local function gd_move_handler(source, destination)
  if not vim.fs.root(source, "project.godot") then return end -- only run in godot projects
  local suffix = source:match "%.gd$" and "uid" or "import"
  local tmp_file = ("%s.%s"):format(source, suffix)
  local tmp_stat = vim.uv.fs_stat(tmp_file)

  if tmp_stat then
    -- Rename the temporary file
    local new_tmp_file = ("%s.%s"):format(destination, suffix)
    local success, err = vim.uv.fs_rename(tmp_file, new_tmp_file)
    if not success then
      vim.notify(("Failed to rename Godot file: `%s`\n```\n%s\n```"):format(tmp_file, err or "unknown error"))
    end
  end
end

---@type LazySpec
return {
  {
    "AstroNvim/astrolsp",
    opts = { servers = { "gdscript" } },
  },

  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require "dap"
      dap.adapters.godot = {
        type = "server",
        host = "127.0.0.1",
        port = vim.env.GDScript_Debug_Port or 6006,
      }
      dap.configurations.gdscript = {
        {
          type = "godot",
          request = "launch",
          name = "Launch scene",
          project = "${workspaceFolder}",
          launch_scene = true,
        },
      }
    end,
  },

  {
    "QuickGD/quickgd.nvim",
    ft = { "gdshader", "gdshaderinc" },
    cmd = { "GodotRun", "GodotRunLast", "GodotStart" },
    dependencies = {
      {
        "Saghen/blink.cmp",
        opts = {
          sources = {
            per_filetype = {
              gdshader = { "quickgd" },
              gdshaderinc = { "quickgd" },
            },
            providers = {
              quickgd = { name = "quickgd", module = "quickgd.blink", score_offset = 1000 },
            },
          },
        },
      },
    },
    opts = function(_, opts)
      local is_available = require("astrocore").is_available
      opts.cmp = is_available "blink.cmp"
      opts.telescope = is_available "telescope.nvim"
      opts.treesitter = is_available "nvim-treesitter"
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      event_handlers = {
        {
          event = "file_renamed",
          handler = function(args) gd_move_handler(args.source, args.destination) end,
          id = "godot_handler",
        },
        {
          event = "file_moved",
          handler = function(args) gd_move_handler(args.source, args.destination) end,
          id = "godot_handler",
        },
      },
      nesting_rules = {
        godot_import = {
          pattern = "^(.*)$",
          files = { -- pretty loose, but is probably a specific enough pattern to be alright
            "%1.import",
          },
        },
        godot_uid = {
          pattern = "^(.*%.gd)$",
          files = {
            "%1.uid",
          },
        },
      },
    },
  },
}
