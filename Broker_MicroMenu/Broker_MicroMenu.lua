-- Broker_MicroMenu by yess
local ldb = LibStub:GetLibrary("LibDataBroker-1.1",true)
local LibQTip = LibStub('LibQTip-1.0')
local L = LibStub("AceLocale-3.0"):GetLocale("Broker_MicroMenu")

local _G, floor, string, GetNetStats, GetFramerate  = _G, floor, string, GetNetStats, GetFramerate
local delay, counter = 1,0
local dataobj, tooltip, db
local color = true
local path = "Interface\\AddOns\\Broker_MicroMenu\\media\\"
local _

local function Debug(...)
	--[===[@debug@
	local s = "Broker_MicroMenu Debug:"
	for i=1,_G.select("#", ...) do
		local x = _G.select(i, ...)
		s = _G.strjoin(" ",s,_G.tostring(x))
	end
	_G.DEFAULT_CHAT_FRAME:AddMessage(s)
	--@end-debug@]===]
end

local function RGBToHex(r, g, b)
	return ("%02x%02x%02x"):format(r*255, g*255, b*255)
end

local mb = _G.MainMenuMicroButton:GetScript("OnMouseUp")
local function mainmenu(self, ...) self.down = 1; mb(self, ...) end

dataobj = ldb:NewDataObject("Broker_MicroMenu", {
	type = "data source",
	icon = path.."green.tga",
	label = "MicroMenu",
	text  = "",
	OnClick = function(self, button, ...)
		if button == "RightButton" then
			if _G.IsModifierKeyDown() then
				mainmenu(self, button, ...)
			else
				dataobj:OpenOptions()
			end
		else
			_G.ToggleCharacter("PaperDollFrame")
		end
		LibQTip:Release(tooltip)
		tooltip = nil
	end
})

-------------------------
-- custom libqtip cell
-------------------------
local myProvider, cellPrototype = LibQTip:CreateCellProvider()

function cellPrototype:InitializeCell()
	self.texture = self:CreateTexture()
	self.texture:SetAllPoints(self)
end

function cellPrototype:SetupCell(tooltip, value, justification, font, iconCoords, unitID,guild)
	local tex = self.texture
	tex:SetWidth(16)
	tex:SetHeight(16)

	if guild then
		_G.SetSmallGuildTabardTextures("player", tex,tex);
	elseif unitID then
		_G.SetPortraitTexture(tex, unitID)
	else
		tex:SetTexture(value)
	end
	if iconCoords then
		tex:SetTexCoord(_G.unpack(iconCoords))
	end
	return tex:GetWidth(), tex:GetHeight()
end

function cellPrototype:ReleaseCell()

end

-------------------------

function dataobj:UpdateText()
	local fps = (db.customTextSetting or db.showFPS) and floor(GetFramerate()) or 30
	--bandwidthIn, bandwidthOut, latencyHome, latencyWorld
	local _, _, latencyHome, latencyWorld = GetNetStats()

	local fpsColor, colorHome, colorWorld = "", "", ""
	if not db.disableColoring then
		if fps > 30 then
			fpsColor = "|cff00ff00"
		elseif fps > 20 then
			fpsColor = "|cffffd200"
		else
			fpsColor = "|cffdd3a00"
		end
		if latencyHome < 300 then
			colorHome = "|cff00ff00"
		elseif latencyHome < 500 then
			colorHome = "|cffffd200"
		else
			colorHome = "|cffdd3a00"
		end
		if latencyWorld < 300 then
			colorWorld = "|cff00ff00"
			dataobj.icon = path.."green.tga"
		elseif latencyWorld < 500 then
			colorWorld = "|cffffd200"
			dataobj.icon = path.."yellow.tga"
		else
			colorWorld = "|cffdd3a00"
			dataobj.icon = path.."red.tga"
		end
	end

	if db.customTextSetting then
		local lw_string = colorWorld..latencyWorld.."|r"
		local lh_string = colorHome..latencyHome.."|r"
		local fps_string = fpsColor..fps.."|r"
		local text = string.gsub(string.gsub(string.gsub(db.textOutput, "{fps}", (fps_string or "fps")), "{lw}", (lw_string or "lw")), "{lh}", (lh_string or "lh"))
		dataobj.text = text
	else
		local text = ""
		if db.showWorldLatency then
			text = string.format("%s%i|r%s ", colorWorld, latencyWorld, L["ms"])
		end
		if db.showHomeLatency then
			text = string.format("%s%s%i|r%s ", text, colorHome, latencyHome, L["ms"])
		end
		if db.showFPS then
			if db.fpsFirst then
				dataobj.text = string.format("%s%i|r %s %s", fpsColor, fps , L["fps"], text)
			else
				dataobj.text = string.format("%s%s%i|rfps", text, fpsColor, fps )
			end
		else
			dataobj.text = text
		end
	end
