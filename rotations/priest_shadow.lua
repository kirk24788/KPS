--[[
@module Priest Shadow Rotation
@author Kirk24788
]]
local spells = kps.spells.priest
local env = kps.env.priest

kps.rotations.register("PRIEST","SHADOW",
{
    -- Cooldowns
    {{"nested"}, 'kps.cooldowns', {
        {spells.mindbender, 'player.hasTalent(3, 2)'}, -- mindbender,if=talent.mindbender.enabled
        {spells.shadowfiend, 'not player.hasTalent(3, 2)'}, -- shadowfiend,if=!talent.mindbender.enabled
        {spells.darkSoulInstability, 'spells.darkSoulInstability.charges == 2 and player.emberShards > 9'},
    }},

    -- Against 2-3 Targets
    {{"nested"}, 'activeEnemies.count >= 2 and activeEnemies.count <= 3', {
          {spells.devouringPlague, 'player.shadowOrbs >= 3'},
          {spells.mindBlast, 'player.shadowOrbs < 5'},
          {spells.shadowWordDeath, 'player.shadowOrbs < 5 and target.hp < 0.20'},
          {spells.shadowWordPain, 'target.myDebuffDuration(spells.shadowWordPain) <= 5.4'},
          {spells.shadowWordPain, 'mouseover.myDebuffDuration(spells.shadowWordPain) <= 5.4', 'mouseover'},
          {spells.vampiricTouch, 'target.myDebuffDuration(spells.vampiricTouch) <= 4.5'},
          {spells.vampiricTouch, 'mouseover.myDebuffDuration(spells.vampiricTouch) <= 4.5', 'mouseover'},
          {spells.mindFlay},
    }},
    -- Against 4+ Targets
    {{"nested"}, 'activeEnemies.count >= 2 and activeEnemies.count <= 3', {
          {spells.devouringPlague, 'player.shadowOrbs >= 3'},
          {spells.mindBlast, 'player.shadowOrbs < 5'},
          {spells.shadowWordDeath, 'player.shadowOrbs < 5 and target.hp < 0.20'},
          {spells.shadowWordPain, 'target.myDebuffDuration(spells.shadowWordPain) <= 5.4'},
          {spells.shadowWordPain, 'mouseover.myDebuffDuration(spells.shadowWordPain) <= 5.4', 'mouseover'},
          {spells.vampiricTouch, 'target.myDebuffDuration(spells.vampiricTouch) <= 4.5'},
          {spells.vampiricTouch, 'mouseover.myDebuffDuration(spells.vampiricTouch) <= 4.5', 'mouseover'},
          {spells.mindSear},
    }},
    -- Single Target
    {{"nested"}, 'activeEnemies.count == 1', {
          {spells.devouringPlague, 'player.shadowOrbs >= 3'},
          {spells.mindBlast, 'player.shadowOrbs < 5'},
          {spells.shadowWordDeath, 'player.shadowOrbs < 5 and target.hp < 0.20'},
          {spells.insanity, 'player.hasBuff(spells.insanity)'},
          {spells.mindSpike, 'player.hasBuff(spells.surgeOfDarkness).'},
          {spells.shadowWordPain, 'target.myDebuffDuration(spells.shadowWordPain) <= 5.4'},
          {spells.shadowWordPain, 'focus.myDebuffDuration(spells.shadowWordPain) <= 5.4', 'focus'},
          {spells.vampiricTouch, 'target.myDebuffDuration(spells.vampiricTouch) <= 4.5'},
          {spells.vampiricTouch, 'focus.myDebuffDuration(spells.vampiricTouch) <= 4.5', 'focus'},
          {spells.mindFlay},
    }},

}
,"IcyVeins")