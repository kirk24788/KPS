--[[
@module Deathknight Blood Rotation
@author Kirk24788
]]
local spells = kps.spells.deathknight
local env = kps.env.deathknight

kps.runOnClass("DEATHKNIGHT", function ( )
    kps.gui.createToggle("noPresence", "Interface\\Icons\\Achievement_BG_killingblow_30", "No Presence!")
end)

kps.rotations.register("DEATHKNIGHT","BLOOD",
{
    -- Blood presence
    {spells.bloodPresence, 'not kps.noPresence and not player.hasBuff(spells.bloodPresence)'},
    {spells.hornOfWinter, 'not player.hasBuff(spells.hornOfWinter)'},


    -- SHIFT: Death and Decay
    {spells.deathAndDecay,'keys.shift'},

    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.lichborne, 'player.hp < 0.5 and player.runicPower >= 40 and player.hasTalent(2, 1)'},
        {spells.deathCoil, 'player.hp < 0.9 and player.runicPower >= 40 and player.hasBuff(spells.lichborne)'},
        {spells.runeTap, 'player.hp < 0.8 and not player.hasBuff(spells.runeTap)'},
        {spells.iceboundFortitude, 'player.hp < 0.3'},
        {spells.vampiricBlood, 'player.hp < 0.4'},
    }},

    -- CD's
    {{"nested"}, 'kps.cooldowns', {
        {spells.empowerRuneWeapon, 'target.distance <= 10 and player.allRunes <= 2 and player.bloodRunes <= 1 and player.frostRunes <= 1 and player.unholyRunes <= 1 and player.runicPower < 30'},
    }},

    -- Interrupt Target
    {{"nested"}, 'kps.interrupt and target.isInterruptable', {
        {spells.mindFreeze},
        {spells.strangulate, 'not spells.mindFreeze.isRecastAt("target")'},
        {spells.asphyxiate, 'not spells.strangulate.isRecastAt("target")'},
    }},

    {spells.boneShield,'not player.hasBuff(spells.boneShield)'},

    -- Diseases
    {spells.unholyBlight,'target.myDebuffDuration(spells.frostFever) < 2'},
    {spells.unholyBlight,'target.myDebuffDuration(spells.bloodPlague) < 2'},
    {spells.outbreak,'target.myDebuffDuration(spells.frostFever) < 2'},
    {spells.outbreak,'target.myDebuffDuration(spells.bloodPlague) < 2'},

    -- Multi Target
    {{"nested"}, 'activeEnemies.count >= 3', {
        {spells.bloodBoil, 'target.distance <= 10'},
    }},

    -- Rotation
    {spells.deathStrike, 'player.hp < 0.7'},
    {spells.deathStrike, 'player.buffDuration(spells.bloodShield) <= 4'},
    {spells.soulReaper, 'player.hp <= 0.35'},
    {spells.plagueStrike, 'not target.hasMyDebuff(spells.bloodPlague)'},
    {spells.icyTouch, 'not target.hasMyDebuff(spells.frostFever)'},
    {spells.deathStrike},

    -- Death Siphon when we need a bit of healing. (talent based)
    {spells.deathSiphon,'player.hp < 0.6'}, -- moved here, because we heal often more with Death Strike than Death Siphon
    {spells.deathCoil,'player.runicPower >= 30 and not player.hasBuff(spells.lichborne)'},
    {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) >= 5'},
}
,"JPS")
