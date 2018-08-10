--[[
    This file is part of Decursive.

    Decursive (v 2.7.6.1) add-on for World of Warcraft UI
    Copyright (C) 2006-2018 John Wellesz (Decursive AT 2072productions.com) ( http://www.2072productions.com/to/decursive.php )

    Starting from 2009-10-31 and until said otherwise by its author, Decursive
    is no longer free software, all rights are reserved to its author (John Wellesz).

    The only official and allowed distribution means are www.2072productions.com, www.wowace.com and curse.com.
    To distribute Decursive through other means a special authorization is required.


    Decursive is inspired from the original "Decursive v1.9.4" by Patrick Bohnet (Quu).
    The original "Decursive 1.9.4" is in public domain ( www.quutar.com )

    Decursive is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY.

    This file was last updated on 2018-08-09T22:30:55Z
--]]
-------------------------------------------------------------------------------

local _G                = _G;
local GetFramerate      = _G.GetFramerate;
local GetNetStats       = _G.GetNetStats;
local GetRealZoneText   = _G.GetRealZoneText;
local tostring          = _G.tostring;
local tonumber          = _G.tonumber;
local select            = _G.select;
local table             = _G.table;
local GetTime           = _G.GetTime;
local strjoin           = _G.strjoin;
local GetCVarBool       = _G.GetCVarBool;
local IsAddOnLoaded     = _G.IsAddOnLoaded;
local GetAddOnMetadata  = _G.GetAddOnMetadata;
local time              = _G.time;
local pcall             = _G.pcall;
local pairs             = _G.pairs;
local ipairs            = _G.ipairs;
local InCombatLockdown  = _G.InCombatLockdown;

local addonName, T = ...;
DecursiveRootTable = T; -- needed until we get rid of the xml based UI. -- Also used by HHTD from 2013-04-05

T._FatalError_Diaplayed = false;

-- big ugly scary fatal error message display function - only used when nothing else works {{{
T._FatalError = function (TheError)

    if not StaticPopupDialogs["DECURSIVE_ERROR_FRAME"] then
        StaticPopupDialogs["DECURSIVE_ERROR_FRAME"] = {
            text = "|cFFFF0000Decursive Fatal Error:|r\n%s",
            button1 = "OK",
            OnAccept = function()
                T._FatalError_Diaplayed = false;
                return false;
            end,
            timeout = 0,
            whileDead = 1,
            hideOnEscape = 1,
            showAlert = 1,
            preferredIndex = 3,
        };
    end

    if not T._FatalError_Diaplayed then
        StaticPopup_Show ("DECURSIVE_ERROR_FRAME", TheError);
        if T._DiagStatus then
            T._FatalError_Diaplayed = true;
        end
    end
end
-- }}}

DecursiveInstallCorrupted     = false;

T._C                    = {};
T._DebugTextTable       = {};
T._DebugText            = "";
T._DebugTimerRefName    = "";

-- fail safes, T.Dcr will be replaced by AceAddon in normal conditions
-- Just add this so that diag functions can work even in the most dramatic events
T.Dcr = {};

local DC                = T._C;
local DebugTextTable    = T._DebugTextTable;
local Reported          = {};

local UNPACKAGED = "@pro" .. "ject-version@";
local VERSION = "2.7.6.1";

T._LoadedFiles = {};
T._LoadedFiles["Dcr_DIAG.lua"] = false; -- here for consistency but useless in this particular file

if DecursiveInEmbeddedMode == nil then
    T._EmbeddedMode = "unknown";
else
    T._EmbeddedMode = DecursiveInEmbeddedMode;
    DecursiveInEmbeddedMode = nil;

    T._LoadedFiles["embeds.xml"] = DecursiveEmbedsxmlCheck;
    DecursiveEmbedsxmlCheck = nil;
end

-- a list of all source files part of Decursive sort in loading order
T._LoadOrderedFiles = { -- {{{
    "embeds.xml",

    "Dcr_DIAG.xml",
    "Dcr_DIAG.lua",

    "load.xml",

    "enUS.lua",
    "zhCN.lua",
    "zhTW.lua",

    "DCR_init.lua",
    "Dcr_LDB.lua",
    "Dcr_utils.lua",

    "Dcr_opt.lua",
    "Dcr_Events.lua",

    "Dcr_Raid.lua",

    "Decursive.lua",
    "Decursive.xml",

    "Dcr_lists.lua",
    "Dcr_lists.xml",

    "Dcr_DebuffsFrame.lua",
    "Dcr_DebuffsFrame.xml",

    "Dcr_LiveList.lua",
    "Dcr_LiveList.xml",
}; -- }}}


DC.StartTime = GetTime();

-- local utility functions {{{
local function _Debug (...)
    if T.Dcr and T.Dcr.Debug and T.Dcr.debug then
        T.Dcr:Debug(...);
    end
end

local function _Print (...)
    if T.Dcr and T.Dcr.Print then
        T.Dcr:Print(...);
    end
end

local function NiceTime()
    return tonumber(("%.4f"):format(GetTime() - DC.StartTime));
end

local function print(t)
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage(t);
    end
end

-- taken from AceConsole-2.0
local function tostring_args(a1, ...)
        if select('#', ...) < 1 then
                return tostring(a1)
        end
        return tostring(a1), tostring_args(...)
end
-- }}}

 -- DEBUG REPORTING {{{

function T._AddDebugText(a1, ...) -- {{{

    _Debug("Error processed");

    local text = "";

    if select('#', ...) > 0 then
        text = strjoin(", ", tostring_args(a1, ...))
    else
        text = tostring(a1);
    end

    local zone = GetRealZoneText() or "none";

    if not Reported[text] then
        table.insert (DebugTextTable,  ("\n\n|cffff0000*****************|r\n\n%.4f (tr:'%s' ca:'%s' icl:'%s' h%d_w%d-%dfps-%s): %s -|count: "):format(
        NiceTime(), -- %.4f
        tostring(T._DebugTimerRefName), -- tr:'%s'
        tostring(T._CatchAllErrors), -- ca:'%s'
        tostring(InCombatLockdown()), -- icl:'%s'
        select(3, GetNetStats()), -- h%d
        select(4, GetNetStats()), -- w%d
        GetFramerate(), -- %dfps
        zone, -- -%s
        text -- %s
        ));
        table.insert (DebugTextTable, 1);
        Reported[text] = #DebugTextTable;
    else
        DebugTextTable[Reported[text]] = DebugTextTable[Reported[text]] + 1;
    end

    -- if an error is caught while Decursive is being loaded, there is a good chance it will cancel loading alltogether.
    -- So just display what we caught straight away.
    if not T.Dcr.DcrFullyInitialized then
        T._ShowDebugReport();
    end

end -- }}}

function T._DebugFrameOnTextChanged(frame) -- {{{
    -- inspired from BugSack
    if frame:GetText() ~= T._DebugText then
        frame:SetText(T._DebugText)
    end
    frame:GetParent():UpdateScrollChildRect()
    local _, m = DecursiveDebuggingFrameScrollScrollBar:GetMinMaxValues()
    if m > 0 and frame.max ~= m then
        frame.max = m
        DecursiveDebuggingFrameScrollScrollBar:SetValue(0)
    end
end -- }}}

do
    local DebugHeader = false;
    local ReportEmail = GetAddOnMetadata("Decursive", "X-eMail") or "Decursive@2072productions.com";
    local HeaderFailOver = ("|cFF11FF33Please email the content of this window to <%s>|r\n|cFF009999(Use CTRL+A to select all and then CTRL+C to put the text in your clip-board)|r\nAlso tell in your report if you noticed any strange behavior of Decursive.\n"):format(ReportEmail:gsub('@','+ReportFH@'));
    local LoadedAddonNum = 0;
    local TotalAddonMemoryUsage = 0;

    local function GetAddonListAsString ()
        local addonCount = GetNumAddOns();
        local loadedAddonList = {};
        local version, memoryUsage, name, security, _;

        TotalAddonMemoryUsage = 0;
        UpdateAddOnMemoryUsage();

        for addonID=1, addonCount do
            name, _, _, _, _, security, _ = GetAddOnInfo(addonID)

            if security == 'INSECURE' and IsAddOnLoaded(addonID) then
                version = GetAddOnMetadata(addonID, "Version");
                memoryUsage = GetAddOnMemoryUsage(addonID);

                TotalAddonMemoryUsage = TotalAddonMemoryUsage + memoryUsage;

                table.insert(loadedAddonList, ("%s (%s)[%d]{MU: %d}"):format(name, version or 'N/A', addonID, memoryUsage));

            end
        end

        table.sort(loadedAddonList);

        LoadedAddonNum = #loadedAddonList;
        return table.concat(loadedAddonList, "\n");
    end

    local function setReportHeader(fromDiag)

        local instructionsHeader;

        if fromDiag or not T.Dcr.db or not T.Dcr.db.global.NewerVersionName or T._HHTDErrors ~= 0 then
            if T.Dcr.L and T.Dcr.L["DEBUG_REPORT_HEADER"] then
                -- Create the header insterting the email address and
                -- influencing the content if this is an HHTD error.
                instructionsHeader = (T.Dcr.L["DEBUG_REPORT_HEADER"]):format(

                    ReportEmail:gsub('@', T._HHTDErrors ~= 0 and '+HHTDReport@' or '+Report@'),
                    T._HHTDErrors ~= 0 and 'Decursive / H.H.T.D.' or 'Decursive'

                );
            else
                instructionsHeader = HeaderFailOver
            end
        else
            instructionsHeader = T.Dcr.L and ((T.Dcr.L["DECURSIVE_DEBUG_REPORT_BUT_NEW_VERSION"]):format(T.Dcr.db.global.NewerVersionName)) or HeaderFailOver;
            -- disable bug me not since the user _clearly_ took the wrong decision
            T.Dcr.db.global.NewVersionsBugMeNot = false;
        end

        local TIandBI = T.Dcr.GetTimersInfo and {T.Dcr:GetTimersInfo()} or {-1,-1,-1,-1,-1,0};
        TIandBI[#TIandBI + 1], TIandBI[#TIandBI + 2], TIandBI[#TIandBI + 3], TIandBI[#TIandBI + 4] = GetBuildInfo();
        _Debug(unpack(TIandBI));


        DebugHeader = ("%s\n2.7.6.1  %s(%s)  CT: %0.4f D: %s %s %s BDTHFAd: %s nDrE: %d Embeded: %s W: %d (LA: %d TAMU: %d) TA: %d NDRTA: %d BUIE: %d TI: [dc:%d, lc:%d, y:%d, LEBY:%d, LB:%d, TTE:%u] (%s, %s, %s, %s)"):format(instructionsHeader, -- "%s\n
        tostring(DC.MyClass), tostring(UnitLevel("player") or "??"), NiceTime(), date(), GetLocale(), -- %s(%s)  CT: %0.4f D: %s %s
        BugGrabber and "BG" .. (T.BugGrabber and "e" or "") or "NBG", -- %s
        tostring(T._BDT_HotFix1_applyed), -- BDTHFAd: %s
        T._NonDecursiveErrors, -- nDrE: %d
        tostring(T._EmbeddedMode), -- Embeded: %s
        IsWindowsClient() and 1 or 0, -- W: %d
        LoadedAddonNum, -- LA: %d
        TotalAddonMemoryUsage, -- TAMU: %d
        T._TaintingAccusations, -- TA: %d
        T._NDRTaintingAccusations, -- NDRTA: %d
        T._BlizzardUIErrors, -- BUIE: %d
        unpack(TIandBI));
       -- T.Dcr:GetTimersInfo(), -- TI: [dc:%d, lc:%d, y:%d, LEBY:%d, LB:%d, TTE:%u]
       -- GetBuildInfo()); --  (%s, %s, %s, %s)
    end

    function T._ShowDebugReport(fromDiag)

        local diagStatus, PBCK = T._SelfDiagnostic();

        if PBCK then
            return;
        end

        if T._HHTDErrors == 0 and not fromDiag and DC.DevVersionExpired and T.Dcr.VersionWarnings then
            T.Dcr:VersionWarnings(true);
            return;
        end

        -- get running add-ons list
        local ALASsuccess, loadedAddonList = pcall(GetAddonListAsString);

        local ACsuccess, actionsConfiguration = pcall(T._ExportActionsConfiguration);

        local CSCsuccess, customSpellConfiguration = pcall(T._ExportCustomSpellConfiguration);

        local SRTOLEsuccess, SRTOLErrors =
            pcall(function() return "Script ran too long errors:\n" .. T.Dcr:tAsString(T.Dcr.db.global.SRTLerrors) end);

        local headerSucess, headerGenErrorm;
        if not DebugHeader then
            headerSucess, headerGenErrorm = pcall(setReportHeader, fromDiag);
        else
            headerSucess = true;
        end


        T._DebugText = (headerSucess and DebugHeader or (HeaderFailOver .. 'Report header gen failed: ' .. (headerGenErrorm and headerGenErrorm or "")))
        .. table.concat(T._DebugTextTable, "")
        .. "\n\n-- --\n" .. actionsConfiguration .. "\n-- --"
        .. customSpellConfiguration .. "\n-- --"
        .. SRTOLErrors .. "\n-- --"
        .. "\n\nLoaded Addons:\n\n" .. loadedAddonList .. "\n-- --";

        if _G.DecursiveDebuggingFrameText then
            _G.DecursiveDebuggingFrameText:SetText(T._DebugText);

            local title = T.Dcr.L and T.Dcr.L["DECURSIVE_DEBUG_REPORT"] or "**** |cFFFF0000Decursive Debug Report|r ****";

            if T._HHTDErrors ~= 0 then
                title = title:gsub('ecursive', 'ecursive / H.H.T.D.');
            end

            _G.DecursiveDEBUGtext:SetText(title);
            _G.DecursiveDebuggingFrame:Show();
        else
            T._FatalError(T._DebugText);
        end
    end
end -- }}}

-- Decursive LUA error manager and debug reporting functions {{{
local function PlaySoundFile_RanTooLongheck(message)

    -- test for PlaySoundFile() API call failure, this exception bubles in the
    -- dispatcher so eat all errors happenning in the same refresh event (while
    -- GetTime() stays the same)

    if T._PlayingASound and T._PlayingASound == GetTime() and message:find("ran too long") then
        _Debug('"Script ran too long" while playing sound eaten');
        _Print("|cffff0000*DING!*|r (Decursive failed to play a sound)");
        return true;
    end

    return false;
end

local function CheckHHTD_Error(errorm, errorml)
    if (errorml:find("hhtd") and not errorml:find("\\libs\\"))
        or
        (errorml:find("\\libnameplateregistry") and not errorml:find("couldn't open") and not errorml:find("error loading")) then
        _Debug("CheckHHTD_Error()", true);
        return true;
    end

    return false;
end


local AddDebugText = T._AddDebugText;

-- The error handler

-- used to prevent loops if our own error handler crashes
local IsReporting = false;

T._NonDecursiveErrors = 0;
T._TaintingAccusations = 0;
T._NDRTaintingAccusations = 0;
T._BlizzardUIErrors = 0;
T._ErrorLimitStripped = false;
T._HHTDErrors = 0;

local LastErrorMessage = "!NotSet!";

-- a special handler for these random "Script ran too long" error
-- returns true when a resport should be shown, false otherwise
local function continueErrorReporting (lowerCaseErrorMsg)
    local isSRTLE = lowerCaseErrorMsg:find("script ran too long")

    if not isSRTLE then
        -- continue as usual when this error is not a SRTL one
        return true;
    elseif T._CatchAllErrors or not T.Dcr.DcrFullyInitialized then
        -- However we do want to catch SRTL errors when these flags are active as it
        -- explains why subsequent "impossible" errors are happening...
        -- (several reports were received where DCR init did not complete for no apparent reason)
        return true;
    end

    -- these tests appear to be redundant but this function must never crash...
    if not T.Dcr.db or not T.Dcr.db.global or not T.Dcr.db.global.SRTLerrors then
        return false;
    end

    local fname_line = lowerCaseErrorMsg:match('(%w+%.[xl][mu][la]:%d+)');

    if not fname_line then
        return false;
    end

    local SRTLerrors = T.Dcr.db.global.SRTLerrors;

    SRTLerrors["total"] = SRTLerrors["total"] + 1;

    if not SRTLerrors[fname_line] then
        SRTLerrors[fname_line] = {};
    end

    local ctime = time();

    while(SRTLerrors[fname_line][1] and ctime - SRTLerrors[fname_line][1] > 86400 * 30) do
        table.remove(SRTLerrors[fname_line], 1);
    end

    table.insert(SRTLerrors[fname_line], ctime);

    if lowerCaseErrorMsg:find("dcr_diag.lua") then
        return false;
    end

    if #SRTLerrors[fname_line] > 1 then
        return true;
    else
        return false;
    end
end

function T._onError(event, errorObject)
    local errorm = errorObject.message;
    local mine = false;
    local taintingAccusation = false;

    -- test for PlaySoundFile() API call failure
    if PlaySoundFile_RanTooLongheck(errorm) then
        return;
    end

    local errorml = errorm:lower();

    if not IsReporting
        and ( T._CatchAllErrors or (
        errorml:find("decursive") and -- first, make a general test to see if it's worth looking further
        (
           ( not errorml:find("\\libs\\") ) -- errors happpening in something located below Decursive's path but not inside \Libs
        or ( errorm:find("[\"']Decursive[\"']") ) -- events involving Decursive
        or ( errorm:find("Decursive:") ) -- libraries error involving Decursive (AceLocal)
        or ( errorml:find("decursive%.")) -- for Aceconfig
        )
        )) then

        if not continueErrorReporting(errorml) then
            return;
        end

        -- Ignore errors caused by corrupted savedVariables files
        if errorm:find("SavedVariables") then
            return;
        end

        if errorm:find("ADDON_ACTION_") then
            taintingAccusation = true;
        end

        if not taintingAccusation or T._EmbeddedMode == false then -- if we are having this while we're not emebedding anything then it does matters
            IsReporting = true;
            AddDebugText(errorObject.message, "\n|cff00aa00STACK:|r\n", errorObject.stack, "\n|cff00aa00LOCALS:|r\n", errorObject.locals);
            IsReporting = false;
            T._CatchAllErrors = false; -- Errors are unacceptable so one is enough, no need to get all subsequent errors.
            mine = true;
            _Debug("Lua error recorded");
        else
            T._NonDecursiveErrors = T._NonDecursiveErrors + 1;
            T._TaintingAccusations = T._TaintingAccusations + 1;
            _Debug("False tainting accusation put under the carpet");
            return; -- bury it under the carpet since it's blaming the wrong add-on and misleading the users.
        end
    else -- not a Decursive error
        if IsReporting then
            IsReporting = false;
        else
            T._NonDecursiveErrors = T._NonDecursiveErrors + 1;

            if CheckHHTD_Error(errorm, errorml) then

                if not continueErrorReporting(errorml) then
                    return;
                end

                IsReporting = true;
                AddDebugText(errorObject.message, "\n|cff00aa00STACK:|r\n", errorObject.stack, "\n|cff00aa00LOCALS:|r\n", errorObject.locals);
                IsReporting = false;
                T._HHTDErrors = T._HHTDErrors + 1;
                mine = true;
            elseif errorm:find("ADDON_ACTION_") then
                T._NDRTaintingAccusations = T._NDRTaintingAccusations + 1;
            elseif errorm:find("FrameXML") or errorm:find("SharedXML") then
                T._BlizzardUIErrors = T._BlizzardUIErrors + 1;
            end

        end
    end

    LastErrorMessage = errorm;

    if not mine and not T._BugSackLoaded then

        --/console scriptErrors 1 to check it
        if _G.DEBUGLOCALS_LEVEL then

            -- Fix Blizzard's own code... (2017-09-04: it's set to 5 while it should be 4)
            if _G.DEBUGLOCALS_LEVEL == 5 then
                _G.DEBUGLOCALS_LEVEL = 4
            end

            _G.DEBUGLOCALS_LEVEL = _G.DEBUGLOCALS_LEVEL + 9
        end

        -- forward the error to the default Blizzad error displayer
        if _G.HandleLuaError then
            local errorm = errorObject.message;

            _Debug("Lua error forwarded");

            return _G.HandleLuaError( errorm );
        end
    else
        _Debug("Lua error NOT forwarded, mine=", mine);
    end

end

local ProperErrorHandler = false;

local _, _, _, tocversion = GetBuildInfo();

T._CatchAllErrors = false;
T._tocversion = tocversion;

DC.WOW8 = (tocversion >= 80000)

function T._DecursiveErrorHandler(err, ...)

    if T._ErrorLimitStripped then
        return;
    end

    err = tostring(err);
    local errl = err:lower();

    if PlaySoundFile_RanTooLongheck(err) then
        return;
    end

    local mine = false;
    if not IsReporting and (T._CatchAllErrors or errl:find("decursive") and not errl:find("\\libs\\")) then

        if not continueErrorReporting(errl) then
            return;
        end

        -- Ignore errors caused by corrupted savedVariables files
        if err:find("SavedVariables") then
            return;
        end


        IsReporting = true;
        AddDebugText(err, "\n|cff00aa00STACK:|r\n", debugstack(3), "\n|cff00aa00LOCALS:|r\n", debuglocals(3), ...);
        IsReporting = false;
        T._CatchAllErrors = false; -- Errors are unacceptable so one is enough, no need to get all subsequent errors.
        mine = true;
        _Debug("Error recorded");
    else
        if IsReporting then -- then it means there is a bug inside AddDebugText...
            IsReporting = false;
        else
            T._NonDecursiveErrors = T._NonDecursiveErrors + 1;

            if CheckHHTD_Error(err, errl) then

                if not continueErrorReporting(errl) then
                    return;
                end

                IsReporting = true;
                AddDebugText(err, "\n|cff00aa00STACK:|r\n", debugstack(3), "\n|cff00aa00LOCALS:|r\n", debuglocals(3), ...);
                IsReporting = false;
                T._HHTDErrors = T._HHTDErrors + 1;
                mine = true;
            elseif err:find("ADDON_ACTION_") then
                T._NDRTaintingAccusations = T._NDRTaintingAccusations + 1;
            elseif err:find("FrameXML") or err:find("SharedXML") then
                T._BlizzardUIErrors = T._BlizzardUIErrors + 1;
            end

            if (T._NonDecursiveErrors - T._NDRTaintingAccusations - T._BlizzardUIErrors) > 999 then
		T._ErrorLimitStripped = NiceTime() > 10; -- allow a graceful period of 10s after startup
                T._TooManyErrors();
            end
        end
    end

    LastErrorMessage = err;

    if ProperErrorHandler and not mine then
        if _G.DEBUGLOCALS_LEVEL then

            -- Fix Blizzard's own code... (2017-09-04: it's set to 5 while it should be 4)
            if _G.DEBUGLOCALS_LEVEL == 5 then
                _G.DEBUGLOCALS_LEVEL = 4
            end

            _G.DEBUGLOCALS_LEVEL = _G.DEBUGLOCALS_LEVEL + 3;
        end
        return ProperErrorHandler( err, ... ); -- returning this way prevents this function from appearing in the stack
    end
end

local WarningDisplayed = false;
function T._TooManyErrors()

    -- T._NDRTaintingAccusations

    -- If the game just started (or Decursive), we ignore error burst as the
    -- new LUA_WARNING feature reveals many loading issues in other add-ons
    -- without gameplay consequences
    if (NiceTime() > 10) then

        -- if tainting accusation and Blizzard's UI errors represent more than 90% of errors then yield and don't display anything
        if not ((T._NDRTaintingAccusations + T._BlizzardUIErrors) > T._NonDecursiveErrors * 0.9) then
            if not WarningDisplayed and T.Dcr and T.Dcr.L and not (#DebugTextTable > 0 or T._TaintingAccusations > 10) then -- if we can and should display the alert
                _Print(T.Dcr:ColorText((T.Dcr.L["TOO_MANY_ERRORS_ALERT"]):format(T._NonDecursiveErrors), "FFFF0000"));
                _Print(T.Dcr:ColorText(T.Dcr.L["DONT_SHOOT_THE_MESSENGER"], "FFFF9955"));
                _Print('|cFF47C2A1Last UI error:|r', LastErrorMessage);
                WarningDisplayed = true;
            end
        else
            _Debug("_TooManyErrors()'s message not displayed NDR-TA being predominent...");
        end
    else
            _Debug("_TooManyErrors()'s message not displayed Decursive was just started...");
    end

    _Debug("Error handler disabled");
end

function T._RegisterBugGrabberCallBacks()

    if not BugGrabber.RegisterCallback then
        return;
    end

    local ok, errorm  = pcall (BugGrabber.RegisterCallback, T, "BugGrabber_BugGrabbed", T._onError)

    if ok then
        T._BugGrabberEmbeded = true;
    else
        T._BugGrabberEmbeded = false;
        AddDebugText("pcall hook 1: "..errorm, BugGrabber);
    end

    ok, errorm  = pcall (BugGrabber.RegisterCallback, T, "BugGrabber_CapturePaused", T._TooManyErrors)
    if ok then
        T._BugGrabberThrottleAlert = true;
    else
        AddDebugText("pcall hook 2: "..errorm);
    end

    return T._BugGrabberEmbeded;
end

function T._HookErrorHandler()

    if BugGrabber then
        local name, _, _, enabled = GetAddOnInfo("BugSack") -- enabled becomes isLoaded in WoD

        if name and enabled then
            T._BugSackLoaded = true;
        else
            T._BugSackLoaded = false;
        end

        BUGGRABBER_SUPPRESS_THROTTLE_CHAT = true; -- for people using an older version of BugGrabber. There is no way to know...


        -- force BG to load callbackhandler since it relies on other add-ons that embeded it.
        if not BugGrabber.RegisterCallback and BugGrabber.setupCallbacks then
            BugGrabber.setupCallbacks();
        end

        return T._RegisterBugGrabberCallBacks();
    end

    -- if no buggrabber is found then use the old way (no other error catcher is as good as BugGrabber... I can't rely on them)
    if not ProperErrorHandler then
        ProperErrorHandler = geterrorhandler();
        seterrorhandler(T._DecursiveErrorHandler);
    end

    return true;

end

--}}}

T._ShowNotice = function (notice)

    if not StaticPopupDialogs["DECURSIVE_NOTICE_FRAME"] then
        -- the beautiful notice popup : {{{ -
        StaticPopupDialogs["DECURSIVE_NOTICE_FRAME"] = {
            text = "|cFFFF0000Decursive Notice:|r\n%s",
            button1 = "OK",
            OnAccept = function()
                return false;
            end,
            timeout = 0,
            whileDead = 1,
            hideOnEscape = false,
            showAlert = 1,
            preferredIndex = 3,
        }; -- }}}
    end

    StaticPopup_Show ("DECURSIVE_NOTICE_FRAME", notice);
end


-- SELF DIAGNOSTIC {{{
do
    T._DiagStatus = false;

    local PrintMessage = function (message, ...) if T._DiagStatus ~= 2 then _Print("|cFFFFAA55Self diagnostic:|r ", format(message, ...)); end end;


    function T._ExportCustomSpellConfiguration () -- (use pcall with this) -- {{{

        local errorPrefix = function (message)
            return "_ExportCustomSpellConfiguration: " .. message;
        end

        local customSpellConfText = {};
        local D = T.Dcr;

        if not D.classprofile or not D.classprofile.UserSpells then
            return errorPrefix("D.classprofile.UserSpells not available");
        end

        customSpellConfText[1] = "\nCustom spells configuration:\n";

        for spellID, spellData in pairs(D.classprofile.UserSpells) do
            if not spellData.IsDefault then
                 customSpellConfText[#customSpellConfText + 1] = ("    %s (id: %d) - %s - %s - %s - B: %d - Ts: %s - UF: %s - Macro: %s\n"):format(
                 --                                                                  3    4    5       6        7        8           9
                 tostring(spellData.IsItem and (GetItemInfo(spellID * -1)) or (GetSpellInfo(spellID))), spellID,
                 spellData.Disabled and "OFF" or "ON", -- 3
                 spellData.Pet and "PET" or "PLAYER", -- 4
                 spellData.IsItem and "ITEM" or "SPELL", -- 5
                 spellData.Better, -- 6
                 D:tAsString(spellData.Types), -- 7
                 D:tAsString(spellData.UnitFiltering), -- 8
                 spellData.MacroText and spellData.MacroText or "false" -- 9
                 );
            end
        end

        return table.concat(customSpellConfText, "\n");
    end
    function T._ExportActionsConfiguration () -- (use pcall with this) -- {{{

        local errorPrefix = function (message)
            return "_ExportActionsConfiguration: " .. message;
        end

        local SpellAssignmentsTexts = {};
        local D = T.Dcr;

        if not D.Status then
            return errorPrefix("D.Status not available");
        end

        local sucess, MouseButtons = pcall(function ()return D.db.global.MouseButtons end);

        if not sucess then
            return errorPrefix("couldn't get MouseButtons: " .. MouseButtons);
        end

        SpellAssignmentsTexts[1] = "\nSpells assignments:";

        for Spell, Prio in pairs(D.Status.CuringSpellsPrio) do

            local SpellCuredTypes = {};
            for typeprio, afflictionType in ipairs(D.Status.ReversedCureOrder) do

                if D.Status.CuringSpells[afflictionType] == Spell then
                    table.insert(SpellCuredTypes, DC.TypeToLocalizableTypeNames[afflictionType])
                end
            end

            SpellCuredTypes = table.concat (SpellCuredTypes, " - ");

            SpellAssignmentsTexts[Prio + 1] = string.format("\n    %s -> %s%s", ("%s - %s - (%s)"):format( ("Prio %d:"):format(Prio), SpellCuredTypes, MouseButtons[Prio]), Spell, (D.Status.FoundSpells[Spell] and D.Status.FoundSpells[Spell][5]) and ("\n        MACRO(%d):(%s)"):format(D.Status.FoundSpells[Spell][5]:len(), D.Status.FoundSpells[Spell][5]) or "");
        end
        return table.concat(SpellAssignmentsTexts, "\n");
    end -- }}}

    local LibraryIssues = false; -- always a PBCK
    local Incompatible = false; -- always a PBCK
    local MixedInstall = false; -- always a PBCK
    local MissingFile = false; -- always a PBCK
    local RestartNeeded = false; -- always a PBCK
    local IncompleteLoad = false; -- NOT always a PBCK
    function T._SelfDiagnostic (force, FromCommand)    -- {{{

        -- will not executes several times unless forced
        if not force and T._DiagStatus then
            return T._DiagStatus, LibraryIssues or Incompatible or MixedInstall or MissingFile or RestartNeeded;
        end

        T._DiagStatus = 0; -- will be set to 1 if the diagnostic fails

        -- Table with all the required libraries with their current revision at Decursive release time.

        --LibStub:GetLibrary
        local UseLibStub = {
            ["AceAddon-3.0"] = 12,
            ["AceComm-3.0"] = 12,
            ["AceConsole-3.0"] = 7,
            ["AceDB-3.0"] = 26,
            ["AceDBOptions-3.0"] = 15,
            ["AceEvent-3.0"] = 4,
            ["AceHook-3.0"] = 8,
            ["AceLocale-3.0"] = 6,
            ["AceTimer-3.0"] = 17,

            ["AceGUI-3.0"] = 35,
            ["AceConfig-3.0"] = 3,
            ["AceConfigCmd-3.0"] = 14,
            ["AceConfigDialog-3.0"] = 66,
            ["AceConfigRegistry-3.0"] = 18,

            ["LibDataBroker-1.1"] = 4,
            ["LibDBIcon-1.0"] = 36,
            ["LibQTip-1.0"] = 46,
            ["CallbackHandler-1.0"] = 7,
        };

        local GenericErrorMessage1 = "Decursive could not initialize properly because one or several of the required shared libraries (at least |cFF00FF00LibStub|r) could not be found.\n";
        local GenericErrorMessage2 = "Try to re-install Decursive from its original archive or use the |cFF00FF00Curse client|r (Curse.com) to update |cFFFF0000ALL|r your add-ons properly.\nIf that doesn't work, install the add-ons BugGrabber and BugSack in order to detect other errors preventing Decursive to load properly.\n|cFFF000F0Remember that the WoW client must _NOT_ be running while you install add-ons.|r";

        local ErrorFound = false;
        local Errors = {};
        local FatalOccured = false;

        -- Check each version of the required libraries that use LibStub
        if LibStub then
            for k,v in pairs(UseLibStub) do
                if LibStub:GetLibrary(k, true) then
                    if (select(2, LibStub:GetLibrary(k))) < v then
                        table.insert(Errors, ("The shared library |cFF00FF00%s|r is out-dated, revision |cFF0077FF%s|r at least is required. You have |cFF0077DD%s|r\n"):format(k, tostring(v), select(2, LibStub:GetLibrary(k))));
                        LibraryIssues = true;
                    end
                else
                    table.insert(Errors, ("The shared library |cFF00FF00%s|r could not be found!!!\n"):format(k));
                    FatalOccured = true;
                    LibraryIssues = true;
                end
            end
        else
            table.insert(Errors, GenericErrorMessage1);
            FatalOccured = true;
            LibraryIssues = true;
        end

        local DcrMinTOC = tonumber(GetAddOnMetadata("Decursive", "X-Min-Interface") or 60000); -- once GetAddOnMetadata() was bugged and returned nil...

        -- test if Decursive is backward compatible with the client's version
        if tocversion < DcrMinTOC then
            table.insert(Errors, ("Your World of Warcraft client version (%d) is too old to run this version of Decursive.\n"):format(tocversion));
            GenericErrorMessage2 = "You need to install an older version of Decursive.";
            FatalOccured = true;
            Incompatible = true;
        end

        -- Catch people updating add-ons while WoW is running before they post "it doesn't work!!!!" comments.
        local versionInTOC = GetAddOnMetadata("Decursive", "Version");

        if versionInTOC and versionInTOC ~= VERSION and versionInTOC ~= UNPACKAGED and VERSION ~= UNPACKAGED then
            table.insert(Errors, "You have updated Decursive while WoW was still running in the background.");
            GenericErrorMessage2 = "You need to restart WoW completely or you might experience various issues with your add-ons until you do.";
            FatalOccured = true;
            RestartNeeded = true;
        end

        -- check if all Decursive files are loaded
        --local mixedFileVersionsdetection = {};
        local mixedFileVersionsdetection = {};
        local MixedVersionsCount = 0;
        if not FatalOccured then
            for order, fileName in ipairs (T._LoadOrderedFiles) do

                local version = T._LoadedFiles[fileName];

                if version and version ~= "@pro" .. "ject-version@" and not mixedFileVersionsdetection[version] then
                    mixedFileVersionsdetection[version] = fileName;
                    MixedVersionsCount = MixedVersionsCount + 1;
                end

                if not version then
                    table.insert(Errors, ("The Decursive file |cFF00FF00%s|r could not be loaded! (%s)\n"):format(fileName, version == nil and 'missing' or 'runtime error'));
                    FatalOccured = true;
                    IncompleteLoad = true;
                    MissingFile = version == nil;
                    break;
                end
            end
        end

        if MixedVersionsCount > 1 then
            -- some mixed files were detected
            local MixedDetails = "|cFFFF5599The versions of these files differ|r:\n\n";
            for k,v in pairs (mixedFileVersionsdetection) do
                MixedDetails = ("%s%s --> %s\n"):format(MixedDetails, v, k);
            end

            table.insert(Errors, ("Decursive installation is corrupted, mixed versions detected!\n\n%s\n"):format(MixedDetails));
            FatalOccured = true;
            MixedInstall = true;
        end

        if #Errors > 0 then
            local ErrorString = ("|cFFFF0000%d %s(s)|r found while loading Decursive:\n\n"):format(#Errors, FatalOccured and 'fatal error' or 'error');

            for k, v in pairs (Errors) do
                ErrorString = ErrorString .. v;
            end

            ErrorString = ErrorString .. "\n\n" .. GenericErrorMessage2;

            if _G.DecursiveDebuggingFrame then
               _G.DecursiveDebuggingFrame:Hide();
            end
            T._FatalError(ErrorString);
            T._DiagStatus = FatalOccured and 2 or 1;
        end

        -- if the diagnostic was requested by the user, we also test AceEvent functionalities among a few other things {{{ -
        if force and FromCommand and T._DiagStatus == 0 then

            if not _G.HandleLuaError then
                AddDebugText("|cFFFF0000WARNING Blizzard default error handler is no longer available...|r");
            end

            PrintMessage("|cFF00FF00No problem found in shared libraries or Decursive files!|r");

            PrintMessage("Now checking spell translations...");
            if T.Dcr:SetSpellsTranslations(true) then
                PrintMessage("|cFF00FF00No error found in spell translations!|r");
            end

            AddDebugText("Now checking the event management library...");
            PrintMessage("Now checking the event management library...");
            PrintMessage("If, in about 2 seconds, the message \"|cFF00FF00Event library functionning properly|r\" does not appear then there is a problem");

            local OneTimeEvent = "not set"; local ReapeatingEventRate = 1; local ReapeatingEventCount = 0; local CustomEvent = "DCR_TEST_DIAG_EVENT"; local CustomEventCaught = "not set";
            local ConfirmOneTimeEventMessage = "That was a good time!";
            local ConfirmCustomEventMessage = "I was really caught!";

            -- Register a curstom event
            T.Dcr:RegisterMessage(CustomEvent, function(message, DiagTestArg1) CustomEventCaught = DiagTestArg1; _Debug("CustomEvent callback executed"); end);

            -- Schedule a function call in 0.5s
            T.Dcr:ScheduleDelayedCall("DcrDiagOneTimeEvent",
            function(DiagTestArg2)
                OneTimeEvent = DiagTestArg2;
                _Debug("OneTimeEvent callback executed");
                AddDebugText('delayed call executed');
            end, ReapeatingEventRate / 2, ConfirmOneTimeEventMessage);

            -- Set a repeating function call that will check for other test event completion
            T.Dcr:ScheduleRepeatedCall("DcrDiagRepeat",
            function (argTest)
                local argtestdone = false;
                if not argtestdone and argTest ~= "test" then
                    AddDebugText("Event lib management error: argument could not be read!");
                    PrintMessage("|cFFFF0000Event lib management error: argument could not be read!|r");
                    argtestdone = true;
                end

                if OneTimeEvent == ConfirmOneTimeEventMessage and CustomEventCaught == ConfirmCustomEventMessage then
                    T.Dcr:CancelDelayedCall("DcrDiagRepeat");
                    T.Dcr:UnregisterMessage(CustomEvent);
                    PrintMessage("|cFF00FF00Event library functionning properly!|r");
                    PrintMessage("|cFF00FF00Everything seems to be OK.|r");
                    AddDebugText("Event library functionning properly, Everything seems to be OK");
                    -- open the diagnostic window
                    T._ShowDebugReport(true);
                    return;
                else
                    _Debug(OneTimeEvent, "is not", ConfirmOneTimeEventMessage, "and", CustomEventCaught, "is not", ConfirmCustomEventMessage);
                end

                -- cast the custom event
                T.Dcr:SendMessage(CustomEvent, ConfirmCustomEventMessage);

                if ReapeatingEventCount == 4 then
                    AddDebugText("A problem occured, OneTimeEvent:", OneTimeEvent, "CustomEventCaught:", CustomEventCaught);
                    PrintMessage("|cFFFF0000A problem occured, OneTimeEvent='%q', CustomEventCaught='%q'|r", OneTimeEvent, CustomEventCaught);
                    T.Dcr:CancelDelayedCall("DcrDiagRepeat");
                    T.Dcr:UnregisterMessage(CustomEvent);
                    return;
                end

                ReapeatingEventCount = ReapeatingEventCount + 1;

            end,
            ReapeatingEventRate, "test");

        end -- }}}

        if T._DiagStatus == 0 then
            DecursiveInstallCorrupted = nil;
        end

        return T._DiagStatus, LibraryIssues or Incompatible or MixedInstall or MissingFile or RestartNeeded;


    end -- }}}
end -- }}}


T._HookErrorHandler();

do
    local IsInRaid = _G.IsInRaid;
    local GetNumGroupMembers = _G.GetNumGroupMembers;
    DC.GetNumRaidMembers = function()
        return IsInRaid() and GetNumGroupMembers() or 0;
    end
end

T._LoadedFiles["Dcr_DIAG.lua"] = "2.7.6.1";
