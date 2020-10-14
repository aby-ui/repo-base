

local Details = _G.Details
local textAlpha = 0.9
local AceLocale = LibStub ("AceLocale-3.0")
local L = AceLocale:GetLocale ( "Details" )

local on_deathrecap_line_enter = function (self)
	if (self.spellid) then
		GameTooltip:SetOwner (self, "ANCHOR_RIGHT")
		Details:GameTooltipSetSpellByID (self.spellid)
		self:SetBackdropColor (.3, .3, .3, .2)
		GameTooltip:Show()
		self.backgroundTextureOverlay:Show()
		self.timeAt:SetAlpha (1)
		self.sourceName:SetAlpha (1)
		self.amount:SetAlpha (1)
		self.lifePercent:SetAlpha (1)
	end
end

local on_deathrecap_line_leave = function (self)
	GameTooltip:Hide()
	self:SetBackdropColor (.3, .3, .3, 0)
	self.backgroundTextureOverlay:Hide()
	self.timeAt:SetAlpha (textAlpha)
	self.sourceName:SetAlpha (textAlpha)
	self.amount:SetAlpha (textAlpha)
	self.lifePercent:SetAlpha (textAlpha)
end

local create_deathrecap_line = function (parent, n)
	local line = CreateFrame ("frame", "DetailsDeathRecapLine" .. n, parent, "BackdropTemplate")
	line:SetPoint ("topleft", parent, "topleft", 10, (-24 * n) - 17)
	line:SetPoint ("topright", parent, "topright", -10, (-24 * n) - 17)
	line:SetScript ("OnEnter", on_deathrecap_line_enter)
	line:SetScript ("OnLeave", on_deathrecap_line_leave)
	
	line:SetSize (300, 21)

	local timeAt = line:CreateFontString (nil, "overlay", "GameFontNormal")
	local backgroundTexture = line:CreateTexture (nil, "border")
	local backgroundTextureOverlay = line:CreateTexture (nil, "artwork")
	local spellIcon = line:CreateTexture (nil, "overlay")
	local spellIconBorder = line:CreateTexture (nil, "overlay")
	spellIcon:SetDrawLayer ("overlay", 1)
	spellIconBorder:SetDrawLayer ("overlay", 2)
	local sourceName = line:CreateFontString (nil, "overlay", "GameFontNormal")
	local amount = line:CreateFontString (nil, "overlay", "GameFontNormal")
	local lifePercent = line:CreateFontString (nil, "overlay", "GameFontNormal")
	local lifeStatusBar = line:CreateTexture(nil, "border", nil, -3)
	
	--grave icon
	local graveIcon = line:CreateTexture (nil, "overlay")
	graveIcon:SetTexture ([[Interface\MINIMAP\POIIcons]])
	graveIcon:SetTexCoord (146/256, 160/256, 0/512, 18/512)
	graveIcon:SetPoint ("left", line, "left", 11, 0)
	graveIcon:SetSize (14, 18)
	
	--spell icon
	spellIcon:SetSize (19, 19)
	spellIconBorder:SetTexture ([[Interface\ENCOUNTERJOURNAL\LootTab]])
	spellIconBorder:SetTexCoord (6/256, 38/256, 49/128, 81/128)
	spellIconBorder:SetSize (20, 20)
	spellIconBorder:SetPoint ("topleft", spellIcon, "topleft", 0, 0)

	--locations
	timeAt:SetPoint ("left", line, "left", 2, 0)
	spellIcon:SetPoint ("left", line, "left", 50, 0)
	sourceName:SetPoint ("left", line, "left", 82, 0)
	amount:SetPoint ("left", line, "left", 240, 0)
	lifePercent:SetPoint ("left", line, "left", 320, 0)
	
	--text colors
	Details.gump:SetFontColor (amount, "red")
	Details.gump:SetFontColor (timeAt, "gray")
	Details.gump:SetFontColor (sourceName, "yellow")
	
	Details.gump:SetFontSize (sourceName, 10)

	--text alpha
	timeAt:SetAlpha (textAlpha)
	sourceName:SetAlpha (textAlpha)
	amount:SetAlpha (textAlpha)
	lifePercent:SetAlpha (textAlpha)
	
	--text setup
	amount:SetWidth (85)
	amount:SetJustifyH ("right")
	lifePercent:SetWidth (42)
	lifePercent:SetJustifyH ("right")
	
	--life statusbar
	lifeStatusBar:SetPoint("topleft", line, "topleft")
	lifeStatusBar:SetPoint("bottomleft", line, "bottomleft")
	lifeStatusBar:SetColorTexture(0.5, 0.5, 0.5, 0.4)

	backgroundTexture:SetTexture ([[Interface\AddOns\Details\images\deathrecap_background]])
	backgroundTexture:SetTexCoord (0, 1, 0, 1)
	backgroundTexture:SetVertexColor (.1, .1, .1, .3)
	
	--top border
	local TopFader = line:CreateTexture (nil, "border")
	TopFader:SetTexture ([[Interface\AddOns\Details\images\deathrecap_background_top]])
	TopFader:SetTexCoord (0, 1, 0, 1)
	TopFader:SetVertexColor (.1, .1, .1, .3)
	TopFader:SetPoint ("bottomleft", backgroundTexture, "topleft", 0, -0)
	TopFader:SetPoint ("bottomright", backgroundTexture, "topright", 0, -0)
	TopFader:SetHeight (32)
	TopFader:Hide()
	line.TopFader = TopFader
	
	if (n == 10) then
		--bottom fader
		local backgroundTexture2 = line:CreateTexture (nil, "border")
		backgroundTexture2:SetTexture ([[Interface\AddOns\Details\images\deathrecap_background_bottom]])
		backgroundTexture2:SetTexCoord (0, 1, 0, 1)
		backgroundTexture2:SetVertexColor (.1, .1, .1, .3)	
		backgroundTexture2:SetPoint ("topleft", backgroundTexture, "bottomleft", 0, 0)
		backgroundTexture2:SetPoint ("topright", backgroundTexture, "bottomright", 0, 0)
		backgroundTexture2:SetHeight (32)

		Details.gump:SetFontSize (amount, 14)
		Details.gump:SetFontSize (lifePercent, 14)
		backgroundTexture:SetVertexColor (.2, .1, .1, .3)
	end
	
	backgroundTexture:SetPoint ("topleft", 0, 1)
	backgroundTexture:SetPoint ("bottomright", 0, -1)
	backgroundTexture:SetDesaturated (true)
	backgroundTextureOverlay:SetTexture ([[Interface\AdventureMap\AdventureMap]])
	backgroundTextureOverlay:SetTexCoord (460/1024, 659/1024, 330/1024, 350/1024)
	backgroundTextureOverlay:SetAllPoints()
	backgroundTextureOverlay:SetDesaturated (true)
	backgroundTextureOverlay:SetAlpha (0.5)
	backgroundTextureOverlay:Hide()
	
	line.timeAt = timeAt
	line.spellIcon = spellIcon
	line.sourceName = sourceName
	line.amount = amount
	line.lifePercent = lifePercent
	line.backgroundTexture = backgroundTexture
	line.backgroundTextureOverlay = backgroundTextureOverlay
	line.graveIcon = graveIcon
	line.lifeStatusBar = lifeStatusBar
	
	if (n == 10) then
		graveIcon:Show()
		line.timeAt:Hide()
	else
		graveIcon:Hide()
	end
	
	return line
