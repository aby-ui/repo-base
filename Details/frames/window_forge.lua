
local Details = _G.Details
local L = LibStub("AceLocale-3.0"):GetLocale ( "Details" )

--> default weaktable
Details.weaktable = {__mode = "v"}

Details:GetFramework():InstallTemplate("button", "DETAILS_FORGE_TEXTENTRY_TEMPLATE", {
    backdrop = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true}, --edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, 
    backdropcolor = {0, 0, 0, .1},
})

local CONST_BUTTON_TEMPLATE = Details:GetFramework():InstallTemplate("button", "DETAILS_FORGE_BUTTON_TEMPLATE", {
    width = 140,
},
"DETAILS_PLUGIN_BUTTON_TEMPLATE")

local CONST_BUTTONSELECTED_TEMPLATE = Details:GetFramework():InstallTemplate("button", "DETAILS_FORGE_BUTTONSELECTED_TEMPLATE", {
    width = 140,
},
"DETAILS_PLUGIN_BUTTONSELECTED_TEMPLATE")


function Details:InitializeForge()
    local DetailsForgePanel = Details.gump:CreateSimplePanel (UIParent, 960, 600, "Details! " .. L["STRING_SPELLLIST"], "DetailsForgePanel")
    DetailsForgePanel.Frame = DetailsForgePanel
    DetailsForgePanel.__name = L["STRING_SPELLLIST"]
    DetailsForgePanel.real_name = "DETAILS_FORGE"
    DetailsForgePanel.__icon = [[Interface\MINIMAP\Vehicle-HammerGold-3]]
    DetailsPluginContainerWindow.EmbedPlugin (DetailsForgePanel, DetailsForgePanel, true)
    
    function DetailsForgePanel.RefreshWindow()
        Details:OpenForge()
    end
end

