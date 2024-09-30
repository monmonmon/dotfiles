packadd vim-jetpack
call jetpack#begin()
Jetpack 'tani/vim-jetpack', {'opt': 1} "bootstrap

" realtime linting
" Jetpack 'https://github.com/dense-analysis/ale'

" css中の色名やカラーコードをその色でハイライト
Jetpack 'ap/vim-css-color'

" <Leader>ig でインデントの可視化をトグル
Jetpack 'nathanaelkane/vim-indent-guides'

" nerdcommenter
Jetpack 'scrooloose/nerdcommenter'
let g:NERDSpaceDelims = 1 " Add spaces after comment delimiters by default
let g:NERDCompactSexyComs = 1 " Use compact syntax for prettified multi-line comments
let g:NERDDefaultAlign = 'left' " Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDCommentEmptyLines = 1 " Allow commenting and inverting empty lines
let g:NERDTrimTrailingWhitespace = 1 " Enable trimming of trailing whitespace when uncommenting
let g:NERDCreateDefaultMappings = 0 " デフォルトのmappingをキャンセル
nmap <leader>c <plug>NERDCommenterComment
xmap <leader>c <plug>NERDCommenterComment
nmap <leader>i <plug>NERDCommenterInvert
xmap <leader>i <plug>NERDCommenterInvert
nmap <leader>u <plug>NERDCommenterUncomment
xmap <leader>u <plug>NERDCommenterUncomment

call jetpack#end()