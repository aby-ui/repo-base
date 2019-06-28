-- ***************************************************
-- **               Deadly Bar Timers               **
-- **         http://www.deadlybossmods.com         **
-- ***************************************************
--
-- This addon is written and copyrighted by:
--    * Paul Emmerich (Tandanu @ EU-Aegwynn) (DBM-Core)
--    * Martin Verges (Nitram @ EU-Azshara) (DBM-GUI)
--
-- The localizations are written by:
--    * enGB/enUS: Tandanu				http://www.deadlybossmods.com
--    * deDE: Tandanu					http://www.deadlybossmods.com
--    * zhCN: Diablohu					http://wow.gamespot.com.cn
--    * ruRU: BootWin					bootwin@gmail.com
--    * ruRU: Vampik					admin@vampik.ru
--    * zhTW: Hman						herman_c1@hotmail.com
--    * zhTW: Azael/kc10577				paul.poon.kw@gmail.com
--    * koKR: BlueNyx/nBlueWiz			bluenyx@gmail.com / everfinale@gmail.com
--    * esES: Snamor/1nn7erpLaY      	romanscat@hotmail.com
--
-- Special thanks to:
--    * Arta
--    * Omegal @ US-Whisperwind (continuing mod support for 3.2+)
--    * Tennberg (a lot of fixes in the enGB/enUS localization)
--
--
-- The code of this addon is licensed under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 License. (see license.txt)
-- All included textures and sounds are copyrighted by their respective owners.
--
--
--  You are free:
--    * to Share ?to copy, distribute, display, and perform the work
--    * to Remix ?to make derivative works
--  Under the following conditions:
--    * Attribution. You must attribute the work in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the work).
--    * Noncommercial. You may not use this work for commercial purposes.
--    * Share Alike. If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.


---------------
--  Globals  --
---------------
DBT = {}
DBT_PersistentOptions = {}


--------------
--  Locals  --
--------------
local barPrototype = {}
local unusedBars = {}
local unusedBarObjects = setmetatable({}, {__mode = "kv"})
local updateClickThrough
local options
local setupHandlers
local applyFailed = false
local barIsAnimating = false
local function stringFromTimer(t)
	if t <= DBM.Bars:GetOption("TDecimal") then
		return ("%.1f"):format(t)
	elseif t <= 60 then
		return ("%d"):format(t)
	else
		return ("%d:%0.2d"):format(t/60, math.fmod(t, 60))
	end
end

local ipairs, pairs, next, type = ipairs, pairs, next, type
local tinsert = table.insert
local GetTime = GetTime

--Hard code STANDARD_TEXT_FONT since skinning mods like to taint it (or worse, set it to nil, wtf?)
local standardFont = STANDARD_TEXT_FONT
if (LOCALE_koKR) then
	standardFont = "Fonts\\2002.TTF"
elseif (LOCALE_zhCN) then
	standardFont = "Fonts\\ARKai_T.ttf"
elseif (LOCALE_zhTW) then
	standardFont = "Fonts\\blei00d.TTF"
elseif (LOCALE_ruRU) then
	standardFont = "Fonts\\FRIZQT___CYR.TTF"
else
	standardFont = "Fonts\\FRIZQT__.TTF"
end


-----------------------
--  Default Options  --
-----------------------
options = {
	BarXOffset = {
		type = "number",
		default = 0,
	},
	BarYOffset = {
		type = "number",
		default = 0,
	},
	HugeBarXOffset = {
		type = "number",
		default = 0,
	},
	HugeBarYOffset = {
		type = "number",
		default = 0,
	},
	ExpandUpwards = {
		type = "boolean",
		default = false,
	},
	ExpandUpwardsLarge = {
		type = "boolean",
		default = false,
	},
	Flash = {
		type = "boolean",
		default = true,
	},
	Spark = {
		type = "boolean",
		default = true,
	},
	Sort = {
		type = "boolean",
		default = true,
	},
	ColorByType = {
		type = "boolean",
		default = true,
	},
	InlineIcons = {
		type = "boolean",
		default = true,
	},
	IconLeft = {
		type = "boolean",
		default = true,
	},
	IconRight = {
		type = "boolean",
		default = false,
	},
	IconLocked = {
		type = "boolean",
		default = true,
	},
	Texture = {
		type = "string",
		default = "Interface\\AddOns\\DBM-DefaultSkin\\textures\\default.blp",
	},
	StartColorR = {
		type = "number",
		default = 1,
	},
	StartColorG = {
		type = "number",
		default = 0.7,
	},
	StartColorB = {
		type = "number",
		default = 0,
	},
	EndColorR = {
		type = "number",
		default = 1,
	},
	EndColorG = {
		type = "number",
		default = 0,
	},
	EndColorB = {
		type = "number",
		default = 0,
	},
	--Type 1 (Add)
	StartColorAR = {
		type = "number",
		default = 0.375,
	},
	StartColorAG = {
		type = "number",
		default = 0.545,
	},
	StartColorAB = {
		type = "number",
		default = 1,
	},
	EndColorAR = {
		type = "number",
		default = 0.15,
	},
	EndColorAG = {
		type = "number",
		default = 0.385,
	},
	EndColorAB = {
		type = "number",
		default = 1,
	},
	--Type 2 (AOE)
	StartColorAER = {
		type = "number",
		default = 1,
	},
	StartColorAEG = {
		type = "number",
		default = 0.466,
	},
	StartColorAEB = {
		type = "number",
		default = 0.459,
	},
	EndColorAER = {
		type = "number",
		default = 1,
	},
	EndColorAEG = {
		type = "number",
		default = 0.043,
	},
	EndColorAEB = {
		type = "number",
		default = 0.247,
	},
	--Type 3 (Targeted)
	StartColorDR = {
		type = "number",
		default = 0.9,
	},
	StartColorDG = {
		type = "number",
		default = 0.3,
	},
	StartColorDB = {
		type = "number",
		default = 1,
	},
	EndColorDR = {
		type = "number",
		default = 1,
	},
	EndColorDG = {
		type = "number",
		default = 0,
	},
	EndColorDB = {
		type = "number",
		default = 1,
	},
	--Type 4 (Interrupt)
	StartColorIR = {
		type = "number",
		default = 0.47,
	},
	StartColorIG = {
		type = "number",
		default = 0.97,
	},
	StartColorIB = {
		type = "number",
		default = 1,
	},
	EndColorIR = {
		type = "number",
		default = 0.047,
	},
	EndColorIG = {
		type = "number",
		default = 0.88,
	},
	EndColorIB = {
		type = "number",
		default = 1,
	},
	--Type 5 (Role)
	StartColorRR = {
		type = "number",
		default = 0.5,
	},
	StartColorRG = {
		type = "number",
		default = 1,
	},
	StartColorRB = {
		type = "number",
		default = 0.5,
	},
	EndColorRR = {
		type = "number",
		default = 0.11,
	},
	EndColorRG = {
		type = "number",
		default = 1,
	},
	EndColorRB = {
		type = "number",
		default = 0.3,
	},
	--Type 6 (Phase)
	StartColorPR = {
		type = "number",
		default = 1,
	},
	StartColorPG = {
		type = "number",
		default = 0.776,
	},
	StartColorPB = {
		type = "number",
		default = 0.420,
	},
	EndColorPR = {
		type = "number",
		default = 0.5,
	},
	EndColorPG = {
		type = "number",
		default = 0.41,
	},
	EndColorPB = {
		type = "number",
		default = 0.285,
	},
	--Type 7 (Important/User set only)
	StartColorUIR = {
		type = "number",
		default = 1,
	},
	StartColorUIG = {
		type = "number",
		default = 1,
	},
	StartColorUIB = {
		type = "number",
		default = 0.0627450980392157,
	},
	EndColorUIR = {
		type = "number",
		default = 1,
	},
	EndColorUIG = {
		type = "number",
		default = 0.92156862745098,
	},
	EndColorUIB = {
		type = "number",
		default = 0.0117647058823529,
	},
	Bar7ForceLarge = {
		type = "boolean",
		default = false,
	},
	Bar7CustomInline = {
		type = "boolean",
		default = true,
	},
	TextColorR = {
		type = "number",
		default = 1,
	},
	TextColorG = {
		type = "number",
		default = 1,
	},
	TextColorB = {
		type = "number",
		default = 1,
	},
	DynamicColor = {
		type = "boolean",
		default = true,
	},
	Width = {
		type = "number",
		default = 183,
	},
	Height = {
		type = "number",
		default = 20,
	},
	TDecimal = {
		type = "number",
		default = 11,
	},
	Alpha = {
		type = "number",
		default = 0.8,
	},
	Scale = {
		type = "number",
		default = 0.9,
	},
	HugeBarsEnabled = {
		type = "boolean",
		default = true,
	},
	HugeWidth = {
		type = "number",
		default = 200,
	},
	HugeAlpha = {
		type = "number",
		default = 1,
	},
	HugeScale = {
		type = "number",
		default = 1.03,
	},
	TimerPoint = {
		type = "string",
		default = "TOPRIGHT",
	},
	TimerX = {
		type = "number",
		default = -223,
	},
	TimerY = {
		type = "number",
		default = -260,
	},
	HugeTimerPoint = {
		type = "string",
		default = "CENTER",
	},
	HugeTimerX = {
		type = "number",
		default = 0,
	},
	HugeTimerY = {
		type = "number",
		default = -120,
	},
	EnlargeBarTime = {
		type = "number",
		default = 11,
	},
	EnlargeBarsPercent = {
		type = "number",
		default = 0.125,
	},
	FillUpBars = {
		type = "boolean",
		default = true,
	},
	FillUpLargeBars = {
		type = "boolean",
		default = true,
	},
	ClickThrough = {
		type = "boolean",
		default = false,
	},
	Font = {
		type = "string",
		default = standardFont,
	},
	FontFlag = {
		type = "string",
		default = "None",
	},
	FontSize = {
		type = "number",
		default = 10
	},
	Template = {
		type = "string",
		default = "DBTBarTemplate"
	},
	Skin = {
		type = "string",
		default = "DefaultSkin"
	},
	BarStyle = {
		type = "string",
		default = "NoAnim",
	},
	KeepBars = {
		type = "boolean",
		default = true,
	},
	FadeBars = {
		type = "boolean",
		default = true,
	},
}


