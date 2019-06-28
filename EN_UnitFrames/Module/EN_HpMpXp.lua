local n2s, f2s, floor = n2s, f2s, floor
local function isBlizTextDisplay() return GetCVarBool("statusText") and GetCVar("statusTextDisplay") ~= "NUMERIC" end
local textDisplay = isBlizTextDisplay()

local RED     = "|cffff0000";
local GREEN   = "|cff00ff00";
local BLUE    = "|cff0000ff";
local MAGENTA = "|cffff00ff";
local YELLOW  = "|cffffff00";
local CYAN    = "|cff00ffff";
local WHITE   = "|cffffffff";
local NORMAL  = "|r";
function EUF_HpMpXp_OnLoad(self)
	--self:RegisterEvent("VARIABLES_LOADED");
	self:RegisterEvent("UNIT_MANA");
	self:RegisterEvent("UNIT_HEALTH");
    self:RegisterEvent("UNIT_MAXHEALTH")
    self:RegisterEvent("UNIT_HEALTH_FREQUENT");
    self:RegisterEvent("UNIT_LEVEL");
    self:RegisterEvent("UNIT_POWER_UPDATE")
    self:RegisterEvent("UNIT_MAXPOWER")
	self:RegisterEvent("UNIT_DISPLAYPOWER");
	self:RegisterEvent("UPDATE_EXHAUSTION");
	self:RegisterEvent("UPDATE_FACTION");
	self:RegisterEvent("UPDATE_SHAPESHIFT_FORMS");
	--self:RegisterEvent("UNIT_DISPLAYPOWER");
	self:RegisterEvent("UNIT_PORTRAIT_UPDATE");
	self:RegisterEvent("UNIT_PET")
	self:RegisterEvent("GROUP_ROSTER_UPDATE");
	self:RegisterEvent("PARTY_MEMBER_ENABLE");
	self:RegisterEvent("PARTY_MEMBER_DISABLE");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("PLAYER_LEVEL_UP");
	self:RegisterEvent("PLAYER_TARGET_CHANGED");
	self:RegisterEvent("PLAYER_XP_UPDATE");
    self:RegisterEvent'UNIT_EXITED_VEHICLE'
    self:RegisterEvent'UNIT_ENTERED_VEHICLE'
    self:RegisterEvent("PLAYER_FOCUS_CHANGED")
    self:RegisterEvent("CVAR_UPDATE")
    --[[
	local parent =  CreateFrame("Frame","PlayerValueFrame",PlayerFrame);
	parent:SetWidth(PlayerFrame:GetWidth()-100);
	parent:SetHeight(PlayerFrame:GetHeight());
	parent:ClearAllPoints();
	parent:SetFrameLevel(PlayerFrame:GetFrameLevel()+2);
	parent:SetPoint("RIGHT",PlayerFrame,"RIGHT");
	
	local FontString = parent:CreateFontString("","OVERLAY");
	FontString:SetFont(ChatFontNormal:GetFont(),14)
	
	FontString:SetAllPoints(parent);
	FontString:ClearAllPoints();
	FontString:SetPoint("CENTER",parent,"CENTER",0,-8);
	parent.NewManaValue = FontString;	
	
	FontString = parent:CreateFontString("","OVERLAY");
	FontString:SetFont(ChatFontNormal:GetFont(),14)
	
	FontString:SetAllPoints(parent);
	FontString:ClearAllPoints();
	FontString:SetPoint("CENTER",parent,"CENTER",0,6);
	parent.NewHealthValue = FontString;
	parent:Hide();
	--]]
end

