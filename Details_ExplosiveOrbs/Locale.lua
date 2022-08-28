local _, Engine = ...

-- luacheck: ignore 542

-- Lua functions
local rawget = rawget

-- WoW API / Variables

local locale = GetLocale()
local L = {}

Engine.L = setmetatable(L, {
    __index = function(t, s) return rawget(t, s) or s end,
})

if locale == 'zhCN' then
L["Dynamic Overall Explosive Orbs"] = "动态总体爆炸物"
L["Explosive Orbs"] = "爆炸物"
L["Hit: "] = "击: "
L["Only Show Hit"] = "仅显示击"
L["Only show the hit of Explosive Orbs, without target."] = "对爆炸物仅显示击，不显示选。"
L["Show how many explosive orbs players target and hit."] = "显示玩家选中与击中不同爆炸物的次数。"
L["Target: "] = "选: "
L["Use Short Text"] = "使用短文本"
L["Use short text for Explosive Orbs."] = "为爆炸物使用短文本，仅显示数字。"

elseif locale == 'zhTW' then
L["Dynamic Overall Explosive Orbs"] = "動態整場炸藥"
L["Explosive Orbs"] = "炸藥"
L["Hit: "] = "擊: "
--[[Translation missing --]]
--[[ L["Only Show Hit"] = "Only Show Hit"--]] 
--[[Translation missing --]]
--[[ L["Only show the hit of Explosive Orbs, without target."] = "Only show the hit of Explosive Orbs, without target."--]] 
L["Show how many explosive orbs players target and hit."] = "顯示玩家選中與擊中不同炸藥的次數"
L["Target: "] = "選: "
--[[Translation missing --]]
--[[ L["Use Short Text"] = "Use Short Text"--]] 
--[[Translation missing --]]
--[[ L["Use short text for Explosive Orbs."] = "Use short text for Explosive Orbs."--]] 

elseif locale == 'deDE' then
--[[Translation missing --]]
--[[ L["Dynamic Overall Explosive Orbs"] = "Dynamic Overall Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Explosive Orbs"] = "Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Hit: "] = "Hit: "--]] 
--[[Translation missing --]]
--[[ L["Only Show Hit"] = "Only Show Hit"--]] 
--[[Translation missing --]]
--[[ L["Only show the hit of Explosive Orbs, without target."] = "Only show the hit of Explosive Orbs, without target."--]] 
--[[Translation missing --]]
--[[ L["Show how many explosive orbs players target and hit."] = "Show how many explosive orbs players target and hit."--]] 
--[[Translation missing --]]
--[[ L["Target: "] = "Target: "--]] 
--[[Translation missing --]]
--[[ L["Use Short Text"] = "Use Short Text"--]] 
--[[Translation missing --]]
--[[ L["Use short text for Explosive Orbs."] = "Use short text for Explosive Orbs."--]] 

elseif locale == 'esES' then
--[[Translation missing --]]
--[[ L["Dynamic Overall Explosive Orbs"] = "Dynamic Overall Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Explosive Orbs"] = "Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Hit: "] = "Hit: "--]] 
--[[Translation missing --]]
--[[ L["Only Show Hit"] = "Only Show Hit"--]] 
--[[Translation missing --]]
--[[ L["Only show the hit of Explosive Orbs, without target."] = "Only show the hit of Explosive Orbs, without target."--]] 
--[[Translation missing --]]
--[[ L["Show how many explosive orbs players target and hit."] = "Show how many explosive orbs players target and hit."--]] 
--[[Translation missing --]]
--[[ L["Target: "] = "Target: "--]] 
--[[Translation missing --]]
--[[ L["Use Short Text"] = "Use Short Text"--]] 
--[[Translation missing --]]
--[[ L["Use short text for Explosive Orbs."] = "Use short text for Explosive Orbs."--]] 

elseif locale == 'esMX' then
--[[Translation missing --]]
--[[ L["Dynamic Overall Explosive Orbs"] = "Dynamic Overall Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Explosive Orbs"] = "Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Hit: "] = "Hit: "--]] 
--[[Translation missing --]]
--[[ L["Only Show Hit"] = "Only Show Hit"--]] 
--[[Translation missing --]]
--[[ L["Only show the hit of Explosive Orbs, without target."] = "Only show the hit of Explosive Orbs, without target."--]] 
--[[Translation missing --]]
--[[ L["Show how many explosive orbs players target and hit."] = "Show how many explosive orbs players target and hit."--]] 
--[[Translation missing --]]
--[[ L["Target: "] = "Target: "--]] 
--[[Translation missing --]]
--[[ L["Use Short Text"] = "Use Short Text"--]] 
--[[Translation missing --]]
--[[ L["Use short text for Explosive Orbs."] = "Use short text for Explosive Orbs."--]] 

