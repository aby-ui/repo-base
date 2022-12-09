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
	enabledInThisExpansion = true
})
local spec = BattleGroundEnemies:NewButtonModule({
	moduleName = "Spec",
	localizedModuleName = SPECIALIZATION,
	defaultSettings = specDefaults,
	options = nil,
	events = events,
	enabledInThisExpansion = not not GetSpecializationInfoByID
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
		local playerDetails = playerButton.PlayerDetails
		if not playerDetails then return end
		if playerDetails.PlayerSpecName and self.type == "Spec" then
			local width = self:GetWidth()
			local height = self:GetHeight()
			if width and height and width > 0 and height > 0 then
				BattleGroundEnemies.CropImage(self.Icon, width, height)
			end
		end
	end

	frame:HookScript("OnEnter", function(self)
		BattleGroundEnemies:ShowTooltip(self, function()
			local playerDetails = playerButton.PlayerDetails
			if self.type == "Class" then
				if not playerDetails.PlayerClass then return end
				local numClasses = GetNumClasses()
				for i = 1, numClasses do -- we could also just save the localized class name it into the button itself, but since its only used for this tooltip no need for that
					local className, classFile, classID = GetClassInfo(i)
					if classFile and classFile == playerDetails.PlayerClass then
						return GameTooltip:SetText(className)
					end
				end
			else --"Spec"
				if not playerDetails.PlayerSpecName then return end
				GameTooltip:SetText(playerDetails.PlayerSpecName)
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

	frame.PlayerDetailsChanged = function(self, playerDetails)
		if not playerDetails then return end
		if self.type == "Class" then
			--either no spec or the player wants to always see it > display it
			local coords = CLASS_ICON_TCOORDS[playerDetails.PlayerClass]
			if playerDetails.PlayerClass and coords then
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
		self:PlayerDetailsChanged(playerButton.PlayerDetails)
	end
	return frame
end

function class:AttachToPlayerButton(playerButton)
	playerButton.Class = attachToPlayerButton(playerButton, "Class")
end

function spec:AttachToPlayerButton(playerButton)
	playerButton.Spec = attachToPlayerButton(playerButton, "Spec")
end