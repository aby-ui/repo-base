local L = select(2, ...).L

-- TipTac refs
local tt = TipTac;
local cfg;

-- element registration
local ttBars = tt:RegisterElement({ bars = {} },"Bars");
local bars = ttBars.bars;

-- Constants
local BAR_MARGIN_X = 8;
local BAR_MARGIN_Y = 9;
local BAR_SPACING = 5;

local CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS;

--------------------------------------------------------------------------------------------------------
--                                         Mixin: Health Bar                                          --
--------------------------------------------------------------------------------------------------------

local HealthBarMixin = {};

function HealthBarMixin:GetVisibility(u)
	return cfg.healthBar;
end

function HealthBarMixin:GetColor(u)
	if (u.isPlayer) and (cfg.healthBarClassColor) then
		local color = CLASS_COLORS[u.classFile] or CLASS_COLORS["PRIEST"];
		return color.r, color.g, color.b;
	else
		return unpack(cfg.healthBarColor);
	end
end

if (RealMobHealth) then
	local RMH = RealMobHealth;
	function HealthBarMixin:GetValueParams(u)
		local val, max = RMH.GetUnitHealth(u.token);
		if (not val) or (not max) then
			val = UnitHealth(u.token);
			max = UnitHealthMax(u.token);
		end
		return val, max, cfg.healthBarText;
	end
else
	function HealthBarMixin:GetValueParams(u)
		local val = UnitHealth(u.token);
		local max = UnitHealthMax(u.token);
		return val, max, cfg.healthBarText;
	end
end

--------------------------------------------------------------------------------------------------------
--                                          Mixin: Power Bar                                          --
--------------------------------------------------------------------------------------------------------

local PowerBarMixin = {};

function PowerBarMixin:GetVisibility(u)
	u.powerType = UnitPowerType(u.token);
	return (UnitPowerMax(u.token,u.powerType) ~= 0) and (cfg.manaBar and u.powerType == 0 or cfg.powerBar and u.powerType ~= 0);
end

function PowerBarMixin:GetColor(u)
	if (u.powerType == 0) then
		return unpack(cfg.manaBarColor);
	else
		local powerColor = PowerBarColor[u.powerType or 5];
		return powerColor.r, powerColor.g, powerColor.b;
	end
end

function PowerBarMixin:GetValueParams(u)
	-- verify unit is still using the same power type, if not, update the bar color
	local newPowerType = UnitPowerType(u.token);
	if (newPowerType ~= u.powerType) then
		u.powerType = newPowerType;
		self:SetStatusBarColor(self:GetColor(u));
	end

	local val = UnitPower(u.token,u.powerType);
	local max = UnitPowerMax(u.token,u.powerType);
	local fmt = (u.powerType == 0 and cfg.manaBarText) or (cfg.powerBarText);
	return val, max, fmt;
end

--------------------------------------------------------------------------------------------------------
--                                         Mixin: Casting Bar                                         --
--------------------------------------------------------------------------------------------------------

--[[
local CastBarMixin = {};

function CastBarMixin:GetVisibility(u)
	if (UnitCastingInfo(u.token)) then
		self.castType = "cast";
	elseif (UnitCastingInfo(u.token)) then
		self.castType = "channel";
	else
		self.castType = nil;
	end
	return (self.castType ~= nil);
end

function CastBarMixin:GetColor(u)
	return CastingBarFrame.startChannelColor:GetRGBA();
end

function CastBarMixin:GetValueParams(u)
	local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible;
	local castID, notInterruptible, spellId;
	if (self.castType == "cast") then
		name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible = UnitCastingInfo(u.token);
	elseif (self.castType == "channel") then
		name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = UnitChannelInfo(u.token);
	end

	if (not name) then
		return 0, 0, "percent"
	end

	local val = (GetTime() - startTimeMS / 1000);
	local max = (endTimeMS - startTimeMS) / 1000;
	local fmt = cfg.healthBarText;
	return val, max, fmt;
end
--]]
--------------------------------------------------------------------------------------------------------
--                                       Bar Setup & Formatting                                       --
--------------------------------------------------------------------------------------------------------

-- Format Number Value -- kilo, mega, giga
-- Format Number Value -- kilo, mega, giga
local function FormatValue(val,type2)
	if (not cfg.barsCondenseValues) or (val < 10000) then
		return val;
	else
		if (type2 == "wanyi") then
			if (val < 100000000) then
				return (L["%.1fWan"]):format(val / 10000);
			else
				return (L["%.2fYi"]):format(val / 100000000);
			end
		else
			if (val < 1000000) then
				return ("%.1fk"):format(val / 1000);
			elseif (val < 1000000000) then
				return ("%.2fm"):format(val / 1000000);
			else
				return ("%.2fg"):format(val / 1000000000);
			end
		end
	end
end