function EUF_HpMpXp_OnEvent(event, unit)
	if event == "UNIT_HEALTH" or event == 'UNIT_MAXHEALTH' or event == 'UNIT_HEALTH_FREQUENT' then
		EUF_HP_Update(unit);
    elseif (event == 'UNIT_POWER_UPDATE' or event == 'UNIT_MAXPOWER' ) then
		EUF_MP_Update(unit);
	elseif event == "UNIT_PET" then
		EUF_PetFrameHPMP_Update()
	elseif event == "GROUP_ROSTER_UPDATE" then
        if(not IsInRaid())then
		    EUF_PartyFrameHPMP_Update();
		    EUF_PartyFrameDisplay_Update();
        end
	elseif event == "PLAYER_TARGET_CHANGED" then
		EUF_TargetFrameHPMP_Update();
	elseif event == "PLAYER_ENTERING_WORLD" then
		EUF_Frame_Update();
		PlayerHp_Update();
		PlayerPower_Update();
	elseif event == "UNIT_LEVEL" or event == "UNIT_DISPLAYPOWER" then
		EUF_HP_Update(unit);
		EUF_MP_Update(unit);
    elseif event == "PLAYER_FOCUS_CHANGED" then
        EUF_HP_Update("focus");
        EUF_MP_Update("focus");
    elseif event == "PLAYER_XP_UPDATE" or event == "UPDATE_FACTION" then
        EUF_PlayerFrameXp_Update();
    elseif event == 'UNIT_ENTERED_VEHICLE' or event == 'UNIT_EXITED_VEHICLE' then
        if(unit == 'player' or unit == 'vehicle') then
            EUF_PlayerFrame_UpdateVehicle()
        end
	--elseif event == "VARIABLES_LOADED" then
	--	EUF_HpMpXp_Init();
	--	PlayerHp_Update();
	--	PlayerPower_Update();
    elseif event == "CVAR_UPDATE" then
        textDisplay = isBlizTextDisplay()
        EUF_TargetFrameDisplay_Update()
	end
end

local function getPercent(value, max)
    if value == 0 then return "" end
    if value == max then return "100%" end
    return f2s(100 * value / max, 1) .. "%"
end

function PlayerHp_Update()

	local unit = PlayerFrame.unit or "player";
	local value = UnitHealth(unit)
	local valueMax = UnitHealthMax(unit)
	--PlayerValueFrame.NewHealthValue:SetText( currValue.."/"..valueMax);
	EUF_PlayerFrameHP:SetText(value .."/"..valueMax)
	EUF_PlayerFrameHPPercent:SetText(getPercent(value, valueMax))
end

function PlayerPower_Update()
	local currValue, valueMax, percent;
	local unit = PlayerFrame.unit or "player";
	currValue = UnitPower(unit);
	valueMax = UnitPowerMax(unit);
 	if valueMax > 0 then
		--PlayerValueFrame.NewManaValue:SetText( currValue.."/"..valueMax);
		EUF_PlayerFrameMP:SetText(currValue.."/"..valueMax);
	else
		--PlayerValueFrame.NewManaValue:SetText("0/0");
		EUF_PlayerFrameMP:SetText("");
	end
end
--

--加入即時更新血量及上載具時更新為載具血量
PlayerFrameHealthBar:HookScript("OnValueChanged", function(self, value)
	local _, valueMax = self:GetMinMaxValues()
	local value = self:GetValue()
	--PlayerValueFrame.NewHealthValue:SetText( Value.."/"..valueMax);
	EUF_PlayerFrameHP:SetText(n2s(value).."/"..n2s(valueMax))
	EUF_PlayerFrameHPPercent:SetText(getPercent(value, valueMax))
end)

--加入即時更新魔力、能量、怒氣、符能值及上載具時更新為載具魔力
PlayerFrameManaBar:SetScript("OnValueChanged", function(self)
	local _, valueMax = self:GetMinMaxValues();
	if valueMax > 0 then
        local value = self:GetValue();
		--PlayerValueFrame.NewManaValue:SetText( value .."/"..valueMax);
		EUF_PlayerFrameMP:SetText(n2s(value).."/"..n2s(valueMax));
	else		
		--PlayerValueFrame.NewManaValue:SetText("0/0");
		EUF_PlayerFrameMP:SetText("");
	end
end)

hooksecurefunc("UIParent_UpdateTopFramePositions", function()
    if (TargetFrame and not TargetFrame:IsUserPlaced() and not InCombatLockdown()) then
        TargetFrame:SetPoint("TOPLEFT", "PlayerFrame", "TOPRIGHT", 95, 0);
    end
end)

