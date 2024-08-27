" .vimrc
"
" ↓↓↓参考↓↓↓
"   ボクが2ヶ月間で学んだVimのまとめ - ゆず日記
"   http://d.hatena.ne.jp/Yuzuemon/20110304/1299199079
"   Curiosity Drives Me：今年こそ始める！何度も挫折した人のためのモダンVim再入門
"   http://www.curiosity-drives.me/2012/01/rails.html
"   Vimの全オプション
"   http://www15.ocn.ne.jp/~tusr/vim/options.html
"   vimrc基礎文法最速マスター - 永遠に未完成
"   http://d.hatena.ne.jp/thinca/20100205/1265307642

" Common -------------------------------
filetype off
filetype plugin indent off
set nocompatible                " vi互換モードオフ
syntax on                       " シンタックスカラーリングオン
set background=light            " 背景色の傾向(カラースキームがそれに併せて色の明暗を変えてくれる)
"colorscheme Tomorrow            " color scheme

" File ---------------------------------
set autoread                    " 更新時自動再読込み
set hidden                      " 編集中でも他のファイルを開けるようにする
set nobackup                    " バックアップを取らない
"set confirm                     " バッファが変更されているときエラーにせず保存するかどうか確認を求める
let g:netrw_liststyle=3

" Indent -------------------------------
"   tabstop:                Tab文字を画面上で何文字分に展開するか
"   shiftwidth:             cindentやautoindent時に挿入されるインデントの幅
"   softtabstop:            Tabキー押し下げ時の挿入される空白の量，0の場合はtabstopと同じ，BSにも影響する
set tabstop=4 shiftwidth=4 softtabstop=0
set autoindent smartindent      " 自動インデント，スマートインデント
set expandtab                   " タブは空白に開く

" Assist inputting ---------------------
set backspace=indent,eol,start      " バックスペースで特殊記号も削除可能に
set formatoptions=lmoq              " 整形オプション，マルチバイト系を追加
set whichwrap=b,s,h,l,<,>,[,]       " カーソルを行頭、行末で止まらないようにする
"set clipboard=unnamed,autoselect    " バッファにクリップボードを利用する
set pastetoggle=<F12>               " <F12>キーで'paste'と'nopaste'を切り替える
set nofixendofline                  " ファイル末尾に改行を追加しない
set matchpairs+=<:>
set noeol

" Complement Command -------------------
set wildmenu                        " コマンド補完を強化
set wildmode=list:full              " リスト表示，最長マッチ

" Search -------------------------------
set ignorecase                      " 大文字小文字無視
set smartcase                       " 大文字ではじめたら大文字小文字無視しない
set incsearch                       " インクリメンタルサーチ
set hlsearch                        " 検索文字をハイライト

" View ---------------------------------
set showmatch                       " 括弧の対応をハイライト
set showcmd                         " 入力中のコマンドを表示
set showmode                        " 現在のモードを表示
"set number                          " 画面左に行番号表示
set wrap                            " 画面幅で折り返さない
"set list                            " 不可視文字表示
"set listchars=tab:>.                " 不可視文字の表示方法
set notitle                         " タイトル書き換えない
set scrolloff=0                     " カーソルの上または下に表示する最小限の行数
set scrolljump=8                    " カーソルが画面外に出たときにスクロールする行数の最小値
set display=uhex                    " 印字不可能文字を16進数で表示
set visualbell                      " ビープの代わりにビジュアルベル
set t_vb=                           " ビジュアルベルも無効化
set nostartofline                   " 移動コマンドを使ったとき、行頭に移動しない
set foldmethod=manual

set tags=./tags;,tags;

hi ZenkakuSpace gui=underline guibg=DarkBlue cterm=underline ctermfg=LightBlue " 全角スペースの定義
match ZenkakuSpace /　/             " 全角スペースの色を変更

"set cursorcolumn           " カラムをハイライト
"set cursorline             " カーソル行をハイライト
"augroup cch
"   autocmd! cch
"   autocmd WinLeave * set nocursorline
"   autocmd WinEnter,BufRead * set cursorline
"augroup END
":hi clear CursorLine
":hi CursorLine gui=underline
""hi CursorLine ctermbg=blue guibg=blue

" StatusLine ---------------------------
set laststatus=2                " ステータスラインを2行に
set statusline=%<%f\ #%n%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%y%=%l,%c%V%8P
" statusline for insert mode
let g:hi_insert = 'hi StatusLine gui=None guifg=Black guibg=Yellow cterm=None ctermfg=Black ctermbg=Yellow'

" Charset, Line ending -----------------
set termencoding=utf-8
set encoding=utf-8
set fileencodings=utf-8,cp932,euc-jp,iso-2022-jp
set ffs=unix,dos,mac            " LF, CRLF, CR
if exists('&ambiwidth')
    set ambiwidth=double        " UTF-8の□や○でカーソル位置がずれないようにする
endif

" .vimrc.local
augroup vimrc-local
  autocmd!
  autocmd BufNewFile,BufReadPost * call s:vimrc_local(expand('<afile>:p:h'))
augroup END
function! s:vimrc_local(loc)
  let files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction

" 保存時の処理
function! s:remove_dust()
    if &ft =~ 'gitconfig'
        return
    endif
    "let c = getcharsearch()
    let cursor = getpos('.')
    %s/\s\+$//ge " 保存時に行末の空白を除去する
    call setpos('.', cursor)
    "call histdel('/', -1)
    "call setcharsearch(c)
    unlet cursor
    "unlet c
endfunction
autocmd BufWritePre * call <SID>remove_dust()
" to cancel: autocmd! BufWritePre *

" rsense
" http://cx4a.org/software/rsense/manual.html
"let g:rsenseHome = "/usr/local/lib/rsense-0.3"

" vimdiff
"hi DiffAdd cterm=bold ctermbg=green
hi DiffAdd ctermfg=black ctermbg=2
hi DiffChange ctermfg=white ctermbg=5
hi DiffDelete ctermfg=black ctermbg=6
hi DiffText ctermfg=white ctermbg=4

" mappings
source ~/.vim/map.vim

" filetype
source ~/.vim/ft.vim

" " vundle
" source ~/.vim/vundle.vim

" jetpack
source ~/.vim/jetpack.vim
