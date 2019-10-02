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

if not T._LoadedFiles or not T._LoadedFiles["Dcr_opt.lua"] then
    if not DecursiveInstallCorrupted then T._FatalError("Decursive installation is corrupted! (Dcr_opt.lua not loaded)"); end;
    DecursiveInstallCorrupted = true;
    return;
end
T._LoadedFiles["Dcr_Events.lua"] = false;

local D = T.Dcr;


local L = D.L;
local LC = D.LC;
local DC = T._C;

D.DebuffUpdateRequest = 0;

--[===[@alpha@
D.DetectHistory = {};
--@end-alpha@]===]

local pairs     = _G.pairs;
local next      = _G.next;
local pairs     = _G.pairs;
local ipairs    = _G.ipairs;
local unpack    = _G.unpack;
local select    = _G.select;
local tonumber  = _G.tonumber;
local time      = _G.time;
local table             = _G.table;
local UnitCreatureFamily= _G.UnitCreatureFamily;
local UnitFactionGroup  = _G.UnitFactionGroup;
local IsInInstance      = _G.IsInInstance;
local GetNumRaidMembers = DC.GetNumRaidMembers;
local GetNumPartyMembers= _G.GetNumSubgroupMembers;
local GetGuildInfo      = _G.GetGuildInfo;
local InCombatLockdown  = _G.InCombatLockdown;
local UnitExists        = _G.UnitExists;
local UnitCanAttack     = _G.UnitCanAttack;
local UnitName          = _G.UnitName;
local UnitGUID          = _G.UnitGUID;
local GetTime           = _G.GetTime;
local IsShiftKeyDown    = _G.IsShiftKeyDown;

-- Blizzard event management
function D.OnEvent(frame, event, ...)
    if D[event] then
        D[event](D, event, ...);
    else
        D:AddDebugText('unused event:', event);
    end
end

-- GroupChanged(reason) {{{
do

    local function OnGroupeLeave ()
        -- clean gathered version info at this occasion
        D:Debug("|cFFFF0000groupe left, cleaning D.versions!|r");
        D.versions = false;
    end

    local Grouped = false;
    function D:GroupChanged (reason)

        if not D.DcrFullyInitialized then
            D:Debug("|cFFFF0000D:GroupChanged aborted, init uncomplete!|r");
            return;
        end

        -- this will trigger an update of the unit array
        self.Groups_datas_are_invalid = true;
        self.Status.GroupUpdateEvent = self:NiceTime();

        if self.profile.ShowDebuffsFrame then
            -- Update the MUFs display in a short moment
            self.MicroUnitF:Delayed_MFsDisplay_Update ();
        elseif not self.profile.HideLiveList then
            D:ScheduleDelayedCall("Dcr_GetUnitArray", self.GetUnitArray, 1.5, self);
        end

        -- Test if we have to hide Decursive MUF window
        if self.profile.AutoHideMUFs ~= 1 then
            self:ScheduleDelayedCall("Dcr_CheckIfHideShow", self.AutoHideShowMUFs, 2, self);
        end

        if reason ~= "UNIT_PET" then
            if GetNumRaidMembers() ~= 0 or GetNumPartyMembers() ~= 0 then -- TO FIX
                Grouped = true;
                D:Debug("|cFF007700Grouped!!|r", Grouped);
            else
                if Grouped then -- we are NO LONGER in a group
                    OnGroupeLeave();
                end
                Grouped = false;
            end
        end

        self:Debug("Group changed", reason);
    end

    D.PARTY_LEADER_CHANGED = D.GroupChanged;
    D.GROUP_ROSTER_UPDATE = D.GroupChanged;
end
 -- }}}

function D:PLAYER_ENTERING_WORLD()

    if not D.DcrFullyInitialized then
        D:Debug("|cFFFF0000D:PLAYER_ENTERING_WORLD aborted, init uncomplete!|r");
        return;
    end

    if time() - self.db.global.LastVersionAnnounce > 3600/2 then
        -- wait 10 seconds and announce Decursive's version
        self:ScheduleDelayedCall("AnnounceVersion", self.AnnounceVersion, 10, self);
    end
end

local OncePetRetry = false;

function D:UNIT_PET (selfevent, Unit) -- {{{

    if not D.DcrFullyInitialized then
        D:Debug("|cFFFF0000D:UNIT_PET aborted, init uncomplete!|r");
        return;
    end

    -- when a pet changes somwhere, we update the unit array.

    D:Debug("Pet changed for: ", Unit);
    if (D.profile.Scan_Pets and Unit ~= "focus" and self.Status.Unit_Array_UnitToGUID[Unit]) then
        D:GroupChanged ("UNIT_PET");
    end


    -- If the player's pet changed then we should check it for interesting spells
    if ( Unit == "player" ) then
        self:ScheduleDelayedCall("Dcr_CheckPet", self.UpdatePlayerPet, 2, self);
        OncePetRetry = false;
        D:Debug ("PLAYER pet detected! Poll in 2 seconds...");
    end
end -- }}}

local curr_petType = false;
local last_petType = false;

function D:UpdatePlayerPet () -- {{{
    curr_petType = UnitCreatureFamily("pet");
    D:Debug("|cFF0000FFCurrent Pet type is",curr_petType,"|r");

    -- if we had a pet and lost it, retry once later...
    if (last_petType and not curr_petType and not OncePetRetry) then
        OncePetRetry = true;

        D:Debug("|cFF9900FFPet lost, retry in 10 seconds|r");
        D:ScheduleDelayedCall("Dcr_ReCheckPetOnce", D.UpdatePlayerPet, 10, self);
        return;
    end

    -- if we've changed of pet
    if (last_petType ~= curr_petType) then
        if (curr_petType) then D:Debug ("|cFF0066FFPet name changed:",curr_petType,"|r"); else D:Debug ("|cFF0066FFNo more pet!|r"); end; -- debug info only

        last_petType = curr_petType;
        D:ReConfigure(); -- might no longer be required in MoP since spell changed event is more reliable
    else
        D:Debug ("|cFFAA66FFNo change in Pet Type",curr_petType,"|r");
    end
end -- }}}



