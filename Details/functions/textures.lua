
    local Details = _G.Details
    local detailsFramework = _G.DetailsFramework
	local openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0", true)
	local addonName, Details222 = ...

    --frame to create textures
    local frame33 = CreateFrame("frame")

    --store portrait textures for enemy actors
    local portraitPool = {
        inUse = {},
        available = {},
        npcIdToTexture = {},
    }

    local getTextureForPortraitPool = function()
        local texture = tremove(portraitPool.available, 1)
        if (not texture) then
            texture = frame33:CreateTexture(nil, "overlay")
        end
        table.insert(portraitPool.inUse, texture)
        return texture
    end

    local releaseTextureForPortraitPool = function(texture)
        pcall(function() table.remove(portraitPool.inUse, detailsFramework.table.find(portraitPool.inUse, texture)) end)
        table.insert(portraitPool.available, texture)
    end

    local savePortraitTextureForNpcId = function(texture, npcId)
        portraitPool.npcIdToTexture[npcId] = texture
    end

    --get a portrait texture and set all its attributes to mimic some other texture
    --@texture: the texture from GetPortraitTextureForNpcID()
    --@fromTexture: any other texture
    function Details222.Textures.FormatPortraitAsTexture(texture, fromTexture)
        texture:SetDrawLayer("overlay", 7)
        texture:SetParent(fromTexture:GetParent())
        texture:SetSize(fromTexture:GetSize())
        texture:ClearAllPoints()
        texture:Show()

        for i = 1, fromTexture:GetNumPoints() do
            local anchor1, anchorFrame, anchor2, x, y = fromTexture:GetPoint(i)
            texture:SetPoint(anchor1, anchorFrame, anchor2, x, y)
        end

        fromTexture:SetColorTexture(0.0156, 0.047, 0.1215, 1)
    end

    function Details222.Textures.SavePortraitTextureForUnitID(unitId)
        local npcId = detailsFramework:GetNpcIdFromGuid(UnitGUID(unitId) or "")
        if (npcId and not Details222.Textures.GetPortraitTextureForNpcID(npcId)) then
            local texture = getTextureForPortraitPool()
            SetPortraitTexture(texture, unitId)
            savePortraitTextureForNpcId(texture, npcId)
        end
    end

    --value
    function Details222.Textures.GetPortraitTextureForNpcID(npcId)
        return portraitPool.npcIdToTexture[npcId]
    end

    local eventListener = Details:CreateEventListener()

    eventListener:RegisterEvent("DETAILS_DATA_RESET", function()
        --> on reset data, release all textures:
            for i = 1, #portraitPool.inUse do
                local texture = portraitPool.inUse[i]
                releaseTextureForPortraitPool(texture)
            end
            table.wipe(portraitPool.npcIdToTexture)
    end)

    eventListener:RegisterEvent("COMBAT_ENCOUNTER_START", function()
        --> save a portrait texture for each boss in the boss list
        for i = 1, 9 do
            local unitId = "boss" .. i
            if (UnitExists(unitId)) then
                Details222.Textures.SavePortraitTextureForUnitID(unitId)
            end
        end
    end)

    eventListener:RegisterEvent("COMBAT_PLAYER_ENTER", function()
        if (UnitExists("target")) then
            Details222.Textures.SavePortraitTextureForUnitID("target")
        end
    end)

    eventListener:RegisterEvent("PLAYER_TARGET", function()
        if (Details.in_combat) then
            if (UnitExists("target")) then
                Details222.Textures.SavePortraitTextureForUnitID("target")
            end
            if (UnitExists("focus")) then
                Details222.Textures.SavePortraitTextureForUnitID("focus")
            end
        end
    end)




