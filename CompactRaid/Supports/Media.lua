------------------------------------------------------------
-- Media.lua
--
-- Abin
-- 2012/3/27
------------------------------------------------------------

local _, addon = ...

local DEFAULT_MEDIAS = {
	font = STANDARD_TEXT_FONT,
	statusbar = "Interface\\BUTTONS\\WHITE8X8.BLP",
	border = "Interface\\Tooltips\\UI-Tooltip-Border",
	background = "Interface\\DialogFrame\\UI-DialogBox-Background",
}

local mediaList = {}

function addon:GetDefaultMedia(category)
	return DEFAULT_MEDIAS[category]
end

function addon:GetMedia(category)
	return mediaList[category]
end

function addon:SetMedia(category, media)
	local default = DEFAULT_MEDIAS[category]
	if not default then
		return
	end

	if not self:VerifyMedia(category, media) then
		media = default
	end

	if mediaList[category] ~= media then
		mediaList[category] = media
		addon:BroadcastEvent("OnMediaChange", category, media)
	end

	return media
end

-- Objects for validating medias
local frame = CreateFrame("Frame")
local testTexture = frame:CreateTexture(nil, "BACKGROUND")
local testFont = frame:CreateFontString(nil, "BACKGROUND", "GameFontNormal")

function addon:VerifyMedia(category, media)
	local valid
	if type(media) == "string" then
		if category == "statusbar" or category == "border" or category == "background" then
			valid = testTexture:SetTexture(media)
		elseif category == "font" then
			valid = testFont:SetFont(media, 10)
		end
	end
	return valid
end

do
	local k, v
	for k, v in pairs(DEFAULT_MEDIAS) do
		mediaList[k] = v
	end
end