-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
return {
  "AstroNvim/astroui",
  version = false,
  specs = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local get_icon = require("astroui").get_icon
        opts.signs = {
          DapBreakpoint = {
            text = get_icon "DapBreakpoint",
            texthl = "DiagnosticInfo",
            linehl = "DiagnosticBgInfo",
          },
          DapBreakpointCondition = {
            text = get_icon "DapBreakpointCondition",
            texthl = "DiagnosticInfo",
            linehl = "DiagnosticBgInfo",
          },
          DapBreakpointRejected = {
            text = get_icon "DapBreakpointRejected",
            texthl = "DiagnosticError",
            linehl = "DiagnosticBgError",
          },
          DapLogPoint = {
            text = get_icon "DapLogPoint",
            texthl = "DiagnosticInfo",
            linehl = "DiagnosticBgInfo",
          },
          DapStopped = {
            text = get_icon "DapStopped",
            texthl = "DiagnosticWarn",
            linehl = "DiagnosticBgWarn",
          },
        }
      end,
    },
  },
  opts = {
    highlights = {
      init = {}, -- this table overrides highlights in all themes
      astrotheme = { -- a table of overrides/changes when applying the astrotheme theme
        -- Normal = { bg = "#000000" },
      },
    },
    icons = {
      commit = "",
      coverage = "",
      link = "",
      misc = "",
      note = "",
      planet = "",
      project = "󰃥",
      refactoring = "󰣪",
      req = "󱗆",
      tab = "",
      test = "󰙨",
      watch = "󰂥",
      Avante = "",
      Dial = "󱓉",
      Dial_additive = "󱖢",
      IdeHelper = "󱚌", -- php
      Laravel = "󰫐", -- php
      Octo = "",
      Overseer = "",
      Trouble = "󱍼",
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
