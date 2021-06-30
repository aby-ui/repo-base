local AceLocale = LibStub ("AceLocale-3.0")
local Loc = AceLocale:GetLocale ("Details")
local SharedMedia = LibStub:GetLibrary ("LibSharedMedia-3.0")
local DF = _G.DetailsFramework

---------------------------------------------------------------------------------------------

--varios debuffs tao doido com monk
--ignorar bloodlust, shield d priest
--reler os tanks ao sair de um grupo

local _GetTime = GetTime --> wow api local
local _UFC = UnitAffectingCombat --> wow api local
local _IsInRaid = IsInRaid --> wow api local
local _IsInGroup = IsInGroup --> wow api local
local _UnitName = UnitName --> wow api local
local _UnitGroupRolesAssigned = DetailsFramework.UnitGroupRolesAssigned
local _UnitHealth = UnitHealth --> wow api local
local _UnitHealthMax = UnitHealthMax --> wow api local
local _UnitIsPlayer = UnitIsPlayer --> wow api local
local _UnitClass = UnitClass --> wow api local
local _UnitDebuff = UnitDebuff --> wow api local
local UnitGetIncomingHeals = UnitGetIncomingHeals
local _unpack = unpack
local UnitGetTotalAbsorbs = UnitGetTotalAbsorbs
---------------------------------------------------------------------------------------------

local DB_ANIMATION_TIME_DILATATION = 0.515321
local CONST_DEBUFF_AMOUNT = 5
local CONST_MAX_TANKS = 2

local _cstr = string.format --> lua library local
local _table_insert = table.insert --> lua library local
local _table_remove = table.remove --> lua library local
local _ipairs = ipairs --> lua library local
local _pairs = pairs --> lua library local
local _math_floor = math.floor --> lua library local
local _math_abs = math.abs --> lua library local
local _math_min = math.min --> lua library local
local _table_sort = table.sort

local ignored_debuffs = {
	[80354] = true, --temporal displacement
	[57724] = true, --sated
	[6788] = true, --weakened soul
	[124275] = true, --light stagger
	[124274] = true, --moderate stagger
}

---------------------------------------------------------------------------------------------

--> Create plugin Object
local Vanguard = _detalhes:NewPluginObject ("Details_Vanguard")
--> Main Frame
local VanguardFrame = Vanguard.Frame

local onUpdateFrame = CreateFrame("frame")

Vanguard:SetPluginDescription ("Show debuffs on each tanks in the raid, also shows incoming heal and damage and the last hits you took.")

