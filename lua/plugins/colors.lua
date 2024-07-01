return {
  { "NvChad/nvim-colorizer.lua", enabled = false },
  {
    "uga-rosa/ccc.nvim",
    tag = "v1.7.2",
    event = "User AstroFile",
    cmd = { "CccPick", "CccConvert" },
    dependencies = {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        maps.n["<Leader>zc"] = { "<cmd>CccConvert<cr>", desc = "Convert color" }
        maps.n["<Leader>zp"] = { "<cmd>CccPick<cr>", desc = "Pick Color" }
      end,
    },
    config = function(_, opts)
      require("ccc").setup(opts)
      vim.api.nvim_del_user_command "CccHighlighterEnable"
      vim.api.nvim_del_user_command "CccHighlighterDisable"
      vim.api.nvim_del_user_command "CccHighlighterToggle"

      -- local highlighter = opts.highlighter
      -- local action = function() vim.cmd.CccHighlighterToggle() end
      -- if highlighter then
      --   local flag = highlighter.auto_enable
      --   local toggle = vim.schedule_wrap(function()
      --     if flag then
      --       vim.cmd.CccHighlighterEnable()
      --     else
      --       vim.cmd.CccHighlighterDisable()
      --     end
      --   end)
      --   action = function()
      --     flag = not flag
      --     toggle()
      --   end
      --
      --   vim.api.nvim_create_autocmd({ "BufEnter" }, {
      --     callback = toggle,
      --   })
      --
      --   toggle()
      -- end
      --
      -- require("astrocore").set_mappings {
      --   n = {
      --     ["<Leader>uC"] = {
      --       action,
      --       desc = "Toggle colorizer",
      --     },
      --   },
      -- }
    end,
    opts = {
      highlighter = {
        auto_enable = false,
        lsp = true,
      },
    },
  },

  {
    "brenoprata10/nvim-highlight-colors",
    event = "User AstroFile",
    cmd = "HighlightColors",
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>uC"] = { function() vim.cmd.HighlightColors "Toggle" end, desc = "Toggle color highlight" }
        end,
      },
    },
    opts = {
      render = "virtual",
      virtual_symbol = "󰚍",
      enable_tailwind = true,
    },
  },
}
