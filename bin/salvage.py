#!/usr/bin/env python
# -*- coding: utf-8 -*-
# vim: set fileencoding=utf-8

"""
salvage video files from browser cache directories.

ブラウザのキャッシュディレクトリから MIMETYPE が "video/*" のキャッシュファイルを探し、
Desktop 以下に移動するための mv コマンドを出力する。
ブラウザで閲覧した映像のビデオファイルをローカルに保存したい場合に便利。
MacOSX 

ブラウザキャッシュが溜まっていると非常に時間がかかります。
ブラウザで映像を閲覧する前に、予めブラウザキャッシュをクリアしておくと動作が軽いです。

MIMETYPE の判定には file コマンドを使用。
"""

from __future__ import print_function
import os
import sys
import re
import subprocess
import mimetypes
import glob
from optparse import OptionParser

__author__ = "Simon Yamada <ymdsmn@gmail.com>"
__status__ = "development"
__version__ = "0.0.1"
__date__    = "2014/02/10"

cache_directories = {
    'opera': '~/Library/Caches/com.operasoftware.Opera/Cache',
    'firefox': '~/Library/Caches/Firefox/Profiles/*',
    'chrome': '~/Library/Caches/Google/Chrome/Default/Cache',
    }

target_directory = '~/Desktop'

def find_regular_files_recursively(directory_path):
    """
    find all regular file paths in the passed directory and return as a list
    """
    paths = os.listdir(directory_path)
    rfile_paths = []
    for path in paths:
        path = os.path.join(directory_path, path)
        if os.path.isdir(path):
            rfile_paths += find_regular_files_recursively(path)
        elif os.path.isfile(path):
            rfile_paths.append(path)
        else:
            pass
    return rfile_paths

def filter_files_by_mimetype(file_paths, mimetype_regexp, nr_files_per_process = 1000):
    """
    filter file paths by their mimetypes
    """
    nr_files = len(file_paths)
    nr_files_processed = 0
    tuples = []
    #print("# {} files".format(len(file_paths)))
    file_output_regexp = re.compile('''^(.+):\s+(\S+)$''')
    while nr_files_processed < nr_files:
        filepaths = file_paths[nr_files_processed:nr_files_processed + nr_files_per_process]
        #print('# {} files to process'.format(len(filepaths)))
        command = ['/usr/bin/file', '--mime-type'] + filepaths
        file_output_lines = subprocess.Popen(
            command, stdout=subprocess.PIPE
            ).stdout.read().strip().split(b"\n")
        #print('# file command output: {} lines'.format(len(file_output_lines)))
        for line in file_output_lines:
            line = line.decode(encoding='UTF-8')
            m = file_output_regexp.match(line.strip())
            if m:
                path = m.group(1)
                mtype = m.group(2)
                #print('# {}: {}'.format(mtype, path))
                if mimetype_regexp.match(mtype):
                    tuples.append((path, mtype))
        nr_files_processed += len(filepaths)
        #print('# tuples: {}'.format(len(tuples)))
        #print('# nr_files_processed =', nr_files_processed)
    return tuples

def youcandoit(target_directory_path):
    # find regular files in the cache directory
    regular_file_paths = find_regular_files_recursively(target_directory_path)
    # filter the file paths by their mimetypes
    tuples = filter_files_by_mimetype(regular_file_paths, re.compile('''^video\/'''))
    count = 1
    for cache_path, mtype in tuples:
        # guess a file extension from the mimetype
        ext = mimetypes.guess_extension(mtype)
        if ext:
            # determine a unique file path
            while True:
                to_path = '{dir}/{n:03}{ext}'.format(dir = target_directory, n = count, ext = ext)
                if os.path.exists(os.path.expanduser(to_path)):
                    count += 1
                else:
                    break;
            #to_path = '{dir}/{n:03}{ext}'.format(dir = target_directory, n = count, ext = ext)
            # print a mv command
            print('mv "{cache_path}" {to_path}'.format(cache_path = cache_path, to_path = to_path))
            count += 1
        else:
            print('# {cache_path}: unknown type: {mtype}'.format(cache_path = cache_path, mtype = mtype))

def main():
    """
    main function
    """
    # usage
    usage_text = """usage: %prog <hoehoe>"""
    # define command line options
    optionparser = OptionParser(usage=usage_text)
    optionparser.add_option("-o", dest="opera", action="store_true", help="opera")
    optionparser.add_option("-f", dest="firefox", action="store_true", help="firefox")
    optionparser.add_option("-c", dest="chrome", action="store_true", help="chrome")
    (options, _) = optionparser.parse_args()
    if not (options.opera or options.firefox or options.chrome):
        print(":P\n", file = sys.stderr)
        optionparser.print_help()
        sys.exit(1)
    if options.opera:
        target_directory_path = cache_directories['opera']
    elif options.firefox:
        target_directory_path = cache_directories['firefox']
    elif options.chrome:
        target_directory_path = cache_directories['chrome']
    # resolve the target directory
    target_directory_path = os.path.realpath(
        glob.glob(os.path.expanduser(target_directory_path))[0])
    youcandoit(target_directory_path)

if __name__ == '__main__':
    main()
