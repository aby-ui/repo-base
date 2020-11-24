local addonName, ns = ...
local addon = CreateFrame("Frame")

-- addon:CreateModule(name:string, module:Module):Module
-- addon:GetModule(name:string):Module
-- addon:ADDON_LOADED(event:string, name:string)
do

	---@class Module
	local module = {
		Loaded = nil,
		Name = nil,
		CanLoad = nil,
		Widgets = nil,
		Handlers = nil,
		Events = nil,
	}

	---@type Module[]
	local modules = {}

	---@param module Module
	local function Init(module)
		module.Loaded = true
		for _, widget in pairs(module.Widgets) do
			local frame = CreateFrame(widget.type, nil, _G[widget.parent] or widget.parent, widget.template)
			frame.Module = module
			frame.Widget = widget
			for handler, script in pairs(module.Handlers) do
				if handler == "OnLoad" then
					script(frame)
				end
				frame:SetScript(handler, script)
			end
			if module.Events then
				for _, event in pairs(module.Events) do
					frame:RegisterEvent(event)
				end
			end
			widget.Frame = frame
		end
	end

	---@param module Module
	---@return boolean true if the module was loaded, otherwise false if it couldn't load.
	local function Load(module)
		if module.Loaded then
			return true
		end
		if type(module.CanLoad) == "function" then
			if not module:CanLoad() then
				return false
			end
		end
		Init(module)
		return true
	end

	---@param name string
	---@param module Module
	function addon:CreateModule(name, module)
		modules[#modules + 1] = module
		module.Loaded = false
		module.Name = name
		Load(module)
		return module
	end

	---@param name string
	---@return Module
	function addon:GetModule(name)
		for _, module in ipairs(modules) do
			if module.Name == name then
				return module
			end
		end
	end

	---@param event string Event name.
	---@param name string The name of the addon loaded.
	function addon:ADDON_LOADED(event, name)
		for _, module in ipairs(modules) do
			Load(module)
		end
	end

end

-- addon:ResetActors():boolean
-- addon:ResetActiveActor():boolean
-- addon:TryOn(item:string):boolean
-- addon:DressUpSources(appearanceSources:table, mainHandEnchant:number, offHandEnchant:number):boolean
-- addon:UndressActors():boolean
-- addon:UndressActorsSlot(index:number):boolean
-- addon:Undress():boolean
-- addon:UndressSlot(index:number):boolean
-- addon:CanSetUnit(unit:string):boolean
-- addon:SetUnit(unit:string):boolean
-- addon:SetSkinForUnit(unit:string):boolean
-- addon:GetCurrentSkin():race:string, class:string
-- addon:SetSkin(race:string, class:string):boolean
-- addon:ApplyCustomStateToActiveActor(customState:table, doClear:boolean):boolean
do

	local activeActor = {}
	local activeActorSkin = {}

	local function GetActiveFrame()
		local modelScene
		local model
		local frame
		if SideDressUpFrame and SideDressUpFrame:IsShown() then
			frame = SideDressUpFrame
			modelScene = SideDressUpFrame.ModelScene
		elseif DressUpFrame and DressUpFrame:IsShown() then
			frame = DressUpFrame
			modelScene = DressUpFrame.ModelScene
		end
		return modelScene, model, frame
	end

	local function GetActor(modelScene, unit)
		local _, race
		local sex, sex2
		if unit then
			_, race = UnitRace(unit)
			if race then
				race = race:lower()
				if race == "scourge" then
					race = "undead"
				elseif race == "tauren" then
					race = ""
				end
			end
			sex = UnitSex(unit)
			if sex == 2 then
				sex = "male"
				sex2 = "female"
			elseif sex == 3 then
				sex = "female"
				sex2 = "male"
			else
				sex = nil
			end
		end
		local tag, actor
		if race then
			if not actor and sex then
				tag = race .. "-" .. sex
				actor = modelScene:GetActorByTag(tag)
			end
			if not actor and sex2 then
				tag = race .. "-" .. sex2
				actor = modelScene:GetActorByTag(tag)
			end
			if not actor then
				tag = race
				actor = modelScene:GetActorByTag(race)
			end
		end
		if not actor then
			tag = "player"
			actor = modelScene:GetActorByTag(tag)
		end
		return actor, tag
	end

	local function HideExtras(modelScene, mainActor)
		for tag, actor in pairs(modelScene.tagToActor) do
			if actor ~= mainActor then
				actor:ClearModel()
				actor:Hide()
			end
		end
	end

	local function GetActorHideExtras(modelScene, unit)
		if not unit then
			return activeActor[modelScene]
		end
		local actor, tag = GetActor(modelScene, unit)
		if not actor then
			actor, tag = GetActor(modelScene)
		end
		activeActor[modelScene] = actor
		HideExtras(modelScene, actor)
		if actor then
			actor:Show()
		end
		return actor
	end

	local function ResetActors(modelScene)
		for tag, actor in pairs(modelScene.tagToActor) do
			if actor:IsShown() then
				actor:SetSheathed(false)
				actor:Dress()
			end
		end
		return true
	end

	function addon:ResetActors()
		local modelScene, model = GetActiveFrame()
		if modelScene then
			if ResetActors(modelScene) ~= false then
				addon:ClearCustomState()
			end
			return true
		end
		return false
	end

	local function ResetActiveActor(modelScene)
		local currentActor = activeActor[modelScene]
		if not currentActor then
			return false
		end
		local playerActor = modelScene:GetPlayerActor()
		local playerIsActive = playerActor == currentActor
		for tag, actor in pairs(modelScene.tagToActor) do
			if actor ~= currentActor and (not playerIsActive or actor ~= playerActor) then
				actor:ClearModel()
				actor:Hide()
			end
		end
		local activeSkin = activeActorSkin[modelScene]
		if activeSkin then
			addon:SetSkin(activeSkin.race, activeSkin.class, true)
		end
		return true
	end

	function addon:ResetActiveActor()
		local modelScene, model = GetActiveFrame()
		if modelScene then
			if ResetActiveActor(modelScene) ~= false then
				addon:ClearCustomState()
			end
			return true
		end
		return false
	end

	local function TryOnModelScene(modelScene, link)
		local success = 0
		for tag, actor in pairs(modelScene.tagToActor) do
			if actor:IsShown() then
				success = success + (actor:TryOn(link) == Enum.ItemTryOnReason.Success and 1 or 0)
			end
		end
		return success > 0
	end

	local function TryOnModel(model, link)
		return model:TryOn(link)
	end

	function addon:TryOn(link)
		local modelScene, model = GetActiveFrame()
		if modelScene then
			return TryOnModelScene(modelScene, link)
		elseif model then
			return TryOnModel(model, link)
		end
		return false
	end

	local function DressUpSourcesModelScene(modelScene, appearanceSources, mainHandEnchant, offHandEnchant)
		local actor = GetActorHideExtras(modelScene)
		if not actor then
			return false
		end
		local mainHandSlotID = GetInventorySlotInfo("MAINHANDSLOT")
		local secondaryHandSlotID = GetInventorySlotInfo("SECONDARYHANDSLOT")
		for i = 1, #appearanceSources do
			if i ~= mainHandSlotID and i ~= secondaryHandSlotID then
				if appearanceSources[i] and appearanceSources[i] ~= NO_TRANSMOG_SOURCE_ID then
					actor:TryOn(appearanceSources[i])
				end
			end
		end
		actor:TryOn(appearanceSources[mainHandSlotID], "MAINHANDSLOT", mainHandEnchant)
		actor:TryOn(appearanceSources[secondaryHandSlotID], "SECONDARYHANDSLOT", offHandEnchant)
	end

	function addon:DressUpSources(appearanceSources, ...)
		if not appearanceSources then
			return false
		end
		local modelScene, model = GetActiveFrame()
		if modelScene then
			return DressUpSourcesModelScene(modelScene, appearanceSources, ...)
		elseif model then
			return DressUpSources(appearanceSources, ...)
		end
		return false
	end

	local function UndressActorsModelScene(modelScene)
		for tag, actor in pairs(modelScene.tagToActor) do
			if actor:IsShown() then
				actor:Undress()
			end
		end
	end

	function addon:UndressActors()
		local modelScene, model = GetActiveFrame()
		if modelScene then
			return UndressActorsModelScene(modelScene)
		end
		return false
	end

	local function UndressActorsSlotModelScene(modelScene, index)
		for tag, actor in pairs(modelScene.tagToActor) do
			if actor:IsShown() then
				actor:UndressSlot(index)
			end
		end
	end

	function addon:UndressActorsSlot(index)
		local modelScene, model = GetActiveFrame()
		if modelScene then
			return UndressActorsSlotModelScene(modelScene, index)
		end
		return false
	end

	local function UndressModelScene(modelScene)
		local actor = GetActorHideExtras(modelScene)
		if not actor then
			return false
		end
		return actor:Undress()
	end

	local function UndressModel(model)
		return model:Undress()
	end

	function addon:Undress()
		local modelScene, model = GetActiveFrame()
		if modelScene then
			return UndressModelScene(modelScene)
		elseif model then
			return UndressModel(model)
		end
		return false
	end

	local function UndressSlotModelScene(modelScene, index)
		local actor = GetActorHideExtras(modelScene)
		if not actor then
			return false
		end
		return actor:UndressSlot(index)
	end

	local function UndressSlotModel(model, index)
		return model:UndressSlot(index)
	end

	function addon:UndressSlot(index)
		local modelScene, model = GetActiveFrame()
		if modelScene then
			return UndressSlotModelScene(modelScene, index)
		elseif model then
			return UndressSlotModel(model, index)
		end
		return false
	end

	local function CanSetUnitModelScene(unit)
		if not unit or not UnitExists(unit) then
			return false
		end
		if UnitIsPlayer(unit) then
			return true
		end
		local guid = UnitGUID(unit)
		if not guid then
			return false
		end
		local type, _, _, _, _, id = strsplit("-", guid)
		if type == "Creature" or type == "Pet" or type == "GameObject" or type == "Vehicle" or type == "Vignette" then
			local displayID = ns and ns.CreatureToDisplayID and ns.CreatureToDisplayID[id]
			return displayID ~= nil, displayID
		end
	end

	local function CanSetUnitModel(unit)
		return unit and UnitExists(unit)
	end

	function addon:CanSetUnit(unit)
		local modelScene, model = GetActiveFrame()
		if modelScene then
			return CanSetUnitModelScene(unit)
		elseif model then
			return CanSetUnitModel(unit)
		end
		return false
	end

	local function UpdateCameraForNewActor(modelScene, actor)
		modelScene:TransitionToModelSceneID(290, CAMERA_TRANSITION_TYPE_IMMEDIATE, CAMERA_MODIFICATION_TYPE_DISCARD, true)
	end

	local function SetUnitModelScene(modelScene, unit)
		local actor = GetActorHideExtras(modelScene, unit)
		if not actor then
			return false
		end
		local canSetUnit, displayID = CanSetUnitModelScene(unit)
		if not canSetUnit then
			return false
		end
		if not displayID then
			local success = actor:SetModelByUnit(unit)
			UpdateCameraForNewActor(modelScene, actor)
			return success
		end
		if type(displayID) == "table" then
			displayID = displayID[random(1, #displayID)]
		end
		if displayID then
			local success = actor:SetModelByCreatureDisplayID(displayID)
			UpdateCameraForNewActor(modelScene, actor)
			return success
		end
	end

	local function SetUnitModel(model, unit)
		return model:SetUnit(unit)
	end

	function addon:SetUnit(unit)
		local modelScene, model = GetActiveFrame()
		if modelScene then
			if SetUnitModelScene(modelScene, unit) ~= false then
				addon:ClearCustomState()
				return true
			end
		elseif model then
			addon:ClearCustomState()
			return SetUnitModel(model, unit)
		end
		return false
	end

	local function GetCurrentSkin(frame)
		local race, class
		if frame.BGTopLeft then
			local texture = frame.BGTopLeft:GetTexture()
			if type(texture) == "string" then
				race = texture:lower():match("dressupbackground%-(.+)%d$")
			end
		end
		if frame.ModelBackground then
			local atlas = frame.ModelBackground:GetAtlas()
			if type(atlas) == "string" then
				class = atlas:lower():match("dressingroom%-background%-(.+)$")
			end
		end
		return race, class
	end

	function addon:GetCurrentSkin()
		local modelScene, model, frame = GetActiveFrame()
		if frame then
			return GetCurrentSkin(frame)
		end
		return false
	end

	local function CacheSkin(modelScene, frame, race, class)
		local activeSkin = activeActorSkin[modelScene]
		if not activeSkin then
			activeSkin = {}
			activeActorSkin[modelScene] = activeSkin
		end
		if frame then
			activeSkin.race, activeSkin.class = GetCurrentSkin(frame)
		else
			activeSkin.race, activeSkin.class = race, class
		end
		return activeSkin
	end

	local function UpdateUnitSkin(frame, unit, modelScene)
		local _, class = UnitClass(unit)
		SetDressUpBackground(frame:GetParent(), nil, class)
		if UnitIsPlayer(unit) then
			CacheSkin(modelScene, frame:GetParent())
		end
		return true
	end

	function addon:SetSkinForUnit(unit)
		local modelScene, model, frame = GetActiveFrame()
		if frame then
			return UpdateUnitSkin(modelScene or model, unit, modelScene)
		end
		return false
	end

	function addon:SetSkin(race, class, doNotSetActiveSkin)
		local modelScene, model, frame = GetActiveFrame()
		if frame then
			if modelScene and not doNotSetActiveSkin then
				local activeSkin = activeActorSkin[modelScene]
				if not activeSkin then
					activeSkin = {}
					activeActorSkin[modelScene] = activeSkin
				end
				activeSkin.race = race
				activeSkin.class = class
			end
			SetDressUpBackground(frame, race, class)
			CacheSkin(modelScene, nil, race, class)
			return true
		end
		return false
	end

	local function GetGenderRaceIDs(gender, race)
		local genderId = gender and gender.id or UnitSex("player")
		local raceId = race and race.id or select(2, UnitRace("player"))
		return genderId, raceId, gender, race
	end

	local function ApplyGenderRaceToActiveActor(modelScene, genderInfo, raceInfo)
		local success = 0
		for tag, actor in pairs(modelScene.tagToActor) do
			if actor:IsShown() then
				-- actor:SetCustomRace(raceInfo.race, genderInfo.gender)
				success = success + 1
			end
		end
		return success > 0
	end

	local function ApplyGenderRaceToModel(model, genderInfo, raceInfo)
		return model:SetCustomRace(raceInfo.race, genderInfo.gender)
	end

	function addon:ApplyCustomStateToActiveActor(customState, doClear)
		local gender = customState.gender
		local race = customState.race
		if not gender and not race and not doClear then
			return false
		end
		local _, _, genderInfo, raceInfo = GetGenderRaceIDs(gender, race)
		if not genderInfo or not raceInfo then
			return false
		end
		local modelScene, model = GetActiveFrame()
		if modelScene then
			return ApplyGenderRaceToActiveActor(modelScene, genderInfo, raceInfo)
		elseif model then
			return ApplyGenderRaceToModel(model, genderInfo, raceInfo)
		end
		return false
	end

end

-- addon:ClearCustomState():boolean
-- addon:SetCustomGender(gender:table):boolean
-- addon:SetCustomRace(race:table):boolean
do

	local customState = {}

	function addon:ClearCustomState()
		customState.gender = nil
		customState.race = nil
		return addon:ApplyCustomStateToActiveActor(customState, true)
	end

	function addon:SetCustomGender(gender)
		customState.gender = gender
		return addon:ApplyCustomStateToActiveActor(customState)
	end

	function addon:SetCustomRace(race)
		customState.race = race
		return addon:ApplyCustomStateToActiveActor(customState)
	end

end

-- addon.UI.Resize.Update(frame:table)
-- addon.UI.Undress.Setup(frame:table)
-- addon.UI.Undress.Click(frame:table)
-- addon.UI.Reset.Setup(frame:table)
-- addon.UI.Reset.Click(frame:table)
do

	local UI = {}
	addon.UI = UI

	UI.Resize = {
		Update = function(parent, frame)
			if GetCVar(parent.MaxMinButtonFrame.cvar) == "0" then
				frame:SetWidth(frame.Size or 60)
				frame:SetText(frame.Text or frame.TextShort)
			else
				frame:SetWidth(frame.SizeShort or 60/1.5)
				frame:SetText(frame.TextShort or frame.Text)
			end
		end,
	}

	UI.Undress = {
		Setup = function(frame)
			frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		end,
		Click = function(frame, button)
			if button == "RightButton" then
				addon:UndressActorsSlot(INVSLOT_HEAD)
				addon:UndressActorsSlot(INVSLOT_BACK)
				addon:UndressActorsSlot(INVSLOT_TABARD)
			else
				addon:UndressActors()
				addon:Undress()
			end
		end,
	}

	UI.Reset = {
		Setup = function(frame)
			frame:HookScript("OnClick", function(...) UI.Reset.Click(...) end)
		end,
		Click = function(frame, button)
			addon:ResetActiveActor()
			addon:ResetActors()
		end,
	}

end

if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then

	local SDUF_UNDRESS = addon:CreateModule("SideDressUpFrame Undress", {
		CanLoad = function()
			return type(SideDressUpFrame) == "table"
		end,
		Handlers = {
			OnLoad = function(self)
				self:SetText(ns.L.UNDRESS)
				self:SetSize(SideDressUpFrame.ResetButton:GetSize())
				self:SetPoint("BOTTOM", SideDressUpFrame.ResetButton, "TOP", 0, 0)
				SideDressUpFrame.ModelScene:SetPoint("BOTTOMRIGHT", -11, 40 + self:GetHeight() - 4)
				addon.UI.Undress.Setup(self)
				addon.UI.Reset.Setup(SideDressUpFrame.ResetButton)
			end,
			OnClick = function(self, button)
				addon.UI.Undress.Click(self, button)
			end,
		},
		Widgets = {
			{ type = "Button", parent = "SideDressUpFrame", template = "UIPanelButtonTemplate" },
		},
	})

	local DUF_UNDRESS = addon:CreateModule("DressUpFrame Undress", {
		CanLoad = function()
			return type(DressUpFrame) == "table"
		end,
		Handlers = {
			OnLoad = function(self)
				self.Text = ns.L.UNDRESS
				self.TextShort = ns.L.UNDRESS_SHORT
				self:SetPoint("RIGHT", DressUpFrame.ResetButton, "LEFT", 0, 0)
				hooksecurefunc(DressUpFrame, "SetSize", function() C_Timer.After(0.01, function() addon.UI.Resize.Update(DressUpFrame, self) end) end)
				addon.UI.Undress.Setup(self)
				addon.UI.Reset.Setup(DressUpFrame.ResetButton)
			end,
			OnShow = function(self)
				addon.UI.Resize.Update(DressUpFrame, self)
			end,
			OnClick = function(self, button)
				addon.UI.Undress.Click(self, button)
			end,
		},
		Widgets = {
			{ type = "Button", parent = "DressUpFrameResetButton", template = "UIPanelButtonTemplate" },
		},
	})

	local DUF_INSPECT = addon:CreateModule("DressUpFrame Inspect", {
		CanLoad = function()
			return type(DressUpFrame) == "table"
		end,
		Events = {
			"PLAYER_TARGET_CHANGED",
			"INSPECT_READY",
		},
		Handlers = {
			OnLoad = function(self)
				self.Text = ns.L.INSPECT
				self.TextShort = ns.L.INSPECT_SHORT
				self:RegisterForClicks("LeftButtonUp", "RightButtonUp")
				self:SetPoint("RIGHT", DUF_UNDRESS.Widgets[1].Frame, "LEFT", 0, 0)
				hooksecurefunc(DressUpFrame, "SetSize", function() C_Timer.After(0.01, function() addon.UI.Resize.Update(DressUpFrame, self) end) end)
			end,
			OnShow = function(self)
				addon.UI.Resize.Update(DressUpFrame, self)
				self.Module.UpdateButtonState(self)
			end,
			OnClick = function(self, button)
				ClearInspectPlayer()
				NotifyInspect("target")
				self.UnitGUID = UnitGUID("target")
				self.ShowRealItems = button == "RightButton"
			end,
			OnEvent = function(self, event, ...)
				if event == "PLAYER_TARGET_CHANGED" then
					self.Module.UpdateButtonState(self)
				elseif event == "INSPECT_READY" then
					if self.UnitGUID == ... then
						self.Module.UpdateEquipment(self)
					end
				end
			end,
		},
		Widgets = {
			{ type = "Button", parent = "DressUpFrameResetButton", template = "UIPanelButtonTemplate" },
		},
		UpdateButtonState = function(self)
			self:SetEnabled(CanInspect("target"))
		end,
		UpdateEquipment = function(self)
			local race, class = addon:GetCurrentSkin()
			if self.ShowRealItems then
				for i = 1, 19 do
					if GetInventoryItemTexture("target", i) then
						local link = GetInventoryItemLink("target", i)
						addon:TryOn(link)
					end
				end
			else
				addon:DressUpSources(C_TransmogCollection.GetInspectSources())
			end
			addon:SetSkin(race, class)
		end,
	})

	local DUF_TARGET = addon:CreateModule("DressUpFrame Target", {
		CanLoad = function()
			return type(DressUpFrame) == "table"
		end,
		Events = {
			"PLAYER_TARGET_CHANGED",
		},
		Handlers = {
			OnLoad = function(self)
				self.Text = ns.L.TARGET
				self.TextShort = ns.L.TARGET_SHORT
				self:RegisterForClicks("LeftButtonUp", "RightButtonUp")
				self:SetPoint("RIGHT", DUF_INSPECT.Widgets[1].Frame, "LEFT", 0, 0)
				hooksecurefunc(DressUpFrame, "SetSize", function() C_Timer.After(0.01, function() addon.UI.Resize.Update(DressUpFrame, self) end) end)
			end,
			OnShow = function(self)
				addon.UI.Resize.Update(DressUpFrame, self)
				self.Module.UpdateButtonState(self)
				addon:SetUnit("player")
				addon:SetSkinForUnit("player")
			end,
			OnClick = function(self, button)
				addon:SetUnit("target")
				addon:SetSkinForUnit("target")
			end,
			OnEvent = function(self, event, ...)
				if event == "PLAYER_TARGET_CHANGED" then
					self.Module.UpdateButtonState(self)
				end
			end,
		},
		Widgets = {
			{ type = "Button", parent = "DressUpFrameResetButton", template = "UIPanelButtonTemplate" },
		},
		UpdateButtonState = function(self)
			self:SetEnabled(addon:CanSetUnit("target"))
		end,
	})

	local DUF_CUSTOM = false and addon:CreateModule("DressUpFrame Custom", {
		LibDropDown = LibStub and LibStub("LibDropDown", true),
		CanLoad = function(self)
			return self.LibDropDown and type(DressUpFrame) == "table"
		end,
		Handlers = {
			OnLoad = function(self)
				self.Text = ns.L.CUSTOM
				self.TextShort = ns.L.CUSTOM_SHORT
				self:RegisterForClicks("LeftButtonUp", "RightButtonUp")
				self:SetPoint("RIGHT", DUF_TARGET.Widgets[1].Frame, "LEFT", 0, 0)
				hooksecurefunc(DressUpFrame, "SetSize", function() C_Timer.After(0.01, function() addon.UI.Resize.Update(DressUpFrame, self) end) end)
				self.Module.ActiveGender = self.Module.Genders[1]
				self.Module.ActiveRace = self.Module.Races[1]
				self.Module.CreateMenu(self)
			end,
			OnShow = function(self)
				addon.UI.Resize.Update(DressUpFrame, self)
			end,
			OnClick = function(self, button)
				self.Module.ToggleMenu(self)
			end,
		},
		Widgets = {
			{ type = "Button", parent = "DressUpFrameResetButton", template = "UIPanelButtonTemplate" },
		},
		Genders = {
			{ id = 2, gender = 0, text = "Male", atlasGender = "male" },
			{ id = 3, gender = 1, text = "Female", atlasGender = "female" },
		},
		Races = {
			-- Alliance Races
			{ faction = 1, id = "Draenei", race = 11, text = "Draenei", atlasRace = "draenei" },
			{ faction = 1, id = "Dwarf", race = 3, text = "Dwarf", atlasRace = "dwarf" },
			{ faction = 1, id = "Gnome", race = 7, text = "Gnome", atlasRace = "gnome" },
			{ faction = 1, id = "Human", race = 1, text = "Human", atlasRace = "human" },
			{ faction = 1, id = "NightElf", race = 4, text = "Night Elf", atlasRace = "nightelf" },
			{ faction = 1, id = "Worgen", race = 22, text = "Worgen", atlasRace = "worgen" },
			-- Alliance Allied Races
			{ faction = 1, id = "DarkIronDwarf", race = 34, text = "Dark Iron Dwarf", atlasRace = "darkirondwarf", allied = 1 },
			{ faction = 1, id = "KulTiran", race = 32, text = "Kul Tiran", atlasRace = "kultiran", allied = 1 },
			{ faction = 1, id = "LightforgedDraenei", race = 30, text = "Lightforged Draenei", atlasRace = "lightforged", allied = 1 },
			{ faction = 1, id = "VoidElf", race = 29, text = "Void Elf", atlasRace = "voidelf", allied = 1 },
			{ faction = 1, id = "Mechagnome", race = 37, text = "Mechagnome", atlasRace = "mechagnome", allied = 1 },
			-- Horde Races
			{ faction = 2, id = "BloodElf", race = 10, text = "Blood Elf", atlasRace = "bloodelf" },
			{ faction = 2, id = "Goblin", race = 9, text = "Goblin", atlasRace = "goblin" },
			{ faction = 2, id = "Orc", race = 2, text = "Orc", atlasRace = "orc" },
			{ faction = 2, id = "Tauren", race = 6, text = "Tauren", atlasRace = "tauren" },
			{ faction = 2, id = "Troll", race = 8, text = "Troll", atlasRace = "troll" },
			{ faction = 2, id = "Scourge", race = 5, text = "Undead", atlasRace = "undead" },
			-- Horde Allied Races
			{ faction = 2, id = "HighmountainTauren", race = 28, text = "Highmountain Tauren", atlasRace = "highmountain", allied = 2 },
			{ faction = 2, id = "MagharOrc", race = 36, text = "Mag'har Orc", atlasRace = "magharorc", allied = 2 },
			{ faction = 2, id = "Nightborne", race = 27, text = "Nightborne", atlasRace = "nightborne", allied = 2 },
			{ faction = 2, id = "ZandalariTroll", race = 31, text = "Zandalari Troll", atlasRace = "zandalari", allied = 2 },
			{ faction = 3, id = "Vulpera", race = 35, text = "Vulpera", atlasRace = "vulpera", allied = 2 },
			-- Neutral
			{ faction = 3, id = "Pandaren", race = 24, text = "Pandaren", atlasRace = "pandaren" },
			-- Other Races
			-- { faction = 3, id = "FelOrc", race = 12, text = "Fel Orc", allied = 3 },
			-- { faction = 3, id = "Naga_", race = 13, text = "Naga", allied = 3 },
			-- { faction = 3, id = "Broken", race = 14, text = "Broken", allied = 3 },
			-- { faction = 3, id = "Skeleton", race = 15, text = "Skeleton", allied = 3 },
			-- { faction = 3, id = "Vrykul", race = 16, text = "Vrykul", allied = 3 },
			-- { faction = 3, id = "Tuskarr", race = 17, text = "Tuskarr", allied = 3 },
			-- { faction = 3, id = "ForestTroll", race = 18, text = "Forest Troll", allied = 3 },
			-- { faction = 3, id = "Taunka", race = 19, text = "Taunka", allied = 3 },
			-- { faction = 3, id = "NorthrendSkeleton", race = 20, text = "Northrend Skeleton", allied = 3 },
			-- { faction = 3, id = "IceTroll", race = 21, text = "Ice Troll", allied = 3 },
			-- { faction = 3, id = "ThinHuman", race = 33, text = "Thin Human", allied = 3 },
		},
		ActiveGender = nil,
		ActiveRace = nil,
		CreateMenu = function(self)
			local function SetGender(_, _, genderInfo)
				return self.Module.SetGender(self, genderInfo)
			end
			local function SetRace(_, _, raceInfo)
				return self.Module.SetRace(self, raceInfo)
			end
			local Menu = self.Module.LibDropDown:NewButton(self, addonName .. "DressUpFrameDropDownMenuButton")
			Menu:SetStyle("MENU")
			Menu:SetAnchor("BOTTOMLEFT", self, "TOPLEFT", 10, 10)
			local genderOptions = {}
			local raceOptions = {}
			local raceSubMenuOptions
			for i = 1, #self.Module.Genders do
				local genderInfo = self.Module.Genders[i]
				local genderOption = {
					atlas = GetAtlasInfo("charactercreate-gendericon-" .. genderInfo.atlasGender) and "charactercreate-gendericon-" .. genderInfo.atlasGender or "AlliedRace-UnlockingFrame-" .. genderInfo.atlasGender, -- TODO: 9.0
					text = genderInfo.text,
					args = { genderInfo },
					func = SetGender,
					keepShown = true,
				}
				genderOptions[#genderOptions + 1] = genderOption
			end
			for i = 1, #self.Module.Races do
				local prevRaceInfo = self.Module.Races[i - 1]
				local raceInfo = self.Module.Races[i]
				if not prevRaceInfo or (raceInfo.faction ~= prevRaceInfo.faction) then
					raceOptions[#raceOptions + 1] = {
						isTitle = true,
						text = raceInfo.faction == 1 and "Alliance" or (raceInfo.faction == 2 and "Horde" or "Neutral"),
					}
				end
				if prevRaceInfo and raceInfo.allied ~= prevRaceInfo.allied then
					if not prevRaceInfo.allied then
						raceSubMenuOptions = {}
						raceOptions[#raceOptions + 1] = {
							text = raceInfo.allied == 1 and "Alliance Allied Races" or (raceInfo.allied == 2 and "Horde Allied Races" or "Other Races"),
							menu = raceSubMenuOptions,
							keepShown = true,
						}
					elseif not raceInfo.allied then
						raceSubMenuOptions = nil
					end
				end
				local raceOption = {
					atlas = "raceicon-" .. raceInfo.atlasRace .. "-male",
					text = raceInfo.text,
					args = { raceInfo },
					func = SetRace,
					keepShown = true,
				}
				if raceSubMenuOptions then
					raceSubMenuOptions[#raceSubMenuOptions + 1] = raceOption
				else
					raceOptions[#raceOptions + 1] = raceOption
				end
			end
			Menu:Add({
				isTitle = true,
				text = "Gender",
			})
			for i = 1, #genderOptions do
				Menu:Add(genderOptions[i])
			end
			Menu:Add({
				text = "Race",
				menu = raceOptions,
				keepShown = true,
			})
			Menu:Add({
				text = "Close",
			})
			self.Module.Menu = Menu
		end,
		SetGender = function(self, genderInfo)
			self.Module.ActiveGender = genderInfo
			addon:SetCustomGender(genderInfo)
		end,
		SetRace = function(self, raceInfo)
			self.Module.ActiveRace = raceInfo
			addon:SetCustomRace(raceInfo)
		end,
		ToggleMenu = function(self)
			self.Module.Menu:Toggle()
		end,
	})

	addon:SetScript("OnEvent", function(addon, event, ...) addon[event](addon, event, ...) end)
	addon:RegisterEvent("ADDON_LOADED")

end
