local U, _, T = {}, ...
local L = newproxy(true) do
	local LT = T.LT or {}
	getmetatable(L).__call = function(_, k)
		return LT[k] or k
	end
end
T.Util, T.L, T.LT = U, L, nil

local overdesc = {
	[91]=L"Reduces the damage dealt by the furthest enemy by 1 for 3 rounds.",
	[85]=L"Reduces the damage taken by the closest ally by 5000% for two rounds.",
	[198]={L"For two rounds, reduces the damage dealt by incoming attacks by 1 and retaliates for {}.", "thornsATK"},
	[52]={L"Inflicts {} damage to all enemies at range.", "damageATK"},
	[125]={L"Inflicts {} damage to a random enemy.", "damageATK"},
	[229]=L"Reduces damage taken by a random ally by 50%. Forever.",
	[301]={L"Every other turn, a random enemy is attacked for {}% of their maximum health.", "damagePerc"},
	[227]={L"Every other turn, a random enemy is attacked for {}% of their maximum health.", "damagePerc"},
}

local GetMaskBoard do
	local b, u, om = {}, {curHP=1}
	function GetMaskBoard(bm)
		if om == bm then
			return b
		end
		om = bm
		for i=0,12 do
			b[i] = bm % 2^(i+1) >= 2^i and u or nil
		end
		return b
	end
	U.GetMaskBoard = GetMaskBoard
end
local function GetTargetMask(si, casterBoardIndex, boardMask)
	if not (si and casterBoardIndex) then
		return 0
	end
	local TP = T.VSim.TP
	local board, tm, isForked = GetMaskBoard(boardMask), 0, false
	for i=si.type and 0 or 1,#si do
		local ei = si[i] or si
		local eit = ei and ei.target
		if eit then
			isForked = isForked or TP.forkTargetMap[eit]
			local ta = TP.GetTargets(casterBoardIndex, TP.forkTargetMap[eit] or eit, board)
			for i=1,ta and #ta or 0 do
				tm = bit.bor(tm, 2^ta[i])
			end
		end
	end
	return tm + (isForked and tm > 0 and 2^18 or 0)
end
local GetBlipWidth do
	local blipMetric = UIParent:CreateFontString(nil, "BACKGROUND", "GameTooltipText")
	blipMetric:SetPoint("TOPLEFT")
	blipMetric:SetText("|TInterface/Minimap/PartyRaidBlipsV2:8:8|t")
	blipMetric:Hide()
	function GetBlipWidth()
		local _, sh = GetPhysicalScreenSize()
		blipMetric:SetText("|TInterface/Minimap/PartyRaidBlipsV2:8:8|t|TInterface/Minimap/PartyRaidBlipsV2:8:8|t")
		local w2 = blipMetric:GetStringWidth()
		blipMetric:SetText("|TInterface/Minimap/PartyRaidBlipsV2:8:8|t")
		local w1 = blipMetric:GetStringWidth()
		return (w2-w1+select(2,blipMetric:GetFont())*(sh*5/9000-0.7))/0.64*UIParent:GetScale()
	end
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


function U.GetTimeStringFromSeconds(sec, shorter, roundUp, disallowSeconds)
	local h = roundUp and math.ceil or math.floor
	if sec < 90 and not disallowSeconds then
		return (shorter and COOLDOWN_DURATION_SEC or INT_GENERAL_DURATION_SEC):format(sec < 0 and 0 or h(sec))
	elseif (sec < 3600*(shorter and shorter ~= 2 and 3 or 1) and (sec % 3600 >= 1 or sec < 3600)) then
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
function U.SetFollowerInfo(GameTooltip, info, autoCombatSpells, autoCombatantStats, mid, boardIndex, boardMask, showHealthFooter)
	local mhp, hp, atk, role, aat, level
	autoCombatantStats = autoCombatantStats or info and info.autoCombatantStats
	if info then
		role, level = info.role, info.level and ("|cffa8a8a8" .. UNIT_LEVEL_TEMPLATE:format(info.level)) or ""
	end
	if autoCombatantStats then
		local s1 = autoCombatSpells and autoCombatSpells[1]
		mhp, hp, atk = autoCombatantStats.maxHealth, autoCombatantStats.currentHealth, autoCombatantStats.attack
		aat = T.VSim.TP:GetAutoAttack(role, boardIndex, mid, s1 and s1.autoCombatSpellID)
	end
	
	GameTooltip:ClearLines()
	GameTooltip:AddDoubleLine(info.name, level or "")

	local atype = U.FormatTargetBlips(GetTargetMask(T.KnownSpells[aat], boardIndex, boardMask), boardMask, " ")
	if atype == "" then
		atype = aat == 11 and " " .. L"(melee)" or aat == 15 and " " .. L"(ranged)" or ""
	end
	GameTooltip:AddLine("|A:ui_adv_health:20:20|a" .. (hp and BreakUpLargeNumbers(hp) or "???") .. (mhp and mhp ~= hp and ("|cffa0a0a0/|r" .. BreakUpLargeNumbers(mhp)) or "").. "  |A:ui_adv_atk:20:20|a" .. (atk and BreakUpLargeNumbers(atk) or "???") .. "|cffa8a8a8" .. atype, 1,1,1)
	if info and info.isMaxLevel == false and info.xp and info.levelXP and info.level and not info.isAutoTroop then
		GameTooltip:AddLine(GARRISON_FOLLOWER_TOOLTIP_XP:gsub("%%[^%%]*d", "%%s"):format(BreakUpLargeNumbers(info.levelXP - info.xp)), 0.7, 0.7, 0.7)
	end

	for i=1, autoCombatSpells and #autoCombatSpells or 0 do
		local s = autoCombatSpells[i]
		GameTooltip:AddLine(" ")
		local si = T.KnownSpells[s.autoCombatSpellID]
		local pfx = si and "" or "|TInterface/EncounterJournal/UI-EJ-WarningTextIcon:0|t "
		local cdt = s.cooldown ~= 0 and (L"[CD: %dT]"):format(s.cooldown) or SPELL_PASSIVE_EFFECT
		GameTooltip:AddDoubleLine(pfx .. "|T" .. s.icon .. ":0:0:0:0:64:64:4:60:4:60|t " .. NORMAL_FONT_COLOR_CODE .. s.name, "|cffa8a8a8" .. cdt .. "|r")
		local dc, guideLine = 0.95, U.GetAbilityGuide(s.autoCombatSpellID, boardIndex, boardMask)
		local od = U.GetAbilityDescriptionOverride(s.autoCombatSpellID, atk)
		if od then
			dc, guideLine = 0.60, od .. (guideLine and "|n" .. guideLine or "")
		end
		GameTooltip:AddLine(s.description, dc, dc, dc, 1)
		if guideLine then
			GameTooltip:AddLine("|cff73ff00" .. guideLine, 0.45, 1, 0, 1)
		end
	end

	if showHealthFooter and info and info.status ~= GARRISON_FOLLOWER_ON_MISSION and autoCombatantStats and autoCombatantStats.currentHealth < autoCombatantStats.maxHealth then
		local fastHealing = C_Garrison.GetTalentInfo(1075)
		local rt = (1-(autoCombatantStats.currentHealth/autoCombatantStats.maxHealth)) * (fastHealing and fastHealing.researched and 49600 or 60000)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("|cffffd926" .. (L"Full recovery in %s"):format(U.GetTimeStringFromSeconds(rt, false, true, true)), 1, 0.85, 0.15, 1)
	end

	GameTooltip:Show()
