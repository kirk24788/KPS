# -*- coding: utf-8 -*-
"""KPS Spell Handling.

Handles Reading of Spells and Class Rotations.
"""

import logging
import os
import re
import urllib
from kps import KpsError, camel_case
from config import SUPPORTED_SPECS

LOG = logging.getLogger(__name__)

ILLEGAL_KEY_STRINGS=[":","!","&#039;","'","-",",",u'\u2019']
def clean_key(key):
    for illegal_string in ILLEGAL_KEY_STRINGS:
        key = key.replace(illegal_string, "")
    return key

def spell_key(spell_name):
    return camel_case(clean_key(spell_name))


class SpellError(KpsError):
    def __init__(self,msg):
        self.msg = msg
    def __str__(self):
        return self.msg


class Spell(object):
    def __init__(self, spell_id, key=None, key_prefix="", key_suffix="", comment=None, validate=False):
        self.id = int(spell_id)
        self.__key = key
        self.__comment = comment
        self.__key_suffix = key_suffix
        self.__key_prefix = key_prefix
        if validate:
            self.__name = self.__resolve_name()
            self.key
            self.comment
        else:
            self.__name = None

    def __resolve_name(self):
        data = urllib.urlopen("http://www.wowhead.com/spell=%s" % self.id)
        if data.getcode() != 404:
            for line in data.read().split("\n"):
                if "<title>" in line:
                    s = line.find("<title>") + 7
                    e = line.find(" - Spell - World")
                    return line[s:e]
            raise SpellError("Spell with ID %s doesn't seem to have a name?!?" % self.id)
        raise SpellError("Spell with ID %s not found!" % self.id)

    def __resolve_key(self):
        return self.__key_prefix + spell_key(self.name) + self.__key_suffix

    def __resolve_comment(self):
        if len(self.__key_suffix) > 0:
            return "%s (%s)" % (self.name, self.__key_suffix)
        else:
            return "%s" % (self.name)

    def __getattr__(self, key):
        if key=="name":
            if self.__name == None:
                self.__name = self.__resolve_name()
            return self.__name
        elif key=="key":
            if self.__key == None:
                self.__key = self.__resolve_key()
            return self.__key
        elif key=="comment":
            if self.__comment == None:
                self.__comment = self.__resolve_comment()
            return self.__comment

    def __str__(self):
        if self.comment:
            return "%s = kps.Spell.fromId(%d) -- %s" % (self.key, self.id, self.comment)
        else:
            return "%s = kps.Spell.fromId(%d)" % (self.key, self.id)


class PlayerSpells(dict):
    def __init__(self, class_name, validate=False, ignore_validation_errors=True):
        if class_name not in SUPPORTED_SPECS.keys():
            raise KpsError("Unknown class: '%s'" % class_name)
        self.class_name = class_name
        self.__player_spells = {}
        spell_ids_found = {}
        def is_spell_duplicate(spell_id, currentLine):
            if spell_id in spell_ids_found.keys():
                return int(spell_ids_found[spell_id])
            else:
                spell_ids_found[spell_id] = currentLine
                return 0
        file_name = os.path.dirname(os.path.abspath(__file__)) + "/../rotations/" + class_name + "_spells.lua"
        LOG.info("Parsing PlayerSpells in '%s'", file_name)
        line_nr = 0
        try:
            for line in open(file_name).read().split("\n"):
                line_nr = line_nr + 1
                match = re.match(r'kps\.spells\..*\.([a-zA-Z]*)\s*.*kps.Spell.fromId\((\d*)\).*', line)
                if match:
                    spell_key = match.group(1)
                    spell_id = int(match.group(2))
                    if is_spell_duplicate(spell_id, line_nr) > 0:
                        LOG.warn("%s.lua:%3s - %s DUPLICATE OF %s", class_name, line_nr, line, is_spell_duplicate(spell_id,line_nr))
                        self.__player_spells[spell_key] = spell
                    else:
                        if ignore_validation_errors:
                            try:
                                spell = Spell(spell_id, "kps.spells.%s.%s" % (class_name, spell_key), validate=validate)
                                LOG.debug("%s", spell)
                            except SpellError:
                                LOG.warn("%s.lua:%3s - %s INVALID SPELL ID %d", class_name, line_nr, line, spell_id)
                        else:
                            spell = Spell(spell_id, "kps.spells.%s.%s" % (class_name, spell_key), validate=validate)
                            LOG.debug("%s", spell)
                        self[spell_key] = spell
        except IOError,e:
            LOG.error("Couldn't parse '%s': %s", file_name, str(e))

class PlayerEnv(dict):
    def __init__(self, class_name, validate=False, ignore_validation_errors=True):
        if class_name not in SUPPORTED_SPECS.keys():
            raise KpsError("Unknown class: '%s'" % class_name)
        self.class_name = class_name

        file_name = os.path.dirname(os.path.abspath(__file__)) + "/../rotations/" + class_name + ".lua"
        LOG.info("Parsing PlayerEnv in '%s'", file_name)
        line_nr = 0
        try:
            for line in open(file_name).read().split("\n"):
                line_nr = line_nr + 1
                # function kps.env.warlock.isHavocUnit(unit)
                match = re.match(r'.*function\s*kps\.env\..*\.([a-zA-Z]*)\(.*', line)
                if match:
                    function_name = match.group(1)

                    if function_name in self.keys():
                        LOG.warn("%s.lua:%3s - %s DUPLICATE of %s", class_name, line_nr, line, self[function_name])
                    else:
                        self[function_name] = line_nr
        except IOError,e:
            LOG.error("Couldn't parse '%s': %s", file_name, str(e))


class GlobalSpellGroup(object):
    def __init__(self, key, comment):
        self.key = key
        self.comment = comment
        self._key_prefix = "kps.spells.%s." % key
        self._spell_str = []
        self._spell_map = {}

    def add_spell(self, spell_id, key_suffix="", comment=None):
        try:
            spell = Spell(spell_id, key_prefix=self._key_prefix,key_suffix=key_suffix, comment=comment)
            if spell.key in self._spell_map.keys():
                if self._spell_map[spell.key].id == spell_id:
                    raise SpellError("Duplicate SpellID %s" % spell_id)
                else:
                    raise SpellError("Key '%s' already present for SpellID %s (new SpellID: %s)!" % (spell.key, self._spell_map[spell.key].spell_id, spell_id))
            self._spell_map[spell.key] = spell
            self._spell_str.append(str(spell))
        except SpellError as e:
            msg = "-- " + str(e)
            self._spell_str.append(str(msg))
    def add_all_spells(self, spell_ids):
        for spell_id in spell_ids:
            self.add_spell(spell_id)
    def __str__(self):
        header = """

-- %s
kps.spells.%s = {}
%s""" % (self.comment, self.key, "\n".join(self._spell_str))
        return header



class GlobalSpells(object):
    def __init__(self):
        self._groups = {}
    def group(self, key, comment):
        self._groups[key] = GlobalSpellGroup(key, comment)
    def __getattr__(self, key):
        return self._groups[key]

    def __str__(self):
        header = """--[[
Spells:
GENERATED BY *printSpells.py* - DO NOT EDIT MANUALLY!
]]--


kps.spells = {}

%s""" % ("\n".join([str(self._groups[k]) for k in self._groups.keys()]))
        return header
