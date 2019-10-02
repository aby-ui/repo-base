--[[
    This file is part of Decursive.

    Decursive (v 2.7.6.4) add-on for World of Warcraft UI
    Copyright (C) 2006-2019 John Wellesz (Decursive AT 2072productions.com) ( http://www.2072productions.com/to/decursive.php )

    Starting from 2009-10-31 and until said otherwise by its author, Decursive
    is no longer free software, all rights are reserved to its author (John Wellesz).

    The only official and allowed distribution means are www.2072productions.com, www.wowace.com and curse.com.
    To distribute Decursive through other means a special authorization is required.


    Decursive is inspired from the original "Decursive v1.9.4" by Patrick Bohnet (Quu).
    The original "Decursive 1.9.4" is in public domain ( www.quutar.com )

    Decursive is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY.

    This file was last updated on 2019-09-09T00:15:26Z
--]]
-------------------------------------------------------------------------------

local addonName, T = ...;
-- big ugly scary fatal error message display function {{{
if not T._FatalError then
-- the beautiful error popup : {{{ -
StaticPopupDialogs["DECURSIVE_ERROR_FRAME"] = {
    text = "|cFFFF0000Decursive Error:|r\n%s",
    button1 = "OK",
    OnAccept = function()
        return false;
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
    showAlert = 1,
    preferredIndex = 3,
    }; -- }}}
T._FatalError = function (TheError) StaticPopup_Show ("DECURSIVE_ERROR_FRAME", TheError); end
end
-- }}}
if not T._LoadedFiles or not T._LoadedFiles["Dcr_LDB.lua"] then
    if not DecursiveInstallCorrupted then T._FatalError("Decursive installation is corrupted! (Dcr_LDB.lua not loaded)"); end;
    DecursiveInstallCorrupted = true;
    return;
end
T._LoadedFiles["Dcr_utils.lua"] = false;

local D = T.Dcr;

local L = D.L;
local LC = D.LC;
local DC = T._C;

T._CatchAllErrors = 'LibQTip';
local LibQTip = LibStub('LibQTip-1.0');
T._CatchAllErrors = false;

local _G                = _G;
local pairs             = _G.pairs;
local ipairs            = _G.ipairs;
local type              = _G.type;
local tostring          = _G.tostring;
local unpack            = _G.unpack;
local select            = _G.select;
local str_sub           = _G.string.sub;
local str_upper         = _G.string.upper;
local str_lower         = _G.string.lower;
local str_format        = _G.string.format;
local str_split         = _G.strsplit;
local table             = _G.table;
local t_remove          = _G.table.remove;
local t_insert          = _G.table.insert;
local UnitName          = _G.UnitName;
local UnitIsPlayer      = _G.UnitIsPlayer;
local string            = _G.string;
local tonumber          = _G.tonumber;
local UnitGUID          = _G.UnitGUID;
local band              = _G.bit.band;
local GetTime           = _G.GetTime;
local IsSpellInRange    = _G.IsSpellInRange;
local UnitInRange       = _G.UnitInRange;
local debugprofilestop  = _G.debugprofilestop;
local GetSpellInfo      = _G.GetSpellInfo;
local GetItemInfo       = _G.GetItemInfo;

-- replacement for the default function as it is bugged in WoW5 (it returns nil for some spells such as resto shamans' 'Purify Spirit')
D.IsSpellInRange = function (spellName, unit)
    local range = IsSpellInRange(spellName, unit);

    if range ~= nil then
        return range;
    else
        --[===[@debug@
        D:Debug('IsSpellInRange() returned nil for', spellName, unit);
        --@end-debug@]===]
        if unit == 'player' or unit == 'pet' then
            return 1;
        else
            return (UnitInRange(unit)) and 1 or 0;
        end
    end

end


function D:ColorText (text, color)
    return "|c".. color .. text .. "|r";
end

function D:ColorTextNA (text, color)
    return "|cFF".. color .. text .. "|r";
end

function D:RemoveColor (text)
    return str_sub(text, 11, -3);
end

function D:MakePlayerName (name) --{{{
    if not name then name = "NONAME" end
    return "|cFFFFAA22|Hplayer:" .. name .. "|h" .. str_upper(name) .. "|h|r";
end --}}}

function D:UnitIsPet (Unit)
    return (Unit:find('pet')) ~= nil;
end

function D:PetUnitName (Unit, Check) -- {{{
    local Name = (self:UnitName(Unit));

    if not Name or Name == DC.UNKNOWN  then
        Name = DC.UNKNOWN .. "-" .. Unit;
        D:Debug("PetUnitName(): Name of %s is unknown", Unit);
    end

    if not Check or self:UnitIsPet(Unit) then
        Name = ("%s-%s"):format(DC.PET, Name);
    end

    return Name;

end -- }}}

function D:UnitName(Unit)
    local name, server = UnitName(Unit);
        if ( server and server ~= "" ) then
            return name.."-"..server;
        else
            return name;
        end
end

local function isFormattedString(string)
    return type(string)=='string' and (string:find("%%[cdEefgGiouXxsq]")) or false;
end

local function UseFormatIfPresent(...)
    if not isFormattedString((select(1,...))) then
        return ...;
    else
        return (select(1,...)):format(select(2, ...));
    end
end

function D:NumToHexStr(number)
    if type(number) == 'number' then
        return ("%X"):format(number);
    else
        return tostring(number);
    end
end




function D:Println( ... ) --{{{

    if D.profile.Print_ChatFrame then
        self:Print(D.Status.OutputWindow, UseFormatIfPresent(...));
    end
    if D.profile.Print_CustomFrame then
        self:Print(DecursiveTextFrame, UseFormatIfPresent(...));
    end
end --}}}

function D:ColorPrint (r,g,b, ... )

    local datas = {UseFormatIfPresent(...)};

    local ColorHeader = ("|cff%02x%02x%02x"):format(r * 255, g * 255, b * 255);

    t_insert(datas, 1, ColorHeader);
    t_insert(datas, #datas + 1, "|r");

    if D.profile and D.profile.Print_ChatFrame then
        self:Print(D.Status.OutputWindow, ColorHeader, unpack(datas));
    end

    if D.profile and D.profile.Print_CustomFrame then
        self:Print(DecursiveTextFrame, ColorHeader, unpack(datas));
    end

    if not self.db then
        self:Print(ColorHeader, unpack(datas));
    end

end

function D:errln( ... ) --{{{
    if not D.db or D.profile.Print_Error then
        self:ColorPrint(1,0,0,...);

    end
end --}}}

do
    local timerStart = debugprofilestop();

    local function debugStyle(...)
        return ("|cFF00AAAADebug:(%0.3f)|r"):format((debugprofilestop() - timerStart) / 1000), ...;
    end

    function D:Debug(...)
        if self.debug then
            self:Print(debugStyle(UseFormatIfPresent(...)));
        end
    end
end


function D:tremovebyval(tab, val) -- {{{
    for k,v in pairs(tab) do
        if(v==val) then
            t_remove(tab, k);
            return true;
        end
    end
    return false;
end -- }}}

function D:tMap(t, f)
    local mapped_t = {};
    for k,v in pairs(t) do
        mapped_t[k] = f(v);
    end
    return mapped_t;
end

function D:tAsString(t, indent) -- debugging function

    if type(t) ~= 'table' then
        return tostring(t)
    end

    if indent == nil then
        indent = "  ";
    end

    local s = "\n" .. indent .. "{" .. "\n"
    for k,v in pairs(t) do
        s = s .. indent .. indent .. ("[%s] = [%s],\n"):format(tostring(k), self:tAsString(v, indent .. "  "))
    end
    return s .. indent .. "}"
end

function D:tcheckforval(tab, val) -- {{{
    local k, v;
    if tab then
        for k,v in pairs(tab) do
            if v==val then
                return true;
            end
        end
    end
    return false;
end -- }}}

-- tcopy: recursively copy contents of one table to another
function D:tcopy(to, from)   -- "to" must be a table (possibly empty)
    if (type(from) ~= "table") then
        return error(("D:tcopy: bad argument #2 'from' must be a table, got '%s' instead"):format(type(from)),2);
    end

    if (type(to) ~= "table") then
        return error(("D:tcopy: bad argument #1 'to' must be a table, got '%s' instead"):format(type(to)),2);
    end
    for k,v in pairs(from) do
        if(type(v)=="table") then
            to[k] = {}; -- this generate garbage
            D:tcopy(to[k], v);
        else
            to[k] = v;
        end
    end
end


-- tcopycallback: recursively copy contents of one table to another calling a callback before storing the new values
function D:tcopycallback(to, from, CallBack) -- "to" must be a table (possibly empty)
    if (type(from) ~= "table") then
        return error(("D:tcopycallback: bad argument #2 'from' must be a table, got '%s' instead"):format(type(from)),2);
    end

    if (type(to) ~= "table") then
        return error(("D:tcopycallback: bad argument #1 'to' must be a table, got '%s' instead"):format(type(to)),2);
    end
    if (type(CallBack) ~= "function") then
        return error(("D:tcopycallback: bad argument #3 'CallBack' must be a function ref, got '%s' instead"):format(type(CallBack)),2);
    end
    for k,v in pairs(from) do
        if(type(v)=="table") then
            to[k] = {}; -- this generate garbage
            D:tcopycallback(to[k], v, CallBack);
        else
            to[k] = CallBack(v);
        end
    end
end

function D:tGiveValueIndex(tab, val)
    for k,v in pairs(tab) do
        if v==val then
            return k;
        end
    end
    return nil;
end

function D:tSortUsingKeys(tab)
    local SortedTable = {};
    local Keys = {};

    -- store all the keys in a table
    for k,v in pairs(tab) do
        t_insert(Keys, k);
    end

    -- sort the table
    table.sort(Keys);

    -- we now have a sorted table containing the keys
    for pos, k in pairs(Keys) do
        -- insert the values in a new table using the position of each key
        t_insert(SortedTable, pos, tab[k]);
    end

    -- we return a new sorted table with new keys but with the same values
    return SortedTable;
end

function D:tReverse(tab)
    local ReversedTable = {};

    for k,v in pairs(tab) do
        ReversedTable[v] = k;
    end

    return ReversedTable;
end

function D:tSwap(t, i1, i2)

    if i1 == i2 then
        return false;
    end

    local i1c= t[i1];
    local i2c= t[i2];

    if i1 <= i2 then
        t_remove(t, i2) -- remove the greater one first
        t_remove(t, i1)
        t_insert(t, i1, i2c) -- insert the smaller one first
        t_insert(t, i2, i1c)
    else
        t_remove(t, i1) -- remove the greater one first
        t_remove(t, i2)
        t_insert(t, i2, i1c) -- insert the smaller one first
        t_insert(t, i1, i2c)
    end

    return true;
end

function D:tCall(t, f)
    for k,v in pairs(t) do
        f(k,v)
    end
end

function D:ThisSetText(frame, text) --{{{
    _G[frame:GetName().."Text"]:SetText(text);
end --}}}

function D:ThisSetParentText(frame, text) --{{{
    _G[frame:GetParent():GetName().."Text"]:SetText(text);
end --}}}

function D:DisplayTooltip(Message, RelativeTo, AnchorType, x, y) --{{{
        DcrDisplay_Tooltip:SetOwner(RelativeTo, AnchorType or "ANCHOR_LEFT", x, y);
        DcrDisplay_Tooltip:SetText(Message);
        DcrDisplay_Tooltip:Show();
end --}}}

do
    local HeadFont
    function D:CreateLQTHFonts()

        if HeadFont then
            return HeadFont;
        end

        D:Debug("CreateLQTHFonts called");

        -- Create the fonts objects we'll use in the tooltip:
        -- New font looking like GameTooltipText
        HeadFont = CreateFont("DCR_QT_HeadFont")
        HeadFont:SetFont(GameTooltipText:GetFont(), 16)
        HeadFont:SetTextColor(0.8,0.8,0.3)

        return HeadFont;
    end
end

do --{{{
    local LastMessageTable = nil
    function D:DisplayLQTGameTooltip(messageTable, ownerFrame)
        if not messageTable then
            return
        end

        local LQTtoolTip = LibQTip:Acquire("DecursiveDebuffFrameHelp", 2, "LEFT", "RIGHT");

        LQTtoolTip:SetAutoHideDelay(.3, ownerFrame, function() LastMessageTable = nil end)

        -- if it's still being displayed due to autohide delay...
        if LastMessageTable ~= messageTable and LQTtoolTip:GetLineCount() > 0 then
            LQTtoolTip:Clear()
        elseif LastMessageTable == messageTable then
            return LQTtoolTip
        end

        LastMessageTable = messageTable;

        self:tCall(messageTable, function (_,v) self:tCall(v, function (k,v)
            if v ~= -1 then
                LQTtoolTip:AddLine(k,v)
            else
                LQTtoolTip:AddSeparator()
            end
        end ) end);

        -- code from Blizzard's GameTooltip_SetDefaultAnchor
        LQTtoolTip:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -CONTAINER_OFFSET_X - 13, CONTAINER_OFFSET_Y);
        LQTtoolTip:Show();

        return LQTtoolTip;
    end
end --}}}


function D:NumToHexColor(ColorTable)
        return str_format("%02x%02x%02x%02x", ColorTable[4] * 255, ColorTable[1] * 255, ColorTable[2] * 255, ColorTable[3] * 255)
end

-- function taken from http://www.wowwiki.com/SetTexCoord_Transformations
function D:SetCoords(t, A, B, C, D, E, F)
        local det = A*E - B*D;
        local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy;

        ULx, ULy = ( B*F - C*E ) / det, ( -(A*F) + C*D ) / det;
        LLx, LLy = ( -B + B*F - C*E ) / det, ( A - A*F + C*D ) / det;
        URx, URy = ( E + B*F - C*E ) / det, ( -D - A*F + C*D ) / det;
        LRx, LRy = ( E - B + B*F - C*E ) / det, ( -D + A -(A*F) + C*D ) / det;

        t:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy);
end

do

    DC.ClassesColors = { };

    local RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS;

    local NON_CLASSIC_CLASSES = {
        ["DEMONHUNTER"]    = true,
        ["DEATHKNIGHT"]    = true,
        ["MONK"]           = true

    };

    function D:GetClassColor (EnglishClass, noCache)
        if not DC.ClassesColors[EnglishClass] or noCache then
            if RAID_CLASS_COLORS and RAID_CLASS_COLORS[EnglishClass] then
                DC.ClassesColors[EnglishClass] = { RAID_CLASS_COLORS[EnglishClass].r, RAID_CLASS_COLORS[EnglishClass].g, RAID_CLASS_COLORS[EnglishClass].b };
            else
                DC.ClassesColors[EnglishClass] = { 0.63, 0.63, 0.63 };
            end
            DC.ClassesColors[LC[EnglishClass]] = DC.ClassesColors[EnglishClass];
        end
        return unpack(DC.ClassesColors[EnglishClass]);
    end

    DC.HexClassColor = { };

    function D:GetClassHexColor(EnglishClass, noCache)
        if not DC.HexClassColor[EnglishClass] or noCache then
            local r, g, b = self:GetClassColor(EnglishClass)
            DC.HexClassColor[EnglishClass] = str_format("%02x%02x%02x", r * 255, g * 255, b * 255);
            DC.HexClassColor[LC[EnglishClass]] = DC.HexClassColor[EnglishClass];
        end

        return DC.HexClassColor[EnglishClass];
    end


    function D:CreateClassColorTables ()
        if RAID_CLASS_COLORS then
            local class, colors;
            for class in pairs(RAID_CLASS_COLORS) do
                if LC[class] then -- Some badly coded add-ons are modifying RAID_CLASS_COLORS causing multiple problems...
                    D:GetClassColor(class, true);
                    D:GetClassHexColor(class, true);
                elseif not (DC.WOWC and NON_CLASSIC_CLASSES[class]) then
                    D:AddDebugText("Strange class found in RAID_CLASS_COLORS:", class, 'maxClass:', CLASS_SORT_ORDER and #CLASS_SORT_ORDER or 'CLASS_SORT_ORDER unavailable...');
                    print("Decursive: |cFFFF0000Unexpected value found in _G.RAID_CLASS_COLORS table|r\nThis may cause many issues, Decursive will display this message until the culprit add-on is fixed or removed, the unexpected value is: '", class, "'");
                end
            end
        else
            D:AddDebugText("global RAID_CLASS_COLORS does not exist...");
            T._FatalError("global RAID_CLASS_COLORS does not exist...");
        end

        D:Debug('CreateClassColorTables called');
    end

    if CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS.RegisterCallback then
        CUSTOM_CLASS_COLORS:RegisterCallback(function() D:ScheduleDelayedCall('update_Class_Colors', D.CreateClassColorTables, .3, D) end);
    end

end

function D:GetSpellFromLink(link)

    if link:find('|Hspell:%d+') then
        local spellID;
        spellID = tonumber(link:match('|Hspell:(%d+)'));

        local spellName, spellRank = GetSpellInfo(spellID);

        if not spellName then
            return nil;
        end

        if spellRank and spellRank ~= "" then
            spellName = ("%s(%s)"):format(spellName, spellRank);
        end
        D:Debug('Spell link detected:', spellID, spellName, spellRank);

        --return spellName;
        return spellID;
    end

    return nil;
end


local IsUsableItem      = _G.IsUsableItem;
local IsEquippableItem  = _G.IsEquippableItem;
local IsEquippedItem    = _G.IsEquippedItem;
function D:isItemUsable(itemIDorName)
    if IsEquippableItem(itemIDorName) and not IsEquippedItem(itemIDorName) then
        return false;
    end

    return IsUsableItem(itemIDorName);
end

function D:GetItemFromLink(link)
    -- GetItemInfo (only if item seen)
    -- GetItemCooldown
    -- IsUsableItem (ignores cooldowms and petty conditions)
    -- IsItemInRange(itemID, "unit")
    -- GetItemCount(itemId, includeBank, includeCharges)

    if link:find('|Hitem:%d+') then
        local itemID;
        itemID = tonumber(link:match('|Hitem:(%d+)'));

        local name = GetItemInfo(itemID);

        if not name then
            return nil;
        end

        D:Debug('Item link detected:', itemID, name);

        return itemID;
    end

    return nil;
end

function D.GetSpellOrItemInfo(spellID)
    if spellID > 0 then
        return GetSpellInfo(spellID);
    else
        return GetItemInfo(spellID * -1) or "Item: " .. spellID * -1;
    end
end

local function BadLocalTest (localtest)
    D:Print(L[localtest]);
end

-- /run LibStub("AceAddon-3.0"):GetAddon("Decursive"):MakeError()

function D:MakeError(something)

    local testlocal = "test local";
    local testbiglocal = D;

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

function D:NiceTime()
    return tonumber(("%.4f"):format(GetTime() - DC.StartTime));
end


do

    -- /run LibStub("AceAddon-3.0"):GetAddon("Decursive"):RuncombatCrash()
    local combatCrash;
    function D:RuncombatCrash()
        D:Debug("RCC: Last run:", combatCrash);
        if not InCombatLockdown() then
            D:Debug("RCC: Not in combat");
            return;
        end

        local crashStart = debugprofilestop();

        if not crashStart then
            D:Debug("RCC: debugprofilestop() returned garbage...");
            return;
        end

        D:Debug("RCC: Hang started (1s max)");

        repeat
            for i=1,1000,1 do end
            combatCrash = debugprofilestop() - crashStart;
        until debugprofilestop() - crashStart > 1000;

    end

end

do
    local DcrTimers = {};
    local argCount = 0;

    local Yields = 0;
    local CurrentRefreshID = 0;
    local CurrentRefreshElapsed = 0;
    local CurrentRefreshStart = 0;
    local CurrentNumInARow = 0;

    local LongestExecBesidesYields = 0;
    local LargestBatch = 0;

    local TimersTotalExecs = 0;

    local Time = 0;

    local function Yielding ()
        Time = GetTime(); -- get an ID of the current refresg we're in. (GetTime() value is cached on OnUpdate)

        TimersTotalExecs = TimersTotalExecs + 1;

        if Time == CurrentRefreshID then -- if we are still in the same OnUpdate
            CurrentNumInARow = CurrentNumInARow + 1;

            -- do some stats to display when debugging
            if CurrentNumInARow > LargestBatch then
                LargestBatch = CurrentNumInARow;
            end

            CurrentRefreshElapsed = CurrentRefreshElapsed + (debugprofilestop() - CurrentRefreshStart); -- compute how much time has elapsed

            if CurrentRefreshElapsed > 50 then -- if we've been doing things for more than 50ms then yield
                Yields = Yields + 1;
                return true;
            end

            -- do some stats to display when debugging
            if CurrentRefreshElapsed > LongestExecBesidesYields then
                LongestExecBesidesYields = CurrentRefreshElapsed;
            end

        else -- it's the first time we do something on this OnUpdate so initialize our status
            CurrentRefreshID = Time; -- set the RefreshID
            CurrentRefreshElapsed = 0;
            CurrentNumInARow    = 0;
            CurrentRefreshStart = debugprofilestop();
        end

        return false;
    end

    function D:TimerExixts(RefName)
        return DcrTimers[RefName] and DcrTimers[RefName][1] or false;
    end

    function D:DelayedCallExixts(RefName)
        return DcrTimers[RefName] and DcrTimers[RefName][1] or false;
    end


    function D:ScheduleDelayedCall(RefName, FunctionRef, Delay, arg1, ...)
        --[===[@debug@
    --  D:Debug('|cFFFF0000SDC:|r|cFF00FFAA', RefName, Delay, arg1, unpack({...}));
        --@end-debug@]===]

        argCount = select('#', ...);

        if DcrTimers[RefName] and DcrTimers[RefName][1] then -- a timer with the same refname still exists
            -- we test up to two arguments to avoid the cancellation->re-creation of the timer (AceTimers doesn't remove them right away)
            if (argCount == 0 or argCount == 1 and  select(1, ...) == DcrTimers[RefName][2][2]) and arg1 == DcrTimers[RefName][2][1] then
                --[===[@debug@
                D:Debug("Timer |cFF0000DDcancellation-creation canceled|r for", RefName, "Arg:", arg1, "indargcount:", argCount);
                --@end-debug@]===]
                return;
                --[===[@debug@
            else
                D:Debug("Timer |cFF0066DD-replaced-|r for", RefName, "argcount:", argCount);
                --@end-debug@]===]
            end
            if not self:CancelTimer(DcrTimers[RefName][1]) then
                self:AddDebugText("Timer cancellation failed in ScheduleDelayedCall() for", RefName);
            end
        end


        if Delay > 30 then
            self:AddDebugText("A delayed call for", RefName, "was requested with a very large timer:", Delay);
        end

        if not DcrTimers[RefName] then
            DcrTimers[RefName] = {};
        end

        -- arg table
        DcrTimers[RefName][2] = {arg1};

        if argCount > 0 then

            local i;
            for i = 1, argCount do
                DcrTimers[RefName][2][i + 1] = (select(i, ...));
            end

            DcrTimers[RefName][1] = self:ScheduleTimer (
            function(arg)
                T._DebugTimerRefName = RefName;
                DcrTimers[RefName][1] = false;

                if not Yielding() then -- check if we still got time to run this call
                    FunctionRef(unpack(arg));
                else -- we reschedule the event ASAP
                    self:ScheduleDelayedCall(RefName, FunctionRef, 0.01, unpack(arg));
                end

                T._DebugTimerRefName = "";
            end
            , Delay, DcrTimers[RefName][2]
            );
        else
            DcrTimers[RefName][1] = self:ScheduleTimer (
            function(arg)
                T._DebugTimerRefName = RefName;
                DcrTimers[RefName][1] = false;

                if not Yielding() then -- check if we still got time to run this call
                    FunctionRef(arg);
                else -- we reschedule the event ASAP
                    self:ScheduleDelayedCall(RefName, FunctionRef, 0.01, arg1);
                end

                T._DebugTimerRefName = "";
            end
            , Delay, arg1
            );
        end

        --[===[@debug@
    --  D:Debug('|cFFFF0000SDC:|r ACEID:|cFF00FFAA', DcrTimers[RefName][1]);
        --@end-debug@]===]
        return DcrTimers[RefName][1];
    end

    function D:ScheduleRepeatedCall(RefName, FunctionRef, Delay, arg)
        if DcrTimers[RefName] and DcrTimers[RefName][1] then
            if not self:CancelTimer(DcrTimers[RefName][1]) then
                self:AddDebugText("Timer cancellation failed in ScheduleRepeatedCall() for", RefName);
            end
        end

        if not DcrTimers[RefName] then
            DcrTimers[RefName] = {};
        end

        DcrTimers[RefName][1] = self:ScheduleRepeatingTimer(FunctionRef, Delay, arg);

        return DcrTimers[RefName][1];
    end

    function D:CancelDelayedCall(RefName)
        local success = false;
        if DcrTimers[RefName] and DcrTimers[RefName][1] then
            local cancelHandle = DcrTimers[RefName][1];
            success = self:CancelTimer(cancelHandle);

            if success then
                DcrTimers[RefName][1] = false;
            else
                self:AddDebugText("Timer cancellation failed in CancelDelayedCall() for", RefName);
            end

            return success;
        end
        return 0;
    end

    function D:CancelAllTimedCalls()
        for RefName in pairs(DcrTimers) do
            self:CancelDelayedCall(RefName);
        end
    end

    function D:GetTimersInfo()
        local AceTimer = LibStub("AceTimer-3.0");

        local dcrCount = 0;
        for RefName, timer in pairs(DcrTimers) do
            if timer[1] then
                dcrCount = dcrCount + 1;
                --[===[@debug@
                self:Debug("|cff00AA00TimerRef:|r ", RefName, "ARGS:",timer[2] and unpack (timer[2]) or 'NONE', 'ACEID: |cffaa8833', timer[1], '|r', AceTimer.activeTimers[timer[1]] and 'active' or 'UNKNOWN');
                --@end-debug@]===]
            end
        end
        local libTimerCount = 0;
        for id,timer in pairs(AceTimer.activeTimers) do
            if timer.object == D then
                libTimerCount = libTimerCount + 1;
                --[===[@debug@
                self:Debug("|cff00AA00AceRef:", id,'|r');
                --@end-debug@]===]
            end
        end
        return dcrCount, libTimerCount, Yields, LongestExecBesidesYields, LargestBatch, TimersTotalExecs;
    end

end

-- function D:GetOPtionPath(info) {{{
function D:GetOPtionPath(info)
    return table.concat(info, "->");
end -- }}}

do
    local PlaySoundFile = _G.PlaySoundFile;
    T._PlayingASound = false;

    -- Play sounda on a special update execution context to avoid
    -- crashing and leaving the program in an unknown state if WoW fails
    -- to play the sound fast enough... ('script ran too long' add-on
    -- breaker thingy of which I had a few report failing on the
    -- PlaySoundFile() call)

    local testTime;

    local function SafePlaySoundFile(path)

        if D.debug then
            testTime = debugprofilestop();
        end

        T._PlayingASound = GetTime();
        local r1, r2 = PlaySoundFile(path, "Master");
        T._PlayingASound = false;

        if D.debug then
            D:Debug('Sound played:', path, r1, r2, 'it took:', ('%0.3fms'):format(debugprofilestop() - testTime));
        end
    end

    function D:SafePlaySoundFile(path)
        self:ScheduleDelayedCall('PlaySoundFile', SafePlaySoundFile, 0.1, path);
    end
end


T._LoadedFiles["Dcr_utils.lua"] = "2.7.6.4";
