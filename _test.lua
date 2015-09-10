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
require("core.timers")
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
require("modules.player.player_seals")
require("modules.player.player_stagger")
require("modules.auto_turn")
require("modules.totem")
require("modules.spell_id")
require("modules.unlock.basic")
require("modules.heal.heal")
require("modules.heal.raid_status")
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
require("core.settings")

-- Self-Made Asserts
function is(expected)
    return {expected, function (actual)
        return actual == expected
    end}
end
function isNot(expected)
    return {expected, function (actual)
        return actual ~= expected
    end}
end
function assertThat(description, actual, expected)
    if not expected[2](actual) then
        local e = expected[1] ~= nil and ("'"..expected[1].."'") or "nil"
        local a = actual ~= nil and ("'"..actual.."'") or "nil"
        print("Test Failure: " .. description .. "\n  Expected: " .. e .. "\n    Actual: " .. a)
        os.exit(1)
    end
end

-- Rotation Condition Helper Functions
function _testErroneuosConditions(op)
    print("Testing Erroneuos Condition '"..op.."'...")
    local spellTable = kps.parser.parseSpellTable({{kps.spells.warlock.rainOfFire, op, "focus"},{kps.spells.warlock.lifeTap, "true"}})
    local spell, target = spellTable()
    assertThat("Erroneuos Condition '"..op.."'", spell, is(kps.spells.warlock.lifeTap))
    assertThat("Erroneuos Condition '"..op.."'", target, is("target"))
    print("...OK")
end
function _testCondition(op)
    print("Testing Condition '"..op.."'...")
    local spellTable = kps.parser.parseSpellTable({{kps.spells.warlock.rainOfFire, op}})
    local spell, target = spellTable()
    assertThat("Condition '"..op.."'", spell, is(kps.spells.warlock.rainOfFire))
    assertThat("Condition '"..op.."'", target, is("target"))
    print("...OK")
end

-- Test simple conditions
_testCondition("(((true)))")
_testCondition("player.buffDuration(spells.rainOfFire) < 1.5")
_testCondition("(5>4)")
_testCondition("11%9%6")
_testCondition("player.buffDuration(spells.rainOfFire, 3) < 1.5")


-- Test errors in conditions - erroneous conditions mustn't be executed, but shouldn't intefere with the rest of the rotation
_testErroneuosConditions("false or ((5>4) and true")

-- Test Parsing of Arithmethic Operations in Conditions
_testCondition("1 + 3 + 2 == 6")
_testCondition("1 + 3 - 2 == 2")
_testCondition("4%2 == 0")
_testCondition("2 * 3 + 2 == 8")


--Test Parameter List Values
print("Testing Parameter List Values...")
local parameterListValues = 0
kps.env.testMe = function (a,b)
    parameterListValues = a + b 
    return true
end
local spellTable = kps.parser.parseSpellTable({{kps.spells.warlock.rainOfFire, "kps.env.testMe(1,2)"}})
local spell, target = spellTable()
assertThat("Parameter List Values", parameterListValues, is(3))
assertThat("Parameter List Values", spell, is(kps.spells.warlock.rainOfFire))
assertThat("Parameter List Values", target, is("target"))
print("...OK")


-- Test Combat Steps (Warlock)
print("Testing Warlock Combat Rotation...")
kps.combatStep()
print("...OK")