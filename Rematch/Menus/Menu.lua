--[[
This menu system is intended to be used in place of the default DropDownMenu.

Instead of building menus on the fly, menus are pre-made tables with functions to fetch
run-time values.

	To use:
	1) Once per session, register a menu table with rematch:RegisterMenu("name",table)
	2) If a petID or team key being acted on, rematch:SetMenuSubject(petID or whatever)
	3) rematch:ShowMenu("name"[,"cursor"]) or ("name",anchorPoint,relativeTo,relativePoint,xoff,yoff)

	Valid menu tags: title, hidden, indent, disable, subMenu, check, radio, value, icon, text,
	stay, iconCoords, func, spacer, highlight, noPostFunc, tooltipTitle, tooltipBody,
	disableReason
]]


local _,L = ...
local rematch = Rematch
local settings

local menus = {} -- table of registered menus, indexed by name
local menuPostFuncs = {} -- table of functions to run after the click of a registered menu item
local framePool = {} -- pool for menu frames in list form in order of level
local buttonPool = {} -- pool for menu buttons in list form
local menuLevel = nil -- level of menu we're on (index to framePool)
local subject = nil -- the object (usually petID or team key) a menu is acting on
local menuParent = nil -- the button/object that spawned the menu (or that menu is attached to)

-- a menu needs registered to add it to the menu table
-- menuName is an arbitrary name but should be unique to the table
function rematch:RegisterMenu(menuName,menuTable,func)
	menus[menuName] = menuTable
	menuPostFuncs[menuName] = func
end

-- returns the table created for menuName
function rematch:GetMenu(menuName) return menus[menuName] end
-- for functions that deal with a specific item (petID or team key), SetMenuSubject before ShowMenu
function rematch:SetMenuSubject(arg) subject=arg end
function rematch:GetMenuSubject() return subject end
function rematch:GetMenuParent() return menuParent end

-- returns true if a specific menu is open (ie "PetFilter") or any menu if none specified
function rematch:IsMenuOpen(menu)
	if not framePool[1] then return end -- no menus were ever opened!
	if not menu and framePool[1]:IsVisible() then return true end -- no menu specified, something is open
	for _,frame in ipairs(framePool) do
		if frame.menu==menu and frame:IsVisible() then
			return true
		end
	end
end

-- if a value is a function, returns the result of the function; otherwise the value itself
local function getvalue(entry,variable)
	if type(variable)=="function" then return variable(entry,subject) else return variable end
end

-- returns a menu frame for the menu level, creating one if needed
function rematch:GetMenuFrame(level,parent)
	local frame,name
	if not framePool[level] then -- create frame if it doesn't already exist
		frame = CreateFrame("Frame",level==1 and "RematchMenu" or nil,nil,"RematchMenuFrameTemplate")
		frame:SetID(level)
		framePool[level] = frame
		frame.Buttons = {}
		frame:SetScript("OnHide",rematch.MenuFrameOnHide)
		if level==1 then -- first level gets an OnUpdate and keyboard handler to capture ESC
			frame:SetScript("OnUpdate",rematch.MenuFrameOnUpdate)
			frame:EnableKeyboard(true)
			frame:SetScript("OnKeyDown",function(self,key)
				if key==GetBindingKey("TOGGLEGAMEMENU") then
					self:Hide() -- hide menu but don't pass ESC along
					self:SetPropagateKeyboardInput(false)
				else -- ESC not hit, send it along
					self:SetPropagateKeyboardInput(true)
				end
			end)
			frame.elapsed = 0
		end
	end
	frame = framePool[level]
	frame:SetParent(parent)
	frame:SetFrameStrata("FULLSCREEN_DIALOG")
	return frame
end

-- the checkbox/radio is one texture: Interface\Common\UI-DropDownRadioChecks
-- with checkbox textures in top half and radio textures in bottom half
-- and "on" texture on left and "off" texture on right
function rematch:MenuButtonSetChecked(button,isChecked,isRadio)
	local offset = (isRadio and 0.5 or 0) + (isChecked and 0.25 or 0)
	button.Check:SetTexCoord(offset,offset+0.25,0.5,0.75)
end

