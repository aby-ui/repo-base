-- LibFlyPaper-2.0
-- Functionality for sticking frames to different points on the screen
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

local FlyPaper = LibStub:NewLibrary('LibFlyPaper-2.0', 2)
if not FlyPaper then return end

-- sorted in evaluation order
local POINTS = {
	'TOPLEFT',
	'TOP',
	'TOPRIGHT',
	'RIGHT',
	'BOTTOMRIGHT',
	'BOTTOM',
	'BOTTOMLEFT',
	'LEFT',
	'CENTER'
}

-- translates anchor points into x/y coordinates (bottom left, relative to screen)
local COORDS = {
	BOTTOM = function(l, b, w, h) return l + w/2, b end,
	BOTTOMLEFT = function(l, b, w, h) return l, b end,
	BOTTOMRIGHT = function(l, b, w, h) return l + w, b end,
	CENTER = function(l, b, w, h) return l + w/2, b + h/2 end,
	LEFT = function(l, b, w, h) return l, b + h/2 end,
	RIGHT = function(l, b, w, h) return l + w, b + h/2 end,
	TOP = function(l, b, w, h) return l + w/2, b + h end,
	TOPLEFT = function(l, b, w, h) return l, b + h end,
	TOPRIGHT = function(l, b, w, h) return l + w, b + h end,
}

-- what points we'll anchor to on other frames
local ANCHOR_POINTS = {
	BOTTOM = { 'TOP' },
	BOTTOMLEFT = { 'BOTTOMRIGHT', 'RIGHT', 'TOPLEFT', 'TOP' },
	BOTTOMRIGHT = { 'BOTTOMLEFT', 'LEFT', 'TOPRIGHT', 'TOP' },
	CENTER = { },
	LEFT = { 'RIGHT' },
	RIGHT = { 'LEFT' },
	TOP = { 'BOTTOM' },
	TOPLEFT = { 'TOPRIGHT', 'RIGHT', 'BOTTOMLEFT', 'BOTTOM' },
	TOPRIGHT = { 'TOPLEFT', 'LEFT', 'BOTTOMRIGHT', 'BOTTOM' },
}

-- what points we'll anchor to on the frame's parent
local PARENT_ANCHOR_POINTS = {
	BOTTOM = { 'BOTTOM', 'CENTER' },
	BOTTOMLEFT = { 'BOTTOMLEFT', 'BOTTOM', 'LEFT', 'CENTER' },
	BOTTOMRIGHT = { 'BOTTOMRIGHT', 'BOTTOM', 'RIGHT', 'CENTER' },
	CENTER = { 'CENTER' },
	LEFT = { 'LEFT', 'CENTER' },
	RIGHT = { 'RIGHT', 'CENTER' },
	TOP = { 'TOP', 'CENTER' },
	TOPLEFT = { 'TOPLEFT', 'TOP', 'LEFT', 'CENTER' },
	TOPRIGHT = { 'TOPRIGHT', 'TOP', 'RIGHT', 'CENTER' },
}

-- old anchor ids
local LEGACY_ANCHOR_IDS = {
	BC = {'TOP', 'BOTTOM'},
	BL = {'TOPLEFT', 'BOTTOMLEFT'},
	BR = {'TOPRIGHT', 'BOTTOMRIGHT'},
	LB = {'BOTTOMRIGHT', 'BOTTOMLEFT'},
	LC = {'RIGHT', 'LEFT'},
	LT = {'TOPRIGHT', 'TOPLEFT'},
	RB = {'BOTTOMLEFT', 'BOTTOMRIGHT'},
	RC = {'LEFT', 'RIGHT'},
	RT = {'TOPLEFT', 'TOPRIGHT'},
	TC = {'BOTTOM', 'TOP'},
	TL = {'BOTTOMLEFT', 'TOPLEFT'},
	TR = {'BOTTOMRIGHT', 'TOPRIGHT'},
}

-- gets the scaled rect values for frame
-- basically here to work around classic maybe not having GetScaledRect
local function GetScaledRect(frame, xOff, yOff)
	xOff = tonumber(xOff) or 0
	yOff = tonumber(yOff) or 0

	local l, b, w, h = frame:GetRect()

	l = (l or 0) - xOff
	b = (b or 0) - yOff
	w = (w or 0) + xOff
	h = (h or 0) + yOff

	local s = frame:GetEffectiveScale()

	return l * s, b * s, w * s, h * s
