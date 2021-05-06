local E, L, C = select(2, ...):unpack()

local modname = "Party"
local P = E[modname]

P.options = {
	disabled = function(info) return info[2] and not E.GetModuleEnabled(modname) end,
	name = FRIENDLY,
	order = 200,
	type = "group",
	get = function(info) return E.DB.profile.Party[info[#info]] end,
	set = function(info, value) E.DB.profile.Party[info[#info]] = value end,
	args = {},
}

for key, name in pairs(E.L_ZONE) do
	P.options.args[key] = {
		disabled = function(info) return info[3] and not E.DB.profile.Party.visibility[info[2]] or not E.GetModuleEnabled(modname) end,
		name = name,
		type = "group",
		childGroups = "tab",
		args = {
			title = {
				name = name,
				order = 0,
				type = "description",
				fontSize = "large",
			},
			enabled = {
				disabled = false,
				name = ENABLE,
				desc = L["Enable CD tracking in the current zone"],
				order = 1,
				type = "toggle",
				get = function(info) return E.DB.profile.Party.visibility[info[2]] end,
				set = function(info, value)
					local key = info[2]
					E.DB.profile.Party.visibility[key] = value
					if P.test and P.testZone == key then
						P:Test()
					end
					P:Refresh(true)
				end,
			},
			test = {
				name = L["Test"],
				desc = L["Toggle raid-style party frame and player spell bar for testing"],
				order = 2,
				type = "toggle",
				get = function(info) return P.testZone == info[2] and P.test end,
				set = function(info, state) P:Test(state and info[2]) end,
			},
		}
	}

	if key == "none" or key == "scenario" then
		P.options.args[key].args.lb1 = {
			name = "\n", order = 10, type = "description",
		}
		P.options.args[key].args.zoneSetting = {
			name = L["Use Zone Settings From:"],
			desc = L["Select the zone setting to use for this zone."],
			order = 20,
			type = "select",
			values = E.CFG_ZONE,
			get = function(info) return E.DB.profile.Party[info[2] == "none" and "noneZoneSetting" or "scenarioZoneSetting"] end, -- [83]
			set = function(info, value)
				E.DB.profile.Party[info[2] == "none" and "noneZoneSetting" or "scenarioZoneSetting"] = value

				P:Refresh(true) -- [76]
			end,
		}
	end
end

do
	local timer

	local updatePixelObj = function(noDelay)
		P:UpdatePositionValues()
		for _, info in pairs(P.groupInfo) do
			local f = info.bar
			P:SetBarBackdrop(f)
			P:SetIconLayout(f)
		end

		if not noDelay then
			timer = nil
		end
	end

	function P:ConfigSize(key, slider, force)
		if key and E.db ~= E.DB.profile.Party[key] then
			return
		end

		for _, info in pairs(self.groupInfo) do
			local f = info.bar
			self:SetIconScale(f)
		end

		if E.db.icons.displayBorder or force then
			if slider then
				if not timer then
					timer = E.TimerAfter(0.5, updatePixelObj)
				end
			else
				updatePixelObj(true)
			end
		end
	end
end

function P:ConfigBars(key, arg)
	if E.db ~= E.DB.profile.Party[key] then
		return
	end

	if arg == "priority" then
		self:UpdateRaidPriority()
		self:SetExIconLayout("raidCDBar", true, true) -- changed to nodelay
	elseif arg ~= "showAnchor" and arg ~= "locked" then
		self:UpdatePositionValues()
	end

	for _, info in pairs(self.groupInfo) do
		local f = info.bar
		if arg == "preset" or arg == "anchor" or arg == "attach" then
			if not E.db.position.detached then
				local _, relativeTo = f:GetPoint()
				if relativeTo ~= UIParent then
					f:ClearAllPoints()
					f:SetPoint(self.point, relativeTo, self.relativePoint)
				end
			end

			self:SetAnchorPosition(f)
			self:SetOffset(f)
			self:SetIconLayout(f)
		elseif arg == "offsetX" or arg == "offsetY" then
			self:SetOffset(f)
		elseif arg == "showAnchor" or arg == "locked" or arg == "detached" then
			self:SetAnchor(f)
		elseif arg == "reset" then
			E.LoadPosition(f)
		else -- [20]
			self:SetIconLayout(f, arg == "priority")
		end
	end
end

function P:ConfigIconSettings(f, arg, key)
	for j = 1, f.numIcons do
		local icon = f.icons[j]
		if arg == "showTooltip" then
			self:SetTooltip(icon)
		elseif arg == "chargeScale" then
			self:SetChargeScale(icon)
		elseif arg == "showCounter" or arg == "counterScale" then
			self:SetCounter(icon)
		elseif arg == "reverse" or arg == "swipeAlpha" then
			self:SetSwipe(icon)
		elseif arg == "activeAlpha" or arg == "inactiveAlpha" or arg == "desaturateActive" then
			self:SetAlpha(icon)
		elseif arg == "displayBorder" or arg == "borderPixels" then
			if key then
				self:SetExBorder(icon, key)
			else
				self:SetBorder(icon)
			end
		elseif arg == "borderColor" then
			local r, g, b = E.db.icons.borderColor.r, E.db.icons.borderColor.g, E.db.icons.borderColor.b
			if key then
				icon.borderTop:SetColorTexture(r, g, b)
				icon.borderBottom:SetColorTexture(r, g, b)
				icon.borderRight:SetColorTexture(r, g, b)
				icon.borderLeft:SetColorTexture(r, g, b)

				local statusBar = icon.statusBar
				statusBar.borderTop:SetColorTexture(r, g, b)
				statusBar.borderBottom:SetColorTexture(r, g, b)
				statusBar.borderRight:SetColorTexture(r, g, b)
			elseif E.db.icons.displayBorder then
				icon.borderTop:SetColorTexture(r, g, b)
				icon.borderBottom:SetColorTexture(r, g, b)
				icon.borderRight:SetColorTexture(r, g, b)
				icon.borderLeft:SetColorTexture(r, g, b)
			end
		elseif arg == "markEnhanced" then
			self:SetMarker(icon)
		end
	end
end

function P:ConfigIcons(key, arg)
	if E.db == E.DB.profile.Party[key] then
		for _, info in pairs(self.groupInfo) do
			local f = info.bar
			self:ConfigIconSettings(f, arg)
		end
		for _, f in pairs(self.extraBars) do
			self:ConfigIconSettings(f, arg, f.key)
		end
	end
end

P.getIcons = function(info) return E.DB.profile.Party[info[2]].icons[info[#info]] end
P.setIcons = function(info, value)
	local key, option = info[2], info[#info]
	E.DB.profile.Party[key].icons[option] = value
	P:ConfigIcons(key, option)
end

function P:ConfigTextures()
	local texture = E.Libs.LSM:Fetch("statusbar", E.DB.profile.General.textures.statusBar.bar)
	for _, f in pairs(self.extraBars) do
		for i = 1, f.numIcons do
			local icon = f.icons[i]
			local statusBar = icon.statusBar
			if statusBar then
				statusBar.BG:SetTexture(texture)
				statusBar.CastingBar:SetStatusBarTexture(texture)
				statusBar.CastingBar.BG:SetTexture(E.Libs.LSM:Fetch("statusbar", E.DB.profile.General.textures.statusBar.BG))
			end
		end
	end
end

function P:ResetOptions(key, tab, subtab)
	if subtab then
		E.DB.profile.Party[key][tab][subtab] = E.DeepCopy(C.Party[key][tab][subtab])
	elseif tab then
		E.DB.profile.Party[key][tab] = E.DeepCopy(C.Party[key][tab])
	elseif key then
		E.DB.profile.Party[key] = E.DeepCopy(C.Party[key])
	else
		E.DB.profile.Party = E.DeepCopy(C.Party)
	end
end
