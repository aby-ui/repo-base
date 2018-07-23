local Parrot = Parrot

local L = LibStub("AceLocale-3.0"):GetLocale("Parrot_AnimationStyles")

local validPoints = {
	TOPLEFT = "TOPLEFT",
	TOP = "TOP",
	TOPRIGHT = "TOPRIGHT",
	LEFT = "LEFT",
	RIGHT = "RIGHT",
	CENTER = "CENTER",
	BOTTOMLEFT = "BOTTOMLEFT",
	BOTTOM = "BOTTOM",
	BOTTOMRIGHT = "BOTTOMRIGHT",
}

Parrot:RegisterAnimationStyle {
	-- simple vertical
	name = "Straight",
	localName = L["Straight"],
	func = function(frame, xOffset, yOffset, size, percent, direction)
		local vert, align = (";"):split(direction)
		if vert == "DOWN" then
			percent = 1 - percent
		end
		local y = yOffset + (percent - 0.5) * size
		local x = xOffset
		frame:SetPoint(validPoints[align] or "CENTER", UIParent, "CENTER", x, y)
	end,
	defaultDirection = "DOWN;CENTER",
	directions = {
		["UP;LEFT"] = L["Up, left-aligned"],
		["UP;RIGHT"] = L["Up, right-aligned"],
		["UP;CENTER"] = L["Up, center-aligned"],
		["DOWN;LEFT"] = L["Down, left-aligned"],
		["DOWN;RIGHT"] = L["Down, right-aligned"],
		["DOWN;CENTER"] = L["Down, center-aligned"],
	},
	overlap = true,
}
Parrot:RegisterAnimationStyle {
	-- makes a parabola in the form of x = y^2 - 1
	name = "Parabola",
	localName = L["Parabola"],
	func = function(frame, xOffset, yOffset, size, percent, direction, num, max, uid)
		local vert, horiz = (";"):split(direction)
		if vert == "DOWN" then
			percent = 1 - percent
		end
		local xDiff = (1 - 4*(percent - 0.5)^2) * size * 1/3
		local point = "LEFT"
		if horiz == "LEFT" or (horiz == "ALT" and uid%2 == 0) then
			xDiff = -xDiff
			point = "RIGHT"
		end
		local y = yOffset + (percent - 0.5) * size
		local x = xOffset + xDiff
		frame:SetPoint(point, UIParent, "CENTER", x, y)
	end,
	defaultDirection = "DOWN;ALT",
	directions = {
		["UP;LEFT"] = L["Up, left"],
		["UP;RIGHT"] = L["Up, right"],
		["UP;ALT"] = L["Up, alternating"],
		["DOWN;LEFT"] = L["Down, left"],
		["DOWN;RIGHT"] = L["Down, right"],
		["DOWN;ALT"] = L["Down, alternating"],
	},
	overlap = true,
}
Parrot:RegisterAnimationStyle {
	-- makes a semicircle in the form of x = -(-y^2 + 1)^0.5
	name = "Semicircle",
	localName = L["Semicircle"],
	func = function(frame, xOffset, yOffset, size, percent, direction, num, max, uid)
		local vert, horiz = (";"):split(direction)
		local yDiff = size/2 * sin(90 + 180 * (percent))
		local xDiff = -size/2 * cos(90 + 180 * (percent))
		if vert == "UP" then
			yDiff = -yDiff
		end
		local point = "LEFT"
		if horiz == "LEFT" or (horiz == "ALT" and uid%2 == 0) then
			xDiff = -xDiff
			point = "RIGHT"
		end
		local y = yOffset + yDiff
		local x = xOffset + xDiff
		frame:SetPoint(point, UIParent, "CENTER", x, y)
	end,
	defaultDirection = "DOWN;ALT",
	directions = {
		["UP;LEFT"] = L["Up, left"],
		["UP;RIGHT"] = L["Up, right"],
		["UP;ALT"] = L["Up, alternating"],
		["DOWN;LEFT"] = L["Down, left"],
		["DOWN;RIGHT"] = L["Down, right"],
		["DOWN;ALT"] = L["Down, alternating"],
	},
	overlap = true
}

