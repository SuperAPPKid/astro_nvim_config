return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          if vim.fn.executable "git" == 1 then
            local maps = opts.mappings
            maps.v["<Leader>gc"] = {
              function() require("telescope.builtin").git_bcommits_range() end,
              desc = "Git commits (line)",
            }
          end
        end,
      },
    },
  },

  {
    "superappkid/nvim-tinygit",
    dependencies = {
      "stevearc/dressing.nvim",
      {
        "astronvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          local git_prefix = "<Leader>g"

          local commit_prefix = git_prefix .. "M"
          maps.n[commit_prefix] = {
            desc = "Commit (tinygit)",
          }
          maps.n[commit_prefix .. "a"] = {
            function() require("tinygit").smartCommit() end,
            desc = "New",
          }
          maps.n[commit_prefix .. "e"] = {
            function() require("tinygit").amendOnlyMsg() end,
            desc = "Edit",
          }

          maps.n[git_prefix .. "P"] = {
            function() require("tinygit").push() end,
            desc = "Push (tinygit)",
          }
          maps.n[git_prefix .. "I"] = {
            function() require("tinygit").stashPush() end,
            desc = "Stash Push (tinygit)",
          }
          maps.n[git_prefix .. "O"] = {
            function() require("tinygit").stashPop() end,
            desc = "Stash Pop (tinygit)",
          }
        end,
      },
    },
  },

  {
    "sindrets/diffview.nvim",
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
          local prefix = "<Leader>g"
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
    "linrongbin16/gitlinker.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local gitlinker = require "gitlinker"
          local actions = require "gitlinker.actions"
          local maps = opts.mappings
          local prefix = "<Leader>go"

          maps.n[prefix] = { desc = "Gitlinker" }

          -- repo
          maps.n[prefix .. "u"] = {
            function() gitlinker.link { router_type = "repo" } end,
            silent = true,
            noremap = true,
            desc = "GitLink Repo",
          }
          maps.n[prefix .. "U"] = {
            function()
              gitlinker.link {
                router_type = "repo",
                action = actions.system,
              }
            end,
            silent = true,
            noremap = true,
            desc = "GitLink! Repo",
          }

          -- blame
          maps.n[prefix .. "b"] = {
            function() gitlinker.link { router_type = "blame" } end,
            silent = true,
            noremap = true,
            desc = "GitLink blame",
          }
          maps.v[prefix .. "b"] = maps.n[prefix .. "b"]

          maps.n[prefix .. "B"] = {
            function()
              gitlinker.link {
                router_type = "blame",
                action = actions.system,
              }
            end,
            silent = true,
            noremap = true,
            desc = "GitLink! blame",
          }
          maps.v[prefix .. "B"] = maps.n[prefix .. "B"]

          -- browse current branch
          maps.n[prefix .. "l"] = {
            function() gitlinker.link { router_type = "current_branch" } end,
            silent = true,
            noremap = true,
            desc = "GitLink",
          }
          maps.v[prefix .. "l"] = maps.n[prefix .. "l"]

          maps.n[prefix .. "L"] = {
            function()
              gitlinker.link {
                router_type = "current_branch",
                action = actions.system,
              }
            end,
            silent = true,
            noremap = true,
            desc = "GitLink!",
          }
          maps.v[prefix .. "L"] = maps.n[prefix .. "L"]
        end,
      },
    },
    opts = {
      router = {
        repo = {
          ["."] = "https://" .. "{_A.HOST}/" .. "{_A.ORG}/" .. "{_A.REPO}",
        },
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    tag = "v0.8.1",
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings

          maps.n["<Leader>gl"] = { function() require("gitsigns").blame_line() end, desc = "View Git blame" }
          maps.n["<Leader>gr"] = { function() require("gitsigns").reset_hunk() end, desc = "Reset Git hunk" }
          maps.n["<Leader>gR"] = { function() require("gitsigns").reset_buffer() end, desc = "Reset Git buffer" }
          maps.n["<Leader>gp"] = { function() require("gitsigns").preview_hunk_inline() end, desc = "Preview Git hunk" }
          maps.n["<Leader>gs"] = { function() require("gitsigns").stage_hunk() end, desc = "Stage Git hunk" }
          maps.n["<Leader>gS"] = { function() require("gitsigns").stage_buffer() end, desc = "Stage Git buffer" }
          maps.n["<Leader>gu"] = { function() require("gitsigns").undo_stage_hunk() end, desc = "Unstage Git hunk" }
          maps.n["<Leader>gh"] = { function() require("gitsigns").select_hunk() end, desc = "select Git hunk" }
          maps.n["]g"] = { function() require("gitsigns").next_hunk() end, desc = "Next Git hunk" }
          maps.n["[g"] = { function() require("gitsigns").prev_hunk() end, desc = "Previous Git hunk" }

          maps.v["<Leader>gr"] = {
            function() require("gitsigns").reset_hunk { vim.fn.line ".", vim.fn.line "v" } end,
            desc = "Reset Git hunk",
          }
          maps.v["<Leader>gs"] = {
            function() require("gitsigns").stage_hunk { vim.fn.line ".", vim.fn.line "v" } end,
            desc = "Stage Git hunk",
          }
          maps.v["<Leader>gu"] = {
            function() require("gitsigns").undo_stage_hunk { vim.fn.line ".", vim.fn.line "v" } end,
            desc = "Unstage Git hunk",
          }
        end,
      },
    },
    opts = function(_, opts) opts.on_attach = nil end,
  },

  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
      { "AstroNvim/astroui", opts = { icons = { Octo = "" } } },
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          local prefix = "<Leader>gO"
          maps.n[prefix] = { desc = require("astroui").get_icon("Octo", 1, true) .. "Octo" }
          maps.n[prefix .. "a"] = { desc = "Assignee/Reviewer" }
          maps.n[prefix .. "aa"] = { "<Cmd>Octo assignee add<CR>", desc = "Assign a user" }
          maps.n[prefix .. "ap"] = { "<Cmd>Octo reviewer add<CR>", desc = "Assign a PR reviewer" }
          maps.n[prefix .. "ar"] = { "<Cmd>Octo assignee remove<CR>", desc = "Remove a user" }
          maps.n[prefix .. "c"] = { desc = "Comments" }
          maps.n[prefix .. "ca"] = { "<Cmd>Octo comment add<CR>", desc = "Add a new comment" }
          maps.n[prefix .. "cd"] = { "<Cmd>Octo comment delete<CR>", desc = "Delete a comment" }
          maps.n[prefix .. "e"] = { desc = "Reaction" }
          maps.n[prefix .. "e1"] = { "<Cmd>Octo reaction thumbs_up<CR>", desc = "Add 👍 reaction" }
          maps.n[prefix .. "e2"] = { "<Cmd>Octo reaction thumbs_down<CR>", desc = "Add 👎 reaction" }
          maps.n[prefix .. "e3"] = { "<Cmd>Octo reaction eyes<CR>", desc = "Add 👀 reaction" }
          maps.n[prefix .. "e4"] = { "<Cmd>Octo reaction laugh<CR>", desc = "Add 😄 reaction" }
          maps.n[prefix .. "e5"] = { "<Cmd>Octo reaction confused<CR>", desc = "Add 😕 reaction" }
          maps.n[prefix .. "e6"] = { "<Cmd>Octo reaction rocket<CR>", desc = "Add 🚀 reaction" }
          maps.n[prefix .. "e7"] = { "<Cmd>Octo reaction heart<CR>", desc = "Add ❤️ reaction" }
          maps.n[prefix .. "e8"] = { "<Cmd>Octo reaction party<CR>", desc = "Add 🎉 reaction" }
          maps.n[prefix .. "i"] = { desc = "Issues" }
          maps.n[prefix .. "ic"] = { "<Cmd>Octo issue close<CR>", desc = "Close current issue" }
          maps.n[prefix .. "il"] = { "<Cmd>Octo issue list<CR>", desc = "List open issues" }
          maps.n[prefix .. "io"] = { "<Cmd>Octo issue browser<CR>", desc = "Open current issue in browser" }
          maps.n[prefix .. "ir"] = { "<Cmd>Octo issue reopen<CR>", desc = "Reopen current issue" }
          maps.n[prefix .. "iu"] = { "<Cmd>Octo issue url<CR>", desc = "Copies URL of current issue" }
          maps.n[prefix .. "l"] = { desc = "Label" }
          maps.n[prefix .. "la"] = { "<Cmd>Octo label add<CR>", desc = "Assign a label" }
          maps.n[prefix .. "lc"] = { "<Cmd>Octo label create<CR>", desc = "Create a label" }
          maps.n[prefix .. "lr"] = { "<Cmd>Octo label remove<CR>", desc = "Remove a label" }
          maps.n[prefix .. "p"] = { desc = "Pull requests" }
          maps.n[prefix .. "pc"] = { "<Cmd>Octo pr close<CR>", desc = "Close current PR" }
          maps.n[prefix .. "pd"] = { "<Cmd>Octo pr diff<CR>", desc = "Show PR diff" }
          maps.n[prefix .. "pl"] = { "<Cmd>Octo pr commits<CR>", desc = "List changed files in PR" }
          maps.n[prefix .. "pm"] = { desc = "Merge current PR" }
          maps.n[prefix .. "pmd"] = { "<Cmd>Octo pr merge delete<CR>", desc = "Delete merge PR" }
          maps.n[prefix .. "pmm"] = { "<Cmd>Octo pr merge commit<CR>", desc = "Merge commit PR" }
          maps.n[prefix .. "pmr"] = { "<Cmd>Octo pr merge rebase<CR>", desc = "Rebase merge PR" }
          maps.n[prefix .. "pms"] = { "<Cmd>Octo pr merge squash<CR>", desc = "Squash merge PR" }
          maps.n[prefix .. "pn"] = { "<Cmd>Octo pr create<CR>", desc = "Create PR for current branch" }
          maps.n[prefix .. "po"] = { "<Cmd>Octo pr browser<CR>", desc = "Open current PR in browser" }
          maps.n[prefix .. "pp"] = { "<Cmd>Octo pr checkout<CR>", desc = "Checkout PR" }
          maps.n[prefix .. "pr"] = { "<Cmd>Octo pr ready<CR>", desc = "Mark draft as ready for review" }
          maps.n[prefix .. "ps"] = { "<Cmd>Octo pr list<CR>", desc = "List open PRs" }
          maps.n[prefix .. "pt"] = { "<Cmd>Octo pr commits<CR>", desc = "List PR commits" }
          maps.n[prefix .. "pu"] = { "<Cmd>Octo pr url<CR>", desc = "Copies URL of current PR" }
          maps.n[prefix .. "r"] = { desc = "Repo" }
          maps.n[prefix .. "rf"] = { "<Cmd>Octo repo fork<CR>", desc = "Fork repo" }
          maps.n[prefix .. "rl"] = { "<Cmd>Octo repo list<CR>", desc = "List repo user stats" }
          maps.n[prefix .. "ro"] = { "<Cmd>Octo repo open<CR>", desc = "Open current repo in browser" }
          maps.n[prefix .. "ru"] = { "<Cmd>Octo repo url<CR>", desc = "Copies URL of current repo" }
          maps.n[prefix .. "s"] = { desc = "Review" }
          maps.n[prefix .. "sc"] = { "<Cmd>Octo review close<CR>", desc = "Return to PR" }
          maps.n[prefix .. "sc"] = { "<Cmd>Octo review comments<CR>", desc = "View pending comments" }
          maps.n[prefix .. "sd"] = { "<Cmd>Octo review discard<CR>", desc = "Delete pending review" }
          maps.n[prefix .. "sf"] = { "<Cmd>Octo review submit<CR>", desc = "Submit review" }
          maps.n[prefix .. "sp"] = { "<Cmd>Octo review commit<CR>", desc = "Select commit to review" }
          maps.n[prefix .. "sr"] = { "<Cmd>Octo review resume<CR>", desc = "Resume review" }
          maps.n[prefix .. "ss"] = { "<Cmd>Octo review start<CR>", desc = "Start review" }
          maps.n[prefix .. "t"] = { desc = "Threads" }
          maps.n[prefix .. "ta"] = { "<Cmd>Octo thread resolve<CR>", desc = "Mark thread as resolved" }
          maps.n[prefix .. "td"] = { "<Cmd>Octo thread unresolve<CR>", desc = "Mark thread as unresolved" }
          maps.n[prefix .. "x"] = { "<Cmd>Octo actions<CR>", desc = "Run an action" }
        end,
      },
    },
    cmd = { "Octo" },
    opts = {
      use_diagnostic_signs = true,
      mappings = {},
    },
  },

  {
    "FabijanZulj/blame.nvim",
    cmd = "BlameToggle",
    config = true,
    dependencies = {
      {
        "AstroNvim/astrocore",
        ---@type AstroCoreOpts
        opts = {
          mappings = {
            n = {
              ["<Leader>gL"] = {
                "<cmd>BlameToggle<cr>",
                desc = "Toggle git blame",
              },
            },
          },
        },
      },
    },
  },
}
