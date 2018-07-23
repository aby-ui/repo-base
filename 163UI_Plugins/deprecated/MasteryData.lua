
--[[------------------------------------------------------------
精通显示
---------------------------------------------------------------]]
local MASTERY_DATA = {
    HUNTER = { 86472,76657,76659,76658, },
    ROGUE = { 86476,76803,76806,76808, },
    WARRIOR = { 86479,76838,76856,76857, },
    DEATHKNIGHT = { 86471,77513,77514,77515, },
    DRUID = { 86470,77492,{77493,77494},77495, },
    PALADIN = { 86474,76669,76671,76672, },
    SHAMAN = { 86477,77222,77223,77226, },
    WARLOCK = { 86478,77215,77219,77220, },
    PRIEST = { 86475,77484,77485,77486, },
    MAGE = { 86473,76547,76595,76613, },
}
local MASTERY_DATA_G = {}
for k, v in pairs(MASTERY_DATA) do MASTERY_DATA_G[tostring(v[1])] = {k} end
function GetMasteryInfo(self, class, tab)
    local data = MASTERY_DATA_G[tostring(MASTERY_DATA[class][1])];
    if #data==1 then --未获取过
        for i=1, 3 do
            local spells = MASTERY_DATA[data[1]][i+1];
            if type(spells)=="number" then spells = { spells } end
            for _, spell in ipairs(spells) do
                self:SetSpellByID(spell);
                local name = _G[self:GetName().."TextLeft1"]:GetText();
                local text2 = _G[self:GetName().."TextLeft2"]:GetText();
                local info = {}
                if data[1]=="DRUID" and i==2 then
                    info.require = text2;
                    text2 = _G[self:GetName().."TextLeft3"]:GetText();
                end
                local pos = text2:find("。每点精通值");
                if not pos then
                    pos = text2:find("%.每点精通值")
                    if not pos then
                        print("无法解析精通技能说明："..text2)
                        return
                    else
                        pos = pos + 0
                    end
                else
                    pos = pos + 2
                end
                info.name = name.." ("..GetClassTalentName(data[1], i)..")";
                info.detail = text2:sub(1,pos);
                info.calc = text2:sub(pos+1);
                info.per = tonumber(select(3,info.calc:find("每点精通值.-([0-9%.]+)%%")));
                if data[1]=="WARRIOR" and i==2 then
                    info.base = 11.20; --不羁之怒起始为11.2;
                else
                    info.base = info.per * 8;
                end
                data[i+1] = data[i+1] or {};
                table.insert(data[i+1], info);
            end
        end
    end
    return data[tab+1];
end
local function hookSetHyperlink(self, link)
    if(link:sub(1,6)=="spell:")then
        local id=link:sub(7);
        local data = MASTERY_DATA_G[link:sub(7)]
        if(data)then
            --if data[1]==engClass then return end
            GetMasteryInfo(self, data[1], 1);
            self:ClearLines();
            self:AddLine("精通："..GetClassName(data[1]))
            self:AddLine("本功能由有爱独家提供", 0, 0.82, 0);
            for i=2, #data do
                for j=1, #data[i] do
                    self:AddLine(" ");
                    self:AddLine(data[i][j].name, 1, 1, 1);
                    if data[i][j].require then
                        self:AddLine(data[i][j].require, 1,.125,.125);
                    end
                    self:AddLine(data[i][j].detail, 1, 0.82, 0, 1);
                    self:AddLine(data[i][j].calc, 1, 0.82, 0, 1);
                end
            end
            self:Show();
        end
    end
end
hooksecurefunc(ItemRefTooltip, "SetHyperlink", hookSetHyperlink);
hooksecurefunc(GameTooltip, "SetHyperlink", hookSetHyperlink);