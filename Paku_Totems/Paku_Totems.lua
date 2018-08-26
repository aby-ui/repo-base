if UnitFactionGroup("player") ~= "Horde" then return end
local addonName, addonSpace = ...
local addon = LibStub('AceAddon-3.0'):NewAddon(addonSpace, addonName, 'AceEvent-3.0')

--local L = LibStub('AceLocale-3.0'):GetLocale(addonName)

local VERSION = GetAddOnMetadata(addonName, 'Version')

local HBD = LibStub('HereBeDragons-2.0')
local Pins = LibStub('HereBeDragons-Pins-2.0')

local tolerance = 0.00004
local lastTotemRidden = nil
local totemID = "131154"

local totemFrames = {}

local totems = {
  {
    dst = {0.589707016944885,0.110139846801758},
    src = {0.529342889785767,0.113030731678009},
    name = "碎枝林地北部",
    dstMapID = 1165,
    srcMapID = 1165,
  }, -- [1]
  {
    dst = {0.528360247612,0.118593633174896},
    src = {0.591121912002564,0.106748402118683},
    name = "赞枢尔东部",
    dstMapID = 1165,
    srcMapID = 1165,
  }, -- [2]
  {
    dst = {0.446326375007629,0.0604671835899353},
    src = {0.528954386711121,0.123093903064728},
    name = "赞枢尔顶层",
    dstMapID = 1165,
    srcMapID = 1165,
  }, -- [3]
  {
    dst = {0.527879416942596,0.113702595233917},
    src = {0.447229325771332,0.0580671429634094},
    name = "赞枢尔东部",
    dstMapID = 1165,
    srcMapID = 1165,
  }, -- [4]
  {
    dst = {0.527620315551758,0.118496298789978},
    src = {0.532340049743652,0.18929660320282},
    name = "赞枢尔东部",
    dstMapID = 1165,
    srcMapID = 1165,
  }, -- [5]
  {
    dst = {0.592305719852448,0.22837620973587},
    src = {0.653485417366028,0.339411973953247},
    name = "碎枝林地南部",
    dstMapID = 1165,
    srcMapID = 862,
  }, -- [6]
  {
    dst = {0.465587317943573,0.197906374931335},
    src = {0.45066511631012,0.052379310131073},
    name = "选民之台",
    dstMapID = 1165,
    srcMapID = 1165,
  }, -- [7]
  {
    dst = {0.502696871757507,0.325962483882904},
    src = {0.465993463993073,0.199528515338898},
    name = "帕库神坛",
    dstMapID = 1165,
    srcMapID = 1165,
  }, -- [8]
  {
    dst = {0.499147057533264,0.39557409286499},
    src = {0.495611786842346,0.328776597976685},
    name = "巨擘封印平台",
    dstMapID = 1165,
    srcMapID = 1165,
  }, -- [9]
  {
    dst = {0.499848961830139,0.434243261814117},
    src = {0.513542056083679,0.409644901752472},
    name = "黄金王座",
    dstMapID = 1165,
    srcMapID = 1165,
  }, -- [10]
  {
    dst = {0.665206968784332,0.423748135566711},
    src = {0.58306896686554,0.326411426067352},
    name = "驭兽师旅店",
    dstMapID = 862,
    srcMapID = 1165,
  }, -- [11]
  {
    dst = {0.468166947364807,0.856901288032532},
    src = {0.55028235912323,0.417159020900726},
    name = "百商集市",
    dstMapID = 1165,
    srcMapID = 862,
  }, -- [12]
  {
    dst = {0.551357746124268,0.417158424854279},
    src = {0.469304084777832,0.855770230293274},
    name = "工匠平台",
    dstMapID = 862,
    srcMapID = 1165,
  }, -- [13]
  {
    dst = {0.408991038799286,0.107170045375824},
    src = {0.427186667919159,0.229450643062592},
    name = "赞枢尔西部",
    dstMapID = 1165,
    srcMapID = 1165,
  }, -- [14]
  {
    dst = {0.425679862499237,0.231258273124695},
    src = {0.407363951206207,0.111508727073669},
    name = "佐卡罗广场",
    dstMapID = 1165,
    srcMapID = 1165,
  }, -- [15]
  {
    dst = {0.49884170293808,0.3972989320755},
    src = {0.550585150718669,0.42086488008499},
    name = "巨擘封印平台",
    dstMapID = 1165,
    srcMapID = 862,
  }, -- [16]
  {
    dst = {0.46906685829163,0.85581636428833},
    src = {0.40843677520752,0.84118854999542},
    name = "百商集市",
    dstMapID = 1165,
    srcMapID = 1165,
  }, -- [17]
}


