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
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
          },
        },
      },
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
            desc = "avante: ask",
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
}
