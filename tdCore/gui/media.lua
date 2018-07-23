
local GUI = tdCore('GUI')

local List = GUI('List')
local Media = GUI:NewModule('Media')

Media.Fonts = List:New()
Media.Bars = List:New()

function Media:GetFonts()
    return self.Fonts
end

function Media:GetBars()
    return self.Bars
end

do
    local fonts = {
        [[fonts\arkai_t.ttf]],
        [[fonts\arkai_c.ttf]],
        [[fonts\arhei.ttf]],
        [[fonts\arialn.ttf]],
        [[fonts\frizqt__.ttf]],
        [[fonts\2002b.ttf]],
        [[fonts\2002.ttf]],
        [[fonts\k_damage.ttf]],
        [[fonts\k_pagetext.ttf]],
        [[fonts\bhei00m.ttf]],
        [[fonts\bhei01b.ttf]],
        [[fonts\bkai00m.ttf]],
        [[fonts\blei00d.ttf]],
        [[fonts\morpheus.ttf]],
        [[fonts\nim_____.ttf]],
        [[fonts\skurri.ttf]],
    }
    local testFont = UIParent:CreateFontString(nil, 'OVERLAY')
    
    for _, font in ipairs(fonts) do
        if testFont:SetFont(font, 12) then
            tinsert(Media.Fonts, font)
        end
    end
    
    --[=[
    local name = ...
    local fontpath = [[Interface\AddOns\]] .. name .. [[\media\fonts\font%d.ttf]]
    
    local i = 1
    while true do
        local font = fontpath:format(i)
        if testFont:SetFont(font, 12) then
            tinsert(Media.Fonts, font)
        else
            break
        end
        i = i + 1
    end
    --]=]
end
