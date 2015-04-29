--[[[
@module Deathknight
@description
Deathknight Spells and Environment Functions.
]]--


kps.spells.deathknight = {}

kps.spells.deathknight.conversion = kps.Spell.fromId(119975)
kps.spells.deathknight.antimagicShell = kps.Spell.fromId(48707)
kps.spells.deathknight.lichborne = kps.Spell.fromId(49039)
kps.spells.deathknight.deathStrike = kps.Spell.fromId(49998)
kps.spells.deathknight.armyOfTheDead = kps.Spell.fromId(42650)
kps.spells.deathknight.boneShield = kps.Spell.fromId(49222)
kps.spells.deathknight.vampiricBlood = kps.Spell.fromId(55233)
kps.spells.deathknight.iceboundFortitude = kps.Spell.fromId(48792)
kps.spells.deathknight.runeTap = kps.Spell.fromId(48982)
kps.spells.deathknight.dancingRuneWeapon = kps.Spell.fromId(49028)
kps.spells.deathknight.deathPact = kps.Spell.fromId(48743)
kps.spells.deathknight.outbreak = kps.Spell.fromId(77575)
kps.spells.deathknight.deathCoil = kps.Spell.fromId(47541)
kps.spells.deathknight.plagueStrike = kps.Spell.fromId(45462)
kps.spells.deathknight.icyTouch = kps.Spell.fromId(45477)
kps.spells.deathknight.defile = kps.Spell.fromId(152280)
kps.spells.deathknight.plagueLeech = kps.Spell.fromId(123693)
kps.spells.deathknight.bloodTap = kps.Spell.fromId(45529)
kps.spells.deathknight.soulReaper = kps.Spell.fromId(114866)
kps.spells.deathknight.bloodBoil = kps.Spell.fromId(50842)
kps.spells.deathknight.deathAndDecay = kps.Spell.fromId(43265)
kps.spells.deathknight.empowerRuneWeapon = kps.Spell.fromId(47568)
kps.spells.deathknight.crimsonScourge = kps.Spell.fromId(81136)
kps.spells.deathknight.bloodCharge = kps.Spell.fromId(114851)
kps.spells.deathknight.frostFever = kps.Spell.fromId(55095)
kps.spells.deathknight.necroticPlague = kps.Spell.fromId(155165)
kps.spells.deathknight.bloodPlague = kps.Spell.fromId(55078)



kps.env.deathknight = {}

function kps.env.deathknight.diseaseMinRemains(unit)
    minTimeLeft = min(unit.myDebuffDuration(kps.spells.deathknight.bloodPlague),
                      unit.myDebuffDuration(kps.spells.deathknight.frostFever))
    if player.hasTalent(7, 1) then -- Necrotic Plague Talent
        return min(minTimeLeft, unit.myDebuffDuration(kps.spells.deathknight.necroticPlague))
    else
        return minTimeLeft
    end
end
function kps.env.deathknight.diseaseTicking(unit)
    return kps.env.deathknight.diseaseMinRemains(unit) > 0
end


