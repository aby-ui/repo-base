local Details = _G.Details
local DF = _G.DetailsFramework
local C_Timer = _G.C_Timer
local unpack = _G.unpack
local GetTime = _G.GetTime
local tremove = _G.tremove
local GetInstanceInfo = _G.GetInstanceInfo

local Loc = _G.LibStub("AceLocale-3.0"):GetLocale("Details")

--data for the current mythic + dungeon
Details.MythicPlus = {
    RunID = 0,
}

-- ~mythic ~dungeon
local DetailsMythicPlusFrame = _G.CreateFrame ("frame", "DetailsMythicPlusFrame", UIParent)
DetailsMythicPlusFrame.DevelopmentDebug = false

--disabling the mythic+ feature if the user is playing in wow classic
if (not DF.IsTimewalkWoW()) then
    DetailsMythicPlusFrame:RegisterEvent ("CHALLENGE_MODE_START")
    DetailsMythicPlusFrame:RegisterEvent ("CHALLENGE_MODE_COMPLETED")
    DetailsMythicPlusFrame:RegisterEvent ("ZONE_CHANGED_NEW_AREA")
    DetailsMythicPlusFrame:RegisterEvent ("ENCOUNTER_END")
    DetailsMythicPlusFrame:RegisterEvent ("START_TIMER")
end

--[[
    all mythic segments have:
        .is_mythic_dungeon_segment = true
        .is_mythic_dungeon_run_id = run id from details.profile.mythic_dungeon_id
    boss, 'trash overall' and 'dungeon overall' segments have:
        .is_mythic_dungeon 
    boss segments have:
        .is_boss
    'trash overall' segments have:
        .is_mythic_dungeon with .SegmentID = "trashoverall"
    'dungeon overall' segment have:
        .is_mythic_dungeon with .SegmentID = "overall"
    
--]]

--precisa converter um wipe em um trash segment? provavel que sim

-- at the end of a mythic run, if enable on settings, merge all the segments from the mythic run into only one
function DetailsMythicPlusFrame.MergeSegmentsOnEnd()
    if (DetailsMythicPlusFrame.DevelopmentDebug) then
        print ("Details!", "MergeSegmentsOnEnd() > starting to merge mythic segments.", "InCombatLockdown():", InCombatLockdown())
    end
    
    --> create a new combat to be the overall for the mythic run
    Details:EntrarEmCombate()
    
    --> get the current combat just created and the table with all past segments
    local newCombat = Details:GetCurrentCombat()
    local segmentHistory = Details:GetCombatSegments()

    local totalTime = 0
    local startDate, endDate = "", ""
    local lastSegment
    local totalSegments = 0

    --> add all boss segments from this run to this new segment
    for i = 1, 25 do --> from the newer combat to the oldest
        local pastCombat = segmentHistory [i]
        if (pastCombat and pastCombat.is_mythic_dungeon_run_id == Details.mythic_dungeon_id) then
            local canAddThisSegment = true
            if (_detalhes.mythic_plus.make_overall_boss_only) then
                if (not pastCombat.is_boss) then
                    canAddThisSegment = false
                end
            end
            
            if (canAddThisSegment) then
                newCombat = newCombat + pastCombat
                totalTime = totalTime + pastCombat:GetCombatTime()
                totalSegments = totalSegments + 1
                
                if (DetailsMythicPlusFrame.DevelopmentDebug) then
                    print ("MergeSegmentsOnEnd() > adding time:", pastCombat:GetCombatTime(), pastCombat.is_boss and pastCombat.is_boss.name)
                end
                
                if (endDate == "") then
                    local _, whenEnded = pastCombat:GetDate()
                    endDate =whenEnded
                end
                lastSegment = pastCombat
            end
        end
    end
    
    --> get the date where the first segment started
    if (lastSegment) then
        startDate = lastSegment:GetDate()
    end
    
    if (DetailsMythicPlusFrame.DevelopmentDebug) then
        print ("Details!", "MergeSegmentsOnEnd() > totalTime:", totalTime, "startDate:", startDate)
    end
    
    local zoneName, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapID, instanceGroupSize = GetInstanceInfo()
    
    --> tag the segment as mythic overall segment
    newCombat.is_mythic_dungeon = {
        StartedAt = Details.MythicPlus.StartedAt, --the start of the run
        EndedAt = Details.MythicPlus.EndedAt, --the end of the run
        SegmentID = "overall", --segment number within the dungeon
        RunID = Details.mythic_dungeon_id,
        OverallSegment = true,
        ZoneName = Details.MythicPlus.DungeonName,
        MapID = instanceMapID,
        Level = Details.MythicPlus.Level,
        EJID = Details.MythicPlus.ejID,
    }
    
    newCombat.total_segments_added = totalSegments
    
    newCombat.is_mythic_dungeon_segment = true
    newCombat.is_mythic_dungeon_run_id = Details.mythic_dungeon_id
    
    --> set the segment time and date
    newCombat:SetStartTime (GetTime() - totalTime)
    newCombat:SetEndTime (GetTime())
    newCombat:SetDate (startDate, endDate)

    --> immediatly finishes the segment just started
    Details:SairDoCombate()

    --> update all windows
    Details:InstanciaCallFunction(Details.FadeHandler.Fader, "IN", nil, "barras")
    Details:InstanciaCallFunction(Details.AtualizaSegmentos)
    Details:InstanciaCallFunction(Details.AtualizaSoloMode_AfertReset)
    Details:InstanciaCallFunction(Details.ResetaGump)
    Details:RefreshMainWindow (-1, true)
    
    if (DetailsMythicPlusFrame.DevelopmentDebug) then
        print ("Details!", "MergeSegmentsOnEnd() > finished merging segments.")
        print ("Details!", "MergeSegmentsOnEnd() > all done, check in the segments list if everything is correct, if something is weird: '/details feedback' thanks in advance!")
    end
    
    local lower_instance = Details:GetLowerInstanceNumber()
    if (lower_instance) then
        local instance = Details:GetInstance (lower_instance)
        if (instance) then
            local func = {function() end}
            instance:InstanceAlert ("Showing Mythic+ Run Segment", {[[Interface\AddOns\Details\images\icons]], 16, 16, false, 434/512, 466/512, 243/512, 273/512}, 6, func, true)
        end
    end
