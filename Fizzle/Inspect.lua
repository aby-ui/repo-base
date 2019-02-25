local mod = Fizzle:NewModule("Inspect", "AceHook-3.0", "AceEvent-3.0")
local _G = _G
local ipairs, smatch, tonumber = ipairs, string.match, tonumber
local slots = {
	"Head",
	"Shoulder",
	"Chest",
	"Waist",
	"Legs",
	"Feet",
	"Wrist",
	"Hands",
	"MainHand",
	"SecondaryHand",
	"Ranged",
	"Ammo",
	"Neck",
	"Back",
	"Finger0",
	"Finger1",
	"Trinket0",
	"Trinket1",
	"Relic",
	"Tabard",
	"Shirt",
}
local booted = false
-- Make some blizz functions more local
local UnitIsPlayer = UnitIsPlayer
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local GetInventoryItemLink = GetInventoryItemLink
local L = LibStub("AceLocale-3.0"):GetLocale("Fizzle")
mod.modName = L["Inspect"]

function mod:OnInitialize()
	self.db = Fizzle.db:RegisterNamespace("Inspect")
end

function mod:OnEnable()
	if IsAddOnLoaded("Blizzard_InspectUI") then
		self:SecureHookScript(InspectFrame, "OnShow", "InspectFrame_OnShow")
		self:SecureHookScript(InspectFrame, "OnHide", "InspectFrame_OnHide")
		self:InspectFrame_OnShow()
	else
		self:RegisterEvent("ADDON_LOADED")
	end
end

function mod:OnDisable()
	-- Hide all borders if we get disabled.
	for _, item in ipairs(slots) do
		local border = _G[item .."FizzspectB"]
		if border then
			border:Hide()
		end
	end
end

function mod:CreateBorders()
	for _, item in ipairs(slots) do
		-- Create borders
		Fizzle:CreateBorder("Inspect", item, "Fizzspect", false)
	end
	booted = true
end

local function GetItemID(link)
	return tonumber(smatch(link, "item:(%d+)") or smatch(link, "%d+"))
end

-- iLevel add
function HGetItemLevel(link)
	  local levelAdjust={ -- 11th item:id field and level adjustment
		["0"]=0,["1"]=8,["373"]=4,["374"]=8,["375"]=4,["376"]=4,
		["377"]=4,["379"]=4,["380"]=4,["445"]=0,["446"]=4,["447"]=8,
		["451"]=0,["452"]=8,["453"]=0,["454"]=4,["455"]=8,["456"]=0,
		["457"]=8,["458"]=0,["459"]=4,["460"]=8,["461"]=12,["462"]=16,
		["465"]=0,["466"]=4,["467"]=8,["468"]=0,["469"]=4,["470"]=8,
		["471"]=12,["472"]=16,["476"]=0,["477"]=4,["478"]=8,["479"]=0,
		["480"]=8,["491"]=0,["492"]=4,["493"]=8,["494"]=0,["495"]=4,
		["496"]=8,["497"]=12,["498"]=16,["501"]=0,["502"]=4,["503"]=8,
		["504"]=12,["505"]=16,["506"]=20,["507"]=24}

	  local baseLevel = select(4,GetItemInfo(link))
	  local upgrade = string.match(link,":(%d+)\124h%[")
	  if baseLevel and upgrade then
		return baseLevel + (levelAdjust[upgrade] or 0)
	  else
		return baseLevel
	  end
end

function mod:UpdateBorders()
    CoreScheduleBucket("FIZZILE", 0.2, mod.UpdateBordersInner, mod)
end

function mod:UpdateBordersInner()
	if not InspectFrame:IsVisible() then return end
	if not UnitIsPlayer("target") then return end
	-- Now colour the borders.
	for _, item in ipairs(slots) do
		local id
		if _G["Character".. item .."Slot"] then
			id = _G["Character".. item .."Slot"]:GetID()
		end
		if id then
			local link = GetInventoryItemLink("target", id)
			local border = _G[item .."FizzspectB"]
			local iLevelStr = _G[item.."FizzspectiLevel"]
			if link and border then
				local _, _, quality, iLevel = GetItemInfo(link)
				-- iLevel add
                if (U1GetRealItemLevel) then
                    iLevel = U1GetRealItemLevel(link, "target", id);
                else
				    iLevel= HGetItemLevel(link);
                end
				
				if quality then
					local r, g, b = GetItemQualityColor(quality)
					border:SetVertexColor(r, g, b)
					border:Show()
					if false and Fizzle.db.profile.inspectiLevel then
						iLevelStr:SetText(iLevel)
                        if U1GetInventoryLevelColor then
                            iLevelStr:SetTextColor(U1GetInventoryLevelColor(iLevel, quality))
                        end
						iLevelStr:Show()
					end
				else
					border:Hide()
					iLevelStr:Hide()
                end
                if not U1GetCfgValue("fizzle/glow") then border:Hide() end
			else
				if border then
					border:Hide()
				end
				if iLevelStr then
					iLevelStr:Hide()
				end
			end
		end
	end
end

function mod:ADDON_LOADED(event, addonname)
	-- If the Blizzard InspectUI is loading, fire up the addon!
	if addonname == "Blizzard_InspectUI" then
		self:SecureHookScript(InspectFrame, "OnShow", "InspectFrame_OnShow")
		self:SecureHookScript(InspectFrame, "OnHide", "InspectFrame_OnHide")
		self:UnregisterEvent("ADDON_LOADED")
	end
end

function mod:InspectFrame_OnShow()
	-- Create the borders if we're just loading.
	if not booted then
		self:CreateBorders()
	end
	-- Update the borders
	self:UpdateBorders()
	-- Watch for inventory changes
	self:RegisterEvent("UNIT_INVENTORY_CHANGED", "UpdateBorders")
    self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "UpdateBorders")
	-- Watch for target changes.
	if not self:IsHooked("InspectFrame_UnitChanged") then
		self:SecureHook("InspectFrame_UnitChanged", "UpdateBorders")
	end
end

function mod:InspectFrame_OnHide()
	self:Unhook("InspectFrame_UnitChanged")
	self:UnregisterEvent("UNIT_INVENTORY_CHANGED")
    self:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
end
