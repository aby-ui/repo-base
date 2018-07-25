--[[
	Brasilian Portuguese Localization
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'ptBR')
if not L then return end

--keybinding text
L.ToggleBags = 'Abrir mochila'
L.ToggleBank = 'Abrir banco'


--system messages
L.NewUser = 'Novo utilizador detetado, configuração padrão carregada'
L.Updated = 'Atualizado para versão %s'
L.UpdatedIncompatible = 'Impossível atualizar para nova versão, configuração padrão carregada'


--slash commands
L.Commands = 'Commandos:'
L.CmdShowInventory = 'Abre a sua mochila'
L.CmdShowBank = 'Abre o seu banco'
L.CmdShowVersion = 'Mostra a versão atual'


--frame text
L.TitleBags = 'Mochila de %s'
L.TitleBank = 'Banco de %s'


--tooltips
L.TipBags = 'Mochila'
L.TipBank = 'Banco'
L.TipBankToggle = '<Clique Direito> para abrir o banco.'
L.TipChangePlayer = 'Carregue para ver os itens das suas personagens.'
L.TipGoldOnRealm = '%s no Total'
L.TipHideBag = 'Clique para esconder o saco.'
L.TipHideBags = '<Clique Esquerdo> para esconder os sacos.'
L.TipHideSearch = 'Clique para esconder o campo de pesquisa.'
L.TipInventoryToggle = '<Clique Direito> para abrir a mochila.'
L.PurchaseBag = 'Clique para comprar uma ranhura no banco.'
L.TipShowBag = 'Clique para mostrar o bag.'
L.TipShowBags = '<Clique Esquerdo> para mostrar os sacos.'
L.TipShowMenu = '<Clique Esquerdo> para configurar esta janela.'
L.TipShowSearch = 'Clique para pesquisar.'
L.TipShowFrameConfig = 'Clique para configurar esta janela.'
L.TipDoubleClickSearch = '<Alt-Arraste> para mover.\n<Clique Direito> para configurar.\n<Duplo Clique> para pesquisar.'

--itemcount tooltips
L.TipCount1 = 'Equipado: %d'
L.TipCount2 = 'Mochila: %d'
L.TipCount3 = 'Banco: %d'
L.TipCount4 = 'Cofre: %d'

--databroker tooltips
L.TipShowBank = '<Shift-Clique Esquerdo> para abrir o banco.'
L.TipShowInventory = '<Clique Esquerdo> para abrir a mochila.'
L.TipShowOptions = '<Clique Direito> para abrir o menu de configuração.'