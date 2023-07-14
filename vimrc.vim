"
" Note that for this configuration to be loaded when the editor is launched
" I had to put the following contents in the file ~/.config/nvim/init.vim
"
" source ~/.vimrc
"

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

"
" Important:
"
" I can't find a place to keep track of the coc plugins installe so here they
" are:
"
" CocInstall coc-eslint
" CocInstall coc-tsserver
"

let g:coc_config_home=s:current_directory
let g:coc_data_home=g:coc_config_home.'/coc-vim/'
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
nmap <silent> gd <Plug>(coc-definition)

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

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

" Added this config following this https://github.com/neoclide/coc-prettier/commit/25b5fa55580f0958ceb428da789efd0808115f2c#diff-1550ec65ac92f65817fc28928dfef526912b5f52356ff43651369bae92f56031R96
command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument
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
" From: https://github.com/junegunn/fzf#respecting-gitignore
"
" Note that this requires 'fd' to be installed
"
" The configuration also uses the 'with_preview' helper
" to get the preview window options
"
" From: https://github.com/junegunn/fzf.vim#example-customizing-files-command
command! -bang -nargs=? -complete=dir PFiles
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'source': 'fd --type f', 'options': ['--info=inline']}), <bang>0)

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
