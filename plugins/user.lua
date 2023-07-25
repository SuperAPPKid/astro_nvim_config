return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax

  {
    "rebelot/kanagawa.nvim",
    opts = {
      compile = false, -- enable compiling the colorscheme
      undercurl = true, -- enable undercurls
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false, -- do not set background color
      dimInactive = false, -- dim inactive window `:h hl-NormalNC`
      terminalColors = true, -- define vim.g.terminal_color_{0,17}
      colors = { -- add/modify theme and palette colors
        palette = {},
        theme = {
          wave = {},
          lotus = {},
          dragon = {
            ui = {
              bg = "#1F1F28",
            },
          },
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
      overrides = function(colors) -- add/modify highlights
        return {}
      end,
      theme = "dragon", -- Load "wave" theme when 'background' option is not set
      background = { -- map the value of 'background' option to a theme
        dark = "dragon", -- try "dragon" !
        light = "lotus",
      },
    },
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = {
        format = {
          cmdline = { icon = ">" },
          search_down = { icon = "" },
          search_up = { icon = "" },
          filter = { icon = "$" },
          lua = { icon = "" },
          help = { icon = "?" },
        },
      },
      messages = {
        view_search = false,
      },
      format = {
        level = {
          icons = {
            error = "✖",
            warn = "▼",
            info = "●",
          },
        },
      },
      inc_rename = {
        cmdline = {
          format = {
            IncRename = { icon = "⟳" },
          },
        },
      },
      lsp = {
        hover = {
          enabled = false,
        },
        signature = {
          enabled = false,
        },
      },
      presets = {
        bottom_search = false,
        command_palette = false,
        long_message_to_split = true,
        inc_rename = true,
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
        {
          filter = {
            cmdline = true,
            error = false,
            warning = false,
          },
          view = "popup",
        },
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },

  { "MunifTanjim/nui.nvim" },

  {
    "petertriho/nvim-scrollbar",
    event = { "BufReadPre", "BufAdd", "BufNew", "BufReadPost" },
    config = function()
      local colors = {
        red = "#ea6962",
        orange = "#e78a4e",
        yellow = "#d8a657",
        green = "#a9b665",
        blue = "#7daea3",
      }

      require("scrollbar").setup {
        throttle_ms = 0,
        excluded_filetypes = {
          "cmp_docs",
          "cmp_menu",
          "noice",
          "prompt",
          "TelescopePrompt",
          "lazy",
          "aerial",
        },
        handle = {
          text = "   ",
          blend = 0,
          color = "#666666",
        },
        marks = {
          Search = {
            text = { "———", "———" },
            color = colors.yellow,
          },
          Error = {
            text = { "———", "———" },
            color = colors.red,
          },
          Warn = {
            text = { "———", "———" },
            color = colors.orange,
          },
          Info = {
            text = { "———", "———" },
            color = colors.green,
          },
          Hint = {
            text = { "———", "———" },
            color = colors.green,
          },
          Misc = {
            text = { "———", "———" },
            color = colors.green,
          },
          GitAdd = {
            text = "  ┆",
            color = colors.green,
          },
          GitChange = {
            text = "  ┆",
            color = colors.blue,
          },
          GitDelete = {
            text = "  ┆",
            color = colors.red,
          },
        },
        handlers = {
          cursor = false,
          gitsigns = true,
          search = false,
        },
      }
    end,
  },

  {
    "jcdickinson/codeium.nvim",
    commit = "b1ff0d6c993e3d87a4362d2ccd6c660f7444599f",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function() require("codeium").setup() end,
  },
}
