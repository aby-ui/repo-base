U1PLUG["FiveCombo"] = function()
--------------------------------------------------------------------------------
-- FiveCombo.lua
-- 作者：盒子哥
-- 日期：2012-05-07
-- 描述：盗贼、德鲁伊的5星技能提示
-- 版权所有（c）多玩游戏网
--------------------------------------------------------------------------------
local OverlayedSpellID = {};
-- 盗贼
OverlayedSpellID["ROGUE"] = {
	2098,       --斩击
    315496,     --切割
    196819,     --刺骨
    --狂徒
    408,        --肾击
    315341,     --正中眉心
    --奇袭
    1943,       --割裂
	32645,      --毒伤
    121411,     --猩红风暴
    --敏锐
    319175,     --黑火药
    280719,     --影分身
};

-- 德鲁伊
OverlayedSpellID["DRUID"] = {
	52610,  --野蛮咆哮，天赋
    285381, --原始之怒，天赋
	1079,   --割裂
	22568,  --凶猛撕咬
	22570,  --割碎
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

    --abyui change for 9.0 hooksecurefunc("ActionButton_OnUpdate", myActionButton_OnUpdate);
    hooksecurefunc(ActionBarButtonEventsFrame, "RegisterFrame", function(self, btn)
        if not self.__abyFiveCombo then
            self.__abyFiveCombo = true
            for _, btn in ipairs(self.frames) do
                myActionButton_OnUpdate(btn)
            end
        end
        myActionButton_OnUpdate(btn)
    end)
end