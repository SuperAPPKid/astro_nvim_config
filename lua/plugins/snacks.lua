---@type LazySpec
return {
  {
    "folke/lazydev.nvim",
    dependencies = {
      "saghen/blink.cmp",
      opts = {
        sources = {
          per_filetype = {
            lua = { inherit_defaults = true, "lazydev" },
          },
          providers = {
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
            },
          },
        },
      },
    },
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
      local get_icon = require("astroui").get_icon

      opts.bigfile = {
        enabled = true,
        notify = true,
        size = 1.5 * 1024 * 1024, -- 1.5MB
        line_length = 3000,
        ---@param ctx {buf: number, ft:string}
        setup = function(ctx)
          if vim.fn.exists ":MatchParenDisable" ~= 0 then vim.cmd [[MatchParenDisable]] end
          vim.opt_local.swapfile = false
          vim.opt_local.foldmethod = "manual"
          vim.opt_local.undolevels = -1
          vim.opt_local.undoreload = 0
          vim.opt_local.list = false
          vim.cmd "syntax clear"
          vim.opt_local.syntax = "off"
          vim.opt_local.filetype = ""
          vim.diagnostic.enable(false)
          if vim.fn.exists ":VimadeDisable" ~= 0 then vim.cmd [[VimadeDisable]] end
          vim.cmd "TSDisable highlight"
          vim.cmd "TSDisable incremental_selection"
          vim.cmd "TSDisable indent"
          vim.cmd "TSDisable textobjects.lsp_interop"
          vim.cmd "TSDisable textobjects.move"
          vim.cmd "TSDisable textobjects.select"
          vim.cmd "TSDisable textobjects.swap"
          require("lualine").hide()
          for _, client in pairs(vim.lsp.get_clients()) do
            client.stop()
          end
          vim.api.nvim_create_autocmd({ "LspAttach" }, {
            buffer = buf,
            callback = function(args)
              vim.schedule(function() vim.lsp.buf_detach_client(buf, args.data.client_id) end)
            end,
          })
          local ok, blink_cmp = pcall(require, "blink.cmp")
          if ok then
            blink_cmp.hide()
            blink_cmp.cancel()
          end
          vim.api.nvim_buf_set_option(0, "omnifunc", "")
          Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
          vim.b.minianimate_disable = true
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(ctx.buf) then vim.bo[ctx.buf].syntax = ctx.ft end
          end)
        end,
      }

      opts.input.config = function(input_opts, _) input_opts.icon = "" end

      opts.picker.config = function(picker_opts, _) picker_opts.layouts.select.layout.border = "double" end

      opts.dashboard.config = function(dashboard_opts, _)
        dashboard_opts.enabled = false
        dashboard_opts.preset = {
          keys = function()
            return {
              {
                text = {
                  { "           " .. "" .. "  ", hl = "SnacksDashboardIcon" },
                  { "new file", hl = "SnacksDashboardDesc", width = 45 },
                  { "░▒▓", hl = "SnacksDashboardFade" },
                  { " i ", hl = "SnacksDashboardKey" },
                  { "▓▒░", hl = "SnacksDashboardFade" },
                },
                action = "<Leader>n",
                key = "n",
              },
              {
                text = {
                  { "           " .. "" .. "  ", hl = "SnacksDashboardIcon" },
                  { "old files", hl = "SnacksDashboardDesc", width = 45 },
                  { "░▒▓", hl = "SnacksDashboardFade" },
                  { " o ", hl = "SnacksDashboardKey" },
                  { "▓▒░", hl = "SnacksDashboardFade" },
                },
                action = "<Leader>fo",
                key = "o",
              },
              {
                text = {
                  { "           " .. "" .. "  ", hl = "SnacksDashboardIcon" },
                  { "browse cwd", hl = "SnacksDashboardDesc", width = 45 },
                  { "░▒▓", hl = "SnacksDashboardFade" },
                  { " b ", hl = "SnacksDashboardKey" },
                  { "▓▒░", hl = "SnacksDashboardFade" },
                },
                action = "<Leader>fE",
                key = "b",
              },
              {
                text = {
                  { "           " .. get_icon("Search", 0, true) .. "  ", hl = "SnacksDashboardIcon" },
                  { "find file", hl = "SnacksDashboardDesc", width = 45 },
                  { "░▒▓", hl = "SnacksDashboardFade" },
                  { " f ", hl = "SnacksDashboardKey" },
                  { "▓▒░", hl = "SnacksDashboardFade" },
                },
                action = "<Leader>fF",
                key = "f",
              },
              {
                text = {
                  { "           " .. "" .. "  ", hl = "SnacksDashboardIcon" },
                  { "find text", hl = "SnacksDashboardDesc", width = 45 },
                  { "░▒▓", hl = "SnacksDashboardFade" },
                  { " w ", hl = "SnacksDashboardKey" },
                  { "▓▒░", hl = "SnacksDashboardFade" },
                },
                action = "<Leader>fW",
                key = "w",
              },
              {
                text = {
                  { "           " .. get_icon("GitBranch", 0, true) .. "  ", hl = "SnacksDashboardIcon" },
                  { "browse git", hl = "SnacksDashboardDesc", width = 45 },
                  { "░▒▓", hl = "SnacksDashboardFade" },
                  { " g ", hl = "SnacksDashboardKey" },
                  { "▓▒░", hl = "SnacksDashboardFade" },
                },
                action = "<Leader>gg",
                key = "g",
              },
              {
                text = {
                  { "           " .. "󰒲" .. "  ", hl = "SnacksDashboardIcon" },
                  { "lazy", hl = "SnacksDashboardDesc", width = 45 },
                  { "░▒▓", hl = "SnacksDashboardFade" },
                  { " l ", hl = "SnacksDashboardKey" },
                  { "▓▒░", hl = "SnacksDashboardFade" },
                },
                action = "<Leader>ps",
                key = "l",
              },
              {
                text = {
                  { "           " .. "󱊍" .. "  ", hl = "SnacksDashboardIcon" },
                  { "mason", hl = "SnacksDashboardDesc", width = 45 },
                  { "░▒▓", hl = "SnacksDashboardFade" },
                  { " m ", hl = "SnacksDashboardKey" },
                  { "▓▒░", hl = "SnacksDashboardFade" },
                },
                action = "<Leader>pm",
                key = "m",
              },
              {
                text = {
                  { "           " .. get_icon("Refresh", 0, true) .. "  ", hl = "SnacksDashboardIcon" },
                  { "session", hl = "SnacksDashboardDesc", width = 45 },
                  { "░▒▓", hl = "SnacksDashboardFade" },
                  { " s ", hl = "SnacksDashboardKey" },
                  { "▓▒░", hl = "SnacksDashboardFade" },
                },
                action = "<Leader>Sf",
                key = "s",
              },
            }
          end,
        }
        dashboard_opts.sections = {
          {
            section = "terminal",
            cmd = vim.fn.stdpath "config" .. "/nvim-logo -e",
            height = 10,
            width = 70,
            padding = 1,
          },
          {
            section = "keys",
            gap = 0,
            padding = 2,
          },
          {
            section = "startup",
          },
        }
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
