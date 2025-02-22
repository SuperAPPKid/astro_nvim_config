---@type LazySpec
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    config = true,
  },

  {
    "yetone/avante.nvim",
    event = "User AstroFile",
    build = vim.fn.has "win32" == 1 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    dependencies = {
      "stevearc/dressing.nvim",
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
    keys = function(_, _)
      local prefix = "<Leader>A"
      return {
        {
          prefix,
          function() end,
          mode = { "n", "v" },
          desc = " Avante",
        },
        {
          prefix .. "<CR>",
          function() require("avante.api").ask() end,
          mode = { "n", "v" },
          desc = "avante: ask",
        },
        {
          prefix .. "e",
          function() require("avante.api").edit() end,
          mode = "v",
          desc = "avante: edit",
        },
        {
          prefix .. "r",
          function() require("avante.api").refresh() end,
          desc = "avante: refresh",
        },
        {
          prefix .. "f",
          function() require("avante.api").focus() end,
          desc = "avante: focus",
        },
        {
          prefix .. "u",
          function() end,
          desc = "Toggle",
        },
        {
          prefix .. "u<CR>",
          function() require("avante").toggle() end,
          desc = "avante: toggle",
        },
        {
          prefix .. "ud",
          function() require("avante").toggle.debug() end,
          desc = "avante: toggle debug",
        },
        {
          prefix .. "uh",
          function() require("avante").toggle.hint() end,
          desc = "avante: toggle hint",
        },
        {
          prefix .. "us",
          function() require("avante").toggle.suggestion() end,
          desc = "avante: toggle suggestion",
        },
        {
          prefix .. "ur",
          function() require("avante.repo_map").show() end,
          desc = "avante: display repo map",
          noremap = true,
          silent = true,
        },
      }
    end,
    opts = {
      provider = "copilot",
      behaviour = {
        auto_set_keymaps = false,
      },
      mappings = {
        diff = {
          next = "]c",
          prev = "[c",
        },
        files = {
          add_current = "<Leader>zz.",
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
