local _,L = ...
local rematch = Rematch

-- call during initialization to set text, size and position of all tabs;
-- it also makes the parent frame fit around the tabs (set noAutoSize
-- keyvalue to parent frame to prevent this)
function rematch:SetupPanelTabs(frame,activeIndex,...)
	local totalWidth = 0
	for i=1,select("#",...) do
		local button = frame.Tabs[i]
		local label = select(i,...)
		button.Text:SetText(label)
		local width = max(76,button.Text:GetStringWidth()+40-(rematch.localeSquish and 8 or 0))
		button:SetWidth(width)
		button.width = width-16
		totalWidth = totalWidth + button.width
		local index = button:GetID()
		if index==1 then
			button:SetPoint("TOPLEFT")
		elseif index>1 then
			button:SetPoint("LEFT",frame.Tabs[index-1],"RIGHT",-16,0)
		end
	end
	frame.activeTab = activeIndex or 1
	if not frame.noAutoSize then
		frame:SetWidth(totalWidth+16)
	end
end

function rematch:UpdatePanelTabs(parent)
	for i=1,#parent.Tabs do
		local button = parent.Tabs[i]
		local active = parent.activeTab==i
		for i=1,3 do
			button.Inactive[i]:SetShown(not active)
			button.Active[i]:SetShown(active and true)
		end
		button.Text:SetPoint("CENTER",0,active and -3 or 2)
		button.Highlight:SetPoint("BOTTOMRIGHT",-12,active and 1 or 7)
		button:SetNormalFontObject(active and GameFontHighlightSmall or GameFontNormalSmall)
	end
end

-- call when a tab clicked (unless tab shouldn't select like MiniPanel)
function rematch:SelectPanelTab(parent,index)
	parent.activeTab = index
	rematch:ConfigureFrameTabs(parent)
	rematch:UpdatePanelTabs(parent)
end

-- returns the currently selected tab
function rematch:GetSelectedPanelTab(parent)
	return parent.activeTab
end

-- special case for frame.PanelTabs and UseMiniQueue removing the queue tab:
-- adds/drops the Queue tab, reanchors Options tab and resizes parent (frame.PanelTabs)
-- meat of the function only runs if a change actually has to happen
function rematch:ConfigureFrameTabs(parent)
	if parent==rematch.Frame.PanelTabs then
		local settings = RematchSettings
		-- if queue tab (Tabs[3]) is visible and it shouldn't be or vice versa
		if (parent.Tabs[3]:IsShown() and settings.SinglePanel and settings.UseMiniQueue) or (not parent.Tabs[3]:IsShown() and (not settings.SinglePanel or not settings.UseMiniQueue)) then
			local show = not parent.Tabs[3]:IsShown()
			parent.Tabs[3]:SetShown(show)
			parent.Tabs[4]:SetPoint("LEFT",parent.Tabs[show and 3 or 2],"RIGHT",-16,0)
			local width = 0 -- recalculate width of parent
			for i=1,4 do
				width = width + ((i~=3 or show) and parent.Tabs[i].width or 0)
			end
			parent:SetWidth(width+16)
		end
	end
end