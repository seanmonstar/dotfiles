
" Modificacions: 
"	- Antoni Aloy (aaloy@apsl.net)
"	- Piotr Zalewa (piotr@zalewa.info)
"
" Afegit : http://github.com/skyl/vim-config-python-ide/blob/supertab/.vimrc
" Afegit :  http://code.google.com/p/pycopia/source/browse/trunk/vim/vimfiles/vimrc.vim
" Tested with vim7
"
" 14/10/2919 - Added pathogen config and changed some configs (no pylint on
"			   save)
" 5/04/2010  - Added tComment from  http://www.vim.org/scripts/script.php?script_id=1173
"            - Added better tab completion (test shift+tab)
"            - Added markdown syntax
"            - Added additional colour themes
" 5/04/2010  - Merged with http://amix.dk/vim/vimrc.html
" 26/04/2010 - Change surround
"			   Better match it
"			   Updated vcs plugin
"
" 8/07/2010  - Merges from  http://github.com/JoseBlanca/vim-for-python/blob/master/vimrc
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()


""" ininite undo file
set undofile  
set undodir=/tmp  

set encoding=utf-8
set ffs=unix,dos,mac "Default file types

"Set backup to a location
set backup
set backupdir=$HOME/temp/vim_backups/ 
set directory=$HOME/temp/vim_swp/ 
set noswapfile

cd D:/Users/Sean/Documents/Mozilla

" Establim els amples de tabulació

au BufRead,BufNewFile *.py  set ai sw=4 sts=4 et tw=72 " Doc strs
au BufRead,BufNewFile *.js  set ai sw=4 sts=4 et tw=72 " Doc strs
au BufRead,BufNewFile *.html set ai sw=4 sts=4 et tw=72 " Doc strs
au BufRead,BufNewFile *.json set ai sw=4 sts=4 et tw=72 " Doc strs
au BufNewFile *.html,*.py,*.pyw,*.c,*.h,*.json set fileformat=unix
au! BufRead,BufNewFile *.json setfiletype json 

let python_highlight_all=1
syntax on

" Bad whitespace
highlight BadWhitespace ctermbg=red guibg=red
" Display tabs at the beginning of a line in Python mode as bad.
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
" Make trailing whitespace be flagged as bad.
au BufRead,BufNewFile *.js,*.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

filetype plugin on
set iskeyword+=.

"" Skip this file unless we have +eval
if 1

""" Settings 
set nocompatible						" Don't be compatible with vi

"""" Movement
" work more logically with wrapped lines
noremap j gj
noremap k gk

"""" Searching and Patterns
set ignorecase							" search is case insensitive
set smartcase							" search case sensitive if caps on 
set incsearch							" show best match so far
set hlsearch							" Highlight matches to the search 

"""" Display
"set background=dark						" I use dark background
set lazyredraw							" Don't repaint when scripts are running
set scrolloff=3							" Keep 3 lines below and above the cursor
set ruler								" line numbers and column the cursor is on
set number								" Show line numbering
set numberwidth=1						" Use 1 col + 1 space for numbers
set ttyfast

if has("gui_running")
	syntax enable
	set t_Co=256
	set hlsearch
	set clipboard=autoselect
	
	"LIGHT
	"colorscheme pyte
	"hi ColorColumn guibg=#e0d0d0

	"DARK
	"let g:zenburn_high_Contrast = 1
	"colorscheme zenburn
	"colorscheme lettuce
	"colorscheme wombat
	"colorscheme slate
	"hi ColorColumn guibg=#303030

	set nu
	set guioptions-=T
	" Solarized options
	" let g:solarized_bold=0
	" let g:solarized_italic=0
	let g:solarized_contrast="high"
	" let g:solarized_visibility="high"
	set nu
	set guioptions-=T
	if has('mac')
		set guifont=Monaco:h9
		set columns=999
		set background=light
		colorscheme solarized
	elseif has('unix')
		" set guifont=ProFont\ 10
		"set guifont=ProggyCleanTT\ 12
		set guifont=Monaco\ 9
		set guioptions-=m
		set background=light
		colorscheme solarized
	else
		colorscheme solarized
		set guifont=Consolas\ for\ Powerline\ FixedD:h10
	endif
	" toggle light/dark background with a F5 key
	call togglebg#map("<F5>")

else
	set t_Co=256
	"set background=dark
	" let g:zenburn_high_Contrast = 0
	"colorscheme zenburn
	"colorscheme watermark
	"colorscheme nightsky
	" :hi ColorColumn ctermbg=233

	let g:solarized_termcolors=256
	syntax enable
	set background=dark
	colorscheme solarized
endif


" tab labels show the filename without path(tail)
set guitablabel=%N/\ %t\ %M

""" Windows
if exists(":tab")						" Try to move to other windows if changing buf
set switchbuf=useopen,usetab
else									" Try other windows & tabs if available
	set switchbuf=useopen
