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

Previous changes can be found in the CHANGELOG file
]=]
elseif E.isWOTLKC then E.changelog = [=[
v3.4.1.2733
	Compatibility updates for 3.4.1

v3.4.0.2724
	Fixed sync for cross realm group members

v3.4.0.2723
	The correct talents will show for whichever spec your group member has active on inital inspection

v3.4.0.2722
	Wrath of the Lich King Classic release. (Build 45435)
]=]
else E.changelog = [=[
v10.0.2.2735
	Cds will correctly reset inbetween solo shuffle rounds #3
	Desperate Prayer has been added to Sync
	Fixed Dracthyr racials for Alliance
	Returned option to exclude player spells on Extra Bars
	JANUARY 3/9, 2023 Hotfixes

v10.0.2.2730
	Dragonflight

Full list of changes can be found in the CHANGELOG file

]=]
end
