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
if not T._LoadedFiles or not T._LoadedFiles["Dcr_DebuffsFrame.xml"] or not T._LoadedFiles["Dcr_DebuffsFrame.lua"] then
    if not DecursiveInstallCorrupted then T._FatalError("Decursive installation is corrupted! (Dcr_DebuffsFrame.xml or Dcr_DebuffsFrame.lua not loaded)"); end;
    DecursiveInstallCorrupted = true;
    return;
end
T._LoadedFiles["Dcr_LiveList.lua"] = false;

local D   = T.Dcr;

local L     = D.L;
local LC    = D.LC;
local DC    = T._C;

--D.LiveList = OOP.Class();

-- http://www.lua.org/pil/13.4.1.html
-- define the namespace
D.LiveList = {};
local LiveList = D.LiveList;
-- a prototype for LiveList objects, empty, defaults are defined in the :New for better performances
LiveList.prototype = {};
LiveList.metatable ={ __index = LiveList.prototype };

function LiveList:new(...)
    local instance = setmetatable({}, self.metatable);
    instance:init(...);
    return instance;
end

local MicroUnitF = D.MicroUnitF;

LiveList.ExistingPerID      = {};
LiveList.Number             = 0;
LiveList.NumberShown        = 0;
D.ForLLDebuffedUnitsNum     = 0; -- this counts the number of displayed debuffed units. Used to know if the alert sound should/has been played

-- temporary variables often used in function
local Debuff, Debuffs, IsCharmed, MF, i, Index, RangeStatus;

-- local shortcuts to often called global functions
local pairs             = _G.pairs;
local ipairs            = _G.ipairs;
local next              = _G.next;
local select            = _G.select;
local unpack            = _G.unpack;
local table             = _G.table;
local UnitExists        = _G.UnitExists;
local IsSpellInRange    = D.IsSpellInRange;
local UnitClass         = _G.UnitClass;
local UnitIsFriend      = _G.UnitIsFriend;
local UnitGUID          = _G.UnitGUID;
local floor             = _G.math.floor;
local str_upper         = _G.string.upper;
local GetRaidTargetIndex= _G.GetRaidTargetIndex;
local t_wipe            = _G.table.wipe;


-- defines what is printed when the object is read as a string
function LiveList:ToString() -- {{{
    return "Decursive Live-List object";
end -- }}}

-- The Factory for LiveList objects
function LiveList:Create() -- {{{

    if self.Number >= D.profile.Amount_Of_Afflicted then
        return false;
    end

    self.ExistingPerID[self.Number + 1] = self:new(DcrLiveList, self.Number + 1);

    self.Number = self.Number + 1;

    return self.ExistingPerID[self.Number];

end -- }}}

function LiveList:PreCreate()
    if D.Status.Combat or self.Number >= D.profile.Amount_Of_Afflicted then
        return;
    end

    D:Debug("(LiveList) Precreating LL item");

    self.ExistingPerID[self.Number + 1] = self:new(DcrLiveList, self.Number + 1);

    self.Number = self.Number + 1;
    D:Debug("done");

    LiveList:PreCreate();

end

function LiveList:DisplayItem (ID, UnitID, Debuff) -- {{{

    --D:Debug("(LiveList) Displaying LVItem %d for UnitID %s", ID, UnitID);
    local LVItem = false;

    if ID > self.Number + 1 then -- sanity check
        return error(("LiveList:DisplayItem: bad argument #1 'ID (= %d)' must be < LiveList.Number + 1 (LiveList.Number = %d) UnitID was %s, Amount_Of_Afflicted 2disp: %d"):format(ID, self.Number, UnitID, D.profile.Amount_Of_Afflicted), 2);
    end

    if not self.ExistingPerID[ID] then
        LVItem = self:Create();
    else
        LVItem = self.ExistingPerID[ID];
    end

    if not LVItem then
        return false;
    end

    if not Debuff then
        Debuff = D.ManagedDebuffUnitCache[UnitID][1];
    end

    LVItem:SetDebuff(UnitID, Debuff, nil);
    --D:Debug("XXXX => Updating ll item %d for %s", ID, UnitID);

    if not LVItem.IsShown then
        --[===[@debug@--
        D:Debug("(LiveList) Showing LVItem %d", ID);
        --@end-debug@]===]

        LVItem.Frame:Show();

        --[===[@debug@--
        D:Debug("(LiveList) done", ID);
        --@end-debug@]===]

        self.NumberShown = self.NumberShown + 1;
        LVItem.IsShown = true;
    end

end -- }}}

