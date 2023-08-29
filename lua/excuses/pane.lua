local buffer = require("excuses.buffer")
local window = require("excuses.window")
local M = {}

---Focus pane on specific buffer
---@param bufnr number
M.focus_on_buffer = function(bufnr)
  vim.cmd("buffer" .. tostring(bufnr))
end

---Create a split. Can be focus to a specific buffer
---@param opts table
M.create_split = function(opts)
  assert(not opts or type(opts) == "table", "opts could be empty or a table")
  opts = opts or {}
  opts.bufnr = opts.bufnr or nil
  opts.horizontal = opts.horizontal or false

  if opts.horizontal then
    vim.cmd 'split'
  else
    vim.cmd 'vsplit'
  end
  if opts.bufnr then
    M.focus_on_buffer(opts.bufnr)
  end
end

-- Close buffer without clossing the pane
M.close_buffer = function()
  -- TODO:
  -- Implement a function that allow deleting a buffer without 
  -- loosing the current layout
end

return M
