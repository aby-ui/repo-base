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


local _cstr = string.format --> lua library local
local _table_insert = table.insert --> lua library local
local _table_remove = table.remove --> lua library local
local _ipairs = ipairs --> lua library local
local _pairs = pairs --> lua library local
local _math_floor = math.floor --> lua library local
local _math_abs = math.abs --> lua library local
local _math_min = math.min --> lua library local
local _table_sort = table.sort

---------------------------------------------------------------------------------------------

--> Create plugin Object
local Vanguard = _detalhes:NewPluginObject ("Details_Vanguard")
--> Main Frame
local VanguardFrame = Vanguard.Frame

local onUpdateFrame = CreateFrame("frame")

Vanguard:SetPluginDescription ("Show debuffs on each tanks in the raid, also shows incoming heal and damage and the last hits you took.")


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
				welcome:SetSize (400, 175)
				--welcome:SetBackdrop ({edgeFile = "Interface\\Buttons\\UI-SliderBar-Border", edgeSize = 8,
				--bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 130, insets = {left = 1, right = 1, top = 5, bottom = 5}})
				DF:ApplyStandardBackdrop(welcome)
				
				local str = _detalhes.gump:CreateLabel (welcome, "Welcome to Vanguard!\n\n\n- The green-left bar represents the incoming healing plus absorbs on the tank.\n\n- The red-right show the incoming damage.\n\n- Click anywhere to show options.", nil, nil, "GameFontNormal")
				str:SetPoint (15, -15)
				str:SetWidth (375)
				
				local close_button = _detalhes.gump:CreateButton (welcome, function() welcome:Hide() end, 86, 16, "Close")
				close_button:InstallCustomTexture()
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
			Vanguard:ResetBlocks()
			
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
			
		end
	end
	
	--> list with tank names
	Vanguard.TankList = {} --> tanks
	Vanguard.TankHashNames = {} --> tanks
	Vanguard.TankBlocks = {} --> tank frames
	Vanguard.TankIncDamage = {} --> tank damage taken from last 5 seconds
	
	--> search for tanks in the raid or party group 
	function Vanguard:IdentifyTanks()
	
		table.wipe (Vanguard.TankList)
		table.wipe (Vanguard.TankHashNames)
		table.wipe (Vanguard.TankIncDamage)
		
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
			tblock.statusbar:SetValue (100)
			tblock.debuffs_using = 0
			tblock.debuffs_next_index = 1
			
			for i = 1, 3 do
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
		
		self.texture:SetVertexColor (r, g, b)
		
		bar.lefticon = Vanguard.CurrentInstance.row_info.icon_file
		bar.iconleft:SetTexCoord (left, right, top, bottom)
		bar:SetLeftText (Vanguard:GetOnlyName (name))
		bar:SetLeftText (name)
		
		local width = Vanguard.db.tank_block_size
		self:SetWidth (width)
		self:SetBackdropColor (unpack (Vanguard.db.tank_block_color))
		self.texture:SetTexture (SharedMedia:Fetch ("statusbar", Vanguard.db.tank_block_texture))
	end
	
	local debuff_on_enter = function (self)
		if (self.spellid) then
			self.texture:SetBlendMode ("ADD")
			GameTooltip:SetOwner (self, "ANCHOR_TOPLEFT")
			GameTooltip:SetSpellByID (self.spellid)
			GameTooltip:Show()
		end
	end
	local debuff_on_leave = function (self)
		self.texture:SetBlendMode ("BLEND")
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
		f:SetSize (Vanguard.db.tank_block_size or 150, 50)
		
		f:SetScript ("OnMouseUp", on_click)
		
		if (index == 1) then
			f:SetPoint ("bottomleft", VanguardFrame, "bottomleft", 0 + ((index-1) * 155), 0)
		else
			f:SetPoint ("left", Vanguard.TankBlocks [index-1], "right", 5, 0)
		end
		
		f:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0}, edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1})
		f:SetBackdropColor (unpack (Vanguard.db.tank_block_color))
		f:SetBackdropBorderColor (0, 0, 0, 1)
		
		--tank health bar
			f.statusbar = CreateFrame ("statusbar", nil, f, "BackdropTemplate")
			f.statusbar:SetPoint ("topleft", f, "topleft", 1, -1)
			f.statusbar:SetPoint ("bottomright", f, "bottomright", -1, 1)
			--health bar texture
			f.texture = f.statusbar:CreateTexture (nil, "artwork")
			f.statusbar:SetStatusBarTexture (f.texture)
			f.statusbar:SetMinMaxValues (0, 100)
			f.statusbar:SetValue (100)
			f.texture:SetTexture (SharedMedia:Fetch ("statusbar", Vanguard.db.tank_block_texture))
			
			--spec icon
			f.specicon = f.statusbar:CreateTexture (nil, "overlay")
			f.specicon:SetPoint ("topleft", f, "topleft", 5, -5)
			f.specicon:SetSize (14, 14)
			
			--tank name
			f.tankname = f.statusbar:CreateFontString (nil, "overlay", "GameFontNormal")
			f.tankname:SetPoint ("left", f.specicon, "right", 2, 0)
		
			--debuff icons
			f.debufficons = {}
		
		--inc heals inc damage
			f.heal_inc = framework:NewSplitBar (VanguardFrame, VanguardFrame, "VanguardDamageVsHeal" .. index, "DamageVsHeal" .. index, 294, Vanguard.db.bar_height)
			f.heal_inc:SetTexture(SharedMedia:Fetch ("statusbar", Vanguard.db.tank_block_texture))
			f.heal_inc:SetPoint ("topleft", VanguardFrame, "topleft", 0, ((index - 1) * -Vanguard.db.bar_height))
			f.heal_inc:SetPoint ("topright", VanguardFrame, "topright", 0, ((index - 1) * -Vanguard.db.bar_height))
		
			f.heal_inc.fontsize = 10
			
			_G [f.heal_inc:GetName() .. "_IconRight"]:SetSize(1, 1)
			f.heal_inc.righticon = ""

			f.heal_inc.iconright:SetVertexColor (1, .5, .5, 1)
		
			f.heal_inc:SetScript ("OnMouseUp", on_click)

			--debuffs blocks
			f.debuffs_blocks = {}
			f.debuffs_using = 0
			f.debuffs_next_index = 1
		
			for i = 1, 3 do
				local support_frame = CreateFrame ("frame", nil, f, "BackdropTemplate")
				support_frame:SetFrameLevel (f:GetFrameLevel()+1)
				support_frame:SetSize (24, 24)
				support_frame:SetScript ("OnMouseUp", on_click)
				
				local texture = support_frame:CreateTexture (nil, "overlay")
				texture:SetSize (24, 24)
				
				local y = 3
				
				if (i == 1) then --> left
					support_frame:SetPoint ("left", f, "left", 5, 0)
					support_frame:SetPoint ("bottom", f, "bottom", 0, y)
					
					texture:SetPoint ("left", f, "left", 5, 0)
					texture:SetPoint ("bottom", f, "bottom", 0, y)
					
				elseif (i == 2) then --> center
					support_frame:SetPoint ("center", f, "center", 0, 0)
					support_frame:SetPoint ("bottom", f, "bottom", 0, y)
					
					texture:SetPoint ("center", f, "center", 0, 0)
					texture:SetPoint ("bottom", f, "bottom", 0, y)
					
				elseif (i == 3) then --> right
					support_frame:SetPoint ("right", f, "right", -5, 0)
					support_frame:SetPoint ("bottom", f, "bottom", 0, y)
					
					texture:SetPoint ("right", f, "right", -5, 0)
					texture:SetPoint ("bottom", f, "bottom", 0, y)
					
				end

				local dblock = CreateFrame ("cooldown", "VanguardTankBlock" .. index.. "Cooldown" .. i, support_frame, "CooldownFrameTemplate, BackdropTemplate")
				dblock:SetAlpha (0.7)
				dblock:SetPoint ("topleft", texture, "topleft")
				dblock:SetPoint ("bottomright", texture, "bottomright")
				dblock:SetScript ("OnMouseUp", on_click)
				dblock.texture = texture
				
				dblock:SetScript ("OnEnter", debuff_on_enter)
				dblock:SetScript ("OnLeave", debuff_on_leave)

				local stack = dblock:CreateFontString (nil, "overlay", "GameFontNormal")
				stack:SetPoint ("bottomright", dblock, "bottomright", 8, 0)
				local stack_bg = dblock:CreateTexture (nil, "artwork")
				stack_bg:SetTexture (0, 0, 0)
				stack_bg:SetPoint ("bottomright", dblock, "bottomright", 8, 0)
				stack_bg:SetSize (12, 12)

				dblock.stack = stack
				dblock.stack_bg = stack_bg
				dblock.support = support_frame

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

			block:SetTank (i)
		end
		
		if (Vanguard.Running) then
			Vanguard:CombatEnd()
			Vanguard:CombatStart()
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
		
			local shields = UnitGetTotalAbsorbs (tank_name) or 0
			local heals = UnitGetIncomingHeals (tank_name) or 0
		
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
		VanguardFrame:RegisterEvent ("UNIT_HEALTH")
		VanguardFrame:RegisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
		
		if (Vanguard.track_incoming) then
			Vanguard:CancelTimer (Vanguard.track_incoming)
		end
		Vanguard.track_incoming = Vanguard:ScheduleRepeatingTimer ("TrackIncoming", 0.1)
		onUpdateFrame:SetScript("OnUpdate", onUpdateFrame.onUpdate)
	end
	
	function Vanguard:CombatEnd()
		Vanguard.Running = false
		VanguardFrame:UnregisterEvent ("UNIT_HEALTH")
		VanguardFrame:UnregisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
	
		if (Vanguard.track_incoming) then
			Vanguard:CancelTimer (Vanguard.track_incoming)
		end
	
		onUpdateFrame:SetScript("OnUpdate", nil)
	end
	
	function Vanguard:DebuffRefreshed (who_name, spellid)
		local tank_index = Vanguard.TankHashNames [who_name]
		if (tank_index) then
			local tframe = Vanguard.TankBlocks [tank_index]
			for i = 1, 3 do
				local dblock = tframe.debuffs_blocks [i]
				if (dblock.support.spellid == spellid) then
					local debuff_name = GetSpellInfo (spellid)
					
					local icon, count, duration, expirationTime = "", 0, 0, 0
					
					for i = 1, 40 do
						local auraName, icon1, count1, _, duration1, expirationTime1 = _UnitDebuff (who_name, i)
						if (auraName == debuff_name) then
							icon, count, duration, expirationTime = icon1, count1, duration1, expirationTime1
							break
						end
					end
					
					dblock.texture:SetTexture (icon)
					if (count and count > 0) then
						dblock.stack:SetText (count)
						dblock.stack_bg:Show()
					else
						dblock.stack:SetText ("")
						dblock.stack_bg:Hide()
					end
					
					dblock:SetCooldown (GetTime(), expirationTime-GetTime(), 0, 0)
					
					break
				end
			end
		end
	end
	
	function Vanguard:DebuffRemoved (who_name, spellid)
		local tank_index = Vanguard.TankHashNames [who_name]
		if (tank_index) then
			local tframe = Vanguard.TankBlocks [tank_index]
			for i = 1, 3 do
				local dblock = tframe.debuffs_blocks [i]
				if (dblock.support.spellid == spellid) then
					dblock.texture:SetTexture (nil)
					dblock.stack:SetText ("")
					dblock.stack_bg:Hide()
					dblock:SetCooldown (0, 0, 0, 0)
					dblock.in_use = nil
					dblock.support.spellid = nil
					for o = 1, 3 do
						if (not tframe.debuffs_blocks [o].in_use) then
							tframe.debuffs_next_index = o
							break
						end
					end
					tframe.debuffs_using = tframe.debuffs_using - 1
					break
				end
			end
		end
	end
	
	function Vanguard:DebuffApplied (who_name, spellid)
		local tank_index = Vanguard.TankHashNames [who_name]

		if (tank_index) then

			local tframe = Vanguard.TankBlocks [tank_index]
			if (tframe.debuffs_using < 3) then

				local next_index = tframe.debuffs_next_index
				if (next_index) then

					local dblock = tframe.debuffs_blocks [next_index]
					local icon, count, duration, expirationTime
					
					local debuff_name = GetSpellInfo (spellid)
					
					for i = 1, 40 do --doq
						local auraName, icon1, count1, _, duration1, expirationTime1 = _UnitDebuff (who_name, i)
						if (auraName == debuff_name) then
							icon, count, duration, expirationTime = icon1, count1, duration1, expirationTime1
							break
						end
					end

					if (not icon) then
						return
					end
					
					if (not duration) then
						duration = 999
					end
					
					dblock.texture:SetTexture (icon)
					dblock.texture:SetTexCoord (0.078125, 0.921875, 0.078125, 0.921875)
					
					if (count and count > 0) then
						dblock.stack:SetText (count)
						dblock.stack_bg:Show()
					else
						dblock.stack:SetText ("")
						dblock.stack_bg:Hide()
					end
					
					dblock:SetCooldown (GetTime(), expirationTime-GetTime(), 0, 0)
					dblock.in_use = true
					dblock.support.spellid = spellid
					dblock.spellid = spellid
					
					for i = 1, 3 do
						if (not tframe.debuffs_blocks [i].in_use) then
							tframe.debuffs_next_index = i
							break
						end
					end
				end
			end
		end
	end

	function Vanguard:UpdateHealth (blockid)
		local block = Vanguard.TankBlocks [blockid]
		block.statusbar:SetValue (UnitHealth (block.tankname_string) / UnitHealthMax (block.tankname_string) * 100)
	end
	
	function Vanguard:HealthChanged (unitId)
		local name, realm = UnitName (unitId)
		if (realm) then
			name = name .. "-" .. realm
		end
		local block = Vanguard.TankHashNames [name]
		if (block) then
			Vanguard:UpdateHealth (block)
		end
	end

