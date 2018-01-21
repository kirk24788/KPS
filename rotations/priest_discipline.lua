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

kps.runAtEnd(function()
   kps.gui.addCustomToggle("PRIEST","DISCIPLINE", "smite", "Interface\\Icons\\spell_holy_holysmite", "leapOfFaith")
end)

kps.rotations.register("PRIEST","DISCIPLINE",{

    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    
    -- "Dissipation de masse" 32375
    {{"macro"}, 'keys.ctrl', "/cast [@cursor] "..MassDispel },
    -- "Power Word: Barrier" 62618
    {{"macro"}, 'keys.shift', "/cast [@cursor] "..Barriere },

    -- "Fade" 586 "Disparition"
    {spells.fade, 'player.isTarget' },
    {spells.shiningForce, 'player.isTarget and target.distance < 10' , "player" },
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
    -- "Leap Of Faith"
    {spells.leapOfFaith, 'kps.leapOfFaith and not heal.lowestInRaid.isUnit("player") and heal.lowestInRaid.hp < 0.20 and not heal.lowestInRaid.isTankInRaid' , kps.heal.lowestInRaid },
    
    {{"nested"}, 'kps.interrupt' ,{
        {spells.painSuppression, 'heal.aggroTankTarget.hp < 0.30' , kps.heal.aggroTankTarget },
        {spells.painSuppression, 'heal.lowestTankInRaid.hp < 0.30' , kps.heal.lowestTankInRaid },
        {spells.painSuppression, 'focus.isFriend and focus.hp < 0.30' , "focus" },
        {spells.painSuppression, 'player.hp < 0.30' , "player" },
        {spells.painSuppression, 'heal.lowestInRaid.hp < 0.30' , kps.heal.lowestInRaid },  
    }},
    
    -- "Dispel" "Purifier" 527
    {{"nested"},'kps.cooldowns', {
        {spells.purify, 'player.isDispellable("Magic")' , "player" },
        {spells.purify, 'mouseover.isDispellable("Magic")' , "mouseover" },
        {spells.purify, 'focus.isFriend and focus.isDispellable("Magic")' , "focus"},
        {spells.purify, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid},
        {spells.purify, 'heal.lowestInRaid.isDispellable("Magic")' , kps.heal.lowestInRaid},
        {spells.purify, 'heal.aggroTankTarget.isDispellable("Magic")' , kps.heal.aggroTankTarget},
        {spells.purify, 'heal.isMagicDispellable ~= nil' , kps.heal.isMagicDispellable , "DISPEL" },
    }},
    
    -- TRINKETS -- SLOT 0 /use 13
    -- "Carafe de lumière incendiaire" "Carafe of Searing Light"
    {{"macro"}, 'player.hasTrinket(0) == 151960 and player.useTrinket(0) and target.isAttackable' , "/use 13" },
    -- "Résonateur de vitalité" "Vitality Resonator" 151970
    {{"macro"}, 'player.hasTrinket(0) == 151970 and player.useTrinket(0) and target.isAttackable' , "/use 13" },
    -- "Ishkar's Felshield Emitter" "Emetteur de gangrebouclier d'Ishkar" 151957
    {{"macro"}, 'player.hasTrinket(0) == 151957 and player.useTrinket(0) and focus.isFriend' , "/target ".."focus".."\n".."/use 13".."\n".."/targetlasttarget" },
    {{"macro"}, 'player.hasTrinket(0) == 151957 and player.useTrinket(0)' , "/target ".."player".."\n".."/use 13".."\n".."/targetlasttarget" },
     -- "The Deceiver's Grand Design" "Grand dessein du Trompeur" 147007 
    {{"macro"}, 'player.hasTrinket(0) == 147007 and player.useTrinket(0) and focus.isFriend and not focus.hasBuff(spells.guidingHand)' , "/target ".."focus".."\n".."/use 13".."\n".."/targetlasttarget" },
    {{"macro"}, 'player.hasTrinket(0) == 147007 and player.useTrinket(0) and not player.hasBuff(spells.guidingHand)' , "/target ".."player".."\n".."/use 13".."\n".."/targetlasttarget" },
    
    -- TRINKETS -- SLOT 1 /use 14
    -- "Carafe de lumière incendiaire" "Carafe of Searing Light"
    {{"macro"}, 'player.hasTrinket(1) == 151960 and player.useTrinket(1) and target.isAttackable' , "/use 14" },
    -- "Résonateur de vitalité" "Vitality Resonator" 151970
    {{"macro"}, 'player.hasTrinket(1) == 151970 and player.useTrinket(1) and target.isAttackable' , "/use 14" },
    -- "Ishkar's Felshield Emitter" 151957 -- "Emetteur de gangrebouclier d'Ishkar" 151957
    {{"macro"}, 'player.hasTrinket(1) == 151957 and player.useTrinket(1) and focus.isFriend' , "/target ".."focus".."\n".."/use 14".."\n".."/targetlasttarget" },
    {{"macro"}, 'player.hasTrinket(1) == 151957 and player.useTrinket(1)' , "/target ".."player".."\n".."/use 14".."\n".."/targetlasttarget" },
    -- "Velen's Future Sight" 144258
    {{"macro"}, 'player.hasTrinket(1) == 144258 and player.useTrinket(1) and heal.countLossInRange(0.78) >= 3' , "/use 14" },
    
    {spells.powerWordSolace, 'player.hasTalent(4,1) and target.isAttackable' , "target" },
    {spells.powerWordSolace, 'player.hasTalent(4,1) and focustarget.isAttackable' , "focustarget" },

    -- RAID GROUPHEAL
    {spells.lightsWrath, 'not player.isMoving and kps.lastCast["name"] == spells.evangelism and heal.hasRaidBuffCountHealth(spells.atonement,0.82) >= 5' , "target" },
    {spells.lightsWrath, 'not player.isMoving and kps.lastCast["name"] == spells.evangelism and heal.hasRaidBuffLowestHealth(spells.atonement) < 0.55' , "focustarget" },   
    {{"nested"}, 'not player.isMoving and heal.hasRaidBuffCountHealth(spells.atonement,0.78) < heal.countLossInRange(0.78) and heal.countLossInRange(0.78) >= 5' , {
        {spells.powerWordRadiance, 'player.myBuffDuration(spells.atonement) < 2' , "player" }, 
        {spells.powerWordRadiance, 'heal.aggroTankTarget.myBuffDuration(spells.atonement) < 2' , kps.heal.aggroTankTarget },
        {spells.powerWordRadiance, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2' , kps.heal.lowestTankInRaid },
        {spells.powerWordRadiance, 'heal.lowestInRaid.myBuffDuration(spells.atonement) < 2' , kps.heal.lowestInRaid },
        {spells.powerWordRadiance, 'heal.hasDamage.myBuffDuration(spells.atonement) < 2' , kps.heal.hasDamage },
    }},
    {spells.evangelism, 'player.hasTalent(7,3) and kps.lastCast["name"] == spells.powerWordRadiance' },
    {spells.lightsWrath, 'not player.isMoving and kps.lastCast["name"] == spells.powerWordRadiance and heal.hasRaidBuffCountHealth(spells.atonement,0.82) >= 5' , "target" },
    {spells.lightsWrath, 'not player.isMoving and kps.lastCast["name"] == spells.powerWordRadiance and heal.hasRaidBuffLowestHealth(spells.atonement) < 0.55' , "focustarget" },
    {spells.mindbender, 'player.hasTalent(4,3) and heal.hasRaidBuffCountHealth(spells.atonement,0.82) >= 5 and spells.lightsWrath.cooldown > 0' , "target" },
    {spells.mindbender, 'player.hasTalent(4,3) and heal.hasRaidBuffLowestHealth(spells.atonement) < 0.55 and spells.lightsWrath.cooldown > 0' , "focustarget" },
    {spells.shadowfiend, 'not player.hasTalent(4,3) and heal.hasRaidBuffCountHealth(spells.atonement,0.82) >= 5 and spells.lightsWrath.cooldown > 0' , "target" },
    {spells.shadowfiend, 'not player.hasTalent(4,3) and heal.hasRaidBuffLowestHealth(spells.atonement) < 0.55 and spells.lightsWrath.cooldown > 0' , "focustarget" },

    --PARTY GROUPHEAL
    {{"nested"}, 'not player.isInRaid' ,{
        {spells.lightsWrath, 'not player.isMoving and kps.lastCast["name"] == spells.evangelism and heal.hasRaidBuffCountHealth(spells.atonement,0.82) >= 3' , "target" },
        {spells.lightsWrath, 'not player.isMoving and kps.lastCast["name"] == spells.evangelism and heal.hasRaidBuffLowestHealth(spells.atonement) < 0.55' , "focustarget" },
        {spells.powerWordRadiance, 'not player.isMoving and heal.hasRaidBuffCountHealth(spells.atonement,0.78) < heal.countLossInRange(0.78) and heal.countLossInRange(0.78) >= 3' , "player" },
        {spells.evangelism, 'player.hasTalent(7,3) and kps.lastCast["name"] == spells.powerWordRadiance' },
        {spells.lightsWrath, 'not player.isMoving and kps.lastCast["name"] == spells.powerWordRadiance and heal.hasRaidBuffCountHealth(spells.atonement,0.82) >= 3' , "target" },
        {spells.lightsWrath, 'not player.isMoving and kps.lastCast["name"] == spells.powerWordRadiance and heal.hasRaidBuffLowestHealth(spells.atonement) < 0.55' , "focustarget" },
        {spells.mindbender, 'player.hasTalent(4,3) and heal.hasRaidBuffCountHealth(spells.atonement,0.82) >= 5 and spells.lightsWrath.cooldown > 0' , "target" },
        {spells.mindbender, 'player.hasTalent(4,3) and heal.hasRaidBuffLowestHealth(spells.atonement) < 0.55 and spells.lightsWrath.cooldown > 0' , "focustarget" },
        {spells.shadowfiend, 'not player.hasTalent(4,3) and heal.hasRaidBuffCountHealth(spells.atonement,0.82) >= 5 and spells.lightsWrath.cooldown > 0' , "target" },
        {spells.shadowfiend, 'not player.hasTalent(4,3) and heal.hasRaidBuffLowestHealth(spells.atonement) < 0.55 and spells.lightsWrath.cooldown > 0' , "focustarget" },
    }},
    -- SCHIELD
    {spells.powerWordShield, 'not player.hasBuff(spells.powerWordShield) and player.hp < threshold()' , "player" },
    {spells.powerWordShield, 'not heal.aggroTankTarget.hasBuff(spells.powerWordShield)' , kps.heal.aggroTankTarget },  
    {spells.powerWordShield, 'not heal.lowestTankInRaid.hasBuff(spells.powerWordShield)' , kps.heal.lowestTankInRaid },
    {spells.powerWordShield, 'focus.isFriend and not focus.hasBuff(spells.powerWordShield) and focus.hp < threshold()' , "focus" },
    {spells.powerWordShield, 'not heal.lowestInRaid.hasBuff(spells.powerWordShield) and heal.lowestInRaid.hp < threshold()' , kps.heal.lowestInRaid },
    {spells.powerWordShield, 'player.hasBuff(spells.rapture) and not heal.lowestInRaid.hasBuff(spells.powerWordShield)' , kps.heal.lowestInRaid },
    {spells.rapture, 'spells.powerWordRadiance.charges == 0 and spells.powerWordRadiance.cooldown > 4 and heal.countLossInRange(0.62) >= 5' },

    {spells.plea, 'heal.aggroTankTarget.myBuffDuration(spells.atonement) < 2' , kps.heal.aggroTankTarget },
    {spells.plea, 'heal.lowestTankInRaid.myBuffDuration(spells.atonement) < 2' , kps.heal.lowestTankInRaid },
    {spells.plea, 'focus.isFriend and not focus.hasBuff(spells.atonement) and focus.hp < 1' , "focus" },
    {spells.plea, 'not player.hasBuff(spells.atonement) and player.hp < 1' , "player" },
    
    -- MOUSEOVER
    {{"nested"}, 'kps.defensive and mouseover.isFriend' , {
        {spells.painSuppression, 'mouseover.hp < 0.30 and mouseover.isFriend' , "mouseover" },
        {spells.powerWordShield, 'mouseover.hp < threshold() and not mouseover.hasBuff(spells.powerWordShield)' , "mouseover" },
        {spells.shadowMend, 'not player.isMoving and mouseover.hp <  0.30 and not spells.shadowMend.isRecastAt("mouseover")' , "mouseover" },
        {spells.plea, 'not mouseover.hasBuff(spells.atonement) and mouseover.hp < threshold()' , "mouseover" },
    }},

    -- "Purge the Wicked" Spreads to an additional nearby enemy when you cast Penance on the target.
    {spells.purgeTheWicked, 'player.hasTalent(6,1) and target.isAttackable and target.myDebuffDuration(spells.purgeTheWicked) < 2 and not spells.purgeTheWicked.isRecastAt("target")' , "target" },
    {spells.penance, 'target.isAttackable' , "target" },
    {spells.purgeTheWicked, 'player.hasTalent(6,1) and focustarget.isAttackable and focustarget.myDebuffDuration(spells.purgeTheWicked) < 2 and not spells.purgeTheWicked.isRecastAt("focustarget")' , "focustarget" }, 
    {spells.penance, 'focustarget.isAttackable' , "focustarget" },
    {spells.purgeTheWicked, 'player.hasTalent(6,1) and mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.purgeTheWicked) < 2 and not spells.purgeTheWicked.isRecastAt("mouseover")' , 'mouseover' },

    {spells.shadowMend, 'not player.isMoving and player.hp < 0.40 and not spells.shadowMend.isRecastAt("player")' , "player" },    
    {spells.shadowMend, 'not player.isMoving and heal.aggroTankTarget.hp < 0.40 and not spells.shadowMend.isRecastAt(heal.aggroTankTarget.unit)' , kps.heal.aggroTankTarget },
    {spells.shadowMend, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.40 and not spells.shadowMend.isRecastAt(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid },
    {spells.shadowMend, 'not player.isMoving and not player.isInRaid and heal.lowestInRaid.hp < 0.55 and not spells.shadowMend.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "shadowMend_lowest" },

    -- NOT ISINGROUP
    {{"nested"}, 'kps.multiTarget and not player.isInGroup' , {
        {spells.powerWordShield, 'not player.hasBuff(spells.powerWordShield)' , "player" },
        {spells.plea, 'player.myBuffDuration(spells.atonement) < 2' , "player" },
        {spells.penance, 'target.isAttackable' , "target" },
        {spells.mindbender, 'player.hasTalent(4,3) and target.isAttackable' , "target" },
        {spells.shadowfiend, 'not player.hasTalent(4,3) and target.isAttackable' , "target" },
        {spells.lightsWrath, 'not player.isMoving and player.myBuffDuration(spells.atonement) > 2 and target.isAttackable' , "target" },
        {spells.smite,'not player.isMoving and target.isAttackable' , "target" },
    }},

    -- "Borrowed Time" "Sursis"  -- Applying Atonement to a target reduces the cast time of your next Smite or Light's Wrath by 5%, or causes your next Penance to channel 5% faster
    {spells.smite, 'not player.isMoving and heal.hasRaidBuffCountHealth(spells.atonement,0.90) >= heal.countLossInRange(0.90) and heal.countLossInRange(0.90) > 0 and target.isAttackable' , "target" , "smite_count" },
    {spells.smite, 'not player.isMoving and heal.hasRaidBuffCountHealth(spells.atonement,0.90) >= heal.countLossInRange(0.90) and heal.countLossInRange(0.90) > 0 and focustarget.isAttackable' , "focustarget" , "smite_count" },
    {spells.plea, 'not heal.lowestInRaid.hasBuff(spells.atonement) and heal.lowestInRaid.hp < threshold()' , kps.heal.lowestInRaid , "plea_lowest_threshold" },
    {{"nested"}, 'not player.isInRaid' ,{
        {spells.smite, 'not player.isMoving and heal.lowestInRaid.hp < 0.90 and heal.lowestInRaid.myBuffDuration(spells.atonement) > 2 and target.isAttackable' , "target" , "smite_lowest" },
        {spells.smite, 'not player.isMoving and heal.lowestInRaid.hp < 0.90 and heal.lowestInRaid.myBuffDuration(spells.atonement) > 2 and focustarget.isAttackable' , "focustarget" , "smite_lowest" },
        {spells.plea, 'not heal.lowestInRaid.hasBuff(spells.atonement) and heal.lowestInRaid.hp < 0.90' , kps.heal.lowestInRaid , "plea_lowest_count" },
    }},
    {spells.smite, 'not player.isMoving and heal.hasRaidBuffLowestHealth(spells.atonement) < 0.90 and target.isAttackable' , "target" , "smite_lowest_buff" },
    {spells.smite, 'not player.isMoving and heal.hasRaidBuffLowestHealth(spells.atonement) < 0.90 and focustarget.isAttackable' , "focustarget" , "smite_lowest_buff" },
    {spells.smite, 'not player.isMoving and kps.smite and target.isAttackable' , "target" },
    {spells.smite, 'not player.isMoving and kps.smite and focustarget.isAttackable' , "focustarget" },

}
,"priest_discipline")
