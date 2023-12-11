return {
  "nvim-treesitter/nvim-treesitter",
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
    opts.textobjects = {
      select = { enabled = false },
      move = { enabled = false },
      swap = { enabled = false },
    }
    vim.treesitter.language.register("bash", "dotenv")
    vim.treesitter.language.register("go", "api")
  end,
}
