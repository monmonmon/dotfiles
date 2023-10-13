#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# vim: set fileencoding=utf-8
#
# E-H***** DOWNLOADER
#
# Usage: ./eh.py <PAGE URL>

import os
import os.path
import re
import sys
import urllib
import time
import glob
import random
from optparse import OptionParser
from pyquery import PyQuery as pq

options = None

def pseudo_user_agent(maeto_onaji=False):
    """
    User-Agent偽装
    """
    user_agents = [
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20100101 Firefox/13.0",
        "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)",
        "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)",
        "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.75 Safari/535.7",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.52.7 (KHTML, like Gecko) Version/5.1.2 Safari/534.52.7",
        "Mozilla/4.0 (compatible; MSIE 6.0; X11; Linux i686; ja) Opera 10.10",
        ]
    if maeto_onaji and hasattr(pseudo_user_agent, 'ua'):
        return pseudo_user_agent.ua
    else:
        pseudo_user_agent.ua = user_agents[int(random.random() * len(user_agents))]
        return pseudo_user_agent.ua

def pseudo_referer():
    """
    Referer偽装
    """
    referers = [
        "http://www.yahoo.co.jp/",
        "http://twitter.com/",
        "http://4travel.jp/",
        "http://www.google.com/",
        "http://www.google.co.jp/",
        ]
    return referers[int(random.random() * len(referers))]

def pyquery(url):
    """
    User-Agent & Referer を偽装しつつ PyQueる
    """
    request = urllib.request.Request(url, None, {
            'User-Agent':pseudo_user_agent(maeto_onaji=False),
            'Referer':pseudo_referer(),
            })
    html = urllib.request.urlopen(request).read()
    return pq(str(html, 'utf-8'))

def confirm_user(message):
    """
    y/n で回答を求める。デフォルトNO
    """
    message = message.strip() + " [y/N] \a"
    sys.stdout.write(message)
    sys.stdout.flush()
    a = sys.stdin.readline().strip().lower()
    if 'y' == a:
        return True
    else:
        return False

def get_title(q):
    """
    作品タイトルを取得
    """
    # 日本語名
    title = q('h1#gj').text()
    if not title:
        # なければ英語名
        title = q('h1#gn').text()
        if not title:
            raise Exception("h1 text not found")
    return safe_filename(title)

def safe_filename(filename, repl="_"):
    """
    ファイル名として使用不可能な文字を取り除く
    """
    return re.sub("""[\\\/:*?"<>|:]""", repl, filename)

def mkdir(target_dir):
    """
    ディレクトリがなければ作成
    """
    if os.path.exists(target_dir):
        if not os.path.isdir(target_dir):
            raise Exception("File \"%s\" already exists".format(target_dir))
    else:
        os.mkdir(target_dir)

def determine_starting_nr(directory='.'):
    """
    開始ファイル番号を決定
    """
    # ディレクトリ中のファイル数を調べる
    list = os.listdir(directory)
    nr = len(list)
    if nr == 0:
        return 1
    # ディレクトリ中に [0-9]+.jpg 以外のファイルもありうるので
    # nr を減らしながら「最後の」ファイルの番号を調べる
    while nr > 0:
        files = glob.glob('{}/{:03d}.*'.format(directory, nr))
        if len(files) != 0:
            break
        nr -= 1
    return nr + 1

