#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import re
import os
import logging
import argparse
import spells

from kps import ParserError, lower_case, setup_logging_and_get_args

LOG = logging.getLogger(__name__)

NUMBER=1
EXPRESSION=2
COMPERATOR=3
BRACKET=4
BINARY_OPERATOR=4
UNARY_OPERATOR=5

def _convert_spell(spell):
    return lower_case(spell.replace("_", " ").title().replace(" ", ""))

def _convert_fn(fn):
    return lower_case(fn.replace("_", " ").replace(".", " ").title().replace(" ", ""))


def _post_process(tokens):
    """Post-Process Condition Tokens"""
    for idx, (token_type, token) in enumerate(tokens):
        # health.pct returns an integer value - we have to convert the number to decimal
        if token_type == EXPRESSION and token == "health.pct":
            # LeftHand Operation
            if len(tokens) > idx+2 and tokens[idx+1][0] == COMPERATOR and tokens[idx+2][0] == NUMBER:
                tokens[idx+2] = (NUMBER, str(int(tokens[idx+2][1])/100.0))
                #tokens[idx+2][1] = str(int(tokens[idx+2][1])/100.0)
            # RightHand Operation
            elif idx >= 2 and tokens[idx-1][0] == COMPERATOR and tokens[idx-2][0] == NUMBER:
                tokens[idx-2] = (NUMBER, str(int(tokens[idx-2][1])/100.0))
               # tokens[idx-2][1] = str(int(tokens[idx-2][1])/100.0)
            # health.pct error
            else:
                raise ParserError("Couldn't postprocess token '%s'" % (token))
    return tokens

_DIRECT_PRECONVERSIONS = [
    ("!disease.min_ticking", "disease.ticking"),
]

_REGEX_PRECONVERSIONS = [
    (r'movement\.remains\>\d*\.?\d*', "movement.remains"),
]

_EXPESSION_CONVERSIONS = [
    ("runic_power", "player.runicPower"),
    ("health.pct", "player.hp"),
    ("health.max", "player.hpMax"),
    ("target.health.pct", "target.hp"),
    ("target.time_to_die", "target.timeToDie"),
    ("gcd", "player.gcd"),
    ("incoming_damage_5s", "kps.incomingDamage(5)"),
    ("movement.remains", "player.isMoving"),
    ("active_enemies", "activeEnemies()"),
    ("level", "player.level"),
    ("buff.bloodlust.up", "player.bloodlust"),
    # DK specific
    ("blood", "player.bloodRunes"),
    ("frost", "player.frostRunes"),
    ("unholy", "player.unholyRunes"),
    ("blood.death", "player.bloodDeathRunes"),
    ("frost.death", "player.frostDeathRunes"),
    ("unholy.death", "player.unholyDeathRunes"),
    ("blood.frac", "player.bloodFraction"),
    ("frost.frac", "player.frostFraction"),
    ("unholy.frac", "player.unholyFraction"),
    ("Blood", "player.bloodOrDeathRunes"),
    ("Frost", "player.frostOrDeathRunes"),
    ("Unholy", "player.unholyOrDeathRunes"),
    ("death", "player.deathRunes"),
    # Druid specific
    ("lunar_max","player.eclipseLunarMax"),
    ("solar_max","player.eclipseSolarMax"),
    ("eclipse_energy", "player.eclipsePower"),
]


_IGNOREABLE_SPELLS = [
    'auto_attack', # No need to add auto-attack
    'potion', # don't use potions!
    'blood_fury', # Orc Racial
    'berserking', # Troll Racial
    'arcane_torrent', # BloodElf Racial
    'use_item', # Use of Items deativated
]

