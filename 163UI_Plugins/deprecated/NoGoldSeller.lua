--    NoGoldSeller
--    World of Warcraft/TW-Hellscream/Horde/Sonicelement

local NGSenable=1
local NGSkilled=0
local NGSreport=0
local NGSid2=0
local NGSmatchs=1 --在這裡修改關鍵字配對個數.找到n個關鍵字則屏蔽,就改此處為n/在这里修改关键词配对个数.找到n个关键词则屏蔽,就改此处为n
NGSSymbols={" ",
	"_",
	"~",
	"'",
	"=",
	":",
	"-",
	"+",
	"*",
	"ô",
	"#",
	"%.",
	"%,",
	"%(",
	"%)",
	"%[",
	"%]",
	"%{",
	"%}",
	"%.",
	"%/",
	"　",
	"！",
	"“",
	"”",
	"＝",
	"？",
	"·",
	"；",
	"、",
	"，",
	"…",
	"→",
	"。",
	"：",
	"（",
	"）",
	"「",
	"」",
	"『",
	"』",
	"《",
	"》",
	"【",
	"】",
	"＿",
	"æ",
	"◇",
	"♂",
	"‖",
	"￥",
	"∞",
	"〓",
	"≡",
	"—"} 
--在這裡修改要清除的干擾字符/在这里修改要清除的干扰字符
if (GetLocale() == "zhTW") then
  NGSwords = {"淘寶",
	"淘宝",
	"旺旺",
	"純手工",
	"纯手工",
	"牛肉",
	"萬斤",
	"手工金",
	"手工G",
	"平臺",
	"黑一賠",
	"皇冠店",
	"代練",
	"代打",
	"沖鑽",
	"衝鑽",
	"非球不愛",
	"積分",
	"總元帥",
	"高階督軍",
	"高督",
	"1-85",
	"1_85",
	"消保",
	"好評率",
	"①",
	"⑴",
	"⒈",
	"1o",
	"②",
	"⑵",
	"⒉",
	"2o",
	"③",
	"⑶",
	"⒊",
	"④",
	"⑷",
	"⒋",
	"⑤",
	"⑸",
	"⒌",
	"⑥",
	"⑹",
	"⒍",
	"⑦",
	"⑺",
	"⒎",
	"⑧",
	"⑻",
	"⒏",
	"8o",
	"⑨",
	"⑼",
	"⒐",
	"9o",
	"ò",
	"O0",
	"八O",
	"八o",
	"珈Q",
	"九O",
	"九o",
	"六o"
	} 
  --(正體中文)在這裡修改關鍵字,以" "包括,以,分隔.
  NGSrep="|cff3399FFNGS:|r本次登錄到現在已經截獲|cff00ff00%d|r條廣告訊息."
  NGSturnoff="|cff00ff00NoGoldSeller:出售金幣廣告信息屏蔽插件已經停用.輸入/NGS on啟用.|r"
  NGSturnon="|cff00ff00NoGoldSeller:出售金幣廣告信息屏蔽插件已經啟用.輸入/NGS off停用.|r"
  NGSrepFreq=20; --(正體中文)在這裡截獲報告頻率.幾條消息報告一次,就改此處為n.
else if (GetLocale() == "zhCN") then
    NGSwords = {"平台交易","担保","纯手工","淘宝","游戏币","代打","代练","工作室","战点","手工金","手工G","皇冠店","一赔","点心","冲钻","店铺","皇冠","评级","小卡","大卡","套餐","手工带","1_85","塞纳","代刷","带刷","牛肉","1-85","元=","G=","消保","好评"} 
	--(简体中文)在这里修改关键字,以" "包括,以,分隔.
    NGSrep="本次登录到现在已经截获|cff00ff00%d|r条广告信息。"
    NGSturnoff="|cff00ff00NoGoldSeller:出售金币广告信息屏蔽插件已经停用。输入/NGS on启用。|r"
    NGSturnon="|cff00ff00NoGoldSeller:出售金币广告信息屏蔽插件已经启用。输入/NGS off停用。|r"
    NGSrepFreq=1000; --(简体中文)在这里修改报告频率。n条消息报告一次，就该此处为n。
  else
    DEFAULT_CHAT_FRAME:AddMessage("請注意!\nNoGoldSeller只能在zhTW,zhCN下運行,不支持您現在的遊戲語言版本!已經自行禁用.")
	DEFAULT_CHAT_FRAME:AddMessage("WARNING!\nNoGoldSeller: This addon ONLY fits for Traditional Chinese (zhTW) & Simplified Chinese (zhCN) realms. Unsupport your game client. It has automatically disabled now.")
	NGSenable=2;
  end
