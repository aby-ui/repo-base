local Parrot = Parrot
local Parrot_Display = Parrot:NewModule("Display", "AceHook-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("Parrot_Display")
local SharedMedia = LibStub("LibSharedMedia-3.0")

local newList, del = Parrot.newList, Parrot.del
local debug = Parrot.debug

local ParrotFrame

local dbDefaults = {
	profile = {
		alpha = 1,
		iconAlpha = 1,
		iconsEnabled = true,
		font = "Friz Quadrata TT",
		fontSize = 18,
		fontOutline = "THICKOUTLINE",
		stickyFont = "Friz Quadrata TT",
		stickyFontSize = 26,
		stickyFontOutline = "THICKOUTLINE",
	},
}

local Parrot_AnimationStyles
local Parrot_Suppressions
local Parrot_ScrollAreas
local db
function Parrot_Display:OnInitialize()
	self.db1 = Parrot.db1:RegisterNamespace("Display", dbDefaults)
	db = self.db1.profile
	Parrot_AnimationStyles = Parrot:GetModule("AnimationStyles")
	Parrot_Suppressions = Parrot:GetModule("Suppressions")
	Parrot_ScrollAreas = Parrot:GetModule("ScrollAreas")
end

function Parrot_Display:ChangeProfile()
	db = self.db1.profile
end

local function setOption(info, value)
	local name = info[#info]
	db[name] = value
end
local function getOption(info)
	local name = info[#info]
	return db[name]
end

local function onUpdate()
	Parrot_Display:OnUpdate()
end

function Parrot_Display:OnEnable()
	if not ParrotFrame then
		ParrotFrame = CreateFrame("Frame", "ParrotFrame", UIParent)
		ParrotFrame:Hide()
		ParrotFrame:SetFrameStrata("HIGH")
		ParrotFrame:SetToplevel(true)
		ParrotFrame:SetPoint("CENTER")
		ParrotFrame:SetWidth(0.0001)
		ParrotFrame:SetHeight(0.0001)
		ParrotFrame:SetScript("OnUpdate", onUpdate)
	end

	if _G.CombatText_AddMessage then
		self:RawHook("CombatText_AddMessage", true)
	else
		function _G.CombatText_AddMessage(...)
			self:CombatText_AddMessage(...)
		end
	end
end

function Parrot_Display:OnDisable()
end

-- #NODOC
function Parrot_Display:CombatText_AddMessage(message, scrollFunction, r, g, b, displayType, isStaggered)
	if type(message) ~= "string" then
		return
	end
	if type(r) ~= "number" or type(g) ~= "number" or type(b) ~= "number" then
		r, g, b = 1, 1, 1
	end
	self:ShowMessage(message, "Notification", displayType == "crit", r, g, b, nil, nil, nil)
end

local function getFontChoices()
	local result = {}
	for _,v in ipairs(SharedMedia:List('font')) do
		result[v] = v
	end
	return result
end

--[[local function setOption(info, value)
	local name = info[#info]
	db[name] = value
end
local function getOption(info)
	local name = info[#info]
	return db[name]
end--]]

function Parrot_Display:OnOptionsCreate()
	local outlineChoices = {
		NONE = L["None"],
		OUTLINE = L["Thin"],
		THICKOUTLINE = L["Thick"],
	}

	Parrot.options.args.general.args.alpha = {
		type = 'range',
		name = L["Text transparency"],
		desc = L["How opaque/transparent the text should be."],
		min = 0.25,
		max = 1,
		step = 0.01,
		bigStep = 0.05,
		isPercent = true,
		get = getOption,
		set = setOption,
	}
	Parrot.options.args.general.args.iconAlpha = {
		type = 'range',
		name = L["Icon transparency"],
		desc = L["How opaque/transparent icons should be."],
		min = 0.25,
		max = 1,
		step = 0.01,
		bigStep = 0.05,
		isPercent = true,
		get = getOption,
		set = setOption,
	}
	Parrot.options.args.general.args.iconsEnabled = {
		type = 'toggle',
		name = L["Enable icons"],
		desc = L["Set whether icons should be enabled or disabled altogether."],
		get = getOption,
		set = setOption,
	}
	Parrot.options.args.general.args.font = {
		type = 'group',
		name = L["Master font settings"],
		desc = L["Master font settings"],
		get = getOption,
		set = setOption,
		args = {
			font = {
				type = 'select',
				control = "LSM30_Font",
				name = L["Normal font"],
				desc = L["Normal font face."],
				values = getFontChoices(),
			},
			fontSize = {
				type = 'range',
				name = L["Normal font size"],
				desc = L["Normal font size"],
				min = 6,
				max = 32,
				step = 1,
			},
			fontOutline = {
				type = 'select',
				name = L["Normal outline"],
				desc = L["Normal outline"],
				values = outlineChoices,
			},
			stickyFont = {
				type = 'select',
				control = "LSM30_Font",
				name = L["Sticky font"],
				desc = L["Sticky font face."],
				values = getFontChoices(),
			},
			stickyFontSize = {
				type = 'range',
				name = L["Sticky font size"],
				desc = L["Sticky font size"],
				min = 6,
				max = 32,
				step = 1,
			},
			stickyFontOutline = {
				type = 'select',
				name = L["Sticky outline"],
				desc = L["Sticky outline"],
				values = outlineChoices,
			},
		}
	}
end

local freeFrames = {}
local wildFrames
local frame_num = 0
local frameIDs = {}
local freeTextures = {}
local texture_num = 0
local freeFontStrings = {}
local fontString_num = 0

--[[----------------------------------------------------------------------------------
Arguments:
	string - the text you wish to show.
	[optional] string - the scroll area to show in. Default: "Notification"
	[optional] boolean - whether to show in the sticky-style, e.g. crits. Default: false
	[optional] number - [0, 1] the red part of the color. Default: 1
	[optional] number - [0, 1] the green part of the color. Default: 1
	[optional] number - [0, 1] the blue part of the color. Default: 1
	[optional] string - the font to use (as determined by SharedMedia-1.0). Defaults to the scroll area's setting.
	[optional] number - the font size to use. Defaults to the scroll area's setting.
	[optional] string - the font outline to use. Defaults to the scroll area's setting.
	[optional] string - the icon texture to show alongside the message.
Notes:
	* See :GetScrollAreasValidate() for a validation list of scroll areas.
	* Messages are suppressed if the user has set a specific suppression matching the text.
Example:
	Parrot:ShowMessage("Hello, world!", "Notification", false, 0.5, 0.5, 1)
------------------------------------------------------------------------------------]]
function Parrot_Display:ShowMessage(text, scrollArea, sticky, r, g, b, font, fontSize, outline, icon)
	self = Parrot_Display -- for those who do Parrot:ShowMessage
	if not self:IsEnabled() then
		return
	end
	if Parrot_Suppressions:ShouldSuppress(text) then
		return
	end
	if not Parrot_ScrollAreas:HasScrollArea(scrollArea) then
		if Parrot_ScrollAreas:HasScrollArea("Notification") then
			scrollArea = "Notification"
		else
			scrollArea = Parrot_ScrollAreas:GetRandomScrollArea()
			if not scrollArea then
				return
			end
		end
	end

	scrollArea = Parrot_ScrollAreas:GetScrollArea(scrollArea)
	if not sticky then
		if not font then
			font = scrollArea.font or db.font
		end
		if not fontSize then
			fontSize = scrollArea.fontSize or db.fontSize
		end
		if not outline then
			outline = scrollArea.fontOutline or db.fontOutline
		end
	else
		if not font then
			font = scrollArea.stickyFont or db.stickyFont
		end
		if not fontSize then
			fontSize = scrollArea.stickyFontSize or db.stickyFontSize
		end
		if not outline then
			outline = scrollArea.stickyFontOutline or db.stickyFontOutline
		end
	end
	if outline == "NONE" then
		outline = ""
	end

	local frame = next(freeFrames)
	if frame then
		frame:ClearAllPoints()
		freeFrames[frame] = nil
	else
		frame_num = frame_num + 1
		frame = CreateFrame("Frame", "ParrotFrameFrame" .. frame_num, ParrotFrame)
	end

	local fs = next(freeFontStrings)
	if fs then
		fs:ClearAllPoints()
		freeFontStrings[fs] = nil
		fs:SetParent(frame)
	else
		fontString_num = fontString_num + 1
		fs = frame:CreateFontString("ParrotFrameFontString" .. fontString_num, "ARTWORK", "SystemFont_Shadow_Small")
	end
	fs:SetFont(SharedMedia:Fetch('font', font), fontSize, outline)
	if not fs:GetFont() then
		fs:SetFont([[Fonts\FRIZQT__.TTF]], fontSize, outline)
	end

	frame.fs = fs

	local tex
	if icon ~= "Interface\\Icons\\Temp" and scrollArea.iconSide ~= "DISABLE" and db.iconsEnabled then
		tex = next(freeTextures)
		if tex then
			tex:Show()
			tex:ClearAllPoints()
			freeTextures[tex] = nil
			tex:SetParent(frame)
		else
			texture_num = texture_num + 1
			tex = frame:CreateTexture("ParrotFrameTexture" .. texture_num, "OVERLAY")
		end
		if not tex:SetTexture(icon) then
			tex:Hide()
			tex:SetTexture(nil)
			freeTextures[tex] = true
			tex:SetParent(ParrotFrame)
		else
			frame.icon = tex
			if type(icon) ~= "string" or icon:find("^Interface\\Icons\\") then
				tex:SetTexCoord(0.07, 0.93, 0.07, 0.93)
			else
				tex:SetTexCoord(0, 1, 0, 1)
			end
			tex:SetWidth(fontSize)
			tex:SetHeight(fontSize)
		end
	end

	if tex then
		if scrollArea.iconSide == "CENTER" then

		elseif scrollArea.iconSide == "RIGHT" then
			tex:SetPoint("LEFT", fs, "RIGHT", 3, 0)
			fs:SetPoint("LEFT", frame, "LEFT")
		else
			tex:SetPoint("RIGHT", fs, "LEFT", -3, 0)
			fs:SetPoint("RIGHT", frame, "RIGHT")
		end
	else
		fs:SetPoint("LEFT", frame, "LEFT")
	end

	if r and g and b then
		fs:SetTextColor(r, g, b)
	else
		fs:SetTextColor(1, 1, 1)
	end
	fs:SetText(text)
	frame.start = GetTime()
	frame.scrollArea = scrollArea
	frame.sticky = sticky

	if(sticky) then
		frame:SetFrameLevel(1)
	else
		frame:SetFrameLevel(0)
	end

	local animationStyle
	if sticky then
		animationStyle = scrollArea.stickyAnimationStyle
	else
		animationStyle = scrollArea.animationStyle
	end
	local aniStyle = Parrot_AnimationStyles:GetAnimationStyle(animationStyle)
	if not wildFrames then
		wildFrames = newList()
		ParrotFrame:Show()
	end
	local wildFrames_scrollArea = wildFrames[scrollArea]
	if not wildFrames_scrollArea then
		wildFrames_scrollArea = newList()
		wildFrames[scrollArea] = wildFrames_scrollArea
	end
	local wildFrames_scrollArea_aniStyle = wildFrames_scrollArea[aniStyle]
	if not wildFrames_scrollArea_aniStyle then
		wildFrames_scrollArea_aniStyle = newList()
		wildFrames_scrollArea[aniStyle] = wildFrames_scrollArea_aniStyle
	end
	wildFrames_scrollArea_aniStyle.length = scrollArea[sticky and "stickySpeed" or "speed"] or 3
	local frameIDs_scrollArea = frameIDs[scrollArea]
	if not frameIDs_scrollArea then
		frameIDs_scrollArea = newList()
		frameIDs[scrollArea] = frameIDs_scrollArea
	end
	local frameIDs_scrollArea_aniStyle = frameIDs_scrollArea[aniStyle]
	if not frameIDs_scrollArea_aniStyle then
		frameIDs_scrollArea_aniStyle = 1
	else
		frameIDs_scrollArea_aniStyle = frameIDs_scrollArea_aniStyle + 1
	end
	frameIDs_scrollArea[aniStyle] = frameIDs_scrollArea_aniStyle
	frame.id = frameIDs_scrollArea_aniStyle

	table.insert(wildFrames_scrollArea_aniStyle, 1, frame)
	fs:Show()
	frame:Show()
	frame.font, frame.fontSize, frame.fontOutline = fs:GetFont()
	local init = aniStyle.init
	if init then
		init(frame, scrollArea.xOffset, scrollArea.yOffset, scrollArea.size, scrollArea[sticky and "stickyDirection" or "direction"] or aniStyle.defaultDirection, frameIDs_scrollArea_aniStyle)
	end
	fs:SetAlpha(db.alpha)
	if tex then
		tex:SetAlpha(db.iconAlpha)
	end
	self:OnUpdate(scrollArea, aniStyle)
end
Parrot.ShowMessage = Parrot_Display.ShowMessage

local function isOverlapping(alpha, bravo)
	if alpha:GetLeft() <= bravo:GetRight() and bravo:GetLeft() <= alpha:GetRight() and alpha:GetBottom() <= bravo:GetTop() and bravo:GetBottom() <= alpha:GetTop() then
		return true
	end
end

function Parrot_Display:OnUpdate()
	local now = GetTime()
	for scrollArea, u in pairs(wildFrames) do
		for animationStyle, t in pairs(u) do
			local t_len = #t
			local lastFrame = newList()
			for i, frame in ipairs(t) do
				local start, length = frame.start, t.length
				if start + length <= now then
					for j = i, t_len do
						local frame = t[j]
						local cleanup = animationStyle.cleanup
						if cleanup then
							cleanup(frame, scrollArea.xOffset, scrollArea.yOffset, scrollArea.size, scrollArea[frame.sticky and "stickyDirection" or "direction"] or animationStyle.defaultDirection, frame.id)
						end
						frame:Hide()
						t[j] = nil
						freeFrames[frame] = true
						local fs = frame.fs
						fs:Hide()
						fs:SetParent(ParrotFrame)
						freeFontStrings[fs] = true
						local icon = frame.icon
						frame.icon = nil
						if icon then
							freeTextures[icon] = true
							icon:Hide()
							icon:SetTexture(nil)
							icon:ClearAllPoints()
							icon:SetParent(ParrotFrame)
						end
					end
					break
				end
				local percent = (now - start) / length
				if percent >= 0.8 then
					local alpha = (1-percent) * 5
					frame.fs:SetAlpha(alpha * db.alpha)
					if frame.icon then
						frame.icon:SetAlpha(alpha * db.iconAlpha)
					end
				end

				frame:ClearAllPoints()
				animationStyle.func(frame, scrollArea.xOffset, scrollArea.yOffset, scrollArea.size, percent, scrollArea[frame.sticky and "stickyDirection" or "direction"] or animationStyle.defaultDirection, i, t_len, frame.id)
				frame:SetWidth(frame.fs:GetWidth() + (frame.icon and (frame.icon:GetWidth() + 3) or 0))
				frame:SetHeight(math.max(frame.fs:GetHeight(), frame.icon and frame.icon:GetHeight() or 0))

				if animationStyle.overlap then
					for h = #lastFrame, 1, -1 do
						if isOverlapping(lastFrame[h], frame) then
							local done = false
							local minimum = percent
							local maximum = 1
							local current = (percent + maximum) / 2
							while maximum - minimum > 0.01 do
								animationStyle.func(frame, scrollArea.xOffset, scrollArea.yOffset, scrollArea.size, current, scrollArea[frame.sticky and "stickyDirection" or "direction"] or animationStyle.defaultDirection, i, t_len, frame.id)
								frame:SetWidth(frame.fs:GetWidth() + (frame.icon and (frame.icon:GetWidth() + 3) or 0))
								frame:SetHeight(math.max(frame.fs:GetHeight(), frame.icon and frame.icon:GetHeight() or 0))
								if isOverlapping(lastFrame[h], frame) then
									minimum = current
								else
									maximum = current
								end
								current = (maximum + minimum) / 2
							end
							current = current + 0.01
							frame.start = -current * length + now
							animationStyle.func(frame, scrollArea.xOffset, scrollArea.yOffset, scrollArea.size, current, scrollArea[frame.sticky and "stickyDirection" or "direction"] or animationStyle.defaultDirection, i, t_len, frame.id)
							frame:SetWidth(frame.fs:GetWidth() + (frame.icon and (frame.icon:GetWidth() + 3) or 0))
							frame:SetHeight(math.max(frame.fs:GetHeight(), frame.icon and frame.icon:GetHeight() or 0))
							for j = i+1, t_len do
								local v = t[j]
								if v.start > frame.start then
									v.start = frame.start
								end
							end
						end
					end
				end
				lastFrame[#lastFrame+1] = frame
			end
			lastFrame = del(lastFrame)
			if not t[1] then
				u[animationStyle] = del(t)
			end
		end
		if not next(u) then
			wildFrames[scrollArea] = del(u)
		end
	end
	if not next(wildFrames) then
		wildFrames = del(wildFrames)
		ParrotFrame:Hide()
	end
end

local flasher
local function makeflasher()
	if flasher then
		return
	end
	flasher = CreateFrame("Frame", "ParrotFlash", UIParent)
	flasher:SetFrameStrata("BACKGROUND")
	flasher:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",})
	flasher:SetAllPoints( UIParent)
	flasher:SetScript("OnShow", function (self)
			self.elapsed = 0
			self:SetAlpha(0)
	end)
	flasher:SetScript("OnUpdate", function (self, elapsed)
			elapsed = self.elapsed + elapsed
			if elapsed >= 1 then
				self:Hide()
				self:SetAlpha(0)
				return
			end
			local alpha = 1 - math.abs(elapsed - 0.5)
			if elapsed > 0.2 then
				--alpha = 0.4 - alpha
			end
			self:SetAlpha(alpha * 0.7)
			self.elapsed = elapsed
	end)
	flasher:Hide()
end

local function doFlash(self, r, g, b)
	flasher:SetBackdropColor(r, g, b, 255)
	flasher:Show()
end

local function initFlasherAndFlash(self, r, g, b)
	makeflasher()
	Parrot_Display.Flash = doFlash
	doFlash(self, r, g, b)
end

Parrot_Display.Flash = initFlasherAndFlash
