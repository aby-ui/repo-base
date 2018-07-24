-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print

local SUG = TMW.SUG
local strlowerCache = TMW.strlowerCache
local GetSpellTexture = TMW.GetSpellTexture


local Type = rawget(TMW.Types, "guardian")

if not Type then return end



local Module = SUG:NewModule("guardian", SUG:GetModule("default"))
Module.noMin = true
Module.showColorHelp = false
Module.helpText = L["SUG_TOOLTIPTITLE_GENERIC"]

function Module:OnInitialize()
	self.Table = {}
end
function Module:OnSuggest()
	wipe(self.Table)
	
	Type:RefreshNames()
	for npcID, data in pairs(Type.GuardianInfo) do
		self.Table[npcID] = strlowerCache[data.name]
	end
end
function Module:Table_Get()
	return self.Table
end
function Module:Entry_AddToList_1(f, id)
	local data = Type.GuardianInfo[id]
	local name = data.name
	local triggerSpellName = GetSpellInfo(data.triggerSpell)

	if data.nameKnown then
		f.insert = SUG.inputType == "number" and id or name
		f.insert2 = SUG.inputType ~= "number" and id or name

	else
		f.insert = id
	end

	f.tooltiptitle = name
	f.tooltiptext = L["ICONMENU_GUARDIAN_TRIGGER"]:format(triggerSpellName or "<Invalid spell " .. data.triggerSpell .. ">")
	f.Name:SetText(name)
	f.ID:SetText(id)	

	f.Icon:SetTexture(data.texture)
end
