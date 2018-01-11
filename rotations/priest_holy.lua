--[[[
@module Priest Holy Rotation
@author htordeux
@version 7.2
]]--


local spells = kps.spells.priest
local env = kps.env.priest

local HolyWordSanctify = spells.holyWordSanctify.name
local SpiritOfRedemption = spells.spiritOfRedemption.name
local MassDispel = spells.massDispel.name
local AngelicFeather = spells.angelicFeather.name

kps.runAtEnd(function()
   kps.gui.addCustomToggle("PRIEST","HOLY", "leapOfFaith", "Interface\\Icons\\priest_spell_leapoffaith_a", "leapOfFaith")
end)

-- kps.cooldowns for dispel
-- kps.interrupt for guardianSpirit
-- kps.defensive for mouseover
-- kps.multiTarget for damage
kps.rotations.register("PRIEST","HOLY",{

    {{"macro"}, 'not target.exists and mouseover.inCombat and mouseover.isAttackable' , "/target mouseover" },
    env.ShouldInterruptCasting,
    env.ScreenMessage,

    {{"macro"}, 'player.hasBuff(spells.spiritOfRedemption) and heal.countInRange == 0' , "/cancelaura "..SpiritOfRedemption },
    {{"nested"}, 'player.hasBuff(spells.spiritOfRedemption)' ,{
        {spells.guardianSpirit, 'true' , kps.heal.lowestInRaid},
        {spells.holyWordSerenity, 'true' , kps.heal.lowestInRaid},
        {spells.prayerOfMending, 'true' , kps.heal.lowestInRaid},
        {{"macro"},'spells.holyWordSanctify.cooldown == 0' , "/cast [@player] "..HolyWordSanctify },
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.90' , kps.heal.lowestInRaid},
        {spells.renew, 'heal.lowestInRaid.myBuffDuration(spells.renew) < 3' , kps.heal.lowestInRaid},
    }},

    -- "Holy Word: Sanctify" and "Holy Word: Serenity" gives buff  "Divinity" 197030 When you heal with a Holy Word spell, your healing is increased by 15% for 8 sec.
    {{"macro"}, 'keys.shift', "/cast [@cursor] "..HolyWordSanctify },
    -- "Dissipation de masse" 32375
    {{"macro"}, 'keys.ctrl', "/cast [@cursor] "..MassDispel },
    
    -- "Fade" 586 "Disparition"
    {spells.fade, 'player.isTarget' },
    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp < 0.82' ,"/use item:5512" },
    -- "Prière du désespoir" 19236 "Desperate Prayer"
    {spells.desperatePrayer, 'player.hp < 0.72' , "player" },
    -- "Don des naaru" 59544
    {spells.giftOfTheNaaru, 'player.hp < 0.72' , "player" },
    -- "Angelic Feather"
    {{"macro"},'player.hasTalent(2,1) and player.isMovingFor(1.2) and spells.angelicFeather.cooldown == 0 and not player.hasBuff(spells.angelicFeather)' , "/cast [@player] "..AngelicFeather },
    -- "Body and Mind"
    {spells.bodyAndMind, 'player.hasTalent(2,2) and player.isMovingFor(1.2) and not player.hasBuff(spells.bodyAndMind)' , "player"},

    -- "Guardian Spirit" 47788
    {{"nested"}, 'kps.interrupt' ,{
        {spells.guardianSpirit, 'player.hp < 0.30 and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestTankInRaid},
        {spells.guardianSpirit, 'player.hp < 0.30 and not heal.lowestInRaid.isUnit("player")' , kps.heal.lowestInRaid},
        {spells.guardianSpirit, 'focus.isFriend and focus.hp < 0.30' , "focus"},
        {spells.guardianSpirit, 'heal.aggroTankTarget.hp < 0.30' , kps.heal.aggroTankTarget},
        {spells.guardianSpirit, 'heal.lowestTankInRaid.hp < 0.30' , kps.heal.lowestTankInRaid},
        {spells.guardianSpirit, 'heal.lowestInRaid.hp < 0.30' , kps.heal.lowestInRaid},
    }},

    -- "Dispel" "Purifier" 527
    {{"nested"},'kps.cooldowns', {
        {spells.purify, 'player.isDispellable("Magic")' , "player" },
        {spells.purify, 'mouseover.isDispellable("Magic")' , "mouseover" },
        {spells.purify, 'focus.isFriend and focus.isDispellable("Magic")' , "focus"},
        {spells.purify, 'heal.lowestTankInRaid.isDispellable("Magic")' , kps.heal.lowestTankInRaid},
        {spells.purify, 'heal.lowestInRaid.isDispellable("Magic")' , kps.heal.lowestInRaid},
        {spells.purify, 'heal.aggroTankTarget.isDispellable("Magic")' , kps.heal.aggroTankTarget},
        {spells.purify, 'heal.isMagicDispellable ~= nil' , kps.heal.isMagicDispellable , "DISPEL" },
    }},
    
    -- TRINKETS -- SLOT 0 /use 13
    -- "Résonateur de vitalité" "Vitality Resonator" 151970
    {{"macro"}, 'player.hasTrinket(0) == 151970 and player.useTrinket(0) and target.isAttackable' , "/use 13" },
    -- "Ishkar's Felshield Emitter" 151957 -- "Emetteur de gangrebouclier d'Ishkar" 151957
    {{"macro"}, 'player.hasTrinket(0) == 151957 and player.useTrinket(0) and focus.isFriend' , "/target ".."focus".."\n".."/use 13".."\n".."/targetlasttarget" },
    {{"macro"}, 'player.hasTrinket(0) == 151957 and player.useTrinket(0)' , "/target ".."player".."\n".."/use 13".."\n".."/targetlasttarget" },
     -- "The Deceiver's Grand Design" 147007 "Grand dessein du Trompeur"
    {{"macro"}, 'player.hasTrinket(0) == 147007 and player.useTrinket(0) and focus.isFriend and not focus.hasBuff(spells.guidingHand)' , "/target ".."focus".."\n".."/use 13".."\n".."/targetlasttarget" },
    {{"macro"}, 'player.hasTrinket(0) == 147007 and player.useTrinket(0) and not player.hasBuff(spells.guidingHand)' , "/target ".."player".."\n".."/use 13".."\n".."/targetlasttarget" },
    
    -- TRINKETS -- SLOT 1 /use 14
    -- "Résonateur de vitalité" "Vitality Resonator" 151970
    {{"macro"}, 'player.hasTrinket(1) == 151970 and player.useTrinket(1) and target.isAttackable' , "/use 14" },
    -- "Ishkar's Felshield Emitter" 151957 -- "Emetteur de gangrebouclier d'Ishkar" 151957
    {{"macro"}, 'player.hasTrinket(1) == 151957 and player.useTrinket(1) and focus.isFriend' , "/target ".."focus".."\n".."/use 14".."\n".."/targetlasttarget" },
    {{"macro"}, 'player.hasTrinket(1) == 151957 and player.useTrinket(1)' , "/target ".."player".."\n".."/use 14".."\n".."/targetlasttarget" },
    -- "Velen's Future Sight" 144258
    {{"macro"}, 'player.hasTrinket(1) == 144258 and player.useTrinket(1) and heal.countLossInRange(0.82) >= 3' , "/use 14" },

    -- "Apotheosis" 200183 increasing the effects of Serendipity by 200% and reducing the cost of your Holy Words by 100% -- "Benediction" for raid and "Apotheosis" for party
    {spells.apotheosis, 'player.hasTalent(7,1) and heal.countLossInRange(0.78) * 2 >= heal.countInRange' },

    -- "Holy Word: Serenity"
    {spells.holyWordSerenity, 'player.hp < 0.40' , "player"},
    {spells.holyWordSerenity, 'heal.lowestTankInRaid.hp < 0.55' , kps.heal.lowestTankInRaid},
    {spells.holyWordSerenity, 'heal.aggroTankTarget.hp < 0.55' , kps.heal.aggroTankTarget},
    {spells.holyWordSerenity, 'heal.lowestInRaid.hp < 0.40' , kps.heal.lowestInRaid},

    -- "Surge Of Light"
    {{"nested"}, 'player.hasBuff(spells.surgeOfLight)' , {
        {spells.flashHeal, 'player.buffStacks(spells.surgeOfLight) == 2' , kps.heal.lowestInRaid},
        {spells.flashHeal, 'player.hp < 0.78' , "player"},
        {spells.flashHeal, 'heal.lowestTankInRaid.hp < 0.78' , kps.heal.lowestTankInRaid},
        {spells.flashHeal, 'heal.aggroTankTarget.hp < 0.78' , kps.heal.aggroTankTarget},
        {spells.flashHeal, 'heal.lowestInRaid.hp < 0.78' , kps.heal.lowestInRaid},
        {spells.flashHeal, 'player.myBuffDuration(spells.surgeOfLight) < 3' , kps.heal.lowestInRaid},
    }},

    -- "Leap Of Faith"
    {spells.leapOfFaith, 'kps.leapOfFaith and not heal.lowestInRaid.isUnit("player") and heal.lowestInRaid.hp < 0.20 and not heal.lowestInRaid.isTankInRaid' , kps.heal.lowestInRaid },
    -- "Prayer of Mending" (Tank only)
    {spells.prayerOfMending, 'heal.lowestInRaid.hp > 0.82' ,  kps.heal.lowestTankInRaid },
    {spells.prayerOfMending, 'heal.lowestInRaid.hp > 0.82' ,  kps.heal.aggroTankTarget }, 
    
    -- "Light of T'uure" 208065 -- track buff in case an other priest have casted lightOfTuure
    {{spells.lightOfTuure,spells.flashHeal}, 'not player.isMoving and spells.lightOfTuure.cooldown == 0 and heal.lowestTankInRaid.incomingDamage > heal.lowestTankInRaid.incomingHeal and heal.lowestTankInRaid.hp < 0.78 and not heal.lowestTankInRaid.hasBuff(spells.lightOfTuure)' , kps.heal.lowestTankInRaid},
    {{spells.lightOfTuure,spells.flashHeal}, 'not player.isMoving and spells.lightOfTuure.cooldown == 0 and heal.aggroTankTarget.incomingDamage > heal.aggroTankTarget.incomingHeal and heal.aggroTankTarget.hp < 0.78 and not heal.aggroTankTarget.hasBuff(spells.lightOfTuure)' , kps.heal.aggroTankTarget},
    {{spells.lightOfTuure,spells.flashHeal}, 'not player.isMoving and spells.lightOfTuure.cooldown == 0 and heal.lowestInRaid.hp < 0.40 and not heal.lowestInRaid.hasBuff(spells.lightOfTuure)' , kps.heal.lowestInRaid},

    -- "Soins de lien" 32546 -- kps.lastCast["name"] ne fonctionne pas si lastcast etait une macro
    {{"nested"}, 'kps.lastCast["name"] == spells.prayerOfHealing' , {
        {spells.flashHeal, 'not player.isMoving and heal.lowestInRaid.isUnit("player")' , "player" , "FLASH_PLAYER_POH" },
        {spells.flashHeal, 'not player.isMoving and heal.lowestInRaid.hp < 0.40' , kps.heal.lowestInRaid ,"FLASH_LOWEST_POH" },
        {spells.bindingHeal, 'not player.isMoving and not heal.lowestTankInRaid.isUnit("player")' , kps.heal.lowestTankInRaid ,"BINDING_LOWEST_POH" },
        {spells.bindingHeal, 'not player.isMoving and not heal.lowestInRaid.isUnit("player")' , kps.heal.lowestInRaid ,"BINDING_LOWEST_POH" },
    }},  
    -- "Holy Word: Sanctify" -- macro does not work for @target, @mouseover... ONLY @cursor and @player
    {{spells.holyWordSanctify,spells.prayerOfHealing}, 'spells.holyWordSanctify.cooldown == 0 and heal.countLossInRange(0.78) * 2 >= heal.countInRange' , kps.heal.lowestInRaid  }, 
    {{spells.holyWordSanctify,spells.prayerOfHealing}, 'spells.holyWordSanctify.cooldown == 0 and heal.countLossInRange(0.55) >= 3' , kps.heal.lowestInRaid  }, 
    {spells.prayerOfHealing, 'heal.countLossInRange(0.78) >= 4 and player.hasBuff(spells.powerOfTheNaaru)' , kps.heal.lowestInRaid , "POH_DISTANCE" },    
    {{"macro"},'spells.holyWordSanctify.cooldown == 0 and heal.countLossInDistance(0.78,10) >= 4' , "/cast [@player] "..HolyWordSanctify },

    -- "Soins rapides" 2060
    {spells.flashHeal, 'not player.isMoving and player.hp < 0.55 and heal.lowestInRaid.isUnit("player")' , "player" , "FLASH_PLAYER_LOWEST" },
    {spells.flashHeal, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.55 and heal.lowestInRaid.isUnit(heal.lowestTankInRaid.unit)' , kps.heal.lowestTankInRaid , "FLASH_TANK_LOWEST" },
    {spells.flashHeal, 'not player.isMoving and heal.aggroTankTarget.hp < 0.55 and heal.lowestInRaid.isUnit(heal.aggroTankTarget.unit)' , kps.heal.aggroTankTarget , "FLASH_AGGRO_LOWEST" },
    
    -- "Prayer of Mending" (Tank only)
    {spells.prayerOfMending, 'not player.isMoving and heal.hasRaidBuffStacks(spells.prayerOfMending) < 10 and not heal.lowestTankInRaid.hasBuff(spells.prayerOfMending)' , kps.heal.lowestTankInRaid },
    {spells.prayerOfMending, 'not player.isMoving and heal.hasRaidBuffStacks(spells.prayerOfMending) < 10 and not heal.aggroTankTarget.hasBuff(spells.prayerOfMending)' , kps.heal.aggroTankTarget},
    {spells.prayerOfMending, 'not player.isMoving and heal.hasRaidBuffStacks(spells.prayerOfMending) < 10 and not heal.lowestInRaid.hasBuff(spells.prayerOfMending)' , kps.heal.lowestInRaid},

    {{"nested"}, 'kps.defensive and mouseover.isFriend' , {
        {spells.guardianSpirit, 'mouseover.hp < 0.30' , "mouseover" },
        {spells.holyWordSerenity, 'mouseover.hp < 0.40' , "mouseover" },
        {spells.flashHeal, 'not player.isMoving and mouseover.hp < 0.55' , "mouseover" },
        {spells.bindingHeal, 'not player.isMoving and not mouseover.isUnit("player") and mouseover.hp < holythreshold()' , "mouseover" },
    }},

    {{"nested"}, 'kps.multiTarget and heal.lowestInRaid.hp > target.hp and heal.lowestInRaid.hp > 0.72' , {
        {spells.holyWordChastise, 'target.isAttackable' , "target" },
        {spells.holyWordChastise, 'targettarget.isAttackable', "targettarget" },
        {spells.holyWordChastise, 'focustarget.isAttackable', "focustarget" },
        {spells.holyFire, 'target.isAttackable' , "target" },
        {spells.holyFire, 'targettarget.isAttackable', "targettarget" },
        {spells.holyFire, 'focustarget.isAttackable', "focustarget" },
        {spells.holyNova, 'kps.lastCast["name"] == spells.smite and target.distance < 10 and target.isAttackable' , "target" },
        {spells.smite, 'not player.isMoving and target.isAttackable', "target" },
        {spells.smite, 'not player.isMoving and targettarget.isAttackable', "targettarget" },
        {spells.smite, 'not player.isMoving and focustarget.isAttackable', "focustarget" },
    }},

    -- "Prayer of Healing" 596 -- A powerful prayer that heals the target and the 4 nearest allies within 40 yards for (250% of Spell power)
    -- "Holy Word: Sanctify" your healing is increased by 15% for 6 sec. Buff  "Divinity" 197030
    -- "Holy Word: Sanctify" augmente les soins de Prière de soins de 6% pendant 15 sec. Buff "Puissance des naaru" 196490
    {{"nested"}, 'not player.isMoving and heal.countLossInRange(0.78) >= 4 and player.isInRaid' ,{
        {spells.prayerOfHealing, 'player.hasBuff(spells.divinity)' , kps.heal.lowestInRaid , "POH_BUFF" },
        {spells.prayerOfHealing, 'player.hasBuff(spells.powerOfTheNaaru)' , kps.heal.lowestInRaid , "POH_BUFF" },
        {spells.prayerOfHealing, 'not spells.prayerOfHealing.isRecastAt(heal.lowestInRaid.unit)', kps.heal.lowestInRaid , "POH_COUNT" },
    }},
    {{"nested"}, 'not player.isMoving and heal.countLossInRange(0.82) >= 3 and not player.isInRaid' ,{
        {spells.prayerOfHealing, 'player.hasBuff(spells.divinity)' , kps.heal.lowestInRaid , "POH_BUFF_COUNT" },
        {spells.prayerOfHealing, 'player.hasBuff(spells.powerOfTheNaaru)' , kps.heal.lowestInRaid , "POH_BUFF_COUNT" },
        {spells.prayerOfHealing, 'not spells.prayerOfHealing.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "POH_COUNT" },
    }},
    
    -- "Divine Hymn" 64843
    {spells.divineHymn , 'not player.isMoving and heal.countLossInRange(0.62) * 2 >= heal.countInRange and heal.hasRaidBuffCount(spells.prayerOfMending) > 1' },
    -- "Circle of Healing" 204883
    --{spells.circleOfHealing, 'player.isMoving and heal.countLossInRange(0.78) >= 3 and not player.isInRaid' , kps.heal.lowestInRaid},
    --{spells.circleOfHealing, 'player.isMoving and heal.countLossInRange(0.78) >= 5 and player.isInRaid' },
    
    --[[
    -- BOSSDEBUFF
    {spells.lightOfTuure, 'heal.hasBossDebuff ~= nil and heal.hasBossDebuff.hp < 0.78' , kps.heal.hasBossDebuff , "BOSS_DEBUF" },
    {spells.holyWordSerenity, 'heal.hasBossDebuff ~= nil and heal.hasBossDebuff.hp < 0.50' , kps.heal.hasBossDebuff , "BOSS_DEBUF" },
    {spells.flashHeal, 'heal.hasBossDebuff ~= nil and heal.hasBossDebuff.hp < holythreshold()' , kps.heal.hasBossDebuff , "BOSS_DEBUF" },
    -- ABSOPTION HEAL
    {spells.holyWordSerenity, 'heal.hasAbsorptionHeal ~= nil and heal.hasAbsorptionHeal.hp < 1' , kps.heal.hasAbsorptionHeal , "ABSORB_HEAL" },
    {spells.heal, 'heal.hasAbsorptionHeal ~= nil and heal.hasAbsorptionHeal.hp < 1' , kps.heal.hasAbsorptionHeal , "ABSORB_HEAL" },
    ]]

    -- "Soins rapides" 2060    
    {spells.flashHeal, 'not player.isMoving and player.hp < 0.40 and not spells.flashHeal.isRecastAt("player")' , "player" , "FLASH_PLAYER_URG" },
    {spells.flashHeal, 'not player.isMoving and heal.lowestInRaid.hp < 0.40 and not spells.flashHeal.isRecastAt(heal.lowestInRaid.unit)' , kps.heal.lowestInRaid , "FLASH_LOWEST_URG" },
    -- "Soins rapides" 2060
    {spells.flashHeal, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.55 and heal.lowestTankInRaid.incomingDamage > heal.lowestTankInRaid.incomingHeal' , kps.heal.lowestTankInRaid , "FLASH_TANK_DMG" },
    {spells.flashHeal, 'not player.isMoving and heal.aggroTankTarget.hp < 0.55 and heal.aggroTankTarget.incomingDamage > heal.aggroTankTarget.incomingHeal' , kps.heal.aggroTankTarget , "FLASH_AGGRO_DMG" },
    {spells.flashHeal, 'not player.isMoving and heal.lowestInRaid.hp < 0.40 and heal.lowestInRaid.incomingDamage > heal.lowestInRaid.incomingHeal' , kps.heal.lowestInRaid , "FLASH_LOWEST_DMG" },

    {{"nested"}, 'not player.isMoving and heal.lowestInRaid.hp < holythreshold() and not player.isInRaid' ,{
        {spells.flashHeal, 'not player.isMoving and heal.lowestTankInRaid.hp < holythreshold()' , kps.heal.lowestTankInRaid , "FLASH_TANK" },
        {spells.flashHeal, 'not player.isMoving and heal.aggroTankTarget.hp < holythreshold()' , kps.heal.aggroTankTarget , "FLASH_AGGRO" },
        {spells.flashHeal, 'not player.isMoving and heal.lowestInRaid.hp < holythreshold()' , kps.heal.lowestInRaid , "FLASH_LOWEST" },
    }},
    -- "Soins de lien" 32546
    {spells.bindingHeal, 'not player.isMoving and not heal.lowestTankInRaid.isUnit("player") and heal.lowestTankInRaid.hp < 0.92 and spells.holyWordSanctify.cooldown > 4' , kps.heal.lowestTankInRaid ,"BINDING_SANCTIFY_TANK" },
    {spells.bindingHeal, 'not player.isMoving and not heal.aggroTankTarget.isUnit("player") and heal.aggroTankTarget.hp < 0.92 and spells.holyWordSanctify.cooldown > 4' , kps.heal.aggroTankTarget ,"BINDING_SANCTIFY_AGGRO" },
    {spells.bindingHeal, 'not player.isMoving and not heal.lowestInRaid.isUnit("player") and spells.holyWordSanctify.cooldown > 4  ' , kps.heal.lowestInRaid ,"BINDING_SANCTIFY_LOWEST" },
    {spells.bindingHeal, 'not player.isMoving and not heal.lowestInRaid.isUnit("player") and heal.countLossInRange(0.92) > 2' , kps.heal.lowestInRaid ,"BINDING_LOWEST" },
    -- "Soins" 2060 -- "Renouveau constant" 200153
    {spells.heal, 'not player.isMoving and heal.aggroTankTarget.hp < 0.92' , kps.heal.aggroTankTarget , "HEAL_AGGRO" },
    {spells.heal, 'not player.isMoving and heal.lowestTankInRaid.hp < 0.92' , kps.heal.lowestTankInRaid , "HEAL_TANK" },
    {spells.heal, 'not player.isMoving and heal.lowestInRaid.hp < 0.92' , kps.heal.lowestInRaid , "HEAL_LOWEST" },
    {spells.heal, 'not player.isMoving and holyWordSerenityOnCD()' , kps.heal.lowestInRaid , "HEAL_SERENITY" },
    
    -- "Renew" 139 PARTY
    {spells.renew, 'not player.isInRaid and heal.lowestInRaid.hp < 0.92 and heal.lowestInRaid.hp > holythreshold() and heal.lowestInRaid.myBuffDuration(spells.renew) < 3 and not heal.lowestInRaid.hasBuff(spells.masteryEchoOfLight)' , kps.heal.lowestInRaid, "RENEW_PARTY" },
    {spells.renew, 'player.isMoving and heal.lowestTankInRaid.hp < 0.92 and heal.lowestTankInRaid.myBuffDuration(spells.renew) < 3 and not heal.lowestTankInRaid.hasBuff(spells.masteryEchoOfLight)' , kps.heal.lowestTankInRaid, "RENEW_TANK" },
    {spells.renew, 'player.isMoving and heal.aggroTankTarget.hp < 0.92 and heal.aggroTankTarget.myBuffDuration(spells.renew) < 3 and not heal.aggroTankTarget.hasBuff(spells.masteryEchoOfLight)' , kps.heal.aggroTankTarget, "RENEW_AGGRO" },
    {spells.renew, 'player.isMoving and heal.lowestInRaid.hp < holythreshold() and heal.lowestInRaid.myBuffDuration(spells.renew) < 3 and not heal.lowestInRaid.hasBuff(spells.masteryEchoOfLight)' , kps.heal.lowestInRaid, "RENEW" },

    -- "Nova sacrée" 132157
    {spells.holyNova, 'player.isMoving and target.distance < 10 and target.isAttackable and heal.countLossInDistance(0.92,10) >= 3' , "target" },
    {spells.holyNova, 'player.isMoving and targettarget.distance < 10 and targettarget.isAttackable and heal.countLossInDistance(0.92,10) >= 3' , "targettarget" },
    {spells.holyNova, 'player.isMoving and focustarget.distance < 10 and focustarget.isAttackable and heal.countLossInDistance(0.92,10) >= 3' , "focustarget" },
    -- "Surge Of Light" Your healing spells and Smite have a 8% chance to make your next Flash Heal instant and cost no mana
    {spells.smite, 'not player.isMoving and target.isAttackable', "target" },
    {spells.smite, 'not player.isMoving and targettarget.isAttackable', "targettarget" },
    {spells.smite, 'not player.isMoving and focustarget.isAttackable', "focustarget" },

}
,"Holy heal")


