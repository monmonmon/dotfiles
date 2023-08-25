#!/usr/bin/php
<?php
error_reporting(E_ALL);

/**
 * usageだよだよ
 * @param $errmsg エラーメッセージ
 * @param $errno 終了ステータス
 * @return null
 */
function usage ($errmsg = "", $errno = 1) {
    print "Usage: " . basename(__FILE__) . " <jpeg file name>\n";
    if ($errmsg) print "$errmsg\n";
    exit($errno);
}

/**
 * JPG画像のEXIF情報を再帰的に出力
 * @param $exif EXIF情報を収めたツリー構造の配列
 * @param $preceding_space 行先頭のスペース　再帰的に呼ばれる度にふえてく
 * @return null
 */
function exif ($exif, $preceding_space = '') {
    foreach ($exif as $key => $value) {
        if (is_array($value)) {
            // 再帰
            print "$preceding_space$key:\n";
            exif($value, $preceding_space . '  ');
//         } elseif ($key == 'MakerNote') {
//             // 表示がぐっちゃぐちゃになるんで MakerNote はスルー
//             print "$preceding_space$key: .....\n";
        } else {
            // 出力
            $value = trim($value, "\x00..\x20"); // 制御文字とかトリムしちゃうよ
            print "$preceding_space$key: $value\n";
        }
    }
}

if ($argc != 2) {
    usage();
}
$path = $argv[1];
if (!file_exists($path)) {
    usage("$path: file not found");
}
if (!is_file($path)) {
    usage("not a file");
}
// EXIF情報取得
// 第３引数 true でEXIF情報がカテゴリ別に配列に分類される
//$exif = exif_read_data($path, 0, true);
$exif = exif_read_data($path);
if (!$exif) {
    usage("$path: not a jpeg file");
}
// EXIF情報出力
print "** " . $path . " **\n";
exif($exif);
