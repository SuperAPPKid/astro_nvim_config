---@type LazySpec
return {
  {
    "gbprod/yanky.nvim",
    event = "User AstroFile",
    keys = {
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
    },
    opts = function()
      return {
        ring = {
          history_length = 0,
          storage = "memory",
        },
        highlight = {
          timer = 200,
        },
      }
    end,
  },

  {
    "stevearc/resession.nvim",
    lazy = false,
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>Sl"] = {
            function() require("resession").load "Last Session" end,
            desc = "Load last session",
          }
          maps.n["<Leader>Ss"] = {
            function() require("resession").save(vim.fn.getcwd(), { dir = "dirsession" }) end,
            desc = "Save this dirsession",
          }
          maps.n["<Leader>Sd"] = {
            function()
              require("resession").delete(vim.fn.getcwd(), { dir = "dirsession" })
              vim.api.nvim_del_augroup_by_name "resession_auto_save"
              vim.cmd "qa"
            end,
            desc = "Delete this dirsession",
          }
          maps.n["<Leader>SD"] = {
            function() require("resession").delete(nil, { dir = "dirsession" }) end,
            desc = "Delete a dirsession",
          }
          maps.n["<Leader>Sf"] = {
            function() require("resession").load(nil, { dir = "dirsession" }) end,
            desc = "Load a dirsession",
          }
          maps.n["<Leader>SS"] = false
          maps.n["<Leader>St"] = false
          maps.n["<Leader>SF"] = false

          local autocmds = opts.autocmds
          local isStdIn = false
          autocmds.session_restore = {
            {
              event = "StdinReadPre",
              callback = function() isStdIn = true end,
            },
            {
              event = "VimEnter",
              nested = true,
              callback = function()
                -- Only load the session if nvim was started with no args
                if vim.fn.argc(-1) == 0 and not isStdIn then
                  require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
                else
                  vim.api.nvim_del_augroup_by_name "resession_auto_save"
                end
              end,
            },
          }
        end,
      },
    },
    dependencies = {
      "stevearc/overseer.nvim",
    },
    opts = function(_, opts)
      opts.buf_filter = function(bufnr)
        local buftype = vim.bo[bufnr].buftype
        if buftype == "help" then return true end
        if buftype ~= "" and buftype ~= "acwrite" then return false end
        if vim.api.nvim_buf_get_name(bufnr) == "" then return false end
        return require("astrocore.buffer").is_restorable(bufnr)
      end
      opts.extensions = require("astrocore").extend_tbl(opts.extensions, { overseer = { autostart_on_load = false } })
    end,
  },

  {
    "superappkid/edgy.nvim",
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    event = "User AstroFile",
    opts = {
      animate = { enabled = false },
      exit_when_last = false,
      wo = {
        winhighlight = "",
        winbar = false,
      },
      bottom = {
        {
          ft = "qf",
          size = { height = 10 },
          title = "QuickFix",
        },
        {
          ft = "help",
          size = { height = 0.8 },
          -- don't open help files in edgy that we're editing
          filter = function(buf) return vim.bo[buf].buftype == "help" end,
        },
        {
          ft = "neotest-output-panel",
          size = { height = 10 },
        },
        {
          ft = "toggleterm",
          size = { height = 0.33 },
          filter = function(buf, _)
            local _, term = require("toggleterm.terminal").identify(vim.api.nvim_buf_get_name(buf))
            if term then return term.direction == "horizontal" end
          end,
        },
        {
          ft = "dbout",
          size = { height = 0.6 },
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
          ft = "neotest-summary",
          size = { width = 52 },
        },
        {
          ft = "OverseerList",
          size = { width = 52 },
          filter = function(_, win) return vim.api.nvim_win_get_config(win).relative == "" end,
        },
        {
          ft = "grug-far",
          title = "Search/Replace",
          size = { width = 0.5 },
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
    -- cmd = "ASToggle", -- optional for lazy loading on command
    -- event = { "User AstroFile", "InsertEnter" },
    event = {
      "BufLeave",
      "FocusLost",
      "InsertEnter",
      "InsertLeave",
      "TextChanged",
    }, -- optional for lazy loading on trigger events
    config = function(_, opts)
      require("auto-save").setup(opts)

      local group = vim.api.nvim_create_augroup("autosave", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        pattern = "AutoSaveWritePre",
        group = group,
        callback = function(_)
          -- save global autoformat status
          vim.g.OLD_AUTOFORMAT = vim.g.autoformat
          vim.g.autoformat = false
          local old_autoformat_buffers = {}
          -- disable all manually enabled buffers
          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.b[bufnr].autoformat then
              vim.g.OLD_AUTOFORMAT_BUFFERS = require("astrocore").list_insert_unique(old_autoformat_buffers, { bufnr })
              vim.b[bufnr].autoformat = false
            end
          end
          vim.g.OLD_AUTOFORMAT_BUFFERS = old_autoformat_buffers
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
    end,
    opts = {
      trigger_events = { -- See :h events
        immediate_save = { "BufLeave", "FocusLost" }, -- vim events that trigger an immediate save
        defer_save = { "InsertLeave", "TextChanged" }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
        cancel_deferred_save = { "InsertEnter" }, -- vim events that cancel a pending deferred save
      },
      write_all_buffers = true,
      condition = function(bufnr)
        local buftype = vim.bo[bufnr].buftype
        local filetype = vim.bo[bufnr].filetype
        if buftype == "help" then return true end
        if buftype ~= "" and buftype ~= "acwrite" then return false end
        if vim.api.nvim_buf_get_name(bufnr) == "" then return false end
        for _, value in pairs { "harpoon", "oil", "AvanteInput", "OverseerForm" } do
          if filetype == value then return false end
        end
        return true
      end,
    },
  },

  {
    "superappkid/projectmgr.nvim",
    keys = {
      { "<Leader>fp", "<Cmd>ProjectMgr<CR>", desc = "Open ProjectMgr panel" },
    },
    opts = {
      session = {
        enabled = false,
      },
      scripts = {
        enabled = false,
      },
    },
  },

  {
    "superappkid/modes.nvim",
    event = "User AstroFile",
    opts = {
      set_signcolumn = false,
      line_opacity = 0.5,
      ignore = {
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
    "stevearc/oil.nvim",
    init = function(_)
      local augroup = vim.api.nvim_create_augroup("oil_settings", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        desc = "Disable view saving for oil buffers",
        pattern = "oil",
        callback = function(args) vim.b[args.buf].view_activated = false end,
      })

      vim.api.nvim_create_autocmd("User", {
        group = augroup,
        desc = "Close buffers when files are deleted in Oil",
        pattern = "OilActionsPost",
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
      })

      vim.api.nvim_create_autocmd("VimEnter", {
        group = augroup,
        desc = "Start Oil when vim is opened with no arguments",
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
            local stat = (vim.uv or vim.loop).fs_stat(opened)
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
      })
    end,
    cmd = "Oil",
    keys = {
      { "<Leader>O", function() require("oil").open() end, desc = "Open folder in Oil" },
    },
    opts = function(_, opts)
      local get_icon = require("astroui").get_icon
      opts.columns = {
        { "icon", default_file = get_icon "DefaultFile", directory = get_icon "FolderClosed" },
        "permissions",
        "size",
      }
      opts.delete_to_trash = true
      opts.watch_for_changes = true
      opts.skip_confirm_for_simple_edits = true
      opts.keymaps = {
        ["<C-s>"] = false,
        ["<C-h>"] = false,
        ["q"] = { callback = function() require("astrocore.buffer").close() end },
      }
      opts.view_options = {
        show_hidden = true,
      }
      opts.confirmation = { border = "double" }
      opts.ssh = { border = "double" }
      opts.keymaps_help = { border = "double" }
    end,
  },

  {
    "monaqa/dial.nvim",
    lazy = true,
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          local prefix = "<Leader>i"
          local prefix_additive = prefix .. "a"
          maps.n[prefix] = {
            desc = require("astroui").get_icon("Dial", 1, true) .. "incr/decr",
          }
          maps.v[prefix] = maps.n[prefix]

          maps.n[prefix_additive] = {
            desc = require("astroui").get_icon("Dial_additive", 1, true) .. "additive",
          }
          maps.v[prefix_additive] = maps.n[prefix_additive]

          maps.v[prefix .. "i"] = {
            function() require("dial.map").manipulate("increment", "visual", "visual") end,
            desc = "Increment",
          }
          maps.v[prefix .. "d"] = {
            function() require("dial.map").manipulate("decrement", "visual", "visual") end,
            desc = "Decrement",
          }
          maps.v[prefix_additive .. "i"] = {
            function() require("dial.map").manipulate("increment", "gvisual", "visual") end,
            desc = "Increment",
          }
          maps.v[prefix_additive .. "d"] = {
            function() require("dial.map").manipulate("decrement", "gvisual", "visual") end,
            desc = "Decrement",
          }

          maps.n[prefix .. "i"] = {
            function() require("dial.map").manipulate("increment", "normal", "normal") end,
            desc = "Increment",
          }
          maps.n[prefix .. "d"] = {
            function() require("dial.map").manipulate("decrement", "normal", "normal") end,
            desc = "Decrement",
          }
          maps.n[prefix_additive .. "i"] = {
            function() require("dial.map").manipulate("increment", "gnormal", "normal") end,
            desc = "Increment",
          }
          maps.n[prefix_additive .. "d"] = {
            function() require("dial.map").manipulate("decrement", "gnormal", "normal") end,
            desc = "Decrement",
          }
        end,
      },
    },
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
  },

  {
    "nyngwang/NeoZoom.lua",
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>z<enter>"] = {
            "<Cmd>NeoZoomToggle<CR>",
            desc = "Toggle Zoom",
            silent = true,
          }
        end,
      },
    },
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
    },
  },

  {
    "j-hui/fidget.nvim",
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>zn"] = {
            "<Cmd>Fidget history<CR>",
            desc = "Fidget history",
          }
        end,
      },
    },
    config = function(_, opts)
      local fidget = require "fidget"
      fidget.setup(opts)
      vim.notify = fidget.notify
    end,
    opts = function(_, _)
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
            if type(level) ~= "number" then level = nil end
            level = level or 2
            local title = opts and opts.title
            local should_redirect = level >= vim.log.levels.ERROR

            if title then
              if should_redirect then
                should_redirect = string.find(title, "Codeium") == nil -- don't redirect Codeium messages
              else
                local allow_titles = { "tinygit", "Debug" } -- redirect messages
                for _, allow_title in pairs(allow_titles) do
                  if string.find(title, allow_title) ~= nil then
                    should_redirect = true
                    break
                  end
                end
              end
            else
              should_redirect = false
            end

            if should_redirect then
              opts = require("astrocore").extend_tbl(opts, { title = title })
              Snacks.notifier.notify(msg, level, opts)
              return true
            end

            return false
          end,
          view = {
            render_message = function(msg, cnt)
              msg = cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
              msg = #msg > 20 and vim.fn.strcharpart(msg, 0, 16) .. "..." or msg -- truncate to 16 characters
              return msg
            end,
          },
          window = {
            winblend = 0,
          },
        },
      }
    end,
  },

  {
    "backdround/neowords.nvim",
    lazy = true,
    specs = {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local word_hops = function()
          local neowords = require "neowords"
          local general_words = "[:digit:][:lower:][:upper:]\\u0800-\\uffff"
          return neowords.get_word_hops(
            neowords.pattern_presets.hex_color,
            string.format("\\v[-]@![%s]+", general_words), -- utf-8 words
            string.format("\\v([%s]|_)@<!_", general_words), -- leading _
            "\\V\\[{[(}\\])]\\+", -- brackets {}[]()
            "\\v(``)|(\"\")|''" -- quotes '"
          )
        end

        local maps = opts.mappings
        for _, mode in ipairs { "n", "x", "o" } do
          maps[mode]["w"] = { function() word_hops().forward_start() end, desc = "Next word" }
          maps[mode]["e"] = { function() word_hops().forward_end() end, desc = "Next end of word" }
          maps[mode]["b"] = { function() word_hops().backward_start() end, desc = "Previous word" }
          maps[mode]["ge"] = { function() word_hops().backward_end() end, desc = "Previous end of word" }
        end
      end,
    },
  },

  {
    "aurum77/live-server.nvim",
    build = function() require("live_server.util").install() end,
    ft = "html",
    keys = {
      { "<Leader>zh", "<Cmd>LiveServer<CR>", desc = "HTML Preview" },
    },
  },

  {
    "echasnovski/mini.surround",
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
          local plugin_opts = require("lazy.core.plugin").values(plugin, "opts", false)
          opts.mappings.n[plugin_opts.mappings.prefix] = {
            desc = require("astroui").get_icon("bracket", 1, false) .. "Surround",
          }
        end,
      },
    },
    keys = function(plugin, _)
      local opts = type(plugin.opts) == "function" and plugin.opts(plugin, {}) or plugin.opts or {}
      local mappings = opts.mappings or {}
      local insert = require("astrocore").list_insert_unique
      local keys = {
        { mappings.prefix, [[:<C-u>lua MiniSurround.add('visual')<CR>]], mode = "x", desc = "Add surrounding" },
      }
      if mappings.delete then insert(keys, { { mappings.delete, desc = "Delete surrounding" } }) end
      if mappings.replace then insert(keys, { { mappings.replace, desc = "Replace surrounding" } }) end
      if mappings.find then insert(keys, { { mappings.find, desc = "Find right surrounding" } }) end
      if mappings.find_left then insert(keys, { { mappings.find_left, desc = "Find left surrounding" } }) end
      return keys
    end,
    opts = function(_, _)
      local prefix = "<Leader>s"

      return {
        use_nvim_treesitter = false,
        n_lines = 1500,
        search_method = "cover",
        mappings = {
          prefix = prefix,
          delete = prefix .. "d", -- Delete surrounding
          replace = prefix .. "c", -- Replace surrounding

          find = prefix .. "f", -- Find surrounding (to the right)
          find_left = prefix .. "F", -- Find surrounding (to the left)

          add = "", -- manually add mapping
          highlight = "", -- Highlight surrounding
          update_n_lines = "", -- Update n_lines
          suffix_last = "", -- Suffix to search with "prev" method
          suffix_next = "", -- Suffix to search with "next" method
        },
        silent = true,
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
    keys = {
      { "<Leader>zt", "<Cmd>Translate ZH-TW<CR>", mode = { "x" }, desc = "Translate" },
    },
    opts = {
      preset = {
        output = {
          floating = {
            border = "double",
          },
        },
      },
    },
  },

  {
    "ThePrimeagen/harpoon",
    lazy = true,
    branch = "harpoon2",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = function(_, _)
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
          results = filter_empty_string(require("harpoon"):list().items),
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
        require("harpoon"):list():remove(selection.value)

        local function get_selections()
          local results = {}
          action_utils.map_selections(prompt_bufnr, function(entry) table.insert(results, entry) end)
          return results
        end

        local selections = get_selections()
        for _, current_selection in ipairs(selections) do
          require("harpoon"):list():remove(current_selection.value)
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
        { prefix .. "a", function() require("harpoon"):list():add() end, desc = "Add file" },
        { "<C-P>", function() require("harpoon"):list():prev { ui_nav_wrap = true } end, desc = "Goto previous mark" },
        { "<C-N>", function() require("harpoon"):list():next { ui_nav_wrap = true } end, desc = "Goto next mark" },
        {
          prefix .. "e",
          function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,
          desc = "Edit quick menu",
        },
        {
          "<Leader><Leader><CR>",
          function()
            require("telescope").extensions.harpoon.marks {
              finder = gen_finder(),
              attach_mappings = function(_, map)
                map("i", "<C-d>", delete_harpoon_mark)
                map("n", "<C-d>", delete_harpoon_mark)
                return true
              end,
            }
          end,
          desc = "Harpoon marks",
        },
      }
    end,
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
  },

  {
    "kevinhwang91/nvim-hlslens",
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
    specs = {
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

        -- HACK: fix <Esc> not working
        local quit_whichkey_wrapper = function(f)
          return function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
            vim.schedule(f)
          end
        end
        local prefix = "<Leader>m"
        maps.n[prefix] = { desc = " MultiCursor" }
        maps.x[prefix] = { desc = " MultiCursor" }
        for lhs, map in pairs {
          [prefix .. "a"] = {
            quit_whichkey_wrapper(function() vim.cmd "MultipleCursorsAddMatches" end),
            desc = "Add cursor matches",
          },
          [prefix .. "A"] = {
            quit_whichkey_wrapper(function() vim.cmd "MultipleCursorsAddMatchesV" end),
            desc = "Add cursor matches in previous visual area",
          },
          [prefix .. "j"] = {
            quit_whichkey_wrapper(function() vim.cmd "MultipleCursorsAddJumpNextMatch" end),
            desc = "Add cursor and jump to next match",
          },
          [prefix .. "J"] = {
            quit_whichkey_wrapper(function() vim.cmd "MultipleCursorsJumpNextMatch" end),
            desc = "Move cursor to next match",
          },
          [prefix .. "l"] = {
            quit_whichkey_wrapper(function() vim.cmd "MultipleCursorsLock" end),
            desc = "Lock virtual cursors",
          },
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
    keys = {
      { "<Leader>j", "<Cmd>TSJToggle<CR>", desc = "Toggle Treesitter Join" },
    },
    opts = { use_default_keymaps = false },
  },

  {
    "jbyuki/venn.nvim",
    cmd = "VBox",
    specs = {
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
      {
        "nvimtools/hydra.nvim",
        opts = function(_, opts)
          opts["Draw Diagram"] = {
            hint = [[
 Arrow^^^^^^   Select region with <C-v> 
 ^ ^ _K_ ^ ^   _f_: surround it with box
 _H_ ^ ^ _L_
 ^ ^ _J_ ^ ^                      _<Esc>_
]],
            config = {
              color = "pink",
              invoke_on_body = true,
              hint = {
                float_opts = {
                  border = "double",
                },
              },
              on_enter = function() vim.b.virtualedit = "all" end,
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
  },

  {
    "superappkid/kulala.nvim",
    ft = "http",
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local prefix = "<Leader>r"
          opts.mappings.n[prefix] = {
            desc = require("astroui").get_icon("req", 1, false) .. "Request",
          }
          opts.mappings.n[prefix .. "<CR>"] = {
            function() require("kulala").scratchpad() end,
            desc = "Create temp request",
          }
          opts.autocmds = require("astrocore").extend_tbl(opts.autocmds, {
            kulala_settings = {
              {
                event = "FileType",
                desc = "Add run request keymap for .http",
                pattern = "http",
                callback = function(args)
                  require("astrocore").set_mappings({
                    n = {
                      [prefix .. "<CR>"] = {
                        function() require("kulala").run() end,
                        desc = "Run current",
                      },
                      [prefix .. "u"] = {
                        function() require("kulala.ui").show_headers_body() end,
                        desc = "Show response",
                      },
                      [prefix .. "e"] = {
                        function() require("kulala").set_selected_env() end,
                        desc = "Select env",
                      },
                      [prefix .. "R"] = {
                        function() require("kulala").replay() end,
                        desc = "Replay last",
                      },
                      [prefix .. "i"] = {
                        function() require("kulala").inspect() end,
                        desc = "Inspect current",
                      },
                      [prefix .. "y"] = {
                        function() require("kulala").copy() end,
                        desc = "Copy as cURL",
                      },
                      [prefix .. "P"] = {
                        function() require("kulala").from_curl() end,
                        desc = "Paste cURL from clipboard",
                      },
                      [prefix .. "l"] = {
                        function() require("kulala").search() end,
                        desc = "Search request",
                      },
                      ["]R"] = {
                        function() require("kulala").jump_next() end,
                        desc = "Jump to the next",
                      },
                      ["[R"] = {
                        function() require("kulala").jump_prev() end,
                        desc = "Jump to the previous",
                      },
                    },
                  }, { buffer = args.buf })
                end,
              },
            },
          })
        end,
      },
    },
    opts = {
      lsp = { on_attach = function(...) return require("astrolsp").on_attach(...) end },
      ui = {
        display_mode = "float",
        formatter = true,
        win_opts = {
          bo = {
            buflisted = false,
            swapfile = false,
          },
        },
      },
    },
  },

  {
    "echasnovski/mini.ai",
    event = "User AstroFile",
    opts = function(_, opts)
      local gen_spec = require("mini.ai").gen_spec
      opts = require("astrocore").extend_tbl(opts, {
        use_nvim_treesitter = false,
        n_lines = 1500,
        search_method = "cover",
        custom_textobjects = {
          ["c"] = gen_spec.treesitter {
            a = { "@conditional.outer", "@loop.outer" },
            i = { "@conditional.inner", "@loop.inner" },
          },
          ["f"] = gen_spec.treesitter { a = "@function.outer", i = "@function.inner" },
          ["G"] = function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line "$",
              col = math.max(vim.fn.getline("$"):len(), 1),
            }
            return { from = from, to = to }
          end,
          ["i"] = function(ai_type, _, _)
            local params
            if ai_type == "i" then
              params = {
                min_size = 2, -- minimum size of the scope
                edge = false, -- inner scope
                cursor = false,
                treesitter = { blocks = { enabled = false } },
              }
            elseif ai_type == "a" then
              params = {
                cursor = false,
                min_size = 2, -- minimum size of the scope
                treesitter = { blocks = { enabled = false } },
              }
            end
            if params then Snacks.scope.textobject(params) end
            return false
          end,
          ["o"] = gen_spec.treesitter { a = "@loop.outer", i = "@loop.inner" },
          ["|"] = gen_spec.pair("|", "|", { type = "non-balanced" }),
          ["*"] = gen_spec.pair("*", "*", { type = "greedy" }),
          ["_"] = gen_spec.pair("_", "_", { type = "greedy" }),
        },
        mappings = {
          around_next = "",
          inside_next = "",
          around_last = "",
          inside_last = "",
          goto_left = "",
          goto_right = "",
        },
        silent = true,
      })
      return opts
    end,
  },

  {
    "Vonr/align.nvim",
    branch = "v2",
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          local prefix = "<Leader>a"
          maps.x[prefix] = {
            desc = "󱇂 Align",
          }

          maps.x[prefix .. "<CR>"] = {
            function()
              require("align").align_to_char {
                preview = false,
              }
            end,
            silent = true,
            desc = "Aligns to char",
          }
          maps.x[prefix .. "s"] = {
            function()
              require("align").align_to_string {
                preview = false,
                regex = false,
              }
            end,
            silent = true,
            desc = "Aligns to string",
          }
          maps.x[prefix .. "r"] = {
            function()
              require("align").align_to_string {
                preview = false,
                regex = true,
              }
            end,
            silent = true,
            desc = "Aligns to a Vim regex",
          }
        end,
      },
    },
  },

  {
    "kwkarlwang/bufjump.nvim",
    lazy = true,
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          opts.mappings.n["<C-O>"] = { function() require("bufjump").backward_same_buf() end }
          opts.mappings.n["<C-I>"] = { function() require("bufjump").forward_same_buf() end }
        end,
      },
    },
    opts = {
      forward_key = false,
      backward_key = false,
      on_success = function() vim.cmd [[execute "normal! g`\"zz"]] end,
    },
  },

  {
    "vyfor/cord.nvim",
    version = "^2",
    build = ":Cord update",
    event = "VeryLazy",
    opts = {
      log_level = vim.log.levels.OFF,
      editor = {
        icon = true,
      },
      display = {
        theme = "atom",
        flavor = "accent",
      },
      text = {
        workspace = "",
        viewing = "Viewing...",
        editing = "Editing...",
        diagnostics = function(opts)
          return #vim.diagnostic.get(vim.api.nvim_get_current_buf()) > 0 and "Fixing problems in " .. opts.tooltip
            or true
        end,
      },
    },
  },

  {
    "abecodes/tabout.nvim",
    event = "InsertEnter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      tabkey = "<S-Right>", -- key to trigger tabout, set to an empty string to disable
      backwards_tabkey = "<S-Left>", -- key to trigger backwards tabout, set to an empty string to disable
      act_as_tab = false, -- shift content if tab out is not possible
      act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
      default_tab = "", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
      default_shift_tab = "", -- reverse shift default action,
      completion = false, -- if the tabkey is used in a completion pum
      ignore_beginning = true, -- if the cursor is at the beginning of a filled element it will rather tab out than shift the content
    },
  },

  {
    "johmsalas/text-case.nvim",
    keys = {
      { "<Leader>zt", "<Cmd>TextCaseOpenTelescope<CR>", desc = "TextCase" },
    },
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    },
    config = function(_, opts)
      require("textcase").setup(opts)
      require("telescope").load_extension "textcase"
    end,
    opts = {
      default_keymappings_enabled = true,
    },
  },

  {
    "chrishrb/gx.nvim",
    cmd = { "Browse" },
    dependencies = { "nvim-lua/plenary.nvim" }, -- Required for Neovim < 0.10.0
    specs = {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["gx"] = false,
          },
        },
      },
    },
    submodules = false, -- not needed, submodules are required only for tests
    -- you can specify also another config if you want
    config = function(_, opts) require("gx").setup(opts) end,
    opts = {
      handlers = {
        cve = false,
        jira = { -- custom handler to open Jira tickets (these have higher precedence than builtin handlers)
          name = "jira", -- set name of handler
          handle = function(mode, line, _)
            local ticket = require("gx.helper").find(line, mode, "(%u+-%d+)")
            if ticket and #ticket < 20 then return "http://jira.company.com/browse/" .. ticket end
          end,
        },
        rust = { -- custom handler to open rust's cargo packages
          name = "rust", -- set name of handler
          filetype = { "toml" }, -- you can also set the required filetype for this handler
          filename = "Cargo.toml", -- or the necessary filename
          handle = function(mode, line, _)
            local crate = require("gx.helper").find(line, mode, "(%w+)%s-=%s")

            if crate then return "https://crates.io/crates/" .. crate end
          end,
        },
      },
      handler_options = {
        select_for_search = false, -- if your cursor is e.g. on a link, the pattern for the link AND for the word will always match. This disables this behaviour for default so that the link is opened without the select option for the word AND link
        git_remote_push = false, -- use the push url for git issue linking,
      },
    },
    keys = {
      { "gx", "<cmd>Browse<cr>", mode = { "n", "x" }, desc = "Goto link" },
    },
  },

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = {
      {
        "nvim-telescope/telescope.nvim",
        opts = function(_, opts)
          local defaults = opts.defaults
          local open_with_trouble = require("trouble.sources.telescope").open
          defaults.mappings.n["<C-x>"] = open_with_trouble
          defaults.mappings.i["<C-x>"] = open_with_trouble
        end,
      },
    },
    specs = {
      { "lewis6991/gitsigns.nvim", optional = true, opts = { trouble = true } },
    },
    keys = function(_, keys)
      local prefix = "<Leader>x"
      keys = require("astrocore").list_insert_unique(keys, {
        -- { prefix .. "<CR>", "<Cmd>Trouble <CR>", desc = "Trouble modes" },
        { "<Leader>X", "<Cmd>Trouble close<CR>", desc = "Close Trouble" },
        { prefix .. "X", "<Cmd>Trouble diagnostics toggle<CR>", desc = "Workspace Diagnostics (Trouble)" },
        { prefix .. "x", "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Document Diagnostics (Trouble)" },
        { prefix .. "L", "<Cmd>Trouble loclist toggle<CR>", desc = "Location List (Trouble)" },
        { prefix .. "Q", "<Cmd>Trouble quickfix toggle<CR>", desc = "Quickfix List (Trouble)" },
        { prefix .. "s", "<Cmd>Trouble symbols toggle<CR>", desc = "Symbols (Trouble)" },
        { prefix .. "f", "<Cmd>Trouble telescope toggle<CR>", desc = "Telescope Result (Trouble)" },
        { prefix .. "g", "<Nop>", desc = "LSP" },
        { prefix .. "gd", "<Cmd>Trouble lsp_definitions toggle<CR>", desc = "LSP Definition (Trouble)" },
        { prefix .. "gd", "<Cmd>Trouble lsp_references toggle<CR>", desc = "LSP Reference (Trouble)" },
        { prefix .. "gv", "<Cmd>Trouble lsp_declarations toggle<CR>", desc = "LSP Type Declaration (Trouble)" },
        { prefix .. "gy", "<Cmd>Trouble lsp_type_definitions toggle<CR>", desc = "LSP Type Definition (Trouble)" },
        { prefix .. "gI", "<Cmd>Trouble lsp_implementations toggle<CR>", desc = "LSP Implementation (Trouble)" },
        { prefix .. "gc", "<Cmd>Trouble lsp_incoming_calls toggle<CR>", desc = "LSP Incoming Call (Trouble)" },
        { prefix .. "gC", "<Cmd>Trouble lsp_outgoing_calls toggle<CR>", desc = "LSP Outgoing Call (Trouble)" },
      })
      if require("astrocore").is_available "todo-comments.nvim" then
        keys = require("astrocore").list_insert_unique(keys, {
          { prefix .. "t", "<Cmd>Trouble todo<CR>", desc = "Trouble Todo ALL" },
          { prefix .. "T", "<Cmd>Trouble todo filter={tag={TODO,FIX,FIXME}}<CR>", desc = "Trouble Todo/Fix/Fixme" },
        })
      end
      return keys
    end,
    opts = function(_, opts)
      local get_icon = require("astroui").get_icon

      opts.keys = {
        ["<esc>"] = "cancel",
        ["q"] = "close",
        ["<c-e>"] = "close",
      }
      opts.win = {
        type = "split",
        position = "right",
        size = 0.5,
      }
      opts.preview = {
        wo = {
          foldcolumn = "0",
          foldenable = false,
          foldlevel = 99,
          foldmethod = "manual",
          number = true,
        },
        type = "split",
        relative = "win",
        position = "bottom",
        size = 0.4,
      }
      opts.focus = true
      opts.icons = {
        indent = {
          fold_open = get_icon "FoldOpened" .. " ",
          fold_closed = get_icon "FoldClosed" .. " ",
        },
        folder_closed = get_icon "FolderClosed" .. " ",
        folder_open = get_icon "FolderOpen" .. " ",
      }
      opts.modes = opts.modes or {}
      opts.config = function(cfg)
        cfg.modes.symbols.focus = nil
        cfg.modes.symbols.win = nil
      end
    end,
  },

  {
    "folke/flash.nvim",
    event = "User AstroFile",
    keys = {
      {
        "s",
        function() require("flash").jump { jump = { pos = "end", offset = 0 } } end,
        mode = { "n", "x", "o" },
        desc = "Flash",
      },
      { "S", function() require("flash").treesitter() end, mode = { "n", "x", "o" }, desc = "Flash Treesitter" },
      { "R", function() require("flash").treesitter_search() end, mode = { "x" }, desc = "Treesitter Search" },
      {
        "R",
        function() require("flash").treesitter_search { remote_op = { restore = true, motion = true } } end,
        mode = { "o" },
        desc = "Treesitter Search",
      },
      { "r", function() require("flash").remote() end, mode = { "o" }, desc = "Remote Flash" },
    },
    specs = {
      {
        "AstroNvim/astroui",
        opts = {
          highlights = {
            init = {
              FlashCursor = { link = "Normal" },
            },
          },
        },
      },
    },
    opts = {
      labels = "sjkluioyhnmpadftgv;JKLUIOYHNMPTGVRFED",
      label = {
        uppercase = false,
        current = false,
      },
      modes = {
        search = {
          enabled = false,
        },
        char = {
          jump_labels = true,
          labels = "abcdefghijklmnopqrstuvwxyz",
          label = {
            uppercase = true,
            style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
            exclude = "hjklaAiIcCdDmMrRvVyYxX",
          },
          highlight = {
            backdrop = false,
            matches = false,
          },
          keys = { "f", "F", "t", "T" },
          char_actions = function(motion)
            return {
              [motion] = "next",
              [motion:match "%l" and motion:upper() or motion:lower()] = "prev",
            }
          end,
        },
        treesitter = {
          labels = "abcdefghijklmnopqrstuvwxyz",
        },
        treesitter_search = {
          labels = "abcdefghijklmnopqrstuvwxyz",
        },
      },
      prompt = {
        enabled = false,
      },
    },
  },

  {
    "chrisgrieser/nvim-early-retirement",
    event = "User AstroFile",
    opts = {
      deleteBufferWhenFileDeleted = true,
    },
  },

  {
    "superappkid/nvim-recorder",
    specs = {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<Leader>q"] = false,
          },
        },
      },
    },
    keys = function(plugin, _)
      require("astrocore").set_mappings {
        n = {
          ["q"] = { "<Nop>" },
          ["<Leader>q"] = { "<Nop>", desc = " Recording" },
        },
      }

      local opts = type(plugin.opts) == "function" and plugin.opts(plugin, {}) or plugin.opts or {}
      local mapping = opts.mapping or {}
      local insert = require("astrocore").list_insert_unique
      local keys = {}

      if mapping.startStopRecording then
        insert(
          keys,
          { { mapping.startStopRecording, require("recorder").toggleRecording, desc = "Start/Stop Recording" } }
        )
      end
      if mapping.playMacro then
        insert(keys, { { mapping.playMacro, require("recorder").playRecording, desc = "Play Recording" } })
      end
      if mapping.switchSlot then
        insert(keys, { { mapping.switchSlot, require("recorder").switchMacroSlot, desc = "Switch Macro Slot" } })
      end
      if mapping.editMacro then
        insert(keys, { { mapping.editMacro, require("recorder").editMacro, desc = "Edit Macro" } })
      end
      if mapping.deleteAllMacros then
        insert(keys, { { mapping.deleteAllMacros, require("recorder").deleteAllMacros, desc = "Delete All Macros" } })
      end
      if mapping.yankMacro then
        insert(keys, { { mapping.yankMacro, require("recorder").yankMacro, desc = "Yank Macro" } })
      end
      if mapping.addBreakPoint then
        insert(keys, { { mapping.addBreakPoint, require("recorder").addBreakPoint, desc = "Insert Macro Breakpoint" } })
      end
      return keys
    end,
    opts = {
      slots = { "a", "b", "c", "d", "e" },
      mapping = {
        startStopRecording = "Q",
        playMacro = "<Leader>q<CR>",
        switchSlot = "<Leader>qc",
        editMacro = "<Leader>qe",
        deleteAllMacros = "<Leader>qD",
        yankMacro = "<Leader>qy",
      },
    },
  },

  {
    "superappkid/nvim-scissors",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "L3MON4D3/LuaSnip",
    },
    keys = function(_, keys)
      keys = {}
      local prefix = "<Leader>I"
      require("astrocore").set_mappings {
        n = {
          [prefix] = { desc = " Snippet" },
          [prefix .. "<CR>"] = {
            function() require("scissors").editSnippet() end,
            desc = "Find snippet",
          },
          [prefix .. "n"] = {
            function() require("scissors").addNewSnippet() end,
            desc = "Create snippet",
          },
        },
        v = {
          [prefix] = {
            function() require("scissors").addNewSnippet() end,
            desc = "Create snippet",
          },
        },
      }
      return keys
    end,
    opts = function(_, opts)
      local snippetDir = vim.fn.stdpath "data" .. "/nvim-scissors"
      opts.snippetDir = snippetDir
      opts.editSnippetPopup = {
        height = 0.8,
        width = 0.8,
        border = "double",
      }
      require("luasnip.loaders.from_vscode").lazy_load {
        paths = { snippetDir },
      }
    end,
  },

  {
    "chrisgrieser/nvim-origami",
    event = "BufReadPost",
    opts = {
      useLspFoldsWithTreesitterFallback = false,
      autoFold = {
        enabled = false,
      },
      foldKeymaps = {
        hOnlyOpensOnFirstColumn = true,
      },
    },
  },

  {
    "zbirenbaum/neodim",
    event = "LspAttach",
    opts = {
      alpha = 0.75,
      blend_color = "#000000",
      update_in_insert = {
        enable = true,
        delay = 100,
      },
      hide = {
        virtual_text = false,
        signs = false,
        underline = false,
      },
    },
  },

  {
    "Isrothy/neominimap.nvim",
    lazy = false,
    config = function() end,
    init = function()
      vim.g.neominimap = {
        auto_enable = false,
        layout = "split",
        split = {
          close_if_last_window = true,
        },
        git = {
          mode = "icon",
        },
        search = {
          enabled = true,
        },
        buf_filter = function(bufnr) return require("astrocore.buffer").is_valid(bufnr) end,
        winopt = function(opt, _)
          opt.signcolumn = "yes"
          opt.statuscolumn = "%s"
        end,
      }
    end,
    keys = {
      {
        "<Leader>um",
        "<Cmd>Neominimap Toggle<CR>",
        desc = "Toggle minimap",
      },
    },
  },

  {
    "HakonHarnes/img-clip.nvim",
    event = "User AstroFile",
    opts = {
      default = {
        verbose = false,
        embed_image_as_base64 = false,
        prompt_for_file_name = false,
        drag_and_drop = {
          insert_mode = true,
        },
      },
    },
  },

  {
    "andymass/vim-matchup",
    event = "User AstroFile",
    init = function()
      -- vim.g.matchup_matchparen_offscreen = { method = "popup", fullwidth = 1, highlight = "Normal", syntax_hl = 1 }
      vim.g.matchup_matchparen_offscreen = {}
      vim.g.matchup_transmute_enabled = 1
      vim.g.matchup_delim_noskips = 2

      -- vim.g.matchup_motion_enabled = 0
      vim.g.matchup_text_obj_enabled = 0
      -- vim.g.matchup_motion_cursor_end = 0

      vim.g.matchup_matchparen_nomode = "i"
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_hi_surround_always = 1
    end,
  },
}
