--[[
@module Paladin Retribution Rotation
GENERATED FROM SIMCRAFT PROFILE 'paladin_retribution.simc'
]]
local spells = kps.spells.paladin
local env = kps.env.paladin


kps.rotations.register("PALADIN","RETRIBUTION",
{
    {spells.rebuke}, -- rebuke
    {spells.speedOfLight, 'target.distance > 5'}, -- speed_of_light,if=movement.distance>5
    {spells.judgment, 'player.hasTalent(7, 1) and player.timeInCombat < 2'}, -- judgment,if=talent.empowered_seals.enabled&time<2
    {spells.executionSentence}, -- execution_sentence
    {spells.lightsHammer}, -- lights_hammer
    {spells.holyAvenger, 'player.hasTalent(7, 2)'}, -- holy_avenger,sync=seraphim,if=talent.seraphim.enabled
    {spells.holyAvenger, 'player.holyPower <= 2 and not player.hasTalent(7, 2)'}, -- holy_avenger,if=holy_power<=2&!talent.seraphim.enabled
    {spells.avengingWrath, 'player.hasTalent(7, 2)'}, -- avenging_wrath,sync=seraphim,if=talent.seraphim.enabled
    {spells.avengingWrath, 'not player.hasTalent(7, 2)'}, -- avenging_wrath,if=!talent.seraphim.enabled
    {spells.seraphim}, -- seraphim
    {{"nested"}, 'activeEnemies() >= 3', { -- call_action_list,name=cleave,if=active_enemies>=3
        {spells.finalVerdict, 'target.hasMyDebuff(spells.finalVerdict) and player.holyPower == 5'}, -- final_verdict,if=buff.final_verdict.down&holy_power=5
        {spells.divineStorm, 'player.buffStacks(spells.divineCrusader) and player.holyPower == 5 and player.hasBuff(spells.finalVerdict)'}, -- divine_storm,if=buff.divine_crusader.react&holy_power=5&buff.final_verdict.up
        {spells.divineStorm, 'player.holyPower == 5 and player.hasBuff(spells.finalVerdict)'}, -- divine_storm,if=holy_power=5&buff.final_verdict.up
        {spells.divineStorm, 'player.buffStacks(spells.divineCrusader) and player.holyPower == 5 and not player.hasTalent(7, 3)'}, -- divine_storm,if=buff.divine_crusader.react&holy_power=5&!talent.final_verdict.enabled
        {spells.divineStorm, 'player.holyPower == 5 and ( not player.hasTalent(7, 2) or spells.seraphim.cooldown > player.gcd * 4 ) and not player.hasTalent(7, 3)'}, -- divine_storm,if=holy_power=5&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*4)&!talent.final_verdict.enabled
        {spells.hammerOfWrath}, -- hammer_of_wrath
        {spells.judgment, 'player.hasTalent(7, 1) and player.hasBuff(spells.sealOfRighteousness) and player.buffDuration(spells.liadrinsRighteousness) < spells.judgment.cooldownTotal'}, -- judgment,if=talent.empowered_seals.enabled&seal.righteousness&buff.liadrins_righteousness.remains<cooldown.judgment.duration
        {spells.exorcism, 'player.hasBuff(spells.blazingContempt) and player.holyPower <= 2 and target.hasMyDebuff(spells.holyAvenger)'}, -- exorcism,if=buff.blazing_contempt.up&holy_power<=2&buff.holy_avenger.down
        {spells.divineStorm, 'player.buffStacks(spells.divineCrusader) and player.hasBuff(spells.finalVerdict) and ( player.hasBuff(spells.avengingWrath) or target.hp < 35 )'}, -- divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
        {spells.divineStorm, 'player.hasBuff(spells.finalVerdict) and ( player.hasBuff(spells.avengingWrath) or target.hp < 35 )'}, -- divine_storm,if=buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
        {spells.finalVerdict, 'target.hasMyDebuff(spells.finalVerdict) and ( player.hasBuff(spells.avengingWrath) or target.hp < 35 )'}, -- final_verdict,if=buff.final_verdict.down&(buff.avenging_wrath.up|target.health.pct<35)
        {spells.divineStorm, 'player.buffStacks(spells.divineCrusader) and ( player.hasBuff(spells.avengingWrath) or target.hp < 35 ) and not player.hasTalent(7, 3)'}, -- divine_storm,if=buff.divine_crusader.react&(buff.avenging_wrath.up|target.health.pct<35)&!talent.final_verdict.enabled
        {spells.divineStorm, 'player.holyPower == 5 and ( player.hasBuff(spells.avengingWrath) or target.hp < 35 ) and ( not player.hasTalent(7, 2) or spells.seraphim.cooldown > player.gcd * 3 ) and not player.hasTalent(7, 3)'}, -- divine_storm,if=holy_power=5&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*3)&!talent.final_verdict.enabled
        {spells.divineStorm, 'player.holyPower == 4 and ( player.hasBuff(spells.avengingWrath) or target.hp < 35 ) and ( not player.hasTalent(7, 2) or spells.seraphim.cooldown > player.gcd * 4 ) and not player.hasTalent(7, 3)'}, -- divine_storm,if=holy_power=4&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*4)&!talent.final_verdict.enabled
        {spells.divineStorm, 'player.holyPower == 3 and ( player.hasBuff(spells.avengingWrath) or target.hp < 35 ) and ( not player.hasTalent(7, 2) or spells.seraphim.cooldown > player.gcd * 5 ) and not player.hasTalent(7, 3)'}, -- divine_storm,if=holy_power=3&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*5)&!talent.final_verdict.enabled
        {spells.hammerOfTheRighteous, 'activeEnemies() >= 4 and player.holyPower < 5 and player.hasTalent(7, 2)'}, -- hammer_of_the_righteous,if=active_enemies>=4&holy_power<5&talent.seraphim.enabled
        {spells.hammerOfTheRighteous, 'activeEnemies() >= 4 and ( player.holyPower <= 3 or ( player.holyPower == 4 and target.hp >= 35 and target.hasMyDebuff(spells.avengingWrath) ) )'}, -- hammer_of_the_righteous,if=active_enemies>=4&(holy_power<=3|(holy_power=4&target.health.pct>=35&buff.avenging_wrath.down))
        {spells.crusaderStrike, 'player.holyPower < 5 and player.hasTalent(7, 2)'}, -- crusader_strike,if=holy_power<5&talent.seraphim.enabled
        {spells.crusaderStrike, 'player.holyPower <= 3 or ( player.holyPower == 4 and target.hp >= 35 and target.hasMyDebuff(spells.avengingWrath) )'}, -- crusader_strike,if=holy_power<=3|(holy_power=4&target.health.pct>=35&buff.avenging_wrath.down)
        {spells.exorcism, 'player.hasGlyph(spells.glyphOfMassExorcism) and player.holyPower < 5 and = 1'}, -- exorcism,if=glyph.mass_exorcism.enabled&holy_power<5&!set_bonus.tier17_4pc=1
        {spells.judgment, 'player.hasGlyph(spells.glyphOfDoubleJeopardy) and player.holyPower < 5'}, -- judgment,cycle_targets=1,if=glyph.double_jeopardy.enabled&holy_power<5
        {spells.judgment, 'player.holyPower < 5 and player.hasTalent(7, 2)'}, -- judgment,if=holy_power<5&talent.seraphim.enabled
        {spells.judgment, 'player.holyPower <= 3 or ( player.holyPower == 4 and spells.crusaderStrike.cooldown >= player.gcd * 2 and target.hp > 35 and target.hasMyDebuff(spells.avengingWrath) )'}, -- judgment,if=holy_power<=3|(holy_power=4&cooldown.crusader_strike.remains>=gcd*2&target.health.pct>35&buff.avenging_wrath.down)
        {spells.divineStorm, 'player.buffStacks(spells.divineCrusader) and player.hasBuff(spells.finalVerdict)'}, -- divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up
        {spells.divineStorm, 'player.buffStacks(spells.divinePurpose) and player.hasBuff(spells.finalVerdict)'}, -- divine_storm,if=buff.divine_purpose.react&buff.final_verdict.up
        {spells.divineStorm, 'player.holyPower >= 4 and player.hasBuff(spells.finalVerdict)'}, -- divine_storm,if=holy_power>=4&buff.final_verdict.up
        {spells.finalVerdict, 'player.buffStacks(spells.divinePurpose) and target.hasMyDebuff(spells.finalVerdict)'}, -- final_verdict,if=buff.divine_purpose.react&buff.final_verdict.down
        {spells.finalVerdict, 'player.holyPower >= 4 and target.hasMyDebuff(spells.finalVerdict)'}, -- final_verdict,if=holy_power>=4&buff.final_verdict.down
        {spells.divineStorm, 'player.buffStacks(spells.divineCrusader) and not player.hasTalent(7, 3)'}, -- divine_storm,if=buff.divine_crusader.react&!talent.final_verdict.enabled
        {spells.divineStorm, 'player.holyPower >= 4 and ( not player.hasTalent(7, 2) or spells.seraphim.cooldown > player.gcd * 5 ) and not player.hasTalent(7, 3)'}, -- divine_storm,if=holy_power>=4&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*5)&!talent.final_verdict.enabled
        {spells.exorcism, 'player.holyPower < 5 and player.hasTalent(7, 2)'}, -- exorcism,if=holy_power<5&talent.seraphim.enabled
        {spells.exorcism, 'player.holyPower <= 3 or ( player.holyPower == 4 and ( spells.judgment.cooldown >= player.gcd * 2 and spells.crusaderStrike.cooldown >= player.gcd * 2 and target.hp > 35 and target.hasMyDebuff(spells.avengingWrath) ) )'}, -- exorcism,if=holy_power<=3|(holy_power=4&(cooldown.judgment.remains>=gcd*2&cooldown.crusader_strike.remains>=gcd*2&target.health.pct>35&buff.avenging_wrath.down))
        {spells.divineStorm, 'player.holyPower >= 3 and ( not player.hasTalent(7, 2) or spells.seraphim.cooldown > player.gcd * 6 ) and not player.hasTalent(7, 3)'}, -- divine_storm,if=holy_power>=3&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*6)&!talent.final_verdict.enabled
        {spells.divineStorm, 'player.holyPower >= 3 and player.hasBuff(spells.finalVerdict)'}, -- divine_storm,if=holy_power>=3&buff.final_verdict.up
        {spells.finalVerdict, 'player.holyPower >= 3 and target.hasMyDebuff(spells.finalVerdict)'}, -- final_verdict,if=holy_power>=3&buff.final_verdict.down
        {spells.holyPrism}, -- holy_prism,target=self
    },
    {{"nested"}, 'True', { -- call_action_list,name=single
        {spells.divineStorm, 'player.buffStacks(spells.divineCrusader) and ( player.holyPower == 5 or player.hasBuff(spells.holyAvenger) and player.holyPower >= 3 ) and player.hasBuff(spells.finalVerdict)'}, -- divine_storm,if=buff.divine_crusader.react&(holy_power=5|buff.holy_avenger.up&holy_power>=3)&buff.final_verdict.up
        {spells.divineStorm, 'player.buffStacks(spells.divineCrusader) and ( player.holyPower == 5 or player.hasBuff(spells.holyAvenger) and player.holyPower >= 3 ) and activeEnemies() == 2 and not player.hasTalent(7, 3)'}, -- divine_storm,if=buff.divine_crusader.react&(holy_power=5|buff.holy_avenger.up&holy_power>=3)&active_enemies=2&!talent.final_verdict.enabled
        {spells.divineStorm, '( player.holyPower == 5 or player.hasBuff(spells.holyAvenger) and player.holyPower >= 3 ) and activeEnemies() == 2 and player.hasBuff(spells.finalVerdict)'}, -- divine_storm,if=(holy_power=5|buff.holy_avenger.up&holy_power>=3)&active_enemies=2&buff.final_verdict.up
        {spells.divineStorm, 'player.buffStacks(spells.divineCrusader) and ( player.holyPower == 5 or player.hasBuff(spells.holyAvenger) and player.holyPower >= 3 ) and ( player.hasTalent(7, 2) and spells.seraphim.cooldown < player.gcd * 4 )'}, -- divine_storm,if=buff.divine_crusader.react&(holy_power=5|buff.holy_avenger.up&holy_power>=3)&(talent.seraphim.enabled&cooldown.seraphim.remains<gcd*4)
        {spells.templarsVerdict, '( player.holyPower == 5 or player.hasBuff(spells.holyAvenger) and player.holyPower >= 3 ) and ( target.hasMyDebuff(spells.avengingWrath) or target.hp > 35 ) and ( not player.hasTalent(7, 2) or spells.seraphim.cooldown > player.gcd * 4 )'}, -- templars_verdict,if=(holy_power=5|buff.holy_avenger.up&holy_power>=3)&(buff.avenging_wrath.down|target.health.pct>35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*4)
        {spells.templarsVerdict, 'player.buffStacks(spells.divinePurpose) and player.buffDuration(spells.divinePurpose) < 3'}, -- templars_verdict,if=buff.divine_purpose.react&buff.divine_purpose.remains<3
        {spells.divineStorm, 'player.buffStacks(spells.divineCrusader) and player.buffDuration(spells.divineCrusader) < 3 and not player.hasTalent(7, 3)'}, -- divine_storm,if=buff.divine_crusader.react&buff.divine_crusader.remains<3&!talent.final_verdict.enabled
        {spells.divineStorm, 'player.buffStacks(spells.divineCrusader) and player.buffDuration(spells.divineCrusader) < 3 and player.hasBuff(spells.finalVerdict)'}, -- divine_storm,if=buff.divine_crusader.react&buff.divine_crusader.remains<3&buff.final_verdict.up
        {spells.finalVerdict, 'player.holyPower == 5 or player.hasBuff(spells.holyAvenger) and player.holyPower >= 3'}, -- final_verdict,if=holy_power=5|buff.holy_avenger.up&holy_power>=3
        {spells.finalVerdict, 'player.buffStacks(spells.divinePurpose) and player.buffDuration(spells.divinePurpose) < 3'}, -- final_verdict,if=buff.divine_purpose.react&buff.divine_purpose.remains<3
        {spells.hammerOfWrath}, -- hammer_of_wrath
        {spells.judgment, 'player.hasTalent(7, 1) and player.hasBuff(spells.sealOfTruth) and player.buffDuration(spells.maraadsTruth) < spells.judgment.cooldownTotal'}, -- judgment,if=talent.empowered_seals.enabled&seal.truth&buff.maraads_truth.remains<cooldown.judgment.duration
        {spells.judgment, 'player.hasTalent(7, 1) and player.hasBuff(spells.sealOfRighteousness) and player.buffDuration(spells.liadrinsRighteousness) < spells.judgment.cooldownTotal'}, -- judgment,if=talent.empowered_seals.enabled&seal.righteousness&buff.liadrins_righteousness.remains<cooldown.judgment.duration
        {spells.judgment, 'player.hasTalent(7, 1) and player.hasBuff(spells.sealOfRighteousness) and spells.avengingWrath.cooldown < spells.judgment.cooldownTotal'}, -- judgment,if=talent.empowered_seals.enabled&seal.righteousness&cooldown.avenging_wrath.remains<cooldown.judgment.duration
        {spells.exorcism, 'player.hasBuff(spells.blazingContempt) and player.holyPower <= 2 and target.hasMyDebuff(spells.holyAvenger)'}, -- exorcism,if=buff.blazing_contempt.up&holy_power<=2&buff.holy_avenger.down
        {spells.sealOfTruth, 'player.hasTalent(7, 1) and target.hasMyDebuff(spells.maraadsTruth)'}, -- seal_of_truth,if=talent.empowered_seals.enabled&buff.maraads_truth.down
        {spells.sealOfTruth, 'player.hasTalent(7, 1) and spells.avengingWrath.cooldown < spells.judgment.cooldownTotal and player.buffDuration(spells.liadrinsRighteousness) > spells.judgment.cooldownTotal'}, -- seal_of_truth,if=talent.empowered_seals.enabled&cooldown.avenging_wrath.remains<cooldown.judgment.duration&buff.liadrins_righteousness.remains>cooldown.judgment.duration
        {spells.sealOfRighteousness, 'player.hasTalent(7, 1) and player.buffDuration(spells.maraadsTruth) > spells.judgment.cooldownTotal and target.hasMyDebuff(spells.liadrinsRighteousness) and not player.hasBuff(spells.avengingWrath) and not player.bloodlust'}, -- seal_of_righteousness,if=talent.empowered_seals.enabled&buff.maraads_truth.remains>cooldown.judgment.duration&buff.liadrins_righteousness.down&!buff.avenging_wrath.up&!buff.bloodlust.up
        {spells.divineStorm, 'player.buffStacks(spells.divineCrusader) and player.hasBuff(spells.finalVerdict) and ( player.hasBuff(spells.avengingWrath) or target.hp < 35 )'}, -- divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
        {spells.divineStorm, 'activeEnemies() == 2 and player.hasBuff(spells.finalVerdict) and ( player.hasBuff(spells.avengingWrath) or target.hp < 35 )'}, -- divine_storm,if=active_enemies=2&buff.final_verdict.up&(buff.avenging_wrath.up|target.health.pct<35)
        {spells.finalVerdict, 'player.hasBuff(spells.avengingWrath) or target.hp < 35'}, -- final_verdict,if=buff.avenging_wrath.up|target.health.pct<35
        {spells.divineStorm, 'player.buffStacks(spells.divineCrusader) and activeEnemies() == 2 and ( player.hasBuff(spells.avengingWrath) or target.hp < 35 ) and not player.hasTalent(7, 3)'}, -- divine_storm,if=buff.divine_crusader.react&active_enemies=2&(buff.avenging_wrath.up|target.health.pct<35)&!talent.final_verdict.enabled
        {spells.templarsVerdict, 'player.holyPower == 5 and ( player.hasBuff(spells.avengingWrath) or target.hp < 35 ) and ( not player.hasTalent(7, 2) or spells.seraphim.cooldown > player.gcd * 3 )'}, -- templars_verdict,if=holy_power=5&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*3)
        {spells.templarsVerdict, 'player.holyPower == 4 and ( player.hasBuff(spells.avengingWrath) or target.hp < 35 ) and ( not player.hasTalent(7, 2) or spells.seraphim.cooldown > player.gcd * 4 )'}, -- templars_verdict,if=holy_power=4&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*4)
        {spells.templarsVerdict, 'player.holyPower == 3 and ( player.hasBuff(spells.avengingWrath) or target.hp < 35 ) and ( not player.hasTalent(7, 2) or spells.seraphim.cooldown > player.gcd * 5 )'}, -- templars_verdict,if=holy_power=3&(buff.avenging_wrath.up|target.health.pct<35)&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*5)
        {spells.crusaderStrike, 'player.holyPower < 5 and player.hasTalent(7, 2)'}, -- crusader_strike,if=holy_power<5&talent.seraphim.enabled
        {spells.crusaderStrike, 'player.holyPower <= 3 or ( player.holyPower == 4 and target.hp >= 35 and target.hasMyDebuff(spells.avengingWrath) )'}, -- crusader_strike,if=holy_power<=3|(holy_power=4&target.health.pct>=35&buff.avenging_wrath.down)
        {spells.divineStorm, 'player.buffStacks(spells.divineCrusader) and ( player.hasBuff(spells.avengingWrath) or target.hp < 35 ) and not player.hasTalent(7, 3)'}, -- divine_storm,if=buff.divine_crusader.react&(buff.avenging_wrath.up|target.health.pct<35)&!talent.final_verdict.enabled
