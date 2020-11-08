local gtt = GameTooltip;

-- TipTac refs
local tt = TipTac;
local cfg;

-- element registration
local ttAuras = tt:RegisterElement({ auras = {} },"Auras");
local auras = ttAuras.auras;

-- Valid units to filter the aurs in DisplayAuras() with the "cfg.selfAurasOnly" setting on
local validSelfCasterUnits = {
	player = true,
	pet = true,
	vehicle = true,
};

--------------------------------------------------------------------------------------------------------
--                                                Misc                                                --
--------------------------------------------------------------------------------------------------------

local function CreateAuraFrame(parent)
	local aura = CreateFrame("Frame",nil,parent);
	aura:SetSize(cfg.auraSize,cfg.auraSize);

	aura.count = aura:CreateFontString(nil,"OVERLAY");
	aura.count:SetPoint("BOTTOMRIGHT",1,0);
	aura.count:SetFont(GameFontNormal:GetFont(),(cfg.auraSize / 2),"OUTLINE");

	aura.icon = aura:CreateTexture(nil,"BACKGROUND");
	aura.icon:SetAllPoints();
	aura.icon:SetTexCoord(0.07,0.93,0.07,0.93);

	aura.cooldown = CreateFrame("Cooldown",nil,aura,"CooldownFrameTemplate");
	aura.cooldown:SetReverse(1);
	aura.cooldown:SetAllPoints();
	aura.cooldown:SetFrameLevel(aura:GetFrameLevel());
	aura.cooldown.noCooldownCount = cfg.noCooldownCount or nil;

	aura.border = aura:CreateTexture(nil,"OVERLAY");
	aura.border:SetPoint("TOPLEFT",-1,1);
	aura.border:SetPoint("BOTTOMRIGHT",1,-1);
	aura.border:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays");
	aura.border:SetTexCoord(0.296875,0.5703125,0,0.515625);

	auras[#auras + 1] = aura;
	return aura;
end

-- querires auras of the specific auraType, and sets up the aura frame and anchors it in the desired place
function ttAuras:DisplayAuras(tip,u,auraType,startingAuraFrameIndex)

	local aurasPerRow = floor((tip:GetWidth() - 4) / (cfg.auraSize + 1));	-- auras we can fit into one row based on the current size of the tooltip
	local xOffsetBasis = (auraType == "HELPFUL" and 1 or -1);				-- is +1 or -1 based on horz anchoring

	local queryIndex = 1;							-- aura query index for this auraType
	local auraFrameIndex = startingAuraFrameIndex;	-- array index for the next aura frame, initialized to the starting index

	-- anchor calculation based on "auraType" and "cfg.aurasAtBottom"
	local horzAnchor1 = (auraType == "HELPFUL" and "LEFT" or "RIGHT");
	local horzAnchor2 = tt.MirrorAnchors[horzAnchor1];

	local vertAnchor = (cfg.aurasAtBottom and "TOP" or "BOTTOM");
	local anchor1 = vertAnchor..horzAnchor1;
	local anchor2 = tt.MirrorAnchors[vertAnchor]..horzAnchor1;

	-- query auras
	while (true) do
		local _, iconTexture, count, debuffType, duration, endTime, casterUnit = UnitAura(u.token,queryIndex,auraType);	-- [18.07.19] 8.0/BfA: "dropped second parameter"
		if (not iconTexture) or (auraFrameIndex / aurasPerRow > cfg.auraMaxRows) then
			break;
		end
		if (not cfg.selfAurasOnly or validSelfCasterUnits[casterUnit]) then
			local aura = auras[auraFrameIndex] or CreateAuraFrame(tip);

			-- Anchor It
			aura:ClearAllPoints();
			if ((auraFrameIndex - 1) % aurasPerRow == 0) or (auraFrameIndex == startingAuraFrameIndex) then
				-- new aura line
				local x = (xOffsetBasis * 2);
				local y = (cfg.auraSize + 1) * floor((auraFrameIndex - 1) / aurasPerRow);
				y = (cfg.aurasAtBottom and -y or y);
				aura:SetPoint(anchor1,tip,anchor2,x,y);
			else
				-- anchor to last
				aura:SetPoint(horzAnchor1,auras[auraFrameIndex - 1],horzAnchor2,xOffsetBasis,0);
			end

			-- Cooldown
			if (cfg.showAuraCooldown) and (duration and duration > 0 and endTime and endTime > 0) then
				aura.cooldown:SetCooldown(endTime - duration,duration);
			else
				aura.cooldown:Hide();
			end

			-- Set Texture + Count
			aura.icon:SetTexture(iconTexture);
			aura.count:SetText(count and count > 1 and count or "");

			-- Border -- Only shown for debuffs
			if (auraType == "HARMFUL") then
				local color = DebuffTypeColor[debuffType] or DebuffTypeColor["none"];
				aura.border:SetVertexColor(color.r,color.g,color.b);
				aura.border:Show();
			else
				aura.border:Hide();
			end

			-- Show + Next, Break if exceed max desired rows of aura
			aura:Show();
			auraFrameIndex = (auraFrameIndex + 1);
		end
		queryIndex = (queryIndex + 1);
	end

	-- return the number of auras displayed
	return (auraFrameIndex - startingAuraFrameIndex);
end

-- display buffs and debuffs and hide unused aura frames
function ttAuras:SetupAuras(tip,u)
--printf("[%.2f] %-24s %d x %d",GetTime(),"SetupAuras",tip:GetWidth(),tip:GetHeight())
	local auraCount = 0;
	if (cfg.showBuffs) then
		auraCount = auraCount + self:DisplayAuras(tip,u,"HELPFUL",auraCount + 1);
	end
	if (cfg.showDebuffs) then
		auraCount = auraCount + self:DisplayAuras(tip,u,"HARMFUL",auraCount + 1);
	end

	-- Hide the Unused
	for i = (auraCount + 1), #auras do
		auras[i]:Hide();
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Element Events                                           --
--------------------------------------------------------------------------------------------------------

function ttAuras:OnLoad()
	cfg = TipTac_Config;
end

function ttAuras:OnApplyConfig(cfg)
	-- If disabled, hide auras, else set their size
	local gameFont = GameFontNormal:GetFont();
	for _, aura in ipairs(auras) do
		if (cfg.showBuffs or cfg.showDebuffs) then
			aura:SetWidth(cfg.auraSize,cfg.auraSize);
			aura.count:SetFont(gameFont,(cfg.auraSize / 2),"OUTLINE");
			aura.cooldown.noCooldownCount = cfg.noCooldownCount;
		else
			aura:Hide();
		end
	end
end

-- Auras - Has to be updated last because it depends on the tips new dimention
function ttAuras:OnPostStyleTip(tip,u,first)
	-- Check token, because if the GTT was hidden in OnShow (called in ApplyUnitAppearance),
	-- it would be nil here due to "u" being wiped in OnTooltipCleared()
	if (u.token) and (cfg.showBuffs or cfg.showDebuffs) then
		self:SetupAuras(tip,u);
	end
end

--function ttAuras:OnShow(tip)
--	if (u.token) and (cfg.showBuffs or cfg.showDebuffs) then
--		self:SetupAuras(tip,u);
--	end
--end

function ttAuras:OnCleared(tip)
	for _, aura in ipairs(auras) do
		aura:Hide();
	end
end