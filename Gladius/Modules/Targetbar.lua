local Gladius = _G.Gladius
if not Gladius then
	DEFAULT_CHAT_FRAME:AddMessage(format("Module %s requires Gladius", "Target Bar"))
end
local L = Gladius.L
local LSM

-- Global Functions
local pairs = pairs
local select = select
local strfind = string.find
local unpack = unpack

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local UnitClass = UnitClass
local UnitGUID = UnitGUID
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax

local CLASS_BUTTONS = CLASS_ICON_TCOORDS
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

local TargetBar = Gladius:NewModule("TargetBar", true, true, {
	targetBarAttachTo = "Trinket",
	targetBarEnableBar = true,
	targetBarHeight = 30,
	targetBarAdjustWidth = true,
	targetBarWidth = 200,
	targetBarInverse = false,
	targetBarColor = {r = 1, g = 1, b = 1, a = 1},
	targetBarClassColor = true,
	targetBarBackgroundColor = {r = 1, g = 1, b = 1, a = 0.3},
	targetBarTexture = "Minimalist",
	targetBarIconPosition = "LEFT",
	targetBarIcon = true,
	targetBarIconCrop = false,
	targetBarOffsetX = 10,
	targetBarOffsetY = 0,
	targetBarAnchor = "TOPLEFT",
	targetBarRelativePoint = "TOPRIGHT",
},
{
	"Target bar with class ", "Class icon on health bar"
})

function TargetBar:OnInitialize()
	-- init frames
	self.frame = { }
end

function TargetBar:OnEnable()
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("UNIT_MAXHEALTH", "UNIT_HEALTH")
	self:RegisterEvent("UNIT_TARGET")
	LSM = Gladius.LSM
	-- set frame type
	if (Gladius.db.targetBarAttachTo == "Frame" or strfind(Gladius.db.targetBarRelativePoint, "BOTTOM")) then
		self.isBar = true
	else
		self.isBar = false
	end
	if not self.frame then
		self.frame = { }
	end
end

function TargetBar:OnDisable()
	self:UnregisterAllEvents()
	for unit in pairs(self.frame) do
		self.frame[unit].frame:SetAlpha(0)
	end
end

--[[function TargetBar:SetTemplate(template)
	if template == 1 then
		-- reset width
		if Gladius.db.targetBarAttachTo == "HealthBar" and not Gladius.db.healthBarAdjustWidth then
			Gladius.db.healthBarAdjustWidth = true
		end
		-- reset to default
		for k, v in pairs(self.defaults) do
			Gladius.db[k] = v
		end
	else
		if Gladius.db.modules["HealthBar"] then
			if Gladius.db.healthBarAdjustWidth then
				Gladius.db.healthBarAdjustWidth = false
				Gladius.db.healthBarWidth = Gladius.db.barWidth - Gladius.db.healthBarHeight
			else
				Gladius.db.healthBarWidth = Gladius.db.healthBarWidth - Gladius.db.healthBarHeight
			end
			Gladius.db.targetBarEnableBar = false
			Gladius.db.targetBarIcon = true
			Gladius.db.targetBarHeight = Gladius.db.healthBarHeight
			Gladius.db.targetBarAttachTo = "HealthBar"
			Gladius.db.targetBarAnchor = "TOPLEFT"
			Gladius.db.targetBarRelativePoint = "TOPRIGHT"
			Gladius.db.targetBarOffsetX = 0
			Gladius.db.targetBarOffsetY = 0
		end
	end
	-- set frame type
	if (Gladius.db.targetBarAttachTo == "Frame" or strfind(Gladius.db.targetBarRelativePoint, "BOTTOM")) then
		self.isBar = true
	else
		self.isBar = false
	end
end]]

function TargetBar:GetAttachTo()
	return Gladius.db.targetBarAttachTo
end

function TargetBar:GetFrame(unit)
	return self.frame[unit].frame
end

