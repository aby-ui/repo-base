--[[ Configure.lua contains rematch:ConfigureFrame() and supporting functions to
		 define the layout of the standalone frame. ]]

local _,L = ...
local rematch = Rematch
local frame = RematchFrame
local settings

-- these values define the overall configuration of the standalone window
frame.config = {
	bottomOffset = nil, -- bottom anchor above red panel buttons or toolbar buttons
	topOffset = nil, -- top anchor below toolbar buttons or titlebar
	frameWidth = nil, -- width of standalone frame
	frameHeight = nil, -- height of standalone frame
	panelWidth = nil, -- width of individual panels
	panelHeight = nil, -- height of an entire panel (including sub-panels)
}
local config = frame.config

-- these are layouts for each numbered tab, with "left"/"right" in the index of a rematch.panel to show
-- from Main.lua panels are ordered: PetPanel, LoadoutPanel, TeamPanel, QueuePanel, OptionPanel
frame.dualLayout = {{"left","right"},{nil,"left","right"},{"left",nil,nil,"right"},{nil,"left",nil,nil,"right"}}
-- for SinglePanel tab only shows one panel at a time
frame.singleLayout = {"PetPanel","TeamPanel","QueuePanel","OptionPanel"}

rematch:InitModule(function()
	rematch.Frame = frame
	settings = RematchSettings
end)

function frame:ConfigureFrame()

	-- if PetJournal is up, then it needs to hide before standalone frame can show
	if rematch.Journal:IsVisible() or (PetJournal and PetJournal:IsVisible()) then
		HideUIPanel(CollectionsJournal)
	end

	-- to start, hide all the things
	rematch:HideWidgets()
	rematch:HideDialog()
	rematch:HideNotes(settings.NotesNoESC)
	-- hide all panels too (except for the standalone frame) for a fresh start
	for _,panel in pairs(rematch.panels) do
		if panel~="RematchFrame" then
			_G[panel]:ClearAllPoints()
			_G[panel]:Hide()
		end
	end

	local bottomToolbar = settings.BottomToolbar or settings.Minimized

	-- offset from bottom of frame to anchor panels (offset past toolbar vs red panel buttons)
	config.bottomOffset = bottomToolbar and 40 or 26
	-- offset from top of frame to anchor panels (with BottomToolbar panels anchor to very top, otherwise past toolbar)
	config.topOffset = bottomToolbar and -24 or -58
	-- height of a full panel
	config.panelHeight = bottomToolbar and 540 or 520

	local frameWidth, frameHeight, panelWidth
	if settings.Minimized then -- minimized view
		frame:ConfigureMinimized()
	elseif settings.SinglePanel and settings.UseMiniQueue then -- single panel with pets+queue combined
		frame:ConfigureSinglePanelWithMiniQueue()
	elseif settings.SinglePanel then -- standard single panel
		frame:ConfigureSinglePanel()
	else -- standard dual panel standalone frame
		frame:ConfigureDualPanel()
	end

	rematch:SetTitlebarButtonIcon(frame.TitleBar.MinimizeButton,settings.Minimized and "maximize" or "minimize")
	frame.TitleBar:SetShown(not settings.Minimized or not settings.MiniMinimized)
	frame.PanelTabs:SetShown(not settings.Minimized or not settings.MiniMinimized)
	frame:UpdateSinglePanelButton()
	frame.TitleBar.Title:SetPoint("TOP",settings.Minimized and -10 or 0,-5)

	-- set the size of the whole standalone window
	frame:SetSize(config.frameWidth,config.frameHeight)
	-- update tabs across the bottom
	rematch:SelectPanelTab(frame.PanelTabs,not settings.Minimized and settings.ActivePanel or 0)

	if not settings.Minimized and (settings.ActivePanel==2 or settings.AlwaysTeamTabs) then
		rematch.TeamTabs:Configure(frame)
	end

	-- if toolbar buttons are at the bottom, show the "streaks" behind them
	frame.BottomTileStreaks:SetShown(bottomToolbar)
	frame.ShadowCornerBottomLeft:SetShown(bottomToolbar)
	frame.ShadowCornerBottomRight:SetShown(bottomToolbar)

	-- if a pet is on the cursor, sync the slot glows
	local petID = rematch:GetCursorPet()
	if petID then
		for i=1,3 do
			rematch.LoadoutPanel.Loadouts[i].DropButton.Glow:Stop()
			rematch.LoadoutPanel.Loadouts[i].DropButton.Glow:Play()
		end
		if rematch:PetCanLevel(petID) then
			rematch.QueuePanel.DropButton.Glow:Stop()
			rematch.QueuePanel.DropButton.Glow:Play()
		end
	end

	-- reaffirm saved position
	frame:ClearAllPoints()
	frame:SetPoint(settings.CornerPos,UIParent,"BOTTOMLEFT",settings.XPos,settings.YPos)

	-- finally do an UpdateUI to update/refresh the contents of all shown panels
	rematch:UpdateUI()

	-- gross hack to fix issue of queue's height changing causing scrollbar to be disabled/enabled
	-- when there was enough to fit before resize but not enough after resize; waiting a frame and
	-- then updating queue again when hitrect calculated properly
	if queueStartingHeight ~= rematch.QueuePanel.List:GetHeight() then
		C_Timer.After(0,rematch.QueuePanel.UpdateList)
	end

