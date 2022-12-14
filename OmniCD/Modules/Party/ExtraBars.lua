local E, L = select(2, ...):unpack()
local P = E.Party

P.extraBars = {}

local function OmniCDExBar_OnHide(self)
	local key = self.key
	if not P.disabled and E.db.extraBars[key].enabled then
		return
	end

	P:RemoveUnusedIcons(self, 1)
	self.numIcons = 0
end

function P:HideExBars(force)
	for _, frame in pairs(self.extraBars) do
		frame:Hide()
		if force then
			self:RemoveUnusedIcons(frame, 1)
			frame.numIcons = 0
		end
	end
end

function P:CreateExtraBarFrames()
	if next(self.extraBars) then return end
	for i = 0, 8 do
		local key = "raidBar" .. i
		local frame = CreateFrame("Frame", E.AddOn .. key, UIParent, "OmniCDTemplate")
		frame.index = i
		frame.key = key
		frame.icons = {}
		frame.numIcons = 0
		frame.db = E.db.extraBars[key]
		frame:SetScript("OnShow", nil)
		frame:SetScript("OnHide", OmniCDExBar_OnHide)

		frame.anchor.text:SetFontObject(E.AnchorFont)
		local name = key == "raidBar0" and L["Interrupts"] or i
		frame.anchor.text:SetText(name)
		frame.anchor.text:SetTextColor(1, 0.824, 0)
		frame.anchor.background:SetColorTexture(0, 0, 0, 1)
		if E.isDF or E.TocVersion == 30401 then
			frame.anchor.background:SetGradient("HORIZONTAL", CreateColor(1, 1, 1, 1), CreateColor(1, 1, 1, .05))
		else
			frame.anchor.background:SetGradientAlpha("Horizontal", 1, 1, 1, 1, 1, 1, 1, .05)
		end
		frame.anchor:EnableMouse(true)
		frame.anchor:SetScript("OnMouseUp", E.OmniCDAnchor_OnMouseUp)
		frame.anchor:SetScript("OnMouseDown", E.OmniCDAnchor_OnMouseDown)

		self.extraBars[key] = frame
	end
end

function P:UpdateExBarPositionValues()
	for key, frame in pairs(self.extraBars) do
		local db = frame.db
		local pixel = E.PixelMult / db.scale
		local growLeft = db.growLeft
		local growX = growLeft and -1 or 1
		local growRowsUpward = db.growUpward
		local growY = growRowsUpward and 1 or -1
		local isProgressBarEnabled = db.enabled and db.progressBar

		frame.point = "TOPLEFT"
		frame.anchorPoint = "BOTTOMLEFT"
		frame.anchorOfsY = growRowsUpward and -(E.BASE_ICON_SIZE * db.scale + 15) or 0

		if db.layout == "horizontal" then
			if growLeft then
				frame.point2 = "TOPRIGHT"
				frame.relativePoint2 = "TOPLEFT"
				frame.ofsX2 = -(db.paddingX * pixel)
			else
				frame.point2 = "TOPLEFT"
				frame.relativePoint2 = "TOPRIGHT"
				frame.ofsX2 = db.paddingX * pixel
			end
			frame.ofsX = 0
			frame.ofsY = growY * (E.BASE_ICON_SIZE + db.paddingY * pixel)
			frame.ofsY2 = 0
			frame.shouldShowProgressBar = nil
		else
			if growRowsUpward then
				frame.point2 = "BOTTOMLEFT"
				frame.relativePoint2 = "TOPLEFT"
				frame.ofsY2 = db.paddingY * pixel
			else
				frame.point2 = "TOPLEFT"
				frame.relativePoint2 = "BOTTOMLEFT"
				frame.ofsY2 = -(db.paddingY * pixel)
			end
			frame.ofsX = growX * (E.BASE_ICON_SIZE + (db.paddingX * pixel) + (isProgressBarEnabled and db.statusBarWidth or 0))
			frame.ofsY = 0
			frame.ofsX2 = 0
			frame.shouldShowProgressBar = isProgressBarEnabled
		end

		if key == "raidBar0" then
			self.rearrangeInterrupts = db.sortBy == 2
		end
	end
end

