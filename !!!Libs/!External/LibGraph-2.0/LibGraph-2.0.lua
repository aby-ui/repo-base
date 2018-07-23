--[[
Name: LibGraph-2.0
Revision: $Rev: 55 $
Author(s): Cryect (cryect@gmail.com), Xinhuan
Website: http://www.wowace.com/
Documentation: http://www.wowace.com/wiki/GraphLib
SVN: http://svn.wowace.com/root/trunk/GraphLib/
Description: Allows for easy creation of graphs
]]

--Thanks to Nelson Minar for catching several errors where width was being used instead of height (damn copy and paste >_>)

local major = "LibGraph-2.0"
local minor = 90000 + tonumber(("$Revision: 55 $"):match("(%d+)"))


--Search for just Addon\\ at the front since the interface part often gets trimmed
--Do this before anything else, so if it errors, any existing loaded copy of LibGraph-2.0
--doesn't get modified with a newer revision (this one)
local TextureDirectory
do
	--local path = string.match(debugstack(1, 1, 0), "AddOns\\(.+)LibGraph%-2%.0%.lua")
    local path = "!!!Libs\\!External\\LibGraph-2.0\\"
	if path then
		TextureDirectory = "Interface\\AddOns\\"..path
	else
		error(major.." cannot determine the folder it is located in because the path is too long and got truncated in the debugstack(1, 1, 0) function call")
	end
end


if not LibStub then error(major .. " requires LibStub") end

local lib, oldLibMinor = LibStub:NewLibrary(major, minor)
if not lib then return end

local GraphFunctions = {}

local gsub = gsub
local ipairs = ipairs
local pairs = pairs
local sqrt = sqrt
local table = table
local tinsert = tinsert
local tremove = tremove
local type = type
local math_max = math.max
local math_min = math.min
local math_ceil = math.ceil
local math_pi = math.pi
local math_floor = math.floor
local math_pow = math.pow
local math_random = math.random
local math_cos = math.cos
local math_sin = math.sin
local math_deg = math.deg
local math_atan = math.atan
local math_abs = math.abs
local math_fmod = math.fmod
local math_huge = math.huge

local CreateFrame = CreateFrame
local GetCursorPosition = GetCursorPosition
local GetTime = GetTime
local MouseIsOver = MouseIsOver
local UnitHealth = UnitHealth

local UIParent = UIParent

local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME

-- lib upgrade stuff
lib.RegisteredGraphRealtime		= lib.RegisteredGraphRealtime or {}
lib.RegisteredGraphLine			= lib.RegisteredGraphLine or {}
lib.RegisteredGraphScatterPlot	= lib.RegisteredGraphScatterPlot or {}
lib.RegisteredGraphPieChart		= lib.RegisteredGraphPieChart or {}


--------------------------------------------------------------------------------
--Graph Creation Functions
--------------------------------------------------------------------------------

--Realtime Graph
local function SetupGraphRealtimeFunctions(graph, upgrade)
	local self = lib

	--Set the various functions
	graph.SetXAxis = GraphFunctions.SetXAxis
	graph.SetYMax = GraphFunctions.SetYMax
	graph.AddTimeData = GraphFunctions.AddTimeData
	graph.OnUpdate = GraphFunctions.OnUpdateGraphRealtime
	graph.CreateGridlines = GraphFunctions.CreateGridlines
	graph.RefreshGraph = GraphFunctions.RefreshRealtimeGraph
	graph.SetAxisDrawing = GraphFunctions.SetAxisDrawing
	graph.SetGridSpacing = GraphFunctions.SetGridSpacing
	graph.SetAxisColor = GraphFunctions.SetAxisColor
	graph.SetGridColor = GraphFunctions.SetGridColor
	graph.SetGridColorSecondary = GraphFunctions.SetGridColorSecondary
	graph.SetGridSecondaryMultiple = GraphFunctions.SetGridSecondaryMultiple
	graph.SetFilterRadius = GraphFunctions.SetFilterRadius
	--graph.SetAutoscaleYAxis = GraphFunctions.SetAutoscaleYAxis
	graph.SetBarColors = GraphFunctions.SetBarColors
	graph.SetMode = GraphFunctions.SetMode
	graph.SetAutoScale = GraphFunctions.SetAutoScale
	if not upgrade then
		-- This is the original frame:SetWidth() and frame:SetHeight()
		-- standard frame functions
		graph.OldSetWidth = graph.SetWidth
		graph.OldSetHeight = graph.SetHeight
	end
	graph.SetWidth = GraphFunctions.RealtimeSetWidth
	graph.SetHeight = GraphFunctions.RealtimeSetHeight
	graph.SetBarColors = GraphFunctions.RealtimeSetColors
	graph.GetMaxValue = GraphFunctions.GetMaxValue
	graph.GetValue = GraphFunctions.RealtimeGetValue
	graph.SetUpdateLimit = GraphFunctions.SetUpdateLimit
	graph.SetDecay = GraphFunctions.SetDecay
	graph.SetMinMaxY = GraphFunctions.SetMinMaxY
	graph.AddBar = GraphFunctions.AddBar
	graph.SetYLabels = GraphFunctions.SetYLabels


	graph.DrawLine = self.DrawLine
	graph.DrawHLine = self.DrawHLine
	graph.DrawVLine = self.DrawVLine
	graph.HideLines = self.HideLines
	graph.HideFontStrings = GraphFunctions.HideFontStrings
	graph.FindFontString = GraphFunctions.FindFontString
	graph.SetBars = GraphFunctions.SetBars


	--Set the update function
	graph:SetScript("OnUpdate", graph.OnUpdate)
end

function lib:CreateGraphRealtime(name, parent, relative, relativeTo, offsetX, offsetY, Width, Height)
	local graph
	local i
	graph = CreateFrame("Frame", name, parent)

	Width = math_floor(Width)


	graph:SetPoint(relative, parent, relativeTo, offsetX, offsetY)
	graph:SetWidth(Width)
	graph:SetHeight(Height)
	graph:Show()

	--Create the bars
	graph.Bars = {}
	graph.BarsUsing = {}
	graph.BarNum = Width
	graph.Height = Height
	for i = 1, Width do
		local bar
		bar = CreateFrame("StatusBar", name.."Bar"..i, graph)--graph:CreateTexture(nil, "ARTWORK")
		bar:SetPoint("BOTTOMLEFT", graph, "BOTTOMLEFT", i - 1, 0)
		bar:SetHeight(Height)
		bar:SetWidth(1)
		bar:SetOrientation("VERTICAL")
		bar:SetMinMaxValues(0, 1)
		bar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
		bar:GetStatusBarTexture():SetHorizTile(false)
		bar:GetStatusBarTexture():SetVertTile(false)

		local t = bar:GetStatusBarTexture()
		t:SetGradientAlpha("VERTICAL", 0.2, 0.0, 0.0, 0.5, 1.0, 0.0, 0.0, 1.0)

		bar:Show()
		tinsert(graph.Bars, bar)
		tinsert(graph.BarsUsing, bar)
	end


	SetupGraphRealtimeFunctions(graph)


	--Initialize Data
	graph.GraphType = "REALTIME"
	graph.YMax = 60
	graph.YMin = 0
	graph.XMax = -0.75
	graph.XMin = -10
	graph.TimeRadius = 0.5
	graph.Mode = "FAST"
	graph.Filter = "RECT"
	graph.AxisColor = {1.0, 1.0, 1.0, 1.0}
	graph.GridColor = {0.5, 0.5, 0.5, 0.5}
	graph.BarColorTop = {1.0, 0.0, 0.0, 1.0}
	graph.BarColorBot = {0.2, 0.0, 0.0, 0.5}
	graph.AutoScale = false
	graph.Data = {}
	graph.MinMaxY = 0
	graph.CurVal = 0
	graph.LastDataTime = GetTime()

	graph.Textures = {}
	graph.TexturesUsed = {}

	graph.LimitUpdates = 0
	graph.NextUpdate = 0

	graph.BarHeight = {}
	graph.LastShift = GetTime()
	graph.BarWidth = (graph.XMax - graph.XMin) / graph.BarNum
	graph.DecaySet = 0.8
	graph.Decay = math_pow(graph.DecaySet, graph.BarWidth)
	graph.ExpNorm = 1 / (1 - graph.Decay)

	graph.FilterOverlap = math_max(math_ceil((graph.TimeRadius + graph.XMax) / graph.BarWidth), 0)
	for i = 1, graph.BarNum do
		graph.BarHeight[i] = 0
	end

	graph.TextFrame = CreateFrame("Frame", nil, graph)
	graph.TextFrame:SetAllPoints(graph)
	graph.TextFrame:SetFrameLevel(graph:GetFrameLevel() + 2)

	tinsert(self.RegisteredGraphRealtime, graph)
	return graph
end

--Line Graph
local function SetupGraphLineFunctions(graph)
	local self = lib

	--Set the various functions
	graph.SetXAxis = GraphFunctions.SetXAxis
	graph.SetYAxis = GraphFunctions.SetYAxis
	graph.AddDataSeries = GraphFunctions.AddDataSeries
	graph.AddFilledDataSeries = GraphFunctions.AddFilledDataSeries
	graph.ResetData = GraphFunctions.ResetData
	graph.RefreshGraph = GraphFunctions.RefreshLineGraph
	graph.CreateGridlines = GraphFunctions.CreateGridlines
	graph.SetAxisDrawing = GraphFunctions.SetAxisDrawing
	graph.SetGridSpacing = GraphFunctions.SetGridSpacing
	graph.SetAxisColor = GraphFunctions.SetAxisColor
	graph.SetGridColor = GraphFunctions.SetGridColor
	graph.SetGridColorSecondary = GraphFunctions.SetGridColorSecondary
	graph.SetGridSecondaryMultiple = GraphFunctions.SetGridSecondaryMultiple
	graph.SetAutoScale = GraphFunctions.SetAutoScale
	graph.SetYLabels = GraphFunctions.SetYLabels
	graph.OnUpdate = GraphFunctions.OnUpdateGraph

	graph.SetLineTexture = GraphFunctions.SetLineTexture
	graph.SetBorderSize = GraphFunctions.SetBorderSize
	
	graph.LockXMin = GraphFunctions.LockXMin
	graph.LockXMax = GraphFunctions.LockXMax
	graph.LockYMin = GraphFunctions.LockYMin
	graph.LockYMax = GraphFunctions.LockYMax


	graph.DrawLine = self.DrawLine
	graph.DrawHLine = self.DrawHLine
	graph.DrawVLine = self.DrawVLine
	graph.HideLines = self.HideLines
	graph.DrawBar = self.DrawBar
	graph.HideBars = self.HideBars
	graph.HideFontStrings = GraphFunctions.HideFontStrings
	graph.FindFontString = GraphFunctions.FindFontString

	--Set the update function
	graph:SetScript("OnUpdate", graph.OnUpdate)
