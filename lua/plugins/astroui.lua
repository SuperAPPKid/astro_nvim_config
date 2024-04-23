-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
return {
  "AstroNvim/astroui",
  version = false,
  opts = {
    colorscheme = "kanagawa",
    highlights = {
      init = { -- this table overrides highlights in all themes
        -- Normal = { bg = "#000000" },
      },
      astrotheme = { -- a table of overrides/changes when applying the astrotheme theme
        -- Normal = { bg = "#000000" },
      },
    },
    icons = {
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
    status = {
      attributes = {
        buffer_active = { bold = true, italic = false },
        buffer_visible = { bold = true, italic = true },
      },
      colors = function(colors)
        local get_hlgroup = require("astroui").get_hlgroup
        local Comment = get_hlgroup "Comment"
        local TabLineFill = get_hlgroup "TabLineFill"

        colors.buffer_visible_fg = Comment.fg
        colors.buffer_visible_bg = TabLineFill.bg
        return colors
      end,
    },
  },
}