Parrot:RegisterAnimationStyle {
	-- places in the center and shakes around
	name = "Pow",
	localName = L["Pow"],
	func = function(frame, xOffset, yOffset, size, percent, direction, num, max, uid)
		local fsHeight = frame.fontSize
		local topDiff = (max - 1) * 0.5 * fsHeight
		local currDiff = -(num - 1) * fsHeight
		local yDiff = topDiff + currDiff
		local vert, align = (';'):split(direction)
		if vert == "DOWN" then
			yDiff = -yDiff
		end
		local y = yOffset + yDiff
		local x = xOffset
		if percent < 0.1 then
			local newFSHeight = fsHeight*(20*(0.1-percent)+1)
			frame.fs:SetFont(frame.font, newFSHeight, frame.fontOutline)
			if frame.icon then
				frame.icon:SetWidth(newFSHeight)
				frame.icon:SetHeight(newFSHeight)
			end
		else
			frame.fs:SetFont(frame.font, fsHeight, frame.fontOutline)
			if frame.icon then
				frame.icon:SetWidth(fsHeight)
				frame.icon:SetHeight(fsHeight)
			end

			-- now for squiggle
			local now = GetTime()
			if not frame.nextSquiggle or frame.nextSquiggle < now then
				frame.nextSquiggle = now + 0.05
				frame.squiggleX = math.random(-1, 1)
				frame.squiggleY = math.random(-1, 1)
			end
			x = x + frame.squiggleX
			y = y + frame.squiggleY
		end

		frame:SetPoint(validPoints[align] or "CENTER", UIParent, "CENTER", x, y)
	end,
	cleanup = function(frame, scrollArea)
		frame.nextSquiggle = nil
		frame.squiggleX = nil
		frame.squiggleY = nil
	end,
	defaultDirection = "DOWN;CENTER",
	directions = {
		["UP;LEFT"] = L["Up, left-aligned"],
		["UP;RIGHT"] = L["Up, right-aligned"],
		["UP;CENTER"] = L["Up, center-aligned"],
		["DOWN;LEFT"] = L["Down, left-aligned"],
		["DOWN;RIGHT"] = L["Down, right-aligned"],
		["DOWN;CENTER"] = L["Down, center-aligned"],
	},
}

Parrot:RegisterAnimationStyle {
	-- places in the center and shakes around
	name = "Pow2",
	localName = L["Pow"] .. 2,
	func = function(frame, xOffset, yOffset, size, percent, direction, num, max, uid)
		local fsHeight = frame.fontSize
		local topDiff = (max - 1) * 0.5 * fsHeight
		local currDiff = -(num - 1) * fsHeight
		local yDiff = topDiff + currDiff
		local vert, align = (';'):split(direction)
		if vert == "DOWN" then
			yDiff = -yDiff
		end
		local y = yOffset + yDiff
		local x = xOffset
		if percent < 0.1 then
			local newFSHeight = fsHeight*(20*(0.1-percent)+1)
			frame.fs:SetFont(frame.font, newFSHeight, frame.fontOutline)
			if frame.icon then
				frame.icon:SetWidth(newFSHeight)
				frame.icon:SetHeight(newFSHeight)
			end
		else
			frame.fs:SetFont(frame.font, fsHeight, frame.fontOutline)
			if frame.icon then
				frame.icon:SetWidth(fsHeight)
				frame.icon:SetHeight(fsHeight)
			end

		end

		frame:SetPoint(validPoints[align] or "CENTER", UIParent, "CENTER", x, y)
	end,
	cleanup = function(frame, scrollArea)
		frame.nextSquiggle = nil
		frame.squiggleX = nil
		frame.squiggleY = nil
	end,
	defaultDirection = "DOWN;CENTER",
	directions = {
		["UP;LEFT"] = L["Up, left-aligned"],
		["UP;RIGHT"] = L["Up, right-aligned"],
		["UP;CENTER"] = L["Up, center-aligned"],
		["DOWN;LEFT"] = L["Down, left-aligned"],
		["DOWN;RIGHT"] = L["Down, right-aligned"],
		["DOWN;CENTER"] = L["Down, center-aligned"],
	},
}

