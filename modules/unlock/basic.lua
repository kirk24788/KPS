--[[[
@module Basic Unlock
@description
Basic Unlock - Dummy Functions for access to enhanced unlock features. Prevents errors if no advanced unlock is present.
]]--

function kps.env.activeEnemies()
    if kps.multiTarget then
        return 6
    else
        return 1
    end
end