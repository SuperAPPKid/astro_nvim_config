---@type LazySpec
return {
  {
    "akinsho/flutter-tools.nvim",
    ft = "dart",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
      {
        "AstroNvim/astrolsp",
        opts = function(_, opts) opts.servers = require("astrocore").list_insert_unique(opts.servers, { "dartls" }) end,
      },
    },
    init = function(_)
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("dart_mappings", { clear = true }),
        desc = "Add map for dart",
        pattern = "dart",
        callback = function(args)
          require("astrocore").set_mappings({
            n = {
              ["<Leader>zz"] = { "<Cmd>Telescope flutter commands<CR>", desc = "Flutter commands" },
            },
          }, { buffer = args.buf })
        end,
      })
    end,
    config = function(_, opts)
      require("flutter-tools").setup(opts)
      require("telescope").load_extension "flutter"
    end,
    opts = function(_, opts)
      local astrolsp_avail, astrolsp = pcall(require, "astrolsp")
      if astrolsp_avail then
        opts.debugger = { enabled = true }
        opts.lsp = astrolsp.lsp_opts "dartls"
      end
      opts.ui = { border = "double" }
      opts.widget_guides = { enabled = true }
      opts.dev_log = { enabled = false }
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      -- HACK: Disables the select treesitter textobjects because the Dart treesitter parser is very inefficient. Hopefully this gets fixed and this block can be removed in the future.
      -- Reference: https://github.com/AstroNvim/AstroNvim/issues/2707
      local select = vim.tbl_get(opts, "textobjects", "select")
      if select then select.disable = require("astrocore").list_insert_unique(select.disable, { "dart" }) end
    end,
  },
}
