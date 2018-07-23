--    NoGoldSeller
--    Copyright (C) 2012  World of Warcraft/TW-Hellscream/Horde/Sonicelement
local NGSenable=1
local NGSkilled=0
local NGSreport=0
local NGSid2=0
local NGSmatchs=2 --在這裡修改關鍵字配對個數.找到n個關鍵字則屏蔽,就改此處為n/在这里修改关键词配对个数.找到n个关键词则屏蔽,就改此处为n
local NGSSymbols={"`","~","@","#","^","*","=","|"," ","，","。","、","？","！","：","；","’","‘","“","”","【","】","『","』","《","》","<",">","（","）"} 
--在這裡修改要清除的干擾字符/在这里修改要清除的干扰字符
if (GetLocale() == "zhTW") then		--(正體中文)在這裡修改關鍵字,以" "包括,以,分隔.
	NGSwords = {"淘寶","淘宝","旺旺","純手工","纯手工","牛肉","萬斤","手工金","手工G","平臺","黑一賠","皇冠店","代練","代打","沖鑽","衝鑽","非球不愛","積分",
				"總元帥","高階督軍","高督","1-85","消保","好評率"}		
	NGSrep="|cff3399FFNGS:|r本次登錄到現在已經截獲|cff00ff00%d|r條廣告訊息."
	NGSturnoff="|cff00ff00NoGoldSeller:出售金幣廣告信息屏蔽插件已經停用.輸入/NGS啟用.|r"
	NGSturnon="|cff00ff00NoGoldSeller:出售金幣廣告信息屏蔽插件已經啟用.輸入/NGS停用.|r"
	NGSrepFreq=20 --(正體中文)在這裡截獲報告頻率.幾條消息報告一次,就改此處為n.
elseif (GetLocale() == "zhCN") then	--(简体中文)在这里修改关键字,以" "包括,以,分隔.
	NGSwords = {"大尾巴","平台交易","担保","承接","工作室","纯手工","游戏币","代打","代练","战点","手工金","手工G","托管","带级","皇冠店","一赔","套装消费",
				"點心","冲钻","店铺","皇冠","小卡","大卡","大饼","小饼","特惠","服务","加盟","七煌","套餐","手工带","塞纳","尘埃","Style","落叶","代刷",
				"代抓","带刷","牛肉","专业","毕业","大桥","QQ","企鹅","联系","点心","-60","-100","-90","2200","2400","3200","0元","消保","好评","优惠","付款",
				"默默","续费","充值","大桥","美味","梦想","黄金","战场","征服","打扰","小花","大花","出货","丫丫","声旺","一波流","小號","渃葉","熵会","落夜",
				"天意","佰圆","二佰","二二","金币","收金","万G","點訫","军装","浅唱","吖妹","续费","大时间","小时间","660","保驾护航","贰百","0万","W金","PJ40",
				"肖废","万金","0块","3015","點芯","-100","90-","美味","W=","可散卖","一百","⒈","⒐","⒉","⒎","萬G","畅游","￥","代刷","陶宝","點訫","宝儿",
				"點.卡","饼干","老牌经营","G出售","买G","重.拳.戈.隆","全.网.最.低","荣.誉_征.服","RMB=","包团包毕业","风神无敌","无敌0灯","小可爱","刷红玉",
				"荣.誉","征.服","荣.征","誉.服","波塞冬斯","的Q","小-可","可-爱","H副本","抱团","最后一波","站神","小.甜.心","大/小","小.可","可.爱","十万G",
				"带红玉","接招募","二.佰","42.W","千与千寻","夕瑶歌尽","大{rt2}","小{rt2}","刷屏[勿见]","扰屏[勿见]","月下G","包团","包毕业","挑Z","雪亽",
				"陶{rt2}","{rt2}shop","冰{rt2}","点{rt2}","冰{@}点","挑{@}战","上.陶","锈水财阀","水财阀","{*}冰","{*}点","{*}竞{*}技","月下G团","月下G",
				"牛牛","冰封H黑","封H黑石","大尾巴","内销G团","价格公道","强力老板","躺尸老板","价格便宜啦","黑石G团","皇朝","老板无竞争","强力消费","来老板",
				"跨服H黑石","G团包过","消费老板","消费的老板","支F宝","纵横魔兽","支持躺尸","⑥","⑤","黑石铸造厂","$带走","比例1W","马云消费","散卖","正负",
				"消废","黑石G团","职业老板","清倉","H畢業","黑手门票","软妹"}
	NGSrep="|cff3399FFNGS:|r本次登录到现在已经截获|cff00ff00%d|r条广告信息。"
	NGSturnoff="|cff00ff00NoGoldSeller:出售金币广告信息屏蔽插件已经停用。输入/NGS启用。|r"
	NGSturnon="|cff00ff00NoGoldSeller:出售金币广告信息屏蔽插件已经启用。输入/NGS停用。|r"
	NGSrepFreq=100 --(简体中文)在这里修改报告频率。n条消息报告一次，就该此处为n。
