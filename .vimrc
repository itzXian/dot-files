" vim:sts=24:ts=24:noet

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/plugged')

" Look and Feel
Plug 'Yggdroot/indentLine'
Plug 'vim-airline/vim-airline'
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#formatter = 'unique_tail'
  let g:airline_powerline_fonts = 0
  let g:airline_symbols_ascii = 1
  let g:airline_theme = 'dark'
  let g:airline_section_z = '
    \%l
    \/
    \%L
    \%{g:airline_symbols.maxlinenr}
    \ 
    \%v
    \'
  let g:airline_mode_map = {
    \ '__'     : '-',
    \ 'c'      : 'C',
    \ 'i'      : 'I',
    \ 'ic'     : 'I',
    \ 'ix'     : 'I',
    \ 'n'      : 'N',
    \ 'multi'  : 'M',
    \ 'ni'     : 'N',
    \ 'no'     : 'N',
    \ 'R'      : 'R',
    \ 'Rv'     : 'R',
    \ 's'      : 'S',
    \ 'S'      : 'S',
    \ ''     : 'S',
    \ 't'      : 'T',
    \ 'v'      : 'V',
    \ 'V'      : 'V',
    \ ''     : 'V',
    \ }
  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
    let g:airline_symbols.maxlinenr = ' Ln'
    let g:airline_symbols.whitespace = '■'
    let g:airline#extensions#whitespace#trailing_format = '[%s]'
    let b:airline_whitespace_checks =
      \  [ 'indent', 'trailing', 'long', 'mixed-indent-file', 'conflicts' ]

  endif
Plug 'edkolev/tmuxline.vim'
  let g:tmuxline_powerline_separators = 0
  let g:tmuxline_preset = {
    \'a'    : '#S',
    \'win'  : '#I: #W',
    \'cwin' : '#W',
    \'z'    : '#(whoami)',
    \'x'    : '%a,%H:%M'
  \}
" Behavior
Plug '907th/vim-auto-save'
  let g:auto_save=1
  let g:auto_save_no_updatetime = 1
  let g:auto_save_in_insert_mode = 0
  let g:auto_save_events = ["InsertLeave", "TextChanged"]
Plug 't9md/vim-choosewin'
  nm  - <Plug>(choosewin)
Plug 'majutsushi/tagbar'
  no  <C-k>g :TagbarToggle<CR>
Plug 'justinmk/vim-sneak'
  let g:sneak#label = 1
" Syntax and Highlight
Plug 'kelwin/vim-smali', { 'for': 'smali' }
"Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'mhinz/vim-startify'
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'nikvdp/ejs-syntax', { 'for': '*.ejs' }
Plug 'lfv89/vim-interestingwords'
  no <silent> <C-k>k :call InterestingWords('n')<CR>
  no <silent> <C-k>K :call UncolorAllWords()<CR>
Plug 'dart-lang/dart-vim-plugin', { 'for': 'dart' }
  let dart_html_in_string=v:true
  let dart_style_guide=2
" Completion
"Plug 'prabirshrestha/vim-lsp'
"Plug 'mattn/vim-lsp-settings'
"Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'prabirshrestha/asyncomplete-lsp.vim'
"Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
"Plug 'jiangmiao/auto-pairs'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = [
  \'coc-json',
  \'coc-git',
  \'coc-markdownlint',