Parrot:RegisterAnimationStyle {
	-- places in the center
	name = "Static",
	localName = L["Static"],
	func = function(frame, xOffset, yOffset, size, percent, direction, num, max, uid)
		local fsHeight = frame.fontSize
		local topDiff = (max - 1) * 0.5 * fsHeight
		local currDiff = -(num - 1) * fsHeight
		local yDiff = topDiff + currDiff
		local vert, align = (';'):split(direction)
		if vert == "DOWN" then
			yDiff = -yDiff
		end
		local y = yOffset + yDiff
		local x = xOffset
		frame:SetPoint(validPoints[align] or "CENTER", UIParent, "CENTER", x, y)
	end,
	defaultDirection = "DOWN;CENTER",
	directions = {
		["UP;LEFT"] = L["Up, left-aligned"],
		["UP;RIGHT"] = L["Up, right-aligned"],
		["UP;CENTER"] = L["Up, center-aligned"],
		["DOWN;LEFT"] = L["Down, left-aligned"],
		["DOWN;RIGHT"] = L["Down, right-aligned"],
		["DOWN;CENTER"] = L["Down, center-aligned"],
	},
}

Parrot:RegisterAnimationStyle({
		-- makes a parabola in the form of y = (-x - 1)(-x + 0.5) + 1
		name = "Rainbow",
		localName = L["Rainbow"],
		init = function(frame, xOffset, yOffset, size, direction, uid)
			frame.leftRoot = 1 + (math.random()-0.5) / 5
			frame.rightRoot = -0.5 + (math.random()-0.5) / 5
		end,
		func = function(frame, xOffset, yOffset, size, percent, direction, num, max, uid)
			local xDiff = size/2 * percent
			local yDiff = size * (-16/9 * (percent - frame.leftRoot) * (percent - frame.rightRoot) - 0.5)
			local vert, horiz = (";"):split(direction)
			if vert == "UP" then
				yDiff = -yDiff
			end
			local point = "LEFT"
			if horiz == "LEFT" or (horiz == "ALT" and uid%2 == 0) then
				xDiff = -xDiff
				point = "RIGHT"
			end
			local y = yOffset + yDiff
			local x = xOffset + xDiff
			frame:SetPoint(point, UIParent, "CENTER", x, y)
		end,
		cleanup = function(frame, xOffset, yOffset, size, direction, uid)
			frame.leftRoot = nil
			frame.rightRoot = nil
		end,
		overlap = false,
		defaultDirection = "DOWN;ALT",
		directions = {
			["UP;LEFT"] = L["Up, left"],
			["UP;RIGHT"] = L["Up, right"],
			["UP;ALT"] = L["Up, alternating"],
			["DOWN;LEFT"] = L["Down, left"],
			["DOWN;RIGHT"] = L["Down, right"],
			["DOWN;ALT"] = L["Down, alternating"],
		},
})

Parrot:RegisterAnimationStyle({
		-- makes a path going straight to the right with a random y.
		name = "Horizontal",
		localName = L["Horizontal"],
		init = function(frame, xOffset, yOffset, size, direction, uid)
			frame.y = math.random() - 0.5
		end,
		func = function(frame, xOffset, yOffset, size, percent, direction, num, max, uid)
			local xDiff = size * percent
			local point = "LEFT"
			if direction == "LEFT" or (direction == "ALT" and uid%2 == 0) then
				xDiff = -xDiff
				point = "RIGHT"
			end
			local y = yOffset + size * frame.y
			local x = xOffset + xDiff
			frame:SetPoint(point, UIParent, "CENTER", x, y)
		end,
		cleanup = function(frame, xOffset, yOffset, size, direction, uid)
			frame.y = nil
		end,
		overlap = false,
		defaultDirection = "ALT",
		directions = {
			["LEFT"] = L["Left"],
			["RIGHT"] = L["Right"],
			["ALT"] = L["Alternating"],
		},
})

