--[[[
@module Warlock Demonology Rotation
@author Kirk24788
@version 7.0.3
]]--
local spells = kps.spells.warlock
local env = kps.env.warlock

--[[
Suggested Talents (both rotations!):
Level 15: Shadowy Inspiration
Level 30: Impending Doom
Level 45: Demon Skin
Level 60: Power Trip
Level 75: Burning Rush
Level 90: Grimoire of Service
Level 100: Soul Conduit
]]--

kps.rotations.register("WARLOCK","DEMONOLOGY",
{
    -- Deactivate Burning Rush if not moving for 1 second
    env.deactivateBurningRushIfNotMoving(1),

    -- Cast Call Dreadstalkerswhenever available.
    {spells.callDreadstalkers},
    -- Cast Demonic Strength whenever available.
    {{"nested"}, 'player.hasTalent(1, 2)', {
        {spells.demonicStrength},
    }},
    -- Cast Summon Vilefiend or Soul Strike whenever available.
    {{"nested"}, 'player.hasTalent(4, 2)', {
        {spells.soulStrike},
    }},
    {{"nested"}, 'player.hasTalent(4, 3)', {
        {spells.summonVilefiend},
    }},
    -- Cast Hand of Gul'dan if you have 4-5 Soul Shards.
    {spells.handOfGuldan, 'player.soulShards >= 4'},
    -- Cast Implosion to detonate Wild Imps on 2+ targets.
    {spells.implosion, 'kps.multiBoss'},
    -- Cast Demonbolt if you have 3+ stacks of Demonic Core.
    {spells.demonbolt, 'player.buffStacks(spells.demonicCore) >= 3'},
    -- Cast Power Siphon to generate Demonic Core.
    {spells.powerSiphon, 'kps.multiBoss'},
    -- Cast Shadow Bolt to generate Soul Shards.
    {spells.shadowBolt},
}
,"IcyVeins")

