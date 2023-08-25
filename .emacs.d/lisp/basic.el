;;; basic settings ;;;

;; 起動メッセージ抑制
(setq inhibit-startup-message t)
;; メニューバー非表示
(menu-bar-mode 0)
;; ツールバー非表示
(tool-bar-mode 0)
;; スクロールバー非表示
;;(scroll-bar-mode 0)
;; スクロールバーの位置指定
;;(set-scroll-bar-mode  'right)
;; カーソルの点滅抑制
(blink-cursor-mode 0)
;; *Messages*バッファへの書き込み抑制
(setq message-log-max nil)
;; ビープ、ビジブルベルを抑制
(setq ring-bell-function '(lambda ()))
;; ミニバッファのリサイズ可
(setq resize-minibuffer-mode t)
;; ガベージコレクション(メモリ解放)を起こりにくく
(setq gc-cons-threshold 200000)
;; 行数表示
(line-number-mode 1)
;; 桁番号表示
(setq column-number-mode t)
;; 標準編集モードを text-mode に
(setq default-major-mode 'text-mode)
;; スクロールステップ
(setq scroll-step 8)
;; C-n で新しい行を作らない
(setq next-line-add-newlines nil)
;; C-k で改行を含めてカット
(setq kill-whole-line t)
;; 'nn' で 'ん'
(setq enable-double-n-syntax t)
;; 行末の空白を可視化
(setq show-trailing-whitespace t)
;; 保存時に末尾の空白を削除
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; 対応する括弧をハイライト
(show-paren-mode 1)
;; リージョンをハイライト
(setq transient-mark-mode t)
;; 行番号表示
;(global-linum-mode t)
;; Visual line mode をオフ
(setq line-move-visual nil)
;; coding system
(prefer-coding-system 'utf-8)
;; インデント抑制
(setq-default indent-tabs-mode nil)
;; avoid "Symbolic link to SVN-controlled source file; follow link? (yes or no)"
(setq vc-follow-symlinks nil)

;; exec path
(add-to-list 'exec-path (expand-file-name "/usr/local/bin"))
;(exec-path-from-shell-initialize)

(defun toggle-line-move-visual ()
  "Toggle behavior of up/down arrow key, by visual line vs logical line."
  (interactive)
  (if line-move-visual
      (setq line-move-visual nil)
    (setq line-move-visual t))
  )

;; C-xC-u(upcase-region)
(put 'upcase-region 'disabled nil)
;; C-xC-l(downcase-region)
(put 'downcase-region 'disabled nil)
;; C-xC-n(set-goal-column)
(put 'set-goal-column 'disabled nil)
;; C-x n n (narrowing)
(put 'narrow-to-region 'disabled nil)

;; restrict backup
(setq make-backup-files nil)
(setq backup-by-copying nil)               ; rename
(setq backup-by-copying-when-mismatch nil) ; rename
(setq backup-by-copying-when-linked nil)     ; copy
;; restrict autosave file
(setq auto-save-list-file-prefix nil)
(setq auto-save-default nil)
;; Version Controll
(setq version-control t)
(setq kept-new-versions 2)
(setq kept-old-versions 2)

;(modify-coding-system-alist 'file "\\.txt\\'" 'china-iso-8bit)
;(modify-coding-system-alist 'file ".*" 'utf-8)
(modify-coding-system-alist 'file "\\.rst$" 'utf-8)

; tab width 4
(setq-default tab-width 4)
(setq tab-stop-list
  '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120 124 128 132 136 140 144 148 152 156 160 164 168 172 176 180 184 188 192 196 200))

; use space instead of ^I
(setq-default indent-tabs-mode t)
;(setq-default indent-tabs-mode nil)

; snake case
(load "snake-case.el")

;; 自動保存
(require 'auto-save-buffers)
(setq auto-save-buffers-timer
	  (run-with-idle-timer 60 t 'auto-save-buffers))
;(cancel-timer auto-save-buffers-timer)

(desktop-save-mode t)
