--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * _NPCScan.Overlay.Config.lua - Adds a configuration pane to enable and      *
  *   disable display modules like the WorldMap and BattlefieldMinimap.        *
  ****************************************************************************]]

 -------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local FOLDER_NAME, private = ...
local L = private.L
local panel = _G.CreateFrame("Frame", "_NPCScanOverlayConfig")
private.Config = panel


local ModuleMethods = setmetatable({}, getmetatable(panel))
panel.ModuleMeta = {__index = ModuleMethods;}

local IsChildAddOn = IsAddOnLoaded("_NPCScan")

--- Adds a control to the module to automatically be enabled and disabled.
function ModuleMethods:AddControl(Control)
	self[#self + 1] = Control
	Control:SetEnabled(self.Module.Registered and self.Enabled:GetChecked())
end


do
	--- Enables/disables all registered controls.
	local function SetControlsEnabled(Config, Enabled)
		for _, Control in ipairs(Config) do
			Control:SetEnabled(Enabled)
		end
	end
	--- Sets the module's enabled checkbox and enables/disables all child controls.
	function ModuleMethods:SetEnabled(Enabled)
		self.Enabled:SetChecked(Enabled)
		if (self.Module.Registered) then
			SetControlsEnabled(self, Enabled)
		end
	end
	--- Disables the module's configuration when it gets unregistered.
	function ModuleMethods:Unregister()
		self.Enabled:SetEnabled(false)
		local Color = GRAY_FONT_COLOR
		_G[self:GetName().."Title"]:SetTextColor(Color.r, Color.g, Color.b)

		SetControlsEnabled(self, false)
	end
end


--- Shows the control's tooltip.
function panel:ControlOnEnter()
	if (self.tooltipText) then
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
		GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1)
	end
end


--- Standard checkbox control SetEnabled method.
function panel:ModuleCheckboxSetEnabled(Enable)
	(Enable and BlizzardOptionsPanel_CheckButton_Enable or BlizzardOptionsPanel_CheckButton_Disable)(self)
end


--- Standard slider control SetEnabled method.
function panel:ModuleSliderSetEnabled(Enable)
	(Enable and BlizzardOptionsPanel_Slider_Enable or BlizzardOptionsPanel_Slider_Disable)(self)
end