local sorters = {

	function(a, b)
		local acd, bcd = a.duration, b.duration
		if acd == bcd then
			if a.class == b.class then
				return P.groupInfo[a.guid].name < P.groupInfo[b.guid].name
			end
			return a.class < b.class
		end
		return acd < bcd
	end,

	function(a, b)
		local aactive = P.groupInfo[a.guid].active[a.spellID]
		local bactive = P.groupInfo[b.guid].active[b.spellID]
		if aactive and bactive then
			return a.duration + aactive.startTime < b.duration + bactive.startTime
		elseif not aactive and not bactive then
			local acd, bcd = a.duration, b.duration
			if acd == bcd then
				local aclass, bclass = a.class, b.class
				if aclass == bclass then
					return P.groupInfo[a.guid].name < P.groupInfo[b.guid].name
				end
				return aclass < bclass
			end
			return acd < bcd
		elseif aactive then return false
		elseif bactive then return true end
	end,

	function(a, b)
		local aprio, bprio = E.db.priority[a.type], E.db.priority[b.type]
		if aprio == bprio then
			local aclass, bclass = a.class, b.class
			if aclass == bclass then
				if a.spellID == b.spellID then
					return P.groupInfo[a.guid].name < P.groupInfo[b.guid].name
				end
				return a.spellID < b.spellID
			end
			return aclass < bclass
		end
		return aprio > bprio
	end,

	function(a, b)
		local aclass, bclass = a.class, b.class
		if aclass == bclass then
			local aprio, bprio = E.db.priority[a.type], E.db.priority[b.type]
			if aprio == bprio then
				if a.spellID == b.spellID then
					return P.groupInfo[a.guid].name < P.groupInfo[b.guid].name
				end
				return a.spellID < b.spellID
			end
			return aprio > bprio
		end
		return aclass < bclass
	end,
}

local _sorter

local reverseSort = function(a, b)
	return _sorter(b, a)
end

local updateLayout = function(key, noDelay, sortOrder, updateSettings)
	local frame = P.extraBars[key]
	local db = frame.db



	local n = 0
	for i = frame.numIcons, 1, -1 do
		local icons = frame.icons
		local icon = icons[i]
		local info = P.groupInfo[icon.guid]
		local spellIcon = info and info.spellIcons[icon.spellID]
		if icon ~= spellIcon then
			P:RemoveIcon(icon)
			tremove(icons, i)
			n = n + 1
		end
	end
	frame.numIcons = frame.numIcons - n

	if sortOrder then
		_sorter = sorters[db.sortBy]
		local sortFunc = db.sortDirection == "dsc" and reverseSort or _sorter
		sort(frame.icons, sortFunc)
	end

	local count, rows = 0, 0
	local columns = db.columns
	for i = 1, frame.numIcons do
		local icon = frame.icons[i]
		icon:Hide()
		icon:ClearAllPoints()

		if i > 1 then
			count = count + 1
			if count == columns then
				icon:SetPoint(frame.point, frame.container, frame.ofsX * rows, frame.ofsY * rows)
				rows = rows + 1
				count = 0
			else
				icon:SetPoint(frame.point2, frame.icons[i-1], frame.relativePoint2, frame.ofsX2, frame.ofsY2)
			end
		else
			icon:SetPoint(frame.point, frame.container)
			rows = rows + 1
		end

		icon:Show()
	end


	if not noDelay or updateSettings then
		P:ApplyExSettings(key)
	end

	P.callbackTimers[key] = nil
end


function P:SetExIconLayout(key, noDelay, sortOrder, updateSettings)
	if self.disabled then
		return
	end

	if noDelay then
		updateLayout(key, noDelay, sortOrder, updateSettings)
	else
		if not self.callbackTimers[key] then
			self.callbackTimers[key] = E.TimerAfter(0.5, updateLayout, key, noDelay, sortOrder, updateSettings)
		end
	end
end


