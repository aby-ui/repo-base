-- Dialog.lua: the ShowDialog() and support functions

local _,L = ...
local rematch = Rematch
local dialog = RematchDialog

dialog.context = {} -- wiped when a dialog is shown, used by SetContext(var,value) and GetContext(var)

-- list of widgets reused. custom ones should use dialog:RegisterWidget("name")
dialog.widgets = { "Pet", "Warning", "EditBox", "Slot", "TeamTabIconPicker", "Text",
	"Team", "OldTeam", "SaveAs", "Preferences", "CheckButton", "Share", "TabPicker",
	"ConflictRadios", "Send", "ShareIncludes", "CollectionReport", "ScaleSlider",
	"ScriptFilter", "MultiLine", "SmallText",
}

rematch:InitModule(function()
	rematch.Dialog = dialog
	local petButton = dialog.Pet.Pet
	petButton.noPickup = true -- don't allow pickup or right-click or dialog pet
	petButton:SetScript("OnEnter",function(self) rematch:ShowPetCard(self,self.petID) end)
	petButton:SetScript("OnLeave",function(self) rematch:HidePetCard(true) end)
	petButton:SetScript("OnClick",function(self,button) rematch.PetListButtonOnClick(self,button) end)
	dialog.TabPicker.Label:SetText(L["Tab:"])
	rematch:ConvertTitlebarCloseButton(dialog.CloseButton)
end)

