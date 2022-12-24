local E = select(2, ...):unpack()

local unpack = unpack
local tinsert = table.insert
local tremove = table.remove

function E:DeepCopy(source, blackList)
	local copy = {}
	if type(source) == "table" then
		for k, v in pairs(source) do
			if not blackList or not blackList[k] then
				copy[k] = self:DeepCopy(v)
			end
		end
	else
		copy = source
	end
	return copy
end

function E:RemoveEmptyDuplicateTables(dest, src)
	local copy = {}
	for k, v in pairs(dest) do
		local srcV = src[k]
		if type(v) == "table" and type(srcV) == "table" then
			copy[k] = self:RemoveEmptyDuplicateTables(v, srcV)
		elseif v ~= srcV then
			copy[k] = v
		end
	end
	return next(copy) and copy
end

E.IsTableExact = function(a, b)
	local n = #a
	if n ~= #b then return false end
	for i = 1, n do
		if (a[i] ~= b[i]) then return false end
	end
	return true
end

E.FormatConcat = function(tbl, delimiter, template, template2)
	local t = {}
	for i, v in ipairs(tbl) do
		if template2 then
			if (i % 2 == 0) then
				t[i] = template2:format(v)
			else
				t[i] = template:format(v)
			end
		else
			t[i] = template:format(v)
		end
	end
	return table.concat(t, delimiter)
end

E.MergeConcat = function(...)
	local t = {}
	for i = 1, select("#", ...) do
		local src = select(i, ...)
		if src then
			for _, v in ipairs(src) do
				t[#t + 1] = v
			end
		end
	end
	return table.concat(t, ",")
end

E.SplitConcat = function(tbl, n)
	local t = {}
	for i = n + 1, #tbl do
		local v = tbl[i]
		t[#t+1] = v
		tbl[i] = nil
	end
	return table.concat(tbl, ","),	#t > 0 and table.concat(t, ",")
end

E.SortHashToArray = function(src, db)
	local t = {}
	for k in pairs(src) do
		t[#t + 1] = {db[k], k}
	end
	sort(t, function(a, b)
		return a[1] > b[1]
	end)

	local sorted = {}
	for i = 1, #t do
		local v = t[i][2]
		sorted[i] = v
	end
	return sorted
end

E.pairs = function(t, ...)
	local i, a, k, v = 1, {...}
	return function()
		repeat
			k, v = next(t, k)
			if k == nil then
				i, t = i + 1, a[i]
			end
		until k ~= nil or not t
		return k, v
	end
end

local function SavePosition(f)
	local x = f:GetLeft()
	local y = f:GetTop()
	local s = f:GetEffectiveScale()
	x = x * s
	y = y * s

	local db = f.db or E.db
	db = db.manualPos[f.key]
	db.x = x
	db.y = y
end

E.LoadPosition = function(f, key)
	key = key or f.key
	local db = f.db or E.db
	db.manualPos[key] = db.manualPos[key] or {}
	db = db.manualPos[key]
	local x = db.x
	local y = db.y

	f:ClearAllPoints()
	if not x then
		f:SetPoint("CENTER", UIParent)
		SavePosition(f)
	else
		local s = f:GetEffectiveScale()
		x = x / s
		y = y / s
		f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y)
	end
end

E.OmniCDAnchor_OnMouseDown = function(self, button)
	local parent
	while true do
		parent = self:GetParent()
		if not parent or parent == UIParent then
			break
		end
		self = parent
	end
	if button == "LeftButton" and not self.isMoving then
		self:StartMoving()
		self.isMoving = true
	end
end

E.OmniCDAnchor_OnMouseUp = function(self, button)
	local parent
	while true do
		parent = self:GetParent()
		if not parent or parent == UIParent then
			break
		end
		self = parent
	end
	if button == "LeftButton" and self.isMoving then
		self:StopMovingOrSizing()
		self.isMoving = false
		SavePosition(self)
	end

end


do
	local Timers = CreateFrame("Frame")
	local unusedTimers = {}

	local Timer_OnFinished = function(self)
		self.func(unpack(self.args))
		tinsert(unusedTimers, self)
	end

	local TimerCancelled = function(self)
		if self.TimerAnim:IsPlaying() then
			self.TimerAnim:Stop()
			tinsert(unusedTimers, self)
		end
	end

	local function CreateTimer()
		local TimerAnim = Timers:CreateAnimationGroup()
		local Timer = TimerAnim:CreateAnimation("Alpha")
		Timer:SetScript("OnFinished", Timer_OnFinished)
		Timer.TimerAnim = TimerAnim
		Timer.Cancel = TimerCancelled
		return Timer
	end

	E.TimerAfter = function(delay, func, ...)
		if delay <= 0 then
			error("Timer requires a non-negative duration")
		end
		local Timer = tremove(unusedTimers)
		if not Timer then
			Timer = CreateTimer()
		end
		Timer.args = {...}
		Timer.func = func
		Timer:SetDuration(delay)
		Timer.TimerAnim:Play()
		return Timer
	end
end

do
	local backdropStyle = {}
	local textureUVs = {
		"TopLeftCorner",
		"TopRightCorner",
		"BottomLeftCorner",
		"BottomRightCorner",
		"TopEdge",
		"BottomEdge",
		"LeftEdge",
		"RightEdge",
		"Center"
	}

	E.DisablePixelSnap = function(obj)
		obj:SetTexelSnappingBias(0.0)
		obj:SetSnapToPixelGrid(false)
	end

	E.BackdropTemplate = function(frame, style, bgFile, edgeFile, edgeSize, force)
		style = style or "default"
		local backdrop = backdropStyle[style]
		if not backdrop or force then
			backdrop = {
				bgFile = bgFile or E.TEXTURES.White8x8,
				edgeFile = edgeFile or E.TEXTURES.White8x8,
				edgeSize = (edgeSize or 1) * E.PixelMult / (style == "ACD" and E.global.optionPanelScale or 1),
			}
			backdropStyle[style] = backdrop
		end
		frame:SetBackdrop(backdrop)
		for _, pieceName in ipairs(textureUVs) do
			local region = frame[pieceName];
			if region then
				E.DisablePixelSnap(region)
			end
		end
	end
end

E.Noop = function() end

E.IsPercentChance = function(percent)
	return percent >= random(1, 100)
end

E.GetClassHexColor = function(class)
	local hex = select(4, GetClassColor(class))
	return "|c" .. hex
end

E.RGBToHex = function(r, g, b)
	return format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

E.write = function(...)
	print(E.userClassHexColor .. "OmniCD|r: ", ...)
end

E.BLANK = {}
