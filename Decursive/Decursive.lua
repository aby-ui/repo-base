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
if not T._LoadedFiles or not T._LoadedFiles["Dcr_Raid.lua"] then
    if not DecursiveInstallCorrupted then T._FatalError("Decursive installation is corrupted! (Dcr_Raid.lua not loaded)"); end;
    DecursiveInstallCorrupted = true;
    return;
end
T._LoadedFiles["Decursive.lua"] = false;

local D = T.Dcr;

local L = D.L;
local LC = D.LC;
local DC = T._C;
-------------------------------------------------------------------------------

local _G                = _G;
local pairs             = _G.pairs;
local ipairs            = _G.ipairs;
local type              = _G.type;
local table             = _G.table;
local t_sort            = _G.table.sort;
local t_wipe            = _G.table.wipe;
local UnitName          = _G.UnitName;
local UnitDebuff        = _G.UnitDebuff;
local UnitBuff          = _G.UnitBuff;
local UnitIsCharmed     = _G.UnitIsCharmed;
local UnitCanAttack     = _G.UnitCanAttack;
local UnitClass         = _G.UnitClass;
local UnitExists        = _G.UnitExists;
local GetNetStats       = _G.GetNetStats;
local _;

-------------------------------------------------------------------------------
-- The UI functions {{{
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- The printing functions {{{
-------------------------------------------------------------------------------

function D:Show_Cure_Order() --{{{
    self:Println("printing cure order:");
    for index, unit in ipairs(self.Status.Unit_Array) do
        self:Println( unit, " - ", self:MakePlayerName((self:UnitName(unit))) , " Index: ", index);
    end
end --}}}

-- }}}
-------------------------------------------------------------------------------

-- Show Hide FUNCTIONS -- {{{

function D:ShowHideLiveList(hide) --{{{

    if not D.DcrFullyInitialized then
        return;
    end

    -- if hide is requested or if hide is not set and the live-list is shown
    if (hide==1 or (not hide and DcrLiveList:IsVisible())) then
        D.profile.HideLiveList = true;
        DcrLiveList:Hide();
        D:CancelDelayedCall("Dcr_LLupdate");
    else
        D.profile.HideLiveList = false;
        DcrLiveList:ClearAllPoints();
        DcrLiveList:SetPoint("TOPLEFT", "DecursiveMainBar", "BOTTOMLEFT");
        DcrLiveList:Show();

        D:ScheduleRepeatedCall("Dcr_LLupdate", D.LiveList.Update_Display, D.profile.ScanTime, D.LiveList);
    end

end --}}}

-- This functions hides or shows the "Decursive" bar depending on its current
-- state, it's also able hide/show the live-list if the "tie live-list" option is active
function D:HideBar(hide) --{{{

    if not D.DcrFullyInitialized then
        return;
    end

    if (hide==1 or (not hide and DecursiveMainBar:IsVisible())) then
        if (D.profile.LiveListTied) then
            D:ShowHideLiveList(1);
        end
        D.profile.BarHidden = true;
        DecursiveMainBar:Hide();
    else
        if (D.profile.LiveListTied) then
            D:ShowHideLiveList(0);
        end
        D.profile.BarHidden = false;
        DecursiveMainBar:Show();
    end

    if DecursiveMainBar:IsVisible() and DcrLiveList:IsVisible() then
        DcrLiveList:ClearAllPoints();
        DcrLiveList:SetPoint("TOPLEFT", "DecursiveMainBar", "BOTTOMLEFT");
    else
        D:ColorPrint(0.3, 0.5, 1, L["SHOW_MSG"]);
    end

    LibStub("AceConfigRegistry-3.0"):NotifyChange(D.name);
end --}}}

function D:ShowHidePriorityListUI() --{{{

    if not D.DcrFullyInitialized then
        return;
    end

    if (DecursivePriorityListFrame:IsVisible()) then
        DecursivePriorityListFrame:Hide();
    else
        DecursivePriorityListFrame:Show();
    end
end --}}}

function D:ShowHideSkipListUI() --{{{

    if not D.DcrFullyInitialized then
        return;
    end

    if (DecursiveSkipListFrame:IsVisible()) then
        DecursiveSkipListFrame:Hide();
    else
        DecursiveSkipListFrame:Show();
    end
end --}}}

-- This shows/hides the buttons near the "Decursive" bar
function D:ShowHideButtons(UseCurrentValue) --{{{

    if not D.DcrFullyInitialized then
        return;
    end

    if not D.profile then
        return;
    end


    local DcrFrame = "DecursiveMainBar";
    local buttons = {
        DcrFrame .. "Priority",
        DcrFrame .. "Skip",
        DcrFrame .. "Hide",
    }

    local DCRframeObject = _G[DcrFrame];

    if (not UseCurrentValue) then
        D.profile.HideButtons = (not D.profile.HideButtons);
    end

    for _, ButtonName in pairs(buttons) do
        local Button = _G[ButtonName];

        if (D.profile.HideButtons) then
            Button:Hide();
            DCRframeObject.isLocked = 1;
        else
            Button:Show();
            DCRframeObject.isLocked = 0;
        end

    end

end --}}}

-- }}}


-- this resets the location of the windows
function D:ResetWindow() --{{{

    DecursiveMainBar:ClearAllPoints();
    DecursiveMainBar:SetPoint("CENTER", UIParent);
    DecursiveMainBar:Show();

    DcrLiveList:ClearAllPoints();
    DcrLiveList:SetPoint("TOPLEFT", DecursiveMainBar, "BOTTOMLEFT");
    DcrLiveList:Show();

    DecursivePriorityListFrame:ClearAllPoints();
    DecursivePriorityListFrame:SetPoint("CENTER", UIParent);

    DecursiveSkipListFrame:ClearAllPoints();
    DecursiveSkipListFrame:SetPoint("CENTER", UIParent);

    DecursivePopulateListFrame:ClearAllPoints();
    DecursivePopulateListFrame:SetPoint("CENTER", UIParent);

    D.MFContainer:ClearAllPoints();
    D.MFContainer:SetPoint("CENTER", UIParent, "CENTER", 0, 0);

    DecursiveAnchor:ClearAllPoints();
    DecursiveAnchor:SetPoint("TOP", UIErrorsFrame, "BOTTOM", 0, 0);

end --}}}


function D:PlaySound (UnitID, Caller) --{{{
    if self.profile.PlaySound and not self.Status.SoundPlayed then
        local Debuffs, IsCharmed = self:UnitCurableDebuffs(UnitID, true);
        if Debuffs[1] or IsCharmed then

            -- since WoW 8.2, one has to use ids found at https://wow.tools/files/
            self:SafePlaySoundFile(self.profile.SoundFile);

            self.Status.SoundPlayed = true;

            if self.debug then
                self:Debug("Sound scheduled by", Caller);
            end

        end
    end
end --}}}

-- LIVE-LIST DISPLAY functions {{{



-- Those set the scalling of the LIVELIST container
-- SACALING FUNCTIONS {{{
-- Place the LIVELIST container according to its scale
function D:PlaceLL () -- {{{
    local UIScale       = UIParent:GetEffectiveScale()
    local FrameScale    = DecursiveMainBar:GetEffectiveScale();
    local x, y = D.profile.MainBarX, D.profile.MainBarY;

    -- check if the coordinates are correct
    if x and y and (x + 10 > UIParent:GetWidth() * UIScale or x < 0 or (-1 * y + 10) > UIParent:GetHeight() * UIScale or y > 0) then
        x = false; -- reset to default position
        T._FatalError("Decursive's bar position reset to default");
    end

    -- Executed for the very first time, then put it in the top right corner of the screen
    if (not x or not y) then
        x =    (UIParent:GetWidth()  * UIScale) / 2;
        y =  - (UIParent:GetHeight() * UIScale) / 8;

        D.profile.MainBarX = x;
        D.profile.MainBarY = y;
    end

    -- set to the scaled position
    DecursiveMainBar:ClearAllPoints();
    DecursiveMainBar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x/FrameScale , y/FrameScale);
    DcrLiveList:ClearAllPoints();
    DcrLiveList:SetPoint("TOPLEFT", DecursiveMainBar, "BOTTOMLEFT");
end -- }}}

-- Save the position of the frame without its scale
function D:SaveLLPos () -- {{{
    if self.profile and DecursiveMainBar:IsVisible() then
        -- We save the unscalled position (no problem if the sacale is changed behind our back)
        self.profile.MainBarX = DecursiveMainBar:GetEffectiveScale() * DecursiveMainBar:GetLeft();
        self.profile.MainBarY = DecursiveMainBar:GetEffectiveScale() * DecursiveMainBar:GetTop() - UIParent:GetHeight() * UIParent:GetEffectiveScale();


        if self.profile.MainBarX < 0 then
            self.profile.MainBarX = 0;
        end

        if self.profile.MainBarY > 0 then
            self.profile.MainBarY = 0;
        end

    end
end -- }}}

-- set the scaling of the LIVELIST container according to the user settings
function D:SetLLScale (NewScale) -- {{{

    -- save the current position without any scaling
    D:SaveLLPos ();
    -- Set the new scale
    DecursiveMainBar:SetScale(NewScale);
    DcrLiveList:SetScale(NewScale);
    -- Place the frame adapting its position to the news cale
    D:PlaceLL ();

end -- }}}
-- }}}


-- }}}

-- // }}}
-------------------------------------------------------------------------------

do
   local iterator = 1;
   local DebuffHistHashTable = {};

   function D:Debuff_History_Add( DebuffName, DebuffType )

       if not DebuffHistHashTable[DebuffName] then

           -- reset iterator if out of boundaries
           if iterator > DC.DebuffHistoryLength then
               iterator = 1;
           end

           -- clean hastable if necessary before adding a new entry
           if DebuffHistHashTable[D.DebuffHistory[iterator]] then
               DebuffHistHashTable[D.DebuffHistory[iterator]] = nil;
           end

           -- Register the name in the HashTable using the debuff type
           DebuffHistHashTable[DebuffName] = (DebuffType and DC.NameToTypes[DebuffType] or DC.NOTYPE);
           --D:Debug(DebuffName, DebuffHistHashTable[DebuffName]);

           -- Put this debuff in our history
           D.DebuffHistory[iterator] = DebuffName;

           -- This is a useless comment
           iterator = iterator + 1;
       end

   end

   function D:Debuff_History_Get (Index, Colored)

       local HumanIndex = iterator - Index;

       if HumanIndex < 1 then
           HumanIndex = HumanIndex + DC.DebuffHistoryLength;
       end

       if not D.DebuffHistory[HumanIndex] then
           return "|cFF777777Empty|r", false;
       end

       if Colored then
           --D:Debug(D.DebuffHistory[HumanIndex], DebuffHistHashTable[D.DebuffHistory[HumanIndex]]);
           return D:ColorText(D.DebuffHistory[HumanIndex], "FF" .. DC.TypeColors[DebuffHistHashTable[D.DebuffHistory[HumanIndex]]]), true;
       else
           return D.DebuffHistory[HumanIndex], true;
       end
   end

end

-- Scanning functionalities {{{
-------------------------------------------------------------------------------

do

    local D                 = D;

    local UnitDebuff        = _G.UnitDebuff;
    local UnitIsCharmed     = _G.UnitIsCharmed;
    local UnitCanAttack     = _G.UnitCanAttack;
    local GetTime           = _G.GetTime;

    local UnTrustedUnitIDs = {
        ['mouseover'] = true,
        ['target'] = true,
    };

    -- This local function only sets interesting values of UnitDebuff()
    local Name, Texture, Applications, TypeName, Duration, ExpirationTime, _, SpellID;
    local function GetUnitDebuff  (Unit, i) --{{{

        if D.LiveList.TestItemDisplayed and UnitExists(Unit) then -- and not UnTrustedUnitIDs[Unit] then
            if i == 1 then
                Name, Texture, Applications, TypeName, Duration, ExpirationTime, SpellID = "Test item", "Interface\\AddOns\\Decursive\\iconON.tga", 2, DC.TypeNames[D.Status.ReversedCureOrder[1]], 70, (D.LiveList.TestItemDisplayed + 70), 0;
                -- D:Debug("|cFFFF0000Setting test debuff for ", Unit, " (debuff ", i, ")|r");--, Name, Texture, Applications, TypeName, Duration, ExpirationTime);
                return true;
            else
                i = i - 1;
            end
        end

        Name, Texture, Applications, TypeName, Duration, ExpirationTime, _, _, _, SpellID = UnitDebuff (Unit, i);

        if Name then
            return true;
        else
            return false;
        end
    end --}}}

    -- there is a known maximum number of unit and a known maximum debuffs per unit so lets allocate the memory needed only once. Memory will be allocated when needed and re-used...
    local DebuffUnitCache = {};

    -- Variables are declared outside so that Lua doesn't initialize them at each call
    local Type, i, StoredDebuffIndex, CharmFound, IsCharmed;

    local DcrC = T._C; -- for faster access




    -- This is the core debuff scanning function of Decursive
    -- This function does more than just reporting Debuffs. it also detects charmed units

    function D:GetUnitDebuffAll (Unit) --{{{

        -- create a Debuff table for this unit if there is not already one
        if not DebuffUnitCache[Unit] then
            DebuffUnitCache[Unit] = {};
        end

        -- This is just a shortcut for easier readability
        local ThisUnitDebuffs = DebuffUnitCache[Unit];

        i = 1;                  -- => to index all debuffs
        StoredDebuffIndex = 1;  -- => this index only debuffs with a type
        CharmFound = false;     -- => avoid to find that the unit is charmed again and again...


        -- test if the unit is mind controlled once
        -- The unit is not mouseover or target and it's attackable ---> it's charmed! (A new game's mechanic as been introduced where a player can become hostile but remain in controll...)
        if not UnTrustedUnitIDs[Unit] and UnitCanAttack("player", Unit) then
            IsCharmed = true;
        else
            IsCharmed = false;
        end

        if self.LiveList.TestItemDisplayed and not UnTrustedUnitIDs[Unit] and (D.Status.ReversedCureOrder[1] == DC.CHARMED or D.Status.ReversedCureOrder[1] == DC.ENEMYMAGIC) then
            IsCharmed = true;
        end

        -- iterate all available debuffs
        while true do
            if not GetUnitDebuff(Unit, i) then
                if not IsCharmed or CharmFound then
                    break;
                else
                    Name = "*Charm effect*";
                    Texture = "Interface\\AddOns\\Decursive\\iconON.tga";
                    ExpirationTime = false;
                    Duration = false;
                    Applications = 0;
                    --D:AddDebugText("Charm effect without debuff", i);
                end
            end


            -- test for a type (Magic Curse Disease or Poison)
            if TypeName and TypeName ~= "" then
                Type = DC.NameToTypes[TypeName];
            else
                Type = false;
            end

            -- if the unit is charmed and we didn't took care of this information yet
            if IsCharmed and (not CharmFound or Type == DC.MAGIC) then
                -- If the unit has a magical debuff and we can cure it
                -- (note that the target is not friendly in that case)
                if (Type == DC.MAGIC and self.Status.CuringSpells[DC.ENEMYMAGIC]) then
                    Type = DC.ENEMYMAGIC;

                    -- NOTE: if a unit is charmed and has another magical debuff
                    -- this block will be executed...
                else -- the unit doesn't have a magical debuff or we can't remove magical debuffs
                    Type = DC.CHARMED; -- The player can't remove it anyway so just say the unit is afflicted by a charming effect
                    TypeName = DC.TypeNames[DC.CHARMED];
                end
                CharmFound = true;
            end

            -- If we found a type, register the Debuff
            if Type then
                -- Create a Debuff index entry if necessary
                if (not ThisUnitDebuffs[StoredDebuffIndex]) then
                    ThisUnitDebuffs[StoredDebuffIndex] = {};
                end

                ThisUnitDebuffs[StoredDebuffIndex].Duration       = Duration;
                ThisUnitDebuffs[StoredDebuffIndex].ExpirationTime = ExpirationTime;
                ThisUnitDebuffs[StoredDebuffIndex].Texture        = Texture;
                ThisUnitDebuffs[StoredDebuffIndex].Applications   = Applications;
                ThisUnitDebuffs[StoredDebuffIndex].TypeName       = TypeName;
                ThisUnitDebuffs[StoredDebuffIndex].Type           = Type;
                ThisUnitDebuffs[StoredDebuffIndex].Name           = Name;
                ThisUnitDebuffs[StoredDebuffIndex].index          = i;

                -- we can't use i, else we wouldn't have contiguous indexes in the table
                StoredDebuffIndex = StoredDebuffIndex + 1;
            end

            i = i + 1;

            -- if a deadly debuff has been found, just forget everything...
            if DC.IS_DEADLY_DEBUFF[SpellID] then
                StoredDebuffIndex = 1;
                break;
            end
        end

        -- erase remaining unused entries without freeing the memory (less garbage)
        while (ThisUnitDebuffs[StoredDebuffIndex]) do
            ThisUnitDebuffs[StoredDebuffIndex].Type = false;
            StoredDebuffIndex = StoredDebuffIndex + 1;
        end

        -- if no debuff on the unit then it can't be charmed... or is it?
        -- if i == 1 then
        --    IsCharmed = false;
        -- end

        return ThisUnitDebuffs, IsCharmed;
    end --}}}
end


do
    -- see the comment about DebuffUnitCache
    local ManagedDebuffUnitCache = D.ManagedDebuffUnitCache;


    local continue_; -- if we have to ignore a debuff, this will become false
    local D = D;
    local _;
    local CureOrder;
    local sorting = function (a, b)

        CureOrder = D.classprofile.CureOrder;

        return CureOrder[a.Type] * 10000 - a.Applications < CureOrder[b.Type] * 10000 - b.Applications;
    end

    local NotRaidOrParty = {
        ["player"]      = true,
        ["target"]      = true,
        ["focus"]       = true,
        ["mouseover"]   = true,
    };

    local HostileHolders = {
        ["target"]      = true,
        ["focus"]       = true,
        ["mouseover"]   = true,
    };

    local function UnitFilteringTest(unit, filterValue)

        --D:Debug("UnitFilteringTest:", unit, filterValue);

        if not filterValue then
            return nil;
        end

        if filterValue==1 and unit ~= 'player' then -- for personal spells
            return true;
        elseif filterValue==2 and NotRaidOrParty[unit] then -- for spells that can't be used on oneself
            return true;
        end

    end

    D.UnitFilteringTest = UnitFilteringTest; -- I need this function elsewhere

    -- This function will return a table containing only the Debuffs we can cure excepts the one we have to ignore
    -- in different conditions.
    function D:UnitCurableDebuffs (Unit, JustOne) -- {{{

        if not Unit then
            D:AddDebugText("No unit supplied to UnitCurableDebuffs()");
            return DC.EMPTY_TABLE, false;
        end

        if not ManagedDebuffUnitCache[Unit] then
            ManagedDebuffUnitCache[Unit] = {};
        end

        local ManagedDebuffs = ManagedDebuffUnitCache[Unit]; -- shortcut for readability

        if ManagedDebuffs[1] then
            t_wipe(ManagedDebuffs);
        end

        local AllUnitDebuffs, IsCharmed = self:GetUnitDebuffAll(Unit); -- always return a table, may be empty though

        local Spells    = self.Status.CuringSpells; -- shortcut to available spells by debuff type

        for _, Debuff in ipairs(AllUnitDebuffs) do

            continue_ = true;

            -- test if we have to ignore this debuf  {{{ --

            if UnitFilteringTest(Unit, self.Status.UnitFilteringTypes[Debuff.Type]) then
                continue_ = false; -- == skip this debuff
            end

            if self.profile.DebuffsToIgnore[Debuff.Name] then -- XXX not sure it has any actual use nowadays (2013-06-18)
                -- these are the BAD ones... the ones that make the target immune... abort this unit
                --D:Debug("UnitCurableDebuffs(): %s is ignored", Debuff.Name);
                break; -- exit here
            end

            if self.profile.BuffDebuff[Debuff.Name] then
                -- these are just ones you don't care about (sleepless deam etc...)
                continue_ = false; -- == skip this debuff
                --D:Debug("UnitCurableDebuffs(): %s is not a real debuff", Debuff.Name);
            end

            if self.Status.Combat or self.profile.DebuffAlwaysSkipList[Debuff.Name] then
                local _, EnUClass = UnitClass(Unit);
                if self.profile.skipByClass[EnUClass] then
                    if self.profile.skipByClass[EnUClass][Debuff.Name] then
                        -- these are just ones you don't care about by class while in combat

                        -- This lead to a problem because once the fight is finished there are no event to trigger
                        -- a rescan of this unit, so the debuff does not appear...

                        -- solution to the above problem:

                        if not self.profile.DebuffAlwaysSkipList[Debuff.Name] then
                            self:AddDelayedFunctionCall("ReScan"..Unit, D.MicroUnitF.UpdateMUFUnit, D.MicroUnitF, Unit);
                        end

                        D:Debug("UnitCurableDebuffs(): %s is configured to be skipped", Debuff.Name);
                        continue_ = false;
                    end
                end
            end

            -- }}}


            if continue_ then
                --      self:Debug("Debuffs matters");
                -- If we are still here it means that this Debuff is something not to be ignored...


                -- We have a match for this type and we decided (checked) to
                -- cure it NOTE: self.classprofile.CureOrder[DEBUFF_TYPE] is set
                -- to FALSE when the type is unchecked and to < 0 when there is
                -- no spell available for the type or when the spell is gone
                -- (it happens for warlocks or when using the same profile with
                -- several characters)
                --if (self.classprofile.CureOrder[Debuff.Type] and self.classprofile.CureOrder[Debuff.Type] > 0) then
                if self:GetCureTypeStatus(Debuff.Type) then


                    -- self:Debug("we can cure it");

                    -- if we do have a spell to cure
                    if Spells[Debuff.Type] then

                        -- self:Debug("It's managed");

                        ManagedDebuffs[#ManagedDebuffs + 1] = Debuff;

                        -- the live-list only reports the first debuf found and set JustOne to true
                        if JustOne then
                            break;
                        end
                    end
                end
            end
        end -- for END

        if ManagedDebuffs[1] then

            -- sort the table only if it contains more than 1 debuff
            if #ManagedDebuffs > 1 then
                t_sort(ManagedDebuffs, sorting);
            end

            if not D.UnitDebuffed[Unit] then
                D.UnitDebuffed[Unit] = true;
                D.ForLLDebuffedUnitsNum = D.ForLLDebuffedUnitsNum + 1;
            end

        else
            if D.UnitDebuffed[Unit] then
                D.UnitDebuffed[Unit] = false;
                D.ForLLDebuffedUnitsNum = D.ForLLDebuffedUnitsNum - 1;
            end
            return DC.EMPTY_TABLE, false; -- avoid race conditions
        end

        return ManagedDebuffs, IsCharmed;

    end -- // }}}

    local GetTime               = _G.GetTime;
    local Debuffs               = DC.EMPTY_TABLE; local IsCharmed = false; local Unit; local MUF; local IsDebuffed = false; local IsMUFDebuffed = false; local CheckStealth = false;
    local NoScanStatuses        = false;
    local band                  = _G.bit.band;
    --[===[@debug@
    --local debugprofilestop = _G.debugprofilestop;
    --@end-debug@]===]
    function D:ScanEveryBody()

        if not NoScanStatuses then
            NoScanStatuses = {[DC.ABSENT] = true, [DC.FAR] = true, [DC.BLACKLISTED] = true};
        end

        local UnitArray = self.Status.Unit_Array; local i = 1;
        local CheckStealth = self.profile.Show_Stealthed_Status;

        --[===[@debug@
        --local start = debugprofilestop();
        --@end-debug@]===]

        while UnitArray[i] do
            Unit = UnitArray[i];
            MUF = self.MicroUnitF.UnitToMUF[Unit];

            if MUF and not NoScanStatuses[MUF.UnitStatus] then
                IsMUFDebuffed = MUF.Debuffs[1] and true or band(MUF.UnitStatus, DC.CHARMED_STATUS) == DC.CHARMED_STATUS;

                Debuffs, IsCharmed = self:UnitCurableDebuffs(Unit, true);

                if CheckStealth then
                    self.Stealthed_Units[Unit] = self:CheckUnitStealth(Unit); -- update stealth status
                end

                IsDebuffed = (Debuffs[1] and true) or IsCharmed;
                -- If MUF disagrees
                if (IsDebuffed ~= IsMUFDebuffed) and not D:DelayedCallExixts("Dcr_Update" .. Unit) then
                    --[===[@debug@
                    if IsDebuffed then
                        self:AddDebugText("delayed debuff found by scaneveryone");
                        --D:ScheduleDelayedCall("Dcr_lateanalysis" .. Unit, self.MicroUnitF.LateAnalysis, 1, self.MicroUnitF, "ScanEveryone", Debuffs, MUF, MUF.UnitStatus);
                    else
                        self:AddDebugText("delayed UNdebuff found by scaneveryone on", Unit, IsDebuffed, IsMUFDebuffed);
                    end
                    --@end-debug@]===]

                    self.MicroUnitF:UpdateMUFUnit(Unit, true);

                    --[===[@debug@
                    --D:Println("HAAAAAAA!!!!!");
                    --@end-debug@]===]
                end
            end

            i = i + 1;
        end
        --[===[@debug@
        --D:Debug("|cFF777777Scanning everybody...", i - 1, "units scanned in ", debugprofilestop() - start, "miliseconds|r");
        --@end-debug@]===]
    end


    -- a little test... the ".." way wins (6x faster than the format solution) when both sides are strings
    function D:tests()

        local test = "test1";
        local start = GetTime();
        local strings = {"string1", "string2", "strring3"};
        local teststring = "unitraid5"
        for i =1, 1000000 do
            teststring = strings[i%3 + 1];
            test = "test_"..teststring;
        end
        D:Debug("pass (\"\".. completed in:", GetTime() - start, test);

        start = GetTime();
        for i =1, 1000000 do
            local t = strings[i%3 + 1];
            test = ("test_%s"):format(teststring);
        end
        D:Debug("pass format completed in:", GetTime() - start, test);

    end

end

--local UnitBuffsCache    = {};

do
    local G_UnitBuff = _G.UnitBuff;

    local buffName;


    local function UnitBuff(unit, BuffNameToCheck)
        for i = 1, 40 do
            buffName = G_UnitBuff(unit, i)
            if not buffName then
                return
            else
                if BuffNameToCheck == buffName then
                    return G_UnitBuff(unit, i)
                end
            end
        end
    end

    -- this function returns true if one of the debuff(s) passed to it is found on the specified unit
    function D:CheckUnitForBuffs(unit, BuffNamesToCheck) --{{{


        if type(BuffNamesToCheck) == "string" then

            return (UnitBuff(unit, BuffNamesToCheck)) and true or false;

        else
            for buff in pairs(BuffNamesToCheck) do

                if UnitBuff(unit, buff) then
                    return true;
                end

            end
        end

        return false;

    end --}}}
end



function D:CheckUnitStealth(unit)
    if self:CheckUnitForBuffs(unit, DC.IS_STEALTH_BUFF) then
        --      self:Debug("Sealth found !");
        return true;
    end
    return false;
end
-- }}}



T._LoadedFiles["Decursive.lua"] = "2.7.6.4";

-- Sin
