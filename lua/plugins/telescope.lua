return {
  "nvim-telescope/telescope.nvim",
  version = false,
  dependencies = {
    { "nvim-telescope/telescope-dap.nvim" },
    {
      "nvim-telescope/telescope-file-browser.nvim",
      config = function()
        require("telescope").setup {
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
        }
      end,
    },
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      config = function()
        local lga_actions = require "telescope-live-grep-args.actions"
        local actions = require "telescope.actions"

        require("telescope").setup {
          extensions = {
            live_grep_args = {
              auto_quoting = true, -- enable/disable auto-quoting
              mappings = { -- extend mappings
                i = {
                  ["<C-k>"] = lga_actions.quote_prompt(),
                  ["<C-i>"] = lga_actions.quote_prompt { postfix = " --iglob " },
                  -- freeze the current list and start a fuzzy search in the frozen list
                  ["<C-space>"] = actions.to_fuzzy_refine,
                },
              },
            },
          },
        }
      end,
    },
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        local prefix = "<leader>f"

        maps.n[prefix .. "e"] = {
          "<Cmd>:Telescope file_browser<CR>",
          desc = "Open File browser",
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
          maps.n[prefix .. "W"] = {
            function()
              require("telescope").extensions.live_grep_args.live_grep_args {
                additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
              }
            end,
            desc = "Find words in all files",
          }
        end

        local dap_prefix = "<leader>df"
        maps.n[dap_prefix] = {
          desc = "DAP Funcs",
        }
        maps.n[dap_prefix .. "c"] = {
          "<Cmd>lua require('telescope').extensions.dap.commands()<CR>",
          desc = "Telescope DAP commands",
        }
        maps.n[dap_prefix .. "f"] = {
          "<Cmd>lua require('telescope').extensions.dap.frames()<CR>",
          desc = "Telescope DAP frames",
        }
        maps.n[dap_prefix .. "g"] = {
          "<Cmd>lua require('telescope').extensions.dap.configurations()<CR>",
          desc = "Telescope DAP configurations",
        }
        maps.n[dap_prefix .. "l"] = {
          "<Cmd>lua require('telescope').extensions.dap.list_breakpoints()<CR>",
          desc = "Telescope DAP list breakpoints",
        }
        maps.n[dap_prefix .. "v"] = {
          "<Cmd>lua require('telescope').extensions.dap.variables()<CR>",
          desc = "Telescope DAP variables",
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
    opts.defaults = require("telescope.themes").get_ivy(defaults)

    require "astronvim.plugins.configs.telescope"(plugin, opts)
    require("telescope").load_extension "dap"
    require("telescope").load_extension "file_browser"
    require("telescope").load_extension "live_grep_args"
  end,
}
