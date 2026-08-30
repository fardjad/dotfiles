local M = {}

local install_target = "mvdan.cc/sh/v3/cmd/shfmt@latest"

local function executable()
  local shfmt = vim.fn.exepath("shfmt")
  if shfmt ~= "" then
    return shfmt
  end

  local go = vim.fn.exepath("go")
  if go == "" then
    return nil, "shfmt is unavailable and Go is required to install it."
  end

  local gobin = vim.trim(vim.fn.system({ go, "env", "GOBIN" }))
  if gobin == "" then
    gobin = vim.trim(vim.fn.system({ go, "env", "GOPATH" })) .. "/bin"
  end
  local installed = gobin .. "/shfmt"
  if vim.uv.fs_stat(installed) then
    return installed
  end
  return nil, nil, go
end

function M.command(language, notify, done)
  local shfmt, error_message, go = executable()
  if shfmt then
    done({ shfmt, "-ln", language })
    return
  end
  if error_message then
    notify(error_message, vim.log.levels.ERROR)
    done(nil)
    return
  end

  notify("Installing shfmt with Go...", vim.log.levels.INFO)
  vim.system({ go, "install", install_target }, { text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        local message = vim.trim(result.stderr ~= "" and result.stderr or result.stdout)
        notify("Failed to install shfmt" .. (message ~= "" and ": " .. message or "."), vim.log.levels.ERROR)
        done(nil)
        return
      end
      local installed = executable()
      if not installed then
        notify("shfmt was installed but could not be located.", vim.log.levels.ERROR)
        done(nil)
        return
      end
      done({ installed, "-ln", language })
    end)
  end)
end

return M
