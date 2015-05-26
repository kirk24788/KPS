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

ADDITIONAL_SPELLS = {
    "deathknight": [114851],
    "druid": [164545,164547,171743,171744,117679,135201],
    "hunter": [168980],
    "mage": [166872,145254,48107,166868,101166,135029],
    "monk": [115307,121286,116768,118864,159407,145008,125359],
    "paladin": [114637,117809,156989,156988,144595,156990,166831],
    "priest": [179337,167254],
    "rogue": [84747],
    "shaman": [157765,114074,115356],
    "warlock": [77801,157698,163512,104316,103964,104025,124915,89751,115831,115625],
    "warrior": [],
}

SPELL_BLACKLIST = [
    "Leather Specialization",
]

ENV_FUNCTIONS = {
    "deathknight": """
kps.env.deathknight = {}

function kps.env.deathknight.diseaseMinRemains(unit)
    minTimeLeft = min(unit.myDebuffDuration(kps.spells.deathknight.bloodPlague),
                      unit.myDebuffDuration(kps.spells.deathknight.frostFever))
    if player.hasTalent(7, 1) then -- Necrotic Plague Talent
        return min(minTimeLeft, unit.myDebuffDuration(kps.spells.deathknight.necroticPlague))
    else
        return minTimeLeft
    end
end

function kps.env.deathknight.diseaseMaxRemains(unit)
    maxTimeLeft = max(unit.myDebuffDuration(kps.spells.deathknight.bloodPlague),
                      unit.myDebuffDuration(kps.spells.deathknight.frostFever))
    if player.hasTalent(7, 1) then -- Necrotic Plague Talent
        return max(maxTimeLeft, unit.myDebuffDuration(kps.spells.deathknight.necroticPlague))
    else
        return maxTimeLeft
    end
end

function kps.env.deathknight.diseaseTicking(unit)
    return kps.env.deathknight.diseaseMinRemains(unit) > 0
end

function kps.env.deathknight.diseaseMaxTicking(unit)
    return kps.env.deathknight.diseaseMaxRemains(unit) > 0
end""",
    "druid": """""",
    "hunter": """""",
    "mage": """
kps.env.mage = {}

local burnPhase = false
function kps.env.mage.burnPhase()
    if not burnPhase then
        -- At the start of the fight and whenever Evocation Icon Evocation is about to come off cooldown, you need to start the Burn Phase
        -- and burn your Mana. Before doing so, make sure that you have 3 charges of Arcane Missiles and 4 stacks of Arcane Charge.
        burnPhase = kps.env.player.timeInCombat < 5 or kps.spells.mage.evocation.cooldown < 2
    else
        burnPhase = kps.env.player.mana > 0.35
    end
    return burnPhase
end

local incantersFlowDirection = 0
local incantersFlowLastStacks = 0
function kps.env.mage.incantersFlowDirection()
    local stack = select(4, UnitBuff("player", GetSpellInfo(116267)))
    if stack < incantersFlowLastStacks then
        incantersFlowDirection = -1
        incantersFlowLastStacks = stack
    elseif stack > incantersFlowLastStacks then
        incantersFlowDirection = 1
        incantersFlowLastStacks = stack
    end
    return encantersFlowDirection
end

local pyroChain = false
local pyroChainEnd = 0
function kps.env.mage.pyroChain()
    if not pyroChain then
        -- Combustion sequence initialization
        -- This sequence lists the requirements for preparing a Combustion combo with each talent choice
        -- Meteor Combustion:
        --    actions.init_combust=start_pyro_chain,if=talent.meteor.enabled&cooldown.meteor.up&((cooldown.combustion.remains<gcd.max*3&buff.pyroblast.up&(buff.heating_up.up^action.fireball.in_flight))|(buff.pyromaniac.up&(cooldown.combustion.remains<ceil(buff.pyromaniac.remains%gcd.max)*gcd.max)))
        -- Prismatic Crystal Combustion without 2T17:
        --    actions.init_combust+=/start_pyro_chain,if=talent.prismatic_crystal.enabled&!set_bonus.tier17_2pc&cooldown.prismatic_crystal.up&((cooldown.combustion.remains<gcd.max*2&buff.pyroblast.up&(buff.heating_up.up^action.fireball.in_flight))|(buff.pyromaniac.up&(cooldown.combustion.remains<ceil(buff.pyromaniac.remains%gcd.max)*gcd.max)))
        -- Prismatic Crystal Combustion with 2T17:
        --    actions.init_combust+=/start_pyro_chain,if=talent.prismatic_crystal.enabled&set_bonus.tier17_2pc&cooldown.prismatic_crystal.up&cooldown.combustion.remains<gcd.max*2&buff.pyroblast.up&(buff.heating_up.up^action.fireball.in_flight)
        -- Unglyphed Combustions between Prismatic Crystals:
        --    actions.init_combust+=/start_pyro_chain,if=talent.prismatic_crystal.enabled&!glyph.combustion.enabled&cooldown.prismatic_crystal.remains>20&((cooldown.combustion.remains<gcd.max*2&buff.pyroblast.up&buff.heating_up.up&action.fireball.in_flight)|(buff.pyromaniac.up&(cooldown.combustion.remains<ceil(buff.pyromaniac.remains%gcd.max)*gcd.max)))
        -- Kindling or Level 90 Combustion:
        --    actions.init_combust+=/start_pyro_chain,if=!talent.prismatic_crystal.enabled&!talent.meteor.enabled&((cooldown.combustion.remains<gcd.max*4&buff.pyroblast.up&buff.heating_up.up&action.fireball.in_flight)|(buff.pyromaniac.up&cooldown.combustion.remains<ceil(buff.pyromaniac.remains%gcd.max)*(gcd.max+talent.kindling.enabled)))

        --TODO!!!
        -- pyroChainStart = GetTime()
        return false
    else
        -- actions=stop_pyro_chain,if=prev_off_gcd.combustion
        pyroChain = kps.env.player.mana > 0.35
    end
    return pyroChain
end
function kps.env.mage.pyroChainDuration()
    local duration = pyroChainEnd - GetTime()
    if duration < 0 then return 0 else return duration end
end
""",
    "monk": """""",
    "paladin": """""",
    "priest": """""",
    "rogue": """""",
    "shaman": """""",
    "warlock": """
kps.env.warlock = {}

function kps.env.warlock.isHavocUnit(unit)
    if not UnitExists(unit) then  return false end
    if UnitIsUnit("target",unit) then return false end
    return true
end
local burningRushLastMovement = 0
function kps.env.warlock.deactivateBurningRushIfNotMoving(seconds)
    return function ()
        if not seconds then seconds = 0 end
        local player = kps.env.player
        if player.isMoving or not player.hasBuff(kps.spells.warlock.burningRush) then
            burningRushLastMovement = GetTime()
        else
            local nonMovingDuration = GetTime() - burningRushLastMovement
            if nonMovingDuration >= seconds then
                RunMacroText("/cancelaura " .. kps.spells.warlock.burningRush)
            end
        end
    end
end
""",
    "warrior": """""",
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

_ALREADY_SEEN = []
def is_filtered(spell):
    if spell["name"] in _ALREADY_SEEN:
        return (True, "Duplicate")
    else:
        _ALREADY_SEEN.append(spell["name"])
    if spell["name"] in SPELL_BLACKLIST:
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
%s Spells and Environment Functions.
GENERATED FROM WOWHEAD SPELLS - DO NOT EDIT MANUALLY
]]--

kps.spells.%s = {}

""" % (class_name.title(), class_name.title(), class_name)
    for spell in spells:
        if not is_filtered(spell)[0]:
            s += "kps.spells.%s.%s = kps.Spell.fromId(%s)\n" % (class_name,spell_key(spell["name"][1:]),spell["id"])
    for spell_id in ADDITIONAL_SPELLS[class_name]:
        spell = Spell(spell_id)
        s += "kps.spells.%s.%s = kps.Spell.fromId(%s)\n" % (class_name, spell.key, spell.id)
    return s + "\n" + ENV_FUNCTIONS[class_name] + "\n"

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Loads Class Spells from Wowhead')
    parser.add_argument('-c','--class', dest='class_name', help='Set the class to scan', required=True, choices=spells.SUPPORTED_CLASSES)
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


