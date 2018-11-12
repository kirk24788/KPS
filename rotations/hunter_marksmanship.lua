--[[[
@module Hunter Marksmanship Rotation
@author kirk24788
@version 8.0.1
]]--
local spells = kps.spells.hunter
local env = kps.env.hunter

kps.rotations.register("HUNTER","MARKSMANSHIP", {
    {{"nested"}, 'kps.defensive', {
        {spells.exhilaration, 'player.hp < 0.6'},
        {spells.survivalOfTheFittest, 'player.hp < 0.5'},
    }},
    {spells.rapidFire, 'player.focus < 75'},
    {spells.aimedShot, 'not player.isMoving'},
    {spells.arcaneShot, 'player.hasBuff(spells.preciseShots)'},
    {spells.arcaneShot},
    {spells.steadyShot},

}
,"Icy Veins - Easy mode")
