-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)

local save_file = {
  "<cmd>w<cr><esc>",
  desc = "Save file",
}

return {
  -- first key is the mode
  n = {
    -- disabled
    -- ["<leader>q"] = false,
    -- ["<leader>w"] = false,

    -- save file
    ["<C-s>"] = save_file,

    -- buffers
    ["<S-h>"] = {
      function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
      desc = "Previou s buffer",
    },
    ["<S-l>"] = {
      function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Next buffer",
    },

    -- tabs
    ["<leader><tab><tab>"] = { "<cmd>tabnew<cr>", desc = "New Tab" },
    ["<leader><tab>q"] = { "<cmd>tabclose<cr>", desc = "Close Tab" },

    -- ["<leader>ur"] = {
    --   "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
    --   desc = "Redraw / clear hlsearch / diff update",
    -- },
    ["<leader>a"] = { "<cmd>AerialToggle<cr>", desc = "Toggle Aerial" },
  },
  t = {
    ["<esc><esc>"] = { "<c-\\><c-n>", desc = "Enter Normal Mode" },
  },
  i = {
    -- save file
    ["<C-s>"] = save_file,
  },
  v = {
    -- save file
    ["<C-s>"] = save_file,
  },
  s = {
    -- save file
    ["<C-s>"] = save_file,
  },
}
