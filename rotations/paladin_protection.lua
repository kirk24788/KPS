--[[[
@module Paladin Protection Rotation
@generated_from paladin_protection.simc
@version 7.2
]]--
local spells = kps.spells.paladin
local env = kps.env.paladin


kps.rotations.register("PALADIN","PROTECTION","paladin_protection.simc").setCombatTable(
{
-- ERROR in 'speed_of_light,if=movement.remains>1': Spell 'speedOfLight' unknown!
    {spells.holyAvenger}, -- holy_avenger
    {spells.seraphim}, -- seraphim
    {spells.divineProtection, 'player.timeInCombat < 5 or not player.hasTalent(7, 2) or ( not player.hasBuff(spells.seraphim) and spells.seraphim.cooldown > 5 and spells.seraphim.cooldown < 9 )'}, -- divine_protection,if=time<5|!talent.seraphim.enabled|(buff.seraphim.down&cooldown.seraphim.remains>5&cooldown.seraphim.remains<9)
    {spells.guardianOfAncientKings, 'player.timeInCombat < 5 or ( not player.hasBuff(spells.holyAvenger) and not player.hasBuff(spells.shieldOfTheRighteous) and not player.hasBuff(spells.divineProtection) )'}, -- guardian_of_ancient_kings,if=time<5|(buff.holy_avenger.down&buff.shield_of_the_righteous.down&buff.divine_protection.down)
    {spells.ardentDefender, 'player.timeInCombat < 5 or ( not player.hasBuff(spells.holyAvenger) and not player.hasBuff(spells.shieldOfTheRighteous) and not player.hasBuff(spells.divineProtection) and not player.hasBuff(spells.guardianOfAncientKings) )'}, -- ardent_defender,if=time<5|(buff.holy_avenger.down&buff.shield_of_the_righteous.down&buff.divine_protection.down&buff.guardian_of_ancient_kings.down)
-- ERROR in 'eternal_flame,if=buff.eternal_flame.remains<2&buff.bastion_of_glory.react>2&(holy_power>=3|buff.divine_purpose.react|buff.bastion_of_power.react)': Spell 'eternalFlame' unknown!
-- ERROR in 'eternal_flame,if=buff.bastion_of_power.react&buff.bastion_of_glory.react>=5': Spell 'eternalFlame' unknown!
    {spells.shieldOfTheRighteous, 'player.buffStacks(spells.divinePurpose)'}, -- shield_of_the_righteous,if=buff.divine_purpose.react
    {spells.shieldOfTheRighteous, '( player.holyPower >= 5 or player.incomingDamage >= player.hpMax * 0.3 ) and ( not player.hasTalent(7, 2) or spells.seraphim.cooldown > 5 )'}, -- shield_of_the_righteous,if=(holy_power>=5|incoming_damage_1500ms>=health.max*0.3)&(!talent.seraphim.enabled|cooldown.seraphim.remains>5)
    {spells.shieldOfTheRighteous, 'player.buffDuration(spells.holyAvenger) > player.timeToNextHolyPower and ( not player.hasTalent(7, 2) or spells.seraphim.cooldown > player.timeToNextHolyPower )'}, -- shield_of_the_righteous,if=buff.holy_avenger.remains>time_to_hpg&(!talent.seraphim.enabled|cooldown.seraphim.remains>time_to_hpg)
-- ERROR in 'seal_of_insight,if=talent.empowered_seals.enabled&!seal.insight&buff.uthers_insight.remains<cooldown.judgment.remains': Spell 'sealOfInsight' unknown!
-- ERROR in 'seal_of_righteousness,if=talent.empowered_seals.enabled&!seal.righteousness&buff.uthers_insight.remains>cooldown.judgment.remains&buff.liadrins_righteousness.down': Spell 'sealOfRighteousness' unknown!
-- ERROR in 'avengers_shield,if=buff.grand_crusader.react&active_enemies>1&!glyph.focused_shield.enabled': Spell 'kps.spells.paladin.glyphOfFocusedShield' unknown (in expression: 'glyph.focused_shield.enabled')!
    {spells.hammerOfTheRighteous, 'activeEnemies.count >= 3'}, -- hammer_of_the_righteous,if=active_enemies>=3
    {spells.crusaderStrike}, -- crusader_strike
-- ERROR in 'judgment,cycle_targets=1,if=glyph.double_jeopardy.enabled&last_judgment_target!=target': Spell 'kps.spells.paladin.glyphOfDoubleJeopardy' unknown (in expression: 'glyph.double_jeopardy.enabled')!
    {spells.judgment}, -- judgment
-- ERROR in 'avengers_shield,if=active_enemies>1&!glyph.focused_shield.enabled': Spell 'kps.spells.paladin.glyphOfFocusedShield' unknown (in expression: 'glyph.focused_shield.enabled')!
    {spells.holyWrath, 'player.hasTalent(5, 2)'}, -- holy_wrath,if=talent.sanctified_wrath.enabled
    {spells.avengersShield, 'player.buffStacks(spells.grandCrusader)'}, -- avengers_shield,if=buff.grand_crusader.react
-- ERROR in 'sacred_shield,if=target.dot.sacred_shield.remains<2': Spell 'sacredShield' unknown!
-- ERROR in 'holy_wrath,if=glyph.final_wrath.enabled&target.health.pct<=20': Spell 'kps.spells.paladin.glyphOfFinalWrath' unknown (in expression: 'glyph.final_wrath.enabled')!
    {spells.avengersShield}, -- avengers_shield
    {spells.lightsHammer, 'not player.hasTalent(7, 2) or player.buffDuration(spells.seraphim) > 10 or spells.seraphim.cooldown < 6'}, -- lights_hammer,if=!talent.seraphim.enabled|buff.seraphim.remains>10|cooldown.seraphim.remains<6
    {spells.holyPrism, 'not player.hasTalent(7, 2) or player.hasBuff(spells.seraphim) or spells.seraphim.cooldown > 5 or player.timeInCombat < 5'}, -- holy_prism,if=!talent.seraphim.enabled|buff.seraphim.up|cooldown.seraphim.remains>5|time<5
    {spells.consecration, ' and activeEnemies.count >= 3'}, -- consecration,if=target.debuff.flying.down&active_enemies>=3
    {spells.executionSentence, 'not player.hasTalent(7, 2) or player.hasBuff(spells.seraphim) or player.timeInCombat < 12'}, -- execution_sentence,if=!talent.seraphim.enabled|buff.seraphim.up|time<12
-- ERROR in 'hammer_of_wrath': Spell 'hammerOfWrath' unknown!
-- ERROR in 'sacred_shield,if=target.dot.sacred_shield.remains<8': Spell 'sacredShield' unknown!
    {spells.consecration, ''}, -- consecration,if=target.debuff.flying.down
    {spells.holyWrath}, -- holy_wrath
-- ERROR in 'seal_of_insight,if=talent.empowered_seals.enabled&!seal.insight&buff.uthers_insight.remains<=buff.liadrins_righteousness.remains': Spell 'sealOfInsight' unknown!
-- ERROR in 'seal_of_righteousness,if=talent.empowered_seals.enabled&!seal.righteousness&buff.liadrins_righteousness.remains<=buff.uthers_insight.remains': Spell 'sealOfRighteousness' unknown!
-- ERROR in 'sacred_shield': Spell 'sacredShield' unknown!
-- ERROR in 'flash_of_light,if=talent.selfless_healer.enabled&buff.selfless_healer.stack>=3': Spell 'kps.spells.paladin.selflessHealer' unknown (in expression: 'buff.selfless_healer.stack')!
})
