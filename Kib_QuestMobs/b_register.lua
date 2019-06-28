local ThisAddon, AddonDB = ...

--<<NOTES>>-----------------------------------------------------------------------------------------<<>>

    --[[

        AUTHOR(s):
            02/2016 > Current: Tosaido (Creator)

        Disclaimer:
            If any issues appear please PM the author.

            All code has been rewriten and is now 7.0 compatible

        File Structure:

            - Localization:
                Is used to store text, in multiple different languages, for people using non English clients.
                Do this early because we may need the text.

            - Register:
                Register the addon with Kib_Config, so we can use, saved variables, profiles and a config menu

            - Core:
                Contains dormant core functionality of the addon

            - Config:
                Contains dormant config related elements

            - Finalize:
                Activate the addon (if applicable)
                Activate the config elements

    --]]

--<<DEFAULTS>>--------------------------------------------------------------------------------------<<>>

    local Defaults = {
        State = true,
        DisableInCombat = true,
        DisableInInstance = true,
        TextureVariant = 1,
        Alpha = 0.9,
        NormalQuestcolor = {r = 1, g = 0.1, b = 0.1},
        GroupQuestcolor = {r = 0.9, g = 0.4, b = 0.04},
        AreaQuestcolor = {r = 0.3, g = 0.3, b = 1},
        Scale = 1,
        IconXOffset = 0,
        IconYOffset = 0,
        TasksXOffset = 0,
        TasksYOffset = 0,
        TextSize = 8,
        ShowQuestTask = false,
        ShowQuestTaskOnMouseOver = false,
    }

--<<REGISTER THE ADDON WITH KIB_CONFIG (If available)>>---------------------------------------------<<>>

    -- Setup some default settings, incase Kib_Config is not active
    local SavedVars, GlobalDatabase = Defaults, {Font = ChatFontNormal:GetFont(), Localization = GetLocale()}

    -- Access Kib_Config, which returns valuable data
    if Kib_Register_Addon then
        SavedVars, GlobalDatabase = Kib_Register_Addon("Quest Mobs", 1.15, Defaults, "Tosaido")
    end

    -- Get localized text
    local LocalizedText = AddonDB.GetLocalizedText(GlobalDatabase.Localization)

    -- Setup addon database
    AddonDB[1] = {}                                                                 -- Local Database
    AddonDB[2] = GlobalDatabase                                                     -- Global Database
    AddonDB[3] = SavedVars                                                          -- Profile Saved Variables
    AddonDB[4] = LocalizedText                                                      -- Localized text
    AddonDB[5] = CopyTable(SavedVars)                                               -- Default Old Values

----------------------------------------------------------------------------------------------------<<END>>
