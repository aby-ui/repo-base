local MDT = MDT
local L = MDT.L
local dungeonIndex = 26
MDT.dungeonList[dungeonIndex] = L["Mechagon - Workshop"]
MDT.mapInfo[dungeonIndex] = {
  viewportPositionOverrides =
  {
    [2] = {
      zoomScale = 1.5999999046326;
      horizontalPan = 202.69757113491;
      verticalPan = 126.55720322784;
    };
    [3] = {
      zoomScale = 1.2999999523163;
      horizontalPan = 105.50581163535;
      verticalPan = 109.22701167556;
    };
  };
};

MDT.dungeonMaps[dungeonIndex] = {
  [0] = "MechagonDungeon",
  [1] = "MechagonDungeon1_",
  [2] = "MechagonDungeon3_",
  [3] = "MechagonDungeon4_",
}
MDT.dungeonSubLevels[dungeonIndex] = {
  [1] = L["The Robodrome"],
  [2] = L["The Under Junk"],
  [3] = L["Mechagon City"],
}

MDT.dungeonTotalCount[dungeonIndex] = { normal = 160, teeming = 192, teemingEnabled = true }
MDT.mapPOIs[dungeonIndex] = {
  [1] = {
    [1] = {
      ["template"] = "MapLinkPinTemplate";
      ["type"] = "mapLink";
      ["x"] = 309.61613296983;
      ["y"] = -344.0717104272;
      ["target"] = 2;
      ["direction"] = -1;
      ["connectionIndex"] = 1;
    };
  };
  [2] = {
    [1] = {
      ["template"] = "MapLinkPinTemplate";
      ["type"] = "mapLink";
      ["x"] = 466.94234514817;
      ["y"] = -444.44517818302;
      ["target"] = 1;
      ["direction"] = 1;
      ["connectionIndex"] = 1;
    };
    [2] = {
      ["template"] = "MapLinkPinTemplate";
      ["type"] = "mapLink";
      ["x"] = 400.22732136754;
      ["y"] = -153.56451426492;
      ["target"] = 3;
      ["direction"] = -2;
      ["connectionIndex"] = 2;
    };
    [3] = {
      ["template"] = "VignettePinTemplate";
      ["type"] = "nyalothaSpire";
      ["x"] = 427.29831246484;
      ["y"] = -387.01163878014;
      ["index"] = 1;
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
  };
  [3] = {
    [1] = {
      ["template"] = "MapLinkPinTemplate";
      ["type"] = "mapLink";
      ["x"] = 518.05941971039;
      ["y"] = -434.64189702298;
      ["target"] = 2;
      ["direction"] = 2;
      ["connectionIndex"] = 2;
    };
    [2] = {
      ["template"] = "VignettePinTemplate";
      ["type"] = "nyalothaSpire";
      ["x"] = 583.95261802562;
      ["y"] = -196.78696311057;
      ["index"] = 2;
      ["npcId"] = 161244;
      ["tooltipText"] = "Defiled Spire of Ny'alotha";
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
    [3] = {
      ["template"] = "VignettePinTemplate";
      ["type"] = "nyalothaSpire";
      ["x"] = 518.79281541031;
      ["y"] = -316.04973510387;
      ["index"] = 3;
      ["npcId"] = 161241;
      ["tooltipText"] = "Cursed Spire of Ny'alotha";
      ["weeks"] = {
        [1] = true;
        [2] = true;
        [5] = true;
        [6] = true;
        [9] = true;
        [10] = true;
      };
    };
    [4] = {
      ["template"] = "VignettePinTemplate";
      ["type"] = "nyalothaSpire";
      ["x"] = 261.46012993765;
      ["y"] = -482.69635226266;
      ["index"] = 4;
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
    [5] = {
      ["template"] = "VignettePinTemplate";
      ["type"] = "nyalothaSpire";
      ["x"] = 521.12234499945;
      ["y"] = -314.41684201658;
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
    [6] = {
      ["template"] = "VignettePinTemplate";
      ["type"] = "nyalothaSpire";
      ["x"] = 263.04799966455;
      ["y"] = -482.76939866107;
      ["index"] = 6;
      ["npcId"] = 161241;
      ["tooltipText"] = "Cursed Spire of Ny'alotha";
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
      [314478] = {
      };
      [314483] = {
      };
      [314531] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 415.49306032303;
        ["y"] = -387.72142697985;
        ["sublevel"] = 2;
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
  [2] = {
    ["name"] = "Urg'roth, Breaker of Heroes";
    ["id"] = 161124;
    ["count"] = 4;
    ["teemingCount"] = 6;
    ["health"] = 2305485;
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
        ["x"] = 270.77807786568;
        ["y"] = -474.23647104838;
        ["sublevel"] = 3;
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
        ["x"] = 513.87414677701;
        ["y"] = -327.57515030846;
        ["sublevel"] = 3;
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
  [3] = {
    ["name"] = "Voidweaver Mal'thir";
    ["id"] = 161241;
    ["count"] = 4;
    ["teemingCount"] = 6;
    ["health"] = 1998087;
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
        ["x"] = 509.35379102691;
        ["y"] = -330.0865069582;
        ["sublevel"] = 3;
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
        ["x"] = 272.2534435685;
        ["y"] = -470.97178097464;
        ["sublevel"] = 3;
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
  [4] = {
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
        ["x"] = 592.22743961573;
        ["y"] = -180.41171990004;
        ["sublevel"] = 3;
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
  [5] = {
    ["name"] = "Blastatron X-80";
    ["id"] = 151476;
    ["count"] = 10;
    ["health"] = 1921238;
    ["scale"] = 1.4;
    ["displayId"] = 90712;
    ["creatureType"] = "Mechanical";
    ["level"] = 121;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [293986] = {
      };
      [294015] = {
      };
      [295169] = {
      };
      [295170] = {
      };
      [295183] = {
      };
      [296348] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 435.06247431919;
        ["y"] = -406.34323129692;
        ["sublevel"] = 3;
      };
    };
  };
  [6] = {
    ["name"] = "Mechagon Citizen";
    ["id"] = 144300;
    ["count"] = 0;
    ["health"] = 192124;
    ["scale"] = 0.7;
    ["displayId"] = 91167;
    ["creatureType"] = "Mechanical";
    ["level"] = 120;
    ["characteristics"] = {
      ["Stun"] = true;
    };
    ["clones"] = {
      [1] = {
        ["x"] = 499.70337825139;
        ["y"] = -421.66419640937;
        ["g"] = 8;
        ["sublevel"] = 3;
      };
      [2] = {
        ["x"] = 496.86060747485;
        ["y"] = -430.63364694467;
        ["g"] = 8;
        ["sublevel"] = 3;
      };
      [3] = {
        ["x"] = 492.84152392959;
        ["y"] = -436.90737631667;
        ["g"] = 8;
        ["sublevel"] = 3;
      };
      [4] = {
        ["x"] = 484.6561799684;
        ["y"] = -435.51047744238;
        ["g"] = 8;
        ["sublevel"] = 3;
      };
      [5] = {
        ["x"] = 487.30300371032;
        ["y"] = -443.69571816028;
        ["g"] = 8;
        ["sublevel"] = 3;
      };
      [6] = {
        ["x"] = 484.67447267549;
        ["y"] = -428.52550114086;
        ["g"] = 8;
        ["sublevel"] = 3;
      };
      [7] = {
        ["x"] = 493.51113606412;
        ["y"] = -419.85584273725;
        ["g"] = 8;
        ["sublevel"] = 3;
      };
      [8] = {
        ["x"] = 490.17023050112;
        ["y"] = -427.34976261929;
        ["g"] = 8;
        ["sublevel"] = 3;
      };
      [9] = {
        ["x"] = 478.16193916255;
        ["y"] = -440.55886808142;
        ["g"] = 8;
        ["sublevel"] = 3;
      };
      [10] = {
        ["x"] = 487.54800405373;
        ["y"] = -420.92899835806;
        ["g"] = 8;
        ["sublevel"] = 3;
      };
      [11] = {
        ["x"] = 486.03961528088;
        ["y"] = -413.68897609184;
        ["g"] = 8;
        ["sublevel"] = 3;
      };
      [12] = {
        ["x"] = 477.97117706412;
        ["y"] = -432.47763924175;
        ["g"] = 8;
        ["sublevel"] = 3;
      };
      [13] = {
        ["x"] = 500.60243944338;
        ["y"] = -345.60610751627;
        ["g"] = 11;
        ["sublevel"] = 3;
      };
      [14] = {
        ["x"] = 510.79229020326;
        ["y"] = -344.09650599496;
        ["g"] = 11;
        ["sublevel"] = 3;
      };
      [15] = {
        ["x"] = 499.84760628993;
        ["y"] = -352.96549186558;
        ["g"] = 11;
        ["sublevel"] = 3;
      };
      [16] = {
        ["x"] = 508.90528020342;
        ["y"] = -350.51236104974;
        ["g"] = 11;
        ["sublevel"] = 3;
      };
      [17] = {
        ["x"] = 514.00022987796;
        ["y"] = -356.92822420273;
        ["g"] = 11;
        ["sublevel"] = 3;
      };
    };
  };
  [7] = {
    ["name"] = "Defense Bot Mk I";
    ["id"] = 151649;
    ["count"] = 4;
    ["health"] = 806920;
    ["scale"] = 1;
    ["displayId"] = 91349;
    ["creatureType"] = "Mechanical";
    ["level"] = 120;
    ["characteristics"] = {
      ["Stun"] = true;
    };
    ["spells"] = {
      [294195] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 438.24199819465;
        ["y"] = -447.10383393789;
        ["g"] = 10;
        ["sublevel"] = 3;
      };
      [2] = {
        ["x"] = 432.89392785131;
        ["y"] = -431.77408026805;
        ["g"] = 10;
        ["sublevel"] = 3;
      };
      [3] = {
        ["x"] = 604.72424938609;
        ["y"] = -209.62623239455;
        ["g"] = 12;
        ["sublevel"] = 3;
      };
      [4] = {
        ["x"] = 611.47784039704;
        ["y"] = -193.33828230687;
        ["g"] = 12;
        ["sublevel"] = 3;
      };
    };
  };
  [8] = {
    ["name"] = "Mechagon Tinkerer";
    ["id"] = 144294;
    ["count"] = 4;
    ["health"] = 768495;
    ["scale"] = 1;
    ["displayId"] = 91170;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["characteristics"] = {
      ["Polymorph"] = true;
      ["Stun"] = true;
    };
    ["spells"] = {
      [293827] = {
      };
      [293854] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 452.54473391855;
        ["y"] = -417.70447330755;
        ["g"] = 9;
        ["sublevel"] = 3;
      };
      [2] = {
        ["x"] = 460.05502978644;
        ["y"] = -408.05752691365;
        ["g"] = 9;
        ["sublevel"] = 3;
      };
      [3] = {
        ["x"] = 596.16623437765;
        ["y"] = -203.897120688;
        ["g"] = 12;
        ["sublevel"] = 3;
      };
      [4] = {
        ["x"] = 283.88727151756;
        ["y"] = -446.50406505997;
        ["g"] = 13;
        ["sublevel"] = 3;
      };
      [5] = {
        ["x"] = 307.06091955626;
        ["y"] = -299.74609894492;
        ["g"] = 14;
        ["sublevel"] = 3;
      };
      [6] = {
        ["x"] = 606.89150891813;
        ["y"] = -185.02700485576;
        ["g"] = 12;
        ["sublevel"] = 3;
        ["teeming"] = true;
      };
    };
  };
  [9] = {
    ["name"] = "Workshop Defender";
    ["id"] = 144299;
    ["count"] = 4;
    ["health"] = 768495;
    ["scale"] = 1;
    ["displayId"] = 91183;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["characteristics"] = {
      ["Polymorph"] = true;
      ["Stun"] = true;
    };
    ["spells"] = {
      [293670] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 596.35310107265;
        ["y"] = -196.75146056589;
        ["g"] = 12;
        ["sublevel"] = 3;
      };
      [2] = {
        ["x"] = 275.4461942786;
        ["y"] = -450.49903723392;
        ["g"] = 13;
        ["sublevel"] = 3;
      };
      [3] = {
        ["x"] = 287.37702464163;
        ["y"] = -455.61225024665;
        ["g"] = 13;
        ["sublevel"] = 3;
      };
      [4] = {
        ["x"] = 300.7164362048;
        ["y"] = -305.46689987613;
        ["g"] = 14;
        ["sublevel"] = 3;
      };
      [5] = {
        ["x"] = 280.62386541069;
        ["y"] = -455.35139934526;
        ["g"] = 13;
        ["sublevel"] = 3;
        ["teeming"] = true;
      };
    };
  };
  [10] = {
    ["name"] = "Mechagon Mechanic";
    ["id"] = 144295;
    ["count"] = 4;
    ["health"] = 768495;
    ["scale"] = 1;
    ["displayId"] = 91171;
    ["creatureType"] = "Humanoid";
    ["level"] = 120;
    ["characteristics"] = {
      ["Polymorph"] = true;
      ["Stun"] = true;
    };
    ["spells"] = {
      [293729] = {
      };
      [293930] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 601.18387765416;
        ["y"] = -190.10916220199;
        ["g"] = 12;
        ["sublevel"] = 3;
      };
      [2] = {
        ["x"] = 291.76409208577;
        ["y"] = -295.46130024962;
        ["g"] = 14;
        ["sublevel"] = 3;
      };
      [3] = {
        ["x"] = 293.16840262958;
        ["y"] = -305.11581470697;
        ["g"] = 14;
        ["sublevel"] = 3;
      };
    };
  };
  [11] = {
    ["name"] = "Head Machinist Sparkflux";
    ["id"] = 144248;
    ["count"] = 0;
    ["health"] = 5379465;
    ["scale"] = 1;
    ["displayId"] = 23397;
    ["creatureType"] = "Mechanical";
    ["level"] = 122;
    ["isBoss"] = true;
    ["encounterID"] = 2348;
    ["instanceID"] = 1178;
    ["spells"] = {
      [285440] = {
      };
      [285454] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 549.93643742759;
        ["y"] = -270.03016453617;
        ["sublevel"] = 3;
      };
    };
  };
  [12] = {
    ["name"] = "Spider Tank";
    ["id"] = 144296;
    ["count"] = 5;
    ["health"] = 1229592;
    ["scale"] = 1;
    ["displayId"] = 90710;
    ["creatureType"] = "Mechanical";
    ["level"] = 121;
    ["spells"] = {
      [293986] = {
      };
      [294015] = {
      };
      [296348] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 501.59536419878;
        ["y"] = -236.41429530968;
        ["sublevel"] = 3;
      };
      [2] = {
        ["x"] = 440.44634915076;
        ["y"] = -187.966455098;
        ["sublevel"] = 3;
      };
      [3] = {
        ["x"] = 471.93328013387;
        ["y"] = -214.30605838935;
        ["sublevel"] = 3;
        ["teeming"] = true;
      };
    };
  };
  [13] = {
    ["name"] = "Defense Bot Mk III";
    ["id"] = 144298;
    ["count"] = 8;
    ["health"] = 1229592;
    ["scale"] = 1;
    ["stealthDetect"] = true;
    ["displayId"] = 90855;
    ["creatureType"] = "Mechanical";
    ["level"] = 121;
    ["spells"] = {
      [294195] = {
      };
      [297127] = {
      };
      [297128] = {
      };
      [297133] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 429.94298772705;
        ["y"] = -441.33086427245;
        ["g"] = 10;
        ["sublevel"] = 3;
      };
      [2] = {
        ["x"] = 297.90466440177;
        ["y"] = -406.72989326751;
        ["sublevel"] = 3;
        ["patrol"] = {
          [1] = {
            ["x"] = 297.90466440177;
            ["y"] = -406.72989326751;
          };
          [2] = {
            ["x"] = 286.26100243489;
            ["y"] = -431.93310938028;
          };
          [3] = {
            ["x"] = 297.90466440177;
            ["y"] = -406.72989326751;
          };
          [4] = {
            ["x"] = 300.04098072629;
            ["y"] = -378.90164926768;
          };
          [5] = {
            ["x"] = 300.90360986371;
            ["y"] = -357.04902805453;
          };
          [6] = {
            ["x"] = 297.50283730687;
            ["y"] = -327.18854897621;
          };
          [7] = {
            ["x"] = 300.90360986371;
            ["y"] = -357.04902805453;
          };
          [8] = {
            ["x"] = 300.04098072629;
            ["y"] = -378.90164926768;
          };
        };
      };
      [3] = {
        ["x"] = 313.27374351498;
        ["y"] = -364.25047627049;
        ["sublevel"] = 3;
        ["patrol"] = {
          [1] = {
            ["x"] = 313.27374351498;
            ["y"] = -364.25047627049;
          };
          [2] = {
            ["x"] = 313.40512735786;
            ["y"] = -347.28133549391;
          };
          [3] = {
            ["x"] = 311.03286477058;
            ["y"] = -325.60759964757;
          };
          [4] = {
            ["x"] = 313.40512735786;
            ["y"] = -347.28133549391;
          };
          [5] = {
            ["x"] = 313.27374351498;
            ["y"] = -364.25047627049;
          };
          [6] = {
            ["x"] = 310.17584582341;
            ["y"] = -394.79246970652;
          };
          [7] = {
            ["x"] = 296.44056787358;
            ["y"] = -440.70032748029;
          };
          [8] = {
            ["x"] = 310.17584582341;
            ["y"] = -394.79246970652;
          };
        };
      };
      [4] = {
        ["x"] = 281.84583501642;
        ["y"] = -291.74184239816;
        ["g"] = 14;
        ["sublevel"] = 3;
      };
      [5] = {
        ["x"] = 302.07848946789;
        ["y"] = -288.03820044584;
        ["g"] = 14;
        ["sublevel"] = 3;
      };
    };
  };
  [14] = {
    ["name"] = "Aerial Unit R-21/X";
    ["id"] = 150396;
    ["count"] = 0;
    ["health"] = 3688776;
    ["scale"] = 1;
    ["displayId"] = 90547;
    ["creatureType"] = "Mechanical";
    ["level"] = 122;
    ["isBoss"] = true;
    ["encounterID"] = 2331;
    ["instanceID"] = 1178;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [291613] = {
      };
      [291626] = {
      };
      [291865] = {
      };
      [291878] = {
      };
      [291928] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 179.1418279613;
        ["y"] = -362.16512816792;
        ["g"] = 15;
        ["sublevel"] = 3;
      };
    };
  };
  [15] = {
    ["name"] = "Junkyard D.0.G.";
    ["id"] = 151773;
    ["count"] = 4;
    ["health"] = 768495;
    ["scale"] = 1;
    ["displayId"] = 90511;
    ["creatureType"] = "Mechanical";
    ["level"] = 120;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [294107] = {
      };
      [294180] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 522.29246790592;
        ["y"] = -353.06278997051;
        ["g"] = 4;
        ["sublevel"] = 2;
      };
      [2] = {
        ["x"] = 538.95927907908;
        ["y"] = -282.52821719069;
        ["g"] = 7;
        ["sublevel"] = 2;
      };
      [3] = {
        ["x"] = 527.58760397305;
        ["y"] = -289.16189808614;
        ["g"] = 7;
        ["sublevel"] = 2;
        ["teeming"] = true;
      };
    };
  };
  [16] = {
    ["name"] = "Waste Processing Unit";
    ["id"] = 144293;
    ["count"] = 7;
    ["health"] = 1229592;
    ["scale"] = 1;
    ["displayId"] = 92177;
    ["creatureType"] = "Mechanical";
    ["level"] = 121;
    ["characteristics"] = {
      ["Taunt"] = true;
      ["Stun"] = true;
    };
    ["spells"] = {
      [294290] = {
      };
      [294291] = {
      };
      [294324] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 362.18281730758;
        ["y"] = -386.30433113779;
        ["sublevel"] = 2;
      };
      [2] = {
        ["x"] = 457.90817655344;
        ["y"] = -381.92194523713;
        ["sublevel"] = 2;
      };
      [3] = {
        ["x"] = 545.88667894292;
        ["y"] = -327.43196399115;
        ["g"] = 5;
        ["sublevel"] = 2;
      };
      [4] = {
        ["x"] = 564.88785899073;
        ["y"] = -330.35849621681;
        ["g"] = 5;
        ["sublevel"] = 2;
        ["teeming"] = true;
      };
    };
  };
  [17] = {
    ["name"] = "Living Waste";
    ["id"] = 144301;
    ["count"] = 1;
    ["health"] = 76850;
    ["scale"] = 1;
    ["displayId"] = 92217;
    ["creatureType"] = "Elemental";
    ["level"] = 120;
    ["spells"] = {
      [294349] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 476.58863517454;
        ["y"] = -373.14504241806;
        ["g"] = 3;
        ["sublevel"] = 2;
      };
      [2] = {
        ["x"] = 480.97216346021;
        ["y"] = -379.9856887912;
        ["g"] = 3;
        ["sublevel"] = 2;
      };
      [3] = {
        ["x"] = 483.44108508101;
        ["y"] = -366.64991773679;
        ["g"] = 3;
        ["sublevel"] = 2;
      };
      [4] = {
        ["x"] = 486.18292792546;
        ["y"] = -374.01261308778;
        ["g"] = 3;
        ["sublevel"] = 2;
      };
      [5] = {
        ["x"] = 489.23554166131;
        ["y"] = -379.5492887157;
        ["g"] = 3;
        ["sublevel"] = 2;
      };
      [6] = {
        ["x"] = 517.90296147965;
        ["y"] = -360.81253713167;
        ["g"] = 4;
        ["sublevel"] = 2;
      };
      [7] = {
        ["x"] = 523.00546261047;
        ["y"] = -366.8408980967;
        ["g"] = 4;
        ["sublevel"] = 2;
      };
      [8] = {
        ["x"] = 530.64769619118;
        ["y"] = -356.11194358718;
        ["g"] = 4;
        ["sublevel"] = 2;
      };
      [9] = {
        ["x"] = 531.25302333858;
        ["y"] = -364.20479692043;
        ["g"] = 4;
        ["sublevel"] = 2;
      };
      [10] = {
        ["x"] = 540.59579527792;
        ["y"] = -316.68566636406;
        ["g"] = 6;
        ["sublevel"] = 2;
      };
      [11] = {
        ["x"] = 548.88831485568;
        ["y"] = -314.14084231796;
        ["g"] = 6;
        ["sublevel"] = 2;
      };
      [12] = {
        ["x"] = 537.65021591515;
        ["y"] = -309.0844802683;
        ["g"] = 6;
        ["sublevel"] = 2;
      };
      [13] = {
        ["x"] = 544.44718769335;
        ["y"] = -304.98565488565;
        ["g"] = 6;
        ["sublevel"] = 2;
      };
      [14] = {
        ["x"] = 553.0311229253;
        ["y"] = -306.48814632018;
        ["g"] = 6;
        ["sublevel"] = 2;
      };
    };
  };
  [18] = {
    ["name"] = "Omega Buster";
    ["id"] = 144249;
    ["count"] = 0;
    ["health"] = 4610970;
    ["scale"] = 1;
    ["displayId"] = 90998;
    ["creatureType"] = "Mechanical";
    ["level"] = 122;
    ["isBoss"] = true;
    ["encounterID"] = 2331;
    ["instanceID"] = 1178;
    ["characteristics"] = {
      ["Taunt"] = true;
    };
    ["spells"] = {
      [283551] = {
      };
      [292264] = {
      };
      [292267] = {
      };
      [292290] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 151.30590992095;
        ["y"] = -383.11225682513;
        ["g"] = 15;
        ["sublevel"] = 3;
      };
    };
  };
  [19] = {
    ["name"] = "Bomb Tonk";
    ["id"] = 151657;
    ["count"] = 4;
    ["health"] = 302142;
    ["scale"] = 1.5;
    ["displayId"] = 21209;
    ["creatureType"] = "Mechanical";
    ["level"] = 120;
    ["spells"] = {
      [301088] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 269.53200910371;
        ["y"] = -374.2151489309;
        ["g"] = 1;
        ["sublevel"] = 1;
      };
      [2] = {
        ["x"] = 259.27553305712;
        ["y"] = -354.32391026756;
        ["g"] = 1;
        ["sublevel"] = 1;
      };
    };
  };
  [20] = {
    ["name"] = "Rocket Tonk";
    ["id"] = 151659;
    ["count"] = 4;
    ["health"] = 503570;
    ["scale"] = 1.5;
    ["displayId"] = 91228;
    ["creatureType"] = "Mechanical";
    ["level"] = 120;
    ["spells"] = {
      [294103] = {
      };
      [294128] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 230.69550162853;
        ["y"] = -367.61262040707;
        ["g"] = 1;
        ["sublevel"] = 1;
      };
      [2] = {
        ["x"] = 239.63705516806;
        ["y"] = -389.70524704043;
        ["g"] = 1;
        ["sublevel"] = 1;
      };
    };
  };
  [21] = {
    ["name"] = "Strider Tonk";
    ["id"] = 151658;
    ["count"] = 4;
    ["health"] = 503570;
    ["scale"] = 1.5;
    ["displayId"] = 91229;
    ["creatureType"] = "Mechanical";
    ["level"] = 120;
    ["spells"] = {
      [294061] = {
      };
      [294064] = {
      };
      [294073] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 237.23806882906;
        ["y"] = -345.90929412611;
        ["g"] = 1;
        ["sublevel"] = 1;
      };
      [2] = {
        ["x"] = 261.35754205452;
        ["y"] = -396.32696201739;
        ["g"] = 1;
        ["sublevel"] = 1;
      };
    };
  };
  [22] = {
    ["name"] = "The Platinum Pummeler";
    ["id"] = 144244;
    ["count"] = 0;
    ["health"] = 2014280;
    ["scale"] = 1.5;
    ["displayId"] = 91216;
    ["creatureType"] = "Mechanical";
    ["level"] = 122;
    ["isBoss"] = true;
    ["encounterID"] = 2336;
    ["instanceID"] = 1178;
    ["spells"] = {
      [282801] = {
      };
      [285020] = {
      };
      [285344] = {
      };
      [285377] = {
      };
      [305393] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 213.62890398115;
        ["y"] = -417.41680355738;
        ["g"] = 2;
        ["sublevel"] = 1;
      };
    };
  };
  [23] = {
    ["name"] = "Gnomercy 4.U.";
    ["id"] = 145185;
    ["count"] = 0;
    ["health"] = 2014280;
    ["scale"] = 1.5;
    ["displayId"] = 91879;
    ["creatureType"] = "Mechanical";
    ["level"] = 122;
    ["isBoss"] = true;
    ["encounterID"] = 2336;
    ["instanceID"] = 1178;
    ["spells"] = {
      [283421] = {
      };
      [283422] = {
      };
      [283565] = {
      };
      [283640] = {
      };
      [285152] = {
      };
      [285388] = {
      };
      [285468] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 195.09111527009;
        ["y"] = -368.75253591347;
        ["g"] = 2;
        ["sublevel"] = 1;
      };
    };
  };
  [24] = {
    ["name"] = "K.U.-J.0.";
    ["id"] = 144246;
    ["count"] = 0;
    ["health"] = 4918368;
    ["scale"] = 1;
    ["displayId"] = 90775;
    ["creatureType"] = "Mechanical";
    ["level"] = 122;
    ["isBoss"] = true;
    ["encounterID"] = 2339;
    ["instanceID"] = 1178;
    ["spells"] = {
      [291922] = {
      };
      [291946] = {
      };
      [291949] = {
      };
      [291972] = {
      };
      [291973] = {
      };
      [292035] = {
      };
      [294929] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 420.53647095542;
        ["y"] = -238.70347446204;
        ["sublevel"] = 2;
      };
    };
  };
  [25] = {
    ["name"] = "Alarm-o-Bot";
    ["id"] = 151325;
    ["count"] = 0;
    ["health"] = 38425;
    ["scale"] = 1;
    ["displayId"] = 90874;
    ["creatureType"] = "Mechanical";
    ["level"] = 120;
    ["clones"] = {
      [1] = {
        ["x"] = 477.5225723606;
        ["y"] = -421.83846267556;
        ["g"] = 8;
        ["sublevel"] = 3;
      };
    };
  };
  [26] = {
    ["name"] = "G.U.A.R.D.";
    ["id"] = 144303;
    ["count"] = 4;
    ["health"] = 768495;
    ["scale"] = 1;
    ["displayId"] = 68856;
    ["creatureType"] = "Mechanical";
    ["level"] = 120;
    ["characteristics"] = {
      ["Stun"] = true;
    };
    ["spells"] = {
      [294107] = {
      };
    };
    ["clones"] = {
      [1] = {
        ["x"] = 466.40975979746;
        ["y"] = -410.07293451348;
        ["g"] = 9;
        ["sublevel"] = 3;
      };
      [2] = {
        ["x"] = 459.82529834771;
        ["y"] = -424.54963316643;
        ["g"] = 9;
        ["sublevel"] = 3;
      };
    };
  };
};
