-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("user_checktime", { clear = true }),
  callback = function()
    if vim.bo.buftype == "" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("user_nowrap", { clear = true }),
  callback = function()
    if vim.bo.filetype == "markdown" then
      vim.opt_local.conceallevel = 0
    end
    if vim.tbl_contains({ "text", "plaintex", "typst", "gitcommit", "markdown" }, vim.bo.filetype) then
      vim.opt_local.wrap = false
    end
  end,
})
