------------------------------------------------------------------------------------------
-- CastDelayBar - ver 1.0
-- 作者: dugu
-- 日期: 2010年3月13日
-- 描述: 在系统的施法条上增加一条延迟条, 用以辅助判断施法是否完成
-- 版权所有 (c) duowan.com
-------------------------------------------------------------------------------------------

CastDelayBar = LibStub("AceAddon-3.0"):NewAddon("CastDelayBar", "AceEvent-3.0", "AceHook-3.0");
local C = CastDelayBar;
C.enable = true;
C.showremain = true;

local CHANNELDELAY = "|cffff2020%-.2f|r"
local CASTDELAY = "|cffff2020%.1f|r"
local CASTCURR = "|cffFFFFFF%.1f|r"
local CASTMAX = "|cffFFFFFF%.1f|r"
local CASTMAX_NO_DECIMAL = "|cffFFFFFF%d|r"

function C:OnInitialize()	
	self.playerName = UnitName("player");
	self.delayText = PlayerCastingBarFrame:CreateFontString(nil, "ARTWORK");
	--self.delayText:SetPoint("LEFT", PlayerCastingBarFrame, "RIGHT", -22, -11);
	self.delayText:SetFont(GameFontHighlight:GetFont(), 13, "");
	self.delayText:SetShadowColor(0,0,0,1)
	self.delayText:SetShadowOffset(1,-1)

	self.delayBar = PlayerCastingBarFrame:CreateTexture("StatusBar");
	self.delayBar:SetDrawLayer("ARTWORK", 2)
	self.delayBar:SetHeight(PlayerCastingBarFrame:GetHeight()-2);
	self.delayBar:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
	self.delayBar:SetVertexColor(1, 0, 0, 0.5)
	self.delayBar:Hide()
    SetOrHookScript(PlayerCastingBarFrame, "OnUpdate", function(...)
        self:PlayerCastingBarFrame_OnUpdate(...)
    end);
end

function C:Toggle(switch)
	if (switch) then
        self:RegisterEvent("CURRENT_SPELL_CAST_CHANGED"); --self:RegisterEvent("UNIT_SPELLCAST_SENT"); --7.0 SENT 和 START 相同
		self:RegisterEvent("UNIT_SPELLCAST_START");
		self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");		
		self:RegisterEvent("UNIT_SPELLCAST_DELAYED");
		self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
		self:RegisterEvent("UNIT_SPELLCAST_FAILED");
		self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
        self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
		self:RegisterEvent("UNIT_SPELLCAST_STOP", "SpellOther");
		self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", "SpellOther");
		self:RegisterEvent("UI_ERROR_MESSAGE");

		self.enable = true;
	else
		self:UnregisterAllEvents();
		self.delayBar:Hide();
		self.delayText:Hide();
		self.enable = false;
	end
end

-- OnXX BEGIN --
function C:UNIT_SPELLCAST_SENT(event, unit, spell, rank, target)
	if unit ~= 'player' then
		return
	end
	if target then
		self.targetName = target;
	else
		self.targetName = self.playerName;
	end

	self.sendTime = GetTime()
end

--7.0 from Quartz
function C:CURRENT_SPELL_CAST_CHANGED(event, cancelledCast)
	if not cancelledCast then
		self.sendTime = GetTime()
	end
end

local function delayCleanSendTime()
	CastDelayBar.sendTime = nil
end

function C:UNIT_SPELLCAST_SUCCEEDED(event, unit)
	if unit ~= "player" and unit ~= "vehicle" then
		return
	end
	C_Timer.After(0, delayCleanSendTime) --UNIT_SPELLCAST_SUCCEEDED后面会紧跟一个CAST_CHANGED, 所以要延迟清理
end

--7.0 for Dominos castBar
function C:GetLatency()
	local down, up, lagHome, lagWorld = GetNetStats()

	return (max(lagHome, lagWorld)) / 1000
end

function C:ShowDelayBar(maxValue)
    if (self.enable and self.showdelay and self.timeDiff and self.timeDiff > 0) then
        local modulus = self.timeDiff / maxValue;
        if modulus > 1 then
            modulus = 1;
        elseif modulus <= 0 then
            modulus = 0.001;
        end
        self.delayBar:SetWidth((PlayerCastingBarFrame:GetWidth() - 4) * modulus);
		local point = self.casting and "RIGHT" or self.channeling and "LEFT"
		if point and point ~= self.lastPoint then
			self.delayBar:ClearAllPoints()
			self.delayBar:SetPoint(point, PlayerCastingBarFrame, point,  point=="RIGHT" and -2 or 2, 0);
			self.lastPoint = point
		end
        self.delayBar:Show();
    else
        self.delayBar:Hide()
    end
end

function C:UNIT_SPELLCAST_START(event, unit)
	if unit ~= "player" then return end
	local _, _, _,startTime, endTime = UnitCastingInfo(unit);
	self.startTime = startTime / 1000;
	self.endTime = endTime / 1000;
	self.delay = 0;
	self.casting = true;
	self.channeling = nil;
	self.fadeOut = nil;
    local maxValue = (endTime - startTime) / 1000

	--print(self.sendTime, format("%.3f", self.sendTime and (GetTime() - self.sendTime) or 0), self:GetLatency())
	if self.sendTime and self.sendTime < GetTime() - 0.6 then
		self.sendTime = nil --上次sendTime没清零的情况
	end
	self.timeDiff = self.sendTime and (GetTime() - self.sendTime) or self:GetLatency();
    self.sendTime = nil
	local castlength = endTime - startTime;
	if self.timeDiff > castlength then
		self.timeDiff = castlength
	end
    self:ShowDelayBar(maxValue)
