local GlobalAddonName, ExRT = ...

--- outdated module, temp disable
if true then return end

local module = ExRT.mod:New("Arrow",ExRT.L.Arrow,true,true)
local ELib,L = ExRT.lib,ExRT.L

local VExRT = nil

-- This file uses models and textures taken from TomTom. The 3d arrow model was created by Guillotine (curse.guillotine@gmail.com).

--[[
Blizzard map rules:
- coords decreases from left to right
- coords decreases from top to bottom
- GetCurrentMapZone returns coords of Right,Top,Left,Bottom
- GetCurrentMapDungeonLevel returns coords of Left,Bottom,Right,Top
]]

----------------------------
--  Initialize variables  --
----------------------------
-- globals
module.Arrow = {}

local arrowFrame = module.Arrow
local runAwayArrow
local targetType
local targetPlayer
local targetX, targetY
local hideTime, hideDistance
local dontHide
local isWorldCoord
local textureArrow,textureTop = "Interface\\AddOns\\DBM-Core\\textures\\arrows\\Arrow", "Interface\\AddOns\\DBM-Core\\textures\\arrows\\Arrow-UP"

local pi, pi2, pi05 = math.pi, math.pi * 2, math.pi * 0.5
local floor = math.floor
local sin, cos, atan2, sqrt, min = math.sin, math.cos, math.atan2, math.sqrt, math.min
local GetPlayerMapPosition = GetPlayerMapPosition
local GetCurrentMapZone, GetCurrentMapDungeonLevel, GetCurrentMapAreaID = GetCurrentMapZone, GetCurrentMapDungeonLevel, GetCurrentMapAreaID
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
	
	VExRT.Arrow.Point1 = point1
	VExRT.Arrow.Point2 = point2
	VExRT.Arrow.PointX = x
	VExRT.Arrow.PointY = y
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
txtrng:SetFont("Fonts\\ARHei.ttf", 14, "OUTLINE")
txtrng:SetJustifyH("RIGHT")
txtrng:SetJustifyV("BOTTOM")
txtrng:SetText("")

local txttime = frame:CreateFontString(nil,"OVERLAY")
txttime:SetPoint("TOP",txtrng,"BOTTOM",0,-1)
txttime:SetFont("Interface\\AddOns\\ExRT\\media\\ariblk.ttf", 10, "OUTLINE")
txttime:SetText("")

--[[
C_Timer.NewTicker(1,function()
	if not frame:IsShown() then
		txttime.p = nil
		return
	end
	if not txttime.p then
		txttime:SetText("")
		txttime.p = txttime.d
		return 
	end
	if txttime.d then
		if txttime.p == txttime.d then
			txttime:SetText("inf")
		else
			txttime:SetFormattedText("%ds",txttime.d / ((txttime.p - txttime.d) / 1))
		end
		--print(txttime.p,txttime.d)
		txttime.p = txttime.d 
	end
end)
]]

---------------------
--  Map Utilities  --
---------------------
local SetMapToCurrentZone -- throttled SetMapToCurrentZone function to prevent lag issues with unsupported WorldMap addons
do
	local lastMapUpdate = 0
	function SetMapToCurrentZone(...)
		if GetTime() - lastMapUpdate > 1 then
			lastMapUpdate = GetTime()
			return _G.SetMapToCurrentZone(...)
		end
	end
end

local function calculateDistance(x1, y1, x2, y2)
	local dims = module:GetMapSizes()
	if not dims then
		return
	end
	local dX = (x1 - x2) * dims[1]
	local dY = (y1 - y2) * dims[2]
	return sqrt(dX * dX + dY * dY)
end

local function calculateWorldDistance(x1, y1, x2, y2)
	local dX = (x1 - x2)
	local dY = (y1 - y2)
	return sqrt(dX * dX + dY * dY)
end

local function mapPositionToCoords(x,y)
	local zoneIndex = GetCurrentMapAreaID()
	local floor = GetCurrentMapDungeonLevel()
	
	local coords = module.db.mapCoords[zoneIndex] and module.db.mapCoords[zoneIndex][floor]
	if not coords then
		module:UpdateMapSizes()
		coords = module.db.mapCoords[zoneIndex] and module.db.mapCoords[zoneIndex][floor]
		if not coords then
			return
		end
	end
	return coords[1] - x * (coords[1] - coords[3]),coords[2] - y * (coords[2] - coords[4])
end

-----------------
--  Map Sizes  --
-----------------
module.db.mapSizes = {}
module.db.mapCoords = {}
local currentSizes

