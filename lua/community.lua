-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

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
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
  { import = "astrocommunity.editing-support.telescope-undo-nvim" },
  { import = "astrocommunity.editing-support.vim-exchange" },
  { import = "astrocommunity.editing-support.vim-move" },

  { import = "astrocommunity.fuzzy-finder.telescope-nvim" },

  { import = "astrocommunity.game.leetcode-nvim" },
  {
    "kawre/leetcode.nvim",
    opts = {
      arg = "leetcode",
      lang = "golang",
    },
  },

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
        hint = table.concat({
          "  ^ ^        Options",
          "  ^",
          "  _v_ %{ve} virtual edit",
          "  _i_ %{list} invisible characters  ",
          "  _s_ %{spell} spell",
          "  _w_ %{wrap} wrap",
          "  _c_ %{cul} cursor line",
          "  _n_ %{nu} number",
          "  _r_ %{rnu} relative number",
          "  ^",
          "       ^^^^                _<Esc>_",
        }, "\n"),
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

  { import = "astrocommunity.quickfix.nvim-bqf" },

  { import = "astrocommunity.recipes.cache-colorscheme" },
  { import = "astrocommunity.recipes.astrolsp-no-insert-inlay-hints" },
  { import = "astrocommunity.recipes.vscode" },

  { import = "astrocommunity.scrolling.neoscroll-nvim" },
  { import = "astrocommunity.scrolling.mini-animate" },
  {
    "echasnovski/mini.animate",
    init = function(_)
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("mini.animate_ignore_filetypes", { clear = true }),
        desc = "disable mini.animate for filetypes",
        callback = function(args) vim.g.minianimate_disable = vim.bo[args.buf].ft == "snacks_dashboard" end,
      })
    end,
    opts = {
      scroll = { enable = false },
      open = { enable = false },
      close = { enable = false },
    },
  },
}
