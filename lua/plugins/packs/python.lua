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
    cmd = "VenvSelect",
    ft = "python",
    enabled = vim.fn.executable "fd" == 1 or vim.fn.executable "fdfind" == 1 or vim.fn.executable "fd-find" == 1,
    init = function(_)
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("venv_mappings", { clear = true }),
        desc = "Add map for venv",
        pattern = "python",
        callback = function(args)
          require("astrocore").set_mappings({
            n = {
              ["<Leader>zz"] = { "<Cmd>VenvSelect<CR>", desc = "Select VirtualEnv" },
            },
          }, { buffer = args.buf })
        end,
      })
    end,
    config = true,
  },
}
