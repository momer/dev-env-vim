local ok, devicons = pcall(require, 'nvim-web-devicons')
if not ok then return end

-- nf-fa-file_text (U+F0F6) - guaranteed to be in all Nerd Fonts
local readme_icon = '\u{f0f6}'

devicons.setup({
  -- Override icons that may be missing from some Nerd Font variants
  -- (e.g., Hack Nerd Font Mono doesn't have the DevIconReadme glyph)
  override_by_filename = {
    ['readme.md'] = {
      icon = readme_icon,
      color = '#519aba',
      name = 'Readme',
    },
    ['README.md'] = {
      icon = readme_icon,
      color = '#519aba',
      name = 'Readme',
    },
    ['README'] = {
      icon = readme_icon,
      color = '#519aba',
      name = 'Readme',
    },
  },
  default = true,
})
