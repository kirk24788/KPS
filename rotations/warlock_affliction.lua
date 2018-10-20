--[[[
@module Warlock Affliction Rotation
@author Kirk24788
@version 8.0.1
]]--
local spells = kps.spells.warlock
local env = kps.env.warlock

kps.runAtEnd(function()
    kps.gui.addCustomToggle("WARLOCK","AFFLICTION", "multiBoss", "Interface\\Icons\\achievement_boss_lichking", "MultiDot Bosses")
end)


kps.rotations.register("WARLOCK","AFFLICTION",
{
    -- Deactivate Burning Rush if not moving for 1 second
    env.deactivateBurningRushIfNotMoving(1),


    -- Maintain Agony (on up to 3 targets, including Soul Effigy) at all times.
    {spells.agony, 'target.myDebuffDuration(spells.agony) <= 7.2'},
    {spells.agony, 'focus.myDebuffDuration(spells.agony) <= 7.2', 'focus'},
    {spells.agony, 'mouseover.myDebuffDuration(spells.agony) <= 7.2', 'mouseover'},
    {{"nested"}, 'kps.multiBoss', {
        {spells.agony, 'boss1.myDebuffDuration(spells.agony) <= 7.2', 'boss1'},
        {spells.agony, 'boss2.myDebuffDuration(spells.agony) <= 7.2', 'boss2'},
        {spells.agony, 'boss3.myDebuffDuration(spells.agony) <= 7.2', 'boss3'},
        {spells.agony, 'boss4.myDebuffDuration(spells.agony) <= 7.2', 'boss4'},
    }},

    -- Maintain Corruption (on up to 3 targets, including Soul Effigy) at all times and all bosses.
    {{"nested"}, 'player.hasTalent(2, 2)', {
        {spells.corruption, 'not target.hasMyDebuff(spells.corruption)'},
        {spells.corruption, 'not focus.hasMyDebuff(spells.corruption)', 'focus'},
        {spells.corruption, 'not mouseover.hasMyDebuff(spells.corruption)', 'mouseover'},
        {{"nested"}, 'kps.multiBoss', {
            {spells.corruption, 'boss1.hasMyDebuff(spells.corruption)', 'boss1'},
            {spells.corruption, 'boss2.hasMyDebuff(spells.agony)', 'boss2'},
            {spells.corruption, 'boss3.hasMyDebuff(spells.agony)', 'boss3'},
            {spells.corruption, 'boss4.hasMyDebuff(spells.agony)', 'boss4'},
        }},
    }},
    {{"nested"}, 'not player.hasTalent(2, 2)', {
        {spells.corruption, 'target.myDebuffDuration(spells.corruption) <= 5.4'},
        {spells.corruption, 'focus.myDebuffDuration(spells.corruption) <= 5.4', 'focus'},
        {spells.corruption, 'mouseover.myDebuffDuration(spells.corruption) <= 5.4', 'mouseover'},
        {{"nested"}, 'kps.multiBoss', {
            {spells.corruption, 'boss1.myDebuffDuration(spells.corruption) <= 5.4', 'boss1'},
            {spells.corruption, 'boss2.myDebuffDuration(spells.corruption) <= 5.4', 'boss2'},
            {spells.corruption, 'boss3.myDebuffDuration(spells.corruption) <= 5.4', 'boss3'},
            {spells.corruption, 'boss4.myDebuffDuration(spells.corruption) <= 5.4', 'boss4'},
        }},
    }},
    -- Maintain Siphon Life
    {{"nested"}, 'player.hasTalent(2, 3)', {
        {spells.siphonLife, 'target.myDebuffDuration(spells.siphonLife) <= 5.4'},
        {spells.siphonLife, 'focus.myDebuffDuration(spells.siphonLife) <= 5.4', 'focus'},
        {spells.siphonLife, 'mouseover.myDebuffDuration(spells.siphonLife) <= 5.4', 'mouseover'},
        {{"nested"}, 'kps.multiBoss', {
            {spells.siphonLife, 'boss1.myDebuffDuration(spells.siphonLife) <= 5.4', 'boss1'},
            {spells.siphonLife, 'boss2.myDebuffDuration(spells.siphonLife) <= 5.4', 'boss2'},
            {spells.siphonLife, 'boss3.myDebuffDuration(spells.siphonLife) <= 5.4', 'boss3'},
            {spells.siphonLife, 'boss4.myDebuffDuration(spells.siphonLife) <= 5.4', 'boss4'},
        }},
    }},
    -- Cast Unstable Affliction if you reach 5 Soul Shards.
    {spells.unstableAffliction, 'player.soulShards >= 5'},

    -- Cast Haunt whenever available.
    {{"nested"}, 'player.hasTalent(6, 2)', {
        {spells.haunt},
    }},

    -- Cast Phantom Singularity whenever available
    {{"nested"}, 'player.hasTalent(4, 2)', {
        {spells.phantomSingularity},
    }},

    --  Apply one Unstable Affliction immediately before casting Deathbolt.
    --{spells.unstableAffliction, 'player.soulShards >= 1 and spells.deathbolt.cooldown <= 1.4 and spells.deathbolt.cooldown > 0'},

    -- Cast Deathbolt whenever available. Apply one Unstable Affliction immediately before casting Deathbolt.
    --{spells.deathbolt},
    {spells.deathbolt},

    -- Maintain 1 Unstable Affliction as often as possible for the damage increase.
    --{spells.unstableAffliction, 'player.soulShards >= 1 and target.myDebuffDuration(spells.unstableAffliction) <= 1.4'},
    {spells.unstableAffliction, 'not target.hasMyDebuff(spells.unstableAffliction)'},

    -- Cast Drain Life/Drain Soul Icon Drain Soul as a filler. (Spell names don't matter!)
    {spells.shadowBolt},
}
,"Icy Veins Raid", {3,-1,0,2,0,2,2})


local simcraftFillers = {
-- if=remains<18&cooldown.summon_darkglare.remains>=30+gcd&cooldown.deathbolt.remains<=gcd&!prev_gcd.1.summon_darkglare&!prev_gcd.1.agony

    {spells.agony, 'target.myDebuffDuration(spells.agony) <= 18 and spells.summonDarkglare.cooldown >= 30+player.gcd and spells.deathbolt.cooldown <= player.gcd and not spells.agony.isRecastAt("target")'},
    {spells.deathbolt, 'spells.summonDarkglare.cooldown >= 30+player.gcd or spells.summonDarkglare.cooldown >= 140'},
    --actions.fillers+=/shadow_bolt,if=buff.movement.up&buff.nightfall.remains
    {spells.agony, 'player.isMoving and target.myDebuffDuration(spells.agony) < 18 and not spells.agony.isRecastAt("target")'},
    {spells.corruption, 'player.isMoving and target.myDebuffDuration(spells.corruption) < 16 and not spells.corruption.isRecastAt("target")'},
--actions.fillers+=/drain_life,if=(buff.inevitable_demise.stack>=90&(cooldown.deathbolt.remains>execute_time|!talent.deathbolt.enabled)&(cooldown.phantom_singularity.remains>execute_time|!talent.phantom_singularity.enabled)&(cooldown.dark_soul.remains>execute_time|!talent.dark_soul_misery.enabled)&(cooldown.vile_taint.remains>execute_time|!talent.vile_taint.enabled)&cooldown.summon_darkglare.remains>execute_time+10|buff.inevitable_demise.stack>30&target.time_to_die<=10)


    {spells.shadowBolt},
}

kps.rotations.register("WARLOCK","AFFLICTION",
{
    -- Deactivate Burning Rush if not moving for 1 second
    env.deactivateBurningRushIfNotMoving(1),

    {spells.haunt},

    {{"nested"}, 'kps.cooldowns and not player.isMoving', {
        { {"macro"}, "player.useTrinket(0)" , "/use 13"},
        { {"macro"}, "player.useTrinket(1)" , "/use 14"},
        {spells.summonDarkglare, 'target.hasMyDebuff(spells.corruption) and target.hasMyDebuff(spells.corruption) and (target.myDebuffCount==5 or player.soulShards==0) and spells.phantomSingularity.cooldown > 0'},
    }},
    -- actions+=/shadow_bolt,target_if=min:debuff.shadow_embrace.remains,if=talent.shadow_embrace.enabled&talent.absolute_corruption.enabled&active_enemies=2&debuff.shadow_embrace.remains&debuff.shadow_embrace.remains<=execute_time*2+travel_time&!action.shadow_bolt.in_flight
    {spells.phantomSingularity, 'kps.timeInCombat > 40 and spells.summonDarkglare.cooldown >= 45 or spells.summonDarkglare.cooldown < 8'},

    {spells.agony, 'target.myDebuffDuration(spells.agony) <= 7.2'},
    {spells.agony, 'focus.myDebuffDuration(spells.agony) <= 7.2', 'focus'},
    {spells.agony, 'mouseover.myDebuffDuration(spells.agony) <= 7.2', 'mouseover'},

    {spells.siphonLife, 'target.myDebuffDuration(spells.siphonLife) <= 5.4'},
    {spells.siphonLife, 'focus.myDebuffDuration(spells.siphonLife) <= 5.4', 'focus'},
    {spells.siphonLife, 'mouseover.myDebuffDuration(spells.siphonLife) <= 5.4', 'mouseover'},

    {{"nested"}, 'player.hasTalent(2, 2)', {
        {spells.corruption, 'not target.hasMyDebuff(spells.corruption)'},
        {spells.corruption, 'not focus.hasMyDebuff(spells.corruption)', 'focus'},
        {spells.corruption, 'not mouseover.hasMyDebuff(spells.corruption)', 'mouseover'},
    }},
    {{"nested"}, 'not player.hasTalent(2, 2)', {
        {spells.corruption, 'target.myDebuffDuration(spells.corruption) <= 5.4'},
        {spells.corruption, 'focus.myDebuffDuration(spells.corruption) <= 5.4', 'focus'},
        {spells.corruption, 'mouseover.myDebuffDuration(spells.corruption) <= 5.4', 'mouseover'},
    }},

    {spells.phantomSingularity, 'kps.timeInCombat < 40'},

    {spells.darkSoulMisery, 'kps.cooldowns'},
    {spells.unstableAffliction, 'player.soulShards >= 5'},
    {spells.unstableAffliction, 'spells.summonDarkglare.cooldown <= player.soulShards*spells.unstableAffliction.castTime'},
    {{"nested"}, '(spells.summonDarkglare.cooldown <player.timeToShard*(5-player.soulShards) or spells.summonDarkglare.cooldown>0) and target.timeToDie > spells.summonDarkglare.cooldown', simcraftFillers },
--actions+=/unstable_affliction,if=(talent.deathbolt.enabled&cooldown.deathbolt.remains<=execute_time|soul_shard>=2&target.time_to_die>4+execute_time&target.time_to_die<=8+execute_time*soul_shard)

    --{spells.unstableAffliction, 'player.soulShards >= 1 and target.myDebuffDuration(spells.unstableAffliction) <= 1.4'},
    {spells.unstableAffliction, 'target.myDebuffDuration(spells.unstableAffliction) <= spells.unstableAffliction.castTime'},
    {spells.unstableAffliction, '(spells.deathbolt.cooldown>player.timeToShard or player.soulShards>1) and target.myDebuffDuration(spells.unstableAffliction) <= spells.unstableAffliction.castTime'},

    {{"nested"}, 'true', simcraftFillers },

}
,"Simcraft", {3,3,0,2,0,2,3})

