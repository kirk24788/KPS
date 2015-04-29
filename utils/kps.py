# -*- coding: utf-8 -*-
"""KPS Common Classes.

Exception used in all Python KPS modules.
"""
import logging


class KpsError(Exception):
    def __init__(self,msg):
        self.msg = msg
    def __str__(self):
        return self.msg

class ParserError(KpsError):
    def __init__(self, msg):
        self.msg = msg
    def __str__(self):
        return self.msg

lower_case = lambda s: s[:1].lower() + s[1:] if s else ''

def camel_case(str):
    return lower_case(str.title().replace(" ", ""))


def setup_logging_and_get_args(parser):
    grp = parser.add_mutually_exclusive_group()
    grp.add_argument('-v','--verbose', help='Verbose Logging', action="store_true")
    grp.add_argument('-q','--quiet', help='Only Error Logging', action="store_true")
    args = parser.parse_args()
    if args.verbose:
        logging.basicConfig(format='%(levelname)s:%(message)s', level=logging.DEBUG)
    elif args.quiet:
        logging.basicConfig(format='%(levelname)s:%(message)s', level=logging.WARN)
    else:
        logging.basicConfig(format='%(levelname)s:%(message)s', level=logging.INFO)
    return args
