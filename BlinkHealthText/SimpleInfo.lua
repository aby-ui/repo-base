-------------------------------------------------------------------------------
-- 文件: SimpleInfo.lua ver 1.0
-- 日期: 2010-12-11
-- 作者: dugu@wowbox
-- 描述: 在屏幕中下方显示玩家(宠物)和目标(ToT)的基本信息
-- 版权所有@多玩游戏网
-------------------------------------------------------------------------------

BlinkHealth = LibStub("AceAddon-3.0"):NewAddon("SimpleInfo",  "AceEvent-3.0", "AceTimer-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("SimpleInfo");
local S = BlinkHealth;
S._DEBUG = false;

local WARRIOR       = 1
local PALADIN       = 2
local HUNTER        = 3
local ROGUE         = 4
local PRIEST        = 5
local DEATHKNIGHT   = 6
local SHAMAN        = 7
local MAGE          = 8
local WARLOCK       = 9
local MONK          = 10
local DRUID         = 11
local DEMONHUNTER   = 12

--local BlinkHealthTextPowerType;

local function GetPowerType()
    local _, _, class = UnitClass("player")
    local spec = GetSpecialization()
    if (class == MONK and spec == 3) then
        return Enum.PowerType.Chi
    elseif (class == PALADIN) then
        return spec == 3 and Enum.PowerType.HolyPower
    elseif (class == WARLOCK) then
        return Enum.PowerType.SoulShards
    elseif (class == MAGE) then
        return spec == 1 and Enum.PowerType.ArcaneCharges
    elseif (class == ROGUE) then
        return Enum.PowerType.ComboPoints
    elseif (class == DRUID) then
        return UnitPowerType("player") == Enum.PowerType.Energy and Enum.PowerType.ComboPoints or nil
    elseif (class == DEATHKNIGHT) then

    end
end
-- Target name
local FONT_PATH = "Fonts\\ARKai_T.ttf";
if (GetLocale() == "zhTW") then
	FONT_PATH = STANDARD_TEXT_FONT;
end
local fntBig = CreateFont("SIFontBig");
fntBig:SetFont(FONT_PATH, 22, "THICKOUTLINE");
-- Power, absolute health
local fntMedium = CreateFont("SIFontMedium");
fntMedium:SetFont(FONT_PATH, 16, "THINOUTLINE");
fntMedium:SetTextColor(1, 0.65, 0.16);
fntMedium:SetShadowColor(0.25, 0.25, 0.25, 0.5);
fntMedium:SetShadowOffset(1, -1);
-- ToT, pet
local fntSmall = CreateFont("SIFontSmall");
fntSmall:SetFont(FONT_PATH, 14, "THINOUTLINE");


fntSmall:SetTextColor(1, 0.65, 0.16);
fntSmall:SetShadowColor(0.25, 0.25, 0.25, 0.5);
fntSmall:SetShadowOffset(1, -1);

S.digitTexCoords = {
	["1"] = {1, 20},
	["2"] = {21, 31},
	["3"] = {53, 30},
	["4"] = {84, 33},
	["5"] = {118, 30},
	["6"] = {149, 31},
	["7"] = {181, 30},
	["8"] = {212, 31},
	["9"] = {244, 31},
	["0"] = {276, 31},
	["%"] = {308, 17},
	["X"] = {326, 31},	-- Dead
	["G"] = {358, 36},	-- Ghost
	["Off"] = {395, 23},	-- Offline
	["height"] = 42,
	["texWidth"] = 512,
	["texHeight"] = 128
};

S.powerColor = {
	AMMOSLOT = {0.8, 0.6, 0},
	ENERGY = {1, 1, 0},
	FOCUS = {1, 0.5, 0.25},
	FUEL = {0, 0.55, 0.5},
	HAPPINESS = {0, 1, 1},
	MANA = {0.31, 0.45, 0.63},
	RAGE = {0.69, 0.31, 0.31},
	RUNES = {0.55, 0.57, 0.61},
	RUNIC_POWER = {0, 0.82, 1},
    FURY = {0.788, 0.259, 0.992},
    PAIN = {255/255, 156/255, 0},
    INSANITY = {0.40, 0, 0.80}, -- PowerBarColor
};

S.runeColors = {
	{1, 0, 0};
	{0, .5, 0};
	{0, 1, 1};
	{.9, .1, 1};
}

S.classColor = {};
do
    for k, v in pairs(RAID_CLASS_COLORS) do
        S.classColor[k] = {v.r, v.g, v.b};
    end
end

function S:OnInitialize()
	self.frame = {};
	self:CreateAnchorFrame()
	self:ConstructFrame("player");
	self:ConstructFrame("target");
	self.class = select(2, UnitClass("player"));
	if (self.class == "DEATHKNIGHT") then		
		self:ConstructRunes();
	end
	if ("MONK,PALADIN,WARLOCK,MAGE,ROGUE,DRUID"):find(self.class) then
		self:ConstructCombo();
		self:ConstructHitPoints();	-- 构建连击点
	end
	self:ConstructCastingBar();
	self:UpdateUnitFrame();
end

function S:OnEnable()
	self:RegisterEvent("PLAYER_TARGET_CHANGED");
    self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
    self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("PLAYER_REGEN_DISABLED");
	self:RegisterEvent("PLAYER_REGEN_ENABLED");
    self:RegisterEvent("UNIT_POWER_UPDATE");

	self.frame["player"]:Show();
	self.handle = self:ScheduleRepeatingTimer("UpdateUnitValues", 0.05);
end

function S:OnDisable()
	self:UnregisterAllEvents();
	self:CancelTimer(self.handle, true);
	self.frame["player"]:Hide();
	self.frame["target"]:Hide();
end

function S:PLAYER_TARGET_CHANGED()
	self:UpdateUnitFrame();
end

function S:PLAYER_SPECIALIZATION_CHANGED()
    BlinkHealthTextPowerType = GetPowerType()
end

function S:PLAYER_ENTERING_WORLD()
    BlinkHealthTextPowerType = GetPowerType()
end

function S:PLAYER_REGEN_DISABLED()
	self:UpdateUnitFrame();
end

function S:PLAYER_REGEN_ENABLED()
	self:UpdateUnitFrame();
end

function S:UNIT_POWER_UPDATE(event, unit)
	if (unit == "player") then
        if BlinkHealthTextPowerType then
            self:UpdateComboPoints();
        end
	end
end

function S:CreateAnchorFrame()
	if (self.anchor) then return end

	self.anchor = CreateFrame("Button", "SimpleInfoAnchorFrame", UIParent);
	self.anchor:SetWidth(280);
	self.anchor:SetHeight(80);
	self.anchor:EnableMouse(true);
	self.anchor:SetMovable(true);
	self.anchor:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 300);
	local backdrop = {
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tileSize = 16, edgeSize = 16, tile = true,
		insets = {left = 4, right = 4, top = 4, bottom = 4}
	};		
	self.anchor:SetBackdrop(backdrop);
	self.anchor:SetBackdropColor(0.1, 0.1, 0.1, 0.65)
	self.anchor:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
	
	self.anchor.close = CreateFrame("Button", nil, self.anchor, "UIPanelCloseButton");
	self.anchor.close:SetPoint("TOPRIGHT", self.anchor, "TOPRIGHT", -5, -5);

	self.anchor.text = self.anchor:CreateFontString(nil, "OVERLAY");
	self.anchor.text:SetFontObject("SIFontSmall");
	self.anchor.text:SetJustifyH("CENTER");
	self.anchor.text:SetPoint("CENTER");
	self.anchor.text:SetText(L["Move Text"]);
	self.anchor.text:SetTextColor(1, 1, 1);

	self.anchor:RegisterForClicks("LeftButtonDown", "RightButtonDown");
	self.anchor:SetScript("OnMouseDown", function(self, button)
		if (button == "LeftButton") then
			self:StartMoving();
			self.isMoving = true;
		else
			self:Hide();
		end
		
	end);
	self.anchor:SetScript("OnMouseUp", function(self)
		if (self.isMoving) then
			self:StopMovingOrSizing();
		end		
	end);

	--dwRegisterForSaveFrame(self.anchor);
	self.anchor:Hide();