end

local function MouseHandler(event, func, button, ...)
	local name = func

	if _G.type(func) == "function" then
		func(event, func,button, ...)
	else
		func:GetScript("OnClick")(func,button, ...)
	end

	LibQTip:Release(tooltip)
	tooltip = nil
end

function dataobj:OnLeave()
    return
end

function dataobj:OnEnter()
	if tooltip then
		LibQTip:Release(tooltip)
	end

	tooltip = LibQTip:Acquire("Broker_MicroMenuTooltip", 2, "LEFT", "LEFT")
	tooltip:Clear()
	self.tooltip = tooltip

	local y, x = tooltip:AddLine()
	tooltip:SetCell(y, 1, "", myProvider, {0.2, 0.8, 0.2, 0.8},"player")
	tooltip:SetCell(y, 2, _G.CharacterMicroButton.tooltipText)
	tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, function() _G.ToggleCharacter("PaperDollFrame") end)

	local y, x = tooltip:AddLine()
	tooltip:SetCell(y, 1, path.."spells.tga", myProvider)
	--tooltip:SetCell(y, 2, "Spellbook & Abilities |cffffd200(P)|r")
	local key = _G.GetBindingKey("TOGGLESPELLBOOK")
	if key then
		tooltip:SetCell(y, 2, _G.SPELLBOOK_ABILITIES_BUTTON.."|cffffd200 ("..key..")")
	else
		tooltip:SetCell(y, 2, _G.SPELLBOOK_ABILITIES_BUTTON)
	end
	tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, function(self, func, button, ...)

		if _G.InCombatLockdown() then
			if key then
				_G.DEFAULT_CHAT_FRAME:AddMessage("Cant' open the Spellbook during combat. Use your hot key: "..key)
			else
				_G.DEFAULT_CHAT_FRAME:AddMessage("Cant' open the Spellbook during combat. Set and use a hot key.")
			end
		else
			--SpellbookMicroButton:GetScript("OnClick")(SpellbookMicroButton,button, ...)
			_G.ToggleSpellBook(_G.BOOKTYPE_SPELL)
			--[[
			if  SpellBookFrame:IsShown() then
				SpellBookFrame:Hide()
			else
				tinsert(UISpecialFrames,SpellBookFrame:GetName());
				SpellBookFrame:Show()
			end
			--]]
		end
	end)

	local y, x = tooltip:AddLine()
	tooltip:SetCell(y, 1, path.."talents.tga", myProvider)
	tooltip:SetCell(y, 2, _G.TalentMicroButton.tooltipText)
	--tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, TalentMicroButton)
	tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, function(self, func, button, ...)
		if _G.InCombatLockdown() then
			key = _G.GetBindingKey("TOGGLETALENTS")
			if key then
				_G.DEFAULT_CHAT_FRAME:AddMessage("Cant' open the Talents during combat. Use your hot key: "..key)
			else
				_G.DEFAULT_CHAT_FRAME:AddMessage("Cant' open the Talents during combat. Set and use a hot key.")
			end
		else
			_G.LoadAddOn("Blizzard_TalentUI")
			--TalentMicroButton:GetScript("OnClick")(TalentMicroButton,button, ...)
			if  _G.PlayerTalentFrame:IsShown() then
				_G.PlayerTalentFrame:Hide()
			else
				_G.tinsert(_G.UISpecialFrames,_G.PlayerTalentFrame:GetName());
				_G.PlayerTalentFrame:Show()
			end
		end
	end)

	local y, x = tooltip:AddLine()
	tooltip:SetCell(y, 1, path.."achivements.tga", myProvider)
	tooltip:SetCell(y, 2, _G.AchievementMicroButton.tooltipText)
	tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, _G.AchievementMicroButton)

	local y, x = tooltip:AddLine()
	tooltip:SetCell(y, 1, path.."quest.tga", myProvider)
	tooltip:SetCell(y, 2, _G.QuestLogMicroButton.tooltipText)
	tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, _G.QuestLogMicroButton)

	local y, x = tooltip:AddLine()
	--tooltip:SetCell(y, 1, path.."social.tga", myProvider)
	tooltip:SetCell(y, 1, "", myProvider, nil,"player",true)
	tooltip:SetCell(y, 2, _G.GuildMicroButton.tooltipText)
	tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, _G.GuildMicroButton)

	--[[
	local y, x = tooltip:AddLine()
	tooltip:SetCell(y, 1, path.."pvp.tga", myProvider)
	tooltip:SetCell(y, 2, "PvP")
	--tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, function() ToggleFrame(PVPParentFrame) end)
	tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, function()
		if TogglePVPUI then
			TogglePVPUI()
		end
	end)
	]]

	local y, x = tooltip:AddLine()
	tooltip:SetCell(y, 1, path.."lfg.tga", myProvider)
	tooltip:SetCell(y, 2, _G.LFDMicroButton.tooltipText)
	tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, _G.LFDMicroButton)

	if _G.CollectionsMicroButton then
		local y, x = tooltip:AddLine()
		tooltip:SetCell(y, 1, path.."mounts.tga", myProvider)
		tooltip:SetCell(y, 2, _G.CollectionsMicroButton.tooltipText)
		tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, _G.CollectionsMicroButton)
	end

	if _G.EJMicroButton then
		local y, x = tooltip:AddLine()
		tooltip:SetCell(y, 1, path.."journal.tga", myProvider)
		tooltip:SetCell(y, 2, _G.EJMicroButton.tooltipText)
		tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, _G.EJMicroButton)
	end
	if _G.RaidMicroButton then
		local y, x = tooltip:AddLine()
		tooltip:SetCell(y, 1, path.."raid.tga", myProvider)
		tooltip:SetCell(y, 2, _G.RaidMicroButton.tooltipText)
		tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, _G.RaidMicroButton)
	end

	if _G.StoreMicroButton then
		local y, x = tooltip:AddLine()
		tooltip:SetCell(y, 1, path.."raid.tga", myProvider)
		tooltip:SetCell(y, 2, _G.StoreMicroButton.tooltipText)
		tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, _G.StoreMicroButton)
	end

	local y, x = tooltip:AddLine()
	tooltip:SetCell(y, 1, path.."green.tga", myProvider)
	tooltip:SetCell(y, 2, _G.MainMenuMicroButton.tooltipText)
	tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, mainmenu)

	tooltip:AddSeparator(10,0,0,0,0)

	local y, x = tooltip:AddLine()
	tooltip:SetCell(y, 1, "", myProvider)
	tooltip:SetCell(y, 2, _G.GameMenuButtonOptions:GetText())
	tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, function() _G.VideoOptionsFrame:Show() end)

	local y, x = tooltip:AddLine()
	tooltip:SetCell(y, 2, "Interface")
	tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, function() _G.InterfaceOptionsFrame:Show() end)

	local y, x = tooltip:AddLine()
	tooltip:SetCell(y, 2, _G.GameMenuButtonKeybindings:GetText())
	tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, function() _G.KeyBindingFrame_LoadUI(); _G.KeyBindingFrame:Show() end)

	local y, x = tooltip:AddLine()
	tooltip:SetCell(y, 2, _G.GameMenuButtonMacros:GetText())
	tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, _G.ShowMacroFrame)

	if _G.GameMenuButtonAddons then
		local y, x = tooltip:AddLine()
		tooltip:SetCell(y, 2, _G.GameMenuButtonAddons:GetText())
		tooltip:SetLineScript(y, "OnMouseUp", MouseHandler, _G.GameMenuButtonAddons)
	end

	tooltip:SetAutoHideDelay(0.1, self)
	tooltip:SmartAnchorTo(self)
	tooltip:Show()
end

function dataobj:SetDB(database)
	db = database
end

local function OnUpdate(self, elapsed)
	counter = counter + elapsed
	if counter >= delay then
		dataobj:UpdateText()
		counter = 0
	end
end

local frame = CreateFrame("Frame")
local function OnEnterWorld(self)
	dataobj:RegisterOptions()
	frame:UnregisterEvent("PLAYER_ENTERING_WORLD")
end


frame:SetScript("OnUpdate", OnUpdate)
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", OnEnterWorld)
