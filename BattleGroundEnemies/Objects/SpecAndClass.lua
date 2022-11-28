local AddonName, Data = ...
local BattleGroundEnemies = BattleGroundEnemies
local L = Data.L
local CreateFrame = CreateFrame
local GameTooltip = GameTooltip


local specDefaults = {
	Enabled = true,
	Parent = "Button",
	ActivePoints = 2,
	Points = {
		{
			Point = "TOPLEFT",
			RelativeFrame = "Class",
			RelativePoint = "TOPLEFT",
		},
		{
			Point = "BOTTOMRIGHT",
			RelativeFrame = "Class",
			RelativePoint = "BOTTOMRIGHT",
		}
	}
}

local classDefaults = {
	Enabled = true,
	Width = 36,
	Parent = "Button",
	ActivePoints = 2,
	Points = {
		{
			Point = "TOPLEFT",
			RelativeFrame = "Button",
			RelativePoint = "TOPLEFT",
		},
		{
			Point = "BOTTOMLEFT",
			RelativeFrame = "Button",
			RelativePoint = "BOTTOMLEFT",
		}
	}
}

local events = {"PlayerDetailsChanged"}

local class = BattleGroundEnemies:NewButtonModule({
	moduleName = "Class",
	localizedModuleName = CLASS,
	defaultSettings = classDefaults,
	options = nil,
	events = events,
	expansions = "All"
})
local spec = BattleGroundEnemies:NewButtonModule({
	moduleName = "Spec",
	localizedModuleName = SPECIALIZATION,
	defaultSettings = specDefaults,
	options = nil,
	events = events,
	expansions = {WOW_PROJECT_MAINLINE}
})




local function attachToPlayerButton(playerButton, type)
	local frame = CreateFrame("Frame", nil, playerButton)
	frame.type = type
	if type == "Spec" then
		if playerButton.Class and playerButton.Class.GetFrameLevel then
			frame:SetFrameLevel(playerButton.Class:GetFrameLevel() + 1) -- to always make sure the level is above the spec in case they are stacked ontop of each other
		end
	end

	frame:SetScript("OnSizeChanged", function(self, width, height)
		self:CropImage()
	end)

	function frame:CropImage()
		if playerButton.PlayerSpecName and self.type == "Spec" then
			local width = self:GetWidth()
			local height = self:GetHeight()
			if width and height and width > 0 and height > 0 then
				BattleGroundEnemies.CropImage(self.Icon, width, height)
			end
		end
	end

	frame:HookScript("OnEnter", function(self)
		BattleGroundEnemies:ShowTooltip(self, function()
			if self.type == "Class" then
				if not playerButton.PlayerClass then return end
				local numClasses = GetNumClasses()
				for i = 1, numClasses do -- we could also just save the localized class name it into the button itself, but since its only used for this tooltip no need for that
					local className, classFile, classID = GetClassInfo(i)
					if classFile and classFile == playerButton.PlayerClass then
						return GameTooltip:SetText(className)
					end
				end
			else --"Spec"
				if not playerButton.PlayerSpecName then return end
				GameTooltip:SetText(playerButton.PlayerSpecName)
			end
		end)
	end)

	frame:HookScript("OnLeave", function(self)
		if GameTooltip:IsOwned(self) then
			GameTooltip:Hide()
		end
	end)

	frame.Background = frame:CreateTexture(nil, 'BACKGROUND')
	frame.Background:SetAllPoints()
	frame.Background:SetColorTexture(0,0,0,0.8)

	frame.Icon = frame:CreateTexture(nil, 'OVERLAY')
	frame.Icon:SetAllPoints()

	frame.PlayerDetailsChanged = function(self)
		if self.type == "Class" then
			--either no spec or the player wants to always see it > display it
			local coords = CLASS_ICON_TCOORDS[playerButton.PlayerClass]
			if playerButton.PlayerClass and coords then
				self.Icon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
				self.Icon:SetTexCoord(unpack(coords))
			else
				self.Icon:SetTexture(nil)
			end	
		else -- "Spec"
			local specData = playerButton:GetSpecData()
			if specData then
				self.Icon:SetTexture(specData.specIcon)
			else
				self.Icon:SetTexture(nil)
			end
		end

		self:CropImage()
	end


	frame.ApplyAllSettings = function(self)
		self:Show()
		self:PlayerDetailsChanged()
	end
	return frame
end

function class:AttachToPlayerButton(playerButton)
	playerButton.Class = attachToPlayerButton(playerButton, "Class")
end

function spec:AttachToPlayerButton(playerButton)
	playerButton.Spec = attachToPlayerButton(playerButton, "Spec")
end