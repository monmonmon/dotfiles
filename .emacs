;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; load-path
(setq load-path (append (list "~/.emacs.d/lisp" ) load-path))

;; exec-path
(setq exec-path
      (append (list
               "/usr/local/bin"
               "/usr/bin"
               (expand-file-name "~.rbenv/shims")
               ) exec-path))

;; basics
(load "basic.el")
;; keybind
(load "keybind.el")
;; color
(load "color-settings.el")
;; character code
(load "jp_utf8.el")
;; programming
(load "lang.el")
;; misc
(load "misc.el")
;; package management
(load "packages.el")
;; macros
(load "macros.el")
;; environment specifics
(cond
 ;((string-match "mingw" (emacs-version)) (load "meadow-specifics.el"))
 ((string-match "mingw" (emacs-version)) (load "windows-specifics.el"))
 ((string-match "darwin" (emacs-version)) (load "macosx-specifics.el"))
 ((string-match "linux" (emacs-version)) (load "linux-specifics.el"))
 )

;; frame size
(when (window-system)
  (set-frame-size
    (selected-frame)
    120 ; width
    (- (/ (display-pixel-height) (frame-char-height)) 2) ; height
    )
  (set-frame-position
    (selected-frame)
    (- (- (display-pixel-width) (frame-native-width)) 10) ; left
    0 ; top
    )
  )

;; シメ
(kill-buffer "*Messages*")
(text-mode)
(cd "~/")

;; 環境依存設定
(defvar private-setting-file "~/.emacs.local"
  "machine specific emacs settings")
(if (file-exists-p private-setting-file)
    (load private-setting-file))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(markdown-preview-mode markdown-mode typescript-mode mozc add-node-modules-path flycheck vue-mode elm-mode pug-mode solidity-mode js2-mode yaml-mode swift-mode slim-mode sass-mode python-environment pos-tip pkg-info magit jade-mode hledger-mode helm haskell-mode go-mode git-gutter gherkin-mode fuzzy feature-mode f exec-path-from-shell epc csv-mode coffee-mode buffer-move auto-complete)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(italic ((t nil)))
 '(markdown-italic-face ((t (:inherit font-lock-variable-name-face :slant italic)))))
