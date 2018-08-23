U1RegisterAddon("WhisperPop", {
    title = "密语记录",
    defaultEnable = 1,
    optionsAfterVar = 1,
    load = "LOGIN", --防止恢复历史的时候清除最新的密语
    frames = {"WhisperPopFrame", "WhisperPopNotifyButton"}, --需要保存位置的框体

    tags = { TAG_CHAT,},
    icon = "Interface\\Icons\\INV_Letter_05",
    desc = "Abin的老牌插件，可以记录玩家收到和发送的所有密语信息，并在有新密语到来时播放声音或闪动图标进行提醒。`在聊天窗口左上角的社交按钮上方，有此插件的提醒图标，点击即可打开密语记录窗口。所有密语信息已根据玩家名字分组，鼠标移上去即可查看。同时shift点击人名可查询详情，alt点击可以邀请入队，右键点击则可打开玩家菜单。`爱不易特别增加了保留历史记录的功能，但请不要在网吧等公共环境使用，以免泄漏私人信息。",

    toggle = function(name, info, enable, justload)
        if justload and WhisperPopNotifyButton then
            local button = WhisperPopNotifyButton
            button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
            local leftClick = button:GetScript("OnClick")
            button:SetScript("OnClick", function(self, button)
                if button == "RightButton" then
                    UUI.OpenToAddon(name, true)
                    self:SetChecked(false)
                else
                    leftClick(self, button)
                end
            end)
        end
    end,

    {
        text = "打开密语窗口",
        callback = function(cfg, v, loading) WhisperPop:ToggleFrame() end,
    },

    {
        text = "配置选项",
        callback = function(cfg, v, loading) WhisperPopOptionFrame:Open() end
    },

    {
        text = "重置提示按钮位置",
        callback = function(cfg, v, loading)
            local button = WhisperPopNotifyButton
            button:ClearAllPoints()
            button:SetPoint('TOP', QuickJoinToastButton, 'BOTTOM', 0, -2)
        end
    }

});