--[[[
@module Rotation Registry
@description
Rotations are stored in a central registry - each class/spec combination can have multiple Rotations.
Most of the rotations are registered on load, but you can also (un)register Rotations during runtime.
You could even outsource your rotations to a separate addon if you want to.
]]--

kps.classes = {}

local classNames = { "WARRIOR", "PALADIN", "HUNTER", "ROGUE", "PRIEST", "DEATHKNIGHT", "SHAMAN", "MAGE", "WARLOCK", "MONK", "DRUID", "DEMONHUNTER" }

local specNames = {}
specNames[1] = {"ARMS","FURY","PROTECTION"}
specNames[2] = {"HOLY","PROTECTION","RETRIBUTION"}
specNames[3] = {"BEASTMASTERY","MARKSMANSHIP","SURVIVAL"}
specNames[4] = {"ASSASSINATION","OUTLAW","SUBTLETY"}
specNames[5] = {"DISCIPLINE","HOLY","SHADOW"}
specNames[6] = {"BLOOD","FROST","UNHOLY"}
specNames[7] = {"ELEMENTAL","ENHANCEMENT","RESTORATION"}
specNames[8] = {"ARCANE","FIRE","FROST"}
specNames[9] = {"AFFLICTION","DEMONOLOGY","DESTRUCTION"}
specNames[10] = {"BREWMASTER","MISTWEAVER","WINDWALKER"}
specNames[11] = {"BALANCE","FERAL","GUARDIAN","RESTORATION"}
specNames[12] = {"HAVOC","VENGEANCE"}

local function classToNumber(class)
    if type(class) == "string" then
        className = string.upper(class)
        for k, v in ipairs(classNames) do
            if v == className then return k end
        end
    elseif type(class) == "number" then
        if classNames[class] then return class end
    end
    return nil
end

local function specToNumber(classId, spec)
    if not specNames[classId] then return nil end
    if type(spec) == "string" then
        specName = string.upper(spec)
        for k, v in ipairs(specNames[classId]) do
            if v == specName then return k end
        end
    elseif type(spec) == "number" then
        if specNames[classId][spec] then return class end
    end
    return nil
end

function kps.classes.toKey(class, spec)
    local classId = classToNumber(class)
    if not classId then return 0 end
    local specId = specToNumber(classId, spec)
    if not specId then return 0 end
    if classId < 1 or classId > 12 then return 0 end
    if classId < 11 and specId > 3 then return 0 end
    if classId == 11 and specId > 4 then return 0 end
    if classId == 12 and specId > 2 then return 0 end
    return classId * 10 + specId
end


function kps.classes.getCurrentKey()
    _,_,classId = UnitClass("player")
    specId = GetSpecialization() or 0
    return classId * 10 + specId
end

function kps.classes.isPlayerClass(class)
    _,_,classId = UnitClass("player")
    return classToNumber(class) == classId
end
