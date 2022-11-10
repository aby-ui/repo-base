--AuraFrameTemplate.AuraContainer OnLoad self.auraPool:CreatePool("BUTTON", self.AuraContainer, self.auraTemplate);
--UNIT_AURA -> 先再BuffFrame.UpdateAuras()生成auraInfos(实际UpdatePlayerBuffs), 再BuffFrame.UpdateAuraButtons创建按钮, 再UpdateGridLayout布局

--为了把CPU分到插件里
local _ADDONNAME, private = ...
_G[_ADDONNAME] = private

local _G, floor = _G, floor
local U1GetCfgValue, n2s = U1GetCfgValue, n2s

local function SBuff_SecondsToTimeAbbrev(seconds)
    local m,s,d,h;
    if(seconds > 60*60*24*3) then
        d = floor(seconds / 60 / 60 / 24)
        return "|cffffd100"..n2s(d).."d|r" --3天以上显示3d
    --elseif(seconds > 60*60*24) then
    --    d = floor(seconds / 60 / 60 / 24)
    --    h = floor(seconds % (60*60*24) / 60 / 60)
    --    return "|cffffd100"..n2s(d).."d"..n2s(h, 2).."h|r" --24小时以上显示1d1h
    elseif(seconds > 60*180) then
        h = floor(seconds / 60 / 60)
        return "|cffffd100"..n2s(h)..'h|r' --3h 180m 3小时以上显示 71h
    elseif (private.cfg_showsec_10 and seconds >= 600) or seconds > 6000 then
        m = floor( seconds / 60 )
        return "|cffffd100"..n2s(m)..'m|r' --10分钟以上或者100分钟以上不显示秒
    elseif ( seconds >= 60) then
        m = floor(seconds / 60);
        s = floor(seconds - m*60);
        return "|cff00ff00"..n2s(m)..":"..n2s(s, 2) .. '|r'
    elseif ( seconds > 0 ) then
        return "|cffffffff0:"..n2s(floor(seconds), 2) .. '|r' --红色录像看不清，改白色
	else
	    return ""
    end
end

local function updateAll(buttons, func)
    for _, btn in ipairs(buttons) do
        func(btn, btn.buttonInfo)
    end
end

--- 初始化和编辑模式修改布局时调用
local updateWidthAndPoint = function(btn)
    local d = btn.aby_duration
    d:SetSize(max(100, btn.duration:GetWidth()), 10) --高度无所谓, 靠SetJustifyH
    local point, obj, rel, x, y = btn.duration:GetPoint(1)
    d:ClearAllPoints()
    if point == "BOTTOM" then y = (y or 0) + 1 end --底部有点太紧
    d:SetPoint(point, obj, rel, x, y)
    d:SetJustifyV(point) --Point TOP, Justify TOP
    local text = d:GetText() d:SetText("") d:SetText(text) --强制重新渲染位置
end

--- 初始化和改变字体大小时调用
local function updateFontAlpha(btn)
    local size = U1GetCfgValue(_ADDONNAME, 'cvar_buffDurations/buffSize')
    local outline = U1GetCfgValue(_ADDONNAME, 'cvar_buffDurations/outline')
    local fontfile, _, _ = btn.aby_duration:GetFont()
    btn.aby_duration:SetFont(fontfile, size, outline and "THINOUTLINE" or "")
    btn.aby_duration:SetShadowColor(0,0,0,outline and 0 or 1)
    btn.aby_duration:SetShadowOffset(1, -1)
    if private.cfg_show then
        btn.aby_duration:SetAlpha(private.cfg_showsec and 1 or 0)
        btn.duration:SetAlpha(private.cfg_showsec and 0 or 1) --btn.duration.SetFormattedText = noop --也可以noop, 因为secure调用, 所以不会污染
    else
        btn.aby_duration:SetAlpha(0)
    end
end

local NA_STRING = "|cff00ff00N/A|r"
local NA_buttonInfo = { duration = 0 }

--- 精确到秒, 10分钟以上是否显示秒
local function updateDurationWithSeconds(self, timeLeft)
    local duration = self.aby_duration;
    if timeLeft and private.cfg_show and private.cfg_showsec then
        duration:SetText(SBuff_SecondsToTimeAbbrev(timeLeft));
    else
        duration:SetText("");
    end
end

--- 没有的时候显示N/A
local function updateExpirationTimeToNA(self, buttonInfo)
    if buttonInfo and buttonInfo.duration == 0 then
        if private.cfg_show then
            --非showsec的时候显示在默认数字上
            local str = private.cfg_showna and NA_STRING or ""
            if private.cfg_showsec then
                self.aby_duration:SetText(str)
            else
                self.duration:SetText(str)
                if str ~= "" then self.duration:Show() end
            end
        else
            if not private.cfg_showsec then
                self.duration:Hide()
            end
        end
    end
end

--- 编辑模式的示例
local function updateEditModeExample(btn)
    local text = (btn.duration:GetText() or ""):match("%d+")

    local n = tonumber(text or 1) or 1
    n = n - 3

    local d = btn.aby_duration
    if n < 0 then
        return updateExpirationTimeToNA(btn, NA_buttonInfo)
    end

    local timeLeft
    if n < 4 then
        timeLeft = 40*n + random(10) - 1 --5 45 85 125 sec
    elseif n < 8 then
        timeLeft = (13+60*(n-4))*60 + random(60) - 1 --13m 73m 133m 193m
    else
        timeLeft = ((7+50*(n-8))*60) * 60 + random(3600) - 1 --7h, 57h, 107h
    end
    d:SetText(SBuff_SecondsToTimeAbbrev(timeLeft))
end

local allAuras, allExamples = {}, {}

local function hookPoolAcquireAuraButton(btn, frameType, template)
    if template == "DeadlyDebuffFrame" then
        return
    end

    btn.aby_duration = btn:CreateFontString(nil, "BACKGROUND")
    btn.aby_duration:SetFont(btn.duration:GetFont())
    updateFontAlpha(btn)
    updateWidthAndPoint(btn)

    hooksecurefunc(btn.duration, "SetPoint", function(self) updateWidthAndPoint(self:GetParent()) end)

    if template ~= "ExampleAuraTemplate"  and template ~= "ExampleDebuffTemplate" then
        tinsert(allAuras, btn)
        hooksecurefunc(btn, "UpdateDuration", updateDurationWithSeconds)
        hooksecurefunc(btn, "UpdateExpirationTime", updateExpirationTimeToNA)
        updateExpirationTimeToNA(btn, btn.buttonInfo)

    else
        --only initialize once, no need to hook, but remember to update format
        tinsert(allExamples, btn)
        updateEditModeExample(btn)
    end
end

CoreUIHookPoolCollection(BuffFrame.auraPool, hookPoolAcquireAuraButton)
CoreUIHookPoolCollection(DebuffFrame.auraPool, hookPoolAcquireAuraButton)
hooksecurefunc(BuffFrame, "OnEditModeEnter", function()
    for _, btn in ipairs(allExamples) do
        updateEditModeExample(btn)
    end
end)

function private:UpdateConfig()
    updateAll(allAuras, updateFontAlpha)
    updateAll(allExamples, updateFontAlpha)
    updateAll(allAuras, updateExpirationTimeToNA)
    updateAll(allExamples, updateEditModeExample)
end