end

local ignored_debuffs = {
	[80354] = true, --temporal displacement
	[57724] = true, --sated
	[6788] = true, --weakened soul
	[124275] = true, --light stagger
	[124274] = true, --moderate stagger
}

function Vanguard:TrackDebuffsAlreadyApplied()
	for tank_name, block_index in pairs (Vanguard.TankHashNames) do
		for i = 1, 41 do
			local auraName, icon, count, _, duration, expirationTime, unitCaster, _, _, spellid = _UnitDebuff (tank_name, i)
			if (icon and spellid and not ignored_debuffs [spellid]) then
				Vanguard:DebuffApplied (tank_name, spellid)
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
			type = "toggle",
			get = function() return Vanguard.db.show_inc_bars end,
			set = function (self, fixedparam, value) Vanguard.db.show_inc_bars = value; Vanguard:ResetBars() end,
			desc = "When enabled, shows the incoming heal and damage bars.",
			name = "Show Incoming Bars"
		},
		{
			type = "range",
			get = function() return Vanguard.db.tank_block_size end,
			set = function (self, fixedparam, value) Vanguard.db.tank_block_size = value; Vanguard:RefreshTanks() end,
			min = 70,
			max = 250,
			step = 1,
			desc = "Set the width of the blocks showing the tanks.",
			name = "Tank Block Size",
		},
		{
			type = "color",
			get = function() return Vanguard.db.tank_block_color end,
			set = function (self, r, g, b, a) 
				local current = Vanguard.db.tank_block_color;
				current[1], current[2], current[3], current[4] = r, g, b, a;
				Vanguard:RefreshTanks();
			end,
			desc = "Select the color of the tank block background.",
			name = "Tank Block Background Color"
		},
		{
			type = "select",
			get = function() return Vanguard.db.tank_block_texture end,
			values = function() return tank_texture_menu end,
			desc = "Choose the texture used on tank blocks.",
			name = "Tank Block Texture"
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
			desc = "Inc Damage Heigth",
			name = "Inc Damage Heigth",
		},
	}

	Vanguard:GetFramework():BuildMenu (options_frame, menu, 15, -50, 260, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
end

Vanguard.OpenOptionsPanel = function()
	if (not VanguardOptionsWindow) then
		build_options_panel()
	end
	VanguardOptionsWindow:Show()
end

local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

function Vanguard:OnEvent (_, event, arg1, token, time, who_serial, who_name, who_flags, _, alvo_serial, alvo_name, alvo_flags, _, spellid, spellname, spellschool, tipo)

	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		
		local arg1, token, time, who_serial, who_name, who_flags, _, alvo_serial, alvo_name, alvo_flags, _, spellid, spellname, spellschool, tipo = CombatLogGetCurrentEventInfo()
		
		--print (token, Vanguard.TankHashNames [alvo_name], alvo_name, tipo, Vanguard.Running)
		
		if (token == "SPELL_AURA_APPLIED") then
			if (Vanguard.TankHashNames [alvo_name] and tipo == "DEBUFF" and Vanguard.Running and not ignored_debuffs [spellid]) then
				Vanguard:DebuffApplied (alvo_name, spellid)
			end
			
		elseif (token == "SPELL_AURA_REMOVED") then
			if (Vanguard.TankHashNames [alvo_name] and tipo == "DEBUFF" and Vanguard.Running and not ignored_debuffs [spellid]) then
				Vanguard:DebuffRemoved (alvo_name, spellid)
			end
			
		elseif (token == "SPELL_AURA_REFRESH") then
			if (Vanguard.TankHashNames [alvo_name] and tipo == "DEBUFF" and Vanguard.Running and not ignored_debuffs [spellid]) then
				Vanguard:DebuffRefreshed (alvo_name, spellid)
			end
			
		elseif (token == "SPELL_AURA_APPLIED_DOSE") then
			if (Vanguard.TankHashNames [alvo_name] and tipo == "DEBUFF" and Vanguard.Running and not ignored_debuffs [spellid]) then
				Vanguard:DebuffRefreshed (alvo_name, spellid)
			end
			
		elseif (token == "SPELL_AURA_REMOVED_DOSE") then
			if (Vanguard.TankHashNames [alvo_name] and tipo == "DEBUFF" and Vanguard.Running and not ignored_debuffs [spellid]) then
				Vanguard:DebuffRefreshed (alvo_name, spellid)
			end

		end
	
	elseif (event == "UNIT_HEALTH") then
		Vanguard:HealthChanged (arg1)
		
	elseif (event == "ADDON_LOADED") then
	
		local AddonName = arg1
		if (AddonName == "Details_Vanguard") then
			
			if (_G._detalhes) then
			
				if (DetailsFramework.IsTimewalkWoW()) then
					return
				end
				
				local MINIMAL_DETAILS_VERSION_REQUIRED = 1
				local default_saved_table = {
					show_inc_bars = true,
					tank_block_size = 150,
					tank_block_height = 40,
					tank_block_color = {0.24705882, 0.0039215, 0, 0.8},
					tank_block_texture = "Details Serenity",
					first_run = false,
					bar_height = 24,
				}

				--> Install
				function Vanguard:OnDetailsEvent() end --> dummy func to stop warnings.
				
				local install, saveddata = _G._detalhes:InstallPlugin ("TANK", "Vanguard", "Interface\\Icons\\INV_Shield_77", Vanguard, "DETAILS_PLUGIN_VANGUARD", MINIMAL_DETAILS_VERSION_REQUIRED, "Tercio", "v2.1", default_saved_table)
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
