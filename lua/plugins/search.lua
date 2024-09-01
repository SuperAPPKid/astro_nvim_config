return {

  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = {
      startInInsertMode = false,
      transient = true,
      keymaps = {
        replace = { n = "<localleader>r" },
        qflist = { n = "<localleader>q" },
        syncLocations = { n = "<localleader>s" },
        syncLine = { n = "<localleader>l" },
        close = { n = "q" },
        historyOpen = { n = "<localleader>t" },
        historyAdd = { n = "<localleader>a" },
        refresh = { n = "<localleader>f" },
        openLocation = { n = "<localleader>o" },
        gotoLocation = { n = "<enter>" },
        pickHistoryEntry = { n = "<enter>" },
        abort = { n = "<localleader>b" },
        help = { n = "g?" },
        toggleShowRgCommand = { n = "<localleader>p" },
      },
    },
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>zs"] = {
            function() require("grug-far").open {} end,
            desc = "Search / Replace",
          }
          maps.n["<Leader>zS"] = {
            function()
              require("grug-far").open {
                prefills = { paths = vim.fn.expand "%" },
              }
            end,
            desc = "Search / Replace (current file)",
          }
          maps.x["<Leader>zs"] = {
            function() require("grug-far").open { startCursorRow = 4 } end,
            desc = "Search / Replace",
          }
          maps.x["<Leader>zS"] = {
            function()
              require("grug-far").with_visual_selection {
                startCursorRow = 4,
                prefills = { paths = vim.fn.expand "%" },
              }
            end,
            desc = "Search / Replace (current file)",
          }
        end,
      },
    },
  },
}
