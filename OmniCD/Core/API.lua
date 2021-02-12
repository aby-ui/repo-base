local E, L, C = select(2, ...):unpack()

--[[
OmniCD.AddUnitFrameData
	Add new or overwrite pre-existing raid frame data for anchoring cooldown bars

@param Addon: The name of the addon.
@param RaidFrame: The name of raid frame used for party groups.
@param UnitKey: The key used by the raid frames for unitId value.
@param Delay: The delay time required to aquire correct unitId to raid frame
	association when GROUP_ROSTER_UPDATE event fires. (defaults to 1)
@param TestFunc(Optional): Reference to a function that toggles test frames or the player
	raid frame. Boolean value gets passed as the first argument. (true = test enabled, false = test disabled)

@usage
Add raid frame data before PLAYER_LOGIN event:
function MyAddon:ADDON_LOADED(arg1)
	if arg1 == "MyAddon" or arg1 == "OmniCD" then
		local func = OmniCD and OmniCD.AddUnitFrameData
		if func then
			func("MyAddon", "MyRaidFrame", "MyUnitKey", 1)
		end
	end
end

Create reference func if it doesn't exist or can't use boolean as an argument to toggle on and off:
function MyAddon.TestFunc(isTestEnabled)
	if isTestEnabled then
		toggle frames on
	else
		toggle frames off
	end
end
]]

function OmniCD.AddUnitFrameData(Addon, RaidFrame, UnitKey, Delay, TestFunc)
	if type(Addon) ~= "string" then
		error(("Usage: OmniCD.AddUnitFrameData(addon, raidFrame, unitKey, [delay, testFn]): 'addon' - string expected, got '%s'."):format(type(Addon)), 2)
	end
	if type(RaidFrame) ~= "string" then
		error(("Usage: OmniCD.AddUnitFrameData(addon, raidFrame, unitKey, [delay, testFn]): 'raidFrame' - string expected, got '%s'."):format(type(RaidFrame)), 2)
	end
	if type(UnitKey) ~= "string" then
		error(("Usage: OmniCD.AddUnitFrameData(addon, raidFrame, unitKey, [delay, testFn]): 'unitKey' - string expected, got '%s'."):format(type(UnitKey)), 2)
	end

	if not Delay then
		Delay = 1
	elseif type(Delay) ~= "number" then
		error(("Usage: OmniCD.AddUnitFrameData(addon, raidFrame, unitKey, [delay, testFn]): 'delay' - number expected, got '%s'."):format(type(Delay)), 2)
	end

	local tbl = { Addon, RaidFrame, UnitKey, Delay }
	local update

	for i = 1, #E.unitFrameData do
		local addon = E.unitFrameData[i]
		if addon[1] == Addon then
			E.unitFrameData[i] = tbl
			update = true

			break
		end
	end

	if not update then
		tinsert(E.unitFrameData, tbl)
	end

	if TestFunc then
		if type(TestFunc) ~= "function" then
			error(("Usage: OmniCD.AddUnitFrameData(addon, raidFrame, unitKey, [delay, testFn]): 'testFn' - function expected, got '%s'."):format(type(TestFunc)), 2)
		else
			E.addOnTestMode[Addon] = TestFunc
		end
	end
end