local FocusPrevious_ElligStatus = false;
function D:PLAYER_FOCUS_CHANGED () -- {{{

    if not D.DcrFullyInitialized then
        D:Debug("|cFFFF0000D:PLAYER_FOCUS_CHANGED aborted, init uncomplete!|r");
        return;
    end

    -- we need to rescan if the focus is not in our group and it's nice or if we already have a focus unit registered

    local FocusCurrent_ElligStatus = (
        not self.Status.Unit_Array_GUIDToUnit[UnitGUID("focus")]    -- it's not already in the unit array
        ) and ( UnitExists("focus") and (not UnitCanAttack("focus", "player") or UnitIsFriend("focus", "player"))) -- and it is (or used to) be nice


    if not FocusCurrent_ElligStatus then FocusCurrent_ElligStatus = false; end -- avoid the difference between nil and false...

    if FocusCurrent_ElligStatus~=FocusPrevious_ElligStatus or self.Status.Unit_Array_UnitToGUID["focus"] then
        self:GroupChanged ("FOCUS changed");
        self:Debug("Groups set to invalid due to focus update", FocusPrevious_ElligStatus, FocusCurrent_ElligStatus);

        self.MicroUnitF:UpdateMUFUnit("focus", true); -- update the focus unit

        if FocusCurrent_ElligStatus~=FocusPrevious_ElligStatus then -- if the focus is no longer valid, we need to update things
            self.MicroUnitF:Delayed_MFsDisplay_Update();
        end

        FocusPrevious_ElligStatus = FocusCurrent_ElligStatus;

    end


end -- }}}

function D:OnDebugEnable ()
    self.db.global.debug = true;
end

function D:OnDebugDisable ()
    self.db.global.debug = false;
end

-- This function update Decursive states :
--   - Clear the black list
--   - Execute things we couldn't do when in combat
local LastScanAllTime = 0;
D.Status.MaxConcurentUpdateDebuff = 0;
function D:ScheduledTasks() -- {{{

    if not self.DcrFullyInitialized then
        self:Debug("|cFFFF0000D:ScheduledTasks aborted, init uncomplete!|r");
        return;
    end

    local status = self.Status;

    -- clean up the blacklist
    for unit in pairs(status.Blacklisted_Array) do
        status.Blacklisted_Array[unit] = status.Blacklisted_Array[unit] - 0.3;
        if (status.Blacklisted_Array[unit] < 0) then
            status.Blacklisted_Array[unit] = nil; -- remove it from the BL
        end
    end

    if status.Combat and not InCombatLockdown() then -- just in case...
        self:PLAYER_REGEN_ENABLED();
    end

    if (not InCombatLockdown() and status.DelayedFunctionCallsCount > 0) then
        for Id, FuncAndArgs in pairs (status.DelayedFunctionCalls) do
            self:Debug("Running post combat command", Id);
            local DidSmth = FuncAndArgs.func(unpack(FuncAndArgs.args));
            status.DelayedFunctionCalls[Id] = nil; -- remove it from the list
            status.DelayedFunctionCallsCount = status.DelayedFunctionCallsCount - 1;
            if DidSmth ~= false then
                break;
            end
        end
    end


   if IsShiftKeyDown() then
       if self.profile.CenterTextDisplay ~= "3_STACKS" then
           self.Status.CenterTextDisplay  = "3_STACKS";
       else
           self.Status.CenterTextDisplay  = '1_TLEFT';
       end
   else
       self.Status.CenterTextDisplay = self.profile.CenterTextDisplay;
   end


    if self.DebuffUpdateRequest > status.MaxConcurentUpdateDebuff then
        status.MaxConcurentUpdateDebuff = self.DebuffUpdateRequest;
    end

    self.DebuffUpdateRequest = 0;

    -- Rescan all only if the MUF are used else we don't care at all...
    --[=[
    if self.profile.ShowDebuffsFrame and GetTime() - LastScanAllTime > 1 then
        self:ScanEveryBody();
        LastScanAllTime =  GetTime();
    end
    --]=]


end --}}}

-- the combat functions and events. // {{{
-------------------------------------------------------------------------------
function D:PLAYER_REGEN_DISABLED() -- {{{
    -- this is not reliable for testing unitframe modifications authorization,
    -- this event fires after the player enters in combat, only InCombatLockdown() may be used for critical checks
    self.Status.Combat = true;
end --}}}

--function D:PLAYER_REGEN_ENABLED() --{{{
do
    local LastDebugReportNotification = 0;
    function D:PLAYER_REGEN_ENABLED() -- LeaveCombat
        --D:Debug("Leaving combat");
        self.Status.Combat = false;

        -- test for debug report
        if #T._DebugTextTable > 0 and GetTime() - LastDebugReportNotification > 300 * 3 then
            if LastDebugReportNotification == 0 then
                T._FatalError(L["DECURSIVE_DEBUG_REPORT_NOTIFY"]);
            end
            self:Println(L["DECURSIVE_DEBUG_REPORT_NOTIFY"]);
            LastDebugReportNotification = GetTime();
        end
    end
end--}}}
-- }}}

-- This let us park command we can't execute while in combat to execute them later {{{
    -- the called function must return a non false value when it does something to prevent UI lagging
function D:AddDelayedFunctionCall(CallID,functionLink, ...)


    if (not self.Status.DelayedFunctionCalls[CallID]) then
        self.Status.DelayedFunctionCalls[CallID] =  {["func"] = functionLink, ["args"] =  {...}};
        self.Status.DelayedFunctionCallsCount = self.Status.DelayedFunctionCallsCount + 1;
    elseif select("#",...) > 1 then -- if we had more than the function reference and its object

        local args = self.Status.DelayedFunctionCalls[CallID].args;

        for i=1,select("#",...), 1 do
            args[i]=select(i, ...);
        end

    end
