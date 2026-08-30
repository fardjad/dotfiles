-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

vim.api.nvim_create_user_command("ReloadConfig", function()
  local config = vim.fn.stdpath("config") .. "/lua/config/"
  for _, file in ipairs({ "options.lua", "autocmds.lua", "keymaps.lua" }) do
    dofile(config .. file)
  end
  vim.notify("Neovim configuration reloaded", vim.log.levels.INFO)
end, { desc = "Reload user configuration", force = true })

vim.keymap.set("n", "<C-/>", function()
  Snacks.explorer()
end, { desc = "Explorer Snacks (cwd)" })

vim.keymap.set("n", "<C-`>", function()
  Snacks.terminal()
end, { desc = "Toggle Terminal" })

vim.keymap.set("n", "<leader>t", function()
  local previous_buf = vim.api.nvim_get_current_buf()
  local previous_win = vim.api.nvim_get_current_win()
  local terminal = Snacks.terminal.open(nil, {
    auto_close = false,
    win = { position = "current" },
  })

  vim.api.nvim_create_autocmd("TermClose", {
    buffer = terminal.buf,
    once = true,
    callback = function()
      if vim.api.nvim_win_is_valid(previous_win) and vim.api.nvim_win_get_buf(previous_win) == terminal.buf then
        vim.api.nvim_win_set_buf(previous_win, previous_buf)
      end
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(terminal.buf) then
          vim.api.nvim_buf_delete(terminal.buf, { force = true })
        end
      end)
    end,
  })
end, { desc = "Terminal (current window)" })

vim.keymap.set("n", "<leader>T", function()
  require("config.terminal_picker").pick()
end, { desc = "Terminals" })

local resize = {
  ["<C-M-h>"] = "vertical resize -1",
  ["<C-M-j>"] = "resize -1",
  ["<C-M-k>"] = "resize +1",
  ["<C-M-l>"] = "vertical resize +1",
}

for lhs, command in pairs(resize) do
  vim.keymap.set("n", lhs, "<cmd>" .. command .. "<cr>", { desc = "Resize Pane" })
  vim.keymap.set("t", lhs, "<C-\\><C-n><cmd>" .. command .. "<cr>i", { desc = "Resize Pane" })
end