endif

"""" Messages, Info, Status
set shortmess+=a						" Use [+] [RO] [w] for modified, read-only, modified
set showcmd								" Display what command is waiting for an operator
set laststatus=2						" Always show statusline, even if only 1 window
set report=0							" Notify me whenever any lines have changed
set confirm								" Y-N-C prompt if closing with unsaved changes
set vb t_vb=							" Disable visual bell!  I hate that flashing.
set statusline=%<%f%m%r%y%=%b\ 0x%B\ \ %l,%c%V\ %P
set laststatus=2  " always a status line


"""" Editing
set backspace=2							" Backspace over anything! (Super backspace!)
set matchtime=2							" For .2 seconds
set formatoptions-=tc					" I can format for myself, thank you very much
set nosmartindent
"XXX: uncommented
set autoindent
"set cindent
set tabstop=4							" Tab stop of 4
set shiftwidth=4						" sw 4 spaces (used on auto indent)
set softtabstop=4						" 4 spaces as a tab for bs/del
set matchpairs+=<:>						" specially for html
"set showmatch							" Briefly jump to the previous matching parent

" highlight tabs and trailing spaces
set list listchars=tab:→\ ,trail:·


"""" XXX: From dotfiles
set scrolloff=2    " keep this many lines of context around cursor
set esckeys        " make use of function keys possible
set smarttab       " indent next line as the previous


"""" Coding
set history=100							" 100 Lines of history
set showfulltag							" Show more information while completing tags
filetype plugin indent on				" Let filetype plugins indent for me

" set up tags
set tags=tags;/
set tags+=$HOME/.vim/tags/python.ctags

""""" Folding
set foldmethod=indent					" By default, use indent to determine folds
set foldlevelstart=99					" All folds open by default
set nofoldenable

"""" Command Line
set wildmenu							" Autocomplete features in the status bar
set wildmode=longest:full,list
set wildignore=*.o,*.obj,*.bak,*.exe,*.py[co],*.swp,*~,*.pyc,.svn

"""" Autocommands
if has("autocmd")
augroup vimrcEx
au!
	au BufNewFile,BufRead *.{md,mkd,mkdn,mark*,txt} set filetype=markdown
	au BufNewFile,BufRead *.json set filetype=javascript
	au BufNewFile,BufRead *.rs set filetype=rust
	" In plain-text files and svn commit buffers, wrap automatically at 78 chars
	au FileType text,svn setlocal tw=78 fo+=t

	" In all files, try to jump back to the last spot cursor was in before exiting
	au BufReadPost *
		\ if line("'\"") > 0 && line("'\"") <= line("$") |
		\   exe "normal g`\"" |
		\ endif

	" Use :make to check a script with perl
	au FileType perl set makeprg=perl\ -c\ %\ $* errorformat=%f:%l:%m

	" Use :make to compile c, even without a makefile
	au FileType c,cpp if glob('Makefile') == "" | let &mp="gcc -o %< %" | endif

	" Switch to the directory of the current file, unless it's a help file.
	au BufEnter * if &ft != 'help' | silent! cd %:p:h | endif

	" Insert Vim-version as X-Editor in mail headers
	au FileType mail sil 1  | call search("^$")
				 \ | sil put! ='X-Editor: Vim-' . Version()

	" smart indenting for python
	au FileType python set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
	autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
	set iskeyword+=.,_,$,@,%,#

	" allows us to run :make and get syntax errors for our python scripts
	"au FileType python set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
	"au FileType python compiler pylint
	"au FileType python compiler pyflakes
	au FileType python set expandtab

	" setup file type for snipmate
	"--------------------------------------------------------------------------
	au FileType python set ft=python.django
	au FileType html set ft=htmldjango.html
	"au FileType javascript set ft=javascript.mootools 

	" kill calltip window if we move cursor or leave insert mode
	au CursorMovedI * if pumvisible() == 0|pclose|endif
	au InsertLeave * if pumvisible() == 0|pclose|endif
	
	autocmd FileType python set omnifunc=pythoncomplete#Complete
	autocmd FileType python.django set omnifunc=pythoncomplete#Complete
	autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
	autocmd FileType htmldjango.html set omnifunc=htmlcomplete#CompleteTags
	autocmd FileType css set omnifunc=csscomplete#CompleteCSS

	" Javascript indenting
	au FileType javascript set sw=2 ts=2 expandtab
	" Rust indenting
	au FileType rust set sw=4 ts=4 expandtab

	"autocmd BufWritePost *.js :JSHint 

	augroup END
endif

"""" Key Mappings