--------------------------
--  Double Linked List  --
--------------------------

local DLL = {}
DLL.__index = DLL

function DLL:Append(obj)
	if self.first == nil then -- list is empty
		self.first = obj
		self.last = obj
		obj:SetPosition()
	elseif not obj.owner.options.Sort then -- list is not emty
		obj.prev = self.last
		self.last.next = obj
		self.last = obj
		obj:SetPosition()
	else
		local ptr = self.first
		local barInserted = false
		while ptr do
			if not barInserted then
				if ptr.timer > obj.timer then
					if ptr == self.first then
						obj.prev = nil
						obj.next = self.first
						self.first.prev = obj
						self.first = obj
						obj:SetPosition()
						ptr.moving = nil
						ptr:SetPosition()
					else
						obj.prev = ptr.prev
						obj.next = ptr
						obj.prev.next = obj
						obj.next.prev = obj
						obj:SetPosition()
						ptr.moving = nil
						ptr:SetPosition()
					end
					barInserted = true
				end
			end
			ptr = ptr.next
		end
		if not barInserted then
			obj.prev = self.last
			obj.next = nil
			self.last.next = obj
			self.last = obj
			obj:SetPosition()
		end
	end
	return obj
end

function DLL:Remove(obj)
	if self.first == nil then -- list is empty...
		-- ...meaning the object is not even in the list, nothing we can do here expect for removing the "prev" and "next" entries from obj
	elseif self.first == obj and self.last == obj then -- list has only one element
		self.first = nil
		self.last = nil
	elseif self.first == obj then -- trying to remove the first element
		self.first = obj.next
		self.first.prev = nil
		self.first:MoveToNextPosition()
	elseif self.last == obj then -- trying to remove the last element
		self.last = obj.prev
		self.last.next = nil
	elseif obj.prev and obj.next then -- trying to remove something in the middle of the list
		obj.prev.next, obj.next.prev = obj.next, obj.prev
		obj.next:MoveToNextPosition()
	end
	obj.prev = nil
	obj.next = nil
end

function DLL:New()
	return setmetatable({
		first = nil,
		last = nil
	}, self)
end
setmetatable(DLL, {__call = DLL.New})


