
local LOG=kps.Logger(kps.LogLevel.DEBUG)

local prioritySpell = nil
local priorityAction = nil
local priorityMacro = nil

kps.runMacro = function(macroText)
    -- Call Macro Text
    RunMacroText(macroText)
end

function kps.write(...)
    DEFAULT_CHAT_FRAME:AddMessage("|cffff8000KPS: " .. strjoin(" ", tostringall(...))); -- color orange
end

kps.useBagItem = function(bagItem)
    -- TODO: Return a FUNCTION which uses Item!
    -- See JPS, also:
    --[[

            if res == nil and IsEquippedItem(id) then
                slot = select(9, GetItemInfo(id))
                if string.find(slot, "TRINKET") ~= nil then
                    s1 = select(1,GetInventorySlotInfo("Trinket0Slot"))
                    s2 = select(1,GetInventorySlotInfo("Trinket1Slot"))
                    t1 = GetInventoryItemID("player", s1)
                    t2 = GetInventoryItemID("player", s2)

                    if t1 == id then
                        priorityMacro = "/use "..s1
                    end
                    if t2 == id then
                        priorityMacro = "/use "..s2
                    end

                end

    ]]
end

kps.combatStep = function ()
    -- Check for combat
    if not InCombatLockdown() then return end

    -- Check for rotation
    if not kps.rotations.getActive() then
        kps.write("KPS does not have a rotation for your class (%s) or spec (%s)!", kps.spec, kps.class)
        kps.enabled = false
    end

    local player = kps.env.player

    -- No combat if mounted (except if overriden by config), dead or drinking
    if (player.isMounted and not kps.config.dismountInCombat) or player.isDead or player.isDrinking then
        return
    end
    local spell, target = kps.rotations.getActive().getSpell()

    if spell ~= nil and not player.isCasting then
        if priorityMacro ~= nil then
            kps.runMacro(priorityMacro)
            priorityMacro = nil
        elseif priorityAction ~= nil then
            priorityAction()
            priorityAction = nil
        elseif prioritySpell ~= nil then
            if prioritySpell.canBeCastAt("target") then
                prioritySpell.cast()
                LOG.warn("Priority Spell %s was casted.", prioritySpell)
                prioritySpell = nil
            else
                if kps.spells.cooldown(prioritySpell) > 3 then prioritySpell = nil end
                spell.cast(target)
            end
        else
            spell.cast(target)
        end
    end
end

hooksecurefunc("UseAction", function(...)
    if kps.enabled and (select(3, ...) ~= nil) and InCombatLockdown() == true  then
        local stype,id,_ = GetActionInfo(select(1, ...))
        if stype == "spell" then
            local spell = kps.Spell.fromId(id)
            if prioritySpell ~= spell.name  and spell.isPrioritySpell then
                prioritySpell = spell
                LOG.warn("Set %s for next cast.", spell.name)
            end
        end
        if stype == "item" then
            priorityAction = kps.useItem(id)
        end
        if stype == "macro" then
            macroText = select(3, GetMacroInfo(id))
            if string.find(macroText,"kps") == nil then
                priorityMacro = macroText
            end
        end
    end
end)

kps.stopCasting = function()
    SpellStopCasting()
end
