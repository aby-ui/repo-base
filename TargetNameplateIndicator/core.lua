------------------------------------------------------
-- Configuration variables have moved to config.lua --
--        Do not change anything in this file       --
------------------------------------------------------

-- List globals here for Mikk's FindGlobals script
-- GLOBALS: UnitGUID, print

local addon, ns = ...
local CONFIG = ns.CONFIG

local TNI = CreateFrame("Frame", "TargetNameplateIndicator", UIParent)
TNI:SetIgnoreParentScale(true)

LibStub("LibNameplateRegistry-1.0"):Embed(TNI)

local texture = TNI:CreateTexture("$parentTexture", "OVERLAY")
texture:SetTexture(CONFIG.TEXTURE_PATH)
texture:SetSize(CONFIG.TEXTURE_WIDTH, CONFIG.TEXTURE_HEIGHT)


--[===[@debug@
local DEBUG = false

local function debugprint(...)
	if DEBUG then
		print("TNI DEBUG:", ...)
	end
end

if DEBUG then
	TNI:LNR_RegisterCallback("LNR_DEBUG", debugprint)
end
--@end-debug@]===]

-----
-- Error callbacks
-----
local print, format = print, string.format

local function errorPrint(fatal, formatString, ...)
	local message = "|cffFF0000LibNameplateRegistry has encountered a" .. (fatal and " fatal" or "n") .. " error:|r"
	print("TargetNameplateIndicator:", message, format(formatString, ...))
end

function TNI:OnError_FatalIncompatibility(callback, incompatibilityType)
	local detailedMessage
	if incompatibilityType == "TRACKING: OnHide" or incompatibilityType == "TRACKING: OnShow" then
		detailedMessage = "LibNameplateRegistry missed several nameplate show and hide events."
	elseif incompatibilityType == "TRACKING: OnShow missed" then
		detailedMessage = "A nameplate was hidden but never shown."
	else
		detailedMessage = "Something has gone terribly wrong!"
	end

	errorPrint(true, "(Error Code: %s) %s", incompatibilityType, detailedMessage)
end

TNI:LNR_RegisterCallback("LNR_ERROR_FATAL_INCOMPATIBILITY", "OnError_FatalIncompatibility")

------
-- Nameplate callbacks
------
local CurrentNameplate

function TNI:UpdateIndicator(nameplate)
	CurrentNameplate = nameplate
	texture:ClearAllPoints()

	if nameplate then
		texture:Show()
		texture:SetPoint(CONFIG.TEXTURE_POINT, nameplate, CONFIG.ANCHOR_POINT, CONFIG.OFFSET_X, CONFIG.OFFSET_Y)
	else
		texture:Hide()
	end
end

function TNI:OnTargetPlateOnScreen(callback, nameplate, plateData)
	--[===[@debug@
	debugprint("Callback fired (target found)")
	--@end-debug@]===]

	self:UpdateIndicator(nameplate)
end

function TNI:OnRecyclePlate(callback, nameplate, plateData)
	--[===[@debug@
	debugprint("Callback fired (recycle)", nameplate == CurrentNameplate)
	--@end-debug@]===]

	if nameplate == CurrentNameplate then
		self:UpdateIndicator()
	end
end

function TNI:PLAYER_TARGET_CHANGED()
	local nameplate, plateData = TNI:GetPlateByGUID(UnitGUID("target"))

	--[===[@debug@
	debugprint("Player target changed", nameplate)
	--@end-debug@]===]

	if not nameplate then
		TNI:UpdateIndicator()
	end
end

TNI:LNR_RegisterCallback("LNR_ON_TARGET_PLATE_ON_SCREEN", "OnTargetPlateOnScreen")
TNI:LNR_RegisterCallback("LNR_ON_RECYCLE_PLATE", "OnRecyclePlate")

TNI:RegisterEvent("PLAYER_TARGET_CHANGED")
TNI:SetScript("OnEvent", function(self, event, ...)
	self[event](self, ...)
end)

--[[------------------------------------------------------------
163ui copy for WorldFlightMap
---------------------------------------------------------------]]
local bounceOffset = 5
local bounceDuration = 0.3
local function BounceAnimation(self) -- SetLooping('BOUNCE') is producing broken animations, so we're just simulating what it's supposed to do
	local tx, bounce = self.tx, self.bounce
    local p1, rel, p2, x, y = tx:GetPoint()
    if p1 then tx:ClearAllPoints() end
	if self.up then
		if p1 then tx:SetPoint(p1, rel, p2, CONFIG.OFFSET_X, CONFIG.OFFSET_Y + bounceOffset) end
		bounce:SetSmoothing('OUT')
    else
        if p1 then tx:SetPoint(p1, rel, p2, CONFIG.OFFSET_X, CONFIG.OFFSET_Y) end
		bounce:SetSmoothing('IN')
	end
	bounce:SetOffset(0, self.up and -bounceOffset or bounceOffset)
	self.up = not self.up
	self:Play()
end
--group:SetLooping('REPEAT')
--group:Play()

local group = texture:CreateAnimationGroup()
group.tx = texture

local bounce = group:CreateAnimation('Translation')
bounce:SetOffset(0, bounceOffset)
bounce:SetDuration(bounceDuration)
bounce:SetSmoothing('IN')
group.bounce = bounce
group.up = true
group:SetScript('OnFinished', BounceAnimation)
group:Play()

hooksecurefunc(TNI, "PLAYER_TARGET_CHANGED", function()
    if U1GetCfgValue(addon, "anim") then
        group:Play()
    end
end)


local addon = ...
function TNI:SetOptions()
    if GetAddOnEnableState(U1PlayerName, addon) >=2 then
        texture:SetAlpha(1)
    else
        texture:SetAlpha(0)
    end

    local tex = U1GetCfgValue(addon, "tex")
    if tex == "deadarrow" then
        tex = 'interface/minimap/minimap-deadarrow'
        texture:SetTexCoord(0, 1, 1, 0)
    else
        tex = "Interface\\AddOns\\"..addon.."\\Textures\\".. tex
        texture:SetTexCoord(0, 1, 0, 1)
    end

    CONFIG.TEXTURE_PATH = tex

    CONFIG.TEXTURE_HEIGHT = U1GetCfgValue(addon, "size")
    CONFIG.TEXTURE_WIDTH = CONFIG.TEXTURE_HEIGHT
    --local TEXTURE_POINT = "BOTTOM"
    --local ANCHOR_POINT  = "TOP"
    CONFIG.OFFSET_X = U1GetCfgValue(addon, "x")
    CONFIG.OFFSET_Y = U1GetCfgValue(addon, "y")

    texture:SetTexture(CONFIG.TEXTURE_PATH)
    texture:SetSize(CONFIG.TEXTURE_WIDTH, CONFIG.TEXTURE_HEIGHT)
    local nameplate = select(2, texture:GetPoint())
    if nameplate then
        texture:SetPoint(CONFIG.TEXTURE_POINT, nameplate, CONFIG.ANCHOR_POINT, CONFIG.OFFSET_X, CONFIG.OFFSET_Y)
    end

    if U1GetCfgValue(addon, "anim") then
        group:Play()
        group:SetScript('OnFinished', BounceAnimation)
    else
        group:Stop()
        group:SetScript('OnFinished', nil)
    end
end
