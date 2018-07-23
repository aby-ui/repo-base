--[[
	KeyBound localization file
		Traditional Chinese
--]]

if (GetLocale() ~= "zhTW") then
	return
end

local REVISION = 90000 + tonumber(("$Revision: 97 $"):match("%d+"))
if (LibKeyBoundLocale10 and REVISION <= LibKeyBoundLocale10.REVISION) then
	return
end

LibKeyBoundLocale10 = {
	REVISION = REVISION;
	BindingMode = "按鍵綁定模式";
	Enabled = "按鍵綁定模式已啟用";
	Disabled = "按鍵綁定模式已停用";
	ClearTip = format("按%s清除所有按鍵綁定", GetBindingText("ESCAPE", "KEY_"));
	NoKeysBoundTip = "目前沒有按鍵綁定";
	ClearedBindings = "從%s移除所有按鍵綁定";
	BoundKey = "設定%s到%s";
	UnboundKey = "取消綁定%s從%s";
	CannotBindInCombat = "無法在戰鬥狀態按鍵綁定";
	CombatBindingsEnabled = "離開戰鬥狀態，按鍵綁定模式已啟用";
	CombatBindingsDisabled = "進入戰鬥狀態，按鍵綁定模式已停用";
	BindingsHelp = "將滑鼠停留在按鈕上，然後按下欲指定快捷鍵之後就能綁定。要清除目前綁定的按鈕請按%s。";

	-- This is the short display version you see on the Button
	["Alt"] = "A",
	["Ctrl"] = "C",
	["Shift"] = "S",
	["NumPad"] = "N",

	["Backspace"] = "BS",
	["Button1"] = "B1",
	["Button2"] = "B2",
	["Button3"] = "B3",
	["Button4"] = "B4",
	["Button5"] = "B5",
	["Button6"] = "B6",
	["Button7"] = "B7",
	["Button8"] = "B8",
	["Button9"] = "B9",
	["Button10"] = "B10",
	["Button11"] = "B11",
	["Button12"] = "B12",
	["Button13"] = "B13",
	["Button14"] = "B14",
	["Button15"] = "B15",
	["Button16"] = "B16",
	["Button17"] = "B17",
	["Button18"] = "B18",
	["Button19"] = "B19",
	["Button20"] = "B20",
	["Button21"] = "B21",
	["Button22"] = "B22",
	["Button23"] = "B23",
	["Button24"] = "B24",
	["Button25"] = "B25",
	["Button26"] = "B26",
	["Button27"] = "B27",
	["Button28"] = "B28",
	["Button29"] = "B29",
	["Button30"] = "B30",
	["Button31"] = "B31",
	["Capslock"] = "Cp",
	["Clear"] = "Cl",
	["Delete"] = "Del",
	["End"] = "En",
	["Home"] = "HM",
	["Insert"] = "Ins",
	["Mouse Wheel Down"] = "WD",
	["Mouse Wheel Up"] = "WU",
	["Num Lock"] = "NL",
	["Page Down"] = "PD",
	["Page Up"] = "PU",
	["Scroll Lock"] = "SL",
	["Spacebar"] = "Sp",
	["Tab"] = "Tb",

	["Down Arrow"] = "Dn",
	["Left Arrow"] = "Lf",
	["Right Arrow"] = "Rt",
	["Up Arrow"] = "Up",
}
	setmetatable(LibKeyBoundLocale10, {__index = LibKeyBoundBaseLocale10})
