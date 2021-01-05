local Factory, _, T = {}, ...
local C = C_Garrison
local PROGRESS_MIN_STEP = 0.2
local CovenKit = "NightFae"
local currencyMeterFrame

local function CreateObject(otype, ...)
	return assert(Factory[otype], otype)(...)
end
T.CreateObject = CreateObject

local function Mirror(tex, swapH, swapV)
	local ulX, ulY, llX, llY, urX, urY, lrX, lrY = tex:GetTexCoord()
	if swapH then
		ulX, ulY, llX, llY, urX, urY, lrX, lrY = urX, urY, lrX, lrY, ulX, ulY, llX, llY
	end
	if swapV then
		ulX, ulY, llX, llY, urX, urY, lrX, lrY = llX, llY, ulX, ulY, lrX, lrY, urX, urY
	end
	tex:SetTexCoord(ulX, ulY, llX, llY, urX, urY, lrX, lrY)
	return tex
end

local function HideOwnGameTooltip(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end
local function GetTimeStringFromSeconds(sec, shorter, roundUp, disallowSeconds)
	local h = roundUp and math.ceil or math.floor
	if sec < 90 and not disallowSeconds then
		return (shorter and COOLDOWN_DURATION_SEC or INT_GENERAL_DURATION_SEC):format(sec < 0 and 0 or h(sec))
	elseif (sec < 3600*(shorter and 3 or 1) and (sec % 3600 >= 1)) then
		return (shorter and COOLDOWN_DURATION_MIN or INT_GENERAL_DURATION_MIN):format(h(sec/60))
	elseif sec <= 3600*72 and not shorter then
		sec = h(sec/60)*60
		local m = math.ceil(sec % 3600 / 60)
		return INT_GENERAL_DURATION_HOURS:format(math.floor(sec / 3600)) .. (m > 0 and " " .. INT_GENERAL_DURATION_MIN:format(m) or "")
	elseif sec <= 3600*72 then
		return (shorter and COOLDOWN_DURATION_HOURS or INT_GENERAL_DURATION_HOURS):format(h(sec/3600))
	else
		return (shorter and COOLDOWN_DURATION_DAYS or INT_GENERAL_DURATION_DAYS):format(h(sec/84600))
	end
end
local function CommonTooltip_OnEnter(self)
	local showCurrencyBar = false
	GameTooltip:SetOwner(self, self.tooltipAnchor or "ANCHOR_TOP")
	if type(self.mechanicInfo) == "table" then
		local ic, m = self.Icon and self.Icon:GetTexture(), self.mechanicInfo
		ic = ic or m.icon
		GameTooltip:SetText((ic and "|T" .. ic .. ":0:0:0:0:64:64:4:60:4:60|t " or "") .. m.name)
		if (m.enemy or "") ~= "" then
			GameTooltip:AddLine("|cff49C8F2" .. m.enemy)
		elseif (m.description or "") ~= "" then
			GameTooltip:AddLine(m.description, 1,1,1,1)
		end
		if type(m.ability) == "table" then
			local a = m.ability
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine((a.icon and "|T" .. a.icon .. ":0|t " or "") .. a.name)
			if (a.description or "") ~= "" then
				GameTooltip:AddLine(a.description, 1,1,1,1)
			end
		end
	elseif self.itemLink then
		GameTooltip:SetHyperlink(self.itemLink)
	elseif self.itemID then
		GameTooltip:SetItemByID(self.itemID)
	elseif self.tooltipHeader and self.tooltipText then
		GameTooltip:AddLine(self.tooltipHeader)
		GameTooltip:AddLine(self.tooltipText, 1,1,1, 1)
		showCurrencyBar = not not (self.currencyID)
	elseif self.currencyID then
		GameTooltip:SetCurrencyByID(self.currencyID)
		if self.currencyID == 1889 then
			GameTooltip:AddLine("|n当前进度:" .. "|cffffffff" .. C_CurrencyInfo.GetCurrencyInfo(self.currencyID).quantity)
			GameTooltip:Show()
		end
	elseif self.achievementID then
		local self, achievementID, highlightAsset = GameTooltip, self.achievementID, self.assetID
		local _, n, _points, c, _, _, _, description, _, _icon, _, _, wasEarnedByMe, _earnedBy =
			GetAchievementInfo(achievementID)
		self:SetText(n)
		if not c or not wasEarnedByMe then
			self:AddLine(ACHIEVEMENT_TOOLTIP_IN_PROGRESS:format(UnitName("player")), 0.1, 0.9, 0.1)
			self:AddLine(" ")
		end
		self:AddLine(description, 1,1,1,1)
		local nc = GetAchievementNumCriteria(achievementID)
		for i=1,nc,2 do
			local n1, _, c1, _, _, _, _, asid = GetAchievementCriteriaInfo(achievementID, i)
			n1 = (asid == highlightAsset and "|cffffea00" or c1 and "|cff20c020" or "|cffa8a8a8") .. n1
			if i == nc then
				self:AddLine(n1)
			else
				local n2, _, c2, _, _, _, _, asid = GetAchievementCriteriaInfo(achievementID, i+1)
				n2 = (asid == highlightAsset and "|cffffea00" or c2 and "|cff20c020" or "|cffa8a8a8") .. n2
				self:AddDoubleLine(n1, n2)
			end
		end
	else
		GameTooltip:Hide()
		return
	end
	if self.ShowQuantityFromWidgetText then
		local w = self[self.ShowQuantityFromWidgetText]
		local t = w and w:GetText() or ""
		local c = NORMAL_FONT_COLOR
		if t ~= "" then
			GameTooltip:AddLine("数量:" .. " |cffffffff" .. t, c.r, c.g, c.b)
		end
	end
	if self.tooltipExtra then
		GameTooltip:AddLine(self.tooltipExtra, 1,1,1)
	end
	GameTooltip:Show()
	if showCurrencyBar then
		currencyMeterFrame = currencyMeterFrame or CreateObject("CurrencyMeter")
		currencyMeterFrame:Activate(GameTooltip, self.currencyID, self.currencyQ)
	end
end
local function CommonLinkable_OnClick(self)
	if self.itemLink then
		HandleModifiedItemClick(self.itemLink)
	elseif not IsModifiedClick("CHATLINK") then
	elseif self.achievementID then
		ChatEdit_InsertLink(GetAchievementLink(self.achievementID))
	elseif self.itemID then
		local _, link = GetItemInfo(self.itemID)
		if link then
			ChatEdit_InsertLink(link)
		end
	elseif self.currencyID and self.currencyID ~= 0 then
		ChatEdit_InsertLink(C_CurrencyInfo.GetCurrencyLink(self.currencyID, self.currencyAmount or 0))
	end
end
local function MissionList_ScrollToward(self, obj)
	if obj:GetBottom() < self:GetBottom() then
		self:GetScript("OnMouseWheel")(self, -1)
	elseif obj:GetTop() > self:GetTop() then
		self:GetScript("OnMouseWheel")(self, 1)
	end
end
local function MissionList_SpawnMissionButton(arr, i)
	local prev = type(i) == "number" and rawget(arr, i-1)
	if type(prev) == "table" then
		local cf = CreateObject("MissionButton", prev:GetParent())
		arr[i] = cf
		cf:SetPoint("TOPLEFT", 294*(((i-1)%3)+1)-286, math.floor((i-1)/3) *- 195)
		return cf
	end
end
local function MissionButton_OnClick(self)
	if IsModifiedClick("CHATLINK") and self.missionID then
		ChatEdit_InsertLink(C.GetMissionLink(self.missionID))
	else
		if self.missionID and self.ProgressBar:IsShown() and self.completableAfter and self.completableAfter <= GetTime()
		   and self.ProgressBar:IsMouseOver(6, -6, -6, 6) then
			local mid = self.missionID
					local cm = C_Garrison.GetCompleteMissions(123)
					for i=1,#cm do
						if cm[i].missionID == mid then
							cm[i].encounterIconInfo = C_Garrison.GetMissionEncounterIconInfo(self.missionID)
							CovenantMissionFrame:InitiateMissionCompletion(cm[i])
						end
					end
		else
			self:GetParent():GetParent():ScrollToward(self)
		end
	end
end
local function Progress_UpdateTimer(self)
	local now, endTime = GetTime(), self.endTime
	if endTime <= now then
		self.Fill:SetWidth(self:GetWidth())
		self:SetScript("OnUpdate", nil)
		if self.endText then
			self.Text:SetText(self.endText)
		end
		if self.endMotion then
			self:SetMouseMotionEnabled(true)
		end
		self.endTime, self.duration, self.endText, self.nextUp = nil
	elseif (self.nextUp or 0) < now then
		local w, d = self:GetWidth(), self.duration
		local secsLeft = endTime-now
		self.Fill:SetWidth(math.max(0.01, w*(1-(endTime-now)/d)))
		self.nextUp = now + math.min(PROGRESS_MIN_STEP/w * d, 0.01 + secsLeft % (secsLeft < 100 and 1 or 60))
		if self.showTimeRemaining then
			self.Text:SetText(GetTimeStringFromSeconds(secsLeft, false, true))
		else
			self.Text:SetText("")
		end
	end
end
local function Progress_SetProgress(self, progress)
	self.Fill:SetWidth(math.max(0.01,self:GetWidth()*progress))
	self.endTime, self.duration, self.endText, self.endMotion, self.nextUp = nil
	self:SetScript("OnUpdate", nil)
end
local function Progress_SetTimer(self, endTime, duration, endText, endMotion, showTimeRemaining)
	self.endTime, self.duration, self.endText, self.endMotion, self.showTimeRemaining, self.nextUp = endTime, duration, endText, endMotion == true or nil, showTimeRemaining == true or nil, nil
	self:SetScript("OnUpdate", Progress_UpdateTimer)
	Progress_UpdateTimer(self)
end
local function CurrencyMeter_Update(self)
	local p = self:GetParent()
	local pt, sb, pw = p:GetTop(), self:GetBottom(), p:GetWidth()
	if pt and sb then
		p:SetHeight(pt-sb+8)
	end
	if pw then
		self:SetWidth(pw - 20)
	end
	self.Bar:SetProgress(self.pv)
	self.Fill2:SetWidth(self.Bar:GetWidth()*self.v2)
end
local function CurrencyMeter_Activate(self, tip, currencyID, q1)
	local factionID, cur, max, label = C_CurrencyInfo.GetFactionGrantedByCurrency(currencyID)
	if factionID then
		if C_Reputation.IsFactionParagon(factionID) then
			label, cur, max = _G["FACTION_STANDING_LABEL8" .. (UnitSex("player") ~= 2 and "_FEMALE" or "")], C_Reputation.GetFactionParagonInfo(factionID)
			cur = cur % max
		else
			local _, _, stID, bMin, bMax, bVal  = GetFactionInfoByID(factionID)
			if stID and bMin then
				cur, max, label = bVal - bMin, bMax-bMin, _G["FACTION_STANDING_LABEL" .. stID .. (UnitSex("player") ~= 2 and "_FEMALE" or "")]
			end
		end
	elseif currencyID == 1553 and not C_AzeriteItem.IsAzeriteItemAtMaxLevel() then
		local aloc = C_AzeriteItem.FindActiveAzeriteItem()
		local ok, level = pcall(C_AzeriteItem.GetPowerLevel, aloc)
		if ok and level then
			label, cur, max = HEART_OF_AZEROTH_LEVEL:format(level), C_AzeriteItem.GetAzeriteItemXPInfo(aloc)
		end
	end
	if not (cur and max) then
		return
	end
	label = label .. " - " .. BreakUpLargeNumbers(cur) .. " / " .. BreakUpLargeNumbers(max)
	self.pv = cur/max
	self.v2 = math.max(0.00001, math.min(1-self.pv, (q1 or 0)/max))
	self.Bar.Text:SetText(label)
	self.Fill2:SetAtlas((cur+ (q1 or 0)) > max and "UI-Frame-Bar-Fill-Green" or "UI-Frame-Bar-Fill-Yellow")
	self:SetParent(tip)
	local lastLine = _G[tip:GetName() .. "TextLeft" .. tip:NumLines()]
	self:SetPoint("TOPLEFT", lastLine, "BOTTOMLEFT", 0, -2)
	self:Show()
	tip:Show()
	CurrencyMeter_Update(self)
end
local function CurrencyMeter_OnHide(self)
	self:Hide()
	self:SetParent(nil)
	self:ClearAllPoints()
end
local function PlaySoundKit_OnHide(self)
	PlaySound(self.soundKitOnHide)
end

local function CountdownText_OnUpdate(self)
	local now = GetTime()
	if now >= self.cdtTick then
		local cdTo = self.cdtTo
		local secsLeft = cdTo-now
		if secsLeft <= 0 then
			self.CDTDisplay:SetText(self.cdtRest)
			self:SetScript("OnUpdate", nil)
			self.cdtTick, self.cdtTo = nil
		else
			self.cdtTick = secsLeft < 120 and (now + secsLeft % 0.5 + 0.01) or (now + secsLeft % 60 + 0.01)
			self.CDTDisplay:SetText(self.cdtPrefix .. GetTimeStringFromSeconds(secsLeft, self.cdtShort, self.cdtRoundedUp) .. self.cdtSuffix .. self.cdtRest)
		end
	end
end
local function CountdownText_SetCountdown(self, prefix, expireAt, suffix, rest, isShort, isRoundUp)
	prefix, suffix, rest = prefix or "", suffix or "", rest or ""
	local now = GetTime()
	if not (expireAt and expireAt > now) then
		self.CDTDisplay:SetText(rest or "")
		self:SetScript("OnUpdate", nil)
	else
		self.cdtTick, self.cdtPrefix, self.cdtTo, self.cdtSuffix, self.cdtRest, self.cdtShort, self.cdtRoundedUp = now, prefix, expireAt, suffix, rest, isShort == true, isRoundUp == true
		self:SetScript("OnUpdate", CountdownText_OnUpdate)
		CountdownText_OnUpdate(self)
	end
end
local function LockedInputBox_OnTextChanged(self, userInput)
	if not userInput then
		self.text = self:GetText()
	elseif self.text then
		self:SetText(self.text)
		self:SetCursorPosition(0)
		self:HighlightText()
	end
end
local function ResizedButton_SetText(self, text)
	(self.Text or self):SetText(text)
	self:SetWidth((self.Text or self):GetStringWidth()+26)
end
local function ResourceButton_Update(self, _event, currencyID)
	if currencyID == self.currencyID then
		local ci = C_CurrencyInfo.GetCurrencyInfo(currencyID)
		local quant = ci and ci.quantity
		if quant then
			self.Text:SetText(BreakUpLargeNumbers(quant))
			self:SetWidth(self.Text:GetStringWidth()+26)
		end
	end
end
local function ResourceButton_OnClick(self)
	if IsModifiedClick("CHATLINK") then
		ChatEdit_InsertLink(C_CurrencyInfo.GetCurrencyLink(self.currencyID, 42))
	end
end
local RewardButton_SetReward do
	local baseXPReward = {title="追随者经验", tooltip="如果敌人被击败。", icon="Interface/Icons/XP_Icon", qualityAtlas="loottoast-itemborder-purple"}
	function RewardButton_SetReward(self, rew, isOvermax, pw)
		if rew == "xp" then
			baseXPReward.followerXP = isOvermax
			return RewardButton_SetReward(self, baseXPReward)
		end
		self:SetShown(not not rew)
		if not rew then
			return
		end
		local q, tooltipTitle, tooltipText, cq = rew.quantity, rew.title
		if rew.icon then
			self.Icon:SetTexture(rew.icon)
		elseif rew.itemID then
			self.Icon:SetTexture(GetItemIcon(rew.itemID))
		end
		if rew.currencyID then
			self.RarityBorder:SetAtlas("loottoast-itemborder-gold")
			if rew.currencyID == 0 then
				q = math.floor(rew.quantity / 1e4)
				tooltipText = GetMoneyString(rew.quantity)
			else
				local ci = C_CurrencyInfo.GetCurrencyContainerInfo(rew.currencyID, rew.quantity)
				if ci then
					self.Icon:SetTexture(ci.icon)
					tooltipTitle = (ci.quality and "|c" .. (select(4,GetItemQualityColor(ci.quality)) or "ff00ffff") or "") .. ci.name
					tooltipText = NORMAL_FONT_COLOR_CODE .. (ci.description or "")
					local lb = LOOT_BORDER_BY_QUALITY[ci.quality]
					if lb then
						self.RarityBorder:SetAtlas(lb)
					end
				end
				if rew.currencyID == 1828 then
					self.RarityBorder:SetAtlas("loottoast-itemborder-orange")
				end
				cq = (isOvermax and pw and pw.currencyID == rew.currencyID and pw.currencyQ or 0) + q
			end
		elseif rew.itemID then
			q = rew.quantity == 1 and "" or rew.quantity or ""
			local _,_,r = GetItemInfo(rew.itemID)
			self.RarityBorder:SetAtlas(
				((r or 2) <= 2) and "loottoast-itemborder-green"
				or r == 3 and "loottoast-itemborder-blue"
				or r == 4 and "loottoast-itemborder-purple"
				or "loottoast-itemborder-orange"
			)
		elseif rew.followerXP then
			q, tooltipTitle, tooltipText = BreakUpLargeNumbers(rew.followerXP), rew.title, rew.tooltip
			self.RarityBorder:SetAtlas(rew.qualityAtlas or "loottoast-itemborder-green")
		end
		local overfullText = isOvermax and "|cffff8000" .. "Bonus roll reward" .. "|r" or nil
		self.OvermaxRewardIcon:SetShown(isOvermax)
		self.currencyID, self.currencyAmount, self.currencyQ = rew.currencyID, rew.quantity, cq
		self.itemID, self.itemLink = rew.itemID, rew.itemLink
		self.tooltipExtra, self.tooltipHeader, self.tooltipText = overfullText, tooltipTitle, tooltipText
		self.Quantity:SetText(q == 1 and "" or q or "")
	end
end

do -- Factory.ObjectGroup
	local NamedMethodCallCache = setmetatable({}, {__index=function(t,k)
		t[k] = function(self, ...)
			for i=1,#self do
				local o = self[i]
				securecall(o[k], o, ...)
			end
		end
		return t[k]
	end})
	local ObjectGroup_Meta = {__index=function(t,k)
		if type(k) == "string" and type(t[1]) == "table" and type(t[1][k]) == "function" then
			t[k] = NamedMethodCallCache[k]
			return t[k]
		end
	end}
	function Factory.ObjectGroup(...)
		return setmetatable({...}, ObjectGroup_Meta)
	end
end

function Factory.RaisedBorder(parent)
	local border = CreateFrame("Frame", nil, parent)
	border:SetPoint("TOPLEFT", 0, 8)
	border:SetPoint("BOTTOMRIGHT", 0, -4)
	do
		local t = border:CreateTexture(nil, "BACKGROUND")
		t:SetPoint("TOPLEFT", 0, 2)
		t:SetPoint("TOPRIGHT", 0, 2)
		t:SetHeight(12)
		t:SetTexture("Interface/Garrison/AdventureMissionsFrameHorizontal")
		t:SetTexCoord(0,1, 67/128, 79/128)
		t = border:CreateTexture(nil, "BACKGROUND")
		t:SetPoint("BOTTOMLEFT", 0, -2)
		t:SetPoint("BOTTOMRIGHT", 0, -2)
		t:SetHeight(12)
		t:SetTexture("Interface/Garrison/AdventureMissionsFrameHorizontal")
		t:SetTexCoord(0,1, 79/128, 67/128)
		t = border:CreateTexture(nil, "BACKGROUND")
		t:SetPoint("TOPLEFT", -1, 0)
		t:SetPoint("BOTTOMLEFT", -1, 0)
		t:SetWidth(12)
		t:SetTexture("Interface/Garrison/AdventureMissionsFrameVert")
		t:SetTexCoord(85/128, 97/128, 0, 1)
		t = border:CreateTexture(nil, "BACKGROUND")
		t:SetPoint("TOPRIGHT", 1, 0)
		t:SetPoint("BOTTOMRIGHT", 1, 0)
		t:SetWidth(12)
		t:SetTexture("Interface/Garrison/AdventureMissionsFrameVert")
		t:SetTexCoord(67/128, 79/128, 0, 1)
		t = border:CreateTexture(nil, "BACKGROUND", nil, 1)
		t:SetSize(42, 42)
		t:SetPoint("TOPLEFT")
		t:SetTexture("Interface/Garrison/AdventureMissionsFrame")
		t:SetTexCoord(650/1024, 688/1024, 1119/2048, 1158/2048)
		t = border:CreateTexture(nil, "BACKGROUND", nil, 1)
		t:SetSize(42, 42)
		t:SetPoint("TOPRIGHT")
		t:SetTexture("Interface/Garrison/AdventureMissionsFrame")
		t:SetTexCoord(650/1024, 688/1024, 1119/2048, 1158/2048)
		Mirror(t, true, false)
		t = border:CreateTexture(nil, "BACKGROUND", nil, 1)
		t:SetSize(42, 42)
		t:SetPoint("BOTTOMLEFT")
		t:SetTexture("Interface/Garrison/AdventureMissionsFrame")
		t:SetTexCoord(650/1024, 688/1024, 1119/2048, 1158/2048)
		Mirror(t, false, true)
		t = border:CreateTexture(nil, "BACKGROUND", nil, 1)
		t:SetSize(42, 42)
		t:SetPoint("BOTTOMRIGHT")
		t:SetTexture("Interface/Garrison/AdventureMissionsFrame")
		t:SetTexCoord(650/1024, 688/1024, 1119/2048, 1158/2048)
		Mirror(t, true, true)
		t = parent:CreateTexture(nil, "BACKGROUND", nil, -2)
		t:SetTexture("Interface/FrameGeneral/UIFrame"..CovenKit.."Background", true, true)
		t:SetHorizTile(true)
		t:SetVertTile(true)
		t:SetAllPoints(border)
		t:SetVertexColor(0.95, 0.95, 0.95)
		t = parent:CreateTexture(nil, "BACKGROUND", nil, -1)
		t:SetAtlas("Adventures-Missions-Shadow")
		t:SetAllPoints(border)
		t:SetAlpha(0.45)
	end
end
function Factory.LockedCopyInputBox(parent)
	local f = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
	f:SetHighlightColor(1,0.8,0.3, 0.6)
	f:SetScript("OnEscapePressed", f.ClearFocus)
	f:SetScript("OnTextChanged", LockedInputBox_OnTextChanged)
	f:SetAutoFocus(false)
	f:SetSize(250, 20)
	return f
end
function Factory.CopyBoxUI(parent)
	local f = CreateFrame("Frame", nil, parent)
	f:SetSize(335, 310)
	f:SetFrameLevel(600)
	f:SetPoint("CENTER")
	local fbg = CreateFrame("Button", nil, f)
	fbg:SetAllPoints(parent)
	fbg:SetScript("OnMouseWheel", function() end)
	fbg:SetScript("OnClick", function() if not f:IsMouseOver(0, 0, -10, 10) then f:Hide() end end)
	fbg:RegisterForClicks("AnyUp")
	fbg:EnableMouse(true)
	fbg:SetFrameLevel(500)
	local t = fbg:CreateTexture(nil, "BACKGROUND")
	t:SetColorTexture(0,0,0,0.9)
	t:SetAllPoints()
	t = f:CreateTexture(nil, "BACKGROUND")
	t:SetAtlas("UI-Frame-"..CovenKit.."-CardParchmentWider")
	t:SetAllPoints()
	t = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge2")
	t:SetText("Moonkittens for sale")
	t:SetPoint("TOP", 0, -34)
	t, f.Title = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium"), t
	t:SetWidth(270)
	t:SetPoint("TOP", f.Title, "BOTTOM", 0, -10)
	t:SetJustifyH("LEFT")
	t:SetTextColor(0.1, 0.1, 0.1)
	t:SetText("These adorable rascals are guaranteed to moonfire literally everything around them.");
	t, f.Intro = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium"), t
	t:SetWidth(270)
	t:SetJustifyH("LEFT")
	t:SetText("1. Moonfire.")
	t:SetTextColor(0.1, 0.1, 0.1)
	local ub = CreateObject("LockedCopyInputBox", f)
	ub:SetPoint("TOP",0,-170)
	ub:SetText("Very moon,")
	ub:SetTextColor(0.25, 0.75, 1)
	t:SetPoint("BOTTOM", ub, "TOP", 0, 6)
	f.FirstInputBox = ub
	f.FirstInputBoxLabel = t
	
	local cb = CreateObject("LockedCopyInputBox", f)
	cb:SetPoint("TOP",0, -220)
	cb:SetText("Much fire!")
	f.SecondInputBox = cb
	t = f:CreateFontString(nil, "OVERLAY", "GameFontBlackMedium")
	t:SetWidth(270)
	t:SetJustifyH("LEFT")
	t:SetPoint("BOTTOM", cb, "TOP", 0, 6)
	t:SetText("2. Kittens.")
	t:SetTextColor(0.1, 0.1, 0.1)
	f.SecondInputBoxLabel = t
	
	f:SetScript("OnKeyDown", function(self, key)
		f:SetPropagateKeyboardInput(key ~= "ESCAPE")
		if key == "ESCAPE" then
			self:Hide()
		end
	end)
	
	t = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	t:SetPoint("BOTTOM", 0, 30)
	t:SetWidth(200)
	t:SetText("Reset")
	f.ResetButton = t
	t = CreateFrame("Button", nil, f, "UIPanelCloseButtonNoScripts")
	t:SetPoint("TOPRIGHT", -8, -8)
	t:SetScript("OnClick", function()
		f:Hide()
	end)
	f.CloseButton2 = t
	
	f.soundKitOnHide = 170568
	f:SetScript("OnHide", PlaySoundKit_OnHide)
	
	return f
end
function Factory.MissionPage(parent)
	local f = CreateFrame("Frame", nil, parent)
	f:SetAllPoints()
	f.MissionList = CreateObject("MissionList", f)
	f.CopyBox = CreateObject("CopyBoxUI", f)
	f.CopyBox:Hide()
	local resButton = CreateObject("ResourceButton", f, 1813) do
		f.ResourceCounter = resButton
		resButton:SetPoint("TOPRIGHT", -72, -30)
		CreateObject("ControlContainerBorder", resButton, 15, 9)
	end
	local prButton = CreateObject("ResourceButton", f, 1889) do
		f.ProgressCounter = prButton
		prButton:SetPoint("RIGHT", resButton, "LEFT", -35, 0)
		CreateObject("ControlContainerBorder", prButton, 15, 9)
	end
	local logsButton = CreateObject("LogBookButton", f, 1889) do
		f.LogCounter = logsButton
		logsButton:SetPoint("RIGHT", prButton, "LEFT", -35, 0)
		CreateObject("ControlContainerBorder", logsButton, 15, 9)
	end
	
	return f, f.MissionList
end
function Factory.MissionList(parent)
	local coven = C_Covenants.GetCovenantData(C_Covenants.GetActiveCovenantID() or 1)
	CovenKit = coven and coven.textureKit or "NightFae"
	
	local mf = parent
	local missionList = CreateFrame("ScrollFrame", nil, parent)
	missionList:SetSize(892, 524)
	missionList:SetPoint("TOP", 0, -72)
	missionList:EnableMouseWheel(true)
	missionList.ScrollToward = MissionList_ScrollToward
	CreateObject("RaisedBorder", missionList)
	do -- missionList:OnMouseWheel
		local v = CreateFrame("Frame", nil, mf)
		v:SetAllPoints(missionList)
		v:EnableMouse(true)
		v:SetFrameLevel(mf:GetFrameLevel()+20)
		v:Hide()
		missionList.ScrollVeil = v
		local function scrollFinish(self)
			self:GetScrollChild():SetPoint("TOPLEFT", 0, self.scrollEnd)
			self.scrollStart, self.scrollEnd, self.scrollTimeStart, self.scrollTimeEnd, self.scrollSpeed, self.scrollLast = nil
			self:SetScript("OnUpdate", nil)
			self:SetScript("OnHide", nil)
			self.ScrollVeil:Hide()
		end
		local function scrollOnUpdate(self)
			local a, b, s, t = self.scrollStart, self.scrollEnd, self.scrollTimeStart, self.scrollTimeEnd
			local sc, c = self:GetScrollChild(), GetTime()
			if c >= t then
				scrollFinish(self)
			else
				local p = a + (b-a)*(c-s)/(t-s)
				sc:SetPoint("TOPLEFT", 0, p)
				self.scrollLastTime, self.scrollLastOffset = c, s
			end
		end
		missionList:SetScript("OnMouseWheel", function(self, d)
			local scrollChild = self:GetScrollChild()
			local _, _, _, _, y = scrollChild:GetPoint()
			local snap = math.min(math.max(0, (self.scrollSnap or 0) - d), math.floor(((self.numMissions or 0)-1)/3)-1)
			local dy = snap == 0 and 0 or (195*snap-30)
			if self.scrollEnd ~= dy then
				local ct = GetTime()
				self.scrollSnap, self.scrollStart, self.scrollEnd, self.scrollTimeStart, self.scrollTimeEnd = snap, y, dy, ct, ct + 0.20
				self:SetScript("OnUpdate", scrollOnUpdate)
				self:SetScript("OnHide", scrollFinish)
				self.ScrollVeil:Show()
			end
		end)
		function missionList:ReturnToTop()
			self.scrollSnap, self.scrollEnd = 0, 0
			scrollFinish(self)
		end
	end
	local scrollChild = CreateFrame("Frame", nil, missionList)
	scrollChild:SetPoint("TOPLEFT")
	scrollChild:SetSize(902,missionList:GetHeight())
	missionList:SetScrollChild(scrollChild)
	missionList.Missions = setmetatable({}, {__index=MissionList_SpawnMissionButton})
	for i=1,6 do
		local cf = CreateObject("MissionButton", scrollChild)
		missionList.Missions[i] = cf
		cf:SetPoint("TOPLEFT", 292*(((i-1)%3)+1)-284, math.floor((i-1)/3) *- 195)
	end
	
	return missionList
end
function Factory.MissionButton(parent)
	local cf, t = CreateFrame("Button", nil, parent)
	cf:SetSize(290, 190)
	cf:SetScript("OnClick", MissionButton_OnClick)
	t = cf:CreateTexture(nil, "BACKGROUND", nil, -2)
	t:SetAtlas("UI-Frame-"..CovenKit.."-CardParchmentWider")
	t:SetPoint("TOPLEFT", 0, -24)
	t:SetPoint("BOTTOMRIGHT", 0, 0)
	Mirror(t, true)
	t = cf:CreateTexture(nil, "ARTWORK", nil, -6)
	t:SetAtlas("UI-Frame-"..CovenKit.."-CardParchmentWider")
	t:SetPoint("TOPLEFT", 0, -24)
	t:SetPoint("BOTTOMRIGHT", 0, 0)
	t:SetVertexColor(0.30, 0.30, 0.40, 0.60)
	Mirror(t, true)
	t, cf.Veil = cf:CreateFontString(nil, "BACKGROUND", "GameFontHighlightLarge"), t
	t:SetText("Goats' Goat Goat")
	t:SetPoint("TOP", 0, -54)
	t:SetWidth(276)
	t:SetTextColor(0.97, 0.94, 0.70)
	t, cf.Name = cf:CreateTexture(nil, "BACKGROUND", nil, 2), t
	t:SetAtlas("Campaign-QuestLog-LoreDivider")
	local divC = CovenKit == "Kyrian" and 0xfeb0a0 or CovenKit == "Venthyr" and 0xfe40f0 or CovenKit == "Necrolord" and 0xc0fe00 or 0x4080fe
	t:SetVertexColor(divC / 2^24, divC/256 % 256 / 255, divC%256/255)
	t:SetWidth(286)
	t:SetPoint("TOP", cf.Name, 0, 6)
	t:SetPoint("BOTTOM", cf.Name, "BOTTOM", 0, -3)
	t = cf:CreateFontString(nil, "OVERLAY", "GameFontBlack")
	t:SetWidth(262)
	t:SetPoint("TOP", cf.Name, "BOTTOM", 0, -26)
	t:SetText("There is no cow level. Our forces, however, have discovered a goat level. Perhaps there's even epic goat loot? You should go rescue the goats. Who knows what would happen if the Horde got there first.")
	t, cf.Description = cf:CreateFontString(nil, "OVERLAY", "GameFontBlack"), t
	t:SetPoint("BOTTOMLEFT", cf, 14, 16)
	t:SetText("Expired")
	cf.ExpireTime = t
	CreateObject("CountdownText", cf, t)

	t = CreateFrame("Frame", nil, cf)
	t:SetPoint("TOP", 0, -4)
	t:SetSize(104, 48)
	cf.Rewards = {Container=t}
	for j=1,3 do
		local rew = CreateObject("RewardFrame", t)
		rew:SetPoint("LEFT", 52*j-52, 0)
		cf.Rewards[j] = rew
	end
	t = CreateObject("AchievementRewardIcon", cf)
	t:SetPoint("RIGHT", cf, "TOPRIGHT", -20, -40)
	cf.AchievementReward = t

	t = CreateFrame("Frame", nil, cf)
	t:SetPoint("TOP", cf.Name, "BOTTOM", 0, -4)
	t:SetSize(224, 20)
	local a, b = cf:CreateTexture(nil, "BACKGROUND", nil, 2)
	a:SetAtlas("ui_adv_health", true)
	a:SetPoint("LEFT", t, "LEFT", -6, 0)
	b = t:CreateFontString(nil, "OVERLAY", "GameFontBlack")
	b:SetPoint("LEFT", a, "RIGHT", -2, 0)
	b:SetText("244,242")
	a, cf.enemyHP = cf:CreateTexture(nil, "BACKGROUND", nil, 2), b
	a:SetAtlas("ui_adv_atk", true)
	a:SetPoint("LEFT", b, "RIGHT", 0, 0)
	b = t:CreateFontString(nil, "OVERLAY", "GameFontBlack")
	b:SetPoint("LEFT", a, "RIGHT", -2, 0)
	b:SetText("244,242")
	a, cf.enemyATK = cf:CreateTexture(nil, "BACKGROUND", nil, 2), b
	a:SetAtlas("animachannel-bar-" .. CovenKit .. "-gem", true)
	a:SetPoint("LEFT", b, "RIGHT", 8, 0)
	b = t:CreateFontString(nil, "OVERLAY", "GameFontBlack")
	b:SetPoint("LEFT", a, "RIGHT", -2, 0)
	b:SetText("244,242")
	a, cf.animaCost = cf:CreateTexture(nil, "BACKGROUND", nil, 2), b
	a:SetTexture("Interface/Common/Mini-hourglass")
	a:SetSize(14, 14)
	a:SetVertexColor(0.5, 0.75, 1)
	a:SetPoint("LEFT", b, "RIGHT", 8, 0)
	b = t:CreateFontString(nil, "OVERLAY", "GameFontBlack")
	b:SetPoint("LEFT", a, "RIGHT", 2, 0)
	cf.duration = b
	cf.statLine = t
	
	t = CreateObject("ProgressBar", cf)
	t:SetWidth(cf:GetWidth()-50)
	t:SetPoint("BOTTOM", 0, 16)
	t.Fill:SetAtlas("UI-Frame-Bar-Fill-Blue")
	cf.ProgressBar = t
	local gb = CreateFrame("Button", nil, cf, "UIPanelButtonTemplate")
	gb:SetPoint("BOTTOM", 0, 12)
	gb:SetText("选择冒险者")
	gb:SetSize(160, 21)
	gb:SetScript("OnClick", function(self)
		local mf = self:GetParent()
		local c = C_Garrison.GetAvailableMissions(123)
		for i=1,#c do
			if c[i].missionID == mf.missionID then
				local mi = c[i]
				mi.missionID = mf.missionID
				mi.encounterIconInfo = C_Garrison.GetMissionEncounterIconInfo(mf.missionID)
				PlaySound(SOUNDKIT.UI_GARRISON_COMMAND_TABLE_SELECT_MISSION)
				CovenantMissionFrame:GetMissionPage():Show()
				CovenantMissionFrame:ShowMission(mi)
				self:GetParent():GetParent():GetParent():GetParent():Hide()
				break
			end
		end
	end)
	cf.ViewButton = gb
	t = cf:CreateFontString(nil, "BACKGROUND", "GameFontNormalSmall")
	t:SetTextColor(0.97, 0.94, 0.70)
	t:SetPoint("TOPLEFT", 16, -38)
	cf.TagText = t
	
	return cf
end
function Factory.RewardFrame(parent)
	local f, t = CreateObject("CommonHoverTooltip", CreateFrame("Button", nil, parent))
	f:SetSize(48, 48)
	t = f:CreateTexture(nil, "ARTWORK")
	t:SetAllPoints()
	t:SetTexture("Interface/Icons/Temp")
	t, f.Icon = f:CreateTexture(nil, "ARTWORK", nil, 2), t
	t:SetAllPoints()
	t:SetAtlas("loottoast-itemborder-orange")
	t, f.RarityBorder = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightOutline"), t
	t:SetPoint("BOTTOMRIGHT", -4, 5)
	t, f.Quantity = f:CreateTexture(nil, "ARTWORK", nil, 3), t
	t:SetPoint("TOP", 0, 7)
	t:SetSize(20, 20)
	t:SetAtlas("VignetteLoot")
	f.OvermaxRewardIcon = t
	f:SetScript("OnClick", CommonLinkable_OnClick)
	f.SetReward = RewardButton_SetReward
	return f
end
function Factory.InlineRewardBlock(parent)
	local f, t = CreateFrame("Frame", nil, parent)
	f:SetSize(140, 28)
	t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	t:SetPoint("LEFT")
	t:SetText("奖励:")
	f.Rewards, f.RewardsLabel = {}, t
	for i=1,3 do
		t = CreateObject("RewardFrame", f)
		t:SetSize(28,28)
		t:SetPoint("LEFT", f.Rewards[i-1] or f.RewardsLabel, "RIGHT", i == 1 and 12 or 4, 0)
		t.Quantity:Hide()
		t.ShowQuantityFromWidgetText = "Quantity"
		f.Rewards[i] = t
	end
	return f
end
function Factory.CommonHoverTooltip(frame)
	frame:SetScript("OnEnter", CommonTooltip_OnEnter)
	frame:SetScript("OnLeave", HideOwnGameTooltip)
	return frame
end
function Factory.MissionBaseBackground(parent, expandW, expandH)
	local eX, eY, t = expandW or 10, expandH or expandW or 10
	t = parent:CreateTexture(nil, "BORDER")
	t:SetAtlas("Garr_InfoBoxMission-BackgroundTile")
	t:SetPoint("TOPLEFT", -eX, eY)
	t:SetPoint("BOTTOMRIGHT", eX, -eY)
	t = parent:CreateTexture(nil, "BORDER", nil, 1)
	parent["BaseFrameTop"] = t
	t:SetAtlas("_Garr_InfoBoxMission-Top", true)
	t:SetHorizTile(true)
	t:SetPoint("TOPLEFT", 1-eX, 7+eY)
	t:SetPoint("TOPRIGHT", -1+eX, 7+eY)
	t = parent:CreateTexture(nil, "BORDER", nil, 1)
	parent["BaseFrameBottom"] = t
	t:SetAtlas("_Garr_InfoBoxMission-Top", true)
	t:SetHorizTile(true)
	t:SetPoint("BOTTOMLEFT", -eX, -7-eY)
	t:SetPoint("BOTTOMRIGHT", eX, -7-eY)
	t:SetTexCoord(0.0, 1.0, 1.0, 0.0)
	t = parent:CreateTexture(nil, "BORDER", nil, 1)
	parent["BaseFrameLeft"] = t
	t:SetAtlas("!Garr_InfoBoxMission-Left", true)
	t:SetVertTile(true)
	t:SetPoint("TOPLEFT", -7-eX, eY)
	t:SetPoint("BOTTOMLEFT", -7-eX, -eY)
	t = parent:CreateTexture(nil, "BORDER", nil, 1)
	parent["BaseFrameRight"] = t
	t:SetAtlas("!Garr_InfoBoxMission-Left", true)
	t:SetVertTile(true)
	t:SetPoint("TOPRIGHT", 7+eX, eY)
	t:SetPoint("BOTTOMRIGHT", 7+eX, -eY)
	t:SetTexCoord(1.0, 0.0, 0.0, 1.0)

	t = parent:CreateTexture(nil, "BORDER", nil, 2)
	parent["BaseFrameTopLeft"] = t
	t:SetAtlas("Garr_InfoBoxMission-Corner", true)
	t:SetPoint("TOPLEFT", -6-eX, 7+eY)
	t = parent:CreateTexture(nil, "BORDER", nil, 2)
	parent["BaseFrameTopRight"] = t
	t:SetAtlas("Garr_InfoBoxMission-Corner", true)
	t:SetPoint("TOPRIGHT", 6+eX, 7+eY)
	t:SetTexCoord(1.0, 0.0, 0.0, 1.0)
	t = parent:CreateTexture(nil, "BORDER", nil, 2)
	parent["BaseFrameBottomLeft"] = t
	t:SetAtlas("Garr_InfoBoxMission-Corner", true)
	t:SetPoint("BOTTOMLEFT", -7-eX, -7-eY)
	t:SetTexCoord(0.0, 1.0, 1.0, 0.0)
	t = parent:CreateTexture(nil, "BORDER", nil, 2)
	parent["BaseFrameBottomRight"] = t
	t:SetAtlas("Garr_InfoBoxMission-Corner", true)
	t:SetPoint("BOTTOMRIGHT", 7+eX, -7-eY)
	t:SetTexCoord(1.0, 0.0, 1.0, 0.0)

	t = parent:CreateTexture(nil, "BORDER", nil, 4)
	t:SetAtlas("_Garr_InfoBoxBorderMission-Top", true)
	t:SetHorizTile(true)
	t:SetPoint("TOPLEFT", -eX,eY)
	t:SetPoint("TOPRIGHT", eX,eY)
	t = parent:CreateTexture(nil, "BORDER", nil, 4)
	t:SetAtlas("_Garr_InfoBoxBorderMission-Top", true)
	t:SetHorizTile(true)
	t:SetPoint("BOTTOMLEFT", -eX,-eY)
	t:SetPoint("BOTTOMRIGHT", eX,-eY)
	t:SetTexCoord(0.0, 1.0, 1.0, 0.0)
	t = parent:CreateTexture(nil, "BORDER", nil, 4)
	t:SetAtlas("!Garr_InfoBoxBorderMission-Left", true)
	t:SetVertTile(true)
	t:SetPoint("TOPLEFT", -eX,eY)
	t:SetPoint("BOTTOMLEFT", -eX,-eY)
	t = parent:CreateTexture(nil, "BORDER", nil, 4)
	t:SetAtlas("!Garr_InfoBoxBorderMission-Left", true)
	t:SetVertTile(true)
	t:SetPoint("TOPRIGHT", eX,eY)
	t:SetPoint("BOTTOMRIGHT", eX,-eY)
	t:SetTexCoord(1.0, 0.0, 0.0, 1.0)

	t = parent:CreateTexture(nil, "BORDER", nil, 5)
	t:SetAtlas("Garr_InfoBoxBorderMission-Corner", true)
	t:SetPoint("TOPLEFT", -eX, eY)
	t = parent:CreateTexture(nil, "BORDER", nil, 5)
	t:SetAtlas("Garr_InfoBoxBorderMission-Corner", true)
	t:SetPoint("TOPRIGHT", eX, eY)
	t:SetTexCoord(1.0, 0.0, 0.0, 1.0)
	t = parent:CreateTexture(nil, "BORDER", nil, 5)
	t:SetAtlas("Garr_InfoBoxBorderMission-Corner", true)
	t:SetPoint("BOTTOMLEFT", -eX, -eY)
	t:SetTexCoord(0.0, 1.0, 1.0, 0.0)
	t = parent:CreateTexture(nil, "BORDER", nil, 5)
	t:SetAtlas("Garr_InfoBoxBorderMission-Corner", true)
	t:SetPoint("BOTTOMRIGHT", eX, -eY)
	t:SetTexCoord(1.0, 0.0, 1.0, 0.0)
end
function Factory.CountdownText(widget, textWidget)
	widget.SetCountdown = CountdownText_SetCountdown
	widget.CDTDisplay = textWidget or widget
end
function Factory.AchievementRewardIcon(parent)
	local f, t = CreateObject("CommonHoverTooltip", CreateFrame("Button", nil, parent))
	f:SetSize(30,30)
	f:SetScript("OnHide", HideOwnGameTooltip)
	f:SetScript("OnClick", CommonLinkable_OnClick)
	t = f:CreateTexture(nil, "ARTWORK")
	t:SetTexture("Interface/AchievementFrame/UI-Achievement-Progressive-Shield")
	t:SetTexCoord(0, 0.75, 0, 0.75)
	t:SetAllPoints()
	return f
end
function Factory.ProgressBar(parent)
	local f, t, r = CreateFrame("Frame", nil, parent)
	f:SetHeight(16)
	f:SetHitRectInsets(-3, -3, -6, -4)
	t = f:CreateTexture(nil, "BACKGROUND")
	t:SetAtlas("UI-Frame-Bar-BGLeft", true)
	t:SetPoint("LEFT", -2,0)
	t = f:CreateTexture(nil, "BACKGROUND")
	t:SetAtlas("UI-Frame-Bar-BGRight", true)
	t:SetPoint("RIGHT", 2,0)
	t = f:CreateTexture(nil, "BACKGROUND")
	t:SetAtlas("UI-Frame-Bar-BGCenter")
	t:SetPoint("LEFT", 27,0)
	t:SetPoint("RIGHT", -27,0)
	t:SetHeight(18)
	t = f:CreateTexture(nil, "BORDER")
	t:SetAtlas("UI-Frame-Bar-BorderLeft", true)
	t:SetPoint("LEFT", -8,0)
	t = f:CreateTexture(nil, "BORDER")
	t:SetAtlas("UI-Frame-Bar-BorderRight", true)
	t:SetPoint("RIGHT", 8,0)
	t = f:CreateTexture(nil, "BORDER")
	t:SetAtlas("UI-Frame-Bar-BorderCenter")
	t:SetPoint("LEFT", 27,0)
	t:SetPoint("RIGHT", -27,0)
	t:SetHeight(31)
	t, r = f:CreateTexture(nil, "HIGHLIGHT"), CreateObject("ObjectGroup")
	t:SetAtlas("UI-Frame-Bar-BorderLeft", true)
	t:SetPoint("LEFT", -8,0)
	t, r[#r+1] = f:CreateTexture(nil, "HIGHLIGHT"), t
	t:SetAtlas("UI-Frame-Bar-BorderRight", true)
	t:SetPoint("RIGHT", 8,0)
	t, r[#r+1] = f:CreateTexture(nil, "HIGHLIGHT", nil, 2), t
	t:SetAtlas("UI-Frame-Bar-BorderCenter")
	t:SetPoint("LEFT", 27,0)
	t:SetPoint("RIGHT", -27,0)
	t:SetHeight(31)
	r[#r+1], f.Highlight = t, r
	r:SetBlendMode("ADD")
	t = f:CreateTexture(nil, "BACKGROUND", nil, 2)
	t:SetAtlas("UI-Frame-Bar-Fill-Red")
	t:SetPoint("TOPLEFT")
	t:SetPoint("BOTTOMLEFT")
	t:SetWidth(50)
	t, f.Fill = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight"), t
	t:SetPoint("TOPLEFT", 4, 0)
	t:SetPoint("BOTTOMRIGHT", -4, 1)
	t:SetJustifyV("MIDDLE")
	f.Text = t
	f.SetProgress = Progress_SetProgress
	f.SetProgressCountdown = Progress_SetTimer
	return f
end
function Factory.CurrencyMeter()
	local f, t = CreateFrame("Frame")
	f:SetSize(180, 30)
	f:Hide()
	t = CreateObject("ProgressBar", f)
	t:SetPoint("LEFT", 8, 0)
	t:SetPoint("RIGHT", -8, 0)
	t:SetClipsChildren(true)
	t.Fill:SetAtlas("UI-Frame-Bar-Fill-Blue")
	t, f.Bar = t:CreateTexture(nil, "BACKGROUND", nil, 2), t
	t:SetAtlas("UI-Frame-Bar-Fill-Yellow")
	t:SetPoint("TOPLEFT", f.Bar.Fill, "TOPRIGHT")
	t:SetPoint("BOTTOMLEFT", f.Bar.Fill, "BOTTOMRIGHT")
	t:SetWidth(50)
	f.Activate, f.Fill2 = CurrencyMeter_Activate, t
	f:SetScript("OnHide", CurrencyMeter_OnHide)
	f:SetScript("OnUpdate", CurrencyMeter_Update)
	return f
end
function Factory.ControlContainerBorder(parent, expandX, expandY)
	expandX, expandY = expandX or 0, expandY or 0
	local t, is, ts = parent:CreateTexture(nil, "BACKGROUND"), 18, 1/16
	t:SetAtlas("adventures_mission_materialframe")
	t:SetTexCoord(0, ts, 0, 1)
	t:SetPoint("TOPLEFT", -expandX, expandY)
	t:SetPoint("BOTTOMRIGHT", parent, "BOTTOMLEFT", is-expandX, -expandY)
	t = parent:CreateTexture(nil, "BACKGROUND")
	t:SetTexCoord(ts, 1-ts, 0, 1)
	t:SetAtlas("adventures_mission_materialframe")
	t:SetPoint("TOPLEFT", is-expandX, expandY)
	t:SetPoint("BOTTOMRIGHT", -is+expandX, -expandY)
	t = parent:CreateTexture(nil, "BACKGROUND")
	t:SetTexCoord(1-ts, 1, 0, 1)
	t:SetAtlas("adventures_mission_materialframe")
	t:SetPoint("TOPRIGHT", expandX, expandY)
	t:SetPoint("BOTTOMLEFT", parent, "BOTTOMRIGHT", -is+expandX, -expandY)
end
function Factory.ResourceButton(parent, currencyID)
	local f,t = CreateObject("CommonHoverTooltip", CreateFrame("Button", nil, parent))
	f.tooltipAnchor, f.currencyID = "ANCHOR_BOTTOM", currencyID
	f:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
	f:SetScript("OnEvent", ResourceButton_Update)
	f:SetScript("OnClick", ResourceButton_OnClick)
	f:SetSize(60, 23)
	t = f:CreateTexture()
	t:SetSize(18, 18)
	local ci = C_CurrencyInfo.GetCurrencyInfo(currencyID)
	t:SetTexture(ci and ci.iconFileID or "Interface/Icons/Temp")
	t:SetTexCoord(4/64,60/64, 4/64,60/64)
	t:SetPoint("LEFT", 1, 0)
	t, f.Icon = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightMed2")
	t:SetPoint("LEFT", 25, 0)
	t:SetText("Lots")
	f.Text = t
	ResourceButton_Update(f, nil, currencyID)
	return f
end
function Factory.LogBookButton(parent)
	local f,t = CreateObject("CommonHoverTooltip", CreateFrame("Button", nil, parent))
	f.tooltipAnchor = "ANCHOR_BOTTOM"
	f:SetSize(60, 23)
	t = f:CreateTexture()
	t:SetSize(18, 18)
	t:SetTexture("Interface/Icons/INV_Inscription_80_Scroll")
	t:SetTexCoord(4/64,60/64, 4/64,60/64)
	t:SetPoint("LEFT", 1, 0)
	t, f.Icon = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightMed2")
	t:SetPoint("LEFT", 25, 0)
	t:SetText("Lots")
	f.SetText, f.Text = ResizedButton_SetText, t
	return f
end