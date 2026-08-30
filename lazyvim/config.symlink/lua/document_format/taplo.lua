local M = {}

local install_target = "taplo-cli"

local function executable()
  local taplo = vim.fn.exepath("taplo")
  if taplo ~= "" then
    return taplo
  end

  local cargo = vim.fn.exepath("cargo")
  if cargo == "" then
    return nil, "Taplo is unavailable and Rust with Cargo is required to install it."
  end

  local cargo_home = vim.env.CARGO_HOME or (vim.env.HOME .. "/.cargo")
  local installed = cargo_home .. "/bin/taplo"
  if vim.uv.fs_stat(installed) then
    return installed
  end
  return nil, nil, cargo
end

function M.command(notify, done)
  local taplo, error_message, cargo = executable()
  if taplo then
    done({ taplo, "fmt", "-" })
    return
  end
  if error_message then
    notify(error_message, vim.log.levels.ERROR)
    done(nil)
    return
  end

  notify("Installing taplo-cli with Cargo...", vim.log.levels.INFO)
  vim.system({ cargo, "install", install_target }, { text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        local message = vim.trim(result.stderr ~= "" and result.stderr or result.stdout)
        notify("Failed to install taplo-cli" .. (message ~= "" and ": " .. message or "."), vim.log.levels.ERROR)
        done(nil)
        return
      end
      local installed = executable()
      if not installed then
        notify("taplo-cli was installed but Taplo could not be located.", vim.log.levels.ERROR)
        done(nil)
        return
      end
      done({ installed, "fmt", "-" })
    end)
  end)
end

return M
