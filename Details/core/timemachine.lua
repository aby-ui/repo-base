-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local _detalhes = 		_G._detalhes
	local _tempo = time()
	local _
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _table_insert = table.insert --lua local
	local _ipairs = ipairs --lua local
	local _pairs = pairs --lua local
	local _math_floor = math.floor --lua local
	local _time = time --lua local
	
	local _GetTime = GetTime --api local
	
	local timeMachine = _detalhes.timeMachine --details local

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants
	local _tempo = _time()
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core

	timeMachine.ligada = false

	local calc_for_pvp = function (self)
		for tipo, tabela in _pairs (self.tabelas) do
			for nome, jogador in _ipairs (tabela) do
				if (jogador) then
					if (jogador.last_event+3 > _tempo) then --> okey o jogador esta dando dps
						if (jogador.on_hold) then --> o dps estava pausado, retornar a ativa
							jogador:HoldOn (false)
						end
					else
						if (not jogador.on_hold) then --> n�o ta pausado, precisa por em pausa
							--> verifica se esta castando alguma coisa que leve + que 3 segundos
							jogador:HoldOn (true)
						end
					end
				end
			end
		end
	end
	
	local calc_for_pve = function (self)
		for tipo, tabela in _pairs (self.tabelas) do
			for nome, jogador in _ipairs (tabela) do
				if (jogador) then
					if (jogador.last_event+10 > _tempo) then --> okey o jogador esta dando dps
						if (jogador.on_hold) then --> o dps estava pausado, retornar a ativa
							jogador:HoldOn (false)
						end
					else
						if (not jogador.on_hold) then --> n�o ta pausado, precisa por em pausa
							--> verifica se esta castando alguma coisa que leve + que 10 segundos
							jogador:HoldOn (true)
						end
					end
				end
			end
		end
	end
	
	function timeMachine:Core()
		_tempo = _time()
		_detalhes._tempo = _tempo
		_detalhes:UpdateGears()

		if (_detalhes.is_in_battleground or _detalhes.is_in_arena) then
			return calc_for_pvp (self)
		else
			return calc_for_pve (self)
		end
	end

	function timeMachine:Ligar()
		self.atualizador = self:ScheduleRepeatingTimer ("Core", 1)
		self.ligada = true
		self.tabelas = {{}, {}} --> 1 dano 2 cura
		
		local danos = _detalhes.tabela_vigente[1]._ActorTable
		for _, jogador in _ipairs (danos) do
			if (jogador.dps_started) then
				jogador:RegistrarNaTimeMachine()
			end
		end
	end

	function timeMachine:Desligar()
		self.ligada = false
		self.tabelas = nil
		if (self.atualizador) then
			self:CancelTimer (self.atualizador)
			self.atualizador = nil
		end
	end

	function timeMachine:Reiniciar()
		table.wipe (self.tabelas[1])
		table.wipe (self.tabelas[2])
		self.tabelas = {{}, {}} --> 1 dano 2 cura
	end

	function _detalhes:DesregistrarNaTimeMachine()
		if (not timeMachine.ligada) then
			return
		end
		
		local timeMachineContainer = timeMachine.tabelas [self.tipo]
		local actorTimeMachineID = self.timeMachine
		
		if (timeMachineContainer [actorTimeMachineID] == self) then
			self:TerminarTempo()
			self.timeMachine = nil
			timeMachineContainer [actorTimeMachineID] = false
		end
	end

	function _detalhes:RegistrarNaTimeMachine()
		if (not timeMachine.ligada) then
			return
		end

		local esta_tabela = timeMachine.tabelas [self.tipo]
		_table_insert (esta_tabela, self)
		self.timeMachine = #esta_tabela
	end 

	function _detalhes:ManutencaoTimeMachine()
		for tipo, tabela in _ipairs (timeMachine.tabelas) do
			local t = {}
			local removed = 0
			for index, jogador in _ipairs (tabela) do
				if (jogador) then
					t [#t+1] = jogador
					jogador.timeMachine = #t
				else
					removed = removed + 1
				end
			end
			
			timeMachine.tabelas [tipo] = t
			
			if (_detalhes.debug) then
				--_detalhes:Msg ("timemachine r"..removed.."| e"..#t.."| t"..tipo)
			end
		end
	end

	function _detalhes:Tempo()
	
		if (self.pvp) then
			--> pvp timer
			if (self.end_time) then --> o tempo do jogador esta trancado
				local t = self.end_time - self.start_time
				if (t < 3) then
					t = 3
				end
				return t
			elseif (self.on_hold) then --> o tempo esta em pausa
				local t = self.delay - self.start_time
				if (t < 3) then
					t = 3
				end
				return t
			else
				if (self.start_time == 0) then
					return 3
				end
				local t = _tempo - self.start_time
				if (t < 3) then
					if (_detalhes.in_combat) then
						local combat_time = _detalhes.tabela_vigente:GetCombatTime()
						if (combat_time < 3) then
							return combat_time
						end
					end
					t = 3
				end
				return t
			end
		else
			--> pve timer
			if (self.end_time) then --> o tempo do jogador esta trancado
				local t = self.end_time - self.start_time
				if (t < 10) then
					t = 10
				end
				return t
			elseif (self.on_hold) then --> o tempo esta em pausa
				local t = self.delay - self.start_time
				if (t < 10) then
					t = 10
				end
				return t
			else
				if (self.start_time == 0) then
					return 10
				end
				local t = _tempo - self.start_time
				if (t < 10) then
					if (_detalhes.in_combat) then
						local combat_time = _detalhes.tabela_vigente:GetCombatTime()
						if (combat_time < 10) then
							return combat_time
						end
					end
					t = 10
				end
				return t
			end
		end
	end

	function _detalhes:IniciarTempo (tempo)
		self.start_time = tempo
	end

	function _detalhes:TerminarTempo()
		if (self.end_time) then
			return
		end

		if (self.on_hold) then
			self:HoldOn (false)
		end
		
		self.end_time = _tempo
	end

	--> diz se o dps deste jogador esta em pausa
	function _detalhes:HoldOn (pausa)
		if (pausa == nil) then 
			return self.on_hold --retorna se o dps esta aberto ou fechado para este jogador
			
		elseif (pausa) then --> true - colocar como inativo
			self.delay = _math_floor (self.last_event) --_tempo - 10
			if (self.delay < self.start_time) then
				self.delay = self.start_time
			end
			self.on_hold = true
			
		else --> false - retornar a atividade
			local diff = _tempo - self.delay - 1
			if (diff > 0) then
				self.start_time = self.start_time + diff
			end
			--if (_tempo - self.start_time < 20) then
			--	self.start_time = self.start_time - 1
			--end
			self.on_hold = false
			
		end
	end

	function _detalhes:PrintTimeMachineIndexes()
		print ("timemachine damage", #timeMachine.tabelas [1])
		print ("timemachine heal", #timeMachine.tabelas [2])
	end
