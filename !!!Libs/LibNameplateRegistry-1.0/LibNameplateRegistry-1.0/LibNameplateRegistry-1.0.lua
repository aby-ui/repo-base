--[[
        LibNameplateRegistry-1.0

        An embeddable library providing an abstraction layer for tracking and
        querying Blizzard's Nameplate frames with ease and efficiency.

        Copyright (c) 2013-2019 by John Wellesz (LibNameplateRegistry@2072productions.com)
        
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser Public License for more details.

    You should have received a copy of the GNU Lesser Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

This file was last updated on 2019-09-02T13:51:45Z by Archarodim

--]]



--========= coding NAMING Convention ==========
--      VARIABLES AND FUNCTIONS (upvalues excluded)
-- Constants                      == NAME_WORD2 (full upper-case)
-- locals to closures or members  == NameWord2
-- locals to functions            == nameWord2
--
--      TABLES
--  Closure or file locals        == Name_Word2
--  locals                        == name_word2
--  members                       == Name_Word2

--
-- TODO:
-- - Add args error checking on public API (at least in debug mode?)
-- - Add a :GetPlateClass() method
--

-- Library framework {{{
local MAJOR, MINOR = "LibNameplateRegistry-1.0", 19

-- used to be set using debug packager tags but they've been broken ever since the new wowace.com...
-- see: https://www.curseforge.com/forums/wow-sites/wow-sites-feedback/185461-curse-keyword-substitution-not-applied-for
local DEBUG = false;

if not LibStub then
    error(MAJOR .. " requires LibStub");
    return
end

if not LibStub("CallbackHandler-1.0") then
    error(MAJOR .. " requires CallbackHandler-1.0");
    return;
end

if not C_Timer then
    error(MAJOR .. "." .. MINOR .. " requires WoW 7.0 (C_Timer missing)");
    return;
end

local _, oldMinor =  LibStub:GetLibrary(MAJOR, true);

-- I do not want to expose the library internals to the outside world in order
-- to limit Murphy's law influence. This is unusual for a WoW library but still, it's worth trying.

local LNR_Private; -- holder for all our private workset

if oldMinor and oldMinor < MINOR then
    LNR_Private = LibStub(MAJOR):Quit("newer version loaded"); -- ask the older library to destroy itself properly clearing all its local caches.
    if not LNR_Private.UpgradeHistory then
        LNR_Private.UpgradeHistory = "";
    end
    LNR_Private.UpgradeHistory = LNR_Private.UpgradeHistory .. oldMinor .. "-";
end

LNR_Private = LNR_Private or {};

local LNR_Public, oldMinor = LibStub:NewLibrary(MAJOR, MINOR)
if not LNR_Public then return end -- no upgrade required

local LNR_ENABLED = false; -- must stay local to the file, it was used to disable hooked Scripts which couldn't be removed

LNR_Private.callbacks = LNR_Private.callbacks or LibStub("CallbackHandler-1.0"):New(LNR_Private);
LNR_Private.Fire      = LNR_Private.callbacks.Fire;


-- Manage embedding
LNR_Private.mixinTargets = LNR_Private.mixinTargets or {};

local Mixins = {"GetPlateName", "GetPlateReaction", "GetPlateType", "GetPlateGUID", "GetPlateByGUID", "GetPlateRegion", "EachPlateByName", "LNR_RegisterCallback", "LNR_UnregisterCallback", "LNR_UnregisterAllCallbacks" };

function LNR_Public:Embed(target)

    for _,name in pairs(Mixins) do
        target[name] = LNR_Public[name];
    end

    LNR_Private.mixinTargets[target] = true;

end

local function Debug(level, ...)
    LNR_Private:Fire("LNR_DEBUG", level, MINOR, ...);
end



--}}}

-- Lua and Blizzard upvalues {{{
local _G                    = _G;
local pairs                 = _G.pairs;
local select                = _G.select;
local setmetatable          = _G.setmetatable;
local twipe                 = _G.table.wipe;
local GetMouseFocus         = _G.GetMouseFocus;
local UnitExists            = _G.UnitExists;
local UnitGUID              = _G.UnitGUID;
local UnitName              = _G.UnitName;
local UnitIsUnit            = _G.UnitIsUnit;
local UnitSelectionColor    = _G.UnitSelectionColor;
local UnitReaction          = _G.UnitReaction;
local UnitPlayerControlled  = _G.UnitPlayerControlled;
local InCombatLockdown      = _G.InCombatLockdown;

local WorldFrame            = _G.WorldFrame;
local C_Timer               = _G.C_Timer;

local GetNamePlateForUnit   = _G.C_NamePlate.GetNamePlateForUnit
local GetNamePlateSizes     = _G.C_NamePlate.GetNamePlateSizes
local GetNamePlates         = _G.C_NamePlate.GetNamePlates
--local GetNumNamePlateMotionTypes = C_NamePlate.GetNumNamePlateMotionTypes
--local SetNamePlateSizes          = C_NamePlate.SetNamePlateSizes

--[===[@debug@
local tostring              = _G.tostring;
local assert                = _G.assert;
local unpack                = _G.unpack;
--@end-debug@]===]
-- }}}

