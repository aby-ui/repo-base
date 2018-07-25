--[[
	Italian Localization
]]--

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'itIT')
if not L then return end

--keybinding text
L.ToggleBags = "Attiva l'Inventario"
L.ToggleBank = 'Attiva la Banca'
L.ToggleVault = 'Attiva la Banca Eterea'


--system messages
L.NewUser = 'Trovato un nuovo utente. Le impostazioni predefinite sono state caricate.'
L.Updated = 'Aggiornato alla v%s'
L.UpdatedIncompatible = 'Aggiornato da una versione incompatibile. Caricati valori predefiniti.'


--slash commands
L.Commands = 'Comandi:'
L.CmdShowInventory = 'Mostra il tuo Inventario'
L.CmdShowBank = 'Mostra la tua Banca'
L.CmdShowVersion = 'Mostra la versione attuale'


--frame text
L.TitleBags = 'Inventario di %s'
L.TitleBank = 'Banca di %s'


--tooltips
L.TipBags = 'Borse'
L.TipChangePlayer = 'Clicca per vedere gli oggetti di un altro personaggio.'
L.TipCleanBags = 'Clicca per mettere in ordine le borse.'
L.TipCleanBank = '<Clic Destro> per mettere in ordine la Banca.'
L.TipDepositReagents = '<Clic Sinistro> per depositare tutti i reagenti.'
L.TipFrameToggle = "<Clic Destro> per attivare un'altra finestra."
L.TipGoldOnRealm = 'Totali di %s'
L.TipHideBag = 'Clicca per nascondere questa borsa.'
L.TipHideBags = '<Clic Sinistro> per nascondere il riquadro delle borse.'
L.TipHideSearch = 'Clicca per nascondere la barra di ricerca.'
L.TipManageBank = 'Gestisci Banca'
L.PurchaseBag = 'Clicca per comprare questo spazio di Banca.'
L.TipShowBag = 'Clicca per mostrare questa borsa.'
L.TipShowBags = '<Clic Sinistro> per mostrare il riquadro delle borse.'
L.TipShowMenu = '<Clic Destro> per configurare questa finestra.'
L.TipShowSearch = 'Clicca per cercare.'
L.TipShowFrameConfig = 'Clicca per configurare questa finestra.'
L.TipDoubleClickSearch = '<Alt e trascina> per muovere.\n<Clic Destro> per configurare.\n<Doppio clic> per cercare.'
L.Total = 'Totali'

--itemcount tooltips
L.TipCount1 = 'Equipaggiati: %d'
L.TipCount2 = 'Borse: %d'
L.TipCount3 = 'Banca: %d'
L.TipCount4 = 'Banca Eterea: %d'
L.TipDelimiter = '|'

--databroker tooltips
L.TipShowBank = '<Shift+Clic Sinistro> per mostrare la Banca.'
L.TipShowInventory = '<Clic Sinistro> per mostrare il tuo Inventario.'
L.TipShowOptions = '<Clic Destro> per mostrare le opzioni del menù.'