_TALENTS = {
    "deathknight":  ["plaguebearer", "plagueLeech", "unholyBlight",
                    "lichborne", "antiMagicZone", "purgatory",
                    "deathsAdvance", "chilblains", "asphyxiate",
                    "bloodTap", "runicEmpowerment", "runicCorruption",
                    "deathPact", "deathSiphon", "conversion",
                    "gorefiendsGrasp", "remoreselessWinter", "desecratedGround",
                    "necroticPlague", "defile", "breathOfSindragosa"],
    "druid":        ["felineSwiftness","displacerBeast","wildCharge"
                    "yserasGift","renewal","cenarionWard"
                    "faerieSwarm","massEntanglement","typhoon"
                    "soulOfTheForest","incarnationChosenOfElune","forceOfNature"
                    "incapacitatingRoar","ursolsVortex","mightyBash"
                    "heartOfTheWild","dreamOfCenarius","naturesVigil"
                    "euphoria","stellarFlare","balanceOfPower"],
    "warlock":      ["darkRegeneration", "soulLeech", "searingFlames",
                    "howlOfTerror", "mortalCoil", "shadowfury",
                    "","",""
                    "","",""
                    "","",""
                    "","",""
                    "soulLink", "sacrificialPact", "darkBargain"],
}


def _pre_tokenize(condition):
    for (old,new) in _DIRECT_PRECONVERSIONS:
        condition = condition.replace(old, new)
    for (rex,new) in _REGEX_PRECONVERSIONS:
        condition = re.sub(rex, new, condition)
    return condition

def _tokenize(condition):
    """Tokenize a SimC condition"""
    scanner=re.Scanner([
        (r"\d+(.\d+)?",       lambda scanner,token:(NUMBER, token)),
        (r"[a-zA-Z][a-zA-Z_.0-9]+",      lambda scanner,token:(EXPRESSION, token)),
        (r"(\<\=|\>\=|\=|\<|\>)",      lambda scanner,token:(COMPERATOR, token)),
        (r"[\(\)]",        lambda scanner,token:(BRACKET, token)),
        (r"\&",        lambda scanner,token:(BINARY_OPERATOR, "and")),
        (r"\|",        lambda scanner,token:(BINARY_OPERATOR, "or")),
        (r"\!",        lambda scanner,token:(UNARY_OPERATOR, "not")),
        (r"[*+-/%]",        lambda scanner,token:(BINARY_OPERATOR, token)),
        (r"\s+", None), # None == skip token.
    ])

    results, remainder=scanner.scan(condition)
    if len(remainder) > 0:
        raise ParserError("Couldn't tokenize '%s' - error at: %s" % (condition, remainder))
    return _post_process(results)

class Condition(object):
    def __init__(self, condition, profile):
        self.condition = condition
        self.profile = profile
        self.player_spells = profile.player_spells
        self.player_env = profile.player_env
        self.tokens = _tokenize(_pre_tokenize(condition))
        self.__convert_tokens()

    def __str__(self):
        return self.kps

    def __convert_tokens(self):
        condition_parts = []
        for token_type, token in self.tokens:
            if token_type == EXPRESSION:
                condition_parts.append(self.__convert_condition(token))
            else:
                condition_parts.append(token)
        self.kps = " ".join(condition_parts)

    def __convert_condition(self, expression):
        for sc,kps in _EXPESSION_CONVERSIONS:
            if expression==sc:
                return kps

        m = re.search("buff\.(.*)\.(up|down|react|stack)", expression)
        if m:
            buff = _convert_spell(m.group(1))
            buff_key = "kps.spells.%s.%s" % (self.player_spells.class_name, buff)
            if buff not in self.player_spells.keys():
                raise ParserError("Spell '%s' unknown (in expression: '%s')!" % (buff_key, expression))
            state = m.group(2)
            if state == "up":
                return "player.hasBuff(spells.%s)" % buff
            elif state == "down":
                return "target.hasMyDebuff(spells.%s)" % buff
            elif state == "react" or state == "stack":
                return "player.buffStacks(spells.%s)" % buff
            else:
                raise ParserError("Unknown Buff State '%s'" % state)


        m = re.search("talent\.(.*)\.enabled", expression)
        if m:
            talent_name = _convert_spell(m.group(1))
            if talent_name not in _TALENTS[self.player_spells.class_name]:
                raise ParserError("Unknown Talent '%s' for '%s'!" % (talent_name, self.player_spells.class_name))
            idx = _TALENTS[self.player_spells.class_name].index(talent_name)
            row = 1+(idx / 3 )
            talent = 1+(idx % 3 )
            return "player.hasTalent(%s, %s)" % (row, talent)

        m = re.search("dot\.(.*)\.(ticking|remains)", expression)
        if m:
            dot = _convert_spell(m.group(1))
            dot_key = "kps.spells.%s.%s" % (self.player_spells.class_name, dot)
            if dot not in self.player_spells.keys():
                raise ParserError("Spell '%s' unknown (in expression: '%s')!" % (dot_key, expression))
            state = m.group(2)
            if state == "ticking":
                return "target.hasMyDebuff(spells.%s)" % dot
            elif state == "remains":
                return "target.myDebuffDuration(spells.%s)" % dot
            else:
                raise ParserError("Unknown Buff State '%s'" % state)

        m = re.search("cooldown\.(.*)\.(remains)", expression)
        if m:
            cd = _convert_spell(m.group(1))
            cd_key = "kps.spells.%s.%s" % (self.player_spells.class_name, cd)
            if cd not in self.player_spells.keys():
                raise ParserError("Spell '%s' unknown (in expression: '%s')!" % (cd_key, expression))
            state = m.group(2)
            if state == "remains":
                return "spells.%s.cooldown" % cd
            else:
                raise ParserError("Unknown Buff State '%s'" % state)

        m = re.search("(.*)\.(ready_in)", expression)
        if m:
            cd = _convert_spell(m.group(1))
            cd_key = "kps.spells.%s.%s" % (self.player_spells.class_name, cd)
            if cd not in self.player_spells.keys():
                raise ParserError("Spell '%s' unknown (in expression: '%s')!" % (cd_key, expression))
            state = m.group(2)
            if state == "ready_in":
                return "spells.%s.cooldown" % cd
            else:
                raise ParserError("Unknown State '%s'" % state)

        fn = _convert_fn(expression)
        if fn in self.player_env.keys():
            return "%s()" % fn

        raise ParserError("Unkown expression '%s'!" % expression)








