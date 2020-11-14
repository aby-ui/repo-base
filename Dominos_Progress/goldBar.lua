local _, Addon = ...
local Dominos = _G.Dominos
local GoldBar = Dominos:CreateClass("Frame", Addon.ProgressBar)


function GoldBar:Init()
	self:Update()
	self:SetColor(Addon.Config:GetColor("gold"))
	self:SetBonusColor(Addon.Config:GetColor("gold_realm"))
end

function GoldBar:Update()
	local gold = GetMoney("player")
	local max = Addon.Config:GoldGoal()

	if DataStore then
	    realm = 0
         for _, c in pairs(DataStore:GetCharacters()) do
             realm = realm + DataStore:GetMoney(c)
         end
         realm = realm - gold
	else
	    realm = 0
	end

     if max == 0 then
         max = (gold + realm) / 10000
     end

	self:SetValues(gold, max*10000, realm)
	self:UpdateText(_G.MONEY, gold/10000, max, realm/10000)
end

function GoldBar:IsModeActive()
     local goal = Addon.Config:GoldGoal()
	return goal and goal > 0
end

-- register this as a possible progress bar mode
Addon.progressBarModes = Addon.progressBarModes or {}
Addon.progressBarModes["gold"] = GoldBar
Addon.GoldBar = GoldBar