function addon:PLAYER_ENTERING_WORLD(event, ...)
  --self:RegisterEvent("UNIT_ENTERING_VEHICLE", self.vehicletrigger, ...)
  --self:RegisterEvent("UNIT_EXITED_VEHICLE", self.vehicletrigger, ...)

  GameTooltip:HookScript("OnTooltipSetUnit", function(tt,...)
      local guid = UnitGUID("mouseover")
      if not guid then return end

      local _, _, _, _, _, id, _ = strsplit("-", guid)
      if not id or id ~= totemID then
          return
      end

      local totemID = addon.GetClosestTotem()
      if not totemID or not totems[totemID] then
          return
      end
      local totem = totems[totemID]
      tt:AddLine(" ", 1,1,1,1);
      tt:AddLine(" ", 1,1,1,1);
      tt:AddLine("前往 " .. totem.name, 1,1,1,1);
      tt:Show()

      --local xy, mapid, frame = totem.dst, totem.dstMapID, totem.totemDestFrame
      --Pins:AddMinimapIconMap(addonName.."dest", frame, mapid, xy[1],xy[2], true, true)
      --addon:showTotemOnMap(totemID, "WarlockPortalHorde", true, "dest")
  end)

  --GameTooltip:HookScript("OnUpdate",         function() Pins:RemoveAllWorldMapIcons(addonName.."dest") end)
  GameTooltip:HookScript("OnTooltipCleared", function()
    Pins:RemoveAllMinimapIcons(addonName.."dest")
    Pins:RemoveAllWorldMapIcons(addonName.."dest")
  end)

  for totemID,totem in ipairs(totems) do
    local x,y,instance = HBD:GetWorldCoordinatesFromZone(totem.src[1], totem.src[2], totem.srcMapID)
    -- convert them back so they are on the dazar'alor map only - i actually should convert my data to this perhaps
    local ix,iy = HBD:GetZoneCoordinatesFromWorld(x, y, 1165)

    addon:showTotemOnMap(totemID, "WarlockPortalAlliance")
    totemFrames[""..totemID]:SetScript("OnEnter", addon.mapIconOnEnter)
    totemFrames[""..totemID]:SetScript("OnLeave", addon.mapIconOnLeave)
    totemFrames[""..totemID].totemID = totemID

    local minimapIconFrame = CreateFrame("frame", nil,nil)
    minimapIconFrame:SetWidth(16)
    minimapIconFrame:SetHeight(16)
    minimapIconFrame.icon = minimapIconFrame:CreateTexture(nil,"BACKGROUND")
    minimapIconFrame.icon:SetAtlas("WarlockPortalAlliance")
    minimapIconFrame.icon:SetAllPoints()
    minimapIconFrame:SetScript("OnEnter", addon.mapIconOnEnter)
    minimapIconFrame:SetScript("OnLeave", addon.mapIconOnLeave)
    minimapIconFrame.totemID = totemID

    local minimapDestIconFrame = CreateFrame("frame", nil,nil)
    minimapDestIconFrame:SetWidth(16)
    minimapDestIconFrame:SetHeight(16)
    minimapDestIconFrame.icon = minimapDestIconFrame:CreateTexture(nil,"OVERLAY")
    minimapDestIconFrame.icon:SetAtlas("WarlockPortalHorde")
    minimapDestIconFrame.icon:SetAllPoints()
    totems[totemID].totemDestFrame = minimapDestIconFrame

    Pins:AddMinimapIconWorld(addonName, minimapIconFrame, instance, x,y, false)
  end

  self:UnregisterEvent("PLAYER_ENTERING_WORLD")
  self.PLAYER_ENTERING_WORLD = nil
end

