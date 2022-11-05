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

local CreateEdge do
	local edgeSlices = {
		{"TOPLEFT", 0, -1, "BOTTOMRIGHT", "BOTTOMLEFT", 1, 1}, -- L
		{"TOPRIGHT", 0, -1, "BOTTOMLEFT", "BOTTOMRIGHT", -1, 1}, -- R
		{"TOPLEFT", 1, 0, "BOTTOMRIGHT", "TOPRIGHT", -1, -1, ccw=true}, -- T
		{"BOTTOMLEFT", 1, 0, "TOPRIGHT", "BOTTOMRIGHT", -1, 1, ccw=true}, -- B
		{"TOPLEFT", 0, 0, "BOTTOMRIGHT", "TOPLEFT", 1, -1},
		{"TOPRIGHT", 0, 0, "BOTTOMLEFT", "TOPRIGHT", -1, -1},
		{"BOTTOMLEFT", 0, 0, "TOPRIGHT", "BOTTOMLEFT", 1, 1},
		{"BOTTOMRIGHT", 0, 0, "TOPLEFT", "BOTTOMRIGHT", -1, 1}
	}
	function CreateEdge(f, info, bgColor, edgeColor)
		local insets = info.insets
		local es = info.edgeFile and (info.edgeSize or 39) or 0
		if info.bgFile then
			local bg = f:CreateTexture(nil, "BACKGROUND", nil, -7)
			local tileBackground = not not info.tile
			bg:SetTexture(info.bgFile, tileBackground, tileBackground)
			bg:SetPoint("TOPLEFT", (insets and insets.left or 0), -(insets and insets.top or 0))
			bg:SetPoint("BOTTOMRIGHT", -(insets and insets.right or 0), (insets and insets.bottom or 0))
			local n = bgColor or 0xffffff
			bg:SetVertexColor((n - n % 2^16) / 2^16 % 256 / 255, (n - n % 2^8) / 2^8 % 256 / 255, n % 256 / 255, n >= 2^24 and (n - n % 2^24) / 2^24 % 256 / 255 or 1)
		end
		if info.edgeFile then
			local n = edgeColor or 0xffffff
			local r,g,b,a = (n - n % 2^16) / 2^16 % 256 / 255, (n - n % 2^8) / 2^8 % 256 / 255, n % 256 / 255, n >= 2^24 and (n - n % 2^24) / 2^24 % 256 / 255 or 1
			for i=1,#edgeSlices do
				local t, s = f:CreateTexture(nil, "BORDER", nil, -7), edgeSlices[i]
				t:SetTexture(info.edgeFile)
				t:SetPoint(s[1], s[2]*es, s[3]*es)
				t:SetPoint(s[4], f, s[5], s[6]*es, s[7]*es)
				local x1, x2, y1, y2 = 1/128+(i-1)/8, i/8-1/128, 0.0625, 1-0.0625
				if s.ccw then
					t:SetTexCoord(x1,y2, x2,y2, x1,y1, x2,y1)
				else
					t:SetTexCoord(x1, x2, y1, y2)
				end
				t:SetVertexColor(r,g,b,a)
			end
		end
	end
end
T.CreateEdge = CreateEdge

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
