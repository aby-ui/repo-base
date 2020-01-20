local MAJOR_VERSION = "LibDogTag-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20200115020223"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_MINOR_VERSION then
	_G.DogTag_MINOR_VERSION = MINOR_VERSION
end

if GetLocale() == "zhTW" then

DogTag_funcs[#DogTag_funcs+1] = function(DogTag)
	local L = DogTag.L
	
	L["True"] = "True"
	
	-- Namespaces
	L["Base"] = "基本"
	L["Unit"] = "單位"
	
	-- Categories
	L["Mathematics"] = "數學"
	L["Operators"] = "運算符"
	L["Text manipulation"] = "文字處理"
	L["Miscellaneous"] = "其他"
	
	-- Colors
	L["White"] = "白色"
	L["Red"] = "紅色"
	L["Green"] = "綠色"
	L["Blue"] = "藍色"
	L["Cyan"] = "深藍色"
	L["Fuchsia"] = "紫紅色"
	L["Yellow"] = "黃色"
	L["Gray"] = "灰色"
	
	-- Helps
	L["DogTag Help"] = "DogTag説明"
	L["Test area:"] = "測試區域："
	L["Output:"] = "輸出結果："
	L["Test on: "] = "測試單位："
	L["Player"] = "玩家"
	L["Target"] = "目標"
	L["Pet"] = "寵物"
	L["Search:"] = "搜尋；"
	L["Syntax"] = "語法"
	L["Search results"] = "搜索結果"
	L["Type your search into the search box in the upper-left corner of DogTag Help"] = "在DogTag幫助視窗左上的搜索框裏輸入你的搜索資訊"
	L["Tags matching %q"] = "符合%q的標籤"
	L["alias for "] = "相當於 "
	L["SyntaxHTML"] = [=[<html><body>
		<h1>語法</h1>
		<p>
			LibDogTag-3.0標籤本質是一些以方括號括起來的普通標籤文本，例如 {這是一個[標籤]} 。一般的語法是“OO {[標籤]} XX”這樣的形式，其中oo和xx都是普通的文字，而 {[標籤]} 會被替換成其所代表的動態文字。所有的標籤和操作符都不是大小寫敏感的，但是如果標籤沒寫錯，將會被自動糾正為正常的大小寫格式。
			<br/><br/>
		</p>
		<h2>修飾符</h2>
		<p>
			修飾符用於更改標籤的輸出文字的樣子。例如 {{:Hide(0)}} 修飾符在標籤輸出結果等於數位 {{0}} 的時候會隱藏該結果文本，因此 {[HP:Hide(0)]} 將會顯示玩家當前的HP值，等到HP值為0時則什麼都不顯示。你也可以連續設置多個修飾符，例如：{[MissingHP:Hide(0):Red]} 將會以紅色顯示當前缺少的HP值，並且在該值為0時不顯示東西。修飾符其實是一種標籤的語法簡化，所以 {[HP:Hide(0)]} 和 {[Hide(HP, 0)]} 的作用是完全一致的。所有的修飾符都可以這樣使用，同時所有的標籤都可以當作參數，前提是這個修飾符接受參數。
			<br/><br/>
		</p>
		<h2>參數</h2>
		<p>
			標籤和修飾符都可以接受參數，以類似 {[標籤(參數)]} 或者 {[標籤:修飾符(參數)]} 這樣的格式輸入。你也可以不按照順序來指定參數，但是要附帶參數名稱，例如 {[HP(unit='player')]} ，這跟 {[HP('player')]} 以及 {['player':HP]} 的效果是一樣的。
			<br/><br/>
		</p>
		<h2>文本</h2>
		<p>
			字串需要用雙引號或者單引號括起來，例如 {["你" '好']} 。數位則可以正常按照數位輸入，例如 {[1234 56.78 1e6]} 。也有跟標籤同樣作用的文本，例如 {{nil}}，{{true}} 以及 {{false}} 。
			<br/><br/>
		</p>
		<h2>邏輯判斷 ( if 語句 )</h2>
		<p>
			* 運算符 {{&}} 以及 {{and}} 實現了邏輯與的效果，例如 {[OO and XX]} 將會檢查OO是不是值為 非false ，如果是，則運行XX。<br />
			* 運算符 {{||}} 以及 {{or}} 實現了邏輯或的效果，例如 {[OO or XX]} 將會檢查OO是不是值為 false ，如果是，則運行XX，否則顯示OO。<br />
			* 運算符 {{?}} 實現了 if 語句的效果，它可以與 {{!}} 運算符結合用以創建一個 if-else 語句。例如 {[IsPlayer ? "Player"]} 或者 {[IsPlayer ? "Player" ! "NPC"]} 。<br />
			* 運算符 {{if}} 實現了 if 語句的效果，它可以與 {{else}} 運算符結合用以創建一個 if-else 語句。例如 {[if IsPlayer then "Player" end]} or {[if IsPlayer then "Player" else "NPC" end]} 或者 {[if IsPlayer then "Player" elseif IsPet then "Pet" else "NPC"]} 。<br />
			* 運算符 {{not}} 以及 {{~}} 會將一個 false 值轉為 true ，或者將一個 true 值轉為 false 。例如 {[not IsPlayer]} 或者 {[~IsPlayer]}
			<br/><br/>
		</p>
		<h3>舉例</h3>
		<p>
			{[Status || FractionalHP(known=true) || PercentHP]}<br />
			將會返回以下列幾種情況其中的一種(只會是一種)：<br /><br />
			* "|cffffffff死亡|r", "|cffffffff離線|r", "|cffffffff鬼魂|r" 等 － 因為 || 運算符已經指明存在一個合法的返回值了，所以不會有更多的返回值了<br />
			* "|cffffffff3560/8490|r" 或者 "|cffffffff130/6575|r" (不會是 "|cffffffff62/100|r" 這個樣子的，除非目標真的只有 {{100}} 點HP) -- 而且也不會是 "|cffffffff0/2340|r" 或者 "|cffffffff0/3592|r" ，因為這樣則表明單位已經死亡，從而會按照順序被第一個標籤給處理了<br />
			* "|cffffffff25|r" 或者 "|cffffffff35|r" 或者 "|cffffffff72|r" (百分比生命) － 如果單位沒有死，也沒有離線等，並且你的插件也無法確定當前目標的具體生命值時，就會顯示百分比形式的生命值。<br /><br />
			{[Status || (IsPlayer ? HP(known=true)) || PercentHP:Percent]} 會返回跟上面差不多的結果，其中的細微差別已經表現的很明顯。<br /><br />
			不過還是要說明清楚，嵌套句 {{(IsPlayer ? HP(known=true))}} 創建了一個 if 語句，該語句描述了如果 {{IsPlayer}} 的值為 false ，那麼整個標籤值就為 false ，如果你都能讀到這裏，你應該被獎勵一塊餅乾。假如 {{IsPlayer}} 值為 true ，在這個例子裏，這個嵌套句的實際返回值應該遵循邏輯與的規則，即返回的是 {{HP(known=true)}} 。所以這行代碼在 {{IsPlayer}} 值為 true 的情況下(即單位是一個玩家單位)將會顯示 {{HP(known=true)}} 的值。<br/>
			<br/>
			{[if IsFriend then -MissingHP:Green else HP:Red end]}<br /> 
			將會返回以下列幾種情況其中的一種(只會是一種)：<br /><br />
			* 假如單位是友好單位，這將會顯示他所需的治療量數字，以回滿到他的最大生命值。整個字將會以綠色顯示，並且在前面還有一個負號。<br /> 
			* 假如單位是敵對單位，這將會顯示他當前的生命值，就像是這個序列所寫的那樣，它不會檢測是不是存在一個具體的生命值。對於生命值不能確定具體值的敵人，它會顯示百分比數位(但是沒有百分號)，直到可以檢測到一個更精確的數字為止。這個值將會以紅色顯示。
			<br/><br/>
		</p>
		<h2>目標指定</h2>
		<p>
			一般使用DogTag的插件會預先定義好所作用於的單位了，比如 {{"player"}} 或者 {{"mouseover"}} 以及其他的。你也可以指定一個單位覆蓋掉標籤或者修飾符默認的，以這樣的形式：{[標籤(unit="myunit")]} 或者 {[標籤:修飾符(unit="myunit")]}。例如 {[HP(unit='player')]} 會返回玩家自己的生命值。
			<br/><br/>
		</p>
		<h3>示例單位列表</h3>
		<p>
			* player - 你自己的角色<br />
			* target - 你的目標<br />
			* targettarget - 你的目標的目標<br />
			* pet - 你的寵物<br />
			* mouseover - 你當前滑鼠所指向的單位<br />
			* focus - 你鎖定的目標<br />
			* party1 - 你小隊裏的第一名隊友<br />
			* partypet2 - 你小隊裏的第二名隊友的寵物<br />
			* raid3 - 你團隊裏的第三名隊友<br />
			* raidpet4 - 你團隊裏的第四名隊友的寵物
			<br/><br/>
		</p>
		<h2>算術運算符</h2>
		<p>
			你可以在你的DogTag序列裏面使用算術運算符，它們符合算術的常規運算順序規則。<br/><br/>
			* {{+}} - 加<br />
			* {{-}} - 減<br />
			* {{*}} - 乘<br />
			* {{/}} - 除<br />
			* {{%}} - 取餘數<br />
			* {{^}} - 求冪
			<br/><br/>
		</p>
		<h2>比較運算符</h2>
		<p>
			你可以在你的DogTag序列裏面使用比較運算符，就像使用算術運算符那樣。<br /><br />
			* {{=}} - 相等<br />
			* {{~=}} - 不等<br />
			* {{<}} - 小於<br />
			* {{>}} - 大於<br />
			* {{<=}} - 小於等於<br />
			* {{>=}} - 大於等於
			<br/><br/>
		</p>
		<h2>拼接</h2>
		<p>
			拼接(將兩個文本連在一起)非常簡單，你只需要將每個字串一個接一個放置，每兩個之間添加一個空格，例如 {['你' "好"]} =&gt; "|cffffffff你好|r"。舉個更實際點的例子，{[HP '/' MaxHP]} => "|cffffffff50/100|r" 。
		</p>
	</body></html>]=]
	
	-- Docs
	-- Math
	L["Round number to the one's place or the place specified by digits"] = "四捨五入數字到個位，或者到所指定的位數"
	L["Take the floor of number"] = "返回小於等於指定數位的最大整數"
	L["Take the ceiling of number"] = "返回小於等於指定數位的最小整數"
	L["Take the absolute value of number"] = "返回指定數字的絕對值"
	L["Take the signum of number"] = "返回指定數位的符號"
	L["Return the greatest value of the given arguments"] = "返回給定參數中的最大值"
	L["Return the smallest value of the given arguments"] = "返回給定參數中的最小值"
	L["Return the mathematical number π, or %s"] = "返回π的值，即%s"
	L["Convert radian into degrees"] = "將弧度轉換為角度"
	L["Convert degree into radians"] = "將角度轉換為弧度"
	L["Return the cosine of radian"] = "返回弧度的余弦值"
	L["Return the sin of radian"] = "返回弧度的正弦值"
	L["Return the natural log of number"] = "返回指定數位的自然對數"
	L["Return the log base 10 of number"] = "返回指定數字以10為底的對數"
	-- Operators
	L["Add left and right together"] = "將左右值相加"
	L["Subtract right from left"] = "從左值中減去右值"
	L["Multiple left and right together"] = "將左右值相乘"
	L["Divide left by right"] = "用左值除以右值"
	L["Take the modulus of left and right"] = "用左值除以右值，返回餘數"
	L["Raise left to the right power"] = "返回左值的右值次冪"
	L["Check if left is less than right, if so, return left"] = "如果左值比右值小，則返回左值"
	L["Check if left is greater than right, if so, return left"] = "如果左值比右值大，則返回左值"
	L["Check if left is less than or equal to right, if so, return left"] = "如果左值小於等於右值，則返回左值"
	L["Check if left is greater than or equal to right, if so, return left"] = "如果左值大於等於右值，則返回左值"
	L["Check if left is equal to right, if so, return left"] = "如果左右兩值相等，則返回左值"
	L["Check if left is not equal to right, if so, return left"] = "如果左右兩值不等，則返回左值"
	L["Return the negative of number"] = "返回指定數字的相反值"
	-- Text manipulation
	L["Append a percentage sign to the end of number"] = "在數位後面添加一個百分數符號"
	L["Shorten value to have at maximum 3 decimal places showing"] = "將數字簡寫到最多只有3位元的顯示方式"
	L["Shorten value to its closest denomination"] = "將數字簡寫到最貼近的千位值"
	L["Turn value into an uppercase string"] = "將值轉換為全部大寫的形式"
	L["Turn value into an lowercase string"] = "將值轉換為全部小寫的形式"
	L["Wrap value with square brackets"] = "將值用方括號括起來"
	L["Wrap value with angle brackets"] = "將值用尖括弧括起來"
	L["Wrap value with braces"] = "將值用大括弧括起來"
	L["Wrap value with parentheses"] = "將值用小括弧括起來"
	L["Truncate value to the length specified by number, adding ellipses by default"] = "將值截斷到指定的長度，默認添加省略號"
	L["Return the characters specified by start and finish. If either are negative, it means take from the end instead of the beginning"] = "返回兩個參數所指定的位置之間的字串。如果其中一個參數為負，則表明是從後往前而不是從前往後"
	L["Repeat value number times"] = "將值重複拼接指定的次數"
	L["Return the length of value"] = "返回值的長度"
	L["Turn number_value into a roman numeral."] = "將一個數位值轉化為羅馬樣式"
	L["Abbreviate value if a space is found"] = "如果值有空格，則返回整個值的首字母縮寫"
	L["Concatenate the values of ... as long as they are all non-blank"] = "當所有給定值都不為空時，拼接所有的值"
	L["Append right to left if right exists"] = "如果右值存在，則將右值附加在左值之後"
	L["Prepend left to right if right exists"] = "如果右值存在，則將右值附加在左值之前"
	-- Misc
	L["Return True if the Alt key is held down"] = "如果Alt正在按下則返回True"
	L["Return True if the Shift key is held down"] = "如果Shift正在按下則返回True"
	L["Return True if the Ctrl key is held down"] = "如果Ctrl正在按下則返回True"
	L["Return the current time in seconds, specified by WoW's internal format"] = "以魔獸的內部格式返回當前的時間，以秒為單位"
	L["Set the transparency of the FontString according to argument"] = "依據參數設置FontString的透明度"
	L["Set the FontString to be outlined"] = "讓FontString有外描線"
	L["Set the FontString to be outlined thickly"] = "讓FontString有較粗的外描線"
	L["Return True if currently mousing over the Frame the FontString is harbored in"] = "如果當前滑鼠懸停框體是FontString所停靠的話，返回True"
	L["Return the color or wrap value with the rrggbb color of argument"] = "返回顏色，或者依據參數用顏色代碼(rrggbb)將值括起來"
	L["Return the color or wrap value with %s color"] = "返回顏色，或者用%s代碼將值括起來"
	L["Return value if value is within ..."] = "如果值存在於參數中，則返回值"
	L["Hide value if value is within ..."] = "如果值不存在於參數中，則返回值"
	L["Return left if left contains right"] = "如果左值包含了右值，則返回左值"
	L["Return True if non-blank"] = "如果值不為空則返回True"
	L["Return a string formatted by format"] = "返回按指定格式格式化的字串"
	L["Return a string formatted by format. Use 'e' for extended, 'f' for full, 's' for short, 'c' for compressed."] = "返回按指定格式格式化的字串。'e'為擴展格式，'f'為完整格式，'s'為簡短格式，'c'為壓縮格式。"
	L["Return an icon using the given path"] = "返回依據指定的路徑和大小所生成的圖示"
end

end
