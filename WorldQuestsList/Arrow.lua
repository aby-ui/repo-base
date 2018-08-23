local GlobalAddonName, WQLdb = ...

----------------------------
--  Initialize variables  --
----------------------------
-- globals
WQLdb.Arrow = {}

local arrowFrame = WQLdb.Arrow
local runAwayArrow
local targetType
local targetPlayer
local targetX, targetY
local hideTime, hideDistance
local dontHide
local isWorldCoord

local textureArrow,textureTop = "Interface\\AddOns\\WorldQuestsList\\Arrows", "Interface\\AddOns\\WorldQuestsList\\Arrows-Down"

local pi, pi2, pi05 = math.pi, math.pi * 2, math.pi * 0.5
local floor = math.floor
local sin, cos, atan2, sqrt, min = math.sin, math.cos, math.atan2, math.sqrt, math.min
local GetTime, GGetPlayerFacing = GetTime, GetPlayerFacing
local UnitPosition = UnitPosition

local function GetPlayerFacing()
	return GGetPlayerFacing() or 0
end

--------------------
--  Create Frame  --
--------------------
local frame = CreateFrame("Button", nil, UIParent)
frame:Hide()
frame:SetFrameStrata("HIGH")
frame:SetWidth(56)
frame:SetHeight(42)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton", "RightButton")
frame:SetScript("OnDragStart", function(self)
	if self:IsMovable() then 
		self:StartMoving()
	end
end)
frame:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing()
	local point1, _, point2, x, y = self:GetPoint(1)
	
	VWQL.Arrow_Point1 = point1
	VWQL.Arrow_Point2 = point2
	VWQL.Arrow_PointX = x
	VWQL.Arrow_PointY = y
end)
frame:SetScript("OnClick", function(self)
	self:Hide()
end)
frame:SetClampedToScreen(true)
local arrow = frame:CreateTexture(nil, "OVERLAY")
arrow:SetTexture(textureArrow)
arrow:SetAllPoints(frame)

local txtrng = frame:CreateFontString(nil,"OVERLAY")
txtrng:SetSize(0,18)
txtrng:SetPoint("BOTTOM",frame,"BOTTOMRIGHT",0,5)
txtrng:SetFont("Interface\\AddOns\\WorldQuestsList\\ariblk.ttf", 14, "OUTLINE")
txtrng:SetJustifyH("RIGHT")
txtrng:SetJustifyV("BOTTOM")
txtrng:SetText("")

local txttime = frame:CreateFontString(nil,"OVERLAY")
txttime:SetPoint("TOP",txtrng,"BOTTOM",0,-1)
txttime:SetFont("Interface\\AddOns\\WorldQuestsList\\ariblk.ttf", 10, "OUTLINE")
txttime:SetText("")

------------------------
--  Update the arrow  --
------------------------
local updateArrow,IsArrowDown
do
	local currentCell
	local count = 0
	local showDownArrow = false
	function updateArrow(direction, distance)
		if distance and distance <= hideDistance and dontHide then
			if not showDownArrow then
				frame:SetHeight(60)
				frame:SetWidth(47)
				arrow:SetTexture(textureTop)
				arrow:SetVertexColor(0.3, 1, 0)
				showDownArrow = true
			end
			count = count + 1
			if count >= 55 then
				count = 0
			end
	
			local cell = count
			local column = cell % 9
			local row = floor(cell / 9)
	
			local xstart = (column * 53) / 512
			local ystart = (row * 70) / 512
			local xend = ((column + 1) * 53) / 512
			local yend = ((row + 1) * 70) / 512
			arrow:SetTexCoord(xstart,xend,ystart,yend)
			txtrng:SetFormattedText("%d",distance)
			txttime.d = distance
		else
			if showDownArrow then
				frame:SetHeight(42)
				frame:SetWidth(56)
				arrow:SetTexture(textureArrow)
				showDownArrow = false
				currentCell = nil
			end
			local cell = floor(direction / pi2 * 108 + 0.5) % 108
			if cell ~= currentCell then
				currentCell = cell
				local column = cell % 9
				local row = floor(cell / 9)
				local xStart = (column * 56) / 512
				local yStart = (row * 42) / 512
				local xEnd = ((column + 1) * 56) / 512
				local yEnd = ((row + 1) * 42) / 512
				arrow:SetTexCoord(xStart, xEnd, yStart, yEnd)
			end
			if distance then
				if runAwayArrow then
					local perc = distance / hideDistance
					local red = 1 - perc
					arrow:SetVertexColor(red, perc, 0)
					txtrng:SetTextColor(red, perc, 0)
					if distance >= hideDistance then
						frame:Hide()
					end
				else
					local perc = distance > 2000 and 2000 or distance
					if perc >= 500 then
						local green = 1 - ((perc-500) / 1500)
						arrow:SetVertexColor(1, green, 0)
						txtrng:SetTextColor(1, green, 0)
					else
						perc = perc < 40 and 0 or perc - 40
						local red = perc / 460
						arrow:SetVertexColor(red, 1, 0)
						txtrng:SetTextColor(red, 1, 0)
					end
					if distance <= hideDistance then
						frame:Hide()			
					end
				end
				txtrng:SetFormattedText("%d",distance)
				txttime.d = distance
			elseif runAwayArrow then
				arrow:SetVertexColor(1, 0.3, 0)
			else
				arrow:SetVertexColor(1, 1, 0)
			end
		end
	end
	function IsArrowDown()
		return showDownArrow
	end
