--[[ detect actor class ]]

do 

	local _detalhes	= 	_G._detalhes
	local _
	local _pairs = pairs
	local _ipairs = ipairs
	local _UnitClass = UnitClass
	local _select = select
	local _unpack = unpack

	local unknown_class_coords = {0.75, 1, 0.75, 1}
	
	function _detalhes:GetIconTexture (iconType, withAlpha)
		iconType = string.lower (iconType)
		
		if (iconType == "spec") then
			if (withAlpha) then
				return [[Interface\AddOns\Details\images\spec_icons_normal_alpha]]
			else
				return [[Interface\AddOns\Details\images\spec_icons_normal]]
			end
			
		elseif (iconType == "class") then
			if (withAlpha) then
				return [[Interface\AddOns\Details\images\classes_small_alpha]]
			else
				return [[Interface\AddOns\Details\images\classes_small]]
			end
		end
	end
	
	-- try get the class from actor name
	function _detalhes:GetClass (name)
		local _, class = _UnitClass (name)
		
		if (not class) then
			for index, container in _ipairs (_detalhes.tabela_overall) do
				local index = container._NameIndexTable [name]
				if (index) then
					local actor = container._ActorTable [index]
					if (actor.classe ~= "UNGROUPPLAYER") then
						local left, right, top, bottom = unpack (_detalhes.class_coords [actor.classe] or unknown_class_coords)
						local r, g, b = unpack (_detalhes.class_colors [actor.classe])
						return actor.classe, left, right, top, bottom, r or 1, g or 1, b or 1
					end
				end
			end
			
			return "UNKNOW", 0.75, 1, 0.75, 1, 1, 1, 1, 1
		else
			local left, right, top, bottom = unpack (_detalhes.class_coords [class])
			local r, g, b = unpack (_detalhes.class_colors [class])
			return class, left, right, top, bottom, r or 1, g or 1, b or 1
		end
	end
	
	local CLASS_ICON_TCOORDS = CLASS_ICON_TCOORDS
	
	local roles = {
		DAMAGER = {421/512, 466/512, 381/512, 427/512},
		HEALER = {467/512, 512/512, 381/512, 427/512},
		TANK = {373/512, 420/512, 381/512, 427/512},
		NONE = {0, 50/512, 110/512, 150/512},
	} 
	function _detalhes:GetRoleIcon (role)
		return [[Interface\AddOns\Details\images\icons2]], unpack (roles [role])
	end
	
	function _detalhes:GetClassIcon (class)
	
		local c
	
		if (self.classe) then
			c = self.classe
		elseif (type (class) == "table" and class.classe) then
			c = class.classe
		elseif (type (class) == "string") then
			c = class
		else
			c = "UNKNOW"
		end
		
		if (c == "UNKNOW") then
			return [[Interface\LFGFRAME\LFGROLE_BW]], 0.25, 0.5, 0, 1
		elseif (c == "UNGROUPPLAYER") then
			return [[Interface\ICONS\Achievement_Character_Orc_Male]], 0, 1, 0, 1
		elseif (c == "PET") then
			return [[Interface\AddOns\Details\images\classes_small]], 0.25, 0.49609375, 0.75, 1
		else
			return [[Interface\AddOns\Details\images\classes_small]], _unpack (_detalhes.class_coords [c])
		end
	end
	
	function _detalhes:GetSpecIcon (spec, useAlpha)
		if (spec) then
			if (useAlpha) then
				return [[Interface\AddOns\Details\images\spec_icons_normal_alpha]], unpack (_detalhes.class_specs_coords [spec])
			else
				return [[Interface\AddOns\Details\images\spec_icons_normal]], unpack (_detalhes.class_specs_coords [spec])
			end
		end
	end
	
	local default_color = {1, 1, 1, 1}
	function _detalhes:GetClassColor (class)
		if (self.classe) then
			return unpack (_detalhes.class_colors [self.classe] or default_color)
			
		elseif (type (class) == "table" and class.classe) then
			return unpack (_detalhes.class_colors [class.classe] or default_color)
		
		elseif (type (class) == "string") then
			return unpack (_detalhes.class_colors [class] or default_color)
			
		else
			unpack (default_color)
		end
	end
	
	function _detalhes:GetPlayerIcon (playerName, segment)
		segment = segment or _detalhes.tabela_vigente
		
		local texture
		local L, R, T, B

		local playerObject = segment (1, playerName)
		if (not playerObject or not playerObject.spec) then
			playerObject = segment (2, playerName)
		end
		
		if (playerObject) then
			local spec = playerObject.spec
			if (spec) then
				texture = [[Interface\AddOns\Details\images\spec_icons_normal]]
				L, R, T, B = unpack (_detalhes.class_specs_coords [spec])
			else
				texture = [[Interface\AddOns\Details\images\classes_small]]
				L, R, T, B = unpack (_detalhes.class_coords [playerObject.classe or "UNKNOW"])
			end
		else
			texture = [[Interface\AddOns\Details\images\classes_small]]
			L, R, T, B = unpack (_detalhes.class_coords ["UNKNOW"])
		end
		
		return texture, L, R, T, B
	end
	
	function _detalhes:GuessClass (t)
	
		local Actor, container, tries = t[1], t[2], t[3]
		
		if (not Actor) then
			return false
		end
		
		if (Actor.spells) then --> correcao pros containers misc, precisa pegar os diferentes tipos de containers de  l�
			for spellid, _ in _pairs (Actor.spells._ActorTable) do 
				local class = _detalhes.ClassSpellList [spellid]
				if (class) then
					Actor.classe = class
					Actor.guessing_class = nil
					
					if (container) then
						container.need_refresh = true
					end
					
					if (Actor.minha_barra and type (Actor.minha_barra) == "table") then
						Actor.minha_barra.minha_tabela = nil
						_detalhes:ScheduleWindowUpdate (2, true)
					end
				
					return class
				end
			end
		end

		if (not Actor.nome) then
			if (not _detalhes.NoActorNameWarning) then
				print ("==============")
				_detalhes:Msg ("Unhandled Exception: Actor has no name, ContainerID: ", container.tipo)
				_detalhes:Msg ("After the current combat, reset data and use /reload.")
				_detalhes:Msg ("Report this issue to the Author: Actor with no name, container: ", container.tipo)
				print ("==============")
				_detalhes.NoActorNameWarning = true
			end
			return
		end
		
		local class = _detalhes:GetClass (Actor.nome)
		if (class and class ~= "UNKNOW") then
			Actor.classe = class
			Actor.need_refresh = true
			Actor.guessing_class = nil
			
			if (container) then
				container.need_refresh = true
			end
			
			if (Actor.minha_barra and type (Actor.minha_barra) == "table") then
				Actor.minha_barra.minha_tabela = nil
				_detalhes:ScheduleWindowUpdate (2, true)
			end
			
			return class
		end
		
		if (tries and tries < 10) then 
			t[3] = tries + 1 --thanks @Farmbuyer on curseforge
			--_detalhes:ScheduleTimer ("GuessClass", 2, {Actor, container, tries+1})
			_detalhes:ScheduleTimer ("GuessClass", 2, t) --passing the same table instead of creating a new one
		end
		
		return false
	end
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	function _detalhes:GetSpecByGUID (unitSerial)
		return _detalhes.cached_specs [unitSerial]
	end
	
	-- try get the spec from actor name
	function _detalhes:GetSpec (name)

		local guid = UnitGUID (name)
		if (guid) then
			local spec = _detalhes.cached_specs [guid]
			if (spec) then
				return spec
			end
		end
		
		for index, container in _ipairs (_detalhes.tabela_overall) do
			local index = container._NameIndexTable [name]
			if (index) then
				local actor = container._ActorTable [index]
				return actor and actor.spec
			end
		end
		
	end
	
	function _detalhes:ReGuessSpec (t)
		local Actor, container = t[1], t[2]
		local SpecSpellList = _detalhes.SpecSpellList
		
		--> get from the spell cast list
		if (_detalhes.tabela_vigente) then
			local misc_actor = _detalhes.tabela_vigente (4, Actor.nome)
			if (misc_actor and misc_actor.spell_cast) then
				for spellid, _ in pairs (misc_actor.spell_cast) do
					local spec = SpecSpellList [spellid]
					if (spec) then
						_detalhes.cached_specs [Actor.serial] = spec
					
						Actor.spec = spec
						Actor.classe = _detalhes.SpecIDToClass [spec] or Actor.classe
						Actor.guessing_spec = nil
						
						if (container) then
							container.need_refresh = true
						end
						
						if (Actor.minha_barra and type (Actor.minha_barra) == "table") then
							Actor.minha_barra.minha_tabela = nil
							_detalhes:ScheduleWindowUpdate (2, true)
						end
					
						return spec
					end
				end
			end
		else
			if (Actor.spells) then
				for spellid, _ in _pairs (Actor.spells._ActorTable) do 
					local spec = SpecSpellList [spellid]
					if (spec) then
						if (spec ~= Actor.spec) then
							_detalhes.cached_specs [Actor.serial] = spec
						
							Actor.spec = spec
							Actor.classe = _detalhes.SpecIDToClass [spec] or Actor.classe
							
							if (container) then
								container.need_refresh = true
							end
							
							if (Actor.minha_barra and type (Actor.minha_barra) == "table") then
								Actor.minha_barra.minha_tabela = nil
								_detalhes:ScheduleWindowUpdate (2, true)
							end
						
							return spec
						else
							break
						end
					end
				end
				
				if (Actor.classe == "HUNTER") then
					local container_misc = _detalhes.tabela_vigente[4]
					local index = container_misc._NameIndexTable [Actor.nome]
					if (index) then
						local misc_actor = container_misc._ActorTable [index]
						local buffs = misc_actor.buff_uptime_spells and misc_actor.buff_uptime_spells._ActorTable
						if (buffs) then
							for spellid, spell in _pairs (buffs) do
								local spec = SpecSpellList [spellid]
								if (spec) then
									if (spec ~= Actor.spec) then
										_detalhes.cached_specs [Actor.serial] = spec
									
										Actor.spec = spec
										Actor.classe = _detalhes.SpecIDToClass [spec] or Actor.classe
										
										if (container) then
											container.need_refresh = true
										end
										
										if (Actor.minha_barra and type (Actor.minha_barra) == "table") then
											Actor.minha_barra.minha_tabela = nil
											_detalhes:ScheduleWindowUpdate (2, true)
										end
									
										return spec
									else
										break
									end
								end
							end
						end
					end
				end
				
			end
		end
	end
	
	function _detalhes:GuessSpec (t)
		
		local Actor, container, tries = t[1], t[2], t[3]
		if (not Actor) then
			return false
		end
		
		local SpecSpellList = _detalhes.SpecSpellList
		
		--local misc_actor = info.instancia.showing (4, self:name())
		--spell_cast
		
		--> get from the spec cache
		local spec = _detalhes.cached_specs [Actor.serial]
		if (spec) then
			Actor.spec = spec
			Actor.classe = _detalhes.SpecIDToClass [spec] or Actor.classe
			
			Actor.guessing_spec = nil
			
			if (container) then
				container.need_refresh = true
			end
			
			if (Actor.minha_barra and type (Actor.minha_barra) == "table") then
				Actor.minha_barra.minha_tabela = nil
				_detalhes:ScheduleWindowUpdate (2, true)
			end
		
			return spec
		end
		
		--> get from the spell cast list
		if (_detalhes.tabela_vigente) then
			local misc_actor = _detalhes.tabela_vigente (4, Actor.nome)
			
			if (misc_actor and misc_actor.spell_cast) then
				for spellid, _ in pairs (misc_actor.spell_cast) do
					local spec = SpecSpellList [spellid]
					if (spec) then
						_detalhes.cached_specs [Actor.serial] = spec
					
						Actor.spec = spec
						Actor.classe = _detalhes.SpecIDToClass [spec] or Actor.classe
						
						Actor.guessing_spec = nil
						
						if (container) then
							container.need_refresh = true
						end
						
						if (Actor.minha_barra and type (Actor.minha_barra) == "table") then
							Actor.minha_barra.minha_tabela = nil
							_detalhes:ScheduleWindowUpdate (2, true)
						end
					
						return spec
					end
				end
			else
				if (Actor.spells) then --> correcao pros containers misc, precisa pegar os diferentes tipos de containers de  l�
					for spellid, _ in _pairs (Actor.spells._ActorTable) do 
						local spec = SpecSpellList [spellid]
						if (spec) then
							_detalhes.cached_specs [Actor.serial] = spec
						
							Actor.spec = spec
							Actor.classe = _detalhes.SpecIDToClass [spec] or Actor.classe
							Actor.guessing_spec = nil
							
							if (container) then
								container.need_refresh = true
							end
							
							if (Actor.minha_barra and type (Actor.minha_barra) == "table") then
								Actor.minha_barra.minha_tabela = nil
								_detalhes:ScheduleWindowUpdate (2, true)
							end
						
							return spec
						end
					end
				end
			end
		else
			
			if (Actor.spells) then --> correcao pros containers misc, precisa pegar os diferentes tipos de containers de  l�
				for spellid, _ in _pairs (Actor.spells._ActorTable) do 
					local spec = SpecSpellList [spellid]
					if (spec) then
						_detalhes.cached_specs [Actor.serial] = spec
					
						Actor.spec = spec
						Actor.classe = _detalhes.SpecIDToClass [spec] or Actor.classe
						Actor.guessing_spec = nil
						
						if (container) then
							container.need_refresh = true
						end
						
						if (Actor.minha_barra and type (Actor.minha_barra) == "table") then
							Actor.minha_barra.minha_tabela = nil
							_detalhes:ScheduleWindowUpdate (2, true)
						end
					
						return spec
					end
				end
			end
		end

		if (Actor.classe == "HUNTER") then
			local container_misc = _detalhes.tabela_vigente[4]
			local index = container_misc._NameIndexTable [Actor.nome]
			if (index) then
				local misc_actor = container_misc._ActorTable [index]
				local buffs = misc_actor.buff_uptime_spells and misc_actor.buff_uptime_spells._ActorTable
				if (buffs) then
					for spellid, spell in _pairs (buffs) do
						local spec = SpecSpellList [spellid]
						if (spec) then
						
							_detalhes.cached_specs [Actor.serial] = spec
						
							Actor.spec = spec
							Actor.classe = _detalhes.SpecIDToClass [spec] or Actor.classe
							Actor.guessing_spec = nil
							
							if (container) then
								container.need_refresh = true
							end
							
							if (Actor.minha_barra and type (Actor.minha_barra) == "table") then
								Actor.minha_barra.minha_tabela = nil
								_detalhes:ScheduleWindowUpdate (2, true)
							end
						
							return spec
						end
					end
				end
			end
		end

		local spec = _detalhes:GetSpec (Actor.nome)
		if (spec) then
		
			_detalhes.cached_specs [Actor.serial] = spec
		
			Actor.spec = spec
			Actor.classe = _detalhes.SpecIDToClass [spec] or Actor.classe
			Actor.need_refresh = true
			Actor.guessing_spec = nil
			
			if (container) then
				container.need_refresh = true
			end
			
			if (Actor.minha_barra and type (Actor.minha_barra) == "table") then
				Actor.minha_barra.minha_tabela = nil
				_detalhes:ScheduleWindowUpdate (2, true)
			end
			
			return spec
		end
		
		if (_detalhes.streamer_config.quick_detection) then
			if (tries and tries < 30) then 
				t[3] = tries + 1
				_detalhes:ScheduleTimer ("GuessSpec", 1, t)
			end		
		else
			if (tries and tries < 10) then 
				t[3] = tries + 1
				_detalhes:ScheduleTimer ("GuessSpec", 3, t)
			end		
		end
		
		return false
	end

