return {
  -- customize alpha options
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
      { "<Leader>fy", "<cmd>Telescope neoclip<cr>", desc = "Find yanks (neoclip)" },
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
    "stevearc/resession.nvim",
    lazy = false,
    dependencies = {
      {
        "tiagovla/scope.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        opts = function() require("telescope").load_extension "scope" end,
      },
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>fb"] = {
            function() require("telescope").extensions.scope.buffers() end,
            desc = "Open Scopes",
          }
        end,
      },
    },
    opts = function(_, opts)
      opts.buf_filter = function(bufnr)
        local buftype = vim.bo[bufnr].buftype
        if buftype == "help" then return true end
        if buftype ~= "" and buftype ~= "acwrite" then return false end
        if vim.api.nvim_buf_get_name(bufnr) == "" then return false end
        return true
      end
      opts.extensions = require("astrocore").extend_tbl(opts.extensions, { scope = {} })
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
          size = { width = 52 },
        },
        {
          ft = "sagaoutline",
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
          vim.g.OLD_AUTOFORMAT = vim.g.autoformat

          vim.g.autoformat = false
          vim.g.OLD_AUTOFORMAT_BUFFERS = {}
          -- disable all manually enabled buffers
          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.b[bufnr].autoformat then
              vim.g.OLD_AUTOFORMAT_BUFFERS =
                require("astrocore").list_insert_unique(vim.g.OLD_AUTOFORMAT_BUFFERS, { bufnr })
              vim.b[bufnr].autoformat = false
            end
          end
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "AutoSaveWritePost",
        group = group,
        callback = function(_)
          -- restore global autoformat status
          vim.g.autoformat = vim.g.OLD_AUTOFORMAT
          -- reenable all manually enabled buffers
          for _, bufnr in ipairs(vim.g.OLD_AUTOFORMAT_BUFFERS or {}) do
            vim.b[bufnr].autoformat = true
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
      { "<Leader>fp", "<cmd>ProjectMgr<cr>", desc = "Open ProjectMgr panel" },
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
      local core = require "astrocore"
      opts.cut_key = "m"
      if core.is_available "leap.nvim" or core.is_available "hop.nvim" then
        opts.exclude = core.list_insert_unique(opts.exclude, { "ns", "nS" })
      end
    end,
  },

  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    event = "User AstroFile",
    config = function(_, opts)
      local prefix = "<Leader>k"

      opts.prefix = prefix
      require("textcase").setup(opts)
      require("telescope").load_extension "textcase"

      local mapping = {}
      mapping[prefix] = {
        desc = " TextCase",
      }
      mapping[prefix .. "<Leader>"] = {
        "<cmd>TextCaseOpenTelescope<CR>",
        desc = "Telescope",
      }
      require("astrocore").set_mappings {
        n = mapping,
        x = mapping,
      }
    end,
  },

  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<Leader>o"] = { function() require("oil").open() end, desc = "Open folder in Oil" },
            },
          },
          autocmds = {
            oil_settings = {
              {
                event = "FileType",
                desc = "Disable view saving for oil buffers",
                pattern = "oil",
                callback = function(args) vim.b[args.buf].view_activated = false end,
              },
              {
                event = "User",
                pattern = "OilActionsPost",
                desc = "Close buffers when files are deleted in Oil",
                callback = function(args)
                  if args.data.err then return end
                  for _, action in ipairs(args.data.actions) do
                    if action.type == "delete" then
                      local _, path = require("oil.util").parse_url(action.url)
                      local bufnr = vim.fn.bufnr(path)
                      if bufnr ~= -1 then require("astrocore.buffer").wipe(bufnr, true) end
                    end
                  end
                end,
              },
              {
                event = "VimEnter",
                desc = "Start Oil when vim is opened with no arguments",
                group = vim.api.nvim_create_augroup("oil_autostart", { clear = true }),
                callback = vim.schedule_wrap(function()
                  local should_skip = false
                  local lines = vim.api.nvim_buf_get_lines(0, 0, 2, false)
                  if
                    #lines > 1 -- don't open if current buffer has more than 1 line
                    or (#lines == 1 and lines[1]:len() > 0) -- don't open the current buffer if it has anything on the first line
                    or #vim.tbl_filter(function(bufnr) return vim.bo[bufnr].buflisted end, vim.api.nvim_list_bufs()) > 1 -- don't open if any listed buffers
                    or not vim.o.modifiable -- don't open if not modifiable
                  then
                    should_skip = true
                  end

                  local dir
                  local argc = vim.fn.argc()
                  if not should_skip and argc > 0 then
                    local opened = vim.fn.expand "%:p"
                    local stat = vim.loop.fs_stat(opened)
                    if stat and stat.type == "directory" then dir = opened end
                    for _, arg in pairs(vim.v.argv) do
                      if arg == "-b" or arg == "-c" or vim.startswith(arg, "+") or arg == "-S" then
                        should_skip = true
                        break
                      end
                    end

                    if not dir then should_skip = true end
                  end

                  if not should_skip then require("oil").open(dir) end
                end),
              },
            },
          },
        },
      },
    },
    opts = function(_, opts)
      local get_icon = require("astroui").get_icon
      opts.columns = { { "icon", default_file = get_icon "DefaultFile", directory = get_icon "FolderClosed" } }
      opts.view_options = {
        show_hidden = true,
      }
    end,
  },

  {
    "monaqa/dial.nvim",
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
      local prefix = "<Leader>i"
      local prefix_additive = prefix .. "a"
      local mapping = {}
      mapping[prefix] = {
        desc = "󱓉 incr/decr",
      }
      mapping[prefix_additive] = {
        desc = "󱖢 additive",
      }
      require("astrocore").set_mappings {
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
    "nyngwang/NeoZoom.lua",
    config = function(_, opts) require("neo-zoom").setup(opts) end,
    opts = {
      exclude_filetypes = { "dapui_.*", "dap-repl", "terminal", "lspinfo", "mason", "lazy", "fzf", "qf" },
      winopts = {
        offset = {
          top = 1,
          width = vim.o.columns,
          height = vim.o.lines - 4,
        },
        border = "thicc", -- this is a preset, try it :)
      },
      presets = {},
    },
    keys = {
      {
        "<Leader>zz",
        function() vim.cmd "NeoZoomToggle" end,
        desc = "Toggle Zoom",
        { silent = true, nowait = true },
      },
    },
  },

  {
    "j-hui/fidget.nvim",
    specs = {
      {
        "rcarriga/nvim-notify",
        config = function(_, opts)
          local notify = require "notify"
          notify.setup(opts)
        end,
        opts = {
          max_width = 36,
        },
      },
    },
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>zn"] = {
            "<cmd>Fidget history<CR>",
            desc = "fidget history",
          }
        end,
      },
    },
    event = "User AstroFile",
    config = function(_, opts)
      local fidget = require "fidget"
      fidget.setup(opts)
      vim.notify = fidget.notify
    end,
    opts = function(_, _)
      require "fidget"
      return {
        progress = {
          suppress_on_insert = true, -- Suppress new messages while in insert mode
          ignore_done_already = true, -- Ignore new tasks that are already complete
          ignore_empty_message = true, -- Ignore new tasks that don't contain a message
        },
        notification = {
          configs = {
            default = require("astrocore").extend_tbl(require("fidget.notification").default_config, {
              icon = "󱅫",
              icon_on_left = true,
            }),
          },
          -- Conditionally redirect notifications to another backend
          redirect = function(msg, level, opts)
            if
              (type(level) == "number" and level >= vim.log.levels.ERROR)
              or (opts and opts.title and string.find(opts.title, "tinygit"))
            then
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
            winblend = 50,
          },
        },
      }
    end,
  },

  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    keys = function()
      return {
        {
          "<Leader>zs",
          mode = { "n", "x" },
          function() require("spectre").toggle() end,
          desc = "Search / Replace",
        },
        {
          "<Leader>zS",
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
        "\\v[-]@![[:digit:][:lower:][:upper:]\\u0800-\\uffff]+", -- utf-8 words
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
    "aurum77/live-server.nvim",
    build = function() require("live_server.util").install() end,
    ft = "html",
    keys = {
      {
        "<Leader>zh",
        "<cmd>LiveServer<cr>",
        desc = "html preview",
      },
    },
  },

  {
    "echasnovski/mini.surround",
    opts = function(_, _)
      local prefix = "<Leader>s"
      local mapping = {}
      mapping[prefix] = {
        desc = "󰅪 Surround",
      }
      require("astrocore").set_mappings {
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
      { "<Leader>t", "<cmd>Translate ZH-TW<cr>", mode = { "x" }, desc = "Translate" },
    },
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function(_, opts)
      local harpoon = require "harpoon"
      harpoon:setup(opts)
    end,
    opts = {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
      default = {
        display = function(list_item)
          if list_item.context then
            return string.format("%s:%s", list_item.value, tostring(list_item.context.row or 0))
          end
          return list_item.value
        end,
        equals = function(list_item_a, list_item_b)
          if list_item_a == nil and list_item_b == nil then
            return true
          elseif list_item_a == nil or list_item_b == nil then
            return false
          end

          local a = {
            value = list_item_a.value,
            row = list_item_a.context.row or 0,
          }
          local b = {
            value = list_item_b.value,
            row = list_item_b.context.row or 0,
          }
          return a.value == b.value and a.row == b.row
        end,
        select = function(list_item, _, options)
          if list_item == nil then return end

          options = options or {}

          local bufnr = vim.fn.bufnr("^" .. list_item.value .. "$")
          if bufnr == -1 then -- must create a buffer!
            bufnr = vim.fn.bufadd(list_item.value)
          end
          if not vim.api.nvim_buf_is_loaded(bufnr) then
            vim.fn.bufload(bufnr)
            vim.api.nvim_set_option_value("buflisted", true, {
              buf = bufnr,
            })
          end

          if options.vsplit then
            vim.cmd "vsplit"
          elseif options.split then
            vim.cmd "split"
          elseif options.tabedit then
            vim.cmd "tabedit"
          end

          vim.api.nvim_set_current_buf(bufnr)

          local lines = vim.api.nvim_buf_line_count(bufnr)
          if list_item.context.row > lines then list_item.context.row = lines end

          vim.api.nvim_win_set_cursor(0, {
            list_item.context.row or 1,
            list_item.context.col or 0,
          })
        end,
        BufLeave = function() end,
      },
    },
    keys = function(_, _)
      local harpoon = require "harpoon"
      local action_state = require "telescope.actions.state"
      local action_utils = require "telescope.actions.utils"

      local filter_empty_string = function(list)
        local next = {}
        for idx = 1, #list do
          if list[idx].value ~= "" then table.insert(next, list[idx]) end
        end

        return next
      end

      local gen_finder = function()
        return require("telescope.finders").new_table {
          results = filter_empty_string(harpoon:list().items),
          entry_maker = function(item)
            local line = string.format("%s:%s", item.value, item.context.row or 0)
            return {
              value = item,
              ordinal = line,
              display = line,
              lnum = item.context.row,
              col = item.context.col,
              filename = item.value,
            }
          end,
        }
      end

      local delete_harpoon_mark = function(prompt_bufnr)
        local confirmation = vim.fn.input(string.format "Delete current mark(s)? [y/n]: ")
        if string.len(confirmation) == 0 or string.sub(string.lower(confirmation), 0, 1) ~= "y" then
          print(string.format "Didn't delete mark")
          return
        end

        local selection = action_state.get_selected_entry()
        harpoon:list():remove(selection.value)

        local function get_selections()
          local results = {}
          action_utils.map_selections(prompt_bufnr, function(entry) table.insert(results, entry) end)
          return results
        end

        local selections = get_selections()
        for _, current_selection in ipairs(selections) do
          harpoon:list():remove(current_selection.value)
        end

        local current_picker = action_state.get_current_picker(prompt_bufnr)
        current_picker:refresh(gen_finder(), { reset_prompt = true })
      end

      local prefix = "<Leader><Leader>"
      require("astrocore").set_mappings {
        n = {
          [prefix] = { desc = "󰐃 Harpoon" },
        },
      }

      return {
        { prefix .. "a", function() harpoon:list():add() end, desc = "Add file" },
        { "<C-p>", function() require("harpoon"):list():prev { ui_nav_wrap = true } end, desc = "Goto previous mark" },
        { "<C-n>", function() require("harpoon"):list():next { ui_nav_wrap = true } end, desc = "Goto next mark" },
        {
          prefix .. "e",
          function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
          desc = "Toggle quick menu",
        },
        {
          "<Leader>f<Leader>",
          function()
            require("telescope").extensions.harpoon.marks {
              finder = gen_finder(),
              attach_mappings = function(_, map)
                map("i", "<c-d>", delete_harpoon_mark)
                map("n", "<c-d>", delete_harpoon_mark)
                return true
              end,
            }
          end,
          desc = "Show marks in Telescope",
        },
      }
    end,
  },

  {
    "nvim-neotest/neotest",
    version = "^5",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-python",
      "sidlatau/neotest-dart",
      "markemmons/neotest-deno",
      "rouge8/neotest-rust",
      {
        "folke/neodev.nvim",
        opts = function(_, opts)
          opts.library = opts.library or {}
          if opts.library.plugins ~= true then
            opts.library.plugins = require("astrocore").list_insert_unique(opts.library.plugins, { "neotest" })
          end
          opts.library.types = true
        end,
      },
    },
    config = function(_, opts)
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup(opts)
    end,
    opts = function()
      return {
        adapters = {
          require "neotest-go",
          require "neotest-rust",
          require "neotest-python",
          require "neotest-deno",
          require "neotest-dart" {
            command = "flutter", -- Command being used to run tests. Defaults to `flutter`
            -- Change it to `fvm flutter` if using FVM
            -- change it to `dart` for Dart only tests
            use_lsp = true, -- When set Flutter outline information is used when constructing test name.
          },
        },
      }
    end,
    keys = function(_, _)
      local prefix = "<Leader>T"
      local plugin = require "neotest"

      require("astrocore").set_mappings {
        n = {
          [prefix] = { desc = "󰙨 Test" },
        },
      }

      return {
        {
          prefix .. "r",
          function() plugin.run.run(vim.fn.expand "%") end,
          desc = "Run the current file",
        },
        {
          prefix .. "w",
          function() plugin.watch.toggle(vim.fn.expand "%") end,
          desc = "Toggle watch test",
        },
      }
    end,
  },

  {
    "kevinhwang91/nvim-hlslens",
    -- dependencies = { "AstroNvim/astrocore", opts = { on_keys = { auto_hlsearch = false } } },
    event = "BufRead",
    config = true,
  },

  {
    "brenton-leighton/multiple-cursors.nvim",
    cmd = {
      "MultipleCursorsAddDown",
      "MultipleCursorsAddUp",
      "MultipleCursorsMouseAddDelete",
      "MultipleCursorsAddMatches",
      "MultipleCursorsAddMatchesV",
      "MultipleCursorsAddJumpNextMatch",
      "MultipleCursorsJumpNextMatch",
      "MultipleCursorsLock",
    },
    dependencies = {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        for lhs, map in pairs {
          ["<C-PageDown>"] = { "<Cmd>MultipleCursorsAddDown<CR>", desc = "Add cursor down" },
          ["<C-PageUp>"] = { "<Cmd>MultipleCursorsAddUp<CR>", desc = "Add cursor up" },
          ["<C-LeftMouse>"] = { "<Cmd>MultipleCursorsMouseAddDelete<CR>", desc = "Add cursor with mouse" },
        } do
          maps.n[lhs] = map
          maps.i[lhs] = map
        end

        local prefix = "<Leader>m"
        maps.n[prefix] = { desc = " MultiCursor" }
        maps.x[prefix] = { desc = " MultiCursor" }
        for lhs, map in pairs {
          [prefix .. "a"] = { "<Cmd>MultipleCursorsAddMatches<CR>", desc = "Add cursor matches" },
          [prefix .. "A"] = {
            "<Cmd>MultipleCursorsAddMatchesV<CR>",
            desc = "Add cursor matches in previous visual area",
          },
          [prefix .. "j"] = { "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", desc = "Add cursor and jump to next match" },
          [prefix .. "J"] = { "<Cmd>MultipleCursorsJumpNextMatch<CR>", desc = "Move cursor to next match" },
          [prefix .. "l"] = { "<Cmd>MultipleCursorsLock<CR>", desc = "Lock virtual cursors" },
        } do
          maps.n[lhs] = map
          maps.x[lhs] = map
        end
      end,
    },
    config = true,
  },

  {
    "Wansmer/treesj",
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          opts.mappings.n["<Leader>j"] = { "<CMD>TSJToggle<CR>", desc = "Toggle Treesitter Join" }
        end,
      },
    },
    opts = { use_default_keymaps = false },
  },

  {
    {
      "jbyuki/venn.nvim",
      cmd = "VBox",
      dependencies = {
        {
          "AstroNvim/astrocore",
          opts = function(_, opts)
            local astrocore = require "astrocore"
            if not astrocore.is_available "hydra.nvim" then return end
            if not opts.commands then opts.comands = {} end
            opts.commands.ToggleVenn = {
              function()
                local hydra = vim.tbl_get(astrocore.plugin_opts "hydra.nvim", "Draw Diagram", "hydra")
                if hydra then
                  if hydra.layer.active then
                    hydra:exit()
                  else
                    hydra:activate()
                  end
                end
              end,
              desc = "Toggle venn diagramming mode",
            }
          end,
        },
      },
    },
    {
      "anuvyklack/hydra.nvim",
      opts = function(_, opts)
        local hint = [[
 Arrow^^^^^^   Select region with <C-v> 
 ^ ^ _K_ ^ ^   _f_: surround it with box
 _H_ ^ ^ _L_
 ^ ^ _J_ ^ ^                      _<Esc>_
]]
        opts["Draw Diagram"] = {
          hint = hint,
          config = {
            invoke_on_body = true,
            hint = { border = "double" },
            on_enter = function() vim.o.virtualedit = "all" end,
          },
          mode = "n",
          body = "<Leader>zv",
          heads = {
            { "H", "<C-v>h:VBox<CR>" },
            { "J", "<C-v>j:VBox<CR>" },
            { "K", "<C-v>k:VBox<CR>" },
            { "L", "<C-v>l:VBox<CR>" },
            { "f", ":VBox<CR>", { mode = "v" } },
            { "<Esc>", nil, { exit = true } },
          },
        }
      end,
    },
  },

  {
    "stevearc/overseer.nvim",
    version = "*",
    cmd = {
      "OverseerOpen",
      "OverseerClose",
      "OverseerToggle",
      "OverseerSaveBundle",
      "OverseerLoadBundle",
      "OverseerDeleteBundle",
      "OverseerRunCmd",
      "OverseerRun",
      "OverseerInfo",
      "OverseerBuild",
      "OverseerQuickAction",
      "OverseerTaskAction ",
      "OverseerClearCache",
    },
    ---@param opts overseer.Config
    opts = function(_, opts)
      local astrocore = require "astrocore"
      if astrocore.is_available "toggleterm.nvim" then opts.strategy = "toggleterm" end
      opts.task_list = {
        direction = "bottom",
        bindings = {
          ["<C-l>"] = false,
          ["<C-h>"] = false,
          ["<C-k>"] = false,
          ["<C-j>"] = false,
          q = "<Cmd>close<CR>",
          K = "IncreaseDetail",
          J = "DecreaseDetail",
          ["<C-p>"] = "ScrollOutputUp",
          ["<C-n>"] = "ScrollOutputDown",
        },
      }
    end,
    dependencies = {
      { "AstroNvim/astroui", opts = { icons = { Overseer = "" } } },
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          local prefix = "<Leader>R"
          maps.n[prefix] = { desc = require("astroui").get_icon("Overseer", 1, true) .. "Overseer" }

          maps.n[prefix .. "t"] = { "<Cmd>OverseerToggle<CR>", desc = "Toggle" }
          maps.n[prefix .. "c"] = { "<Cmd>OverseerRunCmd<CR>", desc = "Run Command" }
          maps.n[prefix .. "r"] = { "<Cmd>OverseerRun<CR>", desc = "Run Task" }
          maps.n[prefix .. "q"] = { "<Cmd>OverseerQuickAction<CR>", desc = "Quick Action" }
          maps.n[prefix .. "a"] = { "<Cmd>OverseerTaskAction<CR>", desc = "Task Action" }
          maps.n[prefix .. "i"] = { "<Cmd>OverseerInfo<CR>", desc = "Info" }
        end,
      },
    },
  },

  {
    "mistweaverco/kulala.nvim",
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>zr"] = {
            function() require("kulala").run() end,
            desc = "Run the current request",
          }
          maps.n["]r"] = {
            function() require("kulala").jump_next() end,
            desc = "Jump to the next request",
          }
          maps.n["[r"] = {
            function() require("kulala").jump_prev() end,
            desc = "Jump to the previous request",
          }
        end,
      },
    },
    ft = "http",
  },
}
