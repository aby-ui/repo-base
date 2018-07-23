local PROFILE_SIMPLE = "有爱-简洁"
local Profiles, CreateProfileAndApply

U1RegisterAddon("Parrot", {
    title = "浮动战斗信息",
    defaultEnable = 0,
    load = "LOGIN",

    tags = { TAG_COMBATINFO, },
    icon = [[Interface\Icons\Spell_Nature_ForceOfNature]],

    desc = "战斗信息滚动显示插件，可以显示技能图标等酷炫效果，通过命令：/parrot进入设置页面，可以设置滚动区域、条件触发等高级功能。",
    toggle = function(name, info, enable, justload)
        if justload then
        end
        return true
    end,

    {
        text = "配置选项",
        tip = "快捷命令`/parrot",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_PARROT"]() end,
    },

    {
        text = "调整滚动区域位置",
        callback = function()
            --force call OnOptionsCreate
            Parrot:ShowConfig() LibStub('AceConfigDialog-3.0'):Close("Parrot") --ACD3:Open("Parrot", "scrollAreas")
            local option = Parrot.options.args.scrollAreas.args.config
            option.set(nil, not option.get())
        end
    },

    {
        text = "隐藏(5x 2++)这样的数字",
        var = "hideThrottleText",
        default = true,
        getvalue = function() return Parrot:GetModule("CombatEvents").db1.profile.hideThrottleText end,
        callback = function(info, v, loading)
            Parrot:GetModule("CombatEvents").db1.profile.hideThrottleText = v
        end
    },

    {
        text = "缩写数字",
        var = "shortenAmount",
        default = true,
        getvalue = function() return Parrot:GetModule("CombatEvents").db1.profile.shortenAmount end,
        callback = function(info, v, loading)
            Parrot:GetModule("CombatEvents").db1.profile.shortenAmount = v
        end,

        {
            text = "缩写方式",
            var = "type",
            type = "drop",
            tip = "说明`第一个选项是使用英文缩写习惯，千进位。后面选项表示有效位数",
            options = {"英文习惯", 1, "99万, 9.9万", 2, "99.9万, 99999", 3},
            default = 2,
            callback = function(info, v, loading)
                Parrot:GetModule("CombatEvents").db1.profile.shortenAmountType = v
            end,
        }
    },

    {
        var = "profile",
        text = "选择配置方案",
        type = "radio",
        default = PROFILE_SIMPLE,
        options = { '恢复原风格', 'Default', '简洁风格', PROFILE_SIMPLE, },
        cols = 2,
        getvalue = function() return Parrot.db1:GetCurrentProfile() end,
        callback = function(info, v, loading)
            if loading then
                hooksecurefunc(Parrot.db1, "ResetProfile", function(self, ...)
                    if Profiles[self:GetCurrentProfile()] then
                        CreateProfileAndApply(self:GetCurrentProfile())
                    end
                end)

                local tbl = Parrot.db1:GetProfiles()
                local found
                for _, name in ipairs(tbl) do
                    if name == PROFILE_SIMPLE then
                        found = true
                        break
                    end
                end
                if not found then
                    CreateProfileAndApply(PROFILE_SIMPLE)
                    if not Parrot.firstRun and v == PROFILE_SIMPLE then
                        U1Message("Parrot方案自动设置为'"..PROFILE_SIMPLE.."', 可以在控制台中复原")
                    end
                end
            else
                Parrot:ShowConfig() LibStub('AceConfigDialog-3.0'):Close("Parrot") --LibStub('AceConfigDialog-3.0'):Open("Parrot", "profiles")
                U1Message("已切换至'" .. v .. "'配置方案")
            end
            Parrot.db1:SetProfile(v)
        end
    },

    {
        text = "重置所选配置方案",
        desc = "说明`如果当前选择默认，则恢复为插件自带的默认值。如果当前选择为简洁，则恢复为预设的简洁方案。",
        confirm = "已修改的配置内容将丢弃，且不可恢复。\n是否继续？",
        callback = function()
            Parrot.db1:ResetProfile()
        end
    }
});