function Details:OpenForge()
    
    if (not DetailsForgePanel or not DetailsForgePanel.Initialized) then
        
        local fw = Details:GetFramework()
        local lower = string.lower
        
        DetailsForgePanel.Initialized = true
        
        --main frame
        local f = DetailsForgePanel or Details.gump:CreateSimplePanel (UIParent, 960, 600, "Details! " .. L["STRING_SPELLLIST"], "DetailsForgePanel")
        f:SetPoint ("center", UIParent, "center")
        f:SetFrameStrata ("HIGH")
        f:SetToplevel (true)
        f:SetMovable (true)
        f.Title:SetTextColor (1, .8, .2)
        
        local have_plugins_enabled
        
        for id, instanceTable in pairs (Details.EncounterInformation) do
            if (Details.InstancesToStoreData [id]) then
                have_plugins_enabled = true
                break
            end
        end
        
        if (not have_plugins_enabled and false) then
            local nopluginLabel = f:CreateFontString (nil, "overlay", "GameFontNormal")
            local nopluginIcon = f:CreateTexture (nil, "overlay")
            nopluginIcon:SetPoint ("bottomleft", f, "bottomleft", 10, 10)
            nopluginIcon:SetSize (16, 16)
            nopluginIcon:SetTexture ([[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]])
            nopluginLabel:SetPoint ("left", nopluginIcon, "right", 5, 0)
            nopluginLabel:SetText (L["STRING_FORGE_ENABLEPLUGINS"])
        end
        
        if (not Details:GetTutorialCVar ("FORGE_TUTORIAL")) then
            local tutorialFrame = CreateFrame ("frame", "$parentTutorialFrame", f,"BackdropTemplate")
            tutorialFrame:SetPoint ("center", f, "center")
            tutorialFrame:SetFrameStrata ("DIALOG")
            tutorialFrame:SetSize (400, 300)
            tutorialFrame:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16,
            insets = {left = 0, right = 0, top = 0, bottom = 0}, edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize=1})
            tutorialFrame:SetBackdropColor (0, 0, 0, 1)
            
            tutorialFrame.Title = Details.gump:CreateLabel (tutorialFrame, L["STRING_FORGE_TUTORIAL_TITLE"], 12, "orange")
            tutorialFrame.Desc = Details.gump:CreateLabel (tutorialFrame, L["STRING_FORGE_TUTORIAL_DESC"], 12)
            tutorialFrame.Desc.width = 370
            tutorialFrame.Example = Details.gump:CreateLabel (tutorialFrame, L["STRING_FORGE_TUTORIAL_VIDEO"], 12)
            
            tutorialFrame.Title:SetPoint ("top", tutorialFrame, "top", 0, -5)
            tutorialFrame.Desc:SetPoint ("topleft", tutorialFrame, "topleft", 10, -45)
            tutorialFrame.Example:SetPoint ("topleft", tutorialFrame, "topleft", 10, -110)
            
            local editBox = Details.gump:CreateTextEntry (tutorialFrame, function()end, 375, 20, nil, nil, nil, entry_template, label_template)
            editBox:SetPoint ("topleft", tutorialFrame.Example, "bottomleft", 0, -10) 
            editBox:SetText ([[https://www.youtube.com/watch?v=om0k1Yj2pEw]])
            editBox:SetTemplate (Details.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
            
            local closeButton = Details.gump:CreateButton (tutorialFrame, function() Details:SetTutorialCVar ("FORGE_TUTORIAL", true); tutorialFrame:Hide() end, 80, 20, L["STRING_OPTIONS_CHART_CLOSE"])
            closeButton:SetPoint ("bottom", tutorialFrame, "bottom", 0, 10)
            closeButton:SetTemplate (Details.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
        end
        
        --modules
        local all_modules = {}
        local spell_already_added = {}
        
        f:SetScript ("OnHide", function()
            for _, module in ipairs (all_modules) do
                if (module.data) then
                    wipe (module.data)
                end
            end
            wipe (spell_already_added)
        end)
        
        f.bg1 = f:CreateTexture (nil, "background")
        f.bg1:SetTexture ([[Interface\AddOns\Details\images\background]], true)
        f.bg1:SetAlpha (0.7)
        f.bg1:SetVertexColor (0.27, 0.27, 0.27)
        f.bg1:SetVertTile (true)
        f.bg1:SetHorizTile (true)
        f.bg1:SetSize (790, 454)
        f.bg1:SetAllPoints()
        
        f:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
        f:SetBackdropColor (.5, .5, .5, .5)
        f:SetBackdropBorderColor (0, 0, 0, 1)
        
        --[=[
        --scroll gradient
        local blackdiv = f:CreateTexture (nil, "artwork")
        blackdiv:SetTexture ([[Interface\ACHIEVEMENTFRAME\UI-Achievement-HorizontalShadow]])
        blackdiv:SetVertexColor (0, 0, 0)
        blackdiv:SetAlpha (1)
        blackdiv:SetPoint ("topleft", f, "topleft", 170, -100)
        blackdiv:SetHeight (461)
        blackdiv:SetWidth (200)
        
        --big gradient
        local blackdiv = f:CreateTexture (nil, "artwork")
        blackdiv:SetTexture ([[Interface\ACHIEVEMENTFRAME\UI-Achievement-HorizontalShadow]])
        blackdiv:SetVertexColor (0, 0, 0)
        blackdiv:SetAlpha (0.7)
        blackdiv:SetPoint ("topleft", f, "topleft", 0, 0)
        blackdiv:SetPoint ("bottomleft", f, "bottomleft", 0, 0)
        blackdiv:SetWidth (200)
        --]=]
        
        local no_func = function()end
        local nothing_to_show = {}
        local current_module
        local buttons = {}
        
        function f:InstallModule (module)
            if (module and type (module) == "table") then
                tinsert (all_modules, module)
            end
        end
        
        local all_players_module = {
            name = L["STRING_FORGE_BUTTON_PLAYERS"],
            desc = L["STRING_FORGE_BUTTON_PLAYERS_DESC"],
            filters_widgets = function()
                if (not DetailsForgeAllPlayersFilterPanel) then
                    local w = CreateFrame ("frame", "DetailsForgeAllPlayersFilterPanel", f, "BackdropTemplate")
                    w:SetSize (600, 20)
                    w:SetPoint ("topleft", f, "topleft", 164, -40)
                    --
                    local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
                    label:SetText (L["STRING_FORGE_FILTER_PLAYERNAME"] .. ": ")
                    label:SetPoint ("left", w, "left", 5, 0)
                    local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeAllPlayersNameFilter")
                    entry:SetHook ("OnTextChanged", function() f:refresh() end)
                    entry:SetPoint ("left", label, "right", 2, 0)
                    entry:SetTemplate (Details.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
                end
                return DetailsForgeAllPlayersFilterPanel
            end,
            search = function()
                local t = {}
                local filter = DetailsForgeAllPlayersNameFilter:GetText()
                for _, actor in ipairs (Details:GetCombat("current"):GetActorList (DETAILS_ATTRIBUTE_DAMAGE)) do
                    if (actor:IsGroupPlayer()) then
                        if (filter ~= "") then
                            filter = lower (filter)
                            local actor_name = lower (actor:name())
                            if (actor_name:find (filter)) then
                                t [#t+1] = actor
                            end
                        else
                            t [#t+1] = actor
                        end
                    end
                end
                return t
            end,
            header = {
                {name = L["STRING_FORGE_HEADER_INDEX"], width = 40, type = "text", func = no_func},
                {name = L["STRING_FORGE_HEADER_NAME"], width = 150, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_CLASS"], width = 100, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_GUID"], width = 230, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_FLAG"], width = 100, type = "entry", func = no_func},
            },
            fill_panel = false,
            fill_gettotal = function (self) return #self.module.data end,
            fill_fillrows = function (index, self) 
                local data = self.module.data [index]
                if (data) then
                    return {
                        index,
                        data:name() or "",
                        data:class() or "",
                        data.serial or "",
                        "0x" .. Details:hex (data.flag_original)
                    }
                else
                    return nothing_to_show
                end
            end,
            fill_name = "DetailsForgeAllPlayersFillPanel",
        }
        
        -----------------------------------------------
        local all_pets_module = {
            name = L["STRING_FORGE_BUTTON_PETS"],
            desc = L["STRING_FORGE_BUTTON_PETS_DESC"],
            filters_widgets = function()
                if (not DetailsForgeAllPetsFilterPanel) then
                    local w = CreateFrame ("frame", "DetailsForgeAllPetsFilterPanel", f, "BackdropTemplate")
                    w:SetSize (600, 20)
                    w:SetPoint ("topleft", f, "topleft", 164, -40)
                    --
                    local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
                    label:SetText (L["STRING_FORGE_FILTER_PETNAME"] .. ": ")
                    label:SetPoint ("left", w, "left", 5, 0)
                    local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeAllPetsNameFilter")
                    entry:SetHook ("OnTextChanged", function() f:refresh() end)
                    entry:SetPoint ("left", label, "right", 2, 0)
                    entry:SetTemplate (Details.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
                    --
                    local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
                    label:SetText (L["STRING_FORGE_FILTER_OWNERNAME"] .. ": ")
                    label:SetPoint ("left", entry.widget, "right", 20, 0)
                    local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeAllPetsOwnerFilter")
                    entry:SetHook ("OnTextChanged", function() f:refresh() end)
                    entry:SetPoint ("left", label, "right", 2, 0)
                    entry:SetTemplate (Details.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
                end
                return DetailsForgeAllPetsFilterPanel
            end,
            search = function()
                local t = {}
                local filter_petname = DetailsForgeAllPetsNameFilter:GetText()
                local filter_ownername = DetailsForgeAllPetsOwnerFilter:GetText()
                for _, actor in ipairs (Details:GetCombat("current"):GetActorList (DETAILS_ATTRIBUTE_DAMAGE)) do
                    if (actor.owner) then
                        local can_add = true
                        if (filter_petname ~= "") then
                            filter_petname = lower (filter_petname)
                            local actor_name = lower (actor:name())
                            if (not actor_name:find (filter_petname)) then
                                can_add = false
                            end
                        end
                        if (filter_ownername ~= "") then
                            filter_ownername = lower (filter_ownername)
                            local actor_name = lower (actor.ownerName)
                            if (not actor_name:find (filter_ownername)) then
                                can_add = false
                            end
                        end
                        if (can_add) then
                            t [#t+1] = actor
                        end
                    end
                end
                return t
            end,
            header = {
                {name = L["STRING_FORGE_HEADER_INDEX"], width = 40, type = "text", func = no_func},
                {name = L["STRING_FORGE_HEADER_NAME"], width = 150, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_OWNER"], width = 150, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_NPCID"], width = 60, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_GUID"], width = 100, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_FLAG"], width = 100, type = "entry", func = no_func},
            },
            fill_panel = false,
            fill_gettotal = function (self) return #self.module.data end,
            fill_fillrows = function (index, self) 
                local data = self.module.data [index]
                if (data) then
                    return {
                        index,
                        data:name():gsub ("(<).*(>)", "") or "",
                        data.ownerName or "",
                        Details:GetNpcIdFromGuid (data.serial),
                        data.serial or "",
                        "0x" .. Details:hex (data.flag_original)
                    }
                else
                    return nothing_to_show
                end
            end,
            fill_name = "DetailsForgeAllPetsFillPanel",
        }
        

        
        -----------------------------------------------
        
        local all_enemies_module = {
            name = L["STRING_FORGE_BUTTON_ENEMIES"],
            desc = L["STRING_FORGE_BUTTON_ENEMIES_DESC"],
            filters_widgets = function()
                if (not DetailsForgeAllEnemiesFilterPanel) then
                    local w = CreateFrame ("frame", "DetailsForgeAllEnemiesFilterPanel", f, "BackdropTemplate")
                    w:SetSize (600, 20)
                    w:SetPoint ("topleft", f, "topleft", 164, -40)
                    --
                    local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
                    label:SetText (L["STRING_FORGE_FILTER_ENEMYNAME"] .. ": ")
                    label:SetPoint ("left", w, "left", 5, 0)
                    local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeAllEnemiesNameFilter")
                    entry:SetHook ("OnTextChanged", function() f:refresh() end)
                    entry:SetPoint ("left", label, "right", 2, 0)
                    entry:SetTemplate (Details.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
                end
                return DetailsForgeAllEnemiesFilterPanel
            end,
            search = function()
                local t = {}
                local filter = DetailsForgeAllEnemiesNameFilter:GetText()
                for _, actor in ipairs (Details:GetCombat("current"):GetActorList (DETAILS_ATTRIBUTE_DAMAGE)) do
                    if (actor:IsNeutralOrEnemy()) then
                        if (filter ~= "") then
                            filter = lower (filter)
                            local actor_name = lower (actor:name())
                            if (actor_name:find (filter)) then
                                t [#t+1] = actor
                            end
                        else
                            t [#t+1] = actor
                        end
                    end
                end
                return t
            end,
            header = {
                {name = L["STRING_FORGE_HEADER_INDEX"], width = 40, type = "text", func = no_func},
                {name = L["STRING_FORGE_HEADER_NAME"], width = 150, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_NPCID"], width = 60, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_GUID"], width = 230, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_FLAG"], width = 100, type = "entry", func = no_func},
            },
            fill_panel = false,
            fill_gettotal = function (self) return #self.module.data end,
            fill_fillrows = function (index, self) 
                local data = self.module.data [index]
                if (data) then
                    return {
                        index,
                        data:name(),
                        Details:GetNpcIdFromGuid (data.serial),
                        data.serial or "",
                        "0x" .. Details:hex (data.flag_original)
                    }
                else
                    return nothing_to_show
                end
            end,
            fill_name = "DetailsForgeAllEnemiesFillPanel",
        }

        -----------------------------------------------
        
        local spell_ignore_spell_func = function(row)
            local data = all_modules [1].data [row]
            local spellid = data[1]

            if (not Details.spellid_ignored[spellid]) then
                Details.spellid_ignored[spellid] = true
            else
                Details.spellid_ignored[spellid] = nil
            end
        end

        local spell_open_aura_creator = function (row)
            local data = all_modules [1].data [row]
            local spellid = data[1]
            local spellname, _, spellicon = GetSpellInfo (spellid)
            Details:OpenAuraPanel (spellid, spellname, spellicon, data[3])
        end
        
        local spell_encounter_open_aura_creator = function (row)
            local data = all_modules [2].data [row]
            local spellID = data[1]
            local encounterID  = data [2]
            local enemyName = data [3]
            local encounterName = data [4]
            
            local spellname, _, spellicon = GetSpellInfo (spellID)
            
            Details:OpenAuraPanel (spellID, spellname, spellicon, encounterID)
        end
        
        local EncounterSpellEvents = EncounterDetailsDB and EncounterDetailsDB.encounter_spells
        
        local all_spells_module = {
            name = L["STRING_FORGE_BUTTON_ALLSPELLS"],
            desc = L["STRING_FORGE_BUTTON_ALLSPELLS_DESC"],
            filters_widgets = function()
                if (not DetailsForgeAllSpellsFilterPanel) then
                    local w = CreateFrame ("frame", "DetailsForgeAllSpellsFilterPanel", f, "BackdropTemplate")
                    w:SetSize (600, 20)
                    w:SetPoint ("topleft", f, "topleft", 164, -40)
                    --
                    local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
                    label:SetText (L["STRING_FORGE_FILTER_SPELLNAME"] .. ": ")
                    label:SetPoint ("left", w, "left", 5, 0)
                    local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeAllSpellsNameFilter")
                    entry:SetHook ("OnTextChanged", function() f:refresh() end)
                    entry:SetPoint ("left", label, "right", 2, 0)
                    entry:SetTemplate (Details.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
                    --
                    local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
                    label:SetText (L["STRING_FORGE_FILTER_CASTERNAME"] .. ": ")
                    label:SetPoint ("left", entry.widget, "right", 20, 0)
                    local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeAllSpellsCasterFilter")
                    entry:SetHook ("OnTextChanged", function() f:refresh() end)
                    entry:SetPoint ("left", label, "right", 2, 0)
                    entry:SetTemplate (Details.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
                end
                return DetailsForgeAllSpellsFilterPanel
            end,
            search = function()
                local t = {}
                local filter_caster = DetailsForgeAllSpellsCasterFilter:GetText()
                local filter_name = DetailsForgeAllSpellsNameFilter:GetText()
                local lower_FilterCaster = lower (filter_caster)
                local lower_FilterSpellName = lower (filter_name)
                wipe (spell_already_added)
                
                local SpellPoll = Details.spell_pool
                for spellID, className in pairs (SpellPoll) do
                    
                    if (type (spellID) == "number" and spellID > 12) then

                        local can_add = true
                        
                        if (lower_FilterCaster ~= "") then
                            --class name are stored as numbers for players and string for non-player characters
                            local classNameOriginal = className
                            if (type (className) == "number") then
                                className = Details.classid_to_classstring [className]
                                className = lower (className)
                            else
                                className = lower (className)
                            end
                            
                            if (not className:find (lower_FilterCaster)) then
                                can_add = false
                            else
                                className = classNameOriginal
                            end
                        end
                        
                        if (can_add	) then
                            if (filter_name ~= "") then
                                local spellName = GetSpellInfo (spellID)
                                if (spellName) then
                                    spellName = lower (spellName)
                                    if (not spellName:find (lower_FilterSpellName)) then
                                        can_add = false
                                    end
                                else
                                    can_add = false
                                end
                            end
                        end
                        
                        if (can_add) then
                            tinsert (t, {spellID, Details.classid_to_classstring [className] or className})
                        end
                        
                    end
                end
                
                return t
            end,
            header = {
                {name = L["STRING_FORGE_HEADER_INDEX"], width = 40, type = "text", func = no_func},
                {name = L["STRING_FORGE_HEADER_ICON"], width = 40, type = "texture"},
                {name = L["STRING_FORGE_HEADER_NAME"], width = 150, type = "entry", func = no_func, onenter = function(self) GameTooltip:SetOwner (self.widget, "ANCHOR_TOPLEFT"); Details:GameTooltipSetSpellByID (self.id); GameTooltip:Show() end, onleave = function(self) GameTooltip:Hide() end},
                {name = L["STRING_FORGE_HEADER_SPELLID"], width = 60, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_SCHOOL"], width = 60, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_CASTER"], width = 100, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_EVENT"], width = 140, type = "entry", func = no_func},
                {name = "Ignore", width = 50, type = "checkbox", func = spell_ignore_spell_func, icon = [[Interface\Glues\LOGIN\Glues-CheckBox-Check]], notext = true, iconalign = "center"},
                {name = L["STRING_FORGE_HEADER_CREATEAURA"], width = 86, type = "button", func = spell_open_aura_creator, icon = [[Interface\AddOns\WeakAuras\Media\Textures\icon]], notext = true, iconalign = "center"},
            },
            fill_panel = false,
            fill_gettotal = function (self) return #self.module.data end,
            fill_fillrows = function (index, self) 
                local data = self.module.data [index]
                if (data) then
                    local events = ""
                    if (EncounterSpellEvents and EncounterSpellEvents [data[1]]) then
                        for token, _ in pairs (EncounterSpellEvents [data[1]].token) do
                            token = token:gsub ("SPELL_", "")
                            events = events .. token .. ",  "
                        end
                        events = events:sub (1, #events - 3)
                    end
                    local spellName, _, spellIcon = GetSpellInfo (data[1])
                    local classColor = RAID_CLASS_COLORS [data[2]] and RAID_CLASS_COLORS [data[2]].colorStr or "FFFFFFFF"
                    return {
                        index,
                        {texture = spellIcon, texcoord = {.1, .9, .1, .9}},
                        {text = spellName or "", id = data[1] or 1},
                        data[1] or "",
                        Details:GetSpellSchoolFormatedName (Details.spell_school_cache [spellName]) or "",
                        "|c" .. classColor .. data[2] .. "|r",
                        events,
                        Details.spellid_ignored[data[1]]
                    }
                else
                    return nothing_to_show
                end
            end,
            fill_name = "DetailsForgeAllSpellsFillPanel",
        }
        
        
        -----------------------------------------------
        
        
        local encounter_spells_module = {
            name = L["STRING_FORGE_BUTTON_ENCOUNTERSPELLS"],
            desc = L["STRING_FORGE_BUTTON_ENCOUNTERSPELLS_DESC"],
            filters_widgets = function()
                if (not DetailsForgeEncounterBossSpellsFilterPanel) then
                
                    local w = CreateFrame ("frame", "DetailsForgeEncounterBossSpellsFilterPanel", f, "BackdropTemplate")
                    w:SetSize (600, 20)
                    w:SetPoint ("topleft", f, "topleft", 164, -40)
                    --
                    local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
                    label:SetText (L["STRING_FORGE_FILTER_SPELLNAME"] .. ": ")
                    label:SetPoint ("left", w, "left", 5, 0)
                    local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeEncounterSpellsNameFilter")
                    entry:SetHook ("OnTextChanged", function() f:refresh() end)
                    entry:SetPoint ("left", label, "right", 2, 0)
                    entry:SetTemplate (Details.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
                    --
                    local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
                    label:SetText (L["STRING_FORGE_FILTER_CASTERNAME"] .. ": ")
                    label:SetPoint ("left", entry.widget, "right", 20, 0)
                    local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeEncounterSpellsCasterFilter")
                    entry:SetHook ("OnTextChanged", function() f:refresh() end)
                    entry:SetPoint ("left", label, "right", 2, 0)
                    entry:SetTemplate (Details.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
                    --
                    local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
                    label:SetText (L["STRING_FORGE_FILTER_ENCOUNTERNAME"] .. ": ")
                    label:SetPoint ("left", entry.widget, "right", 20, 0)
                    local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeEncounterSpellsEncounterFilter")
                    entry:SetHook ("OnTextChanged", function() f:refresh() end)
                    entry:SetPoint ("left", label, "right", 2, 0)
                    entry:SetTemplate (Details.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
                end
                return DetailsForgeEncounterBossSpellsFilterPanel
            end,
            search = function()
                local t = {}
                
                local filter_name = DetailsForgeEncounterSpellsNameFilter:GetText()
                local filter_caster = DetailsForgeEncounterSpellsCasterFilter:GetText()
                local filter_encounter = DetailsForgeEncounterSpellsEncounterFilter:GetText()
                
                local lower_FilterCaster = lower (filter_caster)
                local lower_FilterSpellName = lower (filter_name)
                local lower_FilterEncounterName = lower (filter_encounter)
                
                wipe (spell_already_added)
                
                local SpellPoll = Details.encounter_spell_pool
                for spellID, spellTable in pairs (SpellPoll) do
                    if (spellID > 12) then

                        local encounterID = spellTable [1]
                        local enemyName = spellTable [2]
                        local bossDetails, bossIndex = Details:GetBossEncounterDetailsFromEncounterId (nil, encounterID)
                        
                        local can_add = true
                        
                        if (lower_FilterCaster ~= "") then
                            if (not lower (enemyName):find (lower_FilterCaster)) then
                                can_add = false
                            end
                        end
                        
                        if (can_add	) then
                            if (filter_name ~= "") then
                                local spellName = GetSpellInfo (spellID)
                                if (spellName) then
                                    spellName = lower (spellName)
                                    if (not spellName:find (lower_FilterSpellName)) then
                                        can_add = false
                                    end
                                else
                                    can_add = false
                                end
                            end
                        end
                        
                        if (can_add and bossDetails) then
                            local encounterName = bossDetails.boss
                            if (filter_encounter ~= "" and encounterName and encounterName ~= "") then
                                encounterName = lower (encounterName)
                                if (not encounterName:find (lower_FilterEncounterName)) then
                                    can_add = false
                                end
                            end
                        end
                        
                        if (can_add) then
                            tinsert (t, {spellID, encounterID, enemyName, bossDetails and bossDetails.boss or "--x--x--"})
                        end
                    end
                end
                
                return t
            end,
            
            header = {
                {name = L["STRING_FORGE_HEADER_INDEX"], width = 40, type = "text", func = no_func},
                {name = L["STRING_FORGE_HEADER_ICON"], width = 40, type = "texture"},
                {name = L["STRING_FORGE_HEADER_NAME"], width = 151, type = "entry", func = no_func, onenter = function(self) GameTooltip:SetOwner (self.widget, "ANCHOR_TOPLEFT"); Details:GameTooltipSetSpellByID (self.id); GameTooltip:Show() end, onleave = function(self) GameTooltip:Hide() end},
                {name = L["STRING_FORGE_HEADER_SPELLID"], width = 55, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_SCHOOL"], width = 60, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_CASTER"], width = 80, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_EVENT"], width = 150, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_ENCOUNTERNAME"], width = 95, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_CREATEAURA"], width = 86, type = "button", func = spell_encounter_open_aura_creator, icon = [[Interface\AddOns\WeakAuras\Media\Textures\icon]], notext = true, iconalign = "center"},
            },
            
            fill_panel = false,
            fill_gettotal = function (self) return #self.module.data end,
            fill_fillrows = function (index, self) 
                local data = self.module.data [index]
                if (data) then
                
                    local events = ""
                    if (EncounterSpellEvents and EncounterSpellEvents [data[1]]) then
                        for token, _ in pairs (EncounterSpellEvents [data[1]].token) do
                            token = token:gsub ("SPELL_", "")
                            events = events .. token .. ",  "
                        end
                        events = events:sub (1, #events - 3)
                    end
                    
                    local spellName, _, spellIcon = GetSpellInfo (data[1])
                    
                    return {
                        index,
                        spellIcon,
                        {text = spellName or "", id = data[1] or 1},
                        data[1] or "",
                        Details:GetSpellSchoolFormatedName (Details.spell_school_cache [spellName]) or "",
                        data[3] .. "|r",
                        events,
                        data[4],
                    }
                else
                    return nothing_to_show
                end
            end,
            fill_name = "DetailsForgeEncounterBossSpellsFillPanel",
        }			
        
        
        -----------------------------------------------
        
        local npc_ids_module = {
            name = "Npc IDs",
            desc = "Show a list of known npc IDs",
            filters_widgets = function()
                if (not DetailsForgeEncounterNpcIDsFilterPanel) then
                
                    local w = CreateFrame ("frame", "DetailsForgeEncounterNpcIDsFilterPanel", f, "BackdropTemplate")
                    w:SetSize (600, 20)
                    w:SetPoint ("topleft", f, "topleft", 164, -40)
                    --npc name filter
                    local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
                    label:SetText ("Npc Name" .. ": ")
                    label:SetPoint ("left", w, "left", 5, 0)
                    local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeEncounterNpcIDsFilter")
                    entry:SetHook ("OnTextChanged", function() f:refresh() end)
                    entry:SetPoint ("left", label, "right", 2, 0)
                    entry:SetTemplate (Details.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
                    --
                end
                return DetailsForgeEncounterNpcIDsFilterPanel
            end,
            search = function()
                local t = {}
                
                local filter_name = DetailsForgeEncounterNpcIDsFilter:GetText()
                local lower_FilterNpcName = lower (filter_name)
                
                local npcPool = Details.npcid_pool
                for npcID, npcName in pairs (npcPool) do
                    local can_add = true
                    
                    if (lower_FilterNpcName ~= "") then
                        if (not lower (npcName):find (lower_FilterNpcName)) then
                            can_add = false
                        end
                    end
                    
                    if (can_add) then
                        tinsert (t, {npcID, npcName})
                    end
                    
                    table.sort (t, DetailsFramework.SortOrder2R)
                end
                
                return t
            end,
            
            header = {
                {name = L["STRING_FORGE_HEADER_INDEX"], width = 40, type = "text", func = no_func},
                {name = "NpcID", width = 100, type = "entry", func = no_func},
                {name = "Npc Name", width = 400, type = "entry", func = no_func},
            },
            
            fill_panel = false,
            fill_gettotal = function (self) return #self.module.data end,
            fill_fillrows = function (index, self) 
                local data = self.module.data [index]
                if (data) then
                    local events = ""
                    if (EncounterSpellEvents and EncounterSpellEvents [data[1]]) then
                        for token, _ in pairs (EncounterSpellEvents [data[1]].token) do
                            token = token:gsub ("SPELL_", "")
                            events = events .. token .. ",  "
                        end
                        events = events:sub (1, #events - 3)
                    end

                    return {
                        index,
                        data[1],
                        data[2]
                    }
                else
                    return nothing_to_show
                end
            end,
            fill_name = "DetailsForgeNpcIDsFillPanel",
        }	
        
        -----------------------------------------------
        
        local dbm_open_aura_creator = function (row)
            local data = all_modules [4].data [row]
            
            local spellname, spellicon, _
            if (type (data [7]) == "number") then
                spellname, _, spellicon = GetSpellInfo (data [7])
            else
                if (data [7]) then
                    local spellid = data[7]:gsub ("ej", "")
                    spellid = tonumber (spellid)
                    local title, description, depth, abilityIcon, displayInfo, siblingID, nextSectionID, filteredByDifficulty, link, startsOpen, flag1, flag2, flag3, flag4 = DetailsFramework.EncounterJournal.EJ_GetSectionInfo (spellid)
                    spellname, spellicon = title, abilityIcon
                else
                    return
                end
            end
            
            Details:OpenAuraPanel (data[2], spellname, spellicon, data.id, DETAILS_WA_TRIGGER_DBM_TIMER, DETAILS_WA_AURATYPE_TEXT, {dbm_timer_id = data[2], spellid = data[7], text = "Next " .. spellname .. " In", text_size = 72, icon = spellicon})
        end
        
        local dbm_timers_module = {
            name = L["STRING_FORGE_BUTTON_DBMTIMERS"],
            desc = L["STRING_FORGE_BUTTON_DBMTIMERS_DESC"],
            filters_widgets = function()
                if (not DetailsForgeDBMBarsFilterPanel) then
                    local w = CreateFrame ("frame", "DetailsForgeDBMBarsFilterPanel", f, "BackdropTemplate")
                    w:SetSize (600, 20)
                    w:SetPoint ("topleft", f, "topleft", 164, -40)
                    --
                    local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
                    label:SetText (L["STRING_FORGE_FILTER_BARTEXT"] .. ": ")
                    label:SetPoint ("left", w, "left", 5, 0)
                    local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeDBMBarsTextFilter")
                    entry:SetHook ("OnTextChanged", function() f:refresh() end)
                    entry:SetPoint ("left", label, "right", 2, 0)
                    entry:SetTemplate (Details.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
                    --
                    local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
                    label:SetText (L["STRING_FORGE_FILTER_ENCOUNTERNAME"] .. ": ")
                    label:SetPoint ("left", entry.widget, "right", 20, 0)
                    local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeDBMBarsEncounterFilter")
                    entry:SetHook ("OnTextChanged", function() f:refresh() end)
                    entry:SetPoint ("left", label, "right", 2, 0)
                    entry:SetTemplate (Details.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
                end
                return DetailsForgeDBMBarsFilterPanel
            end,
            search = function()
                local t = {}
                local filter_barname = DetailsForgeDBMBarsTextFilter:GetText()
                local filter_encounter = DetailsForgeDBMBarsEncounterFilter:GetText()
                
                local lower_FilterBarName = lower (filter_barname)
                local lower_FilterEncounterName = lower (filter_encounter)
                
                local source = Details.boss_mods_timers.encounter_timers_dbm or {}
                
                for key, timer in pairs (source) do
                    local can_add = true
                    if (lower_FilterBarName ~= "") then
                        if (not lower (timer [3]):find (lower_FilterBarName)) then
                            can_add = false
                        end
                    end
                    if (lower_FilterEncounterName ~= "") then
                        local bossDetails, bossIndex = Details:GetBossEncounterDetailsFromEncounterId (nil, timer.id)
                        local encounterName = bossDetails and bossDetails.boss
                        if (encounterName and encounterName ~= "") then
                            encounterName = lower (encounterName)
                            if (not encounterName:find (lower_FilterEncounterName)) then
                                can_add = false
                            end
                        end
                    end
                    
                    if (can_add) then
                        t [#t+1] = timer
                    end
                end
                return t
            end,
            header = {
                {name = L["STRING_FORGE_HEADER_INDEX"], width = 40, type = "text", func = no_func},
                {name = L["STRING_FORGE_HEADER_ICON"], width = 40, type = "texture"},
                {name = L["STRING_FORGE_HEADER_BARTEXT"], width = 150, type = "entry", func = no_func, onenter = function(self) GameTooltip:SetOwner (self.widget, "ANCHOR_TOPLEFT"); Details:GameTooltipSetSpellByID (self.id); GameTooltip:Show() end, onleave = function(self) GameTooltip:Hide() end},
                {name = L["STRING_FORGE_HEADER_ID"], width = 130, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_SPELLID"], width = 50, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_TIMER"], width = 40, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_ENCOUNTERID"], width = 80, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_ENCOUNTERNAME"], width = 110, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_CREATEAURA"], width = 80, type = "button", func = dbm_open_aura_creator, icon = [[Interface\AddOns\WeakAuras\Media\Textures\icon]], notext = true, iconalign = "center"},
            },
            
            fill_panel = false,
            fill_gettotal = function (self) return #self.module.data end,
            fill_fillrows = function (index, self) 
                local data = self.module.data [index]
                if (data) then
                    local encounter_id = data.id
                    local bossDetails, bossIndex = Details:GetBossEncounterDetailsFromEncounterId (nil, data.id)
                    local bossName = bossDetails and bossDetails.boss or "--x--x--"

                    local abilityID = tonumber (data [7])
                    local spellName, _, spellIcon
                    if (abilityID) then
                        if (abilityID > 0) then
                            spellName, _, spellIcon = GetSpellInfo (abilityID)
                        end
                    end
                    
                    return {
                        index,
                        spellIcon,
                        {text = data[3] or "", id = abilityID and abilityID > 0 and abilityID or 0},
                        data[2] or "",
                        data[7] or "",
                        data[4] or "0",
                        tostring (encounter_id) or "0",
                        bossName,
                    }
                else
                    return nothing_to_show
                end
            end,
            fill_name = "DetailsForgeDBMBarsFillPanel",
        }
        
        -----------------------------------------------
        
        local bw_open_aura_creator = function (row)
        
            local data = all_modules [5].data [row]
            
            local spellname, spellicon, _
            local spellid = tonumber (data [2])
            
            if (type (spellid) == "number") then
                if (spellid < 0) then
                    local title, description, depth, abilityIcon, displayInfo, siblingID, nextSectionID, filteredByDifficulty, link, startsOpen, flag1, flag2, flag3, flag4 = DetailsFramework.EncounterJournal.EJ_GetSectionInfo (abs (spellid))
                    spellname, spellicon = title, abilityIcon
                else
                    spellname, _, spellicon = GetSpellInfo (spellid)
                end
                Details:OpenAuraPanel (data [2], spellname, spellicon, data.id, DETAILS_WA_TRIGGER_BW_TIMER, DETAILS_WA_AURATYPE_TEXT, {bw_timer_id = data [2], text = "Next " .. spellname .. " In", text_size = 72, icon = spellicon})
                
            elseif (type (data [2]) == "string") then
                --> "Xhul'horac" Imps
                Details:OpenAuraPanel (data [2], data[3], data[5], data.id, DETAILS_WA_TRIGGER_BW_TIMER, DETAILS_WA_AURATYPE_TEXT, {bw_timer_id = data [2], text = "Next " .. (data[3] or "") .. " In", text_size = 72, icon = data[5]})
            end
        end
        
        local bigwigs_timers_module = {
            name = L["STRING_FORGE_BUTTON_BWTIMERS"],
            desc = L["STRING_FORGE_BUTTON_BWTIMERS_DESC"],
            filters_widgets = function()
                if (not DetailsForgeBigWigsBarsFilterPanel) then
                    local w = CreateFrame ("frame", "DetailsForgeBigWigsBarsFilterPanel", f, "BackdropTemplate")
                    w:SetSize (600, 20)
                    w:SetPoint ("topleft", f, "topleft", 164, -40)
                    --
                    local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
                    label:SetText (L["STRING_FORGE_FILTER_BARTEXT"] .. ": ")
                    label:SetPoint ("left", w, "left", 5, 0)
                    local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeBigWigsBarsTextFilter")
                    entry:SetHook ("OnTextChanged", function() f:refresh() end)
                    entry:SetPoint ("left", label, "right", 2, 0)
                    entry:SetTemplate (Details.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
                    --
                    local label = w:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
                    label:SetText (L["STRING_FORGE_FILTER_ENCOUNTERNAME"] .. ": ")
                    label:SetPoint ("left", entry.widget, "right", 20, 0)
                    local entry = fw:CreateTextEntry (w, nil, 120, 20, "entry", "DetailsForgeBWBarsEncounterFilter")
                    entry:SetHook ("OnTextChanged", function() f:refresh() end)
                    entry:SetPoint ("left", label, "right", 2, 0)
                    entry:SetTemplate (Details.gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
                    --
                end
                return DetailsForgeBigWigsBarsFilterPanel
            end,
            search = function()
                local t = {}
                
                local filter_barname = DetailsForgeBigWigsBarsTextFilter:GetText()
                local filter_encounter = DetailsForgeBWBarsEncounterFilter:GetText()

                local lower_FilterBarName = lower (filter_barname)
                local lower_FilterEncounterName = lower (filter_encounter)
                
                
                local source = Details.boss_mods_timers.encounter_timers_bw or {}
                for key, timer in pairs (source) do
                    local can_add = true
                    if (lower_FilterBarName ~= "") then
                        if (not lower (timer [3]):find (lower_FilterBarName)) then
                            can_add = false
                        end
                    end
                    if (lower_FilterEncounterName ~= "") then
                        local bossDetails, bossIndex = Details:GetBossEncounterDetailsFromEncounterId (nil, timer.id)
                        local encounterName = bossDetails and bossDetails.boss
                        if (encounterName and encounterName ~= "") then
                            encounterName = lower (encounterName)
                            if (not encounterName:find (lower_FilterEncounterName)) then
                                can_add = false
                            end
                        end
                    end
                    
                    if (can_add) then
                        t [#t+1] = timer
                    end
                end
                return t
            end,
            header = {
                {name = L["STRING_FORGE_HEADER_INDEX"], width = 40, type = "text", func = no_func},
                {name = L["STRING_FORGE_HEADER_ICON"], width = 40, type = "texture"},
                {name = L["STRING_FORGE_HEADER_BARTEXT"], width = 200, type = "entry", func = no_func, onenter = function(self) GameTooltip:SetOwner (self.widget, "ANCHOR_TOPLEFT"); Details:GameTooltipSetSpellByID (self.id); GameTooltip:Show() end, onleave = function(self) GameTooltip:Hide() end},
                {name = L["STRING_FORGE_HEADER_SPELLID"], width = 50, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_TIMER"], width = 40, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_ENCOUNTERID"], width = 80, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_ENCOUNTERNAME"], width = 120, type = "entry", func = no_func},
                {name = L["STRING_FORGE_HEADER_CREATEAURA"], width = 120, type = "button", func = bw_open_aura_creator, icon = [[Interface\AddOns\WeakAuras\Media\Textures\icon]], notext = true, iconalign = "center"},
            },
            fill_panel = false,
            fill_gettotal = function (self) return #self.module.data end,
            fill_fillrows = function (index, self) 
                local data = self.module.data [index]
                if (data) then
                    local encounter_id = data.id
                    local bossDetails, bossIndex = Details:GetBossEncounterDetailsFromEncounterId (nil, data.id)
                    local bossName = bossDetails and bossDetails.boss or "--x--x--"
                    
                    local abilityID = tonumber (data[2])
                    local spellName, _, spellIcon
                    if (abilityID) then
                        if (abilityID > 0) then
                            spellName, _, spellIcon = GetSpellInfo (abilityID)
                        end
                    end

                    return {
                        index,
                        spellIcon,
                        {text = data[3] or "", id = abilityID and abilityID > 0 and abilityID or 0},
                        data[2] or "",
                        data[4] or "",
                        tostring (encounter_id) or "0",
                        bossName
                    }
                else
                    return nothing_to_show
                end
            end,
            fill_name = "DetailsForgeBigWigsBarsFillPanel",
        }
        
        -----------------------------------------------
        


        local select_module = function (a, b, module_number)
        
            if (current_module ~= module_number) then
                local module = all_modules [current_module]
                if (module) then
                    local filters = module.filters_widgets()
                    filters:Hide()
                    local fill_panel = module.fill_panel
                    fill_panel:Hide()
                end
            end
            
            for index, button in ipairs (buttons) do
                button:SetTemplate (CONST_BUTTON_TEMPLATE)
            end
            buttons[module_number]:SetTemplate (CONST_BUTTONSELECTED_TEMPLATE)
            
            local module = all_modules [module_number]
            if (module) then
                current_module = module_number
                
                local fillpanel = module.fill_panel
                if (not fillpanel) then
                    fillpanel = fw:NewFillPanel (f, module.header, module.fill_name, nil, 740, 481, module.fill_gettotal, module.fill_fillrows, false)
                    fillpanel:SetPoint (170, -80)
                    fillpanel.module = module
                    
                    local background = fillpanel:CreateTexture (nil, "background")
                    background:SetAllPoints()
                    background:SetColorTexture (0, 0, 0, 0.2)
                    
                    module.fill_panel = fillpanel
                end
                
                local filters = module.filters_widgets()
                filters:Show()
                
                local data = module.search()
                module.data = data
                
                fillpanel:Show()
                fillpanel:Refresh()
                
                for o = 1, #fillpanel.scrollframe.lines do
                    for i = 1, #fillpanel.scrollframe.lines [o].entry_inuse do
                        --> text entry
                        fillpanel.scrollframe.lines [o].entry_inuse [i]:SetTemplate (fw:GetTemplate ("button", "DETAILS_FORGE_TEXTENTRY_TEMPLATE"))
                    end
                end
            end
        end
        
        function f:refresh()
            select_module (nil, nil, current_module)
        end
        
        f.SelectModule = select_module
        f.AllModules = all_modules

        f:InstallModule (all_spells_module)
        f:InstallModule (encounter_spells_module)
        
        f:InstallModule (npc_ids_module)
        
        f:InstallModule (dbm_timers_module)
        f:InstallModule (bigwigs_timers_module)
        
        f:InstallModule (all_players_module)
        f:InstallModule (all_enemies_module)
        f:InstallModule (all_pets_module)

        local brackets = {
            [4] = true, 
            [6] = true
        }
        local lastButton
        
        for i = 1, #all_modules do
            local module = all_modules [i]
            local b = fw:CreateButton (f, select_module, 140, 20, module.name, i)
            b.tooltip = module.desc
            
            b:SetTemplate (CONST_BUTTON_TEMPLATE)
            b:SetIcon ([[Interface\BUTTONS\UI-GuildButton-PublicNote-Up]], nil, nil, nil, nil, {1, 1, 1, 0.7})
            b:SetWidth (140)
            
            if (lastButton) then
                if (brackets [i]) then
                    b:SetPoint ("topleft", lastButton, "bottomleft", 0, -23)
                else
                    b:SetPoint ("topleft", lastButton, "bottomleft", 0, -8)
                end
            else
                b:SetPoint ("topleft", f, "topleft", 10, (i*16*-1) - 67)
            end

            lastButton = b
            tinsert (buttons, b)
        end

        select_module (nil, nil, 1)
        
    end

    DetailsForgePanel:Show()
    
    --do a refresh on the panel
    if (DetailsForgePanel.FirstRun) then
        DetailsForgePanel:refresh()
    else
        DetailsForgePanel.FirstRun = true
    end
    
    DetailsPluginContainerWindow.OpenPlugin (DetailsForgePanel)
end
