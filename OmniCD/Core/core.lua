local E, L, C = select(2, ...):unpack()

local tinsert = table.insert
local tremove = table.remove

E.Write = function(...)
	print(E.userClassHexColor .. "OmniCD|r: ", ...)
end

E.DeepCopy = function(source, blackList)
	local copy = {}
	if type(source) == "table" then
		for k, v in pairs(source) do
			if not blackList or not blackList[k] then
				copy[k] = E.DeepCopy(v)
			end
		end
	else
		copy = source
	end

	return copy
end

E.IsTableExact = function(a, b)
	if #a ~= #b then return false end
	for i = 1, #a do
		if (a[i] ~= b[i]) then return false end
	end

	return true
end

E.RemoveEmptyDuplicateTables = function(dest, src)
	local copy = {}
	for k, v in pairs(dest) do
		local srcV = src[k]
		if type(v) == "table" and type(srcV) == "table" then
			copy[k] = E.RemoveEmptyDuplicateTables(v, srcV)
		elseif v ~= srcV then
			copy[k] = v
		end
	end

	return next(copy) and copy
end

E.GetModuleEnabled = function(k)
	return E.DB.profile.modules[k]
end

E.SetModuleEnabled = function(k, v)
	E.DB.profile.modules[k] = v

	local module = E[k]
	if v then
		module:Enable()
	else
		module:Disable()
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
	local db = f.db or E.db -- [57]
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

function OmniCD_AnchorOnMouseDown(self)
	local bar = self:GetParent()
	bar:StartMoving()
end

function OmniCD_AnchorOnMouseUp(self)
	local bar = self:GetParent()
	bar:StopMovingOrSizing()
	SavePosition(bar)
	E.Libs.ACR:NotifyChange("OmniCD")
end

E.SetWidth = function(anchor)
	local width = anchor.text:GetWidth() + 20
	anchor:SetWidth(width)
end

do
	local Timers = CreateFrame("Frame")
	local unusedTimers = {}

	local TimerFinished = function(self)
		self.func(unpack(self.args))
		tinsert(unusedTimers, self)
	end

	local function CreateTimer()
		local TimerAnim = Timers:CreateAnimationGroup()
		local Timer = TimerAnim:CreateAnimation("Alpha")
		Timer:SetScript("OnFinished", TimerFinished)
		Timer.TimerAnim = TimerAnim

		return Timer
	end

	E.TimerAfter = function(delay, func, ...)
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

E.IsPercentChance = function(percent)
	return percent >= math.random(1, 100)
end

E.FormatConcat = function(tbl, template, template2)
	local t = {}
	for k, v in ipairs(tbl) do
		if template2 then
			if (k % 2 == 0) then
				t[k] = v and template2:format(v) or ""
			else
				t[k] = v and template:format(v) or ""
			end
		else
			t[k] = v and template:format(v) or ""
		end
	end

	return table.concat(t)
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

E.RegisterEvents = function(f, t)
	if not t then return end
	f.eventMap = f.eventMap or {}

	if type(t) == "table" then
		for i = 1, #t do
			local event = t[i]
			if not f.eventMap[event] then
				f:RegisterEvent(event)
				f.eventMap[event] = true
			end
		end
	elseif not f.eventMap[t] then
		f:RegisterEvent(t)
		f.eventMap[t] = true
	end
end

E.UnregisterEvents = function(f, t)
	if not t then return end
	f.eventMap = f.eventMap or {}

	if type(t) == "table" then
		for i = 1, #t do
			local event = t[i]
			if f.eventMap[event] then
				f:UnregisterEvent(event)
				f.eventMap[event] = nil
			end
		end
	elseif f.eventMap[t] then
		f:UnregisterEvent(t)
		f.eventMap[t] = nil
	end
end

E.Noop = function() end

do
	local backdropFrames = {}
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

	E.BackdropTemplate = function(frame, style, bgFile, edgeFile, edgeSize)
		style = style or "default"

		local backdrop = backdropStyle[style]
		if not backdrop then
			backdrop = {
				bgFile = bgFile or E.TEXTURES.White8x8,
				edgeFile = edgeFile or E.TEXTURES.White8x8,
				edgeSize = (edgeSize or 1) * E.PixelMult,
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

		backdropFrames[frame] = backdrop
	end

	E.UpdateBackdrops = function()
		for style, backdrop in pairs(backdropStyle) do
			backdrop.edgeSize = E.PixelMult
		end
		for frame, backdrop in pairs(backdropFrames) do
			frame:SetBackdrop(backdrop)
		end
	end
end

E.SortHashToArray = function(src, db)
	local t = {}
	for k in pairs(src) do
		t[#t + 1] = {db[k], k}
	end

	table.sort(t, function(a, b)
		return a[1] > b[1]
	end)

	local sorted = {}
	for i = 1, #t do
		local v = t[i][2]
		sorted[i] = v
	end
	t = nil

	return sorted
end
