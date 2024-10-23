---@type LazySpec
--- pgsql: brew install libpq && brew link --force libpq
--- mongo: brew install mongosh
--- redis: brew install redis
return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod" },
      {
        "hrsh7th/nvim-cmp",
        dependencies = {
          { "kristijanhusak/vim-dadbod-completion" },
        },
      },
    },
    config = function(_, _)
      vim.g.db_use_nerd_fonts = vim.g.icons_enabled and 1 or nil
      require("cmp").setup.buffer { sources = { { name = "vim-dadbod-completion" } } }
    end,
    keys = {
      { "<Leader>D", "<Cmd>DBUIToggle<CR>", desc = "Toggle DB-UI" },
    },
  },
}
