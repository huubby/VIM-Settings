" All system-wide defaults are set in $VIMRUNTIME/debian.vim (usually just
" /usr/share/vim/vimcurrent/debian.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vim/vimrc), since debian.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing debian.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
    source /etc/vim/vimrc.local
endif

"""""""""""""""""""""""""""""""""""""""""""""""""
" ===>> General
"""""""""""""""""""""""""""""""""""""""""""""""""
"set how many lines of history VIM has to remember
set history=700

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" Load indentation rules and plugins according to the detected filetype.
if has("autocmd")
    filetype plugin indent on
endif

set autoread " auto read file 

"set mapleader
let mapleader = ","
let g:mapleader = ","

" Fast reload the .vimrc
map <silent> <leader>ss :source ~/.vimrc<cr>
" Fast editing of .vimrc
map <silent> <leader>ee :e ~/.vimrc<cr>
" Fast saving
map <silent> <leader>w :w!<cr>
" Fast quiting, with make session to save current workspace
map <silent> <leader>q :mksession cursession<cr>:q<cr>

"when vimrc is writed, reload it
if has('autocmd')
    autocmd! bufwritepost .vimrc source ~/.vimrc
endif 

" fold settings, fold the same indent line
" 'zc', 'za', 'zo' change the fold
set foldmethod=indent
set foldlevel=99

"""""""""""""""""""""""""""""""""""""""""
"        VIM user interface 
"""""""""""""""""""""""""""""""""""""""""
" set 7 lines to the cursors - when moving vertical
set so=7
set wildmenu
set nolazyredraw
set magic
set ruler "Always show current position

set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set cmdheight=1 " The commandbar height

" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching

set hlsearch        "Highlight search things
set incsearch		" Incremental search
set mat=2           " How many tenths of a second to blink

set autowrite		" Automatically save before commands like :next and :make
set hidden             " Hide buffers when they are abandoned
set number          " Show line number

" No sound on errors - I'm not sure about if I really need this
"set noerrorbells
"set novisualbell
"set t_vb=
"set tm=500

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf8

" Syntax highlighting by default.
if has("syntax")
  syntax on
endif

if has("gui_running")
    set guioptions-=T
    set lines=45 columns=160
    set t_Co=256
    set background=dark
    set gfn=Monaco:h12
    colorscheme Tomorrow-Night-Eighties
    set nu
else  
    set t_Co=256
    colorscheme Tomorrow-Night-Eighties
    set background=dark
    set nu
endif

try
    lang en_US
catch
endtry

set ffs=unix,dos,mac " Default file types


"""""""""""""""""""""""""""""""""""""""""
" Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""
" Turn backup off, using SVN or git, no local backup
set nobackup nowb noswapfile

" Persistent undo
"try
"    set undodir=~/.vim/undodir
"    set undofile
"catch
"endtry

" Jump to the last position when reopening a file
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"""""""""""""""""""""""""""""""""""""""""
" Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""
set expandtab "expand tab as blank
set shiftwidth=4
set tabstop=4
set smarttab

set lbr "no new line before one word is finished
set tw=140 "new line over 155 columns

" Set auto indent, smart indent, wrap lines
set ai si wrap


""""""""""""""""""""""""""""""
" Visual mode related
""""""""""""""""""""""""""""""
" In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSearch('gv')<CR>
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map space to / (search) and c-space to ? (backgwards search)
map <space> /
map <c-space> ?
map <silent> <leader><cr> :noh<cr>

" Close the current buffer without saving
map <leader>bd :Bclose<cr>

