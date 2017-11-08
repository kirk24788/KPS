--[[[
@module Priest Discipline Rotation
@generated_from priest_discipline_dmg.simc
@version 7.0.3
]]--

kps.spells.priest.guidingHand = kps.Spell.fromId(242622) -- Guiding Hand used by trinket "The Deceiver's Grand Design"
local spells = kps.spells.priest
local env = kps.env.priest

local MassDispel = spells.massDispel.name
local AngelicFeather = spells.angelicFeather.name

-- kps.interrupt for painSuppression
-- kps.cooldowns for dispel
kps.rotations.register("PRIEST","DISCIPLINE",{

    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    
    -- "Dissipation de masse" 32375
    {{"macro"}, 'keys.ctrl', "/cast [@cursor] "..MassDispel },

    -- "Fade" 586 "Disparition"
    {spells.fade, 'player.isTarget' },
    {spells.shiningForce, 'player.isTarget and not player.isInRaid' , "player" },
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
    --{{"macro"}, 'player.hasTrinket(0) == 147007 and player.useTrinket(0) and not heal.lowestTankInRaid.hasBuff(spells.guidingHand)' , "/target "..kps["env"].heal.lowestTankInRaid.unit.."\n".."/use 13".."\n".."/targetlasttarget" },
    {{"macro"}, 'player.hasTrinket(0) == 147007 and player.useTrinket(0) and focus.exists and not focus.hasBuff(spells.guidingHand)' , "/target ".."focus".."\n".."/use 13".."\n".."/targetlasttarget" },
    {{"macro"}, 'player.hasTrinket(0) == 147007 and player.useTrinket(0) and not player.hasBuff(spells.guidingHand)' , "/target ".."player".."\n".."/use 13".."\n".."/targetlasttarget" },
    -- "Velen's Future Sight" 144258
    {{"macro"}, 'player.hasTrinket(1) == 144258 and player.useTrinket(1) and heal.countLossInRange(0.82) >= 3' , "/use 14" },

    {spells.evangelism, 'kps.lastCast["name"] == spells.powerWordRadiance' },
    {{"nested"}, 'kps.interrupt' ,{
        {spells.painSuppression, 'heal.lowestTankInRaid.hp < 0.30' , kps.heal.lowestTankInRaid },
        {spells.painSuppression, 'player.hp < 0.30' , "player" },
        {spells.painSuppression, 'heal.lowestInRaid.hp < 0.30' , kps.heal.lowestInRaid },  
    }},

    {{"nested"}, 'kps.defensive and mouseover.isFriend' , {
        {spells.powerWordShield, 'mouseover.hp < 0.55 and not mouseover.hasBuff(spells.powerWordShield)' , "mouseover" },
        {spells.shadowMend, 'mouseover.hp <  threshold()' , "mouseover" },
        {spells.plea, 'not mouseover.hasBuff(spells.atonement)' , "mouseover" },
    }},
    
    {spells.powerWordShield, 'not heal.lowestTankInRaid.hasBuff(spells.powerWordShield)' , kps.heal.lowestTankInRaid }, 
    {spells.powerWordShield, 'focus.isFriend and not focus.hasBuff(spells.powerWordShield)' , "focus" },  
    {spells.powerWordShield, 'player.hp < threshold() and not player.hasBuff(spells.powerWordShield)' , kps.heal.lowestTankInRaid },
    {spells.powerWordShield, 'heal.lowestInRaid.hp < threshold() and not heal.lowestInRaid.hasBuff(spells.powerWordShield)' , kps.heal.lowestInRaid },

    {spells.plea, 'not player.hasBuff(spells.atonement)' , "target" },
    {spells.plea, 'not heal.lowestTankInRaid.hasBuff(spells.atonement)' , kps.heal.lowestTankInRaid },
    {spells.plea, 'focus.isFriend and not focus.hasBuff(spells.atonement)' , "focus" },
    {spells.lightsWrath, 'not player.isMoving and heal.hasRaidBuffCount(spells.atonement) >= 5 and heal.countLossInRange(0.82) >= 5 and player.isInRaid' },
    {spells.lightsWrath, 'not player.isMoving and heal.hasRaidBuffCount(spells.atonement) >= 3 and heal.countLossInRange(0.82) >= 3 and not player.isInRaid' },
    {spells.powerWordRadiance, 'not player.isMoving and heal.hasRaidBuffCount(spells.atonement) <= heal.countLossInRange(0.82) and heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 3' , kps.heal.lowestTankInRaid },
    {spells.powerWordRadiance, 'not player.isMoving and heal.hasRaidBuffCount(spells.atonement) <= heal.countLossInRange(0.82) and heal.lowestInRaid.myBuffDuration(spells.atonement) < 3', kps.heal.lowestInRaid },
    {spells.powerWordRadiance, 'not player.isMoving and heal.hasRaidBuffCount(spells.atonement) <= heal.countLossInRange(0.82)', "player" },

    {spells.penance, 'heal.lowestInRaid.hp < 0.40' , kps.heal.lowestInRaid },
    {spells.penance, 'target.isAttackable and player.hasBuff(spells.borrowedTime)' , "target" , "borrowedTime" },
    {spells.penance, 'target.isAttackable and heal.lowestTankInRaid.hasBuff(spells.atonement)' , "target" },
    {spells.penance, 'focustarget.isAttackable and heal.lowestTankInRaid.hasBuff(spells.atonement)' , "focustarget" },

    {spells.smite, 'target.isAttackable and player.hasBuff(spells.borrowedTime)' , "target" , "smite_borrowedTime" },
    {spells.smite, 'focustarget.isAttackable and player.hasBuff(spells.borrowedTime)' , "focustarget" , "smite_borrowedTime" },

    {spells.powerWordSolace, 'player.hasTalent(4,1)' },
    {spells.powerInfusion, 'player.hasTalent(7,1)'},
    {spells.mindbender, 'player.hasTalent(4,3)'},
    {spells.shadowfiend, 'not player.hasTalent(4,3)'},

    {spells.purgeTheWicked, 'target.myDebuffDuration(spells.purgeTheWicked) < 3' },
    {spells.purgeTheWicked, 'mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.purgeTheWicked) < 2 and not spells.purgeTheWicked.isRecastAt("mouseover")' , 'mouseover' },
    {spells.shadowWordPain, 'not player.hasTalent(6,1) and target.myDebuffDuration(spells.shadowWordPain) < 3'},
    {spells.shadowWordPain, 'not player.hasTalent(6,1) and mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.shadowWordPain) < 2 and not spells.shadowWordPain.isRecastAt("mouseover")' , 'mouseover' },

    {spells.shadowMend, 'not heal.lowestInRaid.hasBuff(spells.atonement) and heal.lowestInRaid.hp < threshold()' , kps.heal.lowestInRaid },
    {spells.plea, 'not heal.lowestInRaid.hasBuff(spells.atonement) and heal.lowestInRaid.hp < 0.90' , kps.heal.lowestInRaid },
    {spells.plea, 'heal.hasNotBuffAtonement ~= nil and heal.hasNotBuffAtonement.hp < 0.90' , kps.heal.hasNotBuffAtonement , "plea_hasNotBuffAtonement" },
    
    {spells.smite, 'not player.isMoving and target.isAttackable and heal.lowestInRaid.hasBuff(spells.atonement)' , "target" },
    {spells.smite, 'not player.isMoving and focustarget.isAttackable and heal.lowestInRaid.hasBuff(spells.atonement)' , "focustarget" },
    {spells.smite, 'not player.isMoving and target.isAttackable and heal.lowestTankInRaid.hasBuff(spells.atonement)' , "target" },
    {spells.smite, 'not player.isMoving and focustarget.isAttackable and heal.lowestTankInRaid.hasBuff(spells.atonement)' , "focustarget" },

}
,"priest_discipline")