end

function S:ToHexColor(r, g, b)
	return format("%02x%02x%02x", r*255, g*255, b*255);
end

function S:ToHexColorRGB(color)
	return format("%02x%02x%02x", color.r*255, color.g*255, color.b*255);
end

function S:UpdateUnitFrame()
	if (UnitExists("target")) then
		self.frame["player"]:SetAlpha(1);
		self.frame["target"]:SetAlpha(1);
		self.frame["target"]:Show();
	else
		self.frame["player"]:SetAlpha(0.2);
		self.frame["target"]:SetAlpha(0.2);
		self.frame["target"]:Hide();
	end
end

function S:UpdateComboPoints()
	local comboPoints = UnitPower(PlayerFrame.unit, BlinkHealthTextPowerType);
	if (comboPoints and comboPoints > 0) then

        self.hitPoint.text:SetText(comboPoints);
		self.Combo:Show();
		for i=1, 10 do
			self.Combo[i]:Hide();
		end

		for i=1, comboPoints do
			self.Combo[i]:Show();
		end
	else
		self.Combo:Hide();
        self.hitPoint.text:SetText("");
        self.hitPoint.hit:SetText("");
	end

	if (self.castBar and self.castBar:IsShown()) then
		self:CastingBarAdjustPosition();
	end
end

