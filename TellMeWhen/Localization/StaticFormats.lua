local L = LibStub("AceLocale-3.0"):GetLocale("TellMeWhen", true)

local pname = UnitName("player")
local locale = GetLocale()

local spellFmt = "|T%s:0|t%s"
local function Spell(id)
    local name, _, tex = GetSpellInfo(id)
    if not name or name == "" or not tex then
        return "?????"
    end
    if id == 42292 then
        tex = "Interface\\Icons\\inv_jewelry_trinketpvp_0" .. (UnitFactionGroup("player") == "Horde" and "2" or "1")
    end

    return spellFmt:format(tex, name)
end

-- Blizzard has a typo in the English string ("Ecplise")
L["ECLIPSE"] = (locale == "enUS" or locale == "enGB") and "Eclipse" or ECLIPSE

L["DOMAIN_GLOBAL_NC"] = L["DOMAIN_GLOBAL"]:gsub("|cff00c300", ""):gsub("|r", "")

L["HELP_FIRSTUCD"]                      = L["HELP_FIRSTUCD"]                        :format(L["ICONMENU_CHOOSENAME3"], GetSpellInfo(65547), GetSpellInfo(47528), GetSpellInfo(2139), GetSpellInfo(62618), GetSpellInfo(62618))
L["HELP_MISSINGDURS"]                   = L["HELP_MISSINGDURS"]                     :format("%s", GetSpellInfo(1766)) -- keep the first "%s" as "%s"
L["ICONMENU_IGNORENOMANA_DESC"]         = L["ICONMENU_IGNORENOMANA_DESC"]           :format(Spell(85288), Spell(5308))
L["ICONMENU_REACTIVE_DESC"]             = L["ICONMENU_REACTIVE_DESC"]               :format(Spell(5308), Spell(119996), Spell(32379))
L["ICONMENU_UNITCOOLDOWN_DESC"]         = L["ICONMENU_UNITCOOLDOWN_DESC"]           :format(Spell(42292), GetSpellInfo(42292))
L["CLEU_DAMAGE_SHIELD_DESC"]            = L["CLEU_DAMAGE_SHIELD_DESC"]              :format(Spell(31271), Spell(30482), Spell(324))
L["CLEU_DAMAGE_SHIELD_MISSED_DESC"]     = L["CLEU_DAMAGE_SHIELD_MISSED_DESC"]       :format(Spell(31271), Spell(30482), Spell(324))
L["CLEU_SPELL_STOLEN_DESC"]             = L["CLEU_SPELL_STOLEN_DESC"]               :format(Spell(30449))
L["SPELLCHARGES_DESC"]                  = L["SPELLCHARGES_DESC"]                    :format(Spell(109132), Spell(115308))
L["SPELLCHARGETIME_DESC"]               = L["SPELLCHARGETIME_DESC"]                 :format(Spell(109132), Spell(105174))


L["ICONMENU_ICD_DESC"]                  = L["ICONMENU_ICD_DESC"]                    :format(L["ICONMENU_ICDTYPE"])
L["MESSAGERECIEVE"]                     = L["MESSAGERECIEVE"]                       :format("%s", L["IMPORT_EXPORT"]) -- keep the first "%s" as "%s"
L["TEXTLAYOUTS_NOEDIT_DESC"]            = L["TEXTLAYOUTS_NOEDIT_DESC"]              :format(L["IMPORT_EXPORT"])
L["PROFILES_COPY_DESC"]                 = L["PROFILES_COPY_DESC"]                   :format(L["IMPORT_FROMBACKUP"], L["IMPORT_EXPORT"])
L["PROFILES_DELETE_DESC"]               = L["PROFILES_DELETE_DESC"]                 :format(L["IMPORT_FROMBACKUP"], L["IMPORT_EXPORT"])


L["ICONMENU_UNIT_DESC"]                 = L["ICONMENU_UNIT_DESC"]                   :format(pname)
L["ICONMENU_UNIT_DESC_CONDITIONUNIT"]   = L["ICONMENU_UNIT_DESC_CONDITIONUNIT"]     :format(pname)

L["SOUND_EVENT_ONSTACK_DESC"]           = L["SOUND_EVENT_ONSTACK_DESC"]             :format(L["ICONMENU_DRS"])

L["ICONMENU_APPENDCONDT"]               = L["ICONMENU_APPENDCONDT"]                 :format(L["CONDITIONPANEL_ICON"])

L["ICONMENU_SPELLCAST_COMPLETE_DESC"]   = L["ICONMENU_SPELLCAST_COMPLETE_DESC"]     :format(L["ICONMENU_CHOOSENAME3"])
L["ICONMENU_SPELLCAST_START_DESC"]      = L["ICONMENU_SPELLCAST_START_DESC"]        :format(L["ICONMENU_CHOOSENAME3"])
L["ICONMENU_ICDAURA_DESC"]              = L["ICONMENU_ICDAURA_DESC"]                :format(L["ICONMENU_CHOOSENAME3"])
--L["CHOOSENAME_EQUIVS_TOOLTIP"]            = L["CHOOSENAME_EQUIVS_TOOLTIP"]            :format(L["ICONMENU_CHOOSENAME3"])
L["SORTBYNONE_DESC"]                    = L["SORTBYNONE_DESC"]                      :format(L["ICONMENU_CHOOSENAME3"])
L["CLEU_TIMER_DESC"]                    = L["CLEU_TIMER_DESC"]                      :format(L["ICONMENU_CHOOSENAME3"])
L["UIERROR_TIMER_DESC"]                 = L["CLEU_TIMER_DESC"]                      :format(L["ICONMENU_CHOOSENAME_EVENTS"])

