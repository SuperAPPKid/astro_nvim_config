---@type LazySpec
return {
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      local path = vim.fn.exepath "python"
      local debugpy = require("mason-registry").get_package "debugpy"
      if debugpy:is_installed() then
        path = vim.fn.expand "$MASON/packages/debugpy"
        if vim.fn.has "win32" == 1 then
          path = path .. "/venv/Scripts/python"
        else
          path = path .. "/venv/bin/python"
        end
      end
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
