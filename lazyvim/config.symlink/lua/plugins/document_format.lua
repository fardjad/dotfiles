return {
  {
    dir = vim.fn.stdpath("config"),
    name = "document-format",
    cmd = "FormatDocument",
    config = function()
      require("document_format").setup()
    end,
  },
}
