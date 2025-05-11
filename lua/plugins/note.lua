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

local M = {
  {
    "superappkid/global-note.nvim",
    lazy = true,
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          local prefix = "<Leader>N"
          maps.n[prefix] = { desc = require("astroui").get_icon("note", 1, true) .. "Notes" }
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
      directory = vim.env.HOME .. "/Documents/Notes",
      additional_presets = {
        project_local = {
          command_name = "ProjectNote",
          filename = function() return get_project_name() .. ".md" end,
          title = function() return " Note for project " .. get_project_name() .. " " end,
        },
      },
      post_open = function(bufr, _)
        vim.keymap.set("n", "<C-Q>", "<Cmd>close<CR>", {
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
  },

  {
    "obsidian-nvim/obsidian.nvim",
    -- the obsidian vault in this default config  ~/obsidian-vault
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand':
    -- event = { "bufreadpre " .. vim.fn.expand "~" .. "/my-vault/**.md" },
    event = { "BufReadPre  */Obsidian/*.md" },
    init = function(plugin)
      -- create dir if opts.dir not exist
      local plugin_opts = require("lazy.core.plugin").values(plugin, "opts", false)
      if not (vim.uv or vim.loop).fs_stat(plugin_opts.dir) then vim.fn.mkdir(plugin_opts.dir, "p") end
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
    },
    config = function(_, opts)
      require("obsidian").setup(opts)
      require("astrocore").set_mappings {
        n = {
          ["gf"] = {
            function()
              if require("obsidian").util.cursor_on_markdown_link() then
                return "<Cmd>ObsidianFollowLink<CR>"
              else
                return "gf"
              end
            end,
            desc = "Obsidian Follow Link",
            expr = true,
          },
        },
      }
    end,
    opts = {
      dir = vim.env.HOME .. "/Documents/Obsidian", -- specify the vault location. no need to call 'vim.fn.expand' here
      use_advanced_uri = true,
      finder = "telescope.nvim",

      templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
      },
      daily_notes = {
        folder = "daily",
      },
      note_frontmatter_func = function(note)
        -- This is equivalent to the default frontmatter function.
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
      -- URL it will be ignored but you can customize this behavior here.
      follow_url_func = vim.ui.open or function(url) vim.ui.open(url) end,
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "markdown.mdx", "Avante" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      render_modes = { "n", "v", "i", "c" },
      filetypes = { "markdown", "Avante" },
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
  },
}

local deno = vim.fn.stdpath "data" .. [[/mason/bin/deno]]
if vim.fn.executable(deno) == 1 then
  table.insert(M, {
    "toppair/peek.nvim",
    build = deno .. " task --quiet build:fast",
    keys = {
      {
        "<Leader>zm",
        function()
          local peek = require "peek"
          if peek.is_open() then
            peek.close()
          else
            peek.open()
          end
        end,
        desc = "Markdown Preview",
      },
    },
  })
end

return M