function LiveList:RestAllPosition () -- {{{
    for _, LVitem in ipairs(self.ExistingPerID) do
        LVitem.Frame:ClearAllPoints();
        LVitem.Frame:SetPoint(LVitem:GiveAnchor());
    end
end -- }}}

function LiveList.prototype:GiveAnchor() -- {{{

    local ItemHeight = self.Frame:GetHeight();

    if self.ID == 1 then
        if D.profile.ReverseLiveDisplay then
            return "BOTTOMLEFT", DecursiveMainBar, "BOTTOMLEFT", 5, -1 * (ItemHeight + 1) * D.profile.Amount_Of_Afflicted;
        else
            return "TOPLEFT", DecursiveMainBar, "BOTTOMLEFT", 5, 0;
        end
    else
        if D.profile.ReverseLiveDisplay then
            return "BOTTOMLEFT", LiveList.ExistingPerID[self.ID - 1].Frame, "TOPLEFT", 0, 1;
        else
            return "TOPLEFT", LiveList.ExistingPerID[self.ID - 1].Frame, "BOTTOMLEFT", 0, -1;
        end
    end

end -- }}}


function LiveList.prototype:init(Container,ID) -- {{{

    --LiveList.super.prototype.init(self); -- needed
    D:Debug("(LiveList) Initializing LiveList object '%s'", ID);

    --ObjectRelated
    self.ID                 = ID;
    self.IsShown            = false;
    self.Parent             = Container;

    --Debuff info
    self.UnitID             = false;
    self.UnitName           = false;
    self.RaidTargetIndex    = false;
    self.PrevUnitName       = false;
    self.PrevUnitID         = false;
    self.PrevRaidTargetIndex= false;
    self.UnitClass          = false;

    self.Debuff             = {};

    self.PrevDebuffIndex    = false;
    self.PrevDebuffName     = false;
    self.PrevDebuffTypeName    = false;
    self.PrevDebuffApplicaton  = false;
    self.PrevDebuffTexture  = false;

    self.IsCharmed          = false;
    self.PrevIsCharmed      = false;

    self.Alpha              = false;

    -- Create the frame
    self.Frame = CreateFrame ("Button", "DcrLiveListItem"..ID, self.Parent, "DcrLVItemTemplate");

    -- Set some basic properties
    self.Frame:SetFrameStrata("LOW");
    self.Frame:RegisterForClicks("AnyDown");

    -- Set the anchor of this item
    self.Frame:SetPoint(self:GiveAnchor());

    -- create the background
    self.BackGroundTexture = self.Frame:CreateTexture("DcrLiveListItem"..ID.."BackTexture", "BACKGROUND", "DcrLVBackgroundTemplate");

    -- Create the Icon Texture
    self.IconTexture = self.Frame:CreateTexture("DcrLiveListItem"..ID.."Icon", "ARTWORK", "DcrLVIconTemplate");

    -- Create the Debuff application count font string
    self.DebuffAppsFontString = self.Frame:CreateFontString("DcrLiveListItem"..ID.."Count", "OVERLAY", "DcrLLAfflictionCountFont");

    -- Create the character name Fontstring
    self.UnitNameFontString = self.Frame:CreateFontString("DcrLiveListItem"..ID.."UnitName", "OVERLAY", "DcrLLUnitNameFont");

    -- Create the unitID Fontstring
    self.UnitIDFontString = self.Frame:CreateFontString("DcrLiveListItem"..ID.."UnitID", "OVERLAY", "DcrLLUnitIDFont");
    --self.UnitIDFontString:SetHeight(3);

    -- Create the debuff type fontstring
    self.DebuffTypeFontString = self.Frame:CreateFontString("DcrLiveListItem"..ID.."Type", "OVERLAY", "DcrLLDebuffTypeFont");

    -- Create the Raid Target Icon Texture
    self.RaidIconTexture = self.Frame:CreateTexture("DcrLiveListItem"..ID.."RaidIcon", "ARTWORK", "DcrLVRaidIconTemplate");

    -- Create the debuff name fontstring
    self.DebuffNameFontString = self.Frame:CreateFontString("DcrLiveListItem"..ID.."Name", "OVERLAY", "DcrLLDebuffNameFont");


    -- a reference to this object
    self.Frame.Object = self;

end -- }}}

