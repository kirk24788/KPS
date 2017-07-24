#!/usr/bin/env python
from spells import GlobalSpells

# **********************************************************************
# * Creates Global Spell List and checks if those spells are still valid
# **********************************************************************

spells = GlobalSpells()

# Nagrand Combat Mounts
spells.group("mount","Nagrand Combat Mounts")
spells.mount.add_all_spells([164222,165803])

# CC
spells.group("cc","Crowd Control Spells")
## Priest
spells.cc.add_spell(605) # Mind Control
## Druid
spells.cc.add_spell(339) # Entangling Roots
spells.cc.add_spell(33786) # Cyclone
## Hunter
spells.cc.add_spell(13809) # FrosSnake Trapt Trap
## Mage
spells.cc.add_spell(118) # Polymorph
spells.cc.add_spell(61305, "BlackCat") # Polymorph: Black Cat
spells.cc.add_spell(28272, "Pig") # Polymorph: Pig
spells.cc.add_spell(61721, "Rabbit") # Polymorph: Rabbit
spells.cc.add_spell(61780, "Turkey") # Polymorph: Turkey
spells.cc.add_spell(28271, "Turtle") # Polymorph: Turtle
## Warlock
spells.cc.add_spell(5782) # Polymorph: Turkey
spells.cc.add_spell(5484) # Polymorph: Turtle
## Shaman
spells.cc.add_spell(51514) #  Hex

# Draenic Flasks
spells.group("flask","Greater Draenic Flasks")
spells.flask.add_all_spells([156064,156079,156572,156576])

# Draenic Potions
spells.group("potion","Draenic Potions")
spells.potion.add_all_spells([156426,156577,156428])

# Polymorph Spells
spells.group("poly","Polymorph Spells")
spells.poly.add_spell(118) # Polymorph
spells.poly.add_spell(61305, "BlackCat") # Polymorph: Black Cat
spells.poly.add_spell(28272, "Pig") # Polymorph: Pig
spells.poly.add_spell(61721, "Rabbit") # Polymorph: Rabbit
spells.poly.add_spell(61780, "Turkey") # Polymorph: Turkey
spells.poly.add_spell(28271, "Turtle") # Polymorph: Turtle
spells.poly.add_spell(51514) # Hex

# Spells which require a select (cast ond ground) - usually AE Spells
spells.group("ae","Spells which require a select (cast ond ground) - usually AE Spells")
spells.ae.add_all_spells([109248,30283,34861,32375,43265,62618,2120,114158, 115313, 6544, 33395, 116011, 115315, 152108,61882])
spells.ae.add_spell(5740,"Channeled") # Rain of Fire (Channeled)
spells.ae.add_spell(73920) # Healing Rain
spells.ae.add_spell(13813) # Explosive Trap
spells.ae.add_spell(13809) # Ice Trap
spells.ae.add_spell(152280) # Defile
spells.ae.add_spell(187827) # Metamorphosis
spells.ae.add_spell(191034) # Starfall
spells.ae.add_spell(145205) # Efflorescence

# User-Priorized Spells to ignore
spells.group("ignore","User-Priorized Spells to ignore")
spells.ignore.add_spell(6603, comment="Auto Attack (prevents from toggling on/off)")
spells.ignore.add_spell(109132, comment="Roll (Unless you want to roll off cliffs, leave this here)")
spells.ignore.add_spell(137639, comment="Storm, Earth, and Fire (prevents you from destroying your copy as soon as you make it)")
spells.ignore.add_spell(115450, comment="Detox (when casting Detox without any dispellable debuffs, the cooldown resets)")
spells.ignore.add_spell(119582, comment="Purifying Brew (having more than 1 chi, this can prevent using it twice in a row)")
spells.ignore.add_spell(115008, comment="Chi Torpedo (same as roll)")
spells.ignore.add_spell(101545, comment="Flying Serpent Kick (prevents you from landing as soon as you start 'flying')")
spells.ignore.add_spell(115072, comment="Expel Harm (below 35%, brewmasters ignores cooldown on this spell)")
spells.ignore.add_spell(115181, comment="Breath of Fire (if you are chi capped, this can make you burn all your chi)")
spells.ignore.add_spell(115546, comment="Provoke (prevents you from wasting your taunt)")
spells.ignore.add_spell(116740, comment="Tigereye Brew (prevents you from wasting your stacks and resetting your buff)")
spells.ignore.add_spell(111400, comment="warlock burning rush")
spells.ignore.add_spell(12051, comment="Evocation")
spells.ignore.add_spell(1953, comment="Blink")
spells.ignore.add_spell(19263, comment="Deterrence")
spells.ignore.add_spell(781, comment="Disengage")
spells.ignore.add_spell(108839, comment="Ice Floes")

spells.group("battlerez","Battle Rez")
spells.battlerez.add_all_spells([20484, 61999, 20707, 126393])

spells.group("bloodlust","Bloodlust")
spells.bloodlust.add_all_spells([2825, 32182, 80353, 90355, 146555])

print(spells)