function S:UpdateUnitValues()
	local heal, maxheal, perh, petheal, petmax, name;
	local power, maxpower, powertype, _;
	-- player
	if (UnitHasVehicleUI("player")) then
		heal, maxheal = UnitHealth("pet"), UnitHealthMax("pet");
		power, maxpower = UnitPower("pet"), UnitPowerMax("pet");
		petheal, petmax = UnitHealth("player"), UnitHealthMax("player");
		name = UnitName("player");	-- petName
		_, powertype = UnitPowerType("pet");
	else
		heal, maxheal = UnitHealth("player"), UnitHealthMax("player");
		power, maxpower = UnitPower("player"), UnitPowerMax("player");
		petheal, petmax = UnitHealth("pet"), UnitHealthMax("pet");
		name = UnitName("pet");
		_, powertype = UnitPowerType("player");
	end
	
	perh = heal/maxheal * 100 + 0.5;
	self:SetPercentText("player", perh);
	local hexColor = self:ToHexColor(1, 0.65, 0.16);
	heal, maxheal = self:FormatDigit(heal), self:FormatDigit(maxheal);
	self.frame["player"].heal:SetFormattedText("|cff%s%s/%s|r", hexColor, heal, maxheal);	
	if (type(maxpower) == "number" and maxpower > 0 and PowerBarColor[powertype]) then
        hexColor = self:ToHexColorRGB(PowerBarColor[powertype]);
		power, maxpower = self:FormatDigit(power), self:FormatDigit(maxpower);
		self.frame["player"].power:SetFormattedText("|cff%s%s/%s|r", hexColor, power, maxpower);
		self.frame["player"].power:Show();
	else
		self.frame["player"].power:Hide();
	end
	-- pet
	hexColor = self:ToHexColor(1, 0.65, 0.16);
	if (type(petmax) == "number" and petmax > 0 and name) then
		perh = petheal/petmax*100+0.5
		self.frame["player"].pet:SetFormattedText("|cff%s%s@%d%%|<r", hexColor, name, perh);
		self.frame["player"].pet:Show();
	else
		self.frame["player"].pet:Hide();
	end

	-- target
	local hexH, hexP;
	if (UnitExists("target")) then
		heal, maxheal = UnitHealth("target"), UnitHealthMax("target");
		power, maxpower = UnitPower("target"), UnitPowerMax("target");
		_, powertype = UnitPowerType("target");
		name = UnitName("target");
		perh = heal/maxheal * 100 + 0.5;
		self:SetPercentText("target", perh);		
		heal, maxheal = self:FormatDigit(heal), self:FormatDigit(maxheal);
		local hexH = self:ToHexColor(1, 0.65, 0.16);
		if (powertype and PowerBarColor[powertype] and type(maxpower) == "number" and maxpower > 0) then
			hexP = self:ToHexColorRGB(PowerBarColor[powertype]);
			power, maxpower = self:FormatDigit(power), self:FormatDigit(maxpower);
			--self.frame["target"].heal:SetFormattedText("|cff%s%s/%s|r | |cff%s%s/%s|r", hexH, heal, maxheal, hexP, power, maxpower);
			self.frame["target"].heal:SetFormattedText("|cff%s%s/%s|r", hexH, heal, maxheal);
			self.frame["target"].power:SetFormattedText("|cff%s%s/%s|r", hexP, power, maxpower);
			self.frame["target"].power:Show();
		else
			self.frame["target"].heal:SetFormattedText("|cff%s%s/%s|r", hexH, heal, maxheal);
			self.frame["target"].power:Hide();
		end

		if (UnitIsPlayer("target")) then
			local _, class = UnitClass("target");
			hexColor = self:ToHexColor(unpack(self.classColor[class]));
		else
			hexColor = self:ToHexColor(UnitSelectionColor("target"));
		end
		self.frame["target"].name:SetFormattedText("|cff%s%s|r", hexColor, name);
	
		if (UnitExists("targettarget")) then
			heal, maxheal = UnitHealth("targettarget"), UnitHealthMax("targettarget");
			perh = heal/maxheal*100+0.5
			hexColor = self:ToHexColor(1, 0.65, 0.16);
			name = UnitName("targettarget");
			if (UnitIsUnit("targettarget", "player")) then
				name = L["YOU"];
			end
			self.frame["target"].tot:SetFormattedText("|cff%s>%s@%d%%|r", hexColor, name, perh);
			self.frame["target"].tot:Show();
		else
			self.frame["target"].tot:Hide();
		end
	end
end