end
local NGSdebug=0;

function IsGoldSeller(NGSself, NGSevent, NGSmsg, NGSauthor, _, _, _, NGSflag, _, _, _, _, NGSid)
  if(NGSenable==0 or NGSenable==2) then
    return false;
  end
  if (NGSdebug==0) then
	if ((NGSevent == "CHAT_MSG_WHISPER" and NGSflag == "GM") or UnitIsInMyGuild(NGSauthor) or UnitIsUnit(NGSauthor,"player") or UnitInRaid(NGSauthor) or UnitInParty(NGSauthor)) then 
		return false; 
	end
  end
  for _, NGSsymbol in ipairs(NGSSymbols) do
    NGSmsg, a = gsub(NGSmsg, NGSsymbol, "")
  end
  local NGSmatch = 0;
  local NGSnewString=""
  for _, NGSword in ipairs(NGSwords) do
    local NGSnewString, NGSresult= gsub(NGSmsg, NGSword, "");
	if (NGSresult > 0) then
	  NGSmatch = NGSmatch +1;
	end
  end
  if (NGSmatch >= NGSmatchs) then 
	if (not(NGSid == NGSid2)) then
		NGSkilled = NGSkilled + 1
		NGSreport = NGSreport + 1
		NGSid2 = NGSid
		
		if (NGSdebug == 1) then --debug
			DEFAULT_CHAT_FRAME:AddMessage(NGSauthor)
			DEFAULT_CHAT_FRAME:AddMessage(NGSevent)
			DEFAULT_CHAT_FRAME:AddMessage(NGSmsg)
			DEFAULT_CHAT_FRAME:AddMessage(NGSkilled)
		end
		
		if (NGSreport == NGSrepFreq) then
		DEFAULT_CHAT_FRAME:AddMessage(string.format(NGSrep, NGSkilled))
		NGSreport=0
		end
	end
	return true;
  else
    return false;
  end
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL",IsGoldSeller)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", IsGoldSeller) 
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", IsGoldSeller) 
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", IsGoldSeller) 
ChatFrame_AddMessageEventFilter("CHAT_MSG_ADDON", IsGoldSeller) 
ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE", IsGoldSeller) 



local function isInTable(t,v)
	for i, vv in pairs(t) do
		if vv==v then
			return i
		end
	end
	return false
end
local function removeFromTable(t,v)
	for _, vv in pairs(t) do
		if vv==v then
			return true
		end
	end
	return false
end
local function mergeTable(t1,t2)
	local mergedVs = {}
	for _, v in pairs(t2) do
		if not isInTable(t1,v) then
			tinsert(t1,v)
			tinsert(mergedVs,v)
		end
	end
	return mergedVs
end
local function diffTable(t1,t2)
	local removed = {}
	for _, v in pairs(t2) do
		local i = isInTable(t1,v)
		if i then
			table.remove(t1,i)
			tinsert(removed,v)
		end
	end
	return removed
end
local function escapewordlst(...)
	local lst = {}
	for i=1, select("#",...) do
		local word = select(i,...)
		tinsert(lst,word)
	end
	return lst
