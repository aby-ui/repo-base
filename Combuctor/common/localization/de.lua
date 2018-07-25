--[[
	German Localization
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'deDE')
if not L then return end

--keybindings
L.ToggleBags = 'Inventar umschalten'
L.ToggleBank = 'Bank umschalten'
L.ToggleGuild = 'Gildenbank umschalten'
L.ToggleVault = 'Leerenlager umschalten'

--terminal
L.Commands = 'Befehlsliste'
L.CmdShowInventory = 'Schaltet das Inventar um'
L.CmdShowBank = 'Schaltet die Bank um'
L.CmdShowGuild = 'Schaltet die Gildenbank um'
L.CmdShowVault = 'Schaltet das Leerenlager um'
L.CmdShowVersion = 'Zeigt die aktuelle Version an'
L.Updated = 'Aktualisiert auf v%s'

--frames
L.TitleBags = 'Inventar von %s'
L.TitleBank = 'Bank von %s'

--tooltips
L.TipBags = 'Taschen'
L.TipChangePlayer = '<Klicken> um die Gegenst\195\164nde anderer Charaktere anzuzeigen.'
L.TipCleanBags = '<Klicken> um die Taschen aufräumen.'
L.TipCleanBank = '<Rechtsklick> um die Bank aufzuräumen.'
L.TipDepositReagents = '<Klicken> um alle Reagenzien einzulagern.'
L.TipFrameToggle = '<Rechtsklick> um andere Fenster umzuschalten.'
L.TipGoldOnRealm = 'Auf %s gesamt'
L.TipHideBag = '<Klicken> um diese Tasche zu verstecken.'
L.TipHideBags = '<Klicken> um die Taschenanzeige zu verstecken.'
L.TipHideSearch = '<Klicken> um das Suchfenster zu verstecken.'
L.TipManageBank = 'Bank verwalten'
L.PurchaseBag = '<Klicken> um das Bankfach zu kaufen.'
L.TipResetPlayer = '<Rechtsklick> um auf den aktuellen Charakter zurücksetzen.'
L.TipShowBag = '<Klicken> um diese Taschen anzuzeigen.'
L.TipShowBags = '<Klicken> um das Taschenfenster anzuzeigen.'
L.TipShowMenu = '<Rechtsklick> um das Fenster zu konfigurieren.'
L.TipShowSearch = '<Klicken> zum Suchen.'
L.TipShowFrameConfig = '<Klicken> um dieses Fenster zu konfigurieren.'
L.TipDoubleClickSearch = '<Alt-Ziehen> zum Verschieben.\n<Rechtsklick> zum Konfigurieren.\n<Doppelklick> zum Suchen.'
L.Total = 'Gesamt'

--itemcount tooltips
L.TipCount1 = 'Angelegt: %d'
L.TipCount2 = 'Taschen: %d'
L.TipCount3 = 'Bank: %d'
L.TipCount4 = 'Leerenlager: %d'
L.TipDelimiter = '|'

--databroker plugin tooltips
L.TipShowBank = '<Rechtsklick> um die Bank umzuschalten'
L.TipShowInventory = '<Klicken> um das Inventar umzuschalten'
L.TipShowOptions = '<Shift-Klick> um das Konfigurationsmen\195\188 anzuzeigen'
