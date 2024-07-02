-- TODOS :
-- - [ ] Make custom function to generate different sections
-- - [ ] Make logique to navigate between sections
-- ...

local api = vim.api
local buf, win
local position = 0

local border = require("test.border")
local windowHelper = require("test.windowHelper")


local function open_window()
  buf = api.nvim_create_buf(false, true)
  local border_buf = api.nvim_create_buf(false, true)

  api.nvim_set_option_value('bufhidden', 'wipe', {buf = buf})
  api.nvim_set_option_value('filetype', 'whid', {buf = buf})

  local width = api.nvim_win_get_width(0)
  local height = api.nvim_win_get_height(0)

  local win_height = math.ceil(height * 0.8 - 4)
  local win_width = math.ceil(width * 0.8)
  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  local split = true


  local opts = {
    -- style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    -- title = "TESTTING test",
    -- footer = "TESTTING test"
  }

  if split == true then
    opts.width = math.ceil(opts.width / 2)
    opts.height = math.ceil(opts.height / 2)
  end

  local border_opts = {
    style = "minimal",
    relative = "editor",
    width = win_width + 2,
    height = win_height + 2,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
  }


  local currentBorder = border.simpleBorder
  local border_lines = {}
  local top_border =  currentBorder[border.CORNER_LEFT_TOP] .. string.rep(currentBorder[border.SIDE_BOTTOM], win_width) .. currentBorder[border.CORNER_RIGHT_TOP] 
  local bottom_border =  currentBorder[border.CORNER_LEFT_BOTTOM] .. string.rep(currentBorder[border.SIDE_BOTTOM], win_width) .. currentBorder[border.CORNER_RIGHT_BOTTOM] 
  local middle_line =  currentBorder[border.SIDE] .. string.rep(' ', win_width) .. currentBorder[border.SIDE] 

  table.insert(border_lines, top_border)

  for i=1, win_height do
    table.insert(border_lines, middle_line)
  end

  table.insert(border_lines, bottom_border)
  api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)

  local border_win = api.nvim_open_win(border_buf, true, border_opts)

  win = api.nvim_open_win(buf, true, opts)
  win2 = api.nvim_open_win(buf, true, opts)
  api.nvim_command('au BufWipeout <buffer> exe "silent bwipeout! "'..border_buf)

  api.nvim_win_set_option(win, 'cursorline', true)

  api.nvim_buf_set_lines(buf, 0, -1, false, { windowHelper.center('What have i done?'), '', ''})
  api.nvim_buf_add_highlight(buf, -1, 'WhidHeader', 0, 0, -1)
end

local function update_view(direction)
  api.nvim_buf_set_option(buf, 'modifiable', true)
  position = position + direction
  if position < 0 then position = 0 end

  local result = api.nvim_call_function('systemlist', {
      'git diff-tree --no-commit-id --name-only -r HEAD~'..position
    })

  if #result == 0 then table.insert(result, '') end
  for k,v in pairs(result) do
    result[k] = '  '..result[k]
  end

  api.nvim_buf_set_lines(buf, 1, 2, false, {windowHelper.center('HEAD~'..position)})
  api.nvim_buf_set_lines(buf, 2, 3, false, {"testing"})

  api.nvim_buf_set_lines(buf, 4, -1, false, result)

  api.nvim_buf_add_highlight(buf, -1, 'whidSubHeader', 1, 0, -1)
  api.nvim_buf_set_option(buf, 'modifiable', false)
end

local function close_window()
  api.nvim_win_close(win, true)
end

local function open_file()
  local str = api.nvim_get_current_line()
  close_window()
  api.nvim_command('edit '..str)
end

local function move_cursor()
  local new_pos = math.max(4, api.nvim_win_get_cursor(win)[1] - 1)
  api.nvim_win_set_cursor(win, {new_pos, 0})
end

local function set_mappings()
  local mappings = {
    ['['] = 'update_view(-1)',
    [']'] = 'update_view(1)',
    ['<cr>'] = 'open_file()',
    h = 'update_view(-1)',
    l = 'update_view(1)',
    q = 'close_window()',
    -- k = 'move_cursor()'
  }

  for k,v in pairs(mappings) do
    api.nvim_buf_set_keymap(buf, 'n', k, ':lua require"test.window".'..v..'<cr>', {
        nowait = true, noremap = true, silent = true
      })
  end

  -- Disable key while using the plugin
  local other_chars = {
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'i', 'n', 'o', 'p', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
  }

  for k,v in ipairs(other_chars) do
    api.nvim_buf_set_keymap(buf, 'n', v, '', { nowait = true, noremap = true, silent = true })
    api.nvim_buf_set_keymap(buf, 'n', v:upper(), '', { nowait = true, noremap = true, silent = true })
    api.nvim_buf_set_keymap(buf, 'n',  '<c-'..v..'>', '', { nowait = true, noremap = true, silent = true })
  end

end

local function contentOption(opts, key)
  if opts[key] and opts[key] == true then
    api.nvim_buf_set_option(buf, key, false)
  end
end

local function generateContent(content, opts)
-- content is array
  api.nvim_buf_set_lines(buf, 1, 2, false, {windowHelper.center('HEAD~'..position)})
  api.nvim_buf_set_lines(buf, 2, 3, false, {"testing"})

  api.nvim_buf_set_lines(buf, 4, -1, false, result)

  api.nvim_buf_add_highlight(buf, -1, 'whidSubHeader', 1, 0, -1)
  contentOption(opts, "modifiable")

end


local function window(content, opts)
  position = 0
  open_window()
  set_mappings()
  update_view(0)
  api.nvim_win_set_cursor(win, {4, 0})
  -- generateContent(content, opts)
end

return {
  window = window,
  update_view = update_view,
  open_file = open_file,
  move_cursor = move_cursor,
  close_window = close_window
}