end
local subcmdfuncs = {
	["+keyword"] = function(...)
		print("添加关键词：",unpack(mergeTable(NGSwords,escapewordlst(...))))
	end ,
	["-keyword"] = function(...)
		print("移除关键词：",unpack(diffTable(NGSwords,escapewordlst(...))))
	end ,
	["+symbols"] = function(...)
		print("添加过滤字符：",unpack(mergeTable(NGSSymbols,escapewordlst(...))))
	end ,
	["-symbols"] = function(...)
		print("移除过滤字符：",unpack(diffTable(NGSSymbols,escapewordlst(...))))
	end ,
	["-l"] = function()
		print("NoGoldSeller 使用中的关键词：")
		print(unpack(NGSwords))
		print("NoGoldSeller 使用中的过滤字符：")
		print(unpack(NGSSymbols))
	end ,
	["on"] = function(...)
		DEFAULT_CHAT_FRAME:AddMessage(NGSturnon)
		NGSenable=1
	end ,
	["off"] = function(...)
		DEFAULT_CHAT_FRAME:AddMessage(NGSturnoff)
		NGSenable=nil
	end ,
	["?web"] = function(...)
		local url = "http://bbs.game.163.com/forum.php?mod=viewthread&tid=179662797"
        if ThreeDimensionsCode_Send and Cmd3DCode_CheckoutClientAndPrompt and Cmd3DCode_CheckoutClientAndPrompt("没有检测到有爱客户端，无法启动有爱内置浏览器") then
            ThreeDimensionsCode_Send("innerbrowser",url)
        else
        	print(url)
        end
	end ,
	["?"] = function(...)
		print("[查看详细的使用教程(内置浏览器)]")
		print(" /ngs ?web")
		print(" ")

		print("[启用NoGoldSeller聊天框过滤]")
		print(" /ngs on")
		print(" ")

		print("[关闭NoGoldSeller聊天框过滤]")
		print(" /ngs off")
		print(" ")

		print("[增加关键词]")
		print(" /ngs +k 关键词...")
		print(" 例如： “/ngs +k 淘宝 代练 90级”")
		print(" ")
		print("[移除关键词]")
		print(" /ngs -k 关键词...")
		print(" 例如： “/ngs -k 淘宝 代练 90级”")
		print(" ")

		print("[增加过滤字符]")
		print(" /ngs +s 关键词...")
		print(" 例如： “/ngs +s ① ② ③”")
		print(" ")
		print("[移除过滤字符]")
		print(" /ngs -s 关键词...")
		print(" 例如： “/ngs -s ① ② ③”")
		print(" ")

		print("[查看已添加的关键词和过滤字符]")
		print(" /ngs -l")
		print(" ")

		
	end ,
}
subcmdfuncs["+"] = subcmdfuncs["+keyword"]
subcmdfuncs["+k"] = subcmdfuncs["+keyword"]
subcmdfuncs["-"] = subcmdfuncs["-keyword"]
subcmdfuncs["-k"] = subcmdfuncs["-keyword"]
subcmdfuncs["+s"] = subcmdfuncs["+symbols"]
subcmdfuncs["-s"] = subcmdfuncs["-symbols"]
subcmdfuncs["+K"] = subcmdfuncs["+keyword"]
subcmdfuncs["-K"] = subcmdfuncs["-keyword"]
subcmdfuncs["+S"] = subcmdfuncs["+symbols"]
subcmdfuncs["-S"] = subcmdfuncs["-symbols"]
subcmdfuncs["ON"] = subcmdfuncs["on"]
subcmdfuncs["OFF"] = subcmdfuncs["off"]

SLASH_NGS1 = "/nogoldseller";
SLASH_NGS2 = "/NGS";
SlashCmdList["NGS"] = function(sargs,editor)
	local args = {}
	for _,v in pairs({strsplit(" ",sargs)}) do
		if #v>0 then
			tinsert(args,v)
		end
	end
	local subcmd = args[1]
	local func = (subcmd and subcmdfuncs[subcmd]) and subcmdfuncs[subcmd] or subcmdfuncs["?"]
	func( select(2,unpack(args)) )
end
  
