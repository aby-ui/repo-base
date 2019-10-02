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
if not T._LoadedFiles or not T._LoadedFiles["Decursive.xml"] or not T._LoadedFiles["Decursive.lua"] then
    if not DecursiveInstallCorrupted then T._FatalError("Decursive installation is corrupted! (Decursive.xml or Decursive.lua not loaded)"); end;
    DecursiveInstallCorrupted = true;
    return;
end
T._LoadedFiles["Dcr_lists.lua"] = false;

local D = T.Dcr;


local L = D.L;
local LC = D.LC;
local DC = T._C;
local _;
local _G = _G;

local pairs             = _G.pairs;
local ipairs            = _G.ipairs;
local type              = _G.type;
local string            = _G.string;
local UnitGUID          = _G.UnitGUID;
local table             = _G.table;
local str_format        = _G.string.format;
local t_insert          = _G.table.insert;

local UnitClass         = _G.UnitClass;
local UnitExists        = _G.UnitExists;
local UnitIsPlayer      = _G.UnitIsPlayer;
local GetRaidRosterInfo = _G.GetRaidRosterInfo;
local IsShiftKeyDown    = _G.IsShiftKeyDown;
local IsControlKeyDown  = _G.IsControlKeyDown;

-- Dcr_ListFrameTemplate specific internal functions {{{
function D.ListFrameTemplate_OnLoad(frame)
    frame.ScrollFrame = _G[frame:GetName().."ScrollFrame"];
    frame.ScrollBar = _G[frame.ScrollFrame:GetName().."ScrollBar"];
    frame.ScrollFrame.offset = 0;
end

function D:ListFrameScrollFrameTemplate_OnMouseWheel(frame, value)
    local scrollBar = _G[frame:GetName().."ScrollBar"];
    local min, max = scrollBar:GetMinMaxValues();
    if ( value > 0 ) then
        if (IsShiftKeyDown() ) then
            scrollBar:SetValue(min);
        else
            scrollBar:SetValue(scrollBar:GetValue() - scrollBar:GetValueStep());
        end
    else
        if (IsShiftKeyDown() ) then
            scrollBar:SetValue(max);
        else
            scrollBar:SetValue(scrollBar:GetValue() + scrollBar:GetValueStep());
        end
    end
end

-- }}}

