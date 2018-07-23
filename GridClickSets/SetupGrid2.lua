if select(5, GetAddOnInfo("Grid2")) == "MISSING" then
    return
end

local _, addon = ...
addon.DependOn("Grid2", function()

    local Grid2Frame = Grid2:GetModule("Grid2Frame")
    local function initializeFrame(gridFrameObj, frame)
        frame:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp", "Button4Up", "Button5Up")
        frame:SetAttribute("*type2", "menu");
        GridClickSets_SetAttributes(frame, GridClickSetsFrame_GetCurrentSet());
    end

    hooksecurefunc(Grid2Frame, "RegisterFrame", initializeFrame)
    if IsLoggedIn() and Grid2Frame.registeredFrames then Grid2Frame:WithAllFrames(function(f) initializeFrame(nil, f) end) end

    table.insert(GridClickSetsFrame_Updates, function(set)
        Grid2Frame:WithAllFrames(function (f) GridClickSets_SetAttributes(f, set) end)
    end);

end)