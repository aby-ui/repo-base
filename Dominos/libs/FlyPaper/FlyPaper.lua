--[[
	FlyPaper
		Functionality for sticking one frome to another frame

	Methods:
		FlyPaper.Stick(frame, otherFrame, tolerance, xOff, yOff) - Attempts to attach <frame> to <otherFrame>
			tolerance - how close the frames need to be to attach
			xOff - how close, horizontally, the frames should be attached
			yOff - how close, vertically, the frames should be attached

		FlyPaper.StickToPoint(frame, otherFrame, point, xOff, yOff) - attempts to anchor <frame> to a specific point on <otherFrame>
			point - any non nil return value of FlyPaper.Stick
--]]

--[[
		This work is in the Public Domain. To view a copy of the public domain certification, 
		visit http://creativecommons.org/licenses/publicdomain/ or send a letter to Creative Commons, 
		171 Second Street, Suite 300, San Francisco, California, 94105, USA.
--]]



--[[ library stuff ]]--

local VERSION = 2
if FlyPaper and tonumber(FlyPaper.version) and tonumber(FlyPaper.version) >= VERSION then 
	return 
end

if not FlyPaper then
	FlyPaper = {version = VERSION}
else
	FlyPaper.version = VERSION
end


--returns true if <frame>, or one of the frames that <frame> is dependent on, is anchored to <otherFrame>.  Returns nil otherwise.
local function FrameIsDependentOnFrame(frame, otherFrame)
	if (frame and otherFrame) then
		if frame == otherFrame then 
			return true 
		end

		local points = frame:GetNumPoints()
		for i = 1, points do
			local parent = select(2, frame:GetPoint(i))
			if FrameIsDependentOnFrame(parent, otherFrame) then
				return true
			end
		end
	end
end

--returns true if its actually possible to attach the two frames without error
local function CanAttach(frame, otherFrame)
	if not(frame and otherFrame) then
		return
	elseif frame:GetNumPoints() == 0 or otherFrame:GetNumPoints() == 0 then
		return
	elseif frame:GetWidth() == 0 or frame:GetHeight() == 0 or otherFrame:GetWidth() == 0 or otherFrame:GetHeight() == 0 then
		return
	elseif FrameIsDependentOnFrame(otherFrame, frame) then
		return
	end
	return true
end


--[[ Attachment Functions ]]--

local function AttachToTop(frame, otherFrame, distLeft, distRight, distCenter, offset)
	frame:ClearAllPoints()
	--closest to the left
	if distLeft < distCenter and distLeft < distRight then
		frame:SetPoint('BOTTOMLEFT', otherFrame, 'TOPLEFT', 0, offset)
		return 'TL'
	--closest to the right
	elseif distRight < distCenter and distRight < distLeft then
		frame:SetPoint('BOTTOMRIGHT', otherFrame, 'TOPRIGHT', 0, offset)
		return 'TR'
	--closest to the center
	else
		frame:SetPoint('BOTTOM', otherFrame, 'TOP', 0, offset)
		return 'TC'
	end
end

local function AttachToBottom(frame, otherFrame, distLeft, distRight, distCenter, offset)
	frame:ClearAllPoints()
	--bottomleft
	if distLeft < distCenter and distLeft < distRight then
		frame:SetPoint('TOPLEFT', otherFrame, 'BOTTOMLEFT', 0, -offset)
		return 'BL'
	--bottomright
	elseif distRight < distCenter and distRight < distLeft then
		frame:SetPoint('TOPRIGHT', otherFrame, 'BOTTOMRIGHT', 0, -offset)
		return 'BR'
	--bottom
	else
		frame:SetPoint('TOP', otherFrame, 'BOTTOM', 0, -offset)
		return 'BC'
	end
end

local function AttachToLeft(frame, otherFrame, distTop, distBottom, distCenter, offset)
	frame:ClearAllPoints()
	--bottomleft
	if distBottom < distTop and distBottom < distCenter then
		frame:SetPoint('BOTTOMRIGHT', otherFrame, 'BOTTOMLEFT', -offset, 0)
		return 'LB'
	--topleft
	elseif distTop < distBottom and distTop < distCenter then
		frame:SetPoint('TOPRIGHT', otherFrame, 'TOPLEFT', -offset, 0)
		return 'LT'
	--left
	else
		frame:SetPoint('RIGHT', otherFrame, 'LEFT', -offset, 0)
		return 'LC'
	end
end

local function AttachToRight(frame, otherFrame, distTop, distBottom, distCenter, offset)
	frame:ClearAllPoints()
	--bottomright
	if distBottom < distTop and distBottom < distCenter then
		frame:SetPoint('BOTTOMLEFT', otherFrame, 'BOTTOMRIGHT', offset, 0)
		return 'RB'
	--topright
	elseif distTop < distBottom and distTop < distCenter then
		frame:SetPoint('TOPLEFT', otherFrame, 'TOPRIGHT', offset, 0)
		return 'RT'
	--right
	else
		frame:SetPoint('LEFT', otherFrame, 'RIGHT', offset, 0)
		return 'RC'
	end
end