function addon:showTotemOnMap(totemID, atlasIcon, dst, layer, ref)
  local layer = layer or "BACKGROUND"
  local ref = ref or ""
  local totem = totems[totemID]
  local x,y,instance
  if not dst then
    x,y,instance = HBD:GetWorldCoordinatesFromZone(totem.src[1], totem.src[2], totem.srcMapID)
  else
    x,y,instance = HBD:GetWorldCoordinatesFromZone(totem.dst[1], totem.dst[2], totem.dstMapID)
  end

  local ix,iy = HBD:GetZoneCoordinatesFromWorld(x, y, 1165)

  if not totemFrames[ref..totemID] then
    local mapIconFrame = CreateFrame("frame", nil,nil)
    mapIconFrame:SetWidth(16)
    mapIconFrame:SetHeight(16)
    mapIconFrame.icon = mapIconFrame:CreateTexture(nil,layer)
    mapIconFrame.icon:SetAtlas(atlasIcon)
    mapIconFrame.icon:SetAllPoints()
    totemFrames[ref..totemID] = mapIconFrame
  end

  Pins:AddWorldMapIconMap(addonName..ref, totemFrames[ref..totemID], 1165, ix,iy, nil)
end


function addon:mapIconOnEnter()
  local totem = totems[self.totemID]
  local xy, mapid, frame = totem.dst, totem.dstMapID, totem.totemDestFrame
  -- print(totem.name, unpack(totem.dst))
  Pins:AddMinimapIconMap(addonName.."dest", frame, mapid, xy[1],xy[2], true, true)
  addon:showTotemOnMap(self.totemID, "WarlockPortalHorde", true, "OVERLAY", "dest")
end

function addon:mapIconOnLeave()
  Pins:RemoveAllMinimapIcons(addonName.."dest")
  Pins:RemoveAllWorldMapIcons(addonName.."dest")
end


function addon:OnInitialize()
  if IsLoggedIn() then self:PLAYER_ENTERING_WORLD() else self:RegisterEvent("PLAYER_ENTERING_WORLD") end
end

function addon:vehicletrigger(event,...)
    local unitTarget,_,_,_,vehicleGUID = ...
    local bestmap = C_Map.GetBestMapForUnit("player")
    if not bestmap then
      lastTotemRidden = nil
      return
    end
    local mappos = C_Map.GetPlayerMapPosition(bestmap, "player")
    if not mappos then
      lastTotemRidden = nil
      return
    end
    local px,py = mappos:GetXY()

    if event == "UNIT_ENTERING_VEHICLE" and unitTarget == "player" and vehicleGUID then
        local _, _, _, _, _, id, _ = strsplit("-", vehicleGUID)
        if id ~= totemID then
          return
        end
        local totemID, distance = addon.GetClosestTotem()

        if not distance or distance > tolerance then
          local totem = {name="new",src={px,py},uiMapID=bestmap}
          totems[#totems+1] = totem
          print(string.format("Found new totem at %f,%f in %s - please report this to the Pa'ku Totems developer.", totem.src[1], totem.src[2], totem.uiMapID))
          lastTotemRidden = #totems
        else
          lastTotemRidden = totemID
        end
    elseif event == "UNIT_EXITED_VEHICLE" and unitTarget == "player" then
        local totemID = lastTotemRidden
        if totemID and not totems[totemID].dst then
            local totem = totems[totemID]
            --print(string.format("Found new totem destination at {%f,%f} in MapID %s - please report this to the Pa'ku Totems developer.", px,py, C_Map.GetBestMapForUnit("player")))
            totems[totemID].dst = {px,py}
            totems[totemID].dstMapID = C_Map.GetBestMapForUnit("player")
        end
    else
        lastTotemRidden = nil
    end
end

function addon.distsq(x1,y1, x2,y2)
    local dx, dy = x2-x1, y2-y1
    local ds = (dx*dx + dy*dy)
    return ds
end

function addon:GetClosestTotem()
    local bestmap = C_Map.GetBestMapForUnit("player")
    
    local px, py = C_Map.GetPlayerMapPosition(bestmap, "player"):GetXY()
    
    local closest, min_ds
    for key,totem in ipairs(totems) do
        local ds = addon.distsq(totem.src[1],totem.src[2],px,py)
        if not min_ds or ds<min_ds then
            min_ds=ds
            closest=key
        end
    end
    if not closest or min_ds > tolerance then
        return nil,nil
    else
        return closest,min_ds
    end
end







