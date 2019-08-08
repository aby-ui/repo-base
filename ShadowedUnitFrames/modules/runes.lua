local Runes = {}
ShadowUF:RegisterModule(Runes, "runeBar", ShadowUF.L["Rune bar"], true, "DEATHKNIGHT")
ShadowUF.BlockTimers:Inject(Runes, "RUNE_TIMER")
ShadowUF.DynamicBlocks:Inject(Runes)

function Runes:OnEnable(frame)
	if( not frame.runeBar ) then
		frame.runeBar = CreateFrame("StatusBar", nil, frame)
		frame.runeBar:SetMinMaxValues(0, 1)
		frame.runeBar:SetValue(0)
		frame.runeBar.runes = {}
		frame.runeBar.blocks = frame.runeBar.runes

		for id=1, 6 do
			local rune = ShadowUF.Units:CreateBar(frame.runeBar)
			rune.id = id

			if( id > 1 ) then
				rune:SetPoint("TOPLEFT", frame.runeBar.runes[id-1], "TOPRIGHT", 1, 0)
			else
				rune:SetPoint("TOPLEFT", frame.runeBar, "TOPLEFT", 0, 0)
			end

			frame.runeBar.runes[id] = rune
		end
	end

	frame:RegisterNormalEvent("RUNE_POWER_UPDATE", self, "UpdateUsable")
	frame:RegisterUpdateFunc(self, "UpdateUsable")
end

function Runes:OnDisable(frame)
	frame:UnregisterAll(self)
end

function Runes:OnLayoutApplied(frame)
	if( not frame.visibility.runeBar ) then return end

	local barWidth = (frame.runeBar:GetWidth() - 5) / 6
	for id, rune in pairs(frame.runeBar.runes) do
		if( ShadowUF.db.profile.units[frame.unitType].runeBar.background ) then
			rune.background:Show()
		else
			rune.background:Hide()
		end

		rune.background:SetTexture(ShadowUF.Layout.mediaPath.statusbar)
		rune.background:SetHorizTile(false)
		rune:SetStatusBarTexture(ShadowUF.Layout.mediaPath.statusbar)
		rune:GetStatusBarTexture():SetHorizTile(false)
		rune:SetWidth(barWidth)

		local color = ShadowUF.db.profile.powerColors.RUNES
		frame:SetBlockColor(rune, "runeBar", color.r, color.g, color.b)
	end
end

local function runeMonitor(self, elapsed)
	local time = GetTime()
	self:SetValue(time)

	if( time >= self.endTime ) then
		self:SetValue(self.endTime)
		self:SetAlpha(1.0)
		self:SetScript("OnUpdate", nil)
		self.endTime = nil
	end

	if( self.fontString ) then
		self.fontString:UpdateTags()
	end
end

-- Updates the timers on runes
function Runes:UpdateUsable(frame, event, id, usable)
	if( not id or not frame.runeBar.runes[id] ) then
		return
	end

	local rune = frame.runeBar.runes[id]
	local startTime, cooldown, cooled = GetRuneCooldown(id)
	-- Blizzard changed something with this API apparently and now it can be true/false/nil
	if( cooled == nil ) then return end

	if( not cooled ) then
		rune.endTime = startTime + cooldown
		rune:SetMinMaxValues(startTime, rune.endTime)
		rune:SetValue(GetTime())
		rune:SetAlpha(0.40)
		rune:SetScript("OnUpdate", runeMonitor)
	else
		rune:SetMinMaxValues(0, 1)
		rune:SetValue(1)
		rune:SetAlpha(1.0)
		rune:SetScript("OnUpdate", nil)
		rune.endTime = nil
	end

	if( rune.fontString ) then
		rune.fontString:UpdateTags()
	end
end