elseif locale == 'frFR' then
--[[Translation missing --]]
--[[ L["Dynamic Overall Explosive Orbs"] = "Dynamic Overall Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Explosive Orbs"] = "Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Hit: "] = "Hit: "--]] 
--[[Translation missing --]]
--[[ L["Only Show Hit"] = "Only Show Hit"--]] 
--[[Translation missing --]]
--[[ L["Only show the hit of Explosive Orbs, without target."] = "Only show the hit of Explosive Orbs, without target."--]] 
--[[Translation missing --]]
--[[ L["Show how many explosive orbs players target and hit."] = "Show how many explosive orbs players target and hit."--]] 
--[[Translation missing --]]
--[[ L["Target: "] = "Target: "--]] 
--[[Translation missing --]]
--[[ L["Use Short Text"] = "Use Short Text"--]] 
--[[Translation missing --]]
--[[ L["Use short text for Explosive Orbs."] = "Use short text for Explosive Orbs."--]] 

elseif locale == 'itIT' then
--[[Translation missing --]]
--[[ L["Dynamic Overall Explosive Orbs"] = "Dynamic Overall Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Explosive Orbs"] = "Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Hit: "] = "Hit: "--]] 
--[[Translation missing --]]
--[[ L["Only Show Hit"] = "Only Show Hit"--]] 
--[[Translation missing --]]
--[[ L["Only show the hit of Explosive Orbs, without target."] = "Only show the hit of Explosive Orbs, without target."--]] 
--[[Translation missing --]]
--[[ L["Show how many explosive orbs players target and hit."] = "Show how many explosive orbs players target and hit."--]] 
--[[Translation missing --]]
--[[ L["Target: "] = "Target: "--]] 
--[[Translation missing --]]
--[[ L["Use Short Text"] = "Use Short Text"--]] 
--[[Translation missing --]]
--[[ L["Use short text for Explosive Orbs."] = "Use short text for Explosive Orbs."--]] 

elseif locale == 'koKR' then
--[[Translation missing --]]
--[[ L["Dynamic Overall Explosive Orbs"] = "Dynamic Overall Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Explosive Orbs"] = "Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Hit: "] = "Hit: "--]] 
--[[Translation missing --]]
--[[ L["Only Show Hit"] = "Only Show Hit"--]] 
--[[Translation missing --]]
--[[ L["Only show the hit of Explosive Orbs, without target."] = "Only show the hit of Explosive Orbs, without target."--]] 
--[[Translation missing --]]
--[[ L["Show how many explosive orbs players target and hit."] = "Show how many explosive orbs players target and hit."--]] 
--[[Translation missing --]]
--[[ L["Target: "] = "Target: "--]] 
--[[Translation missing --]]
--[[ L["Use Short Text"] = "Use Short Text"--]] 
--[[Translation missing --]]
--[[ L["Use short text for Explosive Orbs."] = "Use short text for Explosive Orbs."--]] 

elseif locale == 'ptBR' then
--[[Translation missing --]]
--[[ L["Dynamic Overall Explosive Orbs"] = "Dynamic Overall Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Explosive Orbs"] = "Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Hit: "] = "Hit: "--]] 
--[[Translation missing --]]
--[[ L["Only Show Hit"] = "Only Show Hit"--]] 
--[[Translation missing --]]
--[[ L["Only show the hit of Explosive Orbs, without target."] = "Only show the hit of Explosive Orbs, without target."--]] 
--[[Translation missing --]]
--[[ L["Show how many explosive orbs players target and hit."] = "Show how many explosive orbs players target and hit."--]] 
--[[Translation missing --]]
--[[ L["Target: "] = "Target: "--]] 
--[[Translation missing --]]
--[[ L["Use Short Text"] = "Use Short Text"--]] 
--[[Translation missing --]]
--[[ L["Use short text for Explosive Orbs."] = "Use short text for Explosive Orbs."--]] 

elseif locale == 'ruRU' then
--[[Translation missing --]]
--[[ L["Dynamic Overall Explosive Orbs"] = "Dynamic Overall Explosive Orbs"--]] 
L["Explosive Orbs"] = "Взрывоопасные сферы"
L["Hit: "] = "Урон:"
L["Only Show Hit"] = "Показать только урон"
L["Only show the hit of Explosive Orbs, without target."] = "Показывать только урон от взрывоопасных шаров, без цели"
L["Show how many explosive orbs players target and hit."] = "Отображает, сколько взрывоопасных сфер игроки выделяют и бьют."
L["Target: "] = "Цель:"
L["Use Short Text"] = "Использовать короткий текст"
L["Use short text for Explosive Orbs."] = "Использовать короткий текст для взрывоопасных сфер."

end
