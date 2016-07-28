--[[[
@module Rogue Environment Functions and Variables
@description
Rogue Environment Functions and Variables.
]]--

kps.env.rogue = {}

local rollTheBonesBuffs = {
    -- True Bearing - causes finishing moves to reduce the remaining cooldown of some of your abilities (including Adrenaline Rush) by 2 seconds per Combo Point
    kps.spells.rogue.trueBearing,
    -- Shark Infested Waters increases your Critical Strike chance by 40%;
    kps.spells.rogue.sharkInfestedWaters,
    -- Jolly Roger grants Saber Slash an additional 40% chance to strike an additional time
    kps.spells.rogue.jollyRoger,
    -- Grand Melee increases your attack speed by 40% and your Leech by 20%
    kps.spells.rogue.grandMelee,
    -- Broadsides causes your Combo Point generating abilities to generate 1 additional Combo Point
    kps.spells.rogue.broadsides,
    -- Buried Treasure increases your Energy regeneration by 40%
    kps.spells.rogue.buriedTreasure,
}
function kps.env.rogue.rollTheBonesBuffCount(minCount)
    local buffCount = 0
    for i,buff in pairs(rollTheBonesBuffs) do
        if kps.env.player.hasBuff(buff) then buffCount = buffCount + 1 end
    end
    return buffCount >= minCount
end

local rollTheBonesDecentBuffs = {
    -- True Bearing - causes finishing moves to reduce the remaining cooldown of some of your abilities (including Adrenaline Rush) by 2 seconds per Combo Point
    kps.spells.rogue.trueBearing,
    -- Shark Infested Waters increases your Critical Strike chance by 40%;
    kps.spells.rogue.sharkInfestedWaters,
    -- Jolly Roger grants Saber Slash an additional 40% chance to strike an additional time
    kps.spells.rogue.jollyRoger,
    -- Broadsides causes your Combo Point generating abilities to generate 1 additional Combo Point
    kps.spells.rogue.broadsides,
    -- Buried Treasure increases your Energy regeneration by 40%
    kps.spells.rogue.buriedTreasure,
}
function kps.env.rogue.rollTheBonesDecentBuffCount(minCount)
    local buffCount = 0
    for i,buff in pairs(rollTheBonesDecentBuffs) do
        if kps.env.player.hasBuff(buff) then buffCount = buffCount + 1 end
    end
    return buffCount >= minCount
end
