local MDT = MDT
local L = MDT.L
local dungeonIndex = 16
MDT.dungeonList[dungeonIndex] = L["Freehold"]
MDT.mapInfo[dungeonIndex] = {
  viewportPositionOverrides =
  {
    [1] = {
      zoomScale = 1.5999999046326;
      horizontalPan = 159.53385728911;
      verticalPan = 112.92774143478;
    };
  };
};

MDT.scaleMultiplier[dungeonIndex] = 0.6

MDT.dungeonMaps[dungeonIndex] = {
  [0] = "KulTirasPirateTownDungeon",
  [1] = "KulTirasPirateTownDungeon",
}
MDT.dungeonSubLevels[dungeonIndex] = {
  [1] = L["Freehold Sublevel"],
}

MDT.dungeonTotalCount[dungeonIndex] = { normal = 261, teeming = 313, teemingEnabled = true }

local selectorGroup
local AceGUI = LibStub("AceGUI-3.0")
local db
local function fixFreeholdShowHide(widget, frame, isFrame)
  frame = frame or MDT.main_frame
  local originalShow, originalHide = frame.Show, frame.Hide
  if not isFrame then
    widget = widget.frame
  end
  function frame:Show(...)
    if db.currentDungeonIdx == 16 then
      widget:Show()
    end
    return originalShow(self, ...);
  end

  function frame:Hide(...)
    widget:Hide()
    return originalHide(self, ...);
  end
end

function MDT:ToggleFreeholdSelector(show)
  db = MDT:GetDB()
  if not selectorGroup then
    selectorGroup = AceGUI:Create("SimpleGroup")
    selectorGroup.frame:SetFrameStrata("HIGH")
    selectorGroup.frame:SetFrameLevel(50)
    if not selectorGroup.frame.SetBackdrop then
      Mixin(selectorGroup.frame, BackdropTemplateMixin)
    end
    selectorGroup.frame:SetBackdropColor(unpack(MDT.BackdropColor))
    fixFreeholdShowHide(selectorGroup)
    selectorGroup:SetLayout("Flow")
    selectorGroup.frame.bg = selectorGroup.frame:CreateTexture(nil, "BACKGROUND")
    selectorGroup.frame.bg:SetAllPoints(selectorGroup.frame)
    selectorGroup.frame.bg:SetColorTexture(unpack(MDT.BackdropColor))
    selectorGroup:SetWidth(120)
    selectorGroup:SetHeight(90)
    selectorGroup.frame:SetPoint("TOPRIGHT", MDT.main_frame, "TOPRIGHT", 0, 0)

  end
  MDT:UpdateFreeholdSelector(MDT:GetCurrentPreset().week)
  if show then
    selectorGroup.frame:Show()
    MDT:DungeonEnemies_UpdateFreeholdCrew(MDT:GetCurrentPreset().freeholdCrew)
    MDT:ReloadPullButtons()
    MDT:UpdateProgressbar()
  else
    selectorGroup.frame:Hide()
    MDT:DungeonEnemies_UpdateFreeholdCrew()
  end
end

function MDT:UpdateFreeholdSelector(week)
  if not selectorGroup then return end
  week = week % 3
  if week == 0 then week = 3 end
  selectorGroup:ReleaseChildren()
  MDT:GetCurrentPreset().freeholdCrew = (MDT:GetCurrentPreset().freeholdCrew and week) or nil
  local label = AceGUI:Create("Label")
  label:SetText(L["  Join Crew:"])
  selectorGroup:AddChild(label)
  local check = AceGUI:Create("CheckBox")
  check:SetLabel((week == 2 and L["Blacktooth"]) or (week == 1 and L["Cutwater"]) or (week == 3 and L["Bilge Rats"]))
  selectorGroup:AddChild(check)
  check:SetCallback("OnValueChanged", function(widget, callbackName, value)
    MDT:GetCurrentPreset().freeholdCrew = (value and week) or nil
    if MDT.liveSessionActive and MDT:GetCurrentPreset().uid == MDT.livePresetUID then
      MDT:LiveSession_SendFreeholdSelector(value, week)
    end
    MDT:DungeonEnemies_UpdateFreeholdCrew(MDT:GetCurrentPreset().freeholdCrew)
    MDT:ReloadPullButtons()
    MDT:UpdateProgressbar()
  end)
  check:SetValue(MDT:GetCurrentPreset().freeholdCrew)
  MDT:DungeonEnemies_UpdateFreeholdCrew(MDT:GetCurrentPreset().freeholdCrew)
end

MDT.mapPOIs[dungeonIndex] = {
  [1] = {
    [1] = {
      ["template"] = "DeathReleasePinTemplate";
      ["type"] = "graveyard";
      ["x"] = 591.8001100269;
      ["y"] = -200.49488376925;
      ["graveyardDescription"] = "";
    };
    [2] = {
      ["template"] = "DeathReleasePinTemplate";
      ["type"] = "graveyard";
      ["x"] = 372.07463735;
      ["y"] = -348.54647419431;
      ["graveyardDescription"] = "freeholdGraveyardDescription2";
    };
    [3] = {
      ["template"] = "DeathReleasePinTemplate";
      ["type"] = "graveyard";
      ["x"] = 576.72706599388;
      ["y"] = -343.53532845441;
      ["graveyardDescription"] = "freeholdGraveyardDescription1";
    };
    [4] = {
      ["template"] = "MapLinkPinTemplate";
      ["type"] = "generalNote";
      ["x"] = 292.04610954455;
      ["y"] = -360.14964210345;
      ["text"] = "freeholdBeguilingPatrolNote";
      ["season"] = 3;
      ["weeks"] = {
        [2] = true;
        [5] = true;
        [8] = true;
        [11] = true;
      };
    };
    [5] = {
      ["template"] = "VignettePinTemplate";
      ["type"] = "nyalothaSpire";
      ["x"] = 542.83067431935;
      ["y"] = -216.18611247057;
      ["scale"] = 0.7;
      ["index"] = 1;
      ["npcId"] = 161244;
      ["tooltipText"] = "Defiled Spire of Ny'alotha";
      ["weeks"] = {
        [1] = true;
        [2] = true;
        [5] = true;
        [6] = true;
        [9] = true;
        [10] = true;
      };
    };
    [6] = {
      ["template"] = "VignettePinTemplate";
      ["type"] = "nyalothaSpire";
      ["x"] = 426.32933852779;
      ["y"] = -399.99192050787;
      ["scale"] = 0.7;
      ["index"] = 2;
      ["npcId"] = 161243;
      ["tooltipText"] = "Entropic Spire of Ny'alotha";
      ["weeks"] = {
        [1] = true;
        [2] = true;
        [3] = true;
        [4] = true;
        [5] = true;
        [6] = true;
        [7] = true;
        [8] = true;
        [9] = true;
        [10] = true;
        [11] = true;
        [12] = true;
      };
    };
    [7] = {
      ["template"] = "VignettePinTemplate";
      ["type"] = "nyalothaSpire";
      ["x"] = 264.17738562146;
      ["y"] = -321.73972084523;
      ["scale"] = 0.7;
      ["index"] = 3;
      ["npcId"] = 161124;
      ["tooltipText"] = "Brutal Spire of Ny'alotha";
      ["weeks"] = {
        [1] = true;
        [2] = true;
        [5] = true;
        [6] = true;
        [9] = true;
        [10] = true;
      };
    };
    [8] = {
      ["template"] = "VignettePinTemplate";
      ["type"] = "nyalothaSpire";
      ["x"] = 362.86539259214;
      ["y"] = -192.18697377317;
      ["scale"] = 0.7;
      ["index"] = 4;
      ["npcId"] = 161241;
      ["tooltipText"] = "Cursed Spire of Ny'alotha";
      ["weeks"] = {
        [1] = true;
        [2] = true;
        [3] = true;
        [4] = true;
        [5] = true;
        [6] = true;
        [7] = true;
        [8] = true;
        [9] = true;
        [10] = true;
        [11] = true;
        [12] = true;
      };
    };
    [9] = {
      ["template"] = "VignettePinTemplate";
      ["type"] = "nyalothaSpire";
      ["x"] = 542.69650118108;
      ["y"] = -217.98968560487;
      ["scale"] = 0.7;
      ["index"] = 5;
      ["npcId"] = 161124;
      ["tooltipText"] = "Brutal Spire of Ny'alotha";
      ["weeks"] = {
        [3] = true;
        [4] = true;
        [7] = true;
        [8] = true;
        [11] = true;
        [12] = true;
      };
    };
    [10] = {
      ["template"] = "VignettePinTemplate";
      ["type"] = "nyalothaSpire";
      ["x"] = 263.92862992815;
      ["y"] = -322.99946041137;
      ["scale"] = 0.7;
      ["index"] = 6;
      ["npcId"] = 161244;
      ["tooltipText"] = "Defiled Spire of Ny'alotha";
      ["weeks"] = {
        [3] = true;
        [4] = true;
        [7] = true;
        [8] = true;
        [11] = true;
        [12] = true;
      };
    };
  };
};

