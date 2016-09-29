--[[
Player demons: Functions which count player demons and empowerment (demonology warlock)
]]--


local Player = kps.Player.prototype
local demonDespawnTime = {}
local demonEmpowermentTime = {}
local demonCount = 0
local lastEmpowermentCast = 0;

local loaded = false
local demonDB = {
    [55659]  = {name="Wild Imps", duration=12}, -- Wild imps from Hand of Gul'dan
    [98035]  = {name="Dreadstalker", duration=12}, -- Dreadstalkers, which is a vehicle. Imps on dreadstalkers are 99737
    [99737] = {name="Dreadstalker Imp", duration=12}, -- Dreadstalker Imps
    [103673] = {name="Darkglare", duration=12}, -- Darkglares
    [11859] = {name="Doomguard", duration=25}, -- Doomguard
    [89] = {name="Infernal", duration=25}, -- Infernal
    [416] = {name="Grimoir: Imp", duration=25}, -- Grimoir: Imp
    [1860] = {name="Grimoir: Voidwalker", duration=25}, -- Grimoir: Voidwalker
    [1863] = {name="Grimoir: Succubus", duration=25}, -- Grimoir: Succubus
    [417] = {name="Grimoir: Felhunter", duration=25}, -- Grimoir: Felhunter
    [17252] = {name="Grimoir: Felguard", duration=25}, -- Grimoir: Felguard
}

local function registerEventsIfNecessary()
    if not loaded then
        loaded = true
        kps.events.register("COMBAT_LOG_EVENT_UNFILTERED", function ( timestamp, ... )
            local currentTime = GetTime()
            local combatEvent = select(1, ...)
            local sourceGUID = select(3, ...)
            local sourceName = select(4, ...)
            local destGUID = select(7, ...)
            local destName = select(8, ...)
            local spellId = select(11, ...)
            local spellName = select(12, ...)

            -- time out any demons
            for guid, despawnTime in pairs(demonDespawnTime) do
                if despawnTime < currentTime then
                    demonDespawnTime[guid] = nil
                    demonEmpowermentTime[guid] = nil
                    demonCount = demonCount - 1
                    --print(("Demon timed out. Count: |cff00ff00%d|r"):format(demonCount))
                end
            end

            -- demon died
            if combatEvent == "UNIT_DIED" then
                for guid, despawnTime in pairs(demonDespawnTime) do
                    if destGUID == guid then
                        demonDespawnTime[guid] = nil
                        demonEmpowermentTime[guid] = nil
                        demonCount = demonCount - 1
                        --print(("Demon died. Count: |cff00ff00%d|r"):format(demonCount))
                    end
                end
            end

            -- player casts Demonic Empowerment
            if combatEvent == "SPELL_CAST_SUCCESS" and sourceGUID == UnitGUID("player") and spellId == 193396 then
                lastEmpowermentCast = currentTime
                -- empower demons
                for guid, time in pairs(demonDespawnTime) do
                    demonEmpowermentTime[guid] = currentTime
                    --print(("Empowering: |cff00ff00%s|r"):format(guid))
                end
            end

            -- Implosion
            if combatEvent == 'SPELL_INSTAKILL' and spellId == 196278 then
                for guid, despawnTime in pairs(demonDespawnTime) do
                    demonDespawnTime[guid] = nil
                    demonEmpowermentTime[guid] = nil
                end
                demonCount = 0
                --print(("Implosion. Count: |cff00ff00%d|r"):format(demonCount))
            end

            -- Summons
            if combatEvent == 'SPELL_SUMMON' and sourceGUID == UnitGUID("player") then
                local _, _, _, _, _, _, _, creatureId, _ = destGUID:find('(%S+)-(%d+)-(%d+)-(%d+)-(%d+)-(%d+)-(%S+)')
                currentDemonId = tonumber(creatureId)
                for demonId, demonData in pairs(demonDB) do
                    if demonId == currentDemonId then
                        demonDespawnTime[destGUID] = currentTime + demonData.duration
                        demonEmpowermentTime[destGUID] = 0
                        demonCount = demonCount + 1
                        --print(("%s spawned. Count: |cff00ff00%d|r"):format(demonData.name, demonCount))
                        return
                    end
                end
                --print (("Unknown Demon: |cff00ff00%d|r"):format(creatureId))
            end
        end)
    end
end


--[[[
@function `player.lastEmpowermentCast` - returns the time of the last cast of Demonic Empowerment
]]--
function Player.lastEmpowermentCast(self)
    registerEventsIfNecessary()
    return lastEmpowermentCast
end

--[[[
@function `player.demons` - returns the number of active demons
]]--
function Player.demons(self)
    registerEventsIfNecessary()
    if UnitExists("pet") then
        return demonCount + 1
    else
        return demonCount
    end
end

--[[[
@function `player.empoweredDemons` - returns the number of empowered demons
]]--
function Player.empoweredDemons(self)
    registerEventsIfNecessary()
    local count = 0
    for guid, empoweredTime in pairs(demonEmpowermentTime) do
        if demonEmpowermentTime[guid] ~= nil and demonEmpowermentTime[guid]+10 > GetTime() then
            count = count + 1
        end
    end
    if UnitExists("pet") and UnitBuff("pet", kps.spells.warlock.demonicEmpowerment.name) ~= nil then
        return count + 1
    else
        return count
    end
end
