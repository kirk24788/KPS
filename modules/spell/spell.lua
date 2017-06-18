--[[[
@module Spell Class
Provides access to specific spell information and provide an localization-independant access to WoW spells.

Assuming you want to cast `mySpell`, then `<SPELL>` may be one of:

 * `spells.mySpell`: If you are in a rotation *condition* - you can also use this short notation within your rotation spells, if you have previously defined spells like so (which is by default the first line in every class rotation):
   ```
      local spells = kps.spells.warlock
   ```
 * `kps.spells.warlock.mySpell`: This is the fully qualified spell, you can always use this if you're unsure or if you want to access other classes spells
]]--


kps.Spell = {}
kps.Spell.prototype = {}
kps.Spell.metatable = {}

local GetUnitName = GetUnitName

local castAt = setmetatable({}, {
    __index = function(t, self)
        local val = function (target,message)
            if target == nil then target = "target" end

            if self.needsSelect then
                SetCVar("deselectOnClick", "0")
                CastSpellByName(self.name)
                CameraOrSelectOrMoveStart(1)
                CameraOrSelectOrMoveStop(1)
                SetCVar("deselectOnClick", "1")
            else
                CastSpellByName(self.name,target)
            end

            if kps.debug then print(self.name,"|cff1eff00","|",GetUnitName(target),"|cffffffff|",target,"|cffa335ee",message) end
            kps.gui.updateSpellTexture(self)

            local _, gcd = GetSpellCooldown(61304) -- Global Cooldown Spell
            kps.gcd = gcd
            kps.lastCast = self
            kps.lastTargetGUID = UnitGUID(target)
            kps.lastTarget = target
            self.lastCast = GetTime()
        end
        t[self] = val
        return val
    end})
function kps.Spell.prototype.cast(self)
    return castAt[self]
end



local isOneOf = setmetatable({}, {
    __index = function(t, self)
        local val = function (spellList)
            for _,otherSpell in pairs(spellList) do
                if otherSpell.id==self.id then
                    return true
                end
            end
            return false
        end
        t[self] = val
        return val
    end})
function kps.Spell.prototype.isOneOf(self)
    return isOneOf[self]
end



function kps.Spell.prototype.icon(self)
    return GetSpellTexture(self.id)
end

local spellCache = {}
function kps.Spell.fromId(spellId)
    if spellCache[spellId] == nil then
        local inst = {}
        inst.id = spellId
        local spellname = select(1,GetSpellInfo(spellId))
        if spellname == nil then spellname = "Unknown Spell-ID:"..spellId end
        inst.name = tostring(spellname)
        inst.lastCast = 0
        setmetatable(inst, kps.Spell.metatable)
        spellCache[spellId] = inst
    end
    return spellCache[spellId]
end

kps.Spell.metatable.__index = function (table, key)
    local fn = kps.Spell.prototype[key]
    if fn == nil then
        error("Unknown Spell-Property '" .. key .. "'!")
    end
    return fn(table)
end
kps.Spell.metatable.__tostring = function (table)
    return table.name
end
kps.Spell.metatable.__concat = function (lhs, rhs)
    return tostring(lhs) .. tostring(rhs)
end
