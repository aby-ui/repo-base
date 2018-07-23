local PartyTarget_Enable = true;
local frame
for i = 1, MAX_PARTY_MEMBERS do
	frame = CreateFrame("Button", "PartyTarget"..i, getglobal("PartyMemberFrame"..i), "PartyTargetFrameTemplate")
	frame:SetPoint("TOPLEFT", getglobal("PartyMemberFrame"..i), "TOPLEFT", 200, -6)
	frame:SetAttribute("unit", "party"..i.."target")
	frame:SetAttribute("*type1", "target")
end

function PartyTarget_OnUpdate(self, elapsed)
	if (not PartyTarget_Enable) then
		return;
	end
    local _

	self.timer = (self.timer or 0) + elapsed
	if self.timer >= 0.2 then
		local i = n2s(self:GetID())
		local unit = "party" .. i .."target"
		if UnitExists(unit) then
			local _, en = UnitClass(unit)
			local color = RAID_CLASS_COLORS[en] or NORMAL_FONT_COLOR
			local perc = floor( (UnitHealth(unit) or 0) / max((UnitHealthMax(unit) or 1),1) * 100 )
			--getglobal("PartyTarget"..i):Show()
			getglobal("PartyTarget"..i.."Name"):SetText(UnitName(unit))
			getglobal("PartyTarget"..i.."Name"):SetTextColor(color.r, color.g, color.b)
			getglobal("PartyTarget"..i.."HealthBar"):SetValue(perc)
			getglobal("PartyTarget"..i.."HealthBarText"):SetText(perc .. "%")
			if perc == 0 then
				getglobal("PartyTarget"..i.."HealthBarText"):SetText("|cffeed200DEAD|r")
			end
			if UnitIsEnemy("player", unit) then
				getglobal("PartyTarget"..i.."Border"):SetVertexColor(1, 0.2, 0.2)
				getglobal("PartyTarget"..i.."HealthBar"):SetStatusBarColor(1, 0.55, 0.72)
			elseif UnitIsFriend("player", unit) then
				getglobal("PartyTarget"..i.."Border"):SetVertexColor(0, 1, 0)
				getglobal("PartyTarget"..i.."HealthBar"):SetStatusBarColor(0, 1, 0)
			else
				getglobal("PartyTarget"..i.."Border"):SetVertexColor(0.9, 0.82, 0)
				getglobal("PartyTarget"..i.."HealthBar"):SetStatusBarColor(0.65, 0.9, 0.85)
			end
		else
			--getglobal("PartyTarget"..i):Hide()
		end
		self.timer = 0
	end
end

hooksecurefunc("PartyMemberFrame_OnUpdate", function(self, elapsed)
	PartyTarget_OnUpdate(self, elapsed)
end )

function PartyTarget_Toggle(switch)
    local frame;
	if (switch) then
		PartyTarget_Enable = true;
		for i=1, MAX_PARTY_MEMBERS do
			frame = getglobal("PartyTarget" .. i);
			dwSecureCall(RegisterUnitWatch, frame);
		end		
	else
		PartyTarget_Enable = false;
		for i=1, MAX_PARTY_MEMBERS do
			frame = getglobal("PartyTarget" .. i);
			dwSecureCall(UnregisterUnitWatch, frame);
			dwSecureCall(frame.Hide, frame);			
		end
	end
end
