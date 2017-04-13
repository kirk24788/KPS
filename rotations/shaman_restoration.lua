--[[[
@module Shaman Restoration Rotation
@author E.Faber
@version 7.0.3
@untested
]]--
local spells = kps.spells.shaman
local env = kps.env.shaman


kps.rotations.register("SHAMAN","RESTORATION",
{

    {{"nested"}, 'keys.shift', {
        {spells.healingStreamTotem},
    }},

    {{"nested"}, 'keys.alt', {
        {spells.healingRain},
        {spells.healingTideTotem},
        {spells.spiritLinkTotem},
    }},

    {{"nested"}, 'player.hasBuff(spells.tidalWaves)', {

        {spells.healingWave, 'heal.defaultTank.hp < 0.7', kps.heal.defaultTank},
        {spells.chainHeal, 'heal.defaultTank.hp < 0.8', kps.heal.defaultTank},
    }},

    {{"nested"}, 'not player.hasBuff(spells.tidalWaves)', {
        {spells.riptide, 'heal.defaultTank.hp < 1', kps.heal.defaultTank},
        {spells.chainHeal, 'heal.defaultTank.hp < 0.8', kps.heal.defaultTank},
    }},
   
    {spells.chainHeal, 'heal.defaultTarget.hp < 0.6 and (heal.defaultTank.hasBuff(spells.riptide) or heal.defaultTarget.hasBuff(spells.riptide))', kps.heal.defaultTarget },

}
,"Resto.Shaman.E.Faber")