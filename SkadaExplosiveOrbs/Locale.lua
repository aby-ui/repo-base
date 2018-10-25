local addonName, vars = ...
local Ld, La = {}, {}
local locale = GAME_LOCALE or GetLocale()

vars.L = setmetatable({},{
    __index = function(t, s) return La[s] or Ld[s] or rawget(t,s) or s end
})

Ld["Explosive Orbs"] = "Explosive Orbs"

if locale == "zhCN" then do end
La["Explosive Orbs"] = "易爆打球"
La["Number of player spells"] = "技能次数"

end
