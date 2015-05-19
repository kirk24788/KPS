local Spell = kps.Spell.prototype


function Spell.charges(spell)
    return GetSpellCharges(spell.name)
end

function Spell.castTime(spell)
    name, rank, icon, castTime, minRange, maxRange = GetSpellInfo(spell.id)
    return castTime / 1000.0
end

function Spell.cooldown(spell)
    if not IsUsableSpell(spell.name) then return 999 end
    local start,duration,_ = GetSpellCooldown(spell.name)
    if start == nil or duration == nil then return 0 end
    local cd = start+duration-GetTime()
    if cd < 0 then return 0 end
    return cd
end

local isRecastAt = setmetatable({}, {
    __index = function(t, self)
        local val = function (unit)
            if unit==nil then unit = "target" end
            return kps.lastCast==self and UnitGUID(unit)==kps.lastTargetGUID
        end
        t[self] = val
        return val
    end})
function Spell.isRecastAt(self)
    return isRecastAt[self]
end


function Spell.needsSelect(self)
    if rawget(self,"_needsSelect") == nil then
        self._needsSelect = self.isOneOf(kps.spells.ae)
    end
    return self._needsSelect
end

function Spell.isBattleRez(self)
    if rawget(self,"_isBattleRez") == nil then
        self._isBattleRez = self.isOneOf(kps.spells.battlerez)
    end
    return self._isBattleRez
end


function Spell.isPrioritySpell(self)
    if rawget(spell,"_isPrioritySpell") == nil then
        self._isPrioritySpell = not self.isOneOf(kps.spells.ignore)
    end
    return self._isPrioritySpell
end




-- check if a spell is castable @ unit
local canBeCastAt = setmetatable({}, {
    __index = function(t, self)
        local val = function  (unit)
            if not self.needsSelect then
                if not kps.env[unit].exists and not self.isBattleRez then return false end
            end

            local usable, nomana = IsUsableSpell(self.name) -- usable, nomana = IsUsableSpell("spellName" or spellID)
            if not usable then return false end
            if nomana then return false end
            if (self.cooldown~=0) then return false end
            if self.hasRange and not self.inRange(unit) then return false end
            return true
        end
        t[self] = val
        return val
    end})
function Spell.canBeCastAt(self)
    return canBeCastAt[self]
end
