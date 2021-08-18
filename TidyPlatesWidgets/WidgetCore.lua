TidyPlatesWidgets = {}

----------------------
-- HideIn() - Registers a callback, which hides the specified frame in X seconds
----------------------
do
	local Framelist = {}			-- Key = Frame, Value = Expiration Time
	local Watcherframe = CreateFrame("Frame", nil, nil)
	local WatcherframeActive = false
	local select = select
	local timeToUpdate = 0

	local function CheckFramelist(self)
		local curTime = GetTime()
		if curTime < timeToUpdate then return end
		local framecount = 0
		timeToUpdate = curTime + 1
		-- Cycle through the watchlist, hiding frames which are timed-out
		for frame, expiration in pairs(Framelist) do
			if expiration < curTime then frame:Hide(); Framelist[frame] = nil
			else framecount = framecount + 1 end
		end
		-- If no more frames to watch, unregister the OnUpdate script
		if framecount == 0 then Watcherframe:SetScript("OnUpdate", nil) end
	end

	function TidyPlatesWidgets:HideIn(frame, expiration)
		-- Register Frame
		Framelist[ frame] = expiration
		-- Init Watchframe
		if not WatcherframeActive then
			Watcherframe:SetScript("OnUpdate", CheckFramelist)
			WatcherframeActive = true
		end
	end

end

-- For compatibility:
local DummyFunction = function() end
TidyPlatesWidgets.ResetWidgets = TidyPlates.ResetWidgets
TidyPlatesWidgets.EnableTankWatch = DummyFunction
TidyPlatesWidgets.DisableTankWatch = DummyFunction
TidyPlatesWidgets.EnableAggroWatch = DummyFunction