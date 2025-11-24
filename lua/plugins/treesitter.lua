-- Customize Treesitter

---@type LazySpec
---@diagnostic disable: inject-field, missing-fields
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
      parser_config.blade.filetype = "blade"

      require("nvim-treesitter.configs").setup {
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,
        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = false,
        -- List of parsers to ignore installing (or "all")
        ignore_install = {},
        ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
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
        }),
        textobjects = {
          select = {
            enable = false,
          },
          move = {
            goto_next_start = {
              ["]f"] = { query = "@function.outer", desc = "Next function start" },
              ["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
            },
            goto_next_end = {
              ["]F"] = { query = "@function.outer", desc = "Next function end" },
              ["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
            },
            goto_previous_start = {
              ["[f"] = { query = "@function.outer", desc = "Previous function start" },
              ["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
            },
            goto_previous_end = {
              ["[F"] = { query = "@function.outer", desc = "Previous function end" },
              ["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
            },
          },
          swap = {
            swap_next = {
              [">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
            },
            swap_previous = {
              ["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
            },
          },
        },
        incremental_selection = {
          enable = false,
        },
      }

      vim.treesitter.language.register("bash", "dotenv")
      vim.treesitter.language.register("scss", "less")
      vim.treesitter.language.register("scss", "postcss")
      vim.treesitter.language.register("gomod", "gowork")
    end,
  },
}
