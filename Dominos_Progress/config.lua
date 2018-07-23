local AddonName, Addon = ...
local Dominos = LibStub('AceAddon-3.0'):GetAddon('Dominos')
local ConfigVersion = 1

local Config = {}

function Config:Init()
	local db = Dominos.db:RegisterNamespace('ProgressBars', self:GetDefaults())

	if db.global.version ~= ConfigVersion then
		db.global.version = ConfigVersion
	end

	self.db = db
end

function Config:GetDefaults()
    return {
		profile = {
            one_bar = false,

			colors = {
				xp = {0.58, 0, 0.55, 1},
				xp_bonus = {0, 0.39, 0.88},
				honor = {1.0, 0.24, 0, 1},
				-- honor_bonus = {1.0, 0.71, 0, 1},
				artifact = {1, 0.75, 0.45, 0.81},
				azerite = {0.601, 0.8, 0.901, 1}
			}
		}
	}
end

function Config:SetOneBarMode(enable)
    self.db.profile.one_bar = enable or false
end

function Config:OneBarMode()
    return self.db.profile.one_bar
end

function Config:SetColor(key, ...)
	local color = self.db.profile.colors[key]

	for i = 1, select('#', ...) do
		color[i] = select(i, ...)
	end
end

function Config:GetColor(key)
	return unpack(self.db.profile.colors[key])
end

-- exports
Addon.Config = Config