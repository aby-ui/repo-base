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


local CNDT = TMW.CNDT

-- All of this code is internal. No public documentation will be written.
-- UpdateEngine:RegisterObject() and UpdateEngine:UnregisterObject() are its only external interfaces,
-- and they are only called by ConditionObject's methods.

CNDT.UpdateEngine = CreateFrame("Frame")
local UpdateEngine = CNDT.UpdateEngine



-------------------------------------------
-- Update table managers
-------------------------------------------

-- Creates a simple instance of TMW.Classes.UpdateTableManager.
function UpdateEngine:CreateUpdateTableManager()
	local manager = TMW.Classes.UpdateTableManager:New()
	
	manager:UpdateTable_Set()
	
	return manager.UpdateTable_UpdateTable, manager
end

-- An UpdateTableManager that wraps around the UpdateEngine to atumotically register and unregister 
-- events as they become used and unused by the table.
TMW:NewClass("EventUpdateTableManager", "UpdateTableManager"){
	OnNewInstance_EventUpdateTableManager = function(self, event)
		self.event = event
		self:UpdateTable_Set()
	end,
	
	UpdateTable_OnUsed = function(self)
		UpdateEngine:RegisterEvent(self.event)
	end,
	UpdateTable_OnUnused = function(self)
		UpdateEngine:UnregisterEvent(self.event)
	end,

}

-- Creates a simple instance of EventUpdateTableManager.
function UpdateEngine:CreateEventUpdateTableManager(event)
	local manager = TMW.Classes.EventUpdateTableManager:New(event)
	
	return manager.UpdateTable_UpdateTable, manager
end



local OnUpdate_UpdateTable, OnUpdate_UpdateTableManager = UpdateEngine:CreateUpdateTableManager()
local OnAnticipate_UpdateTable, OnAnticipate_UpdateTableManager = UpdateEngine:CreateUpdateTableManager()

UpdateEngine.EventUpdateTables = {}
UpdateEngine.EventUpdateTableManagers = {}

function UpdateEngine:RegisterObjForOnEvent(ConditionObject)
	for event in pairs(ConditionObject.RequestedEvents) do
		self:RegisterObjForEvent(ConditionObject, event)
	end
	
	if ConditionObject.AnticipateFunction and ConditionObject.doesAutoUpdate then
		OnAnticipate_UpdateTableManager:UpdateTable_Register(ConditionObject)
	end
end
function UpdateEngine:RegisterObjForEvent(ConditionObject, event)
	
	if event:find("^TMW_") then
		TMW:RegisterCallback(event, ConditionObject.UpdateFunction, ConditionObject)
	else		
		local UpdateTableManager = UpdateEngine.EventUpdateTableManagers[event]
		if not UpdateTableManager then
			local UpdateTable
			UpdateTable, UpdateTableManager = self:CreateEventUpdateTableManager(event)
			
			UpdateEngine.EventUpdateTableManagers[event] = UpdateTableManager
			UpdateEngine.EventUpdateTables[event] = UpdateTable
		end
		
		UpdateTableManager:UpdateTable_Register(ConditionObject)		
	end	
end

function UpdateEngine:UnregisterObjForOnEvent(ConditionObject)
	for event in pairs(ConditionObject.RequestedEvents) do
		self:UnregisterObjForEvent(ConditionObject, event)
	end
	
	if ConditionObject.AnticipateFunction then
		OnAnticipate_UpdateTableManager:UpdateTable_Unregister(ConditionObject)
	end
end
function UpdateEngine:UnregisterObjForEvent(ConditionObject, event)
	if event:find("^TMW_") then
		TMW:UnregisterCallback(event, ConditionObject.UpdateFunction, ConditionObject)
	else
		local UpdateTableManager = UpdateEngine.EventUpdateTableManagers[event]
		if UpdateTableManager then
			UpdateTableManager:UpdateTable_Unregister(ConditionObject)
		end
	end
end

function UpdateEngine:OnEvent(event, ...)
	local UpdateTable = self.EventUpdateTables[event]
	
	if UpdateTable then
		TMW:UpdateGlobals()
		for i = 1, #UpdateTable do
			local ConditionObject = UpdateTable[i]
			ConditionObject:UpdateFunction(event, ...)
		end
	end
end
UpdateEngine:SetScript("OnEvent", UpdateEngine.OnEvent)



function UpdateEngine:RegisterObjForOnUpdate(ConditionObject)
	OnUpdate_UpdateTableManager:UpdateTable_Register(ConditionObject)
end
function UpdateEngine:UnregisterObjForOnUpdate(ConditionObject)
	OnUpdate_UpdateTableManager:UpdateTable_Unregister(ConditionObject)
end

function UpdateEngine:OnUpdate(event, time, Locked)
	if Locked then
		for i = 1, #OnUpdate_UpdateTable do
			local ConditionObject = OnUpdate_UpdateTable[i]
			
			ConditionObject:Check()
		end
		
		for i = 1, #OnAnticipate_UpdateTable do
			local ConditionObject = OnAnticipate_UpdateTable[i]
			if ConditionObject.NextUpdateTime < time then
				ConditionObject:Check()
			end
		end
	end

end
TMW:RegisterCallback("TMW_ONUPDATE_TIMECONSTRAINED_PRE", UpdateEngine, "OnUpdate")


-- Automatically update all used ConditionObjects after a TMW_GLOBAL_UPDATE_POST.
TMW:RegisterCallback("TMW_GLOBAL_UPDATE_POST", function()
	for _, ConditionObject in pairs(TMW.C.ConditionObject.instances) do
		if ConditionObject.registeredForUpdating then
			ConditionObject:Check()
		end
	end
end)




-------------------------------------------
-- Interfaces with ConditionObject
-------------------------------------------

-- Top level methods for auto-updating, still private(ish) because they are called by ConditionObject
function UpdateEngine:RegisterObject(ConditionObject)
	if ConditionObject.UpdateMethod == "OnUpdate" and ConditionObject.doesAutoUpdate then
		self:RegisterObjForOnUpdate(ConditionObject)
		
	elseif ConditionObject.UpdateMethod == "OnEvent" then
		self:RegisterObjForOnEvent(ConditionObject)
	end
end
function UpdateEngine:UnregisterObject(ConditionObject)
	if ConditionObject.UpdateMethod == "OnUpdate" then
		self:UnregisterObjForOnUpdate(ConditionObject)
		
	elseif ConditionObject.UpdateMethod == "OnEvent" then
		self:UnregisterObjForOnEvent(ConditionObject)
	end
end