function LiveList.prototype:SetDebuff(UnitID, Debuff, IsCharmed) -- {{{
    self.UnitID             = UnitID;
    self.UnitName           = D:PetUnitName(UnitID, true);
    self.Debuff             = Debuff;
    self.IsCharmed          = IsCharmed;
    self.RaidTargetIndex    = GetRaidTargetIndex(UnitID);

    if D.profile.LiveListAlpha ~= self.Alpha then
        self.Frame:SetAlpha(D.profile.LiveListAlpha);
        self.Alpha = D.profile.LiveListAlpha;
    end

    -- Set the graphical elements to the right values
    -- Icon
    if self.PrevDebuffTexture ~= Debuff.Texture then
        self.IconTexture:SetTexture(Debuff.Texture);
        self.PrevDebuffTexture =  Debuff.Texture;
    end

    -- Raid Icon
    if self.PrevRaidTargetIndex ~= self.RaidTargetIndex then
        self.RaidIconTexture:SetTexture(self.RaidTargetIndex and DC.RAID_ICON_TEXTURE_LIST[self.RaidTargetIndex] or nil);
        self.PrevRaidTargetIndex = self.RaidTargetIndex;
    end

    -- Applications count
    if self.PrevDebuffApplicaton ~= Debuff.Applications then
        if (Debuff.Applications > 1) then
            self.DebuffAppsFontString:SetText(Debuff.Applications);
            self.PrevDebuffApplicaton = Debuff.Applications;
        else
            self.DebuffAppsFontString:SetText(" ");
            self.PrevDebuffApplicaton = " ";
        end
    end

    -- Unit Name
    if self.PrevUnitName ~= self.UnitName then
        self.UnitClass = (select(2, UnitClass(UnitID)));
        self.UnitNameFontString:SetText(self.UnitName);
        if self.UnitClass then
            self.UnitNameFontString:SetTextColor(unpack(DC.ClassesColors[self.UnitClass]));
        end
        self.PrevUnitName =  self.UnitName;
        --D:Debug("(LiveList) Updating %d with %s", self.ID, UnitID);
    end

    -- Unit ID
    if self.PrevUnitID ~= UnitID then
        self.UnitIDFontString:SetText("( "..UnitID.." )");
        self.PrevUnitID = UnitID;
    end

    -- Debuff Type Name
    if self.PrevDebuffTypeName ~= Debuff.TypeName then
        if Debuff.Type then
            self.DebuffTypeFontString:SetText(D:ColorText(L[str_upper(Debuff.TypeName)], "FF" .. DC.TypeColors[Debuff.Type] ));
            --self.DebuffTypeFontString:SetTextColor(DC.TypeColors[Debuff.Type]);
        else
            self.DebuffTypeFontString:SetText("Unknown");
        end
        self.PrevDebuffTypeName = Debuff.TypeName;
    end

    -- Debuff Name
    if self.PrevDebuffName ~= Debuff.Name then
        self.DebuffNameFontString:SetText(Debuff.Name);
        self.PrevDebuffName = Debuff.Name;
    end

end -- }}}


function LiveList:GetDebuff(UnitID) -- {{{
    --  (note that this function is only called for the mouseover and target if the MUFs are active)

    if (UnitID == "target" or UnitID == "mouseover") and (not UnitIsFriend(UnitID, "player") or not UnitExists(UnitID)) then
        if D.ManagedDebuffUnitCache[UnitID] and D.ManagedDebuffUnitCache[UnitID][1] then
            t_wipe(D.ManagedDebuffUnitCache[UnitID]); -- clear target/mouseover debufs, else it would stay on
            if D.UnitDebuffed[UnitID] then
                D.ForLLDebuffedUnitsNum = D.ForLLDebuffedUnitsNum - 1;
                D.UnitDebuffed[UnitID] = false;
            end
        end
        --D:Debug("(LiveList) GetDebuff() |cFF00DDDDcanceled|r, unit %s is hostile or gone.", UnitID);
        return false;
    end

    -- Get the unit Debuffs
    if not D.profile.ShowDebuffsFrame or not MicroUnitF.UnitToMUF[UnitID] or UnitID == "mouseover" or UnitID == "target" then
        --D:Debug("(|cff00ff00LiveList|r) Getting Debuff for ", UnitID, Debuffs, IsCharmed);
        Debuffs, IsCharmed = D:UnitCurableDebuffs(UnitID);
        --Debuffs, IsCharmed = D:UnitCurableDebuffs(UnitID, true);
    else -- The MUFs are active and Unit is not mouseover and is not target
        MF = MicroUnitF.UnitToMUF[UnitID];
        if MF then
            Debuffs = MF.Debuffs;
        end
    end

    return D.UnitDebuffed[UnitID];
end -- }}}

