--[[
Name: LibCrayon-3.0
Revision: $Rev: 49 $
Author(s): ckknight (ckknight@gmail.com)
Website: http://ckknight.wowinterface.com/
Documentation: http://wiki.wowace.com/index.php/LibCrayon-3.0
SVN: http://svn.wowace.com/root/trunk/CrayonLib/LibCrayon-3.0
Description: A library to provide coloring tools.
]]

--Theondry (theondry@gmail.com) added the purple.  yell at me if it's wrong, please

local MAJOR_VERSION = "LibCrayon-3.0"
local MINOR_VERSION = tonumber(("$Revision: 49 $"):match("(%d+)")) + 90000

if not LibStub then error(MAJOR_VERSION .. " requires LibStub") end

local Crayon, oldLib = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not Crayon then
	return
end

Crayon.COLOR_HEX_RED       = "ff0000"
Crayon.COLOR_HEX_ORANGE    = "ff7f00"
Crayon.COLOR_HEX_YELLOW    = "ffff00"
Crayon.COLOR_HEX_GREEN     = "00ff00"
Crayon.COLOR_HEX_WHITE     = "ffffff"
Crayon.COLOR_HEX_COPPER    = "eda55f"
Crayon.COLOR_HEX_SILVER    = "c7c7cf"
Crayon.COLOR_HEX_GOLD      = "ffd700"
Crayon.COLOR_HEX_PURPLE    = "9980CC"
Crayon.COLOR_HEX_BLUE	   = "0000ff"
Crayon.COLOR_HEX_CYAN	   = "00ffff"
Crayon.COLOR_HEX_BLACK	   = "000000"

function Crayon:Colorize(hexColor, text)
	return "|cff" .. tostring(hexColor or 'ffffff') .. tostring(text) .. "|r"
end
function Crayon:Red(text) return self:Colorize(self.COLOR_HEX_RED, text) end
function Crayon:Orange(text) return self:Colorize(self.COLOR_HEX_ORANGE, text) end
function Crayon:Yellow(text) return self:Colorize(self.COLOR_HEX_YELLOW, text) end
function Crayon:Green(text) return self:Colorize(self.COLOR_HEX_GREEN, text) end
function Crayon:White(text) return self:Colorize(self.COLOR_HEX_WHITE, text) end
function Crayon:Copper(text) return self:Colorize(self.COLOR_HEX_COPPER, text) end
function Crayon:Silver(text) return self:Colorize(self.COLOR_HEX_SILVER, text) end
function Crayon:Gold(text) return self:Colorize(self.COLOR_HEX_GOLD, text) end
function Crayon:Purple(text) return self:Colorize(self.COLOR_HEX_PURPLE, text) end
function Crayon:Blue(text) return self:Colorize(self.COLOR_HEX_BLUE, text) end
function Crayon:Cyan(text) return self:Colorize(self.COLOR_HEX_CYAN, text) end
function Crayon:Black(text) return self:Colorize(self.COLOR_HEX_BLACK, text) end

local inf = math.huge

local function GetThresholdPercentage(quality, ...)
	local n = select('#', ...)
	if n <= 1 then
		return GetThresholdPercentage(quality, 0, ... or 1)
	end

	local worst = ...
	local best = select(n, ...)

	if worst == best and quality == worst then
		return 0.5
	end

	if worst <= best then
		if quality <= worst then
			return 0
		elseif quality >= best then
			return 1
		end
		local last = worst
		for i = 2, n-1 do
			local value = select(i, ...)
			if quality <= value then
				return ((i-2) + (quality - last) / (value - last)) / (n-1)
			end
			last = value
		end

		local value = select(n, ...)
		return ((n-2) + (quality - last) / (value - last)) / (n-1)
	else
		if quality >= worst then
			return 0
		elseif quality <= best then
			return 1
		end
		local last = worst
		for i = 2, n-1 do
			local value = select(i, ...)
			if quality >= value then
				return ((i-2) + (quality - last) / (value - last)) / (n-1)
			end
			last = value
		end

		local value = select(n, ...)
		return ((n-2) + (quality - last) / (value - last)) / (n-1)
	end
end

function Crayon:GetThresholdColor(quality, ...)
	if quality ~= quality or quality == inf or quality == -inf then
		return 1, 1, 1
	end

	local percent = GetThresholdPercentage(quality, ...)

	if percent <= 0 then
		return 1, 0, 0
	elseif percent <= 0.5 then
		return 1, percent*2, 0
	elseif percent >= 1 then
		return 0, 1, 0
	else
		return 2 - percent*2, 1, 0
	end
