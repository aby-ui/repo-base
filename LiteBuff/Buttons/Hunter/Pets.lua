------------------------------------------------------------
-- Pets.lua
--
-- Abin
-- 2011/11/13
------------------------------------------------------------

if select(2, UnitClass("player")) ~= "HUNTER" then return end

local InCombatLockdown = InCombatLockdown
local GetStablePetInfo = GetStablePetInfo
local UnitName = UnitName
local UnitIsDead = UnitIsDead
local GetPetIcon = GetPetIcon

local _, addon = ...
local L = addon.L

local spellList = {}
addon:BuildSpellList(spellList, 883)
addon:BuildSpellList(spellList, 83242)
addon:BuildSpellList(spellList, 83243)
addon:BuildSpellList(spellList, 83244)
addon:BuildSpellList(spellList, 83245)

local i
for i = 1, 5 do
	local data = spellList[i]
	data.rawName = data.spell
end

local DISMISS = addon:BuildSpellList(nil, 2641)
local REVIVE = addon:BuildSpellList(nil, 982)
local petAlive

local button = addon:CreateActionButton("HunterPets", L["pets"], nil, nil, "DUAL")
button:SetFlyProtect()
button:SetScrollable(spellList, "spell1")
button:RequireSpell(883)

button:SetAttribute("petalive", DISMISS.spell)
button:SetAttribute("petdead", REVIVE.spell)

function button:OnEnable()
	self:RegisterEvent("PET_STABLE_UPDATE")
	self:RegisterEvent("UNIT_NAME_UPDATE")
end

function button:OnPetAlive(alive)
	petAlive = alive
	self:SetSpell2(alive and DISMISS or REVIVE)
	self:UpdateTimer()
end

button:SetAttribute("_onstate-petstate", [[
	local alive = newstate == 1
	local spell = self:GetAttribute(alive and "petalive" or "petdead")
	self:SetAttribute("spell2", spell)
	self:CallMethod("OnPetAlive", alive, spell)
]])

RegisterStateDriver(button, "petstate", "[@pet,exists,nodead] 1; 0")

function button:PET_STABLE_UPDATE()
	local maxIndex = 1
	local i
	for i = 1, 5 do
--163uiedit
		local icon, name --= GetStablePetInfo(i)
        local spellID, isKnown = GetFlyoutSlotInfo(9, i);
        if spellID and isKnown then
            icon = GetSpellTexture(spellID)
            local petIndex, petName = GetCallPetSpellInfo(spellID);
            if petIndex and petName and petName~="" then
                name = petName
            end
        end
		if icon and name then
			spellList[i].icon = icon
			spellList[i].spell = name
			maxIndex = i
		else
			spellList[i].icon = "Interface\\Icons\\Ability_Hunter_BeastCall"
			spellList[i].spell = spellList[i].rawName
		end
	end

	self:SetMaxIndex(maxIndex)
	self:UpdateSpell()
end

function button:UNIT_NAME_UPDATE(unit)
	if unit == "pet" then
		self:PET_STABLE_UPDATE()
	end
end

local petName, petIcon
function button:OnUpdateTimer()
	if petAlive and petName and petIcon then
		local data = spellList[self.index]
		return data and petName == data.spell and petIcon == data.icon and "NONE" or "Y"
    else
        return not (petAlive and petName) and "R"
    end
end

-- I have no idea, at the moment when UNIT_PET event fires UnitName("pet") often returns nil, so the only solution is
-- to check pet name frequently, update the button only when pet name changes, aweful but fotunately UnitName isn't
-- a heavy call that causes serious performance impact
function button:OnTick()
	local name = UnitName("pet")
	local icon = GetPetIcon()
	if petName ~= name or petIcon ~= icon then
		petName, petIcon = name, icon
		self:UpdateTimer()
	end
end

button.OnEnterWorld = button.PET_STABLE_UPDATE
button.OnLeaveCombat = button.PET_STABLE_UPDATE