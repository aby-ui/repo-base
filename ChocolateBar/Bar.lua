local ChocolateBar = LibStub("AceAddon-3.0"):GetAddon("ChocolateBar")

local LSM = LibStub("LibSharedMedia-3.0")
local Bar = ChocolateBar.Bar
local chocolate = ChocolateBar.ChocolatePiece
local Debug = ChocolateBar.Debug
local jostle = ChocolateBar.Jostle
local pairs, ipairs, table, math, mod = pairs, ipairs, table, math, mod
local CreateFrame, UIParent = CreateFrame, UIParent
local db

function Bar:OnMouseUp(button)
	if (db.combathidebar or self.settings.hideBarInCombat) and ChocolateBar.InCombat then return end
	if button == "RightButton" then
        if InCombatLockdown() then return end
		if db.disableoptons and ChocolateBar.InCombat then return end
		if db.barRightClick == "OPTIONS" then
			ChocolateBar:LoadOptions()
		elseif db.barRightClick == "BLIZZ" then
		  ChocolateBar:LoadOptions(nil, nil, true)
        elseif db.barRightClick == "163UI" and UUI then
            UUI.OpenToAddon("chocolatebar", true)
		end
	else
		if db.moreBar == self:GetName() then
			self:Hide()
		end
	end
end

function Bar:New(name, settings, database)
	db = database
	local frame = CreateFrame("Frame",name,UIParent)
	frame.chocolist = {} --create list of chocolate chocolist in the bar

	-- add class methods to frame object
	for k, v in pairs(Bar) do
		frame[k] = v
	end

	frame:SetPoint("TOPLEFT",-1,1);
	--frame:SetPoint("TOPLEFT", settings.xoff, settings.yoff);
	--frame:SetClampedToScreen(true)
	if settings.width == 0 then
		frame:ClearAllPoints()
		frame:SetPoint("TOPLEFT","UIParent",-1,1);
		frame:SetPoint("RIGHT", "UIParent" ,"RIGHT",0, 0);
	else
		frame:SetPoint("RIGHT", "UIParent",0, 0);
		frame:SetWidth(settings.width)
	end

	frame:SetHeight(db.height)
	frame:EnableMouse(true)
	frame:SetScript("OnEnter", function(self)
		if (db.combathidebar or settings.hideBarInCombat) and ChocolateBar.InCombat then return end
		self:ShowAll()
	end)
	frame:SetScript("OnLeave", function(self)
		if (db.combathidebar or settings.hideBarInCombat) and ChocolateBar.InCombat then return end
		if self.autohide then
			self:HideAll()
		end
	end)

	--frame:SetScript("OnMouseUp", function(self, button)
--
	--end)
	frame:SetScript("OnMouseUp", self.OnMouseUp)

	frame.settings = settings
	frame.autohide = settings.hideonleave
	frame:UpdateTexture(db)
	frame:UpdateColors(db)
	frame:UpdateStrata(db)
	return frame
end

function Bar:UpdateStrata(db)
	self:SetFrameStrata(db.strata)
end

function Bar:UpdateAutoHide(db)
	if self.settings.autohide then
		self.autohide = true
		self:HideAll()
		if jostle then jostle:Unregister(self) end
	else
		self.autohide = false
		self:ShowAll()
		self:UpdateJostle(db)
	end
end

function Bar:UpdateJostle(db)
  Debug("Bar:UpdateJostle(db)")
	if jostle then
		jostle:Unregister(self)
		if db.moveFrames then
			if self.settings.align == "bottom" then
				jostle:RegisterBottom(self)
			elseif  self.settings.align == "top" then
				jostle:RegisterTop(self)
			end
		end
	end
end

function Bar:UpdateScale(db)
	self.scale = db.scale
	self:SetScale(db.scale)
	self:UpdateJostle(db)
end

function Bar:UpdateHeight(db)
	local height = db.height
	self.height = height
	self:SetHeight(height)
	ChocolateBar:UpdateChoclates("updateSettings")
	db.fontSize = height - 8
	ChocolateBar:UpdateChoclates("updatefont")
	self:UpdateJostle(db)
end

function Bar:UpdateColors(db)
	local bg = db.background
	local color = bg.borderColor
	self:SetBackdropBorderColor(color.r,color.g,color.b,color.a)
	color = bg.color
	self:SetBackdropColor(color.r,color.g,color.b,color.a)
end

