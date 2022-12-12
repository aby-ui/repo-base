local addonName, Cell = ...
local F = Cell.funcs

Cell.defaults.appearance = {
    ["scale"] = 1,
    ["accentColor"] = {"class_color", {1, 0.26667, 0.4}}, -- FF4466
    ["optionsFontSizeOffset"] = 0,
    ["useGameFont"] = true,
    ["texture"] = "Cell ".._G.DEFAULT,
    ["barColor"] = {"class_color", {0.2, 0.2, 0.2}},
    ["lossColor"] = {"class_color_dark", {0.667, 0, 0}},
    ["deathColor"] = {false, {0.545, 0, 0}},
    ["powerColor"] = {"power_color", {0.7, 0.7, 0.7}},
    ["barAlpha"] = 1,
    ["lossAlpha"] = 1,
    ["bgAlpha"] = 1,
    ["barAnimation"] = "Flash",
    ["auraIconOptions"] = {
        ["animation"] = "duration",
        ["durationRoundUp"] = false,
        ["durationDecimal"] = 0,
        ["durationColorEnabled"] = false,
        ["durationColors"] = {{0,1,0}, {1,1,0,0.5}, {1,0,0,3}},
    },
    ["targetColor"] = {1, 0.31, 0.31, 1},
    ["mouseoverColor"] = {1, 1, 1, 0.6},
    ["highlightSize"] = 1,
    ["outOfRangeAlpha"] = 0.45,
    ["healPrediction"] = {true, false, {1, 1, 1, 0.4}},
    ["useLibHealComm"] = false,
    ["healAbsorb"] = {Cell.isRetail, {1, 0.1, 0.1, 0.9}},
    ["shield"] = {true, {1, 1, 1, 0.4}},
    ["overshield"] = true,
}

local buttonStyleIndices = {
    "texture",
    "barColor",
    "lossColor",
    "powerColor",
    "barAlpha",
    "lossAlpha",
    "deathColor",
    "bgAlpha",
    "barAnimation",
    "auraIconOptions",
    "targetColor",
    "mouseoverColor",
    "highlightSize",
    "outOfRangeAlpha",
    "healPrediction",
    "healAbsorb",
    "shield",
    "overshield",
}
function Cell:ResetButtonStyle()
    for _, index in pairs(buttonStyleIndices) do
        if type(Cell.defaults.appearance[index]) == "table" then
            CellDB["appearance"][index] = F:Copy(Cell.defaults.appearance[index])
        else
            CellDB["appearance"][index] = Cell.defaults.appearance[index]
        end
    end
end