\]
let g:mapleader = ','
  nmap <silent><nowait> Cc :<C-u>CocCommand<cr>
  " https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim

  " May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
  " utf-8 byte sequence
  set encoding=utf-8
  " Some servers have issues with backup files, see #649
  set nobackup
  set nowritebackup

  " Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
  " delays and poor user experience
  set updatetime=300

  " Always show the signcolumn, otherwise it would shift the text each time
  " diagnostics appear/become resolved
  set signcolumn=yes

  " Use tab for trigger completion with characters ahead and navigate
  " NOTE: There's always complete item selected by default, you may want to enable
  " no select by `"suggest.noselect": true` in your configuration file
  " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  " other plugin before putting this into your config
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
  " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
  nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
  nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

  " GoTo code navigation
  nmap <silent><nowait> gd <Plug>(coc-definition)
  nmap <silent><nowait> gy <Plug>(coc-type-definition)
  nmap <silent><nowait> gi <Plug>(coc-implementation)
  nmap <silent><nowait> gr <Plug>(coc-references)

  " Use K to show documentation in preview window
  nnoremap <silent> K :call ShowDocumentation()<CR>

  function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
      call CocActionAsync('doHover')
    else
      call feedkeys('K', 'in')
    endif
  endfunction

  " Highlight the symbol and its references when holding the cursor
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Symbol renaming
  nmap <leader>rn <Plug>(coc-rename)

  " Formatting selected code
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s)
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  augroup end

  " Applying code actions to the selected code block
  " Example: `<leader>aap` for current paragraph
  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap keys for applying code actions at the cursor position
  nmap <leader>ac  <Plug>(coc-codeaction-cursor)
  " Remap keys for apply code actions affect whole buffer
  nmap <leader>as  <Plug>(coc-codeaction-source)
  " Apply the most preferred quickfix action to fix diagnostic on the current line
  nmap <leader>qf  <Plug>(coc-fix-current)

  " Remap keys for applying refactor code actions
  nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
  xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
  nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

  " Run the Code Lens action on the current line
  nmap <leader>cl :CocCommand

  " Map function and class text objects
  " NOTE: Requires 'textDocument.documentSymbol' support from the language server
  xmap if <Plug>(coc-funcobj-i)
  omap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap af <Plug>(coc-funcobj-a)
  xmap ic <Plug>(coc-classobj-i)
  omap ic <Plug>(coc-classobj-i)
  xmap ac <Plug>(coc-classobj-a)
  omap ac <Plug>(coc-classobj-a)

  " Remap <C-f> and <C-b> to scroll float windows/popups
  if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  endif

  " Use CTRL-S for selections ranges
  " Requires 'textDocument/selectionRange' support of language server
  nmap <silent> <C-s> <Plug>(coc-range-select)
  xmap <silent> <C-s> <Plug>(coc-range-select)

  " Add `:Format` command to format current buffer
  command! -nargs=0 Format :call CocActionAsync('format')

  " Add `:Fold` command to fold current buffer
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)

  " Add `:OR` command for organize imports of the current buffer
  command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

  " Add (Neo)Vim's native statusline support
  " NOTE: Please see `:h coc-status` for integrations with external plugins that
  " provide custom statusline: lightline.vim, vim-airline
  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

  " Mappings for CoCList
  " Show all diagnostics
  nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
  " Manage extensions
  nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
  " Show commands
  nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
  " Find symbol of current document
  nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
  " Search workspace symbols
  nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
  " Do default action for next item
  nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
  " Do default action for previous item
  nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
  " Resume latest coc list
  nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


call plug#end()

no  <C-k>q      :qa!             <CR>

no  <C-k>t      :term            <CR>
ino <C-k>t <Esc>:term            <CR>
tno <C-k>t <C-w>:term            <CR>

no  <C-k>T      :vert term       <CR>
ino <C-k>T <Esc>:vert term       <CR>
tno <C-k>T <C-w>:vert term       <CR>

no  <C-k>R      :source $MYVIMRC <CR>
ino <C-k>R <Esc>:source $MYVIMRC <CR>
tno <C-k>R <C-w>:source $MYVIMRC <CR>

no  <C-k>n      :new 
ino <C-k>n <Esc>:new 
tno <C-k>n <C-w>:new 

no  <C-k>N      :vnew 
ino <C-k>N <Esc>:vnew 
tno <C-k>N <C-w>:vnew 

no  <C-k>e      :call Netrw()    <CR>
ino <C-k>e <Esc>:call Netrw()    <CR>
tno <C-k>e <C-w>:call Netrw()    <CR>

  let g:netrw_banner=0
  let g:netrw_sizestyle="H"
  let g:netrw_liststyle=3 "<C-l> issue
  let g:netrw_winsize=0
  let g:netrw_bufsettings="wrap"

function! Netrw()
  if bufwinnr("NetrwTreeListing") > 0
    :Lex
  else
    :Lex
    :40 wincmd |
  endif
endfunction


set fencs=ucs-bom,utf-8
if ! has('win32')
  set fencs+=euc-cn,big5,euc-tw,
    \sjis,euc-jp,
    \euc-kr
else
  set fencs+=ucs-bom,utf-8,
    \cp932,
    \cp936,cp950
endif
set fencs+=cp949,latin1
set fenc=utf-8
set enc=utf-8

set et
set shiftwidth=4
set ts=8
set sts=4

  no  <C-k><Tab>      :set sts=
  ino <C-k><Tab> <Esc>:set sts=

  no  <C-k>C          :set cc=
  ino <C-k>C     <Esc>:set cc=

set t_Co=16
syntax on
  no  <C-k>S      :set syn=
  ino <C-k>S <Esc>:set syn=
  au! BufReadPost *.dict.yaml |
    \setl noet                 |
    \setl shiftwidth=0         |
    \setl ts=16                |
    \setl sts=16
  au! BufReadPost *.arb |
    \setl syn=json
