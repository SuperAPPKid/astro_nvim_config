-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

local isStdIn = false
local autocmds = {
  alpha_autostart = false,
  session_restore = {
    {
      event = "StdinReadPre",
      callback = function() isStdIn = true end,
    },
    {
      event = "VimEnter",
      callback = vim.schedule_wrap(function()
        -- Only load the session if nvim was started with no args
        if vim.fn.argc(-1) == 0 and not isStdIn then
          require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
        else
          vim.api.nvim_del_augroup_by_name "resession_auto_save"
        end
      end),
    },
  },
}

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        wrap = true, -- sets vim.opt.wrap
        autoread = true,
        tabstop = 4,
        shiftwidth = 4,
        softtabstop = 4,
        swapfile = false,
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
        autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
        autopairs_enabled = true, -- enable autopairs at start
        diagnostics_mode = 3, -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
        icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
        ui_notifications_enabled = true, -- disable notifications when toggling UI elements
        inlay_hints_enabled = true, -- enable or disable LSP inlay hints on startup (Neovim v0.10 only)
        -- move_normal_option = 1,
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs with `H` and `L`
        -- L = {
        --   function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
        --   desc = "Next buffer",
        -- },
        -- H = {
        --   function() require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
        --   desc = "Previous buffer",
        -- },

        -- mappings seen under group name "Buffer"
        ["<Leader>bD"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        ["<Leader>b"] = { desc = "Buffers" },
        -- quick save
        -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
      },
      t = {
        -- setting a mapping to false will disable it
        -- ["<esc>"] = false,
      },
    },
    autocmds = {
      alpha_autostart = false,
      session_restore = {
        {
          event = "StdinReadPre",
          callback = function() isStdIn = true end,
        },
        {
          event = "VimEnter",
          callback = vim.schedule_wrap(function()
            -- Only load the session if nvim was started with no args
            if vim.fn.argc(-1) == 0 and not isStdIn then
              require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
            else
              vim.api.nvim_del_augroup_by_name "resession_auto_save"
            end
          end),
        },
        {
          event = "VimEnter",
          desc = "Start Oil when vim is opened with no arguments",
          group = vim.api.nvim_create_augroup("oil_autostart", { clear = true }),
          callback = vim.schedule_wrap(function()
            local should_skip
            local lines = vim.api.nvim_buf_get_lines(0, 0, 2, false)
            if
              vim.fn.argc() > 0 -- don't start when opening a file
              or #lines > 1 -- don't open if current buffer has more than 1 line
              or (#lines == 1 and lines[1]:len() > 0) -- don't open the current buffer if it has anything on the first line
              or #vim.tbl_filter(function(bufnr) return vim.bo[bufnr].buflisted end, vim.api.nvim_list_bufs()) > 1 -- don't open if any listed buffers
              or not vim.o.modifiable -- don't open if not modifiable
            then
              should_skip = true
            else
              for _, arg in pairs(vim.v.argv) do
                if arg == "-b" or arg == "-c" or vim.startswith(arg, "+") or arg == "-S" then
                  should_skip = true
                  break
                end
              end
            end
            if should_skip then return end
            require("oil").open()
          end),
        },
      },
    },
  },
}
