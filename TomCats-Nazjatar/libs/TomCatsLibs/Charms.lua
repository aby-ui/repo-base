local addon = select(2,...)
--noinspection UnusedDef
local TCL = addon.TomCatsLibs
local cursorStartX, cursorStartY
local seqNum = 1;
local handleSlideBar, handleSexyMap

function TCL.Charms.Create(buttonInfo)
    --noinspection GlobalCreationOutsideO
    TOMCATS_LIBS_ICON_LASTFRAMELEVEL = (TOMCATS_LIBS_ICON_LASTFRAMELEVEL or 7) + 3
    if (MinimapZoneTextButton and MinimapZoneTextButton:GetParent() == MinimapCluster) then
        MinimapZoneTextButton:SetParent(Minimap)
    end
    local name = buttonInfo.name
    if (not name) then
        name = addon.name .. "MinimapButton" .. seqNum
        seqNum = seqNum + 1
    end
    --noinspection UnusedDef
    local frame = CreateFrame("Button", name, Minimap, "TomCats-NazjatarMinimapButtonTemplate");
    frame:SetFrameLevel(TOMCATS_LIBS_ICON_LASTFRAMELEVEL)
    if (buttonInfo.backgroundColor) then
        local background = _G[name .. "Background"];
        background:SetDrawLayer("BACKGROUND", 1)
        background:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMaskSmall")
        background:SetWidth(25)
        background:SetHeight(25)
        background:SetVertexColor(unpack(buttonInfo.backgroundColor))
        frame.backgroundColor = buttonInfo.backgroundColor
    end
    frame.title = buttonInfo.title or name
    if (buttonInfo.iconTexture) then
        _G[name .. "Icon"]:SetTexture(buttonInfo.iconTexture)
    end
    if (buttonInfo.name) then
        local scope = addon.savedVariables[TCL.Charms.scope or "character"].preferences
        if (scope[name]) then
            frame:SetPreferences(scope[name])
        else
            scope[name] = frame:GetPreferences()
        end
    end
    if (buttonInfo.handler_onclick) then
        frame:SetHandler("OnClick",buttonInfo.handler_onclick)
    end
    handleSlideBar(frame)
    handleSexyMap(frame)
    return frame
end

-- Begin SexyMap Compatibility --
local sexyMapPresent = select(4, GetAddOnInfo("SexyMap"))
local sexyMapQueue = {}

function handleSexyMap(button, event)
    if (not sexyMapPresent) then return end
    if (IsAddOnLoaded("SexyMap")) then
        if (event) then
            TCL.Events.UnregisterEvent("ADDON_LOADED", handleSexyMap)
        else
            table.insert(sexyMapQueue, button)
        end
        for _, btn in ipairs(sexyMapQueue) do
            local ldbiMock = CreateFromMixins(btn)
            setmetatable(ldbiMock, getmetatable(btn))
            function ldbiMock:GetName() return "LibDBIcon10_" .. btn.title end
            function ldbiMock:SetScript() end
            function ldbiMock:SetPoint() end
            function ldbiMock:SetAllPoints() end
            function ldbiMock:ClearAllPoints() end
            _G[ldbiMock:GetName()] = ldbiMock
            table.insert(LibStub["libs"]["LibDBIcon-1.0"].objects, ldbiMock)
            LibStub["libs"]["LibDBIcon-1.0"].callbacks:Fire("LibDBIcon_IconCreated", ldbiMock, btn.title)
        end
    end
    if (not event) then
        table.insert(sexyMapQueue, button)
        return
    end
end

if (sexyMapPresent and (not IsAddOnLoaded("SexyMap"))) then
    TCL.Events.RegisterEvent("ADDON_LOADED", handleSexyMap)
end
-- End SexyMap Compatibility --

-- Begin SlideBar Compatibility --
local slideBarPresent = select(4, GetAddOnInfo("SlideBar"))
local slideBarQueue = {}

function handleSlideBar(button, event)
    if (not slideBarPresent) then return end
    if (LibStub and LibStub.libs and LibStub.libs.SlideBar) then
        if (event) then
            TCL.Events.UnregisterEvent("ADDON_LOADED", handleSlideBar)
        else
            table.insert(slideBarQueue, button)
        end
        for _, btn in ipairs(slideBarQueue) do
            local n = btn:GetName()
            local newButton = LibStub.libs.SlideBar.AddButton(
                btn.title, _G[n .. "Icon"]:GetTexture(), nil, n .. "SlideBar", true, { OnClick = _G[btn:GetName()]:GetScript("OnClick") }
            )
            local oldOnEnter = newButton:GetScript("OnEnter")
            newButton:SetScript("OnEnter", function(this)
                if (oldOnEnter) then oldOnEnter(this) end
                if (btn.tooltip) then btn.tooltip.Show(this) end
            end)
            local oldOnLeave = newButton:GetScript("OnLeave")
            newButton:SetScript("OnLeave", function(this)
                if (oldOnLeave) then oldOnLeave(this) end
                if (btn.tooltip) then btn.tooltip.Hide(this) end
            end)
            -- todo: force background color to work in the interface config panel
            if (btn.backgroundColor) then
                newButton.icon:SetDrawLayer("ARTWORK",1)
                local bg = _G[btn:GetName() .. "SlideBar"]:CreateTexture("", "BACKGROUND")
                bg:SetDrawLayer("BACKGROUND", 1)
                bg:SetTexture("Interface\\AddOns\\"  .. addon.name .. "\\libs\\TomCatsLibs\\images\\square-button-mask")
                bg:SetPoint("TOPLEFT", newButton, "TOPLEFT", 0,0)
                bg:SetWidth(30)
                bg:SetHeight(30)
                bg:SetVertexColor(unpack(btn.backgroundColor))
            end
        end
        slideBarQueue = {}
        return
    end
    if (not event) then
        table.insert(slideBarQueue, button)
    end
end

if (slideBarPresent and (not (LibStub and LibStub.libs and LibStub.libs.SlideBar))) then
    TCL.Events.RegisterEvent("ADDON_LOADED", handleSlideBar)
end
-- End SlideBar Compatibility --
