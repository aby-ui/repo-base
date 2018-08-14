U1RegisterAddon("WorldFlightMap", {
    title = "世界飞行地图",
    tags = { TAG_MAPQUEST },
    desc = "替换暴雪7.0默认的飞行地图界面，使用带任务标记的普通世界地图。",
    load = "NORMAL",
    defaultEnable = 1,
    nopic = 1,
    icon = [[Interface\Icons\Icon_PetFamily_Flying]],

    toggle = function(name, info, enable, justload)
        if not WorldFlightMapFrame then return end
        if not justload then
            if enable then
                TaxiFrame:UnregisterEvent("TAXIMAP_CLOSED");
                UIParent:UnregisterEvent("TAXIMAP_OPENED");
                WorldFlightMapFrame:RegisterEvent('TAXIMAP_OPENED')
                WorldFlightMapFrame:RegisterEvent('TAXIMAP_CLOSED')
            else
                TaxiFrame:RegisterEvent("TAXIMAP_CLOSED");
                UIParent:RegisterEvent("TAXIMAP_OPENED");
                WorldFlightMapFrame:UnregisterEvent('TAXIMAP_CLOSED')
                WorldFlightMapFrame:UnregisterEvent('TAXIMAP_OPENED')
            end
        end
    end
});

U1RegisterAddon("!WorldFlightMapLoader", { hide = 1, protected = 1, load = "NORMAL" });
