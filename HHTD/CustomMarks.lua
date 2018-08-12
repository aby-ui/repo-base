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
    CustomMarks.lua
-----

This component hooks the name plates above characters and allow users to set custom marks only they can see.

--]=]

--  module framework {{{
local ERROR     = 1;
local WARNING   = 2;
local INFO      = 3;
local INFO2     = 4;


local ADDON_NAME, T = ...;
local HHTD = T.HHTD;
local L = HHTD.Localized_Text;


if not LibStub:GetLibrary("LibNameplateRegistry-1.0", true) then
    T._DiagStatus = 2;
    T._Diagmessage = "The required library LibNameplateRegistry-1.0 could not be loaded.\n\nMake sure HHTD is installed correctly.";
    T._FatalError(T._Diagmessage);
    return;
end

HHTD.Custom_Marks = HHTD:NewModule("CM", "LibNameplateRegistry-1.0");

local CM = HHTD.Custom_Marks;

CM:SetDefaultModulePrototype( HHTD.MODULE_PROTOTYPE );
CM:SetDefaultModuleLibraries( "AceConsole-3.0", "AceEvent-3.0");
CM:SetDefaultModuleState( false );

local LAST_TEXTURE_UPDATE = 0;

local playerNamesToMark

-- upvalues {{{
local GetCVarBool           = _G.GetCVarBool;
local GetCVar               = _G.GetCVar;
local GetTime               = _G.GetTime;
local pairs                 = _G.pairs;
local ipairs                = _G.ipairs;
local CreateFrame           = _G.CreateFrame;
local GetTexCoordsForRole   = _G.GetTexCoordsForRole;
-- }}}

function CM:OnInitialize() -- {{{

    -- if core failed to load...
    if T._DiagStatus == 2 then
        return;
    end

    self:Debug(INFO, "OnInitialize called!");

    if (select(2, LibStub:GetLibrary("LibNameplateRegistry-1.0"))) < 8 then
        T._DiagStatus = 2;
        T._Diagmessage = "The required library LibNameplateRegistry-1.0 is too old.\n\nMake sure HHTD has been installed correctly.";
        T._FatalError(T._Diagmessage);
    end


    self.db = HHTD.db:RegisterNamespace('CM', {
        global = {
            playerNamesToMark = {},
            MarkerChoice = 1,
            marker_Scale = 0.45,
            marker_Xoffset = 60,
            marker_Yoffset = 0,
            marker_VCr = 1,
            marker_VCg = 1,
            marker_VCb = 1,
            marker_VCa = 1,
        },
    })

    playerNamesToMark = self.db.global.playerNamesToMark
end -- }}}
do

    local function getRTTStr(rt)

        if not rt then
            return "no marker"
        end

        local ref = _G.UnitPopupButtons[("RAID_TARGET_%d"):format(rt)]
        local RAID_TARGET_TEXTURE_DIMENSION = _G.RAID_TARGET_TEXTURE_DIMENSION

        return ("|T%s:0:0:0:0:%d:%d:%d:%d:%d:%d|t"):format(ref.icon
            , RAID_TARGET_TEXTURE_DIMENSION, RAID_TARGET_TEXTURE_DIMENSION
            , ref.tCoordLeft   * RAID_TARGET_TEXTURE_DIMENSION
            , ref.tCoordRight  * RAID_TARGET_TEXTURE_DIMENSION
            , ref.tCoordTop    * RAID_TARGET_TEXTURE_DIMENSION
            , ref.tCoordBottom * RAID_TARGET_TEXTURE_DIMENSION
        )
    end

    local function getSelectorAssociations()
        local sA = {}
        for name, symbol in pairs(playerNamesToMark) do
            sA[name] = name .. " " .. getRTTStr(symbol)
        end

        return sA
    end

    local function updateMarkDisplay(un, action)
        for plate, plateData in CM:EachPlateByName(un) do
            if action == nil or action == 2 then
                CM:HideMarkerFromPlate(plate, un, "updateMarkDisplay");
            end
            if action ~= nil then
                CM:AddMarkerToPlate(plate, un, "updateMarkDisplay");
            end
         end
    end

    function CM:GetOptions () -- {{{
        return {
            [CM:GetName()] = {
                name = L[CM:GetName()],
                type = 'group',
                get = function (info) return self.db.global[info[#info]]; end,
                set = function (info, value) HHTD:SetHandler(self, info, value) end,
                args = {
                    Info1 = {
                        type = 'description',
                        name = HHTD:ColorText(L["OPT_CM_DESCRIPTION"], "FF00FF00"),
                        order = 0,
                    },
                    Warning1 = {
                        type = 'description',
                        name = HHTD:ColorText(L["OPT_NPH_WARNING1"], "FFFF0000"),
                        hidden = function () return GetCVarBool("nameplateShowEnemies") end,
                        order = 1,
                    },
                    Warning2 = {
                        type = 'description',
                        name = HHTD:ColorText(L["OPT_NPH_WARNING2"], "FFFF0000"),
                        hidden = function () return GetCVarBool("nameplateShowFriends") end,
                        order = 2,
                    },
                    MarkerChoice = {
                        type = 'select',
                        name = L['OPT_CM_SELECT_MARKER'],
                        desc = L['OPT_CM_SELECT_MARKER_DESC'],
                        values = {getRTTStr(1),getRTTStr(2),getRTTStr(3),getRTTStr(4),getRTTStr(5),getRTTStr(6),getRTTStr(7),getRTTStr(8)},
                        order = 3,
                    },
                    MarkTarget = {
                        type = 'execute',
                        name = L["OPT_CM_SETTARGETMARKER"],
                        desc = L["OPT_CM_SETTARGETMARKER_DESC"],
                        func = function ()
                            if (UnitGUID("target")) then
                                local un = (UnitName("target"))
                                local hadMark = self.db.global.playerNamesToMark[un]

                                self.db.global.playerNamesToMark[un] = self.db.global.MarkerChoice

                                updateMarkDisplay(un, hadMark and 2 or 1)


                                self:Debug(INFO, un, 'marked with mark #', self.db.global.MarkerChoice)
                                return un .. " marked with mark with " .. getRTTStr(self.db.global.MarkerChoice)
                            else
                                self:Debug(ERROR, L["OPT_TESTONTARGET_ENOTARGET"] );
                            end
                        end,
                        order = 5,
                    },
                    ClearTarget = {
                        type = 'execute',
                        name = L["OPT_CM_CLEARTARGETMARKER"],
                        desc = L["OPT_CM_CLEARTARGETMARKER_DESC"],
                        func = function ()
                            if (UnitGUID("target")) then
                                local un = (UnitName("target"));

                                self.db.global.playerNamesToMark[un] = nil

                                updateMarkDisplay(un)

                                self:Debug(INFO, un, 'mark cleared')
                            else
                                self:Debug(ERROR, L["OPT_TESTONTARGET_ENOTARGET"] );
                            end

                        end,
                        order = 7,
                    },
                    Header100 = {
                        type = 'header',
                        name = L["OPT_CM_MARKER_MANAGEMENT"],
                        order = 10,
                    },
                    existingAssoc = {
                        type = 'select',
                        name = L["OPT_CM_EXISTINGASSOC"],
                        desc = L["OPT_CM_EXISTINGASSOC_DESC"],
                        width = "double",
                        values = getSelectorAssociations,
                        order = 11,
                    },
                    ChangeMark = {
                        type = 'execute',
                        name = L["OPT_CM_CHANGEMARK"]:format(getRTTStr(self.db.global.MarkerChoice)),
                        desc = L["OPT_CM_CHANGEMARK_DESC"]:format(L['OPT_CM_SELECT_MARKER']),
                        disabled = function ()
                            local un = self.db.global.existingAssoc;
                            return un == nil or un and self.db.global.playerNamesToMark[un] == self.db.global.MarkerChoice
                        end,
                        func = function ()
                            local un = self.db.global.existingAssoc;

                            self.db.global.playerNamesToMark[un] = self.db.global.MarkerChoice

                            updateMarkDisplay(un, 2)

                            self:Debug(INFO, un, 'marked with mark #', self.db.global.MarkerChoice)
                        end,
                        order = 12,
                    },
                    ClearAssoc = {
                        type = 'execute',
                        name = L["OPT_CM_CLEARASSOC"],
                        desc = L["OPT_CM_CLEARASSOC_DESC"],
                        disabled = function () return self.db.global.existingAssoc == nil end,
                        func = function ()
                            local un = self.db.global.existingAssoc;

                            self.db.global.playerNamesToMark[un] = nil
                            self.db.global.existingAssoc = nil

                            updateMarkDisplay(un)


                            self:Debug(INFO, un, 'mark cleared (OPT_CM_CLEARASSOC)')
                        end,
                        order = 13,
                    },
                    Header150 = {
                        type = 'header',
                        name = L["OPT_NPH_MARKER_HIDDEN_WOW_SETTINGS"],
                        order = 14,
                    },
                    enemyNameplates = {
                        type = 'toggle',
                        name = L["OPT_NPH_ENEMY_NAMEPLATE"],
                        order = 14.01,
                        set = function (info, value)
                            SetCVar("nameplateShowEnemies", value and 1 or 0);
                        end,
                        get = function()
                            return GetCVarBool("nameplateShowEnemies");
                        end,
                    },
                    friendyNameplates = {
                        type = 'toggle',
                        name = L["OPT_NPH_FRIENDLY_NAMEPLATE"],
                        order = 14.1,
                        set = function (info, value)
                            SetCVar("nameplateShowFriends", value and 1 or 0);
                        end,
                        get = function()
                            return GetCVarBool("nameplateShowFriends");
                        end,
                    },
                    FNPC_Nameplate = {
                        type = 'toggle',
                        name = L["OPT_CM_FNPC_NAMEPLATE"],
                        desc = L["OPT_CM_FNPC_NAMEPLATE_DESC"],
                        width = 'double',
                        order = 14.2,
                        set = function (info, value)
                            SetCVar("nameplateShowFriendlyNPCs", value and 1 or 0);
                        end,
                        get = function()
                            return GetCVarBool("nameplateShowFriendlyNPCs");
                        end,
                    },
                    AlwaysShowNameplates = {
                        type = 'toggle',
                        name = _G.UNIT_NAMEPLATES_AUTOMODE or L["OPT_ALWAYS_SHOW_NAMEPLATES"],
                        desc = _G.OPTION_TOOLTIP_UNIT_NAMEPLATES_AUTOMODE or L["OPT_ALWAYS_SHOW_NAMEPLATES_DESC"],
                        width = 'double',
                        order = 14.3,
                        set = function (info, value)
                            SetCVar("nameplateShowAll", value and 1 or 0);
                        end,
                        get = function()
                            return GetCVarBool("nameplateShowAll");
                        end,
                    },
                    NamePlateMaxDistance = {
                        type = "range",
                        name = L["OPT_NPH_MAX_NAMEPLATE_DISTANCE"],
                        desc = L["OPT_NPH_MAX_NAMEPLATE_DISTANCE_DESC"],
                        min = 1,
                        max = 100,
                        softMax = 100,
                        step = 1,
                        bigStep = 1,
                        order = 14.4,
                        isPercent = false,
                        width=1.5,

                        set = function (info, value)
                            SetCVar("nameplateMaxDistance", value);
                        end,
                        get = function (info)
                            return tonumber(GetCVar("nameplateMaxDistance"));
                        end,
                    },
                    Header200 = {
                        type = 'header',
                        name = L["OPT_NPH_MARKER_SETTINGS"],
                        order = 15,
                    },
                    marker_Scale = {
                        type = "range",
                        name = L["OPT_NPH_MARKER_SCALE"],
                        desc = L["OPT_NPH_MARKER_SCALE_DESC"],
                        min = 0.45,
                        max = 3,
                        softMax = 2,
                        step = 0.01,
                        bigStep = 0.03,
                        order = 20,
                        isPercent = true,

                        set = function (info, value)
                            HHTD:SetHandler(self, info, value);
                            self:UpdateTextures();
                        end,
                    },
                    marker_Xoffset = {
                        type = "range",
                        name = L["OPT_NPH_MARKER_X_OFFSET"],
                        desc = L["OPT_NPH_MARKER_X_OFFSET_DESC"],
                        min = -100,
                        max = 100,
                        softMin = -60,
                        softMax = 60,
                        step = 0.01,
                        bigStep = 1,
                        order = 30,

                        set = function (info, value)
                            HHTD:SetHandler(self, info, value);
                            self:UpdateTextures();
                        end,
                    },
                    marker_Yoffset = {
                        type = "range",
                        name = L["OPT_NPH_MARKER_Y_OFFSET"],
                        desc = L["OPT_NPH_MARKER_Y_OFFSET_DESC"],
                        min = -100,
                        max = 100,
                        softMin = -60,
                        softMax = 60,
                        step = 0.01,
                        bigStep = 1,
                        order = 30,

                        set = function (info, value)
                            HHTD:SetHandler(self, info, value);
                            self:UpdateTextures();
                        end,
                    },
                    Header100 = {
                        type = 'header',
                        name = L["OPT_CM_MARKER_CUSTOMIZATION"],
                        order = 35,
                    },
                    marker_VCr = {
                        type = "range",
                        name = L["OPT_CM_VCr"],
                        desc = L["OPT_CM_VCr_DESC"],
                        min = 0,
                        max = 1,
                        step = 0.01,
                        order = 40,

                        set = function (info, value)
                            HHTD:SetHandler(self, info, value);
                            self:UpdateTextures();
                        end,
                    },
                    marker_VCg = {
                        type = "range",
                        name = L["OPT_CM_VCg"],
                        desc = L["OPT_CM_VCg_DESC"],
                        min = 0,
                        max = 1,
                        step = 0.01,
                        order = 45,

                        set = function (info, value)
                            HHTD:SetHandler(self, info, value);
                            self:UpdateTextures();
                        end,
                    },
                    marker_VCb = {
                        type = "range",
                        name = L["OPT_CM_VCb"],
                        desc = L["OPT_CM_VCb_DESC"],
                        min = 0,
                        max = 1,
                        step = 0.01,
                        order = 50,

                        set = function (info, value)
                            HHTD:SetHandler(self, info, value);
                            self:UpdateTextures();
                        end,
                    },
                    marker_VCa = {
                        type = "range",
                        name = L["OPT_CM_VCa"],
                        desc = L["OPT_CM_VCa_DESC"],
                        min = 0,
                        max = 1,
                        step = 0.01,
                        order = 55,

                        set = function (info, value)
                            HHTD:SetHandler(self, info, value);
                            self:UpdateTextures();
                        end,
                    }
                },
            },
        };
    end -- }}}
end

function CM:OnEnable() -- {{{
    self:Debug(INFO, "OnEnable");

    if T._DiagStatus == 2 then
        self:Disable();
        return;
    end


    self:RegisterEvent("PLAYER_ENTERING_WORLD");

    -- Subscribe to callbacks
    self:LNR_RegisterCallback("LNR_ON_NEW_PLATE");
    self:LNR_RegisterCallback("LNR_ON_RECYCLE_PLATE");

    self:LNR_RegisterCallback("LNR_ERROR_FATAL_INCOMPATIBILITY");

 
    for unitName, id in pairs(playerNamesToMark) do
        for plate, plateData in self:EachPlateByName(unitName) do
            self:AddMarkerToPlate(plate, self:GetPlateName(plate), false);
        end
    end

end -- }}}


function CM:OnDisable() -- {{{
    self:Debug(INFO2, "OnDisable");

    if T._DiagStatus == 2 then
        self:Print("|cFFD00000"..T._Diagmessage.."|r");
    end

    self:LNR_UnregisterAllCallbacks();
    -- clean all nameplates
    for plateTID, plate in pairs(self.DisplayedPlates_byFrameTID) do
        self:HideMarkerFromPlate(plate, false, "OnDisable");
    end
end -- }}}
-- }}}


CM.DisplayedPlates_byFrameTID = {}; -- used for updating plates dipslay attributes

local Plate_Name_Count = { -- array by name so we have to make the difference between friends and foes
};
local NP_Is_Not_Unique = { -- array by name so we have to make the difference between friends and foes
};

function CM:PLAYER_ENTERING_WORLD() -- {{{
    self:Debug(INFO2, "Cleaning multi instanced healers data");
    Plate_Name_Count = {};
    NP_Is_Not_Unique = {};
end -- }}}


-- Name Plates CallBacks {{{
function CM:LNR_ERROR_FATAL_INCOMPATIBILITY(selfevent, incompatibility_type)
    HHTD:FatalError("The Nameplate Hooker module had to be disabled due to an incompatibility.");

    self:Disable();
end

function CM:LNR_ON_NEW_PLATE(selfevent, plate, data)

    local plateName = data.name;
    local isFriend = (data.reaction == "FRIENDLY") and true or false;

    -- test for uniqueness of the nameplate
    if not Plate_Name_Count[plateName] then
        Plate_Name_Count[plateName] = 1;
    else
        Plate_Name_Count[plateName] = Plate_Name_Count[plateName] + 1;
        if not NP_Is_Not_Unique[plateName] then
            NP_Is_Not_Unique[plateName] = true;
            self:Debug(INFO2, plateName, "is not unique");
        end
    end

    -- Check if this name plate is of interest -- TODO
    if playerNamesToMark[plateName] then
        self:AddMarkerToPlate(plate, plateName, data.GUID);
    end
end

function CM:LNR_ON_RECYCLE_PLATE(selfevent, plate, data)
    local plateName = data.name;


   self:HideMarkerFromPlate(plate, plateName, "LNR_ON_RECYCLE_PLATE");


    -- prevent uniqueness data from stacking
    if Plate_Name_Count[plateName] then

        Plate_Name_Count[plateName] = Plate_Name_Count[plateName] - 1;
        if Plate_Name_Count[plateName] == 0 then
            Plate_Name_Count[plateName] = nil;
        end
    end
end

-- }}}


do
    local Plate;
    local PlateAdditions;
    local PlateName;
    local Guid;

    local assert = _G.assert;
    local unpack = _G.unpack;

    local SetRaidTargetIconTexture = _G.SetRaidTargetIconTexture
    local TargetFrameTextureFrameRaidTargetIcon = _G.TargetFrameTextureFrameRaidTargetIcon

    local function SetTextureParams(t) -- MUL
        local profile = CM.db.global;

        t:SetSize(64 * profile.marker_Scale, 64 * profile.marker_Scale);
        t:SetPoint("BOTTOM", Plate, "TOP", profile.marker_Xoffset, profile.marker_Yoffset);
        t:SetVertexColor(profile.marker_VCr, profile.marker_VCg, profile.marker_VCb, profile.marker_VCa)
    end

    local function AdjustTexCoord(t) -- MUL

        local textureID = CM.db.global.playerNamesToMark[PlateName]

        if PlateAdditions.textureID ~= textureID then
            SetRaidTargetIconTexture (t, textureID)
            PlateAdditions.textureID = textureID;
        end

    end

    local function UpdateTextureParams () -- MUL XXX

        if not PlateAdditions.textureUpdate or PlateAdditions.textureUpdate < LAST_TEXTURE_UPDATE then
            --self:Debug(INFO, 'Updating texture');

            SetTextureParams(PlateAdditions.texture);

            PlateAdditions.textureUpdate = GetTime();
        end

    end

    local function AddElements () -- ONCEx
        local texture  = Plate:CreateTexture();
        texture:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons");
        AdjustTexCoord(texture);
        SetTextureParams(texture);
        
        PlateAdditions.texture = texture;
        PlateAdditions.texture:Show();
        PlateAdditions.IsShown = true; -- set it as soon as we show something
    end

    local function PopulatePlateData(plate) -- set locals Guid
        PlateName       = CM:GetPlateName(plate);
        Guid            = CM:GetPlateGUID(plate);
    end

    function CM:AddMarkerToPlate (plate, plateName, guid) -- {{{

        if not plate then
            self:Debug(ERROR, "AddMarkerToPlate(), plate is not defined");
            return false;
        end

        if not plateName then
            self:Debug(ERROR, "AddMarkerToPlate(), plateName is not defined");
            return false;
        end

        if not self.db.global.playerNamesToMark[plateName] then
            self:Debug(ERROR, "AddMarkerToPlate(), no marker set for", plateName);
            return false;
        end

        -- export useful data
        Guid            = guid or self:GetPlateGUID(plate);
        Plate           = plate;
        PlateName       = plateName;
        PlateAdditions  = plate.HHTD and plate.HHTD.CM;

        if not PlateAdditions then
            plate.HHTD = plate.HHTD or {};
            plate.HHTD.CM = {}

            PlateAdditions = plate.HHTD.CM;

            AddElements();

        elseif not PlateAdditions.IsShown then

            AdjustTexCoord(PlateAdditions.texture);
            UpdateTextureParams();
            PlateAdditions.texture:Show();
            PlateAdditions.IsShown = true;

        elseif guid and NP_Is_Not_Unique[plateName] then
            AdjustTexCoord(PlateAdditions.texture);
            UpdateTextureParams();
        end

        PlateAdditions.plateName = plateName;

        self.DisplayedPlates_byFrameTID[plate] = plate; -- used later to update what was created above

        
    end -- }}}

    function CM:UpdateTextures ()

        LAST_TEXTURE_UPDATE = GetTime();

        for plate in pairs(self.DisplayedPlates_byFrameTID) do

            PlateAdditions  = plate.HHTD and plate.HHTD.CM;
            Plate           = plate;
            PopulatePlateData(plate);

            UpdateTextureParams();

            AdjustTexCoord(PlateAdditions.texture);

        end

       
    end


end


function CM:HideMarkerFromPlate(plate, plateName, caller) -- {{{

    --[===[@alpha@
    if not plate then
        self:Debug(ERROR, "HideMarkerFromPlate(), plate is not defined");
        error("'Plate' is not defined");
        return;
    end
    --@end-alpha@]===]

    local plateAdditions = plate.HHTD and plate.HHTD.CM;

    if plateAdditions and plateAdditions.IsShown then
        plateAdditions.texture:Hide();
        plateAdditions.IsShown = false;
        plateAdditions.plateName = nil;
    end

    self.DisplayedPlates_byFrameTID[plate] = nil;

end -- }}}
