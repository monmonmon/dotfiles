;; 交通費
;; モバイルSUICAからの交通費のコピペをExcel用の形式に修正
;; リージョン選択せずコピペの先頭行で実行
(fset 'kotsuhi
   [C-down C-up ?\M-x ?f ?l ?u tab ?\C-m ?物 ?販 return ?\M-x ?f ?l ?u tab ?\C-m ?窓 ?出 ?る ?\C-h return ?\M-x ?f ?l ?u tab ?\C-m ?V ?I ?E ?W ?\C-q ?\C-i ?モ ?バ ?イ ?ル return ?\C-\M-% ?入 ?り ?\C-h ?\C-q ?\C-i ?¥ ?\( ?\[ ?¥ backspace ?^ ?\C-q ?\C-i ?\] ?+ ?¥ ?\) ?\C-q ?\C-i ?出 ?る backspace ?\C-q ?\C-i ?¥ ?\( ?\[ ?^ ?\C-q ?\C-i ?\] ?+ ?¥ ?\) return ?¥ ?1 ?〜 ?¥ ?2 return ?! C-up ?\C-\M-% ?ﾊ ?ﾞ ?ｽ ?等 ?\C-q ?\C-i ?¥ ?\( ?\[ ?\C-q ?\C-i ?\C-h ?^ ?\C-q ?\C-i ?\] ?+ ?¥ ?\) ?\C-q ?\C-i ?  backspace ?　 ?\C-q ?\C-i ?\C-q ?\C-i backspace return ?b ?a ?s ?u backspace backspace backspace backspace ?ﾊ ?ﾞ ?ｽ ?等 ?　 backspace ?  ?¥ ?1 return ?! C-up ?\C-\M-% ?\[ ?^ ?\C-q ?\C-i ?\] ?\[ ?0 ?- ?9 ?, ?\] ?+ ?\C-q ?\C-i ?- return return ?! C-up])