end

--TODO: Clip lines with the bounds
function lib:CreateGraphLine(name, parent, relative, relativeTo, offsetX, offsetY, Width, Height)
	local graph
	local i
	graph = CreateFrame("Frame", name, parent)


	graph:SetPoint(relative, parent, relativeTo, offsetX, offsetY)
	graph:SetWidth(Width)
	graph:SetHeight(Height)
	graph:Show()


	SetupGraphLineFunctions(graph)


	graph.NeedsUpdate = false


	--Initialize Data
	graph.GraphType = "LINE"
	graph.YMax = 1
	graph.YMin = -1
	graph.XMax = 1
	graph.XMin = -1
	graph.AxisColor = {1.0, 1.0, 1.0, 1.0}
	graph.GridColor = {0.5, 0.5, 0.5, 0.5}
	graph.XGridInterval = 0.25
	graph.YGridInterval = 0.25
	graph.XAxisDrawn = true
	graph.YAxisDrawn = true

	graph.LockOnXMin = false
	graph.LockOnXMax = false
	graph.LockOnYMin = false
	graph.LockOnYMax = false
	graph.Data = {}
	graph.FilledData = {}
	graph.Textures = {}
	graph.TexturesUsed = {}
	graph.TextFrame = CreateFrame("Frame", nil, graph)
	graph.TextFrame:SetAllPoints(graph)


	tinsert(self.RegisteredGraphLine, graph)
	return graph
end


--Scatter Plot
local function SetupGraphScatterPlotFunctions(graph)
	local self = lib

	--Set the various functions
	graph.SetXAxis = GraphFunctions.SetXAxis
	graph.SetYAxis = GraphFunctions.SetYAxis
	graph.AddDataSeries = GraphFunctions.AddDataSeries
	graph.ResetData = GraphFunctions.ResetData
	graph.RefreshGraph = GraphFunctions.RefreshScatterPlot
	graph.CreateGridlines = GraphFunctions.CreateGridlines
	graph.OnUpdate = GraphFunctions.OnUpdateGraph

	graph.LinearRegression = GraphFunctions.LinearRegression
	graph.SetAxisDrawing = GraphFunctions.SetAxisDrawing
	graph.SetGridSpacing = GraphFunctions.SetGridSpacing
	graph.SetAxisColor = GraphFunctions.SetAxisColor
	graph.SetGridColor = GraphFunctions.SetGridColor
	graph.SetGridColorSecondary = GraphFunctions.SetGridColorSecondary
	graph.SetGridSecondaryMultiple = GraphFunctions.SetGridSecondaryMultiple
	graph.SetLinearFit = GraphFunctions.SetLinearFit
	graph.SetAutoScale = GraphFunctions.SetAutoScale
	graph.SetYLabels = GraphFunctions.SetYLabels

	graph.LockXMin = GraphFunctions.LockXMin
	graph.LockXMax = GraphFunctions.LockXMax
	graph.LockYMin = GraphFunctions.LockYMin
	graph.LockYMax = GraphFunctions.LockYMax

	graph.DrawLine = self.DrawLine
	graph.DrawHLine = self.DrawHLine
	graph.DrawVLine = self.DrawVLine
	graph.HideLines = self.HideLines
	graph.HideTextures = GraphFunctions.HideTextures
	graph.FindTexture = GraphFunctions.FindTexture
	graph.HideFontStrings = GraphFunctions.HideFontStrings
	graph.FindFontString = GraphFunctions.FindFontString

	--Set the update function
	graph:SetScript("OnUpdate", graph.OnUpdate)
end

function lib:CreateGraphScatterPlot(name, parent, relative, relativeTo, offsetX, offsetY, Width, Height)
	local graph
	local i
	graph = CreateFrame("Frame",name, parent)


	graph:SetPoint(relative, parent, relativeTo, offsetX, offsetY)
	graph:SetWidth(Width)
	graph:SetHeight(Height)
	graph:Show()


	SetupGraphScatterPlotFunctions(graph)


	graph.NeedsUpdate = false

	--Initialize Data
	graph.GraphType = "SCATTER"
	graph.YMax = 1
	graph.YMin = -1
	graph.XMax = 1
	graph.XMin = -1
	graph.AxisColor = {1.0, 1.0, 1.0, 1.0}
	graph.GridColor = {0.5, 0.5, 0.5, 0.5}
	graph.XGridInterval = 0.25
	graph.YGridInterval = 0.25
	graph.XAxisDrawn = true
	graph.YAxisDrawn = true
	graph.AutoScale = false
	graph.LinearFit = false
	graph.LockOnXMin = false
	graph.LockOnXMax = false
	graph.LockOnYMin = false
	graph.LockOnYMax = false
	graph.Data = {}
	graph.Textures = {}
	graph.TexturesUsed = {}

	graph.TextFrame = CreateFrame("Frame", nil, graph)
	graph.TextFrame:SetAllPoints(graph)

	tinsert(self.RegisteredGraphScatterPlot, graph)
	return graph
end

--Pie Chart
local function SetupGraphPieChartFunctions(graph)
	local self = lib

	--Set the various functions
	graph.AddPie = GraphFunctions.AddPie
	graph.CompletePie = GraphFunctions.CompletePie
	graph.ResetPie = GraphFunctions.ResetPie

	graph.DrawLine = self.DrawLine
	graph.DrawHLine = self.DrawHLine
	graph.DrawVLine = self.DrawVLine
	graph.DrawLinePie = GraphFunctions.DrawLinePie
	graph.HideLines = self.HideLines
	graph.HideTextures = GraphFunctions.HideTextures
	graph.FindTexture = GraphFunctions.FindTexture
	graph.OnUpdate = GraphFunctions.PieChart_OnUpdate
	graph.SetSelectionFunc = GraphFunctions.SetSelectionFunc

	graph:SetScript("OnUpdate", graph.OnUpdate)
end

function lib:CreateGraphPieChart(name, parent, relative, relativeTo, offsetX, offsetY, Width, Height)
	local graph
	local i
	graph = CreateFrame("Frame",name, parent)


	graph:SetPoint(relative, parent, relativeTo, offsetX, offsetY)
	graph:SetWidth(Width)
	graph:SetHeight(Height)
	graph:Show()


	SetupGraphPieChartFunctions(graph)


	--Initialize Data
	graph.GraphType = "PIE"
	graph.PieUsed = 0
	graph.PercentOn = 0
	graph.Remaining = 0
	graph.Textures = {}
	graph.Ratio = Width / Height
	graph.Radius = 0.88 * (Width / 2)
	graph.Radius = graph.Radius * graph.Radius
	graph.Sections = {}
	graph.Textures = {}
	graph.TexturesUsed = {}
	graph.LastSection = nil
	graph.onColor = 1
	graph.TotalSections = 0

	tinsert(self.RegisteredGraphPieChart, graph)
	return graph
end


-------------------------------------------------------------------------------
--Functions for Realtime Graphs
-------------------------------------------------------------------------------

--AddTimeData - Adds a data value to the realtime graph at this moment in time
function GraphFunctions:AddTimeData(value)
	if type(value) ~= "number" then
		return
	end

	local t = {}
	t.Time = GetTime()
	self.LastDataTime = t.Time
	t.Value = value
	tinsert(self.Data, t)
end

--RefreshRealtimeGraph - Refreshes the gridlines for the realtime graph
function GraphFunctions:RefreshRealtimeGraph()
	self:HideLines(self)
	self:CreateGridlines()
end

--SetFilterRadius - controls the radius of the filter
function GraphFunctions:SetFilterRadius(radius)
	self.TimeRadius = radius
end

--SetAutoscaleYAxis - If enabled the maximum y axis is adjusted to be 25% more than the max value
function GraphFunctions:SetAutoscaleYAxis(scale)
	self.AutoScale = scale
end

--SetBarColors - 
function GraphFunctions:SetBarColors(BotColor, TopColor)
	local Temp
	if BotColor.r then
		Temp = BotColor
		BotColor = {Temp.r, Temp.g, Temp.b, Temp.a}
	end
	if TopColor.r then
		Temp = TopColor
		TopColor = {Temp.r, Temp.g, Temp.b, Temp.a}
	end
	for i = 1, self.BarNum do
		local t = self.Bars[i]:GetStatusBarTexture()
		t:SetGradientAlpha("VERTICAL", BotColor[1], BotColor[2], BotColor[3], BotColor[4], TopColor[1], TopColor[2], TopColor[3], TopColor[4])
	end
end

function GraphFunctions:SetMode(mode)
	self.Mode = mode

	if mode ~= "SLOW" then
		self.LastShift = GetTime() + self.XMin
	end
end

