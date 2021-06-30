--[[
	Krowi's World Map Buttons License
		Copyright ©2020-2021 The contents of this library, excluding third-party resources, are
		copyrighted to their authors with all rights reserved.

		This library is free to use and the authors hereby grants you the following rights:

		1. 	You may make modifications to this library for private use only, you
			may not publicize any portion of this library. The only exception being you may
			upload to the github website.

		2. 	Do not modify the name of this library, including the library folders.

		3. 	This copyright notice shall be included in all copies or substantial
			portions of the Software.

		All rights not explicitly addressed in this license are reserved by
		the copyright holders.
]]

local lib = LibStub:NewLibrary('Krowi_WorldMapButtons-1.0', 1);

if not lib then
	return;
end

local buttons;

local function SetPoints()
	local xOffset = 4;
	for _, button in next, buttons do
		if button:IsShown() then
			button:SetPoint("TOPRIGHT", button.relativeFrame, -xOffset, -2);
			xOffset = xOffset + 32;
		end
	end
end

local hookedDefaultButtons;
local function HookDefaultButtons()
	hooksecurefunc(WorldMapFrame, "RefreshOverlayFrames", function()
		SetPoints();
	end);

	for _, f in next, WorldMapFrame.overlayFrames do
        if WorldMapTrackingOptionsButtonMixin and f.OnLoad == WorldMapTrackingOptionsButtonMixin.OnLoad then
			f.KrowiWorldMapButtonsIndex = #buttons;
			tinsert(buttons, f);
        end
        if WorldMapTrackingPinButtonMixin and f.OnLoad == WorldMapTrackingPinButtonMixin.OnLoad then
			f.KrowiWorldMapButtonsIndex = #buttons;
			tinsert(buttons, f);
        end
    end

	hookedDefaultButtons = true;
end

-- local hookedHandyNotesButtons;
-- local function HookHandyNotesButtons()
--     for _, f in next, WorldMapFrame.overlayFrames do
--         if HandyNotes_ShadowlandsWorldMapOptionsButtonMixin and f.OnLoad == HandyNotes_ShadowlandsWorldMapOptionsButtonMixin.OnLoad then
-- 			f.KrowiWorldMapButtonsIndex = #buttons;
-- 			tinsert(buttons, f);
--         end
--         if HandyNotes_VisionsOfNZothWorldMapOptionsButtonMixin and f.OnLoad == HandyNotes_VisionsOfNZothWorldMapOptionsButtonMixin.OnLoad then
-- 			f.KrowiWorldMapButtonsIndex = #buttons;
-- 			tinsert(buttons, f);
--         end
--     end

-- 	hookedHandyNotesButtons = true;
-- end

function lib:Add(templateName, templateType)
	if buttons == nil then
		buttons = {};
	end

	if not hookedDefaultButtons then
		HookDefaultButtons();
	end

	-- if not hookedHandyNotesButtons then
	-- 	HookHandyNotesButtons();
	-- end

	local xOffset = 4 + #buttons * 32;

	local button = WorldMapFrame:AddOverlayFrame(templateName, templateType, "TOPRIGHT", WorldMapFrame:GetCanvasContainer(), "TOPRIGHT", -xOffset, -2);

	tinsert(buttons, button);

	return button;
end