end

--[[ Major configurations ]]

-- minimized (Minimized=true, SinglePanel=any, UseMiniQueue=any)
function frame:ConfigureMinimized()
	config.frameWidth, config.frameHeight, config.panelWidth = 269, 184, 260
--	config.bottomOffset, config.topOffset, config.panelHeight = 4, -24, 92
	config.bottomOffset, config.panelHeight = 4, 92
	frame:PlaceMiniPanel()
	rematch.Toolbar:Resize(config.frameWidth)
	rematch:Reparent(rematch.Toolbar,frame,"BOTTOM",-1,4)
end

-- standard single panel (Minimized=false, SinglePanel=true, UseMiniQueue=false)
function frame:ConfigureSinglePanel()
	config.frameWidth, config.frameHeight, config.panelWidth = 347, 604, 337
	frame:PlaceMiniPanelOrOptions()
	frame:PlaceSinglePanel()
end

-- single panel with combined pets+queue (Minimized=false, SinglePanel=true, UseMiniQueue=true)
function frame:ConfigureSinglePanelWithMiniQueue()
	config.frameWidth, config.frameHeight, config.panelWidth = 378, 604, 368
	if settings.ActivePanel==3 then
		settings.ActivePanel = 1 -- switch to Pets tab if we were on Queue tab
	end
	frame:PlaceMiniPanelOrOptions()
	frame:PlaceSinglePanel()
end

-- dual panel (Minimized=false, SinglePanel=false, UseMiniQueue=false)
function frame:ConfigureDualPanel()
	config.frameWidth, config.frameHeight, config.panelWidth = 572, 604, 280
	frame:PlaceToolbarAndBottomPanel(true)
	for i=1,5 do -- going through first 5 panels as defined in Main.lua (Pet,Loadout,Team,Queue,Option)
		local panel = _G[rematch.panels[i]]
		local layout = frame.dualLayout[settings.ActivePanel]
		if layout and layout[i] then
			rematch:Reparent(panel,frame,"BOTTOMLEFT",frame,"BOTTOMLEFT",layout[i]=="left" and 4 or 286,config.bottomOffset)
			panel:SetHeight(config.panelHeight)
			if panel.Resize then -- LoadoutPanel has no Resize
				panel:Resize(config.panelWidth)
			end
		end
	end
	-- special case for queue tab (show MiniPanel and LoadedTeamPanel at top)
	if settings.ActivePanel==3 then
		rematch:Reparent(rematch.MiniPanel,frame,"TOPLEFT",frame,"TOPLEFT",286,config.topOffset-28) -- (28 is LoadedTeamPanel(26)+2)
		rematch.MiniPanel:Resize(config.panelWidth)
		rematch:Reparent(rematch.LoadedTeamPanel,frame,"TOPLEFT",frame,"TOPLEFT",286,config.topOffset)
		rematch.LoadedTeamPanel.maxWidth = config.panelWidth
		rematch.QueuePanel:SetPoint("TOPLEFT",rematch.MiniPanel,"BOTTOMLEFT",0,-2)
	else -- for the rest, move LoadedTeamPanel to the top of the Loadouts in the LoadoutPanel (too many Loads!)
		rematch:Reparent(rematch.LoadedTeamPanel,frame,"BOTTOMLEFT",rematch.LoadoutPanel.Loadouts[1],"TOPLEFT",0,2)
		rematch.LoadedTeamPanel.maxWidth = config.panelWidth
	end
