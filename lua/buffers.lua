local Buff = {}

local EXPAND_PARAM = {
  CURR_BUF_PATH = "%",
  AUTOCMD_PATH = "<afile>",
}

---Get buffers path
---@param absolute boolean?
Buff.get_path = function (absolute)
  local addon = ""
  if absolute then
    addon = ":p"
  end
  local path = vim.fn.expand(EXPAND_PARAM.AUTOCMD_PATH .. addon)
  if not path then
    path = vim.fn.expand(EXPAND_PARAM.CURR_BUF_PATH .. addon)
  end
  return path
end

---Check if a buffer exist
---    The buffer can exist without being open
---@param bufnr number
---@return boolean
Buff.exist = function (bufnr)
  return vim.fn.buffer_exists(bufnr) == 1
end

---Check if the buffer exist AND is open
---@param bufnr number
---@return boolean
Buff.is_open = function (bufnr)
  assert(type(bufnr) == "number", "number expected but " .. bufnr .. " given")
  return Buff.exist(bufnr) and vim.bo[bufnr].buflisted 
end

Buff.append_text = function (bufnr, text)
  -- Code here
end

return Buff


-- -- Work with this
-- local BFF = {}
--
--
-- -- Append text to the given buffer
-- -- @param number buffer number
-- -- @param string | table text
-- BFF.append_text_to_buffer = function(buffnr, text)
--   if not text then
--     return nil
--   elseif type(text) ~= "table" then
--     text = { tostring(text) }
--   end
--   return vim.api.nvim_buf_set_lines(buffnr, -1, -1, false, text)
-- end
--
-- -- Clean all the lines from a given buffer
-- -- @param number bufnr buffer id to clean
-- BFF.clear_buffer = function(bufnr)
--   return vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "" })
-- end
--
-- -- Get the current buffer number
-- -- @return number buffer number
-- BFF.get_current_bufnr = function()
--   vim.api.nvim_get_current_buf()
-- end
--
-- -- Check if the buffer exists or not
-- -- @return boolean wether buf exist or not
-- BFF.buffer_exists = function(bufnr)
--   return vim.fn.buffer_exists(bufnr) == 1
-- end
--
-- -- Create a new empty bufffer
-- -- @param is_listed boolean - Weather or not the bew buffer is listed
-- -- @param is_scratch boolean - When true, it will not ask to save when modified
-- -- @param name string - New buffer name
-- -- @return number bufnr
-- BFF.create_buffer = function(is_listed, is_scratch, name)
--   local bufnr = vim.api.nvim_create_buf(is_listed or true, is_scratch or false)
--   if name then
--     vim.api.nvim_buf_set_name(bufnr, name)
--   end
--   return bufnr
-- end
--
-- -- Get selected text from current buffer
-- -- @return string selected text
-- -- TODO: Find a simpler way to do this.
-- BFF.get_buf_selected_text = function()
--   local _, start_row, start_col = unpack(vim.fn.getcurpos())
--   local end_row = tonumber(vim.fn.line "v")
--   local end_col = tonumber(vim.fn.col "v")
--
--   if start_row == end_row and start_col > end_col then
--     start_col, end_col = end_col, start_col
--   end
--   if start_row > end_row then
--     start_row, end_row = end_row, start_row
--     start_col, end_col = end_col, start_col
--   end
--
--   local text = vim.api.nvim_buf_get_text(
--     0,
--     tonumber(start_row) - 1,
--     tonumber(start_col) - 1,
--     tonumber(end_row) - 1,
--     tonumber(end_col),
--     {}
--   )
--
--   return vim.fn.join(text, " ")
-- end
--
-- return BFF
--
