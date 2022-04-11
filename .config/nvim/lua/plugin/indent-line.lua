local found_indent, indent = pcall(require, "indent_blankline")

if not found_indent then
  print("Couldn't find indent_blankline in indent-line.lua")
  return
end

indent.setup {
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = false,
}
