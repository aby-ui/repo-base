
    local Details = _G.Details
    local detailsFramework = _G.DetailsFramework
	local openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0", true)
	local addonName, Details222 = ...

	--wrap warcraftlogs addon api
	Details222.WarcraftLogs = {} --namespace

    function Details222.WarcraftLogs.GetAddon()
        local WCLAddonName = "WarcraftLogs"
        local WarcraftLogs = _G[WCLAddonName]
        return WarcraftLogs
    end

    function Details222.WarcraftLogs.GetParseColor(percent)
        if (percent == 100) then
            return "moccasin"

        elseif (percent >= 91) then
            return "palevioletred"

        elseif (percent >= 70) then
            return "blueviolet"

        elseif (percent >= 50) then
            return "SHAMAN"

        elseif (percent >= 30) then
            return "lime"

        else
            return "gray"
        end
    end

	function Details222.WarcraftLogs.GetPlayerProfile(actorObject)
		local playerName, playerRealm = actorObject:Name():match("(%w+)%-(%w+)")

		local WarcraftLogs = Details222.WarcraftLogs.GetAddon()
		if (WarcraftLogs) then
			playerName = playerName or actorObject:Name()
			playerRealm = playerRealm or GetRealmName()

			local factionName = actorObject.enemy and Details.faction_against or UnitFactionGroup("player")
			local factionId = factionName == "Horde" and 2 or 1

            local playerProfile

            --~rename or change function call
            if (WarcraftLogs.GetProfile) then
			    playerProfile = WarcraftLogs.GetProfile(playerName, playerRealm, factionId)
            end

            return playerProfile or {}
        else
            return {}
		end
	end

    --details wrap
    function Details222.WarcraftLogs.GetClassPercentileFromBossProfile(bossProfile)
        --pipeline to return a table with information about the damage percentiles of all classes of an encounter
        --~rename or change function call
        return bossProfile.ClassPercentile or {} --wrapped
    end

    --details wrap
    function Details222.WarcraftLogs.GetEncounterProfile(cleuBossId, difficultyId)
        --pipeline to return a table with an encounter data
        local WarcraftLogs = Details222.WarcraftLogs.GetAddon()
        if (WarcraftLogs) then
            --~rename or change function call
            if (WarcraftLogs.GetEncounterProfile) then
                return WarcraftLogs.GetEncounterProfile(cleuBossId, difficultyId) or {} --wrapped
            else
                return {}
            end
        else
            return {}
        end
    end

    --details wrap
    function Details222.WarcraftLogs.GetClassPercentileForEncounterID(cleuBossId, difficultyId, classId)
        --pipeline: return a table with class damage percentile, this table need to have sub tables with specs
        local bossProfile = Details222.WarcraftLogs.GetEncounterProfile(cleuBossId, difficultyId) --wrapped
        if (bossProfile) then
            local classesPercentile = Details222.WarcraftLogs.GetClassPercentileFromBossProfile(bossProfile) --wrapped
            if (classesPercentile) then
                return classesPercentile or {}
            else
                return {}
            end
        end

        return {}
    end

    --detais wrap
	function Details222.WarcraftLogs.GetSpecPercentileFromClassPercentile(classPercentile, specId)
        --pipeline: get a table with percentile damage information of a SPEC, this table should have {min = minDamage, max = maxDamage}
        local percentileTable = classPercentile[specId]
        local resultTable = {}
        if (percentileTable) then
            --~rename or change function call
            local minDamage = percentileTable["MinDamage"]
            local maxDamage = percentileTable["MaxDamage"]
            resultTable = {min = minDamage, max = maxDamage}
        end
        return resultTable or {min = 0, max = 1}
	end

    --details wrap
    function Details222.WarcraftLogs.GetDamageParsePercent(encounterId, difficultyId, specId, amount)
        local classId = LIB_OPEN_RAID_SPECID_TO_CLASSID and LIB_OPEN_RAID_SPECID_TO_CLASSID[specId]
        local classPercentileTable = Details222.WarcraftLogs.GetClassPercentileForEncounterID(encounterId, difficultyId, classId) --wrapped

        local specPercentile = classPercentileTable[specId]
        if (specPercentile) then
            local minDamage = specPercentile.min
            local maxDamage = specPercentile.max

            local percentScalar = detailsFramework:MapRangeClamped(minDamage, maxDamage, 0, 100, amount)
            return percentScalar
        else
            return nil
        end
    end

    --namespace
    Details222.ParsePercent = {}

    function Details222.ParsePercent.GetPercent(attribute, difficultyId, encounterId, specId, amount)
        --query warcraftlogs addon
        if (attribute == DETAILS_ATTRIBUTE_DAMAGE) then
            local percent = Details222.WarcraftLogs.GetDamageParsePercent(encounterId, difficultyId, specId, amount)
            if (not percent) then
                local data = Details222.ParsePercent.Data.Damage
                local difficultyData = data[difficultyId]
                if (difficultyData) then
                    local encounterData = difficultyData[encounterId]
                    if (encounterData) then
                        local parsePercentForSpec = encounterData[specId]
                        if (parsePercentForSpec) then
                            local minDamage = parsePercentForSpec.min
                            local maxDamage = parsePercentForSpec.max
                            local percentScalar = detailsFramework:MapRangeClamped(minDamage, maxDamage, 0, 100, amount)
                            return percentScalar
                        end
                    end
                end
            end
        end
    end

    --all data below are from warcraftlogs.com
    Details222.ParsePercent.Data = {}
    Details222.ParsePercent.Data.Damage = {
        [16] = { --mythic
            [2549] = {
                encounterName = "Rygelon",
                difficultyId = 16,
                encounterId = 2549,
                [256] = {min = 1626, max = 7425},       [65] = {min = 306, max = 12589},        [66] = {min = 1422, max = 24248},       [259] = {min = 16245, max = 33852},     [260] = {min = 63, max = 46266},                                                       [581] = {min = 4083, max = 25071},       [262] = {min = 7184, max = 38595},      [263] = {min = 5742, max = 41418},      [72] = {min = 237, max = 46719},        [265] = {min = 3895, max = 80390},                                                             [266] = {min = 5298, max = 42644},       [267] = {min = 75, max = 60883},        [268] = {min = 4776, max = 26091},      [269] = {min = 5532, max = 44171},      [270] = {min = 1029, max = 10306},                                                             [102] = {min = 48, max = 69128}, [103] = {min = 12, max = 34808},        [104] = {min = 8649, max = 57866},      [105] = {min = 111, max = 5676},        [1468] = {min = 0, max = 9055}, [257] = {min = 0, max = 13921},                                        [264] = {min = 0, max = 13998},  [258] = {min = 0, max = 37454}, [577] = {min = 4, max = 50291}, [70] = {min = 9, max = 39581},  [255] = {min = 19545, max = 35969},     [62] = {min = 9015, max = 58220},                                                      [64] = {min = 238, max = 39381}, [73] = {min = 5606, max = 21926},       [251] = {min = 5159, max = 45765},      [71] = {min = 3177, max = 42030},       [261] = {min = 17589, max = 35743}, [250] = {min = 5052, max = 29744},                                 [1467] = {min = 21, max = 53874},        [252] = {min = 42, max = 55027},        [253] = {min = 131, max = 56301},       [254] = {min = 7216, max = 25786},      [63] = {min = 3080, max = 44934},
            },

            [2542] = {
                encounterName = "Skolex, the Insatiable Ravener",
                difficultyId = 16,
                encounterId = 2542,
                [256] = {min = 1660, max = 8282},       [577] = {min = 949, max = 66929},       [258] = {min = 6726, max = 58808},      [259] = {min = 11187, max = 43587},     [260] = {min = 0, max = 64508},                                                        [581] = {min = 3985, max = 32690},       [262] = {min = 7548, max = 70129},      [263] = {min = 2443, max = 56677},      [264] = {min = 0, max = 29608}, [265] = {min = 5349, max = 119245}, [266] = {min = 8728, max = 81211},                                 [267] = {min = 0, max = 60711},  [268] = {min = 4051, max = 38896},      [269] = {min = 374, max = 72983},       [270] = {min = 144, max = 17106},       [102] = {min = 40, max = 108134},   [103] = {min = 0, max = 43682},                                    [104] = {min = 3119, max = 74814},       [105] = {min = 6, max = 12923}, [65] = {min = 0, max = 21372},  [1468] = {min = 0, max = 9218}, [71] = {min = 0, max = 61207},  [257] = {min = 0, max = 11007},                                                        [255] = {min = 10013, max = 48432},      [254] = {min = 8829, max = 36167},      [72] = {min = 132, max = 77011},        [70] = {min = 324, max = 72764},        [1467] = {min = 476, max = 66210},                                                             [73] = {min = 4923, max = 28826},        [66] = {min = 59, max = 32459}, [64] = {min = 9, max = 65568},  [261] = {min = 13385, max = 42379},     [250] = {min = 581, max = 41322},       [251] = {min = 237, max = 62833},                                      [252] = {min = 336, max = 84710},        [253] = {min = 3080, max = 96027},      [62] = {min = 1572, max = 56735},       [63] = {min = 5530, max = 58773},
            },

            [2539] = {
                encounterName = "Lihuvim, Principal Architect",
                difficultyId = 16,
                encounterId = 2539,
                [256] = {min = 3011, max = 7868},       [577] = {min = 1132, max = 72054},      [66] = {min = 5123, max = 26117},       [259] = {min = 14790, max = 51766},     [260] = {min = 1190, max = 59834},                                                     [581] = {min = 6246, max = 29596},       [262] = {min = 12650, max = 75350},     [263] = {min = 11347, max = 50277},     [72] = {min = 4641, max = 65615},       [265] = {min = 8015, max = 169882},                                                            [266] = {min = 11103, max = 79833},      [267] = {min = 0, max = 52499}, [268] = {min = 6084, max = 40329},      [269] = {min = 13185, max = 69375},     [270] = {min = 618, max = 19657},   [102] = {min = 54, max = 109717},                                  [103] = {min = 12387, max = 48102},      [104] = {min = 8444, max = 71747},      [105] = {min = 0, max = 11354}, [70] = {min = 0, max = 67326},  [257] = {min = 80, max = 8273}, [1468] = {min = 0, max = 9596},                                                [264] = {min = 0, max = 25636},  [63] = {min = 6489, max = 63280},       [62] = {min = 10213, max = 62808},      [261] = {min = 8793, max = 35809},      [71] = {min = 257, max = 51415},    [251] = {min = 5799, max = 55044},                                 [258] = {min = 3482, max = 55788},       [64] = {min = 24, max = 61930}, [73] = {min = 5770, max = 33081},       [65] = {min = 31, max = 12068}, [250] = {min = 3839, max = 41956},      [1467] = {min = 1258, max = 98542},                                    [252] = {min = 24, max = 80672}, [253] = {min = 0, max = 111086},        [254] = {min = 12780, max = 34447},     [255] = {min = 25418, max = 38668},
            },

            [2529] = {
                encounterName = "Halondrus the Reclaimer",
                difficultyId = 16,
                encounterId = 2529,
                [64] = {min = 5056, max = 28896},       [577] = {min = 7093, max = 45045},      [258] = {min = 9106, max = 30073},      [259] = {min = 16679, max = 36056},     [260] = {min = 407, max = 45629},                                                      [261] = {min = 17450, max = 29193},      [262] = {min = 11546, max = 31585},     [71] = {min = 2645, max = 37612},       [72] = {min = 3784, max = 41779},       [265] = {min = 7701, max = 41880},                                                             [266] = {min = 6232, max = 38614},       [267] = {min = 9089, max = 33653},      [268] = {min = 4061, max = 20363},      [269] = {min = 7826, max = 36996},      [270] = {min = 429, max = 12408},                                                              [102] = {min = 68, max = 68528}, [103] = {min = 14432, max = 34306},     [104] = {min = 6736, max = 52497},      [105] = {min = 0, max = 10141}, [1468] = {min = 0, max = 4893}, [257] = {min = 0, max = 9311},                                                 [70] = {min = 19, max = 40946},  [264] = {min = 65, max = 13698},        [255] = {min = 28135, max = 30662},     [254] = {min = 15813, max = 19925},     [65] = {min = 1405, max = 14512},   [256] = {min = 2245, max = 5362},                                  [251] = {min = 7892, max = 41885},       [73] = {min = 730, max = 20118},        [263] = {min = 11272, max = 35673},     [66] = {min = 5231, max = 13732},       [581] = {min = 4605, max = 22964},                                                             [250] = {min = 5940, max = 24676},       [1467] = {min = 3570, max = 32861},     [252] = {min = 6175, max = 59998},      [253] = {min = 5431, max = 51637},      [62] = {min = 860, max = 31660},                                                               [63] = {min = 2585, max = 32445},
            },

            [2537] = {
                encounterName = "The Jailer",
                difficultyId = 16,
                encounterId = 2537,
                [64] = {min = 163, max = 66605},        [65] = {min = 23, max = 16095}, [258] = {min = 33, max = 65322},        [259] = {min = 0, max = 61954}, [260] = {min = 4, max = 68358}, [261] = {min = 10, max = 63011},                                       [262] = {min = 24, max = 71824}, [71] = {min = 23, max = 68116}, [72] = {min = 0, max = 81676},  [73] = {min = 36, max = 34610}, [266] = {min = 10, max = 73962},        [267] = {min = 5, max = 70493},                                                        [268] = {min = 578, max = 42536},        [269] = {min = 0, max = 86592}, [270] = {min = 6, max = 17608}, [102] = {min = 0, max = 120056},        [103] = {min = 2, max = 52493}, [104] = {min = 63, max = 90099},                                               [105] = {min = 0, max = 8947},   [70] = {min = 0, max = 81460},  [577] = {min = 4, max = 85436}, [1468] = {min = 0, max = 12279},        [255] = {min = 2933, max = 47242},      [254] = {min = 54, max = 58569},                                               [265] = {min = 121, max = 154457},       [66] = {min = 5, max = 32383},  [251] = {min = 23, max = 80501},        [581] = {min = 9, max = 39238}, [264] = {min = 0, max = 18841}, [257] = {min = 0, max = 19892},                                                [263] = {min = 56, max = 65007}, [256] = {min = 55, max = 10584},        [250] = {min = 54, max = 58082},        [1467] = {min = 7, max = 72426},        [252] = {min = 17, max = 92259},    [253] = {min = 0, max = 130009},                                   [62] = {min = 317, max = 77104}, [63] = {min = 140, max = 82191},
            },

            [2540] = {
                encounterName = "Dausegne, the Fallen Oracle",
                difficultyId = 16,
                encounterId = 2540,
                [256] = {min = 2261, max = 8920},       [577] = {min = 229, max = 84685},       [258] = {min = 8129, max = 62342},      [259] = {min = 1836, max = 53743},      [260] = {min = 15, max = 67308},                                                       [581] = {min = 4489, max = 41766},       [262] = {min = 2376, max = 70828},      [263] = {min = 3814, max = 57779},      [264] = {min = 0, max = 31010}, [265] = {min = 6330, max = 205013}, [266] = {min = 9207, max = 120339},                                [267] = {min = 0, max = 60703},  [268] = {min = 4450, max = 46429},      [269] = {min = 0, max = 83255}, [270] = {min = 131, max = 21087},       [102] = {min = 107, max = 136214},      [103] = {min = 1950, max = 52186},                                     [104] = {min = 5489, max = 100541},      [105] = {min = 118, max = 12519},       [64] = {min = 0, max = 79918},  [254] = {min = 0, max = 37574}, [1468] = {min = 0, max = 12974},        [257] = {min = 0, max = 10371},                                        [255] = {min = 18456, max = 42526},      [65] = {min = 104, max = 22834},        [66] = {min = 5604, max = 32507},       [72] = {min = 642, max = 66439},        [251] = {min = 2733, max = 74272},                                                             [73] = {min = 974, max = 34317}, [261] = {min = 16576, max = 49824},     [70] = {min = 1560, max = 71870},       [71] = {min = 1291, max = 61619},       [250] = {min = 4413, max = 46804},  [1467] = {min = 88, max = 90726},                                  [252] = {min = 921, max = 86261},        [253] = {min = 152, max = 122104},      [62] = {min = 7768, max = 67170},       [63] = {min = 128, max = 81629},
            },

            [2544] = {
                encounterName = "Prototype Pantheon",
                difficultyId = 16,
                encounterId = 2544,
                [256] = {min = 1467, max = 8575},       [577] = {min = 11087, max = 74432},     [258] = {min = 9355, max = 70028},      [259] = {min = 16258, max = 51420},     [260] = {min = 3085, max = 67981},                                                     [581] = {min = 9326, max = 46505},       [70] = {min = 7208, max = 85924},       [263] = {min = 13278, max = 68027},     [72] = {min = 4743, max = 79646},       [73] = {min = 8697, max = 37977},                                                              [266] = {min = 20877, max = 124897},     [267] = {min = 0, max = 63397}, [268] = {min = 10094, max = 57005},     [269] = {min = 120, max = 96070},       [270] = {min = 470, max = 23504},   [102] = {min = 104, max = 111666},                                 [103] = {min = 663, max = 64002},        [104] = {min = 9424, max = 100330},     [105] = {min = 0, max = 14378}, [1468] = {min = 0, max = 12555},        [1467] = {min = 0, max = 99448},    [257] = {min = 0, max = 13864},                                    [264] = {min = 0, max = 29500},  [255] = {min = 22870, max = 47224},     [254] = {min = 10349, max = 52557},     [64] = {min = 7, max = 105331}, [65] = {min = 494, max = 18457},        [262] = {min = 36, max = 79752},                                       [265] = {min = 15967, max = 193747},     [66] = {min = 6774, max = 31577},       [261] = {min = 23728, max = 45070},     [71] = {min = 2872, max = 59317},       [250] = {min = 9976, max = 53933},                                                             [251] = {min = 14052, max = 75024},      [252] = {min = 5681, max = 103977},     [253] = {min = 2542, max = 112982},     [62] = {min = 1469, max = 66056},       [63] = {min = 254, max = 75081},
            },

            [2543] = {
                encounterName = "Lords of Dread",
                difficultyId = 16,
                encounterId = 2543,
                [64] = {min = 2502, max = 114225},      [65] = {min = 253, max = 22346},        [258] = {min = 294, max = 96439},       [259] = {min = 17327, max = 59147},     [260] = {min = 0, max = 84630},                                                        [581] = {min = 14713, max = 54438},      [262] = {min = 6559, max = 81248},      [263] = {min = 11038, max = 114766},    [72] = {min = 31, max = 96836}, [265] = {min = 3005, max = 215712}, [266] = {min = 1860, max = 110359},                                [267] = {min = 5794, max = 121131},      [268] = {min = 49, max = 67378},        [269] = {min = 1552, max = 113755},     [270] = {min = 29, max = 22652},        [102] = {min = 0, max = 236482},                                                               [103] = {min = 10628, max = 92694},      [104] = {min = 18723, max = 123898},    [105] = {min = 0, max = 14228}, [1468] = {min = 0, max = 11523},        [1467] = {min = 0, max = 116256},   [257] = {min = 0, max = 26046},                                    [264] = {min = 0, max = 30717},  [255] = {min = 3833, max = 58314},      [62] = {min = 2927, max = 118934},      [66] = {min = 46, max = 68190}, [577] = {min = 61, max = 96590},        [73] = {min = 7063, max = 42825},                                      [256] = {min = 1860, max = 16383},       [70] = {min = 28, max = 119230},        [261] = {min = 9, max = 63535}, [71] = {min = 2156, max = 123888},      [250] = {min = 4323, max = 87139},  [251] = {min = 3137, max = 98430},                                 [252] = {min = 47, max = 130374},        [253] = {min = 208, max = 129046},      [254] = {min = 10531, max = 62653},     [63] = {min = 5331, max = 112939},
            },

            [2512] = {
                encounterName = "Vigilant Guardian",
                difficultyId = 16,
                encounterId = 2512,
                [256] = {min = 1627, max = 15396},      [65] = {min = 0, max = 22817},  [66] = {min = 5194, max = 43170},       [259] = {min = 16363, max = 51786},     [260] = {min = 8973, max = 81427},                                                             [581] = {min = 7366, max = 42701},       [262] = {min = 2758, max = 76725},      [263] = {min = 10530, max = 70638},     [72] = {min = 0, max = 94150},  [73] = {min = 4713, max = 44133},   [266] = {min = 12508, max = 92878},                                [267] = {min = 0, max = 73103},  [268] = {min = 6520, max = 48122},      [269] = {min = 0, max = 96037}, [270] = {min = 95, max = 15823},        [102] = {min = 0, max = 128755},        [103] = {min = 6927, max = 59516},                                     [104] = {min = 85, max = 79825}, [105] = {min = 115, max = 11237},       [70] = {min = 0, max = 82011},  [64] = {min = 0, max = 76943},  [63] = {min = 0, max = 86800},  [577] = {min = 0, max = 80000},                                                        [258] = {min = 3042, max = 78984},       [254] = {min = 1293, max = 57475},      [261] = {min = 11056, max = 51154},     [1468] = {min = 0, max = 16683},        [1467] = {min = 304, max = 102275},                                                            [71] = {min = 0, max = 83289},   [265] = {min = 1240, max = 135593},     [264] = {min = 0, max = 25232}, [257] = {min = 0, max = 25197}, [250] = {min = 4421, max = 59154},      [251] = {min = 0, max = 82985},                                                [252] = {min = 0, max = 95127},  [253] = {min = 0, max = 118264},        [62] = {min = 0, max = 91924},  [255] = {min = 14206, max = 47431},
            },

            [2553] = {
                encounterName = "Artificer Xy'mox",
                difficultyId = 16,
                encounterId = 2553,
                [256] = {min = 797, max = 7404},        [577] = {min = 4, max = 51659}, [66] = {min = 3005, max = 23645},       [259] = {min = 18438, max = 37961},     [260] = {min = 3475, max = 52019},                                                             [581] = {min = 6136, max = 25313},       [262] = {min = 22, max = 62229},        [263] = {min = 5129, max = 42172},      [72] = {min = 2096, max = 48641},       [73] = {min = 3076, max = 22067},                                                              [266] = {min = 7938, max = 70181},       [267] = {min = 61, max = 45052},        [268] = {min = 5924, max = 34167},      [269] = {min = 13, max = 57008},        [270] = {min = 498, max = 14915},                                                              [102] = {min = 55, max = 82505}, [103] = {min = 5437, max = 38185},      [104] = {min = 6453, max = 51754},      [105] = {min = 107, max = 10952},       [1468] = {min = 0, max = 8374}, [257] = {min = 0, max = 9080},                                         [264] = {min = 0, max = 21505},  [65] = {min = 3, max = 13631},  [64] = {min = 5, max = 63392},  [255] = {min = 6707, max = 33658},      [254] = {min = 3043, max = 40855},      [70] = {min = 24, max = 47404},                                                [265] = {min = 3685, max = 111394},      [251] = {min = 1774, max = 50182},      [71] = {min = 635, max = 40356},        [258] = {min = 7282, max = 41833},      [261] = {min = 17678, max = 37062},                                                            [250] = {min = 154, max = 36124},        [1467] = {min = 488, max = 52310},      [252] = {min = 44, max = 61758},        [253] = {min = 108, max = 58369},       [62] = {min = 9490, max = 48616},                                                              [63] = {min = 124, max = 53016},
            },

            [2546] = {
                encounterName = "Anduin Wrynn",
                difficultyId = 16,
                encounterId = 2546,
                [64] = {min = 13310, max = 100905},     [65] = {min = 866, max = 19784},        [66] = {min = 16093, max = 67052},      [259] = {min = 33340, max = 76875},     [260] = {min = 40, max = 99983},                                                       [261] = {min = 35761, max = 80096},      [262] = {min = 26788, max = 102392},    [71] = {min = 6257, max = 109950},      [264] = {min = 0, max = 42249}, [73] = {min = 11010, max = 60141},  [266] = {min = 11305, max = 89744},                                [267] = {min = 15, max = 87282}, [268] = {min = 8572, max = 62243},      [269] = {min = 12256, max = 115165},    [270] = {min = 557, max = 30189},       [102] = {min = 47, max = 149146},   [103] = {min = 14220, max = 100089},                               [104] = {min = 21840, max = 101125},     [105] = {min = 41, max = 23435},        [1468] = {min = 0, max = 20941},        [72] = {min = 0, max = 111321}, [257] = {min = 0, max = 31938}, [581] = {min = 14889, max = 54920},                                    [255] = {min = 36161, max = 73728},      [254] = {min = 34837, max = 98306},     [577] = {min = 366, max = 167035},      [258] = {min = 41, max = 82571},        [251] = {min = 17323, max = 103732},                                                           [256] = {min = 1417, max = 14445},       [263] = {min = 6894, max = 104238},     [265] = {min = 26994, max = 177927},    [70] = {min = 18, max = 118124},        [250] = {min = 4747, max = 83442},                                                             [1467] = {min = 129, max = 120937},      [252] = {min = 16, max = 120978},       [253] = {min = 996, max = 163203},      [62] = {min = 21848, max = 122162},     [63] = {min = 3081, max = 132784},
            },
        },

        [15] = { --17 to test on raid finder
        [2537] = {
                    encounterName = "The Jailer",
                    difficultyId = 15,
                    encounterId = 2537,
                    [256] = {min = 15, max = 8959}, [257] = {min = 0, max = 13934}, [258] = {min = 0, max = 65252}, [259] = {min = 0, max = 58866}, [260] = {min = 0, max = 63798}, [261] = {min = 0, max = 44350},      [262] = {min = 0, max = 64091}, [71] = {min = 0, max = 62485},  [264] = {min = 0, max = 14565}, [265] = {min = 0, max = 139087},        [266] = {min = 0, max = 76676}, [267] = {min = 0, max = 54435},      [268] = {min = 0, max = 37138}, [269] = {min = 0, max = 69644}, [270] = {min = 0, max = 14470}, [102] = {min = 0, max = 99872}, [103] = {min = 3, max = 47215},      [104] = {min = 0, max = 69376}, [105] = {min = 0, max = 8394},  [70] = {min = 0, max = 83930},  [65] = {min = 0, max = 15871},  [64] = {min = 0, max = 65529},  [63] = {min = 0, max 
            = 82999},       [577] = {min = 0, max = 67002}, [62] = {min = 0, max = 68100},  [66] = {min = 0, max = 33886},  [1468] = {min = 0, max = 11867},        [1467] = {min = 0, max = 57933},    [263] = {min = 0, max = 61092},  [581] = {min = 0, max = 42647}, [73] = {min = 0, max = 23625},  [72] = {min = 0, max = 64040},  [250] = {min = 0, max = 35509}, [251] = {min = 0, max = 67179},      [252] = {min = 0, max = 88558}, [253] = {min = 0, max = 111049},        [254] = {min = 0, max = 36079}, [255] = {min = 0, max = 36569},
            },

            [2549] = {
                encounterName = "Rygelon",
                difficultyId = 15,
                encounterId = 2549,
                [256] = {min = 30, max = 9670}, [257] = {min = 0, max = 15147}, [258] = {min = 9, max = 47884}, [259] = {min = 8, max = 38848}, [260] = {min = 0, max = 53192}, [261] = {min = 9, max = 35739},      [262] = {min = 0, max = 47231}, [263] = {min = 0, max = 47665}, [264] = {min = 0, max = 13195}, [265] = {min = 54, max = 98712},        [266] = {min = 0, max = 43400}, [267] = {min = 0, max = 44086},      [268] = {min = 47, max = 31473},        [269] = {min = 0, max = 44870}, [270] = {min = 0, max = 12388}, [102] = {min = 0, max = 65153}, [103] = {min = 7, max = 37474},      [104] = {min = 0, max = 63012}, [105] = {min = 0, max = 10755}, [70] = {min = 0, max = 49585},  [66] = {min = 0, max = 24391},  [65] = {min = 0, max = 15135},  [64] = {min = 0, max = 36869},       [255] = {min = 103, max = 26606},       [62] = {min = 43, max = 58110}, [71] = {min = 0, max = 46517},  [252] = {min = 5, max = 60052}, [1467] = {min = 0, max = 37942},     [581] = {min = 0, max = 35291}, [72] = {min = 0, max = 49275},  [73] = {min = 0, max = 19236},  [577] = {min = 0, max = 45108}, [250] = {min = 3, max = 28547}, [251] = {min = 0, max = 51155},      [1468] = {min = 0, max = 9578}, [253] = {min = 0, max = 60657}, [254] = {min = 0, max = 27647}, [63] = {min = 0, max = 52600},
        },

            [2512] = {
                encounterName = "Vigilant Guardian",
                difficultyId = 15,
                encounterId = 2512,
                [64] = {min = 0, max = 47744},  [257] = {min = 0, max = 9018},  [258] = {min = 0, max = 41701}, [259] = {min = 0, max = 38397}, [260] = {min = 0, max = 47671}, [261] = {min = 4, max = 24293},      [262] = {min = 18, max = 43486},        [71] = {min = 17, max = 44877}, [264] = {min = 0, max = 12857}, [73] = {min = 0, max = 18670},  [266] = {min = 0, max = 44779}, [267] = {min = 0, max = 38536},      [268] = {min = 2008, max = 32757},      [269] = {min = 0, max = 67971}, [270] = {min = 0, max = 11710}, [102] = {min = 0, max = 66199}, [103] = {min = 0, max = 32670},      [104] = {min = 0, max = 49388}, [105] = {min = 0, max = 5641},  [256] = {min = 0, max = 9040},  [70] = {min = 0, max = 66502},  [65] = {min = 0, max = 8745},   [255] = {min 
            = 0, max = 26681},      [62] = {min = 0, max = 48329},  [265] = {min = 0, max = 83160}, [1468] = {min = 0, max = 7341}, [1467] = {min = 0, max = 47176},        [581] = {min = 0, max = 36612},      [577] = {min = 0, max = 48211}, [66] = {min = 6, max = 26990},  [72] = {min = 0, max = 47381},  [263] = {min = 0, max = 46259}, [250] = {min = 0, max = 29562}, [251] = {min = 0, max = 41950},      [252] = {min = 0, max = 61884}, [253] = {min = 0, max = 79911}, [254] = {min = 0, max = 25300}, [63] = {min = 0, max = 64871},
            },

            [2543] = {
                encounterName = "Lords of Dread",
                difficultyId = 15,
                encounterId = 2543,
                [64] = {min = 0, max = 143327}, [257] = {min = 0, max = 15949}, [258] = {min = 0, max = 116028},        [259] = {min = 0, max = 87466}, [260] = {min = 0, max = 102099},        [261] = {min = 0, max = 53316},      [262] = {min = 0, max = 81944}, [263] = {min = 2, max = 109760},        [264] = {min = 0, max = 26180}, [73] = {min = 0, max = 38867},  [266] = {min = 0, max = 106380},     [267] = {min = 0, max = 95200}, [268] = {min = 32, max = 80110},        [269] = {min = 0, max = 117413},        [270] = {min = 0, max = 21669}, [102] = {min = 0, max = 293153},     [103] = {min = 0, max = 103736},        [104] = {min = 0, max = 135974},        [105] = {min = 0, max = 10655}, [256] = {min = 0, max = 13368}, [70] = {min = 0, max = 122920}, [65] 
            = {min = 0, max = 30901},       [255] = {min = 86, max = 86188},        [62] = {min = 23, max = 151537},        [66] = {min = 2, max = 91605},  [252] = {min = 13, max = 123127},       [1467] = {min = 0, max = 103169},    [581] = {min = 0, max = 64520}, [265] = {min = 0, max = 176578},        [71] = {min = 0, max = 132533}, [72] = {min = 0, max = 103813}, [577] = {min = 0, max = 101076},     [250] = {min = 1, max = 59608}, [251] = {min = 0, max = 128489},        [1468] = {min = 0, max = 19807},        [253] = {min = 0, max = 125235},        [254] = {min = 11, max = 91006},     [63] = {min = 0, max = 114060},
            },

            [2540] = {
                encounterName = "Dausegne, the Fallen Oracle",
                difficultyId = 15,
                encounterId = 2540,
                [256] = {min = 27, max = 15423},        [257] = {min = 0, max = 15987}, [66] = {min = 6, max = 51881},  [259] = {min = 0, max = 59925}, [260] = {min = 0, max = 75489}, [261] = {min 
            = 0, max = 26192},      [262] = {min = 0, max = 94827}, [263] = {min = 0, max = 72319}, [264] = {min = 0, max = 24611}, [265] = {min = 0, max = 242780},        [266] = {min = 0, max = 97498},      [267] = {min = 299, max = 69105},       [268] = {min = 0, max = 66270}, [269] = {min = 0, max = 90107}, [270] = {min = 0, max = 15806}, [102] = {min = 0, max = 183109},        [103] = {min = 49, max = 60617},     [104] = {min = 0, max = 128962},        [105] = {min = 0, max = 12744}, [70] = {min = 0, max = 101326}, [65] = {min = 0, max = 23287},  [63] = {min = 0, max 
            = 126577},      [258] = {min = 0, max = 82241}, [62] = {min = 648, max = 135298},       [64] = {min = 4, max = 99064},  [1468] = {min = 0, max = 16105},        [1467] = {min = 0, max = 76872},     [71] = {min = 0, max = 69054},  [72] = {min = 0, max = 74877},  [73] = {min = 0, max = 26494},  [577] = {min = 0, max = 87321}, [581] = {min = 0, max = 48213}, [250] = {min = 6, max = 59945},      [251] = {min = 0, max = 81458}, [252] = {min = 0, max = 144306},        [253] = {min = 0, max = 152407},        [254] = {min = 0, max = 40232}, [255] = {min = 0, max = 47516},
            },

            [2546] = {
                encounterName = "Anduin Wrynn",
                difficultyId = 15,
                encounterId = 2546,
                [64] = {min = 0, max = 100040}, [257] = {min = 0, max = 19732}, [258] = {min = 2, max = 81782}, [259] = {min = 0, max = 93638}, [260] = {min = 0, max = 96245}, [261] = {min = 0, max = 50610},      [262] = {min = 0, max = 97561}, [263] = {min = 0, max = 108748},        [264] = {min = 0, max = 29753}, [265] = {min = 0, max = 135030},        [266] = {min = 0, max = 80540},      [267] = {min = 0, max = 81394}, [268] = {min = 11, max = 74655},        [269] = {min = 0, max = 90405}, [270] = {min = 0, max = 18010}, [102] = {min = 0, max = 185767},        [103] = {min = 0, max = 80344},      [104] = {min = 0, max = 99768}, [105] = {min = 0, max = 17810}, [256] = {min = 0, max = 18632}, [70] = {min = 0, max = 150788}, [65] = {min = 0, max = 23109},       [255] = {min = 18, max = 52548},        [62] = {min = 7, max = 107795}, [66] = {min = 1, max = 60289},  [1468] = {min = 0, max = 20589},        [251] = {min = 3, max = 107230},    [71] = {min = 0, max = 120222},  [72] = {min = 0, max = 118753}, [73] = {min = 0, max = 36569},  [577] = {min = 0, max = 96636}, [581] = {min = 0, max = 74331}, [250] = {min = 1, max = 61297},      [1467] = {min = 0, max = 79615},        [252] = {min = 0, max = 140278},        [253] = {min = 0, max = 131235},        [254] = {min = 0, max = 65598}, [63] = {min = 0, max = 132792},
            },

            [2539] = {
                encounterName = "Lihuvim, Principal Architect",
                difficultyId = 15,
                encounterId = 2539,
                [64] = {min = 0, max = 95745},  [257] = {min = 0, max = 14538}, [258] = {min = 8, max = 60754}, [259] = {min = 0, max = 62899}, [260] = {min = 0, max = 78032}, [261] = {min = 0, max = 37570},      [262] = {min = 0, max = 86220}, [71] = {min = 8, max = 82121},  [264] = {min = 0, max = 19346}, [265] = {min = 0, max = 191718},        [266] = {min = 0, max = 118577},    [267] = {min = 0, max = 68510},  [268] = {min = 0, max = 65256}, [269] = {min = 0, max = 93815}, [270] = {min = 0, max = 17737}, [102] = {min = 0, max = 226280},        [103] = {min = 47, max = 61461},     [104] = {min = 50, max = 88592},        [105] = {min = 0, max = 10698}, [256] = {min = 0, max = 13562}, [70] = {min = 0, max = 90840},  [65] = {min = 0, max = 20993},  [255] = {min = 0, max = 40955},      [62] = {min = 110, max = 96212},        [72] = {min = 0, max = 80140},  [1468] = {min = 0, max = 17450},        [1467] = {min = 0, max = 70482},        [263] = {min = 0, max = 73164},      [73] = {min = 0, max = 34590},  [577] = {min = 0, max = 91632}, [581] = {min = 0, max = 48545}, [66] = {min = 3, max = 48774},  [250] = {min = 0, max = 74413},      [251] = {min = 0, max = 66403}, [252] = {min = 0, max = 108284},        [253] = {min = 0, max = 163139},        [254] = {min = 0, max = 39281}, [63] = {min = 0, max = 95348},       
            },

            [2529] = {
                encounterName = "Halondrus the Reclaimer",
                difficultyId = 15,
                encounterId = 2529,
                [64] = {min = 28, max = 44154}, [257] = {min = 0, max = 10446}, [258] = {min = 0, max = 47129}, [259] = {min = 0, max = 44919}, [260] = {min = 4, max = 50932}, [261] = {min = 0, max = 21011},      [262] = {min = 0, max = 40749}, [71] = {min = 17, max = 47420}, [72] = {min = 0, max = 51611},  [265] = {min = 0, max = 66416}, [266] = {min = 0, max = 48778}, [267] = {min 
            = 0, max = 40900},      [268] = {min = 1119, max = 28039},      [269] = {min = 0, max = 51753}, [270] = {min = 0, max = 11042}, [102] = {min = 0, max = 79687}, [103] = {min = 0, max = 40354},      [104] = {min = 17, max = 75226},        [105] = {min = 0, max = 10229}, [256] = {min = 0, max = 8034},  [70] = {min = 0, max = 55712},  [66] = {min = 0, max = 22331},  [65] = {min = 0, max = 12609},       [255] = {min = 879, max = 26729},       [254] = {min = 46, max = 32832},        [581] = {min = 4, max = 27475}, [1468] = {min = 0, max = 8495}, [251] = {min = 16, max = 48231},     [577] = {min = 0, max = 51834}, [263] = {min = 0, max = 44925}, [264] = {min = 0, max = 12054}, [73] = {min = 0, max = 17782},  [250] = {min = 16, max = 24068},        [1467] = {min = 0, max = 41245},     [252] = {min = 0, max = 69430}, [253] = {min = 0, max = 69978}, [62] = {min = 215, max = 38895},        [63] = {min = 0, max = 60766},
            },

            [2542] = {
                encounterName = "Skolex, the Insatiable Ravener",
                difficultyId = 15,
                encounterId = 2542,
                [256] = {min = 271, max = 10094},       [257] = {min = 0, max = 14406}, [66] = {min = 16, max = 51537}, [259] = {min = 0, max = 64691}, [260] = {min = 0, max = 71433}, [261] = {min 
            = 0, max = 29475},      [262] = {min = 0, max = 83649}, [263] = {min = 0, max = 69501}, [264] = {min = 0, max = 17591}, [265] = {min = 0, max = 152230},        [266] = {min = 0, max = 94325},      [267] = {min = 0, max = 70824}, [268] = {min = 0, max = 42793}, [269] = {min = 0, max = 93975}, [270] = {min = 0, max = 24151}, [102] = {min = 0, max = 199522},        [103] = {min 
            = 0, max = 57741},      [104] = {min = 0, max = 72943}, [105] = {min = 0, max = 13211}, [70] = {min = 0, max = 100549}, [65] = {min = 0, max = 20763},  [64] = {min = 0, max = 88475},  [255] = {min = 112, max = 42084},    [62] = {min = 0, max = 96368},  [73] = {min = 0, max = 28507},  [1468] = {min = 0, max = 11553},        [1467] = {min = 0, max = 76901},        [258] = {min 
            = 0, max = 65188},      [577] = {min = 0, max = 78885}, [581] = {min = 0, max = 46778}, [72] = {min = 0, max = 79490},  [71] = {min = 0, max = 72782},  [250] = {min = 0, max = 55900}, [251] = {min = 0, max = 75438},      [252] = {min = 0, max = 125691},        [253] = {min = 0, max = 112643},        [254] = {min = 0, max = 39698}, [63] = {min = 0, max = 115827},
            },

            [2544] = {
                encounterName = "Prototype Pantheon",
                difficultyId = 15,
                encounterId = 2544,
                [64] = {min = 0, max = 108283}, [257] = {min = 0, max = 15220}, [258] = {min = 0, max = 72731}, [259] = {min = 0, max = 57688}, [260] = {min = 0, max = 68463}, [261] = {min = 0, max = 29653},      [262] = {min = 0, max = 82429}, [263] = {min = 0, max = 75930}, [264] = {min = 0, max = 22283}, [265] = {min = 0, max = 275775},        [266] = {min = 0, max = 131667},    [267] = {min = 0, max = 66544},  [268] = {min = 2263, max = 57813},      [269] = {min = 0, max = 99127}, [270] = {min = 0, max = 22205}, [102] = {min = 0, max = 134851},        [103] = {min 
            = 0, max = 52823},      [104] = {min = 112, max = 92505},       [105] = {min = 0, max = 14270}, [256] = {min = 0, max = 16529}, [70] = {min = 0, max = 95961},  [65] = {min = 0, max = 19297},       [63] = {min = 73, max = 107171},        [62] = {min = 126, max = 91554},        [66] = {min = 3, max = 35003},  [1468] = {min = 0, max = 16638},        [1467] = {min = 0, max = 78207},     [71] = {min = 0, max = 61526},  [72] = {min = 0, max = 86095},  [73] = {min = 0, max = 25579},  [577] = {min = 0, max = 75173}, [581] = {min = 0, max = 49011}, [250] = {min = 13, max = 45176},     [251] = {min = 0, max = 79676}, [252] = {min = 0, max = 118116},        [253] = {min = 0, max = 114283},        [254] = {min = 0, max = 50788}, [255] = {min = 0, max = 38675},
            },

            [2553] = {
                encounterName = "Artificer Xy'mox",
                difficultyId = 15,
                encounterId = 2553,
                [64] = {min = 0, max = 75227},  [257] = {min = 0, max = 16946}, [258] = {min = 0, max = 58744}, [259] = {min = 0, max = 58446}, [260] = {min = 0, max = 59794}, [261] = {min = 0, max = 26010},      [262] = {min = 17, max = 70740},        [263] = {min = 4, max = 57720}, [264] = {min = 0, max = 19465}, [265] = {min = 0, max = 162348},        [266] = {min = 0, max = 84628},      [267] = {min = 0, max = 52454}, [268] = {min = 81, max = 39433},        [269] = {min = 0, max = 93118}, [270] = {min = 0, max = 20319}, [102] = {min = 0, max = 90077}, [103] = {min 
            = 13, max = 43399},     [104] = {min = 0, max = 64418}, [105] = {min = 0, max = 11345}, [256] = {min = 0, max = 15449}, [70] = {min = 0, max = 86984},  [66] = {min = 0, max = 32851},  [65] 
            = {min = 0, max = 16511},       [255] = {min = 0, max = 40009}, [254] = {min = 42, max = 51248},        [71] = {min = 49, max = 57600}, [252] = {min = 13, max = 98953},        [1467] = {min = 0, max = 59878},     [72] = {min = 0, max = 68892},  [73] = {min = 0, max = 24387},  [577] = {min = 0, max = 67419}, [581] = {min = 0, max = 50139}, [250] = {min = 6, max = 37574}, [251] = {min = 0, max = 67577},      [1468] = {min = 0, max = 18160},        [253] = {min = 0, max = 104953},        [62] = {min = 0, max = 74689},  [63] = {min = 0, max = 96869},
            },

        },

        --[14] = {} --normal
        --[17] = {} --raid finder
    }