-- Dcr_ListFrameTemplate specific handlers {{{

function D.PrioSkipListFrame_OnUpdate(frame) --{{{


    if not D.DcrFullyInitialized then
        return;
    end

    if (frame.UpdateYourself) then
        frame.UpdateYourself = false;
        local baseName = frame:GetName();
        local size;

        if (frame.Priority) then
            size = #D.profile.PriorityList;
        else
            size = #D.profile.SkipList;
        end
        -- D:Debug("PrioSkipListFrame_OnUpdate executed", size, this.ScrollFrame.offset);

        local i;
        for i = 1, 10 do
            local id = ""..i;
            if (i < 10) then
                id = "0"..i;
            end
            local btn = _G[baseName.."Index"..id];

            btn:SetID( i + frame.ScrollFrame.offset);
            D:PrioSkipListEntry_Update(btn);

            if (i <= size) then
                btn:Show();
            else
                btn:Hide();
            end
        end
        frame.ScrollUpdateFunc(_G[baseName.."ScrollFrame"], true);
    end

end --}}}

function D.PrioSkipListEntryTemplate_OnClick(listFrame, entryBFrame, button) --{{{

    local list;
    local UnitNum;
    if listFrame.Priority then
        list = D.profile.PriorityList;
        UnitNum = #D.profile.PriorityList;
    else
        list = D.profile.SkipList;
        UnitNum = #D.profile.SkipList;
    end


    local id = entryBFrame:GetID();
    if (id) then
        if (IsControlKeyDown()) then
            if (listFrame.Priority) then
                D:RemoveIDFromPriorityList(id);
            else
                D:RemoveIDFromSkipList(id);
            end
        elseif (UnitNum > 1) then
            local previousUnit_ID, previousUnit, nextUnit_ID, nextUnit, currentUnit;

            previousUnit_ID  = id - 1;
            nextUnit_ID      = id + 1;

            previousUnit = list[previousUnit_ID];
            nextUnit     = list[nextUnit_ID    ];
            currentUnit  = list[id];


            if (button=="RightButton" and IsShiftKeyDown()) then -- move at the bottom
                table.remove(list, id);
                table.insert(list, UnitNum, currentUnit);

            elseif (button=="LeftButton" and IsShiftKeyDown()) then -- move at the top
                table.remove(list, id);
                table.insert(list, 1, currentUnit);
            elseif (button=="LeftButton" and id ~= 1) then -- unit gets higher
                D:Debug("upping %s of id %d", list[id], id);
                list[previousUnit_ID]   = list[id];
                list[id]                = previousUnit;
            elseif (button=="RightButton" and id ~= UnitNum) then -- unit gets lower
                D:Debug("downing %s of id %d", list[id], id);
                list[nextUnit_ID]       = list[id];
                list[id]                = nextUnit;
            elseif (button=="MiddleButton") then

            end
            listFrame.UpdateYourself = true;
        end
        D.Status.PrioChanged       = true;
        D:GroupChanged ("PrioSkipListEntryTemplate_OnClick");
    else
            D:Debug("No ID");
    end

end --}}}

function D:PrioSkipListEntry_Update(Entry) --{{{
        local id = Entry:GetID();
        if (id) then
        --D:Debug("PrioSkipListEntry_Update executed");
            local name, classname, GUIDorNum;
            if (Entry:GetParent().Priority) then
                GUIDorNum = D.profile.PriorityList[id];
                classname = D.profile.PriorityListClass[GUIDorNum];
                name = D.profile.PrioGUIDtoNAME[GUIDorNum];
            else
                GUIDorNum = D.profile.SkipList[id];
                classname = D.profile.SkipListClass[GUIDorNum];
                name = D.profile.SkipGUIDtoNAME[GUIDorNum];
            end

            if (GUIDorNum) then
                if (type(GUIDorNum) == "number") then
                    if (GUIDorNum > 10) then
                        name = str_format("[ %s ]", DC.ClassNumToLName[GUIDorNum]);
                    elseif GUIDorNum > 0 then
                        name = str_format("[ %s %s ]", L["STR_GROUP"], GUIDorNum);
                    else
                        name = str_format("[ %s ]", _G[({"HEALER", "TANK", "DAMAGER"})[-GUIDorNum]] or GUIDorNum);
                    end
                end
                Entry:SetText(id.." - "..D:ColorText(name, classname and "FF"..DC.HexClassColor[classname] or (GUIDorNum > 0 and "FFCACAF0" or "FFBAF0DA") ));
            else
                Entry:SetText("Error - NO name!");
            end
        else
            Entry:SetText("Error - No ID!");
        end
end --}}}

function D.PrioSkipList_ScrollFrame_Update (ScrollFrame) -- {{{

    if not D.DcrFullyInitialized then
        return;
    end

    local maxentry;
    local UpdateListOnceDone = true;
    local DirectCall = false;

    D:Debug("ScrollFrame is a %s", type(ScrollFrame));
    if (not ScrollFrame) then
        --ScrollFrame = this; -- Called from the scrollbar frame handler
    else
        --UpdateListOnceDone = false; -- The function was called from the list update function
        DirectCall = true;
    end

    if (not ScrollFrame.UpdateYourself) then
        ScrollFrame.UpdateYourself = true;
        return;
    end

    if (ScrollFrame:GetParent().Priority) then
        maxentry = #D.profile.PriorityList;
    else
        maxentry = #D.profile.SkipList;
    end

    FauxScrollFrame_Update(ScrollFrame,maxentry,10,16);


    if (UpdateListOnceDone) then
        ScrollFrame.UpdateYourself = false; -- prevent this function to re-execute unecessarily
        ScrollFrame:GetParent().UpdateYourself = true;
    end
    D:Debug("PrioSkipList_ScrollFrame_Update executed for %s", ScrollFrame:GetName());
end -- }}}


-- }}}