" PyLint on demand
au FileType python nmap	<F9> :Pylint<CR>
au FileType javascript nmap <F9> :JSHint<CR>

""" syntastic
let g:syntastic_auto_loc_list=1
let g:syntastic_always_populate_loc_list=1

" bind ctrl+space for omnicompletion
inoremap <Nul> <C-x><C-o>
imap <c-space> <C-x><C-o>

"Format 
au FileType xml map <F9> :silent 1,$!xmllint --format --recover - 2>/dev/null<CR>

" tab navigation (next tab) with alt left / alt right
nnoremap  <a-right>  gt
nnoremap  <a-left>   gT

" Ctrl + Arrows - Move around quickly
"nnoremap  <c-up>     {
"nnoremap  <c-down>   }
"nnoremap  <c-right>  El
"nnoremap  <c-down>   Bh

""" moving one line
nmap <c-up> [e
nmap <c-down> e]
""" moving selection
vmap <c-up> [egv
vmap <c-down> ]egv

" Shift + Arrows - Visually Select text
" TODO Check where it's overwritten
nnoremap  <s-up>     Vk
nnoremap  <s-down>   Vj
nnoremap  <s-right>  vl
nnoremap  <s-left>   vh

if &diff
" easily handle diffing 
   vnoremap < :diffget<CR>
   vnoremap > :diffput<CR>
   vnoremap j :[c
   vnoremap k :]c
else
" visual shifting (builtin-repeat)
   vnoremap < <gv                       
   vnoremap > >gv 
endif

"""" Moving between windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
map <C-t> <C-w>t

""" Toggle the tag list bar
nmap <F4> :TlistToggle<CR>

""" Goyo discraction free writing
nmap <F6> :Goyo<CR>
function! g:goyo_before()
  set lbr
  set nolist
endfunction

function! g:goyo_after()
  set list listchars=tab:→\ ,trail:·
endfunction

let g:goyo_callbacks = [function('g:goyo_before'), function('g:goyo_after')]

""" CtrlP
let g:ctrlp_cmd = 'CtrlPMixed'

""" Airline
set noshowmode
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline#extensions#whitespace#enabled = 0

let g:airline_symbols.branch = '◊'
let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'

let g:airline_powerline_fonts = 'fancy'

function! AirLineMe()
  function! Modified()
    return &modified ? " +" : ''
  endfunction

  call airline#parts#define_raw('filename', '%<%f')
  call airline#parts#define_function('modified', 'Modified')

  let g:airline_section_b = airline#section#create_left(['filename'])
  let g:airline_section_c = airline#section#create([''])
  let g:airline_section_gutter = airline#section#create(['modified', '%='])
  let g:airline_section_x = airline#section#create_right([''])
  let g:airline_section_y = airline#section#create_right(['%l:%c'])
  let g:airline_section_z = airline#section#create(['branch'])
endfunction

autocmd Vimenter * call AirLineMe()

let g:airline_theme_patch_func = 'AirLineMyTheme'

