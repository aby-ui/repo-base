-- slash commands
local AddonName, Addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(AddonName)

local SlashCommands = Addon:NewModule("SlashCommands", "AceConsole-3.0")

local function printCommand(cmd, desc)
    print((" - |cFF33FF99%s|r: %s"):format(cmd, desc))
end

function SlashCommands:OnEnable()
    self:RegisterChatCommand("dominos", "OnCmd")
    self:RegisterChatCommand("dom", "OnCmd")
end

function SlashCommands:OnCmd(args)
    local cmd = string.split(" ", args):lower() or args:lower()

    if cmd == "config" or cmd == "lock" then
        Addon:ToggleLockedFrames()
    elseif cmd == "bind" then
        Addon:ToggleBindingMode()
    elseif cmd == "scale" then
        Addon:ScaleFrames(select(2, string.split(" ", args)))
    elseif cmd == "setalpha" then
        Addon:SetOpacityForFrames(select(2, string.split(" ", args)))
    elseif cmd == "fade" then
        Addon:SetFadeForFrames(select(2, string.split(" ", args)))
    elseif cmd == "setcols" then
        Addon:SetColumnsForFrames(select(2, string.split(" ", args)))
    elseif cmd == "pad" then
        Addon:SetPaddingForFrames(select(2, string.split(" ", args)))
    elseif cmd == "space" then
        Addon:SetSpacingForFrame(select(2, string.split(" ", args)))
    elseif cmd == "show" then
        Addon:ShowFrames(select(2, string.split(" ", args)))
    elseif cmd == "hide" then
        Addon:HideFrames(select(2, string.split(" ", args)))
    elseif cmd == "toggle" then
        Addon:ToggleFrames(select(2, string.split(" ", args)))
    elseif cmd == "numbars" then
        Addon:SetNumBars(tonumber(select(2, string.split(" ", args))))
    elseif cmd == "numbuttons" then
        Addon:SetNumButtons(tonumber(select(2, string.split(" ", args))))
    elseif cmd == "save" then
        local profileName = string.join(" ", select(2, string.split(" ", args)))
        Addon:SaveProfile(profileName)
    elseif cmd == "set" then
        local profileName = string.join(" ", select(2, string.split(" ", args)))
        Addon:SetProfile(profileName)
    elseif cmd == "copy" then
        local profileName = string.join(" ", select(2, string.split(" ", args)))
        Addon:CopyProfile(profileName)
    elseif cmd == "delete" then
        local profileName = string.join(" ", select(2, string.split(" ", args)))
        Addon:DeleteProfile(profileName)
    elseif cmd == "reset" then
        Addon:ResetProfile()
    elseif cmd == "list" then
        Addon:ListProfiles()
    elseif cmd == "version" then
        Addon:PrintVersion()
    elseif cmd == "help" or cmd == "?" then
        self:PrintHelp()
    elseif cmd == "statedump" then
        Addon.OverrideController:DumpStates()
    elseif cmd == "configstatus" then
        self:PrintConfigModeStatus()
    else
        if not Addon:ShowOptions() then
            self:PrintHelp()
        end
    end
end

function SlashCommands:PrintConfigModeStatus()
    local status = Addon:IsConfigAddonEnabled() and "ENABLED" or "DISABLED"

    Addon:Printf("Config Mode Status: %s", status)
end

function SlashCommands:PrintHelp(cmd)
    Addon:Print("Commands (/dom, /dominos)")

    printCommand("config", L.ConfigDesc)
    printCommand("scale <frameList> <scale>", L.SetScaleDesc)
    printCommand("setalpha <frameList> <opacity>", L.SetAlphaDesc)
    printCommand("fade <frameList> <opacity>", L.SetFadeDesc)
    printCommand("setcols <frameList> <columns>", L.SetColsDesc)
    printCommand("pad <frameList> <padding>", L.SetPadDesc)
    printCommand("space <frameList> <spacing>", L.SetSpacingDesc)
    printCommand("show <frameList>", L.ShowFramesDesc)
    printCommand("hide <frameList>", L.HideFramesDesc)
    printCommand("toggle <frameList>", L.ToggleFramesDesc)
    printCommand("save <profile>", L.SaveDesc)
    printCommand("set <profile>", L.SetDesc)
    printCommand("copy <profile>", L.CopyDesc)
    printCommand("delete <profile>", L.DeleteDesc)
    printCommand("reset", L.ResetDesc)
    printCommand("list", L.ListDesc)
    printCommand("version", L.PrintVersionDesc)
end