class Action(object):
    def __init__(self, action, profile, indent):
        self.simc_action = action
        self.profile = profile
        self.player_spells = profile.player_spells
        self.player_env = profile.player_env
        self.indent = indent
        parts = action.split(",if=")
        if len(parts) > 1:
            try:
                self.condition = Condition(parts[1], profile)
                self.comment = None
            except ParserError,e:
                LOG.warn("Error while converting condition '%s': %s" % (parts[1], str(e)))
                self.condition = "SimC Conversion ERROR"
                self.comment = "ERROR in '%s': %s" % (parts[1], str(e))
        else:
            self.condition = None
            self.comment = None

    @staticmethod
    def parse(action, profile, indent=1):
        if action.startswith("call_action_list") or action.startswith("run_action_list"):
            return NestedActions(action, profile, indent)
        else:
            return SpellAction(action, profile, indent)


class SpellAction(Action):
    def __init__(self, action, profile, indent):
        Action.__init__(self, action, profile, indent)
        self.spell = self.convert_spell(action.split(",")[0])
        self.spell_key = "kps.spells.%s.%s" % (profile.player_spells.class_name, self.spell)
        if self.spell not in profile.player_spells:
            raise ParserError("Spell '%s' unknown!" % self.spell)
    def __str__(self):
        prefix = " "*(self.indent*4)
        if self.comment:
            comment = " -- " + self.comment
        else:
            comment = ""
        if self.condition:
            return "%s{spells.%s, '%s'},%s" % (prefix, self.spell, self.condition, comment)
        else:
            return "%s{spells.%s},%s" % (prefix, self.spell, comment)

    def convert_spell(self, spell):
        return lower_case(spell.replace("_", " ").title().replace(" ", ""))

class NestedActions(Action):
    def __init__(self, action, profile, indent):
        Action.__init__(self, action, profile, indent)
        name = action.split(",")[1].split("=")[1]
        self.actions = []
        for a in profile.get_action_sublist(name):
            try:
                self.actions.append(Action.parse(a, profile, self.indent+1))
            except ParserError,e:
                LOG.warn("Error while converting condition '%s': %s" % (a, str(e)))

    def __str__(self):
        if self.condition:
            condition = self.condition
        else:
            condition = "True"
        if self.comment:
            comment = " -- " + self.comment
        else:
            comment = ""
        prefix = " "*(self.indent*4)
        s = """%s{{"nested"}, '%s', {%s\n""" % (prefix, condition, comment)
        for a in self.actions:
            s = s + str(a) + "\n"
        s = s + prefix + "},"
        return s

