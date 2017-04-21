--[[[
@module Warlock Destruction Rotation
@author Kirk24788
@version 7.0.3
]]--

local spells = kps.spells.warlock
local env = kps.env.warlock

--[[
Suggested Talents:
Level 15: Roaring Blaze
Level 30: Reverse Entropy
Level 45: Demon Skin
Level 60: Eradication
Level 75: Burning Rush
Level 90: Grimoire of Service
Level 100: Soul Conduit
]]--

kps.rotations.register("WARLOCK","DESTRUCTION","Icy Veins").setCombatTable(
{
    -- Deactivate Burning Rush if not moving for 1 second
    env.deactivateBurningRushIfNotMoving(1),

    -- Apply  Havoc if a secondary target is present.
    {{"nested"}, 'not player.hasTalent(7, 1)', {
        {spells.havoc, 'isHavocUnit("mouseover") and keys.ctrl', "mouseover" },
        {spells.havoc, 'isHavocUnit("focus") and focus.isAttackable', "focus"  },
    }},
    {{"nested"}, 'player.hasTalent(7, 1)', {
        {spells.havoc, 'focus.myDebuffDuration(spells.havoc) <= 2.0', "focus"  },
    }},

    -- Maintain Immolate on your main target(s).
    {spells.immolate, 'focus.myDebuffDuration(spells.immolate) <= 1.0 and not spells.immolate.isRecastAt("focus")', "focus"},
    {spells.immolate, 'target.myDebuffDuration(spells.immolate) <= 1.0 and not spells.immolate.isRecastAt("target")'},

    -- Cast Conflagrate  immediately following a fresh application of Immolate.
    {spells.conflagrate, 'spells.immolate.isRecastAt("target")'},

    -- Cast Chaos Bolt if you have 5 Soul Shards.
    {spells.chaosBolt, 'player.soulShards >= 5'},

    -- Cast Shadowburn (if talented) if the target will die within 5 seconds.
    -- Has to be done manually - and probably isn't selected anyways

    -- Cast Summon Doomguard on cooldown.
    {spells.summonDoomguard, 'kps.cooldowns'},

    -- Cast Grimoire: Imp on cooldown.
    {spells.grimoireImp, 'kps.cooldowns'},

    -- Cast Rain of Fire on large groups of stacked targets.
    {spells.rainOfFire, 'keys.shift and player.soulShards >=3 and player.buffDuration(spells.rainOfFire) < 1.5 and player.isMoving' },
    {spells.rainOfFire, 'keys.shift and player.soulShards >=3 and player.buffDuration(spells.rainOfFire) < 1.5 and activeEnemies.count >= 3' },
    {spells.rainOfFire, 'keys.shift and player.soulShards >=3 and keys.ctrl' },

    -- Cast Conflagrate to generate Soul Shards.
    {spells.conflagrate},

    -- Cast Chaos Bolt to maintain Eradication Icon Eradication.
    {spells.chaosBolt, 'player.soulShards >= 2 and not target.debuffDuration(spells.eradication) <= 0.0'},

    -- Cast Conflagrate to generate Soul Shards.
    {spells.incinerate},
}).setExpectedTalents({0,0,0,0,0,2,0})
