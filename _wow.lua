--[[[
@module WoW Functions
@description
Definition of WoW Functions for testing without WoW.
]]--

function GetTime()
    return 121412
end

function UnitExists(unit)
    return true
end
function UnitHealth(unit)
    return 75000
end
function UnitHealthMax(unit)
    return 300000
end
function UnitGetIncomingHeals(unit)
    return 125000
end
function UnitMana(unit)
    return 230000
end
function UnitManaMax(unit)
    return 300000
end
function UnitPower(token, idx,flag)
    return 4
end
function GetSpellInfo(id)
    return "SpellForID:"..id
end
function UnitClass(unit)
    return "WARLOCK", "DESTRUCTION", 9
end
function GetSpecialization()
    return 3
end
function GetUnitSpeed(unit)
    return 0
end
function UnitCastingInfo(unit)
    -- name, subText, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo("unit")
    return "SpellNameCasting", "SpellText", "SpellSubText", "SpellTexture", nil, 1000, 1002, false, nil, false
end
function UnitChannelInfo( ... )
    --  local spellName,_,_,_,_,endTime,_,_,_ = UnitChannelInfo(self.unit)
    return "SpellChanneled", nil, nil, nil, 1, 5, nil, nil, nil
end
function debugstack(a,b,c)
    return "file.lua:1"
end
function UnitBuff( ... )
    -- local auraName, _, _, count, _, duration, expirationTime, castBy, _, _, buffId = UnitBuff(unit, i)
    return  nil, nil, nil, 3, nil, 50, 1001, "me", nil, nil, 5
end
function UnitDebuff( ... )
    -- local auraName, _, _, count, _, duration, expirationTime, castBy, _, _, buffId = UnitBuff(unit, i)
    return "UnitDebuffAuraName", nil, nil, 3, nil, 50, 1001, "me", nil, nil, 5
end
function GetSpellCharges( ... )
    return 1
end
function IsUsableSpell( ... )
    return true
end
function IsShiftKeyDown( ... )
   return false
end
function IsControlKeyDown( ... )
   return false
end
function IsAltKeyDown( ... )
   return false
end
function GetCurrentKeyBoardFocus( ... )
   return false
end
function GetLocale( ... )
    return "enUS"
end
function GetSpellTabInfo( ... )
    return nil, nil, 3, 40, nil
end
function GetSpellBookItemName( ... )
    return "SpellBookItem1", 5, 1
end
function GetSpellBookItemInfo( ... )
    return 1, 1234,0,0,10,40
end
function IsHarmfulSpell( ... )
    return true
end
function UnitIsUnit( ... )
    return true
end
function UnitIsVisible( ... )
    return true
end
function UnitIsDeadOrGhost( ... )
    return 0
end
function GetUnitName(unit)
    return "NameOf:"..tostring(unit)
end
function UnitCanAttack( ... )
    return true
end
function UnitIsEnemy( ... )
    return true
end
function RunMacroText( ... )
end
function CreateFrame( ... )
    local frame = {}
    local texture = {}
    texture.SetPoint = function ( ... ) end
    texture.SetTexCoord = function ( ... ) end
    texture.SetTexture = function ( ... ) end
    texture.SetParent = function ( ... ) end
    texture.SetVertexColor = function ( ... ) end
    texture.SetParent = function ( ... ) end

    frame.SetScript = function ( ... ) end
    frame.RegisterEvent = function ( ... ) end
    frame.SetMovable = function ( ... ) end
    frame.EnableMouse = function ( ... ) end
    frame.RegisterForDrag = function ( ... ) end
    frame.SetPoint = function ( ... ) end
    frame.SetScale = function ( ... ) end
    frame.SetWidth = function ( ... ) end
    frame.SetHeight = function ( ... ) end
    frame.CreateTexture = function ( ... ) return texture end
    frame.RegisterForDrag = function ( ... ) end
    frame.RegisterForClicks = function ( ... ) end
    frame.Show = function ( ... ) end
    return frame
end
function UnitAffectingCombat( ... )
    return 1
end
function hooksecurefunc( ... )
end
function IsMounted( ... )
    return false
end
function CastSpellByName(a,b)
    print("CASTING: "..a.."@"..b)
end
function UnitStat( ... )
    return 5,6,1,0
end
function GetMastery( ... )
    return 100
end
function GetCritChance( ... )
    return 100
end
function UnitSpellHaste( ... )
    return 100
end
function GetCritChance( ... )
    return 100
end
function GetSpellCooldown( ... )
    return 0
end
function SpellHasRange( ... )
    return true
end
function HasPetSpells( ... )
    return 3
end
function UnitGUID( ... )
    return "0x242345"
end
function LibStub( ... )
    return {}
end
