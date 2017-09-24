--[[[
@module Priest Environment Functions and Variables
@description
Priest Environment Functions and Variables.
]]--

kps.env.priest = {}

local UnitIsUnit = UnitIsUnit
local UnitExists = UnitExists
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local MindFlay = tostring(kps.spells.priest.mindFlay)
local VoidForm = tostring(kps.spells.priest.voidform)
local EnemyTable = {"mouseover", "focus", "target"}
local UnitDebuff = UnitDebuff
local UnitBuff = UnitBuff
local UnitChannelInfo = UnitChannelInfo

--------------------------------------------------------------------------------------------
------------------------------- TEST FUNCTIONS
--------------------------------------------------------------------------------------------

function kps.env.priest.booltest()
    if kps.multiTarget then return true end
    return false
end
function kps.env.priest.boolval(arg)
    if arg == true then return true end
    return false
end
function kps.env.priest.strtest()
    if kps.multiTarget then return "a" end
    return "b"
end
function kps.env.priest.strval(arg)
    if arg == true then return "a" end
    return "b"
end

--kps.rotations.register("PRIEST","SHADOW",{

--{spells.mindFlay, env.booltest }, -- true/false
--{spells.mindFlay, env.booltest() }, -- always false
--{spells.mindFlay, 'env.booltest' }, -- nil value
--{spells.mindFlay, 'env.booltest()' }, -- nil value
--{spells.mindFlay, 'booltest()' }, -- true/false
--{spells.mindFlay, 'booltest' }, -- always true

--{spells.mindFlay, env.boolval(kps.multiTarget) }, -- always false
--{spells.mindFlay, 'env.boolval(kps.multiTarget)' }, -- nil value
--{spells.mindFlay, 'boolval(kps.multiTarget)' }, -- always true

--{spells.mindFlay, env.strtest == "a" }, -- always false
--{spells.mindFlay, env.strtest() == "a" }, -- always false
--{spells.mindFlay, 'env.strtest == "a"' }, -- nil value
--{spells.mindFlay, 'env.strtest() == "a"' }, -- nil value
--{spells.mindFlay, 'strtest() == "a"' }, -- true/false
--{spells.mindFlay, 'strtest == "a"' }, -- always false

--{spells.mindFlay, env.strval(kps.multiTarget) == "a" }, -- always false
--{spells.mindFlay, 'env.strval(kps.multiTarget) == "a"' }, -- nil value
--{spells.mindFlay, strval(kps.multiTarget) == "a" }, -- nil value
--{spells.mindFlay, 'strval(kps.multiTarget) == "a"' }, -- true/false

--},"TEST Priest")

--------------------------------------------------------------------------------------------
------------------------------- LOCAL FUNCTIONS
--------------------------------------------------------------------------------------------

function kps.env.priest.threshold()
    if IsInRaid() then return 0.60 end
    return 0.70
end

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

local function UnitIsAttackable(unit)
    if UnitIsDeadOrGhost(unit) then return false end
    if not UnitExists(unit) then return false end
    if (string.match(GetUnitName(unit), kps.locale["Dummy"])) then return true end
    if UnitCanAttack("player",unit) == false then return false end
    --if UnitIsEnemy("player",unit) == false then return false end
    if not kps.env.harmSpell.inRange(unit) then return false end
    return true
end

local function PlayerHasTalent(row,talent)
    local _, talentRowSelected =  GetTalentTierInfo(row,1)
    if talent == talentRowSelected then return true end
    return false
end

function kps.env.priest.canCastvoidBolt()
    if not UnitHasBuff(VoidForm,"player") then return false end
    if kps.spells.priest.voidEruption.cooldown > 0 then return false end
    local Channeling = UnitChannelInfo("player") -- "Mind Flay" is a channeling spell
    if Channeling ~= nil then
      if tostring(Channeling) == MindFlay then return true end
    end
    return false
end

function kps.env.priest.canCastMindBlast()
    if kps.spells.priest.mindBlast.cooldown > 0 then return false end
    local Channeling = UnitChannelInfo("player") -- "Mind Flay" is a channeling spell
    if Channeling ~= nil then
        if tostring(Channeling) == MindFlay then return true end
    end
    return false
end

function kps.env.priest.VoidBoltTarget()
    local VoidBoltTarget = "target"
    local VoidBoltTargetDuration = 24
    for i=1,#EnemyTable do
        local enemy = EnemyTable[i]
        local shadowWordPainDuration = UnitDebuffDuration(kps.spells.priest.shadowWordPain,enemy)
        local vampiricTouchDuration = UnitDebuffDuration(kps.spells.priest.vampiricTouch,enemy)
        if shadowWordPainDuration > 0 and vampiricTouchDuration > 0 then
            local duration = math.min(shadowWordPainDuration,vampiricTouchDuration)
            if duration < VoidBoltTargetDuration then
                VoidBoltTargetDuration = duration
                VoidBoltTarget = enemy
            end
        end
    end
    return VoidBoltTarget
end

-- UnitHealthMax returns the maximum health of the specified unit, returns 0 if the specified unit does not exist (eg. "target" given but there is no target)
function kps.env.priest.DeathEnemyTarget()
    local DeathTarget = "target"
    local HealthTarget = 1
    for i=1,#EnemyTable do
        local enemy = EnemyTable[i]
        if UnitExists(enemy) then HealthTarget = UnitHealth(enemy) / UnitHealthMax(enemy) end
        if PlayerHasTalent(4,2) and HealthTarget < 0.35 and UnitIsAttackable(enemy) then
            DeathTarget = enemy
        elseif HealthTarget < 0.20 and UnitIsAttackable(enemy) then
            DeathTarget = enemy
        break end
    end
    return DeathTarget
end

-- Config FOCUS with MOUSEOVER
function kps.env.priest.TargetMouseover()
    if not UnitExists("focus") and not UnitIsUnit("target","mouseover") and UnitIsAttackable("mouseover") and UnitAffectingCombat("mouseover") then
        if UnitDebuffDuration(kps.spells.priest.vampiricTouch,"mouseover") == 0 then
            kps.runMacro("/focus mouseover")
        elseif UnitDebuffDuration(kps.spells.priest.shadowWordPain,"mouseover") == 0 then
            kps.runMacro("/focus mouseover")
        else
            kps.runMacro("/focus mouseover")
        end
    end
    return nil, nil
end

function kps.env.priest.FocusMouseover()
    if UnitExists("focus") and not UnitIsUnit("target","mouseover") and UnitIsAttackable("mouseover") and UnitAffectingCombat("mouseover") then
        if UnitDebuffDuration(kps.spells.priest.vampiricTouch,"focus") > 4 and UnitDebuffDuration(kps.spells.priest.shadowWordPain,"focus") > 4 then
            if UnitDebuffDuration(kps.spells.priest.vampiricTouch,"mouseover") == 0 then
                kps.runMacro("/focus mouseover")
            end
        end
    end
    return nil, nil
end

--------------------------------------------------------------------------------------------
------------------------------- AVOID OVERHEALING
--------------------------------------------------------------------------------------------

local Heal = tostring(kps.spells.priest.heal)
local FlashHeal = tostring(kps.spells.priest.flashHeal)
local PrayerOfHealing = tostring(kps.spells.priest.prayerOfHealing)
local SpiritOfRedemption = tostring(kps.spells.priest.spiritOfRedemption)
local holyWordSerenity = tostring(kps.spells.priest.holyWordSerenity)

function kps.env.priest.holyWordSerenityOnCD()
    if UnitHasBuff(SpiritOfRedemption,"player") then return true end
    if kps.spells.priest.holyWordSerenity.cooldown > kps.gcd then return true end
    return false
end

local interruptTableUpdate = function()
    local onCD = kps.env.priest.holyWordSerenityOnCD() or kps.defensive -- case I want heal with mouseover
    local buffPlayer = UnitHasBuff(SpiritOfRedemption,"player") or kps.defensive
    return { {FlashHeal, 0.885 , onCD}, {Heal, 0.995 , onCD}, {PrayerOfHealing, 3 , buffPlayer} }
end

local ShouldInterruptCasting = function (interruptTable, countLossInRange, lowestHealth)
    if kps.lastTargetGUID == nil then return false end
    local spellCasting, _, _, _, _, endTime, _ = UnitCastingInfo("player")
    if spellCasting == nil then return false end
    local targetHealth = UnitHealth(kps.lastTarget) / UnitHealthMax(kps.lastTarget)

    for key, healSpellTable in pairs(interruptTable) do
        local breakpoint = healSpellTable[2]
        local spellName = tostring(healSpellTable[1])
        if spellName == spellCasting and healSpellTable[3] == false then
            if spellName == PrayerOfHealing and countLossInRange < breakpoint then
                SpellStopCasting()
                DEFAULT_CHAT_FRAME:AddMessage("STOPCASTING OverHeal "..spellName..", has enough hp: "..countLossInRange, 0, 0.5, 0.8)

            elseif spellName == Heal and lowestHealth < 0.50 and UnitPower("player",0)/UnitPowerMax("player",0) > 0.10 then
                -- SPELL_POWER_MANA value 0
                SpellStopCasting()
                kps.timers.create("criticalHP", 4 )
                DEFAULT_CHAT_FRAME:AddMessage("STOPCASTING "..spellName.." Lowest has critical hp: "..lowestHealth, 0, 0.5, 0.8)

            elseif spellName == Heal and targetHealth > breakpoint then
                SpellStopCasting()
                DEFAULT_CHAT_FRAME:AddMessage("STOPCASTING OverHeal "..spellName..","..kps.lastTarget.." has enough hp: "..targetHealth, 0, 0.5, 0.8)

            elseif spellName == FlashHeal and targetHealth > breakpoint then
                SpellStopCasting()
                DEFAULT_CHAT_FRAME:AddMessage("STOPCASTING OverHeal "..spellName..","..kps.lastTarget.." has enough hp: "..targetHealth, 0, 0.5, 0.8)
            end
        end
    end
    return nil, nil
end

kps.env.priest.ShouldInterruptCasting = function()
    local countLossInRange = kps["env"].heal.countLossInRange(0.80)
    local lowestHealth = kps["env"].heal.lowestInRaid.hp
    local interruptTable = interruptTableUpdate()
    return ShouldInterruptCasting(interruptTable, countLossInRange, lowestHealth)
end

--------------------------------------------------------------------------------------------
------------------------------- MESSAGE ON SCREEN
--------------------------------------------------------------------------------------------

local buffdivinity = tostring(kps.spells.priest.divinity)
local function holyWordSanctifyOnScreen()
    if kps.spells.priest.holyWordSanctify.cooldown < kps.gcd and kps.timers.check("holyWordSanctify") == 0 and not UnitHasBuff(buffdivinity,"player") then
        kps.timers.create("holyWordSanctify", 10 )
        CreateMessage("holyWordSanctify Ready")
    end
end

kps.env.priest.ScreenMessage = function()
    return holyWordSanctifyOnScreen()
end


-- SendChatMessage("msg" [, "chatType" [, languageIndex [, "channel"]]])
-- Sends a chat message of the specified in 'msg' (ex. "Hey!"), to the system specified in 'chatType' ("SAY", "WHISPER", "EMOTE", "CHANNEL", "PARTY", "INSTANCE_CHAT", "GUILD", "OFFICER", "YELL", "RAID", "RAID_WARNING", "AFK", "DND"),
-- in the language specified in 'languageID', to the player or channel specified in 'channel'(ex. "1", "Bob").


--kps.events.register("UNIT_SPELLCAST_START", function(unitID,spellname,_,_,spellID)
--    if unitID == "player" and spellID ~= nil then
--    end
--end)

kps.events.register("UNIT_SPELLCAST_CHANNEL_START", function(unitID,spellname,_,_,spellID)
    if unitID == "player" and spellID ~= nil then
        if spellID == 64843 then SendChatMessage("Casting DIVINE HYMN" , "RAID" ) end
    end
end)