function module:UpdateMapSizes()
	SetMapToCurrentZone()
	local _, a2, b2, c2, d2 = GetCurrentMapZone()
	local zoneIndex = GetCurrentMapAreaID()
	local floor, a1, b1, c1, d1 = GetCurrentMapDungeonLevel()
	if module.db.mapSizes[zoneIndex] and module.db.mapSizes[zoneIndex][floor] then
		currentSizes = module.db.mapSizes[zoneIndex][floor]
		return
	end

	if not (a1 and b1 and c1 and d1) then
		a1, b1, c1, d1 = c2, d2, a2, b2
	end

	if not (a1 and b1 and c1 and d1) then 
		return
	end
	
	currentSizes = {abs(c1-a1), abs(d1-b1)}
	if not module.db.mapSizes[zoneIndex] then
		module.db.mapSizes[zoneIndex] = {}
		module.db.mapCoords[zoneIndex] = {}
	end
	module.db.mapSizes[zoneIndex][floor] = currentSizes
	module.db.mapCoords[zoneIndex][floor] = {c1, d1, a1, b1}
	
	--[[
		! Note:
		GetCurrentMapDungeonLevel() > return 3001,-13.833,3938.75,611.333 instead 3938.75,611.333,3001,-13.833	[xB,yB,xT,yT instead xT,yT,xB,yB]
	]]
end

function module:GetMapSizes()
	if not currentSizes then
		module:UpdateMapSizes()
	end
	return currentSizes
end


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
					local perc = min(distance, 40)
					if perc > 20 then
						local green = 1 - ((perc-20) / 20)
						arrow:SetVertexColor(1, green, 0)
						txtrng:SetTextColor(1, green, 0)
					else
						local red = perc / 20
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
	
	function functionOnUpdateMap(self, elapsed)
		if hideTime and GetTime() > hideTime then
			frame:Hide()
		end
		if targetType == "static" then
			return updateArrow(targetX, 0) -- targetX contains the static angle to show
		end

		local x,y = GetPlayerMapPosition("player")
		if x == 0 and y == 0 then
			SetMapToCurrentZone()
			x, y = GetPlayerMapPosition("player")
			if x == 0 and y == 0 then
				self:Hide() -- hide the arrow if you enter a zone without a map
				return
			end
		end
		
		if targetType == "player" then
			targetX, targetY = GetPlayerMapPosition(targetPlayer)
			if targetX == 0 and targetY == 0 then
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
		
		local player = GetPlayerFacing()
		if player < 0 then
			player = pi2 + player
		end
		updateArrow(angle - player, calculateDistance(x, y, targetX, targetY))
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
	elseif not world then	--Update Map Only if local coords
		SetMapToCurrentZone()--Set map to current zone before checking other stuff
		module:UpdateMapSizes()--Force a mapsize update after SetMapToCurrentZone to ensure our information is current
		frame:SetScript("OnUpdate", functionOnUpdateMap)
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


--- Other func

local buffFilter = {"HARMFUL","HELPFUL"}
function arrowFrame:ShowToBuff(spell)
	local n = GetNumGroupMembers() or 0
	local spellName
	if type(spell) == "string" then
		spellName = spell
	end
	for i=1,n do
		local name, _, _, _, _, _, _, online, isDead = GetRaidRosterInfo(i)
		if name and online and not isDead then
			if spellName then
				for k=1,2 do
					for j=1,40 do
						local auraName = UnitAura(name, j, buffFilter[k])
						if auraName and string.lower(auraName) == spellName then
							return self:ShowToPlayer(name)
						end
					end
				end
			else
				for k=1,2 do
					for j=1,40 do
						local _, _, _, _, _, _, _, _, _, spellId = UnitAura(name, j, buffFilter[k])
						if spellId and spellId == spell then
							return self:ShowToPlayer(name)
						end
					end
				end
			end
		end
	end
end

---

ExRT.F.Arrow = arrowFrame
function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.Arrow = VExRT.Arrow or {}

	if VExRT.Arrow.PointX and VExRT.Arrow.PointY and VExRT.Arrow.Point1 and VExRT.Arrow.Point2 then
		arrowFrame:LoadPosition(VExRT.Arrow.Point1,UIParent,VExRT.Arrow.Point2,VExRT.Arrow.PointX,VExRT.Arrow.PointY)
	else
		arrowFrame:LoadPosition("TOP",UIParent,"TOP",0,-100)
	end
	
	if VExRT.Arrow.Fix then
		--frame:SetMovable(false)
	end
	
	if VExRT.Arrow.Alpha then frame:SetAlpha(VExRT.Arrow.Alpha/100) end
	if VExRT.Arrow.Scale then frame:SetScale(VExRT.Arrow.Scale/100) end
	
	module:RegisterSlash()
	module:RegisterAddonMessage()
end

