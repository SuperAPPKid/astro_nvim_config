return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  version = false,
  dependencies = {
    "nvim-telescope/telescope-dap.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        local prefix = "<Leader>f"

        maps.n[prefix .. "e"] = {
          "<Cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>",
          desc = "Open File browser",
        }

        maps.n[prefix .. "E"] = {
          "<Cmd>Telescope file_browser<CR>",
          desc = "Open File browser(CWD)",
        }

        if vim.fn.executable "rg" == 1 then
          maps.n[prefix .. "c"] = {
            require("telescope-live-grep-args.shortcuts").grep_word_under_cursor,
            desc = "Find word under cursor",
          }
          maps.n[prefix .. "w"] = {
            function() require("telescope").extensions.live_grep_args.live_grep_args() end,
            desc = "Find words",
          }

          local args = require("astrocore").list_insert_unique({}, require("telescope.config").values.vimgrep_arguments)
          args = require("astrocore").list_insert_unique(args, { "--hidden", "--no-ignore" })
          maps.n[prefix .. "W"] = {
            function()
              require("telescope").extensions.live_grep_args.live_grep_args {
                vimgrep_arguments = args,
              }
            end,
            desc = "Find words in all files",
          }
        end
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

    opts.extensions = {
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
      live_grep_args = {
        auto_quoting = true, -- enable/disable auto-quoting
        mappings = { -- extend mappings
          i = {
            ["<C-q>"] = require("telescope-live-grep-args.actions").quote_prompt { postfix = " " },
          },
        },
      },
    }

    require "astronvim.plugins.configs.telescope"(plugin, opts)
    require("telescope").load_extension "dap"
    require("telescope").load_extension "file_browser"
    require("telescope").load_extension "live_grep_args"
  end,
}
