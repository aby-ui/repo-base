local _, T = ...
local EV = T.Evie

local function GetTargetMask(si, casterBoardIndex, boardMask)
	local TP = T.VSim.TP
	local u, board = {curHP=1}, {}
	for i=0,12 do
		board[i] = boardMask % 2^(i+1) >= 2^i and u or nil
	end
	local tt = si.target
	if #si > 0 then
		for i=1,#si do
			if si[i].target ~= 4 then
				tt = si[i].target
				break
			end
		end
	end
	if tt == nil then
		return 0
	end
	tt = TP.forkTargetMap[tt] or tt
	local r, ta = 0, TP.GetTargets(casterBoardIndex, tt, board)
	for i=1,ta and #ta or 0 do
		r = r + 2^ta[i]
	end
	return r
end
local function GenBoardMask()
	local m, MP = 0, CovenantMissionFrame.MissionTab.MissionPage
	for i=0,12 do
		local f = MP.Board.framesByBoardIndex[i]
		if f and f.name and f:IsShown() then
			m = m + 2^i
		end
	end
	return m
end
local blipMetric = UIParent:CreateFontString(nil, "BACKGROUND", "GameTooltipText")
blipMetric:SetPoint("TOPLEFT")
blipMetric:SetText("|TInterface/Minimap/PartyRaidBlipsV2:8:8|t")
blipMetric:Hide()
local function FormatTargetBlips(tm, bm, prefix)
	local r, xs = "", 0
	local bw = math.ceil(blipMetric:GetStringWidth()/0.64*UIParent:GetEffectiveScale())
	local yd = math.floor(bw/2+0.5)
	if tm % 32 > 0 then
		for i=0,4 do
			local t, p = tm % 2^(i+1) >= 2^i, bm % 2^(i+1) >= 2^i
			r = r .. "|TInterface/Minimap/PartyRaidBlipsV2:8:8:" .. (i < 2 and (math.floor(0.5*bw-1) .. ":" .. -yd) or (-2.5*bw .. ":" .. yd)).. ":64:32:0:20:0:20:" .. (t and "120:255:0|t" or p and "160:160:160|t" or "40:40:40|t")
		end
		xs = -10
	end
	if tm >= 32 then
		local lo, hi = xs .. ":" .. -yd, (xs-math.ceil(4.5*bw)) .. ":" .. yd
		for i=5,12 do
			local t, p = tm % 2^(i+1) >= 2^i, bm % 2^(i+1) >= 2^i
			r = r .. "|TInterface/Minimap/PartyRaidBlipsV2:8:8:" .. (i > 8 and hi or lo).. ":64:32:0:20:0:20:" .. (t and "120:255:0|t" or p and "160:160:160|t" or "40:40:40|t")
		end
	end
	if prefix and r ~= "" then
		r = prefix .. r
	end
	return r
end
local function FormatSpellPulse(si)
	local t = si.type
	local on, off = "|TInterface/Minimap/PartyRaidBlipsV2:8:8:0:0:64:32:0:20:0:20:255:120:0|t", "|TInterface/Minimap/PartyRaidBlipsV2:8:8:0:0:64:32:0:20:0:20:80:80:80|t"
	if t == "heal" or t == "nuke" or t == "nukem" or (si.duration and si.duration <= 1 and si.echo) then
		if si.echo then
			return on .. (off):rep(si.echo-1) .. on
		end
	elseif (t == "heal" or t == "nuke") and (si.duration and si.duration > 1) then
		return on .. (off):rep(si.duration-1)
	elseif t == "aura" then
		local r, p = (si.noFirstTick or si.period) and off or on, si.period or 1
		for i=2, si.duration do
			r = r .. (i % p == 0 and on or off)
		end
		return r
	end
