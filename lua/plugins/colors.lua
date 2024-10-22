return {
  { "NvChad/nvim-colorizer.lua", enabled = false },
  {
    "uga-rosa/ccc.nvim",
    tag = "v1.7.2",
    event = "User AstroFile",
    keys = {
      { "<Leader>zc", "<Cmd>CccConvert<CR>", desc = "Convert color" },
      { "<Leader>zp", "<Cmd>CccPick<CR>", desc = "Pick Color" },
    },
    config = function(_, opts)
      require("ccc").setup(opts)
      vim.api.nvim_del_user_command "CccHighlighterEnable"
      vim.api.nvim_del_user_command "CccHighlighterDisable"
      vim.api.nvim_del_user_command "CccHighlighterToggle"
    end,
    opts = {
      highlighter = {
        auto_enable = false,
        lsp = true,
      },
    },
  },

  {
    "brenoprata10/nvim-highlight-colors",
    event = "User AstroFile",
    keys = {
      {
        "<Leader>uC",
        function() vim.cmd.HighlightColors "Toggle" end,
        desc = "Toggle color highlight",
      },
    },
    opts = {
      render = "virtual",
      virtual_symbol = "󰚍",
      enable_tailwind = true,
    },
  },
}
