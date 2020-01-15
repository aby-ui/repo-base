-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local RareScanner = LibStub("AceAddon-3.0"):GetAddon("RareScanner")

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

local ADDON_NAME, private = ...
local MAX_REGISTERS_LOG_WINDOW = 5;
local REGISTER_HEIGHT = 32;
local REGISTER_WIDTH = 250;
local REGISTER_FRAME_WIDTH = REGISTER_WIDTH + 10; -- 10 both borders in sides
local UI_PANEL_DIALOG_TEMPLATE_HEADERS_HEIGHT = 30
local REGISTER_FRAME_HEIGHT = REGISTER_HEIGHT * MAX_REGISTERS_LOG_WINDOW + UI_PANEL_DIALOG_TEMPLATE_HEADERS_HEIGHT; -- 25 header + 5 bottom border
local MAX_ITEMS_LOOT_BAR = 9;

-- Information array
local registry = {}
local registryInCombat = {}

-- Registry window
local rsRegisterFrame = CreateFrame("Frame", "rsRegisterFrame", UIParent, "UIPanelDialogTemplate") 
rsRegisterFrame:SetSize(REGISTER_FRAME_WIDTH, REGISTER_FRAME_HEIGHT)
rsRegisterFrame:SetPoint("CENTER")
rsRegisterFrame:SetMovable(true)
rsRegisterFrame:EnableMouse(true)
rsRegisterFrame.Title:SetText("RareScanner log")
rsRegisterFrame:RegisterForDrag("LeftButton")
rsRegisterFrame:SetScript("OnDragStart", rsRegisterFrame.StartMoving)
rsRegisterFrame:SetScript("OnDragStop", rsRegisterFrame.StopMovingOrSizing)
rsRegisterFrame.buttons = {}
rsRegisterFrame:Hide()
rsRegisterFrameClose:SetScript("OnClick", function(self)
	if (not InCombatLockdown()) then
		-- Close every icon and remove registry
		registry = {}
		
		table.foreach(rsRegisterFrame.buttons, function(index, npcButton)
			npcButton.npcID = nil
			npcButton:Hide()
		end)
		
		rsRegisterFrame:Hide()
	end
end)
rsRegisterFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
rsRegisterFrame:SetScript("OnEvent", function(self, event, ...)
	if (event == "PLAYER_REGEN_ENABLED") then
		-- hide pending buttons
		table.foreach(self.buttons, function(index, npcButton)
			if (npcButton.pendingToHide) then
				rsRegisterFrame:Relocate(npcButton.npcID)
			end
		end)
		
		-- add new registers
		table.foreach(registryInCombat, function(index, register)
			RareScanner:RegisterPreviousButton(register.npcID, register.name, register.iconid)
		end)
		registryInCombat = {}
	end
end)

local buttonsFrame = CreateFrame("Frame", "buttonsFrame", rsRegisterFrame)
buttonsFrame:SetPoint("TOPLEFT", 6, -25)
buttonsFrame:SetPoint("BOTTOMRIGHT", rsRegisterFrame, "BOTTOMRIGHT", -7, 8)

-- Create all button frames and hide
for index=1, MAX_REGISTERS_LOG_WINDOW do 
	local npcButton = _G.CreateFrame("Button", "Register"..index, buttonsFrame, "SecureActionButtonTemplate")
	npcButton:SetSize(REGISTER_WIDTH, REGISTER_HEIGHT)
	npcButton:SetPoint("TOPLEFT", 0, -(REGISTER_HEIGHT * (index - 1)))
	npcButton:SetBackdrop({ tile = true, edgeSize = 16, edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]] })	
	npcButton:SetBackdropBorderColor(0, 0, 0)
	npcButton:SetScript("OnEnter", function(self)
		self:SetBackdropBorderColor(0.9, 0.9, 0.9)
	end)
	npcButton:SetScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0, 0, 0)
	end)
	npcButton:SetAttribute("type", "macro")
	
	-- --------------------- --
	-- Textures
	-- --------------------- --
	npcButton.parentBackground = npcButton:CreateTexture("$parentBackground", "BACKGROUND")
	npcButton.parentBackground:SetTexture([[Interface\AchievementFrame\UI-Achievement-Parchment-Horizontal-Desaturated]])
	npcButton.parentBackground:SetPoint("TOPLEFT",3,-3)
	npcButton.parentBackground:SetPoint("BOTTOMRIGHT",-3,3)

	npcButton.parentLabel = npcButton:CreateFontString("$parentLabel", "OVERLAY", "GameFontHighlightLeft")
	npcButton.parentLabel:SetSize(REGISTER_WIDTH - 60, 16)
	npcButton.parentLabel:SetPoint("TOPLEFT", npcButton, "TOPLEFT", 35, -5)
	
	rsRegisterFrame.buttons[index] = npcButton
	
	-- --------------------- --
	-- Close button icon
	-- --------------------- --
	npcButton.CloseButton = _G.CreateFrame("Button", "CloseButton", npcButton, "UIPanelCloseButton")
	npcButton.CloseButton:SetPoint("BOTTOMRIGHT")
	npcButton.CloseButton:SetSize(24, 24)
	npcButton.CloseButton:SetHitRectInsets(8, 8, 8, 8)
	npcButton.CloseButton:SetScript("OnClick", function(self)
		if (InCombatLockdown()) then
			npcButton.pendingToHide = true
		elseif (npcButton.npcID) then
			rsRegisterFrame:Relocate(npcButton.npcID)
		end
	end)