function rematch:MenuButtonSetEnabled(button,enabled)
	if enabled then
		button.Text:SetTextColor(1,1,1)
		button.Icon:SetDesaturated(false)
		button.Check:SetDesaturated(false)
		button:Enable()
	else
		button.Text:SetTextColor(0.5,0.5,0.5)
		button.Icon:SetDesaturated(true)
		button.Check:SetDesaturated(true)
		button:Disable()
	end
end

-- if anchorPoint is "cursor", menu is anchored to the cursor
-- if keepWidgets is true, widgets (pet card, dialogs, etc) aren't hidden
function rematch:ShowMenu(name,anchorPoint,relativeTo,relativePoint,anchorXoff,anchorYoff,keepWidgets)

	if not keepWidgets then
		rematch:HideWidgets("HideMenu")
	end

	-- when called by a subMenu, anchorPoint and relativeTo are both frames, and relativePoint is level
	local level = type(relativePoint)=="number" and relativePoint or 1

	if level==1 then
		if type(relativeTo)=="table" then
			menuParent = relativeTo
		else
			menuParent = GetMouseFocus()
		end
	end

	-- hide any menus at this level or deeper
	for i=level,#framePool do
		framePool[i]:Hide()
	end

	local frame = rematch:GetMenuFrame(level or 1,relativeTo or UIParent)
	frame.Title:Hide()
	frame.Shadow:SetPoint("TOPLEFT",3,-3)

	local numItems = #menus[name]
	local maxWidth = 32
	local hasSubMenu -- becomes true if any item in this menu has a sub-menu
	local yoff = -6
	local index = 1

	-- go through each entry and fill its button
	for i,entry in ipairs(menus[name]) do

		-- get a button (make one if needed)
		local button = frame.Buttons[i]
		if not button then
			frame.Buttons[i] = CreateFrame("Button",nil,frame,"RematchMenuButtonTemplate")
			button = frame.Buttons[i]
			button:SetID(i)
			button:SetScript("OnEnter",rematch.MenuButtonOnEnter)
			button:SetScript("OnLeave",rematch.MenuButtonOnLeave)
			button:SetScript("OnMouseDown",rematch.MenuButtonOnMouseDown)
			button:SetScript("OnMouseUp",rematch.MenuButtonOnMouseUp)
			button:SetScript("OnClick",rematch.MenuButtonOnClick)
		end

		-- wipe everything the button had before
		button.Icon:Hide()
		button.Check:Hide()
		button.Arrow:Hide()
		button.Text:SetText("")

		local width = 0
		local padding = getvalue(entry,entry.indent) or 0 -- amount of space to pad to left
		local padright = 0 -- amount of space to pad to the right
		local height = 20

		button.entry = entry

		if getvalue(entry,entry.hidden) then
			button:Hide() -- menu item is hidden
		else -- for non-hidden items
			button:SetPoint("TOPLEFT",8,yoff)
			if i==1 and entry.title then -- handle title
				frame.Title:Show()
				frame.Title.Text:SetText(getvalue(entry,entry.text))
				local titleWidth = frame.Title.Text:GetStringWidth()+16
				width = min(180,titleWidth) -- make titles 180 width at most unless further menu items widen menu
				button:Hide() -- the actual button is hidden
				frame.Shadow:SetPoint("TOPLEFT",3,-24)
			else -- non-title button
				-- spacer is a half-height gap with no visible button
				if entry.spacer then
					button:Hide()
					height = 6
				else
					button:Show()
				end
				-- check or radio button
				if getvalue(entry,entry.check) or getvalue(entry,entry.radio) then
					button.Check:SetPoint("LEFT",padding-2,entry.radio and -1 or 0) 
					padding = padding + 19
					button.isChecked = getvalue(entry,entry.value)
					rematch:MenuButtonSetChecked(button,button.isChecked,entry.radio)
					button.Check:Show()
				end
				-- icon
				local icon = getvalue(entry,entry.icon)
				if icon then
					button.Icon:SetPoint("LEFT",padding,0)
					padding = padding + 19
					button.Icon:SetTexture(icon)
					if entry.iconCoords then
						button.Icon:SetTexCoord(unpack(entry.iconCoords))
					else
						button.Icon:SetTexCoord(0.085,0.915,0.085,0.915)
					end
					button.Icon:Show()
				end
				-- button text
				button.Text:SetText(getvalue(entry,entry.text) or "")
				button.Text:SetPoint("LEFT",padding,0)
				width = button.Text:GetStringWidth()+2 -- little extra for "mouse down" shift
				-- submenu arrow
				if getvalue(entry,entry.subMenu) then
					hasSubMenu = true
					button.Arrow:Show()
					button.Arrow:SetTexCoord(0,1,1,1,0,0,1,0) -- rotate arrow
				end
				-- disabled state
				rematch:MenuButtonSetEnabled(button,not getvalue(entry,entry.disabled))
				-- text highlight (enabled button will be SetTextColor(1,1,1) already)
				if getvalue(entry,entry.highlight) then
					button.Text:SetTextColor(1,0.82,0)
				end
				-- delete button will go here, add space to show it
				if getvalue(entry,entry.deleteButton) then
					padright = 18
				end
				-- space for edit button (all menus with an edit button must have a delete button too)
				if getvalue(entry,entry.editButton) then
					padright = 34
				end
			end
			yoff = yoff - height
		end
		button.padding = padding
		maxWidth = max(maxWidth,width+padding+padright+(hasSubMenu and 8 or 0))
	end

	-- hide buttons not used
	for i=#menus[name]+1,#frame.Buttons do
		frame.Buttons[i]:Hide()
	end

	-- make all buttons the same width as the maxWidth
	for _,button in pairs(frame.Buttons) do
		button:SetWidth(maxWidth)
	end

	frame:SetSize(maxWidth+16,abs(yoff)+6)

	-- now position the frame
	local uiScale = UIParent:GetEffectiveScale()
	frame:ClearAllPoints()
	if type(anchorPoint)=="table" then -- if this subMenu is being anchored to a menu button
		if rematch.reverseMenuAnchor or (anchorPoint:GetRight()+maxWidth)*anchorPoint:GetEffectiveScale() > UIParent:GetRight()*uiScale then
			frame:SetPoint("TOPRIGHT",anchorPoint,"TOPLEFT",-2,5)
			rematch.reverseMenuAnchor = true
		else
			frame:SetPoint("TOPLEFT",anchorPoint,"TOPRIGHT",2,5)
		end
	elseif anchorPoint=="cursor" or not anchorPoint then -- if "cursor" or no anchor, to cursor
	  local x,y = GetCursorPosition()
		uiScale = frame:GetEffectiveScale()
		frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",x/uiScale-4,y/uiScale+4)
		rematch.reverseMenuAnchor = nil
	elseif anchorPoint then -- or a defined anchor
		frame:SetPoint(anchorPoint,relativeTo,relativePoint,anchorXoff,anchorYoff)
		rematch.reverseMenuAnchor = nil
	end

	frame.menu = name
	frame:Show()
