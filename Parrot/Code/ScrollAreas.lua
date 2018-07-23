local Parrot = Parrot
local Parrot_ScrollAreas = Parrot:NewModule("ScrollAreas", "AceTimer-3.0")
local self = Parrot_ScrollAreas
local L = LibStub("AceLocale-3.0"):GetLocale("Parrot_ScrollAreas")

local debug = Parrot.debug
local del = Parrot.del
local newList = Parrot.newList
--[===[@debug@
_G.Parrot_ScrollAreas = Parrot_ScrollAreas
--@end-debug@]===]--
local scrollAreas

local choices = {}
local choicesBase = {
	Incoming = L["Incoming"],
	Outgoing = L["Outgoing"],
	Notification = L["Notification"],
}

-- Parrot_ScrollAreas.db = Parrot:GetDatabaseNamespace("ScrollAreas")

function Parrot_ScrollAreas:OnInitialize()
	Parrot_ScrollAreas.db1 = Parrot.db1:RegisterNamespace("ScrollAreas")
end

local function initDB()
	if not self.db1.profile.areas then
		self.db1.profile.areas = {
			["Notification"] = {
				animationStyle = "Straight",
				direction = "UP;CENTER",
				stickyAnimationStyle = "Pow",
				stickyDirection = "UP;CENTER",
				size = 150,
				xOffset = 0,
				yOffset = 175,
			},
			["Incoming"] = {
				animationStyle = "Parabola",
				direction = "DOWN;LEFT",
				stickyAnimationStyle = "Pow",
				stickyDirection = "DOWN;RIGHT",
				size = 260,
				xOffset = -60,
				yOffset = -30,
				iconSide = "RIGHT",
			},
			["Outgoing"] = {
				animationStyle = "Parabola",
				direction = "DOWN;RIGHT",
				stickyAnimationStyle = "Pow",
				stickyDirection = "DOWN;LEFT",
				size = 260,
				xOffset = 60,
				yOffset = -30,
			},
		}
	end
end

local function rebuildChoices()
	scrollAreas = self.db1.profile.areas
	choices = del(choices)
	choices = newList()
	for k, v in pairs(scrollAreas) do
		choices[k] = choicesBase[k] or k
	end
end

function Parrot_ScrollAreas:ChangeProfile()
	initDB()
	if Parrot.options.args.scrollAreas then
		Parrot.options.args.scrollAreas = nil
		self:OnOptionsCreate()
	end
	rebuildChoices()
end

local setConfigMode
function Parrot_ScrollAreas:OnDisable()
	if setConfigMode then
		setConfigMode(false)
	end
end

CONFIGMODE_CALLBACKS = CONFIGMODE_CALLBACKS or {}
CONFIGMODE_CALLBACKS["Parrot"] = function(state)
	Parrot:SetConfigMode(state == "ON")
end


--[[----------------------------------------------------------------------------------
Notes:
	Turn on/off the config mode boxes.
Arguments:
	boolean - whether to turn on.
Example:
	Parrot:SetConfigMode(true)
	-- or
	Parrot:SetConfigMode(false)
------------------------------------------------------------------------------------]]
function Parrot:SetConfigMode(state)
	if type(state) ~= "boolean" then
		error(("Bad argument #2 to `SetConfigMode'. Expected %q, got %q."):format("boolean", type(state)), 2)
	end
	setConfigMode(state)
end
local configModeTimer
local offsetBoxes
local function hideAllOffsetBoxes()
	if not offsetBoxes then
		return
	end
	for k,v in pairs(offsetBoxes) do
		v:Hide()
	end
	Parrot_ScrollAreas:CancelTimer(configModeTimer)
