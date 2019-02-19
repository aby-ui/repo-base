if UnitFactionGroup("player") ~= "Horde" then return end
local addonName, addonSpace = ...
local addon = LibStub('AceAddon-3.0'):NewAddon(addonSpace, addonName, 'AceEvent-3.0')

local L = LibStub('AceLocale-3.0'):GetLocale(addonName)

local VERSION = GetAddOnMetadata(addonName, 'Version')

local HBD = LibStub('HereBeDragons-2.0')
local Pins = LibStub('HereBeDragons-Pins-2.0')

local tolerance = 280.0 -- zone tolerance was 0.00004
local lastTotemRidden = nil
local totemID = "131154"
local DAZARALOR_MAP_ID = 1165
local ZANDALAR_MAP_ID = 1642


local sv_defaults = {
  global = {
    minimapIconSize = 16,
    mapIconSize = 16
  }
}

local db

local options_panel = {
  name    = ('%s v%s'):format(L[addonName], VERSION),
  handler = addon,
  type    = 'group',
  childGroups = 'tab',
  args = {
    options = {
      name  = L["Options"],
      type  = 'group',
      order = 1,
      get   = 'OptionsPanel_GetOpt',
      set   = 'OptionsPanel_SetOpt',
      args  = {
        mapIconSize = {
          name  = L["World Map Icon Size"],
          type  = 'range',
          order = 1,
          min = 8,
          max = 36,
          step = 2
        },
        minimapIconSize = {
          name  = L["Minimap Icon Size"],
          type  = 'range',
          order = 2,
          min = 8,
          max = 36,
          step = 2
        },
      },
    },
  }
}

local totemFrames = {}

local totems = {
  {
    src = {720.53886816837, -474.66773464868},
    dst = {550.63884473685, -469.24131223932},
    name = L["The Sliver (North)"],
  },
  {
    src = {546.65650100447, -462.87529898866},
    dst = {723.30459901225, -485.10974622506},
    name = L["East Zanchul"],
  },
  {
    src = {721.63234345894, -493.55711318145},
    dst = {954.19598324318, -376.00174569699},
    name = L["Top of Zanchul"],
  },
  {
    src = {951.65455072140, -371.49667725025},
    dst = {724.65793825267, -475.92887634470},
    name = L["East Zanchul"],
  },
  {
    src = {712.10310389847, -617.82488272875},
    dst = {725.38720138371, -484.92704179022},
    name = L["East Zanchul"],
  },
  {
    src = {178.93509410461, -535.68233801774},
    dst = {543.32457207749, -691.18043361290},
    name = L["The Sliver (South)"],
  },
  {
    src = {941.98422298673, -360.82015955297},
    dst = {899.98440411268, -633.98611371755},
    name = L["Terrace of the Chosen"],
  },
  {
    src = {898.84127115318, -637.03100116050},
    dst = {795.53637580108, -874.35768471274},
    name = L["Altar of Pa'ku"],
  },
  {
    src = {815.47795616929, -879.64000221575},
    dst = {805.52763299737, -1005.0242491392},
    name = L["The Great Seal Ledge"],
  },
  {
    src = {765.01167250704, -1031.4362841850},
    dst = {803.55206303392, -1077.6093758113},
    name = L["The Golden Throne"],
  },
  {
    src = {569.32220714260, -875.20038514340},
    dst = {79.717060590863, -1011.4788772402},
    name = L["Beastcaller Inn (Warbeast Kraal)"],
  },
  {
    src = {1052.5058464766, -974.30528652138},
    dst = {892.72381541971, -1870.9723366855},
    name = L["Grand Bazaar"],
  },
  {
    src = {889.52324444801, -1868.8492507359},
    dst = {1043.4031449910, -974.30192382582},
    name = L["Terrace of Crafters"],
  },
  {
    src = {1008.0663336623, -693.19723100576},
    dst = {1059.2794955070, -463.66675714671},
    name = L["West Zanchul"],
  },
  {
    src = {1063.8590733656, -471.81081012706},
    dst = {1012.3073670077, -696.59029738395},
    name = L["The Zocalo"],
  },
  {
    src = {1049.9428421787, -995.21250995894},
    dst = {806.38707974693, -1008.2619104593},
    name = L["The Great Seal Ledge"],
  },
  {
    src = {1060.8395180181, -1841.4782691433},
    dst = {890.19093878007, -1868.9358479390},
    name = L["Grand Bazaar"],
  },
}

