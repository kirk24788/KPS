.PHONY: all

# ALL
all: toc global_spells rotations


# Table Of Contents
toc:
	./utils/generateTOC.py > kps.toc


# Rotations Directory (Spells & SimC Profiles)
rotations: rotation_spells class_rotations

# Global Spells
global_spells:
	./utils/printGlobalSpells.py > modules/spell/spells.lua

# Rotation Spells for each class
rotation_spells: deathknight_class_spells druid_class_spells hunter_class_spells mage_class_spells monk_class_spells paladin_class_spells priest_class_spells rogue_class_spells shaman_class_spells warlock_class_spells warrior_class_spells
%_class_spells: rotations/%.lua
	./utils/printClassSpells.py -c $(subst _class_spells,,$@) -o $<


# Rotations for each class
class_rotations: deathknight_class_rotations druid_class_rotations hunter_class_rotations mage_class_rotations monk_class_rotations paladin_class_rotations priest_class_rotations rogue_class_rotations shaman_class_rotations warlock_class_rotations warrior_class_rotations

deathknight_class_rotations: rotations/deathknight_blood.lua rotations/deathknight_frost.lua rotations/deathknight_unholy.lua
rotations/deathknight_blood.lua: FORCE
	./utils/convertSimC.py -p simc/deathknight_blood.simc -c deathknight -s blood -o rotations/deathknight_blood.lua
rotations/deathknight_frost.lua: FORCE
	./utils/convertSimC.py -p simc/deathknight_frost_1h.simc -c deathknight -s frost -o rotations/deathknight_frost.lua
	./utils/convertSimC.py -p simc/deathknight_frost_2h.simc -c deathknight -s frost -a rotations/deathknight_frost.lua
rotations/deathknight_unholy.lua: FORCE
	./utils/convertSimC.py -p simc/deathknight_unholy.simc -c deathknight -s unholy -o rotations/deathknight_unholy.lua

druid_class_rotations: rotations/druid_balance.lua rotations/druid_feral.lua rotations/druid_guardian.lua
rotations/druid_balance.lua: FORCE
	./utils/convertSimC.py -p simc/druid_balance.simc -c druid -s balance -o rotations/druid_balance.lua
rotations/druid_feral.lua: FORCE
	./utils/convertSimC.py -p simc/druid_feral.simc -c druid -s feral -o rotations/druid_feral.lua
rotations/druid_guardian.lua: FORCE
	./utils/convertSimC.py -p simc/druid_guardian.simc -c druid -s guardian -o rotations/druid_guardian.lua

hunter_class_rotations: rotations/hunter_beastmaster.lua rotations/hunter_marksmanship.lua rotations/hunter_survival.lua
rotations/hunter_beastmaster.lua: FORCE
	./utils/convertSimC.py -p simc/hunter_beastmaster.simc -c hunter -s beastmaster -o rotations/hunter_beastmaster.lua
rotations/hunter_marksmanship.lua: FORCE
	./utils/convertSimC.py -p simc/hunter_marksmanship.simc -c hunter -s marksmanship -o rotations/hunter_marksmanship.lua
rotations/hunter_survival.lua: FORCE
	./utils/convertSimC.py -p simc/hunter_survival.simc -c hunter -s survival -o rotations/hunter_survival.lua

mage_class_rotations: rotations/mage_arcane.lua rotations/mage_fire.lua rotations/mage_frost.lua
rotations/mage_arcane.lua: FORCE
	./utils/convertSimC.py -p simc/mage_arcane.simc -c mage -s arcane -o rotations/mage_arcane.lua
rotations/mage_fire.lua: FORCE
	./utils/convertSimC.py -p simc/mage_fire.simc -c mage -s fire -o rotations/mage_fire.lua
rotations/mage_frost.lua: FORCE
	./utils/convertSimC.py -p simc/mage_frost.simc -c mage -s frost -o rotations/mage_frost.lua

monk_class_rotations: rotations/monk_brewmaster.lua rotations/monk_windwalker.lua
rotations/monk_brewmaster.lua: FORCE
	./utils/convertSimC.py -p simc/monk_brewmaster_1h.simc -c monk -s brewmaster -o rotations/monk_brewmaster.lua
	./utils/convertSimC.py -p simc/monk_brewmaster_2h.simc -c monk -s brewmaster -a rotations/monk_brewmaster.lua
rotations/monk_windwalker.lua: FORCE
	./utils/convertSimC.py -p simc/monk_windwalker_1h.simc -c monk -s windwalker -o rotations/monk_windwalker.lua
	./utils/convertSimC.py -p simc/monk_windwalker_2h.simc -c monk -s windwalker -a rotations/monk_windwalker.lua

paladin_class_rotations: rotations/paladin_protection.lua rotations/paladin_retribution.lua
rotations/paladin_protection.lua: FORCE
	./utils/convertSimC.py -p simc/paladin_protection.simc -c paladin -s protection -o rotations/paladin_protection.lua
rotations/paladin_retribution.lua: FORCE
	./utils/convertSimC.py -p simc/paladin_retribution.simc -c paladin -s retribution -o rotations/paladin_retribution.lua

priest_class_rotations:

rogue_class_rotations:

shaman_class_rotations:

warlock_class_rotations:

warrior_class_rotations:

FORCE:
