return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-context",
      opts = {
        multiline_threshold = 1,
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
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
      "arduino",
      "cmake",
      "csv",
      "diff",
      "dot",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "godot_resource",
      "gomod",
      "gosum",
      "gotmpl",
      "gowork",
      "graphql",
      "jsdoc",
      "luadoc",
      "make",
      "phpdoc",
      "pod",
      "regex",
      "scss",
      "sql",
      "ssh_config",
      "swift",
      "xml",
    })

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
