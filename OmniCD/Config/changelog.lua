local E, L, C = select(2, ...):unpack()

if E.isClassic then E.changelog = [=[
v1.14.3.2720
	NIL

Previous changes can be found in the CHANGELOG file.
]=]
elseif E.isBCC then E.changelog = [=[
v2.5.4.2720
	NIL

Previous changes can be found in the CHANGELOG file.
]=]
else E.changelog = [=[
v9.2.5.2720
	Season 4 PvP changes.
	Localization update.

Previous changes can be found in the CHANGELOG file.
]=]
end