end


function _detalhes:AddColorString (player_name, class)
	--> check if the class colors exists
	local classColors = _G.RAID_CLASS_COLORS
	if (classColors) then
		local color = classColors [class]
		--> check if the player name is valid
		if (type (player_name) == "string" and color) then
			player_name = "|c" .. color.colorStr .. player_name .. "|r"
			return player_name
		end
	end
	
	--> if failed, return the player name without modifications
	return player_name
end

function _detalhes:AddRoleIcon (player_name, role, size)
	--> check if is a valid role
	local roleIcon = _detalhes.role_texcoord [role]
	if (type (player_name) == "string" and roleIcon and role ~= "NONE") then
		--> add the role icon
		size = size or 14
		player_name = "|TInterface\\LFGFRAME\\UI-LFG-ICON-ROLES:" .. size .. ":" .. size .. ":0:0:256:256:" .. roleIcon .. "|t " .. player_name
		return player_name
	end

	return player_name
end

function _detalhes:AddClassOrSpecIcon (playerName, class, spec, iconSize, useAlphaIcons)

	local size = iconSize or 16
	
	if (spec) then
		local specString = ""
		local L, R, T, B = unpack (_detalhes.class_specs_coords [spec])
		if (L) then
			if (useAlphaIcons) then
				specString = "|TInterface\\AddOns\\Details\\images\\spec_icons_normal_alpha:" .. size .. ":" .. size .. ":0:0:512:512:" .. (L * 512) .. ":" .. (R * 512) .. ":" .. (T * 512) .. ":" .. (B * 512) .. "|t"
			else
				specString = "|TInterface\\AddOns\\Details\\images\\spec_icons_normal:" .. size .. ":" .. size .. ":0:0:512:512:" .. (L * 512) .. ":" .. (R * 512) .. ":" .. (T * 512) .. ":" .. (B * 512) .. "|t"
			end
			return specString .. " " .. playerName
		end
	end
	
	if (class) then
		local classString = ""
		local L, R, T, B = unpack (_detalhes.class_coords [class])
		if (L) then
			local imageSize = 128
			if (useAlphaIcons) then
				classString = "|TInterface\\AddOns\\Details\\images\\classes_small_alpha:" .. size .. ":" .. size .. ":0:0:" .. imageSize .. ":" .. imageSize .. ":" .. (L * imageSize) .. ":" .. (R * imageSize) .. ":" .. (T * imageSize) .. ":" .. (B * imageSize) .. "|t"
			else
				classString = "|TInterface\\AddOns\\Details\\images\\classes_small:" .. size .. ":" .. size .. ":0:0:" .. imageSize .. ":" .. imageSize .. ":" .. (L * imageSize) .. ":" .. (R * imageSize) .. ":" .. (T * imageSize) .. ":" .. (B * imageSize) .. "|t"
			end
			return classString .. " " .. playerName
		end
	end
	
	return playerName
end
