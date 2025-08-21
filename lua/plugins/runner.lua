---@type LazySpec
return {
  {
    "stevearc/overseer.nvim",
    version = "*",
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
          maps.n[prefix .. "a"] = { "<Cmd>OverseerRunCmd<CR>", desc = "Add Command" }
          maps.n[prefix .. "A"] = { "<Cmd>OverseerRun<CR>", desc = "Add Task" }
          maps.n[prefix .. "<CR>"] = { "<Cmd>OverseerTaskAction<CR>", desc = "Task Actions" }
          maps.n[prefix .. "i"] = { "<Cmd>OverseerInfo<CR>", desc = "Info" }
        end,
      },
    },
    opts = function(_, opts)
      opts.form = { border = "double" }
      opts.confirm = { border = "double" }
      opts.task_win = { border = "double" }
      opts.help_win = { border = "double" }
      opts.bundles = {
        autostart_on_load = false,
      }
      opts.dap = false
      opts.actions = {
        ["save"] = false,
        ["open"] = false,
        ["open float"] = false,
        ["open hsplit"] = false,
        ["open vsplit"] = false,
        ["open tab"] = false,
        ["ensure"] = false,
      }
      opts.component_aliases = {
        -- Most tasks are initialized with the default components
        default = {
          { "display_duration", detail_level = 2 },
          "on_complete_notify",
          "on_output_summarize",
          "on_exit_set_status",
          -- { "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
          { "on_result_diagnostics", remove_on_restart = true, signs = false, underline = false, virtual_text = true },
          "unique",
        },
      }
      opts.task_list = {
        direction = "right",
        bindings = {
          ["a"] = "<Cmd>OverseerRunCmd<CR>",
          ["A"] = "<Cmd>OverseerRun<CR>",
          ["s"] = "<Cmd>OverseerQuickAction start<CR>",
          ["e"] = "Edit",
          ["d"] = "Dispose",
          ["o"] = "OpenQuickFix",
          ["L"] = "IncreaseDetail",
          ["H"] = "DecreaseDetail",
          ["K"] = "ScrollOutputUp",
          ["J"] = "ScrollOutputDown",

          ["<C-e>"] = false,
          ["<C-v>"] = false,
          ["<C-s>"] = false,
          ["<C-f>"] = false,
          ["<C-q>"] = false,
          ["["] = false,
          ["]"] = false,
          ["<C-l>"] = false,
          ["<C-h>"] = false,
          ["<C-k>"] = false,
          ["<C-j>"] = false,
        },
      }
      opts.task_launcher = {
        bindings = {
          i = {
            ["<C-c>"] = false,
            ["<C-q>"] = "Cancel",
          },
        },
      }
      opts.task_editor = {
        bindings = {
          i = {
            ["<C-c>"] = false,
            ["<C-q>"] = "Cancel",
          },
        },
      }
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
