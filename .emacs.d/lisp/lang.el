;;; language major mode & style settings

;; インデントにはスペース使う
;; (setq-default indent-tabs-mode nil)
;; (setq indent-line-function 'indent-relative-maybe)

;; c-style
(load "c-style.el")

; 'sh-mode
(add-hook 'sh-mode-hook
          (lambda()
			(setq tab-width 4)
			(setq sh-basic-offset 4)
			(setq indent-tabs-mode nil)))

;; web-mode
(require 'web-mode)
(set-face-attribute 'web-mode-symbol-face nil :foreground "#FF7400")
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)

; editor-config
;(load "editorconfig")

; javascript-mode
; js2-mode っての試してみる？
(autoload 'javascript-mode "javascript" nil t)
(setq js-indent-level 2)
(setq js-mode-hook
      '(lambda () (progn
                    (set-variable 'indent-tabs-mode nil))))
; M-. がオーバーライドされるのでオーバーライドし返す
(eval-after-load 'js
  '(define-key js-mode-map (kbd "M-.") (lambda () (interactive) (scroll-up 8))))

; html-mode
(add-hook 'html-mode-hook
          (lambda()
            (setq sgml-basic-offset 4)
            (setq indent-tabs-mode nil)))

; php-mode
(autoload 'php-mode "php-mode" "Major mode for php" t)
(add-hook 'php-mode-hook
          (lambda ()
            (c-set-style "stroustrup")
            (setq tab-width 4)
            (setq c-basic-offset 4)				; 基本タブ幅
            (setq indent-tabs-mode nil)			; タブでなくスペースで
            (c-set-offset 'case-label' 4)		; case文
            (c-set-offset 'arglist-intro' 4)	; 引数リストを改行した時：リスト開始
            (c-set-offset 'arglist-cont-nonempty' 4) ; 引数リストを改行した時：リスト途中
            (c-set-offset 'arglist-close' 4)	 ; 引数リストを改行した時：リスト終了
            (setq comment-start "// "
                  comment-end   ""
                  comment-start-skip "// *")
            ))

;; ; css-mode (http://www.garshol.priv.no/download/software/css-mode/doco.html)
;; (autoload 'css-mode "css-mode")
;; (setq cssm-indent-function #'cssm-c-style-indenter)
(setq css-indent-offset 2)
(add-hook 'css-mode-hook
          (lambda()
            (setq indent-tabs-mode nil)))

;; scss-mode
(autoload 'scss-mode "scss-mode")
(setq scss-compile-at-save nil)         ; 保存時自動コンパイルをOFF
(autoload 'sass-mode "sass-mode")

;; less-mode
;; https://github.com/myfreeweb/less-mode
(require 'less-mode)
(setq less-compile-at-save nil)         ; 保存時自動コンパイルをOFF

;; rst-mode
;; http://docutils.sourceforge.net/tools/editors/emacs/rst.el
;; http://ymotongpoo.hatenablog.com/entry/20101106/1289007403
(load "rst.el")
(autoload 'rst-mode "rst-mode" nil t)
(add-hook 'rst-mode-hook '(lambda() (setq indent-tabs-mode nil)))

;; ;; zencoding-mode
;; (require 'zencoding-mode)
;; (add-hook 'sgml-mode-hook 'zencoding-mode)
; (add-hook 'php-mode-hook 'zencoding-mode)
; (add-hook 'web-mode-hook 'zencoding-mode)

;; emmet-mode
(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode)
(add-hook 'html-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook  'emmet-mode)
(add-hook 'web-mode-hook 'emmet-mode)
(add-hook 'php-mode-hook 'emmet-mode)
(add-hook 'rst-mode-hook 'emmet-mode)
(eval-after-load "emmet-mode"
  '(define-key emmet-mode-keymap (kbd "C-j") nil)) ;; C-j は newline のままにしておく
(define-key emmet-mode-keymap (kbd "C-M-j") 'emmet-expand-line) ;; C-i で展開

;; pug-mode
(setq pug-tab-width 2)
(add-hook 'pug-mode-hook
          (lambda()
            (setq indent-tabs-mode nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ruby
;; cf. EmacsでRubyの開発環境をめちゃガチャパワーアップしたまとめ | Futurismo
;; http://futurismo.biz/archives/1295

;; ruby-mode
(setq load-path
	  (append (list "~/.emacs.d/ruby" "~/.emacs.d/ruby/emacs-rails" ) load-path))
;; 空白赤くなるの防ぐ
(add-hook 'ruby-mode-hook (lambda ()
                            (setq show-trailing-whitespace nil)))

;; ruby-block
(require 'ruby-block)
(ruby-block-mode t)
(setq ruby-block-highlight-toggle t)
;; rcodetools
(require 'rcodetools)
(setq rct-find-tag-if-available nil)
(defun ruby-mode-hook-rcodetools ()
  (define-key ruby-mode-map "\M-\C-i" 'rct-complete-symbol)
  (define-key ruby-mode-map "\C-c\C-t" 'ruby-toggle-buffer)
  (define-key ruby-mode-map "\C-c\C-d" 'xmp)
  (define-key ruby-mode-map "\C-c\C-f" 'rct-ri))
(add-hook 'ruby-mode-hook 'ruby-mode-hook-rcodetools)
; ;; anything-rcodetools
; (require 'anything-rcodetools)
; (setq rct-get-all-methods-command "PAGER=cat fri -l")
; (define-key anything-map [(control ?;)] 'anything-execute-persistent-action)
;; smart-compile
(require 'smart-compile)
(define-key ruby-mode-map (kbd "C-c c") 'smart-compile)
(define-key ruby-mode-map (kbd "C-c C-c") (kbd "C-c c C-m"))

;; ;; rsense
;; (setq rsense-home "/usr/local/lib/rsense-0.3")
;; (add-to-list 'load-path (concat rsense-home "/etc"))
;; (require 'rsense)

;; slim-mode
;(custom-set-variables '(slim-indent-offset 4))

;; go-mode
(add-to-list 'exec-path (expand-file-name "~/projects/go/bin"))
(add-hook 'before-save-hook 'gofmt-before-save)
(setq gofmt-command "goimports")
(add-hook 'go-mode-hook (lambda ()
                          (local-set-key (kbd "M-") 'godef-jump)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 拡張子に紐付け
(setq auto-mode-alist
	  (append
	   '(
		 ("\\.js$" . javascript-mode)
		 ("\\.json$" . javascript-mode)
		 ("\\.php$" . php-mode)
		 ("\\.rst$" . rst-mode)
		 ("\\.rst.txt$" . rst-mode)
		 ("\\.org.txt$" . org-mode)
		 ("\\.md$" . markdown-mode)
		 ("\\.m$" . objc-mode)
		 ("\\.rake$" . ruby-mode)
		 ("\\(Cap\\|Gem\\|Guard\\|Rake\\|Schema\\)file$" . ruby-mode)
		 ("\\.erb$" . html-mode)
		 ;; ("\\.erb$" . web-mode)
		 ;; ("\\.html?$" . web-mode)
		 ) auto-mode-alist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; テンプレート
(require 'autoinsert)
(setq auto-insert-directory "~/lib")
(setq auto-insert-alist
      (nconc '(("\\.html?$" . "template.html")
	       ("\\.pl$" . "template.pl")
	       ("\\.php$" . "template.php")
	       ("\\.java$" . "template.java")
	       ("\\.c$" . "template.c")
	       ("\\.cpp$" . "template.cpp")
	       ("\\.c++$" . "template.cpp")
	       ("\\.cc$" . "template.cpp")
	       ("\\.tex$" . "template.tex")
	       ("\\.sh$" . "template.sh")
	       ("\\.py$" . "template.py")
	       ("\\.md$" . "template.md")
	       ("\\.m$" . "template.m")
	       ("\\.swift$" . "template.swift")
	       ) auto-insert-alist))
(add-hook 'find-file-not-found-hooks 'auto-insert)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; その他
; lorem-ipsum.el
; http://www.emacswiki.org/emacs/LoremIpsum
(load "lorem-ipsum.el")

; jq
; http://qiita.com/saku/items/d97e930ffc9ca39ac976
(defun jq-format (beg end)
  (interactive "r")
  (shell-command-on-region beg end "jq ." nil t))

; org-mode
(setq org-startup-truncated nil)
(setq org-startup-folded nil)
(add-hook 'rst-mode-hook 'turn-on-orgtbl)

; vue-mode
;(require 'vue-mode)
;error: Unable to activate package ‘vue-mode’.
;Required package ‘mmm-mode-0.5.5’ is unavailable
