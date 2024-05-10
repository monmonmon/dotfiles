" 検索のハイライトをキャンセル
nnoremap <C-L> :nohl<CR><C-L>
" バッファ移動
nnoremap <C-j> :bn<CR>
nnoremap <C-k> :bp<CR>
" vv で行ビジュアルモード
nnoremap vv V
" jk で編集モード離脱
inoremap <silent> jk <ESC>
" 編集モード中の移動
inoremap <C-a> <HOME>
inoremap <C-e> <END>
" * 検索で次の単語にジャンプしない
nnoremap <silent> * :let @/= '\<' . expand('<cword>') . '\>' <bar> set hls <cr>
nnoremap <silent> g* :let @/=expand('<cword>') <bar> set hls <cr>

" 不要なkeymapを無効化
nnoremap <S-k> <Nop>
nnoremap ZQ <Nop>
nnoremap Q <Nop>
vnoremap u <Nop>
vnoremap U <Nop>

" Leader
let mapleader = "\<Space>"
nnoremap <Leader>w :wa<CR>
nnoremap <Leader>d :bd<CR>
nnoremap <Leader>l :ls<CR>
nnoremap <Leader>q :qa<CR>
nnoremap <silent> <Leader>vr :new ~/.vimrc<CR>    " .vimrcを開く
nnoremap <silent> <Leader>r :source ~/.vimrc<CR>  " .vimrcの読み込み

" ウィンドウ関連
" cf. Vimの便利な画面分割＆タブページと、それを更に便利にする方法 - Qiita
" https://qiita.com/tekkoc/items/98adcadfa4bdc8b5a6ca
nnoremap s <Nop>
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap s- :<C-u>q<CR>
" nnoremap sq :<C-u>q<CR>
" nnoremap sQ :<C-u>bd<CR>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap s9 <C-w>-
nnoremap s0 <C-w>+
nnoremap sn gt
nnoremap sp gT
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap s_ <C-w>_
nnoremap so <C-w>o
" nnoremap sw <C-w>w
" nnoremap so <C-w>_<C-w>|
nnoremap st :<C-u>tabnew<CR>
nnoremap sT :<C-u>Unite tab<CR>
nnoremap sb :<C-u>Unite buffer_tab -buffer-name=file<CR>
nnoremap sB :<C-u>Unite buffer -buffer-name=file<CR>
"call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
"call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
"call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
"call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
"call submode#map('bufmove', 'n', '', '>', '<C-w>>')
"call submode#map('bufmove', 'n', '', '<', '<C-w><')
"call submode#map('bufmove', 'n', '', '+', '<C-w>+')
"call submode#map('bufmove', 'n', '', '-', '<C-w>-')
