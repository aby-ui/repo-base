local E, L, C = select(2, ...):unpack()

if E.isClassic then E.changelog = [=[
v2.7.13
	NIL

Previous changes can be found in the CHANGELOG file
]=]
elseif E.isBCC then E.changelog = [=[
v2.7.13
	NIL

Previous changes can be found in the CHANGELOG file
]=]
else E.changelog = [=[
v2.7.13
	Fixed an issue where sync could incorrectly reset the CD.
	Bwonsamdi's Pact has been added back in for non-synced units. (doesn't support multiple buffs per target)
	Crafted Unity Legendaries added.

Previous changes can be found in the CHANGELOG file
]=]
end
