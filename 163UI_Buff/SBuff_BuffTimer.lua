--为了把CPU分到插件里
local name, private = ...
_G[name] = private

local _G,floor,format = _G,floor,format
local U1GetCfgValue, IsAddOnLoaded, UnitAura, PlayerFrame = U1GetCfgValue, IsAddOnLoaded, UnitAura, PlayerFrame
local type,n2s,f2s = type,n2s,f2s

local function SBuff_SecondsToTimeAbbrev(seconds)
    local m,s;
    if(seconds > 60*60*24*1) then
        d = floor(seconds / 60 / 60 / 24)
        return "|cffffd100"..n2s(d).."d"
    elseif(seconds > 60*60*24) then
        d = floor(seconds / 60 / 60 / 24)
        h = floor(seconds % (60*60*24) / 60 / 60)
        return "|cffffd100"..n2s(d).."d"..n2s(h, 2).."h"
    elseif(seconds > 60*180) then --3h 180m 
        h = floor(seconds / 60 / 60)
        return "|cffffd100"..n2s(h)..'h'
    elseif (private.cfg_showsec_10 and seconds >= 600) or seconds > 6000 then
        m = floor( seconds / 60 )
        return "|cffffd100"..n2s(m)..'m'
    elseif ( seconds >= 60) then
        m = floor(seconds / 60);
        s = floor(seconds-m*60);
        --return format("|cff00ff00%01d:%02d|r", m, s);
        return "|cff00ff00"..n2s(m)..":"..n2s(s, 2) --.."|r"
    elseif ( seconds > 0 ) then
        --return format("|cffff0000%01d:%02d|r", m, s);
        return "|cffff00000:"..n2s(floor(seconds), 2) --.."|r"
	else
	    return "N/A"
    end
end

local _ADDONNAME = ...
local doneButtons = {}
-- _G.SBuff_AuraDurationProcessed = doneButtons

local function SBuff_SetFontSize(dura, size)
    local fontfile, height, flags = dura:GetFont()
    dura:SetFont(fontfile, size, flags)
end

local function SBuff_Aura_ChangeBuffFontSize(dura)
    if(dura.__sbuff_proccessed) then return end
    doneButtons[dura] = true
    dura.__sbuff_proccessed = true
    dura:SetWidth(80)

    -- if U1GetCfgValue then
    --     local displaySeconds = U1GetCfgValue(_ADDONNAME, 'time')
    -- end

    local size = U1GetCfgValue(_ADDONNAME, 'cvar_buffDurations/buffSize')
    SBuff_SetFontSize(dura, size)
end

function SBuff_ResetAuraDurationFontSize()
    local size = U1GetCfgValue(_ADDONNAME, 'cvar_buffDurations/buffSize')
    for fs in next, doneButtons do
        SBuff_SetFontSize(fs, size)
    end
end

local function SBuff_AuraButton_UpdateDuration(button, timeleft)
    if(timeleft) then
        local buttonDuration = button.duration
        if buttonDuration:IsShown() then
            buttonDuration:SetText(SBuff_SecondsToTimeAbbrev(timeleft))
            if not buttonDuration.__sbuff_proccessed then
                return SBuff_Aura_ChangeBuffFontSize(buttonDuration)
            end
        end
    end
end

--used in Cfg163UI_Buff.lua
--SBuff_Orig_SecondsToTimeAbbrev = SecondsToTimeAbbrev;
--SecondsToTimeAbbrev = SBuff_SecondsToTimeAbbrev;

--show N/A
local duraCache = {}
local function SBuff_AuraButton_Update(buttonName, index, filter)
    local buffName = buttonName..index;
    local buffDuration = duraCache[buffName]
    if not buffDuration then buffDuration = _G[buffName.."Duration"] duraCache[buffName] = buffDuration end
    if not buffDuration then return end

    local unit = PlayerFrame.unit;
	local name, _, _, _, _, expirationTime = UnitAura(unit, index, filter); --aby8

	if (name) and (expirationTime == 0) then
        if SHOW_BUFF_DURATIONS == "1" and private.cfg_showna then
            local buff = _G[buffName];
            buffDuration:SetText("|cff00ff00N/A|r");
            buffDuration:Show();
            if not buffDuration.__sbuff_proccessed then
                SBuff_Aura_ChangeBuffFontSize(buffDuration)
            end
        else
            if buffDuration:IsShown() then
                buffDuration:Hide()
            end
        end
	end
end

--hooksecurefunc("AuraButton_Update", hookwrap("SBuff_AuraButton_Update")); --在config里处理

function SBuff_Refresh()
    for i=1, BUFF_MAX_DISPLAY do
        SBuff_AuraButton_Update("BuffButton", i, "HELPFUL")
    end
    for i=1, DEBUFF_MAX_DISPLAY do
        SBuff_AuraButton_Update("DebuffButton", i, "HARMFUL")
    end
    return true
end
CoreOnEvent("PLAYER_ENTERING_WORLD", SBuff_Refresh, true)

hooksecurefunc("AuraButton_UpdateDuration", function(...)
    if private.cfg_showsec then
        SBuff_AuraButton_UpdateDuration(...)
    end
end)

hooksecurefunc("AuraButton_Update", function(...)
    if private.cfg_showna then
        SBuff_AuraButton_Update(...)
    end
end)