colo default
  set bg=dark
  hi Folded	ctermfg=8	ctermbg=NONE
  hi LineNr	ctermfg=8	ctermbg=NONE
  hi Search	ctermfg=234	ctermbg=11
  hi ColorColumn	ctermfg=8	ctermbg=234
  hi MatchParen	ctermfg=6	ctermbg=234
  hi DiffAdd	ctermfg=2	ctermbg=234
  hi DiffDelete	ctermfg=234	ctermbg=234
  hi DiffChange	ctermfg=7	ctermbg=NONE
  hi DiffText	ctermfg=3	ctermbg=234
  hi VertSplit	cterm=NONE	ctermfg=234	ctermbg=234
  hi Visual	cterm=reverse
  hi StatusLine	cterm=NONE	ctermbg=234
  hi StatusLineNC	cterm=NONE	ctermfg=234	ctermbg=234
  hi ToolbarLine	cterm=NONE
  set cursorline
  hi CursorLine	term=bold	cterm=NONE
  hi CursorLineNr	term=bold	cterm=bold

set directory="~/.vim/swapfiles//,~/tmp,/var/tmp,/tmp"
set hls
  set is
  no  <C-k>c :let @/=""<CR>
  ino <C-k>c <Esc>:let @/=""<CR>
set fdm=indent
set fdl=28
"set nowrap
set signcolumn=auto
set nu
  au! InsertEnter * set rnu
  au! InsertLeave * set nornu
  au! ModeChanged *:[vV\x16]* :set nonu signcolumn=no
  au! ModeChanged [vV\x16]*:* :set nu signcolumn=auto
set listchars=tab:‹-›,trail:■
set list
set wildmenu
set wildmode=longest:list,full
set shm=a
set ch=2
set autoread
"set autochdir
augroup AutoChdirOnce
  autocmd!
  autocmd VimEnter * if argc() > 0 || (has('nvim') && len(v:argv) > 0) | 
        \ cd %:p:h | 
        \ autocmd! AutoChdirOnce VimEnter * 
        \ endif
augroup END
set splitbelow
set splitright
"set bufhidden=wipe
  no gp :bp<CR>
  no gn :bn<CR>
  no gw :bw<CR>
  no gq :q<CR>
  no gb :tabnew 
set so=0

set backspace=indent,eol,start
  set nocindent
  set nosmartindent
  set noautoindent
  set indentexpr=
  filetype indent off
  filetype plugin indent off
set notimeout
set tm=0
set ttimeout
set ttm=-1
 "help map-overview map-commands
  no   <C-c> <Esc> " Normal, Visual, Select, Operator-pending
 "nn   <C-c> <Esc> " Normal
 "vn   <C-c> <Esc> "         Visual, Select
 "xn   <C-c> <Esc> "         Visual
 "snor <C-c> <Esc> "                 Select
 "ono  <C-c> <Esc> "                         Operator-pending
  ino  <C-c> <Esc> " Insert
 "ln   <C-c> <Esc> " Insert, Command-line, Lang-Arg
 "cno  <C-c> <Esc> "         Command-line
 "tno  <C-c> <Esc> " Terminal-Job
"Disable mouse
"set mouse=""
"Enable mouse
set mouse=a

  no   <Up>    <NOP>
  ino  <Up>    <NOP>
  tno  <Up>    <NOP>

  no   <Down>  <NOP>
  ino  <Down>  <NOP>
  tno  <Down>  <NOP>

  no   <Left>  <NOP>
  ino  <Left>  <NOP>
  tno  <Left>  <NOP>

  no   <Right> <NOP>
  ino  <Right> <NOP>
  tno  <Right> <NOP>

  no  <C-f> z+
  ino <C-f> z+
  tno <C-f> z+

  no  <C-b> z^
  ino <C-b> z^
  tno <C-b> z^

  no  z+ <C-f>
  ino z+ <C-f>
  tno z+ <C-f>

  no  z^ <C-b>
  ino z^ <C-b>
  tno z^ <C-b>

function! MoveFile()
  let old_file = expand('%:p')
  let new_file = input('Move to: ', expand('%:p'), 'file')
  if new_file != '' && new_file != old_file
    exec ':saveas ' . new_file
    exec ':silent !rm ' . old_file
    redraw!
  endif
endfunction
no <C-k>m :call MoveFile()<CR>

function! ExecFile()
  if     &filetype == 'sh'
    :!sh     "%:p"
  elseif &filetype == 'python'
    :!python "%:p"
  elseif &filetype == 'javascript'
    :!node   "%:p"
  endif
endfunction
no <C-k>r :call ExecFile()<CR>

function! ScrollBind()
  if &scb == 0
    :set scb
  else
    :set noscb
  endif
endfunction
no <C-k>s :call ScrollBind()<CR>
