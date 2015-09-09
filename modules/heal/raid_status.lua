--[[[
@module Raid Status
@description
Tank or Focus Class, sub-class of Unit, which represents the (lowest hp) tank or focus target.
]]--

local raidStatus = {}
local raidStatusSize = 0

local raidHealTargets = {}
local groupHealTargets = {}

local moduleLoaded = false
local function updateRaidStatus()
    local newRaidStatus = {}
    local newRaidStatusSize = 0
    local healTargets = nil
    local unit = nil
    local maxId = 0

    if IsInRaid() then
        healTargets = raidHealTargets
        newRaidStatusSize = GetNumGroupMembers()
    else
        healTargets = groupHealTargets
        newRaidStatusSize = GetNumSubgroupMembers() + 1
    end
    for i=1,maxId do
        newRaidStatus[healTargets[i].name] = healTargets[i]
    end
    raidStatus = newRaidStatus
    raidStatusSize = newRaidStatusSize
end

local function loadOnDemand()
    if not moduleLoaded then
        groupHealTargets[1] = kps.Heal.new("player")
        for i=2,5 do
            groupHealTargets[i] = kps.Heal.new("party"..(i-1))
        end
        for i=1,40 do
            raidHealTargets[i] = kps.Heal.new("raid"..(1))
        end

        kps.events.registerOnUpdate(updateRaidStatus)
        moduleLoaded = true
    end
end

kps.raidStatus = {}

function kps.raidStatus.size()
    loadOnDemand()
    return raidStatusSize
end