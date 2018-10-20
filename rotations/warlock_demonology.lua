--[[[
@module Warlock Demonology Rotation
@author Kirk24788
@version 7.0.3
]]--
local spells = kps.spells.warlock
local env = kps.env.warlock

local buildShard = {

    --actions.build_a_shard=demonbolt,if=azerite.forbidden_knowledge.enabled&buff.forbidden_knowledge.react&!buff.demonic_core.react&cooldown.summon_demonic_tyrant.remains>20
    {spells.demonbolt, 'spells.summonDemonicTyrant.cooldown > 20'},
    --actions.build_a_shard+=/soul_strike
    {spells.soulStrike},
    --actions.build_a_shard+=/shadow_bolt
    {spells.shadowBolt},
}
kps.rotations.register("WARLOCK","DEMONOLOGY",
{
    -- Deactivate Burning Rush if not moving for 1 second
    env.deactivateBurningRushIfNotMoving(1),

    -- actions+=/use_items,if=pet.demonic_tyrant.active|target.time_to_die<=15
    {{"nested"}, 'kps.cooldowns and player.hasBuff(spells.demonicPower)', {
        { {"macro"}, "player.useTrinket(0)" , "/use 13"},
        { {"macro"}, "player.useTrinket(1)" , "/use 14"},
    }},
    -- actions+=/doom,if=!ticking&time_to_die>30&spell_targets.implosion<2
    {spells.doom, 'not target.hasMyDebuff(spells.doom) and not kps.multiTarget'},


    -- actions+=/demonic_strength,if=(buff.wild_imps.stack<6|buff.demonic_power.up)|spell_targets.implosion<2
    {spells.demonicStrength, '(player.wildImps<6 or player.hasBuff(spells.demonicPower)) or not kps.multiTarget'},

    --actions+=/call_action_list,name=nether_portal,if=talent.nether_portal.enabled&spell_targets.implosion<=2
    --{{"nested"}, 'player.hasTalent(7, 3)', {
    --}}

    --actions+=/call_action_list,name=implosion,if=spell_targets.implosion>1
    {{"nested"}, 'kps.multiTarget', {
        -- actions.implosion=implosion,if=(buff.wild_imps.stack>=6&(soul_shard<3|prev_gcd.1.call_dreadstalkers|buff.wild_imps.stack>=9|prev_gcd.1.bilescourge_bombers|(!prev_gcd.1.hand_of_guldan&!prev_gcd.2.hand_of_guldan))&!prev_gcd.1.hand_of_guldan&!prev_gcd.2.hand_of_guldan&buff.demonic_power.down)|(time_to_die<3&buff.wild_imps.stack>0)|(prev_gcd.2.call_dreadstalkers&buff.wild_imps.stack>2&!talent.demonic_calling.enabled)
        {spells.implosion, '(player.wildImps >=6 and (player.soulShards<3 or spells.callDreadstalkers.isRecastAt("target") or player.wildImps >=9 or spells.bilescourgeBombers.isRecastAt("target") or not spells.handOfGuldan.isRecastAt("target")) and not spells.handOfGuldan.isRecastAt("target") and not player.hasBuff(spells.demonicPower))'},
        -- actions.implosion+=/grimoire_felguard,if=cooldown.summon_demonic_tyrant.remains<13|!equipped.132369
        {spells.grimoireFelguard, "spells.summonDemonicTyrant.cooldown < 13"},
        --actions.implosion+=/call_dreadstalkers,if=(cooldown.summon_demonic_tyrant.remains<9&buff.demonic_calling.remains)|(cooldown.summon_demonic_tyrant.remains<11&!buff.demonic_calling.remains)|cooldown.summon_demonic_tyrant.remains>14
        {spells.callDreadstalkers, "(spells.summonDemonicTyrant.cooldown<9 and player.hasBuff(spells.demonicCalling)) or (spells.summonDemonicTyrant.cooldown<11 and not player.hasBuff(spells.demonicCalling)) or spells.summonDemonicTyrant.cooldown > 14"},
        --actions.implosion+=/summon_demonic_tyrant
        {spells.summonDemonicTyrant},
        --actions.implosion+=/hand_of_guldan,if=soul_shard>=5
        {spells.handOfGuldan, 'player.soulShards >= 5'},
        --actions.implosion+=/hand_of_guldan,if=soul_shard>=3&(((prev_gcd.2.hand_of_guldan|buff.wild_imps.stack>=3)&buff.wild_imps.stack<9)|cooldown.summon_demonic_tyrant.remains<=gcd*2|buff.demonic_power.remains>gcd*2)
        {spells.handOfGuldan, 'player.soulShards >= 3 and ((player.wildImps>=3 and player.wildImps <9) or spells.summonDemonicTyrant.cooldown<=player.gcd*2 or player.buffDuration(spells.demonicPower)>3)'},

        -- actions.implosion+=/demonbolt,if=prev_gcd.1.hand_of_guldan&soul_shard>=1&(buff.wild_imps.stack<=3|prev_gcd.3.hand_of_guldan)&soul_shard<4&buff.demonic_core.up
        {spells.demonbolt, 'spells.handOfGuldan.isRecastAt("target") and player.soulShards>=1 and player.wildImps<=3 and player.hasBuff(spells.demonicCore)'},
        --actions.implosion+=/summon_vilefiend,if=(cooldown.summon_demonic_tyrant.remains>40&spell_targets.implosion<=2)|cooldown.summon_demonic_tyrant.remains<12
        {spells.summonVilefiend, 'spells.summonDemonicTyrant.cooldown < 12'},
        -- actions.implosion+=/bilescourge_bombers,if=cooldown.summon_demonic_tyrant.remains>9
        {spells.bilescourgeBombers, 'spells.summonDemonicTyrant.cooldown > 9'},
        --actions.implosion+=/soul_strike,if=soul_shard<5&buff.demonic_core.stack<=2
        {spells.soulStrike, "player.soulShards<5 and player.buffStacks(spells.demonicCore)<=2"},
        --actions.implosion+=/demonbolt,if=soul_shard<=3&buff.demonic_core.up&(buff.demonic_core.stack>=3|buff.demonic_core.remains<=gcd*5.7)
        {spells.demonbolt, 'player.soulShards<=3 and player.hasBuff(spells.demonicCore) and (player.buffStacks(spells.demonicCore)>=3 or player.buffDuration(spells.demonicCore) <= player.gcd*5.7)'},
        --actions.implosion+=/doom,cycle_targets=1,max_cycle_targets=7,if=refreshable
        {spells.doom, 'not target.hasMyDebuff(spells.doom) and not kps.multiTarget'},
        {spells.doom, 'not focus.hasMyDebuff(spells.doom) and not kps.multiTarget', 'focus'},
        {spells.doom, 'not mouseover.hasMyDebuff(spells.doom) and not kps.multiTarget', 'mouseover'},
        -- actions.implosion+=/call_action_list,name=build_a_shard
        {{"nested"}, 'true', buildShard },
    }},

    --actions+=/grimoire_felguard,if=cooldown.summon_demonic_tyrant.remains<13|!equipped.132369
    {spells.grimoireFelguard, "spells.summonDemonicTyrant.cooldown < 13"},

    -- actions+=/summon_vilefiend,if=equipped.132369|cooldown.summon_demonic_tyrant.remains>40|cooldown.summon_demonic_tyrant.remains<12
    {spells.summonVilefiend, 'spells.summonDemonicTyrant.cooldown > 40 or spells.summonDemonicTyrant.cooldown<12'},

    -- actions+=/call_dreadstalkers,if=equipped.132369|(cooldown.summon_demonic_tyrant.remains<9&buff.demonic_calling.remains)|(cooldown.summon_demonic_tyrant.remains<11&!buff.demonic_calling.remains)|cooldown.summon_demonic_tyrant.remains>14
    {spells.callDreadstalkers, "(spells.summonDemonicTyrant.cooldown<9 and player.hasBuff(spells.demonicCalling)) or (spells.summonDemonicTyrant.cooldown<11 and not player.hasBuff(spells.demonicCalling)) or spells.summonDemonicTyrant.cooldown > 14"},

    -- actions+=/summon_demonic_tyrant,if=equipped.132369|(buff.dreadstalkers.remains>cast_time&(buff.wild_imps.stack>=3|prev_gcd.1.hand_of_guldan)&(soul_shard<3|buff.dreadstalkers.remains<gcd*2.7|buff.grimoire_felguard.remains<gcd*2.7))
    {spells.summonDemonicTyrant, 'spells.callDreadstalkers.cooldown - 8 > spells.callDreadstalkers.castTime and (player.wildImps >= 3 or spells.handOfGuldan.isRecastAt("target")) and (player.soulShards<3 or spells.callDreadstalkers.cooldown - 8 < player.gcd * 2.7)'},

    -- actions+=/power_siphon,if=buff.wild_imps.stack>=2&buff.demonic_core.stack<=2&buff.demonic_power.down&spell_targets.implosion<2
    {spells.powerSiphon, 'player.wildImps>=2 and player.buffStacks(spells.demonicCore) <=2 and not player.hasBuff(spells.demonicPower)'},
    --actions+=/doom,if=talent.doom.enabled&refreshable&time_to_die>(dot.doom.remains+30)
    {spells.doom, 'target.myDebuffDuration(spells.doom)<=30'},
    --actions+=/hand_of_guldan,if=soul_shard>=5|(soul_shard>=3&cooldown.call_dreadstalkers.remains>4&(!talent.summon_vilefiend.enabled|cooldown.summon_vilefiend.remains>3))
    {spells.handOfGuldan, 'player.soulShards >= 5 or (player.soulShards>=3 and spells.callDreadstalkers.cooldown>4 and (not player.hasTalent(4, 3) or spells.summonVilefiend.cooldown > 3))'},

    -- actions+=/soul_strike,if=soul_shard<5&buff.demonic_core.stack<=2
    {spells.soulStrike, "player.soulShards<5 and player.buffStacks(spells.demonicCore)<=2"},
    -- actions+=/demonbolt,if=soul_shard<=3&buff.demonic_core.up&((cooldown.summon_demonic_tyrant.remains<10|cooldown.summon_demonic_tyrant.remains>22)|buff.demonic_core.stack>=3|buff.demonic_core.remains<5|time_to_die<25)
    {spells.demonbolt, 'player.soulShards<=3 and player.hasBuff(spells.demonicCore) and ((spells.summonDemonicTyrant.cooldown<10 or spells.summonDemonicTyrant.cooldown>22) or player.buffStacks(spells.demonicCore) >= 3 or player.buffDuration(spells.demonicCore)<5)'},

    -- actions+=/call_action_list,name=build_a_shard
    {{"nested"}, 'true', buildShard },
}
,"SimC", {2,3,0,3,0,3,1})