-- CONSTANTS and library local variables {{{

-- Debug templates

local ERROR     = 1; -- if HHTD and Decursive are loaded thses will be reported through Decursive's report functionality
local WARNING   = 2;
local INFO      = 3;
local INFO2     = 4;



-- State variable that we keep local, when upgrading we restart from scratch
local PlateRegistry_per_frame   =  {};
local ActivePlates_per_frame    =  {};
local ActivePlateFrames_per_unitToken =  {};
local CurrentTarget             = false;
local HasTarget                 = false;

--[===[@debug@
local callbacks_consisistency_check = {};
--@end-debug@]===]
--}}}

-- Clever cache tables: Frame_Children_Cache, Frame_Regions_Cache, Plate_Parts_Cache {{{

-- Various cache tables (WARNING: those shall be destroyed upon upgrading using :Quit())



local Frame_Children_Cache = setmetatable({}, {__index =
-- frame cache
function(t, frame)

    t[frame] = setmetatable({}, {__index =
            -- children per number cache
            function(t, childNum)

                t[childNum] = (select(childNum, frame:GetChildren())) or false;

                if not t[childNum] then
                    t[childNum] = nil;
                    error("CFCache: Child" .. childNum .. " not found.");
                end

                --[===[@debug@
                Debug(INFO, 'cached a new frame child', childNum);
                --@end-debug@]===]
                return  t[childNum];

            end
        })

    return t[frame];
end

});

local Frame_Regions_Cache = setmetatable({}, {__index =
-- frame cache
function(t, frame)
    -- region cache
    t[frame] = setmetatable({}, {__index =
            -- children per number cache
            function(t, regionNum)

                t[regionNum] = (select(regionNum, frame:GetRegions())) or false;

                if not t[regionNum] then
                    t[regionNum] = nil;
                    --[===[@debug@
                    Debug(ERROR, 'CFCache', regionNum, 'not found, regions:', frame:GetName() );
                    --@end-debug@]===]
                    error( "CFCache: Region" .. regionNum .. " not found.");
                end

                --[===[@debug@
                Debug(INFO, 'cached a new frame region', regionNum);
                --@end-debug@]===]
                return t[regionNum];

            end
        })
        return t[frame];
    end
});


-- we could fuse Frame_Regions_Cache and Frame_Children_Cache into this one but
-- it's best to keep the three of them for better clarity
local Plate_Parts_Cache = setmetatable ({}, {__index =

function (t, plateFrame)
    t[plateFrame] = setmetatable({}, {__index =
        function (t, regionName)
            if regionName == 'name' then
                t[regionName] =  Frame_Children_Cache[plateFrame][1].name;
            elseif regionName == 'statusBar' then
                t[regionName] =  Frame_Children_Cache[plateFrame][1].healthBar;
            elseif regionName == 'raidIcon' then
                t[regionName] =  Frame_Children_Cache[plateFrame][1].RaidTargetFrame;
            else
                return false;
            end
            --[===[@debug@
            if DEBUG then
                Debug(INFO, 'cached a new plateFrame part:', regionName, 'unit name is:', Frame_Children_Cache[plateFrame][1].name:GetText());
            end
            --@end-debug@]===]
            return t[regionName];
        end
    })
    return t[plateFrame];
end
})

-- }}}

