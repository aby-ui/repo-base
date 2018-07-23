local Recount = _G.Recount

local SM = LibStub:GetLibrary("LibSharedMedia-3.0")

local revision = tonumber(string.sub("$Revision: 1254 $", 12, -3))
if Recount.Version < revision then
	Recount.Version = revision
end

local pairs = pairs

local FontStrings = {}
local FontFile

--First thing first need to add fonts
--SM:Register("font", "Vera", [[Interface\AddOns\Recount\Fonts\Vera.ttf]])
-- removed ABF.ttf by request from Curse (Arrowmaster)
-- tried DejaVu, crashes client if resized too big
-- tried Bitstream Vera, crashes client if resized too big
-- Hence reverting to Arial Narrow as default font, sorry.

function Recount:AddFontString(string)
	local Font, Height, Flags

	FontStrings[#FontStrings + 1] = string

	if not FontFile and Recount.db.profile.Font then
		FontFile = SM:Fetch("font", Recount.db.profile.Font)
	end

	if FontFile then
		Font, Height, Flags = string:GetFont()
		if Font ~= FontFile then
			string:SetFont(FontFile, Height, Flags)
		end
	end
end

function Recount:SetFont(fontname)
	local Height, Flags

	Recount.db.profile.Font = fontname
	FontFile = SM:Fetch("font", fontname)

	for _, v in pairs(FontStrings) do
		_, Height, Flags = v:GetFont()
		v:SetFont(FontFile, Height, Flags)
	end
end
