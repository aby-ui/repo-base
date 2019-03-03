--Dispel Module for Gladius
--Mavvo
local Gladius = _G.Gladius
if not Gladius then
	DEFAULT_CHAT_FRAME:AddMessage(format("Module %s requires Gladius", "Dispel"))
end
local L = Gladius.L
local LSM

-- global functions
local _G = _G
local pairs = pairs
local strfind = string.find
local strformat = string.format

local CreateFrame = CreateFrame
local UnitClass = UnitClass
local UnitFactionGroup = UnitFactionGroup
local UnitGUID = UnitGUID
local UnitLevel = UnitLevel
local UnitName = UnitName

local Dispel = Gladius:NewModule("Dispel", false, true, {
	dispellAttachTo = "Frame",
	dispellAnchor = "TOPLEFT",
	dispellRelativePoint = "TOPRIGHT",
	dispellGridStyleIcon = false,
	dispellGridStyleIconColor = {r = 0, g = 1, b = 0, a = 1},
	dispellGridStyleIconUsedColor = {r = 1, g = 0, b = 0, a = 1},
	dispellAdjustSize = true,
	dispellSize = 52,
	dispellOffsetX = 52,
	dispellOffsetY = 0,
	dispellFrameLevel = 1,
	dispellIconCrop = false,
	dispellGloss = true,
	dispellGlossColor = {r = 1, g = 1, b = 1, a = 0.4},
	dispellCooldown = true,
	dispellCooldownReverse = false,
	dispellFaction = true,
},
{
	"Dispel icon",
	"Grid style health bar",
	"Grid style power bar",
})

function Dispel:OnEnable()
	--self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	LSM = Gladius.LSM
	if not self.frame then
		self.frame = { }
	end
end

function Dispel:OnDisable()
	self:UnregisterAllEvents()
	for unit in pairs(self.frame) do
		self.frame[unit]:SetAlpha(0)
	end
end

function Dispel:OnProfileChanged()
	if Gladius.dbi.profile.modules["Dispel"] then
		Gladius:EnableModule("Dispel")
	else
		Gladius:DisableModule("Dispel")
	end
end

function Dispel:GetAttachTo()
	return Gladius.db.dispellAttachTo
end

function Dispel:GetFrame(unit)
	return self.frame[unit]
end

--[[function Dispel:SetTemplate(template)
	if template == 1 then
		-- reset width
		if (Gladius.db.targetBarAttachTo == "HealthBar" and not Gladius.db.healthBarAdjustWidth) then
			Gladius.db.healthBarAdjustWidth = true
		end
		-- reset to default
		for k, v in pairs(self.defaults) do
			Gladius.db[k] = v
		end
	elseif template == 2 then
		if Gladius.db.modules["HealthBar"] then
			if (Gladius.db.healthBarAdjustWidth) then
				Gladius.db.healthBarAdjustWidth = false
				Gladius.db.healthBarWidth = Gladius.db.barWidth - Gladius.db.healthBarHeight
			else
				Gladius.db.healthBarWidth = Gladius.db.healthBarWidth - Gladius.db.healthBarHeight
			end
			Gladius.db.dispellGridStyleIcon = true
			Gladius.db.dispellAdjustHeight = false
			Gladius.db.dispellHeight = Gladius.db.healthBarHeight
			Gladius.db.dispellAttachTo = "HealthBar"
			Gladius.db.dispellAnchor = "TOPLEFT"
			Gladius.db.dispellRelativePoint = "TOPRIGHT"
			Gladius.db.dispellOffsetX = 52
			Gladius.db.dispellOffsetY = 0
		end
	else
		if Gladius.db.modules["PowerBar"] then
			if (Gladius.db.powerBarAdjustWidth) then
				Gladius.db.powerBarAdjustWidth = false
				Gladius.db.powerBarWidth = Gladius.db.powerBarWidth - Gladius.db.powerBarHeight
			else
				Gladius.db.powerBarWidth = Gladius.db.powerBarWidth - Gladius.db.powerBarHeight
			end
			Gladius.db.dispellGridStyleIcon = true
			Gladius.db.dispellAdjustHeight = false
			Gladius.db.dispellHeight = Gladius.db.powerBarHeight
			Gladius.db.dispellAttachTo = "PowerBar"
			Gladius.db.dispellAnchor = "TOPLEFT"
			Gladius.db.dispellRelativePoint = "TOPRIGHT"
			Gladius.db.dispellOffsetX = 52
			Gladius.db.dispellOffsetY = 0
		end
	end
end]]

