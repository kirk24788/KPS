#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import re
import os
import logging
import argparse
import spells

from kps import ParserError, lower_case, setup_logging_and_get_args, parse_rotation_meta
from config import SUPPORTED_SPECS
from config import WOW_VERSION

LOG = logging.getLogger(__name__)

NUMBER=1
EXPRESSION=2
COMPERATOR=3
BRACKET=4
BINARY_OPERATOR=4
UNARY_OPERATOR=5

_SPELL_CONVERSION = {
    "deathknight":  {
    }, "druid":  {
        "king_of_the_jungle":"incarnationKingOfTheJungle",
        "wild_charge_movement":"wildCharge",
        "thrash_cat":"thrash",
        "thrash_bear":"thrash",
        "moonfire_cat":"moonfire",
    }, "hunter": {
    }, "mage": {
    }, "monk": {
        "combo_breaker_bok":"comboBreakerBlackoutKick",
        "combo_breaker_tp":"comboBreakerTigerPalm",
        "combo_breaker_ce":"comboBreakerChiExplosion",
        "combo_breaker_e":"comboBreakerEnergize",
        "invoke_xuen":"invokeXuenTheWhiteTiger",
    }, "paladin": {
    }, "priest": {
       "holy_word":"holyWordChastise",
    }, "rogue": {
    }, "shaman": {
        "shock":"flameShock", # All Shocks share the same cd?
    }, "warlock": {
        "cancel_metamorphosis":"metamorphosis",
        "felguard:felstorm":"felstorm",
        "wrathguard:wrathstorm":"wrathstorm",
        "wrathguard:mortal_cleave":"mortalCleave",
    }, "warrior": {
    },
}

def _convert_spell(spell, profile):
    if spell in _SPELL_CONVERSION[profile.kps_class].keys():
        return _SPELL_CONVERSION[profile.kps_class][spell]
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

