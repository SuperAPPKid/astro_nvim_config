-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  { import = "astrocommunity.completion.cmp-cmdline" },
  { import = "astrocommunity.completion.cmp-git" },
  { import = "astrocommunity.completion.cmp-under-comparator" },

  { import = "astrocommunity.debugging.nvim-chainsaw" },
  {
    "chrisgrieser/nvim-chainsaw",
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          local prefix = "<Leader>L"
          local plugin = require "chainsaw"
          maps.n[prefix] = { desc = "󱂅 Logging" }
          maps.n[prefix .. "L"] = {
            function() plugin.variableLog() end,
            desc = "log the name and value for current variable",
          }
          maps.n[prefix .. "A"] = {
            function() plugin.assertLog() end,
            desc = "assertion statement under the cursor",
          }
          maps.n[prefix .. "l"] = {
            function() plugin.messageLog() end,
            desc = "create log under the cursor",
          }
          maps.n[prefix .. "t"] = {
            function() plugin.timelog() end,
            desc = "create time log",
          }
          maps.n[prefix .. "d"] = {
            function() plugin.removeLogs() end,
            desc = "remove all log created by chainsaw",
          }
        end,
      },
    },
  },

  -- { import = "astrocommunity.debugging.nvim-dap-virtual-text" },

  { import = "astrocommunity.editing-support.copilotchat-nvim" },
  { import = "astrocommunity.editing-support.cloak-nvim" },
  {
    "laytan/cloak.nvim",
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>zk"] = {
            "<Cmd>CloakToggle<CR>",
            desc = "Cloak",
          }
        end,
      },
    },
  },
  { import = "astrocommunity.editing-support.comment-box-nvim" },
  { import = "astrocommunity.editing-support.hypersonic-nvim" },
  {
    "tomiis4/Hypersonic.nvim",
    opts = {
      enable_cmdline = false,
    },
  },
  { import = "astrocommunity.editing-support.neogen" },
  { import = "astrocommunity.editing-support.nvim-treesitter-endwise" },
  { import = "astrocommunity.editing-support.nvim-regexplainer" },
  { import = "astrocommunity.editing-support.nvim-origami" },
  {
    "chrisgrieser/nvim-origami",
    opts = {
      keepFoldsAcrossSessions = false,
      hOnlyOpensOnFirstColumn = true,
    },
  },

  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
  { import = "astrocommunity.editing-support.telescope-undo-nvim" },
  { import = "astrocommunity.editing-support.vim-move" },
  { import = "astrocommunity.editing-support.wildfire-nvim" },

  { import = "astrocommunity.game.leetcode-nvim" },
  {
    "kawre/leetcode.nvim",
    opts = {
      arg = "leetcode",
      lang = "golang",
    },
  },

  { import = "astrocommunity.indent.indent-rainbowline" },

  { import = "astrocommunity.keybinding.hydra-nvim" },
  {
    "nvimtools/hydra.nvim",
    opts = function(_, opts)
      opts["Side scroll"] = {
        mode = "n",
        body = "z",
        heads = {
          { "h", "5zh", { desc = "" } },
          { "l", "5zl", { desc = "" } },
          { "H", "zH", { desc = "󰁎󱘹󱘹󱘹" } },
          { "L", "zL", { desc = "󱘹󱘹󱘹󰁕" } },
        },
      }
      opts["Options"] = {
        hint = [[
  ^ ^        Options
  ^
  _v_ %{ve} virtual edit
  _i_ %{list} invisible characters  
  _s_ %{spell} spell
  _w_ %{wrap} wrap
  _c_ %{cul} cursor line
  _n_ %{nu} number
  _r_ %{rnu} relative number
  ^
       ^^^^                _<Esc>_
]],
        config = {
          color = "amaranth",
          invoke_on_body = true,
          hint = {
            float_opts = {
              border = "double",
            },
            position = "middle",
          },
        },
        mode = "n",
        body = "<Leader>uo",
        heads = {
          {
            "n",
            function()
              if vim.o.number == true then
                vim.o.number = false
              else
                vim.o.number = true
              end
            end,
            { desc = "number" },
          },
          {
            "r",
            function()
              if vim.o.relativenumber == true then
                vim.o.relativenumber = false
              else
                vim.o.number = true
                vim.o.relativenumber = true
              end
            end,
            { desc = "relativenumber" },
          },
          {
            "v",
            function()
              if vim.o.virtualedit == "all" then
                vim.o.virtualedit = "block"
              else
                vim.o.virtualedit = "all"
              end
            end,
            { desc = "virtualedit" },
          },
          {
            "i",
            function()
              if vim.o.list == true then
                vim.o.list = false
              else
                vim.o.list = true
              end
            end,
            { desc = "show invisible" },
          },
          {
            "s",
            function()
              if vim.o.spell == true then
                vim.o.spell = false
              else
                vim.o.spell = true
              end
            end,
            { desc = "spell" },
          },
          {
            "w",
            function()
              if vim.o.wrap ~= true then
                vim.o.wrap = true
                -- Dealing with word wrap:
                -- If cursor is inside very long line in the file than wraps
                -- around several rows on the screen, then 'j' key moves you to
                -- the next line in the file, but not to the next row on the
                -- screen under your previous position as in other editors. These
                -- bindings fixes this.
                vim.keymap.set(
                  "n",
                  "k",
                  function() return vim.v.count > 0 and "k" or "gk" end,
                  { expr = true, desc = "k or gk" }
                )
                vim.keymap.set(
                  "n",
                  "j",
                  function() return vim.v.count > 0 and "j" or "gj" end,
                  { expr = true, desc = "j or gj" }
                )
              else
                vim.o.wrap = false
                vim.keymap.del("n", "k")
                vim.keymap.del("n", "j")
              end
            end,
            { desc = "wrap" },
          },
          {
            "c",
            function()
              if vim.o.cursorline == true then
                vim.o.cursorline = false
              else
                vim.o.cursorline = true
              end
            end,
            { desc = "cursor line" },
          },
          { "<Esc>", nil, { exit = true } },
        },
      }
    end,
  },

  { import = "astrocommunity.lsp.nvim-lsp-file-operations" },

  { import = "astrocommunity.media.codesnap-nvim" },
  {
    "mistricky/codesnap.nvim",
    opts = {
      save_path = "~/Desktop",
      has_breadcrumbs = true,
      has_line_number = true,
      watermark = "",
      bg_theme = "sea",
    },
  },

  { import = "astrocommunity.neovim-lua-development.helpview-nvim" },

  -- { import = "astrocommunity.programming-language-support.csv-vim" },
  -- { import = "astrocommunity.programming-language-support.nvim-jqx" },
  -- { import = "astrocommunity.programming-language-support.rest-nvim" },

  { import = "astrocommunity.quickfix.nvim-bqf" },

  { import = "astrocommunity.recipes.cache-colorscheme" },
  {
    import = "astrocommunity.recipes.heirline-vscode-winbar",
    enabled = function() return vim.fn.has "nvim-0.10" ~= 1 end,
  },
  { import = "astrocommunity.recipes.astrolsp-no-insert-inlay-hints" },
  { import = "astrocommunity.recipes.vscode" },

  { import = "astrocommunity.scrolling.neoscroll-nvim" },
  { import = "astrocommunity.scrolling.mini-animate" },
  {
    "echasnovski/mini.animate",
    opts = {
      scroll = { enable = false },
    },
  },

  {
    import = "astrocommunity.utility.neodim",
    enabled = function() return vim.fn.has "nvim-0.10" == 1 end,
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

  -- { import = "astrocommunity.worflow.hardtime-nvim" },
}
