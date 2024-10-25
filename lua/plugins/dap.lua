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
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
          { "LiadOz/nvim-dap-repl-highlights", config = true },
        },
        opts = function(_, opts)
          if opts.ensure_installed ~= "all" then
            opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "dap_repl" })
          end
        end,
      },
    },
  },

  {
    "superappkid/nvim-dap-ui",
    version = false,
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings

          local function open_float(element)
            require("dapui").float_element(element, {
              width = math.floor(vim.o.columns * 0.8),
              enter = true,
            })
          end

          maps.n["<Leader>dR"] = false
          maps.n["<Leader>du"] = { function() require("dapui").toggle() end, desc = "Toggle REPL" }
          maps.n["<Leader>dh"] = { function() require("dap.ui.widgets").hover() end, desc = "Debugger Hover" }
          maps.n["<Leader>dH"] = { function() open_float "scopes" end, desc = "Open Scopes" }
          maps.n["<Leader>dB"] = { function() open_float "breakpoints" end, desc = "Open Breakpoints" }
          maps.n["<Leader>dd"] = { function() require("dap").clear_breakpoints() end, desc = "Clear Breakpoints" }
          maps.n["<Leader>dS"] = { function() open_float "stacks" end, desc = "Open Stacks" }
          maps.n["<Leader>dw"] = { function() open_float "watches" end, desc = "Open Watches" }
        end,
      },
    },
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
