--[[[
@module Priest Environment Functions and Variables
@description
Priest Environment Functions and Variables.
]]--

kps.env.priest = {}

local MindFlay = tostring(kps.spells.priest.mindFlay)

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

local PlayerDebuffDuration = function(spell,unit)
	--if unit == nil then return "target" end
	local spellname = tostring(spell)
	local name,_,_,_,_,duration,endTime,caster,_,_ = UnitDebuff(unit,spellname)
	if caster ~= "player" then return 0 end
	if endTime == nil then return 0 end
	local timeLeft = endTime - GetTime()
    if timeLeft < 0 then return 0 end
	return timeLeft
end

local Enemy = { "target", "focus" ,"mouseover" }
function kps.env.priest.VoidBoltTarget()
	local VoidBoltTarget = nil
	local VoidBoltTargetDuration = 24
	for i=1,#Enemy do -- for _,unit in ipairs(EnemyUnit) do
		local unit = Enemy[i]
		local shadowWordPainDuration = PlayerDebuffDuration(kps.spells.priest.shadowWordPain,unit)
		local vampiricTouchDuration = PlayerDebuffDuration(kps.spells.priest.vampiricTouch,unit)
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