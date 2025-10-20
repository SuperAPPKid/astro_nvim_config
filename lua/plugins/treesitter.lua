-- Customize Treesitter

---@type LazySpec
---@diagnostic disable: inject-field
return {
  {
    "sustech-data/wildfire.nvim",
    lazy = true,
    init = function(plugin) require("astrocore").on_load("nvim-treesitter", plugin.name) end,
    config = true,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-context",
        cmd = "TSContext",
        opts = {
          max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
          multiline_threshold = 1, -- Maximum number of lines to show for a single context
          separator = "-",
        },
      },
    },
    keys = function(_, keys)
      table.insert(keys, {
        "[C",
        function() require("treesitter-context").go_to_context() end,
        desc = "Jumping to context",
        silent = true,
      })
      return keys
    end,
    opts = function(_, opts)
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.go = {
        install_info = {
          url = "https://github.com/superappkid/tree-sitter-go",
          files = { "src/parser.c" },
          revision = "7444f1535e3ec32e7bf8b063b42201c0ef7e6097",
        },
        branch = "master",
      }
      parser_config.blade = {
        install_info = {
          url = "https://github.com/EmranMR/tree-sitter-blade",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "blade",
      }

      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.auto_install = false
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "angular",
        "bash",
        "blade",
        "c",
        "c_sharp",
        "cpp",
        "css",
        "cuda",
        "dart",
        "diff",
        "dockerfile",
        "gdscript",
        "glsl",
        "godot_resource",
        "go",
        "goctl",
        "gomod",
        "gosum",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "helm",
        "html",
        "http",
        "java",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "kdl",
        "kotlin",
        "lua",
        "luap",
        "markdown",
        "markdown_inline",
        "nix",
        "objc",
        "php",
        "phpdoc",
        "proto",
        "python",
        "ruby",
        "rust",
        "scss",
        "sql",
        "styled",
        "swift",
        "svelte",
        "templ",
        "terraform",
        "toml",
        "tsx",
        "typescript",
        "vue",
        "vim",
        "xml",
        "yaml",
      })

      opts.textobjects.select.enable = false
      opts.incremental_selection.enable = false

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
      vim.treesitter.language.register("scss", "less")
      vim.treesitter.language.register("scss", "postcss")
      vim.treesitter.language.register("gomod", "gowork")
    end,
  },
}
