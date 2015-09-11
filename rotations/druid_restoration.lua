--[[
@module Druid Restoration Rotation
@author Kirk24788
]]
local spells = kps.spells.druid
local env = kps.env.druid

kps.rotations.register("DRUID","RESTORATION",{
    -- Cooldowns
    {{"nested"}, 'kps.cooldowns', {
        {spells.tranquility, 'not player.isMoving and kps.heal.averageHpIncoming < 0.5'},
    }},

    {spells.swiftmend, 'kps.heal.defaultTarget.hp < 0.85 and (kps.heal.defaultTarget.hasBuff(spells.rejuvination) or kps.heal.defaultTarget.hasBuff(spells.regrowth))', kps.heal.defaultTarget },
    {spells.lifebloom, 'kps.heal.defaultTank.myBuffDuration(spells.lifebloom) < 3 and kps.heal.defaultTank.hp < 1', kps.heal.defaultTank},
    {spells.wildGrowth, 'kps.multiTarget and kps.heal.defaultTarget.hpIncoming < 0.9 and kps.heal.defaultTarget.hp < 1', kps.heal.defaultTarget},
    {spells.rejuvenation, 'kps.heal.defaultTarget.myBuffDuration(spells.rejuvenation) < 3 and kps.heal.defaultTarget.hp < 1', kps.heal.defaultTarget},

    {spells.regrowth, 'kps.heal.defaultTarget.hpIncoming < 0.5', kps.heal.defaultTarget},

    {spells.naturesSwiftness, 'kps.heal.defaultTarget.hpIncoming < 0.4', kps.heal.defaultTarget},

    
    {{"nested"}, '(player.hasBuff(spells.naturesSwiftness) or kps.heal.defaultTarget.hp < 0.6) and not player.isMoving', {
        {spells.regrowth, 'player.hasBuff(spells.clearcasting)', kps.heal.defaultTarget},
        {spells.healingTouch, 'true', kps.heal.defaultTarget},
    }},
    
    -- rebirth Ctrl-key + mouseover
    --[[
    { druid.spells.rebirth, 'IsAltKeyDown() == true and UnitIsDeadOrGhost("mouseover") == true and IsSpellInRange("rebirth", "mouseover")', "mouseover" },
    
    -- Buffs
    { druid.spells.markOfTheWild, 'not jps.buff(druid.spells.markOfTheWild)', player },
    
    -- CDs
    { druid.spells.barkskin, 'jps.hp() < 0.50' },
    
    {druid.spells.wildMushroom, 'IsShiftKeyDown() == true'  },
    
    {"nested",'jps.Interrupts', {
        druid.dispel
    }},
    { druid.spells.lifebloom, 'jps.buffDuration(druid.spells.lifebloom,jps.findMeATank()) < 3', jps.findMeATank },
    { druid.spells.swiftmend, 'druid.legacyDefaultHP() < 0.85 and (jps.buff(druid.spells.rejuvination,druid.legacyDefaultTarget()) or jps.buff(druid.spells.regrowth,druid.legacyDefaultTarget()))', druid.legacyDefaultTarget },
    { druid.spells.wildGrowth, 'druid.legacyDefaultHP() < 0.90 and jps.MultiTarget', druid.legacyDefaultTarget },
    { druid.spells.rejuvination, 'druid.legacyDefaultHP() < 0.85 and not jps.buff(druid.spells.rejuvination,druid.legacyDefaultTarget())', druid.legacyDefaultTarget },
    --{ druid.spells.rejuvination, 'jps.talentInfo("Germination") and druid.legacyDefaultHP() < 0.65 and jps.buff(druid.spells.rejuvination,druid.legacyDefaultTarget()) and not jps.buff("Rejuvenation (Germination)",druid.legacyDefaultTarget())', druid.legacyDefaultTarget },
    
    { druid.spells.rejuvination, 'jps.buffDuration(druid.spells.rejuvination,jps.findMeATank()) < 3', jps.findMeATank },    
    { druid.spells.rejuvination, 'jps.buff(druid.spells.rejuvination,jps.findMeATank()) and jps.talentInfo("Germination") and not jps.buff("Rejuvenation (Germination)",jps.findMeATank()) ', jps.findMeATank },  
    
    { druid.spells.healingTouch, '(jps.buff(druid.spells.naturesSwiftness) or not jps.Moving) and jps.hp(jps.findMeATank()) < 0.70', jps.findMeATank },   
    { druid.spells.healingTouch, '(jps.buff(druid.spells.naturesSwiftness) or not jps.Moving) and druid.legacyDefaultHP() < 0.60', druid.legacyDefaultTarget },    

    { druid.spells.regrowth, 'druid.legacyDefaultHP() < 0.50', druid.legacyDefaultTarget },
    { druid.spells.naturesSwiftness, 'druid.legacyDefaultHP() < 0.40' },
    ]]
}, "Legacy Rotation")
