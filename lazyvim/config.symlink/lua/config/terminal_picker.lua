local M = {}

function M.pick()
  Snacks.picker.pick({
    title = "Terminals",
    finder = function()
      local items = {}
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "snacks_terminal" then
          local details = vim.b[buf].snacks_terminal or {}
          items[#items + 1] = {
            buf = buf,
            file = ("Terminal %s: %s"):format(details.id or "?", vim.b[buf].term_title or vim.o.shell),
            text = ("terminal %s %s"):format(details.id or "", vim.b[buf].term_title or vim.o.shell),
            flags = "",
            name = "",
            buftype = vim.bo[buf].buftype,
            filetype = vim.bo[buf].filetype,
          }
        end
      end
      return items
    end,
    format = "buffer",
  })
end

return M
