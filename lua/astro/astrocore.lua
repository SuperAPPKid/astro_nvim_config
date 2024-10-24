-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`

local utils = require "astrocore"
local is_available = utils.is_available

-- mapping

local save_file = {
  "<Cmd>w<CR><Esc>",
  desc = "Save file",
}

local mapping = {
  -- first key is the mode
  n = {
    h = {
      function()
        if vim.v.count > 1 then
          return "m'" .. vim.v.count .. "h"
        else
          return "h"
        end
      end,
      expr = true,
      silent = true,
    },
    l = {
      function()
        if vim.v.count > 1 then
          return "m'" .. vim.v.count .. "l"
        else
          return "l"
        end
      end,
      expr = true,
      silent = true,
    },
    j = {
      function()
        if vim.v.count > 1 then
          return "m'" .. vim.v.count .. "j"
        else
          return "gj"
        end
      end,
      expr = true,
      silent = true,
    },
    k = {
      function()
        if vim.v.count > 1 then
          return "m'" .. vim.v.count .. "k"
        else
          return "gk"
        end
      end,
      expr = true,
      silent = true,
    },
    gj = "j",
    gk = "k",

    -- navigate buffer tabs with `H` and `L`
    L = {
      function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Next buffer",
    },
    H = {
      function() require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
      desc = "Previous buffer",
    },

    -- mappings seen under group name "Buffer"
    ["<Leader>bD"] = {
      function()
        require("astroui.status.heirline").buffer_picker(function(bufnr) require("astrocore.buffer").close(bufnr) end)
      end,
      desc = "Pick to close",
    },

    -- quick save
    ["<C-s>"] = save_file,

    --tabs
    ["<Leader><Tab>"] = { desc = " Tabs" },
    ["<Leader><Tab>n"] = {
      function()
        local bufr = vim.api.nvim_get_current_buf()
        local view = vim.fn.winsaveview()
        local f_name = vim.fn.fnameescape(vim.api.nvim_buf_get_name(bufr))

        vim.cmd(string.format("tabnew %s", f_name))
        vim.fn.winrestview(view)
      end,
      desc = "New Tab",
    },
    ["<Leader><Tab>N"] = {
      function()
        local helper = require "astrocore.buffer"
        local bufr = vim.api.nvim_get_current_buf()
        local view = vim.fn.winsaveview()
        local f_name = vim.fn.fnameescape(vim.api.nvim_buf_get_name(bufr))

        if helper.is_valid(bufr) then helper.close(bufr) end
        vim.cmd(string.format("tabnew %s", f_name))
        vim.fn.winrestview(view)
      end,
      desc = "Move to new Tab",
    },
    ["<Leader><Tab>q"] = {
      function()
        local helper = require "astrocore.buffer"
        local before_bufs = vim.fn.tabpagebuflist()

        vim.cmd "tabclose"

        local after_bufs = vim.fn.tabpagebuflist()

        -- find differnce from before_bufs to after_bufs
        local diff = {}
        for _, bb in ipairs(before_bufs) do
          if not vim.tbl_contains(after_bufs, bb) then require("astrocore").list_insert_unique(diff, { bb }) end
        end

        for _, buf in ipairs(diff) do
          if helper.is_valid(buf) then helper.close(buf) end
        end
      end,
      desc = "Close Tab",
    },

    ["<C-W>d"] = { "" },
    ["<C-W><C-D>"] = { "" },
    ["<Leader>f'"] = false,
    ["<Leader>fr"] = false,
    ["gl"] = false,
    ["<Leader>lD"] = false,
    ["<Leader>fd"] = {
      function() require("telescope.builtin").diagnostics() end,
      desc = "Search diagnostics",
    },
    ["<Leader>fF"] = {
      function() require("telescope.builtin").find_files { hidden = true, no_ignore = true, file_ignore_patterns = {} } end,
      desc = "Find all files",
    },
    ["<Leader>fH"] = {
      function() require("telescope.builtin").highlights() end,
      desc = "Find Highlight",
    },

    ["<Leader>lR"] = false,
    ["<Leader>gK"] = false,

    ["<Leader>z"] = { desc = " Misc" },

    ["<C-q>"] = { "<Cmd>qa!<CR>", desc = "Force quit" },

    gra = false,
    grn = false,
    grr = false,
  },
  i = {
    -- quick save
    ["<C-s>"] = save_file,
    ["<C-l>"] = "<Right>",
    ["<C-h>"] = "<Left>",
  },
  x = {
    ["<Leader>z"] = { desc = " Misc" },
    ["<C-s>"] = save_file,
    gra = false,
  },
  s = {
    -- save file
    ["<C-s>"] = save_file,
  },
  t = {},
}

if is_available "nvim-dap-ui" then
  local function open_float(element)
    require("dapui").float_element(element, {
      height = nil,
      width = math.floor(vim.o.columns * 0.8),
      enter = true,
    })
  end

  mapping.n["<Leader>dR"] = false
  mapping.n["<Leader>du"] = { function() require("dapui").toggle() end, desc = "Toggle REPL" }
  mapping.n["<Leader>dh"] = { function() require("dap.ui.widgets").hover() end, desc = "Debugger Hover" }
  mapping.n["<Leader>dH"] = { function() open_float "scopes" end, desc = "Open Scopes" }
  mapping.n["<Leader>dB"] = { function() open_float "breakpoints" end, desc = "Open Breakpoints" }
  mapping.n["<Leader>dd"] = { function() require("dap").clear_breakpoints() end, desc = "Clear Breakpoints" }
  mapping.n["<Leader>dS"] = { function() open_float "stacks" end, desc = "Open Stacks" }
  mapping.n["<Leader>dw"] = { function() open_float "watches" end, desc = "Open Watches" }
end

-- autocmds
local autocmds = {
  alpha_autostart = false,
}

---@type LazySpec
return {
  "AstroNvim/astrocore",
  version = false,
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
      update_in_insert = false,
      virtual_text = true,
      underline = { severity = { vim.diagnostic.severity.ERROR } },
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
        autoformat = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
        autopairs_enabled = true, -- enable autopairs at start
        diagnostics_mode = 3, -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
        icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
        ui_notifications_enabled = true, -- disable notifications when toggling UI elements
        inlay_hints_enabled = true, -- enable or disable LSP inlay hints on startup (Neovim v0.10 only)
        textwidth = 0,
        -- move_normal_option = 1,
        wrap = true,
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = mapping,
    autocmds = autocmds,
    -- configure functions on key press
    on_keys = {
      -- first key is the namespace
      auto_hlsearch = {
        -- list of functions to execute on key press (:h vim.on_key)
        function(char) -- example automatically disables `hlsearch` when not actively searching
          if vim.fn.mode() == "n" then
            local new_hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
            if vim.opt.hlsearch:get() ~= new_hlsearch then vim.opt.hlsearch = new_hlsearch end
          end
        end,
      },
    },
  },
}
