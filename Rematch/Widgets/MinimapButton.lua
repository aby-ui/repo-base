local _,L = ...
local rematch = Rematch

function rematch:CreateMinimapButton()
	if RematchMinimapButton then
		return
	end
	local button = CreateFrame("Button","RematchMinimapButton",Minimap)
	button:SetSize(31,31)
	button:SetToplevel(true)
	button:SetFrameStrata("MEDIUM")
	button:SetFrameLevel(button:GetFrameLevel()+3)
	button:RegisterForClicks("AnyUp")
	button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
	button.icon = button:CreateTexture(nil,"BACKGROUND")
	button.icon:SetTexture("Interface\\Icons\\PetJournalPortrait")
	button.icon:SetSize(20,20)
	button.icon:SetPoint("CENTER")
	local border = button:CreateTexture(nil,"OVERLAY")
	border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
	border:SetSize(53,53)
	border:SetPoint("TOPLEFT")
	button:SetScript("OnMouseDown",rematch.MinimapButtonOnMouseDown)
	button:SetScript("OnMouseUp",rematch.MinimapButtonOnMouseUp)
	button:SetScript("OnClick",function(self,button)
		if button=="RightButton" then
			rematch:MinimapFavoriteTeams()
		else
			rematch:HideMenu()
			rematch.Frame:Toggle()
		end
	end)
	button:SetScript("OnEnter",function(self)
		GameTooltip:SetOwner(self,"ANCHOR_LEFT")
		GameTooltip:SetText(L["Rematch"],1,1,1)
		GameTooltip:AddLine(format("%s %s",rematch.LMB,L["Toggle Window"]))
		GameTooltip:AddLine(format("%s %s",rematch.RMB,L["Load Favorite Team"]))
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave",function(self)
		GameTooltip:Hide()
	end)
	button:RegisterForDrag("LeftButton")
	button:SetScript("OnDragStart",rematch.MinimapButtonOnDragStart)
	button:SetScript("OnDragStop",rematch.MinimapButtonOnDragStop)
end

function rematch:MinimapButtonOnMouseDown()
	self.icon:SetPoint("CENTER",1,-1)
	self.icon:SetVertexColor(.75,.75,.75)
end

function rematch:MinimapButtonOnMouseUp()
	self.icon:SetPoint("CENTER")
	self.icon:SetVertexColor(1,1,1)
end

function rematch:MinimapButtonOnDragStart()
	rematch:HideMenu()
	self.update = self.update or CreateFrame("Frame",nil,self)
	self.update:SetScript("OnUpdate",rematch.MinimapButtonDragUpdate)
end

function rematch:MinimapButtonOnDragStop()
	rematch.MinimapButtonOnMouseUp(self) -- release button
	self.update:SetScript("OnUpdate",nil)
end

function rematch:MinimapButtonDragUpdate(elapsed)
	local x,y = GetCursorPosition()
	local minX,minY = Minimap:GetLeft(), Minimap:GetBottom()
	local scale = Minimap:GetEffectiveScale()
	RematchSettings.minimapButtonPosition = math.deg(math.atan2(y/scale-minY-70,minX-x/scale+70))
	rematch:MinimapButtonPosition()
end

function rematch:MinimapButtonPosition()
	local angle = RematchSettings.minimapButtonPosition or -162
	RematchMinimapButton:SetPoint("TOPLEFT",Minimap,"TOPLEFT",52-(80*cos(angle)),(80*sin(angle))-52)
end

-- from the right-click of the minimap button: generate a menu of favorite teams to load
function rematch:MinimapFavoriteTeams()
	if rematch:IsMenuOpen("MinimapFavorites") then
		rematch:HideMenu()
	else
		local favorites = {} -- gather all favorites into this table
		for key,team in pairs(RematchSaved) do
			if team.favorite then
				tinsert(favorites,key)
			end
		end
		table.sort(favorites,rematch.TeamSort) -- sort teams as if they were its own tab
		-- register menu if it hasn't been reigstered yet
		if not rematch:GetMenu("MinimapFavorites") then
			rematch:RegisterMenu("MinimapFavorites",{})
		end
		local menu = rematch:GetMenu("MinimapFavorites")
		wipe(menu) -- and recreate it (some garbage creation is fine, this is not a frequent event)
		tinsert(menu,{text=L["Favorite Teams"],title=true})
		for _,key in ipairs(favorites) do
			local icon = RematchSettings.TeamGroups[RematchSaved[key].tab or 1][2]
			tinsert(menu,{text=rematch:GetTeamTitle(key),highlight=type(key)=="string",icon=icon,key=key,func=function(self) rematch:LoadTeam(self.key) end})
		end
		if #menu==1 then -- only title added, no favorite teams :(
			tinsert(menu,{text=NONE,disabled=true,icon="Interface\\Icons\\Spell_Misc_EmotionSad"})
		end
		rematch:ShowMenu("MinimapFavorites","cursor")
		RematchMenu:ClearAllPoints()
		RematchMenu:SetPoint("TOPRIGHT",RematchMinimapButton,"BOTTOMLEFT",8,8)
	end
end
