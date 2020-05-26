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

local get = TMW.get


TMW:NewClass("Resizer_Generic"){
	tooltipTitle = L["RESIZE"],
	tooltipText = L["RESIZE_TOOLTIP"],

	MODE_STATIC = 0,
	MODE_SIZE = 1,
	MODE_SCALE = 2,

	-- Configuration. Set these on created instances.
	scale_min = 0.4,
	scale_max = math.huge,
	x_min = 1,
	x_max = math.huge,
	y_min = 1,
	y_max = math.huge,
	
	OnNewInstance_Resizer = function(self, parent)
		self.parent = parent
		
		self.mode_x = self.MODE_SIZE
		self.mode_y = self.MODE_SIZE

		self.resizeButton = CreateFrame("Button", nil, parent, "TellMeWhen_ResizeButton")
		
		-- Default module state is disabled, but default frame state is shown,
		-- so initially we need to hide the button so that the two states agree with eachother.
		self.resizeButton:Hide()
		
		self.resizeButton.module = self
		
		self.resizeButton:SetScript("OnMouseDown", self.StartSizing)
		self.resizeButton:SetScript("OnMouseUp", self.OnMouseUp)
		
		-- A new function is required for each resizeButton/parent combo because it has to be able to reference both.
		parent:HookScript("OnSizeChanged", function(parent)
			local scale = 1.6 / parent:GetEffectiveScale()
			scale = max(scale, 0.6)
			self.resizeButton:SetScale(scale)
		end)

		-- Initial value. Should be good enough.
		self.resizeButton:SetScale(2)

		self.resizeButton:HookScript("OnShow", function(self)
			self:SetFrameLevel(self:GetParent():GetFrameLevel() + 5)
		end)

		TMW:TT(self.resizeButton, self.tooltipTitle, self.tooltipText, 1, 1)
	end,

	-- These are here so this class can be inherited with a TMW.C.ObjectModule
	OnEnable = function(self)
		self:Show()
	end,
	OnDisable = function(self)
		self:Hide()
	end,

	Show = function(self)
		self.resizeButton:Show()
	end,
	Hide = function(self)
		self.resizeButton:Hide()
	end,
	
	ShowTexture = function(self)
		self.resizeButton.texture:Show()
	end,
	HideTexture = function(self)
		self.resizeButton.texture:Hide()
	end,

	OnMouseUp = function(resizeButton)
		local self = resizeButton.module

		self.StopSizing(resizeButton)
		self:ShowTexture()
	end,

	SetModes = function(self, x, y)
		self.mode_x = x
		self.mode_y = y
	end,

	
	GetStandardizedCoordinates = function(self)
		local parent = self.parent
		local scale = parent:GetEffectiveScale()
		
		return
			parent:GetLeft()*scale,
			parent:GetRight()*scale,
			parent:GetTop()*scale,
			parent:GetBottom()*scale
	end,
	GetStandardizedCursorCoordinates = function(self)
		-- This method is rather pointless (its just a wrapper),
		-- but having consistency is nice so that I don't have to remember if the coords returned
		-- are comparable to other Standardized coordinates/sizes
		return GetCursorPosition()
	end,
	GetStandardizedSize = function(self)
		local parent = self.parent
		local x, y = parent:GetSize()
		local scale = parent:GetEffectiveScale()
		
		return x*scale, y*scale
	end,
	
	StartSizing = function(resizeButton, button)
		local self = resizeButton.module
		if not self.resizeButton:IsVisible() then return end
		local parent = self.parent
		
		self.std_oldLeft, self.std_oldRight, self.std_oldTop, self.std_oldBottom = self:GetStandardizedCoordinates()
		self.std_oldWidth, self.std_oldHeight = self:GetStandardizedSize()
		
		self.oldScale = parent:GetScale()
		self.oldUIScale = UIParent:GetScale()
		self.oldEffectiveScale = parent:GetEffectiveScale()
		
		self.oldX, self.oldY = parent:GetLeft(), parent:GetTop()

		self.button = button
		
		if button == "RightButton" and self.SizeUpdate_RightButton then
			resizeButton:SetScript("OnUpdate", self.SizeUpdate_RightButton)
		else
			resizeButton:SetScript("OnUpdate", self.SizeUpdate)
		end

		self:HideTexture()
	end,

	StopSizing = function(resizeButton)
		resizeButton:SetScript("OnUpdate", nil)

		local self = resizeButton.module
		self:ShowTexture()
	end,

	SizeUpdate = function(resizeButton)
		--[[ Notes:
		--	arg1 (self) is resizeButton
			
		--	The 'std_' that prefixes a lot of variables means that it is comparable with all other 'std_' variables.
			More specifically, it means that it does not depend on the scale of either the group nor UIParent.
		]]
		local self = resizeButton.module
		
		local parent = self.parent
		
		local std_cursorX, std_cursorY = self:GetStandardizedCursorCoordinates()
		

		-- Calculate new scale:
		--[[
			Holy shit. Look at this wicked sick dimensional analysis:
			
			std_newHeight   oldScale
			------------- X	-------- = newScale
			std_oldHeight       1

			'std_Height' cancels out 'std_Height', and 'old' cancels out 'old', leaving us with 'new' and 'Scale'!
			I just wanted to make sure I explained why this shit works, because this code used to be confusing as hell
			(which is why I am rewriting it right now)
		]]
		local std_newWidth = std_cursorX - self.std_oldLeft
		local ratio_SizeChangeX = std_newWidth/self.std_oldWidth
		local newScaleX = ratio_SizeChangeX*self.oldScale
		
		local std_newHeight = self.std_oldTop - std_cursorY
		local ratio_SizeChangeY = std_newHeight/self.std_oldHeight
		local newScaleY = ratio_SizeChangeY*self.oldScale

		local newScale = self.oldScale


		-- Mode-dependent calculation
		if self.mode_x == self.MODE_SCALE and self.mode_y == self.MODE_SCALE then
			if IsControlKeyDown() then
				-- Uses the smaller of the two scales.
				newScale = min(newScaleX, newScaleY)
			else
				-- Uses the larger of the two scales.
				newScale = max(newScaleX, newScaleY)
			end

		elseif self.mode_y == self.MODE_SCALE then
			newScale = newScaleY
		elseif self.mode_x == self.MODE_SCALE then
			newScale = newScaleX
		end

		newScale = max(get(self.scale_min, self), newScale)
		newScale = min(get(self.scale_max, self), newScale)

		parent:SetScale(newScale)

		if self.mode_x == self.MODE_SIZE then
			-- Calculate new width
			local std_newFrameWidth = std_cursorX - self.std_oldLeft
			local newWidth = std_newFrameWidth/parent:GetEffectiveScale()
			newWidth = max(get(self.x_min, self), newWidth)
			newWidth = min(get(self.x_max, self), newWidth)

			parent:SetWidth(newWidth)
		end
		if self.mode_y == self.MODE_SIZE then
			-- Calculate new height
			local std_newFrameHeight = abs(std_cursorY - self.std_oldTop)
			local newHeight = std_newFrameHeight/parent:GetEffectiveScale()
			newHeight = max(get(self.y_min, self), newHeight)
			newHeight = min(get(self.y_max, self), newHeight)
			
			parent:SetHeight(newHeight)
		end

		-- We have all the data needed to find the new position of the parent.
		-- It must be recalculated because otherwise it will scale relative to where it is anchored to,
		-- instead of being relative to the parent's top left corner, which is what it is supposed to be.
		-- I don't remember why this calculation here works, so lets just leave it alone.
		-- Note that it will be re-re-calculated once we are done resizing.
		local newX = self.oldX * self.oldScale / newScale
		local newY = self.oldY * self.oldScale / newScale
		parent:ClearAllPoints()
		parent:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", newX, newY)

		self:SizeUpdated()

	end,

	-- Override this to set settings, do updates, etc.
	SizeUpdated = TMW.NULLFUNC,


}