function Bar:UpdateTexture(db)
	--local background = LSM:Fetch("statusbar", db.background.texture)
	local bg = {
		bgFile = db.background.texture,
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = db.background.tile, tileSize = db.background.tileSize, edgeSize = db.background.edgeSize,
		--insets = { left = 4, right = 4, top = 4, bottom = 4}
		insets = { left = 0, right = 0, top = 0, bottom = 0}
	}
	--bg.bgFile = background
	self:SetBackdrop(bg);
	self:UpdateColors(db)
end

function Bar:ResetDrag(choco, name)
	self.chocolist[name] = choco
	self.dummy:Hide()
	self.dummy = nil
	choco:SetAlpha(1)
	self:UpdateBar()
end

-- add some chocolate to a bar
function Bar:AddChocolatePiece(choco, name, noupdate)

	local chocolist = self.chocolist
	if chocolist[name] then
		Debug("AddChocolatePiece: ",name," already in list.")
		return
	end

	chocolist[name] = choco
	choco:SetParent(self)
	choco.bar = self

	local settings = choco.settings
	settings.barName = self:GetName()
	--if not settings.index then
	--	settings.index = 1
	--end
	if not noupdate then
		self:UpdateBar()
	end

	if self:GetAlpha() < 1 then
		choco.text:Hide()
		if choco.icon then
			choco.icon:Hide()
		end
	end
end

-- eat some chocolate from a ChocolateBar
function Bar:EatChocolatePiece(name)
	self.chocolist = self.chocolist or {}
	local choco = self.chocolist[name]

	if choco then
		choco:Hide()
		self.chocolist[name] = nil
		self:UpdateBar()
	end
end

function Bar:HideAll()
	self:SetAlpha(0)
	for k, v in pairs(self.chocolist) do
		v.text:Hide()
		if v.icon then
			v.icon:Hide()
		end
	end
end

function Bar:ShowAll()
	--Timer:SetScript("OnUpdate", nil)
	self:SetAlpha(1)
	local settings
	for k, v in pairs(self.chocolist) do
		settings = v.settings
		--v:Show()
		if settings.showText then
			v.text:Show()
		end
		if settings.showIcon and v.icon then
			v.icon:Show()
		end
	end
end

function Bar:Disable()
	self:Hide()
	if jostle then jostle:Unregister(self) end
end

local function SortTab(tab)
	local templeft = {}
	local tempright = {}
	local tempcenter = {}

	for k,v in pairs(tab) do
		local index = v.settings.index or 500
		if v.settings.align == "left" then
			table.insert(templeft,{v,index})
		elseif v.settings.align == "center" then
			table.insert(tempcenter,{v,index})
		else
			table.insert(tempright,{v,index})
		end
	end
	table.sort(templeft, function(a,b)return a[2] < b[2] end)
	table.sort(tempcenter, function(a,b)return a[2] < b[2] end)
	table.sort(tempright, function(a,b)return a[2] < b[2] end)
	return templeft, tempcenter, tempright
end

local function SortList(list, side)
	local temp = {}
	for k,v in pairs(list) do
		local index = v.settings.index or 500
		if v.settings.align == side then
			table.insert(temp,{v,index})
		end
	end
	table.sort(temp, function(a,b)return a[2] < b[2] end)
	return temp
end

function Bar:GetChocolateAtCursor()
	local s = self:GetEffectiveScale()
	local x, y = GetCursorPosition()

	x = x/s
	for k, v in pairs(self.chocolist) do
		if x > v:GetLeft() and x < v:GetRight() then --plugin found
			if x < v:GetLeft()+v:GetWidth()/2 then
				return v,"left"
			else
				return v,"right"
			end
		end
	end
	-- cursor over bar
	local left = self.chocoMostLeft and self.chocoMostLeft:GetRight() or self:GetLeft()
	local right = self.chocoMostRight and self.chocoMostRight:GetLeft() or self:GetRight()
	local centerL = self.chocoCenterLeft and self.chocoCenterLeft:GetLeft() or self:GetWidth()/2
	local centerR = self.chocoCenterRight and self.chocoCenterRight:GetRight() or self:GetWidth()/2

	local nameCenterLeft = self.chocoCenterLeft and self.chocoCenterLeft:GetName()
	local nameCenterRight = self.chocoCenterRight and self.chocoCenterRight:GetName()

	if x < 8 then
		return nil, "left" , "left" --left half on left side
	end
	if x > UIParent:GetWidth()-8 then
		return nil, "right", "right"
	end

	local centerPos = "center"
	-- nocenter
	if left > centerR then
		if x < right/2+left/2 then
			return self.chocoMostLeft, "right", "left" --left half on right side
		else
			return self.chocoMostRight, "left" , "right" --right half on right side,
		end
	end
	if right < centerL then
		if x < right/2+left/2 then
			return self.chocoMostLeft, "right" , "left" --left half on left side
		else
			return self.chocoMostRight, "left" , "right" --right half on left side
		end
	end
	-- with center
	if x < centerL then
		if x < centerL/2+left/2 then
			return self.chocoMostLeft, "right" , "left" --left half on left side
		else
			return self.chocoCenterLeft, "left" , "center" --right half on left side
		end
	end
	if x > centerR and x < right then
		if x < right/2+centerR/2 then
			return self.chocoCenterRight, "right", "center" --left half on right side
		else
			return self.chocoMostRight, "left" , "right" --right half on right side,
		end
	end

	return nil, nil
