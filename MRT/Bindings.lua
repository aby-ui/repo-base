local GlobalAddonName, ExRT = ...

BINDING_HEADER_ExRT = "Method Raid Tools"
BINDING_NAME_EXRT_FIGHTLOG_OPEN = ExRT.L.BossWatcher
BINDING_NAME_EXRT_OPEN = ExRT.L.minimapmenu

local function make(name, command, description)
	_G["BINDING_NAME_CLICK "..name..":LeftButton"] = description
	local btn = CreateFrame("Button", name, nil, "SecureActionButtonTemplate")
	btn:SetAttribute("type", "macro")
	btn:SetAttribute("macrotext", command)
	btn:RegisterForClicks("AnyDown")
end

for i=1,8 do
	make("EXRTWM"..i, "/clearworldmarker "..i.."\n/worldmarker "..i, _G["WORLD_MARKER"..i])
end
make("EXRTCWM", "/clearworldmarker 0", REMOVE_WORLD_MARKERS)
make("EXRTTOGGLENOTE", "/rt note", ExRT.L.message)