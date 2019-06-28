------------------------------------------------------------
-- Localization.lua
--
-- Abin
-- 2017/6/22
------------------------------------------------------------

local _, addon = ...

addon.L = {
	["title"] = "Quake Assist",
	["desc"] = "Alerts you when a Quake is about to interrupt you spell so you may stop casting to avoid silence effects.",
	["lock position"] = "Lock position",
	["voice alert"] = "Voice alert",
	["predict next quake"] = "Predict next quake",
	["frame scale"] = "Frame scale",
	["stop casting"] = "Stop casting!",
	["test"] = "Test",
	["risk tolerance"] = "Risk tolerance",
	["enabled prompt"] = "Affix |cff00ff00Quaking|r detected, alerting module activated.",
	["disabled prompt"] = "Alerting module deactivated.",
}

if GetLocale() == "zhCN" then
	addon.L = {
		["title"] = "震荡助手",
		["desc"] = "当一个震荡即将打断你正在施放的法术时发出预警，让你能够及时停止施法以避免遭到反制。",
		["lock position"] = "锁定位置",
		["voice alert"] = "语音报警",
		["predict next quake"] = "预测下一次震荡来临",
		["frame scale"] = "框体缩放",
		["stop casting"] = "停止施法！",
		["test"] = "试听",
		["risk tolerance"] = "风险容忍度",
		["enabled prompt"] = "检测到|cff00ff00震荡|r词缀，报警模块已激活。",
		["disabled prompt"] = "报警模块已休眠。",
	}
end

if GetLocale() == "zhTW" then
	addon.L = {
		["title"] = "震地助手",
		["desc"] = "當一個震地即將打斷你正在施放的法術時發出預警，讓你能夠及時停止施法以避免遭到反制。",
		["lock position"] = "鎖定位置",
		["voice alert"] = "語音報警",
		["predict next quake"] = "預測下一次震地來臨",
		["frame scale"] = "框架縮放",
		["stop casting"] = "停止施法！",
		["test"] = "試聽",
		["risk tolerance"] = "風險容忍度",
		["enabled prompt"] = "檢測到|cff00ff00震地|r詞綴，報警模組已激活。",
		["disabled prompt"] = "報警模組已休眠。",
	}
end
