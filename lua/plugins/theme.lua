return {
  "rebelot/kanagawa.nvim",
  opts = {
    compile = false, -- enable compiling the colorscheme
    undercurl = true, -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = true, -- do not set background color
    dimInactive = false, -- dim inactive window `:h hl-NormalNC`
    terminalColors = false, -- define vim.g.terminal_color_{0,17}
    colors = { -- add/modify theme and palette colors
      theme = {
        dragon = {
          ui = {
            fg_dim = "#c5c9c5",
            bg = "#1F1F28",
          },
        },
        all = {
          ui = {
            bg_gutter = "none",
          },
        },
      },
    },
    overrides = function(colors)
      local theme = colors.theme
      local palette = colors.palette
      return {
        NormalFloat = { bg = "none" },
        WinSeparator = { fg = palette.dragonBlue, bg = "none" },
        FloatBorder = { fg = theme.ui.fg_dim, bg = "none" },
        FoldColumn = { fg = theme.ui.fg_dim, bg = "none" },
        FloatTitle = { bg = "none" },

        -- Save an hlgroup with dark background and dimmed foreground
        -- so that you can use it where your still want darker windows.
        -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
        NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

        -- Popular plugins that open floats will link to NormalFloat by default;
        -- set their background accordingly if you wish to keep them dark and borderless
        LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
        MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

        NeoTreeFloatBorder = { fg = theme.ui.fg_dim, bg = "none" },
        NeoTreeTitleBar = { fg = theme.ui.bg_m3, bg = theme.ui.fg_dim },
        NeoTreeFloatTitle = { fg = theme.ui.bg_m3, bg = theme.ui.fg_dim },

        WhichKeyFloat = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
        LspInfoBorder = { fg = theme.ui.fg_dim, bg = "none" },
        DapUIFloatBorder = { fg = theme.ui.fg_dim, bg = "none" },

        TelescopePromptBorder = { fg = theme.ui.fg_dim, bg = "none" },
        TelescopeResultsBorder = { fg = theme.ui.fg_dim, bg = "none" },
        TelescopePreviewBorder = { fg = theme.ui.fg_dim, bg = "none" },

        IlluminatedWordText = { bg = palette.winterRed },
        IlluminatedWordRead = { bg = palette.winterRed },
        IlluminatedWordWrite = { bg = palette.winterRed },

        DiagnosticUnderlineError = { sp = palette.peachRed },
        DiagnosticUnderlineWarn = { sp = palette.surimiOrange },
        DiagnosticUnderlineInfo = { sp = palette.dragonGreen },
        DiagnosticUnderlineHint = { sp = palette.crystalBlue },
        DiagnosticUnderlineOk = { sp = palette.springGreen },
      }
    end,
    theme = "dragon", -- Load "wave" theme when 'background' option is not set
    background = { -- map the value of 'background' option to a theme
      dark = "dragon", -- try "dragon" !
      light = "lotus",
    },
  },
}
