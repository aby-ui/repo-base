local addon = select(2,...)
--noinspection UnusedDef
local lib = addon.TomCatsLibs.Charms
local cursorStartX, cursorStartY
local seqNum = 1;

function lib.Create(buttonInfo)
    local name = buttonInfo.name
    if (not name) then
        name = addon.name .. "MinimapButton" .. seqNum
        seqNum = seqNum + 1
    end
    --noinspection UnusedDef
    local frame = CreateFrame("Frame", name, Minimap, "TomCats-DarkshoreRaresMinimapButtonTemplate");

    if (buttonInfo.backgroundColor) then
        local background = _G[name .. "Background"];
        background:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMaskSmall")
        background:SetWidth(25)
        background:SetHeight(25)
        background:SetVertexColor(unpack(buttonInfo.backgroundColor))
    end
    if (buttonInfo.iconTexture) then
        _G[name .. "Icon"]:SetTexture(buttonInfo.iconTexture)
    end
    if (buttonInfo.name) then
        if (addon.savedVariables.character.preferences[name]) then
            frame:SetPreferences(addon.savedVariables.character.preferences[name])
        else
            addon.savedVariables.character.preferences[name] = frame:GetPreferences()
        end
    end
    if (buttonInfo.handler_onclick) then
        frame:SetHandler("OnClick",buttonInfo.handler_onclick)
    end
    return frame
end