end

local function GetRelativeRect(frame, relFrame, xOff, yOff)
	local l, b, w, h = GetScaledRect(frame, xOff, yOff)
	local s = relFrame:GetEffectiveScale()

	return l / s, b / s, w / s, h /s
end

-- two dimensional distance
local function GetDistance(x1, y1, x2, y2)
	return math.sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2)
end

local function GetNearestMultiple(value, factor)
	return _G.Round(value / factor) * factor
end

-- returns true if <frame> or one of the frames that <frame> is dependent on
-- is anchored to <otherFrame> and nil otherwise
local function IsFrameDependentOnFrame(frame, otherFrame)
	if frame == nil then
		return false
	end

	if otherFrame == nil then
		return false
	end

	if frame == otherFrame then
		return true
	end

	local points = frame:GetNumPoints()
	for i = 1, points do
		local _, relFrame = frame:GetPoint(i)
		if relFrame and IsFrameDependentOnFrame(relFrame, otherFrame) then
			return true
		end
	end
end

-- iterate through all anchor points
-- return the one with the shortest distance
local function GetBestAnchorToPointForFrame(frame, point, relFrame, anchors, xOff, yOff)
	if IsFrameDependentOnFrame(relFrame, frame) then
		return
	end

	local bestDistance = math.huge
	local bestRelPoint, bestX, bestY

	local fl, fb, fw, fh = GetRelativeRect(frame, relFrame, xOff, yOff)
	local rl, rb, rw, rh = relFrame:GetRect()
	local fx, fy = COORDS[point](fl, fb, fw, fh)

	for _, relPoint in ipairs(anchors[point]) do
		local rx, ry = COORDS[relPoint](rl, rb, rw, rh)
		local distance = GetDistance(fx, fy, rx, ry)

		if distance < bestDistance then
			bestDistance = distance
			bestRelPoint = relPoint
			bestX = fx - rx
			bestY = fy - ry
		end
	end

	if bestRelPoint then
		local scale = frame:GetEffectiveScale() / relFrame:GetEffectiveScale()

		return bestRelPoint, bestX / scale, bestY / scale, bestDistance
	end
end

local function GetBestAnchorForFrame(frame, relFrame, anchors, xOff, yOff)
	if IsFrameDependentOnFrame(relFrame, frame) then
		return
	end

	local bestDistance = math.huge
	local bestPoint
	local bestRelPoint
	local bestX
	local bestY

	for _, point in ipairs(POINTS) do
		local relPoint, x, y, distance = GetBestAnchorToPointForFrame(frame, point, relFrame, anchors, xOff, yOff)

		if distance and distance < bestDistance then
			bestDistance = distance
			bestPoint = point
			bestRelPoint = relPoint
			bestX = x
			bestY = y
		end
	end

	return bestPoint, bestRelPoint, bestX, bestY, bestDistance
end

local function GetBestAnchorToPointForFrames(frame, point, relFrames, anchors, xOff, yOff)
	local bestDistance = math.huge
	local bestRelFrame
	local bestRelPoint
	local bestX
	local bestY

	for _, relFrame in pairs(relFrames) do
		local relPoint, x, y, distance = GetBestAnchorToPointForFrame(frame, point, relFrame, anchors, xOff, yOff)

		if distance and distance < bestDistance then
			bestDistance = distance
			bestRelPoint = relPoint
			bestRelFrame = relFrame
			bestX = x
			bestY = y
		end
	end

	return bestRelFrame, bestRelPoint, bestX, bestY, bestDistance
end

local function GetBestAnchorForFrames(frame, relFrames, anchors, xOff, yOff)
	local bestDistance = math.huge
	local bestPoint
	local bestRelFrame
	local bestRelPoint
	local bestX
	local bestY

	for _, point in ipairs(POINTS) do
		local relFrame, relPoint, x, y, distance = GetBestAnchorToPointForFrames(frame, point, relFrames, anchors, xOff, yOff)

		if distance and distance < bestDistance then
			bestDistance = distance
			bestPoint = point
			bestRelPoint = relPoint
			bestRelFrame = relFrame
			bestX = x
			bestY = y
		end
	end

	return bestPoint, bestRelFrame, bestRelPoint, bestX, bestY, bestDistance
