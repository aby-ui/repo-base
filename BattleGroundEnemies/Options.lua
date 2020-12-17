local addonName, Data = ...
local GetAddOnMetadata = GetAddOnMetadata

local L = LibStub("AceLocale-3.0"):GetLocale("BattleGroundEnemies")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local LSM = LibStub("LibSharedMedia-3.0")

local function copy(obj)
	if type(obj) ~= 'table' then return obj end
	local res = {}
	for k, v in pairs(obj) do res[copy(k)] = copy(v) end
	return res
end
						
local function addStaticPopupForPlayerTypeConfigImport(playerType, oppositePlayerType)
	StaticPopupDialogs["CONFIRM_OVERRITE_"..addonName..playerType] = {
	  text = L.ConfirmProfileOverride:format(L[playerType], L[oppositePlayerType]),
	  button1 = YES,
	  button2 = NO,
	  OnAccept = function (self) 
			BattleGroundEnemies.db.profile[playerType] = copy(BattleGroundEnemies.db.profile[oppositePlayerType])
			BattleGroundEnemies:ProfileChanged()
			AceConfigRegistry:NotifyChange("BattleGroundEnemies")
	  end,
	  OnCancel = function (self) end,
	  OnHide = function (self) self.data = nil; self.selectedIcon = nil; end,
	  hideOnEscape = 1,
	  timeout = 30,
	  exclusive = 1,
	  whileDead = 1,
	}
end
addStaticPopupForPlayerTypeConfigImport("Enemies", "Allies")
addStaticPopupForPlayerTypeConfigImport("Allies", "Enemies")


local function addStaticPopupBGTypeConfigImport(playerType, oppositePlayerType, BGSize)
	StaticPopupDialogs["CONFIRM_OVERRITE_"..addonName..playerType..BGSize] = {
	  text = L.ConfirmProfileOverride:format(L[playerType]..": "..L["BGSize_"..BGSize], L[oppositePlayerType]..": "..L["BGSize_"..BGSize]),
	  button1 = YES,
	  button2 = NO,
	  OnAccept = function (self) 
			BattleGroundEnemies.db.profile[playerType][BGSize] = copy(BattleGroundEnemies.db.profile[oppositePlayerType][BGSize])
			if BattleGroundEnemies.BGSize and BattleGroundEnemies.BGSize == tonumber(BGSize) then BattleGroundEnemies[playerType]:ApplyBGSizeSettings() end
			AceConfigRegistry:NotifyChange("BattleGroundEnemies")
	  end,
	  OnCancel = function (self) end,
	  OnHide = function (self) self.data = nil; self.selectedIcon = nil; end,
	  hideOnEscape = 1,
	  timeout = 30,
	  exclusive = 1,
	  whileDead = 1,
	}
end
addStaticPopupBGTypeConfigImport("Enemies", "Allies", "15")
addStaticPopupBGTypeConfigImport("Allies", "Enemies", "15")
addStaticPopupBGTypeConfigImport("Enemies", "Allies", "40")
addStaticPopupBGTypeConfigImport("Allies", "Enemies", "40")




local function OptionsType(option)

	local playerType, IsGeneralsetting
	if option[1] == "EnemySettings" then
		playerType = "Enemies"
	elseif option[1] == "AllySettings" then
		playerType = "Allies"
	end
	
	if playerType and option[2] == "GeneralSettings" then
		IsGeneralsetting = true
	end
	
	
	return playerType, IsGeneralsetting
end

local function Optionslocation(option)
	local playerType, IsGeneralsetting = OptionsType(option)
	local location = BattleGroundEnemies.db.profile
	
	if playerType then
		location = location[playerType]
		if not IsGeneralsetting then
			location = location[option[2]] -- its an BGSize option
		end
	end
	return location
end