local math_max, math_min = math.max, math.min
Parrot:RegisterAnimationStyle({
		-- Zoom in from the center, linger, zoom out towards the edge
		name = "Action",
		localName = L["Action"], --L["Horizontal"],
		init = function(frame, xOffset, yOffset, size, direction, uid)
			frame.startY = math.random() - 0.5
		end,
		func = function(frame, xOffset, yOffset, size, percent, direction, num, max, uid)
			mod_percent = math.pow(percent, 6)
			local xDiff = size * mod_percent * 6
			local yDiff = size * (percent <= 0.5 and percent or 0.5) * 0.2
			local point = "LEFT"
			if direction == "LEFT" or (direction == "ALT" and uid%2 == 0) then
				xDiff = -xDiff
				point = "RIGHT"
			end
			local x, y = xOffset, yOffset
			x = xOffset + xDiff
			y = yOffset + (frame.startY * size)
			frame:SetScale(math_max(0.1, math_min(percent / 0.1, 1)))
			frame:SetPoint(point, UIParent, "CENTER", x, y)
		end,
		cleanup = function(frame, xOffset, yOffset, size, direction, uid)
			frame.y = nil
		end,
		overlap = false,
		defaultDirection = "ALT",
		directions = {
			["LEFT"] = L["Left"],
			["RIGHT"] = L["Right"],
			["ALT"] = L["Alternating"],
		},
})

Parrot:RegisterAnimationStyle({
		-- Zoom in from the corner, linger, zoom out towards the edge
		name = "Action Sticky",
		localName = L["Action Sticky"], --L["Horizontal"],
		init = function(frame, xOffset, yOffset, size, direction, uid)
			frame.startY = math.random() - 0.5
		end,
		func = function(frame, xOffset, yOffset, size, percent, direction, num, max, uid)
			mod_percent = math.pow(percent, 6)
			local xDiff = size * mod_percent * 6
			local yDiff = size * (percent <= 0.5 and percent or 0.5) * 0.2
			local point = "LEFT"
			if direction == "LEFT" or (direction == "ALT" and uid%2 == 0) then
				xDiff = -xDiff
				point = "RIGHT"
			end
			local x, y = xOffset, yOffset
			x = xOffset + xDiff
			y = yOffset + (frame.startY * size)
			frame:SetScale(math_max(1, 1 + ((0.1 - percent) / 0.1)))
			frame:SetPoint(point, UIParent, "CENTER", x, y)
		end,
		cleanup = function(frame, xOffset, yOffset, size, direction, uid)
			frame.y = nil
		end,
		overlap = false,
		defaultDirection = "ALT",
		directions = {
			["LEFT"] = L["Left"],
			["RIGHT"] = L["Right"],
			["ALT"] = L["Alternating"],
		},
})

Parrot:RegisterAnimationStyle({
		-- makes a parabola in the form of y = (-x - 1)(-x + 0.5) + 1
		name = "Angled",
		localName = L["Angled"],
		init = function(frame, xOffset, yOffset, size, direction, uid)
			frame.finishX = size/2 * (math.random()/2 + 0.75)
			frame.finishY = size/2 * (math.random()/2 + 0.75)
		end,
		func = function(frame, xOffset, yOffset, size, percent, direction, num, max, uid)
			local xDiff, yDiff
			if percent < 0.3 then
				xDiff = percent/0.3 * frame.finishX
				yDiff = -percent/0.3 * frame.finishY
			elseif percent < 0.8 then
				local now = GetTime()
				if not frame.nextSquiggle or now > frame.nextSquiggle then
					frame.nextSquiggle = now + 0.05
					frame.squiggleX = math.random(-1, 1)
					frame.squiggleY = math.random(-1, 1)
				end
				xDiff = frame.finishX + frame.squiggleX
				yDiff = -frame.finishY + frame.squiggleY
			else
				xDiff = ((percent - 0.8)/0.2 + 1) * frame.finishX
				yDiff = -(1 - percent)/0.2 * frame.finishY
			end

			local vert, horiz = (";"):split(direction)
			if vert == "UP" then
				yDiff = -yDiff
			end
			local point = "LEFT"
			if horiz == "LEFT" or (horiz == "ALT" and uid%2 == 0) then
				xDiff = -xDiff
				point = "RIGHT"
			end
			local y = yOffset + yDiff
			local x = xOffset + xDiff
			frame:SetPoint(point, UIParent, "CENTER", x, y)
		end,
		cleanup = function(frame, xOffset, yOffset, size, direction, uid)
			frame.nextSquiggle = nil
			frame.squiggleX = nil
			frame.squiggleY = nil
			frame.finishX = nil
			frame.finishY = nil
		end,
		overlap = false,
		defaultDirection = "DOWN;ALT",
		directions = {
			["UP;LEFT"] = L["Up, left"],
			["UP;RIGHT"] = L["Up, right"],
			["UP;ALT"] = L["Up, alternating"],
			["DOWN;LEFT"] = L["Down, left"],
			["DOWN;RIGHT"] = L["Down, right"],
			["DOWN;ALT"] = L["Down, alternating"],
		},
})