end

--------------------------------------------------------------------------------
-- Public API
--------------------------------------------------------------------------------

if not FlyPaper._callbacks then
	FlyPaper._callbacks = _G.LibStub("CallbackHandler-1.0"):New(FlyPaper)
end

--------------------------------------------------------------------------------
-- best anchor - any registered frame
--------------------------------------------------------------------------------

-- iterates through all registered frames and returns the closest anchor point
-- parameters:
-- @frame: what frame to attempt to anchor (required)
-- @olerance: how far away another frame can be
-- @xOff: any additional horizontal spacing to apply
-- @yOff: any additional vertical spacing to apply
-- returns: point, relFrame, relPoint, x, y
function FlyPaper.GetBestAnchor(frame, tolerance, xOff, yOff)
	if not frame then
		return
	end

	local registry = FlyPaper._registry
	if not registry then
		return
	end

    tolerance = tonumber(tolerance) or math.huge
	xOff = tonumber(xOff) or 0
	yOff = tonumber(yOff) or 0

	local bestDistance = math.huge
	local bestPoint
	local bestRelFrame
	local bestRelPoint
	local bestX
	local bestY

	for _, group in pairs(registry) do
		local point, relFrame, relPoint, x, y, distance = GetBestAnchorForFrames(frame, group, ANCHOR_POINTS, xOff, yOff)

		if distance < bestDistance then
			bestDistance = distance
			bestPoint = point
			bestRelFrame = relFrame
			bestRelPoint = relPoint
			bestX = x
			bestY = y
		end
	end

	if bestPoint and bestDistance <= tolerance then
		return bestPoint, bestRelFrame, bestRelPoint, bestX, bestY, bestDistance
	end
end

function FlyPaper.GetBestAnchorToPoint(frame, point, tolerance, xOff, yOff)
	if not frame then
		return
	end

	local registry = FlyPaper._registry
	if not registry then
		return
	end

    tolerance = tonumber(tolerance) or math.huge
	xOff = tonumber(xOff) or 0
	yOff = tonumber(yOff) or 0

	local bestDistance = math.huge
	local bestRelFrame
	local bestRelPoint
	local bestX
	local bestY

	for _, group in pairs(registry) do
		local relFrame, relPoint, x, y, distance = GetBestAnchorToPointForFrames(frame, point, group, ANCHOR_POINTS, xOff, yOff)

		if distance < bestDistance then
			bestDistance = distance
			bestRelFrame = relFrame
			bestRelPoint = relPoint
			bestX = x
			bestY = y
		end
	end

	if bestRelFrame and bestDistance <= tolerance then
		return bestRelFrame, bestRelPoint, bestX, bestY, bestDistance
	end
end

--------------------------------------------------------------------------------
-- best anchor - any registered frame within <groupName>
--------------------------------------------------------------------------------

-- iterates through all registered frames and returns the closest anchor point
-- parameters:
-- @frame: what frame to attempt to anchor (required)
-- @groupName: what group of frames to check
-- @tolerance: how far away another frame can be
-- @xOff: any additional horizontal spacing to apply
-- @yOff: any additional vertical spacing to apply
-- returns: point, relFrame, relPoint, x, y
function FlyPaper.GetBestAnchorForGroup(frame, groupName, tolerance, xOff, yOff)
	if not frame then
		return
	end

	local registry = FlyPaper._registry
	if not registry then
		return
	end

	local group = groupName and registry[groupName]
	if not group then
		return
	end

    tolerance = tonumber(tolerance) or math.huge
	xOff = tonumber(xOff) or 0
	yOff = tonumber(yOff) or 0

	local point, relFrame, relPoint, x, y, distance = GetBestAnchorForFrames(frame, group, ANCHOR_POINTS, xOff, yOff)

	if point and distance <= tolerance then
		return point, relFrame, relPoint, x, y, distance
	end
end

function FlyPaper.GetBestAnchorToPointForGroup(frame, point, groupName, tolerance, xOff, yOff)
	if not frame then
		return
	end

	local registry = FlyPaper._registry
	if not registry then
		return
	end

	local group = groupName and registry[groupName]
	if not group then
		return
	end

    tolerance = tonumber(tolerance) or math.huge
	xOff = tonumber(xOff) or 0
	yOff = tonumber(yOff) or 0

	local relFrame, relPoint, x, y, distance = GetBestAnchorToPointForFrames(frame, point, group, ANCHOR_POINTS, xOff, yOff)
	if relFrame and distance <= tolerance then
		return relFrame, relPoint, x, y, distance
	end
