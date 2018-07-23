local _,L = ...
local rematch = Rematch
local notes = RematchNotes
local settings

rematch:InitModule(function()
	rematch.Notes = notes
	settings = RematchSettings
	notes.needsInit = true
	rematch:ConvertTitlebarCloseButton(notes.CloseButton)
end)

-- if maybe is true, notes only hide if card isn't locked; otherwise hide regardless
function rematch:HideNotes(maybe)
	if maybe and notes.locked then return end
	notes:Hide()
end

-- toggles notes for the loaded team (called from binding)
function rematch:ToggleNotes()
	if notes:IsVisible() then
		rematch:HideNotes()
	else
		local team = RematchSaved[settings.loadedTeam]
		if team and team.notes then
			rematch:ShowNotes("team",settings.loadedTeam,true)
		end
	end
end

function notes:StopSizing()
	notes:StopMovingOrSizing()
	settings.NotesLeft = notes:GetLeft()
	settings.NotesBottom = notes:GetBottom()
	settings.NotesWidth = notes:GetWidth()
	settings.NotesHeight = notes:GetHeight()
	notes:SetUserPlaced(false)
end

function notes:OnSizeChanged(w)
	self.Content.ScrollFrame.EditBox:SetWidth(w-58)
	notes:ResizeControls(w)
end

function notes:ResizeControls(width)
	-- controls are anchored to BOTTOMLEFT and BOTTOMRIGHT on notes
	width = width or notes:GetWidth()
	local bwidth = min((width-6)/3,122)-2
	self.Controls.DeleteButton:SetWidth(bwidth)
	self.Controls.UndoButton:SetWidth(bwidth)
	self.Controls.SaveButton:SetWidth(bwidth)
end

function notes:OnShow()
	if notes.needsInit then -- one-time stuff first time notes are shown
		notes:SetScript("OnSizeChanged",notes.OnSizeChanged)
		notes:OnSizeChanged(notes:GetWidth())
		notes.needsInit = nil
	end
end

function notes:OnHide()
	notes.locked = nil
	notes.subject = nil
	notes.subjectType = nil
	notes:SetAlpha(1)
end

