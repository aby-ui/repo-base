--[[

	This module handles the behavior of "cards" which includes pet cards, notes
	and win records. Preferences and possibly team cards will become cards in
	the future.

	These cards are hybrid tooltips and dialogs. When the mouse is over a button
	that displays a card, the card will behave like a tooltip: moving the mouse
	off the button will hide the card. When the card-displaying button is
	clicked, a dialog frame appears around the card and it remains locked on the
	screen. Moving the mouse off the button will not hide the card, so the user
	can mouseover and interact with the card's contents as if it was a dialog.

	To use this card manager:
	- Cards should inherit "RematchCardManagerTemplate". This adds a child frame
	  (hidden by default) with the "locked" border frame to surround the card.
	- Cards should be movable, clampedToScreen and FULLSCREEN frameStrata
	- All clickable child frames (like stats on the pet card) should be defined
	  prior to registering the card, when it gathers all clickableElements.
	- Each card should be registered with a name via RegisterCard:
		rematch:RegisterCard(cardName,frame,showFunc,title,isFloating)
		- cardName is a unique string to identify this card ("PetCard", "WinRecord", etc)
		- frame is the parent that inherited RematchCardManagerTemplate
		- showFunc a function for each card to ShowCard(self,cardName,button,subject,forceLock)
		- title is the text to display at the top of the card
		- isFloating is true when a card is never pinned/anchored to an origin button
	- rematch:ShowCard(cardName,etc) can be called directly too.		
	- Each button that displays a card should run these in their OnEnter/OnLeave/OnClick:
		rematch.CardManager.ButtonOnEnter(self,cardName,subject)
		rematch.CardManager.ButtonOnLeave(self,cardName)
		rematch.CardManager.ButtonOnClick(self,cardName,subject,highlightFunc)
		- self is the button being entered/left/clicked
		- cardName is the name of the card as it was registered
		- subject is a petID or teamID the showFunc will use to fill the card
		- (optional) highlightFunc runs when a lock changes func(origin/self,subject)


	To show a card:
	- Let the OnEnter/OnLeave/OnClick do its thing. It requires no extra work.
	- To directly force a card:
		rematch:ShowCard(cardName,UIParent/button,subject,true)

	To hide a card:
	- rematch:HideCard(cardName) to hide a specific card
	- rematch:HideCard() will hide all cards
	- Never directly card:Hide()! It will break the card!

	Each card has these in RematchSettings:
	<cardname>XPos: center x coordinate of the card (when not anchored to origin)
	<cardname>YPos: center y coordinate of the card (when not anchored to origin)
	<cardname>IsPinned: true if the card is presently pinned (not whether pinnable)
	<cardname>IsLocked: true if the card is presently locked and can't be moved
]]

local _,L = ...
local rematch = Rematch
rematch.CardManager = {}
local manager = rematch.CardManager
local settings

local cardProperties = {} -- indexed by card name, the properties of the card being managed
local cardNamesByFrame = {} -- indexed by frame, the card name registered for the frame
local delay = 0.5 -- seconds before card is shown on mouseover with default options

function rematch:RegisterCard(cardName,frame,showFunc,title,isFloating)
	cardProperties[cardName] = {frame=frame,showFunc=showFunc,isFloating=isFloating,clickableElements={}}
	cardNamesByFrame[frame] = cardName

	-- setup lockframe
	frame.LockFrame.CloseButton:SetScript("OnClick",manager.CloseButtonOnClick)
	frame.LockFrame.CloseButton:SetScript("OnKeyDown",manager.CloseButtonOnKeyDown)
	frame.LockFrame.TitleText:SetText(title)
	frame.LockFrame.PinButton.tooltipTitle = isFloating and L["Toggle Lock"] or L["Unpin Card"]
	frame.LockFrame.PinButton.tooltipBody = isFloating and L["While locked, this card cannot be moved unless Shift is held. It will also remain on screen when ESC is pressed."] or L["While pinned, this card will stay wherever you move it.\n\nClick this to unpin the card and snap it back to the button that spawned it."]
	rematch:ConvertTitlebarCloseButton(frame.LockFrame.CloseButton)

	-- if card doesn't have a saved position, then set a default to center of screen
	if not settings[cardName.."XPos"] then
		settings[cardName.."XPos"],settings[cardName.."YPos"] = UIParent:GetCenter()
	end

	-- discover all clickable elements of a card and save them in its clickableElements
	manager:AddClickableElements(cardName,frame)

end

