-- LibFlyPaper-1.1
-- Functionality for sticking one frome to another frame
--
-- Copyright 2020 Jason Greer
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

local LibFlyPaper = LibStub:NewLibrary('LibFlyPaper-1.1', 0)
if not LibFlyPaper then return end

local DEFAULT_STICKY_TOLERANCE = 16

-- all possible frame stratas (used for z distance calculations)
local FRAME_STRATAS = {
	BACKGROUND = 1,
	LOW = 2,
	MEDIUM = 3,
	HIGH = 4,
	DIALOG = 5,
	FULLSCREEN = 6,
	FULLSCREEN_DIALOG = 7,
	TOOLTIP = 8
}

--------------------------------------------------------------------------------
-- a rough diagram of frame anchors. Anchor names are based upon the point on
-- the frame we're attaching to
--
--    BL BC BR
-- TR TL T  TR TL
-- RC L      R LC
-- BR BL B  BR BL
--    TL TC BL
--
-- So, for example, BL refers to anchoring the top left of a frame to the
-- bottom left of another frame
--------------------------------------------------------------------------------

-- sorted in evaluation orders
local FRAME_ANCHORS = {
	"TL",
	"TR",
	"TC",
	"BL",
	"BR",
	"BC",
	"LT",
	"LB",
	"LC",
	"RT",
	"RB",
	"RC"
}

local FRAME_ANCHOR_POINTS = {
	-- bottom to top
	TL = {'BOTTOMLEFT', 'TOPLEFT', 0, 1},
	TR = {'BOTTOMRIGHT', 'TOPRIGHT', 0, 1},
	TC = {'BOTTOM', 'TOP', 0, 1},
	-- top to bottom
	BL = {'TOPLEFT', 'BOTTOMLEFT', 0, -1},
	BR = {'TOPRIGHT', 'BOTTOMRIGHT', 0, -1},
	BC = {'TOP', 'BOTTOM', 0, -1},
	-- right to left
	LT = {'TOPRIGHT', 'TOPLEFT', -1, 0},
	LB = {'BOTTOMRIGHT', 'BOTTOMLEFT', -1, 0},
	LC = {'RIGHT', 'LEFT', -1, 0},
	-- left to right
	RT = {'TOPLEFT', 'TOPRIGHT', 1, 0},
	RB = {'BOTTOMLEFT', 'BOTTOMRIGHT', 1, 0},
	RC = {'LEFT', 'RIGHT', 1, 0},
}

-- translates anchor points into x/y coordinates (bottom left origin)
local COORDS = {
	TOPLEFT = function(l, b, w, h) return l, b + h end,
	TOP = function(l, b, w, h) return l + w/2, b + h end,
	TOPRIGHT = function(l, b, w, h) return l + w, b + h end,
	RIGHT = function(l, b, w, h) return l + w, b + h/2 end,
	BOTTOMRIGHT = function(l, b, w, h) return l + w, b end,
	BOTTOM = function(l, b, w, h) return l + w/2, b end,
	BOTTOMLEFT = function(l, b, w, h) return l, b end,
	LEFT = function(l, b, w, h) return l, b + h/2 end,
	CENTER = function(l, b, w, h) return l + w/2, b + h/2 end,
}

local function IsValidAnchor(anchor)
	for _, a in pairs(FRAME_ANCHORS) do
		if a == anchor then
			return true
		end
	end
	return false
end

-- gets the scaled rect values for frame
-- basically here to work around classic maybe not having GetScaledRect
local function GetScaledRect(frame)
	if frame.GetScaledRect then
		return frame:GetScaledRect()
	end

	local l, b, w, h = frame:GetRect()
	local s = frame:GetEffectiveScale()

	return l * s, b * s, w * s, h * s
end

-- two dimensional distance
local function GetSquaredDistance(x1, y1, x2, y2)
	return (x1 - x2) ^ 2 + (y1 - y2) ^ 2
end

-- returns true if <frame> or one of the frames that <frame> is dependent on
-- is anchored to <otherFrame> and nil otherwise
local function IsFrameDependentOnFrame(frame, otherFrame)
	if frame and otherFrame then
		if frame == otherFrame then
			return true
		end

		local points = frame:GetNumPoints()
		for i = 1, points do
			local _, parent = frame:GetPoint(i)
			if IsFrameDependentOnFrame(parent, otherFrame) then
				return true
			end
		end
	end