-- Internal helper private methods {{{

function LNR_Private:GetUnitTokenFromPlate (frame)

    if not ActivePlates_per_frame[frame] then
        error('tried to get unit token on inactive namePlate');
    end

    local unitToken = ActivePlates_per_frame[frame].unitToken;

    if not unitToken then
        error(".UnitFrame.unit empty");
    end

    --[===[@debug@
    if DEBUG then
        if frame ~= GetNamePlateForUnit(unitToken) then
            Debug(ERROR, 'INCONSISTENCY detected in .unitToken metadata');
        end
    end
    --@end-debug@]===]

    return unitToken;
end

-- This method shall never be made public for it must be used in a particular
-- way to be reliable. To find if a nameplate is targeted the user needs to use
-- the callback LNR_ON_TARGET_PLATE_ON_SCREEN
function LNR_Private:IsPlateTargeted (frame)
    if not HasTarget then
        return false;
    end

    if CurrentTarget == frame then -- we already told you
        --[===[@debug@
        Debug(WARNING, 'CurrentTarget == frame');
        --@end-debug@]===]
        return true;
    elseif CurrentTarget then -- we know it's not that one
        return false;
    end

    if not ActivePlates_per_frame[frame] then -- it's not even on the screen...
        return false;
    end

    if UnitIsUnit(ActivePlates_per_frame[frame].unitToken, 'target') then
        CurrentTarget = frame;
        --[===[@debug@
        Debug(WARNING, 'had to redefined CurrentTarget');
        --@end-debug@]===]
        return true;
    else
        CurrentTarget = false;
        return false;
    end

end

do
    -- Create a pattern to remove cross realm label added to the end of plate
    -- names the number of spaces added before (*) seems to vary depending on
    -- outside temperature...
    local FSPAT = "%s*"..((_G.FOREIGN_SERVER_LABEL:gsub("^%s", "")):gsub("[%*()]", "%%%1")).."$"

    function LNR_Private.RawGetPlateName (frame)
        local name = Plate_Parts_Cache[frame].name:GetText()
        if name then
            return (name:gsub(FSPAT,""));
        else
            Debug(WARNING, 'RawGetPlateName(): nil name for', frame:GetName());
            return 'nilName'..frame:GetName();
        end
    end
end


function LNR_Private.RawGetPlateType (frame)

    local unitToken = LNR_Private:GetUnitTokenFromPlate(frame);

    local reaction = UnitReaction('player', unitToken);

    if reaction > 4 then
        reaction = 'FRIENDLY';
    elseif reaction > 2 then
        reaction = 'NEUTRAL';
    else
        reaction = 'HOSTILE';
    end

    --TODO check if tapped state is still detectable in some ways (API removed in 7.0.3)
    local unitType = UnitPlayerControlled(LNR_Private:GetUnitTokenFromPlate(frame)) and 'PLAYER' or 'NPC';


    return reaction, unitType;
end


do

    local PlateData;

    local function IsGUIDValid (plateFrame)
        if ActivePlates_per_frame[plateFrame].GUID and ActivePlates_per_frame[plateFrame].name == (UnitName(LNR_Private:GetUnitTokenFromPlate(plateFrame))) then
            return ActivePlates_per_frame[plateFrame].GUID;
        else
            ActivePlates_per_frame[plateFrame].GUID = false;
            return false;
        end
    end

    local Getters = {
        ['name'] =  function (plateFrame) return (UnitName(LNR_Private:GetUnitTokenFromPlate(plateFrame))) end,
        ['reaction'] = LNR_Private.RawGetPlateType, -- 1st
        ['type'] = function (plateFrame) return select(2, LNR_Private.RawGetPlateType(plateFrame)); end, -- 2nd
        ['GUID'] = IsGUIDValid,
    };
    function LNR_Private:ValidateCache (plateFrame, entry)
        PlateData = ActivePlates_per_frame[plateFrame];

        if not PlateData then
            return -1;
        end

        if not PlateData[entry] then
            return -2;
        end

        if PlateData[entry] == (Getters[entry](plateFrame)) then
            return 0;
        else
            Debug(WARNING, 'Cache validation failed for entry', entry, 'on plate named', PlateData.name, PlateData[entry], 'V/S', (Getters[entry](plateFrame)));
            return 1;
        end
    end
end

-- }}}


-- Diagnostics related methods {{{

--[===[@debug@
do
    local ShownPlateCount = 0;
    function LNR_Private:DebugTests()

        local count = 0; local names = {};
        for frame in pairs(ActivePlates_per_frame) do
            count = count + 1;
        end

        if count ~= ShownPlateCount then
            ShownPlateCount = count;
            Debug(INFO2, ShownPlateCount, 'plates are shown:', unpack(names));
        end
    end
end
--@end-debug@]===]

-- }}}

