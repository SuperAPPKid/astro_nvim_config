-- Customize Mason plugins

---@type LazySpec
return {
  {
    "zapling/mason-lock.nvim",
    lazy = true,
    cmd = {
      "MasonLock",
      "MasonLockRestore",
    },
    dependencies = { "williamboman/mason.nvim" },
    init = function(plugin) require("astrocore").on_load("mason.nvim", plugin.name) end,
    config = true,
  },
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "lua_ls",
        -- add more arguments for adding more language servers
      })
    end,
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "prettier",
        "stylua",
        "golangci-lint",
        -- add more arguments for adding more null-ls sources
      })
    end,
  },
}
