--File Revision: 1
--Last Modification: 27/07/2013
-- Change Log:
	-- 27/07/2013: Finished alpha version.
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local _detalhes = _G._detalhes
	local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )
	local _
	--> initialize buffs name container
	_detalhes.Buffs.BuffsTable = {} -- armazenara o [nome do buff] = { tabela do buff }
	_detalhes.Buffs.__index = _detalhes.Buffs
	
	--> switch off recording buffs by default
	_detalhes.RecordPlayerSelfBuffs = false
	_detalhes.RecordPlayerAbilityWithBuffs = false
	_detalhes.RecordPlayerSelfDebuffs = false
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _pairs = pairs --> lua local
	local _ipairs = ipairs --> lua local

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> details api functions

	--> return if the buff is already registred or not
	function _detalhes.Buffs:IsRegistred (buff)
		if (type (buff) == "number") then
			for _, buffObject in _pairs (_detalhes.Buffs.BuffsTable) do 
				if (buffObject.id == buff) then
					return true
				end
			end
			return false
		elseif (type (buff) == "string") then
			for name, _ in _pairs (_detalhes.Buffs.BuffsTable) do 
				if (name == buff) then
					return true
				end
			end
			return false
		end
	end

	--> register a new buff name
	function _detalhes.Buffs:NewBuff (BuffName, BuffId)
		if (not BuffName) then
			BuffName = GetSpellInfo (BuffId)
		end
		if (_detalhes.Buffs.BuffsTable [BuffName]) then
			return false
		else
			_detalhes.Buffs.BuffsTable [BuffName] = _detalhes.Buffs:BuildBuffTable (BuffName, BuffId)
		end
	end

	--> remove a registred buff
	function _detalhes.Buffs:RemoveBuff (BuffName)
		if (not _detalhes.Buffs.BuffsTable [BuffName]) then
			return false
		else
			_detalhes.Buffs.BuffsTable = _detalhes:tableRemove (_detalhes.Buffs.BuffsTable, BuffName)
			return true
		end
	end
	
	--> return a list of registred buffs
	function _detalhes.Buffs:GetBuffList()
		local list = {}
		for name, _ in _pairs (_detalhes.Buffs.BuffsTable) do 
			list [#list+1] = name
		end
		return list
	end

	--> return a list of registred buffs ids
	function _detalhes.Buffs:GetBuffListIds()
		local list = {}
		for name, buffObject in _pairs (_detalhes.Buffs.BuffsTable) do 
			list [#list+1] = buffObject.id
		end
		return list
	end

	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internal functions
	
	function _detalhes.Buffs:UpdateBuff (method)
		-- self = buff table
		if (method == "new") then
		
			self.start = _detalhes._tempo
			self.castedAmt = self.castedAmt + 1
			self.active = true
			self.appliedAt [#self.appliedAt+1] = _detalhes.tabela_vigente:GetCombatTime()
			_detalhes:SendEvent ("BUFF_UPDATE")
			
		elseif (method == "refresh") then
			
			self.refreshAmt = self.refreshAmt + 1
			self.duration = self.duration + (_detalhes._tempo - self.start)
			self.start = _detalhes._tempo
			self.appliedAt [#self.appliedAt+1] = _detalhes.tabela_vigente:GetCombatTime()
			_detalhes:SendEvent ("BUFF_UPDATE")
			
		elseif (method == "remove") then
			
			if (self.start) then
				self.duration = self.duration + (_detalhes._tempo - self.start)
			else
				self.duration = 0
			end
			self.droppedAmt = self.droppedAmt + 1
			self.start = nil
			self.active = false
			_detalhes:SendEvent ("BUFF_UPDATE")
			
		end
	end

	--> build buffs
	function _detalhes.Buffs:BuildTables()
		_detalhes.Buffs.built = true
		if (_detalhes.savedbuffs) then
			for _, BuffId in _ipairs (_detalhes.savedbuffs) do 
				_detalhes.Buffs:NewBuff (nil, BuffId)
			end
		end
	end

	--> save buff list when addon exit
	function _detalhes.Buffs:SaveBuffs()
		_detalhes_database.savedbuffs = _detalhes.Buffs:GetBuffListIds()
	end

	--> construct a buff table of the new buff registred
	function _detalhes.Buffs:BuildBuffTable (BuffName, BuffId)
		local bufftable = {name = BuffName, id = BuffId, duration = 0, start = nil, castedAmt = 0, refreshAmt = 0, droppedAmt = 0, active = false, appliedAt = {}}
		bufftable.IsBuff = true
		setmetatable (bufftable, _detalhes.Buffs)
		return bufftable
	end


	--> update player buffs
	function _detalhes.Buffs:CatchBuffs()
		
		if (not _detalhes.Buffs.built) then
			_detalhes.Buffs:BuildTables()
		end
		
		for _, BuffTable in _pairs (_detalhes.Buffs.BuffsTable) do 
			if (BuffTable.active) then
				BuffTable.start = _detalhes._tempo
				BuffTable.castedAmt = 1
			else
				BuffTable.start = nil
				BuffTable.castedAmt = 0
			end
			
			BuffTable.appliedAt = {}
			BuffTable.duration = 0
			BuffTable.refreshAmt = 0
			BuffTable.droppedAmt = 0
		end
		
		--> catch buffs untracked yet
		for buffIndex = 1, 41 do
			local name = UnitAura ("player", buffIndex)
			if (name) then
				local bufftable = _detalhes.Buffs.BuffsTable [name]
				if (bufftable and not bufftable.active) then
					bufftable.active = true
					bufftable.castedAmt = 1
					bufftable.start = _detalhes._tempo
				end
				
				--[[
				for index, BuffName in _pairs (_detalhes.SoloTables.BuffsTableNameCache) do
					if (BuffName == name) then
						local BuffObject = _detalhes.SoloTables.SoloBuffUptime [name]
						if (not BuffObject) then
							_detalhes.SoloTables.SoloBuffUptime [name] = {name = name, duration = 0, start = nil, castedAmt = 1, refreshAmt = 0, droppedAmt = 0, Active = true, tableIndex = index, appliedAt = {}}
							--_detalhes.SoloTables.BuffTextEntry [index].backgroundFrame:Active()
						end
					end
				end
				--]]
			end
		end
	end
