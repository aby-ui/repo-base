local E, L, C = select(2, ...):unpack()
local P = E.Party

P.options = {
	disabled = function(info)
		return info[2] and not E:GetModuleEnabled("Party")
	end,
	name = FRIENDLY,
	order = 20,
	type = "group",
	get = function(info) return E.profile.Party[ info[#info] ] end,
	set = function(info, value) E.profile.Party[ info[#info] ] = value end,
	args = {},
}

local getZoneName = function(info)
	local key = info[2] return E.L_ALL_ZONE[key]
end

local getEnabled = function(info)
	return E.profile.Party.visibility[ info[2] ]
end

local setEnabled = function(info, value)
	local key = info[2]
	E.profile.Party.visibility[key] = value
	if P.isInTestMode and P.testZone == key then
		P:Test()
	end
	P:Refresh(true)
end

local getTestMode = function(info)
	return P.testZone == info[2] and P.isInTestMode
end

local setTestMode = function(info, state)
	P:Test(state and info[2])
end

local cfgZone = {
	disabled = function(info)
		return info[3] and not E.profile.Party.visibility[ info[2] ] or not E:GetModuleEnabled("Party")
	end,
	name = getZoneName,
	type = "group",
	childGroups = "tab",
	args = {
		enabled = {
			disabled = false,
			name = ENABLE,
			desc = L["Enable CD tracking in the current zone"],
			order = 1,
			type = "toggle",
			get = getEnabled,
			set = setEnabled,
		},
		test = {
			name = L["Test"],
			desc = L["Toggle raid-style party frame and player spell bar for testing"],
			order = 2,
			type = "toggle",
			get = getTestMode,
			set = setTestMode,
		},
	}
}

local noCfgZone = {
	disabled = function(info)
		return info[3] and not E.profile.Party.visibility[ info[2] ] or not E:GetModuleEnabled("Party")
	end,
	name = getZoneName,
	type = "group",
	childGroups = "tab",
	args = {
		enabled = {
			disabled = false,
			name = ENABLE,
			desc = L["Enable CD tracking in the current zone"],
			order = 1,
			type = "toggle",
			get = getEnabled,
			set = setEnabled,
		},
		test = {
			name = L["Test"],
			desc = L["Toggle raid-style party frame and player spell bar for testing"],
			order = 2,
			type = "toggle",
			get = getTestMode,
			set = setTestMode,
		},
		lb1 = {
			name = "\n", order = 3, type = "description",
		},
		zoneSetting = {
			name = L["Use Zone Settings From:"],
			desc = L["Select the zone setting to use for this zone."],
			order = 4,
			type = "select",
			values = E.L_CFG_ZONE,
			get = function(info)
				return E.profile.Party[info[2] == "none" and "noneZoneSetting" or "scenarioZoneSetting"]
			end,
			set = function(info, value)
				E.profile.Party[info[2] == "none" and "noneZoneSetting" or "scenarioZoneSetting"] = value
				P:Refresh(true)
			end,
		},
	}
}

for key, name in pairs(E.L_CFG_ZONE) do
	P.options.args[key] = cfgZone
end
P.options.args.none = noCfgZone
P.options.args.scenario = noCfgZone

function P:IsCurrentZone(key)
	return E.db == E.profile.Party[key]
end

local sliderTimer

local function UpdatePixelObjects(noDelay)
	P:UpdatePositionValues()
	for _, info in pairs(P.groupInfo) do
		local frame = info.bar
		P:SetBarBackdrop(frame)
		P:SetIconLayout(frame)
	end
	if not noDelay then
		sliderTimer = nil
	end
end

function P:ConfigSize(key, slider, force)
	if key and not self:IsCurrentZone(key) then return end
	for _, info in pairs(self.groupInfo) do
		local frame = info.bar
		self:SetIconScale(frame)
	end
	if E.db.icons.displayBorder or force then
		if not slider then
			UpdatePixelObjects(true)
		elseif not sliderTimer then
			sliderTimer = E.TimerAfter(0.5, UpdatePixelObjects)
		end
	end
end

function P:ConfigBars(key, arg)
	if not self:IsCurrentZone(key) then return end

	if arg == "priority" then
		for barKey, frame in pairs(self.extraBars) do
			if frame.db.enabled then
				self:SetExIconLayout(barKey, true, true)
			end
		end
	elseif arg ~= "showAnchor" and arg ~= "locked" then
		self:UpdatePositionValues()
	end

	for _, info in pairs(self.groupInfo) do
		local frame = info.bar
		if arg == "preset" or arg == "anchor" or arg == "attach" then
			if not E.db.position.detached then
				local _, relativeTo = frame:GetPoint()
				if relativeTo ~= UIParent then
					frame:ClearAllPoints()
					frame:SetPoint(self.point, relativeTo, self.relativePoint)
				end
			end
			self:SetAnchorPosition(frame)
			self:SetOffset(frame)
			self:SetIconLayout(frame)
		elseif arg == "offsetX" or arg == "offsetY" then
			self:SetOffset(frame)
		elseif arg == "showAnchor" or arg == "locked" or arg == "detached" then
			if arg == "detached" then
				self:SetIconLayout(frame)
				self:ConfigIconSettings(frame, "borderPixels")
			end
			self:SetAnchor(frame)
		elseif arg == "reset" then
			E.LoadPosition(frame)
		else
			self:SetIconLayout(frame, arg == "priority")
		end
	end
end

function P:ConfigIconSettings(frame, arg, key)
	local db = E.db.icons[arg]

	for j = 1, frame.numIcons do
		local icon = frame.icons[j]
		if arg == "showTooltip" then
			self:SetTooltip(icon, db)
		elseif arg == "chargeScale" then
			self:SetChargeScale(icon, db)
		elseif arg == "showCounter" or arg == "counterScale" then
			self:SetSwipeCounter(icon)
		elseif arg == "reverse" or arg == "swipeAlpha" then
			self:SetSwipeCounter(icon)
		elseif arg == "activeAlpha" or arg == "inactiveAlpha" or arg == "desaturateActive" then
			self:SetOpacity(icon)
		elseif arg == "displayBorder" or arg == "borderPixels" then
			if key then
				self:SetExBorder(icon, key)
			else
				self:SetBorder(icon)
			end
		elseif arg == "borderColor" then
			local r, g, b = E.db.icons.borderColor.r, E.db.icons.borderColor.g, E.db.icons.borderColor.b
			if key then
				local statusBar = icon.statusBar
				if statusBar then
					statusBar.borderTop:SetColorTexture(r, g, b)
					statusBar.borderBottom:SetColorTexture(r, g, b)
					statusBar.borderRight:SetColorTexture(r, g, b)
				end
			end
			icon.borderTop:SetColorTexture(r, g, b)
			icon.borderBottom:SetColorTexture(r, g, b)
			icon.borderRight:SetColorTexture(r, g, b)
			icon.borderLeft:SetColorTexture(r, g, b)
		elseif arg == "markEnhanced" then
			self:SetMarker(icon, db)
		end
	end
end

function P:ConfigIcons(key, arg)
	if self:IsCurrentZone(key) then
		for _, info in pairs(self.groupInfo) do
			local frame = info.bar
			self:ConfigIconSettings(frame, arg)
		end
		for barKey, frame in pairs(self.extraBars) do
			self:ConfigIconSettings(frame, arg, barKey)
		end
	end
end

function P.getIcons(info)
	return E.profile.Party[ info[2] ].icons[ info[#info] ]
end

function P.setIcons(info, value)
	local key, option = info[2], info[#info]
	E.profile.Party[key].icons[option] = value
	P:ConfigIcons(key, option)
end

function P:ConfigTextures()
	local texture = E.Libs.LSM:Fetch("statusbar", E.profile.General.textures.statusBar.bar)
	for _, frame in pairs(self.extraBars) do
		for i = 1, frame.numIcons do
			local icon = frame.icons[i]
			local statusBar = icon.statusBar
			if statusBar then
				statusBar.BG:SetTexture(texture)
				statusBar.CastingBar:SetStatusBarTexture(texture)
				statusBar.CastingBar.BG:SetTexture(E.Libs.LSM:Fetch("statusbar", E.profile.General.textures.statusBar.BG))
			end
		end
	end
end

function P:ResetOption(key, tab, subtab)
	if subtab then
		E.profile.Party[key][tab][subtab] = E:DeepCopy(C.Party[key][tab][subtab])
	elseif tab then
		E.profile.Party[key][tab] = E:DeepCopy(C.Party[key][tab])
	elseif key then
		E.profile.Party[key] = E:DeepCopy(C.Party[key])
	else
		E.profile.Party = E:DeepCopy(C.Party)
	end
end

function P:RegisterSubcategory(optionName, optionTable)
	cfgZone.args[optionName] = optionTable
	if optionName == "raidCDS" then
		cfgZone.args.raidCDS = optionTable
	end
	if optionName == "spells" then
		cfgZone.args.extraBars.args.raidCDS = optionTable
	end
end