-- can be called from outside this module; cardName has to have been registered
-- origin is the frame/button the card is to attach to
-- subject is the petID, teamID, etc to show on the card
-- forceLock is true if the card should be locked (LockFrame shown)
function rematch:ShowCard(cardName,origin,subject,forceLock)
	local card = cardProperties[cardName]
	if card then
		if forceLock then -- any card being forced on the screen is locked
			card.locked = true
		end
		-- save origin/subject to the card
		card.origin = origin
		card.subject = subject
		-- run its showFunc
		card.showFunc(card.frame,subject)
		-- handle LockFrame
		card.frame.LockFrame:SetShown(card.locked)
		-- update button in topleft corner
		manager:UpdatePinButton(cardName)
		-- update whether clickable elements can be clicked through (unlocked cards cannot capture mouse)
		manager:UpdateClickableElements(cardName,card.locked and true)
		-- position the card; for pinned cards (or static) anchor card to its saved XPos/YPos
		if card.isFloating or (settings.FixedPetCard and settings[cardName.."IsPinned"]) then
			card.frame:ClearAllPoints()
			card.frame:SetPoint("CENTER",UIParent,"BOTTOMLEFT",settings[cardName.."XPos"],settings[cardName.."YPos"])
		else -- otherwise anchor it to origin button
			rematch:SmartAnchor(card.frame,origin)
		end
		-- and finally put it on screen
		card.frame:Show()
	end
end

-- this will update an existing card, likely due to some change
function rematch:UpdateCard(cardName)
	local card = cardProperties[cardName]
	if card.origin and card.subject then
		rematch:ShowCard(cardName,card.origin,card.subject)
	end
end

-- this should be called instead of card:Hide() to hide a card
-- if no cardName is given, all cards will be hidden
function rematch:HideCard(cardName)
	if cardName then
		rematch:StopTimer(cardName)
		local card = cardProperties[cardName]
		if card then
			card.frame:Hide()
			if card.origin then
				card.origin = nil
				card.subject = nil
				card.locked = nil
			end
		end
	else -- if a card isn't given, hide them all
		for cardName in pairs(cardProperties) do
			rematch:HideCard(cardName)
		end
	end
end

-- adds frame and all children of frame to a card's clickableElements if they can be clicked
function manager:AddClickableElements(cardName,frame)
	if frame:IsMouseEnabled() then
		tinsert(cardProperties[cardName].clickableElements,frame)
	end
	for _,child in pairs({frame:GetChildren()}) do
		if child:IsMouseEnabled() then
			manager:AddClickableElements(cardName,child)
		end
	end
end

-- goes through all clickableElements in a card and enables mouse if true, disables if false
-- (when an unlocked card is overlapping a button, the card can't capture the mouse or it
-- immediately triggers an OnLeave of the button)
function manager:UpdateClickableElements(cardName,enable)
	local card = cardProperties[cardName]
	if card then
		local clickableElements = card.clickableElements
		for i=1,#clickableElements do
			clickableElements[i]:EnableMouse(enable)
		end
	end
end

--[[ LockFrame ]]

-- when a card's LockFrame is shown, make sure the parent card is a higher frameLevel
function manager:LockFrameOnShow()
	local parent = self:GetParent()
	local parentFrameLevel = parent and parent:GetFrameLevel()
	local selfFrameLevel = self:GetFrameLevel()
	if parentFrameLevel and parentFrameLevel<=selfFrameLevel then
		parent:SetFrameLevel(selfFrameLevel)
		self:SetFrameLevel(parentFrameLevel)
	end
end

-- when LockFrame is dragged it drags its parent
function manager:LockFrameOnMouseDown()
	local cardName = cardNamesByFrame[self:GetParent()]
	local card = cardProperties[cardName]
	if card then
		-- only drag the card if it's not a static card or it's not locked
		if not card.isFloating or not settings[cardName.."IsLocked"] then
			self:GetParent():StartMoving()
		end
	end
end

-- when LockFrame is released it stops dragging its parent
function manager:LockFrameOnMouseUp()
	local parent = self:GetParent()
	parent:StopMovingOrSizing()
	local cardName = cardNamesByFrame[parent]
	local card = cardProperties[cardName]
	-- if card is pinnable and "Allow Cards To Be Pinned" is enabled
	if card and (card.isFloating or settings.FixedPetCard) then
		settings[cardName.."IsPinned"] = true
		settings[cardName.."XPos"],settings[cardName.."YPos"] = parent:GetCenter()
		manager:UpdatePinButton(cardName)
	end
end

-- click of the close button on the LockFrame
function manager:CloseButtonOnClick()
	rematch:HideCard(cardNamesByFrame[self:GetParent():GetParent()])
end

-- while lock frame is on screen, the close button will watch for an ESC
function manager:CloseButtonOnKeyDown(key)
	if key==GetBindingKey("TOGGLEGAMEMENU") then
		local cardName = cardNamesByFrame[self:GetParent():GetParent()]
		local card = cardProperties[cardName]
		if card and (not card.isFloating or not settings[cardName.."IsLocked"]) then
			rematch:HideCard(cardNamesByFrame[self:GetParent():GetParent()])
			self:SetPropagateKeyboardInput(false)
			return
		end
	end
	self:SetPropagateKeyboardInput(true)
end

