local Recount = _G.Recount

local Graph = LibStub:GetLibrary("LibGraph-2.0")
local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale("Recount")

local revision = tonumber(string.sub("$Revision: 1472 $", 12, -3))
if Recount.Version < revision then
	Recount.Version = revision
end

local ipairs = ipairs
local math = math
local pairs = pairs
local string = string
local table = table
local tinsert = tinsert
local type = type

local CreateFrame = CreateFrame
local GetCursorPosition = GetCursorPosition
local GetMouseButtonClicked = GetMouseButtonClicked
local MouseIsOver = MouseIsOver

local UIParent = UIParent

local FauxScrollFrame_GetOffset = FauxScrollFrame_GetOffset
local FauxScrollFrame_OnVerticalScroll = FauxScrollFrame_OnVerticalScroll
local FauxScrollFrame_Update = FauxScrollFrame_Update

local me = {}

local Epsilon = 0.000000000000000001

local GraphColors = {
	Damage = {1.0, 0.0, 0.0, 1.0},
	DamageTaken = {1.0, 1.0, 0.0, 1.0},
	Healing = {0.0, 1.0, 0.0, 1.0},
	HealingTaken = {0.0, 1.0, 1.0, 1.0},
	Overhealing = {0.5, 0.0, 1.0, 1.0},
	Threat = {1.0, 0.5, 0, 1.0},
	TPS = {1.0, 0.6, 0.8, 1.0},
}

me.GraphColors = {}

local ClassCount = {}

local GraphName = {
	Damage = "Damage",
	DamageTaken = "Damage Taken",
	Healing = "Healing",
	HealingTaken = "Healing Taken",
	Overhealing = "Overhealing",
}

local ShadeVariant = {
	1.0, -- 1
	0.6, -- 2
	0.8, -- 3
	0.4, -- 4
	0.7, -- 5
	0.5, -- 6
	0.3, -- 7
	0.9, -- 8
}

function me:DataCopy(data)
	if not (data and data[1]) then
		return
	end

	local Copy = Recount:GetTable()
	Copy[1] = Recount:GetTable()
	Copy[2] = Recount:GetTable()
	for i = 1,#data[1] do
		Copy[1][i] = data[1][i]
		Copy[2][i] = data[2][i]
	end
	return Copy
end

