local ok, nvim_tree = pcall(require, 'nvim-tree')
if not ok then return end

nvim_tree.setup({
  view = {
    width = 35,
    side = 'left',
  },
  renderer = {
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },
  filters = {
    dotfiles = false,
    custom = { '.git', 'node_modules', '.cache' },
  },
  git = {
    enable = true,
    ignore = false,
  },
  actions = {
    open_file = {
      quit_on_open = true,
      resize_window = true,
    },
  },
})

vim.keymap.set('n', '<leader>E', ':NvimTreeToggle<CR>', { silent = true })
vim.keymap.set('n', '<leader>ef', ':NvimTreeFindFile<CR>', { silent = true })
