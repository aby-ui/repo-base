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
	

local TimerBar_BarDisplay = TMW:NewClass("IconModule_TimerBar_BarDisplay", "IconModule_TimerBar")

TimerBar_BarDisplay:RegisterIconDefaults{
	BarDisplay_Reverse			= false,
	BarDisplay_Invert			= false,
	BarDisplay_BarGCD			= false,
	BarDisplay_ClassColor		= false,
	BarDisplay_FakeMax			= 0,
}

TMW:RegisterUpgrade(80006, {
	icon = function(self, ics)
		ics.TimerBar_StartColor    = TMW:RGBATableToStringWithFallback(ics.BarDisplay_StartColor,    "ffff0000")
		ics.TimerBar_MiddleColor   = TMW:RGBATableToStringWithFallback(ics.BarDisplay_MiddleColor,   "ffffff00")
		ics.TimerBar_CompleteColor = TMW:RGBATableToStringWithFallback(ics.BarDisplay_CompleteColor, "ff00ff00")

		ics.TimerBar_EnableColors  = ics.BarDisplay_EnableColors or ics.TimerBar_EnableColors

		ics.BarDisplay_StartColor    = nil
		ics.BarDisplay_MiddleColor   = nil
		ics.BarDisplay_CompleteColor = nil
		ics.BarDisplay_EnableColors  = nil
	end,
})

TimerBar_BarDisplay:RegisterConfigPanel_XMLTemplate(210, "TellMeWhen_BarDisplayBarOptions")


TimerBar_BarDisplay:PostHookMethod("OnEnable", function(self)
	local icon = self.icon
	local attributes = icon.attributes
	self.Invert = self.Invert_base

	if TMW.Locked then
		self:VALUE(icon, attributes.value, attributes.maxValue, attributes.valueColor)
	else
		self:VALUE(icon, 1, 1, attributes.valueColor)
	end
end)

function TimerBar_BarDisplay:GetValue()
	-- returns value, doTerminate

	local duration = self.duration

	if duration then
		-- Display a timer.
		if self.Invert then
			if duration == 0 then
				return self.Max, true
			else
				local value = TMW.time - self.start + self.Offset
				return value, value >= self.Max
			end
		else
			if duration == 0 then
				return 0, true
			else
				local value = duration - (TMW.time - self.start) + self.Offset
				return value, value <= 0
			end
		end

	elseif self.value then
		-- Display a set value.
		if self.Invert then
			return self.value + self.Offset, false
		else
			return self.Max - self.value + self.Offset, false
		end
	else
		return 0, true
	end
end

function TimerBar_BarDisplay:VALUE(icon, value, maxValue, valueColor)
	if value and maxValue then
		self.duration = nil
		self.start = nil
		self.Invert = not self.Invert_base

		self.value = value

		local oldMax = self.Max
		self.Max = self.FakeMax or maxValue
		if oldMax ~= self.Max then
			self.bar:SetMinMaxValues(0, self.Max)
		end

		self:SetupColors(self.sourceIcon, valueColor, icon.attributes.unit)

		-- Force an update here since it won't get updated if the color changes and the value doesnt.
		-- This is harmless, because 99% of the the time, the value has changed, so an update would be performed anyway.
		self:UpdateValue(true)
	else
		self.value = value
	end
end
TimerBar_BarDisplay:SetDataListener("VALUE")

function TimerBar_BarDisplay:UNIT(icon, unit)
	if unit then
		self:SetupColors(self.sourceIcon, icon.attributes.valueColor, unit)
		-- Force an update here since it won't get updated if the unit changes and the value doesnt.
		-- This is harmless, because 99% of the the time, the value has changed, so an update would be performed anyway.
		self:UpdateValue(true)
	end
end
TimerBar_BarDisplay:SetDataListener("UNIT")

local colorSettingNames = {
	"TimerBar_StartColor",
	"TimerBar_MiddleColor",
	"TimerBar_CompleteColor",
}

function TimerBar_BarDisplay:SetupColors(icon, valueColor, unit)
	icon = icon or self.icon

	if icon.TimerBar_EnableColors then
		if icon.BarDisplay_ClassColor then
			local class = unit and select(2, UnitClass(unit))
			if class then
				local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
				
				if color then
					-- GLOBALS: CUSTOM_CLASS_COLORS, RAID_CLASS_COLORS
					if color.colorStr then
						color = color.colorStr
					else
						color = TMW:RGBATableToStringWithoutFlags(color)
					end

					self:SetColors(
						color,
						color,
						color)

					return
				end
			end
		else
			self:SetColors(
				icon.TimerBar_StartColor,
				icon.TimerBar_MiddleColor,
				icon.TimerBar_CompleteColor)

			return
		end
	end

	if valueColor then
		-- TODO: add a setting to the value icon type called "use color", and don't ever pass this value color if they disable that setting?
		-- This will make color overriding much more intuitive, since the icon.TimerBar_EnableColors is labeled as "Override group colors".
		if type(valueColor) == "table" and #valueColor == 3 then
			self:SetColors(unpack(valueColor))
		else
			self:SetColors(
				valueColor,
				valueColor,
				valueColor)
		end

		return
	end

	self:SetColors(
		TMW:GetColors(colorSettingNames, "TimerBar_EnableColors",
		              icon.group:GetSettings(), TMW.db.global)
	)
end

function TimerBar_BarDisplay:SetupForIcon(sourceIcon)
	self.Invert_base = sourceIcon.BarDisplay_Invert
	self.Invert = self.Invert_base
	if self.value then
		self.Invert = not self.Invert_base
	end
	
	self.BarGCD = sourceIcon.BarDisplay_BarGCD
	if sourceIcon.typeData.hasNoGCD then
		self.BarGCD = true
	end

	self.Offset = 0

	if self.Invert_base or sourceIcon.BarDisplay_FakeMax == 0 then
		self.FakeMax = nil
	else
		self.FakeMax = sourceIcon.BarDisplay_FakeMax
	end

	self.sourceIcon = sourceIcon
	self.bar:SetReverseFill(sourceIcon.BarDisplay_Reverse)
	self:SetupColors(sourceIcon, sourceIcon.attributes.valueColor, sourceIcon.attributes.unit)
	
	self:UpdateValue(true)
end

TimerBar_BarDisplay:SetIconEventListner("TMW_ICON_SETUP_POST", function(Module, icon)
	if TMW.Locked then
		Module:UpdateTable_Register()
		
	else
		Module:UpdateTable_Unregister()
		
		Module.bar:SetValue(Module.Max)

		local co = Module.completeColor
		Module.bar:SetStatusBarColor(
			co.r,
			co.g,
			co.b,
			co.a
		)
	end
end)
