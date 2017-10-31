--[[[
@module Priest Discipline Rotation
@generated_from priest_discipline_dmg.simc
@version 7.0.3
]]--
local spells = kps.spells.priest
local env = kps.env.priest

local MassDispel = spells.massDispel.name
local AngelicFeather = spells.angelicFeather.name


kps.rotations.register("PRIEST","DISCIPLINE",{

    {{"macro"}, 'not target.exists and mouseover.inCombat and mouseover.isAttackable' , "/target mouseover" },
    
    -- "Dissipation de masse" 32375
    {{"macro"}, 'keys.ctrl', "/cast [@cursor] "..MassDispel },

    -- "Fade" 586 "Disparition"
    {spells.fade, 'player.isTarget' },
    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp < 0.80' ,"/use item:5512" },
    -- "Prière du désespoir" 19236 "Desperate Prayer"
    {spells.desperatePrayer, 'player.hp < 0.70' , "player" },
    -- "Don des naaru" 59544
    {spells.giftOfTheNaaru, 'player.hp < 0.70' , "player" },
    -- "Angelic Feather"
    {{"macro"},'player.hasTalent(2,1) and player.isMovingFor(1.2) and spells.angelicFeather.cooldown == 0 and not player.hasBuff(spells.angelicFeather)' , "/cast [@player] "..AngelicFeather },
    -- "Body and Mind"
    {spells.bodyAndMind, 'player.hasTalent(2,2) and player.isMovingFor(1.2) and not player.hasBuff(spells.bodyAndMind)' , "player"},
    
    -- "Dispel" "Purifier" 527
    {spells.purify, 'mouseover.isDispellable("Magic")' , "mouseover" },
    {{"nested"},'kps.cooldowns', {
        {spells.purify, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid},
        {spells.purify, 'heal.lowestTargetInRaid.isDispellable("Magic")' , kps.heal.lowestTargetInRaid},
        {spells.purify, 'player.isDispellable("Magic")' , "player" },
        {spells.purify, 'heal.isMagicDispellable ~= nil' , kps.heal.isMagicDispellable , "DISPEL" },
    }},
    
    -- TRINKETS SLOT 2
    -- "Archive of Faith" 147006 -- "The Deceiver's Grand Design" 147007 
    {{"macro"}, 'player.hasTrinket(1) == 147007 and player.useTrinket(1) and player.hp < 0.55 and not player.hasBuff(spells.guidingHand)' , "/use 14" },
    {{"macro"}, 'player.hasTrinket(1) == 147007 and player.useTrinket(1) and heal.lowestTankInRaid.hp < 0.85 and not heal.lowestTankInRaid.hasBuff(spells.guidingHand)' , "/target "..kps["env"].heal.lowestTankInRaid.unit.."\n".."/use 14" },
    {{"macro"}, 'player.hasTrinket(1) == 147007 and player.useTrinket(1) and heal.lowestInRaid.hp < 0.55 and not heal.lowestInRaid.hasBuff(spells.guidingHand)' , "/target "..kps["env"].heal.lowestInRaid.unit.."\n".."/use 14" },
    -- "Velen's Future Sight" 144258
    {{"macro"}, 'player.hasTrinket(1) == 144258 and player.useTrinket(1) and heal.countLossInRange(0.82) >= 3' , "/use 14" },

    {spells.painSuppression, 'heal.lowestTankInRaid.hp < 0.30' , kps.heal.lowestTankInRaid },
    {spells.painSuppression, 'player.hp < 0.30' , "player" },
    {spells.painSuppression, 'heal.lowestInRaid.hp < 0.30' , kps.heal.lowestInRaid },
    {spells.evangelism, 'kps.lastCast["name"] == spells.powerWordRadiance' },
    {spells.powerWordShield, 'player.hp < threshold()' , kps.heal.lowestTankInRaid },
    {spells.powerWordShield, 'heal.lowestTankInRaid.hp < threshold()' , kps.heal.lowestTankInRaid },
    {spells.powerWordShield, 'heal.lowestInRaid.hp < threshold()' , kps.heal.lowestInRaid },
    {spells.powerWordRadiance, 'not player.isMoving and heal.countLossInRange(0.82) >= 3 and heal.hasRaidBuffCount(spells.atonement) < 3' , kps.heal.lowestTankInRaid },
    {spells.plea, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 3' , kps.heal.lowestTankInRaid },
    {spells.plea, 'not player.hasBuff(spells.atonement)' , "player" },
    {spells.plea, 'not heal.lowestInRaid.hasBuff(spells.atonement)' , kps.heal.lowestInRaid },

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
