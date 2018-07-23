------------------------------------------------------------
-- Clique.lua
--
-- Abin
-- 2012/3/27
------------------------------------------------------------

local _, addon = ...

local Clique = IsAddOnLoaded("Clique") and type(Clique) == "table" and type(Clique.RegisterFrame) == "function" and type(Clique.UnregisterFrame) == "function" and Clique

function addon:CliqueRegister(frame)
	if not Clique or not self:Initialized() then
		return
	end

	if frame then
		Clique:RegisterFrame(frame)
	else
		self:EnumUnitFrames(Clique, "RegisterFrame")
	end
end

function addon:CliqueUnregister(frame)
	if not Clique or not self:Initialized() then
		return
	end

	if frame then
		Clique:UnregisterFrame(frame)
	else
		self:EnumUnitFrames(Clique, "UnregisterFrame")
	end
end

if not Clique then return end

addon:RegisterEventCallback("OnInitialize", function()
	addon:CliqueRegister()
	addon:RegisterEventCallback("UnitButtonCreated", function(frame)
		addon:CliqueRegister(frame)
	end)
end)