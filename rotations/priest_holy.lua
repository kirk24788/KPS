--[[[
@module Priest Holy Rotation
@author htordeux
@version 7.2
]]--

local spells = kps.spells.priest
local env = kps.env.priest
local holyWordSanctify = tostring(spells.holyWordSanctify)


kps.rotations.register("PRIEST","HOLY",{

    {{"macro"}, 'not target.exists and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable' , "/target mouseover" },
    env.ShouldInterruptCasting,

    {{"nested"}, 'player.hasBuff(spells.spiritOfRedemption)' ,{
        {spells.holyWordSerenity, 'heal.lowestInRaid.hp < 0.60' , kps.heal.lowestInRaid},
        {spells.prayerOfMending,'true' , kps.heal.lowestInRaid},
        {spells.prayerOfHealing, 'heal.averageHpIncoming < 0.80' , kps.heal.lowestInRaid},
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid},
        {spells.renew, 'heal.lowestInRaid.myBuffDuration(spells.renew) < 3 and heal.lowestInRaid.hp < 0.95' , kps.heal.lowestInRaid},
    }},
    
    -- "Fade" 586 "Disparition"
    {spells.fade, 'player.isTarget' },
    -- "Prière du désespoir" 19236 "Desperate Prayer"
    {spells.desperatePrayer, 'player.hp < 0.60' , "player" },
    -- Body and Mind
    {spells.bodyAndMind, 'player.isMoving and not player.hasBuff(spells.bodyAndMind)' , "player"},
    -- "Don des naaru" 59544
    {spells.giftOfTheNaaru, 'player.hp < 0.60' , "player" },
    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp < 0.90' ,"/use item:5512" },
    -- renew
    {spells.renew, 'player.myBuffDuration(spells.renew) < 3 and player.hp < 0.95' , "player"},
    -- "Light of T'uure" 208065
    {spells.lightOfTuure, 'player.hp < 0.70 and not player.hasBuff(spells.lightOfTuure)' , "player"},
    -- "Soins de lien" 32546
    {spells.bindingHeal, 'heal.lowestInRaid.hp < 0.70 and player.hp < 0.70 and player.hp > heal.lowestInRaid.hp' , kps.heal.lowestInRaid},

    {spells.guardianSpirit, 'player.hp < 0.30' , kps.heal.lowestTargetInRaid},
    {{"nested"}, 'kps.interrupt' ,{
        {spells.guardianSpirit, 'heal.lowestTankInRaid.hp < 0.30 and not heal.lowestTankInRaid.hasBuff(spells.guardianSpirit)' , kps.heal.lowestTankInRaid},
        {spells.guardianSpirit, 'heal.lowestTargetInRaid.hp < 0.30 and not heal.lowestTargetInRaid.hasBuff(spells.guardianSpirit)' , kps.heal.lowestTargetInRaid},
        {spells.guardianSpirit, 'heal.aggroTank.hp < 0.30 and not heal.aggroTank.hasBuff(spells.guardianSpirit)' , kps.heal.aggroTank},
        {spells.guardianSpirit, 'heal.lowestInRaid.hp < 0.30 and not heal.lowestInRaid.hasBuff(spells.guardianSpirit)' , kps.heal.lowestInRaid},
     }},

    -- TRINKETS "Trinket0Slot" est slotId  13 "Trinket1Slot" est slotId  14
    {{"macro"}, 'player.useTrinket(1) and heal.countInRange > 3' , "/use 14"},
    -- "Apotheosis" 200183 increasing the effects of Serendipity by 200% and reducing the cost of your Holy Words by 100%.
    { spells.apotheosis, 'player.hasTalent(7,1) and heal.lowestInRaid.hp < 0.40 and spells.guardianSpirit.cooldown > 0' },
    { spells.apotheosis, 'player.hasTalent(7,1) and heal.lowestInRaid.hp < 0.60 and heal.countInRange > 3' },
    
    -- Surge Of Light
    {{"nested"}, 'player.hasBuff(spells.surgeOfLight)' , {
        {spells.flashHeal, 'player.hp < 0.85' , "player"},
        {spells.flashHeal, 'heal.lowestTankInRaid.hp < 0.85' , kps.heal.lowestTankInRaid},
        {spells.flashHeal, 'heal.lowestTargetInRaid.hp < 0.85' , kps.heal.lowestTargetInRaid},
        {spells.flashHeal, 'heal.aggroTank.hp < 0.85' , kps.heal.aggroTank},
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid},
        {spells.flashHeal, 'player.myBuffDuration(spells.surgeOfLight) < 3' , kps.heal.lowestInRaid},
    }},

    -- Holy Word: Serenity
    {spells.holyWordSerenity, 'player.hp < 0.40' , "player"},
    {spells.holyWordSerenity, 'heal.lowestTankInRaid.hp < 0.40' , kps.heal.lowestTankInRaid},
    {spells.holyWordSerenity, 'heal.lowestTargetInRaid.hp < 0.40' , kps.heal.lowestTargetInRaid},
    {spells.holyWordSerenity, 'heal.aggroTank.hp < 0.40' , kps.heal.aggroTank},
    {spells.holyWordSerenity, 'heal.lowestInRaid.hp < 0.40' , kps.heal.lowestInRaid},

    -- "Dispel" "Purifier" 527
    {{"nested"},'kps.cooldowns', {
        {spells.purify, 'player.isDispellable("Magic")' , "player" },
        {spells.purify, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid},
        {spells.purify, 'heal.isMagicDispellable ~= nil' , kps.heal.isMagicDispellable},
    }}, 

    -- "Light of T'uure" 208065
    {spells.lightOfTuure, 'heal.lowestTankInRaid.hp < 0.85 and not heal.lowestTankInRaid.hasBuff(spells.lightOfTuure)' , kps.heal.lowestTankInRaid},
    {spells.lightOfTuure, 'heal.lowestTargetInRaid.hp < 0.85 and not heal.lowestTargetInRaid.hasBuff(spells.lightOfTuure)' , kps.heal.lowestTargetInRaid},
    {spells.lightOfTuure, 'heal.lowestInRaid.hp < 0.85 and not heal.lowestInRaid.hasBuff(spells.lightOfTuure)' , kps.heal.lowestInRaid},

    -- Prayer of Mending (Tank only)
    {spells.prayerOfMending, 'not player.isMoving and heal.lowestTankInRaid.hp > 0.60 and not heal.lowestTankInRaid.hasBuff(spells.prayerOfMending)' , kps.heal.lowestTankInRaid},
    {spells.prayerOfMending, 'not player.isMoving and heal.aggroTank.hp > 0.60 and not heal.aggroTank.hasBuff(spells.prayerOfMending)' , kps.heal.aggroTank},
    {spells.prayerOfMending, 'not player.isMoving and heal.lowestInRaid.hp > 0.60 and not heal.lowestInRaid.hasBuff(spells.prayerOfMending)' , kps.heal.lowestInRaid},
    -- "Divine Hymn" 64843
    {spells.divineHymn , 'not player.isMoving and heal.countInRange * 2 > heal.maxcountInRange and heal.averageHpIncoming < 0.65 and heal.maxcountInRange > 3' },
    
    {{"nested"}, 'kps.defensive and mouseover.isHealable' , {
        {spells.purify, 'mouseover.isDispellable("Magic")' , "mouseover" },
        {spells.holyWordSerenity, 'mouseover.hp < 0.40' , "mouseover" },
        {spells.guardianSpirit, 'mouseover.hp < 0.30' , "mouseover" },
        {spells.prayerOfHealing, 'not player.isMoving and heal.countInRange > 3 and not player.isInRaid' , "mouseover" },
        {spells.prayerOfHealing, 'not player.isMoving and heal.countInRange > 5 and player.isInRaid' , "mouseover" }, 
        {spells.lightOfTuure, 'mouseover.hp < 0.70' , "mouseover" },
        {spells.flashHeal, 'not player.isMoving and mouseover.hp < 0.70' , "mouseover" },
        {spells.renew, 'mouseover.myBuffDuration(spells.renew) < 3 and mouseover.hp < 0.90' , "mouseover" },
        {spells.heal, 'not player.isMoving and mouseover.hp < 0.90' , "mouseover" },
    }}, 
    
    {{"nested"}, 'kps.multiTarget and target.isAttackable' , {
        {spells.holyWordChastise },
        {spells.holyFire },
        {spells.smite },
        {spells.holyNova, 'player.isMoving and target.distance < 10 and target.isAttackable' , "target" },
    }},

    -- "Prayer of Healing" 596
    {{"nested"}, 'not player.isMoving and heal.countInRange > 3 and spells.holyWordSanctify.cooldown == 0 and heal.lowestTargetInRaid.distance < 20' , {
        {{spells.holyWordSanctify,spells.prayerOfHealing}, 'heal.countInRange > 3 and not player.isInRaid' , "player" },
        {{spells.holyWordSanctify,spells.prayerOfHealing}, 'heal.countInRange > 5 and player.isInRaid' , "player" },
    }},
    {{"macro"}, 'keys.shift', "/cast [@cursor] "..holyWordSanctify },
    {spells.prayerOfHealing, 'not player.isMoving and heal.countInRange > 3 and not player.isInRaid and player.hasBuff(spells.divinity) and spells.holyWordSanctify.cooldown > 0', "player" },
    {spells.prayerOfHealing, 'not player.isMoving and heal.countInRange > 3 and player.isInRaid and player.hasBuff(spells.divinity) and spells.holyWordSanctify.cooldown > 0', "player" },
    {spells.prayerOfHealing, 'not player.isMoving and heal.countInRange > 3 and not player.isInRaid and not spells.prayerOfHealing.isRecastAt("player")', "player" },
    {spells.prayerOfHealing, 'not player.isMoving and heal.countInRange > 5 and player.isInRaid and not spells.prayerOfHealing.isRecastAt("player")', "player" },
 
    -- "Soins rapides" 2060
    {spells.flashHeal, 'not player.isMoving and player.hasTalent(1,1) and heal.lowestInRaid.hp < 0.70 and not heal.lowestInRaid.lastCastedUnit' , kps.heal.lowestInRaid},

    -- "Renew" 139
    {spells.renew, 'heal.lowestTankInRaid.myBuffDuration(spells.renew) < 3 and heal.lowestTankInRaid.hp < 0.95' , kps.heal.lowestTankInRaid},
    {spells.renew, 'heal.lowestTargetInRaid.myBuffDuration(spells.renew) < 3 and heal.lowestTargetInRaid.hp < 0.95' , kps.heal.lowestTargetInRaid},

    -- "Soins rapides" 2060    
    {{"nested"}, 'not player.isMoving and heal.lowestTargetInRaid.hp < 0.80' , {
        {spells.flashHeal, 'heal.lowestTargetInRaid.hasBuff(spells.lightOfTuure)' , kps.heal.lowestTargetInRaid},
        {spells.flashHeal, 'heal.lowestTargetInRaid.incomingDamage > heal.lowestTargetInRaid.incomingHeal' , kps.heal.lowestTargetInRaid},
        {spells.flashHeal, 'heal.lowestTargetInRaid.hp < 0.70' , kps.heal.lowestTargetInRaid},
    }},
    {{"nested"}, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.80' , {
        {spells.flashHeal, 'heal.lowestTankInRaid.hasBuff(spells.lightOfTuure)' , kps.heal.lowestTankInRaid},
        {spells.flashHeal, 'heal.lowestTankInRaid.incomingDamage > heal.lowestTankInRaid.incomingHeal' , kps.heal.lowestTankInRaid},
        {spells.flashHeal, 'heal.lowestTankInRaid.hp < 0.70' , kps.heal.lowestTankInRaid},
    }},
    {{"nested"}, 'not player.isMoving and heal.lowestInRaid.hp < 0.80 and heal.countInRange < 4' , {
        {spells.flashHeal, 'heal.lowestInRaid.hasBuff(spells.lightOfTuure)' , kps.heal.lowestInRaid},
        {spells.flashHeal, 'heal.lowestInRaid.incomingDamage > heal.lowestInRaid.incomingHeal' , kps.heal.lowestInRaid },
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.70' , kps.heal.lowestInRaid},
    }},

    -- "Prayer of Healing" 596 -- A powerful prayer that heals the target and the 4 nearest allies within 40 yards for (250% of Spell power)
    -- "Holy Word: Sanctify" gives buff  "Divinity" 197030 When you heal with a Holy Word spell, your healing is increased by 15% for 8 sec.    
    {{"nested"}, 'not player.isMoving and heal.countInRange > 3 and not player.isInRaid' ,{
        {spells.prayerOfHealing, 'player.hasBuff(spells.divinity)', "player" },
        {spells.holyWordSanctify, 'heal.lowestTargetInRaid.distance < 20' },
        {spells.prayerOfHealing, 'true' , "player" },
    }},
    {{"nested"}, 'not player.isMoving and heal.countInRange > 5 and player.isInRaid' ,{
        {spells.prayerOfHealing, 'player.hasBuff(spells.divinity)' , "player" },
        {spells.holyWordSanctify, 'heal.lowestTargetInRaid.distance < 20' },
        {spells.prayerOfHealing, 'true' , "player" },
    }},
    -- "Circle of Healing" 204883
    {spells.circleOfHealing, 'player.isMoving and heal.averageHpIncoming < 0.80' , kps.heal.lowestInRaid},

    -- "Renew" 139
    {spells.renew, 'heal.lowestInRaid.myBuffDuration(spells.renew) < 3 and heal.lowestInRaid.hpIncoming < 0.95 and not heal.lowestInRaid.hasBuff(spells.echoOfLight)' , kps.heal.lowestInRaid},

    -- "Soins" 2060 -- "Renouveau constant" 200153
    {{"nested"}, 'not player.isMoving',{
        {spells.heal, 'heal.lowestTankInRaid.hp < 0.90' , kps.heal.lowestTankInRaid},
        {spells.heal, 'heal.lowestTargetInRaid.hp < 0.90' , kps.heal.lowestTargetInRaid},
        {spells.heal, 'heal.aggroTank.hp < 0.90' , kps.heal.aggroTank},
        {spells.heal, 'heal.lowestInRaid.hp < 0.90' , kps.heal.lowestInRaid},
        {spells.heal, 'spells.holyWordSerenity.cooldown > 0' , kps.heal.lowestTankInRaid},
    }},

    -- "Nova sacrée" 132157
    {spells.holyNova, 'player.isMoving and target.distance < 10 and target.isAttackable' , "target" },
    {spells.holyNova, 'player.isMoving and targettarget.distance < 10 and targettarget.isAttackable' , "targettarget" },
    -- Your healing spells and Smite have a 8% chance to make your next Flash Heal instant and cost no mana
    {spells.smite, 'not player.isMoving and target.isAttackable and not player.hasBuff(spells.surgeOfLight)', "target" },
    {spells.smite, 'not player.isMoving and targettarget.isAttackable and not player.hasBuff(spells.surgeOfLight)', "targettarget" },

}
,"Holy heal")


