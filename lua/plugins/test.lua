---@type LazySpec
return {
  {
    "nvim-neotest/neotest",
    lazy = true,
    version = "^5",
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings

          local get_file_path = function() return vim.fn.expand "%" end
          local get_project_path = function() return vim.fn.getcwd() end

          local prefix = "<Leader>T"
          maps.n[prefix] = {
            desc = require("astroui").get_icon("test", 1, true) .. "Tests",
          }
          maps.n[prefix .. "t"] = {
            function() require("neotest").run.run() end,
            desc = "Run test",
          }
          maps.n[prefix .. "d"] = {
            function() require("neotest").run.run { suite = false, strategy = "dap" } end,
            desc = "Debug test",
          }
          maps.n[prefix .. "f"] = {
            function() require("neotest").run.run(get_file_path()) end,
            desc = "Run all tests in file",
          }
          maps.n[prefix .. "p"] = {
            function() require("neotest").run.run(get_project_path()) end,
            desc = "Run all tests in project",
          }
          maps.n[prefix .. "<CR>"] = {
            function() require("neotest").summary.toggle() end,
            desc = "Test Summary",
          }
          maps.n[prefix .. "o"] = {
            function() require("neotest").output.open() end,
            desc = "Output hover",
          }
          maps.n[prefix .. "O"] = {
            function() require("neotest").output_panel.toggle() end,
            desc = "Output window",
          }
          maps.n["]T"] = {
            function() require("neotest").jump.next() end,
            desc = "Next test",
          }
          maps.n["[T"] = {
            function() require("neotest").jump.prev() end,
            desc = "Previous test",
          }

          local watch_prefix = prefix .. "w"

          maps.n[watch_prefix] = {
            desc = require("astroui").get_icon("watch", 1, true) .. "Watch",
          }
          maps.n[watch_prefix .. "t"] = {
            function() require("neotest").watch.toggle() end,
            desc = "Toggle watch test",
          }
          maps.n[watch_prefix .. "f"] = {
            function() require("neotest").watch.toggle(get_file_path()) end,
            desc = "Toggle watch all test in file",
          }
          maps.n[watch_prefix .. "p"] = {
            function() require("neotest").watch.toggle(get_project_path()) end,
            desc = "Toggle watch all tests in project",
          }
          maps.n[watch_prefix .. "S"] = {
            function()
              --- NOTE: The proper type of the argument is missing in the documentation
              ---@see https://github.com/nvim-neotest/neotest/blob/master/doc/neotest.txt#L626-L632
              ---@diagnostic disable-next-line: missing-parameter
              require("neotest").watch.stop()
            end,
            desc = "Stop all watches",
          }
        end,
      },
    },
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-neotest/nvim-nio" },
      { "nvim-neotest/neotest-jest", config = function() end },
      { "Issafalcon/neotest-dotnet", config = function() end },
      { "fredrikaverpil/neotest-golang" },
      { "nvim-neotest/neotest-python", config = function() end },
    },
    config = function(_, opts)
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, vim.api.nvim_create_namespace "neotest")
      require("neotest").setup(opts)
    end,
    opts = function(_, opts)
      if not opts.adapters then opts.adapters = {} end
      require("astrocore").list_insert_unique(opts.adapters, {
        require "neotest-jest"(require("astrocore").plugin_opts "neotest-jest"),
        require "neotest-dotnet"(require("astrocore").plugin_opts "neotest-dotnet"),
        require "neotest-golang"(require("astrocore").plugin_opts "neotest-golang"),
        require "neotest-python"(require("astrocore").plugin_opts "neotest-python"),
      })
    end,
  },

  {
    "andythigpen/nvim-coverage",
    lazy = true,
    opts = {
      auto_reload = true,
    },
    specs = {
      {
        "AstroNvim/astrocore",
        optional = true,
        opts = function(_, opts)
          local astroui = require "astroui"
          local maps = opts.mappings

          local tests_prefix = "<Leader>T"
          local coverage_prefix = tests_prefix .. "C"

          -- INFO: Compatibility with `neotest` and `vim-test`
          maps.n[tests_prefix] = {
            desc = require("astroui").get_icon("test", 1, true) .. "Tests",
          }

          maps.n[coverage_prefix] = { desc = astroui.get_icon("coverage", 1, true) .. "Coverage" }
          maps.n[coverage_prefix .. "t"] = { function() require("coverage").toggle() end, desc = "Toggle coverage" }
          maps.n[coverage_prefix .. "s"] =
            { function() require("coverage").summary() end, desc = "Show coverage summary" }
          maps.n[coverage_prefix .. "c"] = { function() require("coverage").clear() end, desc = "Clear coverage" }
          maps.n[coverage_prefix .. "l"] = {
            function() require("coverage").load(true) end,
            desc = "Load and show coverage",
          }
        end,
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
