
local Details = _G.Details
local L = _G.LibStub ("AceLocale-3.0"):GetLocale( "Details" )

function Details:OpenProfiler()

    --> isn't first run, so just quit
    if (not Details.character_first_run) then
        return

    elseif (Details.is_first_run) then
        return

    elseif (Details.always_use_profile) then
        return

    else
        --> check is this is the first run of the addon (after being installed)
        local amount = 0
        for name, profile in pairs (_detalhes_global.__profiles) do
            amount = amount + 1
        end
        if (amount == 1) then
            return
        end
    end

    local f = Details:CreateWelcomePanel (nil, nil, 250, 300, true)
    f:SetPoint ("right", UIParent, "right", -5, 0)

    local logo = f:CreateTexture (nil, "artwork")
    logo:SetTexture ([[Interface\AddOns\Details\images\logotipo]])
    logo:SetSize (256*0.8, 128*0.8)
    logo:SetPoint ("center", f, "center", 0, 0)
    logo:SetPoint ("top", f, "top", 20, 20)
    
    local string_profiler = f:CreateFontString (nil, "artwork", "GameFontNormal")
    string_profiler:SetPoint ("top", logo, "bottom", -20, 10)
    string_profiler:SetText ("Profiler!")
    
    local string_profiler = f:CreateFontString (nil, "artwork", "GameFontNormal")
    string_profiler:SetPoint ("topleft", f, "topleft", 10, -130)
    string_profiler:SetText (L["STRING_OPTIONS_PROFILE_SELECTEXISTING"])
    string_profiler:SetWidth (230)
    Details:SetFontSize (string_profiler, 11)
    Details:SetFontColor (string_profiler, "white")
    
    --> get the new profile name
    local current_profile = Details:GetCurrentProfileName()
    
    local on_select_profile = function (_, _, profilename)
        if (profilename ~= Details:GetCurrentProfileName()) then
            Details:ApplyProfile (profilename)
            if (_G.DetailsOptionsWindow and _G.DetailsOptionsWindow:IsShown()) then
                Details:OpenOptionsWindow (_G.DetailsOptionsWindow.instance)
            end
        end
    end
    
    local texcoord = {5/32, 30/32, 4/32, 28/32}
    
    local fill_dropdown = function()
        local t = {
            {value = current_profile, label = L["STRING_OPTIONS_PROFILE_USENEW"], onclick = on_select_profile, icon = [[Interface\FriendsFrame\UI-Toast-FriendRequestIcon]], texcoord = {4/32, 30/32, 4/32, 28/32}, iconcolor = "orange"}
        }
        for _, profilename in ipairs (Details:GetProfileList()) do
            if (profilename ~= current_profile) then
                t[#t+1] = {value = profilename, label = profilename, onclick = on_select_profile, icon = [[Interface\FriendsFrame\UI-Toast-FriendOnlineIcon]], texcoord = texcoord, iconcolor = "yellow"}
            end
        end
        return t
    end
    
    local dropdown = Details.gump:NewDropDown (f, f, "DetailsProfilerProfileSelectorDropdown", "dropdown", 220, 20, fill_dropdown, 1)
    dropdown:SetPoint (15, -190)
    
    local confirm_func = function()
        if (current_profile ~= Details:GetCurrentProfileName()) then
            Details:EraseProfile (current_profile)
        end
        f:Hide()
    end
    local confirm = Details.gump:NewButton (f, f, "DetailsProfilerProfileConfirmButton", "button", 150, 20, confirm_func, nil, nil, nil, "Okey!")
    confirm:SetPoint (50, -250)
    confirm:InstallCustomTexture()
end
