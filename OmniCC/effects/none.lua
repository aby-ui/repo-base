-- none.lua - no effect
local Addon = _G[...]
local L = _G.OMNICC_LOCALS

local None = Addon.FX:Create("none", L.None)

function None:Run() end
