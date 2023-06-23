""""""""
" Base "
""""""""
"{{{

" space as leader
noremap <Space> <Nop>
let mapleader = "\<Space>"

" misc
set nocompatible
syntax on
noremap <F12> <Esc>:syntax sync fromstart<CR>
nnoremap ml :<C-u>marks<CR>:normal! `

" indentation
set autoindent
set smarttab
set expandtab
set breakindent
set smartcase
set tabstop=2
set shiftwidth=2
set breakindentopt=shift:2
autocmd BufNew,BufRead *.c,*.cpp setlocal tabstop=4
autocmd BufNew,BufRead *.c,*.cpp setlocal shiftwidth=4
autocmd BufNew,BufRead *.c,*.cpp setlocal breakindentopt=shift:4

" search
set incsearch

" movement
set scrolloff=8

" vertical line mark
set colorcolumn=80

" Mouse support
set mouse=a

" utf-8 encoding
set encoding=utf-8

" enable relative numbers
set number relativenumber

" use system clipboard
set clipboard=unnamedplus

" move to start of the line
set startofline

" limit the width of text to 72 characters when editing a mail on neomutt
autocmd BufNew,BufRead,BufNewFile /tmp/neomutt-* set tw=72

"spellcheck
set spelllang=en,es
autocmd BufNew,BufRead,BufNewFile /tmp/neomutt-* setlocal spell
autocmd BufNew,BufRead,BufNewFile *.Tex set spell

" refresh on file changes
"" Triger `autoread` when files changes on disk
autocmd WinEnter,FocusGained,BufEnter,CursorHold,CursorHoldI *
        \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif

"" Notification after file change
autocmd FileChangedShellPost *
        \  echo "File updated." | echohl None

" Enable autocompletion:
set wildoptions+=pum
set wildmode=longest:full,full

" Disables automatic commenting on newline:
augroup NoCommentOnNewLine 
  autocmd!
  autocmd BufEnter * set formatoptions-=c formatoptions-=r formatoptions-=o
augroup END

" splits
set splitbelow
set splitright

set equalalways

augroup AutomaticWindowSizing
  autocmd!
  autocmd VimResized * wincmd =
  " autocmd VimResized * call <SID>SetWindowsToEqualWidths()
augroup END

" marks and others
nnoremap R q
nnoremap gm `

" J to M
nnoremap H J

" swap g<command> and <command> 
nnoremap j gj
nnoremap k gk
nnoremap $ g$
nnoremap 0 g0
nnoremap ^ g^

vnoremap j gj
vnoremap k gk
vnoremap $ g$
vnoremap 0 g0
vnoremap ^ g^

nnoremap gj j
nnoremap gk k
nnoremap g$ $
nnoremap g0 0
nnoremap g^ ^

vnoremap gj j
vnoremap gk k
vnoremap g$ $
vnoremap g0 0
vnoremap g^ ^

" Better Y
nnoremap Y y$

" Keep n N centered
nnoremap n nzzzv
nnoremap N Nzzzv

function! CenterSearch()
  let cmdtype = getcmdtype()
  if cmdtype == '/' || cmdtype == '?'
    return "\<enter>zzzv"
  endif
  return "\<enter>"
endfunction

cnoremap <silent> <expr> <enter> CenterSearch()