end

--CURRENT_SPELL_CAST_CHANGED is later than UNIT_SPELLCAST_CHANNEL_START
--function C:UNIT_SPELLCAST_CHANNEL_START(event, unit)
--    RunOnNextFrame(C.UNIT_SPELLCAST_CHANNEL_START_BACKEND, C, event, unit)
--end
function C:UNIT_SPELLCAST_CHANNEL_START(event, unit)
	if unit ~= "player" then return end
	local _, _, _,startTime,endTime = UnitChannelInfo(unit);
	self.startTime = startTime / 1000;
	self.endTime = endTime / 1000;
	self.delay = 0;
	self.casting = nil;
	self.channeling = true;
	self.fadeOut = nil;	
    local maxValue = (endTime - startTime) / 1000

    self.timeDiff = self.sendTime and (GetTime() - self.sendTime) or self:GetLatency();
    self.sendTime = nil;
	local castlength = endTime - startTime;
	self.timeDiff = self.timeDiff > castlength and castlength or self.timeDiff;
    self:ShowDelayBar(maxValue)
end

function C:UNIT_SPELLCAST_DELAYED(event, unit)
	if unit ~= "player" then return end
	local oldStart = self.startTime;
	local _,text,_,startTime,endTime = UnitCastingInfo(unit);
	if not startTime then self.delay = 0 return end
	
	startTime = startTime/1000;
	endTime = endTime/1000;
	self.startTime = startTime;
	self.endTime = endTime;
	self.delay = (self.delay or 0) + (startTime - (oldStart or startTime));

end

function C:UNIT_SPELLCAST_CHANNEL_UPDATE(event, unit)
	if unit ~= "player" then return end

	local oldStart = self.startTime;
	local _, _, _, startTime, endTime = UnitChannelInfo(unit);


	if (not startTime) then self.delay = 0 return end
	startTime = startTime/1000;
	endTime = endTime/1000;
	self.startTime = startTime;
	self.endTime = endTime;

	self.delay = (self.delay or 0) + ((oldStart or startTime) - startTime);
end

function C:SpellOther(event, unit)
	if unit ~="player" then return end

    self.sendTime = nil
	if event == "UNIT_SPELLCAST_STOP" then
		if self.casting then
			self.targetName = nil;
			self.casting = nil;
			self.fadeOut = true;
			self.stopTime = GetTime();
			self.sendTime = nil
		end
	elseif (event == "UNIT_SPELLCAST_CHANNEL_STOP") then
		if self.channeling then
			self.channeling = nil;
			self.fadeOut = true;
			self.stopTime = GetTime();
			self.sendTime = nil
		end
	end
end

function C:UNIT_SPELLCAST_FAILED(event, unit)
	if unit ~= "player" or self.channeling then return end
	self.targetName = nil;
	self.casting = nil;
	self.channeling = nil;
	self.fadeOut = true;
	self.sendTime = nil;
	if (not self.stopTime) then
		self.stopTime = GetTime();
	end
end

function C:UNIT_SPELLCAST_INTERRUPTED(event, unit)
	if unit ~= "player" then return end
	self.targetName = nil;
	self.casting = nil;
	self.channeling = nil;
	self.fadeOut = true;
	self.sendTime = nil;
	if (not self.stopTime) then
		self.stopTime = GetTime();
	end
end

function C:UI_ERROR_MESSAGE(event, messageType, message)
	if messageType and GetGameMessageInfo(messageType) == "ERR_SPELL_FAILED_S" then
		C:UNIT_SPELLCAST_INTERRUPTED(event, "player")
	end
end
----- END  ----

function C:PlayerCastingBarFrame_OnUpdate(frame, elapsed, ...)
	if frame.unit ~= "player" then return end
    if not (self.casting or self.channeling) then
        self.delayText:Hide()
        return
    end

	local currentTime = GetTime();
	local startTime = self.startTime;
	local endTime = self.endTime;
	local timeLeft,finishTime;
	local diff = self.timeDiff --表示已经施法但得到开始事件晚了
	if(endTime and startTime and diff)then
		finishTime = endTime - startTime - diff
		timeLeft = currentTime - startTime - diff;
		if (timeLeft < 0) then
			timeLeft = 0;
		end

		local castTime = finishTime - timeLeft;
		local duration = endTime - startTime;

		if (self.showremain) then
			-- 倒数计时
			if(castTime > 0)then
				self.delayText:SetText(format(CASTCURR, castTime))
			end
            self.delayText:Show()
		else
			-- 正计时
			local max_format = duration >= 10 and CASTMAX_NO_DECIMAL or CASTMAX
			if(castTime > 0)then
				self.delayText:SetText(format(CASTCURR.."/"..max_format, timeLeft, duration))
			else
				self.delayText:SetText(format(CASTCURR.."/"..max_format, timeLeft, duration));
            end
            self.delayText:Show()
		end
	end
	if (self.casting) then
		if (currentTime > endTime) then
			self.casting = nil;
			self.fadeOut = true;
			self.stopTime = currentTime;
			self.sendTime = nil;
			return;
		end
	else --if(self.channeling) then
		if (currentTime > endTime) then
			self.channeling = nil
			self.fadeOut = true
			self.stopTime = currentTime;
			self.sendTime = nil;
			return;
		end		
	end
end