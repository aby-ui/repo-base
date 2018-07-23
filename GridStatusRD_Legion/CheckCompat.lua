-- Check to make sure we are using a compatible version of GridStatusRaidDebuff.

-- Disable if we are using an incompatible version of GridStatusRaidDebuff.

local GSRDVersion = GetAddOnMetadata("GridStatusRaidDebuff","Version")

GridStatusRD_Legion = {}
GridStatusRD_Legion.rd_version = 0

function GridStatusRD_Legion:PrintNotCompat()
	ChatFrame1:AddMessage("GridStatusRD_Legion: Incompatible version of GridStatusRaidDebuff: " .. GSRDVersion)
end

-- With v4.99-switch version of GridStatusRaidDebuff, they already get a pop-up to upgrade
if GSRDVersion == "v4.99-switch" then
	GridStatusRD_Legion:PrintNotCompat()
	return
end

do
	local a, b = strsplit(".", GSRDVersion) -- e.g. "4", "0", "6"
	GridStatusRD_Legion.rd_version = 100*a + b -- e.g. 40006
end

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
EventFrame:SetScript("OnEvent", function(self, event, ...)
	if GridStatusRD_Legion.rd_version < 700 then
		GridStatusRD_Legion:PrintNotCompat()
	end
end)

