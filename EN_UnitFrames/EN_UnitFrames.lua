local filename, fontHeight, flags = dwTextStatusBarTextSmall:GetFont() dwTextStatusBarTextSmall:SetFont(filename, 11, flags)
local filename, fontHeight, flags = dwTextStatusBarTextTiny:GetFont() dwTextStatusBarTextTiny:SetFont(filename, 9, flags)

EN_RealmName = GetRealmName();
if not EN_RealmName then
	EN_RealmName = "Enigma";
end
EN_PlayerName = UnitName("player");
if not EN_PlayerName then
	EN_PlayerName = "Unknown";
end
EN_PlayerId = EN_RealmName .. "." .. EN_PlayerName;

EUF_Version = "3.1.2"
EUF_AddonId = "EUF";
EUF_AddonName = "Enigma Unit Frames";

mg_EUF_Options = {};

local EUF_DefaultOptions= {
	["PLAYERFRM"] = 1,						-- 稀有精英头像
	["PLAYERHPMP"] = 1,						-- 玩家生命值和法力值(扩展框)
	["PLAYERXP"]	 = 1,
	["PLAYERXPAUTO"] = 1,					-- 满级显示声望	
	["PLAYERRARE"] = 0,	
	["PLAYERCLASSICONSMALL"] = 0,			-- 玩家职业图标(小)
	["PLAYERPETHPMP"] = 1,					-- 宠物生命和魔法

	["TARGETHPMPPERCENT"] = 1,				-- 目标生命百分比
	["TARGETCLASSICONSMALL"] = 1,			-- 目标小职业图标
	["TARGETINFO"] = 0,						-- 目标信息(头像上)
	["TARGETTARGETHPMPPERCENT"] = 1,		-- 目标的目标生命值百分比	
	["TARGETHPMP"] = 1,						-- 目标生命值
	--["TARGETPERCENTBOSS"] = 0,				-- 目标为boss时只显示百分比

	["PARTYCOLOR"] = 1,
	["PARTYCLASSICONSMALL"] = 0,			-- 队友职业小图标
	["PARTYINFO"] = 1,						-- 队友职业和等级
	["PARTYHPMP"] = 1,	

	["AUTOHEALTHCOLOR"] = 1,				-- 着色生命条
	["3DPORTRAIT"] = 0,						-- 玩家头像3D显示

	["VERSION"] = "3.1.1",	
	["COMPATIBLEVERSION"] = "3.1.1",
	["MOVINGTARGETTARGETFRAME"] = 0,	

    ["NUMBERFORMAT"] = 0,                   -- 数字显示格式, [1] 万进位 [2] 千进位
};

function EUF_OnLoad(self)
	self:RegisterEvent("ADDON_LOADED");
	--Slash Command Handler
	SLASH_EUF1 = "/euf";
	SLASH_EUF2 = "/enigmaunitframes";
	SlashCmdList[EUF_AddonId] = function(msg)
		EUF_SlashCommandHandler(msg);
	end

end

function EUF_OnEvent(self, event, ...)
	local arg1 = ...;
	if event == "ADDON_LOADED" and arg1 == "EN_UnitFrames" then	
		EUF_Options_Init();
		-- 生命值和魔法值
		if EUF_HpMpXp_Init then
			EUF_HpMpXp_Init();
		end
		-- 3D头像
		if (EUF_3DPortrait_OnUpdate) then
			EUF_3DPortrait_OnUpdate();
		end
		-- 职业图标
		if EUF_FrameClassIcon_Update then
			EUF_FrameClassIcon_Update();
		end
		-- 队友信息
		if EUF_PartyInfo_Update then
			EUF_PartyInfo_Update();
		end
		-- 目标信息
		if EUF_TargetInfo_Update then
			EUF_TargetInfo_Update();
		end
		-- 目标的目标框架
		if EUF_UpdateTargetOfTargetFrame then
			EUF_UpdateTargetOfTargetFrame();
		end
		-- 状态条状态
		EUF_InitCVar();
	end
end

function EUF_SlashCommandHandler(msg)
	
end

function EUF_Options_Init()
	-- 载入配置
	if not mg_EUF_Options then
		mg_EUF_Options = {};
	end
	if mg_EUF_Options[EN_PlayerId] then
		EUF_CurrentOptions = mg_EUF_Options[EN_PlayerId];
	end
	
	if not EUF_CurrentOptions then
		EUF_CurrentOptions={};
		EUF_OptionsDefault_Load();
	end
	
	if not EUF_CurrentOptions["VERSION"] or EUF_DefaultOptions["COMPATIBLEVERSION"] > EUF_CurrentOptions["VERSION"] then
		EUF_OptionsDefault_Load();
		EN_Msg(EUF_AddonId, EUF_TEXT_OPTION_NOTCOMPATIBLE);
	end
	
	EUF_CurrentOptions["VERSION"] = nil;

	local index, value;
	for index, value in pairs(EUF_DefaultOptions) do
		if not EUF_CurrentOptions[index] then
			EUF_CurrentOptions[index] = value;
		end
	end


    hooksecurefunc('TextStatusBar_UpdateTextStringWithValues', EUF_TextStatusBar_UpdateTextStringWithValues)
