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
if not T._LoadedFiles or not T._LoadedFiles["Dcr_Events.lua"] then
    if not DecursiveInstallCorrupted then T._FatalError("Decursive installation is corrupted! (Dcr_Events.lua not loaded)"); end;
    DecursiveInstallCorrupted = true;
    return;
end
T._LoadedFiles["Dcr_Raid.lua"] = false;

local D = T.Dcr;


local L     = D.L;
local LC    = D.LC;
local DC    = T._C;

local RaidRosterCache           = { };
local SortingTable              = { };
D.Status.Unit_Array_GUIDToUnit  = { };
D.Status.Unit_Array_UnitToGUID  = { };

D.Status.InternalPrioList       = { };
D.Status.InternalSkipList       = { };
D.Status.Unit_Array             = { };

local _G                    = _G;
local pairs                 = _G.pairs;
local ipairs                = _G.ipairs;
local type                  = _G.type;
local select                = _G.select;
local UnitIsFriend          = _G.UnitIsFriend;
local UnitCanAttack         = _G.UnitCanAttack;
local GetNumRaidMembers     = DC.GetNumRaidMembers;
local GetNumPartyMembers    = _G.GetNumSubgroupMembers;

local GetRaidRosterInfo     = _G.GetRaidRosterInfo;
local random                = _G.random;
local UnitIsUnit            = _G.UnitIsUnit;
local UnitClass             = _G.UnitClass;
local UnitExists            = _G.UnitExists;
local UnitGUID              = _G.UnitGUID;
local UnitGroupRolesAssigned= _G.UnitGroupRolesAssigned;
local table                 = _G.table;
local t_insert              = _G.table.insert;
local str_upper             = _G.string.upper;
local MAX_RAID_MEMBERS      = _G.MAX_RAID_MEMBERS;
local setmetatable          = _G.setmetatable;
local rawget                = _G.rawget;
local GetTime               = _G.GetTime;
-------------------------------------------------------------------------------

-- GROUP STATUS UPDATE, these functions update the UNIT table to scan
-------------------------------------------------------------------------------


DC.ClassNumToLName = {
    [11]        = LC[DC.CLASS_DRUID],
    [12]        = LC[DC.CLASS_HUNTER],
    [13]        = LC[DC.CLASS_MAGE],
    [14]        = LC[DC.CLASS_PALADIN],
    [15]        = LC[DC.CLASS_PRIEST],
    [16]        = LC[DC.CLASS_ROGUE],
    [17]        = LC[DC.CLASS_SHAMAN],
    [18]        = LC[DC.CLASS_WARLOCK],
    [19]        = LC[DC.CLASS_WARRIOR],
    [20]        = LC[DC.CLASS_DEATHKNIGHT],
    [21]        = LC[DC.CLASS_MONK],
    [22]        = LC[DC.CLASS_DEMONHUNTER],
}

DC.ClassLNameToNum = D:tReverse(DC.ClassNumToLName);

DC.ClassNumToUName = {
    [11]        = DC.CLASS_DRUID,
    [12]        = DC.CLASS_HUNTER,
    [13]        = DC.CLASS_MAGE,
    [14]        = DC.CLASS_PALADIN,
    [15]        = DC.CLASS_PRIEST,
    [16]        = DC.CLASS_ROGUE,
    [17]        = DC.CLASS_SHAMAN,
    [18]        = DC.CLASS_WARLOCK,
    [19]        = DC.CLASS_WARRIOR,
    [20]        = DC.CLASS_DEATHKNIGHT,
    [21]        = DC.CLASS_MONK,
    [22]        = DC.CLASS_DEMONHUNTER,
}

DC.ClassUNameToNum = D:tReverse(DC.ClassNumToUName);