function Dispel:COMBAT_LOG_EVENT_UNFILTERED(event)
	self:CombatLogEvent(event, CombatLogGetCurrentEventInfo())
end

function Dispel:CombatLogEvent(event, timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName, spellSchool, auraType)
	if eventType == "SPELL_DISPEL" then
		if not (UnitGUID("arena1") == sourceGUID or UnitGUID("arena2") == sourceGUID or UnitGUID("arena3") == sourceGUID or UnitGUID("arena4") == sourceGUID or UnitGUID("arena5") == sourceGUID) then
			return
		end
		if spellID == 527 or spellID == 4987 or spellID == 77130 or spellID == 88423 or spellID == 115450 or spellID == 2782 or spellID == 51886 or spellID == 475 then
			if UnitGUID("arena1") == sourceGUID then
				self:UpdateDispel("arena1", 8)
			elseif UnitGUID("arena2") == sourceGUID then
				self:UpdateDispel("arena2", 8)
			elseif UnitGUID("arena3") == sourceGUID then
				self:UpdateDispel("arena3", 8)
			elseif UnitGUID("arena4") == sourceGUID then
				self:UpdateDispel("arena4", 8)
			elseif UnitGUID("arena5") == sourceGUID then
				self:UpdateDispel("arena5", 8)
			end
		end
		--wotf
		--[[if spellID == GetSpellInfo(7744) then
			self:UpdateDispel(unit, 45)
		end]]
	end
end

function Dispel:UpdateDispel(unit, duration)
	if not unit or not duration then
		return
	end
	-- grid style icon
	if Gladius.db.dispellGridStyleIcon then
		self.frame[unit].texture:SetVertexColor(Gladius.db.dispellGridStyleIconUsedColor.r, Gladius.db.dispellGridStyleIconUsedColor.g, Gladius.db.dispellGridStyleIconUsedColor.b, Gladius.db.dispellGridStyleIconUsedColor.a)
	end
	-- announcement
	if Gladius.db.announcements.dispell then
		Gladius:Call(Gladius.modules.Announcements, "Send", strformat(L["DISPEL USED: %s (%s)"], UnitName(unit) or "test", UnitClass(unit) or "test"), 2, unit)
	end
	if Gladius.db.announcements.dispell or Gladius.db.dispellGridStyleIcon then
		self.frame[unit].timeleft = duration
		self.frame[unit]:SetScript("OnUpdate", function(f, elapsed)
			self.frame[unit].timeleft = self.frame[unit].timeleft - elapsed
			if self.frame[unit].timeleft <= 0 then
				-- dispel
				if Gladius.db.dispellGridStyleIcon then
					self.frame[unit].texture:SetVertexColor(Gladius.db.dispellGridStyleIconColor.r, Gladius.db.dispellGridStyleIconColor.g, Gladius.db.dispellGridStyleIconColor.b, Gladius.db.dispellGridStyleIconColor.a)
				end
				-- announcement
				if Gladius.db.announcements.dispell then
					Gladius:Call(Gladius.modules.Announcements, "Send", strformat(L["DISPEL READY: %s (%s)"], UnitName(unit) or "", UnitClass(unit) or ""), 2, unit)
				end
				self.frame[unit]:SetScript("OnUpdate", nil)
			end
		end)
	end
	-- cooldown
	Gladius:Call(Gladius.modules.Timer, "SetTimer", self.frame[unit], duration)
end

function Dispel:UpdateColors(unit)
	if Gladius.db.dispellGridStyleIcon then
		self.frame[unit].texture:SetVertexColor(Gladius.db.dispellGridStyleIconUsedColor.r, Gladius.db.dispellGridStyleIconUsedColor.g, Gladius.db.dispellGridStyleIconUsedColor.b, Gladius.db.dispellGridStyleIconUsedColor.a)
	end
	self.frame[unit].normalTexture:SetVertexColor(Gladius.db.dispellGlossColor.r, Gladius.db.dispellGlossColor.g, Gladius.db.dispellGlossColor.b, Gladius.db.dispellGloss and Gladius.db.dispellGlossColor.a or 0)
