-- Check to make sure we are using a compatible version of GridStatusRaidDebuff.

-- Disable if we are using an incompatible version of GridStatusRaidDebuff.

local GSRDVersion = GetAddOnMetadata("GridStatusRaidDebuff","Version")

GridStatusRD_MoP = {}
GridStatusRD_MoP.rd_version = 0

StaticPopupDialogs["GridStatusRD_Compat"] = {
  text = "GridStatusRaidDebuff is out of date and incompatible. " ..
         "Please upgrade:\n" ..
         "http://www.curse.com/addons/wow/gridstatusraiddebuff-mop",
  button1 = "Close",
  OnAccept = function() end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}

function GridStatusRD_MoP:PrintNotCompat()
	ChatFrame1:AddMessage("GridStatusRD_MoP: Incompatible version of GridStatusRaidDebuff: " .. GSRDVersion)
end

-- With the wrong version of GridStatusRaidDebuff, they already get a pop-up
if GSRDVersion == "v4.99-switch" then
	GridStatusRD_MoP:PrintNotCompat()
	return
end

do
	local a, b = strsplit(".", GSRDVersion) -- e.g. "4", "0", "6"
	GridStatusRD_MoP.rd_version = 100*a + b -- e.g. 40006
end

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
EventFrame:SetScript("OnEvent", function(self, event, ...)
	if GridStatusRD_MoP.rd_version < 502 then
		GridStatusRD_MoP:PrintNotCompat()
		StaticPopup_Show("GridStatusRD_Compat")
	end
end)

