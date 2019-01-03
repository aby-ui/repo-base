local _
--血量阀值, 血量处于在两个值之间时显示对应材质,
--血量高于第一个值则不显示, 如果第一个值为100则一直显示,
--血量低于最后一个值也不显示, 如果希望死亡也有骷髅, 请设置为-1
GEAR_HUD_THRESH_HOLD = { 75, 40, 25, 10, 0 };

--距离屏幕中心的偏移位置
GEAR_HUD_OFFSET = {0, 130}

--挨打提示的停留时间
GEARHUD_INDICATOR_SHOWTIME = 0.3
--挨打提示的渐隐时间
GEARHUD_INDICATOR_FADETIME = 0.2

--四个材质根据血量比例的透明度范围, 该属性一般不用修改.
GEAR_HUD_ALPHA = { 
	{0.4, 0.8},
	{0.6, 0.8},
	{0.8, 1},
	{0.5, 0.75},
}
--[[
GEAR_HUD_ALPHA = { 
	{0.1, 0.9},
	{0.5, 0.7},
	{0.6, 0.75},
	{0.5, 0.75},
}
]]
--[[
GEAR_HUD_ALPHA = { 
	{0.5, 0.8},
	{0.7, 0.8},
	{0.8, 1.0},
	{0.4, 0.65},
}
]]

------------------------------- 以下为常量, 请勿修改 -----------------------
GEAR_HUD_CENTER_SIZE=148;
--{ 齿轮左上角X坐标, Y坐标, 增加的宽度, 增加的高度 }
GEAR_HUD_TEX_POS = {
	{ 12, 5, 5, 5 },
	{ 215, 6, 30, 10},
	{ 254, 164, 100, 10},
	{ 174, 341, 170, 25},
}

GearHudSettings = {
	scale = 1,
}

function GearHud_OnLoad(self)
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("UNIT_HEALTH");
    --self:RegisterEvent("UNIT_HEALTH_FREQUENT");
    self:RegisterEvent("PLAYER_UNGHOST");
	self:RegisterEvent("UNIT_MAXHEALTH");
	self:RegisterEvent("UNIT_COMBAT");
	self:RegisterEvent("VARIABLES_LOADED");

	GearHud_Reset();

	--texture2是重复显示1
	GearHudTexture2:SetWidth(GEAR_HUD_CENTER_SIZE + GEAR_HUD_TEX_POS[2][3] * 2);
	GearHudTexture2:SetHeight(GEAR_HUD_CENTER_SIZE + GEAR_HUD_TEX_POS[2][4] * 2);
	GearHudTexture2:SetTexCoord(
		(GEAR_HUD_TEX_POS[1][1] - GEAR_HUD_TEX_POS[2][3])/512,
		(GEAR_HUD_TEX_POS[1][1] + GEAR_HUD_TEX_POS[2][3] + GEAR_HUD_CENTER_SIZE)/512,
		(GEAR_HUD_TEX_POS[1][2] - GEAR_HUD_TEX_POS[2][4])/512, 
		(GEAR_HUD_TEX_POS[1][2] + GEAR_HUD_TEX_POS[2][4] + GEAR_HUD_CENTER_SIZE)/512
	)
end

function GearHud_UpdateScale()
	GearHud:SetScale(GearHudSettings.scale);
	if(GearHudIndicator) then GearHudIndicator:SetScale(GearHudSettings.scale); end
	if(GearHudIndicator) then GearHudIndicator:Show(); end
	--GearHud_SavePos();
end

function GearHud_Reset()
	GearHudSettings.scale = 1;
	GearHud:ClearAllPoints();
	GearHud:SetPoint("CENTER", UIParent, "CENTER", GEAR_HUD_OFFSET[1], GEAR_HUD_OFFSET[2]);
    GearHud_SavePos();
	GearHud_UpdateScale();
end

function GearHud_SavePos()
    local s = GearHudSettings;
    s[1],_,s[2],s[3],s[4]= GearHud:GetPoint()
end

function GearHud_OnEvent(event, arg1, arg2)
	if(event=="VARIABLES_LOADED") then
		GearHud_BuildDrag();
		GearHud_UpdateScale();
        local s = GearHudSettings;
        if s and s[1] then
            GearHud:ClearAllPoints();
            GearHud:SetPoint(s[1],UIParent, s[2],s[3],s[4]);
        end

	elseif(event=="PLAYER_ENTERING_WORLD") then
		GearHud_Lock();

    elseif(event=="PLAYER_UNGHOST") then
        GearHud_Update(100)
        C_Timer.After(0.1, function() GearHud_Update() end)

	elseif((event=="UNIT_HEALTH" or event=="UNIT_MAXHEALTH") and arg1=="player") then
		GearHud_Update();
	elseif(event=="UNIT_COMBAT" and arg1=="player" and arg2=="WOUND") then
		GearHudIndicator:Show();
		GearHudIndicator.timer=GEARHUD_INDICATOR_SHOWTIME + GEARHUD_INDICATOR_FADETIME; 
		GearHudIndicator:SetAlpha(1.0);
	end
