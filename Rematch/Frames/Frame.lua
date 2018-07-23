local _,L = ...
local rematch = Rematch
local frame = RematchFrame
local settings

rematch:InitModule(function()
	rematch.Frame = frame
	settings = RematchSettings
	settings.ActivePanel = settings.ActivePanel or 1
	if not settings.CornerPos or not settings.XPos then
		settings.CornerPos = "BOTTOMLEFT"
		frame:UpdateCorner()
	end
	rematch:AdjustScale(frame,true)
	rematch:SetupPanelTabs(frame.PanelTabs,settings.ActivePanel,L["Pets"],L["Teams"],L["Queue"],L["Options"])
	for i=1,4 do
		frame.PanelTabs.Tabs[i]:SetScript("OnClick",frame.PanelTabOnClick)
	end
	frame.TitleBar.Title:SetText(L["Rematch"])
	frame.TitleBar.SinglePanelButton.tooltipTitle = L["Toggle Single Panel Mode"]
	frame.TitleBar.SinglePanelButton.tooltipBody = L["Toggle between one panel or two panels side by side."]

	rematch:ConvertTitlebarCloseButton(frame.TitleBar.CloseButton)
end)

-- this is UpdateUI stuff, just title and lock button status
-- major changes to frame are done in ConfigureFrame
function frame:Update()
	rematch:SetTitlebarButtonIcon(frame.TitleBar.LockButton,settings.LockPosition and "lock" or "unlock")
	frame.TitleBar.SinglePanelButton:SetShown(not settings.Minimized)
end

function frame:Toggle()
	if not InCombatLockdown() then
		frame:SetShown(not frame:IsShown())
	else
		rematch:print(L["You are in combat. Try again when out of combat."])
	end
end

function frame:UpdateSinglePanelButton()
	if not settings.Minimized then
		if settings.CornerPos=="BOTTOMLEFT" or settings.CornerPos=="TOPLEFT" then
			rematch:SetTitlebarButtonIcon(frame.TitleBar.SinglePanelButton,settings.SinglePanel and "right" or "left")
		else
			rematch:SetTitlebarButtonIcon(frame.TitleBar.SinglePanelButton,settings.SinglePanel and "left" or "right")
		end
	end
end

function frame:OnShow()
	-- if pets aren't loaded, and frame is attempting to show, display a loading dialog
	rematch.timeUIChanged = GetTime()
	frame:ConfigureFrame()
	frame.showAfterBattle = nil
	frame.showAfterCombat = nil
	if not settings.LockWindow then
		rematch:SetESCable("RematchFrame",true)
	end
	settings.JournalUsed = nil
end

function frame:OnHide()
	rematch:HideWidgets()
	rematch:HideDialog()
	rematch:SetESCable("RematchFrame",false)
	C_PetJournal.ClearRecentFanfares()
	-- when frame hides due to entering battle, we may not actually be in battle yet; this will wait
	if not C_PetBattles.IsInBattle() then
		C_Timer.After(0.75,frame.CheckIfHidingForBattle)
		-- while here, if we're not in combat or pvp, check if backup reminder should happen
		if not InCombatLockdown() and not C_PetBattles.GetPVPMatchmakingInfo() then
			rematch:CheckForBackupReminder()
		end
	end
end

-- if frame is automatically hidden due to entering battle, we may not be in battle yet.
-- the OnHide above will check 0.75 seconds after the frame hides to see if we're in battle
function frame:CheckIfHidingForBattle()
	if C_PetBattles.IsInBattle() then
		frame.showAfterBattle = true -- and mark frame to show after battle if so
	end
end

-- call when frame moves or CornerPos changes (options) to update XPos,YPos to new position
function frame:UpdateCorner()
	local corner = settings.CornerPos
	if corner=="BOTTOMRIGHT" then
		settings.XPos, settings.YPos = frame:GetRight(), frame:GetBottom()
	elseif corner=="TOPRIGHT" then
		settings.XPos, settings.YPos = frame:GetRight(), frame:GetTop()
	elseif corner=="BOTTOMLEFT" then
		settings.XPos, settings.YPos = frame:GetLeft(), frame:GetBottom()
	elseif corner=="TOPLEFT" then
		settings.XPos, settings.YPos = frame:GetLeft(), frame:GetTop()
	end
	frame:SetPoint(corner,UIParent,"BOTTOMLEFT",settings.XPos,settings.YPos)
end

function frame:SelectPanel(index,unselect)
	settings.ActivePanel = index
	frame:ConfigureFrame()
end

function frame:MoveStart()
	if not settings.LockPosition or IsShiftKeyDown() then
		rematch:HideWidgets()
		frame:StartMoving()
	end
end

function frame:MoveStop()
	frame:StopMovingOrSizing()
	frame:SetUserPlaced(false)
	frame:UpdateCorner()
end

-- onclick of the minimize button
function frame:ToggleSize()
	settings.Minimized = not settings.Minimized
	rematch:HideWidgets()
	rematch.timeUIChanged = GetTime()
	frame:ConfigureFrame()
end

function frame:LockButtonOnClick()
	settings.LockPosition = not settings.LockPosition
	frame:Update()
end

-- this is set as the OnKeyDown in Options
function frame:MinimizeOnKeyDown(key)
	if key==GetBindingKey("TOGGLEGAMEMENU") and not settings.Minimized then
		frame:ToggleSize() -- minimize but don't pass ESC along
		self:SetPropagateKeyboardInput(false)
	else -- ESC not hit (or already minimized), send it along
		self:SetPropagateKeyboardInput(true)
	end
end

-- when one of the panel tabs is clicked
function frame:PanelTabOnClick()
	if settings.Minimized then
		settings.Minimized = nil
		RematchFrame:SelectPanel(self:GetID())
	elseif settings.ActivePanel==self:GetID() then
		if not (settings.LockDrawer and settings.DontMinTabToggle) then
			-- if we're clicking the same tab (and settings "Don't Minimize With ESC Key" and "Or With Panel Tabs" not checked), minimize
			frame:ToggleSize()
		end
	else -- otherwise select new tab
		frame:SelectPanel(self:GetID())
	end
end

-- for Bindings.xml
function rematch:ToggleFrameTab(tab)
	local visible = frame:IsVisible()
	if settings.SinglePanel and settings.UseMiniQueue and tab==3 then
		tab = 1 -- if toggling queue panel while in narrow mode (with pets+queue combined) go to pets tab
	end
	if visible and settings.ActivePanel==tab and not settings.Minimized then
		frame:Hide()
	else
		settings.ActivePanel = tab
		settings.Minimized = nil
		if not visible then
			frame:Toggle() -- not on screen, show it
		else
			frame:ConfigureFrame() -- already on screen, reconfigure
		end
	end
end
