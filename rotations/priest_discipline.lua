--[[[
@module Priest Discipline Rotation
@generated_from priest_discipline_dmg.simc
@version 7.0.3
]]--
local spells = kps.spells.priest
local env = kps.env.priest


kps.rotations.register("PRIEST","DISCIPLINE",{

    {spells.painSuppression, 'heal.lowestTankInRaid.hp < 0.30' , kps.heal.lowestTankInRaid },
    {spells.painSuppression, 'player.hp < 0.30' , "player" },
    {spells.evangelism, 'kps.lastCast["name"] == spells.powerWordRadiance' },
    {spells.plea, 'not player.hasAtonement' , "player" },
    {spells.powerWordShield, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 3' , kps.heal.lowestTankInRaid },
    {spells.powerWordShield, 'heal.lowestInRaid.myBuffDuration(spells.atonement) < 3' , kps.heal.lowestInRaid },
    {spells.powerWordRadiance, 'not player.isMoving and heal.countLossInRange(0.82) >= 3 and heal.hasRaidBuffCount(spells.atonement) < 3' , kps.heal.lowestTankInRaid },
    {spells.powerWordRadiance, 'not player.isMoving and heal.hasNotAtonement ~= nil and heal.hasRaidBuffCount(spells.atonement) < 3' , kps.heal.hasNotAtonement },
    {spells.plea, 'spells.powerWordShield.cooldown > 0 and heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 3' , kps.heal.lowestTankInRaid },
    {spells.plea, 'spells.powerWordShield.cooldown > 0 and heal.lowestInRaid.myBuffDuration(spells.atonement) < 3' , kps.heal.lowestInRaid },

    {spells.powerInfusion, 'player.hasTalent(7,1)'},
    {spells.mindbender, 'player.hasTalent(4,3)'},
    {spells.shadowfiend, 'not player.hasTalent(4,3)'},
    {spells.shadowWordPain, 'not player.hasTalent(6,1) and target.myDebuffDuration(spells.shadowWordPain) < 3'},
    {spells.shadowWordPain, 'not player.hasTalent(6,1) and mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.shadowWordPain) < 2 and not spells.shadowWordPain.isRecastAt("mouseover")' , 'mouseover' },
    {spells.purgeTheWicked, 'target.myDebuffDuration(spells.purgeTheWicked) < 3'},
    {spells.purgeTheWicked, 'mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.purgeTheWicked) < 2 and not spells.purgeTheWicked.isRecastAt("mouseover")' , 'mouseover' },
    {spells.penance, 'target.isAttackable' , "target" },
    {spells.penance, 'targettarget.isAttackable', "targettarget" },
    {spells.penance, 'focustarget.isAttackable', "focustarget" },
    {spells.powerWordSolace, 'player.hasTalent(4,1)' },
    {spells.lightsWrath},

    {spells.shadowMend, 'heal.lowestTankInRaid.hp < threshold()' , kps.heal.lowestTankInRaid },
    {spells.shadowMend, 'heal.lowestInRaid.hp < threshold()' , kps.heal.lowestInRaid },

    {spells.smite}, 
}
,"priest_discipline")
