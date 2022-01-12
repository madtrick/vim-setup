if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  " Copy to the clipboard when yankin
  set clipboard=unnamed
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

let mapleader = ";"

set number
set ignorecase
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set list
set listchars+=trail:¶

" Got the trick to the current directory from https://stackoverflow.com/a/18734557
let s:current_directory = fnamemodify(resolve(expand('<sfile>:p')), ':h')

call plug#begin(s:current_directory.'/plugins')
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/jsonc.vim'
" tsconfig.json is actually jsonc, help TypeScript set the correct filetype
autocmd BufRead,BufNewFile tsconfig.json set filetype=jsonc
autocmd BufRead,BufNewFile api-extractor.json set filetype=jsonc

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
" Use Shift-m to show documentation in preview window.
nnoremap <silent> <S-m> :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction
augroup mygroup
  autocmd!
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')
augroup end
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
" CocAction
nmap <c-a> <Plug>(coc-codeaction)
" End coc.vim config
"
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'kana/vim-textobj-user' " required for vim-textobj-line
Plug 'kana/vim-textobj-line'
Plug 'tpope/vim-vinegar'
nnoremap W :W<CR>

" Create custom command PFiles (project files)
" Uses recommendation from fzf to ignore files mentioned in the .gitignore
" https://github.com/junegunn/fzf#respecting-gitignore
command! -bang -nargs=? -complete=dir PFiles
    \ call fzf#vim#files(<q-args>, {'source': 'fd --type f'}, <bang>0)
" Use PFiles instead of plain Files to avoid getting results for
" non tracked files as for example anything under `node_modules`
nnoremap <c-F> :PFiles<CR>
Plug 'pbrisbin/vim-mkdir'
Plug 'tpope/vim-commentary'
Plug 'liuchengxu/vista.vim'
let g:vista_default_executive = 'coc'
let g:vista#renderer#enable_icon = 0
nnoremap <silent> <leader>v :Vista finder<CR>
Plug 'tpope/vim-fugitive'
" Required to have highlighting in JSX/TSX files
Plug 'peitalin/vim-jsx-typescript'
" To get real nice TS syntax highlighting

" This setting is a suggestion from Yats:
"   Old regexp engine will incur performance issues for yats and old engine is
"   usually turned on by other plugins.
set re=0
Plug 'HerringtonDarkholme/yats.vim'
Plug 'pantharshit00/vim-prisma'
call plug#end()

colorscheme gruvbox

" Minimal statusline
set statusline=%<%f\ %h%m%r\ %{coc#status()}%=%-14.(%l,%c%V%)\ %P


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

" Select previously pasted object
nnoremap gV `[v`]

"-- FOLDING --
set foldmethod=syntax "syntax highlighting items specify folds
set foldcolumn=1 "defines 1 col at window left, to indicate folding
let javaScript_fold=1 "activate folding by JS syntax
set foldlevelstart=99 "start file with all folds opened
