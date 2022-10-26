local AddonName, Data = ...
local BattleGroundEnemies = BattleGroundEnemies
local L = Data.L

local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local LibDeflate = LibStub("LibDeflate")
local LibSerialize = LibStub("LibSerialize")


local ButtonFrameTemplate_HidePortrait = ButtonFrameTemplate_HidePortrait
local CreateFrame = CreateFrame


local function CreateImportExportFrame()
	local frame = CreateFrame("Frame", "dsafsdafdsafdsafsdaf", UIParent, "ButtonFrameTemplate")
	frame:SetFrameStrata("TOOLTIP") -- to make it appear above the options panel


	ButtonFrameTemplate_HidePortrait(frame)

	frame.Inset:SetPoint("TOPLEFT", 4, -25)

	-- frame:EnableMouse(true)

	frame:SetSize(500, 500)
	frame:SetPoint("CENTER")
	-- frame:SetMovable(true)
	-- frame:RegisterForDrag("LeftButton")
	-- frame:SetScript("OnDragStart", frame.StartMoving)
	-- frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

	frame.scrollBar = CreateFrame("ScrollFrame", nil, frame.Inset, "UIPanelScrollFrameTemplate")
	frame.scrollBar:SetPoint("TOPLEFT", 10, -6)
	frame.scrollBar:SetPoint("BOTTOMRIGHT", -27, 6)

	frame.EditBox = CreateFrame("EditBox")
	frame.EditBox:SetMultiLine(true)
	frame.EditBox:SetSize(frame.scrollBar:GetWidth(), 170)
	frame.EditBox:SetPoint("TOPLEFT", frame.scrollBar)
	frame.EditBox:SetPoint("BOTTOMRIGHT", frame.scrollBar)
	frame.EditBox:SetMaxBytes(nil);
	frame.EditBox:SetFontObject(GameFontNormal)
	frame.EditBox:SetAutoFocus(false)
	frame.EditBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

	frame.scrollBar:SetScrollChild(frame.EditBox)

	if DoesTemplateExist("SharedButtonSmallTemplate") then
		frame.Button = CreateFrame("Button", nil, frame, "SharedButtonSmallTemplate")
	else
		frame.Button = CreateFrame("Button", nil, frame, "MagicButtonTemplate")
	end

	frame.Button:SetSize(80, 22)
	frame.Button:SetPoint("BOTTOMRIGHT", -4, 4)
	frame.Button:SetScript("OnClick", function(self)

		if frame.mode == "Import" then
			local stringg = frame.EditBox:GetText()
			if not stringg or stringg == "" then
				return BattleGroundEnemies:Information("Empty input, please enter a exported string here.")
			end
			local data = BattleGroundEnemies:ReceivePrintData(stringg)
			BattleGroundEnemies.db.profile = data

			BattleGroundEnemies:NotifyChange()
		end
		frame:Hide()
	end)

	return frame
end


function BattleGroundEnemies:ImportExportFrameSetupForMode(mode, exportString)
	self.ImportExportFrame = self.ImportExportFrame or CreateImportExportFrame()
	if self.ImportExportFrame.SetTitle then
		self.ImportExportFrame:SetTitle(AddonName..": "..mode)
	else
		--workaround for TBCC
		self.ImportExportFrame.TitleText:SetText(AddonName..": "..mode)
	end
	if mode == "Import" then
		self.ImportExportFrame.Button:SetText(L.Import)
		self.ImportExportFrame.EditBox:SetText("")
		self.ImportExportFrame.EditBox:SetAutoFocus(true)
	else
		self.ImportExportFrame.Button:SetText(CLOSE)
		self.ImportExportFrame.EditBox:SetText(exportString)
		self.ImportExportFrame.EditBox:HighlightText()
	end
	self.ImportExportFrame.mode = mode
	self.ImportExportFrame:Show()
end



local function SerializeAndCompress(data)
	local serialized = LibSerialize:Serialize(data)
	if not serialized then
		return BattleGroundEnemies:Information("An serialization error happened")
	end
	local compressed = LibDeflate:CompressDeflate(serialized)
	if not compressed then
		return BattleGroundEnemies:Information("An compression error happened")
	end
	return compressed
end

local function DecompressAndDeserialize(decoded)
	if not decoded then
		return BattleGroundEnemies:Information("An decoding error happened")
	end
	local decompressed = LibDeflate:DecompressDeflate(decoded)
    if not decompressed then
		return BattleGroundEnemies:Information("An decompressing error happened")
	end
    local success, data = LibSerialize:Deserialize(decompressed)
    if not success then
		return BattleGroundEnemies:Information("An deserialization error happened")
	end
	return data
end


-- With compression (recommended):
function BattleGroundEnemies:ExportDataViaAddonMessage(data)
    local compressed = SerializeAndCompress(data)
    local encoded = LibDeflate:EncodeForWoWAddonChannel(compressed)
	if not encoded then
		return BattleGroundEnemies:Information("An encoding error happened")
	end
   -- self:SendCommMessage("MyPrefix", encoded, "WHISPER", UnitName("player"))
end

function BattleGroundEnemies:ReceiveAddonMessageData(prefix, payload, distribution, sender)
	return DecompressAndDeserialize(LibDeflate:DecodeForWoWAddonChannel(payload))
    -- Handle `data`
end

function BattleGroundEnemies:ExportDataViaPrint(data)
    local compressed = SerializeAndCompress(data)
	local encoded = LibDeflate:EncodeForPrint(compressed)

	if not encoded then
		return BattleGroundEnemies:Information("An encoding error happened")
	end

	self:ImportExportFrameSetupForMode("Export", encoded)

    --self:SendCommMessage("MyPrefix", encoded, "WHISPER", UnitName("player"))
end



function BattleGroundEnemies:ReceivePrintData(string)
    return DecompressAndDeserialize(LibDeflate:DecodeForPrint(string))
end