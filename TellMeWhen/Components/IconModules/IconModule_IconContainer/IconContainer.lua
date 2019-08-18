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

local IconContainer = TMW:NewClass("IconModule_IconContainer", "IconModule")

IconContainer:RegisterAnchorableFrame("IconContainer")

function IconContainer:OnNewInstance_IconContainer(icon)	
	local container = CreateFrame("Button", self:GetChildNameBase() .. "IconContainer", icon)
	
	container:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
	container:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress")

	self.container = container
	
	container:EnableMouse(false)
end

function IconContainer:OnEnable()
	local icon = self.icon
	local container = self.container
	
	if not container:IsShown() then
		container:Show()
	end
	
	container:SetFrameLevel(icon:GetFrameLevel())
end

function IconContainer:OnDisable()
	self:SetBorder(0, "ffffffff")
end

function IconContainer:OnDisableDelayed()
	self.container:Hide()
end

function IconContainer:SetBorder(size, color, inset)
	if not self.border and size ~= 0 then
		self.border = CreateFrame("Frame", nil, self.container, "TellMeWhen_GenericBorder")
	end

	if inset then size = -size end

	if self.border then
		self.border:SetBorderSize(size)
		self.border:SetColor(TMW:StringToRGBA(color))
	end
end





--Overlay stuff, copied from Blizz code.
-- We use our own instance of the code to prevent taint.
local unusedOverlayGlows = {}
local numOverlays = 0

local function OverlayGlowAnimOutFinished(animGroup)
	local overlay = animGroup:GetParent();
	local actionButton = overlay:GetParent();
	overlay:Hide();
	tinsert(unusedOverlayGlows, overlay);
	actionButton.overlay = nil;
end
local function OverlayOnHide(overlay)
	if ( overlay.animOut:IsPlaying() ) then
		overlay.animOut:Stop();
		OverlayGlowAnimOutFinished(overlay.animOut);
	end
end

function IconContainer:GetOverlayGlow()
	local overlay = tremove(unusedOverlayGlows);
	if ( not overlay ) then
		numOverlays = numOverlays + 1;
		overlay = CreateFrame("Frame", "TMW_ActionButtonOverlay" .. numOverlays, UIParent, "ActionBarButtonSpellActivationAlert");


		-- Override scripts from the blizzard template:
		-- We do this so we don't have to duplicate the template as well.
		overlay.animOut:SetScript("OnFinished", OverlayGlowAnimOutFinished)
		overlay:SetScript("OnHide", OverlayOnHide)
	end
	return overlay;
end

function IconContainer:ShowOverlayGlow()
	local IconModule_IconContainer = self
	self = self.container

	if ( self.overlay ) then
		if ( self.overlay.animOut:IsPlaying() ) then
			self.overlay.animOut:Stop();
			self.overlay.animIn:Play();
		end
	else
		self.overlay = IconModule_IconContainer:GetOverlayGlow();
		local frameWidth, frameHeight = self:GetSize();
		self.overlay:SetParent(self);
		self.overlay:ClearAllPoints();
		--Make the height/width available before the next frame:
		self.overlay:SetSize(frameWidth * 1.4, frameHeight * 1.4);
		self.overlay:SetPoint("TOPLEFT", self, "TOPLEFT", -frameWidth * 0.2, frameHeight * 0.2);
		self.overlay:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", frameWidth * 0.2, -frameHeight * 0.2);
		self.overlay.animIn:Play();
	end
end

function IconContainer:HideOverlayGlow()
	self = self.container

	if ( self.overlay ) then
		if ( self.overlay.animIn:IsPlaying() ) then
			self.overlay.animIn:Stop();
		end
		if ( self:IsVisible() ) then
			self.overlay.animOut:Play();
		else
			OverlayGlowAnimOutFinished(self.overlay.animOut);	--We aren't shown anyway, so we'll instantly hide it.
		end
	end
end


IconContainer:RegisterEventHandlerData("Animations", 60, "ACTVTNGLOW", {
	text = L["ANIM_ACTVTNGLOW"],
	desc = L["ANIM_ACTVTNGLOW_DESC"],
	ConfigFrames = {
		"Duration",
		"Infinite",
		"Scale"
	},

	Play = function(icon, eventSettings)
		icon:Animations_Start{
			eventSettings = eventSettings,
			Start = TMW.time,
			Scale = eventSettings.Scale,
			Duration = eventSettings.Infinite and math.huge or eventSettings.Duration,
		}
	end,

	OnUpdate = function(icon, table)
		if table.Duration - (TMW.time - table.Start) < 0 then
			icon:Animations_Stop(table)
		end
	end,
	OnStart = function(icon, table)
		local IconModule_IconContainer = icon:GetModuleOrModuleChild("IconModule_IconContainer")
		local container = IconModule_IconContainer.container
		
		IconModule_IconContainer:ShowOverlayGlow()
		
		-- overlay is a field created by IconModule_IconContainer:ShowOverlayGlow()
		container.overlay:SetScale(table.Scale)
		container.overlay:SetFrameLevel(icon:GetFrameLevel() + 3)
	end,
	OnStop = function(icon, table)
		local IconModule_IconContainer = icon:GetModuleOrModuleChild("IconModule_IconContainer", true, true)
		
		IconModule_IconContainer:HideOverlayGlow()
	end,
})






IconContainer:SetScriptHandler("OnEnter", function(Module, icon)
	Module.container:LockHighlight()
end)
IconContainer:SetScriptHandler("OnLeave", function(Module, icon)
	Module.container:UnlockHighlight()
	Module.container:SetButtonState("NORMAL")
end)
IconContainer:SetScriptHandler("OnMouseDown", function(Module, icon)
	Module.container:SetButtonState("PUSHED")
end)
IconContainer:SetScriptHandler("OnMouseUp", function(Module, icon)
	Module.container:SetButtonState("NORMAL")
end)



