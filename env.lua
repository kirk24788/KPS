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

--TODO: Clean UP!!! This code is a mess...


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
        kps.spells.druid
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
        kps.env.druid
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




local harmSpells = {}
local function getHarmfulSpell()
    local HarmSpell = nil
    local HarmSpell40 = {}
    local HarmSpell30 = {}
    local HarmSpell20 = {}
    local _, _, offset, numSpells, _ = GetSpellTabInfo(2)
    local booktype = "spell"
    for index = offset+1, numSpells+offset do
        -- Get the Global Spell ID from the Player's spellbook
        -- local spellname,rank,icon,cost,isFunnel,powerType,castTime,minRange,maxRange = GetSpellInfo(spellID)
        local name = select(1,GetSpellBookItemName(index, booktype))
        local spellID = select(2,GetSpellBookItemInfo(index, booktype))
        local maxRange = select(6,GetSpellInfo(spellID))
        local minRange = select(5,GetSpellInfo(spellID))
        local harmful = IsHarmfulSpell(index, booktype)
        if minRange ~= nil and maxRange ~= nil and harmful ~= nil then
            if (maxRange > 39) and (harmful == true) and (minRange == 0) then
                table.insert(HarmSpell40,name)
            elseif (maxRange > 29) and (harmful == true) and (minRange == 0) then
                table.insert(HarmSpell30,name)
            elseif (maxRange > 19) and (harmful == true) and (minRange == 0) then
                table.insert(HarmSpell20,name)
            end
        end
    end
    if HarmSpell40[1] then
        HarmSpell = HarmSpell40[1]
    elseif HarmSpell30[1] then
        HarmSpell = HarmSpell30[1]
    else
        HarmSpell = HarmSpell20[1]
    end
    if HarmSpell ~= nil then
        harmSpells[HarmSpell] = true
        return kps.Spell.fromId(HarmSpell)
    else
        return kps.Spell.fromId(0)
    end
end
kps.env.harmSpell = getHarmfulSpell()