end
local function showOffsetBox(k)
	if not offsetBoxes then
		offsetBoxes = {}
	end
	local offsetBox = offsetBoxes[k]
	local name = choicesBase[k] or k
	if not offsetBox then
		offsetBox = CreateFrame("Button", "Parrot_ScrollAreas_OffsetBox_" .. k, UIParent)
		local midPoint = CreateFrame("Frame", "Parrot_ScrollAreas_OffsetBox_" .. k .. "_Midpoint", offsetBox)
		offsetBox.midPoint = midPoint
		midPoint:SetWidth(1)
		midPoint:SetHeight(1)
		offsetBoxes[k] = offsetBox
		offsetBox:SetPoint("CENTER", midPoint, "CENTER")
		offsetBox:SetWidth(300)
		offsetBox:SetHeight(100)
		offsetBox:SetFrameStrata("MEDIUM")

		local bg = offsetBox:CreateTexture("Parrot_ScrollAreas_OffsetBox_" .. k .. "_Background", "BACKGROUND")
		bg:SetColorTexture(0.7, 0.4, 0, 0.5) -- orange
		bg:SetAllPoints(offsetBox)

		local text = offsetBox:CreateFontString("Parrot_ScrollAreas_Offset_" .. k .. "_BoxText", "ARTWORK", "GameFontHighlight")
		offsetBox.text = text
		text:SetText(L["Click and drag to the position you want."])
		text:SetPoint("CENTER")
		local topText = offsetBox:CreateFontString("Parrot_ScrollAreas_Offset_" .. k .. "_BoxTopText", "ARTWORK", "GameFontHighlight")
		offsetBox.topText = topText
		topText:SetText(L["Scroll area: %s"]:format(name))
		topText:SetPoint("BOTTOM", offsetBox, "TOP", 0, 5)
		local bottomText = offsetBox:CreateFontString("Parrot_ScrollAreas_Offset_" .. k .. "_BoxBottomText", "ARTWORK", "GameFontHighlight")
		offsetBox.bottomText = bottomText
		bottomText:SetPoint("TOP", offsetBox, "BOTTOM", 0, -5)

		offsetBox:SetScript("OnDragStart", function(this)
				midPoint:StartMoving()
				this.moving = true
		end)

		offsetBox:SetScript("OnDragStop", function(this)
				this:GetScript("OnUpdate")(this)
				this.moving = nil
				midPoint:StopMovingOrSizing()
		end)

		offsetBox:SetScript("OnUpdate", function(this)
				if this.moving then
					local x, y = this:GetCenter()
					x = x - GetScreenWidth()/2
					y = y - GetScreenHeight()/2
					scrollAreas[k].xOffset = x
					scrollAreas[k].yOffset = y
					this.bottomText:SetText(L["Position: %d, %d"]:format(x, y))
				end
		end)

		offsetBox:SetMovable(true)
		offsetBox:RegisterForDrag("LeftButton")
		midPoint:SetMovable(true)
		midPoint:RegisterForDrag("LeftButton")
		offsetBox:Hide()

		midPoint:SetClampedToScreen(true)
	end

	offsetBox:Show()

	local offsetX, offsetY = scrollAreas[k].xOffset, scrollAreas[k].yOffset
	offsetBox.midPoint:SetPoint("CENTER", UIParent, "CENTER", offsetX, offsetY)
	offsetBox.bottomText:SetText(L["Position: %d, %d"]:format(offsetX, offsetY))
end

