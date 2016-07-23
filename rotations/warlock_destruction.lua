--[[[
@module Warlock Destruction Rotation
@author Kirk24788
@version 7.0.3
]]--

local spells = kps.spells.warlock
local env = kps.env.warlock


--kps.runOnClass("WARLOCK", function ( )
--    kps.gui.createToggle("conserve", "Interface\\Icons\\spell_Mage_Flameorb", "Conserve")
--end)

kps.rotations.register("WARLOCK","DESTRUCTION",
{
    -- Deactivate Burning Rush if not moving for 1 second
    env.deactivateBurningRushIfNotMoving(1),

    -- Apply  Havoc if a secondary target is present.
    {spells.havoc, 'isHavocUnit("mouseover") and keys.ctrl', "mouseover" },
    {spells.havoc, 'isHavocUnit("focus") and focus.isAttackable', "focus"  },

    -- Maintain Immolate on your main target(s).
    {spells.immolate, 'focus.myDebuffDuration(spells.immolate) <= 1.0 and not spells.immolate.isRecastAt("focus")', "focus"},
    {spells.immolate, 'target.myDebuffDuration(spells.immolate) <= 1.0 and not spells.immolate.isRecastAt("target")'},

    -- Cast Conflagrate  immediately following a fresh application of Immolate.
    {spells.conflagrate, 'spells.immolate.isRecastAt("target")'},

    -- Cast Chaos Bolt if you have 5 Soul Shards.
    {spells.chaosBolt, 'player.soulShards >= 5'},

    -- Cast Shadowburn (if talented) if the target will die within 5 seconds.
    -- Has to be done manually - and probably isn't selected anyways

    -- Cast Summon Doomguard on cooldown.
    {spells.summonDoomguard, 'kps.cooldowns'},

    -- Cast Grimoire: Imp on cooldown.
    {spells.grimoireImp, 'kps.cooldowns'},

    -- Cast Rain of Fire on large groups of stacked targets.
    {spells.rainOfFire, 'keys.shift and player.soulShards >=3 and player.buffDuration(spells.rainOfFire) < 1.5 and player.isMoving' },
    {spells.rainOfFire, 'keys.shift and player.soulShards >=3 and player.buffDuration(spells.rainOfFire) < 1.5 and activeEnemies.count >= 3' },
    {spells.rainOfFire, 'keys.shift and player.soulShards >=3 and keys.ctrl' },

    -- Cast Conflagrate to generate Soul Shards.
    {spells.conflagrate},

    -- Cast Chaos Bolt to maintain Eradication Icon Eradication.
    {spells.chaosBolt, 'player.soulShards >= 2 and not target.debuffDuration(spells.eradication) <= 0.0'},

    -- Cast Conflagrate to generate Soul Shards.
    {spells.incinerate},
}
,"Destruction 7.0.3")
