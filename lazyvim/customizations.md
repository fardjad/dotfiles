# LazyVim Configuration Specification

This document is the source of truth for the intended behavior and preferences of this LazyVim configuration.

## Current preferences

- Reload user options, autocmds, and keymaps with `:ReloadConfig`, configured in [`config.symlink/lua/config/keymaps.lua`](config.symlink/lua/config/keymaps.lua).
- Resize panes one step with Ctrl-Alt-H/J/K/L in normal and terminal modes, configured in [`config.symlink/lua/config/keymaps.lua`](config.symlink/lua/config/keymaps.lua).
- Create a fresh Snacks terminal in the current window with `,t`; when it exits, restore the prior buffer in that window without closing panes. Use `,T` to select any valid Snacks terminal buffer, including hidden ones. The picker implementation belongs in [`config.symlink/lua/config/terminal_picker.lua`](config.symlink/lua/config/terminal_picker.lua), not [`config.symlink/lua/config/keymaps.lua`](config.symlink/lua/config/keymaps.lua).
- Use lazygit for the Git workflow through `,gg`; it is declared in [`Brewfile`](Brewfile).
- Automatically reload unmodified open buffers when their files change externally, checking on focus, buffer entry, and idle cursor events. This is configured in [`config.symlink/lua/config/autocmds.lua`](config.symlink/lua/config/autocmds.lua).
- Toggle the Snacks explorer rooted at the current working directory with `Ctrl-/`, configured in [`config.symlink/lua/config/keymaps.lua`](config.symlink/lua/config/keymaps.lua).
- Toggle Snacks terminals with Ctrl-Backtick. A numeric count selects an independent terminal, such as 2 Ctrl-Backtick for terminal 2. This is configured in [`config.symlink/lua/config/keymaps.lua`](config.symlink/lua/config/keymaps.lua).
- Format the current Markdown, JSON, JSONC, or YAML buffer, or a valid Ex line-range fragment, without saving through `:FormatDocument`. The local `document-format` LazyVim plugin dispatches by filetype, uses Prettier with an 80-column prose wrap for Markdown, and reports an error when neither Bun nor Node.js is installed. Its plugin specification is in [`config.symlink/lua/plugins/document_format.lua`](config.symlink/lua/plugins/document_format.lua), with modular implementation files in [`config.symlink/lua/document_format/`](config.symlink/lua/document_format/).
- Format shell buffers through shfmt and Dockerfiles through dockerfmt with `:FormatDocument`, updating only the current buffer and never saving it. If shfmt is unavailable, the plugin installs `mvdan.cc/sh/v3/cmd/shfmt@latest` through Go. Shell and Dockerfile range formatting is unsupported because their formatters require complete documents. This is configured in [`config.symlink/lua/document_format/`](config.symlink/lua/document_format/).
- Format TOML buffers through Taplo with `:FormatDocument`, updating only the current buffer and never saving it. If Taplo is unavailable, the plugin installs `taplo-cli` through Cargo when Rust is installed. TOML range formatting is unsupported because Taplo requires a complete document. This is configured in [`config.symlink/lua/document_format/`](config.symlink/lua/document_format/).
- Display Markdown source literally by disabling concealment, so table alignment remains visible in the editor. This is configured in [`config.symlink/lua/config/autocmds.lua`](config.symlink/lua/config/autocmds.lua).
- Disable word wrapping for all filetypes, including LazyVim's prose filetypes, and show vertical guides at columns 80 and 120. This is configured in [`config.symlink/lua/config/options.lua`](config.symlink/lua/config/options.lua) and [`config.symlink/lua/config/autocmds.lua`](config.symlink/lua/config/autocmds.lua).
- Use `,` as both the global and local Neovim leader key, configured in [`config.symlink/lua/config/options.lua`](config.symlink/lua/config/options.lua).
- Use the Base16 Eighties colorscheme for Neovim, configured in [`config.symlink/lua/plugins/base16.lua`](config.symlink/lua/plugins/base16.lua).