end

----------------------------------------------
-- Log registry methods
----------------------------------------------
function rsRegisterFrame:Relocate(dropNpcID)
	-- Drops the NPC closed
	if (dropNpcID) then
		table.foreach(registry, function(index, register)
			if (register.npcID == dropNpcID) then
				if (register.timer) then
					register.timer:Cancel()
				end
				
				table.remove(registry, index)
				return
			end
		end)
	end
	
	-- Reload information in proper order
	local numberOrRegisters = 0
	table.foreach(rsRegisterFrame.buttons, function(index, npcButton)
		local currentNPC = registry[index]
		if (registry[index]) then
			npcButton.npcID = currentNPC.npcID
			npcButton.parentLabel:SetText(currentNPC.name)
			npcButton:SetAttribute("macrotext", "/cleartarget\n/targetexact "..currentNPC.name.."\n/tm 8")
			npcButton:Show()
			numberOrRegisters = numberOrRegisters + 1
		else
			npcButton.npcID = nil
			npcButton:Hide()
		end
	end)
	
	if (numberOrRegisters == 0) then
		rsRegisterFrame:Hide()
	else
		rsRegisterFrame:SetHeight(REGISTER_HEIGHT * numberOrRegisters + UI_PANEL_DIALOG_TEMPLATE_HEADERS_HEIGHT)
		rsRegisterFrame:Show()
	end
end

function rsRegisterFrame:AutoHide(npcID)
	table.foreach(rsRegisterFrame.buttons, function(index, npcButton)
		if (npcButton.npcID and npcButton.npcID == npcID) then
			if (not InCombatLockdown()) then
				rsRegisterFrame:Relocate(npcID)
			else
				npcButton.pendingToHide = true
			end
			return
		end
	end)
end

function RareScanner:RegisterPreviousButton(npcID, name, iconid)
	-- If filtered return
	if (not private.db.display.displayLogWindow) then
		return
	end
	
	-- If its a test these variables will be nil
	if (not npcID or not name or not iconid) then
		return
	end
	
	-- It its a container or event skip
	if (iconid == RareScanner.CONTAINER_VIGNETTE or iconid == RareScanner.CONTAINER_ELITE_VIGNETTE or iconid == RareScanner.EVENT_VIGNETTE or iconid == RareScanner.EVENT_ELITE_VIGNETTE) then
		return
	end

	-- If it exists already in the log, ignore it
	local alreadyInTheLog = false;
	table.foreach(registry, function(index, register)
		if (register.npcID == npcID) then
			alreadyInTheLog = true
			return
		end
	end)
	
	if (alreadyInTheLog == true) then
		return
	end
	
	-- If in combat waits until out of combat
	if (InCombatLockdown()) then
		local newRegistry = { npcID = npcID, name = name, iconid = iconid }
		table.insert(registryInCombat, 1, newRegistry);
		return
	end

	-- If not in combat shows the new register right away
	local newRegistry = nil
	if (private.db.display.autoHideLogWindow == 0) then
		newRegistry = { npcID = npcID, name = name }
	else
		newRegistry = { npcID = npcID, name = name, timer = C_Timer.After(private.db.display.autoHideLogWindow * 60, function() 
			rsRegisterFrame:AutoHide(npcID)
		end) }
	end
	
	table.insert(registry, 1, newRegistry);
	
	if (table.getn(registry) > MAX_REGISTERS_LOG_WINDOW) then
		table.remove(registry) --removes last
	end
	
	rsRegisterFrame:Relocate()
end