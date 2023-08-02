local Buff = {}

local EXPAND_PARAM = {
  CURR_BUF_PATH = "%",
  AUTOCMD_PATH = "<afile>",
}

---Get buffers path
---@param absolute boolean?
Buff.get_path = function(absolute)
  local addon = ""
  if absolute then
    addon = ":p"
  end
  local path = vim.fn.expand(EXPAND_PARAM.AUTOCMD_PATH .. addon)
  if path == "" then
    path = vim.fn.expand(EXPAND_PARAM.CURR_BUF_PATH .. addon)
  end
  return path
end

---Get current buffer
---@return number
Buff.get_bufnr = function ()
  return vim.api.nvim_get_current_buf()
end

---Check if a buffer exist
---    The buffer can exist without being open
---@param bufnr number
---@return boolean
Buff.exist = function(bufnr)
  return vim.fn.buffer_exists(bufnr) == 1
end

---Check if the buffer exist AND is open
---@param bufnr number
---@return boolean
Buff.is_open = function(bufnr)
  assert(type(bufnr) == "number", "number expected but " .. bufnr .. " given")
  return Buff.exist(bufnr) and vim.bo[bufnr].buflisted
end

---Create a new buffer
---@param opts table
---@return number
Buff.create_buffer = function(opts)
  assert(type(opts) == "table", "options should be a table")
  return vim.api.nvim_create_buf(opts.make_listed or true, opts.make_scratch or false)
end

---Give a name to a buffer
---@param bufnr number
---@param name string
Buff.set_buffer_name = function(bufnr, name)
  -- Note: setting buffer name will give it full path to project root
  assert(Buff.exist(bufnr), "given buffer does not exist")
  return vim.api.nvim_buf_set_name(bufnr, name)
end

---Give a name to a buffer
---@param bufnr number
---@return string
Buff.get_buffer_name = function(bufnr)
  -- Note: Getting buffer name returns full path (wether it exists or not)
  assert(Buff.exist(bufnr), "given buffer does not exist")
  return vim.api.nvim_buf_get_name(bufnr)
end

---Append lines to an existing buffer
---@param bufnr number
---@param text any
---@return nil
Buff.append_text = function(bufnr, text)
  -- Code here
  if not text then
    return nil
  elseif type(text) ~= "table" then
    text = { tostring(text) }
  end
  return vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, text)
end

---Clear buffer content
---@param bufnr number
Buff.clear_text = function (bufnr)
  assert(Buff.exist(bufnr), "Buffer to clear must exist")
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "" })
end

---Close (but not delete) given buffer
---@param bufnr number
Buff.close = function(bufnr)
  assert(Buff.exist(bufnr), "buffer to close must exist")
  vim.api.nvim_buf_delete(bufnr, { unload = true })
end

---Delete given buffer
---@param bufnr number
---@param force boolean?
Buff.delete = function(bufnr, force)
  assert(Buff.exist(bufnr), "buffer to delete must exist")
  vim.api.nvim_buf_delete(bufnr, { unload = false, force = force or false })
end


---Get selected text from current buffer
---@return string 
---TODO: Find a simpler way to do this.
Buff.get_buf_selected_text = function()
  local _, start_row, start_col = unpack(vim.fn.getcurpos())
  local end_row = tonumber(vim.fn.line "v")
  local end_col = tonumber(vim.fn.col "v")

  if start_row == end_row and start_col > end_col then
    start_col, end_col = end_col, start_col
  end
  if start_row > end_row then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end

  local text = vim.api.nvim_buf_get_text(
    0,
    tonumber(start_row) - 1,
    tonumber(start_col) - 1,
    tonumber(end_row) - 1,
    tonumber(end_col),
    {}
  )

  return vim.fn.join(text, " ")
end

return Buff