end
function U.FormatTargetBlips(tm, bm, prefix, ac, padHeight)
	local isForked = tm >= 2^18
	tm = tm - (isForked and 2^18 or 0)
	ac = ac and ac .. "|t" or (isForked and "200:50:255|t" or "120:255:0|t")
	local r, xs, bw = "", 0, GetBlipWidth()
	local yd = bw/2
	if tm % 32 > 0 then
		local xo = 0
		for i=2,4 do
			local t, p = tm % 2^(i+1) >= 2^i, bm % 2^(i+1) >= 2^i
			r = r .. "|TInterface/Minimap/PartyRaidBlipsV2:8:8:" .. (xo .. ":" .. yd).. ":64:32:0:20:0:20:" .. (t and ac or p and "160:160:160|t" or "40:40:40|t")
			if i < 4 then
				i, xo = i - 2, xo - bw/2
				t, p = tm % 2^(i+1) >= 2^i, bm % 2^(i+1) >= 2^i
				r = r .. "|TInterface/Minimap/PartyRaidBlipsV2:8:8:" .. (xo .. ":" .. -yd).. ":64:32:0:20:0:20:" .. (t and ac or p and "160:160:160|t" or "40:40:40|t")
				xo = xo - bw/2
			end
		end
		xs = -bw
	end
	if tm >= 32 then
		local xo = xs
		for i=5,8 do
			local t, p = tm % 2^(i+1) >= 2^i, bm % 2^(i+1) >= 2^i
			r = r .. "|TInterface/Minimap/PartyRaidBlipsV2:8:8:" .. xo .. ":" .. -yd .. ":64:32:0:20:0:20:" .. (t and ac or p and "160:160:160|t" or "40:40:40|t")
			i, xo = i + 4, xo - bw
			t, p = tm % 2^(i+1) >= 2^i, bm % 2^(i+1) >= 2^i
			r = r .. "|TInterface/Minimap/PartyRaidBlipsV2:8:8:" .. xo .. ":" .. yd  .. ":64:32:0:20:0:20:" .. (t and ac or p and "160:160:160|t" or "40:40:40|t")
		end
	end
	if prefix and r ~= "" then
		r = prefix .. r
	end
	if r ~= "" and padHeight ~= false then
		r = r .. "|TInterface/Minimap/PartyRaidBlipsV2:19:1:0:0:64:32:62:63:0:2|t"
	end
	return r
end
function U.GetAbilityGuide(spellID, boardIndex, boardMask, padHeight)
	local si, guideLine = T.KnownSpells[spellID]
	if not (si and si.type ~= "nop") then
		return
	end
	if si.firstTurn then
		padHeight = true
	end
	local tm = GetTargetMask(si, boardIndex, boardMask)
	if tm > 0 then
		local b = U.FormatTargetBlips(tm, boardMask, nil, nil, padHeight)
		if b and b ~= "" then
			guideLine = L"Targets:" .. " " .. b
		end
	end
	if si.healATK or si.damageATK or si.healPerc or si.damagePerc then
		local p = FormatSpellPulse(si)
		if p then
			guideLine = L"Pulse:" .. " " .. p .. (guideLine and "    " .. guideLine or "")
		end
	end
	if si.firstTurn then
		guideLine = (L"First cast during turn %d."):format(si.firstTurn) .. (guideLine and "|n" .. guideLine or "")
	end
	return guideLine
end
function U.GetAbilityDescriptionOverride(spellID, atk)
	local si = T.KnownSpells[spellID]
	if si and si.type == "nop" then
		return L"It does nothing."
	end
	local od = overdesc[spellID]
	if od then
		if type(od) == "table" then
			local vk = od[2]
			local rv = vk == "damagePerc" and si[vk] or si[vk] and atk and math.floor(si[vk]*(atk or -1)/100) or ""
			od = od[1]:gsub("{}", rv)
		end
		return od
	end
end
