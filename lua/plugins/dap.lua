return {
  {
    "superappkid/nvim-dap-ui",
    version = false,
    opts = function(_, opts)
      opts.expand_lines = false
      opts.layouts = {
        {
          elements = {
            {
              id = "repl",
              size = 1,
            },
          },
          position = "bottom",
          size = 0.5,
        },
      }
      opts.floating.border = "double"
    end,
  },

  -- HACK: Fix AstroNvim redundantly calling `vscode.load_launchjs()`
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        -- overrides `require("mason-nvim-dap").setup(...)`
        config = function(_, opts) end,
        opts = function(_, opts)
          -- add more things to the ensure_installed table protecting against community packs modifying it
          opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
            "python",
            -- add more arguments for adding more debuggers
          })
        end,
      },
    },
    opts = function()
      require("dap").configurations = {}

      local providers = require("dap").providers
      providers.configs = {
        [0] = providers.configs["dap.launch.json"],
        [1] = providers.configs["dap.global"],
      }

      local plugin = require("lazy.core.config").spec.plugins["mason-nvim-dap.nvim"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)

      require("mason-nvim-dap").setup(opts)
    end,
  },
}