function TargetBar:SetClassIcon(unit)
	if not self.frame[unit] then
		return
	end
	self.frame[unit]:Hide()
	self.frame[unit].icon:Hide()
	-- get unit class
	local class
	if not Gladius.test then
		class = select(2, UnitClass(unit.."target"))
	else
		class = Gladius.testing[unit].unitClass
	end
	if class then
		-- color
		local colorx = self:GetBarColor(class)
		if not colorx then
			-- fallback, when targeting a pet or totem
			colorx = Gladius.db.targetBarColor
		end
		self.frame[unit]:SetStatusBarColor(colorx.r, colorx.g, colorx.b, colorx.a or 1)
		local healthx, maxHealthx = UnitHealth(unit.."target"), UnitHealthMax(unit.."target")
		self:UpdateHealth(unit, healthx, maxHealthx)
		self.frame[unit].icon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
		local left, right, top, bottom = unpack(CLASS_BUTTONS[class])
		if Gladius.db.targetBarIconCrop then
			-- zoom class icon
			left = left + (right - left) * 0.075
			right = right - (right - left) * 0.075
			top = top + (bottom - top) * 0.075
			bottom = bottom - (bottom - top) * 0.075
		end
		self.frame[unit]:Show()
		self.frame[unit].icon:Show()
		self.frame[unit].icon:SetTexCoord(left, right, top, bottom)
	end
end

function TargetBar:UNIT_TARGET(event, unit)
	self:SetClassIcon(unit)
end

function TargetBar:UNIT_HEALTH(event, unit)
	if not unit then
		return
	end
	local foundUnit = nil
	for u, _ in pairs(self.frame) do
		if UnitGUID(unit) == UnitGUID(u.."target") then
			foundUnit = u
		end
	end
	if not foundUnit then
		return
	end
	local health, maxHealth = UnitHealth(foundUnit.."target"), UnitHealthMax(foundUnit.."target")
	self:UpdateHealth(foundUnit, health, maxHealth)
end

function TargetBar:UpdateHealth(unit, health, maxHealth)
	if not self.frame[unit] then
		if not Gladius.buttons[unit] then
			Gladius:UpdateUnit(unit)
		else
			self:Update(unit)
		end
	end
	-- update min max values
	self.frame[unit]:SetMinMaxValues(0, maxHealth)
	-- inverse bar
	if Gladius.db.targetBarInverse then
		self.frame[unit]:SetValue(maxHealth - health)
	else
		self.frame[unit]:SetValue(health)
	end
end

function TargetBar:UpdateColors(unit)
	local testing = Gladius.test
	-- get unit class
	local class
	if not testing then
		class = select(2, UnitClass(unit.."target"))
	else
		class = Gladius.testing[unit].unitClass
	end
	-- set color
	if not Gladius.db.targetBarClassColor then
		local color = Gladius.db.targetBarColor
		self.frame[unit]:SetStatusBarColor(color.r, color.g, color.b, color.a)
	else
		local color = self:GetBarColor(class)
		if not color then
			-- fallback, when targeting a pet or totem
			color = Gladius.db.targetBarColor
		end
		self.frame[unit]:SetStatusBarColor(color.r, color.g, color.b, color.a or 1)
	end
	self.frame[unit].background:SetVertexColor(Gladius.db.targetBarBackgroundColor.r, Gladius.db.targetBarBackgroundColor.g, Gladius.db.targetBarBackgroundColor.b, Gladius.db.targetBarBackgroundColor.a)
end

function TargetBar:CreateBar(unit)
	local button = Gladius.buttons[unit]
	if not button then
		return
	end
	-- create bar + text
	self.frame[unit] = CreateFrame("StatusBar", "Gladius"..self.name.."Bar"..unit, button)
	self.frame[unit].frame = CreateFrame("Frame", "Gladius"..self.name..unit, button)
	self.frame[unit]:SetParent(self.frame[unit].frame)
	self.frame[unit].secure = CreateFrame("Button", "Gladius"..self.name.."Secure"..unit, self.frame[unit].frame, "SecureActionButtonTemplate")
	self.frame[unit].background = self.frame[unit]:CreateTexture("Gladius"..self.name..unit.."Background", "BACKGROUND")
	self.frame[unit].highlight = self.frame[unit]:CreateTexture("Gladius"..self.name.."Highlight"..unit, "OVERLAY")
	self.frame[unit].icon = self.frame[unit].frame:CreateTexture("Gladius"..self.name.."IconFrame"..unit, "ARTWORK")
	self.frame[unit].unit = unit.."target"
