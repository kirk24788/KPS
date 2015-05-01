#!/usr/bin/env python
# -*- coding: utf-8 -*-

import urllib
import json
import logging
import time
import stat
import os
import argparse
import spells
from kps import setup_logging_and_get_args
from spells import spell_key

LOG = logging.getLogger(__name__)
DEFAULT_CACHE_AGE_IN_SECONDS = 5 * 60 * 60

# *************************************************
# * Creates Player Spell List directly from Wowhead
# *************************************************

THOTTBOT_IDS = {
    "deathknight": 6,
    "druid": 11,
    "hunter": 3,
    "mage": 8,
    "monk": 10,
    "paladin": 2,
    "priest": 5,
    "rogue": 4,
    "shaman": 7,
    "warlock": 9,
    "warrior": 1,
}



def load_html_page(class_id, cache_age):
    cache_file = "/tmp/_tb_ext_%s.cache" % class_id
    try:
        cached_data = open(cache_file).read()
        if time.time() - os.stat(cache_file)[stat.ST_MTIME] <= cache_age:
            LOG.info("Class %s loaded from Cache: %s", class_id, cache_file)
            return cached_data
    except:
        pass

    url = "http://www.wowhead.com/class=%s" % class_id
    html_data = urllib.urlopen(url).read()
    LOG.info("Class %s loaded from Thottbot: %s", class_id, url)

    try:
        cached_data = open(cache_file, "w").write(html_data)
    except Exception as e:
        LOG.warn("Couldn't save cached file '%s': %s", cache_file, str(e))
    return html_data

def extract_json_from_html(html_data):
    start_pos = html_data.find("new Listview({template: 'spell'")
    start_pos = html_data.find("data: [", start_pos) + 6
    end_pos = html_data.find(";", start_pos) - 2
    json_data = html_data[start_pos:end_pos]
    return json.loads(json_data)

def is_filtered(spell):
    if spell["cat"]==-11:
        return (True, "Weapon Proficiencies")
    #if spell["cat"]==-12:
    #    return (True, "Specialization")
    if spell["cat"]==-5:
        return (True, "Mounts")
    if spell["cat"]==-13:
        return (True, "Glyph")
    if spell["cat"]==-14:
        return (True, "Perks")
    if "rank" in spell.keys() and spell["rank"].upper() == "PASSIVE":
        return (True, "Passive")
    return (False, None)

def summarize(spells):
    s = ""
    for spell in spells:
        filtered, reason = is_filtered(spell)
        if filtered:
            s += " * FILTERED (%s): %s\n" % (reason, spell["name"][1:])
        else:
            s += " * %s\n" % (spell["name"][1:])
    return s

def generate_lua(spells, class_name):
    s = """--[[[
@module %s
@description
%s Spells and Environment Functions.
]]--

kps.spells.%s = {}

""" % (class_name.title(), class_name.title(), class_name)
    for spell in spells:
        if not is_filtered(spell)[0]:
            s += "kps.spells.%s.%s = kps.Spell.fromId(%s)\n" % (class_name,spell_key(spell["name"][1:]),spell["id"])
    return s + "\n"

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Loads Class Spells from Wowhead')
    parser.add_argument('-c','--class', dest='class_name', help='Set the class to scan', required=True, choices=spells.SUPPORTED_CLASSES)
    parser.add_argument('-a','--cache-age', dest='cache_age', help='Set the max cache age in seconds (by default the class data is cached)', required=False, default=DEFAULT_CACHE_AGE_IN_SECONDS)
    parser.add_argument('-s','--summarize', help='List all found spells and show which one were filtered', required=False, action="store_true")
    parser.add_argument('-o','--output', help='Output file (omit to print to stdout)', default=None)
    args = setup_logging_and_get_args(parser)
    spells = extract_json_from_html(load_html_page(THOTTBOT_IDS[args.class_name], args.cache_age))

    outp = summarize(spells) if args.summarize else generate_lua(spells,args.class_name)

    if args.output:
        open(args.output,"w").write(outp)
    else:
        print outp


