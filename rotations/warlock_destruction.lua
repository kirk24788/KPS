--[[[
@module Warlock Destruction Rotation
@author Kirk24788
@version 8.0.1
]]--

local spells = kps.spells.warlock
local env = kps.env.warlock

--[[
Suggested Talents:
Level 15: Eradication
Level 30: Internal combustion
Level 45: Burning Rush
Level 60: Cataclysm
Level 75: Demonic Circle
Level 90: Roaring Blaze
Level 100: Channel Demonfire
]]--

kps.rotations.register("WARLOCK","DESTRUCTION",
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

    -- Cast Conflagrate Icon Conflagrate if you have 2 charges.
    {spells.chaosBolt, 'player.soulShards >= 5'},

    -- Cast Conflagrate  immediately following a fresh application of Immolate.
    {spells.conflagrate, 'spells.conflagrate.charges >= 2'},

    -- Cast Channel Demonfire Icon Channel Demonfire whenever available.
    {spells.channelDemonfire, 'spells.immolate.isRecastAt("target")'},

    -- Cast Chaos Bolt to maintain Eradication Icon Eradication.
    {{"nested"}, 'player.hasTalent(1, 2)', {
        {spells.chaosBolt, 'player.soulShards >= 2 and not target.debuffDuration(spells.eradication) <= 0.0'},
    }},

    -- Cast Cataclysm Icon Cataclysm when available.
    {spells.cataclysm, 'target.guid == mouseover.guid'},

    -- Cast Rain of Fire on large groups of stacked targets.
    {spells.rainOfFire, 'keys.shift and player.soulShards >=3 and player.buffDuration(spells.rainOfFire) < 1.5 and player.isMoving' },
    {spells.rainOfFire, 'keys.shift and player.soulShards >=3 and player.buffDuration(spells.rainOfFire) < 1.5 and activeEnemies.count >= 3' },
    {spells.rainOfFire, 'keys.shift and player.soulShards >=3 and keys.ctrl' },

    -- Cast Conflagrate to generate Soul Shards.
    {spells.conflagrate},

    -- Cast Conflagrate to generate Soul Shards.
    {spells.incinerate},
}
,"Destruction 8.0.1", {0,0,0,0,0,2,0})
