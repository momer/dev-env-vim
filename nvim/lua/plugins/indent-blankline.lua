local ok, ibl = pcall(require, 'ibl')
if not ok then return end

ibl.setup({
  indent = {
    char = '│',
  },
  scope = {
    enabled = true,
    show_start = false,
    show_end = false,
  },
})