-- dialogName: a string to reference the dialog (rematch:IsDialogOpen("SaveDialog"))
-- width: any but recommend 300 for minimum (that fits third button)
-- height: any
-- title: string to display in titlebar of dialog
-- prompt: string to display in a "separate" inset at bottom of dialog (bottom y is 52 when this used)
-- acceptText: text to put in the second button to do whatever dialog is meant to do
-- acceptFunc: function to run when accept button is clicked
-- cancelText: text to put in the bottomright button to dismiss the dialog and cancel its action
-- cancelFunc: function to run when cancel button clicked or dialog dismissed/hidden
-- otherText: text to put in the bottomleft button for some other action (default name for renaming)
-- otherFunc: function to do when other button is clicked (note this doesn't prevent cancelFunc!)

function rematch:ShowDialog(dialogName,width,height,title,prompt,acceptText,acceptFunc,cancelText,cancelFunc,otherText,otherFunc)
	dialog:ResetAll()
	rematch:HideWidgets()
	rematch:HideNotes()
	-- set stuff passed as parameters
	dialog.name = dialogName
	dialog:SetSize(width or 300,height or 320)
	dialog.Title:SetText(title)
	dialog.Prompt:SetShown(prompt and true)
	dialog.Prompt.Text:SetText(prompt or "")
	dialog.Accept:SetShown(acceptText and true)
	dialog.Accept:SetText(acceptText or "")
	dialog.acceptFunc = acceptFunc
	dialog.Cancel:SetText(cancelText)
	dialog.cancelFunc = cancelFunc
	dialog.Other:SetShown(otherText and true)
	dialog.Other:SetText(otherText or "")
	dialog.otherFunc = otherFunc

	dialog:Show()
	dialog.dialogName = dialogName

	return dialog
end

function rematch:HideDialog()
	dialog:Hide()
end

function dialog:OnHide()
	rematch.timeUIChanged = GetTime()
	if dialog.cancelFunc then
		dialog.cancelFunc()
	end
end

-- click of the Accept button at bottom of dialog
function dialog:AcceptOnClick()
	if dialog.Accept:IsEnabled() then
		dialog.cancelFunc = nil -- don't run the cancelFunc if accept clicked
		dialog:Hide()
		if dialog.acceptFunc then
			dialog.acceptFunc()
		end
	end
end

function dialog:OtherOnClick()
	if dialog.Other:IsEnabled() and dialog.otherFunc then
		dialog.otherFunc()
	end
end

-- returns true if name (ie "SaveAs") is visible; or any dialog if name not given
function rematch:IsDialogOpen(name)
	if name then
		return dialog:IsVisible() and dialog.dialogName==name
	else
		return dialog:IsVisible()
	end
end

-- hides/unanchors/wipes/resets widgets and script handlers for a clean slate
function dialog:ResetAll()
	wipe(dialog.context)
	for _,widget in ipairs(dialog.widgets) do
		dialog[widget]:Hide()
		dialog[widget]:ClearAllPoints()
	end
	dialog.acceptFunc = nil
	dialog.otherFunc = nil
	dialog.EditBox:SetWidth(220)
	dialog.EditBox:SetScript("OnTextChanged",dialog.EditBoxOnTextChanged)
	dialog.EditBox:SetText("")
	dialog.EditBox:SetScript("OnEnterPressed",dialog.EditBoxOnEnterPressed)
	dialog.EditBox:SetScript("OnEscapePressed",dialog.EditBoxOnEscapePressed)
	dialog.Accept:SetEnabled(true)
	dialog.Other:SetEnabled(true)
	dialog.Text:SetText("")
	dialog.Text:SetFontObject(GameFontNormal)
	dialog.Text:SetJustifyH("CENTER")
	dialog.CheckButton.text:SetText("")
	dialog.CheckButton.text:SetFontObject(GameFontNormal)
	dialog.CheckButton:SetScript("OnClick",nil)
	dialog.CheckButton:SetChecked(false)
	dialog.CheckButton.tooltipTitle = nil
	dialog.CheckButton.tooltipBody = nil
	dialog.MultiLine.EditBox:SetScript("OnTextChanged",nil)
	dialog.MultiLine.EditBox:SetText("")
	dialog.MultiLine.EditBox:SetScript("OnEscapePressed",dialog.EditBoxOnEscapePressed)
	dialog.MultiLine.EditBox:SetScript("OnEditFocusGained",nil)
end

function dialog:RegisterWidget(name)
	tinsert(dialog.widgets,name)
end

function dialog:OnKeyDown(key)
	if key==GetBindingKey("TOGGLEGAMEMENU") then
		if rematch:IsDialogOpen("ScriptFilterDialog") and dialog.ScriptFilter.referenceOpen then
			dialog.ScriptFilter:HideReference() -- if script filter open, hide reference
		else
			dialog:Hide() -- otherwise hide menu but don't pass ESC along
		end
		self:SetPropagateKeyboardInput(false)
	else -- ESC not hit, send it along
		self:SetPropagateKeyboardInput(true)
	end
end

-- default behavior of EditBox: disable Accept if it's empty
function dialog:EditBoxOnTextChanged()
	dialog.Accept:SetEnabled(self:GetText():trim():len()>0)
end

function dialog:EditBoxOnEnterPressed()
	if dialog.Accept:IsEnabled() then
		dialog.Accept:Click()
	end
end

function dialog:EditBoxOnEscapePressed()
	dialog:Hide()
end

function dialog:SetContext(var,value)
	dialog.context[var] = value
	return value
end

function dialog:GetContext(var)
	return dialog.context[var]
end

function dialog:FillTeam(frame,team)
	local saved = RematchSaved
	for i=1,3 do
		rematch:FillPetSlot(frame.Pets[i],team[i][1])
		if frame.Pets[i].Missing then
			frame.Pets[i].Missing:Hide()
		end
		for j=1,3 do
			local button = frame.Pets[i].Abilities[j]
			local abilityID = team[i][j+1]
			if abilityID and abilityID~=0 then
				button.abilityID = abilityID
				button.Icon:SetTexture((select(3,C_PetBattles.GetAbilityInfoByID(abilityID))))
				button.Icon:SetTexCoord(0.075,0.925,0.075,0.925)
			else
				button.abilityID = nil
				button.Icon:SetTexture("Interface\\Buttons\\UI-EmptySlot-Disabled")
				button.Icon:SetTexCoord(0.21875,0.765625,0.21875,0.765625)
			end
		end
	end
end

-- sets dialog.Text to test, sizes to cx,cy dimensions and anchors it to ...
function dialog:ShowText(text,cx,cy,...)
	dialog.Text:SetSize(cx,cy)
	dialog.Text:SetText(text)
	dialog.Text:SetPoint(...)
	dialog.Text:Show()
end


function dialog:UpdateTabPicker()
	local index = rematch.TeamTabs:GetSelectedTab()
	local settings = RematchSettings
	dialog.TabPicker.Text:SetText(settings.TeamGroups[index][1])
	dialog.TabPicker.Icon:SetTexture(settings.TeamGroups[index][2])
	local team = rematch:GetSideline()
	if team then
		team.tab = index>1 and index or nil
	end
end

function dialog.TabPicker:OnClick()
	rematch:ToggleMenu("TabPick","TOPRIGHT",self,"BOTTOMRIGHT",0,2)
end

function dialog:CancelOnClick()
	if rematch:IsDialogOpen("ScriptFilterDialog") and dialog.ScriptFilter.referenceOpen then
		dialog.ScriptFilter:HideReference()
	else
		dialog:Hide()
	end
end
