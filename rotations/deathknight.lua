--[[[
@module Deathknight Environment Functions and Variables
@description
Deathknight Environment Functions and Variables.
]]--

kps.env.deathknight = {}

function kps.env.deathknight.diseaseMinRemains(unit)
    minTimeLeft = min(unit.myDebuffDuration(kps.spells.deathknight.bloodPlague),
                      unit.myDebuffDuration(kps.spells.deathknight.frostFever))
    if kps.env.player.hasTalent(7, 1) then -- Necrotic Plague Talent
        return min(minTimeLeft, unit.myDebuffDuration(kps.spells.deathknight.necroticPlague))
    else
        return minTimeLeft
    end
end

function kps.env.deathknight.diseaseMaxRemains(unit)
    maxTimeLeft = max(unit.myDebuffDuration(kps.spells.deathknight.bloodPlague),
                      unit.myDebuffDuration(kps.spells.deathknight.frostFever))
    if kps.env.player.hasTalent(7, 1) then -- Necrotic Plague Talent
        return max(maxTimeLeft, unit.myDebuffDuration(kps.spells.deathknight.necroticPlague))
    else
        return maxTimeLeft
    end
end

function kps.env.deathknight.diseaseTicking(unit)
    return kps.env.deathknight.diseaseMinRemains(unit) > 0
end

function kps.env.deathknight.diseaseMaxTicking(unit)
    return kps.env.deathknight.diseaseMaxRemains(unit) > 0
end
