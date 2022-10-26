--[[
	Krowi's World Map Buttons License
		Copyright ©2020-2022 The contents of this library, excluding third-party resources, are
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

local lib = LibStub:NewLibrary('Krowi_WorldMapButtons-1.4', 1);

if not lib then
	return;
end

local function SetPoints()
	local xOffset = 4;
	for _, button in next, lib.buttons do
		if button:IsShown() then
			button:SetPoint("TOPRIGHT", button.relativeFrame, -xOffset, -2);
			xOffset = xOffset + 32;
		end
	end
end

local function HookDefaultButtons()
	if WorldMapFrame.overlayFrames == nil then
		lib.HookedDefaultButtons = true;
		return;
	end

	for _, f in next, WorldMapFrame.overlayFrames do
        if WorldMapTrackingOptionsButtonMixin and f.OnLoad == WorldMapTrackingOptionsButtonMixin.OnLoad then
			f.KrowiWorldMapButtonsIndex = #lib.buttons;
			tinsert(lib.buttons, f);
        end
        if WorldMapTrackingPinButtonMixin and f.OnLoad == WorldMapTrackingPinButtonMixin.OnLoad then
			f.KrowiWorldMapButtonsIndex = #lib.buttons;
			tinsert(lib.buttons, f);
        end
    end

	lib.HookedDefaultButtons = true;
end

local function PatchWrathClassic()
	if WorldMapFrame.RefreshOverlayFrames ~= nil then
		return;
	end

	WorldMapFrame.RefreshOverlayFrames = function()
	end
	
	lib.IsWrathClassic = true;
	lib.PatchedWrathClassic = true;
end

function lib:Add(templateName, templateType)
	if lib.buttons == nil then
		lib.buttons = {};
	end

	if not lib.HookedDefaultButtons then
		HookDefaultButtons();
	end

	if not lib.PatchedWrathClassic then
		PatchWrathClassic();
	end

	local xOffset = 4 + #lib.buttons * 32;

	-- local button = WorldMapFrame:AddOverlayFrame(templateName, templateType, "TOPRIGHT", WorldMapFrame:GetCanvasContainer(), "TOPRIGHT", -xOffset, -2);
	NumKrowi_WorldMapButtons = NumKrowi_WorldMapButtons or 1;
	local button = CreateFrame(templateType, "Krowi_WorldMapButtons" .. NumKrowi_WorldMapButtons, WorldMapFrame, templateName);
	NumKrowi_WorldMapButtons = NumKrowi_WorldMapButtons + 1;
	button:SetPoint("TOPRIGHT", WorldMapFrame:GetCanvasContainer(), "TOPRIGHT", -xOffset, -2);
	button.relativeFrame = WorldMapFrame:GetCanvasContainer();
	hooksecurefunc(WorldMapFrame, lib.IsWrathClassic and "OnMapChanged" or "RefreshOverlayFrames", function()
		button:Refresh();
		SetPoints();
	end);

	tinsert(lib.buttons, button);

	return button;
end