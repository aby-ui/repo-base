--[[
  playerDropdown.lua
    A player selector dropdown
--]]

local ADDON, Addon = ...
local Cache = LibStub('LibItemCache-1.1')
local CurrentFrame
local Dropdown


--[[ Local Functions ]]--

local function SetPlayer(self)
    CurrentFrame:SetPlayer(self.value)
    CloseDropDownMenus()
end

local function DeletePlayer(self)
    for i, frame in Addon:IterateFrames() do
        if self.value == frame:GetPlayer() then
            frame.player = nil
            frame:SendFrameMessage('PLAYER_CHANGED')
        end
    end

    Cache:DeletePlayer(self.value)
    CloseDropDownMenus()
end

local function ShowPlayer(player)
    UIDropDownMenu_AddButton {
        text = format('|T%s:14:14:-3:0|t', Addon:GetPlayerIcon(player)) .. Addon:GetPlayerColorString(player):format(player),
        hasArrow = Cache:IsPlayerCached(player),
        checked = player == CurrentFrame:GetPlayer(),
        func = SetPlayer,
        value = player
    }
end

local function UpdateDropdown(self, level)
    if level == 2 then
        UIDropDownMenu_AddButton({
            text = REMOVE,
            notCheckable = true,
            value = UIDROPDOWNMENU_MENU_VALUE,
            func = DeletePlayer
        }, 2)
    else
		ShowPlayer(Cache.PLAYER)

        for i, player in Cache:IteratePlayers() do
			if player ~= Cache.PLAYER then
				ShowPlayer(player)
            end
        end
    end
end

local function Startup()
	Dropdown = CreateFrame('Frame', 'BagnonPlayerDropdown', UIParent, 'UIDropDownMenuTemplate')
    Dropdown.initialize = UpdateDropdown
    Dropdown.displayMode = 'MENU'
    Dropdown:SetID(1)
    
	return Dropdown
end


--[[ Public Methods ]]--

function Addon:TogglePlayerDropdown(anchor, frame, offX, offY)
    if Cache:HasCache() then
        CurrentFrame = frame
        ToggleDropDownMenu(1, nil, Dropdown or Startup(), anchor, offX, offY)
    end
end