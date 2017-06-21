--[[[
@module Priest Shadow Rotation
@author htordeux
@version 7.2
]]--

local spells = kps.spells.priest
local env = kps.env.priest
local dispersion = tostring(spells.dispersion)

kps.rotations.register("PRIEST","SHADOW",{

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    env.TargetMouseover,
    env.FocusMouseover,

    -- "Dispersion" 47585
    {spells.dispersion, 'player.hp < 0.40' },
    {{"macro"}, 'player.hasBuff(spells.dispersion) and player.hp > 0.90 and player.insanity > 90' , "/cancelaura "..dispersion },
    {{"macro"}, 'player.hasBuff(spells.dispersion)' , "/stopcasting" },
    {spells.fade, 'player.isTarget' },
    
    -- "Purify Disease" 213634
    {{"nested"}, 'kps.cooldowns',{
        {spells.purifyDisease, 'heal.isDiseaseDispellable ~= nil' , kps.heal.isDiseaseDispellable},
        {spells.purifyDisease, 'player.isDispellable("Disease")' , "player" },
        {spells.purifyDisease, 'mouseover.isDispellable("Disease")' , "mouseover" },
    }},

    -- "Power Word: Shield" 17
    {spells.powerWordShield, 'player.isMovingFor(1.6) and player.hasTalent(2,2) and not player.hasBuff(spells.bodyAndSoul)' , "player" , "SCHIELD" },
    {spells.powerWordShield, 'player.isTarget and player.hp < 0.50 and not player.hasBuff(spells.voidForm) and not player.hasBuff(spells.powerWordShield)' , "player" },
    {spells.powerWordShield, 'mouseover.isHealable and mouseover.hp < 0.50 and not mouseover.hasBuff(spells.powerWordShield)' , "mouseover" },
    --{spells.powerWordShield, 'targettarget.isHealable and targettarget.hp < 0.50 and not targettarget.hasBuff(spells.powerWordShield)' , "targettarget" },
    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp < 0.60', "/use item:5512" },
    -- "Don des naaru" 59544
    {spells.giftOfTheNaaru, 'player.hp < 0.70', "player" },
    -- "Etreinte vampirique" buff 15286 -- pendant 15 sec, vous permet de rendre à un allié proche, un montant de points de vie égal à 40% des dégâts d’Ombre que vous infligez avec des sorts à cible unique
    {spells.vampiricEmbrace, 'player.hasBuff(spells.voidForm) and player.hp < 0.50' },
    {spells.vampiricEmbrace, 'player.hasBuff(spells.voidForm) and heal.averageHpIncoming < 0.80' },
    -- "Guérison de l’ombre" 186263 -- debuff "Shadow Mend" 187464 10 sec
    {spells.shadowMend, 'not player.isMoving and not spells.shadowMend.lastCasted(4) and not player.hasBuff(spells.voidForm) and player.hp < 0.60 and not player.hasBuff(spells.vampiricEmbrace)' , "player" },
    {spells.shadowMend, 'not player.isMoving and not spells.shadowMend.lastCasted(4) and and not player.hasBuff(spells.voidForm) and player.hp < 0.90 and player.incomingDamage*2 > player.incomingHeal and not player.hasBuff(spells.vampiricEmbrace)' , "player" },

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

     -- "Levitate" 1706
    { spells.levitate, 'player.isFallingFor(1.6) and not player.hasBuff(spells.levitate)' , "player" },
    { spells.levitate, 'player.isSwimming and not player.hasBuff(spells.levitate)' , "player" },
    
    -- "Shadow Word: Death" 32379
    {{"nested"}, 'spells.shadowWordDeath.charges == 2',{
       {spells.shadowWordDeath, 'mouseover.hp < 0.20' , "mouseover" },
       {spells.shadowWordDeath, 'focus.hp < 0.20' , "focus" },
       {spells.shadowWordDeath, 'target.hp < 0.20' , "target" },
    }},
    {{"nested"}, 'spells.shadowWordDeath.charges > 0 and player.insanity < 85',{
       {spells.shadowWordDeath, 'mouseover.hp < 0.20' , "mouseover" },
       {spells.shadowWordDeath, 'focus.hp < 0.20' , "focus" },
       {spells.shadowWordDeath, 'target.hp < 0.20' , "target" },
    }},

    --{{"macro"}, 'canCastvoidBolt()' , "/stopcasting" },
    {{"macro"}, 'player.hasBuff(spells.voidForm) and spells.voidEruption.cooldown == 0 and spells.mindFlay.castTimeLeft("player") > 0.5' , "/stopcasting" },
    {spells.voidEruption, 'player.hasBuff(spells.voidForm)' , env.VoidBoltTarget , "VOIDERUPTION"},
    {spells.voidTorrent, 'player.hasBuff(spells.voidForm) and not player.isMoving and target.myDebuffDuration(spells.vampiricTouch) > 4 and target.myDebuffDuration(spells.shadowWordPain) > 4' },
    
    -- "Void Eruption" 228260
    {spells.voidEruption , 'not player.isMoving and not player.hasBuff(spells.voidForm) and player.insanity == 100' },
    {spells.voidEruption , 'not player.isMoving and not player.hasBuff(spells.voidForm) and player.hasTalent(7,1) and player.insanity > 65 and target.myDebuffDuration(spells.vampiricTouch) > 4 and target.myDebuffDuration(spells.shadowWordPain) > 4' },

    -- "Mindblast" is highest priority spell out of voidForm
    {spells.mindBlast, 'not player.isMoving and not player.hasBuff(spells.voidForm)' , "target" },
    {spells.mindBlast, 'not player.isMoving and not player.hasBuff(spells.voidForm) and targettarget.isAttackable' , "targettarget" },

    -- MultiTarget -- Mind Flay If the target is afflicted with Shadow Word: Pain you will also deal splash damage to nearby targets.
    {spells.vampiricTouch, 'kps.multiTarget and heal.raidTarget ~= nil and not spells.vampiricTouch.isRecastAt(heal.raidTarget)' , kps.heal.raidTarget , "RAIDTARGET" },
    {{"nested"}, 'player.plateCount > 4 or kps.multiTarget',{
        {spells.shadowWordPain, 'target.myDebuffDuration(spells.shadowWordPain) < 4 and not spells.shadowWordPain.isRecastAt("target")' , 'target' },
        {spells.shadowWordPain, 'mouseover.isAttackable and mouseover.myDebuffDuration(spells.shadowWordPain) < 4 and not spells.shadowWordPain.isRecastAt("mouseover")' , 'mouseover' },    
        {spells.mindFlay, 'not player.isMoving and target.myDebuffDuration(spells.shadowWordPain) > 4' , "target" , "MULTITARGET" },
    }},

    {spells.vampiricTouch, 'not player.isMoving and target.myDebuffDuration(spells.vampiricTouch) < 4 and not spells.vampiricTouch.isRecastAt("target")' , 'target' },
    {spells.shadowWordPain, 'target.myDebuffDuration(spells.shadowWordPain) < 4 and not spells.shadowWordPain.isRecastAt("target")' , 'target' },    
    {spells.vampiricTouch, 'not player.isMoving and focus.myDebuffDuration(spells.vampiricTouch) < 4 and not spells.vampiricTouch.isRecastAt("focus")' , 'focus' },
    {spells.shadowWordPain, 'focus.myDebuffDuration(spells.shadowWordPain) < 4 and not spells.shadowWordPain.isRecastAt("focus")' , 'focus' },

    --{{"macro"}, 'canCastMindBlast()' , "/stopcasting" },
    {{"macro"}, 'spells.mindBlast.cooldown == 0 and spells.mindFlay.castTimeLeft("player") > 0.5' , "/stopcasting" },
    {spells.mindBlast, 'not player.isMoving' , "target" , "MINDBLAST" },

    -- TRINKETS "Trinket0Slot" est slotId  13 "Trinket1Slot" est slotId  14
    --{{"macro"}, 'player.useTrinket(0) and player.hasBuff(spells.voidForm)' , "/use 13"},
    {{"macro"}, 'player.useTrinket(1) and player.hasBuff(spells.voidForm)' , "/use 14"},
    -- "Infusion de puissance"  -- Confère un regain de puissance pendant 20 sec, ce qui augmente la hâte de 25%
    {spells.powerInfusion, 'kps.cooldowns and not player.isMoving and player.buffStacks(spells.voidForm) > 14 and player.insanity > 50 ' },
    -- "Ombrefiel" cd 3 min duration 12sec -- "Mindbender" cd 1 min duration 12 sec
    {spells.shadowfiend, 'player.haste > 50' },
    {spells.mindbender, 'player.haste > 50' },

    {spells.vampiricTouch, 'mouseover.isAttackable and not player.isMoving and mouseover.myDebuffDuration(spells.vampiricTouch) < 4 and not spells.vampiricTouch.isRecastAt("mouseover")' , 'mouseover' },
    {spells.shadowWordPain, 'mouseover.isAttackable and mouseover.myDebuffDuration(spells.shadowWordPain) < 4 and not spells.shadowWordPain.isRecastAt("mouseover")' , 'mouseover' },

    {spells.mindFlay, 'not player.isMoving' , "target" },
    {spells.mindFlay, 'not player.isMoving and targettarget.isAttackable' , "targettarget" },

},"Shadow Priest")


--{spells.voidEruption, 'target.myDebuffDuration(spells.shadowWordPain) > 0 and target.myDebuffDuration(spells.shadowWordPain) < focus.myDebuffDuration(spells.shadowWordPain)' , "target" },
--{spells.voidEruption, 'target.myDebuffDuration(spells.vampiricTouch) > 0 and target.myDebuffDuration(spells.vampiricTouch) < focus.myDebuffDuration(spells.vampiricTouch)' , "target" },
--{spells.voidEruption, 'mouseover.myDebuffDuration(spells.shadowWordPain) > 0 and mouseover.myDebuffDuration(spells.shadowWordPain) < target.myDebuffDuration(spells.shadowWordPain) and mouseover.myDebuffDuration(spells.shadowWordPain) < focus.myDebuffDuration(spells.shadowWordPain)' , "mouseover" },
--{spells.voidEruption, 'mouseover.myDebuffDuration(spells.vampiricTouch) > 0 and mouseover.myDebuffDuration(spells.vampiricTouch) < target.myDebuffDuration(spells.vampiricTouch) and mouseover.myDebuffDuration(spells.vampiricTouch) < focus.myDebuffDuration(spells.vampiricTouch)' , "mouseover" },
--{spells.voidEruption, 'focus.myDebuffDuration(spells.shadowWordPain) > 0 and focus.myDebuffDuration(spells.shadowWordPain) < target.myDebuffDuration(spells.shadowWordPain)' , "focus" },
--{spells.voidEruption, 'focus.myDebuffDuration(spells.vampiricTouch) > 0 and focus.myDebuffDuration(spells.vampiricTouch) < target.myDebuffDuration(spells.vampiricTouch)' , "focus" },
