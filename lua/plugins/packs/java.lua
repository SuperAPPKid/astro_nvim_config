---@type LazySpec
return {
  {
    "AstroNvim/astrolsp",
    opts = function(_, opts)
      opts.servers = require("astrocore").list_insert_unique(opts.servers, { "jdtls" })
      opts.handlers.jdtls = function(server, opts)
        require("lazy").load { plugins = { "nvim-java" } }
        require("lspconfig")[server].setup(opts)
      end
    end,
  },

  {
    "nvim-java/nvim-java",
    lazy = true,
    config = true,
  },
}