class SimCraftProfile(object):

    def __init__(self, filename, kps_class, kps_spec=None, kps_title=None):
        LOG.info("Parsing SimCraftProfile: %s", filename)
        self.filename = filename
        self.player_spells = spells.PlayerSpells(kps_class)
        self.player_env = spells.PlayerEnv(kps_class)
        self.kps_class = kps_class
        self.kps_spec = kps_spec
        if kps_title:
            self.kps_title = kps_title
        else:
            self.kps_title = os.path.basename(filename)
        try:
            self.actions = []
            self.nested_actions = {}
            all_lines = open(filename).read().split("\n")
            for line in all_lines:
                if line.startswith("actions="):
                    action_condition = line[8:]
                    if not self.__is_filtered(action_condition):
                        self.actions.append(action_condition)
                        LOG.debug("ACTION: %s", action_condition)
                    else:
                        LOG.debug("FILTERED: %s", line)
                elif line.startswith("actions+=/"):
                    action_condition = line[10:]
                    if not self.__is_filtered(action_condition):
                        self.actions.append(action_condition)
                        LOG.debug("ACTION: %s", action_condition)
                    else:
                        LOG.debug("FILTERED: %s", line)
                elif line.startswith("actions."):
                    list_name,action_condition = line[8:].split("=", 1)
                    if list_name[-1] == "+":
                        list_name = list_name[:-1]
                        action_condition = action_condition[1:]
                    if list_name != "precombat":

                        if not self.__is_filtered(action_condition):
                            try:
                                self.nested_actions[list_name]
                            except KeyError:
                                self.nested_actions[list_name] = []
                            self.nested_actions[list_name].append(action_condition)
                            LOG.debug("ACTION[%s]: %s", list_name, action_condition)
                        else:
                            LOG.debug("FILTERED: %s", line)

                    else:
                        LOG.debug("SKIP[precombat]: %s", line)
                elif line.startswith("spec=") and not self.kps_spec:
                    self.kps_spec = line[5:]
                else:
                    LOG.debug("SKIP: %s", line)
        except IOError,e:
            raise ParserError("Couldn't read simcraft profile '%s': %s" % (filename, str(e)))

    def __is_filtered(self, line):
        for spell in _IGNOREABLE_SPELLS:
            if line.startswith(spell):
                return True
        return False

    def get_action_sublist(self, key):
        return self.nested_actions[key]

    def convert_to_action_list(self):
        action_list = []
        for a in self.actions:
            try:
                action_list.append(Action.parse(a, self))
            except ParserError,e:
                LOG.warn("Error while converting condition '%s': %s" % (a, str(e)))
        return action_list

    def __str__(self):
        header = """--[[
@module %s %s Rotation
GENERATED FROM SIMCRAFT PROFILE: %s
]]\n""" %(self.kps_class.title(), self.kps_spec.title(), os.path.basename(self.filename))
        header += "local spells = kps.spells.%s\n" % self.kps_class
        header += "local env = kps.env.%s\n\n" % self.kps_class
        header += """kps.rotations.register("%s","%s",\n{\n""" % (self.kps_class.upper(),self.kps_spec.upper())
        for r in simc.convert_to_action_list():
            header += "%s\n" % r
        header += """}\n,"%s")""" % self.kps_title
        return header

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='SimC 2 KPS Rotation Converter')
    parser.add_argument('-p','--simc-profile', dest="simc", help='SimC Profile', required=True)
    parser.add_argument('-c','--kps-class', dest="kps_class", help='KPS Class', required=True, choices=spells.SUPPORTED_CLASSES)
    parser.add_argument('-s','--kps-spec', dest="kps_spec", help='KPS Spec', required=True)
    parser.add_argument('-t','--title', help='KPS Rotation Title', default=None)
    parser.add_argument('-o','--output', help='Output file (omit to print to stdout)', default=None)
    args = setup_logging_and_get_args(parser)
    simc = SimCraftProfile(args.simc, args.kps_class, args.kps_spec, args.title)
    if args.output:
        open(args.output,"w").write(str(simc))
    else:
        print simc