end -- }}}



function D:UPDATE_MOUSEOVER_UNIT ()

    if not D.DcrFullyInitialized then
        D:Debug("|cFFFF0000D:UPDATE_MOUSEOVER_UNIT aborted, init uncomplete!|r");
        return;
    end

    if not self.profile.HideLiveList and not self.Status.MouseOveringMUF and not UnitCanAttack("mouseover", "player") then
        --      D:Debug("will check MouseOver");
        self.LiveList:DelayedGetDebuff("mouseover");
    end
end



function D:PLAYER_TARGET_CHANGED()


    if not D.DcrFullyInitialized then
        D:Debug("|cFFFF0000D:PLAYER_TARGET_CHANGED aborted, init uncomplete!|r");
        return;
    end

    if UnitExists("target") and not UnitCanAttack("player", "target") then

        D.Status.TargetExists = true;

        self.LiveList:DelayedGetDebuff("target");


        if self:CheckUnitStealth("target") then
            self.Stealthed_Units["target"] = true;
        end

    else
        D.Status.TargetExists = false;
        self.Stealthed_Units["target"] = false;
        if D.UnitDebuffed["target"] then
            D.ForLLDebuffedUnitsNum = D.ForLLDebuffedUnitsNum - 1;
            D.UnitDebuffed["target"] = false;
        end
    end
end

function D:PLAYER_ALIVE()
    D:Debug("|cFFFF0000PLAYER_ALIVE|r");
    self:ScheduleDelayedCall("Dcr_ReConfigure", self.ReConfigure, 4, self);
    self.eventFrame:UnregisterEvent("PLAYER_ALIVE");
    T.PLAYER_IS_ALIVE = GetTime();
end

function D:LEARNED_SPELL_IN_TAB()
    D:Debug("|cFFFF0000A new spell was learned, scheduling a reconfiguration|r");
    self:ScheduleDelayedCall("Dcr_ReConfigure", self.ReConfigure, 4, self);
end

function D:SPELLS_CHANGED()
    D:Debug("|cFFFF0000Spells were changed, scheduling a reconfiguration check|r");
    self:ScheduleDelayedCall("Dcr_ReConfigure", self.ReConfigure, 4, self); -- used to be 15s changed to 4 to be more reaactive for warlocks
end

function D:PLAYER_EQUIPMENT_CHANGED()
    D:Debug("|cFFFF0000Equipment changed, scheduling a reconfiguration check|r");
    self:ScheduleDelayedCall("Dcr_ReConfigure", self.ReConfigure, 4, self);
end

function D:BAG_UPDATE_DELAYED()
    D:Debug("|cFFFF0000Bag changed, scheduling a reconfiguration check|r");
    self:ScheduleDelayedCall("Dcr_ReConfigure", self.ReConfigure, 4, self);
end

function D:GET_ITEM_INFO_RECEIVED()
    if self.Status.WaitingForSpellInfo and GetItemInfo(self.Status.WaitingForSpellInfo) then
        self:ScheduleDelayedCall("Dcr_ReConfigure", self.ReConfigure, 4, self);
        self.Status.WaitingForSpellInfo = false;
        D:Debug("|cFFFF0000Missing itemInfo received, scheduling a reconfiguration check|r");
    end
end

function D:PLAYER_TALENT_UPDATE()
    D:Debug("|cFFFF0000Talents were changed, scheduling a reconfiguration check|r");
    self:ScheduleDelayedCall("Dcr_ReConfigure", self.ReConfigure, 4, self);
end

function D:DECURSIVE_TALENTS_AVAILABLE()
    D:Debug("|cFFFF0000Talents are available recnfiguration in 1 second|r");
    self:ScheduleDelayedCall("Dcr_ReConfigure", self.ReConfigure, 1, self);

    if time() - self.db.global.LastVersionAnnounce > 3600/2 then
        -- wait 10 seconds and announce Decursive's version
        self:ScheduleDelayedCall("AnnounceVersion", self.AnnounceVersion, 10, self);
    end

    -- some useful constants
    DC.MyClass = (select(2, UnitClass("player")));
    DC.MyName  = (self:UnitName("player"));
    DC.MyGUID  = (UnitGUID("player"));

    if not DC.MyGUID then
        DC.MyGUID = "NONE";
        D:AddDebugText("DECURSIVE_TALENTS_AVAILABLE(): (UnitGUID(\"player\")) still returned nil even after the talents were available... this is the fifth dimension");
    end

    self.Groups_datas_are_invalid = true;
    D:GetUnitArray(); -- get the unit array
