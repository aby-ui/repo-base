local _, T = ...
T.Mark = 50

local function noop() end
if GarrisonMissionFrame_SelectTab == nil then
	GarrisonMissionFrame_SelectTab = noop
end
if GarrisonLandingPageTab_OnEnter == nil then
	GarrisonLandingPageTab_OnEnter = noop
end
if GarrisonLandingPageTab_OnLeave == nil then
	GarrisonLandingPageTab_OnLeave = noop
end
local GetFollowerSourceTextByID = C_Garrison.GetFollowerSourceTextByID
function C_Garrison.GetFollowerSourceTextByID(...)
	local ids = ...
	local id = type(ids) == "string" and tonumber(ids)
	if id and (id >= 2^31 or id < -2^31) then
		local x = C_Garrison.GetFollowers(1)
		for k,v in pairs(x) do
			if v.followerID == ids and v.garrFollowerID then
				return GetFollowerSourceTextByID(v.garrFollowerID, select(2, ...))
			end
		end
	end
	return GetFollowerSourceTextByID(...)
end

hooksecurefunc("GarrisonFollowerTooltipTemplate_SetGarrisonFollower", function(fr, data)
	if fr and data and data.level == T.FOLLOWER_LEVEL_CAP and data.quality > 3 then
		fr.XP:Hide()
		fr.XPBar:Hide()
		fr.XPBarBackground:Hide()
	elseif fr and data and data.followerTypeID and data.followerTypeID < 3 and (data.level < T.FOLLOWER_LEVEL_CAP or data.quality <= 3) then
		fr.XP:Show()
		fr.XPBar:Show()
		fr.XPBarBackground:Show()
	end
end)

local function CallOwner(f, ...)
	return f(...)
end
function T.RegisterCallback_OnInitializedFrame(box, f)
	box:RegisterCallback("OnInitializedFrame", CallOwner, f)
	if box:IsVisible() then
		box:ForEachFrame(f)
	end
	if type(box:GetParent().buttonInitializer) == "function" then
		-- GarrisonFollowerList:UpdateData, hiss.
		hooksecurefunc(box:GetParent(), "buttonInitializer", f)
	end
end