end

--> after each boss fight, if enalbed on settings, create an extra segment with all trash segments from the boss just killed
function DetailsMythicPlusFrame.MergeTrashCleanup (isFromSchedule)
    if (DetailsMythicPlusFrame.DevelopmentDebug) then
        print ("Details!", "MergeTrashCleanup() > running", DetailsMythicPlusFrame.TrashMergeScheduled and #DetailsMythicPlusFrame.TrashMergeScheduled)
    end
    
    local segmentsToMerge = DetailsMythicPlusFrame.TrashMergeScheduled
    
    --> table exists and there's at least one segment
    if (segmentsToMerge and segmentsToMerge[1]) then
        
        --the first segment is the segment where all other trash segments will be added
        local masterSegment = segmentsToMerge[1]
        masterSegment.is_mythic_dungeon_trash = nil
        
        --> get the current combat just created and the table with all past segments
        local newCombat = masterSegment
        local totalTime = newCombat:GetCombatTime()
        local startDate, endDate = "", ""
        local lastSegment
        
        --> add segments
        for i = 2, #segmentsToMerge do --segment #1 is the host
            local pastCombat = segmentsToMerge[i]
            newCombat = newCombat + pastCombat
            totalTime = totalTime + pastCombat:GetCombatTime()
            
            --> tag this combat as already added to a boss trash overall
            pastCombat._trashoverallalreadyadded = true
            
            if (endDate == "") then
                local _, whenEnded = pastCombat:GetDate()
                endDate = whenEnded
            end
            lastSegment = pastCombat
        end
        
        --> get the date where the first segment started
        if (lastSegment) then
            startDate = lastSegment:GetDate()
        end
        
        local zoneName, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapID, instanceGroupSize = GetInstanceInfo()

        --> tag the segment as mythic overall segment
        newCombat.is_mythic_dungeon = {
            StartedAt = segmentsToMerge.PreviousBossKilledAt, --start of the mythic run or when the previous boss got killed
            EndedAt = segmentsToMerge.LastBossKilledAt, --the time() when encounter_end got triggered
            SegmentID = "trashoverall",
            RunID = Details.mythic_dungeon_id,
            TrashOverallSegment = true,
            ZoneName = Details.MythicPlus.DungeonName,
            MapID = instanceMapID,
            Level = Details.MythicPlus.Level,
            EJID = Details.MythicPlus.ejID,
            EncounterID = segmentsToMerge.EncounterID,
            EncounterName = segmentsToMerge.EncounterName or Loc ["STRING_UNKNOW"],
        }
        
        newCombat.is_mythic_dungeon_segment = true
        newCombat.is_mythic_dungeon_run_id = Details.mythic_dungeon_id
        
        --> set the segment time / using a sum of combat times, this combat time is reliable
        newCombat:SetStartTime (GetTime() - totalTime)
        newCombat:SetEndTime (GetTime())
        --> set the segment date
        newCombat:SetDate (startDate, endDate)
        
        if (DetailsMythicPlusFrame.DevelopmentDebug) then
            print ("Details!", "MergeTrashCleanup() > finished merging trash segments.", _detalhes.tabela_vigente, _detalhes.tabela_vigente.is_boss)
        end	

        --> should delete the trash segments after the merge?
        if (_detalhes.mythic_plus.delete_trash_after_merge) then
            local segmentHistory = Details:GetCombatSegments()
            for i = #segmentHistory, 1, -1 do
                local segment = segmentHistory [i]
                if (segment and segment._trashoverallalreadyadded) then
                    tremove (segmentHistory, i)
                end
            end

            for i = #segmentsToMerge, 1, -1 do
                tremove (segmentsToMerge, i)
            end
            
            Details:SendEvent ("DETAILS_DATA_SEGMENTREMOVED")
        else
            --> clear the segments to merge table
            for i = #segmentsToMerge, 1, -1 do
                tremove (segmentsToMerge, i)
                --> notify plugins about a segment deleted
                Details:SendEvent ("DETAILS_DATA_SEGMENTREMOVED")
            end
            
            --> clear encounter name and id
            segmentsToMerge.EncounterID = nil
            segmentsToMerge.EncounterName = nil
        end

        --> update all windows
        Details:InstanciaCallFunction (Details.FadeHandler.Fader, "IN", nil, "barras")
        Details:InstanciaCallFunction (Details.AtualizaSegmentos)
        Details:InstanciaCallFunction (Details.AtualizaSoloMode_AfertReset)
        Details:InstanciaCallFunction (Details.ResetaGump)
        Details:RefreshMainWindow (-1, true)
    end
end

--> this function merges trash segments after all bosses of the mythic dungeon are defeated
--> happens when the group finishes all bosses but don't complete the trash requirement
function DetailsMythicPlusFrame.MergeRemainingTrashAfterAllBossesDone()
    if (DetailsMythicPlusFrame.DevelopmentDebug) then
        print ("Details!", "MergeRemainingTrashAfterAllBossesDone() > running, #segments: ", #DetailsMythicPlusFrame.TrashMergeScheduled2, "trash overall table:", DetailsMythicPlusFrame.TrashMergeScheduled2_OverallCombat)
    end
    
    local segmentsToMerge = DetailsMythicPlusFrame.TrashMergeScheduled2
    local overallCombat = DetailsMythicPlusFrame.TrashMergeScheduled2_OverallCombat
    
    --> needs to merge, add the total combat time, set the date end to the date of the first segment
    local totalTime = 0
    local startDate, endDate = "", ""
    local lastSegment
    
    --> add segments
    for i, pastCombat in ipairs (segmentsToMerge) do
        overallCombat = overallCombat + pastCombat
        if (DetailsMythicPlusFrame.DevelopmentDebug) then
            print ("MergeRemainingTrashAfterAllBossesDone() >  segment added")
        end
        totalTime = totalTime + pastCombat:GetCombatTime()
        
        --> tag this combat as already added to a boss trash overall
        pastCombat._trashoverallalreadyadded = true
        
        if (endDate == "") then --get the end date of the first index only
            local _, whenEnded = pastCombat:GetDate()
            endDate = whenEnded
        end
        lastSegment = pastCombat
    end
    
    --> set the segment time / using a sum of combat times, this combat time is reliable
    local startTime = overallCombat:GetStartTime()
    overallCombat:SetStartTime (startTime - totalTime)
    if (DetailsMythicPlusFrame.DevelopmentDebug) then
        print ("MergeRemainingTrashAfterAllBossesDone() > total combat time:", totalTime)
    end
    --> set the segment date
    local startDate = overallCombat:GetDate()
    overallCombat:SetDate (startDate, endDate)
    if (DetailsMythicPlusFrame.DevelopmentDebug) then
        print ("MergeRemainingTrashAfterAllBossesDone() > new end date:", endDate)
    end
    
    local mythicDungeonInfo = overallCombat:GetMythicDungeonInfo()
    
    if (DetailsMythicPlusFrame.DevelopmentDebug) then
        print ("MergeRemainingTrashAfterAllBossesDone() > elapsed time before:", mythicDungeonInfo.EndedAt - mythicDungeonInfo.StartedAt)
    end
    mythicDungeonInfo.StartedAt = mythicDungeonInfo.StartedAt - (Details.MythicPlus.EndedAt - Details.MythicPlus.PreviousBossKilledAt)
    if (DetailsMythicPlusFrame.DevelopmentDebug) then
        print ("MergeRemainingTrashAfterAllBossesDone() > elapsed time after:", mythicDungeonInfo.EndedAt - mythicDungeonInfo.StartedAt)
    end
    
    --> should delete the trash segments after the merge?
    if (_detalhes.mythic_plus.delete_trash_after_merge) then
        local removedCurrentSegment = false
        local segmentHistory = Details:GetCombatSegments()
        for _, pastCombat in ipairs (segmentsToMerge) do
            for i = #segmentHistory, 1, -1 do
                local segment = segmentHistory [i]
                if (segment == pastCombat) then
                    --> remove the segment
                    if (_detalhes.tabela_vigente == segment) then
                        removedCurrentSegment = true
                    end
                    tremove (segmentHistory, i)
                    break
                end
            end
        end
        
        for i = #segmentsToMerge, 1, -1 do
            tremove (segmentsToMerge, i)
        end

        if (removedCurrentSegment) then
            --> find another current segment
            local segmentHistory = Details:GetCombatSegments()
            _detalhes.tabela_vigente = segmentHistory [1]
            
            if (not _detalhes.tabela_vigente) then
                --> assuming there's no segment from the dungeon run
                Details:EntrarEmCombate()
                Details:SairDoCombate()
            end
            
            --> update all windows
            Details:InstanciaCallFunction(Details.FadeHandler.Fader, "IN", nil, "barras")
            Details:InstanciaCallFunction(Details.AtualizaSegmentos)
            Details:InstanciaCallFunction(Details.AtualizaSoloMode_AfertReset)
            Details:InstanciaCallFunction(Details.ResetaGump)
            Details:RefreshMainWindow(-1, true)
        end
        
        Details:SendEvent ("DETAILS_DATA_SEGMENTREMOVED")
    else
        --> clear the segments to merge table
        for i = #segmentsToMerge, 1, -1 do
            tremove (segmentsToMerge, i)
            --> notify plugins about a segment deleted
            Details:SendEvent ("DETAILS_DATA_SEGMENTREMOVED")
        end
    end

    DetailsMythicPlusFrame.TrashMergeScheduled2 = nil
    DetailsMythicPlusFrame.TrashMergeScheduled2_OverallCombat = nil

    if (DetailsMythicPlusFrame.DevelopmentDebug) then
        print ("Details!", "MergeRemainingTrashAfterAllBossesDone() > done merging")
    end
end

--this function is called right after defeat a boss inside a mythic dungeon
--it comes from details! control leave combat
function DetailsMythicPlusFrame.BossDefeated (this_is_end_end, encounterID, encounterName, difficultyID, raidSize, endStatus) --hold your breath and count to ten
    if (DetailsMythicPlusFrame.DevelopmentDebug) then
        print ("Details!", "BossDefeated() > boss defeated | SegmentID:", Details.MythicPlus.SegmentID, " | mapID:", Details.MythicPlus.DungeonID)
    end
    
    local zoneName, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapID, instanceGroupSize = GetInstanceInfo()
    
    --> add the mythic dungeon info to the combat
    _detalhes.tabela_vigente.is_mythic_dungeon = {
        StartedAt = Details.MythicPlus.StartedAt, --the start of the run
        EndedAt = time(), --when the boss got killed
        SegmentID = Details.MythicPlus.SegmentID, --segment number within the dungeon
        EncounterID = encounterID,
        EncounterName = encounterName or Loc ["STRING_UNKNOW"],
        RunID = Details.mythic_dungeon_id,
        ZoneName = Details.MythicPlus.DungeonName,
        MapID = Details.MythicPlus.DungeonID,
        OverallSegment = false,
        Level = Details.MythicPlus.Level,
        EJID = Details.MythicPlus.ejID,
    }

    --> check if need to merge the trash for this boss
    if (_detalhes.mythic_plus.merge_boss_trash and not Details.MythicPlus.IsRestoredState) then
        --> store on an table all segments which should be merged
        local segmentsToMerge = DetailsMythicPlusFrame.TrashMergeScheduled or {}

        --> table with all past semgnets
        local segmentHistory = Details:GetCombatSegments()
        
        --> iterate among segments
        for i = 1, 25 do --> from the newer combat to the oldest
            local pastCombat = segmentHistory [i]
            --> does the combat exists
            if (pastCombat and not pastCombat._trashoverallalreadyadded and pastCombat.is_mythic_dungeon_trash) then
                --> is the combat a mythic segment from this run?
                local isMythicSegment, SegmentID = pastCombat:IsMythicDungeon()
                if (isMythicSegment and SegmentID == Details.mythic_dungeon_id and not pastCombat.is_boss) then
                
                    local mythicDungeonInfo = pastCombat:GetMythicDungeonInfo() -- .is_mythic_dungeon only boss, trash overall and run overall have it
                    if (not mythicDungeonInfo or not mythicDungeonInfo.TrashOverallSegment) then
                        --> trash segment found, schedule to merge
                        tinsert (segmentsToMerge, pastCombat)
                    end
                end
            end
        end
        
        --> add encounter information
        segmentsToMerge.EncounterID = encounterID
        segmentsToMerge.EncounterName = encounterName
        segmentsToMerge.PreviousBossKilledAt = Details.MythicPlus.PreviousBossKilledAt
        
        --> reduce this boss encounter time from the trash lenght time, since the boss doesn't count towards the time spent cleaning trash
        segmentsToMerge.LastBossKilledAt = time() - _detalhes.tabela_vigente:GetCombatTime()
        
        DetailsMythicPlusFrame.TrashMergeScheduled = segmentsToMerge
        
        --there's no more script run too long
        --if (not InCombatLockdown() and not UnitAffectingCombat ("player")) then
            if (DetailsMythicPlusFrame.DevelopmentDebug) then
                print ("Details!", "BossDefeated() > not in combat, merging trash now")
            end
            --merge the trash clean up
            DetailsMythicPlusFrame.MergeTrashCleanup()
        --else
        --	if (DetailsMythicPlusFrame.DevelopmentDebug) then
        --		print ("Details!", "BossDefeated() > player in combatlockdown, scheduling trash merge")
        --	end
        --	_detalhes.schedule_mythicdungeon_trash_merge = true
        --end
    end

    --> close the combat
    if (this_is_end_end) then
        --> player left the dungeon
        if (in_combat and _detalhes.mythic_plus.always_in_combat) then
            Details:SairDoCombate()
        end
    else
        --> re-enter in combat if details! is set to always be in combat during mythic plus
        if (Details.mythic_plus.always_in_combat) then
            Details:EntrarEmCombate()
        end
        
        --> increase the segment number for the mythic run
        Details.MythicPlus.SegmentID = Details.MythicPlus.SegmentID + 1
        
        --> register the time when the last boss has been killed (started a clean up for the next trash)
        Details.MythicPlus.PreviousBossKilledAt = time()
        
        --> update the saved table inside the profile
        _detalhes:UpdateState_CurrentMythicDungeonRun (true, Details.MythicPlus.SegmentID, Details.MythicPlus.PreviousBossKilledAt)
    end
end

function DetailsMythicPlusFrame.MythicDungeonFinished (fromZoneLeft)
    if (DetailsMythicPlusFrame.IsDoingMythicDungeon) then
        if (DetailsMythicPlusFrame.DevelopmentDebug) then
            print ("Details!", "MythicDungeonFinished() > the dungeon was a Mythic+ and just ended.")
        end
        
        DetailsMythicPlusFrame.IsDoingMythicDungeon = false
        Details.MythicPlus.Started = false
        Details.MythicPlus.EndedAt = time()-1.9
        
        Details:UpdateState_CurrentMythicDungeonRun()
        
        --> at this point, details! should not be in combat, but if something triggered a combat start, just close the combat right away
        if (Details.in_combat) then
            if (DetailsMythicPlusFrame.DevelopmentDebug) then
                print ("Details!", "MythicDungeonFinished() > was in combat, calling SairDoCombate():", InCombatLockdown())
            end
            Details:SairDoCombate()
        end
        
        local segmentsToMerge = {}
        
        --> check if there is trash segments after the last boss. need to merge these segments with the trash segment of the last boss
        if (_detalhes.mythic_plus.merge_boss_trash and not Details.MythicPlus.IsRestoredState and not fromZoneLeft) then
            --> is the current combat not a boss fight? 
            --> this mean a combat was opened after the last boss of the dungeon was killed
            if (not Details.tabela_vigente.is_boss and Details.tabela_vigente:GetCombatTime() > 5) then
                
                if (DetailsMythicPlusFrame.DevelopmentDebug) then
                    print ("Details!", "MythicDungeonFinished() > the last combat isn't a boss fight, might have trash after bosses done.")
                end
                
                --> table with all past semgnets
                local segmentHistory = Details:GetCombatSegments()
                
                for i = 1, #segmentHistory do
                    local pastCombat = segmentHistory [i]
                    --> does the combat exists
                
                    if (pastCombat and not pastCombat._trashoverallalreadyadded and pastCombat:GetCombatTime() > 5) then
                        --> is the last boss?
                        if (pastCombat.is_boss) then
                            break
                        end
                        
                        --> is the combat a mythic segment from this run?
                        local isMythicSegment, SegmentID = pastCombat:IsMythicDungeon()
                        if (isMythicSegment and SegmentID == Details.mythic_dungeon_id and pastCombat.is_mythic_dungeon_trash) then
                        
                            --> if have mythic dungeon info, cancel the loop
                            local mythicDungeonInfo = pastCombat:GetMythicDungeonInfo()
                            if (mythicDungeonInfo) then
                                break
                            end
                            
                            --> merge this segment
                            tinsert (segmentsToMerge, pastCombat)
                            
                            if (DetailsMythicPlusFrame.DevelopmentDebug) then
                                print ("MythicDungeonFinished() > found after last boss combat")
                            end
                        end
                    end
                end
            end
        end
        
        if (#segmentsToMerge > 0) then
            if (DetailsMythicPlusFrame.DevelopmentDebug) then
                print ("Details!", "MythicDungeonFinished() > found ", #segmentsToMerge, "segments after the last boss")
            end
            
            --> find the latest trash overall
            local segmentHistory = Details:GetCombatSegments()
            local latestTrashOverall
            for i = 1, #segmentHistory do
                local pastCombat = segmentHistory [i]
                if (pastCombat and pastCombat.is_mythic_dungeon and pastCombat.is_mythic_dungeon.SegmentID == "trashoverall") then
                    latestTrashOverall = pastCombat
                    break
                end
            end
            
            if (latestTrashOverall) then
                --> stores the segment table and the trash overall segment to use on the merge
                DetailsMythicPlusFrame.TrashMergeScheduled2 = segmentsToMerge
                DetailsMythicPlusFrame.TrashMergeScheduled2_OverallCombat = latestTrashOverall
                
                --there's no more script ran too long
                --if (not InCombatLockdown() and not UnitAffectingCombat ("player")) then
                    if (DetailsMythicPlusFrame.DevelopmentDebug) then
                        print ("Details!", "MythicDungeonFinished() > not in combat, merging last pack of trash now")
                    end

                    DetailsMythicPlusFrame.MergeRemainingTrashAfterAllBossesDone()
                --else
                --	if (DetailsMythicPlusFrame.DevelopmentDebug) then
                --		print ("Details!", "MythicDungeonFinished() > player in combatlockdown, scheduling the merge for last trash packs")
                --	end
                --	_detalhes.schedule_mythicdungeon_endtrash_merge = true
                --end
            end
        end
        
        --> merge segments
        if (_detalhes.mythic_plus.make_overall_when_done and not Details.MythicPlus.IsRestoredState and not fromZoneLeft) then
            --if (not InCombatLockdown() and not UnitAffectingCombat ("player")) then
                if (DetailsMythicPlusFrame.DevelopmentDebug) then
                    print ("Details!", "MythicDungeonFinished() > not in combat, creating overall segment now")
                end
                DetailsMythicPlusFrame.MergeSegmentsOnEnd()
            --else
            --	if (DetailsMythicPlusFrame.DevelopmentDebug) then
            --		print ("Details!", "MythicDungeonFinished() > player in combatlockdown, scheduling the creation of the overall segment")
            --	end
            --	_detalhes.schedule_mythicdungeon_overallrun_merge = true
            --end
        end
        
        Details.MythicPlus.IsRestoredState = nil
        
        --> shutdown parser for a few seconds to avoid opening new segments after the run ends
        if (not fromZoneLeft) then
            Details:CaptureSet (false, "damage", false, 15)
            Details:CaptureSet (false, "energy", false, 15)
            Details:CaptureSet (false, "aura", false, 15)
            Details:CaptureSet (false, "energy", false, 15)
            Details:CaptureSet (false, "spellcast", false, 15)
        end
        
        --> store data
        --[=[
        local expansion = tostring (select (4, GetBuildInfo())):match ("%d%d")
        if (expansion and type (expansion) == "string" and string.len (expansion) == 2) then
            local expansionDungeonData = _detalhes.dungeon_data [expansion]
            if (not expansionDungeonData) then
                expansionDungeonData = {}
                _detalhes.dungeon_data [expansion] = expansionDungeonData
            end
            
            --store information about the dungeon run
            --the the dungeon ID, can't be localized
            --players in the group
            --difficulty level
            --
            
        end
        --]=]
    end
end

function DetailsMythicPlusFrame.MythicDungeonStarted()
    --> flag as a mythic dungeon
    DetailsMythicPlusFrame.IsDoingMythicDungeon = true
    
    --> this counter is individual for each character
    Details.mythic_dungeon_id = Details.mythic_dungeon_id + 1
    
    local mythicLevel = C_ChallengeMode.GetActiveKeystoneInfo()
    local zoneName, _, _, _, _, _, _, currentZoneID = GetInstanceInfo()
    
    local mapID = C_Map.GetBestMapForUnit ("player")
    
    if (not mapID) then
        return
    end
    
    local ejID = DF.EncounterJournal.EJ_GetInstanceForMap (mapID)

    --> setup the mythic run info
    Details.MythicPlus.Started = true
    Details.MythicPlus.DungeonName = zoneName
    Details.MythicPlus.DungeonID = currentZoneID
    Details.MythicPlus.StartedAt = time()+9.7 --> there's the countdown timer of 10 seconds
    Details.MythicPlus.EndedAt = nil --reset
    Details.MythicPlus.SegmentID = 1
    Details.MythicPlus.Level = mythicLevel
    Details.MythicPlus.ejID = ejID
    Details.MythicPlus.PreviousBossKilledAt = time()

    Details:SaveState_CurrentMythicDungeonRun (Details.mythic_dungeon_id, zoneName, currentZoneID, time()+9.7, 1, mythicLevel, ejID, time())
    
    --> start a new combat segment after 10 seconds
    if (_detalhes.mythic_plus.always_in_combat) then
        C_Timer.After (9.7, function()
            if (DetailsMythicPlusFrame.DevelopmentDebug) then
                print ("Details!", "New segment for mythic dungeon created.")
            end
            _detalhes:EntrarEmCombate()
        end)
    end
    
    local name, groupType, difficultyID, difficult = GetInstanceInfo()
    if (groupType == "party" and Details.overall_clear_newchallenge) then
        Details.historico:resetar_overall()
        Details:Msg ("overall data are now reset.")
        
        if (Details.debug) then
            Details:Msg ("(debug) timer is for a mythic+ dungeon, overall has been reseted.")
        end
    end
    
    if (DetailsMythicPlusFrame.DevelopmentDebug) then
        print ("Details!", "MythicDungeonStarted() > State set to Mythic Dungeon, new combat starting in 10 seconds.")
    end
    
end

function DetailsMythicPlusFrame.OnChallengeModeStart()
    --> is this a mythic dungeon?
    local _, _, difficulty, _, _, _, _, currentZoneID = GetInstanceInfo()

    if (difficulty == 8 and DetailsMythicPlusFrame.LastTimer and DetailsMythicPlusFrame.LastTimer+2 > GetTime()) then
        --> start the dungeon on Details!
        DetailsMythicPlusFrame.MythicDungeonStarted()
        --print("D! mythic dungeon started!")
    else

        --print("D! mythic dungeon was already started!")
        --> from zone changed
        local mythicLevel = C_ChallengeMode.GetActiveKeystoneInfo()
        local zoneName, _, _, _, _, _, _, currentZoneID = GetInstanceInfo()

        --print("Details.MythicPlus.Started", Details.MythicPlus.Started)
        --print("Details.MythicPlus.DungeonID", Details.MythicPlus.DungeonID)
        --print("currentZoneID", currentZoneID)
        --print("Details.MythicPlus.Level", Details.MythicPlus.Level)
        --print("mythicLevel", mythicLevel)
        
        if (not Details.MythicPlus.Started and Details.MythicPlus.DungeonID == currentZoneID and Details.MythicPlus.Level == mythicLevel) then
            Details.MythicPlus.Started = true
            Details.MythicPlus.EndedAt = nil
            _detalhes.mythic_dungeon_currentsaved.started = true
            DetailsMythicPlusFrame.IsDoingMythicDungeon = true

            --print("D! mythic dungeon was NOT already started! debug 2")
        end
    end
end

--make an event listener to sync combat data
DetailsMythicPlusFrame.EventListener = Details:CreateEventListener()
DetailsMythicPlusFrame.EventListener:RegisterEvent ("COMBAT_ENCOUNTER_START")
DetailsMythicPlusFrame.EventListener:RegisterEvent ("COMBAT_ENCOUNTER_END")
DetailsMythicPlusFrame.EventListener:RegisterEvent ("COMBAT_PLAYER_ENTER")
DetailsMythicPlusFrame.EventListener:RegisterEvent ("COMBAT_PLAYER_LEAVE")
DetailsMythicPlusFrame.EventListener:RegisterEvent ("COMBAT_MYTHICDUNGEON_START")
DetailsMythicPlusFrame.EventListener:RegisterEvent ("COMBAT_MYTHICDUNGEON_END")

function DetailsMythicPlusFrame.EventListener.OnDetailsEvent (contextObject, event, ...)
    --these events triggers within Details control functions, they run exactly after details! creates or close a segment
    if (event == "COMBAT_PLAYER_ENTER") then
        
    
    elseif (event == "COMBAT_PLAYER_LEAVE") then
        --> ignore the event if ignoring mythic dungeon special treatment
        if (_detalhes.streamer_config.disable_mythic_dungeon) then
            return
        end

        if (DetailsMythicPlusFrame.IsDoingMythicDungeon) then
            local combatObject = ...
        
            if (combatObject.is_boss) then
                if (not combatObject.is_boss.killed) then
                    
                    --> just in case the combat get tagged as boss fight
                    Details.tabela_vigente.is_boss = nil
                    
                    --> tag the combat as mythic dungeon trash
                    local zoneName, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapID, instanceGroupSize = GetInstanceInfo()
                    Details.tabela_vigente.is_mythic_dungeon_trash = {
                        ZoneName = zoneName,
                        MapID = instanceMapID,
                        Level = _detalhes.MythicPlus.Level,
                        EJID = _detalhes.MythicPlus.ejID,
                    }
                else
                    DetailsMythicPlusFrame.BossDefeated (false, combatObject.is_boss.id, combatObject.is_boss.name, combatObject.is_boss.diff, 5, 1)
                end
            end
            
        end
    
    elseif (event == "COMBAT_ENCOUNTER_START") then
        --> ignore the event if ignoring mythic dungeon special treatment
        if (_detalhes.streamer_config.disable_mythic_dungeon) then
            return
        end
        
        local encounterID, encounterName, difficultyID, raidSize, endStatus = ...
        --nothing
    
    elseif (event == "COMBAT_ENCOUNTER_END") then
        --> ignore the event if ignoring mythic dungeon special treatment
        if (_detalhes.streamer_config.disable_mythic_dungeon) then
            return
        end
        
        local encounterID, encounterName, difficultyID, raidSize, endStatus = ...
        --nothing

    elseif (event == "COMBAT_MYTHICDUNGEON_START") then
    
        local lower_instance = _detalhes:GetLowerInstanceNumber()
        if (lower_instance) then
            lower_instance = _detalhes:GetInstance (lower_instance)
            if (lower_instance) then
                C_Timer.After (3, function()
                    if (lower_instance:IsEnabled()) then
                        --todo, need localization
                        lower_instance:InstanceAlert ("Details!" .. " " .. "Damage" .. " " .. "Meter", {[[Interface\AddOns\Details\images\minimap]], 16, 16, false}, 3, {function() end}, false, true)
                    end
                end)
            end
        end
    
        --> ignore the event if ignoring mythic dungeon special treatment
        if (_detalhes.streamer_config.disable_mythic_dungeon) then
            return
        end
        
        --> reset spec cache if broadcaster requested
        if (_detalhes.streamer_config.reset_spec_cache) then
            wipe (_detalhes.cached_specs)
        end
        
        C_Timer.After (0.5, DetailsMythicPlusFrame.OnChallengeModeStart)
    
    elseif (event == "COMBAT_MYTHICDUNGEON_END") then
        
        --> ignore the event if ignoring mythic dungeon special treatment
        if (_detalhes.streamer_config.disable_mythic_dungeon) then
            return
        end
        
        --> delay to wait the encounter_end trigger first
        --> assuming here the party cleaned the mobs kill objective before going to kill the last boss
        C_Timer.After (2, DetailsMythicPlusFrame.MythicDungeonFinished)
    
    end
end

DetailsMythicPlusFrame:SetScript ("OnEvent", function (_, event, ...)

    if (event == "START_TIMER") then
        DetailsMythicPlusFrame.LastTimer = GetTime()
        
    elseif (event == "ZONE_CHANGED_NEW_AREA") then
        if (DetailsMythicPlusFrame.IsDoingMythicDungeon) then
            if (DetailsMythicPlusFrame.DevelopmentDebug) then
                print ("Details!", event, ...)
                print ("Zone changed and is Doing Mythic Dungeon")
            end
            
            --> ignore the event if ignoring mythic dungeon special treatment
            if (_detalhes.streamer_config.disable_mythic_dungeon) then
                return
            end
            
            local _, _, difficulty, _, _, _, _, currentZoneID = GetInstanceInfo()
            if (currentZoneID ~= Details.MythicPlus.DungeonID) then
                if (DetailsMythicPlusFrame.DevelopmentDebug) then
                    print ("Zone changed and the zone is different than the dungeon")
                end
                
                --> send mythic dungeon end event
                _detalhes:SendEvent ("COMBAT_MYTHICDUNGEON_END")
                
                --> finish the segment
                DetailsMythicPlusFrame.BossDefeated (true)
                
                --> finish the mythic run
                DetailsMythicPlusFrame.MythicDungeonFinished (true)
            end
        end
        
    end
    
end)
