local api = vim.api

-- Global mapping table
_G.Mappings = {
{
    mode = '',
    lhs = '',
    description = '',
  }
}

function _G.Mappings.map(mode, lhs, rhs, opts, desc, bufnr)
  opts      = opts or {}
  bufnr     = bufnr or 0

  if desc == '' or desc == nil then desc = rhs end

  if bufnr == 0 then
    api.nvim_set_keymap(mode, lhs, rhs, opts)
  else
    api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
  end

  _G.Mappings.add(mode, lhs, desc)
end

function _G.Mappings.add(mode, lhs, desc)
  table.insert(_G.Mappings, {
    mode        = mode,
    lhs         = lhs,
    description = desc})
end

function _G.Mappings.view()
  local function create_popup_window_opts()
    local win_height = vim.o.lines - vim.o.cmdheight - 2 -- Add margin for status and buffer line
    local win_width = vim.o.columns
    local popup_layout = {
      relative = "editor",
      height = math.floor(win_height * 0.9),
      width = math.floor(win_width * 0.8),
      style = "minimal",
      border = "rounded",
    }
    popup_layout.row = math.floor((win_height - popup_layout.height) / 2)
    popup_layout.col = math.floor((win_width - popup_layout.width) / 2)

    return popup_layout
  end

  local buf_opts = {
    modifiable = true,
    swapfile = false,
    textwidth = 0,
    buftype = 'nofile',
    bufhidden = 'wipe',
    buflisted = false,
    filetype = 'Mappings',
  }

  local win_opts = {
    number = false,
    relativenumber = false,
    wrap = false,
    spell = false,
    foldenable = false,
    signcolumn = 'no',
    colorcolumn = '',
    cursorline = true,
  }

  local bufnr = api.nvim_create_buf(false, true)
  local win_id = api.nvim_open_win(bufnr, true, create_popup_window_opts())

  -- window options
  for key, value in pairs(win_opts) do
    api.nvim_win_set_option(win_id, key, value)
  end

  -- buffer options
  for key, value in pairs(buf_opts) do
    api.nvim_buf_set_option(bufnr, key, value)
  end

  api.nvim_buf_set_keymap(bufnr, 'n', 'q', ':close<CR>', {silent = true})
  api.nvim_buf_set_keymap(bufnr, 'n', '<ESC>', ':close<CR>', {silent = true})


  local output = {}
  for _, value in ipairs(_G.Mappings) do
    -- local out = string.format('%s  %s    %s', value.mode, value.lhs, value.description)
    local out = string.format('%s  %s', value.mode, value.lhs)
    table.insert(output, out)
    out = string.format('   %s', value.description)
    table.insert(output, out)
  end

  local win_height = vim.o.lines - vim.o.cmdheight - 2 -- Add margin for status and buffer line
  api.nvim_buf_set_lines(bufnr, 0, win_height, false, output)
end
