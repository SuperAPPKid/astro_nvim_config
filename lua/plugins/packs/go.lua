---@type LazySpec
---@diagnostic disable: inject-field
return {
  {
    "leoluz/nvim-dap-go",
    ft = { "go", "gomod", "gosum", "gowork" },
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap").configurations.go = {}
      require("dap-go").setup(opts)

      local old_adaptor = require("dap").adapters.go
      require("dap").adapters.go = function(callback, config)
        if not config.outputMode then config.outputMode = "remote" end
        old_adaptor(callback, config)
      end
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
