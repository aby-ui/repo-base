--[[
    Spanish Localization
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'esES') or LibStub('AceLocale-3.0'):NewLocale(ADDON, 'esMX')
if not L then return end

--keybinding text
L.ToggleBags = 'Abrir mochila'
L.ToggleBank = 'Abrir banco'


--system messages
L.NewUser = 'Nuevo usuario detectado; configuración predeterminada cargada.'
L.Updated = 'Actualizado a la versión %s.'
L.UpdatedIncompatible = 'No se puede actualizar a la nueva versión; configuración predeterminada cargada.'


--slash commands
L.Commands = 'Comandos:'
L.CmdShowInventory = 'Abre la mochila'
L.CmdShowBank = 'Abre la banco'
L.CmdShowVersion = 'Muestra la versión actual'


--frame text
L.TitleBags = 'Mochila de %s'
L.TitleBank = 'Banco de %s'


--tooltips
L.TipBags = 'Mochila'
L.TipBank = 'Banco'
L.TipBankToggle = '<Clic derecho> para abrir el banco.'
L.TipChangePlayer = 'Clic para ver los objetos de tus personajes.'
L.TipGoldOnRealm = 'Total en %s'
L.TipHideBag = 'Clic para ocultar la bolsa.'
L.TipHideBags = '<Clic izquierda> para ocultar las bolsas.'
L.TipHideSearch = 'Clic para ocultar el campo de búsqueda.'
L.TipInventoryToggle = '<Clic derecho> para abrir la mochila.'
L.PurchaseBag = 'Clic para comprar una ranura en el banco.'
L.TipResetPlayer = '<Clic derecho> para volver al personaje actual.'
L.TipShowBag = 'Clic para mostrar la bolsa.'
L.TipShowBags = '<Clic izquierda> para mostrar las bolsas.'
L.TipShowMenu = '<Clic izquierda> para configurar esta ventana.'
L.TipShowSearch = 'Clic para buscar.'
L.TipShowFrameConfig = 'Clic para configurar esta ventana.'
L.TipDoubleClickSearch = '<Alt-Arrastra> para mover.\n<Clic derecho> para configurar.\n<Doble clic> para buscar.'
L.ToggleVault = 'Abrir depósito del vacío'
L.TipCleanBags = 'Clic para limpiar las bolsas.'
L.TipCleanBank = 'Clic derecho para limpiar el banco.'
L.TipDepositReagents = 'Clic izquierda para depositar todos los componentes.'
L.TipFrameToggle = 'Clic derecho para abrir/ocultar otras ventanas.'

--itemcount tooltips
L.TipCount1 = 'Equipado: %d'
L.TipCount2 = 'Mochila: %d'
L.TipCount3 = 'Banco: %d'
L.TipCount4 = 'Cámara: %d'

--databroker tooltips
L.TipShowBank = '<Mayús clic> para abrir el banco.'
L.TipShowInventory = '<Clic izquierda> para abrir la mochila.'
L.TipShowOptions = '<Clic derecho> para abrir el menú de opciones.'