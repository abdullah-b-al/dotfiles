local api = vim.api

-- Global mapping table
_G.Mappings = {}
local spr_max_length = 0
local mode_spr_max_length = 0

function Mappings.map(mode, lhs, rhs, opts, desc)
  opts      = opts or {}

  vim.keymap.set(mode, lhs, rhs, opts)

  if desc == '' or desc == nil then
    desc = ''
  end

  if not next(mode) or mode == '' then
    mode = {' '}
  end

  Mappings.add(mode, lhs, desc)
end

function Mappings.add(mode, lhs, desc)

  local lhs_length = string.len(lhs)
  local mode_length = #mode

  if lhs_length >= spr_max_length then
    spr_max_length = lhs_length
  end
  if mode_length >= mode_spr_max_length then
    mode_spr_max_length = mode_length
  end

  local mode_string = ''
  for _, v in ipairs(mode) do
    mode_string = mode_string .. v
  end

  local mapping_info = { mode = mode_string, lhs = lhs, description = desc }
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

  for _, v in ipairs(Mappings) do
    local len = spr_max_length - string.len(v.lhs) + 1
    local mode_len = mode_spr_max_length - (#v.mode) + 1

    local lhs_desc_spr = string.rep(' ', len)
    local mode_lhs_spr = string.rep(' ', mode_len)

    local out = string.format('%s' .. mode_lhs_spr .. '%s' .. lhs_desc_spr .. '%s',
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
