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
      { "tiagovla/scope.nvim" },
    },
    opts = function(_, opts)
      opts.buf_filter = function(bufnr)
        local buftype = vim.bo[bufnr].buftype
        if buftype == "help" then return true end
        if buftype ~= "" and buftype ~= "acwrite" then return false end
        if vim.api.nvim_buf_get_name(bufnr) == "" then return false end
        return require("astrocore.buffer").is_valid(bufnr)
      end
      opts.extensions = require("astrocore").extend_tbl(opts.extensions, { scope = {}, overseer = {} })
    end,
  },

  {
    "folke/edgy.nvim",
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
          size = { width = 36 },
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
        if filetype == "harpoon" then return false end
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
    "stevearc/oil.nvim",
    cmd = "Oil",
    specs = {
      {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<Leader>O"] = { function() require("oil").open() end, desc = "Open folder in Oil" },
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
              },
            },
          },
        },
      },
    },
    opts = function(_, opts)
      local get_icon = require("astroui").get_icon
      opts.columns = { { "icon", default_file = get_icon "DefaultFile", directory = get_icon "FolderClosed" } }
      opts.delete_to_trash = true
      opts.skip_confirm_for_simple_edits = true
      opts.view_options = {
        show_hidden = true,
      }
      opts.keymaps = {
        ["<C-s>"] = false,
        ["<C-h>"] = false,
      }
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
    dependencies = {
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
    event = "User AstroFile",
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
            local should_redirect = true

            if type(level) == "number" and level < vim.log.levels.ERROR then
              should_redirect = (title and string.find(title, "tinygit") or 0) ~= 0
            end

            if should_redirect and (title and (string.find(title, "Codeium") or 0) ~= 0) then -- exclude Codeium
              should_redirect = false
            end

            if should_redirect then
              return require("fidget.integration.nvim-notify").delegate(msg, level, opts) --
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
          return neowords.get_word_hops(
            neowords.pattern_presets.hex_color,
            "\\v[-]@![[:digit:][:lower:][:upper:]\\u0800-\\uffff]+", -- utf-8 words
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
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>zh"] = {
            "<Cmd>LiveServer<CR>",
            desc = "HTML Preview",
          }
        end,
      },
    },
  },

  {
    "echasnovski/mini.surround",
    keys = function(plugin, _)
      local opts = type(plugin.opts) == "function" and plugin.opts(plugin, {}) or plugin.opts or {}
      local mappings = opts.mappings or {}
      local insert = require("astrocore").list_insert_unique
      local keys = {}
      if mappings.add then insert(keys, { { mappings.add, desc = "Add surrounding", mode = { "n", "v" } } }) end
      if mappings.delete then insert(keys, { { mappings.delete, desc = "Delete surrounding" } }) end
      if mappings.replace then insert(keys, { { mappings.replace, desc = "Replace surrounding" } }) end
      if mappings.find then insert(keys, { { mappings.find, desc = "Find right surrounding" } }) end
      if mappings.find_left then insert(keys, { { mappings.find_left, desc = "Find left surrounding" } }) end
      return keys
    end,
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
        { "<C-p>", function() require("harpoon"):list():prev { ui_nav_wrap = true } end, desc = "Goto previous mark" },
        { "<C-n>", function() require("harpoon"):list():next { ui_nav_wrap = true } end, desc = "Goto next mark" },
        {
          prefix .. "e",
          function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,
          desc = "Toggle quick menu",
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
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          opts.mappings.n["<Leader>j"] = { "<Cmd>TSJToggle<CR>", desc = "Toggle Treesitter Join" }
        end,
      },
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
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          local prefix = "<Leader>o"
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
  },

  {
    "mistweaverco/kulala.nvim",
    ft = "http",
    opts = {
      winbar = true,
    },
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          opts.mappings.n["<Leader>zr"] = {
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
                      ["<Leader>zR"] = { desc = "Request" },
                      ["<Leader>zR<CR>"] = {
                        function() require("kulala").run() end,
                        desc = "Run current",
                      },
                      ["<Leader>zRr"] = {
                        function() require("kulala").replay() end,
                        desc = "Replay last",
                      },
                      ["<Leader>zRc"] = {
                        function() require("kulala").copy() end,
                        desc = "Copy as cURL",
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
  },

  {
    "echasnovski/mini.ai",
    event = "User AstroFile",
    opts = function(_, _)
      local gen_spec = require("mini.ai").gen_spec
      return {
        use_nvim_treesitter = false,
        n_lines = 1500,
        search_method = "cover",
        custom_textobjects = {
          ["c"] = gen_spec.treesitter {
            a = { "@conditional.outer", "@loop.outer" },
            i = { "@conditional.inner", "@loop.inner" },
          },
          ["f"] = gen_spec.treesitter { a = "@function.outer", i = "@function.inner" },
          ["g"] = function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line "$",
              col = math.max(vim.fn.getline("$"):len(), 1),
            }
            return { from = from, to = to }
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
      }
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
    "superappkid/hover.nvim",
    keys = {
      { "K", function() require("hover").hover() end, desc = "Hover cursor" },
    },
    opts = {
      init = function()
        -- Require providers
        require "hover.providers.dap"
        require "hover.providers.diagnostic"
        require "hover.providers.dictionary"
        require "hover.providers.fold_preview"
        -- require "hover.providers.gh"
        -- require "hover.providers.gh_user"
        -- require "hover.providers.jira"
        require "hover.providers.lsp"
        require "hover.providers.man"
      end,
      preview_opts = {
        border = "double",
      },
      -- What to do if hover() is called when a hover popup is already open:
      -- "cycle_providers" - cycle to the next enabled provider
      -- "focus" - move the cursor into the popup
      -- "preview_window" - move the popup contents to a :h preview-window
      -- "close" - close the popup
      -- "ignore" - do nothing
      multiple_hover = "focus",
    },
  },

  {
    "kwkarlwang/bufjump.nvim",
    lazy = true,
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          opts.mappings.n["<C-o>"] = { function() require("bufjump").backward_same_buf() end }
          opts.mappings.n["<C-i>"] = { function() require("bufjump").forward_same_buf() end }
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
    build = vim.fn.has "win32" == 0 and "./build" or ".\\build",
    event = "VeryLazy",
    opts = {
      log_level = "off", -- One of 'trace', 'debug', 'info', 'warn', 'error', 'off'
      editor = {
        image = "hidden", -- Image ID or URL in case a custom client id is provided
        client = "neovim", -- vim, neovim, lunarvim, nvchad, astronvim or your application's client id
        tooltip = "", -- Text to display when hovering over the editor's image
      },
      display = {
        show_repository = true, -- Display 'View repository' button linked to repository url, if any
      },
      text = {
        viewing = "Viewing...", -- Text to display when viewing a readonly file
        editing = "Editing...", -- Text to display when editing a file
        file_browser = "", -- Text to display when browsing files (Empty string to disable)
        plugin_manager = "", -- Text to display when managing plugins (Empty string to disable)
        lsp_manager = "", -- Text to display when managing LSP servers (Empty string to disable)
        vcs = "", -- Text to display when using Git or Git-related plugin (Empty string to disable)
        workspace = "{}", -- Text to display when in a workspace (Empty string to disable)
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
    "benlubas/molten-nvim",
    lazy = true,
    version = "^1", -- use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    specs = {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local prefix = "<leader>k"

        opts.mappings.n[prefix] = {
          desc = require("astroui").get_icon("planet", 1, true) .. "Kernel",
        }
        opts.mappings.n[prefix .. "mi"] = { "<Cmd>MoltenInit<CR>", desc = "Initialize the plugin" }
        opts.mappings.n[prefix .. "e"] = { "<Cmd>MoltenEvaluateOperator<CR>", desc = "Run operator selection" }
        opts.mappings.n[prefix .. "rl"] = { "<Cmd>MoltenEvaluateLine<CR>", desc = "Evaluate line" }
        opts.mappings.n[prefix .. "rr"] = { "<Cmd>MoltenReevaluateCell<CR>", desc = "Re-evaluate cell" }
        opts.mappings.v[prefix .. "r"] = { ":<C-u>MoltenEvaluateVisual<CR>gv", desc = "Evaluate visual selection" }
      end,
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
          defaults.mappings.n["<C-\\>"] = open_with_trouble
          defaults.mappings.i["<C-\\>"] = open_with_trouble
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
        { "<Leader>X", "<Cmd>Trouble diagnostics close<CR>", desc = "Close Trouble" },
        { prefix .. "X", "<Cmd>Trouble diagnostics toggle<CR>", desc = "Trouble Workspace Diagnostics" },
        { prefix .. "x", "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Trouble Document Diagnostics" },
        { prefix .. "L", "<Cmd>Trouble loclist toggle<CR>", desc = "Trouble Location List" },
        { prefix .. "Q", "<Cmd>Trouble quickfix toggle<CR>", desc = "Trouble Quickfix List" },
        { prefix .. "s", "<Cmd>Trouble symbols toggle<CR>", desc = "Trouble Symbols" },
        { prefix .. "l", "<Cmd>Trouble lsp toggle<CR>", desc = "Trouble LSP" },
      })
      if require("astrocore").is_available "todo-comments.nvim" then
        keys = require("astrocore").list_insert_unique(keys, {
          { prefix .. "t", "<Cmd>Trouble todo<CR>", desc = "Trouble Todo" },
          { prefix .. "T", "<Cmd>Trouble todo filter={tag={TODO,FIX,FIXME}}<CR>", desc = "Trouble Todo/Fix/Fixme" },
        })
      end
      return keys
    end,
    opts = function(_, opts)
      local get_icon = require("astroui").get_icon
      local lspkind_avail, lspkind = pcall(require, "lspkind")

      opts.keys = {
        ["<ESC>"] = "close",
        ["q"] = "close",
        ["<C-E>"] = "close",
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
          fold_open = get_icon "FoldOpened",
          fold_closed = get_icon "FoldClosed",
        },
        folder_closed = get_icon "FolderClosed",
        folder_open = get_icon "FolderOpen",
        kinds = lspkind_avail and lspkind.symbol_map,
      }
      opts.modes = opts.modes or {}
      opts.config = function(cfg)
        cfg.modes.symbols.focus = nil
        cfg.modes.symbols.win = nil
      end
    end,
  },
}
