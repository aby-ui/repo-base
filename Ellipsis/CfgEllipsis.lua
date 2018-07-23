
local function load_opt()
    U1LoadAddOn('Ellipsis_Options')
end

U1RegisterAddon("Ellipsis", {
    title = "法术计时",
    tags = { TAG_COMBATINFO },
    icon = [[Interface\Icons\SPELL_HOLY_BORROWEDTIME]],
    desc = "多功能法术计时器",
    defaultEnable = 0,
    nopic = 1,

    {
        text = '锁定/解锁位置',
        callback = function()
            if Ellipsis.db.profile.locked then
                Ellipsis:UnlockInterface()
            else
                Ellipsis:LockInterface()
            end
        end,
    },

    {
        text = '测试计时条',
        callback = function()
            load_opt()
            Ellipsis:SpawnExampleAuras()
        end,
    },

    {
        text = '开启/关闭线性冷却条',
        callback = function()
            load_opt()
            Ellipsis:CooldownsSet({"enabled"}, not Ellipsis.db.profile.cooldowns.enabled)
        end,
    },

    {
        text = "配置选项",
        callback = function()
            load_opt()
            return Ellipsis:OpenOptions()
        end,
    },
})

U1RegisterAddon("Ellipsis_Options", {title = '', hide = 1, })

