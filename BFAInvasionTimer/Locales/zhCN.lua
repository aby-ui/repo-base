
if GetLocale() ~= "zhCN" then return end
local _, mod = ...
local L = mod.L

L.firstRunWarning = "遇到第一次入侵之前不会显示计时器。"
L.underAttack = "|T%d:15:15:0:0:64:64:4:60:4:60|t %s 被入侵！"
L.nextInvasions = "下次入侵"
L.next = "下次：%s"
L.waiting = "等待中"
