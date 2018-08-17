
-- CHANGES TO LOCALIZATION SHOULD BE MADE USING http://www.wowace.com/addons/Broker_MicroMenu/localization/

local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("Broker_MicroMenu", "enUS", true)

if L then
	L["Advanced"] = true
	L["Enable this if you want to fine tune the displayed text."] = true
	L["Enable"] = true
	L["Custom Text"] = true
	
	L["Show FPS"] = true
	L["Show frames per second."] = true
	L["Show World Latency"] = true
	L["Show latency for combat data, data from the people around you (specs, gear, enchants, etc.)."] = true
	L["Show Home Latency"] = true
	L["Show latency for chat data, auction house stuff some addon data, and various other data."] = true
	L["Enable Coloring"] = true
	L["General"] = true
	L["ms"] = true
	L["fps"] = true
	L["Show FPS First"] = true
end

local L = AceLocale:NewLocale("Broker_MicroMenu", "deDE")
if L then 
	L["Advanced"] = "Erweitert"
L["Custom Text"] = "Eigener Text"
L["Disable Coloring"] = "Farben deaktivieren"
L["Enable"] = "Aktivieren"
L["Enable this if you want to fine tune the displayed text."] = "Aktiviere dies, um den Anzeigetext zu bearbeiten."
L["fps"] = "FPS"
L["General"] = "Allgemein"
L["ms"] = "ms"
L["Show FPS First"] = "FPS zuerst zeigen"
L["Show Home Latency"] = "Standortlatenz zeigen"
L["Show latency for chat data, auction house stuff some addon data, and various other data."] = "Zeigt die Latenz für Chatdaten, Auktionshaus, Addondaten und verschiedene anderen Datenübertragungen."
L["Show latency for combat data, data from the people around you (specs, gear, enchants, etc.)."] = "Zeigt die Latenz für Kampfdaten, Daten von Mitspielern um dich herum (Spezialisierung, Ausrüstung, Verzauberungen usw.)."
L["Show World Latency"] = "Weltlatenz zeigen"

	return
end

local L = AceLocale:NewLocale("Broker_MicroMenu", "frFR")
if L then
	
	return
end

local L = AceLocale:NewLocale("Broker_MicroMenu", "koKR")
if L then
	
	return
end

local L = AceLocale:NewLocale("Broker_MicroMenu", "zhTW")
if L then
	L["Advanced"] = "進階"
L["Custom Text"] = "自訂文字"
L["Enable Coloring"] = "啟用著色"
L["Enable"] = "啟用"
L["Enable this if you want to fine tune the displayed text."] = "啟用此如果你想微調顯示文字。"
L["fps"] = "fps"
L["General"] = "一般"
L["ms"] = "ms"
L["Show FPS First"] = "優先顯示FPS"
L["Show Home Latency"] = "顯示本地延遲"
L["Show latency for chat data, auction house stuff some addon data, and various other data."] = "顯示延遲的聊天數據，拍賣場原料的附加數據，和其他各種數據。"
L["Show latency for combat data, data from the people around you (specs, gear, enchants, etc.)."] = "顯示延遲的戰鬥數據，你身邊人的數據(天賦，裝備，附魔..等等)"
L["Show World Latency"] = "顯示世界延遲"

	return
end

local L = AceLocale:NewLocale("Broker_MicroMenu", "zhCN")
if L then
	L["Enable Coloring"] = "启用着色"
L["fps"] = "FPS"
L["General"] = "综合"
L["ms"] = "ms" -- Needs review
L["Show FPS First"] = "首先显示FPS"
L["Show Home Latency"] = "显示本地延迟"
L["Show latency for combat data, data from the people around you (specs, gear, enchants, etc.)."] = "显示战斗数据的延迟, 来自周围人的数据（天赋，装备，副本，等。。。）"
L["Show World Latency"] = "显示世界延迟"

	return
end

local L = AceLocale:NewLocale("Broker_MicroMenu", "ruRU")
if L then
	
	return
end

local L = AceLocale:NewLocale("Broker_MicroMenu", "esES")
if L then
	L["Advanced"] = "Avanzado"
L["Custom Text"] = "Texto personalizado"
L["Disable Coloring"] = "Desactivar coloración"
L["Enable"] = "Activar"
L["Enable this if you want to fine tune the displayed text."] = "Actívalo si quieres personalizar el texto mostrado."
L["fps"] = "fps"
L["General"] = "General"
L["ms"] = "ms"
L["Show FPS First"] = "Mostrar el FPS primero"
L["Show Home Latency"] = "Mostrar latencia del cliente"
L["Show latency for chat data, auction house stuff some addon data, and various other data."] = "Mostrar la latencia del chat, la casa de subastas, la comunicación entre los addons, y algos otros tipos de datos."
L["Show latency for combat data, data from the people around you (specs, gear, enchants, etc.)."] = "Mostrar la latencia de los datos del combate y la información de los jugadores cercanos (especializaciones, equipamiento, encantamientos, etc)"
L["Show World Latency"] = "Mostrar latencia del servidor"

	return
end

local L = AceLocale:NewLocale("Broker_MicroMenu", "esMX")
if L then
	L["Advanced"] = "Avanzado"
L["Custom Text"] = "Texto personalizado"
L["Disable Coloring"] = "Desactivar coloración"
L["Enable"] = "Activar"
L["Enable this if you want to fine tune the displayed text."] = "Actívalo si quieres personalizar el texto mostrado."
L["fps"] = "fps"
L["General"] = "General"
L["ms"] = "ms"
L["Show FPS First"] = "Mostrar el FPS primero"
L["Show Home Latency"] = "Mostrar latencia del cliente"
L["Show latency for chat data, auction house stuff some addon data, and various other data."] = "Mostrar la latencia del chat, la casa de subastas, la comunicación entre los addons, y algos otros tipos de datos."
L["Show latency for combat data, data from the people around you (specs, gear, enchants, etc.)."] = "Mostrar la latencia de los datos del combate y la información de los jugadores cercanos (especializaciones, equipamiento, encantamientos, etc)"
L["Show World Latency"] = "Mostrar latencia del servidor"

	return
end
local L = AceLocale:NewLocale("Broker_MicroMenu", "ptBR")
if L then
	L["Disable Coloring"] = "Desabilitar cores"
L["fps"] = "fps"
L["General"] = "Geral"
L["ms"] = "ms"
L["Show FPS First"] = "Mostrar FPS primeiro"
L["Show Home Latency"] = "Mostrar latência Local"
L["Show latency for chat data, auction house stuff some addon data, and various other data."] = "Mostrar latência para dados de chat, coisas da casa de leilões, alguns dados de addons e outros dados."
L["Show latency for combat data, data from the people around you (specs, gear, enchants, etc.)."] = "Mostrar latência para dados de combate, dados de pessoas ao seu redor (especs, equipamento, encantamentos etc.)"
L["Show World Latency"] = "Mostrar latência Global"

	return
end