function me:DataSparsen(data, amount)
	local Keep = Recount:GetTable()

	if #data[1] == 0 then
		return
	end

	local Min, Max, MinV, MaxV, CurVal
	local Time = data[1][1] + 0.5

	Keep[1] = true
	Min = 0

	for k, v in ipairs(data[1]) do
		CurVal = data[2][k]
		if v > Time and v < (Time + amount) then
			if Min == 0 then
				Min = k
				Max = k
				MinV = CurVal
				MaxV = CurVal
			elseif CurVal < MinV then
				Min = k
				MinV = CurVal
			elseif CurVal >= MaxV then
				Max = k
				MaxV = CurVal
			end
		elseif v >= (Time + amount) then
			if Min ~= 0 then
				Keep[Min] = true
				Keep[Max] = true
			end
			Time = v
			Min = k
			Max = k
			MinV = CurVal
			MaxV = CurVal
		end
	end
	if Min ~= 0 then
		Keep[Min] = true
		Keep[Max] = true

		Keep[#data[1]] = true
	end

	local i = #data[1]

	while i > 0 do
		if not Keep[i] then
			table.remove(data[1], i)
			table.remove(data[2], i)
		end
		i = i - 1
	end

	Recount:FreeTable(Keep)
end

function me:FilterDataByTime(data)
	local filtered = Recount:GetTable()
	filtered[1] = Recount:GetTable()
	filtered[2] = Recount:GetTable()

	local First = true
	local Last = 0

	for k, v in ipairs(data[1]) do
		if v >= Recount.TimeRangeLower and v <= Recount.TimeRangeUpper then
			--Need to add value right at the front edge
			if First then
				if k ~= 1 then
					--If not first need to LERP to find the edge value
					local Weight = (Recount.TimeRangeLower - data[1][k - 1]) / (data[1][k] - data[1][k - 1])
					filtered[2][#filtered[2] + 1] = Weight * data[2][k] + (1 - Weight) * data[2][k - 1]
				else
					--If this is first then insert 0 at front
					filtered[2][#filtered[2] + 1] = 0
				end
				filtered[1][#filtered[1] + 1] = Recount.TimeRangeLower
				First = false
			end
			filtered[1][#filtered[1] + 1] = v
			filtered[2][#filtered[2] + 1] = data[2][k]
			Last = k
		end
	end

	--Only add a trailer if we have data otherwise don't do anything
	if Last ~= 0 then
		--Do we have something we can LERP with?
		if data[1][Last + 1] then
			--Yes, so calculate a weight and then LERP
			local Weight = (Recount.TimeRangeUpper - data[1][Last]) / (data[1][Last + 1] - data[1][Last])
			filtered[2][#filtered[2] + 1] = Weight * data[2][Last + 1] + (1 - Weight) * data[2][Last]
		else
			--No so lets insert 0
			filtered[2][#filtered[2] + 1] = 0
		end
		filtered[1][#filtered[1] + 1] = Recount.TimeRangeUpper
	end

	return filtered
end

function me:FindMax(data)
	local Min = data[2][1]
	local Max = data[2][1]
	for _, v in ipairs(data[2]) do
		if v > Max then
			Max = v
		end
		if v < Min then
			Min = v
		end
	end
	return Min, Max
end

function me:SetMin(data, Min)
	for k, v in ipairs(data[2]) do
		if v < Min then
			data[2][k] = Min
		end
	end
end

function me:IntegrateData(data)
	local CurSum = 0
	local LastNum = 0
	local NotFirst = false
	for k, v in ipairs(data[1]) do
		if NotFirst then
			CurSum = CurSum + 0.5 * (data[2][k] + LastNum) * (v - data[1][k - 1])
			LastNum = data[2][k]
			data[2][k] = CurSum
		else
			LastNum = data[2][k]
			data[2][k] = 0
		end
		NotFirst = true
	end
end

function me:NormalizeData(data)
	local Min, Max = me:FindMax(data)
	local Width = Max - Min
	for k, v in ipairs(data[2]) do
		data[2][k] = 100 * (v - Min) / Width
	end
end
function me:HideTextures()
	if not self.Textures then
		self.Textures = {}
	end
	for k, t in pairs(self.Textures) do
		t:Hide()
	end
end

--Make sure to show a texture after you grab it or its free for anyone else to grab
function me:FindTexture()
	for k, t in pairs(self.Textures) do
		if not t:IsShown() then
			return t
		end
	end
	local g = self:CreateTexture(nil, "BACKGROUND")
	table.insert(self.Textures, g)
	return g
end

local function SortForStack(a, b)
	if a[1] > b[1] then
		return true
	elseif a[1] == b[1] and a[4] > b[4] then
		return true
	end
	return false
end

local function SortForDisplay(a, b)
	if a[1] < b[1] then
		return true
	elseif a[1] == b[1] and a[4] < b[4] then
		return true
	end
	return false
end

function me:AddDataSeries(a, b)
	--If ones nil just return the other one
	if a == nil or table.maxn(a) < 2 then
		return b
	elseif b == nil or table.maxn(b) < 2 then
		return a
	end

	local LastA, LastAT, Temp
	local PosA, PosB, LengthA, LengthB

	PosA = 1
	PosB = 1
	LengthA = table.maxn(a[1])
	LengthB = table.maxn(b[1])

	a[2][PosA] = math.max(a[2][PosA], 0)
	b[2][PosB] = math.max(b[2][PosB], 0)

	while PosA <= #a[1] or PosB <= LengthB do
		if PosA <= #a[1] then
			if PosB <= LengthB then
				if a[1][PosA] < b[1][PosB] then
					if PosB ~= 1 then
						--Need to lerp first calculate a weight
						Temp = (a[1][PosA] - b[1][PosB - 1]) / (b[1][PosB] - b[1][PosB - 1])
						--Now perform the lerp
						Temp = Temp * b[2][PosB] + (1 - Temp) * b[2][PosB - 1]
					else
						--If the first value can't lerp just pass the first value
						Temp = b[2][1]
					end
					LastAT = a[1][PosA]
					LastA = a[2][PosA]
					a[2][PosA] = a[2][PosA] + Temp
					PosA = PosA + 1
					if PosA <= LengthA and a[2][PosA] < 0 then
						a[2][PosA] = 0
					end
				elseif a[1][PosA] == b[1][PosB] then
					LastAT = a[1][PosA]
					LastA = a[2][PosA]
					a[2][PosA] = a[2][PosA] + b[2][PosB]
					PosA = PosA + 1
					PosB = PosB + 1
				else
					if PosA ~= 1 then
						--Need to lerp first calculate a weight
						Temp = (b[1][PosB] - LastAT) / (a[1][PosA] - LastAT)
						--Now perform the lerp
						Temp = Temp * a[2][PosA] + (1 - Temp) * LastA
					else
						--If the first value can't lerp just pass the first value
						Temp = a[2][1]
					end

					tinsert(a[1],PosA, b[1][PosB])
					tinsert(a[2],PosA, b[2][PosB] + Temp)
					PosA = PosA + 1
					PosB = PosB + 1

					if PosB <= LengthB and b[2][PosB] < 0 then
						b[2][PosB] = 0
					end
				end
			else
				LastAT = a[1][PosA]
				LastA = a[2][PosA]
				a[2][PosA] = a[2][PosA] + b[2][LengthB]
				PosA = PosA + 1
				if PosA <= LengthA and a[2][PosA] < 0 then
					a[2][PosA] = 0
				end
			end
		else
			--Then PosB must be <= LengthB
			a[1][PosA] = b[1][PosB]
			a[2][PosA] = b[2][PosB] + LastA
			PosB = PosB + 1
			PosA = PosA + 1
			if PosB <= LengthB and b[2][PosB] < 0 then
				b[2][PosB] = 0
			end
		end
	end
	return a
end

function me:DivideDataSeries(a, b)
	--If ones nil just return the other one
	if a == nil or table.maxn(a) < 2 then
		return b
	elseif b == nil or table.maxn(b) < 2 then
		return a
	end

	local LastA, LastB, Temp
	local PosA, PosB, LengthA, LengthB

	PosA = 1
	PosB = 1
	LengthA = #a[1]
	LengthB = #b[1]

	while PosA <= LengthA do
		if PosB <= LengthB then
			if a[1][PosA] <= b[1][PosB] then
				if PosB ~= 1 then
					--Need to lerp first calculate a weight
					Temp = (a[1][PosA] - b[1][PosB - 1]) / (b[1][PosB] - b[1][PosB - 1])
					--Now perform the lerp
					Temp = Temp * b[2][PosB] + (1 - Temp) * b[2][PosB - 1]
				else
					--If the first value can't lerp instead just pass the first value
					Temp = b[2][1]
				end

				if Temp ~= 0 then
					a[2][PosA] = (100 * a[2][PosA]) / Temp
				else
					a[2][PosA] = 0
				end

				if a[2][PosA] < 0 then
					a[2][PosA] = 0
				end

				PosA = PosA + 1
			else
				PosB = PosB + 1
				if PosB <= LengthB and b[2][PosB] < 0 then
					b[2][PosB] = 0
				end
			end
		else
			a[2][PosA] = 100*a[2][PosA] / (b[2][LengthB] + Epsilon)
			PosA = PosA + 1
		end
	end
end


function me:RefreshGraph()
	local Graph = Recount.GraphWindow.LineGraph
	local Length, MaxLength, Filtered, Result, MinAmount, MaxAmount, DataMax, Temp
	local Stacked = Recount:GetTable()

	Graph:ResetData()

	local i = 1
	MaxLength = 0
	MaxAmount = 0
	MinAmount = 0

	--If time range is not set need to find what will be used then
	if not Recount.TimeRangeSet then
		local TimeRangeLower, TimeRangeUpper
		if Recount.GraphWindow.Data then
			for k, v in pairs(Recount.GraphWindow.Data) do
				if v[1][1] then
					if TimeRangeLower == nil or v[1][1] < TimeRangeLower then
						TimeRangeLower = v[1][1]
					end
					if TimeRangeUpper == nil or v[1][table.maxn(v[1])] > TimeRangeUpper then
						TimeRangeUpper = v[1][table.maxn(v[1])]
					end
				end
			end
		end
		--Need to pretend like a Time Range is set then
		Recount.TimeRangeLower = TimeRangeLower
		Recount.TimeRangeUpper = TimeRangeUpper

		Graph:SetXAxis(TimeRangeLower, TimeRangeUpper)
		Graph:LockXMin(true)
		Graph:LockXMax(true)
	end

	if Recount.GraphWindow.Data then
		for k, v in pairs(Recount.GraphWindow.Data) do
			if type(v) == "table" and table.maxn(v[1]) > 0 and (v[1][1] ~= nil) and me.Enabled[k] then
				--Figure out the color used
				local color = me.GraphColors[k]

				--Start procecssing this data
				Filtered = me:FilterDataByTime(v)

				--Need to ensure its actually a copy if not then copy it
				if Filtered == v then
					Filtered = me:DataCopy(v)
				end

				if table.maxn(Filtered[1]) > 0 then
					if Recount.GraphWindow.IntegrateOn then
						me:IntegrateData(Filtered)
					end

					if not Recount.GraphWindow.StackedOn then
						Length = Filtered[1][table.maxn(Filtered[1])] - Filtered[1][1]

						if Length > 300 then
							me:DataSparsen(Filtered, Length / 100)
						end

						if Recount.GraphWindow.NormalizeOn then
							me:NormalizeData(Filtered)
						end

						local _
						_, DataMax = me:FindMax(Filtered)

						me:SetMin(Filtered, 0)

						if MaxAmount < DataMax then
							MaxAmount = DataMax
						end

						Graph:AddDataSeries(Filtered, color, true)

						if MaxLength < Length then
							MaxLength = Length
						end

						--Done with it so lets remove it
						Recount:FreeTableRecurse(Filtered)
					else
						--Stacked Graph Data needs to be stored for the moment
						local _
						_, DataMax = me:FindMax(Filtered)
						Temp = Recount:GetTable()
						Temp[1] = DataMax
						Temp[2] = Filtered
						Temp[3] = color
						Temp[4] = k
						table.insert(Stacked, Temp)
					end
				end
			end
			i = i + 1
		end
	end

	if Recount.GraphWindow.StackedOn then
		local Current = Recount:GetTable()
		table.sort(Stacked, SortForStack)

		for k, v in pairs(Stacked) do
			for k2, v2 in pairs(v[2][2]) do
				if v2 < 0 then
					v[2][2][k2] = 0
				end
			end
		end

		for k, v in pairs(Stacked) do
			Length = v[2][1][table.maxn(v[2][1])] - v[2][1][1]

			if Length > 200 then
				me:DataSparsen(v[2], Length / 70)
			end

			Current = me:AddDataSeries(v[2],Current)
			if Current ~= v[2] then
				Recount:FreeTableRecurse(v[2])
				v[2] = Current
			end
		end
		if Recount.GraphWindow.NormalizeOn then
			--Divide now by the total
			local Total = me:DataCopy(Current)
			for k, v in pairs(Stacked) do
				me:DivideDataSeries(v[2], Total)
			end
		end

		table.sort(Stacked, SortForDisplay)
		if Stacked[1] and Stacked[1][2] then
			local _
			_, MaxAmount = me:FindMax(Stacked[1][2])

			for k, v in pairs(Stacked) do
				Length = v[2][1][table.maxn(v[2][1])] - v[2][1][1]

				if Length > 200 then
					me:DataSparsen(v[2], Length / 70)
				end

				if MaxLength < Length then
					MaxLength = Length
				end

				Graph:AddFilledDataSeries(v[2], v[3], true)
				--Recount:PrintLiteral(v[2])
				--break
			end
		end
		--Can't free current because its already in there
		Recount:FreeTableRecurse(Current)
		for k, v in pairs(Stacked) do
			Recount:FreeTableRecurse(v[2])
			Recount:FreeTable(v)
		end
		Recount:FreeTable(Stacked)
	end

	Graph:SetYAxis(0, MaxAmount)

	if MaxAmount < 100 then
		DataMax = 10
	elseif MaxAmount < 250 then
		DataMax = 25
	elseif MaxAmount < 500 then
		DataMax = 50
	elseif MaxAmount < 1500 then
		DataMax = 100
	elseif MaxAmount < 3000 then
		DataMax = 200
	else
		DataMax = 100 * math.floor(MaxAmount / 1000)
	end

	local XMin = Graph.XMin
	local XMax = Graph.XMax

	--Hack fix for no data
	if XMin == nil or XMax == nil then
		Graph:SetXAxis(5, 30)
		XMin = Graph.XMin
		XMax = Graph.XMax
	end

	MaxLength = XMax - XMin

	if MaxLength < 60 then
		Graph:SetGridSpacing(5, DataMax)
		Graph.TimeRef:SetText(L["X Gridlines Represent"].." 5 "..L["Seconds"])
	elseif MaxLength < 180 then
		Graph:SetGridSpacing(15, DataMax)
		Graph.TimeRef:SetText(L["X Gridlines Represent"].." 15 "..L["Seconds"])
	elseif MaxLength < 400 then
		Graph:SetGridSpacing(30, DataMax)
		Graph.TimeRef:SetText(L["X Gridlines Represent"].." 30 "..L["Seconds"])
	elseif MaxLength < 600 then
		Graph:SetGridSpacing(60, DataMax)
		Graph.TimeRef:SetText(L["X Gridlines Represent"].." 60 "..L["Seconds"])
	else
		Graph:SetGridSpacing(math.floor(MaxLength / 100) * 10, DataMax)
		Graph.TimeRef:SetText(L["X Gridlines Represent"].." "..(math.floor(MaxLength / 100) * 10).." "..L["Seconds"])
	end

	local Background = Recount.GraphWindow.GraphBackground
	Background:HideTextures()

	local CurPos = XMin
	local Width = Background:GetWidth() / (XMax - XMin)
	local T
	--Code for drawing the various fights with a red background
	for k, v in ipairs(Recount.db2.CombatTimes) do
		if CurPos < v[1] then
			if v[1] > XMax then
				return
			end

			T = Background:FindTexture()
			T:Show()
			if Recount.GraphWindow.LastTimeOver ~= k then
				T:SetColorTexture(1, 0, 0, 0.1)
			else
				T:SetColorTexture(1, 1, 0, 0.1)
			end
			T:SetPoint("TOPLEFT", Background, "TOPLEFT", (v[1] - XMin) * Width, 0)
			if v[2] > XMax then
				T:SetPoint("BOTTOMRIGHT", Background, "BOTTOMRIGHT", 0, 0)
				return
			end
			T:SetPoint("BOTTOMRIGHT", Background, "BOTTOMLEFT", (v[2] - XMin) * Width, 0)
			T.id = k
			CurPos = v[2]
		elseif CurPos < v[2] then
			T = Background:FindTexture()
			T:Show()
			if Recount.GraphWindow.LastTimeOver ~= k then
				T:SetColorTexture(1, 0, 0, 0.1)
			else
				T:SetColorTexture(1, 1, 0, 0.1)
			end
			T:SetPoint("TOPLEFT", Background, "TOPLEFT", (CurPos - XMin) * Width, 0)
			if v[2] > XMax then
				T:SetPoint("BOTTOMRIGHT", Background, "BOTTOMRIGHT", 0, 0)
				return
			end
			T:SetPoint("BOTTOMRIGHT", Background, "BOTTOMLEFT", (v[2] - XMin) * Width, 0)
			T.id = k
			CurPos = v[2]
		end
	end
end

function me:SelectCombatTimes(id)
	local Graph = Recount.GraphWindow.LineGraph
	local Rows = Recount.GraphWindow.TimeRows

	local offset = FauxScrollFrame_GetOffset(Recount.GraphWindow.ScrollBar2)

	if Recount.TimeRangeSet == (id + offset) then
		Recount.TimeRangeSet = false
		Rows[id].Background:Hide()
		Graph:LockXMin(false)
		Graph:LockXMax(false)
		me:RefreshGraph()
		return
	end

	Recount.TimeRangeSet = id + offset
	local Times = Recount.db2.CombatTimes[id + offset]

	Recount.TimeRangeLower = Times[1] - 30
	Recount.TimeRangeUpper = Times[2] + 30

	for i = 1, 10 do
		Rows[i].Background:Hide()
	end

	Rows[id].Background:Show()

	Graph:LockXMin(true)
	Graph:LockXMax(true)
	Graph:SetXAxis(Recount.TimeRangeLower, Recount.TimeRangeUpper)
	me:RefreshGraph()
end

function me:SelectCombatTime(time)
	for k, v in pairs(Recount.db2.CombatTimes) do
		if v[1] <= time and time <= v[2] then
			local Graph = Recount.GraphWindow.LineGraph
			Recount.TimeRangeSet = k
			Recount.TimeRangeLower = v[1] - 30
			Recount.TimeRangeUpper = v[2] + 30
			Graph:LockXMin(true)
			Graph:LockXMax(true)
			Graph:SetXAxis(Recount.TimeRangeLower, Recount.TimeRangeUpper)
			me:RefreshGraph()
			Recount:GraphRefreshCombat()
			return
		end
	end
end

function me:HighlightCombatTime(time)
	local TimeOver = nil
	if time then
		for k, v in pairs(Recount.db2.CombatTimes) do
			if v[1] <= time and time <= v[2] then
				TimeOver = k
				break
			end
		end
	end

	if TimeOver ~= Recount.GraphWindow.LastTimeOver then
		for _, v in pairs(Recount.GraphWindow.GraphBackground.Textures) do
			if v.id == TimeOver then
				v:SetColorTexture(1, 1, 0, 0.1)
			elseif v.id == Recount.GraphWindow.LastTimeOver then
				v:SetColorTexture(1, 0, 0, 0.1)
			end
		end

		Recount.GraphWindow.LastTimeOver = TimeOver
	end
end

function Recount:CheckFontStringLength(fontstring, maxwidth)
	local Text = fontstring:GetText()

	while fontstring:GetStringWidth() > maxwidth do
		Text = string.sub(Text, 1, string.len(Text) - 1)
		fontstring:SetText(Text.."...")
	end
end

function Recount:SetGraphData(name, data, combat)
	Recount.GraphWindow.Title:SetText(L["Graph Window"].." - "..name)
	Recount.GraphWindow.Data = data
	Recount.GraphWindow.CombatTime = combat
	Recount.GraphWindow:Show()
	Recount:SetWindowTop(Recount.GraphWindow)

	--Need to reset class counts if in compare mode
	if Recount.GraphCompare then
		for k, _ in pairs(ClassCount) do
			ClassCount[k] = nil
		end
	end
	local Class, Shade

	if me.Enabled == nil then
		me.Enabled = {}
	end

	local i = 1
	if Recount.GraphWindow.Data then
		for k, _ in pairs(Recount.GraphWindow.Data) do
			local color = GraphColors[k]

			if type(color) ~= "table" then
				if Recount.GraphCompare and Recount.GraphClass[k] then
					Class = Recount.GraphClass[k]
					ClassCount[Class] = (ClassCount[Class] or 0) + 1
					if ClassCount[Class] <= 8 then
						Shade = ShadeVariant[ClassCount[Class]]
						color = {Shade * Recount.db.profile.Colors.Class[Class].r, Shade * Recount.db.profile.Colors.Class[Class].g, Shade * Recount.db.profile.Colors.Class[Class].b, 1}
					else
						color = {math.random(), math.random(), math.random(), 1}
					end
				else
					color = {math.random(), math.random(), math.random(), 1}
				end
			end

			me.GraphColors[k] = color
			me.Enabled[k] = true

			if i <= 10 then
				Recount.GraphWindow.Rows[i]:Show()
				Recount.GraphWindow.Rows[i].Key:SetVertexColor(color[1], color[2], color[3], 1)
				Recount.GraphWindow.Rows[i].Name:SetText(GraphName[k] or k)
			end

			i = i + 1
		end
	end

	Recount.GraphWindow.Entries = i - 1

	for j = i, 10 do
		Recount.GraphWindow.Rows[j]:Hide()
	end

	Recount:GraphRefreshData()
	Recount:GraphRefreshCombat()

	me:RefreshGraph()
end

function Recount:GraphRefreshData()
	local data = Recount.GraphWindow.Data
	local size = Recount.GraphWindow.Entries
	FauxScrollFrame_Update(Recount.GraphWindow.ScrollBar1, size, 10, 20)
	local offset = FauxScrollFrame_GetOffset(Recount.GraphWindow.ScrollBar1)
	local Rows = Recount.GraphWindow.Rows
	local i = 1 - offset

	if Recount.GraphWindow.Data then
		for k, v in pairs(Recount.GraphWindow.Data) do
			if i >= 1 and i <= 10 then
				Rows[i]:Show()
				Rows[i].Key:SetVertexColor(me.GraphColors[k][1], me.GraphColors[k][2], me.GraphColors[k][3], 1)
				Rows[i].Name:SetText(GraphName[k] or k)
				Recount:CheckFontStringLength(Rows[i].Name, 180)
				Rows[i].Enabled:SetChecked(me.Enabled[k])
				Rows[i].Enabled.Key = k
			end
			i = i + 1
		end
	end

	while i <= 10 do
		Rows[i]:Hide()
		i = i + 1
	end
end

function Recount:GraphRefreshCombat()
	local combat = Recount.db2.CombatTimes
	local size = table.getn(combat)
	FauxScrollFrame_Update(Recount.GraphWindow.ScrollBar2, size, 10, 20)
	local offset = FauxScrollFrame_GetOffset(Recount.GraphWindow.ScrollBar2)
	local Rows = Recount.GraphWindow.TimeRows

	for i = 1, 10 do
		local c = combat[i + offset]
		if c then
			Rows[i]:Show()
			Rows[i].Who:SetText(c[5])
			Recount:CheckFontStringLength(Rows[i].Who, 115)
			Rows[i].Start:SetText(c[3])
			Rows[i].End:SetText(c[4])

			if i + offset ~= Recount.TimeRangeSet then
				Rows[i].Background:Hide()
			else
				Rows[i].Background:Show()
			end
		else
			Rows[i]:Hide()
		end
	end
end

function Recount:CreateGraphWindow()
	Recount.GraphWindow = CreateFrame("Frame","Recount_GraphWindow",UIParent)

	local theFrame = Recount.GraphWindow

	theFrame.Me = me

	theFrame:ClearAllPoints()
	theFrame:SetPoint("CENTER", UIParent)
	theFrame:SetHeight(432 + 20)
	theFrame:SetWidth(625 + 24)

	theFrame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		edgeFile = "Interface\\AddOns\\Recount\\textures\\otravi-semi-full-border", edgeSize = 32,
		insets = {left = 1, right = 1, top = 20, bottom = 1},
	})
	theFrame:SetBackdropBorderColor(1.0, 0.0, 0.0)
	theFrame:SetBackdropColor(24 / 255, 24 / 255, 24 / 255)
	Recount.Colors:RegisterBorder("Other Windows","Title",theFrame)
	Recount.Colors:RegisterBackground("Other Windows","Background",theFrame)

	theFrame:EnableMouse(true)
	theFrame:SetMovable(true)
	--theFrame:RegisterForDrag("LeftButton")
	--theFrame:SetScript("OnDragStart",theFrame.StartMoving)
	--theFrame:SetScript("OnDragStop",theFrame.StopMovingOrSizing)

	theFrame:SetFrameLevel(Recount.MainWindow:GetFrameLevel() + 20)

	theFrame:SetScript("OnMouseDown", function(this, button)
		if (((not this.isLocked) or (this.isLocked == 0)) and (button == "LeftButton")) then
			Recount:SetWindowTop(this)
			this:StartMoving()
			this.isMoving = true
		end
	end)
	theFrame:SetScript("OnMouseUp", function(this)
		if (this.isMoving) then
			local point, relativeTo, relativePoint, xOfs, yOfs = this:GetPoint(1)
			Recount.db.profile.GraphWindowX = xOfs
			Recount.db.profile.GraphWindowY = yOfs
			this:StopMovingOrSizing()
			this.isMoving = false
		end
	end)
	theFrame:SetScript("OnShow", function(this)
		Recount:SetWindowTop(this)
	end)
	theFrame:SetScript("OnHide", function(this)
		if (this.isMoving) then
			local point, relativeTo, relativePoint, xOfs, yOfs = this:GetPoint(1)
			Recount.db.profile.GraphWindowX = xOfs
			Recount.db.profile.GraphWindowY = yOfs
			this:StopMovingOrSizing()
			this.isMoving = false
		end
	end)

	theFrame.Title = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Title:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 6, -15)
	theFrame.Title:SetTextColor(1.0, 1.0, 1.0, 1.0)
	theFrame.Title:SetText(L["Graph Window"])

	--Recount.Colors:UnregisterItem(Recount.GraphWindow.Title)
	Recount.Colors:RegisterFont("Other Windows", "Title Text", Recount.GraphWindow.Title)

	theFrame.LineGraph = Graph:CreateGraphLine("Recount_GraphWindow_LineGraph", theFrame, "TOPLEFT", "TOPLEFT", 1, -32, 400, 418)
	theFrame.LineGraph:SetAutoScale(true)
	theFrame.LineGraph:SetYAxis(0, 100)
	theFrame.LineGraph:SetGridSpacing(15, 25)
	theFrame.LineGraph:LockYMin(true)
	theFrame.LineGraph:SetYLabels(true, true)
	theFrame.LineGraph:SetFrameLevel(theFrame:GetFrameLevel() + 2)
	theFrame.LineGraph.TimeRef = theFrame.LineGraph:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.LineGraph.TimeRef:SetPoint("TOP", theFrame.LineGraph, "TOP", 0, -2)
	theFrame.LineGraph.TimeRef:SetTextColor(1.0, 1.0, 1.0, 1.0)

	theFrame.GraphBackground = CreateFrame("Frame", nil, theFrame)
	theFrame.GraphBackground:SetAllPoints(theFrame.LineGraph)
	theFrame.GraphBackground.HideTextures = me.HideTextures
	theFrame.GraphBackground.FindTexture = me.FindTexture

	theFrame.GraphBackground:EnableMouse(true)

	theFrame.GraphBackground.TimeSelect = theFrame.GraphBackground:CreateTexture(nil, "BACKGROUND")
	theFrame.GraphBackground.TimeSelect:SetColorTexture(0, 1, 0, 0.1)
	theFrame.GraphBackground.TimeSelect:Hide()


	theFrame.GraphBackground:SetScript("OnUpdate", function(this)
		local sX = this:GetCenter()
		local Scale = this:GetEffectiveScale()
		local mX = GetCursorPosition()
		local TimePos
		local GraphWindow = Recount.GraphWindow

		if Recount.TimeRangeUpper and (MouseIsOver(GraphWindow.GraphBackground) or Recount.GraphWindow.Dragging) then
			TimePos = (mX / Scale - sX + this:GetWidth() / 2) / this:GetWidth()
			TimePos = TimePos * (Recount.TimeRangeUpper - Recount.TimeRangeLower) + Recount.TimeRangeLower

			if MouseIsOver(GraphWindow.GraphBackground) then
				me:HighlightCombatTime(TimePos)
			end

			if GraphWindow.Dragging then
				local Graph = GraphWindow.LineGraph
				local Background = GraphWindow.GraphBackground

				local XMin = Graph.XMin
				local XMax = Graph.XMax

				--Hack fix for no data
				if XMin == nil or XMax == nil then
					Graph:SetXAxis(5, 30)
					XMin = Graph.XMin
					XMax = Graph.XMax
				end

				local Width = Background:GetWidth() / (XMax - XMin)

				local Left, Right

				Left = math.max(math.min(GraphWindow.DragTimeStart, XMax),XMin)
				Right = math.max(math.min(TimePos, XMax),XMin)

				if Right < Left then
					local t = Left
					Left = Right
					Right = t
				end

				Background.TimeSelect:SetPoint("TOPLEFT", Background, "TOPLEFT", (Left - XMin) * Width, 0)
				Background.TimeSelect:SetPoint("BOTTOMRIGHT", Background, "BOTTOMLEFT", (Right - XMin) * Width, 0)
			end
		end
	end)
	theFrame.GraphBackground:SetScript("OnMouseDown", function(this)
		local sX = this:GetCenter()
		local Scale = this:GetEffectiveScale()
		local mX = GetCursorPosition()
		local TimePos

		if Recount.TimeRangeUpper then
			TimePos = (mX / Scale - sX + this:GetWidth() / 2) / this:GetWidth()
			TimePos = TimePos * (Recount.TimeRangeUpper - Recount.TimeRangeLower) + Recount.TimeRangeLower

			--If we start dragging we want this to be the start position
			Recount.GraphWindow.DragTimeStart = TimePos
		end
	end)
	theFrame.GraphBackground:SetScript("OnMouseUp", function(this)
		if Recount.GraphWindow.Dragging then
			Recount.GraphWindow.Dragging = false
			return
		end
		if GetMouseButtonClicked() == "RightButton" then
			Recount.TimeRangeSet = false
			me:RefreshGraph()
			Recount:GraphRefreshCombat()
		elseif GetMouseButtonClicked() == "LeftButton" then
			local sX = this:GetCenter()
			local Scale = this:GetEffectiveScale()
			local mX = GetCursorPosition()
			local TimePos

			if Recount.TimeRangeUpper then -- Elsia: Prevent nil error
				TimePos = (mX / Scale - sX + this:GetWidth() / 2) / this:GetWidth()
				TimePos = TimePos * (Recount.TimeRangeUpper - Recount.TimeRangeLower) + Recount.TimeRangeLower
				me:SelectCombatTime(TimePos)
			end
		end
	end)
	theFrame.GraphBackground:SetScript("OnDragStart", function()
		Recount.GraphWindow.Dragging = true
		--Recount.GraphWindow.DragTimeStart = TimePos
		Recount.GraphWindow.GraphBackground.TimeSelect:Show()
	end)
	theFrame.GraphBackground:SetScript("OnDragStop", function(this)
		--First get cur time pos
		local sX = this:GetCenter()
		local Scale = this:GetEffectiveScale()
		local mX = GetCursorPosition()
		local TimePos

		if Recount.TimeRangeUpper then -- Elsia: Prevent nil error
			TimePos = (mX / Scale - sX + this:GetWidth() / 2) / this:GetWidth()
			TimePos = TimePos * (Recount.TimeRangeUpper - Recount.TimeRangeLower) + Recount.TimeRangeLower
			me:HighlightCombatTime(TimePos)
		end

		--Need XMin and XMax of the graph
		local Graph = Recount.GraphWindow.LineGraph
		local XMin = Graph.XMin
		local XMax = Graph.XMax

		--Hack fix for no data
		if XMin == nil or XMax == nil then
			Graph:SetXAxis(5, 30)
			XMin = Graph.XMin
			XMax = Graph.XMax
		end

		--Now figure out left and right
		local Left, Right

		if Recount.GraphWindow.DragTimeStart then
			Left = math.max(math.min(Recount.GraphWindow.DragTimeStart, XMax), XMin)
			Right = math.max(math.min(TimePos, XMax), XMin)

			if Right < Left then
				local t = Left
				Left = Right
				Right = t
			end
		end

		--Now to set the graph
		Recount.TimeRangeSet = true
		Recount.TimeRangeLower = Left
		Recount.TimeRangeUpper = Right
		Graph:LockXMin(true)
		Graph:LockXMax(true)
		Graph:SetXAxis(Recount.TimeRangeLower, Recount.TimeRangeUpper)
		me:RefreshGraph()

		Recount.GraphWindow.GraphBackground.TimeSelect:Hide()
	end)
	theFrame.GraphBackground:RegisterForDrag("LeftButton")



	theFrame.Labels = CreateFrame("Frame", nil, theFrame)
	local Labels = theFrame.Labels

	Labels:SetWidth(219)
	Labels:SetHeight(16)
	Labels:SetPoint("TOPRIGHT", theFrame, "TOPRIGHT", -1 - 24, -34)

	Labels.Key = Labels:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Labels.Key:SetPoint("LEFT", Labels, "LEFT", 1, 0)
	Labels.Key:SetText("K")

	Labels.Name = Labels:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Labels.Name:SetPoint("LEFT", Labels, "LEFT", 16, 0)
	Labels.Name:SetText(L["Data Name"])

	Labels.Name = Labels:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Labels.Name:SetPoint("Right", Labels, "RIGHT", -2, 0)
	Labels.Name:SetText(L["Enabled"])

	theFrame.Rows = {}

	for i = 1, 10 do
		local Row = CreateFrame("Frame", nil, theFrame)
		Row:SetWidth(219)
		Row:SetHeight(16)
		Row:SetPoint("TOPRIGHT", theFrame, "TOPRIGHT", -1 - 24, -34 - i * 18)

		Row.Key = Row:CreateTexture("RecountRowTexture"..i,"OVERLAY")
		Row.Key:SetPoint("LEFT", Row, "LEFT", 0, 0)
		Row.Key:SetTexture("Interface\\Buttons\\WHITE8X8.blp")
		Row.Key:SetWidth(12)
		Row.Key:SetHeight(12)

		Row.Name = Row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		Row.Name:SetPoint("LEFT", Row, "LEFT", 16, 0)
		Row.Name:SetText("Test")
		Row.Name:SetTextColor(1.0, 1.0, 1.0, 1.0)

		Row.Enabled = CreateFrame("CheckButton", nil, Row)
		Row.Enabled:SetPoint("RIGHT", Row, "RIGHT", -4, 0)
		Row.Enabled:SetWidth(16)
		Row.Enabled:SetHeight(16)
		Row.Enabled:SetScript("OnClick", function(this)
			if this:GetChecked() then
				this:SetChecked(true)
			else
				this:SetChecked(false)
			end
			me.Enabled[this.Key] = this:GetChecked()
			me:RefreshGraph()
		end)
		Row.Enabled:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
		Row.Enabled:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
		Row.Enabled:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
		Row.Enabled:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
		Row.Enabled:SetChecked(true)

		Row:Hide()

		table.insert(theFrame.Rows, Row)
	end

	theFrame.ScrollBar1 = CreateFrame("SCROLLFRAME", "Recount_GraphWindow_ScrollBar1", theFrame, "FauxScrollFrameTemplate")
	theFrame.ScrollBar1:SetScript("OnVerticalScroll", function(self, offset)
		FauxScrollFrame_OnVerticalScroll(self, offset, 20, Recount.GraphRefreshData)
	end)
	theFrame.ScrollBar1:SetPoint("TOPLEFT", theFrame.Rows[1], "TOPLEFT")
	theFrame.ScrollBar1:SetPoint("BOTTOMRIGHT", theFrame.Rows[10], "BOTTOMRIGHT")
	Recount:SetupScrollbar("Recount_GraphWindow_ScrollBar1")

	theFrame.TimeLabels = CreateFrame("Frame", nil, theFrame)
	local Labels = theFrame.TimeLabels

	Labels:SetWidth(219)
	Labels:SetHeight(16)
	Labels:SetPoint("TOPLEFT", theFrame.Rows[10], "BOTTOMLEFT", 0, -2)

	Labels.Who = Labels:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Labels.Who:SetPoint("LEFT", Labels, "LEFT", 0, 0)
	Labels.Who:SetText(L["Fought"])

	Labels.Start = Labels:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Labels.Start:SetPoint("CENTER", Labels, "RIGHT", -80, 0)
	Labels.Start:SetText(L["Start"])

	Labels.End = Labels:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Labels.End:SetPoint("RIGHT", Labels, "RIGHT", -15, 0)
	Labels.End:SetText(L["End"])

	theFrame.TimeRows = {}
	for i = 1, 10 do
		local Row = CreateFrame("Frame", nil, theFrame)
		Row:SetWidth(219)
		Row:SetHeight(16)
		Row:SetPoint("TOP", Labels, "BOTTOM", 0, -2 - 18 * (i - 1))
		Row.id = i
		Row:EnableMouse(true)
		Row:SetScript("OnMouseDown", function(this)
			me:SelectCombatTimes(this.id)
		end)
		Row:SetScript("OnEnter", function(this)
			this.Highlighted:Show()
		end)
		Row:SetScript("OnLeave", function(this)
			this.Highlighted:Hide()
		end)

		Row.Background = Row:CreateTexture(nil, "BACKGROUND")
		Row.Background:SetAllPoints(Row)
		Row.Background:SetColorTexture(1.0, 1.0, 0.0, 0.3)
		Row.Background:Hide()

		Row.Highlighted = Row:CreateTexture(nil, "BACKGROUND")
		Row.Highlighted:SetAllPoints(Row)
		Row.Highlighted:SetColorTexture(1.0, 0.0, 0.0, 0.3)
		Row.Highlighted:Hide()

		Row.Who = Row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		Row.Who:SetPoint("LEFT",Row,"LEFT",0, 0)
		Row.Who:SetText("Test")
		Row.Who:SetTextColor(1.0, 1.0, 1.0, 1.0)

		Row.Start = Row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		Row.Start:SetPoint("CENTER", Row, "RIGHT", -80, 0)
		Row.Start:SetText("12:12:50")
		Row.Start:SetTextColor(1.0, 1.0, 1.0, 1.0)

		Row.End = Row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		Row.End:SetPoint("RIGHT", Row, "RIGHT", 0, 0)
		Row.End:SetText("12:12:50")
		Row.End:SetTextColor(1.0, 1.0, 1.0, 1.0)

		--Row:Hide()

		table.insert(theFrame.TimeRows, Row)
	end

	theFrame.ScrollBar2 = CreateFrame("SCROLLFRAME", "Recount_GraphWindow_ScrollBar2", theFrame, "FauxScrollFrameTemplate")
	theFrame.ScrollBar2:SetScript("OnVerticalScroll", function(self, offset)
		FauxScrollFrame_OnVerticalScroll(self, offset, 20, Recount.GraphRefreshCombat)
	end)
	theFrame.ScrollBar2:SetPoint("TOPLEFT", theFrame.TimeRows[1], "TOPLEFT")
	theFrame.ScrollBar2:SetPoint("BOTTOMRIGHT", theFrame.TimeRows[10], "BOTTOMRIGHT")
	Recount:SetupScrollbar("Recount_GraphWindow_ScrollBar2")

	theFrame.CloseButton = CreateFrame("Button", nil, theFrame)
	theFrame.CloseButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
	theFrame.CloseButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
	theFrame.CloseButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
	theFrame.CloseButton:SetWidth(20)
	theFrame.CloseButton:SetHeight(20)
	theFrame.CloseButton:SetPoint("TOPRIGHT", theFrame, "TOPRIGHT", -4, -12)
	theFrame.CloseButton:SetScript("OnClick", function(this)
		this:GetParent():Hide()
	end)

	theFrame.RefreshButton = CreateFrame("Button", nil, theFrame)
	theFrame.RefreshButton:SetNormalTexture("Interface\\Buttons\\UI-RotationLeft-Button-Up")
	theFrame.RefreshButton:SetPushedTexture("Interface\\Buttons\\UI-RotationLeft-Button-Down")
	theFrame.RefreshButton:SetWidth(20)
	theFrame.RefreshButton:SetHeight(20)
	theFrame.RefreshButton:SetPoint("RIGHT", theFrame.CloseButton, "LEFT", 0, 0)
	theFrame.RefreshButton:SetScript("OnClick", function()
		me:RefreshGraph()
	end)

	theFrame.SelectAllButton = CreateFrame("Button",nil, theFrame)
	theFrame.SelectAllButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
	theFrame.SelectAllButton:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-Down")
	theFrame.SelectAllButton:SetWidth(16)
	theFrame.SelectAllButton:SetHeight(16)
	theFrame.SelectAllButton:SetPoint("RIGHT", theFrame.RefreshButton, "LEFT", 0, 0)
	theFrame.SelectAllButton:SetScript("OnClick", function()
		Recount:AddAllToGraph()
	end)

	theFrame.Normalize = CreateFrame("Frame", nil, theFrame)
	local Normalize = theFrame.Normalize

	Normalize:SetWidth(80)
	Normalize:SetHeight(18)
	Normalize:SetPoint("BOTTOMRIGHT", theFrame, "BOTTOMRIGHT", -164, 2)

	Normalize.Text = Normalize:CreateFontString(nil,"OVERLAY","GameFontNormal")
	Normalize.Text:SetPoint("LEFT",Normalize,"LEFT",0, 0)
	Normalize.Text:SetText(L["Normalize"])

	Normalize.Enabled = CreateFrame("CheckButton", nil, Normalize)
	Normalize.Enabled:SetPoint("LEFT", Normalize.Text, "RIGHT", 6, 0)
	Normalize.Enabled:SetWidth(18)
	Normalize.Enabled:SetHeight(18)
	--Normalize.Enabled.id = CurRow
	Normalize.Enabled:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			theFrame.NormalizeOn = true
		else
			this:SetChecked(false)
			theFrame.NormalizeOn = false
		end
		me:RefreshGraph()
	end)
	Normalize.Enabled:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
	Normalize.Enabled:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
	Normalize.Enabled:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
	Normalize.Enabled:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
	Normalize.Enabled:SetChecked(false)
	Normalize:Show()

	theFrame.Integrate = CreateFrame("Frame", nil, theFrame)
	local Integrate = theFrame.Integrate

	Integrate:SetWidth(80)
	Integrate:SetHeight(18)
	Integrate:SetPoint("BOTTOMRIGHT", theFrame, "BOTTOMRIGHT", -70, 2)

	Integrate.Text = Integrate:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Integrate.Text:SetPoint("LEFT", Integrate, "LEFT", 0, 0)
	Integrate.Text:SetText(L["Integrate"])

	Integrate.Enabled = CreateFrame("CheckButton", nil, Integrate)
	Integrate.Enabled:SetPoint("LEFT", Integrate.Text, "RIGHT", 6, 0)
	Integrate.Enabled:SetWidth(18)
	Integrate.Enabled:SetHeight(18)
	--Integrate.Enabled.id = CurRow
	Integrate.Enabled:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			theFrame.IntegrateOn = true
		else
			this:SetChecked(false)
			theFrame.IntegrateOn = false
		end
		me:RefreshGraph()
	end)
	Integrate.Enabled:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
	Integrate.Enabled:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
	Integrate.Enabled:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
	Integrate.Enabled:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
	Integrate.Enabled:SetChecked(false)
	Integrate:Show()

	theFrame.Stacked = CreateFrame("Frame", nil, theFrame)
	local Stacked = theFrame.Stacked

	Stacked:SetWidth(60)
	Stacked:SetHeight(18)
	Stacked:SetPoint("BOTTOMRIGHT", theFrame, "BOTTOMRIGHT", 0, 2)

	Stacked.Text = Integrate:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Stacked.Text:SetPoint("LEFT", Stacked, "LEFT", 0, 0)
	Stacked.Text:SetText(L["Stack"])

	Stacked.Enabled = CreateFrame("CheckButton", nil, Integrate)
	Stacked.Enabled:SetPoint("LEFT", Stacked.Text, "RIGHT", 6, 0)
	Stacked.Enabled:SetWidth(18)
	Stacked.Enabled:SetHeight(18)
	--Stacked.Enabled.id = CurRow
	Stacked.Enabled:SetScript("OnClick",function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			theFrame.StackedOn = true
		else
			this:SetChecked(false)
			theFrame.StackedOn = false
		end
		me:RefreshGraph()
	end)
	Stacked.Enabled:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
	Stacked.Enabled:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
	Stacked.Enabled:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
	Stacked.Enabled:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
	Stacked.Enabled:SetChecked(false)
	Stacked:Show()

	theFrame.NormalizeOn = false
	theFrame.IntegrateOn = false
	theFrame.StackedOn = false

	theFrame:Hide()
end