function LiveList:DelayedGetDebuff(UnitID) -- {{{
    if not D:DelayedCallExixts("Dcr_GetDebuff"..UnitID) then
        D.DebuffUpdateRequest = D.DebuffUpdateRequest + 1;
        D:Debug("LiveList: GetDebuff scheduled for, ", UnitID);
        D:ScheduleDelayedCall("Dcr_GetDebuff"..UnitID, self.GetDebuff, (D.profile.ScanTime / 3) * (1 + D.DebuffUpdateRequest / 30), self, UnitID);
    end
end -- }}}

local IndexOffset = 0; -- used when target and/or mouseover are found
local DebuffedUnitsNumber = 0;
local _;
function LiveList:Update_Display() -- {{{

    if not D.DcrFullyInitialized  then
        return;
    end

    --
    self:PreCreate();

    Index = 0;

    if D.profile.ShowDebuffsFrame and D.profile.LV_OnlyInRange then -- The MUFs are here and we test for range
        DebuffedUnitsNumber = MicroUnitF.UnitsDebuffedInRange;
    else -- the MUFs are not here or we don't test for range
        DebuffedUnitsNumber = D.ForLLDebuffedUnitsNum;
    end

    -- Check the units in order of importance:

    -- First the Target
    if D.Status.TargetExists and not D.Status.Unit_Array_GUIDToUnit[UnitGUID("target")] and self:GetDebuff("target") then -- TargetExists implies that the unit is a friend
        Index = Index + 1;
        self:DisplayItem(Index, "target");
        --D:Debug("frenetic target update");

        if D.profile.ShowDebuffsFrame and D.profile.LV_OnlyInRange then
            DebuffedUnitsNumber = DebuffedUnitsNumber + 1;
        end

        if not D.Status.SoundPlayed then
            D:PlaySound ("target", "LV target" );
        end
    end

    -- Then the MouseOver
    if not D.Status.MouseOveringMUF and D.UnitDebuffed["mouseover"] and not D.Status.Unit_Array_GUIDToUnit[UnitGUID("mouseover")] and self:GetDebuff("mouseover") then -- this won't catch new debuff if all debuffs disappeard while overing the unit...
        Index = Index + 1;
        self:DisplayItem(Index, "mouseover");
        --D:Debug("frenetic mouseover update");

        if D.profile.ShowDebuffsFrame and D.profile.LV_OnlyInRange then
            DebuffedUnitsNumber = DebuffedUnitsNumber + 1;
        end

        if not D.Status.SoundPlayed then
            D:PlaySound ("mouseover", "LV mouseover" );
        end
    end

    -- the sound played status is reset here because the live list is able to display target and mouseover units and far away ones...
    if DebuffedUnitsNumber == 0 and D.Status.SoundPlayed then
        D.Status.SoundPlayed = false;
        D:Debug("LiveList:Update_Display(): sound re-enabled");
    end

    IndexOffset = Index;

    -- Then continue with all the remaining units if at least one of them is debuffed
    -- We need this loop because:
    --      1, we have to show an ordered list (always true)
    --      2, we want to test if the unit is in spell range (only if the option is active and the MUFs hidden)
    --      There is no event to do the last and a not simple table.sort() would be needed for the first...
    if DebuffedUnitsNumber > 0 and Index < D.profile.Amount_Of_Afflicted then
        for _, UnitID in ipairs(D.Status.Unit_Array) do
            -- if the unit is debuffed and still exists and is not stealthed check this only if the MUFs engine is not there, redudent tests otherwise...
            if D.UnitDebuffed[UnitID] and UnitExists(UnitID) then

                -- we don't care about range
                if not D.profile.LV_OnlyInRange then
                    Index = Index + 1;
                    self:DisplayItem(Index, UnitID);

                    -- play the sound if not already done
                    if not D.Status.SoundPlayed then
                        D:PlaySound (UnitID, "LV scan NR" );
                    end

                else -- we care about range

                    if D.profile.ShowDebuffsFrame and MicroUnitF.UnitToMUF[UnitID] then
                        RangeStatus = MicroUnitF.UnitToMUF[UnitID].UnitStatus; -- MicroUnitF.UnitToMUF[UnitID] is nil sometimes XXX
                        RangeStatus = (RangeStatus == DC.AFFLICTED or RangeStatus == DC.AFFLICTED_AND_CHARMED) and true or false;
                    else
                        -- Test if the spell we are going to use is in range
                        -- Some time can elaps between the instant the debuff is detected and the instant it is shown.
                        -- Between those instants, a reconfiguration can happen (pet dies or some spells become unavailable)
                        -- So we test before calling this api that we can still cure this debuff type
                        if D.Status.CuringSpells[D.ManagedDebuffUnitCache[UnitID][1].Type] then
                            RangeStatus = IsSpellInRange(D.Status.CuringSpells[D.ManagedDebuffUnitCache[UnitID][1].Type], UnitID);
                        else
                            --[[
                            D:AddDebugText(
                                "LiveList:Update_Display(): couldn't get range, DType:", D.ManagedDebuffUnitCache[UnitID][1].Type,
                                "DTypeName:", D.ManagedDebuffUnitCache[UnitID][1].TypeName,
                                "DName:", D.ManagedDebuffUnitCache[UnitID][1].Name,
                                "MUFs are:", D.profile.ShowDebuffsFrame,
                                "InCombatLockdown():", InCombatLockdown(),
                                "UnitID:", UnitID,
                                "HasSpell", D.Status.HasSpell,

                                "MAGIC:", D.Status.CuringSpells[DC.MAGIC],
                                "ENEMYMAGIC:", D.Status.CuringSpells[DC.ENEMYMAGIC],
                                "CURSE:", D.Status.CuringSpells[DC.CURSE],
                                "POISON:", D.Status.CuringSpells[DC.POISON],
                                "DISEASE:", D.Status.CuringSpells[DC.DISEASE],
                                "CHARMED:", D.Status.CuringSpells[DC.CHARMED]
                            );
                            --]]
                            RangeStatus = 0;
                        end
                        RangeStatus = (RangeStatus and RangeStatus ~= 0) and true or false;
                    end

                    if (RangeStatus) then
                        Index = Index + 1;
                        self:DisplayItem(Index, UnitID);
                        -- play the sound if not already done
                        if not D.Status.SoundPlayed then
                            D:PlaySound (UnitID, "LV R" );
                        end
                    end
                end
            end

            -- don't loop if we reach the max displayed unit num or if all debuffed units have been displayed
            if Index == D.profile.Amount_Of_Afflicted or Index == DebuffedUnitsNumber + IndexOffset then
                break;
            end
        end
    end

    -- reset the sound if no units were displayed
    if not D.profile.ShowDebuffsFrame and Index == 0 and D.Status.SoundPlayed then
        D:Debug("LV: No more unit displayed, sound re-enabled");
        D.Status.SoundPlayed = false; -- re-enable the sound if no more debuff
    end

    -- Hide unneeded Items
    if self.NumberShown > Index then -- if there are more units shown than the actual number of debuffed units
        for i = Index + 1, self.NumberShown do
            if self.ExistingPerID[i] and self.ExistingPerID[i].IsShown then
                --D:Debug("(LiveList) Hidding LVItem %d", i);
                self.ExistingPerID[i].Frame:Hide();
                self.ExistingPerID[i].IsShown = false;
                self.NumberShown = self.NumberShown - 1;
            else
                break;
            end
        end
    end


end -- }}}



