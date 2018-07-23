
local LMB = LibStub("Masque", true) or (LibMasque and LibMasque("Button"))
if not LMB then return end

local f = CreateFrame("Frame")

local function NULL()
end
local Buffs = LMB:Group("Blizzard Buffs", "Buffs")
local Debuffs = LMB:Group("Blizzard Buffs", "Debuffs")
local TempEnchant = LMB:Group("Blizzard Buffs", "TempEnchant")

local function OnEvent(self, event, addon)
	for i=1, BUFF_MAX_DISPLAY do
		local buff = _G["BuffButton"..i]
		if buff then
			Buffs:AddButton(buff)
		end
		if not buff then break end
	end
	
	for i=1, BUFF_MAX_DISPLAY do
		local debuff = _G["DebuffButton"..i]
		if debuff then
			Debuffs:AddButton(debuff)
		end
		if not debuff then break end
	end
	
	for i=1, NUM_TEMP_ENCHANT_FRAMES do
		local f = _G["TempEnchant"..i]
		--_G["TempEnchant"..i.."Border"].SetTexture = NULL
		if TempEnchant then
			TempEnchant:AddButton(f)
		end
		_G["TempEnchant"..i.."Border"]:SetVertexColor(.75, 0, 1)
	end
	
	f:SetScript("OnEvent", nil)
end


hooksecurefunc("CreateFrame", function (_, name, parent) --dont need to do this for TempEnchant enchant frames because they are hard created in xml
	if parent ~= BuffFrame or type(name) ~= "string" then return end
	if strfind(name, "^DebuffButton%d+$") then
		Debuffs:AddButton(_G[name])
		Debuffs:ReSkin() -- Needed to prevent issues with stack text appearing under the frame.
	elseif strfind(name, "^BuffButton%d+$") then
		Buffs:AddButton(_G[name])
		Buffs:ReSkin() -- Needed to prevent issues with stack text appearing under the frame.
	end
end
)
	
f:SetScript("OnEvent", OnEvent)
f:RegisterEvent("PLAYER_ENTERING_WORLD")