-- Event handlers : NAME_PLATE_UNIT_ADDED, NAME_PLATE_UNIT_REMOVED, PLAYER_TARGET_CHANGED, UPDATE_MOUSEOVER_UNIT, PLAYER_REGEN_ENABLED {{{

do
    local namePlateFrameBase, PlateData, PlateName, PlateUnitID;

    --[=[
    function LNR_Private:NAME_PLATE_CREATED(selfEvent, namePlateFrameBase)
        -- This event is unreliable as it may fire before the library is loaded...

        -- Debug(INFO, 'NAME_PLATE_CREATED', 'frameName:', namePlateFrameBase:GetName());
    end
    --]=]

    local Insane = false;

    local dataMeta = {__index =
        function (t, k)
            -- because UnitName() can return Unknwon right after a player logs in...
            if k == 'name' then
                t[k] = (UnitName(t.unitToken)) or false;

                if not t[k] or t[k] == 'Unknown' then
                    t[k] = nil;
                    return 'Unknown';
                end

                return t[k];
            else
                -- only the name key is handled
                return nil;
            end
        end
    };

    function LNR_Private:NAME_PLATE_UNIT_ADDED(selfEvent, namePlateUnitToken)
        namePlateFrameBase = GetNamePlateForUnit(namePlateUnitToken);
        ActivePlateFrames_per_unitToken[namePlateUnitToken] = namePlateFrameBase;

        if not PlateRegistry_per_frame[namePlateFrameBase] then
            PlateRegistry_per_frame[namePlateFrameBase] = setmetatable({}, dataMeta);
        end

        --Debug(INFO, 'NAME_PLATE_UNIT_ADDED', 'unitToken:', namePlateUnitToken, 'frameName:', namePlateFrameBase:GetName());

        Insane = false;
        if ActivePlates_per_frame[namePlateFrameBase] then -- test REMOVED tracking
            Insane = true;
        end

        --[===[@debug@
        if DEBUG then
            if not callbacks_consisistency_check[namePlateFrameBase] then
                callbacks_consisistency_check[namePlateFrameBase] = 1;
            else
                callbacks_consisistency_check[namePlateFrameBase] = callbacks_consisistency_check[namePlateFrameBase] + 1;
            end

            if callbacks_consisistency_check[namePlateFrameBase] ~= 1 then
                Debug(ERROR, 'PlateADDED/REMOVED sync broken:', callbacks_consisistency_check[namePlateFrameBase]);
            end
        end
        --@end-debug@]===]


        PlateData = PlateRegistry_per_frame[namePlateFrameBase];
        ActivePlates_per_frame[namePlateFrameBase] = PlateData;
        
        PlateData.unitToken = namePlateUnitToken;
        PlateData.name      = UnitName(namePlateUnitToken);
        -- if UnitName fails, store nothing and let the metaTable retry the query later
        if PlateData.name == 'Unknown' then PlateData.name = nil end
        PlateData.reaction, PlateData.type = LNR_Private.RawGetPlateType(namePlateFrameBase);
        PlateData.GUID      = UnitGUID(namePlateUnitToken);

        if not PlateData.GUID then
            Debug(WARNING, 'GUID unavailable on newly shown plate for unit', PlateData.unitToken);
        end

        LNR_Private:Fire("LNR_ON_NEW_PLATE", namePlateFrameBase, PlateData);

        -- is it currently targeted?
        if UnitExists('target') and UnitIsUnit('target', namePlateUnitToken) then
            if CurrentTarget and CurrentTarget ~= namePlateFrameBase then
                Debug(ERROR, 'target tracking inconsistency');
                self:PLAYER_TARGET_CHANGED();
            end

            CurrentTarget = namePlateFrameBase
            self:Fire("LNR_ON_TARGET_PLATE_ON_SCREEN", namePlateFrameBase, PlateData);
        end

        --[===[@debug@
        --Debug(INFO, "Nameplate on screen:", PlateData.unitToken, PlateData.name, PlateData.reaction, PlateData.GUID);
        --@end-debug@]===]

        if Insane then
            Debug(ERROR, "REMOVED event missed");
            error(('REMOVED event never fired for nameplateFrame %s (%s)'):format(tostring(namePlateFrameBase:GetName()), tostring(LNR_Private.RawGetPlateName(namePlateFrameBase))));
        end
    end

    function LNR_Private:NAME_PLATE_UNIT_REMOVED(selfEvent, namePlateUnitToken)
        namePlateFrameBase = ActivePlateFrames_per_unitToken[namePlateUnitToken];

        if not ActivePlates_per_frame[namePlateFrameBase] then
            Debug(ERROR, "ADDED missed", namePlateUnitToken);
            LNR_Private:FatalIncompatibilityError('Tracking: ADDED missed');
            return;
        end

        --[===[@debug@
        if DEBUG then
            if not namePlateFrameBase:IsVisible() then
                Debug(ERROR, 'nameplate was already hidden on NAME_PLATE_UNIT_REMOVED', namePlateUnitToken, namePlateFrameBase:GetName());
                -- observeed to happen several times on 2016-08-14
            end
        end

        --Debug(INFO2, 'NAME_PLATE_UNIT_REMOVED', 'unitToken:', namePlateUnitToken, 'is visible?', namePlateFrameBase:IsVisible());
        --@end-debug@]===]

        --[===[@debug@
        if DEBUG then
            if not callbacks_consisistency_check[namePlateFrameBase] then
                callbacks_consisistency_check[namePlateFrameBase] = 0;
            else
                callbacks_consisistency_check[namePlateFrameBase] = callbacks_consisistency_check[namePlateFrameBase] - 1;
            end
        end
        --@end-debug@]===]

        PlateData = PlateRegistry_per_frame[namePlateFrameBase];

        LNR_Private:Fire("LNR_ON_RECYCLE_PLATE", namePlateFrameBase, PlateData);

        -- we keep the data available until after the event is fired
        PlateData.name      = false;
        PlateData.unitToken = false;
        PlateData.reaction, PlateData.type = false, false;
        PlateData.GUID      = false;

        -- clear current target knowledge
        if namePlateFrameBase == CurrentTarget then
            CurrentTarget = false;
            Debug(INFO2, 'Current Target\'s plate was hidden');
        end

        -- free active plate status
        ActivePlates_per_frame[namePlateFrameBase] = nil;
        ActivePlateFrames_per_unitToken[namePlateUnitToken] = nil;
    end
end

function LNR_Private:PLAYER_REGEN_ENABLED()
    self.EventFrame:UnregisterEvent('PLAYER_REGEN_ENABLED');
    self:Enable();
end


function LNR_Private:PLAYER_TARGET_CHANGED()

    Debug(INFO, 'Target Changed');

    if UnitExists('target') then
        HasTarget = true;
        -- Have we already cached that unit's GUID?
        CurrentTarget = GetNamePlateForUnit('target');

        if CurrentTarget then
            self:Fire("LNR_ON_TARGET_PLATE_ON_SCREEN", CurrentTarget, ActivePlates_per_frame[CurrentTarget]);
        end
    else
        CurrentTarget = false; -- we don't know any more
        HasTarget = false;
    end

end

local HighlightFailsReported = false;
function LNR_Private:UPDATE_MOUSEOVER_UNIT()

    local unitName = "";
    local mouseoverNameplate, data;
    if GetMouseFocus() == WorldFrame then -- the cursor is either on a name plate or on a 3d model (ie: not on a unit-frame)

        if UnitExists("mouseover") then
            mouseoverNameplate = GetNamePlateForUnit("mouseover");

            if not mouseoverNameplate then
                return;
            end

            --[===[@debug@
            if DEBUG then
                Debug(INFO, "UPDATE_MOUSEOVER_UNIT", UnitReaction('mouseover', 'player'), UnitPlayerControlled('mouseover'), '*' ,LNR_Private.RawGetPlateType(mouseoverNameplate));
            end
            --@end-debug@]===]

            data = ActivePlates_per_frame[mouseoverNameplate]

            if data and not data.GUID then -- not sure if still useful...
                data.GUID = UnitGUID('mouseover');
                unitName = UnitName('mouseover');

                if unitName == data.name and self:ValidateCache(mouseoverNameplate, 'name') == 0 then
                    self:Fire("LNR_ON_GUID_FOUND", mouseoverNameplate, data.GUID, 'mouseover');
                    --[===[@debug@
                    Debug(ERROR, 'Guid found for', data.name, 'mouseover'); -- should not happen in WoW 7
                    --@end-debug@]===]
                else
                    Debug(HighlightFailsReported and INFO2 or WARNING, 'bad cache on mouseover check:', "'"..unitName.."'", "V/S:", "'"..data.name.."'", 'mouseover', unitName == data.name, self:ValidateCache(mouseoverNameplate, 'name'));
                end
            elseif not data then
                Debug(WARNING, 'frame reference not found in active plates:', mouseoverNameplate);
            end

        end
    end
end

-- }}}