function LiveList:DisplayTestItem() -- {{{
    if not self.TestItemDisplayed and D.Status.Unit_Array[1] then
        self.TestItemDisplayed = GetTime();
        for i,unit in ipairs(D.Status.Unit_Array) do
            D:DummyDebuff(unit, "Test item");
        end
    end
end -- }}}

function LiveList:HideTestItem() -- {{{
     self.TestItemDisplayed = false;
     local i = 1;

     for UnitID, Debuffed in pairs(D.UnitDebuffed) do
         if Debuffed then
             D:ScheduleDelayedCall("Dcr_rmt"..i, D.DummyDebuff, i * (D.profile.ScanTime / 3), D, UnitID);
             i = i + 1;
         end
     end

end -- }}}


-- this displays the tooltips of the live-list
function LiveList:DebuffTemplate_OnEnter(frame) --{{{
    if D.profile.AfflictionTooltips and frame.Object.UnitID then
        DcrDisplay_Tooltip:SetOwner(frame, "ANCHOR_CURSOR");
        DcrDisplay_Tooltip:SetUnitDebuff(frame.Object.UnitID,frame.Object.Debuff.index); -- Reported to trigger a "script ran too long" error on 2016-09-13...
        DcrDisplay_Tooltip:Show();
    else
        D:Debug(D.profile.AfflictionTooltips, frame.Object.UnitID);
    end
end --}}}

function LiveList:Onclick() -- {{{
    D:Println(L["HLP_LL_ONCLICK_TEXT"]);
end -- }}}

T._LoadedFiles["Dcr_LiveList.lua"] = "2.7.6.4";