else
	DEFAULT_CHAT_FRAME:AddMessage("請注意!\nNoGoldSeller只能在zhTW,zhCN下運行,不支持您現在的遊戲語言版本!已經自行禁用.")
	DEFAULT_CHAT_FRAME:AddMessage("WARNING!\nNoGoldSeller: This addon ONLY fits for Traditional Chinese (zhTW) & Simplified Chinese (zhCN) realms. Unsupport your game client. It has automatically disabled now.")
	NGSenable=2
end

local NGSdebug=0

local function IsGoldSeller(NGSself, NGSevent, NGSmsg, NGSauthor, _, _, _, NGSflag, _, _, _, _, NGSid)
	if(NGSenable==0 or NGSenable==2) then
		return false
	end
	if (NGSdebug==0) then
		if ((NGSevent == "CHAT_MSG_WHISPER" and NGSflag == "GM") or UnitIsInMyGuild(NGSauthor) or UnitIsUnit(NGSauthor,"player") or UnitInRaid(NGSauthor) or UnitInParty(NGSauthor)) then 
			return false 
		end
	end
	for _, NGSsymbol in ipairs(NGSSymbols) do
		NGSmsg, a = gsub(NGSmsg, NGSsymbol, "")
	end
	local NGSmatch = 0
	local NGSnewString = ""
	for _, NGSword in ipairs(NGSwords) do
	local NGSnewString, NGSresult= gsub(NGSmsg, NGSword, "")
		if (NGSresult > 0) then
			NGSmatch = NGSmatch +1
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
		return true
	else
		return false
	end
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL",IsGoldSeller)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", IsGoldSeller) 
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", IsGoldSeller) 
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", IsGoldSeller) 
ChatFrame_AddMessageEventFilter("CHAT_MSG_ADDON", IsGoldSeller) 
ChatFrame_AddMessageEventFilter("CHAT_MSG_TEXT_EMOTE", IsGoldSeller)

SLASH_NGS1 = "/nogoldseller"
SLASH_NGS2 = "/NGS"
SlashCmdList["NGS"] = function(cmd)
	if (NGSenable==2) then
		DEFAULT_CHAT_FRAME:AddMessage("請注意!\nNoGoldSeller只能在zhTW,zhCN下運行,不支持您現在的遊戲語言版本!已經自行禁用.")
		DEFAULT_CHAT_FRAME:AddMessage("WARNING!\nNoGoldSeller: This addon ONLY fits for Traditional Chinese (zhTW) & Simplified Chinese (zhCN) realms. Unsupport your game client. It has automatically disabled now.")
	end
	if (NGSenable==1) then
		DEFAULT_CHAT_FRAME:AddMessage(NGSturnoff)
		NGSenable=0
	else
		DEFAULT_CHAT_FRAME:AddMessage(NGSturnon)
		NGSenable=1
	end
end