function EUF_HpMpXp_Init()
	local flag=MHDB and MHDB["tab"] and MHDB["tab"]["defpos"]
	if not (flag and flag["TargetFrame"]) then
        if not TargetFrame:IsUserPlaced() then
		    TargetFrame:SetPoint("TOPLEFT", "PlayerFrame", "TOPRIGHT", 95, 0);
        end
	end
	if not (flag and flag["PetFrame"]) then
		PetFrame:SetPoint("TOPLEFT","PlayerFrame","TOPLEFT",72,-80);
		PetName:SetPoint("BOTTOMLEFT","PetFrame","BOTTOMLEFT",50,31);	
	end
	if not (flag and flag["PartyMemberFrame1"]) then
		--PartyMemberFrame1:ClearAllPoints();
		--PartyMemberFrame1:SetPoint("TOPLEFT","UIParent","TOPLEFT",20,-180);
	end
	if not (flag and flag["PartyMemberFrame2"]) then
		PartyMemberFrame2:SetPoint("TOPLEFT","PartyMemberFrame1PetFrame","BOTTOMLEFT",-23,-12);
	end
	if not (flag and flag["PartyMemberFrame3"]) then
		PartyMemberFrame3:SetPoint("TOPLEFT","PartyMemberFrame2PetFrame","BOTTOMLEFT",-23,-12);
	end
	if not (flag and flag["PartyMemberFrame4"]) then
		PartyMemberFrame4:SetPoint("TOPLEFT","PartyMemberFrame3PetFrame","BOTTOMLEFT",-23,-12);
	end
	EUF_Frame_Update();
end

-- PlayerFrame
function EUF_PlayerFramePosition_Update()
	
end

local function updateBarColor(self, value)
    if ( not value ) then
        return;
    end
    local r, g, b;
    local min, max = self:GetMinMaxValues();
    if ( (value < min) or (value > max) ) then
        return;
    end
    if ( (max - min) > 0 ) then
        value = (value - min) / (max - min);
    else
        value = 0;
    end
    if(value > 0.5) then
        r = (1.0 - value) * 2;
        g = 1.0;
    else
        r = 1.0;
        g = value * 2;
    end
    b = 0.0;
    if ( not self.lockColor ) then
        self:SetStatusBarColor(r, g, b);
    end
end

--用这个可以方式避免闪烁
hooksecurefunc("HealthBar_OnValueChanged", function(self, value)
    if EUF_CurrentOptions and EUF_CurrentOptions["AUTOHEALTHCOLOR"] == 1 then
        if self==PlayerFrameHealthBar
                or self==PetFrameHealthBar
                or self==TargetFrameHealthBar
                or self==FocusFrameHealthBar
                or self==PartyMemberFrame1HealthBar or self==PartyMemberFrame2HealthBar or self==PartyMemberFrame3HealthBar or self==PartyMemberFrame4HealthBar then
            updateBarColor(self, value)
        end
    end
end)

--[[
--TODO: 会在 UnitFrameHealthBar_Update 的时候设置回来
if FocusFrameToTHealthBar then FocusFrameToTHealthBar:HookScript("OnValueChanged", updateBarColor) end
if TargetFrameToTHealthBar then TargetFrameToTHealthBar:HookScript("OnValueChanged", updateBarColor) end
]]

local nameCache = {} for i=1, 4 do nameCache["party"..i] = "EUF_PartyFrame"..i end
-- HP/MP/XP
function EUF_HP_Update(unit)
	if not unit or (unit ~= "pet" and unit ~="target" and unit ~="focus" and not nameCache[unit]) then --unit ~= "player" and
		return;
	end

	local currValue = UnitHealth(unit);
	local maxValue = UnitHealthMax(unit);
	local digit;
    if unit=="player" or unit=="target" or unit=="focus" then
        digit = EUF_FormatNumericValue(currValue)  .. " / " .. EUF_FormatNumericValue(maxValue);
    else
		digit = EUF_FormatNumericValue(currValue)  .. "/" .. EUF_FormatNumericValue(maxValue);
    end

	if maxValue == 0 then
		digit = "";
	end

	if unit == "target" and UnitIsDead("target") then
		digit = "";
	end

    -- FIXME
    -- this is a bug when maxValue == 0
    if(maxValue == 0) then
        maxValue = 1
    end

	local unitObj, unitPercentObj, unitObjShow, unitPercentObjShow, unitId;

	if unit == "pet" then
		unitObj = EUF_PetFrameHP;
    --elseif unit == "player" then
    --    PlayerValueFrame.NewHealthValue:SetText( currValue.."/"..maxValue);
    elseif unit == "target" then
		unitObj = EUF_TargetFrameHP;
		unitPercentObj = EUF_TargetFrameHPPercent;
	elseif (unit == "focus") then
		unitObj = EUF_FocusFrameHP;
		unitPercentObj = EUF_FocusFrameHPPercent;
	else
        local name = nameCache[unit]
		if (name) then
			unitObj = _G[name .. "HP"];
			unitPercentObj = _G[name .. "HPPercent"]
		end
	end
	if unitObj then
		unitObj:SetText(digit);
	end
	if unitPercentObj then
		unitPercentObj:SetText(getPercent(currValue, maxValue));
	end