function GraphFunctions:RealtimeSetColors(BotColor, TopColor)
	local Temp
	if BotColor.r then
		Temp = BotColor
		BotColor = {Temp.r, Temp.g, Temp.b, Temp.a}
	end
	if TopColor.r then
		Temp = TopColor
		TopColor = {Temp.r, Temp.g, Temp.b, Temp.a}
	end
	self.BarColorBot = BotColor
	self.BarColorTop = TopColor
	for _, v in pairs(self.Bars) do
		v:GetStatusBarTexture():SetGradientAlpha("VERTICAL", self.BarColorBot[1], self.BarColorBot[2], self.BarColorBot[3], self.BarColorBot[4], self.BarColorTop[1], self.BarColorTop[2], self.BarColorTop[3], self.BarColorTop[4])
	end
end

function GraphFunctions:RealtimeSetWidth(Width)
	Width = math_floor(Width)

	if Width == self.BarNum then
		return
	end

	self.BarNum = Width
	for i = 1, Width do
		if type(self.Bars[i]) == "nil" then
			local bar
			bar = CreateFrame("StatusBar", self:GetName().."Bar"..i, self)
			bar:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", i - 1, 0)
			bar:SetHeight(self.Height)
			bar:SetWidth(1)
			bar:SetOrientation("VERTICAL")
			bar:SetMinMaxValues(0, 1)
			bar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
			bar:GetStatusBarTexture():SetHorizTile(false)
			bar:GetStatusBarTexture():SetVertTile(false)

			local t = bar:GetStatusBarTexture()
			t:SetGradientAlpha("VERTICAL", self.BarColorBot[1], self.BarColorBot[2], self.BarColorBot[3], self.BarColorBot[4], self.BarColorTop[1], self.BarColorTop[2], self.BarColorTop[3], self.BarColorTop[4])

			tinsert(self.Bars, bar)
		else
			self.Bars[i]:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", i - 1, 0)
		end
		self.BarHeight[i] = 0
	end

	local SizeOfBarsUsed = table.maxn(self.BarsUsing)

	if Width > SizeOfBarsUsed then
		for i = SizeOfBarsUsed + 1, Width do
			tinsert(self.BarsUsing, self.Bars[i])
			self.Bars[i]:Show()
		end
	elseif Width < SizeOfBarsUsed then
		for i = Width + 1, SizeOfBarsUsed do
			tremove(self.BarsUsing, Width + 1)
			self.Bars[i]:Hide()
		end
	end

	self.BarWidth = (self.XMax - self.XMin) / self.BarNum
	self.Decay = math_pow(self.DecaySet, self.BarWidth)
	self.ExpNorm = 1 / (1 - self.Decay) / 0.95 --Actually a finite geometric series


	self:OldSetWidth(Width)
	self:RefreshGraph()
end

function GraphFunctions:RealtimeSetHeight(Height)
	self.Height = Height

	for i = 1, self.BarNum do
		--self.Bars[i]:Hide()
		self.Bars[i]:SetValue(0)
		self.Bars[i]:SetHeight(self.Height)
	end

	self:OldSetHeight(Height)
	self:RefreshGraph()
end

function GraphFunctions:GetMaxValue()
	--Is there any data that could possibly be not zero?
	if self.LastDataTime < (self.LastShift + self.XMin - self.TimeRadius) then
		return 0
	end

	local MaxY = 0

	for i = 1, self.BarNum do
		MaxY = math_max(MaxY, self.BarHeight[i])
	end

	return MaxY
end



function GraphFunctions:RealtimeGetValue(Time)
	local Bar
	if Time < self.XMin or Time > self.XMax then
		return 0
	end

	Bar = math_min(math_max(math_floor(self.BarNum * (Time - self.XMin) / (self.XMax - self.XMin) + 0.5), 1), self.BarNum)

	return self.BarHeight[Bar]
end

function GraphFunctions:SetUpdateLimit(Time)
	self.LimitUpdates = Time
end

