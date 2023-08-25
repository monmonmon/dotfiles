;; ~/.saves-PID-hostname という名前の中間ファイルを作らない
(setq auto-save-list-file-name nil)
(setq auto-save-list-file-prefix nil)

;; マウスカーソルを消す
(setq w32-hide-mouse-on-key t)

;; C-x t で最大サイズ<->元のサイズ のトグル
(defvar my-frame-state-alist nil)
(defun my-toggle-frame-size ()
  (interactive)
  (let ((state (assq (selected-frame) my-frame-state-alist)))
    (if state
	(if (cdr state)
	    (w32-restore-frame)
	  (w32-maximize-frame))
      (setq state (cons (selected-frame) nil))
      (setq my-frame-state-alist
	    (cons state my-frame-state-alist))
      (w32-maximize-frame))
    (setcdr state (null (cdr state)))))
(global-set-key "\C-xt" 'my-toggle-frame-size)

;; 右クリックで paste する（カーソル位置にしかペースト出来ない）
;; (global-set-key [mouse-2] 'ignore)
;; (global-set-key [mouse-3] 'yank)

;; character code
(load "jp_sjis.el")

;; font settings
(load "font-meadow.el")
(when (require 'font-setup nil t)
  (setq font-setup-bdf-dir "D:/Meadow/intlfonts-1.2.1")
  (font-setup))


;;; IME settings ;;;
(mw32-ime-initialize)
(setq default-input-method "MW32-IME")
(setq-default mw32-ime-mode-line-state-indicator "[--]")
(setq mw32-ime-mode-line-state-indicator-list '("[--]" "[Jp]" "[--]"))
(add-hook 'mw32-ime-on-hook (function (lambda () (set-cursor-height 2))))
(add-hook 'mw32-ime-off-hook (function (lambda () (set-cursor-height 4))))
(wrap-function-to-control-ime 'y-or-n-p nil nil)
(wrap-function-to-control-ime 'yes-or-no-p nil nil)
(add-hook 'mw32-ime-on-hook	; IMEのONOFFでカーソルの色を変える
   (function (lambda () (set-cursor-color "darkgreen"))))
(add-hook 'mw32-ime-off-hook
   (function (lambda () (set-cursor-color "black"))))

(global-set-key [?\C-￥] 'mw32-ime-toggle)