end

function TargetBar:Update(unit)
	-- check parent module
	if not Gladius:GetModule(Gladius.db.castBarAttachTo) then
		if self.frame[unit] then
			self.frame[unit].frame:Hide()
		end
		return
	end
	-- create power bar
	if not self.frame[unit] then
		self:CreateBar(unit)
	end
	-- set bar type
	local parent = Gladius:GetParent(unit, Gladius.db.targetBarAttachTo)
	-- set frame type
	if Gladius.db.targetBarAttachTo == "Frame" or strfind(Gladius.db.targetBarRelativePoint, "BOTTOM") then
		self.isBar = true
	else
		self.isBar = false
	end
	-- update health bar
	self.frame[unit].frame:ClearAllPoints()
	local width = 1
	if Gladius.db.targetBarEnableBar then
		width = Gladius.db.targetBarAdjustWidth and Gladius.dbWidth or Gladius.db.targetBarWidth
		-- add width of the widget if attached to an widget
		if Gladius.db.targetBarAttachTo ~= "Frame" and not strfind(Gladius.db.targetBarRelativePoint, "BOTTOM") and Gladius.db.targetBarAdjustWidth then
			if not Gladius:GetModule(Gladius.db.targetBarAttachTo).frame[unit] then
				Gladius:GetModule(Gladius.db.targetBarAttachTo):Update(unit)
			end
			width = width + Gladius:GetModule(Gladius.db.targetBarAttachTo).frame[unit]:GetWidth()
		end
	end
	self.frame[unit].frame:SetHeight(Gladius.db.targetBarHeight)
	self.frame[unit].frame:SetHeight(Gladius.db.targetBarHeight)
	if Gladius.db.targetBarIcon then
		width = width + self.frame[unit].frame:GetHeight()
	end
	self.frame[unit].frame:SetWidth(width)
	self.frame[unit].frame:SetPoint(Gladius.db.targetBarAnchor, parent, Gladius.db.targetBarRelativePoint, Gladius.db.targetBarOffsetX, Gladius.db.targetBarOffsetY)
	-- update icon
	self.frame[unit].icon:ClearAllPoints()
	if Gladius.db.targetBarIcon then
		self.frame[unit].icon:SetPoint(Gladius.db.targetBarIconPosition, self.frame[unit].frame, Gladius.db.targetBarIconPosition)
		self.frame[unit].icon:SetWidth(self.frame[unit].frame:GetHeight())
		self.frame[unit].icon:SetHeight(self.frame[unit].frame:GetHeight())
		self.frame[unit].icon:SetTexCoord(0, 1, 0, 1)
		self.frame[unit].icon:SetAlpha(1)
		self.frame[unit].icon:Show()
	else
		self.frame[unit].icon:SetAlpha(0)
		self.frame[unit].icon:Hide()
	end
	if Gladius.db.targetBarEnableBar then
		self.frame[unit]:ClearAllPoints()
		if Gladius.db.targetBarIcon and Gladius.db.targetBarIconPosition == "LEFT" then
			self.frame[unit]:SetPoint("TOPLEFT", self.frame[unit].icon, "TOPRIGHT")
		else
			self.frame[unit]:SetPoint("TOPLEFT", self.frame[unit].frame, "TOPLEFT")
		end
		self.frame[unit]:SetWidth(width)
		self.frame[unit]:SetHeight(self.frame[unit].frame:GetHeight())
		self.frame[unit]:SetMinMaxValues(0, 100)
		self.frame[unit]:SetValue(100)
		self.frame[unit]:SetStatusBarTexture(LSM:Fetch(LSM.MediaType.STATUSBAR, Gladius.db.targetBarTexture))
		-- disable tileing
		self.frame[unit]:GetStatusBarTexture():SetHorizTile(false)
		self.frame[unit]:GetStatusBarTexture():SetVertTile(false)
		-- update health bar background
		self.frame[unit].background:ClearAllPoints()
		self.frame[unit].background:SetAllPoints(self.frame[unit])
		self.frame[unit].background:SetWidth(self.frame[unit]:GetWidth())
		self.frame[unit].background:SetHeight(self.frame[unit]:GetHeight())
		self.frame[unit].background:SetTexture(LSM:Fetch(LSM.MediaType.STATUSBAR, Gladius.db.targetBarTexture))
		self.frame[unit].background:SetVertexColor(Gladius.db.targetBarBackgroundColor.r, Gladius.db.targetBarBackgroundColor.g, Gladius.db.targetBarBackgroundColor.b, Gladius.db.targetBarBackgroundColor.a)
		-- disable tileing
		self.frame[unit].background:SetHorizTile(false)
		self.frame[unit].background:SetVertTile(false)
		self.frame[unit]:SetAlpha(1)
		self.frame[unit]:Show()
	else
		self.frame[unit]:SetAlpha(0)
		self.frame[unit]:Hide()
	end
	self:UpdateColors(unit)
	-- update secure frame
	self.frame[unit].secure:RegisterForClicks("AnyUp")
	self.frame[unit].secure:SetAllPoints(self.frame[unit].frame)
	self.frame[unit].secure:SetWidth(self.frame[unit].frame:GetWidth())
	self.frame[unit].secure:SetHeight(self.frame[unit].frame:GetHeight())
	if not InCombatLockdown() then
		self.frame[unit].secure:SetFrameStrata("LOW")
	end
	self.frame[unit].secure:SetAttribute("unit", unit.."target")
	self.frame[unit].secure:SetAttribute("type1", "target")
	-- update highlight texture
	self.frame[unit].highlight:SetAllPoints(self.frame[unit].frame)
	self.frame[unit].highlight:SetTexture([=[Interface\QuestFrame\UI-QuestTitleHighlight]=])
	self.frame[unit].highlight:SetBlendMode("ADD")
	self.frame[unit].highlight:SetVertexColor(1.0, 1.0, 1.0, 1.0)
	self.frame[unit].highlight:SetAlpha(0)
	-- hide frame
	self.frame[unit].frame:SetAlpha(0)
