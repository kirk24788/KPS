--[[[
@module Hunter Beastmaster Rotation
@author blackcardi
@version 7.2.0
]]--
local spells = kps.spells.hunter
local env = kps.env.hunter

kps.rotations.register("HUNTER","BEASTMASTERY",
{
    -- buffs
    {spells.callPet1, 'not player.hasPet'},
    -- { {"macro"}, 'player.hasBuff(spells.aspectOfTheCheetah)', "/cancelaura Aspect of the Cheetah" },

    -- interrupts
    {{"nested"}, 'kps.interrupt',{
        {spells.counterShot, 'target.isInterruptable'},
        {spells.counterShot, 'focus.isInterruptable', "focus" },
    }},

    -- defensive
    {{"nested"}, 'kps.defensive', {
        { {"macro"}, 'kps.useBagItem and player.hp < 0.40', "/use Healthstone" },
        {spells.exhilaration, 'player.hp < 0.32'},
        {spells.aspectOfTheTurtle, 'player.hp < 0.25'},
    }},

    -- situational

    -- cooldowns
    {{"nested"}, 'kps.cooldowns', {
        {{"nested"}, 'spells.bestialWrath.cooldown > 30', {
            { {"macro"}, 'kps.cooldowns', "/cast Berserking" },
            {spells.stampede},
            {spells.aMurderOfCrows},
            {spells.aspectOfTheWild},
            -- trinkets!
            --{ {"macro"}, 'kps.useBagItem', "/use 13" },
            { {"macro"}, 'kps.useBagItem', "/use 14" },
            -- pet attack, just in case!
            { {"macro"}, 'player.hasPet', "/petattack"}, -- loops
            -- cooldown racial
            { {"macro"}, 'kps.cooldowns', "/cast Blood Fury" },
        }},
    }},

    -- multitarget
    {{"nested"}, 'kps.multiTarget', {
        {spells.volley, 'not player.hasBuff(spells.volley)'},

        {spells.bestialWrath, 'player.focus >= 105'},

        {spells.killCommand, 'spells.bestialWrath.cooldown > 2'},
        {spells.direBeast,'spells.bestialWrath.cooldown > 2'},
        --{spells.direFrenzy, 'player.hasTalent(2, 2) and spells.bestialWrath.cooldown > 2'},
        {spells.multishot, 'pet.buffDuration(spells.beastCleave) < 0.75 and spells.bestialWrath.cooldown > 2'},
        {spells.cobraShot, 'player.focus > 90 and spells.bestialWrath.cooldown > 3 and pet.buffDuration(spells.beastCleave) > 1.5'},
    }},

    -- rotation
    {spells.volley, 'not player.hasBuff(spells.volley)'},
    {{"macro"}, 'keys.shift', "/cast [@cursor] Freezing Trap" },
    {spells.mendPet, 'pet.hp <= 0.45'},
    {spells.bestialWrath, 'player.focus >= 105'},
    {spells.aMurderOfCrows,'spells.bestialWrath.cooldown > 3 and not kps.multiTarget'},
    {spells.killCommand, 'spells.bestialWrath.cooldown > 2'},
    {spells.chimaeraShot},
    {spells.direBeast, 'spells.bestialWrath.cooldown > 2'},
    {spells.tarTrap, 'keys.shift'},
    --{spells.direFrenzy, 'player.hasTalent(2, 2) and spells.bestialWrath.cooldown > 2 and not player.focus >= 100'},
    {spells.barrage, 'player.hasTalent(6, 2)'},
    {spells.titansThunder},
    {spells.cobraShot, 'player.hasBuff(spells.bestialWrath) and spells.killCommand.cooldown > 1.5 and not kps.multiTarget'},
    {spells.cobraShot, 'player.focus > 90 and spells.bestialWrath.cooldown > 3 and not kps.multiTarget'},
    {{"macro"}, 'player.hasPet', "/petattack"},

}
,"Beastmastery 7.0.3 MU", {0, 0, 0, 0, 0, 0, 0})
