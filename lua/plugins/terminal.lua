return {
  "ryanmsnyder/toggleterm-manager.nvim",
  lazy = true,
  init = function(plugin) require("astrocore").on_load("telescope.nvim", plugin.name) end,
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    {
      "akinsho/toggleterm.nvim",
      config = function(_, opts)
        require("toggleterm").setup(opts)
        vim.api.nvim_create_autocmd("TermOpen", {
          group = vim.api.nvim_create_augroup("my_toggle_term", { clear = true }),
          pattern = "term://*toggleterm#*",
          callback = function(args)
            vim.keymap.set("t", "<C-n>", [[<C-\><C-n>]], {
              desc = "Normal mode",
              noremap = true,
              silent = true,
              buffer = args.buf,
            })
            vim.keymap.set({ "n", "t" }, "<C-q>", function() require("astrocore.buffer").close() end, {
              desc = "Close buffer",
              noremap = true,
              silent = true,
              buffer = args.buf,
            })
            vim.keymap.set({ "n", "t" }, "<C-t>", function() vim.cmd "hide" end, {
              desc = "Toggle buffer",
              noremap = true,
              silent = true,
              buffer = args.buf,
            })
          end,
        })
      end,
      opts = {
        open_mapping = false,
        float_opts = {
          border = "double",
          height = function(_) return vim.o.lines - 3 end,
          width = function(_) return vim.o.columns end,
        },
        highlights = {
          NormalFloat = {
            link = "NormalDark",
          },
        },
      },
    },
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<C-t>"] = { "<cmd>ToggleTerm<cr>" },
            ["<Leader>ts"] = { "<cmd>Telescope toggleterm_manager<cr>", desc = "Search Toggleterms" },
          },
          i = {
            ["<C-t>"] = { "<cmd>ToggleTerm<cr>" },
          },
        },
      },
    },
  },
  opts = function(_, opts)
    local term_icon = require("astroui").get_icon "Terminal"
    local toggleterm_manager = require "toggleterm-manager"
    local actions = toggleterm_manager.actions

    return require("astrocore").extend_tbl(opts, {
      titles = { prompt = term_icon .. " Terminals" },
      results = { term_icon = term_icon },
      mappings = {
        n = {
          ["<CR>"] = { action = actions.toggle_term, exit_on_action = true }, -- toggles terminal open/closed
          ["r"] = { action = actions.rename_term, exit_on_action = false }, -- provides a prompt to rename a terminal
          ["d"] = { action = actions.delete_term, exit_on_action = false }, -- deletes a terminal buffer
          ["n"] = { action = actions.create_term, exit_on_action = false }, -- creates a new terminal buffer
        },
        i = {
          ["<CR>"] = { action = actions.toggle_term, exit_on_action = true }, -- toggles terminal open/closed
          ["<C-r>"] = { action = actions.rename_term, exit_on_action = false }, -- provides a prompt to rename a terminal
          ["<C-d>"] = { action = actions.delete_term, exit_on_action = false }, -- deletes a terminal buffer
          ["<C-n>"] = { action = actions.create_term, exit_on_action = false }, -- creates a new terminal buffer
        },
      },
    })
  end,
}
