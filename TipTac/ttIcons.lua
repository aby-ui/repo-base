local gtt = GameTooltip;

-- TipTac refs
local tt = TipTac;
local cfg;

-- element registration
local ttIcons = tt:RegisterElement({},"Icons");

--ttIcons.icons = {};

--------------------------------------------------------------------------------------------------------
--                                                Misc                                                --
--------------------------------------------------------------------------------------------------------

function ttIcons:SetIcon(icon,u)
	local raidIconIndex = GetRaidTargetIndex(u.token);

	if (cfg.iconRaid) and (raidIconIndex) then
		icon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons");
		SetRaidTargetIconTexture(icon,raidIconIndex);
	elseif (cfg.iconFaction) and (UnitIsPVPFreeForAll(u.token)) then
		icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA");
		icon:SetTexCoord(0,0.62,0,0.62);
	elseif (cfg.iconFaction) and (UnitIsPVP(u.token)) and (UnitFactionGroup(u.token)) then
		icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..UnitFactionGroup(u.token));
		icon:SetTexCoord(0,0.62,0,0.62);
	elseif (cfg.iconCombat) and (UnitAffectingCombat(u.token)) then
		icon:SetTexture("Interface\\CharacterFrame\\UI-StateIcon");
		icon:SetTexCoord(0.5,1,0,0.5);
	elseif (u.isPlayer) and (cfg.iconClass) then
		local texCoord = CLASS_ICON_TCOORDS[u.classID];
		icon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles");
		icon:SetTexCoord(unpack(texCoord));
	else
		return false;
	end

	return true;
end

--------------------------------------------------------------------------------------------------------
--                                           Element Events                                           --
--------------------------------------------------------------------------------------------------------

function ttIcons:OnLoad()
	cfg = TipTac_Config;
end

function ttIcons:OnApplyConfig(cfg)
	self.wantIcon = (cfg.iconRaid or cfg.iconFaction or cfg.iconCombat or cfg.iconClass);

	if (self.wantIcon) then
		if (not self.icon) then
			self.icon = gtt:CreateTexture(nil,"BACKGROUND");
		end
		self.icon:SetSize(cfg.iconSize,cfg.iconSize);
		self.icon:ClearAllPoints();
		self.icon:SetPoint(tt.MirrorAnchors[cfg.iconAnchor],gtt,cfg.iconAnchor);
	elseif (self.icon) then
		self.icon:Hide();
	end
end

function ttIcons:OnPostStyleTip(tip,u,first)
	if (self.wantIcon) then
		self.icon:SetShown(self:SetIcon(self.icon,u));
	end
end

function ttIcons:OnCleared()
	if (self.icon) then
		self.icon:Hide();
	end
end