" Map the <Esc> to a nearer key under insert mode
inoremap <c-[> <Esc>

" Use the arrows switch among buffers
map <right> :bn<cr>
map <left> :bp<cr>

" When pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>

command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete ".l:currentBufNum)
   endif
endfunction


"""""""""""""""""""""""""""""""""""""""""
" Statusline
"""""""""""""""""""""""""""""""""""""""""
" Always hide the statusline
set laststatus=2

" Format the statusline, this is fantastic!
"au FileType c,cpp,python 
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c

function! CurDir()
    let curdir = substitute(getcwd(), '/home/wall', "~", "g")
    return curdir
endfunction

function! HasPaste()
    if &paste
        return 'PASTE MODE'
    else
        return ''
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""
" TaskList
"""""""""""""""""""""""""""""""""""""""""
" Open task list
map <leader>td <Plug>TaskList


"""""""""""""""""""""""""""""""""""""""""
" Parenthesis/bracket expanding
"""""""""""""""""""""""""""""""""""""""""
vnoremap $1 <esc>`>a)<esc>`<i(<esc>
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $e <esc>`>a"<esc>`<i"<esc>

inoremap $1 ()<esc>i
inoremap $2 []<esc>i
inoremap $3 {}<esc>i
inoremap $4 {<esc>o}<esc>0
inoremap $q ''<esc>i
inoremap $e ""<esc>i
inoremap $t <><esc>i


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Delete trailing white space, useful for Python ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

autocmd BufWrite *.py :call DeleteTrailingWS()

"""""""""""""""""""""""""""""""""""""""""
" Quickfix 
"""""""""""""""""""""""""""""""""""""""""
autocmd FileType c,cpp map<buffer> <leader><space> :w<cr>:make<cr>
nmap <leader>cc :botright cope<cr>
nmap <leader>cn :cn<cr>
nmap <leader>cp :cp<cr>
nmap <leader>ccl :ccl<cr>


"""""""""""""""""""""""""""""""""""""""""
" BufExplorer
"""""""""""""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0 " Do not show default help
let g:bufExplorerShowRelativePath=1 " Show relative paths
"let g:bufExplorerShowTabBuffer=1 " Show buffers on
autocmd BufWinEnter \[Buf\ List\] setl nonumber 
map <leader>o :BufExplorer<cr>


"""""""""""""""""""""""""""""""""""""""""
" MiniBufExplorer
"""""""""""""""""""""""""""""""""""""""""
let g:miniBufExplMapWindowNavVim = 1 
"let g:miniBufExplMapWindowNavArrows = 1 
"let g:miniBufExplMapCTabSwitchBufs = 1 
let g:miniBufExplorerMoreThanOne = 2
let g:miniBufExplModSelTarget = 0
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplVSplit = 25
let g:miniBufExplSplitBelow=1

let g:bufExplorerSortBy = "name"

autocmd BufRead,BufNew :call UMiniBufExplorer

map <leader>u :TMiniBufExplorer<cr>


"""""""""""""""""""""""""""""""""""""""""
" AutoComplete
"""""""""""""""""""""""""""""""""""""""""
inoremap <C-]>   <C-X><C-]>
inoremap <C-F>   <C-X><C-F>
inoremap <C-D>   <C-X><C-D>
inoremap <C-L>   <C-X><C-L>
inoremap <C-P>   <C-X><C-P>

"""""""""""""""""""""""""""""""""""""""""
" SuperTab
"""""""""""""""""""""""""""""""""""""""""
let g:SuperTabDefaultCompletionType="context"


"""""""""""""""""""""""""""""""""""""""""
" OmniCppComplete
"""""""""""""""""""""""""""""""""""""""""
" Short-key for make tags for cpp file
set completeopt=longest,menu 
"map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q<cr>
set completeopt=longest,menu

autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType python set omnifunc=pythoncomplete#Complete