end

function EUF_MP_Update(unit)
    if not unit or (unit ~= "pet" and unit ~="target" and unit ~="focus" and not nameCache[unit]) then --unit ~= "player" and
        return;
    end
	local currValue = UnitPower(unit);
	local maxValue = UnitPowerMax(unit);
	local percent = maxValue == 0 and 0 or floor(currValue * 100 / maxValue);
    local digit;
    if unit=="player" or unit=="target" or unit=="focus" then
        digit = EUF_FormatNumericValue(currValue)  .. " / " .. EUF_FormatNumericValue(maxValue);
    else
        digit = EUF_FormatNumericValue(currValue)  .. "/" .. EUF_FormatNumericValue(maxValue);
    end

    if percent and maxValue ~= 0 then
        percent = n2s(percent) .. "%";
    else
        percent = "";
        digit = "";
    end

	local unitObj, unitPercentObj, unitObjShow, unitPercentObjShow, unitId;

	if unit == "pet" then
		unitObj = EUF_PetFrameMP;
    --elseif unit == "player" then
    --        PlayerValueFrame.NewManaValue:SetText( currValue.."/"..maxValue);
	elseif unit == "target" then
		unitObj = EUF_TargetFrameMP;
		--unitPercentObj = EUF_TargetFrameMPPercent;
	elseif unit == "focus" then
		unitObj = EUF_FocusFrameMP;
    else
        local name = nameCache[unit]
        if (name) then
            unitObj = _G[name .. "MP"];
            unitPercentObj = _G[name .. "MPPercent"]
        end
    end

	if unitObj then
		unitObj:SetText(digit);
	end
	if unitPercentObj then
		unitPercentObj:SetText(percent);
	end
end

-- XP
function EUF_PlayerFrameXp_Update()
    local name, reaction, mini, max, value = GetWatchedFactionInfo();
    max = max - mini;
	value = value - mini;
	mini = 0;
	local color = FACTION_BAR_COLORS[reaction]
    local playerReputation = value;
    local playerReputationMax = max;

    local playerXP = UnitXP("player");
    local playerXPMax = UnitXPMax("player");
    local playerXPRest = GetXPExhaustion();
	-- 显示声望
    if name then --ReputationWatchBar:IsVisible() and
       if(EUF_CurrentOptions) then
			if EUF_CurrentOptions["PLAYERHPMP"] == 1 then
				EUF_PlayerFrameXP:SetText(WHITE..string.format("%s %s/%s", name or "", value, max))
			else
				EUF_PlayerFrameXP:SetText(WHITE..string.format("%s/%s", value, max))
			end
		else
			EUF_PlayerFrameXP:SetText(WHITE..string.format("%s/%s", value, max))
		end

		EUF_PlayerFrameXPBar:SetMinMaxValues(min(0, playerReputation), playerReputationMax)
		EUF_PlayerFrameXPBar:SetValue(value)
		EUF_PlayerFrameXPBar:SetStatusBarColor(color.r, color.g, color.b)
    else
		if EUF_CurrentOptions then 
			if not playerXPRest or EUF_CurrentOptions["PLAYERHPMP"] ~= 1 then				
				EUF_PlayerFrameXP:SetText(string.format("%s / %s", playerXP, playerXPMax));				
			else			
				EUF_PlayerFrameXP:SetText(string.format("%s/%s (+%s)", playerXP, playerXPMax, playerXPRest/2));				
			end
		
			EUF_PlayerFrameXPBar:SetMinMaxValues(min(0, playerXP), playerXPMax);
			EUF_PlayerFrameXPBar:SetValue(playerXP);
			EUF_PlayerFrameXPBar:SetStatusBarColor(0, 0.4, 1)
		end
    end
