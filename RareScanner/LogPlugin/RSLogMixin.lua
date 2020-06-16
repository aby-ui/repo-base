-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local RareScanner = LibStub("AceAddon-3.0"):GetAddon("RareScanner")
local ADDON_NAME, private = ...

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");
	
RSLogMixin = { };

function RSLootMixin:OnLoad()
	self:EnableKeyboard(true)
end

function RSLootMixin:OnMouseEnter()
	self.Icon.Anim:Play();
end
 
function RSLootMixin:OnMouseLeave()
	self.Icon.Anim:Stop();
end

function RSLootMixin:OnMouseDown()
	if (private.db.general.showMaker) then
		self:SetAttribute("macrotext", "/cleartarget\n/targetexact "..self.name.."\n/tm "..private.db.general.marker)
	else
		self:SetAttribute("macrotext", "/cleartarget\n/targetexact "..self.name)
	end
end

function RSLootMixin:AddLog(npcID, name)
	self.npcID = npcID
	self.name = name
	self.TargetButton:SetAttribute("type", "macro")
	self.TargetButton.Text:SetText(name)
	self:SetPoint("TOP", self:GetParent(), "BOTTOM", 0, -3)
end