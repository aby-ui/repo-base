-- ===================== Part for TradeLog ==================
TRADE_LOG_MONEY_NAME = {
	gold = "g",
	silver = "s",
	copper = "c",
}

CANCEL_REASON_TEXT = {
	self = "I cancelled it",
	other = "target cancelled it",
	toofar = "we are too faraway",
	selfrunaway = "I moved away",
	selfhideui = "I hid ui",
	unknown = "unknown reason",
}

TRADE_LOG_SUCCESS_NO_EXCHANGE = "Trade with [%t] was COMPLETED, but no exchange made.";
TRADE_LOG_SUCCESS = "Trade with [%t] was COMPLETED.";
TRADE_LOG_DETAIL = "Detail";
TRADE_LOG_CANCELLED = "Trade with [%t] was CANCELLED: %r.";
TRADE_LOG_FAILED = "Trade with [%t] was FAILED: %r.";
TRADE_LOG_FAILED_NO_TARGET = "Trade FAILED: %r.";
TRADE_LOG_HANDOUT = "lost";
TRADE_LOG_RECEIVE = "got";
TRADE_LOG_ENCHANT = "enchant";
TRADE_LOG_ITEM_NUMBER = "%d items";
TRADE_LOG_CHANNELS = {
	whisper = "Whisper",
	raid = "Raid",
	party = "Party",
	say = "Say",
	yell = "Yell",
}
TRADE_LOG_ANNOUNCE = "NOTIFY";
TRADE_LOG_ANNOUNCE_TIP = "Check this to automatically announce after trading."

TRADE_LOG_RESULT_TEXT_SHORT = { 
	cancelled = "cancel", 
	complete = "ok", 
	error = "failed", 
}

TRADE_LOG_RESULT_TEXT = {
	cancelled = "Trade Cancelled", 
	complete = "Trade Completed", 
	error = "Trade Failed", 
}

TRADE_LOG_MONTH_SUFFIX = "-"
TRADE_LOG_DAY_SUFFIX = ""

TRADE_LOG_COMPLETE_TOOLTIP = "Click to show detail";


RECENT_TRADE_TIME = "%d %s ago"
RECENT_TRADE_TITLE = "Recent Trade"

-- ===================== Part for TradeList ==================
TRADE_LIST_CLEAR_HISTORY = "CLEAR"
TRADE_LIST_SCALE = "Detail Scale"
TRADE_LIST_FILTER = "Completed Only"

TRADE_LIST_HEADER_WHEN = "Time"
TRADE_LIST_HEADER_WHO = "Recipent"
TRADE_LIST_HEADER_WHERE = "Location"
TRADE_LIST_HEADER_SEND = "Lost"
TRADE_LIST_HEADER_RECEIVE = "Got"
TRADE_LIST_HEADER_RESULT = "Result"

TRADE_LIST_CLEAR_CONFIRM = "Records before today will be totally cleared!";

TRADE_LIST_TITLE = "TradeLog"
TRADE_LIST_DESC = "Show recent trade logs, or the reasons of failed trades."