--[[[
@module Test-Runner
@description
Test-Runner for KPS. Used to test KPS Functionality.
]]--
    require("_wow")
--LIB:libs\LibStub-1.0\LibStub.lua
--LIB:libs\CallbackHandler-1.0\CallbackHandler-1.0.xml
--LIB:libs\LibRangeCheck-2.0\LibRangeCheck-2.0.lua
require("init")
require("core.logger")
require("core.config")
require("core.kps")
require("core.events")
require("core.locale")
require("core.utils")
require("core.lexer")
require("core.parser")
require("core.rotations")
require("modules.spell.spell")
require("modules.spell.spells")
require("modules.spell.spell_range")
require("modules.spell.spell_state")
require("modules.spell.spell_ticktime")
require("modules.incoming_damage")
require("modules.keys")
require("modules.latency")
require("modules.unlock.basic")
require("modules.unit.unit")
require("modules.unit.unit_auras")
require("modules.unit.unit_casting")
require("modules.unit.unit_info")
require("modules.unit.unit_powers")
require("modules.unit.unit_range")
require("modules.unit.unit_state")
require("modules.player.player")
require("modules.player.player_auras")
require("modules.player.player_eclipse")
require("modules.player.player_powers")
require("modules.player.player_procs")
require("modules.player.player_runes")
require("modules.player.player_stagger")
require("modules.totem")
require("modules.unlock.basic")
require("rotations.deathknight")
require("rotations.druid")
require("rotations.hunter")
require("rotations.mage")
require("rotations.monk")
require("rotations.paladin")
require("rotations.priest")
require("rotations.rogue")
require("rotations.shaman")
require("rotations.warlock")
require("rotations.warrior")
require("env")
require("rotations.deathknight_blood")
require("rotations.deathknight_frost")
require("rotations.deathknight_unholy")
require("rotations.druid_balance")
require("rotations.druid_feral")
require("rotations.druid_guardian")
require("rotations.hunter_beastmaster")
require("rotations.hunter_marksmanship")
require("rotations.hunter_survival")
require("rotations.mage_arcane")
require("rotations.mage_fire")
require("rotations.mage_frost")
require("rotations.monk_brewmaster")
require("rotations.monk_windwalker")
require("rotations.paladin_protection")
require("rotations.paladin_retribution")
require("rotations.priest_discipline")
require("rotations.priest_holy")
require("rotations.priest_shadow")
require("rotations.rogue_assassination")
require("rotations.rogue_combat")
require("rotations.rogue_subtlety")
require("rotations.warlock_affliction")
require("rotations.warlock_demonology")
require("rotations.warlock_destruction")
require("rotations.warrior_arms")
require("rotations.warrior_fury")
require("rotations.warrior_protection")
require("gui.gui")
require("gui.toggle")
require("gui.slashcmd")


kps.combatStep()
