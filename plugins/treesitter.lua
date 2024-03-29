return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-context",
      opts = {
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        multiline_threshold = 1, -- Maximum number of lines to show for a single context
        separator = "-",
      },
    },
  },
  cmd = {
    "TSContextEnable",
    "TSContextDisable",
    "TSContextToggle",
  },
  keys = function(_, keys)
    table.insert(keys, {
      "[C",
      function() require("treesitter-context").go_to_context() end,
      desc = "Jumping to context",
      silent = true,
    })
  end,
  opts = function(_, opts)
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.go = {
      install_info = {
        url = "https://github.com/superappkid/tree-sitter-go",
        files = { "src/parser.c" },
        revision = "b1843aa70530cfc7143665b1f57d2bb757d59087",
      },
      branch = "master",
    }

    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, { "php" })

    opts.textobjects.select.enabled = false

    opts.textobjects.move.goto_next_start = {
      ["]f"] = { query = "@function.outer", desc = "Next function start" },
      ["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
    }
    opts.textobjects.move.goto_next_end = {
      ["]F"] = { query = "@function.outer", desc = "Next function end" },
      ["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
    }
    opts.textobjects.move.goto_previous_start = {
      ["[f"] = { query = "@function.outer", desc = "Previous function start" },
      ["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
    }
    opts.textobjects.move.goto_previous_end = {
      ["[F"] = { query = "@function.outer", desc = "Previous function end" },
      ["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
    }

    opts.textobjects.swap.swap_next = {
      [">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
    }
    opts.textobjects.swap.swap_previous = {
      ["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
    }

    vim.treesitter.language.register("bash", "dotenv")
    vim.treesitter.language.register("go", "api")
  end,
}
