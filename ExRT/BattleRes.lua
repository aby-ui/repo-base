local GlobalAddonName, ExRT = ...

if ExRT.isClassic then
	return
end 

local VExRT = nil

local GetSpellCharges, GetTime, floor = GetSpellCharges, GetTime, floor

local module = ExRT.mod:New("BattleRes",ExRT.L.BattleRes)
local ELib,L = ExRT.lib,ExRT.L

function module.options:Load()
	self:CreateTilte()

	self.enableChk = ELib:Check(self,L.Enable,VExRT.BattleRes.enabled):Point(15,-30):AddColorState():OnClick(function(self) 
		if self:GetChecked() then
			VExRT.BattleRes.enabled = true
			module:Enable()
		else
			VExRT.BattleRes.enabled = nil
			module:Disable()
		end
	end)
	
	self.fixChk = ELib:Check(self,L.BattleResFix,VExRT.BattleRes.fix):Point(15,-55):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.BattleRes.fix = true
			module.frame:Hide()
			module.frame:SetMovable(false)
		else
			VExRT.BattleRes.fix = nil
			if VExRT.BattleRes.enabled then
				module.frame:Show()
			end
			module.frame:SetMovable(true)
		end
	end)
	
	self.SliderScale = ELib:Slider(self,L.BattleResScale):Size(640):Point("TOP",0,-95):Range(5,200):SetTo(VExRT.BattleRes.Scale or 100):OnChange(function(self,event) 
		event = event - event%1
		VExRT.BattleRes.Scale = event
		ExRT.F.SetScaleFix(module.frame,event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	self.SliderAlpha = ELib:Slider(self,L.BattleResAlpha):Size(640):Point("TOP",0,-130):Range(0,100):SetTo(VExRT.BattleRes.Alpha or 100):OnChange(function(self,event) 
		event = event - event%1
		VExRT.BattleRes.Alpha = event
		module.frame:SetAlpha(event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	self.shtml1 = ELib:Text(self,L.BattleResHelp,12):Size(650,0):Point("TOP",0,-165):Top()
	
	self.hideTimerChk = ELib:Check(self,L.BattleResHideTime,VExRT.BattleRes.HideTimer):Point(15,-200):Tooltip(L.BattleResHideTimeTooltip):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.BattleRes.HideTimer = true
			module.frame.time:Hide()
		else
			VExRT.BattleRes.HideTimer = nil
			module.frame.time:Show()
		end
	end)

	self.frameStrataDropDown = ELib:DropDown(self,275,8):Point(15,-225):Size(260):SetText(L.S_Strata)
	local function FrameStrataDropDown_SetVaule(_,arg)
		VExRT.BattleRes.Strata = arg
		ELib:DropDownClose()
		for i=1,#self.frameStrataDropDown.List do
			self.frameStrataDropDown.List[i].checkState = arg == self.frameStrataDropDown.List[i].arg1
		end
		module.frame:SetFrameStrata(arg)
	end
	for i,strataString in ipairs({"BACKGROUND","LOW","MEDIUM","HIGH","DIALOG","FULLSCREEN","FULLSCREEN_DIALOG","TOOLTIP"}) do
		self.frameStrataDropDown.List[i] = {
			text = strataString,
			checkState = VExRT.BattleRes.Strata == strataString,
			radio = true,
			arg1 = strataString,
			func = FrameStrataDropDown_SetVaule,
		}
	end
end

function module:Enable()
	module:RegisterTimer()
	if not VExRT.BattleRes.fix then
		module.frame:Show()
		module.frame:SetMovable(true)
	end
end
function module:Disable()
	module:UnregisterTimer()
	module.frame:Hide()
end

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.BattleRes = VExRT.BattleRes or {}

	VExRT.BattleRes.Strata = VExRT.BattleRes.Strata or "HIGH"
	module.frame:SetFrameStrata(VExRT.BattleRes.Strata)

	if VExRT.BattleRes.Left and VExRT.BattleRes.Top then
		module.frame:ClearAllPoints()
		module.frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.BattleRes.Left,VExRT.BattleRes.Top)
	end
	if VExRT.BattleRes.Alpha then module.frame:SetAlpha(VExRT.BattleRes.Alpha/100) end
	if VExRT.BattleRes.Scale then module.frame:SetScale(VExRT.BattleRes.Scale/100) end
	
	if VExRT.BattleRes.HideTimer then
		module.frame.time:Hide()
	end
	
	if VExRT.BattleRes.enabled then
		module:Enable()
	end
end

function module:timer(elapsed)
	local charges, maxCharges, started, duration = GetSpellCharges(20484)
	if not charges then
		if VExRT.BattleRes.fix then
			module.frame:Hide()
		end
		module.frame.time:SetText("")
		module.frame.charge:SetText("")
		module.frame.cooldown:Hide()
		return
	else
		module.frame:Show()
		module.frame.cooldown:Show()
	end

	if maxCharges == charges then
		module.frame.time:SetFormattedText("")
		module.frame.charge:SetText(charges)
		if not module.frame.cooldown.is0 then
			module.frame.cooldown:Hide()
			module.frame.cooldown.is0 = true
		end
	else
		local time = duration - (GetTime() - started)

		module.frame.time:SetFormattedText("%d:%02d", floor(time/60), time%60)
		module.frame.charge:SetText(charges)
		if module.frame.cooldown.is0 then
			module.frame.cooldown:Show()
			module.frame.cooldown.is0 = nil
		end
		module.frame.cooldown:SetCooldown(started,duration)
	end
	if charges == 0 then
		module.frame.charge:SetTextColor(1,0,0,1)
	else
		module.frame.charge:SetTextColor(1,1,1,1)
	end
end

do
	local frame = CreateFrame("Frame",nil,UIParent)
	module.frame = frame
	frame:SetSize(64,64)
	frame:SetPoint("TOP", 0,-200)
	frame:SetFrameStrata("HIGH")
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self) 
		if self:IsMovable() then 
			self:StartMoving() 
		end 
	end)
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		VExRT.BattleRes.Left = self:GetLeft()
		VExRT.BattleRes.Top = self:GetTop()
	end)
	
	frame.texture = frame:CreateTexture(nil, "BACKGROUND")
	frame.texture:SetTexture(GetSpellTexture(20484))
	frame.texture:SetAllPoints()
	frame.texture:SetTexCoord(.1,.9,.1,.9)
	
	frame.backdrop = CreateFrame("Frame",nil,frame, BackdropTemplateMixin and "BackdropTemplate")
	frame.backdrop:SetPoint("TOPLEFT",-3,3)
	frame.backdrop:SetPoint("BOTTOMRIGHT",3,-3)
	frame.backdrop:SetBackdrop({bgFile = "",edgeFile = "Interface\\AddOns\\ExRT\\media\\UI-Tooltip-Border_grey",tile = true,tileSize = 16,edgeSize = 16,insets = {left = 3,right = 3,top = 3,bottom = 3}})
	frame.backdrop:SetBackdropBorderColor(.3,.3,.3)
	
	frame.cooldown = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
	frame.cooldown:SetHideCountdownNumbers(true)
	frame.cooldown:SetAllPoints()
	frame.cooldown:SetDrawEdge(false)
	frame.cooldown:SetFrameLevel(40)
	frame.texts = CreateFrame("Frame",nil,frame)
	frame.texts:SetAllPoints()
	frame.texts:SetFrameLevel(50)
	frame.time = frame.texts:CreateFontString(nil,"ARTWORK","ExRTFontNormal")
	frame.time:SetAllPoints()
	frame.time:SetJustifyH("CENTER")
	frame.time:SetJustifyV("MIDDLE")
	frame.time:SetFont(frame.time:GetFont(),18,"OUTLINE")
	frame.time:SetTextColor(1,1,1,1)
	frame.charge = frame.texts:CreateFontString(nil,"ARTWORK","ExRTFontNormal")
	frame.charge:SetAllPoints()
	frame.charge:SetJustifyH("RIGHT")
	frame.charge:SetJustifyV("BOTTOM")
	frame.charge:SetFont(frame.charge:GetFont(),16,"OUTLINE")
	frame.charge:SetShadowOffset(1,-1)
	frame.charge:SetTextColor(1,1,1,1)
	
	frame:Hide()
end