_CLASS_REGEX_PRECONVERSIONS = {
    "deathknight":  [
    ], "druid":  [
    ], "hunter": [
    ], "mage":  [
        (r"glyph.cone_of_cold.enabled","glyph.cone_of_cold.enabled&target_distance <= 12"),
        (r"(current_)?target!=prismatic_crystal","target.npc_id!=76933"),
        (r"(current_)?target=prismatic_crystal","target.npc_id=76933"),
        (r"pet.prismatic_crystal.active","pet.npc_id=76933"),
        (r"pet.prismatic_crystal.remains","cooldown.prismatic_crystal.remains-78"), # no actual pet remains, but cooldown is 90 sec, duration is 12 sec
    ], "monk":  [
        (r"buff\.elusive_brew_stacks\.react","buff.elusive_brew.stacks"),
        (r"buff\.elusive_brew_stacks\.stack","buff.elusive_brew.stacks"),
        (r"buff\.elusive_brew_activated\.down","buff.elusive_brew.down"),
        (r"debuff.([a-z_]*)_target.down", lambda x: "debuff."+x.group(1)+".down"),
        (r"buff.([a-z_]*)_use.down", lambda x: "debuff."+x.group(1)+".down"),
    ], "paladin":  [
        (r'([\!\&\|\(])seal.([a-z_]*)([\!\&\|\)])', lambda x: x.group(1) + "buff.seal_of_" + x.group(2) + ".up" + x.group(3)),
    ], "priest":  [
        (r'moving\=1', "movement.remains"), # seems to be only used in spriest rotation
        (r'primary_target\=0', ""), # ?
        (r'natural_shadow_word_death_range', ""), # ?
        (r'devouring_plague_(dot|tick)', "devouring_plague"),
        (r',interrupt=1', ""),
        (r'.*shadowy_apparitions_in_flight.*', "IGNORE_LINE"),
        (r'.*mind_harvest.*', "IGNORE_LINE"),
    ], "rogue":  [
        (r'dot.deadly_poison_dot.ticking',"dot.deadly_poison.ticking"),
        (r'anticipation_charges',"buff.anticipation.stacks"),
        (r'position_front',""),
    ], "shaman":  [
        (r"pet.([a-z_]*).remains", lambda x: "totem."+x.group(1)+".remains"),
        (r"pet.([a-z_]*).active", lambda x: "totem."+x.group(1)+".active"),
    ], "warlock":  [
    ], "warrior":  [
        (r'buff.colossus_smash_up.up', "buff.colossus_smash.up"), # ?
        (r'buff.ravager_protection.up', "buff.ravager.up"), # ?
        (r'.*desired_targets.*', "IGNORE_LINE"),
    ],

}
_CMP_ = r'\s*[\<\>\=]*\s*'
_NR_ = r'\d*\.?\d*'
_TOKEN_ = r'[\.a-z_]*'
_NR_OR_TOKEN_ = r'\d*\.?\d*[\.a-z_]*'
_REGEX_PRECONVERSIONS = [
    (r'(.*)active_dot\.([a-z_]*)'+_CMP_+_NR_+r'(.*)', lambda x: x.group(1)+"dot."+x.group(2)+".ticking"+x.group(3)), # convert active_dot.XXX <=> Y.Y to dot.XXX.ticking
    (r'(.*)active_dot\.([a-z_]*)'+_CMP_+_TOKEN_+r'(.*)', lambda x: x.group(1)+"dot."+x.group(2)+".ticking"+x.group(3)), # convert active_dot.XXX <=> YYY to dot.XXX.ticking
    (r'set_bonus.tier[0-9]*_[0-9]pc(_caster|_melee)?', ""), # remove tXX set boni
    (r'\!?t[0-9]*_class_trinket(\|\&)?', ""), # remove tXX trinkets
    (r'raid_event\.movement\.distance\>\d*\.?\d*', "movement.remains"), # not predictable, isMoving will be closest equivalent
    (r'raid_event\.movement\.in'+_CMP_+r'[1-9\s\+\-\*\.a-z_]*', "movement.remains"), # not predictable, isMoving will be closest equivalent
    (r'movement\.remains\>\d*\.?\d*', "movement.remains"), # not predictable, isMoving will be closest equivalent
    (r'raid_event\.adds\.in'+_CMP_+r'[1-9\s\+\-\*\.a-z_]*', ""), # not predictable, remove
    (r'raid_event\.adds\.cooldown', ""), # not predictable, remove
    (r'raid_event\.adds\.count', ""), # not predictable, remove
    (r'raid_event\.movement\.cooldown', ""), # not predictable, remove
    (r'[a-z]*\.[a-z_]*\.pmultiplier', "1"), # ???
    (r'persistent_multiplier', "1"), # ???
    (r'(action\.[a-z_]*\.)?travel_time', "1"), # Remove travel_time, no equivalent!
    (r'([a-z_\.]*[-+*])?cast_regen([\s\-+*][a-z_\.]*)?[\s\<\>\=]*[0-9]*', ""), # cast_regen is too complicated, depends on too much information
    (r'.*buff.archmages_greater_incandescence_agi.remains.*',"IGNORE_LINE"), # TODO: needs greater incendescnence module!
    (r'miss_react', ""), # no info on spell misses
    (r',cycle_targets.*',""), # remove trailing "cycle_targets"
    (r',chain=.*',""), # remove trailing "chain=" condition
    (r',interrupt_if.*',""), # remove trailing "interrupt_if" condition
    (r'\(\)', ""), # remove useless paranthesis left from previous replacements
    (r'\&\&', "&"), # remove double operators left from previous replacements
    (r'\|\|', "|"), # remove double operators left from previous replacements
    (r'[\|\&]\)', ")"), # remove dangling operators in paranthesis from previous replacements
    (r'\([\|\&]', "("), # remove dangling operators in paranthesis from previous replacements
    (r'^[\&\|](.*)', lambda x: x.group(1)), # remove leading operators left from previous replacements
    (r'(.*)[\&\|]$', lambda x: x.group(1)), # remove trailing operators left from previous replacements
    (r'^$', "EMPTY_EXPRESSION"),
]

