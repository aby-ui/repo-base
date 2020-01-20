local MAJOR_VERSION = "LibDogTag-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20200115020223"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_MINOR_VERSION then
	_G.DogTag_MINOR_VERSION = MINOR_VERSION
end

if GetLocale() == "zhCN" then

DogTag_funcs[#DogTag_funcs+1] = function(DogTag)
	local L = DogTag.L
	
	L["True"] = "True"
	
	-- Namespaces
	L["Base"] = "基本"
	L["Unit"] = "单位"
	
	-- Categories
	L["Mathematics"] = "数学"
	L["Operators"] = "运算符"
	L["Text manipulation"] = "文字处理"
	L["Miscellaneous"] = "其它"
	
	-- Colors
	L["White"] = "白色"
	L["Red"] = "红色"
	L["Green"] = "绿色"
	L["Blue"] = "蓝色"
	L["Cyan"] = "青色"
	L["Fuchsia"] = "紫红色"
	L["Yellow"] = "黄色"
	L["Gray"] = "灰色"
	
	-- Helps
	L["DogTag Help"] = "DogTag帮助"
	L["Test area:"] = "测试区域："
	L["Output:"] = "输出结果："
	L["Test on: "] = "测试单位："
	L["Player"] = "玩家"
	L["Target"] = "目标"
	L["Pet"] = "宠物"
	L["Search:"] = "搜索；"
	L["Syntax"] = "语法"
	L["Search results"] = "搜索结果"
	L["Type your search into the search box in the upper-left corner of DogTag Help"] = "在DogTag帮助窗口左上的搜索框里输入你的搜索信息"
	L["Tags matching %q"] = "符合%q的标签"
	L["alias for "] = "相当于 "
	L["SyntaxHTML"] = [=[<html><body>
		<h1>语法</h1>
		<p>
			LibDogTag-3.0标签本质是一些以方括号括起来的普通标签文本，例如 {这是一个[标签]} 。一般的语法是“OO {[标签]} XX”这样的形式，其中oo和xx都是普通的文字，而 {[标签]} 会被替换成其所代表的动态文字。所有的标签和操作符都不是大小写敏感的，但是如果标签没写错，将会被自动纠正为正常的大小写格式。
			<br/><br/>
		</p>
		<h2>修饰符</h2>
		<p>
			修饰符用于更改标签的输出文字的样子。例如 {{:Hide(0)}} 修饰符在标签输出结果等于数字 {{0}} 的时候会隐藏该结果文本，因此 {[HP:Hide(0)]} 将会显示玩家当前的HP值，等到HP值为0时则什么都不显示。你也可以连续设置多个修饰符，例如：{[MissingHP:Hide(0):Red]} 将会以红色显示当前缺少的HP值，并且在该值为0时不显示东西。修饰符其实是一种标签的语法简化，所以 {[HP:Hide(0)]} 和 {[Hide(HP, 0)]} 的作用是完全一致的。所有的修饰符都可以这样使用，同时所有的标签都可以当作参数，前提是这个修饰符接受参数。
			<br/><br/>
		</p>
		<h2>参数</h2>
		<p>
			标签和修饰符都可以接受参数，以类似 {[标签(参数)]} 或者 {[标签:修饰符(参数)]} 这样的格式输入。你也可以不按照顺序来指定参数，但是要附带参数名称，例如 {[HP(unit='player')]} ，这跟 {[HP('player')]} 以及 {['player':HP]} 的效果是一样的。
			<br/><br/>
		</p>
		<h2>文本</h2>
		<p>
			字符串需要用双引号或者单引号括起来，例如 {["你" '好']} 。数字则可以正常按照数字输入，例如 {[1234 56.78 1e6]} 。也有跟标签同样作用的文本，例如 {{nil}}，{{true}} 以及 {{false}} 。
			<br/><br/>
		</p>
		<h2>逻辑判断 ( if 语句 )</h2>
		<p>
			* 运算符 {{&}} 以及 {{and}} 实现了逻辑与的效果，例如 {[OO and XX]} 将会检查OO是不是值为 非false ，如果是，则运行XX。<br />
			* 运算符 {{||}} 以及 {{or}} 实现了逻辑或的效果，例如 {[OO or XX]} 将会检查OO是不是值为 false ，如果是，则运行XX，否则显示OO。<br />
			* 运算符 {{?}} 实现了 if 语句的效果，它可以与 {{!}} 运算符结合用以创建一个 if-else 语句。例如 {[IsPlayer ? "Player"]} 或者 {[IsPlayer ? "Player" ! "NPC"]} 。<br />
			* 运算符 {{if}} 实现了 if 语句的效果，它可以与 {{else}} 运算符结合用以创建一个 if-else 语句。例如 {[if IsPlayer then "Player" end]} or {[if IsPlayer then "Player" else "NPC" end]} 或者 {[if IsPlayer then "Player" elseif IsPet then "Pet" else "NPC"]} 。<br />
			* 运算符 {{not}} 以及 {{~}} 会将一个 false 值转为 true ，或者将一个 true 值转为 false 。例如 {[not IsPlayer]} 或者 {[~IsPlayer]}
			<br/><br/>
		</p>
		<h3>举例</h3>
		<p>
			{[Status || FractionalHP(known=true) || PercentHP]}<br />
			将会返回以下列几种情况其中的一种(只会是一种)：<br /><br />
			* "|cffffffff死亡|r", "|cffffffff离线|r", "|cffffffff鬼魂|r" 等 － 因为 || 运算符已经指明存在一个合法的返回值了，所以不会有更多的返回值了<br />
			* "|cffffffff3560/8490|r" 或者 "|cffffffff130/6575|r" (不会是 "|cffffffff62/100|r" 这个样子的，除非目标真的只有 {{100}} 点HP) -- 而且也不会是 "|cffffffff0/2340|r" 或者 "|cffffffff0/3592|r" ，因为这样则表明单位已经死亡，从而会按照顺序被第一个标签给处理了<br />
			* "|cffffffff25|r" 或者 "|cffffffff35|r" 或者 "|cffffffff72|r" (百分比生命) － 如果单位没有死，也没有离线等，并且你的插件也无法确定当前目标的具体生命值时，就会显示百分比形式的生命值。<br /><br />
			{[Status || (IsPlayer ? HP(known=true)) || PercentHP:Percent]} 会返回跟上面差不多的结果，其中的细微差别已经表现的很明显。<br /><br />
			不过还是要说明清楚，嵌套句 {{(IsPlayer ? HP(known=true))}} 创建了一个 if 语句，该语句描述了如果 {{IsPlayer}} 的值为 false ，那么整个标签值就为 false ，如果你都能读到这里，你应该被奖励一块饼干。假如 {{IsPlayer}} 值为 true ，在这个例子里，这个嵌套句的实际返回值应该遵循逻辑与的规则，即返回的是 {{HP(known=true)}} 。所以这行代码在 {{IsPlayer}} 值为 true 的情况下(即单位是一个玩家单位)将会显示 {{HP(known=true)}} 的值。<br/>
			<br/>
			{[if IsFriend then -MissingHP:Green else HP:Red end]}<br /> 
			将会返回以下列几种情况其中的一种(只会是一种)：<br /><br />
			* 假如单位是友好单位，这将会显示他所需的治疗量数字，以回满到他的最大生命值。整个字将会以绿色显示，并且在前面还有一个负号。<br /> 
			* 假如单位是敌对单位，这将会显示他当前的生命值，就像是这个序列所写的那样，它不会检测是不是存在一个具体的生命值。对于生命值不能确定具体值的敌人，它会显示百分比数字(但是没有百分号)，直到可以检测到一个更精确的数字为止。这个值将会以红色显示。
			<br/><br/>
		</p>
		<h2>目标指定</h2>
		<p>
			一般使用DogTag的插件会预先定义好所作用于的单位了，比如 {{"player"}} 或者 {{"mouseover"}} 以及其他的。你也可以指定一个单位覆盖掉标签或者修饰符默认的，以这样的形式：{[标签(unit="myunit")]} 或者 {[标签:修饰符(unit="myunit")]}。例如 {[HP(unit='player')]} 会返回玩家自己的生命值。
			<br/><br/>
		</p>
		<h3>示例单位列表</h3>
		<p>
			* player - 你自己的角色<br />
			* target - 你的目标<br />
			* targettarget - 你的目标的目标<br />
			* pet - 你的宠物<br />
			* mouseover - 你当前鼠标所指向的单位<br />
			* focus - 你的焦点目标<br />
			* party1 - 你小队里的第一名队友<br />
			* partypet2 - 你小队里的第二名队友的宠物<br />
			* raid3 - 你团队里的第三名队友<br />
			* raidpet4 - 你团队里的第四名队友的宠物
			<br/><br/>
		</p>
		<h2>算术运算符</h2>
		<p>
			你可以在你的DogTag序列里面使用算术运算符，它们符合算术的常规运算顺序规则。<br/><br/>
			* {{+}} - 加<br />
			* {{-}} - 减<br />
			* {{*}} - 乘<br />
			* {{/}} - 除<br />
			* {{%}} - 取余数<br />
			* {{^}} - 求幂
			<br/><br/>
		</p>
		<h2>比较运算符</h2>
		<p>
			你可以在你的DogTag序列里面使用比较运算符，就像使用算术运算符那样。<br /><br />
			* {{=}} - 相等<br />
			* {{~=}} - 不等<br />
			* {{<}} - 小于<br />
			* {{>}} - 大于<br />
			* {{<=}} - 小于等于<br />
			* {{>=}} - 大于等于
			<br/><br/>
		</p>
		<h2>拼接</h2>
		<p>
			拼接(将两个文本连在一起)非常简单，你只需要将每个字符串一个接一个放置，每两个之间添加一个空格，例如 {['你' "好"]} =&gt; "|cffffffff你好|r"。举个更现实点的例子，{[HP '/' MaxHP]} => "|cffffffff50/100|r" 。
		</p>
	</body></html>]=]
	
	-- Docs
	-- Math
	L["Round number to the one's place or the place specified by digits"] = "四舍五入数字到个位，或者到所指定的位数"
	L["Take the floor of number"] = "返回小于等于指定数字的最大整数"
	L["Take the ceiling of number"] = "返回小于等于指定数字的最小整数"
	L["Take the absolute value of number"] = "返回指定数字的绝对值"
	L["Take the signum of number"] = "返回指定数字的符号"
	L["Return the greatest value of the given arguments"] = "返回给定参数中的最大值"
	L["Return the smallest value of the given arguments"] = "返回给定参数中的最小值"
	L["Return the mathematical number π, or %s"] = "返回π的值，即%s"
	L["Convert radian into degrees"] = "将弧度转换为角度"
	L["Convert degree into radians"] = "将角度转换为弧度"
	L["Return the cosine of radian"] = "返回弧度的余弦值"
	L["Return the sin of radian"] = "返回弧度的正弦值"
	L["Return the natural log of number"] = "返回指定数字的自然对数"
	L["Return the log base 10 of number"] = "返回指定数字以10为底的对数"
	-- Operators
	L["Add left and right together"] = "将左右值相加"
	L["Subtract right from left"] = "从左值中减去右值"
	L["Multiple left and right together"] = "将左右值相乘"
	L["Divide left by right"] = "用左值除以右值"
	L["Take the modulus of left and right"] = "用左值除以右值，返回余数"
	L["Raise left to the right power"] = "返回左值的右值次幂"
	L["Check if left is less than right, if so, return left"] = "如果左值比右值小，则返回左值"
	L["Check if left is greater than right, if so, return left"] = "如果左值比右值大，则返回左值"
	L["Check if left is less than or equal to right, if so, return left"] = "如果左值小于等于右值，则返回左值"
	L["Check if left is greater than or equal to right, if so, return left"] = "如果左值大于等于右值，则返回左值"
	L["Check if left is equal to right, if so, return left"] = "如果左右两值相等，则返回左值"
	L["Check if left is not equal to right, if so, return left"] = "如果左右两值不等，则返回左值"
	L["Return the negative of number"] = "返回指定数字的相反值"
	-- Text manipulation
	L["Append a percentage sign to the end of number"] = "在数字后面添加一个百分数符号"
	L["Shorten value to have at maximum 3 decimal places showing"] = "将数字简写到最多只有3位的显示方式"
	L["Shorten value to its closest denomination"] = "将数字简写到最贴近的千位值"
	L["Turn value into an uppercase string"] = "将值转换为全部大写的形式"
	L["Turn value into an lowercase string"] = "将值转换为全部小写的形式"
	L["Wrap value with square brackets"] = "将值用方括号括起来"
	L["Wrap value with angle brackets"] = "将值用尖括号括起来"
	L["Wrap value with braces"] = "将值用大括号括起来"
	L["Wrap value with parentheses"] = "将值用小括号括起来"
	L["Truncate value to the length specified by number, adding ellipses by default"] = "将值截断到指定的长度，默认添加省略号"
	L["Return the characters specified by start and finish. If either are negative, it means take from the end instead of the beginning"] = "返回两个参数所指定的位置之间的字符串。如果其中一个参数为负，则表明是从后往前而不是从前往后"
	L["Repeat value number times"] = "将值重复拼接指定的次数"
	L["Return the length of value"] = "返回值的长度"
	L["Turn number_value into a roman numeral."] = "将一个数字值转化为罗马样式"
	L["Abbreviate value if a space is found"] = "如果值有空格，则返回整个值的首字母缩写"
	L["Concatenate the values of ... as long as they are all non-blank"] = "当所有给定值都不为空时，拼接所有的值"
	L["Append right to left if right exists"] = "如果右值存在，则将右值附加在左值之后"
	L["Prepend left to right if right exists"] = "如果右值存在，则将右值附加在左值之前"
	-- Misc
	L["Return True if the Alt key is held down"] = "如果Alt正在按下则返回True"
	L["Return True if the Shift key is held down"] = "如果Shift正在按下则返回True"
	L["Return True if the Ctrl key is held down"] = "如果Ctrl正在按下则返回True"
	L["Return the current time in seconds, specified by WoW's internal format"] = "以魔兽的内部格式返回当前的时间，以秒为单位"
	L["Set the transparency of the FontString according to argument"] = "依据参数设置FontString的透明度"
	L["Set the FontString to be outlined"] = "让FontString有外描线"
	L["Set the FontString to be outlined thickly"] = "让FontString有较粗的外描线"
	L["Return True if currently mousing over the Frame the FontString is harbored in"] = "如果当前鼠标悬停框体是FontString所停靠的话，返回True"
	L["Return the color or wrap value with the rrggbb color of argument"] = "返回颜色，或者依据参数用颜色代码(rrggbb)将值括起来"
	L["Return the color or wrap value with %s color"] = "返回颜色，或者用%s代码将值括起来"
	L["Return value if value is within ..."] = "如果值存在于参数中，则返回值"
	L["Hide value if value is within ..."] = "如果值不存在于参数中，则返回值"
	L["Return left if left contains right"] = "如果左值包含了右值，则返回左值"
	L["Return True if non-blank"] = "如果值不为空则返回True"
	L["Return a string formatted by format"] = "返回按指定格式格式化的字符串"
	L["Return a string formatted by format. Use 'e' for extended, 'f' for full, 's' for short, 'c' for compressed."] = "返回按指定格式格式化的字符串。'e'为扩展格式，'f'为完整格式，'s'为简短格式，'c'为压缩格式。"
	L["Return an icon using the given path"] = "返回依据指定的路径和大小所生成的图标"
end

end
