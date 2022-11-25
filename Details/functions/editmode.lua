
local Details = _G.Details
local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale("Details")
local addonName, Details222 = ...

function Details.RegisterDragonFlightEditMode()
    if (EventRegistry and type(EventRegistry) == "table") then
        local onEnterEditMode = function()
            
        end

        local onLeaveEditMode = function()

        end
        EventRegistry:RegisterCallback("EditMode.Enter", onEnterEditMode)
        EventRegistry:RegisterCallback("EditMode.Edit", onLeaveEditMode)
    end
end