L["SOUND_EVENT_ONSHOW_DESC"]            = L["SOUND_EVENT_ONSHOW_DESC"]              :format(L["ICONALPHAPANEL_FAKEHIDDEN"])
L["SOUND_EVENT_ONHIDE_DESC"]            = L["SOUND_EVENT_ONHIDE_DESC"]              :format(L["ICONALPHAPANEL_FAKEHIDDEN"])
L["CONDITIONPANEL_ICON_DESC"]           = L["CONDITIONPANEL_ICON_DESC"]             :format(L["ICONALPHAPANEL_FAKEHIDDEN"])
L["CONDITIONPANEL_ICONSHOWNTIME_DESC"]  = L["CONDITIONPANEL_ICONSHOWNTIME_DESC"]    :format(L["ICONALPHAPANEL_FAKEHIDDEN"])
L["CONDITIONPANEL_ICONHIDDENTIME_DESC"] = L["CONDITIONPANEL_ICONHIDDENTIME_DESC"]   :format(L["ICONALPHAPANEL_FAKEHIDDEN"])
L["ICONMENU_META_DESC"]                 = L["ICONMENU_META_DESC"]                   :format(L["ICONALPHAPANEL_FAKEHIDDEN"])
L["UIPANEL_GROUPSORT_fakehidden"]       = L["UIPANEL_GROUPSORT_fakehidden"]         :format(L["ICONALPHAPANEL_FAKEHIDDEN"])
L["UIPANEL_GROUPSORT_fakehidden_DESC"]  = L["UIPANEL_GROUPSORT_fakehidden_DESC"]    :format(L["ICONALPHAPANEL_FAKEHIDDEN"])
L["ICONMENU_BUFFCHECK_DESC"]            = L["ICONMENU_BUFFCHECK_DESC"]              :format(L["ICONMENU_BUFFDEBUFF"])
L["UIPANEL_GROUPALPHA_DESC"]            = L["UIPANEL_GROUPALPHA_DESC"]              :format(L["ICONALPHAPANEL_FAKEHIDDEN"])

L["HELP_CNDT_PARENTHESES_FIRSTSEE"]     = L["HELP_CNDT_PARENTHESES_FIRSTSEE"]       :format(L["CONDITIONPANEL_ANDOR"])
L["HELP_BUFF_NOSOURCERPPM"]             = L["HELP_BUFF_NOSOURCERPPM"]               :format("%s", L["ICONMENU_ONLYMINE"])

L["CODESNIPPET_ORDER_DESC"]             = L["CODESNIPPET_ORDER_DESC"]               :format(L["CODESNIPPET_GLOBAL"], L["CODESNIPPET_PROFILE"])

L["CLEU_NOFILTERS"]                     = L["CLEU_NOFILTERS"]                       :format(L["ICONMENU_CLEU"], "%s")
L["CLEU_SPELL_DAMAGE_CRIT_DESC"]        = L["CLEU_SPELL_DAMAGE_CRIT_DESC"]          :format(L["CLEU_SPELL_DAMAGE"])
L["CLEU_SPELL_DAMAGE_NONCRIT_DESC"]     = L["CLEU_SPELL_DAMAGE_NONCRIT_DESC"]       :format(L["CLEU_SPELL_DAMAGE"])
L["CLEU_SPELL_HEAL_CRIT_DESC"]          = L["CLEU_SPELL_HEAL_CRIT_DESC"]            :format(L["CLEU_SPELL_HEAL"])
L["CLEU_SPELL_HEAL_NONCRIT_DESC"]       = L["CLEU_SPELL_HEAL_NONCRIT_DESC"]         :format(L["CLEU_SPELL_HEAL"])


L["UIPANEL_GROUPSORT_value_DESC"]       = L["UIPANEL_GROUPSORT_value_DESC"]         :format(L["ICONMENU_VALUE"])
L["UIPANEL_GROUPSORT_valuep_DESC"]      = L["UIPANEL_GROUPSORT_valuep_DESC"]        :format(L["ICONMENU_VALUE"])


L["IE_NOLOADED_ICON_DESC"]              = L["IE_NOLOADED_ICON_DESC"]                :format(L["GROUP"])

L["SOUND_CHANNEL_DESC"]                 = L["SOUND_CHANNEL_DESC"]                   :format(L["SOUND_CHANNEL_MASTER"])

L["ANIM_INFINITE_DESC"]                 = L["ANIM_INFINITE_DESC"]                   :format(L["ANIM_ICONCLEAR"])

