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
  { "<leader>w", desc = "Save file" },
  { "<leader>q", desc = "Quit" },
  { "<leader><space>", desc = "Clear search highlight" },
  { "<leader>e", desc = "File explorer" },
  { "<leader>n", desc = "Next buffer" },
  { "<leader>p", desc = "Previous buffer" },
  { "<leader>bd", desc = "Delete buffer" },
  -- fzf
  { "<leader>f", desc = "Find files" },
  { "<leader>/", desc = "Grep (ripgrep)" },
  { "<leader>b", desc = "List buffers" },
  { "<leader>l", desc = "Search lines" },
  { "<leader>h", desc = "File history" },
  { "<leader>c", desc = "Commands" },
  { "<leader>*", desc = "Grep word under cursor" },
  { "<leader>:", desc = "Command history" },
  { "<leader>?", desc = "Search history" },
  -- git (fzf)
  { "<leader>gf", desc = "Git files" },
  { "<leader>gs", desc = "Git status files" },
  -- coc.nvim
  { "<leader>gd", desc = "Go to definition" },
  { "<leader>gt", desc = "Go to type definition" },
  { "<leader>gi", desc = "Go to implementation" },
  { "<leader>gr", desc = "Find references" },
  { "<leader>rn", desc = "Rename symbol" },
  { "<leader>ca", desc = "Code actions" },
  { "<leader>qf", desc = "Quick fix" },
  { "<leader>cf", desc = "Format code" },
  { "<leader>re", desc = "Refactor" },
  { "<leader>cl", desc = "Code lens action" },
  { "<leader>co", desc = "Show outline" },
  { "<leader>cs", desc = "Search symbols" },
  -- Lint/Diagnostics
  { "<leader>L", group = "Lint" },
  { "<leader>Ld", desc = "Show error detail (CoC)" },
  { "<leader>LD", desc = "Show error detail (ALE)" },
  { "<leader>Ll", desc = "List diagnostics (CoC)" },
  { "<leader>LL", desc = "List diagnostics (ALE)" },
  { "<leader>Lt", desc = "Toggle inline errors" },
  { "<leader>Ln", desc = "Next diagnostic" },
  { "<leader>Lp", desc = "Previous diagnostic" },
  { "<leader>Lf", desc = "Quick fix" },
  { "<leader>La", desc = "Code actions" },
  -- gitsigns
  { "<leader>hp", desc = "Preview hunk" },
  { "<leader>hb", desc = "Blame line" },
  -- nvim-tree
  { "<leader>E", desc = "Toggle file tree" },
  -- markdown
  { "<leader>mp", desc = "Markdown preview" },
  -- terminal
  { "<leader>t", group = "Terminal" },
  { "<leader>tt", desc = "Open terminal (horizontal)" },
  { "<leader>tv", desc = "Open terminal (vertical)" },
  -- window relocation (built-in)
  { "<C-w>H", desc = "Move window to far left" },
  { "<C-w>J", desc = "Move window to bottom" },
  { "<C-w>K", desc = "Move window to top" },
  { "<C-w>L", desc = "Move window to far right" },
  { "<C-w>r", desc = "Rotate windows down/right" },
  { "<C-w>R", desc = "Rotate windows up/left" },
  { "<C-w>x", desc = "Exchange with next window" },
  { "<C-w>T", desc = "Move window to new tab" },
  -- session (persistence.nvim)
  { "<leader>S", group = "Session" },
  { "<leader>Ss", function() require("persistence").load() end, desc = "Restore session (cwd)" },
  { "<leader>Sl", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
  { "<leader>Sd", function() require("persistence").stop() end, desc = "Stop saving session" },
  -- window resize (built-in)
  { "<C-w>+", desc = "Increase height" },
  { "<C-w>-", desc = "Decrease height" },
  { "<C-w>>", desc = "Increase width" },
  { "<C-w><", desc = "Decrease width" },
  { "<C-w>=", desc = "Equal size all windows" },
  { "<C-w>_", desc = "Maximize height" },
  { "<C-w>|", desc = "Maximize width" },
})
