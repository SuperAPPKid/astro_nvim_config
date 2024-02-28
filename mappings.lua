-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)

local save_file = {
  "<cmd>w<cr><esc>",
  desc = "Save file",
}

local mapping = {
  -- first key is the mode
  n = {
    -- disabled
    -- ["<leader>q"] = false,
    -- ["<leader>w"] = false,

    -- save file
    ["<C-s>"] = save_file,

    -- buffers
    ["H"] = {
      function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
      desc = "Previous buffer",
    },
    ["L"] = {
      function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Next buffer",
    },

    -- tabs
    ["<leader><tab>"] = { desc = " Tabs" },
    ["<leader><tab><tab>"] = {
      function()
        local bufr = vim.api.nvim_get_current_buf()
        local view = vim.fn.winsaveview()
        local f_name = vim.fn.fnameescape(vim.api.nvim_buf_get_name(bufr))

        vim.cmd("bwipeout " .. tostring(bufr))
        vim.cmd(string.format("tabnew %s", f_name))
        vim.fn.winrestview(view)
      end,
      desc = "New Tab",
    },
    ["<leader><tab>q"] = {
      function()
        local before_bufs = vim.fn.tabpagebuflist()

        vim.cmd "tabclose"

        local after_bufs = vim.fn.tabpagebuflist()

        -- find differnce from before_bufs to after_bufs
        local diff = {}
        for _, bb in ipairs(before_bufs) do
          if not vim.tbl_contains(after_bufs, bb) then require("astronvim.utils").list_insert_unique(diff, bb) end
        end

        for _, buf in ipairs(diff) do
          vim.cmd("bwipeout " .. tostring(buf))
        end
      end,
      desc = "New Tab",
    },

    -- ["<leader>ur"] = {
    --   "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
    --   desc = "Redraw / clear hlsearch / diff update",
    -- },

    -- fix dap-ui size changed issue temporarily
    ["<leader>du"] = {
      function() require("dapui").toggle { reset = true } end,
      desc = "Toggle Debugger UI",
    },

    ["<leader>f'"] = false,
    ["<leader>fr"] = false,

    ["<leader>z"] = { desc = " Misc" },
  },
  i = {
    -- save file
    ["<C-s>"] = save_file,
  },
  v = {
    -- save file
    ["<C-s>"] = save_file,

    -- plugin: Yanky conflict with this key
    -- paste without yanking selected text
    -- ["p"] = { "P", desc = "Paste without yanking" },
  },
  s = {
    -- save file
    ["<C-s>"] = save_file,
  },
}

local utils = require "astronvim.utils"
local is_available = utils.is_available
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

return mapping
