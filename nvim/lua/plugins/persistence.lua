local ok, persistence = pcall(require, 'persistence')
if not ok then return end

persistence.setup({
  dir = vim.fn.stdpath("state") .. "/sessions/",
  need = 1,  -- minimum number of buffers to save
  branch = true,  -- use separate session per git branch
})

-- Auto-load session on startup (if exists and no files were passed)
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("persistence_autoload", { clear = true }),
  callback = function()
    if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
      require("persistence").load()
    end
  end,
  nested = true,
})