Profiles = {
    [PROFILE_SIMPLE] = {
        ScrollAreas = {
            areas = {
                Notification = { stickyDirection = "UP;CENTER", direction = "DOWN;LEFT", xOffset = 180, yOffset = -100, size = 150, animationStyle = "Straight", stickyAnimationStyle = "Pow", },
                Outgoing = { stickyDirection = "UP;LEFT", direction = "UP;RIGHT", xOffset = 140, yOffset = 190, iconSide = "RIGHT", speed = 2, size = 80, animationStyle = "Straight", stickyAnimationStyle = "Pow", },
                Incoming = { stickyDirection = "DOWN;RIGHT", direction = "DOWN;RIGHT", xOffset = -130, yOffset = -100, iconSide = "RIGHT", size = 150, animationStyle = "Straight", stickyAnimationStyle = "Pow", },
            },
        },
        CombatEvents = {
            dbver = 5, disabled = false, hideSkillNames = true,
            Notification = {
                ["Currency gains"] = { disabled = false, },
                ["Enemy debuff gains"] = { disabled = true, },
                ["Power gain"] = { disabled = true, },
                ["Pet debuff gains"] = { disabled = true, },
                ["Experience gains"] = { disabled = false, sticky = false, },
                ["Debuff fades"] = { disabled = true, },
                ["Pet buff gains"] = { disabled = true, },
                ["Target buff gains"] = { disabled = true, },
                ["Enemy buff gains"] = { disabled = true, },
                ["Combo points full"] = { disabled = true, },
                ["Debuff gains"] = { disabled = true, },
                ["Reputation gains"] = { disabled = false, },
                ["Buff stack gains"] = { disabled = true, },
                ["Enemy buff fades"] = { disabled = true, },
                ["Enter combat"] = { disabled = false, },
                ["Item buff fades"] = { disabled = true, },
                ["Item buff gains"] = { disabled = true, },
                ["Combo point gain"] = { disabled = true, },
                ["Pet debuff fades"] = { disabled = true, },
                ["Power loss"] = { disabled = true, },
                ["Pet buff fades"] = { disabled = true, },
                ["Target buff stack gains"] = { disabled = true, },
                ["Skill cooldown finish"] = { disabled = true, },
                ["Skill gains"] = { disabled = false, },
                ["Reputation losses"] = { disabled = false, },
                ["Leave combat"] = { disabled = false, },
                ["Enemy debuff fades"] = { disabled = true, },
                ["Extra attacks"] = { disabled = false, },
                ["Buff fades"] = { disabled = true, },
                ["NPC killing blows"] = { disabled = false, },
                ["Player killing blows"] = { disabled = false, },
                ["Buff gains"] = { disabled = true, },
                ["Debuff stack gains"] = { disabled = true, },
            },
            --/save Parrot.modules.CombatEvents.db1.profile.Outgoing
            Outgoing = {
              ["Pet heals over time"] = { disabled = true, },
              ["Pet melee absorbs"] = { disabled = true, },
              ["Pet melee blocks"] = { disabled = true, },
              ["Pet melee damage"] = { disabled = true, },
              ["Pet melee deflects"] = { disabled = true, },
              ["Pet melee dodges"] = { disabled = true, },
              ["Pet melee evades"] = { disabled = true, },
              ["Pet melee immunes"] = { disabled = true, },
              ["Pet melee misses"] = { disabled = true, },
              ["Pet melee parries"] = { disabled = true, },
              ["Pet melee reflects"] = { disabled = true, },
              ["Pet melee resists"] = { disabled = true, },
              ["Pet skill DoTs"] = { disabled = true, },
              ["Pet skill absorbs"] = { disabled = true, },
              ["Pet skill blocks"] = { disabled = true, },
              ["Pet skill deflects"] = { disabled = true, },
              ["Pet skill dodges"] = { disabled = true, },
              ["Pet skill evades"] = { disabled = true, },
              ["Pet skill immunes"] = { disabled = true, },
              ["Pet skill misses"] = { disabled = true, },
              ["Pet skill parries"] = { disabled = true, },
              ["Pet skill reflects"] = { disabled = true, },
              ["Pet skill resists"] = { disabled = true, },
            },
            Incoming = {
              ["Heals over time"] = { disabled = true, },
              ["Pet heals over time"] = { disabled = true, },
              ["Pet melee absorbs"] = { disabled = true, },
              ["Pet melee blocks"] = { disabled = true, },
              ["Pet melee damage"] = { disabled = true, },
              ["Pet melee deflects"] = { disabled = true, },
              ["Pet melee dodges"] = { disabled = true, },
              ["Pet melee evades"] = { disabled = true, },
              ["Pet melee immunes"] = { disabled = true, },
              ["Pet melee misses"] = { disabled = true, },
              ["Pet melee parries"] = { disabled = true, },
              ["Pet melee reflects"] = { disabled = true, },
              ["Pet melee resists"] = { disabled = true, },
              ["Pet skill DoTs"] = { disabled = true, },
              ["Pet skill absorbs"] = { disabled = true, },
              ["Pet skill blocks"] = { disabled = true, },
              ["Pet skill damage"] = { disabled = true, },
              ["Pet skill deflects"] = { disabled = true, },
              ["Pet skill dodges"] = { disabled = true, },
              ["Pet skill evades"] = { disabled = true, },
              ["Pet skill immunes"] = { disabled = true, },
              ["Pet skill misses"] = { disabled = true, },
              ["Pet skill parries"] = { disabled = true, },
              ["Pet skill reflects"] = { disabled = true, },
              ["Pet skill resists"] = { disabled = true, },
              ["Self heals over time"] = { disabled = true, },
              ["Skill DoTs"] = { disabled = true, },
            },
            modifier = {
                overheal = { enabled = false, },
                absorb = { enabled = false, },
                overkill = { enabled = false, },
                resist = { enabled = false, },
                vulnerable = { enabled = false, },
                block = { enabled = false, },
            },
            filters = {
                ["Incoming heals"] = 1,
                ["Power gain"] = 1,
                ["Incoming damage"] = 1,
            },
        },
        Display = {
            fontOutline = "OUTLINE",
        }
    }
}

function CreateProfileAndApply(name)
    Parrot.db1:SetProfile(name)
    for k,v in pairs(Profiles[name]) do
        if type(v) == "table" then
            deepmix(Parrot.db1.children[k].profile, v)
        end
    end
    Parrot.db1:SetProfile(name)
end