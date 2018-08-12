--[=[
H.H.T.D. World of Warcraft Add-on
Copyright (c) 2009-2018 by John Wellesz (hhtd@2072productions.com)
All rights reserved

Version 2.4.9

In World of Warcraft healers have to die. This is a cruel truth that you're
taught very early in the game. This add-on helps you influence this unfortunate
destiny in a way or another depending on the healer's side...

More information: https://www.wowace.com/projects/h-h-t-d

-----
    utils.lua
-----


--]=]

local ERROR     = 1;
local WARNING   = 2;
local INFO      = 3;
local INFO2     = 4;


local ADDON_NAME, T = ...;
local HHTD = T.HHTD;

local HHTD_C = T.HHTD.Constants;

local _G        = _G;
local pairs     = _G.pairs;
local tostring  = _G.tostring;
local table     = _G.table;
local select    = _G.select;
local type      = _G.type;
local date      = _G.date;
local debugstack= _G.debugstack;

function HHTD:MakePlayerName (name) --{{{
    if not name then name = "NONAME" end
    return "|Hplayer:" .. name .. "|h" .. (name):upper() .. "|h";
end --}}}

function HHTD:ColorText (text, color) --{{{

    if type(text) ~= "string" then
        text = tostring(text)
    end

    return "|c".. color .. text .. "|r";
end --}}}


-- Class coloring related functions {{{
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS;

HHTD_C.ClassesColors = { };

local LC = _G.LOCALIZED_CLASS_NAMES_MALE;

function HHTD:GetClassColor (englishClass) -- {{{
    if not HHTD_C.ClassesColors[englishClass] then
        if RAID_CLASS_COLORS and RAID_CLASS_COLORS[englishClass] then
            HHTD_C.ClassesColors[englishClass] = { RAID_CLASS_COLORS[englishClass].r, RAID_CLASS_COLORS[englishClass].g, RAID_CLASS_COLORS[englishClass].b };
        else
            HHTD_C.ClassesColors[englishClass] = { 0.63, 0.63, 0.63 };
        end
    end
    return unpack(HHTD_C.ClassesColors[englishClass]);
end -- }}}

HHTD_C.HexClassColor = { };

function HHTD:GetClassHexColor(englishClass) -- {{{

    if not HHTD_C.HexClassColor[englishClass] then

        local r, g, b = self:GetClassColor(englishClass);

        HHTD_C.HexClassColor[englishClass] = ("FF%02x%02x%02x"):format( r * 255, g * 255, b * 255);

    end

    return HHTD_C.HexClassColor[englishClass];
end -- }}}

function HHTD:CreateClassColorTables () -- {{{
    if RAID_CLASS_COLORS then
        local class, colors;
        for class in pairs(RAID_CLASS_COLORS) do
            if LC[class] then -- thank to a wonderful add-on that adds the wrong translation "Death Knight" to the global RAID_CLASS_COLORS....
                HHTD:GetClassHexColor(class);
            else
                RAID_CLASS_COLORS[class] = nil; -- Eat that!
                self:Print("|cFFFF0000Stupid value found in _G.RAID_CLASS_COLORS table|r\nThis will cause many issues (tainting), HHTD will display this message until the culprit add-on is fixed or removed, the Stupid value is: '", class, "'");
            end
        end
    else
        HHTD:Debug(ERROR, "global RAID_CLASS_COLORS does not exist...");
    end
end -- }}}
-- }}}

function HHTD:Error(message)
    UIErrorsFrame:AddMessage("HHTD: " .. message, 1, 0, 0, 1, UIERRORS_HOLD_TIME);
    self:Print(HHTD:ColorText(message, 'FFFF3030'));
    return message;
end

-- function HHTD:UnitName(Unit) {{{
local UnitName = _G.UnitName;
function HHTD:UnitName(Unit)
    local name, server = UnitName(Unit);
        if ( server and server ~= "" ) then
            return name.."-"..server;
        else
            return name;
        end 
end
-- }}}

-- function HHTD:RotateTexture(self, degrees) {{{
local mrad = _G.math.rad;
local mcos = _G.math.cos;
local msin = _G.math.sin;
-- inspired from http://www.wowwiki.com/SetTexCoord_Transformations#Simple_rotation_of_square_textures_around_the_center
function HHTD:RotateTexture(self, degrees)
	local angle = mrad(degrees)
	local cos, sin = mcos(angle), msin(angle)
        self:SetTexCoord(
        0.5-sin, 0.5+cos,
        0.5+cos, 0.5+sin,
        0.5-cos, 0.5-sin,
        0.5+sin, 0.5-cos
        );
end -- }}}