end

--------------------------------------------------------------------------------
-- best anchor - specific frame
--------------------------------------------------------------------------------

function FlyPaper.GetBestAnchorForFrame(frame, relFrame, tolerance, xOff, yOff)
	if not (frame and relFrame) then
		return
	end

    tolerance = tonumber(tolerance) or math.huge
	xOff = tonumber(xOff) or 0
	yOff = tonumber(yOff) or 0

	local point, relPoint, x, y, distance = GetBestAnchorForFrame(frame, relFrame, ANCHOR_POINTS, xOff, yOff)
	if point and distance <= tolerance then
		return point, relPoint, x, y, distance
	end
end

function FlyPaper.GetBestAnchorToPointForFrame(frame, point, relFrame, tolerance, xOff, yOff)
	if not (frame and point and relFrame) then
		return
	end

    tolerance = tonumber(tolerance) or math.huge
	xOff = tonumber(xOff) or 0
	yOff = tonumber(yOff) or 0

	local relPoint, x, y, distance = GetBestAnchorToPointForFrame(frame, point, relFrame, ANCHOR_POINTS, xOff, yOff)
	if relPoint and distance <= tolerance then
		return relPoint, x, y, distance
	end
end

--------------------------------------------------------------------------------
-- best anchor - within parent
--------------------------------------------------------------------------------

function FlyPaper.GetBestAnchorForParent(frame, tolerance, xOff, yOff)
	if not frame then
		return
	end

	local parent = frame:GetParent()
	if not parent then
		return
	end

	tolerance = tonumber(tolerance) or math.huge
	xOff = tonumber(xOff) or 0
	yOff = tonumber(yOff) or 0

	local point, relPoint, x, y, distance = GetBestAnchorForFrame(frame, parent, PARENT_ANCHOR_POINTS, xOff, yOff)

	if distance and distance <= tolerance then
		return point, relPoint, x, y, distance
	end
end


function FlyPaper.GetBestAnchorToPointForParent(frame, point, tolerance, xOff, yOff)
	if not (frame and point) then
		return
	end

	local parent = frame:GetParent()
	if not parent then
		return
	end

	tolerance = tonumber(tolerance) or math.huge
	xOff = tonumber(xOff) or 0
	yOff = tonumber(yOff) or 0

	local relPoint, x, y, distance = GetBestAnchorToPointForFrame(frame, point, parent, PARENT_ANCHOR_POINTS, xOff, yOff)
	if distance and distance <= tolerance then
		return relPoint, x, y, distance
	end
end

--------------------------------------------------------------------------------
-- best anchor - within parent grid
--------------------------------------------------------------------------------

function FlyPaper.GetBestAnchorForParentGrid(frame, xScale, yScale, tolerance, xOff, yOff)
	if not frame then
		return
	end

	local parent = frame:GetParent()
	if not parent then
		return
	end

    -- get the grid size
    local bestDistance = math.huge
    local bestPoint, bestRelPoint, bestX, bestY

    -- iterate through all frame points
	for _, point in ipairs(POINTS) do
		local relPoint, x, y, distance = FlyPaper.GetBestAnchorToPointForParentGrid(frame, point, xScale, yScale, tolerance, xOff, yOff)

        -- keep it if its better
        if distance and distance < bestDistance then
            bestDistance = distance
			bestPoint = point
			bestRelPoint = relPoint
            bestX = x
            bestY = y
        end
    end

    if bestDistance <= tolerance then
        return bestPoint, bestRelPoint, bestX, bestY, bestDistance
    end
end