end

function Dispel:CreateFrame(unit)
	local button = Gladius.buttons[unit]
	if not button then
		return
	end
	-- create frame
	self.frame[unit] = CreateFrame("CheckButton", "Gladius"..self.name.."Frame"..unit, button, "ActionButtonTemplate")
	self.frame[unit]:EnableMouse(false)
	self.frame[unit]:SetNormalTexture("Interface\\AddOns\\Gladius\\Images\\Gloss")
	self.frame[unit].texture = _G[self.frame[unit]:GetName().."Icon"]
	self.frame[unit].normalTexture = _G[self.frame[unit]:GetName().."NormalTexture"]
	self.frame[unit].cooldown = _G[self.frame[unit]:GetName().."Cooldown"]
end

function Dispel:Update(unit)
	-- create frame
	if not self.frame[unit] then
		self:CreateFrame(unit)
	end
	-- update frame
	self.frame[unit]:ClearAllPoints()
	-- anchor point
	local parent = Gladius:GetParent(unit, Gladius.db.dispellAttachTo)
	self.frame[unit]:SetPoint(Gladius.db.dispellAnchor, parent, Gladius.db.dispellRelativePoint, Gladius.db.dispellOffsetX, Gladius.db.dispellOffsetY)
	-- frame level
	self.frame[unit]:SetFrameLevel(Gladius.db.dispellFrameLevel)
	if Gladius.db.dispellAdjustSize then
		if self:GetAttachTo() == "Frame" then
			local height = false
			-- need to rethink that
			--[[for _, module in pairs(Gladius.modules) do
				if (module:GetAttachTo() == self.name) then
					height = false
				end
			end]]
			if height then
				self.frame[unit]:SetWidth(Gladius.buttons[unit].height)
				self.frame[unit]:SetHeight(Gladius.buttons[unit].height)
			else
				self.frame[unit]:SetWidth(Gladius.buttons[unit].frameHeight)
				self.frame[unit]:SetHeight(Gladius.buttons[unit].frameHeight)
			end
		else
			self.frame[unit]:SetWidth(Gladius:GetModule(self:GetAttachTo()).frame[unit]:GetHeight() or 1)
			self.frame[unit]:SetHeight(Gladius:GetModule(self:GetAttachTo()).frame[unit]:GetHeight() or 1)
		end
	else
		self.frame[unit]:SetWidth(Gladius.db.dispellSize)
		self.frame[unit]:SetHeight(Gladius.db.dispellSize)
	end
	-- set frame mouse-interactable area
	if self:GetAttachTo() == "Frame" then
	local left, right, top, bottom = Gladius.buttons[unit]:GetHitRectInsets()
	if strfind(Gladius.db.dispellRelativePoint, "LEFT") then
		left = - self.frame[unit]:GetWidth() + Gladius.db.dispellOffsetX
	else
		right = - self.frame[unit]:GetWidth() + - Gladius.db.dispellOffsetX
	end
	-- search for an attached frame
	--[[for _, module in pairs(Gladius.modules) do
		if module.attachTo and module:GetAttachTo() == self.name and module.frame and module.frame[unit] then
			local attachedPoint = module.frame[unit]:GetPoint()
			if strfind(Gladius.db.trinketRelativePoint, "LEFT" and (not attachedPoint or (attachedPoint and strfind(attachedPoint, "RIGHT")))) then
				left = left - module.frame[unit]:GetWidth()
			elseif strfind(Gladius.db.trinketRelativePoint, "RIGHT" and (not attachedPoint or (attachedPoint and strfind(attachedPoint, "LEFT")))) then
				right = right - module.frame[unit]:GetWidth()
			end
		end
	end]]
	-- top / bottom
	if self.frame[unit]:GetHeight() > Gladius.buttons[unit]:GetHeight() then
		bottom = - (self.frame[unit]:GetHeight() - Gladius.buttons[unit]:GetHeight()) + Gladius.db.dispellOffsetY
	end
		Gladius.buttons[unit]:SetHitRectInsets(left, right, 0, 0)
		Gladius.buttons[unit].secure:SetHitRectInsets(left, right, 0, 0)
	end
	-- style action button
	self.frame[unit].normalTexture:SetHeight(self.frame[unit]:GetHeight() + self.frame[unit]:GetHeight() * 0.4)
	self.frame[unit].normalTexture:SetWidth(self.frame[unit]:GetWidth() + self.frame[unit]:GetWidth() * 0.4)
	self.frame[unit].normalTexture:ClearAllPoints()
	self.frame[unit].normalTexture:SetPoint("CENTER", 0, 0)
	self.frame[unit]:SetNormalTexture("Interface\\AddOns\\Gladius\\Images\\Gloss")
	self.frame[unit].texture:ClearAllPoints()
	self.frame[unit].texture:SetPoint("TOPLEFT", self.frame[unit], "TOPLEFT")
	self.frame[unit].texture:SetPoint("BOTTOMRIGHT", self.frame[unit], "BOTTOMRIGHT")
	if not Gladius.db.dispellIconCrop and not Gladius.db.dispellGridStyleIcon then
		self.frame[unit].texture:SetTexCoord(0, 1, 0, 1)
	else
		self.frame[unit].texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	end
	self.frame[unit].normalTexture:SetVertexColor(Gladius.db.dispellGlossColor.r, Gladius.db.dispellGlossColor.g, Gladius.db.dispellGlossColor.b, Gladius.db.dispellGloss and Gladius.db.dispellGlossColor.a or 0)
	-- cooldown
	if Gladius.db.dispellCooldown then
		self.frame[unit].cooldown:Show()
	else
		self.frame[unit].cooldown:Hide()
	end
	self.frame[unit].cooldown:SetReverse(Gladius.db.dispellCooldownReverse)
	Gladius:Call(Gladius.modules.Timer, "RegisterTimer", self.frame[unit], Gladius.db.dispellCooldown)
	-- hide
	self.frame[unit]:SetAlpha(0)
