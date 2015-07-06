--[[[
@module Spell Table Parser
@description
Parses Spell Tables and compiles them into executable functions.
]]--
kps.parser = {}

local LOG=kps.Logger(kps.LogLevel.WARN)
local parser = {}
parser.testMode = false
parser.error = nil


--[[
    FUNCTIONS USED IN SPELL TABLE
  ]]

local function FN(fn,...)
    local params = {...}
    local params_exec = {}
    return function()
  for i,v in ipairs(params) do
    if type(v) == "function" then
        params_exec[i] = v()
    else
        params_exec[i] = v
    end
  end
        return fn()(unpack(params_exec))
    end
end


local function AND(...)
    local functions = {...}
    return function()
        for _,fn in pairs(functions) do
            if not fn() then if not parser.testMode then return false end end
        end
        return true
    end
end

local function OR(...)
    local functions = {...}
    return function()
        for _,fn in pairs(functions) do
            if fn() then if not parser.testMode then return true end end
        end
        return false
    end
end

local function NOT(fn)
    return function()
        return not fn()
    end
end


local function LT(o1, o2)
    return function()
        return o1() < o2()
    end
end

local function LE(o1, o2)
    return function()
        return o1() <= o2()
    end
end

local function EQ(o1, o2)
    return function()
        return o1() == o2()
    end
end

local function NEQ(o1, o2)
    return function()
        return o1() ~= o2()
    end
end

local function GE(o1, o2)
    return function()
        return o1() >= o2()
    end
end

local function GT(o1, o2)
    return function()
        return o1() > o2()
    end
end

local function VALUE(val)
    return function()
        return val
    end
end


local function SUBSTRACT(o1, o2)
    return function()
        return o1() - o2()
    end
end
local function ADD(o1, o2)
    return function()
        return o1() - o2()
    end
end
local function MULTIPLY(o1, o2)
    return function()
        return o1() * o2()
    end
end
local function DIVIDE(o1, o2)
    return function()
        return o1() / o2()
    end
end
local function MODULO(o1, o2)
    return function()
        return o1() % o2()
    end
end

local function GLOBAL_IDENTIFIER(id)
    return function()
        return kps["env"][id]
    end
end

local function ACCESSOR(base, key)
    return function()
        return base()[key]
    end
end
local errorCount = 0
local errorLogTable = {}
local function ERROR(condition,msg)
    local ePos = string.find(tostring(msg), ":", string.find(tostring(msg), ":"))
    local eDescription = string.sub(tostring(msg), ePos)
    local errorMsg = "Your rotation has an error in condition: '" .. tostring(condition) .. "':\n   " .. eDescription
    local errorId = errorCount + 1
    errorCount = errorCount + 1
    errorLogTable[errorId] = 0
    return function()
        if GetTime() - errorLogTable[errorId] > 15 then
            LOG.error("Rotation-Error: %s", errorMsg)
            errorLogTable[errorId] = GetTime()
        end
        return false
    end
end



local function fnMessageEval(message)
    if message == nil then
        return ""
    elseif type(message) == "string" then
        return message
    end
end

local function fnTargetEval(target)
    if target == nil then
        return "target"
    elseif type(target) == "function" then
        return target()
    else
        return target
    end
end

local function alwaysTrue() return true end
local function alwaysFalse() return false end
local function fnParseCondition(conditions)
    if conditions == nil then
        return alwaysTrue
    elseif type(conditions) == "boolean" then
        return function()
            return conditions
        end
    elseif type(conditions) == "number" then
        return function()
            return conditions ~= 0
        end
    elseif type(conditions) == "function" then
        return function()
            return conditions()
        end
    elseif type(conditions) == "string" and string.len(conditions) > 0 then
        local tokens = {}
        local i = 0

        for t,v in kps.lexer.lua(conditions) do
            i = i+1
            tokens[i] = {t,v}
        end
        local retOK, fn  = pcall(parser.conditions, tokens, 0)
        if not retOK then
            --TODO: syntax error in
            return ERROR(conditions,fn)
        end
        parser.testMode = true
        local retOK, err = pcall(fn)
        parser.testMode = false
        if not retOK then
            --TODO: Error Handling!
            return ERROR(conditions,err)
        end
        return fn
    else
        return alwaysFalse
    end
end

local function fnParseMacro(macroText, conditionFn)
    return function ()
        if conditionFn() then
            if not kps["env"].player.isCasting() then
                kps.runMacro(macroText)
            end
        end
        -- Macro's always return nil,nil to allow other spells to be cast! Actual macro casting is done within this function!
        return nil, nil
    end
end

local function fnParseSpellTable(compiledTable, fnCondition)
    return function ()
        if fnCondition() then
            for _, spellFn in pairs(compiledTable) do
                local spell, target = spellFn()
                if spell ~= nil and target ~= nil then
                    return spell, target
                end
            end
        end
        return nil, nil
    end
end

local function fnParseSpell(spell)
    if type(spell) == "function" then
        return spell
    end
    return function ()
        return spell
    end
end

local function fnParseTarget(target)
    if type(spell) == "function" then
        return target
    elseif target == nil then
        return function ()
            return "target"
        end
    else
        return function ()
            return target
        end
    end
end

local function fnParseDefault(spell, condition, target)
    local spellFn = fnParseSpell(spell)
    local conditionFn = fnParseCondition(condition)
    local targetFn = fnParseTarget(target)
    return function ( )
        if LOG.isDebugEnabled then
            local conditionStr = "true"
            if condition ~= nil then conditionStr = tostring(condition) end
            LOG.debug("Evaluating: '%s'@'%s' IF: %s", spellFn(), targetFn(), conditionStr)
        end
        local spell = spellFn()
        local target = targetFn()
        if conditionFn() and spell.canBeCastAt(target) then
            return spell, target
        end
        return nil, nil
    end
end



--[[
    PARSER:
    conditions    = <condition> | <condition> 'and' <conditions> | <condition> 'or' <conditions>
    condition     = 'not' <condition> | '(' <conditions> ')' | <comparison>
    comparison    = <value> <comparator> <value>
    comparator    = '<' | '<=' | '=' | '==' | '~=' | '>=' | '>'
    value         = <identifier> | STRING | NUMBER | BOOLEAN | 'nil'
    identifier    = IDEN | IDEN'.'<accessor> | IDEN '(' ')' | IDEN'('<parameterlist>')
    accessor      = IDEN | IDEN.<accessor>
    parameterlist = <value> | <value> ',' <parameterlist>
]]

---[[[ Internal Parsing function - DON'T USE !!! ]]--
function parser.pop(tokens)
    local t,v = unpack(tokens[1])
    table.remove(tokens, 1)
    return t,v
end

---[[[ Internal Parsing function - DON'T USE !!! ]]--
function parser.lookahead(tokens)
    if tokens[1] then
        local t,v = unpack(tokens[1])
        return t,v
    else
        return nil
    end
end

---[[[ Internal Parsing function - DON'T USE !!! ]]--
function parser.lookaheadType(tokens)
    return parser.lookahead(tokens)
end

---[[[ Internal Parsing function - DON'T USE !!! ]]--
function parser.lookaheadData(tokens)
    return select(2,parser.lookahead(tokens))
end

---[[[ Internal Parsing function - DON'T USE !!! conditions = <condition> | <condition> 'and' <conditions> | <condition> 'or' <conditions> ]]--
function parser.conditions(tokens, bracketLevel)
    local condition1 = parser.condition(tokens, bracketLevel)

    if tokens[1] then
        local t, v = parser.pop(tokens)
        if t == "keyword" then
            if v == 'and' then
                local condition2 = parser.conditions(tokens, bracketLevel)
                return AND(condition1, condition2)
            elseif v == 'or' then
                local condition2 = parser.conditions(tokens, bracketLevel)
                return OR(condition1, condition2)
            else
                error("Unexpected '" .. tostring(v) .. "' conditions must be combined using keywords 'and' or 'or'!")
            end
        elseif t == "%" then
            local condition2 = parser.conditions(tokens, bracketLevel)
            return MODULO(condition1, condition2)
        elseif t == "-" then
            local condition2 = parser.conditions(tokens, bracketLevel)
            return SUBSTRACT(condition1, condition2)
        elseif t == "+" then
            local condition2 = parser.conditions(tokens, bracketLevel)
            return ADD(condition1, condition2)
        elseif t == "*" then
            local condition2 = parser.conditions(tokens, bracketLevel)
            return MULTIPLY(condition1, condition2)
        elseif t == "/" then
            local condition2 = parser.conditions(tokens, bracketLevel)
            return DIVIDE(condition1, condition2)
        elseif t == "<" then
            local condition2 = parser.conditions(tokens, bracketLevel)
            return LT(condition1, condition2)
        elseif t == "<=" then
            local condition2 = parser.conditions(tokens, bracketLevel)
            return LE(condition1, condition2)
        elseif t == "=" or t == "==" then
            local condition2 = parser.conditions(tokens, bracketLevel)
            return EQ(condition1, condition2)
        elseif t == "~=" then
            local condition2 = parser.conditions(tokens, bracketLevel)
            return NEQ(condition1, condition2)
        elseif t == ">=" then
            local condition2 = parser.conditions(tokens, bracketLevel)
            return GE(condition1, condition2)
        elseif t == ">" then
            local condition2 = parser.conditions(tokens, bracketLevel)
            return GT(condition1, condition2)
        elseif bracketLevel > 0 then
            if t == ")" then
                return condition1
            else
                error("Unexpected '" .. tostring(t) .. "' missing ')'!")
            end
        else
            error("Unexpected '" .. tostring(t) .. "' conditions must be combined using keywords 'and' or 'or'!")
        end
    elseif bracketLevel > 0 then
        error("Unexpected '" .. tostring(t) .. "' missing ')'!")
    else
        return condition1
    end
end

---[[[ Internal Parsing function - DON'T USE !!! -- condition = 'not' <condition> | '(' <conditions> ')' | <comparison> ]]--
function parser.condition(tokens, bracketLevel)
    local t, v = parser.lookahead(tokens)
    if t == "keyword" and v == "not" then
        parser.pop(tokens)
        return NOT(parser.condition(tokens, bracketLevel))
    elseif t == "(" then
        parser.pop(tokens)
        return parser.conditions(tokens, bracketLevel + 1)
    else
        return parser.comparison(tokens)
    end
end


---[[[ Internal Parsing function - DON'T USE !!! -- comparison = <value> <comparator> <value> -- comparator = '<' | '<=' | '=' | '==' | '~=' | '>=' | '>' ]]--
function parser.comparison(tokens)
    local value1 = parser.value(tokens)
    local t = parser.lookaheadType(tokens)
    if t == "<" then
        local t, v = parser.pop(tokens)
        local value2 = parser.value(tokens)
        return LT(value1, value2)
    elseif t == "<=" then
        local t, v = parser.pop(tokens)
        local value2 = parser.value(tokens)
        return LE(value1, value2)
    elseif t == "=" or t == "==" then
        local t, v = parser.pop(tokens)
        local value2 = parser.value(tokens)
        return EQ(value1, value2)
    elseif t == "~=" then
        local t, v = parser.pop(tokens)
        local value2 = parser.value(tokens)
        return NEQ(value1, value2)
    elseif t == ">=" then
        local t, v = parser.pop(tokens)
        local value2 = parser.value(tokens)
        return GE(value1, value2)
    elseif t == ">" then
        local t, v = parser.pop(tokens)
        local value2 = parser.value(tokens)
        return GT(value1, value2)
    else
        return value1
    end
end

---[[[ Internal Parsing function - DON'T USE !!! -- value      = <identifier> | STRING | NUMBER | BOOLEAN | 'nil']]--
function parser.value(tokens)
    local t, v = parser.lookahead(tokens)
    if t == "number" or t == "string" then
        parser.pop(tokens)
        return VALUE(v)
    elseif t == "keyword" and v == "true" then
        parser.pop(tokens)
        return VALUE(true)
    elseif t == "keyword" and v == "false" then
        parser.pop(tokens)
        return VALUE(false)
    elseif t == "keyword" and v == "nil" then
        parser.pop(tokens)
        return VALUE(nil)
    end
    return parser.identifier(tokens)
end

---[[[ Internal Parsing function - DON'T USE !!! -- identifier = IDEN | IDEN'.'<accessor> | IDEN '(' ')' | IDEN'('<parameterlist>')]]--
function parser.identifier(tokens)
    local t, v = parser.pop(tokens)
    if t ~= "iden" then
        error("Invalid identifier '" .. tostring(v) .. "'!")
    end
    local symbol = GLOBAL_IDENTIFIER(v)
    if parser.lookaheadType(tokens) == "." then
        parser.pop(tokens)
        symbol = parser.accessor(tokens, symbol)
    end
    if parser.lookaheadType(tokens) == "(" then
        parser.pop(tokens)
        if parser.lookaheadType(tokens) == ")" then
            parser.pop(tokens)
            return FN(symbol)
        else
            local parameterList = parser.parameterlist(tokens)
            return FN(symbol, unpack(parameterList))
        end
    else
        return symbol
    end

end

---[[[ Internal Parsing function - DON'T USE !!! -- accessor = IDEN | IDEN.<accessor>]]--
function parser.accessor(tokens, base)
    local t, v = parser.pop(tokens)
    if t ~= "iden" then
        error("Invalid identifier '" .. tostring(v) .. "'!")
    end
    local symbol = ACCESSOR(base, v)
    if parser.lookaheadType(tokens) == "." then
        parser.pop(tokens)
        symbol = parser.accessor(tokens, symbol)
    end
    return symbol
end


---[[[ Internal Parsing function - DON'T USE !!! -- parameterlist = <value> | <value> ',' <parameterlist>]]--
function parser.parameterlist(tokens)
    if parser.lookaheadType(tokens) == ")" then
        parser.pop(tokens)
        return nil
    end
    local value = parser.value(tokens)
    local nextToken = parser.lookaheadType(tokens)
    if nextToken == "," then
        parser.pop(tokens)
        return {value, unpack(parser.parameterlist(tokens))}
    elseif nextToken == ")" then
        parser.pop(tokens)
        return {value}
    else
        error("Invalid Token " .. tostring(nextToken) .. " in parameter list!")
    end
end



---[[[ Internal Parsing function - DON'T USE !!! ]]--
local function conditionParser(str)
    if type(str) == "function" then return str end
    local tokens = {}
    local i = 0

    for t,v in kps.lexer.lua(str) do
        i = i+1
        tokens[i] = {t,v}
    end
    local retOK, fn  = pcall(parser.conditions, tokens, 0)
    if not retOK then
        return ERROR(str,fn)
    end
    parser.testMode = true
    local retOK, err = pcall(fn)
    parser.testMode = false
    if not retOK then
        return ERROR(str,err)
    end
    return fn
end

---[[[ Internal Parsing function - DON'T USE !!! ]]--
local function compileSpellTable(unparsedTable)
    local spell = nil
    local conditions = nil
    local target = nil
    local message = nil

    for i, spellTable in pairs(unparsedTable) do
        if type(spellTable) == "table" then
            spell = spellTable[1]
            conditions = spellTable[2]
            if conditions ~= nil and type(conditions)=="string" then
                spellTable[2] = conditionParser(conditions)
            end
            if spell == "nested" then
                compileSpellTable(spellTable[3])
            end
        end
    end
    return unparsedTable
end

local function compileTable(hydraTable)
    local compiledTable = {}
    for _, spellTable in pairs(hydraTable) do
        -- Spell-Table is already a function - just add it!
        if type(spellTable) == "function" then
            table.insert(compiledTable, spellTable)
        -- spell is a sub-table - check which one
        elseif type(spellTable[1]) == "table" and spellTable[1].name == nil then
            local conditionFn = fnParseCondition(spellTable[2])
            -- macro sub-table
            if spellTable[1][1] == "macro" then
                table.insert(compiledTable, fnParseMacro(spellTable[3],conditionFn) )
            -- nested sub-table
            elseif spellTable[1][1] == "nested" then
                compiledSubTable = compileTable(spellTable[3])
                table.insert(compiledTable, fnParseSpellTable(compiledSubTable, conditionFn))
            else
                --TODO: Error!!!
            end
        -- default: {spell(Fn)[[, condition(Fn)[, target(Fn)]]}
        else
            table.insert(compiledTable, fnParseDefault(spellTable[1], spellTable[2], spellTable[3]))
        end
    end
    return compiledTable
end


function kps.parser.parseSpellTable(hydraTable)
    local compiledTable = compileTable(hydraTable)
    return function ()
        for _, spellFn in pairs(compiledTable) do
            local spell, target = spellFn()
            if spell ~= nil and target ~= nil then
                return spell, target
            end
        end
        return nil, nil
    end
end