""""""""""""""""""""""""""""""
" => Python section
" """"""""""""""""""""""""""""""
let python_highlight_all=1
au FileType python syn keyword pythonDecorator True None False self
au FileType python set tags+=/usr/lib/python2.7/python27tags
au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

au FileType python inoremap <buffer> $r return
au FileType python inoremap <buffer> $i import
au FileType python inoremap <buffer> $p print
au FileType python inoremap <buffer> $f #--- PH ----------------------------------------------<esc>FP2xi
au FileType python map <buffer> <leader>1 /class
au FileType python map <buffer> <leader>2 /def
au FileType python map <buffer> <leader>C ?class
au FileType python map <buffer> <leader>D ?def


"""""""""""""""""""""""""""""""""""""""""
" pyflakes
"""""""""""""""""""""""""""""""""""""""""
let g:pyflakes_use_quickfix = 0

"""""""""""""""""""""""""""""""""""""""""
" Google appengine
"""""""""""""""""""""""""""""""""""""""""
au FileType python set tags+=/usr/lib/python2.7/gapptags

"""""""""""""""""""""""""""""""""""""""""
" HTML section
"""""""""""""""""""""""""""""""""""""""""
au BufNewFile,BufRead *.html set filetype=htmldjango

"""""""""""""""""""""""""""""""""""""""""
" winManager setting
"""""""""""""""""""""""""""""""""""""""""
" Set window layout
" BufExplorer and FileExplorer share one window, using 'CTRL-N' switch betweens the two windows
let g:winManagerWindowLayout = "BufExplorer,FileExplorer|TagList"
let g:winManagerWidth = 40
let g:defaultExplorer = 1
"let g:persistentBehaviour=0     " Only the explorer windows are the ones left, VIM quit
" Set short-key for switching to left top window
nmap <C-W><C-F> :FirstExplorerWindow<cr>
" Set short-key for switching to left bottom window
nmap <C-W><C-B> :BottomExplorerWindow<cr>
" Set short-key for open/close winManager
nmap <silent> <leader>wm :WMToggle<cr> 


"""""""""""""""""""""""""""""""""""""""""
" Taglist
"""""""""""""""""""""""""""""""""""""""""
" Indicate ctags path
let Tlist_Ctags_Cmd='ctags'
" Only show tags in current file
let Tlist_Show_One_File=1
" Exit vim if tags window is only windows
let Tlist_Exit_OnlyWindow=1
" Short-key for previous/next tag in tags stack
"nmap <leader>tp :tp<cr>
"nmap <leader>tn :tn<cr>
"nmap <leader>tu :TlistUpdate<cr>
" Short-key for flip tags list open/close, not useful when using winmanager
"map <silent> <F9> :TlistToggle<cr>


""""""""""""""""""""""""""""""
" lookupfile setting
" """"""""""""""""""""""""""""""
let g:LookupFile_MinPatLength = 3               " two characters need to start searching
let g:LookupFile_PreserveLastPattern = 0        " do not saving the last search string
let g:LookupFile_PreservePatternHistory = 1     " saving history
let g:LookupFile_AlwaysAcceptFirst = 1
let g:LookupFile_AllowNewFiles = 0
let g:LookupFile_FileFilter = '\.class$\|\.o$\|\.obj$\|\.exe$\|\.jar$\|\.zip$\|\.war$\|\.ear$' "Don't display binary files
if filereadable("./filenametags")
    let g:LookupFile_TagExpr = string('./filenametags')
    let g:LookupFile_LookupFunc = 'LookupFile_IgnoreCaseFunc'
endif

nmap <silent> <leader>lk :LUTags<cr>
nmap <silent> <leader>ll :LUBufs<cr>
nmap <silent> <leader>lw :LUWalk<cr>
" lookup file with ignore case
function! LookupFile_IgnoreCaseFunc(pattern)
    let _tags = &tags
    try
        let &tags = eval(g:LookupFile_TagExpr)
        let newpattern = '\c' . a:pattern
        let tags = taglist(newpattern)
    catch
        echohl ErrorMsg | echo "Exception: " . v:exception | echohl NONE
        return ""
    finally
        let &tags = _tags
    endtry

    " Show the matches for what is typed so far.
    let files = map(tags, 'v:val["filename"]')
    return files
endfunction


""""""""""""""""""""""""""""""""""""""
" Ctrl-P settings
""""""""""""""""""""""""""""""""""""""
let g:ctrlp_map='<c-p>'
let g:ctrlp_wirking_path_mode=0 " don't change the working directory
set wildignore+='*/.git/*,*/.hg/*,*/.svn/*'
let g:ctrlp_custom_ignore='\.git$\|\.hg$\|\.svn$'
let g:ctrlp_user_command='find %s -type f' " custom file listing command


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Cscope setting
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("cscope")
    set csprg=/usr/bin/cscope
    set csto=1
    set cst
    set nocsverb
    " add any database in current directory
    if filereadable("cscope.out")
        cs reset
        cs add cscope.out
    endif
    set csverb
endif

nmap <leader>cfs :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <leader>cfg :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <leader>cfc :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <leader>cft :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <leader>cfe :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <leader>cff :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <leader>cfi :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <leader>cfd :cs find d <C-R>=expand("<cword>")<CR><CR>


"""""""""""""""""""""""""""""""""""""""""
" Tags settings 
"""""""""""""""""""""""""""""""""""""""""
set tags+=/usr/include/tags

"""""""""""""""""""""""""""""""""""""""""
" Local settings 
"""""""""""""""""""""""""""""""""""""""""
" Set tags
if filereadable("local.vim")
    source local.vim
endif

""""""""""""""""""""""""""""""""
" Arrow fixing
""""""""""""""""""""""""""""""""
nnoremap <Esc>A <up>
nnoremap <Esc>B <down>
nnoremap <Esc>C <right>
nnoremap <Esc>D <left>
inoremap <Esc>A <up>
inoremap <Esc>B <down>
inoremap <Esc>C <right>
inoremap <Esc>D <left>

"""""""""""""""""""""""""""""""""""""""
" vimdiff color settings
"""""""""""""""""""""""""""""""""""""""
highlight DiffAdd term=reverse cterm=bold ctermbg=green ctermfg=white
highlight DiffChange term=reverse cterm=bold ctermbg=cyan ctermfg=black
highlight DiffText term=reverse cterm=bold ctermbg=gray ctermfg=black
highlight DiffDelete term=reverse cterm=bold ctermbg=red ctermfg=black
