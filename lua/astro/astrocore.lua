-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`

local extend_tbl = require("astrocore").extend_tbl
local save_file = {
  function()
    if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "" then
      return "<Cmd>w<CR><Esc>"
    else
      return "<Esc>"
    end
  end,
  desc = "Save file",
  silent = true,
  expr = true,
}

---@type LazySpec
return {
  "AstroNvim/astrocore",
  version = false,
  opts = function(_, opts)
    -- Configure core features of AstroNvim
    opts.features = extend_tbl(opts.features, {
      large_buf = { size = 1024 * 1024 * 1.5, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    })

    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    opts.diagnostics = extend_tbl(opts.diagnostics, {
      float = {
        border = "double",
        format = function(diagnostic) return string.format("%s [%s]", diagnostic.message, diagnostic.source) end,
      },
      update_in_insert = false,
      virtual_text = {
        replace = "replace",
        prefix = function(_, index, total)
          if total > 1 then
            if index == total then
              return string.format("[%d/%d]", index, total)
            else
              return ""
            end
          else
            return "■"
          end
        end,
      },
      underline = { severity = { vim.diagnostic.severity.ERROR } },
    })

    -- vim options can be configured here
    opts.options = extend_tbl(opts.options, {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        wrap = true, -- sets vim.opt.wrap
        autoread = true,
        swapfile = false,
      },

      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
        autoformat = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
        autopairs_enabled = true, -- enable autopairs at start
        icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
        ui_notifications_enabled = true, -- disable notifications when toggling UI elements
        inlay_hints_enabled = true, -- enable or disable LSP inlay hints on startup (Neovim v0.10 only)
        textwidth = 0,
        -- move_normal_option = 1,
        wrap = true,
        netrw_nogx = 1, -- disable netrw gx
      },
    })

    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    opts.mappings = extend_tbl(opts.mappings, {
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
        gl = false,

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
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },

        --tabs
        ["<Leader><Tab>"] = { desc = require("astroui").get_icon("tab", 1, true) .. "Tabs" },
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

        ["<C-S>"] = save_file,
        ["<C-Q>"] = { "<Cmd>confirm qall<CR>", desc = "Force quit" },
        ["<C-W>d"] = { "" },
        ["<C-W><C-D>"] = { "" },

        ["<Leader>fr"] = false,
        ["<Leader>fg"] = false,

        ["<Leader>gt"] = false,
        ["<Leader>gK"] = false,

        ["<Leader>l"] = false,
        ["<Leader>lD"] = false,

        ["<Leader>w"] = false,

        ["<Leader>z"] = { desc = require("astroui").get_icon("misc", 1, true) .. "Misc" },
      },
      i = {
        -- quick save
        ["<C-S>"] = save_file,
        ["<C-L>"] = "<Right>",
        ["<C-H>"] = "<Left>",
      },
      x = {
        ["<Leader>z"] = { desc = " Misc" },
        ["<C-S>"] = save_file,
      },
      s = {
        -- save file
        ["<C-S>"] = save_file,
      },
      t = {},
      c = {
        ["<C-B>"] = "<S-Left>",
        ["<C-F>"] = "<S-Right>",
        ["<C-L>"] = "<Right>",
        ["<C-H>"] = "<Left>",
      },
    })

    -- configure functions on key press
    opts.on_keys = extend_tbl(opts.on_keys, {
      -- first key is the namespace
      auto_hlsearch = {
        -- list of functions to execute on key press (:h vim.on_key)
        function(char) -- example automatically disables `hlsearch` when not actively searching
          if vim.fn.mode() == "n" then
            local new_hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
            if vim.opt.hlsearch ~= new_hlsearch then vim.opt.hlsearch = new_hlsearch end
          end
        end,
      },
    })
  end,
}