end

--[[
function EUF_PlayerFrameHPMP_Update()
	local unit = PlayerFrame.unit or "player";
	EUF_HP_Update(unit);
	EUF_MP_Update(unit);
end
]]

function EUF_FocusFrameHPMP_Update()
	EUF_HP_Update("focus");
	EUF_MP_Update("focus");
end

function EUF_PetFrameHPMP_Update()
	local unit = PetFrame.unit or "pet";
	EUF_HP_Update(unit);
	EUF_MP_Update(unit);
end

function EUF_TargetFrameHPMP_Update()
	EUF_HP_Update("target");
	EUF_MP_Update("target");
end

function EUF_PartyFrameHPMP_Update()
	local unit;
	for i=1, GetNumSubgroupMembers() do
		unit = _G["PartyMemberFrame"..i].unit or "party"..i;
		EUF_HP_Update(unit);
		EUF_MP_Update(unit);
	end
end

function EUF_FrameHPMP_Update()
	--EUF_PlayerFrameHPMP_Update();
	EUF_PetFrameHPMP_Update();
	EUF_TargetFrameHPMP_Update();
	EUF_PartyFrameHPMP_Update();
	EUF_FocusFrameHPMP_Update();
end


-- Frame position / display adjust

function EUF_PlayerFrameFrm_Update()
end
hooksecurefunc("PetFrame_Update", function(self, override) 
	if EUF_CurrentOptions["PLAYERHPMP"] == 1 then	
		PetFrameTexture:SetTexture("Interface\\AddOns\\EN_UnitFrames\\Texture\\UI-PetFrameTexture");
	end
end)
function EUF_PlayerFrameExtBar_Update()
	if EUF_CurrentOptions["PLAYERHPMP"] == 1 then
		EUF_PlayerFrameHP:Show();
		EUF_PlayerFrameMP:Show();		
		EUF_PlayerFrameHPPercent:Show();		
		EUF_PlayerFrameBackground:Show();
		EUF_PlayerFrameTextureExt:Show();
		EUF_PlayerFrameXPBarBorders:Show();
		-- 玩家头像
		PlayerFrameBackground:Hide();
		--PlayerFrameTexture:Hide();--11
		-- 宠物头像
		PetFrameTexture:SetWidth(256);
		PetFrameTexture:SetTexture("Interface\\AddOns\\EN_UnitFrames\\Texture\\UI-PetFrameTexture");
		--PetFrameHappiness:ClearAllPoints();
		--PetFrameHappiness:SetPoint("LEFT", "PetFrame", "RIGHT", 70, -4);
		-- 闪烁纹理
		PlayerFrameFlash:SetWidth(335);		
		PlayerFrameFlash:SetTexture("Interface\\AddOns\\EN_UnitFrames\\Texture\\UI-TargetingFrame-Flash");
		PlayerFrameFlash:SetTexCoord(0.7421875, 0, 0, 0.7265625);
		-- 目标头像
		--dwSecureCall(TargetFrame.SetPoint, TargetFrame, "TOPLEFT", "PlayerFrame", "TOPRIGHT", 95, 0);
	else	
		EUF_PlayerFrameHP:Hide();		
		EUF_PlayerFrameMP:Hide();		
		EUF_PlayerFrameHPPercent:Hide();
		EUF_PlayerFrameBackground:Hide();
		EUF_PlayerFrameTextureExt:Hide();
		EUF_PlayerFrameXPBarBorders:Hide();
		-- 玩家头像
		PlayerFrameBackground:Show();
		--PlayerFrameTexture:Show();--11
		-- 宠物头像
		PetFrameTexture:SetWidth(128);
		PetFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-SmallTargetingFrame");	
		--PetFrameHappiness:ClearAllPoints();
		--PetFrameHappiness:SetPoint("LEFT", "PetFrame", "RIGHT", -7, -4);
		-- 闪烁纹理
		PlayerFrameFlash:SetWidth(242);
		PlayerFrameFlash:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Flash");
		PlayerFrameFlash:SetTexCoord(0.9453125, 0, 0, 0.181640625);
		-- 目标头像
		--dwSecureCall(TargetFrame.SetPoint, TargetFrame, "TOPLEFT", "PlayerFrame", "TOPRIGHT", 10, 0);
    end

    hooksecurefunc("PlayerFrame_ToPlayerArt", function()
        if EUF_CurrentOptions["PLAYERHPMP"] == 1 then
            PlayerFrameFlash:SetTexture("Interface\\AddOns\\EN_UnitFrames\\Texture\\UI-TargetingFrame-Flash");
            PlayerFrameFlash:SetTexCoord(0.7421875, 0, 0, 0.7265625);
        end
    end)
