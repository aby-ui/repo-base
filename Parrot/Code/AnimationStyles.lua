
local Parrot = Parrot
local Parrot_AnimationStyles = Parrot:NewModule("AnimationStyles")

local animationStyles = {}
local animationStylesChoices = {}

--[[----------------------------------------------------------------------------------
Arguments:
	table - a data table holding the details of an animation style.
Notes:
	* The data table is of the following style:
	<pre>{
		name = "Name of the style in English",
		localName = "Name of the style in the current locale",
		func = function(
			frame, -- the Frame to work with
			xOffset, -- the horizontal offset from the center of the screen
			yOffset, -- the vertical offset from the center of the screen
			size, -- the size of the animation area to work within.
			percent, -- [0, 1] the current percentage done.
			direction, -- a string of the direction specified.
			num, -- the number of the Frame out of the others using the same area.
			max, -- the number of Frames using the same area
			uid, -- the unique ID of the Frame, for the given area.
		)
			frame:SetPoint(...) -- the Frame must be positioned here.
		end,
		init = function( -- this is optional
			frame, -- the Frame to work with
			xOffset, -- the horizontal offset from the center of the screen
			yOffset, -- the vertical offset from the center of the screen
			size, -- the size of the animation area to work within.
			direction, -- a string of the direction specified.
			uid, -- the unique ID of the Frame, for the given area.
		)
			-- this is called before the first func() is called.
		end,
		cleanup = function( -- this is optional
			frame, -- the Frame to work with
			xOffset, -- the horizontal offset from the center of the screen
			yOffset, -- the vertical offset from the center of the screen
			size, -- the size of the animation area to work within.
			direction, -- a string of the direction specified.
			uid, -- the unique ID of the Frame, for the given area.
		)
			-- this is called after the last func() is called.
		end,
		overlap = true, -- or false. This dictates whether Frames should be moved along prematurely if they are overlapping.
		defaultDirection = "UP", -- required if directions is given.
		directions = { -- this is optional
			UP = "Up" -- key-value of backend direction to localized name. This will be exposed to the user, who can choose what direction to go with.
		}
	}</pre>
	* the following fields are available on the frame: .fs (which is the fontstring), .icon (which is the icon, optional), .font, .fontSize, and .fontOutline. With these, you can manipulate the size of the fontstring with <tt>frame.fs:SetFont(frame.font, frame.fontSize*2, frame.fontOutline); if frame.icon then frame.icon:SetWidth(frame.fontSize*2); frame.icon:SetHeight(frame.fontSize*2) end</tt> to double its size.
Example:
	Parrot:RegisterAnimationStyle {
		-- simple vertical
		name = "Straight",
		localName = L["Straight"],
		func = function(frame, xOffset, yOffset, size, percent, direction)
			if direction == "DOWN" then
				percent = 1 - percent
			end
			local y = yOffset + (percent - 0.5) * size
			local x = xOffset
			frame:SetPoint("CENTER", UIParent, "CENTER", x, y)
		end,
		defaultDirection = "DOWN",
		directions = {
			UP = L["Up"],
			DOWN = L["Down"],
		},
		overlap = true,
	}
------------------------------------------------------------------------------------]]
function Parrot_AnimationStyles:RegisterAnimationStyle(data)
	self = Parrot_AnimationStyles -- so people can Parrot:RegisterAnimationStyle
	if type(data) ~= "table" then
		error(("Bad argument #2 to `RegisterAnimationStyle'. Expected %q, got %q."):format("table", type(data)), 2)
	end
	local name = data.name
	if type(name) ~= "string" then
		error(("Bad argument #2 to `RegisterAnimationStyle'. name must be a %q, got %q."):format("string", type(name)), 2)
	end
	local localName = data.localName
	if type(localName) ~= "string" then
		error(("Bad argument #2 to `RegisterAnimationStyle'. localName must be a %q, got %q."):format("string", type(localName)), 2)
	end
	if type(data.func) ~= "function" then
		error(("Bad argument #2 to `RegisterAnimationStyle'. func must be a %q, got %q."):format("function", type(data.func)), 2)
	end
	if data.cleanup and type(data.cleanup) ~= "function" then
		error(("Bad argument #2 to `RegisterAnimationStyle'. cleanup must be a %q or %q, got %q."):format("function", "nil", type(data.cleanup)), 2)
	end
	if data.init and type(data.init) ~= "function" then
		error(("Bad argument #2 to `RegisterAnimationStyle'. init must be a %q or %q, got %q."):format("function", "nil", type(data.init)), 2)
	end
	if data.overlap and data.overlap ~= true then
		error(("Bad argument #2 to `RegisterAnimationStyle'. overlap must be a %q, got %q."):format("boolean", type(data.overlap)), 2)
	end
	if data.directions then
		if type(data.directions) ~= "table" then
			error(("Bad argument #2 to `RegisterAnimationStyle'. directions must be a %q, got %q."):format("table", type(data.directions)), 2)
		end
		if type(data.defaultDirection) ~= "string" then
			error(("Bad argument #2 to `RegisterAnimationStyle'. defaultDirection must be a %q, got %q."):format("string", type(data.defaultDirection)), 2)
		end
	end
	if animationStyles[name] then
		error(("Animation style %q already registered"):format(name), 2)
	end
	animationStyles[name] = data
	animationStylesChoices[name] = localName
end
Parrot.RegisterAnimationStyle = Parrot_AnimationStyles.RegisterAnimationStyle

--[[----------------------------------------------------------------------------------
Arguments:
	string - the name of the animation style, in English.
Returns:
	boolean - whether the animation style has been registered or not.
Example:
	local has = Parrot:HasAnimationStyle("My funky style")
------------------------------------------------------------------------------------]]
function Parrot_AnimationStyles:HasAnimationStyle(name)
	self = Parrot_AnimationStyles -- so people can Parrot:RegisterAnimationStyle
	if type(name) ~= 'string' then
		error(("Bad argument #2 to `HasAnimationStyle'. defaultDirection must be a %q, got %q."):format("string", type(name)))
	end
	return not not animationStyles[name]
end
Parrot.HasAnimationStyle = Parrot_AnimationStyles.HasAnimationStyle

-- #NODOC
function Parrot_AnimationStyles:GetAnimationStyle(name)
	return animationStyles[name] or animationStyles.Straight
end

-- #NODOC
function Parrot_AnimationStyles:GetAnimationStylesChoices()
	return animationStylesChoices
end

-- #NODOC
function Parrot_AnimationStyles:GetAnimationStyleDirectionChoices(name)
	if not animationStyles[name] then
		return
	end
	return animationStyles[name].directions
end
function Parrot_AnimationStyles:GetAnimationStyleDefaultDirection(name)
	if not animationStyles[name] then
		return nil
	end
	return animationStyles[name].defaultDirection
end
