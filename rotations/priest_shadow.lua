--[[[
@module Priest Shadow Rotation
@author htordeux
@version 7.2
]]--

local spells = kps.spells.priest
local env = kps.env.priest
local Dispersion = tostring(spells.dispersion)
local MassDispel = tostring(spells.massDispel)

kps.rotations.register("PRIEST","SHADOW",{

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.isAttackable' , "/cleartarget"},
    env.TargetMouseover,
    --{{"macro"}, 'not focus.exists and not target.isUnit("mouseover") and mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.vampiricTouch) == 0'  ,"/focus mouseover" },
    --{{"macro"}, 'not focus.exists and not target.isUnit("mouseover") and mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.shadowWordPain) == 0'  ,"/focus mouseover" },
    --{{"macro"}, 'not focus.exists and not target.isUnit("mouseover") and mouseover.isAttackable and mouseover.inCombat'  ,"/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    {{"macro"}, 'focus.exists and not focus.isAttackable' , "/clearfocus" },
    env.FocusMouseover,

    -- "Dispersion" 47585
    {spells.dispersion, 'player.hp < 0.40' },
    {spells.dispersion, 'player.isMovingFor(1.2) and player.hasBuff(spells.voidform) and player.buffStacks(spells.voidform) > 29' },
    --{spells.dispersion, 'spells.mindbender.cooldown > 44 and player.buffStacks(spells.voidform) > 39 and spells.voidTorrent.cooldown > 6' , "target", "DISPERSION_BUFF" },
    {{"macro"}, 'player.hasBuff(spells.dispersion) and player.hp == 1 and player.insanity == 100' , "/cancelaura "..Dispersion },
    --"Fade" 586
    {spells.fade, 'player.isTarget' },
    -- "Power Word: Shield" 17
    {spells.powerWordShield, 'player.isMovingFor(1.2) and player.hasTalent(2,2) and not player.hasBuff(spells.bodyAndSoul) and player.hp < 0.70' , "player" , "SCHIELD" },
    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp < 0.70', "/use item:5512" },
    -- "Don des naaru" 59544
    {spells.giftOfTheNaaru, 'player.hp < 0.70', "player" },
    -- "Etreinte vampirique" buff 15286 -- pendant 15 sec, vous permet de rendre à un allié proche, un montant de points de vie égal à 40% des dégâts d’Ombre que vous infligez avec des sorts à cible unique
    {spells.vampiricEmbrace, 'player.hasBuff(spells.voidform) and player.hp < 0.50' },
    {spells.vampiricEmbrace, 'player.hasBuff(spells.voidform) and heal.countInRange > 2 and heal.averageHpIncoming < 0.80' },
    
    --{{"macro"}, 'canCastvoidBolt()' , "/stopcasting" },
    {{"macro"}, 'player.hasBuff(spells.voidform) and spells.voidEruption.cooldown == 0 and spells.mindFlay.castTimeLeft("player") < kps.gcd' , "/stopcasting" },
    {spells.voidEruption, 'player.hasBuff(spells.voidform)' , env.VoidBoltTarget },
    {spells.voidTorrent, 'not player.isMoving and player.hasBuff(spells.voidform) and target.myDebuffDuration(spells.vampiricTouch) > 4 and target.myDebuffDuration(spells.shadowWordPain) > 4 and player.buffStacks(spells.voidform) > 9' },
    
    -- "Dissipation de masse" 32375
    {{"macro"}, 'keys.ctrl', "/cast [@cursor] "..MassDispel },
    -- "Purify Disease" 213634
    {spells.purifyDisease, 'mouseover.isDispellable("Disease")' , "mouseover" },
    {{"nested"}, 'kps.cooldowns',{
        {spells.purifyDisease, 'heal.isDiseaseDispellable ~= nil' , kps.heal.isDiseaseDispellable},
        {spells.purifyDisease, 'player.isDispellable("Disease")' , "player" },
    }},
    -- interrupts
    {{"nested"}, 'kps.interrupt',{
        -- "Silence" 15487 -- debuff same ID
        {spells.silence, 'not target.hasDebuff(spells.mindBomb) and target.isInterruptable and target.distance < 30' , "target" },
        {spells.silence, 'not focus.hasDebuff(spells.mindBomb) and focus.isInterruptable and focus.distance < 30' , "focus" },
        -- "Mind Bomb" 205369 -- 30 yd range -- debuff "Explosion mentale" 226943
        {spells.mindBomb, 'target.isCasting and target.distance < 30' , "target" },
        {spells.mindBomb, 'focus.isCasting and focus.distance < 30' , "focus" },
        {spells.mindBomb, 'kps.multiTarget' , "target" },
    }},
    
    -- "Shadow Word: Death" 32379
    {spells.shadowWordDeath, 'mouseover.isAttackable and mouseover.inCombat and mouseover.hp < 0.20' , "mouseover" , "DEATH_MOUSEOVER" },
    {spells.shadowWordDeath, 'target.hp < 0.20' , "target" , "DEATH_TARGET" },
    -- "Mindblast" is highest priority spell out of voidform
    {spells.mindBlast, 'not player.isMoving and not player.hasBuff(spells.voidform) and player.hasTalent(7,1) and player.insanity < 65' , "target" },
    {spells.mindBlast, 'not player.isMoving and not player.hasBuff(spells.voidform) and not player.hasTalent(7,1) and player.insanity < 100' , "target" },
    
     -- "Void Eruption" 228260
    {spells.voidEruption , 'not player.isMoving and not player.hasBuff(spells.voidform) and player.insanity == 100 and target.myDebuffDuration(spells.vampiricTouch) > 4 and target.myDebuffDuration(spells.shadowWordPain) > 4' },
    {spells.voidEruption , 'not player.isMoving and not player.hasBuff(spells.voidform) and player.hasTalent(7,1) and player.insanity > 64 and target.myDebuffDuration(spells.vampiricTouch) > 4 and target.myDebuffDuration(spells.shadowWordPain) > 4' },

    {spells.shadowWordPain, 'kps.multiTarget and mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.shadowWordPain) < 2 and not spells.shadowWordPain.isRecastAt("mouseover")' , 'mouseover' },
    {spells.vampiricTouch, 'not player.isMoving and target.myDebuffDuration(spells.vampiricTouch) < 2 and not spells.vampiricTouch.isRecastAt("target")' , 'target' },
    {spells.shadowWordPain, 'target.myDebuffDuration(spells.shadowWordPain) < 2 and not spells.shadowWordPain.isRecastAt("target")' , 'target' },
    {spells.vampiricTouch, 'not player.isMoving and focus.myDebuffDuration(spells.vampiricTouch) < 2 and not spells.vampiricTouch.isRecastAt("focus")' , 'focus' },
    {spells.shadowWordPain, 'focus.myDebuffDuration(spells.shadowWordPain) < 2 and not spells.shadowWordPain.isRecastAt("focus")' , 'focus' },
    {spells.vampiricTouch, 'mouseover.isAttackable and mouseover.inCombat and not player.isMoving and mouseover.myDebuffDuration(spells.vampiricTouch) < 2 and not spells.vampiricTouch.isRecastAt("mouseover")' , 'mouseover' },
    {spells.shadowWordPain, 'mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.shadowWordPain) < 2 and not spells.shadowWordPain.isRecastAt("mouseover")' , 'mouseover' },

    -- TRINKETS "Trinket0Slot" est slotId  13 "Trinket1Slot" est slotId  14
    --{{"macro"}, 'player.useTrinket(0) and player.hasBuff(spells.voidform)' , "/use 13"},
    -- "Charm of the Rising Tide" -- While you remain stationary, gain 576 Haste every 1 sec stacking up to 10 times. Lasts 20 sec. (1 Min, 30 Sec Cooldown)
    {{"macro"}, 'player.useTrinket(1) and player.hasBuff(spells.voidform) and spells.mindbender.cooldown > 40 and spells.mindbender.cooldown < 50' , "/use 14"},
    -- "Infusion de puissance" -- Confère un regain de puissance pendant 20 sec, ce qui augmente la hâte de 25%
    {spells.powerInfusion, 'kps.cooldowns and not player.isMoving and player.buffStacks(spells.voidform) > 29 and player.insanity > 50' },
    -- "Ombrefiel" cd 3 min duration 12sec -- "Mindbender" cd 1 min duration 12 sec
    {spells.shadowfiend, 'not player.hasTalent(6,3) and player.hasBuff(spells.voidform) and player.haste > 50' , "target" },
    {spells.mindbender, 'player.hasTalent(6,3) and player.hasBuff(spells.voidform) and player.buffStacks(spells.voidform) > 29 and player.insanity < 80 and spells.voidTorrent.cooldown > 30' , "target" },
    {spells.mindbender, 'player.hasTalent(6,3) and player.hasBuff(spells.voidform) and player.buffStacks(spells.voidform) > 19 and player.insanity < 60 and spells.voidTorrent.cooldown > 30' , "target" },
    
    {spells.mindFlay, 'kps.multiTarget and not player.isMoving and target.myDebuffDuration(spells.shadowWordPain) > 4' , "target" , "MULTITARGET" },

    --{{"macro"}, 'canCastMindBlast()' , "/stopcasting" },
    --{{"macro"}, 'not player.isMoving and player.hasBuff(spells.voidform) and spells.mindBlast.cooldown == 0 and spells.mindFlay.castTimeLeft("player") < kps.gcd' , "/stopcasting" },
    {spells.mindBlast, 'not player.isMoving and player.hasBuff(spells.voidform) and not spells.mindBlast.isRecastAt("target")' , "target" , "MINDBLAST" },
    {spells.mindBlast, 'not player.isMoving and player.hasBuff(spells.voidform) and targettarget.isAttackable and not spells.mindBlast.isRecastAt("targettarget")' , "targettarget" , "MINDBLAST" },

    -- "Guérison de l’ombre" 186263 -- debuff "Shadow Mend" 187464 10 sec
    {spells.shadowMend, 'not player.isMoving and not spells.shadowMend.lastCasted(4) and not player.hasBuff(spells.voidform) and player.hp < 0.60 and not player.hasBuff(spells.vampiricEmbrace)' , "player" },
    -- "Power Word: Shield" 17
    {spells.powerWordShield, 'player.isTarget and player.hp < 0.50 and not player.hasBuff(spells.powerWordShield)' , "player" },
    {spells.powerWordShield, 'targettarget.isHealable and targettarget.hp < 0.50 and not targettarget.hasBuff(spells.powerWordShield)' , "targettarget" },
     -- "Levitate" 1706
    { spells.levitate, 'player.isFallingFor(1.6) and not player.hasBuff(spells.levitate)' , "player" },
    { spells.levitate, 'player.isSwimming and not player.hasBuff(spells.levitate)' , "player" },
    
    {spells.mindFlay, 'not player.isMoving' , "target" },
    {spells.mindFlay, 'not player.isMoving and targettarget.isAttackable' , "targettarget" },

},"Shadow Priest")
