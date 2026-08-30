local M = {}

local formatters = require("document_format.formatters")
local prettier = require("document_format.prettier")
local shfmt = require("document_format.shfmt")
local dockerfmt = require("document_format.dockerfmt")
local taplo = require("document_format.taplo")

local function notify(message, level)
  vim.notify(message, level, { title = "FormatDocument" })
end

function M.format(opts)
  local formatter = formatters[vim.bo.filetype]
  if not formatter then
    notify("No formatter is configured for " .. (vim.bo.filetype == "" and "this buffer" or vim.bo.filetype) .. ".", vim.log.levels.WARN)
    return
  end
  if opts.range ~= 0 and formatter.supports_range == false then
    notify("Range formatting is not supported for " .. vim.bo.filetype .. ". Format the whole buffer instead.", vim.log.levels.WARN)
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local first_line = opts.range == 0 and 1 or opts.line1
  local last_line = opts.range == 0 and vim.api.nvim_buf_line_count(buf) or opts.line2
  local changedtick = vim.api.nvim_buf_get_changedtick(buf)
  local original_lines = vim.api.nvim_buf_get_lines(buf, first_line - 1, last_line, false)

  local function apply(command)
    if not command then
      return
    end
    vim.system(command, { stdin = table.concat(original_lines, "\n"), text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        local error_message = vim.trim(result.stderr ~= "" and result.stderr or result.stdout)
        notify(formatter.name .. " failed" .. (error_message ~= "" and ": " .. error_message or "."), vim.log.levels.ERROR)
        return
      end
      if not vim.api.nvim_buf_is_valid(buf) then
        return
      end
      if vim.api.nvim_buf_get_changedtick(buf) ~= changedtick then
        notify("Buffer changed while Prettier was running. Formatted output was not applied.", vim.log.levels.WARN)
        return
      end

      local lines = vim.split(result.stdout, "\n", { plain = true })
      if lines[#lines] == "" then
        table.remove(lines)
      end
      if vim.deep_equal(original_lines, lines) then
        notify("Already formatted with " .. formatter.name .. ".", vim.log.levels.INFO)
        return
      end
      vim.api.nvim_buf_set_lines(buf, first_line - 1, last_line, false, lines)
      local scope = opts.range == 0 and "current buffer" or ("lines %d-%d"):format(first_line, last_line)
      notify("Formatted " .. scope .. " with " .. formatter.name .. ".", vim.log.levels.INFO)
    end)
    end)
  end

  if formatter.adapter == "shfmt" then
    shfmt.command(formatter.language, notify, apply)
  elseif formatter.adapter == "taplo" then
    taplo.command(notify, apply)
  elseif formatter.adapter == "dockerfmt" then
    dockerfmt.command(notify, apply)
  else
    local command = prettier.command(notify)
    if not command then
      return
    end
    vim.list_extend(command, { "--parser", formatter.parser })
    vim.list_extend(command, formatter.args or {})
    apply(command)
  end
end

function M.setup()
  vim.api.nvim_create_user_command("FormatDocument", M.format, {
    desc = "Format buffer or range based on filetype",
    force = true,
    range = true,
  })
end

return M
