local E, L, C = select(2, ...):unpack()

local tinsert = table.insert
local tremove = table.remove
local P = E["Party"]

P.extraBars = {}
P.raidGroup = {}
P.raidPriority = {}

function P:UpdateRaidPriority(spellType, column)
	local db = E.db.priority
	if spellType then
		if not column then
			P.raidGroup[spellType] = nil
			P.raidPriority[spellType] = 100
		else
			P.raidGroup[spellType] = column
			P.raidPriority[spellType] = 900 - 100 * column + db[spellType]
		end
	else
		wipe(P.raidGroup)

		for k in pairs(db) do
			P.raidPriority[k] = 100
		end

		for i = 1, 8 do
			local group = E.db.extraBars.raidCDBar["group" .. i]
			for k, v  in pairs(group) do
				if v then
					P.raidGroup[k] = i
					P.raidPriority[k] = 900 - 100 * i + db[k]
				end
			end
		end
	end
end

local function OmniCD_ExBarOnHide(self)
	local key = self.key
	if not P.disabled and E.db.extraBars[key].enabled then
		return
	end

	P:RemoveUnusedIcons(self, 1)
	self.numIcons = 0
end

function P:HideExBars(force)
	for _, f in pairs(self.extraBars) do
		f:Hide()
		if force then
			self:RemoveUnusedIcons(f, 1)
			f.numIcons = 0
		end
	end
end

local function CreateBar(key)
	local f = CreateFrame("Frame", "OmniCD" .. key, UIParent, "OmniCDTemplate")
	f.key = key
	f.icons = {}
	f.numIcons = 0
	f:SetScript("OnShow", nil)
	f:SetScript("OnHide", OmniCD_ExBarOnHide)

	f.anchor.text:SetFontObject(E.AnchorFont)
	local name = key == "interruptBar" and L["Interrupts"] or L["Raid CD"]
	f.anchor.text:SetText(name)
	f.anchor.text:SetTextColor(1, 0.824, 0)
	f.anchor.background:SetColorTexture(0, 0, 0, 1)
	f.anchor.background:SetGradientAlpha("Horizontal", 1, 1, 1, 1, 1, 1, 1, .05)
	f.anchor:EnableMouse(true)

	return f
end

function P:CreateExBars()
	if next(self.extraBars) == nil then
		for i = 1, 2 do
			local key = i == 1 and "interruptBar" or "raidCDBar"
			self.extraBars[key] = CreateBar(key)
		end

		for i = 1, 8 do
			local f = CreateBar("raidCDBar" .. i)
			f.anchor.text:SetText(format(L["CD-Group %d"], i))
			f:SetScript("OnHide", nil)
			f:SetParent(self.extraBars.raidCDBar)
		end
	end
end

function P:UpdateExBar(bar, isGRU)
	for i = 1, 2 do
		local key = i == 1 and "interruptBar" or "raidCDBar"
		local f = self.extraBars[key]
		local f_icons = f.icons
		local f_container = f.container
		local icons = bar.icons
		local db = E.db.extraBars[key]
		if db.enabled then
			local n  = 0
			for j = bar.numIcons, 1, -1 do
				local icon = icons[j]
				local spellID = icon.spellID
				local sId = tostring(spellID)
				if (i == 1 and icon.type == "interrupt") or (i == 2 and E.db.raidCDS[sId]) then
					tremove(icons, j)
					tinsert(f_icons, icon)
					icon:SetParent(f_container)

					local statusBar = icon.statusBar
					if f.isProgressBarShown then
						statusBar = statusBar or self.GetStatusBar(icon, key)
					elseif statusBar then
						P.RemoveStatusBar(statusBar)
						icon.statusBar = nil
					end
					n = n + 1
				end
			end
			bar.numIcons = bar.numIcons - n
			f.numIcons = f.numIcons + n

			if not isGRU then
				self:SetExIconLayout(key, nil, true, true)
			end
		end
	end
end