_CLASS_EXPRESSION_CONVERSIONS = {
    "deathknight":  [
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
        ("buff.potion.up","player.hasStrProc"),
        ("disease.ticking","diseaseTicking(target)"),
    ], "druid":  [
        ("lunar_max","player.eclipseLunarMax"),
        ("solar_max","player.eclipseSolarMax"),
        ("eclipse_energy", "player.eclipsePower"),
        ("eclipse_change", "player.eclipseChange"),
    ], "hunter": [
        ("buff.potion.up","player.hasAgiProc"),
        ("trinket.proc.any.react","player.hasAgiProc"),
        ("trinket.proc.any.remains",""),
        ("cooldown.potion.remains",""),
    ], "mage":  [
        ("spell_haste","1"),
        ("incanters_flow_dir","incanters_flow_direction"),
    ], "monk":  [
        ("stagger.light","player.staggerPercent < 0.035"),
        ("stagger.moderate","player.staggerPercent >= 0.035 and player.staggerPercent < 0.065"),
        ("stagger.heavy","player.staggerPercent >= 0.065"),
    ], "paladin":  [
        ("target.debuff.flying.down",""), # ignore flying check, used for desecration
        ("time_to_hpg","player.timeToNextHolyPower"),
    ], "priest":  [
        ("target.dot.devouring_plague.ticks_remain", "(target.myDebuffDuration(spells.devouringPlague)/spells.devouringPlague.tickTime)"),
    ], "rogue":  [
    ], "shaman":  [
        ("buff.lightning_shield.max_stack","7"),
        ("totem.fire.active","totem.fire.isActive"),
        ("totem.earth.active","totem.earth.isActive"),
        ("totem.water.active","totem.water.isActive"),
        ("totem.air.active","totem.air.isActive"),
    ], "warlock":  [
        ("shard_react", "player.soulShards>0"),
    ], "warrior":  [
        ("buff.potion.up","player.hasStrProc"),
    ],
}

_EXPRESSION_CONVERSIONS = [
    ("runic_power", "player.runicPower"),
    ("health.percent", "player.hp"),
    ("health.pct", "player.hp"),
    ("health.max", "player.hpMax"),
    ("mana.pct", "player.mana"),
    ("target.distance", "target.distance"),
    ("target_distance", "target.distance"),
    ("target.health.percent", "target.hp"),
    ("target.health.pct", "target.hp"),
    ("target.time_to_die", "target.timeToDie"),
    ("gcd", "player.gcd"),
    ("gcd.max", "player.gcd"),
    ("incoming_damage_1s", "kps.incomingDamage(1)"),
    ("incoming_damage_1500ms", "kps.incomingDamage(1.5)"),
    ("incoming_damage_2500ms", "kps.incomingDamage(2.5)"),
    ("incoming_damage_5s", "kps.incomingDamage(5)"),
    ("incoming_damage_10s", "kps.incomingDamage(10)"),
    ("movement.remains", "player.isMoving"),
    ("movement.distance", "target.distance"),
    ("in_flight","player.isMoving"),
    ("raid_event.movement.exists","player.isMoving"),
    ("active_enemies", "activeEnemies.count"),
    ("raid_event.adds.exists", "activeEnemies.count"),
    ("level", "player.level"),
    ("buff.bloodlust.up", "player.bloodlust"),
    ("buff.bloodlust.remains", "player.buffDuration(spells.bloodlust)"),
    ("cooldown_react","player.hasProc"),
    ("trinket.stat.any.up","player.hasProc"),
    ("trinket.stat.intellect.up","player.hasIntProc"),
    ("buff.archmages_incandescence_agi.up","player.hasAgiProc"),
    ("buff.archmages_greater_incandescence_agi.up","player.hasAgiProc"),
    ("buff.archmages_incandescence_agi.react","player.hasAgiProc"),
    ("buff.archmages_greater_incandescence_agi.react","player.hasAgiProc"),
    ("trinket.stacking_proc.any.react","player.hasProc"),
    ("trinket.proc.any.react","player.hasProc"),
    ("trinket.proc.all.react","player.hasProc"),
    ("energy.time_to_max","player.energyTimeToMax"),
    ("energy.max","player.energyMax"),
    ("energy.regen","player.energyRegen"),
    ("energy","player.energy"),
    ("focus.time_to_max","player.focusTimeToMax"),
    ("focus.max","player.focusMax"),
    ("focus.regen","player.focusRegen"),
    ("focus.deficit","(player.focusMax-player.focus)"),
    ("focus","player.focus"),
    ("chi.max","player.chiMax"),
    ("chi","player.chi"),
    ("soul_shard", "player.soulShards"),
    ("demonic_fury","player.demonicFury"),
    ("shadow_orb","player.shadowOrbs"),
    ("holy_power","player.holyPower"),
    ("combo_points","target.comboPoints"),
    ("rage","player.rage"),
    ("rage.max","player.rageMax"),
    ("target.npc_id","target.npcId"),
    ("pet.npc_id","pet.npcId"),
    ("time","player.timeInCombat"),
]


