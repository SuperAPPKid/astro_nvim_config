local default_opts = { instanceName = "main", transient = true }
local function grug_far_open(opts, with_visual)
  local grug_far = require "grug-far"
  opts = require("astrocore").extend_tbl(default_opts, opts)
  if not grug_far.has_instance(opts.instanceName) then
    grug_far.open(opts)
  else
    if with_visual then
      if not opts.prefills then opts.prefills = {} end
      opts.prefills.search = grug_far.get_current_visual_selection()
    end
    grug_far.open_instance(opts.instanceName)
    if opts.prefills then grug_far.update_instance_prefills(opts.instanceName, opts.prefills, false) end
  end
end

--@type LazySpec
return {
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    ---@param opts GrugFarOptionsOverride
    opts = function(_, opts)
      opts.icons = opts.icons or {}
      opts.icons.enabled = vim.g.icons_enabled
      if not vim.g.icons_enabled then
        opts.resultsSeparatorLineChar = "-"
        opts.spinnerStates = {
          "|",
          "\\",
          "-",
          "/",
        }
      end

      opts.startInInsertMode = false
      opts.transient = true
      opts.keymaps = {
        replace = { n = "<localleader>r" },
        qflist = { n = "<localleader>q" },
        syncLocations = { n = "<localleader>s" },
        syncLine = { n = "<localleader>l" },
        close = { n = "q" },
        historyOpen = { n = "<localleader>t" },
        historyAdd = { n = "<localleader>a" },
        refresh = { n = "<localleader>f" },
        openLocation = { n = "<localleader>o" },
        openNextLocation = { n = "<Tab>" },
        openPrevLocation = { n = "<S-Tab>" },
        gotoLocation = { n = "<enter>" },
        pickHistoryEntry = { n = "<enter>" },
        abort = { n = "<localleader>b" },
        help = { n = "g?" },
        toggleShowCommand = { n = "<localleader>p" },
        swapEngine = { n = "<localleader>e" },
        previewLocation = { n = "<localleader>i" },
        swapReplacementInterpreter = { n = "<localleader>x" },
      }
    end,
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>zs"] = {
            function() grug_far_open() end,
            desc = "Search / Replace",
          }
          maps.n["<Leader>zS"] = {
            function()
              local ext = require("astrocore.buffer").is_valid() and vim.fn.expand "%:e" or ""
              local paths = require("astrocore.buffer").is_valid() and vim.fn.expand "%" or nil
              grug_far_open {
                prefills = {
                  paths = paths,
                  filesFilter = ext ~= "" and "*." .. ext or nil,
                },
              }
            end,
            desc = "Search / Replace (current file)",
          }
          maps.x["<Leader>zs"] = {
            function() grug_far_open({ startCursorRow = 4 }, true) end,
            desc = "Search / Replace",
          }
          maps.x["<Leader>zS"] = {
            function()
              local ext = require("astrocore.buffer").is_valid() and vim.fn.expand "%:e" or ""
              local paths = require("astrocore.buffer").is_valid() and vim.fn.expand "%" or nil
              grug_far_open({
                startCursorRow = 4,
                prefills = {
                  paths = paths,
                  filesFilter = ext ~= "" and "*." .. ext or nil,
                },
              }, true)
            end,
            desc = "Search / Replace (current file)",
          }
        end,
      },
    },
    specs = {
      {
        "folke/which-key.nvim",
        opts = function(_, opts)
          if not opts.disable then opts.disable = {} end
          opts.disable.ft = require("astrocore").list_insert_unique(opts.disable.ft, { "grug-far" })
        end,
      },
      {
        "nvim-neo-tree/neo-tree.nvim",
        opts = {
          commands = {
            grug_far_replace = function(state)
              local node = state.tree:get_node()
              grug_far_open {
                prefills = {
                  paths = node.type == "directory" and node:get_id() or vim.fn.fnamemodify(node:get_id(), ":h"),
                },
              }
            end,
          },
          window = {
            mappings = {
              gS = "grug_far_replace",
            },
          },
        },
      },
      {
        "stevearc/oil.nvim",
        opts = {
          keymaps = {
            gS = {
              function() grug_far_open { prefills = { paths = require("oil").get_current_dir() } } end,
              desc = "Search/Replace in directory",
            },
          },
        },
      },
    },
  },
}
