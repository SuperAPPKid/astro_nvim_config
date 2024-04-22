-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`

local utils = require "astrocore"
local is_available = utils.is_available

-- mapping

local save_file = {
  "<cmd>w<cr><esc>",
  desc = "Save file",
}

local mapping = {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map

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
    ["<leader><tab>"] = { desc = " Tabs" },
    ["<leader><tab>n"] = {
      function()
        local bufr = vim.api.nvim_get_current_buf()
        local view = vim.fn.winsaveview()
        local f_name = vim.fn.fnameescape(vim.api.nvim_buf_get_name(bufr))

        vim.cmd(string.format("tabnew %s", f_name))
        vim.fn.winrestview(view)
      end,
      desc = "New Tab",
    },
    ["<leader><tab>N"] = {
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
    ["<leader><tab>q"] = {
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

    ["<leader>du"] = {
      function() require("dapui").toggle { reset = true } end,
      desc = "Toggle Debugger UI",
    },

    ["<leader>f'"] = false,
    ["<leader>fr"] = false,

    ["<leader>z"] = { desc = " Misc" },

    ["<C-q>"] = { "<cmd>qa!<cr>", desc = "Force quit" },
  },
  i = {
    -- quick save
    ["<C-s>"] = save_file,
  },
  v = {
    ["<C-s>"] = save_file,
  },
  s = {
    -- save file
    ["<C-s>"] = save_file,
  },
  t = {},
}

if is_available "toggleterm.nvim" and vim.fn.executable "joshuto" == 1 then
  mapping.n["<leader>tj"] = {
    function()
      local edit_cmd = ""
      local fm_tmpfile = vim.fn.tempname()
      local feedkeys = function(keys)
        local key_termcode = vim.api.nvim_replace_termcodes(keys, true, true, true)
        vim.api.nvim_feedkeys(key_termcode, "n", false)
      end
      local opts = {
        direction = "float",
        hidden = true,
        cmd = string.format('joshuto --file-chooser --output-file="%s"', fm_tmpfile),
        dir = vim.fn.expand "%:p:h",
        on_open = function(term)
          edit_cmd = "edit"
          vim.keymap.set("t", "<Tab>", function()
            edit_cmd = "tabedit"
            feedkeys "<cr>"
          end, { noremap = true, silent = true, buffer = term.bufnr })
          vim.keymap.set("t", "\\", function()
            edit_cmd = "split"
            feedkeys "<cr>"
          end, { noremap = true, silent = true, buffer = term.bufnr })
          vim.keymap.set("t", "|", function()
            edit_cmd = "vsplit"
            feedkeys "<cr>"
          end, { noremap = true, silent = true, buffer = term.bufnr })
        end,
        on_exit = function()
          local file = io.open(fm_tmpfile, "r")
          if file ~= nil then
            local file_name = file:read "*a"
            file:close()
            os.remove(fm_tmpfile)
            vim.uv.new_timer():start(0, 0, vim.schedule_wrap(function() vim.cmd(edit_cmd .. " " .. file_name) end))
          end
        end,
      }
      utils.toggle_term_cmd(opts)
    end,
    desc = "ToggleTerm joshuto",
  }
end

if is_available "neo-tree.nvim" then
  mapping.n["<leader>e"] = { "<cmd>Neotree toggle<cr>", desc = "Toggle Filesystem" }
  mapping.n["<leader>be"] = { "<cmd>Neotree source=buffers toggle<cr>", desc = "Toggle Buffers (neo-tree)" }
  mapping.n["<leader>ge"] = { "<cmd>Neotree source=git_status toggle<cr>", desc = "Toggle Git (neo-tree)" }
  mapping.n["<leader>le"] = { "<cmd>Neotree source=diagnostics toggle<cr>", desc = "Toggle Diagnostics (neo-tree)" }
end

if is_available "nvim-dap-ui" then
  local function open_float(element)
    require("dapui").float_element(element, {
      height = nil,
      width = math.floor(vim.o.columns * 0.8),
      enter = true,
    })
  end
  mapping.n["<Leader>dh"] = { function() require("dap.ui.widgets").hover() end, desc = "Debugger Hover" }
  mapping.n["<leader>dH"] = { function() open_float "scopes" end, desc = "Debugger Hover" }
  mapping.n["<leader>du"] = { function() require("dapui").toggle() end, desc = "Toggle REPL" }
  mapping.n["<leader>dB"] = { function() open_float "breakpoints" end, desc = "Open Breakpoints" }
  mapping.n["<leader>dd"] = { function() require("dap").clear_breakpoints() end, desc = "Clear Breakpoints" }
  mapping.n["<leader>dS"] = { function() open_float "stacks" end, desc = "Open Stacks" }
  mapping.n["<leader>dw"] = { function() open_float "watches" end, desc = "Open Watches" }
end

-- autocmds
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
    mappings = mapping,
    autocmds = autocmds,
  },
}
