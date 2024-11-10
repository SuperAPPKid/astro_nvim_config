---@type LazySpec
return {
  {
    "leoluz/nvim-dap-go",
    ft = { "go", "gomod", "gosum", "gowork" },
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap").configurations.go = {}
      require("dap-go").setup(opts)
    end,
  },

  {
    "olexsmir/gopher.nvim",
    ft = "go",
    build = function()
      if not require("lazy.core.config").spec.plugins["mason.nvim"] then
        vim.print "Installing go dependencies..."
        vim.cmd.GoInstallDeps()
      end
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "williamboman/mason.nvim",
    },
    config = true,
  },
}
