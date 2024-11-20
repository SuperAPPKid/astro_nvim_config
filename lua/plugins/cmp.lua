---@type LazySpec
return {

  {
    "Exafunction/codeium.nvim",
    event = "User AstroFile",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    config = function(_, opts) require("codeium").setup(opts) end,
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
        "<C-f>",
        function() return require("codeium.virtual_text").accept() end,
        mode = "i",
        silent = true,
        expr = true,
        script = true,
        nowait = true,
      },
      {
        "<A-l>",
        function() require("codeium.virtual_text").cycle_completions(1) end,
        mode = "i",
        silent = true,
      },
      {
        "<A-h>",
        function() require("codeium.virtual_text").cycle_completions(-1) end,
        mode = "i",
        silent = true,
      },
      {
        "<C-x>",
        function() require("codeium.virtual_text").clear() end,
        mode = "i",
        silent = true,
      },
      {
        "<C-e>",
        function() require("codeium.virtual_text").complete() end,
        mode = "i",
        silent = true,
      },
    },
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- { "chrisgrieser/cmp-nerdfont" },
      { "hrsh7th/cmp-emoji" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-calc" },
      { "f3fora/cmp-spell" },
      { "Exafunction/codeium.nvim" },
      { "kdheepak/cmp-latex-symbols" },
    },
    config = function(_, opts)
      local cmp = require "cmp"
      cmp.setup(opts)
      cmp.setup.filetype({ "help", "lazy" }, {
        sources = {
          { name = "path" },
          { name = "buffer" },
        },
      })

      local group = vim.api.nvim_create_augroup("cmp", {})
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "saga*",
        group = group,
        callback = function(_) cmp.setup.buffer { sources = {} } end,
      })
    end,
    opts = function(_, opts)
      local cmp = require "cmp"

      opts.sources = cmp.config.sources {
        { name = "nvim_lsp", priority = 1000 },
        { name = "nvim_lua", priority = 900 },
        { name = "luasnip", priority = 800 },
        -- { name = "nerdfont", priority = 800 },
        { name = "emoji", priority = 700 },
        {
          name = "latex_symbols",
          priority = 700,
          option = {
            -- 0 mixed Show the command and insert the symbol
            -- 1 julia Show and insert the symbol
            -- 2 latex Show and insert the command
            strategy = 0,
          },
        },
        { name = "codeium", priority = 600 },
        -- { name = "buffer", priority = 500 },
        { name = "path", priority = 500 },
        {
          name = "spell",
          priority = 500,
          option = {
            keep_all_entries = false,
            enable_in_context = function() return true end,
            preselect_correct_word = true,
          },
        },
        { name = "calc", priority = 400 },
      }

      local kind_icons = {
        Text = "",
        Method = "m",
        Function = "󰊕",
        Constructor = "",
        Field = "",
        Variable = "󰆧",
        Class = "󰌗",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰇽",
        Struct = "󱥒",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰊄",
        Codeium = "󰚩",
        Copilot = "",
      }

      local menu_names = {
        nvim_lsp = "LSP",
        nvim_lua = "lua",
        luasnip = "Snippet",
        buffer = "Buffer",
        path = "PATH",
        emoji = "emoji",
        calc = "Calc",
        spell = "Spell",
        codeium = "Codeium",
        cmdline = "cmd",
        git = "Git",
      }

      opts.formatting = {
        fields = { "abbr", "kind", "menu" },
        format = function(entry, item)
          local ok, hl_colors = pcall(require, "nvim-highlight-colors")
          local color_item = ok and hl_colors.format(entry, { kind = item.kind })

          if color_item and color_item.abbr_hl_group then
            item.kind_hl_group = color_item.abbr_hl_group
            item.kind = " " .. color_item.abbr .. " " .. item.kind
          else
            item.kind = " " .. kind_icons[item.kind] .. " " .. item.kind
          end

          local menu_name = menu_names[entry.source.name]
          if menu_name then item.menu = "[" .. menu_name .. "]" end
          return item
        end,
      }

      opts.mapping["<C-E>"] = cmp.mapping(function()
        require("cmp").abort()
        require("codeium.virtual_text").complete()
      end, { "i", "c" })
      opts.mapping["<C-Y>"] = cmp.mapping(function()
        if cmp.visible_docs() then
          cmp.close_docs()
        else
          cmp.open_docs()
        end
      end, { "i" })

      opts.window.completion.border = "double"
      opts.window.documentation.border = "double"
      opts.view = {
        docs = { auto_open = false },
      }

      return opts
    end,
  },
}
