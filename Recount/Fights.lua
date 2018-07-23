local Recount = _G.Recount

local revision = tonumber(string.sub("$Revision: 1256 $", 12, -3))
if Recount.Version < revision then
	Recount.Version = revision
end

local date = date
local math = math
local pairs = pairs
local string = string
local tonumber = tonumber

local Fights = {}
Recount.Fights = Fights

function Fights:CopyCurrentFights()
	for _, v in pairs(Recount.db2.combatants) do
		--v.Fights.LastFightData = v.Fights.CurrentFightData -- Copy current even for short fights
		Recount:ResetFightData(v.Fights["CurrentFightData"])
	end
end

function Fights:MoveFights()
	local ReuseFight

	if not Recount.db.profile.SegmentBosses or Recount.FightingLevel == -1 then
		for i = math.min(#Recount.db2.FoughtWho, Recount.db.profile.MaxFights - 1), 1, -1 do
			Recount.db2.FoughtWho[i + 1] = Recount.db2.FoughtWho[i]
		end
		Recount.db2.FoughtWho[1] = Recount.FightingWho.." "..Recount.InCombatF.."-"..date("%H:%M:%S")
	end

	for k, v in pairs(Recount.db2.combatants) do
		--ReuseFight = v.Fights.LastFightData
		ReuseFight = nil

		v.Fights.LastFightData = v.Fights.CurrentFightData

		if not Recount.db.profile.SegmentBosses or Recount.FightingLevel == -1 then
			v.FightsSaved = v.FightsSaved or 0
			if v.FightsSaved == Recount.db.profile.MaxFights then
				ReuseFight = v.Fights["Fight"..v.FightsSaved]
			end
			v.FightsSaved = v.FightsSaved or 0
			for i = math.min(v.FightsSaved, Recount.db.profile.MaxFights - 1), 1, -1 do
				v.Fights["Fight"..i + 1] = v.Fights["Fight"..i]
			end

			if v.LastFightIn == Recount.db2.FightNum then
				v.Fights["Fight1"] = v.Fights.CurrentFightData
			else
				v.Fights["Fight1"] = nil
			end

			if v.FightsSaved < Recount.db.profile.MaxFights then
				v.FightsSaved = v.FightsSaved + 1
			end
		end

		if not ReuseFight or ReuseFight == v.Fights.LastFightData then
			v.Fights["CurrentFightData"] = Recount:GetTable()
			Recount:InitFightData(v.Fights["CurrentFightData"])
		else
			Recount:ResetFightData(ReuseFight)
			v.Fights["CurrentFightData"] = ReuseFight
		end
	end

	if RecountDeathTrack then
		RecountDeathTrack:CopyFight()
	end

	--Main Window Display Cache needs to be reset should fix several bugs
	Recount:FullRefreshMainWindow() -- Elsia: Made a function for this as it's also needed for deleting combatants and refreshing when options change

	local FightNum = tonumber(string.match(Recount.db.profile.CurDataSet, "Fight(%d+)"))

	if FightNum then
		Recount.FightName = Recount.db2.FoughtWho[FightNum]
	end
end

function Fights:DeleteOverflowFights(newmax)
	for k, v in pairs(Recount.db2.combatants) do
		for i = newmax + 1, Recount.db.profile.MaxFights, 1 do
			v.Fights["Fight"..i] = nil
			Recount.db2.FoughtWho[i] = nil
			if RecountDeathTrack then
				RecountDeathTrack:DeleteDeathTrackEntry(i)
			end
		end
	end
end

function Fights:RemoveFight(num)
end

function Fights:ChangeFightNum(num)
end
