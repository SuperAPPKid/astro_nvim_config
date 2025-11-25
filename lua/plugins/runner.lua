---@type LazySpec
return {
  {
    "stevearc/overseer.nvim",
    version = "^2",
    cmd = {
      "OverseerOpen",
      "OverseerClose",
      "OverseerToggle",
      "OverseerSaveBundle",
      "OverseerLoadBundle",
      "OverseerDeleteBundle",
      "OverseerRunCmd",
      "OverseerRun",
      "OverseerInfo",
      "OverseerBuild",
      "OverseerQuickAction",
      "OverseerTaskAction ",
      "OverseerClearCache",
    },
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          local prefix = "<Leader>o"
          maps.n[prefix] = { desc = require("astroui").get_icon("Overseer", 1, true) .. "Overseer" }

          maps.n[prefix .. "u"] = { "<Cmd>OverseerToggle<CR>", desc = "Toggle" }
          maps.n[prefix .. "n"] = { "<Cmd>OverseerShell<CR>", desc = "New Task" }
          maps.n[prefix .. "<CR>"] = { "<Cmd>OverseerTaskAction<CR>", desc = "Task Actions" }
        end,
      },
    },
    opts = function(_, opts)
      opts.dap = false
      opts.form = { border = "double" }
      opts.component_aliases = {
        -- Most tasks are initialized with the default components
        default = {
          "on_complete_notify",
          "on_exit_set_status",
          -- { "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
          { "on_result_diagnostics", remove_on_restart = true, signs = false, underline = false, virtual_text = true },
          "unique",
        },
      }
      opts.actions = {
        ["open"] = false,
        ["open float"] = false,
        ["open hsplit"] = false,
        ["open vsplit"] = false,
        ["open tab"] = false,
        ["ensure"] = false,
      }
      opts.task_list = {
        direction = "right",
        separator = "━━━",
        keymaps = {
          ["s"] = { "keymap.run_action", opts = { action = "start" }, desc = "Start task" },
          ["S"] = { "keymap.run_action", opts = { action = "stop" }, desc = "Stop task" },
          ["p"] = {
            desc = "Toggle task output in a preview floating window",
            callback = function()
              local sb = require("overseer.task_list.sidebar").get()
              if not sb then return end
              sb:toggle_preview()
              local preview = sb.preview
              if preview and not preview:is_win_closed() then
                vim.api.nvim_win_set_config(sb.preview.winid, { border = "double" })
              end
            end,
          },

          ["<C-e>"] = false,
          ["e"] = { "keymap.run_action", opts = { action = "edit" }, desc = "Edit task" },

          ["<C-v>"] = false,
          ["<C-s>"] = false,
          ["<C-t>"] = false,
          ["<C-f>"] = false,

          ["dd"] = false,
          ["d"] = { "keymap.run_action", opts = { action = "dispose" }, desc = "Dispose task" },

          ["<C-q>"] = false,
          ["O"] = {
            "keymap.run_action",
            opts = { action = "open output in quickfix" },
            desc = "Open task output in the quickfix",
          },

          ["<C-k>"] = false,
          ["<C-j>"] = false,
          ["K"] = "keymap.scroll_output_up",
          ["J"] = "keymap.scroll_output_down",
        },
      }
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("overseer_settings", { clear = true }),
        pattern = "OverseerForm",
        callback = function(args)
          local winids = vim.fn.win_findbuf(args.buf)
          if #winids > 0 then vim.api.nvim_win_set_config(winids[1], { border = "double" }) end
          require("astrocore").set_mappings({
            i = {
              ["<C-c>"] = "<Nop>",
            },
          }, { buffer = args.buf })
        end,
      })
    end,
  },

  {
    "michaelb/sniprun",
    build = "bash ./install.sh 1",
    specs = {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local prefix = "<Leader>R"
        opts.mappings.n[prefix] = {
          desc = require("astroui").get_icon("play", 1, false) .. "RunCode",
        }
        opts.mappings.v[prefix] = {
          desc = require("astroui").get_icon("play", 1, false) .. "RunCode",
        }
        opts.mappings.n[prefix .. "<CR>"] = {
          function()
            if vim.v.count > 1 then
              require("sniprun").run "n"
            else
              require("sniprun").run()
            end
          end,
          desc = "run",
        }
        opts.mappings.n[prefix .. "i"] = {
          function() require("sniprun").info() end,
          desc = "info",
        }
        opts.mappings.n[prefix .. "Q"] = {
          function() require("sniprun").reset() end,
          desc = "stop",
        }
        opts.mappings.n[prefix .. "d"] = {
          function() require("sniprun").clear_repl() end,
          desc = "clear REPL",
        }
        opts.mappings.n[prefix .. "q"] = {
          function() require("sniprun.display").close_all() end,
          desc = "close",
        }
        opts.mappings.v[prefix .. "<CR>"] = {
          function() require("sniprun").run "v" end,
          desc = "run",
        }
      end,
    },
    opts = {
      display = { "Classic" },
      show_no_output = { "Classic" },
    },
  },
}