--- Toggles the module when its checkbox is clicked.
function panel:ModuleEnabledOnClick()
	local isEnabled = self:GetChecked() == true
	_G.PlaySound(isEnabled and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
	private.Modules[isEnabled and "Enable" or "Disable"](self:GetParent().Module.Name)
end


--- Sets a module's alpha setting when its slider gets adjusted.
function panel:ModuleAlphaOnValueChanged(Value)
	private.Modules.SetAlpha(self:GetParent().Module.Name, Value)
end


do
	local LastFrame
	--- Creates a config entry for a module with basic controls.
	-- @return Settings frame for module.
	function panel.ModuleRegister(Module, Label)
		local Frame = CreateFrame("Frame", "_NPCScanOverlayModule"..Module.Name, panel.ScrollChild, "OptionsBoxTemplate")
		Frame.Module = Module
		setmetatable(Frame, panel.ModuleMeta)

		_G[Frame:GetName().."Title"]:SetText(Label)
		Frame:SetPoint("RIGHT", panel.ScrollChild:GetParent(), -4, 0)
		if (LastFrame) then
			Frame:SetPoint("TOPLEFT", LastFrame, "BOTTOMLEFT", 0, -16)
		else
			Frame:SetPoint("TOPLEFT", 4, -14)
		end
		LastFrame = Frame

		local Enabled = CreateFrame("CheckButton", "$parentEnabled", Frame, "UICheckButtonTemplate")
		Frame.Enabled = Enabled
		Enabled:SetPoint("TOPLEFT", 6, -6)
		Enabled:SetSize(26, 26)
		Enabled:SetScript("OnClick", panel.ModuleEnabledOnClick)
		local Label = _G[Enabled:GetName().."Text"]
		Label:SetText(L.CONFIG_ENABLE)
		Enabled:SetHitRectInsets(4, 4 - Label:GetStringWidth(), 4, 4)
		Enabled.SetEnabled = panel.ModuleCheckboxSetEnabled

		local Alpha = CreateFrame("Slider", "$parentAlpha", Frame, "OptionsSliderTemplate")
		Frame.Alpha = Alpha
		Alpha:SetPoint("TOP", 0, -16)
		Alpha:SetPoint("RIGHT", -8, 0)
		Alpha:SetPoint("LEFT", Label, "RIGHT", 16, 0)
		Alpha:SetMinMaxValues(0, 1)
		Alpha:SetScript("OnValueChanged", panel.ModuleAlphaOnValueChanged)
		Alpha.SetEnabled = panel.ModuleSliderSetEnabled
		local AlphaName = Alpha:GetName()
		_G[AlphaName.."Text"]:SetText(L.CONFIG_ALPHA)
		_G[AlphaName.."Low"]:Hide()
		_G[AlphaName.."High"]:Hide()
		Frame:AddControl(Alpha)

		Frame:SetHeight(Alpha:GetHeight() + 16 + 4)
		return Frame
	end
end


--- Reverts to default options.
function panel:default()
	private.Synchronize()
end


--- Slash command chat handler to open the options pane.
function panel.SlashCommand()
	InterfaceOptionsFrame_OpenToCategory(panel)
end


local Label = L[IsChildAddOn and "CONFIG_TITLE" or "CONFIG_TITLE_STANDALONE"]
panel.name = Label
panel:Hide()

-- Pane title
panel.Title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
panel.Title:SetPoint("TOPLEFT", 16, -16)
panel.Title:SetText(Label)

panel.SubText = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
panel.SubText:SetPoint("TOPLEFT", panel.Title, "BOTTOMLEFT", 0, -8)
panel.SubText:SetPoint("RIGHT", -32, 0)
panel.SubText:SetHeight(32)
panel.SubText:SetJustifyH("LEFT")
panel.SubText:SetJustifyV("TOP")
panel.SubText:SetText(L.CONFIG_DESC)

-- Minimap Icon Checkbox
panel.MiniMapIcon = CreateFrame("CheckButton", "$parentMinimapIconCheckbox", panel, "InterfaceOptionsCheckButtonTemplate")
panel.MiniMapIcon:SetPoint("TOPLEFT", panel.SubText, "BOTTOMLEFT", -2, -8)
_G[panel.MiniMapIcon:GetName().."Text"]:SetText(L.CONFIG_MINIMAPICON)
panel.MiniMapIcon.tooltipText = L.CONFIG_MINIMAPICON_DESC


L.CONFIG_MOUSEOVERTEXT_DESC = "Note: This may interfear with other map tooltips"
L.CONFIG_MOUSEOVERTEXT = "Show Mob Name on Map Path Mouse Over"
-- Mouseover Text Checkbox
panel.MouseoverText = CreateFrame("CheckButton", "$parentMouseoverTextCheckbox", panel, "InterfaceOptionsCheckButtonTemplate")
panel.MouseoverText:SetPoint("LEFT", panel.MiniMapIcon, "RIGHT", _G[panel.MiniMapIcon:GetName().."Text"]:GetStringWidth() + 25, 0)
--panel.MouseoverText:SetPoint("TOPLEFT", panel.SubText, "BOTTOMLEFT", 25, 0)
_G[panel.MouseoverText:GetName().."Text"]:SetText(L.CONFIG_MOUSEOVERTEXT)
panel.MouseoverText.tooltipText = L.CONFIG_MOUSEOVERTEXT_DESC


-- Path Show All Checkbox
panel.ShowAll = CreateFrame("CheckButton", "$parentShowAllCheckbox", panel, "InterfaceOptionsCheckButtonTemplate")
panel.ShowAll:SetPoint("TOPLEFT", panel.MiniMapIcon, "BOTTOMLEFT", 0, -8)
_G[panel.ShowAll:GetName().."Text"]:SetText(L.CONFIG_SHOWALL)
panel.ShowAll.tooltipText = L.CONFIG_SHOWALL_DESC

-- Key Key Movement Swap Checkbox
panel.LockSwap = CreateFrame("CheckButton", "$parentSwapCheckbox", panel, "InterfaceOptionsCheckButtonTemplate")
panel.LockSwap:SetPoint("TOPLEFT", panel.ShowAll, "BOTTOMLEFT", 0, -8)
_G[panel.LockSwap:GetName().."Text"]:SetText(L.CONFIG_LOCKSWAP)
panel.LockSwap.tooltipText = L.CONFIG_LOCKSWAP_DESC

--Key Auto Hide Checkbox
panel.KeyAutoHide = CreateFrame("CheckButton", "$parentKeyAutoHideCheckbox", panel, "InterfaceOptionsCheckButtonTemplate")
panel.KeyAutoHide:SetPoint("TOPLEFT", panel.LockSwap, "BOTTOMLEFT", 0, -8)
_G[panel.KeyAutoHide:GetName().."Text"]:SetText(L.CONFIG_KEYAUTOHIDE)
panel.KeyAutoHide.tooltipText = L.CONFIG_KEYAUTOHIDE_DESC

-- Key Alpha Slider
panel.KeyAutoHideAlpha = CreateFrame("Slider", "$parentKeyAutoHideAlphaSlider", panel, "OptionsSliderTemplate")
panel.KeyAutoHideAlpha:SetMinMaxValues(.25, 1)
panel.KeyAutoHideAlpha:SetScript("OnValueChanged", function(self, Value)
	private.Options.KeyAutoHideAlpha = Value
	panel.KeyAutoHideAlpha.setFunc(Value)
	end)
local PanelName = panel.KeyAutoHideAlpha:GetName()
_G[PanelName.."Text"]:SetText(L.CONFIG_ALPHA)
_G[PanelName.."Text"]:SetFontObject("GameFontNormalSmall")
_G[PanelName.."Low"]:SetText("25%")
_G[PanelName.."High"]:SetText("100%")
panel.KeyAutoHideAlpha:SetEnabled(true)
panel.KeyAutoHideAlpha:SetPoint("LEFT", panel.KeyAutoHide, "RIGHT", _G[panel.KeyAutoHide:GetName().."Text"]:GetStringWidth() + 25, 0)

-- Key Size Text
panel.KeySizeTitle = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightLeft")
panel.KeySizeTitle:SetPoint("TOPLEFT", panel.KeyAutoHide, "BOTTOMLEFT", 5, -25)
panel.KeySizeTitle:SetText(L.CONFIG_KEYMAXHEIGHT)

-- Key Size Slider
panel.KeySize = CreateFrame("Slider", "$parentKeySizeSlider", panel, "OptionsSliderTemplate")
panel.KeySize:SetMinMaxValues(.25, .85)
panel.KeySize:SetScript("OnValueChanged", function(self, Value)
	private.Options.KeyMaxSize = Value
	panel.KeySize.setFunc(Value)
	end)
local KeyName = panel.KeySize:GetName()
_G[KeyName.."Text"]:SetText(L.CONFIG_MAP_PERCENT)
_G[KeyName.."Text"]:SetFontObject("GameFontNormalSmall")
_G[KeyName.."Low"]:SetText("25%")
_G[KeyName.."High"]:SetText("100%")
panel.KeySize:SetEnabled(true)
panel.KeySize:SetPoint("LEFT", panel.KeySizeTitle, "RIGHT", 10, 0)

-- Key Font Dropdown
panel.KeyFont = _G.CreateFrame("Frame", "%parentFontDropdown", panel, "UIDropDownMenuTemplate")
panel.KeyFont:SetPoint("TOPLEFT", panel.KeySizeTitle, "BOTTOMLEFT", -10, -30)
UIDropDownMenu_SetWidth(panel.KeyFont, 200)
panel.KeyFont:EnableMouse(true)

_G.UIDropDownMenu_JustifyText(panel.KeyFont, "LEFT")

panel.KeyFont.Button = _G[panel.KeyFont:GetName() .. "Button"]
_G.UIDropDownMenu_SetAnchor(panel.KeyFont, 0, 0, "TOPLEFT", panel.KeyFont.Button, "TOPRIGHT")

_G[panel.KeyFont:GetName() .. "Middle"]:SetPoint("RIGHT", -16, 0)

local LSM = _G.LibStub("LibSharedMedia-3.0")

do
	local function Entry_OnSelect(info_table, font)
		private.SetPanelFont(font, private.Options.KeyFontSize)
		_G.UIDropDownMenu_SetText(panel.KeyFont, font == private.DEFAULT_FONT_NAME and "Default" or font)
		ToggleDropDownMenu(nil, nil, panel.KeyFont)
		private.forceKeyUpdate = true
	end


	local SORTED_GROUPS = { "A_E", "F_J", "K_O", "P_T", "U_Z", "0_9", }
	local GROUPS = {}
	local DISPLAY_TO_GROUP_MAP = {}
	for index = 1, #SORTED_GROUPS do
		local group_key = SORTED_GROUPS[index]
		GROUPS[group_key] = {}
		DISPLAY_TO_GROUP_MAP[group_key:gsub("_", "-")] = group_key
	end

	local GROUPINGS = {
		a = GROUPS.A_E,
		b = GROUPS.A_E,
		c = GROUPS.A_E,
		d = GROUPS.A_E,
		e = GROUPS.A_E,
		f = GROUPS.F_J,
		g = GROUPS.F_J,
		h = GROUPS.F_J,
		i = GROUPS.F_J,
		j = GROUPS.F_J,
		k = GROUPS.K_O,
		l = GROUPS.K_O,
		m = GROUPS.K_O,
		n = GROUPS.K_O,
		o = GROUPS.K_O,
		p = GROUPS.P_T,
		q = GROUPS.P_T,
		r = GROUPS.P_T,
		s = GROUPS.P_T,
		t = GROUPS.P_T,
		u = GROUPS.U_Z,
		v = GROUPS.U_Z,
		w = GROUPS.U_Z,
		x = GROUPS.U_Z,
		y = GROUPS.U_Z,
		z = GROUPS.U_Z,
		["1"] = GROUPS["0_9"],
		["2"] = GROUPS["0_9"],
		["3"] = GROUPS["0_9"],
		["4"] = GROUPS["0_9"],
		["5"] = GROUPS["0_9"],
		["6"] = GROUPS["0_9"],
		["7"] = GROUPS["0_9"],
		["8"] = GROUPS["0_9"],
		["9"] = GROUPS["0_9"],
		["0"] = GROUPS["0_9"],
	}

	function panel.KeyFont:initialize(level)
		if not level then
			return
		end
		local current_font = private.Options.KeyFont
		local info = _G.UIDropDownMenu_CreateInfo()


		if level == 1 then
			info.func = Entry_OnSelect
			info.text = "Default"
			info.arg1 = private.DEFAULT_FONT_NAME
			info.checked = current_font == private.DEFAULT_FONT_NAME
			info.fontObject = private.DEFAULT_FONT_NAME
			_G.UIDropDownMenu_AddButton(info, level)

			for group, data in pairs(GROUPS) do
				table.wipe(data)
			end

			local media_list = LSM:List(LSM.MediaType.FONT)
			for index = 1, #media_list do
				local key = media_list[index]
				local grouping = GROUPINGS[key:sub(1, 1):lower()]


				if grouping then
					grouping[#grouping + 1] = key
				else
					info.text = key
					info.arg1 = key
					info.checked = current_font == key
					local font = CreateFont(key)
					font:SetFont(LSM:Fetch(LSM.MediaType.FONT, key), 14)
					info.fontObject = font
					_G.UIDropDownMenu_AddButton(info, level)
				end
			end
			info.func = nil

			for index = 1, #SORTED_GROUPS do
				info.text = SORTED_GROUPS[index]:gsub("_", "-")
				info.hasArrow = true
				info.notCheckable = true
				_G.UIDropDownMenu_AddButton(info, level)
			end
		else
			local group = GROUPS[DISPLAY_TO_GROUP_MAP[_G.UIDROPDOWNMENU_MENU_VALUE]]
			info.func = Entry_OnSelect

			for index = 1, #group do
				local key = group[index]
				info.text = key
				info.arg1 = key
				local font = CreateFont(key)
				font:SetFont(LSM:Fetch(LSM.MediaType.FONT, key), 14)
				info.fontObject = font
				info.checked = current_font == key
				_G.UIDropDownMenu_AddButton(info, level)
			end
		end
	end
end -- do-block

-- Font Dropdown Label
panel.KeyFont.Label = panel.KeyFont:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
panel.KeyFont.Label:SetPoint("BOTTOMLEFT", panel.KeyFont, "TOPLEFT", 16, 3)
panel.KeyFont.Label:SetText(L.CONFIG_KEY_FONT_DROPDOWN)

-- Font Size Slider
panel.KeyFontSize = CreateFrame("Slider", "$parentFontSizeSlider", panel, "OptionsSliderTemplate")
panel.KeyFontSize:SetMinMaxValues(7, 25)
panel.KeyFontSize:SetScript("OnValueChanged", function(self, Value)
	private.SetPanelFont(private.Options.KeyFont, Value)
	private.forceKeyUpdate = true
	end)

local PanelName = panel.KeyFontSize:GetName()
_G[PanelName.."Text"]:SetText(L.CONFIG_KEY_FONT_SIDE)
_G[PanelName.."Text"]:SetFontObject("GameFontNormalSmall")
_G[PanelName.."Low"]:SetText("7")
_G[PanelName.."High"]:SetText("25")
panel.KeyFontSize:SetEnabled(true)
panel.KeyFontSize:SetPoint("LEFT", panel.KeyFont, "RIGHT",  25, 0)

-- Set Color Button
panel.SetColor = CreateFrame("Button", "$parentSetColorButton", panel, "UIPanelButtonTemplate")
panel.SetColor:SetPoint("TOPLEFT", panel.KeyFont, "BOTTOMLEFT", -2, -12)
_G[panel.SetColor:GetName().."Text"]:SetText(L.CONFIG_SETCOLOR)
panel.SetColor:SetScript("OnClick", function() _NPCScanOverlayPathColorList:Show()end)
panel.SetColor:SetHeight(32)
panel.SetColor:SetWidth(150)
panel.SetColor.tooltipText = L.CONFIG_SETCOLOR_DESC

-- Module Options Scrollframe
local Background = CreateFrame("Frame", nil, panel, "OptionsBoxTemplate")
Background:SetPoint("TOPLEFT", panel.SetColor, "BOTTOMLEFT", 0, -8)
Background:SetPoint("BOTTOMRIGHT", -32, 16)
local Texture = Background:CreateTexture(nil, "BACKGROUND")
Texture:SetTexture(0, 0, 0, 0.5)
Texture:SetPoint("BOTTOMLEFT", 5, 5)
Texture:SetPoint("TOPRIGHT", -5, -5)

local ScrollFrame = CreateFrame("ScrollFrame", "_NPCScanOverlayScrollFrame", Background, "UIPanelScrollFrameTemplate")
ScrollFrame:SetPoint("TOPLEFT", 4, -4)
ScrollFrame:SetPoint("BOTTOMRIGHT", -4, 4)

panel.ScrollChild = CreateFrame("Frame")
ScrollFrame:SetScrollChild(panel.ScrollChild)
panel.ScrollChild:SetSize(1, 1)

--- Sets the ShowAll option when its checkbox is clicked.
function panel.ShowAll.setFunc(Enable)
	Enable = (Enable == "1")
		if Enable == true then
		-- Update all affected maps
		for Map, MapData in pairs(private.PathData) do
			-- If a map has a disabled path, it must be redrawn
			for NpcID in pairs(MapData) do
				if not private.NPCCounts[NpcID] then
					private.Modules.UpdateMap(Map)
					break
				end
			end
		end
	end
	private.Options.ShowAll = Enable
end

function panel.MouseoverText.setFunc(Enable)
	private.Options.MouseoverText = (Enable == "1")
end


--- Sets the MiniMapIcon option when its checkbox is clicked.
function panel.MiniMapIcon.setFunc(Hide)
	Hide = (Hide == "1")
	private.Options.MiniMapIcon.hide = Hide

	if Hide == true then
		private.LDBI:Hide(FOLDER_NAME)
	else
		private.LDBI:Show(FOLDER_NAME)
	end
end


--- Sets the LockSwap option when its checkbox is clicked.
function panel.LockSwap.setFunc(Enable)
	private.Options.LockSwap = (Enable == "1")
end


--- Sets the KeyAutoHide option when its checkbox is clicked.
function panel.KeyAutoHide.setFunc(Enable)
	private.Options.KeyAutoHide = (Enable == "1")
end


--- Sets the KeySize Slider Value.
function panel.KeySize.setFunc(Value)
	panel.KeySize:SetValue(Value)
end

--- Sets the KeyAutoHideAlpha Slider Value.
function panel.KeyAutoHideAlpha.setFunc(Value)
	panel.KeyAutoHideAlpha:SetValue(Value)
end








-------------------------------------------------------------------------------
-- Panel methods.
-------------------------------------------------------------------------------
function panel:ControlOnEnter()
	_G.GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
	_G.GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, 1)
end

function private.SetPanelFont(fontname, fontsize)
	-- a couple of arg checks to avoid unpleasant things...
	if not fontname then fontname = private.DEFAULT_FONT end
	if not fontsize then fontsize = private.DEFAULT_FONT_SIZE end
	private.Options.KeyFont = fontname
	private.Options.KeyFontSize = fontsize

	local newfont = LSM:Fetch("font", fontname)
		_G._NPCScanOverlayWorldMapKeyFont:SetFont(newfont, fontsize);

end


--]]








if (IsChildAddOn) then
	panel.parent = assert(_NPCScan.Config.name, "Couldn't parent configuration to _NPCScan.")
end
InterfaceOptions_AddCategory(panel)

SlashCmdList["_NPCSCAN_OVERLAY"] = panel.SlashCommand
