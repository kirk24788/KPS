--[[[
@module Druid
@description
Druid Spells and Environment Functions.
]]--

kps.spells.druid = {}

kps.spells.druid.incapacitatingRoar = kps.Spell.fromId(99)
kps.spells.druid.entanglingRoots = kps.Spell.fromId(339)
kps.spells.druid.tranquility = kps.Spell.fromId(740)
kps.spells.druid.catForm = kps.Spell.fromId(768)
kps.spells.druid.faerieFire = kps.Spell.fromId(770)
kps.spells.druid.rejuvenation = kps.Spell.fromId(774)
kps.spells.druid.travelForm = kps.Spell.fromId(783)
kps.spells.druid.rip = kps.Spell.fromId(1079)
kps.spells.druid.markOfTheWild = kps.Spell.fromId(1126)
kps.spells.druid.rake = kps.Spell.fromId(1822)
kps.spells.druid.dash = kps.Spell.fromId(1850)
kps.spells.druid.removeCorruption = kps.Spell.fromId(2782)
kps.spells.druid.soothe = kps.Spell.fromId(2908)
kps.spells.druid.starfire = kps.Spell.fromId(2912)
kps.spells.druid.wrath = kps.Spell.fromId(5176)
kps.spells.druid.healingTouch = kps.Spell.fromId(5185)
kps.spells.druid.mightyBash = kps.Spell.fromId(5211)
kps.spells.druid.prowl = kps.Spell.fromId(5215)
kps.spells.druid.tigersFury = kps.Spell.fromId(5217)
kps.spells.druid.shred = kps.Spell.fromId(5221)
kps.spells.druid.trackHumanoids = kps.Spell.fromId(5225)
kps.spells.druid.bearForm = kps.Spell.fromId(5487)
kps.spells.druid.growl = kps.Spell.fromId(6795)
kps.spells.druid.maul = kps.Spell.fromId(6807)
kps.spells.druid.moonfire = kps.Spell.fromId(8921)
kps.spells.druid.regrowth = kps.Spell.fromId(8936)
kps.spells.druid.omenOfClarity = kps.Spell.fromId(16864)
kps.spells.druid.clearcasting = kps.Spell.fromId(16870)
kps.spells.druid.thickHide = kps.Spell.fromId(16931)
kps.spells.druid.primalFury = kps.Spell.fromId(16961)
kps.spells.druid.predatorySwiftness = kps.Spell.fromId(16974)
kps.spells.druid.leaderOfThePack = kps.Spell.fromId(17007)
kps.spells.druid.naturalHealing = kps.Spell.fromId(17073)
kps.spells.druid.swiftmend = kps.Spell.fromId(18562)
kps.spells.druid.teleportMoonglade = kps.Spell.fromId(18960)
kps.spells.druid.rebirth = kps.Spell.fromId(20484)
kps.spells.druid.ferociousBite = kps.Spell.fromId(22568)
kps.spells.druid.maim = kps.Spell.fromId(22570)
kps.spells.druid.barkskin = kps.Spell.fromId(22812)
kps.spells.druid.frenziedRegeneration = kps.Spell.fromId(22842)
kps.spells.druid.moonkinForm = kps.Spell.fromId(24858)
kps.spells.druid.astralShowers = kps.Spell.fromId(33605)
kps.spells.druid.lacerate = kps.Spell.fromId(33745)
kps.spells.druid.lifebloom = kps.Spell.fromId(33763)
kps.spells.druid.cyclone = kps.Spell.fromId(33786)
kps.spells.druid.forceOfNature = kps.Spell.fromId(33831)
kps.spells.druid.nurturingInstinct = kps.Spell.fromId(33873)
kps.spells.druid.incarnationTreeOfLife = kps.Spell.fromId(33891)
kps.spells.druid.mangle = kps.Spell.fromId(33917)
kps.spells.druid.wildGrowth = kps.Spell.fromId(48438)
kps.spells.druid.infectedWounds = kps.Spell.fromId(48484)
kps.spells.druid.livingSeed = kps.Spell.fromId(48500)
kps.spells.druid.starfall = kps.Spell.fromId(48505)
kps.spells.druid.revive = kps.Spell.fromId(50769)
kps.spells.druid.savageRoar = kps.Spell.fromId(52610)
kps.spells.druid.survivalInstincts = kps.Spell.fromId(61336)
kps.spells.druid.savageDefense = kps.Spell.fromId(62606)
kps.spells.druid.masteryTotalEclipse = kps.Spell.fromId(77492)
kps.spells.druid.masteryRazorClaws = kps.Spell.fromId(77493)
kps.spells.druid.masteryHarmony = kps.Spell.fromId(77495)
kps.spells.druid.thrash = kps.Spell.fromId(77758)
kps.spells.druid.starsurge = kps.Spell.fromId(78674)
kps.spells.druid.solarBeam = kps.Spell.fromId(78675)
kps.spells.druid.pulverize = kps.Spell.fromId(80313)
kps.spells.druid.meditation = kps.Spell.fromId(85101)
kps.spells.druid.leatherSpecialization = kps.Spell.fromId(86093)
kps.spells.druid.naturesCure = kps.Spell.fromId(88423)
kps.spells.druid.wildMushroom = kps.Spell.fromId(88747)
kps.spells.druid.malfurionsGift = kps.Spell.fromId(92364)
kps.spells.druid.shootingStars = kps.Spell.fromId(93399)
kps.spells.druid.displacerBeast = kps.Spell.fromId(102280)
kps.spells.druid.ironbark = kps.Spell.fromId(102342)
kps.spells.druid.cenarionWard = kps.Spell.fromId(102351)
kps.spells.druid.massEntanglement = kps.Spell.fromId(102359)
kps.spells.druid.wildCharge = kps.Spell.fromId(102401)
kps.spells.druid.incarnationKingOfTheJungle = kps.Spell.fromId(102543)
kps.spells.druid.incarnationSonOfUrsoc = kps.Spell.fromId(102558)
kps.spells.druid.incarnationChosenOfElune = kps.Spell.fromId(102560)
kps.spells.druid.ursolsVortex = kps.Spell.fromId(102793)
kps.spells.druid.faerieSwarm = kps.Spell.fromId(106707)
kps.spells.druid.swipe = kps.Spell.fromId(106785)
kps.spells.druid.skullBash = kps.Spell.fromId(106839)
kps.spells.druid.stampedingRoar = kps.Spell.fromId(106898)
kps.spells.druid.berserk = kps.Spell.fromId(106952)
kps.spells.druid.renewal = kps.Spell.fromId(108238)
kps.spells.druid.heartOfTheWild = kps.Spell.fromId(108291)
kps.spells.druid.killerInstinct = kps.Spell.fromId(108299)
kps.spells.druid.dreamOfCenarius = kps.Spell.fromId(108373)
kps.spells.druid.celestialAlignment = kps.Spell.fromId(112071)
kps.spells.druid.naturalInsight = kps.Spell.fromId(112857)
kps.spells.druid.soulOfTheForest = kps.Spell.fromId(114107)
kps.spells.druid.naturesVigil = kps.Spell.fromId(124974)
kps.spells.druid.felineGrace = kps.Spell.fromId(125972)
kps.spells.druid.astralCommunion = kps.Spell.fromId(127663)
kps.spells.druid.felineSwiftness = kps.Spell.fromId(131768)
kps.spells.druid.naturesSwiftness = kps.Spell.fromId(132158)
kps.spells.druid.typhoon = kps.Spell.fromId(132469)
kps.spells.druid.toothAndClaw = kps.Spell.fromId(135288)
kps.spells.druid.yserasGift = kps.Spell.fromId(145108)
kps.spells.druid.genesis = kps.Spell.fromId(145518)
kps.spells.druid.balanceOfPower = kps.Spell.fromId(152220)
kps.spells.druid.stellarFlare = kps.Spell.fromId(152221)
kps.spells.druid.euphoria = kps.Spell.fromId(152222)
kps.spells.druid.momentOfClarity = kps.Spell.fromId(155577)
kps.spells.druid.guardianOfElune = kps.Spell.fromId(155578)
kps.spells.druid.lunarInspiration = kps.Spell.fromId(155580)
kps.spells.druid.bloodtalons = kps.Spell.fromId(155672)
kps.spells.druid.germination = kps.Spell.fromId(155675)
kps.spells.druid.masteryPrimalTenacity = kps.Spell.fromId(155783)
kps.spells.druid.rampantGrowth = kps.Spell.fromId(155834)
kps.spells.druid.bristlingFur = kps.Spell.fromId(155835)
kps.spells.druid.resolve = kps.Spell.fromId(158298)
kps.spells.druid.ursaMajor = kps.Spell.fromId(159232)
kps.spells.druid.bladedArmor = kps.Spell.fromId(161608)
kps.spells.druid.sunfire = kps.Spell.fromId(164815)
kps.spells.druid.sharpenedClaws = kps.Spell.fromId(165372)
kps.spells.druid.naturalist = kps.Spell.fromId(165374)
kps.spells.druid.lunarGuidance = kps.Spell.fromId(165386)
kps.spells.druid.survivalOfTheFittest = kps.Spell.fromId(165387)
kps.spells.druid.flightForm = kps.Spell.fromId(165962)
kps.spells.druid.balance = kps.Spell.fromId(166163)
kps.spells.druid.clawsOfShirvallah = kps.Spell.fromId(171746)
kps.spells.druid.naturesBounty = kps.Spell.fromId(179333)
kps.spells.druid.solarEmpowerment = kps.Spell.fromId(164545)
kps.spells.druid.lunarEmpowerment = kps.Spell.fromId(164547)
kps.spells.druid.lunarPeak = kps.Spell.fromId(171743)
kps.spells.druid.solarPeak = kps.Spell.fromId(171744)
kps.spells.druid.incarnation = kps.Spell.fromId(117679)
kps.spells.druid.shadowmeld = kps.Spell.fromId(135201)