end

--create a copy of the choco
local function createDummy(self, choco, name)
	local dummy = self.dummy
	if not dummy then
		--dummy = CreateFrame("Frame", "ChocolateDummy", self)
		dummy = chocolate:New("dummy", choco.obj, choco.settings, ChocolateBar.db.profile)
		dummy:SetParent(self)
		--dummy:SetAllPoints(chocolate.frame)
		dummy.name = "dummy"
		dummy:SetAlpha(0.5)
		dummy.bar = choco.bar
		self.dummy = dummy
	end
	dummy:Show()
	dummy:SetWidth(choco:GetWidth())
	dummy:SetHeight(choco:GetHeight())

	dummy.settings.index = choco.settings.index
	dummy.settings.align = choco.settings.align
	self.chocolist[name] = dummy --replace original with dummy to free the original
end

function Bar:UpdateDragChocolate()
	local choco, side, align = self:GetChocolateAtCursor()
	self.pointer = self.pointer or ChocolateBar:GetPointer(self)
	local pointer = self.pointer

	if choco then
		pointer.align = choco.settings.align --align
		local offset = 0.5
		if choco.settings.align == "right" then -- the right
			offset = -0.5
		end
		if side == "left"  then
			pointer.index = choco.settings.index - offset
			pointer:SetPoint("TOPLEFT",choco,0,0)
		else
			pointer.index = choco.settings.index + offset
			pointer:SetPoint("TOPLEFT",choco,"TOPRIGHT",0,0)
			--pointer:SetPoint("TOPRIGHT",choco,-5,0)
		end
	else
		if align == "left"  then
			pointer.index = 0.5
			pointer.align = "left"
			pointer:SetPoint("TOPLEFT",self,6,-1)
		elseif align == "right" then
			pointer.index = 0.5
			pointer.align = "right"
			pointer:SetPoint("TOPLEFT",self,"TOPRIGHT",0,0)
			--pointer:SetPoint("TOPRIGHT",choco,-5,0)
		else
			pointer.index = 1
			pointer.align = "center"
			--pointer:SetPoint("CENTER",self,"CENTER",0,0)
			pointer:SetPoint("TOPLEFT",self,self:GetWidth()/2,0)
		end
	end
	pointer:Show()
end

function Bar:Drag(name)
	local choco = self.chocolist[name]
	choco:SetAlpha(0.8)
	--if choco.OnLeave then choco:OnLeave() end
	createDummy(self, choco, name)
	self.pointer = ChocolateBar:GetPointer(self)
	self:UpdateBar(true)
end

function Bar:Drop(choco, pos)
	local settings = choco.settings
	settings.index = self.pointer.index
	settings.align = self.pointer.align
	choco:SetAlpha(1)
	self.pointer:Hide()

	local oldbar = ChocolateBar:GetBar(settings.barName)
	--check if droped from different bar
	if oldbar == self then -- same bar
		self.dummy:Hide()
		self.dummy = nil
		self.chocolist[choco.obj.name] = choco --replace dummy with original
	else -- cross bars
		oldbar.chocolist[choco.obj.name] = nil --remove from oldbar
		oldbar.dummy:Hide()
		oldbar.dummy = nil
		oldbar:UpdateBar(true)
		self:AddChocolatePiece(choco, choco.obj.name)
	end
	self:UpdateBar(true)
end

function Bar:LoseFocus(name)
	self.pointer:Hide()
end

function Bar:GetFocus(name)
	local choco = ChocolateBar:GetChocolate(name)
	ChocolateBar:GetPointer(self)
end

