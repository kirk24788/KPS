--[[[
@module Deathknight Unholy Rotation
@author markusem
@version 7.0.3
]]--
local spells = kps.spells.deathknight
local env = kps.env.deathknight

--[[

-- Talents:
-- Tier 1: Ebon Fever
-- Tier 2: Pestilunt Pustules
-- Tier 3: Clawing Shadows
-- Tier 4: Sludge Belcher
-- Tier 5: Lingering Apparition
-- Tier 6: Shadow Infusion
-- Tier 7: Dark Arbiter

]]

kps.rotations.register("DEATHKNIGHT","UNHOLY",
{

    -- buffs
    {spells.raiseDead, 'not player.hasPet'},

    -- interrupts
    {{"nested"}, 'kps.interrupt and target.isInterruptable', {
        {spells.mindFreeze},
        {spells.asphyxiate, 'not spells.strangulate.isRecastAt("target")'},
    }},

    -- defensive
    {{"nested"}, 'kps.defensive', {
        { {"macro"}, 'kps.useBagItem and player.hp < 0.70', "/use Healthstone" },
        -- {spells.deathStrike, 'player.hp < 0.7'},
        {spells.iceboundFortitude, 'player.hp < 0.3'},
    }},

    -- situational
    {spells.deathAndDecay, 'keys.shift'}, -- also does Defile

    -- diseases
    -- {spells.outbreak, 'not target.hasMyDebuff(spells.virulentPlague)'},
    {spells.outbreak, 'target.myDebuffDuration(spells.virulentPlague) < 2'},

    -- multitarget
    -- WORK ON IT

    -- cooldowns
    {{"nested"}, 'kps.cooldowns', {
        {spells.summonGargoyle, 'not player.hasTalent(7,1)'},

        {{"nested"}, 'spells.darkArbiter.cooldown > 60', {
            -- trinkets!
            { {"macro"}, 'kps.useBagItem', "/use 13" },
            { {"macro"}, 'kps.useBagItem', "/use 14" },
            -- racial!
            { {"macro"}, 'kps.cooldowns', "/cast Blood Fury" },
        }},
        -- pet attack, just in case!
        -- { {"macro"}, 'player.hasPet', "/petassist"}, --loops

        {spells.darkTransformation},
        {spells.darkArbiter, 'player.runicPower > 90'},
        {spells.deathCoil, 'spells.darkArbiter.cooldown > 165'},
        {spells.deathCoil, 'player.runicPower > 95'},
        {spells.deathCoil, 'player.hasBuff(spells.suddenDoom)'},
        {spells.festeringStrike, 'target.debuffStacks(spells.festeringWound) < 5'},
        {spells.clawingShadows, 'target.debuffStacks(spells.festeringWound) >= 1'},
        {spells.deathCoil, 'pet.hasBuff(spells.darkTransformation) and player.runicPower > 85'},
        {spells.deathCoil, 'spells.darkArbiter.cooldown > 10 and not pet.hasBuff(spells.darkTransformation)'},
    }},

    -- rotation
    {{"nested"}, 'not kps.cooldowns', {
        {spells.darkTransformation},

        {spells.deathCoil, 'spells.darkArbiter.cooldown > 165'},

        {spells.deathCoil, 'player.runicPower > 95'},
        {spells.deathCoil, 'player.hasBuff(spells.suddenDoom)'},
        {spells.festeringStrike, 'target.debuffStacks(spells.festeringWound) < 5'},
        {spells.clawingShadows, 'target.debuffStacks(spells.festeringWound) >= 1'},
        {spells.deathCoil, 'pet.hasBuff(spells.darkTransformation) and player.runicPower > 85'},
        {spells.deathCoil, 'not pet.hasBuff(spells.darkTransformation) and player.runicPower > 70'},
    }},

}
,"Unholy 7.0.3 MU", {3, 2, 3, 1, 3, 1, 1})
