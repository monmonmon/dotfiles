;; key bind
(global-set-key [?\C-m] 'electric-newline-and-maybe-indent)
(global-set-key [?\C-j] 'newline)
(global-set-key [?\M-g] 'goto-line)
(global-set-key [?\C-x?\C-o] 'other-window)
(global-set-key [?\C-c?\C-r] 'comment-region)
(global-set-key [?\C-h] 'backward-delete-char)
(global-set-key [?\M-h]    'backward-kill-word)
(global-set-key [?\M-\C-h] 'backward-kill-sexp)
(global-set-key [?\M-b] 'backward-word)
(global-set-key [?\M-\C-p] (lambda () (interactive) (previous-line 4)))
(global-set-key [?\M-\C-n] (lambda () (interactive) (next-line 4)))
(global-set-key [?\M--] (lambda () (interactive) (delete-window)))
(global-set-key [?\M-1] (lambda () (interactive) (delete-other-windows)))
(global-set-key [?\M-2] (lambda () (interactive) (split-window-below)))
(global-set-key [?\M-3] (lambda () (interactive) (split-window-right)))
(global-set-key [?\M-9] (lambda () (interactive) (shrink-window 4)))
(global-set-key [?\M-0] (lambda () (interactive) (enlarge-window 4)))
(global-set-key [?\M-,] (lambda () (interactive) (scroll-down 8)))
(global-set-key [?\M-.] (lambda () (interactive) (scroll-up 8)))
(global-set-key [?\C-,] (lambda () (interactive) (scroll-down 4)))
(global-set-key [?\C-.] (lambda () (interactive) (scroll-up 4)))
(global-set-key [?\C-x?\C-,] (lambda () (interactive) (move-to-window-line 0)))
(global-set-key [?\C-x?\C-.] (lambda () (interactive) (move-to-window-line -1)))
(global-set-key [?\M-t] (lambda () (interactive) (move-to-window-line 0)))
(global-set-key [?\M-e] (lambda () (interactive) (move-to-window-line -1)))
(global-set-key [?\C-x?\C-k] 'kill-buffer)
(global-set-key [?\M-B] (lambda () (interactive) (switch-to-buffer (other-buffer))))
;(global-set-key [?\C-x?f] 'hexl-find-file)

;; cancel key bind
(global-unset-key [?\C-x?\C-l]) ; リージョンを小文字に
(global-unset-key [?\C-x?\C-u]) ; リージョンを大文字に

; http://d.hatena.ne.jp/rubikitch/20100210/emacs
(defun other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (split-window-vertically)
	)
  (other-window 1)
  )
(global-set-key [?\M-o] 'other-window-or-split)
(global-set-key "\C-xo" 'other-window-or-split)

;; EmacsWiki: Incremental Search
;; http://www.emacswiki.org/emacs/IncrementalSearch
(define-key isearch-mode-map (kbd "C-y") 'isearch-yank-line)
