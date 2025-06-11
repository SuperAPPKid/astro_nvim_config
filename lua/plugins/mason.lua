---@type LazySpec
return {
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        border = "double",
      },
    },
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
    opts = {
      auto_update = true,
      ensure_installed = {
        "angular-language-server",
        "blade-formatter",
        "buf",
        "codelldb",
        "dart-debug-adapter",
        "helm-ls",
        "json-lsp",
        "kulala-fmt",
        "lemminx", -- xml
        "marksman", -- markdown
        "nginx-config-formatter",
        "nginx-language-server",
        "prettier",
        "prettierd",
        "rust-analyzer",
        "sonarlint-language-server",
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

        -- web dev
        "biome",
        "eslint-lsp",

        -- yaml
        "yaml-language-server",
        "yamllint",
      },
    },
    specs = {
      -- disable init and ensure installed of other plugins
      {
        "jay-babu/mason-nvim-dap.nvim",
        init = function() end,
        config = function(_, _)
          local providers = require("dap").providers
          providers.configs = {
            [0] = providers.configs["dap.launch.json"],
            [1] = providers.configs["dap.global"],
          }
        end,
      },
    },
  },
}