end

-- returns true if its actually possible to attach the two frames without error
local function CanAttach(frame, otherFrame)
	return frame and otherFrame and not IsFrameDependentOnFrame(otherFrame, frame)
end

-- returns the addon id and addonName associated with the specified frame
local function GetFrameGroup(frame)
	local registry = LibFlyPaper._registry
	if not registry then
		return
	end

	for groupName, group in pairs(registry) do
		for groupId, groupFrame in pairs(group) do
			if groupFrame == frame then
				return groupName, groupId
			end
		end
	end
end

-- returns 0 if a frame is in the same group as another frame
-- and 0 otherwise
local function GetGroupDistance(frame, otherFrame)
	if frame == otherFrame then
		return 0
	end

	if GetFrameGroup(frame) == GetFrameGroup(otherFrame) then
		return 0
	end

	return 1
end

local function GetZDistance(frame, otherFrame)
	if frame == otherFrame then
		return 0
	end

	local s1 = FRAME_STRATAS[frame:GetFrameStrata()]
	local s2 = FRAME_STRATAS[otherFrame:GetFrameStrata()]
	local l1 = frame:GetFrameLevel()
	local l2 = otherFrame:GetFrameLevel()

	return GetSquaredDistance(s1, l1, s2, l2)
end

-- iterate through all anchor points
-- return the one with the shortest distance
local function GetClosestAnchor(frame, otherFrame)
	if frame == otherFrame then
		return
	end

	local bestDistance = math.huge
	local bestAnchor = false
	local l1, b1, w1, h1 = GetScaledRect(frame)
	local l2, b2, w2, h2 = GetScaledRect(otherFrame)

	for i = 1, #FRAME_ANCHORS do
		local anchor = FRAME_ANCHORS[i]
		local point, relPoint = unpack(FRAME_ANCHOR_POINTS[anchor])
		local x1, y1 = COORDS[point](l1, b1, w1, h1)
		local x2, y2 = COORDS[relPoint](l2, b2, w2, h2)
		local distance = GetSquaredDistance(x1, y1, x2, y2)

		if distance < bestDistance then
			bestDistance = distance
			bestAnchor = anchor
		end
	end

	return bestAnchor, bestDistance
end

local function GetClosestFrame(frame, registry, tolerance)
	local maxDistance = (tonumber(tolerance) or DEFAULT_STICKY_TOLERANCE) ^ 2
	local bestAnchor
	local bestDistance = math.huge
	local bestFrame
	local bestId

	for rId, rFrame in pairs(registry) do
		if CanAttach(frame, rFrame) then
			local anchor, distance = GetClosestAnchor(frame, rFrame)

			if distance <= maxDistance then
				-- prioritize frames on the same layer
				distance = distance + GetZDistance(frame, rFrame)

				-- prioritize frames from the same addon
				distance = distance + GetGroupDistance(frame, rFrame)

				if distance < bestDistance then
					bestAnchor = anchor
					bestDistance = distance
					bestFrame = rFrame
					bestId = rId
				end
			end
		end
	end

	return bestFrame, bestAnchor, bestId, bestDistance
end

local function AnchorFrame(frame, relFrame, anchor, xOff, yOff)
	local point, relPoint, xMult, yMult = unpack(FRAME_ANCHOR_POINTS[anchor])
	local s = frame:GetEffectiveScale()
	local x = ((tonumber(xOff) or 0) * xMult) / s
	local y = ((tonumber(yOff) or 0) * yMult) / s

	frame:ClearAllPoints()
	frame:SetPoint(point, relFrame, relPoint, x, y)

	LibFlyPaper._callbacks:Fire('OnAnchorFrame', frame, relFrame, anchor, x, y)
end

--------------------------------------------------------------------------------
-- Public API
--------------------------------------------------------------------------------

if not LibFlyPaper._callbacks then
	LibFlyPaper._callbacks = LibStub("CallbackHandler-1.0"):New(LibFlyPaper)
end