Vanguard.auraUpdateFrames = {}
for i = 1, CONST_MAX_TANKS do
	local auraUpdateFrame = CreateFrame("frame", nil, UIParent)
	Vanguard.auraUpdateFrames[#Vanguard.auraUpdateFrames+1] = auraUpdateFrame
end

local function CreatePluginFrames (data)

	--> localize details functions
	Vanguard.GetSpec = Vanguard.GetSpec
	Vanguard.class_specs_coords = Vanguard.class_specs_coords
	
	local framework = Vanguard:GetFramework()
	
	--> OnDetailsEvent Parser
	function Vanguard:OnDetailsEvent (event, ...)
	
		if (event == "HIDE") then --> plugin hidded, disabled
			VanguardFrame:UnregisterEvent ("ROLE_CHANGED_INFORM")
			VanguardFrame:UnregisterEvent ("GROUP_ROSTER_UPDATE")
			VanguardFrame:UnregisterEvent ("PLAYER_TARGET_CHANGED")
			Vanguard:CombatEnd()
			
		elseif (event == "SHOW") then --> plugin shown, enabled
		
			if (not Vanguard.db.first_run) then
				Vanguard.db.first_run = true
				
				local welcome = CreateFrame ("frame", nil, UIParent, "BackdropTemplate")
				welcome:SetFrameStrata ("TOOLTIP")
				welcome:SetPoint ("center", UIParent, "center")
				welcome:SetSize (400, 200)
				DF:ApplyStandardBackdrop(welcome)
				
				local str = _detalhes.gump:CreateLabel (welcome, "Welcome to Vanguard!\n\n\n- The green-left bar represents the incoming healing plus absorbs on the tank.\n\n- The red-right show the incoming damage.\n\n- Tanks health bar and debuffs on them are shown in the bottom side.\n\n- Click anywhere to show options.", nil, nil, "GameFontNormal")
				str:SetPoint (15, -15)
				str:SetWidth (375)
				
				local close_button = _detalhes.gump:CreateButton (welcome, function() welcome:Hide() end, 120, 20, "Close")
				close_button:SetTemplate(_detalhes.gump:GetTemplate ("button", "DETAILS_PLUGINPANEL_BUTTON_TEMPLATE"))
				close_button:SetPoint ("center", welcome, "center")
				close_button:SetPoint ("bottom", welcome, "bottom", 0, 10)
				
			end
		
			Vanguard.CurrentInstance = Vanguard:GetInstance (Vanguard.instance_id)
			
			VanguardFrame:RegisterEvent ("ROLE_CHANGED_INFORM")
			VanguardFrame:RegisterEvent ("GROUP_ROSTER_UPDATE")
			VanguardFrame:RegisterEvent ("PLAYER_TARGET_CHANGED")
			
			Vanguard:ResetBars()
			
			Vanguard:IdentifyTanks()
			Vanguard.CurrentCombat = _detalhes:GetCombat ("current")

			VanguardFrame:SetFrameStrata (Vanguard.CurrentInstance.baseframe:GetFrameStrata())
			VanguardFrame:SetFrameLevel (Vanguard.CurrentInstance.baseframe:GetFrameLevel()+5)
			
			if (Vanguard:IsInCombat()) then
				Vanguard:CombatStart()
			end
			
			VanguardFrame:SetPoint ("topleft", Vanguard.CurrentInstance.baseframe, "topleft")
			VanguardFrame:SetPoint ("bottomright", Vanguard.CurrentInstance.baseframe, "bottomright")

		elseif (event == "COMBAT_PLAYER_ENTER") then --> a new combat has been started
		
			Vanguard.CurrentInstance = Vanguard:GetInstance (Vanguard.instance_id)
			Vanguard.CurrentCombat = select (1, ...)
			Vanguard.Running = true
			
			Vanguard:CombatStart()
			
		elseif (event == "COMBAT_PLAYER_LEAVE") then --> current combat has finished
		
			Vanguard.CurrentCombat = select (1, ...)
			
			Vanguard:CombatEnd()
			Vanguard:ResetBars()
			--Vanguard:ResetBlocks()
			
		elseif (event == "GROUP_ONLEAVE") then
		
			if (Vanguard.Running) then
				Vanguard:CombatEnd()
				Vanguard:ResetBars()
				Vanguard:ResetBlocks()
			end
			
			Vanguard:IdentifyTanks()
			
		elseif (event == "DETAILS_STARTED") then

			Vanguard.CurrentInstance = Vanguard:GetInstance (Vanguard.instance_id)
			Vanguard.CurrentCombat = Vanguard:GetCurrentCombat()

		elseif (event == "DETAILS_INSTANCE_ENDRESIZE" or event == "DETAILS_INSTANCE_SIZECHANGED") then
			--Vanguard:OnResize()
		
		elseif (event == "PLUGIN_DISABLED") then
		
		elseif (event == "PLUGIN_ENABLED") then
		
		elseif (event == "DETAILS_OPTIONS_MODIFIED") then
			Vanguard.RefreshWidgets()
		end
	end
	
	--> list with tank names
	Vanguard.TankList = {} --> tanks
	Vanguard.TankHashNames = {} --> tanks
	Vanguard.TankBlocks = {} --> tank frames
	Vanguard.TankIncDamage = {} --> tank damage taken from last 5 seconds
	Vanguard.UnitIdCache = {}
	
	--> search for tanks in the raid or party group 
	function Vanguard:IdentifyTanks()
	
		table.wipe (Vanguard.TankList)
		table.wipe (Vanguard.TankHashNames)
		table.wipe (Vanguard.TankIncDamage)
		table.wipe (Vanguard.UnitIdCache)

		for i = 1, CONST_MAX_TANKS do 
			Vanguard.auraUpdateFrames[i]:UnregisterEvent("UNIT_AURA")
		end

		--Vanguard.auraUpdateFrame:UnregisterEvent("UNIT_AURA")
		
		if (IsInRaid()) then
			for i = 1, GetNumGroupMembers(), 1 do
				local role = _UnitGroupRolesAssigned ("raid" .. i)
				if (role == "TANK") then
					local name, realm = UnitName ("raid"..i)
					if (realm) then
						name = name .. "-" .. realm
					end
					
					if (not Vanguard.TankHashNames [name]) then
						Vanguard.TankList [#Vanguard.TankList+1] = name
						Vanguard.TankHashNames [name] = #Vanguard.TankList
						Vanguard.TankIncDamage [name] = {}
						Vanguard.auraUpdateFrames[#Vanguard.TankList]:RegisterUnitEvent("UNIT_AURA", "raid" .. i)
						Vanguard.UnitIdCache[name] = "raid" .. i
					end
				end
			end

		elseif (IsInGroup()) then
		
			for i = 1, GetNumGroupMembers()-1, 1 do
				local role = _UnitGroupRolesAssigned ("party"..i)
				if (role == "TANK") then
					local name, realm = UnitName ("party"..i)
					if (realm) then
						name = name .. "-" .. realm
					end
					
					if (not Vanguard.TankHashNames [name]) then
						Vanguard.TankList [#Vanguard.TankList+1] = name
						Vanguard.TankHashNames [name] = #Vanguard.TankList
						Vanguard.TankIncDamage [name] = {}
						Vanguard.auraUpdateFrames[#Vanguard.TankList]:RegisterUnitEvent("UNIT_AURA", "party" .. i)
						Vanguard.UnitIdCache[name] = "party" .. i
					end
				end
			end
			
			local role = _UnitGroupRolesAssigned ("player")
			if (role == "TANK") then
				local name, realm = UnitName ("player")
				if (realm) then
					name = name .. "-" .. realm
				end
				
				if (not Vanguard.TankHashNames [name]) then
					Vanguard.TankList [#Vanguard.TankList+1] = name
					Vanguard.TankHashNames [name] = #Vanguard.TankList
					Vanguard.TankIncDamage [name] = {}
					Vanguard.auraUpdateFrames[#Vanguard.TankList]:RegisterUnitEvent("UNIT_AURA", "player")
					Vanguard.UnitIdCache[name] = "player"
				end
			end
		
		else
			local name, realm = UnitName ("player")
			if (realm) then
				name = name .. "-" .. realm
			end
			
			if (not Vanguard.TankHashNames [name]) then
				Vanguard.TankList [#Vanguard.TankList+1] = name
				Vanguard.TankHashNames [name] = #Vanguard.TankList
				Vanguard.TankIncDamage [name] = {}
				Vanguard.auraUpdateFrames[#Vanguard.TankList]:RegisterUnitEvent("UNIT_AURA", "player")
				Vanguard.UnitIdCache[name] = "player"
			end
		end
		
		Vanguard:RefreshTanks()
		
	end
	
	function Vanguard:ResetBars()
	
		if (Vanguard.db.show_inc_bars) then
			for i, tankblock in ipairs (Vanguard.TankBlocks) do
				local bar = tankblock.heal_inc
				bar:SetSplit (50)
				bar:SetLeftText (tankblock.tankname_string)
				bar:SetRightText ("")
				bar:SetRightColor (.25, 0, 0, 1)
				bar:SetLeftColor (0, .25, 0, 1)
				bar:SetHeight(Vanguard.db.bar_height)
				bar:SetTexture(SharedMedia:Fetch ("statusbar", Vanguard.db.tank_block_texture))
				bar.div:SetHeight(Vanguard.db.bar_height*2)
				bar.div:SetAlpha(0.79)
				bar:Show()
			end
		else
			for i, tankblock in ipairs (Vanguard.TankBlocks) do
				local bar = tankblock.heal_inc
				bar:Hide()
			end
		end
	end
	
	function Vanguard:ResetBlocks()
		for i, tblock in ipairs (Vanguard.TankBlocks) do
			local _, maxValue = tblock.unitFrame.healthBar:GetMinMaxValues()
			tblock.unitFrame.healthBar:SetValue(maxValue)

			tblock.debuffs_using = 0
			tblock.debuffs_next_index = 1
			
			for i = 1, CONST_DEBUFF_AMOUNT do
				local dblock = tblock.debuffs_blocks [i]
				dblock.texture:SetTexture (nil)
				dblock.stack:SetText ("")
				dblock.stack_bg:Hide()
				dblock:SetCooldown (0, 0, 0, 0)
				dblock.in_use = nil
				dblock.support.spellid = nil
			end
		end
	end
	
	local SetTank = function (self, index)
		local name = Vanguard.TankList [index]
		self.tankname:SetText (Vanguard:GetOnlyName (name))
		self.tankname_string = name
		
		local bar = self.heal_inc
		bar.tankname = name
		
		local class, left, right, top, bottom, r, g, b = Vanguard:GetClass (name)
		
		local spec = Vanguard:GetSpec (name)
		
		if (spec) then
			self.specicon:SetTexture (Vanguard.CurrentInstance.row_info.spec_file)
			self.specicon:SetTexCoord (_unpack (Vanguard.class_specs_coords [spec]))
		else
			self.specicon:SetTexture (Vanguard.CurrentInstance.row_info.icon_file)
			self.specicon:SetTexCoord (left, right, top, bottom)
		end
		
		self.unitFrame:SetUnit(Vanguard.UnitIdCache[name])
		self.unitFrame.healthBar:SetUnit(Vanguard.UnitIdCache[name])
		self.unitFrame.castBar:SetUnit(Vanguard.UnitIdCache[name])
		self.unitFrame.powerBar:SetUnit(Vanguard.UnitIdCache[name])
		self.unitFrame.healthBar:SetColor(r, g, b)
		
		bar.lefticon = Vanguard.CurrentInstance.row_info.icon_file
		bar.iconleft:SetTexCoord (left, right, top, bottom)
		bar:SetLeftText (Vanguard:GetOnlyName (name))
		bar:SetLeftText (name)
		
		local width = Vanguard.db.tank_block_size
		self:SetWidth (width)
		self:SetBackdropColor (unpack (Vanguard.db.tank_block_color))
		self.unitFrame.healthBar.background:SetColorTexture(unpack (Vanguard.db.tank_block_color))
		self.unitFrame.healthBar.Settings.BackgroundColor = Vanguard.db.tank_block_color

		--texture
		self.unitFrame.healthBar:SetTexture (SharedMedia:Fetch("statusbar", Vanguard.db.tank_block_texture))
		self.unitFrame.powerBar:SetTexture (SharedMedia:Fetch("statusbar", Vanguard.db.tank_block_texture))
		self.unitFrame.castBar:SetTexture (SharedMedia:Fetch("statusbar", Vanguard.db.tank_block_texture))
	end
	
	local debuff_on_enter = function (self)
		if (self.spellid) then
			--self.texture:SetBlendMode ("ADD")
			GameTooltip:SetOwner (self, "ANCHOR_TOPLEFT")
			GameTooltip:SetSpellByID (self.spellid)
			GameTooltip:Show()
		end
	end
	local debuff_on_leave = function (self)
		--self.texture:SetBlendMode ("BLEND")
		if (self.spellid) then
			GameTooltip:Hide()
		end
	end

	local on_click = function (self, button)
		if (button == "LeftButton") then
			Vanguard.OpenOptionsPanel()
			
		elseif (button == "RightButton") then
			local instance = Vanguard:GetPluginInstance()
			if (instance) then
				_detalhes.switch:ShowMe (instance)
			end
		end
	end
	
	function Vanguard:CreateTankBlock (index)
		--frame
		
		local f = CreateFrame ("button", "VanguardTankBlock" .. index, VanguardFrame, "BackdropTemplate")
		f.SetTank = SetTank
		f:SetSize (Vanguard.db.tank_block_size, Vanguard.db.tank_block_size_height)
		
		f:SetScript ("OnMouseUp", on_click)
		
		if (index == 1) then
			f:SetPoint ("bottomleft", VanguardFrame, "bottomleft", 0 + ((index-1) * 155), 0)
		else
			f:SetPoint ("left", Vanguard.TankBlocks [index-1], "right", 5, 0)
		end
		
		f:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0}, edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1})
		f:SetBackdropColor (unpack (Vanguard.db.tank_block_color))
		f:SetBackdropBorderColor (0, 0, 0, 1)
		
		--debuff icons
		f.debufficons = {}

		--tank health bar
			local unitFrameSettingsOverride = {
				ShowPowerBar = true,
				ShowCastBar = true,
				ShowBorder = false, 
				CanModifyHealhBarColor = false,
				ShowTargetOverlay = false,
				ShowUnitName = false,
				ClearUnitOnHide = false,
			}
			
			local healthBarSettingsOverride = {
				ShowHealingPrediction = not DetailsFramework.IsTBCWow(),
				ShowShields = not DetailsFramework.IsTBCWow(),
			}
			
			local castBarSettingsOverride = {
				FadeInTime = 0.01,
				FadeOutTime = 0.40,
				SparkHeight = 16,
				LazyUpdateCooldown = 0.1,
			}
			
			local powerBarSettingsOverride = {
				ShowAlternatePower = false,
			}

			f.unitFrame = DetailsFramework:CreateUnitFrame(f, "VanguardTankUnitFrame" .. index, unitFrameSettingsOverride, healthBarSettingsOverride, castBarSettingsOverride, powerBarSettingsOverride)
			f.unitFrame:SetPoint ("topleft", f, "topleft", 1, -1)
			f.unitFrame:SetPoint ("bottomright", f, "bottomright", -1, 1)
			--spec icon
			f.specicon = f.unitFrame.healthBar:CreateTexture(nil, "overlay")
			f.specicon:SetPoint ("topleft", f.unitFrame.healthBar, "topleft", 5, -5)
			f.specicon:SetSize (14, 14)
			--tank name
			f.tankname = f.unitFrame.healthBar:CreateFontString(nil, "overlay", "GameFontNormal")
			f.tankname:SetPoint ("left", f.specicon, "right", 2, 1)

			f.unitFrame.castBar:SetTexture (SharedMedia:Fetch("statusbar", Vanguard.db.tank_block_texture))
			f.unitFrame.healthBar:SetTexture (SharedMedia:Fetch("statusbar", Vanguard.db.tank_block_texture))
			f.unitFrame.powerBar:SetTexture (SharedMedia:Fetch("statusbar", Vanguard.db.tank_block_texture))

			f.unitFrame.powerBar.background:SetColorTexture(0, 0, 0, 1)
			f.unitFrame.powerBar.background:SetVertexColor(0, 0, 0, 1)

		--inc heals inc damage
			f.heal_inc = DF:CreateSplitBar(f, 294, Vanguard.db.bar_height)
			f.heal_inc:SetSize(294, Vanguard.db.bar_height)
			f.heal_inc:SetPoint ("topleft", VanguardFrame, "topleft", 0, ((index - 1) * -Vanguard.db.bar_height))
			f.heal_inc:SetPoint ("topright", VanguardFrame, "topright", 0, ((index - 1) * -Vanguard.db.bar_height))
			f.heal_inc.fontsize = 10
			f.heal_inc:SetTexture(SharedMedia:Fetch ("statusbar", Vanguard.db.tank_block_texture))
			f.heal_inc:EnableAnimations()

			f.heal_inc:SetScript ("OnMouseUp", on_click)

			--debuffs blocks
			f.debuffs_blocks = {}
			f.debuffs_using = 0
			f.debuffs_next_index = 1
		
			for i = 1, CONST_DEBUFF_AMOUNT do
				local support_frame = CreateFrame ("frame", "VanguardSupportFrame_"..index.."_"..i, f.unitFrame, "BackdropTemplate")
				support_frame:SetFrameLevel (f.unitFrame:GetFrameLevel()+10)
				support_frame:SetSize (24, 24)
				support_frame:SetScript ("OnMouseUp", on_click)
				
				--icon texture
				local texture = support_frame:CreateTexture (support_frame:GetName() .. "_Texture", "overlay")
				texture:SetSize (24, 24)
				texture:SetPoint("center", support_frame, "center", 0, 0)
				
				local y = 3				
				local xOffSet = (i-1) * (texture:GetWidth() + 1)
				support_frame.offset = xOffSet
				support_frame:SetPoint ("left", f, "left", 5 + xOffSet, -8)
				
				local dblock = CreateFrame ("cooldown", "VanguardTankDebuffCooldown" .. index.. "_" .. i, support_frame, "CooldownFrameTemplate, BackdropTemplate")
				dblock:SetAlpha (0.7)
				dblock:SetPoint ("topleft", texture, "topleft")
				dblock:SetPoint ("bottomright", texture, "bottomright")

				--scripts
				dblock:SetScript ("OnMouseUp", on_click)
				dblock:SetScript ("OnEnter", debuff_on_enter)
				dblock:SetScript ("OnLeave", debuff_on_leave)

				dblock.texture = texture

				dblock:SetHideCountdownNumbers(true)

				local elevateStringsFrame = CreateFrame("frame", support_frame:GetName() .. "_ElevateFrame", support_frame)
				elevateStringsFrame:SetAllPoints()
				elevateStringsFrame:SetFrameLevel(dblock:GetFrameLevel()+10)
				elevateStringsFrame:EnableMouse(false)

				local stack = elevateStringsFrame:CreateFontString (elevateStringsFrame:GetName() .. "_StackText", "overlay", "GameFontNormal")
				stack:SetPoint ("bottomright", dblock, "bottomright", 0, 0)
				DetailsFramework:SetFontColor(stack, "yellow")

				local stack_bg = elevateStringsFrame:CreateTexture (elevateStringsFrame:GetName() .. "_StackBG", "artwork")
				stack_bg:SetColorTexture(0, 0, 0, 1)
				stack_bg:SetPoint ("center", stack, "center", 0, 0)
				stack_bg:SetSize(10, 10)
				stack_bg:Hide()

				dblock.Timer = dblock:CreateFontString(dblock:GetName() .. "_Timer", "overlay", "NumberFontNormal")
				dblock.Timer:SetPoint("center")

				dblock.stack = stack
				dblock.stack_bg = stack_bg
				dblock.support = support_frame
				dblock.elevate_frame = elevateStringsFrame

				f.debuffs_blocks [i] = dblock
			end

		Vanguard.TankBlocks [index] = f
		Vanguard:ResetBars()
		return f
	end

	function Vanguard:RefreshTanks()
		Vanguard:ResetBlocks()

		for i = 1, #Vanguard.TankList do
			local block = Vanguard.TankBlocks [i]
			if (not block) then
				block = Vanguard:CreateTankBlock (i)
			end

			block:SetTank(i)
			block:SetSize(Vanguard.db.tank_block_size, Vanguard.db.tank_block_size_height)
		end
		
		if (Vanguard.Running) then
			Vanguard:CombatEnd()
			Vanguard:CombatStart()
		end

		Vanguard.RefreshWidgets()
	end

	function Vanguard.RefreshWidgets()

		local hostInstance = Vanguard:GetInstance(Vanguard.instance_id)
		local isClickThrough = hostInstance.clickthrough_window
		local isClickThrough_InCombat = hostInstance.clickthrough_incombatonly

		for i, f in pairs(Vanguard.TankBlocks) do
			for debuffBlockId = 1, CONST_DEBUFF_AMOUNT do
				local debuffBlock = f.debuffs_blocks[debuffBlockId]
				DetailsFramework:SetFontSize(debuffBlock.Timer, Vanguard.db.aura_timer_text_size)
				debuffBlock.support:SetPoint ("left", f, "left", 5 + debuffBlock.support.offset, -8 + Vanguard.db.aura_offset_y)
			end

			if (isClickThrough) then
				if (isClickThrough_InCombat) then
					if (InCombatLockdown()) then
						f:EnableMouse(false)
						f.unitFrame:EnableMouse(false)
						f.unitFrame.healthBar:EnableMouse(false)
						f.unitFrame.powerBar:EnableMouse(false)
						f.unitFrame.castBar:EnableMouse(false)
						for debuffBlockId = 1, CONST_DEBUFF_AMOUNT do
							local debuffBlock = f.debuffs_blocks[debuffBlockId]
							debuffBlock:EnableMouse(false)
							debuffBlock.support:EnableMouse(false)
							--debuffBlock.elevate_frame:EnableMouse(false)
						end
						f.heal_inc:EnableMouse(false)
					else
						f:EnableMouse(true)
						f.unitFrame:EnableMouse(true)
						f.unitFrame.healthBar:EnableMouse(true)
						f.unitFrame.powerBar:EnableMouse(true)
						f.unitFrame.castBar:EnableMouse(true)
						for debuffBlockId = 1, CONST_DEBUFF_AMOUNT do
							local debuffBlock = f.debuffs_blocks[debuffBlockId]
							debuffBlock:EnableMouse(true)
							debuffBlock.support:EnableMouse(true)
							--debuffBlock.elevate_frame:EnableMouse(true)
							debuffBlock:SetScript("OnMouseUp", on_click)
						end
						f.heal_inc:EnableMouse(true)
					end
				else
					f:EnableMouse(false)
					f.unitFrame:EnableMouse(false)
					f.unitFrame.healthBar:EnableMouse(false)
					f.unitFrame.powerBar:EnableMouse(false)
					f.unitFrame.castBar:EnableMouse(false)
					for debuffBlockId = 1, CONST_DEBUFF_AMOUNT do
						local debuffBlock = f.debuffs_blocks[debuffBlockId]
						debuffBlock:EnableMouse(false)
						debuffBlock.support:EnableMouse(false)
						--debuffBlock.elevate_frame:EnableMouse(false)
					end
					f.heal_inc:EnableMouse(false)
				end
			else
				f:EnableMouse(true)
				f.unitFrame:EnableMouse(true)
				f.unitFrame.healthBar:EnableMouse(true)
				f.unitFrame.powerBar:EnableMouse(true)
				f.unitFrame.castBar:EnableMouse(true)
				for debuffBlockId = 1, CONST_DEBUFF_AMOUNT do
					local debuffBlock = f.debuffs_blocks[debuffBlockId]
					debuffBlock:EnableMouse(true)
					debuffBlock.support:EnableMouse(true)
					--debuffBlock.elevate_frame:EnableMouse(true)
					debuffBlock:SetScript("OnMouseUp", on_click)
				end
				f.heal_inc:EnableMouse(true)
			end

			--texture
			f.unitFrame.healthBar:SetTexture(SharedMedia:Fetch("statusbar", Vanguard.db.tank_block_texture))
			f.unitFrame.powerBar:SetTexture(SharedMedia:Fetch("statusbar", Vanguard.db.tank_block_texture))
			f.unitFrame.castBar:SetTexture(SharedMedia:Fetch("statusbar", Vanguard.db.tank_block_texture))

			f.unitFrame.powerBar:ClearAllPoints()
			f.unitFrame.healthBar:ClearAllPoints()
			f.unitFrame.castBar:ClearAllPoints()

			if (not Vanguard.db.show_health_bar and not Vanguard.db.show_cast_bar and not Vanguard.db.show_power_bar) then
				f.unitFrame:Hide()
				f.Center:Hide()
				f:SetBackdropBorderColor (0, 0, 0, 0)
				return
			end

			f.unitFrame:Show()
			f.unitFrame.healthBar:Show()
			f.Center:Show()
			f:SetBackdropBorderColor (0, 0, 0, 1)

			f.unitFrame.healthBar:SetPoint("topleft", f, "topleft", 0, 0)
			f.unitFrame.healthBar:SetPoint("topright", f, "topright", 0, 0)
			f.unitFrame.healthBar:SetPoint("bottomleft", f, "bottomleft", 0, 0)
			f.unitFrame.healthBar:SetPoint("bottomright", f, "bottomright", 0, 0)

			if (Vanguard.db.show_cast_bar) then
				f.unitFrame.castBar:Show()
				f.unitFrame.castBar:SetHeight(Vanguard.db.tank_block_castbar_size_height)

				if (Vanguard.db.show_health_bar) then
					if (Vanguard.db.show_power_bar) then
						f.unitFrame.castBar:SetPoint("bottomleft", f, "bottomleft", 0, Vanguard.db.tank_block_powerbar_size_height)
						f.unitFrame.castBar:SetPoint("bottomright", f, "bottomright", 0, Vanguard.db.tank_block_powerbar_size_height)
					else
						f.unitFrame.castBar:SetPoint("bottomleft", f, "bottomleft", 0, 0)
						f.unitFrame.castBar:SetPoint("bottomright", f, "bottomright", 0, 0)
					end
				else
					f.unitFrame.castBar:SetPoint("topleft", f, "topleft", 0, 0)
					f.unitFrame.castBar:SetPoint("topright", f, "topright", 0, 0)
				end
			end

			f.unitFrame.castBar:Hide()

			if (Vanguard.db.show_power_bar) then
				f.unitFrame.powerBar:Show()
				f.unitFrame.powerBar:SetHeight(Vanguard.db.tank_block_powerbar_size_height)
				f.unitFrame.powerBar:SetPoint("bottomleft", f, "bottomleft", 0, 0)
				f.unitFrame.powerBar:SetPoint("bottomright", f, "bottomright", 0, 0)
			else
				f.unitFrame.powerBar:Hide()
			end

		end
	end

	function Vanguard.AnimateLeftWithAccel(self, deltaTime)
		local distance = (self.AnimationStart - self.AnimationEnd) / self.CurrentHealthMax * 100	--scale 1 - 100
		local minTravel = min (distance / 10, 3) -- 10 = trigger distance to max speed 3 = speed scale on max travel
		local maxTravel = max (minTravel, 0.45) -- 0.45 = min scale speed on low travel speed
		local calcAnimationSpeed = (self.CurrentHealthMax * (deltaTime * DB_ANIMATION_TIME_DILATATION)) * maxTravel --re-scale back to unit health, scale with delta time and scale with the travel speed
		
		self.AnimationStart = self.AnimationStart - (calcAnimationSpeed)
		self:SetSplit (self.AnimationStart)
		self.CurrentHealth = self.AnimationStart
		
		if (self.Spark) then
			self.Spark:SetPoint ("center", self, "left", self.AnimationStart / self.CurrentHealthMax * self:GetWidth(), 0)
			self.Spark:Show()
		end
		
		if (self.AnimationStart-1 <= self.AnimationEnd) then
			self:SetSplit (self.AnimationEnd)
			self.CurrentHealth = self.AnimationEnd
			self.IsAnimating = false
			if (self.Spark) then
				self.Spark:Hide()
			end
		end
	end

	function Vanguard.AnimateRightWithAccel(self, deltaTime)
		local distance = (self.AnimationEnd - self.AnimationStart) / self.CurrentHealthMax * 100	--scale 1 - 100 basis
		local minTravel = math.min (distance / 10, 3) -- 10 = trigger distance to max speed 3 = speed scale on max travel
		local maxTravel = math.max (minTravel, 0.45) -- 0.45 = min scale speed on low travel speed
		local calcAnimationSpeed = (self.CurrentHealthMax * (deltaTime * DB_ANIMATION_TIME_DILATATION)) * maxTravel --re-scale back to unit health, scale with delta time and scale with the travel speed
		
		self.AnimationStart = self.AnimationStart + (calcAnimationSpeed)
		self:SetSplit (self.AnimationStart)
		self.CurrentHealth = self.AnimationStart
		
		if (self.AnimationStart+1 >= self.AnimationEnd) then
			self:SetSplit (self.AnimationEnd)
			self.CurrentHealth = self.AnimationEnd
			self.IsAnimating = false
		end
	end

	onUpdateFrame.onUpdate = function(self, deltaTime)
		--do healthbar animation ~animation ~healthbar
		for tank_name, block_index in pairs (Vanguard.TankHashNames) do
			local tframe = Vanguard.TankBlocks [block_index]
			local bar = tframe.heal_inc
			if (bar.IsAnimating) then
				bar.AnimateFunc(bar, deltaTime)
			end
		end
	end

	function Vanguard:TrackIncoming()
		
		for tank_name, block_index in pairs (Vanguard.TankHashNames) do
		
			local shields = UnitGetTotalAbsorbs and UnitGetTotalAbsorbs(tank_name) or 0
			local heals = UnitGetIncomingHeals and UnitGetIncomingHeals(tank_name) or 0
		
			local events_table = Vanguard.CurrentCombat.player_last_events [tank_name]
			local taken = 0
			local timeNow = time()

			if (events_table) then
				for _, event in ipairs (events_table) do
					if (event[1] and event[4]+5 > timeNow) then --damage event
						taken = taken + event [3]
					end
				end

				tinsert(Vanguard.TankIncDamage, 1, taken)
				tremove(Vanguard.TankIncDamage, 41)

				--taken = taken / 3.5
			end

			local tframe = Vanguard.TankBlocks [block_index]
				
			--split animation
			tframe.heal_inc:SetLeftText (Vanguard:ToK (shields + heals) .. " [|cFFFFFF55" .. Vanguard:ToK (shields) .. "|r]")
			tframe.heal_inc:SetRightText (Vanguard:ToK ( _math_floor (taken)))
			
			heals = heals + shields

			local oldValue = tframe.heal_inc:GetValue()
			local currentValue = 0
			
			if (taken > 0 and heals > 0) then
				if (taken > heals) then 
					local p = heals / taken * 100
					p = _math_abs (p - 100)

					p = p / 2
					p = p + 50
					p = _math_abs (p - 100)
					--tframe.heal_inc:SetSplit (p)
					currentValue = p
				else
					local p = taken / heals * 100
					p = _math_abs (p - 100)
					p = p / 2
					p = p + 50
					
					--tframe.heal_inc:SetSplit (p)
					currentValue = p
				end

			elseif (taken > 0) then
				--tframe.heal_inc:SetSplit (6)
				currentValue = 1

			elseif (heals > 0) then
				--tframe.heal_inc:SetSplit (94)
				currentValue = 99
			end

			--~animation
			tframe.heal_inc.oldValue = oldValue
			tframe.heal_inc.currentValue = currentValue--tframe.heal_inc:GetValue()
			
			tframe.heal_inc.CurrentHealthMax = 100
			tframe.heal_inc.AnimationStart = tframe.heal_inc.oldValue
			tframe.heal_inc.AnimationEnd = tframe.heal_inc.currentValue
			
			tframe.heal_inc.IsAnimating = true
			
			if (tframe.heal_inc.AnimationEnd > tframe.heal_inc.AnimationStart) then
				tframe.heal_inc.AnimateFunc = Vanguard.AnimateRightWithAccel
			else
				tframe.heal_inc.AnimateFunc = Vanguard.AnimateLeftWithAccel
			end

		
		end
	end
	
	function Vanguard:CombatStart()
		Vanguard.Running = true

		for i = 1, CONST_MAX_TANKS do
			Vanguard.auraUpdateFrames[i]:SetScript("OnEvent", Vanguard.AuraUpdate)
		end
		
		if (Vanguard.track_incoming) then
			Vanguard:CancelTimer (Vanguard.track_incoming)
		end

		Vanguard.track_incoming = Vanguard:ScheduleRepeatingTimer ("TrackIncoming", 0.1)
		onUpdateFrame:SetScript("OnUpdate", onUpdateFrame.onUpdate)

		Vanguard.RefreshWidgets()
	end
	
	function Vanguard:CombatEnd()
		Vanguard.Running = false

		for i = 1, CONST_MAX_TANKS do
			Vanguard.auraUpdateFrames[i]:SetScript("OnEvent", nil)
		end		
	
		if (Vanguard.track_incoming) then
			Vanguard:CancelTimer (Vanguard.track_incoming)
		end
	
		onUpdateFrame:SetScript("OnUpdate", nil)

		Vanguard.RefreshWidgets()
	end

	local formatTime = function(time)
		if (time >= 3600) then
			return floor (time / 3600) .. "h"
		elseif (time >= 60) then
			return floor (time / 60) .. "m"
		else
			return floor (time)
		end
	end

	function Vanguard.AuraUpdate(self, event, unit)
		local who_name = GetUnitName(unit, true)
		local tank_index = Vanguard.TankHashNames[who_name]

		if (tank_index) then
			local tframe = Vanguard.TankBlocks[tank_index]
			local debuffBlockId = 1

--			print("powerBar shown:", tframe.unitFrame.powerBar:GetPoint(1))
--			print("castBar shown:", tframe.unitFrame.castBar.unit)
--			print("healthBar shown:", tframe.unitFrame.healthBar:GetPoint(1))

			for i = 1, 40 do
				local name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer = _UnitDebuff(who_name, i)
				if (name and not ignored_debuffs[spellId]) then -- and not castByPlayer
					local dblock = tframe.debuffs_blocks[debuffBlockId]
					debuffBlockId = debuffBlockId + 1

					dblock.debuffName = name
					dblock.texture:SetTexture(icon)
					dblock.texture:SetTexCoord(.1, .9, .1, .9)
					dblock.spellid = spellId

					if (count and count > 1) then
						dblock.stack:SetText(count)
						dblock.stack:Show()
						dblock.stack_bg:Show()
					else
						dblock.stack:SetText("")
						dblock.stack_bg:Hide()
					end

					local timeLeft = expirationTime-GetTime()
					timeLeft = max(timeLeft, 0)
					timeLeft = min(timeLeft, 600)
					dblock.Timer:SetText(formatTime(timeLeft))
					dblock.Timer:Show()

					if ((timeLeft > 0 and timeLeft < 600) and (floor(expirationTime) ~= dblock.expirationAt or not dblock:IsShown())) then
						dblock:Show()
						dblock:SetCooldown(GetTime(), timeLeft, 0, 0)
						dblock.expirationAt = floor(expirationTime)
						dblock.expirationAtFloat = expirationTime
					else
						if ((timeLeft < 0 or timeLeft > 600)) then
							dblock:Hide()
						end
					end

					if (debuffBlockId == CONST_DEBUFF_AMOUNT+1) then
						break
					end
				else
					if (not name) then
						for o = debuffBlockId, CONST_DEBUFF_AMOUNT do
							local dblock = tframe.debuffs_blocks[o]
							dblock:Hide()
							dblock.texture:SetTexture(nil)
						end
						break
					end
				end
			end
		end
	end
end


local build_options_panel = function()
	local options_frame = Vanguard:CreatePluginOptionsFrame ("VanguardOptionsWindow", "Vanguard Options", 1)
	
	local tank_texture_set = function (_, _, value) 
		Vanguard.db.tank_block_texture = value;
		Vanguard:ResetBars()
		Vanguard:RefreshTanks()
	end
	
	local texture_icon = [[Interface\TARGETINGFRAME\UI-PhasingIcon]]
	local texture_icon = [[Interface\AddOns\Details\images\icons]]
	local texture_icon_size = {14, 14}
	local texture_texcoord = {469/512, 505/512, 249/512, 284/512}
	
	local textures = SharedMedia:HashTable ("statusbar")
	local texTable = {}
	for name, texturePath in pairs (textures) do 
		texTable[#texTable+1] = {value = name, label = name, iconsize = texture_icon_size, statusbar = texturePath, onclick = tank_texture_set, icon = texture_icon, texcoord = texture_texcoord}
	end
	table.sort (texTable, function (t1, t2) return t1.label < t2.label end)
	
	local tank_texture_menu = texTable

	--templates
	local options_text_template = DF:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE")
	local options_dropdown_template = DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
	local options_switch_template = DF:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE")
	local options_slider_template = DF:GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE")
	local options_button_template = DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")

	local menu = {
		{
			type = "select",
			get = function() return Vanguard.db.tank_block_texture end,
			values = function() return tank_texture_menu end,
			--desc = "Choose the texture used on tank blocks.",
			name = "Texture"
		},

		{type = "blank"},	

		{
			type = "toggle",
			get = function() return Vanguard.db.show_inc_bars end,
			set = function (self, fixedparam, value) Vanguard.db.show_inc_bars = value; Vanguard:ResetBars() end,
			--desc = "Shows the incoming heal vs incoming damage.",
			name = "Show Incoming Damage"
		},
		{
			type = "range",
			get = function() return Vanguard.db.bar_height end,
			set = function (self, fixedparam, value)
				Vanguard.db.bar_height = value
				Vanguard:ResetBars()
				Vanguard:RefreshTanks()
			end,
			min = 10,
			max = 50,
			step = 1,
			--desc = "Inc Damage Heigth",
			name = "Incoming Damage Heigth",
		},
		{type = "blank"},

		{
			type = "toggle",
			get = function() return Vanguard.db.show_health_bar end,
			set = function (self, fixedparam, value) Vanguard.db.show_health_bar = value; Vanguard:RefreshTanks(); Vanguard:ResetBars() end,
			name = "Show Health Bar"
		},
		{
			type = "toggle",
			get = function() return Vanguard.db.show_cast_bar end,
			set = function (self, fixedparam, value) Vanguard.db.show_cast_bar = value; Vanguard:RefreshTanks(); Vanguard:ResetBars() end,
			name = "Show Cast Bar"
		},
		{
			type = "toggle",
			get = function() return Vanguard.db.show_power_bar end,
			set = function (self, fixedparam, value) Vanguard.db.show_power_bar = value; Vanguard:RefreshTanks(); Vanguard:ResetBars() end,
			name = "Show Power Bar"
		},

		{
			type = "range",
			get = function() return Vanguard.db.tank_block_size end,
			set = function (self, fixedparam, value) Vanguard.db.tank_block_size = value; Vanguard:RefreshTanks() end,
			min = 70,
			max = 250,
			step = 1,
			--desc = "Set the width of the blocks showing the tanks.",
			name = "Health Bar Width",
		},
		{
			type = "range",
			get = function() return Vanguard.db.tank_block_size_height end,
			set = function (self, fixedparam, value) Vanguard.db.tank_block_size_height = value; Vanguard:RefreshTanks() end,
			min = 10,
			max = 100,
			step = 1,
			name = "Health Bar Height",
		},
		{
			type = "range",
			get = function() return Vanguard.db.tank_block_castbar_size_height end,
			set = function (self, fixedparam, value) Vanguard.db.tank_block_castbar_size_height = value; Vanguard:RefreshTanks() end,
			min = 10,
			max = 60,
			step = 1,
			name = "Cast Bar Height",
		},		
		{
			type = "range",
			get = function() return Vanguard.db.tank_block_powerbar_size_height end,
			set = function (self, fixedparam, value) Vanguard.db.tank_block_powerbar_size_height = value; Vanguard:RefreshTanks() end,
			min = 10,
			max = 60,
			step = 1,
			name = "Power Bar Height",
		},
		{
			type = "color",
			get = function() return Vanguard.db.tank_block_color end,
			set = function (self, r, g, b, a) 
				local current = Vanguard.db.tank_block_color;
				current[1], current[2], current[3], current[4] = r, g, b, a;
				Vanguard:RefreshTanks()
			end,
			--desc = "Select the color of the tank block background.",
			name = "Health Bar Background Color"
		},

		{type = "blank"},
		{
			type = "range",
			get = function() return Vanguard.db.aura_offset_y end,
			set = function (self, fixedparam, value) Vanguard.db.aura_offset_y = value; Vanguard.RefreshWidgets() end,
			min = -20,
			max = 20,
			step = 1,
			name = "Debuff Y Offset",
		},
		{
			type = "range",
			get = function() return Vanguard.db.aura_timer_text_size end,
			set = function (self, fixedparam, value) Vanguard.db.aura_timer_text_size = value; Vanguard.RefreshWidgets() end,
			min = 6,
			max = 24,
			step = 1,
			name = "Debuff Text Size",
		},
	}

	options_frame:SetSize(500, 400)
	Vanguard:GetFramework():BuildMenu (options_frame, menu, 15, -50, 460, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
end

Vanguard.OpenOptionsPanel = function()
	if (not VanguardOptionsWindow) then
		build_options_panel()
	end
	VanguardOptionsWindow:Show()
end

local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo



function Vanguard:OnEvent (_, event, arg1, token, time, who_serial, who_name, who_flags, _, alvo_serial, alvo_name, alvo_flags, _, spellid, spellname, spellschool, tipo)

	if (event == "ADDON_LOADED") then
		local AddonName = arg1
		if (AddonName == "Details_Vanguard") then
			
			if (_G._detalhes) then
			
				if (DetailsFramework.IsClassicWow()) then
					return
				end
				
				local MINIMAL_DETAILS_VERSION_REQUIRED = 1
				local default_saved_table = {
					show_inc_bars = true,
					tank_block_size = 150,
					tank_block_height = 40,
					tank_block_color = {0.074509, 0.035294, 0.035294, 0.832845},
					tank_block_texture = "Details Serenity",
					first_run = false,
					bar_height = 24,
					aura_timer_text_size = 14,
					aura_offset_y = 0,
					show_health_bar = true,
					show_power_bar = false,
					show_cast_bar = false,
					tank_block_size_height = 50,
					tank_block_castbar_size_height = 16,
					tank_block_powerbar_size_height = 10,
				}
				
				--> Install
				function Vanguard:OnDetailsEvent() end --> dummy func to stop warnings.
				
				local install, saveddata = _G._detalhes:InstallPlugin ("TANK", "Vanguard", "Interface\\Icons\\INV_Shield_04", Vanguard, "DETAILS_PLUGIN_VANGUARD", MINIMAL_DETAILS_VERSION_REQUIRED, "Terciob", "v3.0", default_saved_table)
				if (type (install) == "table" and install.error) then
					print (install.error)
				end

				--Vanguard.db.first_run = false --debug
				
				--> create widgets
				CreatePluginFrames()

				--> Register needed events
				_G._detalhes:RegisterEvent (Vanguard, "COMBAT_PLAYER_ENTER")
				_G._detalhes:RegisterEvent (Vanguard, "COMBAT_PLAYER_LEAVE")
				_G._detalhes:RegisterEvent (Vanguard, "DETAILS_INSTANCE_ENDRESIZE")
				_G._detalhes:RegisterEvent (Vanguard, "DETAILS_INSTANCE_SIZECHANGED")
				_G._detalhes:RegisterEvent (Vanguard, "GROUP_ONLEAVE")
				_G._detalhes:RegisterEvent (Vanguard, "DETAILS_OPTIONS_MODIFIED")
				
				VanguardFrame:RegisterEvent ("ZONE_CHANGED_NEW_AREA")
				VanguardFrame:RegisterEvent ("PLAYER_ENTERING_WORLD")
			end
		end
	
	elseif (event == "ROLE_CHANGED_INFORM" or event == "GROUP_ROSTER_UPDATE") then --> raid changes
		if (Vanguard.CurrentInstance) then
			Vanguard:IdentifyTanks()
		end
		
	elseif (event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD") then --> logon or map changes
		if (Vanguard.CurrentInstance) then
			Vanguard:IdentifyTanks()
		end

	end
end
