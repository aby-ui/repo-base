

local Details = _G.Details
local DF = _G.DetailsFramework
local Loc = _G.LibStub("AceLocale-3.0"):GetLocale("Details")

--> config bookmarks
function Details:OpenBookmarkConfig()
	
    if (not _G.DetailsBookmarkManager) then
        DF:CreateSimplePanel (UIParent, 465, 460, Loc ["STRING_OPTIONS_MANAGE_BOOKMARKS"], "DetailsBookmarkManager")
        local panel = _G.DetailsBookmarkManager
        DF:ApplyStandardBackdrop (panel)
        panel.blocks = {}
        
        local clear_func = function (self, button, id)
            if (Details.switch.table [id]) then
                Details.switch.table [id].atributo = nil
                Details.switch.table [id].sub_atributo = nil
                panel:Refresh()
                Details.switch:Update()
            end
        end
        
        local select_attribute = function (_, _, _, attribute, sub_atribute)
            if (not sub_atribute) then
                return
            end
            Details.switch.table [panel.selecting_slot].atributo = attribute
            Details.switch.table [panel.selecting_slot].sub_atributo = sub_atribute
            panel:Refresh()
            Details.switch:Update()
        end
        
        local cooltip_color = {.1, .1, .1, .3}
        local set_att = function (self, button, id)
            panel.selecting_slot = id
            GameCooltip:Reset()
            GameCooltip:SetType (3)
            GameCooltip:SetOwner (self)
            Details:MontaAtributosOption (Details:GetInstance(1), select_attribute)
            GameCooltip:SetColor (1, cooltip_color)
            GameCooltip:SetColor (2, cooltip_color)
            GameCooltip:SetOption ("HeightAnchorMod", -7)
            GameCooltip:SetOption ("TextSize", Details.font_sizes.menus)
            GameCooltip:SetBackdrop (1, Details.tooltip_backdrop, nil, Details.tooltip_border_color)
            GameCooltip:SetBackdrop (2, Details.tooltip_backdrop, nil, Details.tooltip_border_color)
            
            GameCooltip:ShowCooltip()
        end
        
        local button_backdrop = {bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 64, insets = {left=0, right=0, top=0, bottom=0}}
        
        local set_onenter = function (self, capsule)
            self:SetBackdropColor (1, 1, 1, 0.9)
            capsule.icon:SetBlendMode ("ADD")
        end
        local set_onleave = function (self, capsule)
            self:SetBackdropColor (0, 0, 0, 0.5)
            capsule.icon:SetBlendMode ("BLEND")
        end
        
        for i = 1, 40 do
            local clear = DF:CreateButton (panel, clear_func, 16, 16, nil, i, nil, [[Interface\Glues\LOGIN\Glues-CheckBox-Check]])
            if (i%2 ~= 0) then
                --impar
                clear:SetPoint (15, (( i*10 ) * -1) - 35) --left
            else
                --par
                local o = i-1
                clear:SetPoint (250, (( o*10 ) * -1) - 35) --right
            end
        
            local set = DF:CreateButton (panel, set_att, 16, 16, nil, i)
            set:SetPoint ("left", clear, "right")
            set:SetPoint ("right", clear, "right", 180, 0)
            set:SetBackdrop (button_backdrop)
            set:SetBackdropColor (0, 0, 0, 0.5)
            set:SetHook ("OnEnter", set_onenter)
            set:SetHook ("OnLeave", set_onleave)
        
            --set:InstallCustomTexture (nil, nil, nil, nil, true)
            set:SetTemplate (DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
            
            local bg_texture = DF:CreateImage (set, [[Interface\AddOns\Details\images\bar_skyline]], 135, 30, "background")
            bg_texture:SetAllPoints()
            set.bg = bg_texture
        
            local icon = DF:CreateImage (set, nil, 16, 16, nil, nil, "icon")
            icon:SetPoint ("left", clear, "right", 4, 0)
            
            local label = DF:CreateLabel (set, "")
            label:SetPoint ("left", icon, "right", 2, 0)

            tinsert (panel.blocks, {icon = icon, label = label, bg = set.bg, button = set})
        end
        
        local normal_coords = {0, 1, 0, 1}
        local unknown_coords = {157/512, 206/512, 39/512,  89/512}
        
        function panel:Refresh()
            local bookmarks = Details.switch.table
            
            for i = 1, 40 do
                local bookmark = bookmarks [i]
                local this_block = panel.blocks [i]
                if (bookmark and bookmark.atributo and bookmark.sub_atributo) then
                    if (bookmark.atributo == 5) then --> custom
                        local CustomObject = Details.custom [bookmark.sub_atributo]
                        if (not CustomObject) then --> ele j� foi deletado
                            this_block.label.text = "-- x -- x --"
                            this_block.icon.texture = "Interface\\ICONS\\Ability_DualWield"
                            this_block.icon.texcoord = normal_coords
                            this_block.bg:SetVertexColor (.4, .1, .1, .12)
                        else
                            this_block.label.text = CustomObject.name
                            this_block.icon.texture = CustomObject.icon
                            this_block.icon.texcoord = normal_coords
                            this_block.bg:SetVertexColor (.4, .4, .4, .6)
                        end
                    else
                        bookmark.atributo = bookmark.atributo or 1
                        bookmark.sub_atributo = bookmark.sub_atributo or 1
                        this_block.label.text = Details.sub_atributos [bookmark.atributo] and Details.sub_atributos [bookmark.atributo].lista [bookmark.sub_atributo]
                        this_block.icon.texture = Details.sub_atributos [bookmark.atributo] and Details.sub_atributos [bookmark.atributo].icones [bookmark.sub_atributo] [1]
                        this_block.icon.texcoord = Details.sub_atributos [bookmark.atributo] and Details.sub_atributos [bookmark.atributo].icones [bookmark.sub_atributo] [2]
                        this_block.bg:SetVertexColor (.4, .4, .4, .6)
                    end
                    
                    this_block.button:SetAlpha (1)
                else
                    this_block.label.text = "-- x -- x --"
                    this_block.icon.texture = [[Interface\AddOns\Details\images\icons]]
                    this_block.icon.texcoord = unknown_coords
                    this_block.bg:SetVertexColor (.1, .1, .1, .12)
                    this_block.button:SetAlpha (0.3)
                end
            end
        end
    end

    _G.DetailsBookmarkManager:Show()
    _G.DetailsBookmarkManager:Refresh()
end