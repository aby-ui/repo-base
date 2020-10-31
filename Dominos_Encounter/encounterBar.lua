if U1PlayerName and U1IsAddonEnabled then
    if GetAddOnEnableState(U1PlayerName, "BlizzMove")>=2 or U1IsAddonEnabled("BlizzMove") then return end
end

local PlayerPowerBarAlt = _G.PlayerPowerBarAlt
if not PlayerPowerBarAlt then return end

local _, Addon = ...
local Dominos = LibStub('AceAddon-3.0'):GetAddon('Dominos')
local EncounterBar = Dominos:CreateClass('Frame', Dominos.Frame)

function EncounterBar:New()
	local f = EncounterBar.proto.New(self, 'encounter')

	f:InitPlayerPowerBarAlt()
	f:ShowInOverrideUI(true)
	f:ShowInPetBattleUI(true)
	f:Layout()

	return f
end

function EncounterBar:GetDefaults()
	return { point = 'CENTER' }
end

-- always reparent + position the bar due to UIParent.lua moving it whenever its shown
function EncounterBar:Layout()
	local bar = self.__PlayerPowerBarAlt
	bar:ClearAllPoints()
	bar:SetParent(self)
	bar:SetPoint('CENTER', self)

	-- resize out of combat
	if not InCombatLockdown() then
		local width, height = bar:GetSize()
		local pW, pH = self:GetPadding()

		width = math.max(width, 36 * 6)
		height = math.max(height, 36)

		self:SetSize(width + pW, height + pH)
	end
end

-- grab a reference to the bar
-- and hook the scripts we need to hook
function EncounterBar:InitPlayerPowerBarAlt()
	if not self.__PlayerPowerBarAlt then
		local bar = PlayerPowerBarAlt

		if bar:GetScript('OnSizeChanged') then
			bar:HookScript('OnSizeChanged', function() self:Layout() end)
		else
			bar:SetScript('OnSizeChanged', function() self:Layout() end)
		end

		self.__PlayerPowerBarAlt = bar
	end
end

function EncounterBar:OnCreateMenu(menu)
	self:AddLayoutPanel(menu)
	self:AddAdvancedPanel(menu)
	menu:AddFadingPanel()
end

function EncounterBar:AddLayoutPanel(menu)
	local panel = menu:NewPanel(LibStub('AceLocale-3.0'):GetLocale('Dominos-Config').Layout)

	panel.scaleSlider = panel:NewScaleSlider()
	panel.paddingSlider = panel:NewPaddingSlider()

	return panel
end

function EncounterBar:AddAdvancedPanel(menu)
	local panel = menu:NewPanel(LibStub('AceLocale-3.0'):GetLocale('Dominos-Config').Advanced)

	panel:NewClickThroughCheckbox()

	return panel
end

-- module
local EncounterBarModule = Dominos:NewModule('EncounterBar', 'AceEvent-3.0')

function EncounterBarModule:Load()
	if not self.initialized then
		self.initialized = true

		-- tell blizzard that we don't it to manage this frame's position
		PlayerPowerBarAlt.ignoreFramePositionManager = true

		-- the standard UI will check to see if the power bar is user placed before
		-- doing anything to its position, so mark as user placed to prevent that
		-- from happening
		PlayerPowerBarAlt:SetMovable(true)
		PlayerPowerBarAlt:SetUserPlaced(true)

		-- onshow/hide call UpdateManagedFramePositions on the blizzard end so turn
		-- that bit off
		PlayerPowerBarAlt:SetScript("OnShow", nil)
		PlayerPowerBarAlt:SetScript("OnHide", nil)

		self:RegisterEvent("PLAYER_LOGOUT")
	end

	self.frame = Addon.EncounterBar:New()
end

function EncounterBarModule:Unload()
	self.frame:Free()
end

function EncounterBarModule:PLAYER_LOGOUT()
	-- SetUserPlaced is persistent, so revert upon logout
	PlayerPowerBarAlt:SetUserPlaced(false)
end

-- exports
Addon.EncounterBar = EncounterBar
