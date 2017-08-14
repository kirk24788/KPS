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
        {spells.guardianSpirit, 'true' , kps.heal.lowestInRaid},
        {spells.holyWordSerenity, 'true' , kps.heal.lowestInRaid},
        {spells.prayerOfMending, 'true' , kps.heal.lowestInRaid},
        {spells.holyWordSanctify, 'true' },
        {spells.divineHymn, 'true'},
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid},
        {spells.renew, 'heal.lowestInRaid.myBuffDuration(spells.renew) < 3' , kps.heal.lowestInRaid},
    }},
    
    -- "Guardian Spirit" 47788  -- track buff in case an other priest have casted guardianSpirit
    {{"nested"}, 'kps.interrupt' ,{
        {spells.guardianSpirit, 'player.hp < 0.30 and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestTankInRaid},
        {spells.guardianSpirit, 'player.hp < 0.30 and not heal.lowestInRaid.isUnit("player")' , kps.heal.lowestInRaid},
        {spells.guardianSpirit, 'heal.lowestTankInRaid.hp < 0.30 and not heal.lowestTankInRaid.hasBuff(spells.guardianSpirit)' , kps.heal.lowestTankInRaid},
        {spells.guardianSpirit, 'heal.lowestTargetInRaid.hp < 0.30 and not heal.lowestTargetInRaid.hasBuff(spells.guardianSpirit)' , kps.heal.lowestTargetInRaid},
        {spells.guardianSpirit, 'heal.lowestInRaid.hp < 0.30 and not heal.lowestInRaid.hasBuff(spells.guardianSpirit)' , kps.heal.lowestInRaid},
    }},
    
    -- "Dispel" "Purifier" 527
    {{"nested"},'kps.cooldowns', {
        {spells.purify, 'heal.isMagicDispellable ~= nil' , kps.heal.isMagicDispellable , "DISPEL" },
        {spells.purify, 'mouseover.isDispellable("Magic")' , "mouseover" },
        {spells.purify, 'player.isDispellable("Magic")' , "player" },
        {spells.purify, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid},
    }},
    
    -- "Holy Word: Sanctify" and "Holy Word: Serenity" gives buff  "Divinity" 197030 When you heal with a Holy Word spell, your healing is increased by 15% for 8 sec.
    {{"macro"}, 'keys.shift', "/cast [@cursor] "..HolyWordSanctify },
    -- "Dissipation de masse" 32375
    {{"macro"}, 'keys.ctrl', "/cast [@cursor] "..MassDispel },
    
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
    -- "Soins rapides" 2060
    {spells.flashHeal, 'not player.isMoving and player.hp < 0.60 and not spells.flashHeal.isRecastAt("player")' , "player" , "FLASH_PLAYER" },
    {spells.flashHeal, 'not player.isMoving and player.hp < 0.60 and heal.lowestInRaid.isUnit("player")' , "player" , "FLASH_PLAYER" },

    -- TRINKETS
    -- "Velen's Future Sight"
    {{"macro"}, 'player.useTrinket(1) and heal.countLossInRange(0.80) >= 3' , "/use 14"},
    -- "Apotheosis" 200183 increasing the effects of Serendipity by 200% and reducing the cost of your Holy Words by 100% -- "Benediction" for raid and "Apotheosis" for party
    {spells.apotheosis, 'player.hasTalent(7,1) and heal.countLossInRange(0.70) >= 3' },
    
    -- "Soins rapides" 2060
    {spells.bindingHeal, 'not player.isMoving and kps.lastCast["name"] == spells.holyWordSanctify and heal.lowestInRaid.hp < 0.80 and not heal.lowestInRaid.isUnit("player")' , kps.heal.lowestInRaid},
    {spells.bindingHeal, 'not player.isMoving and kps.lastCast["name"] == spells.prayerOfHealing and heal.lowestInRaid.hp < 0.80 and not heal.lowestInRaid.isUnit("player")' , kps.heal.lowestInRaid},
    {spells.flashHeal, 'not player.isMoving and kps.lastCast["name"] == spells.prayerOfHealing and heal.lowestTankInRaid.hp < 0.50' , kps.heal.lowestTankInRaid },
    {spells.flashHeal, 'not player.isMoving and kps.lastCast["name"] == spells.prayerOfHealing and heal.lowestInRaid.hp < 0.50' , kps.heal.lowestInRaid},

    -- "Surge Of Light"
    {{"nested"}, 'player.hasBuff(spells.surgeOfLight)' , {
        {spells.flashHeal, 'player.hp < 0.80' , "player"},
        {spells.flashHeal, 'heal.lowestTankInRaid.hp < 0.80' , kps.heal.lowestTankInRaid},
        {spells.flashHeal, 'heal.lowestTargetInRaid.hp < 0.80' , kps.heal.lowestTargetInRaid},
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid},
        {spells.flashHeal, 'player.myBuffDuration(spells.surgeOfLight) < 3' , kps.heal.lowestInRaid},
    }},
    
    -- "Holy Word: Serenity"
    {spells.holyWordSerenity, 'heal.lowestTankInRaid.hp < 0.50' , kps.heal.lowestTankInRaid},
    {spells.holyWordSerenity, 'heal.lowestTargetInRaid.hp < 0.50' , kps.heal.lowestTargetInRaid},
    {spells.holyWordSerenity, 'heal.lowestInRaid.hp < 0.50' , kps.heal.lowestInRaid},
    {spells.holyWordSerenity, 'not player.hasBuff(spells.divinity) and heal.lowestInRaid.hp < 0.60 and heal.countLossInRange(0.80) >= 3 and not player.isInRaid' , kps.heal.lowestInRaid , "SERENITY_COUNT" },
    {spells.holyWordSerenity, 'not player.hasBuff(spells.divinity) and heal.lowestInRaid.hp < 0.60 and heal.countLossInRange(0.70) >= 5 and player.isInRaid' , kps.heal.lowestInRaid , "SERENITY_COUNT" },
    
    -- "Prayer of Mending" (Tank only)
    {spells.prayerOfMending, 'not player.isMoving and heal.lowestInRaid.hp > 0.60 and not heal.lowestTankInRaid.hasBuff(spells.prayerOfMending)' , kps.heal.lowestTankInRaid},
    {spells.prayerOfMending, 'not player.isMoving and heal.lowestInRaid.hp > 0.60 and not heal.lowestTargetInRaid.hasBuff(spells.prayerOfMending)' , kps.heal.lowestTargetInRaid},
    {spells.prayerOfMending, 'not player.isMoving and heal.lowestInRaid.hp > 0.60 and not heal.lowestInRaid.hasBuff(spells.prayerOfMending)' , kps.heal.lowestInRaid},
    {spells.prayerOfMending, 'not player.isMoving and heal.hasRaidBuff(spells.prayerOfMending) == nil and heal.lowestInRaid.hp > 0.50' , kps.heal.lowestTankInRaid, "POM_COUNT" },
    
    -- "Light of T'uure" 208065 -- track buff in case an other priest have casted lightOfTuure
    {{spells.lightOfTuure,spells.flashHeal}, 'not player.isMoving and spells.lightOfTuure.cooldown == 0 and heal.lowestTankInRaid.hp > 0.50 and heal.lowestTankInRaid.hp < 0.80 and not heal.lowestTankInRaid.hasBuff(spells.lightOfTuure)' , kps.heal.lowestTankInRaid},
    {{spells.lightOfTuure,spells.flashHeal}, 'not player.isMoving and spells.lightOfTuure.cooldown == 0 and heal.lowestTankInRaid.hp > 0.50 and heal.lowestTargetInRaid.hp < 0.80 and not heal.lowestTargetInRaid.hasBuff(spells.lightOfTuure)' ,kps.heal.lowestTargetInRaid},
    --{{spells.lightOfTuure,spells.flashHeal}, 'not player.isMoving and spells.lightOfTuure.cooldown == 0 and heal.lowestInRaid.hp < 0.70 and not heal.lowestInRaid.hasBuff(spells.lightOfTuure)' , kps.heal.lowestInRaid},

    {{"nested"}, 'kps.defensive and mouseover.isHealable' , {
        {spells.guardianSpirit, 'mouseover.hp < 0.30' , "mouseover" },
        {spells.holyWordSerenity, 'mouseover.hp < 0.50' , "mouseover" },
        {spells.prayerOfHealing, 'not player.isMoving and heal.countLossInRange(0.80) >= 3 and not player.isInRaid' , "mouseover" },
        {spells.prayerOfHealing, 'not player.isMoving and heal.countLossInRange(0.70) >= 5 and player.isInRaid' , "mouseover" }, 
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
        {spells.smite, 'not player.isMoving and focustarget.isAttackable', "focustarget" },
    }},

    -- "Holy Word: Sanctify"
    {spells.holyWordSanctify, 'heal.countLossInRange(0.80) >= 3 and not player.isInRaid' },
    {spells.holyWordSanctify, 'heal.countLossInRange(0.70) >= 5 and player.isInRaid' },
    -- "Divine Hymn" 64843
    {spells.divineHymn , 'not player.isMoving and heal.countLossInRange(0.50) * 2 >= heal.maxcountInRange and heal.hasRaidBuff(spells.prayerOfMending) ~= nil' },
    -- "Circle of Healing" 204883
    {spells.circleOfHealing, 'player.isMoving and heal.countLossInRange(0.80) >= 3 and not player.isInRaid' , kps.heal.lowestInRaid},
    {spells.circleOfHealing, 'player.isMoving and heal.countLossInRange(0.70) >= 5 and player.isInRaid' },
 
    -- "Prayer of Healing" 596 -- A powerful prayer that heals the target and the 4 nearest allies within 40 yards for (250% of Spell power)
    -- "Holy Word: Sanctify" your healing is increased by 15% for 6 sec. Buff  "Divinity" 197030
    -- "Holy Word: Sanctify" augmente les soins de Prière de soins de 6% pendant 15 sec. Buff "Puissance des naaru" 196490
    {{"nested"}, 'not player.isMoving and heal.countLossInRange(0.70) >= 5 and player.isInRaid' ,{
        {spells.prayerOfHealing, 'player.hasBuff(spells.divinity)' , kps.heal.lowestInRaid , "POH_BUFF" },
        {spells.prayerOfHealing, 'player.hasBuff(spells.powerOfTheNaaru)' , kps.heal.lowestInRaid , "POH_BUFF" },
        {spells.prayerOfHealing, 'not spells.prayerOfHealing.isRecastAt(heal.lowestInRaid.unit)', kps.heal.lowestInRaid , "POH" },
    }},
    {{"nested"}, 'not player.isMoving and heal.countLossInRange(0.80) >= 3 and not player.isInRaid' ,{
        {spells.prayerOfHealing, 'player.hasBuff(spells.divinity)' , kps.heal.lowestInRaid , "POH_BUFF_COUNT" },
        {spells.prayerOfHealing, 'player.hasBuff(spells.powerOfTheNaaru)' , kps.heal.lowestInRaid , "POH_BUFF_COUNT" },
        {spells.prayerOfHealing, 'not spells.prayerOfHealing.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "POH_COUNT" },
    }},
    
    -- "Renew" 139 PARTY
    {spells.renew, 'not player.isInRaid and heal.lowestInRaid.hpIncoming < 0.90 and heal.lowestInRaid.hpIncoming > 0.70 and heal.lowestInRaid.myBuffDuration(spells.renew) < 3 and not heal.lowestInRaid.hasBuff(spells.masteryEchoOfLight)' , kps.heal.lowestInRaid, "RENEW_PARTY" }, 
    {spells.bindingHeal, 'not player.isMoving and heal.lowestInRaid.hp < 0.90 and heal.lowestInRaid.hp > 0.70 and not heal.lowestInRaid.isUnit("player") and heal.lowestTankInRaid.hp < heal.lowestInRaid.hp and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestTankInRaid ,"BINDINGHEAL_TANK" },
    {spells.bindingHeal, 'not player.isMoving and heal.lowestInRaid.hp < 0.90 and heal.lowestInRaid.hp > 0.70 and not heal.lowestInRaid.isUnit("player") and heal.lowestTankInRaid.hp > heal.lowestInRaid.hp and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestInRaid ,"BINDINGHEAL" },

    -- "Soins rapides" 2060
    {spells.flashHeal, 'not player.isMoving and heal.lowestInRaid.hp < 0.70 and heal.lowestTankInRaid.hp > heal.lowestInRaid.hp' , kps.heal.lowestInRaid , "FLASH_LOWEST" },
    {spells.flashHeal, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.70' , kps.heal.lowestTankInRaid , "FLASH_TANK" },
   
    -- "Soins de lien" 32546
    {spells.bindingHeal, 'not player.isMoving and not heal.lowestTankInRaid.isUnit("player") and holyWordSerenityOnCD()' , kps.heal.lowestTankInRaid ,"BINDINGHEAL_SERENITY" },
    {spells.bindingHeal, 'not player.isMoving and not heal.lowestInRaid.isUnit("player") and holyWordSerenityOnCD()' , kps.heal.lowestInRaid ,"BINDINGHEAL_SERENITY" },

    -- "Soins" 2060 -- "Renouveau constant" 200153
    {spells.heal, 'not player.isMoving and heal.lowestTankInRaid.hp < 1' , kps.heal.lowestTankInRaid, "HEAL_TANK" },
    {spells.heal, 'not player.isMoving and heal.lowestInRaid.hp < 1' , kps.heal.lowestInRaid , "HEAL_LOWEST" },
    {spells.heal, 'not player.isMoving and holyWordSerenityOnCD()' , kps.heal.lowestInRaid , "HEAL_SERENITY" },

    -- "Renew" 139
    {spells.renew, 'player.isMoving and heal.lowestTankInRaid.hpIncoming < 0.95 and heal.lowestTankInRaid.myBuffDuration(spells.renew) < 3 and not heal.lowestTankInRaid.hasBuff(spells.masteryEchoOfLight)' , kps.heal.lowestTankInRaid},
    {spells.renew, 'player.isMoving and heal.lowestTargetInRaid.hpIncoming < 0.95 and heal.lowestTargetInRaid.myBuffDuration(spells.renew) < 3 and not heal.lowestTargetInRaid.hasBuff(spells.masteryEchoOfLight)' , kps.heal.lowestTargetInRaid},
    {spells.renew, 'player.isMoving and heal.lowestInRaid.hpIncoming < 0.95 and heal.lowestInRaid.myBuffDuration(spells.renew) < 3 and not heal.lowestInRaid.hasBuff(spells.masteryEchoOfLight)' , kps.heal.lowestInRaid, "RENEW" },

    -- "Nova sacrée" 132157
    {spells.holyNova, 'player.isMoving and target.distance < 10 and target.isAttackable' , "target" },
    {spells.holyNova, 'player.isMoving and targettarget.distance < 10 and targettarget.isAttackable' , "targettarget" },
    -- "Surge Of Light" Your healing spells and Smite have a 8% chance to make your next Flash Heal instant and cost no mana
    {spells.smite, 'not player.isMoving and target.isAttackable', "target" },
    {spells.smite, 'not player.isMoving and targettarget.isAttackable', "targettarget" },
    {spells.smite, 'not player.isMoving and focustarget.isAttackable', "focustarget" },

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


