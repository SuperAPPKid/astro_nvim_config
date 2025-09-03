local lsp_opts
---@type LazySpec
return {
  {
    "akinsho/flutter-tools.nvim",
    ft = "dart",
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
      {
        "AstroNvim/astrolsp",
        opts = function(_, opts)
          opts.servers = require("astrocore").list_insert_unique(opts.servers, { "dartls" })
          local default_handler = opts.handlers[1]
          opts.handlers.dartls = function(server, handler_opts)
            handler_opts.autostart = false
            default_handler(server, handler_opts)
            lsp_opts = handler_opts
          end
        end,
      },
    },
    init = function(_)
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("dart_setting", { clear = true }),
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
      local path = require "flutter-tools.utils.path"
      vim.opt_local.comments = [[sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,:///,://]]
      vim.opt_local.commentstring = [[//%s]]
      vim.opt.includeexpr = "v:lua.require('flutter-tools.resolve_url').resolve_url(v:fname)"
      local full_path = vim.fn.expand "%:p"
      -- Prevent writes to files in the pub cache and FVM folder.
      if path.is_flutter_dependency_path(full_path) then vim.opt_local.modifiable = false end

      if not lsp_opts then require("astrolsp").lsp_setup "dartls" end
      opts = require("astrocore").extend_tbl(opts, { lsp = lsp_opts, debugger = { enabled = true } })
      require("flutter-tools").setup(opts)
      require("telescope").load_extension "flutter"

      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function() require("flutter-tools.lsp").attach() end,
        once = true,
      })
    end,
    opts = {
      ui = { border = "double" },
      widget_guides = { enabled = true },
      dev_log = { enabled = false },
    },
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
