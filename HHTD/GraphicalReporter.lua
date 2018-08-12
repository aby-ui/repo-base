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
    GraphicalReporter.lua
-----

This component displays a list of known healers with a proximity sensor, the list is click-able and will run a targeting macro
- it may also focus them
- trigger a chosen spell
- should not ring when target through macro

--]=]

--[===[@debug@

local ERROR     = 1;
local WARNING   = 2;
local INFO      = 3;
local INFO2     = 4;

local ADDON_NAME, T = ...;
local HHTD = T.HHTD;
local L = HHTD.Localized_Text;

-- Create module
HHTD.Graphical_Reporter = HHTD:NewModule("GR")
local GR = HHTD.Graphical_Reporter;

function GR:CreateGRObjectsAnchor() -- {{{
    self.Anchor = {};
    self.Anchor.frame = CreateFrame ("Frame", nil, UIParent);
    local frame = self.Anchor.frame;

    frame:EnableMouse(true);
    frame:RegisterForDrag("LeftButton");

    frame:SetScript("OnDragStart", frame.StartMoving);
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing);

    frame:SetPoint("CENTER"); frame:SetWidth(263); frame:SetHeight(33);

    -- create a beautiful texture for the anchor.
    local AnchorTexture = frame:CreateTexture("ARTWORK");
    AnchorTexture:SetAllPoints();
    AnchorTexture:SetTexture(0.275, 0.765, 0.222);
    AnchorTexture:SetAlpha(0.85);

    frame:Hide();

end -- }}}

function GR:OnEnable() -- {{{
    self:Debug(INFO, "OnEnable");
    -- start roaming updater code here
end -- }}}

function GR:OnDisable() -- {{{
    self:Debug(INFO2, "OnDisable");
    -- stop roaming update here and hide evrything
end -- }}}



-- Graphical Reporter Objects constructor
GR.GRObject = {};

local GRObject = GR.GRObject;
GRObject.Prototype = {};
GRObject.Metatable ={ __index = GRObject.Prototype };

GRObject.Count = 0;
GRObject.Initialized = false;


function GRObject:new(...)
    local instance = setmetatable({}, self.Metatable);
    instance:Init(...);
    return instance;
end



function GRObject.Prototype:Init(healerName)

    if not HHTD.initOK then
        HHTD:Debug(INFO, "Initializing EH object for", healerName, "failed, initialization incomplete");
        return;
    end

    HHTD:Debug(INFO, "Initializing EH object for", healerName);


    GRObject.Count = GRObject.Count + 1;

    self.Shown = false;
    self.ProximitySensor = false;

    -- create the frame
    self.Frame  = CreateFrame ("Button", nil, UIParent, "SecureUnitButtonTemplate");

    -- global texture
    self.Texture = self.Frame:CreateTexture(nil, "ARTWORK");
    self.Texture:SetPoint("CENTER", self.Frame, "CENTER", 0, 0)

    self.Texture:SetHeight(16);
    self.Texture:SetWidth(160);

-- name (class colored)
-- proximity light
-- targetable indicator

end
--@end-debug@]===]

-- === ROADMAP === --

-- name (class colored)
-- proximity light
-- targetable indicator
-- heal amount indicator
-- anchoring function
-- update mechanism
-- -- Roaming or not roaming?
-- -- -- needed for proximity light and macro update
-- -- -- needed for deletion (grey out unseen healers - make them disappear completely in some event)
-- -- -- leave combat trigger