function FlyPaper.GetBestAnchorToPointForParentGrid(frame, point, xScale, yScale, tolerance, xOff, yOff)
	--due to changes in Dominos_Config\overlay\ui.lua to
	--function "DrawGrid", grid snapping must now be based off screen center.
	if not frame then
		return
	end

	local parent = frame:GetParent()
	if not parent then
		return
	end

	xScale = tonumber(xScale) or 1
    yScale = tonumber(yScale) or 1
    tolerance = tonumber(tolerance) or math.huge
	xOff = tonumber(xOff) or 0
	yOff = tonumber(yOff) or 0

	-- get the coordinates for the frame point
	local fx, fy = COORDS[point](GetRelativeRect(frame, parent, xOff, yOff))
	local cX, cY = parent:GetWidth()/2, parent:GetHeight()/2

	local x = (GetNearestMultiple(fx - cX, xScale)) + cX --nearest vertex, based off screen center.
	local y = (GetNearestMultiple(fy - cY, yScale)) + cY

	-- return it if its within the limit
	local distance = GetDistance(fx, fy, x, y)
	if distance <= tolerance then
		local scale = frame:GetScale()

		return 'BOTTOMLEFT', x / scale, y / scale, distance
	end
end

--------------------------------------------------------------------------------
-- frame registry
--------------------------------------------------------------------------------

function FlyPaper.AddFrame(groupName, id, frame)
	local registry = FlyPaper._registry
	if not registry then
		registry = {}
		FlyPaper._registry = registry
	end

	local group = FlyPaper._registry[groupName]
	if not group then
		group = {}
		registry[groupName] = group
	end

	if not group[id] then
		group[id] = frame
		FlyPaper._callbacks:Fire('OnAddFrame', frame, groupName, id)
		return true
	end
end

function FlyPaper.RemoveFrame(groupName, id)
	local registry = FlyPaper._registry
	if not registry then
		return
	end

	local group = FlyPaper._registry[groupName]
	if not group then
		return
	end

	local frame = group[id]
	if frame then
		group[id] = nil
		FlyPaper._callbacks:Fire('OnRemoveFrame', frame, groupName, id)
		return true
	end
end

function FlyPaper.GetFrame(groupName, id)
	local registry = FlyPaper._registry
	if not registry then
		return
	end

	local group = FlyPaper._registry[groupName]
	if not group then
		return
	end

	return group[id]
end

function FlyPaper.GetFrameInfo(frame)
	local registry = FlyPaper._registry
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

--------------------------------------------------------------------------------
-- Frame Utilities
--------------------------------------------------------------------------------

-- scales the frame, preserving its current position
function FlyPaper.SetScale(frame, scale)
	local oldScale = frame:GetScale() or 1
	local newScale = tonumber(scale) or 1

	if _G.Round(oldScale * 100) == _G.Round(newScale * 100) then
		return
	end

	local ratio
	if (newScale == 0 or oldScale == 0) then
		ratio = 0
	else
		ratio = oldScale / newScale
	end

	local point, relFrame, relPoint, x, y = frame:GetPoint()

	frame:ClearAllPoints()
	frame:SetScale(newScale)
	frame:SetPoint(point, relFrame, relPoint, x * ratio, y * ratio)

	return true
end

-- returns true if the given frame is currently anchored to another frame
function FlyPaper.IsAnchored(frame)
	local parent = frame:GetParent() or nil

	local points = frame:GetNumPoints()
	for i = 1, points do
		local _, relFrame = frame:GetPoint(i)
		if relFrame and relFrame ~= parent then
			return true
		end
	end
end

function FlyPaper.GetNearestPointToCursor(frame, tolerance, xOff, yOff)
	local cx, cy = _G.GetCursorPosition()
	local l, b, w, h = GetRelativeRect(frame, _G.UIParent, xOff, yOff)

	local relPoint = 'BOTTOMLEFT'
	local relFrame = _G.UIParent

	local bestDistance = math.huge
	local bestPoint

	for _, point in ipairs(POINTS) do
		local fx, fy = COORDS[point](l, b, w, h)

		local distance = GetDistance(fx, fy, cx, cy)

		if distance < bestDistance then
			bestDistance = distance
			bestPoint = point
		end
	end

	if bestPoint and bestDistance <= tolerance then
		local bestX, bestY = COORDS[relPoint](-xOff, -yOff, xOff, yOff)
		local scale = frame:GetEffectiveScale() / relFrame:GetEffectiveScale()

		return bestPoint, relFrame, relPoint, bestX / scale, bestY / scale, bestDistance
	end
end

function FlyPaper.ConvertAnchorId(anchorId)
	if not anchorId then return end

	local info = LEGACY_ANCHOR_IDS[anchorId]
	if info then
		return unpack(info)
	end
end
