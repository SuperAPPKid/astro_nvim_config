local command_key = "<Leader>zz"
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
    lazy = true,
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
      opts.resultsHighlight = false
      opts.wrap = false
      opts.keymaps = {
        replace = { n = command_key .. "r" },
        qflist = { n = command_key .. "q" },
        syncLocations = { n = command_key .. "s" },
        syncLine = { n = command_key .. "l" },
        close = { n = "q" },
        historyOpen = { n = command_key .. "t" },
        historyAdd = { n = command_key .. "a" },
        refresh = { n = command_key .. "f" },
        openLocation = { n = command_key .. "o" },
        openNextLocation = { n = "<Tab>" },
        openPrevLocation = { n = "<S-Tab>" },
        gotoLocation = { n = "<enter>" },
        pickHistoryEntry = { n = "<enter>" },
        abort = { n = command_key .. "b" },
        help = { n = "g?" },
        toggleShowCommand = { n = command_key .. "p" },
        swapEngine = { n = command_key .. "e" },
        previewLocation = { n = command_key .. "i" },
        swapReplacementInterpreter = { n = command_key .. "x" },
      }
      opts.resultLocation = { showNumberLabel = false }
      opts.folding = { enabled = false }
      opts.helpWindow = { border = "double" }
      opts.historyWindow = { border = "double" }
      opts.previewWindow = { border = "double" }
    end,
    dependencies = {
      {
        "nvim-neo-tree/neo-tree.nvim",
        optional = true,
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
        optional = true,
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
    specs = {
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
          maps.v["<Leader>zs"] = {
            function() grug_far_open({ startCursorRow = 4 }, true) end,
            desc = "Search / Replace",
          }
          maps.v["<Leader>zS"] = {
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
          opts.autocmds = require("astrocore").extend_tbl(opts.autocmds, {
            grugfar_settings = {
              {
                event = "FileType",
                desc = "Add hint",
                pattern = "grug-far",
                callback = function(args)
                  require("astrocore").set_mappings({
                    n = {
                      [command_key] = { desc = "Grugfar CMD" },
                    },
                  }, { buffer = args.buf })
                end,
              },
            },
          })
        end,
      },
    },
  },
}
