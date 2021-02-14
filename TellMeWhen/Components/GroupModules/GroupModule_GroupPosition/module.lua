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


local GroupPosition = TMW:NewClass("GroupModule_GroupPosition", "GroupModule")

GroupPosition:RegisterGroupDefaults{
	Locked  = false,
	Scale   = 2.0,
	Level   = 10,
	Strata  = "MEDIUM",

	Point = {
		point         = "CENTER",
		relativeTo    = "UIParent",
		relativePoint = "CENTER",
		x             = 0,
		y             = 0,
	},
}

TMW:RegisterUpgrade(41402, {
	group = function(self, gs)
		gs.Point.defined = nil
	end,
})


GroupPosition:RegisterConfigPanel_XMLTemplate(10, "TellMeWhen_GM_GroupPosition")


local function GetAnchoredPoints(group, wasMove)
	local _
	local gs = group:GetSettings()
	local p = gs.Point

	local relframe = TMW.GUIDToOwner[p.relativeTo] or _G[p.relativeTo] or UIParent
	local point, relativePoint = p.point, p.relativePoint

	if relframe == UIParent and wasMove and not gs.ShrinkGroup then
		-- use the smart anchor points provided by UIParent anchoring if it is being used
		-- Don't do this for shrunk groups, per https://github.com/ascott18/TellMeWhen/issues/1811
		point, _, relativePoint = group:GetPoint(1)
	end


	local x1, x2, y1, y2
	if point:find("LEFT") then
		x1 = group:GetLeft()
	elseif point:find("RIGHT") then
		x1 = group:GetRight()
	else
		x1 = group:GetCenter()
	end
	if point:find("TOP") then
		y1 = group:GetTop()
	elseif point:find("BOTTOM") then
		y1 = group:GetBottom()
	else
		_, y1 = group:GetCenter()
	end


	if relativePoint:find("LEFT") then
		x2 = relframe:GetLeft()
	elseif relativePoint:find("RIGHT") then
		x2 = relframe:GetRight()
	else
		x2 = relframe:GetCenter()
	end
	if relativePoint:find("TOP") then
		y2 = relframe:GetTop()
	elseif relativePoint:find("BOTTOM") then
		y2 = relframe:GetBottom()
	else
		_, y2 = relframe:GetCenter()
	end



	x1 = x1*group:GetEffectiveScale()
	y1 = y1*group:GetEffectiveScale()
	x2 = x2*relframe:GetEffectiveScale()
	y2 = y2*relframe:GetEffectiveScale()


	local factor = group:GetEffectiveScale()
	
	if TMW:ParseGUID(p.relativeTo) then
		return point, p.relativeTo, relativePoint, (x1-x2)/factor, (y1-y2)/factor
	else
		return point, relframe:GetName(), relativePoint, (x1-x2)/factor, (y1-y2)/factor
	end
end

TMW_CursorAnchor = CreateFrame("Frame", "TMW_CursorAnchor", UIParent)
function TMW_CursorAnchor:Initialize()
	self:SetSize(24, 24)
	self:SetFrameStrata("HIGH")
	self:SetFrameLevel(100)

	-- Text
	self.icon = self:CreateTexture(nil, "ARTWORK", nil, 7)
	self.icon:SetAllPoints()
	self.icon:SetTexture("Interface/CURSOR/Point")
	self.icon:SetVertexColor(1, .1, .6)

	self.fs = TMW_CursorAnchor:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
	self.fs:SetPoint("TOP", self, "BOTTOM", 0, 13)
	self.fs:SetText("TMW")
	self.fs:SetFont(self.fs:GetFont(), 8, "THINOUTLINE")


	self:SetMovable(true)
	self:RegisterForDrag("LeftButton")
	self:SetScript("OnSizeChanged", self.CheckState)

	self:SetScript("OnDragStart", self.StartMoving)
	self:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()

		TMW.IE.db.profile.CursorAnchorPoint = {self:GetPoint()}
		TMW.IE.db.profile.CursorAnchorPoint[2] = nil -- don't store the parent. Its always UIParent.
	end)

	TMW:RegisterCallback("TMW_GLOBAL_UPDATE_POST", self, "CheckState")

	self:CheckState()

	self.Initialize = TMW.NULLFUNC
end


TMW:RegisterCallback("TMW_OPTIONS_LOADING", function()
	TMW.IE:RegisterDatabaseDefaults({
		profile = {
			CursorAnchorPoint = {
				"CENTER", nil, "CENTER", 0, 100,
			}
		}
	})
end)

function TMW_CursorAnchor:Start()
	self.Started = true
end

function TMW_CursorAnchor:CheckState()
	self:ClearAllPoints()

	self:SetScale(1/UIParent:GetScale())

	if TMW.Locked or not TMW.IE  then
		self:SetClampedToScreen(false)
		self.icon:Hide()
		self.fs:Hide()

		if self.Started then
			self:SetScript("OnUpdate", self.OnUpdate)
		end

		self:EnableMouse(false)
		TMW:TT(self, nil, nil)

	else
		self:SetClampedToScreen(true)
		self.icon:Show()
		self.fs:Show()
		self:SetScript("OnUpdate", nil)

		self:EnableMouse(true)
		TMW:TT(self, "ANCHOR_CURSOR_DUMMY", "ANCHOR_CURSOR_DUMMY_DESC")

		if TMW.IE then
			self:SetPoint(unpack(TMW.IE.db.profile.CursorAnchorPoint))
		else
			self:SetPoint("CENTER", 0, 100)
		end
	end
end

