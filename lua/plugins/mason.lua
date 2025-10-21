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
    "williamboman/mason-lspconfig.nvim",
    version = "^2",
    config = function(_, opts)
      local is_available = require("astrocore").is_available
      if is_available "mason-tool-installer.nvim" then opts.ensure_installed = nil end

      if is_available "astrolsp" then
        if opts.automatic_enable ~= false then
          local _ = require "mason-core.functional"
          local registry = require "mason-registry"
          local mappings = require "mason-lspconfig.mappings"
          local lsp_setup = require("astrolsp").lsp_setup

          local enabled_servers = {}
          if not mason_lsp_setup then
            mason_lsp_setup = vim.schedule_wrap(function(mason_pkg)
              if type(mason_pkg) ~= "string" then mason_pkg = mason_pkg.name end
              local lspconfig_name = mappings.get_mason_map().package_to_lspconfig[mason_pkg]
              if not lspconfig_name or enabled_servers[lspconfig_name] then return end

              local ok, config = pcall(require, "mason-lspconfig.lsp." .. lspconfig_name)
              if ok then vim.lsp.config(lspconfig_name, config) end

              lsp_setup(lspconfig_name)
              enabled_servers[lspconfig_name] = true
            end)
          end

          _.each(mason_lsp_setup, registry.get_installed_package_names())
          registry.refresh(vim.schedule_wrap(function(success, updated_registries)
            if success and #updated_registries > 0 then
              _.each(mason_lsp_setup, registry.get_installed_package_names())
            end
          end))
          registry:off("package:install:success", mason_lsp_setup)
          registry:on("package:install:success", mason_lsp_setup)
        end

        opts.automatic_enable = false
      end

      require("mason-lspconfig").setup(opts)
    end,
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
        "docker-language-server",
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
