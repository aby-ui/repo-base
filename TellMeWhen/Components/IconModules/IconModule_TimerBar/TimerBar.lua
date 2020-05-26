-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print


local LSM = LibStub("LibSharedMedia-3.0")
local	pairs, wipe =
		pairs, wipe

local OnGCD = TMW.OnGCD



local BarsToUpdate = {}


local TimerBar = TMW:NewClass("IconModule_TimerBar", "IconModule", "UpdateTableManager")
TimerBar:UpdateTable_Set(BarsToUpdate)


local settings = {
	TimerBar_StartColor    = "ffff0000",
	TimerBar_MiddleColor   = "ffffff00",
	TimerBar_CompleteColor = "ff00ff00",
	TimerBar_EnableColors  = false,
}

-- Icon defaults
TimerBar:RegisterIconDefaults(settings)

-- Group defaults
TMW:MergeDefaultsTables(settings, TMW.Group_Defaults)

-- Global defaults (global doesn't have the Enable_Colors setting)
settings.TimerBar_EnableColors = nil
TMW:MergeDefaultsTables(settings, TMW.Defaults.global)


TimerBar:RegisterConfigPanel_XMLTemplate(52, "TellMeWhen_TimerBar_GroupColors")
	:SetPanelSet("group")
	:SetColumnIndex(1)


TimerBar:RegisterConfigPanel_XMLTemplate(52, "TellMeWhen_TimerBar_GlobalColors")
	:SetPanelSet("global")



TimerBar:RegisterAnchorableFrame("TimerBar")


function TimerBar:OnNewInstance(icon)	
	local bar = CreateFrame("StatusBar", self:GetChildNameBase() .. "TimerBar", icon)
	self.bar = bar
	
	self.texture = bar:CreateTexture(nil, "OVERLAY")
	bar:SetStatusBarTexture(self.texture)
	
	self.Max = 1
	bar:SetMinMaxValues(0, self.Max)
	
	self.start = 0
	self.duration = 0
	self.normalStart = 0
	self.normalDuration = 0
	self.chargeStart = 0
	self.chargeDur = 0
	self.Offset = 0
	self.__oldPercent = 0
	
	self:UpdateValue(true)
end

function TimerBar:OnEnable()
	local icon = self.icon
	local attributes = icon.attributes
	
	self.bar:Show()
	local texture = icon.group.TextureName
	if texture == "" then
		texture = TMW.db.profile.TextureName
	end
	self.texture:SetTexture(LSM:Fetch("statusbar", texture))
	
	self:SetCooldown(attributes.start, attributes.start, attributes.chargeStart, attributes.chargeDur)
end
function TimerBar:OnDisable()
	self.bar:Hide()
	self:UpdateTable_Unregister()
end

function TimerBar:GetValue()
	-- returns value, doTerminate

	local start, duration, Invert = self.start, self.duration, self.Invert

	if Invert then
		if duration == 0 then
			return self.Max, true
		else
			local value = TMW.time - start + self.Offset
			return value, value >= self.Max
		end
	else
		if duration == 0 then
			return 0, true
		else
			local value = duration - (TMW.time - start) + self.Offset
			return value, value <= 0
		end
	end
end

function TimerBar:UpdateValue(force)
	local ret = 0
	
	local Invert = self.Invert

	local value, doTerminate = self:GetValue()

	if doTerminate then
		self:UpdateTable_Unregister()
		ret = -1
		if Invert then
			value = self.Max
		else
			value = 0
		end
	end

	local percent = self.Max == 0 and 0 or value / self.Max
	if percent < 0 then
		percent = 0
	elseif percent > 1 then
		percent = 1
	end

	if force or value ~= self.__value then
		local bar = self.bar
		bar:SetValue(value)

		if abs(self.__oldPercent - percent) > 0.02 then
			-- If the percentage of the bar changed by more than 2%, force an instant redraw of the texture.
			-- For some reason, blizzard defers the updating of status bar textures until sometimes 1 or 2 frames after it is set.
			self:UpdateStatusBarImmediate(percent)
		elseif bar:GetReverseFill() then
			-- Bliizard goofed (or forgot) when they implemented reverse filling,
			-- the tex coords are messed up. We'll just have to fix them ourselves.
			if bar:GetOrientation() == "VERTICAL" then
				self.texture:SetTexCoord(0, 0, percent, 0, 0, 1, percent, 1)
			else
				self.texture:SetTexCoord(1 - percent, 1, 0, 1)
			end
		end

		-- This line is here to fix an issue with the bar texture
		-- not being in the correct location/correct size if
		-- the bar is modified while it, or a parent, is hidden.
		--self.texture:GetSize()

		if value ~= 0 then
			local completeColor = self.completeColor
			local halfColor = self.halfColor
			local startColor = self.startColor

			if Invert then
				completeColor, startColor = startColor, completeColor
			end
			
			-- This is multiplied by 2 because we subtract 100% if it ends up being past
			-- the point where halfColor will be used.
			-- If we don't multiply by 2, we would check if (percent > 0.5), but then
			-- we would have to multiply that percentage by 2 later anyway in order to use the
			-- full range of colors available (we would only get half the range of colors otherwise, which looks like shit)
			local doublePercent = percent * 2

			if doublePercent > 1 then
				completeColor = halfColor
				doublePercent = doublePercent - 1
			else
				startColor = halfColor
			end

			local inv = 1-doublePercent

			bar:SetStatusBarColor(
				(startColor.r * doublePercent) + (completeColor.r * inv),
				(startColor.g * doublePercent) + (completeColor.g * inv),
				(startColor.b * doublePercent) + (completeColor.b * inv),
				(startColor.a * doublePercent) + (completeColor.a * inv)
			)
		end
		self.__value = value
		self.__oldPercent = percent
	end
	
	return ret
end

function TimerBar:UpdateStatusBarImmediate(percent)
	local bar = self.bar
	local tex = self.texture

	if bar:GetOrientation() == "VERTICAL" then
		local height = bar:GetHeight()
		local sizePercent = height*percent


		-- tex:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
		if bar:GetReverseFill() then
			tex:SetPoint("BOTTOMLEFT", 0, height - sizePercent)
			tex:SetPoint("BOTTOMRIGHT", 0, height - sizePercent)
			tex:SetTexCoord(0, 0, percent, 0, 0, 1, percent, 1)
		else
			tex:SetPoint("TOPLEFT", 0, sizePercent - height)
			tex:SetPoint("TOPRIGHT", 0, sizePercent - height)
			tex:SetTexCoord(percent, 0, 0, 0, percent, 1, 0, 1)
		end

	else
		local width = bar:GetWidth()
		local sizePercent = width*percent

		if bar:GetReverseFill() then
			tex:SetPoint("TOPLEFT", width - sizePercent, 0)
			tex:SetPoint("BOTTOMLEFT", width - sizePercent, 0)
			tex:SetTexCoord(1 - percent, 1, 0, 1)
		else
			tex:SetPoint("TOPRIGHT", sizePercent - width, 0)
			tex:SetPoint("BOTTOMRIGHT", sizePercent - width, 0)
			tex:SetTexCoord(0, percent, 0, 1)
		end

	end
end

function TimerBar:SetCooldown(start, duration, chargeStart, chargeDur)
	self.normalStart, self.normalDuration = start, duration
	self.chargeStart, self.chargeDur = chargeStart, chargeDur

	if chargeDur and chargeDur > 0 then
		duration = chargeDur

		self.duration = chargeDur
		self.start = chargeStart
	else
		self.duration = duration
		self.start = start
	end
	
	if duration > 0 then
		if not self.BarGCD and self.icon:OnGCD(duration) then
			self.duration = 0
		end

		self.Max = self.FakeMax or duration
		self.bar:SetMinMaxValues(0, self.Max)
		self.__value = nil -- the displayed value might change when we change the max, so force an update

		self:UpdateTable_Register()
	end
end

function TimerBar:SetColors(startColor, halfColor, completeColor)
	self.startColor    = startColor and TMW:StringToCachedRGBATable(startColor)
	self.halfColor     = halfColor and TMW:StringToCachedRGBATable(halfColor)
	self.completeColor = completeColor and TMW:StringToCachedRGBATable(completeColor)
end

function TimerBar:DURATION(icon, start, duration)
	self:SetCooldown(start, duration, self.chargeStart, self.chargeDur)
end
TimerBar:SetDataListener("DURATION")

function TimerBar:SPELLCHARGES(icon, charges, maxCharges, chargeStart, chargeDur)
	self:SetCooldown(self.normalStart, self.normalDuration, chargeStart, chargeDur)
end
TimerBar:SetDataListener("SPELLCHARGES")


TMW:RegisterCallback("TMW_LOCK_TOGGLED", function(event, Locked)
	if not Locked then
		TimerBar:UpdateTable_UnregisterAll()
	end
end)

TMW:RegisterCallback("TMW_ONUPDATE_POST", function(event, time, Locked)
	local offs = 0
	for i = 1, #BarsToUpdate do
		local TimerBar = BarsToUpdate[i + offs]
		offs = offs + TimerBar:UpdateValue() -- returns -1 if the bar was unregistered, otherwise 0
	end
end)