end

-- shows or hides a menu as a toggle
function rematch:ToggleMenu(name,...)
	PlaySound(856)
	if rematch:IsMenuOpen(name) then
		rematch:HideMenu()
	else
		rematch:ShowMenu(name,...)
	end
end

function rematch:HideMenu()
	if framePool[1] then
		framePool[1]:Hide()
	end
end

-- when any menu frame hides, hide any menus deeper than the one being hidden
function rematch:MenuFrameOnHide()
	for i=self:GetID()+1,#framePool do
		framePool[i]:Hide()
	end
end

function rematch:MenuFrameOnUpdate(elapsed)
	self.elapsed = self.elapsed + elapsed
	if self.elapsed>0 then
		local overMenu
		for _,frame in ipairs(framePool) do
			if MouseIsOver(frame) then
				overMenu = true
			end
		end
		if overMenu then
			self.timeAway = 0
		elseif self.timeAway then
			self.timeAway = self.timeAway + self.elapsed
			if self.timeAway>2 then
				rematch:HideMenu()
				self.timeAway = nil -- timer doesn't start until mouse goes over menu
			end
		end
		self.elapsed = 0
	end
end

function rematch:MenuButtonOnEnter()
	self.Highlight:Show()
	rematch.MenuFrameOnHide(self:GetParent()) -- hide any menus deeper than the one belonging to this button
	-- if we entered a button with a subMenu, show it
	if self.entry.subMenu then
		local level = self:GetParent():GetID()
		rematch:ShowMenu(getvalue(self.entry,self.entry.subMenu),self,self,level+1)
	end
	-- show tooltip if entry has one and/or reason it's disabled if menu item disabled
	local tooltipTitle = self.entry.tooltipTitle
	local tooltipBody = getvalue(self.entry,self.entry.tooltipBody)
	local disabled = getvalue(self.entry,self.entry.disabled)
	local disabledReason = getvalue(self.entry,self.entry.disabledReason)
	if self.entry.tooltipTitle or tooltipBody or (disabled and disabledReason) then
		-- if menu button is disabled and a disabledReason is given, append it to the tooltipBody
		if disabled and disabledReason then
			if not tooltipTitle and not tooltipBody then -- if tooltip is disabled but has no body or title, make reason the title
				tooltipTitle = format("%s%s",rematch.hexRed,disabledReason)
				tooltipBody = nil
			else -- otherwise append reason to the end of the body (if one exists)
				tooltipBody = format("%s%s%s%s",tooltipBody or "",tooltipBody and "\n\n" or "",rematch.hexRed,disabledReason)
			end
		end
		rematch.ShowTooltip(self,tooltipTitle or getvalue(self.entry,self.entry.text),tooltipBody,self.entry.text==L["Help"])
	end
	-- if delete or edit+delete buttons are in entry, show the SideButtons
	if self.entry.editButton or self.entry.deleteButton then
		local sideButtons = RematchMenuSideButtons
		sideButtons:SetParent(self)
		sideButtons:SetPoint("RIGHT")
		sideButtons:SetWidth(self.entry.editButton and 32 or 16)
		sideButtons.Edit:SetShown(self.entry.editButton and true)
		sideButtons:Show()
	end