-- list specific management functions {{{
-------------------------------------------------------------------------------

function D:AddTargetToPriorityList() --{{{
    D:Debug( "Adding the target to the priority list");
    return D:AddElementToPriorityList("target", true);
end --}}}

local function AddElementToList(element, checkIfExist, list, listGUIDtoName, listClass) -- {{{

    if not D.DcrFullyInitialized then
        return false;
    end

    if #list > 99 then
        return false;
    end

    if not checkIfExist or UnitExists(element) then
        if type(element) == "number" or UnitIsPlayer(element) then
            D:Debug("adding %s", element);

            local GUIDorNum;

            if type(element) == "number" then
                GUIDorNum = element;
            else
                GUIDorNum = UnitGUID(element);
                if not GUIDorNum then
                    return false;
                end
            end

            if listGUIDtoName[GUIDorNum] then
                return false;
            end

            table.insert(list, GUIDorNum);

            if type(element) == "string" then
                _, listClass[GUIDorNum]   = UnitClass(element);
                listGUIDtoName[GUIDorNum] = D:UnitName(element);
            elseif element > 10 then
                listClass[element]        = DC.ClassNumToUName[element];
                listGUIDtoName[GUIDorNum] = str_format("[ %s ]", DC.ClassNumToLName[GUIDorNum]);
            else
                listGUIDtoName[GUIDorNum] = str_format("[ %s %s ]", L["STR_GROUP"], GUIDorNum);
            end

            return true;
        else
            D:Debug("Unit is not a player:", element, checkIfExist, UnitExists(element));

            if not element then
                error("D:AddElementToList: bad argument #1 'element' must be!",2);
            end
        end
    else
        D:Debug("Unit does not exist");
    end

    return false;
end -- }}}

function D:AddElementToPriorityList(element, check) --{{{

    if AddElementToList(element, check, D.profile.PriorityList, D.profile.PrioGUIDtoNAME, D.profile.PriorityListClass) then

        DecursivePriorityListFrame.UpdateYourself = true;
        D.Status.PrioChanged                      = true;

        D:GroupChanged("AddElementToPriorityList");
        D:Debug("Unit %s added to the prio list", element);
        return true;
    else
        return false;
    end

end --}}}

function D:RemoveIDFromPriorityList(id) --{{{

    D.profile.PriorityListClass[ D.profile.PriorityList[id] ] = nil; -- remove it from the table
    D.profile.PrioGUIDtoNAME[ D.profile.PriorityList[id]] = nil;

    table.remove( D.profile.PriorityList, id );

    D.Status.PrioChanged       = true;
    D:GroupChanged ("RemoveIDFromPriorityList");
    DecursivePriorityListFrame.UpdateYourself = true;
end --}}}

function D:ClearPriorityList() --{{{
    D.profile.PriorityList = {};
    D.profile.PriorityListClass = {};
    D.profile.PrioGUIDtoNAME = {};

    D.Status.PrioChanged       = true;
    D:GroupChanged ("ClearPriorityList");
    DecursivePriorityListFrame.UpdateYourself = true;
end --}}}

function D:AddTargetToSkipList() --{{{
    D:Debug( "Adding the target to the Skip list");
    return D:AddElementToSkipList("target");
end --}}}



function D:AddElementToSkipList(element, check) --{{{

    if AddElementToList(element, check, D.profile.SkipList, D.profile.SkipGUIDtoNAME, D.profile.SkipListClass) then

        DecursiveSkipListFrame.UpdateYourself = true;
        D.Status.PrioChanged                  = true;

        D:GroupChanged ("AddElementToSkipList");

        D:Debug("Unit %s added to the skip list", element);
        return true;
    else
        return false;
    end

end --}}}

function D:RemoveIDFromSkipList(id) --{{{

    D.profile.SkipListClass[ D.profile.SkipList[id] ] = nil; -- remove it from the table
    D.profile.SkipGUIDtoNAME[ D.profile.SkipList[id]] = nil;


    table.remove( D.profile.SkipList, id );

    D.Status.PrioChanged       = true;
    D:GroupChanged ("RemoveIDFromSkipList");
    DecursiveSkipListFrame.UpdateYourself = true;
end --}}}

function D:ClearSkipList() --{{{
    local i;

    D.profile.SkipList = {};
    D.profile.SkipListClass = {};
    D.profile.SkipGUIDtoNAME = {};

    D.Status.PrioChanged       = true;
    D.Groups_datas_are_invalid = true;
    D:GroupChanged ("ClearSkipList");
    DecursiveSkipListFrame.UpdateYourself = true;
end --}}}


function D:IsInPriorList (GUID) --{{{
    return self.Status.InternalPrioList[GUID] or false;
end --}}}

function D:IsInSkipList (GUID) --{{{
    return self.Status.InternalSkipList[GUID] or false;
end --}}}


-- }}}



function D:PopulateButtonPress(frame) --{{{
    local PopulateFrame = frame:GetParent();
    local UppedClass = "";

    if (IsShiftKeyDown() and frame.ClassType) then

        -- UnitClass returns uppercased class...
        UppedClass = string.upper(frame.ClassType);

        D:Debug("Populate called for %s", frame.ClassType);
        -- for the class type stuff... we do party

        local _, pclass = UnitClass("player");
        if (pclass == UppedClass) then
            PopulateFrame:addFunction("player");
        end

        _, pclass = UnitClass("party1");
        if (pclass == UppedClass) then
            PopulateFrame:addFunction("party1");
        end
        _, pclass = UnitClass("party2");
        if (pclass == UppedClass) then
            PopulateFrame:addFunction("party2");
        end
        _, pclass = UnitClass("party3");
        if (pclass == UppedClass) then
            PopulateFrame:addFunction("party3");
        end
        _, pclass = UnitClass("party4");
        if (pclass == UppedClass) then
            PopulateFrame:addFunction("party4");
        end
    end

    local i, pgroup, pclass;


    if (IsShiftKeyDown() and frame.ClassType) then
        D:Debug("Finding raid units with a macthing class");
        for index, unit in ipairs(D.Status.Unit_Array) do
            _, pclass = UnitClass(unit);

            if (pclass == UppedClass) then
                D:Debug("found %s", pclass);
                PopulateFrame:addFunction(unit);
            end

        end
    elseif (frame.ClassType) then
        PopulateFrame:addFunction(DC.ClassUNameToNum[string.upper(frame.ClassType)]);
    end


    local max = DC.GetNumRaidMembers();

    if (IsShiftKeyDown() and frame.GroupNumber and max > 0) then
        D:Debug("Finding raid units with a matching group number");
        for i = 1, max do
            _, _, pgroup, _, _, pclass = GetRaidRosterInfo(i);

            if (pgroup == frame.GroupNumber) then
                D:Debug("found %s in group %d", pclass, max);
                PopulateFrame:addFunction("raid"..i);
            end
        end
    elseif (not IsShiftKeyDown() and frame.GroupNumber) then
        PopulateFrame:addFunction(frame.GroupNumber);
    end

end --}}}

T._LoadedFiles["Dcr_lists.lua"] = "2.7.6.4";
