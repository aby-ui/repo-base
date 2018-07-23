--[[
	shine.lua
		a flare finish effect. Artwork by Renaitre
--]]

local L = OMNICC_LOCALS
local Shine = OmniCC:GetEffect('shine')
local Flare = LibStub('Classy-1.0'):New('Frame', Shine)

Flare.id = 'flare'
Flare.texture = [[Interface\Addons\OmniCC\media\flare]]
Flare.name = L.Flare
Flare.instances = {}

OmniCC:RegisterEffect(Flare)