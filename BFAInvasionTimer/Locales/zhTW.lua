
if GetLocale() ~= "zhTW" then return end
local _, mod = ...
local L = mod.L

L.firstRunWarning = "計時器將在第一次遇到入侵之後顯示。"
L.underAttack = "|T%d:15:15:0:0:64:64:4:60:4:60|t %s被入侵！"
L.nextInvasions = "下次入侵"
L.next = "下次：%s"
L.waiting = "等待中"

