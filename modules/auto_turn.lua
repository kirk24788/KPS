--[[
AutoTurn Module
]]--
local LOG = kps.Logger(kps.LogLevel.INFO)

kps.events.register("UI_ERROR_MESSAGE", function(event_type, event_error)
      if kps.enabled and kps.autoTurn and  ((event_error == SPELL_FAILED_UNIT_NOT_INFRONT) or (event_error == ERR_BADATTACKFACING)) then
         if kps["env"].player ~= nil and not kps["env"].player.isMoving then
            kps.timers.create("Facing", 1)
            TurnLeftStart()
            --CameraOrSelectOrMoveStart()
            C_Timer.After(1,function() TurnLeftStop() end)
         end
      end
end)

local function disableTurningAfterCombat()
   if kps.timers.check("Facing") > 0 then
      TurnLeftStop()
      TurnRightStop()
      CameraOrSelectOrMoveStop()
   end
end
kps.events.register("PLAYER_REGEN_ENABLED", disableTurningAfterCombat)
kps.events.register("PLAYER_UNGHOST", disableTurningAfterCombat)

kps.events.register("UNIT_SPELLCAST_START", function(...)
      if kps.autoTurn then
         local unitID = select(1,...)
         local spellID = select(5,...)
         if (unitID == "player") and spellID then 
            if kps.timers.check("Facing") > 0 then
               TurnLeftStop()
               TurnRightStop()
               CameraOrSelectOrMoveStop()
            end
         end
      end
end)

--[[
"UNIT_SPELLCAST_SENT" Fired when an event is sent to the server
"UNIT_SPELLCAST_START" Fired when a unit begins casting
"UNIT_SPELLCAST_SUCCEEDED" Fired when a spell is cast successfully
]]--