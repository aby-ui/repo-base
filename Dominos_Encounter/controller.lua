local PlayerPowerBarAlt = _G.PlayerPowerBarAlt
if not PlayerPowerBarAlt then return end

if U1PlayerName and U1IsAddonEnabled then
    if GetAddOnEnableState(U1PlayerName, "BlizzMove")>=2 or U1IsAddonEnabled("BlizzMove") then return end
end

local _, Addon = ...
local EncounterBarModule = _G.Dominos:NewModule('EncounterBar', 'AceEvent-3.0')

function EncounterBarModule:OnInitialize()
	-- the standard UI will check to see if the power bar is user placed before
	-- doing anything to its position, so mark as user placed to prevent that
	-- from ahppening
	PlayerPowerBarAlt:SetMovable(true)
	PlayerPowerBarAlt:SetUserPlaced(true)

	-- tell blizzard that we don't it to manage this frame's position
	PlayerPowerBarAlt.ignoreFramePositionManager = true

	-- onshow/hide call UpdateManagedFramePositions on the blizzard end so turn
	-- that bit off
	PlayerPowerBarAlt:SetScript("OnShow", nil)
	PlayerPowerBarAlt:SetScript("OnHide", nil)

	self:RegisterEvent("PLAYER_LOGOUT")
end

function EncounterBarModule:PLAYER_LOGOUT()
	-- SetUserPlaced is persistent, so revert upon logout
	PlayerPowerBarAlt:SetUserPlaced(false)
end

function EncounterBarModule:Load()
	self.frame = Addon.EncounterBar:New()
end

function EncounterBarModule:Unload()
	self.frame:Free()
end