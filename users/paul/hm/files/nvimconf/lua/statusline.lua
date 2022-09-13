local function keymap()
  if vim.o.iminsert == 0 then
    return 'us'
  else
    return vim.b.keymap_name
  end
end

require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'onedark',
    component_separators = { '', '' },
    section_separators = { '', '' },
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = { 'mode', keymap, 'diff' },
    lualine_b = { 'branch' },
    lualine_c = { { 'filename', file_status = true } },
    lualine_x = { 'encoding', 'fileformat', { 'filetype', colored = true } },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = { 'quickfix', 'fugitive', 'nvim-tree' }
}
