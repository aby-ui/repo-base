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

if not T._LoadedFiles or not T._LoadedFiles["Dcr_lists.xml"] or not T._LoadedFiles["Dcr_lists.lua"] then -- XML are loaded even if LUA syntax errors exixts
    if not DecursiveInstallCorrupted then T._FatalError("Decursive installation is corrupted! (Dcr_lists.xml or Dcr_lists.lua not loaded)"); end;
    DecursiveInstallCorrupted = true;
    return;
end
T._LoadedFiles["Dcr_DebuffsFrame.lua"] = false;

local D   = T.Dcr;


local L     = D.L;
local LC    = D.LC;
local DC    = T._C;

local _G                = _G;
local setmetatable      = _G.setmetatable;
local unpack            = _G.unpack;
local select            = _G.select;
local pairs             = _G.pairs;
local ipairs            = _G.ipairs;
local bit               = _G.bit;
local GetTime           = _G.GetTime;
local IsControlKeyDown  = _G.IsControlKeyDown;
local IsAltKeyDown      = _G.IsAltKeyDown;
local IsShiftKeyDown    = _G.IsShiftKeyDown;
local floor             = _G.math.floor;
local table             = _G.table;
local t_insert          = _G.table.insert;
local UnitExists        = _G.UnitExists;
local UnitClass         = _G.UnitClass;
local fmod              = _G.math.fmod;
local UnitIsUnit        = _G.UnitIsUnit;
local InCombatLockdown  = _G.InCombatLockdown;
local GetRaidTargetIndex= _G.GetRaidTargetIndex;
local CreateFrame       = _G.CreateFrame;

-- NS def
D.MicroUnitF = {};
-- create a shortcut
local MicroUnitF = D.MicroUnitF;
MicroUnitF.prototype = {};
MicroUnitF.metatable ={ __index = MicroUnitF.prototype };

function MicroUnitF:new(...)
    local instance = setmetatable({}, self.metatable);
    instance:init(...);
    return instance;
end



-- Init object factory defaults
--MicroUnitF.ExistingPerID          = {};
MicroUnitF.ExistingPerUNIT          = {};
MicroUnitF.UnitToMUF                = {};
MicroUnitF.Number                   = 0;
MicroUnitF.UnitShown                = 0;
MicroUnitF.UnitsDebuffedInRange     = 0;
MicroUnitF.DraggingHandle           = false;
D.ForLLDebuffedUnitsNum             = 0;


