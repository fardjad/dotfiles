local telescope = require('telescope')

telescope.load_extension('fzf')

vim.cmd([[
  nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
  nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
  nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
  nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

  " lsp related commands are prefixed with l
  nnoremap <leader>lw <cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>
  nnoremap <leader>lr <cmd>lua require('telescope.builtin').lsp_references()<cr>
]]);

