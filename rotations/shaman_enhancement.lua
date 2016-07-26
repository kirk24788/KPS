--[[[
@module Shaman Enhancement Rotation
@generated_from shaman_enhancement.simc
@version 7.0.3
]]--
local spells = kps.spells.shaman
local env = kps.env.shaman


kps.rotations.register("SHAMAN","ENHANCEMENT",
{
    {spells.windShear}, -- wind_shear
    {spells.bloodlust, 'target.hp < 25 or player.timeInCombat > 0.500'}, -- bloodlust,if=target.health.pct<25|time>0.500
    {spells.feralSpirit}, -- feral_spirit
    {spells.boulderfist, 'not player.hasBuff(spells.boulderfist)'}, -- boulderfist,if=!buff.boulderfist.up
    {spells.ascendance}, -- ascendance
    {spells.windsong}, -- windsong
    {spells.furyOfAir, 'not target.hasMyDebuff(spells.furyOfAir)'}, -- fury_of_air,if=!ticking
-- ERROR in 'frostbrand,if=talent.hailstorm.enabled&buff.frostbrand.remains<4.8': Unknown Talent 'hailstorm' for 'shaman'!
    {spells.flametongue, 'player.buffDuration(spells.flametongue) < 4.8'}, -- flametongue,if=buff.flametongue.remains<4.8
    {spells.doomWinds}, -- doom_winds
    {spells.crashLightning, 'activeEnemies.count >= 3'}, -- crash_lightning,if=active_enemies>=3
    {spells.windstrike}, -- windstrike
    {spells.stormstrike}, -- stormstrike
-- ERROR in 'lightning_bolt,if=talent.overcharge.enabled&maelstrom>=45': Unknown Talent 'overcharge' for 'shaman'!
    {spells.lavaLash, 'player.buffStacks(spells.hotHand)'}, -- lava_lash,if=buff.hot_hand.react
    {spells.boulderfist, 'spells.boulderfist.charges >= 1.5'}, -- boulderfist,if=charges_fractional>=1.5
    {spells.earthenSpike}, -- earthen_spike
-- ERROR in 'crash_lightning,if=active_enemies>1|talent.crashing_storm.enabled|(pet.feral_spirit.remains>5|pet.frost_wolf.remains>5|pet.fiery_wolf.remains>5|pet.lightning_wolf.remains>5)': Unknown Talent 'crashingStorm' for 'shaman'!
    {spells.sundering}, -- sundering
-- ERROR in 'lava_lash,if=maelstrom>=120': Unknown expression 'maelstrom'!
-- ERROR in 'flametongue,if=talent.boulderfist.enabled': Unknown Talent 'boulderfist' for 'shaman'!
    {spells.boulderfist}, -- boulderfist
    {spells.rockbiter}, -- rockbiter
}
,"shaman_enhancement.simc")
