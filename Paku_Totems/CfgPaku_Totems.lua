local isHorde = UnitFactionGroup("player") == "Horde"
if not isHorde then
    return U1RegisterAddon("Paku_Totems", { hide = 1 })
end

U1RegisterAddon("Paku_Totems", {
    title = "帕库图腾标记",
    defaultEnable = 0,
    tags = { TAG_MAPQUEST, TAG_GOOD },
    icon = "Interface\\ICONS\\Spell_Shaman_TotemRecall",
    nopic = 1,
})
