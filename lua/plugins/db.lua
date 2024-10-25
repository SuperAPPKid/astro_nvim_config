---@type LazySpec
--- pgsql: brew install libpq && brew link --force libpq
--- mongo: brew install mongosh
--- redis: brew install redis
return {
  {
    "kristijanhusak/vim-dadbod-ui",
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          opts.autocmds = require("astrocore").extend_tbl(opts.autocmds, {
            dadbod_settings = {
              {
                event = "FileType",
                desc = "dbout mappings",
                pattern = "dbout",
                callback = function(args)
                  require("astrocore").set_mappings({
                    n = {
                      ["q"] = { function() vim.cmd "bdelete!" end },
                      ["<Leader>zz"] = { desc = "DBUI CMD" },
                      ["<Leader>zzH"] = { "<Plug>(DBUI_YankHeader)", desc = "DBUI: Copy Header" },
                      ["<Leader>zzc"] = { "<Plug>(DBUI_ToggleResultLayout)", desc = "DBUI: Toggle Column" },
                      ["<Leader>zzf"] = { "<Plug>(DBUI_JumpToForeignKey)", desc = "DBUI: Jump to ForeignKey" },
                    },
                  }, { buffer = args.buf })
                end,
              },
              {
                event = "FileType",
                desc = "dbui mappings",
                pattern = "dbui",
                callback = function(args)
                  require("astrocore").set_mappings({
                    n = {
                      ["<CR>"] = { "<Plug>(DBUI_SelectLine)" },
                      ["d"] = { "<Plug>(DBUI_DeleteLine)" },
                      ["a"] = { "<Plug>(DBUI_AddConnection)" },
                      ["r"] = { "<Plug>(DBUI_RenameLine)" },
                      ["R"] = { "<Plug>(DBUI_Redraw)" },
                      ["J"] = { "<Plug>(DBUI_GotoNextSibling)" },
                      ["K"] = { "<Plug>(DBUI_GotoPrevtSibling)" },
                      ["h"] = { "<Plug>(DBUI_GotoParentNode)" },
                      ["<Leader>zz"] = { desc = "DBUI CMD" },
                      ["<Leader>zz?"] = { "<Plug>(DBUI_ToggleDetails)", desc = "DBUI: Drawer Details" },
                    },
                  }, {
                    buffer = args.buf,
                  })
                end,
              },
              {
                event = "FileType",
                desc = "dbui query mappings",
                pattern = { "mysql", "plsql", "sql" },
                callback = function(args)
                  vim.api.nvim_set_option_value("buflisted", true, { buf = arg.buf })

                  require("astrocore").set_mappings({
                    n = {
                      ["<Leader>zz"] = { desc = "DBUI CMD" },
                      ["<Leader>zze"] = { "<Plug>(DBUI_EditBindParameters)", desc = "DBUI: Edit Parameter" },
                      ["<Leader>zzs"] = { "<Plug>(DBUI_SaveQuery)", desc = "DBUI: Save Query" },
                      ["<Leader>zz<CR>"] = { "<Plug>(DBUI_ExecuteQuery)", desc = "DBUI: Execute Query" },
                    },
                    v = {
                      ["<Leader>zz"] = { desc = "DBUI CMD" },
                      ["<Leader>zz<CR>"] = { "<Plug>(DBUI_ExecuteQuery)" },
                    },
                  }, {
                    buffer = args.buf,
                  })
                end,
              },
            },
          })
        end,
      },
    },
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
      vim.g.db_ui_show_help = 0
      vim.g.db_ui_disable_mappings = 1
      vim.g.db_ui_use_nvim_notify = 1
      require("cmp").setup.filetype({ "sql", "mysql", "plsql" }, {
        sources = {
          { name = "vim-dadbod-completion" },
        },
      })
    end,
    keys = {
      { "<Leader>D", "<Cmd>DBUIToggle<CR>", desc = "Toggle DB-UI" },
    },
  },
}
