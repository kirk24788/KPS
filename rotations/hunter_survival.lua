--[[[
@module Hunter Survival Rotation
@generated_from hunter_survival.simc
@version 7.0.3
]]--
local spells = kps.spells.hunter
local env = kps.env.hunter


kps.rotations.register("HUNTER","SURVIVAL","hunter_survival.simc").setCombatTable(
{
    {spells.explosiveTrap}, -- explosive_trap
    {spells.dragonsfireGrenade}, -- dragonsfire_grenade
-- ERROR in 'carve,if=talent.serpent_sting.enabled&active_enemies>=3&(!dot.serpent_sting.ticking|dot.serpent_sting.remains<=gcd.max)': Unknown Talent 'serpentSting' for 'hunter'!
-- ERROR in 'raptor_strike,cycle_targets=1,if=talent.serpent_sting.enabled&active_enemies<=2&(!dot.serpent_sting.ticking|dot.serpent_sting.remains<=gcd.max)|talent.way_of_the_moknathal.enabled&(buff.moknathal_tactics.remains<gcd.max|buff.moknathal_tactics.down)': Unknown Talent 'serpentSting' for 'hunter'!
    {spells.aspectOfTheEagle}, -- aspect_of_the_eagle
-- ERROR in 'fury_of_the_eagle,if=buff.mongoose_fury.up&buff.mongoose_fury.remains<=gcd.max*2': Spell 'kps.spells.hunter.mongooseFury' unknown (in expression: 'buff.mongoose_fury.up')!
-- ERROR in 'mongoose_bite,if=buff.mongoose_fury.up|cooldown.fury_of_the_eagle.remains<5|charges=3': Spell 'kps.spells.hunter.mongooseFury' unknown (in expression: 'buff.mongoose_fury.up')!
    {spells.steelTrap}, -- steel_trap
    {spells.aMurderOfCrows}, -- a_murder_of_crows
    {spells.lacerate, 'target.hasMyDebuff(spells.lacerate) and target.myDebuffDuration(spells.lacerate) <= 3 or target.timeToDie >= 5'}, -- lacerate,if=dot.lacerate.ticking&dot.lacerate.remains<=3|target.time_to_die>=5
-- ERROR in 'snake_hunter,if=action.mongoose_bite.charges<=1&buff.mongoose_fury.remains>gcd.max*4': Spell 'kps.spells.hunter.mongooseFury' unknown (in expression: 'buff.mongoose_fury.remains')!
-- ERROR in 'flanking_strike,if=talent.way_of_the_moknathal.enabled&(focus>=55&buff.moknathal_tactics.remains>=3)|focus>=55': Unknown Talent 'wayOfTheMoknathal' for 'hunter'!
-- ERROR in 'butchery,if=spell_targets.butchery>=2': Unknown expression 'spell_targets.butchery'!
-- ERROR in 'carve,if=spell_targets.carve>=4': Unknown expression 'spell_targets.carve'!
    {spells.spittingCobra}, -- spitting_cobra
    {spells.throwingAxes}, -- throwing_axes
    {spells.raptorStrike, 'player.focus > 75 - spells.flankingStrike.cooldown * player.focusRegen'}, -- raptor_strike,if=focus>75-cooldown.flanking_strike.remains*focus.regen
})
