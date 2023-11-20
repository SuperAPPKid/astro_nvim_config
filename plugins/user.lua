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
      overrides = function(_) -- add/modify highlights
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
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function() require("codeium").setup() end,
  },

  {
    "freddiehaddad/feline.nvim",
    event = "VeryLazy",
    config = function()
      local line_ok, feline = pcall(require, "feline")
      if not line_ok then return end

      local one_monokai = {
        fg = "#abb2bf",
        bg = "#1e2024",
        green = "#98c379",
        yellow = "#e5c07b",
        purple = "#c678dd",
        orange = "#d19a66",
        peanut = "#f6d5a4",
        red = "#e06c75",
        aqua = "#61afef",
        darkblue = "#282c34",
        dark_red = "#f75f5f",
      }

      local vi_mode_colors = {
        NORMAL = "green",
        OP = "green",
        INSERT = "yellow",
        VISUAL = "purple",
        LINES = "orange",
        BLOCK = "dark_red",
        REPLACE = "red",
        COMMAND = "aqua",
      }

      local c = {
        vim_mode = {
          provider = {
            name = "vi_mode",
            opts = {
              show_mode_name = true,
              -- padding = "center", -- Uncomment for extra padding.
            },
          },
          hl = function()
            return {
              fg = require("feline.providers.vi_mode").get_mode_color(),
              bg = "darkblue",
              style = "bold",
              name = "NeovimModeHLColor",
            }
          end,
          left_sep = "block",
          right_sep = "block",
        },
        gitBranch = {
          provider = "git_branch",
          hl = {
            fg = "peanut",
            bg = "darkblue",
            style = "bold",
          },
          left_sep = "block",
          right_sep = "block",
        },
        gitDiffAdded = {
          provider = "git_diff_added",
          hl = {
            fg = "green",
            bg = "darkblue",
          },
          left_sep = "block",
          right_sep = "block",
        },
        gitDiffRemoved = {
          provider = "git_diff_removed",
          hl = {
            fg = "red",
            bg = "darkblue",
          },
          left_sep = "block",
          right_sep = "block",
        },
        gitDiffChanged = {
          provider = "git_diff_changed",
          hl = {
            fg = "fg",
            bg = "darkblue",
          },
          left_sep = "block",
          right_sep = "right_filled",
        },
        separator = {
          provider = "",
        },
        fileinfo = {
          provider = {
            name = "file_info",
            opts = {
              type = "relative-short",
            },
          },
          hl = {
            style = "bold",
          },
          left_sep = " ",
          right_sep = " ",
        },
        diagnostic_errors = {
          provider = "diagnostic_errors",
          hl = {
            fg = "red",
          },
        },
        diagnostic_warnings = {
          provider = "diagnostic_warnings",
          hl = {
            fg = "yellow",
          },
        },
        diagnostic_hints = {
          provider = "diagnostic_hints",
          hl = {
            fg = "aqua",
          },
        },
        diagnostic_info = {
          provider = "diagnostic_info",
        },
        lsp_client_names = {
          provider = "lsp_client_names",
          hl = {
            fg = "purple",
            bg = "darkblue",
            style = "bold",
          },
          left_sep = "left_filled",
          right_sep = "block",
        },
        file_type = {
          provider = {
            name = "file_type",
            opts = {
              filetype_icon = true,
              case = "titlecase",
            },
          },
          hl = {
            fg = "red",
            bg = "darkblue",
            style = "bold",
          },
          left_sep = "block",
          right_sep = "block",
        },
        file_encoding = {
          provider = "file_encoding",
          hl = {
            fg = "orange",
            bg = "darkblue",
            style = "italic",
          },
          left_sep = "block",
          right_sep = "block",
        },
        position = {
          provider = "position",
          hl = {
            fg = "green",
            bg = "darkblue",
            style = "bold",
          },
          left_sep = "block",
          right_sep = "block",
        },
        line_percentage = {
          provider = "line_percentage",
          hl = {
            fg = "aqua",
            bg = "darkblue",
            style = "bold",
          },
          left_sep = "block",
          right_sep = "block",
        },
        scroll_bar = {
          provider = "scroll_bar",
          hl = {
            fg = "yellow",
            style = "bold",
          },
        },
      }

      local left = {
        c.vim_mode,
        c.gitBranch,
        c.gitDiffAdded,
        c.gitDiffRemoved,
        c.gitDiffChanged,
        c.separator,
      }

      local middle = {
        c.fileinfo,
        c.diagnostic_errors,
        c.diagnostic_warnings,
        c.diagnostic_info,
        c.diagnostic_hints,
      }

      local right = {
        c.lsp_client_names,
        c.file_type,
        c.file_encoding,
        c.position,
        c.line_percentage,
        c.scroll_bar,
      }

      local components = {
        active = {
          left,
          middle,
          right,
        },
        inactive = {
          left,
          middle,
          right,
        },
      }

      feline.setup {
        components = components,
        theme = one_monokai,
        vi_mode_colors = vi_mode_colors,
      }
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-telescope/telescope-dap.nvim" },
    opts = function() require("telescope").load_extension "dap" end,
  },

  {
    "luckasRanarison/nvim-devdocs",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = {
      "DevdocsFetch",
      "DevdocsInstall",
      "DevdocsUninstall",
      "DevdocsOpen",
      "DevdocsOpenFloat",
      "DevdocsUpdate",
      "DevdocsUpdateAll",
    },
    keys = function(_, _)
      local prefix = "<leader>f"
      return {
        { prefix .. "d", "<cmd>DevdocsOpenCurrent<CR>", desc = "Find Devdocs for current file", mode = { "n" } },
        { prefix .. "D", "<cmd>DevdocsOpen<CR>", desc = "Find Devdocs", mode = { "n" } },
      }
    end,
  },
}
