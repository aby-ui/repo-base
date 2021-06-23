-----------------------------------------------------------------------
--- Provides several dropdown item types that can be used with AceGUI-3.0's
-- AceGUIWidget-DropDown in order to style font, statusbar and sound-dropdowns
-- properly, making it easier for the user to select the preferred item.
--
-- LibDDI can also be used with AceConfig option tables with the 'select' type,
-- using the itemControl property.
--
-- The following item types are available: DDI-Font, DDI-Statusbar, DDI-Sound and DDI-RaidIcon.
--
-- Pull LibDDI-1.0 in via your TOC/embeds.xml and make sure it's loaded after
-- AceGUI-3.0 and LibSharedMedia-3.0, and it's ready to be used. There's no real
-- API; LibDDI just provides a few widget types for AceGUI.
--
-- @usage
-- -- If you're using AceOptions tables;
-- local fonts = LibStub("LibSharedMedia-3.0"):List("font")
-- local option = {
--   type = "select",
--   name = "Font",
--   values = fonts,
--   get = function()
--     for i, v in next, fonts do
--       if v == db.font then return i end
--     end
--   end,
--   set = function(_, value)
--     db.font = fonts[value]
--   end,
--   itemControl = "DDI-Font",
-- }
-- -- If you're using AceGUI-3.0 directly;
-- local dropdown = AceGUI:Create("Dropdown")
-- dropdown:SetLabel("Font")
-- dropdown:SetList(fonts, nil, "DDI-Font")
-- dropdown:SetCallback("OnValueChanged", function(_, _, value)
--   db.font = fonts[value]
-- end)
-- for i, v in next, fonts do
--   if v == db.font then
--     dropdown:SetValue(i)
--     break
--   end
-- end
-- @class file
-- @name LibDDI-1.0

local ddiVersion = 2
local prototype = LibStub("AceGUI-3.0-DropDown-ItemBase"):GetItemBase()
local version = ddiVersion + prototype.version

if _G.AGUILSMDDI10 and _G.AGUILSMDDI10 >= version then return end
_G.AGUILSMDDI10 = version

local media = LibStub("LibSharedMedia-3.0")
local gui = LibStub("AceGUI-3.0")

-----------------------------------------------------------------------
-- Common
--

local function updateToggle(self)
	if self.value then
		self.check:Show()
	else
		self.check:Hide()
	end
end
local function onRelease(self)
	prototype.OnRelease(self)
	self:SetValue(nil)
end
local function onClick(frame)
	local self = frame.obj
	if self.disabled then return end
	self.value = not self.value
	if self.value then
		PlaySound(856) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON
	else
		PlaySound(857) -- SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF
	end
	updateToggle(self)
	self:Fire("OnValueChanged", self.value)
end
local function setValue(self, value)
	self.value = value
	updateToggle(self)
end
local function getValue(self)
	return self.value
end
local function commonConstructor(type)
	local self = prototype.Create(type)
	self.frame:SetScript("OnClick", onClick)
	self.SetValue = setValue
	self.GetValue = getValue
	self.OnRelease = onRelease
	return self
end

-----------------------------------------------------------------------
-- Raid icon
--

do
	local icons = {
		[RAID_TARGET_1] = 1, Star = 1,
		[RAID_TARGET_2] = 2, Circle = 2, Orange = 2, Nipple = 2,
		[RAID_TARGET_3] = 3, Diamond = 3,
		[RAID_TARGET_4] = 4, Triangle = 4,
		[RAID_TARGET_5] = 5, Moon = 5,
		[RAID_TARGET_6] = 6, Square = 6,
		[RAID_TARGET_7] = 7, Cross = 7,
		[RAID_TARGET_8] = 8, Skull = 8,
	}
	local widgetType = "DDI-RaidIcon"
	local function setText(self, text)
		if icons[text] then
			self.icon:SetTexture(icons[text] + 137000) -- Texture id list for raid icons 1-8 is 137001-137008. Base texture path is Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_%d
		else
			self.icon:SetTexture()
		end
		self.text:SetText(text)
	end
	local function constructor()
		local self = commonConstructor(widgetType)
		local frame = self.frame

		local icon = frame:CreateTexture(nil, "ARTWORK")
		icon:SetWidth(16)
		icon:SetHeight(16)
		icon:SetPoint("LEFT", frame, "LEFT", 18, 0)
		self.icon = icon

		local text = self.text
		text:ClearAllPoints()
		text:SetPoint("LEFT", icon, "RIGHT", 4, 0)
		text:SetPoint("RIGHT", frame, "RIGHT", -8, 0)
		text:SetPoint("TOP", frame)
		text:SetPoint("BOTTOM", frame)

		self.SetText = setText
		gui:RegisterAsWidget(self)
		return self
	end
	gui:RegisterWidgetType(widgetType, constructor, version)
end

-----------------------------------------------------------------------
-- Sound
--

do
	local widgetType = "DDI-Sound"
	local function onClick(self)
		local snd = media:Fetch("sound", self.sound:GetText())
		if snd then PlaySoundFile(snd, "Master") end
	end
	local function constructor()
		local self = commonConstructor(widgetType)
		local frame = self.frame

		local sndButton = CreateFrame("Button", nil, frame)
		sndButton:SetWidth(16)
		sndButton:SetHeight(16)
		sndButton:SetPoint("RIGHT", frame, "RIGHT", -3, -1)
		sndButton:SetScript("OnClick", onClick)
		sndButton.sound = frame.obj.text

		local icon = sndButton:CreateTexture(nil, "BACKGROUND")
		icon:SetTexture(130979) --"Interface\\Common\\VoiceChat-Speaker"
		icon:SetAllPoints(sndButton)

		local highlight = sndButton:CreateTexture(nil, "HIGHLIGHT")
		highlight:SetTexture(130977) --"Interface\\Common\\VoiceChat-On"
		highlight:SetAllPoints(sndButton)

		gui:RegisterAsWidget(self)
		return self
	end
	gui:RegisterWidgetType(widgetType, constructor, version)
end

-----------------------------------------------------------------------
-- Font
--

do
	local widgetType = "DDI-Font"
	local function setText(self, text)
		local _, size, flags = self.text:GetFont()
		local font = media:Fetch("font", text)
		if font then self.text:SetFont(font, size, flags) end
		self.text:SetText(text)
	end
	local function constructor()
		local self = commonConstructor(widgetType)
		self.SetText = setText
		gui:RegisterAsWidget(self)
		return self
	end
	gui:RegisterWidgetType(widgetType, constructor, version)
end

-----------------------------------------------------------------------
-- Statusbar
--

do
	local widgetType = "DDI-Statusbar"
	local function setText(self, text)
		self.text:SetText(text)
		local texture = media:Fetch("statusbar", text)
		if texture then self.bar:SetTexture(texture) end
	end
	local function constructor()
		local self = commonConstructor(widgetType)
		local frame = self.frame

		local bar = frame:CreateTexture(nil, "ARTWORK")
		bar:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -1)
		bar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 1)
		self.bar = bar

		self.SetText = setText
		gui:RegisterAsWidget(self)
		return self
	end
	gui:RegisterWidgetType(widgetType, constructor, version)
end

