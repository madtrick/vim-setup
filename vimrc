if empty($NEW_VIM_SETUP_PATH)
  throw '$NEW_VIM_SETUP_PATH is empty or undefined'
endif

set number
set ignorecase
set tabstop      =2
set softtabstop  =2
set shiftwidth   =2

call plug#begin($NEW_VIM_SETUP_PATH.'/plugins')
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"
" Begin coc.vim config
"

let g:coc_config_home='/Users/farruco/repos/personal/new-vim-setup'
let g:coc_data_home='/Users/farruco/repos/personal/new-vim-setup/coc-vim/'
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
nmap <silent> gd <Plug>(coc-definition)
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" Use K to show documentation in preview window.
nnoremap <silent> <S-m> :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
augroup mygroup
  autocmd!
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')
augroup end
"
" End coc.vim config
"
Plug 'jiangmiao/auto-pairs'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
" Use GFiles instead of plain Files to avoid getting results for
" non tracked files as for example anything under `node_modules`
nnoremap <c-F> :GFiles<CR>
nnoremap W :W<CR>
call plug#end()

colorscheme gruvbox


" Move with ease
nnoremap H <C-w>h
nnoremap L <C-w>l
nnoremap J <C-w>j
nnoremap K <C-w>k

" Clear the search highlighting
nnoremap <silent> <BS> :nohlsearch<CR>

" Move half-page up or down
nnoremap <A-k> <C-u>
nnoremap <A-j> <C-d>