Parrot:RegisterAnimationStyle({
		-- makes a parabola in the form of y = (-x - 1)(-x + 0.5) + 1
		name = "Angled2",
		localName = L["Angled"] .. "2",
		init = function(frame, xOffset, yOffset, size, direction, uid)
			frame.finishX = size/2 * (math.random()/2 + 0.75)
			frame.finishY = size/2 * (math.random()/2 + 0.75)
		end,
		func = function(frame, xOffset, yOffset, size, percent, direction, num, max, uid)
			local xDiff, yDiff
			if percent < 0.3 then
				xDiff = percent/0.3 * frame.finishX
				yDiff = -percent/0.3 * frame.finishY
			elseif percent < 0.8 then
				local now = GetTime()
				xDiff = frame.finishX
				yDiff = -frame.finishY
			else
				xDiff = ((percent - 0.8)/0.2 + 1) * frame.finishX
				yDiff = -(1 - percent)/0.2 * frame.finishY
			end

			local vert, horiz = (";"):split(direction)
			if vert == "UP" then
				yDiff = -yDiff
			end
			local point = "LEFT"
			if horiz == "LEFT" or (horiz == "ALT" and uid%2 == 0) then
				xDiff = -xDiff
				point = "RIGHT"
			end
			local y = yOffset + yDiff
			local x = xOffset + xDiff
			frame:SetPoint(point, UIParent, "CENTER", x, y)
		end,
		cleanup = function(frame, xOffset, yOffset, size, direction, uid)
			frame.nextSquiggle = nil
			frame.squiggleX = nil
			frame.squiggleY = nil
			frame.finishX = nil
			frame.finishY = nil
		end,
		overlap = false,
		defaultDirection = "DOWN;ALT",
		directions = {
			["UP;LEFT"] = L["Up, left"],
			["UP;RIGHT"] = L["Up, right"],
			["UP;ALT"] = L["Up, alternating"],
			["DOWN;LEFT"] = L["Down, left"],
			["DOWN;RIGHT"] = L["Down, right"],
			["DOWN;ALT"] = L["Down, alternating"],
		},
})

