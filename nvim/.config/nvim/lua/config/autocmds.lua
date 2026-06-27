-- Tắt Kitty Keyboard Protocol (CSI u) để tránh lỗi double Enter / Backspace trong Kitty terminal
vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    io.stdout:write("\027[<u")
  end,
})
