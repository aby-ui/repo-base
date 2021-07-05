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
				if v then -- we nil this in options but whatever
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
	--f.anchor.text:SetTextColor(1, 0.824, 0) -- #ffd200
	E.SetWidth(f.anchor)
	f.anchor.background:SetColorTexture(0, 0, 0, 1)
	f.anchor.background:SetGradientAlpha("Horizontal", 1, 1, 1, 1, 1, 1, 1, 0)
	f.anchor:EnableMouse(true)

	return f
end

function P:CreateExBars()
	if next(self.extraBars) == nil then
		for i = 1, 2 do
			local key = i == 1 and "interruptBar" or "raidCDBar"
			self.extraBars[key] = CreateBar(key)
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

					local statusBar = icon.statusBar -- always nil
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

			if not isGRU then -- prevent updating for every roster on GRU (inspect is still per roster)
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
		local growY = growUpward and 1 or -1

		if db.layout == "horizontal" then
			f.point = "TOPLEFT"
			f.relat = "TOPRIGHT"
			f.ofsX1 = 0
			f.ofsY1 = growY * (E.BASE_ICON_SIZE + db.paddingY * px)
			f.ofsX2 = db.paddingX * px
			f.ofsY2 = 0
			--[[ #iss259 let the user decide
			if key == "interruptBar" then
				self.rearrangeInterrupts = nil
			end
			]]
			f.isProgressBarShown = nil
		else
			f.point = growUpward and "BOTTOMLEFT" or "TOPLEFT"
			f.relat = growUpward and "TOPLEFT" or "BOTTOMLEFT"
			f.ofsX1 = E.BASE_ICON_SIZE + (db.paddingX  * px) + (isProgressBarShown and db.statusBarWidth or 0)
			f.ofsY1 = 0
			f.ofsX2 = 0
			f.ofsY2 = growY * db.paddingY * px
			--[[ #iss259
			if key == "interruptBar" then
				self.rearrangeInterrupts = isProgressBarShown and db.sortBy == 2
			end
			]]
			f.isProgressBarShown = isProgressBarShown
		end

		if key == "interruptBar" then -- #iss259
			self.rearrangeInterrupts = db.sortBy == 2
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
						return P.groupInfo[a.guid].name < P.groupInfo[b.guid].name -- end with name so we don't see it shuffling around
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
		function(a, b) -- reserved for multicolumn layout
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

		local n = 0
		for i = f.numIcons, 1, -1 do
			local icons = f.icons
			local icon = icons[i]
			local info = P.groupInfo[icon.guid]
			local spellIcon = info and info.spellIcons[icon.spellID]
			if icon ~= spellIcon then -- [104]
				P:RemoveIcon(icon)
				tremove(icons, i)
				n = n + 1
			end
		end
		f.numIcons = f.numIcons - n

		if sortOrder then
			local sortFunc = isMulticolumn and sorters[5] or (db.sortDirection == "dsc" and reverseSort or sorters[db.sortBy])
			sort(f.icons, sortFunc)
		end

		local count, rows, groups = 0, 1, 1
		local columns = db.columns
		for i = 1, f.numIcons do
			local icon = f.icons[i]
			icon:Hide()
			icon:ClearAllPoints()

			if i > 1 then
				count = count + 1
				if isMulticolumn and P.raidGroup[icon.type] ~= P.raidGroup[f.icons[i-1].type] then
					icon:SetPoint(f.point, f.container, f.ofsX1 * rows + db.groupPadding * groups, 0)
					count = 0
					rows = rows + 1
					groups = groups + 1
				elseif count == columns then
					icon:SetPoint(f.point, f.container, isMulticolumn and (f.ofsX1 * rows + db.groupPadding * (groups-1)) or f.ofsX1 * rows, f.ofsY1 * rows)
					count = 0
					rows = rows + 1
				else
					icon:SetPoint(f.point, f.icons[i-1], f.relat, f.ofsX2, f.ofsY2)
				end
			else
				icon:SetPoint(f.point, f.container)
			end

			icon:Show()
		end

		if not noDelay or updateSettings then -- [88]
			P:ApplyExSettings(key)
		end

		timers[key] = nil
	end


	function P:SetExIconLayout(key, noDelay, sortOrder, updateSettings) -- removed all delay from options. we don't want a slouchy response
		if self.disabled then -- [102]
			return
		end

		if noDelay then
			updateLayout(key, noDelay, sortOrder, updateSettings)
		else
			if not timers[key] then -- [33]
				timers[key] = E.TimerAfter(0.5, updateLayout, key, noDelay, sortOrder, updateSettings)
			end
		end
	end
