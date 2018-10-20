--[[
@module Functions: Wild Imps
@description
Wild Imp Counter
]]--
local Player = kps.Player.prototype

local playerGUID
local impTime, impCast = {}, {}
local impCount = 0
local moduleLoaded = false
local wildImpCasts = 5

local function updateWildImps( ... )
    local compTime = GetTime()
    local _, combatEvent, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, arg12, arg13, arg14, arg15 = CombatLogGetCurrentEventInfo()

    -- time out any imps
    for index, value in pairs(impTime) do
        if (value + 25) < compTime then
            impTime[index] = nil
            impCount = impCount - 1

            print(("Imp timed out. Count: |cff00ff00%d|r"):format(impCount))
        end
    end

    -- imp died
    if combatEvent == "UNIT_DIED" then
        for index, value in pairs(impTime) do
            if destGUID == index then
                impTime[index] = nil
                impCast[index] = nil
                impCount = impCount - 1

                print(("Imp died. Count: |cff00ff00%d|r"):format(impCount))
            end
        end
    end

    -- imp died from casting
    if combatEvent == "SPELL_CAST_SUCCESS" and sourceName == "Wild Imp" then
        for index,  value in pairs(impCast) do
            if sourceGUID == index then
                -- remove cast
                impCast[index] = impCast[index] - 1

                -- wild imp has casted n times so it dies
                if impCast[index] == 0 then
                    impCast[index] = nil
                    impTime[index] = nil
                    impCount = impCount - 1

                    print(("Imp casted n times and died. Count: |cff00ff00%d|r"):format(impCount))
                end
            end
        end
    end

    -- sacrifice all @ implosion

    if combatEvent == "SPELL_CAST_SUCCESS" and sourceGUID == playerGUID then
        if  arg12 == 196277 then
            for index, value in pairs(impTime) do
                impTime[index] = nil
                impCount = impCount - 1
                print(("Imp imploded. Count: |cff00ff00%d|r"):format(impCount))
            end
            impCount = 0
        end
    end

    -- imp summoned
    if combatEvent == "SPELL_SUMMON" and destName == "Wild Imp" and sourceGUID == playerGUID then

        impTime[destGUID] = compTime
        impCast[destGUID] = wildImpCasts  -- each imp has  casts
        impCount = impCount + 1

        print(("Imp spawned. Count: |cff00ff00%d|r"):format(impCount))
    end

end

local function loadOnDemand()
    if not moduleLoaded then
        playerGUID = UnitGUID("player")
        kps.events.register("COMBAT_LOG_EVENT_UNFILTERED", updateWildImps)
        moduleLoaded = true
    end
end


--[[
@function `<UNIT>.wildImps` - Number of active Wild Imps
]]--
function Player.wildImps(self)
    loadOnDemand()
    return impCount
end
