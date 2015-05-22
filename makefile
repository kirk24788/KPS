.PHONY: all

# ALL
all: toc global_spells rotations


# Table Of Contents
toc:
	./utils/generateTOC.py > kps.toc


# Rotations Directory (Spells & SimC Profiles)
rotations: class_spells class_rotations

# Global Spells
global_spells:
	./utils/printGlobalSpells.py > modules/spell/spells.lua

# Rotation Spells for each class
class_spells: deathknight_spells druid_spells hunter_spells mage_spells monk_spells paladin_spells priest_spells rogue_spells shaman_spells warlock_spells warrior_spells
%_spells: rotations/%.lua
	./utils/printClassSpells.py -c $(subst _spells,,$@) -o $<


# Rotations for each class
class_rotations: deathknight_rotations druid_rotations hunter_rotations mage_rotations monk_rotations paladin_rotations priest_rotations rogue_rotations shaman_rotations warlock_rotations warrior_rotations

deathknight_rotations: deathknight_blood_rotation deathknight_frost_rotation deathknight_unholy_rotation
deathknight_blood_rotation:
	./utils/convertSimC.py -p simc/deathknight_blood.simc -c deathknight -s blood -o rotations/deathknight_blood.lua
deathknight_frost_rotation:
	./utils/convertSimC.py -p simc/deathknight_frost_1h.simc -c deathknight -s frost -o rotations/deathknight_frost.lua
	./utils/convertSimC.py -p simc/deathknight_frost_2h.simc -c deathknight -s frost -a rotations/deathknight_frost.lua
deathknight_unholy_rotation:
	./utils/convertSimC.py -p simc/deathknight_unholy.simc -c deathknight -s unholy -o rotations/deathknight_unholy.lua

druid_rotations: druid_balance_rotation druid_feral_rotation druid_guardian_rotation
druid_balance_rotation:
	./utils/convertSimC.py -p simc/druid_balance.simc -c druid -s balance -o rotations/druid_balance.lua
druid_feral_rotation:
	./utils/convertSimC.py -p simc/druid_feral.simc -c druid -s feral -o rotations/druid_feral.lua
druid_guardian_rotation:
	./utils/convertSimC.py -p simc/druid_guardian.simc -c druid -s guardian -o rotations/druid_guardian.lua

hunter_rotations: hunter_beastmaster_rotation hunter_marksmanship_rotation hunter_survival_rotation
hunter_beastmaster_rotation:
	./utils/convertSimC.py -p simc/hunter_beastmaster.simc -c hunter -s beastmaster -o rotations/hunter_beastmaster.lua
hunter_marksmanship_rotation:
	./utils/convertSimC.py -p simc/hunter_marksmanship.simc -c hunter -s marksmanship -o rotations/hunter_marksmanship.lua
hunter_survival_rotation:
	./utils/convertSimC.py -p simc/hunter_survival.simc -c hunter -s survival -o rotations/hunter_survival.lua

mage_rotations: mage_arcane_rotation mage_fire_rotation mage_frost_rotation
mage_arcane_rotation:
	./utils/convertSimC.py -p simc/mage_arcane.simc -c mage -s arcane -o rotations/mage_arcane.lua
mage_fire_rotation:
	./utils/convertSimC.py -p simc/mage_fire.simc -c mage -s fire -o rotations/mage_fire.lua
mage_frost_rotation:
	./utils/convertSimC.py -p simc/mage_frost.simc -c mage -s frost -o rotations/mage_frost.lua

monk_rotations: monk_brewmaster_rotation monk_windwalker_rotation
monk_brewmaster_rotation:
	./utils/convertSimC.py -p simc/monk_brewmaster_1h.simc -c monk -s brewmaster -o rotations/monk_brewmaster.lua
	./utils/convertSimC.py -p simc/monk_brewmaster_2h.simc -c monk -s brewmaster -a rotations/monk_brewmaster.lua
monk_windwalker_rotation:
	./utils/convertSimC.py -p simc/monk_windwalker_1h.simc -c monk -s windwalker -o rotations/monk_windwalker.lua
	./utils/convertSimC.py -p simc/monk_windwalker_2h.simc -c monk -s windwalker -a rotations/monk_windwalker.lua

paladin_rotations: paladin_protection_rotation paladin_retribution_rotation
paladin_protection_rotation:
	./utils/convertSimC.py -p simc/paladin_protection.simc -c paladin -s protection -o rotations/paladin_protection.lua
paladin_retribution_rotation:
	./utils/convertSimC.py -p simc/paladin_retribution.simc -c paladin -s retribution -o rotations/paladin_retribution.lua

priest_rotations: priest_discipline_rotation priest_discipline_rotation priest_shadow_rotation
priest_discipline_rotation:
	./utils/convertSimC.py -p simc/priest_discipline_dmg.simc -c priest -s discipline -o rotations/priest_discipline.lua
priest_holy_rotation:
	./utils/convertSimC.py -p simc/priest_holy_dmg.simc -c priest -s holy -o rotations/priest_holy.lua
priest_shadow_rotation:
	./utils/convertSimC.py -p simc/priest_shadow.simc -c priest -s shadow -o rotations/priest_shadow.lua

rogue_rotations: rogue_assassination_rotation rogue_combat_rotation rogue_subtlety_rotation
rogue_assassination_rotation:
	./utils/convertSimC.py -p simc/rogue_assassination.simc -c rogue -s assassination -o rotations/rogue_assassination.lua
rogue_combat_rotation:
	./utils/convertSimC.py -p simc/rogue_combat.simc -c rogue -s combat -o rotations/rogue_combat.lua
rogue_subtlety_rotation:
	./utils/convertSimC.py -p simc/rogue_subtlety.simc -c rogue -s subtlety -o rotations/rogue_subtlety.lua

shaman_rotations:

warlock_rotations:

warrior_rotations:

