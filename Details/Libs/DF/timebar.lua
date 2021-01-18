

local DF = _G ["DetailsFramework"]
if (not DF or not DetailsFrameworkCanLoad) then
	return
end

local _
local rawset = rawset
local rawget = rawget
local setmetatable = setmetatable
local unpack = unpack
local type = type
local floor = math.floor
local GetTime = GetTime

local SharedMedia = LibStub:GetLibrary ("LibSharedMedia-3.0")

local cleanfunction = function() end
local APITimeBarFunctions

do
	local metaPrototype = {
		WidgetType = "timebar",
		SetHook = DF.SetHook,
		RunHooksForWidget = DF.RunHooksForWidget,
		dversion = DF.dversion,
	}

	--check if there's a metaPrototype already existing
	if (_G[DF.GlobalWidgetControlNames["timebar"]]) then
		--get the already existing metaPrototype
		local oldMetaPrototype = _G[DF.GlobalWidgetControlNames ["timebar"]]
		--check if is older
		if ( (not oldMetaPrototype.dversion) or (oldMetaPrototype.dversion < DF.dversion) ) then
			--the version is older them the currently loading one
			--copy the new values into the old metatable
			for funcName, _ in pairs(metaPrototype) do
				oldMetaPrototype[funcName] = metaPrototype[funcName]
			end
		end
	else
		--first time loading the framework
		_G[DF.GlobalWidgetControlNames ["timebar"]] = metaPrototype
	end
end

local TimeBarMetaFunctions = _G[DF.GlobalWidgetControlNames["timebar"]]


--methods
TimeBarMetaFunctions.SetMembers = TimeBarMetaFunctions.SetMembers or {}
TimeBarMetaFunctions.GetMembers = TimeBarMetaFunctions.GetMembers or {}

TimeBarMetaFunctions.__index = function (table, key)
    local func = TimeBarMetaFunctions.GetMembers[key]
    if (func) then
        return func(table, key)
    end

    local fromMe = rawget(table, key)
    if (fromMe) then
        return fromMe
    end
    return TimeBarMetaFunctions [key]
end

TimeBarMetaFunctions.__newindex = function(table, key, value)
    local func = TimeBarMetaFunctions.SetMembers[key]
    if (func) then
        return func(table, value)
    else
        return rawset(table, key, value)
    end
end

--scripts
local OnEnterFunc = function(statusBar)
    local kill = statusBar.MyObject:RunHooksForWidget("OnEnter", statusBar, statusBar.MyObject)
    if (kill) then
        return
    end

    if (statusBar.MyObject.tooltip) then
        GameCooltip2:Reset()
        GameCooltip2:AddLine(statusBar.MyObject.tooltip)
        GameCooltip2:ShowCooltip(statusBar, "tooltip")
    end
end

local OnLeaveFunc = function(statusBar)
    local kill = statusBar.MyObject:RunHooksForWidget("OnLeave", statusBar, statusBar.MyObject)
    if (kill) then
        return
    end

    if (statusBar.MyObject.tooltip) then
        GameCooltip2:Hide()
    end
end

local OnHideFunc = function(statusBar)
    local kill = statusBar.MyObject:RunHooksForWidget("OnHide", statusBar, statusBar.MyObject)
    if (kill) then
        return
    end
end

local OnShowFunc = function(statusBar)
    local kill = statusBar.MyObject:RunHooksForWidget("OnShow", statusBar, statusBar.MyObject)
    if (kill) then
        return
    end
end

local OnMouseDownFunc = function(statusBar, mouseButton)
    local kill = statusBar.MyObject:RunHooksForWidget("OnMouseDown", statusBar, statusBar.MyObject)
    if (kill) then
        return
    end
end

local OnMouseUpFunc = function(statusBar, mouseButton)
    local kill = statusBar.MyObject:RunHooksForWidget("OnMouseUp", statusBar, statusBar.MyObject)
    if (kill) then
        return
    end
end

--timer functions
function TimeBarMetaFunctions:SetIconSize(width, height)
    if (width and not height) then
        self.statusBar.icon:SetWidth(width)

    elseif (not width and height) then
        self.statusBar.icon:SetHeight(height)

    elseif (width and height) then
        self.statusBar.icon:SetSize(width, height)
    end
end

