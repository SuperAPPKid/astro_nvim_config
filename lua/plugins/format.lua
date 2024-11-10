local lsp_rooter, prettierrc_rooter

local has_prettier = function(bufnr)
  local function check_json_key_exists(json, ...) return vim.tbl_get(json, ...) ~= nil end
  local function decode_json(filename)
    -- Open the file in read mode
    local file = io.open(filename, "r")
    if not file then
      return false -- File doesn't exist or cannot be opened
    end

    -- Read the contents of the file
    local content = file:read "*all"
    file:close()

    -- Parse the JSON content
    local json_parsed, json = pcall(vim.fn.json_decode, content)
    if not json_parsed or type(json) ~= "table" then
      return false -- Invalid JSON format
    end
    return json
  end

  if type(bufnr) ~= "number" then bufnr = vim.api.nvim_get_current_buf() end
  local rooter = require "astrocore.rooter"
  if not lsp_rooter then
    lsp_rooter = rooter.resolve("lsp", {
      ignore = {
        servers = function(client)
          return not vim.tbl_contains({ "eslint", "ts_ls", "typescript-tools", "volar", "vtsls" }, client.name)
        end,
      },
    })
  end
  if not prettierrc_rooter then
    prettierrc_rooter = rooter.resolve {
      ".prettierrc",
      ".prettierrc.json",
      ".prettierrc.yml",
      ".prettierrc.yaml",
      ".prettierrc.json5",
      ".prettierrc.js",
      ".prettierrc.cjs",
      "prettier.config.js",
      ".prettierrc.mjs",
      "prettier.config.mjs",
      "prettier.config.cjs",
      ".prettierrc.toml",
    }
  end
  local prettier_dependency = false
  for _, root in ipairs(require("astrocore").list_insert_unique(lsp_rooter(bufnr), { vim.fn.getcwd() })) do
    local package_json = decode_json(root .. "/package.json")
    if
      package_json
      and (
        check_json_key_exists(package_json, "dependencies", "prettier")
        or check_json_key_exists(package_json, "devDependencies", "prettier")
      )
    then
      prettier_dependency = true
      break
    end
  end
  return prettier_dependency or next(prettierrc_rooter(bufnr))
end

local conform_formatter = function(bufnr)
  return has_prettier(bufnr) and { "prettierd", "prettier", stop_after_first = true } or {}
end

---@type LazySpec
return {
  {
    "stevearc/conform.nvim",
    event = "User AstroFile",
    specs = {
      {
        "AstroNvim/astrocore",
        opts = {
          options = { opt = { formatexpr = "v:lua.require'conform'.formatexpr()" } },
          commands = {
            Format = {
              function(args)
                local range = nil
                if args.count ~= -1 then
                  local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                  range = {
                    start = { args.line1, 0 },
                    ["end"] = { args.line2, end_line:len() },
                  }
                end
                require("conform").format { async = true, range = range }
              end,
              desc = "Format buffer (conform)",
              range = true,
            },
          },
          mappings = {
            n = {
              ["<Leader>lf"] = { function() vim.cmd.Format() end, desc = "Format buffer (conform)" },
              ["<Leader>uf"] = {
                function()
                  if vim.b.autoformat == nil then
                    if vim.g.autoformat == nil then vim.g.autoformat = true end
                    vim.b.autoformat = vim.g.autoformat
                  end
                  vim.b.autoformat = not vim.b.autoformat
                  require("astrocore").notify(
                    string.format("Buffer autoformatting %s", vim.b.autoformat and "on" or "off")
                  )
                end,
                desc = "Toggle autoformatting (buffer)",
              },
              ["<Leader>uF"] = {
                function()
                  if vim.g.autoformat == nil then vim.g.autoformat = true end
                  vim.g.autoformat = not vim.g.autoformat
                  vim.b.autoformat = nil
                  require("astrocore").notify(
                    string.format("Global autoformatting %s", vim.g.autoformat and "on" or "off")
                  )
                end,
                desc = "Toggle autoformatting (global)",
              },
            },
            v = {
              ["<Leader>lf"] = {
                function()
                  vim.cmd.Format()
                  vim.cmd [[execute "normal! \<Esc>"]]
                end,
                desc = "Format lines (conform)",
              },
            },
          },
        },
      },
    },
    dependencies = {
      "williamboman/mason.nvim",
      { "jay-babu/mason-null-ls.nvim", opts = { methods = { formatting = false } } },
      {
        "AstroNvim/astrolsp",
        opts = {
          formatting = { disabled = true },
          commands = {
            Format = false,
          },
          mappings = {
            n = {
              ["<Leader>lf"] = false,
              ["<Leader>uF"] = false,
              ["<Leader>uf"] = false,
            },
            v = {
              ["<Leader>lf"] = false,
            },
          },
        },
      },
    },
    opts = {
      formatters_by_ft = {
        ["blade"] = { "blade-formatter" },
        ["css"] = conform_formatter,
        ["helm"] = conform_formatter,
        ["html"] = conform_formatter,
        ["go"] = { "goimports", lsp_format = "last" },
        ["javascript"] = conform_formatter,
        ["javascriptreact"] = conform_formatter,
        ["json"] = conform_formatter,
        ["less"] = conform_formatter,
        ["lua"] = { "stylua" },
        ["markdown"] = conform_formatter,
        ["php"] = { "php_cs_fixer" },
        ["postcss"] = conform_formatter,
        ["proto"] = { "buf" },
        ["python"] = { "isort", "black" },
        ["ruby"] = { "standardrb" },
        ["scss"] = conform_formatter,
        ["sh"] = { "shfmt" },
        ["terraform"] = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        ["tf"] = { "terraform_fmt" },
        ["toml"] = { "taplo" },
        ["typescript"] = conform_formatter,
        ["typescriptreact"] = conform_formatter,
        ["yaml"] = conform_formatter,
        ["yaml.ansible"] = conform_formatter,
        ["yaml.docker-compose"] = conform_formatter,
      },
      notify_on_error = false,
      default_format_opts = { lsp_format = "fallback" },
      format_on_save = function(bufnr)
        if vim.g.autoformat == nil then vim.g.autoformat = true end
        local autoformat = vim.b[bufnr].autoformat
        if autoformat == nil then autoformat = vim.g.autoformat end
        if autoformat then
          return {
            timeout_ms = vim.tbl_get(require("astrolsp").config, "formatting", "timeout_ms") or 500,
          }
        end
      end,
    },
  },
}