-------------------------------
--  DBT Constructor/Options  --
-------------------------------
do
	local mt = {__index = DBT}
	local optionMT = {
		__index = function(t, k)
			if options[k] then
				return options[k].default
			else
				return nil
			end
		end
	}

	function DBT:New()
		local obj = setmetatable(
			{
				options = setmetatable({}, optionMT),
				defaultOptions = setmetatable({}, optionMT),
				mainAnchor = CreateFrame("Frame", nil, UIParent),
				secAnchor = CreateFrame("Frame", nil, UIParent),
				bars = {},
				smallBars = DLL(),
				hugeBars = DLL()
			},
			mt
		)
		obj.mainAnchor:SetHeight(1)
		obj.mainAnchor:SetWidth(1)
		obj.mainAnchor:SetPoint("TOPRIGHT", 223, -260)
		obj.mainAnchor:SetClampedToScreen(true)
		obj.mainAnchor:SetMovable(true)
		obj.mainAnchor:Show()
		obj.secAnchor:SetHeight(1)
		obj.secAnchor:SetWidth(1)
		obj.secAnchor:SetPoint("CENTER", 0, -120)
		obj.secAnchor:SetClampedToScreen(true)
		obj.secAnchor:SetMovable(true)
		obj.secAnchor:Show()
		return obj
	end

	local function delaySkinCheck(self)
		local skins = self:GetSkins()
		if not skins then--Returns nil if checked too soon
			DBM:Schedule(3, delaySkinCheck, self)
			return
		end
		local enabled = GetAddOnEnableState(UnitName("player"), "DBM-DefaultSkin")
		local loaded = "nil"
		if skins and self and self.options and self.options.Skin and skins[self.options.Skin] and skins[self.options.Skin].loaded then
			loaded = tostring(skins[self.options.Skin].loaded)
		else
			DBM:Debug("delaySkinCheck detected corrupt skin settings attempting set back to DefaultSkin")
		end
		if enabled and enabled ~= 0 and loaded ~= "true" then
			-- The currently set skin is no longer loaded, revert to DefaultSkin. If enabled (else, person wants textureless bar on purpose)
			self:SetSkin("DefaultSkin")
			DBM:Debug("delaySkinCheck firing DefaultSkin successful")
		end
	end

	function DBT:LoadOptions(id)
		--init
		if not DBT_AllPersistentOptions then DBT_AllPersistentOptions = {} end
		if not DBT_AllPersistentOptions[_G["DBM_UsedProfile"]] then DBT_AllPersistentOptions[_G["DBM_UsedProfile"]] = {} end
		--migrate old options
		if DBT_PersistentOptions and DBT_PersistentOptions[id] and not DBT_AllPersistentOptions[_G["DBM_UsedProfile"]][id] then
			DBT_AllPersistentOptions[_G["DBM_UsedProfile"]][id] = DBT_PersistentOptions[id]
		end
		DBT_AllPersistentOptions[_G["DBM_UsedProfile"]][id] = DBT_AllPersistentOptions[_G["DBM_UsedProfile"]][id] or {}
		self.options = setmetatable(DBT_AllPersistentOptions[_G["DBM_UsedProfile"]][id], optionMT)
		self:Rearrange()
		DBM:Schedule(2, delaySkinCheck, self)
		if not self.options.Font then--Fix font if it's nil
			self.options.Font = standardFont
		end
		--Repair options from texture conversions
		if self.options.Texture == "Interface\\AddOns\\DBM-DefaultSkin\\textures\\default.tga" then
			self.options.Texture = "Interface\\AddOns\\DBM-DefaultSkin\\textures\\default.blp"
		elseif self.options.Texture == "Interface\\AddOns\\DBM-DefaultSkin\\textures\\smooth.tga" then
			self.options.Texture = "Interface\\AddOns\\DBM-DefaultSkin\\textures\\smooth.blp"
		elseif self.options.Texture == "Interface\\AddOns\\DBM-DefaultSkin\\textures\\glaze.tga" then
			self.options.Texture = "Interface\\AddOns\\DBM-DefaultSkin\\textures\\glaze.blp"
		elseif self.options.Texture == "Interface\\AddOns\\DBM-DefaultSkin\\textures\\otravi.tga" then
			self.options.Texture = "Interface\\AddOns\\DBM-DefaultSkin\\textures\\otravi.blp"
		end
	end

	function DBT:CreateProfile(id)
		if not DBT_AllPersistentOptions[_G["DBM_UsedProfile"]] then DBT_AllPersistentOptions[_G["DBM_UsedProfile"]] = {} end
		DBT_AllPersistentOptions[_G["DBM_UsedProfile"]][id] = DBT_AllPersistentOptions[_G["DBM_UsedProfile"]][id] or {}
		self.options = setmetatable(DBT_AllPersistentOptions[_G["DBM_UsedProfile"]][id], optionMT)
		self:Rearrange()
	end

	function DBT:ApplyProfile(id)
		if not DBT_AllPersistentOptions[_G["DBM_UsedProfile"]] then return end
		self.options = setmetatable(DBT_AllPersistentOptions[_G["DBM_UsedProfile"]][id], optionMT)
		self:Rearrange()
	end

	function DBT:CopyProfile(name, id)
		if not DBT_AllPersistentOptions[_G["DBM_UsedProfile"]] then DBT_AllPersistentOptions[_G["DBM_UsedProfile"]] = {} end
		if not DBT_AllPersistentOptions[_G["DBM_UsedProfile"]][id] then DBT_AllPersistentOptions[_G["DBM_UsedProfile"]][id] = {} end
		if not DBT_AllPersistentOptions[name] then DBT_AllPersistentOptions[name] = {} end
		if not DBT_AllPersistentOptions[name][id] then DBT_AllPersistentOptions[name][id] = {} end
		DBT_AllPersistentOptions[_G["DBM_UsedProfile"]][id] = DBT_AllPersistentOptions[name][id]
		self.options = setmetatable(DBT_AllPersistentOptions[_G["DBM_UsedProfile"]][id], optionMT)
		self:Rearrange()
	end

	function DBT:DeleteProfile(name, id)
		if name == "Default" or not DBT_AllPersistentOptions[name] then return end
		DBT_AllPersistentOptions[name] = nil
		self.options = setmetatable(DBT_AllPersistentOptions[_G["DBM_UsedProfile"]][id], optionMT)
		self:Rearrange()
	end

	function DBT:Rearrange()
		self.mainAnchor:ClearAllPoints()
		self.secAnchor:ClearAllPoints()
		self.mainAnchor:SetPoint(self.options.TimerPoint, UIParent, self.options.TimerPoint, self.options.TimerX, self.options.TimerY)
		self.secAnchor:SetPoint(self.options.HugeTimerPoint, UIParent, self.options.HugeTimerPoint, self.options.HugeTimerX, self.options.HugeTimerY)
		self:ApplyStyle()
	end
end

function DBT:SetOption(option, value)
	if not options[option] then
		error(("Invalid option: %s"):format(tostring(option)), 2)
	elseif options[option].type and type(value) ~= options[option].type then
		error(("The option %s requires a %s value. (tried to assign a %s value)"):format(tostring(option), tostring(options[option].type), tostring(type(value))), 2)
	elseif options[option].checkFunc then
		local ok, errMsg = options[option].checkFunc(self, option, value)
		if not ok then
			error(("Error while setting option %s to %s: %s"):format(tostring(option), tostring(value), tostring(errMsg)), 2)
		end
	end
	local oldValue = self.options[option]
	self.options[option] = value
	if options[option].onChange then
		options[option].onChange(self, value, oldValue)
	end
	self:ApplyStyle()
end

function DBT:GetOption(option)
	return self.options[option]
end

function DBT:GetDefaultOption(option)
	return self.defaultOptions[option]
end


