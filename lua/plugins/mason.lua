-- helper function to setup a plugin without an `ensure_installed` table
local setup_without_ensure_installed = function(main, opts)
  opts = vim.deepcopy(opts)
  opts.ensure_installed = nil
  require(main).setup(opts)
end

---@type LazySpec
return {
  {
    "mason-org/mason.nvim",
    version = "^1.0.0",
    opts = {
      ui = {
        border = "double",
      },
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    version = "^1.0.0",
  },

  {
    "zapling/mason-lock.nvim",
    lazy = true,
    cmd = {
      "MasonLock",
      "MasonLockRestore",
    },
    dependencies = { "mason-org/mason.nvim" },
    init = function(plugin) require("astrocore").on_load("mason.nvim", plugin.name) end,
    config = true,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    cmd = {
      "MasonToolsInstall",
      "MasonToolsInstallSync",
      "MasonToolsUpdate",
      "MasonToolsUpdateSync",
      "MasonToolsClean",
    },
    dependencies = { "mason-org/mason.nvim" },
    init = function(plugin) require("astrocore").on_load("mason.nvim", plugin.name) end,
    opts_extend = { "ensure_installed" },
    opts = {
      auto_update = true,
      ensure_installed = {
        "angular-language-server",
        "blade-formatter",
        "codelldb",
        "dart-debug-adapter",
        "helm-ls",
        "json-lsp",
        "lemminx", -- xml
        "marksman", -- markdown
        "nginx-language-server",
        "prettier",
        "prettierd",
        "rust-analyzer",
        "svelte-language-server",
        "taplo", -- toml
        "tailwindcss-language-server",
        "vue-language-server",

        -- ansible
        "ansible-lint",
        "ansible-language-server",

        -- bash
        "bash-language-server",
        "shellcheck",
        "shfmt",
        "bash-debug-adapter",

        "buf",

        -- csharp
        "omnisharp",
        "csharpier",
        "netcoredbg",

        -- docker
        "docker-compose-language-service",
        "dockerfile-language-server",
        "hadolint",

        -- go
        "delve",
        "goimports",
        "golangci-lint",
        "gopls",
        "gotests",
        "gomodifytags",
        "iferr",
        "impl",
        "templ",

        -- html
        "html-lsp",
        "css-lsp",
        "emmet-ls",

        -- java
        "java-debug-adapter",
        { "java-test", auto_update = false },
        "jdtls",

        -- kotlin
        "kotlin-language-server",
        "ktlint",
        "kotlin-debug-adapter",

        -- lua
        "lua-language-server",
        "stylua",

        -- php
        "phpactor",
        "php-debug-adapter",
        "php-cs-fixer",

        -- python
        "basedpyright",
        "black",
        "debugpy",
        "isort",

        -- ruby
        "solargraph",
        "standardrb",

        -- sql
        "sqlfluff",

        -- terraform
        "terraform-ls",
        "tflint",
        "tfsec",

        -- typescript
        "deno",
        "eslint-lsp",
        "js-debug-adapter",
        "vtsls",

        -- yaml
        "yaml-language-server",
        "yamllint",
      },
      integrations = { ["mason-lspconfig"] = false, ["mason-null-ls"] = false, ["mason-nvim-dap"] = false },
    },
    config = function(_, opts)
      local mason_tool_installer = require "mason-tool-installer"
      mason_tool_installer.setup(opts)
      if opts.run_on_start ~= false then mason_tool_installer.run_on_start() end
    end,
    specs = {
      -- disable init and ensure installed of other plugins
      {
        "jay-babu/mason-nvim-dap.nvim",
        init = function() end,
        config = function(_, opts)
          local providers = require("dap").providers
          providers.configs = {
            [0] = providers.configs["dap.launch.json"],
            [1] = providers.configs["dap.global"],
          }

          setup_without_ensure_installed("mason-nvim-dap", opts)
        end,
      },
      {
        "mason-org/mason-lspconfig.nvim",
        init = function() end,
        config = function(_, opts) setup_without_ensure_installed("mason-lspconfig", opts) end,
      },
      {
        "jay-babu/mason-null-ls.nvim",
        init = function() end,
        config = function(_, opts) setup_without_ensure_installed("mason-null-ls", opts) end,
      },
    },
  },
}