function addon:OptionsPanel_GetOpt(info)
    return db.global[info[#info]]
end
function addon:OptionsPanel_SetOpt(info, value)
  db.global[info[#info]] = value
  for totemID,totem in ipairs(totems) do
    local minimapIconSize = db.global.minimapIconSize
    totem.totemSrcFrame:SetWidth(minimapIconSize)
    totem.totemSrcFrame:SetHeight(minimapIconSize)
    --if totem.totemDestFrame then
      totem.totemDestFrame:SetWidth(minimapIconSize)
      totem.totemDestFrame:SetHeight(minimapIconSize)
    --end
  end

  for _,f in pairs(totemFrames) do
    f:SetWidth(db.global.mapIconSize)
    f:SetHeight(db.global.mapIconSize)
  end
end


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

      --local xy, frame = totem.dst, totem.totemDestFrame
      --Pins:AddMinimapIconWorld(addonName.."dest", frame, ZANDALAR_MAP_ID, xy[1], xy[2], true, true)
      --addon:showTotemOnMap(totemID, "TaxiNode_Neutral", true, "OVERLAY", "dest")
  end)

  --GameTooltip:HookScript("OnUpdate",         function() Pins:RemoveAllWorldMapIcons(addonName.."dest") end)
  GameTooltip:HookScript("OnTooltipCleared", function()
    Pins:RemoveAllMinimapIcons(addonName.."dest")
    Pins:RemoveAllWorldMapIcons(addonName.."dest")
  end)

  for totemID,totem in ipairs(totems) do
    local x,y = totem.src[1], totem.src[2]
    -- convert them back so they are on the dazar'alor map only
    local ix,iy = HBD:GetZoneCoordinatesFromWorld(x, y, DAZARALOR_MAP_ID)

    addon:showTotemOnMap(totemID, "WarlockPortalAlliance", false, "OVERLAY", "src")

    local srcFrame = totemFrames["src"..totemID]
    srcFrame:SetScript("OnEnter", addon.mapIconOnEnter)
    srcFrame:SetScript("OnLeave", addon.mapIconOnLeave)
    srcFrame.totemID = totemID

    local minimapIconFrame = CreateFrame("frame", nil,nil)
    minimapIconFrame:SetWidth(db.global.minimapIconSize)
    minimapIconFrame:SetHeight(db.global.minimapIconSize)
    minimapIconFrame.icon = minimapIconFrame:CreateTexture(nil,"BACKGROUND")
    minimapIconFrame.icon:SetAtlas("WarlockPortalAlliance")
    minimapIconFrame.icon:SetAllPoints()
    minimapIconFrame:SetScript("OnEnter", addon.mapIconOnEnter)
    minimapIconFrame:SetScript("OnLeave", addon.mapIconOnLeave)
    minimapIconFrame.totemID = totemID
    totems[totemID].totemSrcFrame = minimapIconFrame

    local minimapDestIconFrame = CreateFrame("frame", nil,nil)
    minimapDestIconFrame:SetWidth(db.global.minimapIconSize)
    minimapDestIconFrame:SetHeight(db.global.minimapIconSize)
    minimapDestIconFrame.icon = minimapDestIconFrame:CreateTexture(nil,"OVERLAY")
    minimapDestIconFrame.icon:SetAtlas("WarlockPortalHorde")
    minimapDestIconFrame.icon:SetAllPoints()
    totems[totemID].totemDestFrame = minimapDestIconFrame

    Pins:AddMinimapIconWorld(addonName, minimapIconFrame, ZANDALAR_MAP_ID, x,y, false)
  end

  self:UnregisterEvent("PLAYER_ENTERING_WORLD")
  self.PLAYER_ENTERING_WORLD = nil
end

function addon:showTotemOnMap(totemID, atlasIcon, dst, layer, ref)
  local layer = layer or "BACKGROUND"
  local ref = ref or ""
  local totem = totems[totemID]
  local x,y,ix,iy
  if not dst then
    x,y = totem.src[1], totem.src[2]
  else
    x,y = totem.dst[1], totem.dst[2]
  end
  local ix, iy = HBD:GetZoneCoordinatesFromWorld(x, y, DAZARALOR_MAP_ID)

  if not totemFrames[ref..totemID] then
    local mapIconFrame = CreateFrame("frame", nil,nil)
    mapIconFrame:SetWidth(db.global.mapIconSize)
    mapIconFrame:SetHeight(db.global.mapIconSize)
    mapIconFrame.icon = mapIconFrame:CreateTexture(nil,layer)
    mapIconFrame.icon:SetAtlas(atlasIcon)
    mapIconFrame.icon:SetAllPoints()
    totemFrames[ref..totemID] = mapIconFrame
  end

  Pins:AddWorldMapIconMap(addonName..ref, totemFrames[ref..totemID], DAZARALOR_MAP_ID, ix,iy, nil)
end

function addon:mapIconOnEnter()
  local totem = totems[self.totemID]
  local xy, frame = totem.dst, totem.totemDestFrame
  Pins:AddMinimapIconWorld(addonName.."dest", frame, ZANDALAR_MAP_ID, xy[1],xy[2], true, true)
  addon:showTotemOnMap(self.totemID, "WarlockPortalHorde", true, "OVERLAY", "dest")

  if not self.highlightLine then
    self.highlightLine = CreateFrame("FRAME", nil, WorldMapFrame:GetCanvas())
    self.highlightLine.Fill = self.highlightLine:CreateLine(WorldMapFrame, "OVERLAY")
    self.highlightLine.Fill:SetAtlas('_UI-Taxi-Line-horizontal')
  end

  local startPin = totemFrames["src"..self.totemID]
  local destinationPin = totemFrames["dest"..self.totemID]

  local lineContainer = self.highlightLine
  if WorldMapFrame.ScrollContainer.zoomLevels then
    lineContainer.Fill:SetThickness(Lerp(1, 2, Saturate(1 - WorldMapFrame:GetCanvasZoomPercent())) * 90)
  end
  
  lineContainer.Fill:SetStartPoint("CENTER", startPin)
  lineContainer.Fill:SetEndPoint("CENTER", destinationPin)

  lineContainer:Show()
end

function addon:mapIconOnLeave()
  Pins:RemoveAllMinimapIcons(addonName.."dest")
  Pins:RemoveAllWorldMapIcons(addonName.."dest")

  if self.highlightLine then
    self.highlightLine:Hide()
  end
end


function addon:OnInitialize()
  db = LibStub("AceDB-3.0"):New("Paku_Totems_DB", sv_defaults, true)
  if IsLoggedIn() then self:PLAYER_ENTERING_WORLD() else self:RegisterEvent("PLAYER_ENTERING_WORLD") end
  
  LibStub('AceConfig-3.0'):RegisterOptionsTable(addonName, options_panel)
  local optionsFrame = LibStub('AceConfigDialog-3.0'):AddToBlizOptions(addonName)
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
          --print(string.format("Found new totem at {%f,%f} in %s - please report this to the Pa'ku Totems developer.", totem.src[1], totem.src[2], totem.uiMapID))
          lastTotemRidden = #totems
        else
          lastTotemRidden = totemID
        end
    elseif event == "UNIT_EXITED_VEHICLE" and unitTarget == "player" then
        local totemID = lastTotemRidden
        if totemID and not totems[totemID].dst then
            local totem = totems[totemID]
            --print(string.format("Found new totem destination at {%f,%f} in %s - please report this to the Pa'ku Totems developer.", px,py, C_Map.GetBestMapForUnit("player")))
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
    local px, py = HBD:GetPlayerWorldPosition()

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