end

--[[ Sub-panel placement ]]

-- positions the MiniPanel to the top of the frame (adjusted by anything that will be at the top)
-- used by minimize and both single panel views
function frame:PlaceMiniPanel()
	rematch:Reparent(rematch.MiniPanel,frame,"TOPLEFT",frame,"TOPLEFT",4,config.topOffset-28) -- (28 is LoadedTeamPanel(26)+2)
	rematch.MiniPanel:Resize(config.panelWidth)
	rematch:Reparent(rematch.LoadedTeamPanel,frame,"TOPLEFT",frame,"TOPLEFT",4,config.topOffset)
	rematch.LoadedTeamPanel.maxWidth = config.panelWidth
end

-- used by both single panel views to place minimap at top of frame unless we're in options tab
function frame:PlaceMiniPanelOrOptions()
	if settings.ActivePanel~=4 then -- if not in options put MiniPanel at top
		frame:PlaceMiniPanel()
	else -- if options then hide MiniPanel and LoadedTeamPanel
		rematch.OptionPanel:SetHeight(config.panelHeight)
	end
end

-- sets up major panels in a SinglePanel view
function frame:PlaceSinglePanel()
	for i=1,4 do
		local panel = rematch[frame.singleLayout[i]]
		if i==settings.ActivePanel then
			rematch:Reparent(panel,frame,"BOTTOMLEFT",frame,"BOTTOMLEFT",4,config.bottomOffset)
			if i~=4 then -- for all but options, anchor top of panel to bottom of MiniPanel
				panel:SetPoint("TOPLEFT",rematch.MiniPanel,"BOTTOMLEFT",0,-2)
			end
			if settings.UseMiniQueue and i==1 then -- if on PetPanel and UseMiniQueue enabeld
				panel:Resize(290 - (settings.SlimListButtons and 12 or 0)) -- resize PetPanel to fit MiniQueue
				rematch:Reparent(rematch.MiniQueue,panel,"TOPRIGHT",rematch.MiniPanel,"BOTTOMRIGHT",0,-2)
				rematch.MiniQueue:SetPoint("BOTTOMLEFT",rematch.PetPanel,"BOTTOMRIGHT",2,0)
			else -- for all other panels resize to panelWidth
				panel:Resize(config.panelWidth)
			end
			panel:SetHeight(config.panelHeight)
		end
	end
	frame:PlaceToolbarAndBottomPanel()
end

-- places the toolbar at top/bottom and bottom red buttons depending on BottomToolar setting
function frame:PlaceToolbarAndBottomPanel(showSummon)
	rematch.Toolbar:Resize(config.frameWidth)
	if not settings.BottomToolbar then
		rematch:Reparent(rematch.BottomPanel,frame,"BOTTOMLEFT")
		rematch.BottomPanel:SetPoint("BOTTOMRIGHT")
		rematch.BottomPanel:Resize(config.frameWidth,nil,showSummon)
		rematch:Reparent(rematch.Toolbar,frame,"TOPLEFT",5,-25)
	else
		rematch:Reparent(rematch.Toolbar,frame,"BOTTOM",-1,4)
	end
end
