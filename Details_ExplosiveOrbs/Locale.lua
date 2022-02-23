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
L["Show how many explosive orbs players target and hit."] = "显示玩家选中与击中不同爆炸物的次数。"
L["Target: "] = "选: "

elseif locale == 'zhTW' then
L["Dynamic Overall Explosive Orbs"] = "動態整場炸藥"
L["Explosive Orbs"] = "炸藥"
L["Hit: "] = "擊: "
L["Show how many explosive orbs players target and hit."] = "顯示玩家選中與擊中不同炸藥的次數"
L["Target: "] = "選: "

elseif locale == 'deDE' then
--[[Translation missing --]]
--[[ L["Dynamic Overall Explosive Orbs"] = "Dynamic Overall Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Explosive Orbs"] = "Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Hit: "] = "Hit: "--]] 
--[[Translation missing --]]
--[[ L["Show how many explosive orbs players target and hit."] = "Show how many explosive orbs players target and hit."--]] 
--[[Translation missing --]]
--[[ L["Target: "] = "Target: "--]] 

elseif locale == 'esES' then
--[[Translation missing --]]
--[[ L["Dynamic Overall Explosive Orbs"] = "Dynamic Overall Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Explosive Orbs"] = "Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Hit: "] = "Hit: "--]] 
--[[Translation missing --]]
--[[ L["Show how many explosive orbs players target and hit."] = "Show how many explosive orbs players target and hit."--]] 
--[[Translation missing --]]
--[[ L["Target: "] = "Target: "--]] 

elseif locale == 'esMX' then
--[[Translation missing --]]
--[[ L["Dynamic Overall Explosive Orbs"] = "Dynamic Overall Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Explosive Orbs"] = "Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Hit: "] = "Hit: "--]] 
--[[Translation missing --]]
--[[ L["Show how many explosive orbs players target and hit."] = "Show how many explosive orbs players target and hit."--]] 
--[[Translation missing --]]
--[[ L["Target: "] = "Target: "--]] 

elseif locale == 'frFR' then
--[[Translation missing --]]
--[[ L["Dynamic Overall Explosive Orbs"] = "Dynamic Overall Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Explosive Orbs"] = "Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Hit: "] = "Hit: "--]] 
--[[Translation missing --]]
--[[ L["Show how many explosive orbs players target and hit."] = "Show how many explosive orbs players target and hit."--]] 
--[[Translation missing --]]
--[[ L["Target: "] = "Target: "--]] 

elseif locale == 'itIT' then
--[[Translation missing --]]
--[[ L["Dynamic Overall Explosive Orbs"] = "Dynamic Overall Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Explosive Orbs"] = "Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Hit: "] = "Hit: "--]] 
--[[Translation missing --]]
--[[ L["Show how many explosive orbs players target and hit."] = "Show how many explosive orbs players target and hit."--]] 
--[[Translation missing --]]
--[[ L["Target: "] = "Target: "--]] 

elseif locale == 'koKR' then
--[[Translation missing --]]
--[[ L["Dynamic Overall Explosive Orbs"] = "Dynamic Overall Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Explosive Orbs"] = "Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Hit: "] = "Hit: "--]] 
--[[Translation missing --]]
--[[ L["Show how many explosive orbs players target and hit."] = "Show how many explosive orbs players target and hit."--]] 
--[[Translation missing --]]
--[[ L["Target: "] = "Target: "--]] 

elseif locale == 'ptBR' then
--[[Translation missing --]]
--[[ L["Dynamic Overall Explosive Orbs"] = "Dynamic Overall Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Explosive Orbs"] = "Explosive Orbs"--]] 
--[[Translation missing --]]
--[[ L["Hit: "] = "Hit: "--]] 
--[[Translation missing --]]
--[[ L["Show how many explosive orbs players target and hit."] = "Show how many explosive orbs players target and hit."--]] 
--[[Translation missing --]]
--[[ L["Target: "] = "Target: "--]] 

elseif locale == 'ruRU' then
--[[Translation missing --]]
--[[ L["Dynamic Overall Explosive Orbs"] = "Dynamic Overall Explosive Orbs"--]] 
L["Explosive Orbs"] = "Взрывоопасная сфера"
L["Hit: "] = "Урон:"
L["Show how many explosive orbs players target and hit."] = "Отображает, сколько взрывоопасных сфер игроки выделяют и бьют."
L["Target: "] = "Цель:"

end