function P:ApplyExSettings(key)
	local frame = self.extraBars[key]
	local shouldShowProgressBar = frame.shouldShowProgressBar

	local db_f = frame.db
	local locked = db_f.locked
	local statusBarWidth = db_f.statusBarWidth
	local scale = db_f.scale
	local nameBar = db_f.nameBar
	local showName = db_f.showName
	local truncateIconName = db_f.truncateIconName
	local textOfsX = db_f.textOfsX
	local textOfsY = db_f.textOfsY
	local textColors = db_f.textColors
	local barColors = db_f.barColors
	local hideBorder = db_f.hideBorder
	local invertNameBar = db_f.invertNameBar

	local db_icons = E.db.icons
	local r, g, b = db_icons.borderColor.r, db_icons.borderColor.g, db_icons.borderColor.b
	local displayBorder = db_icons.displayBorder
	local edgeSize = E.PixelMult / scale
	local desaturateActive = db_icons.desaturateActive
	local reverseSwipe = db_icons.reverse
	local swipeAlpha = db_icons.swipeAlpha
	local showCounter = db_icons.showCounter
	local counterScale = db_icons.counterScale
	local chargeScale = db_icons.chargeScale
	local showTooltip = db_icons.showTooltip


	local anchor = frame.anchor
	if locked then
		anchor:Hide()
	else
		anchor:ClearAllPoints()
		anchor:SetPoint(frame.anchorPoint, frame, frame.point, 0, frame.anchorOfsY)
		if shouldShowProgressBar then
			anchor:SetWidth((E.BASE_ICON_SIZE + statusBarWidth) * scale)
		else
			local width = math.max(anchor.text:GetWidth() + 20, E.BASE_ICON_SIZE * scale)
			anchor:SetWidth(width)
		end
		anchor:Show()
	end


	frame.container:SetScale(scale)

	local icons = frame.icons
	local numIcons = frame.numIcons
	for i = 1, numIcons do
		local icon = icons[i]
		local guid = icon.guid
		local info = self.groupInfo[guid]
		if not info then
			error("groupInfo doesn't exist for " .. guid)
		end

		local statusBar = icon.statusBar
		local iconicon = icon.icon
		local name = icon.name
		local hotKey = icon.hotKey
		local count = icon.count
		local cooldown = icon.cooldown
		local counter = icon.counter

		local isDeadOrOffline = info.isDeadOrOffline
		local class = icon.class
		local isActiveIcon = icon.active
		local spellID = icon.spellID
		local isHighlighted = icon.isHighlighted
		local maxcharges = icon.maxcharges
		local charges = maxcharges and tonumber(count:GetText())


		local borderTop, borderBottom, borderLeft, borderRight = icon.borderTop, icon.borderBottom, icon.borderLeft, icon.borderRight
		if displayBorder or shouldShowProgressBar then
			borderTop:ClearAllPoints()
			borderBottom:ClearAllPoints()
			borderLeft:ClearAllPoints()
			borderRight:ClearAllPoints()
			borderTop:SetPoint("TOPLEFT", icon, "TOPLEFT")
			borderTop:SetPoint("BOTTOMRIGHT", icon, "TOPRIGHT", 0, -edgeSize)
			borderBottom:SetPoint("BOTTOMLEFT", icon, "BOTTOMLEFT")
			borderBottom:SetPoint("TOPRIGHT", icon, "BOTTOMRIGHT", 0, edgeSize)
			borderLeft:SetPoint("TOPLEFT", icon, "TOPLEFT")
			borderLeft:SetPoint("BOTTOMRIGHT", icon, "BOTTOMLEFT", edgeSize, 0)
			borderRight:SetPoint("TOPRIGHT", icon, "TOPRIGHT")
			borderRight:SetPoint("BOTTOMLEFT", icon, "BOTTOMRIGHT", -edgeSize, 0)
			borderTop:SetColorTexture(r, g, b)
			borderBottom:SetColorTexture(r, g, b)
			borderLeft:SetColorTexture(r, g, b)
			borderRight:SetColorTexture(r, g, b)
			borderTop:Show()
			borderBottom:Show()
			borderLeft:Show()
			borderRight:Show()
			iconicon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		else
			borderTop:Hide()
			borderBottom:Hide()
			borderRight:Hide()
			borderLeft:Hide()
			iconicon:SetTexCoord(0, 1, 0, 1)
		end

		if shouldShowProgressBar then
			if nameBar then
				statusBar:DisableDrawLayer("BORDER")
			else
				statusBar:EnableDrawLayer("BORDER")
				local statusBar_borderTop, statusBar_borderBottom, statusBar_borderRight = statusBar.borderTop, statusBar.borderBottom, statusBar.borderRight
				statusBar_borderTop:ClearAllPoints()
				statusBar_borderBottom:ClearAllPoints()
				statusBar_borderRight:ClearAllPoints()
				statusBar_borderTop:SetPoint("TOPLEFT", statusBar, "TOPLEFT")
				statusBar_borderTop:SetPoint("BOTTOMRIGHT", statusBar, "TOPRIGHT", 0, -edgeSize)
				statusBar_borderBottom:SetPoint("BOTTOMLEFT", statusBar, "BOTTOMLEFT")
				statusBar_borderBottom:SetPoint("TOPRIGHT", statusBar, "BOTTOMRIGHT", 0, edgeSize)
				statusBar_borderRight:SetPoint("TOPRIGHT", statusBar_borderTop, "BOTTOMRIGHT")
				statusBar_borderRight:SetPoint("BOTTOMLEFT", statusBar_borderBottom, "TOPRIGHT", -edgeSize, 0)
				if hideBorder then
					statusBar_borderTop:Hide()
					statusBar_borderBottom:Hide()
					statusBar_borderRight:Hide()
				else
					statusBar_borderTop:SetColorTexture(r, g, b)
					statusBar_borderBottom:SetColorTexture(r, g, b)
					statusBar_borderRight:SetColorTexture(r, g, b)
					statusBar_borderTop:Show()
					statusBar_borderBottom:Show()
					statusBar_borderRight:Show()
				end
			end
		end


		if shouldShowProgressBar or not showName then
			name:Hide()
		else
			local unitName = info.name
			if truncateIconName > 0 then
				unitName = string.utf8sub(unitName, 1, truncateIconName)
			end
			name:SetText(unitName)
			name:Show()
		end

		if statusBar then

			statusBar:SetWidth(statusBarWidth)

			statusBar.Text:ClearAllPoints()
			if nameBar and invertNameBar then
				statusBar.Text:SetPoint("RIGHT", icon, "LEFT", -textOfsX, textOfsY)
			else
				statusBar.Text:SetPoint("LEFT", statusBar, textOfsX, textOfsY)
			end
			statusBar.CastingBar.Text:SetPoint("LEFT", statusBar.CastingBar, textOfsX, textOfsY)
			statusBar.CastingBar.Timer:SetPoint("RIGHT", statusBar.CastingBar, -3, textOfsY)


			local c, r, g, b, a = RAID_CLASS_COLORS[class]




			if not nameBar or not isActiveIcon then
				if isDeadOrOffline then
					r, g, b = 0.3, 0.3, 0.3
				elseif textColors.useClassColor.inactive then
					r, g, b = c.r, c.g, c.b
				else
					local text_c = textColors.inactiveColor
					r, g, b = text_c.r, text_c.g, text_c.b
				end
				statusBar.Text:SetTextColor(r, g, b)
			end

			statusBar.BG:SetShown(not nameBar and not isActiveIcon)
			statusBar.Text:SetShown(nameBar or not isActiveIcon)


			local bar_c = barColors.inactiveColor
			local alpha = bar_c.a
			if isDeadOrOffline then
				r, g, b, a = 0.3, 0.3, 0.3, alpha
			elseif info.preactiveIcons[spellID] and spellID ~= 1022 and spellID ~= 204018 then
				r, g, b, a = 0.7, 0.7, 0.7, alpha
			elseif barColors.useClassColor.inactive then
				r, g, b, a = c.r, c.g, c.b, alpha
			else
				r, g, b, a =  bar_c.r, bar_c.g, bar_c.b, alpha
			end
			statusBar.BG:SetVertexColor(r, g, b, a)
		end


		hotKey:Hide()


		icon:SetAlpha(1.0)
		if isDeadOrOffline then
			iconicon:SetDesaturated(true)
			iconicon:SetVertexColor(0.3, 0.3, 0.3)
		else
			if info.preactiveIcons[spellID] and not isHighlighted then
				iconicon:SetVertexColor(0.4, 0.4, 0.4)
			else
				iconicon:SetVertexColor(1, 1, 1)
			end
			iconicon:SetDesaturated(desaturateActive and isActiveIcon and not isHighlighted and (not charges or charges == 0));
		end


		self:SetCooldownElements(icon, icon.maxcharges and tonumber(icon.count:GetText()))
		cooldown:SetReverse(reverseSwipe)
		cooldown:SetSwipeColor(0, 0, 0, swipeAlpha)
		counter:SetScale(counterScale)


		count:SetScale(chargeScale)


		icon:EnableMouse(showTooltip)
	end
end

function P:UpdateExBars()
	if self.disabled then
		return
	end

	for key, frame in pairs(self.extraBars) do
		if frame.db.enabled then
			self:SetExIconLayout(key, true, true, true)
			E.LoadPosition(frame)
			frame:Show()
		else
			frame:Hide()
		end
	end
end