-- ERROR in 'judgment,cycle_targets=1,if=last_judgment_target!=target&glyph.double_jeopardy.enabled&holy_power<5': Unknown expression 'last_judgment_target'!
        {spells.exorcism, 'player.hasGlyph(spells.glyphOfMassExorcism) and activeEnemies() >= 2 and player.holyPower < 5 and not player.hasGlyph(spells.glyphOfDoubleJeopardy) and = 1'}, -- exorcism,if=glyph.mass_exorcism.enabled&active_enemies>=2&holy_power<5&!glyph.double_jeopardy.enabled&!set_bonus.tier17_4pc=1
        {spells.judgment, 'player.holyPower < 5 and player.hasTalent(7, 2)'}, -- judgment,if=holy_power<5&talent.seraphim.enabled
        {spells.judgment, 'player.holyPower <= 3 or ( player.holyPower == 4 and spells.crusaderStrike.cooldown >= player.gcd * 2 and target.hp > 35 and target.hasMyDebuff(spells.avengingWrath) )'}, -- judgment,if=holy_power<=3|(holy_power=4&cooldown.crusader_strike.remains>=gcd*2&target.health.pct>35&buff.avenging_wrath.down)
        {spells.divineStorm, 'player.buffStacks(spells.divineCrusader) and player.hasBuff(spells.finalVerdict)'}, -- divine_storm,if=buff.divine_crusader.react&buff.final_verdict.up
        {spells.divineStorm, 'activeEnemies() == 2 and player.holyPower >= 4 and player.hasBuff(spells.finalVerdict)'}, -- divine_storm,if=active_enemies=2&holy_power>=4&buff.final_verdict.up
        {spells.finalVerdict, 'player.buffStacks(spells.divinePurpose)'}, -- final_verdict,if=buff.divine_purpose.react
        {spells.finalVerdict, 'player.holyPower >= 4'}, -- final_verdict,if=holy_power>=4
        {spells.divineStorm, 'player.buffStacks(spells.divineCrusader) and activeEnemies() == 2 and player.holyPower >= 4 and not player.hasTalent(7, 3)'}, -- divine_storm,if=buff.divine_crusader.react&active_enemies=2&holy_power>=4&!talent.final_verdict.enabled
        {spells.templarsVerdict, 'player.buffStacks(spells.divinePurpose)'}, -- templars_verdict,if=buff.divine_purpose.react
        {spells.divineStorm, 'player.buffStacks(spells.divineCrusader) and not player.hasTalent(7, 3)'}, -- divine_storm,if=buff.divine_crusader.react&!talent.final_verdict.enabled
        {spells.templarsVerdict, 'player.holyPower >= 4 and ( not player.hasTalent(7, 2) or spells.seraphim.cooldown > player.gcd * 5 )'}, -- templars_verdict,if=holy_power>=4&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*5)
        {spells.sealOfTruth, 'player.hasTalent(7, 1) and player.buffDuration(spells.maraadsTruth) < spells.judgment.cooldownTotal'}, -- seal_of_truth,if=talent.empowered_seals.enabled&buff.maraads_truth.remains<cooldown.judgment.duration
        {spells.sealOfRighteousness, 'player.hasTalent(7, 1) and player.buffDuration(spells.liadrinsRighteousness) < spells.judgment.cooldownTotal and not player.bloodlust'}, -- seal_of_righteousness,if=talent.empowered_seals.enabled&buff.liadrins_righteousness.remains<cooldown.judgment.duration&!buff.bloodlust.up
        {spells.exorcism, 'player.holyPower < 5 and player.hasTalent(7, 2)'}, -- exorcism,if=holy_power<5&talent.seraphim.enabled
        {spells.exorcism, 'player.holyPower <= 3 or ( player.holyPower == 4 and ( spells.judgment.cooldown >= player.gcd * 2 and spells.crusaderStrike.cooldown >= player.gcd * 2 and target.hp > 35 and target.hasMyDebuff(spells.avengingWrath) ) )'}, -- exorcism,if=holy_power<=3|(holy_power=4&(cooldown.judgment.remains>=gcd*2&cooldown.crusader_strike.remains>=gcd*2&target.health.pct>35&buff.avenging_wrath.down))
        {spells.divineStorm, 'activeEnemies() == 2 and player.holyPower >= 3 and player.hasBuff(spells.finalVerdict)'}, -- divine_storm,if=active_enemies=2&holy_power>=3&buff.final_verdict.up
        {spells.finalVerdict, 'player.holyPower >= 3'}, -- final_verdict,if=holy_power>=3
        {spells.templarsVerdict, 'player.holyPower >= 3 and ( not player.hasTalent(7, 2) or spells.seraphim.cooldown > player.gcd * 6 )'}, -- templars_verdict,if=holy_power>=3&(!talent.seraphim.enabled|cooldown.seraphim.remains>gcd*6)
        {spells.holyPrism}, -- holy_prism
    },
}
,"paladin_retribution.simc")
