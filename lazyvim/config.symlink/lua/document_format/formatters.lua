return {
  markdown = { parser = "markdown", name = "Prettier", args = { "--prose-wrap", "always", "--print-width", "80" } },
  json = { parser = "json", name = "Prettier" },
  jsonc = { parser = "jsonc", name = "Prettier" },
  yaml = { parser = "yaml", name = "Prettier" },
  toml = { adapter = "taplo", name = "Taplo", supports_range = false },
  sh = { adapter = "shfmt", name = "shfmt", language = "posix", supports_range = false },
  bash = { adapter = "shfmt", name = "shfmt", language = "bash", supports_range = false },
  zsh = { adapter = "shfmt", name = "shfmt", language = "zsh", supports_range = false },
  dockerfile = { adapter = "dockerfmt", name = "dockerfmt", supports_range = false },
}
