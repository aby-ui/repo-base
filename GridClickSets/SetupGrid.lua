local _, addon = ...
--addon.DependOn = CoreDependCall

if not addon.DependOn then
    local eventFrame = CreateFrame("Frame");
    local all_funcs = {}
    eventFrame:RegisterEvent("ADDON_LOADED")
    eventFrame:SetScript("OnEvent", function(self, event, addon)
        local funcs = all_funcs[addon]
        if not funcs then return end
        for i=#funcs, 1, -1 do
            funcs[i](event, addon)
        end
        all_funcs[addon] = nil
    end)

    addon.DependOn = function(addon, func)
        if(IsAddOnLoaded(addon)) then
            func()
        else
            all_funcs[addon] = all_funcs[addon] or {}
            table.insert(all_funcs[addon], func);
        end
    end
end

if select(5, GetAddOnInfo("Grid")) == "MISSING" then
    return
end

addon.DependOn("Grid", function()

    local GridFrame = Grid:GetModule("GridFrame")

    local function WithAllGridFrames(func)
        for _, frame in pairs(GridFrame.registeredFrames) do
       		func(frame)
       	end
    end

    GridClickSets = Grid:NewModule("GridClickSets")

    function GridFrameDropDown_Initialize(self)
        local unit = self:GetParent().unit;
        if ( not unit ) then
            return;
        end
        local menu;
        local name;
        local id = nil;
        if ( UnitIsUnit(unit, "player") ) then
            menu = "SELF";
        elseif ( UnitIsUnit(unit, "vehicle") ) then
            -- NOTE: vehicle check must come before pet check for accuracy's sake because
            -- a vehicle may also be considered your pet
            menu = "VEHICLE";
        elseif ( UnitIsUnit(unit, "pet") ) then
            menu = "PET";
        elseif ( UnitIsPlayer(unit) ) then
            id = UnitInRaid(unit);
            if ( id ) then
                menu = "RAID_PLAYER";
                name = GetRaidRosterInfo(id);
            elseif ( UnitInParty(unit) ) then
                menu = "PARTY";
            else
                menu = "PLAYER";
            end
        else
            menu = "TARGET";
            name = RAID_TARGET_ICON;
        end
        if ( menu ) then
            UnitPopup_ShowMenu(self, menu, unit, name, id);
        end
    end

    local function initializeFrame(gridFrameObj, frame)
        frame.dropDown = CreateFrame("Frame", frame:GetName().."DropDown", frame, "UIDropDownMenuTemplate");
        frame.dropDown:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, 2);
        UIDropDownMenu_Initialize(frame.dropDown, GridFrameDropDown_Initialize, "MENU");
        frame.menu = function()
            ToggleDropDownMenu(1, nil, frame.dropDown, frame:GetName(), 0, 0);
        end
        frame:SetAttribute("*type2", "menu");
        frame.dropDown:Hide();
        GridClickSets_SetAttributes(frame, GridClickSetsFrame_GetCurrentSet());
    end

    hooksecurefunc(GridFrame, "InitializeFrame", initializeFrame)
    if IsLoggedIn() and GridFrame.registeredFrames then WithAllGridFrames(function(f) initializeFrame(nil, f) end) end

    local options = {
        type = "execute",
        name = GRIDCLICKSETS_MENUNAME,
        desc = GRIDCLICKSETS_MENUTIP,
        order = 0.1,
        func = function()
            if InterfaceOptionsFrame:IsVisible() then
                InterfaceOptionsFrame.lastFrame = nil
                HideUIPanel(InterfaceOptionsFrame, true)
                GridClickSetsFrame.lastFrame = InterfaceOptionsFrame
            else
                LibStub("AceConfigDialog-3.0"):Close("Grid")
                GridClickSetsFrame.lastFrame = function() LibStub("AceConfigDialog-3.0"):Open("Grid") end
            end
            GridClickSetsFrame:Show();
            GameTooltip:Hide();
        end
    }

    GridClickSets.options = { type = "group", name = options.name, order = options.order, args = { button = options } }

    function GridClickSets:OnEnable()
        --the profile no longer work with grid.
    end

    function GridClickSets:Reset()
        --the profile no longer work with grid.
    end

    table.insert(GridClickSetsFrame_Updates, function(set)
        WithAllGridFrames(function (f) GridClickSets_SetAttributes(f, set) end)
    end);

end)