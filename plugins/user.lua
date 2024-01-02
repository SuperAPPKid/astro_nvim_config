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
      terminalColors = false, -- define vim.g.terminal_color_{0,17}
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
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = {
      require("codeium").setup {},
    },
  },

  {
    "Exafunction/codeium.vim",
    event = "User AstroFile",
    config = function(_, _)
      vim.g.codeium_disable_bindings = 1
      vim.g.codeium_manual = 1
    end,
    keys = function(_, _)
      return {
        {
          "<C-f>",
          function() return vim.fn["codeium#Accept"]() end,
          mode = "i",
          noremap = false,
          expr = true,
        },
        {
          "<A-l>",
          function() return vim.fn["codeium#CycleCompletions"](1) end,
          mode = "i",
          noremap = false,
          expr = true,
        },
        {
          "<A-h>",
          function() return vim.fn["codeium#CycleCompletions"](-1) end,
          mode = "i",
          noremap = false,
          expr = true,
        },
        {
          "<C-x>",
          function() return vim.fn["codeium#Clear"]() end,
          mode = "i",
          noremap = false,
          expr = true,
        },
        {
          "<C-e>",
          function() return vim.fn["codeium#Complete"]() end,
          mode = "i",
          noremap = false,
          expr = true,
        },
      }
    end,
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
              type = "relative",
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

  {
    "AckslD/nvim-neoclip.lua",
    event = "UIEnter",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
      { "kkharji/sqlite.lua", module = "sqlite" },
    },
    opts = {
      enable_persistent_history = true,
    },
    config = function(_, opts)
      require("neoclip").setup(opts)
      require("telescope").load_extension "neoclip"
    end,
    keys = {
      { "<leader>fy", "<cmd>Telescope neoclip<cr>", desc = "Find yanks (neoclip)" },
    },
  },

  {
    "gbprod/yanky.nvim",
    event = "UIEnter",
    opts = function()
      return {
        ring = {
          history_length = 0,
          storage = "memory",
        },
        highlight = { timer = 200 },
      }
    end,
    keys = function(_, _)
      return {
        { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
        { "p", "<Plug>(YankyPutAfter)", mode = { "n" }, desc = "Put yanked text after cursor" },
        { "p", "<Plug>(YankyPutBefore)", mode = { "x" }, desc = "Put yanked text before cursor" },
        { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
        { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
        { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
        { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history" },
        { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle backward through yank history" },
        { "]p", "<Plug>(YankyPutAfterLinewise)", desc = "Put indented after cursor (linewise)" },
        { "[p", "<Plug>(YankyPutBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      }
    end,
  },

  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {
      animate = { enabled = false },
      exit_when_last = true,
      wo = {
        winhighlight = "",
      },
      bottom = {
        { ft = "qf", title = "QuickFix" },
        {
          ft = "help",
          size = { height = 20 },
          -- don't open help files in edgy that we're editing
          filter = function(buf) return vim.bo[buf].buftype == "help" end,
        },
      },
      left = {
        {
          ft = "neo-tree",
          filter = function(buf) return vim.b[buf].neo_tree_source == "filesystem" end,
          pinned = true,
          open = "Neotree position=left filesystem",
        },
      },
      right = {
        {
          ft = "aerial",
          title = "Symbols",
          pinned = true,
          open = function() require("aerial").open() end,
        },
      },
    },
  },

  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle", -- optional for lazy loading on command
    -- event = { "User AstroFile", "InsertEnter" },
    event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
    opts = function(_, _)
      local group = vim.api.nvim_create_augroup("autosave", {})

      vim.api.nvim_create_autocmd("User", {
        pattern = "AutoSaveWritePre",
        group = group,
        callback = function(_)
          -- save global autoformat status
          vim.g.OLD_AUTOFORMAT = vim.g.autoformat_enabled

          vim.g.autoformat_enabled = false
          vim.g.OLD_AUTOFORMAT_BUFFERS = {}
          -- disable all manually enabled buffers
          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.b[bufnr].autoformat_enabled then
              table.insert(vim.g.OLD_BUFFER_AUTOFORMATS, bufnr)
              vim.b[bufnr].autoformat_enabled = false
            end
          end
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "AutoSaveWritePost",
        group = group,
        callback = function(_)
          -- restore global autoformat status
          vim.g.autoformat_enabled = vim.g.OLD_AUTOFORMAT
          -- reenable all manually enabled buffers
          for _, bufnr in ipairs(vim.g.OLD_AUTOFORMAT_BUFFERS or {}) do
            vim.b[bufnr].autoformat_enabled = true
          end
        end,
      })

      return {
        execution_message = {
          enabled = false,
        },
      }
    end,
  },

  {
    "superappkid/projectmgr.nvim",
    event = "VeryLazy",
    lazy = false,
    opts = {
      session = {
        enabled = false,
      },
      scripts = {
        enabled = false,
      },
    },
    keys = {
      { "<leader>fp", "<cmd>ProjectMgr<cr>", desc = "Open ProjectMgr panel" },
    },
  },

  {
    { "folke/which-key.nvim", optional = true, opts = { plugins = { presets = { operators = false } } } },
    {
      "mvllow/modes.nvim",
      event = "VeryLazy",
      opts = {
        line_opacity = 0.3,
        ignore_filetypes = {
          "neo-tree",
          "neo-tree-popup",
          "neo-tree-preview",
          "NvimTree",
          "TelescopePrompt",
        },
      },
    },
  },

  {
    "superappkid/cutlass.nvim",
    lazy = false,
    opts = function(_, opts)
      local utils = require "astronvim.utils"
      opts.cut_key = "m"
      if utils.is_available "leap.nvim" then opts.exclude = utils.list_insert_unique(opts.exclude, { "ns", "nS" }) end
      if utils.is_available "hop.nvim" then opts.exclude = utils.list_insert_unique(opts.exclude, { "ns", "nS" }) end
    end,
  },

  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    event = "User AstroFile",
    config = function(_, opts)
      require("textcase").setup(opts)
      require("telescope").load_extension "textcase"
    end,
    keys = {
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "v" }, desc = "Telescope" },
    },
  },

  {
    "Pocco81/true-zen.nvim",
    opts = function(_, opts)
      local utils = require "astronvim.utils"
      return utils.extend_tbl(opts, {
        integrations = {
          tmux = os.getenv "TMUX" ~= nil, -- hide tmux status bar in (minimalist, ataraxis)
          twilight = utils.is_available "twilight.nvim", -- enable twilight (ataraxis)
        },
      })
    end,
    keys = function(_, _)
      local prefix = "<leader>z"
      return {
        {
          prefix .. "z",
          function() require("true-zen").focus() end,
          desc = "Focus (True Zen)",
        },
        {
          prefix .. "m",
          function() require("true-zen").minimalist() end,
          desc = "Minimalist (True Zen)",
        },
      }
    end,
  },

  {
    "stevearc/oil.nvim",
    event = "User AstroFile",
    opts = {},
    keys = {
      { "<leader>o", function() require("oil").open() end, desc = "Open folder in Oil" },
    },
  },

  {
    "monaqa/dial.nvim",
    event = "User AstroFile",
    config = function()
      local augend = require "dial.augend"
      local general_group = {
        augend.integer.alias.decimal,
        augend.integer.alias.octal,
        augend.integer.alias.hex,
        augend.date.alias["%Y/%m/%d"],
        augend.date.alias["%-m/%-d"],
        augend.date.alias["%Y-%m-%d"],
        augend.date.alias["%Y年%-m月%-d日"],
        augend.date.alias["%Y年%-m月%-d日(%ja)"],
        augend.date.alias["%H:%M:%S"],
        augend.date.alias["%H:%M"],
        augend.constant.alias.ja_weekday,
        augend.constant.alias.ja_weekday_full,
        augend.constant.alias.bool,
        augend.semver.alias.semver,
        augend.misc.alias.markdown_header,
        augend.hexcolor.new {
          case = "lower",
        },
      }
      local visual_group = general_group
      table.insert(
        visual_group,
        augend.case.new {
          types = { "camelCase", "PascalCase", "snake_case", "SCREAMING_SNAKE_CASE" },
        }
      )
      require("dial.config").augends:register_group {
        normal = general_group,
        visual = visual_group,
      }
    end,
    keys = {
      {
        "<leader>i",
        mode = { "n", "v" },
        desc = "incr/decr",
      },
      {
        "<leader>ia",
        mode = { "n", "v" },
        desc = "additive",
      },
      -- Visual mode mappings
      {
        "<leader>i+",
        mode = { "v" },
        function() return require("dial.map").manipulate("increment", "visual", "visual") end,
        desc = "Increment",
      },
      {
        "<leader>i-",
        mode = { "v" },
        function() return require("dial.map").manipulate("decrement", "visual", "visual") end,
        desc = "Decrement",
      },
      {
        "<leader>ia+",
        mode = { "v" },
        function() return require("dial.map").manipulate("increment", "gvisual", "visual") end,
        desc = "Increment",
      },
      {
        "<leader>ia-",
        mode = { "v" },
        function() return require("dial.map").manipulate("decrement", "gvisual", "visual") end,
        desc = "Decrement",
      },
      -- Normal mode mappings
      {
        "<leader>i+",
        function() return require("dial.map").manipulate("increment", "normal", "normal") end,
        desc = "Increment",
      },
      {
        "<leader>i-",
        function() return require("dial.map").manipulate("decrement", "normal", "normal") end,
        desc = "Decrement",
      },
      {
        "<leader>ia+",
        function() return require("dial.map").manipulate("increment", "gnormal", "normal") end,
        desc = "Increment",
      },
      {
        "<leader>ia-",
        function() return require("dial.map").manipulate("decrement", "gnormal", "normal") end,
        desc = "Decrement",
      },
    },
  },

  { import = "user.plugins.tmp" },
}
