--[[
@module Warlock Destruction Rotation
@author Kirk24788
]]

local spells = kps.spells.warlock
local env = kps.env.warlock

kps.runOnClass("WARLOCK", function ( )
    kps.gui.createToggle("conserve", "Interface\\Icons\\spell_Mage_Flameorb", "Conserve")
end)

kps.rotations.register("WARLOCK","DESTRUCTION",
{
    -- Deactivate Burning Rush if not moving for 1 second
    env.deactivateBurningRushIfNotMoving(1),

    -- Rain of Fire on shift (only when moving or multiTarget), force cast with ctrl-shift
    {spells.rainOfFire, 'keys.shift and player.buffDuration(spells.rainOfFire) < 1.5 and player.isMoving' },
    {spells.rainOfFire, 'keys.shift and player.buffDuration(spells.rainOfFire) < 1.5 and kps.multiTarget' },
    {spells.rainOfFire, 'keys.shift and keys.ctrl' },

    -- Cooldowns
    {{"nested"}, 'kps.cooldowns', {
        {spells.darkSoulInstability, 'not player.hasBuff(spells.darkSoulInstability) and spells.darkSoulInstability.cooldown == 0 and player.emberShards > 19'},
        {spells.darkSoulInstability, 'player.hasBuff(spells.darkSoulInstability).charges == 2 and player.emberShards > 9'},
    }},

    -- Havoc + ChaosBolt at focus (or mouseover on ctrl)
    {{"nested"}, 'not keys.alt', {
        {spells.havoc, 'isHavocUnit("mouseover") and keys.ctrl', "mouseover" },
        {spells.havoc, 'isHavocUnit("focus") and not player.isMoving and player.emberShards >= 10 and focus.isAttackable', "focus"  },
        {spells.chaosBolt, 'not player.isMoving and player.burningEmbers > 0 and player.buffStacks(spells.havoc)>=3'},
    }},
    -- Shadowburn/Chaos Bolt (Tier 18 - 4pc)
    {spells.shadowburn, 'mouseover.hpTotal < 1500000 and target.hp < 0.20 and player.emberShards >= 10 and mouseover.myDebuffDuration(spells.shadowburn) <= 1', 'mouseover'},
    {spells.shadowburn, 'target.hpTotal < 200000 and player.emberShards >= 10'},

    {{"nested"}, 'not kps.conserve and target.isRaidBoss and player.emberShards >= 10', {
        {spells.chaosBolt, 'target.hp < 0.20 and (player.hasMasteryProc or player.hasCritProc or player.hasIntProc)'},
        {spells.chaosBolt, 'target.hp < 0.20 and player.hasBuff(spells.darkSoulInstability)'},
    }},
    {{"nested"}, 'not kps.conserve and not target.isRaidBoss and player.emberShards >= 10', {
        {spells.shadowburn, 'target.hp < 0.20 and player.emberShards >= 35'},
        {spells.shadowburn, 'target.hp < 0.20 and (player.hasMasteryProc or player.hasCritProc or player.hasIntProc)'},
        {spells.shadowburn, 'target.hp < 0.20 and player.hasBuff(spells.darkSoulInstability)'},
    }},
    {{"nested"}, 'kps.conserve and player.emberShards >= 39', {
        {spells.chaosBolt, 'target.isRaidBoss or target.hp >= 0.20'},
        {spells.shadowburn, 'not target.isRaidBoss and target.hp < 0.20'},
    }},


    -- Simple MultiTarget: FireAndBrimstone + default rotation
    {{"nested"}, 'kps.multiTarget and not keys.alt', {
        {spells.fireAndBrimstone, 'player.burningEmbers > 0 and not player.hasBuff(spells.fireAndBrimstone) and not spells.fireAndBrimstone.isRecastAt("target")' },
        {spells.immolate, 'target.hpTotal > 1000000 and target.myDebuffDuration(spells.immolate) <= 1.0 and not spells.immolate.isRecastAt("target")'},
        {spells.chaosBolt, 'player.emberShards >= 35'},
        {spells.conflagrate, 'spells.conflagrate.charges >= 2'},
        {spells.immolate, 'target.hpTotal > 1000000 and target.myDebuffDuration(spells.immolate) <= 4.5 and not spells.immolate.isRecastAt("target")'},
        {spells.conflagrate},
        {spells.incinerate},
    }},
    -- Simple SingleTarget
    {{"nested"}, 'not kps.multiTarget and not keys.alt', {
        { {"macro"}, 'player.hasBuff(spells.fireAndBrimstone)', "/cancelaura "..spells.fireAndBrimstone },
        {spells.immolate, 'target.myDebuffDuration(spells.immolate) <= 1.0 and not spells.immolate.isRecastAt("target")'},
        {spells.conflagrate, 'spells.conflagrate.charges >= 2'},
        -- don't waste chaotic infusion if havoc cooldown is about to come off!
        {{"nested"}, 'not kps.conserve', {
            {spells.chaosBolt, 'player.emberShards >= 35'},
            {spells.chaosBolt, 'spells.havoc.cooldown > 12 and player.hasMasteryProc or player.hasCritProc or player.hasIntProc'},
            {spells.chaosBolt, 'player.hasBuff(spells.darkSoulInstability)'},
        }},
        {spells.immolate, 'target.myDebuffDuration(spells.immolate) <= 4.5 and not spells.immolate.isRecastAt("target")'},
        {spells.conflagrate},
        {spells.incinerate},
    }},
    -- Alt-Key modifier to stop Casting
    {{"nested"}, 'keys.alt', {
        kps.stopCasting,
        {spells.shadowburn, 'target.hp < 0.20 and player.emberShards >= 35'},
        {spells.conflagrate},
    }},

}
,"Destruction 6.2")
