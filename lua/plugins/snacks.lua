---@type LazySpec
return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = function(_, opts)
      opts.library =
        require("astrocore").list_insert_unique(opts.library, { { path = "snacks.nvim", words = { "Snacks" } } })
    end,
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    specs = {
      {
        "AstroNvim/astrocore",
        opts = { features = { large_buf = false } } --[[@as AstroCoreOpts]],
      },
    },
    init = function()
      _G.dd = function(...) require("snacks.debug").inspect(...) end
      _G.bt = function() require("snacks.debug").backtrace() end
      _G.p = function(...) require("snacks.debug").profile(...) end
      vim.print = _G.dd
    end,
    dependencies = {
      {
        "MaximilianLloyd/ascii.nvim",
        dependencies = {
          "MunifTanjim/nui.nvim",
        },
        lazy = true,
      },
    },
    config = function(_, opts)
      require("snacks").setup(opts)
      vim.ui.select = Snacks.picker.select
    end,
    opts = function(_, opts)
      opts.bigfile = {}

      opts.input.config = function(input_opts, _) input_opts.icon = "" end

      opts.picker.config = function(picker_opts, _) picker_opts.layouts.select.layout.border = "double" end

      opts.dashboard.config = function(dashboard_opts, _)
        dashboard_opts.enabled = false
        dashboard_opts.preset.header = table.concat(require("ascii").art.text.neovim.delta_corps_priest1, "\n")
      end
    end,
  },
}
