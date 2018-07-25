--[[
	French Localization
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'frFR')
if not L then return end

--keybinding text
L.ToggleBags = 'Afficher votre inventaire'
L.ToggleBank = 'Afficher votre banque'
L.ToggleVault = 'Afficher votre chambre du vide'


--system messages
L.NewUser = 'Nouvel utilisateur détecté, paramêtres par défaut chargés'
L.Updated = 'Mis à jour vers la version %s'
L.UpdatedIncompatible = 'Mise à jour vers une version incompatible, paramêtres par défaut chargés'


--slash commands
L.Commands = 'Commandes:'
L.CmdShowInventory = 'Affiche votre inventaire'
L.CmdShowBank = 'Affiche votre banque'
L.CmdShowVersion = 'Affiche la version actuelle'


--frame text
L.TitleBags = 'Inventaire de %s'
L.TitleBank = 'Banque de %s'


--tooltips
L.TipBags = 'Sacs'
L.TipBank = 'Banque'
L.TipChangePlayer = 'Cliquez pour afficher les objets d\'un autre personnage.'
L.TipGoldOnRealm = '%s Totaux'
L.TipHideBag = 'Cliquez pour cacher ce sac.'
L.TipHideBags = '<Clic Gauche> pour cacher l\'affichage des sac.'
L.TipHideSearch = 'Cliquez pour cacher le champ de recherche.'
L.TipFrameToggle = '<Clic Droit> pour afficher d\'autres fenêtres.'
L.PurchaseBag = 'Cliquez pour acheter cet emplacement de sac.'
L.TipShowBag = 'Cliquez pour afficher ce sac.'
L.TipShowBags = '<Clic Gauche> pour afficher la fenêtre de vos sacs.'
L.TipShowMenu = '<Clic Droit> pour configurer cette fenêtre.'
L.TipShowSearch = 'Cliquez pour rechercher.'
L.TipShowFrameConfig = 'Cliquez pour configurer cette fenêtre.'
L.TipDoubleClickSearch = '<Clic Gauche-Déplacer> pour bouger.\n<Clic Droit> pour configurer.\n<Double Clique> pour rechercher.'

--itemcount tooltips
L.TipCount1 = 'Equippé: %d'
L.TipCount2 = 'Sacs: %d'
L.TipCount3 = 'Banque: %d'
L.TipCount4 = 'Vault: %d'

--databroker tooltips
L.TipShowBank = '<Maj-Clic Gauche> pour afficher votre banque.'
L.TipShowInventory = '<Clic Gauche> pour afficher votre inventaire.'
L.TipShowOptions = '<Clic Droit> pour afficher le menu options.'