function P:UpdateExPositionValues()
	for key, f in pairs(self.extraBars) do
		local db = E.db.extraBars[key]
		local px = E.PixelMult / db.scale
		local isProgressBarShown = db.enabled and db.progressBar
		local growUpward = db.growUpward
		local growLeft = db.growLeft
		local growX = growLeft and -1 or 1
		local growY = growUpward and 1 or -1

		f.point = "TOPLEFT"
		f.anchorPoint = "BOTTOMLEFT"
		f.anchorOfsY = growUpward and -E.BASE_ICON_SIZE * db.scale - 15 or 0

		if db.layout == "horizontal" or db.layout == "multirow" then
			f.point2 = growLeft and "TOPRIGHT" or "TOPLEFT"
			f.relat2 = growLeft and "TOPLEFT" or "TOPRIGHT"
			f.ofsX1 = 0
			f.ofsY1 = growY * (E.BASE_ICON_SIZE + db.paddingY * px)
			f.ofsX2 = growX * db.paddingX * px
			f.ofsY2 = 0
			f.isProgressBarShown = nil
		else
			f.point2 = growUpward and "BOTTOMLEFT" or "TOPLEFT"
			f.relat2 = growUpward and "TOPLEFT" or "BOTTOMLEFT"
			f.ofsX1 = growX * (E.BASE_ICON_SIZE + (db.paddingX  * px) + (isProgressBarShown and db.statusBarWidth or 0))
			f.ofsY1 = 0
			f.ofsX2 = 0
			f.ofsY2 = growY * db.paddingY * px
			f.isProgressBarShown = isProgressBarShown
		end

		if key == "interruptBar" then
			self.rearrangeInterrupts = db.sortBy == 2
		else
			for i = 1, 8 do
				local g = _G["OmniCDraidCDBar" .. i]
				local growLeft = db.groupGrowLeft[i]
				local growUpward = db.groupGrowUpward[i]
				local growX = growLeft and -1 or 1
				local growY = growUpward and 1 or -1

				g.point = "TOPLEFT"
				g.anchorPoint = "BOTTOMLEFT"
				g.anchorOfsY = growUpward and -E.BASE_ICON_SIZE * db.scale -15 or 0

				if db.layout == "horizontal" or db.layout == "multirow" then
					g.point2 = growLeft and "TOPRIGHT" or "TOPLEFT"
					g.relat2 = growLeft and "TOPLEFT" or "TOPRIGHT"
					g.ofsX1 = 0
					g.ofsY1 = growY * (E.BASE_ICON_SIZE + db.paddingY * px)
					g.ofsX2 = growX * db.paddingX * px
					g.ofsY2 = 0
				else
					g.point2 = growUpward and "BOTTOMLEFT" or "TOPLEFT"
					g.relat2 = growUpward and "TOPLEFT" or "BOTTOMLEFT"
					g.ofsX1 = growX * (E.BASE_ICON_SIZE + (db.paddingX  * px) + (isProgressBarShown and db.statusBarWidth or 0))
					g.ofsY1 = 0
					g.ofsX2 = 0
					g.ofsY2 = growY * db.paddingY * px
				end
			end

			f.groupPadding = (db.layout == "multicolumn" and growX or (db.layout == "multirow" and growY) or 0) * db.groupPadding
		end
	end
end

