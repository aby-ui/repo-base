--[[
    {
        var = "CovenantHelper", text = U1_NEW_ICON.."盟约选择助手", default = true,
        callback = function(cfg, v, loading, ...)
            load(cfg, v, loading, true)
            if AbySoulbindFrame then
                AbySoulbindFrame:refresh()
            end
        end,
        tip = "说明`盟约NPC对话时自动选择第一个选项，并且在天赋选择界面右侧显示当前选择的灵魂羁绊。",
    },
--]]
local addonName = ...
U1PLUG["CovenantHelper"] = function()
    local covenants = { Fey=1, Kyrian=1, Necrolord=1, Venthyr=1, }
    local selectTime
    CoreOnEvent("GOSSIP_SHOW", function(event, covenant)
        if not U1GetCfgValue(addonName, 'CovenantHelper') then return end
        local options = C_GossipInfo.GetOptions()
        if covenants[covenant or ""] then
            if #options == 1 then
                C_GossipInfo.SelectOption(options[1].gossipOptionID)
                U1Message("小功能集合-盟约助手：自动选择了对话项目")
                selectTime = GetTime()
            end
        else
            if GetTime() - (selectTime or 0) < 1 then
                if #options == 2 then
                    C_GossipInfo.SelectOption(options[1].gossipOptionID)
                end
            end
        end
    end)

    CoreDependCall("Blizzard_ClassTalentUI", function()
        LoadAddOn("Blizzard_Soulbinds")

        local f = CreateFrame("Frame", "AbySoulbindFrame", ClassTalentFrame)
        f:Hide() --未Init之前Show会报错

        Mixin(f, BackdropTemplateMixin)
        f.tree = CreateFrame("Frame", nil, f, "SoulbindTreeTemplate")

        local scale = 0.7
        f:ClearAllPoints()
        f:SetPoint("TOPLEFT", ClassTalentFrame, "TOPRIGHT")
        f:SetSize(250*scale,855*scale)
        f:SetBackdrop({
            bgFile = [[Interface\TALENTFRAME\spec-blue-bg]],
            edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
            tile = true,
            tileSize = f:GetHeight(),
            edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })

        f.tree:SetPoint("TOPLEFT",40, -53)
        f.tree:SetScale(scale)

        local size = 36
        f.cov = WW:CheckButton(nil, f, "ActionButtonTemplate"):BL(12,10):Size(size):SetScale(0.8):SetEnabled(false):un()
        CoreUISetActionButtonSize10(f.cov, size)

        f.soulbinds = {}
        for i=1, 3 do
            local b = WW:CheckButton(nil, f, "ActionButtonTemplate"):Size(size):SetScale(1):un()
            CoreUISetActionButtonSize10(b, size)
            if i == 1 then
                b:SetPoint("LEFT", f.cov, "RIGHT", 7, 0)
            else
                b:SetPoint("TOPLEFT", f.soulbinds[i-1], "TOPRIGHT", 7, 0)
            end
            b:GetCheckedTexture():SetPoint("TOPLEFT", -5, 5)
            b:GetCheckedTexture():SetPoint("BOTTOMRIGHT", 5, -5)
            CoreUIEnableTooltip(b, "灵魂羁绊", "左键激活，右键打开暴雪界面")
            b:SetScript("OnClick", function(self, button)
                if button == "LeftButton" then
                    C_Soulbinds.ActivateSoulbind(self.sbid)
                else
                    SoulbindViewer:Open()
                    SoulbindViewer:OpenSoulbind(self.sbid)
                    self:SetChecked(self.sbid == C_Soulbinds.GetActiveSoulbindID())
                end
            end)
            b:RegisterForClicks("AnyUp")

            f.soulbinds[i] = b
        end

        f.refresh = function(self)
            local active = C_Soulbinds.GetActiveSoulbindID()
            local soulbindData = C_Soulbinds.GetSoulbindData(active);
            if not soulbindData then self:Hide() return end
            f.tree:Init(soulbindData)

            local covenantData = C_Covenants.GetCovenantData(soulbindData.covenantID);
            if not covenantData then
                for i, btn in ipairs(f.soulbinds) do btn:Hide() end
                f:Hide()
                return
            end

            if not U1GetCfgValue(addonName, 'CovenantHelper') then f:Hide() return end

            f:Show()
            f.cov.icon:SetTexture("interface/icons/ui_sigil_" .. covenantData.textureKit)
            f.cov.icon:SetTexCoord(.05, .95, .05, .95)

            for i, btn in ipairs(f.soulbinds) do
                local sbid = covenantData.soulbindIDs[i]
                local data = C_Soulbinds.GetSoulbindData(sbid);
                SetPortraitTextureFromCreatureDisplayID(btn.icon, data.modelSceneData.creatureDisplayInfoID)
                btn.tooltipTitle = data.name
                btn.tooltipAnchorPoint = "ANCHOR_BOTTOMRIGHT"
                btn.icon:SetTexCoord(.1, .9, .1, .9)
                btn.sbid = sbid
                btn:Show()
                btn:SetChecked(sbid == active)
            end
        end
        f:RegisterEvent("SOULBIND_ACTIVATED")
        f:SetScript("OnEvent", f.refresh)

        f.tree.OriginOnShow = f.tree:GetScript("OnShow")
        f.tree:SetScript("OnShow", function(self)
            f:refresh()
            self:OriginOnShow()
        end)

        f:SetShown(true)
        --CoreUIShowOverlayGlow(grp.b1)
        --LibStub("LibCustomGlow-1.0", true).AutoCastGlow_Start(AbySoulbindFrame.soulbinds[1])

        --[[ 10.0没有展开功能了
        hooksecurefunc("SetUIPanelAttribute", function(frame, prop, value)
            if frame and frame == PlayerTalentFrame and prop == "width" then
                frame:SetAttributeNoHandler("UIPanelLayout-"..prop, value + 100);
            end
        end)
        --]]
    end)
end

