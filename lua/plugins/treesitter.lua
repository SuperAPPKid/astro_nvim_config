-- Customize Treesitter

---@type LazySpec
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
    {
      "andymass/vim-matchup",
      event = "User AstroFile",
      init = function()
        -- vim.g.matchup_matchparen_offscreen = { method = "popup", fullwidth = 1, highlight = "Normal", syntax_hl = 1 }
        vim.g.matchup_matchparen_offscreen = {}
        vim.g.matchup_transmute_enabled = 1
        vim.g.matchup_delim_noskips = 2

        -- vim.g.matchup_motion_enabled = 0
        vim.g.matchup_text_obj_enabled = 0
        -- vim.g.matchup_motion_cursor_end = 0

        vim.g.matchup_matchparen_nomode = "i"
        vim.g.matchup_matchparen_deferred = 1
        vim.g.matchup_matchparen_hi_surround_always = 1
      end,
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
        revision = "eabb298ee52187d9aa8cab74b81fbdb5166faa28",
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

    opts.textobjects.select.enable = false
    opts.incremental_selection.enable = false
    opts.matchup = { enable = true }

    -- add more things to the ensure_installed table protecting against community packs modifying it
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
      "dockerfile",
      "gdscript",
      "glsl",
      "godot_resource",
      "go",
      "gomod",
      "gosum",
      "gowork",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "helm",
      "html",
      "java",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
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
      "scss",
      "sql",
      "swift",
      "svelte",
      "tmux",
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
    vim.treesitter.language.register("scss", "less")
    vim.treesitter.language.register("scss", "postcss")
  end,
}
