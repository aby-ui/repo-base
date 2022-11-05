
local Dominos = _G['Dominos']


--Dominos.oriOnInitialize = Dominos.OnInitialize
--[[Dominos.OnInitialize = function()
    -- XXX abyui
    self.db = LibStub('AceDB-3.0'):New('DominosDB', self:GetDefaults(),
    '有爱-'..(GetRealmName())..'-'..(UnitName'player'))
    self:U1_InitPreset()
    -- XXX abyui end

    return self:oriOnInitialize()
end]]


function Dominos:U1_GetPreset(style)
    local MAX_BUTTONS = self.ACTION_BUTTON_COUNT
    local num_bars = self:NumBars() --self.db.profile.ab.count
    local default_button_scale = 0.8 --dragon flight button is bigger
    local hideonvehicleui = '[novehicleui]'

    local frames = {}

    frames.menu = {
        columns=5,
        x=0, y=0, point='BOTTOMRIGHT',
        padW=1, padH=1, spacing=1,
        disabled={StoreMicroButton = true},
    }

    frames.bags = {
        x=0, y=0, point='BOTTOMRIGHT',
        padW=3, padH=1, spacing=4,
        scale = 0.73,
        oneBag = true,
        anchor='menuTR'
    }

    for i = 1, num_bars do
        local def = { pages = {}, x=0, y=0, point='BOTTOM', spacing=4, padW=2, padH=2, numButtons = floor(MAX_BUTTONS/num_bars), scale = default_button_scale, }
        frames[i] = def
        if(i~= 1) then def.showstates = hideonvehicleui end
        if(i == 5) then
            def.anchor = '1TC'
        elseif(i == 6) then
            def.anchor = '5TC'
        elseif(i == 1) then
            def.y = 0 + 15
        elseif(i == 3) then
            def.point = 'BOTTOMRIGHT'; def.anchor = 'bagsTR'; def.columns = 1
        elseif(i == 4) then
            def.point = 'RIGHT'; def.anchor = '3LC'; def.columns = 1
        elseif(i == 2) then
            def.point = 'TOP'; def.y = -400; def.hidden = true
        else
            def.hidden = true; def.anchor = (i==7 and '2' or tostring(i-1)).."TC"; def.y = 0
        end
    end

    --ProgressBar:GetDefaults()
    frames.exp = {
        x=0, y=0, point='BOTTOM', spacing=1,
        width=480, height=11, fontSize=13, texture='Minimalist',
        showInPetBattleUI = false, lockMode = true, showLabels = true, numButtons = 20,
        alwaysShowText=true, display={label=true, value=true, max=true, bonus=true, percent=true}
    }
    --这里不生效, 需要在azeriteBar里修改
    --frames.artifact = Mixin({x=0, y=0, point='BOTTOMLEFT', anchor='expBL', width=480, height=21, fontSize=23, display={label=false, value=true, max=true}}, frames.exp)

    frames.pet = {
        x=0, y=0, point='BOTTOMRIGHT',
        anchor = '6TR',
        spacing=2, padW=5, padH=2,
    }

    frames.class = {
        x=0, y=0, point='BOTTOMLEFT',
        anchor = '6TL',
        spacing=2, padW=2, padH=2,
        showstates = hideonvehicleui,
    }

    frames.vehicle = {
        x=0, y=0, point = 'BOTTOMLEFT',
        anchor = '5LT',
        numButtons = 3,
    }

    frames.cast_new = {
        point='BOTTOM', x=0, y=200,
        width = 240,
        height = 24,
        padW = 1, padH = 1,
        texture = 'Minimalist',
        display = { icon = true, time = true, border = false }
    }

    frames.cast = { x=0, y=180, point='BOTTOM', showText=true, showInOverrideUI = true }
    frames.roll = { point='BOTTOM', x=0, y=128, spacing=2, columns=1, }
    frames.alerts = { point='BOTTOM', x=0, y=138, spacing=2, columns=1, }
    frames.encounter = { x=0, point='BOTTOM', x=0, y=200+30, anchor='BOTTOM' }
    frames.extra = { point = 'CENTER', x = 0, y = -150, showInPetBattleUI = true, showInOverrideUI = true }
    frames.page = { x=0, y=0, point='BOTTOMLEFT', spacing=0, columns=1, anchor='1LB', scale=1, fadeAlpha=0.5, }
    frames.possess = { point = 'BOTTOMRIGHT', anchor = 'pageLB', x = 0, y = 0, spacing=2, padW=2, padH=2, }
    frames.zone = { point = 'CENTER', x = 0, y = -244, showInPetBattleUI = true, showInOverrideUI = true }
    frames.queue = { point = "TOPRIGHT", anchor = "bagsLT", x = 0, y = 0, scale = 0.9, displayLayer = "HIGH", }
    frames.talk = { point = "BOTTOMLEFT", x = 60, y = 60, }

    return frames
end

local key_abyui = 'abyui_init'
local key_db_ver = 1
function Dominos:U1_InitPreset(force)
    if not self.db.profile[key_abyui] then
        self.db.profile[key_abyui] = key_db_ver
        if not self.db.profile['163init'] then
            force = true
        end
    end

    if(not force) then
        Dominos:U1_FixDefaults()
        return
    end

    local style = "MINI" --U1GetCfgValue('Dominos', 'prestyle') --现在只有一个了
    local defauls = Dominos:U1_GetPreset(style)
    Mixin(self.db.profile.frames, defauls)
end

--修正一些版本变化导致的框体位置
function Dominos:U1_FixDefaults()
    if self.db.profile[key_abyui] ~= key_db_ver  then return end

    --[[ --修正LootFrame的位置
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
    --]]
end