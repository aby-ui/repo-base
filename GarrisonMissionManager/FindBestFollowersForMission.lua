local addon_name, addon_env = ...

local c_garrison_cache = addon_env.c_garrison_cache

-- [AUTOLOCAL START]
local AddFollowerToMission = C_Garrison.AddFollowerToMission
local After = C_Timer.After
local C_Garrison = C_Garrison
local CreateFrame = CreateFrame
local dump = DevTools_Dump
local GARRISON_CURRENCY = GARRISON_CURRENCY
local GARRISON_FOLLOWER_MAX_LEVEL = GARRISON_FOLLOWER_MAX_LEVEL
local GARRISON_SHIP_OIL_CURRENCY = GARRISON_SHIP_OIL_CURRENCY
local GarrisonMissionFrame = GarrisonMissionFrame
local GetFramesRegisteredForEvent = GetFramesRegisteredForEvent
local GetMissionCost = C_Garrison.GetMissionCost
local GetNumFollowersOnMission = C_Garrison.GetNumFollowersOnMission
local GetPartyMissionInfo = C_Garrison.GetPartyMissionInfo
local LE_FOLLOWER_TYPE_GARRISON_6_0 = LE_FOLLOWER_TYPE_GARRISON_6_0
local LE_FOLLOWER_TYPE_GARRISON_7_0 = LE_FOLLOWER_TYPE_GARRISON_7_0
local pairs = pairs
local print = print
local RemoveFollowerFromMission = C_Garrison.RemoveFollowerFromMission
local sfind = string.find
local tinsert = table.insert
local tremove = table.remove
local type = type
local wipe = wipe
-- [AUTOLOCAL END]

addon_env.event_frame = addon_env.event_frame or CreateFrame("Frame")
local event_frame = addon_env.event_frame
local RegisterEvent = event_frame.RegisterEvent
local UnregisterEvent = event_frame.UnregisterEvent

-- local prof = time_record.new():ldb_register('GMM - FindBestFollowersForMission')
-- local timer = prof.timer

local top = {{}, {}, {}, {}}
local top_yield = {{}, {}, {}, {}}
local top_unavailable = {{}, {}, {}, {}}

local min, max = {}, {}
local best_modes = { "success" }
local best_mode_unavailable = {}
local preserve_mission_page_followers = {}

local FindBestFollowersForMission_compare

local debug_follower
local debug_follower_string
local function debug_report_group(follower1, follower2, follower3, ...)
   if not debug_follower then debug_follower = {} end
   if not debug_follower_string then debug_follower_string = {} end

   debug_follower[1] = follower1
   debug_follower[2] = follower2
   debug_follower[3] = follower3

   for idx = 1, 3 do
      if debug_follower[idx] then
         local name = debug_follower[idx].name
         local garrFollowerID = debug_follower[idx].garrFollowerID

         if false then
         elseif garrFollowerID == 659 then name = "T.Appr.-FHuman"
         elseif garrFollowerID == 716 then name = "Kalec"
         elseif garrFollowerID == 717 then name = "Modera"
         elseif garrFollowerID == 724 then name = "A.Destroyer"
         elseif garrFollowerID == 726 then name = "Esara"
         elseif garrFollowerID == 822 then name = "T.Appr.-MElf"
         end

         debug_follower_string[idx] = name .. "-" .. garrFollowerID
      else
         debug_follower_string[idx] = "."
      end
   end
   print(debug_follower_string[1] .. " * " .. debug_follower_string[2] .. " * " .. debug_follower_string[3] .. " :: ", ...)
end

-- dd7e31478690-alpha typo debug - c/p to: if xp_only_rewards then
-- if successChance_clamped >= 90 then
--    debug_report_group(follower1, follower2, follower3, follower_is_busy_for_mission, prev_successChance, prev_successChance_clamped, prev_top.followers_not_maxed, successChance, successChance_clamped, followers_not_maxed)
-- end