function module:slash(arg)
	if arg:find("^arrow ") then
		local x,y = arg:match("([0-9%.]+),? ([0-9%.]+)")
		if not x or not y then
			return
		end
		local isWorldCoord = arg:find("^arrow w")
		x = tonumber(x)/100
		y = tonumber(y)/100
		if isWorldCoord then
			local floor, a1, b1, c1, d1 = GetCurrentMapDungeonLevel()
			local _, a2, b2, c2, d2 = GetCurrentMapZone()
			if not a1 or not b1 or not c1 or not d1 then
				a1, b1, c1, d1 = c2, d2, a2, b2
			end
			x = c1 - x * abs(c1-a1)
			y = d1 - y * abs(d1-b1)
		end
		arrowFrame:ShowRunTo(x,y,nil,nil,isWorldCoord)
	elseif arg:find("^range ") then
		local unit = arg:match("^range (.+)")
		if not unit or not UnitName(unit) then
			print('Unit doesnt exist')
			return
		end
		--local x,y = mapPositionToCoords(GetPlayerMapPosition(unit))
		--local xP,yP = mapPositionToCoords(GetPlayerMapPosition("player"))
		local y,x = UnitPosition(unit)
		local yP,xP = UnitPosition("player")
		--if (x == 0 and y == 0) or (xP == 0 or yP == 0) then
		if not x or not xP then
			print('Map error')
			return
		end
		local dist = calculateWorldDistance(x,y,xP,yP)
		print(format("Distance to %s: %.1f",unit,dist))
	elseif arg:find("^arrowbuff ") then
		local spell = arg:match("^arrowbuff (.+)")
		if not spell then
			return
		end
		if tonumber(spell) then spell = tonumber(spell) end
		arrowFrame:ShowToBuff(spell)
	elseif arg:find("^arrowplayer ") then
		local unit,hidetime = arg:match("^arrowplayer ([^ ]+) ?(%d*)")
		if not unit or not UnitName(unit) then
			print('Unit doesnt exist')
			return
		end
		if not tonumber(hidetime) then
			hidetime = nil
		end
		arrowFrame:ShowToPlayer(unit,nil,nil,hidetime,nil,true)
	elseif arg:find("^arrowplayer2 ") then
		local unit,hidetime = arg:match("^arrowplayer2 ([^ ]+) ?(%d*)")
		if not unit or not UnitName(unit) then
			print('Unit doesnt exist')
			return
		end
		if not tonumber(hidetime) then
			hidetime = nil
		end
		arrowFrame:ShowToPlayer(unit,nil,nil,hidetime)
	elseif arg:find("^arrowhide") then
		arrowFrame:Hide()
	elseif arg:find("^arrowthis") then
		local y,x = UnitPosition("player")
		arrowFrame:ShowRunTo(x, y, 3, nil, true, true)
	elseif arg:find("^arrowmark ") then
		local markID = arg:match("^arrowmark (%d+)")
		markID = tonumber(markID or "?")
		if not markID then
			return
		end
		for i=1,40 do
			local mark = GetRaidTargetIndex('raid'..i)
			if mark == markID then
				return arrowFrame:ShowToPlayer( UnitName('raid'..i), nil )
			end
		end
	elseif arg:find("^arrowget") then
		local x,y = arrowFrame:GetPosition()
		print(x,y)
	elseif arg:find("^arrowstatic ") then
		local angle = arg:match("%d+")
		if angle then
			arrowFrame:ShowStatic(angle)
		end
	end
end

local playerName = UnitName'player'
function module:addonMessage(sender, prefix, ...)
	if prefix == "arrow" then
		if IsInRaid() and not ExRT.F.IsPlayerRLorOfficer(sender) then
			return
		end
	
		local name, sub_prefix = ...
		if name ~= "raid" and ExRT.F.delUnitNameServer(name) ~= playerName then
			return
		end
		if sub_prefix == "g" then
			local _, _, runAway, x, y, distance, time, world, hide = ...
			runAway = (runAway == "true" or runAway == "1") and true or false
			x = tonumber(x)
			y = tonumber(y)
			distance = tonumber(distance)
			time = tonumber(time)
			world = (world == "true" or world == "1") and true or false
			hide = (hide == "true" or hide == "1") and true or false
			show(runAway, x, y, distance, time, world, hide)
		elseif sub_prefix == "p" then
			local _, _, runAway, toPlayer, distance, time, hide = ...
			runAway = (runAway == "true" or runAway == "1") and true or false
			distance = tonumber(distance)
			time = tonumber(time)
			hide = (hide == "true" or hide == "1") and true or false
			show(runAway, toPlayer, distance, time, nil, true, hide)
		elseif sub_prefix == "s" then
			local _, _, angle, time = ...
			angle = tonumber(angle) or 0
			time = tonumber(time)
			show(false, "_static", angle, time)
		end
	end 
