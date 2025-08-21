---@type LazySpec
return {
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      local path = vim.fn.exepath "debugpy-adapter"
      if path == "" then path = vim.fn.exepath "python" end
      require("dap-python").setup(path, opts)
    end,
  },

  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    cmd = "VenvSelect",
    ft = "python",
    enabled = vim.fn.executable "fd" == 1 or vim.fn.executable "fdfind" == 1 or vim.fn.executable "fd-find" == 1,
    opts = function(_, _)
      require("astrocore").set_mappings {
        n = {
          ["<Leader>lv"] = { "<Cmd>VenvSelect<CR>", desc = "Select VirtualEnv" },
        },
      }
    end,
  },
}
