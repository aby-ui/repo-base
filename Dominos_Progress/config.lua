local _, Addon = ...
local Dominos = LibStub("AceAddon-3.0"):GetAddon("Dominos")
local ConfigVersion = 2

local Config = {}

function Config:Init()
	local db = Dominos.db:RegisterNamespace("ProgressBars", self:GetDefaults())
	local dbVersion = db.global.version or 1

	if dbVersion ~= ConfigVersion then
		self:Upgrade(db, dbVersion, ConfigVersion)

		db.global.version = ConfigVersion
	end

	self.db = db
end

function Config:Upgrade(db, oldVersion, newVersion)
	if oldVersion == 1 then
		local charTable = db and db.sv and db.sv.char
		if type(charTable) ~= "table" then
			return
		end

		for _, charSettings in pairs(charTable) do
			local bars = charSettings.bars
			if type(bars) == "table" then
				for barId, barSettings in pairs(bars) do
					if type(barSettings) == "string" then
						bars[barId] = { mode = barSettings }
					end
				end
			end
		end
	end
end

function Config:GetDefaults()
	return {
		profile = {
			one_bar = true,
			skip_inactive_modes = false,
                gold_goal = 0,
			colors = {
				xp = {0.58, 0, 0.55, 1},
				xp_bonus = {0, 0.39, 0.88},
				honor = {1.0, 0.24, 0, 1},
				artifact = {1, 0.75, 0.45, 0.81},
				azerite = {0.601, 0.8, 0.901, 1},
                     gold = {1, .8431, 0, 1},
                     gold_realm = {1, .9451, .7294, 1}
			}
		},

		char = {
			bars = {
				["**"] = {
				}
			}
		}
	}
end

function Config:SetBarMode(barId, mode)
	local barSettings = self.db.char.bars[barId]

	if type(barSettings) == "table" then
		barSettings.mode = mode
	else
		self.db.char.bars[barId] = {
			["mode"] = mode
		}
	end
end

function Config:GetBarMode(barId)
	local barSettings = self.db.char.bars[barId]

	if type(barSettings) == "table" then
		return barSettings.mode
	else
		return barSettings
	end
end

function Config:SetOneBarMode(enable)
	self.db.profile.one_bar = enable or false
end

function Config:OneBarMode()
	return self.db.profile.one_bar
end

function Config:SetSkipInactiveModes(skip)
	self.db.profile.skip_inactive_modes = skip or false
end

function Config:SkipInactiveModes()
	return self.db.profile.skip_inactive_modes
end

function Config:GoldGoal()
     return self.db.profile.gold_goal
end

function Config:SetGoldGoal(value)
     self.db.profile.gold_goal = value or 0
end

function Config:SetColor(key, ...)
	local color = self.db.profile.colors[key]

	for i = 1, select("#", ...) do
		color[i] = select(i, ...)
	end
end

function Config:GetColor(key)
	return unpack(self.db.profile.colors[key])
end

-- exports
Addon.Config = Config