-- using power 2 values just to OR them but only CHARMED_STATUS is ORed (it's a C style bitfield)
local NORMAL                = DC.NORMAL;
local ABSENT                = DC.ABSENT;
local FAR                   = DC.FAR;
local STEALTHED             = DC.STEALTHED;
local BLACKLISTED           = DC.BLACKLISTED;
local AFFLICTED             = DC.AFFLICTED;
local AFFLICTED_NIR         = DC.AFFLICTED_NIR;
local CHARMED_STATUS        = DC.CHARMED_STATUS;
local AFFLICTED_AND_CHARMED = DC.AFFLICTED_AND_CHARMED;
local EMPTY_TABLE           = DC.EMPTY_TABLE;

-- Those are the different colors used for the MUFs main texture
local MF_colors = { };



DC.MouseButtonsReadable = { -- {{{
    ["*%s1"]        =   L["HLP_LEFTCLICK"],   -- left mouse button
    ["*%s2"]        =   L["HLP_RIGHTCLICK"],  -- right mouse button
    ["*%s3"]        =   L["HLP_MIDDLECLICK"], -- middle mouse button
    ["*%s4"]        =   L["HLP_MOUSE4"],      -- 4th mouse button
    ["*%s5"]        =   L["HLP_MOUSE5"],      -- 5th mouse button
    ["ctrl-%s1"]    =   L["CTRL"]  .. "-" .. L["HLP_LEFTCLICK"],
    ["ctrl-%s2"]    =   L["CTRL"]  .. "-" .. L["HLP_RIGHTCLICK"],
    ["ctrl-%s3"]    =   L["CTRL"]  .. "-" .. L["HLP_MIDDLECLICK"],
    ["ctrl-%s4"]    =   L["CTRL"]  .. "-" .. L["HLP_MOUSE4"],
    ["ctrl-%s5"]    =   L["CTRL"]  .. "-" .. L["HLP_MOUSE5"],
    ["shift-%s1"]   =   L["SHIFT"] .. "-" .. L["HLP_LEFTCLICK"],
    ["shift-%s2"]   =   L["SHIFT"] .. "-" .. L["HLP_RIGHTCLICK"],
    ["shift-%s3"]   =   L["SHIFT"] .. "-" .. L["HLP_MIDDLECLICK"],
    ["shift-%s4"]   =   L["SHIFT"] .. "-" .. L["HLP_MOUSE4"],
    ["shift-%s5"]   =   L["SHIFT"] .. "-" .. L["HLP_MOUSE5"],
    ["alt-%s1"]     =   L["ALT"]   .. "-" .. L["HLP_LEFTCLICK"],
    ["alt-%s2"]     =   L["ALT"]   .. "-" .. L["HLP_RIGHTCLICK"],
    ["alt-%s3"]     =   L["ALT"]   .. "-" .. L["HLP_MIDDLECLICK"],
    ["alt-%s4"]     =   L["ALT"]   .. "-" .. L["HLP_MOUSE4"],
    ["alt-%s5"]     =   L["ALT"]   .. "-" .. L["HLP_MOUSE5"],
}; -- }}}

-- modifier for the macro
local AvailableModifier = { -- {{{
    "shift","ctrl","alt",
} -- }}}

-- MicroUnitF STATIC methods {{{

function MicroUnitF:Show()
    -- change handle position here depending on reverse display option or in INIT?
    D.MFContainer:SetScale(D.profile.DebuffsFrameElemScale);
    self:Place (); -- not strickly necessary but avoid glitches when switching between profiles where the scale is different...
    D.MFContainer:Show();
    D.profile.ShowDebuffsFrame = true;
    self:ResetAllPositions();
end

-- Updates the color table
function MicroUnitF:RegisterMUFcolors ()
    -- MF_colors = D.profile.MF_colors; -- this should be enough but is not because D.profile can change at unexpected times....
    D:tcopy(MF_colors, D.profile.MF_colors);
end

function MicroUnitF:GetFarthestVerticalMUF()
    -- "Everything pushes me further away..."

    if D.profile.DebuffsFrameVerticalDisplay then

        if self.UnitShown > D.profile.DebuffsFramePerline then
            return D.profile.DebuffsFramePerline;
        else
            return self.UnitShown;
        end

    else

        if self.UnitShown > D.profile.DebuffsFramePerline then
            return floor( self.UnitShown / D.profile.DebuffsFramePerline ) * D.profile.DebuffsFramePerline
            + ((self.UnitShown % D.profile.DebuffsFramePerline ~= 0) and 1 or - D.profile.DebuffsFramePerline + 1);
        else
            return 1;
        end

    end

end

-- defines what is printed when the object is read as a string
function MicroUnitF:ToString() -- {{{
    return "Decursive Micro Unit Frame Object";
end -- }}}

-- The Factory for MicroUnitF objects
function MicroUnitF:Create(Unit, ID) -- {{{

    if InCombatLockdown() then
        -- if we are fighting, postpone the call
        D:AddDelayedFunctionCall (
        "Create"..Unit, self.Create,
        Unit, ID);
        return false;
    end

    if self.ExistingPerUNIT[Unit] then
        return false;
    end


    -- create a new MUF object
    self.ExistingPerUNIT[Unit] = self:new(D.MFContainer, Unit, self.Number + 1, ID);

    self.Number = self.Number + 1;


    return self.ExistingPerUNIT[Unit];
end -- }}}


-- return the number MUFs we can use
function MicroUnitF:MFUsableNumber () -- {{{
    return ((self.MaxUnit > D.Status.UnitNum) and D.Status.UnitNum or self.MaxUnit);
end -- }}}

-- this is used when a setting influencing MUF's position is changed
function MicroUnitF:ResetAllPositions () -- {{{

    -- Lua is great...
    D:ScheduleDelayedCall("Dcr_MicroUnitF_ResetAllPositions", function()

        if InCombatLockdown() then
            D:AddDelayedFunctionCall (
            "ResetAllPositions", self.ResetAllPositions,
            self);
            return false;
        end

        if self:MFsDisplay_Update () == false then
            D:Debug("ResetAllPositions(): |cFFFFAA33We are not ready, let's call ourself back later...|r"); -- LOL
            self:ResetAllPositions();
            return false;
        end

        local Unit_Array = D.Status.Unit_Array;

        D:Debug("Resetting all MF position", 'perRow:', D.profile.DebuffsFramePerline, '#Unit_Array:', #Unit_Array);

        for i=1, #Unit_Array do
            local MF = self.ExistingPerUNIT[ Unit_Array[i] ]

            if MF then
                MF.Frame:SetPoint(unpack(self:GetMUFAnchor(i)));
            end
        end

        self:Place();
        return true;

    end, 0.5);

end -- }}}

-- return the anchor of a given MUF depending on its creation ID
do
    local Anchor = { "BOTTOMLEFT", 0, 0, "BOTTOMLEFT" };
    function MicroUnitF:GetMUFAnchor (ID) -- {{{

        local RowNum, NumOnRow

        if not D.profile.DebuffsFrameVerticalDisplay then
            RowNum =   floor( (ID - 1) / D.profile.DebuffsFramePerline);
            NumOnRow = fmod( (ID - 1), D.profile.DebuffsFramePerline);
        else
            RowNum =   fmod(  (ID - 1),  D.profile.DebuffsFramePerline );
            NumOnRow = floor( (ID - 1) / D.profile.DebuffsFramePerline );
        end

        local x = NumOnRow * (DC.MFSIZE + D.profile.DebuffsFrameXSpacing);
        local y = (D.profile.DebuffsFrameGrowToTop and 1 or -1) * RowNum * (D.profile.DebuffsFrameYSpacing + DC.MFSIZE);

        Anchor[2] = x; Anchor[3] = y;

        return Anchor;
    end


    function MicroUnitF:GetHelperAnchor (atBottom)

        if atBottom then
            -- set Anchor table
            self:GetMUFAnchor(D.profile.DebuffsFrameGrowToTop and 1 or self:GetFarthestVerticalMUF());
            Anchor[3] = Anchor[3] - (D.profile.DebuffsFrameYSpacing + DC.MFSIZE);

            return "TOPLEFT", self.Frame, Anchor[2], Anchor[3], "BOTTOMLEFT";
        else
            -- set Anchor table
            self:GetMUFAnchor(D.profile.DebuffsFrameGrowToTop and self:GetFarthestVerticalMUF() or 1);
            Anchor[3] = Anchor[3] + (D.profile.DebuffsFrameYSpacing + DC.MFSIZE);

            return "BOTTOMLEFT", self.Frame, Anchor[2], Anchor[3], "BOTTOMLEFT";
        end

    end

end-- }}}


function MicroUnitF:Delayed_MFsDisplay_Update ()
    if D.profile.ShowDebuffsFrame then
        D:ScheduleDelayedCall("Dcr_Delayed_MFsDisplay_Update", self.MFsDisplay_Update, 1.5, self);
    end
end

-- This update the MUFs display, show and hide MUFs as necessary
function MicroUnitF:MFsDisplay_Update () -- {{{

    if (not D.profile.ShowDebuffsFrame) then
        return;
    end

    -- This function cannot do anything if we are fighting
    if InCombatLockdown() then
        -- if we are fighting, postpone the call
        D:AddDelayedFunctionCall (
        "UpdateMicroUnitFrameDisplay", self.MFsDisplay_Update,
        self);
        return false;
    end

    -- Get an up to date unit array if necessary
    D:GetUnitArray(); -- this is the only place where GetUnitArray() is called directly

    -- =======
    --  Begin
    -- =======

    -- get the number of MUFs we should display
    local NumToShow = self:MFUsableNumber();


    -- if we don't have all the MUFs needed then return, we are not ready
    if (self.Number < NumToShow) then
        self:Delayed_MFsDisplay_Update ();
        return false;
    end


    local MF = false;
    local i = 1;
    local Old_UnitShown = self.UnitShown;


    D:Debug("Update required: NumToShow = ", NumToShow);

    local Unit_Array_UnitToGUID = D.Status.Unit_Array_UnitToGUID;
    local Unit_Array            = D.Status.Unit_Array;


    -- Scan unit array in display order and show the maximum until NumToShow is reached
    -- The ID is set for all MUFs present in our unit array
    local Updated = 0;
    for i, Unit in ipairs(Unit_Array) do

        MF = self.ExistingPerUNIT[Unit];
        if MF then
            MF.ID = i;

            if not MF.Shown and i <= NumToShow then -- we got this unit in our group but it's hidden

                MF.Shown = true;
                self.UnitShown = self.UnitShown + 1;
                MF.ToPlace = true;
                Updated = Updated + 1;

                D:ScheduleDelayedCall("Dcr_Update"..MF.CurrUnit, MF.UpdateWithCS, D.profile.DebuffsFrameRefreshRate * (0.9 + Updated / D.profile.DebuffsFramePerUPdate), MF);
                --D:Debug("|cFF88AA00Show schedule for MUF", Unit, "UnitShown:", self.UnitShown);
            end
        else
            --D:errln("showhide: no muf for", Unit); -- call delay display up
            self:Delayed_MFsDisplay_Update ();
        end

    end

    -- hide remaining units
    if self.UnitShown > NumToShow then

        for Unit, MF in  pairs(self.ExistingPerUNIT) do -- see all the MUF we ever created and show or hide them if there corresponding unit exists

            -- hide
            if MF.Shown and (not Unit_Array_UnitToGUID[Unit] or MF.ID > NumToShow ) then -- we don't have this unit but its MUF is shown

                -- clear debuff before hiding to avoid leaving 'ghosts' behind... that would reappear briefly when the unit comes back
                if D.UnitDebuffed[MF.CurrUnit] then
                    D.UnitDebuffed[MF.CurrUnit] = false; -- used by the live-list only
                    D.ForLLDebuffedUnitsNum = D.ForLLDebuffedUnitsNum - 1;
                end

                MF.Debuffs                      = EMPTY_TABLE;
                MF.Debuff1Prio                  = false;
                MF.PrevDebuff1Prio              = false;
                D.Stealthed_Units[MF.CurrUnit]  = false;


                MF.Shown = false;
                self.UnitShown = self.UnitShown - 1;
                --D:Debug("|cFF88AA00Hiding %d (%s), scheduling update in %f|r", i, MF.CurrUnit, D.profile.DebuffsFrameRefreshRate * i);
                Updated = Updated + 1;
                D:ScheduleDelayedCall("Dcr_Update"..MF.CurrUnit, MF.Update, D.profile.DebuffsFrameRefreshRate * (0.9 + Updated / D.profile.DebuffsFramePerUPdate), MF);
                MF.Frame:Hide();
            end

        end
    end

    -- manage to get what we show in the screen
    if self.UnitShown > 0 and Old_UnitShown ~= self.UnitShown then
        MicroUnitF:Place();
    end

    return true;
end -- }}}


function MicroUnitF:Delayed_Force_FullUpdate ()
    if (D.profile.ShowDebuffsFrame) then
        D:ScheduleDelayedCall("Dcr_Force_FullUpdate", self.Force_FullUpdate, 0.3, self);
    end
end

function MicroUnitF:Force_FullUpdate () -- {{{
    if (not D.profile.ShowDebuffsFrame) then
        return false;
    end

    -- This function cannot do anything if we are fighting
    if InCombatLockdown() then
        -- if we are fighting, postpone the call
        D:AddDelayedFunctionCall (
        "Force_FullUpdate", self.Force_FullUpdate,
        self);
        return false;
    end

    D.Status.SpellsChanged = GetTime(); -- will force an update of all MUFs attributes

    D.MicroUnitF.UnitsDebuffedInRange = 0; -- reset this now since we are no longer able to maintain it.
    local i = 1;
    for Unit, MF in  pairs(self.ExistingPerUNIT) do

        --if not MF.Debuffs[1] then
            MF.UnitStatus = 0; -- reset status to force SetColor to update
        --end

        MF.CenterFontString:SetTextColor(unpack(MF_colors["COLORCHRONOS"]));

        MF.InnerTexture:SetColorTexture(unpack(MF_colors[CHARMED_STATUS]));

        D:ScheduleDelayedCall("Dcr_Update"..MF.CurrUnit, MF.UpdateWithCS, D.profile.DebuffsFrameRefreshRate * (0.9 + i / D.profile.DebuffsFramePerUPdate), MF);
        i = i + 1;
    end

    return true
end -- }}}


-- Those set the scalling of the MUF container
-- SACALING FUNCTIONS (MicroUnitF Children) {{{
do
    local UIScale = 0;
    local FrameScale = 0;

    local function TestMUFCorner(x, y, margin) -- {{{

        -- if the MUF is not horizontaly outside of the screen
        if not (x < 0 or x + margin > DC.ScreenWidth) then
            x = nil;
        end

        -- if the MUF is not vertically outside of the screen
        if not (y < 0 or y + margin > DC.ScreenHeight) then
            y = nil;
        end

        return x, y;
    end -- }}}

    function MicroUnitF.prototype:IsOnScreen(xDelta, yDelta) -- {{{

        -- frame relative position
        local left, bottom, width, height = self.Frame:GetRect();

        -- we need to check just one corner (MUFs are fix-sized squares)
        return TestMUFCorner(left * FrameScale - xDelta, bottom * FrameScale - yDelta, width * FrameScale);

    end -- }}}

    -- Place the MUFs container according to its scale
    function MicroUnitF:Place () -- {{{

        if self.UnitShown == 0 or self.DraggingHandle then return end

        if InCombatLockdown() then
            -- if we are fighting, postpone the call
            D:AddDelayedFunctionCall (
            "MicroUnitFPlace", self.Place,
            self);
            return false;
        end

        local UIParent = UIParent;

        UIScale       = UIParent:GetEffectiveScale()
        FrameScale    = self.Frame:GetEffectiveScale();

        DC.ScreenWidth  = UIParent:GetWidth() * UIScale;
        DC.ScreenHeight = UIParent:GetHeight() * UIScale;

        local saved_x, saved_y = D.profile.DebuffsFrameContainer_x, D.profile.DebuffsFrameContainer_y;
        local current_x, current_y = self.Frame:GetRect();
        current_x = current_x * FrameScale;
        current_y = current_y * FrameScale;

        -- If executed for the very first time, then put it in the top right corner of the screen
        if (not saved_x or not saved_y) then
            saved_x =    (UIParent:GetWidth() * UIScale) - (UIParent:GetWidth() * UIScale) / 4;
            saved_y =    (UIParent:GetHeight() * UIScale) - (UIParent:GetWidth() * UIScale) / 5;

            D.profile.DebuffsFrameContainer_x = saved_x;
            D.profile.DebuffsFrameContainer_y = saved_y;
        end


        -- test and fix handle's position if some MUFs are out of the screen
        local Handle_x_offset = 0;
        local Handle_y_offset = 0;
        local StickToRightOffest = 0;

        local Unit_Array = D.Status.Unit_Array;
        local x_out_arrays = {};
        local y_out_arrays = {};


        if D.profile.DebuffsFrameStickToRight then -- {{{
            local FirstLineNum = 0;
            -- get the number of max unit per line/row
            if not D.profile.DebuffsFrameVerticalDisplay then
                if self.UnitShown > D.profile.DebuffsFramePerline then
                    FirstLineNum = D.profile.DebuffsFramePerline;
                else FirstLineNum = self.UnitShown; end
            else
                if self.UnitShown > D.profile.DebuffsFramePerline then
                    FirstLineNum = floor( (self.UnitShown ) /  D.profile.DebuffsFramePerline ) + ((self.UnitShown % D.profile.DebuffsFramePerline ~= 0) and 1 or 0);
                else FirstLineNum = 1; end
            end

            -- get the offset of the handle we need to apply in order to align the MUFs on the right
            StickToRightOffest = FrameScale * (FirstLineNum * (DC.MFSIZE + D.profile.DebuffsFrameXSpacing) - D.profile.DebuffsFrameXSpacing );
        end -- }}}


        -- get a list of all MUFs which position is *saved* outside of the screen (hence the current_y - saved_y)
        for i=1, self.UnitShown do
            local MF = self.ExistingPerUNIT[ Unit_Array[i] ];

            if MF then
                x_out_arrays[#x_out_arrays + 1], y_out_arrays[#y_out_arrays + 1] = MF:IsOnScreen(current_x - saved_x + StickToRightOffest, current_y - saved_y)
            end
        end

        -- sort those lists to find the extrems
        if #x_out_arrays then table.sort(x_out_arrays) end
        if #y_out_arrays then table.sort(y_out_arrays) end


        -- test if there is no solution -- XXX cannot work
        if (x_out_arrays[1] and x_out_arrays[1] < 0 and  (x_out_arrays[#x_out_arrays] > DC.ScreenWidth))
            or (y_out_arrays[1] and y_out_arrays[1] < 0 and  (y_out_arrays[#y_out_arrays] > DC.ScreenHeight)) then
            D:Print(D:ColorText("WARNING: Your Micro-Unit-Frames' window is too big to fit entirely on your screen, you should change MUFs display settings (scale and/or disposition)! (Type /Decursive)", "FFFF0000"));
        end

        --D:Debug("MicroUnitF:Place(), outliers:", x_out_arrays[1], x_out_arrays[#x_out_arrays], y_out_arrays[1], y_out_arrays[#x_out_arrays]);

        -- x
        if x_out_arrays[1] then
            if x_out_arrays[1] < 0 then
                Handle_x_offset = -  x_out_arrays[1];
            else
                Handle_x_offset = - (x_out_arrays[#x_out_arrays] + DC.MFSIZE * FrameScale - DC.ScreenWidth)
            end
        end

        -- y
        if y_out_arrays[1] then
            if y_out_arrays[1] < 0 then
                Handle_y_offset = -  y_out_arrays[1];
            else
                Handle_y_offset = - (y_out_arrays[#y_out_arrays] + DC.MFSIZE * FrameScale - DC.ScreenHeight)
            end
        end

        --D:Debug("MicroUnitF:Place(), handle offset:", Handle_x_offset, Handle_y_offset);



        saved_x = saved_x + Handle_x_offset - StickToRightOffest;
        saved_y = saved_y + Handle_y_offset;

        -- set to the scaled position
        self.Frame:ClearAllPoints();
        self.Frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", saved_x/FrameScale , saved_y/FrameScale);
        D:Debug("MUF Window position set");

        D.MFContainerHandle:ClearAllPoints();
        D.MFContainerHandle:SetPoint(self:GetHelperAnchor());

        -- if the handle is at the top of the screen it means it's overlaping the MUF, let's move the handle somewhere else.
        if floor(D.MFContainerHandle:GetTop() * FrameScale + 0.5) == floor(UIParent:GetTop() * UIScale + 0.5) then -- if at top

            D.MFContainerHandle:ClearAllPoints();
            D.MFContainerHandle:SetPoint(self:GetHelperAnchor(true));

            D:Debug("|cff00ff00Handle moved|r");

        end

        return true


    end -- }}}

    -- Save the position of the frame without its scale
    function MicroUnitF:SavePos () -- {{{

        if self.UnitShown == 0 then return end


        if self.Frame:IsVisible() then
            -- We save the unscalled position (no problem if the sacale is changed behind our back)
            D.profile.DebuffsFrameContainer_x = self.Frame:GetEffectiveScale() * self.Frame:GetLeft();
            D.profile.DebuffsFrameContainer_y = self.Frame:GetEffectiveScale() * self.Frame:GetBottom();
            D:Debug("MUF pos:", D.profile.DebuffsFrameContainer_x, D.profile.DebuffsFrameContainer_y);


            -- if we choosed to align the MUF to the right then we have to add the
            -- width of the first line to get the original position of the handle

            if D.profile.DebuffsFrameStickToRight then -- {{{

                local FirstLineNum;

                if not D.profile.DebuffsFrameVerticalDisplay then
                    if self.UnitShown > D.profile.DebuffsFramePerline then
                        FirstLineNum = D.profile.DebuffsFramePerline;
                    else
                        FirstLineNum = self.UnitShown;
                    end
                else
                    if self.UnitShown > D.profile.DebuffsFramePerline then
                        FirstLineNum = floor( self.UnitShown / D.profile.DebuffsFramePerline ) + ((self.UnitShown % D.profile.DebuffsFramePerline ~= 0) and 1 or 0);
                    else
                        FirstLineNum = 1;
                    end
                end

                D.profile.DebuffsFrameContainer_x = D.profile.DebuffsFrameContainer_x + self.Frame:GetEffectiveScale() * (FirstLineNum * (DC.MFSIZE + D.profile.DebuffsFrameXSpacing) - D.profile.DebuffsFrameXSpacing);
            end -- }}}

            --      D:Debug("Frame position saved");
            D:Debug("MUF pos saved:", D.profile.DebuffsFrameContainer_x, D.profile.DebuffsFrameContainer_y);
        end

    end -- }}}
end

-- set the scaling of the MUFs container according to the user settings
function MicroUnitF:SetScale (NewScale) -- {{{

    -- Setting the new scale
    self.Frame:SetScale(NewScale);
    -- Place the frame adapting its position to the news cale
    self:Place ();

end -- }}}
-- }}}

-- Update the MUF of a given unitid
function MicroUnitF:UpdateMUFUnit(Unitid, CheckStealth)
    if not D.profile.ShowDebuffsFrame then
        return;
    end

    local unit = false;

    if (D.Status.Unit_Array_UnitToGUID[Unitid]) then
        unit = Unitid;
    else
        D:Debug("Unit", Unitid, "not in raid or party!" );
        return;
    end

    -- get the MUF object
    local MF = self.UnitToMUF[unit];

    if (MF and MF.Shown) then
        -- The MUF will be updated only every DebuffsFrameRefreshRate seconds at most
        -- but we don't miss any event XXX note this can be the cause of slowdown if 25 or 40 players got debuffed at the same instant, DebuffUpdateRequest is here to prevent that since 2008-02-17
        if (not D:DelayedCallExixts("Dcr_Update"..unit)) then
            D.DebuffUpdateRequest = D.DebuffUpdateRequest + 1;
            D:ScheduleDelayedCall("Dcr_Update"..unit, CheckStealth and MF.UpdateWithCS or MF.Update, D.profile.DebuffsFrameRefreshRate * (0.9 + D.DebuffUpdateRequest / D.profile.DebuffsFramePerUPdate), MF);
            D:Debug("Update scheduled for, ", unit, MF.ID);

            return true; -- return value used to aknowledge that the function actually did something
        end
    else
        D:Debug("No MUF found for ", unit, Unitid);
    end
end

-- Event management functions
-- MUF EVENTS (MicroUnitF children) (OnEnter, OnLeave, OnLoad, OnPreClick) {{{
do
    local UnitGUID = _G.UnitGUID;
    local GetSpellInfo = _G.GetSpellInfo;
    local ttHelpLines = {}; -- help tooltip text
    local TooltipUpdate = 0; -- help tooltip change update check

    T._CatchAllErrors = 'LibQTip';
    local LibQTip = LibStub('LibQTip-1.0');
    T._CatchAllErrors = false;

    local MUFtoolTip = nil;

    -- This function is responsible for showing the tooltip when the mouse pointer is over a MUF
    -- it also handles Unstable Affliction detection and warning.
    function MicroUnitF:OnEnter(frame) -- {{{
        D.Status.MouseOveringMUF = true;

        local MF = frame.Object;
        local Status;

        local Unit = MF.CurrUnit; -- shortcut
        local TooltipText = "";


        local GUIDwasFixed = false;
        local unitguid = UnitGUID(Unit);

        if unitguid ~= D.Status.Unit_Array_UnitToGUID[Unit] or Unit ~= D.Status.Unit_Array_GUIDToUnit[unitguid] then

            if unitguid then
                D.Status.Unit_Array_UnitToGUID[Unit] = unitguid;
                D.Status.Unit_Array_GUIDToUnit[unitguid] = Unit;
                GUIDwasFixed = true;
            end

        end

        MF:Update(false, false, true); -- will reset the color early and set the current status of the MUF
        MF:SetClassBorder(); -- set the border if it wasn't possible at the time the unit was discovered

        if not Unit then
            return; -- If the user overs the MUF before it's completely initialized
        end

        --Test for unstable affliction like spells
        if MF.Debuffs[1] then
            for i, Debuff in ipairs(MF.Debuffs) do
                if Debuff.Type then
                    -- Create a warning if an Unstable Affliction like spell is detected XXX will be integrated along with the filtering system comming 'soon'(tm)
                    if DC.IS_HARMFULL_DEBUFF[Debuff.Name] then
                    -- if Debuff.Name == DC.DS["Unstable Affliction"] or Debuff.Name == DC.DS["Vampiric Touch"] then
                        D:Println("|cFFFF0000 ==> %s !!|r (%s)", Debuff.Name, D:MakePlayerName((D:PetUnitName(      Unit, true    ))));
                        D:SafePlaySoundFile(DC.DeadlyDebuffAlert);
                    end
                end
            end

            -- TODO: scan here for fluidity buff/debuff and alert
            -- http://www.wowhead.com/search?q=Ionization#npc-abilities
            -- http://www.wowhead.com/search?q=+Fluidity#spells
        end

        if D.profile.AfflictionTooltips then
            MUFtoolTip = LibQTip:Acquire("DecursiveMUFToolTip", 1, "LEFT");
            MUFtoolTip:SetAutoHideDelay(.3, frame, function() MUFtoolTip = nil end)
            MUFtoolTip:Clear()

            -- removes the CHARMED_STATUS bit from Status, we don't need it
            Status = bit.band(MF.UnitStatus,  bit.bnot(CHARMED_STATUS));

            -- First, write the name of the unit in its class color
            if UnitExists(MF.CurrUnit) then
            MUFtoolTip:AddLine(
                ((DC.RAID_ICON_LIST[GetRaidTargetIndex(Unit)]) and (DC.RAID_ICON_LIST[GetRaidTargetIndex(Unit)] .. "0:0:0:0|t ") or "")
                -- Colored unit name
                .. D:ColorTextNA((D:PetUnitName(Unit, true)), ((UnitClass(Unit)) and DC.HexClassColor[ (select(2, UnitClass(Unit))) ] or "AAAAAA"))
                .. "  |cFF3F3F3F(".. Unit .. ")|r"
                );
            else
                MUFtoolTip:AddLine(MF.CurrUnit);
            end


            -- set UnitStatus text
            local StatusText = "";

            -- set the status text, just translate the bitfield to readable text
            if Status == NORMAL then
                StatusText = L["NORMAL"];

            elseif Status == ABSENT then
                StatusText = L["ABSENT"]:format(Unit);

            elseif Status == FAR then
                StatusText = L["TOOFAR"];

            elseif Status == BLACKLISTED then
                StatusText = L["BLACKLISTED"];

            elseif MF.Debuffs[1] and (Status == AFFLICTED or Status == AFFLICTED_NIR) then
                local DebuffType = MF.Debuffs[1].Type;
                StatusText = L["AFFLICTEDBY"]:format(D:ColorTextNA( L[DC.TypeNames[DebuffType]:upper()], DC.TypeColors[DebuffType]) );

            elseif Status == STEALTHED then
                StatusText = L["STEALTHED"];
            end

            -- Unit Status
            MUFtoolTip:AddLine(StatusText);

            -- list the debuff(s) names
            if MF.Debuffs[1] then
                for i, Debuff in ipairs(MF.Debuffs) do
                    if Debuff.Type then
                        local DebuffApps = Debuff.Applications;
                        MUFtoolTip:AddLine(D:ColorTextNA(Debuff.Name, DC.TypeColors[Debuff.Type]) .. (DebuffApps > 0 and (" (%d)"):format(DebuffApps) or ""));
                    end
                end
            end

            -- Display the tooltip
            MUFtoolTip:ClearAllPoints();
            MUFtoolTip:SetClampedToScreen(true)
            MUFtoolTip:SetPoint(self:GetHelperAnchor());
            MUFtoolTip:Show();

            -- if the tooltip is at the top of the screen it means it's overlaping the MUF, let's move the tooltip beneath the first MUF.
            if floor(MUFtoolTip:GetTop() + 0.5) >= floor(UIParent:GetTop() + 0.5) then -- if at top -- XXX attempt to perform arithmetic on a nil value, reported on 2018-08-16
                MUFtoolTip:ClearAllPoints();
                MUFtoolTip:SetPoint(self:GetHelperAnchor(true));
            end
        end

        -- show a help text in the Game default tooltip
        if D.profile.DebuffsFrameShowHelp then
            -- if necessary we will update the help tooltip text
            if (D.Status.SpellsChanged ~= TooltipUpdate and not D.Status.Combat) then
                ttHelpLines = {};
                local MouseButtons = D.db.global.MouseButtons;

                for Spell, Prio in pairs(D.Status.CuringSpellsPrio) do
                    ttHelpLines[Prio] = {[D:ColorText(DC.MouseButtonsReadable[MouseButtons[Prio]], D:NumToHexColor(MF_colors[Prio]))] =

                    ("%s%s"):format((GetSpellInfo(Spell)) or Spell, (D.Status.FoundSpells[Spell] and D.Status.FoundSpells[Spell][5]) and "|cFFFF0000*|r" or "")}
                end

                t_insert(ttHelpLines, {[DC.MouseButtonsReadable[MouseButtons[#MouseButtons - 1]]] = ("%s"):format(L["TARGETUNIT"])});
                t_insert(ttHelpLines, {[DC.MouseButtonsReadable[MouseButtons[#MouseButtons    ]]] = ("%s"):format(L["FOCUSUNIT"])});

                TooltipUpdate = D.Status.SpellsChanged;
            end

            D:DisplayLQTGameTooltip(ttHelpLines, frame)
        end

    end -- }}}

    function MicroUnitF:OnLeave(frame) -- {{{
        D.Status.MouseOveringMUF = false;
    end -- }}}

    local keyTemplate = "|cFF11FF11%s|r-|cFF11FF11%s|r";

    local keyHelp;

    function D.MicroUnitF:OnCornerLeave(frame)
    end

    function D.MicroUnitF:OnCornerEnter(frame)

        if MUFtoolTip then
            MUFtoolTip:Release();
            MUFtoolTip = nil;
        end

        if not keyHelp then
            keyHelp = {
                {[keyTemplate:format(D.L["ALT"],   D.L["HLP_LEFTCLICK"]) ] = D.L["HANDLEHELP"]},
                {[-1] =  -1},
                {[keyTemplate:format(D.L["ALT"],   D.L["HLP_RIGHTCLICK"])] = D.L["BINDING_NAME_DCRSHOWOPTION"]},
                {[-1] =  -1},
                {[keyTemplate:format(D.L["CTRL"],  D.L["HLP_LEFTCLICK"]) ] = D.L["BINDING_NAME_DCRPRSHOW"] },
                {[keyTemplate:format(D.L["SHIFT"], D.L["HLP_LEFTCLICK"]) ] = D.L["BINDING_NAME_DCRSKSHOW"] },
                {[-1] =  -1},
                {[keyTemplate:format(D.L["SHIFT"], D.L["HLP_RIGHTCLICK"])] = D.L["BINDING_NAME_DCRSHOW"] },
            }
        end

        if D.profile.DebuffsFrameShowHelp then
            D:DisplayLQTGameTooltip(keyHelp, frame);
        end;
    end
end


function MicroUnitF:OnLoad(frame) -- {{{
    frame:SetScript("PreClick", self.OnPreClick);
    frame:SetScript("PostClick", self.OnPostClick);
end
-- }}}

function MicroUnitF.OnPreClick(frame, Button) -- {{{
    D:Debug("Micro unit Preclicked: ", Button);

    local RequestedPrio;
    local ButtonsString = "";
    local modifier;

    if IsControlKeyDown() then
        modifier = "ctrl-";
    elseif IsAltKeyDown() then
        modifier = "alt-";
    elseif IsShiftKeyDown() then
        modifier = "shift-";
    end

    if Button == "LeftButton" then
        ButtonsString = "*%s1";
    elseif Button == "RightButton" then
        ButtonsString = "*%s2";
    elseif Button == "MiddleButton" then
        ButtonsString = "*%s3";
    elseif Button == "Button4" then
        ButtonsString = "*%s4";
    elseif Button == "Button5" then
        ButtonsString = "*%s5";
    else
        D:Debug("unknown button", Button);
        return;
    end

    RequestedPrio = D:tGiveValueIndex(D.db.global.MouseButtons, modifier and (modifier .. ButtonsString:sub(-3)) or ButtonsString);

    D:Debug("RequestedPrio:", RequestedPrio);
    if frame.Object.UnitStatus == NORMAL and D:tcheckforval(D.Status.CuringSpellsPrio, RequestedPrio) then

        D:Println(L["HLP_NOTHINGTOCURE"]);

    elseif (frame.Object.UnitStatus == AFFLICTED and frame.Object.Debuffs[1]) then
        local NeededPrio = D:GiveSpellPrioNum(frame.Object.Debuffs[1].Type);
        local Unit = frame.Object.CurrUnit; -- shortcut


        -- there is no spell for the requested prio ? (no spell registered to this modifier+mousebutton)
        if modifier and RequestedPrio and not D:tcheckforval(D.Status.CuringSpellsPrio, RequestedPrio) then

            D:Debug("No spell registered for", RequestedPrio);

            -- Get the priority that would have been requested without modifiers
            local RequestedPrioNoMod = D:tGiveValueIndex(D.db.global.MouseButtons, ButtonsString);

            -- Get the spell bond to this priority
            local NoModSpell = D:tGiveValueIndex(D.Status.CuringSpellsPrio, RequestedPrioNoMod)

            -- If there is one and it's a user customized macro
            if NoModSpell and D.Status.FoundSpells[NoModSpell][5] then
                D:Debug("But spell used by", ButtonsString, "is a user nacro");
                -- let the user use the modifiers he want without yelling at him
                RequestedPrio = RequestedPrioNoMod;
            end
        end

        if RequestedPrio and NeededPrio ~= RequestedPrio then
            D:errln(L["HLP_WRONGMBUTTON"]);
            if NeededPrio and MF_colors[NeededPrio] then
                D:Println(L["HLP_USEXBUTTONTOCURE"], D:ColorText(DC.MouseButtonsReadable[ D.db.global.MouseButtons[NeededPrio] ], D:NumToHexColor(MF_colors[NeededPrio])));
                --[===[@debug@
            else
                D:AddDebugText("Button wrong click info bug: NeededPrio:", NeededPrio, "Unit:", Unit, "RequestedPrio:", RequestedPrio, "Button clicked:", Button, "MF_colors:", unpack(MF_colors), "Debuff Type:", frame.Object.Debuffs[1].Type);
                --@end-debug@]===]
            end
        elseif RequestedPrio and D.Status.HasSpell then
            D.Status.ClickCastingWIP = true;
            D:Debug("ClickCastingWIP")
            D.Status.ClickedMF = frame.Object; -- used to update the MUF on cast success and failure to know which unit is being cured
            D.Status.ClickedMF.SPELL_CAST_SUCCESS = false;
            local spell = D.Status.CuringSpells[frame.Object.Debuffs[1].Type];

            D.Status.ClickedMF.CastingSpell = "notyet";
            D:Debuff_History_Add(frame.Object.Debuffs[1].Name, frame.Object.Debuffs[1].TypeName);
        end
    end
end -- }}}

function MicroUnitF:OnPostClick(frame, button)
    D:Debug("Micro unit PostClicked");
    D.Status.ClickCastingWIP = false;
end

-- }}}

-- }}}



-- MicroUnitF NON STATIC METHODS {{{
-- init a new micro frame (Call internally by :new() only)
function MicroUnitF.prototype:init(Container, Unit, FrameNum, ID) -- {{{

    D:Debug("Initializing MicroUnit object", Unit, "with FrameNum=", FrameNum, " and ID", ID);


    -- set object default variables
    self.Parent             = Container;
    self.ID                 = ID; -- is set by te roaming updater
    self.FrameNum           = FrameNum;
    self.ToPlace            = true;
    self.Debuffs            = EMPTY_TABLE;
    self.Debuff1Prio        = false;
    self.PrevDebuff1Prio    = false;
    self.CurrUnit           = false;
    self.UnitName           = false;
    self.UnitGUID           = false;
    self.UnitClass          = false;
    self.UnitStatus         = 0;
    self.FirstDebuffType    = 0;
    self.NormalAlpha        = false;
    self.BorderAlpha        = false;
    self.Color              = {};
    self.IsCharmed          = false;
    self.UpdateCountDown    = 3;
    self.LastAttribUpdate   = 0;
    self.CenterText         = false;
    self.PrevCenterText     = false;
    self.Shown              = false; -- Setting this to true will broke the stick to right option
    self.UpdateCD           = 0;
    self.RaidTargetIcon     = false;
    self.PrevRaidTargetIndex= false;

    -- if it's a pet make it a little bit smaller
    local petminus = 0;
    if Unit:find("pet") then
        petminus = 4;
    end

    -- create the frame
    self.Frame  = CreateFrame ("Button", nil, self.Parent, "DcrMicroUnitTemplateSecure");
    self.CooldownFrame = CreateFrame ("Cooldown", nil, self.Frame, "DcrMicroUnitCDTemplate");

    if petminus ~= 0 then
        self.Frame:SetWidth(20 - petminus);
        self.Frame:SetHeight(20 - petminus);
        self.CooldownFrame:SetWidth(16 - petminus);
        self.CooldownFrame:SetHeight(16 - petminus);
    end

    -- outer texture (the class border)
    -- Bottom side
    self.OuterTexture1 = self.Frame:CreateTexture(nil, "BORDER", nil, 1);
    self.OuterTexture1:SetPoint("BOTTOMLEFT", self.Frame, "BOTTOMLEFT", 0, 0);
    self.OuterTexture1:SetPoint("TOPRIGHT", self.Frame, "BOTTOMRIGHT",  0, 2);

    -- left side
    self.OuterTexture2 = self.Frame:CreateTexture(nil, "BORDER", nil, 1);
    self.OuterTexture2:SetPoint("TOPLEFT", self.Frame, "TOPLEFT", 0, -2);
    self.OuterTexture2:SetPoint("BOTTOMRIGHT", self.Frame, "BOTTOMLEFT", 2, 2);

    -- top side
    self.OuterTexture3 = self.Frame:CreateTexture(nil, "BORDER", nil, 1);
    self.OuterTexture3:SetPoint("TOPLEFT", self.Frame, "TOPLEFT", 0, 0);
    self.OuterTexture3:SetPoint("BOTTOMRIGHT", self.Frame, "TOPRIGHT", 0, -2);

    -- right side
    self.OuterTexture4 = self.Frame:CreateTexture(nil, "BORDER", nil, 1);
    self.OuterTexture4:SetPoint("TOPRIGHT", self.Frame, "TOPRIGHT", 0, -2);
    self.OuterTexture4:SetPoint("BOTTOMLEFT", self.Frame, "BOTTOMRIGHT", -2, 2);


    -- global texture
    self.Texture = self.Frame:CreateTexture(nil, "BACKGROUND", nil, 2);
    self.Texture:SetPoint("CENTER",self.Frame ,"CENTER",0,0)
    self.Texture:SetHeight(16 - petminus);
    self.Texture:SetWidth(16 - petminus);

    -- inner Texture (Charmed special texture)
    self.InnerTexture = self.Frame:CreateTexture(nil, "OVERLAY", nil, 6);
    self.InnerTexture:SetPoint("TOPRIGHT",self.Frame ,"TOPRIGHT",0,0);
    self.InnerTexture:SetHeight(7 - petminus);
    self.InnerTexture:SetWidth(7 - petminus);
    self.InnerTexture:SetColorTexture(unpack(MF_colors[CHARMED_STATUS]));

    -- CenterText Font string
    self.CenterFontString = self.Frame:CreateFontString(nil, "ARTWORK", "DcrMicroUnitChronoFont");
    self.CenterFontString:SetFont(DC.NumberFontFileName, 12.2, "THICKOUTLINE, MONOCHROME")
    self.CenterFontString:SetPoint("CENTER",self.Frame ,"CENTER",1.6,0)
    self.CenterFontString:SetPoint("BOTTOM",self.Frame ,"BOTTOM",0,1)
    self.CenterFontString:SetTextColor(unpack(MF_colors["COLORCHRONOS"]));

    -- raid target icon
    self.RaidIconTexture = self.Frame:CreateTexture(nil, "OVERLAY", nil, 5);
    self.RaidIconTexture:SetPoint("CENTER",self.Frame ,"CENTER",0,8)
    self.RaidIconTexture:SetHeight(13 - petminus);
    self.RaidIconTexture:SetWidth(13 - petminus);


    -- a reference to this object
    self.Frame.Object = self;

    -- register events
    self.Frame:RegisterForClicks("AnyUp");
    self.Frame:SetFrameStrata("MEDIUM");

    -- set the frame attributes
    self:UpdateAttributes(Unit);

    -- once the MF frame is set up, schedule an event to show it
    MicroUnitF:Delayed_MFsDisplay_Update();
end -- }}}


function MicroUnitF.prototype:Update(SkipSetColor, SkipDebuffs, CheckStealth)



    local MF = self;
    local ActionsDone = 0;

    local Unit = MF.CurrUnit;

    -- The unit is the same but the name isn't... (check for class change)
    if MF.CurrUnit == Unit and D.Status.Unit_Array_UnitToGUID[self.CurrUnit] ~= self.UnitGUID then
        if MF:SetClassBorder() then
            ActionsDone = ActionsDone + 1; -- count expensive things done
        end
        -- if the guid changed we really need to rescan the unit!
        SkipSetColor = false; SkipDebuffs = false; CheckStealth = true;
        --[===[@debug@
        D:Debug("|cFF00CC00MUF:Update(): Guid change rescanning", Unit, "|r");
        --@end-debug@]===]
    end

    -- Update the frame attributes if necessary (Spells priority or unit id changes)
    if (D.Status.SpellsChanged ~= MF.LastAttribUpdate ) then
        --D:Debug("Attributes update required: ", MF.ID);
        if (MF:UpdateAttributes(Unit, true)) then
            ActionsDone = ActionsDone + 1; -- count expensive things done
            SkipSetColor = false; SkipDebuffs = false; -- if some attributes were updated then update the rest
        end
    end


    if (not SkipSetColor) then
        if (not SkipDebuffs) then
            -- get the manageable debuffs of this unit
            MF:SetDebuffs();
            --D:Debug("Debuff set for ", MF.ID);
            if CheckStealth then
                D.Stealthed_Units[MF.CurrUnit] = D:CheckUnitStealth(MF.CurrUnit); -- update stealth status
                --              D:Debug("MF:Update(): Stealth status checked as requested.");
            end
        end

        if (MF:SetColor()) then
            ActionsDone = ActionsDone + 1; -- count expensive things done
        end
    end

    return ActionsDone;
end


function MicroUnitF.prototype:UpdateWithCS()
    self:Update(false, false, true);
end

function MicroUnitF.prototype:UpdateSkippingSetBuf()
    self:Update(false, true);
end

-- UPDATE attributes (Spells and Unit) {{{



do
    -- used to tell if we changed something to improve performances.
    -- Each attribute change trigger an event...
    local ReturnValue = false;
    local tmp;
    -- this updates the sttributes of a MUF's frame object
    function MicroUnitF.prototype:SetUnstableAttribute(attribute, value)
        self.Frame:SetAttribute(attribute, value);
        self.usedAttributes[attribute] = self.LastAttribUpdate;
    end

    function MicroUnitF.prototype:CleanDefuncUnstableAttributes()
        for attribute, lastupdate in pairs(self.usedAttributes) do
            if lastupdate ~= self.LastAttribUpdate then
                self.Frame:SetAttribute(attribute, nil);
                self.usedAttributes[attribute] = nil;
                D:Debug("Removed defunc attribute", attribute);
            end
        end
    end

    function MicroUnitF.prototype:UpdateAttributes(Unit, DoNotDelay)

        -- Delay the call if we are fighting
        if InCombatLockdown() then
            if not DoNotDelay then
                D:AddDelayedFunctionCall (
                "MicroUnit_" .. Unit,                   -- UID
                self.UpdateAttributes, self, Unit);     -- function call
            end
            return false;
        end

        ReturnValue = false;

        if not self.usedAttributes then
            self.usedAttributes = {};
        end

        -- if the unit is not set
        if not self.CurrUnit then
            self.Frame:SetAttribute("unit", Unit);

            -- UnitToMUF[] can only be set when out of fight so it remains
            -- coherent with what is displayed when groups are changed during a
            -- fight

            MicroUnitF.UnitToMUF[Unit] = self;
            self.CurrUnit = Unit;

            self:SetClassBorder();

            -- set the return value because we did something expensive
            ReturnValue = self;
        end

        if (D.Status.SpellsChanged == self.LastAttribUpdate) then
            return ReturnValue; -- nothing changed
        end

        -- D:Debug("UpdateAttributes() executed");

        if self.LastAttribUpdate == 0 then -- only once
            -- set the mouse left-button actions on all modifiers
            self.Frame:SetAttribute("*type1", "macro");
            self.Frame:SetAttribute("ctrl-type1", "macro");
            self.Frame:SetAttribute("alt-type1", "macro");
            self.Frame:SetAttribute("shift-type1", "macro");

            -- set the mouse right-button actions on all modifiers
            self.Frame:SetAttribute("*type2", "macro");
            self.Frame:SetAttribute("ctrl-type2", "macro");
            self.Frame:SetAttribute("alt-type2", "macro");
            self.Frame:SetAttribute("shift-type2", "macro");

            -- set the mouse middle-button actions on all modifiers
            self.Frame:SetAttribute("*type3", "macro");
            self.Frame:SetAttribute("ctrl-type3", "macro");
            self.Frame:SetAttribute("alt-type3", "macro");
            self.Frame:SetAttribute("shift-type3", "macro");

            -- set the mouse 4th-button actions on all modifiers
            self.Frame:SetAttribute("*type4", "macro");
            self.Frame:SetAttribute("ctrl-type4", "macro");
            self.Frame:SetAttribute("alt-type4", "macro");
            self.Frame:SetAttribute("shift-type4", "macro");

            -- set the mouse 4th-button actions on all modifiers
            self.Frame:SetAttribute("*type5", "macro");
            self.Frame:SetAttribute("ctrl-type5", "macro");
            self.Frame:SetAttribute("alt-type5", "macro");
            self.Frame:SetAttribute("shift-type5", "macro");
        end

        local MouseButtons = D.db.global.MouseButtons;

        self:SetUnstableAttribute(MouseButtons[#MouseButtons - 1]:format("macrotext"), ("/target %s"):format(Unit));
        self:SetUnstableAttribute(MouseButtons[#MouseButtons    ]:format("macrotext"), ("/focus %s"):format(Unit));

        -- set the spells attributes using the lookup tables above
        for Spell, Prio in pairs(D.Status.CuringSpellsPrio) do

            if not D.Status.FoundSpells[Spell][5] then -- if using the default macro mechanism

                if not D.UnitFilteringTest (Unit, D.Status.FoundSpells[Spell][6]) then
                    --the [target=%s, help][target=%s, harm] prevents the 'please select a unit' cursor problem (Blizzard should fix this...)
                    -- -- XXX this trick may cause issues or confusion when for some reason the unit is invalid, nothing will happen when clicking
                    self:SetUnstableAttribute(MouseButtons[Prio]:format("macrotext"), ("%s/%s [@%s, help][@%s, harm] %s"):format(
                    not D.Status.FoundSpells[Spell][1] and "/stopcasting\n" or "", -- pet test
                    D.Status.FoundSpells[Spell][2] > 0 and "cast" or "use", -- item test
                    Unit,Unit,
                    Spell));
                end
            else
                tmp = D.Status.FoundSpells[Spell][5];
                tmp = tmp:gsub("UNITID", Unit);
                if tmp:len() < 256 then -- last chance protection, shouldn't happen
                    self:SetUnstableAttribute(MouseButtons[Prio]:format("macrotext"), tmp);
                else
                    D:errln("Macro too long for", Unit);
                end
            end

        end

        -- clean unused attributes...
        self:CleanDefuncUnstableAttributes();

        self.Debuff1Prio = false;

        -- the update timestamp
        self.LastAttribUpdate = D.Status.SpellsChanged;
        return self;
    end
end -- }}}

function MicroUnitF.prototype:SetDebuffs() -- {{{

    self.Debuffs, self.IsCharmed = D:UnitCurableDebuffs(self.CurrUnit);

    if self.Debuffs[1] then
        self.Debuff1Prio = D:GiveSpellPrioNum( self.Debuffs[1].Type );
    else
        self.Debuff1Prio                = false;
        self.PrevDebuff1Prio            = false;
    end
end -- }}}


function MicroUnitF.prototype:IsDebuffed()
     -- due to deffered calls the unit debuffs table to which .Debuffs refers
     -- might be emptied before it's actually used.
    return self.Debuffs[1] and true or false;
end

-- SetColor and SetClassBorder {{{
do
    --[=[
    --      This closure is responsible for setting all the textures of a MUF object:
    --          - The main color
    --          - Showing/Hiding the charmed alert square
    --          - The Alpha of the center and borders
    --      This closure also set the Status of the MUF that will be used in the tooltip
    --]=]
    local DebuffType, Unit, PreviousStatus, BorderAlpha, Class, ClassColor, ReturnValue, RangeStatus, Alpha, PrioChanged, Time, Status;
    local profile = {};

    -- global access optimization
    local IsSpellInRange    = D.IsSpellInRange;
    local IsItemInRange     = _G.IsItemInRange;
    local IsUsableItem      = _G.IsUsableItem;
    local UnitClass         = _G.UnitClass;
    local UnitExists        = _G.UnitExists;
    local UnitIsVisible     = _G.UnitIsVisible;
    local UnitLevel         = _G.UnitLevel;
    local unpack            = _G.unpack;
    local select            = _G.select;
    local GetTime           = _G.GetTime;
    local floor             = _G.math.floor;
    local fmod              = _G.math.fmod;
    local CooldownFrame_Set = _G.CooldownFrame_Set;
    local GetSpellCooldown  = _G.GetSpellCooldown;
    local GetItemCooldown   = _G.GetItemCooldown;
    local GetRaidTargetIndex= _G.GetRaidTargetIndex;
    local bor               = _G.bit.bor;
    local band              = _G.bit.band;
    local SpellID;

    function MicroUnitF.prototype:SetColor() -- {{{

        profile = D.profile;
        Status  = D.Status;

        -- register default alpha of the border
        BorderAlpha =  profile.DebuffsFrameElemBorderAlpha;

        -- register local variables
        DebuffType = false;
        ReturnValue = false;
        Unit = self.CurrUnit;
        PreviousStatus = self.UnitStatus;



        -- if unit not available, if a unit cease to exist (this happen often for pets)
        if not UnitExists(Unit) then
            if PreviousStatus ~= ABSENT then
                self.Color = MF_colors[ABSENT];
                self.UnitStatus = ABSENT;
                if self.CenterText then
                    self.CenterText = false;
                    self.CenterFontString:SetText(" ");
                end
            end

            -- UnitIsVisible() behavior is not 100% reliable so we also use UnitLevel() that will return -1 when the Unit is too far...
        elseif not UnitIsVisible(Unit) or UnitLevel(Unit) < 1 then
            if PreviousStatus ~= FAR then
                self.Color = MF_colors[FAR];
                self.UnitStatus = FAR;
                if self.CenterText then
                    self.CenterText = false;
                    self.CenterFontString:SetText(" ");

                end
            end

        else
            -- If the Unit is visible
            if profile.Show_Stealthed_Status and D.Stealthed_Units[Unit] and not self.Debuffs[1] then
                if PreviousStatus ~= STEALTHED then
                    self.Color = MF_colors[STEALTHED];
                    self.UnitStatus = STEALTHED;
                    if self.CenterText then
                        self.CenterText = false;
                        self.CenterFontString:SetText(" ");

                    end
                end

                -- if unit is blacklisted
            elseif Status.Blacklisted_Array[Unit] then
                if PreviousStatus ~= BLACKLISTED then
                    self.Color = MF_colors[BLACKLISTED];
                    self.UnitStatus = BLACKLISTED;
                    if self.CenterText then
                        self.CenterText = false;
                        self.CenterFontString:SetText(" ");

                    end
                end

                -- if the unit has some debuffs we can handle
            elseif self.Debuffs[1] then
                DebuffType = self.Debuffs[1].Type;

                self.Color = MF_colors[self.Debuff1Prio]; -- so people can play with the color settings (don't put it after the if).
                if self.PrevDebuff1Prio ~= self.Debuff1Prio then
                    self.PrevDebuff1Prio = self.Debuff1Prio;
                    PrioChanged = true;
                end

                SpellID = Status.FoundSpells[Status.CuringSpells[DebuffType]][2];

                -- Test if the spell we are going to use is in range
                -- Some time can elaps between the instant the debuff is detected and the instant it is shown.
                -- Between those instants, a reconfiguration can happen (pet dies or some spells become unavailable)
                -- So we test before calling this api that we can still cure this debuff type
                if Status.CuringSpells[DebuffType] then
                    RangeStatus = SpellID > 0 and IsSpellInRange(Status.CuringSpells[DebuffType], Unit) or D:isItemUsable(-1 * SpellID) and IsItemInRange(-1 * SpellID, Unit);
                else
                    RangeStatus = false;
                end

                Time = GetTime();

                if RangeStatus and self.UpdateCD < Status.UpdateCooldown then
                    if SpellID > 0 then
                        CooldownFrame_Set (self.CooldownFrame, GetSpellCooldown(Status.CuringSpells[DebuffType]));
                    else
                        CooldownFrame_Set (self.CooldownFrame, GetItemCooldown(-1 * SpellID));
                    end
                    self.UpdateCD = Time;
                end

                -- update the CenterText
                --if profile.DebuffsFrameChrono and self.Debuffs[1].ExpirationTime then
                if profile.CenterTextDisplay ~= '4_NONE' then

                    self.PrevCenterText = self.CenterText;

                    if Status.CenterTextDisplay ~= '3_STACKS' and self.Debuffs[1].ExpirationTime then

                        if Status.CenterTextDisplay == '2_TELAPSED' then
                            --self.CenterText = floor(Time - self.CenterText);
                            self.CenterText = floor(self.Debuffs[1].Duration - (self.Debuffs[1].ExpirationTime - Time));

                            if self.CenterText ~= self.PrevCenterText then -- do not unecessarily compute the final displayed string
                                --D:Debug('center text update');
                                self.CenterFontString:SetText( ((self.CenterText < 60) and self.CenterText or (floor(self.CenterText / 60) .. "\'") ));
                            end
                        elseif self.Debuffs[1].ExpirationTime > 0 then

                            self.CenterText = floor(self.Debuffs[1].ExpirationTime - Time);

                            if self.CenterText ~= self.PrevCenterText then
                                self.CenterFontString:SetText( ((self.CenterText < 60) and (self.CenterText + 1) or (floor(self.CenterText / 60 + 1) .. "\'") ));
                            end
                        elseif self.PrevCenterText then
                            self.CenterText = false;
                            self.CenterFontString:SetText(" ");
                        end

                    else

                        self.CenterText = self.Debuffs[1].Applications;

                        if self.CenterText ~= self.PrevCenterText then
                            self.CenterFontString:SetText(self.CenterText > 0 and self.CenterText or '');
                        end

                    end

                end

                self.RaidTargetIcon = GetRaidTargetIndex(Unit);
                if self.PrevRaidTargetIndex ~= self.RaidTargetIcon then
                    self.RaidIconTexture:SetTexture(self.RaidTargetIcon and DC.RAID_ICON_TEXTURE_LIST[self.RaidTargetIcon] or nil);
                    self.PrevRaidTargetIndex = self.RaidTargetIcon;
                end


                -- set the status according to RangeStatus
                if (not RangeStatus or RangeStatus == 0) then
                    Alpha = 0.40;
                    self.UnitStatus = AFFLICTED_NIR;
                else
                    Alpha = 1;
                    self.UnitStatus = AFFLICTED;
                    BorderAlpha = 1;
                end
            elseif PreviousStatus ~= NORMAL then
                -- the unit has nothing special, set the status to normal
                self.Color = MF_colors[NORMAL];
                self.UnitStatus = NORMAL;
                if self.CenterText then
                    self.CenterText = false;
                    self.CenterFontString:SetText(" ");
                end

                if self.RaidTargetIcon then
                    self.RaidIconTexture:SetTexture(nil);
                    self.RaidTargetIcon = false;
                    self.PrevRaidTargetIndex = false;
                end

                -- if the previous status was FAR, trigger a full rescan of the unit (combat log event does not report events for far away units)
                if PreviousStatus == FAR then
                    D.MicroUnitF:UpdateMUFUnit(self.CurrUnit, true); -- this is able to deal when a lot of update queries
                end
            end
        end

        if not profile.DebuffsFrameElemBorderShow then
            BorderAlpha = 0;
        end


        -- set the class border color when needed (the class is unknown and the unit exists or the unit name changed)
        --self:SetClassBorder();

        -- set the alpha of the border if necessary
        if self.BorderAlpha ~= BorderAlpha then
            self.OuterTexture1:SetAlpha(BorderAlpha);
            self.OuterTexture2:SetAlpha(BorderAlpha);
            self.OuterTexture3:SetAlpha(BorderAlpha);
            self.OuterTexture4:SetAlpha(BorderAlpha);

            self.BorderAlpha = BorderAlpha;

            -- set this to true because we just did something expensive...
            ReturnValue = true;
            --D:Debug("border alpha set");
        end


        -- Add the charm status to the bitfield (note that it's treated separatly because it's shown even if the unit is not afflicetd by anything we can cure)
        if self.IsCharmed then
            self.UnitStatus = bor(self.UnitStatus, CHARMED_STATUS);
        end

        -- if the unit is not afflicted or too far set the color to a lower alpha
        if not DebuffType then -- if DebuffType was not set, it means that the unit is too far
            Alpha = self.Color[4] * profile.DebuffsFrameElemAlpha;
            self.PrevDebuff1Prio = false;
        end


        -- Apply the colors and alphas only if necessary
        --      The MUF status changed
        --      The user changed the defaultAlpha
        --      The priority (and thus the color) of the first affliction changed
        if self.UnitStatus ~= PreviousStatus or self.NormalAlpha ~= profile.DebuffsFrameElemAlpha or PrioChanged then-- or self.FirstDebuffType ~= DebuffType) then


            if band(PreviousStatus, AFFLICTED)~=0 then
                MicroUnitF.UnitsDebuffedInRange =  MicroUnitF.UnitsDebuffedInRange - 1;
                D:Debug("SetColor(): UnitsDebuffedInRange decreased:",  MicroUnitF.UnitsDebuffedInRange);

                if MicroUnitF.UnitsDebuffedInRange == 0 and profile.HideLiveList then
                    D:Debug("SetColor(): No more unit, sound re-enabled");
                    Status.SoundPlayed = false;
                end
            end

            if band(self.UnitStatus, AFFLICTED)~=0 then
                MicroUnitF.UnitsDebuffedInRange =  MicroUnitF.UnitsDebuffedInRange + 1;
                D:Debug("SetColor(): UnitsDebuffedInRange INCREASED:",  MicroUnitF.UnitsDebuffedInRange);

                if not Status.SoundPlayed then
                    D:PlaySound (self.CurrUnit, "SetColor()");
                end
            end

            if PrioChanged then PrioChanged = false; end

            --[===[@debug@
            D:Debug('Setting MUF texture color...');
            --@end-debug@]===]
            -- Set the main texture
            self.Texture:SetColorTexture(self.Color[1], self.Color[2], self.Color[3], Alpha); -- XXX reported to cause rare "script ran too long" errors" on 2016-09-25 and 2016-12-30
            --self.Texture:SetAlpha(Alpha);
            --[===[@debug@
            D:Debug('Setting MUF texture color... done');
            --@end-debug@]===]



            -- Show the charmed alert square
            if self.IsCharmed then
                self.InnerTexture:Show();
            else
                self.InnerTexture:Hide();
            end

            --D:Debug("Color Applied, MUF Status:", self.UnitStatus);


            -- save the current global status
            self.NormalAlpha = profile.DebuffsFrameElemAlpha;
            self.FirstDebuffType = DebuffType;

            -- set this to true because we just did something expensive...
            ReturnValue = true;
        end

        return ReturnValue;

    end -- }}}

    function MicroUnitF.prototype:SetClassBorder() -- {{{
        --D:Debug("SetClassBorder called ", D.Status.Unit_Array_UnitToGUID[self.CurrUnit] , self.UnitGUID);
        ReturnValue = false;
        if (D.profile.DebuffsFrameElemBorderShow and (D.Status.Unit_Array_UnitToGUID[self.CurrUnit] ~= self.UnitGUID or (not self.UnitClass and UnitExists(self.CurrUnit)))) then

            -- Get the GUID of this unit
            self.UnitGUID = D.Status.Unit_Array_UnitToGUID[self.CurrUnit];

            if self.UnitGUID then -- can be nil because of focus...
                -- Get its class
                Class = (select(2, UnitClass(self.CurrUnit)));
            else
                Class = false;
            end

            -- if the class changed
            if (Class and Class ~= self.UnitClass) then
                ClassColor = DC.ClassesColors[Class];
                -- update the border color (the four borders)
                self.OuterTexture1:SetColorTexture(  unpack(ClassColor) );
                self.OuterTexture2:SetColorTexture(  unpack(ClassColor) );
                self.OuterTexture3:SetColorTexture(  unpack(ClassColor) );
                self.OuterTexture4:SetColorTexture(  unpack(ClassColor) );

                -- save the class for futur reference
                self.UnitClass = Class;

                -- set this to true because we just did something expensive...
                ReturnValue = true;

                --D:Debug("Class '%s' set for '%s'", Class, self.CurrUnit);
            elseif not Class and self.UnitClass then
                -- if the class is not available, set it to false so this test will be done again and again until a class is found
                self.UnitClass = false;
                BorderAlpha = 0;
                self.OuterTexture1:SetAlpha(BorderAlpha);
                self.OuterTexture2:SetAlpha(BorderAlpha);
                self.OuterTexture3:SetAlpha(BorderAlpha);
                self.OuterTexture4:SetAlpha(BorderAlpha);

                self.BorderAlpha = BorderAlpha;

                ReturnValue = true;
                --D:Debug("Class of unit %s is Nil", self.CurrUnit);
            end
        end
        return ReturnValue;
    end -- }}}

end -- }}}




-- }}}

do
    local MicroFrameUpdateIndex = 1; -- MUFs are not updated all together
    local NumToShow, ActionsDone, Unit, MF, pass, UnitNum;
    -- updates the micro frames if needed (called regularly by ACE event, changed in the option menu)
    function D:DebuffsFrame_Update() -- {{{

        local Unit_Array = self.Status.Unit_Array;
        local UnitToGUID = self.Status.Unit_Array_UnitToGUID;

        UnitNum = self.Status.UnitNum; -- we need to go through all the units to set MF.ID properly
        NumToShow = ((MicroUnitF.MaxUnit > UnitNum) and UnitNum or MicroUnitF.MaxUnit);

        ActionsDone = 0; -- used to limit the maximum number of consecutive UI actions


        -- we don't check all the MUF at each call, only some of them (changed in the options)
        for pass = 1, self.profile.DebuffsFramePerUPdate do

            -- When all frames have been updated, go back to the first
            if (MicroFrameUpdateIndex > UnitNum) then
                MicroFrameUpdateIndex = 1;
                -- self:Debug("last micro frame updated,,:: %d", #self.Status.Unit_Array);
            end

            -- get a unit
            Unit = Unit_Array[MicroFrameUpdateIndex];

            -- should never fire unless the player choosed to ignore everything or something is wrong somewhere in the code
            if not Unit then
                --self:Debug("Unit is nil :/");
                return false;
            end

            -- get its MUF
            MF = MicroUnitF.ExistingPerUNIT[Unit];

            -- if no MUF then create it (All MUFs are created here)
            if (not MF) then
                if not InCombatLockdown() then
                    MF = MicroUnitF:Create(Unit, MicroFrameUpdateIndex);
                    ActionsDone = ActionsDone + 1;
                end
            end

            -- place the MUF ~right where it belongs~
            if MF and MF.ToPlace ~= MicroFrameUpdateIndex and not InCombatLockdown() then

                --sanity check
                --[[
                if MicroFrameUpdateIndex ~= MF.ID then
                D:AddDebugText("DebuffsFrame_Update(): MicroFrameUpdateIndex ~= MF.ID", MicroFrameUpdateIndex, MF.ID, Unit, MF.CurrUnit, "ToPlace:", MF.ToPlace);
                end
                --]]

                MF.ToPlace = MicroFrameUpdateIndex;

                MF.Frame:SetPoint(unpack(MicroUnitF:GetMUFAnchor(MicroFrameUpdateIndex)));

                if MF.Shown then
                    MF.Frame:Show();
                end

                -- test for GUID change and force a debuff update in this case
                if UnitToGUID[MF.CurrUnit] ~= MF.UnitGUID then
                    MF.UpdateCountDown = 0; -- will force MF:Update() to be called
                    --[===[@debug@
                    --D:Println("|cFFFFAA55GUID change detected while placing for |r", MicroFrameUpdateIndex, UnitToGUID[MF.CurrUnit], MF.UnitGUID );
                    --@end-debug@]===]
                end

                ActionsDone = ActionsDone + 1;
            end

            -- update the MUF attributes and its colors -- this is done by an event handler now (buff/debuff received...) except when the unit has a debuff and is in range
            if MF and MicroFrameUpdateIndex <= NumToShow then
                if not (MF.Debuffs[1] or MF.IsCharmed) and MF.UpdateCountDown ~= 0 then
                    MF.UpdateCountDown = MF.UpdateCountDown - 1;
                else -- if MF.Debuffs or MF.IsCharmed or MF.UpdateCountDown == 0
                    ActionsDone = ActionsDone + MF:Update(false, true);--, not ((MF.Debuffs or MF.IsCharmed) and MF.UnitStatus ~= AFFLICTED)); -- we rescan debuffs if the unit is not in spell range XXX useless now since we rescan everyone every second
                    MF.UpdateCountDown = 3;
                end
            end

            -- we are done for this frame, go to te next
            MicroFrameUpdateIndex = MicroFrameUpdateIndex + 1;

            -- don't update more than 5 MUF in a row
            -- don't loop when reaching the end, wait for the next call (useful when less MUFs than PerUpdate)
            if (ActionsDone > 5 or pass == UnitNum) then
                --self:Debug("Max actions count reached");
                break;
            end

        end
        --    end
    end -- }}}
end

-- This little function returns the priority of the spell corresponding to an affliction type (one spell can be used for several types)
function D:GiveSpellPrioNum (Type) -- {{{
    return D.Status.CuringSpellsPrio[D.Status.CuringSpells[Type]];
end -- }}}








-- old unused variables and functions
-- UNUSED STUFF {{{
-- Micro Frame Events, useless for now



function MicroUnitF:OnAttributeChanged(self, name, value)
    D:Debug("Micro unit", name, "AttributeChanged to", value);
end


local MUF_Status = { -- unused
    [1] = "normal";
    [2] = "absent";
    [3] = "far";
    [4] = "stealthed";
    [5] = "blacklist";
    [6] = "afflicted";
    [7] = "afflicted-far";
    [8] = "afflicted-charmed";
    [9] = "afflicted-charmed-far";
}


local MF_Textures = { -- unused
    "Interface/AddOns/Decursive/Textures/BackDrop-red", -- red
    "Interface/AddOns/Decursive/Textures/BackDrop-blue", -- blue
    "Interface/AddOns/Decursive/Textures/BackDrop-orange", -- orange
    ["grey"] = "Interface\\AddOns\\Decursive\\Textures\\BackDrop-grey-medium",
    ["black"] = "Interface/AddOns/Decursive/Textures/BackDrop",
};


-- }}}

T._LoadedFiles["Dcr_DebuffsFrame.lua"] = "2.7.6.4";

-- Heresy
