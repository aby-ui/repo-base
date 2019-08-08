local Portrait = {}
ShadowUF:RegisterModule(Portrait, "portrait", ShadowUF.L["Portrait"])

-- If the camera isn't reset OnShow, it'll show the entire character instead of just the head, odd I know
local function resetCamera(self)
	self:SetPortraitZoom(1)
end

local function resetGUID(self)
	self.guid = nil
end

function Portrait:OnEnable(frame)
	frame:RegisterUnitEvent("UNIT_PORTRAIT_UPDATE", self, "UpdateFunc")
	frame:RegisterUnitEvent("UNIT_MODEL_CHANGED", self, "Update")

	frame:RegisterUpdateFunc(self, "UpdateFunc")
end

function Portrait:OnDisable(frame)
	frame:UnregisterAll(self)
end

function Portrait:OnPreLayoutApply(frame, config)
	if( not frame.visibility.portrait ) then return end

	if( config.portrait.type == "3D" ) then
		if( not frame.portraitModel ) then
			frame.portraitModel = CreateFrame("PlayerModel", nil, frame)
			frame.portraitModel:SetScript("OnShow", resetCamera)
			frame.portraitModel:SetScript("OnHide", resetGUID)
			frame.portraitModel.parent = frame
		end

		frame.portrait = frame.portraitModel
		frame.portrait:Show()

		ShadowUF.Layout:ToggleVisibility(frame.portraitTexture, false)
	else
		frame.portraitTexture = frame.portraitTexture or frame:CreateTexture(nil, "ARTWORK")
		frame.portrait = frame.portraitTexture
		frame.portrait:Show()

		ShadowUF.Layout:ToggleVisibility(frame.portraitModel, false)
	end
end

function Portrait:UpdateFunc(frame)
	-- Portrait models can't be updated unless the GUID changed or else you have the animation jumping around
	if( ShadowUF.db.profile.units[frame.unitType].portrait.type == "3D" ) then
		local guid = UnitGUID(frame.unitOwner)
		if( frame.portrait.guid ~= guid ) then
			self:Update(frame)
		end

		frame.portrait.guid = guid
	else
		self:Update(frame)
	end
end

function Portrait:Update(frame, event)
	local type = ShadowUF.db.profile.units[frame.unitType].portrait.type
	-- Use class thingy
	if( type == "class" ) then
		local classToken = frame:UnitClassToken()
		if( classToken ) then
			frame.portrait:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
			frame.portrait:SetTexCoord(CLASS_ICON_TCOORDS[classToken][1], CLASS_ICON_TCOORDS[classToken][2], CLASS_ICON_TCOORDS[classToken][3], CLASS_ICON_TCOORDS[classToken][4])
		else
			frame.portrait:SetTexture("")
		end
	-- Use 2D character image
	elseif( type == "2D" ) then
		frame.portrait:SetTexCoord(0.10, 0.90, 0.10, 0.90)
		SetPortraitTexture(frame.portrait, frame.unitOwner)
	-- Using 3D portrait, but the players not in range so swap to question mark
	elseif( not UnitIsVisible(frame.unitOwner) or not UnitIsConnected(frame.unitOwner) ) then
		frame.portrait:ClearModel()
		frame.portrait:SetModelScale(5.5)
		frame.portrait:SetPosition(0, 0, -0.8)
		frame.portrait:SetModel("Interface\\Buttons\\talktomequestionmark.m2")

	-- Use animated 3D portrait
	else
		frame.portrait:ClearModel()
		frame.portrait:SetUnit(frame.unitOwner)
		frame.portrait:SetPortraitZoom(1)
		frame.portrait:SetPosition(0, 0, 0)
		frame.portrait:Show()
	end
end




