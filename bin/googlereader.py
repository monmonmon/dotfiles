#!/usr/bin/env python
# -*- coding: utf-8 -*-
# vim: set fileencoding=utf-8
import os
import sys
import re
from optparse import OptionParser
import gdata
import monutils
import getpass

# 参考
# http://moimoitei.blogspot.jp/2011/03/google-python-google-reader-api.html

# なんかうごかねえー
# あとまわし！

def hoehoe_n():
    # Google Reader サービス設定
    service = gdata.service.GDataService(account_type='GOOGLE',
                                         service='reader',
                                         server='www.google.com',
                                         source='MyReaderHoge') # なんこれ？？
    # Googleにログイン
    email = 'ymdsmn@softbank.ne.jp'
    passwd = getpass.getpass('{1} のパスワードを入力してちょ: '.format(email))
    service.ClientLogin(email, passwd)
    # 認証トークン(SIDの値)
    print service.GetClientLoginToken()
    # 書き込み用のトークンの取得
    token = service.Get('/reader/api/0/token',converter=lambda x:x)
    print "token:", token

def main():
    """main function"""
    hoehoe_n()

if __name__ == '__main__':
    main()
