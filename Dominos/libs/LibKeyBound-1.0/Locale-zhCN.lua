--[[
	KeyBound localization file
		Simplified Chinese
--]]

if (GetLocale() ~= "zhCN") then
	return
end

local REVISION = 90000 + tonumber(("$Revision: 97 $"):match("%d+"))
if (LibKeyBoundLocale10 and REVISION <= LibKeyBoundLocale10.REVISION) then
	return
end

LibKeyBoundLocale10 = {
	REVISION = REVISION;
	BindingMode = "按键绑定模式";
	Enabled = "按键绑定模式已启用";
	Disabled = "按键绑定模式已禁用";
	ClearTip = format("按%s清除所有按键绑定", GetBindingText("ESCAPE", "KEY_"));
	NoKeysBoundTip = "当前没有按键绑定";
	ClearedBindings = "从%s移除所有按键绑定";
	BoundKey = "设置%s到%s";
	UnboundKey = "取消按键绑定%s从%s";
	CannotBindInCombat = "不能在战斗状态按键绑定";
	CombatBindingsEnabled = "离开战斗状态，按键绑定模式已启用";
	CombatBindingsDisabled = "进入战斗状态，按键绑定模式已禁用";
	BindingsHelp = "将鼠标停留在按钮上，然后按下欲指定快捷键之后就能绑定。要清除目前绑定的按钮请按%s。";

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