end

function ExRT.F.ArrowText(angle,width,height)
	local cell = floor(angle / pi2 * 108 + 0.5) % 108
	local column = cell % 9
	local row = floor(cell / 9)
	local xStart = (column * 56) / 512
	local yStart = (row * 42) / 512
	local xEnd = ((column + 1) * 56) / 512
	local yEnd = ((row + 1) * 42) / 512
	xStart = floor(512 * xStart)
	xEnd = floor(512 * xEnd)
	yStart = floor(512 * yStart)
	yEnd = floor(512 * yEnd)
	
	width = tonumber(width or 16) or 16
	height = tonumber(height or width) or width
	
	return "|TInterface\\AddOns\\ExRT\\media\\Arrow:"..width..":"..height..":0:0:512:512:"..xStart..":"..xEnd..":"..yStart..":"..yEnd.."|t"
end

function ExRT.F.ArrowTextPlayer(unit,width,height)
	local pY,pX = UnitPosition('player')
	local tY,tX = UnitPosition(unit)
	if not tX or (tY == 0 and tX == 0) or not pY then
		return ""
	end
	local angle = atan2(pX - tX, pY - tY)
	local player = GetPlayerFacing()
	if player < 0 then
		player = player + pi2
	end
	
	return ExRT.F.ArrowText( angle - player - pi, width, height )
end

function ExRT.F.ArrowTextCoord(tX,tY,width,height)
	local pY,pX = UnitPosition('player')
	if not tX or not tY or not pX or not pY then
		return ""
	end
	local angle = atan2(pX - tX, pY - tY)
	local player = GetPlayerFacing()
	if player < 0 then
		player = player + pi2
	end

	return ExRT.F.ArrowText( angle - player - pi, width, height )
end

function ExRT.F.ArrowTextMapCoord(tX,tY,width,height)
	local pY,pX = GetPlayerMapPosition('player')
	if not tX or not tY or (pY == 0 and pX == 0) then
		return ""
	end
	tX,tY = tX/100,tY/100
	local angle = atan2(pX - tX, tY - pY)

	local player = GetPlayerFacing()

	return ExRT.F.ArrowText( angle - player - pi05, width, height )
end

function ExRT.F.ArrowTexture(texture,top)
	textureArrow = texture
	textureTop = top
	arrow:SetTexture(IsArrowDown() and textureTop or textureArrow)
end

local BlackFrames = {}
local function FindArrow()
	if not BlackFrames[1] then
		BlackFrames.G = CreateFrame("Frame",nil,UIParent)
		BlackFrames.G:SetFrameStrata("FULLSCREEN_DIALOG")
		
		BlackFrames[1] = ELib:Texture(BlackFrames.G,0,0,0,.7,"OVERLAY"):Point("TOPLEFT",UIParent,0,0):Point("BOTTOMRIGHT",frame,"TOPRIGHT",0,0)
		BlackFrames[2] = ELib:Texture(BlackFrames.G,0,0,0,.7,"OVERLAY"):Point("LEFT",UIParent,0,0):Point("TOP",frame,0,0):Point("BOTTOM",frame,0,0):Point("RIGHT",frame,"LEFT",0,0)
		BlackFrames[3] = ELib:Texture(BlackFrames.G,0,0,0,.7,"OVERLAY"):Point("BOTTOMLEFT",UIParent,0,0):Point("TOPRIGHT",frame,"BOTTOMRIGHT",0,0)
		BlackFrames[4] = ELib:Texture(BlackFrames.G,0,0,0,.7,"OVERLAY"):Point("TOPRIGHT",UIParent,0,0):Point("BOTTOMRIGHT",UIParent,0,0):Point("LEFT",frame,"RIGHT",0,0)
		
		BlackFrames.Hide = ELib:Button(BlackFrames.G,L.minimapmenuclose):Point("BOTTOM",frame,"TOP",0,0):Size(100,30):OnClick(function()
			BlackFrames.G:Hide()
			frame:Hide()
			BlackFrames.G:SetScript('OnKeyDown',nil)
			BlackFrames.G:SetPropagateKeyboardInput(true)
		end)
		BlackFrames.Hide:SetFrameStrata("TOOLTIP")
	end
	BlackFrames.G:Show()
	BlackFrames.G:SetPropagateKeyboardInput(false)
	BlackFrames.G:SetScript('OnKeyDown',function(self,key)
		if key == 'ESCAPE' or key == 'ENTER' or key == 'SPACE' then
			BlackFrames.Hide:Click()
		end
	end)
	local y,x = UnitPosition("player")
	arrowFrame:ShowRunTo(x, y, 3, nil, true, true)
end
