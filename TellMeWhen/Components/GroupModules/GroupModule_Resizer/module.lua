-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print


TMW:NewClass("GroupModule_Resizer", "GroupModule", "Resizer_Generic"){
	tooltipTitle = L["RESIZE"],

	METHOD_EXTENSIONS = {
		OnImplementIntoGroup = function(self)
			local group = self.group
			
			local GroupPosition = group:GetModuleOrModuleChild("GroupModule_GroupPosition")
			
			if not GroupPosition then
				error("Implementing GroupModule_Resizer (or a derivative) requies that GroupModule_GroupPosition (or a derivative) already be implemented.")
			end

			if TMW.Locked or not GroupPosition:CanMove() then
				self:Disable()
			else
				self:Enable()
			end
		
			self.resizeButton:SetFrameLevel(group:GetFrameLevel() + 3)
			
			self.resizeButton.__noWrapTooltipText = true
			TMW:TT(self.resizeButton, self.tooltipTitle, self.tooltipText .. "\r\n" .. L["RESIZE_TOOLTIP_CHANGEDIMS"], 1, 1)
		end,

		StartSizing = function(resizeButton)
			local self = resizeButton.module
			local group = self.group

			self.oldColumns, self.oldRows = group.Columns, group.Rows

			if self.button == "RightButton" then
				group:ClearAllPoints()
				group:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", self.oldX, self.oldY)
			end
		end,
	},

	METHOD_EXTENSIONS_PRE = {
		StartSizing = function(resizeButton)
			local self = resizeButton.module
			self:UpdateEnabledState()
		end,
	},

	UpdateEnabledState = function(self) 
		local group = self.group
		local GroupPosition = group:GetModuleOrModuleChild("GroupModule_GroupPosition")
		if TMW.Locked or not GroupPosition:CanMove() then
			self:Disable()
		else
			self:Enable()
		end
	end,
	
	OnEnable = function(self)
		self:Show()
		self:ShowTexture()
	end,
	
	OnDisable = function(self)
		-- Don't hide if we are dragging, because then the OnMouseUp script won't fire when we finish.
		-- This module is never really being disabled unless we are LockToggle()-ing TMW,
		-- and we probably aren't dragging anything when that happens.
		if not self.resizeButton:GetScript("OnUpdate") then
			self:Hide()
		end
	end,

	StopSizing = function(resizeButton)
		local self = resizeButton.module
		local group = self.group
		
		resizeButton:SetScript("OnUpdate", nil)
	
		local GroupModule_GroupPosition = group:GetModuleOrModuleChild("GroupModule_GroupPosition")
		GroupModule_GroupPosition:UpdatePositionAfterMovement()
		
		group:Setup()
	end,

	SizeUpdate_RightButton = function(resizeButton)
		local self = resizeButton.module
		local group = self.group

		local std_cursorX, std_cursorY = self:GetStandardizedCursorCoordinates()

		-- Calculate new number of columns and groups:
		local std_newWidth = std_cursorX - self.std_oldLeft
		local ratio_SizeChangeX = std_newWidth/self.std_oldWidth
		local newColumns = floor(self.oldColumns * ratio_SizeChangeX + 0.5)
		newColumns = min(TELLMEWHEN_MAXROWS, max(1, newColumns))
		
		local std_newHeight = self.std_oldTop - std_cursorY
		local ratio_SizeChangeY = std_newHeight/self.std_oldHeight
		local newRows = floor(self.oldRows * ratio_SizeChangeY + 0.5)
		newRows = min(TELLMEWHEN_MAXROWS, max(1, newRows))
		
		if newColumns ~= group.Columns or newRows ~= group.Rows then
			local gs = group:GetSettings()

			local ics_old = TMW.CI.ics

			local GroupModule_GroupPosition = group:GetModuleOrModuleChild("GroupModule_GroupPosition")
			GroupModule_GroupPosition:UpdatePositionAfterMovement()


			local GroupModule_IconPosition = group:GetModuleOrModuleChild("GroupModule_IconPosition")
			GroupModule_IconPosition:AdjustIconsForModNumRowsCols(newRows - group.Rows, newColumns - group.Columns)


			gs.Rows = newRows
			gs.Columns = newColumns
	
			group:Setup()

			if TMW.CI.ics ~= ics_old then
				TMW.IE:LoadIcon(1, false)
			end
		end
	end,
}







