---@type LazySpec
return {
  {
    "AstroNvim/astrolsp",
    opts = { servers = { "gdscript" } },
  },

  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require "dap"
      dap.adapters.godot = {
        type = "server",
        host = "127.0.0.1",
        port = vim.env.GDScript_Debug_Port or 6006,
      }
      dap.configurations.gdscript = {
        {
          type = "godot",
          request = "launch",
          name = "Launch scene",
          project = "${workspaceFolder}",
          launch_scene = true,
        },
      }
    end,
  },

  {
    "QuickGD/quickgd.nvim",
    ft = { "gdshader", "gdshaderinc" },
    cmd = { "GodotRun", "GodotRunLast", "GodotStart" },
    dependencies = {
      { "hrsh7th/nvim-cmp" },
    },
    opts = function(_, opts)
      local is_available = require("astrocore").is_available
      if is_available "nvim-cmp" then
        opts.cmp = true
        local cmp = require "cmp"
        local sources = require("astrocore").list_insert_unique(
          require("cmp.config").global.sources,
          { { name = "quickgd", priority = 750 } }
        )
        dd(sources)
        cmp.setup.filetype({ "gdshader", "gdshaderinc" }, { sources = sources })
      end
      opts.telescope = is_available "telescope.nvim"
      opts.treesitter = is_available "nvim-treesitter"
    end,
  },
}
