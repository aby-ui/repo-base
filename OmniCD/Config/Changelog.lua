local E, L, C = select(2, ...):unpack()

if E.isClassic then E.changelog = [=[
v1.14.3.2740
	version update

v1.14.3.2724
	Fixed sync for cross realm group members

v1.14.3.2722
	Classic Era re-release. (Build 44834)
]=]
elseif E.isBCC then E.changelog = [=[
v2.5.4.2722
	Fixed sync for cross realm group members

Previous changes can be found in the CHANGELOG file
]=]
elseif E.isWOTLKC then E.changelog = [=[
v3.4.1.2740
	Fixed Set bonus inspection
	Added Season 6 tier set bonuses

Previous changes can be found in the CHANGELOG file
]=]
else E.changelog = [=[
v10.0.2.2740
	Non-PvP talent changes made by non-synced units are now updated instantly
	Fixed item inspection

Previous changes can be found in the CHANGELOG file

]=]
end
