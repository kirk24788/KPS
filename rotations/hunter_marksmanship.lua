--[[[
@module Hunter Marksmanship Rotation
@author Silk_sn
@version 7.0.3
]]--
local spells = kps.spells.hunter
local env = kps.env.hunter

--[[
Mandatory talents :
Tier 1 ==> Lone Wolf or Careful Aim (not recommended with Sidewinders)
Tier 2 ==> Lock and Load or True Aim (not recommended with Sidewinders)
Tier 3 ==> did not affect rotation
Tier 4 ==> Patient Sniper
Tier 5 ==> did not affect rotation
Tier 6 ==> A Murder of Crows
Tier 7 ==> Sidewinders
]]
kps.rotations.register("HUNTER","MARKSMANSHIP",
{
    --Survival
    {spells.exhilaration, 'player.hp<0.3'},

    --Burst
    {spells.trueshot, 'kps.cooldowns'},

    --DPS
    {spells.markedShot, 'not target.hasMyDebuff(spells.vulnerable) or target.myDebuffDuration(spells.vulnerable) < 2)'},
    {spells.aimedShot, 'target.myDebuffDuration(spells.vulnerable) >= 2'},
    {spells.sidewinders, '(player.hasBuff(spells.markingTargets) and player.focus >= 60) or spells.sidewinders.charges == 2'},
    {spells.aMurderOfCrows},
    {spells.aimedShot, 'player.focus >= 130'},

}
,"hunter marksmanship", {-3, -2, 0, 3, 0, 1, 1})
