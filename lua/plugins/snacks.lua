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
    "superappkid/snacks.nvim",
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
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(items, select_opts, on_choice)
        if
          select_opts
          and select_opts.prompt
          and type(select_opts.prompt) == "string"
          and string.match(select_opts.prompt, [[^You've reached.*limit.*Upgrade.*$]]) -- ...
        then
          vim.notify("Copilot: " .. select_opts.prompt, vim.log.levels.ERROR) --you can also delete this notify
          vim.cmd "Copilot disable"
        else
          return Snacks.picker.select(items, select_opts, on_choice)
        end
      end
    end,
    opts = function(_, opts)
      opts.bigfile = {}

      opts.input.config = function(input_opts, _) input_opts.icon = "" end

      opts.picker.config = function(picker_opts, _) picker_opts.layouts.select.layout.border = "double" end

      opts.dashboard.config = function(dashboard_opts, _)
        dashboard_opts.enabled = false
        dashboard_opts.preset.header = table.concat(require("ascii").art.text.neovim.delta_corps_priest1, "\n")
      end

      local old_indent_filter = opts.indent.filter
      opts.indent.config = function(indent_opts, _)
        indent_opts.indent.char = "│"
        indent_opts.scope.char = "┃"
        indent_opts.filter = function(buf)
          local excluded_filetypes = { "markdown" }
          if vim.tbl_contains(excluded_filetypes, vim.bo[buf].filetype) then return false end
          return old_indent_filter(buf)
        end
      end

      opts.scope.config = function(scope_opts, default)
        if default.keys then scope_opts.keys.textobject = {} end
      end

      opts.styles = {
        notification_history = {
          border = "double",
          minimal = true,
        },
      }
    end,
  },
}
