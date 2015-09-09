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


local errorCount = 0
local errorLogTable = {}
local function ERROR(condition,msg)
    local ePos = string.find(tostring(msg), ":", string.find(tostring(msg), ":"))
    local eDescription = string.sub(tostring(msg), ePos ~= nil and ePos or 1)
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
        local retOK, fn  = pcall(parser.parse, tokens, 0)
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
            if not kps["env"].player.isCasting then
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
    if type(target) == "function" then
        return function ()
            local targetData = target()
            if type(targetData) == "table" then
                return targetData.unit
            else
                return targetData
            end
        end
    elseif type(target) == "table" then
        return function ()
            return target.unit
        end
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

---[[[ Pop from Token List ]]--
function parser.pop(tokens)
    local t,v = unpack(tokens[1])
    table.remove(tokens, 1)
    return t,v
end

---[[[ Pop from Function/Element List]]--
function parser.popFn(functions)
    local v = functions[1]
    table.remove(functions, 1)
    return v
end

---[[[ Token Lookahead ]]--
function parser.lookahead(tokens)
    if tokens[1] then
        local t,v = unpack(tokens[1])
        return t,v
    else
        return nil
    end
end

---[[[ Token Type Lookahead ]]--
function parser.lookaheadType(tokens)
    return parser.lookahead(tokens)
end

---[[[ Token Data Lookahead ]]--
function parser.lookaheadData(tokens)
    return select(2,parser.lookahead(tokens))
end

function parser.debugTokenList(fn, tokens)
    if LOG.isDebugEnabled then
        local s = ""
        for i,e in pairs(tokens) do
            if type(e) == "function" then
                s = s.."fn"..str(e)
            else 
                local t,v = unpack(e)
                s = s.."["..tostring(t)..":"..tostring(v).."] "
            end
        end
        LOG.debug("%-30s= %s", fn, s)
    end
end

---[[[ Internal Parsing function - DON'T USE !!! ]]--
function parser.parse(tokens)
    parser.debugTokenList("parser.parse", tokens)
    return parser.parseBrackets(tokens, 0)
end

function parser.parseBrackets(tokens, bracketLevel)
    local parsedBrackets = {}
    parser.debugTokenList(" * parse.parseBrackets["..bracketLevel.."]", tokens)
    local parameterList = false
    while #tokens > 0 do
        local t, v = parser.pop(tokens)
        if t == "(" then
            table.insert(parsedBrackets, currentBracket)
            table.insert(parsedBrackets, {"()", parser.parseBrackets(tokens, bracketLevel + 1)})
            parser.debugTokenList(" * parse.parseBrackets["..bracketLevel.."]", tokens)
        elseif t == ")" then
            if bracketLevel == 0 then
                error("Too many closing brackets!")
            end
            --return parser.parseAnd(parsedBrackets)
            if parameterList then 
                return parser.parseParameterList(parsedBrackets)
            else
                return parser.parseAnd(parsedBrackets)
            end
        else
            parameterList = parameterList or t == ","
            table.insert(parsedBrackets, {t, v})
        end
    end
    if bracketLevel ~= 0 then
        error("Missing closing brackets!")
    end
    return parameterList and parser.parseParameterList(parsedBrackets) or parser.parseAnd(parsedBrackets)
end


local function PARAMETER_LIST(parameters)
    local params_exec = {}
    return function()
        for i,v in ipairs(parameters) do
            params_exec[i] = v()
        end
        return unpack(params_exec)
    end
end
function parser.parseParameterList(parseBrackets)
    parser.debugTokenList("  * parse.parseParameterList", parseBrackets)
    local parsedParameters = {}
    local currentParameter = {}
    while #parseBrackets > 0 do
        local t, v = parser.pop(parseBrackets)
        if t == "," then
            table.insert(parsedParameters, parser.parseAnd(currentParameter))
            currentParameter = {}
        else
            table.insert(currentParameter, {t, v})
        end
    end
    table.insert(parsedParameters, parser.parseAnd(currentParameter))
    return PARAMETER_LIST(parsedParameters)
end

local function AND(operands)
    if #operands == 1 then
        return parser.popFn(operands)
    end
    local o1 = parser.popFn(operands)
    local o2 = AND(operands)
    
    return function()
        return o1() and o2()
    end
end
function parser.parseAnd(parseBrackets)
    parser.debugTokenList("  * parse.parseAnd", parseBrackets)
    local parsedAnds = {}
    local currentAnd = {}
    while #parseBrackets > 0 do
        local t, v = parser.pop(parseBrackets)
        if t == "keyword" and v == 'and' then
            table.insert(parsedAnds, parser.parseOr(currentAnd))
            currentAnd = {}
        else
            table.insert(currentAnd, {t, v})
        end
    end
    table.insert(parsedAnds, parser.parseOr(currentAnd))
    return AND(parsedAnds)
end

local function OR(operands)
    if #operands == 1 then
        return parser.popFn(operands)
    end
    local o1 = parser.popFn(operands)
    local o2 = OR(operands)
    
    return function()
        return o1() or o2()
    end
end
function parser.parseOr(parsedAnd)
    parser.debugTokenList("   * parse.parseOr", parsedAnd)
    local parsedOrs = {}
    local currentOr = {}
    while #parsedAnd > 0 do
        local t, v = parser.pop(parsedAnd)
        if t == "keyword" and v == 'or' then
            table.insert(parsedOrs, parser.parseComparison(currentOr))
            currentOr = {}
        else
            table.insert(currentOr, {t, v})
        end
    end
    table.insert(parsedOrs, parser.parseComparison(currentOr))
    return OR(parsedOrs)
end


local function LE(o1, o2)
    return function()
        return o1() <= o2()
    end
end

local function LT(o1, o2)
    return function()
        return o1() < o2()
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
parser.comperatorFunctions = {}
parser.comperatorFunctions["<="]= LE
parser.comperatorFunctions["<"]= LT
parser.comperatorFunctions["="]= EQ
parser.comperatorFunctions["=="]= EQ
parser.comperatorFunctions["~="]= NEQ
parser.comperatorFunctions[">="]= GE
parser.comperatorFunctions[">"]= GT

function parser.parseComparison(parsedOr)
    parser.debugTokenList("    * parse.parseComparison", parsedOr)
    local t, v = parser.lookahead(parsedOr)
    if t == "keyword" and v == "not" then
        parser.pop(parsedOr)
        return NOT(parser.parseComparison(parsedOr))
    end
    local leftHand = {}
    local rightHand = {}
    local comperator = nil
    local currentSide = leftHand
    while #parsedOr > 0 do
        local t, v = parser.pop(parsedOr)
        if t == "<" or t == "<=" or t == "=" or t == "==" or t == "~=" or t == ">=" or t == ">" then
            if comperator ~= nil then
                error("Unexpected '" .. tostring(t) .. "' expressions may only have one comperator!")
            end
            comperator = t
            currentSide = rightHand
        else
            table.insert(currentSide, {t, v})
        end
    end
    if comperator == nil then
        return parser.parseAddition(leftHand)
    else
        local cmpFn = parser.comperatorFunctions[comperator]
        if cmpFn == nil then error("Unknown Comperator '"..comperator .. "'!") end
        return cmpFn(parser.parseAddition(leftHand), parser.parseAddition(rightHand))
    end
end


local function ADD(operands)
    if #operands == 1 then
        return parser.popFn(operands)
    end
    local o1 = parser.popFn(operands)
    local op = parser.popFn(operands)
    local o2 = ADD(operands)
    if op == "+" then
        return function()
            return o1() + o2()
        end
    elseif op == "-" then
        return function()
            return o1() - o2()
        end
    else
        error("Unexpected Multiply Operator '" .. op .. "'!")
    end
end
function parser.parseAddition(expression)
    parser.debugTokenList("    * parse.parseAddition", expression)
    local parsedAdditions = {}
    local currentAddition = {}
    while #expression > 0 do
        local t, v = parser.pop(expression)
        if t == "+" or t == "-" then
            table.insert(parsedAdditions, parser.parseMultiplication(currentAddition))
            table.insert(parsedAdditions, t)
            currentAddition = {}
        else
            table.insert(currentAddition, {t, v})
        end
    end
    table.insert(parsedAdditions, parser.parseMultiplication(currentAddition))
    return ADD(parsedAdditions)
end


local function MULTIPLY(operands)
    if #operands == 1 then
        return parser.popFn(operands)
    end
    local o1 = parser.popFn(operands)
    local op = parser.popFn(operands)
    local o2 = MULTIPLY(operands)
    if op == "*" then
        return function()
            return o1() * o2()
        end
    elseif op == "/" then
        return function()
            return o1() / o2()
        end
    else
        error("Unexpected Multiply Operator '" .. op .. "'!")
    end
end
function parser.parseMultiplication(expression)
    parser.debugTokenList("     * parse.parseMultiplication", expression)
    local parsedMultiplications = {}
    local currentMultiplication = {}
    while #expression > 0 do
        local t, v = parser.pop(expression)
        if t == "*" or t == "/" then
            table.insert(parsedMultiplications, parser.parseModulo(currentMultiplication))
            table.insert(parsedMultiplications, t)
            currentMultiplication = {}
        else
            table.insert(currentMultiplication, {t, v})
        end
    end
    table.insert(parsedMultiplications, parser.parseModulo(currentMultiplication))
    return MULTIPLY(parsedMultiplications)
end


local function MODULO(operands)
    if #operands == 1 then
        return parser.popFn(operands)
    end
    local o1 = parser.popFn(operands)
    local o2 = MODULO(operands)
    return function()
        return o1() % o2()
    end
end
function parser.parseModulo(expression)
    parser.debugTokenList("      * parse.parseModulo", expression)
    local parsedModulos = {}
    local currentModulo = {}
    while #expression > 0 do
        local t, v = parser.pop(expression)
        if t == "%" then
            table.insert(parsedModulos, parser.parseExpression(currentModulo))
            currentModulo = {}
        else
            table.insert(currentModulo, {t, v})
        end
    end
    table.insert(parsedModulos, parser.parseExpression(currentModulo))
    return MODULO(parsedModulos)
end


local function VALUE(val)
    return function()
        return val
    end
end
function parser.parseExpression(expression)
    parser.debugTokenList("       * parse.parseExpression", expression)
    local t, v = parser.lookahead(expression)
    if t == "number" or t == "string" then
        parser.pop(expression)
        return VALUE(v)
    elseif t == "keyword" and v == "true" then
        parser.pop(expression)
        return VALUE(true)
    elseif t == "keyword" and v == "false" then
        parser.pop(expression)
        return VALUE(false)
    elseif t == "keyword" and v == "nil" then
        parser.pop(expression)
        return VALUE(nil)
    end
    return parser.parseIdentifier(expression)
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
local function FN(fn,param)
    return function()
        return fn()(param())
    end
end
function parser.parseIdentifier(tokens)
    parser.debugTokenList("        * parse.parseExpression", tokens)
    local t, v = parser.pop(tokens)
    if t == "()" then
        return v
    end
    if t ~= "iden" then
        error("Invalid identifier '" .. tostring(v) .. "'!")
    end
    local symbol = GLOBAL_IDENTIFIER(v)
    if parser.lookaheadType(tokens) == "." then
        parser.pop(tokens)
        symbol = parser.parseAccessor(tokens, symbol)
    end
    if parser.lookaheadType(tokens) == "()" then
        _,v = parser.pop(tokens)
            return FN(symbol, v)
    else
        return symbol
    end

end


---[[[ Internal Parsing function - DON'T USE !!! -- accessor = IDEN | IDEN.<accessor>]]--
function parser.parseAccessor(tokens, base)
    local t, v = parser.pop(tokens)
    if t ~= "iden" then
        error("Invalid identifier '" .. tostring(v) .. "'!")
    end
    local symbol = ACCESSOR(base, v)
    if parser.lookaheadType(tokens) == "." then
        parser.pop(tokens)
        symbol = parser.parseAccessor(tokens, symbol)
    end
    return symbol
end



---[[[ Internal Parsing function - DON'T USE !!! conditions = <condition> | <condition> 'and' <conditions> | <condition> 'or' <conditions> ]]--
function parser.conditions(tokens)
    local parsedBrackets = parser.parseBrackets(tokens, {}, 0)
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
        local value1 = parser.value(tokens)
        local arithmetic = parser.arithmetic(tokens, value1)
        if arithmetic~=nil then
            return parser.comparison(tokens, arithmetic)
        else
            return parser.comparison(tokens, value1)
        end
    end
end


---[[[ Internal Parsing function - DON'T USE !!! -- arithmetic = <value> <arithmetic-operator> <value> -- arithmetic-operator = '%' | '+' | '-' | '*' | '/' ]]--
function parser.arithmetic(tokens, value1)

    local t = parser.lookaheadType(tokens)
    if t == "%" then
        local t, v = parser.pop(tokens)
        local value2 = parser.value(tokens)
        local arithmetic2 = parser.arithmetic(tokens, value2)
        return MODULO(value1, arithmetic2==nil and value2 or arithmetic2)
    elseif t == "-" then
        local t, v = parser.pop(tokens)
        local value2 = parser.value(tokens)
        local arithmetic2 = parser.arithmetic(tokens, value2)
        return SUBSTRACT(value1, arithmetic2==nil and value2 or arithmetic2)
    elseif t == "+" then
        local t, v = parser.pop(tokens)
        local value2 = parser.value(tokens)
        local arithmetic2 = parser.arithmetic(tokens, value2)
        return ADD(value1, arithmetic2==nil and value2 or arithmetic2)
    elseif t == "*" then
        local t, v = parser.pop(tokens)
        local value2 = parser.value(tokens)
        local arithmetic2 = parser.arithmetic(tokens, value2)
        return MULTIPLY(value1, arithmetic2==nil and value2 or arithmetic2)
    elseif t == "/" then
        local t, v = parser.pop(tokens)
        local value2 = parser.value(tokens)
        local arithmetic2 = parser.arithmetic(tokens, value2)
        return DIVIDE(value1, arithmetic2==nil and value2 or arithmetic2)
    else
        return nil
    end
end

---[[[ Internal Parsing function - DON'T USE !!! -- comparison = <value> <comparator> <value> -- comparator = '<' | '<=' | '=' | '==' | '~=' | '>=' | '>' ]]--
function parser.comparison(tokens, value1)
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
    local retOK, fn  = pcall(parser.parse, tokens)
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