do
	local timers = {}

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
		function(a, b)
			local aRprio, bRprio = P.raidPriority[a.type], P.raidPriority[b.type]
			if aRprio == bRprio then
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
			end
			return aRprio > bRprio
		end,
	}

	local reverseSort = function(b, a)
		return sorters[E.db.extraBars.interruptBar.sortBy](a, b)
	end

	local updateLayout = function(key, noDelay, sortOrder, updateSettings)
		local f = P.extraBars[key]
		local db = E.db.extraBars[key]
		local isMulticolumn = db.layout == "multicolumn"
		local isMultirow = db.layout == "multirow"
		local isMultiline = isMulticolumn or isMultirow

		local n = 0
		for i = f.numIcons, 1, -1 do
			local icons = f.icons
			local icon = icons[i]
			local info = P.groupInfo[icon.guid]
			local spellIcon = info and info.spellIcons[icon.spellID]
			if icon ~= spellIcon then
				P:RemoveIcon(icon)
				tremove(icons, i)
				n = n + 1
			end
		end
		f.numIcons = f.numIcons - n

		if sortOrder then
			local sortFunc = isMultiline and sorters[5] or (db.sortDirection == "dsc" and reverseSort or sorters[db.sortBy])
			sort(f.icons, sortFunc)
		end

		local count, rows, gRows, groups, detached, g = 0, 0, 0, 0, 0
		local columns = db.columns
		for i = 1, f.numIcons do
			local icon = f.icons[i]
			icon:Hide()
			icon:ClearAllPoints()

			local columnIndex = P.raidGroup[icon.type]
			if i > 1 then
				count = count + 1
				if isMultiline and columnIndex ~= P.raidGroup[f.icons[i-1].type] then
					if columnIndex and db.groupDetached[columnIndex] then
						g = _G["OmniCDraidCDBar" .. columnIndex]
						icon:SetPoint(g.point, g.container)
						gRows = gRows + 1
						detached = detached + 1
					else
						g = nil
						icon:SetPoint(f.point, f.container, isMulticolumn and (f.ofsX1 * rows + f.groupPadding * (groups - detached)) or 0, isMultirow and (f.ofsY1 * rows + f.groupPadding * (groups - detached)) or 0)
						rows = rows + 1
					end
					count = 0
					groups = groups + 1
				elseif count == columns then
					if g then
						icon:SetPoint(g.point, g.container, g.ofsX1 * gRows, g.ofsY1 * gRows)
						gRows = gRows + 1
					else
						icon:SetPoint(f.point, f.container, isMulticolumn and (f.ofsX1 * rows + f.groupPadding * (groups-1 - detached)) or f.ofsX1 * rows, isMultirow and (f.ofsY1 * rows + f.groupPadding * (groups-1 - detached)) or f.ofsY1 * rows)
						rows = rows + 1
					end
					count = 0
				else
					if g then
						icon:SetPoint(g.point2, f.icons[i-1], g.relat2, g.ofsX2, g.ofsY2)
					else
						icon:SetPoint(f.point2, f.icons[i-1], f.relat2, f.ofsX2, f.ofsY2)
					end
				end
			else
				if columnIndex and db.groupDetached[columnIndex] then
					g = _G["OmniCDraidCDBar" .. columnIndex]
					icon:SetPoint(g.point, g.container)
					gRows = gRows + 1
					detached = detached + 1
				else
					icon:SetPoint(f.point, f.container)
					rows = rows + 1
				end
				groups = groups + 1
			end

			icon:Show()
		end

		if not noDelay or updateSettings then
			P:ApplyExSettings(key)
		end

		timers[key] = nil
	end


	function P:SetExIconLayout(key, noDelay, sortOrder, updateSettings)
		if self.disabled then
			return
		end

		if noDelay then
			updateLayout(key, noDelay, sortOrder, updateSettings)
		else
			if not timers[key] then
				timers[key] = E.TimerAfter(0.5, updateLayout, key, noDelay, sortOrder, updateSettings)
			end
		end
	end
end

function P:ToggleColumnAnchors()
	local db = E.db.extraBars.raidCDBar
	for i = 1, 8 do
		local g = _G["OmniCDraidCDBar" .. i]
		if (db.layout == "multicolumn" or db.layout == "multirow")and db.groupDetached[i] then
			g.anchor:ClearAllPoints()
			g.anchor:SetPoint(g.anchorPoint, g, g.point, 0, g.anchorOfsY)
			if self.extraBars.raidCDBar.isProgressBarShown then
				g.anchor:SetWidth(( E.BASE_ICON_SIZE + db.statusBarWidth) * db.scale)
			else
				E.SetWidth(g.anchor)
			end

			E.LoadPosition(g)
			g:Show()
			g.anchor:SetShown(not db.locked)
		else
			g:Hide()
			g.anchor:Hide()
		end
	end
end

