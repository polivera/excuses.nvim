local buffer = require("excuses.buffer")
local M = {}

---Get the window ID that contains a buffer
---   If the buffer is not on any window it will return -1
---   If the buffer does not exist it will error out
---@param bufnr number
---@return number
M.id_contain_buffer = function(bufnr)
  return buffer.get_win_id(bufnr)
end

---Get tab layout
---@return table
M.get_layout = function()
  return vim.fn.winlayout()
end


return M
