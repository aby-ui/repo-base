
local Dominos = _G['Dominos']


--Dominos.oriOnInitialize = Dominos.OnInitialize
--[[Dominos.OnInitialize = function()
    -- XXX 163
    self.db = LibStub('AceDB-3.0'):New('DominosDB', self:GetDefaults(),
    '有爱-'..(GetRealmName())..'-'..(UnitName'player'))
    self:U1_InitPreset()
    -- XXX 163 end

    return self:oriOnInitialize()
end]]


function Dominos:U1_GetPreset(style)
    local MAX_BUTTONS = 120
    local num_bars = self.db.profile.ab.count
    local hideonvehicleui = '[novehicleui]'
    local real_style = style
    if( style ~= 'MINI' and style ~= 'NORM' ) then
        style = 'MINI'
    end
    local mini = style == 'MINI'

    local frames = {}
    if mini then
        frames.menu = {
            columns=6,
            x=0, y=0, point='BOTTOMRIGHT',
            padW=1, padH=1, spacing=1,
        }
        frames.bags = {
            x=0, y=0, point = 'BOTTOMRIGHT',
            padW=1, padH=1, spacing=4,
            scale = 0.85,
            anchor='menuTR'
        }

        for i = 1, 10 do
            local def = {
                pages = {},
                x=0, y=0, point = 'BOTTOM',
                spacing=4, padW=2, padH=2,
                numButtons = floor(MAX_BUTTONS/num_bars),
            }
            frames[i] = def

            if(i~= 1) then
                def.showstates = hideonvehicleui
            end

            if(i == 5) then
                def.anchor = '1TC'
            elseif(i == 6) then
                def.anchor = '5TC'
            elseif(i == 1) then
                def.y = 0 + 15
            elseif(i == 3) then
                def.point = 'BOTTOMRIGHT'
                def.anchor = 'bagsTR'
                def.columns = 1
            elseif(i == 4) then
                def.point = 'RIGHT'
                def.anchor = '3LC'
                def.columns = 1
            elseif(i == 2) then
                def.point = 'TOP'
                def.y = -260
                def.hidden = true
            else
                def.hidden = true
                def.anchor = (i==7 and '2' or tostring(i-1)).."TC"
                def.y = 0
            end
        end

    else
        frames.menu = {
            x = 0, y = 0, point = 'LEFT',
            anchor = '1RC',
            spacing = -2, padW = 1, padH = 1,
            scale = 1.0,
        }

        frames.bags = {
            x = 0, y = 0, point = 'BOTTOMLEFT',
            anchor = 'menuRC',
            scale = 0.90,
            spacing = 3, padW = 2, padH = 2,
        }

        for i = 1, 10 do
            local def = frames[i] or {}
            frames[i] = def

            def.pages = {}
            def.spacing = 4
            def.padW = 2
            def.padH = 2
            def.point = 'BOTTOM'
            def.x = 0
            def.y = 0
            def.numButtons = floor(MAX_BUTTONS/num_bars)
            def.showstates = i ~= 1 and hideonvehicleui

            if(i == 1) then
                def.point = 'BOTTOMRIGHT'
                local screen_width = UIParent:GetWidth()
                def.x = 0-(screen_width / 2)
                def.y = 0 + 15
            elseif(i == 6) then
                def.anchor = "1TR"
            elseif(i == 5) then
                def.anchor = "6RT"
            elseif(i == 3) then
                def.point = 'BOTTOMRIGHT'
                def.y = 80
                def.columns = 1
            elseif(i == 4) then
                def.point = 'RIGHT'
                def.anchor = '3LC'
                def.columns = 1
            elseif(i == 2) then
                def.point = 'TOP'
                def.y = -260
                def.hidden = true
            else
                def.hidden = true
                def.anchor = (i==7 and '2' or tostring(i-1)).."TC"
                def.y = 0
            end
        end

    end

    local exp_default = {
        --width, x, y, point
        alwaysShowText = true,
        height = 13,
        fontSize = 13,
        texture = 'Minimalist',
        showInPetBattleUI = false,
        lockMode = true,
        showLabels = true,
        numButtons = 20,
        padW = 1, spacing = 1, padH = 1,
    }

    frames.artifact = Mixin({x=0, y=0, point='BOTTOMLEFT', width=mini and 280 or 130, display={label=false, value=true, max=true}}, exp_default)
    frames.artifact.display.percent = false
    frames.artifact.numButtons = 1
    --/run Dominos:GetModule("ProgressBars").bars[2]:SetNumButtons(5)
    frames.exp = Mixin({x=0, y=0, point='BOTTOM', width=mini and 480 or 950, display={label=true, value=true, max=true, bonus=true, percent=true}}, exp_default)

    frames.pet = {
        x=0, y=0, point = 'BOTTOMRIGHT',
        anchor = mini and '6TR' or '5TR',
        spacing=2, padW=5, padH=2,
    }

    frames.class = {
        x=0, y=0, point = 'BOTTOMLEFT',
        anchor = mini and 'petLB' or '6TL',
        spacing=2, padW=5, padH=2,
        showstates = hideonvehicleui,
    }

    frames.vehicle = {
        x=0, y=0, point = 'BOTTOMLEFT',
        anchor = mini and '5LT' or '6TR',
        numButtons = 3,
    }

    frames.cast_new = {
        point='BOTTOM', x=0, y=mini and 200 or 160,
        width = 240,
        height = 24,
        padW = 1, padH = 1,
        texture = 'Minimalist',
        display = {
            icon = true,
            time = true,
            border = false
        }
    }

    frames.cast = { x=0, y=180, point='BOTTOM', showText=true, }
    frames.roll = { point='BOTTOM', x=0, y=128, spacing=2, columns=1, }
    frames.alerts = { point='BOTTOM', x=0, y=138, spacing=2, columns=1, }
    --frames.roll = { x=0, y=0, point='CENTER', numButtons = NUM_GROUP_LOOT_FRAMES, spacing=2, columns=1, }
    frames.page = { x=0, y=0, point='BOTTOMLEFT', spacing=0, columns=1, anchor='1LC', scale=0.9, fadeAlpha=0.35, }
    frames.encounter = { x=0, point='BOTTOM', x=0, y=mini and 200+30 or 160+30, anchor='BOTTOM' }

    --基于MINI
    if real_style == "COMPACT" then
        Mixin(frames.artifact, { point="BOTTOMRIGHT", width=166 })
        Mixin(frames.exp, { point="BOTTOMRIGHT", anchor="artifactLC", width=439 })
        Mixin(frames[1], { point="BOTTOMRIGHT", anchor="expTR" })
        Mixin(frames.menu, { point="BOTTOMRIGHT", anchor="artifactTR" })
        for i=1, 10 do
            frames[i].scale = (i==3 or i==4) and 0.82 or 0.92
        end
    end

    return frames