--[[ Origin button's OnEnter/Leave/Click ]]

-- buttons that show a card should use in their OnEnter
-- subject is the petID, teamID, etc of the card to show
function manager:ButtonOnEnter(cardName,subject)
	if settings.ClickPetCard then
		return
	end
	local card = cardProperties[cardName]
	-- don't do anything if card is already locked on screen (or a dialog/menu just went away)
	if card.locked or rematch:UIJustChanged() then
		return
	end
	card.origin = self
	card.subject = subject
	if settings.FastPetCard then -- if "Faster Pet Card" enabled, show card immediately
		rematch:ShowCard(cardName,self,subject)
	else -- otherwise wait a short delay before showing card
		rematch:StartTimer(cardName,delay,manager.DelayedButtonOnEnter)
	end
end

-- called after delay via ButtonOnEnter, actually shows the card
function manager:DelayedButtonOnEnter()
	local cardName = rematch:GetTimerStopped() -- get name of timer that triggered this function
	local card = cardProperties[cardName]
	rematch:ShowCard(cardName,card.origin,card.subject)
end

-- buttons that show a card should use this in their OnLeave
function manager:ButtonOnLeave(cardName)
	if settings.ClickPetCard then
		return
	end
	local card = cardProperties[cardName]
	if not card.locked then
		rematch:HideCard(cardName)
	end
end

-- this should be called after the button checked if any other clicks (right-click,
-- shift+click, etc) needed handling and only if they weren't handled.
function manager:ButtonOnClick(cardName,subject,highlightFunc)
	local card = cardProperties[cardName]
	if card.frame:IsVisible() then
		-- if the opened subject is being clicked, toggle its lock state
		if card.origin==self and card.subject==subject then
			if settings.ClickPetCard then
				rematch:HideCard(cardName)
			elseif card.locked then -- card locked on same origin/subject, unlock it
				card.locked = nil
				card.frame.LockFrame:Hide()
				manager:UpdateClickableElements(cardName,false)
			else -- card unlocked on same origin/subject, lock it
				card.locked = true
				card.frame.LockFrame:Show()
				manager:UpdateClickableElements(cardName,true)
			end
		else -- if a different subject is clicked, open new subject and lock for this click
			card.locked = true
			rematch:ShowCard(cardName,self,subject)
		end
	else -- card is not visible (clicked before delay over or ClickToOpen)
		rematch:StopTimer(cardName)
		card.locked = true
		rematch:ShowCard(cardName,self,subject)
	end
end

-- returns the subject and origin of the shown card
function manager:GetCardInfo(cardName)
	local card = cardProperties[cardName]
	if card then
		return card.subject,card.origin
	end
end

--[[ Pinning/Locking ]]

-- updates the state of the the pin/lock button in the topleft corner of the card
function manager:UpdatePinButton(cardName)
	local card = cardProperties[cardName]
	if card then
		local pinButton = card.frame.LockFrame.PinButton
		if card.isFloating then
			local isLocked = settings[cardName.."IsLocked"]
			rematch:SetTitlebarButtonIcon(pinButton,isLocked and "lock" or "unlock")
			pinButton:Show()
		elseif settings.FixedPetCard and settings[cardName.."IsPinned"]  then
			rematch:SetTitlebarButtonIcon(pinButton,"pin")
			pinButton:Show()
		else
			pinButton:Hide()
		end
	end
end

-- when pin/lock button is clicked on the lock frame
function manager:PinButtonOnClick()
	local cardName = cardNamesByFrame[self:GetParent():GetParent()]
	local card = cardProperties[cardName]
	if card.isFloating then
		settings[cardName.."IsLocked"] = not settings[cardName.."IsLocked"]
		manager:UpdatePinButton(cardName)
	else
		settings[cardName.."IsPinned"] = nil
		rematch:UpdateCard(cardName)
	end
end

--[[ CardTest ]]

local testData = {}

local function fillTestCard(self,subject)
	local petInfo = rematch.petInfo:Fetch(subject)
	self.Text:SetText(petInfo.name)
	self.Icon:SetNormalTexture(petInfo.icon)
end

local function fillTestCardListButton(self,subject)
	local petInfo = rematch.petInfo:Fetch(subject)
	self.Pet.Icon:SetTexture(petInfo.icon)
	self.Text:SetText(petInfo.name)
	self.petID = subject
	self:UnlockHighlight()
end

rematch:InitModule(function()
	settings = RematchSettings
--	rematch:RegisterCard("CardTest",CardTestCard,function(self,subject) self.Text:SetText(subject) self:Show() end,"Card Test","pin")
	rematch:RegisterCard("CardTest",CardTestCard,fillTestCard,"Card Test",true)

	local scrollFrame = AutoScrollFrame:Create(CardTest, "CardTestListButtonTemplate", testData, fillTestCardListButton)
	scrollFrame:SetPoint("TOPLEFT",4,-24)
	scrollFrame:SetPoint("BOTTOMRIGHT",-6,5)
	CardTest.scrollFrame = scrollFrame

	CardTest:SetScript("OnEvent",function(self,event)
		wipe(testData)
		for i=1,C_PetJournal.GetNumPets() do
			local petID = C_PetJournal.GetPetInfoByIndex(i)
			if petID then
				tinsert(testData,petID)
			end
		end
		self.scrollFrame:Update()
	end)
	CardTest:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
end)
