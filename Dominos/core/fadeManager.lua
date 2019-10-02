--[[
	fadeManager.lua
		Handles fading out frames when not moused over
		Necessary since using the blizzard fading functions can cause issues in combat
--]]
local _, Addon = ...
local After = C_Timer.After

local MouseOverWatcher = {}
local watched = {}

function MouseOverWatcher:Update()
	for f in pairs(watched) do
		if f:IsFocus() then
			if not f.focused then
				f.focused = true
				f:Fade()
			end
		else
			if f.focused then
				f.focused = nil
				f:Fade()
			end
		end
	end

	if next(watched) then
		self:RequestUpdate()
	end
end

function MouseOverWatcher:RequestUpdate()
	if not self.__Update then
		self.__Update = function()
			self.__Waiting = false
			self:Update()
		end
	end

	if not self.__Waiting then
		self.__Waiting = true
		After(0.15, self.__Update)
	end
end

function MouseOverWatcher:Add(f)
	if not watched[f] then
		watched[f] = true

		f.focused = f:IsFocus() and true or nil
		f:UpdateAlpha()

		self:RequestUpdate()
	end
end

function MouseOverWatcher:Remove(f)
	if watched[f] then
		watched[f] = nil

		f.focused = nil
		f:UpdateAlpha()
	end
end

-- exports
Addon.MouseOverWatcher = MouseOverWatcher
