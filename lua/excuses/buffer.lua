local M = {}

local EXPAND_PARAM = {
  CURR_BUF_PATH = "%",
  AUTOCMD_PATH = "<afile>",
}

---Get buffers path
---@param absolute boolean?
M.get_path = function(absolute)
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
M.get_bufnr = function()
  ---TODO: I might have to check for autocmd buffer number expand()
  return vim.api.nvim_get_current_buf()
end

---Check if a buffer exist
---    The buffer can exist without being open
---@param bufnr number
---@return boolean
M.exist = function(bufnr)
  return vim.fn.buffer_exists(bufnr) == 1
end

---Check if the buffer exist AND is open
---@param bufnr number
---@return boolean
M.is_open = function(bufnr)
  assert(type(bufnr) == "number", "number expected but " .. bufnr .. " given")
  return M.exist(bufnr) and vim.bo[bufnr].buflisted
end

---Check if the buffer is loaded or not
---@param bufnr number
---@return boolean
M.is_loaded = function(bufnr)
  assert(type(bufnr) == "number", "bufnr should be a number")
  return vim.api.nvim_buf_is_loaded(bufnr)
end

---Create a new buffer
---@param opts table?
---@return number
M.create = function(opts)
  assert(not opts or type(opts) == "table", "options should be a table")
  opts = opts or {}
  opts.listed = opts.listed or true
  opts.scratch = opts.scratch or false

  return vim.api.nvim_create_buf(opts.listed, opts.scratch)
end

---Give a name to a buffer
---@param bufnr number
---@param name string
M.set_name = function(bufnr, name)
  -- Note: setting buffer name will give it full path to project root
  assert(M.exist(bufnr), "given buffer does not exist")
  return vim.api.nvim_buf_set_name(bufnr, name)
end

---Give a name to a buffer
---@param bufnr number
---@return string
M.get_name = function(bufnr)
  -- Note: Getting buffer name returns full path (wether it exists or not)
  assert(M.exist(bufnr), "given buffer does not exist")
  return vim.api.nvim_buf_get_name(bufnr)
end

---Append lines to an existing buffer
---@param bufnr number
---@param text any
---@return nil
M.append_text = function(bufnr, text)
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
M.clear_text = function(bufnr)
  assert(M.exist(bufnr), "Buffer to clear must exist")
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "" })
end

---Close (but not delete) given buffer
---@param bufnr number
M.close = function(bufnr)
  assert(M.exist(bufnr), "buffer to close must exist")
  vim.api.nvim_buf_delete(bufnr, { unload = true })
end

---Delete given buffer
---@param bufnr number
---@param force boolean?
M.delete = function(bufnr, force)
  assert(M.exist(bufnr), "buffer to delete must exist")
  vim.api.nvim_buf_delete(bufnr, { unload = false, force = force or false })
end


---Get selected text from current buffer
---@return string
---TODO: Find a simpler way to do this.
M.get_selected_text = function()
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

---Reload current buffer from disc
M.reload = function()
  -- This reload method is aim to be used after, for example, an autocmd
  -- that runs a formatter. Instead of trigger a focus event, try to force it
  if vim.api.nvim_get_option_value("autoread", {}) then
    vim.cmd("checktime")
  else
    vim.cmd("e " .. M.get_path())
  end
end

---Get a list of all, loaded and opened buffers
---@return table
M.get_list = function()
  local all_buffers = vim.api.nvim_list_bufs()
  local loaded_buffers = {}
  local opened_buffers = {}

  for _, bufnr in ipairs(all_buffers) do
    if M.is_loaded(bufnr) then
      table.insert(loaded_buffers, bufnr)
    end
    if M.is_open(bufnr) then
      table.insert(opened_buffers, bufnr)
    end
  end

  return {
    all = all_buffers,
    loaded = loaded_buffers,
    open = opened_buffers,
  }
end

---Get the window number that contain the buffer
---   If the buffer is not on any window it will return -1
---   If the buffer does not exist it will error out
---@param bufnr number
---@return number
M.get_win_id = function (bufnr)
  assert(M.exist(bufnr), "given buffer does not exist")
  local win_list = vim.fn.win_findbuf(bufnr)
  if #win_list == 0 then
    return -1
  else
    return win_list[#win_list]
  end
end

return M
