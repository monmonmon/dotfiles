#!/usr/bin/env python

"""
awesome python script
"""

__author__ = 'Simon Yamada <ymdsmn@gmail.com>'
__status__ = 'development'
__version__ = '0.0.1'
__date__    = '2014/01/10'

import os
import sys
import codecs
import re
from optparse import OptionParser

options = None

def doit():
    """
    you can do it
    """
    pass

def main():
    """
    main function
    """
    global options
    # usage
    usage_text = 'Usage: %prog <hoehoe>'
    # define command line options
    optionparser = OptionParser(usage=usage_text)
    optionparser.add_option('-v', dest='verbose', action='store_true', help='verbose mode')
    optionparser.add_option('-n', dest='number', action='store', type='int', default=3, help='integer parameter')
    optionparser.add_option('-s', dest='string', action='store', type='string', default='', help='string parameter')
    (options, args) = optionparser.parse_args()
    if options.verbose:
        print('verbose')
    if len(args) < 1:
        print('Too few arguments', file=sys.stderr)
        optionparser.print_help()
        sys.exit(1)
    doit()

if __name__ == '__main__':
    main()
