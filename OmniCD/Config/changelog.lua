local E, L, C = select(2, ...):unpack()

if E.isClassic then E.changelog = [=[

Previous changes can be found in the CHANGELOG file.
]=]
elseif E.isBCC then E.changelog = [=[
v2.7.15
	Feign Death will no longer grey-out the icons.
	Fixed an issue where logging back in would incorrectly grey-out the icons.
	Group inspection is now done periodically until the arena match begins.

Previous changes can be found in the CHANGELOG file.
]=]
else E.changelog = [=[
v2.7.19
	JUNE 28. 2022, Blizzard Class Tuning Update

v2.7.18
	TOC bump.
	9.2.5 minor updates.

Previous changes can be found in the CHANGELOG file.
]=]
end
