--[[[
@module Warlock Affliction Rotation
@author Kirk24788
@version 6.2.2
]]--
local spells = kps.spells.warlock
local env = kps.env.warlock


kps.rotations.register("WARLOCK","AFFLICTION",
{
    -- Deactivate Burning Rush if not moving for 1 second
    env.deactivateBurningRushIfNotMoving(1),

    -- Cooldowns
    {{"nested"}, 'kps.cooldowns', {
        {spells.darkSoulMisery, 'not player.hasBuff(spells.darkSoulMisery) and spells.darkSoulMisery.cooldown == 0 and player.soulShards >= 2'},
        {spells.darkSoulMisery, 'player.hasBuff(spells.darkSoulMisery).charges == 2 and player.soulShards >= 1'},
    }},


    {{"nested"}, 'not kps.multiTarget', {
        {{spells.soulburn, spells.haunt, spells.soulburn, spells.soulSwap}, 'player.timeInCombat < 2 and player.soulShards>=4 and target.isRaidBoss'},
        {spells.agony, 'target.myDebuffDuration(spells.agony) <= 7.2'},
        {spells.corruption, 'target.myDebuffDuration(spells.corruption) <= 5.4'},
        {spells.unstableAffliction, 'target.myDebuffDuration(spells.unstableAffliction) <= 4.2'},

        {spells.agony, 'focus.myDebuffDuration(spells.agony) <= 7.2', 'focus'},
        {spells.corruption, 'focus.myDebuffDuration(spells.corruption) <= 5.4', 'focus'},
        {spells.unstableAffliction, 'focus.myDebuffDuration(spells.unstableAffliction) <= 4.2', 'focus'},

        {spells.agony, 'mouseover.myDebuffDuration(spells.agony) <= 7.2', 'mouseover'},
        {spells.corruption, 'mouseover.myDebuffDuration(spells.corruption) <= 5.4', 'mouseover'},
        {spells.unstableAffliction, 'mouseover.myDebuffDuration(spells.unstableAffliction) <= 4.2', 'mouseover'},

        {spells.agony, 'boss1.myDebuffDuration(spells.agony) <= 7.2 and not kps.conserve', 'boss1'},
        {spells.corruption, 'boss1.myDebuffDuration(spells.corruption) <= 5.4 and not kps.conserve', 'boss1'},
        {spells.unstableAffliction, 'boss1.myDebuffDuration(spells.unstableAffliction) <= 4.2 and not kps.conserve', 'boss1'},

        {spells.agony, 'boss2.myDebuffDuration(spells.agony) <= 7.2 and not kps.conserve', 'boss2'},
        {spells.corruption, 'boss2.myDebuffDuration(spells.corruption) <= 5.4 and not kps.conserve', 'boss2'},
        {spells.unstableAffliction, 'boss2.myDebuffDuration(spells.unstableAffliction) <= 4.2 and not kps.conserve', 'boss2'},

        {spells.agony, 'boss3.myDebuffDuration(spells.agony) <= 7.2 and not kps.conserve', 'boss3'},
        {spells.corruption, 'boss3.myDebuffDuration(spells.corruption) <= 5.4 and not kps.conserve', 'boss3'},
        {spells.unstableAffliction, 'boss3.myDebuffDuration(spells.unstableAffliction) <= 4.2 and not kps.conserve', 'boss3'},

        {spells.agony, 'boss4.myDebuffDuration(spells.agony) <= 7.2 and not kps.conserve', 'boss4'},
        {spells.corruption, 'boss4.myDebuffDuration(spells.corruption) <= 5.4 and not kps.conserve', 'boss4'},
        {spells.unstableAffliction, 'boss4.myDebuffDuration(spells.unstableAffliction) <= 4.2 and not kps.conserve', 'boss4'},

        --{spells.haunt, '(target.myDebuffDuration(spells.haunt) <= 0.5 or player.souldShards>=4) and (player.hasProc or player.hasBuff(spells.darkSoulMisery) or player.soulShards >= 3)'},
        {{spells.soulburn, spells.haunt}, 'not player.hasBuff(spells.soulburn) and player.soulShards>=2 and player.buffDuration(spells.hauntingSpirits) < 9'},
        {spells.haunt, 'not spells.haunt.isRecastAt("target") and (player.hasProc or player.hasBuff(spells.darkSoulMisery)) and player.soulShards >= 3'},
        {spells.haunt, 'not spells.haunt.isRecastAt("target") and player.soulShards >= 4'},
        {spells.lifeTap, 'player.mana < 0.4 and not player.hasBuff(spells.darkSoulMisery)'},
        {spells.drainSoul}, -- drain_soul,interrupt=1,chain=1
    }},

    {{"nested"}, 'kps.multiTarget', {
        {{spells.soulburn, spells.seedOfCorruption}, 'not player.hasBuff(spells.soulburn) and player.soulShards>=2 and target.myDebuffDuration(spells.corruption) <= 3.0'},
        {spells.corruption, 'target.myDebuffDuration(spells.corruption) <= 3.0 and target.hpTotal > 350000'},
        {spells.agony, 'target.myDebuffDuration(spells.agony) <= 5.2 and target.hpTotal > 350000'},
        --{spells.corruption, 'focus.myDebuffDuration(spells.corruption) <= 3.0', 'focus'},
        --{spells.agony, 'focus.myDebuffDuration(spells.agony) <= 5.2', 'focus'},
        --{spells.corruption, 'mouseover.myDebuffDuration(spells.corruption) <= 3.0', 'mouseover'},
        --{spells.agony, 'mouseover.myDebuffDuration(spells.agony) <= 5.2', 'mouseover'},
        {spells.lifeTap, 'player.mana < 0.4 and not player.hasBuff(spells.darkSoulMisery)'},
        {spells.seedOfCorruption},
    }},
}
,"Icy Veins")