" Undo break points
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap [ [<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u
inoremap <Space> <Space><C-g>u

" Word replace
nnoremap cn *``cgn
nnoremap cN *``cgN

" improve command line
nnoremap <C-;> :<C-f>i

"}}}

"""""""""""""""""""""
" Installed plugins "
"""""""""""""""""""""
"{{{

" auto install plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Declare used plugins
call plug#begin('~/.config/nvim/plugged')

"" programming related
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'lervag/vimtex'
Plug 'habamax/vim-godot'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

"" Visual
Plug 'Federico-Ciuffardi/vim-code-dark'
Plug 'bling/vim-airline'
Plug 'chrisbra/Colorizer'

"" Search and/or replace
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'

"" Integration
""" tmux
Plug 'christoomey/vim-tmux-navigator'
""" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/conflict-marker.vim'

"" Operators, Motions and Commands
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-unimpaired'

"" Undo, Swap, and fold
Plug 'mbbill/undotree'
Plug 'chrisbra/recover.vim'
Plug 'zhimsel/vim-stay'
Plug 'Konfekt/FastFold'

"" Misc
""" Start Screen
Plug 'mhinz/vim-startify'
""" Notes
Plug 'vimwiki/vimwiki'
""" Smooth motion
Plug 'Federico-Ciuffardi/comfortable-motion.vim'
""" Save as sudo
Plug 'lambdalisue/suda.vim'
""" Root on porjects
Plug 'airblade/vim-rooter'
""" images
Plug 'edluffy/hologram.nvim'
""" tabs
Plug 'kyazdani42/nvim-web-devicons'
Plug 'romgrk/barbar.nvim'
""" better jumplist
call plug#end()
"}}}

"""""""""""""
" Comentary "
"""""""""""""
"{{{
autocmd FileType vimwiki setlocal commentstring=<!---\ %s\ -->
"}}}

""""""""""
" Rooter "
""""""""""
"{{{
let g:rooter_targets = '*'
let g:rooter_patterns = ['.git']
"}}}

""""""""""""""
" Easymotion "
""""""""""""""
"{{{
map \ <Plug>(easymotion-prefix)
"}}}

""""""""""""
" Startify "
""""""""""""
"{{{

let g:startify_lists = [
      \ { 'type': 'dir',       'header': [ '   ' .getcwd(),'' ,'   Recent Files '] },
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]

"}}}

""""""""""""""""""""
" Markdown preview "
""""""""""""""""""""
"{{{

" set to 1, nvim will open the preview window after entering the markdown buffer
" default: 0
let g:mkdp_auto_start = 0

" set to 1, the nvim will auto close current preview window when change
" from markdown buffer to another buffer
" default: 1
let g:mkdp_auto_close = 1

" set to 1, the vim will refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = 0

" set to 1, the MarkdownPreview command can be use for all files,
" by default it can be use in markdown file
" default: 0
let g:mkdp_command_for_global = 0

" set to 1, preview server available to others in your network
" by default, the server listens on localhost (127.0.0.1)
" default: 0
let g:mkdp_open_to_the_world = 0

" use custom IP to open preview page
" useful when you work in remote vim and preview on local browser
" more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
" default empty
let g:mkdp_open_ip = ''

" specify browser to open preview page
" default: ''
let g:mkdp_browser = ''

" set to 1, echo preview page url in command line when open preview page
" default is 0
let g:mkdp_echo_preview_url = 0

" a custom vim function name to open preview page
" this function will receive url as param
" default is empty
let g:mkdp_browserfunc = ''

" options for markdown render
" mkit: markdown-it options for render
" katex: katex options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: if disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: mean the cursor position alway show at the middle of the preview page
"   top: mean the vim top viewport alway show at the top of the preview page
"   relative: mean the cursor position alway show at the relative positon of the preview page
" hide_yaml_meta: if hide yaml metadata, default is 1
" sequence_diagrams: js-sequence-diagrams options
" content_editable: if enable content editable for preview page, default: v:false
" disable_filename: if disable filename header for preview page, default: 0
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0
    \ }

" use a custom markdown style must be absolute path
" like '/Users/username/markdown.css' or expand('~/markdown.css')
let g:mkdp_markdown_css = ''

" use a custom highlight style must absolute path
" like '/Users/username/highlight.css' or expand('~/highlight.css')
let g:mkdp_highlight_css = ''

" use a custom port to start server or random for empty
let g:mkdp_port = ''

" preview page title
" ${name} will be replace with the file name
let g:mkdp_page_title = '「${name}」'

" recognized filetypes
" these filetypes will have MarkdownPreview... commands
let g:mkdp_filetypes = ['markdown']

" nmap <C-m> <Plug>MarkdownPreviewToggle

"}}}

""""""""""""""""
" vim-surround "
""""""""""""""""
"{{{

vmap ' S

"}}}

""""""""""""""""""""""
" confortable motion "
""""""""""""""""""""""
"{{{
let g:comfortable_motion_no_default_key_mappings = 1
nnoremap <silent> <C-d> :call comfortable_motion#flick(100)<CR>
nnoremap <silent> <C-u> :call comfortable_motion#flick(-100)<CR>

" merged with coc scroll
" nnoremap <silent> <C-f> :call comfortable_motion#flick(200)<CR>
" nnoremap <silent> <C-b> :call comfortable_motion#flick(-200)<CR>
let g:comfortable_motion_friction = 165.0
let g:comfortable_motion_air_drag = 1.0
"}}}

"""""""""""""""""""""
" FastFold and Fold "
"""""""""""""""""""""
"{{{

" no nested folds
set foldnestmax=1

" default to marks
set foldmethod=marker

" unfold on jump
set foldopen+=block,hor,insert,jump,mark,search,tag,undo
" set foldclose

" set the fold method by filename
autocmd BufNew,BufRead *.c,*.cpp setlocal foldmethod=indent
autocmd BufNew,BufRead *.py setlocal foldmethod=indent
" autocmd BufNew,BufRead *.md setlocal foldopen=all
" autocmd BufNew,BufRead *.md setlocal foldclose=all
autocmd BufEnter * silent! normal zO

" FastFold base config
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']

" Bindings
"" toggle fold with L or H
nnoremap L zA
nnoremap <LEFT> zc
nnoremap <DOWN> zc
nnoremap <UP> zo
nnoremap <RIGHT> zo
" nnoremap H zA
"" close fold with H and open with L
" nnoremap L zO
" nnoremap H zC

"" fold all with zF and unfold all with zF
nnoremap zU zR
nnoremap zF zM

"}}}

""""""""
" stay "
""""""""
"{{{

set viewoptions=cursor

"}}}

""""""""""""
" undotree "
""""""""""""
"{{{

if has("persistent_undo")
    set undodir=$HOME/.local/share/nvim/undo"
    set undofile
endif
nnoremap <C-Z> :UndotreeToggle<CR>
let g:undotree_WindowLayout = 1
let g:undotree_ShortIndicators = 0
let g:undotree_SetFocusWhenToggle = 1

"}}}

"""""""
" fzf "
"""""""
"{{{

" Config
"" Open on almost full screen
let g:fzf_layout = { 'window': { 'width': 1, 'height': 1 } }
let g:fzf_buffers_jump = 1

"" BLines with preview
command! -bang -nargs=* BLines
    \ call fzf#vim#grep(
    \   'rg --with-filename --column --line-number --no-heading --smart-case . '.fnameescape(expand('%:p')), 1,
    \   fzf#vim#with_preview({'options': '--keep-right --delimiter : --nth 4.. --preview "bat -p --color always {}"'}, 'right:60%' ))

" command! -bang -nargs=* Rg
"   \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1,
"   \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

"" Bindings
let g:fzf_action = {
  \ 'ctrl-h': 'split',
  \ 'ctrl-v': 'vsplit', 
  \ 'ctrl-l': 'e'}

nnoremap <c-g> :GFiles?<cr>

nnoremap <C-P>      :Files<cr>
nnoremap <leader>;  :Commands<cr>
nnoremap <leader>f  :BLines<cr>
nnoremap <leader>F  :Rg<cr>
nnoremap <leader>gf :GFiles<cr>
nnoremap <leader>gc :BCommits<cr>
nnoremap <leader>gC :Commits<cr>
nnoremap <leader>m  :Maps<cr>
nnoremap <leader>?  :Helptags<cr>
nnoremap <leader>b  :Buffers<cr>
nnoremap <c-Space>  :Buffers<cr>

"}}}

""""""""""""""""
" fzf-checkout "
""""""""""""""""
"{{{
let g:fzf_branch_actions = {
      \ 'rebase': {
      \   'prompt': 'Rebase> ',
      \   'execute': 'echo system("{git} rebase {branch}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-r',
      \   'required': ['branch'],
      \   'confirm': v:false,
      \ },
      \ 'track': {
      \   'prompt': 'Track> ',
      \   'execute': 'echo system("{git} checkout --track {branch}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-t',
      \   'required': ['branch'],
      \   'confirm': v:false,
      \ },
      \ 'diff': {
      \   'prompt': 'Diff> ',
      \   'execute': 'Git diff {branch}',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-f',
      \   'required': ['branch'],
      \   'confirm': v:false,
      \ },
      \}
nnoremap <leader>gb :GBranch<cr>

"}}}

"""""""
" coc "
"""""""
"{{{

"" coc extensions
let g:coc_global_extensions = [
      \ 'coc-explorer',
      \ 'coc-clangd',
      \ 'coc-pyright',
      \ 'coc-vimtex',
      \ 'coc-snippets',
      \ 'coc-sh',
      \ 'coc-tsserver',
      \ 'coc-prettier',
      \ 'coc-eslint',
      \ ]

"" don't give |ins-completion-menu| messages.
set shortmess+=c
"" always show signcolumns
set signcolumn=yes

"" Bindings

nmap <C-e> <Cmd>CocCommand explorer<CR>

""" Use <C-n>, <C-p>, <up> and <down> to navigate completion list: >
inoremap <silent><expr> <C-j> coc#pum#visible() ? coc#pum#next(1) : "\<C-j>"
inoremap <silent><expr> <C-k> coc#pum#visible() ? coc#pum#prev(1) : "\<C-k>"
inoremap <silent><expr> <down> coc#pum#visible() ? coc#pum#next(0) : "\<down>"
inoremap <silent><expr> <up> coc#pum#visible() ? coc#pum#prev(0) : "\<up>"

""" Use <PageDown> and <PageUp> to scroll:
inoremap <silent><expr> <PageDown> coc#pum#visible() ? coc#pum#scroll(1) : "\<PageDown>"
inoremap <silent><expr> <PageUp> coc#pum#visible() ? coc#pum#scroll(0) : "\<PageUp>"

""" accept complete trigger
inoremap <silent><expr> <c-space> coc#refresh()

""" navigate diagnostics
nmap <silent> [e <Plug>(coc-diagnostic-prev)
nmap <silent> ]e <Plug>(coc-diagnostic-next)
nmap <silent> ge <Plug>(coc-diagnostic-next)

""" remap keys for gotos
nmap <silent> gd <plug>(coc-definition)
nmap <silent> gy <plug>(coc-type-definition)
nmap <silent> gi <plug>(coc-implementation)

""" use <leader>d for show documentation in preview window
nnoremap <silent> <leader>d :call <sid>show_documentation()<cr>

function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

""" Highlight the symbol and its references when holding the cursor.
" autocmd CursorHold * silent call CocActionAsync('highlight')

""" Get references.
nmap <leader>r :execute "normal \<Plug>(coc-references)"<CR>:set cmdheight=1<CR>
nmap gr :execute "normal \<Plug>(coc-references)"<CR>:set cmdheight=1<CR>

""" Symbol renaming.
nmap <leader>R <Plug>(coc-rename)

" Formatting selected code.
nnoremap <expr> = CocHasProvider('format') ? "<Plug>(coc-format-selected)" : "="
xnoremap <expr> = CocHasProvider('format') ? "<Plug>(coc-format-selected)" : "="
vnoremap <expr> = CocHasProvider('format') ? "<Plug>(coc-format-selected)" : "="

""" Remap <C-d> and <C-u> for scroll float windows/popups.
nmap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : ":call comfortable_motion#flick(200)<CR>"
nmap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : ":call comfortable_motion#flick(-200)<CR>"
imap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
imap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vmap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : ":call comfortable_motion#flick(200)<CR>"
vmap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : ":call comfortable_motion#flick(-200)<CR>"

""" Mappings for CoCList
"""" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
"""" Show all diagnostics.
nnoremap <silent><nowait> <space>e  :<C-u>CocList diagnostics<cr>
"""" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
"""" Manage extensions.
nnoremap <silent><nowait> <space>cx  :<C-u>CocList extensions<cr>
"""" Show commands.
nnoremap <silent><nowait> <space>cc  :<C-u>CocList commands<cr>
"""" Do default action for next item.
nnoremap <silent><nowait> <space>cj  :<C-u>CocNext<CR>
"""" Do default action for previous item.
nnoremap <silent><nowait> <space>ck  :<C-u>CocPrev<CR>
"""" Resume latest coc list.
nnoremap <silent><nowait> <space>cr  :<C-u>CocListResume<CR>

""" close hover
nmap <silent><Esc> :call coc#float#close_all() <CR>
nmap <silent><C-C> :call coc#float#close_all() <CR>

"}}}

""""""""""""""""
" coc explorer "
""""""""""""""""
"{{{

" :nnoremap <C-E> :CocCommand explorer<CR>
" autocmd BufEnter * if (winnr("$") == 1 &&  &filetype == 'coc-explorer') | q | endif

"}}}

""""""""""
" vimtex "
""""""""""
"{{{

let g:vimtex_quickfix_ignore_filters = [
      \ 'Underfull',
      \ 'Overfull',
      \ 'Package beamerthememetropolis',
      \ 'Unused global option',
      \ 'Package hyperref Warning: Token not allowed in a PDF string (Unicode):',
      \]

" Compile .tex
autocmd BufEnter *.tex VimtexCompile
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_enabled = 0

"}}}

"""""""""""
" airline "
"""""""""""
"{{{

let g:airline_powerline_fonts = 0
let g:airline#extensions#hunks#enabled=0
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_min_count =2
let g:airline#extensions#whitespace#enabled = 0

let g:airline#extensions#coc#enabled = 1

"}}}

"""""""""""""
" gitgutter "
"""""""""""""
"{{{

set updatetime=100
let g:gitgutter_highlight_linenrs = 1
nmap <leader>gp <Plug>(GitGutterPreviewHunk)

"}}}

"""""""""""
" theming "
"""""""""""
"{{{

set t_Co=256
set t_ut=
colorscheme codedark
set noshowmode

let t:is_transparent = 0
function! Toggle_transparent_background()
  if t:is_transparent == 0
    hi Normal guibg=#000000 ctermbg=234
    "hi NonText guibg=#000000 ctermbg=black    
    let t:is_transparent = 1
  else
    hi Normal guibg=NONE ctermbg=NONE
    let t:is_transparent = 0
  endif
endfunction
nnoremap <C-t> :call Toggle_transparent_background()<CR>

" neovide bg
hi Normal guibg=#1E1E1E
highlight Folded gui=bold guibg=#1E1E1E guifg=#5E5E5E


" coc
hi CocSemClass ctermfg=43 ctermbg=NONE
"}}}

"""""""""""
" vimwiki "
"""""""""""
"{{{

let g:vimwiki_list = [{'path': '~/.local/share/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]

hi VimwikiHeader1 cterm=bold ctermfg=39
hi VimwikiHeader2 cterm=bold ctermfg=75
hi VimwikiHeader3 cterm=bold ctermfg=81
hi VimwikiHeader4 cterm=bold ctermfg=117
hi VimwikiHeader5 cterm=bold ctermfg=159
hi VimwikiHeader6 cterm=bold ctermfg=195

hi VimwikiList cterm=bold ctermfg=255
hi VimwikiHeaderChar cterm=bold ctermfg=252

" hi VimwikiLink cterm=underline ctermfg=195 guifg=#52B6FF gui=underline

let g:vimwiki_folding = 'custom'

command TODO :F TODO ~/.local/share/vimwiki/* <cr>

let g:vimwiki_listsyms = ' 🕙.x'
let g:vimwiki_markdown_link_ext = 1
"}}}

"""""""""
" Maps "
"""""""""
"{{{
command! -nargs=1 -complete=file Diff :vertical diffsplit <args>
" taskell
command! Taskell :terminal 'taskell' '%:p:h/tasks.md'
autocmd TermOpen * startinsert
autocmd TermClose * :bd
nnoremap <leader>t :Taskell<CR>

" Copy Cut Paste
vnoremap <C-C> "+y
vnoremap <C-X> "+x
nnoremap <C-V> "+gP
inoremap <C-V> <C-O>"+P
"" preserve clipboard on pasting
vnoremap p     pgvy
vnoremap P     Pgvy
vnoremap <C-V> Pgvy

" Save
function! Save()
  if &readonly
    silent! execute "SudaWrite"
  else
    silent! execute "w"
  end
endfunction

noremap <silent> <C-S> :call Save()<CR>
inoremap <silent> <C-S> <C-O>:call Save()<CR>

" Console like bindings
inoremap <C-A> <C-O>^i
inoremap <C-E> <C-O>$a
inoremap <C-C> <ESC>

" double esc removes hl
nmap <ESC><ESC> :silent! nohl<CR>

" splits
nmap <silent> <C-w>- :sp<CR>
nmap <silent> <C-w>\ :vsp<CR>

" correct next
nmap zz ]sz=

"disable not used bindings on netrw
augroup FiletypeSpecificMappings
    autocmd FileType netrw unmap <buffer> qL
    autocmd FileType netrw unmap <buffer> qF
    autocmd FileType netrw unmap <buffer> qf
    autocmd FileType netrw unmap <buffer> qb
augroup END

"}}}

"""""""
" GUI "
"""""""
"{{{
let g:neovide_cursor_antialiasing=v:true
let g:neovide_refresh_rate=60
let g:neovide_transparency=0.94

set guifont=FiraCode\ Nerd\ Font\ Mono:h13
nnoremap <silent> <C-+> :let &guifont = substitute(
 \ &guifont,
 \ ':h\zs\d\+',
 \ '\=eval(submatch(0)+1)',
 \ '')<CR>
nnoremap <silent> <C-_> :let &guifont = substitute(
 \ &guifont,
 \ ':h\zs\d\+',
 \ '\=eval(submatch(0)-1)',
 \ '')<CR>
nnoremap <silent> <C-)> :let &guifont = substitute(
 \ &guifont,
 \ ':h\zs\d\+',
 \ '\=eval(13)',
 \ '')<CR>
"}}}

"""""""""""""""""""
" conflict marker "
"""""""""""""""""""
"{{{

" disable the default highlight group
let g:conflict_marker_highlight_group = ''

" Include text after begin and end markers
let g:conflict_marker_begin = '^<<<<<<< \@='
let g:conflict_marker_common_ancestors = '^||||||| .*$'
let g:conflict_marker_separator = '^=======$'
let g:conflict_marker_end   = '^>>>>>>> \@='

highlight ConflictMarkerBegin ctermbg=34 
highlight ConflictMarkerOurs ctermbg=22  
highlight ConflictMarkerTheirs ctermbg=27 
highlight ConflictMarkerEnd ctermbg=39 
highlight ConflictMarkerCommonAncestorsHunk ctermbg=yellow

"}}}

""""""""""
" BarBar "
""""""""""
"{{{

" Move to previous/next
nnoremap <silent>    K <Cmd>BufferPrevious<CR>
nnoremap <silent>    J <Cmd>BufferNext<CR>
" Re-order to previous/next
nnoremap <silent>    <Up> <Cmd>BufferMovePrevious<CR>
nnoremap <silent>    <Down> <Cmd>BufferMoveNext<CR>
" Pin/unpin buffer
nnoremap <silent>    <A-p> <Cmd>BufferPin<CR>
" Close buffer
" nnoremap <silent>    q <Cmd>BufferClose<CR>
set confirm
function! CondQuit()
  if len(getbufinfo({'buflisted':1})) == 1
    execute "q"
  else
    if len(tabpagebuflist()) > 1
      execute "q"
    else
      BufferClose
    endif
  endif
endfunction
if !exists('g:vscode')
  nnoremap <silent> q :call CondQuit()<CR>
endif

" let bufferline = get(g:, 'bufferline', {})
" let bufferline.auto_hide = v:true
" let bufferline.animation = v:false

hi BufferCurrentSign ctermfg=39
hi BufferVisible ctermfg=242
hi BufferInactive ctermfg=240 ctermbg=235

"}}}