end

------------------------
--  OnUpdate Handler  --
------------------------

local functionOnUpdateWorld,functionOnUpdateMap,functionOnUpdateStatic = nil
do
	local rotateState = 0
	
	function functionOnUpdateWorld(self, elapsed)
		if hideTime and GetTime() > hideTime then
			frame:Hide()
		end

		local y, x = UnitPosition'player'
		
		if not y or not x then
			self:Hide() 
			return
		end
		
		if targetType == "player" then
			targetY, targetX = UnitPosition(targetPlayer)
			if not targetY or not targetX then
				self:Hide() -- hide the arrow if the target doesn't exist
			end
		elseif targetType == "rotate" then
			rotateState = rotateState + elapsed
			targetX = x + cos(rotateState)
			targetY = y + sin(rotateState)
		end

		local angle = atan2(x - targetX, targetY - y)
		if angle <= 0 then -- -pi < angle < pi but we need/want a value between 0 and 2 pi
			if runAwayArrow then
				angle = -angle -- 0 < angle < pi
			else
				angle = pi - angle -- pi < angle < 2pi
			end
		elseif runAwayArrow then
			angle = pi2 - angle -- pi < angle < 2pi
		else
			angle = pi - angle  -- 0 < angle < pi
		end
		
		local player = GetPlayerFacing() - pi
		if player < 0 then
			player = pi2 + player
		end
		
		local dX = (x - targetX)
		local dY = (y - targetY)
		
		updateArrow(angle - player, sqrt(dX * dX + dY * dY))
	end
		
	function functionOnUpdateStatic(self, elapsed)
		if hideTime and GetTime() > hideTime then
			frame:Hide()
		end

		local player = GetPlayerFacing() - pi
		if player < 0 then
			player = pi2 + player
		end
		
		updateArrow(targetX - player)
	end
end


----------------------
--  Public Methods  --
----------------------
local function show(runAway, x, y, distance, time, world, hide)
	local player
	frame:Hide()
	if x == "_static" then
		frame:SetScript("OnUpdate", functionOnUpdateStatic)
	else
		frame:SetScript("OnUpdate", functionOnUpdateWorld)
	end
	if x == "_static" then
		targetX = math.rad(y)
		if distance then
			hideTime = distance + GetTime()
		else
			hideTime = nil
		end
		frame:Show()
		return
	elseif type(x) == "string" then
		player, hideDistance, hideTime = x, y, distance
	end
	frame:Show()
	runAwayArrow = runAway
	hideDistance = distance or runAway and 100 or 3
	if time then
		hideTime = time + GetTime()
	else
		hideTime = nil
	end
	if player then
		targetType = "player"
		targetPlayer = player
	else
		targetType = "fixed"
		targetX, targetY = x, y
	end
	isWorldCoord = world
	dontHide = hide
end

function arrowFrame:ShowRunTo(...)
	return show(false, ...)
end

function arrowFrame:ShowRunAway(...)
	return show(true, ...)
end

-- shows a static arrow
function arrowFrame:ShowStatic(angle, time)
	runAwayArrow = false
	hideDistance = 0
	targetType = "static"
	targetX = angle * pi2 / 360
	if time then
		hideTime = time + GetTime()
	else
		hideTime = nil
	end
	frame:Show()
end

function arrowFrame:ShowToPlayer(...)
	return show(false, ...)
end

function arrowFrame:IsShown()
	return frame and frame:IsShown()
end

function arrowFrame:Hide(autoHide)
	frame:Hide()
end

local function endMove()
	frame:EnableMouse(false)
	arrowFrame:Hide()
end

function arrowFrame:Move()
	targetType = "rotate"
	runAwayArrow = false
	hideDistance = 5
	frame:EnableMouse(true)
	frame:Show()
end

function arrowFrame:LoadPosition(...)
	frame:SetPoint(...)
end

function arrowFrame:GetPosition()
	return targetX, targetY
end

function arrowFrame:Scale(...)
	frame:SetScale(...)
end

arrowFrame.frame = frame