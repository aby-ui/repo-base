
if(GetLocale() == "zhCN") then
    TBT_LEFT_BUTTON = {
        water		= "水",
        food		= "食",
        stone		= "糖",
        unlock		= "锁",
    }

    TBT_RIGHT_BUTTON = {
        whisper		= "密",
        ask		    = "要",
        thank		= "谢",
    }

    TBT_CANT_CREATE_AUCTION = "无法进行拍卖，拍卖按钮不可用，可能是插件冲突。"


elseif(GetLocale() == "zhTW") then
    TBT_LEFT_BUTTON = {
        water		= "水",
        food		= "食",
        stone		= "糖",
        unlock		= "鎖",
    }

    TBT_RIGHT_BUTTON = {
        whisper		= "密",
        ask		    = "要",
        thank		= "謝",
    }

    TBT_CANT_CREATE_AUCTION = "無法進行拍賣，拍賣按鈕不可用，可能是插件衝突。"


else
    TBT_LEFT_BUTTON = {
        water		= "Water",
        food		= "Food",
        stone		= "Stone",
        unlock		= "Lock",
    }

    TBT_RIGHT_BUTTON = {
        whisper		= "tel",
        ask		    = "ask",
        thank		= "thx",
    }

    TBT_CANT_CREATE_AUCTION = "The auction button can't be clicked! Maybe addons confliction."
end

