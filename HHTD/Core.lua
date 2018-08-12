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
    Core.lua
-----


--]=]

--========= NAMING Convention ==========
--      VARIABLES AND FUNCTIONS (upvalues excluded)
-- global variable                == _NAME_WORD2 (underscore + full uppercase)
-- semi-global (file locals)      == NAME_WORD2 (full uppercase)
-- locals to closures or members  == NameWord2
-- locals to functions            == nameWord2
--
--      TABLES
--  globals                       == NAME__WORD2
--  locals                        == name_word2
--  members                       == Name_Word2

-- Debug templates
local ERROR     = 1;
local WARNING   = 2;
local INFO      = 3;
local INFO2     = 4;

local UNPACKAGED = "@pro" .. "ject-version@";
local VERSION = "2.4.9";

local ADDON_NAME, T = ...;

T._FatalError = function (TheError)

    if not StaticPopupDialogs["HHTD_ERROR_FRAME"] then
        StaticPopupDialogs["HHTD_ERROR_FRAME"] = {
            text = "|cFFFF0000HHTD Fatal Error:|r\n\n%s",
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
        StaticPopup_Show ("HHTD_ERROR_FRAME", TheError);
        if T._DiagStatus then
            T._FatalError_Diaplayed = true;
        end
    end
end

T._MessageBox = function (message)

    if not StaticPopupDialogs["HHTD_MESSAGE_FRAME"] then
        StaticPopupDialogs["HHTD_MESSAGE_FRAME"] = {
            text = "|cFFFF1020H.H.T.D. Message|r\n\n%s",
            button1 = "OK",
            OnAccept = function()
                T._MessageBox_Diaplayed = false;
                return false;
            end,
            timeout = 0,
            whileDead = 1,
            hideOnEscape = 0,
            showAlert = true,
            preferredIndex = 3,
        };
    end

    if not T._MessageBox_Diaplayed then
        StaticPopup_Show ("HHTD_MESSAGE_FRAME", message);

    end
end

local _, _, _, tocversion = GetBuildInfo();
T._tocversion = tocversion;

-- === Add-on basics and variable declarations {{{
T.HHTD = LibStub("AceAddon-3.0"):NewAddon("H.H.T.D.", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0");
local HHTD = T.HHTD;

--[===[@debug@
_HHTD_DEBUG = HHTD;
--@end-debug@]===]

HHTD.Localized_Text = LibStub("AceLocale-3.0"):GetLocale("H.H.T.D.", true);

local L = HHTD.Localized_Text;

HHTD.Constants = {};
local HHTD_C = HHTD.Constants;
HHTD_C.WOW8 = (tocversion >= 80000);

--[=[
HHTD_C.Healing_Classes = { -- unused
    ["PRIEST"]  = true,
    ["PALADIN"] = true,
    ["DRUID"]   = true,
    ["SHAMAN"]  = true,
    ["MONK"]    = true,
};
--]=]

HHTD_C.MaxTOC = tonumber(GetAddOnMetadata("HHTD", "X-Max-Interface") or math.huge);

-- Build translation table for classes spec to role
-- needed because WoW API (GetBattlefieldScore) returns a localized specName
do
    -- /spew _HHTD_DEBUG.Constants.CLASS_SPEC_TO_ROLE
    HHTD_C.CLASS_SPEC_TO_ROLE = {}

    local classID, classTag, userSpecNum, specID, specName, role

    for classID = 1, MAX_CLASSES do
        if not HHTD_C.WOW8 then
            classTag = select(2, GetClassInfoByID(classID))
        else
            classTag = C_CreatureInfo.GetClassInfo(classID).classFile
        end

        HHTD_C.CLASS_SPEC_TO_ROLE[classTag] = {}

        userSpecNum = 1

        repeat
            specID, specName = GetSpecializationInfoForClassID(classID, userSpecNum)
            role = specID and GetSpecializationRoleByID(specID) or nil

            if role then
                HHTD_C.CLASS_SPEC_TO_ROLE[classTag][specName] = role
                userSpecNum = userSpecNum + 1
            end
        until not role
        
    end

end


-- The header for HHTD key bindings
BINDING_HEADER_HHTD = "H.H.T.D.";
BINDING_NAME_HHTDP = L["OPT_POST_ANNOUNCE_ENABLE"];



HHTD.Friendly_Healers_Attacked_by_GUID = {};

HHTD.LOGS = {
    [true] = {}, -- [guid] = healer_log_template
    [false] = {}, -- [guid] = healer_log_template
};

HHTD.DelayedFunctionCallsCount  = 0;
HHTD.DelayedFunctionCalls       = {};

do
    local _, _, _, interface = GetBuildInfo();
    HHTD.MOP = (interface >= 50000);
end

--[=[
local healer_template = {
    guid        = "",
    name        = "unknown",
    isUnique    = true,
    isTrueHeal  = false,
    isHuman     = true,
    healDone    = 0,
    rank        = -1,
    _lastSort    = 0,
};
--]=]

HHTD.Registry_by_GUID = {
    [true] = {}, -- [guid] = healer_template
    [false] = {}, -- [guid] = healer_template
}

HHTD.Registry_by_Name = {
    [true] = {}, -- [name] = healer_template
    [false] = {}, -- [name] = healer_template
}
-- upvalues {{{
local _G                = _G;
local UnitIsPlayer      = _G.UnitIsPlayer;
local UnitIsDead        = _G.UnitIsDead;
local UnitFactionGroup  = _G.UnitFactionGroup;
local UnitGUID          = _G.UnitGUID;
local UnitIsUnit        = _G.UnitIsUnit;
local UnitClass         = _G.UnitClass;
local UnitName          = _G.UnitName;
local UnitInRaid        = _G.UnitInRaid;
local UnitInParty       = _G.UnitInParty;
local UnitSetRole       = _G.UnitSetRole;
local UnitGroupRolesAssigned = _G.UnitGroupRolesAssigned;
local GetTime           = _G.GetTime;
local pairs             = _G.pairs;
local ipairs            = _G.ipairs;
local unpack            = _G.unpack;
local select            = _G.select;
local InCombatLockdown  = _G.InCombatLockdown;
local UnitIsFriend      = _G.UnitIsFriend;
-- }}}

function HHTD:HHTD_HEALER_GONE(selfevent, isFriend, healer)

    self.Friendly_Healers_Attacked_by_GUID[healer.guid] = nil;
    self.Registry_by_GUID[isFriend][healer.guid]        = nil;
    self.Registry_by_Name[isFriend][healer.name]        = nil;

    -- test if there are others with the same name... *sigh* this sucks
    for guid, healerRecord in pairs (self.Registry_by_GUID[isFriend]) do

        if healerRecord.name == healer.name then
            self.Registry_by_Name[isFriend][healer.name] = healerRecord;

            self:Debug(INFO, "replaced record for", healer.name);

            break;
        end

    end

end



function HHTD:HHTD_HEALER_BORN(selfevent, isFriend, healer)

    self:Debug(INFO, "HHTD:HHTD_HEALER_BORN()");

    HHTD.Registry_by_GUID[isFriend][healer.guid] = healer;
    HHTD.Registry_by_Name[isFriend][healer.name] = healer;

    --[===[@alpha@
    if InCombatLockdown() then
        self:AddDelayedFunctionCall('test', self.Debug, self, INFO2, "After combat lock down test");
    end
    --@end-alpha@]===]

    -- if the player is human and friendly and is part of our group, set his/her role to HEALER
    if self.db.global.SetFriendlyHealersRole then

        if isFriend and healer.isHuman and (UnitInRaid(healer.fullName) or UnitInParty(healer.fullName)) and UnitGroupRolesAssigned(healer.fullName) == 'NONE' then
            if (select(2, GetRaidRosterInfo(UnitInRaid("player") or 1))) > 0 then
                self:Debug(INFO, "Setting role to HEALER for", healer.fullName);

                if InCombatLockdown() then
                    self:AddDelayedFunctionCall("SetRole_"..healer.fullName, UnitSetRole, healer.fullName, 'HEALER');
                else
                    UnitSetRole(healer.fullName, 'HEALER'); -- fails in combat, has become protected in 5.2
                end
            end
        end

    end 

end


-- local function REGISTER_HEALERS_ONLY_SPELLS_ONCE () -- {{{
local function REGISTER_HEALERS_ONLY_SPELLS_ONCE ()

    if HHTD_C.Healers_Only_Spells_ByName then
        return;
    end

    local Healers_Only_Spells_ByID = {

        -- Priests
        --      Discipline
        [047540] = "PRIEST", -- Penance XXX strange error received from user on 2015-10-15 (this spell was cast by a hunter...)
        [109964] = "PRIEST", -- Spirit shell -- not seen in disc
        [002060] = "PRIEST", -- Greater Heal
        [014914] = "PRIEST", -- Holy Fire
        [033206] = "PRIEST", -- Pain Suppression
        [000596] = "PRIEST", -- Prayer of Healing
        [000527] = "PRIEST", -- Purify
        [081749] = "PRIEST", -- Atonement
        [132157] = "PRIEST", -- Holy Nova
        --      Holy
        [034861] = "PRIEST", -- Circle of Healing
        [064843] = "PRIEST", -- Divine Hymn
        [047788] = "PRIEST", -- Guardian Spirit
        [032546] = "PRIEST", -- Binding Heal
        [077485] = "PRIEST", -- Mastery: Echo of Light -- the passibe ability
        [077489] = "PRIEST", -- Echo of Light -- the aura applied by the afformentioned
        [000139] = "PRIEST", -- Renew

        -- Druids
        --[018562] = "DRUID", -- Swiftmend -- (also available through restoration afinity talent)
        [102342] = "DRUID", -- Ironbark
        [033763] = "DRUID", -- Lifebloom
        [088423] = "DRUID", -- Nature's Cure
        -- [008936] = "DRUID", -- Regrowth -- (also available through restoration afinity talent)
        [033891] = "DRUID", -- Incarnation: Tree of Life
        -- [048438] = "DRUID", -- Wild Growth -- disabled in WoW8: In the feral talents, level 45, you can choose Restoration Affinity, which includes Rejuv, Swiftmend, Wild Growth.
        [000740] = "DRUID", -- Tranquility
        -- [145108] = "DRUID", -- Ysera's Gift -- (also available through restoration afinity talent)
        -- [000774] = "DRUID", -- Rejuvination -- (also available through restoration afinity talent)

        -- Shamans
        [061295] = "SHAMAN", -- Riptide
        [077472] = "SHAMAN", -- Healing Wave
        [098008] = "SHAMAN", -- Spirit link totem
        [001064] = "SHAMAN", -- Chain Heal
        [073920] = "SHAMAN", -- Healing Rain

        -- Paladins
        [020473] = "PALADIN", -- Holy Shock
        [053563] = "PALADIN", -- Beacon of Light
        [082326] = "PALADIN", -- Holy Light
        [085222] = "PALADIN", -- Light of Dawn

        -- Monks
        [115175] = "MONK", -- Soothing Mist
        [115310] = "MONK", -- Revival
        --[116670] = "MONK", -- Vivify all monks have it in WoW8
        [116680] = "MONK", -- Thunder Focus Tea
        [116849] = "MONK", -- Life Cocoon
        [119611] = "MONK", -- Renewing mist

        --[===[@debug@
        -- test bad spell mitigation
        -- those are not healer specific
        -- [031842] = "PALADIN", -- Avenging Wrath - removed in WOW8
        [019750] = "PALADIN", -- Flash of light
        [002061] = "PRIEST",  -- Flash Heal
        -- [005185] = "DRUID",   -- Healing Touch - removed in WOW8
        --@end-debug@]===]
    };

    HHTD_C.Healers_Only_Spells_ByName = {};


    -- /spew _HHTD_DEBUG.Constants.Healers_Only_Spells_ByName
    -- /spew GetSpellInfo(077485)

    for spellID, class in pairs(Healers_Only_Spells_ByID) do

        if (GetSpellInfo(spellID)) then
            HHTD_C.Healers_Only_Spells_ByName[(GetSpellInfo(spellID))] = class;
        else
            HHTD:Debug(ERROR, "Missing spell:", spellID);
        end

    end

    HHTD:Debug(INFO, "Spells registered!");
end -- }}}

-- Modules standards configurations {{{

-- Configure default libraries for modules
HHTD:SetDefaultModuleLibraries( "AceConsole-3.0", "AceEvent-3.0")

-- Set the default prototype for modules
HHTD.MODULE_PROTOTYPE   = {
    OnEnable = function(self) self:Debug(INFO, "prototype OnEnable called!") end,

    OnDisable = function(self) self:Debug(INFO, "prototype OnDisable called!") end,

    OnInitialize = function(self)
        self:Debug(INFO, "prototype OnInitialize called!");
    end,

    Debug = function(self, ...) HHTD.Debug(self, ...) end,

    Error = function(self, m) HHTD.Error (self, m) end,

}

HHTD:SetDefaultModulePrototype( HHTD.MODULE_PROTOTYPE )

-- Set modules' default state to "false"
HHTD:SetDefaultModuleState( false )
-- }}}



-- }}}

-- modules handling functions {{{

function HHTD:SetModulesStates ()
    for moduleName, module in self:IterateModules() do
        self:Debug(INFO2, 'enabling module:', moduleName);
        module:SetEnabledState(self.db.global.Modules[moduleName].Enabled);
    end
end

-- }}}

-- 03 Ghosts I

-- == Options and defaults {{{
do

    local AceOptionAntiStupidity = 0;
    local FormattedLogs = "";

    local function FormatLogs()

        if GetTime() - AceOptionAntiStupidity < 0.1 then
            HHTD:Debug(INFO, "AceOption is stupid");
            return FormattedLogs;
        else
            AceOptionAntiStupidity = GetTime();
        end

        local output        = "";

        for _, isFriend in ipairs({false,true}) do

            local tmp           = {};

            for guid, log in HHTD:pairs_ordered(HHTD.LOGS[isFriend], true, 'healDone') do

                local isActive = HHTD.Registry_by_GUID[isFriend][guid];

                local spellsStats = {}
                local j = 1;

                for spell, spellcount in HHTD:pairs_ordered(log.spells, true) do
                    spellsStats[j] = ("    %s (|cFFAA0000%d|r)"):format(HHTD:ColorText(spell, HHTD_C.Healers_Only_Spells_ByName[spell] and "FFC000C0" or "FFC0C0C0"), spellcount);
                    j = j + 1;
                end

                tmp[#tmp + 1] = ("%s (|cff00dd00%s|r)%s [|cffbbbbbb%s|r]:  %s\n%s\n"):format(
                (HHTD:ColorText("#(%s)|r '%s'", log.isFriend and "FF00FF00" or "FFFF0000")):format(
                    isActive and isActive.rank or '-',
                    HHTD:ColorText(log.name, log.isTrueHeal and HHTD:GetClassHexColor(log.isTrueHeal) or "FFAAAAAA" )
                    ),
                tostring(log.healDone > 0 and log.healDone or L["NO_DATA"]),
                log.healDone > HHTD.HealThreshold and "" or L["LOG_BELOW_THRESHOLD"],
                log.isHuman and L["HUMAN"] or L["NPC"],
                HHTD:ColorText(isActive and L["LOG_ACTIVE"] or L["LOG_IDLE"], isActive and "FF00EE00" or "FFEE0000"),
                table.concat(spellsStats, '\n')
                );

            end

            output = output .. table.concat(tmp, '\n') .. '\n';

        end

        FormattedLogs = output;
        return output;
    end


    local function GetCoreOptions() -- {{{
    return {
        type = 'group',
        get = function (info) return HHTD.db.global[info[#info]]; end,
        set = function (info, value) HHTD:SetHandler(HHTD, info, value) end,
        disabled = function () return not HHTD:IsEnabled(); end,
        childGroups = 'tab',
        name = "H.H.T.D.",
        args = {
            Description = {
                type = 'description',
                name = L["DESCRIPTION"],
                order = 0,
            },
            On = {
                type = 'toggle',
                name = L["OPT_ON"],
                desc = L["OPT_ON_DESC"],
                set = function(info) HHTD.db.global.Enabled = true; HHTD:Enable(); return HHTD.db.global.Enabled; end,
                get = function(info) return HHTD:IsEnabled(); end,
                hidden = function() return HHTD:IsEnabled(); end, 

                disabled = false,
                order = 1,
            },
            Off = {
                type = 'toggle',
                name = L["OPT_OFF"],
                desc = L["OPT_OFF_DESC"],
                set = function(info) HHTD.db.global.Enabled = not HHTD:Disable(); return not HHTD.db.global.Enabled; end,
                get = function(info) return not HHTD:IsEnabled(); end,
                guiHidden = true,
                hidden = function() return not HHTD:IsEnabled(); end, 
                order = -1,
            },
            Debug = {
                type = 'toggle',
                name = L["OPT_DEBUG"],
                desc = L["OPT_DEBUG_DESC"],
                guiHidden = true,
                disabled = false,
                order = -2,
            },
            DebugLevel = {
                type = 'range',
                name = L["OPT_DEBUGLEVEL"],
                desc = L["OPT_DEBUGLEVEL_DESC"],
                min = 1,
                max = 3,
                guiHidden = true,
                disabled = false,
                order = -3,
            },
            
            Version = {
                type = 'execute',
                name = L["OPT_VERSION"],
                desc = L["OPT_VERSION_DESC"],
                guiHidden = true,
                func = function () HHTD:Print(L["VERSION"], '2.4.9,', L["RELEASE_DATE"], '2018-08-12T11:09:16Z') end,
                order = -5,
            },
            ShowGUI = {
                type = 'execute',
                name = L["OPT_GUI"],
                desc = L["OPT_GUI_DESC"],
                guiHidden = true,
                func = function () LibStub("AceConfigDialog-3.0"):Open(tostring(HHTD)) end,
                order = -6,
            },
            core = {
                type = 'group',
                name =  L["OPT_CORE_OPTIONS"],
                order = 1,
                args = {
                    Info_Header = {
                        type = 'header',
                        name = L["VERSION"] .. ' 2.4.9 -- ' .. L["RELEASE_DATE"] .. ' 2018-08-12T11:09:16Z',
                        order = 1,
                    },
                    Pve = {
                        type = 'toggle',
                        name = L["OPT_PVE"],
                        desc = L["OPT_PVE_DESC"],
                        order = 200,
                    },
                    PvpHSpecsOnly = {
                        type = 'toggle',
                        width = 'double',
                        name = L["OPT_PVPHEALERSSPECSONLY"],
                        desc = L["OPT_PVPHEALERSSPECSONLY_DESC"],
                        order = 300,
                    },
                    Log = {
                        type = 'toggle',
                        name = L["OPT_LOG"],
                        desc = L["OPT_LOG_DESC"],
                        disabled = false,
                        order = 350,
                    },
                    ShowChatCommandReminder = {
                        type = 'toggle',
                        name = L["OPT_SHOW_CHAT_COMMAND_REMINDER"],
                        desc = L["OPT_SHOW_CHAT_COMMAND_REMINDER_DESC"],
                        width = 'double',
                        order = 352,
                    },
                    testOnTarget = {
                        type = 'execute',
                        width = 'double',
                        name = L["OPT_TESTONTARGET"],
                        desc = L["OPT_TESTONTARGET_DESC"],
                        func = function ()
                            if (UnitGUID("target")) then
                                HHTD:MakeDummyEvent("target");
                            else
                                HHTD:Print( L["OPT_TESTONTARGET_ENOTARGET"] );
                            end

                        end,
                        order = 355,
                    },
                    Modules = {
                        type = 'group',
                        name = L["OPT_MODULES"],
                        inline = true,
                        handler = {
                            ["hidden"]   = function () return not HHTD:IsEnabled(); end,
                            ["disabled"] = function () return not HHTD:IsEnabled(); end,

                            ["get"] = function (handler, info) return (HHTD:GetModule(info[#info])):IsEnabled(); end,
                            ["set"] = function (handler, info, value) 

                                HHTD.db.global.Modules[info[#info]].Enabled = value;
                                local result;

                                if value then
                                    result = HHTD:EnableModule(info[#info]);
                                    if result then
                                        HHTD:Print(info[#info], HHTD:ColorText(L["OPT_ON"], "FF00FF00"));
                                    end
                                else
                                    result = HHTD:DisableModule(info[#info]);
                                    if result then
                                        HHTD:Print(info[#info], HHTD:ColorText(L["OPT_OFF"], "FFFF0000"));
                                    end
                                end

                                return result;
                            end,
                        },
                        -- Enable-modules-check-boxes (filled by modules)
                        args = {},
                        order = 900,
                    },
                    Header1 = {
                        type = 'header',
                        name = "|cFFDD0000"..L["OPT_HEADER_GLOBAL_ENEMY_HEALER_OPTIONS"].."|r",
                        order = 400,
                    },
                    HFT = {
                        type = "range",
                        name = L["OPT_HEALER_FORGET_TIMER"],
                        desc = L["OPT_HEALER_FORGET_TIMER_DESC"],
                        min = 10,
                        max = 60 * 10,
                        step = 1,
                        bigStep = 5,
                        order = 500,
                    },
                    UHMHAP = {
                        type = "toggle",
                        width = 'double',
                        name = L["OPT_USE_HEALER_MINIMUM_HEAL_AMOUNT"],
                        desc = L["OPT_USE_HEALER_MINIMUM_HEAL_AMOUNT_DESC"],
                        order = 600,
                    },
                    HMHAP = {
                        type = "range",
                        width = 'double',
                        disabled = function() return not HHTD.db.global.UHMHAP or not HHTD:IsEnabled(); end,
                        name = function() HHTD:UpdateHealThresholds(); return (L["OPT_HEALER_MINIMUM_HEAL_AMOUNT"]):format(HHTD.HealThreshold) end,
                        desc = L["OPT_HEALER_MINIMUM_HEAL_AMOUNT_DESC"],
                        min = 0.01,
                        max = 6,
                        softMax = 3,
                        step = 0.01,
                        bigStep = 0.03,
                        order = 650,
                        isPercent = true,

                        set = function (info, value)
                            HHTD:SetHandler(HHTD, info, value);
                            HHTD:UpdateHealThresholds();
                        end,
                    },
                    Header2 = {
                        type = 'header',
                        name = "|cFF00DD00"..L["OPT_HEADER_GLOBAL_FRIENDLY_HEALER_OPTIONS"].."|r",
                        order = 655,
                    },
                    SetFriendlyHealersRole = {
                        type = 'toggle',
                        width = 'double',
                        name = L["OPT_SET_FRIENDLY_HEALERS_ROLE"],
                        desc = L["OPT_SET_FRIENDLY_HEALERS_ROLE_DESC"],
                        order = 660,
                    },
                    HealerUnderAttackAlerts = {
                        type = 'toggle',
                        name = L["OPT_HEALER_UNDER_ATTACK_ALERTS"],
                        desc = function() HHTD:UpdateHealThresholds(); return (L["OPT_HEALER_UNDER_ATTACK_ALERTS_DESC"]):format(HHTD.ProtectDamageThreshold) end,
                        order = 670,
                    },
                    PHMDAP = {
                        type = "range",
                        width = 'double',
                        disabled = function() return not HHTD.db.global.HealerUnderAttackAlerts or not HHTD:IsEnabled(); end,
                        name = function() HHTD:UpdateHealThresholds(); return (L["OPT_PROTECT_HEALER_MINIMUM_DAMAGE_AMOUNT"]):format(HHTD.ProtectDamageThreshold) end,
                        desc = L["OPT_PROTECT_HEALER_MINIMUM_DAMAGE_AMOUNT_DESC"],
                        min = 0.01,
                        max = 6,
                        softMax = 3,
                        step = 0.01,
                        bigStep = 0.03,
                        order = 675,
                        isPercent = true,

                        set = function (info, value)
                            HHTD:SetHandler(HHTD, info, value);
                            HHTD:UpdateHealThresholds();
                        end,
                    },
                    Header1000 = {
                        type = 'header',
                        name = '',
                        order = 999,
                    },
                },
            },
            Logs = {
                type = 'group',
                name =  L["OPT_LOGS"],
                desc = L["OPT_LOGS_DESC"],
                order = -1,
                hidden = function() return not HHTD.db.global.Log end,
                args = {
                    clear = {
                        type = 'execute',
                        name = L["OPT_CLEAR_LOGS"],
                        confirm = true,
                        func = function () 
                            HHTD.LOGS[true]  = {};
                            HHTD.LOGS[false] = {};
                        end,
                        order = 0,

                    },
                    AccusationFacts = { -- {{{
                        type = 'description',
                        name = FormatLogs,
                        order = 1,
                    }, -- }}}
                },
            },
        },
    };
    end -- }}}

    -- Used in Ace3 option table to get feedback when setting options through command line
    function HHTD:SetHandler (module, info, value)

        module.db.global[info[#info]] = value;

        if info["uiType"] == "cmd" then

            if value == true then
                value = L["OPT_ON"];
            elseif value == false then
                value = L["OPT_OFF"];
            end

            self:Print(HHTD:ColorText(HHTD:GetOPtionPath(info), "FF00DD00"), "=>", HHTD:ColorText(value, "FF3399EE"));
        end
    end
    

    local Enable_Module_CheckBox = {
        type = 'toggle',
        name = function (info) return L[info[#info]] end, -- it should be the localized module name
        desc = function (info) return L[info[#info] .. "_DESC"] end, 
        get = "get",
        set = "set",
        disabled = "disabled",
    };

    -- get the option tables feeding it with the core options and adding modules options
    function HHTD.GetOptions()
        local options = GetCoreOptions();

        -- Add modules enable/disable checkboxes
        for moduleName, module in HHTD:IterateModules() do
            if not options.args.core.args.Modules.args[moduleName] then
                options.args.core.args.Modules.args[moduleName] = Enable_Module_CheckBox;
            else
                error("HHTD: module name collision!");
            end
            -- Add modules specific options
            if module.GetOptions then
                if module:IsEnabled() then
                    if not options.plugins then options.plugins = {} end;
                    options.plugins[moduleName] = module:GetOptions();
                end
            end
        end

        return options;
    end
end


local DEFAULT__CONFIGURATION = {
    global = {
        Modules = {
            ['**'] = {
                Enabled = true, -- Modules are enabled by default
            },
        },
        HFT = 60,
        Enabled = true,
        Debug = false,
        DebugLevel = 1,
        --[===[@alpha@
        Debug = true,
        DebugLevel = 2,
        --@end-alpha@]===]
        Log = false,
        Pve = true,
        PvpHSpecsOnly = false,
        UHMHAP = true,
        HMHAP = 0.5,
        PHMDAP = 0.20,
        SetFriendlyHealersRole = true,
        HealerUnderAttackAlerts = true,
        ShowChatCommandReminder = true,
    },
};
-- }}}

-- = Add-on Management functions {{{
do
    local oldName = "Healers-Have-To-Die"
    local oldAce3Name = "Healers Have To Die"
    local oldSV   = "Healers_Have_To_Die"

    local function transmuteSettings() 

        -- I've chosen to rename this add-on, let's handle this decision properly
        -- so that it'll be transparent to the users.

        local function disableOldName()
            local old = LibStub("AceAddon-3.0"):GetAddon(oldAce3Name, true);

            if old then
                -- if it's the full add-on turn it off properly
                old:Disable();
            end

            HHTD:Debug(WARNING, "the old " .. oldName .. " has been disabled for this character");
            -- disable oldName only on the current character
            -- DisableAddOn(oldName); -- on a second thought it's best to do
            -- nothing here, it's soft disabled already, that's enough, this
            -- allows to retain the enable/disable state through settings
            -- resets without causing strange unexpected things...
        end

        --
        -- 1 - check if the old name is loaded and running
        -- 2 - import its settings
        -- 3 - disable it
        if GetAddOnEnableState(UnitName("player"), oldName) == 2 then
            if type(_G[oldSV]) == 'table' then

                if not _G[oldSV].global then
                    _G[oldSV].global = {};
                end

                -- have we already transferred the settings?
                if not HHTD_SavedVariables or not HHTD_SavedVariables.global or not HHTD_SavedVariables.global.settingsMigrated
                    or not _G[oldSV].global.settingsTransmuted then
                    HHTD:Debug(WARNING, "Getting settings from " .. oldName .. "...");

                    if not HHTD_SavedVariables then
                        HHTD_SavedVariables = {};
                    end

                    HHTD:tcopy(HHTD_SavedVariables, _G[oldSV]);

                    HHTD_SavedVariables.global.settingsMigrated = true;
                    HHTD_SavedVariables.global.Enabled = true;

                    HHTD:tcopy(_G[oldSV].global, {["settingsTransmuted"] = "settings switched to new H.H.T.D add-on", ["Enabled"] = false})

                    HHTD:Debug(WARNING, "done. Now disabling " .. oldName .. "...");
                    disableOldName();
                elseif _G[oldSV].global and _G[oldSV].global.settingsTransmuted then
                    HHTD:Debug(WARNING, "Settings already tranferred from " .. oldName);
                    disableOldName();
                    _G[oldSV].global.Enabled = false;
                end
            else
                -- oldName was enabled but no settings were found.
                -- Either there are none or oldName has not been loaded yet...
                return false;
            end

            return true;
        end

    end


    function HHTD:OnInitialize()
        -- Catch people updating add-ons while WoW is running before they post "it doesn't work!!!!" comments.
        local versionInTOC = GetAddOnMetadata("HHTD", "Version");
        if versionInTOC and versionInTOC ~= VERSION and versionInTOC ~= UNPACKAGED and VERSION ~= UNPACKAGED then
            --T._DiagStatus = 2;
            --T._Diagmessage = "You have updated H.H.T.D while WoW was still running in the background.\n\nYou need to restart WoW completely or you might experience various issues with your add-ons until you do.";
            --T._FatalError(T._Diagmessage);
        end


        local oldNameGState = select(5, GetAddOnInfo(oldName));
        local oldNameGEnableState = GetAddOnEnableState(nil, oldName);
        local oldNameLState = GetAddOnEnableState(UnitName("player"), oldName);
        local TSsuccess, TSstatus = pcall(transmuteSettings);

        if not TSsuccess then
            T._DiagStatus = 2;
            T._Diagmessage = "Settings transfer from '" .. oldName .. "' to '" .. ADDON_NAME .. "' failed. " .. ADDON_NAME ..
            " will stay disabled. Error was: " .. TSstatus .. "\n\n" .. debugstack(2,1,1);

            T._FatalError(T._Diagmessage);
            return false;
        elseif TSstatus then
            self:Debug(WARNING, "Previous settings were successfully transferred.");

        end

        self.db = LibStub("AceDB-3.0"):New("HHTD_SavedVariables", DEFAULT__CONFIGURATION);

        -- store once the status of the oldName
        if self.db.global.oldNameEnableState == nil then
            self.db.global.oldNameEnableState = oldNameGEnableState; -- 0 == disabled everywhere, 1 partially, 2 globally enabled
        end

        if TSstatus and not self.db.char.settingsMigrated then
            --T._MessageBox((L["HHTD_IS_NOW_KNOWN_AS_H.H.T.D."]):format(oldName, oldName));
            self.db.char.settingsMigrated = true;
        end

        LibStub("AceConfig-3.0"):RegisterOptionsTable(tostring(self), self.GetOptions, {"hhtd", "H.H.T.D."});
        --LibStub("AceConfigDialog-3.0"):AddToBlizOptions(tostring(self));
        self:RegisterChatCommand('hhtdg', function() LibStub("AceConfigDialog-3.0"):Open(tostring(self)) end, true);
        self:CreateClassColorTables();

        -- if the user previously disabled the oldName then we don't want to intrude
        -- NOTE: once the old add-on is disabled on all characters and the user
        -- reset their settings then this code will be triggered :/
        -- Just make sure that it can be triggered only once...
        -- maybe add a delay?
        if oldNameGState == "DISABLED" and self.db.global.settingsMigrated == nil then
            self:Debug(WARNING, oldName .. " was already disabled for all characters, quitting.");
            self:SetEnabledState(false);
            DisableAddOn(ADDON_NAME, true); -- disable globaly as the oldName was
            self:Debug(WARNING, "globally disabled");
        elseif oldNameGState ~= "DISABLED" and oldNameLState == 0 and self.db.char.settingsMigrated == nil 
            -- and there was actually a per character emable/disable setting
            and self.db.global.oldNameEnableState == 1 then
            -- The oldName was already disabled for this specific character
            self:SetEnabledState(false);
            self:Debug(WARNING, "disabled for this character as", oldName, "was already disabled for", (UnitName("player")));
            DisableAddOn(ADDON_NAME);
        else
            self:SetEnabledState(self.db.global.Enabled);
        end


        -- if we manage to run once on this character make sure that any
        -- disable action on the oldName will not trigger the above code
        if self.db.char.settingsMigrated == nil then
            self.db.char.settingsMigrated = false;
        end

        if self.db.global.settingsMigrated == nil then
            -- if we're here it means that no setting were transferred but
            -- that we found no reason to auto-disable make sure not to find
            -- one in the future
            self.db.global.settingsMigrated = false;
        end
    end

    function HHTD:ADDON_LOADED(selfEvent, addOnName)
        if addOnName == oldName then
            self:Debug(WARNING, oldName .. " was post-loaded... reinitializing!");
            T._DiagStatus = 1;
            self:Disable();
            self.db = nil;
            self:OnInitialize();
            self:Enable();
            T._DiagStatus = nil;
        end
    end
end

HHTD_C.PLAYER_FACTION = "";
HHTD_C.PLAYER_GUID    = "";
function HHTD:OnEnable()

    if T._DiagStatus == 2 then
        self:Disable();
        return;
    end

    REGISTER_HEALERS_ONLY_SPELLS_ONCE ();

    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE");
    self:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "TestUnit");
    self:RegisterEvent("PLAYER_TARGET_CHANGED", "TestUnit");
    self:RegisterEvent("PLAYER_ALIVE"); -- talents SHOULD be available
    self:RegisterEvent("ADDON_LOADED");
    -- self:RegisterEvent("PARTY_MEMBER_DISABLE"); -- useless event, no argument...
   
    if not T._DiagStatus and self.db.global.ShowChatCommandReminder then
        --self:Print(L["ENABLED"]);
    end

    self:SetModulesStates();

    HHTD_C.PLAYER_FACTION = UnitFactionGroup("player");
    HHTD_C.PLAYER_GUID    = UnitGUID("player");

    self:ScheduleRepeatingTimer(self.Undertaker,           10, self);
    self:ScheduleRepeatingTimer(self.UpdateHealThresholds, 50, self);

end

function HHTD:PLAYER_ALIVE()
    self:Debug(INFO, "PLAYER_ALIVE");

    HHTD_C.PLAYER_FACTION = UnitFactionGroup("player");
    HHTD_C.PLAYER_GUID    = UnitGUID("player");
    HHTD:UpdateHealThresholds();

    self:UnregisterEvent("PLAYER_ALIVE");
end

function HHTD:PARTY_MEMBER_DISABLE(e, unit)
    self:Debug(INFO2, "PARTY_MEMBER_DISABLE:", unit);
end

function HHTD:OnDisable()

    if not T._DiagStatus then
        self:Print(L["DISABLED"]);
    end

    if T._DiagStatus == 2 then
        self:Print("|cFFD00000"..T._Diagmessage.."|r");
    end

end
-- }}}

HHTD.HealThreshold = math.huge;
HHTD.ProtectDamageThreshold = math.huge;
local UnitHealthMax = _G.UnitHealthMax;
function HHTD:UpdateHealThresholds()

    local PlayerMaxH = UnitHealthMax('player')

    self.HealThreshold          = math.ceil(self.db.global.HMHAP  * PlayerMaxH);
    self.ProtectDamageThreshold = math.ceil(self.db.global.PHMDAP * PlayerMaxH);
end


-- MouseOver and Target trigger {{{
do
    local LastDetectedGUID = "";
    function HHTD:TestUnit(eventName) -- XXX to check/rewrite

        local unit="";
        local pve = HHTD.db.global.Pve;

        if eventName=="UPDATE_MOUSEOVER_UNIT" then
            unit = "mouseover";
        elseif eventName=="PLAYER_TARGET_CHANGED" then
            unit = "target";
        else
            self:Print("called on invalid event");
            return;
        end

        local unitGuid = UnitGUID(unit);
        local isFriend = UnitIsFriend(unit, 'player')==1 and true or false;

        --self:Debug(INFO, "HHTD:TestUnit()", unitGuid, isFriend);

        if not unitGuid then
            --self:Debug(WARNING, "No unit GUID");
            return;
        end

        local unitFirstName, unitRealm = UnitName(unit);

        if HHTD.Registry_by_GUID[isFriend][unitGuid] then

            -- remove dead units
            if UnitIsDead(unit) then
                self:Reap(unitGuid, isFriend, true);
                return;
            end

            if LastDetectedGUID == unitGuid and unit == "target" then
                self:SendMessage("HHTD_TARGET_LOCKED", isFriend, HHTD.Registry_by_GUID[isFriend][unitGuid]);
                --self:Debug(INFO, "LastDetectedGUID == unitGuid and unit == \"target\""); -- XXX

                return;
            end

            -- Has the unit healed recently?
            if not UnitIsUnit("mouseover", "target") and unit == "mouseover" then
                -- Is this sitill true?

                self:SendMessage("HHTD_HEALER_MOUSE_OVER", isFriend, HHTD.Registry_by_GUID[isFriend][unitGuid]);
                --self:Debug(INFO, "HHTD_HEALER_UNDER_MOUSE"); -- XXX
                LastDetectedGUID = unitGuid;
            end
        end
        
    end
end -- }}}


do

    --up values
    
    local str_match                   = _G.string.match;
    local GetTime                     = _G.GetTime;
    local RequestBattlefieldScoreData = _G.RequestBattlefieldScoreData;

    local pairs                     = _G.pairs;
    local ipairs                    = _G.ipairs;
    local TableWipe                 = _G.table.wipe;
    local TableSort                 = _G.table.sort;

    local WIPRBSD = {false, nil, 0};

    function HHTD:UPDATE_BATTLEFIELD_SCORE()
        --[===[@alpha@
        self:Debug(INFO, "UPDATE_BATTLEFIELD_SCORE")
        --@end-alpha@]===]

        WIPRBSD[1] = false
    end

    -- Healer management {{{


    local ReapSchedulers = {};

    local Private_registry_by_GUID = {
        [true] = {}, -- [guid] = healer_template
        [false] = {}, -- [guid] = healer_template
    }

    local Private_registry_by_Name = {
        [true] = {}, -- [name] = healer_template
        [false] = {}, -- [name] = healer_template
    }

    local HealerPool;
    local function sortHealerCallBack(a, b)
        if HealerPool[a].healDone > HealerPool[b].healDone then
            return true;
        else
            return false;
        end
    end

    local SortingTray = {};

    local function UpdateRanks(healerPool)

        HealerPool = healerPool;

        TableWipe(SortingTray);

        for guid in pairs (healerPool) do
            SortingTray[#SortingTray + 1] = guid;
        end

        TableSort(SortingTray, sortHealerCallBack);

        for i, guid in ipairs (SortingTray) do
            healerPool[guid].rank = i;
        end
    end


    local ReapFriend = {
        [true] = function(guid) HHTD:Reap(guid, true); end,
        [false] = function(guid) HHTD:Reap(guid, false); end,
    };

    local function ApointReaper(guid, isFriend, lifespan)
        if ReapSchedulers[guid] then
            HHTD:CancelTimer(ReapSchedulers[guid]);
        end

        -- Take an apointment with the reaper
        ReapSchedulers[guid] = HHTD:ScheduleTimer(ReapFriend[isFriend], lifespan, guid);
        HHTD:Debug(INFO, "A reap is scheduled in", lifespan, "seconds");
    end

    -- send them to oblivion
    function HHTD:Reap (guid, isFriend, force)

        local corpse = Private_registry_by_GUID[isFriend][guid]; -- keep it safe for autopsy

        if not corpse then
            self:Debug(ERROR, ":Reap() called on non-monitored unit:", guid, isFriend, force);
            return;
        end

        if force then
            HHTD:CancelTimer(ReapSchedulers[guid]);
        end

        if GetTime() - corpse.lastMove > self.db.global.HFT or force then

            -- remove the scheduler id that brought us here
            ReapSchedulers[guid]                            = nil;
            -- clean the mess
            Private_registry_by_GUID[isFriend][guid]        = nil;
            Private_registry_by_Name[isFriend][corpse.name] = nil;

            -- announce the (un)timely departure of this healer and expose the corpse for all to see
            self:HHTD_HEALER_GONE("HHTD_HEALER_GONE", isFriend, corpse); -- make sure our handler is the first to be called
            self:SendMessage("HHTD_HEALER_GONE", isFriend, corpse);
            self:Debug(INFO2, corpse.name, "reaped");
        else
            ApointReaper(guid, isFriend, self.db.global.HFT - (GetTime() - corpse.lastMove) + 1);
            self:Debug(INFO2, corpse.name, "is still kicking");
        end
    end

    local GetNumBattlefieldScores = _G.GetNumBattlefieldScores
    local GetBattlefieldScore = _G.GetBattlefieldScore
    local function checkPlayerRealRole(PlayerName, spellName)
        if GetNumBattlefieldScores() == 0 then
            return nil
        end

        -- find the player name (so dirty...)
        local playerIndex = nil
        for i=1, GetNumBattlefieldScores() do
            if (GetBattlefieldScore(i)) == PlayerName then
                playerIndex = i
                break
            end
        end

        if not playerIndex then

            -- there is no async data query in progress
            if not WIPRBSD[1] then
                -- print an error message if the async query is supposed to have
                -- succeeded for that player
                if WIPRBSD[2] == PlayerName then
                    HHTD:Debug(WARNING, "RqBttfldScrDt FAILED", PlayerName, " - GBSL:", GetNumBattlefieldScores()," - fns:", GetNumBattlefieldScores() and GetBattlefieldScore(1))
                end

                -- async data query
                RequestBattlefieldScoreData()

                WIPRBSD[1] = true;
                WIPRBSD[2] = PlayerName;
                WIPRBSD[3] = GetTime();

                HHTD:Debug(WARNING, "RequestBattlefieldScoreData()")
            elseif GetTime() - WIPRBSD[3] > 30 then
                RequestBattlefieldScoreData()
                WIPRBSD[3] = GetTime();

                HHTD:Debug(ERROR, "Still waiting for UPDATE_BATTLEFIELD_SCORE after 30s...")
            end

            return nil
        end

        local spec = select(16, GetBattlefieldScore(playerIndex))
        local classTag = select(9, GetBattlefieldScore(playerIndex)) -- 2016-05-22 seen as nil in one bug report...

        -- since GetBattlefieldScore() returns so many values, we can be sure it won't
        -- stay stable so make sure it won't break HHTD
        if spec and HHTD_C.CLASS_SPEC_TO_ROLE[classTag] then

            -- is this spell correctly classified?
            if HHTD_C.Healers_Only_Spells_ByName[spellName] ~= classTag then
                -- special case for DK's Dark Simulacrum
                -- From some debug reports, Hunters seem to have a similar ability...
                if classTag == "DEATHKNIGHT" or classTag == "HUNTER" then
                    --[===[@debug@
                    HHTD:Debug(ERROR, "Dark Simulacrum-like detected for", PlayerName, classTag)
                    --@end-debug@]===]
                    return false
                end

                HHTD:Debug(ERROR, "(HHTD update required) Bad spell class for:", spellName, '(removed) detected:', HHTD_C.Healers_Only_Spells_ByName[spellName], 'real:', classTag)

                HHTD_C.Healers_Only_Spells_ByName[spellName] = nil
            end

            if HHTD_C.CLASS_SPEC_TO_ROLE[classTag][spec] ~= "HEALER" then
                HHTD:Debug(ERROR, "(HHTD update required) Invalid healer spec spell (spell removed):", spellName, HHTD_C.CLASS_SPEC_TO_ROLE[classTag][spec], spec)
                HHTD_C.Healers_Only_Spells_ByName[spellName] = nil
                return false
            else
                return true
            end
        else
            -- got a few error reports getting here where the classTag was nil on a Paladin... not sure what to do yet, seems rare.
            HHTD:Debug(ERROR, "(HHTD update required) GetBattlefieldScore() API changed", GetBattlefieldScore(playerIndex))
            
            return nil
        end
    end

    -- Neatly add them to our little registry and keep an eye on them
    local record, name;
    local function RegisterHealer (time, isFriend, guid, sourceName, isHuman, spellName, isHealSpell, healDone, configRef) -- {{{

        -- this is a new one, let's create a birth certificate
        if not Private_registry_by_GUID[isFriend][guid] then

            if sourceName then
                name = isHuman and str_match(sourceName, "^[^-]+") or sourceName; -- Remove the server's name (plates don't include it)
            else
                -- XXX fatal error out
                HHTD:Debug(WARNING, "RegisterHealer(): sourceName is missing and healer is new", guid);
                return;
            end

            local isUnique;

            if Private_registry_by_Name[isFriend][name] then
                isUnique = false;
            else
                isUnique = true;
            end

            record = {
                guid        = guid,
                name        = name,
                fullName    = sourceName,
                isUnique    = isUnique,
                isTrueHeal  = false, -- updated later
                isHuman     = isHuman,
                healDone    =  0, -- updated later
                rank        = -1, -- updated later
                _lastSort   =  0, -- updated later
                lastMove    =  0, -- updated later
                isFake      =  nil,
            };

            Private_registry_by_GUID[isFriend][guid] = record;
            Private_registry_by_Name[isFriend][name] = record;

            ApointReaper(guid, isFriend, configRef.HFT);

        else
            -- fetch the existing record
            record = Private_registry_by_GUID[isFriend][guid];
        end

        if isHealSpell then
            -- set/update heal done
            record.healDone = record.healDone + healDone;
        end

        record.lastMove = time;

        -- detect a true healer
        if not record.isTrueHeal and not record.isFake then
            record.isTrueHeal = HHTD_C.Healers_Only_Spells_ByName[spellName] or false;

            -- Guard against WoW patches or spell translation issues and if
            -- possible verify that this player is indeed a true healer using
            -- the scoreboard.
            -- There is also problems with certain abilities such as DK's Dark
            -- Simulacrum which can mimmic other classes' abilities...

            if isHuman and record.isTrueHeal and false == checkPlayerRealRole(sourceName, spellName) then
                record.isTrueHeal = false
                record.isFake = true
                -- if PvpHSpecsOnly is true then we return but we log first if necessary
                if configRef.PvpHSpecsOnly and not configRef.Log then
                    return
                end
            end
        end

        if configRef.Log then -- {{{
            -- also log and keep track of used spells here if option is set
            -- keep in mind that logging can be enabled once a healer has already been registered
            local log;

            if not HHTD.LOGS[isFriend][guid] then
                log = {
                    guid        = guid,
                    name        = name,
                    spells      = {},
                    healDone    = 0,
                    isTrueHeal  = false,
                    isFriend    = isFriend,
                    isHuman     = isHuman,
                };

                HHTD.LOGS[isFriend][guid] = log;
            else
                log = HHTD.LOGS[isFriend][guid];
            end

            if isHealSpell then
                log.healDone = log.healDone + healDone;
            end

            if not log.isTrueHeal then
                log.isTrueHeal  = record.isTrueHeal;
            end

            if not log.spells[spellName] then
                log.spells[spellName] = 1;
            else
                log.spells[spellName] = log.spells[spellName] + 1;
            end

            -- we may get here despite PvpHSpecsOnly if a fake healer was found and
            -- discarded by the scoreboard check. We do log them though
            if not record.isTrueHeal and configRef.PvpHSpecsOnly then
                return
            end
        end -- }}}

        if configRef.UHMHAP and record.healDone < HHTD.HealThreshold then
            --HHTD:Debug(INFO2, sourceName, "is below minimum healed amount:", record.healDone);
            return;
        end

        -- Time-consuming operations every 5 seconds minimum
        if time - record._lastSort > 5 then

            record._lastSort = time;

            -- update the ranks of this healer's side, good or evil
            UpdateRanks(Private_registry_by_GUID[isFriend]);

            if not HHTD.Registry_by_GUID[isFriend][guid] then
                -- Dispatch the news
                --[===[@debug@
                HHTD:Debug(INFO, "Healer detected:", sourceName, 'uhmhap:', configRef.UHMHAP, 'healdone:', record.healDone, 'threshold:', HHTD.HealThreshold);
                --@end-debug@]===]
                HHTD:HHTD_HEALER_BORN("HHTD_HEALER_BORN", isFriend, record); -- make sure ours is the first to be called
                HHTD:SendMessage("HHTD_HEALER_BORN", isFriend, record);
            end

            HHTD:SendMessage("HHTD_HEALER_GROW", isFriend, record);
        end

    end -- }}}

    -- }}}



    -- Combat Event Listener (Main Healer Detection) {{{

    local band                      = _G.bit.band;
    local sub                       = _G.string.sub;
    local CheckInteractDistance     = _G.CheckInteractDistance;

    local HOSTILE_OUTSIDER          = bit.bor (COMBATLOG_OBJECT_AFFILIATION_OUTSIDER, COMBATLOG_OBJECT_REACTION_HOSTILE);
    local HOSTILE                   = COMBATLOG_OBJECT_REACTION_HOSTILE;
    local FRIENDLY                  = COMBATLOG_OBJECT_REACTION_FRIENDLY;

    local HOSTILE_OUTSIDER_NPC      = bit.bor (HOSTILE_OUTSIDER                     , COMBATLOG_OBJECT_TYPE_NPC);
    local FRIENDLY_NPC              = bit.bor (COMBATLOG_OBJECT_REACTION_FRIENDLY   , COMBATLOG_OBJECT_TYPE_NPC);
    local HOSTILE_OUTSIDER_PLAYER   = bit.bor (HOSTILE_OUTSIDER                     , COMBATLOG_OBJECT_TYPE_PLAYER);
    local FRIENDLY_PLAYER           = bit.bor (COMBATLOG_OBJECT_REACTION_FRIENDLY   , COMBATLOG_OBJECT_TYPE_PLAYER);

    local ACCEPTABLE_TARGETS = bit.bor (COMBATLOG_OBJECT_TYPE_PLAYER, COMBATLOG_OBJECT_TYPE_NPC);

    local Source_Is_NPC = false;
    local Source_Is_Human = false;
    local Source_Is_Friendly = false;

    local isHealSpell = false;

    local Registry_by_GUID = HHTD.Registry_by_GUID;


    local registered;

    local prTime, lastAttack_amount_lastAlert


    function HHTD:MakeDummyEvent(unit)
        local destFlags;

        if UnitIsPlayer(unit) then
            if UnitIsFriend(unit, 'player') then
                self:Debug(INFO, "target is a friendly player");
                destFlags = FRIENDLY_PLAYER;
            else
                destFlags = HOSTILE_OUTSIDER_PLAYER;
                self:Debug(INFO, "target is a hostile player");
            end
        else
            if UnitIsFriend(unit, 'player') then
                self:Debug(INFO, "target is a friendly NPC");
                destFlags = FRIENDLY_NPC;
            else
                destFlags = HOSTILE_OUTSIDER_NPC;
                self:Debug(INFO, "target is a hostile NPC");
            end
        end

        local event, srcFlags, srcGUID, srcName, destGUID, destName

        if IsControlKeyDown() and IsShiftKeyDown() then
            event    = "DUMMY_DAMAGE"
            srcFlags = HOSTILE_OUTSIDER_PLAYER
            srcGUID  = 'hostile unit'
            srcName  = 'hostile unit'
            destGUID = UnitGUID(unit);
            destName = UnitName('player') -- so that CheckInteractDistance('unit name', 1) works
            self:Debug(ERROR, "mimicking attack on healer", destName, "(your name so that the alert can be triggered and tested)");
        else
            event    = "DUMMY_HEAL"
            srcFlags = destFlags
            srcGUID  = UnitGUID(unit)
            srcName  = UnitName(unit)
            destGUID = "healed unit"
            destName = "healed unit"
        end

        local class = select(2, UnitClass(unit));
        local dummySpell = ({["DRUID"] = GetSpellInfo(33891), ["SHAMAN"] = GetSpellInfo(974), ["PRIEST"] = GetSpellInfo(109964), ["PALADIN"] = GetSpellInfo(82326), ["MONK"] = GetSpellInfo(115175)})[class] or GetSpellInfo(3273);
        self:COMBAT_LOG_EVENT_UNFILTERED(nil, 0, event, false, srcGUID, srcName, srcFlags, 0, destGUID, destName, destFlags, 0, 0, dummySpell, "", HHTD.HealThreshold + 1);
    end

    -- http://www.wowpedia.org/API_COMBAT_LOG_EVENT
    function HHTD:COMBAT_LOG_EVENT_UNFILTERED(e, timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, _spellID, spellNAME, _spellSCHOOL, _amount)

        --[===[@debug@
        --if hideCaster then
           --self:Debug(ERROR, e, timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, _spellID, spellNAME, _spellSCHOOL, _amount);
        --end
        --@end-debug@]===]

        if HHTD_C.WOW8 and event == nil then
            timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, _spellID, spellNAME, _spellSCHOOL, _amount = CombatLogGetCurrentEventInfo()
        end

        -- escape if no source {{{
        -- untraceable events are useless
        if not sourceGUID or hideCaster then

            if event == "UNIT_DIED" and self.Friendly_Healers_Attacked_by_GUID[destGUID] then
                self.Friendly_Healers_Attacked_by_GUID[destGUID] = nil;
        --[===[@debug@
            self:Debug(ERROR, e, timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, _spellID, spellNAME, _spellSCHOOL, _amount);
        --@end-debug@]===]
            end

            return
        end
        -- }}}

        -- Escape if bad target (not human nor npc) {{{
        -- Healers are only those caring for other players or NPC
        if band(destFlags, ACCEPTABLE_TARGETS) == 0 then
            --[===[@debug@
            --[[
            if self.db.global.Debug and event:sub(-5) == "_HEAL" and sourceGUID ~= destGUID then
                self:Debug(INFO2, "Bad target", sourceName, destName);
            end
            --]]
            --@end-debug@]===]
            return;
        end -- }}}

        local configRef = self.db.global; -- config shortcut

        Source_Is_NPC = false;
        Source_Is_Human = false;
        Source_Is_Friendly = false;

        if band(sourceFlags, HOSTILE_OUTSIDER_NPC) == HOSTILE_OUTSIDER_NPC then
            -- leave here if we don't care about pve healers | caveat: if a friendly healear is attacked by an NPC we won't know about it
            if not configRef.Pve then
                return;
            end
            Source_Is_NPC = true;
        elseif band (sourceFlags, HOSTILE_OUTSIDER_PLAYER) == HOSTILE_OUTSIDER_PLAYER then
            Source_Is_Human = true;
        elseif band (sourceFlags, FRIENDLY_PLAYER) == FRIENDLY_PLAYER then
            Source_Is_Human = true;
            Source_Is_Friendly = true;
        elseif band (sourceFlags, FRIENDLY_NPC) == FRIENDLY_NPC then
            -- leave here if we don't care about pve healers | caveat: none I can think of
            if not configRef.Pve then
                return;
            end
            Source_Is_NPC = true;
            Source_Is_Friendly = true;
        else
            -- not a player or an NPC, why are we even considering this comment?
            return;
        end


        -- check if a healer is under attack - broadcast the event and return {{{
        -- if the source is hostile AND if its target is a registered friendly healer
        if (not Source_Is_Friendly) and (configRef.HealerUnderAttackAlerts and (Source_Is_NPC or Source_Is_Human) and Registry_by_GUID[true][destGUID]) then


            if event == "SWING_DAMAGE" then
               _amount = _spellID 
            end

            if (_amount and event:sub(-7) == "_DAMAGE") then

                -- the healer is nearby
                if HHTD_C.PLAYER_GUID == destGUID or CheckInteractDistance(destName, 1) then

                    -- first attack?
                    if not self.Friendly_Healers_Attacked_by_GUID[destGUID] then
                        self.Friendly_Healers_Attacked_by_GUID[destGUID] = {0, 0, 0};
                    end

                    -- shortcuts
                    lastAttack_amount_lastAlert  = self.Friendly_Healers_Attacked_by_GUID[destGUID]
                    prTime = GetTime()

                    -- less than 5s elapsed since last attacked (influenced below)
                    if prTime - lastAttack_amount_lastAlert[1] < 5 then
                        lastAttack_amount_lastAlert[2] = lastAttack_amount_lastAlert[2] + _amount
                    else
                        lastAttack_amount_lastAlert[2] = _amount
                    end

                    -- register last attack time, put it in the future if the
                    -- attack is more than half the threshold to delay the
                    -- reset by 10s instead of 5s
                    if prTime > lastAttack_amount_lastAlert[1] then
                        lastAttack_amount_lastAlert[1] = prTime + (_amount / self.ProtectDamageThreshold > .5 and 5 or 0)
                    end

                    --[===[@debug@
                    if _amount / self.ProtectDamageThreshold > .5 then
                        self:Debug(WARNING, "amount is huge:", _amount, _amount / self.ProtectDamageThreshold > .5 and 5 or 0);
                    end
                    --@end-debug@]===]

                    -- last alert was more than 30s ago and threshold is reached
                    if prTime - lastAttack_amount_lastAlert[3] > 30 and lastAttack_amount_lastAlert[2] > self.ProtectDamageThreshold then
                        self:SendMessage("HHTD_HEALER_UNDER_ATTACK", sourceName, sourceGUID, destName, destGUID, HHTD_C.PLAYER_GUID == destGUID);

                        lastAttack_amount_lastAlert[3] = GetTime();
                    end

                    --[===[@debug@
                    self:Debug(WARNING, "amount:", _amount, lastAttack_amount_lastAlert[2], event, prTime - lastAttack_amount_lastAlert[3] > 30, lastAttack_amount_lastAlert[2] > self.ProtectDamageThreshold, _amount / self.ProtectDamageThreshold > .5 and 5 or 0);
                    --@end-debug@]===]

                end
            end

            -- it's certainly not a heal so no use to continue past this point.
            return;
        end -- }}}

        -- Escape if bad source (deprecated) {{{
        -- if the source is not a player and if while pve, the source is not an npc, then we don't care about this event
        -- ie: we care if the source is a human player or pve is enaled and the source is an npc.
        --      not (a or (b and c)) ==  !a and (not b or not c)

        ----------if not ( Source_Is_Human or (Source_Is_NPC and configRef.Pve)) then
            ---------return;
        ----------end -- }}}


        -- get a shortcut to the healer profile if it exists
        registered = Private_registry_by_GUID[Source_Is_Friendly][sourceGUID];

        -- Escape if Source_Is_Human and scanning for pure healing specs and the spell doesn't match and the healer is not known as a true healer {{{
        if Source_Is_Human and (configRef.PvpHSpecsOnly and not HHTD_C.Healers_Only_Spells_ByName[spellNAME] and (not registered or not registered.isTrueHeal)) then
            --[===[@debug@
            --self:Debug(INFO2, "Spell", spellNAME, "is not a healer' spell");
            --@end-debug@]===]
            return;
        end -- }}}

        -- a heal but not a self inflicted one
        if sourceGUID ~= destGUID and event:sub(-5) == "_HEAL" then
            isHealSpell = true;
        else
            isHealSpell = false;
        end

        -- Esacpe if it's a heal spell toward a unit hostile to the source
        if isHealSpell and ( Source_Is_Friendly and band(destFlags, HOSTILE)~=0 or not Source_Is_Friendly and band(destFlags, FRIENDLY)~=0 ) then
            --[===[@debug@
            self:Debug(INFO2, "Spell", spellNAME, "source and destination awkwardness", sourceName, destName, 
                (Source_Is_Friendly and band(destFlags, HOSTILE)),
                (not Source_Is_Friendly and band(destFlags, FRIENDLY)));
            --@end-debug@]===]
            return;
        end

         -- Escape if not a heal spell and (not checking for spec's spells or source is a NPC) {{{
         -- we look for healing spells directed to others
         if not isHealSpell and (Source_Is_NPC or not configRef.PvpHSpecsOnly or not HHTD_C.Healers_Only_Spells_ByName[spellNAME]) then
             return false;
         end -- }}}

         -- if we are still here it means that this is a HEAL toward another
         -- player or an ability available to specialized healers only


         if not sourceName then
             self:Debug(WARNING, "NO NAME for GUID:", sourceGUID);
             return;
         end

         RegisterHealer(GetTime(), Source_Is_Friendly, sourceGUID, sourceName, Source_Is_Human, spellNAME, isHealSpell, _amount, configRef);

     end -- }}}

 end

 -- Undertaker {{{
 -- The Undertaker will garbage collect healers who have not been healing recently (whatever the reason...)
 function HHTD:Undertaker()

     local Time = GetTime();

     local Registry_by_GUID = HHTD.Registry_by_GUID;
     --[===[@debug@
     --self:Debug(INFO2, "cleaning...");
     --@end-debug@]===]

     -- clean attacked healers {{{
     -- should also be cleaned when such healer leaves combat -- no event for those...
     for guid, lastAttack_amount_lastAlert in pairs(self.Friendly_Healers_Attacked_by_GUID) do
         -- if more than 30s elapsed since the last attack or if it's no longer a registered healer
         if Time - lastAttack_amount_lastAlert[1] > 30 or not Registry_by_GUID[true][guid] then
             self.Friendly_Healers_Attacked_by_GUID[guid] = nil;
             self:Debug(INFO2, "removed healer from attack table", guid);
         end
     end -- }}}

     -- delayed execution after combat
     if (not InCombatLockdown() and self.DelayedFunctionCallsCount > 0) then
         for id, funcAndArgs in pairs (self.DelayedFunctionCalls) do

             self:Debug(INFO2, "Running post combat command", id);

             funcAndArgs.func(unpack(funcAndArgs.args));

             self.DelayedFunctionCalls[id] = nil; -- remove it from the list
             self.DelayedFunctionCallsCount = self.DelayedFunctionCallsCount - 1;
         end
     end
 end -- }}}

 
