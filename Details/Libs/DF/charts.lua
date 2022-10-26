
local DF = _G["DetailsFramework"]
if (not DF or not DetailsFrameworkCanLoad) then
	return
end

local _

local ChartFrameMixin = {
    ChartFrameConstructor = function(self)
        self.nextLine = 1
        self.minValue = 0
        self.maxValue = 1
        self.lineThickness = 1
        self.data = {}
        self.lines = {}

        --OnSizeChanged
        self:SetScript("OnSizeChanged", self.OnSizeChanged)
    end,

    --internally handle next line
    GetLine = function(self)
        local line = self.lines[self.nextLine]
        if (not line) then
            line = self:CreateLine(nil, "overlay")
            self.lines[self.nextLine] = line
        end
        self.nextLine = self.nextLine + 1
        line:Show()
        return line
    end,

    GetLines = function(self)
        return self.lines
    end,

    GetAmountLines = function(self)
        return self.nextLine - 1
    end,

    HideLines = function(self)
        local allLines = self:GetLines()
        for i = 1, #allLines do
            local line = allLines[i]
            line:Hide()
        end
    end,

    Reset = function(self)
        self:HideLines()
        self.nextLine = 1
    end,

    SetLineThickness = function(self, value)
        assert(type(value) == "number", "number expected on :SetLineThickness(number)")
        self.lineThickness = value
    end,

    --calculate the width of each drawn line
    GetLineWidth = function(self)
        --self:SetLineWidth(nil) to erase the fixed value
        if (self.fixedLineWidth) then
            return self.fixedLineWidth
        else
            local amountData = self:GetDataSize()
            local frameWidth = self:GetWidth()
            return frameWidth / amountData
        end
    end,

    SetLineWidth = function(self, width)
        assert(type(width) == "number", "number expected on :SetLineWidth(number)")
        self.fixedLineWidth = width
    end,

    CalcYAxisPointForValue = function(self, value)
        return value / self.maxValue * self.height
    end,

    UpdateFrameSizeCache = function(self)
        self.width = self:GetWidth()
        self.height = self:GetHeight()
    end,

    OnSizeChanged = function(self)
        self:UpdateFrameSizeCache()
    end,

    Plot = function(self)
        --debug
        --self:SetData({38, 26, 12, 63, 100, 96, 42, 94, 25, 75, 61, 54, 71, 40, 34, 100, 66, 90, 39, 13, 99, 18, 72, 18, 83, 45, 56, 24, 33, 85, 95, 71, 15, 66, 19, 58, 52, 9, 83, 99, 100, 4, 3, 56, 6, 80, 94, 7, 40, 55, 98, 92, 20, 9, 35, 89, 72, 7, 13, 81, 29, 78, 55, 70, 12, 33, 39, 3, 84, 31, 10, 53, 51, 69, 66, 58, 71, 60, 31, 71, 27, 76, 21, 75, 15, 89, 2, 81, 72, 78, 74, 80, 97, 10, 59, 0, 31, 5, 1, 82, 71, 89, 78, 94, 74, 20, 65, 72, 56, 40, 92, 91, 40, 79, 4, 56, 18, 88, 88, 20, 20, 10, 47, 26, 80, 26, 75, 21, 57, 10, 67, 66, 84, 83, 14, 47, 83, 9, 7, 73, 63, 32, 64, 20, 40, 3, 46, 54, 17, 37, 82, 66, 65, 22, 12, 1, 100, 41, 1, 72, 38, 41, 71, 69, 88, 34, 10, 50, 9, 25, 19, 27, 3, 13, 40, 75, 3, 11, 93, 58, 81, 80, 93, 25, 74, 68, 91, 87, 79, 48, 66, 53, 64, 18, 51, 19, 32, 4, 21, 43})
        local currentXPoint = 0
        local currentYPoint = 0

        self:UpdateFrameSizeCache()

        --max amount of data is the max amount of point the chart will have
        local maxLines = self:GetDataSize()

        --calculate where the first point height will be
        local firstValue = self:GetDataFirstValue()
        assert(firstValue, "Can't Plot(), chart has no data, use Chart:SetData(table)")

        currentYPoint = self:CalcYAxisPointForValue(firstValue)

        --calculate the width space which line should have
        local eachLineWidth = self:GetLineWidth()

        self:ResetDataIndex()

        for i = 1, maxLines do
            local line = self:GetLine()
            line:SetColorTexture(1, 1, 1, 1)
            line:SetThickness(1)

            --the start point starts where the latest point finished
            line:SetStartPoint("bottomleft", currentXPoint, currentYPoint)

            --move x
            currentXPoint = currentXPoint + eachLineWidth

            --end point
            local value = self:GetDataNextValue()
            currentYPoint = self:CalcYAxisPointForValue(value)
            line:SetEndPoint("bottomleft", currentXPoint, currentYPoint)
        end
    end,
}


