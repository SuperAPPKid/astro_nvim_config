---@type LazySpec
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
    "rcarriga/nvim-dap-ui",
    version = false,
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings

          local function open_float(element)
            local params = {
              width = math.floor(vim.o.columns * 0.8),
              enter = true,
            }
            require("dapui").float_element(element, params)
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
    "jbyuki/one-small-step-for-vimkind",
    cmd = {
      "OsvRunThis",
    },
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          opts.commands.OsvRunThis = {
            function(_) require("osv").run_this() end,
            desc = "debug lua script",
          }
        end,
      },
    },
    dependencies = {
      { "mfussenegger/nvim-dap" },
    },
    config = function(_, _)
      local dap = require "dap"
      dap.adapters.nlua = function(callback, config)
        callback {
          type = "server",
          host = config.host,
          port = config.port,
        }
      end
    end,
  },
}