function S:SetDigit(texObj, digit)
	texObj:SetWidth(self.digitTexCoords[digit][2]);
	texObj:SetHeight(self.digitTexCoords["height"]);
	texObj:SetTexCoord(self.digitTexCoords[digit][1] / self.digitTexCoords["texWidth"], (self.digitTexCoords[digit][1] + self.digitTexCoords[digit][2]) / self.digitTexCoords["texWidth"], 0.0078125, 0.3359375);
	texObj:Show();
	texObj.fill:SetWidth(self.digitTexCoords[digit][2]);
	texObj.fill:SetHeight(self.digitTexCoords["height"]);
	texObj.fill:SetTexCoord(self.digitTexCoords[digit][1] / self.digitTexCoords["texWidth"], (self.digitTexCoords[digit][1] + self.digitTexCoords[digit][2]) / self.digitTexCoords["texWidth"], 0.34375, 0.671875);
	texObj.fill:Show();
end

function S:SetPercentText(unit, percent)	
	local health = self.frame[unit].health;	
	local hPerc = ("%d%%"):format(percent);
	local len = string.len(hPerc);

	for i = 1, 4 do
		if i > len then
			health[5 - i]:Hide();
			health[5 - i].fill:Hide();
		else
			local digit;
			if unit == "player" then
				digit = string.sub(hPerc , -i, -i);
			else
				digit = string.sub(hPerc , i, i);
			end

			self:SetDigit(health[5 - i], digit);
		end
	end
	
	if (percent == 0.5) then
		for i = 1, 4 do			
			health[5 - i].fill:Hide();
		end
	end
end

function S:SetPercentTextColor(unit, r, g, b)
	local health = self.frame[unit].health;
	for i=1, 4 do
		health[i].fill:SetVertexColor(r, g, b);
	end
end

function S:FormatDigit(digit)
    if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
        if (digit > 99999999) then
    		return format("%.1亿", digit/100000000);
    	elseif (digit > 99999) then
    		return L["wan"]:format(digit/10000);
        end
    else
        if (digit > 999999) then
            return L["baiwan"]:format(digit/1000000);
        elseif (digit > 9999) then
            return L["wan"]:format(digit/10000);
        end
    end

	return digit;
end

function S:ConstructHealth(unit)
	local this = self.frame[unit];
	local health = {}
	local healthFill = {}
	for i = 1, 4 do
		health[i] = this:CreateTexture(nil, "ARTWORK")
		health[i]:SetTexture("Interface\\AddOns\\BlinkHealthText\\textures\\digits")
		health[i]:Hide()
		healthFill[i] = this:CreateTexture(nil, "OVERLAY")
		healthFill[i]:SetTexture("Interface\\AddOns\\BlinkHealthText\\textures\\digits")
		healthFill[i]:SetVertexColor(1, 0.65, 0.16);
		healthFill[i]:Hide()
		health[i].fill = healthFill[i];
	end

	if unit == "player" then
		health[4]:SetPoint("RIGHT");
		health[3]:SetPoint("RIGHT", health[4], "LEFT");
		health[2]:SetPoint("RIGHT", health[3], "LEFT");
		health[1]:SetPoint("RIGHT", health[2], "LEFT");
	else
		health[4]:SetPoint("LEFT");
		health[3]:SetPoint("LEFT", health[4], "RIGHT");
		health[2]:SetPoint("LEFT", health[3], "RIGHT");
		health[1]:SetPoint("LEFT", health[2], "RIGHT");
	end
		
	healthFill[4]:SetPoint("BOTTOM", health[4]);
	healthFill[3]:SetPoint("BOTTOM", health[3]);
	healthFill[2]:SetPoint("BOTTOM", health[2]);
	healthFill[1]:SetPoint("BOTTOM", health[1]);

	this.health = health;
	this.healthFill = healthFill;

	-- Power, heal
	local heal, power;
	heal = this:CreateFontString(nil, "OVERLAY");
	power = this:CreateFontString(nil, "OVERLAY");
	heal:SetFontObject("SIFontMedium");
	power:SetFontObject("SIFontMedium");
	if unit == "player" then 
		heal:SetPoint("TOPRIGHT", health[3], "BOTTOMRIGHT", 0, -2);
		power:SetPoint("BOTTOMRIGHT", this, "BOTTOMRIGHT", -95, 5);
	else
		heal:SetPoint("TOPLEFT", health[4], "BOTTOMLEFT", 6, -2);
		power:SetPoint("BOTTOMLEFT", this, "BOTTOMLEFT", 100, 5);
	end

	this.power = power;
	this.heal = heal;

	-- Name
	local name, pet, tot;
	if (unit == "player") then
		pet = this:CreateFontString(nil, "OVERLAY");
		pet:SetFontObject("SIFontSmall");
		pet:SetPoint("BOTTOMRIGHT", health[4], "TOPRIGHT", 0, 0);
		this.pet = pet;
	else
		name = this:CreateFontString(nil, "OVERLAY");
		name:SetFontObject("SIFontBig");
		name:SetPoint("BOTTOMLEFT", health[1], "BOTTOMRIGHT", -15, 20);
			
		tot = this:CreateFontString(nil, "OVERLAY");
		tot:SetFontObject("SIFontSmall");
		tot:SetPoint("BOTTOMLEFT", health[4], "TOPLEFT", 0, 0);
		this.tot = tot;		
	end

	this.name = name;