end

function EUF_PlayerFrameDisplay_Update()
	if (EUF_CurrentOptions)then
		-- 生命值
		if EUF_CurrentOptions["PLAYERHPMP"] == 0 then
			EUF_ObjectDisplay_Update(EUF_PlayerFrameHP, 0);
			EUF_ObjectDisplay_Update(EUF_PlayerFrameHPPercent, 0);
		else			
			EUF_ObjectDisplay_Update(EUF_PlayerFrameHP, 1);
			EUF_ObjectDisplay_Update(EUF_PlayerFrameHPPercent, 1);
		end
		
		-- 发力值
		if EUF_CurrentOptions["PLAYERHPMP"] == 0 then
			EUF_ObjectDisplay_Update(EUF_PlayerFrameMP, 0);			
		else
			EUF_ObjectDisplay_Update(EUF_PlayerFrameMP, 1);
		end

		-- 刷新经验条
		EUF_ObjectDisplay_Update(EUF_PlayerFrameXP, EUF_CanXPBarShow());
		EUF_ObjectDisplay_Update(EUF_PlayerFrameXPBar, EUF_CanXPBarShow());
	end
end


function EUF_XPBarToggle(switch)
	if (switch) then
		EUF_CurrentOptions["PLAYERXP"] = 1;
        EUF_ObjectDisplay_Update(EUF_PlayerFrameXP, 1);
        EUF_ObjectDisplay_Update(EUF_PlayerFrameXPBar, 1);
	else
		EUF_CurrentOptions["PLAYERXP"] = 0;
		EUF_ObjectDisplay_Update(EUF_PlayerFrameXP, 0);
        EUF_ObjectDisplay_Update(EUF_PlayerFrameXPBar, 0);
	end
end

function EUF_PetFrameDisplay_Update()
	local classLoc, class = UnitClass("player")
	if EUF_CurrentOptions then
		if EUF_CurrentOptions["PLAYERPETHPMP"] == 1 then
			EUF_PetFrameHP:Show()
		else
			EUF_PetFrameHP:Hide()
		end
	end
end

local partyTexts = {"HP", "HPPercent", "MP", "MPPercent"};
function EUF_PartyFrame_OnLoad(self)
	local text;
	for k, v in pairs(partyTexts) do
		text = getglobal(self:GetName() .. v);
	end
end

function EUF_PartyFrameExtBar_Update()	
end

