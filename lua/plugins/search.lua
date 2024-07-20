return {

  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = {
      staticTitle = "Find and Search",
      startInInsertMode = false,
      searchOnInsertLeave = true,
      icons = { enabled = false },
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
            function() require("grug-far").grug_far {} end,
            desc = "Search / Replace",
          }
          maps.n["<Leader>zS"] = {
            function()
              require("grug-far").grug_far {
                prefills = { filesFilter = vim.fn.expand "%" },
              }
            end,
            desc = "Search / Replace (current file)",
          }
          maps.x["<Leader>zs"] = {
            function() require("grug-far").with_visual_selection() end,
            desc = "Search / Replace",
          }
          maps.x["<Leader>zS"] = {
            function()
              require("grug-far").with_visual_selection {
                prefills = { filesFilter = vim.fn.expand "%" },
              }
            end,
            desc = "Search / Replace (current file)",
          }
        end,
      },
    },
  },
}