local createChartFrame = function(parent, name)
    local f = CreateFrame("frame", name, parent, "BackdropTemplate")

    DF:Mixin(f, DF.DataMixin)
    DF:Mixin(f, DF.ValueMixin)
    DF:Mixin(f, ChartFrameMixin)

    f:DataConstructor()
    f:ValueConstructor()
    f:ChartFrameConstructor()

    --when a new data is set, update the min and max values
    local onSetDataCallback = function()
        local minValue, maxValue = f:GetDataMinMaxValues()
        f:SetMinMaxValues(minValue, maxValue)
        --clear the lines
        f:HideLines()
    end
    f:AddDataChangeCallback(onSetDataCallback)

    return f
end

function DF:CreateGraphicLineFrame(parent, name)
    local newGraphicFrame = createChartFrame(parent, name)
    return newGraphicFrame
end

local MultiChartFrameMixin = {
    MultiChartFrameConstructor = function(self)
        self.nextChartselframe = 1
        self.biggestDataValue = 0
        self.chartFrames = {}
    end,

    AddData = function(self, data)
        assert(type(data) == "table", "MultiChartFrame:AddData() usage: AddData(table)")
        local chartFrame = self:GetChart()
        chartFrame:SetData(data)

        self:SetMaxValueIfBigger(chartFrame:GetMaxValue())
        self:SetMinValueIfLower(chartFrame:GetMinValue())

        local dataAmount = chartFrame:GetDataSize()
        self:SetMaxDataSize(dataAmount)
    end,

    --internally handle next line
    GetChart = function(self)
        local chartFrame = self.chartFrames[self.nextChartFrame]
        if (not chartFrame) then
            chartFrame = createChartFrame(self, "$parentChartFrame" .. self.nextChartFrame)
            chartFrame:SetAllPoints()
            chartFrame:UpdateFrameSizeCache()
            self.chartFrames[self.nextChartFrame] = chartFrame
        end
        self.nextChartFrame = self.nextChartFrame + 1
        chartFrame:Show()
        return chartFrame
    end,

    GetCharts = function(self)
        return self.chartFrames
    end,

    GetAmountCharts = function(self)
        return self.nextChartFrame - 1
    end,

    HideCharts = function(self)
        local charts = self:GetCharts()
        for i = 1, #charts do
            local chartFrame = charts[i]
            chartFrame:Hide()
        end
    end,

    Reset = function(self)
        self:HideCharts()
        self.nextChartFrame = 1
    end,

    SetChartsMinMaxValues = function(self, minValue, maxValue)
        local allCharts = self:GetCharts()
        for i = 1, self:GetAmountCharts() do
            local chartFrame = allCharts[i]
            chartFrame:SetMinMaxValues(minValue, maxValue)
        end
    end,

    SetMaxDataSize = function(self, dataSize)
        self.biggestDataValue = max(self.biggestDataValue, dataSize)
    end,

    GetMaxDataSize = function(self)
        return self.biggestDataValue
    end,

    Plot = function(self)
        local minValue, maxValue = self:GetMinMaxValues()
        self:SetChartsMinMaxValues(minValue, maxValue)

        local plotAreaWidth = self:GetWidth()
        local maxDataSize = self:GetMaxDataSize()
        local eachLineWidth = plotAreaWidth / maxDataSize

        local allCharts = self:GetCharts()
        for i = 1, self:GetAmountCharts() do
            local chartFrame = allCharts[i]
            chartFrame:SetLineWidth(eachLineWidth)
            chartFrame:Plot()
        end
    end,
}

function DF:CreateGraphicMultiLineFrame(parent, name)
    name = name or ("DetailsMultiChartFrameID" .. math.random(1, 10000000))

    local f = CreateFrame("frame", name, parent, "BackdropTemplate")

    DF:Mixin(f, DF.ValueMixin)
    DF:Mixin(f, MultiChartFrameMixin)

    f:ValueConstructor()
    f:MultiChartFrameConstructor()

    return f
end
