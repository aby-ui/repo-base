U1PLUG["MerchantFilterButtons"] = function()

local GetMerchantFilter = _G.GetMerchantFilter
local UnitFactionGroup = _G.UnitFactionGroup
local GameToolTip = _G.GameToolTip
local UnitClass = _G.UnitClass
local GetNumSpecializations = _G.GetNumSpecializations
local GetSpecializationInfo = _G.GetSpecializationInfo
local SetPushed,Buttons

local spacing = 28

local alltexture,allcoord
do
	if UnitFactionGroup("player") == "Neutral" and select(2,UnitClass("player")) == "MONK" then
		alltexture = "Interface\\Glues\\AccountUpgrade\\upgrade-panda"
		allcoord = {0,1,0,1}
	else
		alltexture = "Interface\\COMMON\\icon-"..strlower(UnitFactionGroup("player"))
		allcoord = {0.25,0.75,0.2,0.8}
	end
end

local function BuildButtons()
	Buttons = {
		["ALL"] = {
			text = ALL,
			texture = alltexture,
			coord = allcoord,
			filter = LE_LOOT_FILTER_ALL,
			x = -10
		},
		["BOE"] = {
			text = ITEM_BIND_ON_EQUIP,
			texture = "Interface\\Buttons\\UI-GroupLoot-Coin-Up",
			coord = {0.1,0.9,0.1,0.9},
			filter = LE_LOOT_FILTER_BOE,
			x = -(spacing) - 10,
			y = 2
		},
		["CLASS"] = {
			text = select(1,UnitClass("player")),
			texture = "Interface\\WorldStateFrame\\ICONS-CLASSES",
			coord = CLASS_BUTTONS[select(2,UnitClass("player"))],
			filter = LE_LOOT_FILTER_CLASS,
			x = -(spacing*2) - 10
		}
	}

	local numSpecs = GetNumSpecializations();
	for i = 1, numSpecs do
		local arg1, name, arg3, icon = GetSpecializationInfo(i);
		Buttons["SPEC"..i] = {}
		Buttons["SPEC"..i].text = name;
		Buttons["SPEC"..i].texture = icon;
		Buttons["SPEC"..i].filter = LE_LOOT_FILTER_SPEC1 + i - 1;
		Buttons["SPEC"..i].coord = {0.1,0.9,0.1,0.9};
		Buttons["SPEC"..i].x = (-(spacing)*(i+2))-10;
	end
	
	SetPushed = function(Filter)
		for k,v in pairs(Buttons) do
			local button = _G["MFB_"..k]
			if Filter == v.filter or Filter == LE_LOOT_FILTER_ALL then
				SetDesaturation(_G["MFB_"..k.."_Overlay"], 0)
			else
				SetDesaturation(_G["MFB_"..k.."_Overlay"], 1)			
			end
			if Filter == v.filter then
				button.Flash.flasher:Play()				
				button:SetButtonState("PUSHED", 1)
			else
				if button.Flash.flasher:IsPlaying() then
					button.Flash.flasher:Stop()
				end
				button:SetButtonState("NORMAL")
			end
		end	
	end
	
	for k,v in pairs(Buttons) do
		local button = CreateFrame("Button","MFB_"..k,MerchantFrame,"MainMenuBarMicroButton")
		button.text = v.text
        button:SetSize(28,58) button.Flash:SetPoint("TOPLEFT", -2, -18) --aby8
		button:SetPoint("TOPRIGHT",MerchantFrame,"TOPRIGHT",v.x,-4)
		button:SetScript("OnEnter",function()
			GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
			GameTooltip:AddLine("Merchant Filter");
			GameTooltip:AddLine(v.text);
			GameTooltip:Show();
		end)
		button:SetScript("OnLeave",function()
			GameTooltip:Hide();
		end)
		button:SetNormalTexture("Interface\\Buttons\\UI-MicroButtonCharacter-Up");
		button:SetPushedTexture("Interface\\Buttons\\UI-MicroButtonCharacter-Down");
		button:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight");
		button.overlay = button:CreateTexture("MFB_"..k.."_Overlay","OVERLAY")
		button.overlay:SetSize(18,20)
		button.overlay:SetPoint("TOP",button,"TOP",0,(-30-(v.y or 0)))
		button.overlay:SetTexture(v.texture)
		button.overlay:SetTexCoord(unpack(v.coord))
		button.Flash.flasher = button.Flash:CreateAnimationGroup()
		local fade1 = button.Flash.flasher:CreateAnimation("Alpha")
		fade1:SetDuration(0.5)
		fade1:SetFromAlpha(0) fade1:SetToAlpha(1)
		fade1:SetOrder(1)
		local fade2 = button.Flash.flasher:CreateAnimation("Alpha")
		fade2:SetDuration(0.5)
		fade2:SetFromAlpha(1) fade2:SetToAlpha(0)
		fade2:SetOrder(2)
		button.Flash:SetAlpha(0)
		button.Flash:Show()
		button:SetScript("OnClick",function(self,button)
			MerchantFrame_SetFilter(MerchantFrame,v.filter)
			PlaySound(829) --"igspellbookopen")
			MFB_DB.filter = GetMerchantFilter()
			SetPushed(GetMerchantFilter())
		end)
	end	
	
	SetPushed(GetMerchantFilter())	
end

local f = CreateFrame("frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("MERCHANT_FILTER_ITEM_UPDATE")
f:SetScript("OnEvent", function(self,event,...)
	local arg1, arg2 = ...
	if event == "PLAYER_ENTERING_WORLD" then
		if not MFB_DB then
			MFB_DB = {}
			MFB_DB.filter = GetMerchantFilter()
		end
		MerchantFrame_SetFilter(MFB_DB.filter)
		self:UnregisterEvent(event)
		MerchantFrameLootFilter:Hide()
		BuildButtons()
	elseif event == "MERCHANT_FILTER_ITEM_UPDATE" then
		SetPushed(GetMerchantFilter())
	end
end)
if IsLoggedIn() then f:GetScript("OnEvent")(f, "PLAYER_ENTERING_WORLD") end

end