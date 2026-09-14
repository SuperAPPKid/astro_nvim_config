---@type LazySpec
return {
  {
    "Exafunction/codeium.nvim",
    event = "User AstroFile",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    config = function(_, opts)
      vim.env.DEBUG_CODEIUM = "fatal"
      require("codeium").setup(opts)
    end,
    opts = {
      enable_chat = false,
      enable_cmp_source = true,
      virtual_text = {
        enabled = true,
        manual = true,
        map_keys = false,
        idle_delay = 50,
      },
    },
    keys = {
      {
        "<C-F>",
        function() return require("codeium.virtual_text").accept() end,
        mode = "i",
        expr = true,
        script = true,
        nowait = true,
      },
      {
        "<A-l>",
        function() require("codeium.virtual_text").cycle_completions(1) end,
        mode = "i",
      },
      {
        "<A-h>",
        function() require("codeium.virtual_text").cycle_completions(-1) end,
        mode = "i",
      },
      {
        "<C-X>",
        function() require("codeium.virtual_text").clear() end,
        mode = "i",
      },
      {
        "<C-E>",
        function() require("codeium.virtual_text").complete() end,
        mode = "i",
      },
    },
  },
}
