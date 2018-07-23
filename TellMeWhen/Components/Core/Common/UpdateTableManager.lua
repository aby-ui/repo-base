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



local UpdateTableManager = TMW:NewClass("UpdateTableManager")

function UpdateTableManager:UpdateTable_Set(table)
	self.UpdateTable_UpdateTable = table or {} -- create an anonymous table if one wasnt passed in
end

function UpdateTableManager:UpdateTable_Register(target)
	if not self.UpdateTable_UpdateTable then
		error("No update table was found for " .. tostring(self.GetName and self[0] and self:GetName() or self) .. ". Set one using self:UpdateTable_Set(table).")
	end
	
	TMW:ValidateType("2 (target)", "UpdateTableManager:UpdateTable_Register(target)", target, "!boolean")
	
	if target == nil then
		if self.class == UpdateTableManager then
		TMW:ValidateType("2 (target)", "UpdateTableManager:UpdateTable_Register(target)", target, "!nil")
		else
			target = self
		end
	end
	

	local oldLength = #self.UpdateTable_UpdateTable

	if not TMW.tContains(self.UpdateTable_UpdateTable, target) then

		if self.UpdateTable_DoAutoSort then
			TMW.binaryInsert(self.UpdateTable_UpdateTable, target, self.UpdateTable_AutoSortFunc)
		else
			tinsert(self.UpdateTable_UpdateTable, target)
		end
		
		if oldLength == 0 and self.UpdateTable_OnUsed then
			self:UpdateTable_OnUsed()
		end
	end
end

function UpdateTableManager:UpdateTable_Unregister(target)
	if not self.UpdateTable_UpdateTable then
		error("No update table was found for " .. tostring(self.GetName and self[0] and self:GetName() or self) .. ". Set one using self:UpdateTable_Set(table).")
	end
	
	target = target or self

	local oldLength = #self.UpdateTable_UpdateTable

	TMW.tDeleteItem(self.UpdateTable_UpdateTable, target, true)
	
	if oldLength ~= #self.UpdateTable_UpdateTable then
		
		if oldLength > 0 and #self.UpdateTable_UpdateTable == 0 and self.UpdateTable_OnUnused then
			self:UpdateTable_OnUnused()
		end

		-- Notify that a removal was done
		return true
	end

	-- No removal was done
	return false
end

function UpdateTableManager:UpdateTable_UnregisterAll()
	if not self.UpdateTable_UpdateTable then
		error("No update table was found for " .. tostring(self.GetName and self[0] and self:GetName() or self) .. ". Set one using self:UpdateTable_Set(table).")
	end
	local oldLength = #self.UpdateTable_UpdateTable
	
	wipe(self.UpdateTable_UpdateTable)
	
	if oldLength > 0 and self.UpdateTable_OnUnused then
		self:UpdateTable_OnUnused()
	end
end

function UpdateTableManager:UpdateTable_Sort(func)
	if not self.UpdateTable_UpdateTable then
		error("No update table was found for " .. tostring(self.GetName and self[0] and self:GetName() or self) .. ". Set one using self:UpdateTable_Set(table).")
	end
	
	sort(self.UpdateTable_UpdateTable, func)
end

function UpdateTableManager:UpdateTable_SetAutoSort(func)
	self.UpdateTable_DoAutoSort = not not func
	if type(func) == "function" then
		self.UpdateTable_DoAutoSort = true
		self.UpdateTable_AutoSortFunc = func
	elseif func == true then
		self.UpdateTable_DoAutoSort = true
		self.UpdateTable_AutoSortFunc = nil
	else
		self.UpdateTable_DoAutoSort = false
	end
end

function UpdateTableManager:UpdateTable_PerformAutoSort()
	if self.UpdateTable_DoAutoSort then
		self:UpdateTable_Sort(self.UpdateTable_AutoSortFunc)
	end
end