-----------------------
--  Bar Constructor  --
-----------------------
do
	local fCounter = 1
	local function createBarFrame(self)
		local frame
		if unusedBars[#unusedBars] then
			frame = unusedBars[#unusedBars]
			unusedBars[#unusedBars] = nil
		else
			frame = CreateFrame("Frame", "DBT_Bar_"..fCounter, self.mainAnchor, self.options.Template)
			setupHandlers(frame)
			fCounter = fCounter + 1
		end
		frame:EnableMouse(not self.options.ClickThrough or self.movable)
		return frame
	end
	local mt = {__index = barPrototype}

	function DBT:CreateBar(timer, id, icon, huge, small, color, isDummy, colorType, inlineIcon, keep, fade, countdown, countdownMax)
		if timer <= 0 then return end
		if (self.numBars or 0) >= 15 and not isDummy then return end
		--Most efficient place to block it, nil colorType instead of checking option every update
		if not self.options.ColorByType then colorType = nil end
		local newBar = self:GetBar(id)
		if newBar then -- update an existing bar
			newBar.lastUpdate = GetTime()
			newBar.huge = huge or nil
			newBar:SetTimer(timer) -- this can kill the timer and the timer methods don't like dead timers
			if newBar.dead then return end
			newBar:SetElapsed(0) -- same
			if newBar.dead then return end
			newBar:ApplyStyle()
			newBar:SetText(id)
			newBar:SetIcon(icon)
		else -- create a new one
			newBar = next(unusedBarObjects, nil)
			local newFrame = createBarFrame(self)
			if newBar then
				newBar.lastUpdate = GetTime()
				unusedBarObjects[newBar] = nil
				newBar.dead = nil -- resurrected it :)
				newBar.frame = newFrame
				newBar.id = id
				newBar.timer = timer
				newBar.totalTime = timer
				newBar.owner = self
				newBar.moving = nil
				newBar.enlarged = nil
				newBar.fadingIn = 0
				newBar.small = small
				newBar.color = color
				newBar.colorType = colorType
				newBar.flashing = nil
				newBar.inlineIcon = inlineIcon
				newBar.keep = keep
				newBar.fade = fade
				newBar.countdown = countdown
				newBar.countdownMax = countdownMax
			else  -- duplicate code ;(
				newBar = setmetatable({
					frame = newFrame,
					id = id,
					timer = timer,
					totalTime = timer,
					owner = self,
					moving = nil,
					enlarged = nil,
					fadingIn = 0,
					small = small,
					color = color,
					flashing = nil,
					colorType = colorType,
					inlineIcon = inlineIcon,
					keep = keep,
					fade = fade,
					countdown = countdown,
					countdownMax = countdownMax,
					lastUpdate = GetTime()
				}, mt)
			end
			newFrame.obj = newBar
			self.numBars = (self.numBars or 0) + 1
			local enlargeTime = self.options.BarStyle ~= "NoAnim" and self.options.EnlargeBarTime or 11
			local importantBar = colorType and colorType == 7 and self:GetOption("Bar7ForceLarge")
			if (importantBar or (timer <= enlargeTime or huge)) and self:GetOption("HugeBarsEnabled") then -- start enlarged
				newBar.enlarged = true
				newBar.huge = true
				if huge then
					self.enlargeHack = true
				end
				self.hugeBars:Append(newBar)
			else
				newBar.huge = nil
				self.smallBars:Append(newBar)
			end
			newBar:SetText(id)
			newBar:SetIcon(icon)
			self.bars[newBar] = true
			newBar:ApplyStyle()
			newBar:Update(0)
		end
		return newBar
	end
end


-----------------
--  Dummy Bar  --
-----------------
do
	local dummyBars = 0
	local function dummyCancel(self)
		self.timer = self.totalTime
		self.flashing = nil
		self:Update(0)
		self.flashing = nil
		_G[self.frame:GetName().."BarSpark"]:SetAlpha(1)
	end
	function DBT:CreateDummyBar(colorType, inlineIcon)
		dummyBars = dummyBars + 1
		local dummy = self:CreateBar(25, "dummy"..dummyBars, 136116, nil, true, nil, true, colorType, inlineIcon)--"Interface\\Icons\\Spell_Nature_WispSplode"
		dummy:SetText("Dummy", inlineIcon)
		dummy:Cancel()
		self.bars[dummy] = true
		unusedBars[#unusedBars] = nil
		unusedBarObjects[dummy] = nil
		dummy.frame.obj = dummy
		dummy.frame:SetParent(UIParent)
		dummy.frame:ClearAllPoints()
		dummy.frame:SetScript("OnUpdate", nil)
		dummy.Cancel = dummyCancel
		dummy:ApplyStyle()
		dummy.dummy = true
		return dummy
	end
end


-----------------------------
--  General Bar Functions  --
-----------------------------
function DBT:GetBarIterator()
	if not self.bars then
		DBM:Debug("GetBarIterator failed for unknown reasons")
		return
	end
	return pairs(self.bars)
end

function DBT:GetBar(id)
	for bar in self:GetBarIterator() do
		if id == bar.id then
			return bar
		end
	end
end

function DBT:CancelBar(id)
	for bar in self:GetBarIterator() do
		if id == bar.id then
			bar:Cancel()
			return true
		end
	end
	return false
end

function DBT:UpdateBar(id, elapsed, totalTime)
	for bar in self:GetBarIterator() do
		if id == bar.id then
			bar:SetTimer(totalTime or bar.totalTime)
			bar:SetElapsed(elapsed or self.totalTime - self.timer)
			return true
		end
	end
	return false
end


---------------------------
--  General Bar Methods  --
---------------------------
function DBT:ShowTestBars()
	self:CreateBar(10, "Test 1", 136116)--"Interface\\Icons\\Spell_Nature_WispSplode"
	self:CreateBar(14, "Test 2", 136116)
	self:CreateBar(20, "Test 3", 136116)
	self:CreateBar(12, "Test 4", 136116)
	self:CreateBar(21.5, "Test 5", 136116)
end

function barPrototype:SetTimer(timer)
	self.totalTime = timer
	self:Update(0)
end

function barPrototype:ResetAnimations()
	self:RemoveFromList()
	self.enlarged = nil
	self.moving = nil
	self.owner.smallBars:Append(self)
	self:ApplyStyle()
end

function barPrototype:Pause()
	self.flashing = nil
	self.ftimer = nil
	self:Update(0)
	self.paused = true
	if self.moving == "enlarge" then
		self:ResetAnimations()
	end
end

function barPrototype:Resume()
	self.paused = nil
end

function barPrototype:SetElapsed(elapsed)
	self.timer = self.totalTime - elapsed
	local enlargeTime = self.owner.options.BarStyle ~= "NoAnim" and self.owner.options.EnlargeBarTime or 11
	local enlargePer = self.owner.options.BarStyle ~= "NoAnim" and self.owner.options.EnlargeBarsPercent or 0
	if (self.enlarged or self.moving == "enlarge") and not (self.timer <= enlargeTime or (self.timer/self.totalTime) <= enlargePer) then
		self:ResetAnimations()
		DBM:Debug("ResetAnimations firing for a a bar :Update() call", 2)
	elseif self.owner.options.Sort and self.moving ~= "enlarge" then
		local group = self.enlarged and self.owner.hugeBars or self.owner.smallBars
		group:Remove(self)
		group:Append(self)
	end
	self:Update(0)
end

function barPrototype:SetText(text, inlineIcon)
	if not self.owner.options.InlineIcons then inlineIcon = nil end
	--Force change color type 7 yo custom inlineIcon
	local forcedIcon = (self.colorType and self.colorType == 7 and self.owner.options.Bar7CustomInline) and DBM_CORE_IMPORTANT_ICON or inlineIcon or ""
	_G[self.frame:GetName().."BarName"]:SetText(forcedIcon..text)
end

function barPrototype:SetIcon(icon)
	local frame_name = self.frame:GetName()
	_G[frame_name.."BarIcon1"]:SetTexture("")
	_G[frame_name.."BarIcon1"]:SetTexture(icon)
	_G[frame_name.."BarIcon2"]:SetTexture("")
	_G[frame_name.."BarIcon2"]:SetTexture(icon)
end

function barPrototype:SetColor(color)
	self.color = color
	local frame_name = self.frame:GetName()
	_G[frame_name.."Bar"]:SetStatusBarColor(color.r, color.g, color.b)
	_G[frame_name.."BarSpark"]:SetVertexColor(color.r, color.g, color.b)
end


------------------
--  Bar Update  --
------------------
function barPrototype:Update(elapsed)
	local frame = self.frame
	local frame_name = frame:GetName()
	local bar = _G[frame_name.."Bar"]
	local texture = _G[frame_name.."BarTexture"]
	local spark = _G[frame_name.."BarSpark"]
	local timer = _G[frame_name.."BarTimer"]
	local obj = self.owner
	local barOptions = obj.options
	local currentStyle = barOptions.BarStyle
	local sparkEnabled = currentStyle ~= "NoAnim" and barOptions.Spark
	local isMoving = self.moving
	local isFadingIn = self.fadingIn
	local isEnlarged = self.enlarged
	local fillUpBars = isEnlarged and barOptions.FillUpLargeBars or not isEnlarged and barOptions.FillUpBars
	local ExpandUpwards = isEnlarged and barOptions.ExpandUpwardsLarge or not isEnlarged and barOptions.ExpandUpwards
	self.timer = self.timer - elapsed
	local timerValue = self.timer
	local totaltimeValue = self.totalTime
	local colorCount = self.colorType
	local enlargeHack = self.enlargeHack or false
	if barOptions.DynamicColor and not self.color then
		local r, g, b
		if colorCount and colorCount >= 1 then
			if colorCount == 1 then--Add
				r = barOptions.StartColorAR  + (barOptions.EndColorAR - barOptions.StartColorAR) * (1 - timerValue/totaltimeValue)
				g = barOptions.StartColorAG  + (barOptions.EndColorAG - barOptions.StartColorAG) * (1 - timerValue/totaltimeValue)
				b = barOptions.StartColorAB  + (barOptions.EndColorAB - barOptions.StartColorAB) * (1 - timerValue/totaltimeValue)
			elseif colorCount == 2 then--AOE
				r = barOptions.StartColorAER  + (barOptions.EndColorAER - barOptions.StartColorAER) * (1 - timerValue/totaltimeValue)
				g = barOptions.StartColorAEG  + (barOptions.EndColorAEG - barOptions.StartColorAEG) * (1 - timerValue/totaltimeValue)
				b = barOptions.StartColorAEB  + (barOptions.EndColorAEB - barOptions.StartColorAEB) * (1 - timerValue/totaltimeValue)
			elseif colorCount == 3 then--Debuff
				r = barOptions.StartColorDR  + (barOptions.EndColorDR - barOptions.StartColorDR) * (1 - timerValue/totaltimeValue)
				g = barOptions.StartColorDG  + (barOptions.EndColorDG - barOptions.StartColorDG) * (1 - timerValue/totaltimeValue)
				b = barOptions.StartColorDB  + (barOptions.EndColorDB - barOptions.StartColorDB) * (1 - timerValue/totaltimeValue)
			elseif colorCount == 4 then--Interrupt
				r = barOptions.StartColorIR  + (barOptions.EndColorIR - barOptions.StartColorIR) * (1 - timerValue/totaltimeValue)
				g = barOptions.StartColorIG  + (barOptions.EndColorIG - barOptions.StartColorIG) * (1 - timerValue/totaltimeValue)
				b = barOptions.StartColorIB  + (barOptions.EndColorIB - barOptions.StartColorIB) * (1 - timerValue/totaltimeValue)
			elseif colorCount == 5 then--Role
				r = barOptions.StartColorRR  + (barOptions.EndColorRR - barOptions.StartColorRR) * (1 - timerValue/totaltimeValue)
				g = barOptions.StartColorRG  + (barOptions.EndColorRG - barOptions.StartColorRG) * (1 - timerValue/totaltimeValue)
				b = barOptions.StartColorRB  + (barOptions.EndColorRB - barOptions.StartColorRB) * (1 - timerValue/totaltimeValue)
			elseif colorCount == 6 then--Phase
				r = barOptions.StartColorPR  + (barOptions.EndColorPR - barOptions.StartColorPR) * (1 - timerValue/totaltimeValue)
				g = barOptions.StartColorPG  + (barOptions.EndColorPG - barOptions.StartColorPG) * (1 - timerValue/totaltimeValue)
				b = barOptions.StartColorPB  + (barOptions.EndColorPB - barOptions.StartColorPB) * (1 - timerValue/totaltimeValue)
			elseif colorCount == 7 then--Important
				if barOptions.Bar7ForceLarge then
					enlargeHack = true
				end
				r = barOptions.StartColorUIR  + (barOptions.EndColorUIR - barOptions.StartColorUIR) * (1 - timerValue/totaltimeValue)
				g = barOptions.StartColorUIG  + (barOptions.EndColorUIG - barOptions.StartColorUIG) * (1 - timerValue/totaltimeValue)
				b = barOptions.StartColorUIB  + (barOptions.EndColorUIB - barOptions.StartColorUIB) * (1 - timerValue/totaltimeValue)
			end
		else
			r = barOptions.StartColorR  + (barOptions.EndColorR - barOptions.StartColorR) * (1 - timerValue/totaltimeValue)
			g = barOptions.StartColorG  + (barOptions.EndColorG - barOptions.StartColorG) * (1 - timerValue/totaltimeValue)
			b = barOptions.StartColorB  + (barOptions.EndColorB - barOptions.StartColorB) * (1 - timerValue/totaltimeValue)
		end
		bar:SetStatusBarColor(r, g, b)
		if sparkEnabled then
			spark:SetVertexColor(r, g, b)
		end
	end
	if timerValue <= 0 and not (barOptions.KeepBars and self.keep) then
		return self:Cancel()
	else
		if fillUpBars then
			if currentStyle == "NoAnim" and isEnlarged and not enlargeHack then
				bar:SetValue(1 - timerValue/(totaltimeValue < 11 and totaltimeValue or 11))
			else
				bar:SetValue(1 - timerValue/totaltimeValue)
			end
		else
			if currentStyle == "NoAnim" and isEnlarged and not enlargeHack then
				bar:SetValue(timerValue/(totaltimeValue < 11 and totaltimeValue or 11))
			else
				bar:SetValue(timerValue/totaltimeValue)
			end
		end
		timer:SetText(stringFromTimer(timerValue))
	end
	if isFadingIn and isFadingIn < 0.5 and currentStyle ~= "NoAnim" then
		self.fadingIn = isFadingIn + elapsed
		if (isEnlarged and barOptions.HugeAlpha == 1) or barOptions.Alpha == 1 then--Only fade in if alpha is 1, otherwise we already have a faded bar
			frame:SetAlpha((isFadingIn) / 0.5)
		end
	elseif isFadingIn then
		self.fadingIn = nil
	end
	if timerValue <= 7.75 and not self.flashing and barOptions.Flash and currentStyle ~= "NoAnim" then
		self.flashing = true
		self.ftimer = 0
	elseif self.flashing and timerValue > 7.75 then
		self.flashing = nil
		self.ftimer = nil
	end
	if sparkEnabled then
		spark:ClearAllPoints()
		spark:SetSize(12, barOptions.Height * 3)
		spark:SetPoint("CENTER", bar, "LEFT", bar:GetValue() * bar:GetWidth(), -1)
	else
		spark:SetAlpha(0)
	end
	if self.flashing then
		local ftime = self.ftimer % 1.25
		if ftime >= 0.5 then
			texture:SetAlpha(1)
			if sparkEnabled then
				spark:SetAlpha(1)
			end
		elseif ftime >= 0.25 then
			texture:SetAlpha(1 - (0.5 - ftime) / 0.25)
			if sparkEnabled then
				spark:SetAlpha(1 - (0.5 - ftime) / 0.25)
			end
		else
			texture:SetAlpha(1 - (ftime / 0.25))
			if sparkEnabled then
				spark:SetAlpha(1 - (ftime / 0.25))
			end
		end
		self.ftimer = self.ftimer + elapsed
	end
	local melapsed = self.moveElapsed
	if isMoving == "move" and melapsed <= 0.5 then
		barIsAnimating = true
		self.moveElapsed = melapsed + elapsed
		local newX = self.moveOffsetX + (barOptions[isEnlarged and "HugeBarXOffset" or "BarXOffset"] - self.moveOffsetX) * (melapsed / 0.5)
		local newY
		if ExpandUpwards then
			newY = self.moveOffsetY + (barOptions[isEnlarged and "HugeBarYOffset" or "BarYOffset"] - self.moveOffsetY) * (melapsed / 0.5)
		else
			newY = self.moveOffsetY + (-barOptions[isEnlarged and "HugeBarYOffset" or "BarYOffset"] - self.moveOffsetY) * (melapsed / 0.5)
		end
		frame:ClearAllPoints()
		frame:SetPoint(self.movePoint, self.moveAnchor, self.moveRelPoint, newX, newY)
	elseif isMoving == "move" then
		barIsAnimating = false
		self.moving = nil
		isMoving = nil
		self:SetPosition()
	elseif isMoving == "enlarge" and melapsed <= 1 then
		barIsAnimating = true
		self:AnimateEnlarge(elapsed)
	elseif isMoving == "enlarge" then
		barIsAnimating = false
		self.moving = nil
		isMoving = nil
		self.enlarged = true
		isEnlarged = true
		obj.hugeBars:Append(self)
		self:ApplyStyle()
	elseif isMoving == "nextEnlarge" then
		barIsAnimating = false
		self.moving = nil
		isMoving = nil
		self.enlarged = true
		isEnlarged = true
		obj.hugeBars:Append(self)
		self:ApplyStyle()
	end
	local enlargeTime = currentStyle ~= "NoAnim" and barOptions.EnlargeBarTime or 11
	local enlargePer = currentStyle ~= "NoAnim" and barOptions.EnlargeBarsPercent or 0
	if (timerValue <= enlargeTime or (timerValue/totaltimeValue) <= enlargePer) and not self.small and not isEnlarged and isMoving ~= "enlarge" and obj:GetOption("HugeBarsEnabled") then
		self:RemoveFromList()
		self:Enlarge()
	end
end


-------------------
--  Movable Bar  --
-------------------
function DBT:SavePosition()
	local point, _, _, x, y = self.mainAnchor:GetPoint(1)
	self:SetOption("TimerPoint", point)
	self:SetOption("TimerX", x)
	self:SetOption("TimerY", y)
	point, _, _, x, y = self.secAnchor:GetPoint(1)
	self:SetOption("HugeTimerPoint", point)
	self:SetOption("HugeTimerX", x)
	self:SetOption("HugeTimerY", y)
end

do
	local function moveEnd(self)
		updateClickThrough(self, self:GetOption("ClickThrough"))
		self.movable = false
		DBM.InfoFrame:Hide()
		DBM.RangeCheck:Hide(true)
	end

	function DBT:ShowMovableBar(small, large)
		if small or small == nil then
			local bar1 = self:CreateBar(20, "Move1", 136116, nil, true)
			bar1:SetText(DBM_CORE_MOVABLE_BAR)
		end
		if large or large == nil then
			local bar2 = self:CreateBar(20, "Move2", 136116, true)
			bar2:SetText(DBM_CORE_MOVABLE_BAR)
		end
		updateClickThrough(self, false)
		self.movable = true
		DBM:Unschedule(moveEnd, self)
		DBM:Schedule(20, moveEnd, self)
		DBM.InfoFrame:Show(5, "test")
		DBM.RangeCheck:Show(nil, nil, true)
	end
end


--------------------
--  Bar Handling  --
--------------------
function barPrototype:RemoveFromList()
	if self.moving ~= "enlarge" then
		(self.enlarged and self.owner.hugeBars or self.owner.smallBars):Remove(self)
	end
end


------------------
--  Bar Cancel  --
------------------
function barPrototype:Cancel()
	tinsert(unusedBars, self.frame)
	self.frame:Hide()
	self.frame.obj = nil
	self:RemoveFromList()
	self.owner.bars[self] = nil
	unusedBarObjects[self] = self
	self.dead = true
	self.owner.numBars = (self.owner.numBars or 1) - 1
end


-----------------
--  Bar Style  --
-----------------
function DBT:ApplyStyle()
	for bar in self:GetBarIterator() do
		bar:ApplyStyle()
	end
end

function barPrototype:ApplyStyle()
	local frame = self.frame
	local frame_name = frame:GetName()
	local bar = _G[frame_name.."Bar"]
	local spark = _G[frame_name.."BarSpark"]
	local texture = _G[frame_name.."BarTexture"]
	local icon1 = _G[frame_name.."BarIcon1"]
	local icon2 = _G[frame_name.."BarIcon2"]
	local name = _G[frame_name.."BarName"]
	local timer = _G[frame_name.."BarTimer"]
	local barOptions = self.owner.options
	local sparkEnabled = barOptions.BarStyle ~= "NoAnim" and barOptions.Spark
	local enlarged = self.enlarged
	texture:SetTexture(barOptions.Texture)
	if self.color then
		local barRed, barGreen, barBlue = self.color.r, self.color.g, self.color.b
		bar:SetStatusBarColor(barRed, barGreen, barBlue)
		if sparkEnabled then
			spark:SetVertexColor(barRed, barGreen, barBlue)
		end
	else
		local barStartRed, barStartGreen, barStartBlue
		if self.colorType then
			local colorCount = self.colorType
			if colorCount == 1 then--Add
				barStartRed, barStartGreen, barStartBlue = barOptions.StartColorAR, barOptions.StartColorAG, barOptions.StartColorAB
			elseif colorCount == 2 then--AOE
				barStartRed, barStartGreen, barStartBlue = barOptions.StartColorAER, barOptions.StartColorAEG, barOptions.StartColorAEB
			elseif colorCount == 3 then--Debuff
				barStartRed, barStartGreen, barStartBlue = barOptions.StartColorDR, barOptions.StartColorDG, barOptions.StartColorDB
			elseif colorCount == 4 then--Interrupt
				barStartRed, barStartGreen, barStartBlue = barOptions.StartColorIR, barOptions.StartColorIG, barOptions.StartColorIB
			elseif colorCount == 5 then--Role
				barStartRed, barStartGreen, barStartBlue = barOptions.StartColorRR, barOptions.StartColorRG, barOptions.StartColorRB
			elseif colorCount == 6 then--Phase
				barStartRed, barStartGreen, barStartBlue = barOptions.StartColorPR, barOptions.StartColorPG, barOptions.StartColorPB
			elseif colorCount == 7 then--Important
				barStartRed, barStartGreen, barStartBlue = barOptions.StartColorUIR, barOptions.StartColorUIG, barOptions.StartColorUIB
			end
		else
			barStartRed, barStartGreen, barStartBlue = barOptions.StartColorR, barOptions.StartColorG, barOptions.StartColorB
		end
		bar:SetStatusBarColor(barStartRed, barStartGreen, barStartBlue)
		if sparkEnabled then
			spark:SetVertexColor(barStartRed, barStartGreen, barStartBlue)
		end
	end
	local barTextColorRed, barTextColorGreen, barTextColorBlue = barOptions.TextColorR, barOptions.TextColorG, barOptions.TextColorB
	local barHeight, barWidth, barHugeWidth = barOptions.Height, barOptions.Width, barOptions.HugeWidth
	name:SetTextColor(barTextColorRed, barTextColorGreen, barTextColorBlue)
	timer:SetTextColor(barTextColorRed, barTextColorGreen, barTextColorBlue)
	if barOptions.IconLeft then icon1:Show() else icon1:Hide() end
	if barOptions.IconRight then icon2:Show() else icon2:Hide() end
	if enlarged then
		bar:SetWidth(barHugeWidth)
		bar:SetHeight(barHeight)
		frame:SetScale(barOptions.HugeScale)
		if barOptions.FadeBars and self.fade then
			frame:SetAlpha(barOptions.HugeAlpha/2)
		else
			frame:SetAlpha(barOptions.HugeAlpha)
		end
	else
		bar:SetWidth(barWidth)
		bar:SetHeight(barHeight)
		frame:SetScale(barOptions.Scale)
		if barOptions.FadeBars and self.fade and barOptions.Alpha ~= 0 then
			frame:SetAlpha(barOptions.Alpha/2)
		else
			frame:SetAlpha(barOptions.Alpha)
		end
	end
	if barOptions.IconLocked then
		if enlarged then frame:SetWidth(barHugeWidth); frame:SetHeight(barHeight); else frame:SetWidth(barWidth); frame:SetHeight(barHeight); end
		icon1:SetWidth(barHeight)
		icon1:SetHeight(barHeight)
		icon2:SetWidth(barHeight)
		icon2:SetHeight(barHeight)
	end
	self.frame:Show()
	if sparkEnabled then
		spark:SetAlpha(1)
	end
	texture:SetAlpha(1)
	bar:SetAlpha(1)
	local barFont, barFontSize, barFontFlag = barOptions.Font, barOptions.FontSize, barOptions.FontFlag
	name:SetFont(barFont, barFontSize, barFontFlag)
	name:SetPoint("LEFT", bar, "LEFT", 3, 0)
	timer:SetFont(barFont, barFontSize, barFontFlag)
	self:Update(0)
end

local function updateOrientation(self)
	for bar in self:GetBarIterator() do
		if not bar.dummy then
			if bar.moving == "enlarge" then
				bar.enlarged = true
				bar.moving = nil
				self.hugeBars:Append(bar)
				bar:ApplyStyle()
			else
				bar.moving = nil
				bar:SetPosition()
			end
		end
	end
end
options.ExpandUpwards.onChange = updateOrientation
options.ExpandUpwardsLarge.onChange = updateOrientation
options.BarYOffset.onChange = updateOrientation
options.BarXOffset.onChange = updateOrientation
options.HugeBarYOffset.onChange = updateOrientation
options.HugeBarXOffset.onChange = updateOrientation

function updateClickThrough(self, newValue)
	if not self.movable then
		for bar in self:GetBarIterator() do
			if not bar.dummy then
				bar.frame:EnableMouse(not newValue)
			end
		end
	end
end
options.ClickThrough.onChange = updateClickThrough


--------------------
--  Skinning API  --
--------------------
do
	local skins = {}
	local textures = {}
	local fonts = {}

	local skin = {}
	skin.__index = skin

	function DBT:RegisterSkin(id)
		if id:sub(0, 4) == "DBM-" then
			id = id:sub(5)
		end
		local obj = skins[id]
		if not obj then
			error("unknown skin id; the id must be equal to the addon's name (with the DBM- prefix being optional)", 2)
		end
		obj.loaded = true
		obj.defaults = {}
		return obj
	end

	function DBT:SetSkin(id)
		local skin = skins[id]
		if not skin then
			error("skin " .. id .. " doesn't exist", 2)
		end
--[[		-- changing the skin cancels all timers; this is much easier than creating new frames for all currently running timers
			-- This just fails and I can't see why so disabling this and just blocking setting skins with timers active instead
		for bar in self:GetBarIterator() do
			bar:Cancel()
		end--]]
		self:SetOption("Skin", id)
		-- throw away old bars (note: there is no way to re-use them as the new skin uses a different XML template)
		-- note: this doesn't update dummy bars (and can't do it by design); anyone who has a dummy bar for preview purposes (i.e. the GUI) must create new bars (e.g. in a callback)
		unusedBars = {}
		-- apply default options from the skin and reset all other options
		for k, v in pairs(options) do
			if k ~= "TimerPoint" and k ~= "TimerX" and k ~= "TimerY" -- do not reset the position
				and k ~= "HugeTimerPoint" and k ~= "HugeTimerX" and k ~= "HugeTimerY"
				and k ~= "Skin" then -- do not reset the skin we just set
				-- A custom skin might have some settings as false, so need to check explicitly for nil.
				-- skin.defaults will be nil if there isn't a skin (e.g. DefaultSkin) loaded, so check for that too.
				if skin.defaults and skin.defaults[k] ~= nil then
					self:SetOption(k, skin.defaults[k])
				else
					self:SetOption(k, v.default)
				end
			end
		end
	end

	for i = 1, GetNumAddOns() do
		if GetAddOnMetadata(i, "X-DBM-Timer-Skin") then
			-- load basic skin data
			local id = GetAddOnInfo(i)
			if id:sub(0, 4) == "DBM-" then
				id = id:sub(5)
			end
			local name = GetAddOnMetadata(i, "X-DBM-Timer-Skin-Name")
			skins[id] = setmetatable({
				name = name
			}, skin)

			-- load textures and fonts that might be embedded in this skin (to make them available to other skins)
			local skinTextures = { strsplit(",", GetAddOnMetadata(i, "X-DBM-Timer-Skin-Textures") or "") }
			local skinTextureNames = { strsplit(",", GetAddOnMetadata(i, "X-DBM-Timer-Skin-Texture-Names") or "") }
			if #skinTextures ~= #skinTextureNames then
				geterrorhandler()(id .. ": toc file defines " .. #skinTextures .. " textures but " .. #skinTextureNames .. " names for textures")
			else
				for i = 1, #skinTextures do
					textures[skinTextureNames[i]:trim()] = skinTextures[i]:trim()
				end
			end
			local skinFonts = { strsplit(",", GetAddOnMetadata(i, "X-DBM-Timer-Skin-Fonts") or "") }
			local skinFontNames = { strsplit(",", GetAddOnMetadata(i, "X-DBM-Timer-Skin-Font-Names") or "") }
			if #skinFonts ~= #skinFontNames then
				geterrorhandler()(id .. ": toc file defines " .. #skinFonts .. " fonts but " .. #skinFontNames .. " names for fonts")
			else
				for i = 1, #skinFonts do
					fonts[skinFontNames[i]:trim()] = skinFonts[i]:trim()
				end
			end

		end
	end

	function DBT:GetSkins()
		return skins
	end

	function DBT:GetTextures()
		return textures
	end

	function DBT:GetFonts()
		return fonts
	end
end


--------------------
--  Bar Announce  --
--------------------
function barPrototype:Announce()
	local msg
	if self.owner.announceHook then
		msg = self.owner.announceHook(self)
	end
	local text = tostring(_G[self.frame:GetName().."BarName"]:GetText())
	text = text:gsub("|T.-|t", "")
	msg = msg or ("%s  %d:%02d"):format(text, math.floor(self.timer / 60), self.timer % 60)
	local chatWindow = ChatEdit_GetActiveWindow()
	if chatWindow then
		chatWindow:Insert(msg)
	else
		SendChatMessage(msg, (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT") or (IsInRaid() and "RAID") or "PARTY")
	end
end

function DBT:SetAnnounceHook(f)
	self.announceHook = f
end


-----------------------
--  Bar Positioning  --
-----------------------
function barPrototype:SetPosition()
	if self.moving == "enlarge" then return end
	local anchor = (self.prev and self.prev.frame) or (self.enlarged and self.owner.secAnchor) or self.owner.mainAnchor
	local Enlarged = self.enlarged
	local ExpandUpwards = Enlarged and self.owner.options.ExpandUpwardsLarge or not Enlarged and self.owner.options.ExpandUpwards
	self.frame:ClearAllPoints()
	if ExpandUpwards then
		self.frame:SetPoint("BOTTOM", anchor, "TOP", self.owner.options[Enlarged and "HugeBarXOffset" or "BarXOffset"], self.owner.options[Enlarged and "HugeBarYOffset" or "BarYOffset"])
	else
		self.frame:SetPoint("TOP", anchor, "BOTTOM", self.owner.options[Enlarged and "HugeBarXOffset" or "BarXOffset"], -self.owner.options[Enlarged and "HugeBarYOffset" or "BarYOffset"])
	end
end

function barPrototype:MoveToNextPosition()
	if self.moving == "enlarge" then return end
	local newAnchor = (self.prev and self.prev.frame) or (self.enlarged and self.owner.secAnchor) or self.owner.mainAnchor
	local oldX = self.frame:GetRight() - self.frame:GetWidth()/2
	local oldY = self.frame:GetTop()
	local Enlarged = self.enlarged
	local ExpandUpwards = Enlarged and self.owner.options.ExpandUpwardsLarge or not Enlarged and self.owner.options.ExpandUpwards
	self.frame:ClearAllPoints()
	if ExpandUpwards then
		self.movePoint = "BOTTOM"
		self.moveRelPoint = "TOP"
		self.frame:SetPoint("BOTTOM", newAnchor, "TOP", self.owner.options[Enlarged and "HugeBarXOffset" or "BarXOffset"], self.owner.options[Enlarged and "HugeBarYOffset" or "BarYOffset"])
	else
		self.movePoint = "TOP"
		self.moveRelPoint = "BOTTOM"
		self.frame:SetPoint("TOP", newAnchor, "BOTTOM", self.owner.options[Enlarged and "HugeBarXOffset" or "BarXOffset"], -self.owner.options[Enlarged and "HugeBarYOffset" or "BarYOffset"])
	end
	local newX = self.frame:GetRight() - self.frame:GetWidth()/2
	local newY = self.frame:GetTop()
	if self.owner.options.BarStyle ~= "NoAnim" then
		self.frame:ClearAllPoints()
		self.frame:SetPoint(self.movePoint, newAnchor, self.moveRelPoint, -(newX - oldX), -(newY - oldY))
		self.moving = "move"
	end
	self.moveAnchor = newAnchor
	self.moveOffsetX = -(newX - oldX)
	self.moveOffsetY = -(newY - oldY)
	self.moveElapsed = 0
end

function barPrototype:Enlarge()
	local newAnchor = (self.owner.hugeBars.last and self.owner.hugeBars.last.frame) or self.owner.secAnchor
	local oldX = self.frame:GetRight() - self.frame:GetWidth()/2
	local oldY = self.frame:GetTop()
	local Enlarged = self.enlarged
	local ExpandUpwards = Enlarged and self.owner.options.ExpandUpwardsLarge or not Enlarged and self.owner.options.ExpandUpwards
	self.frame:ClearAllPoints()
	if ExpandUpwards then
		self.movePoint = "BOTTOM"
		self.moveRelPoint = "TOP"
		self.frame:SetPoint("BOTTOM", newAnchor, "TOP", self.owner.options[Enlarged and "HugeBarXOffset" or "BarXOffset"], self.owner.options[Enlarged and "HugeBarYOffset" or "BarYOffset"])
	else
		self.movePoint = "TOP"
		self.moveRelPoint = "BOTTOM"
		self.frame:SetPoint("TOP", newAnchor, "BOTTOM", self.owner.options[Enlarged and "HugeBarXOffset" or "BarXOffset"], -self.owner.options[Enlarged and "HugeBarYOffset" or "BarYOffset"])
	end
	local newX = self.frame:GetRight() - self.frame:GetWidth()/2
	local newY = self.frame:GetTop()
	self.frame:ClearAllPoints()
	self.frame:SetPoint("TOP", newAnchor, "BOTTOM", -(newX - oldX), -(newY - oldY))
	self.moving = self.owner.options.BarStyle == "NoAnim" and "nextEnlarge" or "enlarge"
	self.moveAnchor = newAnchor
	self.moveOffsetX = -(newX - oldX)
	self.moveOffsetY = -(newY - oldY)
	self.moveElapsed = 0
end


---------------------------
--  Bar Special Effects  --
---------------------------
function barPrototype:AnimateEnlarge(elapsed)
	self.moveElapsed = self.moveElapsed + elapsed
	local melapsed = self.moveElapsed
	local newX = self.moveOffsetX + (self.owner.options.HugeBarXOffset - self.moveOffsetX) * (melapsed / 1)
	local newY = self.moveOffsetY + (self.owner.options.HugeBarYOffset - self.moveOffsetY) * (melapsed / 1)
	local newWidth = self.owner.options.Width + (self.owner.options.HugeWidth - self.owner.options.Width) * (melapsed / 1)
	local newScale = self.owner.options.Scale + (self.owner.options.HugeScale - self.owner.options.Scale) * (melapsed / 1)
	if melapsed < 1 then
		self.frame:ClearAllPoints()
		self.frame:SetPoint(self.movePoint, self.moveAnchor, self.moveRelPoint, newX, newY)
		self.frame:SetScale(newScale)
		self.frame:SetWidth(newWidth)
		_G[self.frame:GetName().."Bar"]:SetWidth(newWidth)
	else
		self.moving = nil
		self.enlarged = true
		self.owner.hugeBars:Append(self)
		self:ApplyStyle()
	end
end


------------------------
-- Bar event handlers --
------------------------
do
	local function onUpdate(self, elapsed)
		if self.obj then
			self.obj.curTime = GetTime()
			self.obj.delta = self.obj.curTime - self.obj.lastUpdate
			if barIsAnimating and self.obj.delta >= 0.02 or self.obj.delta >= 0.04 then
				self.obj.lastUpdate = self.obj.curTime
				self.obj:Update(self.obj.delta)
			end
		else
			-- This should *never* happen; .obj is only set to nil when calling :Hide() and :Show() is only called in a function that also sets .obj
			-- However, there have been several reports of this happening since WoW 5.x, wtf?
			-- Unfortunately, none of the developers was ever able to reproduce this.
			-- The bug reports show screenshots of expired timers that are still visible (showing 0.00) with all clean-up operations (positioning, list entry) except for the :Hide() call being performed...
			self:Hide()
		end
	end

	local function onMouseDown(self, btn)
		if self.obj then
			if self.obj.owner.movable and btn == "LeftButton" then
				if self.obj.enlarged then
					self.obj.owner.secAnchor:StartMoving()
				else
					self.obj.owner.mainAnchor:StartMoving()
				end
			end
		end
	end

	local function onMouseUp(self, btn)
		if self.obj then
			self.obj.owner.mainAnchor:StopMovingOrSizing()
			self.obj.owner.secAnchor:StopMovingOrSizing()
			self.obj.owner:SavePosition()
			if btn == "RightButton" then
				self.obj:Cancel()
			elseif btn == "LeftButton" and IsShiftKeyDown() then
				self.obj:Announce()
			end
		end
	end

	local function onHide(self)
		if self.obj then
			self.obj.owner.mainAnchor:StopMovingOrSizing()
			self.obj.owner.secAnchor:StopMovingOrSizing()
		end
	end

	function setupHandlers(frame)
		frame:SetScript("OnUpdate", onUpdate)
		frame:SetScript("OnMouseDown", onMouseDown)
		frame:SetScript("OnMouseUp", onMouseUp)
		frame:SetScript("OnHide", onHide)
		_G[frame:GetName() .. "Bar"]:SetMinMaxValues(0, 1) -- used to be in the OnLoad handler
	end
end
