### 说明
* groupBy四种方式很重要 GROUP/CLASS/RAIDROLE/ASSIGNEDROLE，简写时ASSIGNEDROLE可以写成ROLE，(这和暴雪的不同，暴雪里ROLE就是RAIDROLE)
* groupingOrder必须按照groupBy的方式来列出，例如groupBy是CLASS，则groupingOrder就只能是PAL,SS,ZS之类, 如果用TANK/DPS/MAINASSIT/1234这样的会被忽略
* 使用nameList后，不再支持groupBy和groupingOrder，此时sortMethod=NAMELIST意思就是按给定列表的顺序（既不按id顺序，也不按人名顺序)
* roleFilter是可以和nameList/groupFilter同时使用的，但后两者不能同时用
* showParty指的是显示不显示队友，showRaid=true则showParty就肯定是true了，false会被无视

### WowAcePage
You don't need to write "groupFilter=", for example:
1,2,3,4,5 is just the same as groupFilter="1,2,3,4,5"
WARR,PAL,DRU is just the same as groupFilter="WARRIOR,PALADIN,DRUID"

If the group name is not group ids and not class or role names, for example:
Abcde,Xyz will be parsed to nameList="Abcde,Xyz"

### noRepeat = true
Now you can add a NOREPEAT(NOREP,NOR and NR is just the same) attribute to non-pet group header, for example

WARRIOR,PAL;NOREPEAT
1;NOREPEAT
2;NOREPEAT
3;NOREPEAT
4;NOREPEAT
5;NOREPEAT
Someone,Anotherone

In the above layout, the first group will contains WARRIORs and PALADINs, but not Someone or Anotherone.
And the next 5 groups will contains team 1-5 members, but not Someone or Anotherone, neither any WARRIORs or PALs.
Actually, group headers with NOREPEAT are parsed to specified nameList groups, therefore the 'groupBy' attribute will be ignore.

--[[
List of the various configuration attributes
======================================================
showRaid = [BOOLEAN] -- true if the header should be shown while in a raid
showParty = [BOOLEAN] -- true if the header should be shown while in a party and not in a raid
showPlayer = [BOOLEAN] -- true if the header should show the player when not in a raid
showSolo = [BOOLEAN] -- true if the header should be shown while not in a group (implies showPlayer)
nameList = [STRING] -- a comma separated list of player names (not used if 'groupFilter' is set)
groupFilter = [1-8, STRING] -- a comma seperated list of raid group numbers and/or uppercase class names and/or uppercase roles
[7.0+] roleFilter = [STRING] -- a comma seperated list of MT/MA/Tank/Healer/DPS role strings
strictFiltering = [BOOLEAN]
-- if true, then
---- if only groupFilter is specified then characters must match both a group and a class from the groupFilter list
---- if only roleFilter is specified then characters must match at least one of the specified roles
---- if both groupFilter and roleFilters are specified then characters must match a group and a class from the groupFilter list and a role from the roleFilter list
sortMethod = ["INDEX", "NAME", "NAMELIST"(7.0+)] -- defines how the group is sorted (Default: "INDEX")
sortDir = ["ASC", "DESC"] -- defines the sort order (Default: "ASC")
groupBy = [nil, "GROUP", "CLASS", "ROLE", "ASSIGNEDROLE"(7.0+)] - specifies a "grouping" type to apply before regular sorting (Default: nil)
groupingOrder = [STRING] - specifies the order of the groupings (ie. "1,2,3,4,5,6,7,8")
maxColumns = [NUMBER] - maximum number of columns the header will create (Default: 1)
unitsPerColumn = [NUMBER or nil] - maximum units that will be displayed in a singe column, nil is infinite (Default: nil)
startingIndex = [NUMBER] - the index in the final sorted unit list at which to start displaying units (Default: 1)
--]]