local warnedFstack = false
function TMW_CursorAnchor:OnUpdate()
	local x, y = GetCursorPosition()
	if FrameStackTooltip and FrameStackTooltip:IsShown() then
		x = x + 1
		y = y - 1
		if not warnedFstack then
			warnedFstack = true
			TMW:Print("Framestack detected. Shifting cursor anchor by 1px while fstack is up so it isn't in the way.")
		end
	end
	local scale = self:GetEffectiveScale()

	self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x/scale, y/scale)
end
TMW_CursorAnchor:Initialize()



function GroupPosition:OnEnable()
	self:SetPos()
end

function GroupPosition:OnDisable()
	TMW:UnregisterCallback("TMW_ONUPDATE_TIMECONSTRAINED_PRE", self, "DetectFrame")
end


function GroupPosition:DetectFrame(event, time, Locked)
	local frameToFind = self.frameToFind
	
	if TMW.GUIDToOwner[frameToFind] or _G[frameToFind] then
		self:SetPos()
		TMW:UnregisterCallback("TMW_ONUPDATE_TIMECONSTRAINED_PRE", self, "DetectFrame")
	end
end

function GroupPosition:UpdatePositionAfterMovement(wasMove)
	local group = self.group
	
	local gs = group:GetSettings()
	local p = gs.Point
	
	-- This may fail if the region is "restricted"
	-- (https://us.forums.blizzard.com/en/wow/t/ui-changes-in-rise-of-azshara/202487)
	-- Seems to be no way to determine restrictedness other than
	-- do a restricted call and see if it fails.

	local success, point, relativeTo, relativePoint, x, y = pcall(GetAnchoredPoints, group, wasMove)
	if success then
		p.point, p.relativeTo, p.relativePoint, p.x, p.y =
			point, relativeTo, relativePoint, x, y
	elseif wasMove then
		-- Only print this on a move.
		-- Non-moves happen when a user changes the target/point/relativePoint
		-- in the settings UI. We don't want to warn that we can't "fix up" the position,
		-- since not being able to do that is fairly harmless.
		TMW:Print(L["GROUP_CANNOT_INTERACTIVELY_POSITION"]:format(group:GetGroupName()))
	end
	
	self:SetPos()
	
	group:Setup()
	TMW.IE:LoadGroup(1)
end

function GroupPosition:SetNewScale(newScale)
	local group = self.group 
	local oldScale = group:GetScale()

	local p, rt, rp, oldX, oldY = group:GetPoint()

	local newX = oldX * oldScale / newScale
	local newY = oldY * oldScale / newScale


	group:SetPoint(p, rt, rp, newX, newY)

	group:GetSettings().Scale = newScale
	group:SetScale(newScale)

	self:UpdatePositionAfterMovement()
end

function GroupPosition:CanMove()

	local canQuerySize = pcall(self.group.GetLeft, self.group)
	if not canQuerySize then
		return false
	end

	-- Reset this to true. Blizzard sets it false when a frame becomes restricted.
	self.group:SetMovable(true)

	if not self.group:IsMovable() then return false end

	return not self.group:GetSettings().Locked
end


function GroupPosition:CalibrateAnchors()
end

function GroupPosition:SetPos()
	local group = self.group
	
	local gs = group:GetSettings()
	local p = gs.Point
	
	group:ClearAllPoints()
	
	if p.relativeTo == "" then
		p.relativeTo = "UIParent"
	end
	
	local relativeTo = p.relativeTo

	if relativeTo:lower() == "cursor" then
		relativeTo = "TMW_CursorAnchor"
	end

	relativeTo = TMW.GUIDToOwner[relativeTo] or _G[relativeTo]
	
	if not relativeTo then
		self.frameToFind = p.relativeTo
		TMW:RegisterCallback("TMW_ONUPDATE_TIMECONSTRAINED_PRE", self, "DetectFrame")
		group:SetPoint("CENTER", UIParent)
	else
		if relativeTo == TMW_CursorAnchor then
			TMW_CursorAnchor:Start()
		end

		local success, err = pcall(group.SetPoint, group, p.point, relativeTo, p.relativePoint, p.x, p.y)
		if not success then
			TMW:Error(err)
			
			if err:find("trying to anchor to itself") then
				TMW:Print(L["ERROR_ANCHORSELF"]:format(L["fGROUP"]):format(group:GetGroupName(1)))

			elseif err:find("dependent on this") then
				local thisName = L["fGROUP"]:format(group:GetGroupName(1))
				local relativeToName

				if relativeTo.class == TMW.Classes.Group then
					relativeToName = L["fGROUP"]:format(relativeTo:GetGroupName(1))
				else
					relativeToName = relativeTo:GetName()
				end

				TMW:Print(L["ERROR_ANCHOR_CYCLICALDEPS"]:format(thisName, relativeToName, relativeToName, thisName))
			end

			p.relativeTo = "UIParent"
			p.point = "CENTER"
			p.relativePoint = "CENTER"
			p.x = 0
			p.y = 0

			return self:SetPos()
		end
	end
	
	-- For some reason this was 1 on one of my groups, which caused some issues with animations
	gs.Level = max(gs.Level, 5)

	group:SetFlattensRenderLayers(true)
	group:SetFrameStrata(gs.Strata)
	group:SetFrameLevel(gs.Level)
	group:SetScale(gs.Scale)
	--group:SetToplevel(true)
end

function GroupPosition:Reset()
	local group = self.group
	local gs = group:GetSettings()
	
	for k, v in pairs(TMW.Group_Defaults.Point) do
		gs.Point[k] = v
	end

	gs.Level = TMW.Group_Defaults.Level
	gs.Scale = 1
	gs.Locked = TMW.Group_Defaults.Locked
	gs.Strata = TMW.Group_Defaults.Strata
	
	group:Setup()
	
	TMW.IE:LoadGroup(1)
end

