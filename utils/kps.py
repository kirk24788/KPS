# -*- coding: utf-8 -*-
"""KPS Common Classes.

Exception used in all Python KPS modules.
"""
import logging
import os


class KpsError(Exception):
    def __init__(self,msg):
        self.msg = msg
    def __str__(self):
        return self.msg

class ParserError(KpsError):
    def __init__(self, msg, silent=False):
        self.msg = msg
        self.silent = silent
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


def parse_rotation_meta(class_name, spec_name):
    spec_file = os.path.dirname(os.path.abspath(__file__)) + "/../rotations/%s_%s.lua" % (class_name, spec_name)
    rotation_data = open(spec_file,"r").read()
    comment_start = rotation_data.find("--[[[", 0) + 5
    comment_end = rotation_data.find("]]--", 0)

    if comment_start < 0 or comment_end <= 0:
        raise Exception("No Meta-Information found for %s_%s.lua - Meta-Section must start with '--[[[' and end with ']]--'!" % (class_name, spec_name))


    comment_data = rotation_data[comment_start:comment_end]
    raw_meta_info = {}
    last_meta_key = "@"
    for line in comment_data.split("\n"):
        line_stripped = line.strip()
        if line_stripped != "":
            parts = line_stripped.split(" ", 1)
            if len(parts) == 2:
                meta_key, meta_data = parts
            else:
                meta_key = parts[0]
                meta_data = ""
            if meta_key[0] == "@":
                last_meta_key = meta_key
            else:
                meta_key = last_meta_key
                meta_data = line_stripped
            if meta_key not in raw_meta_info.keys():
                raw_meta_info[meta_key] = []
            raw_meta_info[meta_key].append(meta_data)

    meta_info = {}
    for meta_key, meta_data in raw_meta_info.iteritems():
        if len(meta_key) > 1:
            meta_info[meta_key[1:]] = " ".join(meta_data)
    
    required_keys = ["version", "module"]
    for key in required_keys:
        if not key in meta_info.keys():
            raise Exception("Invalid Meta-Information for %s_%s.lua - No '@%s' Entry!" % (class_name, spec_name, key))
    if "author" in meta_info.keys() and "generated_from" in meta_info.keys():
        raise Exception("Invalid Meta-Information for %s_%s.lua - No '@author' and '@generated_from' are mutually exclusive" % (class_name, spec_name))
    if "author" not in meta_info.keys() and "generated_from" not in meta_info.keys():
        raise Exception("Invalid Meta-Information for %s_%s.lua - One of '@author' and '@generated_from' is required!" % (class_name, spec_name))
    return meta_info
