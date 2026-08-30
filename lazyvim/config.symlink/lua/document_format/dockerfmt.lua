local M = {}

function M.command(notify, done)
  local dockerfmt = vim.fn.exepath("dockerfmt")
  if dockerfmt == "" then
    notify("dockerfmt is required for Dockerfiles. Install github.com/reteps/dockerfmt to enable it.", vim.log.levels.ERROR)
    done(nil)
    return
  end
  done({ dockerfmt })
end

return M
