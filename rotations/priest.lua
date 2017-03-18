--[[[
@module Priest Environment Functions and Variables
@description
Priest Environment Functions and Variables.
]]--

kps.env.priest = {}

local MindFlay = tostring(kps.spells.priest.mindFlay)
local VoidFormBuff = tostring(kps.spells.priest.voidform)

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

function UnitHasBuff(spell,unit)
	--if unit == nil then unit = "player" end
	local spellname = tostring(spell)
	if spellname == nil then return false end
	if select(1,UnitBuff(unit,spellname)) then return true end
	return false
end

local function HealthPct(unit)
	return UnitHealth(unit) / UnitHealthMax(unit)
end
local function PlayerHasTalent(row,talent)
	local _, talentRowSelected =  GetTalentTierInfo(row,1)
	if talent == talentRowSelected then return true end
	return false
end

function kps.env.priest.canCastvoidBolt()
	--if kps.multiTarget then return false end
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



local Enemy = { "target", "focus" ,"mouseover" }
function kps.env.priest.VoidBoltTarget()
	local VoidBoltTarget = nil
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
	local deathEnemyTarget = nil
	for i=1,#Enemy do -- for _,unit in ipairs(EnemyUnit) do
		local unit = Enemy[i]
		if PlayerHasTalent(4,2) and HealthPct(unit) < 0.35 then
			deathEnemyTarget = unit
		elseif HealthPct(unit) < 0.20 then
			deathEnemyTarget = unit
		break end
	end
	return deathEnemyTarget
end

local UnitIsUnit = UnitIsUnit
local UnitExists = UnitExists

local function UnitIsAttackable(unit)
    if not UnitExists(unit) then return false end
    if (string.match(GetUnitName(unit), kps.locale["Dummy"])) then return true end
    if UnitCanAttack("player",unit) == false then return false end-- UnitCanAttack(attacker, attacked) return 1 if the attacker can attack the attacked, nil otherwise.
    if UnitIsEnemy("player",unit) == false then return false end -- WARNING a unit is hostile to you or not Returns either 1 ot nil -- Raider's Training returns nil with UnitIsEnemy
    --TODO: if jps.PlayerIsBlacklisted(self.unit) then return false end -- WARNING Blacklist is updated only when UNITH HEALTH occurs
    if not kps.env.harmSpell.inRange(unit) then return false end
    return true
end

function kps.env.priest.TargetMouseover()
	-- Config FOCUS with MOUSEOVER
	if not UnitExists("focus") and UnitIsAttackable("mouseover") then
		if UnitIsUnit("mouseovertarget","player") and not UnitIsUnit("target","mouseover") then
			kps.runMacro("/focus mouseover") --print("Enemy DAMAGER|cff1eff00 "..name.." |cffffffffset as FOCUS")
		elseif not UnitIsUnit("target","mouseover") and UnitDebuffDuration(kps.spells.priest.shadowWordPain,"mouseover") < 2 then 
			kps.runMacro("/focus mouseover") --print("Enemy COMBAT|cff1eff00 "..name.." |cffffffffset as FOCUS not DEBUFF")
		elseif not UnitIsUnit("target","mouseover") and UnitDebuffDuration(kps.spells.priest.vampiricTouch,"mouseover") < 2 then
			kps.runMacro("/focus mouseover") --print("Enemy COMBAT|cff1eff00 "..name.." |cffffffffset as FOCUS not DEBUFF")
		elseif not UnitIsUnit("target","mouseover") then
			kps.runMacro("/focus mouseover")
		end
	end
	if UnitExists("focus") and UnitIsUnit("target","focus") then
		kps.runMacro("/clearfocus")
	elseif UnitExists("focus") and not UnitIsAttackable("focus") then
		kps.runMacro("/clearfocus")
	end
end