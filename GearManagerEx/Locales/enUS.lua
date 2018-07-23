------------------------------------------------------------
-- enUS.lua
--
-- Abin
-- 2011/8/22
------------------------------------------------------------

local _, addon = ...
addon.L = setmetatable({
	["wear set"] = "Wear set",
	["save set"] = "Save set",
	["rename set"] = "Rename set",
	["delete set"] = "Delete set",
	["put into bank"] = "Put into bank",
	["take from bank"] = "Take from bank",
	["wore set"] = "Current equipped set: |cff00ff00%s|r.",
	["quick strip"] = "Quick strip",
	["too fast"] = "You strip/wear too fast, please wait a second to avoid errors.",
	["wore back"] = "Wore back |cff00ff00%d|r items.",
	["stripped off"] = "Stripped off |cff00ff00%d|r items.",
	["tooltip prompt"] = "<Right-click for advanced set options>",
	["set saved"] = "Set |cff00ff00%s|r saved.",
	["bind to"] = "Bind to ",
	["open"] = "Open ",
	["set hotkey"] = "Set Hotkey",
	["name exists"] = "Set name |cff00ff00%s|r already exists, please type a new name.",
	["set renamed"] = "Set |cff00ff00%s|r has been renamed to |cff00ff00%s|r.",
	["label text"] = "Rename set |cff00ff00%s|r to:",
	["toolbar title"] = "Set Toolbar",
	["lock"] = "Lock toolbar",
	["hide tooltip"] = "Hide tooltips",
	["numeric"] = "Numeric mode",
	["button columns"] = "Button columns",
	["scale"] = "Frame scale",
	["spacing"] = "Button spacing",
	["please type value"] = "Please type \"%s\" value (%d-%d):",
	["hide toolbar"] = "Hide toolbar",
	["show toolbar"] = "Show toolbar",
	["reset toolbar"] = "Reset toolbar",

    ["create new"] = "创建套装方案",
    ["tooltip replace"] = "<ALT点击左键替换此套方案>",
}, { __index = function(t, i)
    t[i] = i
    return i
end})