local alphabet = {
	"Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf",
	"Hotel", "India", "Juliet", "Kilo", "Mike", "November", "Oscar",
	"Papa", "Quebec", "Romeo", "Sierra", "Tango", "Uniform", "Victor",
	"Whiskey", "X-ray", "Yankee", "Zulu",
}
local currentAlphabet = 1
local currentColor = 0
local function test(kind, k)
	local h = currentColor / 60
	local i = math.floor(h)
	local f = h - i
	local color
	local r, g, b
	if i == 0 then
		r, g, b = 1, f, 0
	elseif i == 1 then
		r, g, b = 1-f, 1, 0
	elseif i == 2 then
		r, g, b = 0, 1, f
	elseif i == 3 then
		r, g, b = 0, 1-f, 1
	elseif i == 4 then
		r, g, b = f, 0, 1
	else -- 5
		r, g, b = 1, 0, 1-f
	end
	Parrot:GetModule("Display"):ShowMessage(alphabet[currentAlphabet], k, kind == "sticky", r, g, b, nil, nil, nil, "Interface\\Icons\\INV_Misc_QuestionMark")
	currentAlphabet = (currentAlphabet%(#alphabet)) + 1
	currentColor = (currentColor + 10) % 360
end


local num = 0
local function configModeMessages()
	num = num%2 + 1
	for k in pairs(scrollAreas) do
		test("normal", k)
	end
	if num == 2 then
		for k in pairs(scrollAreas) do
			test("sticky", k)
		end
	end
end

local configMode = false
function setConfigMode(value)
	configMode = value
	if not value then
		hideAllOffsetBoxes()
	else
		for k in pairs(scrollAreas) do
			showOffsetBox(k)
		end
		configModeTimer = Parrot_ScrollAreas:ScheduleRepeatingTimer(configModeMessages, 1)
		configModeMessages()
	end
end

-- #NODOC
function Parrot_ScrollAreas:HasScrollArea(name)
	return not not scrollAreas[name]
end

-- #NODOC
function Parrot_ScrollAreas:GetScrollArea(name)
	return scrollAreas[name]
end

-- #NODOC
function Parrot_ScrollAreas:GetRandomScrollArea()
	local i = 0
	for k, v in pairs(scrollAreas) do
		i = i + 1
	end
	local num = math.random(1, i)
	i = 0
	for k, v in pairs(scrollAreas) do
		i = i + 1
		if i == num then
			return k, v
		end
	end
	return
end

--[[----------------------------------------------------------------------------------
Notes:
	This is to be used for LibRockConfig-1.0 tables.
Returns:
	table - A choices table for LibRockConfig-1.0 tables.
Example:
	{
		type = 'text',
		name = "Scroll area",
		desc = "Scroll area to use in Parrot.",
		choices = Parrot:GetScrollAreasChoices(),
		get = getScrollArea,
		set = setScrollArea,
	}
------------------------------------------------------------------------------------]]
function Parrot_ScrollAreas:GetScrollAreasChoices()
	return choices
end
Parrot.GetScrollAreasChoices = Parrot_ScrollAreas.GetScrollAreasChoices

function Parrot_ScrollAreas:OnOptionsCreate()

	local scrollAreas_opt
	local function getName(info)
		local name = info.arg
		if choicesBase[name] then
			name = choicesBase[name]
		end
		return name
	end
	local function setName(info, new)
		local old = info.arg
		if old == new or scrollAreas[new] then
			return
		end
		local shouldConfig = configMode
		if shouldConfig then
			setConfigMode(false)
		end
		local v = scrollAreas[old]
		scrollAreas[old] = nil
		scrollAreas[new] = v
		local opt = scrollAreas_opt.args[tostring(v)]
		local name = new
		if choicesBase[name] then
			name = choicesBase[name]
		end
		choices[old] = nil
		choices[new] = name
		if new == L["New scroll area"] then
			opt.order = -110
		else
			opt.order = -100
		end
		opt.name = name
		opt.args.name.arg = new
		opt.args.remove.arg = new
		opt.args.size.arg = new
		opt.args.test.args.normal.arg[2] = new
		opt.args.test.args.sticky.arg[2] = new
		opt.args.direction.args.normal.arg[2] = new
		opt.args.direction.args.sticky.arg[2] = new
		opt.args.animationStyle.args.normal.arg[2] = new
		opt.args.animationStyle.args.sticky.arg[2] = new
		opt.args.speed.args.normal.arg[2] = new
		opt.args.speed.args.sticky.arg[2] = new
		opt.args.icon.arg = new
		opt.args.positionX.arg = new
		opt.args.positionY.arg = new
		opt.args.font.args.fontface.arg[2] = new
		opt.args.font.args.fontSizeInherit.arg[2] = new
		opt.args.font.args.fontSize.arg[2] = new
		opt.args.font.args.fontOutline.arg[2] = new
		opt.args.font.args.stickyfontface.arg[2] = new
		opt.args.font.args.stickyfontSizeInherit.arg[2] = new
		opt.args.font.args.stickyfontSize.arg[2] = new
		opt.args.font.args.stickyfontOutline.arg[2] = new
		if shouldConfig then
			setConfigMode(true)
		end
		rebuildChoices()
	end
	local function getFontFace(info)
		local kind, k = info.arg[1], info.arg[2]
		local font = scrollAreas[k][kind == "normal" and "font" or "stickyFont"]
		if font == nil then
			return "1"
		else
			return font
		end
	end
	local function setFontFace(info, value)
		local kind, k = info.arg[1], info.arg[2]
		if value == "1" then
			value = nil
		end
		scrollAreas[k][kind == "normal" and "font" or "stickyFont"] = value
		if not configMode then
			test(kind, k)
		end
	end
	local function getFontSize(info)
		local kind, k = info.arg[1], info.arg[2]
		return scrollAreas[k][kind == "normal" and "fontSize" or "stickyFontSize"]
	end
	local function setFontSize(info, value)
		local kind, k = info.arg[1], info.arg[2]
		scrollAreas[k][kind == "normal" and "fontSize" or "stickyFontSize"] = value
		if not configMode then
			test(kind, k)
		end
	end
	local function getFontSizeInherit(info)
		local kind, k = info.arg[1], info.arg[2]
		return scrollAreas[k][kind == "normal" and "fontSize" or "stickyFontSize"] == nil
	end
	local function setFontSizeInherit(info, value)
		local kind, k = info.arg[1], info.arg[2]
		if value then
			scrollAreas[k][kind == "normal" and "fontSize" or "stickyFontSize"] = nil
		else
			scrollAreas[k][kind == "normal" and "fontSize" or "stickyFontSize"] = 18
		end
		if not configMode then
			test(kind, k)
		end
	end
	local function getFontOutline(info)
		local kind, k = info.arg[1], info.arg[2]
		local outline = scrollAreas[k][kind == "normal" and "fontOutline" or "stickyFontOutline"]
		if outline == nil then
			return L["Inherit"]
		else
			return outline
		end
	end
	local function setFontOutline(info, value)
		local kind, k = info.arg[1], info.arg[2]
		if value == L["Inherit"] then
			value = nil
		end
		scrollAreas[k][kind == "normal" and "fontOutline" or "stickyFontOutline"] = value
		if not configMode then
			test(kind, k)
		end
	end
	local fontOutlineChoices = {
		NONE = L["None"],
		OUTLINE = L["Thin"],
		THICKOUTLINE = L["Thick"],
		[L["Inherit"]] = L["Inherit"],
	}
	local function getAnimationStyle(info)
		local kind, k = info.arg[1], info.arg[2]
		return scrollAreas[k][kind == "normal" and "animationStyle" or "stickyAnimationStyle"]
	end
	local function setAnimationStyle(info, value)
		local kind, k = info.arg[1], info.arg[2]
		scrollAreas[k][kind == "normal" and "animationStyle" or "stickyAnimationStyle"] = value
		local opt = scrollAreas_opt.args[tostring(scrollAreas[k])]
		local choices = Parrot:GetModule("AnimationStyles"):GetAnimationStyleDirectionChoices(value)
		opt.args.direction.args[kind].values = choices
		if not choices[scrollAreas[k][kind == "normal" and "direction" or "stickyDirection"]] then
			scrollAreas[k][kind == "normal" and "direction" or "stickyDirection"] = Parrot:GetModule("AnimationStyles"):GetAnimationStyleDefaultDirection(value)
		end
		if not configMode then
			test(kind, k)
			test(kind, k)
			test(kind, k)
		end
	end
	local function getSpeed(info)
		local kind, k = info.arg[1], info.arg[2]
		return scrollAreas[k][kind == "normal" and "speed" or "stickySpeed"] or 3
	end
	local function setSpeed(info, value)
		local kind, k = info.arg[1], info.arg[2]
		if value == 3 then
			value = nil
		end
		scrollAreas[k][kind == "normal" and "speed" or "stickySpeed"] = value
		if not configMode then
			test(kind, k)
		end
	end
	local function getDirection(info)
		local kind, k = info.arg[1], info.arg[2]
		return scrollAreas[k][kind == "normal" and "direction" or "stickyDirection"] or Parrot:GetModule("AnimationStyles"):GetAnimationStyleDefaultDirection(scrollAreas[k][kind == "normal" and "animationStyle" or "stickyAnimationStyle"])
	end
	local function setDirection(info, value)
		local kind, k = info.arg[1], info.arg[2]
		if value == Parrot:GetModule("AnimationStyles"):GetAnimationStyleDefaultDirection(scrollAreas[k][kind == "normal" and "animationStyle" or "stickyAnimationStyle"]) then
			value = nil
		end
		scrollAreas[k][kind == "normal" and "direction" or "stickyDirection"] = value
		if not configMode then
			test(kind, k)
			test(kind, k)
			test(kind, k)
		end
	end
	local function directionDisabled(info)
		local kind, k = info.arg[1], info.arg[2]
		return not Parrot:GetModule("AnimationStyles"):GetAnimationStyleDirectionChoices(scrollAreas[k][kind == "normal" and "animationStyle" or "stickyAnimationStyle"])
	end
	local function getPositionX(info)
		return scrollAreas[info.arg].xOffset
	end
	local function setPositionX(info, value)
		local k = info.arg
		if value > 0 then
			if value > GetScreenWidth()/2 then
				value = GetScreenWidth()/2
			end
		else
			if value < -GetScreenWidth()/2 then
				value = -GetScreenWidth()/2
			end
		end
		scrollAreas[k].xOffset = value
		if not configMode then
			test("normal", k)
			test("sticky", k)
		end
	end
	local function getPositionY(info)
		return scrollAreas[info.arg].yOffset
	end
	local function setPositionY(info, value)
		local k = info.arg
		if value > 0 then
			if value > GetScreenHeight()/2 then
				value = GetScreenHeight()/2
			end
		else
			if value < -GetScreenHeight()/2 then
				value = -GetScreenHeight()/2
			end
		end
		scrollAreas[k].yOffset = value
		if not configMode then
			test("normal", k)
			test("sticky", k)
		end
	end
	local function getSize(info)
		return scrollAreas[info.arg].size
	end
	local function setSize(info, value)
		local k = info.arg
		scrollAreas[k].size = value
		if not configMode then
			test("normal", k)
			test("sticky", k)
		end
	end
	local function remove(info)
		local k = info.arg
		local shouldConfig = configMode
		if shouldConfig then
			setConfigMode(false)
		end
		scrollAreas_opt.args[tostring(scrollAreas[k])] = nil
		scrollAreas[k] = nil
		choices[k] = nil
		if shouldConfig then
			setConfigMode(true)
		end
	end
	local function disableRemove(info)
		return not next(scrollAreas, next(scrollAreas))
	end
	local function getIconSide(info)
		return scrollAreas[info.arg].iconSide or "LEFT"
	end
	local function setIconSide(info, value)
		local k = info.arg
		if value == "LEFT" then
			value = nil
		end
		scrollAreas[k].iconSide = value
		if not configMode then
			test("normal", k)
			test("sticky", k)
		end
	end
	local iconSideChoices = {
		LEFT = L["Left"],
		RIGHT = L["Right"],
		CENTER = L["Center of screen"],
		EDGE = L["Edge of screen"],
		DISABLE = L["Disable"],
	}

	local function makeOption(k)
		local SharedMedia = LibStub("LibSharedMedia-3.0")
		local v = scrollAreas[k]
		local name = choicesBase[k] or k
		local opt = {
			type = 'group',
			name = name,
			desc = L["Options for this scroll area."],
			args = {
				name = {
					type = 'input',
					name = L["Name"],
					desc = L["Name of the scroll area."],
					get = getName,
					set = setName,
					usage = L["<Name>"],
					arg = k,
					order = 1,
				},
				remove = {
					type = 'execute',
					name = L["Remove"],
					desc = L["Remove this scroll area."],
					func = remove,
					disabled = disableRemove,
					arg = k,
					order = -1,
					confirm = true,
					confirmText = L["Are you sure?"],
				},
				icon = {
					type = 'select',
					name = L["Icon side"],
					desc = L["Set the icon side for this scroll area or whether to disable icons entirely."],
					get = getIconSide,
					set = setIconSide,
					values = iconSideChoices,
					arg = k,
				},
				test = {
					type = 'group',
					inline = true,
					name = L["Test"],
					desc = L["Send a test message through this scroll area."],
					args = {
						normal = {
							type = 'execute',
							name = L["Normal"],
							desc = L["Send a normal test message."],
							func = function(info) test(info.arg[1], info.arg[2]) end,
							arg = {"normal", k},
						},
						sticky = {
							type = 'execute',
							name = L["Sticky"],
							desc = L["Send a sticky test message."],
							func = function(info) test(info.arg[1], info.arg[2]) end,
							arg = {"sticky", k},
						},
					},
					disabled = function() return configMode end
				},
				direction = {
					type = 'group',
					inline = true,
					name = L["Direction"],
					desc = L["Which direction the animations should follow."],
					args = {
						normal = {
							type = 'select',
							name = L["Normal"],
							desc = L["Direction for normal texts."],
							get = getDirection,
							set = setDirection,
							disabled = directionDisabled,
							values = Parrot:GetModule("AnimationStyles"):GetAnimationStyleDirectionChoices(scrollAreas[k].animationStyle) or {},
							arg = {"normal", k},
						},
						sticky = {
							type = 'select',
							name = L["Sticky"],
							desc = L["Direction for sticky texts."],
							get = getDirection,
							set = setDirection,
							disabled = directionDisabled,
							values = Parrot:GetModule("AnimationStyles"):GetAnimationStyleDirectionChoices(scrollAreas[k].stickyAnimationStyle) or {},
							arg = {"sticky", k},
						},
					}
				},
				animationStyle = {
					type = 'group',
					inline = true,
					name = L["Animation style"],
					desc = L["Which animation style to use."],
					args = {
						normal = {
							type = 'select',
							name = L["Normal"],
							desc = L["Animation style for normal texts."],
							get = getAnimationStyle,
							set = setAnimationStyle,
							values = Parrot:GetModule("AnimationStyles"):GetAnimationStylesChoices(),
							arg = {"normal", k},
						},
						sticky = {
							type = 'select',
							name = L["Sticky"],
							desc = L["Animation style for sticky texts."],
							get = getAnimationStyle,
							set = setAnimationStyle,
							values = Parrot:GetModule("AnimationStyles"):GetAnimationStylesChoices(),
							arg = {"sticky", k},
						},
					}
				},
				positionX = {
					type = 'range',
					name = L["Position: horizontal"],
					desc = L["The position of the box across the screen"],
					get = getPositionX,
					set = setPositionX,
					min = math.floor(-GetScreenWidth()/GetScreenHeight()*768 / 0.64 / 2 / 10) * 10,
					max = math.ceil(GetScreenWidth()/GetScreenHeight()*768 / 0.64 / 2 / 10) * 10,
					step = 1,
					bigStep = 10,
					arg = k,
				},
				positionY = {
					type = 'range',
					name = L["Position: vertical"],
					desc = L["The position of the box up-and-down the screen"],
					get = getPositionY,
					set = setPositionY,
					min = math.floor(-768 / 0.64 / 2 / 10) * 10,
					max = math.ceil(768 / 0.64 / 2 / 10) * 10,
					step = 1,
					bigStep = 10,
					arg = k,
				},
				size = {
					type = 'range',
					name = L["Size"],
					desc = L["How large of an area to scroll."],
					get = getSize,
					set = setSize,
					min = 50,
					max = 800,
					step = 1,
					bigStep = 10,
					arg = k,
				},
				speed = {
					type = 'group',
					inline = true,
					name = L["Scrolling speed"],
					desc = L["How fast the text scrolls by."],
					args = {
						normal = {
							type = 'range',
							name = L["Normal"],
							desc = L["Seconds for the text to complete the whole cycle, i.e. larger numbers means slower."],
							min = 1,
							max = 20,
							step = 0.1,
							bigStep = 1,
							get = getSpeed,
							set = setSpeed,
							arg = {"normal", k},
						},
						sticky = {
							type = 'range',
							name = L["Sticky"],
							desc = L["Seconds for the text to complete the whole cycle, i.e. larger numbers means slower."],
							min = 1,
							max = 20,
							step = 0.1,
							bigStep = 1,
							get = getSpeed,
							set = setSpeed,
							arg = {"sticky", k},
						},
					}
				},
				font = {
					type = 'group',
					inline = true,
					name = L["Custom font"],
					desc = L["Custom font"],
					args = {
						fontface = {
							type = 'select',
							name = L["Normal font face"],
							desc = L["Normal font face"],
							values = Parrot.inheritFontChoices(),
							get = getFontFace,
							set = setFontFace,
							arg = {"normal", k},

							order = 1,
						},
						fontSizeInherit = {
							type = 'toggle',
							name = L["Normal inherit font size"],
							desc = L["Normal inherit font size"],
							get = getFontSizeInherit,
							set = setFontSizeInherit,
							arg = {"normal", k},
							order = 2,
						},
						fontSize = {
							type = 'range',
							name = L["Normal font size"],
							desc = L["Normal font size"],
							min = 12,
							max = 30,
							step = 1,
							get = getFontSize,
							set = setFontSize,
							disabled = getFontSizeInherit,
							arg = {"normal", k},

							order = 3,
						},
						fontOutline = {
							type = 'select',
							name = L["Normal font outline"],
							desc = L["Normal font outline"],
							get = getFontOutline,
							set = setFontOutline,
							values = fontOutlineChoices,
							arg = {"normal", k},

							order = 4,
						},
						stickyfontface = {
							type = 'select',
							name = L["Sticky font face"],
							desc = L["Sticky font face"],
							values = Parrot.inheritFontChoices,
							get = getFontFace,
							set = setFontFace,
							arg = {"sticky", k},

							order = 5,
						},
						stickyfontSizeInherit = {
							type = 'toggle',
							name = L["Sticky inherit font size"],
							desc = L["Sticky inherit font size"],
							get = getFontSizeInherit,
							set = setFontSizeInherit,
							arg = {"sticky", k},

							order = 6,
						},
						stickyfontSize = {
							type = 'range',
							name = L["Sticky font size"],
							desc = L["Sticky font size"],
							min = 12,
							max = 30,
							step = 1,
							get = getFontSize,
							set = setFontSize,
							disabled = getFontSizeInherit,
							arg = {"sticky", k},

							order = 7,
						},
						stickyfontOutline = {
							type = 'select',
							name = L["Sticky font outline"],
							desc = L["Sticky font outline"],
							get = getFontOutline,
							set = setFontOutline,
							values = fontOutlineChoices,
							arg = {"sticky", k},

							order = 8,
						},
					}
				}
			},
			order = -100,
		}
		scrollAreas_opt.args[tostring(v)] = opt
	end

	scrollAreas_opt = {
		type = 'group',
		name = L["Scroll areas"],
		desc = L["Options regarding scroll areas."],
		disabled = function()
			return not self:IsEnabled()
		end,
		order = 5,
		args = {
			config = {
				type = 'toggle',
				name = L["Configuration mode"],
				desc = L["Enter configuration mode, allowing you to move around the scroll areas and see them in action."],
				get = function()
					return configMode
				end,
				set = function(info, value) setConfigMode(value) end,
			},
			new = {
				type = 'execute',
				name = L["New scroll area"],
				desc = L["Add a new scroll area."],
				func = function()
					local shouldConfig = configMode
					if shouldConfig then
						setConfigMode(false)
					end
					scrollAreas[L["New scroll area"]] = {
						animationStyle = "Straight",
						direction = Parrot:GetModule("AnimationStyles"):GetAnimationStyleDefaultDirection("Straight"),
						stickyAnimationStyle = "Pow",
						direction = Parrot:GetModule("AnimationStyles"):GetAnimationStyleDefaultDirection("Pow"),
						size = 150,
						xOffset = 0,
						yOffset = 0,
					}
					makeOption(L["New scroll area"])
					scrollAreas_opt.args[tostring(scrollAreas[L["New scroll area"]])].order = -110
					rebuildChoices()
					if shouldConfig then
						setConfigMode(true)
					end
				end,
				disabled = function()
					return scrollAreas[L["New scroll area"]]
				end
			}
		},
	}
	Parrot:AddOption('scrollAreas', scrollAreas_opt)
	scrollAreas = self.db1.profile.areas
	for k, v in pairs(scrollAreas) do
		makeOption(k)
		if k == L["New scroll area"] then
			scrollAreas_opt.args[tostring(v)].order = -110
		end
	end
end
