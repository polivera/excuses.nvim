local buffer = require("excuses.buffer")
local M = {}

---Use options to tell if it is horizontal or vertical and/or to give buf nr
M.create_split = function(bufnr)
  assert(not bufnr or buffer.exist(bufnr), "buffer should exist")
  vim.cmd'vsplit'
  if bufnr then
    vim.cmd('buffer' .. tostring(bufnr))
  end
end

return M
