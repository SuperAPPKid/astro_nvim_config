return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "nvim-telescope/telescope-dap.nvim",
        dependencies = {
          { "nvim-telescope/telescope.nvim" },
        },
        config = function(_, _) require("telescope").load_extension "dap" end,
      },
      {
        "LiadOz/nvim-dap-repl-highlights",
        dependencies = {
          {
            "nvim-treesitter/nvim-treesitter",
            opts = function(_, opts)
              if opts.ensure_installed ~= "all" then
                opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "dap_repl" })
              end
            end,
          },
        },
      },
    },
  },

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

  {
    "jay-babu/mason-nvim-dap.nvim",
    config = function(_, opts)
      local providers = require("dap").providers
      providers.configs = {
        [0] = providers.configs["dap.launch.json"],
        [1] = providers.configs["dap.global"],
      }

      require("mason-nvim-dap").setup(opts)
    end,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        -- add more arguments for adding more debuggers
      })
    end,
  },
}
