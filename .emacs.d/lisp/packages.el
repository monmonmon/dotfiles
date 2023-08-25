(require 'package)
;(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives  '("marmalade" . "https://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
;(package-initialize) ;; Warning (package): Unnecessary call to ‘package-initialize’ in init file

;; refresh package info
;(package-refresh-contents)

; ;; インストールするパッケージ
; (defvar my/favorite-packages
;   '(
;     ;; for auto-complete
;     auto-complete fuzzy popup pos-tip
;
;     ;; buffer utils
;     popwin elscreen yascroll buffer-move
;
;     ;; flymake
;     flycheck flymake-jslint
;
;     ;; python
;     jedi
;
;     ;; helm
;     helm
;
;     ;; git
;     magit git-gutter
;
; 	;; slim
; 	slim-mode
;     ))
;
; ;; my/favorite-packagesからインストールしていないパッケージをインストール
; (dolist (package my/favorite-packages)
;   (unless (package-installed-p package)
;     (package-install package)))