end

function TargetBar:GetBarColor(class)
	if class == "PRIEST" and not Gladius.db.healthBarUseDefaultColorPriest then
		return Gladius.db.healthBarColorPriest
	elseif class == "PALADIN" and not Gladius.db.healthBarUseDefaultColorPaladin then
		return Gladius.db.healthBarUseDefaultColorPaladin
	elseif class == "SHAMAN" and not Gladius.db.healthBarUseDefaultColorShaman then
		return Gladius.db.healthBarColorShaman
	elseif class == "DRUID" and not Gladius.db.healthBarUseDefaultColorDruid then
		return Gladius.db.healthBarColorDruid
	elseif class == "MAGE" and not Gladius.db.healthBarUseDefaultColorMage then
		return Gladius.db.healthBarColorMage
	elseif class == "WARLOCK" and not Gladius.db.healthBarUseDefaultColorWarlock then
		return Gladius.db.healthBarColorWarlock
	elseif class == "HUNTER" and not Gladius.db.healthBarUseDefaultColorHunter then
		return Gladius.db.healthBarColorHunter
	elseif class == "WARRIOR" and not Gladius.db.healthBarUseDefaultColorWarrior then
		return Gladius.db.healthBarColorWarrior
	elseif class == "ROGUE" and not Gladius.db.healthBarUseDefaultColorRogue then
		return Gladius.db.healthBarColorRogue
	elseif class == "DEATHKNIGHT" and not Gladius.db.healthBarUseDefaultColorDeathknight then
		return Gladius.db.healthBarColorDeathknight
	elseif class == "MONK" and not Gladius.db.healthBarUseDefaultColorMonk then
		return Gladius.db.healthBarColorMonk
	end
	return RAID_CLASS_COLORS[class]
