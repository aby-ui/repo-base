local GlobalAddonName, ExRT = ...

if ExRT.isClassic then
	return
end 

local VMRT = nil

local GetSpellCharges, GetTime, floor = GetSpellCharges, GetTime, floor

local module = ExRT:New("BattleRes",ExRT.L.BattleRes)
local ELib,L = ExRT.lib,ExRT.L

function module.options:Load()
	self:CreateTilte()

	self.enableChk = ELib:Check(self,L.Enable,VMRT.BattleRes.enabled):Point(15,-30):AddColorState():OnClick(function(self) 
		if self:GetChecked() then
			VMRT.BattleRes.enabled = true
			module:Enable()
		else
			VMRT.BattleRes.enabled = nil
			module:Disable()
		end
	end)
	
	self.fixChk = ELib:Check(self,L.BattleResFix,VMRT.BattleRes.fix):Point(15,-55):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.BattleRes.fix = true
			module.frame:Hide()
			module.frame:SetMovable(false)
		else
			VMRT.BattleRes.fix = nil
			if VMRT.BattleRes.enabled then
				module.frame:Show()
			end
			module.frame:SetMovable(true)
		end
	end)
	
	self.SliderScale = ELib:Slider(self,L.BattleResScale):Size(640):Point("TOP",0,-95):Range(5,200):SetTo(VMRT.BattleRes.Scale or 100):OnChange(function(self,event) 
		event = event - event%1
		VMRT.BattleRes.Scale = event
		ExRT.F.SetScaleFix(module.frame,event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	self.SliderAlpha = ELib:Slider(self,L.BattleResAlpha):Size(640):Point("TOP",0,-130):Range(0,100):SetTo(VMRT.BattleRes.Alpha or 100):OnChange(function(self,event) 
		event = event - event%1
		VMRT.BattleRes.Alpha = event
		module.frame:SetAlpha(event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	self.shtml1 = ELib:Text(self,L.BattleResHelp,12):Size(650,0):Point("TOP",0,-165):Top()
	
	self.hideTimerChk = ELib:Check(self,L.BattleResHideTime,VMRT.BattleRes.HideTimer):Point(15,-200):Tooltip(L.BattleResHideTimeTooltip):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.BattleRes.HideTimer = true
			module.frame.time:Hide()
		else
			VMRT.BattleRes.HideTimer = nil
			module.frame.time:Show()
		end
	end)

	self.frameStrataDropDown = ELib:DropDown(self,275,8):Point(15,-225):Size(260):SetText(L.S_Strata)
	local function FrameStrataDropDown_SetVaule(_,arg)
		VMRT.BattleRes.Strata = arg
		ELib:DropDownClose()
		for i=1,#self.frameStrataDropDown.List do
			self.frameStrataDropDown.List[i].checkState = arg == self.frameStrataDropDown.List[i].arg1
		end
		module.frame:SetFrameStrata(arg)
	end
	for i,strataString in ipairs({"BACKGROUND","LOW","MEDIUM","HIGH","DIALOG","FULLSCREEN","FULLSCREEN_DIALOG","TOOLTIP"}) do
		self.frameStrataDropDown.List[i] = {
			text = strataString,
			checkState = VMRT.BattleRes.Strata == strataString,
			radio = true,
			arg1 = strataString,
			func = FrameStrataDropDown_SetVaule,
		}
	end
end

function module:Enable()
	if not VMRT.BattleRes.HideTimer then
		module.frame.cooldown.noCooldownCount = true
	else
		module.frame.cooldown.noCooldownCount = nil
	end
	module:RegisterTimer()
	if not VMRT.BattleRes.fix then
		module:ResetStates()
		module.frame:Show()
		module.frame:SetMovable(true)
	end
end
function module:Disable()
	module:UnregisterTimer()
	module.frame:Hide()
end

function module.main:ADDON_LOADED()
	VMRT = _G.VMRT
	VMRT.BattleRes = VMRT.BattleRes or {}

	if VMRT.BattleRes.Left and VMRT.BattleRes.Top then
		module.frame:ClearAllPoints()
		module.frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VMRT.BattleRes.Left,VMRT.BattleRes.Top)
	end
	if VMRT.BattleRes.Alpha then module.frame:SetAlpha(VMRT.BattleRes.Alpha/100) end
	if VMRT.BattleRes.Scale then module.frame:SetScale(VMRT.BattleRes.Scale/100) end
	
	if VMRT.BattleRes.HideTimer then
		module.frame.time:Hide()
	end
	
	if VMRT.BattleRes.enabled then
		module:Enable()
	end

	VMRT.BattleRes.Strata = VMRT.BattleRes.Strata or "HIGH"
	module.frame:SetFrameStrata(VMRT.BattleRes.Strata)
end

do
	local stateHidden
	local is0Charges
	local isCooldownHidden
	local cooldownStarted, cooldownDur, chargesNow
	function module:ResetStates()
		stateHidden = true
	end
	function module:timer(elapsed)
		local charges, maxCharges, started, duration = GetSpellCharges(20484)
		if not charges then
			if not stateHidden then
				if VMRT.BattleRes.fix then
					module.frame:Hide()
				end
				module.frame.time:SetText("")
				module.frame.charge:SetText("")
				module.frame.cooldown:Hide()
				chargesNow = nil
				isCooldownHidden = true
				cooldownStarted = nil
				cooldownDur = nil
				stateHidden = true
			end
			return
		elseif stateHidden then
			module.frame:Show()
			stateHidden = false
		end
	
		if maxCharges == charges then
			module.frame.time:SetFormattedText("")
			if chargesNow ~= charges then
				module.frame.charge:SetText(charges)
				chargesNow = charges
			end
			if not isCooldownHidden then
				module.frame.cooldown:Hide()
				isCooldownHidden = true
			end
		else
			local time = duration - (GetTime() - started)
	
			module.frame.time:SetFormattedText("%d:%02d", floor(time/60), time%60)
			if chargesNow ~= charges then
				module.frame.charge:SetText(charges)
				chargesNow = charges
			end
			if isCooldownHidden then
				module.frame.cooldown:Show()
				isCooldownHidden = false
			end
			if (cooldownStarted ~= started) or (cooldownDur ~= duration) then
				module.frame.cooldown:SetCooldown(started,duration)
				cooldownStarted = started
				cooldownDur = duration
			end
		end
		if charges == 0 and not is0Charges then
			module.frame.charge:SetTextColor(1,0,0,1)
			is0Charges = true
		elseif charges ~= 0 and is0Charges then
			module.frame.charge:SetTextColor(1,1,1,1)
			is0Charges = false
		end
	end
end

do
	local frame = CreateFrame("Frame","MRTBattleRes",UIParent)
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
		VMRT.BattleRes.Left = self:GetLeft()
		VMRT.BattleRes.Top = self:GetTop()
	end)
	
	frame.texture = frame:CreateTexture(nil, "BACKGROUND")
	frame.texture:SetTexture(GetSpellTexture(20484))
	frame.texture:SetAllPoints()
	frame.texture:SetTexCoord(.1,.9,.1,.9)
	
	frame.backdrop = CreateFrame("Frame",nil,frame, BackdropTemplateMixin and "BackdropTemplate")
	frame.backdrop:SetPoint("TOPLEFT",-3,3)
	frame.backdrop:SetPoint("BOTTOMRIGHT",3,-3)
	frame.backdrop:SetBackdrop({bgFile = "",edgeFile = "Interface\\AddOns\\"..GlobalAddonName.."\\media\\UI-Tooltip-Border_grey",tile = true,tileSize = 16,edgeSize = 16,insets = {left = 3,right = 3,top = 3,bottom = 3}})
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