end

function P:SetExAnchor(key)
	local f = self.extraBars[key]
	if E.db.extraBars[key].locked then
		f.anchor:Hide()
	else
		f.anchor:ClearAllPoints()
		if E.db.extraBars[key].growUpward then
			f.anchor:SetPoint("TOPLEFT", f, "BOTTOMLEFT")
		else
			f.anchor:SetPoint("BOTTOMLEFT", f, "TOPLEFT")
		end
		f.anchor:Show()
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
	if db.layout ~= "horizontal" and db.progressBar or E.db.icons.displayBorder then
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
	else
		icon.borderTop:Hide()
		icon.borderBottom:Hide()
		icon.borderRight:Hide()
		icon.borderLeft:Hide()

		icon.icon:SetTexCoord(0, 1, 0, 1)
	end

	if isProgressBarShown then
		local statusBar = icon.statusBar
		statusBar.borderTop:ClearAllPoints()
		statusBar.borderBottom:ClearAllPoints()
		statusBar.borderRight:ClearAllPoints()

		statusBar.borderTop:SetPoint("TOPLEFT", statusBar, "TOPLEFT")
		statusBar.borderTop:SetPoint("BOTTOMRIGHT", statusBar, "TOPRIGHT", 0, -edgeSize)
		statusBar.borderBottom:SetPoint("BOTTOMLEFT", statusBar, "BOTTOMLEFT")
		statusBar.borderBottom:SetPoint("TOPRIGHT", statusBar, "BOTTOMRIGHT", 0, edgeSize)
		statusBar.borderRight:SetPoint("TOPRIGHT", statusBar.borderTop, "BOTTOMRIGHT")
		statusBar.borderRight:SetPoint("BOTTOMLEFT", statusBar.borderBottom, "TOPRIGHT", -edgeSize, 0)

		statusBar.borderTop:SetColorTexture(r, g, b)
		statusBar.borderBottom:SetColorTexture(r, g, b)
		statusBar.borderRight:SetColorTexture(r, g, b)
	end
end

function P:SetExStatusBarWidth(f, key)
	local width = E.db.extraBars[key].statusBarWidth
	f:SetWidth(width)
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
	local db = E.db.extraBars[key]
	local c, r, g, b, a = RAID_CLASS_COLORS[icon.class]
	local statusBar = icon.statusBar

	-- inactive bg doesn't exist

	-- inactive bar
	local db_bar = db.barColors.inactiveColor
	local alpha = db.useIconAlpha and 1 or db_bar.a
	local spellID = icon.spellID
	if P.groupInfo[icon.guid].preActiveIcons[spellID] and spellID ~= 1022 and spellID ~= 204018 then -- [81] filter BOP/BOS
		r, g, b, a = 0.7, 0.7, 0.7, alpha -- [A]
	elseif db.barColors.useClassColor.inactive then
		r, g, b, a = c.r, c.g, c.b, alpha
	else
		r, g, b, a =  db_bar.r, db_bar.g, db_bar.b, alpha
	end
	statusBar.BG:SetVertexColor(r, g, b, a)

	-- inactive text
	if db.textColors.useClassColor.inactive then
		r, g, b = c.r, c.g, c.b
	else
		local db_text = db.textColors.inactiveColor
		r, g, b = db_text.r, db_text.g, db_text.b
	end
	statusBar.Text:SetTextColor(r, g, b)

	--> active & recharge done in CastingBarFrame_OnLoad
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
		--self:SetAtlas(icon)
	end
end

function P:UpdateExPosition()
	if self.disabled then
		return
	end

	for key, f in pairs(self.extraBars) do
		if E.db.extraBars[key].enabled then
			self:SetExIconLayout(key, true, true, true) -- [105]
			E.LoadPosition(f)
			f:Show()
		else
			f:Hide()
		end
	end
end
