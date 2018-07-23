TidyPlatesWidgets = {}

----------------------
-- HideIn() - Registers a callback, which hides the specified frame in X seconds
----------------------
do
	local Framelist = {}			-- Key = Frame, Value = Expiration Time
	local Watcherframe = CreateFrame("Frame")
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

----------------------
-- PolledHideIn() - Registers a callback, which polls the frame until it expires, then hides the frame and removes the callback
----------------------

do
	local updateInterval = .5
	local PolledHideIn
	local Framelist = {}			-- Key = Frame, Value = Expiration Time
	local Watcherframe = CreateFrame("Frame")
	local WatcherframeActive = false
	local select = select
	local timeToUpdate = 0

	local function CheckFramelist(self)
		local curTime = GetTime()
		if curTime < timeToUpdate then return end
		local framecount = 0
		timeToUpdate = curTime + updateInterval
		-- Cycle through the watchlist, hiding frames which are timed-out
		for frame, expiration in pairs(Framelist) do
			-- If expired...
			if expiration < curTime then
				if frame.Expire then frame:Expire() end

				frame:Hide()
				Framelist[frame] = nil
				--TidyPlates:RequestDelegateUpdate()		-- Request an Update on Delegate functions, so we can catch when auras fall off
			-- If still active...
			else
				-- Update the frame
				if frame.Poll then frame:Poll(expiration) end
				framecount = framecount + 1
			end
		end
		-- If no more frames to watch, unregister the OnUpdate script
		if framecount == 0 then Watcherframe:SetScript("OnUpdate", nil); WatcherframeActive = false end
	end

	function PolledHideIn(frame, expiration)

		if expiration == 0 then

			frame:Hide()
			Framelist[frame] = nil
		else
			--print("Hiding in", expiration - GetTime())
			Framelist[frame] = expiration
			frame:Show()

			if not WatcherframeActive then
				Watcherframe:SetScript("OnUpdate", CheckFramelist)
				WatcherframeActive = true
			end
		end
	end

	TidyPlatesWidgets.PolledHideIn = PolledHideIn
end




-- For compatibility:
local DummyFunction = function() end
TidyPlatesWidgets.ResetWidgets = TidyPlates.ResetWidgets
TidyPlatesWidgets.EnableTankWatch = DummyFunction
TidyPlatesWidgets.DisableTankWatch = DummyFunction
TidyPlatesWidgets.EnableAggroWatch = DummyFunction