-- Format Bar Text
local function SetFormattedBarValues(self,val,max,type,type2)
	local fs = self.text;
	if (type == "none") then
		fs:SetText("");
	elseif (type == "value") or (max == 0) then -- max should never be zero, but if it is, dont let it pass through to the "percent" type, or there will be an error
		fs:SetFormattedText("%s / %s",FormatValue(val,type2),FormatValue(max,type2));
	elseif (type == "current") then
		fs:SetFormattedText("%s",FormatValue(val,type2));
	elseif (type == "full") then
		fs:SetFormattedText("%s / %s (%.0f%%)",FormatValue(val,type2),FormatValue(max,type2),val / max * 100);
	elseif (type == "deficit") then
		if (val ~= max) then
			fs:SetFormattedText("-%s",FormatValue(max - val,type2));
		else
			fs:SetText("");
		end
	elseif (type == "percent") then
		fs:SetFormattedText("%.0f%%",val / max * 100);
	end
end

-- Creates a bar with the given mixins
function ttBars:CreateBar(parent,tblMixin)
	local bar = CreateFrame("StatusBar",nil,parent);
	bar:Hide();

--	bar:SetWidth(0);	-- Az: As of patch 3.3.3, setting the initial size will somehow mess up the texture. Previously this initilization was needed to fix an anchoring issue.
--	bar:SetHeight(0);

	bar.bg = bar:CreateTexture(nil,"BACKGROUND");
	bar.bg:SetColorTexture(0.3,0.3,0.3,0.6);
	bar.bg:SetAllPoints();

	bar.text = bar:CreateFontString(nil,"ARTWORK");
	bar.text:SetPoint("CENTER");
	bar.text:SetTextColor(1,1,1);

	bar.SetFormattedBarValues = SetFormattedBarValues;

	return Mixin(bar,tblMixin);
end

-- Initializes the anchoring position and color for each bar
function ttBars:SetupBars(tip)
	for index, bar in ipairs(bars) do
		bar:ClearAllPoints();

		if (bar:GetVisibility(tip.ttUnit)) then
			bar:SetPoint("BOTTOMLEFT", tt.padding.right + BAR_MARGIN_X, tt.padding.bottom + BAR_MARGIN_Y);
			bar:SetPoint("BOTTOMRIGHT", -tt.padding.left - BAR_MARGIN_X, tt.padding.bottom + BAR_MARGIN_Y);

			bar:SetStatusBarColor(bar:GetColor(tip.ttUnit));

			tt.padding.bottom = (tt.padding.bottom + cfg.barHeight + BAR_SPACING);

			bar:Show();
		else
			bar:Hide();
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Element Events                                           --
--------------------------------------------------------------------------------------------------------

function ttBars:OnLoad()
	cfg = TipTac_Config;

	-- Make two bars: Health & Power
	local tip = GameTooltip;
	bars[#bars + 1] = self:CreateBar(tip,PowerBarMixin);
	bars[#bars + 1] = self:CreateBar(tip,HealthBarMixin);
	if (CastBarMixin) then
		bars[#bars + 1] = self:CreateBar(tip,CastBarMixin);
	end
end

function ttBars:OnApplyConfig(cfg)
	GameTooltipStatusBar:SetStatusBarTexture(cfg.barTexture);
	GameTooltipStatusBar:GetStatusBarTexture():SetHorizTile(false);	-- Az: 3.3.3 fix
	GameTooltipStatusBar:GetStatusBarTexture():SetVertTile(false);	-- Az: 3.3.3 fix
	GameTooltipStatusBar:SetHeight(cfg.barHeight);

	for _, bar in ipairs(bars) do
		bar:SetStatusBarTexture(cfg.barTexture);
		bar:GetStatusBarTexture():SetHorizTile(false);	-- Az: 3.3.3 fix
		bar:GetStatusBarTexture():SetVertTile(false);	-- Az: 3.3.3 fix
		bar:SetHeight(cfg.barHeight);
		bar.text:SetFont(cfg.barFontFace,cfg.barFontSize,cfg.barFontFlags);
		
		-- Set default font if font in config is not valid
		if (not bar.text:GetFont()) then
			bar.text:SetFont(NumberFontNormal:GetFont());
			--AzMsg("TipTac: |3Please set a valid font in option tab |1Bars|r. Using default font instead.|r");
		end
	end
end

function ttBars:OnPreStyleTip(tip,first)
	-- for the first time styling, we want to initialize the bars
	if (first) then
		self:SetupBars(tip);

		-- Hide GTT Status bar, we have our own, which is prettier!
		if (cfg.hideDefaultBar) then
			GameTooltipStatusBar:Hide();
		end
	end

	-- update each shown bar
	for _, bar in ipairs(bars) do
		if (bar:IsShown()) then
			local val, max, fmt = bar:GetValueParams(tip.ttUnit);
			bar:SetMinMaxValues(0,max);
			bar:SetValue(val);
			bar:SetFormattedBarValues(val,max,fmt,cfg.barsCondenseType);
		end
	end
end

function ttBars:OnCleared(tip)
	for _, bar in ipairs(bars) do
		if (bar:GetParent() == tip) then
			bar:Hide();
		end
	end
end