-- rearange all chocolate chocolist in a given bar
-- called only when chocolates are added, removed or moved
function Bar:UpdateBar(updateindex)
	local chocolates =  self.chocolist
	-- set left plugins
	local tempList = SortList(chocolates, "left")
	self.chocoMostLeft = tempList[#tempList] and tempList[#tempList][1]

	local yoff = 0
	local relative = nil
	for i, v in ipairs(tempList) do
		local choco = v[1]
		choco:ClearAllPoints()
		if(relative)then
			choco:SetPoint("TOPLEFT",relative,"TOPRIGHT", 0,0)
			choco:SetPoint("BOTTOM",self,"BOTTOM", 0,0)
			choco:SetPoint("TOP",self,0,0)
		else
			choco:SetPoint("TOPLEFT",self, 6,yoff)
			choco:SetPoint("BOTTOM",self,"BOTTOM", 0,0)
			choco:SetPoint("TOP",self,0,0)
		end
		if updateindex then
			choco.settings.index = i
		end
		relative = choco
	end

	-- set center plugins
	self.listCenter = SortList(chocolates, "center")
	local listCenter = self.listCenter
	self.chocoCenterLeft = listCenter[1] and listCenter[1][1]
	self.chocoCenterRight = listCenter[#listCenter] and listCenter[#listCenter][1]

	local centerIndex = math.ceil(#listCenter/2)
	local v = listCenter[centerIndex]
	local relative = nil

	if v then
		local centerChoco = v[1]
		self.centerChoco = centerChoco
		local last = nil
		if centerChoco then
			if mod(#listCenter,2) > 0 then --uneven
				centerChoco:ClearAllPoints()
				centerChoco:SetPoint("CENTER",self, 0,yoff)
				centerChoco:SetPoint("BOTTOM",self,"BOTTOM", 0,0)
			else --even
				centerChoco:ClearAllPoints()
				centerChoco:SetPoint("RIGHT",self,"CENTER", 0,yoff)
				centerChoco:SetPoint("BOTTOM",self,"BOTTOM", 0,0)
			end
			local relativeR = centerChoco

			for i, v in ipairs(listCenter) do
				local choco = v[1]
				if i <= centerIndex then
					if last then
					last:ClearAllPoints()
					last:SetPoint("TOPRIGHT",choco,"TOPLEFT", 0,0)
					last:SetPoint("BOTTOM",self,"BOTTOM", 0,0)
					end
					last = choco
				elseif i > centerIndex then
					choco:ClearAllPoints()
					choco:SetPoint("TOPLEFT",relativeR,"TOPRIGHT", 0,0)
					choco:SetPoint("BOTTOM",self,"BOTTOM", 0,0)
					relativeR = choco
				end
				if updateindex then
					choco.settings.index = i
				end
			end
		end
		self:UpdateCenter()
	end

	-- set right plugins
	tempList = SortList(chocolates, "right")
	self.chocoMostRight = tempList[#tempList] and tempList[#tempList][1]

	relative = nil
	for i, v in ipairs(tempList) do
		local choco = v[1]
		choco:ClearAllPoints()
		if(relative)then
			choco:SetPoint("TOPRIGHT",relative,"TOPLEFT", 0,0)
			choco:SetPoint("BOTTOM",self,"BOTTOM", 0,0)
			--list them downwards
			--choco:SetPoint("TOPLEFT",relative,"BOTTOMLEFT", 0,0)
		else
			choco:SetPoint("TOPRIGHT",self, 0,yoff)
			choco:SetPoint("BOTTOM",self,"BOTTOM", 0,0)
		end
		if updateindex then
			choco.settings.index = i
		end
		relative = choco
	end
end

function Bar:UpdateCenter()
	local centerChoco = self.centerChoco --the chocolate the others are aligend to
	if not centerChoco or not db.adjustCenter then return end

	local totalwidth = 0
	local centerChocoPosX = 0
	--get the total width of all center chocolate's and the relative position of the chocolate they are aligend to
	local listCenter = self.listCenter
	for i, v in ipairs(listCenter) do
		local choco = v[1]
		if i == math.ceil(#listCenter/2) then
			centerChocoPosX = totalwidth
		end
		totalwidth = totalwidth + choco:GetWidth()
	end
	local deltaX = totalwidth/2 - centerChocoPosX
	centerChoco:ClearAllPoints()
	centerChoco:SetPoint("LEFT",self,"CENTER", -deltaX,0)
	centerChoco:SetPoint("BOTTOM",self,"BOTTOM", -deltaX,0)
end