end

-- 载入缺省配置
function EUF_OptionsDefault_Load()
	if not mg_EUF_Options then
		mg_EUF_Options = {};
	end
	mg_EUF_Options[EN_PlayerId] = {};
	for index, value in pairs(EUF_DefaultOptions) do
		mg_EUF_Options[EN_PlayerId][index] = value;
	end
	EUF_CurrentOptions = mg_EUF_Options[EN_PlayerId];
end

function EUF_Options_Update(oOptionId, oValue)
	if not EUF_CurrentOptions then 
		return;
	end
	if not oOptionId or not oValue then
		return -1;
	end
	
	local optionId = string.upper(oOptionId);
	local value = tonumber(oValue);
	if value ~= 1 then
		value = 0;
	end

	EUF_CurrentOptions[optionId] = value;
	
	-- 显示生命及扩展框
	if (optionId == "PLAYERHPMP") then
		if EUF_PlayerFrameDisplay_Update then
			EUF_PlayerFrameDisplay_Update();
		end
		if EUF_PlayerFrameExtBar_Update and EUF_PlayerFrameXp_Update  then
			EUF_PlayerFrameExtBar_Update();
			EUF_PlayerFrameXp_Update();
		end
	elseif ((optionId == "PLAYERXP") or (optionId == "PLAYERXPAUTO")) then
		if EUF_PlayerFrameDisplay_Update then
			EUF_PlayerFrameDisplay_Update();
		end
	elseif (optionId == "AUTOHEALTHCOLOR") then
		if EUF_PlayerFrameHPMP_Update then
			EUF_PlayerFrameHPMP_Update();
		end
		if EUF_PartyFrameHPMP_Update then
			EUF_PartyFrameHPMP_Update();
		end
		if EUF_TargetFrameHPMP_Update then
			EUF_TargetFrameHPMP_Update();
		end
   elseif (optionId == "PLAYERFRM") then
        if EUF_PlayerFrameFrm_Update then
            EUF_PlayerFrameFrm_Update();
        end
	elseif (optionId == "PLAYERCLASSICONSMALL") then
		if EUF_ClassIcon_Update then
			EUF_ClassIcon_Update("player", "Small", value);
		end
    elseif (optionId == "PLAYERPETHPMP") then
        if EUF_PetFrameDisplay_Update then
            EUF_PetFrameDisplay_Update()
        end
	elseif (optionId == "PARTYHPMP") then
		if EUF_PartyFrameDisplay_Update then
			EUF_PartyFrameDisplay_Update();
		end		
	elseif (optionId == "PARTYINFO") then
		if EUF_FramePartyInfo_Update then
			EUF_FramePartyInfo_Update();
		end
	elseif (optionId == "PARTYCOLOR") then
		if EUF_PartyMember_CheckClass  then
			EUF_PartyMember_CheckClass();
		end
	elseif (optionId == "PARTYCLASSICONSMALL") then
		if EUF_ClassIcon_Update then
			EUF_ClassIcon_Update("party", "Small", value);
		end
	elseif (optionId == "TARGETHPMP") or (optionId == "TARGETHPMPPERCENT") then
		if EUF_TargetFrameDisplay_Update then
			EUF_TargetFrameDisplay_Update();
		end
	elseif (optionId == "TARGETINFO") then
		if EUF_TargetInfoClass_Update then
			EUF_TargetInfoClass_Update();
		end
	elseif (optionId == "TARGETCLASSICONSMALL") then
		if EUF_ClassIcon_Update then
			EUF_ClassIcon_Update("target", "Small", value);
		end
	elseif (optionId == "3DPORTRAIT") then
        if EUF_3DPortrait_OnUpdate then		
            EUF_3DPortrait_OnUpdate();
        end
	elseif (optionId == "NUMBERFORMAT") then
		TextStatusBar_UpdateTextString(PlayerFrameHealthBar)
		TextStatusBar_UpdateTextString(PlayerFrameManaBar)
		EUF_TargetFrameDisplay_Update();
	else
		return -1;
	end
end

