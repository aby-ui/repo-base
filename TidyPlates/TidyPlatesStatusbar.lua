
-- obj:SetTexCoord(crop.left, crop.right, crop.top, crop.bottom)


local max, min = math.max, math.min


local function UpdateBar(self)

	local range = self.MaxVal - self.MinVal 
	local value = self.Value - self.MinVal
	local tailValue = self.tailValue

	--tailValue = value / 3		-- test

	local barsize = self.Dim or 1

	local barFraction, tailFraction = 1, 0
	
	if range > 0 then
		barFraction = min(range, value) / range
		tailFraction = min(range - value, tailValue) / range
	else 
		barFraction = 0
		tailFraction = 0
	end
	

	if barFraction > 0 then self.Bar:Show() else self.Bar:Hide() end
	if tailFraction > 0 then self.Tail:Show() else self.Tail:Hide() end


	if self.Orientation == "VERTICAL" then 

		-- Funky Vertical Bar
		local texHeight = (self.Bottom - self.Top)
		self.Bar:SetHeight(barsize * barFraction)
		local barCrop = self.Bottom - ( texHeight * barFraction)		-- bottom = 1, top = 0
		self.Bar:SetTexCoord(self.Left, self.Right, barCrop, self.Bottom)


	else 

		-- Standard Horizonal Bar
		local texWidth = (self.Right - self.Left)
		local barCrop = (texWidth * barFraction) + self.Left
		self.Bar:SetWidth(barsize * barFraction) 
		self.Bar:SetTexCoord(self.Left, barCrop, self.Top, self.Bottom)

		-- Tail
		if tailFraction > 0 then
			local tailCrop = (texWidth * (barFraction+tailFraction)) + barCrop
			self.Tail:SetWidth(barsize * tailFraction)	-- tailFraction
			self.Tail:SetTexCoord(barCrop, self.Right, self.Top, self.Bottom)
		end
		 

	end


end



local function UpdateSize(self)
	if self.Orientation == "VERTICAL" then self.Dim = self:GetHeight()
	else self.Dim = self:GetWidth() end
	UpdateBar(self)
end


local function SetValue(self, value, tail) 
	if value and (value >= self.MinVal) and (value <= self.MaxVal) then 
		self.Value = value 
		if tail then
			self.tailValue = tail
		end
	end

	UpdateBar(self) 
end

	
local function SetStatusBarTexture(self, texture) 
	self.Bar:SetTexture(texture) 
	self.Tail:SetTexture(texture) 
end

local function SetTailColor(self, r, g, b, a) 
	self.Tail:SetVertexColor(r , g , b , a) 
end

local function SetStatusBarColor(self, r, g, b, a) 
	self.Bar:SetVertexColor(r,g,b,a) 
	SetTailColor(self, r + .2 , g + .2, b + .2,a) 
end


local function SetStatusBarGradient(self, r1, g1, b1, a1, r2, g2, b2, a2) self.Bar:SetGradientAlpha(self.Orientation, r1, g1, b1, a1, r2, g2, b2, a2) end

--[[
local function SetStatusBarGradientAuto(self, r, g, b, a) 
	self.Bar:SetGradientAlpha(self.Orientation, .5+(r*1.1), g*.7, b*.7, a, r*.7, g*.7, .5+(b*1.1), a) 
end

local function SetStatusBarSmartGradient(self, r1, g1, b1, r2, g2, b2) 
	self.Bar:SetGradientAlpha(self.Orientation, r1, g1, b1, 1, r2 or r1, g2 or g1, b2 or b1, 1) 
end
--]]

local function SetAllColors(self, rBar, gBar, bBar, aBar, rBackdrop, gBackdrop, bBackdrop, aBackdrop) 
	SetStatusBarColor(self, rBar or 1, gBar or 1, bBar or 1, aBar or 1)

	self.Backdrop:SetVertexColor(rBackdrop or 1, gBackdrop or 1, bBackdrop or 1, aBackdrop or 1)
end

local function SetOrientation(self, orientation) 
	if orientation == "VERTICAL" then
		self.Orientation = orientation
		self.Bar:ClearAllPoints()
		self.Bar:SetPoint("BOTTOMLEFT")
		self.Bar:SetPoint("BOTTOMRIGHT")

		-- Haven't gotten to the Tail yet

		-- TO DO
	else
		self.Orientation = "HORIZONTAL"
		self.Bar:ClearAllPoints()
		self.Bar:SetPoint("TOPLEFT")
		self.Bar:SetPoint("BOTTOMLEFT")

		self.Tail:ClearAllPoints()
		self.Tail:SetPoint("TOPLEFT", self.Bar, "TOPRIGHT")
		self.Tail:SetPoint("BOTTOMLEFT", self.Bar, "BOTTOMRIGHT")
	end
	UpdateSize(self)
end

local function GetMinMaxValues(self)
	return self.MinVal, self.MaxVal
end


local function SetMinMaxValues(self, minval, maxval)
	if not (minval or maxval) then return end
	
	if maxval > minval then
		self.MinVal = minval
		self.MaxVal = maxval
	else 
		self.MinVal = 0
		self.MaxVal = 1
	end
	
	if self.Value > self.MaxVal then self.Value = self.MaxVal
	elseif self.Value < self.MinVal then self.Value = self.MinVal end
	
	UpdateBar(self) 
end

local function SetTexCoord(self, left,right,top,bottom)		-- 0. 1. 0. 1
	self.Left, self.Right, self.Top, self.Bottom = left or 0, right or 1, top or 0, bottom or 1
	UpdateBar(self) 
end

local function SetBackdropTexCoord(self, left,right,top,bottom)		-- 0. 1. 0. 1
	self.Backdrop:SetTexCoord(left or 0, right or 1,top or 0, bottom or 1)
end

local function SetBackdropTexture(self, texture)		-- 0. 1. 0. 1
	self.Backdrop:SetTexture(texture)
end


function CreateTidyPlatesStatusbar(parent, name)
	local frame = CreateFrame("Frame", name, parent)
	--frame.Dim = 1
	frame:SetHeight(1)
	frame:SetWidth(1)
	frame.Value, frame.tailValue = 1, 0
	frame.MinVal, frame.MaxVal, frame.Orientation = 0, 1, "HORIZONTAL"
	frame.Left, frame.Right, frame.Top, frame.Bottom = 0, 1, 0, 1

	frame.Bar = frame:CreateTexture(nil, "BORDER")
	frame.Tail = frame:CreateTexture(nil, "BORDER")		-- Added for Absorbs

	frame.Backdrop = frame:CreateTexture(nil, "BACKGROUND")
	frame.Backdrop:SetAllPoints(frame)
        
        --AddBorders(frame)
	
	frame.SetValue = SetValue
	frame.SetMinMaxValues = SetMinMaxValues
	frame.GetMinMaxValues = GetMinMaxValues
	frame.SetOrientation = SetOrientation
	frame.SetStatusBarColor = SetStatusBarColor
	frame.SetStatusBarGradient = SetStatusBarGradient
	--frame.SetStatusBarGradientAuto = SetStatusBarGradientAuto
	--frame.SetStatusBarSmartGradient = SetStatusBarSmartGradient
	frame.SetAllColors = SetAllColors
	frame.SetStatusBarTexture = SetStatusBarTexture
	frame.SetTexCoord = SetTexCoord
	frame.SetBackdropTexCoord = SetBackdropTexCoord
	frame.SetBackdropTexture = SetBackdropTexture
	
	frame:SetScript("OnSizeChanged", UpdateSize)
	UpdateSize(frame)
	return frame
end
