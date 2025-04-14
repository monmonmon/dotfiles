;;; Mac OS X specific settings ;;;

;; keymaps
(setq mac-option-key-is-meta nil)
(setq mac-command-key-is-meta t)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

;; font
(when (member "Ricty Diminished" (font-family-list))
  (add-to-list 'default-frame-alist '(font . "Ricty Diminished 12")))
;; (when (member "HackGen" (font-family-list))
;;   (add-to-list 'default-frame-alist '(font . "HackGen 12")))
;; (when (member "Moralerspace Neon HWJPDOC" (font-family-list))
;;   (add-to-list 'default-frame-alist '(font . "Moralerspace Neon HWJPDOC 12")))

;; character code
;; http://pcweb.mycom.co.jp/column/osx/079/
(set-clipboard-coding-system 'utf-8)
;(utf-translate-cjk-mode 1)
;(set-file-name-coding-system 'utf-8)
(if window-system
    (set-keyboard-coding-system 'utf-8)
  (progn
    (set-keyboard-coding-system 'utf-8)
    (set-terminal-coding-system 'utf-8)))

(setq default-process-coding-system
	  '(utf-8-unix . japanese-shift-jis-unix))

(add-hook 'after-init-hook
		  '(lambda ()
			 (setq default-buffer-file-coding-system 'utf-8-unix)
			 ))

;; フルスクリーン <-> 元のサイズ
(defun mac-toggle-max-window ()
  (interactive)
  (if (frame-parameter nil 'fullscreen)
      (set-frame-parameter nil 'fullscreen nil)
    (set-frame-parameter nil 'fullscreen 'maximized))) ;; 真のフルスクリーンにするには 'maximized -> 'fullboth
(global-set-key (kbd "M-C-M") 'mac-toggle-max-window)

;; 半透明に
;(if window-system (set-frame-parameter nil 'alpha 90))

;; open コマンドで新しいframe開かない
(setq ns-pop-up-frames nil)

;; backslashが￥になる問題を解決
;; (define-key global-map [2213] nil)
;; (define-key global-map [67111077] nil)
;; (define-key global-map [134219941] nil)
;; (define-key global-map [201328805] nil)
;; (define-key function-key-map [2213] [?\\])
;; (define-key function-key-map [67111077] [?\C-\\])
;; (define-key function-key-map [134219941] [?\M-\\])
;; (define-key function-key-map [201328805] [?\C-\M-\\])
;; (define-key global-map [3420] nil)
;; (define-key global-map [67112284] nil)
;; (define-key global-map [134221148] nil)
;; (define-key global-map [201330012] nil)
;; (define-key function-key-map [3420] [?\\])
;; (define-key function-key-map [67112284] [?\C-\\])
;; (define-key function-key-map [134221148] [?\M-\\])
;; (define-key function-key-map [201330012] [?\C-\M-\\])
(define-key global-map [?\¥] [?\\])
(define-key global-map [?\C-¥] [?\C-\\])
(define-key global-map [?\M-¥] [?\M-\\])
(define-key global-map [?\C-\M-¥] [?\C-\M-\\])