end

local OpenDetailsDeathRecapAtSegment = function (segment)
	Details.OpenDetailsDeathRecap (segment, RecapID)
end

function Details.BuildDeathTableFromRecap (recapID)
	local events = DeathRecap_GetEvents (recapID)
	
	--check if it is a valid recap
	if (not events or #events <= 0) then
		DeathRecapFrame.Unavailable:Show()
		return
	end
	
	--build an death log using details format
	ArtificialDeathLog = {
		{}, --deathlog events
		(events [1] and events [1].timestamp) or (DeathRecapFrame and DeathRecapFrame.DeathTimeStamp) or 0, --time of death
		UnitName ("player"),
		select (2, UnitClass ("player")),
		UnitHealthMax ("player"),
		"0m 0s", --formated fight time
		["dead"] = true,
		["last_cooldown"] = false,
		["dead_at"] = 0,
		n = 1
	}

	for i = 1, #events do
		local evtData = events [i]
		local spellId, spellName, texture = DeathRecapFrame_GetEventInfo ( evtData )

		local ev = {
			true,
			spellId or 0,
			evtData.amount or 0,
			evtData.timestamp or 0, --?
			evtData.currentHP or 0,
			evtData.sourceName or "--x--x--",
			evtData.absorbed or 0,
			evtData.school or 0,
			false,
			evtData.overkill,
			not spellId and {spellId, spellName, texture},
		}
		
		tinsert (ArtificialDeathLog[1], ev)
		ArtificialDeathLog.n = ArtificialDeathLog.n + 1
	end
	
	return ArtificialDeathLog
end

function Details.GetDeathRecapFromChat()
	local chat1 = ChatFrame1
	local recapIDFromChat
	if (chat1) then
		local numLines = chat1:GetNumMessages()
		for i = numLines, 1, -1 do
			local text = chat1:GetMessageInfo (i)
			if (text) then
				if (text:find ("Hdeath:%d")) then
					local recapID = text:match ("|Hdeath:(%d+)|h")
					if (recapID) then
						recapIDFromChat = tonumber (recapID)
					end
					break
				end
			end
		end
	end
	
	if (recapIDFromChat) then
		Details.OpenDetailsDeathRecap (nil, recapIDFromChat, true)
		return
	end
end

function Details.OpenDetailsDeathRecap (segment, RecapID, fromChat)
    if (not Details.death_recap.enabled) then
        if (Details.DeathRecap and Details.DeathRecap.Lines) then
            for i = 1, 10 do
                Details.DeathRecap.Lines [i]:Hide()
            end
            for i, button in ipairs (Details.DeathRecap.Segments) do
                button:Hide()
            end
        end

        return
    end

    DeathRecapFrame.Recap1:Hide()
    DeathRecapFrame.Recap2:Hide()
    DeathRecapFrame.Recap3:Hide()
    DeathRecapFrame.Recap4:Hide()
    DeathRecapFrame.Recap5:Hide()
    
    if (not Details.DeathRecap) then
        Details.DeathRecap = CreateFrame ("frame", "DetailsDeathRecap", DeathRecapFrame, "BackdropTemplate")
        Details.DeathRecap:SetAllPoints()
        
        DeathRecapFrame.Title:SetText (DeathRecapFrame.Title:GetText() .. " (by Details!)")
        
        --lines
        Details.DeathRecap.Lines = {}
        for i = 1, 10 do
            Details.DeathRecap.Lines [i] = create_deathrecap_line (Details.DeathRecap, i)
        end
        
        --segments
        Details.DeathRecap.Segments = {}
        for i = 5, 1, -1 do
            local segmentButton = CreateFrame ("button", "DetailsDeathRecapSegmentButton" .. i, Details.DeathRecap, "BackdropTemplate")
            
            segmentButton:SetSize (16, 20)
            segmentButton:SetPoint ("topright", DeathRecapFrame, "topright", (-abs (i-6) * 22) - 10, -5)
            
            local text = segmentButton:CreateFontString (nil, "overlay", "GameFontNormal")
            segmentButton.text = text
            text:SetText ("#" .. i)
            text:SetPoint ("center")
            Details.gump:SetFontColor (text, "silver")
            
            segmentButton:SetScript ("OnClick", function()
                OpenDetailsDeathRecapAtSegment (i)
            end)
            tinsert (Details.DeathRecap.Segments, i, segmentButton)
        end
    end
    
    for i = 1, 10 do
        Details.DeathRecap.Lines [i]:Hide()
    end

    --segment to use
    local death = Details.tabela_vigente.last_events_tables
    
    --see if this segment has a death for the player
    local foundPlayer = false
    for index = #death, 1, -1 do
        if (death [index] [3] == Details.playername) then
            foundPlayer = true
            break
        end
    end

    --in case a combat has been created after the player death, the death won't be at the current segment
    if (not foundPlayer) then
        local segmentHistory = Details:GetCombatSegments()
        for i = 1, 2 do
            local segment = segmentHistory [1]
            if (segment and segment ~= Details.tabela_vigente) then
                if (Details.tabela_vigente.start_time - 3 < segment.end_time) then
                    death = segment.last_events_tables
                end
            end
        end
    end
    
    --segments
    if (Details.death_recap.show_segments) then
        local last_index = 0
        local buttonsInUse = {}
        for i, button in ipairs (Details.DeathRecap.Segments) do
            if (Details.tabela_historico.tabelas [i]) then
                button:Show()
                tinsert (buttonsInUse, button)
                Details.gump:SetFontColor (button.text, "silver")
                last_index = i
            else
                button:Hide()
            end
        end
        
        local buttonsInUse2 = {}
        for i = #buttonsInUse, 1, -1 do
            tinsert (buttonsInUse2, buttonsInUse[i])
        end
        for i = 1, #buttonsInUse2 do
            local button = buttonsInUse2 [i]
            button:ClearAllPoints()
            button:SetPoint ("topright", DeathRecapFrame, "topright", (-i * 22) - 10, -5)
        end
        
        if (not segment) then
            Details.gump:SetFontColor (Details.DeathRecap.Segments [1].text, "orange")
        else
            Details.gump:SetFontColor (Details.DeathRecap.Segments [segment].text, "orange")
            death = Details.tabela_historico.tabelas [segment] and Details.tabela_historico.tabelas [segment].last_events_tables
        end
        
    else
        for i, button in ipairs (Details.DeathRecap.Segments) do
            button:Hide()
        end
    end

    --if couldn't find the requested log from details!, so, import the log from the blizzard death recap
    --or if the player cliced on the chat link for the recap
    local ArtificialDeathLog
    if (not death or RecapID) then
        if (segment) then
            --nop, the player requested a death log from details it self but the log does not exists
            DeathRecapFrame.Unavailable:Show()
            return
        end

        --get the death events from the blizzard's recap
        ArtificialDeathLog = Details.BuildDeathTableFromRecap (RecapID)
    end
    
    DeathRecapFrame.Unavailable:Hide()
    
    --get the relevance config
    local relevanceTime = Details.death_recap.relevance_time

    local t
    if (ArtificialDeathLog) then
        t = ArtificialDeathLog
    else
        for index = #death, 1, -1 do
            if (death [index] [3] == Details.playername) then
                t = death [index]
                break
            end
        end
    end

    if (t) then
        local events = t [1]
        local timeOfDeath = t [2]
        
        local BiggestDamageHits = {}
        for i = #events, 1, -1 do
            tinsert (BiggestDamageHits, events [i])
        end
        table.sort (BiggestDamageHits, function (t1, t2) 
            return t1[3] > t2[3]
        end)
        for i = #BiggestDamageHits, 1, -1 do
            if (BiggestDamageHits [i][4] + relevanceTime < timeOfDeath) then
                tremove (BiggestDamageHits, i)
            end
        end
        
        --check if the event which killed the player is in the list, or addit to BiggestDamageHits
        local hitKill
        for i = #events, 1, -1 do
            local event = events [i]
            local evType = event [1]
            if (type (evType) == "boolean" and evType) then
                hitKill = event
                break
            end
        end
        if (hitKill) then
            local haveHitKill = false
            for index, t in ipairs (BiggestDamageHits) do
                if (t == hitKill) then
                    haveHitKill = true
                    break
                end
            end
            if (not haveHitKill) then
                tinsert (BiggestDamageHits, 1, hitKill)
            end
        end

        --check if there's at least 10 big events, if not fill with smaller events
        if (#BiggestDamageHits < 10) then
            for i = #events, 1, -1 do
                local event = events [i]
                local evType = event [1]
                if (type (evType) == "boolean" and evType) then
                    local alreadyHave = false
                    for index, t in ipairs (BiggestDamageHits) do
                        if (t == event) then
                            alreadyHave = true
                            break
                        end
                    end
                    if (not alreadyHave) then
                        tinsert (BiggestDamageHits, event)
                        if (#BiggestDamageHits == 10) then
                            break
                        end
                    end
                end
            end
        else
            --cut table to show only 10 events
            while (#BiggestDamageHits > 10) do 
                tremove (BiggestDamageHits, 11)
            end
        end

        if (#BiggestDamageHits == 0) then
            if (not fromChat) then
                Details.GetDeathRecapFromChat()
                return
            end
        end	

        table.sort (BiggestDamageHits, function (t1, t2) 
            return t1[4] > t2[4]
        end)

        local events = BiggestDamageHits
        
        local maxHP = t [5]
        local lineIndex = 10
        
        --for i = #events, 1, -1 do
        for i, event in ipairs (events) do 
            local event = events [i]
            
            local evType = event [1]
            local hp = min (floor (event [5] / maxHP * 100), 100)
            local spellName, _, spellIcon = Details.GetSpellInfo (event [2])
            local amount = event [3]
            local eventTime = event [4]
            local source = event [6]
            local overkill = event [10] or 0
            
            local customSpellInfo = event [11]
            
            if (type (evType) == "boolean" and evType) then
                
                local line = Details.DeathRecap.Lines [lineIndex]
                if (line) then
                    line.timeAt:SetText (format ("%.1f", eventTime - timeOfDeath) .. "s")
                    line.spellIcon:SetTexture (spellIcon or customSpellInfo and customSpellInfo [3] or "")
                    line.TopFader:Hide()
                    --line.spellIcon:SetTexCoord (.1, .9, .1, .9)
                    --line.sourceName:SetText ("|cFFC6B0D9" .. source .. "|r")
                    
                    --parse source and cut the length of the string after setting the spellname and source
                    local sourceClass = Details:GetClass (source)
                    local sourceSpec = Details:GetSpec (source)
                    
                    if (not sourceClass) then
                        local combat = Details:GetCurrentCombat()
                        if (combat) then
                            local sourceActor = combat:GetActor (1, source)
                            if (sourceActor) then
                                sourceClass = sourceActor.classe
                            end
                        end
                    end
                    
                    if (not sourceSpec) then
                        local combat = Details:GetCurrentCombat()
                        if (combat) then
                            local sourceActor = combat:GetActor (1, source)
                            if (sourceActor) then
                                sourceSpec = sourceActor.spec
                            end
                        end
                    end
                    
                    --> remove real name or owner name
                    source = Details:GetOnlyName (source)
                    --> remove owner name
                    source = source:gsub ((" <.*"), "")
                    
                    --> if a player?
                    if (Details.player_class [sourceClass]) then
                        source = Details:AddClassOrSpecIcon (source, sourceClass, sourceSpec, 16, true)
                        
                    elseif (sourceClass == "PET") then
                        source = Details:AddClassOrSpecIcon (source, sourceClass)
                    
                    end

                    --> remove the dot signal from the spell name
                    if (not spellName) then
                        spellName = customSpellInfo and customSpellInfo [2] or "*?*"
                        if (spellName:find (STRING_ENVIRONMENTAL_DAMAGE_FALLING)) then
                            if (UnitName ("player") == "Elphaba") then
                                spellName = "Gravity Won!, Elphaba..."
                                source = ""
                            else
                                source = "Gravity"
                            end
                            --/run for a,b in pairs (_G) do if (type (b)=="string" and b:find ("Falling")) then print (a,b) end end
                        end
                    end
                    
                    spellName = spellName:gsub (L["STRING_DOT"], "")
                    spellName = spellName:gsub ("[*] ", "")
                    source = source or ""
                    
                    line.sourceName:SetText (spellName .. " (" .. "|cFFC6B0D9" .. source .. "|r" .. ")")
                    DetailsFramework:TruncateText (line.sourceName, 185)
                    
                    if (amount > 1000) then
                        --line.amount:SetText ("-" .. Details:ToK (amount))
                        line.amount:SetText ("-" .. amount)
                    else
                        line.amount:SetText ("-" .. floor (amount))
                    end
                    
                    line.lifePercent:SetText (hp .. "%")
                    line.lifeStatusBar:SetWidth(line:GetWidth() * (hp/100))

                    line.spellid = event [2]
                    
                    line:Show()
                    
                    if (Details.death_recap.show_life_percent) then
                        line.lifePercent:Show()
                        line.amount:SetPoint ("left", line, "left", 240, 0)
                        line.lifePercent:SetPoint ("left", line, "left", 320, 0)
                    else
                        line.lifePercent:Hide()
                        line.amount:SetPoint ("left", line, "left", 280, 0)
                        --line.lifePercent:SetPoint ("left", line, "left", 320, 0)
                    end
                end
                
                lineIndex = lineIndex - 1
            end
        end
        
        local lastLine = Details.DeathRecap.Lines [lineIndex + 1]
        if (lastLine) then
            lastLine.TopFader:Show()
        end
        
        DeathRecapFrame.Unavailable:Hide()
    else
        if (not fromChat) then
            Details.GetDeathRecapFromChat()
        end
    end
end

hooksecurefunc (_G, "DeathRecap_LoadUI", function()
	hooksecurefunc (_G, "DeathRecapFrame_OpenRecap", function (RecapID)
		Details.OpenDetailsDeathRecap (nil, RecapID)
	end)
end)
