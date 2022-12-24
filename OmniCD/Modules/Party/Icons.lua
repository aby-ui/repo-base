local E = select(2, ...):unpack()
local P = E.Party

local tonumber, sort, min, max = tonumber, table.sort, math.min, math.max

local sortPriority = function(a, b)
	local aprio, bprio = E.db.priority[a.type], E.db.priority[b.type]
	if aprio == bprio then
		return a.spellID < b.spellID
	end
	return aprio > bprio
end

function P:SetIconLayout(frame, sortOrder)
	local icons = frame.icons
	local displayInactive = self.displayInactive

	if sortOrder then
		sort(icons, sortPriority)
	end

	local db_prio = E.db.priority;
	local count, rows, numActive, lastActiveIndex = 0, 1, 1
	for i = 1, frame.numIcons do
		local icon = icons[i]
		icon:Hide()

		if displayInactive or icon.active then
			icon:ClearAllPoints()
			if numActive > 1 then
				count = count + 1
				if not self.multiline and count == self.columns or
					(self.multiline and (rows == 1 and db_prio[icon.type] <= self.breakPoint or (self.tripleline and rows == 2 and db_prio[icon.type] <= self.breakPoint2))) then
					if self.tripleline and rows == 1 and db_prio[icon.type] <= self.breakPoint2 then
						rows = rows + 1
					end
					icon:SetPoint(self.point, frame.container, self.ofsX * rows, self.ofsY * rows)
					count = 0
					rows = rows + 1
				else
					icon:SetPoint(self.point2, icons[lastActiveIndex], self.relativePoint2, self.ofsX2, self.ofsY2)
				end
			else
				if self.multiline and db_prio[icon.type] <= self.breakPoint then
					if self.tripleline and rows == 1 and db_prio[icon.type] <= self.breakPoint2 then
						rows = rows + 1
					end
					icon:SetPoint(self.point, frame.container, self.ofsX * rows, self.ofsY * rows)
					rows = rows + 1
				else
					icon:SetPoint(self.point, frame.container)
				end
			end

			numActive = numActive + 1
			lastActiveIndex = i

			icon:Show()
		end
	end
end

function P:SetAnchor(frame)
	if E.db.general.showAnchor or (E.db.position.detached and not E.db.position.locked) then
		frame.anchor:Show()
	else
		frame.anchor:Hide()
	end

	if not E.db.position.detached or E.db.position.locked then
		frame.anchor:EnableMouse(false)
		frame.anchor.background:SetColorTexture(0.756, 0, 0.012, 0.7)
	else
		frame.anchor:EnableMouse(true)
		frame.anchor.background:SetColorTexture(0, 0.8, 0, 1)
	end
end

function P:SetIconScale(frame)
	local scale = E.db.icons.scale
	frame.anchor:SetScale(min(max(0.7, scale), 1))
	frame.container:SetScale(scale)
end

function P:SetBorder(icon)
	local db = E.db.icons
	if db.displayBorder then
		icon.borderTop:ClearAllPoints()
		icon.borderBottom:ClearAllPoints()
		icon.borderRight:ClearAllPoints()
		icon.borderLeft:ClearAllPoints()

		local edgeSize = ( E.db.general.showRange and not E.db.position.detached and self.effectivePixelMult or E.PixelMult) / db.scale
		icon.borderTop:SetPoint("TOPLEFT", icon, "TOPLEFT")
		icon.borderTop:SetPoint("BOTTOMRIGHT", icon, "TOPRIGHT", 0, -edgeSize)
		icon.borderBottom:SetPoint("BOTTOMLEFT", icon, "BOTTOMLEFT")
		icon.borderBottom:SetPoint("TOPRIGHT", icon, "BOTTOMRIGHT", 0, edgeSize)
		icon.borderLeft:SetPoint("TOPLEFT", icon, "TOPLEFT", 0, -edgeSize)
		icon.borderLeft:SetPoint("BOTTOMRIGHT", icon, "BOTTOMLEFT", edgeSize, edgeSize)
		icon.borderRight:SetPoint("TOPRIGHT", icon, "TOPRIGHT", 0, -edgeSize)
		icon.borderRight:SetPoint("BOTTOMLEFT", icon, "BOTTOMRIGHT", -edgeSize, edgeSize)

		local r, g, b = db.borderColor.r, db.borderColor.g, db.borderColor.b
		icon.borderTop:SetColorTexture(r, g, b)
		icon.borderBottom:SetColorTexture(r, g, b)
		icon.borderRight:SetColorTexture(r, g, b)
		icon.borderLeft:SetColorTexture(r, g, b)

		icon.borderTop:Show()
		icon.borderBottom:Show()
		icon.borderRight:Show()
		icon.borderLeft:Show()

		icon.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	else
		icon.borderTop:Hide()
		icon.borderBottom:Hide()
		icon.borderRight:Hide()
		icon.borderLeft:Hide()

		icon.icon:SetTexCoord(0, 1, 0, 1)
	end
end

function P:SetMarker(icon, markEnhanced)
	local hotkey = icon.hotKey
	if markEnhanced then
		local spellID = icon.spellID
		local mark = E.spell_marked[spellID]
		if mark and (mark == true or self:IsTalentForPvpStatus(mark, self.groupInfo[icon.guid])) then
			hotkey:Show()
		else
			hotkey:Hide()
		end
	else
		hotkey:Hide()
	end
end

function P:SetOpacity(icon)

	if icon.statusBar then
		icon:SetAlpha(1.0)
	else
		icon:SetAlpha(icon.active and E.db.icons.activeAlpha or E.db.icons.inactiveAlpha)
	end


	local info = self.groupInfo[icon.guid]
	if not info then return end
	if info.isDeadOrOffline then
		icon.icon:SetDesaturated(true)
		icon.icon:SetVertexColor(0.3, 0.3, 0.3)
	else
		if info.preactiveIcons[icon.spellID] and not icon.isHighlighted then
			icon.icon:SetVertexColor(0.4, 0.4, 0.4)
		else
			icon.icon:SetVertexColor(1, 1, 1)
		end
		local charges = icon.maxcharges and tonumber(icon.count:GetText())
		icon.icon:SetDesaturated(E.db.icons.desaturateActive and icon.active and not icon.isHighlighted and (not charges or charges == 0));
	end
end

function P:SetSwipeCounter(icon)
	self:SetCooldownElements(icon, icon.maxcharges and tonumber(icon.count:GetText()))
	icon.cooldown:SetReverse(E.db.icons.reverse)
	icon.cooldown:SetSwipeColor(0, 0, 0, E.db.icons.swipeAlpha)
	icon.counter:SetScale(E.db.icons.counterScale)
end

function P:SetChargeScale(icon, chargeScale)
	icon.count:SetScale(chargeScale)
end

function P:SetTooltip(icon, showTooltip)
	icon:EnableMouse(showTooltip)
end

function P:ApplySettings(frame)
	self:SetAnchor(frame)
	self:SetIconScale(frame)

	local markEnhanced = E.db.icons.markEnhanced
	local chargeScale = E.db.icons.chargeScale
	local showTooltip = E.db.icons.showTooltip

	for i = 1, frame.numIcons do
		local icon = frame.icons[i]
		self:SetBorder(icon)
		self:SetMarker(icon, markEnhanced)
		self:SetOpacity(icon)
		self:SetSwipeCounter(icon)
		self:SetChargeScale(icon, chargeScale)
		self:SetTooltip(icon, showTooltip)
	end
end