local function FindBestFollowersForMission(mission, followers, mode)
   local compare_top_1
   if FindBestFollowersForMission_compare then
      FindBestFollowersForMission_compare(mission, followers, mode)
      compare_top_1 = {}
      for key, val in pairs(top[1]) do
         compare_top_1[key] = val
      end
   end

   local followers_count = #followers

   local top_entries = mode == "mission_list" and 1 or 3

   for idx = 1, top_entries do
      wipe(top[idx])
      wipe(top_yield[idx])
      wipe(top_unavailable[idx])
      top.yield = nil
   end

   local mission_frame = _G[GarrisonFollowerOptions[followers.type].missionFrame]
   local type70 = (followers.type == LE_FOLLOWER_TYPE_GARRISON_7_0 or followers.type == LE_FOLLOWER_TYPE_GARRISON_8_0)

   local slots = mission.numFollowers
   if (slots > followers_count and not type70) or addon_env.b then return end

   local event_handlers = { GetFramesRegisteredForEvent("GARRISON_FOLLOWER_LIST_UPDATE") }
   -- TODO: this can break everything else if player initiates combat and gets "too slow" before handlers are returned
   -- TODO: restoration of events and previous followers should be put in separate function and called through .After
   for idx = 1, #event_handlers do UnregisterEvent(event_handlers[idx], "GARRISON_FOLLOWER_LIST_UPDATE") end

   local mission_id = mission.missionID
   local MissionPage = mission_frame.MissionTab.MissionPage
   local MissionPageFollowers = MissionPage.Followers
   local party_followers_count = #MissionPageFollowers
   if party_followers_count > 0 then
      for party_idx = 1, party_followers_count do
         preserve_mission_page_followers[party_idx] = MissionPageFollowers[party_idx].info
      end
   end

   if GetNumFollowersOnMission(mission_id) > 0 then
      for idx = 1, followers_count do
         RemoveFollowerFromMission(mission_id, followers[idx].followerID)
      end
   end

   local baseCost, cost = GetMissionCost(mission_id)
   local increased_cost = cost > baseCost
   local _, base_totalTimeSeconds = GetPartyMissionInfo(mission_id)

   for idx = 1, slots do
      max[idx] = followers_count - slots + idx
      min[idx] = nil
   end
   for idx = slots + 1, 3 do
      max[idx] = followers_count + 1
      min[idx] = followers_count + 1
   end

   if type70 then
      for idx = followers_count, 1, -1 do
         if not followers[idx].isTroop then
            max[1] = idx
            break
         end
      end
      for idx = 2, 3 do
         max[idx] = followers_count + 1
      end
   end

   local best_modes_count = 1

   local material_rewards
   local xp_only_rewards
   local gold_rewards
   for _, reward in pairs(mission.rewards) do
      local currencyID = reward.currencyID
      if currencyID == 823 --[[Apexis]] then material_rewards = currencyID end
      if currencyID == GARRISON_SHIP_OIL_CURRENCY and (not material_rewards or material_rewards == GARRISON_CURRENCY) then material_rewards = currencyID end
      if currencyID == GARRISON_CURRENCY and not material_rewards then material_rewards = currencyID end
      if currencyID == 0 then gold_rewards = true end
      if reward.followerXP and xp_only_rewards == nil then xp_only_rewards = true end
      if not reward.followerXP then xp_only_rewards = false end
   end

   local mission_type = mission.type
   if mission_type == "Ship-Legendary" or sfind(mission_type, "Ship-Siege", 1, true) == 1 then
      xp_only_rewards = false
   end

   if mode ~= "mission_list" then
      if gold_rewards then
         best_modes_count = best_modes_count + 1
         best_modes[best_modes_count] = "gold_yield"
      elseif material_rewards then
         best_modes_count = best_modes_count + 1
         best_modes[best_modes_count] = "material_yield"
      end
   end

   local salvage_yard_level = followers.type == LE_FOLLOWER_TYPE_GARRISON_6_0 and c_garrison_cache.salvage_yard_level
   local all_followers_maxed = followers.all_maxed

   local overmax_reward = mission.overmaxRewards
   overmax_reward = #overmax_reward > 0

   local follower1_added, follower2_added, follower3_added

   -- for prof_runs = 1, mode ~= "mission_list" and 100 or 1 do local prof_start = timer()

   for i1 = 1, max[1] do
      local follower1 = followers[i1]
      local follower1_id = follower1.followerID
      local follower1_maxed = follower1.levelXP == 0 and 1 or 0
      local follower1_level = follower1.isMaxLevel and follower1.iLevel or follower1.level
      local follower1_busy = follower1.is_busy_for_mission and 1 or 0
      local follower1_is_troop = follower1.isTroop and 1 or 0
      local follower1_not_maxed = (follower1_is_troop == 0 and follower1_maxed == 0) and 1 or 0
      local follower1_quality = follower1.quality
      local prev_follower2_troop_uniq
      for i2 = min[2] or (i1 + 1), max[2] do
         local follower2_maxed = 0
         local follower2 = followers[i2]
         local follower2_id
         local follower2_level = 0
         local follower2_busy = 0
         local follower2_is_troop = 0
         local follower2_troop_uniq
         local follower2_not_maxed = 0
         local follower2_quality = 0
         if follower2 then
            follower2_id = follower2.followerID
            if follower2.levelXP == 0 then follower2_maxed = 1 end
            follower2_level = follower2.isMaxLevel and follower2.iLevel or follower2.level
            if follower2.is_busy_for_mission then follower2_busy = 1 end
            if follower2.isTroop then
               follower2_is_troop = 1
               -- Only used to remove "duplicate" teams with different instance of same troop class
               follower2_troop_uniq = follower2.troop_uniq .. (follower2_busy == 1 and 'b' or '')
            end
            follower2_not_maxed = (follower2_is_troop == 0 and follower2_maxed == 0) and 1 or 0
            follower2_quality = follower2.quality
         end
         -- Special handling to calculate precisely one team for 1 filled slot in 3 members missions.
         local i3_start = min[3] or (i2 + 1)
         if type70 then
            if i2 == followers_count + 1 then i3_start = followers_count + 1 end
         end
         local prev_follower3_troop_uniq
         for i3 = i3_start, max[3] do
            local follower3_maxed = 0
            local follower3 = followers[i3]
            local follower3_id
            local follower3_level = 0
            local follower3_busy = 0
            local follower3_is_troop = 0
            local follower3_troop_uniq
            local follower3_not_maxed = 0
            local follower3_quality = 0
            if follower3 then
               follower3_id = follower3.followerID
               if follower3.levelXP == 0 then follower3_maxed = 1 end
               follower3_level = follower3.isMaxLevel and follower3.iLevel or follower3.level
               if follower3.is_busy_for_mission then follower3_busy = 1 end
               if follower3.isTroop then
                  follower3_is_troop = 1
                  -- Only used to remove "duplicate" teams with different instance of same troop class
                  follower3_troop_uniq = follower3.troop_uniq .. (follower3_busy == 1 and 'b' or '')
               end
               follower3_not_maxed = (follower3_is_troop == 0 and follower3_maxed == 0) and 1 or 0
               follower3_quality = follower3.quality
            end

            local followers_maxed = follower1_maxed + follower2_maxed + follower3_maxed
            local followers_troop = follower1_is_troop + follower2_is_troop + follower3_is_troop
            local followers_not_maxed = follower1_not_maxed + follower2_not_maxed + follower3_not_maxed

            -- at least one follower in party is busy (i.e. staus non-empty/non-party) for mission
            local follower_is_busy_for_mission = (follower1_busy + follower2_busy + follower3_busy) > 0

            local skip -- if set, skip this team completely

            if xp_only_rewards then
               -- Throw away teams that are completely filled with maxed out followers
               if followers_not_maxed == 0 then
                  -- However, if ALL free followers are maxed and we have salvage yard - don't.
                  if not (salvage_yard_level and all_followers_maxed) then
                     skip = true
                  end
               end
            end

            -- Throw away "potential" teams with busy followers if we're just calculating one button for mission list
            if not skip and (mode == "mission_list" and follower_is_busy_for_mission) then
               skip = true
            end

            if not skip and (follower2_is_troop == 1 and follower2_troop_uniq == prev_follower2_troop_uniq) then
               skip = true
            end

            if not skip and (follower3_is_troop == 1 and follower3_troop_uniq == prev_follower3_troop_uniq) then
               skip = true
            end

            if not skip then
               if follower3_added ~= follower3_id then
                  if follower3_added then RemoveFollowerFromMission(mission_id, follower3_added) end
                  if follower3_id then AddFollowerToMission(mission_id, follower3_id) end
                  follower3_added = follower3_id
               end

               if follower2_added ~= follower2_id then
                  if follower2_added then RemoveFollowerFromMission(mission_id, follower2_added) end
                  if follower2_id then AddFollowerToMission(mission_id, follower2_id) end
                  follower2_added = follower2_id
               end

               if follower1_added ~= follower1_id then
                  if follower1_added then RemoveFollowerFromMission(mission_id, follower1_added) end
                  AddFollowerToMission(mission_id, follower1_id)
                  follower1_added = follower1_id
               end

               -- Calculate result
               local follower_level_total = follower1_level + follower2_level + follower3_level
               local follower_quality_total = follower1_quality + follower2_quality + follower3_quality

               local totalTimeString, totalTimeSeconds, isMissionTimeImproved, successChance, partyBuffs, isEnvMechanicCountered, xpBonus, materialMultiplier, goldMultiplier = GetPartyMissionInfo(mission_id)
               local cost = 0
               if type70 then
                  local baseCost
                  baseCost, cost = GetMissionCost(mission_id)
               end

               -- Uh, thanks 6.2, for lots of new calls and tables going directly to garbage right in the middle of most computational heavy loop.
               materialMultiplier = materialMultiplier[material_rewards] or 1
               isEnvMechanicCountered = isEnvMechanicCountered and 1 or 0
               local buffCount = #partyBuffs

               local saved_best_modes
               local saved_best_modes_count
               if follower_is_busy_for_mission then
                  saved_best_modes = best_modes
                  saved_best_modes_count = best_modes_count
                  best_modes = best_mode_unavailable
                  best_mode_unavailable[1] = material_rewards and "material_yield" or (gold_rewards and "gold_yield" or "success")
                  best_modes_count = 1
               end

               for best_modes_idx = 1, best_modes_count do
                  local mode = best_modes[best_modes_idx]
                  local material_yield
                  if material_rewards then
                     material_yield = materialMultiplier * successChance
                  end

                  local gold_yield
                  if gold_rewards then
                     gold_yield = goldMultiplier * successChance
                  end

                  local top_list
                  if follower_is_busy_for_mission then
                     top_list = top_unavailable
                  elseif mode == 'material_yield' or mode == 'gold_yield' then
                     top_list = top_yield
                  else
                     top_list = top
                  end

                  for idx = 1, top_entries do
                     local prev_top = top_list[idx]

                     local found
                     repeat -- Checking if new candidate for top is better than any top 3 already sored

                        if not follower_is_busy_for_mission and (
                           (mode == "material_yield" and materialMultiplier == 1) or
                           (mode == "gold_yield" and goldMultiplier == 1)
                        ) then
                           -- No reason to place non-boosted team in special sorting list,
                           -- success chance top will be better or same anyway, unless it is "unavailable" list.
                           break
                        end

                        if not prev_top[1] then found = true break end

                        local prev_followers_troop = prev_top.followers_troop
                        local prev_successChance = prev_top.successChance
                        local prev_followers_maxed = prev_top.followers_maxed

                        if mode == 'unconditional_minimize_troops' then
                           if prev_followers_troop < followers_troop then break end
                           if prev_followers_troop > followers_troop then found = true break end
                        end

                        -- If mission have XP-only rewards:
                        -- 1) Check that we meet at least 100%.
                        -- 2) Check that we have as many unmaxed followers as possible
                        -- 3) If there's overmax reward - check for biggest success chance
                        if xp_only_rewards then
                           local prev_successChance_clamped = prev_successChance > 100 and 100 or prev_successChance
                           local successChance_clamped = successChance > 100 and 100 or successChance

                           if prev_successChance_clamped > successChance_clamped then break end
                           if prev_successChance_clamped < successChance_clamped then found = true break end

                           local prev_followers_not_maxed = prev_top.followers_not_maxed

                           if prev_followers_not_maxed > followers_not_maxed then break end
                           if prev_followers_not_maxed < followers_not_maxed then found = true break end

                           if overmax_reward then
                              if prev_successChance < successChance then found = true break end
                              if prev_successChance > successChance then break end
                           end
                        end

                        local prev_material_yield = prev_top.material_yield
                        if mode == 'material_yield' then
                           if prev_material_yield < material_yield then found = true break end
                           if prev_material_yield > material_yield then break end
                        end

                        local c_gold_yield = prev_top.gold_yield
                        if mode == 'gold_yield' then
                           if c_gold_yield < gold_yield then found = true break end
                           if c_gold_yield > gold_yield then break end
                        end

                        if not type70 or overmax_reward then -- TODO: FollowerOptions
                           if prev_successChance < successChance then found = true break end
                           if prev_successChance > successChance then break end
                        else
                           -- No point in going over 100%. Try to find team >= 100%, but with as little overkill as posible.
                           local prev_successChance_clamped
                           local successChance_clamped
                           local prev_successChance_over
                           local successChance_over
                           if prev_successChance > 100 then
                              prev_successChance_clamped = 100
                              prev_successChance_over = prev_successChance - 100
                           else
                              prev_successChance_clamped = prev_successChance
                              prev_successChance_over = 0
                           end
                           if successChance > 100 then
                              successChance_clamped = 100
                              successChance_over = successChance - 100
                           else
                              successChance_clamped = successChance
                              successChance_over = 0
                           end

                           if prev_successChance_clamped > successChance_clamped then break end
                           if prev_successChance_clamped < successChance_clamped then found = true break end

                           if prev_successChance_over < successChance_over then break end
                           if prev_successChance_over > successChance_over then found = true break end
                        end

                        if material_rewards then
                           local prev_materialMultiplier = prev_top.materialMultiplier
                           if prev_materialMultiplier < materialMultiplier then found = true break end
                           if prev_materialMultiplier > materialMultiplier then break end
                        end

                        if prev_followers_maxed > followers_maxed then found = true break end
                        if prev_followers_maxed < followers_maxed then break end

                        local prev_xpBonus = prev_top.xpBonus
                        -- Maximize XP bonus only if party have unmaxed followers
                        if followers_not_maxed > 0 then
                           if prev_xpBonus < xpBonus then found = true break end
                           if prev_xpBonus > xpBonus then break end
                        end

                        local cTotalTimeSeconds = prev_top.totalTimeSeconds
                        if cTotalTimeSeconds > totalTimeSeconds then found = true break end
                        if cTotalTimeSeconds < totalTimeSeconds then break end

                        local prev_cost = prev_top.cost
                        if prev_cost > cost then found = true break end
                        if prev_cost < cost then break end

                        local c_follower_level_total = prev_top.follower_level_total
                        if c_follower_level_total > follower_level_total then found = true break end
                        if c_follower_level_total < follower_level_total then break end

                        -- Maximize material/gold yield in general mode when possible too
                        if material_rewards then
                           if prev_material_yield < material_yield then found = true break end
                           if prev_material_yield > material_yield then break end
                        end

                        if gold_rewards then
                           if c_gold_yield < gold_yield then found = true break end
                           if c_gold_yield > gold_yield then break end
                        end

                        local prev_follower_quality_total = prev_top.follower_quality_total
                        if prev_follower_quality_total > follower_quality_total then found = true break end
                        if prev_follower_quality_total < follower_quality_total then break end

                        -- Minimize XP bonus if all followers are maxed, because it indicates either overkill or XP-bonus traits better used elsewhere
                        -- but only if there are unmaxed followers. Otherwise minimize it after other optimizations.
                        if not all_followers_maxed then
                           if followers_not_maxed == 0 then
                              if prev_xpBonus > xpBonus then found = true break end
                              if prev_xpBonus < xpBonus then break end
                           end
                        end

                        -- Minimize material/gold multiplier if possible if no corresponding reward is available.
                        if not material_rewards then
                           local prev_materialMultiplier = prev_top.materialMultiplier
                           if prev_materialMultiplier > materialMultiplier then found = true break end
                           if prev_materialMultiplier < materialMultiplier then break end
                        end

                        if not gold_rewards then
                           local c_gold_multiplier = prev_top.goldMultiplier
                           if c_gold_multiplier > goldMultiplier then found = true break end
                           if c_gold_multiplier < goldMultiplier then break end
                        end

                        local cBuffCount = prev_top.buffCount
                        if cBuffCount > buffCount then found = true break end
                        if cBuffCount < buffCount then break end

                        if all_followers_maxed then
                           if slots == followers_maxed then
                              if prev_xpBonus > xpBonus then found = true break end
                              if prev_xpBonus < xpBonus then break end
                           end
                        end

                        local cIsEnvMechanicCountered = prev_top.isEnvMechanicCountered
                        if cIsEnvMechanicCountered > isEnvMechanicCountered then found = true break end
                        if cIsEnvMechanicCountered < isEnvMechanicCountered then break end
                     until true

                     if found then
                        local all_followers_maxed_on_mission = followers_not_maxed == 0
                        local new = top_list[4]
                        new[1] = follower1
                        new[2] = follower2
                        new[3] = follower3
                        new.successChance = successChance
                        new.materialMultiplier = materialMultiplier
                        new.goldMultiplier = goldMultiplier
                        new.material_rewards = material_rewards
                        new.gold_rewards = gold_rewards
                        new.xpBonus = xpBonus
                        new.totalTimeSeconds = totalTimeSeconds
                        new.isMissionTimeImproved = isMissionTimeImproved or (base_totalTimeSeconds > totalTimeSeconds)
                        new.followers_maxed = followers_maxed
                        new.buffCount = buffCount
                        new.isEnvMechanicCountered = isEnvMechanicCountered
                        new.material_yield = material_yield
                        new.gold_yield = gold_yield
                        new.xp_reward_wasted = xp_only_rewards and all_followers_maxed_on_mission
                        new.all_followers_maxed = all_followers_maxed_on_mission
                        new.follower_level_total = follower_level_total
                        new.follower_quality_total = follower_quality_total
                        new.mission_level = mission.level
                        new.followers_troop = followers_troop
                        new.cost = cost
                        new.followers_not_maxed = followers_not_maxed
                        tinsert(top_list, idx, new)
                        top_list[5] = nil
                        break
                     end
                  end
               end

               if follower_is_busy_for_mission then
                  best_modes = saved_best_modes
                  best_modes_count = saved_best_modes_count
               end
            end
            prev_follower3_troop_uniq = follower3_troop_uniq
         end -- for i3
         prev_follower2_troop_uniq = follower2_troop_uniq
      end -- for i2
   end -- for i1

   if follower1_added then RemoveFollowerFromMission(mission_id, follower1_added) end
   if follower2_added then RemoveFollowerFromMission(mission_id, follower2_added) end
   if follower3_added then RemoveFollowerFromMission(mission_id, follower3_added) end

   -- local prof_end = timer() if mode ~= "mission_list" then prof:record("permutation loop - mission page", prof_end - prof_start) end end

   top.material_rewards = material_rewards
   top.gold_rewards = gold_rewards

   -- TODO:
   -- If we have material/gold yield list, check it and remove all entries where material_yield is worse than #1 from regular top list.
   -- dump(top[1])

   if party_followers_count > 0 then
      for party_idx = 1, party_followers_count do
         if preserve_mission_page_followers[party_idx] then
            AddFollowerToMission(mission_id, preserve_mission_page_followers[party_idx].followerID)
         end
      end
      if MissionPage:IsVisible() then mission_frame:UpdateMissionParty(MissionPageFollowers) end
   end

   if compare_top_1 then
      local diff
      for key, val in pairs(top[1]) do
         if compare_top_1[key] ~= val and key ~= "cost" then
            print("compare diff", key,
               type(compare_top_1[key]) == "table" and compare_top_1[key].name or compare_top_1[key],
               type(val) == "table" and val.name or val
            )
            diff = true
         end
         compare_top_1[key] = nil
      end
      for key, val in pairs(compare_top_1) do
         print("compare extra", key, val)
         diff = true
      end
      if not diff then print("compare no diffs") end
   end

   for idx = 1, #event_handlers do RegisterEvent(event_handlers[idx], "GARRISON_FOLLOWER_LIST_UPDATE") end

   -- dump(top)
   -- local location, xp, environment, environmentDesc, environmentTexture, locPrefix, isExhausting, enemies = C_Garrison.GetMissionInfo(missionID);
   -- /run GMM_dumpl("location, xp, environment, environmentDesc, environmentTexture, locPrefix, isExhausting, enemies", C_Garrison.GetMissionInfo(GarrisonMissionFrame.MissionTab.MissionPage.missionInfo.missionID))
   -- /run GMM_dumpl("totalTimeString, totalTimeSeconds, isMissionTimeImproved, successChance, partyBuffs, isEnvMechanicCountered, xpBonus, materialMultiplier", C_Garrison.GetPartyMissionInfo(GarrisonMissionFrame.MissionTab.MissionPage.missionInfo.missionID))
   -- /run GMM_dumpl("totalTimeString, totalTimeSeconds, isMissionTimeImproved, successChance, partyBuffs, isEnvMechanicCountered, xpBonus, materialMultiplier", C_Garrison.GetPartyMissionInfo(OrderHallMissionFrame.MissionTab.MissionPage.missionInfo.missionID))
end
addon_env.FindBestFollowersForMission = FindBestFollowersForMission
addon_env.top = top
addon_env.top_yield = top_yield
addon_env.top_unavailable = top_unavailable