MDT.dungeonEnemies[dungeonIndex] = {
  [1] = {
    ["name"] = "Irontide Enforcer";
    ["id"] = 129602;
    ["count"] = 6;
    ["health"] = 1229592;
    ["scale"] = 1.2;
    ["displayId"] = 81224;
    ["creatureType"] = "Humanoid";
    ["level"] = 121;
    ["reaping"] = 148894;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [209859] = {
      };
      [257426] = {
      };
      [274860] = {
      };
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 581.30424951742;
        ["y"] = -218.20907864623;
        ["g"] = 1;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [2] = {
        ["x"] = 604.18640290331;
        ["y"] = -280.82105834615;
        ["g"] = 5;
        ["sublevel"] = 1;
        ["infested"] = {
          [3] = true;
        };
      };
      [3] = {
        ["x"] = 620.16114925439;
        ["y"] = -294.14932601393;
        ["g"] = 7;
        ["sublevel"] = 1;
        ["infested"] = {
          [3] = true;
        };
      };
      [4] = {
        ["x"] = 601.33233622766;
        ["y"] = -317.90736630668;
        ["g"] = 8;
        ["sublevel"] = 1;
        ["infested"] = {
          [3] = true;
        };
      };
      [5] = {
        ["x"] = 607.18948489272;
        ["y"] = -319.33598213933;
        ["g"] = 8;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [6] = {
        ["x"] = 550.13625665189;
        ["y"] = -271.65450774438;
        ["g"] = 9;
        ["sublevel"] = 1;
        ["infested"] = {
          [3] = true;
        };
      };
      [7] = {
        ["x"] = 525.02858089389;
        ["y"] = -325.85163004308;
        ["g"] = 14;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [8] = {
        ["x"] = 555.78923168149;
        ["y"] = -316.99475126787;
        ["g"] = 16;
        ["sublevel"] = 1;
        ["infested"] = {
          [3] = true;
        };
      };
      [9] = {
        ["x"] = 553.4367362721;
        ["y"] = -357.11577737522;
        ["g"] = 20;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
        };
      };
      [10] = {
        ["x"] = 560.64984764785;
        ["y"] = -349.57479282356;
        ["g"] = 20;
        ["sublevel"] = 1;
      };
      [11] = {
        ["x"] = 539.61713085603;
        ["y"] = -313.55766795587;
        ["g"] = 21;
        ["sublevel"] = 1;
        ["patrol"] = {
          [1] = {
            ["x"] = 539.61713085603;
            ["y"] = -313.55766795587;
          };
          [2] = {
            ["x"] = 533.40090066634;
            ["y"] = -297.88199032609;
          };
          [3] = {
            ["x"] = 530.69818482811;
            ["y"] = -284.36846912865;
          };
          [4] = {
            ["x"] = 533.40090066634;
            ["y"] = -297.88199032609;
          };
          [5] = {
            ["x"] = 539.61713085603;
            ["y"] = -313.55766795587;
          };
          [6] = {
            ["x"] = 540.96845397891;
            ["y"] = -326.26039064007;
          };
          [7] = {
            ["x"] = 551.50902023078;
            ["y"] = -345.44954782509;
          };
          [8] = {
            ["x"] = 540.96845397891;
            ["y"] = -326.26039064007;
          };
        };
      };
      [12] = {
        ["x"] = 316.11979809251;
        ["y"] = -192.36645718052;
        ["g"] = 64;
        ["sublevel"] = 1;
      };
      [13] = {
        ["x"] = 312.48054510155;
        ["y"] = -187.57681227386;
        ["g"] = 64;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
    };
  };
  [2] = {
    ["name"] = "Irontide Mastiff";
    ["id"] = 128551;
    ["count"] = 4;
    ["health"] = 768495;
    ["scale"] = 1;
    ["displayId"] = 30221;
    ["creatureType"] = "Beast";
    ["level"] = 120;
    ["reaping"] = 148716;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Incapacitate"] = true;
      ["Silence"] = true;
      ["Polymorph"] = true;
      ["Root"] = true;
      ["Fear"] = true;
      ["Disorient"] = true;
      ["Sap"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [132951] = {
      };
      [209859] = {
      };
      [257476] = {
      };
      [257478] = {
      };
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 581.50181759256;
        ["y"] = -223.4300274816;
        ["g"] = 1;
        ["sublevel"] = 1;
      };
      [2] = {
        ["x"] = 576.66309865434;
        ["y"] = -220.52680442486;
        ["g"] = 1;
        ["sublevel"] = 1;
        ["infested"] = {
          [2] = true;
        };
      };
      [3] = {
        ["x"] = 600.07649778772;
        ["y"] = -261.55965681488;
        ["g"] = 4;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
          [2] = true;
        };
      };
      [4] = {
        ["x"] = 611.04660479748;
        ["y"] = -318.33597514723;
        ["g"] = 8;
        ["sublevel"] = 1;
      };
      [5] = {
        ["x"] = 597.47520657594;
        ["y"] = -314.62168973697;
        ["g"] = 8;
        ["sublevel"] = 1;
        ["infested"] = {
          [2] = true;
        };
      };
      [6] = {
        ["x"] = 557.20720744203;
        ["y"] = -353.6731653106;
        ["g"] = 20;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [7] = {
        ["x"] = 548.1908358106;
        ["y"] = -358.09938283234;
        ["g"] = 20;
        ["sublevel"] = 1;
      };
      [8] = {
        ["x"] = 562.45312197414;
        ["y"] = -344.65676553796;
        ["g"] = 20;
        ["sublevel"] = 1;
      };
      [9] = {
        ["x"] = 344.7599440744;
        ["y"] = -176.36155345305;
        ["g"] = 63;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
        };
      };
      [10] = {
        ["x"] = 319.81840615478;
        ["y"] = -196.75002336221;
        ["g"] = 64;
        ["sublevel"] = 1;
      };
      [11] = {
        ["x"] = 309.95540429154;
        ["y"] = -183.05139594603;
        ["g"] = 64;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
        };
      };
    };
  };
  [3] = {
    ["name"] = "Irontide Crackshot";
    ["id"] = 126918;
    ["count"] = 4;
    ["health"] = 691646;
    ["scale"] = 1;
    ["displayId"] = 81254;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["reaping"] = 148716;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Silence"] = true;
      ["Mind Control"] = true;
      ["Root"] = true;
      ["Fear"] = true;
      ["Sap"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [209859] = {
      };
      [258672] = {
      };
      [258673] = {
      };
      [268440] = {
      };
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 588.65484190154;
        ["y"] = -238.78070801174;
        ["g"] = 2;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [2] = {
        ["x"] = 599.36844553568;
        ["y"] = -254.02737939683;
        ["g"] = 4;
        ["sublevel"] = 1;
      };
      [3] = {
        ["x"] = 597.36603508842;
        ["y"] = -285.78709088423;
        ["g"] = 5;
        ["sublevel"] = 1;
        ["infested"] = {
          [2] = true;
        };
      };
      [4] = {
        ["x"] = 593.21552800938;
        ["y"] = -286.94485788147;
        ["g"] = 5;
        ["sublevel"] = 1;
      };
      [5] = {
        ["x"] = 619.2334876822;
        ["y"] = -279.83856882483;
        ["g"] = 7;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [6] = {
        ["x"] = 554.42436064203;
        ["y"] = -272.53054043255;
        ["g"] = 9;
        ["sublevel"] = 1;
      };
      [7] = {
        ["x"] = 550.8884626247;
        ["y"] = -266.07816174063;
        ["g"] = 9;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [8] = {
        ["x"] = 559.77976564586;
        ["y"] = -300.05438691243;
        ["g"] = 11;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [9] = {
        ["x"] = 556.79975140368;
        ["y"] = -303.71066445212;
        ["g"] = 11;
        ["sublevel"] = 1;
        ["infested"] = {
          [2] = true;
        };
      };
      [10] = {
        ["x"] = 526.73214471648;
        ["y"] = -274.65566223717;
        ["g"] = 12;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [11] = {
        ["x"] = 524.05884893471;
        ["y"] = -312.666079778;
        ["g"] = 13;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [12] = {
        ["x"] = 560.63458495939;
        ["y"] = -317.92258515668;
        ["g"] = 16;
        ["sublevel"] = 1;
      };
      [13] = {
        ["x"] = 579.23010552039;
        ["y"] = -285.51281918287;
        ["g"] = 18;
        ["sublevel"] = 1;
      };
      [14] = {
        ["x"] = 398.38251277098;
        ["y"] = -436.63910850897;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["patrol"] = {
          [1] = {
            ["x"] = 398.38251277098;
            ["y"] = -436.63910850897;
          };
          [2] = {
            ["x"] = 385.1521350923;
            ["y"] = -436.19210304506;
          };
          [3] = {
            ["x"] = 382.40211957228;
            ["y"] = -430.69211492035;
          };
          [4] = {
            ["x"] = 385.1521350923;
            ["y"] = -436.19210304506;
          };
          [5] = {
            ["x"] = 398.38251277098;
            ["y"] = -436.63910850897;
          };
          [6] = {
            ["x"] = 418.15214967123;
            ["y"] = -434.4421117003;
          };
        };
        ["infested"] = {
        };
      };
      [15] = {
        ["x"] = 427.07102168601;
        ["y"] = -408.93419098045;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["patrol"] = {
          [1] = {
            ["x"] = 427.07102168601;
            ["y"] = -408.93419098045;
          };
          [2] = {
            ["x"] = 417.64418470973;
            ["y"] = -408.86471208232;
          };
          [3] = {
            ["x"] = 407.80813013853;
            ["y"] = -418.20897096026;
          };
          [4] = {
            ["x"] = 417.64418470973;
            ["y"] = -408.86471208232;
          };
          [5] = {
            ["x"] = 427.07102168601;
            ["y"] = -408.93419098045;
          };
          [6] = {
            ["x"] = 433.54582268221;
            ["y"] = -406.07781822831;
          };
        };
        ["infested"] = {
          [2] = true;
        };
      };
    };
  };
  [4] = {
    ["name"] = "Irontide Corsair";
    ["id"] = 126928;
    ["count"] = 4;
    ["health"] = 768495;
    ["scale"] = 1;
    ["displayId"] = 81253;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["reaping"] = 148716;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Silence"] = true;
      ["Root"] = true;
      ["Fear"] = true;
      ["Sap"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [209859] = {
      };
      [257436] = {
      };
      [257437] = {
      };
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 585.54966037025;
        ["y"] = -242.68192202712;
        ["g"] = 2;
        ["sublevel"] = 1;
        ["infested"] = {
          [2] = true;
        };
      };
      [2] = {
        ["x"] = 562.73267958816;
        ["y"] = -253.13665336806;
        ["g"] = 3;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
        };
      };
      [3] = {
        ["x"] = 559.61847130863;
        ["y"] = -250.02736876485;
        ["g"] = 3;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [4] = {
        ["x"] = 606.61847821718;
        ["y"] = -261.5273725097;
        ["g"] = 4;
        ["sublevel"] = 1;
      };
      [5] = {
        ["x"] = 602.5507214912;
        ["y"] = -257.9514065402;
        ["g"] = 4;
        ["sublevel"] = 1;
      };
      [6] = {
        ["x"] = 601.00210963562;
        ["y"] = -283.6849123803;
        ["g"] = 5;
        ["sublevel"] = 1;
      };
      [7] = {
        ["x"] = 622.58796835444;
        ["y"] = -290.13103848144;
        ["g"] = 7;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [8] = {
        ["x"] = 562.74913108477;
        ["y"] = -297.12838683341;
        ["g"] = 11;
        ["sublevel"] = 1;
      };
      [9] = {
        ["x"] = 565.9136750961;
        ["y"] = -294.59674619203;
        ["g"] = 11;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [10] = {
        ["x"] = 525.78848760998;
        ["y"] = -279.43331351388;
        ["g"] = 12;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [11] = {
        ["x"] = 525.33974317856;
        ["y"] = -283.01008776162;
        ["g"] = 12;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
        };
      };
      [12] = {
        ["x"] = 527.30621143788;
        ["y"] = -315.81871469401;
        ["g"] = 13;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
        };
      };
      [13] = {
        ["x"] = 610.39756181372;
        ["y"] = -302.65328824365;
        ["g"] = 17;
        ["sublevel"] = 1;
      };
      [14] = {
        ["x"] = 605.79892992417;
        ["y"] = -303.02134561571;
        ["g"] = 17;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
          [3] = true;
        };
      };
      [15] = {
        ["x"] = 579.35159776985;
        ["y"] = -289.80389024593;
        ["g"] = 18;
        ["sublevel"] = 1;
      };
      [16] = {
        ["x"] = 543.35132907592;
        ["y"] = -317.75932407748;
        ["g"] = 21;
        ["sublevel"] = 1;
        ["infested"] = {
          [2] = true;
        };
      };
      [17] = {
        ["x"] = 541.50922228882;
        ["y"] = -322.36458539847;
        ["g"] = 21;
        ["sublevel"] = 1;
      };
      [18] = {
        ["x"] = 547.35174798458;
        ["y"] = -292.75251983388;
        ["g"] = 22;
        ["sublevel"] = 1;
      };
      [19] = {
        ["x"] = 543.40850929022;
        ["y"] = -290.39756402535;
        ["g"] = 22;
        ["sublevel"] = 1;
        ["patrol"] = {
          [1] = {
            ["x"] = 543.40850929022;
            ["y"] = -290.39756402535;
          };
          [2] = {
            ["x"] = 542.6392848175;
            ["y"] = -278.66679590745;
          };
          [3] = {
            ["x"] = 543.21621555146;
            ["y"] = -267.89755425398;
          };
          [4] = {
            ["x"] = 548.21619938299;
            ["y"] = -258.6667863048;
          };
          [5] = {
            ["x"] = 556.10083688434;
            ["y"] = -264.24371737619;
          };
          [6] = {
            ["x"] = 560.90851047121;
            ["y"] = -268.08987275159;
          };
          [7] = {
            ["x"] = 560.90851047121;
            ["y"] = -280.01294286119;
          };
          [8] = {
            ["x"] = 559.17775128111;
            ["y"] = -288.08988235424;
          };
          [9] = {
            ["x"] = 555.13928566106;
            ["y"] = -295.39756436277;
          };
          [10] = {
            ["x"] = 548.21619938299;
            ["y"] = -294.24371114779;
          };
        };
        ["infested"] = {
          [2] = true;
        };
      };
      [20] = {
        ["x"] = 348.10205698293;
        ["y"] = -418.80017217098;
        ["g"] = 32;
        ["sublevel"] = 1;
        ["upstairs"] = true;
      };
      [21] = {
        ["x"] = 343.67582539059;
        ["y"] = -420.93132670847;
        ["g"] = 32;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["infested"] = {
          [1] = true;
        };
      };
      [22] = {
        ["x"] = 592.75895945239;
        ["y"] = -234.54238790785;
        ["g"] = 2;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
    };
  };
  [5] = {
    ["name"] = "Irontide Bonesaw";
    ["id"] = 129788;
    ["count"] = 4;
    ["health"] = 614795;
    ["scale"] = 1;
    ["displayId"] = 81255;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["reaping"] = 148893;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Silence"] = true;
      ["Polymorph"] = true;
      ["Root"] = true;
      ["Fear"] = true;
      ["Sap"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [209859] = {
      };
      [257397] = {
      };
      [258321] = {
      };
      [258323] = {
      };
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 566.86843961712;
        ["y"] = -250.77740026265;
        ["g"] = 3;
        ["sublevel"] = 1;
      };
      [2] = {
        ["x"] = 622.41722392579;
        ["y"] = -286.00298805084;
        ["g"] = 7;
        ["sublevel"] = 1;
      };
      [3] = {
        ["x"] = 558.36188436792;
        ["y"] = -273.04145606772;
        ["g"] = 9;
        ["sublevel"] = 1;
        ["infested"] = {
          [2] = true;
        };
      };
      [4] = {
        ["x"] = 521.66759939464;
        ["y"] = -308.27591848894;
        ["g"] = 13;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [5] = {
        ["x"] = 521.6144083869;
        ["y"] = -302.57211597578;
        ["g"] = 13;
        ["sublevel"] = 1;
      };
      [6] = {
        ["x"] = 557.02635238175;
        ["y"] = -326.78856080126;
        ["g"] = 16;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [7] = {
        ["x"] = 558.36654951403;
        ["y"] = -322.66484872977;
        ["g"] = 16;
        ["sublevel"] = 1;
      };
      [8] = {
        ["x"] = 608.20736915104;
        ["y"] = -298.3660424142;
        ["g"] = 17;
        ["sublevel"] = 1;
        ["patrol"] = {
          [1] = {
            ["x"] = 608.20736915104;
            ["y"] = -298.3660424142;
          };
          [2] = {
            ["x"] = 601.7618445952;
            ["y"] = -273.19018623014;
          };
          [3] = {
            ["x"] = 597.58272362668;
            ["y"] = -276.02599315234;
          };
          [4] = {
            ["x"] = 581.0155594982;
            ["y"] = -282.59316036975;
          };
          [5] = {
            ["x"] = 587.88124450661;
            ["y"] = -267.96631384322;
          };
          [6] = {
            ["x"] = 594.14989393302;
            ["y"] = -261.39912740999;
          };
          [7] = {
            ["x"] = 606.09019563549;
            ["y"] = -270.35436649738;
          };
          [8] = {
            ["x"] = 615.04542191234;
            ["y"] = -290.95137028042;
          };
          [9] = {
            ["x"] = 615.04542191234;
            ["y"] = -305.13048175474;
          };
          [10] = {
            ["x"] = 605.49317286404;
            ["y"] = -313.48867244959;
          };
        };
        ["infested"] = {
        };
      };
      [9] = {
        ["x"] = 579.4660130192;
        ["y"] = -294.46685997874;
        ["g"] = 18;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [10] = {
        ["x"] = 579.4660130192;
        ["y"] = -298.90792437747;
        ["g"] = 18;
        ["sublevel"] = 1;
      };
      [11] = {
        ["x"] = 538.08815876028;
        ["y"] = -319.07510818626;
        ["g"] = 21;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [12] = {
        ["x"] = 543.44931010424;
        ["y"] = -294.94763917898;
        ["g"] = 22;
        ["sublevel"] = 1;
      };
      [13] = {
        ["x"] = 593.04662607793;
        ["y"] = -317.1931213991;
        ["g"] = 8;
        ["sublevel"] = 1;
        ["teeming"] = true;
        ["infested"] = {
        };
      };
    };
  };
  [6] = {
    ["name"] = "Freehold Pack Mule";
    ["id"] = 129598;
    ["count"] = 0;
    ["health"] = 153699;
    ["scale"] = 0.6;
    ["neutral"] = true;
    ["displayId"] = 88571;
    ["creatureType"] = "Beast";
    ["level"] = 120;
    ["reaping"] = 148716;
    ["characteristics"] = {
      ["Root"] = true;
      ["Stun"] = true;
    };
    ["spells"] = {
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 618.1045892353;
        ["y"] = -284.19397073792;
        ["sublevel"] = 1;
      };
      [2] = {
        ["x"] = 626.77360877668;
        ["y"] = -291.09990053226;
        ["sublevel"] = 1;
      };
      [3] = {
        ["x"] = 618.69694197096;
        ["y"] = -288.82464537504;
        ["sublevel"] = 1;
      };
      [4] = {
        ["x"] = 545.52881544343;
        ["y"] = -278.00640151973;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
        };
      };
      [5] = {
        ["x"] = 547.42250343186;
        ["y"] = -275.53299975819;
        ["sublevel"] = 1;
      };
      [6] = {
        ["x"] = 560.84078206604;
        ["y"] = -327.09783433993;
        ["sublevel"] = 1;
      };
      [7] = {
        ["x"] = 561.97479978871;
        ["y"] = -322.25247663777;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
        };
      };
      [8] = {
        ["x"] = 367.7844356909;
        ["y"] = -396.17955458796;
        ["g"] = 66;
        ["sublevel"] = 1;
        ["upstairs"] = true;
      };
      [9] = {
        ["x"] = 370.5298191388;
        ["y"] = -396.41062741958;
        ["g"] = 69;
        ["sublevel"] = 1;
        ["upstairs"] = true;
      };
    };
  };
  [7] = {
    ["name"] = "Skycap'n Kragg";
    ["id"] = 126832;
    ["count"] = 0;
    ["health"] = 5379459;
    ["scale"] = 1;
    ["displayId"] = 80382;
    ["creatureType"] = "Humanoid";
    ["level"] = 122;
    ["isBoss"] = true;
    ["encounterID"] = 2095;
    ["instanceID"] = 1001;
    ["spells"] = {
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 575.37965681591;
        ["y"] = -330.73817112427;
        ["g"] = 19;
        ["sublevel"] = 1;
      };
    };
  };
  [8] = {
    ["name"] = "Cutwater Duelist";
    ["id"] = 129559;
    ["count"] = 4;
    ["health"] = 768495;
    ["scale"] = 1;
    ["displayId"] = 80339;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["reaping"] = 148716;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Incapacitate"] = true;
      ["Silence"] = true;
      ["Root"] = true;
      ["Fear"] = true;
      ["Sap"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [209859] = {
      };
      [274400] = {
      };
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 427.96338096744;
        ["y"] = -391.77930993249;
        ["g"] = 23;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [2] = {
        ["x"] = 441.44698636877;
        ["y"] = -400.5989497842;
        ["g"] = 25;
        ["sublevel"] = 1;
      };
      [3] = {
        ["x"] = 433.45493363816;
        ["y"] = -415.01802570409;
        ["g"] = 27;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
        };
      };
      [4] = {
        ["x"] = 415.86618894122;
        ["y"] = -426.31845966812;
        ["g"] = 28;
        ["sublevel"] = 1;
        ["infested"] = {
          [3] = true;
        };
      };
      [5] = {
        ["x"] = 401.4286623737;
        ["y"] = -426.85229781158;
        ["g"] = 29;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [6] = {
        ["x"] = 391.64222537453;
        ["y"] = -412.55852664629;
        ["g"] = 30;
        ["sublevel"] = 1;
        ["infested"] = {
          [2] = true;
        };
      };
      [7] = {
        ["x"] = 379.75050510268;
        ["y"] = -395.66604335926;
        ["g"] = 31;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["infested"] = {
          [1] = true;
          [2] = true;
        };
      };
      [8] = {
        ["x"] = 387.64223354956;
        ["y"] = -410.44087203575;
        ["g"] = 30;
        ["sublevel"] = 1;
        ["teeming"] = true;
      };
    };
  };
  [9] = {
    ["name"] = "Irontide Oarsman";
    ["id"] = 127111;
    ["count"] = 6;
    ["health"] = 1229592;
    ["scale"] = 1;
    ["displayId"] = 81279;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["reaping"] = 148893;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Silence"] = true;
      ["Root"] = true;
      ["Fear"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [132951] = {
      };
      [209859] = {
      };
      [258777] = {
      };
      [258779] = {
      };
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 423.95089136037;
        ["y"] = -389.52899410757;
        ["g"] = 23;
        ["sublevel"] = 1;
      };
      [2] = {
        ["x"] = 439.8408443899;
        ["y"] = -404.97670441317;
        ["g"] = 25;
        ["sublevel"] = 1;
        ["infested"] = {
          [3] = true;
        };
      };
      [3] = {
        ["x"] = 413.15189213078;
        ["y"] = -421.74702628331;
        ["g"] = 28;
        ["sublevel"] = 1;
        ["infested"] = {
          [3] = true;
        };
      };
      [4] = {
        ["x"] = 385.17164323575;
        ["y"] = -413.97028460597;
        ["g"] = 30;
        ["sublevel"] = 1;
        ["infested"] = {
          [3] = true;
        };
      };
      [5] = {
        ["x"] = 407.15541870807;
        ["y"] = -413.02468717144;
        ["g"] = 36;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["infested"] = {
          [3] = true;
        };
      };
      [6] = {
        ["x"] = 343.61269115135;
        ["y"] = -206.63347059747;
        ["g"] = 61;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [7] = {
        ["x"] = 348.24830300797;
        ["y"] = -179.15223860385;
        ["g"] = 63;
        ["sublevel"] = 1;
        ["infested"] = {
          [3] = true;
        };
      };
      [8] = {
        ["x"] = 389.17164515844;
        ["y"] = -416.32322631945;
        ["g"] = 30;
        ["sublevel"] = 1;
        ["teeming"] = true;
      };
    };
  };
  [10] = {
    ["name"] = "Blacktooth Brute";
    ["id"] = 129548;
    ["count"] = 4;
    ["health"] = 768495;
    ["scale"] = 1;
    ["displayId"] = 80389;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["reaping"] = 148716;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Incapacitate"] = true;
      ["Silence"] = true;
      ["Polymorph"] = true;
      ["Root"] = true;
      ["Fear"] = true;
      ["Disorient"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [209859] = {
      };
      [257747] = {
      };
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 423.8482270145;
        ["y"] = -393.51147578162;
        ["g"] = 23;
        ["sublevel"] = 1;
        ["infested"] = {
          [2] = true;
        };
      };
      [2] = {
        ["x"] = 432.72321672263;
        ["y"] = -419.77411761848;
        ["g"] = 27;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [3] = {
        ["x"] = 397.4751809314;
        ["y"] = -430.80576927357;
        ["g"] = 29;
        ["sublevel"] = 1;
        ["infested"] = {
          [2] = true;
        };
      };
      [4] = {
        ["x"] = 385.75988623742;
        ["y"] = -406.67617741146;
        ["g"] = 30;
        ["sublevel"] = 1;
      };
      [5] = {
        ["x"] = 350.71518826563;
        ["y"] = -441.95542540812;
        ["g"] = 33;
        ["sublevel"] = 1;
        ["upstairs"] = true;
      };
      [6] = {
        ["x"] = 308.12486124605;
        ["y"] = -392.93836700041;
        ["g"] = 39;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["infested"] = {
        };
      };
      [7] = {
        ["x"] = 333.83223376313;
        ["y"] = -408.22734060584;
        ["g"] = 40;
        ["sublevel"] = 1;
        ["upstairs"] = true;
      };
      [8] = {
        ["x"] = 333.48929221358;
        ["y"] = -400.65530192996;
        ["g"] = 40;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["infested"] = {
          [2] = true;
        };
      };
      [9] = {
        ["x"] = 372.0622278959;
        ["y"] = -374.99362441396;
        ["g"] = 42;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [10] = {
        ["x"] = 261.8112140627;
        ["y"] = -344.40986833828;
        ["g"] = 55;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [11] = {
        ["x"] = 417.17919468928;
        ["y"] = -399.01772664306;
        ["g"] = 72;
        ["sublevel"] = 1;
        ["blacktoothEvent"] = true;
      };
      [12] = {
        ["x"] = 420.39193175612;
        ["y"] = -405.66834286789;
        ["g"] = 72;
        ["sublevel"] = 1;
        ["blacktoothEvent"] = true;
      };
    };
  };
  [11] = {
    ["name"] = "Vermin Trapper";
    ["id"] = 130404;
    ["count"] = 4;
    ["health"] = 1229592;
    ["scale"] = 1;
    ["displayId"] = 87975;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["reaping"] = 148716;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Incapacitate"] = true;
      ["Silence"] = true;
      ["Root"] = true;
      ["Disorient"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [209859] = {
      };
      [274383] = {
      };
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 401.84512319017;
        ["y"] = -404.0924587256;
        ["g"] = 24;
        ["sublevel"] = 1;
        ["patrol"] = {
          [1] = {
            ["x"] = 420.86786753369;
            ["y"] = -402.35383442213;
          };
          [2] = {
            ["x"] = 408.6890842739;
            ["y"] = -403.30635849927;
          };
          [3] = {
            ["x"] = 402.86490775006;
            ["y"] = -405.2843780455;
          };
          [4] = {
            ["x"] = 398.33041148939;
            ["y"] = -416.21912332401;
          };
          [5] = {
            ["x"] = 406.9889465177;
            ["y"] = -422.19473819736;
          };
          [6] = {
            ["x"] = 418.2495073647;
            ["y"] = -421.32832694082;
          };
          [7] = {
            ["x"] = 424.73303316923;
            ["y"] = -413.19646566235;
          };
          [8] = {
            ["x"] = 429.89786041239;
            ["y"] = -404.40525510319;
          };
          [9] = {
            ["x"] = 431.21654954182;
            ["y"] = -397.48218197542;
          };
          [10] = {
            ["x"] = 425.83192977316;
            ["y"] = -397.26239888186;
          };
        };
        ["infested"] = {
          [2] = true;
        };
      };
      [2] = {
        ["x"] = 390.71212701568;
        ["y"] = -383.65549462703;
        ["g"] = 26;
        ["sublevel"] = 1;
        ["patrol"] = {
          [1] = {
            ["x"] = 390.71212701568;
            ["y"] = -383.65549462703;
          };
          [2] = {
            ["x"] = 383.22821899715;
            ["y"] = -367.89712183073;
          };
          [3] = {
            ["x"] = 390.71212701568;
            ["y"] = -383.65549462703;
          };
          [4] = {
            ["x"] = 396.15924674565;
            ["y"] = -399.1040015385;
          };
        };
        ["infested"] = {
          [3] = true;
        };
      };
    };
  };
  [12] = {
    ["name"] = "Soggy Shiprat";
    ["id"] = 130024;
    ["count"] = 1;
    ["health"] = 76850;
    ["scale"] = 0.6;
    ["displayId"] = 81400;
    ["creatureType"] = "Beast";
    ["level"] = 120;
    ["reaping"] = 148716;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Silence"] = true;
      ["Root"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [209859] = {
      };
      [257476] = {
      };
      [274555] = {
      };
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 405.74757153767;
        ["y"] = -403.97051113992;
        ["g"] = 24;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
        };
      };
      [2] = {
        ["x"] = 404.89390180289;
        ["y"] = -401.77538656124;
        ["g"] = 24;
        ["sublevel"] = 1;
      };
      [3] = {
        ["x"] = 402.82073527704;
        ["y"] = -400.31197366451;
        ["g"] = 24;
        ["sublevel"] = 1;
      };
      [4] = {
        ["x"] = 399.89390948357;
        ["y"] = -400.43391601661;
        ["g"] = 24;
        ["sublevel"] = 1;
      };
      [5] = {
        ["x"] = 387.21098898925;
        ["y"] = -384.94612254807;
        ["g"] = 26;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
        };
      };
      [6] = {
        ["x"] = 393.91830507738;
        ["y"] = -381.89733346819;
        ["g"] = 26;
        ["sublevel"] = 1;
      };
      [7] = {
        ["x"] = 387.57683174628;
        ["y"] = -381.40953265833;
        ["g"] = 26;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [8] = {
        ["x"] = 391.72317003155;
        ["y"] = -379.82416694234;
        ["g"] = 26;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
    };
  };
  [13] = {
    ["name"] = "Bilge Rat Padfoot";
    ["id"] = 129550;
    ["count"] = 4;
    ["health"] = 768495;
    ["scale"] = 1;
    ["displayId"] = 87973;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["reaping"] = 148716;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Silence"] = true;
      ["Root"] = true;
      ["Fear"] = true;
      ["Disorient"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [209859] = {
      };
      [257774] = {
      };
      [257775] = {
      };
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 436.03002212755;
        ["y"] = -403.53418131343;
        ["g"] = 25;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [2] = {
        ["x"] = 429.0646844808;
        ["y"] = -416.84729705859;
        ["g"] = 27;
        ["sublevel"] = 1;
        ["infested"] = {
          [2] = true;
        };
      };
      [3] = {
        ["x"] = 401.66124358869;
        ["y"] = -430.1081054711;
        ["g"] = 29;
        ["sublevel"] = 1;
      };
      [4] = {
        ["x"] = 390.70105676732;
        ["y"] = -406.67617741146;
        ["g"] = 30;
        ["sublevel"] = 1;
      };
      [5] = {
        ["x"] = 381.82600881022;
        ["y"] = -399.00560380624;
        ["g"] = 31;
        ["sublevel"] = 1;
        ["upstairs"] = true;
      };
      [6] = {
        ["x"] = 331.11793695269;
        ["y"] = -404.65592647466;
        ["g"] = 40;
        ["sublevel"] = 1;
        ["upstairs"] = true;
      };
      [7] = {
        ["x"] = 337.11795438225;
        ["y"] = -404.37020843956;
        ["g"] = 40;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["patrol"] = {
          [1] = {
            ["x"] = 337.11795438225;
            ["y"] = -404.37020843956;
          };
          [2] = {
            ["x"] = 348.49148529343;
            ["y"] = -403.91070866502;
          };
          [3] = {
            ["x"] = 353.64776293362;
            ["y"] = -399.22321401722;
          };
          [4] = {
            ["x"] = 348.49148529343;
            ["y"] = -403.91070866502;
          };
          [5] = {
            ["x"] = 337.11795438225;
            ["y"] = -404.37020843956;
          };
          [6] = {
            ["x"] = 327.71024337527;
            ["y"] = -398.44196714442;
          };
          [7] = {
            ["x"] = 315.67900934774;
            ["y"] = -397.66071356611;
          };
          [8] = {
            ["x"] = 327.71024337527;
            ["y"] = -398.44196714442;
          };
        };
        ["infested"] = {
        };
      };
    };
  };
  [14] = {
    ["name"] = "Blacktooth Scrapper";
    ["id"] = 129529;
    ["count"] = 4;
    ["health"] = 922194;
    ["scale"] = 1;
    ["displayId"] = 80380;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["reaping"] = 148716;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Incapacitate"] = true;
      ["Silence"] = true;
      ["Root"] = true;
      ["Fear"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [209859] = {
      };
      [257739] = {
      };
      [257741] = {
      };
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 363.29861878332;
        ["y"] = -441.25753441285;
        ["g"] = 34;
        ["sublevel"] = 1;
        ["upstairs"] = true;
      };
      [2] = {
        ["x"] = 357.21301553033;
        ["y"] = -395.75098366607;
        ["g"] = 38;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["infested"] = {
          [2] = true;
        };
      };
      [3] = {
        ["x"] = 318.20332812203;
        ["y"] = -371.54779768028;
        ["g"] = 45;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [4] = {
        ["x"] = 317.73905295297;
        ["y"] = -375.3940306223;
        ["g"] = 45;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
          [3] = true;
        };
      };
      [5] = {
        ["x"] = 299.52134444273;
        ["y"] = -378.15437752722;
        ["g"] = 46;
        ["sublevel"] = 1;
      };
      [6] = {
        ["x"] = 267.40221729937;
        ["y"] = -379.5452543256;
        ["g"] = 47;
        ["sublevel"] = 1;
      };
      [7] = {
        ["x"] = 334.47771009328;
        ["y"] = -350.92690700733;
        ["g"] = 49;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [8] = {
        ["x"] = 335.33486419859;
        ["y"] = -366.35547245704;
        ["g"] = 49;
        ["sublevel"] = 1;
      };
      [9] = {
        ["x"] = 285.86859470875;
        ["y"] = -355.48943052005;
        ["g"] = 53;
        ["sublevel"] = 1;
        ["patrol"] = {
          [1] = {
            ["x"] = 287.88987353557;
            ["y"] = -351.34048832854;
          };
          [2] = {
            ["x"] = 289.21075544493;
            ["y"] = -345.11706437257;
          };
          [3] = {
            ["x"] = 288.11699104756;
            ["y"] = -329.02332380774;
          };
          [4] = {
            ["x"] = 289.21075544493;
            ["y"] = -345.11706437257;
          };
          [5] = {
            ["x"] = 287.88987353557;
            ["y"] = -351.34048832854;
          };
          [6] = {
            ["x"] = 282.33489618274;
            ["y"] = -371.15093454023;
          };
          [7] = {
            ["x"] = 289.80497711643;
            ["y"] = -386.25009769854;
          };
          [8] = {
            ["x"] = 282.33489618274;
            ["y"] = -371.15093454023;
          };
        };
      };
      [10] = {
        ["x"] = 278.58694476597;
        ["y"] = -324.24994915898;
        ["g"] = 57;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["infested"] = {
          [2] = true;
        };
      };
      [11] = {
        ["x"] = 278.98600277822;
        ["y"] = -329.55858285652;
        ["g"] = 57;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["infested"] = {
        };
      };
      [12] = {
        ["x"] = 299.24865155987;
        ["y"] = -333.5535978722;
        ["g"] = 58;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["infested"] = {
          [2] = true;
        };
      };
      [13] = {
        ["x"] = 414.42737794132;
        ["y"] = -402.0981673499;
        ["g"] = 72;
        ["sublevel"] = 1;
        ["blacktoothEvent"] = true;
      };
      [14] = {
        ["x"] = 416.25346623816;
        ["y"] = -405.75034021182;
        ["g"] = 72;
        ["sublevel"] = 1;
        ["blacktoothEvent"] = true;
      };
    };
  };
  [15] = {
    ["name"] = "Irontide Buccaneer";
    ["id"] = 130011;
    ["count"] = 4;
    ["health"] = 768495;
    ["scale"] = 1;
    ["displayId"] = 79069;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["reaping"] = 148716;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Incapacitate"] = true;
      ["Silence"] = true;
      ["Polymorph"] = true;
      ["Root"] = true;
      ["Fear"] = true;
      ["Disorient"] = true;
      ["Sap"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [132951] = {
      };
      [209859] = {
      };
      [257870] = {
      };
      [257871] = {
      };
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 409.81157801481;
        ["y"] = -409.47715302758;
        ["g"] = 36;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["infested"] = {
        };
      };
      [2] = {
        ["x"] = 348.03577726071;
        ["y"] = -210.47962597286;
        ["g"] = 61;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
        };
      };
      [3] = {
        ["x"] = 329.66034869884;
        ["y"] = -189.54961353475;
        ["g"] = 62;
        ["sublevel"] = 1;
      };
      [4] = {
        ["x"] = 335.04496952557;
        ["y"] = -185.31883767005;
        ["g"] = 62;
        ["sublevel"] = 1;
        ["infested"] = {
          [2] = true;
        };
      };
      [5] = {
        ["x"] = 359.25607129825;
        ["y"] = -182.79566621356;
        ["g"] = 63;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [6] = {
        ["x"] = 353.20953856669;
        ["y"] = -179.07474602562;
        ["g"] = 63;
        ["sublevel"] = 1;
      };
    };
  };
  [16] = {
    ["name"] = "Bilge Rat Buccaneer";
    ["id"] = 129527;
    ["count"] = 4;
    ["health"] = 768495;
    ["scale"] = 1;
    ["displayId"] = 81424;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["reaping"] = 148716;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Incapacitate"] = true;
      ["Silence"] = true;
      ["Polymorph"] = true;
      ["Root"] = true;
      ["Fear"] = true;
      ["Disorient"] = true;
      ["Imprison"] = true;
      ["Sap"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [209859] = {
      };
      [257756] = {
      };
      [257757] = {
      };
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 352.64160053781;
        ["y"] = -395.3224250057;
        ["g"] = 38;
        ["sublevel"] = 1;
        ["upstairs"] = true;
      };
      [2] = {
        ["x"] = 356.12039857609;
        ["y"] = -391.88071102513;
        ["g"] = 38;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["infested"] = {
          [3] = true;
        };
      };
      [3] = {
        ["x"] = 387.06225796645;
        ["y"] = -359.49358953592;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [4] = {
        ["x"] = 322.67575030236;
        ["y"] = -370.58390090933;
        ["g"] = 45;
        ["sublevel"] = 1;
      };
      [5] = {
        ["x"] = 317.86562602171;
        ["y"] = -379.57124066837;
        ["g"] = 45;
        ["sublevel"] = 1;
      };
      [6] = {
        ["x"] = 273.88681465123;
        ["y"] = -378.28771461564;
        ["g"] = 47;
        ["sublevel"] = 1;
      };
      [7] = {
        ["x"] = 334.62059321691;
        ["y"] = -361.92691026962;
        ["g"] = 49;
        ["sublevel"] = 1;
        ["infested"] = {
          [2] = true;
        };
      };
      [8] = {
        ["x"] = 324.58673976491;
        ["y"] = -340.75871286759;
        ["g"] = 51;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
        };
      };
      [9] = {
        ["x"] = 303.32694337274;
        ["y"] = -351.03294785363;
        ["g"] = 56;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [10] = {
        ["x"] = 286.34836048441;
        ["y"] = -363.36131507245;
        ["g"] = 53;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
        };
      };
      [11] = {
        ["x"] = 273.51232807191;
        ["y"] = -323.50367069466;
        ["g"] = 57;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["infested"] = {
        };
      };
      [12] = {
        ["x"] = 328.21441256104;
        ["y"] = -332.25328423952;
        ["g"] = 51;
        ["sublevel"] = 1;
        ["teeming"] = true;
      };
    };
  };
  [17] = {
    ["name"] = "Bilge Rat Brinescale";
    ["id"] = 129600;
    ["count"] = 3;
    ["health"] = 491836;
    ["scale"] = 1;
    ["displayId"] = 80475;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["reaping"] = 148893;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Incapacitate"] = true;
      ["Silence"] = true;
      ["Polymorph"] = true;
      ["Root"] = true;
      ["Fear"] = true;
      ["Disorient"] = true;
      ["Imprison"] = true;
      ["Sap"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [209859] = {
      };
      [257784] = {
      };
      [277242] = {
      };
      [277564] = {
      };
      [281420] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 311.97508609272;
        ["y"] = -397.3702146717;
        ["g"] = 39;
        ["sublevel"] = 1;
        ["upstairs"] = true;
      };
      [2] = {
        ["x"] = 307.68937687378;
        ["y"] = -400.9416410644;
        ["g"] = 39;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["infested"] = {
        };
      };
      [3] = {
        ["x"] = 366.17780604811;
        ["y"] = -375.23498029718;
        ["g"] = 42;
        ["sublevel"] = 1;
        ["infested"] = {
          [2] = true;
        };
      };
      [4] = {
        ["x"] = 345.27318616201;
        ["y"] = -371.03385132999;
        ["g"] = 44;
        ["sublevel"] = 1;
      };
      [5] = {
        ["x"] = 342.13885482046;
        ["y"] = -374.91444837842;
        ["g"] = 44;
        ["sublevel"] = 1;
      };
      [6] = {
        ["x"] = 297.40598126923;
        ["y"] = -382.57745538363;
        ["g"] = 46;
        ["sublevel"] = 1;
      };
      [7] = {
        ["x"] = 294.41708673335;
        ["y"] = -374.06336406279;
        ["g"] = 46;
        ["sublevel"] = 1;
      };
      [8] = {
        ["x"] = 268.62008024026;
        ["y"] = -383.67991471428;
        ["g"] = 47;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [9] = {
        ["x"] = 288.67131673611;
        ["y"] = -358.37241690708;
        ["g"] = 53;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [10] = {
        ["x"] = 273.51232807191;
        ["y"] = -329.17532937599;
        ["g"] = 57;
        ["sublevel"] = 1;
        ["upstairs"] = true;
      };
      [11] = {
        ["x"] = 294.2486424358;
        ["y"] = -329.58807507283;
        ["g"] = 58;
        ["sublevel"] = 1;
        ["upstairs"] = true;
      };
      [12] = {
        ["x"] = 294.76587585058;
        ["y"] = -333.55360031194;
        ["g"] = 58;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["infested"] = {
          [1] = true;
        };
      };
    };
  };
  [18] = {
    ["name"] = "Blacktooth Knuckleduster";
    ["id"] = 129547;
    ["count"] = 4;
    ["health"] = 845345;
    ["scale"] = 1;
    ["displayId"] = 81207;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["reaping"] = 148716;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Incapacitate"] = true;
      ["Silence"] = true;
      ["Polymorph"] = true;
      ["Root"] = true;
      ["Fear"] = true;
      ["Sap"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [209859] = {
      };
      [257732] = {
      };
      [266950] = {
      };
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 304.54651527221;
        ["y"] = -396.94162535752;
        ["g"] = 39;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["infested"] = {
          [2] = true;
        };
      };
      [2] = {
        ["x"] = 340.79557911019;
        ["y"] = -380.43683254409;
        ["g"] = 44;
        ["sublevel"] = 1;
        ["patrol"] = {
          [1] = {
            ["x"] = 340.79557911019;
            ["y"] = -380.43683254409;
          };
          [2] = {
            ["x"] = 324.82543661657;
            ["y"] = -376.25773689924;
          };
          [3] = {
            ["x"] = 340.79557911019;
            ["y"] = -380.43683254409;
          };
          [4] = {
            ["x"] = 354.52691167262;
            ["y"] = -362.97415223144;
          };
        };
        ["infested"] = {
          [3] = true;
        };
      };
      [3] = {
        ["x"] = 292.62604404009;
        ["y"] = -378.54098360649;
        ["g"] = 46;
        ["sublevel"] = 1;
      };
      [4] = {
        ["x"] = 267.10371872419;
        ["y"] = -375.96316253381;
        ["g"] = 47;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [5] = {
        ["x"] = 320.63070067245;
        ["y"] = -337.13233898354;
        ["g"] = 51;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [6] = {
        ["x"] = 300.04123949134;
        ["y"] = -346.0329473885;
        ["g"] = 56;
        ["sublevel"] = 1;
      };
      [7] = {
        ["x"] = 308.61265345302;
        ["y"] = -350.46152404495;
        ["g"] = 56;
        ["sublevel"] = 1;
        ["infested"] = {
          [3] = true;
        };
      };
      [8] = {
        ["x"] = 285.17885388006;
        ["y"] = -359.19001555574;
        ["g"] = 53;
        ["sublevel"] = 1;
        ["infested"] = {
          [2] = true;
        };
      };
      [9] = {
        ["x"] = 421.80884675384;
        ["y"] = -398.86243447031;
        ["g"] = 72;
        ["sublevel"] = 1;
        ["blacktoothEvent"] = true;
      };
      [10] = {
        ["x"] = 325.28287529806;
        ["y"] = -332.57840453241;
        ["g"] = 51;
        ["sublevel"] = 1;
      };
    };
  };
  [19] = {
    ["name"] = "Cutwater Knife Juggler";
    ["id"] = 129599;
    ["count"] = 3;
    ["health"] = 691646;
    ["scale"] = 1;
    ["displayId"] = 80335;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["reaping"] = 148716;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Incapacitate"] = true;
      ["Silence"] = true;
      ["Polymorph"] = true;
      ["Root"] = true;
      ["Fear"] = true;
      ["Sap"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [205276] = {
      };
      [209859] = {
      };
      [272402] = {
      };
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 369.63235042592;
        ["y"] = -370.14405061668;
        ["g"] = 42;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [2] = {
        ["x"] = 348.70601609998;
        ["y"] = -374.76519267493;
        ["g"] = 44;
        ["sublevel"] = 1;
        ["infested"] = {
          [2] = true;
        };
      };
      [3] = {
        ["x"] = 345.12393045852;
        ["y"] = -378.49654042515;
        ["g"] = 44;
        ["sublevel"] = 1;
      };
      [4] = {
        ["x"] = 321.14477793541;
        ["y"] = -377.52153190744;
        ["g"] = 45;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [5] = {
        ["x"] = 298.75211997001;
        ["y"] = -373.73130792376;
        ["g"] = 46;
        ["sublevel"] = 1;
      };
      [6] = {
        ["x"] = 272.60863543903;
        ["y"] = -383.35758681642;
        ["g"] = 47;
        ["sublevel"] = 1;
      };
      [7] = {
        ["x"] = 270.60869993214;
        ["y"] = -374.75446263186;
        ["g"] = 47;
        ["sublevel"] = 1;
      };
      [8] = {
        ["x"] = 265.09272006431;
        ["y"] = -338.83704787493;
        ["g"] = 55;
        ["sublevel"] = 1;
        ["infested"] = {
          [3] = true;
        };
      };
      [9] = {
        ["x"] = 278.8854561517;
        ["y"] = -334.84696243622;
        ["g"] = 57;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["infested"] = {
          [1] = true;
        };
      };
      [10] = {
        ["x"] = 299.24865155987;
        ["y"] = -328.72602187459;
        ["g"] = 58;
        ["sublevel"] = 1;
        ["upstairs"] = true;
      };
      [11] = {
        ["x"] = 299.12672657478;
        ["y"] = -325.01736614394;
        ["g"] = 58;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["infested"] = {
        };
      };
      [12] = {
        ["x"] = 365.14799923092;
        ["y"] = -369.49490590883;
        ["g"] = 42;
        ["sublevel"] = 1;
        ["teeming"] = true;
      };
      [13] = {
        ["x"] = 374.21051123508;
        ["y"] = -369.80740331685;
        ["g"] = 42;
        ["sublevel"] = 1;
        ["teeming"] = true;
      };
    };
  };
  [20] = {
    ["name"] = "Captain Eudora";
    ["id"] = 126848;
    ["count"] = 0;
    ["health"] = 6762756;
    ["scale"] = 1;
    ["displayId"] = 80346;
    ["creatureType"] = "Humanoid";
    ["level"] = 122;
    ["isBoss"] = true;
    ["encounterID"] = 2093;
    ["instanceID"] = 1001;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [256979] = {
      };
      [257821] = {
      };
      [258352] = {
      };
      [258381] = {
      };
      [272902] = {
      };
      [272905] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 359.55574062333;
        ["y"] = -333.8100385074;
        ["g"] = 43;
        ["sublevel"] = 1;
      };
    };
  };
  [21] = {
    ["name"] = "Captain Raoul";
    ["id"] = 126847;
    ["count"] = 0;
    ["health"] = 6762756;
    ["scale"] = 1;
    ["displayId"] = 81060;
    ["creatureType"] = "Humanoid";
    ["level"] = 122;
    ["isBoss"] = true;
    ["encounterID"] = 2093;
    ["instanceID"] = 1001;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [256589] = {
      };
      [256594] = {
      };
      [257821] = {
      };
      [258338] = {
      };
      [272884] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 371.64872438521;
        ["y"] = -333.81004320864;
        ["g"] = 43;
        ["sublevel"] = 1;
      };
    };
  };
  [22] = {
    ["name"] = "Captain Jolly";
    ["id"] = 126845;
    ["count"] = 0;
    ["health"] = 6762756;
    ["scale"] = 1;
    ["displayId"] = 80532;
    ["creatureType"] = "Humanoid";
    ["level"] = 122;
    ["isBoss"] = true;
    ["encounterID"] = 2093;
    ["instanceID"] = 1001;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [257821] = {
      };
      [267522] = {
      };
      [267523] = {
      };
      [267533] = {
      };
      [272374] = {
      };
      [281329] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 384.21188228675;
        ["y"] = -334.39406436921;
        ["g"] = 43;
        ["sublevel"] = 1;
      };
    };
  };
  [23] = {
    ["name"] = "Cutwater Harpooner";
    ["id"] = 129601;
    ["count"] = 4;
    ["health"] = 768495;
    ["scale"] = 1;
    ["displayId"] = 80343;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["reaping"] = 148716;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Incapacitate"] = true;
      ["Silence"] = true;
      ["Polymorph"] = true;
      ["Root"] = true;
      ["Fear"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [209859] = {
      };
      [272412] = {
      };
      [272413] = {
      };
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 293.07381111868;
        ["y"] = -383.01859674491;
        ["g"] = 46;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [2] = {
        ["x"] = 332.47772021515;
        ["y"] = -354.6411923359;
        ["g"] = 49;
        ["sublevel"] = 1;
      };
      [3] = {
        ["x"] = 334.33487518181;
        ["y"] = -358.06975971105;
        ["g"] = 49;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [4] = {
        ["x"] = 320.62785439778;
        ["y"] = -332.75510566533;
        ["g"] = 51;
        ["sublevel"] = 1;
      };
      [5] = {
        ["x"] = 320.08125237049;
        ["y"] = -341.63783109392;
        ["g"] = 51;
        ["sublevel"] = 1;
        ["infested"] = {
          [2] = true;
        };
      };
      [6] = {
        ["x"] = 305.18409833939;
        ["y"] = -345.46152586901;
        ["g"] = 56;
        ["sublevel"] = 1;
      };
      [7] = {
        ["x"] = 300.18408177117;
        ["y"] = -351.46153716781;
        ["g"] = 56;
        ["sublevel"] = 1;
      };
      [8] = {
        ["x"] = 281.59289372436;
        ["y"] = -362.03865517872;
        ["g"] = 53;
        ["sublevel"] = 1;
      };
      [9] = {
        ["x"] = 282.10418699639;
        ["y"] = -355.75095567493;
        ["g"] = 53;
        ["sublevel"] = 1;
      };
      [10] = {
        ["x"] = 273.21381668619;
        ["y"] = -334.5484510505;
        ["g"] = 57;
        ["sublevel"] = 1;
        ["upstairs"] = true;
      };
    };
  };
  [24] = {
    ["name"] = "Irontide Crusher";
    ["id"] = 130400;
    ["count"] = 6;
    ["health"] = 1536990;
    ["scale"] = 1.4;
    ["displayId"] = 68059;
    ["creatureType"] = "Giant";
    ["level"] = 121;
    ["reaping"] = 148894;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [209859] = {
      };
      [258181] = {
      };
      [258199] = {
      };
      [276061] = {
      };
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 254.27578455822;
        ["y"] = -393.11478902913;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [2] = {
        ["x"] = 267.78112006396;
        ["y"] = -360.8307755636;
        ["g"] = 80;
        ["sublevel"] = 1;
        ["infested"] = {
          [3] = true;
        };
      };
      [3] = {
        ["x"] = 321.21716564031;
        ["y"] = -359.98608439708;
        ["sublevel"] = 1;
        ["patrol"] = {
          [1] = {
            ["x"] = 321.21716564031;
            ["y"] = -359.98608439708;
          };
          [2] = {
            ["x"] = 329.21716232548;
            ["y"] = -334.16791966086;
          };
          [3] = {
            ["x"] = 321.21716564031;
            ["y"] = -359.98608439708;
          };
          [4] = {
            ["x"] = 299.03535026551;
            ["y"] = -356.16791444647;
          };
        };
        ["infested"] = {
          [3] = true;
        };
      };
      [4] = {
        ["x"] = 253.48113073175;
        ["y"] = -327.44045484293;
        ["sublevel"] = 1;
        ["infested"] = {
          [3] = true;
        };
      };
      [5] = {
        ["x"] = 267.66607255606;
        ["y"] = -365.82089742123;
        ["sublevel"] = 1;
        ["teeming"] = true;
      };
    };
  };
  [25] = {
    ["name"] = "Ludwig Von Tortollan";
    ["id"] = 129699;
    ["count"] = 4;
    ["health"] = 3073980;
    ["scale"] = 1.5;
    ["displayId"] = 80792;
    ["creatureType"] = "Beast";
    ["level"] = 121;
    ["reaping"] = 148894;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [257904] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 245.69808511605;
        ["y"] = -361.77744763557;
        ["sublevel"] = 1;
      };
    };
  };
  [26] = {
    ["name"] = "Trothak";
    ["id"] = 126969;
    ["count"] = 0;
    ["health"] = 5533158;
    ["scale"] = 1;
    ["displayId"] = 55657;
    ["creatureType"] = "Humanoid";
    ["level"] = 122;
    ["isBoss"] = true;
    ["encounterID"] = 2094;
    ["instanceID"] = 1001;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [132951] = {
      };
      [256358] = {
      };
      [256363] = {
      };
      [256405] = {
      };
      [256546] = {
      };
      [256706] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 224.69808169065;
        ["y"] = -362.02744563276;
        ["sublevel"] = 1;
      };
    };
  };
  [27] = {
    ["name"] = "Irontide Stormcaller";
    ["id"] = 126919;
    ["count"] = 4;
    ["health"] = 614795;
    ["scale"] = 1;
    ["displayId"] = 79077;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["reaping"] = 148893;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Incapacitate"] = true;
      ["Silence"] = true;
      ["Polymorph"] = true;
      ["Root"] = true;
      ["Fear"] = true;
      ["Disorient"] = true;
      ["Imprison"] = true;
      ["Sap"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [209859] = {
      };
      [257736] = {
      };
      [257737] = {
      };
      [259092] = {
      };
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 330.82048838571;
        ["y"] = -226.55082875808;
        ["g"] = 60;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
        };
      };
      [2] = {
        ["x"] = 339.76653577595;
        ["y"] = -210.0949972306;
        ["g"] = 61;
        ["sublevel"] = 1;
        ["infested"] = {
          [2] = true;
        };
      };
      [3] = {
        ["x"] = 315.01297198444;
        ["y"] = -197.68005864604;
        ["g"] = 64;
        ["sublevel"] = 1;
      };
      [4] = {
        ["x"] = 306.72725932014;
        ["y"] = -186.53721467679;
        ["g"] = 64;
        ["sublevel"] = 1;
      };
    };
  };
  [28] = {
    ["name"] = "Irontide Ravager";
    ["id"] = 130012;
    ["count"] = 4;
    ["health"] = 768495;
    ["scale"] = 1;
    ["displayId"] = 81507;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["reaping"] = 148716;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Silence"] = true;
      ["Root"] = true;
      ["Fear"] = true;
      ["Disorient"] = true;
      ["Sap"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [132951] = {
      };
      [205276] = {
      };
      [209859] = {
      };
      [257899] = {
      };
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 335.38569207796;
        ["y"] = -226.55082875808;
        ["g"] = 60;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [2] = {
        ["x"] = 343.77415219959;
        ["y"] = -213.47315303961;
        ["g"] = 61;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [3] = {
        ["x"] = 356.46535620652;
        ["y"] = -180.70264486523;
        ["g"] = 63;
        ["sublevel"] = 1;
      };
    };
  };
  [29] = {
    ["name"] = "Irontide Officer";
    ["id"] = 127106;
    ["count"] = 6;
    ["health"] = 1229592;
    ["scale"] = 1.2;
    ["displayId"] = 81286;
    ["creatureType"] = "Humanoid";
    ["level"] = 121;
    ["reaping"] = 148894;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Silence"] = true;
      ["Root"] = true;
      ["Fear"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [132951] = {
      };
      [209859] = {
      };
      [257908] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 333.81155073167;
        ["y"] = -190.17959731949;
        ["g"] = 62;
        ["sublevel"] = 1;
        ["patrol"] = {
          [1] = {
            ["x"] = 333.12190009083;
            ["y"] = -188.97268280079;
          };
          [2] = {
            ["x"] = 333.8870398445;
            ["y"] = -202.79123618084;
          };
          [3] = {
            ["x"] = 333.12190009083;
            ["y"] = -188.97268280079;
          };
          [4] = {
            ["x"] = 326.51537691284;
            ["y"] = -181.69974815482;
          };
          [5] = {
            ["x"] = 318.81045577323;
            ["y"] = -184.32269135027;
          };
          [6] = {
            ["x"] = 326.51537691284;
            ["y"] = -181.69974815482;
          };
        };
        ["infested"] = {
          [3] = true;
        };
      };
    };
  };
  [30] = {
    ["name"] = "Harlan Sweete";
    ["id"] = 126983;
    ["count"] = 0;
    ["health"] = 7684950;
    ["scale"] = 1;
    ["displayId"] = 80841;
    ["creatureType"] = "Humanoid";
    ["level"] = 122;
    ["isBoss"] = true;
    ["encounterID"] = 2095;
    ["instanceID"] = 1001;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [132951] = {
      };
      [257278] = {
      };
      [257305] = {
      };
      [257308] = {
      };
      [257316] = {
      };
      [257402] = {
      };
      [257458] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 294.82907727659;
        ["y"] = -205.12285598889;
        ["g"] = 65;
        ["sublevel"] = 1;
      };
    };
  };
  [31] = {
    ["name"] = "Bilge Rat Swabby";
    ["id"] = 129526;
    ["count"] = 4;
    ["health"] = 768494;
    ["scale"] = 0.6;
    ["neutral"] = true;
    ["displayId"] = 80322;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["reaping"] = 148716;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Incapacitate"] = true;
      ["Silence"] = true;
      ["Polymorph"] = true;
      ["Root"] = true;
      ["Fear"] = true;
      ["Disorient"] = true;
      ["Sap"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [274507] = {
      };
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 446.86213684253;
        ["y"] = -408.30408532473;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [2] = {
        ["x"] = 450.41356063263;
        ["y"] = -408.32205343838;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [3] = {
        ["x"] = 449.47082999777;
        ["y"] = -413.52147163522;
        ["sublevel"] = 1;
      };
      [4] = {
        ["x"] = 374.79326397897;
        ["y"] = -404.91542632925;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["infested"] = {
          [3] = true;
        };
      };
      [5] = {
        ["x"] = 388.35701675341;
        ["y"] = -354.30550063995;
        ["sublevel"] = 1;
        ["infested"] = {
          [3] = true;
        };
      };
    };
  };
  [32] = {
    ["name"] = "Freehold Deckhand";
    ["id"] = 127119;
    ["count"] = 0;
    ["health"] = 153699;
    ["scale"] = 0.6;
    ["neutral"] = true;
    ["displayId"] = 78623;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["reaping"] = 148716;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Incapacitate"] = true;
      ["Silence"] = true;
      ["Root"] = true;
      ["Fear"] = true;
      ["Sap"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 431.4327036397;
        ["y"] = -443.70737899842;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [2] = {
        ["x"] = 426.78153843432;
        ["y"] = -440.91666390668;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [3] = {
        ["x"] = 437.01411386254;
        ["y"] = -439.98643884986;
        ["sublevel"] = 1;
        ["infested"] = {
          [3] = true;
        };
      };
      [8] = {
        ["x"] = 409.90550033856;
        ["y"] = -400.42291306931;
        ["sublevel"] = 1;
        ["patrol"] = {
          [1] = {
            ["x"] = 409.90550033856;
            ["y"] = -400.42291306931;
          };
          [2] = {
            ["x"] = 416.37918799437;
            ["y"] = -401.21913589891;
          };
          [3] = {
            ["x"] = 421.50113313294;
            ["y"] = -409.38986488378;
          };
          [4] = {
            ["x"] = 422.72065085833;
            ["y"] = -415.73132251415;
          };
          [5] = {
            ["x"] = 419.79380413055;
            ["y"] = -420.97522570555;
          };
          [6] = {
            ["x"] = 406.9889465177;
            ["y"] = -422.19473819736;
          };
          [7] = {
            ["x"] = 398.33041148939;
            ["y"] = -416.21912332401;
          };
          [8] = {
            ["x"] = 397.59869457387;
            ["y"] = -404.99962096;
          };
          [9] = {
            ["x"] = 403.0864981702;
            ["y"] = -400.48742945054;
          };
        };
        ["infested"] = {
          [1] = true;
        };
      };
      [9] = {
        ["x"] = 425.73693709783;
        ["y"] = -375.39600941973;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [13] = {
        ["x"] = 417.33293235944;
        ["y"] = -410.55586394165;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["infested"] = {
          [1] = true;
        };
      };
      [23] = {
        ["x"] = 424.31276866414;
        ["y"] = -384.66372890629;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
        };
      };
    };
  };
  [33] = {
    ["name"] = "Freehold Shipmate";
    ["id"] = 130522;
    ["count"] = 2;
    ["health"] = 249761;
    ["scale"] = 0.6;
    ["neutral"] = true;
    ["displayId"] = 80087;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["reaping"] = 148716;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Silence"] = true;
      ["Root"] = true;
      ["Fear"] = true;
      ["Disorient"] = true;
      ["Sap"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [1604] = {
      };
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 418.67307060213;
        ["y"] = -440.56507628456;
        ["sublevel"] = 1;
      };
      [2] = {
        ["x"] = 397.0100783833;
        ["y"] = -426.38716532254;
        ["sublevel"] = 1;
      };
      [3] = {
        ["x"] = 392.88085329862;
        ["y"] = -428.45950434897;
        ["sublevel"] = 1;
      };
      [4] = {
        ["x"] = 415.14236186031;
        ["y"] = -391.39382621995;
        ["sublevel"] = 1;
      };
      [5] = {
        ["x"] = 432.06899148287;
        ["y"] = -387.75538730739;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
        };
      };
      [6] = {
        ["x"] = 357.48824782226;
        ["y"] = -441.96021114246;
        ["sublevel"] = 1;
        ["upstairs"] = true;
        ["infested"] = {
          [1] = true;
        };
      };
      [7] = {
        ["x"] = 346.36813066386;
        ["y"] = -345.05410767656;
        ["g"] = 70;
        ["sublevel"] = 1;
      };
      [8] = {
        ["x"] = 349.33256563328;
        ["y"] = -342.45803773105;
        ["g"] = 70;
        ["sublevel"] = 1;
      };
      [9] = {
        ["x"] = 248.30630305316;
        ["y"] = -392.83762504572;
        ["sublevel"] = 1;
      };
      [10] = {
        ["x"] = 244.22470366503;
        ["y"] = -396.91925070855;
        ["sublevel"] = 1;
      };
      [11] = {
        ["x"] = 258.48416560637;
        ["y"] = -390.60274385876;
        ["sublevel"] = 1;
      };
      [12] = {
        ["x"] = 265.41597698255;
        ["y"] = -393.78455979609;
        ["sublevel"] = 1;
      };
    };
  };
  [34] = {
    ["name"] = "Freehold Barhand";
    ["id"] = 127124;
    ["count"] = 0;
    ["health"] = 115274;
    ["scale"] = 0.6;
    ["neutral"] = true;
    ["displayId"] = 79066;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["reaping"] = 148716;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Silence"] = true;
      ["Root"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 425.81058882877;
        ["y"] = -382.04446190413;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
      [2] = {
        ["x"] = 421.48066262642;
        ["y"] = -385.75685278606;
        ["sublevel"] = 1;
        ["infested"] = {
        };
      };
    };
  };
  [35] = {
    ["name"] = "Blacktooth Knuckleduster";
    ["id"] = 129547000;
    ["count"] = 0;
    ["health"] = 845343;
    ["scale"] = 1;
    ["displayId"] = 81207;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["clones"] = {
      [1] = {
        ["x"] = 423.43540478732;
        ["y"] = -403.58138534747;
        ["g"] = 72;
        ["sublevel"] = 1;
        ["blacktoothEvent"] = true;
      };
    };
  };
  [36] = {
    ["name"] = "Shiprat";
    ["id"] = 126497;
    ["count"] = 0;
    ["health"] = 6;
    ["scale"] = 0.6;
    ["displayId"] = 4959;
    ["creatureType"] = "Critter";
    ["level"] = 1;
    ["reaping"] = 148716;
    ["clones"] = {
      [1] = {
        ["x"] = 333.26151520657;
        ["y"] = -220.70211531603;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
        };
      };
    };
  };
  [37] = {
    ["name"] = "Emissary of the Tides";
    ["id"] = 155434;
    ["count"] = 4;
    ["health"] = 614795;
    ["ignoreFortified"] = true;
    ["scale"] = 1;
    ["displayId"] = 39391;
    ["iconTexture"] = 132315;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [302415] = {
      };
      [302417] = {
      };
      [302418] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 582.30250293643;
        ["y"] = -291.95015323478;
        ["g"] = 18;
        ["sublevel"] = 1;
        ["week"] = {
          [1] = true;
          [4] = true;
          [7] = true;
          [10] = true;
        };
      };
      [2] = {
        ["x"] = 428.06202083489;
        ["y"] = -419.54571042367;
        ["g"] = 27;
        ["sublevel"] = 1;
        ["week"] = {
          [1] = true;
          [4] = true;
          [7] = true;
          [10] = true;
        };
      };
      [3] = {
        ["x"] = 275.87748554166;
        ["y"] = -374.02781760134;
        ["g"] = 47;
        ["sublevel"] = 1;
        ["week"] = {
          [1] = true;
          [4] = true;
          [7] = true;
          [10] = true;
        };
      };
      [4] = {
        ["x"] = 351.23732496739;
        ["y"] = -183.85655552339;
        ["g"] = 63;
        ["sublevel"] = 1;
        ["week"] = {
          [1] = true;
          [4] = true;
          [7] = true;
          [10] = true;
        };
      };
      [5] = {
        ["x"] = 342.93664889702;
        ["y"] = -416.37733330228;
        ["g"] = 32;
        ["sublevel"] = 1;
        ["week"] = {
          [1] = true;
          [4] = true;
          [7] = true;
          [10] = true;
        };
      };
      [6] = {
        ["x"] = 563.54157633499;
        ["y"] = -247.68046809193;
        ["g"] = 3;
        ["sublevel"] = 1;
        ["week"] = {
          [2] = true;
          [5] = true;
          [8] = true;
          [11] = true;
        };
      };
      [7] = {
        ["x"] = 605.44800647203;
        ["y"] = -314.16004790875;
        ["g"] = 8;
        ["sublevel"] = 1;
        ["week"] = {
          [2] = true;
          [5] = true;
          [8] = true;
          [11] = true;
        };
      };
      [8] = {
        ["x"] = 426.81291888979;
        ["y"] = -387.75422453959;
        ["g"] = 23;
        ["sublevel"] = 1;
        ["week"] = {
          [2] = true;
          [5] = true;
          [8] = true;
          [11] = true;
        };
      };
      [9] = {
        ["x"] = 448.75870249507;
        ["y"] = -410.70050327641;
        ["sublevel"] = 1;
        ["week"] = {
          [2] = true;
          [5] = true;
          [8] = true;
          [11] = true;
        };
      };
      [10] = {
        ["x"] = 338.37577949106;
        ["y"] = -360.24915170617;
        ["g"] = 49;
        ["sublevel"] = 1;
        ["week"] = {
          [2] = true;
          [5] = true;
          [8] = true;
          [11] = true;
        };
      };
      [11] = {
        ["x"] = 339.07172016809;
        ["y"] = -213.74565817939;
        ["g"] = 61;
        ["sublevel"] = 1;
        ["week"] = {
          [2] = true;
          [5] = true;
          [8] = true;
          [11] = true;
        };
      };
      [12] = {
        ["x"] = 316.94527487871;
        ["y"] = -187.22855340355;
        ["g"] = 64;
        ["sublevel"] = 1;
        ["week"] = {
          [2] = true;
          [5] = true;
          [8] = true;
          [11] = true;
        };
      };
      [13] = {
        ["x"] = 282.11715470633;
        ["y"] = -390.56685023284;
        ["g"] = 53;
        ["sublevel"] = 1;
        ["week"] = {
          [2] = true;
          [5] = true;
          [8] = true;
          [11] = true;
        };
      };
      [14] = {
        ["x"] = 595.98043301204;
        ["y"] = -250.02011579983;
        ["g"] = 4;
        ["sublevel"] = 1;
        ["week"] = {
          [3] = true;
          [6] = true;
          [9] = true;
          [12] = true;
        };
      };
      [15] = {
        ["x"] = 556.68938922037;
        ["y"] = -268.00825204892;
        ["g"] = 9;
        ["sublevel"] = 1;
        ["week"] = {
          [3] = true;
          [6] = true;
          [9] = true;
          [12] = true;
        };
      };
      [16] = {
        ["x"] = 424.16357177479;
        ["y"] = -416.63493784565;
        ["g"] = 27;
        ["sublevel"] = 1;
        ["week"] = {
          [3] = true;
          [6] = true;
          [9] = true;
          [12] = true;
        };
      };
      [17] = {
        ["x"] = 387.35054932879;
        ["y"] = -418.2574930252;
        ["g"] = 30;
        ["sublevel"] = 1;
        ["week"] = {
          [3] = true;
          [6] = true;
          [9] = true;
          [12] = true;
        };
      };
      [18] = {
        ["x"] = 377.40686690757;
        ["y"] = -374.35139133781;
        ["g"] = 42;
        ["sublevel"] = 1;
        ["week"] = {
          [3] = true;
          [6] = true;
          [9] = true;
          [12] = true;
        };
      };
      [19] = {
        ["x"] = 327.0287708105;
        ["y"] = -336.74570419942;
        ["g"] = 51;
        ["sublevel"] = 1;
        ["week"] = {
          [3] = true;
          [6] = true;
          [9] = true;
          [12] = true;
        };
      };
      [20] = {
        ["x"] = 282.26142749583;
        ["y"] = -326.90253473373;
        ["g"] = 57;
        ["sublevel"] = 1;
        ["week"] = {
          [3] = true;
          [6] = true;
          [9] = true;
          [12] = true;
        };
      };
    };
  };
  [38] = {
    ["name"] = "Void-Touched Emissary";
    ["id"] = 155433;
    ["count"] = 4;
    ["health"] = 999042;
    ["ignoreFortified"] = true;
    ["scale"] = 1;
    ["stealthDetect"] = true;
    ["displayId"] = 39391;
    ["iconTexture"] = 132886;
    ["creatureType"] = "Humanoid";
    ["level"] = 122;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [302415] = {
      };
      [302419] = {
      };
      [302420] = {
      };
      [302421] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 574.23008755425;
        ["y"] = -242.01084170409;
        ["g"] = 73;
        ["sublevel"] = 1;
        ["week"] = {
          [1] = true;
          [4] = true;
          [7] = true;
          [10] = true;
        };
      };
      [2] = {
        ["x"] = 561.81069777028;
        ["y"] = -356.8953407165;
        ["g"] = 74;
        ["sublevel"] = 1;
        ["week"] = {
          [1] = true;
          [4] = true;
          [7] = true;
          [10] = true;
        };
      };
      [3] = {
        ["x"] = 428.66798409562;
        ["y"] = -378.55485900182;
        ["g"] = 75;
        ["sublevel"] = 1;
        ["week"] = {
          [1] = true;
          [4] = true;
          [7] = true;
          [10] = true;
        };
      };
      [4] = {
        ["x"] = 445.68436570913;
        ["y"] = -397.42265713305;
        ["g"] = 76;
        ["sublevel"] = 1;
        ["week"] = {
          [1] = true;
          [4] = true;
          [7] = true;
          [10] = true;
        };
      };
      [5] = {
        ["x"] = 385.20545584839;
        ["y"] = -363.95071595557;
        ["sublevel"] = 1;
        ["week"] = {
          [1] = true;
          [4] = true;
          [7] = true;
          [10] = true;
        };
      };
      [6] = {
        ["x"] = 332.82265837518;
        ["y"] = -339.95792564529;
        ["g"] = 78;
        ["sublevel"] = 1;
        ["week"] = {
          [1] = true;
          [4] = true;
          [7] = true;
          [10] = true;
        };
      };
      [7] = {
        ["x"] = 291.73770449832;
        ["y"] = -352.78085178461;
        ["g"] = 79;
        ["sublevel"] = 1;
        ["week"] = {
          [1] = true;
          [4] = true;
          [7] = true;
          [10] = true;
        };
      };
      [8] = {
        ["x"] = 334.43564030022;
        ["y"] = -211.966193448;
        ["g"] = 61;
        ["sublevel"] = 1;
        ["week"] = {
          [1] = true;
          [4] = true;
          [7] = true;
          [10] = true;
        };
      };
      [9] = {
        ["x"] = 388.47377027915;
        ["y"] = -403.84727588351;
        ["g"] = 30;
        ["sublevel"] = 1;
        ["week"] = {
          [2] = true;
          [5] = true;
          [8] = true;
          [11] = true;
        };
      };
      [10] = {
        ["x"] = 263.06736970156;
        ["y"] = -378.54662964872;
        ["g"] = 47;
        ["sublevel"] = 1;
        ["week"] = {
          [2] = true;
          [5] = true;
          [8] = true;
          [11] = true;
        };
      };
      [11] = {
        ["x"] = 351.96821182746;
        ["y"] = -183.57331530092;
        ["g"] = 63;
        ["sublevel"] = 1;
        ["week"] = {
          [2] = true;
          [5] = true;
          [8] = true;
          [11] = true;
        };
      };
      [12] = {
        ["x"] = 616.16375668691;
        ["y"] = -286.41747205571;
        ["g"] = 7;
        ["sublevel"] = 1;
        ["week"] = {
          [2] = true;
          [5] = true;
          [8] = true;
          [11] = true;
        };
      };
      [13] = {
        ["x"] = 584.22521877266;
        ["y"] = -291.20408540459;
        ["g"] = 18;
        ["sublevel"] = 1;
        ["week"] = {
          [3] = true;
          [6] = true;
          [9] = true;
          [12] = true;
        };
      };
      [14] = {
        ["x"] = 273.50423791883;
        ["y"] = -365.87804201991;
        ["g"] = 80;
        ["sublevel"] = 1;
        ["week"] = {
          [3] = true;
          [6] = true;
          [9] = true;
          [12] = true;
        };
      };
    };
  };
  [39] = {
    ["name"] = "Enchanted Emissary";
    ["id"] = 155432;
    ["count"] = 4;
    ["health"] = 15369884;
    ["ignoreFortified"] = true;
    ["scale"] = 1;
    ["displayId"] = 39391;
    ["iconTexture"] = 135735;
    ["creatureType"] = "Humanoid";
    ["level"] = 121;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [290027] = {
      };
      [302415] = {
      };
      [303632] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 597.18729485725;
        ["y"] = -258.24102373746;
        ["g"] = 4;
        ["sublevel"] = 1;
        ["week"] = {
          [1] = true;
          [4] = true;
          [7] = true;
          [10] = true;
        };
      };
      [2] = {
        ["x"] = 419.08191392655;
        ["y"] = -402.32295149245;
        ["g"] = 72;
        ["sublevel"] = 1;
        ["week"] = {
          [1] = true;
          [4] = true;
          [7] = true;
          [10] = true;
        };
      };
      [3] = {
        ["x"] = 349.99263948952;
        ["y"] = -345.97198015544;
        ["g"] = 77;
        ["sublevel"] = 1;
        ["week"] = {
          [1] = true;
          [4] = true;
          [7] = true;
          [10] = true;
        };
      };
      [4] = {
        ["x"] = 281.66695459247;
        ["y"] = -329.24954901654;
        ["g"] = 57;
        ["sublevel"] = 1;
        ["week"] = {
          [1] = true;
          [4] = true;
          [7] = true;
          [10] = true;
        };
      };
      [5] = {
        ["x"] = 529.50479141079;
        ["y"] = -279.40176356912;
        ["g"] = 12;
        ["sublevel"] = 1;
        ["week"] = {
          [1] = true;
          [4] = true;
          [7] = true;
          [10] = true;
        };
      };
      [6] = {
        ["x"] = 583.78124469935;
        ["y"] = -291.06588162301;
        ["g"] = 18;
        ["sublevel"] = 1;
        ["week"] = {
          [2] = true;
          [5] = true;
          [8] = true;
          [11] = true;
        };
      };
      [7] = {
        ["x"] = 376.19365471646;
        ["y"] = -373.28672288567;
        ["g"] = 42;
        ["sublevel"] = 1;
        ["week"] = {
          [2] = true;
          [5] = true;
          [8] = true;
          [11] = true;
        };
      };
      [8] = {
        ["x"] = 308.71664328533;
        ["y"] = -346.04459277918;
        ["g"] = 56;
        ["sublevel"] = 1;
        ["week"] = {
          [2] = true;
          [5] = true;
          [8] = true;
          [11] = true;
        };
      };
      [9] = {
        ["x"] = 377.95753476687;
        ["y"] = -399.31900060793;
        ["g"] = 31;
        ["sublevel"] = 1;
        ["week"] = {
          [2] = true;
          [5] = true;
          [8] = true;
          [11] = true;
        };
      };
      [10] = {
        ["x"] = 584.415568733;
        ["y"] = -234.59158596522;
        ["g"] = 2;
        ["sublevel"] = 1;
        ["week"] = {
          [3] = true;
          [6] = true;
          [9] = true;
          [12] = true;
        };
      };
      [11] = {
        ["x"] = 605.30034623964;
        ["y"] = -314.00732889402;
        ["g"] = 8;
        ["sublevel"] = 1;
        ["week"] = {
          [3] = true;
          [6] = true;
          [9] = true;
          [12] = true;
        };
      };
      [12] = {
        ["x"] = 553.06874413736;
        ["y"] = -323.10909725706;
        ["g"] = 16;
        ["sublevel"] = 1;
        ["week"] = {
          [3] = true;
          [6] = true;
          [9] = true;
          [12] = true;
        };
      };
      [13] = {
        ["x"] = 428.09024552171;
        ["y"] = -395.44957718268;
        ["g"] = 23;
        ["sublevel"] = 1;
        ["week"] = {
          [3] = true;
          [6] = true;
          [9] = true;
          [12] = true;
        };
      };
      [14] = {
        ["x"] = 337.41245133228;
        ["y"] = -383.44885098466;
        ["g"] = 44;
        ["sublevel"] = 1;
        ["week"] = {
          [3] = true;
          [6] = true;
          [9] = true;
          [12] = true;
        };
      };
      [15] = {
        ["x"] = 263.1461363294;
        ["y"] = -380.94270305081;
        ["g"] = 47;
        ["sublevel"] = 1;
        ["week"] = {
          [3] = true;
          [6] = true;
          [9] = true;
          [12] = true;
        };
      };
      [16] = {
        ["x"] = 349.20262223984;
        ["y"] = -184.36561827901;
        ["g"] = 63;
        ["sublevel"] = 1;
        ["week"] = {
          [3] = true;
          [6] = true;
          [9] = true;
          [12] = true;
        };
      };
    };
  };
  [40] = {
    ["name"] = "Samh'rek, Beckoner of Chaos";
    ["id"] = 161243;
    ["count"] = 4;
    ["teemingCount"] = 6;
    ["health"] = 2151786;
    ["scale"] = 1.4;
    ["stealthDetect"] = true;
    ["displayId"] = 90742;
    ["creatureType"] = "Aberration";
    ["level"] = 122;
    ["corrupted"] = true;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [314397] = {
      };
      [314477] = {
      };
      [314483] = {
      };
      [314531] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 432.73180582462;
        ["y"] = -396.61272320204;
        ["sublevel"] = 1;
        ["week"] = {
          [1] = true;
          [2] = true;
          [3] = true;
          [4] = true;
          [5] = true;
          [6] = true;
          [7] = true;
          [8] = true;
          [9] = true;
          [10] = true;
          [11] = true;
          [12] = true;
        };
      };
    };
  };
  [41] = {
    ["name"] = "Urg'roth, Breaker of Heroes";
    ["id"] = 161124;
    ["count"] = 4;
    ["teemingCount"] = 6;
    ["health"] = 2151786;
    ["scale"] = 1.4;
    ["stealthDetect"] = true;
    ["displayId"] = 89415;
    ["creatureType"] = "Aberration";
    ["level"] = 122;
    ["corrupted"] = true;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [314308] = {
      };
      [314309] = {
      };
      [314387] = {
      };
      [314397] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 265.23690933375;
        ["y"] = -329.32092477844;
        ["sublevel"] = 1;
        ["week"] = {
          [1] = true;
          [2] = true;
          [5] = true;
          [6] = true;
          [9] = true;
          [10] = true;
        };
      };
      [2] = {
        ["x"] = 544.36282996575;
        ["y"] = -227.22658610567;
        ["sublevel"] = 1;
        ["week"] = {
          [3] = true;
          [4] = true;
          [7] = true;
          [8] = true;
          [11] = true;
          [12] = true;
        };
      };
    };
  };
  [42] = {
    ["name"] = "Voidweaver Mal'thir";
    ["id"] = 161241;
    ["count"] = 4;
    ["teemingCount"] = 6;
    ["health"] = 2151786;
    ["scale"] = 1.4;
    ["stealthDetect"] = true;
    ["displayId"] = 91910;
    ["creatureType"] = "Beast";
    ["level"] = 122;
    ["corrupted"] = true;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [314397] = {
      };
      [314406] = {
      };
      [314411] = {
      };
      [314463] = {
      };
      [314467] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 355.48569921046;
        ["y"] = -194.25966992696;
        ["sublevel"] = 1;
        ["week"] = {
          [1] = true;
          [2] = true;
          [3] = true;
          [4] = true;
          [5] = true;
          [6] = true;
          [7] = true;
          [8] = true;
          [9] = true;
          [10] = true;
          [11] = true;
          [12] = true;
        };
      };
    };
  };
  [43] = {
    ["name"] = "Blood of the Corruptor";
    ["id"] = 161244;
    ["count"] = 4;
    ["teemingCount"] = 6;
    ["health"] = 2151786;
    ["scale"] = 1.4;
    ["stealthDetect"] = true;
    ["displayId"] = 92229;
    ["creatureType"] = "Aberration";
    ["level"] = 122;
    ["corrupted"] = true;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [314397] = {
      };
      [314565] = {
      };
      [314566] = {
      };
      [314592] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 544.39496214207;
        ["y"] = -225.72526778273;
        ["sublevel"] = 1;
        ["week"] = {
          [1] = true;
          [2] = true;
          [5] = true;
          [6] = true;
          [9] = true;
          [10] = true;
        };
      };
      [2] = {
        ["x"] = 264.54964167183;
        ["y"] = -330.62030234688;
        ["sublevel"] = 1;
        ["week"] = {
          [3] = true;
          [4] = true;
          [7] = true;
          [8] = true;
          [11] = true;
          [12] = true;
        };
      };
    };
  };
  [44] = {
    ["name"] = "Freehold Deckhand";
    ["id"] = 130521;
    ["count"] = 1;
    ["health"] = 18449;
    ["scale"] = 0.6;
    ["neutral"] = true;
    ["displayId"] = 78623;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["reaping"] = 148716;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Incapacitate"] = true;
      ["Silence"] = true;
      ["Root"] = true;
      ["Fear"] = true;
      ["Sap"] = true;
      ["Stun"] = true;
      ["Slow"] = true;
    };
    ["spells"] = {
      [277242] = {
      };
      [277564] = {
      };
    };
    ["clones"] = {
      [4] = {
        ["x"] = 392.48611128988;
        ["y"] = -431.35423955244;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
        };
      };
      [5] = {
        ["x"] = 389.72296240274;
        ["y"] = -431.35423955244;
        ["sublevel"] = 1;
      };
      [6] = {
        ["x"] = 389.72296240274;
        ["y"] = -428.72266004137;
        ["sublevel"] = 1;
      };
      [7] = {
        ["x"] = 384.48718115197;
        ["y"] = -421.58180185169;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
        };
      };
      [10] = {
        ["x"] = 359.73697530238;
        ["y"] = -444.682195676;
        ["sublevel"] = 1;
        ["upstairs"] = true;
      };
      [11] = {
        ["x"] = 358.77807038385;
        ["y"] = -438.79178982585;
        ["sublevel"] = 1;
        ["upstairs"] = true;
      };
      [12] = {
        ["x"] = 373.56751166519;
        ["y"] = -420.13504628936;
        ["sublevel"] = 1;
        ["upstairs"] = true;
      };
      [14] = {
        ["x"] = 344.57703227835;
        ["y"] = -339.97945761309;
        ["g"] = 70;
        ["sublevel"] = 1;
      };
      [15] = {
        ["x"] = 350.61233522429;
        ["y"] = -339.74923835879;
        ["g"] = 70;
        ["sublevel"] = 1;
        ["infested"] = {
          [1] = true;
        };
      };
      [16] = {
        ["x"] = 343.23381235593;
        ["y"] = -344.6063341927;
        ["g"] = 70;
        ["sublevel"] = 1;
      };
      [17] = {
        ["x"] = 245.04100602619;
        ["y"] = -393.04170939424;
        ["sublevel"] = 1;
      };
      [18] = {
        ["x"] = 247.76755448611;
        ["y"] = -397.58700738667;
        ["sublevel"] = 1;
      };
      [19] = {
        ["x"] = 262.34779401948;
        ["y"] = -389.92092650624;
        ["sublevel"] = 1;
      };
      [20] = {
        ["x"] = 262.90768116939;
        ["y"] = -396.0520724445;
        ["sublevel"] = 1;
      };
      [21] = {
        ["x"] = 266.48977407349;
        ["y"] = -386.78688288329;
        ["sublevel"] = 1;
      };
      [22] = {
        ["x"] = 369.90063436546;
        ["y"] = -432.78722978124;
        ["sublevel"] = 1;
        ["upstairs"] = true;
      };
    };
  };
};
