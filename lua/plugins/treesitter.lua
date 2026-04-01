-- Customize Treesitter

---@type LazySpec
---@diagnostic disable: inject-field, missing-fields
return {
  {
    "sustech-data/wildfire.nvim",
    lazy = true,
    init = function(plugin) require("astrocore").on_load("nvim-treesitter", plugin.name) end,
    config = true,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-context",
        cmd = "TSContext",
        opts = {
          max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
          multiline_threshold = 1, -- Maximum number of lines to show for a single context
          separator = "-",
        },
      },
    },
    keys = function(_, keys)
      table.insert(keys, {
        "[C",
        function() require("treesitter-context").go_to_context() end,
        desc = "Jumping to context",
        silent = true,
      })
      return keys
    end,
    opts = function(_, opts)
      vim.api.nvim_create_autocmd("User", {
        pattern = "TSUpdate",
        callback = function()
          local parsers = require "nvim-treesitter.parsers"
          parsers.go = {
            install_info = {
              url = "https://github.com/superappkid/tree-sitter-go",
              files = { "src/parser.c" },
              revision = "7444f1535e3ec32e7bf8b063b42201c0ef7e6097",
            },
            branch = "master",
          }
          parsers.blade.filetype = "blade"
        end,
      })

      vim.treesitter.language.register("bash", "dotenv")
      vim.treesitter.language.register("scss", "less")
      vim.treesitter.language.register("scss", "postcss")
      vim.treesitter.language.register("gomod", "gowork")
      return opts
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    opts = {
      select = { enable = true },
    },
  },
}