Parrot:RegisterAnimationStyle({
		-- makes a parabola in the form of y = (-x - 1)(-x + 0.5) + 1
		name = "Sprinkler",
		localName = L["Sprinkler"],
		init = function(frame, xOffset, yOffset, size, direction, uid)
			local dir, clock = (";"):split(direction)
			local base
			if dir == "RIGHT" then
				base = 0
			elseif dir == "UP" then
				base = 90
			elseif dir == "LEFT" then
				base = 180
			else -- bottom
				base = 270
			end
			local slices = math.floor(size / frame.fs:GetHeight() / 2)
			local diff = (uid%slices)*(120/(slices - 1)) - 60
			if clock == "CCW" then
				diff = -diff
			end
			frame.angle = base + diff
		end,
		func = function(frame, xOffset, yOffset, size, percent, direction, num, max, uid)
			local xDiff, yDiff
			if percent < 0.3 then
				xDiff = percent/0.3 * size/2 * cos(frame.angle)
				yDiff = percent/0.3 * size/2 * sin(frame.angle)
			elseif percent < 0.8 then
				local now = GetTime()
				if not frame.nextSquiggle or now > frame.nextSquiggle then
					frame.nextSquiggle = now + 0.05
					frame.squiggleX = math.random(-1, 1)
					frame.squiggleY = math.random(-1, 1)
				end
				xDiff = size/2 * cos(frame.angle) + frame.squiggleX
				yDiff = size/2 * sin(frame.angle) + frame.squiggleY
			else
				xDiff = ((percent - 0.8)/0.2 + 1) * size/2 * cos(frame.angle)
				yDiff = ((percent - 0.8)/0.2 + 1) * size/2 * sin(frame.angle)
			end

			local y = yOffset + yDiff
			local x = xOffset + xDiff
			local dir, clock = (";"):split(direction)
			local point = "CENTER"
			if dir == "LEFT" then
				point = "RIGHT"
			elseif dir == "RIGHT" then
				point = "LEFT"
			end
			frame:SetPoint(point, UIParent, "CENTER", x, y)
		end,
		cleanup = function(frame, xOffset, yOffset, size, direction, uid)
			frame.nextSquiggle = nil
			frame.squiggleX = nil
			frame.squiggleY = nil
			frame.finishX = nil
			frame.finishY = nil
		end,
		overlap = false,
		defaultDirection = "UP;CCW",
		directions = {
			["UP;CW"] = L["Up, clockwise"],
			["DOWN;CW"] = L["Down, clockwise"],
			["LEFT;CW"] = L["Left, clockwise"],
			["RIGHT;CW"] = L["Right, clockwise"],
			["UP;CCW"] = L["Up, counter-clockwise"],
			["DOWN;CCW"] = L["Down, counter-clockwise"],
			["LEFT;CCW"] = L["Left, counter-clockwise"],
			["RIGHT;CCW"] = L["Right, counter-clockwise"],
		},
})

Parrot:RegisterAnimationStyle({
		-- makes a parabola in the form of y = (-x - 1)(-x + 0.5) + 1
		name = "Sprinkler2",
		localName = L["Sprinkler"] .. "2",
		init = function(frame, xOffset, yOffset, size, direction, uid)
			local dir, clock = (";"):split(direction)
			local base
			if dir == "RIGHT" then
				base = 0
			elseif dir == "UP" then
				base = 90
			elseif dir == "LEFT" then
				base = 180
			else -- bottom
				base = 270
			end
			local slices = math.floor(size / frame.fs:GetHeight() / 2)
			local diff = (uid%slices)*(120/(slices - 1)) - 60
			if clock == "CCW" then
				diff = -diff
			end
			frame.angle = base + diff
		end,
		func = function(frame, xOffset, yOffset, size, percent, direction, num, max, uid)
			local xDiff, yDiff
			if percent < 0.3 then
				xDiff = percent/0.3 * size/2 * cos(frame.angle)
				yDiff = percent/0.3 * size/2 * sin(frame.angle)
			elseif percent < 0.8 then
				local now = GetTime()
				xDiff = size/2 * cos(frame.angle)
				yDiff = size/2 * sin(frame.angle)
			else
				xDiff = ((percent - 0.8)/0.2 + 1) * size/2 * cos(frame.angle)
				yDiff = ((percent - 0.8)/0.2 + 1) * size/2 * sin(frame.angle)
			end

			local y = yOffset + yDiff
			local x = xOffset + xDiff
			local dir, clock = (";"):split(direction)
			local point = "CENTER"
			if dir == "LEFT" then
				point = "RIGHT"
			elseif dir == "RIGHT" then
				point = "LEFT"
			end
			frame:SetPoint(point, UIParent, "CENTER", x, y)
		end,
		cleanup = function(frame, xOffset, yOffset, size, direction, uid)
			frame.nextSquiggle = nil
			frame.squiggleX = nil
			frame.squiggleY = nil
			frame.finishX = nil
			frame.finishY = nil
		end,
		overlap = false,
		defaultDirection = "UP;CCW",
		directions = {
			["UP;CW"] = L["Up, clockwise"],
			["DOWN;CW"] = L["Down, clockwise"],
			["LEFT;CW"] = L["Left, clockwise"],
			["RIGHT;CW"] = L["Right, clockwise"],
			["UP;CCW"] = L["Up, counter-clockwise"],
			["DOWN;CCW"] = L["Down, counter-clockwise"],
			["LEFT;CCW"] = L["Left, counter-clockwise"],
			["RIGHT;CCW"] = L["Right, counter-clockwise"],
		},
})