def download_image(nr_image, url):
    """
    画像のEACHページから画像をダウンロード
    """
    q = pyquery(url)
    # HTML中から画像URL抽出
    image_url = q('img#img').attr('src')
    # "509" エラー画像かどうか
    if os.path.basename(image_url) in ['509.gif', '509s.gif']:
        raise Exception("509 ERROR: BANDWIDTH EXCEEDED")
    # 保存する画像ファイル名を生成
    extension = os.path.basename(image_url).split('.')[-1]
    filename = "{:03d}.{}".format(nr_image, extension)
    if os.path.exists(filename) and not confirm_user('!!! OVERWRITING "{}" !!!'.format(filename)):
        print("QUITTING...")
        sys.exit(1)
    # ダウンロード
    nr_trial = 0
    while True:
        try:
            print('downloading image: {}'.format(image_url))
            (_, headers) = urllib.request.urlretrieve(image_url, filename)
            if 'text/html' == headers.get_content_type():
                raise Error('not an image')
            break
        except Exception as e:
            print("FAILED!", file=sys.stderr)
            print(str(e), file=sys.stderr)
            nr_trial += 1
            if nr_trial <= options.nr_max_trial:
                # リトライ
                print("sleep {} sec...".format(options.wait_sec))
                time.sleep(options.wait_sec)
                print("retry ({}/{})".format(nr_trial, options.nr_max_trial))
            else:
                # ダウンロード失敗
                print(":P\a")
                raise e

def skip_warning_page(q):
    """
    "content warning" ページをスキップ
    """
    h1 = q('h1')
    print(h1.html())
    if q('h1').text() == 'Content Warning':
        print("Content Warning")
        url = q('a[text="View Gallery"]').attr('href');
        print(url)
        return pyquery(url)
    else:
        return q

def doit(index_url):
    # 最初のindexページをフェッチ
    print("=" * 70)
    print("fetching the initial page: {}".format(index_url))
    index_url = index_url + '?nw=session'
    q = pyquery(index_url)
    # "content warning" ページをスキップ
    q = skip_warning_page(q)
    # HTML中から作品タイトル抽出
    title = get_title(q)
    print("TITLE: {}".format(title))
    # 作品タイトル名で保存先ディレクトリを作って中に移動
    mkdir(title)
    os.chdir(title)
    # 画像の開始番号を決定。既にダウンロード済の画像がある場合はその次の番号からスタート
    nr_image = determine_starting_nr()
    if 1 != nr_image and not confirm_user("RESUMING FROM {:03d}".format(nr_image)):
        return
    skip_count = nr_image - 1
    while True:
        #image_a_tags = q('div.gdtm>div>a')
        image_a_tags = q('div.gdtm a')
        target_urls = image_a_tags.map(lambda i, e: q(e).attr('href'))
        print("target_urls: {}".format(len(target_urls)))
        for url in target_urls:
            if skip_count > 0:
                # ダウンロード済みの画像をスキップ
                skip_count -= 1
                continue
            print("fetching image page {}: {}".format(nr_image, url))
            # 画像をダウンロード
            download_image(nr_image, url)
            nr_image += 1
        # 次のindexページへ
        next_index_url = q('table.ptb td:last>a').attr('href')
        if not next_index_url or next_index_url == index_url:
            # 終了
            sys.stdout.write("\a")
            break
        index_url = next_index_url
        print()
        print("fetching next index page: {}".format(index_url))
        q = pyquery(index_url)
    print()
    # ディレクトリを開く
    if options.open_folder:
        os.system('/usr/bin/open .')
    os.chdir('..')

def main():
    """
    main function
    """
    global options
    # usage
    usage_text = """Usage: %prog <PAGE URL>, ..."""
    # define command line options
    optionparser = OptionParser(usage=usage_text)
    optionparser.add_option("-o", dest="open_folder", action="store_true", help="open the folder when download finished")
    optionparser.add_option("-m", dest="nr_max_trial", metavar="<nr_max_trial>", type="int", default=3, help="number of trials to download images")
    optionparser.add_option("-w", dest="wait_sec", metavar="<wait_sec>", type="int", default=5, help="number of seconds to wait between each trials")
    (options, args) = optionparser.parse_args()
    if len(args) < 1:
        print(sys.stderr, "Too few arguments", file=sys.stderr)
        optionparser.print_help()
        sys.exit(1)
    for url in args:
        doit(url)

if __name__ == '__main__':
    main()
