local ChocolateBar = LibStub("AceAddon-3.0"):GetAddon("ChocolateBar")
local LSM = LibStub("LibSharedMedia-3.0")
local ChocolatePiece = ChocolateBar.ChocolatePiece
local Drag = ChocolateBar.Drag
local debug = ChocolateBar and ChocolateBar.Debug or function() end
local _G, unpack, ipairs = _G, unpack, ipairs
local GameTooltip, CreateFrame = GameTooltip, CreateFrame
local tempAutoHide, db

local function resizeFrame(self)
	local settings = self.settings
	local width = db.gap
	local textOffset = settings.textOffset or db.textOffset
	if self.icon and settings.showIcon then
		width = width + self.icon:GetWidth() + textOffset
	end

    -- XXX 163
    -- preventing the width changing too often
    if(self.__163_oldwidth) then
        local delta = self.__163_oldwidth - width
        if(delta > 0) and (delta < 15) then
            width = self.__163_oldwidth
        end
    end
    self.__163_oldwidth = width
    -- XXX 163 end
	
	local textWidth = (settings.showText or settings.showLabel) and self.text:GetStringWidth() or 0
	--local labelWidth = settings.showLabel and self.label:GetStringWidth() or 0

	if settings.widthBehavior == "fixed" then
		width = width + settings.width
	elseif settings.widthBehavior == "max" then
		width = width + min(textWidth, settings.width)
	else
		width = width + textWidth
	end
	
	self:SetWidth(width)
	if self.bar then self.bar:UpdateCenter() end
end

function findpattern(text, pattern, start)
  return string.sub(text, string.find(text, pattern, start))
end

local function TextUpdater(frame, value)
	value = value and value or ""
	if db.forceColor then
		value = string.gsub(value, "|c........", "")
		value = string.gsub(value, "|r", "")
	end

	if frame.settings.showText then
		frame.text:SetText(frame.labelText..value)
	else
		frame.text:SetText(frame.labelText)
	end

	resizeFrame(frame)
end

local function isCustomLabel(frame)
	return frame.settings.customLabel and frame.settings.customLabel ~= ""
end

local function getLabelFromObjOrSettings(frame, value)
	if isCustomLabel(frame) then
		return frame.settings.customLabel
	else
		if db.forceColor then
			value = string.gsub(value, "|c........", "")
			value = string.gsub(value, "|r", "")
		end
		return value and value or "";
	end
end

local function tableToHex(t)
	local r,g,b = t.r, t.g, t.b
	return ("%02x%02x%02x%02x"):format(1*255,r*255, g*255, b*255)
end

local function LabelUpdater(frame, value)
	if frame.settings.showLabel then
		local delimiter = frame.settings.showText and ":" or ""
		frame.labelText = string.format("|c%s%s%s|r ", tableToHex(db.labelColor), getLabelFromObjOrSettings(frame, value), delimiter)
	else 
		frame.labelText = ""
	end

	TextUpdater(frame, frame.obj.text)
end

local function SettingsUpdater(self, value)
	local settings = self.settings
	
	if not settings.showText and not settings.showLabel then
		self.text:Hide()
	else
		self.text:Show()
		local c = db.textColor
		if c then
			self.text:SetTextColor(c.r, c.g, c.b,c.a)
		end
	end

	self.text:SetPoint("CENTER", self, 0, 0)
	self.text:SetPoint("RIGHT", self, 0, 0)

	if self.icon then
		if settings.showIcon then
			local iconSize = settings.iconSize or db.iconSize
			self.icon:SetWidth(db.height * iconSize)
			self.icon:SetHeight(db.height * iconSize)
			self.icon:Show()
			local textOffset = settings.textOffset or db.textOffset
			self.text:SetPoint("LEFT", self.icon,"RIGHT", textOffset, 0)
		else -- hide icon
			self.icon:Hide()
			self.text:SetPoint("LEFT", self, 0, 0)
		end
	else -- no icon
		self.text:SetPoint("LEFT", self, 0, 0)
	end
	
	LabelUpdater(self, self.obj.label)
	resizeFrame(self)
end

local function IconColorUpdater(frame, value, name)
	if not frame.icon then return end

	frame.icon:SetDesaturated(db.desaturated);
	if value then
		local obj = frame.obj
		local r = obj.iconR or 1
		local g = obj.iconG or 1
		local b = obj.iconB or 1
		frame.icon:SetVertexColor(r, g, b)
	else
		frame.icon:SetVertexColor(1, 1, 1)
	end
