local mod = DBM:NewMod("PortalTimers", "DBM-Party-WotLK", 12)
local L = mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(30658)
mod:SetZone()

mod:RegisterEvents(
	"UPDATE_UI_WIDGET",
	"UNIT_DIED",
	"CHAT_MSG_MONSTER_YELL"
)
mod.noStatistics = true

local warningPortalNow	= mod:NewAnnounce("WarningPortalNow", 2, 57687)
local warningPortalSoon	= mod:NewAnnounce("WarningPortalSoon", 1, 57687)
local warningBossNow	= mod:NewAnnounce("WarningBossNow", 4, 33341)

local timerPortalIn	= mod:NewTimer(122, "TimerPortalIn", 57687, nil, nil, 1)

mod:AddBoolOption("ShowAllPortalTimers", false, "timer")--rate they spawn seems to accelerate slowly over time. thus making timers inaccurate by end of fight

local lastWave = 0

function mod:UPDATE_UI_WIDGET(table)
	local id = table.widgetID
	if id ~= 566 then return end
	local widgetInfo = C_UIWidgetManager.GetIconAndTextWidgetVisualizationInfo(id)
	local text = widgetInfo.text
	if not text then return end
	local wave = text:match("(%d+).+18")
	if not wave then
		wave = 0
	end
	wave = tonumber(wave)
	if wave < lastWave then
		lastWave = 0
	end
	if wave > lastWave then
		warningPortalSoon:Cancel()
		timerPortalIn:Cancel()
		if wave == 6 or wave == 12 or wave == 18 then
			warningBossNow:Show()
		else
			warningPortalNow:Show(wave)
			if self.Options.ShowAllPortalTimers then
				timerPortalIn:Start(122, wave + 1)
				warningPortalSoon:Schedule(112)
			end
		end
		lastWave = wave
	end
end

function mod:UNIT_DIED(args)
	local z = mod:GetCIDFromGUID(args.destGUID)
	if z == 29266 or z == 29312 or z == 29313 or z == 29314 or z == 29315 or z == 29316  		-- bosses
	or z == 32226 or z == 32230 or z == 32231 or z == 32234 or z == 32235 or z == 32237 then 	-- boss spirits (in case you wipe)
		timerPortalIn:Start(20, lastWave + 1)
		warningPortalSoon:Schedule(15)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.Sealbroken or msg:find(L.Sealbroken) then
		self:SendSync("Wipe")
	end
end

function mod:OnSync(msg, arg)
	if msg == "Wipe" then
		warningPortalSoon:Cancel()
		timerPortalIn:Cancel()
	end
end