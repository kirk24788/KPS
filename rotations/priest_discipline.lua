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
local Barriere = spells.powerWordBarrier.name

-- kps.interrupt for painSuppression
-- kps.cooldowns for dispel
-- kps.multiTarget for smite endless
-- kps.defensive for mouseover

kps.runAtEnd(function()
   kps.gui.addCustomToggle("PRIEST","DISCIPLINE", "leapOfFaith", "Interface\\Icons\\priest_spell_leapoffaith_a", "leapOfFaith")
end)

kps.rotations.register("PRIEST","DISCIPLINE",{

    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    
    -- "Dissipation de masse" 32375
    {{"macro"}, 'keys.ctrl', "/cast [@cursor] "..MassDispel },
    -- "Power Word: Barrier" 62618
    {{"macro"}, 'keys.shift', "/cast [@cursor] "..Barriere },

    -- "Fade" 586 "Disparition"
    {spells.fade, 'player.isTarget' },
    {spells.shiningForce, 'player.isTarget and not player.isInRaid and target.distance < 10' , "player" },
    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp < 0.82' ,"/use item:5512" },
    -- "Prière du désespoir" 19236 "Desperate Prayer"
    {spells.desperatePrayer, 'player.hp < 0.72' , "player" },
    -- "Don des naaru" 59544
    {spells.giftOfTheNaaru, 'player.hp < 0.72' , "player" },
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
    
    -- TRINKETS
    -- "Ishkar's Felshield Emitter" 151957 -- "Emetteur de gangrebouclier d'Ishkar" 151957
    {{"macro"}, 'player.hasTrinket(0) == 151957 and player.useTrinket(0) and not heal.lowestTankInRaid.hasBuff(spells.guidingHand)' , "/target "..kps["env"].heal.lowestTankInRaid.unit.."\n".."/use 13".."\n".."/targetlasttarget" },
    {{"macro"}, 'player.hasTrinket(0) == 151957 and player.useTrinket(0) and focus.exists and not focus.hasBuff(spells.guidingHand)' , "/target ".."focus".."\n".."/use 13".."\n".."/targetlasttarget" },
    {{"macro"}, 'player.hasTrinket(0) == 151957 and player.useTrinket(0) and not player.hasBuff(spells.guidingHand)' , "/target ".."player".."\n".."/use 13".."\n".."/targetlasttarget" },
    -- "Archive of Faith" 147006 -- "The Deceiver's Grand Design" 147007
    {{"macro"}, 'player.hasTrinket(0) == 147007 and player.useTrinket(0) and focus.exists and not focus.hasBuff(spells.guidingHand)' , "/target ".."focus".."\n".."/use 13".."\n".."/targetlasttarget" },
    {{"macro"}, 'player.hasTrinket(0) == 147007 and player.useTrinket(0) and not player.hasBuff(spells.guidingHand)' , "/target ".."player".."\n".."/use 13".."\n".."/targetlasttarget" },
    -- "Velen's Future Sight" 144258
    {{"macro"}, 'player.hasTrinket(1) == 144258 and player.useTrinket(1) and heal.countLossInRange(0.82) >= 3' , "/use 14" },

    {spells.evangelism, 'player.hasTalent(7,3) and kps.lastCast["name"] == spells.powerWordRadiance' },
    {spells.lightsWrath, 'not player.isMoving and target.isAttackable and kps.lastCast["name"] == spells.powerWordRadiance' , "target" },
    {spells.lightsWrath, 'not player.isMoving and target.isAttackable and kps.lastCast["name"] == spells.evangelism' , "target" },
    {spells.lightsWrath, 'not player.isMoving and focustarget.isAttackable and kps.lastCast["name"] == spells.powerWordRadiance' , "focustarget" },
    {spells.lightsWrath, 'not player.isMoving and focustarget.isAttackable and kps.lastCast["name"] == spells.evangelism' , "focustarget" },
    
    -- "Leap Of Faith"
    {spells.leapOfFaith, 'kps.leapOfFaith and not heal.lowestInRaid.isUnit("player") and heal.lowestInRaid.hp < 0.20 and not heal.lowestInRaid.isTankInRaid' , kps.heal.lowestInRaid },

    {spells.painSuppression, 'mouseover.hp < 0.30 and mouseover.isFriend' , "mouseover" },
    {{"nested"}, 'kps.interrupt' ,{
        {spells.painSuppression, 'heal.lowestTargetInRaid.hp < 0.30' , kps.heal.lowestTargetInRaid },
        {spells.painSuppression, 'heal.lowestTankInRaid.hp < 0.30' , kps.heal.lowestTankInRaid },
        {spells.painSuppression, 'player.hp < 0.30' , "player" },
        {spells.painSuppression, 'heal.lowestInRaid.hp < 0.30' , kps.heal.lowestInRaid },  
    }},

    {{"nested"}, 'kps.defensive and mouseover.isFriend' , {
        {spells.powerWordShield, 'mouseover.hp < threshold() and not mouseover.hasBuff(spells.powerWordShield)' , "mouseover" },
        {spells.shadowMend, 'mouseover.hp <  0.40 and not spells.shadowMend.isRecastAt("mouseover")' , "mouseover" },
        {spells.plea, 'not mouseover.hasBuff(spells.atonement)' , "mouseover" },
    }},

    {spells.rapture, 'spells.powerWordShield.cooldown > 2 and heal.lowestTankInRaid.hp < 0.30 and not heal.lowestTargetInRaid.hasBuff(spells.powerWordShield)' },
    {spells.rapture, 'spells.powerWordRadiance.cooldown > 6 and heal.lowestTankInRaid.hp < 0.40 and heal.countLossInRange(0.62) >= 4' },
    {spells.powerWordShield, 'not heal.lowestTargetInRaid.hasBuff(spells.powerWordShield) and heal.lowestTargetInRaid.incomingDamage > heal.lowestTargetInRaid.incomingHeal' , kps.heal.lowestTargetInRaid },  
    {spells.powerWordShield, 'not heal.lowestTankInRaid.hasBuff(spells.powerWordShield) and heal.lowestTankInRaid.incomingDamage > heal.lowestTankInRaid.incomingHeal' , kps.heal.lowestTankInRaid },
    {spells.powerWordShield, 'not heal.lowestTargetInRaid.hasBuff(spells.powerWordShield) and heal.lowestTargetInRaid.hp < threshold()' , kps.heal.lowestTargetInRaid },  
    {spells.powerWordShield, 'not heal.lowestTankInRaid.hasBuff(spells.powerWordShield) and heal.lowestTankInRaid.hp < threshold()' , kps.heal.lowestTankInRaid },
    {spells.powerWordShield, 'not player.hasBuff(spells.powerWordShield) and player.hp < threshold()' , "player" },
    {spells.powerWordShield, 'not heal.lowestInRaid.hasBuff(spells.powerWordShield) and heal.lowestInRaid.hp < 0.40' , kps.heal.lowestInRaid },

    {spells.powerWordSolace, 'player.hasTalent(4,1) and target.isAttackable' , "target" },
    {spells.powerWordSolace, 'player.hasTalent(4,1) and focustarget.isAttackable' , "focustarget" },

    {{"nested"}, 'heal.hasRaidBuffCount(spells.atonement) > 0' , {
        {spells.mindbender, 'player.hasTalent(4,3) and target.isAttackable and target.timeToDie > 12 and not player.isInGroup' , "target" },
        {spells.shadowfiend, 'not player.hasTalent(4,3) and target.isAttackable and target.timeToDie > 12 and not player.isInGroup' , "target" },
        {spells.mindbender, 'player.hasTalent(4,3) and target.isAttackable and target.timeToDie > 12 and heal.countLossInRange(0.78) >= 4' , "target" },
        {spells.shadowfiend, 'not player.hasTalent(4,3) and target.isAttackable and target.timeToDie > 12 and heal.countLossInRange(0.78) >= 4' , "target" },
        {spells.purgeTheWicked, 'player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.purgeTheWicked) < 2 and not spells.purgeTheWicked.isRecastAt("target")' , "target" },
        {spells.purgeTheWicked, 'player.hasTalent(6,1) and focustarget.isAttackable and focustarget.myDebuffDuration(spells.purgeTheWicked) < 2 and not spells.purgeTheWicked.isRecastAt("focustarget")' , "focustarget" },
        {spells.purgeTheWicked, 'player.hasTalent(6,1) and mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.purgeTheWicked) < 2 and not spells.purgeTheWicked.isRecastAt("mouseover")' , 'mouseover' },
    }},

    {spells.penance, 'target.isAttackable and spells.powerWordRadiance.charges < 2 and heal.countLossInRange(0.78) >= 4' , "target" },
    {spells.penance, 'focustarget.isAttackable and spells.powerWordRadiance.charges < 2 and heal.countLossInRange(0.78) >= 4' , "focustarget" },
    {{"nested"}, 'not player.isMoving and heal.hasRaidBuffCountHealth(spells.atonement,0.78) <= heal.countLossInRange(0.78) and heal.countLossInRange(0.78) >= 4' , {
        {spells.powerWordRadiance, 'player.myBuffDuration(spells.atonement) < 2' , "player" }, 
        {spells.powerWordRadiance, 'heal.lowestTargetInRaid.myBuffDuration(spells.atonement) < 2' , kps.heal.lowestTargetInRaid },
        {spells.powerWordRadiance, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2' , kps.heal.lowestTankInRaid },
        {spells.powerWordRadiance, 'heal.lowestInRaid.myBuffDuration(spells.atonement) < 2' , kps.heal.lowestInRaid },
    }},
    
    {spells.plea, 'player.myBuffDuration(spells.atonement) < 2' , "player" }, 
    {spells.plea, 'heal.lowestTargetInRaid.myBuffDuration(spells.atonement) < 2' , kps.heal.lowestTargetInRaid },
    {spells.plea, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2' , kps.heal.lowestTankInRaid },

    -- "Borrowed Time" "Sursis"  -- Applying Atonement to a target reduces the cast time of your next Smite or Light's Wrath by 5%, or causes your next Penance to channel 5% faster
    {spells.penance, 'player.hp < 0.40' , "player" },
    {spells.penance, 'target.isAttackable and heal.hasRaidBuffLowestHealth(spells.atonement) < 0.82' , "target" },
    {spells.penance, 'focustarget.isAttackable and heal.hasRaidBuffLowestHealth(spells.atonement) < 0.82' , "focustarget" },
    {spells.penance, 'kps.multiTarget and not player.isMoving and target.isAttackable' , "target" },
    {spells.penance, 'kps.multiTarget and not player.isMoving and focustarget.isAttackable' , "focustarget" },

    {spells.smite, 'not player.isMoving and player.hasBuff(spells.borrowedTime) and target.isAttackable' , "target" , "smite_borrowedTime" },
    {spells.smite, 'not player.isMoving and player.hasBuff(spells.borrowedTime) and focustarget.isAttackable' , "focustarget" , "smite_borrowedTime" },
    
    {spells.smite, 'not player.isMoving and heal.lowestInRaid.hasBuff(spells.atonement) and target.isAttackable and heal.lowestInRaid.hp < 0.92' , "target" , "smite_count" },
    {spells.smite, 'not player.isMoving and heal.lowestInRaid.hasBuff(spells.atonement) and focustarget.isAttackable and heal.lowestInRaid.hp < 0.92' , "focustarget" , "smite_count" },
    {spells.plea, 'heal.lowestInRaid.myBuffDuration(spells.atonement) < 2 and heal.lowestInRaid.hp < 0.92' , kps.heal.lowestInRaid },

    {spells.shadowMend, 'not player.isMoving and player.hp < 0.40 and not spells.shadowMend.isRecastAt("player")' , "player" },    
    {spells.shadowMend, 'not player.isMoving and heal.lowestTargetInRaid.hp < 0.40 and not spells.shadowMend.isRecastAt(heal.lowestTargetInRaid.unit)' , kps.heal.lowestTargetInRaid },
    {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.40 and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid },
    {spells.shadowMend, 'not player.isMoving and heal.lowestInRaid.hp < 0.40 and not spells.shadowMend.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid },

    {spells.smite,'kps.multiTarget and not player.isMoving and target.isAttackable' , "target" },
    {spells.smite,'kps.multiTarget and not player.isMoving and focustarget.isAttackable' , "focustarget" },

}
,"priest_discipline")