end

function Dispel:Show(unit)
	-- show frame
	self.frame[unit]:SetAlpha(1)
	if Gladius.db.dispellGridStyleIcon then
		self.frame[unit].texture:SetTexture(LSM:Fetch(LSM.MediaType.STATUSBAR, "Minimalist"))
		self.frame[unit].texture:SetVertexColor(Gladius.db.dispellGridStyleIconColor.r, Gladius.db.dispellGridStyleIconColor.g, Gladius.db.dispellGridStyleIconColor.b, Gladius.db.dispellGridStyleIconColor.a)
	else
		local dispellIcon
		local _, englishClass = UnitClass(unit)
		local testing = Gladius.test
		local spec = Gladius.buttons[unit].spec
		if not testing then
			if englishClass == "PRIEST" then
				if spec == "Discipline" or spec == "Holy" then
					dispellIcon = "Interface\\Icons\\spell_holy_dispelmagic" -- OK
				end
			elseif englishClass == "SHAMAN" then
				dispellIcon = "Interface\\Icons\\ability_shaman_cleansespirit" -- OK
			elseif englishClass == "PALADIN" then
				dispellIcon = "Interface\\Icons\\spell_holy_purify" -- OK
			elseif englishClass == "DRUID" then
				if spec == "Restoration" then
					dispellIcon = "Interface\\Icons\\ability_shaman_cleansespirit" -- OK
				else
					dispellIcon = "Interface\\Icons\\spell_holy_removecurse" -- OK
				end
			elseif englishClass == "MAGE" then
				dispellIcon = "Interface\\Icons\\spell_nature_removecurse" -- OK
			elseif englishClass == "MONK" then
				dispellIcon = "Interface\\Icons\\spell_holy_dispelmagic" -- OK
			end
		else
			if unit == "arena1" then
				dispellIcon = "Interface\\Icons\\spell_nature_removecurse"
			elseif unit == "arena2" then
				dispellIcon = "Interface\\Icons\\spell_holy_dispelmagic"
			elseif unit == "arena3" then
				dispellIcon = "Interface\\Icons\\spell_holy_purify"
			elseif unit == "arena4" then
				dispellIcon = "Interface\\Icons\\ability_shaman_cleansespirit"
			elseif unit == "arena5" then
				dispellIcon = "Interface\\Icons\\spell_holy_removecurse"
			end
		end
		if dispellIcon then
			self.frame[unit].texture:SetTexture(dispellIcon)
			if Gladius.db.dispellGloss then
				self.frame[unit].normalTexture:Show()
			end
		else
			self.frame[unit].texture:SetTexture("")
			self.frame[unit].normalTexture:Hide()
		end
		if Gladius.db.dispellIconCrop then
			self.frame[unit].texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		end
		self.frame[unit].texture:SetVertexColor(1, 1, 1, 1)
	end
