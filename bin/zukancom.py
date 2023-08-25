#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# vim: set fileencoding=utf-8
#
# zukan.com のお魚画像をダウンロードする
# Usage: zukancom.py <https://zukan.com/fish/xx> [...]

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
    title = q('h1[title]').text()
    if not title:
        raise Exception("title text not found")
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

def download_image(url):
    """
    魚のleafページから画像をダウンロード
    """
    q = pyquery(url)
    # HTML中から画像URL抽出
    image_path = q('.leaf_image>a').attr('href')
    image_url = 'https://zukan.com' + image_path
    # 保存する画像ファイル名を生成
    filename = os.path.basename(image_path).split('?')[0]
    if os.path.exists(filename):
        print('skip {}'.format(image_url))
        return
    # ダウンロード
    trial_count = 0
    while True:
        try:
            print('downloading {}'.format(image_url))
            (_, headers) = urllib.request.urlretrieve(image_url, filename)
            if 'text/html' == headers.get_content_type():
                raise Error('not an image')
            break
        except Exception as e:
            print("FAILED!", file=sys.stderr)
            print(str(e), file=sys.stderr)
            trial_count += 1
            if trial_count <= options.max_trial_count:
                # リトライ
                print("sleep {} sec...".format(options.wait_sec))
                time.sleep(options.wait_sec)
                print("retry ({}/{})".format(trial_count, options.max_trial_count))
            else:
                # ダウンロード失敗
                print(":P\a")
                raise e

def doit(index_url):
    # 最初のindexページをフェッチ
    #print("=" * 70)
    #print("fetching the initial page: {}".format(index_url))
    q = pyquery(index_url)
    # HTML中から作品タイトル抽出
    title = get_title(q)
    print("title: {}".format(title))
    # 作品タイトル名で保存先ディレクトリを作って中に移動
    mkdir(title)
    os.chdir(title)
    while True:
        image_link_tags = q('.leaf_img>a')
        target_url_paths = image_link_tags.map(lambda i, e: q(e).attr('href'))
        for path in target_url_paths:
            leaf_page_url = 'https://zukan.com' + path
            #print("leaf page: {}".format(leaf_page_url))
            # 画像をダウンロード
            download_image(leaf_page_url)
        # 次のindexページへ
        next_page_link = q('.pagination_wrapper .pagination li:last>a')
        next_index_path = next_page_link.attr('href')
        if re.match('[0-9]', next_page_link.text()) or not next_index_path or next_index_path == index_url:
            # 終了
            sys.stdout.write("\a")
            break
        index_url = 'https://zukan.com' + next_index_path
        print()
        print("fetching next index page: {}".format(index_url))
        q = pyquery(index_url)
    print()
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
    optionparser.add_option("-m", dest="max_trial_count", metavar="<max_trial_count>", type="int", default=3, help="number of trials to download images")
    optionparser.add_option("-w", dest="wait_sec", metavar="<wait_sec>", type="int", default=5, help="number of seconds to wait between each trials")
    (options, args) = optionparser.parse_args()
    if len(args) < 1:
        print("Too few arguments", file=sys.stderr)
        optionparser.print_help()
        sys.exit(1)
    for url in args:
        doit(url)

if __name__ == '__main__':
    main()