--[[ Usable Functions ]]--

function FlyPaper.Stick(frame, otherFrame, tolerance, xOff, yOff)
	local xOff = xOff or 0
	local yOff = yOff or 0

	if not CanAttach(frame, otherFrame) then 
		return 
	end

	--get anchoring points
	local left = frame:GetLeft()
	local right = frame:GetRight()
	local top = frame:GetTop()
	local bottom = frame:GetBottom()
	local centerX, centerY = frame:GetCenter()

	if left and right and top and bottom and centerX then
		local oScale = otherFrame:GetScale()
		left = left / oScale
		right = right / oScale
		top = top / oScale
		bottom = bottom /oScale
		centerX = centerX / oScale
		centerY = centerY / oScale
	else return end


	local oLeft = otherFrame:GetLeft()
	local oRight = otherFrame:GetRight()
	local oTop = otherFrame:GetTop()
	local oBottom = otherFrame:GetBottom()
	local oCenterX, oCenterY = otherFrame:GetCenter()

	if oLeft and oRight and oTop and oBottom and oCenterX then
		local scale = frame:GetScale()
		oCenterX = oCenterX / scale
		oCenterY = oCenterY / scale
		oLeft = oLeft / scale
		oRight = oRight / scale
		oTop = oTop / scale
		oBottom = oBottom / scale
	else return end


	--[[ Start Attempting to Anchor <frame> to <otherFrame> ]]--

	if(oLeft - tolerance <= left and oRight + tolerance >= right) or (left - tolerance <= oLeft and right + tolerance >= oRight)then
		local distCenter = math.abs(oCenterX - centerX)
		local distLeft = math.abs(oLeft - left)
		local distRight = math.abs(right - oRight)

		--try to stick to the top if the distance is under the threshold distance to stick frames to each other (tolerance)
		if math.abs(oTop - bottom) <= tolerance then
			return AttachToTop(frame, otherFrame, distLeft, distRight, distCenter, yOff)
		--to the bottom
		elseif math.abs(oBottom - top) <= tolerance then
			return AttachToBottom(frame, otherFrame, distLeft, distRight, distCenter, yOff)
		end
	end


	if(oTop + tolerance >= top and oBottom - tolerance <= bottom) or (top + tolerance >= oTop and bottom - tolerance <= oBottom)then
		local distCenter = math.abs(oCenterY - centerY)
		local distTop = math.abs(oTop - top)
		local distBottom = math.abs(oBottom - bottom)

		--to the left
		if math.abs(oLeft - right) <= tolerance then
			return AttachToLeft(frame, otherFrame, distTop, distBottom, distCenter, xOff)
		end

		--to the right
		if math.abs(oRight - left) <= tolerance then
			return AttachToRight(frame, otherFrame, distTop, distBottom, distCenter, xOff)
		end
	end
end

function FlyPaper.StickToPoint(frame, otherFrame, point, xOff, yOff)
	local xOff = xOff or 0
	local yOff = yOff or 0

	--check to make sure its actually possible to attach the frames
	if not(point and CanAttach(frame, otherFrame)) then 
		return 
	end


	--[[ Start Attempting to Anchor <frame> to <otherFrame> ]]--

	frame:ClearAllPoints()

	--to the top
	if point == 'TL' then
		frame:SetPoint('BOTTOMLEFT', otherFrame, 'TOPLEFT', 0, yOff)
		return point
	elseif point == 'TC' then
		frame:SetPoint('BOTTOM', otherFrame, 'TOP', 0, yOff)
		return point
	elseif point == 'TR' then
		frame:SetPoint('BOTTOMRIGHT', otherFrame, 'TOPRIGHT', 0, yOff)
		return point
	end

	--to the bottom
	if point == 'BL' then
		frame:SetPoint('TOPLEFT', otherFrame, 'BOTTOMLEFT', 0, -yOff)
		return point
	elseif point == 'BC' then
		frame:SetPoint('TOP', otherFrame, 'BOTTOM', 0, -yOff)
		return point
	elseif point == 'BR' then
		frame:SetPoint('TOPRIGHT', otherFrame, 'BOTTOMRIGHT', 0, -yOff)
		return point
	end

	--to the left
	if point == 'LB' then
		frame:SetPoint('BOTTOMRIGHT', otherFrame, 'BOTTOMLEFT', -xOff, 0)
		return point
	elseif point == 'LC' then
		frame:SetPoint('RIGHT', otherFrame, 'LEFT', -xOff, 0)
		return point
	elseif point == 'LT' then
		frame:SetPoint('TOPRIGHT', otherFrame, 'TOPLEFT', -xOff, 0)
		return point
	end

	--to the right
	if point == 'RB' then
		frame:SetPoint('BOTTOMLEFT', otherFrame, 'BOTTOMRIGHT', xOff, 0)
		return point
	elseif point == 'RC' then
		frame:SetPoint('LEFT', otherFrame, 'RIGHT', xOff, 0)
		return point
	elseif point == 'RT' then
		frame:SetPoint('TOPLEFT', otherFrame, 'TOPRIGHT', xOff, 0)
		return point
	end
end