function P:SetExAnchor(key)
	local f = self.extraBars[key]
	local db = E.db.extraBars[key]
	if db.locked then
		f.anchor:Hide()
	else
		f.anchor:ClearAllPoints()
		f.anchor:SetPoint(f.anchorPoint, f, f.point, 0, f.anchorOfsY)
		if f.isProgressBarShown then
			f.anchor:SetWidth(( E.BASE_ICON_SIZE + db.statusBarWidth) * db.scale)
		else
			E.SetWidth(f.anchor)
		end
		f.anchor:Show()
	end

	if key == "raidCDBar" then
		P:ToggleColumnAnchors()
	end
end

function P:UpdateExBarBackdrop(f, key)
	local icons = f.icons
	for i = 1, f.numIcons do
		local icon = icons[i]
		self:SetExBorder(icon, key)
	end
end

function P:SetExScale(key)
	local f = self.extraBars[key]
	local db = E.db.extraBars[key]
	f.container:SetScale(db.scale)
	if E.db.icons.displayBorder or (db.layout ~= "horizontal" or db.layout ~= "multirow") and db.progressBar then
		self:UpdateExBarBackdrop(f, key)
	end
end

function P:SetExBorder(icon, key)
	local db = E.db.extraBars[key]
	local db_icon = E.db.icons
	local edgeSize = db_icon.borderPixels * E.PixelMult / db.scale
	local r, g, b = db_icon.borderColor.r, db_icon.borderColor.g, db_icon.borderColor.b
	local isProgressBarShown = self.extraBars[key].isProgressBarShown

	if isProgressBarShown or db_icon.displayBorder then
		icon.borderTop:ClearAllPoints()
		icon.borderBottom:ClearAllPoints()
		icon.borderLeft:ClearAllPoints()
		icon.borderRight:ClearAllPoints()

		icon.borderTop:SetPoint("TOPLEFT", icon, "TOPLEFT")
		icon.borderTop:SetPoint("BOTTOMRIGHT", icon, "TOPRIGHT", 0, -edgeSize)
		icon.borderBottom:SetPoint("BOTTOMLEFT", icon, "BOTTOMLEFT")
		icon.borderBottom:SetPoint("TOPRIGHT", icon, "BOTTOMRIGHT", 0, edgeSize)
		icon.borderLeft:SetPoint("TOPLEFT", icon, "TOPLEFT")
		icon.borderLeft:SetPoint("BOTTOMRIGHT", icon, "BOTTOMLEFT", edgeSize, 0)
		icon.borderRight:SetPoint("TOPRIGHT", icon, "TOPRIGHT")
		icon.borderRight:SetPoint("BOTTOMLEFT", icon, "BOTTOMRIGHT", -edgeSize, 0)

		icon.borderTop:SetColorTexture(r, g, b)
		icon.borderBottom:SetColorTexture(r, g, b)
		icon.borderLeft:SetColorTexture(r, g, b)
		icon.borderRight:SetColorTexture(r, g, b)

		icon.borderTop:Show()
		icon.borderBottom:Show()
		icon.borderLeft:Show()
		icon.borderRight:Show()

		icon.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

		if isProgressBarShown then
			local statusBar = icon.statusBar
			if db.hideBar then
				statusBar:DisableDrawLayer("BORDER")
			else
				statusBar:EnableDrawLayer("BORDER")
			end

			statusBar.borderTop:ClearAllPoints()
			statusBar.borderBottom:ClearAllPoints()
			statusBar.borderRight:ClearAllPoints()

			statusBar.borderTop:SetPoint("TOPLEFT", statusBar, "TOPLEFT")
			statusBar.borderTop:SetPoint("BOTTOMRIGHT", statusBar, "TOPRIGHT", 0, -edgeSize)
			statusBar.borderBottom:SetPoint("BOTTOMLEFT", statusBar, "BOTTOMLEFT")
			statusBar.borderBottom:SetPoint("TOPRIGHT", statusBar, "BOTTOMRIGHT", 0, edgeSize)
			statusBar.borderRight:SetPoint("TOPRIGHT", statusBar.borderTop, "BOTTOMRIGHT")
			statusBar.borderRight:SetPoint("BOTTOMLEFT", statusBar.borderBottom, "TOPRIGHT", -edgeSize, 0)


			if db.hideBorder then
				statusBar.borderTop:Hide()
				statusBar.borderBottom:Hide()
				statusBar.borderRight:Hide()
			else
				statusBar.borderTop:SetColorTexture(r, g, b)
				statusBar.borderBottom:SetColorTexture(r, g, b)
				statusBar.borderRight:SetColorTexture(r, g, b)
				statusBar.borderTop:Show()
				statusBar.borderBottom:Show()
				statusBar.borderRight:Show()
			end
		end
	else
		icon.borderTop:Hide()
		icon.borderBottom:Hide()
		icon.borderRight:Hide()
		icon.borderLeft:Hide()

		icon.icon:SetTexCoord(0, 1, 0, 1)
	end
