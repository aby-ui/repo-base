--[[
	editFrame.lua
		A guild bank tab notes edit frame
--]]

local MODULE = ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local EditFrame = Addon:NewClass('EditFrame', 'ScrollFrame')


--[[ Constructor ]]--

function EditFrame:New(parent)
	local f = self:Bind(CreateFrame('ScrollFrame', parent:GetName() .. 'LogFrame', parent, 'UIPanelScrollFrameTemplate'))
	local edit = CreateFrame('EditBox', nil, f)
	edit:SetScript('OnEscapePressed', edit.ClearFocus)
	edit:SetScript('OnEditFocusLost', self.OnEditFocusLost)
	edit:SetScript('OnCursorChanged', self.OnCursorChanged)
	edit:SetScript('OnTextChanged', self.OnTextChanged)
	edit:SetScript('OnMouseDown', self.OnMouseDown)
	edit:SetScript('OnUpdate', self.OnUpdate)
	edit:SetFontObject(GameFontHighlight)
	edit:SetPoint('TOPLEFT')
	edit:SetSize(500, 300)
	edit:SetAutoFocus(false)
	edit:SetMaxLetters(500)
	edit:SetMultiLine(true)

	local bg = f:CreateTexture()
	bg:SetColorTexture(0, 0, 0, .2)
	bg:SetPoint('TOPLEFT', f)
	bg:SetPoint('BOTTOMRIGHT', f.ScrollBar, 0, -16)

	f:SetScript('OnEvent', function(f, event, ...) f[event](f, ...) end)
	f:SetScript('OnShow', f.RegisterEvents)
	f:SetScript('OnHide', f.OnHide)
	f:SetScrollChild(edit)
	f:RegisterEvents()

	return f
end


--[[ Events ]]--

function EditFrame:RegisterEvents()
	QueryGuildBankText(GetCurrentGuildBankTab())

	self:RegisterSignal('GUILD_TAB_CHANGED', 'Update')
	self:RegisterEvent('GUILDBANKBAGSLOTS_CHANGED', 'Update')
	self:RegisterEvent('GUILDBANK_UPDATE_TEXT')
	self:RegisterEvent('GUILDBANK_TEXT_CHANGED')
	self:RegisterEvent('PLAYER_LOGOUT')
	self:Update()
end

function EditFrame:GUILDBANK_UPDATE_TEXT (tab)
	if tab == GetCurrentGuildBankTab() then
		self:Update()
	end
end

function EditFrame:GUILDBANK_TEXT_CHANGED (tab)
	if tab == GetCurrentGuildBankTab() then
		QueryGuildBankText(tab)
	end
end

function EditFrame:PLAYER_LOGOUT ()
	self.OnEditFocusLost(self:GetScrollChild()) -- save on logout
end

function EditFrame:Update()
	local text = GetGuildBankText(GetCurrentGuildBankTab()) or ''
	local edit = self:GetScrollChild()
	edit.text = text
	edit:SetText(text)
end


--[[ Interaction ]]--

function EditFrame:OnUpdate(elapsed)
	ScrollingEdit_OnUpdate(self, elapsed, self:GetParent())
end

function EditFrame:OnCursorChanged(x, y, ...)
	ScrollingEdit_OnCursorChanged(self, x, y - 10, ...)
end

function EditFrame:OnTextChanged()
	ScrollingEdit_OnTextChanged(self, self:GetParent())
end

function EditFrame:OnMouseDown()
	if CanEditGuildTabInfo(GetCurrentGuildBankTab()) then
		self:SetFocus()
	end
end

function EditFrame:OnEditFocusLost()
	if self:GetText() ~= self.text then
		SetGuildBankText(GetCurrentGuildBankTab(), self:GetText())
	end
end

function EditFrame:OnHide()
	self:UnregisterSignals()
	self:GetScrollChild():ClearFocus()
end
