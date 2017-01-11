--[[
AutoTurn Module
]]--
local LOG = kps.Logger(kps.LogLevel.INFO)

kps.events.register("UI_ERROR_MESSAGE", function(event_type, event_error)
      if kps.enabled and kps.autoTurn and  ((event_error == SPELL_FAILED_UNIT_NOT_INFRONT) or (event_error == ERR_BADATTACKFACING)) then
         if kps["env"].player ~= nil and not kps["env"].player.isMoving then
            kps.timers.create("Facing", 0.6)
            kps.timers.create("FacingBug", 1.2)
            TurnLeftStart()
            CameraOrSelectOrMoveStart()
         end
      end
end)

local function disableTurningAfterCombat()
   if kps.timers.check("FacingBug") > 0 then
      TurnLeftStop()
      TurnRightStop()
      CameraOrSelectOrMoveStop()
   end
end
kps.events.register("PLAYER_REGEN_ENABLED", disableTurningAfterCombat)
kps.events.register("PLAYER_UNGHOST", disableTurningAfterCombat)

local function disableTurning()
   if kps.timers.check("FacingBug") > 0 and kps.timers.check("Facing") == 0 then
      TurnLeftStop()
      TurnRightStop()
      CameraOrSelectOrMoveStop()
   end
end
kps.events.registerOnUpdate(disableTurning)
kps.events.register("UNIT_SPELLCAST_SUCCEEDED", function(...)
      if kps.autoTurn then
         local unitID = select(1,...)
         local spellID = select(5,...)
         if (unitID == "player") and spellID then 
            if kps.timers.check("FacingBug") > 0 then
               TurnLeftStop()
               TurnRightStop()
               CameraOrSelectOrMoveStop()
            end
         end
      end
end)