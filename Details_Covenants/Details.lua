local _, dc = ...
local oribos = _G.Oribos
local detalhes = _G._detalhes

function dc:replaceDetailsImplmentation()
	detalhes = detalhes or _G._detalhes
    if _G.NickTag and detalhes then
        if DCovenant["detailsIgnoreNickname"] == true then
            detalhes.ignore_nicktag = false
        end
        
        detalhes.GetNickname = function(self, playerName, default, silent)
            local covenantPrefix = ""
            local covenantSuffix = ""

            if default == false then
                if DCovenant["iconAlign"] == "right" then
                    covenantSuffix = " "..oribos:getCovenantIconForPlayer(playerName)
                else 
                    covenantPrefix = oribos:getCovenantIconForPlayer(playerName).." "
                end 
            end

            if DCovenant["detailsIgnoreNickname"] == true then
                local name_without_nicktag = playerName

                if (detalhes.remove_realm_from_name) then
                    name_without_nicktag = name_without_nicktag:gsub (("%-.*"), "")
                end

                return covenantPrefix..name_without_nicktag..covenantSuffix
            end

            if (not silent) then
                assert (type (playerName) == "string", "NickTag 'GetNickname' expects a string or string on #1 argument.")
            end
            
            local _table = NickTag:GetNicknameTable (playerName)
            if (not _table) then
                if (detalhes.remove_realm_from_name) then
                    playerName = playerName:gsub (("%-.*"), "")
                end

                return covenantPrefix..playerName..covenantSuffix or nil
            end
            
            local nickName = _table[1]
            if nickName then
                if TemniUgolok_SetEmojiToDetails then
                    return covenantPrefix..TemniUgolok_SetEmojiToDetails(_table[1])..covenantSuffix
                else 
                    return covenantPrefix.._table[1]..covenantSuffix
                end 
            else
                return default or nil
            end
        end
    end
end