end
--------------
-- 连击点
function S:ConstructCombo()
    if self.Combo then return end
	local this = self.frame["target"];
	self.Combo = CreateFrame("Frame", nil, this);
	self.Combo:SetWidth(80)
	self.Combo:SetHeight(16)
	self.Combo:SetPoint("TOPLEFT", this.heal, "BOTTOMLEFT", 0, 0);
	local bg, fill = {}, {};
	for i = 1, 10 do
		self.Combo[i] = CreateFrame("Frame", nil, self.Combo)
		self.Combo[i]:SetWidth(16)
		self.Combo[i]:SetHeight(16)
		if i == 1 then 
			self.Combo[i]:SetPoint("LEFT", self.Combo, "LEFT")
		else
			self.Combo[i]:SetPoint("LEFT", self.Combo[i - 1], "RIGHT") 
		end
		bg[i] = self.Combo[i]:CreateTexture(nil, "ARTWORK")
		bg[i]:SetTexture("Interface\\AddOns\\BlinkHealthText\\textures\\combo.blp")
		bg[i]:SetTexCoord(0, 16 / 64, 0, 1)
		bg[i]:SetAllPoints(self.Combo[i])
		fill[i] = self.Combo[i]:CreateTexture(nil, "OVERLAY")
		fill[i]:SetTexture("Interface\\AddOns\\BlinkHealthText\\textures\\combo.blp")
		fill[i]:SetTexCoord(0.5, 0.75, 0, 1)
		fill[i]:SetVertexColor(1, 1, 0)
		fill[i]:SetAllPoints(self.Combo[i])
	end
	self.Combo:Hide();
	self.Combo.bg = bg;
	self.Combo.fill = fill;	