end

function Dispel:Reset(unit)
	if not self.frame[unit] then
		return
	end
	-- reset frame
	local dispellIcon
	if UnitFactionGroup("player") == "Horde" and Gladius.db.dispellFaction then
		dispellIcon = "Interface\\Icons\\INV_Jewelry_Necklace_38"
	else
		dispellIcon = "Interface\\Icons\\INV_Jewelry_Necklace_37"
	end
	self.frame[unit].texture:SetTexture(dispellIcon)
	if Gladius.db.dispellIconCrop then
		self.frame[unit].texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	end
	self.frame[unit]:SetScript("OnUpdate", nil)
	-- reset cooldown
	Gladius:Call(Gladius.modules.Timer, "HideTimer", self.frame[unit])
	-- hide
	self.frame[unit]:SetAlpha(0)
end

function Dispel:Test(unit)
	if unit == "arena1" then
		self:UpdateDispel(unit, 8)
	elseif unit == "arena2" then
		self:UpdateDispel(unit, 8)
	elseif unit == "arena3" then
		self:UpdateDispel(unit, 8)
	elseif unit == "arena4" then
		self:UpdateDispel(unit, 8)
	elseif unit == "arena5" then
		self:UpdateDispel(unit, 8)
	end
end

-- Add the announcement toggle
function Dispel:OptionsLoad()
	Gladius.options.args.Announcements.args.general.args.announcements.args.dispell = {
		type = "toggle",
		name = L["Dispel"],
		desc = L["Announces when an enemy cast a dispel."],
		disabled = function()
			return not Gladius.db.modules[self.name]
		end,
	}
end

