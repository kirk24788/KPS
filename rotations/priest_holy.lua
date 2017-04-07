--[[[
@module Priest Holy Rotation
@author Subzrk.Xvir
@version 7.0.3
]]--
local spells = kps.spells.priest
local env = kps.env.priest

kps.rotations.register("PRIEST","HOLY",
{
    {{"nested"}, 'player.hasBuff(spells.spiritOfRedemption)' ,{
        {spells.prayerOfHealing, 'heal.countInRange > 3' , kps.heal.lowestInRaid},
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid},
        {spells.renew, 'heal.lowestInRaid.myBuffDuration(spells.renew) < 3 and heal.lowestInRaid.hp < 0.95' , kps.heal.lowestInRaid},
    }},
    
    {spells.guardianSpirit, 'player.hp < 0.30' , kps.heal.lowestTankInRaid}, 
    {spells.guardianSpirit, 'heal.lowestTankInRaid.hp < 0.30' , kps.heal.lowestTankInRaid},
    {spells.guardianSpirit, 'heal.aggroTank.hp < 0.30' , kps.heal.aggroTank},
    {spells.guardianSpirit, 'heal.lowestInRaid.hp < 0.30' , kps.heal.lowestInRaid},
    
    -- TRINKETS
    -- { "macro", jps.useTrinket(0) , "/use 13"}, -- jps.useTrinket(0) est "Trinket0Slot" est slotId  13
    {{"macro"}, 'player.useTrinket(1) and heal.countInRange > 3' , "/use 14"}, -- jps.useTrinket(1) est "Trinket1Slot" est slotId  14

    -- "Apotheosis" 200183 increasing the effects of Serendipity by 200% and reducing the cost of your Holy Words by 100%.
    { spells.apotheosis, 'player.hasTalent(7,1) and heal.lowestInRaid.hp < 0.40' },
    { spells.apotheosis, 'player.hasTalent(7,1) and heal.countInRange > 3' },
    
    -- Surge Of Light
    {{"nested"}, 'player.hasBuff(spells.surgeOfLight)' , {
        {spells.flashHeal, 'player.hp < 0.80' , "player"},
        {spells.flashHeal, 'heal.lowestTankInRaid.hp < 0.85' , kps.heal.lowestTankInRaid},
        {spells.flashHeal, 'heal.aggroTank.hp < 0.85' , kps.heal.aggroTank},
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.80' , kps.heal.lowestInRaid},
    }},
    -- Holy Word: Serenity
    {spells.holyWordSerenity, 'player.hp < 0.50' , "player"},
    {spells.holyWordSerenity, 'heal.lowestTankInRaid.hp < 0.50' , kps.heal.lowestTankInRaid},
    {spells.holyWordSerenity, 'heal.aggroTank.hp < 0.50' , kps.heal.aggroTank},
    {spells.holyWordSerenity, 'heal.lowestInRaid.hp < 0.40' , kps.heal.lowestInRaid},

    -- "Fade" 586 "Disparition"
    {spells.fade, 'player.isTarget' },
    -- Body and Mind
    {spells.bodyAndMind, 'player.isMoving and not player.hasBuff(spells.bodyAndMind)' , "player"},

    -- "Don des naaru" 59544
    {spells.giftNaaru, 'player.hp < 0.60' , "player" },
    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp < 0.90' ,"/use item:5512" },
    -- renew
    {spells.renew, 'player.myBuffDuration(spells.renew) < 3 and player.hp < 0.95' , "player"},

    -- "Dispel" "Purifier" 527
    {spells.purify, 'player.isDispellable("Magic")' , "player" },
    {spells.purify, 'mouseover.isDispellable("Magic")' , "mouseover" },
    {spells.purify, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid},
    
    {{"nested"}, 'kps.multiTarget and target.isAttackable' , {
        {spells.holyWordChastise },
        {spells.holyFire },
        {spells.smite },
    }},
    
    -- Prayer of Mending (Tank only)
    {spells.prayerOfMending, 'not player.isMoving and heal.lowestInRaid.hp > 0.60 and not heal.aggroTank.hasBuff(spells.prayerOfMending)' , kps.heal.aggroTank},
    {spells.prayerOfMending, 'not player.isMoving and heal.lowestInRaid.hp > 0.60 and not heal.lowestTankInRaid.hasBuff(spells.prayerOfMending)' , kps.heal.aggroTank},
    -- "Divine Hymn" 64843
    {spells.divineHymn , 'not player.isMoving and heal.countInRange * 2 > heal.maxcountInRange and heal.averageHpIncoming < 0.70' },
    -- "Prayer of Healing" 596
    {spells.prayerOfHealing, 'not player.isMoving and player.isInRaid and heal.countInRange > 5', "player"},
    {spells.prayerOfHealing, 'not player.isMoving and not player.isInRaid and heal.countInRange > 3', "player"},
    
    {spells.renew, 'heal.lowestInRaid.myBuffDuration(spells.renew) < 3 and heal.lowestInRaid.hp < 0.95' , kps.heal.lowestInRaid},
    {spells.renew, 'heal.lowestTankInRaid.myBuffDuration(spells.renew) < 3 and heal.lowestTankInRaid.hp < 0.95' , kps.heal.lowestTankInRaid},
    
    {spells.flashHeal, 'not player.isMoving and heal.lowestTargetInRaid.hp < 0.70' , kps.heal.lowestTargetInRaid}, 
    
    -- "Light of T'uure" 208065
    {spells.lightOfTuure, 'player.hp < 0.85 and not player.hasBuff(spells.lightOfTuure)' , "player"},
    {spells.flashHeal, 'not player.isMoving and player.hp < 0.70' , "player"},
    {spells.lightOfTuure, 'heal.lowestInRaid.hp < 0.85 and not heal.lowestInRaid.hasBuff(spells.lightOfTuure)' , kps.heal.lowestInRaid},
    {spells.flashHeal, 'not player.isMoving and heal.lowestTankInRaid.hp > heal.lowestInRaid.hp and heal.lowestInRaid.hp < 0.70' , kps.heal.lowestInRaid},

    {spells.lightOfTuure, 'heal.lowestTankInRaid.hp < 0.85 and not heal.lowestTankInRaid.hasBuff(spells.lightOfTuure)' , kps.heal.lowestTankInRaid},
    {spells.flashHeal, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.70' , kps.heal.lowestTankInRaid},
    {spells.lightOfTuure, 'heal.aggroTank.hp < 0.85 and not heal.aggroTank.hasBuff(spells.lightOfTuure)' , kps.heal.aggroTank},
    {spells.flashHeal, 'not player.isMoving and heal.aggroTank.hp < 0.70 ' , kps.heal.aggroTank},
    
    -- renew
    {spells.renew, 'heal.aggroTank.myBuffDuration(spells.renew) < 3 and heal.aggroTank.hp < 0.95' , kps.heal.aggroTank},
    {spells.renew, 'heal.lowestInRaid.myBuffDuration(spells.renew) < 3 and heal.lowestInRaid.hp < 0.95' , kps.heal.lowestInRaid},

    {{"nested"}, 'not player.isMoving',{
        -- Heal
        {spells.heal, 'heal.lowestTankInRaid.hp < 0.95' , kps.heal.lowestTankInRaid},
        {spells.heal, 'heal.lowestInRaid.hp < 0.85' , kps.heal.lowestInRaid},
    }},

    -- "Nova sacrée" 132157
    {spells.holyNova, 'player.isMoving and target.distance < 10 and target.isAttackable' , "target" },    
    -- smite when doing nothing
    {spells.smite, 'target.isAttackable and not player.hasBuff(spells.surgeOfLight)', "target" },

}
,"Holy heal")

--kps.rotations.register("PRIEST","HOLY",
--{
--    {spells.powerInfusion, 'player.hasTalent(5, 2)'}, -- power_infusion,if=talent.power_infusion.enabled
--    {spells.shadowfiend, 'not player.hasTalent(3, 2)'}, -- shadowfiend,if=!talent.mindbender.enabled
--    {spells.mindbender, 'player.hasTalent(3, 2)'}, -- mindbender,if=talent.mindbender.enabled
--    {spells.shadowWordPain, 'not target.hasMyDebuff(spells.shadowWordPain)'}, -- shadow_word_pain,cycle_targets=1,max_cycle_targets=5,if=miss_react&!ticking
--    {spells.powerWordSolace}, -- power_word_solace
--    {spells.mindSear, 'activeEnemies.count >= 4'}, -- mind_sear,if=active_enemies>=4
--    {spells.holyFire}, -- holy_fire
--    {spells.smite}, -- smite
--    {spells.holyWordChastise}, -- holy_word,moving=1
--    {spells.shadowWordPain}, -- shadow_word_pain,moving=1
--}
--,"Holy damage")