function TimeBarMetaFunctions:SetIcon(texture, L, R, T, B)
    if (texture) then
        self.statusBar.icon:Show()
        self.statusBar.icon:SetPoint("left", self.statusBar, "left", 2, 0)
        self.statusBar.icon:SetSize(self.statusBar:GetHeight()-2, self.statusBar:GetHeight()-2)
        self.statusBar.leftText:ClearAllPoints()
        self.statusBar.leftText:SetPoint("left", self.statusBar.icon, "right", 2, 0)
        self.statusBar.icon:SetTexture(texture)

        if (L) then
            self.statusBar.icon:SetTexCoord(L, R, T, B)
        end
    else
        self.statusBar.icon:Hide()
        self.statusBar.leftText:ClearAllPoints()
        self.statusBar.leftText:SetPoint("left", self.statusBar, "left", 2, 0)
    end
end

function TimeBarMetaFunctions:GetIcon()
    return self.statusBar.icon
end

function TimeBarMetaFunctions:SetTexture(texture)
    self.statusBar.barTexture:SetTexture(texture)
end

function TimeBarMetaFunctions:SetLeftText(text)
    self.statusBar.leftText:SetText(text)
end
function TimeBarMetaFunctions:SetRightText(text)
    self.statusBar.rightText:SetText(text)
end

function TimeBarMetaFunctions:SetFont(font, size, color, shadow)
    if (font) then
        DF:SetFontFace(self.statusBar.leftText, font)
    end

    if (size) then
        DF:SetFontSize(self.statusBar.leftText, size)
    end

    if (color) then
        DF:SetFontColor(self.statusBar.leftText, color)
    end

    if (shadow) then
        DF:SetFontOutline(self.statusBar.leftText, shadow)
    end
end

function TimeBarMetaFunctions:SetDirection(direction)
    direction = direction or "right"
    self.direction = direction
end

function TimeBarMetaFunctions:HasTimer()
    return self.statusBar.hasTimer
end

function TimeBarMetaFunctions:StopTimer()
    if (self.statusBar.hasTimer) then
        self.statusBar.hasTimer = nil
        local kill = self:RunHooksForWidget("OnTimerEnd", self.statusBar, self)
        if (kill) then
            return
        end
    end

    local statusBar = self.statusBar
    statusBar:SetScript("OnUpdate", nil)

    statusBar:SetMinMaxValues(0, 100)
    statusBar:SetValue(100)
    statusBar.rightText:SetText("")

    statusBar.spark:Hide()
end

local OnUpdateFunc = function(self, deltaTime)
    self.throttle = self.throttle + deltaTime
    if (self.throttle < 0.1) then
        return
    end
    self.throttle = 0

    local timeNow = GetTime()
    self:SetValue(timeNow)

    --adjust the spark
    local spark = self.spark
    local startTime, endTime = self:GetMinMaxValues()

    if (self.direction == "right") then
        local pct = abs((timeNow - endTime) / (endTime - startTime))
        pct = abs(1 - pct)
        spark:SetPoint("left", self, "left", (self:GetWidth() * pct) - 16, 0)
        spark:Show()
    else
        spark:SetPoint("right", self, "right", self:GetWidth() * (timeNow/self.endTime), 0)
    end

    local timeLeft = floor(endTime - timeNow)
    self.rightText:SetText(timeLeft)

    --check if finished
    if (timeNow >= self.endTime) then
        self.MyObject:StopTimer()
    end
end

function TimeBarMetaFunctions:SetTimer(currentTime, startTime, endTime)

    if (not currentTime or currentTime == 0) then
        self:StopTimer()
        return
    end

    if (startTime and endTime) then
        if (self.statusBar.hasTimer and currentTime == self.statusBar.timeLeft1) then
            --it is the same timer called again
            return
        end
        self.statusBar.startTime = startTime
        self.statusBar.endTime = endTime
    else
        if (self.statusBar.hasTimer and currentTime == self.statusBar.timeLeft2) then
            --it is the same timer called again
            return
        end
        self.statusBar.starTime = GetTime()
        self.statusBar.endTime = GetTime() + currentTime
        self.statusBar.timeLeft2 = currentTime
    end

    --print("min|max values:", self.statusBar.starTime, self.statusBar.endTime)
    self.statusBar:SetMinMaxValues(self.statusBar.starTime, self.statusBar.endTime)

    if (self.direction == "right") then
        self.statusBar:SetReverseFill(false)
    else
        self.statusBar:SetReverseFill(true)
    end

    self.statusBar.spark:Show()
    self.statusBar.hasTimer = true
    self.statusBar.direction = self.direction
    self.statusBar.throttle = 0
    self.statusBar:Show()

    self.statusBar:SetScript("OnUpdate", OnUpdateFunc)

    local kill = self:RunHooksForWidget("OnTimerStart", self.statusBar, self)
    if (kill) then
        return
    end