end
--------------------
-- 符文条
do
function S:ConstructRunes()
	local this = self.frame["player"];
	self.Runes = CreateFrame("Frame", nil, this)	
	self.Runes:SetWidth(96)
	self.Runes:SetHeight(16)
	self.Runes:SetPoint("TOPRIGHT", this.heal, "BOTTOMRIGHT", 0, -1);
	self.Runes:Hide();

	for i = 1, 6 do
		self.Runes[i] = CreateFrame("StatusBar", nil, self.Runes)
		self.Runes[i]:SetStatusBarTexture("Interface\\AddOns\\BlinkHealthText\\textures\\blank.blp")
		self.Runes[i]:SetWidth(16)
		self.Runes[i]:SetHeight(16)

		if i == 1 then
			self.Runes[i]:SetPoint("TOPLEFT", self.Runes, "TOPLEFT")
		else
			self.Runes[i]:SetPoint("LEFT", self.Runes[i - 1], "RIGHT")
		end

		local backdrop = self.Runes[i]:CreateTexture(nil, "ARTWORK")
		backdrop:SetWidth(16)
		backdrop:SetHeight(16)
		backdrop:SetAllPoints()
		backdrop:SetTexture("Interface\\AddOns\\BlinkHealthText\\textures\\combo.blp")
		backdrop:SetTexCoord(0, 16 / 64, 0, 1)
				
		-- This is actually the fill layer, but "bg" gets automatically vertex-colored by the runebar module. So let's make use of that!
		self.Runes[i].bg = self.Runes[i]:CreateTexture(nil, "OVERLAY")
		self.Runes[i].bg:SetWidth(16)
		self.Runes[i].bg:SetHeight(16)
		self.Runes[i].bg:SetPoint("BOTTOM")
		self.Runes[i].bg:SetTexture("Interface\\AddOns\\BlinkHealthText\\textures\\combo.blp")
		self.Runes[i].bg:SetTexCoord(0.5, 0.75, 0, 1)
				
		-- Shine effect
		local shinywheee = CreateFrame("Frame", nil, self.Runes[i])
		shinywheee:SetAllPoints()
		shinywheee:SetAlpha(0)
		shinywheee:Hide()
				
		local shine = shinywheee:CreateTexture(nil, "OVERLAY")
		shine:SetAllPoints()
		shine:SetPoint("CENTER")
		shine:SetTexture("Interface\\Cooldown\\star4.blp")
		shine:SetBlendMode("ADD")

		local anim = shinywheee:CreateAnimationGroup()
		local alphaIn = anim:CreateAnimation("Alpha")
	--	alphaIn:SetChange(0.3)
		alphaIn:SetFromAlpha(0)
		alphaIn:SetToAlpha(0.3)		
		alphaIn:SetDuration(0.4)
		alphaIn:SetOrder(1)
		local rotateIn = anim:CreateAnimation("Rotation")
		rotateIn:SetDegrees(-90)
		rotateIn:SetDuration(0.4)
		rotateIn:SetOrder(1)
		local scaleIn = anim:CreateAnimation("Scale")
		scaleIn:SetScale(2, 2)
		scaleIn:SetOrigin("CENTER", 0, 0)
		scaleIn:SetDuration(0.4)
		scaleIn:SetOrder(1)
		local alphaOut = anim:CreateAnimation("Alpha")
	--	alphaOut:SetChange(-0.5)
		alphaOut:SetFromAlpha(0.5)
		alphaOut:SetToAlpha(0)			
		alphaOut:SetDuration(0.4)
		alphaOut:SetOrder(2)
		local rotateOut = anim:CreateAnimation("Rotation")
		rotateOut:SetDegrees(-90)
		rotateOut:SetDuration(0.3)
		rotateOut:SetOrder(2)
		local scaleOut = anim:CreateAnimation("Scale")
		scaleOut:SetScale(-2, -2)
		scaleOut:SetOrigin("CENTER", 0, 0)
		scaleOut:SetDuration(0.4)
		scaleOut:SetOrder(2)
				
		anim:SetScript("OnFinished", function() shinywheee:Hide() end)
		shinywheee:SetScript("OnShow", function() anim:Play() end)
				
		-- Fill the dots
		self.Runes[i]:SetScript("OnValueChanged", function(self, val)
			-- Resize round overlay texture when hidden statusbar changes
			if (({GetRuneCooldown(self:GetID())})[3]) then
				-- Rune ready: show all 16x16px, play animation
				self.bg:SetWidth(16)
				self.bg:SetHeight(16)
				self.bg:SetTexCoord(0.5, 0.75, 0, 1)
				shinywheee:Show()
			else
				-- Dot distance from top & bottom of texture: 4px
				self.bg:SetWidth(16)
				self.bg:SetHeight(4 + 8 * val / 10)
				self.bg:SetTexCoord(0.25, 0.5, 12 / 16 - 8 * val / 10 / 16, 1)
			end
		end)
	end
end

local OnUpdate = function(self, elapsed)
	local duration = self.duration + elapsed
	if(duration >= self.max) then
		return self:SetScript("OnUpdate", nil)
	else
		self.duration = duration
		return self:SetValue(duration)
	end
end

function S:UpdateRuneType(event, rid)	
	local runeType = 3 --GetRuneType(rid);
	local colors = self.runeColors[runeType]
	local rune = self.Runes[rid];
	local r, g, b = colors[1], colors[2], colors[3];

	rune:SetStatusBarColor(r, g, b);

	if(rune.bg) then
		rune.bg:SetVertexColor(r, g, b);
	end
end

function S:UpdateRune(event, rid)
	local rune = self.Runes[rid]
	if(rune) then
		local start, duration, runeReady = GetRuneCooldown(rune:GetID())
		if(runeReady) then
			rune:SetMinMaxValues(0, 1)
			rune:SetValue(1)
			rune:SetScript("OnUpdate", nil)
		else
			rune.duration = GetTime() - start
			rune.max = duration
			rune:SetMinMaxValues(1, duration)
			rune:SetScript("OnUpdate", OnUpdate)
		end
	end
end

function S:EnableRune()
	local runes = self.Runes;
	
	for i=1, 6 do
		local rune = runes[i];
		rune:SetID(i);
		self:UpdateRuneType(nil, i);
	end

	self:RegisterEvent("RUNE_POWER_UPDATE", "UpdateRune");
	--self:RegisterEvent("RUNE_TYPE_UPDATE", "UpdateRuneType"); --aby8

	runes:Show();
end

function S:DisableRune()
	self.Runes:Hide();

	self:UnregisterEvent("RUNE_POWER_UPDATE");
	--self:UnregisterEvent("RUNE_TYPE_UPDATE"); --aby8
