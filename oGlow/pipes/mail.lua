-- TODO:
--  - Write a description.

local _E
local hook
local stack = {}

local send = function(self)
	if(not SendMailFrame:IsShown()) then return end

	for i=1, ATTACHMENTS_MAX_SEND do
		local slotLink = GetSendMailItemLink(i)
		local slotFrame = _G["SendMailAttachment"..i]
		self:CallFilters('mail', slotFrame, _E and slotLink)
	end
end

local inbox = function()
	local numItems = GetInboxNumItems()
	local index = ((InboxFrame.pageNum - 1) * INBOXITEMS_TO_DISPLAY) + 1

	for i=1, INBOXITEMS_TO_DISPLAY do
		local slotFrame = _G["MailItem"..i.."Button"]
		if (index <= numItems) then
			for j=1, ATTACHMENTS_MAX_RECEIVE do
				local attachLink = GetInboxItemLink(index, j)
				if(attachLink) then
					table.insert(stack, attachLink)
				end
			end
		end

		oGlow:CallFilters('mail', slotFrame, _E and unpack(stack))
		wipe(stack)

		index = index + 1
	end
end

local letter = function()
	if(not InboxFrame.openMailID) then return end

	for i=1, ATTACHMENTS_MAX_RECEIVE do
		local itemLink = GetInboxItemLink(InboxFrame.openMailID, i)
		if(itemLink) then
			local slotFrame = _G["OpenMailAttachmentButton"..i]

			oGlow:CallFilters('mail', slotFrame, _E and itemLink)
		end
	end
end

local update = function(self)
	send(self)
	inbox()
	letter()
end

local hookLetter = function(...)
	if(_E) then return letter(...) end
end

local hookInbox = function(...)
	if(_E) then return inbox(...) end
end

local enable = function(self)
	_E = true

	self:RegisterEvent('MAIL_SHOW', send)
	self:RegisterEvent('MAIL_SEND_INFO_UPDATE', send)
	self:RegisterEvent('MAIL_SEND_SUCCESS', send)

	if(not hook) then
		hooksecurefunc("OpenMail_Update", hookLetter)
		hooksecurefunc("InboxFrame_Update", hookInbox)
		hook = true
	end
end

local disable = function(self)
	_E =  nil

	self:UnregisterEvent('MAIL_SHOW', send)
	self:UnregisterEvent('MAIL_SEND_INFO_UPDATE', send)
	self:UnregisterEvent('MAIL_SEND_SUCCESS', send)
end

oGlow:RegisterPipe('mail', enable, disable, update, 'Mail frame', nil)
