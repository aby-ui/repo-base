-- class target file

	local _detalhes = 		_G._detalhes
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _setmetatable = setmetatable --lua local

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants
	
	local alvo_da_habilidade	=	_detalhes.alvo_da_habilidade

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internals

	function alvo_da_habilidade:NovaTabela (link)

		local esta_tabela = {total = 0}
		_setmetatable (esta_tabela, alvo_da_habilidade)
		
		return esta_tabela
	end

	function alvo_da_habilidade:AddQuantidade (amt)
		self.total = self.total + amt
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> core
	
	function _detalhes.refresh:r_alvo_da_habilidade (este_alvo, shadow)
		_setmetatable (este_alvo, alvo_da_habilidade)
		este_alvo.__index = alvo_da_habilidade
		este_alvo.shadow = shadow._ActorTable [shadow._NameIndexTable [este_alvo.nome]]
	end

	function _detalhes.clear:c_alvo_da_habilidade (este_alvo)
		este_alvo.shadow = nil
		--este_alvo.__index = {}
		este_alvo.__index = nil
	end

	alvo_da_habilidade.__sub = function (tabela1, tabela2)
		tabela1.total = tabela1.total - tabela2.total
		if (tabela1.overheal) then
			tabela1.overheal = tabela1.overheal - tabela2.overheal
			tabela1.absorbed = tabela1.absorbed - tabela2.absorbed
		end
	end
