;; auto add '+x' for script files
(add-hook 'after-save-hook 'my-chmod-script)
(defun my-chmod-script() (interactive) (save-restriction (widen)
 (let ((name (buffer-file-name)))
  (if (and (not (string-match ":" name))
	   (not (string-match "/\\.[^/]+$" name))
	   (equal "#!" (buffer-substring 1 (min 3 (point-max)))))
     (progn (set-file-modes name (logior (file-modes name) 73))
	    (message "Wrote %s (chmod +x)" name)
    ))
)))

;; hilighten yanked texts
(when window-system
  (defadvice yank (after ys:highlight-string activate)
    (let ((ol (make-overlay (mark t) (point))))
      (overlay-put ol 'face 'highlight)
      (sit-for 0.5)
      (delete-overlay ol)))
  (defadvice yank-pop (after ys:highlight-string activate)
    (when (eq last-command 'yank)
      (let ((ol (make-overlay (mark t) (point))))
	(overlay-put ol 'face 'highlight)
	(sit-for 0.5)
	(delete-overlay ol)))))

;; delete active region by Backspace
(when transient-mark-mode
  (defadvice backward-delete-char-untabify
    (around ys:backward-delete-region activate)
    (if mark-active
	(delete-region (region-beginning) (region-end))
      ad-do-it)))

;; dont show "Encoded-kbd" string in mode-line
(let ((elem (assq 'encoded-kbd-mode minor-mode-alist)))
  (when elem
    (setcar (cdr elem) "")))

;; C-x T -> YYYY-MM-DD
(require 'time-stamp)
(define-key ctl-x-map "T"
  (defun my-insert-time-stamp-string ()
    (interactive) (insert (time-stamp-yyyy-mm-dd))))

;; moving among windows with Shift + cursor
;; (http://www.bookshelf.jp/soft/meadow_30.html)
(windmove-default-keybindings)
;(setq windmove-wrap-around t)

;; コマンド名をモードラインに逐一表示
(defun my-echo-command-name-hook ()
  (unless (or
		   (eq this-command 'next-line)
		   (eq this-command 'previous-line)
		   (eq this-command 'self-insert-command)
		   (eq this-command 'count-words-region)
		   (eq this-command 'isearch-printing-char)
		   (eq this-command 'isearch-repeat-forward)
		   (eq this-command 'isearch-repeat-backward)
		   (eq this-command 'eval-last-sexp)
		   )
    (message "%s" this-command)))
(add-hook 'post-command-hook 'my-echo-command-name-hook)
;(remove-hook 'post-command-hook 'my-echo-command-name-hook)
