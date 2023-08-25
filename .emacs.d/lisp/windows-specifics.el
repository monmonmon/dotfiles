;; ~/.saves-PID-hostname て名前の中間ファイルを作らない
(setq auto-save-list-file-name nil)
(setq auto-save-list-file-prefix nil)

;; 右クリックで paste する（カーソル位置にしかペースト出来ない）
(global-set-key [mouse-2] 'ignore)
(global-set-key [mouse-3] 'yank)

;; フルスクリーン->元のサイズ のトグル
;;  ; 最大化
;;  (w32-send-sys-command ?\xf030)
;;  ; 最小化
;;  (w32-send-sys-command ?\xf020)
;;  ; 元のサイズにリストア
;;  (w32-send-sys-command ?\xf120)
(defvar frame-fullscreen-state-alist nil)
(defun toggle-frame-fullscreen ()
  (interactive)
  (let ((state (assq (selected-frame) frame-fullscreen-state-alist)))
    (if state
        (if (cdr state)
            (w32-send-sys-command ?\xf120)
          (w32-send-sys-command ?\xf030))
      (setq state (cons (selected-frame) nil))
      (setq frame-fullscreen-state-alist
            (cons state frame-fullscreen-state-alist))
      (w32-send-sys-command ?\xf030))
    (setcdr state (null (cdr state)))))
(global-set-key (kbd "<M-return>") 'toggle-frame-fullscreen)

;; フォント
(when (member "Ricty Diminished" (font-family-list))
  (add-to-list 'default-frame-alist '(font . "Ricty Diminished")))
