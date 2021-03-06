execute pathogen#infect()

syntax enable

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set expandtab
set tabstop=4 shiftwidth=4
set autochdir

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set number
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set ignorecase
set smartcase
set hidden      " allows buffer to be hidden when modified
set laststatus=2 " always show the status bar
set mousehide
set splitbelow splitright

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  set hlsearch
  set guioptions-=T
  set guioptions-=r
  set guioptions-=L
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " auto-reload .vimrc whenever it is updated
  augroup myvimrchooks
    au!
    autocmd bufwritepost .vimrc source ~/.vimrc
  augroup END

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Read .md files as Markdown, not Modula-2
  autocmd BufNewFile,BufReadPost *.md set filetype=markdown

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

if has("unix")
    " different GUI fonts for Mac and Linux
    let s:uname = substitute(system("uname"), '\n', '', '')
    if !v:shell_error
        if s:uname == "Darwin"
            set guifont=Source\ Code\ Pro\ for\ Powerline:h14
        elseif s:uname == "Linux"
            set guifont=Meslo\ LG\ L\ DZ\ for\ Powerline\ 13
        endif
    endif
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
              \ | wincmd p | diffthis
endif
colorscheme wombat

" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>
nmap <space> :
" Treat lines longer than window width as multiple lines
nnoremap j gj
nnoremap k gk
" Use CTRL-N to move forward buffer, CTRL-B to move back.
map <C-n> :bn<CR>
map <C-b> :bp<CR>
imap jk <ESC>
" Go to first matching tag
map tt <c-]>

if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

" vim-airline settings
let g:airline_enable_syntastic = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" use CTRL-s to run syntax/style check
nmap <C-s> :SyntasticCheck<CR>
" Syntastic settings
let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"
let g:syntastic_check_on_wq = 0 " don't run on save if quitting
let g:syntastic_check_on_open = 1
let g:syntastic_scss_checkers = ['scss_lint']
let g:syntastic_haml_checkers = ['haml_lint']
let g:syntastic_ruby_checkers = ['rubocop', 'ruby-lint']
let g:syntastic_mode_map = {
        \ "mode": "active",
        \ "active_filetypes": ["ruby", "python"],
        \ "passive_filetypes": ["java"] }

" custom Rails.vim commands
let g:rails_projections = {
    \ "config/routes.rb": { "command": "routes" },
    \ "Gemfile": { "command": "gemfile" },
    \ "db/seeds.rb": { "command": "seeds" },
    \ "spec/factories/*.rb": { "command": "factory" },
    \ "features/*.feature": { "command": "feature" },
    \ "features/step_definitions/*.rb": { "command": "step" },
    \ "features/support/*.rb": { "command": "support" }}
