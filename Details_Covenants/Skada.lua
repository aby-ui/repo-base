local _, dc = ...
local oribos = _G.Oribos

function dc:replaceSkadaImplmentation()
    if _G.Skada then
        _G.Skada.get_player = function(self, set, playerid, playername)
            local covenantPrefix = ""
            local covenantSuffix = ""

            if DCovenant["iconAlign"] == "right" then
                covenantSuffix = " "..oribos:getCovenantIconForPlayer(playername)
            else 
                covenantPrefix = oribos:getCovenantIconForPlayer(playername).." "
            end 
            
            -- Add player to set if it does not exist.
            local player = Skada:find_player(set, playerid)

            if not player then
                -- If we do not supply a playername (often the case in submodes), we can not create an entry.
                if not playername then
                    return
                end

                local _, playerClass = UnitClass(playername)
                local playerRole = UnitGroupRolesAssigned(playername)
                player = {id = playerid, class = playerClass, role = playerRole, name = playername, first = time(), ["time"] = 0}

                -- Tell each mode to apply its needed attributes.
                for i, mode in ipairs(_G.Skada:GetModes(nil)) do
                    if mode.AddPlayerAttributes ~= nil then
                        mode:AddPlayerAttributes(player, set)
                    end
                end

                -- Strip realm name
                -- This is done after module processing due to cross-realm names messing with modules (death log for example, which needs to do UnitHealthMax on the playername).
                local player_name, realm = string.split("-", playername, 2)
                player.name = covenantPrefix..(player_name or playername)..covenantSuffix

                tinsert(set.players, player)
            end

            if player.name == UNKNOWN and playername ~= UNKNOWN then -- fixup players created before we had their info
                local player_name, realm = string.split("-", playername, 2)
                player.name = covenantPrefix..(player_name or playername)..covenantSuffix
                local _, playerClass = UnitClass(playername)
                local playerRole = UnitGroupRolesAssigned(playername)
                player.class = playerClass
                player.role = playerRole
            end


            -- The total set clears out first and last timestamps.
            if not player.first then
                player.first = time()
            end

            -- Mark now as the last time player did something worthwhile.
            player.last = time()
            changed = true
            return player
        end
    end  
end
