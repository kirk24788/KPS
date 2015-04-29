--[[[
@module Warlock
@description
Warlock Spells and Environment Functions.
]]--


kps.spells.warlock = {}

kps.spells.warlock.opticalBlast = kps.Spell.fromId(119911)
kps.spells.warlock.spellLock = kps.Spell.fromId(19647)
kps.spells.warlock.mortalCoil = kps.Spell.fromId(6789)
kps.spells.warlock.createHealthstone = kps.Spell.fromId(6201)
kps.spells.warlock.demonicCircleSummon = kps.Spell.fromId(48018)
kps.spells.warlock.demonicCircleTeleport = kps.Spell.fromId(48020)
kps.spells.warlock.demonicGateway = kps.Spell.fromId(113942)
kps.spells.warlock.grimoireOfSacrifice = kps.Spell.fromId(108503)
kps.spells.warlock.grimoireOfSupremacy = kps.Spell.fromId(108499)
kps.spells.warlock.grimoireOfService = kps.Spell.fromId(108501)
kps.spells.warlock.enslaveDemon = kps.Spell.fromId(1098)
kps.spells.warlock.unendingResolve = kps.Spell.fromId(104773)
kps.spells.warlock.commandDemon = kps.Spell.fromId(119898)
kps.spells.warlock.darkIntent = kps.Spell.fromId(109773)
kps.spells.warlock.fear = kps.Spell.fromId(5782)
kps.spells.warlock.banish = kps.Spell.fromId(710)
kps.spells.warlock.soulshatter = kps.Spell.fromId(29858)
kps.spells.warlock.singeMagic = kps.Spell.fromId(132411)
kps.spells.warlock.sacrificialPact = kps.Spell.fromId(108416)
kps.spells.warlock.burningRush = kps.Spell.fromId(111400)
kps.spells.warlock.soulStone = kps.Spell.fromId(20707)
kps.spells.warlock.shadowfury = kps.Spell.fromId(30283)
kps.spells.warlock.cataclysm = kps.Spell.fromId(152108)
-- Affliction
kps.spells.warlock.corruption = kps.Spell.fromId(172)
kps.spells.warlock.darkSoulMisery = kps.Spell.fromId(113860)
kps.spells.warlock.haunt = kps.Spell.fromId(48181)
kps.spells.warlock.seedOfCorruption = kps.Spell.fromId(27243)
kps.spells.warlock.drainSoul = kps.Spell.fromId(103103)
kps.spells.warlock.lifeTap = kps.Spell.fromId(1454)
kps.spells.warlock.soulSwap = kps.Spell.fromId(86121)
kps.spells.warlock.soulburn = kps.Spell.fromId(74434)
kps.spells.warlock.agony = kps.Spell.fromId(980)
kps.spells.warlock.unstableAffliction = kps.Spell.fromId(30108)
-- Destruction
kps.spells.warlock.immolate = kps.Spell.fromId(348)
kps.spells.warlock.backdraft = kps.Spell.fromId(117896)
kps.spells.warlock.rainOfFire = kps.Spell.fromId(5740)
kps.spells.warlock.darkSoulInstability = kps.Spell.fromId(113858)
kps.spells.warlock.havoc = kps.Spell.fromId(80240)
kps.spells.warlock.fireAndBrimstone = kps.Spell.fromId(108683)
kps.spells.warlock.emberTap = kps.Spell.fromId(114635)
kps.spells.warlock.shadowburn = kps.Spell.fromId(17877)
kps.spells.warlock.chaosBolt = kps.Spell.fromId(116858)
kps.spells.warlock.incinerate = kps.Spell.fromId(29722)
kps.spells.warlock.conflagrate = kps.Spell.fromId(17962)
kps.spells.warlock.charredRemains = kps.Spell.fromId(157696)
-- Demonology
kps.spells.warlock.darkSoulKnowledge = kps.Spell.fromId(113861)
kps.spells.warlock.metamorphosis = kps.Spell.fromId(103958)
kps.spells.warlock.handOfGuldan = kps.Spell.fromId(105174)
kps.spells.warlock.shadowflame = kps.Spell.fromId(47960)
kps.spells.warlock.shadowBolt = kps.Spell.fromId(686)
kps.spells.warlock.soulFire = kps.Spell.fromId(6353)
kps.spells.warlock.doom = kps.Spell.fromId(603)
kps.spells.warlock.metaDoom = kps.Spell.fromId(124913)
kps.spells.warlock.touchOfChaos = kps.Spell.fromId(103964)
kps.spells.warlock.chaosWave = kps.Spell.fromId(124916)
kps.spells.warlock.immolationAura = kps.Spell.fromId(104025)
kps.spells.warlock.impSwarm = kps.Spell.fromId(104316)
kps.spells.warlock.hellfire = kps.Spell.fromId(1949)
kps.spells.warlock.demonicLeap = kps.Spell.fromId(109151)
kps.spells.warlock.grimoireFelguard = kps.Spell.fromId(111898)
kps.spells.warlock.harvestLife = kps.Spell.fromId(689)
kps.spells.warlock.moltenCore = kps.Spell.fromId(140074)
kps.spells.warlock.demonBolt = kps.Spell.fromId(157695)



kps.env.warlock = {}

function kps.env.warlock.isHavocUnit(unit)
    if not UnitExists(unit) then  return false end
    if UnitIsUnit("target",unit) then return false end
    return true
end
local burningRushLastMovement = 0
function kps.env.warlock.deactivateBurningRushIfNotMoving(seconds)
    return function ()
        if not seconds then seconds = 0 end
        local player = kps.env.player
        if player.isMoving or not player.hasBuff(kps.spells.warlock.burningRush) then
            burningRushLastMovement = GetTime()
        else
            local nonMovingDuration = GetTime() - burningRushLastMovement
            if nonMovingDuration >= seconds then
                RunMacroText("/cancelaura " .. kps.spells.warlock.burningRush)
            end
        end
    end
end
