-- Common functions used for overlays.


-- local theTime = GetTime()
--TODO: Turn resetDelay into a user option
local resetDelay = .3
-- local resetTime = theTime + resetDelay

-- local calculatedFrames = {}


-- function iconOverlayUpdateDelay(self, elapsed)
--     -- Delays the update of the icon overlay by resetDelay seconds.
--     theTime = GetTime()
--     if theTime > resetTime then
--         calculatedFrames = {}
--         resetTime = theTime + resetDelay
--     end
-- end
-- CanIMogIt.frame:HookScript("OnUpdate", iconOverlayUpdateDelay)



----------------------------
-- Core Overlay functions --
----------------------------


function CIMI_CheckOverlayIconEnabled()
    -- Checks if the item overlay option is enabled.
    if not CanIMogItOptions["showItemIconOverlay"] then
        return false
    end
    return true
end


function CIMI_SetIcon(frame, updateIconFunc, text, unmodifiedText)
    -- Sets the icon based on the text for the CanIMogItOverlay on the given frame.
    frame.text = tostring(text)
    frame.unmodifiedText = tostring(unmodifiedText)
    if text == nil then
        -- nil means not all data was available to get the text. Try again later.
        frame.CIMIIconTexture:SetShown(false)
        frame:SetScript("OnUpdate", CIMIOnUpdateFuncMaker(updateIconFunc));
    elseif text == "" then
        -- An empty string means that the text shouldn't be displayed.
        frame.CIMIIconTexture:SetShown(false)
        frame:SetScript("OnUpdate", nil);
    else
        -- Show an icon!
        frame.CIMIIconTexture:SetShown(true)
        local icon = CanIMogIt.tooltipOverlayIcons[unmodifiedText]
        frame.CIMIIconTexture:SetTexture(icon, false)
        frame:SetScript("OnUpdate", nil);
    end
    frame.shown = frame.CIMIIconTexture:IsShown()
end


-- TODO: Make this configurable
local ICON_MIN_SIZE = 5
local ICON_SIZE = 13
local ICON_MAX_SIZE = 33

function CIMI_AddToFrame(parentFrame, updateIconFunc, frameSuffix, overrideIconLocation)
    -- Create the Texture and set OnUpdate
    if parentFrame and not parentFrame.CanIMogItOverlay then
        frameSuffix = frameSuffix or tostring(parentFrame:GetName())
        local frame = CreateFrame("Frame", "CIMIOverlayFrame_"..frameSuffix, parentFrame)
        parentFrame.CanIMogItOverlay = frame
        -- Get the frame to match the shape/size of its parent
        frame:SetAllPoints()

        -- Create the texture frame.
        frame.CIMIIconTexture = frame:CreateTexture("CIMITextureFrame", "OVERLAY")
        frame.CIMIIconTexture:SetWidth(ICON_SIZE)
        frame.CIMIIconTexture:SetHeight(ICON_SIZE)
        local iconLocation = overrideIconLocation or CanIMogItOptions["iconLocation"]
        frame.CIMIIconTexture:SetPoint(unpack(CanIMogIt.ICON_LOCATIONS[iconLocation]))
        frame.timeSinceCIMIIconCheck = 0
        frame:SetScript("OnUpdate", CIMIOnUpdateFuncMaker(updateIconFunc))
        return frame
    end
end


function CIMIOnUpdateFuncMaker(func)
    function CIMIOnUpdate(self, elapsed)
        -- Attempts to update the icon again after the delay has elapsed.
        self.timeSinceCIMIIconCheck = self.timeSinceCIMIIconCheck + elapsed
        if self.timeSinceCIMIIconCheck >= resetDelay then
            self.timeSinceCIMIIconCheck = 0
            func(self)
        end
    end
    return CIMIOnUpdate
end


----------------------------
-- UpdateIcon functions   --
----------------------------


------------------------
-- Function hooks     --
------------------------


----------------------------
-- Begin adding to frames --
----------------------------


local function HookItemOverlay(event)
    if event ~= "PLAYER_LOGIN" then return end
end

CanIMogIt.frame:AddEventFunction(HookItemOverlay)

------------------------
-- Event functions    --
------------------------

CIMIEvents = {
    ["UNIT_INVENTORY_CHANGED"] = true,
    ["PLAYER_SPECIALIZATION_CHANGED"] = true,
    ["BAG_UPDATE"] = true,
    ["BAG_NEW_ITEMS_UPDATED"] = true,
    ["QUEST_ACCEPTED"] = true,
    ["BAG_SLOT_FLAGS_UPDATED"] = true,
    ["BANK_BAG_SLOT_FLAGS_UPDATED"] = true,
    ["PLAYERBANKSLOTS_CHANGED"] = true,
    ["BANKFRAME_OPENED"] = true,
    ["START_LOOT_ROLL"] = true,
    ["MERCHANT_SHOW"] = true,
    ["VOID_STORAGE_CONTENTS_UPDATE"] = true,
    ["GUILDBANKBAGSLOTS_CHANGED"] = true,
    ["PLAYERREAGENTBANKSLOTS_CHANGED"] = true,
    ["CHAT_MSG_LOOT"] = true,
    ["LOADING_SCREEN_ENABLED"] = true,
    ["LOADING_SCREEN_DISABLED"] = true,
}


CanIMogIt.frame.itemOverlayEventFunctions = {}

function CanIMogIt.frame:ItemOverlayEvents(event, ...)
    if not CIMIEvents[event] then return end
    for i, func in ipairs(CanIMogIt.frame.itemOverlayEventFunctions) do
        func(event, ...)
    end
end

function CanIMogIt.frame:AddOverlayEventFunction(func)
    -- Adds the func to the list of functions that are called for overlay events.
    table.insert(CanIMogIt.frame.itemOverlayEventFunctions, func)
end


local timers = {}
local refreshDelay = 0.1

function CanIMogIt.FrameShouldUpdate(timerName, elapsed)
    -- Returns true if a sufficient amount of time has passed to
    -- not cause FPS drops when updating frames.
    -- To use:
    -- if not FrameShouldUpdate("MyTimer", elapsed) then return end
    if type(elapsed) ~= "number" then
        elapsed = refreshDelay
    end
    if timers[timerName] == nil then
        timers[timerName] = 0
    end

    timers[timerName] = timers[timerName] + elapsed
    if timers[timerName] < refreshDelay then return end
    timers[timerName] = 0
    return true
end