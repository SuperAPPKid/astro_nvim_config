return {
  {
    "SuperBo/fugit2.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-lua/plenary.nvim",
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>gf"] = { "<Cmd>Fugit2<CR>", desc = "Fugit2" }
          maps.n["<leader>gG"] = { "<Cmd>Fugit2Graph<CR>", desc = "Fugit2 Graph" }
        end,
      },
      {
        "chrisgrieser/nvim-tinygit",
        ft = { "git_rebase", "gitcommit" }, -- so ftplugins are loaded
        dependencies = {
          "stevearc/dressing.nvim",
          {
            "astronvim/astrocore",
            opts = function(_, opts)
              local maps = opts.mappings
              maps.n["<leader>gm"] = {
                function() require("tinygit").smartcommit() end,
                desc = "new commit",
              }
              maps.n["<leader>gp"] = {
                function() require("tinygit").push { forcewithlease = true } end,
                desc = "push",
              }
            end,
          },
        },
      },
    },
    cmd = { "Fugit2", "Fugit2Graph" },
    opts = {
      width = "95%",
      height = "95%",
    },
  },

  {
    "sindrets/diffview.nvim",
    event = "User AstroGitFile",
    cmd = {
      "DiffviewFileHistory",
      "DiffviewOpen",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
    },
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local last_tabpage = vim.api.nvim_get_current_tabpage()
          local find_target_tab = function(cmd)
            local lib = require "diffview.lib"
            local view = lib.get_current_view()
            if view then
              -- Current tabpage is a Diffview: go to previous tabpage
              vim.api.nvim_set_current_tabpage(last_tabpage)
            else
              for _, v in ipairs(lib.views) do
                local tabn = vim.api.nvim_tabpage_get_number(v.tabpage)
                vim.cmd.tabclose(tabn)
              end

              last_tabpage = vim.api.nvim_get_current_tabpage()

              vim.cmd(cmd)
            end
          end

          local maps = opts.mappings
          local prefix = "<leader>g"
          maps.n[prefix .. "d"] = {
            function() find_target_tab "DiffviewOpen -uno -- %" end,
            desc = "Open File Diff",
          }
          maps.n[prefix .. "D"] = {
            function() find_target_tab "DiffviewFileHistory %" end,
            desc = "Open File History",
          }
        end,
      },
    },
    opts = {
      hooks = {
        view_opened = function() require("diffview.actions").toggle_files() end,
      },
    },
  },

  {
    "almo7aya/openingh.nvim",
    cmd = { "OpenInGHRepo", "OpenInGHFile", "OpenInGHFileLines" },
    dependencies = {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        local prefix = "<Leader>go"
        maps.n[prefix] = { desc = "OpenInGH" }
        maps.n[prefix .. "r"] = { "<Cmd>OpenInGHRepo<CR>", desc = "Open git repo in web" }
        maps.n[prefix .. "f"] = { "<Cmd>OpenInGHFile<CR>", desc = "Open git file in web" }
        maps.x[prefix .. "f"] = { "<Cmd>OpenInGHFileLines<CR>", desc = "Open git lines in web" }
      end,
    },
  },
}
