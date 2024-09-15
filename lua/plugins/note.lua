local M = {}
local get_project_name = function()
  local project_name

  local project_directory, err = vim.loop.cwd()
  if not project_directory then
    vim.notify(err, vim.log.levels.WARN)
  else
    project_name = vim.fs.basename(project_directory)
  end

  if not project_name then vim.notify("Unable to get the project name", vim.log.levels.WARN) end

  return project_name
end

table.insert(M, {
  "superappkid/global-note.nvim",
  dependencies = {
    { "AstroNvim/astroui", opts = { icons = { Notes = " " } } },
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        local prefix = "<Leader>M"

        maps.n[prefix] = { desc = require("astroui").get_icon("Notes", 0, true) .. "Notes" }
        maps.n[prefix .. "m"] = {
          function() require("global-note").toggle_note() end,
          desc = "Toggle global note",
        }
        maps.n[prefix .. "l"] = {
          function() require("global-note").toggle_note "project_local" end,
          desc = "Toggle local note",
        }
      end,
    },
  },
  opts = {
    title = " Global note ",
    additional_presets = {
      project_local = {
        command_name = "ProjectNote",
        filename = function() return get_project_name() .. ".md" end,
        title = function() return " Note for project " .. get_project_name() .. " " end,
      },
    },
    post_open = function(bufr, _)
      vim.keymap.set("n", "q", "<Cmd>close<CR>", {
        noremap = true,
        silent = true,
        buffer = bufr,
      })
    end,
    -- A nvim_open_win config to show float window.
    -- table or fun(): table
    window_config = function()
      local window_height = vim.api.nvim_list_uis()[1].height
      local window_width = vim.api.nvim_list_uis()[1].width
      return {
        relative = "editor",
        border = "double",
        title = "Note",
        title_pos = "center",
        height = window_height - 3,
        row = 0,
        width = window_width,
        col = 0,
      }
    end,
  },
})

table.insert(M, {
  "iamcco/markdown-preview.nvim",
  init = function() vim.g.mkdp_filetypes = { "markdown" } end,
  build = "cd app && npx --yes yarn install",
  dependencies = {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local maps = opts.mappings
      maps.n["<Leader>zM"] = {
        "<Cmd>MarkdownPreviewToggle<CR>",
        desc = "markdown preview(alter)",
      }
    end,
  },
  ft = { "markdown" },
})

table.insert(M, {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "markdown.mdx" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    render_modes = { "n", "v", "i", "c" },
    heading = {
      -- position = "inline",
      left_pad = 1,
      right_pad = 1,
      icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
      signs = { "󰎦", "󰎩", "󰎬", "󰎮", "󰎰", "󰎵" },
      border = true,
      backgrounds = {
        "Mono",
      },
      foregrounds = {
        "RainbowRed",
        "RainbowOrange",
        "RainbowYellow",
        "RainbowGreen",
        "RainbowBlue",
        "RainbowViolet",
      },
    },
    code = {
      sign = false,
      language_pad = 1,
      left_pad = 1,
      right_pad = 1,
      width = "block",
      -- border = "thick",
    },
    bullet = {
      icons = { "▶", "◆", "▷", "◇", "◈" },
    },
    checkbox = {
      unchecked = {
        icon = "󰄱 ",
      },
      checked = {
        icon = "󰄵 ",
      },
      custom = {
        todo = { raw = "[-]", rendered = "󰔛 ", highlight = "RenderMarkdownTodo" },
        important = { raw = "[~]", rendered = "󰄗 ", highlight = "DiagnosticWarn" },
      },
    },
    pipe_table = {
      preset = "heavy",
      alignment_indicator = "",
    },
  },
})

local deno = vim.fn.stdpath "data" .. [[/mason/bin/deno]]
if vim.fn.executable(deno) == 1 then
  table.insert(M, {
    "toppair/peek.nvim",
    build = deno .. " task --quiet build:fast",
    dependencies = {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        maps.n["<Leader>zm"] = {
          function()
            local peek = require "peek"
            if peek.is_open() then
              peek.close()
            else
              peek.open()
            end
          end,
          desc = "markdown preview",
        }
      end,
    },
    ft = { "markdown" },
  })
end

return M
