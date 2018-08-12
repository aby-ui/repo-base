--[=[
H.H.T.D. World of Warcraft Add-on
Copyright (c) 2009-2018 by John Wellesz (hhtd@2072productions.com)
All rights reserved

Version 2.4.9

In World of Warcraft healers have to die. This is a cruel truth that you're
taught very early in the game. This add-on helps you influence this unfortunate
destiny in a way or another depending on the healer's side...

More information: https://www.wowace.com/projects/h-h-t-d

type /hhtd to get a list of existing options.

-----
    NamePlateHooker.lua
-----

This component hooks the name plates above characters and adds a sign on top to identifie them as healers


--]=]

--  module framework {{{
local ERROR     = 1;
local WARNING   = 2;
local INFO      = 3;
local INFO2     = 4;


local ADDON_NAME, T = ...;
local HHTD = T.HHTD;
local L = HHTD.Localized_Text;
local HHTD_C = HHTD.Constants;


if not LibStub:GetLibrary("LibNameplateRegistry-1.0", true) then
    T._DiagStatus = 2;
    T._Diagmessage = "The required library LibNameplateRegistry-1.0 could not be loaded.\n\nMake sure HHTD is installed correctly.";
    T._FatalError(T._Diagmessage);
    return;
end

HHTD.Name_Plate_Hooker = HHTD:NewModule("NPH", "LibNameplateRegistry-1.0");

local NPH = HHTD.Name_Plate_Hooker;

NPH:SetDefaultModulePrototype( HHTD.MODULE_PROTOTYPE );
NPH:SetDefaultModuleLibraries( "AceConsole-3.0", "AceEvent-3.0");
NPH:SetDefaultModuleState( false );



local LAST_TEXTURE_UPDATE = 0;
local Marker_Textures = {
    ["default"] = {"Interface\\AddOns\\"..ADDON_NAME.."\\Artwork\\healers_icons.tga", -1, 0},
    ["minimal"] = {"Interface\\AddOns\\"..ADDON_NAME.."\\Artwork\\healers_icons_minimal.tga", -1, -5},
};

-- upvalues {{{
local GetCVarBool           = _G.GetCVarBool;
local GetCVar               = _G.GetCVar;
local GetTime               = _G.GetTime;
local pairs                 = _G.pairs;
local ipairs                = _G.ipairs;
local CreateFrame           = _G.CreateFrame;
local GetTexCoordsForRole   = _G.GetTexCoordsForRole;
-- }}}

function NPH:OnInitialize() -- {{{

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


    self.db = HHTD.db:RegisterNamespace('NPH', {
        global = {
            sPve = true,
            displayHealerRanks = true,
            marker_Scale = 0.8,
            marker_Xoffset = 0,
            marker_Yoffset = 0,
            marker_VCa = 1,
            marker_textureID = "default",
        },
    })
end -- }}}

function NPH:GetOptions () -- {{{
    return {
        [NPH:GetName()] = {
            name = L[NPH:GetName()],
            type = 'group',
            get = function (info) return NPH.db.global[info[#info]]; end,
            set = function (info, value) HHTD:SetHandler(self, info, value) end,
            args = {
                Warning1 = {
                    type = 'description',
                    name = HHTD:ColorText(L["OPT_NPH_WARNING1"], "FFFF0000"),
                    hidden = function () return GetCVarBool("nameplateShowEnemies") end,
                    order = 0,
                },
                Warning2 = {
                    type = 'description',
                    name = HHTD:ColorText(L["OPT_NPH_WARNING2"], "FFFF0000"),
                    hidden = function () return GetCVarBool("nameplateShowFriends") end,
                    order = 1,
                },
                sPve = {
                    type = 'toggle',
                    name = L["OPT_STRICTGUIDPVE"],
                    desc = L["OPT_STRICTGUIDPVE_DESC"],
                    disabled = function() return not HHTD.db.global.Pve or not HHTD:IsEnabled(); end,
                    order = 10,
                },
                displayHealerRanks = {
                    type = 'toggle',
                    name = L["OPT_NPH_DISPLAY_HEALER_RANK"],
                    desc = L["OPT_NPH_DISPLAY_HEALER_RANK_DESC"],
                    set = function (info, value)
                        HHTD:SetHandler(self, info, value);
                        self:UpdateRanks();
                    end,
                    order = 10.1,
                },
                Header50 = {
                    type = 'header',
                    name = L["OPT_NPH_MARKER_WOW_SETTINGS"],
                    order = 13,
                },
                enemyNameplates = {
                    type = 'toggle',
                    name = L["OPT_NPH_ENEMY_NAMEPLATE"],
                    order = 13.1,
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
                    order = 13.2,
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
                        order = 13.3,
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
                        order = 13.4,
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
                        order = 13.4,
                        isPercent = false,
                        width=1.5,

                        set = function (info, value)
                            SetCVar("nameplateMaxDistance", value);
                        end,
                        get = function (info)
                            return tonumber(GetCVar("nameplateMaxDistance"));
                        end,
                    },
                Header100 = {
                    type = 'header',
                    name = L["OPT_NPH_MARKER_SETTINGS"],
                    order = 15,
                },
                marker_textureID = {
                    type = 'select',
                    name = L["OPT_NPH_MARKER_THEME"],
                    desc = L["OPT_NPH_MARKER_THEME_DESC"],
                    values = {["default"] = L["OPT_NPH_MARKER_THEME_DEFAULT"], ["minimal"] = L["OPT_NPH_MARKER_THEME_MINIMAL"]},
                    order = 17,
                    set = function (info, value)
                        HHTD:SetHandler(self, info, value);
                        self:UpdateTextures();
                    end,
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
                marker_VCa = {
                    type = "range",
                    name = L["OPT_CM_VCa"],
                    desc = L["OPT_CM_VCa_DESC"],
                    min = 0,
                    max = 1,
                    step = 0.01,
                    order = 33,

                    set = function (info, value)
                        HHTD:SetHandler(self, info, value);
                        self:UpdateTextures();
                    end,
                },
                swapSymbols = {
                    type = 'toggle',
                    name = L["OPT_SWAPSYMBOLS"],
                    desc = L["OPT_SWAPSYMBOLS_DESC"],
                    width = 'double',
                    order = 35,
                    set = function (info, value)
                        HHTD:SetHandler(self, info, value);
                        NPH:UpdateTextures();
                    end,
                },
            },
        },
    };
end -- }}}

function NPH:OnEnable() -- {{{
    self:Debug(INFO, "OnEnable");

    if T._DiagStatus == 2 then
        self:Disable();
        return;
    end

    -- Subscribe to HHTD's callbacks
    self:RegisterMessage("HHTD_HEALER_BORN");
    self:RegisterMessage("HHTD_HEALER_GROW");
    self:RegisterMessage("HHTD_HEALER_GONE");

    self:RegisterEvent("PLAYER_ENTERING_WORLD");

    -- Subscribe to callbacks
    self:LNR_RegisterCallback("LNR_DEBUG");
    self:LNR_RegisterCallback("LNR_ON_NEW_PLATE");
    self:LNR_RegisterCallback("LNR_ON_RECYCLE_PLATE");
    self:LNR_RegisterCallback("LNR_ON_GUID_FOUND");

    self:LNR_RegisterCallback("LNR_ERROR_FATAL_INCOMPATIBILITY");
    self:LNR_RegisterCallback("LNR_ERROR_GUID_ID_HAMPERED");
    self:LNR_RegisterCallback("LNR_ERROR_SETPARENT_ALERT");
    self:LNR_RegisterCallback("LNR_ERROR_SETSCRIPT_ALERT");


    local plate;
    for i, isFriend in ipairs({true,false}) do
        -- Add nameplates to known healers by GUID
        for healerGUID, healer in pairs(HHTD.Registry_by_GUID[isFriend]) do

            plate = self:GetPlateByGUID(healerGUID);

            if plate then
                self:AddCrossToPlate (plate, isFriend, healer.name, healerGUID, healer);
            end

        end
    end

end -- }}}

function NPH:OnDisable() -- {{{
    self:Debug(INFO2, "OnDisable");

    if T._DiagStatus == 2 then
        self:Print("|cFFD00000"..T._Diagmessage.."|r");
    end

    self:LNR_UnregisterCallback("LNR_ON_NEW_PLATE"); -- remove this one alone so I can see LNR debug callback
    self:LNR_UnregisterAllCallbacks();
    -- clean all nameplates
    for plateTID, plate in pairs(self.DisplayedPlates_byFrameTID) do
        self:HideCrossFromPlate(plate, false, "OnDisable");
    end
end -- }}}
-- }}}



NPH.DisplayedPlates_byFrameTID = {}; -- used for updating plates dipslay attributes

local Plate_Name_Count = { -- array by name so we have to make the difference between friends and foes
};
local NP_Is_Not_Unique = { -- array by name so we have to make the difference between friends and foes
};


function NPH:PLAYER_ENTERING_WORLD() -- {{{
    self:Debug(INFO2, "Cleaning multi instanced healers data");
    Plate_Name_Count = {};
    NP_Is_Not_Unique = {};
end


-- }}}

-- Internal CallBacks (HHTD_HEALER_GONE -- HHTD_HEALER_BORN -- ON_HEALER_PLATE_TOUCH -- HHTD_MOUSE_OVER_OR_TARGET) {{{
function NPH:HHTD_HEALER_GONE(selfevent, isFriend, healer)
    self:Debug(INFO2, "NPH:HHTD_HEALER_GONE", healer.name, healer.guid, isFriend);

    --[=[
    if not isFriend and not GetCVarBool("nameplateShowEnemies") or isFriend and not GetCVarBool("nameplateShowFriends") then
        self:Debug(INFO2, "NPH:HHTD_HEALER_GONE(): bad state, nameplates disabled",  healer.name, healer.guid, isFriend);
        return;
    end
    --]=]

    
    local plateByGuid;
    if self.db.global.sPve then
        plateByGuid = self:GetPlateByGUID(healer.guid);
    end

    for frame, data in self:EachPlateByName(healer.name) do
        local plate = plateByGuid or frame;

        --self:Debug(INFO, "Must drop", healer.name);
        self:HideCrossFromPlate(plate, healer.name, "HHTD_HEALER_GONE");

        if plateByGuid then
            break;
        end
    end
end

function NPH:HHTD_HEALER_GROW (selfevent, isFriend, healer)
    self:Debug(INFO, 'Updating displayed ranks');
    self:UpdateRanks();
end

function NPH:HHTD_HEALER_BORN (selfevent, isFriend, healer)

    --[=[
    if not isFriend and not GetCVarBool("nameplateShowEnemies") or isFriend and not GetCVarBool("nameplateShowFriends") then
        return;
    end
    --]=]


    local plateByGuid;
    if self.db.global.sPve then
        plateByGuid = self:GetPlateByGUID(healer.guid);
    end

    for frame, data in self:EachPlateByName(healer.name) do

        local plate = plateByGuid or frame;

        -- we have have access to the correct plate through the unit's GUID or it's uniquely named.
        if plateByGuid or not self.db.global.sPve then
            self:AddCrossToPlate (plate, isFriend, healer.name, healer.guid, healer);

            self:Debug(INFO, "HHTD_HEALER_BORN(): GUID available or unique", NP_Is_Not_Unique[healer.name]);
        else
            self:Debug(WARNING, "HHTD_HEALER_BORN: multi and sPVE and noguid :'( ", healer.name);
        end

        if plateByGuid then
            break;
        end

    end
end

-- }}}

--[===[@alpha@
local callbacks_consisistency_check = {};    
--@end-alpha@]===]


-- Name Plates CallBacks {{{
function NPH:LNR_ON_NEW_PLATE(selfevent, plate, data)

    local plateName = data.name;
    local isFriend = (data.reaction == "FRIENDLY") and true or false;

    --[===[@alpha@

    if not callbacks_consisistency_check[plate] then
        callbacks_consisistency_check[plate] = 1;
    else
        callbacks_consisistency_check[plate] = callbacks_consisistency_check[plate] + 1;
    end

    if self.DisplayedPlates_byFrameTID[plate] then
        self:Debug(ERROR, 'LNR_ON_NEW_PLATE() called but no recycling occured for plate, ccc:', callbacks_consisistency_check[plate]);
        error('LNR_ON_NEW_PLATE() called but no recycling occured for _FRIENDLY_ plate' .. callbacks_consisistency_check[plate]);
    end
    --@end-alpha@]===]

    --[===[@debug@
    -- self:Debug(INFO2, "new plate LNP:IsTarget()?|cff00ff00", LNP:IsTarget(plate) , "|rname:", plateName, 'isFriend?', isFriend, 'alpha:', plate:GetAlpha(),'plate.alpha:', plate.alpha, "plate.unit.alpha:", plate.unit and plate.unit.alpha or nil);
    --@end-debug@]===]

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

    -- Check if this name plate is of interest -- XXX
    if HHTD.Registry_by_Name[isFriend][plateName] then
       
        if not self.db.global.sPve or HHTD.Registry_by_GUID[isFriend][data.GUID] then
            self:AddCrossToPlate(plate, isFriend, plateName, data.GUID, HHTD.Registry_by_Name[isFriend][plateName]);
        end
        --[===[@alpha@
    else -- it's not a healer
        local plateAdditions = plate.HHTD and plate.HHTD.NPH;

        if plateAdditions and (plateAdditions.IsShown or plateAdditions.texture:IsShown() or plateAdditions.rankFont:IsShown()) then -- check if the plate appeared with our additions shown
            self:Debug(ERROR, "Plate prev-recycling hiding failed: ", plateAdditions.IsShown, plateName, isFriend, data.reaction);
            error("Plate prev-recycling hiding failed: "..tostring(plateAdditions.IsShown).." for " .. plateName .. ' friend:' .. tostring(isFriend) .. '-' .. tostring(data.reaction)); -- seems to trigger when plateadditions are hidden while the plate are being recycled
            -- this means:
            --  New_plate fires before the cross was hidden
            --  New_plate fires before recycle
            --  HideCross fails
        end
        --@end-alpha@]===]
    end
end

function NPH:LNR_ON_RECYCLE_PLATE(selfevent, plate, data)

   --x if LNP.fakePlate[plate] then
        --[===[@debug@
        --self:Debug(INFO2, "LNR_ON_RECYCLE_PLATE(): unused frame received for:", self:GetPlateName(plate));
        --@end-debug@]===]
      --x  return;
    --x end

    local plateName = data.name;


    --[===[@alpha@
    if not callbacks_consisistency_check[plate] then
        callbacks_consisistency_check[plate] = 0;
    else
        callbacks_consisistency_check[plate] = callbacks_consisistency_check[plate] - 1;
    end
    --@end-alpha@]===]

    --[===[@debug@
    -- self:Debug(INFO, "LNR_ON_RECYCLE_PLATE():", plateName);
    --@end-debug@]===]

    -- unfortunately a plate can change of faction without being hidden first (if a unit gets mind controlled)
    -- so we have to check both sides
    self:HideCrossFromPlate(plate, plateName, "LNR_ON_RECYCLE_PLATE");


    -- prevent uniqueness data from stacking
    if Plate_Name_Count[plateName] then

        Plate_Name_Count[plateName] = Plate_Name_Count[plateName] - 1;
        if Plate_Name_Count[plateName] == 0 then
            Plate_Name_Count[plateName] = nil;
        end
    end
end

function NPH:LNR_ON_GUID_FOUND(selfevent, plate, guid)

    local healer = HHTD.Registry_by_GUID[true][guid] or HHTD.Registry_by_GUID[false][guid];

    if healer then
        self:Debug(INFO, "GUID found");
        self:AddCrossToPlate(plate, HHTD.Registry_by_GUID[true][guid] and true or false, self:GetPlateName(plate), guid, healer);
    else
        self:Debug(INFO2, "GUID found but not a healer");
    end

end

function NPH:LNR_ERROR_FATAL_INCOMPATIBILITY(selfevent, incompatibility_type)

    if T._tocversion > HHTD.Constants.MaxTOC then
        self:Print("|cFFFF0000ERROR:|rHHTD is outdated and no longer compatible with this version of WoW, you need to update HHTD from Curse.com. The Nameplate Hooker module is now disabled.", 'Incompatibility type:', incompatibility_type);
    else
        self:Print("|cFFFF0000ERROR:|rNameplates tracking as become unreliable for some strange unknown reason. The Nameplate Hooker module is now disabled.", 'Incompatibility type:', incompatibility_type);
    end

    HHTD:FatalError("The Nameplate Hooker module had to be disabled due to an incompatibility.\nSee the chat window for more details.");

    self:Disable();
end

function NPH:LNR_DEBUG(selfevent, level, nrMinor, ...)
    if not HHTD.db.global.Debug and level ~= ERROR then return end;

    self:Debug(level, "LNR", nrMinor, '.', ...);
end

function NPH:LNR_ERROR_GUID_ID_HAMPERED(selfevent, message)
    self:Print(message);
end

function NPH:LNR_ERROR_SETPARENT_ALERT(selfevent, baddon, message)
    self:Print(message);
end

function NPH:LNR_ERROR_SETSCRIPT_ALERT(selfevent, baddon, proof,  message)
    self:Print(message);
    self:Print(proof);
end

-- }}}


do
    local SmallFontName = _G.NumberFont_Shadow_Small:GetFont();

    local IsFriend;
    local Plate;
    local PlateAdditions;
    local PlateName;
    local Guid;
    local HealerClass;

    local assert = _G.assert;
    local unpack = _G.unpack;

    local function SetTextureParams(plateAdditions) -- MUL
        local profile = NPH.db.global;
        local t, f = PlateAdditions.texture, PlateAdditions.rankFont;

        t:SetTexture(Marker_Textures[profile.marker_textureID][1]);

        t:SetSize(64 * profile.marker_Scale, 64 * profile.marker_Scale);
        t:SetPoint("BOTTOM", Plate, "TOP", profile.marker_Xoffset, profile.marker_Yoffset);
        t:SetAlpha(profile.marker_VCa);
        f:SetAlpha(profile.marker_VCa);
        f:SetPoint("CENTER", t, "CENTER", -Marker_Textures[profile.marker_textureID][2] * profile.marker_Scale, -Marker_Textures[profile.marker_textureID][3] * profile.marker_Scale);
    end

    local function getIconCoords (x, y)
        local b = 1/256;
        return {b * x * 64, b * (x * 64 + 64), b * y * 64, b * (y * 64 + 64)};
    end

    local ICONS_COORDS = {
        [true] = {
            [false]     = getIconCoords(0,0), --0,0
            ["DRUID"]   = getIconCoords(1,0), --1,0
            ["MONK"]    = getIconCoords(2,0), --2,0
            ["PALADIN"] = getIconCoords(3,0), --3,0
            ["PRIEST"]  = getIconCoords(0,1), --0,1
            ["SHAMAN"]  = getIconCoords(1,1), --1,1
        },
        [false] = {
            [false]     = getIconCoords(2,1), --2,1
            ["DRUID"]   = getIconCoords(3,1), --3,1
            ["MONK"]    = getIconCoords(0,2), --0,2
            ["PALADIN"] = getIconCoords(1,2), --1,2
            ["PRIEST"]  = getIconCoords(2,2), --2,2
            ["SHAMAN"]  = getIconCoords(3,2), --3,2
        }
    };

    local function AdjustTexCoord(t) -- MUL

        local textureID

        if not NPH.db.global.swapSymbols then
            textureID = ICONS_COORDS[IsFriend][HealerClass];
        else
            textureID = ICONS_COORDS[not IsFriend][HealerClass];
        end

        if PlateAdditions.textureID ~= textureID then
            t:SetTexCoord(unpack(textureID));
            PlateAdditions.textureID = textureID;
        end

    end

    local function MakeFontString() -- ONCE
        local f = Plate:CreateFontString();
        f:SetFont(SmallFontName, 12.2, "THICKOUTLINE, MONOCHROME");
        
        f:SetTextColor(1, 1, 1, 1);
        
        return f;
    end

    local function SetRank ()  -- ONCE
        --[===[@alpha@
        assert(PlateAdditions, 'PlateAdditions is not defined'); -- to diagnose issue repoted on 2012-09-07
        assert(PlateAdditions.rankFont, "rankFont is invalid"); -- to diagnose issue repoted on 2012-09-07
        assert(PlateAdditions.rankFont.SetText, "rankFont.SetText is invalid"); -- to diagnose issue repoted on 2012-10-17
        assert(IsFriend == true or IsFriend == false, "IsFriend is invalid"); -- to diagnose issue repoted on 2012-09-07
        --@end-alpha@]===]

        if NPH.db.global.displayHealerRanks then
            if not Guid then

                if not HHTD.Registry_by_Name[IsFriend][PlateName] then
                    NPH:Debug(ERROR, "HHTD.Registry_by_Name[IsFriend][PlateName] is invalid for plate:", PlateName, "isfriend:", IsFriend, "PlateAdditions.plateName:", PlateAdditions.plateName);
                end
                PlateAdditions.rankFont:SetText(NP_Is_Not_Unique[PlateName] and '?' or HHTD.Registry_by_Name[IsFriend][PlateName].rank);
            else
                if not HHTD.Registry_by_GUID[IsFriend][Guid] then
                    NPH:Debug(ERROR, "HHTD.Registry_by_GUID[IsFriend][Guid] is not defined for plate:", PlateName, "isfriend:", IsFriend, "Found with Name:", HHTD.Registry_by_Name[IsFriend][PlateName] and true or false);
                end
                PlateAdditions.rankFont:SetText(HHTD.Registry_by_GUID[IsFriend][Guid].rank);
            end

            PlateAdditions.rankFont:Show();
        else
            PlateAdditions.rankFont:Hide();
        end
    end

    local function UpdateTextureParams () -- MUL XXX

        if not PlateAdditions.textureUpdate or PlateAdditions.textureUpdate < LAST_TEXTURE_UPDATE then
            --self:Debug(INFO, 'Updating texture');

            SetTextureParams(PlateAdditions);

            PlateAdditions.textureUpdate = GetTime();
        end

    end

    local function AddElements () -- ONCEx
        
        PlateAdditions.texture, PlateAdditions.rankFont = Plate:CreateTexture(), MakeFontString();

        SetTextureParams(PlateAdditions);

        PlateAdditions.texture:Show();
        PlateAdditions.IsShown = true; -- set it as soon as we show something

        SetRank();
    end

    local function PopulatePlateData(plate) -- set locals Guid, IsFriend, HealerClass

        PlateName       = NPH:GetPlateName(plate);
        Guid            = NPH:GetPlateGUID(plate);
        Guid            = (HHTD.Registry_by_GUID[true][Guid] or HHTD.Registry_by_GUID[false][Guid]) and Guid or nil;

        if Guid then
            IsFriend    = HHTD.Registry_by_GUID[true][Guid] and true or false;
            HealerClass = HHTD.Registry_by_GUID[IsFriend][Guid].isTrueHeal;
        else
            IsFriend    = HHTD.Registry_by_Name[true][PlateName] and true or false;
            HealerClass = HHTD.Registry_by_Name[IsFriend][PlateName].isTrueHeal;
        end
    end

    function NPH:AddCrossToPlate (plate, isFriend, plateName, guid, healer) -- {{{

        if not plate then
            self:Debug(ERROR, "AddCrossToPlate(), plate is not defined");
            return false;
        end

        if not plateName then
            self:Debug(ERROR, "AddCrossToPlate(), plateName is not defined");
            return false;
        end

        if isFriend==nil then
            isFriend = (self:GetPlateReaction(plate) == "FRIENDLY") and true or false;
            self:Debug(ERROR, "AddCrossToPlate(), isFriend was not defined", isFriend);
        end

        if guid == HHTD_C.PLAYER_GUID then
            self:Debug(INFO2, "AddCrossToPlate(), it's the player, not showing the symbol!");
            return false;
        end

        --[===[@alpha@
        if plateName ~= self:GetPlateName(plate) then
            self:Debug(ERROR, 'AddCrossToPlate(): plateName ~= :GetPlateName(plate):', plateName, '-_-', self:GetPlateName(plate));
            error('AddCrossToPlate(): plateName ~= :GetPlateName(plate)');
        end
        --@end-alpha@]===]

        -- export useful data
        IsFriend        = isFriend;
        Guid            = guid or self:GetPlateGUID(plate);
        Guid            = HHTD.Registry_by_GUID[IsFriend][Guid] and Guid or nil; -- make sure the Guid is actually usable.
        Plate           = plate;
        PlateName       = plateName;
        PlateAdditions  = plate.HHTD and plate.HHTD.NPH;
        HealerClass     = healer.isTrueHeal;

        if not PlateAdditions then
            plate.HHTD = plate.HHTD or {};
            plate.HHTD.NPH = {}

            PlateAdditions = plate.HHTD.NPH;

            AddElements();
            AdjustTexCoord(PlateAdditions.texture);

        elseif not PlateAdditions.IsShown then

            AdjustTexCoord(PlateAdditions.texture);
            UpdateTextureParams();
            PlateAdditions.texture:Show();
            PlateAdditions.IsShown = true;

            SetRank();

        elseif guid and NP_Is_Not_Unique[plateName] then
            AdjustTexCoord(PlateAdditions.texture);
            UpdateTextureParams();
            SetRank();
        end

        PlateAdditions.plateName = plateName;

        self.DisplayedPlates_byFrameTID[plate] = plate; -- used later to update what was created above

        --[===[@alpha@
        -- IsFriend        = nil;
        -- Guid            = nil;
        -- Plate           = nil;
        -- PlateName       = nil;
        -- PlateAdditions  = nil;
        -- HealerClass     = nil;
        --@end-alpha@]===]

    end -- }}}

    function NPH:UpdateTextures ()

        LAST_TEXTURE_UPDATE = GetTime();

        for plate in pairs(self.DisplayedPlates_byFrameTID) do

            PlateAdditions  = plate.HHTD and plate.HHTD.NPH;
            Plate           = plate;
            PopulatePlateData(plate);

            UpdateTextureParams();

            AdjustTexCoord(PlateAdditions.texture);

        end

        --[===[@alpha@
        PlateAdditions  = nil;
        PlateName       = nil;
        --@end-alpha@]===]
    end

    function NPH:UpdateRanks ()

        for plate in pairs(self.DisplayedPlates_byFrameTID) do

            Plate           = plate;
            PlateAdditions  = plate.HHTD and plate.HHTD.NPH;
            
            PopulatePlateData(plate);
            SetRank();

            AdjustTexCoord(PlateAdditions.texture);
        end

        --[===[@alpha@
        IsFriend        = nil;
        Plate           = nil;
        PlateName       = nil;
        PlateAdditions  = nil;
        HealerClass     = nil;
        --@end-alpha@]===]
    end

end

function NPH:HideCrossFromPlate(plate, plateName, caller) -- {{{

    --[===[@alpha@
    if not plate then
        self:Debug(ERROR, "HideCrossFromPlate(), plate is not defined");
        error("'Plate' is not defined");
        return;
    end
    --@end-alpha@]===]

    local plateAdditions = plate.HHTD and plate.HHTD.NPH;

    --[===[@alpha@
    local testCase1 = false;
    --@end-alpha@]===]

    if plateAdditions and plateAdditions.IsShown then

        --[===[@alpha@
        if plateName and plateName ~= plateAdditions.plateName then
            testCase1 = true;
        end
        --@end-alpha@]===]

        plateAdditions.texture:Hide();
        plateAdditions.rankFont:Hide();
        plateAdditions.IsShown = false;

        plateAdditions.plateName = nil;
        -- self:Debug(INFO2, isFriend and "|cff00ff00Friendly|r" or "|cffff0000Enemy|r", "cross hidden for", plateName);
    end

    self.DisplayedPlates_byFrameTID[plate] = nil;

    --[===[@alpha@
    if testCase1 then
        self:Debug(ERROR, "plateAdditions.plateName ~= plateName:", plateAdditions.plateName, "-__-",  plateName, 'CALLER:', caller);
        --error("plateAdditions.plateName ~= plateName, caller:" .. caller);
    end
    --@end-alpha@]===]

end -- }}}