-- public methods: :GetPlateName(), :GetPlateReaction(), :GetPlateType(), :GetPlateGUID(), :GetPlateByGUID(), :GetPlateRegion(), :EachPlateByName() {{{

--- ==LibNameplateRegistry-1.0 public API documentation\\\\
-- Check the [[http://www.wowace.com/addons/libnameplateregistry-1-0/pages/callbacks/|Callbacks' page]] if you want details about those.\\\\
--
-- Here is a fully working little add-on as an example displaying nameplates' information as they become available.\\
-- You can download a ready to go archive of this example add-on [[http://www.j2072.teaser-hosting.com/dropbox/example.rar|here]]\\\\
--
-- For a more advanced usage example you can take a look at the [[http://www.wowace.com/addons/healers-have-to-die/files/|latest version of Healers Have To Die]].\\
--
-- @usage
-- local ADDON_NAME, T = ...;
-- 
-- -- Create a new Add-on object using AceAddon
-- T.Example = LibStub("AceAddon-3.0"):NewAddon("Example", "LibNameplateRegistry-1.0");
--
-- -- You could also use LibNameplateRegistry-1.0 directly:
-- T.Example2 = {};
-- LibStub("LibNameplateRegistry-1.0"):Embed(T.Example2); -- embedding is optional of course but way more convenient
--
--
-- local Example = T.Example;
-- 
-- function Example:OnEnable()
--     -- Subscribe to callbacks
--     self:LNR_RegisterCallback("LNR_ON_NEW_PLATE"); -- registering this event will enable the library else it'll remain idle
--     self:LNR_RegisterCallback("LNR_ON_RECYCLE_PLATE");
--     self:LNR_RegisterCallback("LNR_ON_GUID_FOUND");
--     self:LNR_RegisterCallback("LNR_ERROR_FATAL_INCOMPATIBILITY");
-- end
-- 
-- function Example:OnDisable()
--     -- unregister all LibNameplateRegistry callbacks, which will disable it if
--     -- your add-on was the only one to use it
--     self:LNR_UnregisterAllCallbacks();
-- end
-- 
-- 
-- function Example:LNR_ON_NEW_PLATE(eventname, plateFrame, plateData)
--     print(ADDON_NAME, ":", plateData.name, "'s nameplate appeared!");
--     print(ADDON_NAME, ":", "It's a", plateData.type, "and", plateData.reaction,
--           plateData.GUID and ("we know its GUID: " .. plateData.GUID) or "GUID not yet known");
-- end
-- 
-- 
-- function Example:LNR_ON_RECYCLE_PLATE(eventname, plateFrame, plateData)
--     print(ADDON_NAME, ":", plateData.name, "'s nameplate disappeared!");
-- end
-- 
-- 
-- function Example:LNR_ON_GUID_FOUND(eventname, frame, GUID, findmethod)
--     -- This is now rarely useful since WoW 7 since GUIDs are linked directly on nameplate appearance.
--     -- Sometimes though some data about a unit may not be available right away due to heavy lag.
--     print(ADDON_NAME, ":", "GUID found using", findmethod, "for", self:GetPlateName(frame), "'s nameplate:", GUID);
-- end
-- 
-- 
-- function Example:LNR_ERROR_FATAL_INCOMPATIBILITY(eventname, icompatibilityType)
--     -- Here you want to check if your add-on and LibNameplateRegistry are not
--     -- outdated (old TOC) and display a nice error message to your user.
-- end
-- 
--
-- @class file
-- @name LibNameplateRegistry-1.0.lua


--- Returns a nameplate's unit's name (removing the " (*)" suffix if present)
-- @name //addon//:GetPlateName
-- @param plateFrame the platename's root frame
-- @return The name of the unit as displayed on the nameplate or nil
function LNR_Public:GetPlateName(plateFrame)
    return ActivePlates_per_frame[plateFrame] and ActivePlates_per_frame[plateFrame].name or nil;
end

--- Gets a nameplate's unit's reaction toward the player
-- @name //addon//:GetPlateReaction
-- @param plateFrame the platename's root frame
-- @return either "FRIENDLY", "NEUTRAL", "HOSTILE", "TAPPED" or nil
function LNR_Public:GetPlateReaction (plateFrame)
    return ActivePlates_per_frame[plateFrame] and ActivePlates_per_frame[plateFrame].reaction or nil;
end

--- Gets a nameplate's unit's type
-- @name //addon//:GetPlateType
-- @param plateFrame the platename's root frame
-- @return either "NPC", "PLAYER" or nil
function LNR_Public:GetPlateType (plateFrame)
    return ActivePlates_per_frame[plateFrame] and ActivePlates_per_frame[plateFrame].type or nil;
end

--- Gets a nameplate's unit's GUID if known
-- @name //addon//:GetPlateGUID
-- @param plateFrame the platename's root frame
-- @return associated unit's GUID as returned by the UnitGUID() WoW API or nil if the GUID is unknown
function LNR_Public:GetPlateGUID (plateFrame)
    return ActivePlates_per_frame[plateFrame] and ActivePlates_per_frame[plateFrame].GUID or nil;
end

--- Gets a platename's frame and known associated plateData using a GUID
-- @name //addon//:GetPlateByGUID
-- @param GUID a unit GUID as returned by UnitGUID() WoW API
-- @return plateFrame, plateData or nil
function LNR_Public:GetPlateByGUID (GUID)

    if GUID then
        for frame, data in pairs(ActivePlates_per_frame) do
            if data.GUID == GUID and LNR_Private:ValidateCache(frame, 'GUID') == 0 then
                return frame, data;
            end
        end
    end

    return nil;

end
LNR_Private.GetPlateByGUID = LNR_Public.GetPlateByGUID;


--- (DEPRECATED) Gets a platename's frame specific region using a normalized name.
-- 
-- Since WoW 7 nameplates can be linked to unit IDs to get
-- the proper information directly using the standard WoW API thus
-- GetPlateRegion should not be used anymore.
--
-- Use this API to get an easy and direct access to a specific sub-frame of any
-- nameplate. This is useful if you want to access data for which
-- LibNameplateRegistry provides no API (yet).
--
-- The result is cached for each frame making subsequent identical calls very fast.
--
-- The following regions are supported: 'name', 'statusBar', 'raidIcon'.
-- If you need to access a specific region which is not supported, please make
-- a feature request using the ticket system.
--
-- @name //addon//:GetPlateRegion
-- @param plateFrame the platename's root frame
-- @param internalRegionNormalizedName a normalized name referring to a specific region
-- @return region or throws an error if asked an unsupported region's name.
function LNR_Public:GetPlateRegion (plateFrame, internalRegionNormalizedName)

    local region = Plate_Parts_Cache[plateFrame][internalRegionNormalizedName];

    if region == false then
        error(("Unknown nameplate region: '%s'."):format(tostring(internalRegionNormalizedName)), 2);
    end

    return region;
end


do
    local CurrentPlate;
    local Data, Name;
    local next = _G.next;
    local function iter ()
        CurrentPlate, Data = next (ActivePlates_per_frame, CurrentPlate);

        if not CurrentPlate then
            return nil;
        end

        if Name == Data.name and LNR_Private:ValidateCache(CurrentPlate, 'name') == 0 then
            return CurrentPlate, Data;
        else
            return iter();
        end

    end

    --- Returns an iterator to iterate through all nameplates sharing an identical name\\
    --
    -- Used to iterate through nameplates using their names.\\\\
    -- Since nameplates are not necessary unique it's best to always use this
    -- method to get a nameplate's frame through it's name.
    --
    -- @name //addon//:EachPlateByName
    --
    -- @param name The name you want to iterate with
    --
    -- @usage
    --
    -- for frame, plateData in self:EachPlateByName(unitName) do
    -- -- code
    -- end
    --
    -- @return iterator 
    function LNR_Public:EachPlateByName (name)
        CurrentPlate = nil;
        Name = name;

        return iter;
    end
end -- }}}

--- Registers a LibNameplateRegistry callback\\
-- It's simply wrapping CallbackHandler-1.0's RegisterCallback() method.
--
-- @name //addon//:LNR_RegisterCallback
--
-- @paramsig callbackName [, method] [, extraArg]
--
-- @param callbackName name of a callback (see the [[http://www.wowace.com/addons/libnameplateregistry-1-0/pages/callbacks/|Callbacks' page]])
--
-- @param method (optional) The method to call when the callback fires, if ommitted, addon:eventname is used
--
-- @param ... (optional) An optional extra argument that is past to your handler as first argument (after 'self')

function LNR_Public:LNR_RegisterCallback (callbackName, method, ...)
    LNR_Private.RegisterCallback(self, callbackName, method, ...);
end

--- Unregisters a LibNameplateRegistry callback (see CallbackHandler-1.0 documentation)
-- @name //addon//:LNR_UnregisterCallback
-- @param callbackName the callback to stop tracking
function LNR_Public:LNR_UnregisterCallback (callbackName)
    LNR_Private.UnregisterCallback(self, callbackName);
end

--- Unregisters all LibNameplateRegistry callbacks
-- @name //addon//:LNR_UnregisterAllCallbacks
function LNR_Public:LNR_UnregisterAllCallbacks ()
    LNR_Private.UnregisterAllCallbacks(self);
end



-- == end of official public APIs ==



-- Blizzard event management
function LNR_Private.OnEvent(frame, event, ...)
    LNR_Private[event](LNR_Private, event, ...);
end

LNR_Private.EventFrame = LNR_Private.EventFrame or CreateFrame("Frame");
LNR_Private.EventFrame:Hide();
LNR_Private.EventFrame:SetScript("OnEvent", LNR_Private.OnEvent);


-- Internal timers management -- {{{

local TimerDivisor = 0
function LNR_Private.Ticker()

    if not LNR_ENABLED then
        -- return and thus don't reschedule ourselves
        return;
    end

    -- Check sanity every 100th tick
    TimerDivisor = TimerDivisor % 101 + 1;

    --[===[@debug@
    if DEBUG then
        if TimerDivisor % 10 == 0 then
            LNR_Private:DebugTests()
        end
    end
    --@end-debug@]===]
    
    C_Timer.After(0.1, LNR_Private.Ticker);

end -- }}}

LNR_Private.UsedCallBacks = LNR_Private.UsedCallBacks or 0;
-- Enable or Disable depending on our main callback usage
function LNR_Private.callbacks:OnUsed(target, eventname)

    LNR_Private.UsedCallBacks = LNR_Private.UsedCallBacks + 1;

    --Debug(INFO, "OnUsed", eventname);
    if LNR_Private.UsedCallBacks == 1 then
        LNR_Private:Enable();
    end

    
end

function LNR_Private.callbacks:OnUnused(target, eventname)

    LNR_Private.UsedCallBacks = LNR_Private.UsedCallBacks - 1;

    --Debug(INFO2, "OnUnused", eventname);
    if LNR_Private.UsedCallBacks == 0 then
        LNR_Private:Disable();
    end

    
end

function LNR_Private:Enable() -- {{{
    -- if we try to enable ourself while in combat blizzard might destroy the
    -- library with a SCRIPT_RAN_TO_LONG Lua exception...
    if InCombatLockdown() then
        Debug(WARNING, ":Enable(), InCombatLockdown, will retry later...");
        self.EventFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
        
        return
    end

    Debug(INFO, "Enable", LNR_ENABLED, debugstack(1,2,0));
    LNR_ENABLED = true;

    Debug(INFO, "Registrering events...");
    self.EventFrame:RegisterEvent("PLAYER_TARGET_CHANGED");
    self.EventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED");
    self.EventFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED");
    self.EventFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
    Debug(INFO2, "done.");

    LNR_Private.EventFrame:Show();
    Debug(INFO, "EventFrameShown!");



    --[===[@debug@
    if DEBUG then
        -- Enable timer execution
        C_Timer.After(0.1, self.Ticker);
        Debug(INFO, "Ticker set!");

        local tCountTest = {1,2}
        local function tCount(t)
            local count = 0

            for i in pairs(t) do
                count = count + 1
            end

            return count
        end 
        -- assert that our state is clean
        assert(tCount(tCountTest) == 2, 'tCount test failure');
        assert(tCount(ActivePlates_per_frame) == tCount(ActivePlateFrames_per_unitToken), 'uncleaned state: count mismatch');
        assert(tCount(ActivePlates_per_frame) == 0, 'uncleaned state: old data exists: '..tCount(ActivePlates_per_frame));
    end 
    --@end-debug@]===]

    local function findPlateUnitToken(plate, tokenID) -- only to be called on shown namePlates
        if GetNamePlateForUnit("nameplate"..tokenID) == plate then
            return "nameplate"..tokenID
        end

        if tokenID > 2000 then
            error('findPlateUnitToken infinite recurse?')
        end

        return findPlateUnitToken(plate, tokenID + 1)
    end

    Debug(INFO, "Looking for shown nameplates...");
    -- register nameplate frames created while we were not runing
    for _, PlateFrame in pairs(GetNamePlates()) do

        if not PlateFrame:IsShown() then
            Debug(ERROR, 'GetNamePlates returns unshown nameplates!?!');
        end

        -- if it's unkown to us
        if not ActivePlates_per_frame[PlateFrame] then
            -- Since we are calling the event handler directly make sure to not
            -- stop if an error is thrown in there (lost 2 hours of my life
            -- figuring out why a call to error() there was creating a rift in
            -- time and space...)
            pcall(self.NAME_PLATE_UNIT_ADDED, self, nil,
            findPlateUnitToken(PlateFrame, 1));
            Debug(INFO, 'START ADDED ', findPlateUnitToken(PlateFrame, 1));
        end
    end
    Debug(INFO2, "LFSN done.");

    self:PLAYER_TARGET_CHANGED();
    Debug(INFO2, "Enable END");

end -- }}}


function LNR_Private:Disable() -- {{{
    Debug(INFO2, "Disable", debugstack(1,2,0));

    -- disable events
    LNR_Private.EventFrame:Hide();

    -- make as if all nameplates were unshown (as tracking won't be accurate anymore)
    for unitToken, frame in pairs(ActivePlateFrames_per_unitToken) do
        self:NAME_PLATE_UNIT_REMOVED(nil, unitToken);
    end

    --[===[@debug@
    if DEBUG then
        twipe(callbacks_consisistency_check);
    end
    --@end-debug@]===]

    self.EventFrame:UnregisterAllEvents();

    LNR_ENABLED = false;
end -- }}}

-- /dump LibStub("LibNameplateRegistry-1.0"):GetUpgradeHistory()
function LNR_Public:GetUpgradeHistory()
    return LNR_Private.UpgradeHistory or false;
end

-- Quit the library properly and definitively destroying all private variables and functions to ensure a clean upgrade.
-- This is also called on catastrophic failure (incompatibility with WoW or other add-ons)
function LNR_Public:Quit(reason)

    --[===[@debug@
    if DEBUG then
        print("|cFFFF0000", MAJOR, MINOR, "Quitting|r", "(", reason, ")");
    end
    --@end-debug@]===]

    Debug(WARNING, "Quit called", debugstack(1,2,0));

    LNR_Private:Disable();

    -- clear Blizzard Event handler
    LNR_Private.EventFrame:SetScript("OnEvent", nil);

    -- destroy local caches
    twipe(Frame_Children_Cache);  Frame_Children_Cache = nil;
    twipe(Frame_Regions_Cache);   Frame_Regions_Cache  = nil;
    twipe(Plate_Parts_Cache);     Plate_Parts_Cache    = nil;

    -- destroy private work state
    twipe(PlateRegistry_per_frame);         PlateRegistry_per_frame = nil;
    twipe(ActivePlates_per_frame);          ActivePlates_per_frame  = {}; -- so public method wont crash
    twipe(ActivePlateFrames_per_unitToken); ActivePlateFrames_per_unitToken  = {};
    CurrentTarget             = nil;
    HasTarget                 = nil;
    TimerDivisor              = nil;

    --[===[@debug@
    callbacks_consisistency_check = nil;    
    --@end-debug@]===]


    -- clear all local methods

    Debug = nil;
    LNR_Public.Quit = function()end; -- if a previous version of the library crashes, this might be called again when upgrading
    LNR_Private.Quit    = LNR_Public.Quit;
    LNR_Private.Enable  = LNR_Public.Quit;
    LNR_Private.Disable = LNR_Public.Quit;

    return LNR_Private; -- return private stuff that can be useful

end
LNR_Private.Quit = LNR_Public.Quit;


function LNR_Private:FatalIncompatibilityError(icompatibilityType)
    LNR_ENABLED = false; -- will disable ticker

    -- do not send the message right away because we don't know what's happening. (we might be inside a metatable's callback for all we know...)
    C_Timer.After(0.5, function()
        LNR_Private:Fire("LNR_ERROR_FATAL_INCOMPATIBILITY", icompatibilityType);
        LNR_Private:Quit("Fatal error: "..icompatibilityType);
        error(MAJOR..MINOR..' has died due to a serious incompatibility issue: ' .. icompatibilityType);
    end);
end


-- upgrade our mixins in all targets
for target,_ in pairs(LNR_Private.mixinTargets) do
    LNR_Public:Embed(target);
end

-- relaunch the lib if it was upgraded while enabled
if LNR_Private.UsedCallBacks ~= 0 then
    LNR_Private:Enable();
end
