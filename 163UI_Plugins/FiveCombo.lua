U1PLUG["FiveCombo"] = function()
--------------------------------------------------------------------------------
-- FiveCombo.lua
-- 作者：盒子哥
-- 日期：2012-05-07
-- 描述：盗贼、德鲁伊的5星技能提示
-- 版权所有（c）多玩游戏网
--------------------------------------------------------------------------------

--[[
刺骨 2098
毒伤 32645
破甲 8647
切割 5171
肾击 408
致命投掷 26679
割裂 1943
恢复 73651

野蛮咆哮 52610
割裂 1079
割碎      22570
凶猛撕咬 22568
]]
local OverlayedSpellID = {};
-- 盗贼
OverlayedSpellID["ROGUE"] = {
	2098,
	32645,
	8647,
	5171,
	408,
	26679,
	1943,
	73651,
	193316,
	199804,
	196819,
	195452,
	206237
};

-- 德鲁伊
OverlayedSpellID["DRUID"] = {
	52610,
	1079,
	22568,
	22570,
};

local GlowSpells = {}
for k,v in pairs(OverlayedSpellID) do
    for _, spell in ipairs(v) do
        GlowSpells[spell] = true
    end
end

local function comboEventFrame_OnEvent(self, event, ...)
	local parent = self:GetParent();
	local points = UnitPower("player", 4)
	local spellType, id, subType  = GetActionInfo(parent.action);

    local spellId
    if spellType == "spell" then
        spellId = id
    elseif spellType == "macro" then
        spellId = GetMacroSpell(id)
    end

    if not spellId or not GlowSpells[spellId] or IsSpellOverlayed(spellId) then
        CoreUIHideOverlayGlow(parent)
        return
    end

	if (points == UnitPowerMax("player", 4)) then
        CoreUIShowOverlayGlow(parent);
	else
		CoreUIHideOverlayGlow(parent);
	end
end

local function myActionButton_OnUpdate(self, elapsed)
    if self.comboEventFrame then return end
	self.comboEventFrame = CreateFrame("Frame", nil, self);
	self.comboEventFrame.countTime = 0;
	self.comboEventFrame:RegisterEvent("UNIT_POWER_UPDATE");
	self.comboEventFrame:RegisterEvent('UNIT_POWER_FREQUENT')
	self.comboEventFrame:RegisterEvent('UNIT_MAXPOWER')
	self.comboEventFrame:SetScript("OnEvent", comboEventFrame_OnEvent);
end

hooksecurefunc("ActionButton_OnUpdate", myActionButton_OnUpdate);
end