end
local function Puck_OnEnter(self)
	if self.name then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.name)
		local mhp, hp, atk, role, aat
		local s1 = self.autoCombatSpells and self.autoCombatSpells[1]
		local mi  = CovenantMissionFrame.MissionTab.MissionPage.missionInfo
		local mid = mi.missionID
		local fi
		if self.boardIndex > 4 then
			for _,v in pairs(C_Garrison.GetMissionDeploymentInfo(mid).enemies) do
				if v.boardIndex == self.boardIndex then
					mhp, hp, atk, role = v.maxHealth, v.health, v.attack, v.role
					aat = T.VSim.TP:GetAutoAttack(role, self.boardIndex, mid, s1 and s1.autoCombatSpellID)
				end
			end
		elseif self.info and self.info.autoCombatantStats then
			fi = self.info
			local acs = fi.autoCombatantStats
			mhp, hp, atk, role = acs.maxHealth, acs.currentHealth, acs.attack, fi.role
			aat = T.VSim.TP:GetAutoAttack(role, self.boardIndex, mid, s1 and s1.autoCombatSpellID)
		end
		local bm = GenBoardMask()
		local atype = FormatTargetBlips(GetTargetMask(T.KnownSpells[aat], self.boardIndex, bm), bm, " ")
		if atype == "" then
			atype = aat == 11 and " (近战)" or aat == 15 and " (远程)" or ""
		end
		GameTooltip:AddLine("|A:ui_adv_health:20:20|a" .. (hp and BreakUpLargeNumbers(hp) or "???") .. (mhp and mhp ~= hp and ("|cffa0a0a0/|r" .. BreakUpLargeNumbers(mhp)) or "").. "  |A:ui_adv_atk:20:20|a" .. (atk and BreakUpLargeNumbers(atk) or "???") .. "|cffa8a8a8" .. atype, 1,1,1)
		if fi and fi.isMaxLevel == false and fi.xp and fi.levelXP and fi.level then
			GameTooltip:AddLine(UNIT_LEVEL_TEMPLATE:format(fi.level) .. ": " .. GARRISON_FOLLOWER_TOOLTIP_XP:format(fi.levelXP-fi.xp), 0.7, 0.7, 0.7)
		end
		for i=1,#self.autoCombatSpells do
			local s = self.autoCombatSpells[i]
			GameTooltip:AddLine(" ")
			local si = T.KnownSpells[s.autoCombatSpellID]
			local pfx = si and "" or "|TInterface/EncounterJournal/UI-EJ-WarningTextIcon:0|t "
			GameTooltip:AddLine(pfx .. "|T" .. s.icon .. ":0:0:0:0:64:64:4:60:4:60|t " .. s.name .. "  |cffffffff[CD: " .. s.cooldown .. "回合]|r")
			local dc, guideLine = 0.95
			if si and si.type == "nop" then
				dc, guideLine = 0.60, "It does nothing."
			elseif si then
				local tm = GetTargetMask(si, self.boardIndex, bm)
				if tm > 0 then
					local b = FormatTargetBlips(tm, bm)
					if b and b ~= "" then
						guideLine = "目标: " .. b
					end
				end
				if si and (si.healATK or si.damageATK or si.healPerc or si.damagePerc) then
					local p = FormatSpellPulse(si)
					if p then
						guideLine = "Pulse: " .. p .. (guideLine and "    " .. guideLine or "")
					end
				end
			end
			GameTooltip:AddLine(s.description, dc, dc, dc, 1)
			if guideLine then
				GameTooltip:AddLine(guideLine, 0.45, 1, 0, 1)
			end
		end
		GameTooltip:Show()
		self:GetBoard():ShowHealthValues()
	elseif GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end
local function Puck_OnLeave(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
	self:GetBoard():HideHealthValues()
end
local function EnvironmentEffect_OnEnter(self)
	local info = self.info
	local si = T.KnownSpells[info and info.autoCombatSpellID]
	local pfx = si and "" or "|TInterface/EncounterJournal/UI-EJ-WarningTextIcon:0|t "
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -8, 0)
	GameTooltip:SetText(pfx .. "|T" .. info.icon .. ":0:0:0:0:64:64:4:60:4:60|t " .. info.name .. "  |cffffffff[CD: " .. info.cooldown .. "回合]|r")
	local dc, guideLine = 0.95
	if si and si.type == "nop" then
		dc, guideLine = 0.60, "It does nothing."
	end
	GameTooltip:AddLine(info.description, dc, dc, dc, 1)
	if guideLine then
		GameTooltip:AddLine(guideLine, 0.45, 1, 0, 1)
	end
	GameTooltip:Show()
