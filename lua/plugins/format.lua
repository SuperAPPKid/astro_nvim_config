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
              ["<Leader>lc"] = { function() vim.cmd.ConformInfo() end, desc = "Conform information" },
              ["<Leader>uf"] = {
                function()
                  vim.b.autoformat = not vim.F.if_nil(vim.b.autoformat, vim.g.autoformat, true)
                  require("astrocore").notify(
                    string.format("Buffer autoformatting %s", vim.b.autoformat and "on" or "off")
                  )
                end,
                desc = "Toggle autoformatting (buffer)",
              },
              ["<Leader>uF"] = {
                function()
                  vim.g.autoformat, vim.b.autoformat = not vim.F.if_nil(vim.g.autoformat, true), nil
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
      "mason-org/mason.nvim",
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
        ["astro"] = { "biome" },
        ["blade"] = { "blade-formatter" },
        ["cs"] = { "csharpier" },
        ["css"] = { "biome" },
        ["helm"] = { "prettierd", "prettier", stop_after_first = true },
        ["html"] = { "prettierd", "prettier", stop_after_first = true },
        -- ["http"] = { "kulala-fmt" }, INFO: wait kulala-fmt fix issue: https://github.com/mistweaverco/kulala-fmt/issues/52
        ["go"] = { "goimports", lsp_format = "last" },
        ["graphql"] = { "biome" },
        ["javascript"] = { "biome" },
        ["javascriptreact"] = { "biome" },
        ["json"] = { "biome" },
        ["jsonc"] = { "biome" },
        ["less"] = { "prettierd", "prettier", stop_after_first = true },
        ["lua"] = { "stylua" },
        ["markdown"] = { "prettierd", "prettier", stop_after_first = true },
        ["nginx"] = { "nginxfmt" },
        ["php"] = { "php_cs_fixer", "pint" },
        ["postcss"] = { "prettierd", "prettier", stop_after_first = true },
        ["proto"] = { "buf" },
        ["python"] = { "isort", "black" },
        ["ruby"] = { "standardrb" },
        ["scss"] = { "prettierd", "prettier", stop_after_first = true },
        ["sh"] = { "shfmt", "shellcheck" },
        ["sql"] = { "sqlfluff" },
        ["svelte"] = { "biome" },
        ["terraform"] = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        ["tf"] = { "terraform_fmt" },
        ["toml"] = { "taplo" },
        ["typescript"] = { "biome" },
        ["typescriptreact"] = { "biome" },
        ["vue"] = { "biome" },
        ["yaml"] = { "prettierd", "prettier", stop_after_first = true },
        ["yaml.ansible"] = { "prettierd", "prettier", stop_after_first = true },
        ["yaml.docker-compose"] = { "prettierd", "prettier", stop_after_first = true },
      },
      notify_on_error = false,
      default_format_opts = { lsp_format = "fallback" },
      format_on_save = function(bufnr)
        if vim.F.if_nil(vim.b[bufnr].autoformat, vim.g.autoformat, true) then
          return { timeout_ms = 1000, lsp_format = "fallback" }
        end
      end,
      formatters = {
        sqlfluff = {
          args = {
            "format",
            "-n",
            "-d",
            "ansi",
            "--disable-progress-bar",
            "--stdin-filename",
            "$FILENAME",
            "-",
          },
          require_cwd = false,
        },
      },
    },
  },
}