end

local function CreateIcon(self, icon)
	local iconTex = self:CreateTexture()
	local obj = self.obj
	--iconTex:SetWidth(db.height - 6)
	--iconTex:SetPoint("TOPLEFT", self, 0, -2)
	--iconTex:SetPoint("BOTTOM", self, 0, 4)
	iconTex:SetPoint("CENTER", self, 0, 0)
	iconTex:SetPoint("LEFT", self, 0, 0)

	iconTex:SetTexture(icon)
	if obj.iconCoords then
		iconTex:SetTexCoord(unpack(obj.iconCoords))
	end
	iconTex:SetDesaturated(db.desaturated);
	self.icon = iconTex
end

-- updaters code taken with permission from fortress
local updaters = {
	text = TextUpdater,
	label  = LabelUpdater,
	resizeFrame = resizeFrame,

	icon = function(frame, value, name)
		--if value and self.db.icon then
		if value then
			if frame.icon then
				frame.icon:SetTexture(value)
			else
				CreateIcon(frame, value)
				SettingsUpdater(frame)
			end
		end
	end,

	updatefont = function(self)
        local fontPath = db.fontPath == " " and (GetLocale() == 'zhCN' and LSM:Fetch('font', '聊天') or LSM:GetDefault("font")) or db.fontPath
		self.text:SetFont(fontPath, db.fontSize)
		resizeFrame(self)
	end,
	updateSettings = SettingsUpdater,
	-- tooltiptext is no longer in the data spec, but
	-- I'll continue to support it, as some plugins seem to use it
	tooltiptext = function(frame, value, name)
		local object = frame.obj
		local tt = object.tooltip or GameTooltip
		if tt:GetOwner() == frame then
			tt:SetText(object.tooltiptext)
		end
	end,

	OnClick = function(frame, value, name)
		frame:SetScript("OnClick", value)
	end,

	iconCoords = function(frame, value, name)
		if value and frame.icon then
			frame.icon:SetTexCoord(unpack(value))
		end
	end,

	iconR = IconColorUpdater,
	iconG = IconColorUpdater,
	iconB = IconColorUpdater,
}

-- GetAnchors code taken with permission from fortress
local function GetAnchors(frame)
	local x, y = frame:GetCenter()
	local leftRight
	if x < _G.GetScreenWidth() / 2 then
		leftRight = "LEFT"
	else
		leftRight = "RIGHT"
	end
	if y < _G.GetScreenHeight() / 2 then
		return "BOTTOM", "TOP"
	else
		return "TOP", "BOTTOM"
	end
end

local function PrepareTooltip(frame, anchorFrame)
	if frame and anchorFrame then
		frame:ClearAllPoints()
		if frame.SetOwner then
			frame:SetOwner(anchorFrame, "ANCHOR_NONE")
		end
		local a1, a2 = GetAnchors(anchorFrame)
		frame:SetPoint(a1, anchorFrame, a2)
	end
end

local function OnEnter(self)
	if (db.combathidebar and ChocolateBar.InCombat) or ChocolateBar.dragging then return end

	local obj  = self.obj
	local name = self.name
	local bar = self.bar
	if bar.autohide then
		bar:ShowAll()
	end

	if db.combathidetip and ChocolateBar.InCombat then return end

	if obj.tooltip then
		PrepareTooltip(obj.tooltip, self)
		if obj.tooltiptext then
			obj.tooltip:SetText(obj.tooltiptext)
		end
		obj.tooltip:Show()

	elseif obj.OnTooltipShow then
		PrepareTooltip(GameTooltip, self)
		obj.OnTooltipShow(GameTooltip)
		GameTooltip:Show()

	elseif obj.tooltiptext then
		PrepareTooltip(GameTooltip, self)
		GameTooltip:SetText(obj.tooltiptext)
		GameTooltip:Show()
	elseif obj.OnEnter then
		obj.OnEnter(self)
	end
end

local function OnLeave(self)
	if db.combathidebar and ChocolateBar.InCombat then return end

	local obj  = self.obj
	local name = self.name

	local bar = self.bar
	if bar.autohide then
		bar:HideAll()
	end

	if obj.OnTooltipShow then
		GameTooltip:Hide()
	end

	if db.combathidetip and ChocolateBar.InCombat then return end
	if obj.OnLeave then
		obj.OnLeave(self)
	elseif obj.tooltip then
		obj.tooltip:Hide()
	else
		GameTooltip:Hide()
	end