end

function rematch:MenuButtonOnLeave()
	self.Highlight:Hide()
	rematch:HideTooltip()
	if not MouseIsOver(RematchMenuSideButtons) then
		RematchMenuSideButtons:Hide()
	end
end

function rematch:MenuButtonOnMouseDown()
	if self:IsEnabled() then
		self.Text:SetPoint("LEFT",self.padding+2,-1)
	end
end

function rematch:MenuButtonOnMouseUp()
	self.Text:SetPoint("LEFT",self.padding,0)
end

function rematch:MenuButtonOnClick()
	PlaySound(856)
	rematch.timeUIChanged = GetTime() -- to prevent hiding menu from HideWidgets in various panels
	local entry = self.entry
	if type(entry.func)=="function" then
		entry.func(entry,subject,self.isChecked) -- run the func defined in the entry, passing itself and the subject
	end
	if not getvalue(entry,entry.stay) and not getvalue(entry,entry.check) and not getvalue(entry,entry.radio) and not entry.subMenu then
		rematch:HideMenu() -- if not staying, hide menu
	else -- we're staying, refresh menus
		rematch:RefreshMenus()
	end
	if not entry.noPostFunc and menuPostFuncs[self:GetParent().menu] then
		menuPostFuncs[self:GetParent().menu](entry)
	end
end

-- goes through all visible menus and updates checks/radios, disables and highlights
function rematch:RefreshMenus()
	for _,frame in ipairs(framePool) do
		if frame:IsVisible() then
			for _,button in ipairs(frame.Buttons) do
				if button:IsVisible() then
					local entry = button.entry
					if entry.check or entry.radio then
						button.isChecked = getvalue(entry,entry.value)
						rematch:MenuButtonSetChecked(button,button.isChecked,entry.radio)
					end
					rematch:MenuButtonSetEnabled(button,not getvalue(entry,entry.disabled))
					if getvalue(entry,entry.highlight) then
						button.Text:SetTextColor(1,0.82,0)
					end
				end
			end
		end
	end
end

-- onenter of delete or edit sidebuttons
function rematch:MenuSideButtonOnEnter()
	self:GetParent():GetParent().Highlight:Show()
end

-- onleave of delete or edit sidebuttons
function rematch:MenuSideButtonOnLeave()
	local parent = self:GetParent()
	if not MouseIsOver(parent) or not parent:GetParent():IsVisible() then
		parent:Hide()
		parent:GetParent().Highlight:Hide()
	end
end

-- onclick of delete or edit sidebuttons
function rematch:MenuSideButtonOnClick()
	local entry = self:GetParent():GetParent().entry
	if entry[self.func] then
		entry[self.func](entry)
	end
end