end

local key_163 = '163init'
local key_db_ver = 1
function Dominos:U1_InitPreset(force)
    if(not self.db.profile[key_163]) then
        self.db.profile[key_163] = key_db_ver
        force = true
    end

    if(not force) then
        Dominos:U1_FixDefaults()
        return
    end

    local style = U1GetCfgValue('Dominos', 'prestyle')
    local defauls = Dominos:U1_GetPreset(style)
    Mixin(self.db.profile.frames, defauls)
end

--修正LootFrame的位置
function Dominos:U1_FixDefaults()
    if self.db.profile[key_163] ~= key_db_ver  then return end

    local prof = self.db.profile.frames.roll
    if prof then
        if (prof.point == 'CENTER' and prof.anchor == nil and (prof.x or 0) == 0 and (prof.y or 0) == 0) or
                (prof.point == 'LEFT' and prof.anchor == nil and (prof.x or 0) == 0 and (prof.y or 0) == 0) or
                (prof.point == nil and prof.anchor == nil and prof.x == nil and prof.y == nil) then
            U1Message("多米诺掷骰框的默认设置已更改, 强制生效.")
            local style = U1GetCfgValue('Dominos', 'prestyle')
            local defaults = Dominos:U1_GetPreset(style)
            wipe(prof)
            Mixin(prof, defaults.roll)
        end
    end

    prof = self.db.profile.frames.alerts
    if prof then
        if (prof.point == 'LEFT' and prof.anchor == nil and (prof.x or 0) == 0 and (prof.y or 0) == 0) or
                (prof.point == nil and prof.anchor == nil and prof.x == nil and prof.y == nil) then
            U1Message("多米诺提示框的默认设置已更改, 强制生效.")
            local style = U1GetCfgValue('Dominos', 'prestyle')
            local defaults = Dominos:U1_GetPreset(style)
            wipe(prof)
            Mixin(prof, defaults.alerts)
        end
    end
end