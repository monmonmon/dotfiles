filetype plugin indent on

au FileType c,cpp,perl :set cindent
au FileType javascript,javascript.jsx setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
au FileType typescript,typescript.tsx,typescriptreact setlocal ts=2 sts=2 sw=2 expandtab
au FileType coffee setlocal ts=2 sts=2 sw=2 expandtab
au FileType json setlocal ts=2 sts=2 sw=2 expandtab
au FileType html setlocal ts=2 sts=2 sw=2 expandtab
au FileType jade setlocal ts=2 sts=2 sw=2 expandtab
au FileType pug setlocal ts=2 sts=2 sw=2 expandtab
au FileType css setlocal ts=2 sts=2 sw=2 expandtab
au FileType scss setlocal ts=2 sts=2 sw=2 expandtab
au FileType sass setlocal ts=2 sts=2 sw=2 expandtab
au FileType slim setlocal ts=2 sts=2 sw=2 expandtab
au FileType haml setlocal ts=2 sts=2 sw=2 expandtab
au FileType swift setlocal ts=4 sts=4 sw=4 noexpandtab
au FileType ruby setlocal ts=2 sts=2 sw=2 expandtab
au FileType eruby setlocal ts=2 sts=2 sw=2 expandtab
au FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
au FileType cucumber setlocal ts=2 sts=2 sw=2 expandtab
au FileType twig setlocal ts=2 sts=2 sw=2 expandtab
au FileType vue setlocal ts=2 sts=2 sw=2 expandtab
au FileType php setlocal ts=2 sts=2 sw=2 expandtab
au FileType elm setlocal ts=2 sts=2 sw=2 expandtab
au FileType go setlocal ts=4 sts=4 sw=4 noexpandtab
au FileType java setlocal ts=2 sts=2 sw=2 expandtab
au FileType objc setlocal ts=2 sts=2 sw=2 expandtab

au BufRead,BufNewFile *.rst set filetype=text
au BufRead,BufNewFile *.coffee set filetype=coffee
au BufRead,BufNewFile *.coffee.erb set filetype=coffee
au BufRead,BufNewFile *.jbuilder set filetype=ruby
au BufRead,BufNewFile *.jb set filetype=ruby
au BufRead,BufNewFile *.thor set filetype=ruby
au BufRead,BufNewFile *.axlsx set filetype=ruby
au BufRead,BufNewFile *.js.erb set filetype=javascript
au BufRead,BufNewFile *.csv.erb set filetype=ruby
au BufRead,BufNewFile *.css.erb set filetype=css
au BufRead,BufNewFile *.scss.erb set filetype=scss
au BufRead,BufNewFile *.sass.erb set filetype=sass
au BufRead,BufNewFile *.jade set filetype=jade
au BufRead,BufNewFile *.es6 set filetype=javascript
au BufRead,BufNewFile *.twig set filetype=html
"au BufRead,BufNewFile *.feature set filetype=gherkin
"au! Syntax gherkin source ~/.vim/cucumber.vim
au BufRead,BufNewFile tsconfig.json set filetype=javascript
au BufRead,BufNewFile *.tsx,*.jsx set filetype=typescriptreact
au BufRead,BufNewFile .profile,*.sh,*.bash set filetype=bash
au BufRead,BufNewFile Dockerfile* set filetype=dockerfile

" 拡張子に対応するテンプレートで新規ファイルを初期化
au BufNewFile *.html 0r $HOME/lib/template.html
au BufNewFile *.vue 0r $HOME/lib/template.vue
"for ext in ['c', 'cpp', 'feature', 'html', 'jade', 'java', 'js', 'm', 'md', 'php', 'pl', 'py', 'rb', 'sh', 'slim', 'swift', 'tex', 'xhtml']
"    au BufNewFile '*.'.ext 0r $HOME.'/lib/template.'.ext
"endfor
