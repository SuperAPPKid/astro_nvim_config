local prefix = "<Leader>f"
local plugin_prefix = "<Leader>p"

---@type LazySpec
return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    version = false,
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>f<CR>"] =
            { function() require("telescope.builtin").pickers() end, desc = "Opens cached pickers" }
          maps.n["<Leader>f`"] = { function() require("telescope.builtin").marks() end, desc = "Find marks" }
          maps.n['<Leader>f"'] = { function() require("telescope.builtin").registers() end, desc = "Find registers" }
          maps.n["<Leader>fd"] = {
            function() require("telescope.builtin").diagnostics() end,
            desc = "Search diagnostics",
          }
          maps.n["<Leader>fF"] = {
            function()
              require("telescope.builtin").find_files { hidden = true, no_ignore = true, file_ignore_patterns = {} }
            end,
            desc = "Find all files",
          }
          maps.n["<Leader>fH"] = {
            function() require("telescope.builtin").highlights() end,
            desc = "Find Highlight",
          }
          maps.n["<Leader>fM"] = {
            function() require("telescope.builtin").man_pages() end,
            desc = "Find man",
          }
          maps.n["<Leader>fT"] = {
            function() require("telescope.builtin").colorscheme { enable_preview = true } end,
            desc = "Find themes",
          }
          maps.n["<Leader>fn"] = {
            function()
              local notifs = {}
              for _, item in ipairs(Snacks.notifier.get_history { reverse = true }) do
                notifs[#notifs + 1] = {
                  text = Snacks.picker.util.text(item, { "level", "title", "msg" }),
                  item = item,
                  severity = item.level,
                  preview = {
                    text = item.msg,
                    ft = "markdown",
                  },
                }
              end

              local entry_display = require "telescope.pickers.entry_display"
              local pickers = require "telescope.pickers"
              local finders = require "telescope.finders"
              local config = require "telescope.config"
              local actions = require "telescope.actions"
              local action_state = require "telescope.actions.state"
              local previewers = require "telescope.previewers"

              local finder_tbl = {
                results = notifs,
                entry_maker = function(notif)
                  return {
                    value = notif,
                    display = function()
                      local align = Snacks.picker.util.align
                      local ret = {} ---@type snacks.picker.Highlight[]
                      local item = notif.item ---@type snacks.notifier.Notif
                      local date = os.date("%R", item.added)

                      ret[#ret + 1] = { align(tostring(date), 5), "SnacksPickerTime" }

                      local severity = notif.severity
                      severity = type(severity) == "number" and vim.diagnostic.severity[severity] or severity
                      if severity then
                        local lower = severity:lower()
                        local cap = severity:sub(1, 1):upper() .. lower:sub(2)
                        ret[#ret + 1] = { lower:upper(), "Diagnostic" .. cap, virtual = true }
                      end

                      ret[#ret + 1] = { align(item.title or "", 15), "SnacksNotifierHistoryTitle" }

                      Snacks.picker.highlight.markdown(ret)

                      return entry_display.create {
                        separator = " ",
                        items = ret,
                      }(ret)
                    end,
                    ordinal = notif.text,
                  }
                end,
              }

              local previewer = {
                define_preview = function(self, entry, status)
                  local txts = vim.split(entry.value.preview.text, "\n")
                  vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, txts)

                  vim.api.nvim_set_option_value("filetype", entry.value.preview.ft, { buf = self.state.bufnr })
                  vim.api.nvim_set_option_value("wrap", true, { win = status.preview_win })
                end,
              }

              pickers
                .new({
                  results_title = "Notifications",
                  prompt_title = "Filter Notifications",
                  finder = finders.new_table(finder_tbl),
                  sorter = config.values.generic_sorter(),
                  attach_mappings = function(prompt_buf, _)
                    actions.select_default:replace(function()
                      actions.close(prompt_buf)
                      local selection = action_state.get_selected_entry()
                      if selection == nil then return end
                      local notif = selection.value
                      Snacks.notifier.show_history {
                        filter = function(item) return item.id == notif.item.id end,
                      }
                    end)
                    return true
                  end,
                  previewer = previewers.new_buffer_previewer(previewer),
                }, {})
                :find()
            end,
            desc = "Find notifications",
          }

          if vim.fn.executable "git" == 1 then
            maps.n["<Leader>gr"] = {
              function() require("telescope.builtin").git_branches { use_file_path = true } end,
              desc = "Git Branches",
            }
            maps.n["<Leader>gc"] = {
              "<Nop>",
              desc = "Git Commits",
            }
            maps.n["<Leader>gcc"] = {
              function() require("telescope.builtin").git_bcommits { use_file_path = true } end,
              desc = "Git Commits (current file)",
            }
            maps.n["<Leader>gcC"] = {
              function() require("telescope.builtin").git_commits { use_file_path = true } end,
              desc = "Git Commits (repository)",
            }
            maps.n["<Leader>gs"] = {
              function() require("telescope.builtin").git_status { use_file_path = true } end,
              desc = "Git Status",
            }
          end
        end,
      },
    },
    opts = function(_, opts)
      local defaults = opts.defaults
      defaults.layout_config = {
        height = math.max(math.floor(vim.o.lines * 0.6), 25),
      }
      defaults.borderchars = {
        prompt = { "─", "│", " ", "│", "╭", "╮", " ", " " },
        results = { " ", "│", "─", "│", "│", "│", "┘", "└" },
        preview = { "─", "│", "─", "│", "╭", "┤", "┘", "└" },
      }
      defaults.prompt_prefix = " "
      defaults.entry_prefix = " "
      defaults.selection_caret = " "
      defaults.selection_strategy = "reset"
      defaults.cache_picker = {
        num_pickers = -1,
        ignore_empty_prompt = true,
      }

      defaults.mappings.i["<C-l>"] = false
      defaults.mappings.n["<C-v>"] = false
      defaults.mappings.i["<C-v>"] = false
      defaults.mappings.n["<C-\\>"] = "select_vertical"
      defaults.mappings.i["<C-\\>"] = "select_vertical"

      opts.defaults = require("telescope.themes").get_ivy(defaults)
    end,
  },

  {
    "nvim-telescope/telescope-file-browser.nvim",
    keys = {
      { prefix .. "e", "<Cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>", desc = "Open File browser" },
      { prefix .. "E", "<Cmd>Telescope file_browser<CR>", desc = "Open File browser(CWD)" },
    },
    dependencies = {
      {
        "nvim-telescope/telescope.nvim",
        opts = {
          extensions = {
            file_browser = {
              grouped = true,
              hidden = {
                file_browser = true,
                folder_browser = true,
              },
              no_ignore = true,
              prompt_path = true,
              quiet = true,
            },
          },
        },
      },
    },
    config = function(_, _) require("telescope").load_extension "file_browser" end,
  },

  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    enable = vim.fn.executable "rg" == 1,
    keys = {
      {
        prefix .. "c",
        function(...) require("telescope-live-grep-args.shortcuts").grep_word_under_cursor(...) end,
        desc = "Find word under cursor",
      },
      {
        prefix .. "w",
        function() require("telescope").extensions.live_grep_args.live_grep_args() end,
        desc = "Find words",
      },
      {
        prefix .. "W",
        function()
          local args = require("astrocore").list_insert_unique({}, require("telescope.config").values.vimgrep_arguments)
          args = require("astrocore").list_insert_unique(args, { "--hidden", "--no-ignore" })
          require("telescope").extensions.live_grep_args.live_grep_args {
            vimgrep_arguments = args,
          }
        end,
        desc = "Find words in all files",
      },
    },
    specs = {
      {
        "Astronvim/astrocore",
        opts = function(_, opts)
          opts.mappings.n[prefix .. "c"] = false
          opts.mappings.n[prefix .. "w"] = false
          opts.mappings.n[prefix .. "W"] = false
        end,
      },
    },
    dependencies = {
      {
        "nvim-telescope/telescope.nvim",
        opts = {
          extensions = {
            live_grep_args = {
              auto_quoting = true, -- enable/disable auto-quoting
              mappings = { -- extend mappings
                i = {
                  ["<C-w>"] = function(...)
                    local quote_prompt = require("telescope-live-grep-args.actions").quote_prompt { postfix = " " }
                    return quote_prompt(...)
                  end,
                },
              },
            },
          },
        },
      },
    },
    config = function(_, _) require("telescope").load_extension "live_grep_args" end,
  },


  {
    "AckslD/nvim-neoclip.lua",
    event = "User AstroFile",
    keys = {
      { "<Leader>fy", "<Cmd>Telescope neoclip<CR>", desc = "Find yanks (neoclip)" },
      { "<Leader>fm", "<Cmd>Telescope macroscope<CR>", desc = "Find macros (neoclip)" },
    },
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
      { "kkharji/sqlite.lua" },
    },
    opts = function(_, opts)
      local function is_whitespace(line) return vim.fn.match(line, [[^\s*$]]) ~= -1 end

      local function all(tbl, check)
        for _, entry in ipairs(tbl) do
          if not check(entry) then return false end
        end
        return true
      end

      opts.filter = function(data) return not all(data.event.regcontents, is_whitespace) end
      opts.default_register = "*"
      opts.default_register_macros = "q"
      opts.enable_persistent_history = true
      opts.on_select = {
        move_to_front = true,
      }
      opts.on_paste = {
        move_to_front = true,
      }
      opts.on_replay = {
        move_to_front = true,
      }
      opts.keys = opts.keys or {}
      opts.keys.telescope = {
        i = {
          select = "<CR>",
          paste = false,
          paste_behind = false,
          replay = "<C-q>", -- replay a macro
          delete = "<C-d>", -- delete an entry
          edit = "<C-e>", -- edit an entry
        },
        n = {
          select = "<CR>",
          paste = "p",
          -- paste = { 'p', '<c-p>' }, -- It is possible to map to more than one key.
          paste_behind = "P",
          replay = "q",
          delete = "d",
          edit = "e",
        },
      }
    end,
    config = function(_, opts)
      require("neoclip").setup(opts)
      require("telescope").load_extension "neoclip"
    end,
  },

  {
    "warpaint9299/nvim-devdocs",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    cmd = {
      "DevdocsFetch",
      "DevdocsInstall",
      "DevdocsUninstall",
      "DevdocsUpdate",
      "DevdocsUpdateAll",
      "DevdocsOpenFloat",
      "DevdocsOpenCurrentFloat",
    },
    keys = {
      { prefix .. "D", "<Cmd>DevdocsOpenFloat<CR>", desc = "Find Devdocs" },
    },
    opts = {
      -- previewer_cmd = vim.fn.executable "glow" == 1 and "glow" or nil,
      cmd_args = { "-s", "dark", "-w", "80" },
      picker_cmd = true,
      picker_cmd_args = { "-p" },
      filetypes = {
        typescript = { "node", "javascript", "typescript" },
      },
      float_win = { -- passed to nvim_open_win(), see :h api-floatwin
        relative = "editor",
        width = vim.o.columns,
        height = vim.o.lines - 4,
        border = "double",
      },
      wrap = true,
      mappings = {
        open_in_browser = "<CR>",
      },
      after_open = function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", true)
      end,
    },
  },

  {
    "tsakirist/telescope-lazy.nvim",
    keys = {
      { plugin_prefix .. "R", "<Cmd>Telescope lazy<CR>", desc = "Plugins README" },
    },
    config = function(_, _) require("telescope").load_extension "lazy" end,
  },
}
