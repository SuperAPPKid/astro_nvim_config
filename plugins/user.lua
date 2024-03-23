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
    {
      "freddiehaddad/feline.nvim",
      event = "UIEnter",
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
      "rebelot/heirline.nvim",
      optional = true,
      opts = function(_, opts) opts.statusline = nil end,
    },
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
    opts = function(_, opts)
      local function is_whitespace(line) return vim.fn.match(line, [[^\s*$]]) ~= -1 end

      local function all(tbl, check)
        for _, entry in ipairs(tbl) do
          if not check(entry) then return false end
        end
        return true
      end

      opts.filter = function(data)
        -- if data.filetype == "spectre_panel" then return false end
        return not all(data.event.regcontents, is_whitespace)
      end
      opts.enable_persistent_history = true
      opts.keys = {
        telescope = {
          i = { paste_behind = false },
        },
      }
    end,
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
    "tiagovla/scope.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    opts = function() require("telescope").load_extension "scope" end,
    keys = {
      {
        "<leader>fb",
        function() require("telescope").extensions.scope.buffers() end,
        desc = "Open Scopes",
      },
    },
    {
      "stevearc/resession.nvim",
      opts = function(_, opts)
        opts.buf_filter = function(bufnr)
          local buftype = vim.bo[bufnr].buftype
          if buftype == "help" then return true end
          if buftype ~= "" and buftype ~= "acwrite" then return false end
          if vim.api.nvim_buf_get_name(bufnr) == "" then return false end
          return true
        end
        opts.extensions = require("astronvim.utils").extend_tbl(opts.extensions, { scope = {} })
      end,
    },
  },

  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {
      animate = { enabled = false },
      exit_when_last = true,
      wo = {
        winhighlight = "",
        winbar = false,
      },
      bottom = {
        {
          ft = "Trouble",
          size = { height = 0.33 },
        },
        {
          ft = "qf",
          size = { height = 0.33 },
          title = "QuickFix",
        },
        {
          ft = "help",
          size = { height = 20 },
          -- don't open help files in edgy that we're editing
          filter = function(buf) return vim.bo[buf].buftype == "help" end,
        },
        {
          ft = "toggleterm",
          size = { height = 0.33 },
          filter = function(buf, _)
            local _, term = require("toggleterm.terminal").identify(vim.api.nvim_buf_get_name(buf))
            if term then return term.direction == "horizontal" end
          end,
        },
      },
      left = {
        {
          ft = "neo-tree",
          size = { width = 48 },
          pinned = true,
          open = "Neotree toggle",
        },
      },
      right = {
        {
          ft = "aerial",
          title = "Symbols",
          size = { width = 52 },
        },
        {
          ft = "spectre_panel",
          title = "Search/Replace",
          size = { width = 64 },
          filter = function(_, win) return vim.api.nvim_win_get_config(win).relative == "" end,
        },
        {
          ft = "toggleterm",
          size = { width = 64 },
          filter = function(buf, _)
            local _, term = require("toggleterm.terminal").identify(vim.api.nvim_buf_get_name(buf))
            if term then return term.direction == "vertical" end
          end,
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
        write_all_buffers = true,
        condition = function(buf)
          local fn = vim.fn

          -- don't save for special-buffers
          if fn.getbufvar(buf, "&buftype") ~= "" then return false end
          return true
        end,
      }
    end,
  },

  {
    "superappkid/projectmgr.nvim",
    event = "VeryLazy",
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
    "superappkid/modes.nvim",
    event = "User AstroFile",
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
    "stevearc/oil.nvim",
    event = "User AstroFile",
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
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
    keys = function(_, _)
      local prefix = "<leader>i"
      local prefix_additive = prefix .. "a"
      local mapping = {}
      mapping[prefix] = {
        desc = "󱓉 incr/decr",
      }
      mapping[prefix_additive] = {
        desc = "󱖢 additive",
      }
      require("astronvim.utils").set_mappings {
        n = mapping,
        x = mapping,
      }

      return {
        -- Visual mode mappings
        {
          prefix .. "i",
          mode = { "v" },
          function() require("dial.map").manipulate("increment", "visual", "visual") end,
          desc = "Increment",
        },
        {
          prefix .. "d",
          mode = { "v" },
          function() require("dial.map").manipulate("decrement", "visual", "visual") end,
          desc = "Decrement",
        },
        {
          prefix_additive .. "i",
          mode = { "v" },
          function() require("dial.map").manipulate("increment", "gvisual", "visual") end,
          desc = "Increment",
        },
        {
          prefix_additive .. "d",
          mode = { "v" },
          function() require("dial.map").manipulate("decrement", "gvisual", "visual") end,
          desc = "Decrement",
        },
        -- Normal mode mappings
        {
          prefix .. "i",
          function() require("dial.map").manipulate("increment", "normal", "normal") end,
          desc = "Increment",
        },
        {
          prefix .. "d",
          function() require("dial.map").manipulate("decrement", "normal", "normal") end,
          desc = "Decrement",
        },
        {
          prefix_additive .. "i",
          function() require("dial.map").manipulate("increment", "gnormal", "normal") end,
          desc = "Increment",
        },
        {
          prefix_additive .. "d",
          function() require("dial.map").manipulate("decrement", "gnormal", "normal") end,
          desc = "Decrement",
        },
      }
    end,
  },

  {
    "rmagatti/goto-preview",
    config = function(_, opts) require("goto-preview").setup(opts) end,
    opts = function(_, opts)
      opts.width = 100
      opts.height = 25
      opts.border = "double"
      opts.stack_floating_preview_windows = false -- Whether to nest floating windows
      opts.preview_window_title = { enable = false }

      local jump_func = function(bufr)
        local function callback()
          local view = vim.fn.winsaveview()
          require("goto-preview").close_all_win { skip_curr_window = false }
          vim.api.nvim_buf_set_option(bufr, "buflisted", true)
          vim.cmd(string.format("buffer %s", vim.fn.fnameescape(vim.api.nvim_buf_get_name(bufr))))
          vim.fn.winrestview(view)
          vim.cmd "normal! m'"
        end

        vim.keymap.set("n", "<CR>", callback, {
          noremap = true,
          silent = true,
          buffer = bufr,
        })
      end

      local tab_func = function(bufr)
        local callback = function()
          local view = vim.fn.winsaveview()
          local f_name = vim.fn.fnameescape(vim.api.nvim_buf_get_name(bufr))

          require("goto-preview").close_all_win { skip_curr_window = false }
          vim.cmd(string.format("tabnew %s", f_name))
          vim.fn.winrestview(view)
          vim.cmd "normal! m'"
        end

        vim.keymap.set("n", "<Tab>", callback, {
          noremap = true,
          silent = true,
          buffer = bufr,
        })
      end

      local close_func = function(bufr)
        local callback = function() require("goto-preview").close_all_win { skip_curr_window = false } end
        vim.keymap.set("n", "q", callback, {
          noremap = true,
          silent = true,
          buffer = bufr,
        })
      end

      local buf_win_pairs = {}
      opts.post_open_hook = function(bufr, win)
        if buf_win_pairs[bufr] then return end

        buf_win_pairs[bufr] = win
        jump_func(bufr)
        tab_func(bufr)
        close_func(bufr)

        local group_id =
          vim.api.nvim_create_augroup(string.format("my-goto-preview_%s_%s", bufr, win), { clear = true })

        vim.api.nvim_create_autocmd("WinClosed", {
          pattern = tostring(win),
          group = group_id,
          callback = function()
            buf_win_pairs[bufr] = nil
            vim.keymap.del("n", "<CR>", { buffer = bufr })
            vim.keymap.del("n", "<Tab>", { buffer = bufr })
            vim.keymap.del("n", "q", { buffer = bufr })
            vim.api.nvim_del_augroup_by_id(group_id)
          end,
        })
      end
      return opts
    end,
  },

  {
    "nyngwang/NeoZoom.lua",
    config = function(_, opts) require("neo-zoom").setup(opts) end,
    opts = {
      exclude_filetypes = { "terminal", "lspinfo", "mason", "lazy", "fzf", "qf" },
      winopts = {
        offset = {
          width = 150,
          height = 0.85,
        },
        border = "rounded", -- this is a preset, try it :)
      },
      presets = {
        {
          filetypes = { "dapui_.*", "dap-repl" },
          winopts = {
            offset = { top = 0.55, left = 0.2, width = 0.75, height = 0.4 },
          },
        },
      },
    },
    keys = {
      {
        "<leader>zz",
        function() vim.cmd "NeoZoomToggle" end,
        desc = "Toggle Zoom",
        { silent = true, nowait = true },
      },
    },
  },

  {
    {
      "rcarriga/nvim-notify",
      config = function(_, opts)
        local notify = require "notify"
        notify.setup(opts)
      end,
    },
    {
      "j-hui/fidget.nvim",
      event = "User AstroFile",
      config = function(_, opts)
        local fidget = require "fidget"
        fidget.setup(opts)
        vim.notify = fidget.notify
      end,
      opts = {
        progress = {
          suppress_on_insert = true, -- Suppress new messages while in insert mode
          ignore_done_already = true, -- Ignore new tasks that are already complete
          ignore_empty_message = true, -- Ignore new tasks that don't contain a message
        },
        notification = {
          -- Conditionally redirect notifications to another backend
          redirect = function(msg, level, opts)
            if type(level) == "number" and level >= vim.log.levels.ERROR then
              return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
            end
          end,
          view = {
            render_message = function(msg, cnt)
              msg = cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
              msg = #msg > 20 and vim.fn.strcharpart(msg, 0, 16) .. "..." or msg -- truncate to 16 characters
              return msg
            end,
          },
          window = {
            max_height = 10,
          },
        },
      },
    },
  },

  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    keys = function()
      return {
        {
          "<leader>zs",
          mode = { "n", "x" },
          function() require("spectre").toggle() end,
          desc = "Search / Replace",
        },
        {
          "<leader>zS",
          mode = { "n", "x" },
          function() require("spectre").open_file_search() end,
          desc = "Search / Replace (current file)",
        },
      }
    end,
    opts = {
      live_update = true, -- auto execute search again when you write to any file in vim
      mapping = {
        toggle_line = { map = "dd" },
        enter_file = { map = "<CR>" },
        send_to_qf = { map = "F" },
        replace_cmd = { map = "c" },
        show_option_menu = { map = "o" },
        run_current_replace = { map = "C" },
        run_replace = { map = "R" },
        change_view_mode = { map = "tv" },
        change_replace_sed = { map = "ts" },
        change_replace_oxi = { map = "to" },
        toggle_live_update = { map = "tu" },
        toggle_ignore_case = { map = "ti" },
        toggle_ignore_hidden = { map = "th" },
        resume_last_search = { map = "<C-r>" },
      },
    },
  },

  {
    "backdround/neowords.nvim",
    keys = function(_, _)
      local neowords = require "neowords"
      local p = neowords.pattern_presets
      local word_hops = neowords.get_word_hops(
        p.hex_color,
        "\\v[-]@![_[:digit:][:lower:][:upper:]\\u0800-\\uffff]+", -- utf-8 words
        "\\V\\[{[(}\\])]\\+", -- brackets {}[]()
        "\\v(``)|(\"\")|''" -- quotes '"
      )

      return {
        {
          "w",
          word_hops.forward_start,
          mode = { "n", "x", "o" },
          desc = "Next word",
        },
        {
          "e",
          word_hops.forward_end,
          mode = { "n", "x", "o" },
          desc = "Next end of word",
        },
        {
          "b",
          word_hops.backward_start,
          mode = { "n", "x", "o" },
          desc = "Previous word",
        },
        {
          "ge",
          word_hops.backward_end,
          mode = { "n", "x", "o" },
          desc = "Previous end of word",
        },
      }
    end,
  },

  {
    "zeioth/garbage-day.nvim",
    dependencies = "neovim/nvim-lspconfig",
    event = "LspAttach",
  },

  {
    "aurum77/live-server.nvim",
    build = function() require("live_server.util").install() end,
    ft = "html",
    keys = {
      {
        "<leader>zh",
        "<cmd>LiveServer<cr>",
        desc = "html preview",
      },
    },
  },

  {
    "echasnovski/mini.surround",
    opts = function(_, _)
      local prefix = "<leader>s"
      local mapping = {}
      mapping[prefix] = {
        desc = "󰅪 Surround",
      }
      require("astronvim.utils").set_mappings {
        n = mapping,
        x = mapping,
      }

      return {
        use_nvim_treesitter = false,
        n_lines = 1500,
        search_method = "cover",
        mappings = {
          add = prefix .. "s", -- Add surrounding in Normal and Visual modes
          delete = prefix .. "d", -- Delete surrounding
          replace = prefix .. "c", -- Replace surrounding

          find = prefix .. "f", -- Find surrounding (to the right)
          find_left = prefix .. "F", -- Find surrounding (to the left)

          highlight = "", -- Highlight surrounding
          update_n_lines = "", -- Update n_lines
          suffix_last = "", -- Suffix to search with "prev" method
          suffix_next = "", -- Suffix to search with "next" method
        },
        silent = true,
      }
    end,
    keys = function(plugin, _)
      local opts = plugin.opts()
      return {
        { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        { opts.mappings.find, desc = "Find right surrounding" },
        { opts.mappings.find_left, desc = "Find left surrounding" },
      }
    end,
  },

  {
    "superappkid/lsp_signature.nvim",
    event = "LspAttach",
    opts = function(_, opts)
      opts.cursorhold_update = false
      opts.doc_lines = 0
      opts.wrap = false
      opts.hint_enable = false
      opts.handler_opts = {
        border = "double", -- double, rounded, single, shadow, none, or a table of borders
      }
    end,
  },

  {
    {
      "rest-nvim/rest.nvim",
      ft = { "http", "json" },
      cmd = {
        "RestNvim",
        "RestNvimPreview",
        "RestNvimLast",
      },
      keys = {
        { "<leader>zr", "<Plug>RestNvim", desc = "Run request" },
      },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        if opts.ensure_installed ~= "all" then
          opts.ensure_installed =
            require("astronvim.utils").list_insert_unique(opts.ensure_installed, { "http", "json" })
        end
      end,
    },
  },

  {
    "amitds1997/remote-nvim.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- For standard functions
      "MunifTanjim/nui.nvim", -- To build the plugin UI
      "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
    },
    cmd = {
      "RemoteStart",
      "RemoteInfo",
      "RemoteCleanup",
      "RemoteConfigDel",
      "RemoteLog",
    },
    config = function(_, opts) require("remote-nvim").setup(opts) end,
    opts = {
      offline_mode = {
        enabled = true,
        no_github = false,
      },
    },
  },

  {
    "uga-rosa/translate.nvim",
    opts = {
      preset = {
        output = {
          floating = {
            border = "double",
          },
        },
      },
    },
    keys = {
      { "<leader>t", "<cmd>Translate ZH-TW<cr>", mode = { "x" }, desc = "Translate" },
    },
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = true,
    keys = function(_, _)
      local harpoon = require "harpoon"

      local prefix = "<leader><leader>"
      require("astronvim.utils").set_mappings {
        n = {
          [prefix] = { desc = "󰐃 Harpoon" },
        },
      }

      return {
        { prefix .. "a", function() harpoon:list():append() end, desc = "Add file" },
        { "<C-p>", function() require("harpoon"):list():prev() end, desc = "Goto previous mark" },
        { "<C-n>", function() require("harpoon"):list():next() end, desc = "Goto next mark" },
        {
          prefix .. "e",
          function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
          desc = "Toggle quick menu",
        },
        {
          "<leader>f<leader>",
          "<cmd>Telescope harpoon marks<CR>",
          desc = "Show marks in Telescope",
        },
      }
    end,
  },

  {
    "andymass/vim-matchup",
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup", fullwidth = 1, highlight = "Normal", syntax_hl = 1 }
      vim.g.matchup_transmute_enabled = 1
      vim.g.matchup_delim_noskips = 2
    end,
  },

  {
    "smjonas/inc-rename.nvim",
    event = "LspAttach",
    config = true,
    opts = {
      input_buffer_type = "dressing",
    },
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npx --yes yarn install",
    init = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" },
    keys = {
      {
        "<leader>zm",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "markdown preview",
      },
    },
  },
}
