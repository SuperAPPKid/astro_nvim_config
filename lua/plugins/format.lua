local prettier_formatter = { "prettierd", "prettier", stop_after_first = true }

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
        ["css"] = prettier_formatter,
        ["helm"] = prettier_formatter,
        ["html"] = prettier_formatter,
        ["go"] = { "goimports", lsp_format = "last" },
        ["javascript"] = prettier_formatter,
        ["javascriptreact"] = prettier_formatter,
        ["json"] = prettier_formatter,
        ["less"] = prettier_formatter,
        ["lua"] = { "stylua" },
        ["markdown"] = prettier_formatter,
        ["php"] = { "php_cs_fixer" },
        ["postcss"] = prettier_formatter,
        ["proto"] = { "buf" },
        ["python"] = { "isort", "black" },
        ["ruby"] = { "standardrb" },
        ["scss"] = prettier_formatter,
        ["sh"] = { "shfmt" },
        ["terraform"] = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        ["tf"] = { "terraform_fmt" },
        ["toml"] = { "taplo" },
        ["typescript"] = prettier_formatter,
        ["typescriptreact"] = prettier_formatter,
        ["yaml"] = prettier_formatter,
        ["yaml.ansible"] = prettier_formatter,
        ["yaml.docker-compose"] = prettier_formatter,
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