end


function DF:CreateTimeBar(parent, texture, width, height, value, member, name)

    if (not name) then
		name = "DetailsFrameworkBarNumber" .. DF.BarNameCounter
		DF.BarNameCounter = DF.BarNameCounter + 1

	elseif (not parent) then
		return error ("Details! FrameWork: parent not found.", 2)
	end

	if (name:find ("$parent")) then
		local parentName = DF.GetParentName(parent)
		name = name:gsub("$parent", parentName)
	end

	local timeBar = {
        type = "timebar",
        dframework = true
    }

	if (member) then
		parent[member] = timeBar
	end
	if (parent.dframework) then
		parent = parent.widget
	end

	value = value or 0
	width = width or 150
	height = height or 14
	timeBar.locked = false

    timeBar.statusBar = CreateFrame("statusbar", name, parent, "BackdropTemplate")
    timeBar.widget = timeBar.statusBar
    DF:Mixin(timeBar.statusBar, DF.WidgetFunctions)
    timeBar.statusBar.MyObject = timeBar
    timeBar.direction = "right"

    if (not APITimeBarFunctions) then
        APITimeBarFunctions = true
        local idx = getmetatable(timeBar.statusBar).__index
        for funcName, funcAddress in pairs(idx) do
            if (not TimeBarMetaFunctions[funcName]) then
                TimeBarMetaFunctions[funcName] = function(object, ...)
                    local x = loadstring("return _G['"..object.statusBar:GetName().."']:"..funcName.."(...)")
                    return x(...)
                end
            end
        end
    end

    --> create widgets
        timeBar.statusBar:SetWidth(width)
		timeBar.statusBar:SetHeight(height)
		timeBar.statusBar:SetFrameLevel(parent:GetFrameLevel()+1)
		timeBar.statusBar:SetMinMaxValues(0, 100)
		timeBar.statusBar:SetValue(value or 100)
		timeBar.statusBar:EnableMouse(false)

        timeBar.statusBar.backgroundTexture = timeBar.statusBar:CreateTexture(nil, "border")
        timeBar.statusBar.backgroundTexture:SetColorTexture(.1, .1, .1, .6)
        timeBar.statusBar.backgroundTexture:SetAllPoints()

        timeBar.statusBar.barTexture = timeBar.statusBar:CreateTexture(nil, "artwork")
        timeBar.statusBar.barTexture:SetTexture(texture or [[Interface\WorldStateFrame\WORLDSTATEFINALSCORE-HIGHLIGHT]])
        timeBar.statusBar:SetStatusBarTexture(timeBar.statusBar.barTexture)

        timeBar.statusBar.spark = timeBar.statusBar:CreateTexture(nil, "overlay", nil, 7)
        timeBar.statusBar.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
        timeBar.statusBar.spark:SetBlendMode("ADD")
        timeBar.statusBar.spark:Hide()

        timeBar.statusBar.icon = timeBar.statusBar:CreateTexture(nil, "overlay", nil, 5)
        timeBar.statusBar.icon:SetPoint("left", timeBar.statusBar, "left", 2, 0)

        timeBar.statusBar.leftText = timeBar.statusBar:CreateFontString("$parentLeftText", "overlay", "GameFontNormal", 4)
        timeBar.statusBar.leftText:SetPoint("left", timeBar.statusBar.icon, "right", 2, 0)

        timeBar.statusBar.rightText = timeBar.statusBar:CreateFontString(nil, "overlay", "GameFontNormal", 4)
        timeBar.statusBar.rightText:SetPoint("right", timeBar.statusBar, "right", -2, 0)
        
	--> hooks
		timeBar.HookList = {
			OnEnter = {},
			OnLeave = {},
			OnHide = {},
			OnShow = {},
			OnMouseDown = {},
            OnMouseUp = {},
            OnTimerStart = {},
			OnTimerEnd = {},
		}

		timeBar.statusBar:SetScript("OnEnter", OnEnterFunc)
		timeBar.statusBar:SetScript("OnLeave", OnLeaveFunc)
		timeBar.statusBar:SetScript("OnHide", OnHideFunc)
		timeBar.statusBar:SetScript("OnShow", OnShowFunc)
		timeBar.statusBar:SetScript("OnMouseDown", OnMouseDownFunc)
		timeBar.statusBar:SetScript("OnMouseUp", OnMouseUpFunc)

	--set class
	setmetatable(timeBar, TimeBarMetaFunctions)

	return timeBar
end