TMW:NewClass("GroupModule_Resizer_ScaleXY", "GroupModule_Resizer"){
	tooltipText = L["RESIZE_TOOLTIP_SCALEXY"],
	scale_min = 0.6,

	OnNewInstance_GroupModule_Resizer_ScaleXY = function(self)
		self:SetModes(self.MODE_SCALE, self.MODE_SCALE)
	end,

	SizeUpdated = function(self)
		local group = self.group
		local gs = group:GetSettings()

		gs.Scale = group:GetScale()
	end,
}







TMW:NewClass("GroupModule_Resizer_ScaleY_SizeX", "GroupModule_Resizer"){
	tooltipText = L["RESIZE_TOOLTIP_SCALEY_SIZEX"],
	UPD_INTV = 1,
	LastUpdate = 0,

	scale_min = 0.25,

	OnNewInstance_GroupModule_Resizer_ScaleY_SizeX = function(self)
		self:SetModes(self.MODE_SIZE, self.MODE_SCALE)
	end,

	SizeUpdated = function(self)
		local group = self.group
		local gs = group:GetSettings()
		local gspv = group:GetSettingsPerView()

		-- Scale
		gs.Scale = group:GetScale()


		local std_spacing = gspv.SpacingX*group:GetEffectiveScale()

		-- Width has already been set by SizeUpdate(). Get it with GetStandardizedSize().
		local std_newFrameWidth = self:GetStandardizedSize()
		local std_newWidth = (std_newFrameWidth + std_spacing)/gs.Columns - std_spacing
		local newWidth = std_newWidth/group:GetEffectiveScale()

		newWidth = max(gspv.SizeY, newWidth)
		gspv.SizeX = newWidth
		

		-- Update size settings for the group.
		-- This needs to be done before we :Setup() or otherwise bad things happen.
		local GroupModule_GroupPosition = group:GetModuleOrModuleChild("GroupModule_GroupPosition")
		GroupModule_GroupPosition:UpdatePositionAfterMovement()
			
		if self.LastUpdate <= TMW.time - self.UPD_INTV then
			-- Update the group completely very infrequently because of the high CPU usage.
			
			self.LastUpdate = TMW.time
		
			group:Setup()
		else
			-- Don't setup icons most of the time. Only setup the group.
			
			group:Setup(true)
		end

		self:HideTexture()
	end,
}







TMW:NewClass("GroupModule_Resizer_ScaleX_SizeY", "GroupModule_Resizer"){
	tooltipText = L["RESIZE_TOOLTIP_SCALEX_SIZEY"],
	UPD_INTV = 1,
	LastUpdate = 0,

	scale_min = 0.25,

	OnNewInstance_GroupModule_Resizer_ScaleX_SizeY = function(self)
		self:SetModes(self.MODE_SCALE, self.MODE_SIZE)
	end,

	SizeUpdated = function(self)
		local group = self.group
		local gs = group:GetSettings()
		local gspv = group:GetSettingsPerView()

		-- Scale
		gs.Scale = group:GetScale()


		local std_spacing = gspv.SpacingX*group:GetEffectiveScale()

		-- Height has already been set by SizeUpdate(). Get it with GetStandardizedSize().
		local _, std_newFrameHeight = self:GetStandardizedSize()
		local std_newHeight = (std_newFrameHeight + std_spacing)/gs.Rows - std_spacing
		local newHeight = std_newHeight/group:GetEffectiveScale()

		newHeight = max(gspv.SizeX, newHeight)
		gspv.SizeY = newHeight
		

		-- Update size settings for the group.
		-- This needs to be done before we :Setup() or otherwise bad things happen.
		local GroupModule_GroupPosition = group:GetModuleOrModuleChild("GroupModule_GroupPosition")
		GroupModule_GroupPosition:UpdatePositionAfterMovement()
			
		if self.LastUpdate <= TMW.time - self.UPD_INTV then
			-- Update the group completely very infrequently because of the high CPU usage.
			
			self.LastUpdate = TMW.time
		
			group:Setup()
		else
			-- Don't setup icons most of the time. Only setup the group.
			
			group:Setup(true)
		end

		self:HideTexture()
	end,
}