end
local function EnvironmentEffect_OnLeave(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end
local function EnvironmentEffect_OnNameUpdate(self_name)
	local ee = self_name:GetParent()
	ee:SetHitRectInsets(0, min(-100, -self_name:GetStringWidth()), 0, 0)
end
local function GetSim()
	local f = CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex
	local mi  = CovenantMissionFrame.MissionTab.MissionPage.missionInfo
	local mid = mi.missionID
	local team = {}
	for i=0,4 do
		local ii = f[i].info
		if ii then
			team[#team+1] = {
				boardIndex=i, role=ii.role, stats=ii.autoCombatantStats, spells=f[i].autoCombatSpells
			}
		end
	end
	local eei = C_Garrison.GetAutoMissionEnvironmentEffect(mid)
	local mdi = C_Garrison.GetMissionDeploymentInfo(mid)
	return T.VSim:New(team, mdi.enemies, eei, mid, mi.missionScalar)
end
local function Predictor_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	GameTooltip:SetText(ITEM_QUALITY_COLORS[5].hex .. "诅咒冒险者的指南")
	GameTooltip:AddLine(ITEM_UNIQUE, 1,1,1, 1)
	GameTooltip:AddLine("使用: 阅读指南, 确定冒险队的命运。", 0, 1, 0, 1)
	GameTooltip:AddLine('"不要相信它的谎言！ 平衡德鲁伊不是紧急口粮。"', 1, 0.835, 0.09, 1)
	GameTooltip:Show()
end
local function Predictor_OnClick(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	local sim, ms = GetSim()
	sim:Run()
	if (sim.pWin < 1 and sim.pWin > 0) or not sim.exhaustive then
		GameTooltip:SetText("诅咒的不确定性", 1, 0.20, 0)
		if sim.exhaustive then
			GameTooltip:AddLine("你该指南显示了一些可能的未来。 在某些情况下，冒险以胜利结束。 在其他情况下，则是特别可怕的失败。", 1,1,1,1)
		else
			GameTooltip:AddLine("指南向你展示了许多可能的未来，太多了。从这一点不可能得出你的队伍获胜的结论。", 1,1,1,1)
			if (sim.pWin == 0) then
				GameTooltip:AddLine("不管怎样，你记得的一切都以失败告终。", 1,1,1,1)
			elseif sim.pLose == 0 then
				GameTooltip:AddLine("不管怎样，你记得的一切都结束得很好。", 1,1,1,1)
			end
		end
		GameTooltip:AddLine('"运气好的话，这就是结束的唯一方法。"', 1, 0.835, 0.09, 1)
	else
		GameTooltip:SetText(sim.won and "胜利" or "失败", 1,1,1)
		if sim.mass == 1 then
			if sim.won then
				local c = NORMAL_FONT_COLOR
				GameTooltip:AddLine("回合数: |cffffffff" .. sim.turn, c.r, c.g, c.b)
				for i=0,4 do
					local e, f = sim.board[i], CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex[i]
					if f and f.name and f:IsShown() and f.info and e and not f.info.isAutoTroop then
						GameTooltip:AddDoubleLine(f.name, e.curHP .. "/" .. e.maxHP, 1,1,1, e.curHP > 0 and 0 or 1, e.curHP > 0 and 1 or 0.3, 0.15)
					end
				end
			else
				local thp, mhp = 0, 0
				for i=5,12 do
					local e = sim.board[i]
					if e then
						mhp, thp = mhp + e.maxHP, thp + e.curHP
					end
				end
				local c = NORMAL_FONT_COLOR
				GameTooltip:AddLine("幸存回合: |cffffffff" .. sim.turn, c.r, c.g, c.b)
				GameTooltip:AddLine("剩余敌人生命值: |cffffffff" .. thp .. " (" .. math.ceil(thp/mhp*100) .. "%)", c.r, c.g, c.b)
			end
		end
		GameTooltip:AddLine('"有什么疑问吗？"', 1, 0.835, 0.09, 1)
	end
	if ms and next(ms) then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("|TInterface/EncounterJournal/UI-EJ-WarningTextIcon:0|t 并非所有的能力都被考虑到。", 0.9,0.25,0.15,1)
	end
	GameTooltip:Show()
end
local function Predictor_OnLeave(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end
local function MissionStartButton_PreClick()
	local mi  = CovenantMissionFrame.MissionTab.MissionPage.missionInfo
	local mid = mi.missionID
	EV("I_MISSION_PRE_START", mid)
end
local function MissionGroup_OnUpdate()
	local o = GameTooltip:IsVisible() and GameTooltip:GetOwner() or GetMouseFocus()
	if o and not o:IsForbidden() and o:GetScript("OnEnter") and o:GetParent():GetParent() == CovenantMissionFrame.MissionTab.MissionPage.Board then
		o:GetScript("OnEnter")(o)
	end
end
local function MissionRewards_OnShow(self)
	local mi = CovenantMissionFrame.MissionTab.MissionPage.missionInfo
	self.Rewards[1]:SetReward("xp", mi and mi.xp)
	self.Rewards[2]:SetReward(mi and mi.rewards and mi.rewards[1])
	self.Rewards[3]:SetReward(mi and mi.rewards and mi.rewards[2])
end

function EV:I_ADVENTURES_UI_LOADED()
	local MP = CovenantMissionFrame.MissionTab.MissionPage
	for i=0,12 do
		local f = MP.Board.framesByBoardIndex[i]
		f:SetScript("OnEnter", Puck_OnEnter)
		f:SetScript("OnLeave", Puck_OnLeave)
		for i=1,2 do
			f.AbilityButtons[i]:EnableMouse(false)
			f.AbilityButtons[i]:SetMouseMotionEnabled(false)
		end
	end
	MP.CloseButton:SetScript("OnKeyDown", function(self, key)
		self:SetPropagateKeyboardInput(key ~= "ESCAPE")
		if key == "ESCAPE" then
			self:Click()
		end
	end)
	local mb = CreateFrame("Button", nil, MP.Board)
	mb:SetSize(64,64)
	mb:SetPoint("BOTTOMLEFT", 24, 8)
	mb:SetNormalTexture("Interface/Icons/INV_Misc_Book_01")
	mb:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
	mb:GetHighlightTexture():SetBlendMode("ADD")
	mb:SetPushedTexture("Interface/Buttons/UI-Quickslot-Depress")
	mb:GetPushedTexture():SetDrawLayer("OVERLAY")
	local t = mb:CreateTexture(nil, "ARTWORK")
	t:SetAllPoints()
	t:SetTexture("Interface/Icons/INV_Misc_Book_01")
	mb:SetScript("OnEnter", Predictor_OnEnter)
	mb:SetScript("OnLeave", Predictor_OnLeave)
	mb:SetScript("OnClick", Predictor_OnClick)
	MP.StartMissionButton:SetScript("PreClick", MissionStartButton_PreClick)
	MP.Stage.EnvironmentEffectFrame:SetScript("OnEnter", EnvironmentEffect_OnEnter)
	MP.Stage.EnvironmentEffectFrame:SetScript("OnLeave", EnvironmentEffect_OnLeave)
	hooksecurefunc(MP.Stage.EnvironmentEffectFrame.Name, "SetText", EnvironmentEffect_OnNameUpdate)
	hooksecurefunc(CovenantMissionFrame, "AssignFollowerToMission", MissionGroup_OnUpdate)
	hooksecurefunc(CovenantMissionFrame, "RemoveFollowerFromMission", MissionGroup_OnUpdate)
	local s = CovenantMissionFrame.MissionTab.MissionPage.Stage
	s.Title:SetPoint("LEFT", s.Header, "LEFT", 100, 9)
	local ir = T.CreateObject("InlineRewardBlock", s)
	ir:SetPoint("LEFT", s.Header, "LEFT", 110, -16)
	ir:SetScript("OnShow", MissionRewards_OnShow)
	hooksecurefunc(CovenantMissionFrame, "SetTitle", function()
		MissionRewards_OnShow(ir)
	end)
	return false
end