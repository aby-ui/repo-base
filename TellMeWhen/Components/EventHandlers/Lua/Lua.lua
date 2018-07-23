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

local loadstring =
	  loadstring


local Lua = TMW.C.EventHandler_WhileConditions_Repetitive:New("Lua", 100)
Lua.frequencyMinimum = 0

Lua:RegisterEventDefaults{
	Lua = "-- <Untitled Lua Code>\n\nlocal icon = ...\n\n--Your code goes here:\n\n\n\n",
}

local Functions = {}

function Lua:GetCompiledFunction(luaCode)
	if Functions[luaCode] then
		return Functions[luaCode]
	end
	
	local func, err = loadstring(luaCode)
	
	if func then
		Functions[luaCode] = func
	end
	
	return func, err
end

-- Required methods
function Lua:ProcessIconEventSettings(event, eventSettings)
	return eventSettings.Lua ~= TMW.Icon_Defaults.Events["**"].Lua and type(self:GetCompiledFunction(eventSettings.Lua)) == "function"
end

function Lua:HandleEvent(icon, eventSettings)
	local func = self:GetCompiledFunction(eventSettings.Lua)
	
	if func then
		return TMW.safecall(func, icon)
	end
end

function Lua:OnRegisterEventHandlerDataTable()
	error("The Lua event handler does not support registration of event handler data - everything is user-defined.", 3)
end

TMW:RegisterLuaImportDetector(function(table, id, parentTableName)
	if parentTableName == "Events" and rawget(table, "Type") == "Lua" and type(rawget(table, "Lua")) == "string" then
		
		local code = table.Lua

		code = code:trim(" \r\n\t")
			
		if code == "" then
			return nil
		else
			code = code:match("^%-?%-?([^\r\n]*)"):trim()
			
			if code == "" then
				code = "|cff808080<No Code/No Title>"
			end

			return table.Lua, L["EVENTHANDLER_LUA_LUAEVENTf"]:format(code)
		end
	end
end)