end
---[=[
local SeenUnitEventsUNITAURA = {};
local SeenUnitEventsCOMBAT = {};

do
    local FAR           = DC.FAR;
    local UnitDebuff    = _G.UnitDebuff;
    local UnitGUID      = _G.UnitGUID;
    local UnitIsCharmed = _G.UnitIsCharmed;
    local time          = _G.time;
    local GetTime       = _G.GetTime;
    -- This event manager is only here to catch events when the GUID unit array is not reliable.
    -- For everything else the combat log event manager does the job since it's a lot more resource friendly. (UNIT_AURA fires way too often and provides no data)
    function D:UNIT_AURA(selfevent, UnitID, ...)


        if not D.DcrFullyInitialized then
            D:Debug("|cFFFF0000D:UNIT_AURA aborted, init uncomplete!|r");
            return;
        end

        if not self.Status.Unit_Array_UnitToGUID[UnitID] then
            -- self:Debug(UnitID, " |cFFFF7711is not in raid|r");
            return;
        end

        local unitguid = UnitGUID(UnitID);

        --[===[@debug@


        --D:Debug("UNIT_AURA", ..., UnitID, GetTime() + (GetTime() % 1));

        --@end-debug@]===]


        -- Here we test if the GUID->Unit array is ok if it isn't we need to scan the unit for debuffs
        -- We also scan the unit if it's charmed. The combatLog event manager tends to not detect those properly, the charm effect is a bitch to manage.
        if unitguid ~= self.Status.Unit_Array_UnitToGUID[UnitID] or UnitID ~= self.Status.Unit_Array_GUIDToUnit[unitguid] or UnitIsCharmed(UnitID) then

            local unitToguid = self.Status.Unit_Array_UnitToGUID[UnitID];

            -- if we updated the unit array but we are here then rebuild the unit array.
            if self.Status.GroupUpdatedOn >= self.Status.GroupUpdateEvent then

                D:GroupChanged("UNIT_AURA-|cFFFF0000bad group detection|r");

                --[=[
                self:AddDebugText("AURA event received and Unit_Array_UnitToGUID ~= UnitGUID() and groups up to date, SG:", self.Status.Unit_Array_UnitToGUID[UnitID],
                "FG:", unitguid,
                "Unit ID:|cFFFF0000", UnitID,
                "|rGUIDToUnit[UnitGUID()]:",  unitguid and self.Status.Unit_Array_GUIDToUnit[unitguid] or "Xnoguid",
                "GUIDToUnit[UnitToGUID[]]:|cFFFF0000", unitToguid and self.Status.Unit_Array_GUIDToUnit[unitToguid] or "Xnone",
                "|rScP:", self.profile.Scan_Pets,
                "LGU:", self.Status.GroupUpdatedOn,
                "LGuEr", self.Status.GroupUpdateEvent,
                "foundUnits:", #self.Status.Unit_Array,
                "RealRaidNum:", GetNumRaidMembers()
                --"Zone:", GetZoneText()
                --"FUnitsList:", unpack(D.Status.Unit_Array)
                );
                --]=]
            end

            --[===[@debug@
            self:Debug("|cFF552255UNIT_AURA triggers a rescan|r because of", UnitID);
            --@end-debug@]===]

            if unitguid then
                self.Status.Unit_Array_UnitToGUID[UnitID] = unitguid;
                self.Status.Unit_Array_GUIDToUnit[unitguid] = UnitID;
            end

            if self.profile.ShowDebuffsFrame and self.MicroUnitF.UnitToMUF[UnitID] then

                if self.MicroUnitF.UnitToMUF[UnitID].UnitStatus == FAR then
                    --self:Debug(UnitID, " |cFFFF7711is too far|r (UNIT_AURA)");
                    return
                end

                -- get out of here if this is just about a fucking buff, combat log event manager handles those... unless there is no debuff because the last was removed
                if not UnitDebuff(UnitID, 1) and not self.MicroUnitF.UnitToMUF[UnitID].IsDebuffed then
                    --self:Debug(UnitID, " |cFFFF7711has no debuff|r (UNIT_AURA)");
                    return;
                end

                --self:errln("update schedule for MUF", UnitID);
                self.MicroUnitF:UpdateMUFUnit(UnitID, true);
                return;
            end

            if not self.profile.HideLiveList then
                self.LiveList:DelayedGetDebuff(UnitID);
            end
        end
    end
end

--]=]

function D:HOOK_CastSpellByName (spellName, target)
    if self.Status.ClickCastingWIP and self.Status.ClickedMF then
        self.Status.ClickedMF.CastingSpell = spellName;
        self:Debug("HOOK_CastSpellByName:", spellName, target);
    end
end

local GetItemSpell = _G.GetItemSpell;
local GetItemCount = _G.GetItemCount;
local GetItemInfo  = _G.GetItemInfo;
function D:HOOK_UseItemByName (itemName, target)
    if self.Status.ClickCastingWIP and self.Status.ClickedMF then
        self.Status.ClickedMF.CastingSpell = GetItemSpell(itemName);

        if (select(8, GetItemInfo(itemName))) > 1 and GetItemCount(itemName, false, true) < 2 then
            self:ScheduleDelayedCall("Dcr_ReConfigure", self.ReConfigure, 4, self);
        end

        self:Debug("HOOK_UseItemByName:", itemName, target, 'left:', GetItemCount(itemName), (select(8, GetItemInfo(itemName))));
    end