function EUF_GetPercentColor(value, valueMax)
	local r = 0;
	local g = 1;
	local b = 0;
	if (value and valueMax) then
		local valuePercent =  tonumber(value) / tonumber(valueMax);
		if (valuePercent >= 0 and valuePercent <= 1) then
			if (valuePercent > 0.5) then
				r = (1.0 - valuePercent) * 2;
				g = 1.0;
			else
				r = 1.0;
				g = valuePercent * 2;
			end
		end
	end
	if r < 0 then
		r = 0;
	end
	if g < 0 then
		g = 0;
	end
	if b < 0 then
		b = 0;
	end
	if r > 1 then
		r = 1;
	end
	if g > 1 then
		g = 1;
	end
	if b > 1 then
		b = 1;
	end	
	return r, g, b;
end

function EN_Msg(Msg1, Msg2)
	local msg = "";
	if Msg2 then
		msg = Msg2;
	end
	if Msg1 then
		if msg == "" then
			msg = "|cffff9900" .. Msg1 .. "|r"
		else
			msg = "|cffff9900[" .. Msg1 .. "]|r " .. msg;
		end
	end
	DEFAULT_CHAT_FRAME:AddMessage(msg);
end

function EUF_ObjectDisplay_Update(obj, status)
	if status == 1 then
		obj:Show();
	else
		obj:Hide();
	end
end

---------------
-- 用于初始化生命条状态
function EUF_InitCVar()
	--[[local ver = dwRawGetCVar("EN_UnitFrames", "ver", "3.1.1");
	if (ver ~= EUF_Version) then
		SetCVar("playerStatusText", "1");
		SetCVar("petStatusText", "1");
		SetCVar("partyStatusText", "1");
		SetCVar("statusTextPercentage", "1");
		dwSetCVar("EN_UnitFrames", "ver", EUF_Version);
	end	]]
end

function dwSecureCall( ...)
	local func = select(1, ...);
	if (type(func) == "function") then	
		if (InCombatLockdown()) then
			--dwPush(func, ...);
			return;
		end
		pcall(...);
	end
end

local n2s, f2s, floor = n2s, f2s, floor
function EUF_FormatNumericValue(value)
    if(EUF_CurrentOptions and EUF_CurrentOptions['NUMBERFORMAT'] == 1) then
        if value <= 99999 then
            return n2s(value);
        elseif value <= 999999 then
            return f2s(value/1e4, 1).."w" --return string.format("%.1fw", value / 1e4);
        elseif value <= 99999999 then
            return n2s(floor(value/1e4)).."w" --return string.format("%dw", value / 1e4);
        else
            return f2s(value/1e8, 1).."亿" --return string.format("%.1f亿", value / 1e8)
        end
    else -- 2
        if value <= 9999 then
            return n2s(value)
        elseif value <= 999999 then
            return f2s(value/1e3, 1).."K" --return string.format("%.1fK", value / 1e3)
        else
            return f2s(value/1e6, 1).."M" --return string.format("%.1fM", value / 1e6)
        end
    end
end

--do
--    local _env = setmetatable({
--        TextStatusBar_CapDisplayOfNumericValue = function(val)
--            return EUF_FormatNumericValue(val)
--        end,
--    }, {__index = _G})
--
--    --setfenv(TextStatusBar_UpdateTextStringWithValues, _env)
--end

function EUF_TextStatusBar_UpdateTextStringWithValues(statusFrame, textString, value, valueMin, valueMax)
	--if ( ( tonumber(valueMax) ~= valueMax or valueMax > 0 ) and not ( statusFrame.pauseUpdates ) ) then
		--if ( value and valueMax > 0 and ( GetCVarBool("statusTextPercentage") or statusFrame.showPercentage ) and not statusFrame.showNumeric) then
            --ommit
        --elseif ( value == 0 and statusFrame.zeroText ) then
            --ommit
        --else
    --target和focus的文字的不走这里，是设置成alpha==0
	--print(statusFrame:GetName() .. tostring(textString:IsVisible()) .. textString:GetAlpha())
    --if textString:IsVisible() and textString:GetAlpha()~=0 then
	if textString:IsVisible() then
		--print(statusFrame.isZero)
        if statusFrame.isZero == nil then
            --if ( GetCVarBool("statusTextPercentage") or statusFrame.showPercentage ) and not statusFrame.showNumeric then print("nothing") return end
			if GetCVar("statusTextDisplay") == "BOTH" or GetCVar("statusTextDisplay") == "PERCENT" then return end
			--print(statusFrame.capNumericDisplay)
            if(statusFrame.capNumericDisplay) then
                value = EUF_FormatNumericValue(value)
                valueMax = EUF_FormatNumericValue(valueMax)
                --只有改掉之后才生效
                if ( statusFrame.prefix and (statusFrame.alwaysPrefix or not (statusFrame.cvar and GetCVar(statusFrame.cvar) == "1" and statusFrame.textLockable) ) ) then
                    textString:SetText(statusFrame.prefix.." "..value.." / "..valueMax);
                else
                    textString:SetText(value.." / "..valueMax);
                end
            end
        end
    end
end