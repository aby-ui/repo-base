--[[
  ownerDropdown.lua
		A owner selector dropdown
--]]

local ADDON, Addon = ...
local Cache = LibStub('LibItemCache-2.0')
local Dropdown, CurrentFrame

local function OpenOwner(self)
	local name = self.value
	local info = Cache:GetOwnerInfo(name)
	if info.isguild then
		if LoadAddOn(ADDON .. '_GuildBank') then
			Addon:CreateFrame('guild'):SetOwner(name)
			Addon:ShowFrame('guild')
		end
	else
		CurrentFrame:SetOwner(name)
	end

	CloseDropDownMenus()
end

local function DeleteOwner(self)
	for i, frame in Addon:IterateFrames() do
		if self.value == frame:GetOwner() then
			frame:SetOwner(nil)
		end
	end

	Cache:DeleteOwnerInfo(self.value)
	CloseDropDownMenus()
end

local function ListOwner(name)
	local canguild = GetAddOnEnableState(UnitName('player'), ADDON .. '_GuildBank') >= 2
	local info = Cache:GetOwnerInfo(name)
	if not info.isguild or canguild then
		UIDropDownMenu_AddButton {
			text = format('|T%s:14:14:-5:0|t', Addon:GetOwnerIcon(info)) .. Addon:GetOwnerColorString(info):format(info.name),
	    checked = name == CurrentFrame:GetOwner(),
			hasArrow = info.cached,
			func = OpenOwner,
			value = name
		}
	end
end

local function UpdateDropdown(self, level)
	if level == 2 then
		UIDropDownMenu_AddButton({
			text = REMOVE,
			notCheckable = true,
			value = UIDROPDOWNMENU_MENU_VALUE,
			func = DeleteOwner
		}, 2)
	else
		ListOwner(UnitName('player'))

		for name in Cache:IterateOwners() do
			if name ~= UnitName('player') then
				ListOwner(name)
		  end
		end
	end
end

local function Startup()
	Dropdown = CreateFrame('Frame', ADDON .. 'OwnerDropdown', UIParent, 'UIDropDownMenuTemplate')
  Dropdown.initialize = UpdateDropdown
  Dropdown.displayMode = 'MENU'
  Dropdown:SetID(1)

	return Dropdown
end


--[[ Public Method ]]--

function Addon:ToggleOwnerDropdown(anchor, frame, offX, offY)
	if self:MultipleOwnersFound() then
		CurrentFrame = frame
		ToggleDropDownMenu(1, nil, Dropdown or Startup(), anchor, offX, offY)
	end
end