function GraphFunctions:SetDecay(decay) 
	self.DecaySet = decay
	self.Decay = math_pow(self.DecaySet, self.BarWidth)
	self.ExpNorm = 1 / (1 - self.Decay) / 0.95 --Actually a finite geometric series (divide 0.96 instead of 1 since seems doesn't quite work right)
end

function GraphFunctions:AddBar(value)
	for i = 1, self.BarNum - 1 do
		self.BarHeight[i] = self.BarHeight[i + 1]
	end
	self.BarHeight[self.BarNum] = value
	self.AddedBar = true
end

function GraphFunctions:SetBars()
	local YHeight = self.YMax - self.YMin

	for i, bar in pairs(self.BarsUsing) do
		local h
		h = (self.BarHeight[i] - self.YMin) / YHeight

		bar:SetValue(h)
	end
end


-------------------------------------------------------------------------------
--Functions for Line Graph Data
-------------------------------------------------------------------------------

function GraphFunctions:AddDataSeries(points, color, n2, linetexture)
	local data
	--Make sure there is data points
	if not points then
		return
	end

	data = points
	if n2 == nil then
		n2 = false
	end
	if n2 or (table.getn(points) == 2 and table.getn(points[1]) ~= 2) then
		data = {}
		for k, v in ipairs(points[1]) do
			tinsert(data, {v, points[2][k]})
		end
	end

	if linetexture then
		if not linetexture:find ("\\") and not linetexture:find ("//") then 
			linetexture = TextureDirectory..linetexture
		end
	end
	
	tinsert(self.Data,{Points = data; Color = color; LineTexture=linetexture})

	self.NeedsUpdate = true
end

function GraphFunctions:AddFilledDataSeries(points, color, n2)
	local data
	--Make sure there is data points
	if not points or #points == 0 then
		return
	end

	data = points
	if n2 == nil then
		n2 = false
	end

	if n2 or (table.getn(points) == 2 and table.getn(points[1]) ~= 2) then
		data = {}
		for k, v in ipairs(points[1]) do
			tinsert(data, {v, points[2][k]})
		end
	end

	tinsert(self.FilledData, {Points = data; Color = color})

	self.NeedsUpdate = true
end


function GraphFunctions:ResetData()
	self.Data = {}

	if self.FilledData then
		self.FilledData = {}
	end

	self.NeedsUpdate = true
end

function GraphFunctions:SetLinearFit(fit)
	self.LinearFit = fit

	self.NeedsUpdate = true
end



function GraphFunctions:HideTextures()
	local k = #self.TexturesUsed
	while k > 0 do
		self.Textures[#self.Textures + 1] = self.TexturesUsed[k]
		self.TexturesUsed[k]:Hide()
		self.TexturesUsed[k] = nil
		k = k - 1
	end
end

--Make sure to show a texture after you grab it or its free for anyone else to grab
function GraphFunctions:FindTexture()
	local t
	if #self.Textures > 0 then
		t = self.Textures[#self.Textures]
		self.TexturesUsed[#self.TexturesUsed + 1] = t
		self.Textures[#self.Textures] = nil
		return t
	end
	local g = self:CreateTexture(nil, "BACKGROUND")
	self.TexturesUsed[#self.TexturesUsed + 1] = g
	return g
end

function GraphFunctions:HideFontStrings()
	if not self.FontStrings then
		self.FontStrings = {}
	end
	for k, t in pairs(self.FontStrings) do
		t:Hide()
	end
end

--Make sure to show a fontstring after you grab it or its free for anyone else to grab
function GraphFunctions:FindFontString()
	for k, t in pairs(self.FontStrings) do
		if not t:IsShown() then
			return t
		end
	end
	local g

	if self.TextFrame then
		g = self.TextFrame:CreateFontString(nil, "OVERLAY")
	else
		g = self:CreateFontString(nil, "OVERLAY")
	end
	tinsert(self.FontStrings, g)
	return g
end

--Linear Regression via Least Squares
function GraphFunctions:LinearRegression(data)
	local alpha, beta
	local n, SX, SY, SXX, SXY = 0, 0, 0, 0, 0

	for k, v in pairs(data) do
		n = n + 1

		SX = SX + v[1]
		SXX = SXX + v[1] * v[1]
		SY = SY + v[2]
		SXY = SXY + v[1] * v[2]
	end

	beta = (n * SXY - SX * SY) / (n * SXX - SX * SX)
	alpha = (SY - beta * SX) / n

	return alpha, beta
end


-------------------------------------------------------------------------------
--Functions for Pie Chart
-------------------------------------------------------------------------------

local PiePieces = {
	"1-2",
	"1-4",
	"1-8",
	"1-16",
	"1-32",
	"1-64",
	"1-128"
}

--26 Colors
local ColorTable = {
	{0.9, 0.1, 0.1},
	{0.1, 0.9, 0.1},
	{0.1, 0.1, 0.9},
	{0.9, 0.9, 0.1},
	{0.9, 0.1, 0.9},
	{0.1, 0.9, 0.9},
	{0.9, 0.9, 0.9},
	{0.5, 0.1, 0.1},
	{0.1, 0.5, 0.1},
	{0.1, 0.1, 0.5},
	{0.5, 0.5, 0.1},
	{0.5, 0.1, 0.5},
	{0.1, 0.5, 0.5},
	{0.5, 0.5, 0.5},
	{0.75, 0.15, 0.15},
	{0.15, 0.75, 0.15},
	{0.15, 0.15, 0.75},
	{0.75, 0.75, 0.15},
	{0.75, 0.15, 0.75},
	{0.15, 0.75, 0.75},
	{0.9, 0.5, 0.1},
	{0.1, 0.5, 0.9},
	{0.9, 0.1, 0.5},
	{0.5, 0.9, 0.1},
	{0.5, 0.1, 0.9},
	{0.1, 0.9, 0.5},
}

function GraphFunctions:AddPie(Percent, Color)
	local PiePercent = self.PercentOn

	local CurPiece = 50
	local Angle = 180
	local CurAngle = PiePercent * 360 / 100

	self.TotalSections = self.TotalSections + 1
	if type(self.Sections[self.TotalSections]) ~= "table" then
		self.Sections[self.TotalSections] = {}
	end

	local Section = self.Sections[self.TotalSections]
	Section.Textures = {}

	if type(Color) ~= "table" then
		if self.onColor <= table.maxn(ColorTable) then
			Color = ColorTable[self.onColor]
		else
			Color = {math_random(), math_random(), math_random()}
		end
		self.onColor = self.onColor + 1
	end

	if PiePercent == 0 then
		self:DrawLinePie(0)
	end

	Percent = Percent + self.Remaining
	local LastPiece = 0
	for k, v in pairs(PiePieces) do
		if (Percent + 0.1) > CurPiece then
			local t = self:FindTexture()
			t:SetTexture(TextureDirectory..v)
			t:ClearAllPoints()
			t:SetPoint("CENTER", self, "CENTER", 0, 0)
			t:SetHeight(self:GetHeight())
			t:SetWidth(self:GetWidth())
			GraphFunctions:RotateTexture(t, CurAngle)
			t:Show()

			t:SetVertexColor(Color[1], Color[2], Color[3], 1.0)
			Percent = Percent - CurPiece
			PiePercent = PiePercent + CurPiece
			CurAngle = CurAngle + Angle

			tinsert(Section.Textures, t)

			if k == 7 then
				LastPiece = 0.09
			end
		end
		CurPiece = CurPiece / 2
		Angle = Angle / 2
	end

	--Finish adding section data
	Section.Color = Color
	Section.Angle = CurAngle

	self:DrawLinePie((PiePercent + LastPiece) * 360 / 100)
	self.PercentOn = PiePercent
	self.Remaining = Percent

	return Color
end

function GraphFunctions:CompletePie(Color)
	local Percent = 100 - self.PercentOn
	local PiePercent = self.PercentOn

	local CurPiece = 50
	local Angle = 180
	local CurAngle = PiePercent * 360 / 100

	self.TotalSections = self.TotalSections + 1
	if not self.Sections[self.TotalSections] then
		self.Sections[self.TotalSections] = {}
	end

	local Section = self.Sections[self.TotalSections]
	Section.Textures = {}

	if type(Color) ~= "table" then
		if self.onColor <= table.maxn(ColorTable) then
			Color = ColorTable[self.onColor]
		else
			Color = {math_random(), math_random(), math_random()}
		end
		self.onColor = self.onColor + 1
	end

	Percent = Percent + self.Remaining
	if PiePercent ~= 0 then
		for k, v in pairs(PiePieces) do
			if (Percent + 0.1) > CurPiece then
				local t = self:FindTexture()
				t:SetTexture(TextureDirectory..v)
				t:ClearAllPoints()
				t:SetPoint("CENTER", self, "CENTER", 0, 0)
				t:SetHeight(self:GetHeight())
				t:SetWidth(self:GetWidth())
				GraphFunctions:RotateTexture(t, CurAngle)
				t:Show()

				t:SetVertexColor(Color[1], Color[2], Color[3], 1.0)
				Percent = Percent - CurPiece
				PiePercent = PiePercent + CurPiece
				CurAngle = CurAngle + Angle

				tinsert(Section.Textures, t)
			end
			CurPiece = CurPiece / 2
			Angle = Angle / 2
		end
	else--Special case if its by itself
		local t = self:FindTexture()
		t:SetTexture(TextureDirectory.."1-1")
		t:ClearAllPoints()
		t:SetPoint("CENTER", self, "CENTER", 0, 0)
		t:SetHeight(self:GetHeight())
		t:SetWidth(self:GetWidth())
		GraphFunctions:RotateTexture(t, CurAngle)
		t:Show()

		t:SetVertexColor(Color[1], Color[2], Color[3], 1.0)
		tinsert(Section.Textures, t)
	end

	--Finish adding section data
	Section.Color = Color
	Section.Angle = 360

	self.PercentOn = PiePercent
	self.Remaining = Percent

	return Color
end

function GraphFunctions:ResetPie()
	self:HideTextures()
	self:HideLines(self)

	self.PieUsed = 0
	self.PercentOn = 0
	self.Remaining = 0
	self.onColor = 1
	self.LastSection = nil
	self.TotalSections = 0
	--self.Sections = {}
end

function GraphFunctions:DrawLinePie(angle)
	local sx, sy, ex, ey
	local Radian = math_pi * (90 - angle) / 180
	local w, h
	w = self:GetWidth() / 2
	h = self:GetHeight() / 2


	sx = w
	sy = h

	ex = sx + 0.88 * w * math_cos(Radian)
	ey = sx + 0.88 * h * math_sin(Radian)

	self:DrawLine(self, sx, sy, ex, ey, 34, {0.0, 0.0, 0.0, 1.0}, "OVERLAY")
end

--Used to rotate the pie slices
function GraphFunctions:RotateTexture(texture, angle)
	local Radian = math_pi * (45 - angle) / 180
	local Radian2 = math_pi * (45 + 90 - angle) / 180
	local Radius = 0.70710678118654752440084436210485

	local tx, ty, tx2, ty2
	tx = Radius * math_cos(Radian)
	ty = Radius * math_sin(Radian)
	tx2 = -ty
	ty2 = tx

	texture:SetTexCoord(0.5 - tx, 0.5 - ty, 0.5 + tx2, 0.5 + ty2, 0.5 - tx2, 0.5 - ty2, 0.5 + tx, 0.5 + ty)
end

function GraphFunctions:SetSelectionFunc(f)
	self.SelectionFunc = f
end

--TODO: Pie chart pieces need to be clickable
function GraphFunctions:PieChart_OnUpdate()
	if (MouseIsOver(self)) then
		local sX, sY = self:GetCenter()
		local Scale = self:GetEffectiveScale()
		local mX, mY = GetCursorPosition()
		local dX, dY

		dX = mX / Scale - sX
		dY = mY / Scale - sY

		local Angle = 90-math_deg(math_atan(dY / dX))
		dY = dY * self.Ratio
		local Dist = dX * dX + dY * dY

		if dX < 0 then
			Angle = Angle + 180
		end

		--Are we on the Pie Chart?
		if Dist < self.Radius then
			--What section are we on?
			for k = 1, self.TotalSections do
				local v = self.Sections[k]
				if Angle < v.Angle then
					local Color
					if k ~= self.LastSection then
						if self.LastSection then
							local Section = self.Sections[self.LastSection]
							for _, t in pairs(Section.Textures) do
								Color = Section.Color
								t:SetVertexColor(Color[1], Color[2], Color[3], 1.0)
							end
						end

						if self.SelectionFunc then
							self:SelectionFunc(k)
						end
					end

					local ColorAdd = 0.15 * math_abs(math_fmod(GetTime(), 3) - 1.5) - 0.1125

					Color = {}
					Color[1] = v.Color[1]+ColorAdd
					Color[2] = v.Color[2]+ColorAdd
					Color[3] = v.Color[3]+ColorAdd

					for _, t in pairs(v.Textures) do
						t:SetVertexColor(Color[1], Color[2], Color[3], 1.0)
					end

					self.LastSection = k

					return
				end
			end
		elseif self.LastSection then
			local Section = self.Sections[self.LastSection]
			for _, t in pairs(Section.Textures) do
				local Color = Section.Color
				t:SetVertexColor(Color[1], Color[2], Color[3], 1.0)
			end
			self.LastSection = nil
			if self.SelectionFunc then
				self:SelectionFunc(nil)
			end
		end
	else
		if self.LastSection then
			local Section = self.Sections[self.LastSection]
			for _, t in pairs(Section.Textures) do
				local Color = Section.Color
				t:SetVertexColor(Color[1], Color[2], Color[3], 1.0)
			end
			self.LastSection = nil
			if self.SelectionFunc then
				self:SelectionFunc(nil)
			end
		end
	end
end


-------------------------------------------------------------------------------
--Axis Setting Functions
-------------------------------------------------------------------------------

function GraphFunctions:SetYMax(ymax)
	if ymax == self.YMax then
		return
	end

	self.YMax = ymax

	self.NeedsUpdate = true
end

function GraphFunctions:SetYAxis(ymin, ymax)
	if self.YMin == ymin and self.YMax == ymax then
		return
	end

	self.YMin = ymin
	self.YMax = ymax

	self.NeedsUpdate = true
end

function GraphFunctions:SetMinMaxY(val)
	if self.MinMaxY == val then
		return
	end

	self.MinMaxY = val
	self.NeedsUpdate = true
end

function GraphFunctions:SetXAxis(xmin, xmax)
	if self.XMin == xmin and self.XMax == xmax then
		return
	end

	self.XMin = xmin
	self.XMax = xmax

	self.NeedsUpdate = true

	if self.GraphType == "REALTIME" then
		self.BarWidth = (xmax - xmin) / self.BarNum
		self.Decay = math_pow(self.DecaySet, self.BarWidth)
		self.FilterOverlap = math_max(math_ceil((self.TimeRadius + xmax) / self.BarWidth), 0)
		self.LastShift = GetTime() + xmin
	end
end

function GraphFunctions:SetAutoScale(auto)
	self.AutoScale = auto

	self.NeedsUpdate = true
end

--The various Lock Functions let you use Autoscale but holds the locked points in place
function GraphFunctions:LockXMin(state)
	if state == nil then
		self.LockOnXMin = not self.LockOnXMin
		return
	end
	self.LockOnXMin = state
end

function GraphFunctions:LockXMax(state)
	if state == nil then
		self.LockOnXMax = not self.LockOnXMax
		return
	end
	self.LockOnXMax = state
end

function GraphFunctions:LockYMin(state)
	if state == nil then
		self.LockOnYMin = not self.LockOnYMin
		return
	end
	self.LockOnYMin = state
end

function GraphFunctions:LockYMax(state)
	if state == nil then
		self.LockOnYMax = not self.LockOnYMax
		return
	end
	self.LockOnYMax = state
end


-------------------------------------------------------------------------------
--Grid & Axis Drawing Functions 
-------------------------------------------------------------------------------

function GraphFunctions:SetAxisDrawing(xaxis, yaxis)
	if xaxis == self.XAxisDrawn and self.YAxisDrawn == yaxis then
		return
	end

	self.XAxisDrawn = xaxis
	self.YAxisDrawn = yaxis

	self.NeedsUpdate = true
end

function GraphFunctions:SetGridSpacing(xspacing, yspacing)
	if xspacing == self.XGridInterval and self.YGridInterval == yspacing then
		return
	end

	self.XGridInterval = xspacing
	self.YGridInterval = yspacing

	self.NeedsUpdate = true
end

function GraphFunctions:SetAxisColor(color)
	if self.AxisColor[1] == color[1] and self.AxisColor[2] == color[2] and self.AxisColor[3] == color[3] and self.AxisColor[4] == color[4] then
		return
	end

	self.AxisColor = color

	self.NeedsUpdate = true
end

function GraphFunctions:SetGridColor(color)
	if self.GridColor[1] == color[1] and self.GridColor[2] == color[2] and self.GridColor[3] == color[3] and self.GridColor[4] == color[4] then
		return
	end

	self.GridColor = color

	self.NeedsUpdate = true
end

function GraphFunctions:SetGridColorSecondary(color)
	if self.GridColorSecondary ~= nil and self.GridColorSecondary[1] == color[1] and self.GridColorSecondary[2] == color[2] and self.GridColorSecondary[3] == color[3] and self.GridColorSecondary[4] == color[4] then
		return
	end

	self.GridColorSecondary = color

	self.NeedsUpdate = true
end

function GraphFunctions:SetGridSecondaryMultiple(XAxis, YAxis)
	if type(XAxis) ~= "number" then
		XAxis = 1
	end
	if type(YAxis) ~= "number" then
		YAxis = 1
	end
	self.GridSecondaryX = XAxis
	self.GridSecondaryY = YAxis

	self.NeedsUpdate = true
end

function GraphFunctions:SetYLabels(Left, Right)
	self.YLabelsLeft = Left
	self.YLabelsRight = Right
end

function GraphFunctions:SetLineTexture(texture)
	if (type (texture) ~= "string") then
		return assert (false, "Parameter 1 for SetLineTexture must be a string")
	end

	--> full path
	if (texture:find ("\\") or texture:find ("//")) then 
		self.CustomLine = texture
	--> using an image inside lib-graph folder
	else 
		self.CustomLine = TextureDirectory..texture
	end
end

function GraphFunctions:SetBorderSize(border, size)
	border = string.lower (border)
	
	if (type (size) ~= "number") then
		return assert (false, "Parameter 2 for SetBorderSize must be a number")
	end
	
	if (border == "left") then
		self.CustomLeftBorder = size
		return true
	elseif (border == "right") then
		self.CustomRightBorder = size
		return true
	elseif (border == "top") then
		self.CustomTopBorder = size
		return true
	elseif (border == "bottom") then
		self.CustomBottomBorder = size
		return true
	end
	
	return assert (false, "Usage: GraphObject:SetBorderSize (LEFT RIGHT TOP BOTTOM, SIZE)")
end

function GraphFunctions:CreateGridlines()
	local Width = self:GetWidth()
	local Height = self:GetHeight()
	local NoSecondary = (self.GridSecondaryY == nil) or (self.GridSecondaryX == nil) or (type(self.GridColorSecondary) ~= "table")
	local F
	self:HideLines(self)
	self:HideFontStrings()

	if self.YGridInterval then
		local LowerYGridLine, UpperYGridLine, TopSpace
		LowerYGridLine = self.YMin / self.YGridInterval
		LowerYGridLine = math_max(math_floor(LowerYGridLine), math_ceil(LowerYGridLine))
		UpperYGridLine = self.YMax / self.YGridInterval
		UpperYGridLine = math_min(math_floor(UpperYGridLine), math_ceil(UpperYGridLine))
		--UpperYGridLine = math_min(UpperYGridLine, self.YGridMax or 16)
		TopSpace = Height * (1 - (UpperYGridLine * self.YGridInterval - self.YMin) / (self.YMax - self.YMin))

		for i = LowerYGridLine, UpperYGridLine do
			if i ~= 0 or not self.YAxisDrawn then
				local YPos, T
				YPos = Height * (i * self.YGridInterval - self.YMin) / (self.YMax - self.YMin)
				if NoSecondary or math_fmod(i, self.GridSecondaryY) == 0 then
					T = self:DrawLine(self, 0, YPos, Width, YPos, 24, self.GridColor, "BACKGROUND")
				else
					T = self:DrawLine(self, 0, YPos, Width, YPos, 24, self.GridColorSecondary, "BACKGROUND")
				end

				if ((i ~= UpperYGridLine) or (TopSpace > 12)) and (NoSecondary or math_fmod(i, self.GridSecondaryY) == 0) then
					if self.YLabelsLeft then
						F = self:FindFontString()
						F:SetFontObject("GameFontHighlightSmall")
						F:SetTextColor(1, 1, 1)
						F:ClearAllPoints()
						F:SetPoint("BOTTOMLEFT", T, "LEFT", 2, 2)
						F:SetText(i * self.YGridInterval)
						F:Show()
					end

					if self.YLabelsRight then
						F = self:FindFontString()
						F:SetFontObject("GameFontHighlightSmall")
						F:SetTextColor(1, 1, 1)
						F:ClearAllPoints()
						F:SetPoint("BOTTOMRIGHT", T, "RIGHT", -2, 2)
						F:SetText(i * self.YGridInterval)
						F:Show()
					end
				end
			end
		end
	end

	if self.XGridInterval then
		local LowerXGridLine, UpperXGridLine
		LowerXGridLine = self.XMin / self.XGridInterval
		LowerXGridLine = math_max(math_floor(LowerXGridLine), math_ceil(LowerXGridLine))
		UpperXGridLine = self.XMax / self.XGridInterval
		UpperXGridLine = math_min(math_floor(UpperXGridLine), math_ceil(UpperXGridLine))
		--UpperXGridLine = math_min(UpperXGridLine, self.XGridMax or 16)

		for i = LowerXGridLine, UpperXGridLine do
			if i ~= 0 or not self.XAxisDrawn then
				local XPos
				XPos = Width * (i * self.XGridInterval - self.XMin) / (self.XMax - self.XMin)
				if NoSecondary or math_fmod(i, self.GridSecondaryX) == 0 then
					self:DrawLine(self, XPos, 0, XPos, Height, 24, self.GridColor, "BACKGROUND")
				else
					self:DrawLine(self, XPos, 0, XPos, Height, 24, self.GridColorSecondary, "BACKGROUND")
				end
			end
		end
	end

	if self.YAxisDrawn and self.YMax >= 0 and self.YMin <= 0 then
		local YPos, T

		YPos = Height * (-self.YMin) / (self.YMax - self.YMin)
		T = self:DrawLine(self, 0, YPos, Width, YPos, 24, self.AxisColor, "BACKGROUND")

		if self.YLabelsLeft then
			F = self:FindFontString()
			F:SetFontObject("GameFontHighlightSmall")
			F:SetTextColor(1, 1, 1)
			F:ClearAllPoints()
			F:SetPoint("BOTTOMLEFT", T, "LEFT", 2, 2)
			F:SetText(0)
			F:Show()
		end
		if self.YLabelsRight then
			F = self:FindFontString()
			F:SetFontObject("GameFontHighlightSmall")
			F:SetTextColor(1, 1, 1)
			F:ClearAllPoints()
			F:SetPoint("BOTTOMRIGHT", T, "RIGHT", -2, 2)
			F:SetText(0)
			F:Show()
		end
	end

	if self.XAxisDrawn and self.XMax >= 0 and self.XMin <= 0 then
		local XPos

		XPos = Width * (-self.XMin) / (self.XMax - self.XMin)
		self:DrawLine(self, XPos, 0, XPos, Height, 24, self.AxisColor, "BACKGROUND")
	end
end


--------------------------------------------------------------------------------
--Refresh functions
--------------------------------------------------------------------------------

function GraphFunctions:OnUpdateGraph()
	if self.NeedsUpdate and self.RefreshGraph then
		self:RefreshGraph()
		self.NeedsUpdate = false
	end
end

--Performs a convolution in realtime allowing to graph Framerate, DPS, or any other data you want graphed in realtime
function GraphFunctions:OnUpdateGraphRealtime()
	local CurTime = GetTime()
	local BarsChanged

	if self.NextUpdate > CurTime or (self.Mode == "RAW" and not (self.NeedsUpdate or self.AddedBar)) then
		return
	end

	self.NextUpdate = CurTime + self.LimitUpdates

	--Slow Mode performs an entire convolution every frame
	if self.Mode == "SLOW" then
		--Initialize Bar Data
		self.BarHeight = {}
		for i = 1, self.BarNum do
			self.BarHeight[i] = 0
		end
		local k, v
		local BarTimeRadius = (self.XMax - self.XMin) / self.BarNum
		local DataValue = 1 / (2 * self.TimeRadius)

		if self.Filter == "RECT" then
			--Take the convolution of the dataset on to the bars wtih a rectangular filter
			local DataValue = 1 / (2 * self.TimeRadius)
			for k, v in pairs(self.Data) do
				if v.Time < (CurTime + self.XMin - self.TimeRadius) then
					tremove(self.Data, k)
				else
					local DataTime = v.Time - CurTime
					local LowestBar = math_max(math_floor((DataTime - self.XMin - self.TimeRadius) / BarTimeRadius), 1)
					local HighestBar = math_min(math_ceil((DataTime - self.XMin + self.TimeRadius) / BarTimeRadius), self.BarNum)
					for i = LowestBar, HighestBar do
						self.BarHeight[i] = self.BarHeight[i] + v.Value * DataValue
					end
				end
			end
		elseif self.Filter == "TRI" then
			--Needs optimization badly
			--Take the convolution of the dataset on to the bars wtih a triangular filter
			local DataValue = 1 / (self.TimeRadius)
			for k, v in pairs(self.Data) do
				local Temp
				if v.Time < (CurTime + self.XMin - self.TimeRadius) then
					tremove(self.Data, k)
				else
					local DataTime = v.Time - CurTime
					local LowestBar = math_max(math_floor((DataTime - self.XMin - self.TimeRadius) / BarTimeRadius), 1)
					local HighestBar = math_min(math_ceil((DataTime - self.XMin + self.TimeRadius) / BarTimeRadius), self.BarNum)

					for i = LowestBar, HighestBar do
						self.BarHeight[i] = self.BarHeight[i] + v.Value * DataValue * math_abs(BarTimeRadius * i + self.XMin - DataTime)
					end
				end
			end
		end
		BarsChanged = true
	elseif self.Mode == "FAST" then
		local ShiftBars = math_floor((CurTime - self.LastShift) / self.BarWidth)

		if ShiftBars > 0 and not (self.LastDataTime < (self.LastShift + self.XMin - self.TimeRadius * 2)) then
			local RecalcBars = self.BarNum - (ShiftBars + self.FilterOverlap) + 1

			for i = 1, self.BarNum do
				if i < RecalcBars then
					self.BarHeight[i] = self.BarHeight[i + ShiftBars]
				else
					self.BarHeight[i] = 0
				end
			end

			local BarTimeRadius = (self.XMax - self.XMin) / self.BarNum
			local DataValue = 1 / (2 * self.TimeRadius)
			local TimeDiff = CurTime-self.LastShift

			CurTime = self.LastShift + ShiftBars * self.BarWidth
			self.LastShift = CurTime

			if self.Filter == "RECT" then
				--Take the convolution of the dataset on to the bars wtih a rectangular filter
				local DataValue = 1 / (2 * self.TimeRadius)
				for k, v in pairs(self.Data) do
					if v.Time < (CurTime + self.XMax - self.TimeRadius - TimeDiff) then
						tremove(self.Data, k)
					else
						local DataTime = v.Time - CurTime
						local LowestBar = math_max(math_max(math_floor((DataTime - self.XMin - self.TimeRadius) / BarTimeRadius), RecalcBars), 1)
						local HighestBar = math_min(math_ceil((DataTime - self.XMin + self.TimeRadius) / BarTimeRadius), self.BarNum)
						if LowestBar <= HighestBar then
							for i = LowestBar, HighestBar do
								self.BarHeight[i] = self.BarHeight[i] + v.Value * DataValue
							end
						end
					end
				end
			end
			BarsChanged = true
		else
			CurTime = self.LastShift + ShiftBars * self.BarWidth
			self.LastShift = CurTime
		end
	elseif self.Mode == "EXP" then
		local ShiftBars = math_floor((CurTime - self.LastShift) / self.BarWidth)

		if ShiftBars > 0 then
			local RecalcBars = self.BarNum - ShiftBars + 1

			for i = 1, self.BarNum do
				if i < RecalcBars then
					self.BarHeight[i] = self.BarHeight[i + ShiftBars]
				end
			end

			--Now to calculate the new bars
			local Total
			local Weight = 1 / self.TimeRadius / self.ExpNorm

			for i = RecalcBars, self.BarNum do
				Total = 0

				--Implement an EXPFAST which does this only once instead of for each bar
				for k, v in pairs(self.Data) do
					Total = Total + v.Value * Weight
					if v.Time < (self.LastShift - self.TimeRadius) then
						tremove(self.Data, k)
					end
				end

				self.CurVal = self.Decay * self.CurVal + Total

				self.BarHeight[i] = self.CurVal

				self.LastShift = self.LastShift + self.BarWidth
			end

			if self.CurVal < 0.1 then
				self.CurVal = 0
			end
			BarsChanged = true
		else
			self.LastShift = self.LastShift + self.BarWidth * ShiftBars
		end
	elseif self.Mode == "EXPFAST" then
		local ShiftBars = math_floor((CurTime - self.LastShift) / self.BarWidth)
		local RecalcBars = self.BarNum - ShiftBars + 1

		if ShiftBars > 0 and not (self.LastDataTime < (self.LastShift + self.XMin-self.TimeRadius)) then
			for i = 1, self.BarNum do
				if i < RecalcBars then
					self.BarHeight[i] = self.BarHeight[i + ShiftBars]
				end
			end

			--Now to calculate the new bars
			local Total
			local Weight = 1 / self.TimeRadius / self.ExpNorm

			Total = 0

			--Implement an EXPFAST which does this only once instead of for each bar
			for k, v in pairs(self.Data) do
				Total = Total + v.Value * Weight
				if v.Time < (self.LastShift - self.TimeRadius) then
					tremove(self.Data, k)
				end
			end

			--self.LastShift = self.LastShift+self.BarWidth*ShiftBars

			if self.CurVal ~= 0 or Total ~= 0 then
				for i = RecalcBars, self.BarNum do
					self.CurVal = self.Decay * self.CurVal + Total
					self.BarHeight[i] = self.CurVal
				end
				self.LastDataTime = self.LastShift + self.BarWidth * ShiftBars
			else
				for i = RecalcBars, self.BarNum do
					self.BarHeight[i] = 0
				end
			end

			if self.CurVal < 0.1 then
				self.CurVal = 0
			end
			BarsChanged = true
		end
		self.LastShift = self.LastShift + self.BarWidth * ShiftBars
	elseif self.Mode == "RAW" then
		--Do nothing really
		--Using .AddedBar so we cut down on updating the grid
		self.AddedBar = false
		BarsChanged = true
	end


	if BarsChanged then
		if self.AutoScale then
			local MaxY = 0

			for i = 1, self.BarNum do
				MaxY = math_max(MaxY, self.BarHeight[i])
			end
			MaxY = 1.25 * MaxY

			MaxY = math_max(MaxY, self.MinMaxY)

			if MaxY ~= 0 and math_abs(self.YMax - MaxY) > 0.01 then
				self.YMax = MaxY
				self.NeedsUpdate = true

				local Spacing
				if self.YMax < 25 then
					Spacing = -1
				else
					Spacing = math.log(self.YMax / 100) / math.log(2)
				end

				self.YGridInterval = 25 * math.pow(2, math.floor(Spacing))
			end
		end
		self:SetBars()
	end

	if self.NeedsUpdate then
		self.NeedsUpdate = false
		self:RefreshGraph()
	end
end

--Line Graph
function GraphFunctions:RefreshLineGraph()
	self:HideLines(self)
	self:HideBars(self)

	if self.AutoScale and self.Data then
		local MinX, MaxX, MinY, MaxY = math_huge, -math_huge, math_huge, -math_huge
		--Go through line data first
		for k1, series in pairs(self.Data) do
			for k2, point in pairs(series.Points) do
				MinX = math_min(point[1], MinX)
				MaxX = math_max(point[1], MaxX)
				MinY = math_min(point[2], MinY)
				MaxY = math_max(point[2], MaxY)
			end
		end

		--Now through the Filled Lines
		for k1, series in pairs(self.FilledData) do
			for k2, point in pairs(series.Points) do
				MinX = math_min(point[1], MinX)
				MaxX = math_max(point[1], MaxX)
				MinY = math_min(point[2], MinY)
				MaxY = math_max(point[2], MaxY)
			end
		end

		local XBorder, YBorder

		XBorder = 0.1 * (MaxX - MinX)
		YBorder = 0.1 * (MaxY - MinY)

		if not self.LockOnXMin then
			if (self.CustomLeftBorder) then
				self.XMin = MinX + self.CustomLeftBorder --> custom size of left border
			else
				self.XMin = MinX - XBorder
			end
		end
		
		if not self.LockOnXMax then
			if (self.CustomRightBorder) then
				self.XMax = MaxX + self.CustomRightBorder --> custom size of right border
			else
				self.XMax = MaxX + XBorder
			end
		end
		
		if not self.LockOnYMin then
			if (self.CustomBottomBorder) then
				self.YMin = MinY + self.CustomBottomBorder --> custom size of bottom border
			else
				self.YMin = MinY - YBorder
			end
		end
		
		if not self.LockOnYMax then
			if (self.CustomTopBorder) then
				self.YMax = MaxY + self.CustomTopBorder --> custom size of top border
			else
				self.YMax = MaxY + YBorder
			end
		end

	end

	self:CreateGridlines()

	local Width = self:GetWidth()
	local Height = self:GetHeight()

	for k1, series in pairs(self.Data) do
		local LastPoint
		LastPoint = nil
		
		for k2, point in pairs(series.Points) do
			if LastPoint then
				local TPoint = {x = point[1]; y = point[2]}

				TPoint.x = Width * (TPoint.x - self.XMin) / (self.XMax - self.XMin)
				TPoint.y = Height * (TPoint.y - self.YMin) / (self.YMax - self.YMin)

				--tercioo: send the data index to DrawLine so custom draw functions know what they are drawing
				self:DrawLine(self, LastPoint.x, LastPoint.y, TPoint.x, TPoint.y, 32, series.Color, nil, series.LineTexture, k1)

				LastPoint = TPoint
			else
				LastPoint = {x = point[1]; y = point[2]}
				LastPoint.x = Width * (LastPoint.x - self.XMin) / (self.XMax - self.XMin)
				LastPoint.y = Height * (LastPoint.y - self.YMin) / (self.YMax - self.YMin)
			end
		end
	end

	--Filled Line Graphs
	for k1, series in pairs(self.FilledData) do
		local LastPoint
		LastPoint = nil

		for k2, point in pairs(series.Points) do
			if LastPoint then
				local TPoint = {x = point[1]; y = point[2]}

				TPoint.x = Width * (TPoint.x - self.XMin) / (self.XMax - self.XMin)
				TPoint.y = Height * (TPoint.y - self.YMin ) /(self.YMax - self.YMin)

				self:DrawBar(self, LastPoint.x, LastPoint.y, TPoint.x, TPoint.y, series.Color, k1)

				LastPoint = TPoint
			else
				LastPoint = {x = point[1]; y = point[2]}
				LastPoint.x = Width * (LastPoint.x - self.XMin) / (self.XMax - self.XMin)
				LastPoint.y = Height * (LastPoint.y - self.YMin) / (self.YMax - self.YMin)
			end
		end
	end
end

--Scatter Plot Refresh
function GraphFunctions:RefreshScatterPlot()
	self:HideLines(self)

	if self.AutoScale and self.Data then
		local MinX, MaxX, MinY, MaxY = math_huge, -math_huge, math_huge, -math_huge
		for k1, series in pairs(self.Data) do
			for k2, point in pairs(series.Points) do
				MinX = math_min(point[1], MinX)
				MaxX = math_max(point[1], MaxX)
				MinY = math_min(point[2], MinY)
				MaxY = math_max(point[2], MaxY)
			end
		end

		local XBorder, YBorder

		XBorder = 0.1 * (MaxX - MinX)
		YBorder = 0.1 * (MaxY - MinY)

		if not self.LockOnXMin then
			self.XMin = MinX - XBorder
		end
		if not self.LockOnXMax then
			self.XMax = MaxX + XBorder
		end
		if not self.LockOnYMin then
			self.YMin = MinY - YBorder
		end
		if not self.LockOnYMax then
			self.YMax = MaxY + YBorder
		end
	end

	self:CreateGridlines()

	local Width = self:GetWidth()
	local Height = self:GetHeight()

	self:HideTextures()
	for k1, series in pairs(self.Data) do
		local MinX, MaxX = self.XMax, self.XMin
		for k2, point in pairs(series.Points) do
			local x, y
			MinX = math_min(point[1],MinX)
			MaxX = math_max(point[1],MaxX)
			x = Width * (point[1] - self.XMin) / (self.XMax - self.XMin)
			y = Height * (point[2] - self.YMin) / (self.YMax - self.YMin)

			local g = self:FindTexture()
			g:SetTexture("Spells\\GENERICGLOW2_64")
			g:SetWidth(6)
			g:SetHeight(6)
			g:ClearAllPoints()
			g:SetPoint("CENTER", self, "BOTTOMLEFT", x, y)
			g:SetVertexColor(series.Color[1], series.Color[2], series.Color[3], series.Color[4])
			g:Show()
		end

		if self.LinearFit then
			local alpha, beta = self:LinearRegression(series.Points)
			local sx, sy, ex, ey

			sx = MinX
			sy = beta * sx + alpha
			ex = MaxX
			ey = beta*ex+alpha

			sx = Width * (sx - self.XMin) / (self.XMax - self.XMin)
			sy = Height * (sy - self.YMin) / (self.YMax - self.YMin)
			ex = Width * (ex - self.XMin) / (self.XMax - self.XMin)
			ey = Height * (ey - self.YMin) / (self.YMax - self.YMin)

			self:DrawLine(self, sx, sy, ex, ey, 32, series.Color)
		end
	end
end

--Copied from Blizzard's TaxiFrame code and modifed for IMBA then remodified for GraphLib

-- The following function is used with permission from Daniel Stephens <iriel@vigilance-committee.org>
local TAXIROUTE_LINEFACTOR = 128 / 126 -- Multiplying factor for texture coordinates
local TAXIROUTE_LINEFACTOR_2 = TAXIROUTE_LINEFACTOR / 2 -- Half of that

-- T		- Texture
-- C		- Canvas Frame (for anchoring)
-- sx, sy	- Coordinate of start of line
-- ex, ey	- Coordinate of end of line
-- w		- Width of line
-- relPoint	- Relative point on canvas to interpret coords (Default BOTTOMLEFT)
function lib:DrawLine(C, sx, sy, ex, ey, w, color, layer, linetexture)
	local relPoint = "BOTTOMLEFT"

	if sx == ex then
		if sy == ey then
			return
		else
			return self:DrawVLine(C, sx, sy, ey, w, color, layer)
		end
	elseif sy == ey then
		return self:DrawHLine(C, sx, ex, sy, w, color, layer)
	end

	if not C.GraphLib_Lines then
		C.GraphLib_Lines = {}
		C.GraphLib_Lines_Used = {}
	end

	local T = tremove(C.GraphLib_Lines) or C:CreateTexture(nil, "ARTWORK")
	
	if linetexture then --> this data series texture
		T:SetTexture(linetexture)
	elseif C.CustomLine then --> overall chart texture
		T:SetTexture(C.CustomLine)
	else --> no texture assigned, use default
		T:SetTexture(TextureDirectory.."line")
	end
	
	tinsert(C.GraphLib_Lines_Used, T)

	T:SetDrawLayer(layer or "ARTWORK")

	T:SetVertexColor(color[1], color[2], color[3], color[4])
	-- Determine dimensions and center point of line
	local dx, dy = ex - sx, ey - sy
	local cx, cy = (sx + ex) / 2, (sy + ey) / 2

	-- Normalize direction if necessary
	if (dx < 0) then
		dx, dy = -dx, -dy
	end

	-- Calculate actual length of line
	local l = sqrt((dx * dx) + (dy * dy))

	-- Sin and Cosine of rotation, and combination (for later)
	local s, c = -dy / l, dx / l
	local sc = s * c

	-- Calculate bounding box size and texture coordinates
	local Bwid, Bhgt, BLx, BLy, TLx, TLy, TRx, TRy, BRx, BRy
	if (dy >= 0) then
		Bwid = ((l * c) - (w * s)) * TAXIROUTE_LINEFACTOR_2
		Bhgt = ((w * c) - (l * s)) * TAXIROUTE_LINEFACTOR_2
		BLx, BLy, BRy = (w / l) * sc, s * s, (l / w) * sc
		BRx, TLx, TLy, TRx = 1 - BLy, BLy, 1 - BRy, 1 - BLx
		TRy = BRx
	else
		Bwid = ((l * c) + (w * s)) * TAXIROUTE_LINEFACTOR_2
		Bhgt = ((w * c) + (l * s)) * TAXIROUTE_LINEFACTOR_2
		BLx, BLy, BRx = s * s, -(l / w) * sc, 1 + (w / l) * sc
		BRy, TLx, TLy, TRy = BLx, 1 - BRx, 1 - BLx, 1 - BLy
		TRx = TLy
	end

	-- Thanks Blizzard for adding (-)10000 as a hard-cap and throwing errors!
	-- The cap was added in 3.1.0 and I think it was upped in 3.1.1
	-- (way less chance to get the error)
	if TLx > 10000 then TLx = 10000 elseif TLx < -10000 then TLx = -10000 end
	if TLy > 10000 then TLy = 10000 elseif TLy < -10000 then TLy = -10000 end
	if BLx > 10000 then BLx = 10000 elseif BLx < -10000 then BLx = -10000 end
	if BLy > 10000 then BLy = 10000 elseif BLy < -10000 then BLy = -10000 end
	if TRx > 10000 then TRx = 10000 elseif TRx < -10000 then TRx = -10000 end
	if TRy > 10000 then TRy = 10000 elseif TRy < -10000 then TRy = -10000 end
	if BRx > 10000 then BRx = 10000 elseif BRx < -10000 then BRx = -10000 end
	if BRy > 10000 then BRy = 10000 elseif BRy < -10000 then BRy = -10000 end

	-- Set texture coordinates and anchors
	T:ClearAllPoints()
	T:SetTexCoord(TLx, TLy, BLx, BLy, TRx, TRy, BRx, BRy)
	T:SetPoint("BOTTOMLEFT", C, relPoint, cx - Bwid, cy - Bhgt)
	T:SetPoint("TOPRIGHT", C, relPoint, cx + Bwid, cy + Bhgt)
	T:Show()
	return T
end

--Thanks to Celandro
function lib:DrawVLine(C, x, sy, ey, w, color, layer)
	local relPoint = "BOTTOMLEFT"

	if not C.GraphLib_Lines then
		C.GraphLib_Lines = {}
		C.GraphLib_Lines_Used = {}
	end

	local T = tremove(C.GraphLib_Lines) or C:CreateTexture(nil, "ARTWORK")
	T:SetTexture(TextureDirectory.."sline")
	tinsert(C.GraphLib_Lines_Used, T)

	T:SetDrawLayer(layer or "ARTWORK")

	T:SetVertexColor(color[1], color[2], color[3], color[4])

	if sy > ey then
		sy, ey = ey, sy
	end

	-- Set texture coordinates and anchors
	T:ClearAllPoints()
	T:SetTexCoord(1, 0, 0, 0, 1, 1, 0, 1)
	T:SetPoint("BOTTOMLEFT", C, relPoint, x - w / 2, sy)
	T:SetPoint("TOPRIGHT", C, relPoint, x + w / 2, ey)
	T:Show()
	return T
end

function lib:DrawHLine(C, sx, ex, y, w, color, layer)
	local relPoint = "BOTTOMLEFT"

	if not C.GraphLib_Lines then
		C.GraphLib_Lines = {}
		C.GraphLib_Lines_Used = {}
	end

	local T = tremove(C.GraphLib_Lines) or C:CreateTexture(nil, "ARTWORK")
	T:SetTexture(TextureDirectory.."sline")
	tinsert(C.GraphLib_Lines_Used, T)

	T:SetDrawLayer(layer or "ARTWORK")

	T:SetVertexColor(color[1], color[2], color[3], color[4])

	if sx > ex then
		sx, ex = ex, sx
	end

	-- Set texture coordinates and anchors
	T:ClearAllPoints()
	T:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
	T:SetPoint("BOTTOMLEFT", C, relPoint, sx, y - w / 2)
	T:SetPoint("TOPRIGHT", C, relPoint, ex, y + w / 2)
	T:Show()
	return T
end

function lib:HideLines(C)
	if C.GraphLib_Lines then
		for i = #C.GraphLib_Lines_Used, 1, -1 do
			C.GraphLib_Lines_Used[i]:Hide()
			tinsert(C.GraphLib_Lines, tremove(C.GraphLib_Lines_Used))
		end
	end
end

--Two parts to each bar
function lib:DrawBar(C, sx, sy, ex, ey, color, level)
	local Bar, Tri, barNum, MinY, MaxY

	--Want sx <= ex if not then flip them
	if sx > ex then
		sx, ex = ex, sx
		sy, ey = ey, sy
	end

	if not C.GraphLib_Bars then
		C.GraphLib_Bars = {}
		C.GraphLib_Tris = {}
		C.GraphLib_Bars_Used = {}
		C.GraphLib_Tris_Used = {}
		C.GraphLib_Frames = {}
	end

	if (#C.GraphLib_Bars) > 0 then
		Bar = C.GraphLib_Bars[#C.GraphLib_Bars]
		tremove(C.GraphLib_Bars, #C.GraphLib_Bars)
		Bar:Show()

		Tri = C.GraphLib_Tris[#C.GraphLib_Tris]
		tremove(C.GraphLib_Tris, #C.GraphLib_Tris)
		Tri:Show()
	end

	if not Bar then
		Bar = C:CreateTexture(nil, "ARTWORK")
		Bar:SetColorTexture(1, 1, 1, 1)

		Tri = C:CreateTexture(nil, "ARTWORK")
		Tri:SetTexture(TextureDirectory.."triangle")
	end

	tinsert(C.GraphLib_Bars_Used, Bar)
	tinsert(C.GraphLib_Tris_Used, Tri)

	if level then
		if type(C.GraphLib_Frames[level]) == "nil" then
			local newLevel = C:GetFrameLevel() + level
			C.GraphLib_Frames[level] = CreateFrame("Frame", nil, C)
			C.GraphLib_Frames[level]:SetFrameLevel(newLevel)
			C.GraphLib_Frames[level]:SetAllPoints(C)

			if C.TextFrame and C.TextFrame:GetFrameLevel() <= newLevel then
				C.TextFrame:SetFrameLevel(newLevel + 1)
				self.NeedsUpdate = true
			end
		end

		Bar:SetParent(C.GraphLib_Frames[level])
		Tri:SetParent(C.GraphLib_Frames[level])
	end

	Bar:SetVertexColor(color[1], color[2], color[3], color[4])
	Tri:SetVertexColor(color[1], color[2], color[3], color[4])


	if sy < ey then
		Tri:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
		MinY = sy
		MaxY = ey
	else
		Tri:SetTexCoord(1, 0, 1, 1, 0, 0, 0, 1)
		MinY = ey
		MaxY = sy
	end

	--Has to be at least 1 wide
	if MinY <= 1 then
		MinY = 1
	end


	Bar:ClearAllPoints()
	Bar:SetPoint("BOTTOMLEFT", C, "BOTTOMLEFT", sx, 0)

	local Width = ex - sx
	if Width < 1 then
		Width = 1
	end
	Bar:SetWidth(Width)
	Bar:SetHeight(MinY)


	if (MaxY-MinY) >= 1 then
		Tri:ClearAllPoints()
		Tri:SetPoint("BOTTOMLEFT", C, "BOTTOMLEFT", sx, MinY)
		Tri:SetWidth(Width)
		Tri:SetHeight(MaxY - MinY)
	else
		Tri:Hide()
	end
end


function lib:HideBars(C)
	if not C.GraphLib_Bars then
		return
	end

	while (#C.GraphLib_Bars_Used) > 0 do
		C.GraphLib_Bars[#C.GraphLib_Bars + 1] = C.GraphLib_Bars_Used[#C.GraphLib_Bars_Used]
		C.GraphLib_Bars[#C.GraphLib_Bars]:Hide()
		C.GraphLib_Bars_Used[#C.GraphLib_Bars_Used] = nil

		C.GraphLib_Tris[#C.GraphLib_Tris + 1] = C.GraphLib_Tris_Used[#C.GraphLib_Tris_Used]
		C.GraphLib_Tris[#C.GraphLib_Tris]:Hide()
		C.GraphLib_Tris_Used[#C.GraphLib_Tris_Used] = nil
	end
end

-- lib upgrade stuff, overwrite the old function references in
-- existing graphs with the ones in this newer library
for _, graph in ipairs(lib.RegisteredGraphRealtime) do
	SetupGraphRealtimeFunctions(graph, true)
end
for _, graph in ipairs(lib.RegisteredGraphLine) do
	SetupGraphLineFunctions(graph)
end
for _, graph in ipairs(lib.RegisteredGraphScatterPlot) do
	SetupGraphScatterPlotFunctions(graph)
end
for _, graph in ipairs(lib.RegisteredGraphPieChart) do
	SetupGraphPieChartFunctions(graph)
end

---------------------------------------------------
--Test Functions, for reference for addon authors to test, use and copy
--To test the library do /script LibStub("LibGraph-2.0"):TestGraph2Lib()
local function TestRealtimeGraph()
	local Graph = LibStub(major)
	local g = Graph:CreateGraphRealtime("TestRealtimeGraph", UIParent, "CENTER", "CENTER", -90, 90, 150, 150)
	g:SetAutoScale(true)
	g:SetGridSpacing(1.0, 10.0)
	g:SetYMax(120)
	g:SetXAxis(-11, -1)
	g:SetFilterRadius(1)
	g:SetBarColors({0.2, 0.0, 0.0, 0.4}, {1.0, 0.0, 0.0, 1.0})

	local f = CreateFrame("Frame")
	f:SetScript("OnUpdate", function()
		g:AddTimeData(1)
	end)
	f:Show()
	DEFAULT_CHAT_FRAME:AddMessage("Testing Realtime Graph")
end

local function TestRealtimeGraphRaw()
	local Graph = LibStub(major)
	local g = Graph:CreateGraphRealtime("TestRealtimeGraph", UIParent, "TOP", "TOP", 0, 0, 150, 150)
	g:SetAutoScale(true)
	g:SetGridSpacing(1.0, 10.0)
	g:SetYMax(120)
	g:SetXAxis(-10, 0)
	g:SetMode("RAW")
	g:SetBarColors({0.2, 0.0, 0.0, 0.4}, {1.0, 0.0, 0.0, 1.0})

	local f = CreateFrame("Frame")
	f.frames = 0
	f.NextUpdate = GetTime()
	f:SetScript("OnUpdate",function()
		if f.NextUpdate > GetTime() then
			return
		end

		g:AddBar(UnitHealth("player"))
		f.NextUpdate = f.NextUpdate + g.BarWidth
	end)
	f:Show()
	DEFAULT_CHAT_FRAME:AddMessage("Testing 0")
end

local function TestLineGraph()
	local Graph = LibStub(major)
	local g = Graph:CreateGraphLine("TestLineGraph", UIParent, "CENTER", "CENTER", 90, 90, 150, 150)
	g:SetXAxis(-1, 1)
	g:SetYAxis(-1, 1)
	g:SetGridSpacing(0.25, 0.25)
	g:SetGridColor({0.5, 0.5, 0.5, 0.5})
	g:SetAxisDrawing(true, true)
	g:SetAxisColor({1.0, 1.0, 1.0, 1.0})
	g:SetAutoScale(true)

	local Data1 = {{0.05, 0.05}, {0.2, 0.3}, {0.4, 0.2}, {0.9, 0.6}}
	local Data2 = {{0.05, 0.8}, {0.3, 0.1}, {0.5, 0.4}, {0.95, 0.05}}

	g:AddDataSeries(Data1,{1.0, 0.0, 0.0, 0.8})
	g:AddDataSeries(Data2,{0.0, 1.0, 0.0, 0.8})
	DEFAULT_CHAT_FRAME:AddMessage("Testing Line Graph")
end

local function TestScatterPlot()
	local Graph = LibStub(major)
	local g = Graph:CreateGraphScatterPlot("TestScatterPlot", UIParent, "CENTER", "CENTER", 90, -90, 150, 150)
	g:SetXAxis(-1, 1)
	g:SetYAxis(-1, 1)
	g:SetGridSpacing(0.25, 0.25)
	g:SetGridColor({0.5, 0.5, 0.5, 0.5})
	g:SetAxisDrawing(true, true)
	g:SetAxisColor({1.0, 1.0, 1.0, 1.0})
	g:SetLinearFit(true)
	g:SetAutoScale(true)

	local Data1 = {{0.05, 0.05}, {0.2, 0.3}, {0.4, 0.2}, {0.9, 0.6}}
	local Data2 = {{0.05, 0.8}, {0.3, 0.1}, {0.5, 0.4}, {0.95, 0.05}}

	g:AddDataSeries(Data1,{1.0, 0.0, 0.0, 0.8})
	g:AddDataSeries(Data2,{0.0, 1.0, 0.0, 0.8})
	DEFAULT_CHAT_FRAME:AddMessage("Testing Scatter Plot")
end

local function TestPieChart()
	local Graph = LibStub(major)
	local g = Graph:CreateGraphPieChart("TestPieChart", UIParent, "CENTER", "CENTER", -90, -90, 150, 150)
	g:AddPie(35, {1.0, 0.0, 0.0})
	g:AddPie(21, {0.0, 1.0, 0.0})
	g:AddPie(10, {1.0, 1.0, 1.0})
	g:CompletePie({0.2, 0.2, 1.0})
	DEFAULT_CHAT_FRAME:AddMessage("Testing Pie Chart")
end

function lib:TestGraph2Lib()
	DEFAULT_CHAT_FRAME:AddMessage("Testing "..major..", "..gsub(minor, "%$", ""))
	TestRealtimeGraph()
	TestLineGraph()
	TestScatterPlot()
	TestPieChart()
end
