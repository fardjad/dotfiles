return { -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity", -- example of imporing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity

  {
    import = "astrocommunity.completion.copilot-lua-cmp",
  },
  {
    import = "astrocommunity.pack.typescript-all-in-one",
  },
  {
    import = "astrocommunity.pack.json",
  },
  {
    import = "astrocommunity.pack.bash",
  },
  {
    import = "astrocommunity.pack.lua",
  },
  {
    import = "astrocommunity.pack.markdown",
  },
  {
    import = "astrocommunity.pack.python",
  },
  {
    import = "astrocommunity.pack.toml",
  },
  { import = "astrocommunity.pack.yaml" },
}
