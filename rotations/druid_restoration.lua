--[[
@module Druid Restoration Rotation
@author Kirk24788
]]
local spells = kps.spells.druid
local env = kps.env.druid

kps.rotations.register("DRUID","RESTORATION",{
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
