--[[[
@module Mage
@description
Mage Spells and Environment Functions.
GENERATED FROM WOWHEAD SPELLS - DO NOT EDIT MANUALLY
]]--

kps.spells.mage = {}

kps.spells.mage.blizzard = kps.Spell.fromId(10)
kps.spells.mage.invisibility = kps.Spell.fromId(66)
kps.spells.mage.frostbolt = kps.Spell.fromId(116)
kps.spells.mage.polymorph = kps.Spell.fromId(118)
kps.spells.mage.coneOfCold = kps.Spell.fromId(120)
kps.spells.mage.frostNova = kps.Spell.fromId(122)
kps.spells.mage.slowFall = kps.Spell.fromId(130)
kps.spells.mage.fireball = kps.Spell.fromId(133)
kps.spells.mage.removeCurse = kps.Spell.fromId(475)
kps.spells.mage.arcaneExplosion = kps.Spell.fromId(1449)
kps.spells.mage.arcaneBrilliance = kps.Spell.fromId(1459)
kps.spells.mage.incantersFlow = kps.Spell.fromId(1463)
kps.spells.mage.blink = kps.Spell.fromId(1953)
kps.spells.mage.flamestrike = kps.Spell.fromId(2120)
kps.spells.mage.fireBlast = kps.Spell.fromId(2136)
kps.spells.mage.counterspell = kps.Spell.fromId(2139)
kps.spells.mage.scorch = kps.Spell.fromId(2948)
kps.spells.mage.teleportStormwind = kps.Spell.fromId(3561)
kps.spells.mage.teleportIronforge = kps.Spell.fromId(3562)
kps.spells.mage.teleportUndercity = kps.Spell.fromId(3563)
kps.spells.mage.teleportDarnassus = kps.Spell.fromId(3565)
kps.spells.mage.teleportThunderBluff = kps.Spell.fromId(3566)
kps.spells.mage.teleportOrgrimmar = kps.Spell.fromId(3567)
kps.spells.mage.arcaneMissiles = kps.Spell.fromId(5143)
kps.spells.mage.mageArmor = kps.Spell.fromId(6117)
kps.spells.mage.frostArmor = kps.Spell.fromId(7302)
kps.spells.mage.portalStormwind = kps.Spell.fromId(10059)
kps.spells.mage.combustion = kps.Spell.fromId(11129)
kps.spells.mage.pyroblast = kps.Spell.fromId(11366)
kps.spells.mage.portalIronforge = kps.Spell.fromId(11416)
kps.spells.mage.portalOrgrimmar = kps.Spell.fromId(11417)
kps.spells.mage.portalUndercity = kps.Spell.fromId(11418)
kps.spells.mage.portalDarnassus = kps.Spell.fromId(11419)
kps.spells.mage.portalThunderBluff = kps.Spell.fromId(11420)
kps.spells.mage.iceBarrier = kps.Spell.fromId(11426)
kps.spells.mage.coldSnap = kps.Spell.fromId(11958)
kps.spells.mage.arcanePower = kps.Spell.fromId(12042)
kps.spells.mage.presenceOfMind = kps.Spell.fromId(12043)
kps.spells.mage.evocation = kps.Spell.fromId(12051)
kps.spells.mage.icyVeins = kps.Spell.fromId(12472)
kps.spells.mage.masteryIgnite = kps.Spell.fromId(12846)
kps.spells.mage.shatter = kps.Spell.fromId(12982)
kps.spells.mage.spellsteal = kps.Spell.fromId(30449)
kps.spells.mage.arcaneBlast = kps.Spell.fromId(30451)
kps.spells.mage.iceLance = kps.Spell.fromId(30455)
kps.spells.mage.moltenArmor = kps.Spell.fromId(30482)
kps.spells.mage.slow = kps.Spell.fromId(31589)
kps.spells.mage.dragonsBreath = kps.Spell.fromId(31661)
kps.spells.mage.summonWaterElemental = kps.Spell.fromId(31687)
kps.spells.mage.portalExodar = kps.Spell.fromId(32266)
kps.spells.mage.portalSilvermoon = kps.Spell.fromId(32267)
kps.spells.mage.teleportExodar = kps.Spell.fromId(32271)
kps.spells.mage.teleportSilvermoon = kps.Spell.fromId(32272)
kps.spells.mage.teleportShattrath = kps.Spell.fromId(33690)
kps.spells.mage.portalShattrath = kps.Spell.fromId(33691)
kps.spells.mage.conjureRefreshment = kps.Spell.fromId(42955)
kps.spells.mage.conjureRefreshmentTable = kps.Spell.fromId(43987)
kps.spells.mage.arcaneBarrage = kps.Spell.fromId(44425)
kps.spells.mage.livingBomb = kps.Spell.fromId(44457)
kps.spells.mage.brainFreeze = kps.Spell.fromId(44549)
kps.spells.mage.deepFreeze = kps.Spell.fromId(44572)
kps.spells.mage.frostfireBolt = kps.Spell.fromId(44614)
kps.spells.mage.iceBlock = kps.Spell.fromId(45438)
kps.spells.mage.teleportStonard = kps.Spell.fromId(49358)
kps.spells.mage.teleportTheramore = kps.Spell.fromId(49359)
kps.spells.mage.portalTheramore = kps.Spell.fromId(49360)
kps.spells.mage.portalStonard = kps.Spell.fromId(49361)
kps.spells.mage.teleportDalaran = kps.Spell.fromId(53140)
kps.spells.mage.portalDalaran = kps.Spell.fromId(53142)
kps.spells.mage.mirrorImage = kps.Spell.fromId(55342)
kps.spells.mage.glyphOfIcyVeins = kps.Spell.fromId(56364)
kps.spells.mage.glyphOfBlink = kps.Spell.fromId(56365)
kps.spells.mage.glyphOfCombustion = kps.Spell.fromId(56368)
kps.spells.mage.glyphOfPolymorph = kps.Spell.fromId(56375)
kps.spells.mage.glyphOfFrostNova = kps.Spell.fromId(56376)
kps.spells.mage.glyphOfSplittingIce = kps.Spell.fromId(56377)
kps.spells.mage.glyphOfCrittermorph = kps.Spell.fromId(56382)
kps.spells.mage.glyphOfMomentum = kps.Spell.fromId(56384)
kps.spells.mage.glyphOfArcaneLanguage = kps.Spell.fromId(57925)
kps.spells.mage.glyphOfIgnite = kps.Spell.fromId(61205)
kps.spells.mage.dalaranBrilliance = kps.Spell.fromId(61316)
kps.spells.mage.glyphOfArcanePower = kps.Spell.fromId(62210)
kps.spells.mage.glyphOfWaterElemental = kps.Spell.fromId(63090)
kps.spells.mage.glyphOfIllusion = kps.Spell.fromId(63092)
kps.spells.mage.masteryManaAdept = kps.Spell.fromId(76547)
kps.spells.mage.masteryIcicles = kps.Spell.fromId(76613)
kps.spells.mage.timeWarp = kps.Spell.fromId(80353)
kps.spells.mage.frozenOrb = kps.Spell.fromId(84714)
kps.spells.mage.glyphOfSlow = kps.Spell.fromId(86209)
kps.spells.mage.cauterize = kps.Spell.fromId(86949)
kps.spells.mage.teleportTolBarad = kps.Spell.fromId(88342)
kps.spells.mage.portalTolBarad = kps.Spell.fromId(88345)
kps.spells.mage.glyphOfRapidTeleportation = kps.Spell.fromId(89749)
kps.spells.mage.glyphOfInfernoBlast = kps.Spell.fromId(89926)
kps.spells.mage.frostjaw = kps.Spell.fromId(102051)
kps.spells.mage.iceFloes = kps.Spell.fromId(108839)
kps.spells.mage.blazingSpeed = kps.Spell.fromId(108843)
kps.spells.mage.infernoBlast = kps.Spell.fromId(108853)
kps.spells.mage.alterTime = kps.Spell.fromId(108978)
kps.spells.mage.greaterInvisibility = kps.Spell.fromId(110959)
kps.spells.mage.iceWard = kps.Spell.fromId(111264)
kps.spells.mage.frostBomb = kps.Spell.fromId(112948)
kps.spells.mage.fingersOfFrost = kps.Spell.fromId(112965)
kps.spells.mage.ringOfFrost = kps.Spell.fromId(113724)
kps.spells.mage.arcaneCharge = kps.Spell.fromId(114664)
kps.spells.mage.netherTempest = kps.Spell.fromId(114923)
kps.spells.mage.glyphOfRemoveCurse = kps.Spell.fromId(115700)
kps.spells.mage.glyphOfCounterspell = kps.Spell.fromId(115703)
kps.spells.mage.glyphOfConeOfCold = kps.Spell.fromId(115705)
kps.spells.mage.glyphOfDeepFreeze = kps.Spell.fromId(115710)
kps.spells.mage.glyphOfSpellsteal = kps.Spell.fromId(115713)
kps.spells.mage.glyphOfArcaneExplosion = kps.Spell.fromId(115718)
kps.spells.mage.glyphOfIceBlock = kps.Spell.fromId(115723)
kps.spells.mage.runeOfPower = kps.Spell.fromId(116011)
kps.spells.mage.criticalMass = kps.Spell.fromId(117216)
kps.spells.mage.ancientTeleportDalaran = kps.Spell.fromId(120145)
kps.spells.mage.ancientPortalDalaran = kps.Spell.fromId(120146)
kps.spells.mage.glyphOfConjureFamiliar = kps.Spell.fromId(126748)
kps.spells.mage.portalValeOfEternalBlossoms = kps.Spell.fromId(132620)
kps.spells.mage.teleportValeOfEternalBlossoms = kps.Spell.fromId(132621)
kps.spells.mage.flameglow = kps.Spell.fromId(140468)
kps.spells.mage.glyphOfRapidDisplacement = kps.Spell.fromId(146659)
kps.spells.mage.glyphOfEvaporation = kps.Spell.fromId(146662)
kps.spells.mage.glyphOfTheUnboundElemental = kps.Spell.fromId(146976)
kps.spells.mage.glyphOfCondensation = kps.Spell.fromId(147353)
kps.spells.mage.prismaticCrystal = kps.Spell.fromId(152087)
kps.spells.mage.meteor = kps.Spell.fromId(153561)
kps.spells.mage.cometStorm = kps.Spell.fromId(153595)
kps.spells.mage.arcaneOrb = kps.Spell.fromId(153626)
kps.spells.mage.overpowered = kps.Spell.fromId(155147)
kps.spells.mage.kindling = kps.Spell.fromId(155148)
kps.spells.mage.thermalVoid = kps.Spell.fromId(155149)
kps.spells.mage.evanesce = kps.Spell.fromId(157913)
kps.spells.mage.unstableMagic = kps.Spell.fromId(157976)
kps.spells.mage.supernova = kps.Spell.fromId(157980)
kps.spells.mage.blastWave = kps.Spell.fromId(157981)
kps.spells.mage.iceNova = kps.Spell.fromId(157997)
kps.spells.mage.glyphOfDragonsBreath = kps.Spell.fromId(159485)
kps.spells.mage.glyphOfRegenerativeIce = kps.Spell.fromId(159486)
kps.spells.mage.incineration = kps.Spell.fromId(165357)
kps.spells.mage.arcaneMind = kps.Spell.fromId(165359)
kps.spells.mage.iceShards = kps.Spell.fromId(165360)
kps.spells.mage.teleportWarspear = kps.Spell.fromId(176242)
kps.spells.mage.portalWarspear = kps.Spell.fromId(176244)
kps.spells.mage.portalStormshield = kps.Spell.fromId(176246)
kps.spells.mage.teleportStormshield = kps.Spell.fromId(176248)
kps.spells.mage.arcaneInstability = kps.Spell.fromId(166872)
kps.spells.mage.potentFlames = kps.Spell.fromId(145254)
kps.spells.mage.heatingUp = kps.Spell.fromId(48107)
kps.spells.mage.pyromaniac = kps.Spell.fromId(166868)
kps.spells.mage.ignite = kps.Spell.fromId(101166)
kps.spells.mage.waterJet = kps.Spell.fromId(135029)


kps.env.mage = {}

local burnPhase = false
function kps.env.mage.burnPhase()
    if not burnPhase then
        -- At the start of the fight and whenever Evocation Icon Evocation is about to come off cooldown, you need to start the Burn Phase
        -- and burn your Mana. Before doing so, make sure that you have 3 charges of Arcane Missiles and 4 stacks of Arcane Charge.
        burnPhase = kps.env.player.timeInCombat < 5 or kps.spells.mage.evocation.cooldown < 2
    else
        burnPhase = kps.env.player.mana > 0.35
    end
    return burnPhase
end

local incantersFlowDirection = 0
local incantersFlowLastStacks = 0
function kps.env.mage.incantersFlowDirection()
    local stack = select(4, UnitBuff("player", GetSpellInfo(116267)))
    if stack < incantersFlowLastStacks then
        incantersFlowDirection = -1
        incantersFlowLastStacks = stack
    elseif stack > incantersFlowLastStacks then
        incantersFlowDirection = 1
        incantersFlowLastStacks = stack
    end
    return encantersFlowDirection
end

local pyroChain = false
local pyroChainEnd = 0
function kps.env.mage.pyroChain()
    if not pyroChain then
        -- Combustion sequence initialization
        -- This sequence lists the requirements for preparing a Combustion combo with each talent choice
        -- Meteor Combustion:
        --    actions.init_combust=start_pyro_chain,if=talent.meteor.enabled&cooldown.meteor.up&((cooldown.combustion.remains<gcd.max*3&buff.pyroblast.up&(buff.heating_up.up^action.fireball.in_flight))|(buff.pyromaniac.up&(cooldown.combustion.remains<ceil(buff.pyromaniac.remains%gcd.max)*gcd.max)))
        -- Prismatic Crystal Combustion without 2T17:
        --    actions.init_combust+=/start_pyro_chain,if=talent.prismatic_crystal.enabled&!set_bonus.tier17_2pc&cooldown.prismatic_crystal.up&((cooldown.combustion.remains<gcd.max*2&buff.pyroblast.up&(buff.heating_up.up^action.fireball.in_flight))|(buff.pyromaniac.up&(cooldown.combustion.remains<ceil(buff.pyromaniac.remains%gcd.max)*gcd.max)))
        -- Prismatic Crystal Combustion with 2T17:
        --    actions.init_combust+=/start_pyro_chain,if=talent.prismatic_crystal.enabled&set_bonus.tier17_2pc&cooldown.prismatic_crystal.up&cooldown.combustion.remains<gcd.max*2&buff.pyroblast.up&(buff.heating_up.up^action.fireball.in_flight)
        -- Unglyphed Combustions between Prismatic Crystals:
        --    actions.init_combust+=/start_pyro_chain,if=talent.prismatic_crystal.enabled&!glyph.combustion.enabled&cooldown.prismatic_crystal.remains>20&((cooldown.combustion.remains<gcd.max*2&buff.pyroblast.up&buff.heating_up.up&action.fireball.in_flight)|(buff.pyromaniac.up&(cooldown.combustion.remains<ceil(buff.pyromaniac.remains%gcd.max)*gcd.max)))
        -- Kindling or Level 90 Combustion:
        --    actions.init_combust+=/start_pyro_chain,if=!talent.prismatic_crystal.enabled&!talent.meteor.enabled&((cooldown.combustion.remains<gcd.max*4&buff.pyroblast.up&buff.heating_up.up&action.fireball.in_flight)|(buff.pyromaniac.up&cooldown.combustion.remains<ceil(buff.pyromaniac.remains%gcd.max)*(gcd.max+talent.kindling.enabled)))

        --TODO!!!
        -- pyroChainStart = GetTime()
        return false
    else
        -- actions=stop_pyro_chain,if=prev_off_gcd.combustion
        pyroChain = kps.env.player.mana > 0.35
    end
    return pyroChain
end
function kps.env.mage.pyroChainDuration()
    local duration = pyroChainEnd - GetTime()
    if duration < 0 then return 0 else return duration end
end

