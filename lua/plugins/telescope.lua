local prefix = "<Leader>f"

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

          maps.n[prefix .. "e"] = {
            "<Cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>",
            desc = "Open File browser",
          }
          maps.n[prefix .. "E"] = {
            "<Cmd>Telescope file_browser<CR>",
            desc = "Open File browser(CWD)",
          }

          maps.n["<Leader>fK"] = {
            "<Cmd>TextCaseOpenTelescope<CR>",
            desc = "select TextCase",
          }

          maps.n["<Leader>fy"] = {
            "<Cmd>Telescope neoclip<CR>",
            desc = "Find yanks (neoclip)",
          }

          maps.n["<Leader>fb"] = {
            function() require("telescope").extensions.scope.buffers() end,
            desc = "Open Scopes",
          }

          maps.n[prefix .. "c"] = {
            function(...) require("telescope-live-grep-args.shortcuts").grep_word_under_cursor(...) end,
            desc = "Find word under cursor",
          }
          maps.n[prefix .. "w"] = {
            function() require("telescope").extensions.live_grep_args.live_grep_args() end,
            desc = "Find words",
          }
          maps.n[prefix .. "W"] = {
            function()
              local args =
                require("astrocore").list_insert_unique({}, require("telescope.config").values.vimgrep_arguments)
              args = require("astrocore").list_insert_unique(args, { "--hidden", "--no-ignore" })

              require("telescope").extensions.live_grep_args.live_grep_args {
                vimgrep_arguments = args,
              }
            end,
            desc = "Find words in all files",
          }
        end,
      },
    },
    config = function(plugin, opts)
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
      defaults.mappings.i["<M-getApiRecordCR>"] = false
      defaults.mappings.n["<M-CR>"] = false

      opts.defaults = require("telescope.themes").get_ivy(defaults)

      require "astronvim.plugins.configs.telescope"(plugin, opts)
    end,
  },

  {
    "nvim-telescope/telescope-file-browser.nvim",
    lazy = true,
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
    lazy = true,
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
    lazy = true,
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    },
    config = function(_, opts)
      require("scope").setup(opts)
      require("telescope").load_extension "scope"
    end,
  },

  {
    "johmsalas/text-case.nvim",
    lazy = true,
    cmd = { "TextCaseOpenTelescope" },
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
    "AckslD/nvim-neoclip.lua",
    lazy = true,
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
  },
}