-- attempts to attach <frame> to <relFrame>
-- tolerance: how close the frames need to be to attach
-- xOff: horizontal spacing to include between each frame
-- yOff: vertical spacing to include between each frame
-- returns an anchor point if attached and nil otherwise
function LibFlyPaper.Stick(frame, relFrame, tolerance, xOff, yOff)
	if not CanAttach(frame, relFrame) then
		return
	end

	local anchor, distance = GetClosestAnchor(frame, relFrame)
	local maxDistance = (tonumber(tolerance) or DEFAULT_STICKY_TOLERANCE) ^ 2

	if distance <= maxDistance then
		AnchorFrame(frame, relFrame, anchor, xOff, yOff)
		return anchor, distance
	end
end

-- attempts to anchor frame to a specific anchor point on relFrame
-- point: any non nil return value of LibFlyPaper.Stick
-- xOff: horizontal spacing to include between each frame
-- yOff: vertical spacing to include between each frame
-- returns an anchor point if attached and nil otherwise
function LibFlyPaper.StickToAnchor(frame, relFrame, anchor, xOff, yOff)
	if IsValidAnchor(anchor) and CanAttach(frame, relFrame) then
		AnchorFrame(frame, relFrame, anchor, xOff, yOff)
		return anchor
	end
end

-- api compatibility with v1
LibFlyPaper.StickToPoint = LibFlyPaper.StickToAnchor

-- iterate through all registered frames in namespace
function LibFlyPaper.StickToClosestFrame(frame, tolerance, xOff, yOff)
	local registry = LibFlyPaper._registry
	if not registry then
		return
	end

	local bestAnchor
	local bestDistance = math.huge
	local bestGroup
	local bestId
	local bestRelFrame

	for groupName, group in pairs(registry) do
		local relFrame, anchor, id, distance = GetClosestFrame(frame, group, tolerance)

		if distance < bestDistance then
			bestAnchor = anchor
			bestDistance = distance
			bestGroup = groupName
			bestId = id
			bestRelFrame = relFrame
		end
	end

	if bestRelFrame then
		AnchorFrame(frame, bestRelFrame, bestAnchor, xOff, yOff)
		return bestAnchor, bestGroup, bestId, bestRelFrame
	end
end

-- iterate through all registered frames, and try to stick to the nearest one
function LibFlyPaper.StickToClosestFrameInGroup(frame, groupName, tolerance, xOff, yOff)
	local registry = LibFlyPaper._registry
	if not registry then
		return
	end

	local group = registry[groupName]
	if not group then
		return
	end

	local relFrame, anchor, id = GetClosestFrame(frame, group, tolerance)

	if relFrame then
		AnchorFrame(frame, relFrame, anchor, xOff, yOff)
		return anchor, id, relFrame
	end
end

function LibFlyPaper.AddFrame(groupName, id, frame)
	local registry = LibFlyPaper._registry
	if not registry then
		registry = {}
		LibFlyPaper._registry = registry
	end

	local group = LibFlyPaper._registry[groupName]
	if not group then
		group = {}
		registry[groupName] = group
	end

	if not group[id] then
		group[id] = frame
		LibFlyPaper._callbacks:Fire('OnAddFrame', frame, groupName, id)
		return true
	end
end

function LibFlyPaper.RemoveFrame(groupName, id)
	local registry = LibFlyPaper._registry
	if not registry then
		return
	end

	local group = LibFlyPaper._registry[groupName]
	if not group then
		return
	end

	local frame = group[id]
	if frame then
		group[id] = nil
		LibFlyPaper._callbacks:Fire('OnRemoveFrame', frame, groupName, id)
		return true
	end
end

function LibFlyPaper.GetFrame(groupName, id)
	local registry = LibFlyPaper._registry
	if not registry then
		return
	end

	local group = LibFlyPaper._registry[groupName]
	if not group then
		return
	end

	return group[id]
end

function LibFlyPaper.GetFrameInfo(frame)
	local registry = LibFlyPaper._registry
	if not registry then
		return
	end

	for groupName, group in pairs(registry) do
		for groupId, groupFrame in pairs(group) do
			if frame == groupFrame then
				return groupName, groupId
			end
		end
	end
end

function LibFlyPaper.GetDefaultStickyTolerance()
	return DEFAULT_STICKY_TOLERANCE
end