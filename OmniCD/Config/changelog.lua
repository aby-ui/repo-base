local E, L, C = select(2, ...):unpack()

if E.isClassic then E.changelog = [=[
v1.14.3.2724
	Fixed sync for cross realm group members

v1.14.3.2722

	Classic Era re-release. (Build 44834)
]=]
elseif E.isBCC then E.changelog = [=[
v2.5.4.2722
	Fixed sync for cross realm group members

v2.5.4.2722
	NIL.

Previous changes can be found in the CHANGELOG file.
]=]
elseif E.isWOTLKC then E.changelog = [=[
v3.4.0.2724
	Fixed sync for cross realm group members

v3.4.0.2723
	The correct talents will show for whichever spec your group member has active on inital inspection.

v3.4.0.2722

	Wrath of the Lich King Classic release. (Build 45435)
]=]
else E.changelog = [=[
v9.2.7.2724
	Fixed sync for cross realm group members

v9.2.7.2723
	Fixed nil err; Will of the Forsaken were missing table values

v9.2.7.2722
	Minor bug fixes.
	bump toc.

v9.2.5.2721
	Season 4 PvP trinkets added.

Previous changes can be found in the CHANGELOG file.
]=]
end
