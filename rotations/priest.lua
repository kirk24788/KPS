--[[[
@module Priest Environment Functions and Variables
@description
Priest Environment Functions and Variables.
]]--

kps.env.priest = {}

local MindFlay = tostring(kps.spells.priest.mindFlay)
local VoidFormBuff = tostring(kps.spells.priest.voidform)
local Heal = tostring(kps.spells.priest.heal)
local FlashHeal = tostring(kps.spells.priest.flashHeal)
local PrayerOfHealing = tostring(kps.spells.priest.prayerOfHealing)

local UnitDebuffDuration = function(spell,unit)
    --if unit == nil then return "target" end
    local spellname = tostring(spell)
    local name,_,_,_,_,duration,endTime,caster,_,_ = UnitDebuff(unit,spellname)
    if caster ~= "player" then return 0 end
    if endTime == nil then return 0 end
    local timeLeft = endTime - GetTime()
    if timeLeft < 0 then return 0 end
    return timeLeft
end

local UnitHasBuff = function(spell,unit)
    --if unit == nil then unit = "player" end
    local spellname = tostring(spell)
    if spellname == nil then return false end
    if select(1,UnitBuff(unit,spellname)) then return true end
    return false
end

local UnitIsUnit = UnitIsUnit
local UnitExists = UnitExists
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax

local function UnitIsAttackable(unit)
    if UnitIsDeadOrGhost(unit) then return false end
    if not UnitExists(unit) then return false end
    if (string.match(GetUnitName(unit), kps.locale["Dummy"])) then return true end
    if UnitCanAttack("player",unit) == false then return false end
    if UnitIsEnemy("player",unit) == false then return false end
    if not kps.env.harmSpell.inRange(unit) then return false end
    return true
end

local function PlayerHasTalent(row,talent)
    local _, talentRowSelected =  GetTalentTierInfo(row,1)
    if talent == talentRowSelected then return true end
    return false
end

function kps.env.priest.canCastvoidBolt()
    if kps.multiTarget then return false end
    --if not kps["env"].player.hasBuff(self,VoidFormBuff) then return false end
    if not UnitHasBuff(VoidFormBuff,"player") then return false end
    if kps.spells.priest.voidEruption.cooldown > 0 then return false end
    local Channeling = UnitChannelInfo("player") -- "Mind Flay" is a channeling spell
    if Channeling ~= nil then
      if tostring(Channeling) == MindFlay then return true end
    end
    return false
end

function kps.env.priest.canCastMindBlast()
    if kps.multiTarget then return false end
    if kps.spells.priest.mindBlast.cooldown > 0 then return false end
    local Channeling = UnitChannelInfo("player") -- "Mind Flay" is a channeling spell
    if Channeling ~= nil then
        if tostring(Channeling) == MindFlay then return true end
    end
    return false
end

function kps.env.priest.test()
    if kps.multiTarget then return true end
    return false
end

function kps.env.priest.testkps(arg)
    if arg == true then return true end
    return false
end

--{spells.mindFlay, env.test }, -- true/false
--{spells.mindFlay, 'test()' }, -- lua error parser/lua:84 bad argument to unpack table expected got nil
--{spells.mindFlay, 'test(1)' }, -- true/false

--{spells.mindFlay, 'testkps(kps.multiTarget)' }, -- true/false
--{spells.mindFlay, env.testkps(kps.multiTarget) }, -- always false


local Enemy = {"mouseover", "focus", "target" }
function kps.env.priest.VoidBoltTarget()
    local VoidBoltTarget = "target"
    local VoidBoltTargetDuration = 24
    for i=1,#Enemy do -- for _,unit in ipairs(EnemyUnit) do
        local unit = Enemy[i]
        local shadowWordPainDuration = UnitDebuffDuration(kps.spells.priest.shadowWordPain,unit)
        local vampiricTouchDuration = UnitDebuffDuration(kps.spells.priest.vampiricTouch,unit)
        if shadowWordPainDuration > 0 and vampiricTouchDuration > 0 then
            local duration = math.min(shadowWordPainDuration,vampiricTouchDuration)
            if duration < VoidBoltTargetDuration then
                VoidBoltTargetDuration = duration
                VoidBoltTarget = unit
            end
        end
    end
    return VoidBoltTarget
end

function kps.env.priest.DeathEnemyTarget()
    local EnemyTarget = "target"
    for i=1,#Enemy do -- for _,unit in ipairs(EnemyUnit) do
        local unit = Enemy[i]
        local unitHealth = UnitHealth(unit) / UnitHealthMax(unit)
        if PlayerHasTalent(4,2) and unitHealth < 0.35 then
            EnemyTarget = unit
        elseif unitHealth < 0.20 then
            EnemyTarget = unit
        end
    end
    return EnemyTarget
end

function kps.env.priest.TargetMouseover()
    -- Config FOCUS with MOUSEOVER
    if not UnitExists("focus") and UnitIsAttackable("mouseover") then
        if UnitIsUnit("mouseovertarget","player") and not UnitIsUnit("target","mouseover") then
            kps.runMacro("/focus mouseover")
        elseif not UnitIsUnit("target","mouseover") and UnitDebuffDuration(kps.spells.priest.shadowWordPain,"mouseover") < 2 and UnitDebuffDuration(kps.spells.priest.vampiricTouch,"mouseover") < 2 then 
            kps.runMacro("/focus mouseover")
        elseif not UnitIsUnit("target","mouseover") and UnitDebuffDuration(kps.spells.priest.shadowWordPain,"mouseover") < 2 then
            kps.runMacro("/focus mouseover")
        elseif not UnitIsUnit("target","mouseover") and UnitDebuffDuration(kps.spells.priest.vampiricTouch,"mouseover") < 2 then
            kps.runMacro("/focus mouseover")
        elseif not UnitIsUnit("target","mouseover") then
            kps.runMacro("/focus mouseover")
        end
    end
    if UnitExists("focus") and UnitIsUnit("target","focus") then
        kps.runMacro("/clearfocus")
    elseif UnitExists("focus") and not UnitIsAttackable("focus") then
        kps.runMacro("/clearfocus")
    end
    return nil, nil
end

-- AVOID OVERHEALING -- env.ShouldInterruptCasting(InterruptTable, CountInRange, AvgHealthRaid)

local SerenityOnCD = function()
    if kps.spells.priest.holyWordSerenity.cooldown == 0 then return false end 
    return true
end

local InterruptTable = {
    {FlashHeal, 0.85 , SerenityOnCD() },
    {Heal, 0.95 , SerenityOnCD() },
    {PrayerOfHealing, 3 , true },
}

local ShouldInterruptCasting = function (InterruptTable, CountInRange, LowestHealth)
    if kps.lastTargetGUID == nil then return false end
    local spellCasting, _, _, _, _, endTime, _ = UnitCastingInfo("player")
    if spellCasting == nil then return false end
    local TargetHealth = UnitHealth(kps.lastTarget) / UnitHealthMax(kps.lastTarget)
    
    for key, healSpellTable in pairs(InterruptTable) do
        local breakpoint = healSpellTable[2]
        local spellName = tostring(healSpellTable[1])
        if spellName == spellCasting and healSpellTable[3] == false then
            if healSpellTable[1] == PrayerOfHealing and CountInRange < breakpoint then
                SpellStopCasting()
                DEFAULT_CHAT_FRAME:AddMessage("STOPCASTING avgHP "..spellName..", raid has enough hp!",0, 0.5, 0.8)
            elseif healSpellTable[1] == Heal and TargetHealth > breakpoint then
                SpellStopCasting()
                DEFAULT_CHAT_FRAME:AddMessage("STOPCASTING OverHeal "..spellName..","..kps.lastTarget.." has enough hp!",0, 0.5, 0.8)
            elseif healSpellTable[1] == FlashHeal and TargetHealth > breakpoint then
                SpellStopCasting()
                DEFAULT_CHAT_FRAME:AddMessage("STOPCASTING OverHeal "..spellName..","..kps.lastTarget.." has enough hp!",0, 0.5, 0.8)
            end
        end
    end
    return nil, nil
end


kps.env.priest.ShouldInterruptCasting = function()
    local countInRange = kps["env"].heal.countInRange
    local lowestHealth = kps["env"].heal.lowestInRaid.hp
    return ShouldInterruptCasting(InterruptTable, countInRange, lowestHealth)
end

