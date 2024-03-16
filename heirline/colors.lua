local get_hlgroup = require("astronvim.utils").get_hlgroup
local C = require("astronvim.utils.status.env").fallback_colors
local Comment = get_hlgroup("Comment", { fg = C.bright_grey, bg = C.bg })
return {
  buffer_visible_fg = Comment.fg,
}