end

function TargetBar:Show(unit)
	local testing = Gladius.test
	-- show frame
	self.frame[unit].frame:SetAlpha(1)
	-- set secure frame
	if not InCombatLockdown() then
		self.frame[unit].secure:SetFrameStrata("DIALOG")
	end
	-- get unit class
	local class
	if not testing then
		class = select(2, UnitClass(unit.."target"))
	else
		class = Gladius.testing[unit].unitClass
	end
	-- set color
	if not Gladius.db.targetBarClassColor then
		local color = Gladius.db.targetBarColor
		self.frame[unit]:SetStatusBarColor(color.r, color.g, color.b, color.a)
	else
		local color = self:GetBarColor(class)
		if not color then
			-- fallback, when targeting a pet or totem
			color = Gladius.db.targetBarColor
		end
		self.frame[unit]:SetStatusBarColor(color.r, color.g, color.b, color.a or 1)
	end
	-- set class icon
	self:SetClassIcon(unit)
	-- call event
	if not Gladius.test then
		self:UNIT_HEALTH("UNIT_HEALTH", unit)
	end
end

function TargetBar:Reset(unit)
	if not self.frame[unit] then
		return
	end
	-- reset bar
	self.frame[unit]:SetMinMaxValues(0, 1)
	self.frame[unit]:SetValue(1)
	-- reset texture
	self.frame[unit].icon:SetTexture("")
	-- hide
	self.frame[unit].frame:SetAlpha(0)
end

function TargetBar:Test(unit)
	-- set test values
	local maxHealth = Gladius.testing[unit].maxHealth
	local health = Gladius.testing[unit].health
	self:UpdateHealth(unit, health, maxHealth)
end