do

    local _; -- a local dummy trash variable
    local D = D;

    local MAX_RAID_MEMBERS = _G.MAX_RAID_MEMBERS;

    local UnitToGUID = {};
    local GUIDToUnit = {};

    local Raidnum;
    local Status;
    local TestMode;

    -- define some mock function to make testing easier
    local function _UnitExists (unit)
        if not TestMode then
            return UnitExists(unit);
        elseif #SortingTable < D.Status.TestLayoutUNum then
            return true;
        else
            return false;
        end
    end

    local FakeClasses = {};
    local function _UnitClass(unit)
        if not TestMode then
            return UnitClass(unit);
        else
            if UnitClass(unit) then
                return UnitClass(unit);
            end

            local randomClass = FakeClasses[unit] or DC.ClassNumToUName[random(11,22)];
            FakeClasses[unit] = randomClass;
            return randomClass, randomClass;
        end
    end

    local function _UnitGUID (unit)
        if not TestMode then
            return UnitGUID(unit);
        elseif #SortingTable < D.Status.TestLayoutUNum then
            return UnitGUID(unit) or "fakeGUID"..unit.."-"..#SortingTable;
        end
    end

    local function _GetNumRaidMembers()
        if not TestMode then
            return GetNumRaidMembers();
        elseif D.Status.TestLayoutUNum > 5 then
            return D.Status.TestLayoutUNum < MAX_RAID_MEMBERS and D.Status.TestLayoutUNum or MAX_RAID_MEMBERS;
        else
            return 0;
        end
    end

    local FakeGroups = {};
    local FakeGroupsAttribution = {};
    local function _GetRaidRosterInfo(i)
        if not TestMode then
            return GetRaidRosterInfo(i);
        else
            if GetRaidRosterInfo(i) then
                return GetRaidRosterInfo(i);
            end

            local unit = "raid"..i;

            local randomClass = FakeClasses[unit] or DC.ClassNumToUName[random(11,22)];
            FakeClasses[unit] = randomClass;
            local randomGroup;

            if FakeGroupsAttribution[unit] then
                randomGroup = FakeGroupsAttribution[unit];
            else
                repeat
                    randomGroup = random (1,8);
                    if not FakeGroups[randomGroup] then
                        FakeGroups[randomGroup] = 1;
                    elseif FakeGroups[randomGroup] ~= 5 then
                        FakeGroups[randomGroup] = FakeGroups[randomGroup] + 1;
                    end
                until FakeGroups[randomGroup] == 5;

                FakeGroupsAttribution[unit] = randomGroup;
            end

            return "fakeName"..i, nil, randomGroup, nil, nil, randomClass;
        end
    end

    local FakeRoles = {}; local roles = {"HEALER", "TANK", "DAMAGER", "NONE"};
    local function _UnitGroupRolesAssigned(unit)

        if DC.WOWC then
            return "NONE";
        end

        if not TestMode then
            return UnitGroupRolesAssigned(unit);
        elseif not FakeRoles[unit] then
            FakeRoles[unit] = roles[random(1,4)];
        end

        return FakeRoles[unit];
    end

    local UnitToGUID_mt = { __index = function(self, unit)
        local GUID = _UnitGUID(unit) or false;

        self[unit] = GUID;
        GUIDToUnit[GUID] = unit;

        return self[unit];
    end };


    local GUIDToUnit_ScannedAll = false;
    local Lookforpets = true;
    local GUIDToUnit_mt = { __index = function(self, GUID)
        -- {{{

        if GUIDToUnit_ScannedAll then
            self[GUID] = false;
            D:Debug("GUIDToUnit_mt: %s is not in our group!", GUID);
            return self[GUID];
        end

        if (not GUID) then
            D:errln("GUIDToUnit_mt: no GUID! ");
            return false;
        end

        local unit = false;


        if GUID == DC.MyGUID then
            unit = "player";
        elseif GUID == UnitToGUID["pet"] then
            unit = "pet";
        elseif (Raidnum == 0) then
            if GetNumPartyMembers() > 0 then
                if GUID == UnitToGUID["party1"] then
                    unit = "party1";
                elseif GUID == UnitToGUID["party2"] then
                    unit = "party2";
                elseif GUID == UnitToGUID["party3"] then
                    unit = "party3";
                elseif GUID == UnitToGUID["party4"] then
                    unit = "party4";
                elseif D.profile.Scan_Pets then
                    if GUID == UnitToGUID["partypet1"] then
                        unit = "partypet1";
                    elseif GUID == UnitToGUID["partypet2"] then
                        unit = "partypet2";
                    elseif GUID == UnitToGUID["partypet3"] then
                        unit = "partypet3";
                    elseif GUID == UnitToGUID["partypet4"] then
                        unit = "partypet4";
                    end
                end
            end
        else
            -- we are in a raid
            local foundmembers = 0;
            local RaidGUID;
            for i=1, MAX_RAID_MEMBERS do
                RaidGUID = UnitToGUID[ "raid"..i];

                if RaidGUID then

                    foundmembers = foundmembers + 1;

                    if GUID == RaidGUID then
                        unit = "raid"..i;
                        break;
                    end

                    if Lookforpets and D.profile.Scan_Pets and GUID == UnitToGUID["raidpet"..i]  then
                        unit = "raidpet"..i;
                        break;
                    end

                    if foundmembers == Raidnum then
                        break;
                    end
                end
            end
        end

        if not unit then
            GUIDToUnit_ScannedAll = true;
        end

        self[GUID] = unit;

        return self[GUID];
    end };
    --}}}


    local IPL;
    local ISL;
    local function IsInSkipList (GUID, group, classNum, role) -- {{{
        if (   ISL[GUID]
            or ISL[group]
            or ISL[classNum]
            or role ~= "NONE" and ISL[role]) then
            return true;
        end

        return false;
    end -- }}}


    local function a_isBefore_b(a, b)

        if a == b then
            return nil;
        elseif a and b then
            return a < b;
        elseif a and not b then
            return true;
        else
            return false;
        end

    end


    local uaVSub;
    local UIa, UIb;
    local min = math.min;

    local function getMinOf4(ui1,ui2,ui3,ui4)
        local t = min(ui1 or 1337, ui2 or 1337, ui3 or 1337, ui4 or 1337)
        return t ~= 1337 and t or nil;
    end

    local UnitInfo = {};
    local CurrentGroup = 0; -- the group we are in
    local function isUnitBeforeUnit(ua, ub)
        -- pet
        -- humans are > to pets in WoW...
        uaVSub = a_isBefore_b(UnitInfo[ub].isPet, UnitInfo[ua].isPet);

        if uaVSub ~= nil then
            return uaVSub;
        end

        -- Priority list
        UIa = UnitInfo[ua]; UIb = UnitInfo[ub];
        uaVSub = a_isBefore_b(getMinOf4(IPL[UIa.class], IPL[UIa.group], IPL[UIa.GUID], IPL[UIa.role]), getMinOf4(IPL[UIb.class], IPL[UIb.group], IPL[UIb.GUID], IPL[UIb.role]));

        if uaVSub ~= nil then
            return uaVSub;
        end

        -- default group
        uaVSub = a_isBefore_b(UnitInfo[ua].group and (UnitInfo[ua].group + 8 - CurrentGroup) % 8 or nil, UnitInfo[ub].group and (UnitInfo[ub].group + 8 - CurrentGroup) % 8 or nil);

        if uaVSub ~= nil then
            return uaVSub;
        end

         -- default id
        uaVSub = a_isBefore_b(UnitInfo[ua].RaidID, UnitInfo[ub].RaidID);

        if uaVSub ~= nil then
            return uaVSub;
        elseif UnitInfo[ua].GUID == UnitInfo[ub].GUID then
            D:Debug('identity in sort for', UnitInfo[ua].GUID);
            return false;
        else
            D:AddDebugText("impossible sort group issue",
                "Cl:", UnitInfo[ua].class,  UnitInfo[ub].class,
                "Gu:", UnitInfo[ua].GUID,   UnitInfo[ub].GUID,
                "Gr:", UnitInfo[ua].group,  UnitInfo[ub].group,
                "ID:", UnitInfo[ua].RaidID, UnitInfo[ub].RaidID,
                "iP:", UnitInfo[ua].isPet,  UnitInfo[ub].isPet,
                "--:", D:tAsString(SortingTable)
            );
            if D.RunningADevVersion then
                error("impossible sort group issue");
            end
        end

    end

    local function addUnit(unit, id, GUID, group, isPet)

        if Status.Unit_Array_GUIDToUnit[GUID] then
            return;
        end

        Status.Unit_Array_GUIDToUnit[GUID] = unit;
        Status.Unit_Array_UnitToGUID[unit] = GUID;

        t_insert(SortingTable, unit);

        UnitInfo[unit] = {
            ["class"]  = DC.ClassUNameToNum[select(2, _UnitClass(unit))];
            ["GUID"]   = GUID;
            ["group"]  = group;
            ["RaidID"] = id;
            ["isPet"]  = isPet;
            ["role"]   = not isPet and _UnitGroupRolesAssigned(unit) or "NONE";
        }
    end

    local function setInternalList(inList, outList)
        for i, ListEntry in ipairs(inList) do

            -- first add GUIDs present in our raid group
            if (type(ListEntry) == "string") then
                if GUIDToUnit[ListEntry] then
                    outList[ListEntry] = i;
                end

            elseif ListEntry > 0 then
                -- > 0 == groups and classes

                outList[ListEntry] = i;
            else
                -- < 0 == roles
                outList[roles[-ListEntry]] = i;
            end
        end
    end

    local RaidRosterCache = {};

    function D:GetUnitArray() --{{{
        -- if the groups composition did not change
        if not self.Groups_datas_are_invalid or DC.MyGUID == "NONE" then
            return;
        end
        self.Groups_datas_are_invalid = false;

        local pGUID;
        local unit;

        -- These are used in local functions
        Status   = self.Status;
        local myGUID  = DC.MyGUID;


        -- clear all the arrays
        Status.InternalPrioList         = {}; -- these lists contains only units currently present
        IPL                             = Status.InternalPrioList;
        Status.InternalSkipList         = {};
        ISL                             = Status.InternalSkipList;
        SortingTable                    = {};
        Status.Unit_Array_GUIDToUnit    = {};
        Status.Unit_Array_UnitToGUID    = {};
        UnitInfo                        = {};

        -- test mode was disabled
        if TestMode ~= Status.TestLayout then
            FakeGroups                  = {};
            FakeGroupsAttribution       = {};
            FakeClasses                 = {};
            FakeRoles                   = {};

            TestMode = Status.TestLayout;
        end

        Raidnum  = _GetNumRaidMembers();

        self:Debug ("|cFFFF44FF-->|r Updating Units Array, test mode:", D.Status.TestLayout, D.Status.TestLayoutUNum, Raidnum);

        UnitToGUID = setmetatable(UnitToGUID, UnitToGUID_mt); -- we could simply erase this one to prevent garbage
        GUIDToUnit = setmetatable(GUIDToUnit, GUIDToUnit_mt); -- this one cannot be erased (memory leak due to GUID...)
        GUIDToUnit_ScannedAll = false;

        -- ############### PARSE PRIO AND SKIP LIST ###############
        Lookforpets = false; -- ignore pet while checking existing names

        -- First clean and load the prioritylist (remove missing units)
        setInternalList(self.profile.PriorityList, IPL);

        -- Get a cleaned skip list
        setInternalList(self.profile.SkipList, ISL);

        Lookforpets = true;

        -- if we are not in a raid but in a party
        if Raidnum == 0 then
            CurrentGroup = 1; -- this is used to compute the default priorities
            if not IsInSkipList(myGUID, false, DC.ClassUNameToNum[DC.MyClass], _UnitGroupRolesAssigned("player")) then
                addUnit("player", 0, myGUID, 1)
            end

            -- add the party members and their pets... if they exist
            for i = 1, 4 do
                unit = "party"..i;

                if _UnitExists(unit) then

                    pGUID = UnitToGUID[unit] or unit; -- at logon sometimes GUID is nil...

                    if not IsInSkipList(pGUID, nil, DC.ClassUNameToNum[(select(2, _UnitClass(unit)))], _UnitGroupRolesAssigned(unit)) then

                        addUnit(unit, i, pGUID, 1);

                        if self.profile.Scan_Pets then

                            unit = "partypet"..i;

                            if _UnitExists(unit) then
                                addUnit(unit, i, UnitToGUID[unit] or unit, 1, true);
                            end
                        end
                    end
                end
            end
        end

        if Raidnum > 0 then -- if we are in a raid
            CurrentGroup = 0;
            local rName, rGroup, rClass, GUID;
            local caheID = 1; -- make an ordered table
            local excluded = 0;
            local playerPrio = 900;

            -- Cache the raid roster info eliminating useless info and already listed members
            for i = 1, MAX_RAID_MEMBERS do
                rName, _, rGroup, _, _, rClass = _GetRaidRosterInfo(i);
                unit = "raid"..i;
                GUID =  UnitToGUID[unit];

                -- add all except member to skip
                if not IsInSkipList(GUID, rGroup, DC.ClassUNameToNum[rClass], _UnitGroupRolesAssigned(unit)) then

                    if (rName) then -- (at log-in GetRaidRosterInfo() returns garbage)

                        if (not RaidRosterCache[caheID]) then
                            RaidRosterCache[caheID] = {};
                        end

                        RaidRosterCache[caheID].rName    = rName;
                        RaidRosterCache[caheID].rGroup   = rGroup;
                        RaidRosterCache[caheID].rClass   = rClass;
                        RaidRosterCache[caheID].rIndex   = i;
                        RaidRosterCache[caheID].rGUID    = GUID;
                        caheID = caheID + 1;
                    end
                else
                    excluded = excluded + 1;
                end

                -- find our group (a whole iteration is required, raid info are not ordered) -- wrong, the player is always the last now but never trust Blizzard...
                if CurrentGroup == 0 and GUID == myGUID then -- anyway they do the same thing in PlayerFrame.lua...
                    CurrentGroup = rGroup;
                end

                if caheID + excluded > Raidnum then -- we found all the units
                    RaidRosterCache[caheID] = false;
                    break;
                end
            end

            if TestMode and CurrentGroup == 0 then
                CurrentGroup = random(1,8); -- XXX tofix
            end

            -- Add the player to the main list if needed

            addUnit("player", 0, myGUID, CurrentGroup)

            -- Now we have a cache without the units we want to skip
            local TempID;
            for _, raidMember in ipairs(RaidRosterCache) do

                if not raidMember then break; end;

                -- put each raid member in our sorting table
                addUnit("raid"..raidMember.rIndex, raidMember.rIndex, raidMember.rGUID, raidMember.rGroup)


                if self.profile.Scan_Pets then
                    unit = "raidpet"..raidMember.rIndex;

                    if _UnitExists(unit) then

                        pGUID = UnitToGUID[unit] or unit;

                        -- add it only if not already in (could be the player pet...)
                        addUnit(unit, raidMember.rIndex, pGUID, raidMember.rGroup, true);
                    end

                end

            end

        end -- END if we are in a raid

        -- add our own pet
        if self.profile.Scan_Pets and _UnitExists("pet") then
            addUnit("pet", 0, UnitToGUID["pet"] or "pet", CurrentGroup, true)
        end

        -- There is a focus and its not hostile in the first place
        if UnitExists("focus") and (not UnitCanAttack("focus", "player") or UnitIsFriend("focus", "player")) then
            pGUID = UnitToGUID["focus"]
            -- the unit is not registered somewhere else yet
            addUnit("focus", 41, pGUID, nil);
        end

        Status.Unit_Array = SortingTable

        table.sort(Status.Unit_Array, isUnitBeforeUnit);

        Status.UnitNum = #Status.Unit_Array;

        UnitToGUID = {};
        GUIDToUnit = {};
        D.Status.GroupUpdatedOn = D:NiceTime(); -- It's used in UNIT_AURA event handler to trigger a rescan if the array is found inacurate

        self:Debug ("|cFFFF44FF-->|r Update complete!", Status.UnitNum);

        --[===[@debug@
        D:Debug("Current group:", CurrentGroup, D:tAsString(IPL));
        for i, unit in ipairs(Status.Unit_Array) do
            unit = Status.Unit_Array[i];
            D:Debug(D:ColorTextNA(unit, D:GetClassHexColor(DC.ClassNumToUName[UnitInfo[unit].class])), DC.ClassNumToUName[UnitInfo[unit].class], UnitInfo[unit].group and "g"..UnitInfo[unit].group or nil, "i"..UnitInfo[unit].RaidID, UnitInfo[unit].role);
        end
        --@end-debug@]===]
    end

end


-------------------------------------------------------------------------------
T._LoadedFiles["Dcr_Raid.lua"] = "2.7.6.4";

-- "Your God is dead and no one cares"
-- "If there is a Hell I'll see you there"
-- NIN
