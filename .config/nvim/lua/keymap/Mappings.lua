local api = vim.api

-- Global mapping table
_G.Mappings = {}
local spr_max_length = 0

function Mappings.map(mode, lhs, rhs, opts, desc, bufnr)
  opts      = opts or {}
  bufnr     = bufnr or 0

  if bufnr == 0 then
    api.nvim_set_keymap(mode, lhs, rhs, opts)
  else
    api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
  end

  if desc == '' or desc == nil then
    desc = rhs
  end

  if mode == '' then
    mode = ' '
  end

  Mappings.add(mode, lhs, desc)
end

function Mappings.add(mode, lhs, desc)

  local lhs_length = string.len(lhs)

  if lhs_length >= spr_max_length then
    spr_max_length = lhs_length
  end

  local mapping_info = { mode = mode, lhs = lhs, description = desc}
  table.insert(Mappings, mapping_info)
end

function Mappings.view(opts)

  local found_telescope = pcall(require, "telescope")
  if not found_telescope then
    print("Couldn't find telescope in Mappings.lua")
    return
  end

  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local conf    = require("telescope.config").values

  local output = {}
  local map_lhs_spr = string.rep(' ', 2)
  local lhs_desc_spr

  for _, v in ipairs(Mappings) do
    local len = spr_max_length - string.len(v.lhs) + 1
    lhs_desc_spr = string.rep(' ', len)

    local out = string.format('%s' .. map_lhs_spr .. '%s' .. lhs_desc_spr .. '%s',
      v.mode, v.lhs, v.description)
    table.insert(output, out)
  end

  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Mappings",
    finder = finders.new_table {
      results = output
    },
    sorter = conf.generic_sorter(opts),
  }):find()
end
