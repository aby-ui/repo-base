local enable = false;

function EN_ToToT_Toggle(switch)
	local self = EN_TargetTargetTarget;
	if (switch) then
		enable = true;
		self:RegisterEvent("UNIT_AURA");
		RegisterUnitWatch(self);
	else
		enable = false;
		self:UnregisterEvent("UNIT_AURA");
		UnregisterUnitWatch(self);
		if (InCombatLockdown()) then
			dwPush(self.Hide, self);
		else
			self:Hide();
		end
	end
end

function EN_TargetTargetTarget_OnLoad(self)
    local pretot = "EN_TargetTargetTarget";
    UnitFrame_Initialize(self, "TargetTargetTarget", 
		getglobal(pretot.."Name"), getglobal(pretot.."Portrait"), 
		getglobal(pretot.."HealthBar"), getglobal(pretot.."HealthBarText"), 
		getglobal(pretot.."ManaBar"), getglobal(pretot.."ManaBarText")
	);
    SetTextStatusBarTextZeroText(getglobal(pretot.."HealthBar"), DEAD);    
    SecureUnitButton_OnLoad(self, "targettargettarget");	
	local text = TargetFrameToTTextureFrame:CreateFontString("TargetofTargetFrameHPText", "OVERLAY" , "GameFontNormalSmall")
	text:SetPoint("CENTER", TargetFrameToT, "CENTER", 20, 1);
	text:SetTextColor(1, 1, 1);
	text:SetAlpha(0.8);
end

function EN_TargetTargetTarget_Update(self, elapsed)
    if (not enable) then
    	return;
    end
	if ( not self ) then
        self = EN_TargetTargetTarget;
    end
	
	if UnitExists("target") and UnitExists("targettarget") and UnitIsPlayer("targettarget") then		
		local _,enClass = UnitClass("targettarget");
		local color = RAID_CLASS_COLORS[enClass];	
		
		TargetFrameToTTextureFrameName:SetTextColor(color.r or 1, color.g or 0.8, color.b or 0);		
	else
		TargetFrameToTTextureFrameName:SetTextColor(1, 0.8, 0);
	end


    if UnitExists("target") and UnitExists("targettarget") and UnitExists("targettargettarget") then         
        UnitFrame_Update(self);
        EN_TargetTargetTarget_CheckDead();
        EN_TargetTargetTargetHealthCheck();        
		RefreshDebuffs(self, "targettargettarget"); 
		if (UnitIsPlayer("targettargettarget")) then
			local _,enClass = UnitClass("targettargettarget");
			local color = RAID_CLASS_COLORS[enClass];			
			EN_TargetTargetTargetName:SetTextColor(color.r or 1, color.g or 0.8, color.b or 0);
		else
			EN_TargetTargetTargetName:SetTextColor(1, 0.8, 0);
		end
	else
		EN_TargetTargetTargetName:SetTextColor(1, 0.8, 0);
    end 
end

hooksecurefunc("TargetofTarget_Update", function(self, elapsed)
    EN_TargetTargetTarget_Update();
end )

function EN_TargetTargetTarget_CheckDead()
	if ( (UnitHealth("TargetTarget") <= 0) and UnitIsConnected("TargetTarget") ) then
		TargetofTargetFrameHPText:Hide();
	else
		TargetofTargetFrameHPText:Show();
	end

    if ( (UnitHealth("TargetTargetTarget") <= 0) and UnitIsConnected("TargetTargetTarget") ) then
        EN_TargetTargetTargetBackground:SetAlpha(0.9);
        EN_TargetTargetTargetDeadText:Show();
		EN_TargetTargetTargetHPText:Hide();
    else
        EN_TargetTargetTargetBackground:SetAlpha(1);
        EN_TargetTargetTargetDeadText:Hide();
		EN_TargetTargetTargetHPText:Show();
    end
end

function EN_TargetTargetTargetHealthCheck()
	-- check tot
	if (UnitExists("targettarget")) then
		if (UnitIsDead("targettarget") or UnitIsGhost("targettarget") ) then
			TargetofTargetFrameHPText:Hide();			
		else
			local unitCurrHP = UnitHealth("targettarget");
			local unitHPMax = UnitHealthMax("targettarget");
			TargetFrameToT.unitHPPercent = unitCurrHP / unitHPMax;
			TargetofTargetFrameHPText:SetText(string.format("%d%%", TargetFrameToT.unitHPPercent * 100));
			TargetofTargetFrameHPText:Show();			
		end
	end
	
	-- check totot
	if (UnitExists("TargetTargetTarget")) then
		if (UnitIsDead("TargetTargetTarget") or UnitIsGhost("TargetTargetTarget") ) then
			EN_TargetTargetTargetHPText:Hide();
			if (UnitIsPlayer("TargetTargetTarget")) then
				if (UnitIsDead("TargetTargetTarget")) then
					EN_TargetTargetTargetPortrait:SetVertexColor(0.35, 0.35, 0.35, 1.0);
				elseif ( UnitIsGhost("TargetTargetTarget")) then
					EN_TargetTargetTargetPortrait:SetVertexColor(0.2, 0.2, 0.75, 1.0);
				end
			end		
		else
			local unitCurrHP = UnitHealth("TargetTargetTarget");
			local unitHPMax = UnitHealthMax("TargetTargetTarget");
			EN_TargetTargetTargetHealthBar.unitHPPercent = unitCurrHP / unitHPMax;
			EN_TargetTargetTargetHPText:SetText(string.format("%d%%", EN_TargetTargetTargetHealthBar.unitHPPercent * 100));
			EN_TargetTargetTargetHPText:Show();

			if (UnitIsPlayer("TargetTargetTarget")) then
				if ((EN_TargetTargetTargetHealthBar.unitHPPercent > 0) and (EN_TargetTargetTargetHealthBar.unitHPPercent <= 0.2)) then
					 EN_TargetTargetTargetPortrait:SetVertexColor(1.0, 0.0, 0.0);
				else
					 EN_TargetTargetTargetPortrait:SetVertexColor(1.0, 1.0, 1.0, 1.0);
				end
			end
		end
	end
end