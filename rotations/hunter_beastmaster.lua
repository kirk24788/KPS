--[[[
@module Hunter Beastmaster Rotation
@author markusem
@version 7.0.3
]]--
local spells = kps.spells.hunter
local env = kps.env.hunter


-- Talents:
-- Tier 1: Dire Stable, Way of the Cobra
-- Tier 2: Stomp, Chimaera Shot
-- Tier 3: Posthaste, Dash
-- Tier 4: Bestial Fury
-- Tier 5: Blinding Shot (whatever talent really)
-- Tier 6: A Murder of Crows, Barrage, Volley (for AOE)
-- Tier 7: Stampede

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
        { {"macro"}, 'kps.useBagItem and player.hp < 0.70', "/use Healthstone" },
        {spells.exhilaration, 'player.hp < 0.40'},
        {spells.aspectOfTheTurtle, 'player.hp < 0.30'},
    }},

    -- situational

    -- cooldowns
    {{"nested"}, 'kps.cooldowns', {
        {{"nested"}, 'spells.bestialWrath.cooldown > 30', {
            {spells.stampede},
            {spells.aMurderOfCrows},
            {spells.aspectOfTheWild},
            -- trinkets!
            { {"macro"}, 'kps.useBagItem', "/use 13" },
            { {"macro"}, 'kps.useBagItem', "/use 14" },
            -- pet attack, just in case!
            -- { {"macro"}, 'player.hasPet', "/petassist"}, -- loops
            -- cooldown racial
            { {"macro"}, 'kps.cooldowns', "/cast Blood Fury" },
        }},
    }},

    -- multitarget
    {{"nested"}, 'kps.multiTarget', {
        {spells.volley, 'not player.hasBuff(spells.volley)'},

        {spells.bestialWrath, 'player.focus >= 110'},

        {spells.killCommand, 'spells.bestialWrath.cooldown > 2'},
        {spells.direBeast,'spells.bestialWrath.cooldown > 2'},
        {spells.direFrenzy, 'player.hasTalent(2, 2) and spells.bestialWrath.cooldown > 2'},
        {spells.multishot, 'pet.buffDuration(spells.beastCleave) < 0.5 and spells.bestialWrath.cooldown > 2'},
        {spells.cobraShot, 'player.focus > 90 and spells.bestialWrath.cooldown > 3 and pet.buffDuration(spells.beastCleave) > 1.5'},
    }},

    -- rotation
    {spells.bestialWrath, 'player.focus >= 110'},

    {spells.killCommand, 'spells.bestialWrath.cooldown > 2'},
    {spells.chimaeraShot},
    {spells.direBeast,'spells.bestialWrath.cooldown > 2'},

    {spells.direFrenzy, 'player.hasTalent(2, 2) and spells.bestialWrath.cooldown > 2'},
    {spells.barrage, 'player.hasTalent(6, 2)'},

    {spells.cobraShot, 'player.hasBuff(spells.bestialWrath) and not kps.multiTarget'},
    {spells.cobraShot, 'player.focus > 90 and spells.bestialWrath.cooldown > 3'},

}
,"Beastmastery 7.0.3 MU", {-1, -2, -2, 2, 0, 0, 1})
