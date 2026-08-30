local M = {}

function M.command(notify)
  local bun = vim.fn.exepath("bun")
  if bun ~= "" then
    return { bun, "x", "prettier" }
  end

  if vim.fn.exepath("node") == "" then
    notify("Bun or Node.js is required to run Prettier.", vim.log.levels.ERROR)
    return nil
  end

  local npx = vim.fn.exepath("npx")
  if npx == "" then
    notify("Node.js was found, but npx is unavailable to run Prettier.", vim.log.levels.ERROR)
    return nil
  end
  return { npx, "--yes", "prettier" }
end

return M
