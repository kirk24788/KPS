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
    env.TargetMouseover,
    env.FocusMouseover,

    -- "Dispersion" 47585
    {spells.dispersion, 'player.hp < 0.40' },
    --{spells.dispersion, 'spells.mindbender.cooldown > 44 and player.buffStacks(spells.voidform) > 40 and spells.voidTorrent.cooldown > 6' , "target", "DISPERSION_BUFF" },
    {{"macro"}, 'player.hasBuff(spells.dispersion) and player.hp == 1 and player.insanity == 100' , "/cancelaura "..Dispersion },
    {{"macro"}, 'player.hasBuff(spells.dispersion)' , "/stopcasting" },
    --"Fade" 586
    {spells.fade, 'player.isTarget' },
    
    --{{"macro"}, 'canCastvoidBolt()' , "/stopcasting" },
    {{"macro"}, 'player.hasBuff(spells.voidform) and spells.voidEruption.cooldown == 0 and spells.mindFlay.castTimeLeft("player") > kps.gcd' , "/stopcasting" },
    {spells.voidEruption, 'player.hasBuff(spells.voidform)' , env.VoidBoltTarget },
    -- "Shadow Word: Death" 32379
    {spells.shadowWordDeath, 'spells.shadowWordDeath.charges == 2 and mouseover.isAttackable and mouseover.inCombat and mouseover.hp < 0.20' , "mouseover" , "DEATH_MOUSEOVER_2" },
    {spells.shadowWordDeath, 'spells.shadowWordDeath.charges == 2 and target.hp < 0.20' , "target" , "DEATH_TARGET_2" },
    {spells.shadowWordDeath, 'spells.shadowWordDeath.charges == 1 and player.insanity < 80 and mouseover.isAttackable and mouseover.inCombat and mouseover.hp < 0.20' , "mouseover" , "DEATH_MOUSEOVER_1" },
    {spells.shadowWordDeath, 'spells.shadowWordDeath.charges == 1 and player.insanity < 80 and target.hp < 0.20' , "target" , "DEATH_TARGET_1" },

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

    -- "Dissipation de masse" 32375
    {{"macro"}, 'keys.ctrl', "/cast [@cursor] "..MassDispel },
    -- "Purify Disease" 213634
    {{"nested"}, 'kps.cooldowns',{
        {spells.purifyDisease, 'heal.isDiseaseDispellable ~= nil' , kps.heal.isDiseaseDispellable},
        {spells.purifyDisease, 'player.isDispellable("Disease")' , "player" },
        {spells.purifyDisease, 'mouseover.isDispellable("Disease")' , "mouseover" },
    }},
    
    -- "Power Word: Shield" 17
    {spells.powerWordShield, 'player.isMovingFor(1.6) and player.hasTalent(2,2) and not player.hasBuff(spells.bodyAndSoul)' , "player" , "SCHIELD" },
    -- "Etreinte vampirique" buff 15286 -- pendant 15 sec, vous permet de rendre à un allié proche, un montant de points de vie égal à 40% des dégâts d’Ombre que vous infligez avec des sorts à cible unique
    {spells.vampiricEmbrace, 'player.hasBuff(spells.voidform) and player.hp < 0.50' },
    {spells.vampiricEmbrace, 'player.hasBuff(spells.voidform) and heal.countInRange > 2 and heal.averageHpIncoming < 0.80' },
    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp < 0.70', "/use item:5512" },
    -- "Don des naaru" 59544
    {spells.giftOfTheNaaru, 'player.hp < 0.70', "player" },

    -- TRINKETS "Trinket0Slot" est slotId  13 "Trinket1Slot" est slotId  14
    --{{"macro"}, 'player.useTrinket(0) and player.hasBuff(spells.voidform)' , "/use 13"},
    {{"macro"}, 'player.useTrinket(1) and player.hasBuff(spells.voidform)' , "/use 14"},
    -- "Infusion de puissance" -- Confère un regain de puissance pendant 20 sec, ce qui augmente la hâte de 25%
    {spells.powerInfusion, 'kps.cooldowns and not player.isMoving and player.buffStacks(spells.voidform) > 22 and player.insanity > 50' },
    -- "Ombrefiel" cd 3 min duration 12sec -- "Mindbender" cd 1 min duration 12 sec
    {spells.shadowfiend, 'not player.hasTalent(6,3) and player.hasBuff(spells.voidform) and player.haste > 50' , "target" },
    {spells.mindbender, 'player.hasTalent(6,3) and player.hasBuff(spells.voidform) and player.buffStacks(spells.voidform) > 26 and player.insanity < 80' , "target" },

    -- "Mindblast" is highest priority spell out of voidform
    {spells.mindBlast, 'not player.isMoving and not player.hasBuff(spells.voidform) and player.hasTalent(7,1) and player.insanity < 65' , "target" },
    {spells.mindBlast, 'not player.isMoving and not player.hasBuff(spells.voidform) and not player.hasTalent(7,1) and player.insanity < 80' , "target" },   
    --{{"macro"}, 'canCastMindBlast()' , "/stopcasting" },
    {{"macro"}, 'not player.isMoving and player.hasBuff(spells.voidform) and spells.mindBlast.cooldown == 0 and spells.mindFlay.castTimeLeft("player") > kps.gcd' , "/stopcasting" },
    {spells.mindBlast, 'not player.isMoving and player.hasBuff(spells.voidform)' , "target" , "MINDBLAST" },
    {spells.mindBlast, 'not player.isMoving and player.hasBuff(spells.voidform) and targettarget.isAttackable ' , "targettarget" , "MINDBLAST" },
    
    -- "Void Eruption" 228260
    {spells.voidEruption , 'not player.isMoving and not player.hasBuff(spells.voidform) and player.insanity == 100' },
    {spells.voidEruption , 'not player.isMoving and not player.hasBuff(spells.voidform) and player.hasTalent(7,1) and player.insanity > 64 and target.myDebuffDuration(spells.vampiricTouch) > 4 and target.myDebuffDuration(spells.shadowWordPain) > 4' },
    {spells.voidTorrent, 'player.hasBuff(spells.voidform) and not player.isMoving and target.myDebuffDuration(spells.vampiricTouch) > 4 and target.myDebuffDuration(spells.shadowWordPain) > 4' },
    
    -- Mind Flay If the target is afflicted with Shadow Word: Pain you will also deal splash damage to nearby targets.    
    {spells.mindFlay, 'player.plateCount > 4 and not player.isMoving and target.myDebuffDuration(spells.vampiricTouch) > 4 and target.myDebuffDuration(spells.shadowWordPain) > 4' , "target" , "PLATECOUNT" },
    {spells.mindFlay, 'kps.multiTarget and not player.isMoving and target.myDebuffDuration(spells.vampiricTouch) > 4 and target.myDebuffDuration(spells.shadowWordPain) > 4' , "target" , "MULTITARGET" },
   
    {spells.vampiricTouch, 'not player.isMoving and target.myDebuffDuration(spells.vampiricTouch) < 4 and not spells.vampiricTouch.isRecastAt("target")' , 'target' },
    {spells.shadowWordPain, 'target.myDebuffDuration(spells.shadowWordPain) < 4 and not spells.shadowWordPain.isRecastAt("target")' , 'target' },    
    {spells.vampiricTouch, 'not player.isMoving and focus.myDebuffDuration(spells.vampiricTouch) < 4 and not spells.vampiricTouch.isRecastAt("focus")' , 'focus' },
    {spells.shadowWordPain, 'focus.myDebuffDuration(spells.shadowWordPain) < 4 and not spells.shadowWordPain.isRecastAt("focus")' , 'focus' },
    {spells.vampiricTouch, 'mouseover.isAttackable and mouseover.inCombat and not player.isMoving and mouseover.myDebuffDuration(spells.vampiricTouch) < 4 and not spells.vampiricTouch.isRecastAt("mouseover")' , 'mouseover' },
    {spells.shadowWordPain, 'mouseover.isAttackable and mouseover.inCombat and mouseover.myDebuffDuration(spells.shadowWordPain) < 4 and not spells.shadowWordPain.isRecastAt("mouseover")' , 'mouseover' },

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
