require("lazy").setup({
  {
    "AstroNvim/AstroNvim",
    version = "^5", -- Remove version tracking to elect for nighly AstroNvim
    import = "astronvim.plugins",
    opts = { -- AstroNvim options must be set here with the `import` key
      mapleader = " ", -- This ensures the leader key must be configured before Lazy is set up
      maplocalleader = "", -- This ensures the localleader key must be configured before Lazy is set up
      icons_enabled = true, -- Set to false to disable icons (if no Nerd Font is available)
      pin_plugins = false, -- Default will pin plugins when tracking `version` of AstroNvim, set to true/false to override
    },
  },
  { import = "community" },
  { import = "astro" },
  { import = "plugins" },
} --[[@as LazySpec]], {
  -- Configure any other `lazy.nvim` configuration options here
  install = { colorscheme = { "astrodark", "habamax" } },
  ui = {
    border = "double",
  },
  performance = {
    rtp = {
      -- disable some rtp plugins, add more to your liking
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "zipPlugin",
      },
    },
  },
  git = {
    timeout = 300, -- kill processes that take more than 5 minutes
  },
  concurrency = 32,
} --[[@as LazyConfig]])
