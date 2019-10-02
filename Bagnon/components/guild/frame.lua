--[[
	frame.lua
		A specialized version of the window frame for guild banks
--]]

local MODULE =  ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local Frame = Addon:NewClass('GuildFrame', 'Frame', Addon.Frame)

Frame.Title = LibStub('AceLocale-3.0'):GetLocale(ADDON).TitleBank
Frame.MoneyFrame = Addon.GuildMoneyFrame
Frame.ItemFrame = Addon.GuildItemFrame
Frame.BagFrame = Addon.GuildTabFrame
Frame.CloseSound = SOUNDKIT.GUILD_VAULT_CLOSE
Frame.OpenSound = SOUNDKIT.GUILD_VAULT_OPEN
Frame.Bags = {}

for i = 1, MAX_GUILDBANK_TABS do
	Frame.Bags[i] = i
end


--[[ Constructor ]]--

function Frame:New(id)
	local f = Addon.Frame.New(self, id)
	local log = Addon.LogFrame:New(f)
	log:SetPoint('BOTTOMRIGHT', -10, 35)
	log:SetPoint('TOPLEFT', 10, -70)
	log:Hide()

	local edit = Addon.EditFrame:New(f)
	edit:SetPoint('BOTTOMRIGHT', -32, 35)
	edit:SetPoint('TOPLEFT', 10, -75)
	edit:Hide()

	f.logToggles = Addon.LogToggle:NewSet(f)
	f.log, f.editFrame = log, edit
	return f
end

function Frame:RegisterSignals()
	Addon.Frame.RegisterSignals(self)
	self:RegisterFrameSignal('LOG_SELECTED', 'OnLogSelected')
end


--[[ Events ]]--

function Frame:OnHide()
	Addon.Frame.OnHide(self)

	StaticPopup_Hide('GUILDBANK_WITHDRAW')
	StaticPopup_Hide('GUILDBANK_DEPOSIT')
	StaticPopup_Hide('CONFIRM_BUY_GUILDBANK_TAB')
	CloseGuildBankFrame()
end

function Frame:OnLogSelected(_, logID)
	self.itemFrame:SetShown(not logID)
	self.editFrame:SetShown(logID == 3)
	self.log:SetShown(logID and logID < 3)
end


--[[ Proprieties ]]--

function Frame:ListMenuButtons()
	for i, toggle in ipairs(self.logToggles) do
		tinsert(self.menuButtons, toggle)
	end

	Addon.Frame.ListMenuButtons(self)
end

function Frame:HasOwnerSelector() end
function Frame:HasSortButton() end
function Frame:HasBagToggle() end
function Frame:IsBagFrameShown()
	return true
end

function Frame:GetOwner()
	return self.owner or LibStub('LibItemCache-2.0'):GetOwnerInfo().guild
end