L["DT_DOC_AuraSource"]                  = L["DT_DOC_AuraSource"]                    :format(L["ICONMENU_BUFFDEBUFF"])
L["DT_DOC_Source"]                      = L["DT_DOC_Source"]                        :format(L["ICONMENU_CLEU"])
L["DT_DOC_Destination"]                 = L["DT_DOC_Destination"]                   :format(L["ICONMENU_CLEU"])
L["DT_DOC_Extra"]                       = L["DT_DOC_Extra"]                         :format(L["ICONMENU_CLEU"])
L["DT_DOC_LocType"]                     = L["DT_DOC_LocType"]                       :format(L["LOSECONTROL_ICONTYPE"])

L["ICONTYPE_DEFAULT_INSTRUCTIONS"]      = L["ICONTYPE_DEFAULT_INSTRUCTIONS"]        :format(L["ICONMENU_TYPE"], L["ICONMENU_ENABLE"])

L["CLEU_SOURCEUNITS_DESC"]              = L["CLEU_SOURCEUNITS_DESC"] .. "\r\n\r\n" .. L["ICONMENU_UNIT_DESC"]
L["CLEU_DESTUNITS_DESC"]                = L["CLEU_DESTUNITS_DESC"]   .. "\r\n\r\n" .. L["ICONMENU_UNIT_DESC"]

L["ERRORS_FRAME_DESC"]                  = L["ERRORS_FRAME_DESC"]                    :format(ERR_SPELL_COOLDOWN)

L["ERROR_NO_LOCKTOGGLE_IN_LOCKDOWN"]    = L["ERROR_NO_LOCKTOGGLE_IN_LOCKDOWN"]      :format(L["UIPANEL_COMBATCONFIG"])
L["ERROR_ACTION_DENIED_IN_LOCKDOWN"]    = L["ERROR_ACTION_DENIED_IN_LOCKDOWN"]      :format(L["UIPANEL_COMBATCONFIG"])

L["ICONMENU_SHOWTIMERTEXT_NOOCC_DESC"]  = L["ICONMENU_SHOWTIMERTEXT_NOOCC_DESC"]    :format(L["ICONMENU_SHOWTIMERTEXT"])

L["ANN_FCT_DESC"]                       = L["ANN_FCT_DESC"]                         :format(FLOATING_COMBAT_SELF_LABEL)

L["CHANGELOG_INFO2"]                    = L["CHANGELOG_INFO2"]                      :format("%s", L["ICON"], L["GROUP"])



L["ICONMENU_DOTWATCH_GCREQ_DESC"]       = L["ICONMENU_DOTWATCH_GCREQ_DESC"]         :format(L["ICONMENU_CTRLGROUP"], L["ICONMENU_ENABLE"])


L["BurstHaste"] = Spell(32182) .. "/" .. Spell(2825)

L["ICONMENU_LIGHTWELL"] = GetSpellInfo(724)
L["ICONMENU_LIGHTWELL_DESC"]            = L["ICONMENU_LIGHTWELL_DESC"]              :format(Spell(724))

-- Mop texture warnings
L["ICONMENU_CUSTOMTEX_DESC"] = L["ICONMENU_CUSTOMTEX_DESC"] .. "\r\n\r\n" .. L["ICONMENU_CUSTOMTEX_MOPAPPEND_DESC"]
L["ANIM_TEX_DESC"] = L["ANIM_TEX_DESC"] .. "\r\n\r\n" .. L["ICONMENU_CUSTOMTEX_MOPAPPEND_DESC"]


L["ICONTYPE_SWINGTIMER_TIP"] = L["ICONTYPE_SWINGTIMER_TIP"]:format(GetSpellInfo(75), L["ICONMENU_SPELLCOOLDOWN"], L["ICONMENU_SPELLCOOLDOWN"], GetSpellInfo(75), 75)
L["ICONTYPE_SWINGTIMER_TIP_APPLYSETTINGS"] = L["ICONTYPE_SWINGTIMER_TIP_APPLYSETTINGS"]:format(GetSpellInfo(75))

L["CONDITIONALPHA_METAICON_DESC"] = L["CONDITIONALPHA_METAICON_DESC"]:format(L["ICONMENU_SHOWWHEN"], L["CONDITIONS"])
L["DURATIONALPHA_DESC"] = L["DURATIONALPHA_DESC"]:format(L["ICONMENU_SHOWWHEN"])
L["STACKALPHA_DESC"] = L["STACKALPHA_DESC"]:format(L["ICONMENU_SHOWWHEN"])


--L["CNDT_SLIDER_DESC_CLICKSWAP_TOMANUAL"] = L["CNDT_SLIDER_DESC_BASE"] .. "\r\n\r\n" .. L["CNDT_SLIDER_DESC_CLICKSWAP_TOMANUAL"]
--L["CNDT_SLIDER_DESC_CLICKSWAP_TOSLIDER"] = L["CNDT_SLIDER_DESC_BASE"] .. "\r\n\r\n" .. L["CNDT_SLIDER_DESC_CLICKSWAP_TOSLIDER"]

