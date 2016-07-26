--[[[
@module Deathknight Frost Rotation
@generated_from deathknight_frost_1h.simc
@version 7.0.3
]]--
local spells = kps.spells.deathknight
local env = kps.env.deathknight


kps.rotations.register("DEATHKNIGHT","FROST",
{
    {spells.pillarOfFrost}, -- pillar_of_frost
    {spells.sindragosasFury}, -- sindragosas_fury
    {spells.obliteration}, -- obliteration
    {spells.breathOfSindragosa, 'player.runicPower >= 80'}, -- breath_of_sindragosa,if=runic_power>=80
    {{"nested"}, 'target.hasMyDebuff(spells.breathOfSindragosa)', { -- run_action_list,name=bos,if=dot.breath_of_sindragosa.ticking
        {{"nested"}, 'True', { -- call_action_list,name=core
            {spells.glacialAdvance}, -- glacial_advance
-- ERROR in 'frostscythe,if=buff.killing_machine.react|spell_targets.frostscythe>=4': Unknown expression 'spell_targets.frostscythe'!
            {spells.obliterate, 'player.buffStacks(spells.killingMachine)'}, -- obliterate,if=buff.killing_machine.react
-- ERROR in 'remorseless_winter,if=spell_targets.remorseless_winter>=2': Unknown expression 'spell_targets.remorseless_winter'!
            {spells.obliterate}, -- obliterate
-- ERROR in 'frostscythe,if=talent.frozen_pulse.enabled': Unknown Talent 'frozenPulse' for 'deathknight'!
-- ERROR in 'howling_blast,if=talent.frozen_pulse.enabled': Unknown Talent 'frozenPulse' for 'deathknight'!
        }},
        {spells.howlingBlast}, -- howling_blast,target_if=!dot.frost_fever.ticking
        {spells.hornOfWinter}, -- horn_of_winter
        {spells.empowerRuneWeapon}, -- empower_rune_weapon
        {spells.hungeringRuneWeapon}, -- hungering_rune_weapon
        {spells.howlingBlast, 'player.buffStacks(spells.rime)'}, -- howling_blast,if=buff.rime.react
    }},
    {{"nested"}, 'True', { -- call_action_list,name=generic
        {spells.howlingBlast}, -- howling_blast,target_if=!dot.frost_fever.ticking
        {spells.howlingBlast, 'player.buffStacks(spells.rime)'}, -- howling_blast,if=buff.rime.react
        {spells.frostStrike, 'player.runicPower >= 80'}, -- frost_strike,if=runic_power>=80
        {{"nested"}, 'True', { -- call_action_list,name=core
            {spells.glacialAdvance}, -- glacial_advance
-- ERROR in 'frostscythe,if=buff.killing_machine.react|spell_targets.frostscythe>=4': Unknown expression 'spell_targets.frostscythe'!
            {spells.obliterate, 'player.buffStacks(spells.killingMachine)'}, -- obliterate,if=buff.killing_machine.react
-- ERROR in 'remorseless_winter,if=spell_targets.remorseless_winter>=2': Unknown expression 'spell_targets.remorseless_winter'!
            {spells.obliterate}, -- obliterate
-- ERROR in 'frostscythe,if=talent.frozen_pulse.enabled': Unknown Talent 'frozenPulse' for 'deathknight'!
-- ERROR in 'howling_blast,if=talent.frozen_pulse.enabled': Unknown Talent 'frozenPulse' for 'deathknight'!
        }},
        {spells.frostStrike, 'player.hasTalent(7, 3) and spells.breathOfSindragosa.cooldown > 15'}, -- frost_strike,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>15
        {spells.frostStrike, 'not player.hasTalent(7, 3)'}, -- frost_strike,if=!talent.breath_of_sindragosa.enabled
        {spells.hornOfWinter, 'player.hasTalent(7, 3) and spells.breathOfSindragosa.cooldown > 15'}, -- horn_of_winter,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>15
        {spells.empowerRuneWeapon, 'player.hasTalent(7, 3) and spells.breathOfSindragosa.cooldown > 15'}, -- empower_rune_weapon,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>15
        {spells.hungeringRuneWeapon, 'player.hasTalent(7, 3) and spells.breathOfSindragosa.cooldown > 15'}, -- hungering_rune_weapon,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>15
        {spells.hornOfWinter, 'not player.hasTalent(7, 3)'}, -- horn_of_winter,if=!talent.breath_of_sindragosa.enabled
        {spells.empowerRuneWeapon, 'not player.hasTalent(7, 3)'}, -- empower_rune_weapon,if=!talent.breath_of_sindragosa.enabled
        {spells.hungeringRuneWeapon, 'not player.hasTalent(7, 3)'}, -- hungering_rune_weapon,if=!talent.breath_of_sindragosa.enabled
    }},
}
,"deathknight_frost_1h.simc")

--GENERATED FROM SIMCRAFT PROFILE 'deathknight_frost_2h.simc'
kps.rotations.register("DEATHKNIGHT","FROST",
{
    {spells.pillarOfFrost}, -- pillar_of_frost
    {spells.sindragosasFury}, -- sindragosas_fury
    {spells.obliteration}, -- obliteration
    {spells.breathOfSindragosa, 'player.runicPower >= 80'}, -- breath_of_sindragosa,if=runic_power>=80
    {{"nested"}, 'target.hasMyDebuff(spells.breathOfSindragosa)', { -- run_action_list,name=bos,if=dot.breath_of_sindragosa.ticking
        {{"nested"}, 'True', { -- call_action_list,name=core
            {spells.glacialAdvance}, -- glacial_advance
-- ERROR in 'frostscythe,if=buff.killing_machine.react|spell_targets.frostscythe>=4': Unknown expression 'spell_targets.frostscythe'!
            {spells.obliterate, 'player.buffStacks(spells.killingMachine)'}, -- obliterate,if=buff.killing_machine.react
-- ERROR in 'remorseless_winter,if=spell_targets.remorseless_winter>=2': Unknown expression 'spell_targets.remorseless_winter'!
            {spells.obliterate}, -- obliterate
-- ERROR in 'frostscythe,if=talent.frozen_pulse.enabled': Unknown Talent 'frozenPulse' for 'deathknight'!
-- ERROR in 'howling_blast,if=talent.frozen_pulse.enabled': Unknown Talent 'frozenPulse' for 'deathknight'!
        }},
        {spells.howlingBlast}, -- howling_blast,target_if=!dot.frost_fever.ticking
        {spells.hornOfWinter}, -- horn_of_winter
        {spells.empowerRuneWeapon}, -- empower_rune_weapon
        {spells.hungeringRuneWeapon}, -- hungering_rune_weapon
        {spells.howlingBlast, 'player.buffStacks(spells.rime)'}, -- howling_blast,if=buff.rime.react
    }},
    {{"nested"}, 'True', { -- call_action_list,name=generic
        {spells.howlingBlast}, -- howling_blast,target_if=!dot.frost_fever.ticking
        {spells.howlingBlast, 'player.buffStacks(spells.rime)'}, -- howling_blast,if=buff.rime.react
        {spells.frostStrike, 'player.runicPower >= 80'}, -- frost_strike,if=runic_power>=80
        {{"nested"}, 'True', { -- call_action_list,name=core
            {spells.glacialAdvance}, -- glacial_advance
-- ERROR in 'frostscythe,if=buff.killing_machine.react|spell_targets.frostscythe>=4': Unknown expression 'spell_targets.frostscythe'!
            {spells.obliterate, 'player.buffStacks(spells.killingMachine)'}, -- obliterate,if=buff.killing_machine.react
-- ERROR in 'remorseless_winter,if=spell_targets.remorseless_winter>=2': Unknown expression 'spell_targets.remorseless_winter'!
            {spells.obliterate}, -- obliterate
-- ERROR in 'frostscythe,if=talent.frozen_pulse.enabled': Unknown Talent 'frozenPulse' for 'deathknight'!
-- ERROR in 'howling_blast,if=talent.frozen_pulse.enabled': Unknown Talent 'frozenPulse' for 'deathknight'!
        }},
        {spells.frostStrike, 'player.hasTalent(7, 3) and spells.breathOfSindragosa.cooldown > 15'}, -- frost_strike,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>15
        {spells.frostStrike, 'not player.hasTalent(7, 3)'}, -- frost_strike,if=!talent.breath_of_sindragosa.enabled
        {spells.hornOfWinter, 'player.hasTalent(7, 3) and spells.breathOfSindragosa.cooldown > 15'}, -- horn_of_winter,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>15
        {spells.empowerRuneWeapon, 'player.hasTalent(7, 3) and spells.breathOfSindragosa.cooldown > 15'}, -- empower_rune_weapon,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>15
        {spells.hungeringRuneWeapon, 'player.hasTalent(7, 3) and spells.breathOfSindragosa.cooldown > 15'}, -- hungering_rune_weapon,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains>15
        {spells.hornOfWinter, 'not player.hasTalent(7, 3)'}, -- horn_of_winter,if=!talent.breath_of_sindragosa.enabled
        {spells.empowerRuneWeapon, 'not player.hasTalent(7, 3)'}, -- empower_rune_weapon,if=!talent.breath_of_sindragosa.enabled
        {spells.hungeringRuneWeapon, 'not player.hasTalent(7, 3)'}, -- hungering_rune_weapon,if=!talent.breath_of_sindragosa.enabled
    }},
}
,"deathknight_frost_2h.simc")
