-- TODOS :
-- - [ ] Make custom function to generate different sections
-- - [ ] Make logique to navigate between sections
-- ...

local api = vim.api
local buf, win
local resumerBuffer, resumerWin
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



  local opts = {
    -- style = "minimal",
    relative = "editor",
    width = win_width ,
    height = math.ceil(win_height),
    row = row,
    col = col,
    border = 'single'
  }

  local border_opts = {
    style = "minimal",
    relative = "editor",
    width = win_width + 2,
    height = win_height + 2,
    col = (vim.o.columns - width) / 2,
  }


  -- local currentBorder = border.simpleBorder
  -- local border_lines = {}
  -- local top_border =  currentBorder[border.CORNER_LEFT_TOP] .. string.rep(currentBorder[border.SIDE_BOTTOM], win_width) .. currentBorder[border.CORNER_RIGHT_TOP] 
  -- local bottom_border =  currentBorder[border.CORNER_LEFT_BOTTOM] .. string.rep(currentBorder[border.SIDE_BOTTOM], win_width) .. currentBorder[border.CORNER_RIGHT_BOTTOM] 
  -- local middle_line =  currentBorder[border.SIDE] .. string.rep(' ', win_width) .. currentBorder[border.SIDE] 

  -- table.insert(border_lines, top_border)

  -- for i=1, win_height do
  --   table.insert(border_lines, middle_line)
  -- end

  -- table.insert(border_lines, bottom_border)
  -- api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)

  -- local border_win = api.nvim_open_win(border_buf, true, border_opts)

  win = api.nvim_open_win(buf, true, opts)
  api.nvim_command('au BufWipeout <buffer> exe "silent bwipeout! "'..border_buf)

  api.nvim_win_set_option(win, 'cursorline', true)

  api.nvim_buf_set_lines(buf, 0, -1, false, { windowHelper.center('What have i done?'), '', ''})
  api.nvim_buf_add_highlight(buf, -1, 'WhidHeader', 0, 0, -1)
end

local function update_view(direction)
  api.nvim_buf_set_option(buf, 'modifiable', true)

  -- todo get the files unstaged
  local unstagedFile = api.nvim_call_function('systemlist', {
      'git diff --name-status'
    })

  local result = {}

  -- if #unstagedFile == 0 then table.insert(unstagedFile, '') end
  for k,v in pairs(unstagedFile) do
    table.insert(result, unstagedFile[k])
  end

  local stagedFile = api.nvim_call_function('systemlist', {
      'git diff --name-status --cached'
    })

  table.insert(result, "--- Staged")

  -- if #stagedFile == 0 then table.insert(stagedFile, '') end
  for k,v in pairs(stagedFile) do
    table.insert(result, stagedFile[k])
  end

  local completStatus = api.nvim_call_function('systemlist', {
      'git status'
    })

  table.insert(result, "--- Complet status")

  -- if #stagedFile == 0 then table.insert(stagedFile, '') end
  for k,v in pairs(completStatus) do
    table.insert(result, completStatus[k])
  end

  api.nvim_buf_set_lines(buf, 1, 2, false, {"todo voir quoi mettre ici"})

  api.nvim_buf_set_lines(buf, 2, 3, false, {"--- Unstaged"})
  api.nvim_buf_set_lines(buf, 3, -1, false, result)

  api.nvim_buf_add_highlight(buf, -1, 'whidSubHeader', 1, 0, -1)
  api.nvim_buf_set_option(buf, 'modifiable', false)
end

local function close_window()
  api.nvim_win_close(win, true)
end

local function open_file()
  local str = api.nvim_get_current_line()
  local path = str:match("%s*(%S+)$")
  close_window()
  api.nvim_command('edit '..path)
end

local function stage_file()
  local str = api.nvim_get_current_line()
  local path = str:match("%s*(%S+)$")
  -- close_window()
  local command = "git add " .. path
  vim.fn.system(command)
  update_view(0)
end

local function unstage_file()
  local str = api.nvim_get_current_line()
  local path = str:match("%s*(%S+)$")
  -- close_window()
  local command = "git restore --staged " .. path
  vim.fn.system(command)
  update_view(0)
end

local function discard_file()
  local str = api.nvim_get_current_line()
  local path = str:match("%s*(%S+)$")
  -- close_window()
  local command = "git restore " .. path
  vim.fn.system(command)
  update_view(0)
end

local function commit()
  local buf = api.nvim_create_buf(false, true)
  
  -- Set the buffer to unmodified to avoid the E5108 error
  api.nvim_buf_set_option(buf, 'modifiable', false)

  -- Open a new window for the terminal buffer
  local opts = {
    style = "minimal",
    relative = "editor",
    width = 80,
    height = 20,
    row = 10,
    col = 10,
    border = "rounded"
  }
  local win = api.nvim_open_win(buf, true, opts)

  -- Run the git commit command in the terminal buffer
  vim.fn.termopen("git commit", {
    on_exit = function(_, exit_code, _)
      if exit_code == 0 then
        print("Commit successful")
      else
        print("Commit failed")
      end
      -- Close the window and buffer
      api.nvim_win_close(win, true)
      api.nvim_buf_delete(buf, { force = true })
    end
  })
  update_view(0)
end

-- local function move_cursor()
--   local new_pos = math.max(4, api.nvim_win_get_cursor(win)[1] - 1)
--   api.nvim_win_set_cursor(win, {new_pos, 0})
-- end

local function set_mappings()
  local mappings = {
    ['<cr>'] = 'open_file()',
    q = 'close_window()',
    s = 'stage_file()',
    u = 'unstage_file()',
    d = 'discard_file()',
    c = 'commit()',
  }

  for k,v in pairs(mappings) do
    api.nvim_buf_set_keymap(buf, 'n', k, ':lua require"test.window".'..v..'<cr>', {
        nowait = true, noremap = true, silent = true
      })
  end

  -- Disable key while using the plugin
  local other_chars = {
    'a', 'b', 'e', 'f', 'g', 'i', 'n', 'o', 'p', 'r', 't', 'v', 'w', 'x', 'y', 'z'
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
  stage_file = stage_file,
  unstage_file = unstage_file,
  discard_file = discard_file,
  commit = commit,
  move_cursor = move_cursor,
  close_window = close_window
}