function rematch:ShowNotes(subjectType,subject,force)
	if not force and notes.locked then
		return -- notes are locked, don't show new notes unless forced (clicking new note)
	end
	if settings.ClickPetCard and not force then
		return
	end
	if rematch:IsDialogOpen("DeleteNotes") then
		return
	end

	-- if FastPetCard not enabled, then cause a 0.25 delay before showing a card (unless it's forced)
	if not settings.ClickPetCard and not settings.FastPetCard then
		if subjectType and subject and not force then
			notes.subjectType = subjectType
			notes.subject = subject
			rematch:StartTimer("ShowNotes",0.25,rematch.ShowNotes)
			return
		elseif not force then
			subjectType = notes.subjectType
			subject = notes.subject
		end
	end

	local text, title, leftIcon, rightIcon
	if subjectType=="team" then
		local team = RematchSaved[subject]
		text = team.notes or ""
		title = rematch:GetTeamTitle(subject,true)
		leftIcon = "Interface\\Icons\\INV_Scroll_03"
		rightIcon = settings.TeamGroups[team.tab or 1][2]
		notes.Title:SetText(L["Team Notes"])
	elseif subjectType=="pet" then
		local idType = rematch:GetIDType(subject)
		local speciesID, name, icon, petType, _
		if idType=="pet" then
			speciesID,_,_,_,_,_,_,name,icon,petType = C_PetJournal.GetPetInfoByPetID(subject)
		elseif idType=="species" then
			speciesID = subject
			name,icon,petType = C_PetJournal.GetPetInfoBySpeciesID(subject)
		end
		if speciesID then
			subject = speciesID -- petID subject changing to speciesID subject here
			text = settings.PetNotes[speciesID] or ""
			title = name
			leftIcon = icon
			rightIcon = "Interface\\Icons\\Icon_PetFamily_"..PET_TYPE_SUFFIX[petType]
		end
		notes.Title:SetText(L["Pet Notes"])
	end

	if not text then
		notes.subject = nil
		notes.subjectType = nil
		notes.locked = nil
		return -- not sure what to display, leave
	end

	notes.Content.Name:SetText(title)
	notes.Content.LeftIcon:SetTexture(leftIcon)
	notes.Content.RightIcon:SetTexture(rightIcon)

	notes.subject = subject
	notes.subjectType = subjectType

	if force then
		notes.locked = true
	end

	notes.Content.ScrollFrame.EditBox:SetText(text)
	notes.Content.ScrollFrame.EditBox:SetCursorPosition(0)

	notes:UpdateLockState()

	if settings.NotesLeft then
		notes:SetSize(settings.NotesWidth,settings.NotesHeight)
		notes:ClearAllPoints()
		notes:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",settings.NotesLeft,settings.NotesBottom)
	end

	notes:Show()
end

-- to prevent onenter/onleave spasms if the notes overlaps the button that spawn them, the
-- mouse is disabled for these when the notes are not locked
function notes:UpdateLockState()
	local locked = notes.locked and true
	notes:SetAlpha(locked and 1 or 0)

	notes:EnableMouse(locked)
	notes.LockButton:EnableMouse(locked)
	notes.Content.ScrollFrame:EnableMouse(locked)
	notes.Content.ScrollFrame.EditBox:EnableMouse(locked)
	notes.Content.ScrollFrame.FocusGrabber:EnableMouse(locked)
	notes.Content.ScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT",notes.Content.ScrollFrame,"BOTTOMRIGHT",8,settings.LockNotesPosition and 13 or 26)
	notes.Content.ScrollFrame.ScrollBar:SetShown(locked)
	notes.Content.ScrollFrame.ScrollBar:SetAlpha(locked and 1 or 0)
	notes.Content.ScrollFrame.ResizeGrip:SetShown(locked and not settings.LockNotesPosition)
	notes.CloseButton:EnableMouse(locked)

	rematch:SetTitlebarButtonIcon(notes.LockButton,settings.LockNotesPosition and "lock" or "unlock")
end

function notes:OnEnter()
	local key = self:GetParent().key
	local petID = self:GetParent().petID
	if key then
		rematch:ShowNotes("team",key)
	else
		rematch:ShowNotes("pet",petID)
	end
end

function notes:OnLeave()
	if not settings.FastPetCard then
		rematch:StopTimer("ShowNotes")
	end
	rematch:HideNotes(true)
end

-- click of the Notes button (from RematchNotesButton template)
function notes:OnClick()
	local parent = self:GetParent()
	local subject,subjectType
	if parent.key then
		subject = parent.key
		subjectType = "team"
	elseif parent.petID then
		subject = parent.petID
		if rematch:GetIDType(subject)=="pet" then -- convert petID to speciesID
			subject = C_PetJournal.GetPetInfoByPetID(subject)
		end
		subjectType = "pet"
	end
	if not subject then return end
	if settings.ClickPetCard then
		notes.locked = true
	end
	if subject~=notes.subject then
		rematch:ShowNotes(subjectType,subject,true)
	elseif settings.ClickPetCard then
		rematch:HideNotes()
	else
		notes.locked = not notes.locked
	end
	notes:UpdateLockState()
end

-- only enabled when NotesNoESC is disabled on notes on screen
function notes:OnKeyDown(key)
	if key==GetBindingKey("TOGGLEGAMEMENU") and notes.locked then
		rematch:HideNotes()
		self:SetPropagateKeyboardInput(false)
	else
		self:SetPropagateKeyboardInput(true)
	end
end

function notes:UndoButtonOnClick()
	rematch:ShowNotes(notes.subjectType,notes.subject,true)
end

-- when focus lost, the control buttons are hidden and the notes
-- are saved
function notes:OnFocusLost()
	notes.Content:SetPoint("BOTTOMRIGHT",-4,2)
	notes.Controls:Hide()
	local text = (self:GetText() or ""):trim()
	local update -- becomes true if UI needs updating (notes gained/lost)
	if notes.subjectType=="team" then
		local team = RematchSaved[notes.subject]
		if team and text~="" then
			update = not team.notes
			team.notes = text
		else
			update = team.notes and true
			team.notes = nil -- was nothing in notes, remove it
		end
	elseif notes.subjectType=="pet" then
		if text~="" then
			update = not settings.PetNotes[notes.subject]
			settings.PetNotes[notes.subject] = text
		else
			update = settings.PetNotes[notes.subject] and true
			settings.PetNotes[notes.subject] = nil
		end
	end
	if update then
		rematch:UpdateUI()
	end
end

-- when focus gained, the control buttons are shown (delete, undo, save, resize)
function notes:OnFocusGained()
	notes.Content:SetPoint("BOTTOMRIGHT",-4,25)
	notes.Controls:Show()
end

function notes:DeleteButtonOnClick()
	local team = RematchSaved[notes.subject]
	-- when dialog opens, notes hide and subject is nil'ed, subject noted before dialog nil's them
	local subjectType, subject = notes.subjectType, notes.subject
	local title
	if subjectType=="team" and team then
		title = rematch:GetTeamTitle(subject,true)
	elseif subjectType=="pet" then
		title = rematch:GetPetName(subject)
	end
	if title then
		local dialog = rematch:ShowDialog("DeleteNotes",300,124,L["Delete Notes"],nil,YES,notes.AcceptDelete,NO)
		dialog:ShowText(format(L["Are you sure you want to delete the notes for %s\124r?"],title),220,50,"TOP",0,-36)
		dialog:SetContext("subjectType",subjectType)
		dialog:SetContext("subject",subject)
	end
end

function notes:AcceptDelete()
	local subjectType = rematch.Dialog:GetContext("subjectType")
	local subject = rematch.Dialog:GetContext("subject")
	if subjectType=="team" and RematchSaved[subject] then
		RematchSaved[subject].notes = nil
	elseif subjectType=="pet" and settings.PetNotes[subject] then
		settings.PetNotes[subject] = nil
	end
	rematch:UpdateUI()
end

function notes:UpdateControlButtons()
	local text = notes.Content.ScrollFrame.EditBox:GetText()
	if notes.subjectType=="team" then
		local team = RematchSaved[notes.subject]
		notes.Controls.UndoButton:SetEnabled(team.notes and text~=team.notes)
	end
end

function notes:LockButtonOnClick()
	settings.LockNotesPosition = not settings.LockNotesPosition
	notes:UpdateLockState()
	notes:ResizeControls()
end
