local _, addon = ...
local L = setmetatable({}, {__index = function(t, k) t[k] = k return k end})
addon.L = L
if GetLocale()=="zhCN" then
	L["Custom Layouts"] = "自定义布局"
	L["Add customed layouts using a simple grammer."] = "使用简写的格式增加自定义布局, 详见插件说明."
	L["Layout text format error, see above information."] = "布局字符串格式错误, 请看以上信息."
	L["Layout name is already used."] = "创建失败, 布局已经存在."
    L["GridCustomLayouts: % saved and loaded as %s layout."] = "Grid自定义布局：%s 已保存，当前布局 %s 已刷新."
end
if GetLocale()=="zhTW" then
	L["Custom Layouts"] = "自定義佈局"
	L["Add customed layouts using a simple grammer."] = "使用簡寫的格式增加自定義佈局, 詳見插件說明."
	L["Layout text format error, see above information."] = "佈局字串格式錯誤, 請看以上資訊."
	L["Layout name is already used."] = "創建失敗, 布局已經存在."
    L["GridCustomLayouts: % saved and loaded as %s layout."] = "Grid自訂佈局：%s 已保存，當前佈局 %s 已刷新."
end

if GetLocale()=="zhCN" or GetLocale()=="zhTW" then
    L.USAGE_HELP_MESSAGE = [[#整体用法: 1.一行表示一个分组   2.'#'之后注释   3.连续空多行表示一个空组
#分组语法: '参数1=值;参数2=值;...', 部分参数可以省略名称直接写值, true可以写为1
#一般用法: 'groupFilter=2,战士,ZS,HEALER; groupBy=CLASS/ROLE; 每列个数/最大列数'
#    其中groupFilter=和groupBy=可以省略, 例如 1,2,3,4,HEALER; CLASS; 6/1; STRICT
#表示: 小队1-4中的治疗者, 按职业排序, 一列6个最多只显示1列(多于6个就不显示了)
#    如果没有strictFilter=true或者STRICT, 则表示小队1-4中所有人以及全团治疗者
#另外一种用法: 'nameList=玩家A,玩家B,玩家C; sortMethod=INDEX/NAME/NAMELIST'
#    其中nameList和sortMethod也可以省略，即简写成'玩家A,玩家B,玩家C; NAMELIST'
#进阶参考：
#groupFilter - (参数名可省略) 支持小队编号/职业/职责/团队角色四种. 小队编号就是数字1-8. 职业可以用英文或汉字缩写，例如ZS,战,WARRIOR,WARR都可以代表战士.  职责是TANK/HEALER/DPS/NONE四种, 团队角色是MT/MA两种, 即主坦克和主助理.
#nameList - (参数名可省略) 即玩家全名的列表, 和groupFilter只能指定一个, 这种方式不能使用groupBy参数, sortMethod可以采用NAMELIST排序, 即保持列表里名字的顺序.
#sortMethod - (参数名可省略) 排序方式, 支持INDEX/NAME/NAMELIST, INDEX即按进团顺序, NAME是按名字的字母顺序, NAMELIST上面说了
#sortDir - (参数名可省略) 排序方向, ASC/DESC 对应正序/倒序
#groupBy - 排序之前先进行分组, 支持四种方式: GROUP/CLASS/ROLE/RAIDROLE, 对应上面groupFilter的四种情况. (可直接写值)
#groupingOrder - 分组的排列顺序, 只有指定了groupBy之后才有用, 取值是groupBy方式的排列, 例如groupBy=GROUP, 那就是'3,2,4,1'这样,若groupBy=CLASS, 那就要写'ZS,FS,MS'这样
#roleFilter - 额外的角色过滤, 可以配合groupFilter和nameList使用, 和strictFiltering配合可以很复杂, 自己体会
#strictFiltering - 表示是否需要同时满足过滤条件, 取值为true/false, 例子中已有说明. 直接写'STRICT'表示strictFiltering=true
#unitsPerColumn和maxColumns - 限制一列里的单位数量, unitsPerColumn=6;maxColumns=2可缩写为6/2, 表示1列最多6个人, 最多只显示2列, 即超过12个人的就不显示了
#isPetGroup - 表示本组是符合过滤条件的单位的宠物, 所以宠物和玩家无法处于同一组. 直接写'PET'表示isPetGroup=true
#noRepeat - 表示本组不出现其他组已经出现的单位, 逻辑是先查找普通组，然后按次序把noRepeat=true的组展开为nameList. 可以直接写为NOREPEAT或NR
#缩写对照：
#WARLOCK or WARL or WL -> "WARLOCK"
#MT / MA / DPS / HEAL -> MAINTANK/MAINASSIST/DAMAGER/HEALER
#GROUP/CLASS/ROLE/RAIDROLE-> groupBy="?"
#INDEX / NAME / NAMELIST -> sortMethod="?"
#ASC / DESC -> sortDir="?"
#STRICT;PET -> isPetGroup=true;strictFiltering=true
#5/2 -> unitsPerColumn=5;maxColumns=2
#role=? -> roleFilter=?       order=? -> groupingOrder=?
]]
else
    L.USAGE_HELP_MESSAGE = [[#NEEDS REVIEW
#Usage: One line for each group. Comments start with '#'. Groups are attribute combinations.
#Group: 'attr1=value1;attr2=value2;...', some attr names can be ommitted
#Example: groupFilter=1,2,3,4,5;groupBy=CLASS;groupingOrder=WARR,MAG,PRI,PAL,DH,DK;5/8
#References:
#groupFilter = [1-8, STRING] -- a comma seperated list of raid group numbers and/or uppercase class names and/or uppercase roles
#nameList = [STRING] -- a comma separated list of player names (not used if 'groupFilter' is set)
sortMethod = ["INDEX", "NAME", "NAMELIST"] -- defines how the group is sorted (Default: "INDEX")
#sortDir = ["ASC", "DESC"] -- defines the sort order (Default: "ASC")
#groupBy = [nil, "GROUP", "CLASS", "ROLE", "RAIDROLE"] - specifies a "grouping" type to apply before regular sorting (Default: nil)
#groupingOrder = [STRING] - specifies the order of the groupings (ie. "1,2,3,4,5,6,7,8")
#roleFilter = [STRING] - a comma seperated list of MT/MA/Tank/Healer/DPS role strings
#strictFiltering = [BOOLEAN] - if true then characters must match both a group and a class from the groupFilter list
#maxColumns = [NUMBER] - maximum number of columns the header will create (Default: 1)
#unitsPerColumn = [NUMBER or nil] - maximum units that will be displayed in a singe column, nil is infinite (Default: nil) ('unitsPerColumn=5;maxColumns=2;' can be shortten to '5/2')
#noRepeat = [BOOLEAN] - Expand this group to nameList and exclude those units already shown in previous groups.
#isPetGroup = [BOOLEAN] - Pets of units that match the filters.
#
#Simplicity
#WARLOCK or WARL or WL -> "WARLOCK"
#MT / MA / DPS / HEAL -> MAINTANK/MAINASSIST/DAMAGER/HEALER
#GROUP/CLASS/ROLE/RAIDROLE-> groupBy="?"
#INDEX / NAME / NAMELIST -> sortMethod="?"
#ASC / DESC -> sortDir="?"
#STRICT;PET -> isPetGroup=true;strictFiltering=true
#5/2 -> unitsPerColumn=5;maxColumns=2
#role=? -> roleFilter=?       order=? -> groupingOrder=?
]]
end