function! AirLineMyTheme(palette)
  if g:airline_theme == 'solarized'
    let secondary = ['#ffffff', '#657b83', 255, 240, '']

    let magenta = ['#ffffff', '#d33682', 255, 125, '']
    let blue = ['#ffffff', '#268bd2', 255, 33, '']
    let green = ['#ffffff', '#859900', 255, 64, '']
    let yellow = ['#ffffff', '#b58900', 255, 136, '']

    let modes = {
      \ 'normal': blue,
      \ 'insert': yellow,
      \ 'replace': green,
      \ 'visual': magenta
      \}

    let a:palette.replace = copy(a:palette.insert)
    let a:palette.replace_modified = a:palette.insert_modified

    for key in ['insert', 'visual', 'normal']
      " no red on modified
      let a:palette[key . '_modified'].airline_c[0] = '#657b83'
      let a:palette[key . '_modified'].airline_c[2] = 11

      for section in ['a', 'b', 'y', 'z']
        let airline_section = 'airline_' . section
        if has_key(a:palette[key], airline_section)
          " white foreground for most components; better contrast imo
          let a:palette[key][airline_section][0] = '#ffffff'
          let a:palette[key][airline_section][2] = 255
        endif
      endfor
    endfor

    for key in keys(modes)
      let a:palette[key].airline_a = modes[key]
      let a:palette[key].airline_z = modes[key]

      let a:palette[key].airline_b = secondary
      let a:palette[key].airline_y = secondary
    endfor

  endif
endfunction

""" NerdTree toggle
nmap <F8> :NERDTreeToggle<CR>

"""" TaskList
nmap <F10> :TaskList<CR>

" Extra functionality for some existing commands:
" <C-6> switches back to the alternate file and the correct column in the line.
nnoremap <C-6> <C-6>`"

" CTRL-g shows filename and buffer number, too.
nnoremap <C-g> 2<C-g>

" <C-l> redraws the screen and removes any search highlighting.
"nnoremap <silent> <C-L> :nohl<CR><C-l>

" Q formats paragraphs, instead of entering ex mode
noremap Q gq

" * and # search for next/previous of selected text when used in visual mode
vnoremap * y/<C-R>"<CR>
vnoremap # y?<C-R>"<CR>

" <space> toggles folds opened and closed
nnoremap <space> za

" <space> in visual mode creates a fold over the marked range
vnoremap <space> zf

" allow arrow keys when code completion window is up
inoremap <Down> <C-R>=pumvisible() ? "\<lt>C-N>" : "\<lt>Down>"<CR>

""" Abbreviations
function! EatChar(pat)
	let c = nr2char(getchar(0))
	return (c =~ a:pat) ? '' : c
endfunc

endif

"No executam pylint cada vegada, descomentar
let g:pylint_onwrite = 0
let g:pylint_signs = 0
let g:pylint_show_rate = 1

" Taglist variables
" Display function name in status bar:
let g:ctags_statusline=1
" Automatically start script
let generate_tags=1
" Displays taglist results in a vertical window:
let Tlist_Use_Horiz_Window=0
" Shorter commands to toggle Taglist display
nnoremap TT :TlistToggle<CR>
map <F4> :TlistToggle<CR>
" Various Taglist diplay config:
let Tlist_Use_Right_Window = 1
"let Tlist_Compact_Format = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_File_Fold_Auto_Close = 1
" changes the width of the taglist window
let Tlist_WinWidth = 50


" Let abbreviations be in its own file
" ------------------------------------

if filereadable(expand("~/.vim/abbr"))
	source ~/.vim/abbr
endif

"Delete trailing white space, useful for Python ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Cope
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Do :help cope if you are unsure what cope is. It's super useful!
map <leader>cc :botright cope<cr>
map <leader>n :cn<cr>
map <leader>p :cp<cr>
" just subsitute ESC with ,
map <leader> ,


""""" show 80 characters
set colorcolumn=80

""""" Override all settings with not shared vim_local
if filereadable(expand("~/.vim/vimrc_local"))
	source ~/.vim/vim_local
endif

""""" F3 to search for hightlighted word 
map <F3> :execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw<CR>
