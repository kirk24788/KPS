--[[[
@module Mage
@description
Mage Spells and Environment Functions.
GENERATED FROM WOWHEAD SPELLS - DO NOT EDIT MANUALLY
]]--

kps.spells.mage = {}

kps.spells.mage.invisibility = kps.Spell.fromId(66)
kps.spells.mage.frostbolt = kps.Spell.fromId(116)
kps.spells.mage.polymorph = kps.Spell.fromId(118)
kps.spells.mage.coneOfCold = kps.Spell.fromId(120)
kps.spells.mage.frostNova = kps.Spell.fromId(122)
kps.spells.mage.slowFall = kps.Spell.fromId(130)
kps.spells.mage.fireball = kps.Spell.fromId(133)
kps.spells.mage.arcaneExplosion = kps.Spell.fromId(1449)
kps.spells.mage.incantersFlow = kps.Spell.fromId(1463)
kps.spells.mage.blink = kps.Spell.fromId(1953)
kps.spells.mage.flamestrike = kps.Spell.fromId(2120)
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
kps.spells.mage.pyroblast = kps.Spell.fromId(11366)
kps.spells.mage.portalIronforge = kps.Spell.fromId(11416)
kps.spells.mage.portalOrgrimmar = kps.Spell.fromId(11417)
kps.spells.mage.portalUndercity = kps.Spell.fromId(11418)
kps.spells.mage.portalDarnassus = kps.Spell.fromId(11419)
kps.spells.mage.portalThunderBluff = kps.Spell.fromId(11420)
kps.spells.mage.iceBarrier = kps.Spell.fromId(11426)
kps.spells.mage.coldSnap = kps.Spell.fromId(11958)
kps.spells.mage.arcanePower = kps.Spell.fromId(12042)
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
kps.spells.mage.arcaneBarrage = kps.Spell.fromId(44425)
kps.spells.mage.livingBomb = kps.Spell.fromId(44457)
kps.spells.mage.flurry = kps.Spell.fromId(44614)
kps.spells.mage.iceBlock = kps.Spell.fromId(45438)
kps.spells.mage.teleportStonard = kps.Spell.fromId(49358)
kps.spells.mage.teleportTheramore = kps.Spell.fromId(49359)
kps.spells.mage.portalTheramore = kps.Spell.fromId(49360)
kps.spells.mage.portalStonard = kps.Spell.fromId(49361)
kps.spells.mage.teleportDalaranNorthrend = kps.Spell.fromId(53140)
kps.spells.mage.portalDalaranNorthrend = kps.Spell.fromId(53142)
kps.spells.mage.mirrorImage = kps.Spell.fromId(55342)
kps.spells.mage.splittingIce = kps.Spell.fromId(56377)
kps.spells.mage.glyphOfCrittermorph = kps.Spell.fromId(56382)
kps.spells.mage.masteryIcicles = kps.Spell.fromId(76613)
kps.spells.mage.timeWarp = kps.Spell.fromId(80353)
kps.spells.mage.frozenOrb = kps.Spell.fromId(84714)
kps.spells.mage.cauterize = kps.Spell.fromId(86949)
kps.spells.mage.teleportTolBarad = kps.Spell.fromId(88342)
kps.spells.mage.portalTolBarad = kps.Spell.fromId(88345)
kps.spells.mage.iceFloes = kps.Spell.fromId(108839)
kps.spells.mage.fireBlast = kps.Spell.fromId(108853)
kps.spells.mage.greaterInvisibility = kps.Spell.fromId(110959)
kps.spells.mage.frostBomb = kps.Spell.fromId(112948)
kps.spells.mage.fingersOfFrost = kps.Spell.fromId(112965)
kps.spells.mage.ringOfFrost = kps.Spell.fromId(113724)
kps.spells.mage.netherTempest = kps.Spell.fromId(114923)
kps.spells.mage.runeOfPower = kps.Spell.fromId(116011)
kps.spells.mage.criticalMass = kps.Spell.fromId(117216)
kps.spells.mage.ancientTeleportDalaran = kps.Spell.fromId(120145)
kps.spells.mage.ancientPortalDalaran = kps.Spell.fromId(120146)
kps.spells.mage.illusion = kps.Spell.fromId(131784)
kps.spells.mage.portalValeOfEternalBlossoms = kps.Spell.fromId(132620)
kps.spells.mage.teleportValeOfEternalBlossoms = kps.Spell.fromId(132621)
kps.spells.mage.waterJet = kps.Spell.fromId(135029)
kps.spells.mage.glyphOfEvaporation = kps.Spell.fromId(146662)
kps.spells.mage.glyphOfTheUnboundElemental = kps.Spell.fromId(146976)
kps.spells.mage.meteor = kps.Spell.fromId(153561)
kps.spells.mage.cometStorm = kps.Spell.fromId(153595)
kps.spells.mage.arcaneOrb = kps.Spell.fromId(153626)
kps.spells.mage.overpowered = kps.Spell.fromId(155147)
kps.spells.mage.kindling = kps.Spell.fromId(155148)
kps.spells.mage.thermalVoid = kps.Spell.fromId(155149)
kps.spells.mage.enhancedPyrotechnics = kps.Spell.fromId(157642)
kps.spells.mage.unstableMagic = kps.Spell.fromId(157976)
kps.spells.mage.supernova = kps.Spell.fromId(157980)
kps.spells.mage.blastWave = kps.Spell.fromId(157981)
kps.spells.mage.iceNova = kps.Spell.fromId(157997)
kps.spells.mage.teleportWarspear = kps.Spell.fromId(176242)
kps.spells.mage.portalWarspear = kps.Spell.fromId(176244)
kps.spells.mage.portalStormshield = kps.Spell.fromId(176246)
kps.spells.mage.teleportStormshield = kps.Spell.fromId(176248)
kps.spells.mage.blastingRod = kps.Spell.fromId(187258)
kps.spells.mage.aegwynnsImperative = kps.Spell.fromId(187264)
kps.spells.mage.etherealSensitivity = kps.Spell.fromId(187276)
kps.spells.mage.aegwynnsFury = kps.Spell.fromId(187287)
kps.spells.mage.everywhereAtOnce = kps.Spell.fromId(187301)
kps.spells.mage.torrentialBarrage = kps.Spell.fromId(187304)
kps.spells.mage.cracklingEnergy = kps.Spell.fromId(187310)
kps.spells.mage.arcanePurification = kps.Spell.fromId(187313)
kps.spells.mage.mightOfTheGuardians = kps.Spell.fromId(187318)
kps.spells.mage.aegwynnsWrath = kps.Spell.fromId(187321)
kps.spells.mage.aegwynnsAscendance = kps.Spell.fromId(187680)
kps.spells.mage.arcaneRebound = kps.Spell.fromId(188006)
kps.spells.mage.combustion = kps.Spell.fromId(190319)
kps.spells.mage.conjureRefreshment = kps.Spell.fromId(190336)
kps.spells.mage.blizzard = kps.Spell.fromId(190356)
kps.spells.mage.arcaneCharge = kps.Spell.fromId(190427)
kps.spells.mage.brainFreeze = kps.Spell.fromId(190447)
kps.spells.mage.masterySavant = kps.Spell.fromId(190740)
kps.spells.mage.teleportHallOfTheGuardian = kps.Spell.fromId(193759)
kps.spells.mage.fireAtWill = kps.Spell.fromId(194224)
kps.spells.mage.reignitionOverdrive = kps.Spell.fromId(194234)
kps.spells.mage.pyroclasmicParanoia = kps.Spell.fromId(194239)
kps.spells.mage.burningGaze = kps.Spell.fromId(194312)
kps.spells.mage.greatBallsOfFire = kps.Spell.fromId(194313)
kps.spells.mage.everburningConsumption = kps.Spell.fromId(194314)
kps.spells.mage.moltenSkin = kps.Spell.fromId(194315)
kps.spells.mage.cauterizingBlink = kps.Spell.fromId(194318)
kps.spells.mage.pyreticIncantation = kps.Spell.fromId(194331)
kps.spells.mage.aftershocks = kps.Spell.fromId(194431)
kps.spells.mage.phoenixsFlames = kps.Spell.fromId(194466)
kps.spells.mage.blastFurnace = kps.Spell.fromId(194487)
kps.spells.mage.hotStreak = kps.Spell.fromId(195283)
kps.spells.mage.icyCaress = kps.Spell.fromId(195315)
kps.spells.mage.iceAge = kps.Spell.fromId(195317)
kps.spells.mage.letItGo = kps.Spell.fromId(195322)
kps.spells.mage.orbitalStrike = kps.Spell.fromId(195323)
kps.spells.mage.frozenVeins = kps.Spell.fromId(195345)
kps.spells.mage.clarityOfThought = kps.Spell.fromId(195351)
kps.spells.mage.theStormRages = kps.Spell.fromId(195352)
kps.spells.mage.shieldOfAlodi = kps.Spell.fromId(195354)
kps.spells.mage.chainReaction = kps.Spell.fromId(195419)
kps.spells.mage.chilledToTheCore = kps.Spell.fromId(195448)
kps.spells.mage.blackIce = kps.Spell.fromId(195615)
kps.spells.mage.displacement = kps.Spell.fromId(195676)
kps.spells.mage.quickening = kps.Spell.fromId(198923)
kps.spells.mage.cinderstorm = kps.Spell.fromId(198929)
kps.spells.mage.glacialSpike = kps.Spell.fromId(199786)
kps.spells.mage.pyromaniac = kps.Spell.fromId(205020)
kps.spells.mage.rayOfFrost = kps.Spell.fromId(205021)
kps.spells.mage.arcaneFamiliar = kps.Spell.fromId(205022)
kps.spells.mage.conflagration = kps.Spell.fromId(205023)
kps.spells.mage.lonelyWinter = kps.Spell.fromId(205024)
kps.spells.mage.presenceOfMind = kps.Spell.fromId(205025)
kps.spells.mage.firestarter = kps.Spell.fromId(205026)
kps.spells.mage.boneChilling = kps.Spell.fromId(205027)
kps.spells.mage.resonance = kps.Spell.fromId(205028)
kps.spells.mage.flameOn = kps.Spell.fromId(205029)
kps.spells.mage.frozenTouch = kps.Spell.fromId(205030)
kps.spells.mage.chargedUp = kps.Spell.fromId(205032)
kps.spells.mage.controlledBurn = kps.Spell.fromId(205033)
kps.spells.mage.wordsOfPower = kps.Spell.fromId(205035)
kps.spells.mage.iceWard = kps.Spell.fromId(205036)
kps.spells.mage.flamePatch = kps.Spell.fromId(205037)
kps.spells.mage.arcticGale = kps.Spell.fromId(205038)
kps.spells.mage.erosion = kps.Spell.fromId(205039)
kps.spells.mage.arcaneLinguist = kps.Spell.fromId(210086)
kps.spells.mage.blueFlameSpecial = kps.Spell.fromId(210182)
kps.spells.mage.manaShield = kps.Spell.fromId(210716)
kps.spells.mage.touchOfTheMagi = kps.Spell.fromId(210725)
kps.spells.mage.markOfAluneth = kps.Spell.fromId(210726)
kps.spells.mage.sloooowDown = kps.Spell.fromId(210730)
kps.spells.mage.artificialStamina = kps.Spell.fromId(211309)
kps.spells.mage.shimmer = kps.Spell.fromId(212653)
kps.spells.mage.jouster = kps.Spell.fromId(214626)
kps.spells.mage.shatteringBolts = kps.Spell.fromId(214629)
kps.spells.mage.ebonbolt = kps.Spell.fromId(214634)
kps.spells.mage.iceNine = kps.Spell.fromId(214664)
kps.spells.mage.itsColdOutside = kps.Spell.fromId(214776)
kps.spells.mage.ancientPower = kps.Spell.fromId(214917)
kps.spells.mage.empoweredSpellblade = kps.Spell.fromId(214918)
kps.spells.mage.spellborne = kps.Spell.fromId(214919)
kps.spells.mage.ruleOfThrees = kps.Spell.fromId(215463)
kps.spells.mage.phoenixReborn = kps.Spell.fromId(215773)
kps.spells.mage.bigMouth = kps.Spell.fromId(215796)
kps.spells.mage.glyphOfSparkles = kps.Spell.fromId(219573)
kps.spells.mage.glyphOfSmolder = kps.Spell.fromId(219592)
kps.spells.mage.glyphOfPolymorphicProportions = kps.Spell.fromId(219630)
kps.spells.mage.icyHand = kps.Spell.fromId(220817)
kps.spells.mage.wingsOfFlame = kps.Spell.fromId(221844)
kps.spells.mage.teleportDalaranBrokenIsles = kps.Spell.fromId(224869)
kps.spells.mage.portalDalaranBrokenIsles = kps.Spell.fromId(224871)
kps.spells.mage.scorchedEarth = kps.Spell.fromId(227481)
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

        --TODO: Implement pyroChain sequence
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