function Dispel:GetOptions()
	return {
		general = {
			type = "group",
			name = L["General"],
			order = 1,
			args = {
				widget = {
					type = "group",
					name = L["Widget"],
					desc = L["Widget settings"],
					inline = true,
					order = 1,
					args = {
						dispellGridStyleIcon = {
							type = "toggle",
							name = L["Dispel Grid Style Icon"],
							desc = L["Toggle dispel grid style icon"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 5,
						},
						sep = {
							type = "description",
							name = "",
							width = "full",
							order = 7,
						},
						dispellGridStyleIconColor = {
							type = "color",
							name = L["Dispel Grid Style Icon Color"],
							desc = L["Color of the dispel grid style icon"],
							hasAlpha = true,
							get = function(info)
								return Gladius:GetColorOption(info)
							end,
							set = function(info, r, g, b, a)
								return Gladius:SetColorOption(info, r, g, b, a)
							end,
							disabled = function()
								return not Gladius.dbi.profile.dispellGridStyleIcon or not Gladius.dbi.profile.modules[self.name]
							end,
							order = 10,
						},
						dispellGridStyleIconUsedColor = {
							type = "color",
							name = L["Dispel Grid Style Icon Used Color"],
							desc = L["Color of the dispel grid style icon when it's on cooldown"],
							hasAlpha = true,
							get = function(info)
								return Gladius:GetColorOption(info)
							end,
							set = function(info, r, g, b, a)
								return Gladius:SetColorOption(info, r, g, b, a)
							end,
							disabled = function()
								return not Gladius.dbi.profile.dispellGridStyleIcon or not Gladius.dbi.profile.modules[self.name]
							end,
							order = 12,
						},
						sep1 = {
							type = "description",
							name = "",
							width = "full",
							order = 13,
						},
						dispellCooldown = {
							type = "toggle",
							name = L["Dispel Cooldown Spiral"],
							desc = L["Display the cooldown spiral for important auras"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 15,
						},
						dispellCooldownReverse = {
							type = "toggle",
							name = L["Dispel Cooldown Reverse"],
							desc = L["Invert the dark/bright part of the cooldown spiral"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 20,
						},
						sep2 = {
							type = "description",
							name = "",
							width = "full",
							order = 23,
						},
						dispellGloss = {
							type = "toggle",
							name = L["Dispel Gloss"],
							desc = L["Toggle gloss on the dispel icon"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 25,
						},
						dispellGlossColor = {
							type = "color",
							name = L["Dispel Gloss Color"],
							desc = L["Color of the dispel icon gloss"],
							get = function(info)
								return Gladius:GetColorOption(info)
							end,
							set = function(info, r, g, b, a)
								return Gladius:SetColorOption(info, r, g, b, a)
							end,
							hasAlpha = true,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 30,
						},
						sep3 = {
							type = "description",
							name = "",
							width = "full",
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 33,
						},
						dispellIconCrop = {
							type = "toggle",
							name = L["Dispel Icon Border Crop"],
							desc = L["Toggle if the borders of the dispell icon should be cropped"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 35,
						},
						dispellFaction = {
							type = "toggle",
							name = L["Dispel Icon Faction"],
							desc = L["Toggle if the dispel icon should be changing based on the opponents faction"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 40,
						},
						sep3 = {
							type = "description",
							name = "",
							width = "full",
							order = 43,
						},
						dispellFrameLevel = {
							type = "range",
							name = L["Dispel Frame Level"],
							desc = L["Frame level of the dispel"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							min = 1,
							max = 5,
							step = 1,
							width = "double",
							order = 45,
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
						dispellAdjustSize = {
							type = "toggle",
							name = L["Dispel Adjust Size"],
							desc = L["Adjust dispel size to the frame size"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 5,
						},
						dispellSize = {
							type = "range",
							name = L["Dispel Size"],
							desc = L["Size of the dispel"],
							min = 10,
							max = 100,
							step = 1,
							disabled = function()
								return Gladius.dbi.profile.dispellAdjustSize or not Gladius.dbi.profile.modules[self.name]
							end,
							order = 10,
						},
					},
				},
				position = {
						type = "group",
						name = L["Position"],
						desc = L["Position settings"],
						inline = true,
						order = 3,
						args = {
						dispellAttachTo = {
							type = "select",
							name = L["Dispel Attach To"],
							desc = L["Attach dispel to the given frame"],
							values = function()
								return Gladius:GetModules(self.name)
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							arg = "general",
							order = 5,
						},
						dispellPosition = {
							type = "select",
							name = L["Dispel Position"],
							desc = L["Position of the dispel"],
							values = {["LEFT"] = L["Left"], ["RIGHT"] = L["Right"]},
							get = function()
								return strfind(Gladius.db.dispellAnchor, "RIGHT") and "LEFT" or "RIGHT"
							end,
							set = function(info, value)
								if (value == "LEFT") then
									Gladius.db.dispellAnchor = "TOPRIGHT"
									Gladius.db.dispellRelativePoint = "TOPLEFT"
								else
									Gladius.db.dispellAnchor = "TOPLEFT"
									Gladius.db.dispellRelativePoint = "TOPRIGHT"
								end
								Gladius:UpdateFrame(info[1])
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return Gladius.db.advancedOptions
							end,
							order = 6,
						},
						sep = {
							type = "description",
							name = "",
							width = "full",
							order = 7,
						},
						dispellAnchor = {
							type = "select",
							name = L["Dispel Anchor"],
							desc = L["Anchor of the dispel"],
							values = function()
								return Gladius:GetPositions()
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 10,
						},
						dispellRelativePoint = {
							type = "select",
							name = L["Dispel Relative Point"],
							desc = L["Relative point of the dispel"],
							values = function()
								return Gladius:GetPositions()
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							order = 15,
						},
						sep2 = {
							type = "description",
							name = "",
							width = "full",
							order = 17,
						},
						dispellOffsetX = {
							type = "range",
							name = L["Dispel Offset X"],
							desc = L["X offset of the dispel"],
							min = - 100,
							max = 100,
							step = 1,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 20,
						},
						dispellOffsetY = {
							type = "range",
							name = L["Dispel Offset Y"],
							desc = L["Y offset of the dispel"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							min = -50,
							max = 50,
							step = 1,
							order = 25,
						},
					},
				},
			},
		},
	}
end
