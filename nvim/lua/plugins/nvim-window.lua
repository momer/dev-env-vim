-- nvim-window: quick window picker with visual labels
local ok, nvim_window = pcall(require, 'nvim-window')
if not ok then return end

nvim_window.setup({
  -- Characters used for window labels (first char = first window, etc.)
  chars = { 'a', 's', 'd', 'f', 'j', 'k', 'l', ';' },

  -- Style of the floating label
  normal_hl = 'Normal',
  hint_hl = 'Bold',
  border = 'single',
})

-- Flash current window to identify it
local M = {}

function M.flash_current_window()
  local win = vim.api.nvim_get_current_win()
  local original_hl = vim.wo[win].winhighlight
  local count = 0
  local max_flashes = 3

  local function flash()
    if count >= max_flashes * 2 then
      vim.wo[win].winhighlight = original_hl
      return
    end

    if count % 2 == 0 then
      vim.wo[win].winhighlight = 'Normal:Visual,NormalNC:Visual'
    else
      vim.wo[win].winhighlight = original_hl
    end

    count = count + 1
    vim.defer_fn(flash, 120)
  end

  flash()
end

_G.nvim_window_utils = M

-- Keymaps registered in which-key.lua: <Leader>vww (pick), <Leader>vwf (flash)