end

function Crayon:GetThresholdHexColor(quality, ...)
	local r, g, b = self:GetThresholdColor(quality, ...)
	return string.format("%02x%02x%02x", r*255, g*255, b*255)
end

function Crayon:GetThresholdColorTrivial(quality, ...)
	if quality ~= quality or quality == inf or quality == -inf then
		return 1, 1, 1
	end

	local percent = GetThresholdPercentage(quality, ...)

	if percent <= 0 then
		return 1, 0, 0
	elseif percent <= 0.5 then
		return 1, percent*2, 0
	elseif percent <= 0.75 then
		return 3 - percent*4, 1, 0
	elseif percent >= 1 then
		return 0.5, 0.5, 0.5
	else
		return percent*2 - 1.5, 2.5 - percent*2, percent*2 - 1.5
	end
end

function Crayon:GetThresholdHexColorTrivial(quality, ...)
	local r, g, b = self:GetThresholdColorTrivial(quality, ...)
	return string.format("%02x%02x%02x", r*255, g*255, b*255)
end

function Crayon:RGBtoHSL(red, green, blue)
	local hue, saturation, luminance
	local minimum = math.min( red, green, blue )
	local maximum = math.max( red, green, blue )
	local difference = maximum - minimum

	luminance = ( maximum + minimum ) / 2

	if difference == 0 then --Greyscale
		hue = 0
		saturation = 0
	else              --Colour
		if luminance < 0.5 then
			saturation = difference / ( maximum + minimum )
		else
			saturation = difference / ( 2 - maximum- minimum )
		end

		local tmpRed   = ( ( ( maximum - red   ) / 6 ) + ( difference / 2 ) ) / difference
		local tmpGreen = ( ( ( maximum - green ) / 6 ) + ( difference / 2 ) ) / difference
		local tmpBlue  = ( ( ( maximum - blue  ) / 6 ) + ( difference / 2 ) ) / difference

		if red == maximum then
			hue = tmpBlue - tmpGreen
		elseif green == maximum then
			hue = ( 1 / 3 ) + tmpRed - tmpBlue
		elseif blue == maximum then
			hue = ( 2 / 3 ) + tmpGreen - tmpRed
		end

		hue = hue % 1
		if hue < 0 then hue = hue + 1 end
	end

	return hue, saturation, luminance
end

function Crayon:HSLtoRGB(hue, saturation, luminance)
	local red, green, blue
	local var1, var2, var3

	if saturation == 0 then
		red, green, blue = luminance, luminance, luminance
	else
		if luminance < 0.5 then
			var2 = luminance * ( 1 + saturation )
		else
			var2 = ( luminance + saturation ) - ( saturation * luminance )
		end

		var1 = 2 * luminance - var2

		red   = self:HueToColor( var1, var2, hue + ( 1 / 3 ) )
		green = self:HueToColor( var1, var2, hue )
		blue  = self:HueToColor( var1, var2, hue - ( 1 / 3 ) )
	end

	return red, green, blue
end

function Crayon:HueToColor(var1, var2, hue)
	hue = hue % 1
	if hue < 0 then hue = hue + 1 end

	if ( 6 * hue ) < 1 then
		return hue + ( var2 - var1 ) * 6 * hue
	elseif ( 2 * hue ) < 1 then
		return var2
	elseif ( 3 * hue ) < 2 then
		return var1 + ( var2 - var1 ) * ( ( 2 / 3 ) - hue ) * 6
	else
		return var1
	end
end

function Crayon:RotateRGBHue(red, green, blue, rotation)
	local hue, saturation, luminance = self:RGBtoHSL(red, green, blue)
	red, green, blue = self:HSLtoRGB(hue + rotation , saturation, luminance)
	return red, green, blue
end

local function compat()
	local Crayon20 = setmetatable({}, {__index = function(self, key)
		if type(Crayon[key]) == "function" then
			self[key] = function(self, ...)
				return Crayon[key](Crayon, ...)
			end
		else
			self[key] = Crayon[key]
		end
		return self[key]
	end})
	AceLibrary:Register(Crayon20, "Crayon-2.0", MINOR_VERSION*1000)
end
if AceLibrary then
	compat()
elseif Rock then
	function Crayon:OnLibraryLoad(major, instance)
		if major == "AceLibrary" then
			compat()
		end
	end
end