_IGNOREABLE_SPELLS = [
    'auto_attack', # No need to add auto-attack
    'auto_shot', # No need to add auto-attack
    'potion', # don't use potions!
    'blood_fury', # Orc Racial
    'berserking', # Troll Racial
    'arcane_torrent', # BloodElf Racial
    'shadowmeld', # Night Elf Racial
    'stoneform', # Dwarf Racial
    'use_item', # Use of Items deativated
    'pool_resource', # ?
    'wait', # No wait...yet
    'choose_target', # Can't switch tagets...
    'start_burn_phase',
    'stop_burn_phase',
    'start_pyro_chain',
    'stop_pyro_chain',
]

_TALENTS = {
    "deathknight":  ["plaguebearer", "plagueLeech", "unholyBlight",
                    "lichborne", "antiMagicZone", "purgatory",
                    "deathsAdvance", "chilblains", "asphyxiate",
                    "bloodTap", "runicEmpowerment", "runicCorruption",
                    "deathPact", "deathSiphon", "conversion",
                    "gorefiendsGrasp", "remoreselessWinter", "desecratedGround",
                    "necroticPlague", "defile", "breathOfSindragosa"],
    "druid":        ["felineSwiftness","displacerBeast","wildCharge",
                    "yserasGift","renewal","cenarionWard",
                    "faerieSwarm","massEntanglement","typhoon",
                    "soulOfTheForest","incarnation|incarnationChosenOfElune|incarnationKingOfTheJungle|incarnationSonOfUrsoc","forceOfNature",
                    "incapacitatingRoar","ursolsVortex","mightyBash",
                    "heartOfTheWild","dreamOfCenarius","naturesVigil",
                    "euphoria|lunarInspiration|guardianOfElune","stellarFlare|bloodtalons|pulverize","balanceOfPower|clawsOfShirvallah|bristlingFur"],
    "hunter":       ["posthaste", "narrowEscape","crouchingTigerHiddenChimaera",
                    "bindingShot","wyvernSting","intimidation",
                    "exhilaration","ironHawk","spiritBond",
                    "steadyFocus","direBeast","thrillOfTheHunt",
                    "aMurderOfCrows","blinkStrikes","stampede",
                    "glaiveToss","powershot","barrage",
                    "exoticMunitions","focusingShot","adaptation",
                    ],
    "mage":         ["evanesce", "blazingSpeed", "iceFloes",
                    "alterTime", "flameglow", "iceBarrier",
                    "ringOfFrost","iceWard","frostjaw",
                    "greaterInvisibility","cauterize","coldSnap",
                    "frostBomb|livingBomb","unstableMagic","iceNova|blastWave",
                    "mirrorImage","runeOfPower","incantersFlow",
                    "overpowered|kindling|thermalVoid", "prismaticCrystal", "arcaneOrb|meteor|cometStorm"],
    "monk":         ["celerity","tigersLust","momentum",
                    "chiWaves","zenSphere","chiBurst",
                    "powerStrikes","ascension","chiBrew",
                    "ringOfPeace","chargingOxWave","legSweep",
                    "healingElixirs","dampenHarm","diffuseMagic",
                    "rushingJadeWind","invokeXuen|invokeXuenTheWhiteTiger","chiTorpedo",
                    "soulDance|hurricaneStrike","chiExplosion","serenity"],
    "paladin":      ["speedOfLight","longArmOfTheLaw","pursuitOfJustice",
                    "fistOfJustice","repentance","blindingLight",
                    "selflessHealer","eternalFlame","sacredShield",
                    "handOfPurity","unbreakableSpirit","clemency",
                    "holyAvenger","sanctifiedWrath","divinePurpose",
                    "holyPrism","lightsHammer","executionSentence",
                    "empoweredSeals","seraphim","holyShield|finalVerdict"],
    "priest":       ["despreatePrayer","spectralGuise","angelicBulkward",
                    "bodyAndSoul","angelicFeather","phantasm",
                    "surgeOfLight|surgeOfDarkness","mindbender","powerWordSolace|insanity",
                    "voidTendrils","psychicScream","dominateMind",
                    "twistOfFate","powerInfusion","spiritShell",
                    "cascade","divineStar","halo",
                    "clarityOfWill|clarityOfPower","wordsOfMending|voidEntropy","savingGrace|auspiciousSpirits"],
    "rogue":        ["nightstalker","subterfuge","shadowFocus",
                    "deadlyThrow","nerveStrike","combatReadiness",
                    "cheatDeath","LeechingPoison","Elusiveness",
                    "CloadAndDagger","shadowstep","burstOfSpeed",
                    "preyOnTheWeak","internalBleeding","dirtyTricks",
                    "shurikenToss","markedForDeath","anticipation",
                    "venomRush","shadowReflection","deathFromAbove"],
    "shaman":       ["naturesGuardian","stoneBulwarkTotem","astralShift",
                    "frozenPower","earthgrabTotem","windwalkTotem",
                    "callOfTheElements","totemicPersistence","totemicProjection",
                    "elementalMastery","ancestralSwiftness","echoOfTheElements",
                    "rushingStreams","ancestralGuidance","conductivity",
                    "unleashedFury","primalElementalist","elementalBlast",
                    "elementalFusion","storeElementalTotem","liquidMagma"],
    "warlock":      ["darkRegeneration", "soulLeech", "searingFlames",
                    "howlOfTerror", "mortalCoil", "shadowfury",
                    "soulLink","sacrificialPact","darkBargain",
                    "bloodHorror","burningRush","unboundWill",
                    "grimoireOfSupremecy","grimoireOfService","grimoireOfSacrifice",
                    "archimondesDarkness","kiljaedensCunning","mannorothsFury",
                    "soulburnHaunt|demonbolt|charredRemains", "cataclysm", "demonicServitude"],
    "warrior":      ["juggernaut","doubleTime","warbringer",
                    "enragedRegeneration","secondWind","impendingVictory",
                    "tasteForBlood","suddenDeath","slam|unquenchableThirst|unyieldingStrikes",
                    "stormBolt","shockwave","dragonRoar",
                    "massSpellReflection","safeguard","vigilance",
                    "avatar","bloodbath","bladestorm",
                    "angerManagement","ravager","siegebreaker"],
}


