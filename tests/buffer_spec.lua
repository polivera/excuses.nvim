local buffer = require("excuses.buffer")

-- Test get_path
local path_rel = buffer.get_path()
assert(path_rel == "tests/buffer_spec.lua", "path is incorrect")
local path_abs = buffer.get_path(true)
assert(
  string.find(path_abs, path_rel) and string.len(path_abs) > string.len(path_rel),
  "absolute path should contain relative path but be larger than it"
)

-- Test exist, is_open, create and delete
local new_buf_nr = buffer.create({ make_scratch = true })
assert(buffer.exist(new_buf_nr), "buffer should exist")
assert(buffer.is_open(new_buf_nr), "buffer should be open")
buffer.close(new_buf_nr)
assert(buffer.exist(new_buf_nr), "buffer should exist")
assert(buffer.is_open(new_buf_nr) == false, "buffer should be closed")
buffer.delete(new_buf_nr)
assert(buffer.exist(new_buf_nr) == false, "buffer should not exist")
assert(buffer.is_open(new_buf_nr) == false, "buffer should be closed")

new_buf_nr = buffer.create({ make_scratch = true })
buffer.append_text(new_buf_nr, "This is a test to append")
buffer.append_text(new_buf_nr, { "two lines", "more" })
local buff_lines = vim.api.nvim_buf_get_lines(new_buf_nr, 1, -1, false)
assert(#buff_lines == 3, "buffer should have 3 lines")
buffer.clear_text(new_buf_nr)
buff_lines = vim.api.nvim_buf_get_lines(new_buf_nr, 1, -1, false)
assert(#buff_lines == 0, "buffer should have 1 lines")
buffer.delete(new_buf_nr)

print("Done")
