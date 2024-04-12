local get_hlgroup = require("astronvim.utils").get_hlgroup
local C = require("astronvim.utils.status.env").fallback_colors
local Comment = get_hlgroup("Comment", { fg = C.bright_grey, bg = C.bg })
local TabLineFill = get_hlgroup("TabLineFill", { fg = C.fg, bg = C.dark_bg })
return {
  buffer_visible_fg = Comment.fg,
  buffer_visible_bg = TabLineFill.bg,
}