local function getOption(option)
	local location = Optionslocation(option)
	local value = location[option[#option]]
	if type(value) == "table" then
		--BattleGroundEnemies:Debug("is table")
		return unpack(value)
	else
		return value
	end
end

local function setOption(option, value)
	-- local setting = BattleGroundEnemies.db
	-- for i = 1, #option do
		-- setting = setting[option[i]]
	-- end
	-- setting = value
	--BattleGroundEnemies:Debug(option.arg, value, option[0], option[1], option[2], option[3], option[4])
	local location = Optionslocation(option)
	--BattleGroundEnemies:Debug(type(value), value)
	-- BattleGroundEnemies:Debug(key, value)
	-- BattleGroundEnemies:Debug(unpack(value))
	location[option[#option]] = value
	
	--BattleGroundEnemies.db.profile[key] = value
end

local function CallInDeepness(obj, fixedsubtable, subtablename, subsubtablename, func, ...)
	--print(obj, fixedsubtable, subtablename, subsubtablename, func, ...)
	if fixedsubtable then obj = obj[fixedsubtable] end
	if subtablename then 
		obj = obj[subtablename] 
		if subsubtablename then 
			obj = obj[subsubtablename] 
		end
	end
	
	--BattleGroundEnemies:Debug(func, ...)
	--print(obj, func, ...)
	obj[func](obj, ...)
end

local function ApplySettingsToButton(playerButton, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, func, ...)
	local object = fixedsubtableBeforeLoop and playerButton[fixedsubtableBeforeLoop] or playerButton
	if loopInButton1 then
		for k, obj in pairs(object[loopInButton1]) do
			CallInDeepness(obj, fixedsubtable, subtablename, subsubtablename, func, ...)
		end
		if loopInButton2 then
			for k, obj in pairs(object[loopInButton2]) do
				CallInDeepness(obj, fixedsubtable, subtablename, subsubtablename, func, ...)
			end
		end
	else
		CallInDeepness(object, fixedsubtable, subtablename, subsubtablename, func, ...)
	end
end


local function UpdateButtons(option, value, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, func, ...)
	setOption(option, value)	
	
	local playerType, IsGeneralsetting = OptionsType(option)
	
	--BattleGroundEnemies:Debug("IsEnemyOrAlly:", IsEnemyOrAlly, "playerType:", playerType)
	
	if playerType and not IsGeneralsetting and BattleGroundEnemies.BGSize ~= tonumber(option[2]) then return end
	
	
	for name, playerButton in pairs(BattleGroundEnemies[playerType].Players) do
		ApplySettingsToButton(playerButton, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, func, ...)
	end
	for i = 1, #BattleGroundEnemies[playerType].InactivePlayerButtons do
		local playerButton = BattleGroundEnemies[playerType].InactivePlayerButtons[i]
		ApplySettingsToButton(playerButton, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, func, ...)
	end
end


local function ApplySetting(option, value, LoopOverButtons, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, func, ...)
	setOption(option, value)
	
	if LoopOverButtons then
		UpdateButtons(option, value, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, func, ...)
	else
		local playerType = option[1] == "EnemySettings" and "Enemies" or "Allies"
		--BattleGroundEnemies:Debug(playerType, fixedsubtable, subtablename, func, ...)
		CallInDeepness(BattleGroundEnemies[playerType], fixedsubtable, subtablename, subsubtablename, func, ...)
	end
end

local function ApplySettingToEnemiesAndAllies(option, value, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, func, ...)
	setOption(option, value)	
	for number, playerType in pairs({BattleGroundEnemies.Allies, BattleGroundEnemies.Enemies}) do
		for name, playerButton in pairs(playerType.Players) do
			ApplySettingsToButton(playerButton, nil, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, func, ...)
		end
		for i = 1, #playerType.InactivePlayerButtons do
			local playerButton = playerType.InactivePlayerButtons[i]
			ApplySettingsToButton(playerButton, nil, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, func, ...)
		end
	end
end

local function addVerticalSpacing(order)
	local verticalSpacing = {
		type = "description",
		name = " ",
		fontSize = "large",
		width = "full",
		order = order
	}
	return verticalSpacing
end

local function addHorizontalSpacing(order)
	local horizontalSpacing = {
		type = "description",
		name = " ",
		width = "half",	
		order = order,
	}
	return horizontalSpacing
end



local function applyMainfont(playerButton, value)
	local conf = playerButton.bgSizeConfig
	playerButton.Name:SetFont(LSM:Fetch("font", value), conf.Name_Fontsize, conf.Name_Outline)
	playerButton.NumericTargetindicator:SetFont(LSM:Fetch("font", value), conf.NumericTargetindicator_Fontsize, conf.NumericTargetindicator_Outline)
	playerButton.ObjectiveAndRespawn.AuraText:SetFont(LSM:Fetch("font", value), conf.ObjectiveAndRespawn_Fontsize, conf.ObjectiveAndRespawn_Outline)
	playerButton.Trinket.Cooldown.Text:SetFont(LSM:Fetch("font", value), conf.Trinket_Cooldown_Fontsize, conf.Trinket_Cooldown_Outline)
	playerButton.Racial.Cooldown.Text:SetFont(LSM:Fetch("font", value), conf.Racial_Cooldown_Fontsize, conf.Racial_Cooldown_Outline)

	for identifier, debuffFrame in pairs(playerButton.DebuffContainer.Active) do
		local conf = playerButton.bgSizeConfig
		debuffFrame.Stacks:SetFont(LSM:Fetch("font", value), conf.Auras_Debuffs_Fontsize, conf.Auras_Debuffs_Outline)
		debuffFrame.Cooldown.Text:SetFont(LSM:Fetch("font", value), conf.Auras_Debuffs_Cooldown_Fontsize, conf.Auras_Debuffs_Cooldown_Outline)
	end
	for identifier, debuffFrame in pairs(playerButton.DebuffContainer.Inactive) do
		local conf = playerButton.bgSizeConfig
		debuffFrame.Stacks:SetFont(LSM:Fetch("font", value), conf.Auras_Debuffs_Fontsize, conf.Auras_Debuffs_Outline)
		debuffFrame.Cooldown.Text:SetFont(LSM:Fetch("font", value), conf.Auras_Debuffs_Cooldown_Fontsize, conf.Auras_Debuffs_Cooldown_Outline)
	end
	for identifier, buffFrame in pairs(playerButton.BuffContainer.Active) do
		local conf = playerButton.bgSizeConfig
		buffFrame.Stacks:SetFont(LSM:Fetch("font", value), conf.Auras_Buffs_Fontsize, conf.Auras_Buffs_Outline)
		buffFrame.Cooldown.Text:SetFont(LSM:Fetch("font", value), conf.Auras_Buffs_Cooldown_Fontsize, conf.Auras_Buffs_Cooldown_Outline)
	end
	for identifier, buffFrame in pairs(playerButton.BuffContainer.Inactive) do
		local conf = playerButton.bgSizeConfig
		buffFrame.Stacks:SetFont(LSM:Fetch("font", value), conf.Auras_Buffs_Fontsize, conf.Auras_Buffs_Outline)
		buffFrame.Cooldown.Text:SetFont(LSM:Fetch("font", value), conf.Auras_Buffs_Cooldown_Fontsize, conf.Auras_Buffs_Cooldown_Outline)
	end
	for drCat, drFrame in pairs(playerButton.DRContainer.DR) do
		drFrame.Cooldown.Text:SetFont(LSM:Fetch("font", value), conf.DrTracking_Cooldown_Fontsize, conf.DrTracking_Cooldown_Outline)
	end
	playerButton.Level:SetFont(LSM:Fetch("font", value), playerButton.config.LevelText_Fontsize, playerButton.config.LevelText_Outline)
end

local function addIconPositionSettings(playerType, BGSize, optionname, maindisable, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename)
	local size = optionname.."_Size"
	local horizontalDirection = optionname.."_HorizontalGrowDirection"
	local horizontalSpacing	= optionname.."_HorizontalSpacing"
	local verticalDirection = optionname.."_VerticalGrowdirection"
	local verticalSpacing =	optionname.."_VerticalSpacing"
	local iconsPerRow = optionname.."_IconsPerRow"
	
	--print(relativeTo)
	local options = {
		[size] = {
			type = "range",
			name = L.Size,
			disabled = function() 
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				return maindisable and not conf[maindisable] 
			end,
			set = function(option, value)
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				UpdateButtons(option, value, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, "SetIconSize", value)
			end,
			min = 0,
			max = 40,
			step = 1,
			order = 1
		},
		[iconsPerRow] = {
			type = "range",
			name = L.IconsPerRow,
			disabled = function() 
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				return maindisable and not conf[maindisable]
			end,
			set = function(option, value)
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				UpdateButtons(option, value, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, "AuraPositioning")
			end,
			min = 4,
			max = 30,
			step = 1,
			order = 2
		},
		Fake = addVerticalSpacing(3),
		[horizontalDirection] = {
			type = "select",
			name = L.HorizontalGrowdirection,
			disabled = function() 
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				return maindisable and not conf[maindisable] 
			end,
			set = function(option, value)
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				UpdateButtons(option, value, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, "AuraPositioning")
			end,
			width = "normal",
			values = Data.HorizontalDirections,
			order = 4
		},
		[horizontalSpacing] = {
			type = "range",
			name = L.HorizontalSpacing,
			disabled = function() 
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				return maindisable and not conf[maindisable] 
			end,
			set = function(option, value)
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				UpdateButtons(option, value, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, "AuraPositioning")
			end,
			min = 0,
			max = 20,
			step = 1,
			order = 5
		},
		Fake1 = addVerticalSpacing(6),
		[verticalDirection] = {
			type = "select",
			name = L.VerticalGrowdirection,
			disabled = function() 
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				return maindisable and not conf[maindisable] 
			end,
			set = function(option, value)
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				UpdateButtons(option, value, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, "AuraPositioning")
			end,
			width = "half",
			values = Data.VerticalDirections,
			order = 7
		},
		[verticalSpacing] = {
			type = "range",
			name = L.VerticalSpacing,
			disabled = function() 
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				return maindisable and not conf[maindisable] 
			end,
			set = function(option, value)
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				UpdateButtons(option, value, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, "AuraPositioning")
			end,
			min = 0,
			max = 20,
			step = 1,
			order = 8
		}
	}
	return options
end


-- all positions, corners, middle, left etc.
local function addContainerPositionSettings(playerType, BGSize, optionname, maindisable, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename)
	local point = optionname.."_Point"
	local relativeTo = optionname.."_RelativeTo"
	local relativePoint = optionname.."_RelativePoint"
	local ofsx = optionname.."_OffsetX"
	local ofsy = optionname.."_OffsetY"
	
	--print(relativeTo)
	local options = {
		[point] = {
			type = "select",
			name = L.Point,
			disabled = function() 
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				return maindisable and not conf[maindisable] 
			end,
			set = function(option, value)
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				UpdateButtons(option, value, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, "SetContainerPosition")
			end,
			width = "normal",
			values = Data.AllPositions,
			order = 1
		},
		[relativeTo] = {
			type = "select",
			name = L.AttachToObject,
			desc = L.AttachToObject_Desc,
			disabled = function() 
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				return maindisable and not conf[maindisable] 
			end,
			set = function(option, value)
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				
				if fixedsubtable == value then PlaySound(8959) RaidNotice_AddMessage(RaidWarningFrame, L.CantAnchorToItself, ChatTypeInfo["RAID_WARNING"]) return end 
				UpdateButtons(option, value, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, "SetContainerPosition")
			end,
			values = Data.Frames,
			order = 2
		},
		Fake = addVerticalSpacing(3),
		[relativePoint] = {
			type = "select",
			name = L.PointAtObject,
			disabled = function() 
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				return maindisable and not conf[maindisable] 
			end,
			set = function(option, value)
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				UpdateButtons(option, value, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, "SetContainerPosition")
			end,
			width = "half",
			values = Data.AllPositions,
			order = 4
		},
		[ofsx] = {
			type = "range",
			name = L.OffsetX,
			disabled = function() 
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				return maindisable and not conf[maindisable] 
			end,
			set = function(option, value)
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				UpdateButtons(option, value, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, "SetContainerPosition")
			end,
			min = -20,
			max = 20,
			step = 1,
			order = 5
		},
		[ofsy] = {
			type = "range",
			name = L.OffsetY,
			disabled = function() 
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				return maindisable and not conf[maindisable]
			end,
			set = function(option, value)
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				UpdateButtons(option, value, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, "SetContainerPosition")
			end,
			min = -20,
			max = 20,
			step = 1,
			order = 6
		}
	}
	return options
end

-- sets 2 points, user can choose left and right, 1 point at TOP..setting, and another point BOTTOM..setting is set
local function addBasicPositionSettings(playerType, BGSize, optionname, maindisable, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename)
	local point = optionname.."_BasicPoint"
	local relativeTo = optionname.."_RelativeTo"
	local relativePoint = optionname.."_RelativePoint"
	local ofsx = optionname.."_OffsetX"
	local ofsy = optionname.."_OffsetY"
	
	--print(relativeTo)
	local options = {
		[point] = {
			type = "select",
			name = L.Side,
			disabled = function() 
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				return maindisable and not conf[maindisable] 
			end,
			set = function(option, value)
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				UpdateButtons(option, value, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, "SetPosition")
			end,
			width = "normal",
			values = Data.BasicPositions,
			order = 1
		},
		[relativeTo] = {
			type = "select",
			name = L.AttachToObject,
			desc = L.AttachToObject_Desc,
			disabled = function() 
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				return maindisable and not conf[maindisable] 
			end,
			set = function(option, value)
				local conf = BattleGroundEnemies.db.profile[playerType]
				--print(option, value, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, "SetPosition", conf[point], value, conf[relativePoint], conf[ofsx], conf[ofsy])
				
				if BGSize then conf = conf[BGSize] end
				if fixedsubtable == value then PlaySound(8959) RaidNotice_AddMessage(RaidWarningFrame, L.CantAnchorToItself, ChatTypeInfo["RAID_WARNING"]) return end 
				UpdateButtons(option, value, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, "SetPosition")
			end,
			values = Data.Frames,
			order = 2
		},
		Fake = addVerticalSpacing(3),
		[relativePoint] = {
			type = "select",
			name = L.SideAtObject,
			disabled = function() 
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				return maindisable and not conf[maindisable] 
			end,
			set = function(option, value)
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				UpdateButtons(option, value, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, "SetPosition")
			end,
			width = "half",
			values = Data.BasicPositions,
			order = 4
		},
		[ofsx] = {
			type = "range",
			name = L.OffsetX,
			disabled = function() 
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				return maindisable and not conf[maindisable] 
			end,
			set = function(option, value)
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				UpdateButtons(option, value, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, "SetPosition")
			end,
			min = -20,
			max = 20,
			step = 1,
			order = 5
		}
	}
	return options
end

local function addNormalTextSettings(playerType, BGSize, optionname, maindisable, LoopOverButtons, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename)
	local fontsize = optionname.."_Fontsize"
	local textcolor = optionname.."_Textcolor"
	local outline = optionname.."_Outline"
	local enableTextShadow = optionname.."_EnableTextshadow"
	local textShadowcolor = optionname.."_TextShadowcolor"
		
	local options = {
		[fontsize] = {
			type = "range",
			name = L.Fontsize,
			desc = L[fontsize.."_Desc"],
			disabled = function() 
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				return maindisable and not conf[maindisable] 
			end,
			set = function(option, value)
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				ApplySetting(option, value, LoopOverButtons, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, "SetFont", LSM:Fetch("font", BattleGroundEnemies.db.profile.Font), value, conf[outline])
			end,
			min = 1,
			max = 40,
			step = 1,
			width = "normal",
			order = 1
		},
		[outline] = {
			type = "select",
			name = L.Font_Outline,
			desc = L.Font_Outline_Desc,
			disabled = function() 
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				return maindisable and not conf[maindisable] 
			end,
			set = function(option, value)
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				ApplySetting(option, value, LoopOverButtons, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, "SetFont", LSM:Fetch("font", BattleGroundEnemies.db.profile.Font), conf[fontsize], value)
			end,
			values = Data.FontOutlines,
			order = 2
		},
		Fake = addVerticalSpacing(3),
		[textcolor] = {
			type = "color",
			name = L.Fontcolor,
			desc = L[textcolor.."_Desc"],
			disabled = function() 
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				return maindisable and not conf[maindisable] 
			end,
			set = function(option, ...)
				local color = {...}
				ApplySetting(option, color, LoopOverButtons, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, "SetTextColor", ...)
			end,
			hasAlpha = true,
			width = "half",
			order = 4
		},
		[enableTextShadow] = {
			type = "toggle",
			name = L.FontShadow_Enabled,
			desc = L.FontShadow_Enabled_Desc,
			disabled = function() 
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				return maindisable and not conf[maindisable] 
			end,
			set = function(option, value)
				ApplySetting(option, value, LoopOverButtons, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, "EnableShadowColor", value)
			end,
			order = 5
		},
		[textShadowcolor] = {
			type = "color",
			name = L.FontShadowColor,
			desc = L.FontShadowColor_Desc,
			disabled = function() 
				local conf = BattleGroundEnemies.db.profile[playerType]
				if BGSize then conf = conf[BGSize] end
				return maindisable and not conf[maindisable] or not conf[enableTextShadow]
			end,
			set = function(option, ...)
				local color = {...}
				ApplySetting(option, color, LoopOverButtons, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename, "SetShadowColor", ...)
			end,
			hasAlpha = true,
			order = 6
		}
	}
	return options
end


local function addCooldownTextsettings(playerType, BGSize, optionname, maindisable, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, subtablename, subsubtablename)
	local showNumbers = optionname.."_ShowNumbers"
	local fontsize = optionname.."_Cooldown_Fontsize"
	local outline = optionname.."_Cooldown_Outline"
	local enableTextShadow = optionname.."_Cooldown_EnableTextshadow"
	local textShadowcolor = optionname.."_Cooldown_TextShadowcolor"	
	
	local mainconfig = BattleGroundEnemies.db.profile

	local options = {
		[showNumbers] = {
			type = "toggle",
			name = L.ShowNumbers,
			desc = L[showNumbers.."_Desc"],
			set = function(option, value)
				UpdateButtons(option, value, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, "Cooldown", subsubtablename, "SetHideCountdownNumbers", not value)
			end,
			order = 1
		},
		asdfasdf = {
			type = "group",
			name = "",
			desc = "",
			disabled = function() 
				local conf = BattleGroundEnemies.db.profile[playerType][BGSize]
				return maindisable and not conf[maindisable] or not conf[showNumbers]
			end, 
			inline = true,
			order = 2,
			args = {
				[fontsize] = {
					type = "range",
					name = L.Fontsize,
					desc = L.Cooldown_Fontsize_Desc,
					set = function(option, value)
						local conf = BattleGroundEnemies.db.profile[playerType][BGSize]
						UpdateButtons(option, value, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, "Cooldown", "Text", "SetFont", LSM:Fetch("font", BattleGroundEnemies.db.profile.Font), value, conf[outline])
					end,
					min = 6,
					max = 40,
					step = 1,
					width = "normal",
					order = 3
				},
				[outline] = {
					type = "select",
					name = L.Font_Outline,
					desc = L.Font_Outline_Desc,
					set = function(option, value)
						local conf = BattleGroundEnemies.db.profile[playerType][BGSize]
						UpdateButtons(option, value, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, "Cooldown", "Text", "SetFont", LSM:Fetch("font", BattleGroundEnemies.db.profile.Font), conf[fontsize], value)
					end,
					values = Data.FontOutlines,
					order = 4
				},
				Fake1 = addVerticalSpacing(5),
				[enableTextShadow] = {
					type = "toggle",
					name = L.FontShadow_Enabled,
					desc = L.FontShadow_Enabled_Desc,
					set = function(option, value)
						local conf = BattleGroundEnemies.db.profile[playerType][BGSize]
						UpdateButtons(option, value, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, "Cooldown", "Text", "EnableShadowColor", value, conf[textShadowcolor])
					end,
					order = 6
				},
				[textShadowcolor] = {
					type = "color",
					name = L.FontShadowColor,
					desc = L.FontShadowColor_Desc,
					disabled = function()
						local conf = BattleGroundEnemies.db.profile[playerType][BGSize]
						return maindisable and not conf[maindisable] or not conf[showNumbers] or not conf[enableTextShadow] 
					end, 
					set = function(option, ...)
						local color = {...}
						local conf = BattleGroundEnemies.db.profile[playerType][BGSize]
						UpdateButtons(option, color, fixedsubtableBeforeLoop, loopInButton1, loopInButton2, fixedsubtable, "Cooldown", "Text", "EnableShadowColor", conf[enableTextShadow], color)
					end,
					hasAlpha = true,
					order = 7
				}
			}
		}
	}
	return options
end

local function addEnemyAndAllySettings(self)
	local playerType = self.PlayerType
	local oppositePlayerType = playerType == "Enemies" and "Allies" or "Enemies"
	local settings = {}
	
	settings.GeneralSettings = {
		type = "group",
		name = GENERAL,
		desc = L["GeneralSettings"..playerType],
		get =  function(option)
			local value = option.arg and self.config[option.arg] or self.config[option[#option]]
			if type(value) == "table" then
				--BattleGroundEnemies:Debug("is table")
				return unpack(value)
			else
				return value
			end
		end,
		--childGroups = "tab",
		order = 1,
		args = {
			Enabled = {
				type = "toggle",
				name = ENABLE,
				desc = "test",
				set = function(option, value) 
					setOption(option, value)
					self:CheckIfShouldShow()
				end,
				order = 1
			},
			Fake = addHorizontalSpacing(2),
			Fake1 = addHorizontalSpacing(3),
			Fake2 = addHorizontalSpacing(4),
			CopySettings = {
				type = "execute",
				name = L.CopySettings:format(L[oppositePlayerType]),
				desc = L.CopySettings_Desc:format(L[oppositePlayerType])..L.NotAvailableInCombat,
				disabled = InCombatLockdown,
				func = function()
					StaticPopup_Show("CONFIRM_OVERRITE_"..addonName..playerType)
				end,
				width = "double",
				order = 5
			},
			RangeIndicator_Settings = {
				type = "group",
				name = L.RangeIndicator_Settings,
				desc = L.RangeIndicator_Settings_Desc,
				order = 6,
				args = {
					RangeIndicator_Enabled = {
						type = "toggle",
						name = L.RangeIndicator_Enabled,
						desc = L.RangeIndicator_Enabled_Desc,
						set = function(option, value) 
							UpdateButtons(option, value, nil, nil, nil, "RangeIndicator_Frame", nil, nil, "SetAlpha", value and self.config.RangeIndicator_Alpha or 1)
						end,
						order = 1
					},
					RangeIndicator_Range = {
						type = "select",
						name = L.RangeIndicator_Range,
						desc = L.RangeIndicator_Range_Desc,
						disabled = function() return not self.config.RangeIndicator_Enabled end,
						get = function() return Data[playerType.."ItemIDToRange"][self.config.RangeIndicator_Range] end,
						set = function(option, value)
							value = Data[playerType.."RangeToItemID"][value]
							setOption(option, value)
						end,
						values = Data[playerType.."RangeToRange"],
						width = "half",
						order = 2
					},
					RangeIndicator_Alpha = {
						type = "range",
						name = L.RangeIndicator_Alpha,
						desc = L.RangeIndicator_Alpha_Desc,
						disabled = function() return not self.config.RangeIndicator_Enabled end,
						min = 0,
						max = 1,
						step = 0.05,
						order = 3
					},
					Fake = addVerticalSpacing(4),
					RangeIndicator_Everything = {
						type = "toggle",
						name = L.RangeIndicator_Everything,
						disabled = function() return not self.config.RangeIndicator_Enabled end,
						set = function(option, value)
							UpdateButtons(option, value, nil, nil, nil, nil, nil, nil, "SetRangeIncicatorFrame")
						end,
						order = 6
					},
					RangeIndicator_Frames = {
						type = "multiselect",
						name = L.RangeIndicator_Frames,
						desc = L.RangeIndicator_Frames_Desc,
						hidden = function() return (not self.config.RangeIndicator_Enabled or self.config.RangeIndicator_Everything) end,
						get = function(option, key)
							return BattleGroundEnemies.db.profile[playerType].RangeIndicator_Frames[key]
						end,
						set = function(option, key, state) 
							BattleGroundEnemies.db.profile[playerType].RangeIndicator_Frames[key] = state
						
							for name, playerButton in pairs(BattleGroundEnemies[playerType].Players) do
								ApplySettingsToButton(playerButton, nil, nil, nil, nil, nil, nil, "SetRangeIncicatorFrame")
							end
							for i = 1, #BattleGroundEnemies[playerType].InactivePlayerButtons do
								local playerButton = BattleGroundEnemies[playerType].InactivePlayerButtons[i]
								ApplySettingsToButton(playerButton, nil, nil, nil, nil, nil, nil, "SetRangeIncicatorFrame")
							end
						end,
						width = "double",
						values = Data.RangeFrames,
						order = 7
					}
				}
			},
			Name = {
				type = "group",
				name = L.Name,
				desc = L.Name_Desc,
				order = 7,
				args = {
					ConvertCyrillic = {
						type = "toggle",
						name = L.ConvertCyrillic,
						desc = L.ConvertCyrillic_Desc,
						set = function(option, value)
							UpdateButtons(option, value, nil, nil, nil, nil, nil, nil, "SetName")
						end,
						width = "normal",
						order = 1
					},
					ShowRealmnames = {
						type = "toggle",
						name = L.ShowRealmnames,
						desc = L.ShowRealmnames_Desc,
						set = function(option, value)
							UpdateButtons(option, value, nil, nil, nil, nil, nil, nil, "SetName")
						end,
						width = "normal",
						order = 2
					},
					Fake = addVerticalSpacing(3),
					LevelTextSettings = {
						type = "group",
						name = L.LevelTextSettings,
						inline = true,
						order = 4,
						args = {
							LevelText_Enabled = {
								type = "toggle",
								name = L.LevelText_Enabled,
								set = function(option, value)
									UpdateButtons(option, value, nil, nil, nil, nil, nil, nil, "DisplayLevel")
								end,
								order = 1
							},
							LevelText_OnlyShowIfNotMaxLevel = {
								type = "toggle",
								name = L.LevelText_OnlyShowIfNotMaxLevel,
								disabled = function() return not self.config.LevelText_Enabled end,
								set = function(option, value)
									UpdateButtons(option, value, nil, nil, nil, nil, nil, nil, "DisplayLevel")
								end,
								order = 2
							},
							LevelTextTextSettings = {
								type = "group",
								name = "",
								--desc = L.TrinketSettings_Desc,
								disabled = function() return not self.config.LevelText_Enabled end,
								inline = true,
								order = 3,
								args = addNormalTextSettings(playerType, nil, "LevelText", "LevelText_Enabled", true, false, false, false, "Level")
							}
						}
					}
				}
			},
			KeybindSettings = {
				type = "group",
				name = KEY_BINDINGS,
				desc = L.KeybindSettings_Desc..L.NotAvailableInCombat,
				disabled = InCombatLockdown,
				set = function(option, value) 
					UpdateButtons(option, value, nil, nil, nil, nil, nil, nil, "SetBindings")
				end,
				--childGroups = "tab",
				order = 9,
				args = {
					LeftButtonType = {
						type = "select",
						name = KEY_BUTTON1,
						values = Data.Buttons,
						order = 1
					},
					LeftButtonValue = {
						type = "input",
						name = ENTER_MACRO_LABEL,
						desc = L.CustomMacro_Desc,
						disabled = function() return self.config.LeftButtonType == "Target" or self.config.LeftButtonType == "Focus" end,
						multiline = true,
						width = 'double',
						order = 2
					},
					Fake = addVerticalSpacing(3),
					RightButtonType = {
						type = "select",
						name = KEY_BUTTON2,
						values = Data.Buttons,
						order = 4
					},
					RightButtonValue = {
						type = "input",
						name = ENTER_MACRO_LABEL,
						desc = L.CustomMacro_Desc,
						disabled = function() return self.config.RightButtonType == "Target" or self.config.RightButtonType == "Focus" end,
						multiline = true,
						width = 'double',
						order = 5
					},
					Fake1 = addVerticalSpacing(6),
					MiddleButtonType = {
						type = "select",
						name = KEY_BUTTON3,
						values = Data.Buttons,
						order = 7
					},
					MiddleButtonValue = {
						type = "input",
						name = ENTER_MACRO_LABEL,
						desc = L.CustomMacro_Desc,
						disabled = function() return self.config.MiddleButtonType == "Target" or self.config.MiddleButtonType == "Focus" end,
						multiline = true,
						width = 'double',
						order = 8
					}
				}
			}
		}
	}
	

	for k, BGSize in pairs({"15", "40"}) do
		settings[BGSize] = {
			type = "group", 
			name = L["BGSize_"..BGSize],
			desc = L["BGSize_"..BGSize.."_Desc"]:format(L[playerType]),
			disabled = function() return not self.config.Enabled end,
			order = k + 1, 
			args = {
				Enabled = {
					type = "toggle",
					name = ENABLE,
					desc = "test",
					set = function(option, value) 
						setOption(option, value)
						self:CheckIfShouldShow()
					end,
					order = 1
				},
				Fake = addHorizontalSpacing(2),
				CopySettings = {
					type = "execute",
					name = L.CopySettings:format(L[oppositePlayerType]..": "..L["BGSize_"..BGSize]),
					desc = L.CopySettings_Desc:format(L[oppositePlayerType]..": "..L["BGSize_"..BGSize]),
					func = function()
						StaticPopup_Show("CONFIRM_OVERRITE_"..addonName..playerType..BGSize)
					end,
					width = "double",
					order = 3
				},
				MainFrameSettings = {
					type = "group",
					name = L.MainFrameSettings,
					desc = L.MainFrameSettings_Desc:format(L[playerType == "Enemies" and "enemies" or "allies"]),
					disabled = function() return not self.config[BGSize].Enabled end,
					--childGroups = "tab",
					order = 4,
					args = {
						Framescale = {
							type = "range",
							name = L.Framescale,
							desc = L.Framescale_Desc..L.NotAvailableInCombat,
							disabled = InCombatLockdown,
							set = function(option, value)
								setOption(option, value)
								if BattleGroundEnemies.BGSize ~= tonumber(BGSize) then return end
								self:SetScale(value)
							end,
							min = 0.3,
							max = 2,
							step = 0.05,
							order = 1
						},
						PlayerCount = {
							type = "group",
							name = L.PlayerCount_Enabled,
							order = 2,
							inline = true,
							args = {
								PlayerCount_Enabled = {
									type = "toggle",
									name = L.PlayerCount_Enabled,
									desc = L.PlayerCount_Enabled_Desc,
									set = function(option, value)
										setOption(option, value)
										if BattleGroundEnemies.BGSize ~= tonumber(BGSize) then return end
									
										self.PlayerCount:SetShown(value)
									end,
									order = 1
								},
								PlayerCountTextSettings = {
									type = "group",
									name = "",
									--desc = L.TrinketSettings_Desc,
									disabled = function() return not self.config[BGSize].PlayerCount_Enabled end,
									inline = true,
									order = 2,
									args = addNormalTextSettings(playerType, BGSize, "PlayerCount", "PlayerCount_Enabled", false, false, false, false, "PlayerCount")
								}
							}
						}
					}
				},
				BarSettings = {
					type = "group",
					name = L.BarSettings,
					desc = L.BarSettings_Desc,
					disabled = function() return not self.config[BGSize].Enabled end,
					--childGroups = "tab",
					order = 5,
					args = {
						BarWidth = {
							type = "range",
							name = L.Width,
							desc = L.BarWidth_Desc..L.NotAvailableInCombat,
							disabled = InCombatLockdown,
							set = function(option, value)
								if BattleGroundEnemies.BGSize and BattleGroundEnemies.BGSize == tonumber(BGSize) then self:SetWidth(value) end
								UpdateButtons(option, value, nil, nil, nil, nil, nil, nil, "SetWidth", value)
							end,
							min = 1,
							max = 400,
							step = 1,
							order = 1
						},
						BarHeight = {
							type = "range",
							name = L.Height,
							desc = L.BarHeight_Desc..L.NotAvailableInCombat,
							disabled = InCombatLockdown,
							set = function(option, value) 
								UpdateButtons(option, value, nil, nil, nil, nil, nil, nil, "SetHeight", value)
							end,
							min = 1,
							max = 40,
							step = 1,
							order = 2
						},
						BarVerticalGrowdirection = {
							type = "select",
							name = L.VerticalGrowdirection,
							desc = L.VerticalGrowdirection_Desc..L.NotAvailableInCombat,
							disabled = InCombatLockdown,
							set = function(option, value) 
								setOption(option, value)
								if BattleGroundEnemies.BGSize ~= tonumber(BGSize) then return end
								
								self:ButtonPositioning()
								self:SetPlayerCountJustifyV(value)
							end,
							values = Data.VerticalDirections,
							order = 3
						},
						BarVerticalSpacing = {
							type = "range",
							name = L.VerticalSpacing,
							desc = L.VerticalSpacing..L.NotAvailableInCombat,
							disabled = InCombatLockdown,
							set = function(option, value) 
								setOption(option, value)
								if BattleGroundEnemies.BGSize ~= tonumber(BGSize) then return end
								
								self:ButtonPositioning()
							end,
							min = 0,
							max = 20,
							step = 1,
							order = 4
						},
						BarColumns = {
							type = "range",
							name = L.Columns,
							desc = L.Columns_Desc..L.NotAvailableInCombat,
							disabled = InCombatLockdown,
							set = function(option, value) 
								setOption(option, value)
								if BattleGroundEnemies.BGSize ~= tonumber(BGSize) then return end
								
								self:ButtonPositioning()
							end,
							min = 1,
							max = 4,
							step = 1,
							order = 5
						},
						BarHorizontalGrowdirection = {
							type = "select",
							name = L.VerticalGrowdirection,
							desc = L.VerticalGrowdirection_Desc..L.NotAvailableInCombat,
							hidden = function() return not self.config[BGSize].Enabled or self.config[BGSize].BarColumns < 2 end,
							disabled = InCombatLockdown,
							set = function(option, value) 
								setOption(option, value)
								if BattleGroundEnemies.BGSize ~= tonumber(BGSize) then return end
								
								self:ButtonPositioning()
								self:SetPlayerCountJustifyV(value)
							end,
							values = Data.HorizontalDirections,
							order = 6
						},
						BarHorizontalSpacing = {
							type = "range",
							name = L.HorizontalSpacing,
							desc = L.HorizontalSpacing..L.NotAvailableInCombat,
							hidden = function() return not self.config[BGSize].Enabled or self.config[BGSize].BarColumns < 2 end,
							disabled = InCombatLockdown,
							set = function(option, value) 
								setOption(option, value)
								if BattleGroundEnemies.BGSize ~= tonumber(BGSize) then return end
								
								self:ButtonPositioning()
							end,
							min = 0,
							max = 400,
							step = 1,
							order = 7
						},
						HealthBarSettings = {
							type = "group",
							name = L.HealthBarSettings,
							desc = L.HealthBarSettings_Desc,
							order = 8,
							args = {
								General = {
									type = "group",
									name = L.General,
									desc = "",
									--inline = true,
									order = 7,
									args = {
										HealthBar_Texture = {
											type = "select",
											name = L.BarTexture,
											desc = L.HealthBar_Texture_Desc,
											set = function(option, value)
												UpdateButtons(option, value, nil, nil, nil, "Health", nil, nil, "SetStatusBarTexture", LSM:Fetch("statusbar", value))
											end,
											dialogControl = 'LSM30_Statusbar',
											values = AceGUIWidgetLSMlists.statusbar,
											width = "normal",
											order = 1
										},
										Fake = addHorizontalSpacing(2),
										HealthBar_Background = {
											type = "color",
											name = L.BarBackground,
											desc = L.HealthBar_Background_Desc,
											set = function(option, ...)
												local color = {...} 
												UpdateButtons(option, color, nil, nil, nil, "Health", "Background", nil, "SetVertexColor", ...)
											end,
											hasAlpha = true,
											width = "normal",
											order = 3
										}
									}
								},
								Name = {
									type = "group",
									name = L.Name,
									desc = L.Name_Desc,
									order = 2,
									args = {
										NameTextSettings = {
											type = "group",
											name = "",
											--desc = L.TrinketSettings_Desc,
											inline = true,
											order = 1,
											args = addNormalTextSettings(playerType, BGSize, "Name", false, true, false, false, false, "Name")
										},
									}
								},
								RoleIconSettings = {
									type = "group",
									name = L.RoleIconSettings,
									desc = L.RoleIconSettings_Desc,
									set = function(option, value)
										UpdateButtons(option, value, nil, nil, nil, "Role", nil, nil, "ApplySettings")
									end,
									order = 3,
									args = {
										RoleIcon_Enabled = {
											type = "toggle",
											name = L.RoleIcon_Enabled,
											desc = L.RoleIcon_Enabled_Desc,
											width = "normal",
											order = 1
										},
										RoleIcon_Size = {
											type = "range",
											name = L.Size,
											desc = L.RoleIcon_Size_Desc,
											disabled = function() return not self.config[BGSize].RoleIcon_Enabled end,
											min = 2,
											max = 20,
											step = 1,
											width = "normal",
											order = 2
										},
										RoleIcon_VerticalPosition = {
											type = "range",
											name = L.VerticalPosition,
											desc = L.RoleIcon_Size_Desc,
											disabled = function() return not self.config[BGSize].RoleIcon_Enabled end,
											min = 0,
											max = 50,
											step = 1,
											width = "normal",
											order = 3,
										}
									}
								},
								TargetIndicator = {
									type = "group",
									name = L.TargetIndicator,
									desc = L.TargetIndicator_Desc,
									--childGroups = "select",
									--inline = true,
									order = 4,
									args = {
										NumericTargetindicator_Enabled = {
											type = "toggle",
											name = L.NumericTargetindicator,
											desc = L.NumericTargetindicator_Enabled_Desc:format(L[playerType == "Enemies" and "enemies" or "allies"]),
											set = function(option, value)
												UpdateButtons(option, value, nil, nil, nil, "NumericTargetindicator", nil, nil, "SetShown", value)
											end,
											width = "full",
											order = 1
										},
										NumericTargetindicatorTextSettings = {
											type = "group",
											name = "",
											--desc = L.TrinketSettings_Desc,
											disabled = function() return not self.config[BGSize].NumericTargetindicator_Enabled end,
											inline = true,
											order = 2,
											args = addNormalTextSettings(playerType, BGSize, "NumericTargetindicator", "NumericTargetindicator_Enabled", true, false, false, false, "NumericTargetindicator")
										},
										Fake2 = addVerticalSpacing(3),
										SymbolicTargetindicator_Enabled = {
											type = "toggle",
											name = L.SymbolicTargetindicator_Enabled,
											desc = L.SymbolicTargetindicator_Enabled_Desc:format(L[playerType == "Enemies" and "enemy" or "ally"]),
											set = function(option, value)
												UpdateButtons(option, value, nil, "TargetIndicators", nil, nil, nil, nil, "SetShown", value)
											end,
											width = "full",
											order = 4
										}
									}
								}
							}
						},
						PowerBarSettings = {
							type = "group",
							name = L.PowerBarSettings,
							desc = L.PowerBarSettings_Desc,
							order = 8,
							args = {
								PowerBar_Enabled = {
									type = "toggle",
									name = L.PowerBar_Enabled,
									desc = L.PowerBar_Enabled_Desc,
									set = function(option, value)
										if value then
											if self:IsShown() and not self.TestmodeActive then
												self:RegisterEvent("UNIT_POWER_FREQUENT")
											end
											UpdateButtons(option, value, nil, nil, nil, "Power", nil, nil, "SetHeight", self.config[BGSize].PowerBar_Height)
										else
											self:UnregisterEvent("UNIT_POWER_FREQUENT")
											UpdateButtons(option, value, nil, nil, nil, "Power", nil, nil, "SetHeight", 0.01)
										end
									end,
									order = 1
								},
								PowerBar_Height = {
									type = "range",
									name = L.Height,
									desc = L.PowerBar_Height_Desc,
									disabled = function() return not self.config[BGSize].PowerBar_Enabled end,
									set = function(option, value)
										UpdateButtons(option, value, nil, nil, nil, "Power", nil, nil, "SetHeight", value)
									end,
									min = 1,
									max = 10,
									step = 1,
									width = "normal",
									order = 2
								},
								PowerBar_Texture = {
									type = "select",
									name = L.BarTexture,
									desc = L.PowerBar_Texture_Desc,
									disabled = function() return not self.config[BGSize].PowerBar_Enabled end,
									set = function(option, value)
										UpdateButtons(option, value, nil, nil, nil, "Power", nil, nil, "SetStatusBarTexture", LSM:Fetch("statusbar", value))
									end,
									dialogControl = 'LSM30_Statusbar',
									values = AceGUIWidgetLSMlists.statusbar,
									width = "normal",
									order = 3
								},
								Fake = addHorizontalSpacing(4),
								PowerBar_Background = {
									type = "color",
									name = L.BarBackground,
									desc = L.PowerBar_Background_Desc,
									disabled = function() return not self.config[BGSize].PowerBar_Enabled end,
									set = function(option, ...)
										local color = {...} 
										UpdateButtons(option, color, nil, nil, nil, "Power", "Background", nil, "SetVertexColor", ...)
									end,
									hasAlpha = true,
									width = "normal",
									order = 5
								}
							}
						},
						TrinketSettings = {
							type = "group",
							name = L.TrinketSettings,
							desc = L.TrinketSettings_Desc,
							order = 9,
							args = {
								Trinket_Enabled = {
									type = "toggle",
									name = L.Trinket_Enabled,
									desc = L.Trinket_Enabled_Desc,
									set = function(option, value)
										UpdateButtons(option, value, nil, nil, nil, "Trinket", nil, nil, "Enable")
									end,
									order = 1
								},
								TrinketPositioning = {
									type = "group",
									name = L.Position,
									args = addBasicPositionSettings(playerType, BGSize, "Trinket", "Trinket_Enabled", nil, nil, nil, "Trinket"),
									order = 2
								},
								Trinket_Width = {
									type = "range",
									name = L.Width,
									desc = L.Trinket_Width_Desc,
									disabled = function() return not self.config[BGSize].Trinket_Enabled end,
									set = function(option, value)
										UpdateButtons(option, value, nil, nil, nil, "Trinket", nil, nil, "Enable")
									end,
									min = 1,
									max = 40,
									step = 1,
									order = 3
								},
								TrinketCooldownTextSettings = {
									type = "group",
									name = L.Countdowntext,
									--desc = L.TrinketSettings_Desc,
									disabled = function() return not self.config[BGSize].Trinket_Enabled end,
									inline = true,
									order = 4,
									args = addCooldownTextsettings(playerType, BGSize, "Trinket", "Trinket_Enabled", nil, nil, nil, "Trinket")
								}
							}
						},
						RacialSettings = {
							type = "group",
							name = L.RacialSettings,
							desc = L.RacialSettings_Desc,
							order = 10,
							args = {
								Racial_Enabled = {
									type = "toggle",
									name = L.Racial_Enabled,
									desc = L.Racial_Enabled_Desc,
									set = function(option, value)
										UpdateButtons(option, value, nil, nil, nil, "Racial", nil, nil, "Enable")
									end,
									order = 1
								},
								RacialPositioning = {
									type = "group",
									name = L.Position,
									args = addBasicPositionSettings(playerType, BGSize, "Racial", "Racial_Enabled", nil, nil, nil, "Racial"),
									order = 2
								},
								Racial_Width = {
									type = "range",
									name = L.Width,
									desc = L.Racial_Width_Desc,
									disabled = function() return not self.config[BGSize].Racial_Enabled end,
									set = function(option, value)
										UpdateButtons(option, value, nil, nil, nil, "Racial", nil, nil, "Enable")
									end,
									min = 1,
									max = 40,
									step = 1,
									order = 3
								},
								RacialCooldownTextSettings = {
									type = "group",
									name = L.Countdowntext,
									--desc = L.TrinketSettings_Desc,
									disabled = function() return not self.config[BGSize].Racial_Enabled end,
									inline = true,
									order = 4,
									args = addCooldownTextsettings(playerType, BGSize, "Racial", "Racial_Enabled", nil, nil, nil, "Racial")
								},
								RacialFilteringSettings = {
									type = "group",
									name = FILTER,
									desc = L.RacialFilteringSettings_Desc,
									disabled = function() return not self.config[BGSize].Racial_Enabled end,
									--inline = true,
									order = 5,
									args = {
										RacialFiltering_Enabled = {
											type = "toggle",
											name = L.Filtering_Enabled,
											desc = L.RacialFiltering_Enabled_Desc,
											disabled = function() return not self.config[BGSize].Racial_Enabled end,
											width = 'normal',
											order = 1
										},
										Fake = addHorizontalSpacing(2),
										RacialFiltering_Filterlist = {
											type = "multiselect",
											name = L.Filtering_Filterlist,
											desc = L.RacialFiltering_Filterlist_Desc,
											disabled = function() return not self.config[BGSize].RacialFiltering_Enabled or not self.config[BGSize].Racial_Enabled end,
											get = function(option, key)
												for spellID in pairs(Data.RacialNameToSpellIDs[key]) do
													return self.config[BGSize].RacialFiltering_Filterlist[spellID]
												end
											end,
											set = function(option, key, state) -- value = spellname
												for spellID in pairs(Data.RacialNameToSpellIDs[key]) do
													self.config[BGSize].RacialFiltering_Filterlist[spellID] = state or nil
												end
											end,
											values = Data.Racialnames,
											order = 3
										}
									}
								}
							}
						},
						SpecSettings = {
							type = "group",
							name = L.SpecSettings,
							desc = L.SpecSettings_Desc,
							order = 11,
							args = {
								Spec_Enabled = {
									type = "toggle",
									name = L.Spec_Enabled,
									desc = L.Spec_Enabled_Desc,
									set = function(option, value)
										UpdateButtons(option, value, nil, nil, nil, "Spec", nil, nil, "ApplySettings")
									end,
									order = 1
								},
								Spec_Width = {
									type = "range",
									name = L.Width,
									desc = L.Spec_Width_Desc,
									disabled = function() return not self.config[BGSize].Spec_Enabled end,
									set = function(option, value)
										UpdateButtons(option, value, nil, nil, nil, "Spec", nil, nil, "ApplySettings")
									end,
									min = 1,
									max = 40,
									step = 1,
									order = 2
								},
								Fake = addVerticalSpacing(3),
								Spec_AuraDisplay_Enabled = {
									type = "toggle",
									name = L.Spec_AuraDisplay_Enabled,
									desc = L.Spec_AuraDisplay_Enabled_Desc,
									order = 4,
								},
								Fake1 = addVerticalSpacing(5),
								Spec_AuraDisplay_CooldownTextSettings = {
									type = "group",
									name = L.Countdowntext,
									--desc = L.TrinketSettings_Desc,
									disabled = function() return not self.config[BGSize].Spec_AuraDisplay_Enabled end,
									inline = true,
									order = 6,
									args = addCooldownTextsettings(playerType, BGSize, "Spec_AuraDisplay", "Spec_AuraDisplay_Enabled", nil, nil, nil, "Spec_AuraDisplay")
								}
							}
						},
						DrTrackingSettings = {
							type = "group",
							name = L.DrTrackingSettings,
							desc = L.DrTrackingSettings_Desc,
							order = 12,
							args = {
								DrTracking_Enabled = {
									type = "toggle",
									name = L.DrTracking_Enabled,
									desc = L.DrTracking_Enabled_Desc,
									order = 1
								},
								DrTracking_Container_PositioningSettings = {
									type = "group",
									name = L.Position,
									args = addBasicPositionSettings(playerType, BGSize, "DrTracking_Container", "DrTracking_Enabled", nil, nil, nil, "DRContainer"),
									order = 2
								},
								DrTracking_HorizontalSpacing = {
									type = "range",
									name = L.DrTracking_Spacing,
									desc = L.DrTracking_Spacing_Desc,
									disabled = function() return not self.config[BGSize].DrTracking_Enabled end,
									set = function(option, value)
										UpdateButtons(option, value, nil, nil, nil, "DRContainer", nil, nil, "DrPositioning")
									end,
									min = 0,
									max = 10,
									step = 1,
									order = 3
								},
								DrTracking_Container_Color = {
									type = "color",
									name = L.Container_Color,
									desc = L.DrTracking_Container_Color_Desc,
									set = function(option, ...)
										local color = {...} 
										UpdateButtons(option, color, nil, nil, nil, "DRContainer", nil, nil, "SetBackdropBorderColor", ...)
									end,
									hasAlpha = true,
									order = 4
								},
								DrTracking_Container_BorderThickness = {
									type = "range",
									name = L.BorderThickness,
									set = function(option, value)
										UpdateButtons(option, value, nil, nil, nil, "DRContainer", nil, nil, "ApplyBackdrop", value)
									end,
									min = 1,
									max = 6,
									step = 1,
									order = 5
								},
								DrTracking_DisplayType = {
									type = "select",
									name = L.DisplayType,
									desc = L.DrTracking_DisplayType_Desc,
									disabled = function() return not self.config[BGSize].DrTracking_Enabled end,
									set = function(option, value)
										UpdateButtons(option, value, "DRContainer", "DR", nil, nil, nil, nil, "ChangeDisplayType")
									end,
									values = Data.DisplayType,
									order = 6
								},
								DrTracking_GrowDirection = {
									type = "select",
									name = L.VerticalGrowdirection,
									desc = L.VerticalGrowdirection_Desc,
									disabled = function() return not self.config[BGSize].DrTracking_Enabled end,
									set = function(option, value) 
										UpdateButtons(option, value, nil, nil, nil, "DRContainer", nil, nil, "DrPositioning")
									end,
									values = Data.HorizontalDirections,
									order = 7
								},
								DrTrackingCooldownTextSettings = {
									type = "group",
									name = L.Countdowntext,
									--desc = L.TrinketSettings_Desc,
									disabled = function() return not self.config[BGSize].DrTracking_Enabled end,
									order = 8,
									args = addCooldownTextsettings(playerType, BGSize, "DrTracking", "DrTracking_Enabled", "DRContainer", "DR")
								},
								Fake1 = addVerticalSpacing(6),
								DrTrackingFilteringSettings = {
									type = "group",
									name = FILTER,
									--desc = L.DrTrackingFilteringSettings_Desc,
									disabled = function() return not self.config[BGSize].DrTracking_Enabled end,
									--inline = true,
									order = 9,
									args = {
										DrTrackingFiltering_Enabled = {
											type = "toggle",
											name = L.Filtering_Enabled,
											desc = L.DrTrackingFiltering_Enabled_Desc,
											disabled = function() return not self.config[BGSize].DrTracking_Enabled end,
											width = 'normal',
											order = 1
										},
										DrTrackingFiltering_Filterlist = {
											type = "multiselect",
											name = L.Filtering_Filterlist,
											desc = L.DrTrackingFiltering_Filterlist_Desc,
											disabled = function() return not (self.config[BGSize].DrTrackingFiltering_Enabled and self.config[BGSize].DrTracking_Enabled) end,
											get = function(option, key)
												return self.config[BGSize].DrTrackingFiltering_Filterlist[key]
											end,
											set = function(option, key, state) -- key = category name
												self.config[BGSize].DrTrackingFiltering_Filterlist[key] = state or nil
											end,
											values = Data.DrCategorys,
											order = 2
										}
									}
								}
							}
						},
						AurasSettings = {
							type = "group",
							name = L.AurasSettings,
							desc = L.AurasSettings_Desc,
							order = 13,
							args = {
								Auras_Enabled = {
									type = "toggle",
									name = L.Auras_Enabled,
									desc = L.Auras_Enabled_Desc,
									order = 1
								},
								Auras_ShowTooltips = {
									type = "toggle",
									name = L.Auras_ShowTooltips,
									order = 2
								},
								Auras_BuffsSettings = {
									type = "group",
									name = L.Buffs,
									disabled = function() return not self.config[BGSize].Auras_Enabled end,
									order = 3,
									args = {
										Auras_Buffs_Enabled = {
											type = "toggle",
											name = ENABLE,
											desc = SHOW_BUFFS,
											order = 1
										},
										Auras_Buffs_Container_IconSettings = {
											type = "group",
											name = L.BuffIcon,
											disabled = function() local conf = self.config[BGSize] return not (conf.Auras_Enabled and conf.Auras_Buffs_Enabled) end,
											order = 2,
											args = addIconPositionSettings(playerType, BGSize, "Auras_Buffs", "Auras_Buffs_Enabled", nil, nil, nil, "BuffContainer"),
										},
										Auras_Buffs_Container_PositioningSettings = {
											type = "group",
											name = L.ContainerPosition,
											disabled = function() local conf = self.config[BGSize] return not (conf.Auras_Enabled and conf.Auras_Buffs_Enabled) end,
											args = addContainerPositionSettings(playerType, BGSize, "Auras_Buffs_Container", "Auras_Buffs_Enabled", nil, nil, nil, "BuffContainer"),
											order = 3
										},
										Auras_Buffs_StacktextSettings = {
											type = "group",
											name = L.AurasStacktextSettings,
											--desc = L.MyAuraSettings_Desc,
											disabled = function() local conf = self.config[BGSize] return not (conf.Auras_Enabled and conf.Auras_Buffs_Enabled) end,
											order = 4,
											args = addNormalTextSettings(playerType, BGSize, "Auras_Buffs", "Auras_Buffs_Enabled", true, "BuffContainer", "Active", "Inactive", "Stacks")
										},
										Auras_Buffs_CooldownTextSettings = {
											type = "group",
											name = L.Countdowntext,
											--desc = L.TrinketSettings_Desc,
											disabled = function() local conf = self.config[BGSize] return not (conf.Auras_Enabled and conf.Auras_Buffs_Enabled) end,
											order = 5,
											args = addCooldownTextsettings(playerType, BGSize, "Auras_Buffs", "Auras_Buffs_Enabled", "BuffContainer", "Active", "Inactive")
										},
										Auras_Buffs_FilteringSettings = {
											type = "group",
											name = FILTER,
											desc = L.AurasFilteringSettings_Desc,
											disabled = function() local conf = self.config[BGSize] return not (conf.Auras_Enabled and conf.Auras_Buffs_Enabled) end,
											order = 6,
											args = {
												Auras_Buffs_Filtering_Enabled = {
													type = "toggle",
													name = L.Filtering_Enabled,
													disabled = function() local conf = self.config[BGSize] return not (conf.Auras_Enabled and conf.Auras_Buffs_Enabled) end,
													width = 'normal',
													order = 1
												},
												Fake = addVerticalSpacing(2),
												Auras_Buffs_OnlyShowMine = {
													type = "toggle",
													name = L.OnlyShowMine,
													desc = L.OnlyShowMine_Desc:format(L.Buffs),
													disabled = function() local conf = self.config[BGSize] return not (conf.Auras_Enabled and conf.Auras_Buffs_Enabled and conf.Auras_Buffs_Filtering_Enabled) end,
													order = 3,
												},
												Fake1 = addVerticalSpacing(4),
												Auras_Buffs_SpellIDFiltering_Enabled = {
													type = "toggle",
													name = L.SpellID_Filtering,
													disabled = function() local conf = self.config[BGSize] return not (conf.Auras_Enabled and conf.Auras_Buffs_Enabled and conf.Auras_Buffs_Filtering_Enabled) end,
													order = 5
												},
												Fake2 = addVerticalSpacing(6),
												Auras_Buffs_SpellIDFiltering__AddSpellID = {
													type = "input",
													name = L.AurasFiltering_AddSpellID,
													desc = L.AurasFiltering_AddSpellID_Desc,
													hidden = function() local conf = self.config[BGSize] return not (conf.Auras_Enabled and conf.Auras_Buffs_Enabled and conf.Auras_Buffs_Filtering_Enabled and conf.Auras_Buffs_SpellIDFiltering_Enabled) end,
													get = function() return "" end,
													set = function(option, value, state)
														local spellIDs = {strsplit(",", value)}
														for i = 1, #spellIDs do
															local spellID = tonumber(spellIDs[i])
															self.config[BGSize].Auras_Buffs_SpellIDFiltering_Filterlist[spellID] = true
														end
													end,
													width = 'double',
													order = 7
												},
												Fake3 = addVerticalSpacing(8),
												Auras_Buffs_SpellIDFiltering_Filterlist = {
													type = "multiselect",
													name = L.Filtering_Filterlist,
													desc = L.AurasFiltering_Filterlist_Desc:format(L.buff),
													hidden = function() local conf = self.config[BGSize] return not (conf.Auras_Enabled and conf.Auras_Buffs_Enabled and conf.Auras_Buffs_Filtering_Enabled and conf.Auras_Buffs_SpellIDFiltering_Enabled) end,
													get = function()
														return true --to make it checked
													end,
													set = function(option, value) 
														self.config[BGSize].Auras_Buffs_SpellIDFiltering_Filterlist[value] = nil
													end,
													values = function()
														local valueTable = {}
														for spellID in pairs(self.config[BGSize].Auras_Buffs_SpellIDFiltering_Filterlist) do
															valueTable[spellID] = spellID..": "..(GetSpellInfo(spellID) or "")
														end
														return valueTable
													end,
													order = 9
												}
											}
										}
									}
								},
								Auras_DebuffsSettings = {
									type = "group",
									name = L.Debuffs,
									disabled = function() return not self.config[BGSize].Auras_Enabled end,
									order = 4,
									args = {
										Auras_Debuffs_Enabled = {
											type = "toggle",
											name = ENABLE,
											desc = SHOW_DEBUFFS,
											order = 1
										},
										Fake = addVerticalSpacing(2),
										Auras_Debuffs_Coloring_Enabled = {
											type = "toggle",
											name = L.Auras_Debuffs_Coloring_Enabled,
											desc = L.Auras_Debuffs_Coloring_Enabled_Desc,
											set = function(option, value)
												UpdateButtons(option, value, "DebuffContainer", "Active", nil, nil, nil, nil, "ChangeDisplayType")
												UpdateButtons(option, value, "DebuffContainer", "Inactive", nil, nil, nil, nil, "ChangeDisplayType")
											end,
											order = 3
										},
										Auras_Debuffs_DisplayType = {
											type = "select",
											name = L.DisplayType,
											disabled = function() return not self.config[BGSize].Auras_Debuffs_Coloring_Enabled end,
											set = function(option, value)
												UpdateButtons(option, value, "DebuffContainer", "Active", nil, nil, nil, nil, "ChangeDisplayType")
												UpdateButtons(option, value, "DebuffContainer", "Inactive", nil, nil, nil, nil, "ChangeDisplayType")
											end,
											values = Data.DisplayType,
											order = 4
										},
										Auras_Debuffs_Container_IconSettings = {
											type = "group",
											name = L.DebuffIcon,
											disabled = function() local conf = self.config[BGSize] return not (conf.Auras_Enabled and conf.Auras_Debuffs_Enabled) end,
											order = 5,
											args = addIconPositionSettings(playerType, BGSize, "Auras_Debuffs", "Auras_Debuffs_Enabled", nil, nil, nil, "DebuffContainer"),
										},
										Auras_Debuffs_Container_PositioningSettings = {
											type = "group",
											name = L.ContainerPosition,
											disabled = function() local conf = self.config[BGSize] return not (conf.Auras_Enabled and conf.Auras_Debuffs_Enabled) end,
											args = addContainerPositionSettings(playerType, BGSize, "Auras_Debuffs_Container", "Auras_Debuffs_Enabled", nil, nil, nil, "DebuffContainer"),
											order = 6
										},
										Auras_Debuffs_StacktextSettings = {
											type = "group",
											name = L.AurasStacktextSettings,
											--desc = L.MyAuraSettings_Desc,
											disabled = function() local conf = self.config[BGSize] return not (conf.Auras_Enabled and conf.Auras_Debuffs_Enabled) end,
											order = 7,
											args = addNormalTextSettings(playerType, BGSize, "Auras_Debuffs", "Auras_Debuffs_Enabled", true, "DebuffContainer", "Active", "Inactive", "Stacks")
										},
										Auras_Debuffs_CooldownTextSettings = {
											type = "group",
											name = L.Countdowntext,
											--desc = L.TrinketSettings_Desc,
											disabled = function() local conf = self.config[BGSize] return not (conf.Auras_Enabled and conf.Auras_Debuffs_Enabled) end,
											order = 8,
											args = addCooldownTextsettings(playerType, BGSize, "Auras_Debuffs", "Auras_Debuffs_Enabled", "DebuffContainer", "Active", "Inactive")
										},
										Auras_Debuffs_FilteringSettings = {
											type = "group",
											name = FILTER,
											desc = L.AurasFilteringSettings_Desc,
											disabled = function() local conf = self.config[BGSize] return not (conf.Auras_Enabled and conf.Auras_Debuffs_Enabled) end,
											order = 9,
											args = {
												Auras_Debuffs_Filtering_Enabled = {
													type = "toggle",
													name = L.Filtering_Enabled,
													disabled = function() local conf = self.config[BGSize] return not (conf.Auras_Enabled and conf.Auras_Debuffs_Enabled) end,
													width = 'normal',
													order = 1
												},
												Fake = addVerticalSpacing(2),
												Auras_Debuffs_OnlyShowMine = {
													type = "toggle",
													name = L.OnlyShowMine,
													desc = L.OnlyShowMine_Desc:format(L.Debuffs),
													disabled = function() local conf = self.config[BGSize] return not (conf.Auras_Enabled and conf.Auras_Debuffs_Enabled and conf.Auras_Debuffs_Filtering_Enabled) end,
													order = 3,
												},
												Fake1 = addVerticalSpacing(4),
												Auras_Debuffs_DebuffTypeFiltering_Enabled = {
													type = "toggle",
													name = L.DebuffType_Filtering,
													desc = L.DebuffType_Filtering_Desc,
													disabled = function() local conf = self.config[BGSize] return not (conf.Auras_Enabled and conf.Auras_Debuffs_Enabled and conf.Auras_Debuffs_Filtering_Enabled) end,
													width = 'normal',
													order = 5
												},
												Auras_Debuffs_DebuffTypeFiltering_Filterlist = {
													type = "multiselect",
													name = "",
													desc = "",
													hidden = function() local conf = self.config[BGSize] return not (conf.Auras_Enabled and conf.Auras_Debuffs_Enabled and conf.Auras_Debuffs_Filtering_Enabled and conf.Auras_Debuffs_DebuffTypeFiltering_Enabled) end,
													get = function(option, key)
														return self.config[BGSize].Auras_Debuffs_DebuffTypeFiltering_Filterlist[key]
													end,
													set = function(option, key, state) -- value = spellname
														self.config[BGSize].Auras_Debuffs_DebuffTypeFiltering_Filterlist[key] = state
													end,
													width = 'normal',
													values = Data.DebuffTypes,
													order = 6
												},
												Auras_Debuffs_SpellIDFiltering_Enabled = {
													type = "toggle",
													name = L.SpellID_Filtering,
													disabled = function() local conf = self.config[BGSize] return not (conf.Auras_Enabled and conf.Auras_Debuffs_Enabled and conf.Auras_Debuffs_Filtering_Enabled) end,
													order = 7
												},
												Auras_Debuffs_SpellIDFiltering__AddSpellID = {
													type = "input",
													name = L.AurasFiltering_AddSpellID,
													desc = L.AurasFiltering_AddSpellID_Desc,
													hidden = function() local conf = self.config[BGSize] return not (conf.Auras_Enabled and conf.Auras_Debuffs_Enabled and conf.Auras_Debuffs_Filtering_Enabled and conf.Auras_Debuffs_SpellIDFiltering_Enabled) end,
													get = function() return "" end,
													set = function(option, value, state)
														local spellIDs = {strsplit(",", value)}
														for i = 1, #spellIDs do
															local spellID = tonumber(spellIDs[i])
															self.config[BGSize].Auras_Debuffs_SpellIDFiltering_Filterlist[spellID] = true
														end
													end,
													width = 'double',
													order = 8
												},
												Fake2 = addVerticalSpacing(9),
												Auras_Debuffs_SpellIDFiltering_Filterlist = {
													type = "multiselect",
													name = L.Filtering_Filterlist,
													desc = L.AurasFiltering_Filterlist_Desc:format(L.debuff),
													hidden = function() local conf = self.config[BGSize] return not (conf.Auras_Enabled and conf.Auras_Debuffs_Enabled and conf.Auras_Debuffs_Filtering_Enabled and conf.Auras_Debuffs_SpellIDFiltering_Enabled) end,
													get = function()
														return true --to make it checked
													end,
													set = function(option, value) 
														self.config[BGSize].Auras_Debuffs_SpellIDFiltering_Filterlist[value] = nil
													end,
													values = function()
														local valueTable = {}
														for spellID in pairs(self.config[BGSize].Auras_Debuffs_SpellIDFiltering_Filterlist) do
															valueTable[spellID] = spellID..": "..(GetSpellInfo(spellID) or "")
														end
														return valueTable
													end,
													order = 10
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	end
	local BGSize = "15"
	
	settings["15"].args.BarSettings.args.ObjectiveAndRespawnSettings = {
		type = "group",
		name = L.ObjectiveAndRespawnSettings,
		desc = L.ObjectiveAndRespawnSettings_Desc,
		order = 13,
		args = {
			ObjectiveAndRespawn_ObjectiveEnabled = {
				type = "toggle",
				name = L.ObjectiveAndRespawn_ObjectiveEnabled,
				desc = L.ObjectiveAndRespawn_ObjectiveEnabled_Desc,
				set = function(option, value)
					setOption(option, value)
					if BattleGroundEnemies.BGSize ~= tonumber(BGSize) then return end
				
					for playerName, playerButton in pairs(self.Players) do
						if value then
							if playerButton.ObjectiveAndRespawn.Icon:GetTexture() then
								playerButton.ObjectiveAndRespawn:Show()
							end
						else
							playerButton.ObjectiveAndRespawn:Hide()
						end
					end
					for playerName, playerButton in pairs(self.InactivePlayerButtons) do
						if value then
							if playerButton.ObjectiveAndRespawn.Icon:GetTexture() then
								playerButton.ObjectiveAndRespawn:Show()
							end
						else
							playerButton.ObjectiveAndRespawn:Hide()
						end
					end
				end,
				order = 1
			},
			ObjectiveAndRespawnPositioning = {
				type = "group",
				name = L.Position,
				args = addBasicPositionSettings(playerType, BGSize, "ObjectiveAndRespawn", "ObjectiveAndRespawn_ObjectiveEnabled", nil, nil, nil, "ObjectiveAndRespawn"),
				order = 2
			},
			ObjectiveAndRespawn_Width = {
				type = "range",
				name = L.Width,
				desc = L.ObjectiveAndRespawn_Width_Desc,
				disabled = function() return not self.config[BGSize].ObjectiveAndRespawn_ObjectiveEnabled end,
				set = function(option, value)
					UpdateButtons(option, value, nil, nil, nil, "ObjectiveAndRespawn", nil, nil, "SetWidth", value)
				end,
				min = 1,
				max = 50,
				step = 1,
				order = 3
			},
			ObjectiveAndRespawnTextSettings = {
				type = "group",
				name = "",
				--desc = L.TrinketSettings_Desc,
				disabled = function() return not self.config[BGSize].ObjectiveAndRespawn_ObjectiveEnabled end,
				inline = true,
				order = 4,
				args = addNormalTextSettings(playerType, BGSize, "ObjectiveAndRespawn", "ObjectiveAndRespawn_ObjectiveEnabled", true, false, false, false, "ObjectiveAndRespawn", "AuraText")
			}
		}
	}
	settings["15"].args.BarSettings.args.RBGSpecificSettings = {
		type = "group",
		name = L.RBGSpecificSettings,
		desc = L.RBGSpecificSettings_Desc,
		--inline = true,
		order = 14,
		args = {
			Notifications_Enabled = {
				type = "toggle",
				name = L.Notifications_Enabled,
				desc = L["Notifications_"..playerType.."_Enabled_Desc"],
				--inline = true,
				order = 1
			},
			-- PositiveSound = {
				-- type = "select",
				-- name = L.PositiveSound,
				-- desc = L.PositiveSound_Desc,
				-- disabled = function() return not self.config[BGSize].Notifications_Enabled end,
				-- dialogControl = 'LSM30_Sound',
				-- values = AceGUIWidgetLSMlists.sound,
				-- order = 2
			-- },
			-- NegativeSound = {
				-- type = "select",
				-- name = L.NegativeSound,
				-- desc = L.NegativeSound_Desc,
				-- disabled = function() return not self.config[BGSize].Notifications_Enabled end,
				-- dialogControl = 'LSM30_Sound',
				-- values = AceGUIWidgetLSMlists.sound,
				-- order = 3
			-- },
			ObjectiveAndRespawn_RespawnEnabled = {
				type = "toggle",
				name = L.ObjectiveAndRespawn_RespawnEnabled,
				desc = L.ObjectiveAndRespawn_RespawnEnabled_Desc,
				order = 4
			},
			ObjectiveAndRespawnCooldownTextSettings = {
				type = "group",
				name = L.Countdowntext,
				--desc = L.TrinketSettings_Desc,
				disabled = function() return not self.config[BGSize].ObjectiveAndRespawn_RespawnEnabled end,
				inline = true,
				order = 5,
				args = addCooldownTextsettings(playerType, BGSize, "ObjectiveAndRespawn", "ObjectiveAndRespawn_RespawnEnabled", nil, nil, nil, "ObjectiveAndRespawn")
			}
		}
	}
	
	
	return settings
end






function BattleGroundEnemies:SetupOptions()
	self.options = {
		type = "group",
		name = "BattleGroundEnemies " .. GetAddOnMetadata(addonName, "Version"),
		childGroups = "tab",
		get = getOption,
		set = setOption,
		args = {
			TestmodeSettings = {
				type = "group",
				name = L.TestmodeSettings,
				disabled = function() return InCombatLockdown() or (self:IsShown() and not self.TestmodeActive) end,
				inline = true,
				order = 1,
				args = {
					Testmode_BGSize = {
						type = "select",
						name = L.BattlegroundSize,
						order = 1,
						get = function() return self.BGSize end,
						set = function(option, value)
							self:BGSizeCheck(value)
							
							if self.TestmodeActive then
								self:FillData()
							end
						end,
						values = {[15] = L.BGSize_15, [40] = L.BGSize_40}
					},
					Testmode_Enabled = {
						type = "execute",
						name = L.Testmode_Toggle,
						desc = L.Testmode_Toggle_Desc,
						disabled = function() return InCombatLockdown() or (self:IsShown() and not self.TestmodeActive) or not self.BGSize end,
						func = self.ToggleTestmode,
						order = 2
					},
					Testmode_ToggleAnimation = {
						type = "execute",
						name = L.Testmode_ToggleAnimation,
						desc = L.Testmode_ToggleAnimation_Desc,
						disabled = function() return InCombatLockdown() or not self.TestmodeActive end,
						func = self.ToggleTestmodeOnUpdate,
						order = 3
					}
				}
			},
			GeneralSettings = {
				type = "group",
				name = L.GeneralSettings,
				desc = L.GeneralSettings_Desc,
				order = 3,
				args = {
					Locked = {
						type = "toggle",
						name = L.Locked,
						desc = L.Locked_Desc,
						order = 1
					},
					DisableArenaFrames = {
						type = "toggle",
						name = L.DisableArenaFrames,
						desc = L.DisableArenaFrames_Desc,
						set = function(option, value) 
							setOption(option, value)
							self:ToggleArenaFrames()
						end,
						order = 3
					},
					Font = {
						type = "select",
						name = L.Font,
						desc = L.Font_Desc,
						set = function(option, value)
							local conf
							BattleGroundEnemies.Enemies.bgSizeConfig = BattleGroundEnemies.Enemies.config[tostring(BattleGroundEnemies.BGSize)]
							conf = BattleGroundEnemies.Enemies.bgSizeConfig
							BattleGroundEnemies.Enemies.PlayerCount:SetFont(LSM:Fetch("font", value), conf.NumericTargetindicator_Fontsize, conf.NumericTargetindicator_Outline)

							
							BattleGroundEnemies.Allies.bgSizeConfig = BattleGroundEnemies.Allies.config[tostring(BattleGroundEnemies.BGSize)]
							conf = BattleGroundEnemies.Allies.bgSizeConfig
							BattleGroundEnemies.Allies.PlayerCount:SetFont(LSM:Fetch("font", value), conf.NumericTargetindicator_Fontsize, conf.NumericTargetindicator_Outline)

							for number, playerType in pairs({BattleGroundEnemies.Allies, BattleGroundEnemies.Enemies}) do
								for playerName, playerButton in pairs (playerType.Players) do
									applyMainfont(playerButton, value)
								end
								for playerName, playerButton in pairs (playerType.InactivePlayerButtons) do
									applyMainfont(playerButton, value)
								end
							end
							setOption(option, value)
						end,
						dialogControl = "LSM30_Font",
						values = AceGUIWidgetLSMlists.font,
						order = 4
					},
					MyTarget_Color = {
						type = "color",
						name = L.MyTarget_Color,
						desc = L.MyTarget_Color_Desc,
						set = function(option, ...)
							local color = {...} 
							ApplySettingToEnemiesAndAllies(option, color, nil, nil, "MyTarget", nil, nil, "SetBackdropBorderColor", ...)
						end,
						hasAlpha = true,
						order = 7
					},
					MyFocus_Color = {
						type = "color",
						name = L.MyFocus_Color,
						desc = L.MyFocus_Color_Desc,
						set = function(option, ...)
							local color = {...} 
							ApplySettingToEnemiesAndAllies(option, color, nil, nil, "MyFocus", nil, nil, "SetBackdropBorderColor", ...)
						end,
						hasAlpha = true,
						order = 8
					},
					Highlight_Color = {
						type = "color",
						name = L.Highlight_Color,
						desc = L.Highlight_Color_Desc,
						set = function(option, ...)
							local color = {...} 
							ApplySettingToEnemiesAndAllies(option, color, nil, nil, "SelectionHighlight", nil, nil, "SetColorTexture", ...)
						end,
						hasAlpha = true,
						order = 9
					}
				}
			},
			EnemySettings = {
				type = "group",
				name = L.Enemies,
				childGroups = "tab",
				order = 4,
				args = addEnemyAndAllySettings(self.Enemies)
			},
			AllySettings = {
				type = "group",
				name = L.Allies,
				childGroups = "tab",
				order = 5,
				args = addEnemyAndAllySettings(self.Allies)
			}
		}
	}
	AceConfigRegistry:RegisterOptionsTable("BattleGroundEnemies", self.options)
		
	AceConfigDialog:SetDefaultSize("BattleGroundEnemies", 709, 532)
	
	--profiles
	self.options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.options.args.profiles.order = -1
	self.options.args.profiles.disabled = InCombatLockdown
	
	AceConfigDialog:AddToBlizOptions("BattleGroundEnemies", "BattleGroundEnemies")
end

SLASH_BattleGroundEnemies1, SLASH_BattleGroundEnemies2, SLASH_BattleGroundEnemies3 = "/BattleGroundEnemies", "/bge", "/BattleGroundEnemies"
SlashCmdList["BattleGroundEnemies"] = function(msg)
	AceConfigDialog:Open("BattleGroundEnemies")
end
