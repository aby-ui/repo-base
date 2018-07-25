--[[
	Russian Localization
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'ruRU')
if not L then return end

--keybinding text
L.ToggleBags = 'Переключить инвентарь'
L.ToggleBank = 'Переключить банк'
L.ToggleVault = 'Переключить Хранилище Бездны'


--system messages
L.NewUser = 'Обнаружен новый пользователь, загружены стандартные настройки'
L.Updated = 'Обновлено до v%s'
L.UpdatedIncompatible = 'Обновление от несовместимой версии, загружены стандартные настройки'


--slash commands
L.Commands = 'Команды:'
L.CmdShowInventory = 'Открыть/закрыть инвентарь'
L.CmdShowBank = 'Открыть/закрыть банк'
L.CmdShowVersion = 'Сообщить текущую версию модификации'


--frame text
L.TitleBags = 'Инвентарь |3-1(%s)'
L.TitleBank = 'Банк |3-1(%s)'


--tooltips
L.TipBags = 'Сумки'
L.TipBank = 'Банк'
L.TipChangePlayer = '<Клик> - просмотр предметов другого персонажа.'
L.TipGoldOnRealm = 'Всего денег на %s'
L.TipHideBag = '<Клик> - скрыть эту сумку.'
L.TipHideBags = '<Левый-клик> - скрыть область сумок.'
L.TipHideSearch = '<Клик> - скрыть область поиска.'
L.TipFrameToggle = '<Правый-клик> - переключить другие окна.'
L.PurchaseBag = '<Клик> - купить банковскую ячейку.'
L.TipShowBag = '<Клик> - показать эту сумку.'
L.TipShowBags = '<Левый-клик> - показать область сумок.'
L.TipShowMenu = '<Правый-клик> - настроить это окно.'
L.TipShowSearch = '<Клик> - поиск.'
L.TipShowFrameConfig = '<Клик> - настроить это окно.'
L.TipDoubleClickSearch = '<Alt-Двигать> - переместить.\n<Правый-клик> - настройки.\n<Двойной-клик> - поиск.'
L.Total = 'Всего'

--itemcount tooltips
L.TipCount1 = 'Надето: %d'
L.TipCount2 = 'Сумки: %d'
L.TipCount3 = 'Банк: %d'
L.TipCount4 = 'Бездна: %d'
L.TipDelimiter = '|'

--databroker tooltips
L.TipShowBank = '<Shift-Левый-Клик> - переключить ваш банк.'
L.TipShowInventory = '<Левый-Клик> - переключить инвентарь.'
L.TipShowOptions = '<Правый-Клик> - открыть меню опций.'