--  function HHTD:Debug(...) {{{
do
    local Debug_Templates = {
        [ERROR]     = "|cFFFF2222Debug:|cFFCC4444[%0.3f]:|r|cFFFF5555",--3
        [WARNING]   = "|cFFFF2222Debug:|cFFCC4444[%0.3f]:|r|cFF55FF55",--2
        [INFO]      = "|cFFFF2222Debug:|cFFCC4444[%0.3f]:|r|cFF9999FF",--1
        [INFO2]     = "|cFFFF2222Debug:|cFFCC4444[%0.3f]:|r|cFFFF9922",--1
        [false]     = "|cFFFF2222Debug:|cFFCC4444[%0.3f]:|r",
    }
    local Debug_Levels = {
        [INFO2]     = 1,
        [INFO]      = 1,
        [WARNING]   = 2,
        [ERROR]     = 3,
        [false]     = 3,
    }
    local select, type, debugprofilestop = _G.select, _G.type, _G.debugprofilestop;

    local timerStart = debugprofilestop();
    function HHTD:Debug(...)

        -- if Decursive is loaded then use its debug report facility...
        if (...) == ERROR and DecursiveRootTable then
            local message = {'HHTD Debug error:', select(2, ...)};
            message[#message + 1] = '\nSTACK:\n' .. debugstack(2);
            DecursiveRootTable._HHTDErrors = DecursiveRootTable._HHTDErrors + 1;
            DecursiveRootTable._AddDebugText(unpack(message));
        end

        if not HHTD.db or not HHTD.db.global.Debug then return end;

        local template = type((...)) == "number" and (...) or false;

        if HHTD.db.global.DebugLevel and HHTD.db.global.DebugLevel > Debug_Levels[template] then
            return;
        end

        local DebugHeader = (Debug_Templates[template]):format((debugprofilestop() - timerStart) / 1000);

        if template then
            self:Print(DebugHeader, select(2, ...));
        else
            self:Print(DebugHeader, ...);
        end
    end
end -- }}}

-- function HHTD:GetOPtionPath(info) {{{
function HHTD:GetOPtionPath(info)
    return table.concat(info, "->");
end -- }}}

-- Iterators

function HHTD:pairs_ordered (t, reverse, SortKey) -- Not to be used where performance and memory are important

    if not reverse then
        reverse = 1;
    end

    local sortedTable_Keys  = {};


    local i = 1;
    -- store the keys
    for key, value in pairs(t) do

        if SortKey and not value[SortKey] then
            self:Debug(ERROR, "listOrderedIter(): invalid SortKey", SortKey, key, value, value.name);
            error("listOrderedIter(): invalid SortKey");

            return nil;
        end

        sortedTable_Keys[i] = key;
        i = i + 1;
    end


    local function sort (a, b)
        if SortKey then
            if reverse then
                return t[a][SortKey] > t[b][SortKey];
            else
                return t[a][SortKey] < t[b][SortKey];
            end
        else
            if reverse then
                return t[a] > t[b];
            else
                return t[a] < t[b];
            end
        end
    end

    -- sort the keys according to the given parameters
    table.sort(sortedTable_Keys, sort);

    i = 0;
    -- return an iterator
    return function ()
        i = i + 1;

        if sortedTable_Keys[i] then
            return sortedTable_Keys[i], t[sortedTable_Keys[i]];
        end

    end, t, 0;

end

function HHTD:AddDelayedFunctionCall(callID, functionLink, ...)

    
    if (not self.DelayedFunctionCalls[callID]) then 
        self.DelayedFunctionCalls[callID] =  {["func"] = functionLink, ["args"] =  {...}};
        self.DelayedFunctionCallsCount = self.DelayedFunctionCallsCount + 1;
    elseif select("#",...) > 1 then -- if we had more than the function reference and its object

        local args = self.DelayedFunctionCalls[callID].args;

        for i=1,select("#",...), 1 do
            args[i]=select(i, ...);
        end

    end
end

local function BadLocalTest (localtest)
        HHTD:Print(HHTD.Localized_Text[localtest]);
end

function HHTD:MakeError(something)

    local testlocal = "test local";
    local testbiglocal = HHTD;

    if something == 1 then
        -- Make something forbidden
        TargetUnit('player');
        return;
    elseif something == 2 then
        BadLocalTest("Bad local");
        return;
    end

    local errorf = function () testErrorCapturing(testlocal); end;

    errorf();
end

--[===[@debug@
function HHTD:Hickup(mul)
    if not mul then mul = 1 end
    local t = 0;

    for i=1, mul * 1000000, 1 do
        t = t + 1
    end

    self:Debug(WARNING, 'Hickup ', t);
end
--@end-debug@]===]


function HHTD:FatalError (TheError)

    if not StaticPopupDialogs["HHTD_ERROR_FRAME"] then
        StaticPopupDialogs["HHTD_ERROR_FRAME"] = {
            text = "|cFFFF0000HHTD Fatal Error:|r\n%s",
            button1 = "OK",
            OnAccept = function()
                return false;
            end,
            timeout = 0,
            whileDead = 1,
            hideOnEscape = 1,
            showAlert = 1,
            preferredIndex = 3,
        };
    end

    StaticPopup_Show ("HHTD_ERROR_FRAME", TheError);
end

function HHTD:GetBAddon (StackLevel)
    local stack = debugstack(1 + StackLevel,2,0);
    if not stack:lower():find("\\libs\\")
        and not stack:find("[/\\]CallbackHandler")
        and not stack:find("[/\\]AceTimer")
        and not stack:find("[/\\]AceHook")
        and not stack:find("[/\\]AceEvent") then

        if stack:find("[/\\]"..ADDON_NAME) then
            self:Debug(ERROR, "GetBAddon failed!"); -- XXX to test
            return false;
        end

        return stack:match("[/\\]AddOns[/\\]([^/\\]+)[/\\]"), stack;
    else
        self:Debug(WARNING, 'SetScript called but not reported:', stack);
        return false;
    end
end

-- tcopy: recursively copy contents of one table to another
function HHTD:tcopy(to, from)   -- "to" must be a table (possibly empty)
    if (type(from) ~= "table") then 
        return error(("HHTD:tcopy: bad argument #2 'from' must be a table, got '%s' instead"):format(type(from)),2);
    end

    if (type(to) ~= "table") then 
        return error(("HHTD:tcopy: bad argument #1 'to' must be a table, got '%s' instead"):format(type(to)),2);
    end
    for k,v in pairs(from) do
        if(type(v)=="table") then
            if not to[k] then
                to[k] = {}; -- this generates garbage
            elseif type(to[k]) ~= 'table' then
                self:Debug(ERROR, k, to[k], 'is not a table');
            end
            self:tcopy(to[k], v);
        else
            to[k] = v;
        end
    end
end