function TargetBar:GetOptions()
	return {
		general = {
			type = "group",
			name = L["General"],
			order = 1,
			args = {
				bar = {
					type = "group",
					name = L["Bar"],
					desc = L["Bar settings"],
					inline = true,
					order = 1,
					args = {
						targetBarEnableBar = {
							type = "toggle",
							name = L["Target bar health bar"],
							desc = L["Toggle health bar display"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 3,
						},
						targetBarClassColor = {
							type = "toggle",
							name = L["Target bar class color"],
							desc = L["Toggle health bar class color"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 5,
						},
						sep2 = {
							type = "description",
							name = "",
							width = "full",
							order = 7,
						},
						targetBarColor = {
							type = "color",
							name = L["Target bar color"],
							desc = L["Color of the health bar"],
							hasAlpha = true,
							get = function(info)
								return Gladius:GetColorOption(info)
							end,
							set = function(info, r, g, b, a)
								return Gladius:SetColorOption(info, r, g, b, a)
							end,
							disabled = function()
								return Gladius.dbi.profile.targetBarClassColor or not Gladius.dbi.profile.modules[self.name]
							end,
							order = 10,
						},
						targetBarBackgroundColor = {
							type = "color",
							name = L["Target bar background color"],
							desc = L["Color of the health bar background"],
							hasAlpha = true,
							get = function(info)
								return Gladius:GetColorOption(info)
							end,
							set = function(info, r, g, b, a)
								return Gladius:SetColorOption(info, r, g, b, a)
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 15,
						},
						sep3 = {
							type = "description",
							name = "",
							width = "full",
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 17,
						},
						targetBarInverse = {
							type = "toggle",
							name = L["Target bar inverse"],
							desc = L["Inverse the health bar"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 20,
						},
						targetBarTexture = {
							type = "select",
							name = L["Target bar texture"],
							desc = L["Texture of the health bar"],
							dialogControl = "LSM30_Statusbar",
							values = AceGUIWidgetLSMlists.statusbar,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 25,
						},
						sep4 = {
							type = "description",
							name = "",
							width = "full",
							order = 27,
						},
						targetBarIcon = {
							type = "toggle",
							name = L["Target bar class icon"],
							desc = L["Toggle the target bar class icon"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 30,
						},
						targetBarIconPosition = {
							type = "select",
							name = L["Target bar icon position"],
							desc = L["Position of the target bar class icon"],
							values={["LEFT"] = L["LEFT"], ["RIGHT"] = L["RIGHT"]},
							disabled = function()
								return not Gladius.dbi.profile.targetBarIcon or not Gladius.dbi.profile.modules[self.name]
							end,
							order = 35,
						},
						sep6 = {
							type = "description",
							name = "",
							width = "full",
							order = 37,
						},
						targetBarIconCrop = {
							type = "toggle",
							name = L["Target Bar Icon Crop Borders"],
							desc = L["Toggle if the target bar icon borders should be cropped or not."],
							disabled = function()
								return not Gladius.dbi.profile.targetBarIcon or not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 40,
						},
					},
				},
				size = {
					type = "group",
					name = L["Size"],
					desc = L["Size settings"],
					inline = true,
					order = 2,
					args = {
						targetBarAdjustWidth = {
							type = "toggle",
							name = L["Target bar adjust width"],
							desc = L["Adjust health bar width to the frame width"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 5,
						},
						sep = {
							type = "description",
							name = "",
							width = "full",
							order = 13,
						},
						targetBarWidth = {
							type = "range",
							name = L["Target bar width"],
							desc = L["Width of the health bar"],
							min = 10,
							max = 500,
							step = 1,
							disabled = function()
								return Gladius.dbi.profile.targetBarAdjustWidth or not Gladius.dbi.profile.modules[self.name]
							end,
							order = 15,
						},
						targetBarHeight = {
							type = "range",
							name = L["Target bar height"],
							desc = L["Height of the health bar"],
							min = 10,
							max = 200,
							step = 1,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 20,
						},
					},
				},
				position = {
					type = "group",
					name = L["Position"],
					desc = L["Position settings"],
					inline = true,
					hidden = function()
						return not Gladius.db.advancedOptions
					end,
					order = 3,
					args = {
						targetBarAttachTo = {
							type = "select",
							name = L["Target Bar Attach To"],
							desc = L["Attach health bar to the given frame"],
							values = function()
								return Gladius:GetModules(self.name)
							end,
							set = function(info, value)
								local key = info.arg or info[#info]
								Gladius.dbi.profile[key] = value
								-- set frame type
								if (Gladius.db.targetBarAttachTo == "Frame" or strfind(Gladius.db.targetBarRelativePoint, "BOTTOM")) then
									self.isBar = true
								else
									self.isBar = false
								end
								Gladius:UpdateFrame()
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							width = "double",
							order = 5,
						},
						sep = {
							type = "description",
							name = "",
							width = "full",
							order = 7,
						},
						targetBarAnchor = {
							type = "select",
							name = L["Target Bar Anchor"],
							desc = L["Anchor of the health bar"],
							values = function()
								return Gladius:GetPositions()
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 10,
						},
						targetBarRelativePoint = {
							type = "select",
							name = L["Target Bar Relative Point"],
							desc = L["Relative point of the health bar"],
							values = function()
								return Gladius:GetPositions()
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 15,
						},
						sep2 = {
							type = "description",
							name = "",
							width = "full",
							order = 17,
						},
						targetBarOffsetX = {
							type = "range",
							name = L["Target bar offset X"],
							desc = L["X offset of the health bar"],
							min = -100,
							max = 100,
							step = 1,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 20,
						},
						targetBarOffsetY = {
							type = "range",
							name = L["Target bar offset Y"],
							desc = L["Y offset of the health bar"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							min = -100,
							max = 100,
							step = 1,
							order = 25,
						},
					},
				},
			},
		},
	}
end