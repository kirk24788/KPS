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
from spells import spell_key, Spell
from config import SUPPORTED_SPECS

LOG = logging.getLogger(__name__)
DEFAULT_CACHE_AGE_IN_SECONDS = 5 * 60 * 60

# *************************************************
# * Creates Player Spell List directly from Wowhead
# *************************************************

THOTTBOT_IDS = {
    "deathknight": 6,
    "demonhunter": 12,
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

ADDITIONAL_SPELLS = {
    "deathknight": [77535,
              195181, # Bone Shield
              81340, # Sudden Doom
              191587, # Virtulent Plague
              194310, # Festering Wound
    ],"demonhunter": [
              195072,  # Fel Rush
    ], "druid": [164545,164547,117679,135201,
                 155777, # Rejuvination (Germination)
    ],"hunter": [],
    "mage": [166872,145254,48107,166868,101166,135029,
              48108, # Hot Streak!
    ], "monk": [116768,159407,145008],
    "paladin": [117809,156989,156988,156990,166831],
    "priest": [179337],
    "rogue": [193359, # True Bearing
              193357, # Shark Infested Waters
              199603, # Jolly Roger
              193358, # Grand Melee
              193356, # Broadsides
              199600, # Buried Treasure
              195627, # Opportunity
    ],"shaman": [114074,115356],
    "warlock": [104316,89751,115831,115625,
                185229, # Flamelicked - Destruction Class Trinket
                111859, # Grimmoire: Imp
                111897, # Grimmoire: Felhunter
                111898, # Grimmoire: Felguard
                63106, # Siphon Life
                216457, # Shard Instability
    ],"warrior": [],
}

SPELL_ID_BLACKLIST = [
    209694, # Wrong Warrior:Rampage
    195283, # Wrong Mage: Hot Streak!
]

SPELL_NAME_BLACKLIST = [
    "Leather Specialization",
]

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
    # Fix for Warrior
    json_data = json_data.replace(""""rank":"Honor Talent"28,""", """"rank":"Honor Talent",""")
    return json.loads(json_data)

_ALREADY_SEEN = []
def is_filtered(spell):
    if spell["name"] in _ALREADY_SEEN:
        return (True, "Duplicate")
    else:
        _ALREADY_SEEN.append(spell["name"])
    if spell["name"] in SPELL_NAME_BLACKLIST:
        return (True, "Blacklisted")
    if int(spell["id"]) in SPELL_ID_BLACKLIST:
        return (True, "Blacklisted")
    if spell["cat"]==-11:
        return (True, "Weapon Proficiencies")
    #if spell["cat"]==-12:
    #    return (True, "Specialization")
    if spell["cat"]==-5:
        return (True, "Mounts")
#    if spell["cat"]==-13:
#        return (True, "Glyph")
    if spell["cat"]==-14:
        return (True, "Perks")
    if "rank" in spell.keys() and spell["rank"].upper() == "PASSIVE":
        return (True, "Passive")
    return (False, None)

def summarize(spells, class_name):
    s = ""
    for spell in spells:
        filtered, reason = is_filtered(spell)
        if filtered:
            s += " * FILTERED (%s): %s\n" % (reason, spell["name"][1:])
        else:
            s += " * %s (ID: %s CAT: %s)\n" % (spell["name"][1:], spell["id"], spell["cat"])
    for spell_id in ADDITIONAL_SPELLS[class_name]:
        spell = Spell(spell_id)
        s += " * %s (ID: %s - from ADDITIONAL_SPELLS)\n" % (spell.name, spell.id)
    return s

def generate_lua(spells, class_name):
    s = """--[[[
@module %s
@description
%s Spells.
GENERATED FROM WOWHEAD SPELLS - DO NOT EDIT MANUALLY
]]--

kps.spells.%s = {}
""" % (class_name.title(), class_name.title(), class_name)
    for spell in spells:
        if not is_filtered(spell)[0]:
            s += "kps.spells.%s.%s = kps.Spell.fromId(%s)\n" % (class_name,spell_key(spell["name"][1:]),spell["id"])
    for spell_id in ADDITIONAL_SPELLS[class_name]:
        try:
            spell = Spell(spell_id)
            s += "kps.spells.%s.%s = kps.Spell.fromId(%s)\n" % (class_name, spell.key, spell.id)
        except:
            LOG.error("ERROR: Spell-ID %s not found for %s", spell_id, class_name)
    return s

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Loads Class Spells from Wowhead')
    parser.add_argument('-c','--class', dest='class_name', help='Set the class to scan', required=True, choices=SUPPORTED_SPECS.keys())
    parser.add_argument('-a','--cache-age', dest='cache_age', help='Set the max cache age in seconds (by default the class data is cached)', required=False, default=DEFAULT_CACHE_AGE_IN_SECONDS)
    parser.add_argument('-s','--summarize', help='List all found spells and show which one were filtered', required=False, action="store_true")
    parser.add_argument('-o','--output', help='Output file (omit to print to stdout)', default=None)
    args = setup_logging_and_get_args(parser)
    spells = extract_json_from_html(load_html_page(THOTTBOT_IDS[args.class_name], args.cache_age))

    outp = summarize(spells, args.class_name) if args.summarize else generate_lua(spells,args.class_name)

    if args.output:
        open(args.output,"w").write(outp)
    else:
        print outp


