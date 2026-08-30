# LazyVim Cheatsheet

## Configuration

| Setting    | Value |
| ---------- | ----- |
| Leader key | `,`   |

## Explorer

| Key      | Action                                                              |
| -------- | ------------------------------------------------------------------- |
| `Ctrl-/` | Toggle the Snacks explorer rooted at the current working directory  |
| `,e`     | Toggle the Snacks explorer rooted at the project root               |
| `,fE`    | Toggle the Snacks explorer rooted at the current working directory  |
| `.`      | Set the explorer root to the selected directory or file's directory |

## Configuration reload

| Command         | Action                                                               |
| --------------- | -------------------------------------------------------------------- |
| `:ReloadConfig` | Reload user options, autocmds, and keymaps without restarting Neovim |

Plugin-spec changes still require restarting Neovim.

## Document formatting

| Command                  | Action                                                                               |
| ------------------------ | ------------------------------------------------------------------------------------ |
| `:FormatDocument`        | Format the current Markdown, JSON, JSONC, YAML, TOML, shell, or Dockerfile buffer    |
| `:{range}FormatDocument` | Format a valid filetype fragment in an Ex line range, such as `:10,20FormatDocument` |

Formatting updates only the current buffer and does not save it. Markdown uses
an 80-column prose wrap. A selected range must be valid for its filetype on its
own. If Prettier finds no changes, it reports that the buffer is already
formatted. The command reports an error when neither Bun nor Node.js is
installed.

Shell buffers use shfmt, which the plugin installs through Go when it is
missing. Dockerfiles use dockerfmt. Shell and Dockerfile formatting require the
complete buffer and do not support ranges.

TOML buffers use Taplo, which the plugin installs through Cargo when Rust is
available. TOML formatting requires the complete buffer and does not support
ranges.

## Pane resizing

| Key          | Action                                |
| ------------ | ------------------------------------- |
| `Ctrl-Alt-h` | Narrow the current pane by one step   |
| `Ctrl-Alt-j` | Shorten the current pane by one step  |
| `Ctrl-Alt-k` | Heighten the current pane by one step |
| `Ctrl-Alt-l` | Widen the current pane by one step    |

## Pane movement

| Key        | Action                              |
| ---------- | ----------------------------------- |
| `Ctrl-w H` | Move the current pane to the left   |
| `Ctrl-w J` | Move the current pane to the bottom |
| `Ctrl-w K` | Move the current pane to the top    |
| `Ctrl-w L` | Move the current pane to the right  |

From terminal input mode, press `Ctrl-\ Ctrl-n` first, then use a pane movement
command.

## Git

| Key   | Action                                                                                              |
| ----- | --------------------------------------------------------------------------------------------------- |
| `,gg` | Open lazygit at the repository root for staging, diffs, commits, branches, and other Git operations |

In lazygit, select a file and press `Space` to stage or unstage it. Press
`Enter` to inspect its diff.

## Terminals

| Key                      | Action                                                                                                   |
| ------------------------ | -------------------------------------------------------------------------------------------------------- |
| `Ctrl-Backtick`          | Toggle terminal 1                                                                                        |
| `2 Ctrl-Backtick`        | Toggle terminal 2                                                                                        |
| `3 Ctrl-Backtick`        | Toggle terminal 3                                                                                        |
| `,t`                     | Create a fresh Snacks terminal in the current window. `exit` restores the previous buffer in that window |
| `,T`                     | Open a picker to select any Snacks terminal buffer, including hidden terminals                           |
| `Enter` in `,T`          | Open the selected terminal in the current window                                                         |
| `Ctrl-s` in `,T`         | Open the selected terminal in a horizontal split                                                         |
| `Ctrl-v` in `,T`         | Open the selected terminal in a vertical split                                                           |
| `Ctrl-t` in `,T`         | Open the selected terminal in a new tab                                                                  |
| `Ctrl-/`                 | Hide the terminal when terminal input is focused                                                         |
| `Ctrl-t` in the explorer | Open a terminal rooted at the selected item's directory                                                  |

Number-prefixed terminals are independent. Repeating the same numbered shortcut
returns to that terminal.

To close only a terminal window or split without ending its process, use
`Ctrl-w c` or `:close`. To replace a terminal in one window while it remains
open elsewhere, focus that window, open `,,`, and select another buffer with
`Enter`. Do not use `Ctrl-x` or `dd` in `,,` for this: they delete the selected
buffer and may stop its terminal process.

## Buffers

| Key               | Action                                        |
| ----------------- | --------------------------------------------- |
| `Shift-h` or `[b` | Previous buffer                               |
| `Shift-l` or `]b` | Next buffer                                   |
| `,,` or `,fb`     | Search and switch to an open buffer           |
| `,bj`             | Pick a visible buffer by its displayed letter |