end

function P:SetExStatusBarWidth(f, key)
	local db = E.db.extraBars[key]
	f:SetWidth(db.statusBarWidth)
	f.Text:SetPoint("LEFT", f, db.textOfsX, db.textOfsY)
	f.CastingBar.Text:SetPoint("LEFT", f.CastingBar, db.textOfsX, db.textOfsY)
	f.CastingBar.Timer:SetPoint("RIGHT", f.CastingBar, -3, db.textOfsY)
end

function P:SetExIconName(icon, key)
	local db = E.db.extraBars[key]
	if self.extraBars[key].isProgressBarShown or not db.showName then
		icon.Name:Hide()
	else
		icon.Name:SetText(P.groupInfo[icon.guid].name)
		icon.Name:Show()
	end
end

function P:SetExStatusBarColor(icon, key)
	local info = P.groupInfo[icon.guid]
	if not info then return end

	local db = E.db.extraBars[key]
	local c, r, g, b, a = RAID_CLASS_COLORS[icon.class]
	local statusBar = icon.statusBar




	if not db.hideBar or not icon.active then
		if info.isDeadOrOffline then
			r, g, b = 0.3, 0.3, 0.3
		elseif db.textColors.useClassColor.inactive then
			r, g, b = c.r, c.g, c.b
		else
			local db_text = db.textColors.inactiveColor
			r, g, b = db_text.r, db_text.g, db_text.b
		end
		statusBar.Text:SetTextColor(r, g, b)
	end

	statusBar.BG:SetShown(not db.hideBar and not icon.active)
	statusBar.Text:SetShown(db.hideBar or not icon.active)


	local db_bar = db.barColors.inactiveColor
	local alpha = db.useIconAlpha and 1 or db_bar.a
	local spellID = icon.spellID
	if info.isDeadOrOffline then
		r, g, b, a = 0.3, 0.3, 0.3, alpha
	elseif info.preActiveIcons[spellID] and spellID ~= 1022 and spellID ~= 204018 then
		r, g, b, a = 0.7, 0.7, 0.7, alpha
	elseif db.barColors.useClassColor.inactive then
		r, g, b, a = c.r, c.g, c.b, alpha
	else
		r, g, b, a =  db_bar.r, db_bar.g, db_bar.b, alpha
	end
	statusBar.BG:SetVertexColor(r, g, b, a)


end

function P:ApplyExSettings(key)
	P:SetExAnchor(key)
	P:SetExScale(key)

	local f = self.extraBars[key]
	for i = 1, f.numIcons do
		local icon = f.icons[i]
		self:SetExBorder(icon, key)
		self:SetExIconName(icon, key)
		local statusBar = icon.statusBar
		if statusBar then
			self:SetExStatusBarWidth(statusBar, key)
			self:SetExStatusBarColor(icon, key)
		end
		self:SetMarker(icon)
		self:SetAlpha(icon)
		self:SetSwipe(icon)
		self:SetCounter(icon)
		self:SetChargeScale(icon)
		self:SetTooltip(icon)
	end
end

function P:UpdateExPosition()
	if self.disabled then
		return
	end

	for key, f in pairs(self.extraBars) do
		if E.db.extraBars[key].enabled then
			self:SetExIconLayout(key, true, true, true)
			E.LoadPosition(f)
			f:Show()
		else
			f:Hide()
		end
	end
end
