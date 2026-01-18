local ok, wk = pcall(require, 'which-key')
if not ok then return end

wk.setup({
  plugins = {
    marks = true,
    registers = true,
    spelling = { enabled = false },
  },
  win = {
    border = "rounded",
    padding = { 2, 2, 2, 2 },
  },
})

wk.add({
  -- Top-level (quick access)
  { "<leader>w", desc = "Save file" },
  { "<leader>q", desc = "Quit" },
  { "<leader><space>", desc = "Clear search highlight" },
  { "<leader>n", desc = "Next buffer" },
  { "<leader>p", desc = "Previous buffer" },
  { "<leader>bd", desc = "Delete buffer" },

  -- Explorer (nvim-tree)
  { "<leader>e", group = "Explorer" },
  { "<leader>ee", desc = "Toggle file tree" },
  { "<leader>E", desc = "Toggle file tree" },
  { "<leader>ef", desc = "Find current file in tree" },

  -- Find (FZF)
  { "<leader>f", group = "Find" },
  { "<leader>ff", desc = "Find files" },
  { "<leader>fg", desc = "Grep (ripgrep)" },
  { "<leader>fb", desc = "List buffers" },
  { "<leader>fl", desc = "Search lines" },
  { "<leader>fh", desc = "File history" },
  { "<leader>fc", desc = "Commands" },
  { "<leader>fw", desc = "Grep word under cursor" },
  { "<leader>f:", desc = "Command history" },
  { "<leader>f?", desc = "Search history" },

  -- Git
  { "<leader>g", group = "Git" },
  { "<leader>gf", desc = "Git files" },
  { "<leader>gs", desc = "Git status files" },
  { "<leader>gp", desc = "Preview hunk" },
  { "<leader>gb", desc = "Blame line" },

  -- Code (LSP)
  { "<leader>c", group = "Code" },
  { "<leader>cd", desc = "Go to definition" },
  { "<leader>ct", desc = "Go to type definition" },
  { "<leader>ci", desc = "Go to implementation" },
  { "<leader>cr", desc = "Find references" },
  { "<leader>cn", desc = "Rename symbol" },
  { "<leader>ca", desc = "Code actions" },
  { "<leader>cq", desc = "Quick fix" },
  { "<leader>cf", desc = "Format code" },
  { "<leader>cx", desc = "Refactor" },
  { "<leader>cl", desc = "Code lens action" },
  { "<leader>co", desc = "Show outline" },
  { "<leader>cs", desc = "Search symbols" },

  -- Lint/Diagnostics
  { "<leader>l", group = "Lint" },
  { "<leader>ld", desc = "Show error detail (CoC)" },
  { "<leader>lD", desc = "Show error detail (ALE)" },
  { "<leader>ll", desc = "List diagnostics (CoC)" },
  { "<leader>lL", desc = "List diagnostics (ALE)" },
  { "<leader>lt", desc = "Toggle inline errors" },
  { "<leader>ln", desc = "Next diagnostic" },
  { "<leader>lp", desc = "Previous diagnostic" },
  { "<leader>lf", desc = "Quick fix" },
  { "<leader>la", desc = "Code actions" },

  -- Markdown
  { "<leader>m", group = "Markdown" },
  { "<leader>mp", desc = "Markdown preview" },

  -- Terminal
  { "<leader>t", group = "Terminal" },
  { "<leader>tt", desc = "Open terminal (horizontal)" },
  { "<leader>tv", desc = "Open terminal (vertical)" },
  -- Vim group
  { "<leader>v", group = "Vim" },
  -- Windows sub-group
  { "<leader>vw", group = "Windows" },
  { "<leader>vww", function() require('nvim-window').pick() end, desc = "Pick window" },
  { "<leader>vwf", function() _G.nvim_window_utils.flash_current_window() end, desc = "Flash current window" },
  { "<leader>vwh", "<C-w>H", desc = "Move window to far left" },
  { "<leader>vwj", "<C-w>J", desc = "Move window to bottom" },
  { "<leader>vwk", "<C-w>K", desc = "Move window to top" },
  { "<leader>vwl", "<C-w>L", desc = "Move window to far right" },
  { "<leader>vwr", "<C-w>r", desc = "Rotate windows down/right" },
  { "<leader>vwR", "<C-w>R", desc = "Rotate windows up/left" },
  { "<leader>vwx", "<C-w>x", desc = "Exchange with next window" },
  { "<leader>vwt", "<C-w>T", desc = "Move window to new tab" },
  { "<leader>vw=", "<C-w>=", desc = "Equal size all windows" },
  { "<leader>vw+", "<C-w>+", desc = "Increase height" },
  { "<leader>vw-", "<C-w>-", desc = "Decrease height" },
  { "<leader>vw>", "<C-w>>", desc = "Increase width" },
  { "<leader>vw<", "<C-w><", desc = "Decrease width" },
  { "<leader>vw_", "<C-w>_", desc = "Maximize height" },
  { "<leader>vw|", "<C-w>|", desc = "Maximize width" },
  -- Session sub-group (persistence.nvim)
  { "<leader>vs", group = "Session" },
  { "<leader>vss", function() require("persistence").load() end, desc = "Restore session (cwd)" },
  { "<leader>vsl", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
  { "<leader>vsd", function() require("persistence").stop() end, desc = "Stop saving session" },
})
