local prefix = "<Leader>f"

---@type LazySpec
return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    version = false,
    dependencies = {
      { "stevearc/dressing.nvim" },
    },
    config = function(plugin, opts)
      require "astronvim.plugins.configs.telescope"(plugin, opts)
      require("dressing").setup {
        select = {
          telescope = opts.defaults,
        },
      }
    end,
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
      defaults.selection_caret = " "
      defaults.entry_prefix = " "
      defaults.selection_strategy = "reset"
      defaults.mappings.i["<C-L>"] = false
      defaults.mappings.i["<M-CR>"] = false
      defaults.mappings.n["<M-CR>"] = false

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
                  ["<C-q>"] = function(...)
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
    "tiagovla/scope.nvim",
    keys = {
      { "<Leader>fb", function() require("telescope").extensions.scope.buffers() end, desc = "Open Scopes" },
    },
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    },
    config = function(_, opts)
      require("scope").setup(opts)
      require("telescope").load_extension "scope"
    end,
  },

  {
    "AckslD/nvim-neoclip.lua",
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
    "ryanmsnyder/toggleterm-manager.nvim",
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          opts.mappings.n["<Leader>fs"] = { "<Cmd>Telescope toggleterm_manager<CR>", desc = "Search Toggleterms" }
        end,
      },
    },
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { prefix .. "s", "<Cmd>Telescope toggleterm_manager<CR>", desc = "Search Toggleterms" },
    },
    config = function(_, opts)
      require("toggleterm-manager").setup(opts)
      require("telescope").load_extension "toggleterm_manager"
    end,
    opts = function(_, opts)
      local term_icon = require("astroui").get_icon "Terminal"
      opts.titles = { prompt = term_icon .. " Terminals" }
      opts.results = { term_icon = term_icon }
      opts.mappings = {
        n = {
          ["<CR>"] = { -- toggles terminal open/closed
            action = function(...) require("toggleterm-manager").actions.toggle_term(...) end,
            exit_on_action = true,
          },
          ["<C-r>"] = { -- provides a prompt to rename a terminal
            action = function(...) require("toggleterm-manager").actions.rename_term(...) end,
            exit_on_action = false,
          },
          ["<C-d>"] = { -- deletes a terminal buffer
            action = function(...) require("toggleterm-manager").actions.delete_term(...) end,
            exit_on_action = false,
          },
          ["<C-n>"] = { -- creates a new terminal buffer
            action = function(...) require("toggleterm-manager").actions.create_term(...) end,
            exit_on_action = false,
          },
        },
        i = {
          ["<CR>"] = { -- toggles terminal open/closed
            action = function(...) require("toggleterm-manager").actions.toggle_term(...) end,
            exit_on_action = true,
          },
          ["<C-r>"] = { -- provides a prompt to rename a terminal
            action = function(...) require("toggleterm-manager").actions.rename_term(...) end,
            exit_on_action = false,
          },
          ["<C-d>"] = { -- deletes a terminal buffer
            action = function(...) require("toggleterm-manager").actions.delete_term(...) end,
            exit_on_action = false,
          },
          ["<C-n>"] = { -- creates a new terminal buffer
            action = function(...) require("toggleterm-manager").actions.create_term(...) end,
            exit_on_action = false,
          },
        },
      }
    end,
  },
}
