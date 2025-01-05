local M = {}

setmetatable(M, {
  __index = function(_, key)
    vim.notify(string.format("No such function: %s", key), vim.log.levels.ERROR)
    return function() end
  end,
})

return M