def _pre_tokenize(condition, profile):
    for (old,new) in _DIRECT_PRECONVERSIONS:
        condition = condition.replace(old, new)
    for (rex,new) in _CLASS_REGEX_PRECONVERSIONS[profile.kps_class]:
        condition = re.sub(rex, new, condition)
    for (rex,new) in _REGEX_PRECONVERSIONS:
        condition = re.sub(rex, new, condition)
    return condition

def _tokenize(condition):
    """Tokenize a SimC condition"""
    scanner=re.Scanner([
        (r"\d+(.\d+)?",       lambda scanner,token:(NUMBER, token)),
        (r"[a-zA-Z][a-zA-Z_.0-9]+",      lambda scanner,token:(EXPRESSION, token)),
        (r"\=",      lambda scanner,token:(COMPERATOR, "==")),
        (r"\!\=",        lambda scanner,token:(COMPERATOR, "=")),
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
    def __init__(self, condition, profile, condition_spell=None):
        self.condition = condition
        self.profile = profile
        self.player_spells = profile.player_spells
        self.player_env = profile.player_env
        self.condition_spell = condition_spell
        self.tokens = _tokenize(_pre_tokenize(condition, self.profile))
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
        for sc,kps in _CLASS_EXPRESSION_CONVERSIONS[self.profile.kps_class]:
            if expression==sc:
                return kps
        for sc,kps in _EXPRESSION_CONVERSIONS:
            if expression==sc:
                return kps

        m = re.search(r"buff\.(.*)\.(up|down|react|stack|remains|duration)", expression)
        if m:
            buff = _convert_spell(m.group(1), self.profile)
            buff_key = "kps.spells.%s.%s" % (self.player_spells.class_name, buff)
            if buff not in self.player_spells.keys():
                raise ParserError("Spell '%s' unknown (in expression: '%s')!" % (buff_key, expression))
            state = m.group(2)
            if state == "up":
                return "player.hasBuff(spells.%s)" % buff
            elif state == "down":
                return "not player.hasBuff(spells.%s)" % buff
            elif state == "react" or state == "stack":
                return "player.buffStacks(spells.%s)" % buff
            elif state == "remains":
                return "player.buffDuration(spells.%s)" % buff
            elif state == "duration":
                return "player.buffDurationMax(spells.%s)" % buff
            else:
                raise ParserError("Unknown Buff State '%s'" % state)


        m = re.search(r"talent\.(.*)\.enabled", expression)
        if m:
            talent_name = _convert_spell(m.group(1), self.profile)
            def talentIndex(talent_name):
                if talent_name in _TALENTS[self.player_spells.class_name]:
                    return _TALENTS[self.player_spells.class_name].index(talent_name)
                for talent in _TALENTS[self.player_spells.class_name]:
                    if "|" in talent and talent_name in talent.split("|"):
                        return _TALENTS[self.player_spells.class_name].index(talent)
                raise ParserError("Unknown Talent '%s' for '%s'!" % (talent_name, self.player_spells.class_name))

            idx = talentIndex(talent_name)
            row = 1+(idx / 3 )
            talent = 1+(idx % 3 )
            return "player.hasTalent(%s, %s)" % (row, talent)

        m = re.search(r"dot\.(.*)\.(ticking|remains|stack|duration)", expression)
        if m:
            dot = _convert_spell(m.group(1), self.profile)
            dot_key = "kps.spells.%s.%s" % (self.player_spells.class_name, dot)
            if dot not in self.player_spells.keys():
                raise ParserError("Spell '%s' unknown (in expression: '%s')!" % (dot_key, expression))
            state = m.group(2)
            if state == "ticking":
                return "target.hasMyDebuff(spells.%s)" % dot
            elif state == "remains":
                return "target.myDebuffDuration(spells.%s)" % dot
            elif state == "stack":
                return "target.debuffStacks(spells.%s)" % dot
            elif state == "duration":
                return "player.myDebuffDurationMax(spells.%s)" % dot
            else:
                raise ParserError("Unknown Buff State '%s'" % state)

        m = re.search(r"glyph\.(.*)\.(enabled)", expression)
        if m:
            glyph = _convert_spell("glyph_of_"+m.group(1), self.profile)
            glyph_key = "kps.spells.%s.%s" % (self.player_spells.class_name, glyph)
            if glyph not in self.player_spells.keys():
                raise ParserError("Spell '%s' unknown (in expression: '%s')!" % (glyph_key, expression))
            state = m.group(2)
            if state == "enabled":
                return "player.hasGlyph(spells.%s)" % glyph
            else:
                raise ParserError("Unknown Buff State '%s'" % state)

        m = re.search(r"cooldown\.(.*)\.(remains|up|duration)", expression)
        if m:
            cd = _convert_spell(m.group(1), self.profile)
            cd_key = "kps.spells.%s.%s" % (self.player_spells.class_name, cd)
            if cd not in self.player_spells.keys():
                raise ParserError("Spell '%s' unknown (in expression: '%s')!" % (cd_key, expression))
            state = m.group(2)
            if state == "remains":
                return "spells.%s.cooldown" % cd
            elif state == "up":
                return "spells.%s.cooldown == 0" % cd
            elif state == "duration":
                return "spells.%s.cooldownTotal" % cd
            else:
                raise ParserError("Unknown Buff State '%s'" % state)

        m = re.search(r"action\.(.*)\.(execute_time|in_flight|in_flight_to_target|charges_fractional|charges|cast_time|cooldown)", expression)
        if m:
            action = _convert_spell(m.group(1), self.profile)
            action_key = "kps.spells.%s.%s" % (self.player_spells.class_name, action)
            if action not in self.player_spells.keys():
                raise ParserError("Spell '%s' unknown (in expression: '%s')!" % (action_key, expression))
            state = m.group(2)
            if state == "execute_time":
                return "spells.%s.castTime" % action
            elif state == "in_flight" or state == "in_flight_to_target":
                return "spells.%s.isRecastAt(\"target\")" % action
            elif state == "charges" or state == "charges_fractional":
                return "spells.%s.charges" % action
            elif state == "cast_time":
                return "spells.%s.castTime" % action
            elif state == "cooldown":
                return "spells.%s.cooldown" % action
            else:
                raise ParserError("Unknown Buff State '%s'" % state)

        m = re.search(r"(.*)\.(ready_in)", expression)
        if m:
            cd = _convert_spell(m.group(1), self.profile)
            cd_key = "kps.spells.%s.%s" % (self.player_spells.class_name, cd)
            if cd not in self.player_spells.keys():
                raise ParserError("Spell '%s' unknown (in expression: '%s')!" % (cd_key, expression))
            state = m.group(2)
            if state == "ready_in":
                return "spells.%s.cooldown" % cd
            else:
                raise ParserError("Unknown State '%s'" % state)

        m = re.search(r"prev_gcd\.(.*)", expression)
        if m:
            spell = _convert_spell(m.group(1), self.profile)
            spell_key = "kps.spells.%s.%s" % (self.player_spells.class_name, spell)
            if spell not in self.player_spells.keys():
                raise ParserError("Spell '%s' unknown (in expression: '%s')!" % (cd_key, expression))
            return "spells.%s.isRecastAt(\"target\")" % spell

        m = re.search(r"prev_off_gcd\.(.*)", expression)
        if m:
            spell = _convert_spell(m.group(1), self.profile)
            spell_key = "kps.spells.%s.%s" % (self.player_spells.class_name, spell)
            if spell not in self.player_spells.keys():
                raise ParserError("Spell '%s' unknown (in expression: '%s')!" % (cd_key, expression))
            return "spells.%s.isRecastAt(\"target\")" % spell

        m = re.search(r"totem\.(.*)\.(remains|active)", expression)
        if m:
            spell = _convert_spell(m.group(1), self.profile)
            spell_key = "kps.spells.%s.%s" % (self.player_spells.class_name, spell)
            if spell not in self.player_spells.keys():
                raise ParserError("Spell '%s' unknown (in expression: '%s')!" % (spell_key, expression))
            state = m.group(2)
            if state == "remains":
                return "totem.duration(spells.%s)" % spell
            elif state == "active":
                return "totem.isActive(spells.%s)" % spell
            else:
                raise ParserError("Unknown Totem State '%s'" % state)

        fn = _convert_fn(expression)
        if fn in self.player_env.keys():
            return "%s()" % fn

        if self.condition_spell:
            if expression=="charges" or expression=="charges_fractional":
                return "spells.%s.charges" % self.condition_spell
            if expression=="recharge_time": # TODO: Check if recharge_time is actally the cooldown OR just the time to the next charge
                return "spells.%s.cooldown" % self.condition_spell
            if expression=="remains":
                return "target.myDebuffDuration(spells.%s)" % self.condition_spell
            if expression=="cast_time":
                return "spells.%s.castTime" % self.condition_spell
            if expression=="tick_time":
                return "spells.%s.tickTime" % self.condition_spell
            if expression=="ticking":
                return "target.hasMyDebuff(spells.%s)" % self.condition_spell
            if expression == "execute_time":
                return "spells.%s.castTime" % self.condition_spell
            if expression=="ticks_remain":
                return "(target.myDebuffDuration(spells.%s)/spells.%s.tickTime)" % (self.condition_spell,self.condition_spell)
            if expression == "duration":
                return "target.myDebuffDurationMax(spells.%s)" % self.condition_spell
            if expression == "in_flight" or expression == "in_flight_to_target":
                return "spells.%s.isRecastAt(\"target\")" % self.condition_spell
            if expression == "enemies":
                return "activeEnemies.count"

        if expression == "EMPTY_EXPRESSION":
            raise ParserError("Empty Expression after RegEx Replacements", silent=True)
        if expression == "IGNORE_LINE":
            raise ParserError("Line Skipped", silent=True)

        raise ParserError("Unknown expression '%s'!" % expression)








class Action(object):
    def __init__(self, action, profile, indent, condition_spell=None):
        self.simc_action = action
        self.profile = profile
        self.player_spells = profile.player_spells
        self.player_env = profile.player_env
        self.indent = indent
        parts = action.split(",if=")
        if len(parts) > 1:
            try:
                self.condition = Condition(parts[1], profile,condition_spell)
                self.error_description = None
            except ParserError,e:
                if not e.silent:
                    LOG.warn("Error while converting condition '%s': %s" % (parts[1], str(e)))
                self.condition = "SimC Conversion ERROR"
                self.error_description = "%s '%s': %s" % ("SKIP" if e.silent else "ERROR in", self.simc_action, str(e))
        else:
            self.condition = None
            self.error_description = None

    @staticmethod
    def parse(action, profile, indent=1):
        if action.startswith("call_action_list") or action.startswith("run_action_list"):
            return NestedActions(action, profile, indent)
        else:
            return SpellAction(action, profile, indent)


class SpellAction(Action):
    def __init__(self, action, profile, indent):
        Action.__init__(self, action, profile, indent, _convert_spell(action.split(",")[0], profile))
        self.spell = _convert_spell(action.split(",")[0], profile)
        self.spell_key = "kps.spells.%s.%s" % (profile.player_spells.class_name, self.spell)
        if self.spell not in profile.player_spells:
            raise ParserError("Spell '%s' unknown!" % self.spell)
    def __str__(self):
        prefix = " "*(self.indent*4)
        if self.error_description:
            return "-- " + self.error_description
        else:
            comment = " -- " + self.simc_action
        if self.condition:
            return "%s{spells.%s, '%s'},%s" % (prefix, self.spell, self.condition, comment)
        else:
            return "%s{spells.%s},%s" % (prefix, self.spell, comment)

class NestedActions(Action):
    def __init__(self, action, profile, indent):
        Action.__init__(self, action, profile, indent)
        name = action.split(",")[1].split("=")[1]
        self.actions = []
        try:
            for a in profile.get_action_sublist(name):
                try:
                    self.actions.append(Action.parse(a, profile, self.indent+1))
                except ParserError,e:
                    if not e.silent:
                        LOG.warn("Error while converting nested action '%s': %s" % (a, str(e)))
        except KeyError:
            LOG.warn("No Action SubList '%s' in: %s", name, action)
    def __str__(self):
        if self.condition:
            condition = self.condition
        else:
            condition = "True"
        if self.error_description:
            return "-- " + self.error_description
        else:
            comment = " -- " + self.simc_action
        prefix = " "*(self.indent*4)
        s = """%s{{"nested"}, '%s', {%s\n""" % (prefix, condition, comment)
        for a in self.actions:
            s = s + str(a) + "\n"
        s = s + prefix + "}},"
        return s

class SimCraftProfile(object):

    def __init__(self, filename, kps_class, kps_spec=None, kps_title=None):
        LOG.info("Parsing SimCraftProfile: %s", filename)
        self.filename = filename
        self.show_header = True
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
                if not e.silent:
                    LOG.warn("Error while converting to actionList '%s': %s" % (a, str(e)))
                action_list.append("-- %s '%s': %s" % ("SKIP" if e.silent else "ERROR in", a, str(e)))
        return action_list

    def __str__(self):
        if self.show_header:
            header = """--[[[
@module %s %s Rotation
@generated_from %s
@version %s
]]--\n""" %(self.kps_class.title(), self.kps_spec.title(), os.path.basename(self.filename), WOW_VERSION)
            header += "local spells = kps.spells.%s\n" % self.kps_class
            header += "local env = kps.env.%s\n\n" % self.kps_class
        else:
            header = "\n--GENERATED FROM SIMCRAFT PROFILE '%s'" % os.path.basename(self.filename)
        rota = """kps.rotations.register("%s","%s",\n{\n""" % (self.kps_class.upper(),self.kps_spec.upper())
        for r in simc.convert_to_action_list():
            rota += "%s\n" % r
        rota += """}\n,"%s")""" % self.kps_title
        return header + "\n" + rota + "\n"

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='SimC 2 KPS Rotation Converter')
    parser.add_argument('-p','--simc-profile', dest="simc", help='SimC Profile', required=True)
    parser.add_argument('-c','--kps-class', dest="kps_class", help='KPS Class', required=True, choices=SUPPORTED_SPECS.keys())
    parser.add_argument('-s','--kps-spec', dest="kps_spec", help='KPS Spec', required=True)
    parser.add_argument('-t','--title', help='KPS Rotation Title', default=None)
    group = parser.add_mutually_exclusive_group()
    group.add_argument('-o','--output', help='Output file (omit to print to stdout)', default=None)
    group.add_argument('-a','--append', help='Append file (omit to print to stdout)', default=None)
    args = setup_logging_and_get_args(parser)
    meta = parse_rotation_meta(args.kps_class, args.kps_spec)
    if "generated" in meta.keys():
        simc = SimCraftProfile(args.simc, args.kps_class, args.kps_spec, args.title)
        if args.output:
            open(args.output,"w").write(str(simc))
        elif args.append:
            simc.show_header = False
            open(args.append,"a").write(str(simc))
        else:
            print simc
    else:
        LOG.info("Skipping %s:%s - Manual rotation" % (args.kps_class, args.kps_spec))



