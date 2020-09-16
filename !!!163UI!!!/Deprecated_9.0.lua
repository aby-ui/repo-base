--[[------------------------------------------------------------
backdrop system
---------------------------------------------------------------]]
--[[
inherits="BackdropTemplate"

<KeyValues>
    <KeyValue key="backdropInfo" value="BACKDROP_TOOLTIP_16_16_5555" type="global"/>
    <KeyValue key="backdropColor" value="LEGENDARY_ORANGE_COLOR" type="global"/>
    <KeyValue key="backdropColorAlpha" value="0.25" type="number"/>
    <KeyValue key="backdropBorderColor" value="LEGENDARY_ORANGE_COLOR" type="global"/>
    <KeyValue key="backdropBorderColorAlpha" value="0.25" type="number"/>
    <KeyValue key="backdropBorderBlendMode" value="ADD/BLEND"/>
</KeyValues>

脚本为空时不用写，写了反而有问题
<OnLoad inherit="prepend">
or self:OnBackdropLoaded()
<OnSizeChanged inherit="prepend">
or self:OnBackdropSizeChanged()

local BDTPL = BackdropTemplateMixin and "BackdropTemplate" .. "," or ""
header:SetAttribute("template", BDTPL .. "SecureUnitButtonTemplate")

--]]
ABY_BD_TPL = BackdropTemplateMixin and "BackdropTemplate"
function AbyBackdrop(frame)
    if BackdropTemplateMixin then
        Mixin(frame, BackdropTemplateMixin)
    end
end

DEBUG_MODE = true

--UnitIsWarModePhased(unit) or not UnitInPhase(unit) -> UnitPhaseReason