function EUF_PartyFrameDisplay_Update()
	EUF_PartyFrameExtBar_Update();
	for i=1, GetNumSubgroupMembers() do
        if _G["PartyMemberFrame" .. i .. "Debuff1"] then
            _G["PartyMemberFrame" .. i .. "Debuff1"]:ClearAllPoints()
            if EUF_CurrentOptions["PARTYHPMP"] == 0 then
                _G["PartyMemberFrame" .. i .. "Debuff1"]:SetPoint("LEFT",_G["PartyMemberFrame"..i],"RIGHT",-5,4)
            else
                _G["PartyMemberFrame" .. i .. "Debuff1"]:SetPoint("LEFT",_G["PartyMemberFrame"..i],"RIGHT",50,30)
            end
        end
		if EUF_CurrentOptions["PARTYHPMP"] == 0 then
			EUF_ObjectDisplay_Update(_G["EUF_PartyFrame"..i.."HP"], 0);	
			EUF_ObjectDisplay_Update(_G["EUF_PartyFrame"..i.."MP"], 0);	            
			_G["PartyMemberFrame" .. i .. "Texture"]:SetWidth(128);
			_G["PartyMemberFrame" .. i .. "Texture"]:SetTexture("Interface\\TargetingFrame\\UI-PartyFrame");
		else
			EUF_ObjectDisplay_Update(_G["EUF_PartyFrame"..i.."HP"], 1);	
			EUF_ObjectDisplay_Update(_G["EUF_PartyFrame"..i.."MP"], 1);
			_G["PartyMemberFrame" .. i .. "Texture"]:SetWidth(260);
			_G["PartyMemberFrame" .. i .. "Texture"]:SetTexture("Interface\\AddOns\\EN_UnitFrames\\Texture\\UI-PartyFrame");
		end
	end
end

function EUF_TargetFrameDisplay_Update()
	if(EUF_CurrentOptions) then
        textDisplay = false
		EUF_ObjectDisplay_Update(EUF_TargetFrameHP, not textDisplay and EUF_CurrentOptions["TARGETHPMPBLIZ"]==0 and EUF_CurrentOptions["TARGETHPMP"]);
		EUF_ObjectDisplay_Update(EUF_TargetFrameHPPercent, EUF_CurrentOptions["TARGETHPMPPERCENT"]);
		EUF_ObjectDisplay_Update(EUF_TargetFrameMP, not textDisplay and EUF_CurrentOptions["TARGETHPMPBLIZ"]==0 and EUF_CurrentOptions["TARGETHPMP"]);
		EUF_ObjectDisplay_Update(EUF_TargetFrameMPPercent, EUF_CurrentOptions["TARGETHPMPPERCENT"]);

        local hpshow = EUF_TargetFrameHP:IsShown()
        TargetFrameTextureFrameHealthBarText:SetAlpha(hpshow and 0 or 1);
        TargetFrameTextureFrameHealthBarTextLeft:SetAlpha(hpshow and 0 or 1);
        TargetFrameTextureFrameHealthBarTextRight:SetAlpha(hpshow and 0 or 1);
        FocusFrameTextureFrameHealthBarText:SetAlpha(hpshow and 0 or 1);
        FocusFrameTextureFrameHealthBarTextLeft:SetAlpha(hpshow and 0 or 1);
        FocusFrameTextureFrameHealthBarTextRight:SetAlpha(hpshow and 0 or 1);
        local mpshow = EUF_TargetFrameMP:IsShown()
        TargetFrameTextureFrameManaBarText:SetAlpha(mpshow and 0 or 1);
        TargetFrameTextureFrameManaBarTextLeft:SetAlpha(mpshow and 0 or 1);
        TargetFrameTextureFrameManaBarTextRight:SetAlpha(mpshow and 0 or 1);
        FocusFrameTextureFrameManaBarText:SetAlpha(mpshow and 0 or 1);
        FocusFrameTextureFrameManaBarTextLeft:SetAlpha(mpshow and 0 or 1);
        FocusFrameTextureFrameManaBarTextRight:SetAlpha(mpshow and 0 or 1);

        if EUF_FocusFrameHP then
            EUF_ObjectDisplay_Update(EUF_FocusFrameHP, not textDisplay and EUF_CurrentOptions["TARGETHPMPBLIZ"]==0 and EUF_CurrentOptions["TARGETHPMP"]);
      	    EUF_ObjectDisplay_Update(EUF_FocusFrameHPPercent, EUF_CurrentOptions["TARGETHPMPPERCENT"]);
      	    EUF_ObjectDisplay_Update(EUF_FocusFrameMP, not textDisplay and EUF_CurrentOptions["TARGETHPMPBLIZ"]==0 and EUF_CurrentOptions["TARGETHPMP"]);
      	    EUF_ObjectDisplay_Update(EUF_FocusFrameMPPercent, EUF_CurrentOptions["TARGETHPMPPERCENT"]);
        end
	end
