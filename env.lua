--[[[
@module Environment
@description
KPS Environment for use in Spell Rotations
]]--

kps.env.player = kps.Player.new()
kps.env.keys = kps.Keys.new()
kps.env.target = kps.Unit.new("target")
kps.env.targettarget = kps.Unit.new("targettarget")
kps.env.pet = kps.Unit.new("pet")
kps.env.focus = kps.Unit.new("focus")
kps.env.focustarget = kps.Unit.new("focustarget")
kps.env.mouseover = kps.Unit.new("mouseover")
kps.env.boss1 = kps.Unit.new("boss1")
kps.env.boss2 = kps.Unit.new("boss2")
kps.env.boss3 = kps.Unit.new("boss3")
kps.env.boss4 = kps.Unit.new("boss4")

kps.env.activeEnemies = kps.BasicActiveEnemies.new()

kps.events.registerOnUpdate(function()
    if kps.enabled then
        kps.combatStep()
    end
end)

function kps.env.min(a,b)
    if a < b then
        return a
    end
    return b
end
function kps.env.max(a,b)
    if a < b then
        return b
    end
    return a
end

local function getPlayerSpells()
    local playerSpells = {
        kps.spells.warrior,
        kps.spells.paladin,
        kps.spells.hunter,
        kps.spells.rogue,
        kps.spells.priest,
        kps.spells.deathknight,
        kps.spells.shaman,
        kps.spells.mage,
        kps.spells.warlock,
        kps.spells.monk,
        kps.spells.druid,
        kps.spells.demonhunter
    }
    _,_,classId = UnitClass("player")
    return playerSpells[classId]
end

local spellsMeta = {}
setmetatable(kps.env.spells, spellsMeta)
local playerSpells = getPlayerSpells()
spellsMeta.__index = function (table, key)
    if playerSpells[key] ~= nil then return playerSpells[key] end
    return kps.spells[key]
end


local function getClassEnv()
    local playerEnvs = {
        kps.env.warrior,
        kps.env.paladin,
        kps.env.hunter,
        kps.env.rogue,
        kps.env.priest,
        kps.env.deathknight,
        kps.env.shaman,
        kps.env.mage,
        kps.env.warlock,
        kps.env.monk,
        kps.env.druid,
        kps.env.demonhunter
    }
    _,_,classId = UnitClass("player")
    return playerEnvs[classId]
end

local envMeta = {}
setmetatable(kps.env, envMeta)
local classEnvs = getClassEnv()
envMeta.__index = function (table, key)
    if classEnvs[key] ~= nil then return classEnvs[key] end
    return _G[key]
end

local toSpellName = function(spell)
    local spellname = nil
    if type(spell) == "string" then spellname = spell
    elseif type(spell) == "number" then spellname = GetSpellInfo(spell) end
    return spellname
end

local function IsSpellKnown(spell)
    local name, texture, offset, numSpells, isGuild = GetSpellTabInfo(2)
    local mySpell = nil
    local spellname = toSpellName(spell)
    for index = offset+1, numSpells+offset do
        -- Get the Global Spell ID from the Player's spellbook
        local spellID = select(2,GetSpellBookItemInfo(index, "spell"))
        local slotType = select(1,GetSpellBookItemInfo(index, "spell"))
        local name = select(1,GetSpellBookItemName(index, "spell"))
        if spellname == name and slotType ~= "FUTURESPELL" then
            mySpell = spellname
            break -- Breaking out of the for/do loop, because we have a match
        end
    end
    if mySpell == nil then return false end
    return true
end

local HarmSpell = nil
local function getHarmfulSpell()
    local _, _, offset, numSpells, _ = GetSpellTabInfo(2)
    local harmdist = 0
    for index = offset+1, numSpells+offset do
        -- Get the Global Spell ID from the Player's spellbook
        local spell = select(1,GetSpellBookItemName(index, "spell"))
        local spellID = select(2,GetSpellBookItemInfo(index, "spell"))
        local minRange = select(5,GetSpellInfo(spellID))
        if minRange == nil then minRange = 8 end
        local maxRange = select(6,GetSpellInfo(spellID))
        if maxRange == nil then maxRange = 0 end
        local harmful = IsHarmfulSpell(spell)
        if harmful and maxRange > 0 and minRange == 0 and IsSpellKnown(spellID) then
            if maxRange > harmdist then
                harmdist = maxRange
                HarmSpell = spell
            end
        end
    end 
    if HarmSpell ~= nil then
        return kps.Spell.fromId(HarmSpell)
    else
        return kps.Spell.fromId(0)
    end
end
kps.env.harmSpell = getHarmfulSpell()
