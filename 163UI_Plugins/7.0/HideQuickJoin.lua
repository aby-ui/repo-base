--- coded by warbaby. please keep this line, thank you.
local btn = QuickJoinToastButton
local hider = CreateFrame("Frame", UIParent)
hider:SetPoint("BOTTOMLEFT", -500, -500)
hider:Hide()

function U1Toggle_QuickJoinToasts(allow, loading)
    if allow then
        btn:RegisterEvent("SOCIAL_QUEUE_UPDATE")
        btn.Toast:SetParent(btn)
        btn.Toast2:SetParent(btn)
        if not loading then U1Message("已允许快速加入提示", .5, 1, .5) end
    else
        btn:UnregisterEvent("SOCIAL_QUEUE_UPDATE")
        btn.Toast:SetParent(hider)
        btn.Toast2:SetParent(hider)
        U1Message("已屏蔽快速加入提示，可在'贴心小功能'中设置", 1, .5, .5)
    end
end