end

function EUF_FrameDisplay_Update()
	EUF_PlayerFrameDisplay_Update();
	EUF_PetFrameDisplay_Update()
	EUF_TargetFrameDisplay_Update();
	EUF_PartyFrameDisplay_Update();
end

function EUF_Frame_Update(self, el)
	EUF_FrameDisplay_Update();
	EUF_FrameHPMP_Update();
	EUF_PlayerFrameXp_Update();
	EUF_PlayerFrameFrm_Update();
	EUF_PlayerFrameExtBar_Update();
    EUF_PlayerFrame_UpdateVehicle()
end

function EUF_PlayerFrame_UpdateVehicle()
	-- 加入上下載具時，頭像更新及死騎符文條位置
    if true then return end --fix7

	local _,class = UnitClass("player");
	local frame
	if class=="DEATHKNIGHT" then
		frame=_G["RuneFrame"]
	elseif class=="PALADIN" then
		frame=_G["PaladinPowerBarFrame"]
	--elseif class=="DRUID" then
	--	frame=_G["EclipseBarFrame"]
	elseif class=="WARLOCK" then
		frame=_G["WarlockPowerFrame"]
    elseif class=="MONK" then
   		frame=_G["MonkHarmonyBarFrame"]
    elseif class=="MAGE" then
   		frame=_G["MageArcaneChargesFrame"]
    --elseif class=="PRIEST" then
   	--	frame=_G["InsanityBarFrame"]
    end
	if frame and EUF_PlayerFrameXPBar and select(2, frame:GetPoint())==PlayerFrame then
		if EUF_PlayerFrameXPBar:IsShown() then
			frame:ClearAllPoints()
			frame:SetPoint("TOP", "PlayerFrame","BOTTOM", 60, 15)
			if PlayerFrameAlternateManaBar and  PlayerFrameAlternateManaBar:IsShown() then
				 PlayerFrameAlternateManaBar:Hide()
			end
		else
			frame:ClearAllPoints()
			if class=="DEATHKNIGHT" or class=="WARLOCK" then
				frame:SetPoint("TOP", "PlayerFrame","BOTTOM", 52,33)
			else
                frame:SetPoint("TOP", "PlayerFrame","BOTTOM", 43,39)
            end
		end
	end
	--[[if ( class=="DEATHKNIGHT" and PetFrame:IsVisible()) then
		RuneFrame:SetScale(1)
		RuneFrame:ClearAllPoints()
		RuneFrame:SetPoint("TOP","PetFrame","BOTTOM",27,4)
	else
		RuneFrame:SetScale(1)
		RuneFrame:ClearAllPoints()
		RuneFrame:SetPoint("TOP", "PlayerFrame","BOTTOM", 60, 15)
	end
	if ( class=="Paladin" and PaladinPowerBar:IsVisible()) then
		PaladinPowerBar:SetScale(1)
		PaladinPowerBar:ClearAllPoints()
		PaladinPowerBar:SetPoint("TOP","PetFrame","BOTTOM",27,4)
	else
		PaladinPowerBar:SetScale(1)
		PaladinPowerBar:ClearAllPoints()
		PaladinPowerBar:SetPoint("TOP", "PlayerFrame","BOTTOM", 60, 15)
	end
	if ( class=="DRUID" and EclipseBarFrame:IsVisible()) then
		EclipseBarFrame:SetScale(1)
		EclipseBarFrame:ClearAllPoints()
		EclipseBarFrame:SetPoint("TOP","PetFrame","BOTTOM",27,4)
	else
		EclipseBarFrame:SetScale(1)
		EclipseBarFrame:ClearAllPoints()
		EclipseBarFrame:SetPoint("TOP", "PlayerFrame","BOTTOM", 60, 15)
	end]]
end

--Basic functions
function EUF_CanXPBarShow()
	local canShow = EUF_CurrentOptions["PLAYERXP"];
	-- 将AutoHide改为满级时显示声望条
	if (canShow == 1 and EUF_CurrentOptions["PLAYERXPAUTO"] == 0 and UnitLevel("player") and UnitLevel("player") >= 70) then
		canShow = 0;
	end
	return canShow;
end