end

function GearHud_Update(hp)
	if(not hp) then 
		hp = UnitHealth("player")/UnitHealthMax("player")*100; 
		if(UnitIsDead("player") or UnitIsGhost("player")) then hp = 0; end
	end

	for i=1, table.getn(GEAR_HUD_THRESH_HOLD) do
		if(hp>GEAR_HUD_THRESH_HOLD[i]) then
			if(i==3) then
				GearHudTexture2:Show();
			else
				GearHudTexture2:Hide();
			end
			if(i==1) then
				GearHudTexture:Hide();
			else
				GearHudTexture:Show();
				GearHudTexture:SetWidth(GEAR_HUD_CENTER_SIZE + GEAR_HUD_TEX_POS[i-1][3] * 2);
				GearHudTexture:SetHeight(GEAR_HUD_CENTER_SIZE + GEAR_HUD_TEX_POS[i-1][4] * 2);
				GearHudTexture:SetTexCoord(
					(GEAR_HUD_TEX_POS[i-1][1] - GEAR_HUD_TEX_POS[i-1][3])/512,
					(GEAR_HUD_TEX_POS[i-1][1] + GEAR_HUD_TEX_POS[i-1][3] + GEAR_HUD_CENTER_SIZE)/512,
					(GEAR_HUD_TEX_POS[i-1][2] - GEAR_HUD_TEX_POS[i-1][4])/512, 
					(GEAR_HUD_TEX_POS[i-1][2] + GEAR_HUD_TEX_POS[i-1][4] + GEAR_HUD_CENTER_SIZE)/512
				)
				local factor = (GEAR_HUD_THRESH_HOLD[i-1]-hp)/(GEAR_HUD_THRESH_HOLD[i-1]-GEAR_HUD_THRESH_HOLD[i]);
				local alpha = GEAR_HUD_ALPHA[i-1][1] + (GEAR_HUD_ALPHA[i-1][2]-GEAR_HUD_ALPHA[i-1][1])*factor;
				GearHud:SetAlpha(alpha);
			end
			break;
		end
		if(i==5) then
			GearHudTexture:Hide();
		end
	end
end

function GearHudIndicator_OnUpdate(self, arg1)
	self.timer = self.timer - arg1;
	if(self.timer <= 0) then
		self:Hide();
	elseif (self.timer <= GEARHUD_INDICATOR_FADETIME) then
		self:SetAlpha( self.timer/GEARHUD_INDICATOR_FADETIME );
	end
end

function GearHud_BuildDrag()
	GearHud:EnableMouse(false);
	GearHud:SetScript("OnMouseDown", function() GearHud:StartMoving() end);
	GearHud:SetScript("OnMouseUp", function() GearHud:StopMovingOrSizing(); GearHud_SavePos(); end);
	
	GearHud.tex = GearHud.tex or GearHud:CreateTexture("$parent_T_Green", "BACKGROUND");
	GearHud.tex:SetTexture(0, 0.6, 0, 0.5);
	GearHud.tex:SetAllPoints(GearHud);
	GearHud.tex:Hide();
	
	GearHud.Background = GearHud.tex;
end

function GearHud_Lock()
	GearHud:EnableMouse(false);
	if GearHud.tex then
		GearHud.tex:Hide();
		GearHud.resizeButton:Hide();
	end
	GearHud_Update();
	GearHudIndicator:Show();
end

function GearHud_UnLock()
	GearHud:EnableMouse(true);
	GearHud:Show();
	GearHud.tex:Show();
	GearHud.resizeButton:Show();
	GearHud_Update();
end

SLASH_GEARHUD1 = "/gearhud";
SLASH_GEARHUD2 = "/gh";
SlashCmdList["GEARHUD"] = function(msg)
	if(msg and strlower(msg)=="reset") then
		GearHud_Reset();
		GearHud_Lock();
	elseif(msg and strlower(msg)=="debug") then
		GearHud_Lock();
		GearHud_Count = 1;
		GearHudDebug:Show();
	else
		if(GearHud.tex:IsVisible()) then
            GearHud_Count = 0;
			GearHud_Lock();
		else
            GearHud_Count = 10000000000;
			GearHud_UnLock();
		end		
	end
end
