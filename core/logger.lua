--[[[
@module Logging
@description
This module provides a Logger instance which can be initialized with a Log-Level
([code]kps.LogLevel.DEBUG[/code],[code]kps.LogLevel.INFO[/code],[code]kps.LogLevel.WARN[/code],[code]kps.LogLevel.ERROR[/code] or [code]kps.LogLevel.NONE[/code]).
All calls to it's logging functions will then either be ignored or printed with Log Level and the calling file/line number. A limited number of varargs are supported, which
then are used to as input for the format string.[br]
[br]
Usage in your code:[br]
[code]
local LOG=kps.Logger(kps.LogLevel.DEBUG)[br]
LOG.debug("debug message")[br]
LOG.debug("this is a number: %s", 2)[br]
[/code]
]]--


kps.LogLevel={ DEBUG=1, INFO=2, WARN=3, ERROR=4, NONE=5 }
local function split(str, sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

local function logPrint(logLevel,msgLevel)
    if msgLevel >= logLevel then
        return function (msg,a,b,c,d,e,f,g,h)
            local stackTrace = split(debugstack(2,1,0), ":")
            local file  = split(stackTrace[1], "\\")
            --local prefix = ""
            local prefix = string.format("%s:%s - ", file[#file], stackTrace[2])--string.format("%s:%s - ", debug.getinfo(1, "S").short_src, debug.getinfo(2, "l").currentline)
            --TODO: Check if DEFAULT_CHAT_FRAME:AddMessage() has any significant advantages
            print(prefix .. string.format(msg, tostring(a), tostring(b), tostring(c), tostring(d), tostring(e), tostring(f), tostring(g), tostring(h)) )
        end
    else
        return function (msg,a,b,c,d,e,f,g,h)
            -- no logging
        end
    end
end

function kps.Logger(level)
    local newLogger = {}
    if not level or not tonumber(level) or (level < kps.LogLevel.DEBUG and level > kps.LogLevel.NONE) then
        newLogger["logLevel"] = kps.LogLevel.NONE
    else
        newLogger["logLevel"] = level
    end
    newLogger["debug"] = logPrint(newLogger.logLevel, kps.LogLevel.DEBUG)
    newLogger["info"] = logPrint(newLogger.logLevel, kps.LogLevel.INFO)
    newLogger["warn"] = logPrint(newLogger.logLevel, kps.LogLevel.WARN)
    newLogger["error"] = logPrint(newLogger.logLevel, kps.LogLevel.ERROR)
    newLogger["isDebugEnabled"] = newLogger.logLevel <= kps.LogLevel.DEBUG
    newLogger["isInfoEnabled"] = newLogger.logLevel <= kps.LogLevel.INFO
    newLogger["isWarnEnabled"] = newLogger.logLevel <= kps.LogLevel.WARN
    newLogger["isErrorEnabled"] = newLogger.logLevel <= kps.LogLevel.ERROR
    return newLogger
end
