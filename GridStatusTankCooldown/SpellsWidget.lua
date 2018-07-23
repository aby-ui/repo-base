local AceGUI = LibStub("AceGUI-3.0")

do
	local widgetType = "GSTCD-SpellsConfig"
	local widgetVersion = 1
	local SPELL_HEIGHT = 24

	local function GetSpellPriority(self, spellid)
		for p, s in ipairs(self.active_spellids) do
			if s == spellid then
				return p
			end
		end

		return false
	end
	
	local function GetSpellClass(self, spellid)
		for class, buffs in pairs(self.spells) do
			for _, s in ipairs(buffs) do
				if s == spellid then
					return class
				end
			end
		end
		
		return nil
	end

	local function SetContainerSpell(self, i, spellid, class, active)
		local sname, _, sicon = GetSpellInfo(spellid)
		if sicon == nil then
			sname = "bad spellid"
			sicon = "bad spellid"
        end

        if class == nil then
            DEFAULT_CHAT_FRAME:AddMessage(format("GridStatusTankCooldown wrong default spell: %s %s", spellid, sname), 1, 0, 0)
            return
        end

		self.spell_containers[i].spellid = spellid
		self.spell_containers[i].label:SetText(string.format(" |T%s:20|t |cFF%02x%02x%02x%s|r", sicon, RAID_CLASS_COLORS[class].r * 0xff, RAID_CLASS_COLORS[class].g * 0xff, RAID_CLASS_COLORS[class].b * 0xff, sname))
		
		if active then
			self.spell_containers[i].check.checktex:Show()
			self.spell_containers[i].upbtn:Enable()			
			self.spell_containers[i].downbtn:Enable()
		else
			self.spell_containers[i].check.checktex:Hide()
			self.spell_containers[i].upbtn:Disable()			
			self.spell_containers[i].downbtn:Disable()
		end
	end
	
	local function UpdateSpells(self)
		local i = 1
		
		for _, spellid in ipairs(self.active_spellids) do
			SetContainerSpell(self, i, spellid, GetSpellClass(self, spellid), true)
			i = i + 1
		end
		
		for class, buffs in pairs(self.spells) do
			for _, spellid in pairs(buffs) do
				if not GetSpellPriority(self, spellid) then
					SetContainerSpell(self, i, spellid, class, false)
					i = i + 1
				end
			end
		end
	end
	
	local function CheckBox_OnClick(frame)
		local self = frame.obj.obj
		local spellid = frame.obj.spellid
		local i = GetSpellPriority(self, spellid)

		if i then
			table.remove(self.active_spellids, i)
			self.inactive_spellids[spellid] = i
		else
			local pos
			if self.inactive_spellids[spellid] and self.inactive_spellids[spellid] <= (#self.active_spellids + 1) then
				pos = self.inactive_spellids[spellid]
			else
				pos = #self.active_spellids+1
			end

			table.insert(self.active_spellids, pos, spellid)
		end
		
		UpdateSpells(self)
        GridStatusTankCooldown:OnSpellListChanged()  --163ui
		GridStatusTankCooldown:UpdateAllUnits()
	end
	
	local function UpButton_Click(frame)
		local self = frame.obj.obj
		local i = GetSpellPriority(self, frame.obj.spellid)
		
		if i and i > 1 then
			if IsLeftShiftKeyDown() then
				local tmp = self.active_spellids[i]
				table.remove(self.active_spellids, i)
				table.insert(self.active_spellids, 1, tmp)
			else
				local tmp = self.active_spellids[i-1]
				self.active_spellids[i-1] = self.active_spellids[i]
				self.active_spellids[i] = tmp
			end

			UpdateSpells(self)
			GridStatusTankCooldown:UpdateAllUnits()
		end
	end

	local function DownButton_Click(frame)
		local self = frame.obj.obj
		local i = GetSpellPriority(self, frame.obj.spellid)
		
		if i and i < #self.active_spellids then
			if IsLeftShiftKeyDown() then
				local tmp = self.active_spellids[i]
				table.remove(self.active_spellids, i)
				table.insert(self.active_spellids, #self.active_spellids+1, tmp)
			else
				local tmp = self.active_spellids[i+1]
				self.active_spellids[i+1] = self.active_spellids[i]
				self.active_spellids[i] = tmp
			end

			UpdateSpells(self)
			GridStatusTankCooldown:UpdateAllUnits()
		end
	end

	local function LabelFrame_OnEnter(frame)
		-- HACK: replaces tooltips of some spells for other more descriptive spellids..
		local spellfilters = {
			-- [63087] = 63086 -- Raptor Strike => Glyph of Raptor Strike
		}
		GameTooltip:SetOwner(frame, "ANCHOR_NONE")
		GameTooltip:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT")
		GameTooltip:SetSpellByID(spellfilters[frame.spellid] or frame.spellid, true, true)
		GameTooltip:Show()
	end
				
	local function LabelFrame_OnLeave(frame)
		GameTooltip:Hide()
	end
	
	local function LabelFrame_OnMouseUp(frame)
		if IsModifiedClick("CHATLINK") then
			ChatEdit_InsertLink(GetSpellLink(frame.spellid))
		end
	end
		
	local function OnAcquire(self)
		UpdateSpells(self)
	end
	
	-- These are required by AceConfigDialog
	local function SetLabel(self, label)
	end	
	
	local function SetText(self, text)
	end
	
	local function SetDisabled(self, disabled)
	end
	
	local function Constructor()
		local widget = {
			type = widgetType,
			
			OnAcquire = OnAcquire,
			SetLabel = SetLabel,
			SetText = SetText,
			SetDisabled = SetDisabled,
		}
	
		-- Create spell containers
		local spells = GridStatusTankCooldown.tankingbuffs
		
		local spell_count = 0
		for _, cspells in pairs(spells) do
			spell_count = spell_count + #cspells
		end

		local frame = CreateFrame("Frame")
		frame:SetWidth(200)
		frame:SetHeight(spell_count * SPELL_HEIGHT)

		local spell_containers = { }
		
		for i = 1, spell_count do
			-- checkbox
			local check = CreateFrame("Button", nil, frame)
			check:SetPoint("TOPLEFT", 0, (i - 1) * -SPELL_HEIGHT)
			check:SetWidth(24)
			check:SetHeight(SPELL_HEIGHT)
			check:Show()			
			check:SetScript("OnClick", CheckBox_OnClick)

			local checkbg = check:CreateTexture(nil, "ARTWORK")
			checkbg:SetAllPoints()
			checkbg:SetTexture("Interface\\Buttons\\UI-CheckBox-Up")

			local checktex = check:CreateTexture(nil, "OVERLAY")
			checktex:SetAllPoints(checkbg)
			checktex:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
			check.checktex = checktex

			local highlight = check:CreateTexture(nil, "HIGHLIGHT")
			highlight:SetTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
			highlight:SetBlendMode("ADD")
			highlight:SetAllPoints(checkbg)

			-- up button
			local upbtn = CreateFrame("Button", nil, frame)
			upbtn:SetPoint("TOPLEFT", check, "TOPRIGHT")
			upbtn:SetWidth(24)
			upbtn:SetHeight(24)
			upbtn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Up")
			upbtn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Down")
			upbtn:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Disabled")
			upbtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
			upbtn:SetScript("OnClick", UpButton_Click)
			
			-- down button
			local downbtn = CreateFrame("Button", nil, frame)
			downbtn:SetPoint("TOPLEFT", upbtn, "TOPRIGHT")
			downbtn:SetWidth(24)
			downbtn:SetHeight(24)
			downbtn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
			downbtn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
			downbtn:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")
			downbtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
			downbtn:SetScript("OnClick", DownButton_Click)

			-- label
			local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			label:SetPoint("TOPLEFT", downbtn, "TOPRIGHT")
			label:SetWidth(200)
			label:SetHeight(SPELL_HEIGHT)
			label:SetJustifyH("LEFT")
			label:SetJustifyV("MIDDLE")
			
			-- label frame
			local label_frame = CreateFrame("Frame", nil, frame)
			label_frame:SetAllPoints(label)
			label_frame:EnableMouse()
			label_frame:SetScript("OnEnter", LabelFrame_OnEnter)				
			label_frame:SetScript("OnLeave", LabelFrame_OnLeave)
			label_frame:SetScript("OnMouseUp", LabelFrame_OnMouseUp)

			check.obj = label_frame
			upbtn.obj = label_frame
			downbtn.obj = label_frame
			
			label_frame.obj = widget
			label_frame.check = check
			label_frame.label = label
			label_frame.upbtn = upbtn
			label_frame.downbtn = downbtn

			spell_containers[i] = label_frame
		end

		widget.frame = frame
		widget.spell_containers = spell_containers
		widget.spells = spells
		widget.active_spellids = GridStatusTankCooldown.db.profile.alert_tankcd.active_spellids
		widget.inactive_spellids = GridStatusTankCooldown.db.profile.alert_tankcd.inactive_spellids
		
		AceGUI:RegisterAsWidget(widget)
		
		return widget
	end

	AceGUI:RegisterWidgetType(widgetType, Constructor, widgetVersion)
end