end
end
----------------------
-- 施法条
do
local function OnEvent(self, event, ...)
	local arg1 = ...;
	if ( event == "PLAYER_TARGET_CHANGED" ) then
		-- check if the new target is casting a spell
		local nameChannel  = UnitChannelInfo("target");
		local nameSpell  = UnitCastingInfo("target");
		if ( nameChannel ) then
			event = "UNIT_SPELLCAST_CHANNEL_START";
			arg1 = "target";
		elseif ( nameSpell ) then
			event = "UNIT_SPELLCAST_START";
			arg1 = "target";
		else
			self.casting = nil;
			self.channeling = nil;
			self:SetMinMaxValues(0, 0);
			self:SetValue(0);
			self:Hide();
			return;
		end		
	end

	S:CastingBarAdjustPosition();
	CastingBarFrame_OnEvent(self, event, arg1, select(2, ...));
end

function S:CastingBarAdjustPosition()
	if (self.Combo) then
		self.castBar:ClearAllPoints();
		if (self.Combo[1]:IsVisible()) then
			self.castBar:SetPoint("TOPLEFT", self.Combo, "BOTTOMLEFT", 24, -5);
		else
			self.castBar:SetPoint("TOPLEFT", self.frame["target"].heal, "BOTTOMLEFT", 26, -5);
		end
	end
end

function S:ConstructCastingBar()	
	self.castBar = CreateFrame("StatusBar", "SimpleInfoTargetCastingBar", UIParent, "CastingBarFrameTemplate");
	self.castBar:SetWidth(120);
	self.castBar:SetHeight(15);
	self.castBar:Hide();
	self.castBar:SetPoint("TOPLEFT", self.frame["target"].heal, "BOTTOMLEFT", 26, -5);
	
	local name = self.castBar
	self.castBar:SetStatusBarTexture("Interface\\AddOns\\BlinkHealthText\\textures\\flat");
	name.Border:SetAlpha(0);
	name.BorderShield:SetAlpha(0);
	name.Flash:SetTexture("");
	self.castBar.bg = CreateFrame("Frame", nil, self.castBar);
	self.castBar.bg:SetFrameStrata("BACKGROUND");
	self.castBar.bg:SetPoint("TOPLEFT", self.castBar, "TOPLEFT", -5, 5);
	self.castBar.bg:SetPoint("BOTTOMRIGHT", self.castBar, "BOTTOMRIGHT", 5, -5);
		
	local backdrop = {
		bgFile = "Interface\\AddOns\\BlinkHealthText\\textures\\flat",
		edgeFile = "Interface\\AddOns\\BlinkHealthText\\textures\\2px_glow",
		tileSize = 16, edgeSize = 16, tile = true,
		insets = {left = 4, right = 4, top = 4, bottom = 4}
	};
		
	self.castBar.bg:SetBackdrop(backdrop);
	self.castBar.bg:SetBackdropColor(0.22, 0.22, 0.19);
	self.castBar.bg:SetBackdropBorderColor(0, 0, 0, 1);
	self.castBar.bg:SetAlpha(0.6);

	self.castBar:RegisterEvent("PLAYER_TARGET_CHANGED");
	CastingBarFrame_OnLoad(self.castBar, "target", false, true);
	self.castBar:SetScript("OnEvent", OnEvent);
	
	

	local barIcon = name.Icon
	barIcon:SetWidth(18);
	barIcon:SetHeight(18);
	barIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	barIcon:Show();

	name.Text:SetFontObject(SystemFont_Shadow_Small);	
	name.Text:ClearAllPoints();
	name.Text:SetPoint("LEFT", self.castBar, "LEFT", 4, 1);
	name.Text:SetJustifyH("LEFT");
	name.Text:SetWidth(100);
end
end

function S:ConstructFrame(unit)
	self.frame[unit] = CreateFrame("Frame", "SimpleInfoPlayerFrame" .. unit, UIParent);
	self.frame[unit]:SetWidth(200);
	self.frame[unit]:SetHeight(50);
	if (unit == "player") then
		self.frame[unit]:SetPoint("BOTTOMRIGHT", self.anchor, "BOTTOM", -60, 0);
	else
		self.frame[unit]:SetPoint("BOTTOMLEFT", self.anchor, "BOTTOM", 60, 0);
	end
	self:ConstructHealth(unit);	
end

