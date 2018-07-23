if(GetLocale() == "zhTW") then

-- ===================== Part for TradeLog ==================
TRADE_LOG_MONEY_NAME = {
	gold = "g",
	silver = "s",
	copper = "c",
}

CANCEL_REASON_TEXT = {
	self = "我取消了交易",
	other = "對方取消了交易",
	toofar = "雙方距離過遠",
	selfrunaway = "我超出了距離",
	selfhideui = "我隱藏了界面,交易窗口關閉",
	unknown = "未知原因",
}

TRADE_LOG_SUCCESS_NO_EXCHANGE = "與[%t]交易成功, 但是沒有做任何交換。";
TRADE_LOG_SUCCESS = "與[%t]交易成功。";
TRADE_LOG_DETAIL = "詳情";
TRADE_LOG_CANCELLED = "與[%t]交易取消: %r。";
TRADE_LOG_FAILED = "與[%t]交易失敗: %r。";
TRADE_LOG_FAILED_NO_TARGET = "交易失敗: %r。";
TRADE_LOG_HANDOUT = "交出";
TRADE_LOG_RECEIVE = "收到";
TRADE_LOG_ENCHANT = "附魔";
TRADE_LOG_ITEM_NUMBER = "%d件物品";
TRADE_LOG_CHANNELS = {
	whisper = "密語",
	raid = "團隊",
	party = "小隊",
	say = "說",
	yell = "喊",
}
TRADE_LOG_ANNOUNCE = "通告";
TRADE_LOG_ANNOUNCE_TIP = "選中就會將交易信息發送到指定的頻道"

TRADE_LOG_RESULT_TEXT_SHORT = { 
	cancelled = "取消", 
	complete = "成功", 
	error = "失敗", 
}

TRADE_LOG_RESULT_TEXT = { 
	cancelled = "交易取消", 
	complete = "交易成功", 
	error = "交易失敗", 
}

TRADE_LOG_MONTH_SUFFIX = "月"
TRADE_LOG_DAY_SUFFIX = "日"

TRADE_LOG_COMPLETE_TOOLTIP = "點擊鼠標左鍵查看交易的詳細信息";


RECENT_TRADE_TIME = "%d%s前"
RECENT_TRADE_TITLE = "近期與此人的交易"

-- ===================== Part for TradeList ==================
TRADE_LIST_CLEAR_HISTORY = "清除記錄"
TRADE_LIST_SCALE = "詳情窗口縮放"
TRADE_LIST_FILTER = "僅列出成功交易"

TRADE_LIST_HEADER_WHEN = "交易時間"
TRADE_LIST_HEADER_WHO = "交易對象"
TRADE_LIST_HEADER_WHERE = "交易地點"
TRADE_LIST_HEADER_SEND = "交出"
TRADE_LIST_HEADER_RECEIVE = "獲得"
TRADE_LIST_HEADER_RESULT = "結果"

TRADE_LIST_CLEAR_CONFIRM = "今天以外的紀錄都將被清除!";
TRADE_LIST_TITLE = "交易記錄"
TRADE_LIST_DESC = "可以查看最近所有的交易記錄，包括失敗的原因。"
end