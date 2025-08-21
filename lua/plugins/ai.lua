---@type LazySpec
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },

  {
    "yetone/avante.nvim",
    event = "User AstroFile",
    build = vim.fn.has "win32" == 1 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    dependencies = {
      "folke/snacks.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      "HakonHarnes/img-clip.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    keys = function(_, keys)
      keys = {}
      local prefix = "<Leader>A"
      require("astrocore").set_mappings {
        n = {
          [prefix] = { desc = " Avante" },
          [prefix .. "<CR>"] = {
            function() require("avante.api").focus() end,
            desc = "avante: focus",
          },
          [prefix .. "n"] = {
            function() require("avante.api").ask { new_chat = true } end,
            desc = "avante: new",
          },
          [prefix .. "s"] = {
            function() require("avante.api").stop() end,
            desc = "avante: stop",
          },
          [prefix .. "r"] = {
            function() require("avante.api").refresh() end,
            desc = "avante: refresh",
          },
          [prefix .. "c"] = {
            "<Cmd>AvanteClear<CR>",
            desc = "avante: clear",
          },
          [prefix .. "M"] = {
            function() require("avante.api").select_model() end,
            desc = "avante: select model",
          },
          [prefix .. "R"] = {
            function() require("avante.repo_map").show() end,
            desc = "avante: display repo map",
          },
          [prefix .. "u"] = { desc = "Toggle" },
          [prefix .. "u<CR>"] = {
            function() require("avante").toggle() end,
            desc = "avante: toggle",
          },
          [prefix .. "ud"] = {
            function() require("avante").toggle.debug() end,
            desc = "avante: toggle debug",
          },
          [prefix .. "uh"] = {
            function() require("avante").toggle.hint() end,
            desc = "avante: toggle hint",
          },
          [prefix .. "us"] = {
            function() require("avante").toggle.suggestion() end,
            desc = "avante: toggle suggestion",
          },
        },
        v = {
          [prefix] = { desc = " Avante" },
          [prefix .. "<CR>"] = {
            function() require("avante.api").focus() end,
            desc = "avante: ask",
          },
          [prefix .. "e"] = {
            function() require("avante.api").edit() end,
            desc = "avante: edit",
          },
        },
      }
      return keys
    end,
    opts = {
      provider = "copilot",
      selector = {
        provider = "snacks",
      },
      behaviour = {
        auto_set_keymaps = false,
      },
      mappings = {
        diff = {
          next = "]c",
          prev = "[c",
        },
        files = {
          add_current = "<Leader>zz" .. ".",
          add_all_buffers = "<Leader>zz" .. "B",
        },
      },
      hints = { enabled = false },
      windows = {
        width = 50,
        sidebar_header = {
          rounded = false,
        },
        edit = {
          border = "double",
        },
        ask = {
          start_insert = false, -- Start insert mode when opening the ask window
          border = "double",
        },
      },
    },
  },

  {
    "Exafunction/codeium.nvim",
    event = "User AstroFile",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    config = function(_, opts)
      vim.env.DEBUG_CODEIUM = "fatal"
      require("codeium").setup(opts)
    end,
    opts = {
      enable_chat = false,
      enable_cmp_source = true,
      virtual_text = {
        enabled = true,
        manual = true,
        map_keys = false,
        idle_delay = 50,
      },
    },
    keys = {
      {
        "<C-F>",
        function() return require("codeium.virtual_text").accept() end,
        mode = "i",
        expr = true,
        script = true,
        nowait = true,
      },
      {
        "<A-l>",
        function() require("codeium.virtual_text").cycle_completions(1) end,
        mode = "i",
      },
      {
        "<A-h>",
        function() require("codeium.virtual_text").cycle_completions(-1) end,
        mode = "i",
      },
      {
        "<C-X>",
        function() require("codeium.virtual_text").clear() end,
        mode = "i",
      },
      {
        "<C-E>",
        function() require("codeium.virtual_text").complete() end,
        mode = "i",
      },
    },
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    version = "^4",
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatClose",
      "CopilotChatToggle",
      "CopilotChatStop",
      "CopilotChatReset",
      "CopilotChatSave",
      "CopilotChatLoad",
      "CopilotChatModels",
      "CopilotChatExplain",
      "CopilotChatReview",
      "CopilotChatFix",
      "CopilotChatOptimize",
      "CopilotChatDocs",
      "CopilotChatTests",
      "CopilotChatCommit",
    },
    specs = {
      {
        "AstroNvim/astrocore",
        ---@param opts AstroCoreOpts
        opts = function(_, opts)
          local maps = assert(opts.mappings)
          local prefix = opts.options.g.copilot_chat_prefix or "<Leader>P"
          local astroui = require "astroui"

          maps.n[prefix] = { desc = astroui.get_icon("Copilot", 1, true) .. "CopilotChat" }
          maps.v[prefix] = { desc = astroui.get_icon("Copilot", 1, true) .. "CopilotChat" }
          maps.n[prefix .. "<CR>"] = { ":CopilotChatOpen<CR>", desc = "Open Chat" }
          maps.n[prefix .. "r"] = { ":CopilotChatReset<CR>", desc = "Reset Chat" }
          maps.n[prefix .. "s"] = { ":CopilotChatStop<CR>", desc = "Stop Chat" }
          maps.n[prefix .. "S"] = {
            function()
              vim.ui.input({ prompt = "Save Chat: " }, function(input)
                if input ~= nil and input ~= "" then require("CopilotChat").save(input) end
              end)
            end,
            desc = "Save Chat",
          }
          maps.n[prefix .. "L"] = {
            function()
              local copilot_chat = require "CopilotChat"
              local path = copilot_chat.config.history_path
              local chats = require("plenary.scandir").scan_dir(path, { depth = 1, hidden = true })
              -- Remove the path from the chat names and .json
              for i, chat in ipairs(chats) do
                chats[i] = chat:sub(#path + 2, -6)
              end
              vim.ui.select(chats, { prompt = "Load Chat: " }, function(selected)
                if selected ~= nil and selected ~= "" then copilot_chat.load(selected) end
              end)
            end,
            desc = "Load Chat",
          }

          local function select_action(selection_type)
            return function()
              require("CopilotChat").select_prompt { selection = require("CopilotChat.select")[selection_type] }
            end
          end
          maps.n[prefix .. "p"] = {
            select_action "buffer",
            desc = "Prompt actions",
          }
          maps.v[prefix .. "p"] = {
            select_action "visual",
            desc = "Prompt actions",
          }

          local function quick_chat(selection_type)
            return function()
              vim.ui.input({ prompt = "Quick Chat: " }, function(input)
                if input ~= nil and input ~= "" then
                  require("CopilotChat").ask(input, { selection = require("CopilotChat.select")[selection_type] })
                end
              end)
            end
          end
          maps.n[prefix .. "Q"] = {
            quick_chat "buffer",
            desc = "Quick Chat",
          }
          maps.v[prefix .. "Q"] = {
            quick_chat "visual",
            desc = "Quick Chat",
          }
        end,
      },
    },
    opts = {
      window = {
        layout = "float",
        border = "double",
        title = "🤖 Copilot Chat",
        width = vim.o.columns,
        height = vim.o.lines - 4,
      },
      headers = {
        user = "👤",
        assistant = "🤖",
        tool = "🔧",
      },
      separator = "━━",
      show_folds = false,
    },
  },
}