function S:CreateHitAnchor()
	if (self.HitAnchor) then return end

	self.HitAnchor = CreateFrame("Button", "SimpleInfoHitPointAnchorFrameNew", UIParent);
	self.HitAnchor:SetSize(100, 80);
	self.HitAnchor:EnableMouse(true);
	self.HitAnchor:SetMovable(true);
	self.HitAnchor:SetPoint("CENTER", UIParent, "CENTER", 127, -70);
	local backdrop = {
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tileSize = 16, edgeSize = 10, tile = true,
		insets = {left = 2, right = 2, top = 2, bottom = 2}
	};		
	self.HitAnchor:SetBackdrop(backdrop);
	self.HitAnchor:SetBackdropColor(0.1, 0.1, 0.1, 0.65)
	self.HitAnchor:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
	
	self.HitAnchor.close = CreateFrame("Button", nil, self.HitAnchor, "UIPanelCloseButton");
	self.HitAnchor.close:SetPoint("TOPRIGHT", self.HitAnchor, "TOPRIGHT", 1, 1);

	self.HitAnchor.text = self.HitAnchor:CreateFontString(nil, "OVERLAY");
	self.HitAnchor.text:SetFont("Interface\\Addons\\BlinkHealthText\\Fonts\\REDCIRCL.ttf", 100, "OUTLINE");
	self.HitAnchor.text:SetPoint("LEFT", self.HitAnchor, "LEFT", 20, -5);
	self.HitAnchor.text:SetJustifyH("RIGHT");
	self.HitAnchor.text:SetTextColor(1.0, 0.69, 0.0);
	self.HitAnchor.text:SetText("5");

	self.HitAnchor.hit = self.HitAnchor:CreateFontString(nil, "OVERLAY");
	self.HitAnchor.hit:SetFont("Interface\\Addons\\BlinkHealthText\\Fonts\\REDCIRCL.ttf", 14, "OUTLINE");
	self.HitAnchor.hit:SetPoint("BOTTOMLEFT", self.HitAnchor.text, "BOTTOMRIGHT", 5, 16);
	self.HitAnchor.hit:SetTextColor(1.0, 0.69, 0.0);
	self.HitAnchor.hit:SetText("hit");

	self.HitAnchor:RegisterForClicks("LeftButtonDown", "RightButtonDown");
	self.HitAnchor:SetScript("OnMouseDown", function(self, button)
		if (button == "LeftButton") then
			self:StartMoving();
			self.isMoving = true;
		else
			self:Hide();
		end
		
	end);
	self.HitAnchor:SetScript("OnMouseUp", function(self)
		if (self.isMoving) then
			self:StopMovingOrSizing();
		end		
	end);

	--dwRegisterForSaveFrame(self.HitAnchor);
	self.HitAnchor:Hide();
end

function S:ConstructHitPoints()
	self:CreateHitAnchor();
	if (not self.hitPoint) then
		self.hitPoint = CreateFrame("Frame", nil, UIParent);
		self.hitPoint:SetWidth(100);
		self.hitPoint:SetHeight(80);
		self.hitPoint:SetPoint("CENTER", self.HitAnchor, "CENTER", 0, 0);
		
		self.hitPoint.text = self.hitPoint:CreateFontString(nil, "OVERLAY");
		self.hitPoint.text:SetFont("Interface\\Addons\\BlinkHealthText\\Fonts\\REDCIRCL.ttf", 75, "OUTLINE");
		self.hitPoint.text:SetPoint("LEFT", self.HitAnchor, "LEFT", 20, -5);
		self.hitPoint.text:SetJustifyH("RIGHT");
		self.hitPoint.text:SetTextColor(1.0, 0.69, 0.0);
		self.hitPoint.text:SetText("");

		self.hitPoint.hit = self.hitPoint:CreateFontString(nil, "OVERLAY");
		self.hitPoint.hit:SetFont("Interface\\Addons\\BlinkHealthText\\Fonts\\REDCIRCL.ttf", 14, "OUTLINE");
		self.hitPoint.hit:SetPoint("BOTTOMLEFT", self.hitPoint.text, "BOTTOMRIGHT", 5, 16);
		self.hitPoint.hit:SetTextColor(1.0, 0.69, 0.0);
	end	
end

function S:ToggleCastingBar(switch)
	if (switch) then
		self.castBar.showCastbar = true;
	else
		self.castBar.showCastbar = false;
		self.castBar:Hide();
	end
end

-- BlinkHealth:ToggleCastingBar();
function S:ShowAnchor()
	self.anchor:Show();
end

function S:ToggleNameVisible(switch)
	if (switch) then
		self.frame["target"].name:Show();
	else
		self.frame["target"].name:Hide();
	end
end

function S:ToggleRuneFrameVisible(switch)
	if (switch) then	
		self:EnableRune();
		self:ScheduleTimer("EnableRune", 1);
	else
		self:DisableRune();
	end
end

function S:ToggleHitPoint(switch)
	if (switch) then
		self.hitPoint:Show();
		self.Combo:SetAlpha(0);
	else
		self.hitPoint:Hide();
		self.Combo:SetAlpha(1);
	end
end

function S:ShowHitAnchor()
	self.HitAnchor:Show();
end

function S:SetHitPointSize(v)
    self.hitPoint.text:SetFont("Interface\\Addons\\BlinkHealthText\\Fonts\\REDCIRCL.ttf", v, "OUTLINE");
end