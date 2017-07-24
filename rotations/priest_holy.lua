--[[[
@module Priest Holy Rotation
@author htordeux
@version 7.2
]]--

local spells = kps.spells.priest
local env = kps.env.priest
local HolyWordSanctify = tostring(spells.holyWordSanctify)
local SpiritOfRedemption = tostring(spells.spiritOfRedemption)
local MassDispel = tostring(spells.massDispel)

kps.rotations.register("PRIEST","HOLY",{

    {{"macro"}, 'not target.exists and mouseover.inCombat and mouseover.isAttackable' , "/target mouseover" },
    env.ShouldInterruptCasting,
    env.ScreenMessage,

    {{"macro"}, 'player.hasBuff(spells.spiritOfRedemption) and heal.lowestInRaid.isUnit("player")' , "/cancelaura "..SpiritOfRedemption },
    {{"nested"}, 'player.hasBuff(spells.spiritOfRedemption)' ,{
        {spells.guardianSpirit, 'heal.lowestInRaid.hp < 0.30' , kps.heal.lowestInRaid},
        {spells.holyWordSerenity, 'heal.lowestInRaid.hp < 0.60' , kps.heal.lowestInRaid},
        {spells.prayerOfMending, 'true' , kps.heal.lowestInRaid},
        {spells.prayerOfHealing, 'heal.countInRange > 3 and not player.isInRaid' , kps.heal.lowestInRaid},
        {spells.prayerOfHealing, 'heal.countInRange > 5 and player.isInRaid' , kps.heal.lowestInRaid},
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid},
        {spells.renew, 'heal.lowestInRaid.myBuffDuration(spells.renew) < 3' , kps.heal.lowestInRaid},
    }},
    
    -- "Dispel" "Purifier" 527
    {{"nested"},'kps.cooldowns', {
        {spells.purify, 'heal.isMagicDispellable ~= nil' , kps.heal.isMagicDispellable , "DISPEL" },
        {spells.purify, 'mouseover.isDispellable("Magic")' , "mouseover" },
        {spells.purify, 'player.isDispellable("Magic")' , "player" },
        {spells.purify, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid},
    }},
    
    -- "Fade" 586 "Disparition"
    {spells.fade, 'player.isTarget' },
    -- "Prière du désespoir" 19236 "Desperate Prayer"
    {spells.desperatePrayer, 'player.hp < 0.70' , "player" },
    -- Body and Mind
    {spells.bodyAndMind, 'player.isMoving and not player.hasBuff(spells.bodyAndMind)' , "player"},
    -- "Don des naaru" 59544
    {spells.giftOfTheNaaru, 'player.hp < 0.70' , "player" },
    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp < 0.80' ,"/use item:5512" },
    -- "Renew" 139
    {spells.renew, 'player.myBuffDuration(spells.renew) < 3 and player.hpIncoming < 0.95' , "player"},
    -- "Light of T'uure" 208065 -- track buff in case an other priest have casted lightOfTuure
    {spells.lightOfTuure, 'player.hp < 0.60 and not player.hasBuff(spells.lightOfTuure)' , "player"},
    -- "Soins de lien" 32546
    {spells.bindingHeal, 'not player.isMoving and heal.lowestInRaid.hp < 0.70 and player.hp < 0.70 and not heal.lowestInRaid.isUnit("player")' , kps.heal.lowestInRaid},

    -- "Holy Word: Sanctify" and "Holy Word: Serenity" gives buff  "Divinity" 197030 When you heal with a Holy Word spell, your healing is increased by 15% for 8 sec.
    {{"macro"}, 'keys.shift', "/cast [@cursor] "..HolyWordSanctify },
    -- "Dissipation de masse" 32375
    {{"macro"}, 'keys.ctrl', "/cast [@cursor] "..MassDispel },

    -- "Guardian Spirit" 47788  -- track buff in case an other priest have casted guardianSpirit
    {spells.guardianSpirit, 'player.hp < 0.30 and not heal.lowestInRaid.isUnit("player")' , kps.heal.lowestInRaid},
    {spells.guardianSpirit, 'player.hp < 0.30 and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestTankInRaid},
    {{"nested"}, 'kps.interrupt' ,{
        {spells.guardianSpirit, 'heal.lowestTankInRaid.hp < 0.30 and not heal.lowestTankInRaid.hasBuff(spells.guardianSpirit)' , kps.heal.lowestTankInRaid},
        {spells.guardianSpirit, 'heal.lowestTargetInRaid.hp < 0.30 and not heal.lowestTargetInRaid.hasBuff(spells.guardianSpirit)' , kps.heal.lowestTargetInRaid},
        {spells.guardianSpirit, 'heal.lowestInRaid.hp < 0.30 and not heal.lowestInRaid.hasBuff(spells.guardianSpirit)' , kps.heal.lowestInRaid},
     }},

    -- Prayer of Mending (Tank only)
    {spells.prayerOfMending, 'not player.isMoving and heal.lowestInRaid.hp > 0.60 and not heal.lowestTankInRaid.hasBuff(spells.prayerOfMending)' , kps.heal.lowestTankInRaid},
    {spells.prayerOfMending, 'not player.isMoving and heal.lowestInRaid.hp > 0.60 and not heal.lowestTargetInRaid.hasBuff(spells.prayerOfMending)' , kps.heal.lowestTargetInRaid},
    {spells.prayerOfMending, 'not player.isMoving and heal.lowestInRaid.hp > 0.60 and not heal.lowestInRaid.hasBuff(spells.prayerOfMending)' , kps.heal.lowestInRaid},
    -- TRINKETS
    {{"macro"}, 'player.useTrinket(1) and heal.countInRange > 2 and not player.isInRaid' , "/use 14"},
    {{"macro"}, 'player.useTrinket(1) and heal.countInRange > 4 and player.isInRaid' , "/use 14"},
    -- "Apotheosis" 200183 increasing the effects of Serendipity by 200% and reducing the cost of your Holy Words by 100% -- "Benediction" for raid and "Apotheosis" for party
    {spells.apotheosis, 'player.hasTalent(7,1) and heal.lowestInRaid.hp < 0.60 and heal.countInRange > 2 and not player.isInRaid' },
    {spells.apotheosis, 'player.hasTalent(7,1) and heal.lowestInRaid.hp < 0.60 and heal.countInRange > 4 and player.isInRaid' },
    
    -- "Surge Of Light"
    {{"nested"}, 'player.hasBuff(spells.surgeOfLight)' , {
        {spells.flashHeal, 'player.hp < 0.80' , "player"},
        {spells.flashHeal, 'heal.lowestTankInRaid.hp < 0.80' , kps.heal.lowestTankInRaid},
        {spells.flashHeal, 'heal.lowestTargetInRaid.hp < 0.80' , kps.heal.lowestTargetInRaid},
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid},
        {spells.flashHeal, 'player.myBuffDuration(spells.surgeOfLight) < 3' , kps.heal.lowestInRaid},
    }},
    
    -- "Holy Word: Serenity"
    {spells.holyWordSerenity, 'player.hp < 0.50' , "player"},
    {spells.holyWordSerenity, 'heal.lowestTankInRaid.hp < 0.50' , kps.heal.lowestTankInRaid},
    {spells.holyWordSerenity, 'heal.lowestTargetInRaid.hp < 0.50' , kps.heal.lowestTargetInRaid},
    {spells.holyWordSerenity, 'heal.lowestInRaid.hp < 0.50' , kps.heal.lowestInRaid},
    
    -- "Light of T'uure" 208065 -- track buff in case an other priest have casted lightOfTuure
    {{spells.lightOfTuure,spells.flashHeal}, 'not player.isMoving and spells.lightOfTuure.cooldown == 0 and heal.lowestTankInRaid.hpIncoming < 0.70 and not heal.lowestTankInRaid.hasBuff(spells.lightOfTuure)' , kps.heal.lowestTankInRaid},
    {{spells.lightOfTuure,spells.flashHeal}, 'not player.isMoving and spells.lightOfTuure.cooldown == 0 and heal.lowestTargetInRaid.hpIncoming < 0.70 and not heal.lowestTargetInRaid.hasBuff(spells.lightOfTuure)' ,kps.heal.lowestTargetInRaid},
    {{spells.lightOfTuure,spells.flashHeal}, 'not player.isMoving and spells.lightOfTuure.cooldown == 0 and heal.lowestInRaid.hpIncoming < 0.70 and not heal.lowestInRaid.hasBuff(spells.lightOfTuure)' , kps.heal.lowestInRaid},

    {{"nested"}, 'kps.defensive and mouseover.isHealable' , {
        {spells.guardianSpirit, 'mouseover.hp < 0.30' , "mouseover" },
        {spells.holyWordSerenity, 'mouseover.hp < 0.40' , "mouseover" },
        {spells.prayerOfHealing, 'not player.isMoving and heal.countInRange > 2 and not player.isInRaid' , "mouseover" },
        {spells.prayerOfHealing, 'not player.isMoving and heal.countInRange > 4 and player.isInRaid' , "mouseover" }, 
        {spells.lightOfTuure, 'mouseover.hp < 0.70' , "mouseover" },
        {spells.flashHeal, 'not player.isMoving and mouseover.hp < 0.70' , "mouseover" },
        {spells.renew, 'mouseover.myBuffDuration(spells.renew) < 3 and mouseover.hpIncoming < 0.90' , "mouseover" },
        {spells.heal, 'not player.isMoving and mouseover.hp < 0.90' , "mouseover" },
    }},
    
    {{"nested"}, 'kps.multiTarget and target.isAttackable and heal.lowestInRaid.hp > target.hp and heal.lowestInRaid.hp > 0.70' , {
        {spells.holyWordChastise, 'target.isAttackable' , "target" },
        {spells.holyFire, 'target.isAttackable' , "target" },
        {spells.holyNova, 'player.isMoving and target.distance < 10 and target.isAttackable' , "target" },
        {spells.holyNova, 'player.isMoving and targettarget.distance < 10 and targettarget.isAttackable' , "targettarget" },
        {spells.smite, 'not player.isMoving and target.isAttackable', "target" },
        {spells.smite, 'not player.isMoving and targettarget.isAttackable', "targettarget" },
        {spells.smite, 'not player.isMoving and focustarget.isAttackable and not player.isInRaid', "focustarget" },
    }},

    -- "Soins rapides" 2060
    {spells.flashHeal, 'not player.isMoving and player.hp < 0.60 and not spells.flashHeal.isRecastAt("player")' , "player"},
    {spells.flashHeal, 'not player.isMoving and player.hp < 0.40 and heal.lowestInRaid.isUnit("player")' , "player"},
    {spells.flashHeal, 'not player.isMoving and kps.lastCast["name"] == spells.prayerOfHealing and heal.lowestTankInRaid.hp < 0.60' , kps.heal.lowestTankInRaid },
    {spells.flashHeal, 'not player.isMoving and kps.lastCast["name"] == spells.prayerOfHealing and heal.lowestInRaid.hp < 0.60' , kps.heal.lowestInRaid},
    {spells.flashHeal, 'not player.isMoving and kps.lastCast["id"] == 596 and heal.lowestTankInRaid.hp < 0.60' , kps.heal.lowestTankInRaid },
    {spells.flashHeal, 'not player.isMoving and kps.lastCast["id"] == 596 and heal.lowestInRaid.hp < 0.60' , kps.heal.lowestInRaid},
    {spells.flashHeal, 'not player.isMoving and heal.countInRange < 4 and heal.lowestInRaid.hp < 0.50 and heal.lowestTargetInRaid.hp > heal.lowestInRaid.hp' , kps.heal.lowestInRaid , "FLASH_LOWEST" },
    {spells.flashHeal, 'not player.isMoving and heal.countInRange < 4 and heal.lowestTargetInRaid.hp < 0.50' , kps.heal.lowestTargetInRaid , "FLASH_LOWEST_TARGET" },

    -- "Divine Hymn" 64843    
    {spells.holyWordSerenity, 'heal.countInRange > 2 and not player.hasBuff(spells.divinity) and not player.isInRaid' , kps.heal.lowestInRaid , "SERENITY_COUNT" },
    {spells.holyWordSerenity, 'heal.countInRange > 4 and not player.hasBuff(spells.divinity) and player.isInRaid' , kps.heal.lowestInRaid , "SERENITY_COUNT" },
    {spells.prayerOfMending, 'not player.isMoving and heal.hasRaidBuff(spells.prayerOfMending) == nil' , kps.heal.lowestTankInRaid, "POM_COUNT" },
    {spells.divineHymn , 'not player.isMoving and heal.countLossInRange(0.60) * 2 >= heal.maxcountInRange and heal.hasRaidBuff(spells.prayerOfMending) ~= nil' },
 
    -- "Prayer of Healing" 596 -- A powerful prayer that heals the target and the 4 nearest allies within 40 yards for (250% of Spell power)
    -- "Holy Word: Sanctify" gives buff  "Divinity" 197030 When you heal with a Holy Word spell, your healing is increased by 15% for 6 sec
    -- "Mot sacré : Sanctification" augmente les soins de Prière de soins de 6% pendant 15 sec. Buff "Puissance des naaru" 196490
    {spells.prayerOfHealing, 'not player.isMoving and player.hasBuff(spells.powerOfTheNaaru) and heal.countLossInRange(0.70) > 2 and not player.isInRaid' , kps.heal.lowestInRaid , "POH_COUNT" },
    {spells.holyWordSanctify, 'not player.isMoving and heal.countLossInRange(0.70) > 2 and not player.isInRaid' },
    {spells.prayerOfHealing, 'not player.isMoving and player.hasBuff(spells.powerOfTheNaaru) and heal.countLossInRange(0.70) > 4 and player.isInRaid' , kps.heal.lowestInRaid , "POH_COUNT" },
    {spells.holyWordSanctify, 'not player.isMoving and heal.countLossInRange(0.70) > 4 and player.isInRaid' },

    {{"nested"}, 'not player.isMoving and heal.countInRange > 4 and player.isInRaid' ,{
        {spells.prayerOfHealing, 'player.hasBuff(spells.divinity)' , kps.heal.lowestTankInRaid , "POH_BUFF" },
        {spells.prayerOfHealing, 'player.hasBuff(spells.powerOfTheNaaru)' , kps.heal.lowestTankInRaid , "POH_BUFF" },
        {spells.prayerOfHealing, 'player.hp < 0.80 and not spells.prayerOfHealing.isRecastAt("player")', "player" , "POH" },
    }},
    {{"nested"}, 'not player.isMoving and heal.countInRange > 2 and not player.isInRaid' ,{
        {spells.prayerOfHealing, 'player.hasBuff(spells.divinity)' , kps.heal.lowestTankInRaid , "POH_BUFF" },
        {spells.prayerOfHealing, 'player.hasBuff(spells.powerOfTheNaaru)' , kps.heal.lowestTankInRaid , "POH_BUFF" },
        {spells.prayerOfHealing, 'player.hp < 0.80 and not spells.prayerOfHealing.isRecastAt("player")' , "player" , "POH" },
    }},

    -- "Renew" 139
    {spells.renew, 'heal.lowestTankInRaid.myBuffDuration(spells.renew) < 3' , kps.heal.lowestTankInRaid},
    {spells.renew, 'heal.lowestTargetInRaid.myBuffDuration(spells.renew) < 3' , kps.heal.lowestTargetInRaid},
    {spells.renew, 'not player.isInRaid and heal.lowestInRaid.hpIncoming < 0.95 and heal.lowestInRaid.hp > 0.70 and heal.lowestInRaid.myBuffDuration(spells.renew) < 3' , kps.heal.lowestInRaid, "RENEW_COUNT" },
    -- "Circle of Healing" 204883
    {spells.circleOfHealing, 'player.isMoving and heal.averageHpIncoming < 0.80' , kps.heal.lowestInRaid},
    
    -- "Soins rapides" 2060
    {spells.flashHeal, 'not player.isMoving and heal.lowestInRaid.hp < 0.80 and heal.lowestTankInRaid.hp > heal.lowestInRaid.hp and not player.isInRaid' , kps.heal.lowestInRaid , "FLASH_PARTY" },
    {spells.flashHeal, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.80 and not player.isInRaid' , kps.heal.lowestTankInRaid , "FLASHEAL_TANK" },
    {spells.flashHeal, 'not player.isMoving and heal.lowestInRaid.hp < 0.70 and heal.lowestTankInRaid.hp > heal.lowestInRaid.hp and player.isInRaid' , kps.heal.lowestInRaid , "FLASH_RAID" },
    {spells.flashHeal, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.70 and player.isInRaid' , kps.heal.lowestTankInRaid , "FLASHEAL_TANK" },
    
    -- "Soins" 2060 -- "Renouveau constant" 200153
    {spells.heal, 'not player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.92' , kps.heal.lowestTankInRaid, "HEAL_TANK" },
    {spells.heal, 'not player.isMoving and heal.lowestTargetInRaid.hpIncoming < 0.92' , kps.heal.lowestTargetInRaid, "HEAL_TANK" },
    {spells.heal, 'not player.isMoving and heal.lowestInRaid.hpIncoming < 0.92' , kps.heal.lowestInRaid , "HEAL_LOWEST" },
    {spells.heal, 'not player.isMoving and holyWordSerenityOnCD()' , kps.heal.lowestInRaid , "HEAL_SERENITY" },

    -- "Renew" 139
    {spells.renew, 'player.isMoving and heal.lowestInRaid.hpIncoming < 0.95 and heal.lowestInRaid.myBuffDuration(spells.renew) < 3 and not heal.lowestInRaid.hasBuff(spells.masteryEchoOfLight)' , kps.heal.lowestInRaid, "RENEW_LOWEST" },

    -- "Nova sacrée" 132157
    {spells.holyNova, 'player.isMoving and target.distance < 10 and target.isAttackable' , "target" },
    {spells.holyNova, 'player.isMoving and targettarget.distance < 10 and targettarget.isAttackable' , "targettarget" },
    -- "Surge Of Light" Your healing spells and Smite have a 8% chance to make your next Flash Heal instant and cost no mana
    {spells.smite, 'not player.isMoving and target.isAttackable', "target" },
    {spells.smite, 'not player.isMoving and targettarget.isAttackable', "targettarget" },
    {spells.smite, 'not player.isMoving and focustarget.isAttackable and not player.isInRaid', "focustarget" },

}
,"Holy heal")

--For Raiding:  Enlightment
--For Dungeons: Trail of Light
--For Raiding:  Light of the Naaru
--For Dungeons: Guardian Angel
--For Raiding:  Piety
--For Dungeons: Surge of Light
--For Raiding:  Divinity
--For Dungeons: Divinity
--For Raiding:  Benediction
--For Dungeons: Apotheosis