end
do -- Combat log event handling {{{1
    local bit           = _G.bit;
    local band          = bit.band;
    local bor           = bit.bor;
    local UnitGUID      = _G.UnitGUID;
    local GetTime       = _G.GetTime;
    local GetSpellInfo  = _G.GetSpellInfo; -- XXX to fix for 8
    local time          = _G.time;

    --[=[ useless bitfields {{{2
    -- a friendly player character controled directly by the player that is not an outsider
    local PLAYER_MASK   = bit.bnot (COMBATLOG_OBJECT_AFFILIATION_OUTSIDER);

    -- a hostile player character contoled as a pet and that is not an outsider
    local REACTION_HOSTILE              = COMBATLOG_OBJECT_REACTION_HOSTILE;

    -- a pet controled by a friendly player that is not an outsider
    local PET       = bit.bor (COMBATLOG_OBJECT_CONTROL_PLAYER  , COMBATLOG_OBJECT_TYPE_PET     , COMBATLOG_OBJECT_REACTION_FRIENDLY  );
    local PET_MASK  = bit.bnot (COMBATLOG_OBJECT_AFFILIATION_OUTSIDER);

    -- An outsider friendly focused unit
    local FOCUSED_FRIEND       = bit.bor (COMBATLOG_OBJECT_REACTION_FRIENDLY   , COMBATLOG_OBJECT_FOCUS     , COMBATLOG_OBJECT_AFFILIATION_OUTSIDER);

    local OUTSIDER              = COMBATLOG_OBJECT_AFFILIATION_OUTSIDER;
    local HOSTILE_OUTSIDER      = bit.bor (COMBATLOG_OBJECT_AFFILIATION_OUTSIDER, COMBATLOG_OBJECT_REACTION_HOSTILE);
    -- }}} ]=]

    local SPELL_FAILED_LINE_OF_SIGHT = _G.SPELL_FAILED_LINE_OF_SIGHT;
    local SPELL_FAILED_BAD_TARGETS =   _G.SPELL_FAILED_BAD_TARGETS;

    local FRIENDLY_TARGET       = bit.bor (_G.COMBATLOG_OBJECT_TARGET, _G.COMBATLOG_OBJECT_REACTION_FRIENDLY);
    local ME                    = _G.COMBATLOG_OBJECT_AFFILIATION_MINE;


    local AuraEvents = {
        ["SPELL_AURA_APPLIED"]      = 1,
        ["SPELL_AURA_APPLIED_DOSE"] = 1,
        ["SPELL_AURA_REMOVED"]      = 0,
        ["SPELL_AURA_REMOVED_DOSE"] = 0,
        ["UNIT_DIED"] = 0, -- Special! Base parameters are not compatible
        --["SPELL_DISPEL"] = 0, -- we don't use it because it just means that someone is dispelling something, the aura is not removed yet
    };

    local SpellEvents = {
        ["SPELL_MISSED"]        = true,
        ["SPELL_CAST_START"]    = true,
        ["SPELL_CAST_FAILED"]   = true,
        ["SPELL_CAST_SUCCESS"]  = true,
        ["SPELL_DISPEL_FAILED"] = true,
    };

    local UnitID;
    local TOC = T._tocversion;

    function D:DummyDebuff (UnitID)
        local PLAYER = bit.bor (COMBATLOG_OBJECT_CONTROL_PLAYER   , COMBATLOG_OBJECT_TYPE_PLAYER  , COMBATLOG_OBJECT_REACTION_FRIENDLY  ); -- still used

        D:COMBAT_LOG_EVENT_UNFILTERED("COMBAT_LOG_EVENT_UNFILTERED", 0, "SPELL_AURA_APPLIED", false, nil, nil, COMBATLOG_OBJECT_NONE, 0, UnitGUID(UnitID), (UnitName(UnitID)), PLAYER, 0, 0, "Test item", 0x32, "DEBUFF");
    end

    local SpecialDebuffs = {
        -- exception for the 'Dark Matter' debuff for which no SPELL_AURA_APPLIED event is generated by the game.
        [59868] = "SPELL_DAMAGE", -- Dark Matter ( http://www.wowhead.com/spell=59868 )
    };


    function D:COMBAT_LOG_EVENT_UNFILTERED(selfevent, timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellNAME, _spellSCHOOL, auraTYPE_failTYPE)

        if event == nil then
            timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellNAME, _spellSCHOOL, auraTYPE_failTYPE = CombatLogGetCurrentEventInfo()
        end
        -- check for exceptions
        if SpecialDebuffs[spellID] and event == SpecialDebuffs[spellID] then
            event = "SPELL_AURA_APPLIED";
        end

        if destName and AuraEvents[event] then -- {{{2

            if not self.DcrFullyInitialized then
                self:Debug("|cFFFF0000Could not process event: init uncomplete!|r");
                return;
            end

            UnitID = self.Status.Unit_Array_GUIDToUnit[destGUID]; -- get the grouped unit associated to the destGUID if there is none then the unit is not in our group or is filtered out

            --D:Print("? (source=%s) (dest=|cFF00AA00%s|r -- %X): |cffff0000%s|r", sourceName, destName, destFlags, event);

            if UnitID then -- (this test is enough, if the unit is grouped we definetely need to scan it, whatever is its status...) {{{3

                if auraTYPE_failTYPE == "BUFF" and self.profile.Show_Stealthed_Status then

                    if DC.IS_STEALTH_BUFF[spellNAME] then
                        if AuraEvents[event] == 1 then
                            self.Stealthed_Units[UnitID] = true;
                        else
                            if self.debug then self:Debug("STEALTH LOST: ", UnitID, spellNAME); end
                            self.Stealthed_Units[UnitID] = false;
                        end
                        self.MicroUnitF:UpdateMUFUnit(UnitID);
                    end
                else

                    --[===[@debug@
                    if self.debug then self:Debug("Debuff, UnitId: ", UnitID, spellNAME, event, time() + (GetTime() % 1), timestamp, "destName:", destName, destFlags, band (destFlags, FRIENDLY_TARGET) == FRIENDLY_TARGET); end
                    --@end-debug@]===]

                    if self.profile.ShowDebuffsFrame then
                        self.MicroUnitF:UpdateMUFUnit(UnitID);

                    elseif not self.profile.HideLiveList then
                        if self.debug then self:Debug("(LiveList) Registering delayed GetDebuff for ", destName); end
                        self.LiveList:DelayedGetDebuff(UnitID);
                    end

                    if event == "UNIT_DIED" then
                        self.Stealthed_Units[UnitID] = false;
                    end

                end
            end -- }}}

            if self.Status.TargetExists and band (destFlags, FRIENDLY_TARGET) == FRIENDLY_TARGET then -- {{{3 -- warning: this test is not triggered by the dumy debuff

                if self.debug then self:Debug("A Target got something (source=", sourceName, "sFlags:", self:NumToHexStr(sourceFlags), "(dest=|cFF00AA00", destName, "dFlags:", self:NumToHexStr(destFlags), "|r, |cffff0000", event, "|r, |cFF00AAAA", spellNAME, "|r", auraTYPE_failTYPE); end

                self.LiveList:DelayedGetDebuff("target");

                if auraTYPE_failTYPE == "BUFF" and self.profile.Show_Stealthed_Status then
                    if DC.IS_STEALTH_BUFF[spellNAME] then
                        if AuraEvents[event] == 1 then
                            self.Stealthed_Units["target"] = true;
                        else
                            if self.debug then self:Debug("TARGET STEALTH LOST: ", "target", spellNAME); end
                            self.Stealthed_Units["target"] = false;
                        end
                    end
                end
            end

            -- SPELL EVENTS {{{2
        elseif self.Status.ClickedMF and SpellEvents[event] and (self.Status.ClickCastingWIP or self.Status.ClickedMF.CastingSpell == spellNAME) and band(sourceFlags, ME) ~= 0 then -- SPELL_MISSED  SPELL_CAST_START  SPELL_CAST_FAILED  SPELL_CAST_SUCCESS  SPELL_DISPEL_FAILED

            if self.Status.ClickCastingWIP then
                self.Status.ClickedMF.CastingSpell = spellNAME;
                self:Debug("clickcastWIP caught: ", spellNAME);
            end


            if event == "SPELL_CAST_SUCCESS" then

                if self.debug then self:Debug(L["SUCCESSCAST"], spellNAME, (select(2, GetSpellInfo(spellID))) or "[WoW8.0-unknown]", self:MakePlayerName(destName)); end

                --self:Debug("|cFFFF0000XXXXX|r |cFF11FF11Updating color of clicked frame|r");
                self:ScheduleDelayedCall("Dcr_UpdatePC"..self.Status.ClickedMF.CurrUnit, self.Status.ClickedMF.Update, 1, self.Status.ClickedMF);
                self:ScheduleDelayedCall("Dcr_clickedMFreset",
                function()
                    if D.Status.ClickedMF then
                        D.Status.ClickedMF.SPELL_CAST_SUCCESS = false;
                        D.Status.ClickedMF = false;
                        if self.debug then D:Debug("ClickedMF to false (sched)"); end
                    end
                end, 0.1 ); -- XXX why wait 0.1s ??????? (probably for SPELL_DISPEL_FAILED and MISSED events)

                self.Status.ClickedMF.SPELL_CAST_SUCCESS = true;

            end

            if event == "SPELL_CAST_FAILED" and not self.Status.ClickedMF.SPELL_CAST_SUCCESS then
                destName = self:PetUnitName( self.Status.ClickedMF.CurrUnit, true);

                self:Println(L["FAILEDCAST"], spellNAME, (select(2, GetSpellInfo(spellID))) or "[WoW8.0-unknown]", self:MakePlayerName(destName), auraTYPE_failTYPE);

                if (auraTYPE_failTYPE == SPELL_FAILED_LINE_OF_SIGHT or auraTYPE_failTYPE == SPELL_FAILED_BAD_TARGETS) then

                    if not self.profile.DoNot_Blacklist_Prio_List or not self:IsInPriorList(self.Status.Unit_Array_UnitToGUID[self.Status.ClickedMF.CurrUnit]) then
                        self.Status.Blacklisted_Array[self.Status.ClickedMF.CurrUnit] = self.profile.CureBlacklist;

                        self:Debug("|cFFFF0000XXXXX|r |cFF11FF11Updating color of blacklist frame|r");
                        self:ScheduleDelayedCall("Dcr_Update"..self.Status.ClickedMF.CurrUnit, self.Status.ClickedMF.UpdateSkippingSetBuf, self.profile.DebuffsFrameRefreshRate, self.Status.ClickedMF);
                    end

                    self:SafePlaySoundFile(DC.FailedSound);
                    --[=[
                    elseif auraTYPE_failTYPE == SPELL_FAILED_BAD_IMPLICIT_TARGETS then
                    self:AddDebugText("ERR_GENERIC_NO_TARGET", "Unit:", self.Status.ClickedMF.CurrUnit, "UE:", UnitExists(self.Status.ClickedMF.CurrUnit), "UiF:",  UnitIsFriend("player",self.Status.ClickedMF.CurrUnit), "CBEs:", timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellID, spellNAME, _spellSCHOOL, auraTYPE_failTYPE); --]=]
                end
                self.Status.ClickedMF = false;

            elseif event == "SPELL_MISSED" or event == "SPELL_DISPEL_FAILED" then
                destName = self:PetUnitName( self.Status.ClickedMF.CurrUnit, true);

                self:Println(L["FAILEDCAST"], spellNAME, (select(2, GetSpellInfo(spellID))) or "[WoW8.0-unknown]", self:MakePlayerName(destName), auraTYPE_failTYPE);
                self:SafePlaySoundFile(DC.FailedSound);
                self.Status.ClickedMF = false;
                --[===[@alpha@
                -- self:AddDebugText("sanitycheck ", event, spellNAME); -- It works!
                --@end-alpha@]===]
            end
            --  }}}
            --[===[@debug@
        elseif self.debug and event then

            --self:Debug("event:", event, "self.Status.ClickedMF.CastingSpell", self.Status.ClickedMF and self.Status.ClickedMF.CastingSpell, "band(sourceFlags, ME) ~= 0", band(sourceFlags, ME) ~= 0, "self.Status.ClickCastingWIP", self.Status.ClickCastingWIP);


            --@end-debug@]===]

        end

    end
end -- }}}

function D:SPELL_UPDATE_COOLDOWN() -- {{{1
    D.Status.UpdateCooldown = GetTime();
end --}}}

do -- Communication event handling and broadcasting {{{1
    local alpha = false;
    --[===[@alpha@
    alpha = true;
    --@end-alpha@]===]


    local function GetDistributionChanel()

        -- if we are in a battle ground or a LFG/R instance
        if GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE) > 0 then
            return "INSTANCE_CHAT";
        end

        if IsInRaid() then
            return "RAID";
        elseif GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) > 0 then
            return "PARTY";
        elseif GetGuildInfo("player") then
            return "GUILD";
        end

        return false;
    end

    T.LastVCheck = 0;
    function D:AskVersion()

        if InCombatLockdown() then
            -- if we are fighting, postpone the call
            D:AddDelayedFunctionCall ("AskVersion", self.AskVersion);
            return false;
        end

        if GetTime() - T.LastVCheck < 60 then
            D:Debug("AskVersion(): Too early!");
            return false;
        end

        T.LastVCheck = GetTime();

        if UnitExists("target") and (UnitFactionGroup("target")) == (UnitFactionGroup("player")) and UnitIsPlayer("target") then -- the unit exists and is a player of our faction
            LibStub("AceComm-3.0"):SendCommMessage( "DecursiveVersion", "giveversion", "WHISPER", self:UnitName("target"));
            D:Debug("Asking version to ", self:UnitName("target"));
        end

        local Distribution = GetDistributionChanel();

        if Distribution then
            LibStub("AceComm-3.0"):SendCommMessage( "DecursiveVersion", "giveversion", Distribution);
        end
        D:Debug("Asking version on ", Distribution);

        return true;

    end

    T.VersionAnnounceReceived = 0;
    function D:OnCommReceived(message, distribution, from)


        --[===[@alpha@
        D:Debug("OnCommReceived:", message, distribution, from);
        --@end-alpha@]===]

        local gettime = GetTime();

        if message == "giveversion" then

            D:AnnounceVersion(distribution, from);
            T.LastVCheck = gettime; -- Enable version info gathering for 60 seconds (just like if the user clicked the button himself)

        elseif message:sub(1, 8) == "Version:" then

            local versionName, versionTimeStamp, versionIsAlpha, versionEnabled = message:match ("^Version: ([^,]+),(%d+),(%d),(%d)");

            versionTimeStamp    = tonumber(versionTimeStamp);
            versionIsAlpha      = tonumber(versionIsAlpha);
            versionEnabled      = tonumber(versionEnabled);

            --[===[@alpha@
            if self.debug then D:Debug("Version info received from, ", from, "by", distribution, "version:", versionName, "date:", versionTimeStamp, "islpha:", versionIsAlpha, "enabled:", versionEnabled); end
            --@end-alpha@]===]

            if versionName then
                if not D.versions then
                    D.versions = {}
                end

                -- only populate the table if it was requested (through the 'check add-on version' button in the about panel)
                if gettime - T.LastVCheck < 60 then
                    D.versions[from] = { versionName, versionTimeStamp, versionIsAlpha, versionEnabled, distribution };
                end

                if from ~= DC.MyName then
                    T.VersionAnnounceReceived = T.VersionAnnounceReceived + 1;
                else
                    D:Debug("Version from self, VersionAnnounceReceived counter not incresead", T.VersionAnnounceReceived);
                end

                if versionTimeStamp > D.db.global.NewerVersionDetected and versionTimeStamp < time() and versionName ~= D.version then
                    if versionIsAlpha==0 or D.RunningADevVersion then -- if the version received is not an alpha or if we are running one
                        D.db.global.NewerVersionDetected = versionTimeStamp;
                        D.db.global.NewerVersionName = versionName;
                    end
                elseif versionTimeStamp >= time() then
                    D:Debug("|cFFFF0000TIME TRAVELER DETECTED!|r");
                end

                -- delayed call to LibStub("AceConfigRegistry-3.0"):NotifyChange(D.name); plus "spam" prevention system (after receiving version info from someone)
                -- We don't want to update the thing if the option panel is closed so we update up to 60s after the check version button was used
                if not D:DelayedCallExixts ("NewversionDatareceived") and gettime - T.LastVCheck < 60 then
                    D:ScheduleDelayedCall("NewversionDatareceived", LibStub("AceConfigRegistry-3.0").NotifyChange, 1, LibStub("AceConfigRegistry-3.0"), D.name);
                    T.LastVCheck = gettime;
                end
            else
                D:Debug("Malformed version string received: ", message);
            end
        else
            D:Debug("Unhandled comm received (spam?)");
        end
    end

    local LastVersionAnnouceByFrom = {};
    local LastVersionAnnouceByDist = {};
    function D:AnnounceVersion(distribution, from)

        if not distribution then
            distribution = GetDistributionChanel();
        end

        if not distribution then
            return false;
        end

        local gettime = GetTime();

        -- announce version but no more than once every 60 seconds to the same player and every 10 seconds to the same chanel
        --      This avoids a player who would be crafting its own version query messages and sending them repeatidly from causing any problem
        --      This avoids race conditions where several players would send a version query at the same time on the same chanel
        if  (not LastVersionAnnouceByDist[distribution] or gettime - LastVersionAnnouceByDist[distribution] > 10 )
            and (not LastVersionAnnouceByFrom[from]     or gettime - LastVersionAnnouceByFrom[from] > 60         ) then

            LibStub("AceComm-3.0"):SendCommMessage("DecursiveVersion", ("Version: %s,%u,%d,%d"):format(D.version, D.VersionTimeStamp, D.RunningADevVersion and 1 or 0, D:IsEnabled() and 1 or 0 ), distribution, from )

            -- /run LibStub("AceComm-3.0"):SendCommMessage("DecursiveVersion", ("Version: %s,%u,%d,%d"):format("Super-test2", time(), 1, 1), "WHISPER", 'torni' )

            if from then
                LastVersionAnnouceByFrom[from]      = gettime;
            else
                self.db.global.LastVersionAnnounce = time(); -- it's not an answer
            end
            LastVersionAnnouceByDist[distribution]  = gettime;

            --[===[@alpha@
            if self.debug then D:Debug("Version info sent to, ", from, "by", distribution, ("Version: %s,%u,%d,%d"):format(D.version, D.VersionTimeStamp, alpha and 1 or 0, D:IsEnabled() and 1 or 0 )); end
            --@end-alpha@]===]

        end
    end
end -- }}}


do

    -- local Name_To_Unit (Auto-Cached table) {{{
    -- Warning this part is not very optimized, fortunately it's just sugar, I'm probably the only one using it :p

    local MAX_RAID_MEMBERS = _G.MAX_RAID_MEMBERS;
    local GetNumRaidMembers = GetNumRaidMembers;
    local GetNumPartyMembers = GetNumPartyMembers;
    local GetRaidRosterInfo = _G.GetRaidRosterInfo;

    local Name_To_Unit = {};

    local Name_To_Unit_mt = {__index =
    function (self, name )

        if not name then return false end

        local numRaidMembers = GetNumRaidMembers();
        local foundUnit = false;

        if numRaidMembers == 0 then
            if name == D:UnitName("player") then
                foundUnit =  "player";
                --elseif name == (D:UnitName("pet") then
                --    foundUnit =  "pet";
            elseif name == D:UnitName("target") then
                foundUnit =  "target";
            elseif GetNumPartyMembers() > 0 then
                if name == D:UnitName("party1") then
                    foundUnit =  "party1";
                elseif name == D:UnitName("party2") then
                    foundUnit =  "party2";
                elseif name == D:UnitName("party3") then
                    foundUnit =  "party3";
                elseif name == D:UnitName("party4") then
                    foundUnit =  "party4";
                elseif name == D:UnitName("partypet1") then
                    foundUnit =  "partypet1";
                elseif name == D:UnitName("partypet2") then
                    foundUnit =  "partypet2";
                elseif name == D:UnitName("partypet3") then
                    foundUnit =  "partypet3";
                elseif name == D:UnitName("partypet4") then
                    foundUnit =  "partypet4";
                end
            end
        else
            -- we are in a raid
            local i;
            local foundmembers = 0;
            local raidName;
            for i=1, MAX_RAID_MEMBERS do
                raidName = (GetRaidRosterInfo(i));

                if raidName then

                    foundmembers = foundmembers + 1;

                    if name == raidName then
                        foundUnit =  "raid"..i;
                        break;
                    end
                    --[[
                    if  D.profile.Scan_Pets and name == D:UnitName("raidpet"..i) then
                    foundUnit =  "raidpet"..i;
                    break;
                    end
                    --]]

                    if foundmembers == numRaidMembers then
                        break;
                    end

                end
            end
        end

        self[name] = foundUnit;

        return self[name];

    end
};
Name_To_Unit = setmetatable(Name_To_Unit, Name_To_Unit_mt);
--}}}

local UnitClass = _G.UnitClass;
local select = _G.select;
local date = _G.date;
function D:ReturnVersions()
    if not D.versions then
        return "no data available";
    end

    table.wipe(Name_To_Unit);

    local formatedversions = {};
    for name, versiondetails in pairs(D.versions) do
        if Name_To_Unit[name] and UnitExists(Name_To_Unit[name]) then
            name = D:ColorText(name, "FF"..DC.HexClassColor[select(2, UnitClass(Name_To_Unit[name]))]);
        else
            D:Debug("ReturnVersions() no unit for ", name);
        end
        formatedversions[#formatedversions + 1] = ("|cFFAAAAAA%s|r: %s %s (%s) %s %s"):format(
        name, -- Class-Colored name
        versiondetails[1], -- version name
        versiondetails[4]==0 and D:ColorText("disabled", "FFFF0000") or "", -- Enable/Disabled
        D:ColorText(date("%Y-%m-%d", versiondetails[2]), versiondetails[2] > D.VersionTimeStamp and "FF00FF00" or "FF00AAAA" ), -- date version
        versiondetails[3]==1 and "|cFFFFAA55"..L["UNSTABLERELEASE"].."|r" or "", -- is alpha?
        "|cAA555555" .. versiondetails[5] .. "|r"
        );
    end

    return table.concat(formatedversions, "\n");
end
end

do

    local UnitLevel          = _G.UnitLevel;
    local GetNumTalentPoints = _G.GetNumTalentPoints;

    local GetTalentInfo      = _G.GetTalentInfo;

    local function CheckTalentsAvaibility() -- {{{


        if not (UnitGUID("player")) then
            return false;
        end

        local playerLevel = UnitLevel("player");

        -- no talents before level 10
        if playerLevel > 0 and playerLevel < 10 then
            return true;
        end

        -- if we know that there are unspet talents, it means we can check for
        -- them
        if _G.GetNumUnspentTalents and GetNumUnspentTalents() then
            return true;
        end

        if (DC.WOWC) then
            -- local name, iconTexture, tier, column, rank, maxRank, isExceptional, available = GetTalentInfo
            -- On loading the 8th value (available) is nil
            for talent=1, (GetNumTalentTabs and GetNumTalentTabs() or 3) do
                if (select(8, GetTalentInfo(talent, 1))) then
                    return true;
                end
            end
        end

        -- then, if none of the above succeeded, talents aren't ready to be
        -- polled.
        return false;

    end -- }}}

    --[===[@alpha@
    local player_is_almost_alive = false; -- I'm trying to figure out why sometimes talents are not detected while PLAYER_ALIVE event fired
    --@end-alpha@]===]

    local function PollTalentsAvaibility() -- {{{

        D:Debug("Polling talents...");

        if CheckTalentsAvaibility() then

            D:Debug("Talents found");
            -- remove the timer
            D:CancelDelayedCall("PollTalents");
            -- dispatch event
            D:SendMessage("DECURSIVE_TALENTS_AVAILABLE");

            --[===[@alpha@
            if player_is_almost_alive then
                D:AddDebugText("StartTalentAvaibilityPolling(): Talents were not available after PLAYER_ALIVE was fired, test was made", player_is_almost_alive, "seconds after PLAYER_ALIVE fired. Sucess happened", GetTime() - T.PLAYER_IS_ALIVE, "secondes after PLAYER_ALIVE fired");
            end
        else
            if T.PLAYER_IS_ALIVE and not player_is_almost_alive then
                player_is_almost_alive = GetTime() - T.PLAYER_IS_ALIVE;
            end
            --@end-alpha@]===]
        end
    end -- }}}


    function D:StartTalentAvaibilityPolling()
        -- poll talents every 2 seconds
        if D:TimerExixts("PollTalents") then
            return;
        end

        self:ScheduleRepeatedCall("PollTalents", PollTalentsAvaibility, 2);
    end
end

T._LoadedFiles["Dcr_Events.lua"] = "2.7.6.4";

-- The Great Below
