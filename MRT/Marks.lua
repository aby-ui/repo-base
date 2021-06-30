local GlobalAddonName, ExRT = ...

local UnitName, GetRaidTargetIndex, SetRaidTargetIcon = UnitName, GetRaidTargetIndex, SetRaidTargetIcon

local VMRT = nil

local module = ExRT:New("Marks",ExRT.L.Marks)
local ELib,L = ExRT.lib,ExRT.L

function module.main:ADDON_LOADED()
	VMRT = _G.VMRT
	VMRT.Marks = VMRT.Marks or {}
	VMRT.Marks.list = VMRT.Marks.list or {}
end

function module:Enable()
	module:RegisterTimer()
	module.Enabled = true
end
function module:Disable()
	module:UnregisterTimer()
	module.Enabled = nil
end

do
	local tmr = 0
	function module:timer(elapsed)
		tmr = tmr + elapsed
		if tmr > .5 then
			tmr = 0
			for i=1,8 do
				local name = VMRT.Marks.list[i]
				if name and UnitName(name) and GetRaidTargetIndex(name)~=i then
					SetRaidTargetIcon(name, i)
				end
			end
		end
	end
end

function module:SetName(markNum,name)
	if name == "" then
		name = nil
	end
	VMRT.Marks.list[markNum] = name
end

function module:GetName(markNum)
	return VMRT.Marks.list[markNum]
end

function module:ClearNames()
	for i=1,8 do
		VMRT.Marks.list[i] = nil
	end
end


function module.options:Load()
	self:CreateTilte()

	local function MarksEditBoxTextChanged(self,isUser)
		if not isUser then
			return
		end
		local i = self._i
		local name = self:GetText()
		if name == "" then
			name = nil
		end
		VMRT.Marks.list[i] = name
	end

	self.namesEditBox = {}
	for i=1,8 do
		self.namesEditBox[i] = ELib:Edit(self):Size(600,20):Point(45,-65-(i-1)*24):Text(VMRT.Marks.list[i]):OnChange(MarksEditBoxTextChanged)
		self.namesEditBox[i]._i = i
		self.namesEditBox[i].icon = ELib:Icon(self.namesEditBox[i],"Interface\\TargetingFrame\\UI-RaidTargetingIcon_"..i,22):Point("RIGHT",self.namesEditBox[i],"LEFT",-5,0)
	end

	self.showButton = ELib:Button(self,L.Enable):Size(632,20):Point("TOP",0,-35):Tooltip(L.MarksTooltip):OnClick(function (self)
		if not module.Enabled then
			self:SetText(L.MarksDisable)
			module:Enable()
		else
			self:SetText(L.Enable)
			module:Disable()
		end
	end)
	if module.Enabled then
		self.showButton:SetText(L.MarksDisable)
	end
	self.showButton:SetScript("OnShow",function (self)
		if module.Enabled then
			self:SetText(L.MarksDisable)
		else
			self:SetText(L.Enable)
		end
	end)
	
	self.clearButton = ELib:Button(self,L.MarksClear):Size(632,20):Point("TOP",0,-265):OnClick(function ()
		module:ClearNames()
		for i=1,8 do
			self.namesEditBox[i]:SetText("")
		end
	end)
end