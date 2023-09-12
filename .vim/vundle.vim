set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'Shougo/vimproc.vim' " 非同期実行
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'digitaltoad/vim-pug'
Plugin 'slim-template/vim-slim'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'ap/vim-css-color'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'mattn/webapi-vim'
Plugin 'prettier/vim-prettier'
Plugin 'Quramy/tsuquyomi'
Plugin 'leafgarland/typescript-vim'
Plugin 'peitalin/vim-jsx-typescript'
" エラー出るようになったからコメントアウト
" Plugin 'Quramy/vim-js-pretty-template'
Plugin 'jason0x43/vim-js-indent'
Plugin 'pechorin/any-jump.vim'

"" theme
Plugin 'w0ng/vim-hybrid'
Plugin 'chriskempson/vim-tomorrow-theme'

call vundle#end()
filetype plugin indent on    " required

""" configurations

" emmet-vim
Plugin 'mattn/emmet-vim'
let g:user_emmet_mode='i'  " enable only in insert mode
let g:user_emmet_install_global = 0
autocmd FileType html,eruby,php,twig,jade,pug,javascript.jsx,vue,typescript.tsx,typescriptreact EmmetInstall
"let g:user_emmet_leader_key='<Space>'

" html5.vim
Plugin 'othree/html5.vim'
let g:html5_event_handler_attributes_complete = 1
let g:html5_rdfa_attributes_complete = 1
let g:html5_microdata_attributes_complete = 1
let g:html5_aria_attributes_complete = 1

" vim-go
"Plugin 'fatih/vim-go'
"let g:go_fmt_command = "goimports"

" open-browser.vim
Plugin 'open-browser.vim'
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" " syntastic
" Plugin 'vim-syntastic/syntastic'
" " :SyntasticToggleMode to toggle to passive mode
" if exists('*SyntasticStatuslineFlag')
"     set statusline+=%#warningmsg#
"     set statusline+=%{SyntasticStatuslineFlag()}
"     set statusline+=%*
"     let g:syntastic_mode_map = { 'mode': 'passive',
"         \ 'active_filetypes': [],
"         \ 'passive_filetypes': ['html'] }
"     let g:syntastic_always_populate_loc_list = 1
"     let g:syntastic_auto_loc_list = 1
"     let g:syntastic_javascript_checkers = ['eslint']
"     let g:syntastic_typescript_tsc_fname = ''
" endif

" " elm-vim
" Plugin 'elmcast/elm-vim'
" " https://github.com/ElmCast/elm-vim
" let g:elm_syntastic_show_warnings = 1

" " vim-templates
" Plugin 'tibabit/vim-templates'
" let g:tmpl_search_paths = ['~/lib/templates']
" let g:tmpl_author_email = 'ymdsmn@gmail.com'
" let g:tmpl_author_name = 'Simon Yamada'
" let g:tmpl_license = 'MIT'

" vim-vue
Plugin 'posva/vim-vue'
" syntax highlight が死ぬのを防ぐ
autocmd FileType vue syntax sync fromstart

" nerdcommenter
Plugin 'scrooloose/nerdcommenter'
let g:NERDSpaceDelims = 1 " Add spaces after comment delimiters by default
let g:NERDCompactSexyComs = 1 " Use compact syntax for prettified multi-line comments
let g:NERDDefaultAlign = 'left' " Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDAltDelims_java = 1 " Set a language to use its alternate delimiters by default
let g:NERDCommentEmptyLines = 1 " Allow commenting and inverting empty lines
let g:NERDTrimTrailingWhitespace = 1 " Enable trimming of trailing whitespace when uncommenting
" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1
" " Add your own custom formats or override the defaults
" let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

let g:NERDCreateDefaultMappings = 0
nmap <leader>c <plug>NERDCommenterComment
xmap <leader>c <plug>NERDCommenterComment
nmap <leader>i <plug>NERDCommenterInvert
xmap <leader>i <plug>NERDCommenterInvert
nmap <leader>u <plug>NERDCommenterUncomment
xmap <leader>u <plug>NERDCommenterUncomment

" nerdcommenter x vue
let g:ft = ''
function! NERDCommenter_before()
  if &ft == 'vue'
    let g:ft = 'vue'
    let stack = synstack(line('.'), col('.'))
    if len(stack) > 0
      let syn = synIDattr((stack)[0], 'name')
      if len(syn) > 0
        exe 'setf ' . substitute(tolower(syn), '^vue_', '', '')
      endif
    endif
  endif
endfunction
function! NERDCommenter_after()
  if g:ft == 'vue'
    setf vue
    let g:ft = ''
  endif
endfunction

" " vim-expand-region
" Plugin 'terryma/vim-expand-region'
" map v <Plug>(expand_region_expand)
" map <C-v> <Plug>(expand_region_shrink)

" vim-lsc
Plugin 'natebosch/vim-lsc'
let g:lsc_auto_map = v:true
"let g:lsc_server_commands = {'dart': 'dart_language_server'}

" dart
Plugin 'dart-lang/dart-vim-plugin'
Plugin 'natebosch/vim-lsc-dart'
let dart_html_in_string=v:true
let dart_style_guide = 2
let dart_format_on_save = 1

" " ALE
" Plugin 'dense-analysis/ale'
" let g:ale_fixers = {
" \  'javascript': ['prettier', 'eslint'],
" \  'vue': ['prettier', 'eslint'],
" \  'css': ['stylelint'],
" \  'scss': ['stylelint'],
" \}
" " let g:ale_fix_on_save = 1
" " let g:ale_sign_error = ''
" " let g:ale_sign_warning = ''
" " let g:airline#extensions#ale#open_lnum_symbol = '('
" " let g:airline#extensions#ale#close_lnum_symbol = ')'
" " let g:ale_echo_msg_format = '[%linter%]%code: %%s'
" " highlight link ALEErrorSign Tag
" " highlight link ALEWarningSign StorageClass
" " Ctrl + kで次の指摘へ、Ctrl + jで前の指摘へ移動
" execute "set <M-j>=\ej"
" nmap <silent> <M-k> <Plug>(ale_previous_wrap)
" execute "set <M-k>=\ek"
" nmap <silent> <M-j> <Plug>(ale_next_wrap)

" vim-easy-align
Plugin 'junegunn/vim-easy-align'
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
