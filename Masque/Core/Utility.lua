--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Core\Utility.lua
	* Author.: StormFX

	Utility Functions

]]

local _, Core = ...

----------------------------------------
-- Lua
---

local type = type

----------------------------------------
-- Color
---

-- Returns a set of color values.
function Core.GetColor(Color, Alpha)
	if type(Color) == "table" then
		return Color[1] or 1, Color[2] or 1, Color[3] or 1, Alpha or Color[4] or 1
	else
		return 1, 1, 1, Alpha or 1
	end
end

----------------------------------------
-- NoOp
---

-- An empty function.
function Core.NoOp() end

----------------------------------------
-- Points
---

-- Clears and sets the points for a region.
function Core.SetPoints(Region, Button, Skin, Default, SetAllPoints)
	Region:ClearAllPoints()

	if SetAllPoints then
		Region:SetAllPoints(Button)
	else
		local Point = Skin.Point
		local RelPoint = Skin.RelPoint or Point

		if not Point then
			Point = Default and Default.Point

			if Point then
				RelPoint = Default.RelPoint or Point
			else
				Point = "CENTER"
				RelPoint = Point
			end
		end

		local OffsetX = Skin.OffsetX
		local OffsetY = Skin.OffsetY

		if Default and not OffsetX and not OffsetY then
			OffsetX = Default.OffsetX or 0
			OffsetY = Default.OffsetY or 0
		end

		Region:SetPoint(Point, Button, RelPoint, OffsetX or 0, OffsetY or 0)
	end
end

----------------------------------------
-- Scale
---

-- Returns the x and y scale of a button.
function Core.GetScale(Button)
	local x = (Button:GetWidth() or 36) / 36
	local y = (Button:GetHeight() or 36) / 36
	return x, y
end

----------------------------------------
-- Size
---

-- Returns a height and width.
function Core.GetSize(Width, Height, xScale, yScale)
	local w = (Width or 36) * xScale
	local h = (Height or 36) * yScale
	return w, h
end

----------------------------------------
-- TexCoords
---

-- Returns a set of texture coordinates.
function Core.GetTexCoords(Coords)
	if type(Coords) == "table" then
		return Coords[1] or 0, Coords[2] or 1, Coords[3] or 0, Coords[4] or 1
	else
		return 0, 1, 0, 1
	end
end
