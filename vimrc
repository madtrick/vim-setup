if empty($NEW_VIM_SETUP_PATH)
  throw '$NEW_VIM_SETUP_PATH is empty or undefined'
endif

call plug#begin($NEW_VIM_SETUP_PATH.'/plugins')
Plug 'morhetz/gruvbox'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

colorscheme gruvbox