end

local function OnClick(self, ...)
	if db.combatdisbar and ChocolateBar.InCombat then return end
	if self.obj.OnClick then
		self.obj.OnClick(self, ...)
	end
end

local function OnMouseWheel(self, ...)
	if self.obj.OnMouseWheel then
	  self:EnableMouseWheel(1)
		self.obj.OnMouseWheel(self, ...)
	end
end

local function Update(self, f,key, value, name)
	local update = updaters[key]
	if update then
		update(f, value, name)
	end
end

local function OnDragStart(frame)
	if not ChocolateBar.db.profile.locked or _G.IsAltKeyDown() then
		local bar = frame.bar
		ChocolateBar:TempDisAutohide(true)
		ChocolateBar.dragging = true

		if ChocolateBar.db.profile.colorizedDragging then
			ChocolateBar:ExecuteforAllChoclates(function(frame)
				frame:highlight(math.random(),math.random(),math.random(), .8)
			end)
		end

		OnLeave(frame)
		-- hide libqtip and libtablet tooltips
		local kids = {_G.UIParent:GetChildren()}
		for _, child in ipairs(kids) do
			if not child:IsForbidden() then
				for i = 1, child:GetNumPoints() do
					local _,relativeTo,_,_,_ = child:GetPoint(i)
					if relativeTo == frame then
						child:Hide()
					end
				end
			end
		end

		ChocolateBar:SetDropPoins(frame)
		Drag:Start(bar, frame.name, frame)
		frame:StartMoving()
		frame.isMoving = true
		frame:highlight(1)
	end
end

local function OnDragStop(frame)
	if ChocolateBar.dragging then
		--frame:highlight(0)
		ChocolateBar:ExecuteforAllChoclates(function(frame) frame:highlight(0,0,0,0) end)
		frame:StopMovingOrSizing()
		frame.isMoving = false
		Drag:Stop(frame)
		ChocolateBar.dropFrames:Hide()
		ChocolateBar.dragging = false
		frame:SetParent(frame.bar)
		ChocolateBar:TempDisAutohide()
	end
end

local function highlightBackground(frame, r, g, b, a)
	if not frame:GetBackdrop() then
		frame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
													edgeFile = nil,
													tile = true, tileSize = 16, edgeSize = 16,
													insets = { left = 0, right = 0, top = 0, bottom = 0 }})
		end
		frame:SetBackdropColor(r, g, b, a)
end

local function isLauncherAndHasNoText(obj)
	return obj.type and obj.type == "launcher" and (obj.text == nil or obj.text == "")
end

function ChocolatePiece:New(name, obj, settings, database)
	db = database

	local icon = obj.icon
	local chocolate = CreateFrame("Button", "Chocolate" .. name)
	chocolate.highlight = highlightBackground

	--set update function
	chocolate.Update = Update
	chocolate.obj = obj

	chocolate:EnableMouse(true)
	chocolate:RegisterForDrag("LeftButton")

    -- XXX hack by 163
	local fontPath = db.fontPath == " " and (GetLocale() == 'zhCN' and LSM:Fetch('font', '聊天') or LSM:GetDefault("font")) or db.fontPath

	chocolate.text = chocolate:CreateFontString(nil, nil, "GameFontHighlight")
	chocolate.text:SetFont(fontPath, db.fontSize)
	chocolate.text:SetJustifyH("LEFT")

	if isLauncherAndHasNoText(obj) then
		obj.text = obj.label and obj.label or name
	end

	if icon then
		CreateIcon(chocolate, icon)
	end

	chocolate:SetScript("OnEnter", OnEnter)
	chocolate:SetScript("OnLeave", OnLeave)
	chocolate:RegisterForClicks("AnyUp")
	chocolate:SetScript("OnClick", OnClick)
	chocolate:SetScript("OnMouseWheel", OnMouseWheel)

	chocolate:Show()
	chocolate.settings = settings

	if not obj.label then
		obj.label = name
	end

	chocolate.name = name
	chocolate:SetMovable(true)
	chocolate:SetScript("OnDragStart", OnDragStart)
	chocolate:SetScript("OnDragStop", OnDragStop)
	SettingsUpdater(chocolate, settings.showText)
	LabelUpdater(chocolate, obj.label)	
	return chocolate
end

function ChocolatePiece:UpdateGap(val)
	db.gap = val
end
