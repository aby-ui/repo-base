-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print



local IconPosition = TMW:NewClass("GroupModule_IconPosition", "GroupModule")


IconPosition:RegisterGroupDefaults{
	SettingsPerView			= {
		["**"] = {
			SpacingX		= 0,
			SpacingY		= 0,
		}
	},
}

TMW:RegisterUpgrade(60005, {
	group = function(self, gs)
		gs.SettingsPerView.icon.SpacingX = gs.Spacing or 0
		gs.SettingsPerView.icon.SpacingY = gs.Spacing or 0
		gs.Spacing = nil
	end,
})


IconPosition:RegisterConfigPanel_XMLTemplate(30, "TellMeWhen_GM_IconPosition")


function IconPosition:OnEnable()
	TMW:RegisterCallback("TMW_GROUP_SETUP_POST", self)
end

function IconPosition:OnDisable()
	TMW:UnregisterCallback("TMW_GROUP_SETUP_POST", self)
end


function IconPosition:Icon_SetPoint(icon, positionID)
	self:AssertSelfIsInstance()
	
	local group = self.group
	local gspv = group:GetSettingsPerView()
	
	local Columns = group.Columns
	
	local row = ceil(positionID / Columns)
	local column = (positionID - 1) % Columns + 1
	
	local sizeX, sizeY = group.viewData:Icon_GetSize(icon)
	
	
	local position = icon.position
	
	position.relativeTo = group
	position.point, position.relativePoint = "TOPLEFT", "TOPLEFT"
	position.x = (sizeX + gspv.SpacingX)*(column-1)
	position.y = -(sizeY + gspv.SpacingY)*(row-1)
	
	icon:ClearAllPoints()
	icon:SetPoint(position.point, position.relativeTo, position.relativePoint, position.x, position.y)
end

function IconPosition:PositionIcons()
	local group = self.group

	for iconID = 1, group.numIcons do
		local icon = group[iconID]
		self:Icon_SetPoint(icon, icon.ID)
	end
end

local clobberWarned = false
function IconPosition:ClobberCheck(ics)
	if not TMW:DeepCompare(TMW.DEFAULT_ICON_SETTINGS, ics) then
		if not clobberWarned then
			TMW:Print(TMW.L["RESIZE_GROUP_CLOBBERWARN"])
			clobberWarned = true
		end
		return true
	end

	return false -- signal that we don't care about these icon settings.
end

function IconPosition:AdjustIconsForModNumRowsCols(deltaRows, deltaCols)
	-- do nothing for rows

	local group = self.group

	if deltaCols ~= 0 then
		if not group.__iconPosClobbered then
			group.__iconPosClobbered = setmetatable({}, {__index = function(t, k)
	            t[k] = {}
	            return t[k]
			end})
		end

		local columns_old = group.Columns
		local columns_new = group.Columns + deltaCols

		
		local iconsCopy = TMW.shallowCopy(group:GetSettings().Icons)
		wipe(group:GetSettings().Icons)

		for iconID, ics in pairs(iconsCopy) do
			local row_old = ceil(iconID / columns_old)
			local column_old = (iconID - 1) % columns_old + 1

			local row_new = ceil(iconID / columns_new)
			local column_new = (iconID - 1) % columns_new + 1

			local newIconID = iconID + (row_old-1)*deltaCols


		    if column_old > columns_new then
		    	if self:ClobberCheck(ics) then
			        group.__iconPosClobbered[row_old][column_old] = ics
			    end
		    else
		    	group:GetSettings().Icons[newIconID] = ics

		    	if column_old == columns_old then
		    		for i = columns_old + 1, columns_new do
		    			local newIconID = newIconID + i - columns_old
		    			local row_new = ceil(newIconID / columns_new)

		    			group:GetSettings().Icons[newIconID] = group.__iconPosClobbered[row_new][i]
		    		end
		    	end
		    end
		end

		-- Causes a whole lot of warnings that are wrong if we don't do this.
		wipe(TMW.ValidityCheckQueue)
	end
end


function IconPosition:TMW_GROUP_SETUP_POST(event, group)
	if self.group == group then
		self:PositionIcons()
	end
end




