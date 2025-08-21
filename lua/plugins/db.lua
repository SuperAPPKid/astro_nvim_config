---@type LazySpec
--- pgsql: brew install libpq && brew link --force libpq
--- mongo: brew install mongosh
--- redis: brew install redis
return {
  {
    "superappkid/vim-dadbod-ui",
    init = function()
      local group = vim.api.nvim_create_augroup("dadbod_settings", { clear = true })
      local create_autocmd = function(event, desc, pattern, callback)
        vim.api.nvim_create_autocmd(event, {
          group = group,
          desc = desc,
          pattern = pattern,
          callback = callback,
        })
      end

      create_autocmd(
        "FileType",
        "dbout mappings", --
        "dbout",
        function(args)
          require("astrocore").set_mappings({
            n = {
              ["q"] = { function() require("astrocore.buffer").close() end },
              ["<Leader>zz"] = { desc = "DBUI CMD" },
              ["<Leader>zzH"] = { "<Plug>(DBUI_YankHeader)", desc = "DBUI: Copy Header" },
              ["<Leader>zzc"] = { "<Plug>(DBUI_ToggleResultLayout)", desc = "DBUI: Toggle Column" },
              ["<Leader>zzf"] = { "<Plug>(DBUI_JumpToForeignKey)", desc = "DBUI: Jump to ForeignKey" },
            },
          }, { buffer = args.buf })
        end
      )

      create_autocmd(
        "FileType",
        "dbui mappings",
        "dbui",
        function(args)
          require("astrocore").set_mappings({
            n = {
              ["q"] = { "<Cmd>DBUIClose<CR>" },
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
        end
      )

      create_autocmd(
        "FileType",
        "dbui query mappings", --
        { "mysql", "plsql", "sql", "javascript", "redis" },
        function(args)
          if not vim.b[args.buf].dbui_db_key_name then return end

          require("astrocore").set_mappings({
            n = {
              ["<Leader>zz"] = { desc = "DBUI CMD" },
              ["<Leader>zze"] = { "<Plug>(DBUI_EditBindParameters)", desc = "DBUI: Edit Parameter" },
              ["<Leader>zzs"] = { "<Plug>(DBUI_SaveQuery)", desc = "DBUI: Save Query" },
              ["<Leader>zz<CR>"] = { "<Plug>(DBUI_ExecuteQuery)", desc = "DBUI: Execute Query" },
            },
            v = {
              ["<Leader>zz"] = { desc = "DBUI CMD" },
              ["<Leader>zz<CR>"] = { "<Plug>(DBUI_ExecuteQuery)", desc = "DBUI: Execute Query" },
            },
          }, {
            buffer = args.buf,
          })
        end
      )

      create_autocmd(
        { "FileType", "BufEnter" },
        "db sidebar autoclose", --
        "*",
        function(args)
          if vim.b[args.buf].dbui_db_key_name or vim.bo[args.buf].filetype == "dbout" then
            vim.cmd "DBUIClose"
            vim.bo[args.buf].buflisted = false
          end
        end
      )

      create_autocmd("BufEnter", "dbout autofocus", "*", function(args)
        if vim.bo[args.buf].filetype == "dbout" then
          local wins = vim.api.nvim_tabpage_list_wins(0)
          if #wins <= 2 then return end
          for _, winid in ipairs(wins) do
            if vim.api.nvim_win_is_valid(winid) then
              if vim.api.nvim_win_get_buf(winid) == args.buf then
                vim.schedule(function() vim.api.nvim_set_current_win(winid) end)
              end
            end
          end
        end
      end)
    end,
    dependencies = {
      { "tpope/vim-dadbod" },
      { "tpope/vim-dotenv" },
      { "kristijanhusak/vim-dadbod-completion" },
      {
        "Saghen/blink.cmp",
        opts = {
          sources = {
            per_filetype = {
              sql = { "dadbod", "buffer" },
            },
            providers = {
              dadbod = {
                name = "Dadbod",
                module = "vim_dadbod_completion.blink",
                score_offset = 1000,
              },
            },
          },
        },
      },
    },
    config = function(_, _)
      vim.g.db_use_nerd_fonts = vim.g.icons_enabled and 1 or nil
      vim.g.db_ui_show_help = 0
      vim.g.db_ui_disable_mappings = 1
      vim.g.db_ui_use_nvim_notify = 1
      vim.g.db_ui_execute_on_save = 0
      vim.g.db_ui_win_position = "right"
      vim.g.db_ui_winwidth = 52
    end,
    keys = {
      { "<Leader>zd", "<Cmd>DBUIToggle<CR>", desc = "Toggle DB-UI" },
    },
  },
}
