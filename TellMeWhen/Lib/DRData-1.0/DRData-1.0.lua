local major = "DRData-1.0"
local minor = 1050
assert(LibStub, string.format("%s requires LibStub.", major))

local Data = LibStub:NewLibrary(major, minor)
if( not Data ) then return end

local L = {
	-- WoD
	["Roots"]              = "Roots",
	["Stuns"]              = "Stuns",
	["Silences"]           = "Silences",
	["Taunts"]             = "Taunts",
	["Knockbacks"]         = "Knockbacks",
	["Incapacitates"]      = "Incapacitates",
	["Disorients"]         = "Disorients",
}

local locale = GetLocale()
if locale == "deDE" then
L["!!Main Addon Description"] = "Bietet visuelle, akustische und schriftliche Benachrichtigungen über Cooldowns, Buffs and so ziemlich alles andere."
L["ABSORBAMT"] = "Menge der Abschirmung des Schildes"
L["ABSORBAMT_DESC"] = "Überprüft die totale Menge des abschirmenden Schutzes des Schildes auf der Einheit."
L["ACTIVE"] = [=[If the %d stands for Integer than it means: 

Nummer aktiv. 

for counting porposes: "Zählen aktiv"
]=]
L["ADDONSETTINGS_DESC"] = "Generele Konfiguration des Addons"
L["AIR"] = "Luft"
L["ALLOWCOMM"] = "Erlaube das teilen im Spiel "
L["ALLOWCOMM_DESC"] = [=[Erlaube anderen TMW Benutzern dir Daten zu schicken: 

Ein UI Reload oder neuerliches starten des Clients sind nötig bevor Daten empfangen werden können. 
]=]
L["ALLOWVERSIONWARN"] = "Melde neue Version"
L["ALPHA"] = "Alpha"
L["ANCHOR_CURSOR_DUMMY"] = "TMW Positionsanzeige Anker Attrappe. "
L["ANIM_ACTVTNGLOW"] = "Icon: Aktivierungs Rahmen"
L["ANIM_ACTVTNGLOW_DESC"] = "Zeigt den Zauberaktivierungs-Rahmen von Blizzard auf dem Icon an."
L["ANIM_COLOR_DESC"] = "Stelle Farbe und Deckkraft ein."
L["ANIM_FADE"] = "Pulsieren"
L["ANIM_FADE_DESC"] = "Auswählen zum pulsieren. Abwählen zum blinken."
L["ANIM_ICONFADE"] = "Icon: Ein-/Ausblenden"
L["ANIM_ICONFLASH_DESC"] = "Farbiges Blinken über dem Symbol."
L["ANIM_ICONSHAKE_DESC"] = "Lässt das Symbol wackeln."
L["ANIM_PERIOD"] = "Periodenlänge"
L["ANIM_SCREENFLASH"] = "Bildschirm: Blinken"
L["ANIM_SCREENFLASH_DESC"] = "Farbiges Blinken über dem Bildschirm."
L["ANIM_SCREENSHAKE_DESC"] = [=[Lässt den Bildschirm wackeln.

HINWEIS: Funktioniert nur wenn ausserhalb des Kampfes oder wenn nameplates seit dem letzten login noch nicht aktiviert wurden.]=]
L["ASPECT"] = "Aspekt"
L["AURA"] = "Aura"
L["Bleeding"] = "Blutend"
L["BOTTOM"] = "unten"
L["BOTTOMLEFT"] = "unten links"
L["BOTTOMRIGHT"] = "unten rechts"
L["CASTERFORM"] = "Zaubergestalt"
L["CENTER"] = "Mitte"
L["CHOOSENAME_DIALOG"] = [=[Trage den Namen oder die ID von etwas ein, das dieses Symbol überwachen soll. Mehrere Einträge (eine beliebige Kombination aus Namen, IDs und so weiter) müssen via Semikolon (';') voneinander getrennt werden.

Mit einem Minuszeichen können Namen oder IDs quasi auskommentiert werden, ohne sie endgültig löschen zu müssen, z. B. "Verlangsamt, -Benommen".

Mit |cff7fffffUMSCHALT-Klick|r oder via Ziehen können Zauber, Gegenstände oder Chat-Links in dieses Eingabefeld eingefügt werden.]=]
L["CHOOSENAME_DIALOG_PETABILITIES"] = "Begleiterfähigkeiten müssen per ID eingetragen werden!"
L["CLEU_CAT_SPELL"] = "Zauber"
L["CLEU_CAT_SWING"] = "Nahkampf/Fernkampf"
L["CLEU_DAMAGE_SHIELD_DESC"] = "Tritt ein, wenn ein Schadensschild  (%s, %s, etc., aber nicht %s) Schaden an einer Einheit verursacht."
L["CLEU_DAMAGE_SHIELD_MISSED_DESC"] = "Tritt ein, wenn ein Schadensschild  (%s, %s, etc., aber nicht %s) keinen Schaden an einer Einheit verursacht."
L["CLEU_DAMAGE_SPLIT_DESC"] = "Tritt ein, wenn der schaden zwischen zwei oder mehr Zielen aufgeteilt wird."
L["CLEU_ENCHANT_APPLIED_DESC"] = "Bezieht temporäre Waffenverzauberungen wie Gifte und Shamanen Tränke mit ein."
L["CLEU_ENCHANT_REMOVED_DESC"] = "Bezieht temporäre Waffenverzauberungen wie Gifte und Shamanen Tränke mit ein."
L["CLEU_ENVIRONMENTAL_DAMAGE_DESC"] = "Beinhaltet/Erfasst Schaden von Lava, Erschöpfung, Ertrinken und Fallen."
L["CLEU_SPELL_EXTRA_ATTACKS_DESC"] = "Tritt ein, wenn ein extra Nahkampfangriff durch eine Fähigkeit gewährt wird."
L["CLEU_SPELL_LEECH"] = "Ressourcenverbrauch"
L["CLEU_UNIT_DESTROYED_DESC"] = "Tritt ein, wenn eine Einheit, wie z.B. ein Totem zerstört wird."
L["CMD_OPTIONS"] = "Optionen"
L["CNDTCAT_ATTRIBUTES_PLAYER"] = "Spieler-Attribute"
L["CNDTCAT_ATTRIBUTES_UNIT"] = "Einheiten-Attribute"
L["CONDITIONPANEL_ALIVE"] = "Einheit lebt"
L["CONDITIONPANEL_ALIVE_DESC"] = "Die Bedingung wird erfüllt, wenn die spezifizierte Einheit lebt."
L["CONDITIONPANEL_AND"] = "und"
L["CONDITIONPANEL_ANDOR"] = "und / oder"
L["CONDITIONPANEL_CLASSIFICATION"] = "Einheit Klassifizierung"
L["CONDITIONPANEL_COMBAT"] = "Einheit im Kampf"
L["CONDITIONPANEL_COMBO"] = "Kombo Punkte"
L["CONDITIONPANEL_ECLIPSE_DESC"] = "Finsternis hat eine Reichweite von -100 (Mondfinsternis) bis 100 (Sonnenfinsternis). Gib -80 ein, wenn du möchtest, dass das Symbol mit einem Wert von 80 Mond-Macht arbeitet. "
L["CONDITIONPANEL_EQUALS"] = "gleich"
L["CONDITIONPANEL_EXISTS"] = "Einheit existiert"
L["CONDITIONPANEL_GREATER"] = "größer als"
L["CONDITIONPANEL_GREATEREQUAL"] = "größer gleich"
L["CONDITIONPANEL_ICON"] = "Zeige Symbol"
L["CONDITIONPANEL_ICON_DESC"] = "Die Bedingung wird erfüllt, wenn das Symbol derzeit mit einer Transparenz von über 0 angezeigt oder versteckt mit einer Transparenz von 0 wird."
L["CONDITIONPANEL_ICON_HIDDEN"] = "Versteckt"
L["CONDITIONPANEL_ICON_SHOWN"] = "Gezeigt"
L["CONDITIONPANEL_INSTANCETYPE"] = "Instanz-Typ"
L["CONDITIONPANEL_LESS"] = "kleiner als"
L["CONDITIONPANEL_LESSEQUAL"] = "kleiner gleich"
L["CONDITIONPANEL_LEVEL"] = "Einheit Level"
L["CONDITIONPANEL_MOUNTED"] = "Gemountet"
L["CONDITIONPANEL_NAME"] = "Einheit Name"
L["CONDITIONPANEL_NAMETOOLTIP"] = "Mehrere Namen können mit Semikolon (;) getrennt werden. Die Bedingung ist erfüllt, wenn einer der Namen zutrifft."
L["CONDITIONPANEL_NOTEQUAL"] = "ungleich"
L["CONDITIONPANEL_OPERATOR"] = "Operator"
L["CONDITIONPANEL_OR"] = "oder"
L["CONDITIONPANEL_POWER"] = "primäre Ressource"
L["CONDITIONPANEL_POWER_DESC"] = "Prüft auf Energie, falls die Einheit ein Druide in Katzengestalt ist, auf Wut, wenn die Einheit ein Krieger ist, usw."
L["CONDITIONPANEL_PVPFLAG"] = "Einheit ist für PvP markiert."
L["CONDITIONPANEL_REMOVE"] = "Bedingung löschen"
L["CONDITIONPANEL_SWIMMING"] = "Schwimmend"
L["CONDITIONPANEL_TYPE"] = "Typ"
L["CONDITIONPANEL_UNIT"] = "Einheit"
L["CONDITIONPANEL_VALUEN"] = "Wert"
L["CONDITIONPANEL_VEHICLE"] = "Einheit kontrolliert Fahrzeug"
L["CONDITIONS"] = "Bedingungen"
L["COPYGROUP"] = "Kopiere Gruppe"
L["COPYPOSSCALE"] = "Kopiere Position/Größe"
L["CrowdControl"] = "Crowd Control"
L["Curse"] = "Fluch"
L["DISABLED"] = "Deaktiviert"
L["Disease"] = "Krankheit"
L["Disoriented"] = "Verwirrt"
L["EARTH"] = "Erde"
L["ECLIPSE_DIRECTION"] = "Finsternis Richtung"
L["elite"] = "Elite"
L["ENABLINGOPT"] = "TellMeWhen_Options ist deaktiviert. Aktiviere..."
L["EVENTS_SETTINGS_CNDTJUSTPASSED_DESC"] = "Verhindert, dass der Event abgearbeitet wird, bis die Bedingung, die oben konfiguriert wurde, zu erfolgen begonnen hat."
L["EVENTS_SETTINGS_HEADER"] = "Ereignis-Einstellungen"
L["EVENTS_SETTINGS_ONLYSHOWN"] = "Nur nutzen, wenn das Icon sichtbar ist."
L["EVENTS_SETTINGS_ONLYSHOWN_DESC"] = "Das Bestätigen dieser Einstellung wird das Ereignis daran hindern jegliche verknüpften Handlungen auszuführen, sollte das Icon nicht sichtbar sein."
L["EVENTS_SETTINGS_PASSINGCNDT"] = "Führe dies nur durch, wenn die Bedingung beendet ist."
L["EVENTS_SETTINGS_PASSINGCNDT_DESC"] = "Verhindert, dass der Event abgearbeitet wird, bis die Bedingung, die unten konfiguriert wurde, erfolgreich war."
L["EXPORT_f"] = "Export %s"
L["EXPORT_HEADING"] = "Export"
L["EXPORT_TOCOMM"] = "An Spieler"
L["EXPORT_TOSTRING"] = "In String (Zeichenkette)"
L["EXPORT_TOSTRING_DESC"] = "Eine Zeichenfolge die die notwendigen Daten enthält wird im Eingabefeld angezeigt. Drücke STRG+C um diese zu kopieren, und füge sie dann dort ein wo du sie anderen teilen möchtest."
L["FALSE"] = "Falsch"
L["Feared"] = "Furcht"
L["fGROUP"] = "Gruppe %s"
L["fICON"] = "Icon %s"
L["FIRE"] = "Feuer"
L["FONTCOLOR"] = "Schriftfarbe"
L["FONTSIZE"] = "Schriftgröße"
L["GCD"] = "Globale Abklingzeit"
L["GROUP"] = "Gruppe "
L["GROUPCONDITIONS"] = "Gruppenbedingungen"
L["GROUPICON"] = "Gruppe: %s, Symbol %s"
L["Heals"] = "Spieler Heilungen"
L["HELP_EXPORT_DOCOPY_MAC"] = "Drücke |cff7fffffCMD+C|r zum kopieren"
L["HELP_EXPORT_DOCOPY_WIN"] = "Drücke |cff7fffffCTRL+C|r zum kopieren"
L["ICON"] = "Symbol"
L["ICONALPHAPANEL_FAKEHIDDEN"] = "Unsichtbar"
L["ICONALPHAPANEL_FAKEHIDDEN_DESC"] = "Macht das Symbol unsichtbar, lässt es aber aktiv damit andere Symbole verknüpfte Bedingungen weiterhin prüfen können."
L["ICONGROUP"] = "Symbol: %s (Gruppe: %s)"
L["ICONMENU_ABSENT"] = "fehlend"
L["ICONMENU_ANCHORTO_UIPARENT"] = "Anker zurücksetzen"
L["ICONMENU_BAROFFS"] = [=[Die Leistendauer wird um diese Dauer erweitert/gekürzt.

Dies ist z.B. nützlich für personalisierte Indikatoren für wann Sie einen neuen Zauber beginnen sollten um einen Buff/Debuff vom Auslaufen abzuhalten.
]=]
L["ICONMENU_BOTH"] = "Entweder"
L["ICONMENU_BUFF"] = "Buff"
L["ICONMENU_BUFFDEBUFF"] = "Buff / Debuff"
L["ICONMENU_BUFFDEBUFF_DESC"] = "Prüft Buffs und/oder Debuffs."
L["ICONMENU_BUFFTYPE"] = "Buff oder Debuff"
L["ICONMENU_CAST"] = "Zauberspruch"
L["ICONMENU_CAST_DESC"] = "Prüft gewirkte und kanalisierte Zauber."
L["ICONMENU_CHECKNEXT"] = "Prüfe Sub-Metasymbole"
L["ICONMENU_CHECKNEXT_DESC"] = [=[Checken dieser Box bewirkt, dass dieses Symbol alle Symbole in allen Metasymbolen, die es prüft, ebenso prüft.

Zusätzlich zeigt dieses Symbol keine Symbole an, die bereits von anderen Metaicons angezeigt werden, die weiter vorne in der Aktualisierungsreihenfolge liegen.]=]
L["ICONMENU_CLEU"] = "Kampfereignis"
L["ICONMENU_COOLDOWNCHECK"] = "Abklingzeit prüfen"
L["ICONMENU_COOLDOWNCHECK_DESC"] = "Auswahl bewirkt, dass das Symbol während der Abklingzeit als nicht nutzbar behandelt wird."
L["ICONMENU_COPYHERE"] = "Hierher kopieren"
L["ICONMENU_DEBUFF"] = "Debuff"
L["ICONMENU_DISPEL"] = "Dispel-Typ"
L["ICONMENU_DURATION_MAX_DESC"] = "Maximale Dauer erlaubt um das Symbol anzuzeigen. (In Sekunden)"
L["ICONMENU_DURATION_MIN_DESC"] = "Minimale Dauer erlaubt um das Symbol anzuzeigen. (In Sekunden)"
L["ICONMENU_ENABLE"] = "Aktiviert"
L["ICONMENU_FOCUS"] = "Fokus"
L["ICONMENU_FOCUSTARGET"] = "Fokusziel"
L["ICONMENU_FRIEND"] = "freundliche Einheiten"
L["ICONMENU_HIDEUNEQUIPPED"] = "Unsichtbar, wenn Waffenplatz leer ist."
L["ICONMENU_HOSTILE"] = "feindliche Einheiten"
L["ICONMENU_ICD"] = "Interne Abklingzeit"
L["ICONMENU_ICDAURA_DESC"] = [=[Mögliche Auslöser für interne Abklingzeiten: Spieler selbst erhält Buff/Debuff, Effekt fügt Schaden zu oder Effekt erfüllt den Spieler mit Mana/Wut/etc.

Es muss der Name/die ID des Buffs/Debuffs/Effekts, der erhalten/ausgeführt wird, wenn die interne Abklingzeit beginnt, angegeben werden.]=]
L["ICONMENU_ICDBDE"] = "Buff/Debuff/Schaden/Energieeffekt/Beschwörung"
L["ICONMENU_ICDTYPE"] = "Ausgelöst durch"
L["ICONMENU_IGNORERUNES"] = "Ignoriere Runen"
L["ICONMENU_IGNORERUNES_DESC"] = "Wählen Sie dies aus, wenn ein Cooldown als nutzbar behandelt werden soll, wenn lediglich Runen benötigt werden (oder der GCD (globale Abklingzeit) aktiv ist)."
L["ICONMENU_IGNORERUNES_DESC_DISABLED"] = "Du musst die \"Cooldown Überprüfung\" Einstellung wählen, um \"Runen ignorieren\" einzuschalten."
L["ICONMENU_INVERTBARS"] = "Leisten auffüllen"
L["ICONMENU_ITEMCOOLDOWN"] = "Item Abklingzeit"
L["ICONMENU_ITEMCOOLDOWN_DESC"] = "Prüft die Abklingzeit von Items."
L["ICONMENU_MANACHECK"] = "Ressourcen Check"
L["ICONMENU_MANACHECK_DESC"] = "Auswahl bewirkt, dass das Symbol die Farbe ändert, wenn kein/e Mana/Wut/Runenmacht/etc. vorhanden ist."
L["ICONMENU_META"] = "Meta Symbol"
L["ICONMENU_META_DESC"] = [=[Kombiniert mehere andere Symbole in einem.
Symbole, die immer unsichtbar sind, werden hier trotzdem angezeigt.]=]
L["ICONMENU_MOUSEOVER"] = "Mausover"
L["ICONMENU_MOUSEOVERTARGET"] = "Mausover's Ziel"
L["ICONMENU_MOVEHERE"] = "hierher verschieben"
L["ICONMENU_ONLYEQPPD"] = "nur wenn ausgerüstet"
L["ICONMENU_ONLYIFCOUNTING"] = "Anzeige nur bei aktiviertem Timer."
L["ICONMENU_ONLYINTERRUPTIBLE"] = "Nur unterbrechbare Zauber"
L["ICONMENU_ONLYMINE"] = "Nur zeigen, wenn selbst gezaubert"
L["ICONMENU_PETTARGET"] = "Begleiterziel"
L["ICONMENU_PRESENT"] = "vorhanden"
L["ICONMENU_RANGECHECK"] = "Reichweiten Check"
L["ICONMENU_RANGECHECK_DESC"] = "Auswahl bewirkt, dass das Symbol die Farbe ändert, wenn Sie außer Reichweite sind."
L["ICONMENU_REACT"] = "Einheit Reaktion"
L["ICONMENU_REACTIVE"] = "Reaktiver Zauber oder Fähigkeit"
L["ICONMENU_RUNES_DESC"] = "Prüft Runen-Abklingzeiten"
L["ICONMENU_SHOWTIMER"] = "Zeige Timer"
L["ICONMENU_SHOWTIMERTEXT"] = "Zeige Timertext"
L["ICONMENU_SHOWTIMERTEXT_DESC"] = "Zeigt einen Timertext für die verbleibende Abklingzeit/Dauer. Benötigt das AddOn 'OmniCC'"
L["ICONMENU_SHOWWHEN"] = "Zeige Symbol, wenn"
L["ICONMENU_SORTASC"] = "Niedrige Dauer"
L["ICONMENU_SORTASC_DESC"] = "Bestätigen Sie dieses Feld um Zaubersprüche mit der niedrigsten Dauer zu priorisieren."
L["ICONMENU_SORTDESC"] = "Hohe Dauer"
L["ICONMENU_SORTDESC_DESC"] = "Bestätigen Sie dieses Feld um Zaubersprüche mit der höchsten Dauer zu priorisieren."
L["ICONMENU_SPELLCOOLDOWN"] = "Zauberspruch Abklingzeit"
L["ICONMENU_SPELLCOOLDOWN_DESC"] = "Prüft die Abklingzeit von Zaubersprüchen in Ihrem Zauberbuch."
L["ICONMENU_SPLIT"] = "In neue Gruppe aufteilen"
L["ICONMENU_SPLIT_DESC"] = "Erstellen Sie eine neue Gruppe und bewegen Sie dieses Symbol in diese hinein. Viele Gruppeneinstellungen werden auf die neue Gruppe übertragen werden."
L["ICONMENU_STACKS_MAX_DESC"] = "Maximale Anzahl Stapel der Aura erlaubt, um das Symbol anzuzeigen."
L["ICONMENU_STACKS_MIN_DESC"] = "Minimale Anzahl Stapel der Aura benötigt, um das Symbol anzuzeigen."
L["ICONMENU_TARGETTARGET"] = "Ziel des Ziels"
L["ICONMENU_TOTEM"] = "Totem / non-MoG Ghoul"
L["ICONMENU_TOTEM_DESC"] = "Prüft Ihre Totems."
L["ICONMENU_TYPE"] = "Icon Typ"
L["ICONMENU_UNUSABLE"] = "unbenutzbar"
L["ICONMENU_USABLE"] = "Benutzbar"
L["ICONMENU_VEHICLE"] = "Fahrzeug"
L["ICONMENU_WPNENCHANT"] = "Temporäre Waffenverzauberung"
L["ICONMENU_WPNENCHANTTYPE"] = "zu überwachender Waffenplatz"
L["ICONTOCHECK"] = "Zu prüfendes Symbol"
L["ImmuneToMagicCC"] = "Immun gegen magisches CC"
L["ImmuneToStun"] = "Immun gegen Betäubungseffekte"
L["IMPORT_EXPORT_DESC"] = "Drücke den Pfeil rechts dieses Feldes zum import und export von Symbolen, Gruppen und Profilen."
L["IMPORT_FROMBACKUP"] = "Von Backup"
L["IMPORT_FROMBACKUP_DESC"] = "Einstellungen die aus diesem Menü wiederhergestellt werden sind von: %s"
L["IMPORT_FROMBACKUP_WARNING"] = "Backup Einstellungen: %s"
L["IMPORT_FROMCOMM"] = "Von Spieler"
L["IMPORT_FROMCOMM_DESC"] = "Wenn ein anderer Benutzer von TellMeWhen Ihnen Konfigurationsdaten schickt, können Sie diese von diesem Untermenü importieren."
L["IMPORT_FROMLOCAL"] = "Von Profil"
L["IMPORT_FROMSTRING"] = "Von String (Zeichenkette)"
L["IMPORT_FROMSTRING_DESC"] = "Um einen String zu importieren, drücken Sie STRG+V um den String einzufügen, nachdem Sie es mit STRG-C kopiert haben. Navigieren Sie danach zurück zu diesem Untermenü."
L["IMPORT_HEADING"] = "Import"
L["IMPORT_PROFILE"] = "Profil kopieren"
L["IMPORT_PROFILE_NEW"] = "Neues Profil erstellen"
L["IMPORT_PROFILE_OVERWRITE"] = "|cFFFF5959Überschreibe|r %s"
L["IMPORTERROR_FAILEDPARSE"] = "Es gab einen Fehler beim Auslesen des Strings. Überprüfe, ob der vollständige String von der Quelle kopiert wurde."
L["Incapacitated"] = "Bewegungsunfähig"
L["ITEMCOOLDOWN"] = "Item Abklingzeit"
L["LDB_TOOLTIP1"] = "|cff7fffffLinks-Klick|r um die Gruppen fest/freizuschalten."
L["LDB_TOOLTIP2"] = "|cff7fffffRechts-Klick|r um die TMW Hauptoptionen anzuzeigen."
L["LEFT"] = "links"
L["LOCKED"] = "gesperrt"
L["Magic"] = "Magie"
L["METAPANEL_DOWN"] = "nach unten bewegen"
L["METAPANEL_REMOVE"] = "Dieses Icon entfernen"
L["METAPANEL_UP"] = "nach oben bewegen"
L["MOON"] = "Mond"
L["NEWVERSION"] = "Eine neue Version von TellMeWhen ist verfügbar: %s"
L["NONE"] = "Keine der Folgenden"
L["normal"] = "normal"
L["OUTLINE_NO"] = "Keine Kontur"
L["OUTLINE_THICK"] = "Dicke Kontur"
L["OUTLINE_THIN"] = "Dünne Kontur"
L["Poison"] = "Gift"
L["PvPSpells"] = "PVP Crowd Control, usw."
L["rare"] = "Rar"
L["rareelite"] = "Rar Elite"
L["ReducedHealing"] = "Verringerte Heilung"
L["RESIZE"] = "Größe ändern"
L["RESIZE_TOOLTIP"] = "Klicken und ziehen um die Größe zu ändern"
L["RIGHT"] = "rechts"
L["Rooted"] = "Gewurzelt"
L["Shatterable"] = "Zerschlagbar"
L["Silenced"] = "Zum Schweigen gebracht"
L["SORTBY"] = "sortieren nach"
L["SOUND_EVENT_ONFINISH_DESC"] = "Dieses Ereignis wird ausgelöst, wenn die Abklingzeit abläuft (Buff/Debuff läuft aus etc.)"
L["SOUND_EVENT_ONSPELL"] = "Wenn Zauberspruch verändert"
L["SOUND_EVENT_ONSPELL_DESC"] = "Dieses Ereignis wird ausgelöst, wenn der Zauberspruch/das Item/etc, für die den/das das Symbol Information darstellt, sich ändert."
L["SOUND_EVENT_ONUNIT"] = "Wenn Einheit verändert"
L["SOUND_EVENT_ONUNIT_DESC"] = "Dieses Ereignis wird ausgelöst, wenn die Einheit, für die das Symbol Information darstellt, sich ändert."
L["STRATA_BACKGROUND"] = "Hintergrund"
L["Stunned"] = "Betäubt"
L["SUG_FINISHHIM_DESC"] = "Dies beendet den Caching/Filtering Prozess sofort. Dies könnte den Rechner einige Sekunden einfrieren."
L["SUG_PATTERNMATCH_FISHINGLURE"] = "Angelköder %(%+%d+ Angelfertigkeit%)"
L["SUG_PATTERNMATCH_SHARPENINGSTONE"] = "Geschärft %(%+%d+ Schaden%)"
L["SUG_PATTERNMATCH_WEIGHTSTONE"] = "Beschwert %(%+%d+ Schaden%)"
L["SUN"] = "Sonne"
L["TOP"] = "oben"
L["TOPLEFT"] = "oben links"
L["TOPRIGHT"] = "oben rechts"
L["TRUE"] = "Wahr"
L["UIPANEL_BARTEXTURE"] = "Leistentextur"
L["UIPANEL_COLUMNS"] = "Spalten"
L["UIPANEL_DELGROUP"] = "Gruppe löschen"
L["UIPANEL_DRAWEDGE"] = "Hervorgehobener Timer-Rand"
L["UIPANEL_DRAWEDGE_DESC"] = "Hervorgehobener Rand um die Abklingzeit (Uhr-Animation), um die Sichtbarkeit zu erhöhen"
L["UIPANEL_FONT_DESC"] = "Wähle die Schriftart für den Stapel-Text auf Symbolen."
L["UIPANEL_FONT_OUTLINE"] = "Schriftart-Kontur"
L["UIPANEL_FONT_SIZE"] = "Zeichengröße"
L["UIPANEL_FONT_XOFFS"] = "X Abstand"
L["UIPANEL_FONT_YOFFS"] = "Y Abstand"
L["UIPANEL_GROUPNAME"] = "Gruppe umbennen"
L["UIPANEL_GROUPRESET"] = "Position zurücksetzen"
L["UIPANEL_GROUPS"] = "Gruppen"
L["UIPANEL_ICONSPACING"] = "Abstand der Icon's."
L["UIPANEL_ICONSPACING_DESC"] = "Abstand der Symbole in einer Gruppe voneinander."
L["UIPANEL_LOCK"] = "sperre Position"
L["UIPANEL_LOCKUNLOCK"] = "Sperre / Entsperre AddOn"
L["UIPANEL_MAINOPT"] = "Grundeinstellungen"
L["UIPANEL_ONLYINCOMBAT"] = "Nur im Kampf zeigen"
L["UIPANEL_POSITION"] = "Position"
L["UIPANEL_PRIMARYSPEC"] = "Primäre Talentspezialisierung"
L["UIPANEL_ROWS"] = "Zeilen"
L["UIPANEL_SCALE"] = "Massstab"
L["UIPANEL_SECONDARYSPEC"] = "Sekundäre Talentspezialisierung"
L["UIPANEL_SPEC"] = "Dual Spec"
L["UIPANEL_SUBTEXT2"] = "Symbole funktionieren im gesperrten Zustand. Im entsperrten Zustand können Sie die Symbolgruppen bewegen, die Größe ändern und mit einem Rechtsklick einzelne Symbole für weitere Optionen anklicken. Du kannst auch '/tellmewhen' oder /tmw zum sperren / entsperren eingeben."
L["UIPANEL_TOOLTIP_COLUMNS"] = "Setzt die Anzahl der Spalten in dieser Gruppe"
L["UIPANEL_TOOLTIP_GROUPRESET"] = "Position und Größe dieser Gruppe zurücksetzen"
L["UIPANEL_TOOLTIP_ONLYINCOMBAT"] = "Auswählen um diese Gruppe nur im Kampf zu zeigen"
L["UIPANEL_TOOLTIP_ROWS"] = "Setzt die Anzahl der Reihen in dieser Gruppe"
L["UIPANEL_TOOLTIP_UPDATEINTERVAL"] = "Legt fest wie oft (in Sekunden) Symbole auf zeigen/verstecken, Transparenz, Bedingungen usw. überprüft werden. Null ist so schnell wie möglich. Niedrigere Werte können erheblichen Einfluss auf die Framerate für Low-End-Rechner haben."
L["UIPANEL_UPDATEINTERVAL"] = "Aktualisierungs-Intervall"
L["worldboss"] = "Weltboss"

elseif locale == "esES" then
L["!!Main Addon Description"] = "Proporciona notificaciones visuales, auditivas y textuales sobre tiempos de reutilización, ventajas y básicamente cualquier otra cosa. "
L["ABSORBAMT"] = "Cantidad de escudos de absorción"
L["ABSORBAMT_DESC"] = "Comprueba la cantidad total de escudos de absorción que tiene la unidad.  "
L["ACTIVE"] = "%d Activo"
L["ADDONSETTINGS_DESC"] = "Configurar todos los parámetros generales de los addon."
L["AIR"] = "Aire"
L["ALLOWCOMM"] = "Permitir compartir en el juego"
L["ALLOWCOMM_DESC"] = "Permitir a otros usuarios de TellMeWhen enviarle datos. "
L["ALLOWVERSIONWARN"] = "Notificar de nueva versión"
L["ALPHA"] = "Opacidad"
L["ANCHORTO"] = "Anclar a"
L["ANIM_ACTVTNGLOW"] = "Icono: Borde de Activación"
L["ANIM_ACTVTNGLOW_DESC"] = "Muestra el borde de activación de hechizo de Blizzard en el icono. "
L["ANIM_ALPHASTANDALONE"] = "Alfa"
L["ANIM_ALPHASTANDALONE_DESC"] = "Establece la opacidad máxima de la animación."
L["ANIM_ANCHOR_NOT_FOUND"] = "No se encontró el marco llamado %q para anclar la animación. ¿Quizá este marco no se usa por la vista actual del icono?"
L["ANIM_ANIMSETTINGS"] = "Ajustes"
L["ANIM_ANIMTOUSE"] = "Animación A Usar"
L["ANIM_COLOR"] = "Color/Opacidad"
L["ANIM_COLOR_DESC"] = "Configurar el color y la opacidad del destello."
L["ANIM_DURATION"] = "Duración de Animación"
L["ANIM_DURATION_DESC"] = "Establece cuánto debería durar la animación tras ser activada. "
L["ANIM_FADE"] = "Desvanecer Destellos"
L["ANIM_FADE_DESC"] = "Marque para que haya un desvanecimiento suave entre cada destello. Desmarque para destellar instantáneamente."
L["ANIM_ICONALPHAFLASH"] = "Icono: Destello Alfa"
L["ANIM_ICONALPHAFLASH_DESC"] = "Destella el propio icono cambiando su opacidad. "
L["ANIM_ICONBORDER"] = "Icono: Borde"
L["ANIM_ICONBORDER_DESC"] = "Superpone un borde coloreado al icono. "
L["ANIM_ICONCLEAR"] = "Icono: Detener Animacions"
L["ANIM_ICONCLEAR_DESC"] = "Detiene todas las animaciones que se están reproduciendo en el icono actual. "
L["ANIM_ICONFADE"] = "Icono: Desvanecerse/Aparecer "
L["ANIM_ICONFADE_DESC"] = "Aplica suavemente cualquier cambio de opacidad sucedido con el evento seleccionado. "
L["ANIM_ICONFLASH"] = "Icono: Destello de Color"
L["ANIM_ICONFLASH_DESC"] = "Hace pasar una transparencia coloreada a través del icono."
L["ANIM_ICONOVERLAYIMG"] = "Icono: Superponer Imagen"
L["ANIM_ICONOVERLAYIMG_DESC"] = "Superpone una imagen personalizada sobre el icono."
L["ANIM_ICONSHAKE"] = "Icono: Agitar"
L["ANIM_ICONSHAKE_DESC"] = "Agita el icono cuando se activa. "
L["ANIM_INFINITE"] = "Reproducir Indefinidamente"
L["ANIM_INFINITE_DESC"] = "Marque para hacer que la animación se reproduzca hasta que sea sobrescrita por otra animación en el icono del mismo tipo, o hasta que la animación %q sea reproducida. "
L["ANIM_MAGNITUDE"] = "Magnitud de Agitado"
L["ANIM_MAGNITUDE_DESC"] = "Establece cuán violento debería ser el agitado."
L["ANIM_PERIOD"] = "Período de Destello"
L["ANIM_PERIOD_DESC"] = [=[Establece cuánto tiempo dura cada destello - el tiempo durante el cual el destello es mostrado o fundido.

Establezca a 0 si no quiere que haya destellos o fundidos. ]=]
L["ANIM_PIXELS"] = "%s Píxels"
L["ANIM_SCREENFLASH"] = "Pantalla: Destello"
L["ANIM_SCREENFLASH_DESC"] = "Pasa rápidamente una transparencia coloreada a través de la pantalla."
L["ANIM_SCREENSHAKE"] = "Pantalla: Agitar"
L["ANIM_SCREENSHAKE_DESC"] = [=[Agita la pantalla entera cuando se activa. 

NOTA: Esto sólo funcionará si está o bien fuera de combate o bien si las placas de nombre no se han activado en absoluto desde que se conectó. ]=]
L["ANIM_SECONDS"] = "%s Segundos"
L["ANIM_SIZE_ANIM"] = "Tamaño Inicial de Borde"
L["ANIM_SIZE_ANIM_DESC"] = "Establece cuánto de grande debería ser el borde entero. "
L["ANIM_SIZEX"] = "Ancho de Imagen"
L["ANIM_SIZEX_DESC"] = "Establece cuánto de ancha debería ser la imagen."
L["ANIM_SIZEY"] = "Altura de Imagen"
L["ANIM_SIZEY_DESC"] = "Establece cuándo de alta debería ser la imagen."
L["ANIM_TAB"] = "Animación"
L["ANIM_TEX"] = "Textura"
L["ANIM_TEX_DESC"] = [=[Escoja la textura que debería ser superpuesta. 

Puede introducir el Nombre o ID de un hechizo que tiene la textura que quiere utilizar, o puede introducir una ruta de textura, como 'Interface/Icons/spell_nature_healingtouch', o simplemente 'spell_nature_healingtouch' si la ruta es 'Interface/Icons'

También puede utilizar sus propias texturas siempre que estén situadas en el directorio de WoW (establezca este campo a la tura de la textura relativa a la carpeta raíz de WoW), sean formato .tga o .blp, y tengan dimensiones que sean potencias de 2 (32, 64, 128, etc)]=]
L["ANIM_THICKNESS"] = "Grosor del Borde"
L["ANIM_THICKNESS_DESC"] = "Establece el grosor del borde."
L["ANN_CHANTOUSE"] = "Canal a Usar"
L["ANN_EDITBOX"] = "Texto para dirigir a salida"
L["ANN_EDITBOX_DESC"] = "Escriba el texto que quiera que pase a la salida cuando se active el evento"
L["ANN_EDITBOX_WARN"] = "Escriba aquí el texto que quiera que pase a la salida"
L["ANN_FCT_DESC"] = "Dirige la salida a la característica de Blizzard Texto Flotante de Combate. DEBE estar habilitada en sus opciones de interfaz para que el texto sea dirigido a ella."
L["ANN_NOTEXT"] = "<Sin Texto>"
L["ANN_SHOWICON"] = "Mostrar textura de icono"
L["ANN_SHOWICON_DESC"] = "Algunos destinos de texto pueden mostrar una textura junto con el texto. Marque esto para activar esta característica. "
L["ANN_STICKY"] = "Adhesivo"
L["ANN_SUB_CHANNEL"] = "Sub sección"
L["ANN_TAB"] = "Texto"
L["ANN_WHISPERTARGET"] = "Susurrar al objetivo"
L["ANN_WHISPERTARGET_DESC"] = [=[Introduzca el nombre del jugador al que le gustaría susurrar. 

Se aplican los requisitos normales de servidor/facción.]=]
L["ASCENDING"] = "Ascendiendo"
L["ASPECT"] = "Aspecto"
L["AURA"] = "Aura"
L["BACK_IE"] = "Atrás"
L["BACK_IE_DESC"] = "Carga el último icono que fue editado (%s |T%s:0|t)."
L["Bleeding"] = "Sangrando"
L["BOTTOM"] = "Abajo"
L["BOTTOMLEFT"] = "Abajo Izquierda"
L["BOTTOMRIGHT"] = "Abajo Derecha"
L["BUFFCNDT_DESC"] = "Sólo el primer hechizo será comprobado, todos los demás serán ignorados. "
L["BUFFTOCHECK"] = "Ventaja a Comprobar"
L["BUFFTOCOMP1"] = "Primera Ventaja a Comparar"
L["BUFFTOCOMP2"] = "Segunda Ventaja a Comparar"
L["BURNING_EMBERS_FRAGMENTS"] = "\"Fragmentos\" de Ascuas ardientes"
L["BURNING_EMBERS_FRAGMENTS_DESC"] = [=[Cada Ascua ardiente completa consiste en 10 fragmentos. 

Si tiene 1 ascua entera y otra media ascua, por ejemplo, entonces tiene 15 fragmentos.]=]
L["CACHING"] = [=[TellMeWhen está almacenando y filtrando todos los hechizos del juego. Sólo es necesario hacer esto una vez por parche de WoW. Puede acelerar o ralentizar este proceso usando la barra deslizante inferior. 

No tiene que esperar a que se complete este proceso para usar TellMeWhen. Sólo la lista de sugerencias depende de la finalización del almacenamiento de los hechizos. ]=]
L["CACHINGSPEED"] = "Hechizos por marco:"
L["CASTERFORM"] = "Forma de Lanzador de Hechizos"
L["CENTER"] = "Centro"
L["CHAT_FRAME"] = "Marco de Chat"
L["CHAT_MSG_CHANNEL"] = "Canal de Chat"
L["CHAT_MSG_CHANNEL_DESC"] = "Dirigirá la salida a un canal de chat, como Comercio, o a un canal personalizado al que se ha unido."
L["CHAT_MSG_SMART"] = "Canal Inteligente"
L["CHAT_MSG_SMART_DESC"] = "Dirigirá la salida al canal Campo de Batalla, Banda, Grupo o Decir - lo que sea apropiado. "
L["CHOOSEICON"] = "Eliga un icono a comprobar"
L["CHOOSEICON_DESC"] = [=[|cff7fffffClick|r para elegir un icono/grupo.
|cff7fffffClick-Izquierdo y arrastrar|r para reordenar.
|cff7fffffClick-Derecho y arrastrar|r para intercambiar.]=]
L["CHOOSENAME_DIALOG"] = [=[Introduzca el Nombre o ID de lo que quiera que vigile este icono. Puede añadir múltiples entradas (cualquier combinación de nombres, IDs y equivalentes) separándolas con punto y coma (;)

Haga |cff7fffffShift-click|r en hechizos/objetos/enlaces de chat o arrastre hechizos/objetos para insertarlos en esta caja de texto.]=]
L["CHOOSENAME_DIALOG_PETABILITIES"] = "Se deben usar IDs de hechizo para las |cFFFF5959HABILIDADES DE MASCOTA|r "
L["CLEU_"] = "Cualquier evento"
L["CLEU_CAT_AURA"] = "Ventajas/Desventajas"
L["CLEU_CAT_CAST"] = "Lanzamientos"
L["CLEU_CAT_MISC"] = "Varios"
L["CLEU_CAT_SPELL"] = "Hechizos"
L["CLEU_CAT_SWING"] = "Cuerpo a Cuerpo/A Distancia"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MASK"] = "Relación de Controlador"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MINE"] = "Relación de Controlador: Jugador (Usted)"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MINE_DESC"] = "Marque para excluir unidades que están controladas por usted"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_OUTSIDER"] = "Relación de Controlador: Forasteros"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_OUTSIDER_DESC"] = "Marque para excluir unidades que son controladas por alguien que no está en su grupo"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_PARTY"] = "Relación de Controlador: Miembros del Grupo"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_PARTY_DESC"] = "Marque para excluir unidades que son controladas por un miembro de su grupo"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_RAID"] = "Relaciones de Controlador: Miembros de la Banda"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_RAID_DESC"] = "Marque para excluir unidades controladas por alguien que está en su grupo de banda. "
L["CLEU_COMBATLOG_OBJECT_CONTROL_MASK"] = "Controlador"
L["CLEU_COMBATLOG_OBJECT_CONTROL_NPC"] = "Controlador: Servidor"
L["CLEU_COMBATLOG_OBJECT_CONTROL_NPC_DESC"] = "Marque para excluir unidades que son controladas por el servidor, incluyendo sus mascotas y guardianes. "
L["CLEU_COMBATLOG_OBJECT_CONTROL_PLAYER"] = "Controlador: Humano"
L["CLEU_COMBATLOG_OBJECT_CONTROL_PLAYER_DESC"] = "Marque para excluir unidades controladas por seres humanos, incluyendo sus mascotas y guardianes. "
L["CLEU_COMBATLOG_OBJECT_FOCUS"] = "Varios: Su Foco"
L["CLEU_COMBATLOG_OBJECT_FOCUS_DESC"] = "Marque para excluir la unidad que tiene establecida como su foco"
L["CLEU_COMBATLOG_OBJECT_MAINASSIST"] = "Varios: Asistente Principal"
L["CLEU_COMBATLOG_OBJECT_MAINASSIST_DESC"] = "Marque para excluir unidades marcadas como asistentes principales en su banda"
L["CLEU_COMBATLOG_OBJECT_MAINTANK"] = "Varios: Tanque Principal"
L["CLEU_COMBATLOG_OBJECT_MAINTANK_DESC"] = "Marque para excluir unidades marcadas como tanques principales en su banda"
L["CLEU_COMBATLOG_OBJECT_NONE"] = "Varios: Unidad Desconocida"
L["CLEU_COMBATLOG_OBJECT_NONE_DESC"] = "Marque para excluir unidades que son completamente desconocidas al cliente de WoW. Esto sucede muy raras veces, y puede en general dejarse desmarcado. "
L["CLEU_COMBATLOG_OBJECT_REACTION_FRIENDLY"] = "Reacción de Unidad: Amistosa"
L["CLEU_COMBATLOG_OBJECT_REACTION_FRIENDLY_DESC"] = "Marque para excluir unidades que son amistosas hacia usted."
L["CLEU_COMBATLOG_OBJECT_REACTION_HOSTILE"] = "Reacción de Unidad: Hostil"
L["CLEU_COMBATLOG_OBJECT_REACTION_HOSTILE_DESC"] = "Marque para excluir unidades que son hostiles hacia usted. "
L["CLEU_COMBATLOG_OBJECT_REACTION_MASK"] = "Reacción de Unidad"
L["CLEU_COMBATLOG_OBJECT_REACTION_NEUTRAL"] = "Reacción de Unidad: Neutral"
L["CLEU_COMBATLOG_OBJECT_REACTION_NEUTRAL_DESC"] = "Marque para excluir unidades que son neutrales hacia usted. "
L["CLEU_COMBATLOG_OBJECT_TARGET"] = "Varios: Su objetivo"
L["CLEU_COMBATLOG_OBJECT_TARGET_DESC"] = "Marque para excluir a la unidad a la que está apuntando. "
L["CLEU_COMBATLOG_OBJECT_TYPE_GUARDIAN"] = "Tipo de Unidad: Guardián"
L["CLEU_COMBATLOG_OBJECT_TYPE_GUARDIAN_DESC"] = "Marque para excluir Guardianes. Los Guardianes son unidades que defienden a su controlador pero no pueden ser controladas directamente. "
L["CLEU_COMBATLOG_OBJECT_TYPE_MASK"] = "Tipo de Unidad"
L["CLEU_COMBATLOG_OBJECT_TYPE_NPC"] = "Tipo de Unidad: PNJ"
L["CLEU_COMBATLOG_OBJECT_TYPE_NPC_DESC"] = "Marque para excluir personajes no jugadores. "
L["CLEU_COMBATLOG_OBJECT_TYPE_OBJECT"] = "Tipo de Unidad: Objeto"
L["CLEU_COMBATLOG_OBJECT_TYPE_OBJECT_DESC"] = "Marque para excluir unidades como trampas, corchos de pesca, o cualquier otra cosa que no entre en las otras categorías de \"Tipo de Unidad\""
L["CLEU_COMBATLOG_OBJECT_TYPE_PET"] = "Tipo de Unidad: Mascota"
L["CLEU_COMBATLOG_OBJECT_TYPE_PET_DESC"] = "Marque para excluir Mascotas. Las Mascotas son unidades que defienden a su controlador y pueden ser controladas directamente. "
L["CLEU_COMBATLOG_OBJECT_TYPE_PLAYER"] = "Tipo de Unidad: Personaje Jugador"
L["CLEU_COMBATLOG_OBJECT_TYPE_PLAYER_DESC"] = "Marque para excluir personajes jugadores. "
L["CLEU_DAMAGE_SHIELD"] = "Escudo de daño"
L["CLEU_DAMAGE_SHIELD_DESC"] = "Sucede cuando un escudo de daño (%s, %s, etc., pero no %s) daña una unidad"
L["CLEU_DAMAGE_SHIELD_MISSED"] = "Escudo de Daño Falló"
L["CLEU_DAMAGE_SHIELD_MISSED_DESC"] = "Sucede cuando un escudo de daño (%s, %s, etc., pero no %s), no consigue dañar a una unidad."
L["CLEU_DAMAGE_SPLIT"] = "Daño Dividido"
L["CLEU_DAMAGE_SPLIT_DESC"] = "Sucede cuando se divide el daño entre dos o más objetivos. "
L["CLEU_DESTUNITS"] = "Unidad(es) destino a comprobar"
L["CLEU_DESTUNITS_DESC"] = "Elija las unidades destino a las que quiere que reaccione el icono, |cff7fffffO|r deje esto en blanco para permitir al icono reaccionar a cualquier destino de evento. "
L["CLEU_DIED"] = "Muerte"
L["CLEU_ENCHANT_APPLIED"] = "Encantamiento Aplicado"
L["CLEU_ENCHANT_APPLIED_DESC"] = "Cubre encantamientos temporales de arma como los venenos de pícaro y los imbuir de chamán. "
L["CLEU_ENCHANT_REMOVED"] = "Encantamiento Eliminado"
L["CLEU_ENCHANT_REMOVED_DESC"] = "Cubre encantamientos temporales de arma como los venenos de pícaro y los imbuir de chamán. "
L["CLEU_ENVIRONMENTAL_DAMAGE"] = "Daño Ambiental"
L["CLEU_ENVIRONMENTAL_DAMAGE_DESC"] = "Incluye daño de lava, fatiga, ahogamiento y caídas. "
L["CLEU_EVENTS"] = "Eventos a comprobar"
L["CLEU_EVENTS_ALL"] = "Todo"
L["CLEU_EVENTS_DESC"] = "Elija los eventos de combate a los que quiere que reaccione el icono"
L["CLEU_FLAGS_DESC"] = "Contiene una lista de atributos que pueden ser usados para que ciertas unidades no activen el icono. Si una exclusión está marcada, y una unidad tiene ese atributo, el icono no procesará el evento del que la unidad formaba parte. "
L["CLEU_FLAGS_DEST"] = "Exclusiones"
L["CLEU_FLAGS_SOURCE"] = "Exclusiones"
L["CLEU_HEADER"] = "Filtros de Eventos de Combate"
L["CLEU_NOFILTERS"] = "El icono %s en %s no tiene ningún filtro definido. No funcionará hasta que defina al menos un filtro. "
L["CLEU_PARTY_KILL"] = "Muerte de Grupo"
L["CLEU_PARTY_KILL_DESC"] = "Sucede cuando alguien en su grupo mata algo."
L["CLEU_RANGE_DAMAGE"] = "Daño a Distancia"
L["CLEU_RANGE_MISSED"] = "Fallo a Distancia"
L["CLEU_SOURCEUNITS"] = "Unidad(es) fuente a comprobar"
L["CLEU_SOURCEUNITS_DESC"] = "Elija las unidades fuente a las que le gustaría que este icono reaccionase,  |cff7fffffO|r deje esto en blanco para permitir al icono reaccionar a cualquier fuente de eventos. "
L["CLEU_SPELL_AURA_APPLIED"] = "Aura Aplicada"
L["CLEU_SPELL_AURA_APPLIED_DOSE"] = "Acumulación de Aura Aplicada"
L["CLEU_SPELL_AURA_BROKEN"] = "Aura Rota"
L["CLEU_SPELL_AURA_BROKEN_SPELL"] = "Aura Rota por Hechizo"
L["CLEU_SPELL_AURA_BROKEN_SPELL_DESC"] = [=[Sucede cuando un aura, habitualmente alguna forma de control de masas, se rompe por daño de un hechizo. 

El icono filtra por el aura que se rompió; el hechizo que la rompió puede accederse con la sustitución [Extra] en los displays de texto. ]=]
L["CLEU_SPELL_AURA_REFRESH"] = "Aura Renovada"
L["CLEU_SPELL_AURA_REMOVED"] = "Aura Eliminada"
L["CLEU_SPELL_AURA_REMOVED_DOSE"] = "Acumulación de Aura Eliminada"
L["CLEU_SPELL_CAST_FAILED"] = "Lanzamiento de Hechizo Fallido"
L["CLEU_SPELL_CAST_START"] = "Comienzo de Lanzamiento de Hechizo"
L["CLEU_SPELL_CAST_START_DESC"] = [=[Sucede cuando un hechizo se comienza a lanzar. 

NOTA: Para prevenir abusos potenciales, Blizzard ha excluido la unidad destino de este evento, de modo que no puede filtrar por ella. ]=]
L["CLEU_SPELL_CAST_SUCCESS"] = "Éxito en Lanzamiento de Hechizo"
L["CLEU_SPELL_CAST_SUCCESS_DESC"] = "Sucede cuando se lanza un hechizo. "
L["CLEU_SPELL_CREATE"] = "Hechizo Crea"
L["CLEU_SPELL_CREATE_DESC"] = "Sucede cuando un objeto, tal como una trampa de cazador o un portal de mago, es creado."
L["CLEU_SPELL_DAMAGE"] = "Daño de Hechizo"
L["CLEU_SPELL_DAMAGE_CRIT"] = "Crítico de Hechizo"
L["CLEU_SPELL_DAMAGE_CRIT_DESC"] = "Sucede cuando cualquier hechizo hace daño crítico. Esto puede suceder al mismo tiempo que el evento %q."
L["CLEU_SPELL_DAMAGE_DESC"] = "Sucede cuando cualquier hechizo hace cualquier daño. "
L["CLEU_SPELL_DISPEL"] = "Disipar"
L["CLEU_SPELL_DISPEL_DESC"] = [=[Sucede cuando un aura es disipada. 

El icono filtra por el aura que fue disipada; el hechizo que la disipó puede accederse con la sustitución [Extra] en los displays de texto. ]=]
L["CLEU_SPELL_DISPEL_FAILED"] = "Disipar Fallido"
L["CLEU_SPELL_DISPEL_FAILED_DESC"] = [=[Sucede cuando un aura no se pudo dispersar. 

El icono filtra por el aura que se intentó dispersar; el hechizo que lo intentó puede accederse con la sustitución [Extra] en los displays de texto. ]=]
L["CLEU_SPELL_DRAIN"] = "Recurso Drenado"
L["CLEU_SPELL_DRAIN_DESC"] = "Sucede cuando se eliminan recursos (salud/maná/ira/energía/etc) de una unidad. "
L["CLEU_SPELL_ENERGIZE"] = "Recurso Ganado"
L["CLEU_SPELL_ENERGIZE_DESC"] = "Sucede cuando se una unidad gana recursos (salud/maná/ira/energía/etc) "
L["CLEU_SPELL_EXTRA_ATTACKS"] = "Ataques Extra Ganados"
L["CLEU_SPELL_EXTRA_ATTACKS_DESC"] = "Sucede cuando un proc concede ataques extra cuerpo a cuerpo."
L["CLEU_SPELL_HEAL"] = "Sanar"
L["CLEU_SPELL_INSTAKILL"] = "Muerte Instantánea"
L["CLEU_SPELL_INTERRUPT"] = "Interrupción - Hechizo Interrumpido"
L["CLEU_SPELL_INTERRUPT_DESC"] = [=[Ocurre cuando se interrumpe el lanzamiento de un hechizo. 

El icono se puede filtrar por el hechizo que fue interrumpido. El hechizo de interrupción que lo interrupció puede ser accedido con la sustitución [Extra] en los displays de texto. 

Tome nota de la diferencia entre los dos eventos de interrupción - ambos sucederán siempre cuando un hechizo sea interrumpido, pero cada uno filtra los hechizos involucrados de forma diferente. ]=]
L["CLEU_SPELL_INTERRUPT_SPELL"] = "Interrupción - Hechizo de Interrupción Usado"
L["CLEU_SPELL_INTERRUPT_SPELL_DESC"] = [=[Sucede cuando un lanzamiento de hechizo es interrumpido. 

El icono se puede filtrar por el hechizo que causó la interrupción. El hechizo que fue interrumpido puede accederse con la sustitución [Extra] en los displays de texto. 

Tenga en cuenta la diferencia entre los dos eventos de interrupción - ambos sucederán siempre cuando se interrumpa un hechizo, pero cada uno filtra los hechizos involucrados de forma diferente. ]=]
L["CLEU_SPELL_LEECH"] = "Parasitación de Recursos. "
L["CLEU_SPELL_LEECH_DESC"] = "Sucede cuando recursos (salud/maná/ira/energía/etc) son eliminados de una unidad y simultáneamente otorgados a otra."
L["CLEU_SPELL_MISSED"] = "Fallo de Hechizo"
L["CLEU_SPELL_PERIODIC_DAMAGE"] = "Daño Periódico"
L["CLEU_SPELL_PERIODIC_DRAIN"] = "Drenaje de Recurso Periódico"
L["CLEU_SPELL_PERIODIC_ENERGIZE"] = "Ganancia de Recurso Periódica"
L["CLEU_SPELL_PERIODIC_HEAL"] = "Sanación Periódica"
L["CLEU_SPELL_PERIODIC_LEECH"] = "Parasitación Periódica"
L["CLEU_SPELL_PERIODIC_MISSED"] = "Fallo periódico"
L["CLEU_SPELL_REFLECT"] = "Reflejo de Hechizos"
L["CLEU_SPELL_REFLECT_DESC"] = [=[Sucede cuando se refleja un hechizo de vuelta a su lanzador. 

La unidad origen es quienquiera que lo reflejó, la unidad destino es a quienquiera que fuera reflejado de vuelta. ]=]
L["CLEU_SPELL_RESURRECT"] = "Resurrección"
L["CLEU_SPELL_RESURRECT_DESC"] = "Sucede cuando una unidad es resucitada de la muerte. "
L["CLEU_SPELL_STOLEN"] = "Aura Robada"
L["CLEU_SPELL_STOLEN_DESC"] = [=[Sucede cuando una ventaja es robada, probablemente por %s.

El icono se puede filtrar por el hechizo que fue robado. ]=]
L["CLEU_SPELL_SUMMON"] = "Hechizo Invoca"
L["CLEU_SPELL_SUMMON_DESC"] = "Sucede cuando un PNJ, como una mascota o un tótem, es invocado o aparece."
L["CLEU_SWING_DAMAGE"] = "Daño de Golpe"
L["CLEU_SWING_MISSED"] = "Fallo de Golpe"
L["CLEU_TIMER"] = "Temporizador a establecer en el evento"
L["CLEU_TIMER_DESC"] = [=[Duración en segundos del temporizador a establecer en el icono cuando sucede un evento. 

También puede establecer duraciones utilizando la sintaxis "Hechizo: Duración" en el cuadro de edición %q para usar cada vez que un evento es manejado utilizando un hechizo que ha establecido como filtro. 

Si no se define duración para un hechizo, o no tiene ningún filtro de hechizo establecido (el cuadro de edición está en blanco) se usará esta duración. ]=]
L["CLEU_UNIT_DESTROYED"] = "Unidad Destruida"
L["CLEU_UNIT_DESTROYED_DESC"] = "Ocurre cuando una unidad como un tótem es destruida. "
L["CLEU_UNIT_DIED"] = "Unidad Murió"
L["CLEU_WHOLECATEGORYEXCLUDED"] = [=[Ha excluido todas las partes de la categoría %q, lo que provocará que este icono no procese ningún evento. 

Desmarque al menos una para una funcionalidad adecuada. ]=]
L["CMD_DISABLE"] = "deshabilitar"
L["CMD_ENABLE"] = "habilitar"
L["CMD_OPTIONS"] = "Opciones"
L["CMD_PROFILE"] = "perfil"
L["CMD_PROFILE_INVALIDPROFILE"] = "No existe el perfil llamado %q!"
L["CMD_PROFILE_INVALIDPROFILE_SPACES"] = "Consejo: Si el nombre de perfil contiene espacios, escríbalo entre comillas "
L["CMD_TOGGLE"] = "alternar"
L["CNDT_ONLYFIRST"] = "Sólo el primer hechizo/objeto será comprobado - listas delimitadas por punto y coma no son válidas para este tipo de condición. "
L["CNDT_SLIDER_DESC_CLICKSWAP_TOMANUAL"] = "|cff7fffffClick-Derecho|r para cambiar a entrada manual. "
L["CNDT_SLIDER_DESC_CLICKSWAP_TOSLIDER"] = "|cff7fffffClick-Derecho|r para cambiar a entrada de deslizador. "
L["CNDT_SLIDER_DESC_CLICKSWAP_TOSLIDER_DISALLOWED"] = "Sólo se permite entrada manual para valores por encima de %s (Los deslizadores de Blizzard pueden comportarse de manera extraña con valores muy grandes.)"
L["CNDT_TOTEMNAME"] = "Nombre(s) de Tótem(s)"
L["CNDT_TOTEMNAME_DESC"] = [=[Deje en blanco para seguir cualquier tótem del tipo seleccionado. 

Introduzca un nombre de tótem, o una lista de nombres separados por punto y coma, para sólo comprobar ciertos tótems. ]=]
L["CNDTCAT_ARCHFRAGS"] = "Fragmentos de Arqueología"
L["CNDTCAT_ATTRIBUTES_PLAYER"] = "Atributos de Jugador"
L["CNDTCAT_ATTRIBUTES_UNIT"] = "Atributos de Unidad"
L["CNDTCAT_BUFFSDEBUFFS"] = "Ventajas/Desventajas"
L["CNDTCAT_CURRENCIES"] = "Monedas"
L["CNDTCAT_FREQUENTLYUSED"] = "Usado Frecuentemente"
L["CNDTCAT_MISC"] = "Varios"
L["CNDTCAT_RESOURCES"] = "Recursos"
L["CNDTCAT_SPELLSABILITIES"] = "Hechizos/Objetos"
L["CNDTCAT_STATS"] = "Estadísticas de Combate"
L["CODESNIPPET_CODE"] = "Código Lua a Ejecutar"
L["CODESNIPPET_DELETE"] = "Borrar Snippet"
L["CODESNIPPET_DELETE_CONFIRM"] = "¿Está seguro de que quiere borrar el snippet de código %q?"
L["CODESNIPPET_GLOBAL"] = "Snippets Globales"
L["CODESNIPPET_ORDER"] = "Orden de Ejecución"
L["CODESNIPPET_ORDER_DESC"] = [=[Establece el ordene en que se debería ejecutar este snippet en relación a otros snippets. 

%s y %s se mezclarán basados en este valor cuando sean ejecutados. 

Se admiten cantidades fraccionarias. No se garantiza un orden consistente si dos snippets comparten el mismo orden. ]=]
L["CODESNIPPET_PROFILE"] = "Snippets de Perfil"
L["CODESNIPPET_RENAME"] = "Nombre de Snippet de Código"
L["CODESNIPPET_RENAME_DESC"] = [=[Elija un nombre para este snippet de modo que pueda identificarlo fácilmente. 

Los nombres no tienen que ser únicos. ]=]
L["CODESNIPPET_RUNNOW"] = "Ejecutar Snippet Ahora"
L["CODESNIPPET_RUNNOW_DESC"] = [=[Pulse para ejecutar este snippet de código. 

Mantenga pulsado |cff7fffffCtrl|r para saltar la confirmación si el snippet ya ha sido ejecutado. ]=]
L["CODESNIPPETS"] = "Snippets de Código Lua"
L["CODESNIPPETS_DEFAULTNAME"] = "Nuevo Snippet"
L["CODESNIPPETS_DESC"] = [=[Esta funcionalidad le permite escribir fragmentos de código Lua que serán ejecutados cuando TellMeWhen se esté inicializando. 

Es una funcionalidad avanzapara para aquellos que tienen experiencia con Lua (o para quienes han recibido un snippet por otro usuario de TellMeWhen)

Los usos posibles incluyen escribir funciones personalizadas para usar en condiciones Lua (asegúrese de definir estas en TMW.CNDT.Env).

Los snippets se pueden definir por perfil o globalmente (ejecutarán en todos los perfiles). ]=]
L["CODESNIPPETS_IMPORT_GLOBAL"] = "Nuevo Snippet Global"
L["CODESNIPPETS_IMPORT_GLOBAL_DESC"] = "Importa el snippet como un snippet global."
L["CODESNIPPETS_IMPORT_PROFILE"] = "Nuevo Snippet de Perfil"
L["CODESNIPPETS_IMPORT_PROFILE_DESC"] = "Importa el snippet como un snippet específico de perfil. "
L["CODESNIPPETS_TITLE"] = "Snippets Lua (Avanzado)"
L["CODETOEXE"] = "Código a Ejecutar"
L["COLOR_MSQ_COLOR"] = "Colorear borde Masque"
L["COLOR_MSQ_COLOR_DESC"] = "Marcar esto hará que el borde de una piel de Masque (si la piel que está usando tiene un borde) sea coloreado."
L["COLOR_MSQ_ONLY"] = "Sólo colorear borde de Masque"
L["COLOR_MSQ_ONLY_DESC"] = "Marcar esto hará que SOLO el borde de una piel de Masque (si la piel que está usando tiene un borde) sea coloreado. Los iconos NO serán coloreados"
L["COMPARISON"] = "Comparación"
L["CONDITION_QUESTCOMPLETE"] = "Misión Completa"
L["CONDITION_QUESTCOMPLETE_DESC"] = "Comprueba si una misión está completa. "
L["CONDITION_QUESTCOMPLETE_EB_DESC"] = [=[Introduzca el ID de misión de la misión que quiera comprobar. 

Los IDs de misión se pueden obtener de la URL al mirar la misión en un sitio de base de datos como Wowhead. 

p. Ej. el ID de misión de http://www.wowhead.com/quest=28716/heros-call-twilight-highlands es 28716]=]
L["CONDITION_TIMEOFDAY"] = "Hora del Día"
L["CONDITION_TIMEOFDAY_DESC"] = [=[Esta condición comprueba la hora actual del día. 

La hora comprobada es su hora local, basada en el reloj de su ordenador. No comprueba la hora del servidor. ]=]
L["CONDITION_TIMERS_FAIL_DESC"] = "Duración del temporizador a establecer en el icono cuando las condiciones empiezan a no cumplirse"
L["CONDITION_TIMERS_SUCCEED_DESC"] = "Duración del temporizador a establecer en el icono cuando las condiciones empiezan a cumplirse"
L["CONDITION_WEEKDAY"] = "Día de la semana"
L["CONDITION_WEEKDAY_DESC"] = [=[Comprueba el día de la semana actual. 

La hora comprobada es su hora local, basada en el reloj de su ordenador. No comprueba la hora del servidor. ]=]
L["CONDITIONALPHA_METAICON"] = "Condiciones No Cumplidas"
L["CONDITIONALPHA_METAICON_DESC"] = [=[Esta opacidad se usará cuando las condiciones no se cumplan. 

Las condiciones se pueden configurar en la pestaña %q.]=]
L["CONDITIONPANEL_ABSOLUTE"] = "Absoluto"
L["CONDITIONPANEL_ADD"] = "Añadir una condición"
L["CONDITIONPANEL_ADD2"] = "Pulse para añadir una condición"
L["CONDITIONPANEL_ALIVE"] = "Unidad está Viva"
L["CONDITIONPANEL_ALIVE_DESC"] = "La condición se pasará si la unidad especificada está viva."
L["CONDITIONPANEL_ALTPOWER"] = "Poder Alt."
L["CONDITIONPANEL_ALTPOWER_DESC"] = "Este es el poder específico del encuentro usado en varios encuentros en Cataclismo, incluyendo Cho'gall y Atramedes"
L["CONDITIONPANEL_AND"] = "Y"
L["CONDITIONPANEL_ANDOR"] = "Y / O"
L["CONDITIONPANEL_ANDOR_DESC"] = "|cff7fffffClick|r para alternar entre operadores lógicos AND y OR"
L["CONDITIONPANEL_AUTOCAST"] = "Autolanzamiento de hechizos de mascota"
L["CONDITIONPANEL_BLIZZEQUIPSET"] = "Conjunto de equipamiento equipado"
L["CONDITIONPANEL_BLIZZEQUIPSET_DESC"] = "Comprueba si tiene o no equipado un conjunto de equipamiento específico del gestor de equipamiento de Blizzard."
L["CONDITIONPANEL_BLIZZEQUIPSET_INPUT"] = "Nombre del conjunto de equipamiento"
L["CONDITIONPANEL_BLIZZEQUIPSET_INPUT_DESC"] = [=[Introduzca el nombre del conjunto de equipamiento de Blizzard que desea comprobar. 

Sólo se puede introducir un conjunto de equipamiento, y |cFFFF5959DISTINGUE MAYÚSCULAS DE MINÚSCULAS|r]=]
L["CONDITIONPANEL_CASTCOUNT"] = "Cuenta de Lanzamiento de Hechizo"
L["CONDITIONPANEL_CASTCOUNT_DESC"] = "Comprueba el número de veces que una unidad ha lanzado un cierto hechizo. "
L["CONDITIONPANEL_CASTTOMATCH"] = "Hechizo a Comparar"
L["CONDITIONPANEL_CASTTOMATCH_DESC"] = [=[Introduzca un nombre de hechizo aquí para hacer que la condición se cumpla sólo si el hechizo lanzado concuerda exactamente con él.

Puede dejar esto en blanco para comprobar cualquier lanzamiento de hechizo/canalización]=]
L["CONDITIONPANEL_CLASS"] = "Clase de Unidad"
L["CONDITIONPANEL_CLASSIFICATION"] = "Clasificación de Unidades"
L["CONDITIONPANEL_COMBAT"] = "Unidad en Combate"
L["CONDITIONPANEL_COMBO"] = "Puntos de Combo"
L["CONDITIONPANEL_CREATURETYPE"] = "Tipo de Criatura Unidad"
L["CONDITIONPANEL_CREATURETYPE_DESC"] = [=[Puede introducir múltiples tipos de criatura para comparar separándolos con punto y coma (;).

Los tipos de criatura deben ser escritos exactamente como aparecen en el tooltip de la criatura. 

La condición se cumplirá si coincide algún tipo.]=]
L["CONDITIONPANEL_CREATURETYPE_LABEL"] = "Tipo(s) de Criatura"
L["CONDITIONPANEL_DEFAULT"] = "Elija un tipo..."
L["CONDITIONPANEL_ECLIPSE_DESC"] = "Eclipse tiene un rango desde -100 (eclipse lunar) a 100 (eclipse solar). Introduzca -80 si quiere que el icono funcione con un valor de poder lunar 80. "
L["CONDITIONPANEL_EQUALS"] = "Iguales"
L["CONDITIONPANEL_EXISTS"] = "Unidad Existe"
L["CONDITIONPANEL_GREATER"] = "Mayor Que"
L["CONDITIONPANEL_GREATEREQUAL"] = "Mayor o Igual a"
L["CONDITIONPANEL_GROUPTYPE"] = "Tipo de Grupo"
L["CONDITIONPANEL_ICON"] = "Icono Mostrado"
L["CONDITIONPANEL_ICON_DESC"] = [=[La condición comprueba si el icono especificado está mostrado u oculto

Si no quiere mostrar los iconos que se están comprobando, marque %q en el editor de iconos de ese icono.

El grupo del icono que se está comprobando debe mostrarse para comprobar el icono, incluso si la condición se establece como falsa.]=]
L["CONDITIONPANEL_ICON_HIDDEN"] = "Oculto"
L["CONDITIONPANEL_ICON_SHOWN"] = "Mostrado"
L["CONDITIONPANEL_ICONHIDDENTIME"] = "Tiempo Icono Oculto"
L["CONDITIONPANEL_ICONHIDDENTIME_DESC"] = [=[La condición comprueba durante cuánto tiempo ha estado oculto el icono especificado. 

Si no quiere mostrar el icono que se está comprobando, marque %q en el editor de iconos de ese icono. 

El grupo del icono siendo comprobado debe mostrarse para comprobar el icono. ]=]
L["CONDITIONPANEL_ICONSHOWNTIME"] = "Tiempo Icono Mostrado"
L["CONDITIONPANEL_ICONSHOWNTIME_DESC"] = [=[La condición comprueba durante cuánto tiempo ha estado mostrándose el icono especificado. 

Si no quiere mostrar el icono que se está comprobando, marque %q en el editor de iconos de ese icono. 

El grupo del icono siendo comprobado debe mostrarse para comprobar el icono. ]=]
L["CONDITIONPANEL_INPETBATTLE"] = "En batalla de mascotas"
L["CONDITIONPANEL_INSTANCETYPE"] = "Tipo de Instancia"
L["CONDITIONPANEL_INTERRUPTIBLE"] = "Interrumpible"
L["CONDITIONPANEL_ITEMRANGE"] = "Objeto al alcance de la unidad"
L["CONDITIONPANEL_LESS"] = "Menor Que"
L["CONDITIONPANEL_LESSEQUAL"] = "Menor o Igual a"
L["CONDITIONPANEL_LEVEL"] = "Nivel de la Unidad"
L["CONDITIONPANEL_MANAUSABLE"] = "Hechizo Utilizable (Maná/Energía/etc.)"
L["CONDITIONPANEL_MAX"] = "Max"
L["CONDITIONPANEL_MOUNTED"] = "Montado"
L["CONDITIONPANEL_NAME"] = "Nombre de la Unidad"
L["CONDITIONPANEL_NAMETOMATCH"] = "Nombre a Comparar"
L["CONDITIONPANEL_NAMETOOLTIP"] = "Puede introducir múltiples nombres para comparar separándolos con punto y coma (;). La condición pasará si cualquiera de los nombres coincide. "
L["CONDITIONPANEL_NOTEQUAL"] = "No es Igual a"
L["CONDITIONPANEL_NPCID"] = "ID de Unidad PNJ"
L["CONDITIONPANEL_NPCID_DESC"] = [=[Comprueba si una unidad tiene un ID de PNJ especificado

El ID de PNJ es el número que se encuentra en la URL al mirar la página de Wowhead del PNJ (P.ej. http://www.wowhead.com/npc=62943)

Los jugadores y otras unidades sin ID de PNJ serán tratadas por esta condición como si tuvieran un ID de 0]=]
L["CONDITIONPANEL_NPCIDTOMATCH"] = "ID a Emparejar"
L["CONDITIONPANEL_NPCIDTOOLTIP"] = "Puede introducir múltiples IDs de PNJs para emparejar separándolas con punto y coma (;). La condición se cumplirá si se empareja cualquier ID. "
L["CONDITIONPANEL_OPERATOR"] = "Operador"
L["CONDITIONPANEL_OR"] = "O"
L["CONDITIONPANEL_PERCENT"] = "Porcentaje"
L["CONDITIONPANEL_PETMODE"] = "Modo de ataque de la mascota"
L["CONDITIONPANEL_PETSPEC"] = "Especialización de mascota"
L["CONDITIONPANEL_POWER"] = "Recurso Primario"
L["CONDITIONPANEL_POWER_DESC"] = "Comprobará energía si la unidad es un druida en forma de gato, ira si la unidad es un guerrero, etc"
L["CONDITIONPANEL_PVPFLAG"] = "Unidad está Marcada JcJ"
L["CONDITIONPANEL_RAIDICON"] = "Icono de Banda de Unidad"
L["CONDITIONPANEL_REMOVE"] = "Eliminar esta condición"
L["CONDITIONPANEL_RESTING"] = "Descansando"
L["CONDITIONPANEL_ROLE"] = "Rol de la Unidad"
L["CONDITIONPANEL_RUNES_CHECK_DESC"] = [=[Normalmente, las runas de la fila superior para esta condición les permitía emparejarse con una runa normal o con una runa de muerte en esa ranura. 

Active esta opción para forzar a las runas de la fila superior a que sólo se emparejen con runas que no sean runas de muerte. ]=]
L["CONDITIONPANEL_SPELLRANGE"] = "Hechizo al alcance de la unidad"
L["CONDITIONPANEL_SWIMMING"] = "Nadando"
L["CONDITIONPANEL_THREAT_RAW"] = "Amenaza de la Unidad - Base"
L["CONDITIONPANEL_THREAT_RAW_DESC"] = [=[Esta condición comprueba su porcentaje de amenaza base en una unidad. 

Los jugadores a distancia de cuerpo a cuerpo son atacados al 110%
Los jugadores a distancia son atacados al 130%
Los jugadores con agro (siendo atacados) tienen un porcentaje base de amenaza del 255%]=]
L["CONDITIONPANEL_THREAT_SCALED"] = "Amenaza de Unidad - Escalado"
L["CONDITIONPANEL_THREAT_SCALED_DESC"] = [=[Esta condición comprueba su porcentaje de amenaza escalado en una unidad. 

100% indica que está tanqueando la unidad. ]=]
L["CONDITIONPANEL_TRACKING"] = "Seguimiento activo"
L["CONDITIONPANEL_TYPE"] = "Tipo"
L["CONDITIONPANEL_UNIT"] = "Unidad"
L["CONDITIONPANEL_UNITISUNIT"] = "Unidad es Unidad"
L["CONDITIONPANEL_UNITISUNIT_DESC"] = "Esta condición se cumplirá si las unidades en el primer cuadro de edición y en el segundo son la misma entidad. "
L["CONDITIONPANEL_UNITISUNIT_EBDESC"] = "Introduzca una unidad en este cuadro de edición para compararla con la primera unidad. "
L["CONDITIONPANEL_VALUEN"] = "Valor"
L["CONDITIONPANEL_VEHICLE"] = "Unidad Controla Vehículo"
L["CONDITIONS"] = "Condiciones"
L["CONFIGMODE"] = "TellMeWhen está en modo de configuración. Los iconos no funcionarán hasta que salga del modo de configuración. Escriba '/tellmewhen' o '/tmw' para activar o desactivar el modo de configuración. "
L["CONFIGMODE_EXIT"] = "Salir del modo de configuración"
L["CONFIGMODE_NEVERSHOW"] = "No mostrar de nuevo"
L["CONFIGPANEL_CBAR_HEADER"] = "Barra de Temporizador Superpuesta"
L["CONFIGPANEL_CLEU_HEADER"] = "Eventos de Combate"
L["CONFIGPANEL_CNDTTIMERS_HEADER"] = "Temporizadores de Condición"
L["CONFIGPANEL_PBAR_HEADER"] = "Barra de Poder Superpuesta"
L["CONFIGPANEL_TIMER_HEADER"] = "Barrido de Temporizador"
L["CONFIGPANEL_TIMERBAR_BARDISPLAY_HEADER"] = "Barra de temporizador"
L["COPYGROUP"] = "Copiar Grupo"
L["COPYPOSSCALE"] = "Copiar posición/escala"
L["CrowdControl"] = "Control de Masas"
L["Curse"] = "Maldición"
L["DamageBuffs"] = "Ventajas de Daño"
L["DamageShield"] = "Escudo de Daño"
L["DEBUFFTOCHECK"] = "Desventaja a Comprobar"
L["DEBUFFTOCOMP1"] = "Primera Desventaja a Comparar"
L["DEBUFFTOCOMP2"] = "Segunda Desventaja a Comparar"
L["DEFAULT"] = "Por defecto"
L["DefensiveBuffs"] = "Ventajas Defensivas"
L["DESCENDING"] = "Descendiendo"
L["DISABLED"] = "Deshabilitado"
L["Disease"] = "Enfermedad"
L["Disoriented"] = "Desorientado"
L["DR-Disorient"] = "Desorientaciones"
L["DR-Silence"] = "Silencios"
L["DR-Taunt"] = "Provocaciones"
L["DT_DOC_Destination"] = "Devuelve la unidad de destino o nombre del último Evento de Combate que el icono procesó. Uso recomendado en conjunción con la etiqueta [Name] (Esta etiqueta sólo debería usarse con iconos de tipo %s)"
L["DT_DOC_Duration"] = "Devuelve la duración restante actualmente en el icono. Se recomienda que dé formato a esto con [TMWFormatDuration]"
L["DT_DOC_Extra"] = "Devuelve el hechizo extra del último Evento de Combate que procesó el icono. (Esta etiqueta sólo debería usarse con iconos de tipo %s)"
L["DT_DOC_IsShown"] = "Devuelve si un icono es mostrado o no."
L["DT_DOC_LocType"] = "Devuelve el tipo del efecto de pérdida de control para el que el icono se está mostrando (esta etiqueta sólo debería usarse con iconos de tipo %s)"
L["DT_DOC_Name"] = "Devuelve el nombre de la unidad. Esta es una versión mejorada de la etiqueta [Name] por defecto proporcionada por DogTag. "
L["DT_DOC_Opacity"] = "Devuelve la opacidad de un icono. El valor de retorno está entre 0 y 1."
L["DT_DOC_PreviousUnit"] = "Devuelve la unidad o el nombre de la unidad que el icono ha comprobado antes de la actual unidad. Recomendado usar junto con la etiqueta [Name]."
L["DT_DOC_Source"] = "Devuelve la unidad fuente o el nombre del último Evento de Combate que el icono procesó. Recomendado usar junto con la etiqueta [Name]. (Esta etiqueta sólo debería usarse con iconos de tipo %s)"
L["DT_DOC_Spell"] = "Devuelve el hechizo u objeto para el que el icono está mostrando datos. "
L["DT_DOC_Stacks"] = "Devuelve las acumulaciones actuales del icono"
L["DT_DOC_TMWFormatDuration"] = "Devuelve una cadena formateada por el formato de tiempo de TellMeWhen. Alternativa a [FormatDuration]."
L["DT_DOC_Unit"] = "Devuelve la unidad o el nombre de la unidad que el icono está comprobando. Recomendado usarlo junto con la etiqueta [Name]."
L["DURATION"] = "Duración"
L["DURATIONALPHA_DESC"] = "Establece el nivel de opacidad con que el icono debería mostrarse cuando estos requisitos de duración no se cumplan."
L["DURATIONPANEL_TITLE2"] = "Requisitos de Duración"
L["EARTH"] = "Tierra"
L["ECLIPSE_DIRECTION"] = "Dirección de Eclipse"
L["elite"] = "Élite"
L["ENABLINGOPT"] = "TellMeWhen_Options está deshabilitado. Habilitando..."
L["Enraged"] = "Enfurecer"
L["EQUIPSETTOCHECK"] = "Conjunto de equipamiento a comprobar (|cFFFF5959DISTINGUE MAYÚSCULAS DE MINÚSCULAS|r)"
L["ERROR_ACTION_DENIED_IN_LOCKDOWN"] = "No puede hacer esto en combate si la opción %q no está activada (escriba '/tmw options')."
L["ERROR_ANCHORSELF"] = "%s estaba intentando anclarse a sí mismo, así que TellMeWhen restableció su anclaje al centro de la pantalla para prevenir un fallo catastrófico. "
L["ERROR_MISSINGFILE"] = [=[Se requiere un reinicio completo de WoW para usar TellMeWhen %s:

No se encontró %s.

Desea reiniciar WoW ahora?]=]
L["ERROR_MISSINGFILE_NOREQ"] = [=[Para usar correctamente TellMeWhen %s podría requerirse un reinicio completo de WoW:

No se encontró %s.

Desea reiniciar WoW ahora?]=]
L["ERROR_MISSINGFILE_REQFILE"] = "Un fichero requerido"
L["ERROR_NO_LOCKTOGGLE_IN_LOCKDOWN"] = "No se puede desbloquear TellMeWhen estando en combate si la opción %q no está activada (escriba '/tmw options')."
L["ERROR_NOTINITIALIZED_NO_ACTION"] = "TellMeWhen no puede ejecutar esa acción si el addon no pudo inicializarse!"
L["ERROR_NOTINITIALIZED_NO_LOAD"] = "TellmeWhen_Opciones no se puede cargar si TellMeWhen no se pudo inicializar!"
L["ERRORS_FRAME"] = "Marco de Errores"
L["ERRORS_FRAME_DESC"] = "Dirige la salida al marco estándar de errores que normalmente muestra mensajes como %q"
L["EVENTCONDITIONS"] = "Condiciones de evento"
L["EVENTCONDITIONS_DESC"] = "Pulse para configurar un conjunto de condiciones que activarán este evento cuando se empiecen a cumplir. "
L["EVENTCONDITIONS_TAB_DESC"] = "Configura un conjunto de condiciones que activarán un evento cuando se empiecen a cumplir."
L["EVENTHANDLER_LUA_CODE"] = "Código Lua a Ejecutar"
L["EVENTHANDLER_LUA_CODE_DESC"] = "Escriba aquí el código Lua que debería ejecutarse cuando se active el evento,"
L["EVENTHANDLER_LUA_LUA"] = "Lua"
L["EVENTHANDLER_LUA_TAB"] = "Lua (Avanzado)"
L["EVENTS_HANDLERS_ADD"] = "Añadir Manejador de Evento..."
L["EVENTS_HANDLERS_ADD_DESC"] = "|cff7fffffClick|r para elegir un manejador de evento para añadir a este icono. "
L["EVENTS_HANDLERS_GLOBAL_DESC"] = [=[|cff7fffffClick|r para opciones del manejador de eventos
|cff7fffffClick-Derecho|r para cambiar evento
|cff7fffffClick-y-Arrastrar|r para reordenar]=]
L["EVENTS_HANDLERS_HEADER"] = "Manejadores de Evento del Icono"
L["EVENTS_HANDLERS_PLAY"] = "Probar Evento"
L["EVENTS_HANDLERS_PLAY_DESC"] = "|cff7fffffClick|r para probar el manejador de evento"
L["EVENTS_SETTINGS_CNDTJUSTPASSED"] = "Y acaba de empezar a cumplirse"
L["EVENTS_SETTINGS_CNDTJUSTPASSED_DESC"] = "Evita que el evento sea manejado a menos que la condición configurada más arriba acabe de empezar a cumplirse. "
L["EVENTS_SETTINGS_HEADER"] = "Ajustes de Eventos"
L["EVENTS_SETTINGS_ONLYSHOWN"] = "Sólo manejar si se muestra el icono"
L["EVENTS_SETTINGS_ONLYSHOWN_DESC"] = "Evita que el evento sea manejado si el icono no se muestra"
L["EVENTS_SETTINGS_PASSINGCNDT"] = "Sólo manejar si se está cumpliendo la condición:"
L["EVENTS_SETTINGS_PASSINGCNDT_DESC"] = "Evita que el evento sea manejado a menos que la condición configurada más abajo tenga éxito. "
L["EVENTS_SETTINGS_PASSTHROUGH"] = "Continuar a eventos inferiores"
L["EVENTS_SETTINGS_PASSTHROUGH_DESC"] = [=[Marque para permitir que otro evento sea manejado después de este. 
Si se deja desmarcado, el icono no procesará más eventos después de este evento si procesa con éxito y muestra/dirige a salida alguna cosa. 

Pueden aplicarse excepciones, vea las descripciones individuales de eventos para más detalles. ]=]
L["EVENTS_TAB"] = "Eventos"
L["EVENTS_TAB_DESC"] = "Configura disparadores para sonidos, salidas de texto y animaciones. "
L["EXPORT_f"] = "Exportar %s"
L["EXPORT_HEADING"] = "Exportar"
L["EXPORT_SPECIALDESC2"] = "Otros usuarios de TellMeWhen sólo pueden importar estos datos si tienen la versión %s"
L["EXPORT_TOCOMM"] = "A Jugador"
L["EXPORT_TOCOMM_DESC"] = [=[Escriba el nombre de un jugador en el cuadro de edición y elija esta opción para enviarle los datos. Debe ser alguien a quien pueda susurrar (misma facción, servidor, online), y debe tener TellMeWhen v4.0.0+

También puede escribir "GUILD" o "RAID" (diferencia mayúsculas y minúsculas) para enviar a toda su hermandad o grupo de banda. ]=]
L["EXPORT_TOGUILD"] = "A Hermandad"
L["EXPORT_TORAID"] = "A Banda"
L["EXPORT_TOSTRING"] = "A Cadena"
L["EXPORT_TOSTRING_DESC"] = "Una cadena conteniendo los datos necesarios será pegada en el cuadro de edición. Pulse Ctrl+C para copiarla, y luego péguela donde quiera compartirla. "
L["FALSE"] = "Falso"
L["fCODESNIPPET"] = "Snippet de código: %s"
L["Feared"] = "Miedo"
L["fGROUP"] = "Grupo: %s"
L["fICON"] = "Icono: %s"
L["FIRE"] = "Fuego"
L["FONTCOLOR"] = "Color de Fuente"
L["FONTSIZE"] = "Tamaño de Fuente"
L["FORWARDS_IE"] = "Adelante"
L["FORWARDS_IE_DESC"] = "Carga el último icono que fue editado (%s |T%s:0|t)."
L["fPROFILE"] = "Perfil: %s"
L["FROMNEWERVERSION"] = "Está importando datos que fueron creados por una versión de TellMeWhen más reciente que la suya. Algunos ajustes podrían no funcionar hasta que se actualice a la última versión. "
L["fTEXTLAYOUT"] = "Diseño de Texto: %s"
L["GCD"] = "Tiempo de Reutilización Global"
L["GCD_ACTIVE"] = "GCD activo"
L["GENERIC_NUMREQ_CHECK_DESC"] = "Marque para habilitar y configurar el %s"
L["GENERICTOTEM"] = "Tótem %d"
L["GLYPHTOCHECK"] = "Glifo a Comprobar"
L["GROUP"] = "Grupo"
L["GROUPCONDITIONS"] = "Condiciones de Grupo"
L["GROUPCONDITIONS_DESC"] = "Configura condiciones que le permiten ajustes finos sobre cuándo se muestra este grupo. "
L["GROUPICON"] = "Grupo: %s, Icono: %s"
L["Heals"] = "Sanaciones de Jugador"
L["HELP_ANN_LINK_INSERTED"] = [=[El enlace que acaba de insertar puede parecer extraño, pero así es como debe ser formateado con DogTag.

Cambiar el código de color si está dirigiendo la salida a un canal de Blizzard romperá el enlace.]=]
L["HELP_CNDT_ANDOR_FIRSTSEE"] = [=[Puede elegir si se deben cumplir ambas condiciones o sólo se necesita que se cumpla una. 

|cff7fffffPinche|r este ajuste entre sus condiciones para cambiar este comportamiento si desea hacerlo. ]=]
L["HELP_CNDT_PARENTHESES_FIRSTSEE"] = [=[Puede agrupar conjuntos de condiciones entre sí para comprobaciones complejas, especialmente cuando se combina con el ajuste %q. 
|cff7fffffPinche|r los paréntesis entre sus condiciones para agruparlas entre sí si desea hacerlo. ]=]
L["HELP_EXPORT_DOCOPY_MAC"] = "Pulse |cff7fffffCMD+C|r para copiar"
L["HELP_EXPORT_DOCOPY_WIN"] = "Pulse |cff7fffffCTRL+C|r para copiar"
L["HELP_FIRSTUCD"] = [=[Ha usado por primera vez un tipo de icono que usa la sintaxis especial de duración!. Los hechizos que se añaden al cuadro de edición %q para ciertos tipos de iconos deben definir una duración inmediatamente tras cada hechizo usando la siguiente sintaxis: 

Hechizo: Duración

Por ejemplo: 

"%s: 120"
"%s: 10; %s: 24"
"%s: 180"
"%s: 3:00"
"62618: 3:00"

Insertar desde la lista de sugerencias añade automáticamente la duración desde el tooltip.]=]
L["HELP_IMPORT_CURRENTPROFILE"] = [=[Intentando mover o copiar un icono desde este perfil a otra ranura de icono?

Puede hacerlo fácilmente haciendo |cff7fffffClick-Derecho y arrastrando|r el icono (mantenga pulsado el botón del ratón) a otra ranura. Cuando libere el botón del ratón, aparecerá un menú con muchas opciones. 

Intente arrastrar un icono a un meta icono, otro grupo, u otro marco en su pantalla para otras opciones. ]=]
L["HELP_MISSINGDURS"] = [=[A los siguientes hechizos les falta duración: 

%s

Para añadir duraciones, utilice la siguiente sintaxis: 

Nombre del Hechizo: Duración

P.Ej. "%s: 10"

Insertar desde la lista de sugerencias añade automáticamente la duración desde el tooltip.]=]
L["HELP_NOUNIT"] = "Debe introducir una unidad!"
L["HELP_NOUNITS"] = "Debe introducir al menos una unidad!"
L["HELP_POCKETWATCH"] = [=[|TInterface\Icons\INV_Misc_PocketWatch_01:20|t -- La textura del reloj de bolsillo.
Se está usando esta textura porque el primer hechizo válido a comprobar se introdujo por nombre y no está en su libro de hechizos. 

La textura correcta se usará una vez que haya visto el hechizo durante el juego. 

Para ver la textura correcta ahora, cambie el primer hechizo a comprobar a una ID de hechizo. Puede hacer esto fácilmente pinchando en la entrada en el cuadro de edición y haciendo click derecho en la entrada correspondiente correcta en la lista de sugerencias. ]=]
L["ICON"] = "Icono"
L["ICON_TOOLTIP2NEW"] = [=[|cff7fffffClick-Derecho|r para opciones del icono.
|cff7fffffClick-Derecho y arrastrar|r a otro icono para mover/copiar.
|cff7fffffArrastrar|r hechizos y objetos al icono para configuración rápida.]=]
L["ICON_TOOLTIP2NEWSHORT"] = "|cff7fffffClick-derecho|r para opciones del icono. "
L["ICONALPHAPANEL_FAKEHIDDEN"] = "Ocultar Siempre"
L["ICONALPHAPANEL_FAKEHIDDEN_DESC"] = [=[Obliga al icono a estar continuamente oculto permitiendo funcionalidad normal:

|cff7fffff-|r Condiciones de otros iconos aún pueden comprobar este icono
|cff7fffff-|r Los Meta iconos pueden mostrar este icono
|cff7fffff-|r Los eventos de este icono serán procesados]=]
L["ICONCONDITIONS_DESC"] = "Configura condiciones que le permiten ajustes finos sobre cuándo se muestra este icono. "
L["ICONGROUP"] = "Icono: %s (Grupo: %s)"
L["ICONMENU_ABSENT"] = "Ausente"
L["ICONMENU_ABSENTONANY"] = "Ausente en Cualquier Unidad"
L["ICONMENU_ABSENTONANY_DESC"] = "Establece el nivel de opacidad al que el icono debería mostrarse cuando cualquier unidad siendo comprobada carezca de todas las ventajas/desventajas siendo comprobadas. "
L["ICONMENU_ADDMETA"] = "Añadir a Meta Icono"
L["ICONMENU_ALLOWGCD"] = "Permitir Tiempo de Reutilización Global"
L["ICONMENU_ALLOWGCD_DESC"] = "Marque esta opción para permitir al temporizador reaccionar a y mostrar el tiempo de reutilización global en vez de simplemente ignorarlo. "
L["ICONMENU_ANCHORTO"] = "Anclar a %s"
L["ICONMENU_ANCHORTO_DESC"] = [=[Ancla %s a %s, de modo que cuando %s se mueva, %s se moverá con ello. 

En las opciones de grupo tiene disponibles ajustes avanzados de anclajes. ]=]
L["ICONMENU_ANCHORTO_UIPARENT"] = "Restablecer anclaje"
L["ICONMENU_ANCHORTO_UIPARENT_DESC"] = [=[Restablecer anclaje de %s de vuelta a su pantalla (UIParent). Está actualmente anclado a %s.

En las opciones de grupo tiene disponibles ajustes avanzados de anclajes. ]=]
L["ICONMENU_APPENDCONDT"] = "Añadir como condición \"Icono Mostrado\""
L["ICONMENU_BAROFFS"] = [=[Esta cantidad se añadirá a la barra con el fin de compensarla. 

Útil para indicadores personalizados de cuándo debería comenzar a lanzar un hechizo para evitar que termine una ventaja, o para indicar el poder requerido para lanzar un hechizo y aún tener suficiente para una interrupción. ]=]
L["ICONMENU_BOTH"] = "Cualquiera"
L["ICONMENU_BUFF"] = "Ventaja"
L["ICONMENU_BUFFCHECK"] = "Comprobación de Ventaja/Desventaja"
L["ICONMENU_BUFFCHECK_DESC"] = [=[Comprueba si una ventaja está ausente de cualquier unidad que esté comprobando. 

Use este tipo de icono para comprobar ventajas de raid faltantes. 

Casi todas las demás situaciones deberían usar el tipo de icono %q.]=]
L["ICONMENU_BUFFDEBUFF"] = "Ventaja/Desventaja"
L["ICONMENU_BUFFDEBUFF_DESC"] = "Sigue ventajas y/o desventajas"
L["ICONMENU_BUFFTYPE"] = "Ventaja o Desventaja"
L["ICONMENU_CAST"] = "Lanzamiento de Hechizo"
L["ICONMENU_CAST_DESC"] = "Controla lanzamientos y canalizaciones de hechizos."
L["ICONMENU_CHECKNEXT"] = "Expandir sub-metas"
L["ICONMENU_CHECKNEXT_DESC"] = [=[Marcar esta casilla provocará que este icono expanda todos los iconos en cualquier meta icono que pueda estar comprobando en cualquier nivel en vez de sólo comprobar sub-meta iconos como si fueran cualquier otro icono normal. 

Adicionalmente, este icono no mostrará ningún icono que ya haya sido mostrado por otro meta icono que se actualice antes que éste.]=]
L["ICONMENU_CHECKREFRESH"] = "Atender a refrescos"
L["ICONMENU_CHECKREFRESH_DESC"] = [=[El registro de combate de Blizzard es muy imperfecto por lo que se refiere a refrescos de hechizo y miedo (u otros hechizos que se rompen tras cierta cantidad de daño). El registro de combate dirá que el hechizo se refrescó cuando el daño es aplicado, incluso si técnicamente no fue así. Desmarque esta casilla para deshabilitar la escucha de refrescos de hechizo, pero tenga en cuenta que los refrescos legítimos serán ignorados también. 

Se recomienda dejarlo marcado si los rendimientos decrecientes que está buscando no se rompen tras cierta cantidad de daño. ]=]
L["ICONMENU_CHOOSENAME_ITEMSLOT_DESC"] = [=[Introduzca el Nombre, ID, o ranura de equipamiento que quiere que compruebe este icono. Puede añadir múltiples entradas (cualquier combinación de nombres, IDs y ranuras de equipamiento) separándolas con punto y coma (;). 

Las ranuras de equipamiento son índices numéricos que corresponden con un objeto equipado. Si cambia el objeto equipado en esa ranura, el icono reflejará esto. 

Pulse |cff7fffffMayus-click|r en objetos y enlaces de chat o arrastre objetos para insertarlos en este cuadro de edición. ]=]
L["ICONMENU_CHOOSENAME_ORBLANK"] = "|cff7fffffO|r deje en blanco para comprobarlo todo"
L["ICONMENU_CHOOSENAME_WPNENCH_DESC"] = [=[Introduzca los nombres de los encantamientos de arma que quiere que vigile este icono. Puede añadir múltiples entradas separándolas con punto y coma (;).

|cFFFF5959IMPORTANTE|r: Los nombres de encantamientos deben introducirse exactamente como aparecen en el tooltip del arma mientras el encantamiento está activo (p.ej "%s", no "%s")]=]
L["ICONMENU_CHOSEICONTOEDIT"] = "Elija un icono a editar:"
L["ICONMENU_CLEU"] = "Evento de Combate"
L["ICONMENU_CLEU_DESC"] = [=[Sigue eventos de combate. 

Ejemplos incluyen reflejos de hechizo, fallos, lanzamientos instantáneos y muertes, pero el icono puede seguir virtualmente cualquier cosa. ]=]
L["ICONMENU_CLEU_NOREFRESH"] = "No Refrescar"
L["ICONMENU_CLEU_NOREFRESH_DESC"] = "Marque para hacer que el icono ignore los eventos que sucedan mientras el temporizador del icono está activo. "
L["ICONMENU_CNDTIC"] = "Icono de Condición"
L["ICONMENU_CNDTIC_DESC"] = "Sigue el estado de condiciones. "
L["ICONMENU_CNDTIC_ICONMENUTOOLTIP"] = "(%d |4Condición:Condiciones;)"
L["ICONMENU_COMPONENTICONS"] = "Iconos y Grupos Componentes"
L["ICONMENU_COOLDOWNCHECK"] = "Comprobación de tiempo de reutilización"
L["ICONMENU_COOLDOWNCHECK_DESC"] = "Marque esto para hacer que el icono se considere inusable si está en tiempo de reutilización"
L["ICONMENU_COPYHERE"] = "Copiar aquí"
L["ICONMENU_COUNTING"] = "Temporizador corriendo"
L["ICONMENU_CUSTOMTEX"] = "Textura Personalizada"
L["ICONMENU_CUSTOMTEX_DESC"] = [=[Si quiere sobrescribir la textura mostrada por este icono, introduzca el Nombre o ID del hechizo que tiene la textura que quiere usar. 

También puede introducir una ruta de textura, como 'Interface/Icons/spell_nature_healingtouch', o simplemente 'spell_nature_healingtouch' si la ruta es 'Interface/Icons'

Puede ver una lista de texturas dinámicas escribiendo "$" (símbolo de dólar, ALT.-36) en esta casilla.

Puede usar sus propias texturas también mientras estén situadas en el directorio de WoW (establezca este campo a la ruta de la textura relativa a la carpeta raíz de WoW), sean formato .tga o .blp, y tengan dimensiones que sean potencias de 2 (32, 64, 128, etc)]=]
L["ICONMENU_CUSTOMTEX_MOPAPPEND_DESC"] = "Si esta textura se muestra como verde sólido, y su textura personalizada está en la carpeta raíz de WoW, por favor muévala a un subdirectorio de la raíz de WoW y actualice el ajuste aquí adecuadamente para que funcione correctamente. Si la textura personalizada está asignada a un hechizo, y es un nombre de hechizo o un hechizo que ya no existe, debería intender cambiarla al ID de hechizo de un hechizo que exista. "
L["ICONMENU_DEBUFF"] = "Desventaja"
L["ICONMENU_DISPEL"] = "Tipo de Disipación"
L["ICONMENU_DONTREFRESH"] = "No Refrescar"
L["ICONMENU_DONTREFRESH_DESC"] = "Marque para forzar que el tiempo de reutilización no se restablezca si la activación sucede mientras aún está en cuenta atrás. "
L["ICONMENU_DR"] = "Rendimiento Decreciente"
L["ICONMENU_DR_DESC"] = "Sigue la duración y extensión del rendimiento decreciente. "
L["ICONMENU_DRABSENT"] = "No afectado por Rendimiento Decreciente"
L["ICONMENU_DRPRESENT"] = "Afectado por Rendimiento Decreciente"
L["ICONMENU_DRS"] = "Rendimientos Decrecientes"
L["ICONMENU_DURATION_MAX_DESC"] = "Duración máxima permitida para mostrar el icono, en segundos"
L["ICONMENU_DURATION_MIN_DESC"] = "Duración mínima requerida para mostrar el icono, en segundos"
L["ICONMENU_ENABLE"] = "Habilitado"
L["ICONMENU_ENABLE_DESC"] = "Los iconos sólo funcionarán cuando estén habilitados. "
L["ICONMENU_FAIL2"] = "No se cumplen las condiciones"
L["ICONMENU_FAKEMAX"] = "Máximo artificial"
L["ICONMENU_FAKEMAX_DESC"] = [=[Establece un valor máximo artificial para el temporizador. 

Puede usar este ajuste para hacer que un grupo de iconos al completo decaiga al mismo ratio, lo que puede proporcional una indicación visual de qué temporizadores terminarán primero. 

Establezca esto a 0 para deshabilitar este ajuste. ]=]
L["ICONMENU_FOCUS"] = "Foco"
L["ICONMENU_FOCUSTARGET"] = "Objetivo del foco"
L["ICONMENU_FRIEND"] = "Unidades Amigas"
L["ICONMENU_HIDENOUNITS"] = "Ocultar si no hay unidades"
L["ICONMENU_HIDENOUNITS_DESC"] = "Marque esto para hacer que el icono se oculte si todas las unidades que este icono está comprobando han sido invalidadas por condiciones de unidad y/o por no existir las unidades."
L["ICONMENU_HIDEUNEQUIPPED"] = "Ocultar cuando la ranura carezca de arma"
L["ICONMENU_HIDEUNEQUIPPED_DESC"] = "Marque esto para forzar al icono a ocultarse si la ranura de arma siendo comprobada no tiene un arma en ella, o si esa ranura tiene un escudo o un adorno de mano izquierda. "
L["ICONMENU_HOSTILE"] = "Unidades Hostiles"
L["ICONMENU_ICD"] = "Tiempo de Reutilización Interno"
L["ICONMENU_ICD_DESC"] = [=[Sigue el tiempo de reutilización de un proc o un efecto similar. 

|cFFFF5959IMPORTANTE|r: Vea los tooltips bajo las configuraciones %q para saber cómo seguir cada tipo de tiempo de reutilización interno.]=]
L["ICONMENU_ICDAURA_DESC"] = [=[Seleccione esta opción si el tiempo de reutilización interno comienza cuando: 

|cff7fffff1)|r Una ventaja o desventaja es aplicada por usted mismo (incluye procs), ó
|cff7fffff2)|r Se causa daño, ó 
|cff7fffff3)|r Usted es energizado con mana/ira/etc.
|cff7fffff4)|r Usted invoca o crea un objeto o PNJ. 

Debe introducir, en la caja de edición %q, el nombre de hechizo/ID de: 

|cff7fffff1)|r La ventaja/desventaja que usted gana cuando el tiempo de reutilización interno es activado, ó
|cff7fffff2)|r El hechizo que hace daño (compruebe su registro de combate), ó
|cff7fffff3)|r El efecto energizador (compruebe su registro de combate), ó
|cff7fffff3)|r El hechizo que activó la invocación (compruebe su registro de combate).]=]
L["ICONMENU_ICDBDE"] = "Ventaja/Desventaja/Daño/Energización/Invocación"
L["ICONMENU_ICDTYPE"] = "Tiempo de reutilización comienza en..."
L["ICONMENU_IGNORENOMANA"] = "Ignorar falta de poder"
L["ICONMENU_IGNORENOMANA_DESC"] = "Marque esto para hacer que la habilidad no sea tratada como inutilizable si únicamente falta poder para usarla. "
L["ICONMENU_IGNORERUNES"] = "Ignorar Runas"
L["ICONMENU_IGNORERUNES_DESC"] = "Marque esto para tratar el tiempo de reutilización como usable si la única cosa impidiéndolo es un tiempo de reutilización de runa (o un tiempo de reutilización global)"
L["ICONMENU_IGNORERUNES_DESC_DISABLED"] = "Debe habilidad el ajuste \"Comprobación de Tiempo de Reutilización\" para habilitar el ajuste \"Ignorar Runas\"."
L["ICONMENU_INVERTBARDISPLAYBAR_DESC"] = "Marque esta opción para hacer que la barra se llene hasta cubrir la totalidad de su ancho cuando la duración llegue a cero. "
L["ICONMENU_INVERTBARS"] = "Rellenar barra"
L["ICONMENU_INVERTCBAR_DESC"] = "Marque esta opción para hacer que la barra superpuesta se llene hasta cubrir la anchura completa del icono conforme la duración alcanza cero. "
L["ICONMENU_INVERTPBAR_DESC"] = "Marque esta opción para hacer que la barra superpuesta se llene hasta cubrir la anchura completa del icono conforme el poder llega a ser suficiente. "
L["ICONMENU_ISPLAYER"] = "Unidad Es Jugador"
L["ICONMENU_ITEMCOOLDOWN"] = "Tiempo de reutilización de Objeto"
L["ICONMENU_ITEMCOOLDOWN_DESC"] = "Sigue los tiempos de reutilización de objetos con efectos de Uso."
L["ICONMENU_LIGHTWELL_DESC"] = "Sigue la duración y cargas de su %s"
L["ICONMENU_MANACHECK"] = "Comprobación de poder"
L["ICONMENU_MANACHECK_DESC"] = "Marque esto para permitir cambiar el color del icono cuando usted esté sin mana/ira/poder rúnico/etc."
L["ICONMENU_META"] = "Meta Icono"
L["ICONMENU_META_DESC"] = [=[Combina múltiples iconos en uno.

Los iconos que tengan %q marcado aún se mostrarán en un meta icono si fuesen a ser mostrados por otro motivo.]=]
L["ICONMENU_META_ICONMENUTOOLTIP"] = "(%d |4Icono:Iconos;)"
L["ICONMENU_MOUSEOVER"] = "Bajo el ratón"
L["ICONMENU_MOUSEOVERTARGET"] = "Objetivo de unidad bajo el ratón"
L["ICONMENU_MOVEHERE"] = "Mover aquí"
L["ICONMENU_NOTCOUNTING"] = "Temporizador no corriendo"
L["ICONMENU_NOTREADY"] = "No Está Listo"
L["ICONMENU_OFFS"] = "Desplazamiento"
L["ICONMENU_ONFAIL"] = "Al Incumplir"
L["ICONMENU_ONLYBAGS"] = "Sólo si en bolsas"
L["ICONMENU_ONLYBAGS_DESC"] = "Marque esto para hacer que el icono se muestre sólo si el objeto está en sus bolsas (o equipado). Si \"Sólo si equipado\" está activado, esta opción se activa forzosamente. "
L["ICONMENU_ONLYEQPPD"] = "Sólo si equipado"
L["ICONMENU_ONLYEQPPD_DESC"] = "Marque esto para hacer que el icono se muestre sólo si el objeto está equipado."
L["ICONMENU_ONLYIFCOUNTING"] = "Sólo mostrar si el temporizador está activo"
L["ICONMENU_ONLYIFCOUNTING_DESC"] = "Marque esto para hacer que el icono se muestre sólo si hay actualmente un temporizador activo corriendo en el icono con una duración mayor que 0."
L["ICONMENU_ONLYIFNOTCOUNTING"] = "Sólo mostrar si el temporizador no está activo"
L["ICONMENU_ONLYIFNOTCOUNTING_DESC"] = "Marque esto para hacer que el icono se muestre sólo si no NO hay un temporizador activo corriendo en el icono con una duración mayor que 0."
L["ICONMENU_ONLYINTERRUPTIBLE"] = "Sólo Interrumpible"
L["ICONMENU_ONLYINTERRUPTIBLE_DESC"] = "Marque esta casilla para mostrar sólo lanzamientos de hechizos que son interrumpibles"
L["ICONMENU_ONLYMINE"] = "Sólo comprobar los míos"
L["ICONMENU_ONLYMINE_DESC"] = "Marque esta opción para hacer que este icono sólo compruebe ventajas/desventajas que usted lanzó"
L["ICONMENU_ONLYSEEN"] = "Sólo si visto"
L["ICONMENU_ONLYSEEN_DESC"] = "Marque esto para hacer que el icono sólo muestre un tiempo de reutilización si la unidad lo ha lanzado al menos una vez. Debería marcar esto si está comprobando hechizos de diferentes clases en un solo icono. "
L["ICONMENU_ONSUCCEED"] = "Al Cumplir"
L["ICONMENU_OOPOWER"] = "Fuera de Poder"
L["ICONMENU_OORANGE"] = "Fuera de Rango"
L["ICONMENU_PETTARGET"] = "Objetivo de la mascota"
L["ICONMENU_PRESENT"] = "Presente"
L["ICONMENU_PRESENTONALL"] = "Presente en Todas las Unidades"
L["ICONMENU_PRESENTONALL_DESC"] = "Establece el nivel de opacidad al que el icono debería mostrarse cuando todas las unidades siendo comprobadas tengan al menos una de las ventajas/desventajas siendo comprobadas. "
L["ICONMENU_RANGECHECK"] = "Comprobación de alcance"
L["ICONMENU_RANGECHECK_DESC"] = "Marque esto para permitir cambiar el color del icono cuando usted esté fuera de alcance. "
L["ICONMENU_REACT"] = "Reacción de Unidad"
L["ICONMENU_REACTIVE"] = "Habilidad Reactiva"
L["ICONMENU_REACTIVE_DESC"] = [=[Sigue la usabilidad de habilidades reactivas. 

Habilidades reactivas son cosas como %s, %s y %s - habilidades que sólo se pueden usar cuando se cumplen ciertas condiciones. ]=]
L["ICONMENU_READY"] = "Listo"
L["ICONMENU_RUNES"] = "Tiempo de Reutilización de Runa"
L["ICONMENU_RUNES_CHARGES"] = "Runas inutilizables como cargas"
L["ICONMENU_RUNES_CHARGES_DESC"] = "Active este ajusta para hacer que el icono trate cualquier runa que está en tiempo de reutilización como una carga extra (mostrado en el deslizador de tiempo de reutilización) cuando el icono esté mostrando una runa utilizable. "
L["ICONMENU_RUNES_DESC"] = "Sigue tiempos de reutilización de runas"
L["ICONMENU_SHOWCBAR_DESC"] = "Muestra una barra que se superpone sobre la mitad inferior del icono que indicará el tiempo de reutilización/duración restante (o el tiempo transcurrido si \"Llenar barras\" está marcado)"
L["ICONMENU_SHOWPBAR_DESC"] = "Muestra una barra que se superpone sobre la mitad superior del icono que indicará el poder faltante para lanzar el hechizo (o el poder que ya tienes cuando \"Llenar barras\" está marcado)"
L["ICONMENU_SHOWSTACKS"] = "Mostrar montones. "
L["ICONMENU_SHOWSTACKS_DESC"] = "Marque esto para mostrar el número de montones del objeto que tiene. "
L["ICONMENU_SHOWTIMER"] = "Mostrar reloj"
L["ICONMENU_SHOWTIMER_DESC"] = "Marque esta opción para mostrar la animación estándar de barrido de tiempo de reutilización en el icono. "
L["ICONMENU_SHOWTIMERTEXT"] = "Mostrar texto de temporizador"
L["ICONMENU_SHOWTIMERTEXT_DESC"] = [=[Marque esta opción para que se muestre en texto la duración/tiempo de reutilización restante en el icono. 

Esto sólo es aplicable si OmniCC (o similar) está instalado. ]=]
L["ICONMENU_SHOWTIMERTEXT_NOOCC"] = "Mostrar texto de temporizador ElvUI"
L["ICONMENU_SHOWTIMERTEXT_NOOCC_DESC"] = [=[Marque esta opción para mostrar el display de texto de ElvUI del tiempo restante de duración/tiempo de reutilización del icono. 

Este ajuste sólo afecta al temporizador de ElvUI. Si tiene otro addon que provea temporizadores (como OmniCC), puede controlar esos temporizadores con el ajuste %q. No se recomienda tener ambos ajustes activados al tiempo. ]=]
L["ICONMENU_SHOWWHEN"] = "Mostrar Estados y Opacidad"
L["ICONMENU_SHOWWHEN_OPACITY_GENERIC_DESC"] = "Establece el nivel de opacidad que debería mostrar el icono en este estado de icono. "
L["ICONMENU_SHOWWHEN_OPACITYWHEN_WRAP"] = "Opacidad cuando %s|r"
L["ICONMENU_SHOWWHENNONE"] = "Mostrar si no hay resultado"
L["ICONMENU_SHOWWHENNONE_DESC"] = "Marque esto para permitir que el icono se muestre como No Afectado por Rendimiento Decreciente cuando no se detectan rendimientos decrecientes en ninguna unidad. "
L["ICONMENU_SORTASC"] = "Duración baja"
L["ICONMENU_SORTASC_DESC"] = "Marque esta casilla para priorizar y mostrar hechizos con la menor duración."
L["ICONMENU_SORTASC_META_DESC"] = "Marque esta casilla para priorizar y mostrar iconos con la duración más baja. "
L["ICONMENU_SORTDESC"] = "Duración alta"
L["ICONMENU_SORTDESC_DESC"] = "Marque esta casilla para priorizar y mostrar hechizos con la mayor duración."
L["ICONMENU_SORTDESC_META_DESC"] = "Marque esta casilla para priorizar y mostrar iconos con la duración más alta."
L["ICONMENU_SPELLCAST_COMPLETE"] = "Lanzamiento de Hechizo Completo/Lanzamiento Instantáneo"
L["ICONMENU_SPELLCAST_COMPLETE_DESC"] = [=[Seleccione esta opción si el tiempo de reutilización interno comienza cuando: 

|cff7fffff1)|r Termina de lanzar un hechizo, ó
|cff7fffff2)|r Lanza un hechizo instantáneo.

Debe introducir el nombre/ID del lanzamiento de hechizo que activa el tiempo de reutilización interno en el cuadro de edición %q]=]
L["ICONMENU_SPELLCAST_START"] = "Lanzamiento de Hechizo Comenzado"
L["ICONMENU_SPELLCAST_START_DESC"] = [=[Seleccione esta opción si el tiempo de reutilización interno comienza cuando: 

|cff7fffff1)|r Comienza a lanzar un hechizo.

Debe introducir el nombre/ID del lanzamiento de hechizo que activa el tiempo de reutilización interno en el cuadro de edición %q]=]
L["ICONMENU_SPELLCOOLDOWN"] = "Tiempo de reutilización de Hechizo"
L["ICONMENU_SPELLCOOLDOWN_DESC"] = "Sigue el tiempo de reutilización de hechizos de su libro de hechizos."
L["ICONMENU_SPLIT"] = "Separar a un grupo nuevo"
L["ICONMENU_SPLIT_DESC"] = "Crear un grupo nuevo y mover este icono a él. Muchos ajustes de grupo se mantendrán en el nuevo grupo. "
L["ICONMENU_STACKS_MAX_DESC"] = "Número máximo de acumulaciones permitidas para mostrar el icono"
L["ICONMENU_STACKS_MIN_DESC"] = "Número mínimo de acumulaciones necesarias para mostrar el icono"
L["ICONMENU_STEALABLE"] = "Sólo robable"
L["ICONMENU_STEALABLE_DESC"] = "Marque esto para mostrar sólo ventajas con las que se pueda usar Robar hechizo. Recomendable usar cuando se está comprobando el tipo de disipación \"Magia\""
L["ICONMENU_SUCCEED2"] = "Condiciones Se Cumplen"
L["ICONMENU_SWAPWITH"] = "Intercambiar con"
L["ICONMENU_SWINGTIMER"] = "Temporizador de golpe"
L["ICONMENU_SWINGTIMER_DESC"] = "Sigue los temporizadores de golpe de sus armas de mano principal y de mano izquierda."
L["ICONMENU_SWINGTIMER_NOTSWINGING"] = "No golpeando"
L["ICONMENU_SWINGTIMER_SWINGING"] = "Golpeando"
L["ICONMENU_TARGETTARGET"] = "El objetivo del objetivo"
L["ICONMENU_TOTEM"] = "Tótem"
L["ICONMENU_TOTEM_DESC"] = "Sigue sus tótems"
L["ICONMENU_TYPE"] = "Tipo de icono"
L["ICONMENU_UNIT_DESC"] = [=[Introduce las unidades a vigilar en este cuadro. Las unidades pueden insertarse desde la lista de sugerencias a la derecha. Los usuarios avanzados pueden escribir sus propias unidades. 

Las unidades estándar (p.ej. jugador) y/o los nombres de los jugadores que están en tu grupo (p.ej. %s) pueden ser usados como unidades. 

Separa múltiples unidades con punto y coma (;).

Para más información sobre unidades, consulta http://www.wowpedia.org/UnitId]=]
L["ICONMENU_UNIT_DESC_CONDITIONUNIT"] = [=[Introduzca la unidad a observar en este cuadro. La unidad puede insertarse desde la lista de sugerencias a la derecha, o usuarios avanzados pueden escribir su propia unidad. 


Unidades estándar (p.ej. jugador) y/o los nombres de los jugadores en su grupo (p.ej. %s) pueden ser usadas. 

Para más información sobre unidades, vaya a http://www.wowpedia.org/UnitId]=]
L["ICONMENU_UNIT_DESC_UNITCONDITIONUNIT"] = [=[Introduzca la unidad a observar en este cuadro. La unidad puede insertarse desde la lista de sugerencias a la derecha. 

"unidad" es un alias para cada unidad que el icono está comprobando.]=]
L["ICONMENU_UNITCOOLDOWN"] = "Tiempo de reutilización de Unidad"
L["ICONMENU_UNITCOOLDOWN_DESC"] = [=[Sigue los tiempos de reutilización de otro.

Se puede comprobar %s usando %q como nombre.]=]
L["ICONMENU_UNITS"] = "Unidades"
L["ICONMENU_UNITSTOWATCH"] = "Unidad(es) a vigilar"
L["ICONMENU_UNUSABLE"] = "Inutilizable"
L["ICONMENU_USABLE"] = "Utilizable"
L["ICONMENU_USEACTIVATIONOVERLAY"] = "Comprobar borde de activación"
L["ICONMENU_USEACTIVATIONOVERLAY_DESC"] = "Marque esto para hacer que la presencia del borde amarillo chispeante alrededor de una acción obligue al icono a actuar como utilizable."
L["ICONMENU_VEHICLE"] = "Vehículo"
L["ICONMENU_WPNENCHANT"] = "Encantamiento de Arma"
L["ICONMENU_WPNENCHANT_DESC"] = "Sigue encantamientos de arma temporales. "
L["ICONMENU_WPNENCHANTTYPE"] = "Ranura de arma a controlar"
L["IconModule_CooldownSweepCooldown"] = "Barrido de Tiempo de Reutilización"
L["IconModule_IconContainer_MasqueIconContainer"] = "Contenedor de Iconos"
L["IconModule_IconContainer_MasqueIconContainer_DESC"] = "Contiene las partes principales del icono, como la textura"
L["IconModule_PowerBar_OverlayPowerBar"] = "Barra de Poder Superpuesta"
L["IconModule_SelfIcon"] = "Icono"
L["IconModule_Texture_ColoredTexture"] = "Textura de icono"
L["IconModule_TimerBar_BarDisplayTimerBar"] = "Barra de Temporizador (display de barra)"
L["IconModule_TimerBar_OverlayTimerBar"] = "Barra de Temporizador Superpuesta"
L["ICONTOCHECK"] = "Icono a comprobar"
L["ICONTYPE_DEFAULT_HEADER"] = "Instrucciones"
L["ICONTYPE_DEFAULT_INSTRUCTIONS"] = [=[Para empezar a configurar este icono, seleccione un tipo de icono del menú desplegable %q más arriba.

Asegúrese de también marcar el ajuste %q de modo que este icono funcione. 

Recuerde que los iconos sólo funcionan cuando TellMeWhen está en su estado bloqueado, así que que escriba '/tmw' cuando termine esta configuración. 

Mientras configura TellMeWhen, asegúrese de leer los tooltips para cada ajuste. Estos tooltips a menudo contienen información importante sobre cómo funciona el ajuste!]=]
L["ICONTYPE_SWINGTIMER_TIP"] = [=[Intentando seguir el temporizador de su %s? El tipo de icono %q tiene la funcionalidad que desea. Simplemente establezca un %s para seguir %q (ID de hechizo %d)!

También puede pulsar el botón de abajo para aplicar automáticamente los ajustes adecuados. ]=]
L["ICONTYPE_SWINGTIMER_TIP_APPLYSETTINGS"] = "Aplicar Ajustes %s"
L["ImmuneToMagicCC"] = "Inmune al Control de Masas mágico"
L["ImmuneToStun"] = "Inmune al Aturdimiento"
L["IMPORT_EXPORT"] = "Importar/Exporar/Restaurar"
L["IMPORT_EXPORT_BUTTON_DESC"] = "Pulse este botón para importar y exportar iconos, grupos y perfiles."
L["IMPORT_EXPORT_DESC"] = [=[Pulse el botón a la derecha para importar y exportar iconos, grupos y perfiles. 

Importar a o desde una cadena, o exportar a otro jugador, requerirá el uso de este cuadro de edición. Vea los tooltips en el menú desplegable para más detalles. ]=]
L["IMPORT_FROMBACKUP"] = "Desde Backup"
L["IMPORT_FROMBACKUP_DESC"] = "Los ajustes restaurados desde este menú quedarán como estaban a las: %s"
L["IMPORT_FROMBACKUP_WARNING"] = "AJUSTES DE BACKUP: %s"
L["IMPORT_FROMCOMM"] = "Desde Jugador"
L["IMPORT_FROMCOMM_DESC"] = "Si otro usuario de TellMeWhen le manda datos de configuración, podrá importarlos desde este submenú. "
L["IMPORT_FROMLOCAL"] = "Desde Perfil"
L["IMPORT_FROMSTRING"] = "Desde Cadena"
L["IMPORT_FROMSTRING_DESC"] = [=[Las cadenas le permiten transferir datos de configuración de TellMeWhen fuera del juego. 

Para importar desde una cadena, pulse CTRL+V para pegar la cadena en el cuadro de edición tras copiarla al portapapeles, y entonces navegue de vuelta a este submenú. ]=]
L["IMPORT_HEADING"] = "Importar"
L["IMPORT_ICON_DISABLED_DESC"] = "Debe estar editando un icono para ser capaz de importar un icono. "
L["IMPORT_PROFILE"] = "Copiar Perfil"
L["IMPORT_PROFILE_NEW"] = "|cff59ff59Crear|r Nuevo Perfil"
L["IMPORT_PROFILE_OVERWRITE"] = "|cFFFF5959Sobreescribir|r %s"
L["IMPORT_SUCCESSFUL"] = "Importado con éxito!"
L["IMPORTERROR_FAILEDPARSE"] = "Hubo un error procesando la cadena. Asegúrese de que ha copiado la cadena entera desde la fuente. "
L["IMPORTERROR_INVALIDTYPE"] = "Intentó importar datos de un tipo desconocido. Compruebe si tiene la última versión de TellMeWhen instalada. "
L["Incapacitated"] = "Incapacitado"
L["INCHEALS"] = "Sanaciones entrantes de la unidad"
L["INCHEALS_DESC"] = [=[Comprueba la cantidad total de sanación que está entrando a la unidad (tanto sanaciones en el tiempo como lanzamientos en marcha)

Sólo funciona para unidades amigas. Las unidades hostiles informarán siempre que tienen 0 sanaciones entrantes. ]=]
L["INRANGE"] = "Al alcance"
L["ITEMCOOLDOWN"] = "Tiempo de reutilización de objeto"
L["ITEMEQUIPPED"] = "Objeto está equipado"
L["ITEMINBAGS"] = "Cuenta de objetos (incluye cargas)"
L["ITEMTOCHECK"] = "Objeto a Comprobar"
L["ITEMTOCOMP1"] = "Primer Objeto a Comparar"
L["ITEMTOCOMP2"] = "Segundo Objeto a Comparar"
L["LAYOUTDIRECTION"] = "Dirección de Disposición"
L["LDB_TOOLTIP1"] = "|cff7fffffClick-Izquierdo|r para activar/desactivar los bloqueos de grupo"
L["LDB_TOOLTIP2"] = "|cff7fffffClick-Derecho|r para mostrar las opciones principales de TMW"
L["LEFT"] = "Izquierda"
L["LOADERROR"] = "No se pudo cargar TellMeWhen_Options:"
L["LOADINGOPT"] = "Cargando TellMeWhen_Options."
L["LOCKED"] = "Bloqueado"
L["LOSECONTROL_CONTROLLOST"] = "Pérdida de control"
L["LOSECONTROL_DROPDOWNLABEL"] = "Tipos de pérdida de control"
L["LOSECONTROL_DROPDOWNLABEL_DESC"] = "Elija los tipos de pérdida de control a los que desea que este icono reaccione. "
L["LOSECONTROL_ICONTYPE"] = "Pérdida de Control"
L["LOSECONTROL_ICONTYPE_DESC"] = "Controla efectos que causan la pérdida de control de su personaje. "
L["LOSECONTROL_INCONTROL"] = "Controlando"
L["LOSECONTROL_TYPE_ALL"] = "Todos los tipos"
L["LOSECONTROL_TYPE_ALL_DESC"] = "Hace que el icono muestre información sobre todos los tipos de efectos"
L["LOSECONTROL_TYPE_DESC_USEUNKNOWN"] = "NOTA: No se sabe si este tipo de pérdida de control se está usando o no. "
L["LOSECONTROL_TYPE_MAGICAL_IMMUNITY"] = "Inmunidad mágica"
L["LOSECONTROL_TYPE_SCHOOLLOCK"] = "Escuela de hechizo bloqueada"
L["LUACONDITION"] = "Lua (Avanzado)"
L["LUACONDITION_DESC"] = [=[Este tipo de condición permite evaluar código Lua para determinar el estado de una condición. 

La entrada no es una sentencia "if .. then", ni es un cierre de función. Es una sentencia normal que será evaluada, p.ej. "a y b o c". Si se requiere una funcionalidad compleja, use una llamada a función, p.ej. 'CompruebaCosas()', que se defina externamente. 

Si se requiere más ayuda (que no sea sobre cómo escribir código Lua), abra un ticket en CurseForge. Para ayuda sobre cómo escribir Lua, vaya a Internet. ]=]
L["MACROCONDITION"] = "Condición de Macro"
L["MACROCONDITION_DESC"] = [=[Esta condición evaluará una condición de macro, y será cumplirá si ésta se cumple. Todas las condiciones de macro pueden ser prefijadas con "no" para invertir lo que comprueban. 

Ejemplos: 
    "[nomodifier:alt]" - no se está manteniendo pulsando la tecla Alt
    "[@target, help][mod:ctrl]" - el objetivo es amistoso O se está manteniendo pulsado Ctrl
    "[@focus, harm, nomod:shift]" - el foco es hostil Y no se está manteniendo pulsado Shift

Para más ayuda, vaya a http://www.wowpedia.org/Making_a_macro]=]
L["MACROCONDITION_EB_DESC"] = "Si se usa una condición simple, las llaves de apertura y cierre son opcionales. Las llaves son necesarias si se están usando condicionales múltiples. "
L["MACROTOEVAL"] = "Condicional(es) de Macro a Evaluar"
L["Magic"] = "Magia"
L["MAIN"] = "Principal"
L["MAIN_DESC"] = "Contiene las opciones principales para este icono. "
L["MAINASSIST"] = "Asistente Principal"
L["MAINTANK"] = "Tanque Principal"
L["MESSAGERECIEVE"] = "%s te ha mandado datos de TellMeWhen! Puedes importar estos datos en TellMeWhen usando el botón %q, ubicado en la parte baja del editor de iconos. "
L["MESSAGERECIEVE_SHORT"] = "%s te ha mandado datos de TellMeWhen!"
L["META_ADDICON"] = "Añadir Icono"
L["META_ADDICON_DESC"] = "Pulse para añadir otro icono a incluir en este meta icono. "
L["META_GROUP_INVALID_VIEW_DIFFERENT"] = [=[Los iconos de este grupo no pueden ser comprobados por este meta icono porque usan métodos de visualización diferentes. 

Este grupo: %s
Grupo objetivo: %s]=]
L["METAPANEL_DOWN"] = "Mover abajo"
L["METAPANEL_REMOVE"] = "Eliminar icono"
L["METAPANEL_REMOVE_DESC"] = "Click para eliminar este icono de la lista que el metaicono comprobará. "
L["METAPANEL_UP"] = "Mover arriba"
L["MISCELLANEOUS"] = "Varios"
L["MiscHelpfulBuffs"] = "Ventajas Útiles Varias "
L["MOON"] = "Luna"
L["MOUSEOVER_TOKEN_NOT_FOUND"] = "<Nada bajo el ratón>"
L["MOUSEOVERCONDITION"] = "Ratón está Encima"
L["MOUSEOVERCONDITION_DESC"] = "Esta condición comprueba si su ratón está sobre el icono o grupo al que está adjunta la condición. "
L["MP5"] = "%d MP5"
L["MUSHROOM"] = "Champiñón %d"
L["NEWVERSION"] = "Hay una nueva versión de TellMeWhen disponible: %s"
L["NONE"] = "Ninguno de estos"
L["normal"] = "Normal"
L["NOTINRANGE"] = "Fuera de alcance"
L["NOTYPE"] = "<Sin Tipo de Icono>"
L["NUMAURAS"] = "Número de"
L["NUMAURAS_DESC"] = "Esta condición comprueba el número de un aura activa - no confundir con el número de acumulaciones de un aura. Esto es para comprobar cosas como si tienes ambos procs de los encantamientos de arma activos al mismo tiempo. Usar moderadamente, ya que el proceso usado para contar los números consume bastante CPU."
L["ONLYCHECKMINE"] = "Sólo Comprobar Míos"
L["ONLYCHECKMINE_DESC"] = "Marque esto para que esta condición sólo compruebe las ventajas/desventajas que usted lanzó"
L["OUTLINE_MONOCHORME"] = "Monocromo"
L["OUTLINE_NO"] = "Sin Contorno"
L["OUTLINE_THICK"] = "Contorno Grueso"
L["OUTLINE_THIN"] = "Contorno Fino"
L["PARENTHESIS_TYPE_("] = "de apertura"
L["PARENTHESIS_TYPE_)"] = "de cierre"
L["PARENTHESIS_WARNING1"] = [=[El número de paréntesis de apertura y cierre no encaja!

Se necesitan %d paréntesis %s más.]=]
L["PARENTHESIS_WARNING2"] = [=[Algunos paréntesis de cierre carecen de apertura!

Hacen falta %d más paréntesis de apertura. ]=]
L["PERCENTAGE"] = "Porcentaje"
L["PET_TYPE_CUNNING"] = "Astucia"
L["PET_TYPE_FEROCITY"] = "Ferocidad"
L["PET_TYPE_TENACITY"] = "Tenacidad"
L["PLAYER_DESC"] = "(Usted)"
L["Poison"] = "Veneno"
L["PROFILE_LOADED"] = "Perfil cargado: %s"
L["PvPSpells"] = "Control de Masas JcJ, etc."
L["QUESTIDTOCHECK"] = "ID de misión a Comprobar"
L["RAID_WARNING_FAKE"] = "Alerta de Banda (Falsa)"
L["RAID_WARNING_FAKE_DESC"] = "Saca un mensaje como una alerta de banda, pero nadie más lo verá, y no tiene que estar en una banda o tener privilegios de alerta de banda"
L["RaidWarningFrame"] = "Marco de Advertencia de Banda"
L["rare"] = "Raro"
L["rareelite"] = "Élite Raro"
L["REACTIVECNDT_DESC"] = "Esta condición sólo comprueba el estado reactivo de la habilidad, no el tiempo de reutilización de la misma. "
L["REDO"] = "Rehacer"
L["ReducedHealing"] = "Sanación Reducida"
L["REQFAILED_ALPHA"] = "Opacidad cuando no se cumpla"
L["RESET_ICON"] = "Restablecer"
L["RESIZE"] = "Cambiar tamaño"
L["RESIZE_TOOLTIP"] = "|cff7fffffPinchar y arrastrar|r para cambiar el tamaño"
L["RESIZE_TOOLTIP_SCALEXY"] = [=[|cff7fffffClick-y-arrastrar|r para cambiar el tamaño
|cff7fffffMantener pulsado Control|r para invertir el eje de escala]=]
L["RESIZE_TOOLTIP_SCALEY_SIZEX"] = "|cff7fffffClick-y-arrastrar|r para cambiar el tamaño"
L["RIGHT"] = "Derecha"
L["Rooted"] = "Inmovilizado"
L["RUNEOFPOWER"] = "Runa %d"
L["RUNES"] = "Runa(s) a comprobar"
L["RUNSPEED"] = "Velocidad de Carrera de la Unidad"
L["SAFESETUP_COMPLETE"] = "Instalación lenta y segura completada. "
L["SAFESETUP_FAILED"] = "Instalación lenta y segura FALLADA: %s"
L["SAFESETUP_TRIGGERED"] = "Ejecutando instalación lenta y segura..."
L["SEAL"] = "Sello"
L["SENDSUCCESSFUL"] = "Enviado con éxito"
L["SHAPESHIFT"] = "Cambio de forma"
L["Shatterable"] = "Destrozable"
L["Silenced"] = "Silenciado"
L["Slowed"] = "Ralentizado"
L["SORTBY"] = "Priorizar"
L["SORTBYNONE"] = "Normalmente"
L["SORTBYNONE_DESC"] = "Si esta marcado, los hechizos serán comprobados y aparecerán en el orden en que fueron introducidos en el cuadro de edición \"%s\". Si este icono es un icono de ventaja/desventaja y el número de auras siendo comprobadas excede el ajuste de umbral de eficiencia, las auras serán comprobadas en el orden en que normalmente aparecerían en la marco de unidad de la unidad."
L["SORTBYNONE_META_DESC"] = "Si está marcado, los iconos serán comprobados en el orden que se configuró más arriba. "
L["SOUND_CHANNEL"] = "Canal de Sonido"
L["SOUND_CHANNEL_DESC"] = [=[Elija el canal de sonido y ajuste de volumen que desearía usar para reproducir sonidos. 

Seleccionar %q permitirá que se reproduzcan sonidos incluso cuando los sonidos están apagados. ]=]
L["SOUND_CHANNEL_MASTER"] = "Maestro"
L["SOUND_CUSTOM"] = "Fichero de sonido personalizado"
L["SOUND_CUSTOM_DESC"] = [=[Inserte la ruta a un sonido personalizado a reproducir. Aquí hay algunos ejemplos, donde "fichero" es en el nombre de su sonido, y "ext" es la extensión del fichero (sólo ogg o mp3!):

- "CustomSounds\fichero.ext": Un fichero situado en una nueva carpeta llamada "CustomSounds" en el directorio raíz de WoW (la misma ubicación que Wow.exe, las carpetas Interface y WTF, etc)

- "Interface\AddOns\fichero.ext": Un fichero suelto en la carpeta AddOns

- "Fichero.ext": un fichero suelto en el directorio raíz de WoW

NOTA: Se debe reiniciar WoW para que reconozca ficheros que no existían cuando fue iniciado. ]=]
L["SOUND_EVENT_DISABLEDFORTYPE"] = "No disponible"
L["SOUND_EVENT_DISABLEDFORTYPE_DESC2"] = [=[Este evento no está disponible para la configuración actual del icono.

Esto es probablemente debido a que este evento no esté disponible para el tipo de icono actual (%s).

cff7fffffClick-Derecho|r para cambiar el evento.]=]
L["SOUND_EVENT_ONALPHADEC"] = "Al Reducir Alfa"
L["SOUND_EVENT_ONALPHADEC_DESC"] = [=[Este evento se activa cuando la opacidad de un icono se reduce. 

NOTA: Este evento no se activará al reducir hasta 0% Opacidad (Al Ocultarse)]=]
L["SOUND_EVENT_ONALPHAINC"] = "En Incremento Alfa"
L["SOUND_EVENT_ONALPHAINC_DESC"] = [=[Este evento se activa cuando la opacidad de un icono aumenta.

NOTA: Este evento no se activará al aumentar desde 0% Opacidad (Al Mostrar)]=]
L["SOUND_EVENT_ONCLEU"] = "En Evento de Combate"
L["SOUND_EVENT_ONCLEU_DESC"] = "Este evento se activa cuando sucede un evento de combate que debería ser procesado por el icono."
L["SOUND_EVENT_ONCONDITION"] = "Justo al cumplirse el conjunto de condiciones"
L["SOUND_EVENT_ONCONDITION_DESC"] = "Este evento se activa cuando un conjunto de condiciones que puede configurar para este evento se empiezan a cumplir. "
L["SOUND_EVENT_ONDURATION"] = "Al Cambiar Duración"
L["SOUND_EVENT_ONDURATION_DESC"] = [=[Este evento se activa cuando la duración del temporizador del icono cambia. 

Ya que este evento sucede cada vez que se actualiza el icono cuando un temporizador está corriendo, debe establecer una condición, y el evento sólo sucederá cuando el estado de esta condición cambie. ]=]
L["SOUND_EVENT_ONEVENTSRESTORED"] = "Al establecer el icono"
L["SOUND_EVENT_ONEVENTSRESTORED_DESC"] = [=[Este evento se activa inmediatamente después de que se ha establecido el icono. 

Esto sucede principalmente cuando deja el modo de configuración, pero también sucede cuando se entra/sale de una zona, entre varias otras cosas. 

También se puede pensar en esto como en un "reseteo suave" del icono. 

Este evento puede ser útil para crear un estado de animación por defecto para el icono. ]=]
L["SOUND_EVENT_ONFINISH"] = "Al Terminar"
L["SOUND_EVENT_ONFINISH_DESC"] = "Este evento se activa cuando el tiempo de reutilización se vuelve utilizable, la ventaja/desventaja termina, etc."
L["SOUND_EVENT_ONHIDE"] = "Al Ocultar"
L["SOUND_EVENT_ONHIDE_DESC"] = "Este evento se activa cuando el icono es ocultado (incluso si %q está marcado)."
L["SOUND_EVENT_ONLEFTCLICK"] = "En Click Izquierdo"
L["SOUND_EVENT_ONLEFTCLICK_DESC"] = "Este evento se activa cuando hace |cff7fffffClick-Izquierdo|r en el icono mientras los iconos están bloqueados. "
L["SOUND_EVENT_ONRIGHTCLICK"] = "Al hacer Click Derecho"
L["SOUND_EVENT_ONRIGHTCLICK_DESC"] = "Este evento se activa cuando hace |cff7fffffClick-Derecho|r en el icono mientras los iconos están bloqueados. "
L["SOUND_EVENT_ONSHOW"] = "Al Mostrar"
L["SOUND_EVENT_ONSHOW_DESC"] = "Este evento se activa cuando el icono pasa a mostrarse (incluso si %q está marcado)"
L["SOUND_EVENT_ONSPELL"] = "Al Cambiar de Hechizo"
L["SOUND_EVENT_ONSPELL_DESC"] = "Este evento se activa cuando el hechizo/objeto/etc. para el que el icono está mostrando información ha cambiado."
L["SOUND_EVENT_ONSTACK"] = "Al Cambiar Acumulación"
L["SOUND_EVENT_ONSTACK_DESC"] = [=[Este evento se activa cuando cambia la acumulación de lo que sea que el objeto está siguiendo. 

Esto incluye la cantidad de decrecimiento de eficiencia para iconos %s. ]=]
L["SOUND_EVENT_ONSTART"] = "Al Empezar"
L["SOUND_EVENT_ONSTART_DESC"] = "Ese evento se activa cuando el tiempo de reutilización se vuelve inutilizable, se aplica la ventaja/desventaja, etc."
L["SOUND_EVENT_ONUNIT"] = "Al Cambiar Unidad"
L["SOUND_EVENT_ONUNIT_DESC"] = "Este evento se activa cuando la unidad para la que el icono está mostrando información ha cambiado."
L["SOUND_EVENT_WHILECONDITION"] = "Mientras se cumple el conjunto de condiciones"
L["SOUND_SOUNDTOPLAY"] = "Sonido a Reproducir"
L["SOUND_TAB"] = "Sonido"
L["SOUNDERROR1"] = "El fichero debe tener una extensión!"
L["SOUNDERROR2"] = [=[Los ficheros WAV personalizados no están soportados por WoW 4.0+

(Los sonidos integrados en WoW funcionan, sin embargo)]=]
L["SOUNDERROR3"] = "Sólo soporta ficheros OGG y MP3!"
L["SPEED"] = "Velocidad de la Unidad"
L["SPEED_DESC"] = "Esto se refiere a la velocidad de movimiento actual de la unidad. Si la unidad no se está moviendo, es cero. Si desea seguir la velocidad máxima de carrera de la unidad, use la condición \"Velocidad de Carrera de la Unidad\""
L["SPELLCHARGES"] = "Cargas de hechizo"
L["SPELLCHARGES_DESC"] = "Sigue las cargas de un hechizo como %s o %s."
L["SPELLCHARGES_FULLYCHARGED"] = "Completamente cargado"
L["SPELLCHARGETIME"] = "Tiempo de carga de hechizo"
L["SPELLCHARGETIME_DESC"] = "Sigue el tiempo restante hasta que un hechizo como %s o %s regenere una carga. "
L["SPELLCOOLDOWN"] = "Tiempo de reutilización de hechizo"
L["SPELLREACTIVITY"] = "Reactividad del Hechizo"
L["SPELLTOCHECK"] = "Hechizo a Comprobar"
L["SPELLTOCOMP1"] = "Primer Hechizo a Comparar"
L["SPELLTOCOMP2"] = "Segundo Hechizo a Comparar"
L["STACKALPHA_DESC"] = "Establece el nivel de opacidad al que el icono debería mostrarse cuando no se cumplan estos requisitos de acumulación."
L["STACKS"] = "Acumulaciones"
L["STACKSPANEL_TITLE2"] = "Requisitos de Acumulación"
L["STANCE"] = "Actitud"
L["STANCE_DESC"] = [=[Puede introducir múltiples actitudes a comparar separándolas con punto y coma (;).

La condición se cumplirá si cualquier actitud encaja. ]=]
L["STANCE_LABEL"] = "Actitud(es)"
L["STRATA_BACKGROUND"] = "Fondo"
L["STRATA_DIALOG"] = "Diálogo"
L["STRATA_FULLSCREEN"] = "Pantalla completa"
L["STRATA_FULLSCREEN_DIALOG"] = "Diálogo a Pantalla Completa"
L["STRATA_HIGH"] = "Alto"
L["STRATA_LOW"] = "Bajo"
L["STRATA_MEDIUM"] = "Medio"
L["STRATA_TOOLTIP"] = "Tooltip"
L["Stunned"] = "Aturdido"
L["SUG_BUFFEQUIVS"] = "Equivalencias de Ventajas"
L["SUG_CLASSSPELLS"] = "Hechizos de mascota/PJ conocidos"
L["SUG_DEBUFFEQUIVS"] = "Equivalencias de Desventajas"
L["SUG_DISPELTYPES"] = "Tipos de Disipación"
L["SUG_FINISHHIM"] = "Terminar el Almacenado Ahora"
L["SUG_FINISHHIM_DESC"] = "|cff7fffffClick|r para terminar inmediatamente el proceso de almacenamiento/filtrado. Tenga en cuenta que su ordenador podría detenerse durante algunos segundos. "
L["SUG_INSERT_ANY"] = "|cff7fffffClick|r"
L["SUG_INSERT_LEFT"] = "|cff7fffffClick-Izquierdo|r"
L["SUG_INSERT_RIGHT"] = "|cff7fffffClick-Derecho|r"
L["SUG_INSERT_TAB"] = " o |cff7fffffTab|r"
L["SUG_INSERTEQUIV"] = "%s para insertar equivalencia"
L["SUG_INSERTID"] = "%s para insertar como ID"
L["SUG_INSERTITEMSLOT"] = "%s para intertar como ID de ranura de objeto"
L["SUG_INSERTNAME"] = "%s para insertar como nombre"
L["SUG_INSERTTEXTSUB"] = "%s para insertar etiqueta"
L["SUG_MISC"] = "Varios"
L["SUG_NPCAURAS"] = "Ventajas/Desventajas de PNJs conocidas"
L["SUG_OTHEREQUIVS"] = "Otras Equivalencias"
L["SUG_PATTERNMATCH_FISHINGLURE"] = "Cebo de pesca %(%+%d+ habilidad para pescar%)"
L["SUG_PATTERNMATCH_SHARPENINGSTONE"] = "Afilado %(%+%d+ daño%)"
L["SUG_PATTERNMATCH_WEIGHTSTONE"] = "Pesado %(%+%d+ daño%)"
L["SUG_PLAYERAURAS"] = "Ventajas/Desventajas de mascota/PJ conocidas"
L["SUG_PLAYERSPELLS"] = "Sus hechizos"
L["SUG_TOOLTIPTITLE"] = [=[Mientras escribe, TellMeWhen revisará su caché y determinará los hechizos que más probablemente estaba buscando. 

Los hechizos están categorizados y coloreados según la lista inferior. Note que las categorías con la palabra "conocido" no serán pobladas con hechizos hasta que se hayan visto mientras juega o se conecta con diferentes Clases. 

Haga click en una entrada para insertarla en el cuadro de edición. ]=]
L["SUG_TOOLTIPTITLE_TEXTSUBS"] = [=[Las siguientes son etiquetas que puede querer usar en este display de texto. Usar una sustitución provocará que sea reemplazada por los datos apropiados cuando quiera que sea mostrada. 

Para más información sobre estas etiquetas, y para más etiquetas, pulse este botón. 

Pulsar en una entrada la insertará en el cuadro de edición.]=]
L["SUGGESTIONS"] = "Sugerencias:"
L["SUGGESTIONS_DOGTAGS"] = "DogTags:"
L["SUN"] = "Sol"
L["SWINGTIMER"] = "Temporizador de Golpe"
L["TEXTLAYOUTS"] = "Diseños de Texto"
L["TEXTLAYOUTS_ADDANCHOR"] = "Añadir anclaje"
L["TEXTLAYOUTS_ADDANCHOR_DESC"] = "Pulse para añadir otro anclaje de texto. "
L["TEXTLAYOUTS_ADDLAYOUT"] = "Crear Nuevo Diseño"
L["TEXTLAYOUTS_ADDLAYOUT_DESC"] = "Crear un nuevo diseño de texto que puede configurar y aplicar a sus iconos."
L["TEXTLAYOUTS_ADDSTRING"] = "Añadir Display de Texto"
L["TEXTLAYOUTS_ADDSTRING_DESC"] = "Añade un nuevo display de texto a este diseño de texto."
L["TEXTLAYOUTS_BLANK"] = "(En Blanco)"
L["TEXTLAYOUTS_CHOOSELAYOUT"] = "Elija Diseño..."
L["TEXTLAYOUTS_CHOOSELAYOUT_DESC"] = "Seleccione el diseño de texto a usar para este icono."
L["TEXTLAYOUTS_CLONELAYOUT"] = "Clonar diseño"
L["TEXTLAYOUTS_CLONELAYOUT_DESC"] = "Click para crear una copia de este diseño que puede editar por separado. "
L["TEXTLAYOUTS_DEFAULTS_BAR1"] = "Diseño de Barra 1"
L["TEXTLAYOUTS_DEFAULTS_BINDINGLABEL"] = "Enlace/Etiqueta"
L["TEXTLAYOUTS_DEFAULTS_CENTERNUMBER"] = "Centrar número"
L["TEXTLAYOUTS_DEFAULTS_DURATION"] = "Duración"
L["TEXTLAYOUTS_DEFAULTS_ICON1"] = "Diseño de Icono 1"
L["TEXTLAYOUTS_DEFAULTS_NOLAYOUT"] = "<Sin Diseño>"
L["TEXTLAYOUTS_DEFAULTS_NUMBER"] = "Número"
L["TEXTLAYOUTS_DEFAULTS_SPELL"] = "Hechizo"
L["TEXTLAYOUTS_DEFAULTS_STACKS"] = "Acumulaciones "
L["TEXTLAYOUTS_DEFAULTS_WRAPPER"] = "Por defecto: %s"
L["TEXTLAYOUTS_DEFAULTTEXT"] = "Texto Por Defecto"
L["TEXTLAYOUTS_DEFAULTTEXT_DESC"] = "Edita el texto por defecto que será usado cuando este diseño de texto se establezca para un icono."
L["TEXTLAYOUTS_DELANCHOR"] = "Borrar anclaje"
L["TEXTLAYOUTS_DELANCHOR_DESC"] = "Pulse para borrar este anclaje de texto. "
L["TEXTLAYOUTS_DELETELAYOUT"] = "Borrar Diseño"
L["TEXTLAYOUTS_DELETESTRING"] = "Borrar Display de Texto"
L["TEXTLAYOUTS_ERROR_FALLBACK"] = [=[El diseño de texto para este icono no se encontró. Se usará un  diseño por defecto hasta que se encuentre el diseño pretendido, o hasta que se seleccione otro. 

(Borró el diseño? O importó este icono sin importar el diseño que usaba?)]=]
L["TEXTLAYOUTS_fLAYOUT"] = "Diseño de Texto: %s"
L["TEXTLAYOUTS_FONTSETTINGS"] = "Ajustes de Fuente"
L["TEXTLAYOUTS_fSTRING"] = "Mostrar %s"
L["TEXTLAYOUTS_fSTRING2"] = "Mostrar %d: %s"
L["TEXTLAYOUTS_fSTRING3"] = "Display de Texto: %s"
L["TEXTLAYOUTS_HEADER_DISPLAY"] = "Display de Texto"
L["TEXTLAYOUTS_HEADER_LAYOUT"] = "Diseño de Texto"
L["TEXTLAYOUTS_IMPORT"] = "Importar Diseño de Texto"
L["TEXTLAYOUTS_IMPORT_CREATENEW"] = "|cff59ff59Crear|r Nuevo"
L["TEXTLAYOUTS_IMPORT_CREATENEW_DESC"] = [=[Ya existe un diseño de texto con el mismo identificador único que éste. 

Elija esta opción para generar un nuevo identificador único e importar el diseño. ]=]
L["TEXTLAYOUTS_IMPORT_NORMAL_DESC"] = "Click para importar el diseño de texto. "
L["TEXTLAYOUTS_IMPORT_OVERWRITE"] = "|cFFFF5959Reemplazar|r Existente"
L["TEXTLAYOUTS_IMPORT_OVERWRITE_DESC"] = [=[Ya existe un diseño de texto con el mismo identificador único que éste. 

Elija esta opción para sobrescribir el diseño de texto existente con este diseño. Todos los iconos que usen el diseño existente serán actualizados acorde a esto.]=]
L["TEXTLAYOUTS_IMPORT_OVERWRITE_DISABLED_DESC"] = "No puede sobrescribir un diseño de texto por defecto."
L["TEXTLAYOUTS_LAYOUT_SETDEFAULTS"] = "Restaurar Valores por Defecto"
L["TEXTLAYOUTS_LAYOUT_SETDEFAULTS_DESC"] = "Restaura todos los textos de display a sus textos por defecto, establecidos en los ajustes del diseño de texto actual. "
L["TEXTLAYOUTS_LAYOUTDISPLAYS"] = [=[Muestra:
%s]=]
L["TEXTLAYOUTS_LAYOUTSETTINGS"] = "Ajustes de Diseño"
L["TEXTLAYOUTS_LAYOUTSETTINGS_DESC"] = "Pulse para configurar el diseño de texto %q."
L["TEXTLAYOUTS_NOEDIT_DESC"] = [=[Este diseño de texto es un diseño por defecto que viene estándar con TellMeWhen y no puede ser modificado. 

Si desea modificarlo, por favor clónelo. ]=]
L["TEXTLAYOUTS_POSITIONSETTINGS"] = "Ajustes de Posición"
L["TEXTLAYOUTS_RELATIVETO_DESC"] = "El objeto al que el texto será anclado"
L["TEXTLAYOUTS_RENAME"] = "Renombrar Diseño"
L["TEXTLAYOUTS_RENAME_DESC"] = "Renombre este diseño a un nombre que describa su función para que pueda identificarlo fácilmente."
L["TEXTLAYOUTS_RENAMESTRING"] = "Renombrar Display"
L["TEXTLAYOUTS_RENAMESTRING_DESC"] = "Ponga a este display un nombre adecuado a su propósito de modo que pueda identificarlo fácilmente."
L["TEXTLAYOUTS_RESETSKINAS"] = "El ajuste %q se ha restaurado para la cadena de fuente %q para evitar conflictos con el nuevo ajuste para la cadena de fuente %q."
L["TEXTLAYOUTS_SETGROUPLAYOUT"] = "Diseño de Texto"
L["TEXTLAYOUTS_SETGROUPLAYOUT_DDVALUE"] = "Seleccione diseño..."
L["TEXTLAYOUTS_SETGROUPLAYOUT_DESC"] = [=[Establece el diseño de texto que usarán todos los iconos de este grupo. 

El diseño de texto puede ser establecido individualmente por icono en los ajustes de cada icono. ]=]
L["TEXTLAYOUTS_SETTEXT"] = "Establecer Texto"
L["TEXTLAYOUTS_SETTEXT_DESC"] = [=[Establece el texto que será usado en este display de texto. 

Se puede dar formato al texto con etiquetas DogTag, permitiendo mostrar información dinámicamente. Escriba '/dogtag' o '/dt' para obtener ayuda sobre cómo usar estas etiquetas.  ]=]
L["TEXTLAYOUTS_SKINAS"] = "Poner Piel Como"
L["TEXTLAYOUTS_SKINAS_COUNT"] = "Texto de Acumulación"
L["TEXTLAYOUTS_SKINAS_DESC"] = "Elija el elemento Masque con el que desea poner piel a este texto. "
L["TEXTLAYOUTS_SKINAS_HOTKEY"] = "Texto Enlazante"
L["TEXTLAYOUTS_SKINAS_NONE"] = "Ninguno"
L["TEXTLAYOUTS_STRING_COPYMENU"] = "Copiar"
L["TEXTLAYOUTS_STRING_COPYMENU_DESC"] = "Click para abrir una lista de todos los textos que se usan en este perfil que puede copiar a este display de texto. "
L["TEXTLAYOUTS_STRING_SETDEFAULT"] = "Restablecer a Por Defecto"
L["TEXTLAYOUTS_STRING_SETDEFAULT_DESC"] = [=[Restablece el texto de este display al siguiente texto por defecto, establecido en los ajustes de diseño de texto actual: 

%s]=]
L["TEXTLAYOUTS_STRINGUSEDBY"] = "Usado %d |4vez:veces;."
L["TEXTLAYOUTS_TAB"] = "Displays de Texto"
L["TEXTLAYOUTS_UNNAMED"] = "<sin nombre>"
L["TEXTMANIP"] = "Manipulación de texto"
L["TOOLTIPSCAN"] = "Variable de Aura"
L["TOOLTIPSCAN_DESC"] = "Este tipo de condición le permite comprobar la primera variable asociada con un aura. Los números los provee la API de Blizzard y no necesariamente concuerdan con los números del tooltip del aura. Tampoco hay garantía de que se obtendrá un número para un aura. Para la mayor parte de los casos prácticos, sin embargo, se comprobará el número correcto. "
L["TOP"] = "Arriba"
L["TOPLEFT"] = "Arriba Izquierda"
L["TOPRIGHT"] = "Arriba Derecha"
L["TOTEMS"] = "Tótems a comprobar"
L["TRUE"] = "Verdadero"
L["UIPANEL_ANCHORNUM"] = "Ancla %d"
L["UIPANEL_BARTEXTURE"] = "Textura de barra"
L["UIPANEL_COLUMNS"] = "Columnas"
L["UIPANEL_COMBATCONFIG"] = "Permitir configurar en combate"
L["UIPANEL_COMBATCONFIG_DESC"] = [=[Active esto para permitir la configuración de TellMeWhen estando en combate. 

Tenga en cuenta que esto obligará al módulo de opciones a estar cargado constantemente, resultando en un mayor uso de memoria y tiempos de carga ligeramente mayores. 


Esta opción afecta a toda la cuenta: todos sus perfiles compartirán este ajuste. 

|cffff5959Los cambios sólo se aplicarán después de que |cff7fffffrecargue su UI|cffff5959.|r]=]
L["UIPANEL_DELGROUP"] = "Borrar este Grupo"
L["UIPANEL_DRAWEDGE"] = "Resaltar borde temporizador"
L["UIPANEL_DRAWEDGE_DESC"] = "Destaca el borde del temporizador de tiempo de reutilización (la animación del reloj) para aumentar la visibilidad"
L["UIPANEL_EFFTHRESHOLD"] = "Umbral de Eficiencia de Ventaja"
L["UIPANEL_EFFTHRESHOLD_DESC"] = "Establece el número mínimo de ventajas/desventajas para cambiar a un modo más eficiente de comprobarlas cuando haya un gran número. Considere que una vez que el número de auras comprobadas excede este número, las auras más antiguas serán priorizadas en vez de prioridad basada en el orden en que fueron introducidas. "
L["UIPANEL_FONT_DESC"] = "Elija la fuente a usar por el texto de acumulación en los iconos"
L["UIPANEL_FONT_JUSTIFY"] = "Justificado"
L["UIPANEL_FONT_JUSTIFY_DESC"] = "Establece el justificado (Izquierda/Centrado/Derecha) para este display de texto. "
L["UIPANEL_FONT_OUTLINE"] = "Contorno de Fuente"
L["UIPANEL_FONT_SHADOW"] = "Desplazamiento de Sombra"
L["UIPANEL_FONT_SHADOW_DESC"] = "Cambia la cantidad de desplazamiento de la sombra tras el texto. Establezca a cero para desactivar la sombra. "
L["UIPANEL_FONT_SIZE"] = "Tamaño de Fuente"
L["UIPANEL_FONT_XOFFS"] = "Desplazamiento X"
L["UIPANEL_FONT_XOFFS_DESC"] = "El desplazamiento del eje x del ancla"
L["UIPANEL_FONT_YOFFS"] = "Desplazamiento Y"
L["UIPANEL_FONT_YOFFS_DESC"] = "El desplazamiento de eje-y del ancha"
L["UIPANEL_FONTFACE"] = "Tipografía"
L["UIPANEL_GLYPH"] = "Glifo activo"
L["UIPANEL_GLYPH_DESC"] = "Comprueba si tiene activo un glifo en concreto"
L["UIPANEL_GROUPALPHA"] = "Opacidad de grupo"
L["UIPANEL_GROUPALPHA_DESC"] = [=[Establece el nivel de opacidad del grupo entero. 

Este ajuste no tiene efecto en la funcionalidad de los propios iconos. Sólo cambia la apariencia del grupo y sus iconos. 

Establezca este ajuste a 0 si quiere ocultar el grupo entero permitiéndole permanecer completamente funcional (semejante al ajuste %q para iconos).]=]
L["UIPANEL_GROUPNAME"] = "Renombrar Grupo"
L["UIPANEL_GROUPRESET"] = "Restablecer Posición"
L["UIPANEL_GROUPS"] = "Grupos"
L["UIPANEL_GROUPSORT"] = "Ordenación de Iconos"
L["UIPANEL_GROUPSORT_alpha"] = "Opacidad"
L["UIPANEL_GROUPSORT_alpha_DESC"] = "Ordena el grupo por la opacidad de sus iconos."
L["UIPANEL_GROUPSORT_duration"] = "Duración"
L["UIPANEL_GROUPSORT_duration_DESC"] = "Ordena el grupo por la duración restante de sus iconos. "
L["UIPANEL_GROUPSORT_id"] = "ID de Icono"
L["UIPANEL_GROUPSORT_id_DESC"] = "Ordena el grupo por los números de ID de sus iconos. "
L["UIPANEL_GROUPSORT_shown"] = "Mostrado"
L["UIPANEL_GROUPSORT_shown_DESC"] = "Ordena el grupo según si el icono es mostrado o no."
L["UIPANEL_GROUPSORT_stacks"] = "Acumulaciones"
L["UIPANEL_GROUPSORT_stacks_DESC"] = "Ordena el grupo por las acumulaciones de cada icono. "
L["UIPANEL_GROUPTYPE"] = "Método de visualización de grupo"
L["UIPANEL_GROUPTYPE_BAR"] = "Barra"
L["UIPANEL_GROUPTYPE_BAR_DESC"] = "Muestra los iconos del grupo con barras de progreso adjuntas a los mismos. "
L["UIPANEL_GROUPTYPE_ICON"] = "Icono"
L["UIPANEL_GROUPTYPE_ICON_DESC"] = "Muestra los iconos en el grupo usando la visualización tradicional de iconos de TellMeWhen"
L["UIPANEL_ICONS"] = "Iconos"
L["UIPANEL_ICONSPACING_DESC"] = "Distancia de separación entre iconos dentro de un grupo"
L["UIPANEL_ICONSPACINGX"] = "Espaciado Horizontal de Icono"
L["UIPANEL_ICONSPACINGY"] = "Espaciado Vertical de Icono"
L["UIPANEL_LEVEL"] = "Nivel de Marco"
L["UIPANEL_LOCK"] = "Bloquear Posición"
L["UIPANEL_LOCK_DESC"] = "Bloquear este grupo, evitando moverlo o cambiarle el tamaño al arrastrar el grupo o la ficha de escala"
L["UIPANEL_LOCKUNLOCK"] = "Bloquear / Desbloquear AddOn"
L["UIPANEL_MAINOPT"] = "Opciones Principales"
L["UIPANEL_ONLYINCOMBAT"] = "Mostrar sólo en combate"
L["UIPANEL_POINT"] = "Punto"
L["UIPANEL_POSITION"] = "Posición"
L["UIPANEL_PRIMARYSPEC"] = "Especialización primaria"
L["UIPANEL_PTSINTAL"] = "Puntos en talento"
L["UIPANEL_RELATIVEPOINT"] = "Punto Relativo"
L["UIPANEL_RELATIVETO"] = "Relativo A"
L["UIPANEL_RELATIVETO_DESC"] = "Escriba /framestack para activar/desactivar un tooltip que contiene una lista de todos los marcos sobre los que está el ratón, y sus nombres, para ponerlos en este diálogo. "
L["UIPANEL_ROWS"] = "Filas"
L["UIPANEL_SCALE"] = "Escala"
L["UIPANEL_SECONDARYSPEC"] = "Especialización Secundaria"
L["UIPANEL_SPEC"] = "Doble especialización"
L["UIPANEL_SPECIALIZATION"] = "Especialización de Talentos"
L["UIPANEL_STRATA"] = "Capa de Marco"
L["UIPANEL_SUBTEXT2"] = [=[Los iconos sólo funcionan cuando están bloqueados. 

Cuando están desbloqueados, puede mover/cambiar el tamaño de grupos de iconos y hacer click derecho en iconos individuales para configurarlos. 

También puede escribir /tellmewhen o /tmw para bloquear/desbloquear]=]
L["UIPANEL_TALENTLEARNED"] = "Talento aprendido"
L["UIPANEL_TOOLTIP_COLUMNS"] = "Establecer el número de columnas en este grupo"
L["UIPANEL_TOOLTIP_GROUPRESET"] = "Restablecer la posición y escala de este grupo"
L["UIPANEL_TOOLTIP_ONLYINCOMBAT"] = "Marcar para que este grupo sólo se muestre en combate"
L["UIPANEL_TOOLTIP_ROWS"] = "Establecer el número de filas de este grupo"
L["UIPANEL_TOOLTIP_UPDATEINTERVAL"] = [=[Establece cuán a menudo (en segundos) son comprobados los iconos para mostrar/ocultar, alfa, condiciones, etc

Cero es tan rápido como sea posible. Valores más bajos pueden tener un impacto significativo en la tasa de fotogramas para ordenadores de gama baja.]=]
L["UIPANEL_TREE_DESC"] = "Marque para permitir que este grupo se muestre cuando este árbol de talentos esté activo, o desmárquelo para que se oculte cuando no está activo. "
L["UIPANEL_UPDATEINTERVAL"] = "Intervalo de actualización"
L["UIPANEL_WARNINVALIDS"] = "Avisar sobre iconos inválidos"
L["UNDO"] = "Deshacer"
L["UNITCONDITIONS"] = "Condiciones de Unidad"
L["UNITCONDITIONS_DESC"] = "Click para configurar un conjunto de condiciones que cada unidad tendrá que cumplir para ser comprobada."
L["UNITCONDITIONS_STATICUNIT"] = "<Unidad de Icono>"
L["UNITCONDITIONS_STATICUNIT_DESC"] = "Hace que la condición compruebe cada unidad que el icono está comprobando."
L["UNITCONDITIONS_STATICUNIT_TARGET"] = "Objetivo de <Unidad de Icono>"
L["UNITCONDITIONS_STATICUNIT_TARGET_DESC"] = "Hace que la condición compruebe el objetivo de cada unidad que el icono está comprobando. "
L["UNITCONDITIONS_TAB_DESC"] = "Configura condiciones que cada unidad tendrá que cumplir para ser comprobada. "
L["UNITTWO"] = "Segunda Unidad"
L["UNNAMED"] = "((Sin nombre))"
L["WARN_DRMISMATCH"] = [=[Advertencia! Está comprobando rendimientos decrecientes en hechizos de dos categorías conocidas diferentes. 

Todos los hechizos deben ser de la misma categoría de rendimiento decreciente para que el icono funcione correctamente. Se detectaron las siguientes categorías y hechizos:]=]
L["WATER"] = "Agua"
L["worldboss"] = "Jefe del Mundo"

elseif locale == "esMX" then
L["CHOOSENAME_DIALOG"] = "Introduzca el nombre o la identificación de los hechizos / Capacidad / artículo / Buff / Debuff desea que este icono de la pantalla. Usted puede agregar múltiples Buffs / Debuffs separándolas con';'."
L["CHOOSENAME_DIALOG_PETABILITIES"] = "|cFFFF5959HABILIDADES PET|r debe utilizar SpellIDs."
L["CMD_OPTIONS"] = "Opciones"
L["CONDITIONPANEL_AND"] = "Y"
L["CONDITIONPANEL_ANDOR"] = "Y / O"
L["CONDITIONPANEL_ECLIPSE_DESC"] = [=[Eclipse tiene un rango de -100 (un eclipse lunar) a 100 (un eclipse solar) 
Percentages trabajo de la misma manera:. 
Input -80 si desea que el icono de trabajar con un valor de 80 energía lunar. ]=]
L["CONDITIONPANEL_EQUALS"] = "iguales"
L["CONDITIONPANEL_GREATER"] = "mayor que"
L["CONDITIONPANEL_GREATEREQUAL"] = "Mayor o igual a"
L["CONDITIONPANEL_LESS"] = "menor que"
L["CONDITIONPANEL_LESSEQUAL"] = "Menor o igual a"
L["CONDITIONPANEL_NOTEQUAL"] = "No es igual a"
L["CONDITIONPANEL_OPERATOR"] = "operador"
L["CONDITIONPANEL_OR"] = "O"
L["CONDITIONPANEL_POWER_DESC"] = [=[buscará la energía si la unidad es un druida en forma de gato, 
rage si la unidad es un guerrero, etc]=]
L["CONDITIONPANEL_TYPE"] = "Tipo"
L["CONDITIONPANEL_UNIT"] = "Unidad"
L["ICONMENU_ABSENT"] = "|cFFFF0000Ausente|r"
L["ICONMENU_BUFF"] = "Buff"
L["ICONMENU_BUFFDEBUFF"] = "Buff / Debuff"
L["ICONMENU_BUFFTYPE"] = "Buff o desventaja?"
L["ICONMENU_DEBUFF"] = "Desventaja"
L["ICONMENU_ENABLE"] = "Activado"
L["ICONMENU_FOCUSTARGET"] = "Focus' target"
L["ICONMENU_FRIEND"] = "|cFF00FF00Unidades Amigas|r"
L["ICONMENU_HOSTILE"] = "|cFF00FF00Unidades Hostiles|r"
L["ICONMENU_INVERTBARS"] = "Llene barras de arriba"
L["ICONMENU_MANACHECK"] = "Comprobar poder?"
L["ICONMENU_ONLYMINE"] = "Mostrar sólo si se emiten por sí mismo"
L["ICONMENU_PETTARGET"] = "objetivo de mascotas"
L["ICONMENU_PRESENT"] = "|cFF00FF00Present|r"
L["ICONMENU_RANGECHECK"] = "Comprobar Gama?"
L["ICONMENU_REACT"] = "Reacción del Unidad"
L["ICONMENU_REACTIVE"] = "hechizo reactiva o la capacidad"
L["ICONMENU_SHOWTIMER"] = "Mostrar reloj"
L["ICONMENU_SHOWWHEN"] = "Mostrar icono cuando"
L["ICONMENU_STACKS_MAX_DESC"] = "Cantidad máxima de las pilas del aura es necesario para mostrar el icono"
L["ICONMENU_STACKS_MIN_DESC"] = "Número mínimo de las pilas del aura es necesario para mostrar el icono"
L["ICONMENU_TARGETTARGET"] = "El objectivo del objectivo"
L["ICONMENU_TOTEM"] = "Totem / Ghoul no MoG"
L["ICONMENU_TYPE"] = "Icono de tipo"
L["ICONMENU_UNUSABLE"] = "|cFFFF0000Inutilizable|r"
L["ICONMENU_USABLE"] = "|cFF00FF00útil|r"
L["ICONMENU_WPNENCHANT"] = "temporal encantar arma"
L["ICONMENU_WPNENCHANTTYPE"] = "ranura de armas para controlar"
L["RESIZE"] = "tamaño"
L["RESIZE_TOOLTIP"] = "Haz clic y arrastra para cambiar el tamaño"
L["SUG_PATTERNMATCH_FISHINGLURE"] = "Cebo de pesca %(%+%d+ habilidad para pescar%)"
L["SUG_PATTERNMATCH_SHARPENINGSTONE"] = "Afilado %(%+%d+ daño%)"
L["SUG_PATTERNMATCH_WEIGHTSTONE"] = "Pesado %(%+%d+ daño%)"
L["UIPANEL_BARTEXTURE"] = "Barra de textura"
L["UIPANEL_COLUMNS"] = "Columnas"
L["UIPANEL_DRAWEDGE"] = "Resaltar borde temporizador"
L["UIPANEL_DRAWEDGE_DESC"] = "Destaca el borde del temporizador de tiempo de reutilización (la animación del reloj) para aumentar la visibilidad"
L["UIPANEL_GROUPRESET"] = "Posición Inicial"
L["UIPANEL_LOCK"] = "AddOn bloqueo"
L["UIPANEL_LOCKUNLOCK"] = "Bloqueo / Desbloqueo AddOn"
L["UIPANEL_ONLYINCOMBAT"] = "Mostrar sólo en combate"
L["UIPANEL_PRIMARYSPEC"] = "Spec primaria"
L["UIPANEL_ROWS"] = "Filas"
L["UIPANEL_SECONDARYSPEC"] = "Spec Secundaria"
L["UIPANEL_SUBTEXT2"] = "Iconos de trabajo una vez cerradas Cuando desbloqueado, puede mover o grupos icono de tamaño y haga clic derecho en los iconos individuales para más opciones de configuración También puede escribir '/tellmewhen' o '/tmw' para bloquear o desbloquear."
L["UIPANEL_TOOLTIP_COLUMNS"] = "Establecer el número de columnas de iconos en este grupo"
L["UIPANEL_TOOLTIP_GROUPRESET"] = "Restablecer la posición de este grupo"
L["UIPANEL_TOOLTIP_ONLYINCOMBAT"] = "Comprobar para mostrar sólo este grupo de iconos en combate"
L["UIPANEL_TOOLTIP_ROWS"] = "Establecer el número de filas en el icono de este grupo"
L["UIPANEL_TOOLTIP_UPDATEINTERVAL"] = "Establece la frecuencia (en segundos) que los iconos son revisados para mostrar / ocultar, alfa, condiciones, etc, no afecta demasiado bares. Cero es tan rápido como sea posible. Los valores más bajos pueden tener un impacto significativo en la tasa de fotogramas de gama baja computadoras "
L["UIPANEL_UPDATEINTERVAL"] = "Intervalo de actualización"

elseif locale == "frFR" then
L["!!Main Addon Description"] = "Fournit des notifications visuelles, auditives et textuelles sur les temps de recharge, les améliorations et à peu près tout le reste"
L["ABSORBAMT"] = "Quantité de bouclier d'absorption"
L["ABSORBAMT_DESC"] = "Vérifie la quantité totale de boucliers d'absorption que l'unité a"
L["ACTIVE"] = "% d actif"
L["ADDONSETTINGS_DESC"] = "Configurez tous les paramètres généraux des add-ons"
L["AIR"] = "Air"
L["ALLOWCOMM"] = "Autoriser le partage en jeu"
L["ALLOWCOMM_DESC"] = "Autoriser les autres utilisateurs TellMeWhen à vous envoyer des données. Vous devrez recharger votre interface utilisateur ou vous déconnecter avant de pouvoir recevoir des données."
L["ALLOWVERSIONWARN"] = "Notifier de nouvelles versions"
L["ALPHA"] = "Opacité"
L["ANCHOR_CURSOR_DUMMY_DESC"] = "Ceci est un curseur fictif pour vous aider à positionner vos icônes ancrées au curseur. L'ancrage des groupes au curseur peut être utile pour les icônes qui vérifient l'unité 'mouseover'. Pour ancrer un groupe au curseur, | cff7fffffRight-Click-and-drag | r une icône pour ce mannequin. En raison d'un bogue de Blizzard, l'animation de balayage de cooldown sera mise en surbrillance quand elle se déplace, vous devriez donc probablement la désactiver pour les icônes ancrées au curseur. | cff7fffffLeft-Cliquez et faites glisser | r pour déplacer ce mannequin."
L["ANCHORTO"] = "Ancre à"
L["ANIM_ACTVTNGLOW"] = "Icône: Activation des bordures"
L["ANIM_ACTVTNGLOW_DESC"] = "Affiche la bordure d'activation du sort Blizzard sur l'icône."
L["ANIM_ALPHASTANDALONE"] = "Opacité"
L["ANIM_ALPHASTANDALONE_DESC"] = "Définissez l'opacité de l'animation."
L["ANIM_COLOR"] = "Couleur / Opacité"
L["ANIM_COLOR_DESC"] = "Configurer la couleur et l'opacité du flash."
L["ANIM_ICONBORDER_DESC"] = "Superpose une bordure colorée sur l'icône."
L["ANIM_ICONCLEAR"] = "Icône: Arrêter les animations"
L["ANIM_ICONOVERLAYIMG_DESC"] = "Superpose une image personnalisée sur l'icône."
L["ANIM_SCREENFLASH_DESC"] = "Clignote une superposition colorée sur l'écran."
L["Bleeding"] = "Saigne"
L["CASTERFORM"] = "Forme de lanceur de sorts"
L["CHOOSENAME_DIALOG"] = "Entrer le nom ou l'id du Sort/Capacité/Objet/Buff/Débuff attribué à cette icône. Vous pouvez ajouter de multiples buffs/débuffs en les séparant avec ';'."
L["CHOOSENAME_DIALOG_PETABILITIES"] = "|cFFFF5959COMPETENCES PET|r devraient utiliser SpellIDs."
L["CMD_OPTIONS"] = "Options"
L["CONDITIONPANEL_ALIVE"] = "Unité est en vie"
L["CONDITIONPANEL_ALIVE_DESC"] = "Le test passera si l'unité est en vie"
L["CONDITIONPANEL_AND"] = "Et"
L["CONDITIONPANEL_ANDOR"] = "Et / Ou"
L["CONDITIONPANEL_COMBAT"] = "Unité est en combat"
L["CONDITIONPANEL_COMBO"] = "Points de combo"
L["CONDITIONPANEL_ECLIPSE_DESC"] = [=[Eclipse fonctionne sur une fourchette de valeurs allant de -100 (éclipse lunaire) à 100 (éclipse solaire).
Entrez -80 si vous voulez faire fonctionner l'icône avec une valeur de 80 en éclipse lunaire.]=]
L["CONDITIONPANEL_EQUALS"] = "Égal à"
L["CONDITIONPANEL_EXISTS"] = "L'unité existe"
L["CONDITIONPANEL_GREATER"] = "Plus Grand Que"
L["CONDITIONPANEL_GREATEREQUAL"] = "Plus Grand Que ou Égal à"
L["CONDITIONPANEL_GROUPTYPE"] = "Type de groupe"
L["CONDITIONPANEL_ICON"] = "Icône affichée"
L["CONDITIONPANEL_ICON_DESC"] = [=[La condition sera remplie si l'icône spécifiée est actuellement affichée avec une transparence supérieure à 0.
Si vous ne voulez pas afficher les icônes cochées, cochez l'option %q dans les réglages de la transparence de l'icône.
Le groupe de l'icône cochée doit aussi être affiché pour cocher l'icône.]=]
L["CONDITIONPANEL_LESS"] = "Moins Que"
L["CONDITIONPANEL_LESSEQUAL"] = "Moins Que ou Égal à"
L["CONDITIONPANEL_NOTEQUAL"] = "Pas Égal à"
L["CONDITIONPANEL_OPERATOR"] = "Opérateur"
L["CONDITIONPANEL_OR"] = "Ou"
L["CONDITIONPANEL_POWER"] = "Puissance"
L["CONDITIONPANEL_POWER_DESC"] = [=[Vérifiera l'énergie du personnage s'il s'agit d'un druide en forme de félin,
sa rage si le personnage est un guerrier, etc.]=]
L["CONDITIONPANEL_PVPFLAG"] = "Unité est taggué PVP"
L["CONDITIONPANEL_RESTING"] = "Restant"
L["CONDITIONPANEL_TYPE"] = "Type"
L["CONDITIONPANEL_UNIT"] = "Personnage"
L["CONDITIONPANEL_VALUEN"] = "Valeur"
L["COPYPOSSCALE"] = "Copier position/échelle uniquement"
L["DESCENDING"] = "descendant"
L["DISABLED"] = "Désactivé"
L["Disoriented"] = "Désorienté"
L["EARTH"] = "Terre"
L["ECLIPSE_DIRECTION"] = "Sens de l'éclipse"
L["Enraged"] = "Enragé"
L["EVENTS_SETTINGS_PASSTHROUGH"] = "Continuer à réduire les événements"
L["FALSE"] = "Faux"
L["Feared"] = "Peur"
L["FIRE"] = "Feu"
L["GCD"] = "Temps de recharge global"
L["GROUP"] = "Groupe"
L["GROUPICON"] = "Groupe : %s, Icône : %d"
L["ICONALPHAPANEL_FAKEHIDDEN"] = "Toujours Masquer"
L["ICONALPHAPANEL_FAKEHIDDEN_DESC"] = "Tout le temps cacher l’icône tout en la laissant active afin de permettre aux conditions des autres icônes d'effectuer des vérifications sur l’icône masquée."
L["ICONMENU_ABSENT"] = "Absent"
L["ICONMENU_APPENDCONDT"] = "Ajoute %q en condition"
L["ICONMENU_BOTH"] = "Soit"
L["ICONMENU_BUFF"] = "Buff"
L["ICONMENU_BUFFDEBUFF"] = "Buff/Débuff"
L["ICONMENU_BUFFTYPE"] = "Buff ou débuff ?"
L["ICONMENU_COOLDOWNCHECK"] = "Vérification de cooldown ?"
L["ICONMENU_DEBUFF"] = "Débuff"
L["ICONMENU_DURATION_MAX_DESC"] = "Durée maximale permise pour afficher l'icône"
L["ICONMENU_DURATION_MIN_DESC"] = "Durée minimale nécessaire pour afficher l'icône"
L["ICONMENU_ENABLE"] = "Activé"
L["ICONMENU_FOCUS"] = "Focus"
L["ICONMENU_FOCUSTARGET"] = "Cible du focus"
L["ICONMENU_FRIEND"] = "Unités amicales"
L["ICONMENU_HIDEUNEQUIPPED"] = "Cacher quand le trou est vide"
L["ICONMENU_HOSTILE"] = "Unités hostiles"
L["ICONMENU_INVERTBARS"] = "Inverser les barres"
L["ICONMENU_MANACHECK"] = "Vérification de la puissance"
L["ICONMENU_MOUSEOVER"] = "Survol de la souris"
L["ICONMENU_MOUSEOVERTARGET"] = "Cible du survol de la souris"
L["ICONMENU_OFFS"] = "Offset"
L["ICONMENU_ONLYMINE"] = "Ne montrer que si lancé par soi"
L["ICONMENU_PETTARGET"] = "Cible du familier"
L["ICONMENU_PRESENT"] = "Présent"
L["ICONMENU_RANGECHECK"] = "Vérification de la portée ?"
L["ICONMENU_REACT"] = "Réaction d'unités"
L["ICONMENU_REACTIVE"] = "Sort réactif ou capacité"
L["ICONMENU_SHOWTIMER"] = "Montrer le timer"
L["ICONMENU_SHOWTIMERTEXT"] = "Afficher le numéro du timer"
L["ICONMENU_SHOWTIMERTEXT_DESC"] = "Cochez cette option pour afficher un texte de la durée restante sur l'icone."
L["ICONMENU_SHOWWHEN"] = "Montrer l'icône quand"
L["ICONMENU_STACKS_MAX_DESC"] = "Nombre maximum de stacks de l'aura requis pour montrer l'icône"
L["ICONMENU_STACKS_MIN_DESC"] = "Nombre minimum de stacks de l'aura requis pour montrer l’icône"
L["ICONMENU_TARGETTARGET"] = "Cible de la cible"
L["ICONMENU_TOTEM"] = "Totem/Goule non améliorée"
L["ICONMENU_TYPE"] = "Type d'icône"
L["ICONMENU_UNUSABLE"] = "Inutilisable"
L["ICONMENU_USABLE"] = "Utilisable"
L["ICONMENU_VEHICLE"] = "Véhicule"
L["ICONMENU_WPNENCHANT"] = "Enchantement d'arme temporaire"
L["ICONMENU_WPNENCHANTTYPE"] = "Slot d'arme à surveiller"
L["ICONTOCHECK"] = "Icône à vérifier"
L["ImmuneToMagicCC"] = "Immunisé aux contrôles magiques"
L["ImmuneToStun"] = "Immunisé aux étourdissements"
L["Incapacitated"] = "Incapacité"
L["LDB_TOOLTIP1"] = "|cff7fffffCliquer-gauche|r pour basculer le verrouillage des groupes"
L["LDB_TOOLTIP2"] = "Cliquer-droit pour montrer/cacher certains groupes "
L["Magic"] = "Magie"
L["MOON"] = "Lunaire"
L["NONE"] = "Aucune des valeurs ci-dessous"
L["Poison"] = "Poison"
L["ReducedHealing"] = "Soins prodigués réduits"
L["RESIZE"] = "Redimensionner"
L["RESIZE_TOOLTIP"] = "Cliquer et glisser pour changer la taille"
L["Rooted"] = "Immobilisé"
L["Silenced"] = "Silence"
L["Stunned"] = "Étourdi"
L["SUG_PATTERNMATCH_FISHINGLURE"] = "Appât de pêche %(%+%d+ compétence de pêche%)"
L["SUG_PATTERNMATCH_SHARPENINGSTONE"] = "Aiguisé %(%+%d+ points de dégâts%)"
L["SUG_PATTERNMATCH_WEIGHTSTONE"] = "Équilibré %(%+%d+ points de dégâts%)"
L["SUN"] = "Solaire"
L["TRUE"] = "Vrai"
L["UIPANEL_BARTEXTURE"] = "Texture de barre"
L["UIPANEL_COLUMNS"] = "Colonnes"
L["UIPANEL_DELGROUP"] = "Supprimer ce Groupe"
L["UIPANEL_DRAWEDGE"] = "Surbrillance de la bordure du timer"
L["UIPANEL_DRAWEDGE_DESC"] = "Mets en surbrillance la bordure du timer de cooldown (animation en forme de montre) pour augmenter sa visibilité"
L["UIPANEL_FONT_DESC"] = "Choisissez la police d'écriture à utiliser pour le texte des stacks des icônes."
L["UIPANEL_FONT_SIZE"] = "Taille de la police"
L["UIPANEL_GROUPRESET"] = "Réinitialiser Position"
L["UIPANEL_GROUPS"] = "Groupes"
L["UIPANEL_ICONSPACING"] = "Espacement des icônes"
L["UIPANEL_ICONSPACING_DESC"] = "Espace entre les icones du même groupe"
L["UIPANEL_LOCK"] = "Verrouiller l'AddOn"
L["UIPANEL_LOCKUNLOCK"] = "Verrouiller/Déverrouiller l'AddOn"
L["UIPANEL_MAINOPT"] = "Options générales"
L["UIPANEL_ONLYINCOMBAT"] = "Ne montrer qu'en combat"
L["UIPANEL_PRIMARYSPEC"] = "Spé principale"
L["UIPANEL_ROWS"] = "Lignes"
L["UIPANEL_SECONDARYSPEC"] = "Spé secondaire"
L["UIPANEL_SUBTEXT2"] = "Les icônes fonctionnent lorsqu'elles sont verrouillées. Si déverrouillées, vous pouvez déplacer/redimensionner les groupes d'icônes et cliquer droit les icônes individuelles pour plus de réglages. Vous pouvez aussi taper '/tellmewhen' ou '/tmw' pour verrouiller/déverrouiller."
L["UIPANEL_TOOLTIP_COLUMNS"] = "Nombre de colonnes d'icônes pour ce groupe"
L["UIPANEL_TOOLTIP_GROUPRESET"] = "Réinitialise la position de ce groupe"
L["UIPANEL_TOOLTIP_ONLYINCOMBAT"] = "Cocher pour ne montrer ce groupe d'icônes qu'en combat"
L["UIPANEL_TOOLTIP_ROWS"] = "Nombre de lignes d'icônes pour ce groupe"
L["UIPANEL_TOOLTIP_UPDATEINTERVAL"] = "Règle l'intervalle de temps (en secondes) pendant lequel les icônes sont vérifiées pour être montrées/cachées, leur niveau alpha, les conditions, etc. Cela n'affecte pas les barres. Zéro : le plus rapide possible. De faibles valeurs peuvent avoir un impact important sur le nombre d'IPS pour des ordinateurs anciens."
L["UIPANEL_UPDATEINTERVAL"] = "Intervalle de mise à jour"
L["UNKNOWN_GROUP"] = "Groupe inconnu / indisponible"
L["UNKNOWN_ICON"] = "Inconnu / Indisponible Icône"
L["UNKNOWN_UNKNOWN"] = "Inconnu ???"
L["UNNAMED"] = "anonyme"
L["VALIDITY_CONDITION_DESC"] = "Une cible d'une condition de"
L["VALIDITY_CONDITION2_DESC"] = "La condition #% de"
L["VALIDITY_ISINVALID"] = "est invalide."
L["VALIDITY_META_DESC"] = "L'icône #% d vérifiée par l'icône méta"
L["WARN_DRMISMATCH"] = "Attention! Vous vérifiez les rendements décroissants sur les sorts de deux catégories connues différentes. Tous les sorts doivent provenir de la même catégorie de rendements décroissants pour que l'icône fonctionne correctement. Les catégories et les sorts suivants ont été détectés:"
L["WATER"] = "Eau"
L["worldboss"] = "Boss mondial"

elseif locale == "itIT" then
L["ACTIVE"] = "Attiva"
L["AIR"] = [=[Aria
]=]
L["ALLOWCOMM"] = "Permette la condivisione in gioco"
L["ANN_CHANTOUSE"] = "Canale da usare"
L["ANN_EDITBOX"] = "Testo da esportare"
L["ANN_EDITBOX_DESC"] = "Scrivi il testo che desideri esportare quando appare la notifica"
L["ANN_TAB"] = "Testo"
L["ASCENDING"] = "Ascendente"
L["ASPECT"] = "Aspetto"

elseif locale == "koKR" then
L["!!Main Addon Description"] = "재사용 대기시간, 강화 효과, 그 밖의 꽤 많은 것에 대해 시각적, 청각적, 문자적인 알림을 제공합니다."
L["ABSORBAMT"] = "흡수 보호막 수치"
L["ABSORBAMT_DESC"] = "유닛에 적용된 흡수 보호막의 전체 수치를 확인합니다."
L["ACTIVE"] = "%d개 활성"
L["ADDONSETTINGS_DESC"] = "애드온의 모든 일반 설정을 구성합니다."
L["AIR"] = "바람"
L["ALLOWCOMM"] = "게임 내 공유 허용"
L["ALLOWCOMM_DESC"] = [=[다른 TellMeWhen 사용자들의 데이터 전송을 허용합니다.

UI를 다시 불러오거나 재접속 해야 데이터를 수신할 수 있습니다.]=]
L["ALLOWVERSIONWARN"] = "새로운 버전 알리기"
L["ALPHA"] = "불투명도"
L["ANCHOR_CURSOR_DUMMY"] = "TellMeWhen 커서 위치 기준 더미"
L["ANCHOR_CURSOR_DUMMY_DESC"] = [=[커서 주변에 위치시킬 아이콘의 위치 설정을 도와주는 더미 커서입니다.

그룹을 커서 주변에 위치시키면 '마우스오버' 유닛을 확인하는 아이콘에 유용합니다.

그룹을 커서 주변에 위치시키려면, 아이콘을 이 더미로 |cff7fffff오른쪽 클릭하고 끄세요|r.

블리자드 버그때문에 움직이고 있을 때는 재사용 대기시간 애니메이션이 작동하지 않습니다, 따라서 커서 위치 아이콘은 비활성하는 게 좋습니다.

|cff7fffff클릭하고 끌면|r 이 더미를 이동합니다.]=]
L["ANCHORTO"] = "고정시키기: "
L["ANIM_ACTVTNGLOW"] = "아이콘: 활성화 테두리"
L["ANIM_ACTVTNGLOW_DESC"] = "아이콘에 블리자드 주문 활성화 테두리를 표시합니다."
L["ANIM_ALPHASTANDALONE"] = "불투명도"
L["ANIM_ALPHASTANDALONE_DESC"] = "애니메이션의 불투명도를 설정합니다."
L["ANIM_ANCHOR_NOT_FOUND"] = "애니메이션을 고정시킬 %q 이름을 가진 프레임을 찾을 수 없습니다. 이 프레임이 아이콘의 현재 표시에 의해 사용되고 있습니까?"
L["ANIM_ANIMSETTINGS"] = "설정"
L["ANIM_ANIMTOUSE"] = "사용할 애니메이션"
L["ANIM_COLOR"] = "색상/불투명도"
L["ANIM_COLOR_DESC"] = "반짝임의 색상과 불투명도를 설정합니다."
L["ANIM_DURATION"] = "지속시간"
L["ANIM_DURATION_DESC"] = "발생된 후부터 애니메이션이 얼마나 지속될 지 설정합니다."
L["ANIM_FADE"] = "흐릿한 반짝임"
L["ANIM_FADE_DESC"] = "체크하면 각 반짝임 간에 부드럽게 흐릿해집니다. 체크하지 않으면 즉시 반짝입니다."
L["ANIM_ICONALPHAFLASH"] = "아이콘: 투명도 반짝임"
L["ANIM_ICONALPHAFLASH_DESC"] = [=[불투명도를 변경하면서 아이콘을 반짝입니다.

불투명도는 아이콘의 보통 불투명도와 애니메이션에 설정된 불투명도 간에 변경됩니다.]=]
L["ANIM_ICONBORDER"] = "아이콘: 테두리"
L["ANIM_ICONBORDER_DESC"] = "아이콘 위에 색상화된 테두리를 입힙니다."
L["ANIM_ICONCLEAR"] = "아이콘: 스톱 애니메이션"
L["ANIM_ICONCLEAR_DESC"] = "현재 아이콘 위에 진행중인 모든 애니메이션을 멈춥니다."
L["ANIM_ICONFADE"] = "아이콘: 서서히 표시/숨기기"
L["ANIM_ICONFADE_DESC"] = "선택한 이벤트가 발생하면 불투명도를 부드럽게 변경합니다."
L["ANIM_ICONFLASH"] = "아이콘: 색상 반짝임"
L["ANIM_ICONFLASH_DESC"] = "아이콘에 색상화된 반짝임을 입힙니다."
L["ANIM_ICONOVERLAYIMG"] = "아이콘: 이미지 입히기"
L["ANIM_ICONOVERLAYIMG_DESC"] = "아이콘 위에 사용자 설정 이미지를 입힙니다."
L["ANIM_ICONSHAKE"] = "아이콘: 흔들기"
L["ANIM_ICONSHAKE_DESC"] = "발생되면 아이콘을 흔듭니다."
L["ANIM_INFINITE"] = "무한 재생"
L["ANIM_INFINITE_DESC"] = "체크하면 같은 형식의 아이콘 위에 다른 애니메이션이 덮어씌워지거나, %q 애니메이션이 재생될 때까지 애니메이션을 재생합니다."
L["ANIM_MAGNITUDE"] = "흔들기 강도"
L["ANIM_MAGNITUDE_DESC"] = "얼마나 심하게 흔들 지 설정합니다."
L["ANIM_PERIOD"] = "반짝임 시간"
L["ANIM_PERIOD_DESC"] = [=[반짝임이 표시될 시간을 설정하세요 - 반짝임이 표시되거나 서서히 나타날 시간.

서서히 나타나거나 반짝이고 싶지 않다면 0으로 설정하세요.]=]
L["ANIM_PIXELS"] = "%s 픽셀"
L["ANIM_SCREENFLASH"] = "화면: 반짝임"
L["ANIM_SCREENFLASH_DESC"] = "화면 위에 색상화된 반짝임을 입힙니다."
L["ANIM_SCREENSHAKE"] = "화면: 흔들기"
L["ANIM_SCREENSHAKE_DESC"] = [=[발생되면 화면 전체를 흔듭니다.

참고: 이 기능은 접속 후 이름표를 활성화 한 적이 없거나 전투 중이 아닐 때만 작동합니다.]=]
L["ANIM_SECONDS"] = "%s초"
L["ANIM_SIZE_ANIM"] = "테두리 외형"
L["ANIM_SIZE_ANIM_DESC"] = "모든 테두리의 크기를 설정합니다."
L["ANIM_SIZEX"] = "이미지 너비"
L["ANIM_SIZEX_DESC"] = "이미지의 너비를 설정합니다."
L["ANIM_SIZEY"] = "이미지 높이"
L["ANIM_SIZEY_DESC"] = "이미지의 높이를 설정합니다."
L["ANIM_TAB"] = "애니메이션"
L["ANIM_TAB_DESC"] = "아이콘이나 화면 전체에 애니메이션 효과를 줍니다."
L["ANIM_TEX"] = "무늬"
L["ANIM_TEX_DESC"] = [=[입혀질 무늬를 선택하세요.

사용하고 싶은 무늬를 가진 주문의 이름 이나 ID를 입력하거나, 'Interface/Icons/spell_nature_healingtouch'같은 무늬의 경로 또는 경로가 'Interface/Icons'라면 'spell_nature_healingtouch'만 입력하세요.

와우 디렉토리 안에 위치한 개인 무늬를 사용할 수 있습니다 (이 입력 영역에 와우 루트 폴더를 기준으로 한 경로와 무늬를 입력하세요), .tga 또는 .blp 포맷이며 2의 제곱 수의 크기를 가져야 합니다 (32, 64, 128, 등등)]=]
L["ANIM_THICKNESS"] = "테두리 두께"
L["ANIM_THICKNESS_DESC"] = "테두리의 두께를 설정합니다."
L["ANN_CHANTOUSE"] = "사용할 채널"
L["ANN_EDITBOX"] = "출력 될 문자"
L["ANN_EDITBOX_DESC"] = "알림이 발생했을 때 출력하고 싶은 문자를 입력하세요."
L["ANN_EDITBOX_WARN"] = "여기에 출력하고 싶은 문자를 입력하세요"
L["ANN_FCT_DESC"] = "블리자드의 %s 기능에 출력합니다. 문자가 출력되려면 인터페이스 설정에 활성화 되어 있어야 합니다."
L["ANN_NOTEXT"] = "<문자 없음>"
L["ANN_SHOWICON"] = "아이콘 무늬 표시"
L["ANN_SHOWICON_DESC"] = "일부 문자 출력부는 문자와 함께 무늬를 함께 표시할 수 있습니다. 기능을 사용하려면 체크하세요."
L["ANN_STICKY"] = "고정"
L["ANN_SUB_CHANNEL"] = "하위 섹션"
L["ANN_TAB"] = "문자"
L["ANN_TAB_DESC"] = "대화 채널, UI 프레임, 또는 다른 애드온에 문자를 출력합니다."
L["ANN_WHISPERTARGET"] = "귓속말 대상"
L["ANN_WHISPERTARGET_DESC"] = [=[귓속말을 보낼 플레이어의 이름을 입력하세요.

일반적인 서버/진영 귓속말 요구 사항이 적용됩니다.]=]
L["ASCENDING"] = "오름차순"
L["ASPECT"] = "상태"
L["AURA"] = "오라"
L["BACK_IE"] = "뒤로"
L["BACK_IE_DESC"] = [=[마지막으로 편집된 아이콘을 불러옵니다

%s |T%s:0|t.]=]
L["Bleeding"] = "출혈"
L["BOTTOM"] = "하단"
L["BOTTOMLEFT"] = "좌측 하단"
L["BOTTOMRIGHT"] = "우측 하단"
L["BUFFCNDT_DESC"] = "첫 주문만 확인합니다, 모든 나머지는 무시합니다."
L["BUFFTOCHECK"] = "확인할 강화 효과"
L["BUFFTOCOMP1"] = "비교할 첫번째 강화 효과"
L["BUFFTOCOMP2"] = "비교할 두번째 강화 효과"
L["BURNING_EMBERS_FRAGMENTS"] = "타오르는 불씨 '조각'"
L["BURNING_EMBERS_FRAGMENTS_DESC"] = [=[하나의 타오르는 불씨는 10개의 조각으로 이루어져 있습니다.

예를 들어 1개의 불씨와 절반의 불씨를 가지고 있다면 15개의 조각을 가지고 있는 것과 같습니다.]=]
L["CACHING"] = [=[TellMeWhen은 게임 내 모든 주문을 저장하고 선별합니다. 와우 패치마다 한번만 완료하면 됩니다. 아래 슬라이더를 사용해 처리 속도를 올리거나 낮출 수 있습니다.

TellMeWhen을 사용하기 위해 이 과정이 완료될 때까지 기다릴 필요는 없습니다. 오직 추천 목록만 주문 캐시의 완성도에 영향을 받습니다.]=]
L["CACHINGSPEED"] = "프레임당 주문:"
L["CASTERFORM"] = "인간형"
L["CENTER"] = "중앙"
L["CHANGELOG"] = "변경 내역"
L["CHANGELOG_DESC"] = "TellMeWhen의 현재와 이전 버전에 만들어진 변경 내역을 표시합니다."
L["CHANGELOG_INFO2"] = [=[TellMeWhen v%s에 오신걸 환영합니다!
<br/><br/>
변경된 사항을 확인한 후에, %s 탭을 클릭하거나 하단의 %s 탭으로 TellMeWhen 설정을 시작하세요.]=]
L["CHANGELOG_LAST_VERSION"] = "이전에 설치된 버전"
L["CHAT_FRAME"] = "대화 창"
L["CHAT_MSG_CHANNEL"] = "대화 채널"
L["CHAT_MSG_CHANNEL_DESC"] = "거래 또는 현재 참여 중인 사용자 채널과 같은 대화 채널로 출력합니다."
L["CHAT_MSG_SMART"] = "똑똑한 채널"
L["CHAT_MSG_SMART_DESC"] = "전장, 공격대, 파티, 또는 일반 대화로 출력합니다 - 적절한 채널로 출력합니다."
L["CHOOSEICON"] = "확인할 아이콘 선택"
L["CHOOSEICON_DESC"] = [=[|cff7fffff클릭|r하여 아이콘/그룹을 선택합니다
|cff7fffff클릭하고 끌어서|r 재정렬합니다. 
|cff7fffff오른쪽 클릭하고 끌어서|r 교체합니다.]=]
L["CHOOSENAME_DIALOG"] = [=[이 아이콘으로 관찰하고자 하는 이름 또는 ID를 입력하세요. 세미콜론(;)으로 항목을 구분지어 여러 개의 항목(이름, ID의 모든 조합)을 추가할 수 있습니다.

하이픈을 사용해 접두사를 붙이면 똑같은 내용을 생략할 수 있습니다, 예. "느려짐; -멍해짐".

주문/아이템/대화 링크를 |cff7fffffShift-클릭|r하거나 주문/아이템을 이 편집박스로 끌어다 놓을 수 있습니다.]=]
L["CHOOSENAME_DIALOG_PETABILITIES"] = "|cFFFF5959소환수 능력|r은 주문ID를 사용해야 합니다."
L["CLEU_"] = "모든 이벤트"
L["CLEU_CAT_AURA"] = "강화 효과/약화 효과"
L["CLEU_CAT_CAST"] = "시전"
L["CLEU_CAT_MISC"] = "기타"
L["CLEU_CAT_SPELL"] = "주문"
L["CLEU_CAT_SWING"] = "근접/원거리 공격"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MASK"] = "조종자 관계"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MINE"] = "조종자 관계: 플레이어 (자신)"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MINE_DESC"] = "자신이 조종하고 있는 유닛인지 확인합니다."
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_OUTSIDER"] = "조종자 관계: 외부인"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_OUTSIDER_DESC"] = "자신과 파티/공격대 중이지 않은 사람이 조종하는 유닛인지 확인합니다."
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_PARTY"] = "조종자 관계: 파티원"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_PARTY_DESC"] = "같은 파티원이 조종하는 유닛인지 확인합니다."
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_RAID"] = "조종자 관계: 공격대원"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_RAID_DESC"] = "같은 공격대에 속한 사람이 조종하는 유닛인지 확인합니다."
L["CLEU_COMBATLOG_OBJECT_CONTROL_MASK"] = "조종자"
L["CLEU_COMBATLOG_OBJECT_CONTROL_NPC"] = "조종자: 서버"
L["CLEU_COMBATLOG_OBJECT_CONTROL_NPC_DESC"] = "그의 소환수와 수호자를 포함한 서버가 조종하는 유닛인지 확인합니다."
L["CLEU_COMBATLOG_OBJECT_CONTROL_PLAYER"] = "조종자: 사람"
L["CLEU_COMBATLOG_OBJECT_CONTROL_PLAYER_DESC"] = "그의 소환수와 수호자를 포함한 사람이 조종하는 유닛인지 확인합니다."
L["CLEU_COMBATLOG_OBJECT_FOCUS"] = "기타: 자신의 주시 대상"
L["CLEU_COMBATLOG_OBJECT_FOCUS_DESC"] = "주시 대상으로 설정된 유닛인지 확인합니다."
L["CLEU_COMBATLOG_OBJECT_MAINASSIST"] = "기타: 지원 전담"
L["CLEU_COMBATLOG_OBJECT_MAINASSIST_DESC"] = "공격대에서 지원 전담으로 지정된 유닛인지 확인합니다."
L["CLEU_COMBATLOG_OBJECT_MAINTANK"] = "기타: 방어 전담"
L["CLEU_COMBATLOG_OBJECT_MAINTANK_DESC"] = "공격대에서 방어 전담으로 지정된 유닛인지 확인합니다."
L["CLEU_COMBATLOG_OBJECT_NONE"] = "기타: 알 수 없는 유닛"
L["CLEU_COMBATLOG_OBJECT_NONE_DESC"] = "와우 클라이언트가 완벽히 알 수 없는 유닛인지 확인하며, 게임 클라이언트에 의해 제공되지 않은 유닛의 이벤트를 제외시킵니다."
L["CLEU_COMBATLOG_OBJECT_REACTION_FRIENDLY"] = "유닛 반응: 우호적"
L["CLEU_COMBATLOG_OBJECT_REACTION_FRIENDLY_DESC"] = "자신과 우호적인 유닛인지 확인합니다."
L["CLEU_COMBATLOG_OBJECT_REACTION_HOSTILE"] = "유닛 반응: 적대적"
L["CLEU_COMBATLOG_OBJECT_REACTION_HOSTILE_DESC"] = "자신과 적대적인 유닛인지 확인합니다."
L["CLEU_COMBATLOG_OBJECT_REACTION_MASK"] = "유닛 반응"
L["CLEU_COMBATLOG_OBJECT_REACTION_NEUTRAL"] = "유닛 반응: 중립"
L["CLEU_COMBATLOG_OBJECT_REACTION_NEUTRAL_DESC"] = "자신과 중립적인 유닛인지 확인합니다."
L["CLEU_COMBATLOG_OBJECT_TARGET"] = "기타: 자신의 대상"
L["CLEU_COMBATLOG_OBJECT_TARGET_DESC"] = "대상 지정 중인 유닛인지 확인합니다."
L["CLEU_COMBATLOG_OBJECT_TYPE_GUARDIAN"] = "유닛 유형: 수호자"
L["CLEU_COMBATLOG_OBJECT_TYPE_GUARDIAN_DESC"] = "수호자 여부를 확인합니다. 수호자는 그의 조종자를 수호하지만 직접적으로 조종할 수 없는 유닛입니다."
L["CLEU_COMBATLOG_OBJECT_TYPE_MASK"] = "유닛 유형"
L["CLEU_COMBATLOG_OBJECT_TYPE_NPC"] = "유닛 유형: NPC"
L["CLEU_COMBATLOG_OBJECT_TYPE_NPC_DESC"] = "비-플레이어 캐릭터 여부를 확인합니다."
L["CLEU_COMBATLOG_OBJECT_TYPE_OBJECT"] = "유닛 유형: 물건"
L["CLEU_COMBATLOG_OBJECT_TYPE_OBJECT_DESC"] = "덫, 낚시찌, 또는 다른 \"유닛 유형\" 범주에 속하지 않는 유닛인지 확인합니다."
L["CLEU_COMBATLOG_OBJECT_TYPE_PET"] = "유닛 유형: 소환수"
L["CLEU_COMBATLOG_OBJECT_TYPE_PET_DESC"] = "소환수 여부를 확인합니다. 소환수는 그의 조종자를 수호하며 직접적으로 조종할 수 있습니다."
L["CLEU_COMBATLOG_OBJECT_TYPE_PLAYER"] = "유닛 유형: 플레이어 캐릭터"
L["CLEU_COMBATLOG_OBJECT_TYPE_PLAYER_DESC"] = "플레이어 캐릭터 여부를 확인합니다."
L["CLEU_CONDITIONS_DESC"] = [=[확인하기 위해서 개별 유닛이 만족해야 할 조건을 설정하세요.

이 조건들은 확인할 유닛을 유닛ID를 이용해서 입력했을 때만 사용 가능합니다 - 이름은 이 조건들과 사용할 수 없습니다.]=]
L["CLEU_CONDITIONS_DEST"] = "대상 조건"
L["CLEU_CONDITIONS_SOURCE"] = "행위자 조건"
L["CLEU_DAMAGE_SHIELD"] = "피해 보호막"
L["CLEU_DAMAGE_SHIELD_DESC"] = "근접 공격자에게 피해를 입히는 주문이나 능력 (%s, %s, 등등, %s|1은;는; 제외)으로 유닛에게 피해를 입혔을 때 발생합니다."
L["CLEU_DAMAGE_SHIELD_MISSED"] = "피해 보호막 적중 실패"
L["CLEU_DAMAGE_SHIELD_MISSED_DESC"] = "근접 공격자에게 피해를 입히는 주문이나 능력 (%s, %s, 등등, %s|1은;는; 제외)으로 유닛에게 피해를 입히지 못했을 때 발생합니다."
L["CLEU_DAMAGE_SPLIT"] = "피해 분배"
L["CLEU_DAMAGE_SPLIT_DESC"] = "피해가 둘 이상의 대상에게 분배되었을 때 발생합니다."
L["CLEU_DESTUNITS"] = "확인할 대상 유닛"
L["CLEU_DESTUNITS_DESC"] = "아이콘이 반응할 대상 유닛을 선택하세요, |cff7fffff또는|r 모든 이벤트 대상에 아이콘이 반응하게 하려면 공란으로 비워두세요."
L["CLEU_DIED"] = "죽음"
L["CLEU_ENCHANT_APPLIED"] = "마법부여 사용"
L["CLEU_ENCHANT_APPLIED_DESC"] = "도적의 독이나 주술사의 주입같은 일시적 무기 마법부여를 포함합니다."
L["CLEU_ENCHANT_REMOVED"] = "마법부여 사라짐"
L["CLEU_ENCHANT_REMOVED_DESC"] = "도적의 독이나 주술사의 주입같은 일시적 무기 마법부여를 포함합니다."
L["CLEU_ENVIRONMENTAL_DAMAGE"] = "환경 피해"
L["CLEU_ENVIRONMENTAL_DAMAGE_DESC"] = "용암, 피로, 호흡 불가, 그리고 낙하 충격을 포함합니다."
L["CLEU_EVENTS"] = "확인할 이벤트"
L["CLEU_EVENTS_ALL"] = "모두"
L["CLEU_EVENTS_DESC"] = "아이콘이 반응할 전투 이벤트를 선택하세요."
L["CLEU_FLAGS_DESC"] = "아이콘 발생시키지 못하도록 특정 유닛을 제외하는 데 사용하는 속성의 목록을 포함합니다. 제외가 확인되고, 유닛이 속성을 가지고 있으면, 아이콘은 유닛이 포함된 이벤트를 처리하지 않습니다."
L["CLEU_FLAGS_DEST"] = "제외"
L["CLEU_FLAGS_SOURCE"] = "제외"
L["CLEU_HEADER"] = "전투 이벤트 필터"
L["CLEU_HEADER_DEST"] = "대상 유닛"
L["CLEU_HEADER_SOURCE"] = "행위자 유닛"
L["CLEU_NOFILTERS"] = "%2$s의 %1$s 아이콘에 정의된 필터가 없습니다. 최소 하나의 필터를 정의하기 전까지 기능하지 않습니다."
L["CLEU_PARTY_KILL"] = "죽임"
L["CLEU_PARTY_KILL_DESC"] = "파티 내 누군가가 무엇인가 처치했을 때 발생합니다."
L["CLEU_RANGE_DAMAGE"] = "원거리 공격 피해"
L["CLEU_RANGE_MISSED"] = "원거리 공격 적중 실패"
L["CLEU_SOURCEUNITS"] = "확인할 행위자 유닛"
L["CLEU_SOURCEUNITS_DESC"] = "아이콘이 반응할 행위자 유닛을 선택하세요, |cff7fffff또는|r 모든 이벤트 행위자에 아이콘이 반응하게 하려면 공란으로 비워두세요."
L["CLEU_SPELL_AURA_APPLIED"] = "효과 적용"
L["CLEU_SPELL_AURA_APPLIED_DOSE"] = "효과 중첩 적용"
L["CLEU_SPELL_AURA_BROKEN"] = "오라 파괴"
L["CLEU_SPELL_AURA_BROKEN_SPELL"] = "주문에 의해 오라 파괴"
L["CLEU_SPELL_AURA_BROKEN_SPELL_DESC"] = [=[일반적으로 군중 제어의 일부 형태인 오라가 주문 피해로 파괴되었을 때 발생합니다.

파괴된 오라는 파괴한 주문 아이콘 별로 선별됩니다; 파괴한 주문은 문자 디스플레이에서 대체자 [Extra]를 사용하여 접근할 수 있습니다.]=]
L["CLEU_SPELL_AURA_REFRESH"] = "오라 지속시간 초기화"
L["CLEU_SPELL_AURA_REMOVED"] = "오라 제거"
L["CLEU_SPELL_AURA_REMOVED_DOSE"] = "오라 중첩 감소"
L["CLEU_SPELL_CAST_FAILED"] = "주문 시전 실패"
L["CLEU_SPELL_CAST_START"] = "주문 시전 시작"
L["CLEU_SPELL_CAST_START_DESC"] = [=[주문 시전이 시작될 때 발생합니다.

참고: 부정 사용을 막기위해, 블리자드는 이 이벤트에서 대상 유닛을 제외시켰습니다, 따라서 대상 유닛으로 필터링할 수 없습니다.]=]
L["CLEU_SPELL_CAST_SUCCESS"] = "주문 시전 성공"
L["CLEU_SPELL_CAST_SUCCESS_DESC"] = "주문을 성공적으로 시전했을 때 발생합니다."
L["CLEU_SPELL_CREATE"] = "만듦"
L["CLEU_SPELL_CREATE_DESC"] = "사냥꾼의 덫이나 마법사의 포탈같은 개체가 생성되면 발생합니다."
L["CLEU_SPELL_DAMAGE"] = "주문 피해"
L["CLEU_SPELL_DAMAGE_CRIT"] = "주문 극대화"
L["CLEU_SPELL_DAMAGE_CRIT_DESC"] = "주문이 극대화 효과를 발휘했을 때 발생합니다. %q 이벤트와 동시에 발생합니다."
L["CLEU_SPELL_DAMAGE_DESC"] = "주문이 피해를 입혔을 때 발생합니다."
L["CLEU_SPELL_DAMAGE_NONCRIT"] = "주문 일반"
L["CLEU_SPELL_DAMAGE_NONCRIT_DESC"] = "주문이 일반 피해를 주었을 때 발생합니다. %q 이벤트와 동시에 발생합니다."
L["CLEU_SPELL_DISPEL"] = "무효화"
L["CLEU_SPELL_DISPEL_DESC"] = [=[오라가 무효화되면 발생합니다.

아이콘은 무효화된 오라에 의해 필터링될 수 있습니다. 문자 디스플레이에서 대체자 [Extra]를 사용하여 주문을 무효화한 주문에 접근할 수 있습니다.]=]
L["CLEU_SPELL_DISPEL_FAILED"] = "무효화 실패"
L["CLEU_SPELL_DISPEL_FAILED_DESC"] = [=[오라가 무효화되는데 실패하면 발생합니다.

아이콘은 무효화를 시도한 오라에 의해 필터링될 수 있습니다. 문자 디스플레이에서 대체자 [Extra]를 사용하여 주문을 무효화하려고 시도한 주문에 접근할 수 있습니다.]=]
L["CLEU_SPELL_DRAIN"] = "자원 소진"
L["CLEU_SPELL_DRAIN_DESC"] = "자원 (생명력/마나/분노/기력/등등)이 유닛에게서 사라지면 발생합니다."
L["CLEU_SPELL_ENERGIZE"] = "자원 얻음"
L["CLEU_SPELL_ENERGIZE_DESC"] = "유닛이 자원 (생명력/마나/분노/기력/등등)을 획득하면 발생합니다."
L["CLEU_SPELL_EXTRA_ATTACKS"] = "추가 공격 획득"
L["CLEU_SPELL_EXTRA_ATTACKS_DESC"] = "발동 효과로 추가 근접 공격 기회를 얻으면 발생합니다."
L["CLEU_SPELL_HEAL"] = "생명력 회복"
L["CLEU_SPELL_INSTAKILL"] = "죽임"
L["CLEU_SPELL_INTERRUPT"] = "방해 - 방해된 주문"
L["CLEU_SPELL_INTERRUPT_DESC"] = [=[주문 시전이 방해되면 발생합니다.

아이콘은 방해된 주문에 의해 필터링될 수 있습니다. 문자 디스플레이에서 대체자 [Extra]를 사용하여 주문을 방해한 주문에 접근할 수 있습니다.

두개의 방해 이벤트엔 차이가 있다는 걸 참고하세요 - 주문이 방해되면 둘 다 발생하지만, 연관된 주문을 각각 다르게 필터링합니다.]=]
L["CLEU_SPELL_INTERRUPT_SPELL"] = "방해 - 사용한 방해 주문"
L["CLEU_SPELL_INTERRUPT_SPELL_DESC"] = [=[주문 시전이 방해되면 발생합니다.

아이콘은 방해시킨 주문에 의해 필터링될 수 있습니다. 문자 디스플레이에서 대체자 [Extra]를 사용하여 방해된 주문에 접근할 수 있습니다.

두개의 방해 이벤트엔 차이가 있다는 걸 참고하세요 - 주문이 방해되면 둘 다 발생하지만, 연관된 주문을 각각 다르게 필터링합니다.]=]
L["CLEU_SPELL_LEECH"] = "자원 소진"
L["CLEU_SPELL_LEECH_DESC"] = "자원 (생명력/마나/분노/기력/등등)이 한 유닛에게서 사라지고 동시에 다른 유닛에게 주어질 때 발생합니다."
L["CLEU_SPELL_MISSED"] = "주문 적중 실패"
L["CLEU_SPELL_PERIODIC_DAMAGE"] = "주기적인 피해"
L["CLEU_SPELL_PERIODIC_DRAIN"] = "주기적인 자원 소진"
L["CLEU_SPELL_PERIODIC_ENERGIZE"] = "주기적인 자원 얻음"
L["CLEU_SPELL_PERIODIC_HEAL"] = "주기적인 생명력 회복"
L["CLEU_SPELL_PERIODIC_LEECH"] = "주기적인 소진"
L["CLEU_SPELL_PERIODIC_MISSED"] = "주기적인 적중 실패"
L["CLEU_SPELL_REFLECT"] = "주문 반사"
L["CLEU_SPELL_REFLECT_DESC"] = [=[주문을 시전자에게 반사하면 발생합니다.

시전자 유닛은 반사한 유닛이고, 대상 유닛은 반사당한 유닛입니다]=]
L["CLEU_SPELL_RESURRECT"] = "부활"
L["CLEU_SPELL_RESURRECT_DESC"] = "유닛이 죽음으로부터 부활하면 발생합니다."
L["CLEU_SPELL_STOLEN"] = "오라 훔침"
L["CLEU_SPELL_STOLEN_DESC"] = [=[아마 %s에 의해 강화 효과가 훔쳐졌을 때 발생합니다.

아이콘은 훔쳐진 주문에 따라 필터링될 수 있습니다.]=]
L["CLEU_SPELL_SUMMON"] = "소환 주문"
L["CLEU_SPELL_SUMMON_DESC"] = "소환수나 토템같은 NPC가 소환되거나 생성되면 발생합니다."
L["CLEU_SWING_DAMAGE"] = "자동 공격 피해"
L["CLEU_SWING_MISSED"] = "자동 공격 적중 실패"
L["CLEU_TIMER"] = "이벤트에 설정할 타이머"
L["CLEU_TIMER_DESC"] = [=[이벤트 발생 시 아이콘에 설정되는 초 단위의 타이머 지속시간입니다.

필터로 설정한 주문을 사용하여 이벤트를 처리할 때마다 %q 입력상자에 "주문: 지속시간" 구문을 사용하여 지속시간을 설정할 수도 있습니다.

지속시간이 없는 주문이거나, 주문 필터 세트가 없으면(입력상자가 비었을 경우), 이 지속시간이 사용됩니다.]=]
L["CLEU_UNIT_DESTROYED"] = "유닛 파괴됨"
L["CLEU_UNIT_DESTROYED_DESC"] = "토템같은 유닛이 파괴되면 발생합니다."
L["CLEU_UNIT_DIED"] = "유닛 죽음"
L["CLEU_WHOLECATEGORYEXCLUDED"] = [=[%q 범주의 모든 부분을 제외했으므로, 이 아이콘은 어떤 이벤트도 처리하지 않습니다.

적절한 기능을 위해 최소 하나는 체크해제하세요.]=]
L["CLICK_TO_EDIT"] = "|cff7fffff클릭|r하여 편집합니다."
L["CMD_CHANGELOG"] = "changelog"
L["CMD_DISABLE"] = "disable"
L["CMD_ENABLE"] = "enable"
L["CMD_OPTIONS"] = "options"
L["CMD_PROFILE"] = "profile"
L["CMD_PROFILE_INVALIDPROFILE"] = "%q|1이라는;라는; 이름의 프로필이 없습니다!"
L["CMD_PROFILE_INVALIDPROFILE_SPACES"] = "팁: 프로필 이름에 공백이 있으면, 주위에 따옴표를 삽입하세요."
L["CMD_TOGGLE"] = "toggle"
L["CNDT_DEPRECATED_DESC"] = "%s 조건이 작동하지 않습니다. 아마도 게임 작동 구조의 변경 때문입니다. 조건을 제거하거나 다른 조건으로 변경하세요."
L["CNDT_MULTIPLEVALID"] = "세미콜론으로 여러 개의 이름/ID를 구분지어 입력할 수 있습니다."
L["CNDT_ONLYFIRST"] = "첫 주문/아이템만 확인합니다 - 세미콜론으로 구분된 목록은 이 조건 유형에 맞지 않습니다."
L["CNDT_RANGE"] = "유닛 거리"
L["CNDT_RANGE_DESC"] = [=[LibRangeCheck-2.0을 사용하여 유닛의 대략적인 거리를 확인합니다.
유닛이 존재하지 않으면 조건은 false 값을 나타냅니다.]=]
L["CNDT_RANGE_IMPRECISE"] = "%d미터. (|cffff1300대략적으로|r)"
L["CNDT_RANGE_PRECISE"] = "%d미터. (|cff00c322정확하게|r)"
L["CNDT_SLIDER_DESC_CLICKSWAP_TOMANUAL"] = "|cff7fffff오른쪽-클릭|r하여 수동 입력으로 전환합니다."
L["CNDT_SLIDER_DESC_CLICKSWAP_TOSLIDER"] = "|cff7fffff오른쪽-클릭|r하여 슬라이더 입력으로 전환합니다."
L["CNDT_SLIDER_DESC_CLICKSWAP_TOSLIDER_DISALLOWED"] = "%s 이상의 값은 수동 입력만 허용됩니다 (블리자드의 슬라이더는 큰 값에서 제대로 작동하지 않을 수 있습니다.)"
L["CNDT_TOTEMNAME"] = "토템 이름"
L["CNDT_TOTEMNAME_DESC"] = [=[선택한 유형의 모든 토템을 추적하려면 공란으로 비워두세요.

토템 이름을 입력하거나, 세미콜론으로 구분한 이름의 목록을 입력하면 특정 토템만 확인합니다.]=]
L["CNDT_UNKNOWN_DESC"] = "당신의 설정에 식별자 %s|1을;를; 사용한 조건이 있지만, 그런 조건은 발견할 수 없었습니다. 아마도 구버전의 TMW를 사용 중이거나, 이 조건이 제거되었을 수 있습니다."
L["CNDTCAT_ARCHFRAGS"] = "고고학 조각"
L["CNDTCAT_ATTRIBUTES_PLAYER"] = "플레이어 속성"
L["CNDTCAT_ATTRIBUTES_UNIT"] = "유닛 속성"
L["CNDTCAT_BOSSMODS"] = "우두머리 모듈"
L["CNDTCAT_BUFFSDEBUFFS"] = "강화 효과/약화 효과"
L["CNDTCAT_CURRENCIES"] = "화폐"
L["CNDTCAT_FREQUENTLYUSED"] = "지속적으로 사용"
L["CNDTCAT_LOCATION"] = "그룹과 위치"
L["CNDTCAT_MISC"] = "기타"
L["CNDTCAT_RESOURCES"] = "자원"
L["CNDTCAT_SPELLSABILITIES"] = "주문/아이템"
L["CNDTCAT_STATS"] = "전투 능력치"
L["CNDTCAT_TALENTS"] = "직업과 특성"
L["CODESNIPPET_ADD2"] = "새로운 %s 코드 조각"
L["CODESNIPPET_ADD2_DESC"] = "|cff7fffff클릭|r하여 새로운 %s 코드 조각을 추가합니다."
L["CODESNIPPET_AUTORUN"] = "접속 시 자동실행"
L["CODESNIPPET_AUTORUN_DESC"] = "활성화하면 이 코드 조각은 TMW_INITIALIZE가 발생하면 (PLAYER_LOGIN 중 발생하지만, 모든 아이콘과 그룹은 그 이전에 생성됩니다) 실행됩니다."
L["CODESNIPPET_CODE"] = "실행할 Lua 코드"
L["CODESNIPPET_DELETE"] = "코드 조각 삭제"
L["CODESNIPPET_DELETE_CONFIRM"] = "%q 코드 조각을 정말로 삭제할까요?"
L["CODESNIPPET_EDIT_DESC"] = "|cff7fffff클릭|r하여 이 코드 조각을 편집합니다."
L["CODESNIPPET_GLOBAL"] = "공통 코드 조각"
L["CODESNIPPET_ORDER"] = "실행 순서"
L["CODESNIPPET_ORDER_DESC"] = [=[이 코드 조각이 다른 코드 조각과 연관되어 실행될 순서를 설정합니다.

%s|1과;와; %s|1은;는; 실행될 때 이 값에 기반하여 함께 섞입니다.

십진수가 유효합니다. 두 코드 조각이 같은 순서를 공유하면 일관된 순서는 보장되지 않습니다.]=]
L["CODESNIPPET_PROFILE"] = "프로필 코드 조각"
L["CODESNIPPET_RENAME"] = "코드 조각 이름"
L["CODESNIPPET_RENAME_DESC"] = [=[자신이 알아 보기 쉽게 이 코드 조각의 이름을 선택하세요.

이름이 고유할 필요는 없습니다.]=]
L["CODESNIPPET_RUNAGAIN"] = "코드 조각 다시 실행"
L["CODESNIPPET_RUNAGAIN_DESC"] = [=[이 코드 조각은 이번 세션에서 이미 한번 실행되었습니다.

|cff7fffff클릭|r하여 다시 실행합니다.]=]
L["CODESNIPPET_RUNNOW"] = "지금 코드 조각 실행"
L["CODESNIPPET_RUNNOW_DESC"] = "|cff7fffff클릭|r하여 이 코드 조각의 코드를 실행합니다."
L["CODESNIPPETS"] = "Lua 코드 조각"
L["CODESNIPPETS_DEFAULTNAME"] = "새로운 코드 조각"
L["CODESNIPPETS_DESC"] = [=[이 기능은 TellMeWhen이 초기 구동될 때 실행될 Lua 코드의 덩어리를 작성할 수 있게 해줍니다.

Lua에 경험이 있는 사람들을 위한 고급 기능입니다 (또는 다른 TellMeWhen 사용자가 전달한 코드 조각의 사용자).

Lua 환경에서 사용할 사용자 설정 함수의 작성을 포함합니다.

코드 조각은 프로필 별로 또는 공용으로 정의될 수 있습니다 (공용 코드 조각은 모든 프로필에서 실행됩니다).

당신의 코드에 TellMeWhen 아이콘을 사용하려면, 아이콘을 |cff7fffffShift-클릭|r하세요.]=]
L["CODESNIPPETS_DESC_SHORT"] = "TellMeWhen이 초기 구동될 때 실행될 Lua 코드의 덩어리를 작성합니다."
L["CODESNIPPETS_IMPORT_GLOBAL"] = "새로운 공통 코드 조각"
L["CODESNIPPETS_IMPORT_GLOBAL_DESC"] = "공통 코드 조각으로 코드 조각을 가져옵니다."
L["CODESNIPPETS_IMPORT_PROFILE"] = "새로운 프로필 코드 조각"
L["CODESNIPPETS_IMPORT_PROFILE_DESC"] = "프로필 관련 코드 조각으로 코드 조각을 가져옵니다."
L["CODESNIPPETS_TITLE"] = "Lua 코드 조각"
L["CODETOEXE"] = "실행할 코드"
L["COLOR_MSQ_COLOR"] = "Masque 테두리 색상 입히기"
L["COLOR_MSQ_COLOR_DESC"] = "체크하면 Masque 스킨의 테두리에 색상을 입힙니다 (사용 중인 스킨에 테두리가 있으면)."
L["COLOR_MSQ_ONLY"] = "Masque 테두리만 색상입히기"
L["COLOR_MSQ_ONLY_DESC"] = "체크하면 Masque 스킨의 테두리만 색상을 입힙니다 (사용 중인 스킨에 테두리가 있으면). 아이콘은 색상을 입히지 않습니다"
L["COLOR_OVERRIDE_GLOBAL"] = "공통 색상 강제 적용"
L["COLOR_OVERRIDE_GLOBAL_DESC"] = "공통으로 정의된 색상을 독립적으로 설정하려면 체크하세요."
L["COLOR_OVERRIDE_GROUP"] = "그룹 색상 강제 적용"
L["COLOR_OVERRIDE_GROUP_DESC"] = "아이콘의 그룹 별로 색상을 독립적으로 설정하려면 체크하세요."
L["COLOR_USECLASS"] = "직업 색상 사용"
L["COLOR_USECLASS_DESC"] = "바에 해당되는 유닛의 직업 색상을 입히려면 체크하세요."
L["COLORPICKER_BRIGHTNESS"] = "밝기"
L["COLORPICKER_BRIGHTNESS_DESC"] = "색상의 밝기를 설정합니다 (종종 값이라고 부릅니다)."
L["COLORPICKER_DESATURATE"] = "흑백"
L["COLORPICKER_DESATURATE_DESC"] = "색상을 적용하기 전에 무늬를 흑백화합니다, 색칠하지 않고 무늬에 색상을 다시 입힐 수 있습니다."
L["COLORPICKER_HUE"] = "색조"
L["COLORPICKER_HUE_DESC"] = "색상의 색조를 설정합니다."
L["COLORPICKER_ICON"] = "미리보기"
L["COLORPICKER_OPACITY"] = "불투명도"
L["COLORPICKER_OPACITY_DESC"] = "색상의 불투명도를 설정합니다 (종종 투명도라고 부릅니다)."
L["COLORPICKER_RECENT"] = "최근 사용한 색상"
L["COLORPICKER_RECENT_DESC"] = [=[|cff7fffff클릭|r하여 이 색상을 불러옵니다.
|cff7fffff오른쪽-클릭|r하여 이 목록에서 제거합니다.]=]
L["COLORPICKER_SATURATION"] = "채도"
L["COLORPICKER_SATURATION_DESC"] = "색상의 채도를 설정합니다."
L["COLORPICKER_STRING"] = "16진 문자열"
L["COLORPICKER_STRING_DESC"] = "현재 색상을 (A)RGB 16진 표현으로 설정하거나 가져옵니다."
L["COLORPICKER_SWATCH"] = "색상"
L["COMPARISON"] = "비교"
L["CONDITION_COUNTER"] = "확인할 카운터"
L["CONDITION_COUNTER_EB_DESC"] = "확인하고 싶은 카운터의 이름을 입력하세요."
L["CONDITION_QUESTCOMPLETE"] = "퀘스트 완료"
L["CONDITION_QUESTCOMPLETE_DESC"] = "퀘스트 완료 여부를 확인합니다."
L["CONDITION_QUESTCOMPLETE_EB_DESC"] = [=[확인하고 싶은 퀘스트ID를 입력하세요.

퀘스트ID는 Wowhead같은 데이터베이스 사이트에서 퀘스트를 볼 때 URL에서 확인할 수 있습니다.

예. http://www.wowhead.com/quest=28716/heros-call-twilight-highlands에서 퀘스트ID는 28716 입니다]=]
L["CONDITION_TIMEOFDAY"] = "시간 확인"
L["CONDITION_TIMEOFDAY_DESC"] = [=[현재 시간을 확인하는 조건입니다.

자신의 지역 시간을 확인하며, 컴퓨터의 시계에 따릅니다. 서버 시간을 확인하지 않습니다.]=]
L["CONDITION_TIMER"] = "확인할 타이머"
L["CONDITION_TIMER_EB_DESC"] = "확인하고 싶은 타이머의 이름을 입력하세요."
L["CONDITION_TIMERS_FAIL_DESC"] = "조건이 실패할 때 아이콘에 설정할 타이머의 지속시간"
L["CONDITION_TIMERS_SUCCEED_DESC"] = "조건이 만족했을 때 아이콘에 설정할 타이머의 지속시간"
L["CONDITION_WEEKDAY"] = "주일"
L["CONDITION_WEEKDAY_DESC"] = [=[현재 주일을 확인하는 조건입니다.

자신의 지역 시간을 확인하며, 컴퓨터의 시계에 따릅니다. 서버 시간을 확인하지 않습니다.]=]
L["CONDITIONALPHA_METAICON"] = "실패한 조건"
L["CONDITIONALPHA_METAICON_DESC"] = [=[이 불투명도는 조건이 실패하면 사용됩니다.

다른 %s 설정에 의해 아이콘이 이미 숨겨져 있다면 이 설정은 무시됩니다.

조건은 %q 탭에서 설정할 수 있습니다.]=]
L["CONDITIONPANEL_ABSOLUTE"] = "현재"
L["CONDITIONPANEL_ADD"] = "조건 추가"
L["CONDITIONPANEL_ADD2"] = "클릭하여 조건을 추가합니다"
L["CONDITIONPANEL_ALIVE"] = "유닛 생존"
L["CONDITIONPANEL_ALIVE_DESC"] = "지정된 유닛이 살아있으면 조건을 만족합니다."
L["CONDITIONPANEL_ALTPOWER"] = "보조 자원"
L["CONDITIONPANEL_ALTPOWER_DESC"] = "여러 퀘스트와 우두머리 전투에서 사용하는 자원입니다."
L["CONDITIONPANEL_AND"] = "And"
L["CONDITIONPANEL_ANDOR"] = "And / Or"
L["CONDITIONPANEL_ANDOR_DESC"] = "|cff7fffff클릭|r하여 논리 연산자 AND 와 OR을 전환합니다"
L["CONDITIONPANEL_AUTOCAST"] = "소환수 주문 자동시전"
L["CONDITIONPANEL_AUTOCAST_DESC"] = "특정 소환수 주문이 자동시전인지 확인합니다."
L["CONDITIONPANEL_BIGWIGS_ENGAGED"] = "Big Wigs - 우두머리 교전 중"
L["CONDITIONPANEL_BIGWIGS_ENGAGED_DESC"] = [=[Big Wigs에 따라서 우두머리와 교전 중인지 확인합니다.

"확인할 공격대 전투"에 공격대 전투의 전체 이름이나 부분 이름을 입력하세요.]=]
L["CONDITIONPANEL_BIGWIGS_TIMER"] = "Big Wigs - 타이머"
L["CONDITIONPANEL_BIGWIGS_TIMER_DESC"] = [=[Big Wigs 우두머리 모듈 타이머의 지속시간을 확인합니다.

"확인할 타이머"에 타이머의 전체 이름이나 부분 이름을 입력하세요.]=]
L["CONDITIONPANEL_BITFLAGS_ALWAYS"] = "항상 True"
L["CONDITIONPANEL_BITFLAGS_CHECK"] = "선택한 항목 무시"
L["CONDITIONPANEL_BITFLAGS_CHECK_DESC"] = [=[이 조건을 확인하는데 사용되는 논리를 반대로 전환하려면 체크하세요.

기본값으로, 선택한 옵션 중 하나라도 true 값이면 이 조건은 충족됩니다.

이 설정을 체크하면, 선택한 모든 옵션이 false 값일 때 조건이 충족됩니다.]=]
L["CONDITIONPANEL_BITFLAGS_CHOOSECLASS"] = "직업 선택..."
L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_CONTINENT"] = "대륙 선택..."
L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_RAIDICON"] = "아이콘 선택..."
L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_TYPES"] = "유형 선택..."
L["CONDITIONPANEL_BITFLAGS_CHOOSERACE"] = "종족 선택..."
L["CONDITIONPANEL_BITFLAGS_NEVER"] = "없음 - 항상 False"
L["CONDITIONPANEL_BITFLAGS_NOT"] = "Not"
L["CONDITIONPANEL_BITFLAGS_SELECTED"] = "|cff7fffff선택|r:"
L["CONDITIONPANEL_BLIZZEQUIPSET"] = "장비 구성 착용"
L["CONDITIONPANEL_BLIZZEQUIPSET_DESC"] = "특정 블리자드 장비 관리 구성을 착용 중인지 확인합니다."
L["CONDITIONPANEL_BLIZZEQUIPSET_INPUT"] = "장비 구성 이름"
L["CONDITIONPANEL_BLIZZEQUIPSET_INPUT_DESC"] = [=[확인하고 싶은 블리자드 장비 구성의 이름을 입력하세요.

오직 하나의 장비 구성만 입력할 수 있으며, |cFFFF5959대/소문자를 구분|r합니다]=]
L["CONDITIONPANEL_CASTCOUNT"] = "주문 시전 횟수"
L["CONDITIONPANEL_CASTCOUNT_DESC"] = "유닛이 특정 주문을 시전한 횟수를 확인합니다."
L["CONDITIONPANEL_CASTTOMATCH"] = "일치시킬 주문"
L["CONDITIONPANEL_CASTTOMATCH_DESC"] = [=[주문 시전이 정확하게 일치한 경우에만 조건이 만족되도록 하려면 여기에 주문 이름을 입력하세요.

모든 주문 시전/정신 집중을 확인하려면 공란으로 비워두세요.]=]
L["CONDITIONPANEL_CLASS"] = "유닛 직업"
L["CONDITIONPANEL_CLASSIFICATION"] = "유닛 등급"
L["CONDITIONPANEL_CLASSIFICATION_DESC"] = "유닛의 희귀/정예/야외 우두머리 상태를 확인합니다."
L["CONDITIONPANEL_COMBAT"] = "전투 중 유닛"
L["CONDITIONPANEL_COMBO"] = "연계 점수"
L["CONDITIONPANEL_COUNTER_DESC"] = "\"카운터\" 알림 처리기가 설정하고 수정한 카운터의 값을 확인합니다"
L["CONDITIONPANEL_CREATURETYPE"] = "유닛 생명체 유형"
L["CONDITIONPANEL_CREATURETYPE_DESC"] = [=[세미콜론(;)으로 구분지어 여러 개의 생명체 유형을 입력할 수 있습니다.

생명체 유형은 생명체의 툴팁에 나타나는 대로 정확하게 입력해야 합니다.

유형이 일치하면 조건이 만족됩니다.]=]
L["CONDITIONPANEL_CREATURETYPE_LABEL"] = "생명체 유형"
L["CONDITIONPANEL_DBM_ENGAGED"] = "Deadly Boss Mods - 우두머리 교전 중"
L["CONDITIONPANEL_DBM_ENGAGED_DESC"] = [=[Deadly Boss Mods에 따라서 우두머리와 교전 중인지 확인합니다.

"확인할 공격대 전투"에 공격대 전투의 전체 이름이나 부분 이름을 입력하세요.]=]
L["CONDITIONPANEL_DBM_TIMER"] = "Deadly Boss Mods - 타이머"
L["CONDITIONPANEL_DBM_TIMER_DESC"] = [=[Deadly Boss Mods 타이머의 지속시간을 확인합니다.

"확인할 타이머"에 타이머의 전체 이름이나 부분 이름을 입력하세요.]=]
L["CONDITIONPANEL_DEFAULT"] = "유형 선택..."
L["CONDITIONPANEL_ECLIPSE_DESC"] = "식은 -100(월식)에서 100(일식)의 범위를 갖습니다. 80의 월력 값으로 작동하는 아이콘을 원한다면 -80을 입력하십시오."
L["CONDITIONPANEL_EQUALS"] = "같음"
L["CONDITIONPANEL_EXISTS"] = "유닛 존재"
L["CONDITIONPANEL_GREATER"] = "보다 큼"
L["CONDITIONPANEL_GREATEREQUAL"] = "보다 크거나/같음"
L["CONDITIONPANEL_GROUPSIZE"] = "인스턴스 규모"
L["CONDITIONPANEL_GROUPSIZE_DESC"] = [=[현재 인스턴스에 맞춰진 플레이어의 숫자를 확인합니다.

여기에는 현재 탄력적 공격대도 포함됩니다.]=]
L["CONDITIONPANEL_GROUPTYPE"] = "그룹 유형"
L["CONDITIONPANEL_GROUPTYPE_DESC"] = "당신이 속한 파티의 유형을 확인합니다 (솔로, 파티, 또는 공격대)."
L["CONDITIONPANEL_ICON"] = "아이콘 표시됨"
L["CONDITIONPANEL_ICON_DESC"] = [=[지정한 아이콘의 표시 여부를 확인하는 조건입니다.

확인 중인 아이콘을 표시하고 싶지 않다면, 해당 아이콘의 아이콘 편집기에서 %q|1을;를; 확인하세요.

조건이 숨겨짐으로 설정된 경우에도 아이콘을 확인하려면 확인 중인 아이콘 그룹이 표시되어야만 합니다.]=]
L["CONDITIONPANEL_ICON_HIDDEN"] = "숨겨짐"
L["CONDITIONPANEL_ICON_SHOWN"] = "표시됨"
L["CONDITIONPANEL_ICONHIDDENTIME"] = "아이콘 숨겨짐 시간"
L["CONDITIONPANEL_ICONHIDDENTIME_DESC"] = [=[지정한 아이콘이 얼마나 오래 숨겨졌는지 확인하는 조건입니다.

확인 중인 아이콘을 표시하고 싶지 않다면, 해당 아이콘의 아이콘 편집기에서 %q|1을;를; 확인하세요.

아이콘을 확인하려면 확인 중인 아이콘 그룹이 표시되어야만 합니다.]=]
L["CONDITIONPANEL_ICONSHOWNTIME"] = "아이콘 표시됨 시간"
L["CONDITIONPANEL_ICONSHOWNTIME_DESC"] = [=[지정한 아이콘이 얼마나 오래 표시되었는지 확인하는 조건입니다.

확인 중인 아이콘을 표시하고 싶지 않다면, 해당 아이콘의 아이콘 편집기에서 %q|1을;를; 확인하세요.

아이콘을 확인하려면 확인 중인 아이콘 그룹이 표시되어야만 합니다.]=]
L["CONDITIONPANEL_INPETBATTLE"] = "애완동물 대전 중"
L["CONDITIONPANEL_INSTANCETYPE"] = "인스턴스 유형"
L["CONDITIONPANEL_INSTANCETYPE_DESC"] = "모든 던전이나 공격대의 난이도 설정을 포함하여, 당신이 속해 있는 인스턴스의 유형을 확인합니다."
L["CONDITIONPANEL_INSTANCETYPE_LEGACY"] = "%s (낭만)"
L["CONDITIONPANEL_INSTANCETYPE_NONE"] = "외부"
L["CONDITIONPANEL_INTERRUPTIBLE"] = "방해 가능"
L["CONDITIONPANEL_ITEMRANGE"] = "유닛의 사정 거리 내 아이템"
L["CONDITIONPANEL_LASTCAST"] = "마지막으로 사용한 기술"
L["CONDITIONPANEL_LASTCAST_ISNTSPELL"] = "불일치"
L["CONDITIONPANEL_LASTCAST_ISSPELL"] = "일치"
L["CONDITIONPANEL_LESS"] = "보다 작음"
L["CONDITIONPANEL_LESSEQUAL"] = "보다 작거나/같음"
L["CONDITIONPANEL_LEVEL"] = "유닛 레벨"
L["CONDITIONPANEL_LOC_CONTINENT"] = "대륙"
L["CONDITIONPANEL_LOC_SUBZONE"] = "하위 지역"
L["CONDITIONPANEL_LOC_SUBZONE_BOXDESC"] = "확인하고 싶은 하위 지역을 입력하세요. 세미콜론으로 구분하여 여러 개의 하위 지역을 입력할 수 있습니다."
L["CONDITIONPANEL_LOC_SUBZONE_DESC"] = "자신의 현재 하위 지역을 확인합니다. 때때로 하위 지역에 있지 않기도 하다는 걸 참고하세요."
L["CONDITIONPANEL_LOC_SUBZONE_LABEL"] = "확인할 하위 지역 입력"
L["CONDITIONPANEL_LOC_ZONE"] = "지역"
L["CONDITIONPANEL_LOC_ZONE_DESC"] = "확인하고 싶은 지역을 입력하세요. 세미콜론으로 구분하여 여러 개의 지역을 입력할 수 있습니다."
L["CONDITIONPANEL_LOC_ZONE_LABEL"] = "확인할 지역 입력"
L["CONDITIONPANEL_MANAUSABLE"] = "사용 가능 주문 (마나/기력/기타)"
L["CONDITIONPANEL_MANAUSABLE_DESC"] = [=[주 자원 (마나/기력/분노/집중/룬마력/등등)을 얼마나 가지고 있는 지에 따라 주문이 사용 가능한 지 확인합니다.

부 자원 (룬/신성한 힘/기/등등)에 따른 사용 가능성을 확인하지 않습니다.]=]
L["CONDITIONPANEL_MAX"] = "최대"
L["CONDITIONPANEL_MOUNTED"] = "탈것 탑승 중"
L["CONDITIONPANEL_NAME"] = "유닛 이름"
L["CONDITIONPANEL_NAMETOMATCH"] = "일치시킬 이름"
L["CONDITIONPANEL_NAMETOOLTIP"] = "세미콜론(;)으로 구분하여 여러 개의 이름을 입력할 수 있습니다. 이름이 일치하면 조건이 만족됩니다."
L["CONDITIONPANEL_NOTEQUAL"] = "같지 않음"
L["CONDITIONPANEL_NPCID"] = "유닛 NPC ID"
L["CONDITIONPANEL_NPCID_DESC"] = [=[유닛이 특정 NPC ID인지 확인합니다.

NPC ID는 NPC의 Wowhead 페이지 (예. http://www.wowhead.com/npc=62943) URL에서 찾을 수 있는 숫자입니다.

NPC ID가 없는 플레이어와 다른 유닛은 이 조건에서 0의 ID를 갖는 것으로 취급됩니다.]=]
L["CONDITIONPANEL_NPCIDTOMATCH"] = "일치시킬 ID"
L["CONDITIONPANEL_NPCIDTOOLTIP"] = "세미콜론(;)으로 구분하여 여러 개의 NPC ID를 입력할 수 있습니다. ID가 일치하면 조건이 만족됩니다."
L["CONDITIONPANEL_OLD"] = "<|cffff1300구|r>"
L["CONDITIONPANEL_OLD_DESC"] = "<|cffff1300구|r> - 사용 가능한 이 조건의 최신/개선 버전이 있습니다."
L["CONDITIONPANEL_OPERATOR"] = "연산자"
L["CONDITIONPANEL_OR"] = "또는"
L["CONDITIONPANEL_OVERLAYED"] = "주문 활성화 강조"
L["CONDITIONPANEL_OVERLAYED_DESC"] = "주어진 주문이 활성화 경보 효과를 갖고 있는지 확인합니다 (행동 단축바에 표시되는 밝은 노란색 테두리)"
L["CONDITIONPANEL_OVERRBAR"] = "행동 단축바 강제 적용"
L["CONDITIONPANEL_OVERRBAR_DESC"] = "주 행동 단축바를 강제 적용하는 몇몇 효과를 가지고 있는지 확인합니다. 애완동물 대전은 포함하지 않습니다."
L["CONDITIONPANEL_PERCENT"] = "백분율"
L["CONDITIONPANEL_PERCENTOFCURHP"] = "현재 생명력의 백분율"
L["CONDITIONPANEL_PERCENTOFMAXHP"] = "최대 생명력의 백분율"
L["CONDITIONPANEL_PETMODE"] = "소환수 공격 모드"
L["CONDITIONPANEL_PETMODE_DESC"] = "현재 소환수의 공격 모드를 확인합니다."
L["CONDITIONPANEL_PETMODE_NONE"] = "소환수 없음"
L["CONDITIONPANEL_PETSPEC"] = "소환수 전문화"
L["CONDITIONPANEL_PETSPEC_DESC"] = "현재 소환수의 전문화를 확인합니다."
L["CONDITIONPANEL_POWER"] = "주 자원"
L["CONDITIONPANEL_POWER_DESC"] = "유닛이 표범 변신 중인 드루이드라면 기력을, 유닛이 전사라면 분노를 확인합니다."
L["CONDITIONPANEL_PVPFLAG"] = "PvP 전투 상태 활성화 유닛"
L["CONDITIONPANEL_RAIDICON"] = "유닛 공격대 아이콘"
L["CONDITIONPANEL_RAIDICON_DESC"] = "유닛에 적용된 공격대 징표 아이콘을 확인합니다."
L["CONDITIONPANEL_REMOVE"] = "이 조건 제거"
L["CONDITIONPANEL_RESTING"] = "휴식 중"
L["CONDITIONPANEL_ROLE"] = "유닛 파티 역할"
L["CONDITIONPANEL_ROLE_DESC"] = "파티/공격대에서 플레이어에 지정된 역할을 확인합니다."
L["CONDITIONPANEL_RUNES"] = "룬 갯수"
L["CONDITIONPANEL_RUNES_CHECK_DESC"] = "이 유형의 룬을 조건의 총 갯수로 계산하려면 체크하세요."
L["CONDITIONPANEL_RUNES_DESC3"] = "원하는 룬의 갯수가 언제 사용 가능한 지 확인하려면 이 조건 유형을 사용하세요."
L["CONDITIONPANEL_RUNESLOCK"] = "룬 갯수 잠금"
L["CONDITIONPANEL_RUNESLOCK_DESC"] = "원하는 룬의 갯수가 언제 잠기는 지 (충전 중) 확인하려면 이 조건 유형을 사용하세요."
L["CONDITIONPANEL_RUNESRECH"] = "충전 중인 룬 갯수"
L["CONDITIONPANEL_RUNESRECH_DESC"] = "원하는 룬의 갯수가 언제 충전되는 지 확인하려면 이 조건 유형을 사용하세요."
L["CONDITIONPANEL_SPELLCOST"] = "주문 비용"
L["CONDITIONPANEL_SPELLCOST_DESC"] = "주문의 비용을 확인합니다. 개체는 마나/분노/기력/등등입니다."
L["CONDITIONPANEL_SPELLRANGE"] = "유닛의 사정 거리 내 주문"
L["CONDITIONPANEL_SWIMMING"] = "수영 중"
L["CONDITIONPANEL_THREAT_RAW"] = "유닛 위협 수준 - 원래의"
L["CONDITIONPANEL_THREAT_RAW_DESC"] = [=[이 조건은 유닛에 자신의 원래의 위협 수준 백분율을 확인합니다.

근접거리 플레이어는 110%에 어그로를 끕니다
원거리 플레이어는 130%에 어그로를 끕니다
어그로를 가진 플레이어는 255%의 원래의 위협 수준 백분율을 가집니다]=]
L["CONDITIONPANEL_THREAT_SCALED"] = "유닛 위협 수준 - 비율화"
L["CONDITIONPANEL_THREAT_SCALED_DESC"] = [=[이 조건은 유닛에 비율화된 위협 수준 백분율을 확인합니다.

자신이 유닛을 방어 중이면 100% 가리킵니다.]=]
L["CONDITIONPANEL_TIMER_DESC"] = "\"타이머\" 알림 처리기가 설정하고 수정한 타이머의 값을 확인합니다."
L["CONDITIONPANEL_TRACKING"] = "추적 활성"
L["CONDITIONPANEL_TRACKING_DESC"] = "활성화한 미니맵 추적의 유형을 확인합니다."
L["CONDITIONPANEL_TYPE"] = "유형"
L["CONDITIONPANEL_UNIT"] = "유닛"
L["CONDITIONPANEL_UNITISUNIT"] = "유닛 일치"
L["CONDITIONPANEL_UNITISUNIT_DESC"] = "이 조건은 첫번째 입력 상자에 입력된 유닛과 두번째 입력 상자에 입력된 유닛이 완전히 같으면 만족됩니다."
L["CONDITIONPANEL_UNITISUNIT_EBDESC"] = "이 입력 상자에 첫번째 유닛과 비교할 유닛을 입력하세요."
L["CONDITIONPANEL_UNITRACE"] = "유닛 종족"
L["CONDITIONPANEL_UNITSPEC"] = "유닛 전문화"
L["CONDITIONPANEL_UNITSPEC_CHOOSEMENU"] = "전문화 선택..."
L["CONDITIONPANEL_UNITSPEC_DESC"] = [=[이 조건은 다음에만 작동합니다:
|cff7fffff-|r 자기 자신
|cff7fffff-|r 전장 적
|cff7fffff-|r 투기장 적

다음에 작동하지 않습니다: |TInterface/AddOns/TellMeWhen/Textures/Alert:0:2|t
|cff7fffff-|r 파티원
|cff7fffff-|r 모든 다른 플레이어]=]
L["CONDITIONPANEL_VALUEN"] = "값"
L["CONDITIONPANEL_VEHICLE"] = "유닛 차량 조종"
L["CONDITIONPANEL_ZONEPVP"] = "지역 PvP 상태"
L["CONDITIONPANEL_ZONEPVP_DESC"] = "지역의 PvP 모드를 확인합니다 (예. 분쟁 지역, 성역, 전투 지역, 등등)"
L["CONDITIONPANEL_ZONEPVP_FFA"] = "개인 PvP 전투"
L["CONDITIONS"] = "조건"
L["CONFIGMODE"] = "TellMeWhen이 설정 모드 상태입니다. 설정 모드를 빠져 나가기 까지 아이콘은 기능하지 않습니다. 설정 모드 켜기와 끄기를 전환하려면 '/tellmewhen'이나 '/tmw'를 입력하세요."
L["CONFIGMODE_EXIT"] = "설정 모드 나가기"
L["CONFIGMODE_EXITED"] = "TMW가 잠겼습니다. 다시 설정 모드로 들어가려면 /tmw를 입력하세요."
L["CONFIGMODE_NEVERSHOW"] = "다시 보지 않기"
L["CONFIGPANEL_BACKDROP_HEADER"] = "배경"
L["CONFIGPANEL_CBAR_HEADER"] = "타이머 바 오버레이"
L["CONFIGPANEL_CLEU_HEADER"] = "전투 이벤트"
L["CONFIGPANEL_CNDTTIMERS_HEADER"] = "조건 타이머"
L["CONFIGPANEL_COMM_HEADER"] = "통신"
L["CONFIGPANEL_MEDIA_HEADER"] = "미디어"
L["CONFIGPANEL_PBAR_HEADER"] = "자원 바 오버레이"
L["CONFIGPANEL_TIMER_HEADER"] = "타이머 회전"
L["CONFIGPANEL_TIMERBAR_BARDISPLAY_HEADER"] = "타이머 바"
L["CONFIRM_DELETE_GENERIC_DESC"] = "%s|1이;가; 삭제됩니다."
L["CONFIRM_DELGROUP"] = "그룹 삭제"
L["CONFIRM_DELLAYOUT"] = "배치 삭제"
L["CONFIRM_HEADER"] = "진행할까요?"
L["COPYGROUP"] = "그룹 복사"
L["COPYPOSSCALE"] = "위치/크기 비율만 복사"
L["CrowdControl"] = "군중 제어"
L["Curse"] = "저주"
L["DamageBuffs"] = "피해 강화 효과"
L["DamageShield"] = "피해 반사"
L["DBRESTORED_INFO"] = [=[TellMeWhen 데이터베이스가 비었거나 손상되었습니다.
여러가지 이유로 발생할 수 있으며, 일반적으로 WoW의 비정상적인 종료로 인해 발생합니다.

TellMeWhen_Options은 이런 식으로 TellMeWhen과 TellMeWhen_Options의 데이터베이스가 동시에 손상 될 가능성이 거의 없기 때문에 데이터베이스의 백업을 유지합니다.


%s에 시작된 세션에서 생성된 백업으로 복원되었습니다.]=]
L["DEBUFFTOCHECK"] = "확인할 약화 효과"
L["DEBUFFTOCOMP1"] = "비교할 첫번째 약화 효과 "
L["DEBUFFTOCOMP2"] = "비교할 두번째 약화 효과"
L["DEFAULT"] = "기본값"
L["DefensiveBuffs"] = "방어 강화 효과"
L["DefensiveBuffsAOE"] = "광역 방어 강화 효과"
L["DefensiveBuffsSingle"] = "대상 지정 방어 강화 효과"
L["DESCENDING"] = "내림"
L["DISABLED"] = "비활성화"
L["Disease"] = "질병"
L["Disoriented"] = "방향 감각 상실"
L["DOMAIN_GLOBAL"] = "|cff00c300공통|r"
L["DOMAIN_PROFILE"] = "프로필"
L["DOWN"] = "아래로"
L["DR-Disorient"] = "방향 감각 상실"
L["DR-Incapacitate"] = "행동 불가"
L["DR-Root"] = "이동 불가"
L["DR-Silence"] = "침묵"
L["DR-Stun"] = "기절"
L["DR-Taunt"] = "도발"
L["DT_DOC_AuraSource"] = [=[아이콘이 확인 중인 강화 효과/약화 효과의 시전 유닛을 반환합니다. 오라의 시전자 유닛ID가 올바를 경우에만 데이터를 가집니다 (일반적으로 시전자가 같은 파티일 때만 해당됩니다).

[Name] 태그와 함께 사용하는 것이 가장 좋습니다. (이 태그는 %s 형식의 아이콘과 사용할 수 있습니다)]=]
L["DT_DOC_Counter"] = "TellMeWhen 카운터의 값을 반환합니다. 카운터는 아이콘 알림에서 생성되고 수정됩니다."
L["DT_DOC_Destination"] = "목적 대상 유닛이나 아이콘이 처리한 마지막 전투 이벤트의 이름을 반환합니다. [Name] 태그와 함께 사용하는 것이 가장 좋습니다. (이 태그는 %s 형식의 아이콘과 사용할 수 있습니다)"
L["DT_DOC_Duration"] = "아이콘에 현재 남은 지속시간으로 반환합니다. [TMWFormatDuration]으로 이 형식을 지정하는 것을 추천합니다."
L["DT_DOC_Extra"] = "아이콘이 처리한 마지막 전투 이벤트로부터 추가 주문을 반환합니다. (이 태그는 %s 형식의 아이콘과 사용할 수 있습니다)"
L["DT_DOC_gsub"] = [=[강력한 문자열 조작 기능의 DogTags를 위해 Lua의 string.gsub 함수를 사용합니다.

선택적인 대체 횟수 제한 옵션과 함께, 값에서 패턴과 일치하는 모든 부분을 대체합니다.]=]
L["DT_DOC_IsShown"] = "아이콘의 표시 여부를 반환합니다."
L["DT_DOC_LocType"] = [=[아이콘이 표시하고 있는 제어 불가 효과의 유형을 반환합니다.
(이 태그는 %s 형식의 아이콘과 사용할 수 있습니다).]=]
L["DT_DOC_MaxDuration"] = "아이콘의 최대 지속시간을 반환합니다. 현재 지속시간이 아닌, 타이머가 시작할 때의 지속시간입니다."
L["DT_DOC_Name"] = "유닛의 이름을 반환합니다. DogTag에서 제공한 기본 [Name] 태그의 향상된 버전입니다."
L["DT_DOC_Opacity"] = "아이콘의 불투명도를 반환합니다. 0에서 1 사이의 값을 반환합니다."
L["DT_DOC_PreviousUnit"] = "현재 유닛 이전에 아이콘이 확인한 유닛이나 유닛의 이름을 반환합니다. [Name] 태그와 함께 사용하는 것이 가장 좋습니다."
L["DT_DOC_Source"] = "아이콘이 처리한 마지막 전투 이벤트의 이름이나 시전자 유닛을 반환합니다. [Name] 태그와 함께 사용하는 것이 가장 좋습니다. (이 태그는 %s 형식의 아이콘과 사용할 수 있습니다)."
L["DT_DOC_Spell"] = "아이콘이 표시 중인 데이터의 주문이나 아이템을 반환합니다."
L["DT_DOC_Stacks"] = "아이콘의 현재 중첩을 반환합니다"
L["DT_DOC_strfind"] = [=[강력한 문자열 조작 기능의 DogTags를 위해 Lua의 string.find 함수를 사용합니다.

첫 시작 문자부터 시작하여 값 내에 패턴이 처음 나타나는 위치를 반환합니다.]=]
L["DT_DOC_StripServer"] = "유닛 이름에서 서버 이름을 제거합니다. 이름의 마지막 하이픈 다음의 모든 내용을 서버 이름으로 간주합니다."
L["DT_DOC_Timer"] = "TellMeWhen 타이머의 값을 반환합니다. 타이머는 아이콘 알림에서 생성되고 수정됩니다."
L["DT_DOC_TMWFormatDuration"] = "TellMeWhen의 시간 형식으로 형식화된 문자열을 반환합니다. [FormatDuration]과 비슷합니다."
L["DT_DOC_Unit"] = "아이콘이 확인 중인 유닛이나 유닛의 이름을 반환합니다. [Name] 태그와 함께 사용하는 것이 가장 좋습니다."
L["DT_DOC_Value"] = "아이콘이 표시 중인 숫자 값을 반환합니다. 아이콘 형식 중 몇몇에서만 사용할 수 있습니다."
L["DT_DOC_ValueMax"] = "아이콘이 표시 중인 숫자 값의 최대 값을 반환합니다. 아이콘 형식 중 몇몇에서만 사용할 수 있습니다."
L["DT_INSERTGUID_GENERIC_DESC"] = "하나의 아이콘에 다른 정보를 표시하고 싶다면, 해당 아이콘을 |cff7fffffShift-클릭|r하여 태그의 \"아이콘\" 매개 변수로 전달할 수 있는 고유 식별자를 삽입할 수 있습니다."
L["DT_INSERTGUID_TOOLTIP"] = "|cff7fffffShift-클릭|r하여 이 아이콘의 식별자를 DogTag에 삽입합니다."
L["DURATION"] = "지속시간"
L["DURATIONALPHA_DESC"] = [=[지속시간 요구 사항이 실패했을 때 아이콘이 표시할 불투명도 등급을 설정하세요.

다른 %s 설정으로 아이콘이 이미 숨겨져 있다면 이 설정은 무시됩니다.]=]
L["DURATIONPANEL_TITLE2"] = "지속시간 요구 사항"
L["EARTH"] = "대지"
L["ECLIPSE_DIRECTION"] = "식 진행방향"
L["elite"] = "정예"
L["ENABLINGOPT"] = "TellMeWhen_Options가 비활성 중입니다. 활성화 중..."
L["ENCOUNTERTOCHECK"] = "확인할 우두머리 전투"
L["ENCOUNTERTOCHECK_DESC_BIGWIGS"] = "우두머리 전투의 전체 이름이나 부분 이름을 입력하세요. 이름은 BigWig 설정에 표시되며, 모험 안내서에도 있습니다."
L["ENCOUNTERTOCHECK_DESC_DBM"] = "우두머리 전투의 전체 이름이나 부분 이름을 입력하세요. 이름은 전투 시작/전멸/처치 시에 대화에 나타나며, 모험 안내서에도 있습니다."
L["Enraged"] = "광폭화"
L["EQUIPSETTOCHECK"] = "확인할 장비 구성 (|cFFFF5959대/소문자 구분|r)"
L["ERROR_ACTION_DENIED_IN_LOCKDOWN"] = "%q 옵션을 활성화하지 않았다면 전투 중에 할 수 없습니다 (이 옵션에 접근하려면 '/tmw options'를 입력하세요)."
L["ERROR_ANCHOR_CYCLICALDEPS"] = "%s|1을;를; %s에 고정하려고 시도했지만 %s의 위치는 %s의 위치에 영향을 받습니다, 따라서 TellMeWhen은 큰 변동을 방지하기 위해 고정 위치를 화면의 중앙으로 재설정 했습니다."
L["ERROR_ANCHORSELF"] = "%s|1이;가; 자기 자신에게 고정되려고 시도했습니다, 따라서 TellMeWhen은 큰 변동을 방지하기 위해 고정 위치를 화면의 중앙으로 재설정 했습니다."
L["ERROR_INVALID_SPELLID2"] = "아이콘이 올바르지 않은 주문ID를 확인하고 있습니다: %s. 원치 않는 아이콘의 동작을 피하려면 제거해 주세요."
L["ERROR_MISSINGFILE"] = [=[TellMeWhen %s|1을;를; 사용하려면 WoW의 완전한 재시작이 필요합니다.

%s|1을;를; 찾을 수 없습니다.

지금 WoW를 재시작하시겠습니까? ]=]
L["ERROR_MISSINGFILE_NOREQ"] = [=[TellMeWhen %s|1을;를; 완벽하게 사용하려면 WoW의 완전한 재시작이 필요할 수 있습니다.

%s|1을;를; 찾을 수 없습니다.

지금 WoW를 재시작하시겠습니까? ]=]
L["ERROR_MISSINGFILE_OPT"] = [=[TellMeWhen %s|1을;를; 설정하려면 WoW의 완전한 재시작이 필요합니다.

%s|1을;를; 찾을 수 없습니다.

지금 WoW를 재시작하시겠습니까? ]=]
L["ERROR_MISSINGFILE_OPT_NOREQ"] = [=[TellMeWhen %s|1을;를; 완벽하게 설정하려면 WoW의 완전한 재시작이 필요할 수 있습니다.

%s|1을;를; 찾을 수 없습니다.

지금 WoW를 재시작하시겠습니까? ]=]
L["ERROR_MISSINGFILE_REQFILE"] = "필요한 파일"
L["ERROR_NO_LOCKTOGGLE_IN_LOCKDOWN"] = "%q 옵션이 비활성 중이면 전투 중에 TellMeWhen을 잠금해제 할 수 없습니다 (이 옵션에 접근하려면 \"/tmw options'을 입력하세요)."
L["ERROR_NOTINITIALIZED_NO_ACTION"] = "애드온 초기 실행에 실패하면 TellMeWhen은 그 동작을 수행할 수 없습니다!"
L["ERROR_NOTINITIALIZED_NO_LOAD"] = "TellMeWhen 초기 실행에 실패하면 TellMeWhen_Options을 불러올 수 없습니다."
L["ERROR_NOTINITIALIZED_OPT_NO_ACTION"] = "애드온 초기 실행에 실패하면 TellMeWhen_Options은 그 동작을 수행할 수 없습니다."
L["ERRORS_FRAME"] = "오류 프레임"
L["ERRORS_FRAME_DESC"] = "%q같은 일반 표시 메시지를 표준 오류 프레임에 출력합니다"
L["EVENT_CATEGORY_CHANGED"] = "데이터 변경됨"
L["EVENT_CATEGORY_CHARGES"] = "충전량"
L["EVENT_CATEGORY_CLICK"] = "상호 작용"
L["EVENT_CATEGORY_CONDITION"] = "조건"
L["EVENT_CATEGORY_MISC"] = "기타"
L["EVENT_CATEGORY_STACKS"] = "중첩"
L["EVENT_CATEGORY_TIMER"] = "타이머"
L["EVENT_CATEGORY_VISIBILITY"] = "표시"
L["EVENT_FREQUENCY"] = "발생 주기"
L["EVENT_FREQUENCY_DESC"] = "조건 세트가 만족했을 때 처리기가 발생되는 빈도를 초 단위로 설정하세요."
L["EVENT_WHILECONDITIONS"] = "발생 조건"
L["EVENT_WHILECONDITIONS_DESC"] = "조건 세트가 만족할 때까지 이 알림을 재생시킬 조건의 세트를 설정하려면 클릭하세요."
L["EVENT_WHILECONDITIONS_TAB_DESC"] = "조건 세트가 만족할 때까지 알림을 재생시킬 조건의 세트를 설정합니다."
L["EVENTCONDITIONS"] = "이벤트 조건"
L["EVENTCONDITIONS_DESC"] = "조건 세트가 통과하기 시작할 때 이 이벤트를 발생시킬 조건의 세트를 설정하려면 클릭하세요."
L["EVENTCONDITIONS_TAB_DESC"] = "조건 세트가 통과하기 시작할 때 이벤트를 발생시킬 조건의 세트를 설정합니다."
L["EVENTHANDLER_COUNTER_TAB"] = "카운터"
L["EVENTHANDLER_COUNTER_TAB_DESC"] = "카운터를 설정, 증가 또는 감소시킵니다. 조건으로 확인하거나 DogTags로 표시할 수 있습니다."
L["EVENTHANDLER_LUA_CODE"] = "실행할 Lua 코드"
L["EVENTHANDLER_LUA_CODE_DESC"] = "이벤트가 발생했을 때 실행될 Lua 코드를 여기에 적으세요."
L["EVENTHANDLER_LUA_LUA"] = "Lua"
L["EVENTHANDLER_LUA_LUAEVENTf"] = "Lua 이벤트: %s"
L["EVENTHANDLER_LUA_TAB"] = "Lua"
L["EVENTHANDLER_LUA_TAB_DESC"] = "Lua 프로그래밍 경험이 있는 고급 사용자는 실행할 스크립트를 작성할 수 있습니다."
L["EVENTHANDLER_TIMER_TAB"] = "타이머"
L["EVENTHANDLER_TIMER_TAB_DESC"] = "초시계 스타일의 타이머를 재생하거나 멈춥니다. 조건으로 확인하거나 DogTags로 표시할 수 있습니다."
L["EVENTS_CHANGETRIGGER"] = "발생 조건 변경"
L["EVENTS_CHOOSE_EVENT"] = "발생 조건 선택:"
L["EVENTS_CHOOSE_HANDLER"] = "알림 선택:"
L["EVENTS_CLONEHANDLER"] = "복제"
L["EVENTS_HANDLER_ADD_DESC"] = "|cff7fffff클릭|r하여 알림의 이 유형을 추가합니다."
L["EVENTS_HANDLERS_ADD"] = "알림 추가..."
L["EVENTS_HANDLERS_ADD_DESC"] = "|cff7fffff클릭|r하여 이 아이콘에 추가할 알림을 선택합니다."
L["EVENTS_HANDLERS_GLOBAL_DESC"] = [=[|cff7fffff클릭|r - 알림 옵션
|cff7fffff오른쪽-클릭|r - 복제 또는 발생 조건 변경
|cff7fffff클릭하고 끌기|r - 재정렬]=]
L["EVENTS_HANDLERS_HEADER"] = "알림 처리기"
L["EVENTS_HANDLERS_PLAY"] = "테스트 알림"
L["EVENTS_HANDLERS_PLAY_DESC"] = "|cff7fffff클릭|r하여 알림을 테스트합니다"
L["EVENTS_SETTINGS_CNDTJUSTPASSED"] = "조건이 만족하기 시작"
L["EVENTS_SETTINGS_CNDTJUSTPASSED_DESC"] = "위에서 설정된 조건이 만족하지 않으면 알림이 처리되지 않도록 방지합니다."
L["EVENTS_SETTINGS_COUNTER_AMOUNT"] = "값"
L["EVENTS_SETTINGS_COUNTER_AMOUNT_DESC"] = "카운터를 설정하거나 수정할 값을 입력하세요."
L["EVENTS_SETTINGS_COUNTER_HEADER"] = "카운터 설정"
L["EVENTS_SETTINGS_COUNTER_NAME"] = "카운터 이름"
L["EVENTS_SETTINGS_COUNTER_NAME_DESC"] = [=[변경할 카운터의 이름을 입력하세요. 카운터가 존재하지 않으면 첫 번째가 변경되며, 초기 값은 0입니다.

카운터 이름은 공백없이 소문자여야 합니다.

이 카운터를 확인하고 싶은 다른 위치에 이 카운터 이름을 사용하세요 ([Counter] Dogtag를 통해 조건과 문자 표시)


고급 사용자: 카운터는 TMW.COUNTERS[counterName] = value 에 저장됩니다.  사용자 설정 Lua 스크립트에서 카운터를 변경하는 경우 TMW:Fire( "TMW_COUNTER_MODIFIED", counterName ) 를 호출하세요.]=]
L["EVENTS_SETTINGS_COUNTER_OP"] = "연산"
L["EVENTS_SETTINGS_COUNTER_OP_DESC"] = "카운터에서 수행할 연산을 선택하세요"
L["EVENTS_SETTINGS_HEADER"] = "발생 조건 설정"
L["EVENTS_SETTINGS_ONLYSHOWN"] = "아이콘이 표시될 때만 처리"
L["EVENTS_SETTINGS_ONLYSHOWN_DESC"] = "아이콘이 표시되고 있지 않을 때 알림이 처리되는 걸 방지합니다."
L["EVENTS_SETTINGS_PASSINGCNDT"] = "조건이 만족할 때만 처리:"
L["EVENTS_SETTINGS_PASSINGCNDT_DESC"] = "아래에서 설정된 조건이 만족하지 않으면 알림이 처리되지 않도록 방지합니다."
L["EVENTS_SETTINGS_PASSTHROUGH"] = "하위 이벤트로 계속"
L["EVENTS_SETTINGS_PASSTHROUGH_DESC"] = [=[이 다음에 다른 이벤트-발생 알림이 처리되도록 허용하려면 체크하세요.

체크하지 않으면, 성공적으로 처리하고 출력/표시 한 경우 아이콘은 이 이벤트 이후에 더 이상의 이벤트를 처리하지 않습니다.

예외가 적용될 수 있습니다, 자세한 내용은 개별 이벤트 설명을 확인하세요.]=]
L["EVENTS_SETTINGS_SIMPLYSHOWN"] = "아이콘이 표시될 때만 발생"
L["EVENTS_SETTINGS_SIMPLYSHOWN_DESC"] = [=[아이콘이 표시되고 있을 때만 알림이 발생하도록 합니다.

다른 추가 조건 없이 알림을 사용받으려면 이 설정을 활성화하고 조건 세트를 공란으로 비워두세요.

또는 이 설정을 추가 조건과 결합할 수 있습니다.]=]
L["EVENTS_SETTINGS_TIMER_HEADER"] = "타이머 설정"
L["EVENTS_SETTINGS_TIMER_NAME"] = "타이머 이름"
L["EVENTS_SETTINGS_TIMER_NAME_DESC"] = [=[수정할 타이머의 이름을 입력하세요.

타이머 이름은 공백없이 소문자여야 합니다.

이 타이머를 확인하고 싶은 다른 위치에 이 타이머 이름을 사용하세요 ([Timer] DogTag를 통한 조건과 문자 표시)]=]
L["EVENTS_SETTINGS_TIMER_OP_DESC"] = "타이머에 수행할 연산을 선택하세요"
L["EVENTS_TAB"] = "알림"
L["EVENTS_TAB_DESC"] = "소리, 문자 출력, 애니메이션을 위한 발생 조건을 설정합니다."
L["EXPORT_ALLGLOBALGROUPS"] = "모든 |cff00c300공통|r 그룹"
L["EXPORT_f"] = "%s 내보내기 "
L["EXPORT_HEADING"] = "내보내기"
L["EXPORT_SPECIALDESC2"] = "%s 버전을 사용 중인 다른 TellMeWhen 사용자만 이 데이터를 가져오기 할 수 있습니다"
L["EXPORT_TOCOMM"] = "플레이어에게"
L["EXPORT_TOCOMM_DESC"] = [=[편집 상자에 플레이어의 이름을 입력하고 데이터를 전송하려면 이 옵션을 선택하세요. 귓속말을 할 수 있는 사람이어야 하며(같은 진영, 서버, 접속 중), TellMeWhen v4.0.0+ 버전을 사용하고 있어야 합니다.

"GUILD" 또는 "RAID" (대/소문자 구분)를 입력하여 전체 길드 또는 공격대에 전송할 수 있습니다.]=]
L["EXPORT_TOGUILD"] = "길드로 내보내기"
L["EXPORT_TORAID"] = "공격대로 내보내기"
L["EXPORT_TOSTRING"] = "문자열로 내보내기"
L["EXPORT_TOSTRING_DESC"] = [=[필요한 데이터가 포함된 문자열이 편집 상자에 붙여 넣어집니다.
Ctrl+C를 눌러 복사하고 공유하고 싶은 곳에 붙여넣기 하세요.]=]
L["FALSE"] = "False(거짓)"
L["fCODESNIPPET"] = "코드 조각: %s"
L["Feared"] = "공포"
L["fGROUP"] = "그룹: %s"
L["fGROUPS"] = "그룹: %s"
L["fICON"] = "아이콘: %s"
L["FIRE"] = "불"
L["FONTCOLOR"] = "글꼴 색상"
L["FONTSIZE"] = "글꼴 크기"
L["FORWARDS_IE"] = "전송"
L["FORWARDS_IE_DESC"] = [=[편집된 다음 아이콘을 불러옵니다

%s |T%s:0|t.]=]
L["fPROFILE"] = "프로필: %s"
L["FROMNEWERVERSION"] = "당신의 버전보다 최신 버전의 TellMeWhen에서 생성된 데이터를 가져왔습니다. 최신 버전으로 업그레이드 하기 전까지 몇몇 설정은 작동하지 않을 수 있습니다."
L["fTEXTLAYOUT"] = "문자 레이아웃: %s"
L["GCD"] = "전역 재사용 대기시간"
L["GCD_ACTIVE"] = "GCD 활성 상태"
L["GENERIC_NUMREQ_CHECK_DESC"] = "%s|1을;를; 활성화하고 설정하려면 체크하세요."
L["GENERICTOTEM"] = "토템 %d"
L["GLOBAL_GROUP_GENERIC_DESC"] = "이 WoW 계정의 모든 TellMeWhen 프로필에 |cff00c300공통|r 그룹을 사용할 수 있습니다."
L["GLYPHTOCHECK"] = "확인할 문양"
L["GROUP"] = "그룹"
L["GROUP_UNAVAILABLE"] = "|TInterface/PaperDollInfoFrame/UI-GearManager-LeaveItem-Transparent:20|t 지나치게 제한적인 전문화/역할 설정때문에 이 그룹을 표시할 수 없습니다."
L["GROUPCONDITIONS"] = "그룹 조건"
L["GROUPCONDITIONS_DESC"] = "이 그룹이 표시될 때 미세 조정할 수 있도록 허용하는 조건을 설정합니다."
L["GROUPICON"] = "그룹: %s, 아이콘: %s"
L["GROUPSELECT_TOOLTIP"] = [=[|cff7fffff클릭|r하여 편집합니다.

|cff7fffff클릭하고 끌어서|r 재정렬 하거나 도메인을 변경합니다.]=]
L["GROUPSETTINGS_DESC"] = "이 그룹의 설정을 구성합니다."
L["GUIDCONFLICT_DESC_PART1"] = [=[TellMeWhen은 다음 항목이 동일한 전역 고유 식별자(GUID)를 가지고 있는 걸 감지했습니다. 다른 아이콘이나 그룹에서 참조하려는 경우 많은 문제를 야기할 수 있습니다 (예. 메타 아이콘의 대상을 만드는 경우).

해결하려면 새로운 GUID를 생성하고 싶은 하나를 선택해주세요. 이전에 생성한 GUID를 가리키는 모든 참조는 GUID를 생성하지 않은 것을 가리키게 됩니다. 모두 정상 작동하게 하려면 설정을 조정해야 할 수 있습니다.]=]
L["GUIDCONFLICT_DESC_PART2"] = "(예를 들어 둘 중에 하나를 삭제하는 방법으로) 직접 이 문제를 해결하고 싶다면, 당신도 이를 수행할 수 있습니다."
L["GUIDCONFLICT_IGNOREFORSESSION"] = "이 구성 세션에 대한 충돌을 무시합니다."
L["GUIDCONFLICT_REGENERATE"] = "%s의 GUID 재생성"
L["Heals"] = "플레이어 치유"
L["HELP_ANN_LINK_INSERTED"] = [=[당신이 삽입한 링크가 이상해 보이지만 DogTag로 형식화하기 위한 방법입니다.

블리자드 채널로 출력하는 경우 색상 코드를 변경하면 링크가 파괴됩니다.]=]
L["HELP_BUFF_NOSOURCERPPM"] = [=[RPPM 체계를 사용하는 강화 효과인 %s|1을;를; 추적하려고 시도하는 것 같습니다.

블리자드 오류때문에 %q 설정을 활성화했다면 이 강화 효과는 추적될 수 없습니다.

이 강화 효과를 제대로 추적하고 싶다면 이 설정을 비활성 해주세요.]=]
L["HELP_CNDT_ANDOR_FIRSTSEE"] = [=[조건 모두가 만족해야 하는지 아니면 하나만 만족해도 되는지 선택할 수 있습니다.

당신이 원할 경우 당신의 조건 사이의 설정을 |cff7fffff클릭|r하여 이 동작을 변경할 수 있습니다.]=]
L["HELP_CNDT_PARENTHESES_FIRSTSEE"] = [=[특히 %q 설정과 결합했을 때 복합 검사 기능을 위해 조건의 세트를 함께 묶을 수 있습니다.

원하는 경우 조건 사이의 괄호를 |cff7fffff클릭|r하여 조건들을 묶어 그룹화합니다.]=]
L["HELP_EXPORT_DOCOPY_MAC"] = "복사하려면 |cff7fffffCMD+C|r를 누르세요"
L["HELP_EXPORT_DOCOPY_WIN"] = "복사하려면 |cff7fffffCTRL+C|r를 누르세요"
L["HELP_EXPORT_MULTIPLE_COMM"] = "내보낸 데이터는 당신이 내보낸 기본 데이터에 필요한 추가 데이터를 포함합니다. 포함된 내용을 확인하려면, 같은 데이터를 문자열로 내보내기한 후 해당 문자열의 \"문자열로부터\" 가져오기 메뉴를 확인하세요."
L["HELP_EXPORT_MULTIPLE_STRING"] = [=[내보내기 문자열은 당신이 내보낸 기본 데이터에 필요한 데이터의 추가 문자열을 포함합니다. 포함된 내용을 확인하려면, 문자열의 "문자열로부터" 가져오기 메뉴를 확인하세요.

TellMeWhen v7.0.0+ 사용자는 모든 문자열을 한번에 복사하여 가져오기 할 수 있습니다. 하위 버전의 사용자는 각 문자열을 개별적으로 붙여넣기 해야 합니다.]=]
L["HELP_FIRSTUCD"] = [=[특별한 지속시간 구문을 사용하는 아이콘 형식을 처음 사용했습니다! 특정 아이콘 형식으로 %q 편집 상자에 추가된 주문은 다음 구문을 사용하여 각 주문 다음에 즉시 지속시간을 정의해야 합니다:

주문: 지속시간

예제:

"%s: 120"
"%s: 10; %s: 24"
"%s: 180"
"%s: 3:00"
"62618: 3:00"

추천 목록에서 추가하면 자동으로 툴팁 상의 지속시간을 추가합니다.]=]
L["HELP_IMPORT_CURRENTPROFILE"] = [=[이 프로필의 아이콘을 다른 아이콘 칸으로 옮기거나 복사하려고 시도 중인가요?

아이콘을 |cff7fffff오른쪽-클릭하고|r (마우스 버튼을 누르고 있는 채로) 다른 칸으로 |cff7fffff끌면|r 쉽게 할 수 있습니다. 마우스 버튼을 놓으면 여러 옵션이 있는 메뉴가 나타납니다.

다른 옵션을 사용하려면 아이콘을 메타 아이콘, 다른 그룹, 또는 화면 상의 다른 프레임으로 끌기 해보세요.]=]
L["HELP_MISSINGDURS"] = [=[다음 주문은 지속시간이 누락되었습니다:

%s

지속시간을 추가하기 위해, 다음 구문을 사용하세요:

주문 이름: 지속시간

예. "%s: 10"

추천 목록에서 추가하면 자동으로 툴팁 상의 지속시간을 추가합니다.]=]
L["HELP_NOUNIT"] = "유닛을 반드시 입력해야 합니다!"
L["HELP_NOUNITS"] = "최소 하나의 유닛을 입력해야 합니다!"
L["HELP_ONLYONEUNIT"] = [=[하나의 유닛에만 적용하는 조건이지만 당신은 %d개의 유닛을 입력했습니다.

여러 유닛을 확인하고 싶다면, 아이콘 표시 조건을 사용하는 아이콘으로 해당 아이콘을 참조하는 별개의 방법을 고려해보세요.]=]
L["HELP_POCKETWATCH"] = [=[|TInterface/Icons/INV_Misc_PocketWatch_01:20|t -- 회중 시계 무늬.
이 무늬는 확인되고 있는 첫번째 유효한 주문이 이름으로 입력되었고 자신의 마법책에 없는 주문이기 때문에 사용되었습니다.

게임을 플레이하는 동안 주문을 한번이라도 확인하면 올바른 무늬가 사용됩니다.

지금 바로 올바른 무늬를 보려면 확인되고 있는 첫번째 주문을 주문 ID로 변경하세요. 편집 상자에서 항목을 클릭하거나 추천 목록에서 올바르게 일치하는 항목을 오른쪽 클릭하는 것으로 쉽게 할 수 있습니다.]=]
L["HELP_SCROLLBAR_DROPDOWN"] = [=[TellMeWhen의 드롭다운 메뉴 중 몇몇은 스크롤바입니다.

메뉴에서 모든 항목을 보려면 스크롤을 아래로 내려야합니다.

마우스 휠을 사용할 수 있습니다.]=]
L["ICON"] = "아이콘"
L["ICON_TOOLTIP_CONTROLLED"] = "이 아이콘은 이 그룹에서 제어하는 첫번째 아이콘입니다. 개별적으로 편집할 수 없습니다."
L["ICON_TOOLTIP_CONTROLLER"] = "이 아이콘은 그룹을 제어합니다."
L["ICON_TOOLTIP2NEW"] = [=[|cff7fffff오른쪽-클릭|r하면 아이콘 옵션을 엽니다.
|cff7fffff클릭하고 끌면|r 이 그룹을 이동시킵니다.
|cff7fffff오른쪽-클릭하고 끌면|r 다른 아이콘으로 이동/복사합니다.
아이콘에 주문이나 아이템을 |cff7fffff끌면|r 빠른 설정을 할 수 있습니다.]=]
L["ICON_TOOLTIP2NEWSHORT"] = "|cff7fffff오른쪽-클릭|r하여 아이콘 옵션을 봅니다."
L["ICONALPHAPANEL_FAKEHIDDEN"] = "항상 숨기기"
L["ICONALPHAPANEL_FAKEHIDDEN_DESC"] = [=[일반 기능을 허용하는 동안 아이콘이 항상 숨겨지도록 강제합니다:

|cff7fffff-|r 아이콘은 다른 아이콘의 조건으로 계속 확인될 수 있습니다.
|cff7fffff-|r 메타 아이콘이 이 아이콘을 표시할 수 있습니다.
|cff7fffff-|r 이 아이콘의 알림이 계속 처리됩니다.]=]
L["ICONCONDITIONS_DESC"] = "이 아이콘이 표시될 때 미세 조정할 수 있도록 허용하는 조건을 설정합니다."
L["ICONGROUP"] = "아이콘: %s (그룹: %s)"
L["ICONMENU_ABSENT"] = "없음"
L["ICONMENU_ABSENTONALL"] = "모두 없음"
L["ICONMENU_ABSENTONALL_DESC"] = "확인 중인 모든 유닛에 확인 중인 모든 강화 효과/약화 효과가 없을 때 아이콘 불투명도 단계를 설정합니다."
L["ICONMENU_ABSENTONANY"] = "하나라도 없음"
L["ICONMENU_ABSENTONANY_DESC"] = "확인 중인 유닛중 하나라도 확인 중인 모든 강화 효과/약화 효과가 없을 때 아이콘 불투명도 단계를 설정합니다."
L["ICONMENU_ADDMETA"] = "메타 아이콘에 추가"
L["ICONMENU_ALLOWGCD"] = "전역 재사용 대기시간 허용"
L["ICONMENU_ALLOWGCD_DESC"] = "타이머가 전역 재사용 대기시간을 무시하지 않고 반응하거나 표시하도록 하려면 이 옵션을 체크하세요."
L["ICONMENU_ALLSPELLS"] = "모든 주문 사용 가능"
L["ICONMENU_ALLSPELLS_DESC"] = "이 아이콘이 추적하는 모든 주문이 특정 유닛에게 모두 준비되어 있을 때 이 상태가 활성화됩니다."
L["ICONMENU_ANCHORTO"] = "%s에 고정시키기"
L["ICONMENU_ANCHORTO_DESC"] = [=[%s|1을;를; %s에 고정시킵니다, 따라서 언제든 %s|1을;를; 이동하면 %s도 같이 이동합니다.

그룹 옵션에서 고급 고정 설정을 사용할 수 있습니다.]=]
L["ICONMENU_ANCHORTO_UIPARENT"] = "고정 위치 초기화"
L["ICONMENU_ANCHORTO_UIPARENT_DESC"] = [=[%s의 고정 위치를 다시 화면으로 되돌립니다 (UIParent). 현재는 %s에 고정되어 있습니다.

그룹 옵션에서 고급 고정 설정을 사용할 수 있습니다.]=]
L["ICONMENU_ANYSPELLS"] = "아무 주문 사용 가능"
L["ICONMENU_ANYSPELLS_DESC"] = "이 아이콘이 추적하는 주문 중 하나라도 특정 유닛에게 준비되어 있을 때 이 상태가 활성화됩니다."
L["ICONMENU_APPENDCONDT"] = "%q 조건으로 추가"
L["ICONMENU_BAR_COLOR_BACKDROP"] = "배경 색상"
L["ICONMENU_BAR_COLOR_BACKDROP_DESC"] = "바 뒤쪽 배경의 색상과 불투명도를 설정합니다."
L["ICONMENU_BAR_COLOR_COMPLETE"] = "완료 색상"
L["ICONMENU_BAR_COLOR_COMPLETE_DESC"] = "재사용 대기시간/지속시간이 완료했을 때 바의 색상입니다."
L["ICONMENU_BAR_COLOR_MIDDLE"] = "중간 색상"
L["ICONMENU_BAR_COLOR_MIDDLE_DESC"] = "재사용 대기시간/지속시간이 절반 완료되었을 때 바의 색상입니다."
L["ICONMENU_BAR_COLOR_START"] = "시작 색상"
L["ICONMENU_BAR_COLOR_START_DESC"] = "재사용 대기시간/지속시간이 시작될 때 바의 색상입니다."
L["ICONMENU_BAROFFS"] = [=[사용자 설정 지시기 표시를 위해 바에 공간이 추가됩니다.

강화 효과가 사라지지 않게 주문을 시전하기 시작해야 할 때의 사용자 설정 지시기에 유용하고, 또는 주문이 시전하는 데 필요한 자원을 표시하고 시전 방해를 위한 여유를 조금 남겨 둘 수 있습니다.]=]
L["ICONMENU_BOTH"] = "둘 중 하나"
L["ICONMENU_BUFF"] = "강화 효과"
L["ICONMENU_BUFFCHECK"] = "강화 효과/약화 효과 확인"
L["ICONMENU_BUFFCHECK_DESC"] = [=[확인하는 유닛 중 하나라도 강화 효과가 없는 지 확인합니다.

누락된 공격대 강화 효과를 확인하기 위해 이 아이콘 형식을 사용하세요.

대부분의 다른 상황에서는 %q 아이콘 형식을 사용하세요.]=]
L["ICONMENU_BUFFDEBUFF"] = "강화 효과/약화 효과"
L["ICONMENU_BUFFDEBUFF_DESC"] = "강화 효과 및 약화 효과를 추적합니다."
L["ICONMENU_BUFFTYPE"] = "강화 효과 또는 약화 효과"
L["ICONMENU_CAST"] = "주문 시전"
L["ICONMENU_CAST_DESC"] = "주문 시전과 정신 집중을 추적합니다."
L["ICONMENU_CHECKNEXT"] = "하위-메타 확장"
L["ICONMENU_CHECKNEXT_DESC"] = [=[이 확인 란을 체크하면 검사 중인 메타 아이콘이 구성 요소 아이콘으로 확장되고 메타 아이콘이 남아 있지 않을 때까지 반복됩니다.

또한 이 아이콘은 이전에 갱신된 다른 메타 아이콘에 의해 이미 표시되었던 아이콘은 표시하지 않습니다.]=]
L["ICONMENU_CHECKREFRESH"] = "갱신 수신"
L["ICONMENU_CHECKREFRESH_DESC"] = [=[블리자드의 전투 기록은 주문 갱신이나 공포 (또는 특정 피해량을 받으면 풀리는 다른 주문)가 나타나면 오류가 많습니다. 전투 기록은 피해를 줬을 때 주문이 갱신됐다고 말하지만 기술적으로는 그렇지 않습니다. 체크 해제하면 주문 갱신에 대한 내용을 수신하지 않고, 적법한 갱신도 무시됩니다.

 특정 피해량을 받아도 풀리지 않는 점감을 확인 중이라면 체크하는 걸 추천합니다.]=]
L["ICONMENU_CHOOSENAME_EVENTS"] = "확인할 메시지 선택"
L["ICONMENU_CHOOSENAME_EVENTS_DESC"] = [=[이 아이콘이 감시할 오류 메시지를 입력하세요. 세미콜론(;)으로 구분하여 여러 항목을 추가할 수 있습니다.

오류 메시지는 입력된 대로 정확하게 일치해야 하지만, 대/소문자는 구분하지 않습니다.]=]
L["ICONMENU_CHOOSENAME_ITEMSLOT_DESC"] = [=[이름, ID, 또는 이 아이콘이 감시할 장비 칸을 입력하세요. 세미콜론(;)으로 구분하여 여러 항목을 (이름, ID, 장비 칸의 모든 조합) 입력할 수 있습니다.

장비 칸은 장착한 아이템에 해당하는 숫자 색인입니다. 장비 칸에 장착 중인 아이템을 변경하면 아이콘에 반영됩니다.

아이템이나 대화 링크를 |cff7fffffShift-클릭|r하거나 편집 상자에 아이템을 끌어다 놓으세요.]=]
L["ICONMENU_CHOOSENAME_ORBLANK"] = "(모두 추적하려면 |cff7fffff공란|r으로 두세요)"
L["ICONMENU_CHOOSENAME_WPNENCH_DESC"] = [=[이 아이콘이 감시할 무기 마법부여의 이름을 입력하세요. 세미콜론(;)으로 구분하여 여러 항목을 입력할 수 있습니다.

|cFFFF5959중요|r: 마법부여 이름은 마법부여가 활성화 중일 때의 무기 툴팁에 나타난대로 정확하게 입력해야 합니다 (예, "%s", "%s"|1은;는; 틀림).]=]
L["ICONMENU_CHOOSENAME3"] = "추적할 것"
L["ICONMENU_CHOSEICONTODRAGTO"] = "끌어다 놓기로 아이콘 선택:"
L["ICONMENU_CHOSEICONTOEDIT"] = "편집할 아이콘 선택:"
L["ICONMENU_CLEU"] = "전투 이벤트"
L["ICONMENU_CLEU_DESC"] = [=[전투 이벤트를 추적합니다.

예를 들어 주문 반사, 적중 실패, 즉시 시전, 죽음을 포함하지만, 아이콘은 사실상 무엇이든 추적할 수 있습니다.]=]
L["ICONMENU_CLEU_NOREFRESH"] = "지속시간 초기화 하지 않기"
L["ICONMENU_CLEU_NOREFRESH_DESC"] = "체크하면 아이콘의 타이머가 활성화 중일 때는 이벤트를 무시합니다."
L["ICONMENU_CNDTIC"] = "조건 아이콘"
L["ICONMENU_CNDTIC_DESC"] = "조건의 상태를 추적합니다."
L["ICONMENU_CNDTIC_ICONMENUTOOLTIP"] = "(%d개 조건)"
L["ICONMENU_COMPONENTICONS"] = "구성 요소 아이콘 & 그룹"
L["ICONMENU_COOLDOWNCHECK"] = "재사용 대기 시간 확인"
L["ICONMENU_COOLDOWNCHECK_DESC"] = "체크하면 재사용 대기 중일 때 아이콘을 사용할 수 없는 것으로 간주합니다."
L["ICONMENU_COPYCONDITIONS"] = "%d개의 조건 복사"
L["ICONMENU_COPYCONDITIONS_DESC"] = "%s의 %d개 조건을 %s|1으로;로; 복사합니다."
L["ICONMENU_COPYCONDITIONS_DESC_OVERWRITE"] = "%d개의 존재하는 조건을 덮어씁니다"
L["ICONMENU_COPYCONDITIONS_GROUP"] = "%d개의 그룹 조건 복사"
L["ICONMENU_COPYEVENTHANDLERS"] = "%d개의 알림 복사"
L["ICONMENU_COPYEVENTHANDLERS_DESC"] = "%s의 %d개의 알림을 %s로 복사합니다"
L["ICONMENU_COPYHERE"] = "여기에 복사"
L["ICONMENU_COUNTING"] = "타이머 진행"
L["ICONMENU_CTRLGROUP"] = "그룹 제어기"
L["ICONMENU_CTRLGROUP_DESC"] = [=[이 아이콘이 전체 그룹을 제어하도록 하려면 이 설정을 활성화하세요.

활성화하면 이 아이콘이 수집한 데이터로 그룹을 채웁니다.

그룹 내 다른 모든 아이콘은 개별 설정을 사용할 수 없게 됩니다.

제어된 그룹으로 사용하면 그룹의 배치 방향 및 정렬 옵션을 사용자 설정할 수 있습니다.]=]
L["ICONMENU_CTRLGROUP_UNAVAILABLE_DESC"] = "현재 아이콘 형식은 전체 그룹을 제어할 능력이 없습니다."
L["ICONMENU_CTRLGROUP_UNAVAILABLEID_DESC"] = "그룹 내 첫번째 아이콘만 (아이콘 ID 1) 그룹 제어기가 될 수 있습니다."
L["ICONMENU_CUSTOMTEX"] = "사용자 설정 무늬"
L["ICONMENU_CUSTOMTEX_DESC"] = [=[다음 방법으로 이 아이콘에 표시되는 무늬를 강제 적용할 수 있습니다:

|cff00d1ff주문 무늬|r
사용하고 싶은 무늬의 주문 이름이나 ID를 입력하세요.

|cff00d1ff다른 블리자드 무늬|r
'Interface/Icons/spell_nature_healingtouch' 같은 무늬 경로를 입력하거나, 경로가 'Interface/Icons'라면 'spell_nature_healingtouch'만 입력할 수 있습니다.

|cff00d1ff공란|r
"none"이나 "blank"를 입력하면 아이콘이 무늬를 표시하지 않습니다.

|cff00d1ff아이템 칸|r
이 상자에 "$" (달러 기호; ALT-036)를 입력하면 유동적 무늬의 목록을 볼 수 있습니다.

|cff00d1ff사용자 설정|r
WoW 디렉토리의 하위 폴더에 있는 자기만의 무늬를 사용할 수 있습니다, 무늬는 .tga 또는 .blp 형식에 2의 배수 (32, 64, 등등)의 크기여야 합니다. WoW 루트 폴더를 기준으로 무늬의 경로를 이 영역에 입력하세요.]=]
L["ICONMENU_CUSTOMTEX_MOPAPPEND_DESC"] = [=[|cff00d1ff문제해결|r
|TNULL:0|t 이 아이콘의 무늬가 녹색 사각형으로 보이고 사용자 설정 무늬가 WoW의 루트 폴더에 있다면, WoW 루트의 하위 디렉토리로 이동시키고 WoW를 재시작한 후 이 설정을 새로운 위치로 업데이트 해주세요. 사용자 설정 무늬가 주문에 설정되어 있고 더이상 존재하지 않는 주문이나 주문 이름인 경우, 존재 하는 주문의 주문ID로 변경해야 합니다.]=]
L["ICONMENU_DEBUFF"] = "약화 효과"
L["ICONMENU_DISPEL"] = "무효화 유형"
L["ICONMENU_DONTREFRESH"] = "갱신 안 함"
L["ICONMENU_DONTREFRESH_DESC"] = "초읽기 중일 때 발생하면 재사용 대기시간이 초기화되지 않도록 하려면 체크하세요."
L["ICONMENU_DOTWATCH"] = "모든 유닛 강화 효과/약화 효과"
L["ICONMENU_DOTWATCH_AURASFOUND_DESC"] = "어떤 유닛이라도 확인 중인 강화 효과/약화 효과 중 하나라도 가지고 있을 때 아이콘 불투명도 레벨을 설정합니다."
L["ICONMENU_DOTWATCH_DESC"] = [=[유닛ID에 관계없이, 자신이 모든 유닛에게 적용한 강화 효과와 약화 효과를 추적하도록 시도합니다.

다중-도트 추적에 유용합니다.

이 아이콘 유형은 반드시 그룹 제어기로 사용되어야 합니다 - 독립 아이콘은 할 수 없습니다.]=]
L["ICONMENU_DOTWATCH_GCREQ"] = "반드시 그룹 제어기"
L["ICONMENU_DOTWATCH_GCREQ_DESC"] = [=[이 아이콘 유형은 기능하기 위해 반드시 그룹 제어기여야 합니다. 독립 아이콘으로 사용할 수 없습니다.

그룹 제어기에 아이콘을 만드려면, 그룹에서 첫번째 아이콘이어야 합니다 (예. 1의 아이콘ID). 그후, %$2q 체크박스 옆에 있는 %$1q 설정을 활성화해야 합니다.]=]
L["ICONMENU_DOTWATCH_NOFOUND_DESC"] = "추적된 강화 효과/약화 효과가 없을 때 아이콘 불투명도를 설정합니다."
L["ICONMENU_DR"] = "점감 효과"
L["ICONMENU_DR_DESC"] = "점감 효과의 길이와 범위를 추적합니다."
L["ICONMENU_DRABSENT"] = "점감되지 않음"
L["ICONMENU_DRPRESENT"] = "점감됨"
L["ICONMENU_DRS"] = "점감 효과"
L["ICONMENU_DURATION_MAX_DESC"] = "아이콘을 표시할 최대 지속시간, 초 단위"
L["ICONMENU_DURATION_MIN_DESC"] = "아이콘을 표시하는 데 필요한 최소 지속시간, 초 단위"
L["ICONMENU_ENABLE"] = "활성화"
L["ICONMENU_ENABLE_DESC"] = "아이콘은 활성화 되었을 때만 기능합니다."
L["ICONMENU_ENABLE_GROUP_DESC"] = "그룹은 활성화 되었을 때만 기능합니다."
L["ICONMENU_ENABLE_PROFILE"] = "프로필 활성화"
L["ICONMENU_ENABLE_PROFILE_DESC"] = "현재 프로필의 |cff00c300공통|r 그룹을 비활성하려면 체크해제 하세요."
L["ICONMENU_FAIL2"] = "조건 실패"
L["ICONMENU_FAKEMAX"] = "인공 최대"
L["ICONMENU_FAKEMAX_DESC"] = [=[타이머의 인공 최대 값을 설정합니다.

이 설정을 사용하면 전체 아이콘 그룹을 동일한 비율로 감소시킬 수 있으며, 첫번째로 끝나는 타이머에 시각적 지시기를 제공할 수 있습니다.

이 설정을 비활성하려면 0으로 설정하세요.]=]
L["ICONMENU_FOCUS"] = "주시 대상"
L["ICONMENU_FOCUSTARGET"] = "주시 대상의 대상"
L["ICONMENU_FRIEND"] = "우호적"
L["ICONMENU_GROUPUNIT_DESC"] = [=[TellMeWhen에서 그룹은 공격대에 속해 있다면 공격대원을, 파티에 속해 있다면 파티원을 추적하는 특별한 유닛입니다.

공격대 중이라면 절대로 중복되는 유닛이 없습니다 (공격대에 있을 때 "player; party; raid" 추적은 겹쳐지므로, 파티원은 두번 확인됩니다.)]=]
L["ICONMENU_HIDENOUNITS"] = "유닛이 없으면 숨기기"
L["ICONMENU_HIDENOUNITS_DESC"] = "이 아이콘이 확인 중인 모든 유닛이 유닛 조건이나 또는 유닛이 존재 하지 않아서 무효화되었을 때 아이콘을 숨기려면 체크하세요."
L["ICONMENU_HIDEUNEQUIPPED"] = "장비 칸에 무기가 없을 때 숨기기"
L["ICONMENU_HIDEUNEQUIPPED_DESC"] = "확인 중인 무기 위치에 무기가 없거나, 해당 칸에 방패나 보조장비 장식을 장착 중일 때 아이콘을 숨기려면 체크하세요."
L["ICONMENU_HOSTILE"] = "적대적"
L["ICONMENU_ICD"] = "내부 재사용 대기시간"
L["ICONMENU_ICD_DESC"] = [=[발동 또는 비슷한 효과의 재사용 대기시간을 추적합니다.

|cFFFF5959중요|r: 각 내부 재사용 대기시간 유형을 추적하는 방법은 %q 설정 아래의 툴팁을 확인하세요.]=]
L["ICONMENU_ICDAURA_DESC"] = [=[내부 재사용 대기시간이 시작되는 경우를 선택하세요:

|cff7fffff1)|r 강화 효과 또는 약화 효과가 자신에 의해 적용되었을 때 (발동 포함), 또는
|cff7fffff2)|r 피해를 주었을 때, 또는
|cff7fffff3)|r 마나/분노/등등을 획득 했을 때.
|cff7fffff4)|r 물체나 NPC를 소환하거나 만들었을 때.

%q 편집상자에 주문 이름/ID를 입력해야 합니다:

|cff7fffff1)|r 내부 재사용 대기시간이 발동했을 때 얻는 강화 효과/약화 효과, 또는
|cff7fffff2)|r 피해를 준 주문 (전투 기록을 확인하세요), 또는
|cff7fffff3)|r 자원 회복 효과 (전투 기록을 확인하세요), 또는
|cff7fffff4)|r 소환을 발동시킨 주문 (전투 기록을 확인하세요).]=]
L["ICONMENU_ICDBDE"] = "강화 효과/약화 효과/피해/자원 회복/소환"
L["ICONMENU_ICDTYPE"] = "다음에 재사용 대기시간 시작..."
L["ICONMENU_IGNORENOMANA"] = "자원 부족 무시"
L["ICONMENU_IGNORENOMANA_DESC"] = [=[능력을 사용할 자원이 부족할 때 능력을 사용할 수 없는 것으로 취급하지 않도록 하려면 체크하세요.

%s 또는 %s 같은 능력에 유용합니다]=]
L["ICONMENU_IGNORERUNES"] = "룬 무시"
L["ICONMENU_IGNORERUNES_DESC"] = "유일한 방해물이 룬 재사용 대기시간 (또는 전역 재사용 대기시간)일 때 사용 가능한 것으로 취급하려면 체크하세요."
L["ICONMENU_IGNORERUNES_DESC_DISABLED"] = "\"룬 무시\" 설정을 활성화하려면 \"재사용 대기시간 확인\" 설정을 활성화해야 합니다."
L["ICONMENU_INVERTBARDISPLAYBAR_DESC"] = "값이 0이 될수록 바를 채웁니다."
L["ICONMENU_INVERTBARS"] = "바 채우기"
L["ICONMENU_INVERTCBAR_DESC"] = "지속시간이 0이 될수록 바를 채웁니다."
L["ICONMENU_INVERTPBAR_DESC"] = "자원이 충분해 질수록 바를 채웁니다."
L["ICONMENU_INVERTTIMER"] = "음영 반전"
L["ICONMENU_INVERTTIMER_DESC"] = "타이머의 음영 효과를 반전시키려면 이 옵션을 체크하세요."
L["ICONMENU_ISPLAYER"] = "유닛이 플레이어일 때"
L["ICONMENU_ITEMCOOLDOWN"] = "아이템 재사용 대기시간"
L["ICONMENU_ITEMCOOLDOWN_DESC"] = "사용 효과가 있는 아이템의 재사용 대기시간을 추적합니다."
L["ICONMENU_LIGHTWELL_DESC"] = "%s의 지속시간과 충전량을 추적합니다."
L["ICONMENU_MANACHECK"] = "자원 확인"
L["ICONMENU_MANACHECK_DESC"] = "마나/분노/룬 마력 등이 부족할 때 아이콘의 색상을 변경하려면 체크하세요."
L["ICONMENU_META"] = "메타 아이콘"
L["ICONMENU_META_DESC"] = [=[여러 아이콘을 하나로 결합시킵니다.

다른 아이콘이 표시되고 있어도 %q|1이;가; 체크된 아이콘은 계속 메타 아이콘으로 표시됩니다.]=]
L["ICONMENU_META_ICONMENUTOOLTIP"] = "(%d개 아이콘)"
L["ICONMENU_MOUSEOVER"] = "마우스오버"
L["ICONMENU_MOUSEOVERTARGET"] = "마우스오버의 대상"
L["ICONMENU_MOVEHERE"] = "여기로 이동"
L["ICONMENU_NAMEPLATE"] = "이름표"
L["ICONMENU_NOTCOUNTING"] = "타이머 미작동"
L["ICONMENU_NOTREADY"] = "준비되지 않음"
L["ICONMENU_OFFS"] = "위치"
L["ICONMENU_ONCOOLDOWN"] = "재사용 대기 시"
L["ICONMENU_ONFAIL"] = "실패 시"
L["ICONMENU_ONLYBAGS"] = "가방에 있을 때만"
L["ICONMENU_ONLYBAGS_DESC"] = "아이템이 가방에 있을 때만 (또는 착용 중) 아이콘을 표시하려면 체크하세요. \"착용 중일 때만\" 옵션이 활성화되어 있으면, 이 옵션도 강제로 활성화됩니다."
L["ICONMENU_ONLYEQPPD"] = "착용 중일 때만"
L["ICONMENU_ONLYEQPPD_DESC"] = "아이템을 착용 중일 때만 아이콘을 표시하려면 체크하세요."
L["ICONMENU_ONLYIFCOUNTING"] = "타이머가 활성화되었을 때만 표시"
L["ICONMENU_ONLYIFCOUNTING_DESC"] = "아이콘에 0보다 큰 지속시간을 가진 타이머가 진행 중일 때만 아이콘을 표시하려면 체크하세요."
L["ICONMENU_ONLYIFNOTCOUNTING"] = "타이머가 활성화되지 않았을 때만 표시"
L["ICONMENU_ONLYIFNOTCOUNTING_DESC"] = "아이콘에 0보다 큰 지속시간을 가진 타이머가 없을 때만 아이콘을 표시하려면 체크하세요."
L["ICONMENU_ONLYINTERRUPTIBLE"] = "시전 방해 가능한 것만"
L["ICONMENU_ONLYINTERRUPTIBLE_DESC"] = "방해할 수 있는 주문 시전만 표시하려면 체크하세요."
L["ICONMENU_ONLYMINE"] = "내가 시전한 것만"
L["ICONMENU_ONLYMINE_DESC"] = "이 아이콘이 자신이 시전한 강화 효과/약화 효과만 확인하려면 체크하세요."
L["ICONMENU_ONLYSEEN"] = "관찰된 주문만"
L["ICONMENU_ONLYSEEN_ALL"] = "모든 주문 허용"
L["ICONMENU_ONLYSEEN_ALL_DESC"] = "확인된 모든 유닛에 모든 능력을 표시하려면 체크하세요."
L["ICONMENU_ONLYSEEN_CLASS"] = "유닛의 직업 주문만"
L["ICONMENU_ONLYSEEN_CLASS_DESC"] = [=[유닛의 직업이 가진 능력만 아이콘에 표시하려면 체크하세요.

알려진 직업 주문은 추천 목록에서 파란색이나 분홍색으로 강조됩니다.]=]
L["ICONMENU_ONLYSEEN_DESC"] = "유닛이 최소 한번 시전한 주문만 아이콘에 표시하려면 체크하세요."
L["ICONMENU_ONLYSEEN_HEADER"] = "주문 필터링"
L["ICONMENU_ONSUCCEED"] = "성공 시"
L["ICONMENU_OO_F"] = "%s 없음"
L["ICONMENU_OOPOWER"] = "자원 없음"
L["ICONMENU_OORANGE"] = "사정 거리 벗어남"
L["ICONMENU_PETTARGET"] = "소환수의 대상"
L["ICONMENU_PRESENT"] = "존재"
L["ICONMENU_PRESENTONALL"] = "모두 존재"
L["ICONMENU_PRESENTONALL_DESC"] = "확인 중인 모든 유닛에 최소 하나의 강화 효과/약화 효과가 확인 중일 때 아이콘 불투명도를 설정합니다."
L["ICONMENU_PRESENTONANY"] = "아무 존재"
L["ICONMENU_PRESENTONANY_DESC"] = "확인 중인 어떤 유닛이라도 최소 하나의 강화 효과/약화 효과가 확인 중일 때 아이콘 불투명도를 설정합니다."
L["ICONMENU_RANGECHECK"] = "사정 거리 확인"
L["ICONMENU_RANGECHECK_DESC"] = "사정 거리를 벗어났을 때 아이콘의 색상을 변경하려면 체크하세요."
L["ICONMENU_REACT"] = "유닛 반응"
L["ICONMENU_REACTIVE"] = "반응 능력"
L["ICONMENU_REACTIVE_DESC"] = [=[반응 능력의 사용 가능성을 추적합니다.

반응 능력은 %s, %s, 그리고 %s 같은 것들입니다 - 특정 조건에서만 사용할 수 있는 능력입니다.]=]
L["ICONMENU_READY"] = "준비"
L["ICONMENU_REVERSEBARS"] = "뒤집기"
L["ICONMENU_REVERSEBARS_DESC"] = "시작점을 왼쪽에서 오른쪽으로 바꿉니다."
L["ICONMENU_RUNES"] = "룬 재사용 대기시간"
L["ICONMENU_RUNES_CHARGES"] = "충전으로 사용할 수 없는 룬"
L["ICONMENU_RUNES_CHARGES_DESC"] = "아이콘이 사용 가능한 룬을 표시할 때 재사용 대기 중인 룬을 추가 충전으로 취급하게 하려면 이 설정을 활성화하세요."
L["ICONMENU_RUNES_DESC"] = "룬 재사용 대기시간 추적"
L["ICONMENU_SHOWCBAR_DESC"] = "아이콘의 아래쪽 절반에 타이머를 표시하는 바를 표시합니다."
L["ICONMENU_SHOWPBAR_DESC"] = "아이콘의 위쪽 절반에 주문 시전에 필요한 자원을 표시하는 바를 표시합니다."
L["ICONMENU_SHOWSTACKS"] = "중첩 갯수 표시"
L["ICONMENU_SHOWSTACKS_DESC"] = "소지하고 있는 아이템의 중첩 갯수를 표시하려면 체크하세요."
L["ICONMENU_SHOWTIMER"] = "타이머 표시"
L["ICONMENU_SHOWTIMER_DESC"] = "아이콘에 표준 재사용 대기시간 회전 애니메이션을 표시하려면 이 옵션을 체크하세요."
L["ICONMENU_SHOWTIMERTEXT"] = "타이머 문자 표시"
L["ICONMENU_SHOWTIMERTEXT_DESC"] = [=[아이콘에 남은 재사용 대기시간/지속시간의 문자를 표시하려면 이 옵션을 체크하세요.

작동하려면 OmniCC같은 애드온이 설치 되어있거나, 또는 인터페이스 옵션의 행동 단축바 범주에서 '재사용 대기시간 숫자 보이기'를 사용해야 합니다.]=]
L["ICONMENU_SHOWTIMERTEXT_NOOCC"] = "ElvUI 타이머 문자 표시"
L["ICONMENU_SHOWTIMERTEXT_NOOCC_DESC"] = [=[아이콘에 남은 재사용 대기시간/지속시간의 ElvUI 문자를 표시하려면 이 옵션을 체크하세요.

이 설정은 ElvUI의 타이머에만 영향을 줍니다. 타이머를 제공하는 다른 애드온 (OmniCC 같은)을 사용 중이라면, %q 설정으로 그 타이머들을 조절할 수 있습니다. 이 두가지 설정을 같이 사용하는 것은 추천하지 않습니다.]=]
L["ICONMENU_SHOWTTTEXT_DESC2"] = [=[아이콘의 중첩을 효과와 연관된 변수로 보고합니다. 실제 사용은 피해 반사량 감시를 포함합니다.

이 값은 아이콘의 중첩 횟수 위치에 보고되고 표시됩니다.

숫자는 블리자드 API에 의해 제공되며 효과의 툴팁에서 발견한 숫자와 일치할 필요는 없습니다.]=]
L["ICONMENU_SHOWTTTEXT_FIRST"] = "첫번째 0이 아닌 변수"
L["ICONMENU_SHOWTTTEXT_FIRST_DESC"] = [=[강화 효과/약화 효과와 연관된 첫번째 0이 아닌 변수를 아이콘의 중첩으로 보고합니다.

일반적으로 효과의 변수 중 하나를 원하면 올바른 변수입니다.

%s|1을;를; 추적 중이면 변수 #1을 명시적으로 관찰해야 합니다.]=]
L["ICONMENU_SHOWTTTEXT_STACKS"] = "중첩 (기본 동작)"
L["ICONMENU_SHOWTTTEXT_STACKS_DESC"] = "강화 효과/약화 효과의 중첩을 아이콘의 중첩으로 보고합니다."
L["ICONMENU_SHOWTTTEXT_VAR"] = "변수 #%d만"
L["ICONMENU_SHOWTTTEXT_VAR_DESC"] = [=[이 변수만 아이콘의 중첩으로 보고되도록 합니다.

가끔 올바르지 않은 변수가 보고될 때 사용하세요. 어느 변수가 올바른지 시행 착오를 겪어 확인하세요.]=]
L["ICONMENU_SHOWTTTEXT2"] = "효과 변수"
L["ICONMENU_SHOWWHEN"] = "불투명도 & 색상"
L["ICONMENU_SHOWWHEN_OPACITY_GENERIC_DESC"] = "이 아이콘 상태일 때 표시될 아이콘의 불투명도를 설정합니다."
L["ICONMENU_SHOWWHEN_OPACITYWHEN_WRAP"] = "%s일 때 불투명도|r"
L["ICONMENU_SHOWWHENNONE"] = "결과 없으면 표시"
L["ICONMENU_SHOWWHENNONE_DESC"] = "어떤 유닛에서도 점감 효과를 발견할 수 없을 때 아이콘을 비점감으로 표시하도록 허용하려면 체크하세요."
L["ICONMENU_SHRINKGROUP"] = "그룹 최소화"
L["ICONMENU_SHRINKGROUP_DESC"] = [=[이 설정을 사용하면 그룹의 경계 상자가 표시된 모든 아이콘에 딱 맞게 유동적으로 조정됩니다.

그룹 배치 방향의 시작점은 그룹의 한쪽 모서리를 형성하고, 이 모서리로부터 가장 먼 아이콘의 가장자리가 다른 쪽을 형성합니다.

위의 표시된 아이콘 정렬 방법과 미세 조정 위치 설정과 함께 사용하면 유동적 중앙 정렬 그룹을 만들 수 있습니다.]=]
L["ICONMENU_SORT_STACKS_ASC"] = "낮은 중첩"
L["ICONMENU_SORT_STACKS_ASC_DESC"] = "체크하면 낮은 중첩 순으로 주문을 표시합니다."
L["ICONMENU_SORT_STACKS_DESC"] = "높은 중첩"
L["ICONMENU_SORT_STACKS_DESC_DESC"] = "체크하면 높은 중첩 순으로 주문을 표시합니다."
L["ICONMENU_SORTASC"] = "짧은 지속시간"
L["ICONMENU_SORTASC_DESC"] = "체크하면 짧은 지속시간 순으로 주문을 표시합니다."
L["ICONMENU_SORTASC_META_DESC"] = "체크하면 짧은 지속시간 순으로 아이콘을 표시합니다."
L["ICONMENU_SORTDESC"] = "긴 지속시간"
L["ICONMENU_SORTDESC_DESC"] = "체크하면 긴 지속시간 순으로 주문을 표시합니다."
L["ICONMENU_SORTDESC_META_DESC"] = "체크하면 긴 지속시간 순으로 아이콘을 표시합니다."
L["ICONMENU_SPELLCAST_COMPLETE"] = "주문 시전 완료/즉시 시전"
L["ICONMENU_SPELLCAST_COMPLETE_DESC"] = [=[내부 재사용 대기시간이 시작되는 경우를 선택하세요:

|cff7fffff1)|r 주문 시전을 완료했을 때, 또는
|cff7fffff2)|r 즉시 시전 부문을 시전했을 때.

%q 편집 상자에 내부 재사용 대기시간을 발동하는 주문 시전의 이름/ID를 입력해야 합니다.   ]=]
L["ICONMENU_SPELLCAST_START"] = "주문 시전 시작"
L["ICONMENU_SPELLCAST_START_DESC"] = [=[내부 재사용 대기시간이 다음 상황에 시작되면 이 옵션을 선택하세요:

|cff7fffff1)|r 주문 시전을 시작할 때.

%q 편집 상자에 내부 재사용 대기시간을 발동하는 주문 시전의 이름/ID를 입력해야 합니다. ]=]
L["ICONMENU_SPELLCOOLDOWN"] = "주문 재사용 대기시간"
L["ICONMENU_SPELLCOOLDOWN_DESC"] = "마법책 주문의 재사용 대기시간을 추적합니다."
L["ICONMENU_SPLIT"] = "새로운 그룹으로 분리"
L["ICONMENU_SPLIT_DESC"] = "새로운 그룹을 만들고 이 아이콘을 이동시킵니다. 많은 그룹 설정이 새로운 그룹으로 옮겨집니다."
L["ICONMENU_SPLIT_GLOBAL"] = "새로운 |cff00c300공통|r 그룹으로 분리"
L["ICONMENU_SPLIT_NOCOMBAT_DESC"] = "전투 중엔 새로운 그룹을 만들 수 없습니다. 새로운 그룹으로 분리하려면 전투를 벗어나세요."
L["ICONMENU_STACKS_MAX_DESC"] = "아이콘에 표시할 최대 중첩 횟수"
L["ICONMENU_STACKS_MIN_DESC"] = "아이콘에 표시할 최소 중첩 횟수"
L["ICONMENU_STATECOLOR"] = "아이콘 색조 & 무늬"
L["ICONMENU_STATECOLOR_DESC"] = [=[이 아이콘 상태일 때 아이콘 무늬의 색조를 설정합니다.

하얀색이 보통입니다. 다른 색상은 무늬를 해당 색상으로 색칠합니다.

이 상태일 때 아이콘에 표시할 무늬를 강제 적용할 수 있습니다.]=]
L["ICONMENU_STATUE"] = "수도사 석상"
L["ICONMENU_STEALABLE"] = "훔칠 수 있는 것만"
L["ICONMENU_STEALABLE_DESC"] = "주문을 훔칠 수 있는 강화 효과만 표시하려면 체크하세요. '마법' 무효화 유형에 대해 확인할 때 사용하는 게 좋습니다. "
L["ICONMENU_SUCCEED2"] = "조건 만족"
L["ICONMENU_SWAPWITH"] = "다음으로 전환:"
L["ICONMENU_SWINGTIMER"] = "자동 공격 타이머"
L["ICONMENU_SWINGTIMER_DESC"] = "주장비와 보조장비 무기의 자동 공격 타이머를 추적합니다."
L["ICONMENU_SWINGTIMER_NOTSWINGING"] = "공격 중지 중"
L["ICONMENU_SWINGTIMER_SWINGING"] = "자동 공격 중"
L["ICONMENU_TARGETTARGET"] = "대상의 대상"
L["ICONMENU_TOTEM"] = "토템"
L["ICONMENU_TOTEM_DESC"] = "토템을 추적합니다."
L["ICONMENU_TOTEM_GENERIC_DESC"] = "%s|1을;를; 추적합니다."
L["ICONMENU_TYPE"] = "아이콘 유형"
L["ICONMENU_TYPE_CANCONTROL"] = "이 아이콘 유형은 그룹의 첫번째 아이콘으로 설정되면 전체 그룹을 제어할 수 있습니다."
L["ICONMENU_TYPE_DISABLED_BY_VIEW"] = "이 아이콘 유형은 %q 표시 방법에 사용할 수 없습니다. 이 그룹의 표시 방법을 변경하거나 이 아이콘 유형을 사용할 새로운 그룹을 만드세요."
L["ICONMENU_UIERROR"] = "전투 오류 이벤트"
L["ICONMENU_UIERROR_DESC"] = [=[UI 오류 메시지를 추적합니다.

예를 들어 "당신은 죽었습니다" 와 "대상이 없습니다" 같은 것들이 포함됩니다.]=]
L["ICONMENU_UNIT_DESC"] = [=[이 상자에 관찰할 유닛을 입력하세요. 오른쪽의 추천 목록에서 입력할 수 있으며, 고급 사용자는 유닛을 직접 입력할 수 있습니다.

표준 유닛 (예. 플레이어)과 또는 같은 파티나 공격대 내에 있는 플레이어의 이름은 유닛으로 사용할 수 있습니다.

어려 유닛은 세미콜론 (;)으로 분리하세요.

유닛에 대한 더 자세한 정보는, http://www.wowpedia.org/UnitId 에서 확인하세요.]=]
L["ICONMENU_UNIT_DESC_CONDITIONUNIT"] = [=[이 상자에 관찰할 유닛을 입력하세요. 오른쪽의 추천 목록에서 입력할 수 있으며, 고급 사용자는 유닛을 직접 입력할 수 있습니다.

표준 유닛 (예. 플레이어)과 또는 같은 파티나 공격대 내에 있는 플레이어의 이름은 유닛으로 사용할 수 있습니다.

어려 유닛은 세미콜론 (;)으로 분리하세요.

유닛에 대한 더 자세한 정보는, http://www.wowpedia.org/UnitId 에서 확인하세요.]=]
L["ICONMENU_UNIT_DESC_UNITCONDITIONUNIT"] = [=[이 상자에 관찰할 유닛을 입력하세요. 오른쪽의 추천 목록에서 입력할 수 있습니다.

"unit"은 아이콘이 확인 중인 각 유닛을 대체합니다.]=]
L["ICONMENU_UNITCNDTIC"] = "유닛 조건 아이콘"
L["ICONMENU_UNITCNDTIC_DESC"] = [=[여러 유닛의 조건 상태를 추적합니다.

이 아이콘에 구성된 설정은 확인 중인 각 유닛에 적용됩니다.]=]
L["ICONMENU_UNITCOOLDOWN"] = "유닛 재사용 대기시간"
L["ICONMENU_UNITCOOLDOWN_DESC"] = [=[누군가의 재사용 대기시간을 추적합니다.

%q|1을;를; 사용하여 %s|1을;를; 동시에 추적할 수 있습니다.]=]
L["ICONMENU_UNITFAIL"] = "유닛의 조건 실패"
L["ICONMENU_UNITS"] = "유닛"
L["ICONMENU_UNITSTOWATCH"] = "관찰할 대상"
L["ICONMENU_UNITSUCCEED"] = "유닛의 조건 만족"
L["ICONMENU_UNUSABLE"] = "사용할 수 없음"
L["ICONMENU_UNUSABLE_DESC"] = "위의 상태가 활성화되지 않았을 때 이 상태가 활성화됩니다. 0%의 불투명도를 가진 상태는 활성화되지 않습니다."
L["ICONMENU_USABLE"] = "사용 가능"
L["ICONMENU_USEACTIVATIONOVERLAY"] = "활성화 테두리 확인"
L["ICONMENU_USEACTIVATIONOVERLAY_DESC"] = "아이콘이 사용 가능한 것으로 보이게끔 테두리 주변에 노란 불꽃을 표시하려면 체크하세요."
L["ICONMENU_VALUE"] = "자원 표시"
L["ICONMENU_VALUE_DESC"] = "유닛의 자원 (체력, 마나, 등등)을 표시합니다."
L["ICONMENU_VALUE_HASUNIT"] = "유닛 발견"
L["ICONMENU_VALUE_NOUNIT"] = "유닛 없음"
L["ICONMENU_VALUE_POWERTYPE"] = "자원 유형"
L["ICONMENU_VALUE_POWERTYPE_DESC"] = "아이콘에 추적할 자원을 설정합니다."
L["ICONMENU_VEHICLE"] = "차량"
L["ICONMENU_VIEWREQ"] = "그룹 표시 방법과 미호환"
L["ICONMENU_VIEWREQ_DESC"] = [=[아 아이콘 유형은 모든 데이터를 표시하는 데 필요한 구성 요소가 없어서 이 그룹의 현재 표시 방법으로 사용할 수 없습니다.

그룹의 표시 방법을 변경하거나 이 아이콘 유형을 사용할 새로운 그룹을 만드세요.]=]
L["ICONMENU_WPNENCHANT"] = "무기 마법부여"
L["ICONMENU_WPNENCHANT_DESC"] = "임시 무기 마법부여를 추적합니다."
L["ICONMENU_WPNENCHANTTYPE"] = "관찰할 무기 칸"
L["IconModule_CooldownSweepCooldown"] = "재사용 대기시간 나선"
L["IconModule_IconContainer_MasqueIconContainer"] = "아이콘 컨테이너"
L["IconModule_IconContainer_MasqueIconContainer_DESC"] = "아이콘의 무늬 같은 주요 부분을 유지합니다"
L["IconModule_PowerBar_OverlayPowerBar"] = "자원 바 오버레이"
L["IconModule_SelfIcon"] = "아이콘"
L["IconModule_Texture_ColoredTexture"] = "아이콘 무늬"
L["IconModule_TimerBar_BarDisplayTimerBar"] = "타이머 바"
L["IconModule_TimerBar_OverlayTimerBar"] = "타이머 바 오버레이"
L["ICONTOCHECK"] = "확인할 아이콘"
L["ICONTYPE_DEFAULT_HEADER"] = "명령"
L["ICONTYPE_DEFAULT_INSTRUCTIONS"] = [=[시작하려면 위의 %q 드롭다운 메뉴에서 아이콘 유형을 선택하세요.

아이콘은 TellMeWhen이 잠겨있을 때만 작동합니다, 따라서 완료 후 '/tmw'를 입력하세요.

TellMeWhen을 설정할 때 각 설정의 툴팁을 읽어보세요. 툴팁은 설정 방법에 대한 중요한 정보를 포함하고 있습니다!]=]
L["ICONTYPE_SWINGTIMER_TIP"] = [=[%s의 타이머를 추적하고 싶나요? %s 아이콘 형식이 당신이 원하는 기능을 가지고 있습니다. %s 아이콘이 %q|1을;를; 추적하도록 설정하세요 (주문ID %d)!

아래 버튼을 클릭하면 적절한 설정을 자동으로 적용할 수 있습니다.]=]
L["ICONTYPE_SWINGTIMER_TIP_APPLYSETTINGS"] = "%s 설정 적용"
L["IE_NOLOADED_GROUP"] = "불러올 그룹 선택:"
L["IE_NOLOADED_ICON"] = "불러온 아이콘 없음!"
L["IE_NOLOADED_ICON_DESC"] = [=[아이콘을 불러오려면 아이콘을 오른쪽 클릭하세요.

화면에 표시할 수 있는 아이콘이 없다면 하단의 %s 탭을 클릭하세요.

거기에서 새로운 그룹을 추가하거나 존재하는 그룹을 사용할 수 있도록 설정할 수 있습니다.

'/tmw'를 입력하면 설정 모드를 끕니다.]=]
L["ImmuneToMagicCC"] = "마법 CC에 면역"
L["ImmuneToStun"] = "기절에 면역"
L["IMPORT_EXPORT"] = "가져오기/내보내기/복원하기"
L["IMPORT_EXPORT_BUTTON_DESC"] = "아이콘, 그룹, 그리고 프로필을 가져오거나 내보내려면 이 버튼을 클릭하세요."
L["IMPORT_EXPORT_DESC"] = [=[아이콘, 그룹, 프로필을 가져오거나 내보내려면 오른쪽의 버튼을 클릭하세요.

문자열에서 가져오거나 다른 플레이어로 내보낼 때 이 편집상자의 사용을 필요로 합니다. 자세한 내용은 드롭다운 메뉴에서 툴팁을 확인하세요.]=]
L["IMPORT_FAILED"] = "가져오기 실패!"
L["IMPORT_FROMBACKUP"] = "백업본에서"
L["IMPORT_FROMBACKUP_DESC"] = "이 메뉴로부터 설정이 복원되었습니다: %s"
L["IMPORT_FROMBACKUP_WARNING"] = "백업본 설정: %s"
L["IMPORT_FROMCOMM"] = "플레이어로부터"
L["IMPORT_FROMCOMM_DESC"] = "다른 TellMeWhen 사용자가 당신에게 구성 데이터를 보내면, 이 메뉴를 통해서 해당 데이터를 가져올 수 있습니다."
L["IMPORT_FROMLOCAL"] = "프로필에서"
L["IMPORT_FROMSTRING"] = "문자열에서"
L["IMPORT_FROMSTRING_DESC"] = [=[TellMeWhen 구성 데이터를 게임 외부로 전송할 수 있는 문자열입니다.

문자열로부터 가져오려면, 클립보드에 문자열을 복사한 후 CTRL+V를 눌러 문자열을 편집상자에 붙여넣기한 후, 이 하위메뉴로 돌아오세요.]=]
L["IMPORT_GROUPIMPORTED"] = "그룹 가져옴!"
L["IMPORT_GROUPNOVISIBLE"] = "그룹 구성과 당신의 현재 직업과 전문화때문에 가져오기 한 그룹이 표시되지 않습니다. TMW의 그룹 옵션에서 설정을 확인하세요 - '/tmw options'."
L["IMPORT_HEADING"] = "가져오기"
L["IMPORT_ICON_DISABLED_DESC"] = "아이콘을 가져오려면 아이콘을 편집해야 합니다."
L["IMPORT_LUA_CONFIRM"] = "Ok, 이것을 가져옵니다"
L["IMPORT_LUA_DENY"] = "가져오기 조작 취소"
L["IMPORT_LUA_DESC"] = [=[가져오기한 데이터에 TellMeWhen이 실행할 수 있는 Lua 코드를 포함하고 있습니다.

악의적 목적으로 사용될 수 있기때문에 신뢰할 수 없는 출처로부터 Lua 코드를 가져올 때는 주의해야 합니다. 대부분 안전하지만 당신에게 잘못된 방법으로 사용하는 사람이 있습니다.

코드를 살펴본 후 신뢰할 수 있는 출처에서 왔는지 또는 우편을 보내거나 거래를 수락하는 등의 동작을 하지 않는 지 확인하세요.]=]
L["IMPORT_LUA_DESC2"] = "|TInterface/AddOns/TellMeWhen/Textures/Alert:0:2|t 빨간색 코드 부분을 살펴보세요, 보통 악의적 활동을 나타내는 단어/구문입니다. |TInterface/AddOns/TellMeWhen/Textures/Alert:0:2|t"
L["IMPORT_NEWGUIDS"] = [=[가져오기한 데이터가 %d개의 그룹과 %d개의 아이콘의 고유 식별자와 문제를 일으켰습니다. 이것은 아마도 예전에 이 데이터를 가져왔거나, 데이터의 구 버전을 가져왔었던 걸 의미합니다.

가져온 데이터에 새로운 고유 식별자가 지정되었습니다. 앞으로 가져오기할 아이콘은 새로운 데이터를 참조해야만 의도한 대로 기능합니다 - 새로운 데이터와 문제를 일으킨 오래된 아이콘을 참조합니다.

기존 데이터를 교체하려면, 올바른 위치에 다시 가져오기 해주세요.]=]
L["IMPORT_PROFILE"] = "프로필 복사"
L["IMPORT_PROFILE_NEW"] = "새 프로필 |cff59ff59생성|r"
L["IMPORT_PROFILE_OVERWRITE"] = "%s |cFFFF5959덮어쓰기|r"
L["IMPORT_SUCCESSFUL"] = "가져오기 성공!"
L["IMPORTERROR_FAILEDPARSE"] = "문자열을 처리하는 도중 오류가 발생했습니다. 출처에서 문자열 전체가 복사되었는지 확인하세요."
L["IMPORTERROR_INVALIDTYPE"] = "알 수 없는 유형의 데이터를 가져오려고 시도했습니다. 최신 버전의 TellMeWhen이 설치되어 있는지 확인해보세요."
L["Incapacitated"] = "움직이지 못함"
L["INCHEALS"] = "유닛 받는 치유"
L["INCHEALS_DESC"] = [=[유닛이 받는 총 치유량을 확인합니다 (진행 중인 HoT와 시전).

우호적 유닛만 작동합니다. 적대적 유닛은 항상 0의 치유량이 보고됩니다.]=]
L["INRANGE"] = "사정 거리 내"
L["ITEMCOOLDOWN"] = "아이템 재사용 대기시간"
L["ITEMEQUIPPED"] = "착용 중인 아이템"
L["ITEMINBAGS"] = "아이템 갯수 (충전량 포함)"
L["ITEMSPELL"] = "사용 효과를 가진 아이템"
L["ITEMTOCHECK"] = "확인할 아이템"
L["ITEMTOCOMP1"] = "비교할 첫번째 아이템 "
L["ITEMTOCOMP2"] = "비교할 두번째 아이템 "
L["LAYOUTDIRECTION"] = "배치 방향"
L["LAYOUTDIRECTION_PRIMARY_DESC"] = "아이콘의 주 배치 방향을 %s 방향으로 확장시킵니다."
L["LAYOUTDIRECTION_SECONDARY_DESC"] = "아이콘의 연속 행/열을 %s 방향으로 확장시킵니다."
L["LDB_TOOLTIP1"] = "|cff7fffff왼쪽 클릭|r: 그룹 잠금 전환"
L["LDB_TOOLTIP2"] = "|cff7fffff오른쪽 클릭|r: 아이콘 편집기 표시"
L["LEFT"] = "좌측"
L["LOADERROR"] = "TellMeWhen_Options를 불러올 수 없습니다: "
L["LOADINGOPT"] = "TellMeWhen_Options를 불러옵니다."
L["LOCKED"] = "잠금"
L["LOCKED2"] = "위치가 잠겼습니다."
L["LOSECONTROL_CONTROLLOST"] = "제어 상실"
L["LOSECONTROL_DROPDOWNLABEL"] = "제어 불가 유형"
L["LOSECONTROL_DROPDOWNLABEL_DESC"] = "아이콘이 반응할 제어 불가 유형을 선택하세요."
L["LOSECONTROL_ICONTYPE"] = "제어 불가"
L["LOSECONTROL_ICONTYPE_DESC"] = "캐릭터를 제어 불가 상태로 만드는 효과를 추적합니다."
L["LOSECONTROL_INCONTROL"] = "제어 중"
L["LOSECONTROL_TYPE_ALL"] = "모든 유형"
L["LOSECONTROL_TYPE_ALL_DESC"] = "아이콘이 효과의 모든 유형에 대한 정보를 표시하도록 합니다."
L["LOSECONTROL_TYPE_DESC_USEUNKNOWN"] = "참고: 이 제어 불가 유형의 사용 여부가 알려지지 않았습니다."
L["LOSECONTROL_TYPE_MAGICAL_IMMUNITY"] = "마법 면역"
L["LOSECONTROL_TYPE_SCHOOLLOCK"] = "주문 속성 잠금"
L["LUA_INSERTGUID_TOOLTIP"] = "|cff7fffffShift-클릭|r하여 아이콘에 대한 참조를 코드에 삽입합니다."
L["LUACONDITION"] = "Lua (전문가)"
L["LUACONDITION_DESC"] = [=[이 조건 유형은 Lua 코드를 평가하여 조건의 상태를 판단할 수 있도록 허용합니다.

입력문은 'if .. then' 구문이 아니며, 종결 함수도 아닙니다. 평가하기 위한 일반적인 구문입니다, 예. 'a and b or c'. 복합 함수가 필요하다면, 외부에서 정의한 함수를 호출하세요, 예. 'CheckStuff()' (아마도 TMW의 Lua 코드 조각 기능을 사용하여).

이 아이콘/그룹에 참조를 획득하려면, 'thisobj'를 사용하세요. GUID로 다른 아이콘에 참조를 삽입하려면, 이 편집 상자를 활성화 중일 때 아이콘을 Shift 클릭하세요.

도움이 더 필요하다면 (Lua 코드 작성법에 관한 도움은 아닙니다), CurseForge에 티켓을 열어주세요. Lua 작성법에 도움을 받고싶다면, 인터넷을 검색해보세요.]=]
L["LUACONDITION2"] = "Lua 조건"
L["MACROCONDITION"] = "매크로 조건"
L["MACROCONDITION_DESC"] = [=[이 조건은 매크로 조건을 평가하며, 매크로 조건 통과시 조건도 통과합니다.
모든 매크로 조건은 앞에 "no"를 붙여 반대되는 조건을 만들 수 있습니다.

예제: 
   "[nomodifier:alt]" - alt 키를 누르고 있지 않을 때.
   "[@target, help][mod:ctrl]" - 대상이 우호적이거나 ctrl 키를 누르고 있을 때
   "[@focus, harm, nomod:shift]" - 주시 대상이 적대적이면서 shift 키를 누르고 있지 않을 때

자세한 정보는, http://www.wowpedia.org/Making_a_macro 를 확인하세요.]=]
L["MACROCONDITION_EB_DESC"] = [=[단일 조건을 사용하면, 괄호의 열고 닫기는 선택적입니다.
복수 조건을 사용할 때 괄호가 필요합니다.]=]
L["MACROTOEVAL"] = "평가할 매크로 조건"
L["Magic"] = "마법"
L["MAIN"] = "일반"
L["MAIN_DESC"] = "이 아이콘의 주 옵션을 포함합니다."
L["MAINASSIST"] = "지원 전담"
L["MAINASSIST_DESC"] = "공격대에서 지원 전담으로 지정된 유닛을 추적합니다."
L["MAINOPTIONS_SHOW"] = "그룹 옵션"
L["MAINTANK"] = "방어 전담"
L["MAINTANK_DESC"] = "공격대에서 방어 전담으로 지정된 유닛을 추적합니다."
L["MAKENEWGROUP_GLOBAL"] = "새로운 |cff00c300공통|r 그룹 |cff59ff59만들기|r"
L["MAKENEWGROUP_PROFILE"] = "새로운 프로필 그룹 |cff59ff59만들기|r"
L["MESSAGERECIEVE"] = "%s님이 TellMeWhen 데이터를 보냈습니다! 아이콘 편집기의 하단에 위치한 %q 버튼을 사용하여 데이터를 TellMeWhen으로 가져올 수 있습니다."
L["MESSAGERECIEVE_SHORT"] = "%s님이 TellMeWhen 데이터를 보냈습니다!"
L["META_ADDICON"] = "아이콘 추가"
L["META_ADDICON_DESC"] = "이 메타 아이콘에 포함시킬 다른 아이콘을 추가하려면 클릭하세요."
L["META_GROUP_INVALID_VIEW_DIFFERENT"] = [=[다른 표시 방법을 사용해서 이 메타 아이콘이 이 그룹에 있는 아이콘을 확인할 수 없습니다.

이 그룹: %s
대상 그룹: %s]=]
L["METAPANEL_DOWN"] = "아래로 이동"
L["METAPANEL_REMOVE"] = "아이콘 제거"
L["METAPANEL_REMOVE_DESC"] = "메타 아이콘이 확인할 목록에서 이 아이콘을 제거하려면 클릭하세요."
L["METAPANEL_UP"] = "위로 이동"
L["minus"] = "하수인"
L["MISCELLANEOUS"] = "기타"
L["MiscHelpfulBuffs"] = "기타 이로운 강화 효과"
L["MODTIMER_PATTERN"] = "Lua 패턴 일치 허용"
L["MODTIMER_PATTERN_DESC"] = [=[기본적으로 이 조건은 당신이 입력한 문자를 포함한 모든 타이머의 이름과 일치시키며 대/소문자를 구분하지 않습니다.

이 설정을 활성화하면 입력 내용이 Lua 스타일 strmatch 패턴으로 사용됩니다.

타이머 이름과 정확히 일치시키려면, ^timer name$ 을 입력하세요. TMW는 타이머 이름을 소문자로 저장하므로, 이 이름은 소문자로 타이머 이름과 반드시 일치해야 합니다.

자세한 정보는 http://wowpedia.org/Pattern_matching 에서 확인하세요]=]
L["MODTIMERTOCHECK"] = "확인할 타이머"
L["MODTIMERTOCHECK_DESC"] = "우두머리 모듈의 타이머 바에 나타나는 타이머의 전체 또는 부분 이름을 입력하세요."
L["MOON"] = "달"
L["MOUSEOVER_TOKEN_NOT_FOUND"] = "<마우스오버 없음>"
L["MOUSEOVERCONDITION"] = "마우스 올려짐"
L["MOUSEOVERCONDITION_DESC"] = "조건이 지정된 아이콘이나 그룹에 마우스가 올려져 있는지 확인하는 조건입니다."
L["MP5"] = "%d MP5"
L["MUSHROOM"] = "%d 버섯"
L["NEWVERSION"] = "TellMeWhen의 새 버전이 이용 가능합니다: %s"
L["NOGROUPS_DIALOG_BODY"] = [=[당신의 현재 TellMeWhen 구성과/또는 플레이어 전문화가 어떤 TellMeWhen 그룹도 표시되도록 허용하지 않았습니다, 따라서 설정할 것이 없습니다.

존재하는 그룹의 설정을 변경하거나 새로운 그룹을 만드려면, '/tmw options'를 입력하여 TellMeWhen의 그룹 옵션을 열거나 하단의 버튼을 클릭하세요.

'/tmw'를 입력하면 설정 모드를 종료합니다.]=]
L["NONE"] = "이것들 중 아무것도 아닌"
L["normal"] = "일반"
L["NOTINRANGE"] = "사정 거리 벗어남"
L["NOTYPE"] = "<아이콘 형식 없음>"
L["NUMAURAS"] = "갯수: "
L["NUMAURAS_DESC"] = "이 조건은 활성화된 오라의 갯수를 확인합니다 - 오라의 중첩 횟수와 혼동하지 마세요. 동시에 두개의 무기 마법부여 발동 활성화 같은 것을 확인합니다. 숫자를 세는 데 사용되는 처리 과정이 CPU를 많이 사용하므로 적게 사용하세요."
L["ONLYCHECKMINE"] = "내가 시전한 것만"
L["ONLYCHECKMINE_DESC"] = "이 조건이 자신이 시전한 강화 효과/약화 효과만 확인하게 하려면 체크하세요."
L["OPERATION_DIVIDE"] = "나누기"
L["OPERATION_MINUS"] = "빼기"
L["OPERATION_MULTIPLY"] = "곱하기"
L["OPERATION_PLUS"] = "더하기"
L["OPERATION_SET"] = "집합"
L["OPERATION_TPAUSE"] = "일시정지"
L["OPERATION_TPAUSE_DESC"] = "타이머를 일시정지 합니다."
L["OPERATION_TRESET"] = "초기화"
L["OPERATION_TRESET_DESC"] = "타이머를 0으로 초기화 합니다. 작동 중에는 멈추지 않습니다."
L["OPERATION_TRESTART"] = "재시작"
L["OPERATION_TRESTART_DESC"] = "타이머를 0으로 초기화하고, 작동 중이 아니면 시작합니다."
L["OPERATION_TSTART"] = "시작"
L["OPERATION_TSTART_DESC"] = "작동 중이 아니면 타이머를 시작합니다. 초기화하지 않습니다."
L["OPERATION_TSTOP"] = "중단"
L["OPERATION_TSTOP_DESC"] = "타이머를 멈추고 0으로 초기화합니다."
L["OUTLINE_MONOCHORME"] = "흑백"
L["OUTLINE_NO"] = "외곽선 없음"
L["OUTLINE_THICK"] = "굵은 외곽선"
L["OUTLINE_THIN"] = "얇은 외곽선 "
L["PARENTHESIS_TYPE_("] = "열기"
L["PARENTHESIS_TYPE_)"] = "닫기"
L["PARENTHESIS_WARNING1"] = [=[열고 닫는 괄호의 숫자가 일치하지 않습니다!

%d개의 %s 괄호가 필요합니다.]=]
L["PARENTHESIS_WARNING2"] = [=[일부 닫기 괄호가 열기 괄호가 없습니다!

%d개의 열기 괄호가 필요합니다.]=]
L["PERCENTAGE"] = "백분율"
L["PERCENTAGE_DEPRECATED_DESC"] = [=[백분율 조건은 속임수때문에 사용되지 않습니다.

드레노어의 전쟁군주에서, 강화 효과/약화 효과의 기존 지속시간을 버리지 않고 새로 고침할 수 있는 시점은 현재 지속시간이 아닌 효과의 기본 지속시간의 30%입니다.

이 조건들을 사용하여 강화 효과/약화 효과가 30% 이하로 남았는 지 확인하는 것은 좋지 않습니다, 왜냐하면 이미 확장된 효과는 30%가 남은 시점에서 새로 적용하면 효과의 일부를 버리게 됩니다.

대신, 확인하고 싶은 효과의 기본 지속시간 중 30%를 수동으로 계산하고 그 값과 비교해야 합니다.]=]
L["PET_TYPE_CUNNING"] = "교활함"
L["PET_TYPE_FEROCITY"] = "흉포함"
L["PET_TYPE_TENACITY"] = "강인함"
L["PLAYER_DESC"] = "'플레이어' 유닛은 자신입니다."
L["Poison"] = "독"
L["PROFILE_LOADED"] = "프로필 불러옴: %s"
L["PROFILES_COPY"] = "프로필 복사..."
L["PROFILES_COPY_CONFIRM"] = "프로필 복사"
L["PROFILES_COPY_CONFIRM_DESC"] = "프로필 %q|1이;가; %q 프로필의 복사본으로 덮어 씌워집니다."
L["PROFILES_COPY_DESC"] = [=[복사해 올 다른 프로필을 선택하세요. 선택한 프로필로 현재 프로필을 덮어씁니다.

%2$q 메뉴 하단에 있는 %1$q 옵션을 사용하여 다음 접속 종료나 다시 불러오기 전까지 이 작업을 실행 취소할 수 있습니다.]=]
L["PROFILES_DELETE"] = "프로필 삭제..."
L["PROFILES_DELETE_CONFIRM"] = "프로필 삭제"
L["PROFILES_DELETE_CONFIRM_DESC"] = "프로필 %q|1이;가; 삭제됩니다."
L["PROFILES_DELETE_DESC"] = [=[삭제할 프로필을 선택하세요.

%2$q 메뉴 하단에 있는 %1$q 옵션을 사용하여 다음 접속 종료나 다시 불러오기 전까지 이 작업을 실행 취소할 수 있습니다.]=]
L["PROFILES_NEW"] = "새 프로필"
L["PROFILES_NEW_DESC"] = "새 프로필의 이름을 입력하고 엔터를 눌러 생성합니다."
L["PROFILES_SET"] = "프로필 변경..."
L["PROFILES_SET_DESC"] = "전환할 다른 프로필을 선택하세요."
L["PROFILES_SET_LABEL"] = "현재 프로필"
L["PvPSpells"] = "PvP 군중 제어, 등등."
L["QUESTIDTOCHECK"] = "확인할 퀘스트ID"
L["RAID_WARNING_FAKE"] = "공격대 경보 (가짜)"
L["RAID_WARNING_FAKE_DESC"] = "공격대 경보로 메시지를 출력하지만, 다른 누구도 볼수 없으며 공격대 경보 권한이나 공격대에 속해 있지 않아도 됩니다."
L["RaidWarningFrame"] = "공격대 경보 프레임"
L["rare"] = "희귀"
L["rareelite"] = "희귀 정예"
L["REACTIVECNDT_DESC"] = "이 조건은 능력의 재사용 대기시간이 아닌 반응 상태만 확인합니다."
L["REDO"] = "다시 실행"
L["REDO_DESC"] = "이 설정들을 만든 마지막 변경을 다시 실행합니다."
L["ReducedHealing"] = "치유량 감소"
L["REQFAILED_ALPHA"] = "실패 시 불투명도"
L["RESET_ICON"] = "초기화"
L["RESET_ICON_DESC"] = "이 아이콘의 모든 설정을 기본값으로 초기화합니다."
L["RESIZE"] = "크기 조절"
L["RESIZE_GROUP_CLOBBERWARN"] = "|cff7fffff오른쪽 클릭하고 끌기|r를 사용하여 그룹을 축소하면, 몇몇 아이콘이 잘릴 수 있습니다. 이 아이콘들은 임시로 저장되며  |cff7fffff오른쪽 클릭하고 끌기|r로 크기를 다시 늘리면 복원됩니다, 하지만 접속 종료나 UI를 다시 불러오면 영원히 잃게 됩니다."
L["RESIZE_TOOLTIP"] = "|cff7fffff클릭하고 끌어서|r 크기 조절"
L["RESIZE_TOOLTIP_CHANGEDIMS"] = "|cff7fffff오른쪽 클릭하고 끌어서|r 그룹과 열의 숫자 변경"
L["RESIZE_TOOLTIP_IEEXTRA"] = "일반 옵션에서 크기 변경을 사용합니다."
L["RESIZE_TOOLTIP_SCALEX_SIZEY"] = "|cff7fffff클릭하고 끌어서|r 크기 비율 조절"
L["RESIZE_TOOLTIP_SCALEXY"] = [=[|cff7fffff클릭하고 끌어서|r 크기 비율 조절
|cff7fffffControl을 누른 상태면|r 크기 비율 축 반전]=]
L["RESIZE_TOOLTIP_SCALEY_SIZEX"] = "|cff7fffff클릭하고 끌어서|r 크기 비율 조절"
L["RIGHT"] = "오른쪽"
L["ROLEf"] = "역할: %s"
L["Rooted"] = "이동 불가"
L["RUNEOFPOWER"] = "룬 %d"
L["RUNES"] = "확인할 룬"
L["RUNSPEED"] = "유닛 달리기 속도"
L["RUNSPEED_DESC"] = "유닛이 현재 이동 중이지 않아도, 유닛의 최대 달리기 속도를 나타냅니다."
L["SAFESETUP_COMPLETE"] = "안전 & 느린 설정 완료."
L["SAFESETUP_FAILED"] = "안전 & 느린 설정 실패: %s"
L["SAFESETUP_TRIGGERED"] = "안전 & 느린 설정 실행 중..."
L["SEAL"] = "문장"
L["SENDSUCCESSFUL"] = "성공적으로 보냈습니다"
L["SHAPESHIFT"] = "변신"
L["Shatterable"] = "산산조각 가능"
L["SHOWGUIDS_OPTION"] = "툴팁에 GUID를 표시합니다."
L["SHOWGUIDS_OPTION_DESC"] = "그룹이나 아이콘의 GUID (전역-고유 식별자)를 툴팁에 표시하려면 이 설정을 활성화하세요. 아이콘과 연관된 GUID를 알고 싶을 때 유용할 수 있습니다."
L["Silenced"] = "침묵"
L["Slowed"] = "느려짐"
L["SORTBY"] = "우선 순위 지정"
L["SORTBYNONE"] = "일반"
L["SORTBYNONE_DESC"] = [=[체크하면, 주문이 "%s" 편집상자에 입력된 순서대로 확인되고 나타납니다.

이 아이콘이 강화 효과/약화 효과 아이콘이고 확인 중인 효과의 갯수가 효율 한계 설정을 초과하면, 효과는 유닛의 유닛 프레임에 나타나는 일반적인 순서로 확인됩니다.]=]
L["SORTBYNONE_DURATION"] = "일반 지속시간"
L["SORTBYNONE_META_DESC"] = "체크하면, 아이콘은 위에 설정된 순서대로 확인됩니다."
L["SORTBYNONE_STACKS"] = "일반 중첩"
L["SOUND_CHANNEL"] = "소리 채널"
L["SOUND_CHANNEL_DESC"] = [=[소리를 재생할 때 사용할 소리 채널과 음량 설정을 선택하세요.

%q|1을;를; 선택하면 소리 설정이 꺼져 있을 때도 소리가 재생됩니다.]=]
L["SOUND_CHANNEL_MASTER"] = "주 채널"
L["SOUND_CUSTOM"] = "사용자 설정 소리 파일"
L["SOUND_CUSTOM_DESC"] = [=[재생할 사용자 설정 소리 파일의 경로를 입력하세요. 숫자로 된 소리 Kit ID를 입력할 수 있습니다.

몇가지 예제가 있습니다, "file"은 소리 파일의 이름이며, "ext"는 파일의 확장자입니다 (ogg 또는 mp3 만 가능!):

- "CustomSounds/file.ext": WoW의 루트 디렉토리에 있는 "CustomSounds"라는 이름의 새로운 폴더에 위치한 파일 (같은 위치로 Wow.exe, Interface와 WTF 폴더, 등이 있습니다)

- "Interface/AddOns/file.ext": AddOns 폴더에 있는 파일

- "file.ext": WoW의 루트 디렉토리에 있는 파일

참고: WoW를 시작할 때 존재하지 않았던 파일을 인식하려면 먼저 재시작해야 하니다.]=]
L["SOUND_ERROR_ALLDISABLED"] = [=[게임 소리가 완전히 꺼져있어서 이 소리를 테스트할 수 없습니다.

블리자드의 소리 옵션에서 설정을 변경하세요.]=]
L["SOUND_ERROR_DISABLED"] = [=[%q 소리 채널이 꺼져있어서 이 소리를 테스트할 수 없습니다.

블리자드의 소리 옵션에서 설정을 변경하세요.

또한, TellMeWhen의 주 옵션에서 사용하도록 설정한 소리 채널을 변경할 수 있습니다 ('/tmw options')]=]
L["SOUND_ERROR_MUTED"] = [=[%q 소리 채널의 음량이 0으로 설정되어 있어서 이 소리를 테스트할 수 없습니다.

블리자드의 소리 옵션에서 설정을 변경하세요.

또한, TellMeWhen의 주 옵션에서 사용하도록 설정한 소리 채널을 변경할 수 있습니다 ("/tmw options')]=]
L["SOUND_EVENT_DISABLEDFORTYPE"] = "사용할 수 없음"
L["SOUND_EVENT_DISABLEDFORTYPE_DESC2"] = [=[이 이벤트는 현재 아이콘 구성에 사용할 수 없습니다.

아마도 이 이벤트는 현재 아이콘 형식 (%s)에 사용할 수 없기 때문일 수 있습니다.

|cff7fffff오른쪽 클릭|r으로 이벤트를 변경합니다.]=]
L["SOUND_EVENT_NOEVENT"] = "구성되지 않은 이벤트"
L["SOUND_EVENT_ONALPHADEC"] = "불투명도 감소 시"
L["SOUND_EVENT_ONALPHADEC_DESC"] = [=[이 이벤트는 아이콘의 불투명도가 감소될 때 발동합니다.

참고: 이 이벤트는 0% 불투명도로 감소할 때는 발동하지 않습니다 (숨길 시).]=]
L["SOUND_EVENT_ONALPHAINC"] = "불투명도 증가 시"
L["SOUND_EVENT_ONALPHAINC_DESC"] = [=[이 이벤트는 아이콘의 불투명도가 증가할 때 발동합니다.

주의: 이 이벤트는 0% 불투명도에서 증가할 때는 발동하지 않습니다 (표시될 때).]=]
L["SOUND_EVENT_ONCHARGEGAINED"] = "충전량 획득 시"
L["SOUND_EVENT_ONCHARGEGAINED_DESC"] = "추적 중인 능력의 충전량을 얻으면 이 이벤트가 발생합니다."
L["SOUND_EVENT_ONCHARGELOST"] = "충전량 소비 시"
L["SOUND_EVENT_ONCHARGELOST_DESC"] = "추적 중인 능력의 충전량이 사용되면 이 이벤트가 발생합니다."
L["SOUND_EVENT_ONCLEU"] = "전투 이벤트 발생 시"
L["SOUND_EVENT_ONCLEU_DESC"] = "이 이벤트는 아이콘이 전투 이벤트를 처리할 때 발동합니다."
L["SOUND_EVENT_ONCONDITION"] = "조건 세트 만족 시"
L["SOUND_EVENT_ONCONDITION_DESC"] = "이 이벤트에 대해 구성할 수 있는 조건의 세트가 만족할 때 발동합니다."
L["SOUND_EVENT_ONDURATION"] = "지속시간 변경 시"
L["SOUND_EVENT_ONDURATION_DESC"] = [=[이 이벤트는 아이콘의 지속시간 타이머가 변경될 때 발동합니다.

이 이벤트는 타이머가 작동하는 동안 아아콘이 갱신될 때마다 발생하기 때문에 해당 조건의 상태가 변경될 때만 발생하도록 조건을 설정해야만 합니다.]=]
L["SOUND_EVENT_ONEVENTSRESTORED"] = "아이콘 구성 시"
L["SOUND_EVENT_ONEVENTSRESTORED_DESC"] = [=[이 이벤트는 이 아이콘이 구성된 후 즉시 발동합니다.

이것은 주로 설정 모드를 종료하면 발생하지만, 다른 것들 중에서 지역에 입장/퇴장할 때 발생하기도 합니다.

이것은 아이콘의 "소프트 초기화"로도 생각할 수 있습니다.

이 이벤트는 아이콘의 기본 상태를 만들 때 유용할 수 있습니다.]=]
L["SOUND_EVENT_ONFINISH"] = "종료 시"
L["SOUND_EVENT_ONFINISH_DESC"] = "이 이벤트는 재사용 대기시간이 끝나거나, 강화 효과/약화 효과가 사라지면 발동합니다."
L["SOUND_EVENT_ONHIDE"] = "숨기기 시"
L["SOUND_EVENT_ONHIDE_DESC"] = "이 이벤트는 아이콘이 숨겨지면 발동합니다(%q|1이;가; 체크되어 있어도)."
L["SOUND_EVENT_ONLEFTCLICK"] = "왼쪽 클릭 시"
L["SOUND_EVENT_ONLEFTCLICK_DESC"] = "이 이벤트는 아이콘이 잠겨 있는 동안 아이콘을 |cff7fffff왼쪽 클릭|r하면 발동합니다."
L["SOUND_EVENT_ONRIGHTCLICK"] = "오른쪽 클릭 시"
L["SOUND_EVENT_ONRIGHTCLICK_DESC"] = "이 이벤트는 아이콘이 잠겨 있는 동안 아이콘을 |cff7fffff오른쪽 클릭|r하면 발동합니다."
L["SOUND_EVENT_ONSHOW"] = "표시될 때"
L["SOUND_EVENT_ONSHOW_DESC"] = "이 이벤트는 아이콘이 표시될 때 발동합니다 (%q|1이;가; 체크되어 있어도)."
L["SOUND_EVENT_ONSPELL"] = "주문 변경 시"
L["SOUND_EVENT_ONSPELL_DESC"] = "이 이벤트는 아이콘이 표시 중인 주문/아이템/기타 등의 정보가 변경되면 발동합니다."
L["SOUND_EVENT_ONSTACK"] = "중첩 변경 시"
L["SOUND_EVENT_ONSTACK_DESC"] = [=[이 이벤트는 아이콘이 추적 중인 것의 중첩이 변경되면 발동합니다.

%s 아이콘의 감소 수치도 포함합니다.]=]
L["SOUND_EVENT_ONSTACKDEC"] = "중첩 감소 시"
L["SOUND_EVENT_ONSTACKINC"] = "중첩 증가 시"
L["SOUND_EVENT_ONSTART"] = "시작 시"
L["SOUND_EVENT_ONSTART_DESC"] = "이 이벤트는 재사용 대기시간이 시작되거나, 강화 효과/약화 효과가 적용되면 발동합니다."
L["SOUND_EVENT_ONUIERROR"] = "전투 오류 이벤트 시"
L["SOUND_EVENT_ONUIERROR_DESC"] = "이 이벤트는 아이콘이 전투 이벤트 오류를 처리할 때 발동합니다."
L["SOUND_EVENT_ONUNIT"] = "유닛 변경 시"
L["SOUND_EVENT_ONUNIT_DESC"] = "이 이벤트는 아이콘이 표시 중인 유닛의 정보가 변경되면 발동합니다."
L["SOUND_EVENT_WHILECONDITION"] = "조건 세트가 만족하는 동안"
L["SOUND_EVENT_WHILECONDITION_DESC"] = "이 알림은 자신이 설정한 조건의 세트가 만족할 때 발동합니다."
L["SOUND_SOUNDTOPLAY"] = "재생할 소리"
L["SOUND_TAB"] = "소리"
L["SOUND_TAB_DESC"] = "LibSharedMedia 소리나 사용자 설정 소리 파일을 재생합니다."
L["SOUNDERROR1"] = "파일은 반드시 확장자가 있어야 합니다!"
L["SOUNDERROR2"] = [=[사용자 설정 WAV 파일은 WoW 4.0+ 버전에서 지원하지 않습니다

(WoW에 내장된 소리는 여전히 작동합니다)]=]
L["SOUNDERROR3"] = "OGG와  MP3 파일만 지원합니다!"
L["SPEED"] = "유닛 속도"
L["SPEED_DESC"] = "이것은 유닛의 현재 이동 속도를 나타냅니다. 유닛이 이동할 수 없다면 그것은 0일 것 입니다. 유닛의 최고 달리기 속도를 추적하고 싶다면 이것 대신에 '유닛 달리기 속도' 조건을 사용하세요.  "
L["SpeedBoosts"] = "속도 증가"
L["SPELL_EQUIV_REMOVE_FAILED"] = "경고: 주문 목록 %2$q에서 %1$s|1을;를; 제거하려고 했지만 찾을 수 없습니다."
L["SPELLCHARGES"] = "주문 충전량"
L["SPELLCHARGES_DESC"] = "%s 또는 %s 같은 주문의 충전량을 추적합니다."
L["SPELLCHARGES_FULLYCHARGED"] = "완전히 충전됨"
L["SPELLCHARGETIME"] = "주문 충전 시간"
L["SPELLCHARGETIME_DESC"] = "%s 또는 %s 같은 주문이 한번 재충전될 때까지 남은 시간을 추적합니다."
L["SPELLCOOLDOWN"] = "주문 재사용 대기시간"
L["SPELLREACTIVITY"] = "주문 반응"
L["SPELLTOCHECK"] = "확인할 주문"
L["SPELLTOCOMP1"] = "비교할 첫번째 주문"
L["SPELLTOCOMP2"] = "비교할 두번째 주문"
L["STACKALPHA_DESC"] = [=[중첩 요구 사항이 실패할 때 아이콘이 표시할 불투명도를 설정합니다.

다른 %s 설정때문에 아이콘이 이미 숨겨져 있으면 이 설정은 무시됩니다.]=]
L["STACKS"] = "중첩"
L["STACKSPANEL_TITLE2"] = "중첩 요구 사항"
L["STANCE"] = "태세"
L["STANCE_DESC"] = [=[세미콜론 (;)으로 구분하여 일치시킬 여러 태세를 입력할 수 있습니다.

아무 태세라도 일치하면 조건은 만족합니다.]=]
L["STANCE_LABEL"] = "태세"
L["STRATA_BACKGROUND"] = "배경"
L["STRATA_DIALOG"] = "대화상자"
L["STRATA_FULLSCREEN"] = "전체화면"
L["STRATA_FULLSCREEN_DIALOG"] = "전체화면 대화상자"
L["STRATA_HIGH"] = "높음"
L["STRATA_LOW"] = "낮음"
L["STRATA_MEDIUM"] = "중간"
L["STRATA_TOOLTIP"] = "툴팁"
L["Stunned"] = "기절"
L["SUG_BUFFEQUIVS"] = "강화 효과 동등성"
L["SUG_CLASSSPELLS"] = "알려진 플레이어 직업/소환수 주문"
L["SUG_DEBUFFEQUIVS"] = "약화 효과 동등성"
L["SUG_DISPELTYPES"] = "무효화 유형"
L["SUG_FINISHHIM"] = "캐싱 지금 종료"
L["SUG_FINISHHIM_DESC"] = "|cff7fffff클릭하여|r 즉시 캐싱/필터링 처리 과정을 종료합니다. 당신의 컴퓨터가 몇 초동안 멈출 수 있습니다."
L["SUG_FIRSTHELP_DESC"] = [=[추천 목록이 빠르게 설정할 수 있게 도와줍니다.

|cff7fffff클릭|r 또는 |cff7fffff위/아래|r 화살표 키나 |cff7fffffTab|r 키를 사용하여 항목을 삽입하세요.

이름을 원하면, 올바른 ID를 선택할 필요가 없습니다 - 단지 올바른 이름을 선택하세요.

일반적으로, 이름으로 추적하는 게 제일 좋습니다. 같은 이름의 다른 것들이 겹칠때만 ID 사용이 필요합니다.

이름을 입력하는 것처럼 똑같이 |cff7fffff오른쪽 클릭|r으로 ID를 삽입하세요.]=]
L["SUG_INSERT_ANY"] = "|cff7fffff클릭|r"
L["SUG_INSERT_LEFT"] = "|cff7fffff왼쪽 클릭|r"
L["SUG_INSERT_RIGHT"] = "|cff7fffff오른쪽 클릭|r"
L["SUG_INSERT_TAB"] = " 또는 |cff7fffffTab|r"
L["SUG_INSERTEQUIV"] = "%s하여 동등성 삽입"
L["SUG_INSERTERROR"] = "%s하여 오류 메시지 삽입"
L["SUG_INSERTID"] = "%s하여 ID 삽입"
L["SUG_INSERTITEMSLOT"] = "%s하여 아이템 칸 ID 삽입"
L["SUG_INSERTNAME"] = "%s하여 이름 삽입"
L["SUG_INSERTNAME_INTERFERE"] = [=[%s하여 이름으로 삽입

|TInterface/AddOns/TellMeWhen/Textures/Alert:0:2|t|cffffa500주의: |TInterface/AddOns/TellMeWhen/Textures/Alert:0:2|t|cffff1111 이 주문은 동등성과 문제가 있습니다. 아마도 이름으로 삽입하면 추적할 수 없는 것 같습니다. 대신 ID를 삽입하세요.|r]=]
L["SUG_INSERTTEXTSUB"] = "%s하여 태그 삽입"
L["SUG_INSERTTUNITID"] = "%s하여 유닛ID 삽입"
L["SUG_MISC"] = "기타"
L["SUG_NPCAURAS"] = "알려진 NPC 강화 효과/약화 효과"
L["SUG_OTHEREQUIVS"] = "기타 동등성"
L["SUG_PATTERNMATCH_FISHINGLURE"] = "미끼 %(낚시 숙련도 %+%d+%)"
L["SUG_PATTERNMATCH_SHARPENINGSTONE"] = "무기 연마 %(공격력 %+%d+%)"
L["SUG_PATTERNMATCH_WEIGHTSTONE"] = "무게 증강 %(공격력 %+%d+%)"
L["SUG_PLAYERAURAS"] = "알려진 플레이어 직업/소환수 강화 효과/약화 효과"
L["SUG_PLAYERSPELLS"] = "자신의 주문"
L["SUG_TOOLTIPTITLE"] = [=[입력하는 동안 TellMeWhen은 캐시를 살펴보고 가장 가능성이 높은 주문을 결정합니다.

주문은 아래 목록 별로 분류되고 색상화됩니다. "알려진" 단어로 시작하는 범주에는 다른 직업으로 플레이하거나 접속해서 확인하기 전까지 주문을 넣을 수 없습니다.

항목을 클릭하면 편집상자에 삽입합니다.]=]
L["SUG_TOOLTIPTITLE_GENERIC"] = [=[입력하는 동안 TellMeWhen은 캐시를 살펴보고 가장 가능성이 높은 주문을 결정합니다.

이 목록은 항상 철저하지 않습니다 - 몇몇 상황에서 나타나지 않는 올바른 입력이 있을 수 있습니다. 추천 목록에 있는 항목을 사용하지 않아도 됩니다 - 편집상자에 올바른 문자만 입력하면 TellMeWhen은 문제없이 허용합니다.

항목을 클릭하면 편집상자에 삽입합니다.]=]
L["SUG_TOOLTIPTITLE_TEXTSUBS"] = [=[다음은 이 문자 디스플레이에서 사용할 수 있는 태그입니다. 대체자를 사용하면 적당한 데이터로 변환되어 표시됩니다.

태그에 대한 자세한 정보와 더 많은 태그는 이 버튼을 클릭하세요.

항목을 클릭하면 편집상자에 삽입합니다.]=]
L["SUGGESTIONS"] = "추천:"
L["SUGGESTIONS_DOGTAGS"] = "DogTags:"
L["SUGGESTIONS_SORTING"] = "정렬 중..."
L["SUN"] = "해"
L["SWINGTIMER"] = "자동 공격 타이머"
L["TABGROUP_GROUP_DESC"] = "TellMeWhen 그룹을 설정합니다."
L["TABGROUP_ICON_DESC"] = "TellMeWhen 아이콘을 설정합니다."
L["TABGROUP_MAIN_DESC"] = "일반 TellMeWhen 설정을 구성합니다."
L["TEXTLAYOUTS"] = "문자 배치"
L["TEXTLAYOUTS_ADDANCHOR"] = "고정 위치 추가"
L["TEXTLAYOUTS_ADDANCHOR_DESC"] = "클릭하여 다른 문자 고정 위치를 추가합니다."
L["TEXTLAYOUTS_ADDLAYOUT"] = "새로운 배치 만들기"
L["TEXTLAYOUTS_ADDLAYOUT_DESC"] = "아이콘에 적용할 수 있는 새로운 문자 배치를 만듭니다."
L["TEXTLAYOUTS_ADDSTRING"] = "문자 디스플레이 추가"
L["TEXTLAYOUTS_ADDSTRING_DESC"] = "이 문자 배치에 새로운 문자 디스플레이를 추가합니다."
L["TEXTLAYOUTS_BLANK"] = "(공란)"
L["TEXTLAYOUTS_CHOOSELAYOUT"] = "배치 선택..."
L["TEXTLAYOUTS_CHOOSELAYOUT_DESC"] = "이 아이콘에 사용할 문자 배치를 선택하세요."
L["TEXTLAYOUTS_CLONELAYOUT"] = "배치 복제"
L["TEXTLAYOUTS_CLONELAYOUT_DESC"] = "따로 편집할 수 있는 이 배치의 복사본을 만드려면 클릭하세요."
L["TEXTLAYOUTS_DEFAULTS_BAR1"] = "바 배치 1"
L["TEXTLAYOUTS_DEFAULTS_BAR2"] = "세로 바 배치 1"
L["TEXTLAYOUTS_DEFAULTS_BINDINGLABEL"] = "단축/제목"
L["TEXTLAYOUTS_DEFAULTS_CENTERNUMBER"] = "중앙 숫자"
L["TEXTLAYOUTS_DEFAULTS_DURATION"] = "지속시간"
L["TEXTLAYOUTS_DEFAULTS_ICON1"] = "아이콘 배치 1"
L["TEXTLAYOUTS_DEFAULTS_NOLAYOUT"] = "<배치 없음>"
L["TEXTLAYOUTS_DEFAULTS_NUMBER"] = "숫자"
L["TEXTLAYOUTS_DEFAULTS_SPELL"] = "주문"
L["TEXTLAYOUTS_DEFAULTS_STACKS"] = "중첩"
L["TEXTLAYOUTS_DEFAULTS_WRAPPER"] = "|cff666666기본값:|r %s"
L["TEXTLAYOUTS_DEFAULTTEXT"] = "기본 문자"
L["TEXTLAYOUTS_DEFAULTTEXT_DESC"] = "이 문자 배치가 아이콘에 설정됐을 때 사용할 기본 문자를 편집합니다."
L["TEXTLAYOUTS_DEGREES"] = "%d도"
L["TEXTLAYOUTS_DELANCHOR"] = "고정 위치 삭제"
L["TEXTLAYOUTS_DELANCHOR_DESC"] = "클릭하여 이 문자 고정 위치를 삭제합니다."
L["TEXTLAYOUTS_DELETELAYOUT"] = "배치 삭제"
L["TEXTLAYOUTS_DELETELAYOUT_CONFIRM_LISTING"] = "%s: ~%d개 아이콘"
L["TEXTLAYOUTS_DELETELAYOUT_CONFIRM_NUM2"] = "|cFFFF2929다음 프로필은 아이콘에 이 배치를 사용합니다. 이 배치를 삭제하면, 기본 배치를 다시 사용합니다:|r"
L["TEXTLAYOUTS_DELETELAYOUT_DESC2"] = "클릭하여 이 문자 배치를 삭제합니다."
L["TEXTLAYOUTS_DELETESTRING"] = "문자 디스플레이 삭제"
L["TEXTLAYOUTS_DELETESTRING_DESC2"] = "이 문자 배치에서 이 문자 디스플레이를 삭제합니다."
L["TEXTLAYOUTS_DESC"] = "아무 아이콘에 적용할 수 있는 문자 배치를 정의합니다."
L["TEXTLAYOUTS_ERR_ANCHOR_BADANCHOR"] = "이 문자 배치는 이 그룹의 표시 방법과 작동할 수 없습니다. 다른 문자 배치를 선택하세요. (누락된 고정 위치: %s)"
L["TEXTLAYOUTS_ERR_ANCHOR_BADINDEX"] = "배치 오류: 문자 디스플레이 #%d|1이;가; 문자 디스플레이 #%d에 고정하려고 시도했지만 #%d|1은;는; 존재하지 않습니다, 따라서 문자 디스플레이 #%d|1은;는; 작동하지 않습니다."
L["TEXTLAYOUTS_ERROR_FALLBACK"] = [=[이 아이콘을 위한 문자 배치를 찾을 수 없습니다. 의도한 배치를 찾을 수 있을 때까지, 또는 다른 배치를 선택할 때까지 기본 배치를 사용합니다.

(배치를 삭제했나요? 아니면 아이콘이 사용하는 배치를 제외하고 이 아이콘을 가져오기 했나요?)]=]
L["TEXTLAYOUTS_fLAYOUT"] = "문자 배치: %s"
L["TEXTLAYOUTS_FONTSETTINGS"] = "글꼴 설정"
L["TEXTLAYOUTS_fSTRING"] = "%s 디스플레이"
L["TEXTLAYOUTS_fSTRING2"] = "%d 디스플레이: %s"
L["TEXTLAYOUTS_fSTRING3"] = "문자 디스플레이: %s"
L["TEXTLAYOUTS_HEADER_DISPLAY"] = "문자 디스플레이"
L["TEXTLAYOUTS_HEADER_LAYOUT"] = "문자 배치"
L["TEXTLAYOUTS_IMPORT"] = "문자 배치 가져오기"
L["TEXTLAYOUTS_IMPORT_CREATENEW"] = "새로 |cff59ff59만들기|r"
L["TEXTLAYOUTS_IMPORT_CREATENEW_DESC"] = [=[같은 고유 식별자를 가진 문자 배치가 이미 존재합니다.

이 옵션을 선택하여 새로운 고유 식별자를 만들고 배치를 가져오세요.]=]
L["TEXTLAYOUTS_IMPORT_NORMAL_DESC"] = "클릭하여 문자 배치를 가져옵니다."
L["TEXTLAYOUTS_IMPORT_OVERWRITE"] = "존재하는 것 |cFFFF5959교체|r"
L["TEXTLAYOUTS_IMPORT_OVERWRITE_DESC"] = [=[같은 고유 식별자를 가진 문자 배치가 이미 존재합니다.

이 옵션을 선택하면 존재하는 문자 배치를 이 문자 배치로 덮어씁니다. 존재하는 배치에서 사용하는 모든 아이콘은 적절하게 업데이트됩니다.]=]
L["TEXTLAYOUTS_IMPORT_OVERWRITE_DISABLED_DESC"] = "기본 문자 배치를 덮어쓸 수 없습니다."
L["TEXTLAYOUTS_LAYOUT_SETDEFAULTS"] = "기본값으로 초기화"
L["TEXTLAYOUTS_LAYOUT_SETDEFAULTS_DESC"] = "모든 디스플레이의 문자를 기본 문자로 초기화 합니다, 현재 문자 배치의 설정에서 설정합니다."
L["TEXTLAYOUTS_LAYOUTDISPLAYS"] = [=[디스플레이:
%s]=]
L["TEXTLAYOUTS_LAYOUTSETTINGS"] = "배치 설정"
L["TEXTLAYOUTS_LAYOUTSETTINGS_DESC"] = "문자 배치 %q|1을;를; 설정하려면 클릭하세요."
L["TEXTLAYOUTS_NOEDIT_DESC"] = [=[이 문자 배치는 TellMeWhen 표준으로 제공되는 배치이며, 편집할 수 없습니다.


편집하고 싶다면, 복제해주세요.]=]
L["TEXTLAYOUTS_POINT2"] = "문자 지점"
L["TEXTLAYOUTS_POINT2_DESC"] = "문자 디스플레이의 %s|1을;를; 고정 대상에 고정시킵니다."
L["TEXTLAYOUTS_POSITIONSETTINGS"] = "위치 설정"
L["TEXTLAYOUTS_RELATIVEPOINT2_DESC"] = "문자 디스플레이를 고정 대상의 %s에 고정시킵니다."
L["TEXTLAYOUTS_RELATIVETO_DESC"] = "문자가 고정될 객체입니다"
L["TEXTLAYOUTS_RENAME"] = "배치 이름 변경"
L["TEXTLAYOUTS_RENAME_DESC"] = "이 배치의 이름을 쉽게 식별할 수 있게 목적에 맞는 이름으로 변경합니다."
L["TEXTLAYOUTS_RENAMESTRING"] = "디스플레이 이름 변경"
L["TEXTLAYOUTS_RENAMESTRING_DESC"] = "이 디스플레이의 이름을 쉽게 식별할 수 있게 목적에 맞는 이름으로 변경합니다."
L["TEXTLAYOUTS_RESETSKINAS"] = "글꼴 문자열 %3$q의 새로운 설정과 충돌을 방지하기 위해 글꼴 문자열 %2$q의 %1$q 설정을 초기화했습니다."
L["TEXTLAYOUTS_SETGROUPLAYOUT"] = "문자 배치"
L["TEXTLAYOUTS_SETGROUPLAYOUT_DDVALUE"] = "배치 선택..."
L["TEXTLAYOUTS_SETGROUPLAYOUT_DESC"] = [=[이 그룹의 모든 아이콘이 사용할 문자 배치를 설정합니다.

문자 배치는 각 아이콘 설정에서 아이콘 별로 개별 설정할 수 있습니다.]=]
L["TEXTLAYOUTS_SETTEXT"] = "문자 지정"
L["TEXTLAYOUTS_SETTEXT_DESC"] = [=[이 문자 디스플레이에 사용할 문자를 설정합니다.

정보의 유동적 표시를 허용하려면 문자는 DogTag 태그로 형식화되어야 합니다. '/dogtag' 또는 '/dt'를 입력하면 태그 사용법에 도움을 받을 수 있습니다.]=]
L["TEXTLAYOUTS_SIZE_AUTO"] = "자동"
L["TEXTLAYOUTS_SKINAS"] = "스킨 선택"
L["TEXTLAYOUTS_SKINAS_COUNT"] = "중첩 문자"
L["TEXTLAYOUTS_SKINAS_DESC"] = "이 문자에 스킨으로 입힐 Masque 요소를 선택하세요."
L["TEXTLAYOUTS_SKINAS_HOTKEY"] = "단축키 문자"
L["TEXTLAYOUTS_SKINAS_NONE"] = "없음"
L["TEXTLAYOUTS_SKINAS_SKINNEDINFO"] = [=[이 문자 디스플레이는 Masque로 스킨을 입히도록 설정되었습니다.

결과적으로, 이 배치를 Masque로 스킨을 입힌 TellMeWhen 아이콘에 사용하면 아래의 설정은 적용되지 않습니다.]=]
L["TEXTLAYOUTS_STRING_COPYMENU"] = "복사하기"
L["TEXTLAYOUTS_STRING_COPYMENU_DESC"] = "이 문자 디스플레이에 복사할 수 있는 이 프로필에 사용된 모든 문자의 목록을 열려면 클릭하세요."
L["TEXTLAYOUTS_STRING_SETDEFAULT"] = "기본값으로 초기화"
L["TEXTLAYOUTS_STRING_SETDEFAULT_DESC"] = [=[디스플레이의 문자를 다음 기본 문자로 초기화합니다, 현재 문자 배치의 설정은 다음을 지정합니다:

%s]=]
L["TEXTLAYOUTS_STRINGUSEDBY"] = "%d번 사용됨"
L["TEXTLAYOUTS_TAB"] = "문자 디스플레이"
L["TEXTLAYOUTS_UNNAMED"] = "<이름 없음>"
L["TEXTLAYOUTS_USEDBY_HEADER"] = "다음 프로필은 이 배치를 사용합니다:"
L["TEXTLAYOUTS_USEDBY_NONE"] = "이 배치는 TellMeWhen 프로필 중 어떤 것에도 사용되지 않습니다."
L["TEXTMANIP"] = "문자 조작"
L["TOOLTIPSCAN"] = "효과 변수"
L["TOOLTIPSCAN_DESC"] = "이 조건 유형은 효과와 연관된 첫번째 변수를 확인하도록 허용합니다. 숫자는 블리자드 API로 제공되며 효과의 툴팁에서 찾은 숫자와 일치할 필요는 없습니다. 또한 효과에 대한 숫자를 얻을 수 있다는 보장이 없습니다. 그래도 실제로 대부분은 올바른 숫자가 확인됩니다."
L["TOOLTIPSCAN2"] = "툴팁 숫자 #%d"
L["TOOLTIPSCAN2_DESC"] = "이 조건 유형은 효과의 툴팁에서 찾은 숫자를 확인할 수 있습니다."
L["TOP"] = "상단"
L["TOPLEFT"] = "좌측 상단"
L["TOPRIGHT"] = "우측 상단"
L["TOTEMS"] = "확인할 토템"
L["TREEf"] = "트리: %s"
L["TRUE"] = "True (참)"
L["UIPANEL_ADDGROUP2"] = "새로운 %s 그룹"
L["UIPANEL_ADDGROUP2_DESC"] = "|cff7fffff클릭|r하여 새로운 %s 그룹을 추가합니다."
L["UIPANEL_ALLOWSCALEIE"] = "아이콘 편집기 확장 허용"
L["UIPANEL_ALLOWSCALEIE_DESC"] = [=[기본적으로 아이콘 편집기는 선명하고 완벽한 배치를 얻기 위해 크기를 변경할 수 없습니다.

이 문제에 관심이 없고 직접 크기를 조절할 수 있는 경우 이 설정을 사용하세요.]=]
L["UIPANEL_ANCHORNUM"] = "고정 %d"
L["UIPANEL_BAR_BORDERBAR"] = "바 테두리"
L["UIPANEL_BAR_BORDERBAR_DESC"] = "바 주위의 테두리를 설정합니다."
L["UIPANEL_BAR_BORDERCOLOR"] = "테두리 색상"
L["UIPANEL_BAR_BORDERCOLOR_DESC"] = "아이콘과 바 테두리의 색상을 변경합니다."
L["UIPANEL_BAR_BORDERICON"] = "아이콘 테두리"
L["UIPANEL_BAR_BORDERICON_DESC"] = "무늬, 재사용 대기시간 나선, 다른 비슷한 요소 주위의 테두리를 설정합니다,"
L["UIPANEL_BAR_FLIP"] = "아이콘 반대로"
L["UIPANEL_BAR_FLIP_DESC"] = "무늬, 재사용 대기시간 나선, 다른 비슷한 요소들을 아이콘의 반대편에 놓습니다."
L["UIPANEL_BAR_PADDING"] = "채우기"
L["UIPANEL_BAR_PADDING_DESC"] = "아이콘과 바 사이의 간격을 설정합니다."
L["UIPANEL_BAR_SHOWICON"] = "아이콘 표시"
L["UIPANEL_BAR_SHOWICON_DESC"] = "이 설정을 비활성하면 무늬, 재사용 대기시간 나선, 다른 비슷한 구성요소를 숨깁니다."
L["UIPANEL_BARTEXTURE"] = "바 무늬"
L["UIPANEL_COLUMNS"] = "행"
L["UIPANEL_COMBATCONFIG"] = "전투 중 설정 허용"
L["UIPANEL_COMBATCONFIG_DESC"] = [=[전투 중에도 TellMeWhen을 설정할 수 있게 허용합니다.

옵션 모듈을 항상 불러오도록 강제하며, 결과적으로 메모리 사용량이 늘어나고 로딩 시간이 길어집니다.

계정 공유 옵션: 모든 프로필이 이 설정을 공유합니다.

|cffff5959변경 사항은 |cff7fffffUI를 다시 불러온 후에 |cffff5959적용됩니다.|r]=]
L["UIPANEL_DELGROUP"] = "이 그룹 삭제"
L["UIPANEL_DIMENSIONS"] = "치수"
L["UIPANEL_DRAWEDGE"] = "타이머 가장자리 강조"
L["UIPANEL_DRAWEDGE_DESC"] = "가시성을 높이기 위해 재사용 대기시간 타이머(시계 애니메이션)의 가장자리를 강조합니다."
L["UIPANEL_EFFTHRESHOLD"] = "강화 효과 효율 한계치"
L["UIPANEL_EFFTHRESHOLD_DESC"] = [=[강화 효과/약화 효과 아이콘이 확인하도록 설정한 강화 효과/약화 효과의 숫자에 기반해서 한계치를 설정합니다.

이 한계치가 아이콘의 설정보다 높으면, 두가지 현상이 일어납니다:

|cff7fffff1)|r 이 아이콘은 데이터의 값이 클수록 빠른 스캔 방법으로 전환합니다 (하지만 값이 작으면 느립니다).

|cff7fffff2)|r 1번의 결과로, 스캔 순서는 설정에 입력된 순서 대신 유닛 프레임에 표시되는 강화 효과/약화 효과의 순서를 따릅니다.

이 설정의 기본값은 15입니다.]=]
L["UIPANEL_FONT_DESC"] = "아이콘의 중첩 문자에 사용될 글꼴을 선택하세요."
L["UIPANEL_FONT_HEIGHT"] = "높이"
L["UIPANEL_FONT_HEIGHT_DESC"] = [=[문자 디스플레이의 최대 높이를 설정합니다. 0으로 설정하면, 가능한 만큼 크게 확장됩니다.

이 문자 디스플레이의 상단과 하단이 고정되면, 이 설정은 효과가 없습니다.]=]
L["UIPANEL_FONT_JUSTIFY"] = "가로 정렬"
L["UIPANEL_FONT_JUSTIFY_DESC"] = "이 문자 디스플레이에 가로 정렬 (왼쪽/가운데/오른쪽)을 설정합니다."
L["UIPANEL_FONT_JUSTIFYV"] = "세로 정렬"
L["UIPANEL_FONT_JUSTIFYV_DESC"] = "이 문자 디스플레이에 세로 정렬 (상단/중앙/하단)을 설정합니다."
L["UIPANEL_FONT_OUTLINE"] = "글꼴 외곽선"
L["UIPANEL_FONT_OUTLINE_DESC2"] = "문자 디스플레이의 외곽선 스타일을 설정합니다."
L["UIPANEL_FONT_ROTATE"] = "회전"
L["UIPANEL_FONT_ROTATE_DESC"] = [=[문자 디스플레이를 회전시킬 각도를 설정합니다.

이 방법은 블리자드가 제공하지 않기 때문에, 이상하게 작동해도 해결할 방법이 없습니다.]=]
L["UIPANEL_FONT_SHADOW"] = "그림자 위치"
L["UIPANEL_FONT_SHADOW_DESC"] = "문자 뒤 편 그림자의 위치를 변경합니다. 0으로 설정하면 그림자를 비활성합니다."
L["UIPANEL_FONT_SIZE"] = "글꼴 크기"
L["UIPANEL_FONT_SIZE_DESC2"] = "글꼴의 크기를 변경합니다."
L["UIPANEL_FONT_WIDTH"] = "너비"
L["UIPANEL_FONT_WIDTH_DESC"] = [=[문자 디스플레이의 최대 너비를 설정합니다. 0으로 설정하면, 가능한 만큼 넓게 확장됩니다.

이 문자 디스플레이의 좌측과 우측이 고정되면, 이 설정은 효과가 없습니다.]=]
L["UIPANEL_FONT_XOFFS"] = "X 좌표"
L["UIPANEL_FONT_XOFFS_DESC"] = "고정기의 x-축 좌표"
L["UIPANEL_FONT_YOFFS"] = "Y 좌표"
L["UIPANEL_FONT_YOFFS_DESC"] = "고정기의 y-축 좌표"
L["UIPANEL_FONTFACE"] = "글꼴체"
L["UIPANEL_FORCEDISABLEBLIZZ"] = "블리자드 재사용 대기시간 문자 비활성화"
L["UIPANEL_FORCEDISABLEBLIZZ_DESC"] = [=[블리자드의 내장 재사용 대기시간 타이머 문자를 강제로 비활성합니다.

이 문자를 제공한다고 알려진 애드온을 설치하면 자동으로 비활성화됩니다.]=]
L["UIPANEL_GLYPH"] = "문양 활성화"
L["UIPANEL_GLYPH_DESC"] = "특정 문양이 활성화 상태인지 확인합니다."
L["UIPANEL_GROUP_QUICKSORT_DEFAULT"] = "ID 별 정렬"
L["UIPANEL_GROUP_QUICKSORT_DURATION"] = "지속시간 별 정렬"
L["UIPANEL_GROUP_QUICKSORT_SHOWN"] = "표시된 아이콘 순"
L["UIPANEL_GROUPALPHA"] = "그룹 불투명도"
L["UIPANEL_GROUPALPHA_DESC"] = [=[모든 그룹의 불투명도를 설정합니다.

이 설정은 아이콘의 기능에 영향을 주지 않습니다. 그룹과 그 아이콘의 모양만 변경합니다.

기능을 유지하면서 모든 그룹을 숨기려면 0으로 설정하세요 (아이콘의 %q 설정과 유사).]=]
L["UIPANEL_GROUPNAME"] = "그룹 이름 변경"
L["UIPANEL_GROUPRESET"] = "위치 초기화"
L["UIPANEL_GROUPS"] = "그룹"
L["UIPANEL_GROUPS_DROPDOWN"] = "그룹 선택 또는 만들기..."
L["UIPANEL_GROUPS_DROPDOWN_DESC"] = [=[설정할 다른 그룹을 불러오거나 새로운 그룹을 만들려면 이 메뉴를 사용하세요.

화면의 아이콘을 |cff7fffff오른쪽-클릭|r하여 아이콘의 그룹을 불러올 수 있습니다.]=]
L["UIPANEL_GROUPS_GLOBAL"] = "|cff00c300공통|r 그룹"
L["UIPANEL_GROUPSORT"] = "아이콘 정렬"
L["UIPANEL_GROUPSORT_ADD"] = "우선순위 추가"
L["UIPANEL_GROUPSORT_ADD_DESC"] = "이 그룹에 새로운 아이콘 정렬 우선순위를 추가합니다."
L["UIPANEL_GROUPSORT_ADD_NOMORE"] = "사용 가능한 우선순위 없음"
L["UIPANEL_GROUPSORT_ALLDESC"] = [=[|cff7fffff클릭|r하여 이 정렬 우선순위의 순서를 변경합니다.
|cff7fffff클릭하고 끌어서|r 재정렬 합니다.

아래로 끌면 삭제합니다.]=]
L["UIPANEL_GROUPSORT_alpha"] = "불투명도"
L["UIPANEL_GROUPSORT_alpha_1"] = "낮은 불투명도 순"
L["UIPANEL_GROUPSORT_alpha_-1"] = "높은 불투명도 순"
L["UIPANEL_GROUPSORT_alpha_DESC"] = "아이콘의 불투명도로 그룹을 정렬합니다."
L["UIPANEL_GROUPSORT_duration"] = "지속시간"
L["UIPANEL_GROUPSORT_duration_1"] = "짧은 지속시간 순"
L["UIPANEL_GROUPSORT_duration_-1"] = "긴 지속시간 순"
L["UIPANEL_GROUPSORT_duration_DESC"] = "아이콘의 남은 지속시간으로 그룹을 정렬합니다."
L["UIPANEL_GROUPSORT_fakehidden"] = "%s"
L["UIPANEL_GROUPSORT_fakehidden_1"] = "항상 표시된 순"
L["UIPANEL_GROUPSORT_fakehidden_-1"] = "항상 숨겨진 순"
L["UIPANEL_GROUPSORT_fakehidden_DESC"] = "%q 설정의 상태에 따라 그룹을 정렬합니다."
L["UIPANEL_GROUPSORT_id"] = "아이콘 ID"
L["UIPANEL_GROUPSORT_id_1"] = "낮은 ID 순"
L["UIPANEL_GROUPSORT_id_-1"] = "높은 ID 순"
L["UIPANEL_GROUPSORT_id_DESC"] = "아이콘의 ID 숫자로 그룹을 정렬합니다."
L["UIPANEL_GROUPSORT_PRESETS"] = "프리셋 선택..."
L["UIPANEL_GROUPSORT_PRESETS_DESC"] = "정렬 우선순위 프리셋 목록에서 이 아이콘에 적용할 우선순위를 선택하세요."
L["UIPANEL_GROUPSORT_shown"] = "표시"
L["UIPANEL_GROUPSORT_shown_1"] = "숨겨진 아이콘 순"
L["UIPANEL_GROUPSORT_shown_-1"] = "표시된 아이콘 순"
L["UIPANEL_GROUPSORT_shown_DESC"] = "아이콘의 표시 여부로 그룹을 정렬합니다."
L["UIPANEL_GROUPSORT_stacks"] = "중첩"
L["UIPANEL_GROUPSORT_stacks_1"] = "낮은 중첩 순"
L["UIPANEL_GROUPSORT_stacks_-1"] = "높은 중첩 순"
L["UIPANEL_GROUPSORT_stacks_DESC"] = "각 아이콘의 중첩 별로 그룹을 정렬합니다."
L["UIPANEL_GROUPSORT_value"] = "수치"
L["UIPANEL_GROUPSORT_value_1"] = "낮은 수치 순"
L["UIPANEL_GROUPSORT_value_-1"] = "높은 수치 순"
L["UIPANEL_GROUPSORT_value_DESC"] = "진행 바 수치로 그룹을 정렬합니다. %s 아이콘 형식이 제공하는 값입니다."
L["UIPANEL_GROUPSORT_valuep"] = "수치 백분율"
L["UIPANEL_GROUPSORT_valuep_1"] = "낮은 % 수치 순"
L["UIPANEL_GROUPSORT_valuep_-1"] = "높은 % 수치 순"
L["UIPANEL_GROUPSORT_valuep_DESC"] = "진행 바 수치 백분율로 그룹을 정렬합니다. %s 아이콘 형식이 제공하는 값입니다."
L["UIPANEL_GROUPTYPE"] = "표시 방법"
L["UIPANEL_GROUPTYPE_BAR"] = "바"
L["UIPANEL_GROUPTYPE_BAR_DESC"] = "진행 바가 붙여진 아이콘으로 그룹 안의 아이콘을 표시합니다."
L["UIPANEL_GROUPTYPE_BARV"] = "수직 바"
L["UIPANEL_GROUPTYPE_BARV_DESC"] = "세로 진행 바가 붙여진 아이콘으로 그룹 안의 아이콘을 표시합니다."
L["UIPANEL_GROUPTYPE_ICON"] = "아이콘"
L["UIPANEL_GROUPTYPE_ICON_DESC"] = "TellMeWhen의 고유 아이콘 표시 방법을 사용하여 그룹 안의 아이콘을 표시합니다."
L["UIPANEL_HIDEBLIZZCDBLING"] = "블리자드 재사용 대기시간 종료 효과 비활성화"
L["UIPANEL_HIDEBLIZZCDBLING_DESC"] = [=[타이머가 종료됐을 때 재사용 대기시간 범위에 블리자드의 진동 효과를 비활성합니다.

이 효과는 6.2 패치에 블리자드에 의해 추가되었습니다.]=]
L["UIPANEL_ICONS"] = "아이콘"
L["UIPANEL_ICONSPACING"] = "아이콘 간격"
L["UIPANEL_ICONSPACING_DESC"] = "그룹 내 각 아이콘 간의 간격입니다."
L["UIPANEL_ICONSPACINGX"] = "가로"
L["UIPANEL_ICONSPACINGY"] = "세로"
L["UIPANEL_LEVEL"] = "프레임 레벨"
L["UIPANEL_LEVEL_DESC"] = "프레임이 그려질 그룹의 우선순위 레벨입니다."
L["UIPANEL_LOCK"] = "위치 잠그기"
L["UIPANEL_LOCK_DESC"] = "이 그룹을 잠급니다, 이동 또는 그룹이나 크기 비율 탭을 끌어서 크기가 변경되지 않게 방지합니다."
L["UIPANEL_LOCKUNLOCK"] = "애드온 잠금/잠금 해제"
L["UIPANEL_MAINOPT"] = "주 옵션"
L["UIPANEL_ONLYINCOMBAT"] = "전투 중에만 표시"
L["UIPANEL_PERFORMANCE"] = "성능"
L["UIPANEL_POINT"] = "그룹 지점"
L["UIPANEL_POINT2_DESC"] = "그룹의 %s|1을;를; 고정 대상에 고정시킵니다."
L["UIPANEL_POSITION"] = "위치"
L["UIPANEL_PRIMARYSPEC"] = "주 특성 전문화"
L["UIPANEL_PROFILES"] = "프로필"
L["UIPANEL_PTSINTAL"] = "특성 포인트"
L["UIPANEL_PVPTALENTLEARNED"] = "PvP 특성 배움"
L["UIPANEL_RELATIVEPOINT"] = "대상 지점"
L["UIPANEL_RELATIVEPOINT2_DESC"] = "고정 대상의 %s|1으로;로; 그룹을 고정시킵니다."
L["UIPANEL_RELATIVETO"] = "고정 대상"
L["UIPANEL_RELATIVETO_DESC"] = "'/framestack'|1을;를; 입력하면 마우스가 올려진 모든 프레임의 목록과 이름을 포함하는 툴팁이 표시 전환되며, 이 대화 상자에 입력하세요."
L["UIPANEL_RELATIVETO_DESC_GUIDINFO"] = "현재 값은 다른 그룹의 고유 식별자입니다. 고정시키기 옵션을 선택하고 이 그룹을 다른 그룹으로 오른쪽-클릭하고 끌면 설정됩니다."
L["UIPANEL_ROLE_DESC"] = "자신의 현재 전문화가 이 역할을 수행할 때 이 그룹을 표시하도록 허용하려면 체크하세요."
L["UIPANEL_ROWS"] = "열 개수"
L["UIPANEL_SCALE"] = "크기 비율"
L["UIPANEL_SECONDARYSPEC"] = "보조 특성 전문화"
L["UIPANEL_SHOWCONFIGWARNING"] = "설정 모드 경고 표시"
L["UIPANEL_SPEC"] = "이중 특성 전문화"
L["UIPANEL_SPECIALIZATION"] = "특성 전문화"
L["UIPANEL_SPECIALIZATIONROLE"] = "전문화 역할"
L["UIPANEL_SPECIALIZATIONROLE_DESC"] = "자신의 현재 특성 전문화에 따른 역할 (탱커, 힐러, 또는 딜러)을 확인합니다."
L["UIPANEL_STRATA"] = "프레임 계층"
L["UIPANEL_STRATA_DESC"] = "그룹이 그려질 UI의 단면 층입니다."
L["UIPANEL_SUBTEXT2"] = [=[잠겨 있을때만 아이콘이 작동합니다. 

잠금이 해제되면, 아이콘 그룹을 이동하거나 크기를 조절할 수 있으며 각 아이콘을 오른쪽 클릭하여 그것들을 설정할 수 있습니다.

또한 잠금/잠금 해제하기 위해 /tellmewhen 또는 /tmw를 입력할 수 있습니다.]=]
L["UIPANEL_TALENTLEARNED"] = "배운 특성"
L["UIPANEL_TOOLTIP_COLUMNS"] = "이 그룹에서의 행 개수를 설정합니다."
L["UIPANEL_TOOLTIP_GROUPRESET"] = "이 그룹의 위치와 크기 비율을 초기화합니다."
L["UIPANEL_TOOLTIP_ONLYINCOMBAT"] = "체크하면 이 그룹은 전투 중에만 표시됩니다"
L["UIPANEL_TOOLTIP_ROWS"] = "이 그룹의 열 개수를 설정합니다."
L["UIPANEL_TOOLTIP_UPDATEINTERVAL"] = [=[보이기/숨기기, 투명도, 조건 등을 위해 아이콘의 확인 빈도(초 단위)를 설정합니다.

0 값은 가능한 가장 빠른 속도입니다. 낮은 값은 성능이 낮은 컴퓨터에 대해 프레임율에 상당한 영향을 미칠 수 있습니다.]=]
L["UIPANEL_TREE_DESC"] = "이 전문화가 활성화 중일 때 이 그룹을 표시하려면 체크하고, 비활성 중일 때 숨기려면 체크해제 하세요."
L["UIPANEL_UPDATEINTERVAL"] = "갱신 주기"
L["UIPANEL_USE_PROFILE"] = "프로필 설정 사용"
L["UIPANEL_WARNINVALIDS"] = "올바르지 않은 아이콘에 대해 경고"
L["UIPANEL_WARNINVALIDS_DESC"] = [=[이 설정을 사용하면 TellMeWhen이 아이콘에서 올바르지 않은 구성을 감지했을 때 당신에게 경고합니다.

이 설정을 사용하길 적극 추천합니다, 이런 구성 오류는 성능 저하를 일으킬 수 있습니다]=]
L["UNDO"] = "실행 취소"
L["UNDO_DESC"] = "이 설정들의 마지막 변경점을 취소합니다."
L["UNITCONDITIONS"] = "유닛 조건"
L["UNITCONDITIONS_DESC"] = "확인하기 위해 개별 유닛이 통과해야할 조건의 세트를 설정하려면 클릭하세요."
L["UNITCONDITIONS_STATICUNIT"] = "<아이콘 유닛>"
L["UNITCONDITIONS_STATICUNIT_DESC"] = "아이콘이 확인 중인 개별 유닛을 확인하는 조건을 발생시킵니다."
L["UNITCONDITIONS_STATICUNIT_TARGET"] = "<아이콘 유닛>의 대상"
L["UNITCONDITIONS_STATICUNIT_TARGET_DESC"] = "아이콘이 확인 중인 개별 유닛의 대상을 확인하는 조건을 발생시킵니다."
L["UNITCONDITIONS_TAB_DESC"] = "확인하기 위해 각 유닛이 통과해야할 조건을 설정합니다."
L["UNITTWO"] = "두번째 유닛"
L["UNKNOWN_GROUP"] = "<알 수 없는/사용할 수 없는 그룹>"
L["UNKNOWN_ICON"] = "<알 수 없는/사용할 수 없는 아이콘>"
L["UNKNOWN_UNKNOWN"] = "<알 수 없음 ???>"
L["UNNAMED"] = "(이름 없음)"
L["UP"] = "위로"
L["VALIDITY_CONDITION_DESC"] = "조건의 대상: "
L["VALIDITY_CONDITION2_DESC"] = "#%d 조건: "
L["VALIDITY_ISINVALID"] = "올바르지 않습니다."
L["VALIDITY_META_DESC"] = "#%d 아이콘이 메타 아이콘에 의해 확인됩니다"
L["WARN_DRMISMATCH"] = [=[경고! 두개의 다르게 알려진 범주로 주문의 점감 효과를 확인하고 있습니다.

아이콘이 정상 작동하려면 모든 주문은 같은 점감 효과 범주에 있어야 합니다. 다음 범주와 주문이 감지되었습니다:]=]
L["WATER"] = "물"
L["worldboss"] = "야외 우두머리"

elseif locale == "ptBR" then
L["ABSORBAMT"] = "Quantidade de absorção do escudo"
L["ABSORBAMT_DESC"] = "Verifique o total de absorção que o escudo de sua unidade teve."
L["ACTIVE"] = "%d Ativo"
L["AIR"] = "Ar"
L["ALLOWCOMM"] = "Compartilhamento no jogo"
L["ALLOWVERSIONWARN"] = "Avisar das novas versões"
L["ALPHA"] = "Opacidade"
L["ANIM_ACTVTNGLOW"] = "Borda de Ativação"
L["ANIM_ACTVTNGLOW_DESC"] = "Mostra a borda da Blizzard para ativação de feitiço."
L["ANIM_ALPHASTANDALONE"] = "Opacidade"
L["ANIM_ALPHASTANDALONE_DESC"] = "Defina a opacidade da animação."
L["ANIM_ANIMSETTINGS"] = "Configurações"
L["ANIM_COLOR"] = "Cor/Opacidade"
L["ANIM_COLOR_DESC"] = "Configura a cor e a opacidade do alerta."
L["ANIM_DURATION"] = "Duração"
L["ANIM_DURATION_DESC"] = "Defina a duração da animação assim que for acionada."
L["ANIM_FADE"] = "Apagar Alertas"
L["ANIM_FADE_DESC"] = "Marque para que cada alerta apague suavemente. Desmarque para instantâneo."
L["ANIM_ICONALPHAFLASH"] = "Ícone: Alerta Alfa"
L["ANIM_ICONALPHAFLASH_DESC"] = [=[Alerta o ícone mudando sua opacidade.

A opacidade irá alternar entre a opacidade normal e a opacidade configurada pela animação.]=]
L["ANIM_ICONCLEAR"] = "Ícone: Parar Animações"
L["ANIM_ICONCLEAR_DESC"] = "Para todas as animações que estão funcionando no ícone atual."
L["ANIM_ICONFADE"] = "Ícone: Acender / Ofuscar"
L["ANIM_ICONFADE_DESC"] = "Aplica suavemente qualquer mudança de opacidade que ocorreram com o evento selecionado."
L["ANIM_ICONFLASH"] = "Ícone: Cor do Alerta"
L["ANIM_ICONFLASH_DESC"] = "Alerta colorido sobre o ícone."
L["ANIM_ICONSHAKE_DESC"] = "Treme o ícone quando é acionado."
L["ANIM_INFINITE"] = "Executar Direto"
L["ANIM_INFINITE_DESC"] = "Veja que a animação irá funcionar direto até que seja substituída por outra no ícone do mesmo tipo, ou até a animação %q começar."
L["ANIM_PERIOD"] = "Período do Alerta"
L["ANIM_PERIOD_DESC"] = [=[Defina o tempo em que cada flash deve ter - O tempo que cada flash exibirá ou desaparecerá.

Defina 0 se você não quiser ofuscação ou alerta.]=]
L["ANIM_SCREENFLASH"] = "Tela: Alerta"
L["ANIM_SCREENFLASH_DESC"] = "Pisca uma camada colorida sobreposta na tela."
L["ANIM_SCREENSHAKE_DESC"] = [=[Treme sua tela quando for acionado.

NOTA: Isto só funcionará se você estiver fora de combate ou se as placas dos nomes não tiverem sido ativadas desde que você logou.]=]
L["ANIM_TAB"] = "Animação"
L["ANIM_TAB_DESC"] = "Animar este ícone ou sua tela inteira."
L["ANN_CHANTOUSE"] = "Canal à usar"
L["ANN_EDITBOX"] = "Texto a ser retornado"
L["ANN_EDITBOX_DESC"] = "Digite o texto que você deseja ser exibido quando as notificações forem acionadas. "
L["ANN_EDITBOX_WARN"] = "Digite o texto que você deseja que seja exibido"
L["ANN_NOTEXT"] = "<Sem Texto>"
L["ANN_SHOWICON"] = "Mostrar textura do ícone"
L["ANN_SHOWICON_DESC"] = "Algumas destinações de texto podem mostrar a textura junto com o texto. Marque esta opção para habilitar esta característica."
L["ANN_STICKY"] = "Permanente"
L["ANN_SUB_CHANNEL"] = "Subseção"
L["ANN_TAB"] = "Texto"
L["ANN_TAB_DESC"] = "Exibir texto nos canais de chat, quadros IU ou outros AddOns."
L["ANN_WHISPERTARGET"] = "Sussurrar em"
L["ASCENDING"] = "Crescente"
L["ASPECT"] = "Aspecto"
L["AURA"] = "Aura"
L["BACK_IE"] = "Voltar"
L["BACK_IE_DESC"] = [=[Carregar última edição

%s |T%s:0|t.]=]
L["Bleeding"] = "Sangrando"
L["BOTTOM"] = "Baixo"
L["BOTTOMLEFT"] = "Baixo à Esquerda"
L["BOTTOMRIGHT"] = "Baixo à Direita"
L["BUFFCNDT_DESC"] = "Somente a primeira magia deverá ser marcada, as outras serão ignoradas."
L["BUFFTOCHECK"] = "Verificar Bônus"
L["BUFFTOCOMP1"] = "1º Bônus à Comparar"
L["BUFFTOCOMP2"] = "2º Bônus à Comparar"
L["CACHING"] = [=[TellMeWhen armazena e filtra todos os feitiços no jogo. Isto precisa apenas será feito uma vez por patch. Você pode aumentar ou diminuir o processo usando a barra deslizante. 

Você não tem que aguardar este processo terminar para usar o TellMeWhen. Apenas a lista de sugestões é dependente da conclusão do armazenamento em cache.]=]
L["CACHINGSPEED"] = "Feitiço por quadro"
L["CASTERFORM"] = "Forma Conjuradora"
L["CENTER"] = "Centro"
L["CHANGELOG"] = "Registro de Mudanças"
L["CHANGELOG_DESC"] = "Exibe uma lista das mudanças feitas na versão atual e anterior do TellMeWhen."
L["CHANGELOG_INFO2"] = [=[Bem-Vindo ao TellMeWhen v%s!
<br/><br/>
Quando você estiver pronto para verificar nossas mudanças, clique na guia %s ou na guia %s abaixo para iniciarmos a configuração.]=]
L["CHANGELOG_LAST_VERSION"] = "Versão Anterior Instalada"
L["CHAT_FRAME"] = "Janela de Chat"
L["CHAT_MSG_CHANNEL"] = "Canal de bate-papo"
L["CHAT_MSG_CHANNEL_DESC"] = "Sairá em um canal do bate-papo, tal como o canal de comércio ou um canal personalizado que você tiver entrado."
L["CHAT_MSG_SMART"] = "Canal inteligente"
L["CHAT_MSG_SMART_DESC"] = "Sairá em Campos de batalhas, Raids, Grupos ou Conversas - Seja qual for apropriado."
L["CHOOSENAME_DIALOG"] = [=[Digite o nome ou ID do que você quer monitorar. Você pode adicionar várias entradas (qualquer combinação de nomes, IDs e equivalentes) separando-os com ponto e vírgula (;).

Você pode omitir uma magia usada da equivalência usando um hífen, por exemplo "Lento; -Confuso".

Você pode |cff7fffffShift-Clique|r nas magias/itens/links do chat ou arrastar magias/itens para inserí-los neste campo
.]=]
L["CHOOSENAME_DIALOG_PETABILITIES"] = "|cFFFF5959HABILIDADES DE PETS|r devem usar o ID da habilidade. "
L["CLEU_"] = "Qualquer evento"
L["CLEU_CAT_AURA"] = "Ganho/Perca de bônus"
L["CLEU_CAT_CAST"] = "Lançamentos"
L["CLEU_CAT_MISC"] = "Diversos"
L["CLEU_CAT_SPELL"] = "Feitiços"
L["CLEU_CAT_SWING"] = "Corpo-a-corpo/Longo-alcance"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MASK"] = "Controle de Relacionamento"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MINE"] = "Controle de Relacionamento: Jogador (Você)"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MINE_DESC"] = "Marque para excluir as unidades controladas por você."
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_OUTSIDER"] = "Controle de Relacionamento: Estranhos"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_OUTSIDER_DESC"] = "Marque para excluir unidades que são controladas por quem não está em grupo com você."
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_PARTY"] = "Controle de Relacionamento: Membros do grupo"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_PARTY_DESC"] = "Marque para excluir unidades que são controladas por alguém de seu grupo."
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_RAID"] = "Controle de Relacionamento: Membros da Raid"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_RAID_DESC"] = "Marque para excluir as unidades que são controladas por alguém que está na Raid."
L["CLEU_COMBATLOG_OBJECT_CONTROL_MASK"] = "Controlador"
L["CLEU_COMBATLOG_OBJECT_CONTROL_NPC"] = "Controlador: Servidor"
L["CLEU_COMBATLOG_OBJECT_CONTROL_NPC_DESC"] = "Marque para excluir unidades que são controladas pelo servidor, incluindo os seus pets e guardiões."
L["CLEU_COMBATLOG_OBJECT_CONTROL_PLAYER"] = "Controlador: Humano"
L["CLEU_COMBATLOG_OBJECT_CONTROL_PLAYER_DESC"] = "Marque esta opção para excluir unidades que são controladas  por seres humanos, incluindo seus pets e guardiões."
L["CLEU_COMBATLOG_OBJECT_FOCUS"] = "Diversos: Seu foco"
L["CLEU_COMBATLOG_OBJECT_FOCUS_DESC"] = "Marque esta opção para excluir a unidade que você definiu como o seu foco."
L["CLEU_COMBATLOG_OBJECT_MAINASSIST"] = "Diversos: Ajudante Principal"
L["CLEU_COMBATLOG_OBJECT_MAINASSIST_DESC"] = "Marque esta opção para excluir unidades marcadas como assistentes principais na sua raide."
L["CLEU_COMBATLOG_OBJECT_MAINTANK"] = "Diversos: Tanque Principal"
L["CLEU_COMBATLOG_OBJECT_MAINTANK_DESC"] = "Marque esta opção para excluir unidades marcadas como tanques principais na sua raide."
L["CLEU_COMBATLOG_OBJECT_NONE"] = "Diversos: Unidade Desconhecida"
L["CLEU_COMBATLOG_OBJECT_NONE_DESC"] = "Marque para excluir unidades que estão desconhecidas para o WoW, e para excluir eventos onde a unidade não é fornecida pelo cliente."
L["CLEU_COMBATLOG_OBJECT_REACTION_FRIENDLY"] = "Reação da Unidade: Amigável"
L["CLEU_COMBATLOG_OBJECT_REACTION_FRIENDLY_DESC"] = "Marque esta opção para excluir unidades que são amigáveis em relação a você."
L["CLEU_COMBATLOG_OBJECT_REACTION_HOSTILE"] = "Reação de unidade: Hostil"
L["CLEU_COMBATLOG_OBJECT_REACTION_HOSTILE_DESC"] = "Marque esta opção para excluir unidades que são hostis em relação a você."
L["CLEU_COMBATLOG_OBJECT_REACTION_MASK"] = "Reação de Unidade"
L["CLEU_COMBATLOG_OBJECT_REACTION_NEUTRAL"] = "Reação de Unidade: Neutra"
L["CLEU_COMBATLOG_OBJECT_TARGET"] = "Diversos: Seu Alvo"
L["CLEU_COMBATLOG_OBJECT_TYPE_GUARDIAN"] = "Tipo de Unidade: Guardião"
L["CLEU_COMBATLOG_OBJECT_TYPE_GUARDIAN_DESC"] = "Marque para excluir Guardiões. Guardiões são unidades que defendem seu personagem, mas não podem ser controlados."
L["CLEU_COMBATLOG_OBJECT_TYPE_MASK"] = "Tipo dae Unidade"
L["CLEU_COMBATLOG_OBJECT_TYPE_NPC"] = "Tipo de Unidade: NPC"
L["CLEU_COMBATLOG_OBJECT_TYPE_OBJECT"] = "Tipo de Unidade: Objeto"
L["CLEU_COMBATLOG_OBJECT_TYPE_PET"] = "Tipo de Unidade: Ajudante"
L["CLEU_COMBATLOG_OBJECT_TYPE_PLAYER"] = "Tipo de Unidade: Personagem"
L["CLEU_DAMAGE_SHIELD"] = "Escudo de Danos"
L["CLEU_DAMAGE_SHIELD_DESC"] = "Ocorre quando um escudo de dano (%s, %s, etc. mas não %s) causa dano."
L["CLEU_DAMAGE_SHIELD_MISSED"] = "Escudo de Danos Perdidos"
L["CLEU_DAMAGE_SHIELD_MISSED_DESC"] = "Ocorre quando um escudo de dano (%s, %s, etc., mas não %s) falha em causar dano."
L["CLEU_DAMAGE_SPLIT"] = "Dano Dividido"
L["CLEU_DAMAGE_SPLIT_DESC"] = "Ocorre quando o dano é dividido entre dois ou mais alvos."
L["CLEU_DESTUNITS"] = "Unidade(s) de destino para verificar"
L["CLEU_DESTUNITS_DESC"] = "Escolha uma unidade que você gostaria de que o ícone reagisse à,  |cff7fffffOU|r deixe isto em branco para deixar o ícone reagir a qualquer evento de destino."
L["CLEU_DIED"] = "Morte"
L["CLEU_ENCHANT_APPLIED"] = "Encantamento Aplicado"
L["CLEU_ENCHANT_APPLIED_DESC"] = "Cobre encantos temporários de arma como venenos de ladinos."
L["CLEU_ENCHANT_REMOVED"] = "Encantamento Removido"
L["CLEU_ENCHANT_REMOVED_DESC"] = "Cobre encantos temporários de arma como venenos de ladinos."
L["CLEU_ENVIRONMENTAL_DAMAGE"] = "Dano Ambiental"
L["CLEU_ENVIRONMENTAL_DAMAGE_DESC"] = "Inclui dano de lava, fadiga, afogamento e queda."
L["CLEU_EVENTS"] = "Verificar eventos"
L["CLEU_EVENTS_ALL"] = "Todos"
L["CLEU_EVENTS_DESC"] = "Escolha os eventos de combate que você gostaria que houvesse reação."
L["CLEU_HEADER"] = "Filtros de Eventos de Combate"
L["CLEU_RANGE_DAMAGE"] = "Danos à distância"
L["CLEU_RANGE_MISSED"] = "Danos à distância Perdidos"
L["CLEU_SOURCEUNITS"] = "Unidade(s) de origem à verificar"
L["CLEU_SOURCEUNITS_DESC"] = "Escolha as unidades que você gostaria que houvesse reação ao ícone |cff7fffffOU|r deixe em branco para deixar o ícone reagir a qualquer evento."
L["CLEU_SPELL_AURA_APPLIED"] = "Aura Aplicada"
L["CLEU_SPELL_AURA_APPLIED_DOSE"] = "Pilha de Aura Aplicada"
L["CLEU_SPELL_AURA_BROKEN"] = "Aura Quebrada"
L["CLEU_SPELL_AURA_BROKEN_SPELL_DESC"] = [=[Ocorre quando uma aura, normalmente alguma forma de controle de massa, é quebrada por dano de alguma magia.

A aura que foi quebrada é o que o ícone filtra por; a magia que a quebrou pode ser acessada com a substituição [Extra] na exibição de texto.]=]
L["CLEU_SPELL_AURA_REFRESH"] = "Aura Atualizada"
L["CLEU_SPELL_AURA_REMOVED"] = "Aura Removida"
L["CLEU_SPELL_AURA_REMOVED_DOSE"] = "Pilha de Aura Removida"
L["CLEU_SPELL_CAST_FAILED"] = "Magias Falhadas"
L["CLEU_SPELL_CAST_START"] = "Magias Iniciadas"
L["CLEU_SPELL_CAST_START_DESC"] = [=[Ocorre quando uma magia começa a ser lançada.

NOTA: Para evitar potencial abuso, a Blizzard excluiu a unidade de destino para este evento, então você não pode filtrar.]=]
L["CLEU_SPELL_DAMAGE"] = "Dano da Magia"
L["CLEU_SPELL_DISPEL"] = "Dispersar"
L["CLEU_SPELL_DISPEL_DESC"] = [=[Ocorre quando uma aura é repelida.

Ícone pode ser filtrado pela aura que foi repelida. A habilidade que foi repelida pode ser acessada com a substituição [Extra] na exibição de texto.]=]
L["CLEU_SPELL_DISPEL_FAILED"] = "Falha ao Dispersar"
L["CLEU_SPELL_DISPEL_FAILED_DESC"] = "Ocorre quando uma aura tiver sido tentada ser dissipada. O feitiço que foi tentado acessar com a substituição [Extra] na exibição do texto."
L["CLEU_SPELL_DRAIN"] = "Drenagem de Recursos"
L["CLEU_SPELL_DRAIN_DESC"] = "Ocorre quando recursos (vida/mana/raiva/energia/etc) são removidos."
L["CLEU_SPELL_ENERGIZE"] = "Ganho de Recursos"
L["CLEU_SPELL_ENERGIZE_DESC"] = "Ocorre quando recursos (vida/mana/raiva/energia/etc) são ganhos."
L["CLEU_SPELL_EXTRA_ATTACKS"] = "Ganho de Ataques Extras"
L["CLEU_SPELL_EXTRA_ATTACKS_DESC"] = "Ocorre quando golpes extras corpo-a-corpo são ganhos pelo processo."
L["CLEU_SPELL_HEAL"] = "Cura"
L["CLEU_SPELL_INSTAKILL"] = "Morte Imediata"
L["CLEU_SPELL_INTERRUPT"] = "Interrompido - Magias Interrompidas"
L["CLEU_SPELL_INTERRUPT_DESC"] = [=[Ocorre quando um feitiço for interrompido.

O ícone pode ser filtrado pela magia que for interrompida. A magia que interrompeu pode ser acessada com a substituição [extra] na exibição de texto.

Note que a diferença entre dois eventos de interrupção - ambos irão sempre ocorrer quando uma magia for interrompida, mas cada magia pode ser filtrada de forma diferente.]=]
L["CLEU_SPELL_INTERRUPT_SPELL"] = "Interrupção - Magia Usada"
L["CLEU_SPELL_INTERRUPT_SPELL_DESC"] = [=[Ocorre quando o lançamento de uma magia é interrompida.

Ícone pode ser filtrado pela magia que causou interrupção. A magia qua foi interrompida pode ser acessada com a substituição [Extra] na exibição de texto.

Note que a diferença entre duas interrupções - ambas sempre ocorrerão quando uma magia for interrompida, mas cada filtro é registrado separadamente.]=]
L["CLEU_SPELL_LEECH"] = "Consumo de Recursos"
L["CLEU_SPELL_LEECH_DESC"] = "Ocorre quando os recursos (saúde/mana/raiva/energia/etc) são removidos de uma unidade e dado a outro."
L["CLEU_SPELL_MISSED"] = "Erro de Magia"
L["CLEU_SPELL_PERIODIC_DAMAGE"] = "Dano Periódico"
L["CLEU_SPELL_PERIODIC_DRAIN"] = "Drenagem Periódica de Recursos"
L["CLEU_SPELL_PERIODIC_ENERGIZE"] = "Ganho Periódico de Recursos"
L["CLEU_SPELL_PERIODIC_HEAL"] = "Cura Periódica"
L["CLEU_SPELL_PERIODIC_LEECH"] = "Sucção Periódica"
L["CLEU_SPELL_PERIODIC_MISSED"] = "Erros Periódicos"
L["CLEU_SPELL_REFLECT"] = "Magias Refletidas"
L["CLEU_SPELL_REFLECT_DESC"] = [=[Ocorre quando você repele um feitiço à seu lançador.

A unidade de origem é àquele quem reflete o feitiço, e a unidade de destino é quem irá receber de volta.]=]
L["CLEU_SPELL_STOLEN_DESC"] = [=[Ocorre quando um buff for roubado, provavelmente por %s.

Ícone pode ser filtrado pela magia que foi roubada.]=]
L["CLEU_SWING_DAMAGE"] = "Balanço de Danos"
L["CLEU_SWING_MISSED"] = "Balanço de Erros"
L["CLEU_TIMER"] = "Temporizador para ajustar evento"
L["CLEU_TIMER_DESC"] = [=[Duração do cronômetro, em segundos, para definir quando o evento acontecerá.

Você pode definir as durações usando a sintaxe "Magia: Duração" no campo %q para ser usado sempre que usar a magia que você definiu como um filtro.

Se não houver duração para a magia, ou você não tiver nenhum filtro definido (o campo estiver vazio), então esta duração será usada.]=]
L["CLEU_UNIT_DESTROYED"] = "Unidade Destruída"
L["CLEU_UNIT_DESTROYED_DESC"] = "Ocorre quando uma unidade, como um totem, for destruído."
L["CLEU_UNIT_DIED"] = "Unidade Morta"
L["CMD_CHANGELOG"] = "Registro de Mudanças"
L["CMD_OPTIONS"] = "Opções"
L["CNDT_ONLYFIRST"] = "Apenas a primeira magia/item será verificado - listas delimitadas por ponto e vírgula não são válidas para esta condição."
L["CNDTCAT_ATTRIBUTES_PLAYER"] = "Atributos do jogador"
L["CNDTCAT_ATTRIBUTES_UNIT"] = "Atributos da unidade"
L["CNDTCAT_BUFFSDEBUFFS"] = "Bônus/Penalidades"
L["CNDTCAT_CURRENCIES"] = "Moedas"
L["CNDTCAT_FREQUENTLYUSED"] = "Frequentemente usado"
L["CNDTCAT_RESOURCES"] = "Recursos"
L["CNDTCAT_SPELLSABILITIES"] = "Feitiços/itens"
L["CNDTCAT_STATS"] = "Status de combate"
L["CODETOEXE"] = "Codigo para executar"
L["COLOR_MSQ_COLOR"] = "Cor da máscara de borda"
L["COLOR_MSQ_COLOR_DESC"] = "Marcando isto fará com que a borda da máscara (se o estilo que você está usando tiver borda) seja colorida."
L["COLOR_MSQ_ONLY"] = "Apenas a cor da borda da máscara"
L["COLOR_MSQ_ONLY_DESC"] = "Marcando isto fará APENAS a bordar da máscara (se o estilo que você está usando tiver borda) seja colorida. Ícones NÃO serão coloridos"
L["COLOR_OVERRIDE_GLOBAL"] = "Substituir Cores Gerais"
L["COLOR_OVERRIDE_GLOBAL_DESC"] = "Marque para configurar as cores independentes das cores gerais."
L["COLOR_OVERRIDE_GROUP"] = "Substituir Grupo de Cores"
L["COLOR_OVERRIDE_GROUP_DESC"] = "Marque para configurar as cores independente das cores específicas do grupo."
L["COLORPICKER_BRIGHTNESS"] = "Brilho"
L["COLORPICKER_DESATURATE"] = "Dessaturar"
L["COLORPICKER_ICON"] = "Visualizar"
L["COLORPICKER_OPACITY"] = "Opacidade"
L["COLORPICKER_RECENT"] = "Cores Recentes"
L["COLORPICKER_RECENT_DESC"] = [=[|cff7fffffClique|r para carregar esta cor.
|cff7fffffBotão Direito|r para remover desta lista.]=]
L["COLORPICKER_SATURATION"] = "Saturação"
L["COLORPICKER_SATURATION_DESC"] = "Ajustar a saturação da cor."
L["COLORPICKER_STRING"] = "String Hexadecimal"
L["COLORPICKER_SWATCH"] = "Cor"
L["COMPARISON"] = "Comparação"
L["CONDITION_TIMERS_FAIL_DESC"] = "Duração do temporizador para ajustar o ícone quando as condições falharem."
L["CONDITION_TIMERS_SUCCEED_DESC"] = "Duração do temporizador para ajustar o ícone quando as condições derem certo."
L["CONDITIONALPHA_METAICON"] = "Condições Falhas"
L["CONDITIONPANEL_ABSOLUTE"] = "Atual"
L["CONDITIONPANEL_ADD"] = "Adicionar  uma condição"
L["CONDITIONPANEL_ALIVE"] = "Unidade está Viva"
L["CONDITIONPANEL_ALIVE_DESC"] = "A condição será passada se a unidade especifica estiver viva."
L["CONDITIONPANEL_ALTPOWER"] = "Poder Alt."
L["CONDITIONPANEL_ALTPOWER_DESC"] = "Isto é o poder de encontro especifico usado em diversas missões e chefes."
L["CONDITIONPANEL_AND"] = "E"
L["CONDITIONPANEL_ANDOR"] = "E / Ou"
L["CONDITIONPANEL_AUTOCAST"] = "Autolançar magia do ajudante"
L["CONDITIONPANEL_BITFLAGS_ALWAYS"] = "Sempre verdade"
L["CONDITIONPANEL_BITFLAGS_CHECK"] = "Anular Seleção"
L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_CONTINENT"] = "Escolha os Continentes..."
L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_RAIDICON"] = "Escolha os Ícones..."
L["CONDITIONPANEL_BITFLAGS_CHOOSERACE"] = "Escolha as Raças..."
L["CONDITIONPANEL_CASTTOMATCH"] = "Feitiços para combinar"
L["CONDITIONPANEL_CASTTOMATCH_DESC"] = [=[Digite o nome de uma magia para criar uma condição que passe somente se a magia combinar. 

Você pode deixar isto em branco para verificar qualquer e toda magia/canal]=]
L["CONDITIONPANEL_CLASS"] = "classe de unidade"
L["CONDITIONPANEL_CLASSIFICATION"] = "Classificação da unidade."
L["CONDITIONPANEL_COMBAT"] = "unidade em combate"
L["CONDITIONPANEL_COMBO"] = "Pontos de Combo"
L["CONDITIONPANEL_DEFAULT"] = "Escolha um tipo,,,"
L["CONDITIONPANEL_ECLIPSE_DESC"] = "Eclipse tem um alcance de -100 (eclipse lunar) até 100 (eclipse solar). Insira -80 se quiser que o ícone apareça com um valor de 80 poder lunar."
L["CONDITIONPANEL_EQUALS"] = "Igual a"
L["CONDITIONPANEL_EXISTS"] = "Unidade Existe"
L["CONDITIONPANEL_GREATER"] = "Maior Que"
L["CONDITIONPANEL_GREATEREQUAL"] = "Maior ou Igual a"
L["CONDITIONPANEL_GROUPTYPE"] = "Tipo de Grupo"
L["CONDITIONPANEL_ICON"] = "Ícone Mostrado"
L["CONDITIONPANEL_ICON_DESC"] = [=[A condição será verdadeira se o ícone especificado estiver sendo exibido ou oculto.

Se você não quiser exibir os ícones que estão marcados, marque %q no editor de ícone deste ícone.

O grupo do ícone marcado deve ser exibido em ordem de marcação, mesmo se a condição estiver como ocultar.]=]
L["CONDITIONPANEL_ICON_HIDDEN"] = "Esconder"
L["CONDITIONPANEL_ICON_SHOWN"] = "Mostrar"
L["CONDITIONPANEL_INSTANCETYPE"] = "Tipos de Instância"
L["CONDITIONPANEL_INSTANCETYPE_DESC"] = "Marque o tipo da instância que você deseja ir, incluindo a dificuldade de qualquer masmorra ou raid."
L["CONDITIONPANEL_INTERRUPTIBLE"] = "Interruptível"
L["CONDITIONPANEL_ITEMRANGE"] = "item no alcance da unidade"
L["CONDITIONPANEL_LESS"] = "Menor Que"
L["CONDITIONPANEL_LESSEQUAL"] = "Menor ou Igual a"
L["CONDITIONPANEL_LEVEL"] = "Nível da unidade"
L["CONDITIONPANEL_LOC_CONTINENT"] = "Continente"
L["CONDITIONPANEL_LOC_SUBZONE"] = "Subzona"
L["CONDITIONPANEL_LOC_ZONE"] = "Zona"
L["CONDITIONPANEL_MANAUSABLE"] = "Feitiço utilizável (Mana/Energia/etc.)"
L["CONDITIONPANEL_MAX"] = "Maximo"
L["CONDITIONPANEL_MOUNTED"] = "Montada"
L["CONDITIONPANEL_NAME"] = "Nome da unidade"
L["CONDITIONPANEL_NAMETOMATCH"] = "Nome para combinar"
L["CONDITIONPANEL_NAMETOOLTIP"] = "Digite múltiplos nomes para serem combinados, separando-os com um ponto e vírgula(;). A condição será permitida se alguns nomes forem combinados."
L["CONDITIONPANEL_NOTEQUAL"] = "Diferente de"
L["CONDITIONPANEL_OPERATOR"] = "Operador"
L["CONDITIONPANEL_OR"] = "Ou"
L["CONDITIONPANEL_PETMODE"] = "Modo de ataque do ajudante"
L["CONDITIONPANEL_PETMODE_NONE"] = "Sem Pet"
L["CONDITIONPANEL_POWER"] = "Recurso primário"
L["CONDITIONPANEL_POWER_DESC"] = "Vai checar a energia se a unidade for um druida em forma de felino, raiva se for um guerreiro, etc."
L["CONDITIONPANEL_PVPFLAG"] = "Marcado Unidade PvP"
L["CONDITIONPANEL_RAIDICON"] = "Ìcone da unidade da raid"
L["CONDITIONPANEL_REMOVE"] = "Remova esta condição"
L["CONDITIONPANEL_RESTING"] = "Descansando"
L["CONDITIONPANEL_ROLE"] = "Função da unidade"
L["CONDITIONPANEL_RUNES_DESC3"] = "Use esta condição para verificar quando a quantidade de runa desejada estiver disponível."
L["CONDITIONPANEL_RUNESLOCK"] = "Contador de Runa Travado"
L["CONDITIONPANEL_RUNESLOCK_DESC"] = "Use esta condição para verificar quando as runas estiverem travadas (esperando recarga)."
L["CONDITIONPANEL_RUNESRECH"] = "Contador de Recarga de Runa"
L["CONDITIONPANEL_RUNESRECH_DESC"] = "Use esta condição para verificar quando as runas estiverem recarregando."
L["CONDITIONPANEL_SPELLRANGE"] = "feitiço no alcance da unidade"
L["CONDITIONPANEL_SWIMMING"] = "Nadando"
L["CONDITIONPANEL_THREAT_RAW"] = "Ameaça da unidade - bruto"
L["CONDITIONPANEL_THREAT_RAW_DESC"] = [=[Esta condição verifica seu percentual de ameaça bruta na unidade.

Jogadores de ataque corpo-a-corpo atraem os monstros em 110%.
Jogadores de ataque a distância atraem os monstros em 130%
Jogadores em combate tem ameaça bruta de 255%]=]
L["CONDITIONPANEL_THREAT_SCALED"] = "Ameça da unidade - Escalada"
L["CONDITIONPANEL_THREAT_SCALED_DESC"] = [=[Esta condição verifica seu percentual de ameaça na unidade.

100% indica que você está detendo a unidade.]=]
L["CONDITIONPANEL_TIMER_DESC"] = "Marque o valor do tempo que você deseja estabilizar e modificar pelo \"Manipulador de Cronômetro\""
L["CONDITIONPANEL_TRACKING"] = "Rastreamento ativado"
L["CONDITIONPANEL_TYPE"] = "Tipo"
L["CONDITIONPANEL_UNIT"] = "Unidade"
L["CONDITIONPANEL_UNITISUNIT"] = "Unidade é unidade"
L["CONDITIONPANEL_UNITISUNIT_DESC"] = "Esta condição acontecerá se a unidade na primeira e segunda caixa de edição forem as mesmas."
L["CONDITIONPANEL_UNITISUNIT_EBDESC"] = "Insira a unidade no campo para ser comparada com a primeira."
L["CONDITIONPANEL_UNITRACE"] = "Raça da Unidade"
L["CONDITIONPANEL_UNITSPEC"] = "Especialização da Unidade"
L["CONDITIONPANEL_UNITSPEC_CHOOSEMENU"] = "Escolha Espec..."
L["CONDITIONPANEL_UNITSPEC_DESC"] = [=[Esta condição APENAS funciona com:
|cff7fffff-|r Você mesmo
|cff7fffff-|r Inimigos do campo de batalha
|cff7fffff-|r Inimigos de Arena

NÃO funciona com: |TInterface/AddOns/TellMeWhen/Textures/Alert:0:2|t
|cff7fffff-|r Membros de Grupo
|cff7fffff-|r Todos os outros jogadores]=]
L["CONDITIONPANEL_VALUEN"] = "Valor"
L["CONDITIONPANEL_VEHICLE"] = "Unidade de controle do veículo"
L["CONDITIONPANEL_ZONEPVP"] = "Tipo da Zona PvP"
L["CONDITIONS"] = "Condição"
L["CONFIGMODE"] = "TellMeWhen está em modo de ajuste. Os ícones não funcionarão enquanto você não sair deste modo. Digite '/tellmewhen' ou '/tmw' para alternar alternar os modos."
L["CONFIGMODE_EXIT"] = "Sair do modo de configuração"
L["CONFIGMODE_NEVERSHOW"] = "Não mostrar de novo."
L["CONFIGPANEL_COMM_HEADER"] = "Comunicação"
L["CONFIGPANEL_MEDIA_HEADER"] = "Mídia"
L["CONFIRM_DELETE_GENERIC_DESC"] = "%s será apagado."
L["CONFIRM_DELGROUP"] = "Apagar Grupo"
L["CONFIRM_DELLAYOUT"] = "Apagar Layout"
L["CONFIRM_HEADER"] = "Tem certeza?"
L["COPYGROUP"] = "copiar grupo"
L["COPYPOSSCALE"] = "Copiar apenas posição/escala"
L["CrowdControl"] = "controle de grupo"
L["Curse"] = "maldição"
L["DamageBuffs"] = "Bônus de Dano"
L["DEBUFFTOCHECK"] = "Verificar Penalidade"
L["DEBUFFTOCOMP1"] = "1ª Penalidade à Comparar"
L["DEBUFFTOCOMP2"] = "2º Penalidade à Comparar"
L["DEFAULT"] = "Padrão"
L["DefensiveBuffs"] = "Bônus de Defesa"
L["DefensiveBuffsAOE"] = "Bônus de Defesa em Área"
L["DefensiveBuffsSingle"] = "Bônus Defensivo no Alvo"
L["DESCENDING"] = "Descendente"
L["DISABLED"] = "Desativado"
L["Disease"] = "Doente"
L["Disoriented"] = "Desorientado"
L["DOWN"] = "Abaixo"
L["DR-Disorient"] = "Desorientados"
L["DR-Silence"] = "Silêncios"
L["DR-Taunt"] = "Provocações"
L["DT_DOC_LocType"] = "Retorna o tipo de efeito de perda de controle que o ícone está indicando. (Esta marcação deve ser usada apenas com ícones do tipo %s)."
L["DURATION"] = "Duração"
L["EARTH"] = "Terra"
L["ECLIPSE_DIRECTION"] = "Direção do Eclipse"
L["elite"] = "Elite"
L["ENABLINGOPT"] = "TellMeWhen_Options está desativado. Ativando..."
L["Enraged"] = "Enraivecer"
L["ERROR_MISSINGFILE"] = [=[Reinicie o WoW completamente para usar o TellMeWhen %s 

%s não foi encontrado.

Gostaria de reiniciar o WoW agora ?]=]
L["ERROR_MISSINGFILE_NOREQ"] = [=[A reinicialização do WoW pode ser necessária para usar o TellMeWhen

%s não foi encontrado.

Você gostaria de reiniciar o WoW agora?]=]
L["ERROR_MISSINGFILE_REQFILE"] = "Um arquivo necessário"
L["ERROR_NOTINITIALIZED_NO_ACTION"] = "TellMeWhen não pode executar esta ação se o addon falhou ao inicializar!"
L["ERROR_NOTINITIALIZED_NO_LOAD"] = "TellMeWhen_Options não foi carregado então o TellMeWhen falha na inicialização!"
L["EVENT_CATEGORY_TIMER"] = "Temporizador"
L["EVENT_CATEGORY_VISIBILITY"] = "Visibilidade"
L["EVENTHANDLER_COUNTER_TAB"] = "Contador"
L["EVENTS_SETTINGS_CNDTJUSTPASSED"] = "E só começou a passar"
L["EVENTS_SETTINGS_CNDTJUSTPASSED_DESC"] = "Impede que a notificação seja manipulada, a menos que a condição acima seja configurada."
L["EVENTS_SETTINGS_COUNTER_AMOUNT"] = "Valor"
L["EVENTS_SETTINGS_COUNTER_HEADER"] = "Ajustar Contador"
L["EVENTS_SETTINGS_COUNTER_NAME"] = "Nome do Contador"
L["EVENTS_SETTINGS_HEADER"] = "Ajustes de Ativadores"
L["EVENTS_SETTINGS_ONLYSHOWN"] = [=[Apenas tratar se o ícone é visto.
Este evento deveria  acontecer apenas se o ícone é visto.]=]
L["EVENTS_SETTINGS_ONLYSHOWN_DESC"] = "Impede o evento se o ícone não estiver sendo mostrado."
L["EVENTS_SETTINGS_PASSINGCNDT"] = "Manipular apenas se aceitar a condição:"
L["EVENTS_SETTINGS_PASSINGCNDT_DESC"] = "Impedir que a notificação seja manipulada, a menos que a condição abaixo seja configurada."
L["EVENTS_SETTINGS_PASSTHROUGH"] = "Continuar a reduzir eventos"
L["EXPORT_f"] = "Exportar %s"
L["EXPORT_HEADING"] = "Exportar"
L["EXPORT_TOCOMM"] = "Para Jogador"
L["EXPORT_TOCOMM_DESC"] = [=[Digite o nome do jogador e escolha esta opção para enviar os dados. Devem ser alguém que você possa enviar um sussurro (Mesma facção, servidor e esteja online), e eles devem ter o TellMeWhen v4.0.0 ou mais recente.

You can also type "GUILD" or "RAID" (case-sensitive) to send to your entire guild or raid group.]=]
L["EXPORT_TOGUILD"] = "Para Guild"
L["EXPORT_TORAID"] = "Para Raid"
L["EXPORT_TOSTRING"] = "Para String"
L["EXPORT_TOSTRING_DESC"] = "Uma string contendo os dados necessários para serem colados na caixa de edição. Pressione Ctrl+C para copiar, e então cole isto onde você queria compartilhar."
L["FALSE"] = "Falso"
L["Feared"] = "Medo"
L["fGROUP"] = "Grupo: %s"
L["fICON"] = "ìcone: %s"
L["FIRE"] = "Fogo"
L["FONTCOLOR"] = "Cor da fonte"
L["FONTSIZE"] = "Tamanho da fonte"
L["FORWARDS_IE"] = "Avançar"
L["FORWARDS_IE_DESC"] = "Carregar o proximo ícone que foi editado (%s |T%s:0|t)."
L["fPROFILE"] = "Perfil: %s"
L["FROMNEWERVERSION"] = "Você importou dados que foram criados em uma versão mais recente do TellMeWhen. Algumas configurações podem não funcionar até você atualizar para a última versão."
L["GCD"] = "Recarga Global"
L["GCD_ACTIVE"] = "TRG ativo"
L["GROUPCONDITIONS"] = "Condições de Grupo"
L["GROUPICON"] = "Grupo: %s, Ícone: %s"
L["Heals"] = "Curas do Jogador"
L["HELP_BUFF_NOSOURCERPPM"] = [=[Parece que você está tentando rastrear %s, que é um bônus que usa sistema RPPM.

Devido a um erro da Blizzard, este bônus não pode ser rastreado se você tiver a opção %q ativada.

Desative esta configuração se você quiser rastrear este bônus corretamente.]=]
L["HELP_EXPORT_DOCOPY_MAC"] = "Pressione |cff7fffffCMD+C|r para copiar"
L["HELP_EXPORT_DOCOPY_WIN"] = "Pressione |cff7fffffCTRL+C|r para copiar"
L["HELP_NOUNIT"] = "Você deve digitar uma unidade!"
L["HELP_NOUNITS"] = "Você deve ter no mínimo uma unidade!"
L["ICON"] = "ícone"
L["ICON_TOOLTIP2NEW"] = [=[|cff7fffffBotão direito|r para opções.
|cff7fffffBotão esquerdo e arraste|r para mover este grupo.
|cff7fffffBotão direito e arraste|r para mover/copiar para outro ícone.
|cff7fffffArraste|r magias ou itens dentro do ícone para ajuste rápido.]=]
L["ICON_TOOLTIP2NEWSHORT"] = "|cff7fffffBotão-direito|r para opções do ícone."
L["ICONALPHAPANEL_FAKEHIDDEN"] = "Sempre Esconder"
L["ICONALPHAPANEL_FAKEHIDDEN_DESC"] = [=[Força o ícone ser oculto por todo tempo enquanto estiver funcionando normalmente.

|cff7fffff-|r O ícone pode ser marcado por condições de outros ícones.
|cff7fffff-|r Ícones Meta podem exibir este ícone.
|cff7fffff-|r Estas notificações de ícones serão processadas.]=]
L["ICONGROUP"] = "Ícone: %s (Grupo: %s)"
L["ICONMENU_ABSENT"] = "Ausente"
L["ICONMENU_ADDMETA"] = "Adicionar Ícone Meta"
L["ICONMENU_ALLSPELLS"] = "Toda Magia Usável"
L["ICONMENU_ANCHORTO"] = "Ancorar em %s"
L["ICONMENU_ANCHORTO_UIPARENT"] = "Reiniciar âncora"
L["ICONMENU_ANYSPELLS"] = "Toda Magia Útil"
L["ICONMENU_APPENDCONDT"] = "Adicionar como condição %q "
L["ICONMENU_BAROFFS"] = [=[Esta quantidade será adicionada à barra de forma que seja compensada.

Útil para personalizar indicadores de quando você deve lançar uma magia para impedir a perca do bônus, ou para indicar o poder necessário para lançar uma magia e sobrar algo para poder interromper.]=]
L["ICONMENU_BOTH"] = "Ou"
L["ICONMENU_BUFF"] = "Bônus"
L["ICONMENU_BUFFCHECK"] = "Verificar Bônus/Penalidade"
L["ICONMENU_BUFFCHECK_DESC"] = [=[Marcar se for um bônus estiver ausente de alguma unidade.

Usar este ícone para verificar se falta algum bônus de raid.

A maioria de outras situações deve usar o tipo de ícone %q .]=]
L["ICONMENU_BUFFDEBUFF"] = "Bônus/Penalidade"
L["ICONMENU_BUFFDEBUFF_DESC"] = "Rastrear bônus e/ou penalidades."
L["ICONMENU_BUFFTYPE"] = "Bônus ou Penalidade"
L["ICONMENU_CAST"] = "Lançar Magia"
L["ICONMENU_CAST_DESC"] = "Rastrear magias e canais."
L["ICONMENU_CHECKNEXT"] = "Expandir Sub-metas"
L["ICONMENU_CHECKNEXT_DESC"] = [=[Marcando esta opção irá fazer com que os ícones metas iniciem a verificação e expansão de seus componentes, repetindo até que não reste nenhum.

Além disso, este ícone não mostrará todos os ícones que já foram exibidos por outro ícone meta antes deste.

]=]
L["ICONMENU_CHOOSENAME_WPNENCH_DESC"] = [=[Digite o nome(s) da arma embutida que você quer monitorar. Você pode adicionar várias entradas, separando-as com ponto e vírgula (;).

|cFFFF5959IMPORTANTE|r: Nomes embutidos devem ser digitados exatamente como eles aparecem nas dicas de sua arma enquanto o embutir estiver ativo (ex. "%s", não "%s").]=]
L["ICONMENU_CHOOSENAME3"] = "O que rastrear"
L["ICONMENU_CLEU"] = "Combate"
L["ICONMENU_CLEU_DESC"] = [=[Rastrear eventos de combate

Exemplos: Magias refletidas, erros, lançamentos instantâneos e mortes, mas o ícone pode rastrear qualquer coisa virtualmente.]=]
L["ICONMENU_CNDTIC"] = "Ícone de condição"
L["ICONMENU_CNDTIC_DESC"] = "Monitora o estado de condições."
L["ICONMENU_COMPONENTICONS"] = "Ícones & Grupos de componentes"
L["ICONMENU_COOLDOWNCHECK"] = "Checagem de recarga"
L["ICONMENU_COOLDOWNCHECK_DESC"] = "Marque isto para fazer com que o ícone seja considerado inutilizável caso esteja carregando."
L["ICONMENU_COPYHERE"] = "Copie aqui"
L["ICONMENU_COUNTING"] = "Tempo correndo"
L["ICONMENU_CUSTOMTEX"] = "Textura Personalizada"
L["ICONMENU_DEBUFF"] = "Penalidade"
L["ICONMENU_DISPEL"] = "Tipo de Dispersão"
L["ICONMENU_DONTREFRESH"] = "Não Atualizar"
L["ICONMENU_DR"] = "Rendimentos Decrescentes"
L["ICONMENU_DR_DESC"] = "Monitora a duração e extensão de retornos diminutivos."
L["ICONMENU_DRABSENT"] = "Inalterado"
L["ICONMENU_DRPRESENT"] = "Alterado"
L["ICONMENU_DRS"] = "Retornos diminutivos"
L["ICONMENU_DURATION_MAX_DESC"] = "Duração máxima permitida para exibir o ícone, em segundos"
L["ICONMENU_DURATION_MIN_DESC"] = "Duração mínima necessária para exibir o ícone, em segundos"
L["ICONMENU_ENABLE"] = "Habilitado"
L["ICONMENU_ENABLE_PROFILE"] = "Ativado para o perfil"
L["ICONMENU_FOCUS"] = "Foco"
L["ICONMENU_FOCUSTARGET"] = "Alvo do foco"
L["ICONMENU_FRIEND"] = "Amigável"
L["ICONMENU_HIDEUNEQUIPPED"] = "Ocultar quando faltar arma no slot"
L["ICONMENU_HOSTILE"] = "Hostil"
L["ICONMENU_ICD"] = "Temporizador Interno"
L["ICONMENU_ICD_DESC"] = [=[Rastreia o tempo de recarga de um processo ou efeito similar.

|cFFFF5959IMPORTANTE|r: Veja as dicas nas configurações de %q de como controlar cada tipo de recarga.]=]
L["ICONMENU_ICDBDE"] = "Bônus/Dano/Energizar/Invocação"
L["ICONMENU_IGNORENOMANA"] = "Ignorar perda de força"
L["ICONMENU_IGNORERUNES"] = "Ignorar Runas"
L["ICONMENU_IGNORERUNES_DESC"] = "Marque esta opção para tratar como útil o tempo de recarga se a única coisa impedindo é o tempo (ou tempo de recarga global)."
L["ICONMENU_INVERTBARS"] = "Preencher barras"
L["ICONMENU_ITEMCOOLDOWN"] = "Recarga do Item"
L["ICONMENU_ITEMCOOLDOWN_DESC"] = "Rastrear as recargas dos itens com efeitos de Uso."
L["ICONMENU_MANACHECK"] = "Checar poder"
L["ICONMENU_MANACHECK_DESC"] = "Marque isto para ativar a mudança de cor do ícone quando você ficar sem mana/raiva/poderes/etc."
L["ICONMENU_META"] = "Ícone Meta"
L["ICONMENU_META_DESC"] = [=[Combinar vários ícones em um.

Ícones que tiverem %q marcado continuarão mostrando em um ícone meta mesmo se outra forma for exibida.]=]
L["ICONMENU_MOUSEOVER"] = "Passar o mouse"
L["ICONMENU_MOUSEOVERTARGET"] = "Passar o mouse no alvo"
L["ICONMENU_MOVEHERE"] = "Mover aqui"
L["ICONMENU_NAMEPLATE"] = "Placa de Identificação"
L["ICONMENU_NOTCOUNTING"] = "Tempo sem correr"
L["ICONMENU_NOTREADY"] = "Não está Pronto"
L["ICONMENU_OFFS"] = "Deslocamento"
L["ICONMENU_ONCOOLDOWN"] = "Recarregando"
L["ICONMENU_ONLYBAGS"] = "Apenas se nas bolsas"
L["ICONMENU_ONLYBAGS_DESC"] = "Marque isto para mostrar o ícone apenas se o item estiver no seu inventário (ou equipado). Se \"Apenas se equipado\" estiver habilitado, esta opção será habilitada automaticamente."
L["ICONMENU_ONLYEQPPD"] = "Apenas se equipado"
L["ICONMENU_ONLYEQPPD_DESC"] = "Marque isto para que o ícone exiba apenas se o item for equipado."
L["ICONMENU_ONLYINTERRUPTIBLE"] = "Apenas Interrompível"
L["ICONMENU_ONLYINTERRUPTIBLE_DESC"] = "Marque esta opção para mostrar apenas lançamentos de habilidades interrompíveis."
L["ICONMENU_ONLYMINE"] = "Mostrar somente o meu"
L["ICONMENU_ONLYSEEN"] = "Apenas Magias Observadas"
L["ICONMENU_ONLYSEEN_DESC"] = "Marque isto para que o ícone mostre se a unidade tiver capacidade de lançar ao menos uma vez."
L["ICONMENU_OO_F"] = "Fora de %s"
L["ICONMENU_OORANGE"] = "Fora de Alcance"
L["ICONMENU_PETTARGET"] = "Alvo do Pet"
L["ICONMENU_PRESENT"] = "Presente"
L["ICONMENU_RANGECHECK"] = "Verificação de alcance"
L["ICONMENU_RANGECHECK_DESC"] = "Marque isto para ativar a mudança de cor do ícone quando você ficar muito longe."
L["ICONMENU_REACT"] = "Reação da Unidade"
L["ICONMENU_REACTIVE"] = "Habilidade Reativa"
L["ICONMENU_REACTIVE_DESC"] = [=[Monitora a usabilidade de habilidades reativas.

Habilidades reativas são coisas como %s, %s and %s - habilidades que são usáveis apenas quando algumas condições são cumpridas.]=]
L["ICONMENU_READY"] = "Pronto"
L["ICONMENU_RUNES"] = "Tempo de Runa"
L["ICONMENU_RUNES_DESC"] = "Rastrear recargas de runas"
L["ICONMENU_SHOWCBAR_DESC"] = "Exibe uma barra em na metade inferior do ícone que exibirá o temporizador."
L["ICONMENU_SHOWPBAR_DESC"] = "Exibe uma barra na metade superior do ícone que exibirá o poder necessário para lançar a magia."
L["ICONMENU_SHOWSTACKS"] = "Mostrar acúmulo"
L["ICONMENU_SHOWSTACKS_DESC"] = "Marque esta opção para mostrar o número acumulado do item que você possui."
L["ICONMENU_SHOWTIMER"] = "Mostrar o tempo"
L["ICONMENU_SHOWTIMERTEXT"] = "Mostrar texto de contagem"
L["ICONMENU_SHOWTIMERTEXT_DESC"] = [=[Marque esta opção para mostrar em texto o tempo de recarga/duração restante no ícone.

Para que isto funcione, você deve ter o OmniCC instalado, ou você precisará ativar o texto em temporizador da Blizzard nas opções de interface, abaixo da categoria de Barras de Ação.]=]
L["ICONMENU_SHOWWHEN"] = "Mostrar ícone quando"
L["ICONMENU_SORT_STACKS_ASC"] = "Pilhas baixas"
L["ICONMENU_SORT_STACKS_ASC_DESC"] = "Marque esta caixa para priorizar e exibir magias com menos pilha."
L["ICONMENU_SORT_STACKS_DESC"] = "Pilhas elevadas"
L["ICONMENU_SORT_STACKS_DESC_DESC"] = "Marque esta caixa para priorizar e exibir magias com altas pilhas."
L["ICONMENU_SORTASC"] = "Baixa duração"
L["ICONMENU_SORTASC_DESC"] = "Marque esta opção para priorizar e mostrar habilidades com a menor duração."
L["ICONMENU_SORTDESC"] = "Alta duração"
L["ICONMENU_SORTDESC_DESC"] = "Marque esta opção para priorizar e mostrar habilidades com a maior duração."
L["ICONMENU_SPELLCAST_COMPLETE"] = "Fim do lançamento de habilidade/Lançamento instantâneo"
L["ICONMENU_SPELLCAST_COMPLETE_DESC"] = [=[Selecione esta opção se o cooldown interno começa quando:

|cff7fffff1)|r Você termina de lançar uma habilidade, ou
|cff7fffff2)|r Você lança uma habilidade instantânea.

Você precisa inserir o nome/ID do lançamento de habilidade que aciona o cooldown interno na caixa de edição %q.]=]
L["ICONMENU_SPELLCAST_START"] = "Iniciar Lançamento de Magia"
L["ICONMENU_SPELLCAST_START_DESC"] = [=[Selecione esta opção se o cooldown interno começa quando:

|cff7fffff1)|r Você começa a lançar uma habilidade.

Você precisa inserir o nome/ID do lançamento de habilidade que aciona o cooldown interno na caixa de edição %q.]=]
L["ICONMENU_SPELLCOOLDOWN"] = "Recarga do Feitiço"
L["ICONMENU_SPELLCOOLDOWN_DESC"] = "Rastreia as recargas dos feitiços do seu grimório."
L["ICONMENU_SPLIT"] = "Dividir em um novo grupo"
L["ICONMENU_SPLIT_DESC"] = "Criar um novo grupo e mover este ícone. Muitas configurações irão de um grupo a outro novo."
L["ICONMENU_STACKS_MAX_DESC"] = "Número máximo de stacks permitidos a mostrar o ícone"
L["ICONMENU_STACKS_MIN_DESC"] = "Número mínimo de stacks necessários para mostrar o ícone"
L["ICONMENU_STATECOLOR"] = "Cor & Textura do Ícone"
L["ICONMENU_STATUE"] = "Estátua Monge"
L["ICONMENU_SWAPWITH"] = "Trocar com"
L["ICONMENU_TARGETTARGET"] = "Alvo do alvo"
L["ICONMENU_TOTEM"] = "Totem"
L["ICONMENU_TOTEM_DESC"] = "Rastrear seus totens."
L["ICONMENU_TOTEM_GENERIC_DESC"] = "Localizar seu %s."
L["ICONMENU_TYPE"] = "Tipo do ícone"
L["ICONMENU_UNIT_DESC"] = [=[Indique as unidades para monitorar. Unidades devem ser inseridas à partir da lista de sugestão a direita ou pelo nome de suas próprias unidades.

Unidades padrões (ex. jogador) e/ou os nomes dos jogadores estão agrupados com (ex., %s) podem ser usados como unidades.

Separe várias unidades com ponto-e-vírgula (;).

Para mais informação sobre unidades, vá em http://www.wowpedia.org/UnitId]=]
L["ICONMENU_UNITCOOLDOWN"] = "Recarga de Unidades"
L["ICONMENU_UNITCOOLDOWN_DESC"] = [=[Rastreia a recarga de outra pessoa.

%s pode ser rastreado usando %q como nome.]=]
L["ICONMENU_UNITS"] = "Unidades"
L["ICONMENU_UNITSTOWATCH"] = "Quem assistir"
L["ICONMENU_UNUSABLE"] = "Inutilizável"
L["ICONMENU_USABLE"] = "Utilizável"
L["ICONMENU_USEACTIVATIONOVERLAY"] = "Verificar borda de ativação"
L["ICONMENU_USEACTIVATIONOVERLAY_DESC"] = "Marque isto para fazer com que uma moldura amarela brilhante apareça envolta da ação que será utilizável."
L["ICONMENU_VEHICLE"] = "Veículo"
L["ICONMENU_WPNENCHANT"] = "Encantamento da Arma"
L["ICONMENU_WPNENCHANT_DESC"] = "Monitora encantamentos temporários de arma."
L["ICONMENU_WPNENCHANTTYPE"] = "Slot de arma a ser monitorado"
L["ICONTOCHECK"] = "Ícone a marcar"
L["IE_NOLOADED_GROUP"] = "Escolha o grupo para carregar:"
L["IE_NOLOADED_ICON"] = "Nenhum ícone carregado!"
L["ImmuneToMagicCC"] = "Imune a Mágica de Controle (CC)"
L["ImmuneToStun"] = "Imune a Atordoamento"
L["IMPORT_EXPORT"] = "Importar/Exportar/Restaurar"
L["IMPORT_EXPORT_BUTTON_DESC"] = "Clique neste botão para importar e exportar ícones, grupos e perfis."
L["IMPORT_EXPORT_DESC"] = [=[Clique no botão a direita para importar e exportar ícones, grupos e perfis.

Importando para ou da string, ou exportando para outro jogador, precisará da caixa de edição. Veja as dicas do menu para mais detalhes.]=]
L["IMPORT_FROMBACKUP"] = "Do Backup"
L["IMPORT_FROMBACKUP_DESC"] = [=[As opções restauradas desse menu ficarão como estavam às: %s
		%s é um tempo, ex. "03:45:67 PM"]=]
L["IMPORT_FROMBACKUP_WARNING"] = "CONFIGURAÇÕES DE BACKUP: s%"
L["IMPORT_FROMCOMM"] = "Do Jogador "
L["IMPORT_FROMCOMM_DESC"] = "Se outro usuário do TellMeWhen enviar alguns dados de configuração, você poderá permitir a importação destes dados  a partir deste submenu."
L["IMPORT_FROMLOCAL"] = "Do Perfil"
L["IMPORT_FROMSTRING"] = "Da String"
L["IMPORT_FROMSTRING_DESC"] = [=[As Strings permitem você transferir os dados de configuração do TellMeWhen para fora do jogo.

Para importar de uma string, pressione CTRL+V para colar a string dentro do campo depois que você tiver copiado na área de transferência, e então volte para este sub-menu.]=]
L["IMPORT_HEADING"] = "Importar"
L["IMPORT_PROFILE"] = "Copiar Perfil"
L["IMPORT_PROFILE_NEW"] = "|cff59ff59Criar|r Novo Perfil"
L["IMPORT_PROFILE_OVERWRITE"] = "|cFFFF5959Sobrescrever|r %s"
L["Incapacitated"] = "Incapacitado"
L["INCHEALS"] = "Cura recebida pela unidade"
L["INCHEALS_DESC"] = [=[Verifique o total de cura que foi recebida pela unidade (HoTs e lançamentos em progresso).

Apenas funciona para unidades amigas. Unidades hostis serão sempre relatadas como se tivesse recebido 0 de cura.]=]
L["INRANGE"] = "Ao Alcance"
L["ITEMCOOLDOWN"] = "Recarga de item"
L["ITEMEQUIPPED"] = "Item equipado"
L["ITEMINBAGS"] = "Contador de Item (Incluso cargas)"
L["ITEMTOCHECK"] = "Verificar Item"
L["LDB_TOOLTIP1"] = "|cff7fffffBotão-esquerdo|r para travar o grupo"
L["LDB_TOOLTIP2"] = "|cff7fffffBotão-direito|r para exibir o Editor de Ícone"
L["LEFT"] = "Esquerda"
L["LOADERROR"] = "TellMeWhen_Options não pôde ser carregado:"
L["LOADINGOPT"] = "Carregando TellMeWhen_Options."
L["LOCKED"] = "Travado"
L["LOCKED2"] = "Posição Travada."
L["LOSECONTROL_TYPE_ALL"] = "Todos os tipos"
L["LOSECONTROL_TYPE_ALL_DESC"] = "Faz com que o ícone mostre informação sobre todos os tipos de efeitos."
L["LUACONDITION"] = "Lua (Avançado)"
L["MACROCONDITION"] = "Macro Condicional"
L["MACROCONDITION_DESC"] = [=[Esta condição avaliará uma condicional macro, e irá passar se esta útlima passar. Todas as condicionais macro podem ser antecedidas com "não" para reverter aquilo que verificam.

Exemplos:
    "[nomodifier:alt]" - não segurando a tecla alt.
    "[@target, help][mod:ctrl]" - alvo é amigável OU segurando ctrl
    "[@focus, harm, nomod:shift]" - foco é hostil E não segurando shift

Para mais ajuda, acesse http://www.wowpedia.org/Making_a_macro]=]
L["Magic"] = "Mágica"
L["MAIN"] = "Geral"
L["MAINASSIST"] = "Ajudante Principal"
L["MAINTANK"] = "Tanque Principal"
L["MESSAGERECIEVE"] = "%s enviou-lhe alguns dados do TellMeWhen! Você pode importar esses dados para o TellMeWhen usando o botão %q, localizado na parte inferior do editor de ícones."
L["MESSAGERECIEVE_SHORT"] = "%s enviou algum dado do TellMeWhen!"
L["META_ADDICON"] = "Adicionar ícone"
L["METAPANEL_DOWN"] = "Para baixo"
L["METAPANEL_REMOVE"] = "Remover ícone"
L["METAPANEL_UP"] = "Para cima"
L["minus"] = "Favorito"
L["MiscHelpfulBuffs"] = "Vários Bônus Úteis"
L["MOON"] = "Lua"
L["MOUSEOVER_TOKEN_NOT_FOUND"] = "<no mouseover>"
L["MP5"] = "%d MP5"
L["MUSHROOM"] = "Cogumelo %d"
L["NEWVERSION"] = "Disponível a nova versão do TellMeWhen: %s"
L["NONE"] = "Nenhum desses"
L["normal"] = "Normal"
L["NOTINRANGE"] = "Fora de alcance"
L["NUMAURAS"] = "Números de"
L["NUMAURAS_DESC"] = "Esta condição verifica sua quantidade de aura ativa - não confunda com a quantidade de pilhas de sua aura. Isto é para   verificar coisas como se você tiver encantamentos ativos em ambas as armas. Use com moderação, visto que o processo utilizado para este processo exige muito da CPU."
L["ONLYCHECKMINE"] = "Apenas Fundido por Mim"
L["ONLYCHECKMINE_DESC"] = "Marque esta opção para que esta condição verifique apenas os bônus/penalidades que você lança."
L["OPERATION_DIVIDE"] = "Dividir"
L["OPERATION_MINUS"] = "Subtraír"
L["OPERATION_MULTIPLY"] = "Multiplicar"
L["OPERATION_PLUS"] = "Adicionar"
L["OPERATION_SET"] = "Defenid"
L["OUTLINE_MONOCHORME"] = "Monocromático"
L["OUTLINE_NO"] = "Sem Contorno"
L["OUTLINE_THICK"] = "Contorno Grosso"
L["OUTLINE_THIN"] = "Contorno Fino"
L["PARENTHESIS_TYPE_("] = "abrindo"
L["PARENTHESIS_TYPE_)"] = "fechando"
L["PARENTHESIS_WARNING1"] = [=[A quantidade de parênteses abertos e fechados não conferem!

%d mais %s |4parênteses:parênteses; |4é:são; necessários.]=]
L["PET_TYPE_CUNNING"] = "Destreza"
L["PET_TYPE_FEROCITY"] = "Bravura"
L["PET_TYPE_TENACITY"] = "Determinação"
L["Poison"] = "Veneno"
L["PROFILES_COPY"] = "Copiar Perfil..."
L["PROFILES_COPY_CONFIRM"] = "Copiar Perfil"
L["PROFILES_COPY_CONFIRM_DESC"] = "O perfil %q será reescrito por uma cópia do perfil %q."
L["PROFILES_COPY_DESC"] = [=[Escolha outro perfil para ser copiado. O perfil atual será reescrito pelo perfil escolhido.

Você pode desfazer esta ação enquanto você não sair ou recarregar usando a opção %q em %q no menu abaixo.]=]
L["PROFILES_DELETE"] = "Apagar Perfil..."
L["PROFILES_DELETE_CONFIRM"] = "Apagar Perfil"
L["PROFILES_DELETE_CONFIRM_DESC"] = "O perfil %q será excluído."
L["PROFILES_DELETE_DESC"] = [=[Escolha o perfil para ser apagado.

Você pode desfazer esta ação até sair ou recarregar usando a opção %q em %q no menu abaixo.]=]
L["PROFILES_NEW"] = "Novo Perfil"
L["PROFILES_NEW_DESC"] = "Digite o nome do novo perfil, e pressione enter para criar."
L["PROFILES_SET"] = "Mudar Perfil..."
L["PROFILES_SET_DESC"] = "Escolha outro perfil para trocar por este."
L["PROFILES_SET_LABEL"] = "Perfil Atual"
L["PvPSpells"] = "Controle de Multidões PvP, etc."
L["rare"] = "Raro"
L["rareelite"] = "Elite Raro"
L["REACTIVECNDT_DESC"] = "Esta condição verifica apenas o estado reativo da habilidade, e não o seu cooldown."
L["REDO"] = "Refazer"
L["REDO_DESC"] = "Desfazer a última alteração nesta configuração."
L["ReducedHealing"] = "Cura Reduzida"
L["RESET_ICON"] = "Resetar"
L["RESIZE"] = "Redimensionar"
L["RESIZE_TOOLTIP"] = "|cff7fffffClique e arraste|r para mudar o tamanho"
L["RIGHT"] = "Direita"
L["Rooted"] = "Enraizado"
L["RUNES"] = "Runas à verificar"
L["RUNSPEED"] = "Velocidade de Corrida"
L["RUNSPEED_DESC"] = "Refere-se à velocidade máxima de execução da unidade, independente da unidade estar se movendo."
L["SENDSUCCESSFUL"] = "Enviado com sucesso."
L["SHAPESHIFT"] = "Alternar Forma"
L["Shatterable"] = "Exausto"
L["Silenced"] = "Silenciado"
L["SORTBY"] = "Priorizar"
L["SORTBYNONE"] = "Normalmente"
L["SORTBYNONE_DESC"] = [=[Se esta opção for marcada, habilidades serão verificadas e aparecerão na ordem em que foram inseridas na caixa de edição "%s".

Se este ícone é um ícone de bônus/penalidade e o número de auras a serem verificadas excede a definição limite de eficiência, auras serão verificadas na ordem em que apareceriam normalmente na moldura da unidade.]=]
L["SORTBYNONE_DURATION"] = "Duração Normal"
L["SORTBYNONE_STACKS"] = "Pilhas Normais"
L["SOUND_CUSTOM"] = "Segundo arquivo personalizado"
L["SOUND_CUSTOM_DESC"] = [=[Informe o caminho do som personalizado. Pode também ser um código do Sound Kit ID.

Aqui estão algum exemplos, onde "arquivo" é o nome do seu som, e "ext" é a extensão do arquivo (apenas ogg ou mp3!):

-"SonsPersonalizados/arquivo.ext": o arquivo colocado na nova pasta chamada "SonsPersonalizados" que está no diretório do WoW (A mesma pasta do Wow.exe, Interface e WTF, etc)

-"Interface/AddOns/arquivo.ext": um arquivo perdido na pasta de AddOns

- "arquivo.ext": um arquivo perdido na pasta do WoW

NOTA: O WoW deve ser reiniciado antes de reorganizar os arquivos que não existiam antes de iniciar.]=]
L["SOUND_EVENT_DISABLEDFORTYPE"] = "Indisponível"
L["SOUND_EVENT_ONCLEU_DESC"] = "Este evento é disparado quando o ícone processa um evento de combate."
L["SOUND_EVENT_ONDURATION_DESC"] = [=[Ativa este evento quando a duração do temporizador do ícone mudar.

Como este evento ocorre cada vez que o ícone é atualizado enquanto um temporizador estiver em execução, você deve definir uma condição, e o evento só acontecerá quando houver alteração.]=]
L["SOUND_EVENT_ONFINISH"] = "Ao Finalizar"
L["SOUND_EVENT_ONFINISH_DESC"] = "Ativa este evento quando a recarga for utilizável, ganha/termina bônus, etc."
L["SOUND_EVENT_ONHIDE"] = "Ao Ocultar"
L["SOUND_EVENT_ONHIDE_DESC"] = "Este evento é acionado quando o ícone estiver oculto (mesmo que %q esteja marcado)."
L["SOUND_EVENT_ONSHOW"] = "Ao mostrar"
L["SOUND_EVENT_ONSHOW_DESC"] = "Este evento ativa quando o ícone é exibido (mesmo se %q estiver marcado)."
L["SOUND_EVENT_ONSPELL_DESC"] = "Este evento acontece quando altera de ícone magia/item/etc. e estava exibindo informações."
L["SOUND_EVENT_ONSTACK_DESC"] = [=[Ativa este evento quando as o rastreamento das pilhas de qualquer ícone tiver mudado.

Isto inclui a quantidade de redução para %s ícones.]=]
L["SOUND_EVENT_ONSTART"] = "Ao Iniciar"
L["SOUND_EVENT_ONSTART_DESC"] = "Este evento é acionado quando o cooldown torna-se inutilizável, o bônus/penalidade é aplicado, etc."
L["SOUND_EVENT_ONUNIT_DESC"] = "Este evento acontece quando altera de unidade que estava exibindo informações."
L["SOUND_SOUNDTOPLAY"] = "Som a ser tocado"
L["SOUND_TAB"] = "Som"
L["SOUNDERROR1"] = "O arquivo deve ter uma extensão!"
L["SOUNDERROR2"] = [=[Arquivos WAV personalizados não são suportados pelo WoW 4.0+

(Sons embutidos no WoW funcionarão, entretanto)]=]
L["SOUNDERROR3"] = "Apenas arquivos OGG e MP3 são suportados!"
L["SPEED"] = "Velocidade da Unidade"
L["SPEED_DESC"] = "Isso refere-se à velocidade atual da unidade. Se a unidade não estiver se movendo, o valor é zero, se deseja rastrear a velocidade da unidade, use a condição 'Velocidade de Corrida da Unidade' em vez disso."
L["SPELLCOOLDOWN"] = "Recarga de feitiço"
L["SPELLTOCOMP1"] = "1º Magia à Comparar"
L["SPELLTOCOMP2"] = "2ª Magia à Comparar"
L["STACKS"] = "Pilhas"
L["STANCE"] = "Postura"
L["STRATA_BACKGROUND"] = "Campos de batalha"
L["STRATA_DIALOG"] = "Diálogo"
L["STRATA_FULLSCREEN"] = "Tela cheia"
L["STRATA_FULLSCREEN_DIALOG"] = "Diálogo completo"
L["STRATA_HIGH"] = "Alto"
L["STRATA_LOW"] = "Baixo"
L["STRATA_MEDIUM"] = "Médio"
L["STRATA_TOOLTIP"] = "Dica"
L["Stunned"] = "Atordoado"
L["SUG_BUFFEQUIVS"] = "Equivalências de Bônus"
L["SUG_CLASSSPELLS"] = "Habilidades de Jogadores/pet conhecidas"
L["SUG_DEBUFFEQUIVS"] = "Equivalências de Penalidades"
L["SUG_DISPELTYPES"] = "Tipos de dissipação"
L["SUG_INSERT_ANY"] = "|cff7fffffClique|r"
L["SUG_INSERT_LEFT"] = "|cff7fffffBotão-esquerdo|r"
L["SUG_INSERT_RIGHT"] = "|cff7fffffBotão-direito|r"
L["SUG_INSERTEQUIV"] = "%s para inserir equivalência"
L["SUG_INSERTID"] = "%s para inserir uma ID"
L["SUG_INSERTITEMSLOT"] = "%s para inserir uma ID do item"
L["SUG_INSERTNAME"] = "%s para inserir um nome"
L["SUG_INSERTTEXTSUB"] = "%s para inserir tag"
L["SUG_MISC"] = "Diversos"
L["SUG_NPCAURAS"] = "Bônus/penalidades de PNJ conhecidos"
L["SUG_OTHEREQUIVS"] = "Outras equivalências"
L["SUG_PATTERNMATCH_FISHINGLURE"] = "Isca de Pesca %(%+%d+ Pesca%)"
L["SUG_PATTERNMATCH_SHARPENINGSTONE"] = "Afiado %(%+%d+ Dano%)"
L["SUG_PATTERNMATCH_WEIGHTSTONE"] = "Pesado %(%+%d+ Dano%)"
L["SUG_PLAYERAURAS"] = "Bônus/penalidades de Jogadores/pet conhecidos"
L["SUG_PLAYERSPELLS"] = "Suas magias"
L["SUG_TOOLTIPTITLE"] = [=[Conforme você digita, o TellMeWhen pesquisará seu cache e determinará as habilidades pelas quais você provavelmente está procurando.

Habilidades são classificadas e coloridas conforme a lista abaixo. Note que as categorias que começam com a palavra "Conhecido" não constarão de habilidades até que sejam vistas conforme você jogue ou logue em personagens de classes diferentes.

Clicar em uma entrada irá inserí-la na caixa de edição.]=]
L["SUG_TOOLTIPTITLE_TEXTSUBS"] = [=[A seguir são tags que você pode usar na exibição de texto. Se substituir fará com que seja alterado com os dados apropriados para o que você quer que seja exibido.

Para mais informações sobre estas tags, e para mais tags, clique aqui.

Clicando em uma entrada será inserida na caixa de texto. ]=]
L["SUGGESTIONS"] = "Sugestões:"
L["SUN"] = "Sol"
L["TABGROUP_GROUP_DESC"] = "Configurar Grupos"
L["TABGROUP_ICON_DESC"] = "Configurar Ícones"
L["TABGROUP_MAIN_DESC"] = "Ajustar configurações gerais."
L["TEXTLAYOUTS_ADDANCHOR"] = "Adicionar Âncora"
L["TEXTLAYOUTS_ADDANCHOR_DESC"] = "Clique para adicionar outra âncora de texto"
L["TEXTLAYOUTS_ADDLAYOUT"] = "Criar Novo Layout"
L["TEXTLAYOUTS_ADDSTRING"] = "Adicionar Texto de Exibição"
L["TEXTLAYOUTS_ADDSTRING_DESC"] = "Adicionar novo texto à este layout de texto."
L["TEXTLAYOUTS_BLANK"] = "(Em Branco)"
L["TEXTLAYOUTS_CHOOSELAYOUT"] = "Escolher Layout..."
L["TEXTLAYOUTS_CHOOSELAYOUT_DESC"] = "Escolha o layout do texto para usar neste ícone."
L["TEXTLAYOUTS_DEFAULTS_BINDINGLABEL"] = "Ligação/Rótulo"
L["TEXTLAYOUTS_DEFAULTS_ICON1"] = "Layout 1"
L["TEXTLAYOUTS_DEFAULTS_SPELL"] = "Magia"
L["TEXTLAYOUTS_DEFAULTS_STACKS"] = "Pilhas"
L["TEXTLAYOUTS_DEFAULTS_WRAPPER"] = "|cff666666Padrão:|r %s"
L["TEXTLAYOUTS_DEGREES"] = "%d Graus"
L["TEXTLAYOUTS_DELANCHOR"] = "Apagar Âncora"
L["TEXTLAYOUTS_DELETELAYOUT_DESC2"] = "Clique para apagar este layout de texto."
L["TEXTLAYOUTS_DELETESTRING_DESC2"] = "Apaga esta exibição de texto deste layout."
L["TEXTLAYOUTS_DESC"] = "Define layouts de texto que podem ser usados em qualquer ícones."
L["TEXTLAYOUTS_POINT2"] = "Ponto do Texto"
L["TEXTLAYOUTS_POINT2_DESC"] = "Ancorar %s na exibição de texto para o destino."
L["TEXTLAYOUTS_RELATIVEPOINT2_DESC"] = "Ancorar a exibição de texto na âncora alvo %s."
L["TEXTLAYOUTS_SIZE_AUTO"] = "Auto"
L["TEXTLAYOUTS_SKINAS_SKINNEDINFO"] = [=[Esta exibição é definida para a aparência da máscara.

Como resultado, nenhuma das configurações abaixo terão efeitos quando este layout for usado nos ícones.]=]
L["TEXTLAYOUTS_UNNAMED"] = "<sem nome>"
L["TOP"] = "Cima"
L["TOPLEFT"] = "Cima à Esquerda"
L["TOPRIGHT"] = "Cima à Direita"
L["TOTEMS"] = "Verificar Totens"
L["TREEf"] = "Diretório: %s"
L["TRUE"] = "Verdade"
L["UIPANEL_ADDGROUP2"] = "Novo Grupo %s"
L["UIPANEL_ADDGROUP2_DESC"] = "|cff7fffffClique|r para adicionar um novo %s grupo."
L["UIPANEL_ANCHORNUM"] = "Âncora %d"
L["UIPANEL_BAR_BORDERBAR"] = "Borda da Barra"
L["UIPANEL_BAR_BORDERBAR_DESC"] = "Ajuste a borda da barra"
L["UIPANEL_BAR_BORDERCOLOR"] = "Cor da Borda"
L["UIPANEL_BAR_BORDERCOLOR_DESC"] = "Altere a cor do ícone e da borda das barras."
L["UIPANEL_BAR_BORDERICON"] = "Borda do ícone"
L["UIPANEL_BAR_BORDERICON_DESC"] = "Ajuste uma borda em torno da textura, varredura de recarga e outros componentes similares."
L["UIPANEL_BAR_FLIP"] = "Virar Ícone"
L["UIPANEL_BAR_FLIP_DESC"] = "Coloque textura, recarga e outros componentes similares no lado oposto do ícone."
L["UIPANEL_BAR_PADDING"] = "Preenchimento"
L["UIPANEL_BAR_PADDING_DESC"] = "Ajuste o espaço entre o ícone e a barra."
L["UIPANEL_BAR_SHOWICON"] = "Exibir Ícone"
L["UIPANEL_BAR_SHOWICON_DESC"] = "Desativar esta configuração oculta a textura, a varredura e outros componentes similares."
L["UIPANEL_BARTEXTURE"] = "Textura da Barra"
L["UIPANEL_COLUMNS"] = "Colunas"
L["UIPANEL_COMBATCONFIG"] = "Permitir ajustes em combate"
L["UIPANEL_COMBATCONFIG_DESC"] = [=[Ativar isto permite configurar o TellMeWhen enquanto estiver em combate.

Note que isto irá forçar o módulo de opções e carregar tudo direto, resultando no aumento do uso de memória e maior tempo de carga.

Será para todas as contas: Todos os seus perfis irão compartilhar essa configuração.]=]
L["UIPANEL_DELGROUP"] = "Apagar este Grupo"
L["UIPANEL_DIMENSIONS"] = "Dimensões"
L["UIPANEL_DRAWEDGE"] = "Realçar temporizador"
L["UIPANEL_DRAWEDGE_DESC"] = "Realçar temporizador de recarga (animação do relógio) para melhorar visibilidade"
L["UIPANEL_EFFTHRESHOLD"] = "Limite de Eficácia do Bônus"
L["UIPANEL_EFFTHRESHOLD_DESC"] = [=[Defina o limite baseado na quantidade de bônus configurados pelo ícone de bônus.

Quando este limite é ultrapassado pelas configurações do ícone, duas coisas podem acontecer:

|cff7fffff1)|r O ícone mudará para um método mais rápido em grandes quantidades de dados (Porém ficará mais lento para valores menores).

|cff7fffff2)|r Como consequência #1, a ordem de análise será baseada na ordem dos bônus e eles reduzirão a quantidade de quadros em vez de priorizarem a ordem em que foram configurados.

O padrão é 15. ]=]
L["UIPANEL_FONT_DESC"] = "Escolha a fonte a ser usada pelas pilhas de texto nos ícones."
L["UIPANEL_FONT_HEIGHT"] = "Altura"
L["UIPANEL_FONT_HEIGHT_DESC"] = [=[Ajuste a altura máxima da exibição do texto. Se for 0, será o mais alto possível.

Se estiver ancorado em ambos os lados, cima e baixo, esta configuração não terá efeito.]=]
L["UIPANEL_FONT_JUSTIFY"] = "Justificação Horizontal"
L["UIPANEL_FONT_JUSTIFY_DESC"] = "Ajusta a justificação horizontal (Esquerda/Centro/Direita) para esta exibição de texto."
L["UIPANEL_FONT_JUSTIFYV"] = "Justificação Vertical"
L["UIPANEL_FONT_JUSTIFYV_DESC"] = "Ajuste a justificação vertical (Cima/Centro/Baixo) para este mostruário."
L["UIPANEL_FONT_OUTLINE"] = "Controno"
L["UIPANEL_FONT_OUTLINE_DESC2"] = "Definir o estilo de contorno da exibição do texto."
L["UIPANEL_FONT_ROTATE"] = "Rotação"
L["UIPANEL_FONT_ROTATE_DESC"] = [=[Defina a quantidade, em graus, que você quer rotacionar o texto.

Por ser uma criação própria, não é suportado pela Blizzard, por isso ele reage tão estranhamente, não há nada que possa ser feito.]=]
L["UIPANEL_FONT_SHADOW"] = "Deslocamento de sombra"
L["UIPANEL_FONT_SHADOW_DESC"] = "Altere o valor da sombra do texto. Defina como 0 para desativar a sombra."
L["UIPANEL_FONT_SIZE"] = "Tamanho da Fonte"
L["UIPANEL_FONT_SIZE_DESC2"] = "Altera o tamanho da fonte."
L["UIPANEL_FONT_WIDTH"] = "Largura"
L["UIPANEL_FONT_WIDTH_DESC"] = [=[Ajuste a largura máxima da exibição do texto. Se for 0, será o mais alargado possível.

Se estiver ancorado em ambos os lados, esquerda e direita, esta configuração não terá efeito.]=]
L["UIPANEL_FONT_XOFFS"] = "Deslocamento X"
L["UIPANEL_FONT_XOFFS_DESC"] = "Âncora de deslocamento do eixo X"
L["UIPANEL_FONT_YOFFS"] = "Deslocamento Y"
L["UIPANEL_FONT_YOFFS_DESC"] = "Âncora de deslocamento do eixo Y"
L["UIPANEL_FONTFACE"] = "Tipo da Letra"
L["UIPANEL_FORCEDISABLEBLIZZ"] = "Desativar texto de recarga da Blizzard"
L["UIPANEL_FORCEDISABLEBLIZZ_DESC"] = "Força o texto do temporizador da Blizzard ser desativado."
L["UIPANEL_GLYPH"] = "Glifo ativo"
L["UIPANEL_GLYPH_DESC"] = "Avaliar se você tem um glifo particular ativo."
L["UIPANEL_GROUP_QUICKSORT_DEFAULT"] = "Classificar por ID"
L["UIPANEL_GROUP_QUICKSORT_DURATION"] = "Classificar por Duração"
L["UIPANEL_GROUP_QUICKSORT_SHOWN"] = "Exibir ícones primeiro"
L["UIPANEL_GROUPALPHA"] = "Opacidade do Grupo"
L["UIPANEL_GROUPALPHA_DESC"] = [=[Ajuste o nível de opacidade do grupo inteiro.

Esta configuração não terá efeito sobre a funcionalidade dos ícones. Ela só muda a aparência do grupo e de seus ícones.

Defina este ajuste para 0 se você quiser ocultar um grupo inteiro e não permitir que fique funcional (parecido com a configuração %q dos ícones).]=]
L["UIPANEL_GROUPNAME"] = "Renomear Grupo"
L["UIPANEL_GROUPRESET"] = "Redefinir Posição"
L["UIPANEL_GROUPS"] = "Grupos"
L["UIPANEL_GROUPS_DROPDOWN"] = "Escolha ou Crie um Grupo..."
L["UIPANEL_GROUPS_DROPDOWN_DESC"] = [=[Use este menu para carregar ou criar um novo grupo.

Em todo caso |cff7fffffClique Direito|r em um ícone na tela para carregar um grupo de ícone.]=]
L["UIPANEL_GROUPS_GLOBAL"] = "Grupos |cff00c300Globais|r "
L["UIPANEL_GROUPSORT"] = "Classificando Ícone"
L["UIPANEL_GROUPSORT_ADD"] = "Adicionar Prioridade"
L["UIPANEL_GROUPSORT_ADD_DESC"] = "Adicionar um novo ícone classificando prioridade."
L["UIPANEL_GROUPSORT_ADD_NOMORE"] = "Nenhuma Prioridade Disponível"
L["UIPANEL_GROUPSORT_ALLDESC"] = [=[|cff7fffffClique|r para mudar a direção da classificação.
|cff7fffffClique-e-arraste|r para reorganizar.

Drag to the bottom to delete.]=]
L["UIPANEL_GROUPSORT_alpha"] = "Opacidade"
L["UIPANEL_GROUPSORT_alpha_1"] = "Baixa opacidade primeiro"
L["UIPANEL_GROUPSORT_alpha_-1"] = "Alta opacidade primeiro"
L["UIPANEL_GROUPSORT_alpha_DESC"] = "Classificar grupo pela opacidade dos ícones."
L["UIPANEL_GROUPSORT_duration"] = "Duração"
L["UIPANEL_GROUPSORT_duration_1"] = "Baixa duração primeiro"
L["UIPANEL_GROUPSORT_duration_-1"] = "Alta duração primeiro"
L["UIPANEL_GROUPSORT_duration_DESC"] = "Classificar grupo pela duração restante nos ícones."
L["UIPANEL_GROUPSORT_fakehidden"] = "%s"
L["UIPANEL_GROUPSORT_fakehidden_1"] = "Sempre oculto por último"
L["UIPANEL_GROUPSORT_fakehidden_-1"] = "Sempre oculto primeiro"
L["UIPANEL_GROUPSORT_fakehidden_DESC"] = "Classificar grupo por estado da configuração."
L["UIPANEL_GROUPSORT_id"] = "ID do ícone"
L["UIPANEL_GROUPSORT_id_1"] = "Baixa ID primeiro"
L["UIPANEL_GROUPSORT_id_-1"] = "Alta ID primeiro"
L["UIPANEL_GROUPSORT_id_DESC"] = "Classificar o grupo pela ID destes ícones."
L["UIPANEL_GROUPSORT_PRESETS"] = "Escolher Modelo..."
L["UIPANEL_GROUPSORT_PRESETS_DESC"] = "Escolha a partir de uma lista de classificação predefinida para este ícone."
L["UIPANEL_GROUPSORT_shown"] = "Exibindo"
L["UIPANEL_GROUPSORT_shown_1"] = "Ocultar ícones primeiro"
L["UIPANEL_GROUPSORT_shown_-1"] = "Exibir ícones primeiro"
L["UIPANEL_GROUPSORT_shown_DESC"] = "Classificar o grupo mesmo que o ícone não seja exibido."
L["UIPANEL_GROUPSORT_stacks"] = "Pilhas"
L["UIPANEL_GROUPSORT_stacks_1"] = "Pilhas menores primeiro"
L["UIPANEL_GROUPSORT_stacks_-1"] = "Pilhas maiores primeiro"
L["UIPANEL_GROUPSORT_stacks_DESC"] = "Classificar o grupo pelas pilhas de cada item."
L["UIPANEL_GROUPSORT_value"] = "Valor"
L["UIPANEL_GROUPSORT_value_1"] = "Baixo valor primeiro"
L["UIPANEL_GROUPSORT_value_-1"] = "Alto valor primeiro"
L["UIPANEL_GROUPSORT_value_DESC"] = "Classificar o grupo pelo valor da barra de progresso. Este é o valor que o tipo de ícone %s fornece."
L["UIPANEL_GROUPSORT_valuep"] = "Percentual"
L["UIPANEL_GROUPSORT_valuep_1"] = "Baixo % primeiro"
L["UIPANEL_GROUPSORT_valuep_-1"] = "Alto % primeiro"
L["UIPANEL_GROUPSORT_valuep_DESC"] = "Classificar pelo percentual da barra de progresso. Este valor que o ícone %s fornece."
L["UIPANEL_GROUPTYPE"] = "Método de Exibição"
L["UIPANEL_GROUPTYPE_BAR"] = "Barra"
L["UIPANEL_GROUPTYPE_BAR_DESC"] = "Exibir ícones no grupo com barras de progresso anexada aos ícones."
L["UIPANEL_GROUPTYPE_BARV"] = "Barras Verticais"
L["UIPANEL_GROUPTYPE_BARV_DESC"] = "Exibe os ícones no grupo com barras de progresso verticais anexadas aos ícones."
L["UIPANEL_GROUPTYPE_ICON"] = "Ícone"
L["UIPANEL_GROUPTYPE_ICON_DESC"] = "Exibe os ícones no grupo usando o modo tradicional do TellMeWhen."
L["UIPANEL_HIDEBLIZZCDBLING"] = "Desativar o acabamento da Blizzard"
L["UIPANEL_HIDEBLIZZCDBLING_DESC"] = [=[Desativar o efeito de acabamento da Blizzard ao terminar o tempo.

Este efeito foi adicionado pela Blizzard no patch 6.2.]=]
L["UIPANEL_ICONS"] = "Ícones"
L["UIPANEL_ICONSPACING"] = "Espaçamento de Ícone"
L["UIPANEL_ICONSPACING_DESC"] = "Distância entre cada ícone dentro do grupo."
L["UIPANEL_ICONSPACINGX"] = "Horizontal"
L["UIPANEL_ICONSPACINGY"] = "Vertical"
L["UIPANEL_LEVEL"] = "Nível do Quadro"
L["UIPANEL_LEVEL_DESC"] = "O nível nos grupos devem ser desenhados nos estrados."
L["UIPANEL_LOCK"] = [=[Travar Posição

		Isto é para bloquear um grupo e não todo o addon. Embora acho que eu reutilizarei esta chave, então irei marcar em todas as traduções para revisão.]=]
L["UIPANEL_LOCK_DESC"] = "Travar este grupo, evita ser movido ou redimensionado ao arrastar o grupo ou tabela."
L["UIPANEL_LOCKUNLOCK"] = "Travar/Destravar AddOn"
L["UIPANEL_MAINOPT"] = "Opções Principais"
L["UIPANEL_ONLYINCOMBAT"] = "Exibir apenas em combate"
L["UIPANEL_PERFORMANCE"] = "Performace"
L["UIPANEL_POINT"] = "Ponto do Grupo"
L["UIPANEL_POINT2_DESC"] = "Ancorar o %s do grupo para o alvo."
L["UIPANEL_POSITION"] = "Posição"
L["UIPANEL_PRIMARYSPEC"] = "Especialização Primária"
L["UIPANEL_PROFILES"] = "Perfis"
L["UIPANEL_PTSINTAL"] = "Pontos no talento"
L["UIPANEL_RELATIVEPOINT"] = "Ponto do Alvo"
L["UIPANEL_RELATIVEPOINT2_DESC"] = "Acorar o grupo à %s do alvo."
L["UIPANEL_RELATIVETO"] = "Âncora do Alvo"
L["UIPANEL_RELATIVETO_DESC"] = "Digite '/framestack' para ver a lista de todos as janelas que você tem acesso e o nome delas, para colocar neste diálogo."
L["UIPANEL_RELATIVETO_DESC_GUIDINFO"] = "O valor atual é exclusivo de outro grupo. Isso foi ajustando quando este grupo estava ancorado em outro grupo."
L["UIPANEL_ROLE_DESC"] = "Marque para permitir que a exibição deste grupo quando sua especialização servir para este papel."
L["UIPANEL_ROWS"] = "Linhas"
L["UIPANEL_SCALE"] = "Escala"
L["UIPANEL_SECONDARYSPEC"] = "Especialização Secundária"
L["UIPANEL_SPEC"] = "Dupla Espec."
L["UIPANEL_SPECIALIZATION"] = "Especialização do Talento"
L["UIPANEL_SPECIALIZATIONROLE"] = "Função de Especialização"
L["UIPANEL_SPECIALIZATIONROLE_DESC"] = "Escolha a função (Tanque, Cura ou DPS) que você escolheu como talento atual."
L["UIPANEL_STRATA"] = "Camada"
L["UIPANEL_STRATA_DESC"] = "A camada da IU em que o grupo deve ser desenhado."
L["UIPANEL_SUBTEXT2"] = [=[Ícones funcionam quando travados.

Quando destravados, você pode mover/redimensionar grupos e clicar com o botão direito nos ícones para mais configurações.

Você também pode digitar /tellmewhen ou /tmw para travar/destravar.]=]
L["UIPANEL_TALENTLEARNED"] = "Talento aprendido"
L["UIPANEL_TOOLTIP_COLUMNS"] = "Definir o número de colunas neste grupo"
L["UIPANEL_TOOLTIP_GROUPRESET"] = "Redefinir a posição e escala deste grupo"
L["UIPANEL_TOOLTIP_ONLYINCOMBAT"] = "Marque para que este grupo só seja mostrado em combate"
L["UIPANEL_TOOLTIP_ROWS"] = "Define o número de linhas neste grupo"
L["UIPANEL_TOOLTIP_UPDATEINTERVAL"] = [=[Define o quão frequente (em segundos) os ícones são verificados para mostrar/esconder, alfa, condições, etc.

Zero é o mais rápido possível. Valores menores podem ter um impacto significativo no número de quadros por segundo em computadores mais fracos.]=]
L["UIPANEL_TREE_DESC"] = "Marque para permitir que este grupo seja exibido quando estiver ativo ou desmarque para ocultar quando inativo."
L["UIPANEL_UPDATEINTERVAL"] = "Intervalo de Atualização"
L["UIPANEL_WARNINVALIDS"] = "Avisar ícones inválidos"
L["UNDO_DESC"] = "Desfazer última alteração destas configurações."
L["UNKNOWN_UNKNOWN"] = "<Desconhecido ???>"
L["UNNAMED"] = "(Sem nome)"
L["UP"] = "Cima"
L["VALIDITY_CONDITION_DESC"] = "Uma condição de alvo de"
L["VALIDITY_CONDITION2_DESC"] = "A condição #%d de"
L["VALIDITY_ISINVALID"] = "é inválido."
L["VALIDITY_META_DESC"] = "O ícone #%d foi marcado pelo ícone meta"
L["WARN_DRMISMATCH"] = [=[Alerta! Você está verificando os retornos decrescentes nas magias de duas categorias diferentes.

Todas as magias devem ser da mesma categoria para que o ícone funcione corretamente. As seguintes categorias e magias foram detectadas:

uma lista de categorias e magias está sendo anexada]=]
L["WATER"] = "Àgua"
L["worldboss"] = "Chefe do mundo"

elseif locale == "ruRU" then
L["!!Main Addon Description"] = "Обеспечивает визуальные, звуковые и текстовые оповещения о готовности заклинаний, способностей, наличии баффов/дебаффов и почти всего остального."
L["ABSORBAMT"] = "Количество поглощаемого щитом урона"
L["ABSORBAMT_DESC"] = "Проверяет общую сумму поглощающих щитов, которые имеет объект"
L["ACTIVE"] = "%d активно"
L["ADDONSETTINGS_DESC"] = "Настройка всех основных параметров аддона"
L["AIR"] = "Воздух"
L["ALLOWCOMM"] = "Разрешает поделиться в игре"
L["ALLOWCOMM_DESC"] = "Позволяет другим пользователям TellMeWhen выслать вам данные"
L["ALLOWVERSIONWARN"] = "Сообщать о новой версии"
L["ALPHA"] = "Альфа"
L["ANCHOR_CURSOR_DUMMY"] = "Макет якоря курсора TellMeWhen"
L["ANCHOR_CURSOR_DUMMY_DESC"] = [=[Это макет курсора. Он должен помочь Вам расположить иконки, привязанные к курсору.

Привязка групп к курсору полезна иконкам, проверяющим объект 'mouseover' (указатель мышки на цели объекта).

Вы можете, удерживая |cff7fffffRight-Click-and-drag|r правую кнопку мышки, перетащить иконку к данному макету, чтобы привязать группу иконки к курсору.

Из-за бага Blizzard'ов, анимация кулдауна - круговое затенение иконки -  будет неверно отображаться. Так что Вам лучше отключить ее для иконок, привязанных к якорю.

|cff7fffffLeft-Click and drag|r для перемещения макета.]=]
L["ANCHORTO"] = "Связать с"
L["ANIM_ACTVTNGLOW"] = "Иконка: Активация рамки"
L["ANIM_ACTVTNGLOW_DESC"] = "Показывает на иконке рамку активации, как у Blizzard"
L["ANIM_ALPHASTANDALONE"] = "Прозрачность"
L["ANIM_ALPHASTANDALONE_DESC"] = "Задайте максимальную прозрачность анимации"
L["ANIM_ANCHOR_NOT_FOUND"] = "Невозможно найти кадр с именем %q для привязки к нему анимации. Разве этот кадр не используется текущим видом иконки?"
L["ANIM_ANIMSETTINGS"] = "Установки"
L["ANIM_ANIMTOUSE"] = "Анимация для использования"
L["ANIM_COLOR"] = "Цвет/Прозрачность"
L["ANIM_COLOR_DESC"] = "Настройте цвет и прозрачность мигания."
L["ANIM_DURATION"] = "Продолжительность анимации"
L["ANIM_DURATION_DESC"] = "Установите, сколько времени анимация должна продлиться после того, как она вызвана."
L["ANIM_FADE"] = "Анимация затухания вспышки"
L["ANIM_FADE_DESC"] = "С галочкой для гладкого перехода между миганиями. Без галочки для немедленной вспышки."
L["ANIM_ICONALPHAFLASH"] = "Иконка: Альфа мигание"
L["ANIM_ICONALPHAFLASH_DESC"] = "Непосредственно подсвечивает иконку изменением ее непрозрачности."
L["ANIM_ICONBORDER"] = "Иконка: Граница"
L["ANIM_ICONBORDER_DESC"] = "Перекрывает цветную границу на иконке."
L["ANIM_ICONCLEAR"] = "Иконка: Прекращение анимации"
L["ANIM_ICONCLEAR_DESC"] = "Прекратить всю анимацию на данной иконке."
L["ANIM_ICONFADE"] = "Иконка: Постепенное проявление Вкл/Выкл"
L["ANIM_ICONFADE_DESC"] = "Постепенно применяет любые изменения непрозрачности, которые происходили с отобранным событием."
L["ANIM_ICONFLASH"] = "Иконка: Цветное мигание"
L["ANIM_ICONFLASH_DESC"] = "Иконка подсвечивается мигающим цветом"
L["ANIM_ICONOVERLAYIMG"] = "Иконка: Отображение перекрытия"
L["ANIM_ICONOVERLAYIMG_DESC"] = "Перекрывает иконку пользовательским изображением."
L["ANIM_ICONSHAKE"] = "Иконка: Тряска"
L["ANIM_ICONSHAKE_DESC"] = "Трясет иконку при срабатывании."
L["ANIM_INFINITE"] = "Играть до бесконечности"
L["ANIM_INFINITE_DESC"] = "С галочкой, чтобы заставить мультипликацию играть, пока она не перепишется другой мультипликацией на иконке такого же типа, или пока играет %q мультипликация."
L["ANIM_MAGNITUDE"] = "Магнитуда встряски"
L["ANIM_MAGNITUDE_DESC"] = "Установите, насколько сильный  должна быть встряска."
L["ANIM_PERIOD"] = "Период Вспышки"
L["ANIM_PERIOD_DESC"] = [=[Устанавливает, сколько времени каждое мигание должно длиться - время, когда мигание показывается или усиливается.

Установите 0, если Вам не нужно постепенное проявление или мигание.]=]
L["ANIM_PIXELS"] = "%s пикселей "
L["ANIM_SCREENFLASH"] = "Экран: Мигает"
L["ANIM_SCREENFLASH_DESC"] = "Мигает наложенным на экран цветом"
L["ANIM_SCREENSHAKE"] = "Экран: Тряска"
L["ANIM_SCREENSHAKE_DESC"] = [=[При срабатывании трясет весь экран.

ВАЖНО: Это сработает если Вы будете или вне боя или если имена персонажей не были включены во время загрузки.]=]
L["ANIM_SECONDS"] = "%s Секунд"
L["ANIM_SIZE_ANIM"] = "Граничное начальное количество"
L["ANIM_SIZE_ANIM_DESC"] = "Задайте насколько большой должна быть вся граница."
L["ANIM_SIZEX"] = "Ширина изображения"
L["ANIM_SIZEX_DESC"] = "Задайте ширину изображения."
L["ANIM_SIZEY"] = "Высота изображения"
L["ANIM_SIZEY_DESC"] = "Задайте высоту изображения"
L["ANIM_TAB"] = "Анимация"
L["ANIM_TAB_DESC"] = "Настроить анимацию. Некоторые эффекты применяются к иконке, некоторые - ко всему экрану."
L["ANIM_TEX"] = "Текстура"
L["ANIM_TEX_DESC"] = [=[Выберите текстуру, которая должна быть перекрыта.

Вы можете ввести Название или ID заклинания, имеющего текстуру, которую Вы хотите использовать, или Вы можете ввести путь к текстуре, такой как 'Interface/Icons/spell_nature_healingtouch', или только 'spell_nature_healingtouch', если путем является 'Interface/Icons'

Вы можете использовать также свои собственные текстуры, пока они размещены в каталоге WoW (установите это поле в пути к текстуре относительно корневого каталога WoW) в .tga или .blp формате, и имеют размерности, кратные 2 (32, 64, 128, и т.д.)]=]
L["ANIM_THICKNESS"] = "Толщина границы"
L["ANIM_THICKNESS_DESC"] = "Задайте толщину границы"
L["ANN_CHANTOUSE"] = "Исп. канал"
L["ANN_EDITBOX"] = "Выводимый текст"
L["ANN_EDITBOX_DESC"] = "Введите текст, который будет выводиться при определенном событии. Могут быть использованы стандартные замещения: \"%t\" для вашей цели и \"%f\" для вашего фокуса."
L["ANN_EDITBOX_WARN"] = "Наберите текст для отображения в этом месте"
L["ANN_FCT_DESC"] = "Выводы в %s стиле Blizzard'а. Возможность вывода текста в вашем интерфейсе ДОЛЖНА быть включена."
L["ANN_NOTEXT"] = "<Нет текста>"
L["ANN_SHOWICON"] = "Показать текстуру значка"
L["ANN_SHOWICON_DESC"] = "Некоторые текстовые поля могут отображать помимо текста текстуры. Установите эту опцию для включения данной особенности."
L["ANN_STICKY"] = "Прилипание"
L["ANN_SUB_CHANNEL"] = "Подраздел"
L["ANN_TAB"] = "Извещения"
L["ANN_TAB_DESC"] = "Настроить выводимый текст. Можно указать канал чата, фрейм или другие аддоны."
L["ANN_WHISPERTARGET"] = "Шепнуть цели"
L["ANN_WHISPERTARGET_DESC"] = [=[Введите имя игрока которому вы хотите шепнуть. 
Игрок должен быть с вашего сервера и одной фракции с вами.]=]
L["ASCENDING"] = "Восходящий"
L["ASPECT"] = "Аспект"
L["AURA"] = "Аура"
L["BACK_IE"] = "назад"
L["BACK_IE_DESC"] = "Загрузить последнюю отредактированную иконку (%s |T%s:0|t)."
L["Bleeding"] = "Кровотечение"
L["BOTTOM"] = "Внизу"
L["BOTTOMLEFT"] = "Внизу слева"
L["BOTTOMRIGHT"] = "Внизу справа"
L["BUFFCNDT_DESC"] = "Только первое заклинание будет проверено, все другие будут проигнорированы."
L["BUFFTOCHECK"] = "Баф для проверки"
L["BUFFTOCOMP1"] = "Первый баф для сравнения"
L["BUFFTOCOMP2"] = "Второй баф для сравнения"
L["BURNING_EMBERS_FRAGMENTS"] = "\"Фрагменты\" горящих углей"
L["BURNING_EMBERS_FRAGMENTS_DESC"] = [=[Каждый целый Горящий Уголь содержит десять его фрагиентов.

Например, если у вас есть 1 целый горящий уголь и еще половина, тогда у вас 15 фрагментов.]=]
L["CACHING"] = "TellMeWhen считывает и фильтрует все умения/заклинания в игре. Это нужно делать только один раз в каждом дополнении WoW. Вы можете увеличивать или уменьшать скорость процесса, используя ползунок внизу."
L["CACHINGSPEED"] = "Умения/заклинания по названию:"
L["CASTERFORM"] = "Может произносить заклинания"
L["CENTER"] = "В центре"
L["CHANGELOG"] = "Список изменений"
L["CHANGELOG_DESC"] = "Отображает список изменений, внесенных в текущей и предыдущих версиях TellMeWhen."
L["CHANGELOG_INFO2"] = [=[Добро пожаловать в TellMeWhen версия %s!
<br/><br/>
Когда вы ознакомитесь с изменениями, нажмите на %s tab or %s tab внизу что начать настройку аддона.]=]
L["CHANGELOG_LAST_VERSION"] = "Предыдущая установленная версия"
L["CHAT_FRAME"] = "Область чата"
L["CHAT_MSG_CHANNEL"] = "Канал чата"
L["CHAT_MSG_CHANNEL_DESC"] = "Отображает в виде сообщения в канале чата (например Торговля или любой другой к которому вы присоединены)"
L["CHAT_MSG_SMART"] = "Умный чат"
L["CHAT_MSG_SMART_DESC"] = "Сообщение отображается в наиболее подходящем канале чата: Рейд, Группа, Поле сражения или Сказать."
L["CHOOSEICON"] = "Выберите иконку для проверки"
L["CHOOSEICON_DESC"] = [=[|cff7fffffClick|r для выбора иконки/группы.
|cff7fffffLeft-Click and drag|r для переназначения.
|cff7fffffRight-Click and drag|r для перестановки.]=]
L["CHOOSENAME_DIALOG"] = [=[Введите название или ID того, что Вы хотите отслеживать на этой иконке. Можно добавить несколько названий (любые комбинации имен, ID или эквивалентов), разделяя их ';'.
Shift+ЛКМ введет заклинания/предметы/текст  или  перетащите мышью заклинания/предметы для ввода их в это поле.]=]
L["CHOOSENAME_DIALOG_PETABILITIES"] = "|cFFFF5959Способности питомцев|r должны использовать SpellID."
L["CLEU_"] = "Любое событие"
L["CLEU_CAT_AURA"] = "Бафы/Дебафы"
L["CLEU_CAT_CAST"] = "Касты"
L["CLEU_CAT_MISC"] = "Разное"
L["CLEU_CAT_SPELL"] = "Заклинания"
L["CLEU_CAT_SWING"] = "Ближний/Дальний"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MASK"] = "Контроль взаимосвязями (отношениями)"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MINE"] = "Отношение контроллера: Игрок (Вы)"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MINE_DESC"] = "Отметьте для исключения юнитов, подконтрольных вам."
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_OUTSIDER"] = "Отношение контроллера: Посторонние"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_OUTSIDER_DESC"] = "Проверка для исключения объекта, которым управляет кто-то, кто с Вами не в группе."
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_PARTY"] = "Управление группой: Члены группы"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_PARTY_DESC"] = "Проверка для исключения объекта, которым управляет кто-то, кто с Вами в группе."
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_RAID"] = "Управление группой: Члены рейда"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_RAID_DESC"] = "Проверка для исключения объектов, контролируемых кем-либо еще в Вашей рейдовой группе"
L["CLEU_COMBATLOG_OBJECT_CONTROL_MASK"] = "Контроллер"
L["CLEU_COMBATLOG_OBJECT_CONTROL_NPC"] = "Контроллер:Сервер"
L["CLEU_COMBATLOG_OBJECT_CONTROL_NPC_DESC"] = "Отметьте, чтобы исключить объекты управляемые компьютером (включая питомцев и стражей)."
L["CLEU_COMBATLOG_OBJECT_CONTROL_PLAYER"] = "Контроль: Человек"
L["CLEU_COMBATLOG_OBJECT_CONTROL_PLAYER_DESC"] = "Проверьте, чтобы исключить объекты контролируемые другими людьми (включая питомцев и стражей)"
L["CLEU_COMBATLOG_OBJECT_FOCUS"] = "Разно: Ваша закрепленная цель(Фокус)"
L["CLEU_COMBATLOG_OBJECT_FOCUS_DESC"] = "Отметьте, чтобы исключить объекты, которые являются Вашей закрепленной целью (Фокус)"
L["CLEU_COMBATLOG_OBJECT_MAINASSIST"] = "Разное: Главная цель"
L["CLEU_COMBATLOG_OBJECT_MAINASSIST_DESC"] = "Отметьте, чтобы исключить объекты, помеченные как Главная цель в Вашем рейде."
L["CLEU_COMBATLOG_OBJECT_MAINTANK"] = "Разное: Главный танк"
L["CLEU_COMBATLOG_OBJECT_MAINTANK_DESC"] = "Отметьте, чтобы исключить объекты, помеченные как Главный танк в Вашем рейде."
L["CLEU_COMBATLOG_OBJECT_NONE"] = "Разное: Неизвестный объект"
L["CLEU_COMBATLOG_OBJECT_NONE_DESC"] = "С галочкой, чтобы исключить объекты, которые абсолютно неизвестны клиенту WoW. Это происходит очень редко и может вообще быть оставлено без проверки."
L["CLEU_COMBATLOG_OBJECT_REACTION_FRIENDLY"] = "Реакция объекта: дружественный"
L["CLEU_COMBATLOG_OBJECT_REACTION_FRIENDLY_DESC"] = "Отметьте, чтобы исключить объекты дружественные к Вам"
L["CLEU_COMBATLOG_OBJECT_REACTION_HOSTILE"] = "Реакция объекта: враждебный"
L["CLEU_COMBATLOG_OBJECT_REACTION_HOSTILE_DESC"] = "Отметьте, чтобы исключить объекты враждебные к Вам"
L["CLEU_COMBATLOG_OBJECT_REACTION_MASK"] = "Реакция объекта"
L["CLEU_COMBATLOG_OBJECT_REACTION_NEUTRAL"] = "Реакция объекта: Нейтральный"
L["CLEU_COMBATLOG_OBJECT_REACTION_NEUTRAL_DESC"] = "Выберите что бы исключить цели, которые нейтральные по отношению к вам"
L["CLEU_COMBATLOG_OBJECT_TARGET"] = "Разное: Ваша цель"
L["CLEU_COMBATLOG_OBJECT_TARGET_DESC"] = "Выберите, что бы исключить юнита, выбранного в данный момент"
L["CLEU_COMBATLOG_OBJECT_TYPE_GUARDIAN"] = "Тип цели: Стражник"
L["CLEU_COMBATLOG_OBJECT_TYPE_GUARDIAN_DESC"] = "С галочкой исключить Охрану. Охрана - объекты, которые защищают свой контроллер, но не могут управляться непосредственно."
L["CLEU_COMBATLOG_OBJECT_TYPE_MASK"] = [=[Тип юнита
]=]
L["CLEU_COMBATLOG_OBJECT_TYPE_NPC"] = "Тип юинта: НИП (NPC)"
L["CLEU_COMBATLOG_OBJECT_TYPE_NPC_DESC"] = "Выберите что бы исключить персонажей не управляемых игроками (NPC)"
L["CLEU_COMBATLOG_OBJECT_TYPE_OBJECT"] = "Тип юнита: Объект"
L["CLEU_COMBATLOG_OBJECT_TYPE_OBJECT_DESC"] = "Выберите что бы исключить юнитов, таких как: ловушки, рыболовные буйки или любые другие не попадающие под другие категории \"Тип юнита\""
L["CLEU_COMBATLOG_OBJECT_TYPE_PET"] = "Тип юнита: Питомец"
L["CLEU_COMBATLOG_OBJECT_TYPE_PET_DESC"] = "Выберите что бы исключить питомцев. Питомцы это юниты которые защищают своего владельца и могут быть контролируемы непосредственно."
L["CLEU_COMBATLOG_OBJECT_TYPE_PLAYER"] = "Тип юнита: Персонаж Игрока"
L["CLEU_COMBATLOG_OBJECT_TYPE_PLAYER_DESC"] = "Выберите что бы исключить персонажей игрока"
L["CLEU_CONDITIONS_DESC"] = [=[Задайте условия, которым должен соответствовать каждый объект.

Введите объекты для проверки, чтобы "Условия" стали доступными. Все введенные объекты должны иметь unitID (имена не могут использоваться с этими условиями).]=]
L["CLEU_CONDITIONS_DEST"] = "Конечные условия"
L["CLEU_CONDITIONS_SOURCE"] = "Исходные условия"
L["CLEU_DAMAGE_SHIELD"] = "Щит от урона"
L["CLEU_DAMAGE_SHIELD_DESC"] = "Возникает, если вредоносный щит (%s, %s, итд., но не %s) повреждает объект."
L["CLEU_DAMAGE_SHIELD_MISSED"] = "Щит от урона пропущен"
L["CLEU_DAMAGE_SHIELD_MISSED_DESC"] = "Происходит, когда щит от урона (%s, %s, и т.д., но не %s) не в состоянии повредить цель."
L["CLEU_DAMAGE_SPLIT"] = "Разделение урона"
L["CLEU_DAMAGE_SPLIT_DESC"] = "Возникает, когда урон разделяется между двумя или более целями"
L["CLEU_DESTUNITS"] = "Конечный объект(ы) для проверки"
L["CLEU_DESTUNITS_DESC"] = "Выберите конечные объекты на которые будет реагировать значок |cff7fffffИЛИ|r оставьте пустым, чтобы значок реагировал на любое конечное событие."
L["CLEU_DIED"] = "Смерть"
L["CLEU_ENCHANT_APPLIED"] = "Зачарование Нанесено"
L["CLEU_ENCHANT_APPLIED_DESC"] = "Охватывает временные улучшения оружия, наподобие яда разбойника или улучшений шамана."
L["CLEU_ENCHANT_REMOVED"] = "Зачарование Удалено"
L["CLEU_ENCHANT_REMOVED_DESC"] = "Охватывает временные улучшения оружия, наподобие яда разбойника или улучшений шамана."
L["CLEU_ENVIRONMENTAL_DAMAGE"] = "Урон от окружения"
L["CLEU_ENVIRONMENTAL_DAMAGE_DESC"] = "Урон от лавы, усталости, падения и утопления."
L["CLEU_EVENTS"] = "События для проверки"
L["CLEU_EVENTS_ALL"] = "Все"
L["CLEU_EVENTS_DESC"] = "Выберите боевые события, на которые будет реагировать значок."
L["CLEU_FLAGS_DESC"] = "Содержит список атрибутов, которые могут использоваться для исключения определенных объектов. Если объект обладает указанными атрибутами, то значок не обрабатывает событие."
L["CLEU_FLAGS_DEST"] = "Исключения"
L["CLEU_FLAGS_SOURCE"] = "Исключения"
L["CLEU_HEADER"] = "Фильтры боевых событий"
L["CLEU_HEADER_DEST"] = "Конечный объект(ы)"
L["CLEU_HEADER_SOURCE"] = "Исходный объект(ы)"
L["CLEU_NOFILTERS"] = "%s Значок %s не имеет определенных фильтров. Он не будет работать, пока вы не определите хотя бы один фильтр."
L["CLEU_PARTY_KILL"] = "Убийство группы"
L["CLEU_PARTY_KILL_DESC"] = "Срабатывает когда член вашей группы убивает что либо."
L["CLEU_RANGE_DAMAGE"] = "Урон на расстоянии (дальний)"
L["CLEU_RANGE_MISSED"] = "Промах на расстоянии (дальний)"
L["CLEU_SOURCEUNITS"] = "Исходный объект(ы) для проверки"
L["CLEU_SOURCEUNITS_DESC"] = "Выберите исходные объекты на которые будет реагировать значок |cff7fffffИЛИ|r оставьте пустым, чтобы значок реагировал на любой источник события."
L["CLEU_SPELL_AURA_APPLIED"] = "Аура наложена"
L["CLEU_SPELL_AURA_APPLIED_DOSE"] = "Ауры наложены"
L["CLEU_SPELL_AURA_BROKEN"] = "Аура снята"
L["CLEU_SPELL_AURA_BROKEN_SPELL"] = "Аура снята спелом"
L["CLEU_SPELL_AURA_BROKEN_SPELL_DESC"] = [=[Срабатывает если аура, обычно некоторая форма контроля, снимается уроном от заклинания.

Снятая аура это то, на что сработала иконка; снявшее заклинание можно вывести с помощью подстановки [Extra] в тестовых подсказках.]=]
L["CLEU_SPELL_AURA_REFRESH"] = "Аура обновлена"
L["CLEU_SPELL_AURA_REMOVED"] = "аура удалена"
L["CLEU_SPELL_AURA_REMOVED_DOSE"] = "Ауры удалены"
L["CLEU_SPELL_CAST_FAILED"] = "Неудачный каст"
L["CLEU_SPELL_CAST_START"] = "Начало каста"
L["CLEU_SPELL_CAST_START_DESC"] = [=[Происходит, когда начинают произносить заклинание.

ВАЖНО: Чтобы предотвратить потенциальные злоупотребления, Blizzard исключил из этого события объект назначения, таким образом, Вы не можете это выбрать.]=]
L["CLEU_SPELL_CAST_SUCCESS"] = "Успешное применение заклинания"
L["CLEU_SPELL_CAST_SUCCESS_DESC"] = "Происходит, когда заклинание успешно применено."
L["CLEU_SPELL_CREATE"] = "Создание заклинания"
L["CLEU_SPELL_CREATE_DESC"] = "Происходит, когда объект, такой как ловушка охотника или портал мага, создан."
L["CLEU_SPELL_DAMAGE"] = "Урон от заклинания"
L["CLEU_SPELL_DAMAGE_CRIT"] = "Критический эффект заклинания"
L["CLEU_SPELL_DAMAGE_CRIT_DESC"] = "Происходит, когда любое заклинание наносит критический урон. Это будет происходить также часть, как и %q событие."
L["CLEU_SPELL_DAMAGE_DESC"] = "Происходит, когда любое заклинание наносит критический урон."
L["CLEU_SPELL_DAMAGE_NONCRIT"] = "Спел не критовый"
L["CLEU_SPELL_DAMAGE_NONCRIT_DESC"] = "Происходит, когда любое заклинание наносит некритический урон. Occurs when any spell does non-critical damage. Это будет происходить также часть, как и %q событие."
L["CLEU_SPELL_DISPEL"] = "Рассеивание залинания"
L["CLEU_SPELL_DISPEL_DESC"] = [=[Срабатывает если аура снимается рассеиванием.

Иконка может зависеть от рассеянной ауры. Рассеевшее заклинание можно вывести с помощью подстановки [Extra] в тестовых подсказках.]=]
L["CLEU_SPELL_DISPEL_FAILED"] = "Рассеивание не удалось"
L["CLEU_SPELL_DISPEL_FAILED_DESC"] = [=[Срабатывает если ауру не удается снять рассеиванием.

Иконка может зависеть от ауры, которую пытались рассеять. Неудавшееся рассеивающее заклинание можно вывести с помощью подстановки [Extra] в тестовых подсказках.
]=]
L["CLEU_SPELL_DRAIN"] = "Утечка ресурса"
L["CLEU_SPELL_DRAIN_DESC"] = "Срабатывает если параметры (здоровье/мана/ярость/энергия/итд) потеряны объектом."
L["CLEU_SPELL_ENERGIZE"] = "Восполнение ресурса"
L["CLEU_SPELL_ENERGIZE_DESC"] = "Срабатывает если параметры (здоровье/мана/ярость/энергия/итд) получены объектом."
L["CLEU_SPELL_EXTRA_ATTACKS"] = "Получен дополнительный урон"
L["CLEU_SPELL_EXTRA_ATTACKS_DESC"] = "Срабатывает если прок дал дополнительный удар в ближнем бою."
L["CLEU_SPELL_HEAL"] = "Лечение"
L["CLEU_SPELL_INSTAKILL"] = "Мгновенное убийство"
L["CLEU_SPELL_INTERRUPT"] = "Прерывание - Заклинание прервано"
L["CLEU_SPELL_INTERRUPT_DESC"] = [=[Срабатывает если заклинание прерывается.

Иконка может зависеть от прерванного заклинания. Прерывающее заклинание можно вывести с помощью подстановки [Extra] в тестовых подсказках.

Понимайте разницу между двумя различными событиями прерывания - оба всегда будут срабатывать, если заклинание прервано, но каждый отбирает использованные заклинания отдельно.
]=]
L["CLEU_SPELL_INTERRUPT_SPELL"] = "Прерывание - прерывание используемого заклинания"
L["CLEU_SPELL_INTERRUPT_SPELL_DESC"] = [=[Происходит, если произнесение заклинания прервано.

Иконка может быть отфильтрована заклинанием, которое вызвало прерывание. К заклинанию, которое было прервано, можно получить доступ с подстановкой [Extra] в текстовых подсказках.

Отметьте различие между двумя событиями прерывания - оба всегда будут происходить, если заклинание будет прервано, но каждое выбирает свои заклинания по-разному.]=]
L["CLEU_SPELL_LEECH"] = "Уменьшение значений параметров"
L["CLEU_SPELL_LEECH_DESC"] = "Срабатывает если параметры (здоровье/мана/ярость/энергия/итд) потеряны одним объектом и, одновременно, получены другим."
L["CLEU_SPELL_MISSED"] = "Промах заклинания"
L["CLEU_SPELL_PERIODIC_DAMAGE"] = "Периодический урон"
L["CLEU_SPELL_PERIODIC_DRAIN"] = "Переодическая Утечка ресурса"
L["CLEU_SPELL_PERIODIC_ENERGIZE"] = "Периодическое Восполнение ресурса"
L["CLEU_SPELL_PERIODIC_HEAL"] = "Периодическое исцеление"
L["CLEU_SPELL_PERIODIC_LEECH"] = "Периодическая откачка"
L["CLEU_SPELL_PERIODIC_MISSED"] = "Периодический промах"
L["CLEU_SPELL_REFLECT"] = "Отражение заклинания"
L["CLEU_SPELL_REFLECT_DESC"] = [=[Срабатывает если вы отразили заклинание обратно на кастера.

Исходящий объект - это любой отразивший, объект назначения - это любой, кто отразил обратно]=]
L["CLEU_SPELL_RESURRECT"] = "Воскрешение"
L["CLEU_SPELL_RESURRECT_DESC"] = "Происходит, когда объект воскрешен после смерти."
L["CLEU_SPELL_STOLEN"] = "Аура украдена"
L["CLEU_SPELL_STOLEN_DESC"] = [=[Происходит если баф украден, возможно посредством %s.

Иконка может быть выбрана заклинанием, которое было украдено.]=]
L["CLEU_SPELL_SUMMON"] = "Заклинание призыва"
L["CLEU_SPELL_SUMMON_DESC"] = "Происходит, когда NPC, такой как пет или тотем, призван или создан."
L["CLEU_SWING_DAMAGE"] = "Колеблющийся урон"
L["CLEU_SWING_MISSED"] = "Колеблющийся промах"
L["CLEU_TIMER"] = "Таймер для настройки на события"
L["CLEU_TIMER_DESC"] = [=[Продолжительность таймера в секундах, выводится на иконке когда событие имеет место.

Вы можете также установить время действия используя формат "Заклинание: Продолжительность" в строке ввода %q, которая будет использоваться всякий раз при обработке события, использующего заклинание, которое Вы установили как фильтр.

Если  продолжительность заклинания никак не определена, или у Вас нет никаких предустановок фильтра заклинания (строка ввода чиста), то будет использоваться эта продолжительность.]=]
L["CLEU_UNIT_DESTROYED"] = "Объект Уничтожен"
L["CLEU_UNIT_DESTROYED_DESC"] = "Срабатывает если объект, такой как тотем, уничтожен."
L["CLEU_UNIT_DIED"] = "Объект Мертв"
L["CLEU_WHOLECATEGORYEXCLUDED"] = [=[Вы исключили каждую часть %q категории, вследствие чего, эта с иконкой не будут происходить никакие события.

Отмените хотя бы одно выделение для правильного функционирования.]=]
L["CLICK_TO_EDIT"] = "|cff7fffffКлик|r для редактирования."
L["CMD_CHANGELOG"] = "Список изменений"
L["CMD_DISABLE"] = "Выкл."
L["CMD_ENABLE"] = "Вкл."
L["CMD_OPTIONS"] = "Параметры"
L["CMD_PROFILE"] = "Профиль"
L["CMD_PROFILE_INVALIDPROFILE"] = "Профиля с названием %q не существует!"
L["CMD_PROFILE_INVALIDPROFILE_SPACES"] = "Подсказка: если в названии профиля есть пробелы, возьмите название в кавычки"
L["CMD_TOGGLE"] = "переключение"
L["CNDT_DEPRECATED_DESC"] = "Свойство %s более не функционирует. Это результат изменений в механике игры. Удалите его или смените на другое свойство."
L["CNDT_MULTIPLEVALID"] = "Вы можете ввести несколько названий/IDs для проверки, разделяя их точкой с запятой."
L["CNDT_ONLYFIRST"] = "Только первое заклинание/предмет будет проверяться - списки, разделённые \";\" некорректны для условия этого типа"
L["CNDT_RANGE"] = "Радиус действия юнита"
L["CNDT_RANGE_DESC"] = "Проверяет приблизительный радиус юнита, используя LibRangeCheck-2.0. Условие будет расценено невыполненным, если юнит не будет соответствовать."
L["CNDT_RANGE_IMPRECISE"] = "%d метров. (|cffff1300 Не точно |r)"
L["CNDT_RANGE_PRECISE"] = "%d метров. (|cffff1300 Точно |r)"
L["CNDT_SLIDER_DESC_CLICKSWAP_TOMANUAL"] = "|cff7fffffRight-Click|r для переключения на ручной ввод."
L["CNDT_SLIDER_DESC_CLICKSWAP_TOSLIDER"] = "|cff7fffffRight-Click|r для переключения на выбор с использованием ползунка."
L["CNDT_SLIDER_DESC_CLICKSWAP_TOSLIDER_DISALLOWED"] = "Только ручной ввод разрешен для значений свыше %s (ползунки Blizzard's могут странно срабатывать с большими значениями.)"
L["CNDT_TOTEMNAME"] = "Название(я) тотема"
L["CNDT_TOTEMNAME_DESC"] = [=[Оставьте пустым, чтобы отслеживать любые тотемы выбранного типа.

Введите название тотема, или список названий, разделенных точкой с запятой, для отслеживания конкретных тотемов.]=]
L["CNDT_UNKNOWN_DESC"] = "Ваши параметры содержат состояние с названием %s, но такого состояния не найдено. Возможно Вы используете старую версию TMW, или данное состояние было удалено."
L["CNDTCAT_ARCHFRAGS"] = "Археологические фрагменты"
L["CNDTCAT_ATTRIBUTES_PLAYER"] = "Свойства игрока"
L["CNDTCAT_ATTRIBUTES_UNIT"] = "Свойства объекта"
L["CNDTCAT_BOSSMODS"] = "Режимы боссов"
L["CNDTCAT_BUFFSDEBUFFS"] = "Баффы/Дебаффы"
L["CNDTCAT_CURRENCIES"] = "Деньги"
L["CNDTCAT_FREQUENTLYUSED"] = "Часто используемый"
L["CNDTCAT_LOCATION"] = "Группа и расположение"
L["CNDTCAT_MISC"] = "Разный"
L["CNDTCAT_RESOURCES"] = "Ресурсы"
L["CNDTCAT_SPELLSABILITIES"] = "Заклинания/Предметы"
L["CNDTCAT_STATS"] = "Характеристики"
L["CNDTCAT_TALENTS"] = "Классы и таланты"
L["CODESNIPPET_ADD2"] = "Новый %s Отрывок"
L["CODESNIPPET_ADD2_DESC"] = "|cff7fffff Нажмите |r чтобы добавить новый отрывок"
L["CODESNIPPET_AUTORUN"] = "Автозапуск при загрузке"
L["CODESNIPPET_AUTORUN_DESC"] = "Если включено, этот отрывок будет запущен когда включается TMW_INITIALIZE  (что происходит вовремя входи игрока в игру, но до создания любых групп и иконок)."
L["CODESNIPPET_CODE"] = "Принимает код для запуска."
L["CODESNIPPET_DELETE"] = "Удалить фрагмент."
L["CODESNIPPET_DELETE_CONFIRM"] = "Вы уверены, что хотите удалить фрагмент кода %q?"
L["CODESNIPPET_EDIT_DESC"] = "|cff7fffff Нажмите |r чтобы редактировать отрывок."
L["CODESNIPPET_GLOBAL"] = "Глобальные Фрагменты"
L["CODESNIPPET_ORDER"] = "Порядок запуска"
L["CODESNIPPET_ORDER_DESC"] = [=[Установите порядок, в котором данный фрагмент будет запускаться относительно других фрагментов.

%s и %s будут смешаны при запуске, основываясь на данном значении.

Допустимы десятичные значения. Последовательный порядок не гарантирован, если два фрагмента используют один и тот же порядок.]=]
L["CODESNIPPET_PROFILE"] = "Фрагменты Профиля"
L["CODESNIPPET_RENAME"] = "Название Фрагмента кода"
L["CODESNIPPET_RENAME_DESC"] = [=[Выберите название для данного фрагмента для простого его распознавания.

Названия не обязаны быть уникальными.]=]
L["CODESNIPPET_RUNAGAIN"] = "Запустить отрывок снова"
L["CODESNIPPET_RUNAGAIN_DESC"] = [=[Этот отрывок уже был запущен в этой игровой сессии.

|cff7fffff Нажмите | r что бы запустить его снова.]=]
L["CODESNIPPET_RUNNOW"] = "Запустить фрагмент сейчас"
L["CODESNIPPET_RUNNOW_DESC"] = "|cff7fffffЩелкните|r, чтобы запустить код этих фрагментов."
L["CODESNIPPETS"] = "Фрагменты кода Lua"
L["CODESNIPPETS_DEFAULTNAME"] = "Новый фрагмент"
L["CODESNIPPETS_DESC"] = [=[Эта функция позволяет писать куски кода на lua, который будет выполнен, когда TellMeWhen инициализируется.

Это расширенная функция для тех, кто имеет опыт работы с Lua (или для тех, кому был предоставлен фрагмент другим пользователям TellMeWhen).

Использование может включать написание пользовательских функций для использования в условиях Lua.

Фрагменты могут быть определены как по профилю, так и глобально (глобальные фрагменты будут выполняться для всех профилей).

Чтобы вставить, ссылку на значок TellMeWhen в ваш код, |cff7fffffshift-щелчок|r на этот значок.]=]
L["CODESNIPPETS_DESC_SHORT"] = "Писать куски кода на lua, который будет выполнен, когда TellMeWhen инициализируется."
L["CODESNIPPETS_IMPORT_GLOBAL"] = "Новый глобальный фрагмент"
L["CODESNIPPETS_IMPORT_GLOBAL_DESC"] = "Импорт фрагмента в качестве глобального фрагмента."
L["CODESNIPPETS_IMPORT_PROFILE"] = "Новый фрагмент профиля"
L["CODESNIPPETS_IMPORT_PROFILE_DESC"] = "Импортируйте фрагмент как фрагмент, специфичный для профиля."
L["CODESNIPPETS_TITLE"] = "Lua фрагменты"
L["CODETOEXE"] = "Код для выполнения"
L["COLOR_MSQ_COLOR"] = "Граница маски цвета"
L["COLOR_MSQ_COLOR_DESC"] = "Проверка этого приведет к тому, что граница скина маски (если скин, на которой вы используете, имеет границу) должен быть окрашен."
L["COLOR_MSQ_ONLY"] = "Только цвет границы маски"
L["COLOR_MSQ_ONLY_DESC"] = "Проверка этого приведет к ТОЛЬКО границе скина маски (если скин, который вы используете, имеет границу), для цвета. Иконки НЕ будут окрашены"
L["COLOR_OVERRIDE_GLOBAL"] = "Переопределить глобальный цвет"
L["COMPARISON"] = "Сравнение"
L["CONDITION_TIMER"] = "Таймер для проверки"
L["CONDITION_TIMER_EB_DESC"] = "Введите название таймера для проверки."
L["CONDITIONALPHA_METAICON"] = "Неудачные сосотояния"
L["CONDITIONALPHA_METAICON_DESC"] = "Эта непрозрачность будет применяться когда спадут условия."
L["CONDITIONPANEL_ADD"] = "Добавить условие"
L["CONDITIONPANEL_ALIVE"] = "Цель жива"
L["CONDITIONPANEL_ALIVE_DESC"] = "Это условие исполняется если указанная цель жива."
L["CONDITIONPANEL_ALTPOWER"] = "Альтернативный ресурс"
L["CONDITIONPANEL_ALTPOWER_DESC"] = "Это счетчик особых способностей, используемых во многих квестах и схватках с боссами"
L["CONDITIONPANEL_AND"] = "и"
L["CONDITIONPANEL_ANDOR"] = "и/или"
L["CONDITIONPANEL_ANDOR_DESC"] = "Нажмите для переключения между операторами И/ИЛИ"
L["CONDITIONPANEL_AUTOCAST"] = "Автоматическое использование заклинаний питомцом"
L["CONDITIONPANEL_BITFLAGS_SELECTED"] = "|cff7fffffВыбрано|r:"
L["CONDITIONPANEL_BLIZZEQUIPSET"] = "Набор вещей надет"
L["CONDITIONPANEL_BLIZZEQUIPSET_INPUT"] = "Наименование набора вещей"
L["CONDITIONPANEL_CLASS"] = "Класс объекта"
L["CONDITIONPANEL_CLASSIFICATION"] = "Тип объекта"
L["CONDITIONPANEL_COMBAT"] = "Объект в бою"
L["CONDITIONPANEL_COMBO"] = "Длина серии приемов"
L["CONDITIONPANEL_DEFAULT"] = "Выберите тип ..."
L["CONDITIONPANEL_ECLIPSE_DESC"] = [=[Затмение друида имеет диапазон от -100 (лунное затмение) до 100 (солнечное затмение).
Введите -80 если вы хотите чтобы значок сработал  при значении лунной силы равной 80.]=]
L["CONDITIONPANEL_EQUALS"] = "равно"
L["CONDITIONPANEL_EXISTS"] = "Цель существует"
L["CONDITIONPANEL_GREATER"] = "Больше"
L["CONDITIONPANEL_GREATEREQUAL"] = "Больше или равно"
L["CONDITIONPANEL_GROUPTYPE"] = "Тип группы"
L["CONDITIONPANEL_ICON"] = "Показать значок"
L["CONDITIONPANEL_ICON_DESC"] = [=[Проверка условий работает только если прозрачность иконки больше 0. 
Если необходимо скрыть значок, но при этом вести проверку условий, установите параметр %q в настройках прозрачности значка.
Для проверки условий значка группа в которой он находится также должна отбражаться.]=]
L["CONDITIONPANEL_ICON_HIDDEN"] = "Скрыт"
L["CONDITIONPANEL_ICON_SHOWN"] = "Отображается"
L["CONDITIONPANEL_ICONHIDDENTIME"] = "Иконка невидимого времени"
L["CONDITIONPANEL_ICONSHOWNTIME"] = "Иконка отображаемого времени"
L["CONDITIONPANEL_INSTANCETYPE"] = "Тип подземелья"
L["CONDITIONPANEL_INSTANCETYPE_LEGACY"] = "%s (Устаревшее)"
L["CONDITIONPANEL_INTERRUPTIBLE"] = "Можно прервать"
L["CONDITIONPANEL_ITEMRANGE"] = "Предмет в пределе действия объекта"
L["CONDITIONPANEL_LESS"] = "Меньше"
L["CONDITIONPANEL_LESSEQUAL"] = "Меньше или равно"
L["CONDITIONPANEL_LEVEL"] = "Уровень объекта"
L["CONDITIONPANEL_MANAUSABLE"] = "Заклинания готово к использованию (Мана/Энергия/и т.д.)"
L["CONDITIONPANEL_MOUNTED"] = "На транспорте"
L["CONDITIONPANEL_NAME"] = "Название объекта"
L["CONDITIONPANEL_NAMETOMATCH"] = "Имя равно"
L["CONDITIONPANEL_NAMETOOLTIP"] = "Вы можете указать несколько имен для проверки разделив их точкой с запятой (;). Условие считается выполненным если совпало хотя одно имя."
L["CONDITIONPANEL_NOTEQUAL"] = "Не равно"
L["CONDITIONPANEL_OPERATOR"] = "Оператор"
L["CONDITIONPANEL_OR"] = "Или"
L["CONDITIONPANEL_PETMODE"] = "Атакующий режим питомца"
L["CONDITIONPANEL_PETSPEC"] = "специализация питомца"
L["CONDITIONPANEL_POWER"] = "Основной ресурс"
L["CONDITIONPANEL_POWER_DESC"] = [=[Будет проверять энергию, если цель - друид в форме кошки, 
ярость - если цель воин, и т.д.]=]
L["CONDITIONPANEL_PVPFLAG"] = "Объект с меткой PvP"
L["CONDITIONPANEL_RAIDICON"] = "Иконка рейда"
L["CONDITIONPANEL_REMOVE"] = "Удалить это условие"
L["CONDITIONPANEL_RESTING"] = "Отдыхает"
L["CONDITIONPANEL_ROLE"] = "Роль игорка"
L["CONDITIONPANEL_SPELLRANGE"] = "Заклинание достает до цели"
L["CONDITIONPANEL_SWIMMING"] = "Плавание"
L["CONDITIONPANEL_TRACKING"] = "Поиск активности"
L["CONDITIONPANEL_TYPE"] = "Тип"
L["CONDITIONPANEL_UNIT"] = "Объект"
L["CONDITIONPANEL_UNITISUNIT"] = "Объект равен"
L["CONDITIONPANEL_UNITISUNIT_DESC"] = "Это условие выполнено если объект в первом поле ввода совпадает с объектом во втором поле ввода."
L["CONDITIONPANEL_UNITISUNIT_EBDESC"] = "Введите объект для сравнения с объектом в первом поле ввода."
L["CONDITIONPANEL_VALUEN"] = "Значение"
L["CONDITIONPANEL_VEHICLE"] = "Объект на сред. передвижения"
L["CONDITIONS"] = "Условия"
L["CONFIGMODE"] = "TellMeWhen в режиме настройки. Значки не будут работать до выхода из режима настройки. Наберите /tmw для включения/выключения режима настройки."
L["CONFIGMODE_EXIT"] = "Выйти из режима настройки"
L["CONFIGMODE_NEVERSHOW"] = "Больше не показывать"
L["CONFIGPANEL_CLEU_HEADER"] = "Боевые события"
L["COPYGROUP"] = "Копировать всю группу"
L["COPYPOSSCALE"] = "Копировать расположение/масштаб"
L["CrowdControl"] = "Контроль"
L["Curse"] = "Проклятье"
L["DamageBuffs"] = "Наносящие урон баффы"
L["DamageShield"] = "Поглощающий щит"
L["DEBUFFTOCHECK"] = "Дебафф для проверки"
L["DEBUFFTOCOMP1"] = "Первый дебаф для сравнения"
L["DEBUFFTOCOMP2"] = "Второй дебаф для сравнения"
L["DEFAULT"] = "По умолчанию"
L["DefensiveBuffs"] = "Защитные баффы"
L["DESCENDING"] = "Нисходящий"
L["DISABLED"] = "Отключено"
L["Disease"] = "Болезнь"
L["Disoriented"] = "Дезориентация"
L["DR-Disorient"] = "Дезориентация"
L["DR-Silence"] = "Немота"
L["DR-Taunt"] = "Таунты"
L["DT_DOC_gsub"] = "Дает досту к функции LUA string.gsub для DogTags для мощных возможностей построковой обработки."
L["DT_DOC_IsShown"] = "Сообщает, показана или нет иконка"
L["DT_DOC_LocType"] = "Показывает тип эффекта потери контроля, отображаемый на иконке. (Этот признак должен использоваться с %s типом иконок)."
L["DT_DOC_Opacity"] = "Возвращает непрозрачность значка. Возвращаемое значение между 0 и 1."
L["DT_DOC_strfind"] = "Дает досту к функции LUA string.find для DogTags для мощных возможностей построковой обработки."
L["DURATION"] = "Продолжительность"
L["EARTH"] = "Земля"
L["ECLIPSE_DIRECTION"] = "Направление затмения"
L["elite"] = "Элитный"
L["ENABLINGOPT"] = "Дополнение TellMeWhen_Options отключено. Включаю ..."
L["Enraged"] = "Энрейдж"
L["ERROR_MISSINGFILE"] = "Для использования TellMeWhen %s необходима перезагрузка WoW (%s не найден). Перезагрузить WoW сейчас?"
L["ERROR_MISSINGFILE_NOREQ"] = [=[Может понадобиться полный перезапуск игры, чтобы использовать TellMeWhen %s:

%s не найден.

Хотите перезапустить WoW сейчас?]=]
L["ERROR_MISSINGFILE_REQFILE"] = "Требуемый файл"
L["ERROR_NOTINITIALIZED_NO_ACTION"] = "TellMeWhen не может произвести это действие, если аддон не удалось инициализировать!"
L["ERROR_NOTINITIALIZED_NO_LOAD"] = "TellMeWhen_Options не может быть загружен, если аддон не удалось инициализировать!"
L["EVENT_FREQUENCY"] = "Триггер Частота"
L["EVENT_WHILECONDITIONS"] = "Условия Триггера"
L["EVENTHANDLER_LUA_LUAEVENTf"] = "Lua событие: %s"
L["EVENTS_CHOOSE_EVENT"] = "Выберите Триггер:"
L["EVENTS_CHOOSE_HANDLER"] = "Выберите Уведомление:"
L["EVENTS_HANDLER_ADD_DESC"] = "|cff7fffffНажмите|r чтобы добавить извещение такого типа."
L["EVENTS_SETTINGS_CNDTJUSTPASSED"] = "И это только что начало происходить"
L["EVENTS_SETTINGS_CNDTJUSTPASSED_DESC"] = "Препятствует тому, чтобы событие было обработано, если состояние, сформулированное выше, только что не начало происходить."
L["EVENTS_SETTINGS_HEADER"] = "Настройки события"
L["EVENTS_SETTINGS_ONLYSHOWN"] = "Обрабатывать только если значок отображается"
L["EVENTS_SETTINGS_ONLYSHOWN_DESC"] = "Препятствует обработке события если иконка не показана"
L["EVENTS_SETTINGS_PASSINGCNDT"] = "Обрабатывается только если условие проходит"
L["EVENTS_SETTINGS_PASSINGCNDT_DESC"] = "Предотвращает обработку события пока нижележащее условие не будет выполнено"
L["EVENTS_SETTINGS_PASSTHROUGH"] = "Продолжайте для нижележащих событий"
L["EVENTS_SETTINGS_TIMER_HEADER"] = "Настройки таймера"
L["EVENTS_SETTINGS_TIMER_NAME"] = "Название таймера"
L["EVENTS_SETTINGS_TIMER_NAME_DESC"] = [=[Введите название изменяемого таймера.

Названия таймеров должны быть в нижнем регистре без пробелов.

Используйте это название таймера в других местах, где вы хотите проверить этот таймер (Условия и Text Displays с помощью [Timer] DogTag)]=]
L["EVENTS_SETTINGS_TIMER_OP_DESC"] = "Выберите операцию, которую вы хотите выполнить на таймере"
L["EVENTS_TAB"] = "Оповещения"
L["EVENTS_TAB_DESC"] = "Настройка триггеров для звуков, вывода текста и анимации."
L["EXPORT_ALLGLOBALGROUPS"] = "Все |cff00c300Global|r Группы"
L["EXPORT_f"] = "Экспорт %s"
L["EXPORT_HEADING"] = "Экспорт"
L["EXPORT_SPECIALDESC2"] = "Другие пользователи TellMeWhen могут импортировать эти данные только в том случае, если они имеют версию %s"
L["EXPORT_TOCOMM"] = "Игроку"
L["EXPORT_TOCOMM_DESC"] = [=[Введите имя игрока в поле и выберите эту опцию чтобы переслать ему настройки. Игрок должен быть доступен для команды /whisper (та же фракция и сервер что и вы, быть в онлайне) и обладать TellMeWhen версии 4.0.0 и выше.
Также Вы можете ввести "GUILD" или "RAID" (внимание на регистр) для посылке всей сваей гильдии или рейду.]=]
L["EXPORT_TOGUILD"] = "в Гильдию"
L["EXPORT_TORAID"] = "в рейд"
L["EXPORT_TOSTRING"] = "В строку"
L["EXPORT_TOSTRING_DESC"] = "Строка, содержащая настройки, которые впоследствии можно будет ввести в поле ввода. Чтобы ее скопировать нажмите Ctrl+C, после чего строку можно вставить туда, куда пожелаете."
L["FALSE"] = "Неверно"
L["fCODESNIPPET"] = "Фрагмент кода: %s"
L["Feared"] = "Страх"
L["fGROUP"] = "Группа: %s"
L["fGROUPS"] = "Группы: %s"
L["fICON"] = "Значок: %s"
L["FIRE"] = "Огонь"
L["FONTCOLOR"] = "Цвет шрифта"
L["FONTSIZE"] = "Размер шрифта"
L["FORWARDS_IE"] = "вперед"
L["FORWARDS_IE_DESC"] = "Загрузить следующую иконку, которая была отредактирована (%s |T%s:0|t)."
L["fPROFILE"] = "Профиль: %s"
L["FROMNEWERVERSION"] = "Вы импортируете данные созданные в более новой версии TellMeWhen. Некоторые установки не будут работать пока вы не обновите TellMeWhen до последней версии."
L["fTEXTLAYOUT"] = "Расположение текста: %s"
L["GCD"] = "Глобальная перезарядка"
L["GCD_ACTIVE"] = "GCD активен"
L["GENERIC_NUMREQ_CHECK_DESC"] = "Установите эту опцию чтобы включить и настроить %s"
L["GENERICTOTEM"] = "тотем %d"
L["GLYPHTOCHECK"] = "Символ для проверки"
L["GROUP"] = "Группа"
L["GROUPCONDITIONS"] = "Усл. группы"
L["GROUPCONDITIONS_DESC"] = "Настройте условия, которые позволят вам точно настроить, когда отображается эта группа."
L["GROUPICON"] = "Группа: %s, значок: %d"
L["GROUPSETTINGS_DESC"] = "Настройте параметры для этой группы."
L["GUIDCONFLICT_IGNOREFORSESSION"] = "Игнорировать конфликт для этого сеанса конфигурации."
L["Heals"] = "Исцеления игрока"
L["HELP_BUFF_NOSOURCERPPM"] = [=[Похоже, вы пытаетесь отследить %s, который является бафом, использующим систему RPPM.

Из-за ошибки Blizzard этот баф не может быть отслежен, если у вас включен параметр %q.

Если вы хотите, чтобы этот баф был правильно отслежен, отключите этот параметр.]=]
L["HELP_EXPORT_DOCOPY_MAC"] = "Нажмите |cff7fffffCMD+C|r , чтобы скопировать"
L["HELP_EXPORT_DOCOPY_WIN"] = "Нажмите |cff7fffffCTRL+C|r , чтобы скопировать"
L["HELP_NOUNIT"] = "Добавьте объект!"
L["HELP_NOUNITS"] = "Нужно добавить хотя бы один объект!"
L["HELP_POCKETWATCH"] = [=[|TInterface\Icons\INV_Misc_PocketWatch_01:20|t - Значок часов.
Этот значок отображается когда заклинание проверяемое по имени отсутствует в вашей книге заклинаний.
Для отображения правильного значка измените имя заклинания на Spell ID (нажмите ЛКМ на имени в поле ввода, выберите правильное заклинание в списке подсказок и нажмите на нем ПКМ)
]=]
L["ICON"] = "Значок"
L["ICON_TOOLTIP2NEW"] = [=[|cff7fffffПКМ|r для свойств значка.
|cff7fffffПКМ и тащите|r на другой значок для перемещения/копирования.
|cff7fffffТащите|r заклинание или предмет на значок для быстрого назначения свойств.]=]
L["ICON_TOOLTIP2NEWSHORT"] = "|cff7fffffПКМ|r для выбора опций иконки"
L["ICONALPHAPANEL_FAKEHIDDEN"] = "Всегда скрывать"
L["ICONALPHAPANEL_FAKEHIDDEN_DESC"] = "Скрывает значок, оставляя его активным, что позволяет условиям других значков использовать его."
L["ICONGROUP"] = "Значок: %s (Группа: %s)"
L["ICONMENU_ABSENT"] = "Отсутствует"
L["ICONMENU_ADDMETA"] = "Добавить к мета-значку"
L["ICONMENU_ALLOWGCD"] = "Разрешить глобальное восстановление (GCD)"
L["ICONMENU_ALLOWGCD_DESC"] = "Установите этот флажок, чтобы позволить таймеру реагировать и показывать глобальное восстановление (GCD), а не игнорировать его."
L["ICONMENU_ALLSPELLS"] = "Все используемые заклинания"
L["ICONMENU_ALLSPELLS_DESC"] = "Это состояние активно, когда все заклинания, отслеживаемые этим значком, готовы к определенному объекту."
L["ICONMENU_ANCHORTO"] = "Якорь к %s"
L["ICONMENU_ANCHORTO_DESC"] = [=[Якорь %s к %s, чтобы всякий раз, когда %s перемещается, %s переместился вслед.

Продвинутые якорные параметры настройки доступны в групповыз насторйках.]=]
L["ICONMENU_ANCHORTO_UIPARENT"] = "Перезагружает якорь"
L["ICONMENU_ANCHORTO_UIPARENT_DESC"] = [=[Восстанавливает якорь %s обратно на экран (Пользовательский интерфейс). В настоящее время он привязан к %s.

Расширенные настройки привязки доступны в параметрах группы.]=]
L["ICONMENU_ANYSPELLS"] = "Любые заклинания"
L["ICONMENU_ANYSPELLS_DESC"] = "Это состояние активно, когда по крайней мере одно из заклинаний, отслеживаемых этим значком, готово на определенном объекте."
L["ICONMENU_APPENDCONDT"] = "Добавляет как %q состояние"
L["ICONMENU_BAR_COLOR_BACKDROP"] = "Цвет фона"
L["ICONMENU_BAR_COLOR_BACKDROP_DESC"] = "Настройте цвет и непрозрачность фона в панели."
L["ICONMENU_BAR_COLOR_COMPLETE"] = "Цвет завершения"
L["ICONMENU_BAR_COLOR_COMPLETE_DESC"] = "Цвет бара, когда время восстановления/длительности завершено."
L["ICONMENU_BAR_COLOR_MIDDLE"] = "Цвет половины"
L["ICONMENU_BAR_COLOR_MIDDLE_DESC"] = "Цвет полосы, когда время восстановления/длительность наполовину завершено."
L["ICONMENU_BAR_COLOR_START"] = "Начальный цвет"
L["ICONMENU_BAR_COLOR_START_DESC"] = "Цвет полосы, когда время восстановления/длительность только началось."
L["ICONMENU_BAROFFS"] = [=[Это количество будет добавлено к полосе для компенсации.

Полезно для настраиваемых индикаторов, указывающих на то, что вы должны начать применение заклинания, предотвращающего потерю бафа, либо на нехватку ресурса, необходимого для применения заклинания, и для того, чтобы иметь некоторый запас в случае прерывания.]=]
L["ICONMENU_BOTH"] = "Любой"
L["ICONMENU_BUFF"] = "Баф"
L["ICONMENU_BUFFCHECK"] = "Отсутствующие бафы/дебафы"
L["ICONMENU_BUFFCHECK_DESC"] = [=[Проверяет, нет ли ауры на любом из наблюдаемых объектов.

Используйте этот тип значка для таких вещей, как проверка отсутствующих рейд бафов.

В большинстве других ситуаций следует использовать %q тип значка.]=]
L["ICONMENU_BUFFDEBUFF"] = "Баф/Дебаф"
L["ICONMENU_BUFFDEBUFF_DESC"] = "Отслеживает бафы и/или дебафы."
L["ICONMENU_BUFFTYPE"] = "Баф или Дебаф"
L["ICONMENU_CAST"] = "Применение заклинания"
L["ICONMENU_CAST_DESC"] = "Отслеживает потоковые и применяемые заклинания."
L["ICONMENU_CHECKNEXT"] = "Расширенные суб-меты"
L["ICONMENU_CHECKNEXT_DESC"] = [=[Галочка заставит эту иконку распространить на все подходящие иконки любых мета иконок на любой уровень вместо того, чтобы прость ставить галочки на под-мета иконки так, как будто они были бы только другой обычной иконкой.

 Кроме того, эта иконка не будет показывать иконок, которые уже показала другая мета иконка, которая обновляет перед ними. ]=]
L["ICONMENU_CHECKREFRESH"] = "Отслеживает обновления"
L["ICONMENU_CHECKREFRESH_DESC"] = [=[Боевой журнал Близзардов жутко глючит когда дело доходит до обновляемых заклинаний или страха (или других заклинаний, которые ломаются после определенного количества ущерба). Боевой журнал скажет, что заклинание было обновлено когда нанесен ущерб, даже при том, что этого технически не было. Без галочки это поле отключает отслеживание обновлений, но помните, что правильные обновления будут также проигнорированы.

Рекомендуется оставить эту галочку, если DRы, которые Вы проверяете, не ломаются после определенного количества ущерба.]=]
L["ICONMENU_CHOOSENAME_ITEMSLOT_DESC"] = [=[Введите название, ID или ячейку снаряжения того, что Вы хотите отслеживать на этой иконке. Можно добавить несколько названий (любые комбинации имен, ID или ячеек снаряжения), разделяя их ';'.
Ячейки снаряжения - это номера соответствующие предметам надетым на персонаже (голова, шея и т.д.). При изменении предмета в ячейке снаряжения соответствующее изменение произойдет и в значке.
Shift+ЛКМ введет предметы и текст  или  перетащите их мышью для ввода их в это поле.]=]
L["ICONMENU_CHOOSENAME_ORBLANK"] = "(оставьте |cff7fffffпустым|r, чтобы отслеживать все)"
L["ICONMENU_CHOOSENAME_WPNENCH_DESC"] = [=[Введите название(я) оружейных энчантов для отслеживания их этой иконкой. Можете добавить несколько названий отделяя их (;).
|cFFFF5959ВАЖНО|r: название энчанта должно быть введено точно так, как оно всплывает в подсказке вашего оружия когда энчант активирован (т.е. "%s", а не "%s").
]=]
L["ICONMENU_CHOOSENAME3"] = "Что отслеживать"
L["ICONMENU_CHOSEICONTODRAGTO"] = "Выберите значок для перетаскивания:"
L["ICONMENU_CHOSEICONTOEDIT"] = "Выберите значок для редактирования:"
L["ICONMENU_CLEU"] = "Боевое событие"
L["ICONMENU_CLEU_DESC"] = [=[Отслеживает события боя.

Примеры включают промахи спеллов, инстант касты, смерти, но иконка может отслеживать почти что угодно.]=]
L["ICONMENU_CLEU_NOREFRESH"] = "Не обновлять"
L["ICONMENU_CNDTIC"] = "Значок-условие"
L["ICONMENU_CNDTIC_DESC"] = "Отслеживает состояние условий."
L["ICONMENU_CNDTIC_ICONMENUTOOLTIP"] = "(%d |4Состояние:Состояния;)"
L["ICONMENU_COMPONENTICONS"] = "Значки и Группы компонентов"
L["ICONMENU_COOLDOWNCHECK"] = "Проверка кулдауна"
L["ICONMENU_COOLDOWNCHECK_DESC"] = "Включить изменение цвета иконки, когда контратакующая способность на восстановлении"
L["ICONMENU_COPYHERE"] = "Копировать сюда"
L["ICONMENU_COUNTING"] = "Таймер запущен"
L["ICONMENU_CUSTOMTEX"] = "Пользовательская текстура"
L["ICONMENU_CUSTOMTEX_DESC"] = [=[Если Вы хотите заменить текстуру этой иконки, введите Название или ID заклинания, которое имеет нужную текстуру.
Вы можете ввести путь по которому находится ваша текстура, пример: "Interface/Icons/123.tga", где "123.tga" - имя файла с текстурой, "Interface/Icons/" - путь к ней.
Вы можете просмотреть список динамических текстур, введя "$" (dollar sign; ALT-36).
Вы можете использовать свои текстуры до тех пор, пока они находятся в каталоге в WoW, имеют формат .TGA и .BLP, имеют размер степени числа 2 (32, 64, 128, etc).]=]
L["ICONMENU_DEBUFF"] = "Дебаф"
L["ICONMENU_DISPEL"] = "Тип развеивания"
L["ICONMENU_DONTREFRESH"] = "Не обновлять"
L["ICONMENU_DONTREFRESH_DESC"] = "Ставьте галочку чтобы заставить кулдаун не перезагружать, если срабатывания триггера не происходит во время отсчета в обратном порядке."
L["ICONMENU_DR"] = "Убывающая доходность (димишинг)"
L["ICONMENU_DR_DESC"] = "Отслеживает продолжительность и степень убывающей доходности (димишинга)."
L["ICONMENU_DRABSENT"] = "Неуменьшенный "
L["ICONMENU_DRPRESENT"] = "Уменьшенный"
L["ICONMENU_DRS"] = "Убывающая доходность (димишинг)"
L["ICONMENU_DURATION_MAX_DESC"] = "Максимальный срок действия для отображения иконки"
L["ICONMENU_DURATION_MIN_DESC"] = "Минимальная срок действия для отображения иконки"
L["ICONMENU_ENABLE"] = "Включено"
L["ICONMENU_FAKEMAX_DESC"] = [=[Эта настройка используется для того, чтобы вся группа иконок затухала с одинаковой скоростью, что даёт визуальную индикацию, какие таймеры истекают первыми.

Установите в 0 для отключения.]=]
L["ICONMENU_FOCUS"] = [=[Фокус
]=]
L["ICONMENU_FOCUSTARGET"] = "Цель фокуса"
L["ICONMENU_FRIEND"] = "Дружественный"
L["ICONMENU_HIDEUNEQUIPPED"] = "Спрятать, когда слот свободен"
L["ICONMENU_HIDEUNEQUIPPED_DESC"] = "При установке этой опции значок будет скрыт если проверяемый слот оружия пуст"
L["ICONMENU_HOSTILE"] = "Враждебный"
L["ICONMENU_ICD"] = "Внутренний кулдаун"
L["ICONMENU_ICD_DESC"] = "Отслеживает время восстановления проков или др. подобных эффектов"
L["ICONMENU_ICDBDE"] = "Баф/Дебаф/Урон/Энергия/Призыв"
L["ICONMENU_ICDTYPE"] = "Срабатывает от"
L["ICONMENU_IGNORENOMANA"] = "Игнорировать нехватку энергии"
L["ICONMENU_IGNORENOMANA_DESC"] = [=[Ставьте галочку чтобы заставить абилку не рассматриваться как непригодную по причине нехватки ресурсов для ее использования .

Полезный для способностей(абилок), таких как %s или %s]=]
L["ICONMENU_IGNORERUNES"] = "Игнорирование рун"
L["ICONMENU_IGNORERUNES_DESC"] = "Отметьте для того, чтобы считать КД готовым, если единственное, что его блокирует - КД на руну или ГКД."
L["ICONMENU_IGNORERUNES_DESC_DISABLED"] = "Для включения опции \"Игнорировать руны\" необходимо включить опцию \"Проверять восстановление\""
L["ICONMENU_INVERTBARDISPLAYBAR_DESC"] = "Отметьте для того, чтобы полоска заполнялась полностью по истечении времени."
L["ICONMENU_INVERTBARS"] = "Заполнение полосок вверх"
L["ICONMENU_ITEMCOOLDOWN"] = "Кулдаун предмета"
L["ICONMENU_ITEMCOOLDOWN_DESC"] = "Отслеживает восстановление предметов."
L["ICONMENU_LIGHTWELL_DESC"] = "Отслеживает продолжительность и изменения вашего %s."
L["ICONMENU_MANACHECK"] = "Проверять энергию?"
L["ICONMENU_MANACHECK_DESC"] = "Включить изменение цвета иконки при недостатке маны/ярости/рунической силы/и т.д."
L["ICONMENU_META"] = "Мета-значок"
L["ICONMENU_META_DESC"] = [=[Объединяет несколько значков в один.
Значки у которых установлено %q будут отображаться в мета-значке так же, как если бы они отображались самостоятельно.]=]
L["ICONMENU_META_ICONMENUTOOLTIP"] = "(%d |4Иконка:Иконки;)"
L["ICONMENU_MOUSEOVER"] = "Курсор мыши над"
L["ICONMENU_MOUSEOVERTARGET"] = "Цель под курсором мыши"
L["ICONMENU_MOVEHERE"] = "Переместить сюда"
L["ICONMENU_NOTCOUNTING"] = "Таймер не запущен"
L["ICONMENU_NOTREADY"] = "Не готов"
L["ICONMENU_OFFS"] = "Смещение"
L["ICONMENU_ONFAIL"] = "Неудача"
L["ICONMENU_ONLYBAGS"] = "Только если в сумках"
L["ICONMENU_ONLYBAGS_DESC"] = "Ставьте галочку для отображения иконки только в случае если само изделие находится в Ваших сумках (или надето). Если разрешен 'Только если надето', то и это также принудительно включено."
L["ICONMENU_ONLYEQPPD"] = "Только если одето"
L["ICONMENU_ONLYEQPPD_DESC"] = "Установите эту опцию для отображения значка только если предмет надет на персонаже."
L["ICONMENU_ONLYIFCOUNTING"] = "Показывать только если таймер активен"
L["ICONMENU_ONLYIFCOUNTING_DESC"] = "Ставьте галочку для показа иконки, только если в настоящее время есть активный таймер, работающий на иконке со значением больше чем 0."
L["ICONMENU_ONLYIFNOTCOUNTING"] = "Показывает только если таймер не активен"
L["ICONMENU_ONLYINTERRUPTIBLE"] = "Только прерываемое"
L["ICONMENU_ONLYINTERRUPTIBLE_DESC"] = "Установите эту опцию для показа только прерываемых заклинаний."
L["ICONMENU_ONLYMINE"] = "Показывать только если это мое заклинание"
L["ICONMENU_ONLYMINE_DESC"] = "При установке этой опции значок будет проверять только ваши собственные баффы/дебаффы"
L["ICONMENU_ONLYSEEN"] = "Только если видно"
L["ICONMENU_ONLYSEEN_DESC"] = "Отметте это, чтобы заставить иконку показать только кулдаун если объект произнес это, по крайней мере, однажды. Вы должны поставить галочку, если Вы проверяете заклинания других Классов в одной иконке."
L["ICONMENU_ONSUCCEED"] = "Успех"
L["ICONMENU_OOPOWER"] = "Из Мощность"
L["ICONMENU_OORANGE"] = "Вне диапазона"
L["ICONMENU_PETTARGET"] = "Цель питомца"
L["ICONMENU_PRESENT"] = "Присутствует"
L["ICONMENU_RANGECHECK"] = "Проверять расстояние до объекта?"
L["ICONMENU_RANGECHECK_DESC"] = "Включить изменение цвета иконки, когда вы вне зоны досягаемости"
L["ICONMENU_REACT"] = "Реакция цели"
L["ICONMENU_REACTIVE"] = "Реактивный заклинания или способности"
L["ICONMENU_REACTIVE_DESC"] = [=[Отслеживает удобство и простоту использования реактивных абилок.

 Реактивные абилки, такие как %s, %s, и %s - это абилки, которые годны к употреблению только когда соблюдены определенные условия.]=]
L["ICONMENU_READY"] = "готов"
L["ICONMENU_RUNES"] = "Восстановление руны"
L["ICONMENU_RUNES_DESC"] = "Отслеживает восстановление рун."
L["ICONMENU_SHOWCBAR_DESC"] = "Показывает полоску,  наложенную на нижнюю половину иконки, которая будет отображать кулдаун/оставшуюся продожительность (или время, которое прошло если галочкой отмечено 'Заполнение полоски'),"
L["ICONMENU_SHOWPBAR_DESC"] = "Показывает полоску, наложенную на верхнюю половину иконки, которая будет отображать ресурс, необходимый для произнесения заклинания (или количество того, что у вас есть если галочкой отмечено 'Заполнение полоски'),"
L["ICONMENU_SHOWSTACKS"] = "Показать стаки"
L["ICONMENU_SHOWSTACKS_DESC"] = "Ставьте галочку для показа числа стаков имеющейся вещи."
L["ICONMENU_SHOWTIMER"] = "Показывать таймер"
L["ICONMENU_SHOWTIMER_DESC"] = "При установке этой опции на значке будет отображаться стандартная круговая анимация восстановления"
L["ICONMENU_SHOWTIMERTEXT"] = "Показывать значение таймера"
L["ICONMENU_SHOWTIMERTEXT_DESC"] = [=[Проверка этого параметра выводит цифровое значение остающегося кулдауна/продолжительности на иконке.
Применимо только если выбран параметр 'Показывать таймер' и установлен OmniCC (или аналог).]=]
L["ICONMENU_SHOWTTTEXT_FIRST"] = "Первая ненулевая переменная"
L["ICONMENU_SHOWWHEN"] = "Непрозрачность и Цвет"
L["ICONMENU_SHOWWHENNONE"] = "Показать если нет результата"
L["ICONMENU_SORT_STACKS_ASC"] = "Мало стаков"
L["ICONMENU_SORT_STACKS_ASC_DESC"] = "Установите этот флажок, для расстановки приоритетов и показа заклинаний с самым низким количеством стаков."
L["ICONMENU_SORT_STACKS_DESC"] = "Много стаков"
L["ICONMENU_SORT_STACKS_DESC_DESC"] = "Установите этот флажок, для расстановки приоритетов и показа заклинаний с самым высоким количеством стаков."
L["ICONMENU_SORTASC"] = "Низкая продолжительность"
L["ICONMENU_SORTASC_DESC"] = "Поставьте этот флажок, чтобы расположить по приоритетам и показать заклинания с самой низкой продолжительностью."
L["ICONMENU_SORTASC_META_DESC"] = "Поставьте этот флажок, чтобы расположить по приоритетам и показать иконки с самой маленькой продолжительностью."
L["ICONMENU_SORTDESC"] = "Высокая продолжительность"
L["ICONMENU_SORTDESC_DESC"] = "Поставьте этот флажок, чтобы расположить по приоритетам и показать заклинания с самой высокой продолжительностью."
L["ICONMENU_SORTDESC_META_DESC"] = "Поставьте этот флажок, чтобы расположить по приоритетам и показать иконки с самой большой продолжительностью."
L["ICONMENU_SPELLCAST_COMPLETE"] = "Конец произнесения залинания/Мгновенное залинание"
L["ICONMENU_SPELLCAST_COMPLETE_DESC"] = [=[Выберите эту опцию если внутренний кулдаун начинается когда:

 |cff7fffff1)|r Вы заканчиваете произносить заклинание, или
 |cff7fffff2)|r Вы произносите мгновенное заклинание .

 Вы должны ввести название/ID заклинания которое вызывает внутренний кулдаун в %q поле ввода.]=]
L["ICONMENU_SPELLCAST_START"] = "Начало произнесения залинания"
L["ICONMENU_SPELLCAST_START_DESC"] = [=[Выберите эту опцию если внутренний кулдаун начинается когда:

 |cff7fffff1)|r Вы начинаете произносить заклинание.

  Вы должны ввести название/ID заклинания которое вызывает внутренний кулдаун в %q поле ввода.]=]
L["ICONMENU_SPELLCOOLDOWN"] = "Кулдаун заклинания"
L["ICONMENU_SPELLCOOLDOWN_DESC"] = "Отслеживает восстановление заклинаний."
L["ICONMENU_SPLIT"] = "Разделится на новую группу"
L["ICONMENU_SPLIT_DESC"] = "Создать новую группу и переместить в нее эту иконку. Большинство параметров настройки группы будут перенесены на новую группу."
L["ICONMENU_STACKS_MAX_DESC"] = "Максимальное количество стаков, необходимое для отображения значка"
L["ICONMENU_STACKS_MIN_DESC"] = "Минимальное количество стаков, необходимое для отображения значка"
L["ICONMENU_STEALABLE"] = "Только возможные для снятия"
L["ICONMENU_STEALABLE_DESC"] = "Ставьте галочку для показа только бафов, которые могут быть сняты залинанием. Лучше всего использовать ставя галочку для 'Магического' типа диспела."
L["ICONMENU_SWAPWITH"] = "Обменять с"
L["ICONMENU_TARGETTARGET"] = "Цель цели"
L["ICONMENU_TOTEM"] = "Тотем"
L["ICONMENU_TOTEM_DESC"] = "Отслеживает ваши тотемы."
L["ICONMENU_TYPE"] = "Тип иконки"
L["ICONMENU_UNIT_DESC"] = [=[Введите название объекта для отслеживания. Объекты могут быть выбраны из выпадающего списка справа или добавлены вручную. Могут быть использованы стандартные имена (например, player) или имена дружественных объектов (например, %s). Множественные имена объектов должны быть разделены точкой с запятой (;).
Для большей информации о объектах посетите http://www.wowpedia.org/UnitId]=]
L["ICONMENU_UNITCOOLDOWN"] = "Восстановление объекта"
L["ICONMENU_UNITCOOLDOWN_DESC"] = [=[Отслеживает время восстановления заклинания, предмета и т.д. у другого объекта.
%s можно отслеживать используя %q в качестве имени.]=]
L["ICONMENU_UNITS"] = "Объекты"
L["ICONMENU_UNITSTOWATCH"] = "Наблюдаемый объект"
L["ICONMENU_UNITSUCCEED"] = "Unit's Conditions Succeed"
L["ICONMENU_UNUSABLE"] = "Недоступно"
L["ICONMENU_USABLE"] = "Доступно"
L["ICONMENU_USEACTIVATIONOVERLAY"] = "Проверка активации границы"
L["ICONMENU_USEACTIVATIONOVERLAY_DESC"] = "Отметить это, чтобы заставить наличием блестящей желтой границы вокруг действия вынудить иконку работать как используемую."
L["ICONMENU_VEHICLE"] = "Средство передвижения"
L["ICONMENU_WPNENCHANT"] = "Чары на оружии"
L["ICONMENU_WPNENCHANT_DESC"] = "Отслеживает временные улучшения на оружии"
L["ICONMENU_WPNENCHANTTYPE"] = " Для отслеживания слота оружия"
L["IconModule_CooldownSweepCooldown"] = "Очистка кулдауна"
L["IconModule_SelfIcon"] = "Иконка"
L["IconModule_Texture_ColoredTexture"] = "текстура"
L["ICONTOCHECK"] = "Значок для проверки"
L["ICONTYPE_DEFAULT_HEADER"] = "Инструкции"
L["ImmuneToMagicCC"] = "Невосприимчивость к контролю"
L["ImmuneToStun"] = "Невосприимчивость к эффектам оглушения"
L["IMPORT_EXPORT"] = "Импорт/Экспорт/Восстановление"
L["IMPORT_EXPORT_BUTTON_DESC"] = "Нажмите на этот список для импорта/экспорта значков, групп и профилей."
L["IMPORT_EXPORT_DESC"] = [=[Нажмите на стрелку выпадающего меню справа от поля ввода чтобы импортировать/экспортировать значки, группы и профили.
Импорт в или из строки, или экспорт другому игроку потребует использование этой сторки ввода. Для детального понимания просмотрите подсказку из выпадающего меню. ]=]
L["IMPORT_FAILED"] = "Импорт не удался!"
L["IMPORT_FROMBACKUP"] = "Из архива"
L["IMPORT_FROMBACKUP_DESC"] = "Настройки, восстановленные из этого меню будут таими, какими были на: %s"
L["IMPORT_FROMBACKUP_WARNING"] = "Архив настроек: %s"
L["IMPORT_FROMCOMM"] = "От игрока"
L["IMPORT_FROMCOMM_DESC"] = "Если другой пользователь поделится с вами своими настройками, вы сможете импортировать их в этом меню."
L["IMPORT_FROMLOCAL"] = "Из профиля"
L["IMPORT_FROMSTRING"] = "Из строки"
L["IMPORT_FROMSTRING_DESC"] = [=[Строки позволяют пользователям обмениваться настройками TellMeWhen.
Для импорта настроек из строки скопируйте ее в буфер обмена (Ctrl+C), нажмите Ctrl+V находясь в поле ввода, после чего вернитесь в это меню. ]=]
L["IMPORT_HEADING"] = "Импорт настроек"
L["IMPORT_LUA_CONFIRM"] = "Ok, импортируй это"
L["IMPORT_LUA_DENY"] = "Об импортной операции"
L["IMPORT_PROFILE"] = "Копировать профиль"
L["IMPORT_PROFILE_NEW"] = "Создать новый профиль"
L["IMPORT_PROFILE_OVERWRITE"] = "Переписать %s"
L["IMPORTERROR_FAILEDPARSE"] = "При обработке строки произошла ошибка. Убедитесь что вы полностью скопировали строку из источника."
L["Incapacitated"] = "Обездвижен"
L["INCHEALS"] = "Входящее лечение объекта"
L["INCHEALS_DESC"] = [=[Проверяет общую сумму входящего лечения объекта (ХоТы и произносимые касты).

Работает только для дружественных целей. Вражеские цели всегда будут показывать 0 входящего лечения.]=]
L["INRANGE"] = "В диапазоне"
L["ITEMCOOLDOWN"] = "Восстановление предмета"
L["ITEMEQUIPPED"] = "Предмет надет"
L["ITEMINBAGS"] = "Подсчет изделия (включает charges)"
L["ITEMTOCHECK"] = "Предмет для проверки"
L["ITEMTOCOMP1"] = "Первый предмет для сравнения"
L["ITEMTOCOMP2"] = "Второй предмет для сравнения"
L["LAYOUTDIRECTION"] = "Установка Направления"
L["LDB_TOOLTIP1"] = "|cff7fffffЩелкните мышью|r для переключения блокировки групп"
L["LDB_TOOLTIP2"] = "|cff7fffffЩелкните ПКМ|r для того чтобы показать/скрыть указанные группы"
L["LEFT"] = "Влево"
L["LOADERROR"] = "Дополнение TellMeWhen_Options не может быть загружено:"
L["LOADINGOPT"] = "Загрузка TellMeWhen_Options."
L["LOCKED"] = "Закреплено"
L["LOSECONTROL_TYPE_ALL"] = "Все типы"
L["LOSECONTROL_TYPE_ALL_DESC"] = "Взаимодействие с иконкой отображает информацию о всех видах эффектов"
L["LUACONDITION"] = "Lua скрипт"
L["LUACONDITION2"] = "Состояние Lua"
L["MACROCONDITION"] = "Макро "
L["MACROCONDITION_DESC"] = [=[Это условие равносильно макро условиям и действует также как и макро условия. Все макро условия могут использоваться с приставкой нет, например:


    "[nomodifier:alt]" - когда не нажата кнопка alt
    "[@target, help][mod:ctrl]" - для дружественной цели ИЛИ нажатая клавиша ctrl
    "[@focus, harm, nomod:shift]" - закрепленная вражествая цель (Фокус) или нажатая клавиша shift

Подробнее на http://www.wowpedia.org/Making_a_macro]=]
L["MACROCONDITION_EB_DESC"] = "При использовании одного условия, открытие и закрытие скобок не обязательно. Скобки требуется при использовании нескольких условий."
L["MACROTOEVAL"] = "Макро условия для оценки"
L["Magic"] = "Магия"
L["MAIN"] = "Основное"
L["MAINASSIST"] = "Главный помощник"
L["MAINOPTIONS_SHOW"] = "Показать основные параметры"
L["MAINTANK"] = "Осн. танк"
L["MESSAGERECIEVE"] = "%s прислал(а) вам строку данных TellMeWhen. Вы можете импортировать эти данные в TellMeWhen используя выпадающий список %q в редакторе значков."
L["MESSAGERECIEVE_SHORT"] = "%s прислал(а) вам строку данных TellMeWhen!"
L["META_ADDICON"] = "добавить иконку"
L["METAPANEL_DOWN"] = "Сместить вниз"
L["METAPANEL_REMOVE"] = "Удалить эту иконку"
L["METAPANEL_UP"] = "Сместить вверх"
L["MISCELLANEOUS"] = "Разное"
L["MiscHelpfulBuffs"] = "Разные полезные баффы"
L["MOON"] = "Луна"
L["MP5"] = "%d MP5"
L["MUSHROOM"] = "Гриб %d"
L["NEWVERSION"] = "Доступна новая версия TellMeWhen: %s"
L["NONE"] = "Ничего из нижеперечисленного"
L["normal"] = "Обычный"
L["NOTINRANGE"] = "Вне диапазона доступности"
L["NUMAURAS"] = "Количество"
L["NUMAURAS_DESC"] = [=[
Это условие проверяет количество активных проков - не следует путать с увеличением счетчиком ауры. Это условие проверяет количество проков вещей, оружия и т.д. одновременно. Используйте аккуратно, т.к. данная функция сильно загружает процессор компьютера.]=]
L["ONLYCHECKMINE"] = "Проверять только мои"
L["ONLYCHECKMINE_DESC"] = "Установите эту опцию для проверки только своих бафов/дебафов"
L["OUTLINE_MONOCHORME"] = "Черно-белый"
L["OUTLINE_NO"] = "Без контура"
L["OUTLINE_THICK"] = "Толстый контур"
L["OUTLINE_THIN"] = "Тонкий контур"
L["PARENTHESIS_TYPE_("] = "открывающая"
L["PARENTHESIS_TYPE_)"] = "закрывающая"
L["PARENTHESIS_WARNING1"] = [=[Число открывающих и закрывающих скобок не совпадает.
Необходимо еще %d %s |4скобка:скобок;]=]
L["PARENTHESIS_WARNING2"] = [=[Недостаточно открывающих скобок!
Необходимо на %d больше открывающих скобок]=]
L["PERCENTAGE"] = "Процент"
L["PET_TYPE_CUNNING"] = "Хитрость"
L["PET_TYPE_FEROCITY"] = "Свирепость"
L["PET_TYPE_TENACITY"] = "Упорство"
L["PLAYER_DESC"] = "(Вы)"
L["Poison"] = "Яд"
L["PvPSpells"] = "Масс контроль в PvP, и т.д."
L["RaidWarningFrame"] = "Рамка предупреждения рейда"
L["rare"] = "Редкий"
L["rareelite"] = "Редкий Элитный"
L["REACTIVECNDT_DESC"] = "Это условие проверяет только возможность применение способности, а не ее откат"
L["REDO"] = "Повторить"
L["ReducedHealing"] = "Снижение эффективности исцеления"
L["RESET_ICON"] = "Сброс"
L["RESET_ICON_DESC"] = "Сбросить настройки всех этих иконок"
L["RESIZE"] = "Изменить размер"
L["RESIZE_TOOLTIP"] = "Чтобы изменить размер, нажмите и тащите "
L["RIGHT"] = "Вправа"
L["Rooted"] = "Корни"
L["RUNES"] = "Проверить руны"
L["RUNSPEED"] = "Скорость бега объекта"
L["SENDSUCCESSFUL"] = "Отправлено успешно"
L["SHAPESHIFT"] = "Изменение облика"
L["Shatterable"] = "Разбиваемо"
L["Silenced"] = "Немота"
L["Slowed"] = "Замедлен"
L["SORTBY"] = "Приоритет"
L["SORTBYNONE"] = "Нормально"
L["SORTBYNONE_DURATION"] = "Нормальная длительность"
L["SORTBYNONE_META_DESC"] = "Если отмечено, то иконки будут проверяться в порядке, который был сформирован выше."
L["SORTBYNONE_STACKS"] = "Обычные стаки"
L["SOUND_CUSTOM"] = "Пользовательский звуковой файл"
L["SOUND_CUSTOM_DESC"] = [=[Укажите путь к пользовательскому звуковому файлу. Приведем несколько примеров (здесь "file' - это имя звукового файла, "ext" - его расширение (поддерживаются только ogg и mp3)):
- "CustomSounds\file.ext" - файл находится в папке CustomSounds которая размещена в корневой папке WoW (папке в которой находятся файл WoW.exe, папки WTF и Interface и т.д.)
- "Interface\AddOns\file.ext": - файл находится в папке AddOns
- "file.ext": - файл находится в в корневой папке WoW
ВАЖНО: необходимо перезапустить WoW для распознавания файлов которых до запуска не было.]=]
L["SOUND_EVENT_DISABLEDFORTYPE"] = "Недоступно"
L["SOUND_EVENT_NOEVENT"] = "Ненастроенное событие"
L["SOUND_EVENT_ONCLEU_DESC"] = "Это событие срабатывает, когда событие боя, отслеживаемое иконкой случается."
L["SOUND_EVENT_ONDURATION"] = "При изменении длительности"
L["SOUND_EVENT_ONDURATION_DESC"] = [=[Это событие возникает когда изменяется продолжительность таймера иконки.

Поскольку это событие имеет место каждый раз, когда иконка обновляется во время работы таймера, то следует установить условие, а событие будет  иметь место только когда состояние того условия изменится.]=]
L["SOUND_EVENT_ONFINISH"] = "При окончании"
L["SOUND_EVENT_ONFINISH_DESC"] = [=[Это событие будет запущено по окончании времени восстановления заклинания/предмета, спадении баффа и т.п.
Внимание: обработчик этого события не исполняется после событий "При отображении" или "При сокрытии"]=]
L["SOUND_EVENT_ONHIDE"] = "При скрытии"
L["SOUND_EVENT_ONHIDE_DESC"] = "Это событие происходит при скрытии значка (даже если установлена опция %q)"
L["SOUND_EVENT_ONSHOW"] = "При отображении"
L["SOUND_EVENT_ONSHOW_DESC"] = "Это событие происходит при отображении значка (даже если установлена опция %q)"
L["SOUND_EVENT_ONSPELL"] = "При изменении заклинания"
L["SOUND_EVENT_ONSPELL_DESC"] = "Это событие происходит при смене заклинания/предмета/и т.п., информация о котором отображается на этом значке."
L["SOUND_EVENT_ONSTACK_DESC"] = [=[Это событие включается когда отслеживаемые стаки или предмет изменяют состояние.

Это включает число уменьшения для %s иконок]=]
L["SOUND_EVENT_ONSTART"] = "На старт"
L["SOUND_EVENT_ONSTART_DESC"] = "Это событие случается когда КД становится становится недоступным, бафф/дебаф применен и т.п."
L["SOUND_EVENT_ONUNIT"] = "При изменении объекта"
L["SOUND_EVENT_ONUNIT_DESC"] = "Это событие происходит при изменении состояния объекта, отображаемого на этом значке."
L["SOUND_SOUNDTOPLAY"] = "Звук для воспроизведения"
L["SOUND_TAB"] = "Звук"
L["SOUND_TAB_DESC"] = "Назначьте звук для проигрывания.Можно указать звук от LibSharedMedia, или звуковой файл."
L["SOUNDERROR1"] = "Файл должен иметь расширение!"
L["SOUNDERROR2"] = "Файлы в формате WAV не поддерживаются WoW 4.0+"
L["SOUNDERROR3"] = "Поддерживаются только файлы в формате OGG и MP3."
L["SPEED"] = "Скорость объекта"
L["SPEED_DESC"] = "Это относится к текущей скорости объекта. Если объект не двигается, то значение равно нулю. Если вы хотите отслеживать максимальную скорость объекта, то используйте команду \"Скорость движения объекта\""
L["SpeedBoosts"] = "Повышения скорости"
L["SPELLCOOLDOWN"] = "Кулдаун заклинания"
L["SPELLTOCHECK"] = "Заклинание для проверки"
L["SPELLTOCOMP1"] = "Первое заклинание к сравнению"
L["SPELLTOCOMP2"] = "Второе заклинание к сравнению"
L["STACKS"] = "Стаки"
L["STANCE"] = "Стойка"
L["STRATA_BACKGROUND"] = "Фон"
L["STRATA_DIALOG"] = "Окно настроек"
L["STRATA_FULLSCREEN"] = "Полный экран"
L["STRATA_FULLSCREEN_DIALOG"] = "Полноэкранное окно настроек"
L["STRATA_HIGH"] = "Высокая"
L["STRATA_LOW"] = "Низкая"
L["STRATA_MEDIUM"] = "Средняя"
L["STRATA_TOOLTIP"] = "Подсказка"
L["Stunned"] = "Оглушен"
L["SUG_BUFFEQUIVS"] = "Эквиваленты бафов"
L["SUG_CLASSSPELLS"] = "Известные заклинания игрока/питомца"
L["SUG_DEBUFFEQUIVS"] = "Эквиваленты дебафов"
L["SUG_DISPELTYPES"] = "Типы рассеивания заклинаний"
L["SUG_INSERT_ANY"] = "|cff7fffffНажмите|r"
L["SUG_INSERT_LEFT"] = "|cff7fffffНажмите ЛКМ|r"
L["SUG_INSERT_RIGHT"] = "|cff7fffffНажмите ПКМ|r"
L["SUG_INSERTEQUIV"] = "%s вставить эквивалентность"
L["SUG_INSERTERROR"] = "%s чтобы вставить сообщение об ошибке"
L["SUG_INSERTID"] = "%s чтобы добавить по ID"
L["SUG_INSERTITEMSLOT"] = "%s чтобы добавить как ID ячейки снаряжения"
L["SUG_INSERTNAME"] = "%s чтобы добавить по имени"
L["SUG_INSERTTEXTSUB"] = "%s для ввода признака"
L["SUG_MISC"] = "Смешанный"
L["SUG_NPCAURAS"] = "Известные баффы/дебаффы НПЦ"
L["SUG_OTHEREQUIVS"] = "Другие эквиваленты."
L["SUG_PATTERNMATCH_FISHINGLURE"] = "Приманка %(рыбная ловля %+%d+%)"
L["SUG_PATTERNMATCH_SHARPENINGSTONE"] = "Оружие заточено %(%+%d+ к урону)"
L["SUG_PATTERNMATCH_WEIGHTSTONE"] = "Оружие утяжелено %(%+%d+ к урону)"
L["SUG_PLAYERAURAS"] = "Известные баффы/дебаффы игроков/питомцев"
L["SUG_PLAYERSPELLS"] = "Ваши заклинания"
L["SUG_TOOLTIPTITLE"] = [=[При вводе текста TellMeWhen будет показывать наиболее подходящие заклинания и способности.

Заклинания делятся на категории и подсвечиваются в списке ниже. Обратите внимание, что в категории, которые начинаются со слова "Изученные" не добавляются заклинания, пока не будут использованы Вами или пока Вы не переключетесь на другой класс.

При нажатии на запись будет вставить его в редактирование.]=]
L["SUG_TOOLTIPTITLE_TEXTSUBS"] = [=[Следующее - это признаки, которые Вы можете захотеть использовать в этой текстовой подсказке. Использование подстановки заставит заменить их соответствующими данными везде, где они отражаются.

Для дополнительной информации об этих признаках, и большего их количества, щелкните по этой кнопке.

Нажатие на ввход вставит его в строку ввода.]=]
L["SUGGESTIONS"] = "Предложения:"
L["SUN"] = "Солнце"
L["TEXTLAYOUTS_DEFAULTS_BINDINGLABEL"] = "Привязка/Ярлык"
L["TEXTLAYOUTS_DEFAULTS_ICON1"] = "Расположение иконки 1"
L["TEXTLAYOUTS_DEFAULTS_STACKS"] = "Стаки"
L["TEXTLAYOUTS_DEFAULTTEXT"] = "Текст по умолчанию"
L["TEXTLAYOUTS_DEFAULTTEXT_DESC"] = "Отредактируйте текст по умолчанию, который будет использоваться на иконке"
L["TEXTLAYOUTS_DELETELAYOUT"] = "Удалить Расположение"
L["TEXTLAYOUTS_fLAYOUT"] = "Расположение текста: %s"
L["TEXTLAYOUTS_SETTEXT"] = "Введите текст"
L["TEXTLAYOUTS_SKINAS"] = "Шкурка как"
L["TEXTLAYOUTS_SKINAS_COUNT"] = "Текст стака"
L["TEXTLAYOUTS_SKINAS_HOTKEY"] = "Привязанный текст"
L["TEXTLAYOUTS_SKINAS_NONE"] = "Нет"
L["TEXTLAYOUTS_STRING_COPYMENU"] = "Скопировать"
L["TEXTLAYOUTS_STRING_SETDEFAULT"] = "По умолчанию"
L["TEXTLAYOUTS_UNNAMED"] = "<без имени>"
L["TOP"] = "Вверху"
L["TOPLEFT"] = "Вверху слева"
L["TOPRIGHT"] = "Вверху справа"
L["TOTEMS"] = "Тотемы для проверки"
L["TRUE"] = "Верно"
L["UIPANEL_BAR_SHOWICON"] = "Показать значок"
L["UIPANEL_BARTEXTURE"] = "Текстура полосы"
L["UIPANEL_COLUMNS"] = "Столбцы"
L["UIPANEL_DELGROUP"] = "Удалить эту группу"
L["UIPANEL_DRAWEDGE"] = "Подсвечивать рамку таймера"
L["UIPANEL_DRAWEDGE_DESC"] = "Подсвечивать рамку таймера восстановления для улучшения видимости"
L["UIPANEL_EFFTHRESHOLD"] = "Порог эффективности защитных заклинаний (бафов)"
L["UIPANEL_EFFTHRESHOLD_DESC"] = "Определяет минимальное количество бафов/дебафов для переключения на более эффективный способ их проверки при наличии большого их количества. Не забудьте, что как только количество проверяемых аур превышает это число, более старые ауры будут расположены по приоритетам вместо порядка, основанного на последовательности их получения."
L["UIPANEL_FONT_DESC"] = "Шрифт для отображения значения суммирования эффекта на иконке."
L["UIPANEL_FONT_OUTLINE"] = "Контур шрифта"
L["UIPANEL_FONT_SIZE"] = "Размер шрифта"
L["UIPANEL_FONT_XOFFS"] = "Смещение по X"
L["UIPANEL_FONT_YOFFS"] = "Смещение по Y"
L["UIPANEL_FONTFACE"] = "Шрифт"
L["UIPANEL_GLYPH"] = "Символ"
L["UIPANEL_GROUPNAME"] = "Переименовать группу"
L["UIPANEL_GROUPRESET"] = "Сбросить расположение"
L["UIPANEL_GROUPS"] = "Группы"
L["UIPANEL_GROUPSORT"] = "Сортировка иконок"
L["UIPANEL_GROUPSORT_alpha"] = "Нерозрачность"
L["UIPANEL_GROUPSORT_alpha_DESC"] = "Сортировать группу по непрозрачности ее иконок"
L["UIPANEL_GROUPSORT_duration"] = "Продолжительность"
L["UIPANEL_GROUPSORT_duration_DESC"] = "Сортирует группу по продолжительности, оставшейся на этих иконках"
L["UIPANEL_GROUPSORT_id"] = "ID иконки"
L["UIPANEL_GROUPSORT_id_DESC"] = "Сортирует группу по ID номерам ее иконок"
L["UIPANEL_GROUPSORT_shown"] = "Показанная"
L["UIPANEL_GROUPSORT_shown_DESC"] = "Сортирует группу по тому, отображается ли значок."
L["UIPANEL_ICONS"] = "Значки"
L["UIPANEL_ICONSPACING"] = "Промежуток между значками"
L["UIPANEL_ICONSPACING_DESC"] = "Расстояние на котором значки расположены друг от друга в группе"
L["UIPANEL_LEVEL"] = "Уровень фрейма"
L["UIPANEL_LOCK"] = "Заблокировать группу"
L["UIPANEL_LOCK_DESC"] = "Заблокировать возможность перемещения или изменения размера группы."
L["UIPANEL_LOCKUNLOCK"] = "Заблокировать/разблокировать аддон"
L["UIPANEL_MAINOPT"] = "Основные параметры"
L["UIPANEL_ONLYINCOMBAT"] = "Показывать только в бою"
L["UIPANEL_POINT"] = "Точка"
L["UIPANEL_POSITION"] = "Расположение"
L["UIPANEL_PRIMARYSPEC"] = "Первый набор талантов"
L["UIPANEL_PTSINTAL"] = "Очков в таланте"
L["UIPANEL_RELATIVEPOINT"] = "Относительная точка"
L["UIPANEL_RELATIVETO"] = "Относительно"
L["UIPANEL_RELATIVETO_DESC"] = "Введите '/framestack' для переключения с заголовка, содержащего список всех фреймов которые Вы закончили с помощью мыши, и их имен, на вставку этого диалога."
L["UIPANEL_ROWS"] = "Строки"
L["UIPANEL_SCALE"] = "Масштаб"
L["UIPANEL_SECONDARYSPEC"] = "Второй набор талантов"
L["UIPANEL_SPEC"] = "Набор талантов"
L["UIPANEL_SPECIALIZATIONROLE_DESC"] = "Проверяет роль (танк, хил или ДД) вашего текущей талантной специализации"
L["UIPANEL_STRATA"] = "Экранная глубина"
L["UIPANEL_SUBTEXT2"] = [=[Значки работают когда они заблокированы.

Когда разблокированы, вы можете перемещать группы значков и изменять их размер, а так же настраивать отдельные значки правым щелчком мыши.

Для блокировки/разблокировки аддона наберите /tellmewhen or /tmw.]=]
L["UIPANEL_TOOLTIP_COLUMNS"] = "Установить число столбцов в этой группе"
L["UIPANEL_TOOLTIP_GROUPRESET"] = "Сбросить расположение и масштаб этой группы"
L["UIPANEL_TOOLTIP_ONLYINCOMBAT"] = "Показывать эту группу только в бою"
L["UIPANEL_TOOLTIP_ROWS"] = "Установить число строк в этой группе"
L["UIPANEL_TOOLTIP_UPDATEINTERVAL"] = "Частота (в секундах) проверки параметров и условий значков. Значение 0 означает максимально быструю проверку. Внимание: маленькие значения могут сильно снизить частоту кадров на слабых компьютерах."
L["UIPANEL_TREE_DESC"] = "Проверка позволяет показать эту группу, когда это дерево талантов активно, или, без проверки, чтобы заставить ее исчезнуть, когда оно не активно."
L["UIPANEL_UPDATEINTERVAL"] = "Интервал обновления"
L["UIPANEL_WARNINVALIDS"] = "Предупреждать о недействительных иконках"
L["UNDO"] = "Отменить"
L["UNDO_DESC"] = "Отменить последние изменения, внесенные в эти настройки."
L["UNITTWO"] = "Второй объект"
L["UNKNOWN_GROUP"] = "<Неизвестная/Недоступная группа>"
L["UNKNOWN_ICON"] = "<Неизвестная/Недоступная иконка>"
L["UNKNOWN_UNKNOWN"] = "<Неизвестно ???>"
L["UNNAMED"] = "((Без названия))"
L["VALIDITY_CONDITION2_DESC"] = "#%d состояние"
L["VALIDITY_ISINVALID"] = "недействительно"
L["WARN_DRMISMATCH"] = [=[Внимание! Вы проверяете убывающую эффективность залинаний из двух различных известных категорий.
Все заклинания обязаны быть из одной убывающей категории чтобы иконка фунционировала должным образом. Были обнаружены следующие категории и заклинания :]=]
L["WATER"] = "Водa"
L["worldboss"] = "Мировой босс"

elseif locale == "zhCN" then
L["!!Main Addon Description"] = "为冷却、增益/减益及其他各个方面提供视觉、听觉以及文字上的通知。"
L["ABSORBAMT"] = "护盾吸收量"
L["ABSORBAMT_DESC"] = "检测单位上的护盾的吸收总量."
L["ACTIVE"] = "%d 作用中"
L["ADDONSETTINGS_DESC"] = "配置所有通用插件的设置。"
L["AIR"] = "空气图腾"
L["ALLOWCOMM"] = "允许图标导入"
L["ALLOWCOMM_DESC"] = "允许另一个TellMeWhen使用者给你发送数据."
L["ALLOWVERSIONWARN"] = "新版本通知"
L["ALPHA"] = "透明度"
L["ANCHOR_CURSOR_DUMMY"] = "TellMeWhen鼠标指针"
L["ANCHOR_CURSOR_DUMMY_DESC"] = [=[这是一个虚拟的鼠标指针，作用是帮你定位图标。

在使用”鼠标悬停目标“单位时，利用该指针定位分组非常有用。

你只需|cff7fffff右键点击并拖拽|r一个图标到指针上即可将该图标组依附到指针。

由于暴雪的bug，冷却时钟动画在移动后可能不能正常使用，依附指针的图标最好禁用它。

|cff7fffff左键点击并拖拽|r移动指针.]=]
L["ANCHORTO"] = "附着框架"
L["ANIM_ACTVTNGLOW"] = "图标:激活边框"
L["ANIM_ACTVTNGLOW_DESC"] = "在图标上显示暴雪的法术激活边框."
L["ANIM_ALPHASTANDALONE"] = "透明度"
L["ANIM_ALPHASTANDALONE_DESC"] = "设置动画的最大不透明度"
L["ANIM_ANCHOR_NOT_FOUND"] = "动画无法附着到框架%q. 当前图标是否没有使用到这个框架?"
L["ANIM_ANIMSETTINGS"] = "设置"
L["ANIM_ANIMTOUSE"] = "使用的动画效果"
L["ANIM_COLOR"] = "颜色/不透明度"
L["ANIM_COLOR_DESC"] = "设置闪光的颜色和不透明度."
L["ANIM_DURATION"] = "动画持续时间"
L["ANIM_DURATION_DESC"] = "设置动画触发后持续显示多久."
L["ANIM_FADE"] = "淡入淡出闪光"
L["ANIM_FADE_DESC"] = [=[勾选此项使每个闪光之间平滑的淡入淡出.不勾选则直接闪光.

(译者注:具体的差别请自行进行区分,我测试的效果除了第一次闪光之外,后面的闪光区别并不明显.)]=]
L["ANIM_ICONALPHAFLASH"] = "图标:透明度闪烁"
L["ANIM_ICONALPHAFLASH_DESC"] = "通过改变图标的透明度达到闪烁提示的效果."
L["ANIM_ICONBORDER"] = "图标:边框"
L["ANIM_ICONBORDER_DESC"] = "在图标上生成一个有颜色的边框."
L["ANIM_ICONCLEAR"] = "图标:停止动画"
L["ANIM_ICONCLEAR_DESC"] = "停止当前图标播放的所有动画效果."
L["ANIM_ICONFADE"] = "图标:淡入/淡出"
L["ANIM_ICONFADE_DESC"] = "在选定的事件发生时透明度将会渐变."
L["ANIM_ICONFLASH"] = "图标:颜色闪烁"
L["ANIM_ICONFLASH_DESC"] = "利用颜色重叠在整个图标上闪烁,达到提示的效果."
L["ANIM_ICONOVERLAYIMG"] = "图标:图像重叠"
L["ANIM_ICONOVERLAYIMG_DESC"] = "在图标上重叠显示自定义图像."
L["ANIM_ICONSHAKE"] = "图标:抖动"
L["ANIM_ICONSHAKE_DESC"] = "在事件触发时抖动图标."
L["ANIM_INFINITE"] = "无限重复播放"
L["ANIM_INFINITE_DESC"] = [=[勾选此项将会重复播放动画直到同个图标上另一相同类型的动画开始播放,或是在'%q'触发之后才会停止.

说明:比如在事件'开始'中设置了'图标:颜色闪烁',并且勾上了'无限重复播放',在事件'结束'设置了'图标:颜色闪烁'(持续时间3秒),事件'开始'中的'无限重复播放'就会在事件'结束'的动画播放结束后停止. 假如在同一个图标中没有设置相同类型的动画那就只能在'图标:停止动画'触发之后才会停止播放.如果还是不明白,就这样理解,同个图标中相同类型的动画只会存在一个,后面触发的会覆盖掉前面触发的.]=]
L["ANIM_MAGNITUDE"] = "抖动幅度"
L["ANIM_MAGNITUDE_DESC"] = "设置抖动的幅度需要多猛烈."
L["ANIM_PERIOD"] = "闪光周期"
L["ANIM_PERIOD_DESC"] = [=[设置每次闪烁应当持续多久 - 闪烁的显示时间或消退时间.

如果设置为0则不会闪烁和淡出.]=]
L["ANIM_PIXELS"] = "%s像素"
L["ANIM_SCREENFLASH"] = "屏幕:闪烁"
L["ANIM_SCREENFLASH_DESC"] = "利用颜色重叠在整个游戏屏幕上闪烁,达到提示的效果."
L["ANIM_SCREENSHAKE"] = "屏幕:抖动"
L["ANIM_SCREENSHAKE_DESC"] = [=[在事件触发时抖动整个游戏屏幕.

注意:屏幕抖动只能在离开战斗后使用,或者在你登陆之后没有启用姓名版的情况下使用.

(第一点啰嗦的解释:如果你在登陆之后按下显示姓名板的快捷键或者姓名板原本就已经启用了,就无法在战斗中使用屏幕抖动,如果你需要在战斗中使用请继续往下看.

第二点啰嗦的解释:如果一定要在战斗中使用屏幕抖动请先关闭在‘ESC->界面->名字’中有关显示单位姓名板的选项,然后小退,登陆之后切记不可以按到任何显示姓名板的快捷键.）]=]
L["ANIM_SECONDS"] = "%s秒"
L["ANIM_SIZE_ANIM"] = "边框大小"
L["ANIM_SIZE_ANIM_DESC"] = "设置边框的尺寸大小为多少."
L["ANIM_SIZEX"] = "图像宽度"
L["ANIM_SIZEX_DESC"] = "设置图像的宽度为多少."
L["ANIM_SIZEY"] = "图像高度"
L["ANIM_SIZEY_DESC"] = "设置图像的高度为多少."
L["ANIM_TAB"] = "动画"
L["ANIM_TAB_DESC"] = "设置需要播放的动画效果。它们当中有些作用于图标，有些则是作用于整个屏幕。"
L["ANIM_TEX"] = "材质"
L["ANIM_TEX_DESC"] = [=[选择你要用来覆盖图标的材质.

你可以输入一个材质路径, 例如'Interface/Icons/spell_nature_healingtouch', 假如材质路径为'Interface/Icons'可以只输入'spell_nature_healingtouch'.

你也能使用放在WoW目录中的自定义材质(请在该字段输入材质的相对路径,像是'tmw/ccc.tga'),仅支持尺寸为2的N次方(32, 64, 128,等)并且类型为.tga和.blp的材质文件.]=]
L["ANIM_THICKNESS"] = "边框粗细"
L["ANIM_THICKNESS_DESC"] = "设置边框的粗细为多少.(一个图标的默认尺寸为30)"
L["ANN_CHANTOUSE"] = "使用频道"
L["ANN_EDITBOX"] = "要输出的文字内容"
L["ANN_EDITBOX_DESC"] = "输入通知事件触发时你想输出的文字内容."
L["ANN_EDITBOX_WARN"] = "在此输入你想要输出的文字内容"
L["ANN_FCT_DESC"] = [=[使用暴雪的浮动战斗文字功能输出.必须先启用界面选项中的文字输出.
]=]
L["ANN_NOTEXT"] = "<无文字>"
L["ANN_SHOWICON"] = "显示图标材质"
L["ANN_SHOWICON_DESC"] = "一些文本目标能随文字内容一起显示一个材质.勾选此项启用该功能."
L["ANN_STICKY"] = "静态模式"
L["ANN_SUB_CHANNEL"] = "输出位置"
L["ANN_TAB"] = "文字"
L["ANN_TAB_DESC"] = "设置要输出的文本。包括暴雪的文字频道、UI框架以及其他的一些插件。"
L["ANN_WHISPERTARGET"] = "悄悄话目标"
L["ANN_WHISPERTARGET_DESC"] = "输入你想要密语的玩家名字,仅可密语同服务器/同阵营的玩家."
L["ASCENDING"] = "升序"
L["ASPECT"] = "守护"
L["AURA"] = "光环"
L["BACK_IE"] = "转到上一个"
L["BACK_IE_DESC"] = [=[载入上一个编辑过的图标

%s |T%s:0|t]=]
L["Bleeding"] = "流血效果"
L["BOTTOM"] = "下"
L["BOTTOMLEFT"] = "左下"
L["BOTTOMRIGHT"] = "右下"
L["BUFFCNDT_DESC"] = "只有第一个法术会被检测,其他的将全部被忽略."
L["BUFFTOCHECK"] = "要检测的增益"
L["BUFFTOCOMP1"] = "进行比较的第一个增益"
L["BUFFTOCOMP2"] = "进行比较的第二个增益"
L["BURNING_EMBERS_FRAGMENTS"] = "燃烧余烬碎片"
L["BURNING_EMBERS_FRAGMENTS_DESC"] = [=[一个完整的燃烧余烬由十个碎片所组成.

假如你有一个半的燃烧余烬(由十五个余烬碎片组成),你要监视全部的余烬碎片时,可能需要使用此条件.]=]
L["CACHING"] = [=[TellMeWhen正在缓存和筛选游戏中的所有法术.
这只需要在每次魔兽世界补丁升级之后完成一次.您可以使用下方的滑杆加快或减慢过程.]=]
L["CACHINGSPEED"] = "法术缓存速度(每帧法术):"
L["CASTERFORM"] = "施法者形态"
L["CENTER"] = "居中"
L["CHANGELOG"] = "更新日志"
L["CHANGELOG_DESC"] = "显示TellMeWhen当前和之前版本的变动列表."
L["CHANGELOG_INFO2"] = [=[欢迎使用 TellMeWhen v%s!
<br/><br/>
在你确认完变更信息后, 点击标签 %s 或底部的标签 %s 开始设置TellMeWhen.]=]
L["CHANGELOG_LAST_VERSION"] = "上次安装的版本"
L["CHAT_FRAME"] = "聊天窗口"
L["CHAT_MSG_CHANNEL"] = "聊天频道"
L["CHAT_MSG_CHANNEL_DESC"] = "将输出到一个聊天频道,例如交易频道或是你加入的某个自定义频道."
L["CHAT_MSG_SMART"] = "智能频道"
L["CHAT_MSG_SMART_DESC"] = "此频道会自行选择最合适的输出频道.(仅限于:战场,团队,队伍,或说)"
L["CHOOSEICON"] = "选择一个用于检测的图标"
L["CHOOSEICON_DESC"] = [=[|cff7fffff点击|r选择一个图标/分组.
|cff7fffff左键点击并拖放|r以滚动方式改变顺序.
|cff7fffff右键点击并拖放|r以常用方式改变顺序.

译者注:如果分不清楚区别请直接使用常用方式.]=]
L["CHOOSENAME_DIALOG"] = [=[输入你想让此图标监视的名称或ID.你可以利用';'(分号)输入多个条目(名称/ID/同类型的任意组合).

你可以使用破折号（减号）从同类型法术中单独移除某个法术，例如"Slowed; -眩晕"。

你可以|cff7fffff按住Shift再按鼠标左键点选|r法术/物品/聊天连结或者拖曳法术/物品添加到此编辑框中.]=]
L["CHOOSENAME_DIALOG_PETABILITIES"] = "|cFFFF5959宠物技能|r必须使用法术ID."
L["CLEU_"] = "任意事件"
L["CLEU_CAT_AURA"] = "增益/减益"
L["CLEU_CAT_CAST"] = "施法"
L["CLEU_CAT_MISC"] = "其他"
L["CLEU_CAT_SPELL"] = "法术"
L["CLEU_CAT_SWING"] = "近战/远程"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MASK"] = "操控者关系"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MINE"] = "操控者关系:玩家(你)"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MINE_DESC"] = "勾选以排除那些你控制的单位."
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_OUTSIDER"] = "操控者关系:外人"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_OUTSIDER_DESC"] = "勾选以排除那些与你同组的某人控制的单位."
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_PARTY"] = "操控者关系:队伍成员"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_PARTY_DESC"] = "勾选以排除那些你队伍中的玩家控制的单位."
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_RAID"] = "操控者关系:团队成员"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_RAID_DESC"] = "勾选以排除那些你团队中的玩家控制的单位."
L["CLEU_COMBATLOG_OBJECT_CONTROL_MASK"] = "操控者"
L["CLEU_COMBATLOG_OBJECT_CONTROL_NPC"] = "操控者:服务器"
L["CLEU_COMBATLOG_OBJECT_CONTROL_NPC_DESC"] = "勾选以排除那些服务器控制的单位(包括它们的宠物跟守卫)."
L["CLEU_COMBATLOG_OBJECT_CONTROL_PLAYER"] = "操控者:人类"
L["CLEU_COMBATLOG_OBJECT_CONTROL_PLAYER_DESC"] = "勾选以排除那些人类控制的单位(包括他们的宠物跟守卫),这里是指真正的人类,不是游戏中的人类种族,如果你教会了猴子/猩猩玩魔兽世界的话,可以加上它们."
L["CLEU_COMBATLOG_OBJECT_FOCUS"] = "其他:你的焦点目标"
L["CLEU_COMBATLOG_OBJECT_FOCUS_DESC"] = "勾选以排除那个你设置为焦点目标的单位."
L["CLEU_COMBATLOG_OBJECT_MAINASSIST"] = "其他:主助攻"
L["CLEU_COMBATLOG_OBJECT_MAINASSIST_DESC"] = "勾选以排除团队中被标记为主助攻的单位."
L["CLEU_COMBATLOG_OBJECT_MAINTANK"] = "其他:主坦克"
L["CLEU_COMBATLOG_OBJECT_MAINTANK_DESC"] = "勾选以排除团队中被标记为主坦克的单位."
L["CLEU_COMBATLOG_OBJECT_NONE"] = "其他:未知单位"
L["CLEU_COMBATLOG_OBJECT_NONE_DESC"] = "勾选以排除WoW客户端完全未知的单位，还可以排除在游戏客户端中没有提供单位的一些事件。"
L["CLEU_COMBATLOG_OBJECT_REACTION_FRIENDLY"] = "单位反应:友好"
L["CLEU_COMBATLOG_OBJECT_REACTION_FRIENDLY_DESC"] = "勾选以排除那些对你反应是友好的单位."
L["CLEU_COMBATLOG_OBJECT_REACTION_HOSTILE"] = "单位反应:敌对"
L["CLEU_COMBATLOG_OBJECT_REACTION_HOSTILE_DESC"] = "勾选以排除那些对你反应是敌对的单位."
L["CLEU_COMBATLOG_OBJECT_REACTION_MASK"] = "单位反应"
L["CLEU_COMBATLOG_OBJECT_REACTION_NEUTRAL"] = "单位反应:中立"
L["CLEU_COMBATLOG_OBJECT_REACTION_NEUTRAL_DESC"] = "勾选以排除那些对你反应是中立的单位."
L["CLEU_COMBATLOG_OBJECT_TARGET"] = "其他:你的目标"
L["CLEU_COMBATLOG_OBJECT_TARGET_DESC"] = "勾选以排除你当前的目标单位."
L["CLEU_COMBATLOG_OBJECT_TYPE_GUARDIAN"] = "单位类型:守卫"
L["CLEU_COMBATLOG_OBJECT_TYPE_GUARDIAN_DESC"] = "勾选以排除守卫. 守卫是指那些会保护操控者但是不能直接被控制的单位."
L["CLEU_COMBATLOG_OBJECT_TYPE_MASK"] = "单位类型"
L["CLEU_COMBATLOG_OBJECT_TYPE_NPC"] = "单位类型:NPC"
L["CLEU_COMBATLOG_OBJECT_TYPE_NPC_DESC"] = "勾选以排除非玩家角色."
L["CLEU_COMBATLOG_OBJECT_TYPE_OBJECT"] = "单位类型:对象"
L["CLEU_COMBATLOG_OBJECT_TYPE_OBJECT_DESC"] = "勾选以排除像是陷阱,鱼点等其他没有被划分到\"单位类型\"中的其他任何东西."
L["CLEU_COMBATLOG_OBJECT_TYPE_PET"] = "单位类型:宠物"
L["CLEU_COMBATLOG_OBJECT_TYPE_PET_DESC"] = "勾选以排除宠物. 宠物是指那些会保护操控者并且可以直接被控制的单位."
L["CLEU_COMBATLOG_OBJECT_TYPE_PLAYER"] = "单位类型:玩家角色"
L["CLEU_COMBATLOG_OBJECT_TYPE_PLAYER_DESC"] = "勾选以排除玩家角色."
L["CLEU_CONDITIONS_DESC"] = [=[配置每个单元必须通过的条件，以便进行检查。

这些条件仅在输入要检查的单位，并且所有输入的单位均为单位ID时可用 - 不能在这些条件下使用名称。]=]
L["CLEU_CONDITIONS_DEST"] = "目标条件"
L["CLEU_CONDITIONS_SOURCE"] = "来源条件"
L["CLEU_DAMAGE_SHIELD"] = "伤害护盾"
L["CLEU_DAMAGE_SHIELD_DESC"] = "此事件在伤害护盾对一个单位造成伤害时发生. (%s,%s,等等,但是不包括%s)"
L["CLEU_DAMAGE_SHIELD_MISSED"] = "伤害护盾未命中"
L["CLEU_DAMAGE_SHIELD_MISSED_DESC"] = "此事件在伤害护盾对一个单位造成伤害失败时发生. (%s,%s,等等,但是不包括%s)"
L["CLEU_DAMAGE_SPLIT"] = "伤害分担"
L["CLEU_DAMAGE_SPLIT_DESC"] = "此事件在伤害被两个或者更多个单位分担时发生."
L["CLEU_DESTUNITS"] = "用于检测的目标单位"
L["CLEU_DESTUNITS_DESC"] = "选择你想要图标检测的事件目标单位,可以保留空白让图标检测任意的事件目标单位."
L["CLEU_DIED"] = "死亡"
L["CLEU_ENCHANT_APPLIED"] = "附魔应用"
L["CLEU_ENCHANT_APPLIED_DESC"] = "此事件所指为暂时性武器附魔,像是潜行者的毒药和萨满的武器强化."
L["CLEU_ENCHANT_REMOVED"] = "附魔消失"
L["CLEU_ENCHANT_REMOVED_DESC"] = "此事件所指为暂时性武器附魔,像是潜行者的毒药和萨满的武器强化."
L["CLEU_ENVIRONMENTAL_DAMAGE"] = "环境伤害"
L["CLEU_ENVIRONMENTAL_DAMAGE_DESC"] = "包括来自熔岩、掉落、溺水以及疲劳的伤害."
L["CLEU_EVENTS"] = "用于检测的事件"
L["CLEU_EVENTS_ALL"] = "全部事件"
L["CLEU_EVENTS_DESC"] = "选择那些你想要图标检测的战斗事件."
L["CLEU_FLAGS_DESC"] = "可以排除列表中包含的某种属性的单位使其无法触发图标.如果勾选排除某种属性的单位,图标将不会处理那个单位相关的事件."
L["CLEU_FLAGS_DEST"] = "排除"
L["CLEU_FLAGS_SOURCE"] = "排除"
L["CLEU_HEADER"] = "战斗事件过滤"
L["CLEU_HEADER_DEST"] = "目标单位"
L["CLEU_HEADER_SOURCE"] = "来源单位"
L["CLEU_NOFILTERS"] = "%s图标在%s没有定义任何过滤条件.你需要定义至少一个过滤条件,否则无法正常使用."
L["CLEU_PARTY_KILL"] = "队伍击杀"
L["CLEU_PARTY_KILL_DESC"] = "当队伍中的某人击杀某怪物时触发."
L["CLEU_RANGE_DAMAGE"] = "远程攻击伤害"
L["CLEU_RANGE_MISSED"] = "远程攻击未命中"
L["CLEU_SOURCEUNITS"] = "用于检测的来源单位"
L["CLEU_SOURCEUNITS_DESC"] = "选择你想要图标检测的事件来源单位,可以保留空白让图标检测任意的事件来源单位."
L["CLEU_SPELL_AURA_APPLIED"] = "效果获得(指目标单位获得某增益/减益,来源单位为施放者)"
L["CLEU_SPELL_AURA_APPLIED_DOSE"] = "效果叠加"
L["CLEU_SPELL_AURA_BROKEN"] = "效果被打破(物理)"
L["CLEU_SPELL_AURA_BROKEN_SPELL"] = "效果被打破(法术)"
L["CLEU_SPELL_AURA_BROKEN_SPELL_DESC"] = [=[此事件在一个效果被法术伤害打破时发生(通常是指某种控场技能).

图标会筛选出被打破的效果;在文字输出/显示时你可以使用标签[Extra]替代这个效果.]=]
L["CLEU_SPELL_AURA_REFRESH"] = "效果刷新"
L["CLEU_SPELL_AURA_REMOVED"] = "效果移除"
L["CLEU_SPELL_AURA_REMOVED_DOSE"] = "效果叠加移除"
L["CLEU_SPELL_CAST_FAILED"] = "施法失败"
L["CLEU_SPELL_CAST_START"] = "开始施法"
L["CLEU_SPELL_CAST_START_DESC"] = [=[此事件在开始施放一个法术时发生.

注意:为了防止可能出现的游戏框架滥用,暴雪禁用了此事件的目标单位,所以你不能过滤它们.]=]
L["CLEU_SPELL_CAST_SUCCESS"] = "法术施放成功"
L["CLEU_SPELL_CAST_SUCCESS_DESC"] = "此事件在法术施放成功时发生."
L["CLEU_SPELL_CREATE"] = "法术制造"
L["CLEU_SPELL_CREATE_DESC"] = "此事件在一个对像被制造时发生,例如猎人的陷阱跟法师的传送门."
L["CLEU_SPELL_DAMAGE"] = "法术伤害"
L["CLEU_SPELL_DAMAGE_CRIT"] = "法术暴击"
L["CLEU_SPELL_DAMAGE_CRIT_DESC"] = "此事件在任意法术伤害暴击时发生，会跟%q事件同时触发。"
L["CLEU_SPELL_DAMAGE_DESC"] = "此事件在任意法术造成伤害时发生."
L["CLEU_SPELL_DAMAGE_NONCRIT"] = "法术未暴击"
L["CLEU_SPELL_DAMAGE_NONCRIT_DESC"] = "此事件在任意法术伤害没有暴击时发生，会跟%q事件同时触发。"
L["CLEU_SPELL_DISPEL"] = "驱散"
L["CLEU_SPELL_DISPEL_DESC"] = [=[此事件在一个效果被驱散时发生.

图标会筛选出被驱散的效果;在文字输出/显示时你可以使用标签[Extra]替代这个效果.]=]
L["CLEU_SPELL_DISPEL_FAILED"] = "驱散失败"
L["CLEU_SPELL_DISPEL_FAILED_DESC"] = [=[此事件在驱散某一效果失败时发生.

图标会筛选出这个驱散失败的效果;在文字输出/显示时你可以使用标签[Extra]替代这个效果.]=]
L["CLEU_SPELL_DRAIN"] = "抽取资源"
L["CLEU_SPELL_DRAIN_DESC"] = "此事件在资源从某个单位移除时发生(资源指生命值/魔法值/怒气/能量等)."
L["CLEU_SPELL_ENERGIZE"] = "获得资源"
L["CLEU_SPELL_ENERGIZE_DESC"] = "此事件在一个单位获得资源时发生(资源指生命值/魔法值/怒气/能量等)."
L["CLEU_SPELL_EXTRA_ATTACKS"] = "获得额外攻击"
L["CLEU_SPELL_EXTRA_ATTACKS_DESC"] = "此事件在你获得额外的近战攻击时发生."
L["CLEU_SPELL_HEAL"] = "治疗"
L["CLEU_SPELL_INSTAKILL"] = "秒杀"
L["CLEU_SPELL_INTERRUPT"] = "打断 - 被打断的法术"
L["CLEU_SPELL_INTERRUPT_DESC"] = [=[此事件在施法被打断时发生.

图标会筛选出被打断施法的法术;在文字输出/显示时你可以使用标签[Extra]替代这个法术.

请注意两个打断事件的区别 - 当一个法术被打断时两个事件都会发生,但是筛选出的法术会有所不同.]=]
L["CLEU_SPELL_INTERRUPT_SPELL"] = "打断 - 造成打断的法术"
L["CLEU_SPELL_INTERRUPT_SPELL_DESC"] = [=[此事件在施法被打断时发生.

图标会筛选出造成打断施法的法术;在文字输出/显示时你可以使用标签[Extra]替代这个法术.

请注意两个打断事件的区别 - 当一个法术被打断时两个事件都会发生,但是筛选出的法术会有所不同.]=]
L["CLEU_SPELL_LEECH"] = "资源吸取"
L["CLEU_SPELL_LEECH_DESC"] = "此事件在从某个单位移除资源给另一单位时发生(资源指生命值/魔法值/怒气/能量等)."
L["CLEU_SPELL_MISSED"] = "法术未命中"
L["CLEU_SPELL_PERIODIC_DAMAGE"] = "伤害(持续性)"
L["CLEU_SPELL_PERIODIC_DRAIN"] = "抽取资源(持续性)"
L["CLEU_SPELL_PERIODIC_ENERGIZE"] = "获得资源(持续性)"
L["CLEU_SPELL_PERIODIC_HEAL"] = "治疗(持续性)"
L["CLEU_SPELL_PERIODIC_LEECH"] = "资源吸取(持续性)"
L["CLEU_SPELL_PERIODIC_MISSED"] = "伤害(持续性)未命中"
L["CLEU_SPELL_REFLECT"] = "法术反射"
L["CLEU_SPELL_REFLECT_DESC"] = [=[此事件在你反射一个对你施放的法术时发生.

来源单位是反射法术者,目标单位是法术被反射的施法者.]=]
L["CLEU_SPELL_RESURRECT"] = "复活"
L["CLEU_SPELL_RESURRECT_DESC"] = "此事件在某个单位从死亡中复活时发生."
L["CLEU_SPELL_STOLEN"] = "效果被偷取"
L["CLEU_SPELL_STOLEN_DESC"] = [=[此事件在增益被偷取时发生,很可能来自%s.

图标会筛选出那个被偷取的法术.]=]
L["CLEU_SPELL_SUMMON"] = "法术召唤"
L["CLEU_SPELL_SUMMON_DESC"] = "此事件在一个NPC被召唤或者生成时发生."
L["CLEU_SWING_DAMAGE"] = "近战攻击伤害"
L["CLEU_SWING_MISSED"] = "近战攻击未命中"
L["CLEU_TIMER"] = "设置事件的计时器"
L["CLEU_TIMER_DESC"] = [=[设置图标计时器在事件发生时的持续时间.

你也可以在%q编辑框中使用"法术:持续时间"语法设置一个持续时间,在事件处理你所筛选出的那些法术时使用.

如果法术没有指定持续时间,或者你没有筛选过滤任何法术(编辑框为空白),那将使用这个持续时间.]=]
L["CLEU_UNIT_DESTROYED"] = "单位被摧毁"
L["CLEU_UNIT_DESTROYED_DESC"] = "此事件在一个单位被摧毁时发生(比如萨满的图腾)."
L["CLEU_UNIT_DIED"] = "单位死亡"
L["CLEU_WHOLECATEGORYEXCLUDED"] = [=[你排除了%q分类中的所有条目,这将导致图标不再处理任何事件.

取消勾选至少一个条目使图标可以正常运作.]=]
L["CLICK_TO_EDIT"] = "|cff7fffff点击|r编辑."
L["CMD_CHANGELOG"] = "更新日志"
L["CMD_DISABLE"] = "禁用"
L["CMD_ENABLE"] = "启用"
L["CMD_OPTIONS"] = "选项"
L["CMD_PROFILE"] = "配置文件"
L["CMD_PROFILE_INVALIDPROFILE"] = "无法找到名为 %q 的配置文件! (译者注:注意区分大小写)"
L["CMD_PROFILE_INVALIDPROFILE_SPACES"] = [=[提示: 如果配置文件名称包含空格,请在前后加上英文的引号. 

例如:
/tmw profile "打打 - 索拉丁"
或
/tmw 配置文件 "百战好哥哥 - 索拉丁"]=]
L["CMD_TOGGLE"] = "切换"
L["CNDT_DEPRECATED_DESC"] = "条件%s无效。这可能是因为游戏机制改变所造成的，请移除它或者更改为其他条件。"
L["CNDT_MULTIPLEVALID"] = "你可以利用分号分隔的方式输入多个用于检测的名称或ID。"
L["CNDT_ONLYFIRST"] = "仅第一个法术/物品会被检测,使用分号分隔的列表不适用此条件类型."
L["CNDT_RANGE"] = "单位距离"
L["CNDT_RANGE_DESC"] = "使用LibRangeCheck-2.0检测单位的大概距离．单位不存在时条件将会返回否（false）。"
L["CNDT_RANGE_IMPRECISE"] = "%d 码。 (|cffff1300不太准确|r)"
L["CNDT_RANGE_PRECISE"] = "%d 码。(|cff00c322准确|r)"
L["CNDT_SLIDER_DESC_CLICKSWAP_TOMANUAL"] = "|cff7fffff点击鼠标右键|r切换到手动输入模式。"
L["CNDT_SLIDER_DESC_CLICKSWAP_TOSLIDER"] = "|cff7fffff点击鼠标右键|r切换到滚动条选择模式。"
L["CNDT_SLIDER_DESC_CLICKSWAP_TOSLIDER_DISALLOWED"] = "仅允许在手动输入时输入大于%s的数值。 (较大的数值显示在暴雪滚动条会变得很奇怪)"
L["CNDT_TOTEMNAME"] = "图腾名称"
L["CNDT_TOTEMNAME_DESC"] = [=[设置为空白将检测所选类型的任意图腾.

你可以输入一个图腾名称,或者一个使用分号分隔开的名称列表,只用来检测某几个特定的图腾.]=]
L["CNDT_UNKNOWN_DESC"] = "你的设置中有一个名为%s的标识无法找到对应的条件。可能是因为使用了旧版本的TMW或者该条件已经被移除。"
L["CNDTCAT_ARCHFRAGS"] = "考古学碎片"
L["CNDTCAT_ATTRIBUTES_PLAYER"] = "玩家属性/状态"
L["CNDTCAT_ATTRIBUTES_UNIT"] = "单位属性/状态"
L["CNDTCAT_BOSSMODS"] = "首领模块"
L["CNDTCAT_BUFFSDEBUFFS"] = "增益/减益"
L["CNDTCAT_CURRENCIES"] = "货币"
L["CNDTCAT_FREQUENTLYUSED"] = "常用条件"
L["CNDTCAT_LOCATION"] = "组队/区域"
L["CNDTCAT_MISC"] = "其他"
L["CNDTCAT_RESOURCES"] = "能量类型"
L["CNDTCAT_SPELLSABILITIES"] = "法术/物品"
L["CNDTCAT_STATS"] = "战斗统计(人物属性)"
L["CNDTCAT_TALENTS"] = "职业/天赋"
L["CODESNIPPET_ADD2"] = "新 %s 片段"
L["CODESNIPPET_ADD2_DESC"] = "|cff7fffff点击|r新增 %s 片段."
L["CODESNIPPET_AUTORUN"] = "登陆时自动运行"
L["CODESNIPPET_AUTORUN_DESC"] = "如果启用，此片段将在TWM载入时激活(激活时间为在玩家登陆事件PLAYER_LOGIN时，但是在图标跟分组创建之前)。"
L["CODESNIPPET_CODE"] = "用于执行的Lua代码"
L["CODESNIPPET_DELETE"] = "删除片段"
L["CODESNIPPET_DELETE_CONFIRM"] = "你确定要删除代码片段(%q)?"
L["CODESNIPPET_EDIT_DESC"] = "|cff7fffff点击|r 编辑此片段."
L["CODESNIPPET_GLOBAL"] = "共用片段"
L["CODESNIPPET_ORDER"] = "执行顺序"
L["CODESNIPPET_ORDER_DESC"] = [=[设置此代码片段的执行顺序(相对于其他的片段而言).

%s和%s都将基于这个数值来执行.

如果两个片段使用了相同的顺序,无法确认谁先执行的时候,可以使用小数.]=]
L["CODESNIPPET_PROFILE"] = "角色专用片段"
L["CODESNIPPET_RENAME"] = "代码片段名称"
L["CODESNIPPET_RENAME_DESC"] = [=[为这个片段输入一个自己容易识别的名称.

名称不是唯一,允许重复使用.]=]
L["CODESNIPPET_RUNAGAIN"] = "再次运行片段"
L["CODESNIPPET_RUNAGAIN_DESC"] = [=[此片段已经在进程中运行过一次。

|cff7fffff点击|r再次运行。]=]
L["CODESNIPPET_RUNNOW"] = "执行片段"
L["CODESNIPPET_RUNNOW_DESC"] = [=[点击执行此代码片段.

按住|cff7fffffCtrl|r跳过片段已经执行的确认.]=]
L["CODESNIPPETS"] = "Lua代码片段"
L["CODESNIPPETS_DEFAULTNAME"] = "新片段"
L["CODESNIPPETS_DESC"] = [=[此功能允许你编写Lua代码并在TellMeWhen加载时执行.

它是一个高级功能,可以让Lua熟练工如鱼得水,也可以让完全不懂Lua的人导入其他TellMeWhen使用者分享出来的片段.

可用在像是编写一个特定的过程用于Lua条件中(必须把它们定义在TMW.CNDT.Env).

片段可被定义为角色专用或公用(共用片段会在所有角色执行).]=]
L["CODESNIPPETS_DESC_SHORT"] = "输入的LUA代码会在TellMeWhen加载的时候运行。"
L["CODESNIPPETS_IMPORT_GLOBAL"] = "新的共用片段"
L["CODESNIPPETS_IMPORT_GLOBAL_DESC"] = "片段导入为共用片段."
L["CODESNIPPETS_IMPORT_PROFILE"] = "新的角色专用片段"
L["CODESNIPPETS_IMPORT_PROFILE_DESC"] = "片段导入为角色专用片段."
L["CODESNIPPETS_TITLE"] = "Lua片段(高玩级)"
L["CODETOEXE"] = "要执行的代码"
L["COLOR_MSQ_COLOR"] = "使用Masque边框颜色(整个图标)"
L["COLOR_MSQ_COLOR_DESC"] = "勾选此项将使用Masque皮肤中设置的边框颜色对图标着色(假如你在皮肤设置中有使用边框的话)."
L["COLOR_MSQ_ONLY"] = "使用Masque边框颜色(仅边框)"
L["COLOR_MSQ_ONLY_DESC"] = "勾选此项将仅对图标边框使用Masque皮肤中设置的边框颜色进行着色(假如你在皮肤设置中有使用边框的话).图标不会被着色."
L["COLOR_OVERRIDE_GLOBAL"] = "覆盖全局颜色"
L["COLOR_OVERRIDE_GLOBAL_DESC"] = "检查以配置独立于全局定义颜色的颜色。"
L["COLOR_OVERRIDE_GROUP"] = "覆盖分组颜色"
L["COLOR_OVERRIDE_GROUP_DESC"] = "检查以配置与为图标组指定的颜色无关的颜色。"
L["COLOR_USECLASS"] = "使用职业颜色"
L["COLOR_USECLASS_DESC"] = "勾选使用所检测单位的职业颜色来给进度条上色。"
L["COLORPICKER_BRIGHTNESS"] = "亮度"
L["COLORPICKER_BRIGHTNESS_DESC"] = "设置颜色的亮度(有时也称为值)"
L["COLORPICKER_DESATURATE"] = "减小饱和度"
L["COLORPICKER_DESATURATE_DESC"] = "在应用颜色之前对纹理去饱和，允许您重新着色纹理，而不是着色。"
L["COLORPICKER_HUE"] = "色度"
L["COLORPICKER_HUE_DESC"] = "设置颜色的色度"
L["COLORPICKER_ICON"] = "预览"
L["COLORPICKER_OPACITY"] = "不透明度"
L["COLORPICKER_OPACITY_DESC"] = "设置颜色的不透明度(也称为alpha通道)."
L["COLORPICKER_RECENT"] = "最近使用的颜色"
L["COLORPICKER_RECENT_DESC"] = [=[|cff7fffff点击|r读取这个颜色。
|cff7fffff右键点击|r从列表移除这个颜色。]=]
L["COLORPICKER_SATURATION"] = "饱和度"
L["COLORPICKER_SATURATION_DESC"] = "设置颜色的饱和度."
L["COLORPICKER_STRING"] = "16进制字符"
L["COLORPICKER_STRING_DESC"] = "获取/设置 当前颜色的十六进制(A)RGB"
L["COLORPICKER_SWATCH"] = "颜色"
L["COMPARISON"] = "比较"
L["CONDITION_COUNTER"] = "用于检测的计数器"
L["CONDITION_COUNTER_EB_DESC"] = "输入你想要检测的计数器名称。"
L["CONDITION_QUESTCOMPLETE"] = "任务完成"
L["CONDITION_QUESTCOMPLETE_DESC"] = "检测一个任务是否已完成."
L["CONDITION_QUESTCOMPLETE_EB_DESC"] = [=[输入你想检测的任务ID.

任务ID可以在魔兽世界数据库网站获得,像是db.178.com(中文)和www.wowhead.com(英文).

例如:http://db.178.com/wow/cn/quest/32615.html<超多的巨型恐龙骨骼>任务ID为32615.]=]
L["CONDITION_TIMEOFDAY"] = "一天中的时间"
L["CONDITION_TIMEOFDAY_DESC"] = [=[此条件将使用当前时间与设置时间进行比较.

用于比较的时间是本地时间(基于你的电脑时钟).它不会获取服务器的时间.]=]
L["CONDITION_TIMER"] = "用于检测的计时器"
L["CONDITION_TIMER_EB_DESC"] = "输入你想用于检测的计时器名称。"
L["CONDITION_TIMERS_FAIL_DESC"] = [=[设置条件无法通过以后图标计时器的持续时间

(译者注:图标在条件每次通过/无法通过后都会重新计时,另外在默认的情况下图标的显示只会根据条件通过情况来改变,设定的持续时间不会影响到图标的显示情况,不会在设置的持续时间倒数结束后隐藏图标,如果想要图标在计时结束后隐藏,需要勾选'仅在计时器作用时显示',这是4.5.3版本新加入的功能.)]=]
L["CONDITION_TIMERS_SUCCEED_DESC"] = [=[设置条件成功通过以后图标计时器的持续时间

(译者注:图标在条件每次通过/无法通过后都会重新计时,另外在默认的情况下图标的显示只会根据条件通过情况来改变,设定的持续时间不会影响到图标的显示情况,不会在设置的持续时间倒数结束后隐藏图标,如果想要图标在计时结束后隐藏,需要勾选'仅在计时器作用时显示',这是4.5.3版本新加入的功能.)]=]
L["CONDITION_WEEKDAY"] = "星期几"
L["CONDITION_WEEKDAY_DESC"] = [=[检测今天是不是星期几.

用于检测的时间是本地时间(基于你的电脑时钟).它不会获取服务器的时间.]=]
L["CONDITIONALPHA_METAICON"] = "条件未通过时"
L["CONDITIONALPHA_METAICON_DESC"] = [=[该透明度用于条件未通过时.

条件可在%q选项卡中设置.]=]
L["CONDITIONPANEL_ABSOLUTE"] = "(非百分比/绝对值)"
L["CONDITIONPANEL_ADD"] = "添加条件"
L["CONDITIONPANEL_ADD2"] = "点击增加一个条件"
L["CONDITIONPANEL_ALIVE"] = "单位存活"
L["CONDITIONPANEL_ALIVE_DESC"] = "此条件会检测指定单位的存活情况."
L["CONDITIONPANEL_ALTPOWER"] = "特殊能量"
L["CONDITIONPANEL_ALTPOWER_DESC"] = [=[这是大地的裂变某些首领战遇到的特殊能量,像是古加尔的腐化值跟艾卓曼德斯的音波值.
]=]
L["CONDITIONPANEL_AND"] = "同时"
L["CONDITIONPANEL_ANDOR"] = "同时/或者"
L["CONDITIONPANEL_ANDOR_DESC"] = "|cff7fffff点击|r切换逻辑运算符 同时/或者(And/Or)"
L["CONDITIONPANEL_AUTOCAST"] = "宠物自动施法"
L["CONDITIONPANEL_AUTOCAST_DESC"] = "检查指定宠物技能是否自动释放中."
L["CONDITIONPANEL_BIGWIGS_ENGAGED"] = "Big Wigs - 首领战开始"
L["CONDITIONPANEL_BIGWIGS_ENGAGED_DESC"] = [=[检测Big Wigs激活的首领战。

请输入首领战的全名到“用于检测的首领战”。]=]
L["CONDITIONPANEL_BIGWIGS_TIMER"] = "Big Wigs - 计时器"
L["CONDITIONPANEL_BIGWIGS_TIMER_DESC"] = [=[检测Big Wigs首领模块计时器的持续时间。

请输入计时器全名到“用于检测的计时器”。]=]
L["CONDITIONPANEL_BITFLAGS_ALWAYS"] = "始终为真"
L["CONDITIONPANEL_BITFLAGS_CHECK"] = "反选"
L["CONDITIONPANEL_BITFLAGS_CHECK_DESC"] = [=[勾选此项来反转检测所用的条件。

默认情况下，条件会在选择的选项成立时通过。

如果设置了此项，条件会在所选的选项都没有成立时通过。]=]
L["CONDITIONPANEL_BITFLAGS_CHOOSECLASS"] = "选择职业..."
L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_CONTINENT"] = "选择大陆..."
L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_RAIDICON"] = "选择图标..."
L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_TYPES"] = "选择类型..."
L["CONDITIONPANEL_BITFLAGS_CHOOSERACE"] = "选择种族..."
L["CONDITIONPANEL_BITFLAGS_NEVER"] = "无 - 始终为否"
L["CONDITIONPANEL_BITFLAGS_NOT"] = "非"
L["CONDITIONPANEL_BITFLAGS_SELECTED"] = "|cff7fffff已选|r:"
L["CONDITIONPANEL_BLIZZEQUIPSET"] = "套装已装备(自带装备管理器)"
L["CONDITIONPANEL_BLIZZEQUIPSET_DESC"] = "检测暴雪自带装备管理器中设置的套装是否已装备。"
L["CONDITIONPANEL_BLIZZEQUIPSET_INPUT"] = "套装名称"
L["CONDITIONPANEL_BLIZZEQUIPSET_INPUT_DESC"] = [=[输入你要检测的暴雪自带装备管理器中的套装名称。

只允许输入一个套装，注意|cFFFF5959区分大小写|r。

译者注：可以从右侧的提示与建议列表中直接选择套装名称。]=]
L["CONDITIONPANEL_CASTCOUNT"] = "法术施放次数"
L["CONDITIONPANEL_CASTCOUNT_DESC"] = "检测一个单位施放某个法术的次数."
L["CONDITIONPANEL_CASTTOMATCH"] = "用于匹配的法术"
L["CONDITIONPANEL_CASTTOMATCH_DESC"] = [=[输入一个法术名称使该条件只在施放的法术名称跟输入的法术名称完全匹配时才可通过.

你可以保留空白来检测任意的法术施放/引导法术(不包括瞬发法术).]=]
L["CONDITIONPANEL_CLASS"] = "单位职业"
L["CONDITIONPANEL_CLASSIFICATION"] = "单位分类"
L["CONDITIONPANEL_CLASSIFICATION_DESC"] = "检测一个单位是否为精英、稀有、世界首领。"
L["CONDITIONPANEL_COMBAT"] = "单位在战斗中"
L["CONDITIONPANEL_COMBO"] = "连击点数"
L["CONDITIONPANEL_COUNTER_DESC"] = "检测“计数器”通知处理所创建和修改的计数器的值。"
L["CONDITIONPANEL_CREATURETYPE"] = "单位生物类型"
L["CONDITIONPANEL_CREATURETYPE_DESC"] = [=[你可以利用分号(;)输入多个生物类型用于匹配.

输入的生物类型必须同鼠标提示信息上所显示的完全相同.

此条件会在输入的任意一个类型与你所检查单位的生物类型相同时通过.]=]
L["CONDITIONPANEL_CREATURETYPE_LABEL"] = "生物类型"
L["CONDITIONPANEL_DBM_ENGAGED"] = "Deadly Boss Mods - 首领战开始"
L["CONDITIONPANEL_DBM_ENGAGED_DESC"] = [=[检测Deadly Boss Mods激活的首领战。

请输入首领战的全名到“用于检测的首领战”。]=]
L["CONDITIONPANEL_DBM_TIMER"] = "Deadly Boss Mods - 计时器"
L["CONDITIONPANEL_DBM_TIMER_DESC"] = [=[检测Deadly Boss Mods计时器的持续时间。

请输入计时器的全名到“用于检测的计时器”。]=]
L["CONDITIONPANEL_DEFAULT"] = "选择条件类型..."
L["CONDITIONPANEL_ECLIPSE_DESC"] = [=[蚀星蔽月的范围是-100(月蚀)到100(日蚀)
如果你想在月蚀能量80時显示图标就輸入-80

说明:蚀星蔽月是台服的翻译,大陆的翻译叫月蚀,这样不容易区分这个月蚀所对应的日蚀/月蚀,所以这里的说明文字直接用台服的翻译.]=]
L["CONDITIONPANEL_EQUALS"] = "等于"
L["CONDITIONPANEL_EXISTS"] = "单位存在"
L["CONDITIONPANEL_GREATER"] = "大于"
L["CONDITIONPANEL_GREATEREQUAL"] = "大于或等于"
L["CONDITIONPANEL_GROUPSIZE"] = "副本人数"
L["CONDITIONPANEL_GROUPSIZE_DESC"] = "检测当前副本设置的人数，也可在检测弹性副本时使用。"
L["CONDITIONPANEL_GROUPTYPE"] = "组队类型"
L["CONDITIONPANEL_GROUPTYPE_DESC"] = "检查你所在的队伍类型(单独,小队或团队)."
L["CONDITIONPANEL_ICON"] = "图标显示"
L["CONDITIONPANEL_ICON_DESC"] = [=[此条件检测指定图标的显示状态或隐藏状态.

如果你不想显示被检测的图标,请在被检测图标的图标编辑器勾选 %q.]=]
L["CONDITIONPANEL_ICON_HIDDEN"] = "隐藏"
L["CONDITIONPANEL_ICON_SHOWN"] = "显示"
L["CONDITIONPANEL_ICONHIDDENTIME"] = "图标隐藏时间"
L["CONDITIONPANEL_ICONHIDDENTIME_DESC"] = [=[此条件检测指定的图标已经隐藏了多久时间.

如果你不想显示被检测的图标,请在被检测图标的图标编辑器勾选 %q.]=]
L["CONDITIONPANEL_ICONSHOWNTIME"] = "图标显示时间"
L["CONDITIONPANEL_ICONSHOWNTIME_DESC"] = [=[此条件检测指定的图标已经显示了多久时间.

如果你不想显示被检测的图标,请在被检测图标的图标编辑器勾选 %q.]=]
L["CONDITIONPANEL_INPETBATTLE"] = "在宠物对战中"
L["CONDITIONPANEL_INSTANCETYPE"] = "副本类型"
L["CONDITIONPANEL_INSTANCETYPE_DESC"] = "检测你所在的地下城的类型。此条件包含任何地下城或团队副本的难度设置。"
L["CONDITIONPANEL_INSTANCETYPE_LEGACY"] = "%s(神话难度)"
L["CONDITIONPANEL_INSTANCETYPE_NONE"] = "野外"
L["CONDITIONPANEL_INTERRUPTIBLE"] = "可打断"
L["CONDITIONPANEL_ITEMRANGE"] = "单位在物品范围内"
L["CONDITIONPANEL_LASTCAST"] = "最后使用的技能"
L["CONDITIONPANEL_LASTCAST_ISNTSPELL"] = "不匹配"
L["CONDITIONPANEL_LASTCAST_ISSPELL"] = "匹配"
L["CONDITIONPANEL_LESS"] = "小于"
L["CONDITIONPANEL_LESSEQUAL"] = "小于或等于"
L["CONDITIONPANEL_LEVEL"] = "单位等级"
L["CONDITIONPANEL_LOC_CONTINENT"] = "大陆"
L["CONDITIONPANEL_LOC_SUBZONE"] = "子地区"
L["CONDITIONPANEL_LOC_SUBZONE_BOXDESC"] = "输入您要检查的子区域。 用分号分隔多个子区域。"
L["CONDITIONPANEL_LOC_SUBZONE_DESC"] = "检查您当前的子区域。 请注意：有时，您可能不在子区域。"
L["CONDITIONPANEL_LOC_SUBZONE_LABEL"] = "输入子区域进行检查"
L["CONDITIONPANEL_LOC_ZONE"] = "地区"
L["CONDITIONPANEL_LOC_ZONE_DESC"] = "输入您要检查的区域。 用分号分隔多个区域。"
L["CONDITIONPANEL_LOC_ZONE_LABEL"] = "输入用于检测的区域"
L["CONDITIONPANEL_MANAUSABLE"] = "法术可用(魔法值/能量/等是否够用.)"
L["CONDITIONPANEL_MANAUSABLE_DESC"] = [=[如果一个法术的可用基于你的主要能量（法力、能量、怒气、符能、集中值等）。

不会再检测基于第二能量的可用性（符文、圣能、真气等）。]=]
L["CONDITIONPANEL_MAX"] = "(最大值)"
L["CONDITIONPANEL_MOUNTED"] = "在坐骑上"
L["CONDITIONPANEL_NAME"] = "单位名字"
L["CONDITIONPANEL_NAMETOMATCH"] = "用于比较的名字"
L["CONDITIONPANEL_NAMETOOLTIP"] = "你可以在每个名字后面加上分号(;)以便输入多个需要比较的名字. 其中任何一个名字相符时此条件都会通过."
L["CONDITIONPANEL_NOTEQUAL"] = "不等于"
L["CONDITIONPANEL_NPCID"] = "单位NPC编号"
L["CONDITIONPANEL_NPCID_DESC"] = [=[检测指定的单位NPC编号.

NPC编号可以在Wowhead之类的魔兽世界数据库找到(例如http://www.wowhead.com/npc=62943).

玩家与某些单位没有NPC编号,在此条件中的返回值为0.]=]
L["CONDITIONPANEL_NPCIDTOMATCH"] = "用于比较的编号"
L["CONDITIONPANEL_NPCIDTOOLTIP"] = "你可以利用分号(;)输入多个NPC编号.条件会在任意一个编号相符时通过."
L["CONDITIONPANEL_OLD"] = "<|cffff1300旧版本|r>"
L["CONDITIONPANEL_OLD_DESC"] = "<|cffff1300旧版本|r> - 此条件有新版本可用。"
L["CONDITIONPANEL_OPERATOR"] = "运算符"
L["CONDITIONPANEL_OR"] = "或者"
L["CONDITIONPANEL_OVERLAYED"] = "法术激活边框"
L["CONDITIONPANEL_OVERLAYED_DESC"] = "检测一个法术是否有激活边框效果（就是在你动作条有黄色的边边的技能）。"
L["CONDITIONPANEL_OVERRBAR"] = "动作条效果"
L["CONDITIONPANEL_OVERRBAR_DESC"] = "检测你主要动作条上的一些动画效果，不包含宠物战斗。"
L["CONDITIONPANEL_PERCENT"] = "(百分比)"
L["CONDITIONPANEL_PERCENTOFCURHP"] = "当前生命值百分比"
L["CONDITIONPANEL_PERCENTOFMAXHP"] = "最大生命百分比"
L["CONDITIONPANEL_PETMODE"] = "宠物攻击模式"
L["CONDITIONPANEL_PETMODE_DESC"] = "检查当前宠物的攻击模式."
L["CONDITIONPANEL_PETMODE_NONE"] = "没有宠物"
L["CONDITIONPANEL_PETSPEC"] = "宠物种类"
L["CONDITIONPANEL_PETSPEC_DESC"] = "检测你当前宠物的专精类型。"
L["CONDITIONPANEL_POWER"] = "基本资源(能量类型)"
L["CONDITIONPANEL_POWER_DESC"] = "如果单位是猫形态的德鲁伊将检测能量值,如果是战士则检测怒气,等等"
L["CONDITIONPANEL_PVPFLAG"] = "单位PVP开启状态"
L["CONDITIONPANEL_RAIDICON"] = "单位团队标记"
L["CONDITIONPANEL_RAIDICON_DESC"] = "检测一个单位的团队标记图标。"
L["CONDITIONPANEL_REMOVE"] = "移除此条件"
L["CONDITIONPANEL_RESTING"] = "休息状态"
L["CONDITIONPANEL_ROLE"] = "单位角色类型"
L["CONDITIONPANEL_ROLE_DESC"] = "检测你队伍、团队中一个玩家所选择的角色类型。"
L["CONDITIONPANEL_RUNES"] = "符文数量"
L["CONDITIONPANEL_RUNES_CHECK_DESC"] = [=[正常情况下,第一行的符文无论是不是死亡符文,在符合条件设置时都会通过.

启用这个选项强制第一行的符文仅匹配非死亡符文.]=]
L["CONDITIONPANEL_RUNES_DESC3"] = "使用此条件仅在特定数量的符文可用时显示图标。"
L["CONDITIONPANEL_RUNESLOCK"] = "符文锁定数量"
L["CONDITIONPANEL_RUNESLOCK_DESC"] = "使用此条件仅在特定数量的符文被锁定时显示图标（等待恢复）。"
L["CONDITIONPANEL_RUNESRECH"] = "恢复中符文数量"
L["CONDITIONPANEL_RUNESRECH_DESC"] = "使用此条件仅在特定数量的符文正在恢复时显示图标。"
L["CONDITIONPANEL_SPELLCOST"] = "施法所需能量"
L["CONDITIONPANEL_SPELLCOST_DESC"] = "检测施法所需能量。像是法力值、怒气、能量等等。"
L["CONDITIONPANEL_SPELLRANGE"] = "单位在法术范围内"
L["CONDITIONPANEL_SWIMMING"] = "在游泳中"
L["CONDITIONPANEL_THREAT_RAW"] = "单位威胁值 - 原始"
L["CONDITIONPANEL_THREAT_RAW_DESC"] = [=[此条件用来检测你对一个单位的原始威胁值百分比.

近战玩家仇恨失控(OT)的威胁值为110%
远程玩家仇恨失控(OT)的威胁值为130%]=]
L["CONDITIONPANEL_THREAT_SCALED"] = "单位威胁值 - 比例"
L["CONDITIONPANEL_THREAT_SCALED_DESC"] = [=[此条件用来检测你对一个单位的威胁值百分比比例.

100%表示你正在坦这个单位.]=]
L["CONDITIONPANEL_TIMER_DESC"] = "检测通知事件“计时器”中的计时器所创建和变更的值。"
L["CONDITIONPANEL_TRACKING"] = "追踪"
L["CONDITIONPANEL_TRACKING_DESC"] = "检测你小地图当前所追踪的类型。"
L["CONDITIONPANEL_TYPE"] = "类型"
L["CONDITIONPANEL_UNIT"] = "单位"
L["CONDITIONPANEL_UNITISUNIT"] = "单位比较"
L["CONDITIONPANEL_UNITISUNIT_DESC"] = "此条件在两个文本框输入的单位为同一角色时通过.(例子:文本框1为'targettarget',文本框2为'player',当'目标的目标'为'玩家'时则此条件通过. )"
L["CONDITIONPANEL_UNITISUNIT_EBDESC"] = "在此文本框输入需要与所指定的第一单位进行比较的第二单位."
L["CONDITIONPANEL_UNITRACE"] = "单位种族"
L["CONDITIONPANEL_UNITSPEC"] = "单位专精"
L["CONDITIONPANEL_UNITSPEC_CHOOSEMENU"] = "选择专精..."
L["CONDITIONPANEL_UNITSPEC_DESC"] = "此条件仅可用于战场跟竞技场。"
L["CONDITIONPANEL_VALUEN"] = "取值"
L["CONDITIONPANEL_VEHICLE"] = "单位控制载具"
L["CONDITIONPANEL_ZONEPVP"] = "区域PvP类型"
L["CONDITIONPANEL_ZONEPVP_DESC"] = "检测区域的PvP类型（例如：争夺中、圣域、战斗区域等）"
L["CONDITIONPANEL_ZONEPVP_FFA"] = "自由PVP"
L["CONDITIONS"] = "条件"
L["CONFIGMODE"] = "TellMeWhen正处于设置模式. 在离开设置模式之前,图标无法正常使用. 输入'/tellmewhen'或'/tmw'可以开启或关闭设置模式."
L["CONFIGMODE_EXIT"] = "退出设置模式"
L["CONFIGMODE_EXITED"] = "TMW已锁定。输入/tmw重新进入设置模式。"
L["CONFIGMODE_NEVERSHOW"] = "不再显示此信息"
L["CONFIGPANEL_BACKDROP_HEADER"] = "背景材质"
L["CONFIGPANEL_CBAR_HEADER"] = "计时条覆盖"
L["CONFIGPANEL_CLEU_HEADER"] = "战斗事件"
L["CONFIGPANEL_CNDTTIMERS_HEADER"] = "条件计时器"
L["CONFIGPANEL_COMM_HEADER"] = "通讯"
L["CONFIGPANEL_MEDIA_HEADER"] = "媒体"
L["CONFIGPANEL_PBAR_HEADER"] = "能量条覆盖"
L["CONFIGPANEL_TIMER_HEADER"] = "计时器时钟"
L["CONFIGPANEL_TIMERBAR_BARDISPLAY_HEADER"] = "计时条"
L["CONFIRM_DELETE_GENERIC_DESC"] = "%s 将被删除."
L["CONFIRM_DELGROUP"] = "删除分组"
L["CONFIRM_DELLAYOUT"] = "删除样式"
L["CONFIRM_HEADER"] = "确定？"
L["COPYGROUP"] = "复制分组"
L["COPYPOSSCALE"] = "仅复制位置/比例"
L["CrowdControl"] = "控场技能"
L["Curse"] = "诅咒"
L["DamageBuffs"] = "信春哥(伤害性增益)"
L["DamageShield"] = "伤害护盾"
L["DBRESTORED_INFO"] = [=[TellMeWhen检测到数据库为空或者已损坏。 造成这个最可能的原因是WoW没有正常退出。

TellMeWhen_Options对数据库多备份了一次，以防止这样的情况发生，因为很少会出现TellMeWhen和TellMeWhen_Options的数据库同时损坏。

你这个创建于%s的备份已还原。]=]
L["DEBUFFTOCHECK"] = "要检测的减益"
L["DEBUFFTOCOMP1"] = "进行比较的第一个减益"
L["DEBUFFTOCOMP2"] = "进行比较的第二个减益"
L["DEFAULT"] = "默认值"
L["DefensiveBuffs"] = "信春哥(防御性增益)"
L["DefensiveBuffsAOE"] = "AOE 减伤 Buffs"
L["DefensiveBuffsSingle"] = "单体减伤 Buffs"
L["DESCENDING"] = "降序"
L["DISABLED"] = "已停用"
L["Disease"] = "疾病"
L["Disoriented"] = "被魅惑"
L["DOMAIN_GLOBAL"] = "|cff00c300共用|r"
L["DOMAIN_PROFILE"] = "角色配置"
L["DOWN"] = "下"
L["DR-Disorient"] = "迷惑/其他"
L["DR-Incapacitate"] = "瘫痪"
L["DR-Root"] = "定身"
L["DR-Silence"] = "沉默"
L["DR-Stun"] = "击晕"
L["DR-Taunt"] = "嘲讽"
L["DT_DOC_AuraSource"] = "返回图标检测的增益/减益的来源单位。最好同[Name]标签一起使用。(此标签仅能用于图标类型：%s)。"
L["DT_DOC_Counter"] = "返回TellMeWhen计数器的值。图标通知消息会创建或修改计数器。"
L["DT_DOC_Destination"] = "返回图标最后一次处理的战斗事件中的目标单位或名称.和[Name]标签一起使用效果更佳.(此标签仅可用于图标类型%s)"
L["DT_DOC_Duration"] = "返回图标当前的剩余持续时间.推荐你使用[TMWFormatDuration]."
L["DT_DOC_Extra"] = "返回图标最后一次处理过的战斗事件中的额外法术名称.（此标签仅可用于图标类型%s）"
L["DT_DOC_gsub"] = [=[提供给力的Lua函数string.gsub来处理DogTags输出的字符串。

替换当前值在匹配模式中的所有实例，可使用可选参数限制替换数目。]=]
L["DT_DOC_IsShown"] = "返回一个图标是否显示."
L["DT_DOC_LocType"] = "返回图标所显示的失去控制的效果类型.(此标签仅可用于图标类型%s)"
L["DT_DOC_MaxDuration"] = "返回当前图标的最大持续时间。 这个持续时间是指刚开始时的持续时间，不是当前剩余的持续时间。"
L["DT_DOC_Name"] = "返回单位的名称.这是一个由DogTag提供的默认[Name]标签的加强版本."
L["DT_DOC_Opacity"] = "返回一个图标的不透明度. 返回值为0到1之间的数字."
L["DT_DOC_PreviousUnit"] = "返回图标检测过的上一个单位或单位名称(相对于与当前检查单位来讲).和[Name]标签一起使用效果更佳."
L["DT_DOC_Source"] = "返回图标最后一次处理过的战斗事件中的来源单位或名称.和[Name]标签一起使用效果更佳.(此标签仅可用于图标类型%s)"
L["DT_DOC_Spell"] = "返回图标当前显示数据的物品名称或法术名称."
L["DT_DOC_Stacks"] = "返回图标当前的叠加数量"
L["DT_DOC_strfind"] = [=[提供给力的Lua函数string.find来处理DogTags输出的字符串。

返回当前值中从第几位开始出现的第一次匹配的具体位置。]=]
L["DT_DOC_StripServer"] = "从单位名字移除服务器名称。这将会移除名字的破折号之后的所有文字。"
L["DT_DOC_Timer"] = "返回TellMeWhen计时器的值。计时器一般在图标的通知事件中被创建或更改。"
L["DT_DOC_TMWFormatDuration"] = "返回一个由TellMeWhen的时间格式处理过的字符串​​.用于替代[FormatDuration]."
L["DT_DOC_Unit"] = "返回当前图标所检查的单位或单位名称.同[Name]标签一起使用效果更佳."
L["DT_DOC_Value"] = "返回图标当前显示的数字，此功能仅在小部分图标类型使用。"
L["DT_DOC_ValueMax"] = "返回图标当前显示的数字的初始最大值，此功能仅在小部分图标类型使用。"
L["DT_INSERTGUID_GENERIC_DESC"] = "如果你想要在一个图标上显示另外一个图标的信息，可以 |cff7fffffShift+鼠标点击|r那个图标將它的唯一标识符添加到标签参数icon中即可。"
L["DT_INSERTGUID_TOOLTIP"] = "|cff7fffffShift+鼠标点击|r将这个图标的标识符插入到DogTag。"
L["DURATION"] = "持续时间"
L["DURATIONALPHA_DESC"] = [=[设置在你要求的持续时间不符合时图标显示的不透明度.

此选项会在勾选%s时自动忽略。]=]
L["DURATIONPANEL_TITLE2"] = "持续时间限制"
L["EARTH"] = "大地图腾"
L["ECLIPSE_DIRECTION"] = "月蚀方向"
L["elite"] = "精英"
L["ENABLINGOPT"] = "TellMeWhen设置已禁用.重新启用中...."
L["ENCOUNTERTOCHECK"] = "用于检测的首领战"
L["ENCOUNTERTOCHECK_DESC_BIGWIGS"] = "输入首领战的全名。在BigWig的设置跟地下城手册中都有显示。"
L["ENCOUNTERTOCHECK_DESC_DBM"] = "输入首领战的全名。在聊天的拉怪、灭团、杀死或者在地下城手册中有显示。"
L["Enraged"] = "激怒"
L["EQUIPSETTOCHECK"] = "用于检测的套装名称(|cFFFF5959区分大小写|r)"
L["ERROR_ACTION_DENIED_IN_LOCKDOWN"] = "无法在战斗中这么做,请先启用%q选项(输入'/tmw options'或'/tmw 选项')."
L["ERROR_ANCHOR_CYCLICALDEPS"] = "%s尝试依附到%s，但是%s的位置依赖于%s的位置，为了防止出错TellMeWhen会将它重置到屏幕的中央。"
L["ERROR_ANCHORSELF"] = "%s尝试附着于它自己, 所以TellMeWhen会重置它的附着位置到屏幕中间以防止出现严重的错误."
L["ERROR_INVALID_SPELLID2"] = "一个图标正在检测一个无效的法术ID: %s. 为免图标发生错误,请移除它!"
L["ERROR_MISSINGFILE"] = "TellMeWhen需要在重开魔兽世界之后才能正常使用%s (原因:无法找到 %s ). 你要马上重开魔兽世界吗?"
L["ERROR_MISSINGFILE_NOREQ"] = "TellMeWhen需要在重开魔兽世界之后才能完全正常使用%s (原因:无法找到 %s ). 你要马上重开魔兽世界吗?"
L["ERROR_MISSINGFILE_OPT"] = [=[需要在重开魔兽世界之后才能设置TellMeWhen %s。

原因：无法找到%s。

你要马上重开魔兽世界吗？ ]=]
L["ERROR_MISSINGFILE_OPT_NOREQ"] = [=[可能需要在重开魔兽世界之后才能全面设置TellMeWhen %s。

原因：无法找到%s。

你要马上重开魔兽世界吗？ ]=]
L["ERROR_MISSINGFILE_REQFILE"] = "一个必需的文件"
L["ERROR_NO_LOCKTOGGLE_IN_LOCKDOWN"] = "无法在战斗中解锁TellMeWhen,请先启用%q选项(输入'/tmw options'或'/tmw 选项')."
L["ERROR_NOTINITIALIZED_NO_ACTION"] = "插件初始化失败,TellMeWhen不能执行该步骤."
L["ERROR_NOTINITIALIZED_NO_LOAD"] = "插件初始化失败,TellMeWhen_Options无法加载."
L["ERROR_NOTINITIALIZED_OPT_NO_ACTION"] = "如果插件初始化失败，TellMeWhen_Options将无法执行该动作！"
L["ERRORS_FRAME"] = "错误框架"
L["ERRORS_FRAME_DESC"] = "输出文字到系统的错误框架,就是显示%q那个位置."
L["EVENT_CATEGORY_CHANGED"] = "数据已改变"
L["EVENT_CATEGORY_CHARGES"] = "充能"
L["EVENT_CATEGORY_CLICK"] = "交互"
L["EVENT_CATEGORY_CONDITION"] = "条件"
L["EVENT_CATEGORY_MISC"] = "其他"
L["EVENT_CATEGORY_STACKS"] = "叠加层数"
L["EVENT_CATEGORY_TIMER"] = "计时器"
L["EVENT_CATEGORY_VISIBILITY"] = "显示方式"
L["EVENT_FREQUENCY"] = "触发频率"
L["EVENT_FREQUENCY_DESC"] = "设置条件通过的触发频率（单位为秒）。"
L["EVENT_WHILECONDITIONS"] = "触发条件"
L["EVENT_WHILECONDITIONS_DESC"] = "点击设置条件，当它们通过时会触发通知事件。"
L["EVENT_WHILECONDITIONS_TAB_DESC"] = "设置触发通知事件需要的条件。"
L["EVENTCONDITIONS"] = "事件条件"
L["EVENTCONDITIONS_DESC"] = "点击进入设置用于触发此事件的条件."
L["EVENTCONDITIONS_TAB_DESC"] = "设置的条件通过时则触发此事件."
L["EVENTHANDLER_COUNTER_TAB"] = "计数器"
L["EVENTHANDLER_COUNTER_TAB_DESC"] = "配置一个计数器。此计数器可用于条件中检测或DogTags标签中显示文字。"
L["EVENTHANDLER_LUA_CODE"] = "用于执行的Lua代码"
L["EVENTHANDLER_LUA_CODE_DESC"] = "在此输入事件触发后需要执行的Lua代码."
L["EVENTHANDLER_LUA_LUA"] = "Lua"
L["EVENTHANDLER_LUA_LUAEVENTf"] = "Lua事件: %s"
L["EVENTHANDLER_LUA_TAB"] = "Lua(高玩级)"
L["EVENTHANDLER_LUA_TAB_DESC"] = "设置用于执行的Lua脚本。这是一个高端的功能，需要有Lua语言编程基础。"
L["EVENTHANDLER_TIMER_TAB"] = "计时器"
L["EVENTHANDLER_TIMER_TAB_DESC"] = "设置一个时钟样式的计时器。此计时器可以使用条件及显示文字到DogTags。"
L["EVENTS_CHANGETRIGGER"] = "更改触发器"
L["EVENTS_CHOOSE_EVENT"] = "选择触发器："
L["EVENTS_CHOOSE_HANDLER"] = "选择通知事件："
L["EVENTS_CLONEHANDLER"] = "克隆"
L["EVENTS_HANDLER_ADD_DESC"] = "|cff7fffff点击|r添加这个通知事件。"
L["EVENTS_HANDLERS_ADD"] = "添加通知事件..."
L["EVENTS_HANDLERS_ADD_DESC"] = "|cff7fffff点击|r选择一个通知事件添加到此图标,"
L["EVENTS_HANDLERS_GLOBAL_DESC"] = [=[|cff7fffff点击|r打开通知事件选项.
|cff7fffff右键点击|r克隆或更改事件的触发.
|cff7fffff点击并拖拽|r来更改排序.]=]
L["EVENTS_HANDLERS_HEADER"] = "通知事件处理器"
L["EVENTS_HANDLERS_PLAY"] = "测试通知事件"
L["EVENTS_HANDLERS_PLAY_DESC"] = "|cff7fffff点击|r测试通知事件"
L["EVENTS_SETTINGS_CNDTJUSTPASSED"] = "仅在条件刚通过时"
L["EVENTS_SETTINGS_CNDTJUSTPASSED_DESC"] = "除非上面设置的条件刚刚成功通过,否则阻止通知事件的触发."
L["EVENTS_SETTINGS_COUNTER_AMOUNT"] = "值"
L["EVENTS_SETTINGS_COUNTER_AMOUNT_DESC"] = "输入你想要检测的计数器被创建或修改的值。"
L["EVENTS_SETTINGS_COUNTER_HEADER"] = "计数器设置"
L["EVENTS_SETTINGS_COUNTER_NAME"] = "计数器名称"
L["EVENTS_SETTINGS_COUNTER_NAME_DESC"] = [=[输入计数器的名称。如果计数器不存在，它的初始值则为0。

计数器名称必须为小写，并且不能有空格。

你也可以在其它地方检测这个计数器,在条件检测或DogTags的文字显示标签[Counter]中。

高玩用户：计数器储存在TMW.COUNTERS[counterName] = value中。如果你想在自定义Lua语言脚本中更改一个计数器可调用 TMW:Fire( "TMW_COUNTER_MODIFIED", counterName )。]=]
L["EVENTS_SETTINGS_COUNTER_OP"] = "运算符"
L["EVENTS_SETTINGS_COUNTER_OP_DESC"] = "选择计数器要执行的运算符"
L["EVENTS_SETTINGS_HEADER"] = "触发设置"
L["EVENTS_SETTINGS_ONLYSHOWN"] = "仅在图标显示时触发"
L["EVENTS_SETTINGS_ONLYSHOWN_DESC"] = "勾选此项防止图标在没有显示时触发相关通知事件."
L["EVENTS_SETTINGS_PASSINGCNDT"] = "仅在条件通过时触发:"
L["EVENTS_SETTINGS_PASSINGCNDT_DESC"] = "除非下面设置的条件成功通过,否则阻止通知事件的触发."
L["EVENTS_SETTINGS_PASSTHROUGH"] = "允许触发其他事件"
L["EVENTS_SETTINGS_PASSTHROUGH_DESC"] = [=[勾选允许在触发该通知事件后去触发另一个事件,如果不勾选,则在该事件触发并输出了文字/音效之后,图标将不再处理同时触发的其他任何通知事件.

可以有例外,详情请参阅个别事件的描述.]=]
L["EVENTS_SETTINGS_SIMPLYSHOWN"] = "仅在图标显示时触发"
L["EVENTS_SETTINGS_SIMPLYSHOWN_DESC"] = [=[让通知事件在图标显示时触发。

你可以在不设置条件的情况下启用此选项来触发事件。

或者你也可以加上条件来决定如何触发。]=]
L["EVENTS_SETTINGS_TIMER_HEADER"] = "计时器设置"
L["EVENTS_SETTINGS_TIMER_NAME"] = "计时器名称"
L["EVENTS_SETTINGS_TIMER_NAME_DESC"] = [=[输入你需要修改的计时器名称。

计时器名称必须为小写字母并且不能有空格。

此计时器使用的名称可以在其它任何地方来检测（条件和文本显示，像是DogTag中的[Timer]）]=]
L["EVENTS_SETTINGS_TIMER_OP_DESC"] = "选择你想要计时器使用的运算符"
L["EVENTS_TAB"] = "通知事件"
L["EVENTS_TAB_DESC"] = "设置声音/文字输出/动画的触发器."
L["EXPORT_ALLGLOBALGROUPS"] = "所有|cff00c300共用|r分组"
L["EXPORT_f"] = "导出 %s"
L["EXPORT_HEADING"] = "导出"
L["EXPORT_SPECIALDESC2"] = "其他TellMeWhen使用者只能在他们所使用的版本高于或等于%s时才能导入这些数据."
L["EXPORT_TOCOMM"] = "到玩家"
L["EXPORT_TOCOMM_DESC"] = [=[输入一个玩家的名字到编辑框同时选择此选项来发送数据给他们.他们必须是你能密语的某人(同阵营,同服务器,在线),同时他们必须已经安装版本为4.0.0+的TellMeWhen.

你还可以输入"GUILD"或"RAID"发送到整个公会或整个团队(输入时请注意区分大小写,'GUILD'跟'RAID'中的英文字母全部都是大写).]=]
L["EXPORT_TOGUILD"] = "到公会"
L["EXPORT_TORAID"] = "到团队"
L["EXPORT_TOSTRING"] = "到字符串"
L["EXPORT_TOSTRING_DESC"] = "包含必要数据的字符串将导出到编辑框里,按下CTRL+C复制它,然后到任何你想分享的地方贴上它."
L["FALSE"] = "否"
L["fCODESNIPPET"] = "代码片段: %s"
L["Feared"] = "被恐惧"
L["fGROUP"] = "分组: %s"
L["fGROUPS"] = "分组：%s"
L["fICON"] = "图标: %s"
L["FIRE"] = "火焰图腾"
L["FONTCOLOR"] = "文字颜色"
L["FONTSIZE"] = "字体大小"
L["FORWARDS_IE"] = "转到下一个"
L["FORWARDS_IE_DESC"] = [=[载入下一个编辑过的图标

%s |T%s:0|t]=]
L["fPROFILE"] = "配置文件: %s"
L["FROMNEWERVERSION"] = "你导入的数据为版本较新的TellMeWhen所创建,某些设置在更新至最新版本之前可能无法正常使用."
L["fTEXTLAYOUT"] = "文字显示样式: %s"
L["GCD"] = "公共冷却"
L["GCD_ACTIVE"] = "公共冷却作用中"
L["GENERIC_NUMREQ_CHECK_DESC"] = "勾选以启用并配置%s"
L["GENERICTOTEM"] = "图腾 %d"
L["GLOBAL_GROUP_GENERIC_DESC"] = "|cff00c300共用分组|r是指在你这个魔兽世界帐号中的TellMeWhen配置文件的所有角色都可共同使用的分组。"
L["GLYPHTOCHECK"] = "要检测的雕文"
L["GROUP"] = "分组"
L["GROUP_UNAVAILABLE"] = "|TInterface/PaperDollInfoFrame/UI-GearManager-LeaveItem-Transparent:20|t 由于其过度限制的规范/角色设置，此组无法显示。"
L["GROUPCONDITIONS"] = "分组条件"
L["GROUPCONDITIONS_DESC"] = "设置条件进行微调,以便更好的显示这个分组."
L["GROUPICON"] = "分组:%s ，图标:%s"
L["GROUPSELECT_TOOLTIP"] = [=[|cff7fffff点击|r 来编辑。

|cff7fffff点击拖拽|r 重新排序或更改域。]=]
L["GROUPSETTINGS_DESC"] = "设置此分组。"
L["GUIDCONFLICT_DESC_PART1"] = [=[TellMeWhen检测到下列的对象拥有相同的全局唯一标识符（GUID）。如果你从它们其中之一调用数据可能会发生料想不到问题（例如：将它们之中的一个加入到整合图标中）。

为了解决这个问题，请选择某个对象重新生成GUID，原有的调用都将指向到那个你没有重新生成GUID的对象。你可能需要适当调整你的设置确保所有东西都能正常使用。]=]
L["GUIDCONFLICT_DESC_PART2"] = "你也可以自行解决这个问题（例如：删除两个之中的某一个）。"
L["GUIDCONFLICT_IGNOREFORSESSION"] = "忽略该设置进程冲突。"
L["GUIDCONFLICT_REGENERATE"] = "为%s重新生成GUID"
L["Heals"] = "玩家治疗法术"
L["HELP_ANN_LINK_INSERTED"] = [=[你插入的链接看起来很诡异,可能是因为DogTag的格式转换所引起.

如果输出到暴雪频道时链接无法正常显示,请更改颜色代码.]=]
L["HELP_BUFF_NOSOURCERPPM"] = [=[看来你想检测%s，这个增益使用了RPPM系统。

由于暴雪的bug，在启用了%q选项时，这个增益无法被检测。

如果你想正确检测这个增益，请禁用该设置。]=]
L["HELP_CNDT_ANDOR_FIRSTSEE"] = [=[你可以选择两个条件都需要通过,还是只需要某个条件通过.

|cff7fffff点击|r此处更改条件之间的关联方式,以达到你所需的检测效果.]=]
L["HELP_CNDT_PARENTHESES_FIRSTSEE"] = [=[你可以组合多个条件执行复杂的检测功能,尤其是连同%q选项一起使用.

|cff7fffff点击|r括号将条件组合在一起,以达到你需要的检测效果(左右括号中间的条件就是一个条件组合).]=]
L["HELP_COOLDOWN_VOIDBOLT"] = [=[看起来你是想检测|TInterface/Icons/ability_ironmaidens_convulsiveshadows:20|t %s的冷却时间。

非常不幸的是暴雪的机制使它无法正常被监测到。

你需要检测的是 |T1386548:20|t %s 的冷却时间。

请添加一个条件检测增益 %s ，如果你仅仅是想检测 %s 是否可以使用的话。]=]
L["HELP_EXPORT_DOCOPY_MAC"] = "按下|cff7fffffCMD+C|r复制"
L["HELP_EXPORT_DOCOPY_WIN"] = "按下|cff7fffffCTRL+C|r复制"
L["HELP_EXPORT_MULTIPLE_COMM"] = "导出的数据包括主要数据所需要的额外数据。想要知道包含了哪些内容，请导出相同数据到字符串后在导入菜单的“来自字符串”查看即可。"
L["HELP_EXPORT_MULTIPLE_STRING"] = [=[导出的数据包括主要数据所需要的额外数据。想要知道包含了哪些内容，请导出相同数据到字符串后在导入菜单的“来自字符串”查看即可。

TellMeWhen版本7.0.0+的使用者可以一次导入所有数据。其他人需要分开多次导入字符串。]=]
L["HELP_FIRSTUCD"] = [=[这是你第一次使用一个采取特定时间语法的图标类型!
在添加法术到某些图标类型的 %q 编辑框时,必须使用下列语法在法术后面指定它们的冷却时间/持续时间:

法术:时间

例如:

"%s: 120"
"%s: 10;%s: 24"
"%s: 180"
"%s: 3:00"
"62618: 3:00"

用建议列表插入条目时会自动添加在鼠标提示信息中显示的时间(译者注:自动添加时间功能支持提示信息中有显示冷却时间的法术以及提示信息中有注明持续时间的大部分法术,如果一个法术同时存在上述两种时间,会优先选择添加冷却时间,假如自动添加的时间不正确,请自行手动更改).]=]
L["HELP_IMPORT_CURRENTPROFILE"] = [=[尝试在这个配置文件中移动或复制一个图标到另外一个图标栏位吗?

你可以轻松的做到这一点,使用|cff7fffff鼠标右键点击图标并拖拽|r它到另外一个图标栏位(这个过程需要按下鼠标右键不放开). 当你放开鼠标右键时,会出现一个有很多选项的选单.

尝试拖拽一个图标到整合图标,其他分组,或在你屏幕上的其他框架以获取其他相应的选项.]=]
L["HELP_MISSINGDURS"] = [=[以下法术缺少持续时间/冷却时间:

%s

请使用下列语法添加时间:

法术:时间

例如"%s: 10"

用建议列表插入条目时会自动添加在鼠标提示信息中显示的时间(译者注:自动添加时间功能支持提示信息中有显示冷却时间的法术以及提示信息中有注明持续时间的大部分法术,如果一个法术同时存在上述两种时间,会优先选择添加冷却时间,假如自动添加的时间不正确,请自行手动更改).]=]
L["HELP_NOUNIT"] = "你必须输入一个单位!"
L["HELP_NOUNITS"] = "你至少需要输入一个单位!"
L["HELP_ONLYONEUNIT"] = "条件只允许检测一个单位，你已经输入了%d个单位。"
L["HELP_POCKETWATCH"] = [=[|TInterface\Icons\INV_Misc_PocketWatch_01:20|t -- 关于怀表材质

此材质用于第一个检测到的有效法术在你的法术书中不存在时.

正确的材质将会在你施放过一次或者见到过一次该法术之后使用.

若要显示正确的材质,请把第一个被检测的法术名称更改为法术ID.你可以轻松的做到这一点,你只需要点击名称编辑框中的法术,再根据之后出现的建议列表中显示的正确的以及相对应的法术上点击鼠标右键即可.

(这里的法术指排在首位的法术,当你的鼠标移动到建议列表的某个法术上时,在提示信息中可以看到更为具体的鼠标左右键插入法术ID或法术名称的方法.)]=]
L["HELP_SCROLLBAR_DROPDOWN"] = [=[一些TellMeWhen的下拉菜单有滚动条。

你可以拖动滚动条来查看菜单的全部内容。

你也可以使用鼠标滚轮。]=]
L["ICON"] = "图标"
L["ICON_TOOLTIP_CONTROLLED"] = "此图标被这分组的第一个图标接管。你不能单独修改它。"
L["ICON_TOOLTIP_CONTROLLER"] = "此图标具有分组控制功能。"
L["ICON_TOOLTIP2NEW"] = [=[|cff7fffff点击鼠标右键|r进入图标设置.
|cff7fffff点击鼠标右键并拖拽|r 移动/复制 到另一个图标.
|cff7fffff拖拽|r法术或者物品到图标上进行快速设置.]=]
L["ICON_TOOLTIP2NEWSHORT"] = "|cff7fffff点击鼠标右键|r进入图标设置."
L["ICONALPHAPANEL_FAKEHIDDEN"] = "始终隐藏"
L["ICONALPHAPANEL_FAKEHIDDEN_DESC"] = [=[使该图标一直被隐藏,但图标依然会处理并执行音效和文字输出,而且仍然可以让包含该图标的条件或者整合图标进行检测.

|cff7fffff-|r此图标能一直检测其他图标的条件。
|cff7fffff-|r 整合图标能显示这个图标。
|cff7fffff-|r 此图标的通知事件会继续处理运行。]=]
L["ICONCONDITIONS_DESC"] = "设置条件进行微调,以便更好的显示图标."
L["ICONGROUP"] = "图标: %s (分组: %s)"
L["ICONMENU_ABSENT"] = "不存在"
L["ICONMENU_ABSENTEACH"] = "没有施法的单位"
L["ICONMENU_ABSENTEACH_DESC"] = [=[设置单位没有任何施法时的图标透明度。

如果此选项未设置成隐藏并且检测到有一个单位存在时，%s选项不会运作。]=]
L["ICONMENU_ABSENTONALL"] = "全都缺少"
L["ICONMENU_ABSENTONALL_DESC"] = "设置在检测的所有单位中不存在任何一个用于检测的增益/减益时的图标透明度."
L["ICONMENU_ABSENTONANY"] = "任一缺少"
L["ICONMENU_ABSENTONANY_DESC"] = "设置在检测的所有单位中只要其中之一不存在任何一个用于检测的增益/减益时的图标透明度."
L["ICONMENU_ADDMETA"] = "添加到'整合图标'"
L["ICONMENU_ALLOWGCD"] = "允许公共冷却"
L["ICONMENU_ALLOWGCD_DESC"] = "勾选此项允许冷却时钟显示公共冷却,而不是忽略它."
L["ICONMENU_ALLSPELLS"] = "所有法术技能可用"
L["ICONMENU_ALLSPELLS_DESC"] = "当此图标正在跟踪的所有法术准备好在特定单位上时，此状态处于活动状态。"
L["ICONMENU_ANCHORTO"] = "附着到 %s"
L["ICONMENU_ANCHORTO_DESC"] = [=[附着%s到%s,无论%s如何移动,%s都会跟随它一起移动.

分组选项中有更为详细的附着设置.]=]
L["ICONMENU_ANCHORTO_UIPARENT"] = "重置附着"
L["ICONMENU_ANCHORTO_UIPARENT_DESC"] = [=[让%s重新附着到你的屏幕(UIParent).它目前附着到%s.

分组选项中有更为详细的附着设置.

分组选项中有更为详细的附着设置.]=]
L["ICONMENU_ANYSPELLS"] = "任意法术技能可用"
L["ICONMENU_ANYSPELLS_DESC"] = "当被该图标跟踪的法术中的至少一个准备好在特定单元上时，该状态是活动的。"
L["ICONMENU_APPENDCONDT"] = "添加到'图标显示'条件"
L["ICONMENU_BAR_COLOR_BACKDROP"] = "背景颜色/透明度"
L["ICONMENU_BAR_COLOR_BACKDROP_DESC"] = "设置计量条后的背景颜色和透明度。"
L["ICONMENU_BAR_COLOR_COMPLETE"] = "完成颜色"
L["ICONMENU_BAR_COLOR_COMPLETE_DESC"] = "计量条在冷却、持续时间完成时的颜色。"
L["ICONMENU_BAR_COLOR_MIDDLE"] = "过半颜色"
L["ICONMENU_BAR_COLOR_MIDDLE_DESC"] = "计量条在冷却、持续时间过半时的颜色。"
L["ICONMENU_BAR_COLOR_START"] = "起始颜色"
L["ICONMENU_BAR_COLOR_START_DESC"] = "计量条在冷却、持续时间起始时的颜色。"
L["ICONMENU_BAROFFS"] = [=[此数值将会添加到计量条以便用来调整它的偏移值.

一些有用的例子:
当你开始施法时防止一个增益消失的自订指示器,或者用来指示某个法术施放所需能量的同时还剩多少时间可以打断施法.]=]
L["ICONMENU_BOTH"] = "任意一种"
L["ICONMENU_BUFF"] = "增益"
L["ICONMENU_BUFFCHECK"] = "增益/减益检测"
L["ICONMENU_BUFFCHECK_DESC"] = [=[检测你所设置的单位是否缺少某个增益.

可使用这个图标类型来检测缺少的团队增益(像是耐力之类).

其他情况应使用图标类型%q.]=]
L["ICONMENU_BUFFDEBUFF"] = "增益/减益"
L["ICONMENU_BUFFDEBUFF_DESC"] = "检测增益或减益."
L["ICONMENU_BUFFTYPE"] = "增益或减益"
L["ICONMENU_CAST"] = "法术施放"
L["ICONMENU_CAST_DESC"] = "检测非瞬发施法跟引导法术."
L["ICONMENU_CHECKNEXT"] = "扩展子元"
L["ICONMENU_CHECKNEXT_DESC"] = [=[选中此框该图标将检测添加在列表中的任意整合图标所包含的全部图标,它可能是任何级别的检测.

此外,该图标不会显示已经在另一个整合图标显示的任何图标.

译者注:因为很多人不明白这个功能,举个例子,假设你有3个设置完全一样的整合图标(每个图标中都是图标1 图标2 图标3),全部都勾上了这个选项,如果在整合图标中图标1 图标2 图标3都可以显示,显示顺序为图标3>图标1>图标2,那么在整合图标1将会显示图标3,整合图标2则是显示图标1,整合图标3显示图标2(理论上就是这样的效果,一些细节请自行钻研).]=]
L["ICONMENU_CHECKREFRESH"] = "法术刷新侦测"
L["ICONMENU_CHECKREFRESH_DESC"] = [=[暴雪的战斗记录在涉及法术刷新和恐惧（或者某些在造成一定伤害量后才会中断的法术）存在严重缺陷，战斗记录会认为法术在造成伤害时已经刷新，尽管事实上并非如此。

取消此选项以便停用法术刷新侦测，注意：正常的刷新也将被忽略。

如果你检测的递减在造成一定伤害量后不会中断的话建议保留此选项。]=]
L["ICONMENU_CHOOSENAME_EVENTS"] = "选择用于检测的消息"
L["ICONMENU_CHOOSENAME_EVENTS_DESC"] = [=[输入你想要图标检测的错误消息。你可以利用';'(分号)输入多个条目。

错误信息必须完全匹配，不区分大小写。]=]
L["ICONMENU_CHOOSENAME_ITEMSLOT_DESC"] = [=[输入你想要此图标监视的 名称/ID/装备栏编号. 你可以利用分号添加多个条目(名称/ID/装备栏编号的任意组合).

装备栏编号是已装备物品所在栏位的编号索引.即使你更换了那个装备栏的已装备物品,也不会影响图标的正常使用.

你可以|cff7fffff按住Shift再按鼠标左键点选|r物品/聊天连结 或者拖曳物品添加此编辑框中.]=]
L["ICONMENU_CHOOSENAME_ORBLANK"] = "或者保留空白检测所有"
L["ICONMENU_CHOOSENAME_WPNENCH_DESC"] = [=[输入你想要此图标监视的暂时性武器附魔的名称. 你可以利用分号(;)添加多个条目.

|cFFFF5959重要提示|r: 附魔名称必须使用在暂时性武器附魔激活时出现在武器的提示信息中的那个名称(例如:"%s", 而不是"%s").

译者注:大陆版魔兽世界中的部分标点符号用的是全角标点,在这里需要使用的就是全角括号.]=]
L["ICONMENU_CHOOSENAME3"] = "监视什么"
L["ICONMENU_CHOSEICONTODRAGTO"] = "选择一个图标拖拽到："
L["ICONMENU_CHOSEICONTOEDIT"] = "选择一个图标来修改:"
L["ICONMENU_CLEU"] = "战斗事件"
L["ICONMENU_CLEU_DESC"] = [=[检测战斗事件.

包括了像是法术反射,未命中,瞬发施法以及死亡等等. 
实际上图标能检测所有的战斗事件(包括上述的例子以及其他没有提到的战斗事件).]=]
L["ICONMENU_CLEU_NOREFRESH"] = "不刷新"
L["ICONMENU_CLEU_NOREFRESH_DESC"] = "勾选后在图标的计时器作用时不会再触发事件."
L["ICONMENU_CNDTIC"] = "条件图标"
L["ICONMENU_CNDTIC_DESC"] = "检测条件的状态."
L["ICONMENU_CNDTIC_ICONMENUTOOLTIP"] = "(%d个条件)"
L["ICONMENU_COMPONENTICONS"] = "组件图标&分组"
L["ICONMENU_COOLDOWNCHECK"] = "冷却检测"
L["ICONMENU_COOLDOWNCHECK_DESC"] = "勾选此项启用当可用技能在冷却中时视为不可用."
L["ICONMENU_COPYCONDITIONS"] = "复制 %d 个条件"
L["ICONMENU_COPYCONDITIONS_DESC"] = "复制%s的%d个条件到%s。"
L["ICONMENU_COPYCONDITIONS_DESC_OVERWRITE"] = "这将会覆盖已存在的%d个的条件。"
L["ICONMENU_COPYCONDITIONS_GROUP"] = "复制%d个分组条件"
L["ICONMENU_COPYEVENTHANDLERS"] = "复制 %d 个通知事件"
L["ICONMENU_COPYEVENTHANDLERS_DESC"] = "复制%s的%d个通知事件到%s。"
L["ICONMENU_COPYHERE"] = "复制到此"
L["ICONMENU_COUNTING"] = "倒数中"
L["ICONMENU_CTRLGROUP"] = "分组控制图标"
L["ICONMENU_CTRLGROUP_DESC"] = [=[启用此选项让这个图标控制整个分组。

如果启用，将使用这个图标的数据填充这个分组。

该分组中的其他图标都不能进行单独设置。

当你需要快速定制分组的布局、样式或者排列选项，可以选择使用它控制分组。]=]
L["ICONMENU_CTRLGROUP_UNAVAILABLE_DESC"] = "当前图标类型不能控制整个分组。"
L["ICONMENU_CTRLGROUP_UNAVAILABLEID_DESC"] = "只有组中的第一个图标（图标ID 1）可以是组控制器。"
L["ICONMENU_CUSTOMTEX"] = "自定义图标材质"
L["ICONMENU_CUSTOMTEX_DESC"] = [=[你可以使用下列方法更改这个图标的显示材质：

|cff00d1ff法术材质|r
你可以输入一个材质路径, 例如'Interface/Icons/spell_nature_healingtouch', 假如材质路径为'Interface/Icons'可以只输入'spell_nature_healingtouch'.

|cff00d1ff空白(透明无材质)|r
输入none或blank后,图标将透明显示,不再使用任何材质.

|cff00d1ff物品栏|r
你可以在此编辑框输入"$"(美元符)浏览一个动态材质列表.

|cff00d1ff自定义|r
|cffff0000你也能使用放在WoW下的子目录中的自定义材质(请在该字段输入材质的相对路径,像是'tmw/ccc.tga'),仅支持尺寸为2的N次方(32, 64, 128,等)并且类型为.tga和.blp的材质文件.]=]
L["ICONMENU_CUSTOMTEX_MOPAPPEND_DESC"] = [=[|cff00d1ff错误解决|r
|TNULL:0|t在自定义了某个材质后图标显示成绿色的话,请看看后面的两种可能性,如果你所指定的材质在WOW主目录(跟WOW.exe相同的目录)下面,请把材质移动到某个子目录(珍爱生命,远离WOW.exe)下即可正常使用(请关闭WOW之后再进行上面的操作),如果你使用的是某个特定的法术图标作为材质,那可能是因为暴雪移除或者更改了它们(它们原来的ID或名称已经不存在),请重新输入另一个你要用于自定义材质的法术名称或法术ID. ]=]
L["ICONMENU_DEBUFF"] = "减益"
L["ICONMENU_DISPEL"] = "驱散类型"
L["ICONMENU_DONTREFRESH"] = "不刷新"
L["ICONMENU_DONTREFRESH_DESC"] = "勾选此项在图标仍然倒数的时候触发效果将强制不重置冷却时间."
L["ICONMENU_DOTWATCH"] = "所有单位的增益/减益"
L["ICONMENU_DOTWATCH_AURASFOUND_DESC"] = "设置图标在被检测的任意单位有任意增益/减益时的透明度。"
L["ICONMENU_DOTWATCH_DESC"] = [=[尝试检测你所选的所有单位的增益、减益。

在检测多个法术效果时比较有用。

这个图标类型必须使用分组控制器 - 它不能是一个单独图标。]=]
L["ICONMENU_DOTWATCH_GCREQ"] = "必须为分组控制器"
L["ICONMENU_DOTWATCH_GCREQ_DESC"] = [=[此图标类型必须使用分组控制器来运作。你不能单独使用它。

请创建一个图标并且设置为分组控制器，他必须是分组中第一个图标（例如，他的图标ID为1），再启用%q选项，它在勾选框%q附近。
]=]
L["ICONMENU_DOTWATCH_NOFOUND_DESC"] = "设置在无法找到检测的增益/减益时图标的透明度。"
L["ICONMENU_DR"] = "递减"
L["ICONMENU_DR_DESC"] = "检测递减时间跟递减程度."
L["ICONMENU_DRABSENT"] = "未递减"
L["ICONMENU_DRPRESENT"] = "已递减"
L["ICONMENU_DRS"] = "递减"
L["ICONMENU_DURATION_MAX_DESC"] = "允许图标显示的最大持续时间,高于此数值图标将被隐藏."
L["ICONMENU_DURATION_MIN_DESC"] = "显示图标所需的最小持续时间,低于此数值图标将被隐藏."
L["ICONMENU_ENABLE"] = "启用"
L["ICONMENU_ENABLE_DESC"] = "图标需要在启用后才会起作用."
L["ICONMENU_ENABLE_GROUP_DESC"] = "分组在启用时才会正常运作。"
L["ICONMENU_ENABLE_PROFILE"] = "对角色启用"
L["ICONMENU_ENABLE_PROFILE_DESC"] = "取消勾选禁止这个角色使用|cff00c300公共|r分组。"
L["ICONMENU_FAIL2"] = "条件无效"
L["ICONMENU_FAKEMAX"] = "伪最大值"
L["ICONMENU_FAKEMAX_DESC"] = [=[设置计时器的伪最大值.

你可以使用此设置让整组图标以相同的速度进行倒计时.可以让你更清楚的看到哪些计时器先结束.

设置为0则禁用此选项.

译者注:如果你设置为20, 那TellMeWhen显示的计时条的总长度将变成20秒,但是并不影响你实际的计时,事实上法术的持续时间还是10秒,只是倒计时会从那个20秒长的计时条的中间开始.]=]
L["ICONMENU_FOCUS"] = "焦点目标"
L["ICONMENU_FOCUSTARGET"] = "焦点目标的目标"
L["ICONMENU_FRIEND"] = "友好单位"
L["ICONMENU_GROUPUNIT_DESC"] = [=[Group是TellMeWhen中一个特殊的单位，用于你在团队时检测团队成员，或你在队伍时检测队伍成员。

如果你在一个团队中,它不会检查重复的单位(实际上可检测的单位有"player;party;raid",某些时候队伍成员可能会被检测两次，但是它不会。)]=]
L["ICONMENU_GUARDIAN"] = "守护者"
L["ICONMENU_GUARDIAN_CHOOSENAME_DESC"] = [=[输入你需要监视的守护者名字或者NPC ID。

你可以利用分号(;)输入多个单位。]=]
L["ICONMENU_GUARDIAN_DESC"] = [=[检测你当前使用的守护者。 像是术士的小鬼等等。

此图标类型最好使用一个分组控制器。]=]
L["ICONMENU_GUARDIAN_DUR"] = "用于显示持续时间的单位"
L["ICONMENU_GUARDIAN_DUR_EITHER"] = "增效优先"
L["ICONMENU_GUARDIAN_DUR_EITHER_DESC"] = "如果存在增效，则优先显示增效的持续时间。否则将显示守护者的持续时间。"
L["ICONMENU_GUARDIAN_DUR_EMPOWER"] = "仅增效"
L["ICONMENU_GUARDIAN_DUR_GUARDIAN"] = "仅守护者"
L["ICONMENU_GUARDIAN_EMPOWERED"] = "增效"
L["ICONMENU_GUARDIAN_TRIGGER"] = "触发自：%s"
L["ICONMENU_GUARDIAN_UNEMPOWERED"] = "未增效"
L["ICONMENU_HIDENOUNITS"] = "无单位时隐藏"
L["ICONMENU_HIDENOUNITS_DESC"] = "勾选此项可在单位不存在时致使图标检测的所有单位都无效的情况下隐藏该图标(包括单位条件的设置在内)."
L["ICONMENU_HIDEUNEQUIPPED"] = "装备栏缺少武器时隐藏"
L["ICONMENU_HIDEUNEQUIPPED_DESC"] = "勾选此项在检测的武器栏没有装备武器时强制隐藏图标"
L["ICONMENU_HOSTILE"] = "敌对单位"
L["ICONMENU_ICD"] = "内置冷却"
L["ICONMENU_ICD_DESC"] = [=[检测一个触发效果或与其类似效果的冷却.

|cFFFF5959重要提示|r: 关于如何检测每个类型的内置冷却请参阅在 %q 下方选项的提示信息.]=]
L["ICONMENU_ICDAURA_DESC"] = [=[如果是在下列情况开始内置冷却,请选择此项:

|cff7fffff1)|r在你应用某个减益/获得某个增益以后(包括触发),或是
|cff7fffff2)|r某一效果造成伤害以后,或是
|cff7fffff3)|r在充能效果使你恢复法力值/怒气/等以后,或是
|cff7fffff4)|r你召唤某个东西或者NPC以后.

你需要在 %q 编辑框中输入技能/法术的名称或ID:

|cff7fffff1)|r触发内置冷却的减益/增益,或是
|cff7fffff2)|r造成伤害的某一法术/技能(请查看你的战斗记录),或是
|cff7fffff3)|r使你恢复法力值/怒气/等的充能效果(请查看你的战斗记录),或是
|cff7fffff4)|r触发内置冷却的召唤效果法术/技能(请查看你的战斗记录).

(请查看你的战斗记录或者利用插件来确认法术名称/ID)]=]
L["ICONMENU_ICDBDE"] = "增益/减益/伤害/充能/召唤"
L["ICONMENU_ICDTYPE"] = "何时开始冷却..."
L["ICONMENU_IGNORENOMANA"] = "忽略能量不足"
L["ICONMENU_IGNORENOMANA_DESC"] = [=[勾选此项当一个技能仅仅是因为能量不足而不可用时视该技能为可用.

对于像是%s 或者 %s这类技能很实用.]=]
L["ICONMENU_IGNORERUNES"] = "忽略符文"
L["ICONMENU_IGNORERUNES_DESC"] = [=[勾选此项,在技能冷却已结束,仅仅因为符文冷却(或公共冷却)导致无法施放技能,则视该技能为可用.

译者注:举例说明一下,比如死亡骑士的符文分流冷却时间为30秒,但是30秒冷却结束之后,在没有可用的鲜血符文或死亡符文的情况下会继续显示冷却倒数计时,如果有勾选这个选项,则图标就不会出现继续倒数,直接显示为符文分流可用.]=]
L["ICONMENU_IGNORERUNES_DESC_DISABLED"] = "\"忽略符文\"必须在\"冷却检测\"已勾选后才可使用."
L["ICONMENU_INVERTBARDISPLAYBAR_DESC"] = "勾选此项以反向的方式填充计量条,会在持续时间到0时填满整个计量条."
L["ICONMENU_INVERTBARS"] = "反转计量条"
L["ICONMENU_INVERTCBAR_DESC"] = "勾选此项使图标上的计时条在持续时间为0时才填满图标的宽度,而不是计时条从填满开始减少."
L["ICONMENU_INVERTPBAR_DESC"] = "勾选此项使图标上的能量条在有足够的能量施法时才填满图标的宽度,而不是计时条从填满开始减少."
L["ICONMENU_INVERTTIMER"] = "反转阴影"
L["ICONMENU_INVERTTIMER_DESC"] = "勾选此项来反转计时器的阴影效果。"
L["ICONMENU_ISPLAYER"] = "单位是玩家"
L["ICONMENU_ITEMCOOLDOWN"] = "物品冷却"
L["ICONMENU_ITEMCOOLDOWN_DESC"] = "检测可使用物品的冷却."
L["ICONMENU_LIGHTWELL_DESC"] = "检测你施放的%s的持续时间跟可用次数."
L["ICONMENU_MANACHECK"] = "能量检测"
L["ICONMENU_MANACHECK_DESC"] = [=[勾选此项启用当你魔法值/怒气/符能等等不足时改变图标颜色(或视为不可用).

译者注:除非特別说明,本插件中的能量一般是指法术施放所需的法力/怒气/符能/集中值等等,并非指盗贼/野德鲁伊的能量值.]=]
L["ICONMENU_META"] = "整合图标"
L["ICONMENU_META_DESC"] = [=[组合多个图标到一个图标.

在整合图标中被检测的那些图标即使设置为 %q 在可以显示时同样会显示.]=]
L["ICONMENU_META_ICONMENUTOOLTIP"] = "(%d个图标)"
L["ICONMENU_MOUSEOVER"] = "鼠标悬停目标"
L["ICONMENU_MOUSEOVERTARGET"] = "鼠标悬停目标的目标"
L["ICONMENU_MOVEHERE"] = "移动到此"
L["ICONMENU_NAMEPLATE"] = "姓名板"
L["ICONMENU_NOPOCKETWATCH"] = "未知时显示透明材质"
L["ICONMENU_NOPOCKETWATCH_DESC"] = "勾选此项使用透明材质代替时钟材质。"
L["ICONMENU_NOTCOUNTING"] = "未倒数"
L["ICONMENU_NOTREADY"] = "没有准备好"
L["ICONMENU_OFFS"] = "偏移"
L["ICONMENU_ONCOOLDOWN"] = "冷却中"
L["ICONMENU_ONFAIL"] = "在无效时"
L["ICONMENU_ONLYACTIVATIONOVERLAY"] = "需要激活边框"
L["ICONMENU_ONLYACTIVATIONOVERLAY_DESC"] = "此选项为检测系统默认提示技能可用时的黄色发光边框所需的必要选项。"
L["ICONMENU_ONLYBAGS"] = "只在背包中存在时"
L["ICONMENU_ONLYBAGS_DESC"] = "勾选此项当物品在背包中(或者已装备)时显示图标,如果启用'已装备的物品',此选项会被强制启用。"
L["ICONMENU_ONLYEQPPD"] = "只在已装备时"
L["ICONMENU_ONLYEQPPD_DESC"] = "勾选此项让图标只在物品已装备时显示."
L["ICONMENU_ONLYIFCOUNTING"] = "仅在计时器倒数时显示"
L["ICONMENU_ONLYIFCOUNTING_DESC"] = "勾选此项使图标仅在计时器持续时间设置大于0并且正在倒数时显示."
L["ICONMENU_ONLYIFNOTCOUNTING"] = "仅在计时器倒数完毕时显示"
L["ICONMENU_ONLYIFNOTCOUNTING_DESC"] = "勾选此项使图标仅在计时器持续时间设置大于0并且倒数完毕时显示."
L["ICONMENU_ONLYINTERRUPTIBLE"] = "仅可打断"
L["ICONMENU_ONLYINTERRUPTIBLE_DESC"] = "仅在施法可打断时显示."
L["ICONMENU_ONLYMINE"] = "仅检测自己施放的"
L["ICONMENU_ONLYMINE_DESC"] = "勾选此项让该图标只显示你施放的增益或减益"
L["ICONMENU_ONLYSEEN"] = "仅显示施放过的法术"
L["ICONMENU_ONLYSEEN_ALL"] = "允许所有法术"
L["ICONMENU_ONLYSEEN_ALL_DESC"] = "选中此项以允许为所有检查的单元显示所有功能。"
L["ICONMENU_ONLYSEEN_CLASS"] = "仅单位职业法术、技能"
L["ICONMENU_ONLYSEEN_CLASS_DESC"] = [=[选中此项，只有在已知该单元的类具有该能力时，才允许该图标显示能力。

已知的类法术在建议列表中用蓝色或粉红色突出显示。]=]
L["ICONMENU_ONLYSEEN_DESC"] = "选择此项可以让图标只显示某单位至少施放过一次的法术冷却.如果你想在同一个图标中检测来自不同职业的法术那么应该勾上它."
L["ICONMENU_ONLYSEEN_HEADER"] = "法术筛选"
L["ICONMENU_ONSUCCEED"] = "在通过时"
L["ICONMENU_OO_F"] = "在 %s 之外"
L["ICONMENU_OOPOWER"] = "没有能量"
L["ICONMENU_OORANGE"] = "超出范围"
L["ICONMENU_PETTARGET"] = "宠物的目标"
L["ICONMENU_PRESENT"] = "存在"
L["ICONMENU_PRESENTONALL"] = "全都存在"
L["ICONMENU_PRESENTONALL_DESC"] = "设置在检测的所有单位中至少都有一个用于检测的增益/减益时的图标透明度."
L["ICONMENU_PRESENTONANY"] = "任一存在"
L["ICONMENU_PRESENTONANY_DESC"] = "设置在检测的所有单位中至少存在一个用于检测的增益/减益时的图标透明度."
L["ICONMENU_RANGECHECK"] = "距离检测"
L["ICONMENU_RANGECHECK_DESC"] = "勾选此项启用当你超出范围时改变图标颜色(或视为不可用)"
L["ICONMENU_REACT"] = "单位反应"
L["ICONMENU_REACTIVE"] = "触发性技能"
L["ICONMENU_REACTIVE_DESC"] = [=[检测触发性技能的可用情况.

触发性的技能指类似 %s, %s 和 %s 这些只能在某种特定条件下使用的技能.]=]
L["ICONMENU_READY"] = "准备"
L["ICONMENU_REVERSEBARS"] = "翻转进度条"
L["ICONMENU_REVERSEBARS_DESC"] = "翻转进度条为从左到右走。"
L["ICONMENU_RUNES"] = "符文冷却"
L["ICONMENU_RUNES_CHARGES"] = "不可用符文充能"
L["ICONMENU_RUNES_CHARGES_DESC"] = "启用此项,在一个符文获得额外充能并显示为可用时,让图标依然显示成符文正在冷却状态(显示为冷却时钟)."
L["ICONMENU_RUNES_DESC"] = "检测符文冷却."
L["ICONMENU_SHOWCBAR_DESC"] = "将会在跟图标重叠的下半部份显示剩余的冷却/持续时间的计量条(或是在'反转计量条'启用的情况下显示已用的时间)"
L["ICONMENU_SHOWPBAR_DESC"] = [=[将会在跟图标重叠的上半部份方显示你施放此法术还需多少能量的能量条(或是在'反转计量条'启用的情况下显示当前的能量).

译者注:这个能量可以是盗贼的能量,战士的怒气,猎人的集中值,其他职业的法力值等等.]=]
L["ICONMENU_SHOWSTACKS"] = "显示叠加数量"
L["ICONMENU_SHOWSTACKS_DESC"] = "勾选此项显示物品的叠加数量并启用叠加数量条件."
L["ICONMENU_SHOWTIMER"] = "显示计时器"
L["ICONMENU_SHOWTIMER_DESC"] = "勾选此项让该图标的冷却时钟动画在可用时显示.(译者注:此选项仅影响图标的时钟动画,就是技能冷却时的那个转圈效果,不包括数字在内哦.)"
L["ICONMENU_SHOWTIMERTEXT"] = "显示计时器数字"
L["ICONMENU_SHOWTIMERTEXT_DESC"] = [=[勾选此项以文字方式在图标上显示剩余冷却时间或持续时间的数字.

你需要安装一个像是OmniCC这样的插件来使它正常运行，或者你需要去界面->动作条下面去开启暴雪的计时器文字（已经AFK几年了，如果这句错误了，麻烦自行找在界面中找动作条的选项）。]=]
L["ICONMENU_SHOWTIMERTEXT_NOOCC"] = "显示ElvUI计时器数字"
L["ICONMENU_SHOWTIMERTEXT_NOOCC_DESC"] = [=[勾选此项使用ElvUI的冷却数字来显示图标剩余的冷却时间/持续时间.

此设置仅用于ElvUI的计时器.如果你有其他插件提供类似此种计时器的功能(像是OmniCC),你可以利用%q选项来控制那些计时器. 我们不推荐两个选项同时启用.]=]
L["ICONMENU_SHOWTTTEXT_DESC2"] = [=[在图标的叠加数量位置显示技能效果的变量数值。较常使用在监视伤害护盾的数值等。

此数值会显示到图标的叠加数量位置并替代它。

数值来源为暴雪的API接口，可能跟提示信息上看到的数值会不相同。]=]
L["ICONMENU_SHOWTTTEXT_FIRST"] = "第一个非零的变量"
L["ICONMENU_SHOWTTTEXT_FIRST_DESC"] = [=[把增益/减益第一个非0的变量显示到图标叠加数量的位置。

一般情况下它显示的变量数值都是正确的，你也可以自行选择一个效果变量来显示。

如果检测%s，你需要监视变量#1。]=]
L["ICONMENU_SHOWTTTEXT_STACKS"] = "叠加数量（默认）"
L["ICONMENU_SHOWTTTEXT_STACKS_DESC"] = "在图标叠加数量位置显示增益/减益的叠加数量。"
L["ICONMENU_SHOWTTTEXT_VAR"] = "仅变量#%d"
L["ICONMENU_SHOWTTTEXT_VAR_DESC"] = [=[仅在图标叠加数量位置显示此变量数值。

请自行尝试并选择正确的数值来源。]=]
L["ICONMENU_SHOWTTTEXT2"] = "法术效果变量"
L["ICONMENU_SHOWWHEN"] = "何时显示图标"
L["ICONMENU_SHOWWHEN_OPACITY_GENERIC_DESC"] = "设置此图标在这个图标状态下用来显示的不透明度."
L["ICONMENU_SHOWWHEN_OPACITYWHEN_WRAP"] = "在%s|r时的不透明度"
L["ICONMENU_SHOWWHENNONE"] = "没有结果时显示"
L["ICONMENU_SHOWWHENNONE_DESC"] = "勾选此项允许在单位没有被检测到递减时显示图标."
L["ICONMENU_SHRINKGROUP"] = "收缩分组"
L["ICONMENU_SHRINKGROUP_DESC"] = [=[如果启用此项，分组将会动态调整可见图标的位置，使其变得不会狗啃骨头一样难看。

结合上面的图标排列以及布局方向一同使用，你就可以创建一个动态居中的分组。]=]
L["ICONMENU_SORT_STACKS_ASC"] = "叠加数量升序"
L["ICONMENU_SORT_STACKS_ASC_DESC"] = "勾选此项优先显示叠加数量最低的法术。"
L["ICONMENU_SORT_STACKS_DESC"] = "叠加数量降序"
L["ICONMENU_SORT_STACKS_DESC_DESC"] = "勾选此项优先显示叠加数量最高的法术。"
L["ICONMENU_SORTASC"] = "持续时间升序"
L["ICONMENU_SORTASC_DESC"] = "勾选此项优先显示持续时间最低的法术."
L["ICONMENU_SORTASC_META_DESC"] = "勾选此项优先显示持续时间最低的图标."
L["ICONMENU_SORTDESC"] = "持续时间降序"
L["ICONMENU_SORTDESC_DESC"] = "勾选该项优先显示持续时间最高的法术."
L["ICONMENU_SORTDESC_META_DESC"] = "勾选此项优先显示持续时间最高的图标."
L["ICONMENU_SPELLCAST_COMPLETE"] = "施法结束/瞬发施法"
L["ICONMENU_SPELLCAST_COMPLETE_DESC"] = [=[如果是在下列情况开始内置冷却,请选择此项:

|cff7fffff1)|r在你施法结束后,或是
|cff7fffff2)|r在你施放一个瞬发法术后.

你需要在 %q 编辑框中输入触发内置冷却的法术名称或ID.]=]
L["ICONMENU_SPELLCAST_START"] = "施法开始"
L["ICONMENU_SPELLCAST_START_DESC"] = [=[如果是在下列情况开始内置冷却,请选择此项:

|cff7fffff1)|r在开始施法后.

你需要在 %q 编辑框中输入触发内置冷却的法术名称或ID.]=]
L["ICONMENU_SPELLCOOLDOWN"] = "法术冷却"
L["ICONMENU_SPELLCOOLDOWN_DESC"] = "检测在你法术书中的那些法术的冷却"
L["ICONMENU_SPLIT"] = "拆分成新的分组"
L["ICONMENU_SPLIT_DESC"] = "创建一个新的分组并将这个图标移动到上面. 原分组中的许多设置会保留到新的分组."
L["ICONMENU_SPLIT_GLOBAL"] = "拆分成新的|cff00c300global共用分组|r"
L["ICONMENU_SPLIT_NOCOMBAT_DESC"] = "战斗中不能创建新的分组。请在脱离战斗后分离到新的分组。"
L["ICONMENU_STACKS_MAX_DESC"] = "允许图标显示的最大叠加数量,高于此数值图标将被隐藏."
L["ICONMENU_STACKS_MIN_DESC"] = "显示图标所需的最低叠加数量,低于此数值图标将被隐藏."
L["ICONMENU_STATECOLOR"] = "图标色彩和材质"
L["ICONMENU_STATECOLOR_DESC"] = [=[将图标纹理的色调设置为此图标状态。

白色是正常的。 任何其他颜色会使纹理的颜色。

在此状态下，还可以覆盖图标上显示的纹理。]=]
L["ICONMENU_STATUE"] = "武僧雕像"
L["ICONMENU_STEALABLE"] = "仅可法术吸取"
L["ICONMENU_STEALABLE_DESC"] = "勾选此项仅显示能被“法术吸取”的增益，非常适合跟驱散类型中的魔法搭配使用。"
L["ICONMENU_SUCCEED2"] = "条件通过"
L["ICONMENU_SWAPWITH"] = "交换位置"
L["ICONMENU_SWINGTIMER"] = "攻击计时器"
L["ICONMENU_SWINGTIMER_DESC"] = "检测你的主手和副手武器的自动攻击时间."
L["ICONMENU_SWINGTIMER_NOTSWINGING"] = "无攻击"
L["ICONMENU_SWINGTIMER_SWINGING"] = "攻击中"
L["ICONMENU_TARGETTARGET"] = "目标的目标"
L["ICONMENU_TOTEM"] = "图腾"
L["ICONMENU_TOTEM_DESC"] = "检测你的图腾."
L["ICONMENU_TOTEM_GENERIC_DESC"] = "检测你的 %s。"
L["ICONMENU_TYPE"] = "图标类型"
L["ICONMENU_TYPE_CANCONTROL"] = "此图标类型如果在分组的第一个图标设置好就能控制整个分组。"
L["ICONMENU_TYPE_DISABLED_BY_VIEW"] = "此图标类型不支持显示方式:%q。你可以更改分组显示方式或者创建一个新的分组使用这个图标类型。"
L["ICONMENU_UIERROR"] = "战斗错误事件"
L["ICONMENU_UIERROR_DESC"] = [=[检测UI错误信息。

例如：“怒气不足”、“你必须面对目标”等等。]=]
L["ICONMENU_UNIT_DESC"] = [=[在此框输入需要监视的单位,此单位能从右边的下拉列表插入,或者你是一位高端玩家可以自行输入需要监视的单位.多个单位请用分号分隔开(;),可使用标准单位(例如:player,target,mouseover等等可用在宏里的单位),或者友好玩家的名字(像是%s,Cybeloras,百战好哥哥等.)

需要了解更多关于单位的相关信息,请访问http://www.wowpedia.org/UnitId]=]
L["ICONMENU_UNIT_DESC_CONDITIONUNIT"] = [=[在此框输入需要监视的单位,此单位能从右边的下拉列表插入,或者你是一位高端玩家可以自行输入需要监视的单位.

可使用标准单位(例如:player,target,mouseover等等可用在宏里的单位),或者友好玩家的名字(像是%s,Cybeloras,百战好哥哥等.)

需要了解更多关于单位的相关信息,请访问http://www.wowpedia.org/UnitId]=]
L["ICONMENU_UNIT_DESC_UNITCONDITIONUNIT"] = [=[在此框输入需要监视的单位,此单位能从右边的下拉列表插入.

"unit"是指当前图标正在检测的任意单位.]=]
L["ICONMENU_UNITCNDTIC"] = "单位条件图标"
L["ICONMENU_UNITCNDTIC_DESC"] = [=[检测单位的条件状态。

设置中所有应用的单位都会被检测。]=]
L["ICONMENU_UNITCOOLDOWN"] = "单位冷却"
L["ICONMENU_UNITCOOLDOWN_DESC"] = [=[检测其他单位的冷却.

%s可以使用 %q 作为名称来检测.

译者注:玩家也可以作为被检测的单位.]=]
L["ICONMENU_UNITFAIL"] = "单位条件未通过"
L["ICONMENU_UNITS"] = "单位"
L["ICONMENU_UNITSTOWATCH"] = "监视的单位"
L["ICONMENU_UNITSUCCEED"] = "单位条件通过"
L["ICONMENU_UNUSABLE"] = "不可用"
L["ICONMENU_UNUSABLE_DESC"] = "当上述状态也不激活时，该状态是活动的。 不透明度为0％的状态将永远不会被激活。"
L["ICONMENU_USABLE"] = "可用"
L["ICONMENU_USEACTIVATIONOVERLAY"] = "检测激活边框"
L["ICONMENU_USEACTIVATIONOVERLAY_DESC"] = "检测系统默认提示技能可用时的黄色发光边框."
L["ICONMENU_VALUE"] = "资源显示"
L["ICONMENU_VALUE_DESC"] = "显示一个单位的资源（生命值、法力值等等）"
L["ICONMENU_VALUE_HASUNIT"] = "单位存在"
L["ICONMENU_VALUE_NOUNIT"] = "单位不存在"
L["ICONMENU_VALUE_POWERTYPE"] = "资源类型"
L["ICONMENU_VALUE_POWERTYPE_DESC"] = "设置你想要图标检测的资源类型。"
L["ICONMENU_VEHICLE"] = "载具"
L["ICONMENU_VIEWREQ"] = "分组显示方式不兼容"
L["ICONMENU_VIEWREQ_DESC"] = [=[此图标类型不能用于当前分组显示方式，因为它没有显示全部数据所需的组件。

请更改分组的显示方式或者创建一个新的分组再使用这个图标类型。]=]
L["ICONMENU_WPNENCHANT"] = "暂时性武器附魔"
L["ICONMENU_WPNENCHANT_DESC"] = "检测暂时性的武器附魔."
L["ICONMENU_WPNENCHANTTYPE"] = "要监视的武器栏"
L["IconModule_CooldownSweepCooldown"] = "冷却时钟"
L["IconModule_IconContainer_MasqueIconContainer"] = "图标容器"
L["IconModule_IconContainer_MasqueIconContainer_DESC"] = "容纳图标的主要部份,像是材质."
L["IconModule_PowerBar_OverlayPowerBar"] = "重叠式能量条"
L["IconModule_SelfIcon"] = "图标"
L["IconModule_Texture_ColoredTexture"] = "图标材质"
L["IconModule_TimerBar_BarDisplayTimerBar"] = "计时条(计量条显示)"
L["IconModule_TimerBar_OverlayTimerBar"] = "重叠式计时条"
L["ICONTOCHECK"] = "要检测的图标"
L["ICONTYPE_DEFAULT_HEADER"] = "提示信息"
L["ICONTYPE_DEFAULT_INSTRUCTIONS"] = [=[要开始设置该图标,请先从%q下拉式菜单中选择一个图标类型.

图标只能在锁定状态才能正常运作,当你设置结束后记得输入"/TMW".


在设置TellMeWhen时,请仔细阅读每个设置选项的提示信息,里面会有如何设置的关键信息,可以让你事半功倍!]=]
L["ICONTYPE_SWINGTIMER_TIP"] = [=[你需要检测%s的时间吗?图标类型%s拥有你想要的功能. 只需简单设置一个%s来检测%q(法术ID:%d)!

你可以点击下方的按钮自动应用设置.]=]
L["ICONTYPE_SWINGTIMER_TIP_APPLYSETTINGS"] = "应用%s设置"
L["IE_NOLOADED_GROUP"] = "选择一个分组加载："
L["IE_NOLOADED_ICON"] = "没有图标被加载。"
L["IE_NOLOADED_ICON_DESC"] = [=[你可以右键点击来读取一个图标。

如果你的屏幕上没有显示任何图标，请点击下面的 %s 标签 。

在那里你可以新增一个分组或者配置一个已存在的分组。

输入'/tmw'退出设置模式。]=]
L["ImmuneToMagicCC"] = "免疫魔法控制"
L["ImmuneToStun"] = "免疫昏迷"
L["IMPORT_EXPORT"] = "导出/导入/还原"
L["IMPORT_EXPORT_BUTTON_DESC"] = "点击此下拉式菜单来导入或导出图标/分组/配置文件."
L["IMPORT_EXPORT_DESC"] = [=[点击这个编辑框右侧的下拉式菜单的箭头来导出图标,分组或配置文件.

导出/导入字符串或发送给其他玩家需要使用这个编辑框. 具体的使用方法请看下拉式菜单上的提示信息.]=]
L["IMPORT_FAILED"] = "导入失败！"
L["IMPORT_FROMBACKUP"] = "来自备份"
L["IMPORT_FROMBACKUP_DESC"] = "用这个菜单可以还原设置到: %s"
L["IMPORT_FROMBACKUP_WARNING"] = "备份设置: %s"
L["IMPORT_FROMCOMM"] = "来自玩家"
L["IMPORT_FROMCOMM_DESC"] = "如果其他TellMeWhen使用者给你发送了配置数据,可以从这个子菜单导入那些数据."
L["IMPORT_FROMLOCAL"] = "来自配置文件"
L["IMPORT_FROMSTRING"] = "来自字符串"
L["IMPORT_FROMSTRING_DESC"] = [=[字符串允许你在游戏以外的地方转存TellMeWhen配置数据.(包括用来给其他人分享自己的设置,或者导入其他人分享的设置,也可用来备份你自己的设置.)

从字符串导入的方法: 当复制TMW字符串到你的剪切板后,在'导出/导入'编辑框中按下CTRL+V贴上字符串,然后返回浏览这个子菜单.]=]
L["IMPORT_GROUPIMPORTED"] = "分组已导入！"
L["IMPORT_GROUPNOVISIBLE"] = "你刚刚导入的分组无法显示，因为它的设置似乎不是你当前的专精和职业所使用。请输入'/tmw options'，在分组设置中修改专精和职业设置。"
L["IMPORT_HEADING"] = "导入"
L["IMPORT_ICON_DISABLED_DESC"] = "你必须在设置一个图标的时候才能导入一个图标."
L["IMPORT_LUA_CONFIRM"] = "确定导入"
L["IMPORT_LUA_DENY"] = "取消导入"
L["IMPORT_LUA_DESC"] = [=[导入的数据中包含了以下Lua代码可以被TellMeWhen执行。

你需要警惕导入的Lua代码的来源是否可信，大部分情况下它们都是安全的，但是知人知面不知心，不要被少数坏人有机可乘。

注意检查并确认代码来自可信的地方，以及它们不会做像是以你的名义来发送邮件或者确认交易这种事情。]=]
L["IMPORT_LUA_DESC2"] = "|TInterface\\AddOns\\TellMeWhen\\Textures\\Alert:0:2|t 请注意检视红色部分代码，它们可能会有某些恶意行为。|TInterface\\AddOns\\TellMeWhen\\Textures\\Alert:0:2|t"
L["IMPORT_NEWGUIDS"] = [=[你刚导入的数据中的%d|4分组:分组;和%d|4图标:图标;有唯一标识符。可能是因为你之前已经导入过该数据。

TellMeWhen已经为导入的数据分配了新的标识符。你在这之后导入的那些图标都将引用新的数据，可能会无法正常使用 - 新数据会使用到老的图标数据而造成混乱。

如果你打算替换现有的数据，请重新导入到正确的位置。 ]=]
L["IMPORT_PROFILE"] = "复制配置文件"
L["IMPORT_PROFILE_NEW"] = "|cff59ff59创建|r新的配置文件"
L["IMPORT_PROFILE_OVERWRITE"] = "|cFFFF5959覆盖|r %s"
L["IMPORT_SUCCESSFUL"] = "导入成功!"
L["IMPORTERROR_FAILEDPARSE"] = "处理字符串时发生错误.请确保你复制的字符串是完整的."
L["IMPORTERROR_INVALIDTYPE"] = "尝试导入未知类型的数据,请检查是否已安装了最新版本的TellMeWhen."
L["Incapacitated"] = "被瘫痪"
L["INCHEALS"] = "单位受到的治疗量"
L["INCHEALS_DESC"] = [=[检测单位即将受到的治疗量(包括下一跳HoT和施放中的治疗法术)

仅能在友好单位使用, 敌对单位会返回0.

译者註:由于暴雪API的限制, HoT只会返回单位框架上所显示的数值.]=]
L["INRANGE"] = "在范围内"
L["ITEMCOOLDOWN"] = "物品冷却"
L["ITEMEQUIPPED"] = "已装备物品"
L["ITEMINBAGS"] = "物品计数(包含次数)"
L["ITEMSPELL"] = "物品有使用功能"
L["ITEMTOCHECK"] = "要检测的物品"
L["ITEMTOCOMP1"] = "进行比较的第一个物品"
L["ITEMTOCOMP2"] = "进行比较的第二个物品"
L["LAYOUTDIRECTION"] = "布局方向"
L["LAYOUTDIRECTION_PRIMARY_DESC"] = "使图标的主要布局方向沿 %s 方向展开。"
L["LAYOUTDIRECTION_SECONDARY_DESC"] = "使连续的行/列图标沿 %s 方向展开。"
L["LDB_TOOLTIP1"] = "|cff7fffff左键点击|r 锁定或解锁分组"
L["LDB_TOOLTIP2"] = "|cff7fffff右键点击|r 显示主选项"
L["LEFT"] = "左"
L["LOADERROR"] = "TellMeWhen设置插件无法加载:"
L["LOADINGOPT"] = "正在加载TellMeWhen设置插件."
L["LOCKED"] = "已锁定"
L["LOCKED2"] = "位置锁定."
L["LOSECONTROL_CONTROLLOST"] = "失去控制"
L["LOSECONTROL_DROPDOWNLABEL"] = "失去控制类型"
L["LOSECONTROL_DROPDOWNLABEL_DESC"] = "选择你需要作用于图标的失去控制的类型(译者注:可多选)."
L["LOSECONTROL_ICONTYPE"] = "失去控制"
L["LOSECONTROL_ICONTYPE_DESC"] = "检测那些造成你角色失去控制权的效果."
L["LOSECONTROL_INCONTROL"] = "可控制"
L["LOSECONTROL_TYPE_ALL"] = "全部类型"
L["LOSECONTROL_TYPE_ALL_DESC"] = "让图标显示所有相关类型的信息."
L["LOSECONTROL_TYPE_DESC_USEUNKNOWN"] = "注意:图标无法判断这个失去控制的类型是否已使用."
L["LOSECONTROL_TYPE_MAGICAL_IMMUNITY"] = "魔法免疫"
L["LOSECONTROL_TYPE_SCHOOLLOCK"] = "法术类别被锁定"
L["LUA_INSERTGUID_TOOLTIP"] = "|cff7fffffShift点击|r插入并在你的代码中引用这个图标。"
L["LUACONDITION"] = "Lua(高玩级)"
L["LUACONDITION_DESC"] = [=[此条件类型允许你使用Lua语言来评估一个条件的状态。(非高玩慎入！)

输入不能为'if..then'叙述,也不能为function closure。它可以是一个普通的叙述评估，例如：‘a and b or c’。如果需要复杂功能，可使用函数调用，例如：’CheckStuff()‘，这是一个外部函数。(也可使用Lua片段功能)。

使用"thisobj"来引用这个图标、分组的数据。你也可以插入其他图标的GUID，在编辑框获得焦点时SHIFT点击那个图标即可。

如果需要更多的帮助(但不是关于如何去写Lua代码)，到CurseForge提交一份回报单。关于如何编写Lua代码，请自行去互联网搜索资料。

PS：Lua语言部份就不翻译了，翻译了反而觉得怪怪的。]=]
L["LUACONDITION2"] = "Lua条件"
L["MACROCONDITION"] = "宏命令条件语"
L["MACROCONDITION_DESC"] = [=[此条件将会评估宏命令条件语,在宏命令条件语成立时则此条件通过.
所有的宏命令条件语都能在前面加上"no"进行逆向检测.
例子:
"[nomodifier:alt]" - 没有按住ALT键
"[@target, help][mod:ctrl]" - 目标是友好的或者按住CTRL键
"[@focus, harm, nomod:shift]" - 焦点目标是敌对的同时没有按住SHIFT键

需要更多的帮助,请访问http://www.wowpedia.org/Making_a_macro]=]
L["MACROCONDITION_EB_DESC"] = "使用单一条件时中括号是可选的,使用多个条件语时中括号是必须的.​​(说明:中括号->'[ ]')"
L["MACROTOEVAL"] = "输入需要评估的宏命令条件语(允许多个)"
L["Magic"] = "魔法"
L["MAIN"] = "主页面"
L["MAIN_DESC"] = "包含这个图标的主要选项."
L["MAINASSIST"] = "主助攻"
L["MAINASSIST_DESC"] = "检测团队中标记为主助攻的单位。"
L["MAINOPTIONS_SHOW"] = "分组设置"
L["MAINTANK"] = "主坦克"
L["MAINTANK_DESC"] = "检测你团队中被标记为主坦克(Main Tank)的单位。"
L["MAKENEWGROUP_GLOBAL"] = "|cff59ff59创建|r新的|cff00c300帐号共用|r分组"
L["MAKENEWGROUP_PROFILE"] = "|cff59ff59创建|r新的角色配置分组"
L["MESSAGERECIEVE"] = "%s给你发送了一些TellMeWhen数据!你可以使用图标编辑器中的 %q 下拉式菜单把数据导入TellMeWhen."
L["MESSAGERECIEVE_SHORT"] = "%s给你发送了一些TellMeWhen数据!"
L["META_ADDICON"] = "增加图标"
L["META_ADDICON_DESC"] = "点击新增图标到此整合图标中."
L["META_GROUP_INVALID_VIEW_DIFFERENT"] = [=[该分组的图标不能用于整合图标检测,因为它们使用不同的显示方式.

分组:%s
目标分组:%s]=]
L["METAPANEL_DOWN"] = "往下移动"
L["METAPANEL_REMOVE"] = "移除此图标"
L["METAPANEL_REMOVE_DESC"] = "点击从整合图标检测列表中移除该图标."
L["METAPANEL_UP"] = "往上移动"
L["minus"] = "仆从"
L["MISCELLANEOUS"] = "其他"
L["MiscHelpfulBuffs"] = "其他增益"
L["MODTIMER_PATTERN"] = "允许Lua匹配模式"
L["MODTIMER_PATTERN_DESC"] = [=[默认情况下，这个条件将匹配任何包含你输入的文字的计时器，不区分大小写。

如果启用此设置，输入将使用Lua样式的字符匹配模式。

输入^timer name$时将强制匹配计时器的完整名称。TellMeWhen保存计时器的名称必须全部为小写字母。

需要获取更多的信息，请访问http://wowpedia.org/Pattern_matching]=]
L["MODTIMERTOCHECK"] = "用于检测的计时器"
L["MODTIMERTOCHECK_DESC"] = "输入显示在首领模块计时器显示在计时条上的全名。"
L["MOON"] = "月蚀"
L["MOUSEOVER_TOKEN_NOT_FOUND"] = "无鼠标悬停目标"
L["MOUSEOVERCONDITION"] = "鼠标指针悬停"
L["MOUSEOVERCONDITION_DESC"] = "此条件检测你的鼠标指针是否有悬停在此图标上,如果是分组条件则是鼠标指针是否有悬停在此分组的某个图标上."
L["MP5"] = "%d 5秒回蓝"
L["MUSHROOM"] = "蘑菇 %d"
L["NEWVERSION"] = "检测到新版本可升级:(%s)"
L["NOGROUPS_DIALOG_BODY"] = [=[你当前的TellMeWhen设置或玩家专精不允许显示任何分组，所以没有东西可以进行设置。

如果你想更改已有分组的设置或新增一个分组，请输入/tmw options打开TellMeWhen的首选项或者点击下方的按键。

输入/tellmewhen或/tmw退出设置模式。 ]=]
L["NONE"] = "不包含任何一个"
L["normal"] = "普通"
L["NOTINRANGE"] = "不在范围内"
L["NOTYPE"] = "<无图标类型>"
L["NUMAURAS"] = "数量"
L["NUMAURAS_DESC"] = [=[此条件仅检测一个作用中的法术效果的数量- 不要与法术效果的叠加数量混淆.
像是你的两个相同的武器附魔特效同时触发并且在作用中.
请有节制的使用它,此过程需要消耗不少CPU运算来计算数量.]=]
L["ONLYCHECKMINE"] = "仅检测自己施放的"
L["ONLYCHECKMINE_DESC"] = "选择此项让该条件只检测自己施放的增益/减益"
L["OPERATION_DIVIDE"] = "除（/）"
L["OPERATION_MINUS"] = "减（-）"
L["OPERATION_MULTIPLY"] = "乘（*）"
L["OPERATION_PLUS"] = "加（+）"
L["OPERATION_SET"] = "集（Set）"
L["OPERATION_TPAUSE"] = "暂停"
L["OPERATION_TPAUSE_DESC"] = "暂停计时器。"
L["OPERATION_TRESET"] = "重置"
L["OPERATION_TRESET_DESC"] = "重置计时器为0，如果它还在运行的话不会停止。"
L["OPERATION_TRESTART"] = "重新开始"
L["OPERATION_TRESTART_DESC"] = "重置计时器为0。如果它未运行则开始运行。"
L["OPERATION_TSTART"] = "开始"
L["OPERATION_TSTART_DESC"] = "如果计时器没在运行则开始计时。不重置计时器。"
L["OPERATION_TSTOP"] = "停止"
L["OPERATION_TSTOP_DESC"] = "停止并重置计时器为0。"
L["OUTLINE_MONOCHORME"] = "单色"
L["OUTLINE_NO"] = "没有描边"
L["OUTLINE_THICK"] = "粗描边"
L["OUTLINE_THIN"] = "细描边"
L["PARENTHESIS_TYPE_("] = "左括号'('"
L["PARENTHESIS_TYPE_)"] = "右括号')'"
L["PARENTHESIS_WARNING1"] = [=[左右括号的数量不相等!

缺少%d个%s.]=]
L["PARENTHESIS_WARNING2"] = [=[一些右括号缺少左括号!

缺少%d个左括号'('.]=]
L["PERCENTAGE"] = "百分比"
L["PERCENTAGE_DEPRECATED_DESC"] = [=[百分比条件已经作废，因为它们不再可靠。

在德拉诺之王，增益/减益的加速机制更改为未结束前刷新可以最大延长至130%基础持续时间。 

其他一大段略过，基本同上。]=]
L["PET_TYPE_CUNNING"] = "狡诈"
L["PET_TYPE_FEROCITY"] = "狂野"
L["PET_TYPE_TENACITY"] = "坚韧"
L["PLAYER_DESC"] = "单位'player'是你自己。"
L["Poison"] = "毒"
L["PROFILE_LOADED"] = "已读取配置文件: %s"
L["PROFILES_COPY"] = "复制配置..."
L["PROFILES_COPY_CONFIRM"] = "复制配置"
L["PROFILES_COPY_CONFIRM_DESC"] = "配置 %q 将会被配置 %q 的一个副本覆盖."
L["PROFILES_COPY_DESC"] = [=[选择一个配置. 当前的配置会被这个选择的配置覆盖.

在登出游戏或重载前你都可以使用 %q (下方菜单 %q 中的选项)来恢复被删配置.]=]
L["PROFILES_DELETE"] = "删除配置..."
L["PROFILES_DELETE_CONFIRM"] = "删除配置"
L["PROFILES_DELETE_CONFIRM_DESC"] = "配置 %q 将会被删除."
L["PROFILES_DELETE_DESC"] = [=[选择需要删除的配置.

在登出游戏或重载前你都可以使用 %q (下方菜单 %q 中的选项)来恢复被删配置.]=]
L["PROFILES_NEW"] = "新建配置"
L["PROFILES_NEW_DESC"] = "输入新配置名称, 然后按回车建立."
L["PROFILES_SET"] = "变更配置..."
L["PROFILES_SET_DESC"] = "切换到选择的配置."
L["PROFILES_SET_LABEL"] = "当前配置"
L["PvPSpells"] = "PVP控场技能等"
L["QUESTIDTOCHECK"] = "用于检测的任务ID"
L["RAID_WARNING_FAKE"] = "团队警报 (假)"
L["RAID_WARNING_FAKE_DESC"] = "输出类似于团队警报信息的文字,此信息不会被其他人看到,你不需要团队权限,也不需要在团队中即可使用."
L["RaidWarningFrame"] = "团队警告框架"
L["rare"] = "稀有"
L["rareelite"] = "稀有精英"
L["REACTIVECNDT_DESC"] = "此条件仅检测技能的触发/激活情况,并非它的冷却."
L["REDO"] = "恢复"
L["REDO_DESC"] = "重做上次对这些设置所做的更改。"
L["ReducedHealing"] = "治疗效果降低"
L["REQFAILED_ALPHA"] = "无效时的不透明度"
L["RESET_ICON"] = "重置"
L["RESET_ICON_DESC"] = "重置这个图标的所有设置为默认值。"
L["RESIZE"] = "调整大小"
L["RESIZE_GROUP_CLOBBERWARN"] = "当你使用|cff7fffff右键点击并拖拽|r缩小分组时，部分图标将会临时保存设置，在你使用|cff7fffff右键点击并拖拽|r放大分组时会恢复，但是在你登出或者重新加载UI后临时保存的数据将会丢失。"
L["RESIZE_TOOLTIP"] = "|cff7fffff点击并拖拽|r以改变大小"
L["RESIZE_TOOLTIP_CHANGEDIMS"] = "|cff7fffff鼠标右键点击并拖拽|r来更改分组的行跟列的数量。"
L["RESIZE_TOOLTIP_IEEXTRA"] = "在主选项启用缩放。"
L["RESIZE_TOOLTIP_SCALEX_SIZEY"] = "|cff7fffff点击并拖拽|r来改变尺寸"
L["RESIZE_TOOLTIP_SCALEXY"] = [=[|cff7fffff点击同时拖曳|r快速调整尺寸
|cff7fffff按住CTRL|r微调尺寸]=]
L["RESIZE_TOOLTIP_SCALEY_SIZEX"] = "|cff7fffff点击并拖动|r来调整尺寸"
L["RIGHT"] = "右"
L["ROLEf"] = "职责: %s"
L["Rooted"] = "被缠绕"
L["RUNEOFPOWER"] = "符文%d"
L["RUNES"] = "要检测的符文"
L["RUNSPEED"] = "单位奔跑速度"
L["RUNSPEED_DESC"] = "这是指单位的最大运行速度，而不管单位是否正在移动。"
L["SAFESETUP_COMPLETE"] = "安全&慢速设置完成."
L["SAFESETUP_FAILED"] = "安全&慢速设置失败:%s"
L["SAFESETUP_TRIGGERED"] = "正在进行安全&慢速设置..."
L["SEAL"] = "圣印"
L["SENDSUCCESSFUL"] = "已成功发送"
L["SHAPESHIFT"] = "变身"
L["Shatterable"] = "冰冻"
L["SHOWGUIDS_OPTION"] = "在鼠标提示信息上显示GUID。"
L["SHOWGUIDS_OPTION_DESC"] = "启用此设置可以在鼠标提示面板显示图标跟分组的GUID（全局唯一标识符）。在需要知道图标或分组所对应的GUID时，这可能对你有所帮助。"
L["Silenced"] = "被沉默"
L["Slowed"] = "被减速"
L["SORTBY"] = "排列方式"
L["SORTBYNONE"] = "正常排列"
L["SORTBYNONE_DESC"] = [=[如果选中，法术将按照"%s"编辑框中的输入顺序来检测并排列。

如果是一个增益/减益图标，只要出现在单位框体上的法术效果数字没有超出效率阀值设定，就会被检测并排列。

(PS：如果看不懂请无视这段说明，只要知道它是按照你输入的顺序来排列就好。)]=]
L["SORTBYNONE_DURATION"] = "持续时间正常"
L["SORTBYNONE_META_DESC"] = "如果勾选,被检测的图标将使用上面的列表所设置的顺序来排列."
L["SORTBYNONE_STACKS"] = "叠加数量正常"
L["SOUND_CHANNEL"] = "音效播放频道"
L["SOUND_CHANNEL_DESC"] = [=[选择一个你想用于播放声音的频道(会直接使用在系统->音效中该频道所设置的音量跟设定来播放).

选择%q时,可以在音效关闭时播放声音.]=]
L["SOUND_CHANNEL_MASTER"] = "主声道"
L["SOUND_CUSTOM"] = "自定义音效文件"
L["SOUND_CUSTOM_DESC"] = [=[输入需要用来播放的自定义音效文件的路径.
下面是一些例子,其中"File"是你的音效文件名,"ext"是后缀名(只能用ogg或者mp3格式)

-"CustomSounds\File.ext": 一个文件放在WOW主目录一个命名为"CustomSound"的新建文件夹中(此文件夹同WOW.exe,Interface和WTF在同一位置)
-"Interface\AddOns\file.ext": 插件文件夹中的某一文件
-"file.ext": WOW主目录的某个文件

注意:魔兽世界必须在重开之后才能正常使用那些在它启动时还不存在的文件.]=]
L["SOUND_ERROR_ALLDISABLED"] = [=[无法进行音效播放测试，原因：游戏音效已经被完全禁用。

你需要去更改暴雪音效选项的相关设置。]=]
L["SOUND_ERROR_DISABLED"] = [=[无法进行音效播放测试，原因：音效播放频道 %q 已经被禁用。

你需要去更改暴雪音效选项的相关设置，或者你也可以在TellMeWhen的主选项中更改TellMeWhen的音效播放频道('/tmw options')。]=]
L["SOUND_ERROR_MUTED"] = [=[无法进行音效播放测试，原因：音效播放频道 %q 的音量大小为0。

你需要去更改暴雪音效选项的相关设置，或者你也可以在TellMeWhen的主选项中更改TellMeWhen的音效播放频道('/tmw options')。]=]
L["SOUND_EVENT_DISABLEDFORTYPE"] = "不可用"
L["SOUND_EVENT_DISABLEDFORTYPE_DESC2"] = [=[在当前图标设置下,此事件不可用.

可能因为当前的图标类型(%s)还不支持此事件,请|cff7fffff右键点击|r更改事件类型.]=]
L["SOUND_EVENT_NOEVENT"] = "未配置的事件"
L["SOUND_EVENT_ONALPHADEC"] = "在透明度百分比减少时"
L["SOUND_EVENT_ONALPHADEC_DESC"] = [=[当图标的不透明度降低时触发此事件.

注意:不透明度在降低后如果为0%不会触发此事件(如果有需要请使用"在隐藏时").]=]
L["SOUND_EVENT_ONALPHAINC"] = "在透明度百分比增加时"
L["SOUND_EVENT_ONALPHAINC_DESC"] = [=[当图标的不透明度提高时触发此事件.

注意:不透明度在提高前如果为0%不会触发此事件(如果有需要请使用"在显示时").]=]
L["SOUND_EVENT_ONCHARGEGAINED"] = "在充能获取时"
L["SOUND_EVENT_ONCHARGEGAINED_DESC"] = "此事件在一个被检测的充能类型技能获取一次充能时触发。"
L["SOUND_EVENT_ONCHARGELOST"] = "在充能使用时"
L["SOUND_EVENT_ONCHARGELOST_DESC"] = "此事件在一个被检测的充能类型技能使用一次充能时触发。"
L["SOUND_EVENT_ONCLEU"] = "在战斗事件发生时"
L["SOUND_EVENT_ONCLEU_DESC"] = "此事件在图标处理一个战斗事件时触发."
L["SOUND_EVENT_ONCONDITION"] = "在设置的条件通过时"
L["SOUND_EVENT_ONCONDITION_DESC"] = "当你设置的条件通过时触发一次此事件."
L["SOUND_EVENT_ONDURATION"] = "在持续时间改变时"
L["SOUND_EVENT_ONDURATION_DESC"] = [=[此事件在图标计时器的持续时间改变时触发.

因为在计时器运行时每次图标更新都会触发该事件,你必须设置一个条件,使事件仅在条件的状态改变时触发.]=]
L["SOUND_EVENT_ONEVENTSRESTORED"] = "在图标设置后"
L["SOUND_EVENT_ONEVENTSRESTORED_DESC"] = [=[此事件在图标已经设置完毕后触发.

这主要发生在你退出设置模式时,同样也会发生在某些区域的进入事件或离开事件.

你可以视它为图标的"软重置".

此事件比较常用于创建一个图标的默认状态的动画.]=]
L["SOUND_EVENT_ONFINISH"] = "在结束时"
L["SOUND_EVENT_ONFINISH_DESC"] = "当冷却结束,增益/减益消失,等相似的情况下触发此事件."
L["SOUND_EVENT_ONHIDE"] = "在隐藏时"
L["SOUND_EVENT_ONHIDE_DESC"] = "当图标隐藏时触发此事件.(即使 %q 已勾选)"
L["SOUND_EVENT_ONLEFTCLICK"] = "在鼠标左键点击时"
L["SOUND_EVENT_ONLEFTCLICK_DESC"] = "在图标锁定的情况下,当你|cff7fffff用鼠标左键点击|r这个图标时触发此事件."
L["SOUND_EVENT_ONRIGHTCLICK"] = "在鼠标右键点击时"
L["SOUND_EVENT_ONRIGHTCLICK_DESC"] = "在图标锁定的情况下,当你|cff7fffff用鼠标右键点击|r这个图标时触发此事件."
L["SOUND_EVENT_ONSHOW"] = "在显示时"
L["SOUND_EVENT_ONSHOW_DESC"] = "当图标显示时触发此事件.(即使 %q 已勾选)"
L["SOUND_EVENT_ONSPELL"] = "在法术改变时"
L["SOUND_EVENT_ONSPELL_DESC"] = "当图标显示信息中的法术/物品/等改变时触发此事件."
L["SOUND_EVENT_ONSTACK"] = "在叠加数量改变时"
L["SOUND_EVENT_ONSTACK_DESC"] = [=[此事件在图标所检测的法术/物品等的叠加数量发生改变时触发.

包括逐渐降低的%s图标.]=]
L["SOUND_EVENT_ONSTACKDEC"] = "在叠加数量减少时"
L["SOUND_EVENT_ONSTACKINC"] = "在叠加数量增加时"
L["SOUND_EVENT_ONSTART"] = "在开始时"
L["SOUND_EVENT_ONSTART_DESC"] = "当冷却开始,增益/减益开始作用,等相似的情况下触发此事件."
L["SOUND_EVENT_ONUIERROR"] = "在战斗错误事件发生时"
L["SOUND_EVENT_ONUIERROR_DESC"] = "此事件在图标处理一个战斗错误事件时触发。"
L["SOUND_EVENT_ONUNIT"] = "在单位改变时"
L["SOUND_EVENT_ONUNIT_DESC"] = "当图标显示信息中的单位改变时触发此事件."
L["SOUND_EVENT_WHILECONDITION"] = "当设置的条件通过时"
L["SOUND_EVENT_WHILECONDITION_DESC"] = "此类型的通知事件会在你设置的条件通过时持续触发。"
L["SOUND_SOUNDTOPLAY"] = "要播放的音效"
L["SOUND_TAB"] = "音效"
L["SOUND_TAB_DESC"] = "设置用于播放的声音。 你可以使用LibSharedMedia的声音或者指定一个声音文件。"
L["SOUNDERROR1"] = "文件必须有后缀名!"
L["SOUNDERROR2"] = [=[魔兽世界4.0+不支持自定义WAV文件

(WoW自带WAV音效可以使用)]=]
L["SOUNDERROR3"] = "只支持OGG跟MP3文件!"
L["SPEED"] = "单位速度"
L["SPEED_DESC"] = [=[这是指单位当前的移动速度,如果单位不移动则为0.
如果您要检测单位的最高奔跑速度,可以使用"单位奔跑速度"条件来代替.]=]
L["SpeedBoosts"] = "速度提升"
L["SPELL_EQUIV_REMOVE_FAILED"] = "警告：尝试把%q从法术列表%q中移除，但是无法找到。"
L["SPELLCHARGES"] = "法术次数"
L["SPELLCHARGES_DESC"] = "检测像是%s或%s这类法术的可用次数."
L["SPELLCHARGES_FULLYCHARGED"] = "完全恢复"
L["SPELLCHARGETIME"] = "法术次数恢复时间"
L["SPELLCHARGETIME_DESC"] = "检测像是%s或%s恢复一次充能还需要多少时间."
L["SPELLCOOLDOWN"] = "法术冷却"
L["SPELLREACTIVITY"] = "法术反应(激活/触发/可能)"
L["SPELLTOCHECK"] = "要检测的法术"
L["SPELLTOCOMP1"] = "进行比较的第一个法术"
L["SPELLTOCOMP2"] = "进行比较的第二个法术"
L["STACKALPHA_DESC"] = [=[设置在你要求的叠加数量不符合时图标显示的不透明度.

此选项会在勾选%s时自动忽略。]=]
L["STACKS"] = "叠加数量"
L["STACKSPANEL_TITLE2"] = "叠加数量限制"
L["STANCE"] = "姿态"
L["STANCE_DESC"] = [=[你可以利用分号(;)输入多个用于检测的姿态.

此条件会在任意一个姿态符合时通过.]=]
L["STANCE_LABEL"] = "姿态"
L["STRATA_BACKGROUND"] = "背景(最低)"
L["STRATA_DIALOG"] = "对话框"
L["STRATA_FULLSCREEN"] = "全屏幕"
L["STRATA_FULLSCREEN_DIALOG"] = "全屏幕对话框"
L["STRATA_HIGH"] = "高"
L["STRATA_LOW"] = "低"
L["STRATA_MEDIUM"] = "中"
L["STRATA_TOOLTIP"] = "提示信息(最高)"
L["Stunned"] = "被昏迷"
L["SUG_BUFFEQUIVS"] = "同类型增益"
L["SUG_CLASSSPELLS"] = "已知玩家/宠物的法术"
L["SUG_DEBUFFEQUIVS"] = "同类型减益"
L["SUG_DISPELTYPES"] = "驱散类型"
L["SUG_FINISHHIM"] = "马上结束缓存"
L["SUG_FINISHHIM_DESC"] = "|cff7fffff点击|r快速完成该缓存/筛选过程. 友情提示:你的电脑可能会因此卡住几秒钟的时间."
L["SUG_FIRSTHELP_DESC"] = [=[这是一个提示与建议列表，它可以显示相关的条目供你选择以加快设置速度。

|cff7fffff鼠标点击|r或者使用键盘|cff7fffff上/下|r箭头和|cff7fffffTab|r插入条目。

如果你只需要插入名称，可以无视条目的ID是否正确，只要名称完全相同即可。

大部分情况下，用名称来检测是比较好的选择。在同个名称存在多个不同效果可能发生重叠的情况下你才需要使用ID来检测。

如果你输入的是一个名称，则|cff7fffff点击右键|r条目会插入一个ID，反之亦然,你输入的是ID则|cff7fffff点击右键|r会插入一个名称。]=]
L["SUG_INSERT_ANY"] = "|cff7fffff点击鼠标|r"
L["SUG_INSERT_LEFT"] = "|cff7fffff点击鼠标左键|r"
L["SUG_INSERT_RIGHT"] = "|cff7fffff点击鼠标右键|r"
L["SUG_INSERT_TAB"] = "或者按|cff7fffffTab|r键"
L["SUG_INSERTEQUIV"] = "%s 插入同类型条目"
L["SUG_INSERTERROR"] = "%s插入错误信息"
L["SUG_INSERTID"] = "%s插入编号(ID)"
L["SUG_INSERTITEMSLOT"] = "%s插入物品对应的装备栏编号"
L["SUG_INSERTNAME"] = "%s插入名称"
L["SUG_INSERTNAME_INTERFERE"] = [=[%s插入名称。

|TInterface\AddOns\TellMeWhen\Textures\Alert:0:2|t|cffffa500CAUTION: |TInterface\AddOns\TellMeWhen\Textures\Alert:0:2|t|cffff1111
此法术可能有多个效果。
如果使用名称可能无法被正确的检测。
你应当使用一个ID来检测。|r]=]
L["SUG_INSERTTEXTSUB"] = "%s插入标签"
L["SUG_INSERTTUNITID"] = "%s插入单位ID"
L["SUG_MISC"] = "杂项"
L["SUG_MODULE_FRAME_LIKELYADDON"] = "猜测来源：%s"
L["SUG_NPCAURAS"] = "已知NPC的增益/减益"
L["SUG_OTHEREQUIVS"] = "其他同类型"
L["SUG_PATTERNMATCH_FISHINGLURE"] = "鱼饵%（%+%d+钓鱼技能%）"
L["SUG_PATTERNMATCH_SHARPENINGSTONE"] = "磨快%（%+%d+伤害%）"
L["SUG_PATTERNMATCH_WEIGHTSTONE"] = "增重%（%+%d+伤害%）"
L["SUG_PLAYERAURAS"] = "已知玩家/宠物的增益/减益"
L["SUG_PLAYERSPELLS"] = "你的法术"
L["SUG_TOOLTIPTITLE"] = [=[当你输入时,TellMeWhen将会在缓存中查找并提示你最有可能输入的法术.

法术按照以下列表分类跟着色.
注意:在记录到相应的数据之前或者在你没有登陆过其他的职业的情况下不会把那些法术放入"已知"开头的分类中.

点击一个条目将其插入到编辑框.

]=]
L["SUG_TOOLTIPTITLE_GENERIC"] = [=[当你输入时，TellMeWhen会尝试确定你想要输入的内容。

在某些情况下，建议列表中可能显示了错误的内容。你可以不用选择建议列表中的条目 - 当你输入编辑框的（正确）内容越长时，TellMeWhen越不容易发生这样的情况。

点击一个条目把它插入到编辑框中。]=]
L["SUG_TOOLTIPTITLE_TEXTSUBS"] = [=[下列的单位变量可以使用在输出显示的文字内容中.变量将会被替换成与其相应的内容后再输出显示.

点击一个条目将其插入到编辑框中.]=]
L["SUGGESTIONS"] = "提示与建议:"
L["SUGGESTIONS_DOGTAGS"] = "DogTags:"
L["SUGGESTIONS_SORTING"] = "排列中..."
L["SUN"] = "日蚀"
L["SWINGTIMER"] = "攻击计时"
L["TABGROUP_GROUP_DESC"] = "设置 TellMeWhen 分组."
L["TABGROUP_ICON_DESC"] = "设置 TellMeWhen 图标."
L["TABGROUP_MAIN_DESC"] = "TellMeWhen综合设置"
L["TEXTLAYOUTS"] = "文字显示样式"
L["TEXTLAYOUTS_ADDANCHOR"] = "增加描点"
L["TEXTLAYOUTS_ADDANCHOR_DESC"] = "点击增加文字描点."
L["TEXTLAYOUTS_ADDLAYOUT"] = "新增文字显示样式"
L["TEXTLAYOUTS_ADDLAYOUT_DESC"] = "创建一个你可自行配置并应用到图标的文字显示样式."
L["TEXTLAYOUTS_ADDSTRING"] = "新增文字显示方案"
L["TEXTLAYOUTS_ADDSTRING_DESC"] = "添加一个新的文字显示方案到此文字显示样式中."
L["TEXTLAYOUTS_BLANK"] = "(空白)"
L["TEXTLAYOUTS_CHOOSELAYOUT"] = "选择样式..."
L["TEXTLAYOUTS_CHOOSELAYOUT_DESC"] = "选取此图标要使用的文字显示样式."
L["TEXTLAYOUTS_CLONELAYOUT"] = "克隆显示样式"
L["TEXTLAYOUTS_CLONELAYOUT_DESC"] = "点击创建一个该显示样式的副本,你可以单独修改它."
L["TEXTLAYOUTS_DEFAULTS_BAR1"] = "计量条显示样式 1"
L["TEXTLAYOUTS_DEFAULTS_BAR2"] = "垂直计量条布局1"
L["TEXTLAYOUTS_DEFAULTS_BINDINGLABEL"] = "绑定/标签"
L["TEXTLAYOUTS_DEFAULTS_CENTERNUMBER"] = "居中数字"
L["TEXTLAYOUTS_DEFAULTS_DURATION"] = "持续时间"
L["TEXTLAYOUTS_DEFAULTS_ICON1"] = "图标样式 1"
L["TEXTLAYOUTS_DEFAULTS_NOLAYOUT"] = "<无显示样式>"
L["TEXTLAYOUTS_DEFAULTS_NUMBER"] = "数字"
L["TEXTLAYOUTS_DEFAULTS_SPELL"] = "法术"
L["TEXTLAYOUTS_DEFAULTS_STACKS"] = "叠加数量"
L["TEXTLAYOUTS_DEFAULTS_WRAPPER"] = "默认: %s"
L["TEXTLAYOUTS_DEFAULTTEXT"] = "默认显示文字"
L["TEXTLAYOUTS_DEFAULTTEXT_DESC"] = "修改文字显示样式在图标上显示的默认文字."
L["TEXTLAYOUTS_DEGREES"] = "%d 度"
L["TEXTLAYOUTS_DELANCHOR"] = "删除描点"
L["TEXTLAYOUTS_DELANCHOR_DESC"] = "点击删除该文字描点."
L["TEXTLAYOUTS_DELETELAYOUT"] = "删除文字显示样式"
L["TEXTLAYOUTS_DELETELAYOUT_CONFIRM_LISTING"] = "%s: ~%d |4图标:图标;"
L["TEXTLAYOUTS_DELETELAYOUT_CONFIRM_NUM2"] = "|cFFFF2929下列角色配置的图标中使用了这个显示样式。如果你要删除该显示样式，图标将重新使用默认的显示样式：|r"
L["TEXTLAYOUTS_DELETELAYOUT_DESC2"] = "点击删除此文字显示样式"
L["TEXTLAYOUTS_DELETESTRING"] = "删除文字显示方案"
L["TEXTLAYOUTS_DELETESTRING_DESC2"] = "从文字显示样式中删除这个文字显示方案。"
L["TEXTLAYOUTS_DESC"] = "定义的文字显示样式能用于你设置的任意一个图标。"
L["TEXTLAYOUTS_ERR_ANCHOR_BADANCHOR"] = "此文字布局无法使用在这个分组显示方式上，请选择另外的文字布局。（未找到描点：%s）"
L["TEXTLAYOUTS_ERR_ANCHOR_BADINDEX"] = [=[文字布局错误：文字显示#%d尝试依附到文字显示#%d，但是%d不存在，所以文字显示#%d不能正常使用。
]=]
L["TEXTLAYOUTS_ERROR_FALLBACK"] = [=[找不到此图标使用的文字显示样式.在找到相符的显示样式或选择其他的显示样式之前将使用默认文字显示样式.

(你是不是删除了相关的文字显示样式?或只有导入图标而没导入它使用的文字显示样式?)]=]
L["TEXTLAYOUTS_fLAYOUT"] = "文字显示样式: %s"
L["TEXTLAYOUTS_FONTSETTINGS"] = "字体设置"
L["TEXTLAYOUTS_fSTRING"] = "文字显示方案 %s"
L["TEXTLAYOUTS_fSTRING2"] = "文字显示方案 %d: %s"
L["TEXTLAYOUTS_fSTRING3"] = "文字显示方案:%s"
L["TEXTLAYOUTS_HEADER_DISPLAY"] = "文字显示方案"
L["TEXTLAYOUTS_HEADER_LAYOUT"] = "文字显示样式"
L["TEXTLAYOUTS_IMPORT"] = "导入文字显示样式"
L["TEXTLAYOUTS_IMPORT_CREATENEW"] = "|cff59ff59新增|r"
L["TEXTLAYOUTS_IMPORT_CREATENEW_DESC"] = [=[文字显示样式中已有一个跟该显示样式相同的唯一标识.

选择此项创建一个新的唯一标识并导入这个显示样式.]=]
L["TEXTLAYOUTS_IMPORT_NORMAL_DESC"] = "点击导入文字显示样式."
L["TEXTLAYOUTS_IMPORT_OVERWRITE"] = "|cFFFF5959替换|r 现有"
L["TEXTLAYOUTS_IMPORT_OVERWRITE_DESC"] = [=[文字显示样式中已有一个跟需要导入的显示样式相同的唯一标识.

选择此项覆盖已有唯一标识的显示样式并导入新的显示样式.那些正在使用被覆盖掉的那个文字显示样式的图标都会在导入后自动作出相应的更新.]=]
L["TEXTLAYOUTS_IMPORT_OVERWRITE_DISABLED_DESC"] = "你不能覆盖默认文字显示样式."
L["TEXTLAYOUTS_LAYOUT_SETDEFAULTS"] = "重置为默认"
L["TEXTLAYOUTS_LAYOUT_SETDEFAULTS_DESC"] = "重置当前文字显示样式设置中所有方案的文字为默认显示文字."
L["TEXTLAYOUTS_LAYOUTDISPLAYS"] = [=[文字显示方案:
%s]=]
L["TEXTLAYOUTS_LAYOUTSETTINGS"] = "显示样式设置"
L["TEXTLAYOUTS_LAYOUTSETTINGS_DESC"] = "点击设置文字显示样式 %q."
L["TEXTLAYOUTS_NOEDIT_DESC"] = [=[这个文字显示样式是TellMeWhen默认的文字显示样式,你无法对其作出更改.

如果你想更改的话,请克隆一份此文字显示样式的副本.]=]
L["TEXTLAYOUTS_POINT2"] = "文字位置"
L["TEXTLAYOUTS_POINT2_DESC"] = "将 %s 的文本显示到锚定目标。"
L["TEXTLAYOUTS_POSITIONSETTINGS"] = "位置设定"
L["TEXTLAYOUTS_RELATIVEPOINT2_DESC"] = "将文本显示到 %s 的锚定目标。"
L["TEXTLAYOUTS_RELATIVETO_DESC"] = "文字将依附的对象"
L["TEXTLAYOUTS_RENAME"] = "重命名显示样式"
L["TEXTLAYOUTS_RENAME_DESC"] = "为此文字显示样式修改一个与其用途相符的名称,让你可以轻松的找到它."
L["TEXTLAYOUTS_RENAMESTRING"] = "重命名文字显示方案"
L["TEXTLAYOUTS_RENAMESTRING_DESC"] = "为此文字显示方案修改一个与其用途相符的名称,让你可以轻松的找到它."
L["TEXTLAYOUTS_RESETSKINAS"] = "%q设置用于文字%q将被重置,以防止跟文字%q的新设置产生冲突."
L["TEXTLAYOUTS_SETGROUPLAYOUT"] = "文字显示样式"
L["TEXTLAYOUTS_SETGROUPLAYOUT_DDVALUE"] = "选择显示样式..."
L["TEXTLAYOUTS_SETGROUPLAYOUT_DESC"] = [=[设置使用于这个分组所有图标的文字显示样式.

每个图标的文字显示样式也可以自行单独设置.]=]
L["TEXTLAYOUTS_SETTEXT"] = "设置显示文字"
L["TEXTLAYOUTS_SETTEXT_DESC"] = [=[设置用于这个文字显示方案中的文字.

文字可能会被转化为DogTag标记的格式,以便动态显示信息. 关于如何使用DogTag标记,请输入'/dogtag'或'/dt'查看帮助.]=]
L["TEXTLAYOUTS_SIZE_AUTO"] = "自动"
L["TEXTLAYOUTS_SKINAS"] = "使用皮肤"
L["TEXTLAYOUTS_SKINAS_COUNT"] = "叠加数量"
L["TEXTLAYOUTS_SKINAS_DESC"] = "选择你想让这些显示文字使用的Masque皮肤."
L["TEXTLAYOUTS_SKINAS_HOTKEY"] = "绑定/标签"
L["TEXTLAYOUTS_SKINAS_NONE"] = "无"
L["TEXTLAYOUTS_SKINAS_SKINNEDINFO"] = [=[此文本显示皮肤由Masque设置。 

因此，当此布局用于由Masque设置外观的TellMeWhen图标时，下面的设置不会有任何效果。]=]
L["TEXTLAYOUTS_STRING_COPYMENU"] = "复制"
L["TEXTLAYOUTS_STRING_COPYMENU_DESC"] = [=[点击打开一个此配置文件中所有的已使用显示文字列表,你可以将它们加入到这个文字显示方案中.
]=]
L["TEXTLAYOUTS_STRING_SETDEFAULT"] = "重置为默认"
L["TEXTLAYOUTS_STRING_SETDEFAULT_DESC"] = [=[重置当前文字显示方案中的显示文字为下列默认显示文字,在该文字显示样式中的设置为:

%s]=]
L["TEXTLAYOUTS_STRINGUSEDBY"] = "已使用%d次."
L["TEXTLAYOUTS_TAB"] = "文字显示方案"
L["TEXTLAYOUTS_UNNAMED"] = "<未命名>"
L["TEXTLAYOUTS_USEDBY_HEADER"] = "以下角色配置在他们的图标中使用了此显示样式："
L["TEXTLAYOUTS_USEDBY_NONE"] = "此魔兽世界帐号中的TellMeWhen配置文件中没有使用这个显示样式。"
L["TEXTMANIP"] = "文字处理"
L["TOOLTIPSCAN"] = "法术效果变量"
L["TOOLTIPSCAN_DESC"] = "此条件类型允许你检测某一单位的某个法术效果提示信息上的第一个变量(数字).数字是由暴雪API所提供,跟你在法术效果的提示信息中看到的数字可能会不同(像是服务器已经在线修正,客户端依然显示错误的数字这种情况),同时也不保证一定能够从法术效果获取一个数字,不过在大多数实际情况下都能检测到正确的数字."
L["TOOLTIPSCAN2"] = "提示信息数字 #%d"
L["TOOLTIPSCAN2_DESC"] = "此条件类型将允许你检测一个在技能提示信息面板上找到的数字。"
L["TOP"] = "上"
L["TOPLEFT"] = "左上"
L["TOPRIGHT"] = "右上"
L["TOTEMS"] = "检测图腾"
L["TREEf"] = "专精：%s"
L["TRUE"] = "是"
L["UIPANEL_ADDGROUP2"] = "新建 %s 分组"
L["UIPANEL_ADDGROUP2_DESC"] = "|cff7fffff点击|r 新建 %s 分组."
L["UIPANEL_ALLOWSCALEIE"] = "允许图标编辑器缩放"
L["UIPANEL_ALLOWSCALEIE_DESC"] = [=[默认情况下图标编辑器不允许拖放更改尺寸，以便让布局比较清新以及完美。

如果你不介意这个或者有特别的原因，那么请启用它。]=]
L["UIPANEL_ANCHORNUM"] = "描点 %d"
L["UIPANEL_BAR_BORDERBAR"] = "进度条边框"
L["UIPANEL_BAR_BORDERBAR_DESC"] = "设置进度条边框."
L["UIPANEL_BAR_BORDERCOLOR"] = "边框颜色"
L["UIPANEL_BAR_BORDERCOLOR_DESC"] = "改变图标和进度条边框颜色."
L["UIPANEL_BAR_BORDERICON"] = "图标边框"
L["UIPANEL_BAR_BORDERICON_DESC"] = "在纹理，冷却时钟和其他类似组件周围设置边框。"
L["UIPANEL_BAR_FLIP"] = "翻转图标"
L["UIPANEL_BAR_FLIP_DESC"] = "将纹理，冷却时钟和其他类似的组件放置在图标的另一侧。"
L["UIPANEL_BAR_PADDING"] = "填充"
L["UIPANEL_BAR_PADDING_DESC"] = "设置图标和计时条间距."
L["UIPANEL_BAR_SHOWICON"] = "显示图标"
L["UIPANEL_BAR_SHOWICON_DESC"] = "禁用此设置可隐藏纹理，冷却时钟和其他类似组件。"
L["UIPANEL_BARTEXTURE"] = "计量条材质"
L["UIPANEL_COLUMNS"] = "列"
L["UIPANEL_COMBATCONFIG"] = "允许在战斗中进行设置"
L["UIPANEL_COMBATCONFIG_DESC"] = [=[启用这个选项就可以在战斗中对TellMeWhen进行设置.

注意,该选项会让插件强制加载设置模块, 内存的占用以及插件加载的时间都会随之增加.

所有角色的配置文件共同使用该选项.

|cff7fffff需要重新加载UI|cffff5959才能生效.|r]=]
L["UIPANEL_DELGROUP"] = "删除该分组"
L["UIPANEL_DIMENSIONS"] = "尺寸"
L["UIPANEL_DRAWEDGE"] = "高亮计时器指针"
L["UIPANEL_DRAWEDGE_DESC"] = "高亮冷却计时器的指针来改善可视性"
L["UIPANEL_EFFTHRESHOLD"] = "增益效率閥值"
L["UIPANEL_EFFTHRESHOLD_DESC"] = "输入增益/减益的最小时间以便在它们有很高的数值时切换到更有效的检测模式. 注意:一旦效果的数值超出所选择的数字的限定,数值较大的效果会优先显示,而不是按照设定的优先级顺序."
L["UIPANEL_FONT_DESC"] = "选择图标的叠加数量文字所使用的字体"
L["UIPANEL_FONT_HEIGHT"] = "高"
L["UIPANEL_FONT_HEIGHT_DESC"] = [=[设置显示文字的最大高度。如果设为0将自动使用可能的最大高度。

如果这个显示文字依附于底部或顶部可能会无效。]=]
L["UIPANEL_FONT_JUSTIFY"] = "文字横向对齐校准"
L["UIPANEL_FONT_JUSTIFY_DESC"] = "设置该文字显示方案中文字的横向对齐位置校准(左/中/右)."
L["UIPANEL_FONT_JUSTIFYV"] = "文字垂直对齐校准"
L["UIPANEL_FONT_JUSTIFYV_DESC"] = "设置该文字显示方案中文字的垂直对齐位置校准(左/中/右)."
L["UIPANEL_FONT_OUTLINE"] = "字体描边"
L["UIPANEL_FONT_OUTLINE_DESC2"] = "设置文字显示方案的轮廓样式。"
L["UIPANEL_FONT_ROTATE"] = "旋转"
L["UIPANEL_FONT_ROTATE_DESC"] = [=[设置你想要文字显示旋转的度数。

此方法不是暴雪自带的功能，所以可能发生一些奇怪的错误，我们也只能做到这了，好运。]=]
L["UIPANEL_FONT_SHADOW"] = "阴影偏移"
L["UIPANEL_FONT_SHADOW_DESC"] = "更改文字阴影的偏移数值,设置为0则禁用阴影效果."
L["UIPANEL_FONT_SIZE"] = "字体大小"
L["UIPANEL_FONT_SIZE_DESC2"] = "改变字体大小."
L["UIPANEL_FONT_WIDTH"] = "宽"
L["UIPANEL_FONT_WIDTH_DESC"] = [=[设置显示文字的最大宽度。如果设为0将自动使用可能的最大宽度。

如果这个显示文字依附于左右两侧可能会无效。]=]
L["UIPANEL_FONT_XOFFS"] = "X偏移"
L["UIPANEL_FONT_XOFFS_DESC"] = "描点的X轴偏移值"
L["UIPANEL_FONT_YOFFS"] = "Y偏移"
L["UIPANEL_FONT_YOFFS_DESC"] = "描点的Y轴偏移值"
L["UIPANEL_FONTFACE"] = "字体"
L["UIPANEL_FORCEDISABLEBLIZZ"] = "禁用暴雪冷却文字"
L["UIPANEL_FORCEDISABLEBLIZZ_DESC"] = "强制关闭暴雪内置的冷却文字显示。它在你安装了有此类功能的插件时会自动开启禁用。"
L["UIPANEL_GLYPH"] = "雕文"
L["UIPANEL_GLYPH_DESC"] = "检测你是否激活了某一特定的雕文."
L["UIPANEL_GROUP_QUICKSORT_DEFAULT"] = "按照ID排列"
L["UIPANEL_GROUP_QUICKSORT_DURATION"] = "按照持续时间排列"
L["UIPANEL_GROUP_QUICKSORT_SHOWN"] = "显示的图标靠前"
L["UIPANEL_GROUPALPHA"] = "分组不透明度"
L["UIPANEL_GROUPALPHA_DESC"] = [=[设置整个分组的不透明度等级.

此选项对图标原本的功能没有任何影响,仅改变这个分组所有图标的外观.

如果你要隐藏整个分组并且仍然允许此分组下的图标正常运作,请将此选项设置为0(该选项有点类似于图标设置中的%q).]=]
L["UIPANEL_GROUPNAME"] = "重命名此分组"
L["UIPANEL_GROUPRESET"] = "重置位置"
L["UIPANEL_GROUPS"] = "分组"
L["UIPANEL_GROUPS_DROPDOWN"] = "选择/创建分组"
L["UIPANEL_GROUPS_DROPDOWN_DESC"] = [=[使用此菜单加载要配置的其他组，或创建新组。

您也可以|cff7fffff右键点击|r在屏幕上的图标加载该图标的组。]=]
L["UIPANEL_GROUPS_GLOBAL"] = "|cff00c300共用|r分组"
L["UIPANEL_GROUPSORT"] = "图标排列"
L["UIPANEL_GROUPSORT_ADD"] = "增加优先级"
L["UIPANEL_GROUPSORT_ADD_DESC"] = "为分组新增一个图标优先级排序."
L["UIPANEL_GROUPSORT_ADD_NOMORE"] = "无可用优先级"
L["UIPANEL_GROUPSORT_ALLDESC"] = [=[|cff7fffff点击|r更改此排序优先级的方向。
|cff7fffff点击并拖动|r重新排列。

拖动到底部删除。]=]
L["UIPANEL_GROUPSORT_alpha"] = "不透明度"
L["UIPANEL_GROUPSORT_alpha_1"] = "透明靠前"
L["UIPANEL_GROUPSORT_alpha_-1"] = "不透明靠前"
L["UIPANEL_GROUPSORT_alpha_DESC"] = "分组将根据图标的不透明度来排列"
L["UIPANEL_GROUPSORT_duration"] = "持续时间"
L["UIPANEL_GROUPSORT_duration_1"] = "短持续时间靠前"
L["UIPANEL_GROUPSORT_duration_-1"] = "长持续时间靠前"
L["UIPANEL_GROUPSORT_duration_DESC"] = "分组将根据图标剩余的持续时间来排列."
L["UIPANEL_GROUPSORT_fakehidden"] = "%s"
L["UIPANEL_GROUPSORT_fakehidden_1"] = "总是隐藏靠后"
L["UIPANEL_GROUPSORT_fakehidden_-1"] = "总是隐藏靠前"
L["UIPANEL_GROUPSORT_fakehidden_DESC"] = "按 %q 设置的状态对组进行排序。"
L["UIPANEL_GROUPSORT_id"] = "图标ID"
L["UIPANEL_GROUPSORT_id_1"] = "低IDs靠前"
L["UIPANEL_GROUPSORT_id_-1"] = "高IDs靠前"
L["UIPANEL_GROUPSORT_id_DESC"] = "分组将根据图标ID数字来排列."
L["UIPANEL_GROUPSORT_PRESETS"] = "选择预设值..."
L["UIPANEL_GROUPSORT_PRESETS_DESC"] = "从预设排序优先级列表中选择以应用于此图标。"
L["UIPANEL_GROUPSORT_shown"] = "显示"
L["UIPANEL_GROUPSORT_shown_1"] = "隐藏的图标靠前"
L["UIPANEL_GROUPSORT_shown_-1"] = "显示的图标靠前"
L["UIPANEL_GROUPSORT_shown_DESC"] = "分组将根据图标是否显示来排列."
L["UIPANEL_GROUPSORT_stacks"] = "叠加数量"
L["UIPANEL_GROUPSORT_stacks_1"] = "低堆叠靠前"
L["UIPANEL_GROUPSORT_stacks_-1"] = "高堆叠靠前"
L["UIPANEL_GROUPSORT_stacks_DESC"] = "分组将根据每个图标的叠加数量来排列."
L["UIPANEL_GROUPSORT_value"] = "数值"
L["UIPANEL_GROUPSORT_value_1"] = "低数值靠前"
L["UIPANEL_GROUPSORT_value_-1"] = "高数值靠前"
L["UIPANEL_GROUPSORT_value_DESC"] = "按进度条值对组进行排序。 这是 %s 图标类型提供的值。"
L["UIPANEL_GROUPSORT_valuep"] = "百分比数值"
L["UIPANEL_GROUPSORT_valuep_1"] = "低值％优先"
L["UIPANEL_GROUPSORT_valuep_-1"] = "高值％优先"
L["UIPANEL_GROUPSORT_valuep_DESC"] = "按进度条值百分比对组进行排序。 这是 %s 图标类型提供的值。"
L["UIPANEL_GROUPTYPE"] = "分组显示方式"
L["UIPANEL_GROUPTYPE_BAR"] = "计时条"
L["UIPANEL_GROUPTYPE_BAR_DESC"] = "分组使用图标+进度条的方式来显示."
L["UIPANEL_GROUPTYPE_BARV"] = "垂直计量条"
L["UIPANEL_GROUPTYPE_BARV_DESC"] = "在分组中的图标将会显示垂直的计量条。"
L["UIPANEL_GROUPTYPE_ICON"] = "图标"
L["UIPANEL_GROUPTYPE_ICON_DESC"] = "分组使用TellMeWhen传统的图标方式来显示."
L["UIPANEL_HIDEBLIZZCDBLING"] = "禁用暴雪自带的冷却完成动画"
L["UIPANEL_HIDEBLIZZCDBLING_DESC"] = [=[禁止暴雪增加的计时器冷却结束时的闪光效果。

此效果暴雪添加于6.2版本。]=]
L["UIPANEL_ICONS"] = "图标"
L["UIPANEL_ICONSPACING"] = "图标间距"
L["UIPANEL_ICONSPACING_DESC"] = "同组图标之间的间隔距离"
L["UIPANEL_ICONSPACINGX"] = "图标横向间隔"
L["UIPANEL_ICONSPACINGY"] = "图标纵向间隔"
L["UIPANEL_LEVEL"] = "框体优先级"
L["UIPANEL_LEVEL_DESC"] = "在组的层次内，应该绘制的等级。"
L["UIPANEL_LOCK"] = "锁定位置"
L["UIPANEL_LOCK_DESC"] = "锁定该组,禁止移动或改变比例."
L["UIPANEL_LOCKUNLOCK"] = "锁定/解锁插件"
L["UIPANEL_MAINOPT"] = "主选项"
L["UIPANEL_ONLYINCOMBAT"] = "仅在战斗中显示"
L["UIPANEL_PERFORMANCE"] = "性能"
L["UIPANEL_POINT"] = "附着点"
L["UIPANEL_POINT2_DESC"] = "将组的 %s 锚定到锚定目标。"
L["UIPANEL_POSITION"] = "位置"
L["UIPANEL_PRIMARYSPEC"] = "主天赋"
L["UIPANEL_PROFILES"] = "配置文件"
L["UIPANEL_PTSINTAL"] = "天赋使用点数(非天赋树)"
L["UIPANEL_PVPTALENTLEARNED"] = "已学荣誉天赋"
L["UIPANEL_RELATIVEPOINT"] = "附着位置"
L["UIPANEL_RELATIVEPOINT2_DESC"] = "将组锚到 %s 的锚定目标的。"
L["UIPANEL_RELATIVETO"] = "附着框体"
L["UIPANEL_RELATIVETO_DESC"] = [=[输入'/framestack'来观察当前鼠标指针所在框体的提示信息,以便寻找需要输入文本框的框体名称.

需要更多帮助,请访问http://www.wowpedia.org/API_Region_SetPoint]=]
L["UIPANEL_RELATIVETO_DESC_GUIDINFO"] = "当前值是另一分组的唯一标识符。它是在该分组右键点击并拖拽到另一分组并且\"依附到\"选项被选中时设置的。 "
L["UIPANEL_ROLE_DESC"] = "勾选此项允许在你当前专精可以担任这个职责时显示分组。"
L["UIPANEL_ROWS"] = "行"
L["UIPANEL_SCALE"] = "比例"
L["UIPANEL_SECONDARYSPEC"] = "副天赋"
L["UIPANEL_SHOWCONFIGWARNING"] = "显示设置模式警告"
L["UIPANEL_SPEC"] = "双天赋"
L["UIPANEL_SPECIALIZATION"] = "天赋类型"
L["UIPANEL_SPECIALIZATIONROLE"] = "专精职责"
L["UIPANEL_SPECIALIZATIONROLE_DESC"] = "检测你当前专精所能满足的职责（坦克，治疗，伤害输出）。"
L["UIPANEL_STRATA"] = "框体层级"
L["UIPANEL_STRATA_DESC"] = "应该绘制组的UI的层。"
L["UIPANEL_SUBTEXT2"] = [=[图标在锁定后开始工作.
在解除锁定时,你可以移动图标分组(或更改大小),右键点击图标打开设置页面.

你可以输入'/tellmewhen'或'/tmw'来锁定/解除锁定.]=]
L["UIPANEL_TALENTLEARNED"] = "已学天赋"
L["UIPANEL_TOOLTIP_COLUMNS"] = "设置在本组中的图标列数"
L["UIPANEL_TOOLTIP_GROUPRESET"] = "重置该组的位置跟比例"
L["UIPANEL_TOOLTIP_ONLYINCOMBAT"] = "勾选此项使该分组仅在战斗中显示"
L["UIPANEL_TOOLTIP_ROWS"] = "设置在本组中的图标行数"
L["UIPANEL_TOOLTIP_UPDATEINTERVAL"] = "设置图标显示/隐藏,透明度,条件等的更新频率(秒).0为最快.低端电脑请自重,设置数值过低会使帧数明显降低."
L["UIPANEL_TREE_DESC"] = "勾选来允许该组在某个天赋树激活时显示，或者不勾选让它在天赋树没激活时隐藏。"
L["UIPANEL_UPDATEINTERVAL"] = "更新间隔"
L["UIPANEL_USE_PROFILE"] = "使用个人档设置"
L["UIPANEL_WARNINVALIDS"] = "提示无效的图标"
L["UIPANEL_WARNINVALIDS_DESC"] = [=[如果勾选此项， TellMeWhen会在检测到你的图标存在无效的设置时警告你。

非常推荐开启这个选项，某些错误的设置可能会让你的电脑变得非常卡。]=]
L["UNDO"] = "撤消"
L["UNDO_DESC"] = "取消最后所做的更改操作。"
L["UNITCONDITIONS"] = "单位条件"
L["UNITCONDITIONS_DESC"] = [=[点击以便设置条件在上面输入的全部单位中筛选出你想用于检测的每个单位.

译者注:
单位条件可用于像是检测团队中哪几个人缺少耐力,或者像是检测团队中的某个坦克中了魔法/疾病等等,这只是我随便举的两个例子,实际应用范围更大.(两个例子的前提都有在单位框中输入了player,raid1-40,party1-4)]=]
L["UNITCONDITIONS_STATICUNIT"] = "<图标单位>"
L["UNITCONDITIONS_STATICUNIT_DESC"] = "该条件将检测正在被图标检测中的每个单位。"
L["UNITCONDITIONS_STATICUNIT_TARGET"] = "<图标单位>的目标"
L["UNITCONDITIONS_STATICUNIT_TARGET_DESC"] = "该条件将检查图标正在检测之中的每个单位的目标."
L["UNITCONDITIONS_TAB_DESC"] = "设置条件只让那些你要使用到的单位通过."
L["UNITTWO"] = "第二单位"
L["UNKNOWN_GROUP"] = "<未知/不可用分组>"
L["UNKNOWN_ICON"] = "<未知/不可用图标>"
L["UNKNOWN_UNKNOWN"] = "<未知???>"
L["UNNAMED"] = "(未命名)"
L["UP"] = "上"
L["VALIDITY_CONDITION_DESC"] = "条件中检测的图标是无效的 >>>"
L["VALIDITY_CONDITION2_DESC"] = "第%d个条件>>>"
L["VALIDITY_ISINVALID"] = "."
L["VALIDITY_META_DESC"] = "整合图标中检测的第%d个图标是无效的 >>>"
L["WARN_DRMISMATCH"] = [=[警告!你正在检测递减的法术来自两个不同的已知分类.

在同一个递减图标中,用于检测的所有法术应当使用同一递减分类才能使图标正常运行.

检测到下列你所使用的法术及其分类:]=]
L["WATER"] = "水之图腾"
L["worldboss"] = "首领"

elseif locale == "zhTW" then
L["!!Main Addon Description"] = "為冷卻、增益/減益及其他各個方面提供視覺、聽覺以及文字上的通知。"
L["ABSORBAMT"] = "護盾吸收量"
L["ABSORBAMT_DESC"] = "檢查單位上的護盾的吸收總量。"
L["ACTIVE"] = "%d 作用中"
L["ADDONSETTINGS_DESC"] = "配置所有通用插件的設置。"
L["AIR"] = "風之圖騰"
L["ALLOWCOMM"] = "允許圖示匯入"
L["ALLOWCOMM_DESC"] = "允許另一個TellMeWhen使用者給你發送數據。"
L["ALLOWVERSIONWARN"] = "新版本通知"
L["ALPHA"] = "可見度"
L["ANCHOR_CURSOR_DUMMY"] = "TellMeWhen虛擬遊標錨點"
L["ANCHOR_CURSOR_DUMMY_DESC"] = [=[這是一個虛擬的遊標，作用是幫你定位圖示。

在使用「遊標對象」單位時，利用該遊標定位群組非常有用。

你只需|cff7fffff右鍵點擊並拖拽|r一個圖示到遊標上即可將該圖示組依附到遊標。

由於暴雪的bug，冷卻時鐘動畫在移動後可能不能正常使用，依附遊標的圖示最好禁用它。

|cff7fffff左鍵點擊並拖拽：|r移動遊標。]=]
L["ANCHORTO"] = "依附框架"
L["ANIM_ACTVTNGLOW"] = "圖示：啟用邊框"
L["ANIM_ACTVTNGLOW_DESC"] = "在圖示上顯示暴雪的法術激活邊框。"
L["ANIM_ALPHASTANDALONE"] = "可見度"
L["ANIM_ALPHASTANDALONE_DESC"] = "設定動畫可視度的最大值。"
L["ANIM_ANCHOR_NOT_FOUND"] = "動畫無法依附到框架「%q」。 當前圖示是否沒有使用到這個框架？"
L["ANIM_ANIMSETTINGS"] = "設定"
L["ANIM_ANIMTOUSE"] = "使用的動畫"
L["ANIM_COLOR"] = "顏色/可視度"
L["ANIM_COLOR_DESC"] = "設定閃光的顏色和可視度。"
L["ANIM_DURATION"] = "動畫持續時間"
L["ANIM_DURATION_DESC"] = "設定動畫觸發後持續顯示多久。"
L["ANIM_FADE"] = "淡入淡出閃光"
L["ANIM_FADE_DESC"] = [=[勾選此項使每個閃光之間平滑的淡入淡出。不勾選則直接閃光。

（譯者註：具體的差別請自行進行區分，我測試的效果除了第一次閃光之外，後面的閃光區別並不明顯。）]=]
L["ANIM_ICONALPHAFLASH"] = "圖示：可見度閃爍"
L["ANIM_ICONALPHAFLASH_DESC"] = "通過改變圖示的可視度達到閃爍提示的效果。"
L["ANIM_ICONBORDER"] = "圖示：邊框"
L["ANIM_ICONBORDER_DESC"] = "在圖示上生成一個有顏色的邊框。"
L["ANIM_ICONCLEAR"] = "圖示：停止動畫"
L["ANIM_ICONCLEAR_DESC"] = "停止當前圖示正在播放的所有動畫效果。"
L["ANIM_ICONFADE"] = "圖示：淡入/淡出"
L["ANIM_ICONFADE_DESC"] = "在選定的事件發生時圖示可見度將會漸變。"
L["ANIM_ICONFLASH"] = "圖示：顏色閃爍"
L["ANIM_ICONFLASH_DESC"] = "利用顏色重疊在整個圖示上閃爍，達到提示的效果。"
L["ANIM_ICONOVERLAYIMG"] = "圖示：圖像重疊"
L["ANIM_ICONOVERLAYIMG_DESC"] = "在圖示上重疊顯示自訂圖像。"
L["ANIM_ICONSHAKE"] = "圖示：震動"
L["ANIM_ICONSHAKE_DESC"] = "在事件觸發時震動圖示。"
L["ANIM_INFINITE"] = "無限重複播放"
L["ANIM_INFINITE_DESC"] = [=[勾選此項將會重複播放動畫直到同個圖示上另一相同類型的動畫開始播放，或是在「%q」觸發之後才會停止。

說明：比如在事件「開始」中設定了「圖示：顏色閃爍」，並且勾選了「無限重複播放」，在事件「結束」設定了「圖示：顏色閃爍」（持續時間3秒），事件「開始」中的「無限重複播放」就會在事件「結束」的動畫播放結束後停止。 假如在同個圖示中沒有設定相同類型的動畫那就只能在「圖示：停止動畫」觸發之後才會停止播放。如果還是不明白，就這樣理解，同個圖示中相同類型的動畫只會存在一個，後面觸發的會覆寫掉前面觸發的。]=]
L["ANIM_MAGNITUDE"] = "震動幅度"
L["ANIM_MAGNITUDE_DESC"] = "設定震動的幅度需要多猛烈。"
L["ANIM_PERIOD"] = "閃光週期"
L["ANIM_PERIOD_DESC"] = [=[設定每次閃爍應當持續多久 - 閃爍的顯示時間或消退時間。

如果設定為0則不閃爍或淡出。]=]
L["ANIM_PIXELS"] = "%s 像素"
L["ANIM_SCREENFLASH"] = "螢幕：閃爍"
L["ANIM_SCREENFLASH_DESC"] = "利用顏色重疊在整個遊戲螢幕上閃爍，達到提示的效果。"
L["ANIM_SCREENSHAKE"] = "螢幕：震動"
L["ANIM_SCREENSHAKE_DESC"] = [=[在事件觸發時震動整個遊戲螢幕。

注意：螢幕震動只能在離開戰鬥後使用，或者在你登入之後沒有啟用名條的情況下使用。

（第一點囉嗦的解釋：如果你在登入之後按下顯示名條的快捷鍵或者名條原本就已經啟用了，就無法在戰鬥中使用螢幕震動如果你需要在戰鬥中使用請繼續往下看。

第二點囉嗦的解釋：如果一定要在戰鬥中使用螢幕震動請先關閉在「ESC->介面->名稱」中有關顯示單位名條的選項，然後重登，登入之後切記不可以按到任何顯示名條的快捷鍵。）]=]
L["ANIM_SECONDS"] = "%s秒"
L["ANIM_SIZE_ANIM"] = "邊框大小"
L["ANIM_SIZE_ANIM_DESC"] = "設定邊框的尺寸大小為多少。"
L["ANIM_SIZEX"] = "圖像寬度"
L["ANIM_SIZEX_DESC"] = "設定圖像的寬度為多少。"
L["ANIM_SIZEY"] = "圖像高度"
L["ANIM_SIZEY_DESC"] = "設定圖像的高度為多少。"
L["ANIM_TAB"] = "動畫"
L["ANIM_TAB_DESC"] = "設定需要​​播放的動畫效果。它們當中有些作用於圖示，有些則是作用於整個熒幕。"
L["ANIM_TEX"] = "材質"
L["ANIM_TEX_DESC"] = [=[選擇你要用於覆蓋圖示的材質。

你可以輸入一個材質路徑，例如'Interface/Icons/spell_nature_healingtouch'， 假如材質路徑為'Interface/Icons'可以只輸入'spell_nature_healingtouch'。

你也能使用放在WoW資料夾中的自訂材質（請在該欄位輸入材質的相對路徑，如：「tmw/ccc.tga」），僅支援尺寸為2的N次方（32， 64， 128，等）並且類型為.tga和.blp的材質檔案。]=]
L["ANIM_THICKNESS"] = "邊框粗細"
L["ANIM_THICKNESS_DESC"] = "設定邊框的粗細為多少。（一個圖示的預設尺寸為30。）"
L["ANN_CHANTOUSE"] = "使用頻道"
L["ANN_EDITBOX"] = "要輸出的文字內容"
L["ANN_EDITBOX_DESC"] = "輸入通知事件觸發時你想輸出的文字內容。"
L["ANN_EDITBOX_WARN"] = "在此輸入你想要輸出的文字內容"
L["ANN_FCT_DESC"] = "使用暴雪的浮動戰鬥文字功能輸出。必須先啟用介面選項中的文字輸出。"
L["ANN_NOTEXT"] = "<暫無文字>"
L["ANN_SHOWICON"] = "顯示圖示材質"
L["ANN_SHOWICON_DESC"] = "一些文字目標能連同文字內容一起顯示一個材質。勾選此項啟用該功能。"
L["ANN_STICKY"] = "靜態訊息"
L["ANN_SUB_CHANNEL"] = "輸出位置"
L["ANN_TAB"] = "文字"
L["ANN_TAB_DESC"] = "設定要輸出的文字。包括暴雪的文字頻道、UI框體以及其他的一些插件。"
L["ANN_WHISPERTARGET"] = "悄悄話目標"
L["ANN_WHISPERTARGET_DESC"] = "輸入你想要密語的玩家名字， 僅可密語同伺服器/同陣營的玩家。"
L["ASCENDING"] = "升序"
L["ASPECT"] = "守護"
L["AURA"] = "光環"
L["BACK_IE"] = "轉到上一個"
L["BACK_IE_DESC"] = [=[載入上一個編輯過的圖示

%s |T%s:0|t.]=]
L["Bleeding"] = "流血效果"
L["BOTTOM"] = "下"
L["BOTTOMLEFT"] = "左下"
L["BOTTOMRIGHT"] = "右下"
L["BUFFCNDT_DESC"] = "只有第一個法術會被檢查，其他的將全部被忽略。"
L["BUFFTOCHECK"] = "要檢查的增益"
L["BUFFTOCOMP1"] = "進行比較的第一個增益"
L["BUFFTOCOMP2"] = "進行比較的第二個增益"
L["BURNING_EMBERS_FRAGMENTS"] = "燃火餘燼碎片"
L["BURNING_EMBERS_FRAGMENTS_DESC"] = [=[一個完整的燃火餘燼由十個碎片所組成。

假如你有一個半的燃火餘燼（由十五個餘燼碎片組成），你要監視全部的餘燼碎片時，可能需要使用此條件。]=]
L["CACHING"] = "TellMeWhen正在快取和篩選遊戲中的所有法術。這只需要在每次魔獸世界補丁升級之後完成一次。您可以使用下方的滑桿加快或減慢過程。"
L["CACHINGSPEED"] = "法術快取速度（每幀法術）："
L["CASTERFORM"] = "施法者形態"
L["CENTER"] = "中間"
L["CHANGELOG"] = "更新紀錄"
L["CHANGELOG_DESC"] = "顯示TellMeWhen當前和之前版本的變動列表。"
L["CHANGELOG_INFO2"] = [=[歡迎使用 TellMeWhen v%s!
<br/><br/>
在你確認完更新訊息後, 點擊標簽 %s 或底部的標簽 %s 開始設置TellMeWhen。]=]
L["CHANGELOG_LAST_VERSION"] = "以前安裝的版本"
L["CHAT_FRAME"] = "聊天視窗"
L["CHAT_MSG_CHANNEL"] = "聊天頻道"
L["CHAT_MSG_CHANNEL_DESC"] = "將輸出到一個聊天頻道，例如交易頻道或是你加入的某個自訂頻道。"
L["CHAT_MSG_SMART"] = "智能頻道"
L["CHAT_MSG_SMART_DESC"] = "此頻道會自行選擇最合適的輸出頻道。（僅限於：戰場，團隊，隊伍，或者說）"
L["CHOOSEICON"] = "選擇一個用於檢查的圖示"
L["CHOOSEICON_DESC"] = [=[|cff7fffff點擊：|r來選擇一個圖示/群組。
|cff7fffff左鍵點擊並拖拽：|r以滾動方式改變排序。
|cff7fffff右鍵點擊並拖拽：|r以常見方式交換位置。

譯者註：如果搞不清楚，只需要用常見方式（右鍵點擊並拖拽）來改變排序即可。]=]
L["CHOOSENAME_DIALOG"] = [=[輸入你想讓此圖示監視的名稱或者ID，你可以利用半形分號（;）輸入多個條目（名稱、ID、同類型的任意組合）。

你可以使用減號從同類型法術中單獨移除某個法術，例如"Slowed; -暈眩"。

你可以|cff7fffff按住Shift再按左鍵點選|r法術/物品/聊天連結或者拖拽法術/物品添加到此編輯框中。]=]
L["CHOOSENAME_DIALOG_PETABILITIES"] = "|cFFFF5959寵物技能|r必須使用法術ID。"
L["CLEU_"] = "任意事件"
L["CLEU_CAT_AURA"] = "增益/減益"
L["CLEU_CAT_CAST"] = "施法"
L["CLEU_CAT_MISC"] = "其他"
L["CLEU_CAT_SPELL"] = "法術"
L["CLEU_CAT_SWING"] = "近戰/遠程"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MASK"] = "操控者關係"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MINE"] = "操控者關係：玩家（你）"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MINE_DESC"] = "勾選以排除那些你控制的單位。"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_OUTSIDER"] = "操控者關係：外人"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_OUTSIDER_DESC"] = "勾選以排除那些與你同組的某人控制的單位。"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_PARTY"] = "操控者關係：隊伍成員"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_PARTY_DESC"] = "勾選以排除那些你隊伍中的玩家控制的單位。"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_RAID"] = "操控者關係：團隊成員"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_RAID_DESC"] = "勾選以排除那些你團隊中的玩家控制的單位。"
L["CLEU_COMBATLOG_OBJECT_CONTROL_MASK"] = "操控者"
L["CLEU_COMBATLOG_OBJECT_CONTROL_NPC"] = "操控者：伺服器"
L["CLEU_COMBATLOG_OBJECT_CONTROL_NPC_DESC"] = "勾選以排除那些伺服器控制的單位（包括它們的寵物跟守護者）。"
L["CLEU_COMBATLOG_OBJECT_CONTROL_PLAYER"] = "操控者：人類"
L["CLEU_COMBATLOG_OBJECT_CONTROL_PLAYER_DESC"] = "勾選以排除那些人類控制的單位（包括他們的寵物跟守護者），這裡是指真正的人類，不是遊戲中的人類種族，如果你教會了猴子、猩猩玩魔獸世界的話，可以算上它們。"
L["CLEU_COMBATLOG_OBJECT_FOCUS"] = "其他：你的專注目標"
L["CLEU_COMBATLOG_OBJECT_FOCUS_DESC"] = "勾選以排除那個你設定為專注目標的單位。"
L["CLEU_COMBATLOG_OBJECT_MAINASSIST"] = "其他：主助攻"
L["CLEU_COMBATLOG_OBJECT_MAINASSIST_DESC"] = "勾選以排除團隊中被標記為主助攻的單位。"
L["CLEU_COMBATLOG_OBJECT_MAINTANK"] = "其他：主坦克"
L["CLEU_COMBATLOG_OBJECT_MAINTANK_DESC"] = "勾選以排除團隊中被標記為主坦克的單位。"
L["CLEU_COMBATLOG_OBJECT_NONE"] = "其他：未知單位"
L["CLEU_COMBATLOG_OBJECT_NONE_DESC"] = "勾選以排除WoW客戶端完全未知的單位，還可以排除在遊戲客戶端中沒有提供單位的一些事件。"
L["CLEU_COMBATLOG_OBJECT_REACTION_FRIENDLY"] = "單位反應：友好"
L["CLEU_COMBATLOG_OBJECT_REACTION_FRIENDLY_DESC"] = "勾選以排除那些對你反應是友好的單位。"
L["CLEU_COMBATLOG_OBJECT_REACTION_HOSTILE"] = "單位反應：敵對"
L["CLEU_COMBATLOG_OBJECT_REACTION_HOSTILE_DESC"] = "勾選以排除那些對你反應是敵對的單位。"
L["CLEU_COMBATLOG_OBJECT_REACTION_MASK"] = "單位反應"
L["CLEU_COMBATLOG_OBJECT_REACTION_NEUTRAL"] = "單位反應：中立"
L["CLEU_COMBATLOG_OBJECT_REACTION_NEUTRAL_DESC"] = "勾選以排除那些對你反應是中立的單位。"
L["CLEU_COMBATLOG_OBJECT_TARGET"] = "其他：你的目標"
L["CLEU_COMBATLOG_OBJECT_TARGET_DESC"] = "勾選以排除你當前的目標單位。"
L["CLEU_COMBATLOG_OBJECT_TYPE_GUARDIAN"] = "單位類型：守護者"
L["CLEU_COMBATLOG_OBJECT_TYPE_GUARDIAN_DESC"] = "勾選以排除守護者。 守護者指那些會保護操控者但是不能直接被控制的單位。"
L["CLEU_COMBATLOG_OBJECT_TYPE_MASK"] = "單位類型"
L["CLEU_COMBATLOG_OBJECT_TYPE_NPC"] = "單位類型：NPC"
L["CLEU_COMBATLOG_OBJECT_TYPE_NPC_DESC"] = "勾選以排除非玩家角色。"
L["CLEU_COMBATLOG_OBJECT_TYPE_OBJECT"] = "單位類型：對象"
L["CLEU_COMBATLOG_OBJECT_TYPE_OBJECT_DESC"] = "勾選以排除像是陷阱，魚點等其他沒有被劃分到「單位類型」中的其他任何東西。"
L["CLEU_COMBATLOG_OBJECT_TYPE_PET"] = "單位類型：寵物"
L["CLEU_COMBATLOG_OBJECT_TYPE_PET_DESC"] = "勾選以排除寵物。 寵物指那些會保護操控者並且可以直接被控制的單位。"
L["CLEU_COMBATLOG_OBJECT_TYPE_PLAYER"] = "單位類型：玩家角色"
L["CLEU_COMBATLOG_OBJECT_TYPE_PLAYER_DESC"] = "勾選以排除玩家角色。"
L["CLEU_CONDITIONS_DESC"] = [=[配置每個單元必須通過的條件，以便進行檢查。

這些條件僅在輸入要檢查的單位，並且所有輸入的單位均為單位ID時可用 - 不能在這些條件下使用名稱。]=]
L["CLEU_CONDITIONS_DEST"] = "目標條件"
L["CLEU_CONDITIONS_SOURCE"] = "來源條件"
L["CLEU_DAMAGE_SHIELD"] = "傷害護盾"
L["CLEU_DAMAGE_SHIELD_DESC"] = "此事件在傷害護盾對一個單位造成傷害時發生。 （%s，%s，等等，但是不包括%s）"
L["CLEU_DAMAGE_SHIELD_MISSED"] = "傷害護盾未命中"
L["CLEU_DAMAGE_SHIELD_MISSED_DESC"] = "此事件在傷害護盾對一個單位造成傷害失敗時發生。 （%s，%s，等等，但是不包括%s）"
L["CLEU_DAMAGE_SPLIT"] = "傷害分擔"
L["CLEU_DAMAGE_SPLIT_DESC"] = "此事件在傷害被兩個或更多個單位分擔時發生。"
L["CLEU_DESTUNITS"] = "用於檢查的目標單位"
L["CLEU_DESTUNITS_DESC"] = "選擇你想要圖示檢查的事件目標單位，可以保留空白讓圖示檢查任意的事件目標單位。"
L["CLEU_DIED"] = "死亡"
L["CLEU_ENCHANT_APPLIED"] = "附魔應用"
L["CLEU_ENCHANT_APPLIED_DESC"] = "此事件所指為暫時性武器附魔，像是盜賊的毒藥和薩滿的武器強化。"
L["CLEU_ENCHANT_REMOVED"] = "附魔移除"
L["CLEU_ENCHANT_REMOVED_DESC"] = "此事件所指為暫時性武器附魔，像是盜賊的毒藥和薩滿的武器強化。"
L["CLEU_ENVIRONMENTAL_DAMAGE"] = "環境傷害"
L["CLEU_ENVIRONMENTAL_DAMAGE_DESC"] = "包括來自熔岩，掉落，溺水以及疲勞的傷害。"
L["CLEU_EVENTS"] = "用於檢查的事件"
L["CLEU_EVENTS_ALL"] = "全部事件"
L["CLEU_EVENTS_DESC"] = "選擇那些你想要圖示檢查的戰鬥事件。"
L["CLEU_FLAGS_DESC"] = "可以排除列表中包含的某種屬性的單位使其無法觸發圖示。如果勾選排除某種屬性的單位，圖示將不會處理那個單位相關的事件。"
L["CLEU_FLAGS_DEST"] = "排除"
L["CLEU_FLAGS_SOURCE"] = "排除"
L["CLEU_HEADER"] = "戰鬥事件篩選"
L["CLEU_HEADER_DEST"] = "目標單位"
L["CLEU_HEADER_SOURCE"] = "來源單位"
L["CLEU_NOFILTERS"] = "%s圖示在%s沒有定義任何篩選條件。你需要定義至少一個篩選條件，否則無法正常使用。"
L["CLEU_PARTY_KILL"] = "隊伍擊殺"
L["CLEU_PARTY_KILL_DESC"] = "當隊伍中的某人殺死某個怪物時觸發。"
L["CLEU_RANGE_DAMAGE"] = "遠程攻擊傷害"
L["CLEU_RANGE_MISSED"] = "遠程攻擊未命中"
L["CLEU_SOURCEUNITS"] = "用於檢查的來源單位"
L["CLEU_SOURCEUNITS_DESC"] = "選擇你想要圖示檢查的事件來源單位，可以保留空白讓圖示檢查任意的事件來源單位。"
L["CLEU_SPELL_AURA_APPLIED"] = "效果獲得（指目標單位獲得某增益/減益，來源單位為施放者）"
L["CLEU_SPELL_AURA_APPLIED_DOSE"] = "效果堆疊"
L["CLEU_SPELL_AURA_BROKEN"] = "效果被打破（物理）"
L["CLEU_SPELL_AURA_BROKEN_SPELL"] = "效果被打破（法術）"
L["CLEU_SPELL_AURA_BROKEN_SPELL_DESC"] = [=[此事件在一個效果被法術傷害打破時發生（通常是指某種控場技能）。

圖示會篩選出被打破的效果;在文字輸出/顯示時你可以使用標籤[Extra]替代這個效果。]=]
L["CLEU_SPELL_AURA_REFRESH"] = "效果刷新"
L["CLEU_SPELL_AURA_REMOVED"] = "效果移除"
L["CLEU_SPELL_AURA_REMOVED_DOSE"] = "效果堆疊移除"
L["CLEU_SPELL_CAST_FAILED"] = "施法失敗"
L["CLEU_SPELL_CAST_START"] = "開始施法"
L["CLEU_SPELL_CAST_START_DESC"] = [=[此事件在開始施放一個法術時發生。

注意：為了防止可能出現的遊戲框架濫用，暴雪禁用了此事件的目標單位，所以你不能篩選它們。]=]
L["CLEU_SPELL_CAST_SUCCESS"] = "法術施放成功"
L["CLEU_SPELL_CAST_SUCCESS_DESC"] = "此事件在法術施法成功時發生。"
L["CLEU_SPELL_CREATE"] = "法術製造"
L["CLEU_SPELL_CREATE_DESC"] = "此事件在一個對像被製造時發生，例如獵人的陷阱跟法師的傳送門。"
L["CLEU_SPELL_DAMAGE"] = "法術傷害"
L["CLEU_SPELL_DAMAGE_CRIT"] = "法術致命一擊"
L["CLEU_SPELL_DAMAGE_CRIT_DESC"] = "此事件在任意法術傷害造成致命一擊時發生，會跟%q事件同時觸發。"
L["CLEU_SPELL_DAMAGE_DESC"] = "此事件在任意法術造成傷害時發生。"
L["CLEU_SPELL_DAMAGE_NONCRIT"] = "法術未致命一擊"
L["CLEU_SPELL_DAMAGE_NONCRIT_DESC"] = "此事件在任意法術傷害沒有造成致命一擊時發生，會跟%q事件同時觸發。"
L["CLEU_SPELL_DISPEL"] = "驅散"
L["CLEU_SPELL_DISPEL_DESC"] = [=[此事件在一個效果被驅散時發生。

圖示會篩選出被驅散的效果;在文字輸出/顯示時你可以使用標籤[Extra]替代這個效果。]=]
L["CLEU_SPELL_DISPEL_FAILED"] = "驅散失敗"
L["CLEU_SPELL_DISPEL_FAILED_DESC"] = [=[此事件在驅散某一效果失敗時發生。

圖示會篩選出這個驅散失敗的效果;在文字輸出/顯示時你可以使用標籤[Extra]替代這個效果。]=]
L["CLEU_SPELL_DRAIN"] = "抽取資源"
L["CLEU_SPELL_DRAIN_DESC"] = "此事件在資源從一個單位移除時發生（資源指生命值/法力值/怒氣/能量等）。"
L["CLEU_SPELL_ENERGIZE"] = "獲得資源"
L["CLEU_SPELL_ENERGIZE_DESC"] = "此事件在一個單位獲得資源時發生（資源指生命值/法力值/怒氣/能量等）。"
L["CLEU_SPELL_EXTRA_ATTACKS"] = "獲得額外攻擊"
L["CLEU_SPELL_EXTRA_ATTACKS_DESC"] = "此事件在你獲得額外的近戰攻擊時發生。"
L["CLEU_SPELL_HEAL"] = "治療"
L["CLEU_SPELL_INSTAKILL"] = "秒殺"
L["CLEU_SPELL_INTERRUPT"] = "中斷 - 被中斷的法術"
L["CLEU_SPELL_INTERRUPT_DESC"] = [=[此事件在施法被中斷時發生。

圖示會篩選出被中斷施法的法術;在文字輸出/顯示時你可以使用標籤[Extra]替代這個法術。

請注意兩個中斷事件的區別- 當一個法術被中斷時兩個事件都會發生，但是篩選出的法術會有所不同。]=]
L["CLEU_SPELL_INTERRUPT_SPELL"] = "中斷 - 造成中斷的法術"
L["CLEU_SPELL_INTERRUPT_SPELL_DESC"] = [=[此事件在施法被中斷時發生。

圖示會篩選出造成中斷施法的法術;在文字輸出/顯示時你可以使用標籤[Extra]替代這個法術。

請注意兩個中斷事件的區別- 當一個法術被中斷時兩個事件都會發生，但是篩選出的法術會有所不同。]=]
L["CLEU_SPELL_LEECH"] = "資源吸取"
L["CLEU_SPELL_LEECH_DESC"] = "此事件在從一個單位移除資源給另一單位時發生（資源指生命值/法力值/怒氣/能量等）。"
L["CLEU_SPELL_MISSED"] = "法術未命中"
L["CLEU_SPELL_PERIODIC_DAMAGE"] = "傷害（週期）"
L["CLEU_SPELL_PERIODIC_DRAIN"] = "抽取資源（週期）"
L["CLEU_SPELL_PERIODIC_ENERGIZE"] = "獲得資源（週期）"
L["CLEU_SPELL_PERIODIC_HEAL"] = "治療（週期）"
L["CLEU_SPELL_PERIODIC_LEECH"] = "資源吸取（週期）"
L["CLEU_SPELL_PERIODIC_MISSED"] = "傷害（週期）未命中"
L["CLEU_SPELL_REFLECT"] = "法術反射"
L["CLEU_SPELL_REFLECT_DESC"] = [=[此事件在你反射一個對你施放的法術時發生。

來源單位是反射法術者，目標單位是法術被反射的施法者。]=]
L["CLEU_SPELL_RESURRECT"] = "復活"
L["CLEU_SPELL_RESURRECT_DESC"] = "此事件在某個單位從死亡中被復活時發生。"
L["CLEU_SPELL_STOLEN"] = "效果被竊取"
L["CLEU_SPELL_STOLEN_DESC"] = [=[此事件在增益被竊取時發生，很可能來自%s。

圖示會篩選出那個被竊取的法術。]=]
L["CLEU_SPELL_SUMMON"] = "法術召喚"
L["CLEU_SPELL_SUMMON_DESC"] = "此事件在一個NPC被召喚或者生成時發生。"
L["CLEU_SWING_DAMAGE"] = "近戰攻擊傷害"
L["CLEU_SWING_MISSED"] = "近戰攻擊未命中"
L["CLEU_TIMER"] = "設定事件的計時器"
L["CLEU_TIMER_DESC"] = [=[設定圖示計時器在事件發生時的持續時間。

你也可以在%q編輯框中使用「法術:持續時間」語法指定一個持續時間，在事件處理你篩選出的那些法術時使用。

如果法術沒有指定持續時間，或者你沒有篩選任何法術（編輯框為空白），那將使用這個持續時間。]=]
L["CLEU_UNIT_DESTROYED"] = "單位被摧毀"
L["CLEU_UNIT_DESTROYED_DESC"] = "此事件在一個單位被摧毀時發生（例如薩滿的圖騰）。"
L["CLEU_UNIT_DIED"] = "單位死亡"
L["CLEU_WHOLECATEGORYEXCLUDED"] = [=[你排除了%q分類中的所有條目，這將導致圖示不再處理任何事件。

取消勾選至少一個條目使圖示可以正常運作。]=]
L["CLICK_TO_EDIT"] = "|cff7fffff點擊|r編輯。"
L["CMD_CHANGELOG"] = "更新日誌"
L["CMD_DISABLE"] = "停用"
L["CMD_ENABLE"] = "啟用"
L["CMD_OPTIONS"] = "選項"
L["CMD_PROFILE"] = "設定檔"
L["CMD_PROFILE_INVALIDPROFILE"] = "無法找到名為「%q」的設定檔! （譯者註：注意區分大小寫）"
L["CMD_PROFILE_INVALIDPROFILE_SPACES"] = [=[提示：如果設定檔包含空格，請在前後加上半形引號。

例如：
/tmw profile "阿光光 - 地獄吼"
或
/tmw 設定檔 "薇璇 - 地獄吼"]=]
L["CMD_TOGGLE"] = "切換"
L["CNDT_DEPRECATED_DESC"] = "條件%s無效。這可能是因為遊戲機制改變所造成的，請移除它或者更改為其他條件。"
L["CNDT_MULTIPLEVALID"] = "你可以利用分號分隔的方式輸入多個用於檢查的名稱或ID。"
L["CNDT_ONLYFIRST"] = "僅檢查第一個法術/物品，使用分號分隔的列表不適用此條件類型。"
L["CNDT_RANGE"] = "單位距離"
L["CNDT_RANGE_DESC"] = "使用LibRangeCheck-2.0檢查單位的大致距離．單位不存在時條件將會返回否（false）。"
L["CNDT_RANGE_IMPRECISE"] = "%d 碼。 （|cffff1300不太準確|r）"
L["CNDT_RANGE_PRECISE"] = "%d 碼。 （|cff00c322準確|r）"
L["CNDT_SLIDER_DESC_CLICKSWAP_TOMANUAL"] = "|cff7fffff點擊右鍵|r切換到手動輸入模式。"
L["CNDT_SLIDER_DESC_CLICKSWAP_TOSLIDER"] = "|cff7fffff點擊右鍵|r切換到滑動條選擇模式。"
L["CNDT_SLIDER_DESC_CLICKSWAP_TOSLIDER_DISALLOWED"] = "僅允許在手動輸入時輸入大於%s的數值。（較大的數值顯示在暴雪滑動條上會變得很奇怪）"
L["CNDT_TOTEMNAME"] = "圖騰名稱"
L["CNDT_TOTEMNAME_DESC"] = [=[設定為空白檢查所選的圖騰類型中的全部圖騰。

如果需要檢查指定的圖騰，請輸入一個圖騰名稱或是利用分號分隔開的名稱列表。]=]
L["CNDT_UNKNOWN_DESC"] = "你的設定中有一個名為%s的標識無法找到對應的條件。可能是因為使用了舊版本的TMW或者該條件已經被移除。"
L["CNDTCAT_ARCHFRAGS"] = "考古學碎片"
L["CNDTCAT_ATTRIBUTES_PLAYER"] = "玩家屬性/狀態"
L["CNDTCAT_ATTRIBUTES_UNIT"] = "單位屬性/狀態"
L["CNDTCAT_BOSSMODS"] = "首領模塊"
L["CNDTCAT_BUFFSDEBUFFS"] = "增益/減益"
L["CNDTCAT_CURRENCIES"] = "通貨"
L["CNDTCAT_FREQUENTLYUSED"] = "常用條件"
L["CNDTCAT_LOCATION"] = "組隊/區域"
L["CNDTCAT_MISC"] = "其他"
L["CNDTCAT_RESOURCES"] = "能量類型"
L["CNDTCAT_SPELLSABILITIES"] = "法術/物品"
L["CNDTCAT_STATS"] = "戰鬥統計（人物屬性）"
L["CNDTCAT_TALENTS"] = "職業/天賦"
L["CODESNIPPET_ADD2"] = "新 %s 片段"
L["CODESNIPPET_ADD2_DESC"] = "|cff7fffff點擊|r新增 %s 片段。"
L["CODESNIPPET_AUTORUN"] = "登入時自動執行"
L["CODESNIPPET_AUTORUN_DESC"] = "如果啟用，此片段將在TWM載入時運行(運行時間為在玩家登入事件PLAYER_LOGIN時，但是在圖標跟分組創建之前)。"
L["CODESNIPPET_CODE"] = "用於執行的Lua程式碼"
L["CODESNIPPET_DELETE"] = "刪除片段"
L["CODESNIPPET_DELETE_CONFIRM"] = "你確定要刪除程式碼片段（%q）？"
L["CODESNIPPET_EDIT_DESC"] = "|cff7fffff點擊|r 編輯此片段。"
L["CODESNIPPET_GLOBAL"] = "共用片段"
L["CODESNIPPET_ORDER"] = "執行順序"
L["CODESNIPPET_ORDER_DESC"] = [=[設定此程式碼片段的執行順序（相對於其他的片段而言）。

%s和%s都將基於這個數值來執行。

如果兩個片段使用了相同的順序，無法確認誰先執行的時候，可以使用小數。]=]
L["CODESNIPPET_PROFILE"] = "角色專用片段"
L["CODESNIPPET_RENAME"] = "程式碼片段名稱"
L["CODESNIPPET_RENAME_DESC"] = [=[為這個片段輸入一個自己容易識別的名稱。

名稱不是唯一，允許重複使用。]=]
L["CODESNIPPET_RUNAGAIN"] = "再次運行片段"
L["CODESNIPPET_RUNAGAIN_DESC"] = [=[此片段已經在進程中運行過一次。

|cff7fffff點擊|r再次運行。]=]
L["CODESNIPPET_RUNNOW"] = "執行片段"
L["CODESNIPPET_RUNNOW_DESC"] = [=[點擊執行此程式碼片段。

按住|cff7fffffCtrl|r繞過片段已經執行的確認。]=]
L["CODESNIPPETS"] = "Lua程式碼片段"
L["CODESNIPPETS_DEFAULTNAME"] = "新片段"
L["CODESNIPPETS_DESC"] = [=[此功能允許你編寫Lua程式碼並在TellMeWhen載入時執行。

它是一個進階功能，可以讓Lua熟練工如魚得水，也可以讓完全不懂Lua的人匯入其他TellMeWhen使用者分享出來的片段。

可用在像是編寫一個特定的過程用於Lua條件中（必須把它們定義在TMW.CNDT.Env）。

片段可被定義為角色專用或公用（共用片段會在所有角色執行）。]=]
L["CODESNIPPETS_DESC_SHORT"] = "輸入的LUA代碼會在TellMeWhen初始化的時候運行。"
L["CODESNIPPETS_IMPORT_GLOBAL"] = "新的共用片段"
L["CODESNIPPETS_IMPORT_GLOBAL_DESC"] = "片段匯入為共用片段。"
L["CODESNIPPETS_IMPORT_PROFILE"] = "新的角色專用片段"
L["CODESNIPPETS_IMPORT_PROFILE_DESC"] = "片段匯入為角色專用片段。"
L["CODESNIPPETS_TITLE"] = "Lua片段（進階）"
L["CODETOEXE"] = "要執行的代碼"
L["COLOR_MSQ_COLOR"] = "使用Masque邊框顏色（整個圖示）"
L["COLOR_MSQ_COLOR_DESC"] = "勾選此項將使用Masque皮膚中設定的邊框顏色對圖示著色（假如你在皮膚設定中有使用邊框的話）。"
L["COLOR_MSQ_ONLY"] = "使用Masque邊框顏色（僅邊框）"
L["COLOR_MSQ_ONLY_DESC"] = "勾選此項將僅對圖示邊框使用Masque皮膚中設定的邊框顏色進行著色（假如你在皮膚設定中有使用邊框的話）。圖示不會被著色。"
L["COLOR_OVERRIDE_GLOBAL"] = "覆蓋全局顏色"
L["COLOR_OVERRIDE_GLOBAL_DESC"] = "勾選以配置獨立於全局定義顏色的顏色。"
L["COLOR_OVERRIDE_GROUP"] = "覆蓋分組顏色"
L["COLOR_OVERRIDE_GROUP_DESC"] = "勾選以配置與為圖標組指定的顏色無關的顏色。"
L["COLOR_USECLASS"] = "使用職業顏色"
L["COLOR_USECLASS_DESC"] = "勾選使用所檢測單位的職業顏色來給進度條著色。"
L["COLORPICKER_BRIGHTNESS"] = "亮度"
L["COLORPICKER_BRIGHTNESS_DESC"] = "設置顏色的亮度(有時也稱為值)"
L["COLORPICKER_DESATURATE"] = "減少飽和度"
L["COLORPICKER_DESATURATE_DESC"] = "在應用顏色之前對紋理去飽和，允許您重新著色紋理，而不是著色。"
L["COLORPICKER_HUE"] = "色度"
L["COLORPICKER_HUE_DESC"] = "設置顏色的色度"
L["COLORPICKER_ICON"] = "預覽"
L["COLORPICKER_OPACITY"] = "透明度"
L["COLORPICKER_OPACITY_DESC"] = "設置顏色的透明度(有時稱為alpha)。"
L["COLORPICKER_RECENT"] = "最近使用的顏色"
L["COLORPICKER_RECENT_DESC"] = [=[|cff7fffff點擊|r讀取這個顏色。
|cff7fffff右鍵點擊|r從列表移除這個顏色。]=]
L["COLORPICKER_SATURATION"] = "飽和度"
L["COLORPICKER_SATURATION_DESC"] = "設置顏色的飽和度。"
L["COLORPICKER_STRING"] = "16進制字串"
L["COLORPICKER_STRING_DESC"] = "獲取/設置 當前顏色的十六進制(A)RGB"
L["COLORPICKER_SWATCH"] = "顏色"
L["COMPARISON"] = "比較"
L["CONDITION_COUNTER"] = "用於檢查的計數器"
L["CONDITION_COUNTER_EB_DESC"] = "輸入你想要檢查的計數器名稱。"
L["CONDITION_QUESTCOMPLETE"] = "任務完成"
L["CONDITION_QUESTCOMPLETE_DESC"] = "檢查一個任務是否已完成。"
L["CONDITION_QUESTCOMPLETE_EB_DESC"] = [=[輸入你想檢查的任務ID​​。

任務ID可以在魔獸世界數據庫網站獲得，像是db.178.com（中文）和www.wowhead.com（英文）。

例如：http:////db.178.com/wow/tw/quest/32615.html<更多更多龐大的恐龍骨頭>任務ID為32615。]=]
L["CONDITION_TIMEOFDAY"] = "一天中的時間"
L["CONDITION_TIMEOFDAY_DESC"] = [=[此條件將使用當前時間與設定時間進行比較。

用於比較的時間是當地時間（基於你的電腦時鐘）。它不會獲取伺服器時間。]=]
L["CONDITION_TIMER"] = "用於檢查的計時器"
L["CONDITION_TIMER_EB_DESC"] = "輸入你想用於檢查的計時器名稱。"
L["CONDITION_TIMERS_FAIL_DESC"] = [=[設定條件無法通過以後圖示計時器的持續時間

（譯者註：圖示在條件每次通過/無法通過後都會重新計時，另外在預設的情況下圖示的顯示只會根據條件通過情況來改變，設定的持續時間不會影響到圖示的顯示情況，不會在設定的持續時間倒數結束後隱藏圖示，如果想要圖示在計時結束後隱藏，需要勾選「僅在計時器作用時顯示」，這是4.5.3版本新加入的功能。）]=]
L["CONDITION_TIMERS_SUCCEED_DESC"] = [=[設定條件成功通過以後圖示計時器的持續時間

（譯者註：圖示在條件每次通過/無法通過後都會重新計時，另外在預設的情況下圖示的顯示只會根據條件通過情況來改變，設定的持續時間不會影響到圖示的顯示情況，不會在設定的持續時間倒數結束後隱藏圖示，如果想要圖示在計時結束後隱藏，需要勾選'僅在計時器作用時顯示'，這是4.5.3版本新加入的功能。）]=]
L["CONDITION_WEEKDAY"] = "星期幾"
L["CONDITION_WEEKDAY_DESC"] = [=[檢查今天是不是星期幾。

用於檢查的時間是當地時間（基於你的電腦時鐘）。它不會獲取伺服器時間。]=]
L["CONDITIONALPHA_METAICON"] = "條件未通過時"
L["CONDITIONALPHA_METAICON_DESC"] = [=[此可見度用於條件未通過時。

條件可在%q選項卡中設定。]=]
L["CONDITIONPANEL_ABSOLUTE"] = "（非百分比/絕對值）"
L["CONDITIONPANEL_ADD"] = "新增條件"
L["CONDITIONPANEL_ADD2"] = "點擊增加一個條件"
L["CONDITIONPANEL_ALIVE"] = "單位存活"
L["CONDITIONPANEL_ALIVE_DESC"] = "此條件會在單位還活著時通過"
L["CONDITIONPANEL_ALTPOWER"] = "特殊能量"
L["CONDITIONPANEL_ALTPOWER_DESC"] = "這是浩劫與重生某些首領戰遇到的特殊能量，像是丘加利的腐化值跟亞特拉米德的音波值。"
L["CONDITIONPANEL_AND"] = "同時"
L["CONDITIONPANEL_ANDOR"] = "同時/或者"
L["CONDITIONPANEL_ANDOR_DESC"] = "|cff7fffff點擊|r切換邏輯運算符 同時/或者（And/Or）"
L["CONDITIONPANEL_AUTOCAST"] = "寵物自動施法"
L["CONDITIONPANEL_AUTOCAST_DESC"] = "檢查指定寵物技能是否自動釋放中。"
L["CONDITIONPANEL_BIGWIGS_ENGAGED"] = "Big Wigs - 首領戰開始"
L["CONDITIONPANEL_BIGWIGS_ENGAGED_DESC"] = [=[檢查Big Wigs激活的首領戰。

請輸入首領戰的全名到「用於檢查的首領戰」。]=]
L["CONDITIONPANEL_BIGWIGS_TIMER"] = "Big Wigs - 計時器"
L["CONDITIONPANEL_BIGWIGS_TIMER_DESC"] = [=[檢測Big Wigs首領模塊計時器的持續時間。

請輸入計時器全名到「用於檢查的計時器」。]=]
L["CONDITIONPANEL_BITFLAGS_ALWAYS"] = "總是如此"
L["CONDITIONPANEL_BITFLAGS_CHECK"] = "否定選擇"
L["CONDITIONPANEL_BITFLAGS_CHECK_DESC"] = [=[檢查此設置，以反轉用於檢查此條件的邏輯。

默認情況下，這種情況將通過是否有任何選擇的選項是正確的。

如果選中該設置，限制將會通過如果所有選擇的選項是錯誤的。]=]
L["CONDITIONPANEL_BITFLAGS_CHOOSECLASS"] = "選擇職業……"
L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_CONTINENT"] = "選擇大陸..."
L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_RAIDICON"] = "選擇圖標..."
L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_TYPES"] = "選擇類型……"
L["CONDITIONPANEL_BITFLAGS_CHOOSERACE"] = "選擇種族..."
L["CONDITIONPANEL_BITFLAGS_NEVER"] = "無 - 不要精確"
L["CONDITIONPANEL_BITFLAGS_NOT"] = "非"
L["CONDITIONPANEL_BITFLAGS_SELECTED"] = "|cff7fffff已選|r："
L["CONDITIONPANEL_BLIZZEQUIPSET"] = "套裝已裝備（裝備管理器）"
L["CONDITIONPANEL_BLIZZEQUIPSET_DESC"] = "檢查暴雪裝備管理器中的套裝設定是否已裝備。"
L["CONDITIONPANEL_BLIZZEQUIPSET_INPUT"] = "套裝名稱"
L["CONDITIONPANEL_BLIZZEQUIPSET_INPUT_DESC"] = [=[輸入你要檢查的暴雪裝備管理器中的套裝名稱。

只允許輸入一個套裝，注意|cFFFF5959區分大小寫|r。

譯者註：可以從右側的提示與建議列表中直接選擇套裝名稱。]=]
L["CONDITIONPANEL_CASTCOUNT"] = "法術施放次數"
L["CONDITIONPANEL_CASTCOUNT_DESC"] = "檢查一個單位施放某個法術的次數。"
L["CONDITIONPANEL_CASTTOMATCH"] = "用於比較的法術"
L["CONDITIONPANEL_CASTTOMATCH_DESC"] = [=[在此輸入一個法術名稱使該條件只在施放的法術名稱跟輸入的法術名稱完全相符時才可通過。

你可以保留空白來檢查任意的法術施放/引導法術（不包括瞬發法術）。]=]
L["CONDITIONPANEL_CLASS"] = "單位職業"
L["CONDITIONPANEL_CLASSIFICATION"] = "單位分類"
L["CONDITIONPANEL_CLASSIFICATION_DESC"] = "檢測一個單位是否為精英、稀有、世界首領。"
L["CONDITIONPANEL_COMBAT"] = "單位在戰鬥中"
L["CONDITIONPANEL_COMBO"] = "連擊點數"
L["CONDITIONPANEL_COUNTER_DESC"] = "檢查「計數器」通知處理所創建和修改的計數器的值。"
L["CONDITIONPANEL_CREATURETYPE"] = "單位生物類型"
L["CONDITIONPANEL_CREATURETYPE_DESC"] = [=[你可以利用分號（;）輸入多個生物類型用於檢查。

輸入的生物類型必須同滑鼠提示資訊上所顯示的完全相同。

此條件會在所選單位的生物類型與你設定的任意一種生物類型相符時通過。]=]
L["CONDITIONPANEL_CREATURETYPE_LABEL"] = "生物類型"
L["CONDITIONPANEL_DBM_ENGAGED"] = "Deadly Boss Mods - 首領戰開始"
L["CONDITIONPANEL_DBM_ENGAGED_DESC"] = [=[檢查Deadly Boss Mods激活的首領戰。

請輸入首領戰的全名到「用於檢查的首領戰」。]=]
L["CONDITIONPANEL_DBM_TIMER"] = "Deadly Boss Mods - 計時器"
L["CONDITIONPANEL_DBM_TIMER_DESC"] = [=[檢查Deadly Boss Mods計時器的持續時間。

請輸入計時器的全名到「用於檢查的計時器」。]=]
L["CONDITIONPANEL_DEFAULT"] = "選擇條件類型……"
L["CONDITIONPANEL_ECLIPSE_DESC"] = "蝕星蔽月有一個範圍在-100（月蝕）到100（日蝕）。如果你想讓圖示在有80月蝕的時候顯示請輸入-80。"
L["CONDITIONPANEL_EQUALS"] = "等於"
L["CONDITIONPANEL_EXISTS"] = "單位存在"
L["CONDITIONPANEL_GREATER"] = "大於"
L["CONDITIONPANEL_GREATEREQUAL"] = "大於或者等於"
L["CONDITIONPANEL_GROUPSIZE"] = "副本大小"
L["CONDITIONPANEL_GROUPSIZE_DESC"] = [=[檢查針對當前實際調整的隊伍成員數量。


這包括當前的彈性團隊組合的調整。]=]
L["CONDITIONPANEL_GROUPTYPE"] = "隊伍類型"
L["CONDITIONPANEL_GROUPTYPE_DESC"] = "檢查你所在的隊伍類型(單獨,小隊或團隊)。"
L["CONDITIONPANEL_ICON"] = "圖示顯示"
L["CONDITIONPANEL_ICON_DESC"] = [=[此條件檢查指定的圖示為顯示或隱藏。

如果你不想顯示被檢查的圖示，請在被檢查圖示的圖示編輯器勾選「%q」。

The group of the icon being checked must be shown in order to check the icon， even if the condition is set to false。]=]
L["CONDITIONPANEL_ICON_HIDDEN"] = "隱藏"
L["CONDITIONPANEL_ICON_SHOWN"] = "顯示"
L["CONDITIONPANEL_ICONHIDDENTIME"] = "圖示隱藏時間"
L["CONDITIONPANEL_ICONHIDDENTIME_DESC"] = [=[此條件檢查指定的圖示隱藏了多久時間。

如果你不想顯示被檢查的圖示，請在被檢查圖示的圖示編輯器勾選 %q。]=]
L["CONDITIONPANEL_ICONSHOWNTIME"] = "圖示顯示時間"
L["CONDITIONPANEL_ICONSHOWNTIME_DESC"] = [=[此條件檢查指定的圖示顯示了多久時間。

如果你不想顯示被檢查的圖示，請在被檢查圖示的圖示編輯器勾選 %q。]=]
L["CONDITIONPANEL_INPETBATTLE"] = "在寵物對戰中"
L["CONDITIONPANEL_INSTANCETYPE"] = "副本類型"
L["CONDITIONPANEL_INSTANCETYPE_DESC"] = "檢測你所在的地下城的類型。此條件包含任何地下城或團隊副本的難度設置。"
L["CONDITIONPANEL_INSTANCETYPE_LEGACY"] = "%s （神話難度）"
L["CONDITIONPANEL_INSTANCETYPE_NONE"] = "戶外"
L["CONDITIONPANEL_INTERRUPTIBLE"] = "可斷法"
L["CONDITIONPANEL_ITEMRANGE"] = "單位在物品範圍內"
L["CONDITIONPANEL_LASTCAST"] = "最後使用的技能"
L["CONDITIONPANEL_LASTCAST_ISNTSPELL"] = "不匹配"
L["CONDITIONPANEL_LASTCAST_ISSPELL"] = "匹配"
L["CONDITIONPANEL_LESS"] = "小於"
L["CONDITIONPANEL_LESSEQUAL"] = "小於或者等於"
L["CONDITIONPANEL_LEVEL"] = "單位等級"
L["CONDITIONPANEL_LOC_CONTINENT"] = "大陸"
L["CONDITIONPANEL_LOC_SUBZONE"] = "子區域"
L["CONDITIONPANEL_LOC_SUBZONE_BOXDESC"] = "輸入您要檢查的子區域。 用分號分隔多個子區域。"
L["CONDITIONPANEL_LOC_SUBZONE_DESC"] = "檢查您當前的子區域。 請注意：有時，您可能不在子區域。"
L["CONDITIONPANEL_LOC_SUBZONE_LABEL"] = "輸入子區域進行檢查"
L["CONDITIONPANEL_LOC_ZONE"] = "地區"
L["CONDITIONPANEL_LOC_ZONE_DESC"] = "輸入您要檢查的區域。 用分號分隔多個區域。"
L["CONDITIONPANEL_LOC_ZONE_LABEL"] = "輸入用於檢測的區域"
L["CONDITIONPANEL_MANAUSABLE"] = "法術可用（法力值/能量/等是否夠用）"
L["CONDITIONPANEL_MANAUSABLE_DESC"] = [=[如果一個法術的可用基於你的主要能量（法力、能量、怒氣、符能、集中值等）。

不會再檢查基於第二能量的可用性（符文、聖能、真氣等）。]=]
L["CONDITIONPANEL_MAX"] = "（最大值）"
L["CONDITIONPANEL_MOUNTED"] = "在坐騎上"
L["CONDITIONPANEL_NAME"] = "單位名字"
L["CONDITIONPANEL_NAMETOMATCH"] = "用於比較的名字"
L["CONDITIONPANEL_NAMETOOLTIP"] = "你可以在每個名字後面加上分號（;）以便輸入多個需要比較的名字。 其中任何一個名字相符時此條件都會通過。"
L["CONDITIONPANEL_NOTEQUAL"] = "不等於"
L["CONDITIONPANEL_NPCID"] = "單位NPC編號"
L["CONDITIONPANEL_NPCID_DESC"] = [=[檢查指定的單位NPC編號。

NPC編號可以在Wowhead之類的魔獸世界數據庫找到（例如http:////www.wowhead.com/npc=62943）。

玩家與某些單位沒有NPC編號，在此條件中的返回值為0。]=]
L["CONDITIONPANEL_NPCIDTOMATCH"] = "用於比較的編號"
L["CONDITIONPANEL_NPCIDTOOLTIP"] = "你可以利用分號（;）輸入多個NPC編號。條件會在任意一個編號相符時通過。"
L["CONDITIONPANEL_OLD"] = "<|cffff1300舊版本|r>"
L["CONDITIONPANEL_OLD_DESC"] = "<|cffff1300舊版本|r> - 此條件有新版本可用。"
L["CONDITIONPANEL_OPERATOR"] = "運算符"
L["CONDITIONPANEL_OR"] = "或者"
L["CONDITIONPANEL_OVERLAYED"] = "法術啟用邊框"
L["CONDITIONPANEL_OVERLAYED_DESC"] = "檢測一個法術是否有啟用邊框效果（就是在你動作條有黃色的邊邊的技能）。"
L["CONDITIONPANEL_OVERRBAR"] = "動作條效果"
L["CONDITIONPANEL_OVERRBAR_DESC"] = "檢查你主要動作條上的一些動畫效果，不包含寵物戰鬥。"
L["CONDITIONPANEL_PERCENT"] = "（百分比）"
L["CONDITIONPANEL_PERCENTOFCURHP"] = "當前生命值百分比"
L["CONDITIONPANEL_PERCENTOFMAXHP"] = "最大生命百分比"
L["CONDITIONPANEL_PETMODE"] = "寵物攻擊模式"
L["CONDITIONPANEL_PETMODE_DESC"] = "檢查當前寵物的攻擊模式。"
L["CONDITIONPANEL_PETMODE_NONE"] = "沒有寵物"
L["CONDITIONPANEL_PETSPEC"] = "寵物種類"
L["CONDITIONPANEL_PETSPEC_DESC"] = "檢測你當前寵物的專精類型。"
L["CONDITIONPANEL_POWER"] = "基本資源"
L["CONDITIONPANEL_POWER_DESC"] = "檢查單位為德魯伊時在貓形態的能量，或者單位為戰士時的怒氣等等。"
L["CONDITIONPANEL_PVPFLAG"] = "開啟PVP的單位"
L["CONDITIONPANEL_RAIDICON"] = "單位團隊標記"
L["CONDITIONPANEL_RAIDICON_DESC"] = "檢測一個單位的團隊標記圖標。"
L["CONDITIONPANEL_REMOVE"] = "移除此條件"
L["CONDITIONPANEL_RESTING"] = "休息狀態"
L["CONDITIONPANEL_ROLE"] = "單位隊伍職責"
L["CONDITIONPANEL_ROLE_DESC"] = "檢測你隊伍、團隊中一個玩家所選擇的角色類型。"
L["CONDITIONPANEL_RUNES"] = "符文數量"
L["CONDITIONPANEL_RUNES_CHECK_DESC"] = [=[正常情況下，第一行的符文無論是不是死亡符文，在符合條件設定時都會通過。

啟用這個選項強制第一行的符文僅匹配非死亡符文。]=]
L["CONDITIONPANEL_RUNES_DESC3"] = "使用此條件僅在特定數量的符文可用時顯示圖示。"
L["CONDITIONPANEL_RUNESLOCK"] = "鎖定符文數量"
L["CONDITIONPANEL_RUNESLOCK_DESC"] = "使用此條件僅在特定數量的符文被鎖定時顯示圖示（等待恢復）。"
L["CONDITIONPANEL_RUNESRECH"] = "恢復中符文數量"
L["CONDITIONPANEL_RUNESRECH_DESC"] = "使用此條件僅在特定數量的符文恢復中時顯示圖示。"
L["CONDITIONPANEL_SPELLCOST"] = "施法所需能量"
L["CONDITIONPANEL_SPELLCOST_DESC"] = "檢測施法所需能量。像是法力值、怒氣、能量等等。"
L["CONDITIONPANEL_SPELLRANGE"] = "單位在法術範圍內"
L["CONDITIONPANEL_SWIMMING"] = "游泳狀態"
L["CONDITIONPANEL_THREAT_RAW"] = "單位威脅值 - 原始"
L["CONDITIONPANEL_THREAT_RAW_DESC"] = [=[此條件用來檢查你對一個單位的原始威脅值百分比。

近戰玩家仇恨失控（OT）的威脅值為110%
遠程玩家仇恨失控（OT）的威脅值為130%]=]
L["CONDITIONPANEL_THREAT_SCALED"] = "單位威脅值 - 比例"
L["CONDITIONPANEL_THREAT_SCALED_DESC"] = [=[此條件用來檢查你對一個單位的威脅值百分比比例。

100%表示你正在坦這個單位。]=]
L["CONDITIONPANEL_TIMER_DESC"] = "檢查通知事件「計時器」中的計時器所創建和變更的數值。"
L["CONDITIONPANEL_TRACKING"] = "追蹤"
L["CONDITIONPANEL_TRACKING_DESC"] = "檢測你小地圖當前所追蹤的類型。"
L["CONDITIONPANEL_TYPE"] = "類型"
L["CONDITIONPANEL_UNIT"] = "單位"
L["CONDITIONPANEL_UNITISUNIT"] = "單位比較"
L["CONDITIONPANEL_UNITISUNIT_DESC"] = "此條件在兩個編輯框輸入的單位為同一角色時通過。（例子：編輯框1為「targettarget」，編輯框2為「player」，當「目標的目標」為「玩家」時此條件通過。）"
L["CONDITIONPANEL_UNITISUNIT_EBDESC"] = "在此編輯框輸入需要與所指定的第一單位進行比較的第二單位。"
L["CONDITIONPANEL_UNITRACE"] = "單位種族"
L["CONDITIONPANEL_UNITSPEC"] = "單位專精"
L["CONDITIONPANEL_UNITSPEC_CHOOSEMENU"] = "選擇專精……"
L["CONDITIONPANEL_UNITSPEC_DESC"] = "此條件僅可用於戰場和競技場。"
L["CONDITIONPANEL_VALUEN"] = "值"
L["CONDITIONPANEL_VEHICLE"] = "單位控制載具"
L["CONDITIONPANEL_ZONEPVP"] = "區域PvP類型"
L["CONDITIONPANEL_ZONEPVP_DESC"] = "檢測區域的PvP類型（例如：爭奪中、聖域、戰鬥區域等）"
L["CONDITIONPANEL_ZONEPVP_FFA"] = "自由PVP"
L["CONDITIONS"] = "條件"
L["CONFIGMODE"] = "TellMeWhen正處於設定模式。 在離開設定模式之前，圖示無法正常使用。 輸入'/tellmewhen'或'/tmw'可以開啟或關閉設定模式。"
L["CONFIGMODE_EXIT"] = "退出設定模式"
L["CONFIGMODE_EXITED"] = "TMW已鎖定。輸入/tmw重新進入設定模式。"
L["CONFIGMODE_NEVERSHOW"] = "不再顯示此訊息"
L["CONFIGPANEL_BACKDROP_HEADER"] = "背景材質"
L["CONFIGPANEL_CBAR_HEADER"] = "計時條覆蓋"
L["CONFIGPANEL_CLEU_HEADER"] = "戰鬥事件"
L["CONFIGPANEL_CNDTTIMERS_HEADER"] = "條件計時器"
L["CONFIGPANEL_COMM_HEADER"] = "通訊"
L["CONFIGPANEL_MEDIA_HEADER"] = "媒體"
L["CONFIGPANEL_PBAR_HEADER"] = "能量條覆蓋"
L["CONFIGPANEL_TIMER_HEADER"] = "計時器時鐘"
L["CONFIGPANEL_TIMERBAR_BARDISPLAY_HEADER"] = "計時條"
L["CONFIRM_DELETE_GENERIC_DESC"] = "%s 將被刪除。"
L["CONFIRM_DELGROUP"] = "刪除分組"
L["CONFIRM_DELLAYOUT"] = "刪除樣式"
L["CONFIRM_HEADER"] = "確定嗎？"
L["COPYGROUP"] = "複製群組"
L["COPYPOSSCALE"] = "僅複製位置/比例"
L["CrowdControl"] = "控場技能"
L["Curse"] = "詛咒"
L["DamageBuffs"] = "傷害爆發增益"
L["DamageShield"] = "傷害護盾"
L["DBRESTORED_INFO"] = [=[TellMeWhen檢測到資料庫為空或已損壞。造成此情況最可能的原因是WoW沒有正常登出。

TellMeWhen_Options對資料庫多備份了一次，以防止這樣的情況發生，因為很少會出現TellMeWhen和TellMeWhen_Options的資料庫同時損壞。

你這個創建於%s的備份已還原。]=]
L["DEBUFFTOCHECK"] = "要檢查的減益"
L["DEBUFFTOCOMP1"] = "進行比較的第一個減益"
L["DEBUFFTOCOMP2"] = "進行比較的第二個減益"
L["DEFAULT"] = "預設值"
L["DefensiveBuffs"] = "防禦性增益"
L["DefensiveBuffsAOE"] = "AOE減傷Buffs"
L["DefensiveBuffsSingle"] = "單體減傷Buffs"
L["DESCENDING"] = "降序"
L["DISABLED"] = "已停用"
L["Disease"] = "疾病"
L["Disoriented"] = "困惑"
L["DOMAIN_GLOBAL"] = "|cff00c300共用|r"
L["DOMAIN_PROFILE"] = "角色設定檔"
L["DOWN"] = "下"
L["DR-Disorient"] = "迷惑/其他"
L["DR-Incapacitate"] = "癱瘓"
L["DR-Root"] = "定身"
L["DR-Silence"] = "沉默"
L["DR-Stun"] = "擊暈"
L["DR-Taunt"] = "嘲諷"
L["DT_DOC_AuraSource"] = "返回圖示檢查的增益/減益的來源單位。最好同[Name]標籤一起使用。 （此標籤僅能用於圖示類型：%s）。"
L["DT_DOC_Counter"] = "返回TellMeWhen計數器的值。圖示通知資訊會創建或修改計數器。"
L["DT_DOC_Destination"] = "返回圖示最後一次處理過的戰鬥事件中的目標單位或名稱。同[Name]標籤一起使用效果更佳。（此標籤僅可用於圖示類型%s）"
L["DT_DOC_Duration"] = "返回圖示當前的剩餘持續時間。推薦你使用[TMWFormatDuration]。"
L["DT_DOC_Extra"] = "返回圖示最後一次處理過的戰鬥事件中的額外法術名稱。（此標籤僅可用於圖示類型%s）"
L["DT_DOC_gsub"] = [=[提供強大的Lua函式string.gsub來處理DogTags輸出的字串。

替換當前值在匹配模式中的所有實例，可使用可選參數限制替換數目。]=]
L["DT_DOC_IsShown"] = "返回一個圖示是否顯示。"
L["DT_DOC_LocType"] = "返回圖示所顯示的失去控制的效果類型（此標籤僅可用於圖示類型%s）。"
L["DT_DOC_MaxDuration"] = "返回當前圖標的最大持續時間。 這個持續時間是指剛開始時的持續時間，不是當前剩余的持續時間。"
L["DT_DOC_Name"] = "返回單位的名稱。這是一個由DogTag提供的預設[Name]標籤的加強版本。"
L["DT_DOC_Opacity"] = "返回一個圖示的可視度。返回值為0和1之間的數字。"
L["DT_DOC_PreviousUnit"] = "返回圖示所檢查的上一個單位或單位名稱（相對於與當前檢查單位來講）。同[Name]標籤一起使用效果更佳。"
L["DT_DOC_Source"] = "返回圖示最後一次處理過的戰鬥事件中的來源單位或名稱。同[Name]標籤一起使用效果更佳。 （此標籤僅可用於圖示類型%s）"
L["DT_DOC_Spell"] = "返回圖示當前所顯示數據的法術名稱或物品名稱。"
L["DT_DOC_Stacks"] = "返回圖示當前的堆疊數量"
L["DT_DOC_strfind"] = [=[提供強大的Lua函式string.find來處理DogTags輸出的字串。

返回當前值中從第幾位開始出現的第一次匹配的具體位置。]=]
L["DT_DOC_StripServer"] = "從單位名字移除伺服器名稱。這將會移除名字的破折號之後的所有文字。"
L["DT_DOC_Timer"] = "返回TellMeWhen計時器的數值。計時器一般在圖示的通知事件中被創建或更改。"
L["DT_DOC_TMWFormatDuration"] = "返回一个由TellMeWhen的時間格式處理過的字串。用於替代[FormatDuration]。"
L["DT_DOC_Unit"] = "返回當前圖示所檢查的單位或單位名稱。同[Name]標籤一起使用效果更佳。"
L["DT_DOC_Value"] = "返回圖示當前顯示的數字，此功能僅在小部分圖示類型使用。"
L["DT_DOC_ValueMax"] = "返回圖示當前顯示的數字的初始最大值，此功能僅在小部分圖示類型使用。"
L["DT_INSERTGUID_GENERIC_DESC"] = "如果你想要在一個圖示上顯示另外一個圖示的資訊，可以 |cff7fffffShift+滑鼠點擊|r那個圖示將它的唯一識別碼添加到標籤參數icon中即可。"
L["DT_INSERTGUID_TOOLTIP"] = "|cff7fffffShift+滑鼠點擊|r將這個圖示的識別碼插入到DogTag。"
L["DURATION"] = "持續時間"
L["DURATIONALPHA_DESC"] = "設定在你要求的持續時間不符合時圖示顯示的可視度。"
L["DURATIONPANEL_TITLE2"] = "持續時間限定"
L["EARTH"] = "大地圖騰"
L["ECLIPSE_DIRECTION"] = "蝕星蔽月方向"
L["elite"] = "精英"
L["ENABLINGOPT"] = "TellMeWhen選項已停用。正在重新啟用中……"
L["ENCOUNTERTOCHECK"] = "用於檢查的首領戰"
L["ENCOUNTERTOCHECK_DESC_BIGWIGS"] = "輸入首領戰的全名。在BigWig的設定跟地城手冊中都有顯示。"
L["ENCOUNTERTOCHECK_DESC_DBM"] = "輸入首領戰的全名。在聊天的拉怪、團滅、殺死或者在地下城手冊中有顯示。"
L["Enraged"] = "狂暴"
L["EQUIPSETTOCHECK"] = "用於檢查的套裝名稱（|cFFFF5959區分大小寫|r）"
L["ERROR_ACTION_DENIED_IN_LOCKDOWN"] = "無法在戰鬥中這麼做，請先啟用%q選項（輸入'/tmw options'或'/tmw 選項'）。"
L["ERROR_ANCHOR_CYCLICALDEPS"] = "%s嘗試依附到%s，但是%s的位置依賴於%s的位置，為了防止出錯TellMeWhen會將它重設到熒幕的中央。"
L["ERROR_ANCHORSELF"] = "%s嘗試依附於它自己，所以TellMeWhen會重設它的依附位置到螢幕中間以防止出現嚴重的錯誤。"
L["ERROR_INVALID_SPELLID2"] = "一個圖示正在檢查一個無效的法術ID：%s。 為免圖示發生錯誤，請移除它!"
L["ERROR_MISSINGFILE"] = "TellMeWhen需要在重開魔獸世界之後才能正常使用 %s （原因：無法找到%s）。 你要馬上重開魔獸世界嗎？"
L["ERROR_MISSINGFILE_NOREQ"] = "TellMeWhen需要在重開魔獸世界之後才能完全正常使用 %s （原因：無法找到%s）。 你要馬上重開魔獸世界嗎？"
L["ERROR_MISSINGFILE_OPT"] = [=[需要在重開魔獸世界之後才能設定TellMeWhen %s。

原因：無法找到%s。

你要馬上重開魔獸世界嗎？]=]
L["ERROR_MISSINGFILE_OPT_NOREQ"] = [=[可能需要在重開魔獸世界之後才能全面設定TellMeWhen %s。

原因：無法找到%s。

你要馬上重開魔獸世界嗎？]=]
L["ERROR_MISSINGFILE_REQFILE"] = "一個必需的檔案"
L["ERROR_NO_LOCKTOGGLE_IN_LOCKDOWN"] = "無法在戰鬥中解鎖TellMeWhen，請先啟用%q選項（輸入'/tmw options'或'/tmw 選項'）。"
L["ERROR_NOTINITIALIZED_NO_ACTION"] = "插件初始化失敗，TellMeWhen不能執行該步驟。 "
L["ERROR_NOTINITIALIZED_NO_LOAD"] = "插件初始化失敗，TellMeWhen_Options無法載入。"
L["ERROR_NOTINITIALIZED_OPT_NO_ACTION"] = "如果插件初始化失敗，TellMeWhen_Options將無法執行該動作！"
L["ERRORS_FRAME"] = "錯誤訊息框架"
L["ERRORS_FRAME_DESC"] = "輸出文字到系統的錯誤訊息框架，就是顯示%q的那個位置。"
L["EVENT_CATEGORY_CHANGED"] = "數據已改變"
L["EVENT_CATEGORY_CHARGES"] = "充能"
L["EVENT_CATEGORY_CLICK"] = "行為"
L["EVENT_CATEGORY_CONDITION"] = "條件"
L["EVENT_CATEGORY_MISC"] = "其他"
L["EVENT_CATEGORY_STACKS"] = "疊加層數"
L["EVENT_CATEGORY_TIMER"] = "計時器"
L["EVENT_CATEGORY_VISIBILITY"] = "顯示"
L["EVENT_FREQUENCY"] = "觸發頻率"
L["EVENT_FREQUENCY_DESC"] = "設定條件通過的觸發頻率（單位為秒）。"
L["EVENT_WHILECONDITIONS"] = "觸發條件"
L["EVENT_WHILECONDITIONS_DESC"] = "點擊設定條件，當它們通過時會觸發通知事件。"
L["EVENT_WHILECONDITIONS_TAB_DESC"] = "設定觸發通知事件需要的條件。"
L["EVENTCONDITIONS"] = "事件條件"
L["EVENTCONDITIONS_DESC"] = "點擊進入設定用於觸發此事件的條件。"
L["EVENTCONDITIONS_TAB_DESC"] = "設定的條件通過時則觸發此事件。"
L["EVENTHANDLER_COUNTER_TAB"] = "計數器"
L["EVENTHANDLER_COUNTER_TAB_DESC"] = "設定一個計數器。此計數器可用於條件中檢查或DogTags標籤中顯示文字。"
L["EVENTHANDLER_LUA_CODE"] = "用於執行的Lua程式碼"
L["EVENTHANDLER_LUA_CODE_DESC"] = "在此輸入事件觸發後需要執行的Lua程式碼"
L["EVENTHANDLER_LUA_LUA"] = "Lua"
L["EVENTHANDLER_LUA_LUAEVENTf"] = "Lua事件：%s"
L["EVENTHANDLER_LUA_TAB"] = "Lua（進階）"
L["EVENTHANDLER_LUA_TAB_DESC"] = "設定用於執行的Lua腳本。這是一個進階功能，需要有Lua語言編程基礎。"
L["EVENTHANDLER_TIMER_TAB"] = "計時器"
L["EVENTHANDLER_TIMER_TAB_DESC"] = "設置一個時鐘樣式的計時器。此計時器可以使用條件及顯示文字到DogTags。"
L["EVENTS_CHANGETRIGGER"] = "更改觸發器"
L["EVENTS_CHOOSE_EVENT"] = "選擇觸發器："
L["EVENTS_CHOOSE_HANDLER"] = "選擇通知事件："
L["EVENTS_CLONEHANDLER"] = "複製"
L["EVENTS_HANDLER_ADD_DESC"] = "|cff7fffff點擊：|r添加這個通知事件。"
L["EVENTS_HANDLERS_ADD"] = "新增通知事件……"
L["EVENTS_HANDLERS_ADD_DESC"] = "|cff7fffff點擊|r選擇一個通知事件新增到此圖示。"
L["EVENTS_HANDLERS_GLOBAL_DESC"] = [=[|cff7fffff點擊：|r開啟通知事件設定選項。
|cff7fffff右鍵點擊|r複製或更改事件的觸發。
|cff7fffff點擊並拖拽|r來變更排序。]=]
L["EVENTS_HANDLERS_HEADER"] = "通知事件處理器"
L["EVENTS_HANDLERS_PLAY"] = "測試通知事件"
L["EVENTS_HANDLERS_PLAY_DESC"] = "|cff7fffff點擊：|r測試通知事件"
L["EVENTS_SETTINGS_CNDTJUSTPASSED"] = "僅在條件剛通過時"
L["EVENTS_SETTINGS_CNDTJUSTPASSED_DESC"] = "除非上面設定的條件剛剛成功通過，否則阻止通知事件的觸發。"
L["EVENTS_SETTINGS_COUNTER_AMOUNT"] = "值"
L["EVENTS_SETTINGS_COUNTER_AMOUNT_DESC"] = "輸入你希望檢查的計數器被創建或修改的值。"
L["EVENTS_SETTINGS_COUNTER_HEADER"] = "計數器設定"
L["EVENTS_SETTINGS_COUNTER_NAME"] = "計數器名稱"
L["EVENTS_SETTINGS_COUNTER_NAME_DESC"] = [=[輸入計數器的名稱。如果計數器不存在，它的預設值則為0。

計數器名稱必須為小寫，並且不能有空格。

你也可以在其它地方檢查這個計數器，在條件檢查或DogTags的文字顯示標籤[Counter]中。

進階玩家：計數器保存在TMW.COUNTERS[counterName] = value中。如果你想在自訂Lua語言腳本中更改一個計數器，可調用TMW:Fire( "TMW_COUNTER_MODIFIED"， counterName )。]=]
L["EVENTS_SETTINGS_COUNTER_OP"] = "運算符"
L["EVENTS_SETTINGS_COUNTER_OP_DESC"] = "選擇計數器要執行的運算符"
L["EVENTS_SETTINGS_HEADER"] = "触发設定"
L["EVENTS_SETTINGS_ONLYSHOWN"] = "僅在圖示顯示時觸發"
L["EVENTS_SETTINGS_ONLYSHOWN_DESC"] = "勾選此項防止圖示在沒有顯示時觸發相關通知事件。"
L["EVENTS_SETTINGS_PASSINGCNDT"] = "僅在條件通過時觸發："
L["EVENTS_SETTINGS_PASSINGCNDT_DESC"] = "除非下面設定的條件成功通過，否則阻止通知事件的觸發。"
L["EVENTS_SETTINGS_PASSTHROUGH"] = "允許觸發其他事件"
L["EVENTS_SETTINGS_PASSTHROUGH_DESC"] = [=[勾選允許在觸發該通知事件後去觸發另一個通知事件，如果不勾選，則在該事件觸發並輸出了文字/音效之後，圖示將不再處理同時觸發的其他任何通知事件。

可以有例外，詳情請參閱個別事件的描述。]=]
L["EVENTS_SETTINGS_SIMPLYSHOWN"] = "僅在圖示顯示時觸發"
L["EVENTS_SETTINGS_SIMPLYSHOWN_DESC"] = [=[讓通知事件在圖示顯示時觸發。

你可以在不設定條件的情況下啟用此選項來觸發事件。

或者你也可以加上條件來決定如何觸發。]=]
L["EVENTS_SETTINGS_TIMER_HEADER"] = "計時器設定"
L["EVENTS_SETTINGS_TIMER_NAME"] = "計時器名稱"
L["EVENTS_SETTINGS_TIMER_NAME_DESC"] = [=[輸入你需要修改的計時器名稱。

計時器名稱必須為小寫字母並且不能有空格。

此計時器使用的名稱可以在其它任何地方來檢測（條件和文字顯示，像是DogTag中的[Timer]）]=]
L["EVENTS_SETTINGS_TIMER_OP_DESC"] = "選擇你想要計時器使用的運算符"
L["EVENTS_TAB"] = "通知事件"
L["EVENTS_TAB_DESC"] = "設定聲音/文字輸出/動畫的觸發器。"
L["EXPORT_ALLGLOBALGROUPS"] = "所有|cff00c300共用|r群組"
L["EXPORT_f"] = "匯出 %s"
L["EXPORT_HEADING"] = "匯出"
L["EXPORT_SPECIALDESC2"] = "其他TellMeWhen使用者只能在他們所用的版本等於或高於%s時才可匯入這些數據。"
L["EXPORT_TOCOMM"] = "到玩家"
L["EXPORT_TOCOMM_DESC"] = [=[輸入一個玩家的名字到編輯框同時選擇此選項來發送數據給他們。他們必須是你能密語的某人（同陣營，同伺服器，在線），同時他們必須已經安裝版本為4.0.0+的TellMeWhen。

你還可以輸入"GUILD"或"RAID"發送到整個公會或整個團隊（輸入時請注意區分大小寫，'GUILD'跟'RAID'中的英文字母全部都是大寫）。]=]
L["EXPORT_TOGUILD"] = "到公會"
L["EXPORT_TORAID"] = "到團隊"
L["EXPORT_TOSTRING"] = "到字串"
L["EXPORT_TOSTRING_DESC"] = "包含必要數據的字串將匯出到編輯框裡，按下CTRL+C複製它，然後到任何你想分享的地方貼上它。"
L["FALSE"] = "否"
L["fCODESNIPPET"] = "程式碼片段：%s"
L["Feared"] = "恐懼"
L["fGROUP"] = "群組：%s"
L["fGROUPS"] = "群組：%s"
L["fICON"] = "圖示：%s"
L["FIRE"] = "火焰圖騰"
L["FONTCOLOR"] = "文字顏色"
L["FONTSIZE"] = "字體大小"
L["FORWARDS_IE"] = "轉到下一個"
L["FORWARDS_IE_DESC"] = [=[載入下一個編輯過的圖示

%s |T%s:0|t.]=]
L["fPROFILE"] = "設定檔：%s"
L["FROMNEWERVERSION"] = "你匯入的數據為版本較新的TellMeWhen所創建，某些設定在更新至最新版本之前可能無法正常使用。"
L["fTEXTLAYOUT"] = "文字顯示樣式：%s"
L["GCD"] = "公共冷卻"
L["GCD_ACTIVE"] = "公共冷卻作用中"
L["GENERIC_NUMREQ_CHECK_DESC"] = "勾選以啟用並設定%s"
L["GENERICTOTEM"] = "圖騰 %d"
L["GLOBAL_GROUP_GENERIC_DESC"] = "|cff00c300共用群組|r是指在你這個魔獸世界帳號中的TellMeWhen設定檔的所有角色都可共同使用的群組。"
L["GLYPHTOCHECK"] = "要檢查的雕紋"
L["GROUP"] = "組"
L["GROUP_UNAVAILABLE"] = "|TInterface/PaperDollInfoFrame/UI-GearManager-LeaveItem-Transparent:20|t 由於其過度限制的規範/角色設置，此組無法顯示。"
L["GROUPCONDITIONS"] = "群組條件"
L["GROUPCONDITIONS_DESC"] = "設定條件進行微調，以便更好的顯示這個群組。"
L["GROUPICON"] = "群組：%s，圖示：%s"
L["GROUPSELECT_TOOLTIP"] = [=[|cff7fffff點擊|r 來編輯。

|cff7fffff點擊拖拽|r 重新排序或更改域。]=]
L["GROUPSETTINGS_DESC"] = "設定此群組。"
L["GUIDCONFLICT_DESC_PART1"] = [=[TellMeWhen檢測到下列的物件擁有相同的全域唯一識別碼（GUID）。如果你從它們其中之一調用數據可能會發生料想不到問題（例如：將它們之中的一個加入到整合圖示中）。

為了解決這個問題，請選擇某個物件重新生成GUID，原有的調用都將指向到那個沒有重新生成GUID的物件。你可能需要適當調整設定才能確保所有功能都可正常使用。]=]
L["GUIDCONFLICT_DESC_PART2"] = "你也可以自行解決這個問題（例如：刪除兩個之中的某一個）。"
L["GUIDCONFLICT_IGNOREFORSESSION"] = "忽略此設定會話衝突。"
L["GUIDCONFLICT_REGENERATE"] = "為%s重新生成GUID"
L["Heals"] = "玩家治療法術"
L["HELP_ANN_LINK_INSERTED"] = [=[你插入的連結看起來很詭異，可能是因為DogTag的格式轉換所引起。

如果輸出到暴雪頻道時連結無法正常顯示，請更改顏色代碼。]=]
L["HELP_BUFF_NOSOURCERPPM"] = [=[看來你想檢查%s，這個增益使用了RPPM系統。

由於暴雪的bug，在啟用了%q選項時，這個增益無法被檢測。

如果你想正確檢測這個增益，請禁用該設定。]=]
L["HELP_CNDT_ANDOR_FIRSTSEE"] = [=[你可以選擇兩個條件都需要通過，還是只需要某個條件通過。

|cff7fffff點擊|r此處更改條件之間的關聯方式，以達到你所需的檢查效果。]=]
L["HELP_CNDT_PARENTHESES_FIRSTSEE"] = [=[你可以組合多個條件執行複雜的檢查功能，尤其是連同%q選項一起使用。

|cff7fffff點擊|r括號將條件組合在一起，以達到你需要的檢查效果（左右括號中間的條件就是一個條件組合）。]=]
L["HELP_COOLDOWN_VOIDBOLT"] = [=[看起來你是想檢測|TInterface/Icons/ability_ironmaidens_convulsiveshadows:20|t %s的冷卻時間。

非常不幸的是暴雪的機制使它無法正常被監測到。

你需要檢測的是 |T1386548:20|t %s 的冷卻時間。

請添加一個條件檢測增益 %s ，如果你僅僅是想檢測 %s 是否可以使用的話。]=]
L["HELP_EXPORT_DOCOPY_MAC"] = "按下|cff7fffffCMD+C|r複製"
L["HELP_EXPORT_DOCOPY_WIN"] = "按下|cff7fffffCTRL+C|r複製"
L["HELP_EXPORT_MULTIPLE_COMM"] = "匯出的數據包括主要數據所需要的額外數據。想要知道包含了哪些內容，請匯出相同數據到字串後在匯入選單的「來自字串」查看即可。"
L["HELP_EXPORT_MULTIPLE_STRING"] = [=[匯出的數據包括主要數據所需要的額外數據。想要知道包含了哪些內容，請匯出相同數據到字串後在匯入選單的「來自字串」查看即可。

TellMeWhen版本7.0.0+的使用者可以一次匯入所有數據。其他人需要分開多次匯入字串。]=]
L["HELP_FIRSTUCD"] = [=[這是你第一次使用一個採取特定時間語法的圖示類型！
在添加法術到某些圖示類型的 %q 編輯框時，必須使用下列語法在法術後面指定它們的冷卻時間/持續時間：

法術:時間

例如：

「%s:120」
「%s:10; %s:24」
「%s:180」
「%s:3:00」
「62618:3:00」

用建議列表插入條目時會自動添加在滑鼠提示資訊中顯示的時間（譯者註：自動添加時間功能支援提示資訊中有顯示冷卻時間的法術以及提示資訊中有註明持續時間的大部分法術，如果一個法術同時存在上述兩種時間，會優先選擇添加冷卻時間，假如自動添加的時間不正確，請自行手動變更）。]=]
L["HELP_IMPORT_CURRENTPROFILE"] = [=[嘗試在這個設定檔中移動或複制一個圖示到另外一個圖示格位嗎？

你可以輕鬆的做到這一點，使用|cff7fffff右鍵點擊圖示並拖拽|r它到另外一個圖示格位（這個過程需要按下右鍵不放開）。 當你放開右鍵時，會出現一個有很多選項的選單。

嘗試拖拽一個圖示到整合圖示，其他群組，或在你螢幕上的其他框架以獲取其他相應的選項。]=]
L["HELP_MISSINGDURS"] = [=[以下法術缺少持續時間/冷卻時間：

%s

請使用下列語法添加時間：

法術:時間

例如：「%s:10」。

用建議列表插入條目時會自動添加在滑鼠提示資訊中顯示的時間（譯者註：自動添加時間功能支援提示資訊中有顯示冷卻時間的法術以及提示資訊中有註明持續時間的大部分法術，如果一個法術同時存在上述兩種時間，會優先選擇添加冷卻時間，假如自動添加的時間不正確，請自行手動變更）。]=]
L["HELP_NOUNIT"] = "你必須輸入一個單位!"
L["HELP_NOUNITS"] = "你至少需要輸入一個單位!"
L["HELP_ONLYONEUNIT"] = "條件只允許檢查一個單位，你已經輸入了%d個單位。"
L["HELP_POCKETWATCH"] = [=[|TInterface\Icons\INV_Misc_PocketWatch_01:20|t -- 關於懷錶材質

此材質用於第一個檢測到的有效法術在你的法術書中不存在時。

正確的材質將會在你施放過一次或者見到過一次該法術之後使用。

若要顯示正確的材質，請把第一個被檢查的法術名稱變更為法術ID。你可以輕鬆的做到這一點，你只需要點擊名稱編輯框中的法術，再根據之後出現的建議列表中顯示的正確的以及相對應的法術上點擊右鍵即可。

（這裡的法術指排在首位的法術，當你的滑鼠移動到建議列表的某個法術上時，在提示資訊中可以看到更為具體的 滑鼠左右鍵插入法術ID或法術名稱的方法。）]=]
L["HELP_SCROLLBAR_DROPDOWN"] = [=[一些TellMeWhen的下拉選單有捲動條。

你可以拖動捲動條來查看選單的全部內容。

你也可以使用滑鼠滾輪。]=]
L["ICON"] = "圖示"
L["ICON_TOOLTIP_CONTROLLED"] = "此圖示被這群組的第一個圖示接管。你不能單獨修改它。"
L["ICON_TOOLTIP_CONTROLLER"] = "此圖示具有群組控制功能。"
L["ICON_TOOLTIP2NEW"] = [=[|cff7fffff點擊右鍵|r進入圖示設定。
|cff7fffff點擊右鍵並拖拽|r 複製/移動 到另一個圖示。
|cff7fffff拖拽|r法術或物品到圖示來快速設定。]=]
L["ICON_TOOLTIP2NEWSHORT"] = "|cff7fffff點擊右鍵|r進入圖示設定。"
L["ICONALPHAPANEL_FAKEHIDDEN"] = "總是隱藏"
L["ICONALPHAPANEL_FAKEHIDDEN_DESC"] = [=[強制隱藏此圖示，但保持它其他的正常功能。

|cff7fffff-|r 此圖示依然可以通過其他圖示的條件進行檢查。
|cff7fffff-|r 整合圖示可以包含並顯示此圖示。
|cff7fffff-|r 此圖示的通知仍正常運作。]=]
L["ICONCONDITIONS_DESC"] = "設定條件進行微調，以便更好的顯示這個圖示。"
L["ICONGROUP"] = "圖示：%s （群組：%s）"
L["ICONMENU_ABSENT"] = "缺少"
L["ICONMENU_ABSENTEACH"] = "沒有施法的單位"
L["ICONMENU_ABSENTEACH_DESC"] = [=[設置單位沒有任何施法時的圖標透明度。

如果此選項未設置成隱藏並且檢測到有一個單位存在時，%s選項不會運作。]=]
L["ICONMENU_ABSENTONALL"] = "全都缺少"
L["ICONMENU_ABSENTONALL_DESC"] = "設定在檢查的所有單位中不存在任何一個用於檢查的增益/減益時的圖示可見度。"
L["ICONMENU_ABSENTONANY"] = "任一缺少"
L["ICONMENU_ABSENTONANY_DESC"] = "設定在檢查的所有單位中只要其中之一不存在任何一個用於檢查的增益/減益時的圖示可見度。"
L["ICONMENU_ADDMETA"] = "添加到'整合圖示'"
L["ICONMENU_ALLOWGCD"] = "允許公共冷卻"
L["ICONMENU_ALLOWGCD_DESC"] = "勾選此項允許冷卻時鐘顯示公共冷卻，而不是忽略它。"
L["ICONMENU_ALLSPELLS"] = "所有法術技能可用"
L["ICONMENU_ALLSPELLS_DESC"] = "當此圖標正在跟蹤的所有法術准備好在特定單位上時，此狀態處於活動狀態。"
L["ICONMENU_ANCHORTO"] = "依附於 %s"
L["ICONMENU_ANCHORTO_DESC"] = [=[依附%s於%s，無論%s如何移動，%s都會跟隨它一起移動。

群組選項中有進階依附設定。]=]
L["ICONMENU_ANCHORTO_UIPARENT"] = "重設依附"
L["ICONMENU_ANCHORTO_UIPARENT_DESC"] = [=[讓%s重新依附於你的螢幕（UIParent）。 它目前依附於%s。

群組選項中有進階依附設定。]=]
L["ICONMENU_ANYSPELLS"] = "任意法術技能可用"
L["ICONMENU_ANYSPELLS_DESC"] = "當被該圖標跟蹤的法術中的至少一個准備好在特定單元上時，該狀態是活動的。"
L["ICONMENU_APPENDCONDT"] = "添加到'圖示顯示'條件"
L["ICONMENU_BAR_COLOR_BACKDROP"] = "背景顏色/可見度"
L["ICONMENU_BAR_COLOR_BACKDROP_DESC"] = "設定計量條後的背景顏色和可見度。"
L["ICONMENU_BAR_COLOR_COMPLETE"] = "完成顏色"
L["ICONMENU_BAR_COLOR_COMPLETE_DESC"] = "計量條在冷卻、持續時間完成時的顏色。"
L["ICONMENU_BAR_COLOR_MIDDLE"] = "過半顏色"
L["ICONMENU_BAR_COLOR_MIDDLE_DESC"] = "計量條在冷卻、持續時間過半時的顏色。"
L["ICONMENU_BAR_COLOR_START"] = "起始顏色"
L["ICONMENU_BAR_COLOR_START_DESC"] = "計量條在冷卻、持續時間起始時的顏色。"
L["ICONMENU_BAROFFS"] = [=[此數值將會添加到計量條以便用來調整它的位移值。

一些有用的例子：
當你開始施法時防止一個增益消失的自訂指示器，或者用來指示某個法術施放所需能量的同時還剩多少時間可以中斷施法。]=]
L["ICONMENU_BOTH"] = "任意一種"
L["ICONMENU_BUFF"] = "增益"
L["ICONMENU_BUFFCHECK"] = "增益/減益檢查"
L["ICONMENU_BUFFCHECK_DESC"] = [=[檢查你所設定的單位是否缺少某個增益。

可使用這個圖示類型來檢查缺少的團隊增益（像是耐力之類）。

其他情況應使用圖示類型%q。]=]
L["ICONMENU_BUFFDEBUFF"] = "增益/減益"
L["ICONMENU_BUFFDEBUFF_DESC"] = "檢查增益或減益。"
L["ICONMENU_BUFFTYPE"] = "增益或減益"
L["ICONMENU_CAST"] = "法術施放"
L["ICONMENU_CAST_DESC"] = "檢查非瞬發施法和引導法術。"
L["ICONMENU_CHECKNEXT"] = "擴展子元"
L["ICONMENU_CHECKNEXT_DESC"] = [=[選中此框該圖示將檢查添加在列表中的任意整合圖示所包含的全部圖示，它可能是任何級別的檢查。

此外，該圖示不會顯示已經在另一個整合圖示顯示的任何圖示。

譯者註：因為很多人不明白這個功能，舉個例子，假設你有3個設定完全一樣的整合圖示（每個圖示中都是圖示1 圖示2 圖示3），全部都勾上了這個選項，如果整合圖示中，圖示1 圖示2 圖示3都可以顯示，並且顯示排序為 圖示3>圖示1>圖示2，那麼在整合圖示1將會顯示圖示3，整合圖示2則是顯示圖示1，整合圖示3顯示圖示2（理論上就是這樣的效果，具體的細節請自行發掘）。]=]
L["ICONMENU_CHECKREFRESH"] = "法術刷新偵測"
L["ICONMENU_CHECKREFRESH_DESC"] = [=[暴雪的戰鬥記錄在涉及法術刷新和恐懼（或者某些在造成一定傷害量後才會中斷的法術）存在嚴重缺陷，戰鬥記錄會認為法術在造成傷害時已經刷新，儘管事實上並非如此。

取消此選項以便停用法術刷新偵測，注意：正常的刷新也將被忽略。 

如果你檢查的遞減在造成一定傷害量後不會中斷的話建議保留此選項。]=]
L["ICONMENU_CHOOSENAME_EVENTS"] = "選擇用於檢查的訊息"
L["ICONMENU_CHOOSENAME_EVENTS_DESC"] = [=[輸入你想要圖示檢查的錯誤訊息。你可以利用';'（分號）輸入多個條目。

錯誤訊息必須完全匹配，不區分大小寫。]=]
L["ICONMENU_CHOOSENAME_ITEMSLOT_DESC"] = [=[輸入你想要此圖示監視的名稱/ID/裝備欄位編號。 你可以利用分號添加多個條目（名稱/ID/裝備欄位編號的任意組合）。

裝備欄位編號是已裝備物品所在欄位的編號索引。即使你更換了那個裝備欄位的已裝備物品，也不會影響圖示的正常使用。

你可以|cff7fffff按住Shift再按左鍵點選|r物品/聊天連結或者拖拽物品添加到此編輯框中。]=]
L["ICONMENU_CHOOSENAME_ORBLANK"] = "或者保留空白檢查所有"
L["ICONMENU_CHOOSENAME_WPNENCH_DESC"] = [=[輸入你想要此圖示監視的暫時性武器附魔的名稱。 你可以利用分號（;）添加多個條目。

|cFFFF5959重要提示|r：附魔名稱必須使用在暫時性武器附魔激活時出現在武器的提示資訊中的那個名稱（例如：「%s」， 而不是「%s」）。]=]
L["ICONMENU_CHOOSENAME3"] = "監視什麼"
L["ICONMENU_CHOSEICONTODRAGTO"] = "選擇一個圖示拖拽到："
L["ICONMENU_CHOSEICONTOEDIT"] = "選擇一個圖示來修改："
L["ICONMENU_CLEU"] = "戰鬥事件"
L["ICONMENU_CLEU_DESC"] = [=[檢查戰鬥事件。

例如：法術被反射，未命中，瞬發施法以及死亡等等。
實際上此圖示類型可以檢查所有的戰鬥事件（包括上述的例子以及其他沒有提到的戰鬥事件）。]=]
L["ICONMENU_CLEU_NOREFRESH"] = "不刷新"
L["ICONMENU_CLEU_NOREFRESH_DESC"] = "勾選後在圖示的計時器作用時不會再觸發事件。"
L["ICONMENU_CNDTIC"] = "條件圖示"
L["ICONMENU_CNDTIC_DESC"] = "檢查條件的狀態。"
L["ICONMENU_CNDTIC_ICONMENUTOOLTIP"] = "（%d個條件）"
L["ICONMENU_COMPONENTICONS"] = "元件圖示&群組"
L["ICONMENU_COOLDOWNCHECK"] = "冷卻檢查"
L["ICONMENU_COOLDOWNCHECK_DESC"] = "勾選此項啟用當可用技能在冷卻中時視為不可用。"
L["ICONMENU_COPYCONDITIONS"] = "複製 %d 個條件"
L["ICONMENU_COPYCONDITIONS_DESC"] = "複製%s的%d個條件到%s。"
L["ICONMENU_COPYCONDITIONS_DESC_OVERWRITE"] = "這將會覆寫已存在的%d個條件。"
L["ICONMENU_COPYCONDITIONS_GROUP"] = "複製%d個群組條件"
L["ICONMENU_COPYEVENTHANDLERS"] = "複製 %d 個通知事件"
L["ICONMENU_COPYEVENTHANDLERS_DESC"] = "複製%s的%d個通知事件到%s。"
L["ICONMENU_COPYHERE"] = "複製到此"
L["ICONMENU_COUNTING"] = "倒數中"
L["ICONMENU_CTRLGROUP"] = "群組控制圖示"
L["ICONMENU_CTRLGROUP_DESC"] = [=[啟用此選項讓這個圖示控制整個群組。

如果啟用，將使用這個圖示的數據填充這個群組。

該群組中的其他圖示都不能進行單獨設定。

當你需要快速定制群組的佈局、樣式或者排列選項，可以選擇使用它控制群組。]=]
L["ICONMENU_CTRLGROUP_UNAVAILABLE_DESC"] = "當前圖示類型不能控制整個群組。"
L["ICONMENU_CTRLGROUP_UNAVAILABLEID_DESC"] = "只有組中的第一個圖標（圖標ID 1）可以是組控制器。"
L["ICONMENU_CUSTOMTEX"] = "自訂圖示材質"
L["ICONMENU_CUSTOMTEX_DESC"] = [=[你可以使用下列方法更改這個圖示的顯示材質：

|cff00d1ff法術材質|r
輸入你希望顯示的法術名稱或法術ID。

|cff00d1ff其他暴雪材質|r
你可以輸入一個材質路徑，例如'Interface/Icons/spell_nature_healingtouch'， 假如材質路徑為'Interface/Icons'可以只輸入'spell_nature_healingtouch'。

|cff00d1ff空白（透明無材質）|r
輸入none或blank圖示將透明顯示，不再使用任何材質。

|cff00d1ff物品欄|r
你可以在此編輯框輸入"$"（美元符號，或稱錢幣符號）檢視一個動態材質列表。

|cff00d1ff自訂材質|r
你也能使用放在WoW子資料夾下的自訂材質（請在該欄位輸入材質的相對路徑，如：「tmw/ccc.tga」），僅支援尺寸為2的N次方（32， 64， 128，等）並且類型為.tga和.blp的材質檔案。]=]
L["ICONMENU_CUSTOMTEX_MOPAPPEND_DESC"] = [=[|cff00d1ff錯誤解決|r
|TNULL:0|t在自訂了某個材質後但是圖示顯示成綠色的話，請往下看可能發生的兩種可能性，如果材質在WOW主目錄（跟WOW.exe同一個目錄）下，請把材質移動到某個子目錄（珍愛生命，遠離WOW.exe）去即可正常使用（請關閉WOW之後再執行上述步驟），如果你是使用某個特定的法術作為材質，那可能是因為暴雪移除或者修改了它們（原來的名稱或ID已經不存在），請重新輸入另一個你要用於自訂材質的法術名稱或法術ID。]=]
L["ICONMENU_DEBUFF"] = "減益"
L["ICONMENU_DISPEL"] = "驅散類型"
L["ICONMENU_DONTREFRESH"] = "不刷新"
L["ICONMENU_DONTREFRESH_DESC"] = "勾選此項在圖示仍然倒數的時候觸發效果將強制不重置冷卻時間。"
L["ICONMENU_DOTWATCH"] = "所有單位的增益/減益"
L["ICONMENU_DOTWATCH_AURASFOUND_DESC"] = "設定圖示在被檢查的任意單位有任意增益/減益時的可見度。"
L["ICONMENU_DOTWATCH_DESC"] = [=[嘗試檢查你所選的所有單位的增益、減益。

在檢查多個法術效果時比較有用。

這個圖示類型必須使用群組控制器- 它不能是一個單獨圖示。]=]
L["ICONMENU_DOTWATCH_GCREQ"] = "必須為群組控制器"
L["ICONMENU_DOTWATCH_GCREQ_DESC"] = [=[此圖示類型必須使用群組控制器來運作。你不能單獨使用它。

請創建一個圖示並且設定為群組控制器，他必須是群組中第一個圖示（例如，他的圖示ID為1），再啟用%q選項，它在勾選框%q附近。]=]
L["ICONMENU_DOTWATCH_NOFOUND_DESC"] = "設定在無法找到被檢查的增益/減益時圖示的可見度。"
L["ICONMENU_DR"] = "遞減"
L["ICONMENU_DR_DESC"] = "檢查遞減程度跟遞減時間。"
L["ICONMENU_DRABSENT"] = "未遞減"
L["ICONMENU_DRPRESENT"] = "已遞減"
L["ICONMENU_DRS"] = "遞減"
L["ICONMENU_DURATION_MAX_DESC"] = "允許圖示顯示的最大持續時間，高於此數值圖示將被隱藏。"
L["ICONMENU_DURATION_MIN_DESC"] = "顯示圖示所需的最小持續時間，低於此數值圖示將被隱藏。"
L["ICONMENU_ENABLE"] = "啟用"
L["ICONMENU_ENABLE_DESC"] = "圖示需要啟用後才會起作用。"
L["ICONMENU_ENABLE_GROUP_DESC"] = "分組在啟用時才會正常運作。"
L["ICONMENU_ENABLE_PROFILE"] = "對角色啟用"
L["ICONMENU_ENABLE_PROFILE_DESC"] = "取消勾選禁止這個角色使用|cff00c300公共|r分組。"
L["ICONMENU_FAIL2"] = "條件無效"
L["ICONMENU_FAKEMAX"] = "偽最大值"
L["ICONMENU_FAKEMAX_DESC"] = [=[設定計時器的偽最大值。

你可以使用此設定讓整組圖示以相同的速度進行倒計時。可以讓你更清楚的看到哪些計時器先結束。

設定為0則禁用此選項。

譯者註：如果你設定為20， 那TellMeWhen顯示的計時條的總長度將變成20秒，但是並不影響你實際的計時，事實上法術的持續時間還是10秒，只是倒計時會從那個20秒長的計時條的中間開始。]=]
L["ICONMENU_FOCUS"] = "專注目標"
L["ICONMENU_FOCUSTARGET"] = "專注目標的目標"
L["ICONMENU_FRIEND"] = "友好"
L["ICONMENU_GROUPUNIT_DESC"] = [=[Group是TellMeWhen中一個特殊的單位，用於你在團隊時檢查團隊成員，或你在隊伍時檢查隊伍成員。

如果你在一個團隊中，它不會檢查重複的單位（實際上可檢查的單位有"player;party;raid"，某些時候隊伍成員可能會被檢查兩次，但是它不會。）]=]
L["ICONMENU_GUARDIAN"] = "守護者"
L["ICONMENU_GUARDIAN_CHOOSENAME_DESC"] = [=[輸入你需要監視的守護者名字或者NPC ID。

你可以利用分號(;)輸入多個單位。]=]
L["ICONMENU_GUARDIAN_DESC"] = [=[檢測你當前使用的守護者。 像是術士的小鬼等等。

此圖標類型最好使用一個分組控制器。]=]
L["ICONMENU_GUARDIAN_DUR"] = "用於顯示持續時間的單位"
L["ICONMENU_GUARDIAN_DUR_EITHER"] = "增效優先"
L["ICONMENU_GUARDIAN_DUR_EITHER_DESC"] = "如果存在增效，則優先顯示增效的持續時間。否則將顯示守護者的持續時間。"
L["ICONMENU_GUARDIAN_DUR_EMPOWER"] = "只有增效"
L["ICONMENU_GUARDIAN_DUR_GUARDIAN"] = "只有守護者"
L["ICONMENU_GUARDIAN_EMPOWERED"] = "增效"
L["ICONMENU_GUARDIAN_TRIGGER"] = "觸發自：%s"
L["ICONMENU_GUARDIAN_UNEMPOWERED"] = "未增效"
L["ICONMENU_HIDENOUNITS"] = "無單位時隱藏"
L["ICONMENU_HIDENOUNITS_DESC"] = "勾選此項可在單位不存在時致使圖示檢查的所有單位都無效的情況下隱藏該圖示（包括單位條件的設定在內）。"
L["ICONMENU_HIDEUNEQUIPPED"] = "當裝備欄缺少武器時隱藏"
L["ICONMENU_HIDEUNEQUIPPED_DESC"] = "勾選此項在檢查的武器欄沒有裝備武器時強制隱藏圖示"
L["ICONMENU_HOSTILE"] = "敵對"
L["ICONMENU_ICD"] = "內置冷卻"
L["ICONMENU_ICD_DESC"] = [=[檢查一個觸發效果或與其類似效果的冷卻。

|cFFFF5959重要提示|r：關於如何檢查每種類型的內置冷卻請參閱在 %q 下方選項的提示資訊。]=]
L["ICONMENU_ICDAURA_DESC"] = [=[如果是在以下情況開始內置冷卻，請選擇此項：

|cff7fffff1）|r在你應用某個減益/獲得某個增益以後（包括觸發），或是
|cff7fffff2）|r在某個效果造成傷害以後，或是
|cff7fffff3）|r在充能效果使你恢復法力值/怒氣/等情況以後，或是
|cff7fffff4）|r在你召喚某個東西或NPC以後。

你需要在 %q 編輯框中輸入法術/技能的名稱或ID：

|cff7fffff1）|r觸發內置冷卻的增益/減益的名稱/ID，或是
|cff7fffff2）|r造成傷害的法術/技能的名稱/ID（請檢查你的戰鬥記錄），或是
|cff7fffff3）|r充能效果的名稱/ID（請檢查你的戰鬥記錄），或是
|cff7fffff4）|r觸發內置冷卻的召喚效果的法術/技能（請檢查你的戰鬥記錄）。

（請檢查你的戰鬥記錄或者利用插件來確認法術名稱或ID）]=]
L["ICONMENU_ICDBDE"] = "增益/減益/傷害/充能/召喚"
L["ICONMENU_ICDTYPE"] = "何時開始冷卻……"
L["ICONMENU_IGNORENOMANA"] = "忽略能量不足"
L["ICONMENU_IGNORENOMANA_DESC"] = [=[勾選此項當一個技能僅僅是因為能量不足而不可用時視該技能為可用。  

對於像是%s 或者 %s這類技能很實用。]=]
L["ICONMENU_IGNORERUNES"] = "忽略符文"
L["ICONMENU_IGNORERUNES_DESC"] = [=[勾選此項，在技能冷卻已結束，僅僅因為符文冷卻（或公共冷卻）導致技能無法施放，則視該技能為可用。

譯者註：舉例說明一下，比如死亡騎士的符文轉化冷卻時間為30秒，但是30秒冷卻結束之後，在沒有可用的血魄符文或死亡符文的情況下會繼續顯示冷卻倒數計時，如果有勾選這個選項，則圖示不會出現繼續倒數，直接顯示為符文轉化可用。]=]
L["ICONMENU_IGNORERUNES_DESC_DISABLED"] = "\"忽略符文\"必須在\"冷卻檢查\"已勾選後才可使用。"
L["ICONMENU_INVERTBARDISPLAYBAR_DESC"] = "勾選此項以反向的方式填充計量條，會在持續時間到0時填滿整個計量條。"
L["ICONMENU_INVERTBARS"] = "反轉計量條"
L["ICONMENU_INVERTCBAR_DESC"] = "勾選此項使圖示上的計時條在持續時間為0時才填滿圖示的寬度，而不是計時條從填滿開始減少。"
L["ICONMENU_INVERTPBAR_DESC"] = "勾選此項使圖示上的能量條在有足夠的能量施法時才填滿圖示的寬度，而不是計時條從填滿開始減少。"
L["ICONMENU_INVERTTIMER"] = "反轉陰影"
L["ICONMENU_INVERTTIMER_DESC"] = "勾選此項來反轉計時器的陰影效果。"
L["ICONMENU_ISPLAYER"] = "單位是玩家"
L["ICONMENU_ITEMCOOLDOWN"] = "物品冷卻"
L["ICONMENU_ITEMCOOLDOWN_DESC"] = "檢查可使用物品的冷卻。"
L["ICONMENU_LIGHTWELL_DESC"] = "檢查你施放的%s的持續時間跟可用次數。"
L["ICONMENU_MANACHECK"] = "能量檢查"
L["ICONMENU_MANACHECK_DESC"] = [=[勾選此項啟用當你法力/怒氣/符能等等不足時改變圖示顏色（或視為不可用）。

譯者註：除非特別說明，本插件中的能量一般是指法術施放所需的法力/怒氣/符能/集中值等等，並非盜賊/野德的能量值。]=]
L["ICONMENU_META"] = "整合圖示"
L["ICONMENU_META_DESC"] = [=[組合多個圖示到一個圖示。

在整合圖示中被檢查的那些圖示即使設定為%q，在可以顯示時同樣會顯示。]=]
L["ICONMENU_META_ICONMENUTOOLTIP"] = "（%d個圖示）"
L["ICONMENU_MOUSEOVER"] = "遊標對象"
L["ICONMENU_MOUSEOVERTARGET"] = "遊標對象的目標"
L["ICONMENU_MOVEHERE"] = "移動到此"
L["ICONMENU_NAMEPLATE"] = "姓名版"
L["ICONMENU_NOPOCKETWATCH"] = "未知時顯示透明材質"
L["ICONMENU_NOPOCKETWATCH_DESC"] = "勾選此項使用透明材質代替時鐘材質。"
L["ICONMENU_NOTCOUNTING"] = "未倒數"
L["ICONMENU_NOTREADY"] = "沒有準備好"
L["ICONMENU_OFFS"] = "位移"
L["ICONMENU_ONCOOLDOWN"] = "冷卻中"
L["ICONMENU_ONFAIL"] = "在無效時"
L["ICONMENU_ONLYACTIVATIONOVERLAY"] = "需要啟用邊框"
L["ICONMENU_ONLYACTIVATIONOVERLAY_DESC"] = "此選項為檢測系統預設提示技能可用時的黃色發光邊框所需的必要選項。"
L["ICONMENU_ONLYBAGS"] = "只在背包中存在時"
L["ICONMENU_ONLYBAGS_DESC"] = "勾選此項當物品在背包中（或者已裝備）時顯示圖示。如果啟用'已裝備的物品'，此選項會被強制啟用。"
L["ICONMENU_ONLYEQPPD"] = "只在已裝備時"
L["ICONMENU_ONLYEQPPD_DESC"] = "勾選這個來使圖示只在物品已裝備時顯示。"
L["ICONMENU_ONLYIFCOUNTING"] = "僅在計時器倒數時顯示"
L["ICONMENU_ONLYIFCOUNTING_DESC"] = "勾選此項使圖示僅在計時器持續時間設定大於0並且正在倒數時顯示"
L["ICONMENU_ONLYIFNOTCOUNTING"] = "僅在計時器倒數完畢時顯示"
L["ICONMENU_ONLYIFNOTCOUNTING_DESC"] = "勾選此項使圖示僅在計時器持續時間設定大於0並且倒數完畢時顯示"
L["ICONMENU_ONLYINTERRUPTIBLE"] = "僅可中斷"
L["ICONMENU_ONLYINTERRUPTIBLE_DESC"] = "選中此框僅顯示可中斷的施法"
L["ICONMENU_ONLYMINE"] = "僅檢查自己施放的"
L["ICONMENU_ONLYMINE_DESC"] = "勾選此項讓該圖示只顯示你施放的增益或減益"
L["ICONMENU_ONLYSEEN"] = "僅顯示施放過的法術"
L["ICONMENU_ONLYSEEN_ALL"] = "允許所有法術"
L["ICONMENU_ONLYSEEN_ALL_DESC"] = "選中此項以允許為所有檢查的單元顯示所有功能。"
L["ICONMENU_ONLYSEEN_CLASS"] = "僅單位職業法術、技能"
L["ICONMENU_ONLYSEEN_CLASS_DESC"] = [=[選中此項，只有在已知該單元的類具有該能力時，才允許該圖標顯示能力。

已知的類法術在建議列表中用藍色或粉紅色突出顯示。]=]
L["ICONMENU_ONLYSEEN_DESC"] = "選擇此項可以讓圖示只顯示某單位至少施放過一次的法術冷卻。如果你想在同一個圖示中檢查來自不同職業的法術那麼應該勾上它。"
L["ICONMENU_ONLYSEEN_HEADER"] = "法術篩選"
L["ICONMENU_ONSUCCEED"] = "在通過時"
L["ICONMENU_OO_F"] = "在 %s 之外"
L["ICONMENU_OOPOWER"] = "在野"
L["ICONMENU_OORANGE"] = "超出範圍"
L["ICONMENU_PETTARGET"] = "寵物的目標"
L["ICONMENU_PRESENT"] = "存在"
L["ICONMENU_PRESENTONALL"] = "全都存在"
L["ICONMENU_PRESENTONALL_DESC"] = "設定在檢查的所有單位中至少都有一個用於檢查的增益/減益時的圖示可見度。"
L["ICONMENU_PRESENTONANY"] = "任一存在"
L["ICONMENU_PRESENTONANY_DESC"] = "設定在檢查的所有單位中至少存在一個用於檢查的增益/減益時的圖示可見度。"
L["ICONMENU_RANGECHECK"] = "距離檢查"
L["ICONMENU_RANGECHECK_DESC"] = "勾選此項啟用當你超出範圍時改變圖示顏色（或視為不可用）。"
L["ICONMENU_REACT"] = "單位反映"
L["ICONMENU_REACTIVE"] = "觸發性技能"
L["ICONMENU_REACTIVE_DESC"] = [=[檢查觸發性技能的可用情況。

觸發性的技能指類似%s， %s 和 %s 這些只能在某種特定條件下使用的技能。]=]
L["ICONMENU_READY"] = "準備"
L["ICONMENU_REVERSEBARS"] = "翻轉進度條"
L["ICONMENU_REVERSEBARS_DESC"] = "翻轉進度條為從左到右走。"
L["ICONMENU_RUNES"] = "符文冷卻"
L["ICONMENU_RUNES_CHARGES"] = "不可用符文充能"
L["ICONMENU_RUNES_CHARGES_DESC"] = "啟用此項，在一個符文獲得額外充能並顯示為可用時，讓圖示依然顯示成符文正在冷卻狀態（顯示為冷卻時鐘）。"
L["ICONMENU_RUNES_DESC"] = "檢查符文冷卻。"
L["ICONMENU_SHOWCBAR_DESC"] = "將會在跟圖示重疊的下半部份顯示剩餘的冷卻/持續時間的計量條（或是在'反轉計量條'啟用的情況下顯示已用的時間）"
L["ICONMENU_SHOWPBAR_DESC"] = [=[將會在跟圖示重疊的上半部份方顯示你施放此法術還需多少能量的能量條（或是在'反轉計量條'啟用的情況下顯示當前的能量）。

譯者註：這個能量可以是盜賊的能量，戰士的怒氣，獵人的集中值，其他職業的法力值等等。]=]
L["ICONMENU_SHOWSTACKS"] = "顯示堆疊數量"
L["ICONMENU_SHOWSTACKS_DESC"] = "勾選此項顯示物品的堆疊數量並啟用堆疊數量條件。"
L["ICONMENU_SHOWTIMER"] = "顯示計時器"
L["ICONMENU_SHOWTIMER_DESC"] = "勾選此項讓該圖示的冷卻時鐘動畫在可用時顯示。（譯者註：此選項僅影響圖示的時鐘動畫，就是技能冷卻時的那個轉圈效果，不包括數字在內哦。）"
L["ICONMENU_SHOWTIMERTEXT"] = "顯示計時器數字"
L["ICONMENU_SHOWTIMERTEXT_DESC"] = [=[勾選此項在圖示上顯示剩餘冷卻時間或持續時間的數字。

你需要安裝OmniCC或類似插件，或者勾選內建遊戲設定「快捷列」一頁中「顯示冷卻時間」一項。]=]
L["ICONMENU_SHOWTIMERTEXT_NOOCC"] = "顯示ElvUI計時器數字"
L["ICONMENU_SHOWTIMERTEXT_NOOCC_DESC"] = [=[勾選此項使用ElvUI的冷卻數字來顯示圖示剩餘的冷卻時間/持續時間。

此設定僅用於ElvUI的計時器。如果你有其他插件提供類似此種計時器的功能（像是OmniCC），你可以利用%q選項來控制那些計時器。 我們不推薦兩個選項同時啟用。]=]
L["ICONMENU_SHOWTTTEXT_DESC2"] = [=[在圖示的疊加層數位置顯示技能效果的變數數值。較常使用在監視傷害護盾的數值等。

此數值會顯示到圖示的疊加層數位置並替代它。

數值來源為暴雪的API接口，可能跟提示訊息上看到的數值會不相同。]=]
L["ICONMENU_SHOWTTTEXT_FIRST"] = "第一個非0變數"
L["ICONMENU_SHOWTTTEXT_FIRST_DESC"] = [=[把增益/減益第一個非0的變數顯示到圖示疊加層數的位置。

一般情況下它顯示的變數數值都是正確的，你也可以自行選擇一個效果變數來顯示。

如果檢查%s，你需要監視變數#1。]=]
L["ICONMENU_SHOWTTTEXT_STACKS"] = "疊加層數（預設）"
L["ICONMENU_SHOWTTTEXT_STACKS_DESC"] = "在圖示疊加層數位置顯示增益/減益的疊加層數。"
L["ICONMENU_SHOWTTTEXT_VAR"] = "僅變數#%d"
L["ICONMENU_SHOWTTTEXT_VAR_DESC"] = [=[僅在圖示疊加層數位置顯示此變數數值。

請自行嘗試並選擇正確的數值來源。]=]
L["ICONMENU_SHOWTTTEXT2"] = "法術效果變數"
L["ICONMENU_SHOWWHEN"] = "何時顯示圖示"
L["ICONMENU_SHOWWHEN_OPACITY_GENERIC_DESC"] = "設定此圖示在這個圖示狀態下用來顯示的可視度。"
L["ICONMENU_SHOWWHEN_OPACITYWHEN_WRAP"] = "當%s|r時的可視度"
L["ICONMENU_SHOWWHENNONE"] = "沒有結果時顯示"
L["ICONMENU_SHOWWHENNONE_DESC"] = "勾選此項允許在單位沒有被檢查到遞減時顯示圖示。"
L["ICONMENU_SHRINKGROUP"] = "收縮分組"
L["ICONMENU_SHRINKGROUP_DESC"] = [=[如果啟用此項，分組將會動態調整可見圖標的位置，使其變得不會狗啃骨頭一樣難看。

結合上面的圖標排列以及布局方向一同使用，你就可以創建一個動態居中的分組。]=]
L["ICONMENU_SORT_STACKS_ASC"] = "堆疊數量升序"
L["ICONMENU_SORT_STACKS_ASC_DESC"] = "勾選此項優先顯示堆疊數量最低的法術。"
L["ICONMENU_SORT_STACKS_DESC"] = "堆疊數量降序"
L["ICONMENU_SORT_STACKS_DESC_DESC"] = "勾選此項優先顯示堆疊數量最高的法術。"
L["ICONMENU_SORTASC"] = "持續時間升序"
L["ICONMENU_SORTASC_DESC"] = "勾選此項優先顯示持續時間最低的法術。"
L["ICONMENU_SORTASC_META_DESC"] = "勾選此項優先顯示持續時間最低的圖示。"
L["ICONMENU_SORTDESC"] = "持續時間降序"
L["ICONMENU_SORTDESC_DESC"] = "勾選此項優先顯示持續時間最高的法術。"
L["ICONMENU_SORTDESC_META_DESC"] = "勾選此項優先顯示持續時間最高的圖示。"
L["ICONMENU_SPELLCAST_COMPLETE"] = "施法結束/瞬發施法"
L["ICONMENU_SPELLCAST_COMPLETE_DESC"] = [=[如果是在以下情況開始內置冷卻，請選擇此項：

|cff7fffff1）|r在你施法結束後，或是
|cff7fffff2）|r在你施放一個瞬發法術後。

你需要在 %q 編輯框中輸入觸發內置冷卻的法術名稱或ID。]=]
L["ICONMENU_SPELLCAST_START"] = "施法開始"
L["ICONMENU_SPELLCAST_START_DESC"] = [=[如果是在以下情況開始內置冷卻，請選擇此項：

|cff7fffff1）|r在開始施法後。

你需要在 %q 編輯框中輸入觸發內置冷卻的法術名稱或ID。]=]
L["ICONMENU_SPELLCOOLDOWN"] = "法術冷卻"
L["ICONMENU_SPELLCOOLDOWN_DESC"] = "檢查在你法術書中那些法術的冷卻。"
L["ICONMENU_SPLIT"] = "拆分成新的群組"
L["ICONMENU_SPLIT_DESC"] = "創建一個新的群組並將這個圖示移動到上面。 原群組中的許多設定會保留到新的群組。"
L["ICONMENU_SPLIT_GLOBAL"] = "拆分成新的|cff00c300global共用群組|r"
L["ICONMENU_SPLIT_NOCOMBAT_DESC"] = "戰鬥中不能創建新的群組。請在脫離戰鬥後分離到新的群組。"
L["ICONMENU_STACKS_MAX_DESC"] = "允許圖示顯示的最大堆疊數量，高於此數值圖示將被隱藏。"
L["ICONMENU_STACKS_MIN_DESC"] = "顯示圖示所需的最低堆疊數量，低於此數值圖示將被隱藏。"
L["ICONMENU_STATECOLOR"] = "圖標色彩和材質"
L["ICONMENU_STATECOLOR_DESC"] = [=[將圖標紋理的色調設置為此圖標狀態。

白色是正常的。 任何其他顏色會使紋理的顏色。

在此狀態下，還可以覆蓋圖標上顯示的紋理。]=]
L["ICONMENU_STATUE"] = "武僧雕像"
L["ICONMENU_STEALABLE"] = "僅可法術竊取"
L["ICONMENU_STEALABLE_DESC"] = "勾選此項僅顯示能被\"法術竊取\"的增益，非常適合跟驅散類型中的魔法搭配使用。"
L["ICONMENU_SUCCEED2"] = "條件通過時"
L["ICONMENU_SWAPWITH"] = "交換位置"
L["ICONMENU_SWINGTIMER"] = "揮擊計時器"
L["ICONMENU_SWINGTIMER_DESC"] = "檢查你主手和副手武器的揮擊時間。"
L["ICONMENU_SWINGTIMER_NOTSWINGING"] = "無揮擊"
L["ICONMENU_SWINGTIMER_SWINGING"] = "揮擊中"
L["ICONMENU_TARGETTARGET"] = "目標的目標"
L["ICONMENU_TOTEM"] = "圖騰"
L["ICONMENU_TOTEM_DESC"] = "檢查你的圖騰。"
L["ICONMENU_TOTEM_GENERIC_DESC"] = "檢測你的 %s。"
L["ICONMENU_TYPE"] = "圖示類型"
L["ICONMENU_TYPE_CANCONTROL"] = "此圖示類型如果在群組的第一個圖示設定好就可以控制整個群組。"
L["ICONMENU_TYPE_DISABLED_BY_VIEW"] = "此圖示類型不支援顯示方式：%q。你可以更改群組顯示方式或者創建一個新的群組使用這個圖示類型。"
L["ICONMENU_UIERROR"] = "戰鬥錯誤訊息"
L["ICONMENU_UIERROR_DESC"] = "檢查UI錯誤訊息。例如：「怒氣不足」、「你需要一個目標」等等。"
L["ICONMENU_UNIT_DESC"] = [=[在此框輸入需要監視的單位。此單位能從右邊的下拉列表插入，或者你是一位高端玩家可以自行輸入需要監視的單位。多個單位請用分號分隔開（;）可使用標準單位（像是player，target，mouseover等等可用於巨集的單位），或者是友好玩家的名字（像是%s，Cybeloras，小兔是豬，阿光是豬等。）

需要瞭解更多關於單位的相關資訊，請訪問http://www.wowpedia.org/UnitId]=]
L["ICONMENU_UNIT_DESC_CONDITIONUNIT"] = [=[在此框輸入需要監視的單位。此單位能從右邊的下拉列表插入，或者你是一位高端玩家可以自行輸入需要監視的單位。

可使用標準單位（像是player，target，mouseover等等可用於巨集的單位），或者是友好玩家的名字（像是%s，Cybeloras，小兔是豬，阿光是豬等。）

需要瞭解更多關於單位的相關資訊，請訪問http:////www.wowpedia.org/UnitId]=]
L["ICONMENU_UNIT_DESC_UNITCONDITIONUNIT"] = [=[在此框輸入需要監視的單位。此單位能從右邊的下拉列表插入。

"unit"是指當前圖示正在檢查的任意單位。]=]
L["ICONMENU_UNITCNDTIC"] = "單位條件圖示"
L["ICONMENU_UNITCNDTIC_DESC"] = [=[檢查單位的條件狀態。

設定中所有應用的單位都會被檢查。]=]
L["ICONMENU_UNITCOOLDOWN"] = "單位冷卻"
L["ICONMENU_UNITCOOLDOWN_DESC"] = [=[檢查其他單位的冷卻。

檢查 %s 可以使用 %q 作為名稱。

譯者註：玩家也可以作為被檢查的單位。]=]
L["ICONMENU_UNITFAIL"] = "單位條件未通過"
L["ICONMENU_UNITS"] = "單位"
L["ICONMENU_UNITSTOWATCH"] = "監視的單位"
L["ICONMENU_UNITSUCCEED"] = "單位條件通過"
L["ICONMENU_UNUSABLE"] = "不可用"
L["ICONMENU_UNUSABLE_DESC"] = "當上述狀態也不啟用時，該狀態是活動的。 不透明度為0％的狀態將永遠不會被啟用。"
L["ICONMENU_USABLE"] = "可用"
L["ICONMENU_USEACTIVATIONOVERLAY"] = "檢查技能激活邊框"
L["ICONMENU_USEACTIVATIONOVERLAY_DESC"] = "檢查系統預設提示技能可用時的黃色發光邊框。"
L["ICONMENU_VALUE"] = "資源顯示"
L["ICONMENU_VALUE_DESC"] = "顯示一個單位的資源（生命值、法力值等等）"
L["ICONMENU_VALUE_HASUNIT"] = "單位已找到"
L["ICONMENU_VALUE_NOUNIT"] = "單位未找到"
L["ICONMENU_VALUE_POWERTYPE"] = "資源類型"
L["ICONMENU_VALUE_POWERTYPE_DESC"] = "設定你想要圖示檢查的資源類型。"
L["ICONMENU_VEHICLE"] = "載具"
L["ICONMENU_VIEWREQ"] = "群組顯示方式不支持"
L["ICONMENU_VIEWREQ_DESC"] = [=[此圖示類型不能用於當前群組顯示方式，因為它沒有顯示全部數據所需的組件。

請更改群組的顯示方式或者創建一個新的群組再使用這個圖示類型。]=]
L["ICONMENU_WPNENCHANT"] = "暫時性武器附魔"
L["ICONMENU_WPNENCHANT_DESC"] = "檢查暫時性的武器附魔"
L["ICONMENU_WPNENCHANTTYPE"] = "監視的武器欄"
L["IconModule_CooldownSweepCooldown"] = "冷卻時鐘"
L["IconModule_IconContainer_MasqueIconContainer"] = "圖示容器"
L["IconModule_IconContainer_MasqueIconContainer_DESC"] = "容納圖示的主要部份，像是材質。"
L["IconModule_PowerBar_OverlayPowerBar"] = "重疊式能量條"
L["IconModule_SelfIcon"] = "圖示"
L["IconModule_Texture_ColoredTexture"] = "圖示材質"
L["IconModule_TimerBar_BarDisplayTimerBar"] = "計時條（計量條顯示）"
L["IconModule_TimerBar_OverlayTimerBar"] = "重疊式計時條"
L["ICONTOCHECK"] = "要檢查的圖示"
L["ICONTYPE_DEFAULT_HEADER"] = "提示資訊"
L["ICONTYPE_DEFAULT_INSTRUCTIONS"] = [=[要開始設定該圖示，請先從%q下拉式選單中選擇一個圖示類型。

圖示只能在鎖定狀態才能正常運作，當你設定結束後記得輸入"/TMW"。


在設定TellMeWhen時，請仔細閱讀每個設定選項的提示資訊，裡面會有如何設定的關鍵訊息，可以讓你事半功倍!]=]
L["ICONTYPE_SWINGTIMER_TIP"] = [=[你需要檢查%s的時間嗎？圖示類型%s擁有你想要的功能。 僅需簡單設定一個%s來檢查%q（法術ID：%d）!

你可以點擊下方的按鈕自動套用設定。]=]
L["ICONTYPE_SWINGTIMER_TIP_APPLYSETTINGS"] = "套用%s設定"
L["IE_NOLOADED_GROUP"] = "選擇一個分組加載："
L["IE_NOLOADED_ICON"] = "沒有圖標載入。"
L["IE_NOLOADED_ICON_DESC"] = [=[你可以右鍵點擊來讀取一個圖標。

如果你的屏幕上沒有顯示任何圖標，請點擊下面的 %s 標簽 。

在那裡你可以新增一個分組或者配置一個已存在的分組。

輸入'/tmw'退出設置模式。]=]
L["ImmuneToMagicCC"] = "免疫法術控制"
L["ImmuneToStun"] = "免疫擊暈"
L["IMPORT_EXPORT"] = "匯入/匯出/還原"
L["IMPORT_EXPORT_BUTTON_DESC"] = "點擊此下拉式選單來匯出或匯入圖示/群組/設定檔。"
L["IMPORT_EXPORT_DESC"] = [=[點擊這個編輯框右側的下拉式選單的箭頭來匯出圖示，群組或設定檔。

匯出/匯入字串或發送給其他玩家需要使用這個編輯框。 具體的使用方法請看下拉式選單上的提示資訊。]=]
L["IMPORT_FAILED"] = "匯入失敗！"
L["IMPORT_FROMBACKUP"] = "來自備份"
L["IMPORT_FROMBACKUP_DESC"] = "用此選單可以還原設定到：%s "
L["IMPORT_FROMBACKUP_WARNING"] = "備份設定：%s"
L["IMPORT_FROMCOMM"] = "來自玩家"
L["IMPORT_FROMCOMM_DESC"] = "如果另一個TellMeWhen使用者給你發送了組態數據，可以從這個子選單匯入那些數據。"
L["IMPORT_FROMLOCAL"] = "來自設定檔"
L["IMPORT_FROMSTRING"] = "來自字串"
L["IMPORT_FROMSTRING_DESC"] = [=[字串允許你在遊戲以外的地方轉存TellMeWhen組態數據。（包括用來給其他人分享自己的設定，或者匯入其他人分享的設定，也可用來備份你自己的設定。）

從字串匯入的方法：當複製TMW字串到你的剪貼簿後，在「匯出/匯入」編輯框中按下CTRL+V貼上字串，然後返回瀏覽這個子選單。]=]
L["IMPORT_GROUPIMPORTED"] = "群組已匯入！"
L["IMPORT_GROUPNOVISIBLE"] = "你剛剛匯入的群組無法顯示，因為它的設定似乎不是你當前的專精和職業所使用。請輸入'/tmw options'，在群組設定中修改專精和職業設定。"
L["IMPORT_HEADING"] = "匯入"
L["IMPORT_ICON_DISABLED_DESC"] = "你必須在設定一個圖示的時候才能匯入一個圖示。"
L["IMPORT_LUA_CONFIRM"] = "確定匯入"
L["IMPORT_LUA_DENY"] = "取消匯入"
L["IMPORT_LUA_DESC"] = [=[匯入的數據中包含了以下Lua程式碼可以被TellMeWhen執行。

你需要警惕匯入的Lua程式碼的來源是否可信。大部分情況下它們都是安全的，但是知人知面不知心，不要被少數壞人有機可乘。

注意檢查並確認程式碼來自可信的地方，以及它們不會做像是以你的名義來發送郵件或者確認交易這種事情。]=]
L["IMPORT_LUA_DESC2"] = "|TInterface\\AddOns\\TellMeWhen\\Textures\\Alert:0:2|t 請注意檢視紅色部分程式碼，它們可能會有某些惡意行為。 |TInterface\\AddOns\\TellMeWhen\\Textures\\Alert:0:2|t"
L["IMPORT_NEWGUIDS"] = [=[你剛匯入的數據中的%d|4群組；群組，和%d|4圖示：圖示；有唯一識別碼。可能是因為你之前已經匯入過該數據。

已經為匯入的數據分配了新的識別碼。你在這之後匯入的那些圖示都將引用新的數據，可能會無法正常使用，新數據會使用到老的圖示數據而造成混亂。

如果你打算替換現有的數據，請重新匯入到正確的位置。]=]
L["IMPORT_PROFILE"] = "複製設定檔"
L["IMPORT_PROFILE_NEW"] = "|cff59ff59創建|r新的設定檔"
L["IMPORT_PROFILE_OVERWRITE"] = "|cFFFF5959覆寫|r %s"
L["IMPORT_SUCCESSFUL"] = "匯入完成!"
L["IMPORTERROR_FAILEDPARSE"] = "處理字串時發生錯誤。請確保你複製的字串是完整的。"
L["IMPORTERROR_INVALIDTYPE"] = "嘗試匯入未知類型的數據，請檢查是否已安裝了最新版本的TellMeWhen。"
L["Incapacitated"] = "癱瘓"
L["INCHEALS"] = "單位受到的治療量"
L["INCHEALS_DESC"] = [=[檢查單位即將受到的治療量（包括下一跳HoT和施放中的法術）

僅能在友好單位使用， 敵對單位會返回0。

譯者註：由於暴雪的API問題，HoT只會返回單位框架上所顯示的數值。]=]
L["INRANGE"] = "在範圍內"
L["ITEMCOOLDOWN"] = "物品冷卻"
L["ITEMEQUIPPED"] = "已裝備的物品"
L["ITEMINBAGS"] = "物品計數（包含使用次數）"
L["ITEMSPELL"] = "物品有使用效果"
L["ITEMTOCHECK"] = "要檢查的物品"
L["ITEMTOCOMP1"] = "進行比較的第一個物品"
L["ITEMTOCOMP2"] = "進行比較的第二個物品"
L["LAYOUTDIRECTION"] = "佈局方向"
L["LAYOUTDIRECTION_PRIMARY_DESC"] = "使圖標的主要布局方向沿 %s 方向展開。"
L["LAYOUTDIRECTION_SECONDARY_DESC"] = "使連續的行/列圖標沿 %s 方向展開。"
L["LDB_TOOLTIP1"] = "|cff7fffff左鍵點擊：|r鎖定群組"
L["LDB_TOOLTIP2"] = "|cff7fffff右鍵點擊：|r顯示TWM選項"
L["LEFT"] = "左"
L["LOADERROR"] = "TellMeWhen設定插件無法載入："
L["LOADINGOPT"] = "正在載入TellMeWhen設定插件。"
L["LOCKED"] = "已鎖定"
L["LOCKED2"] = "位置鎖定。"
L["LOSECONTROL_CONTROLLOST"] = "失去控制"
L["LOSECONTROL_DROPDOWNLABEL"] = "失去控制類型"
L["LOSECONTROL_DROPDOWNLABEL_DESC"] = "選擇你需要作用於此圖示的失去控制的類型（譯者註：可多選）。"
L["LOSECONTROL_ICONTYPE"] = "失去控制"
L["LOSECONTROL_ICONTYPE_DESC"] = "檢查那些造成你失去角色控制權的效果。 "
L["LOSECONTROL_INCONTROL"] = "可控制"
L["LOSECONTROL_TYPE_ALL"] = "全部類型"
L["LOSECONTROL_TYPE_ALL_DESC"] = "讓圖示顯示所有相關類型的資訊。"
L["LOSECONTROL_TYPE_DESC_USEUNKNOWN"] = "注意：圖示無法判斷這個失去控制的類型是否已使用。 "
L["LOSECONTROL_TYPE_MAGICAL_IMMUNITY"] = "魔法免疫"
L["LOSECONTROL_TYPE_SCHOOLLOCK"] = "法術類別被鎖定"
L["LUA_INSERTGUID_TOOLTIP"] = "|cff7fffffShift點擊|r插入並在你的代碼中引用這個圖標。"
L["LUACONDITION"] = "Lua（進階）"
L["LUACONDITION_DESC"] = [=[此條件類型允許你使用Lua語言來評估一個條件的狀態。

輸入不能為「if……then」敘述，也不能為function closure。它可以是一個普通的敘述評估，例如：「a and b or c」。如果需要複雜功能，可使用函數調用，例如：「CheckStuff()」，這是一個外部函數。 （你也可以使用Lua片段功能）。

使用「thisobj」來引用這個圖示、群組的數據。你也可以插入其他圖示的GUID，在編輯框獲得焦點時SHIFT點擊那個圖示即可。

如果需要更多的幫助（但不是關於如何去寫Lua代碼），到CurseForge提交一份回報單。關於如何編寫Lua语言，請自行去互聯網搜尋資料。

註：Lua語言部份就不翻譯了，翻譯了反而覺得怪怪的。]=]
L["LUACONDITION2"] = "Lua條件"
L["MACROCONDITION"] = "巨集條件式"
L["MACROCONDITION_DESC"] = [=[此條件將會評估巨集的條件式，在巨集條件式成立時則此條件通過。
所有的巨集條件式都能在前面加上"no"進行逆向檢查。
例子：
"[nomodifier:alt]" - 沒有按住ALT鍵
"[@target,help][mod:ctrl]" - 目標是友好的或者按住CTRL鍵
"[@focus,harm,nomod:shift]" - 專注目標是敵對的同時沒有按住SHIFT鍵

需要更多的幫助，請訪問http:////www.wowpedia.org/Making_a_macro]=]
L["MACROCONDITION_EB_DESC"] = "使用單一條件時中括號是可選的，使用多個條件式時中括號是必須的。（說明：中括號->[ ]）"
L["MACROTOEVAL"] = "輸入需要評估的巨集條件式（允許多個）"
L["Magic"] = "魔法"
L["MAIN"] = "主頁面"
L["MAIN_DESC"] = "包含這個圖示的主要選項。"
L["MAINASSIST"] = "主助攻"
L["MAINASSIST_DESC"] = "檢查團隊中被標記為主助攻的單位。"
L["MAINOPTIONS_SHOW"] = "群組設定"
L["MAINTANK"] = "主坦克"
L["MAINTANK_DESC"] = "檢查團隊中被標記為主坦克的單位。"
L["MAKENEWGROUP_GLOBAL"] = "|cff59ff59創建|r新的|cff00c300帳號共用|r群組"
L["MAKENEWGROUP_PROFILE"] = "|cff59ff59創建|r新的角色設定檔分組"
L["MESSAGERECIEVE"] = "%s給你發送了一些TellMeWhen的數據! 你可以利用圖示編輯器中的 %q 下拉式選單匯入這些數據到TellMeWhen。"
L["MESSAGERECIEVE_SHORT"] = "%s給你發送了一些TellMeWhen數據!"
L["META_ADDICON"] = "增加圖示"
L["META_ADDICON_DESC"] = "點擊新增圖示到此整合圖示中。"
L["META_GROUP_INVALID_VIEW_DIFFERENT"] = [=[該群組的圖示不可用於整合圖示的檢查，因為它們使用了不同的顯示方式。

群組：%s
目標群組：%s]=]
L["METAPANEL_DOWN"] = "向下移動"
L["METAPANEL_REMOVE"] = "移除此圖示"
L["METAPANEL_REMOVE_DESC"] = "點擊從整合圖示的檢查列表中移除該圖示。"
L["METAPANEL_UP"] = "向上移動"
L["minus"] = "下屬"
L["MISCELLANEOUS"] = "其他"
L["MiscHelpfulBuffs"] = "雜項-其他增益"
L["MODTIMER_PATTERN"] = "允許Lua匹配模式"
L["MODTIMER_PATTERN_DESC"] = [=[預設情況下，這個條件將匹配任何包含你輸入的文字的計時器，不區分大小寫。

如果啟用此設定，輸入將使用Lua樣式的字符匹配模式。

輸入^timer name$時將強制匹配計時器的完整名稱。 TellMeWhen保存計時器的名稱必須全部為小寫字母。

需要獲取更多的資訊，請訪問http:////wowpedia.org/Pattern_matching]=]
L["MODTIMERTOCHECK"] = "用於檢查的計時器"
L["MODTIMERTOCHECK_DESC"] = "輸入顯示在首領模塊計時器顯示在計時條上的全名。"
L["MOON"] = "月蝕"
L["MOUSEOVER_TOKEN_NOT_FOUND"] = "無遊標對象"
L["MOUSEOVERCONDITION"] = "滑鼠遊標停留"
L["MOUSEOVERCONDITION_DESC"] = "此條件檢查你的滑鼠遊標是否有停留在此圖示上，如果為群組條件則檢查滑鼠遊標是否有停留在該群組的某個圖示上。"
L["MP5"] = "%d 5秒回藍"
L["MUSHROOM"] = "蘑菇%d"
L["NEWVERSION"] = "有新版本可升級（%s）"
L["NOGROUPS_DIALOG_BODY"] = [=[你當前的TellMeWhen設定或玩家專精不允許顯示任何群組，所以沒有東西可以進行設定。

如果你想更改已有群組的設定或新增一個群組，請輸入/tmw options打開TellMeWhen的首選項或者點擊下方的按鍵。

輸入/tellmewhen或/tmw退出設定模式。]=]
L["NONE"] = "不包含任何一個"
L["normal"] = "普通"
L["NOTINRANGE"] = "不在範圍內"
L["NOTYPE"] = "<無圖示類型>"
L["NUMAURAS"] = "數量"
L["NUMAURAS_DESC"] = [=[此條件僅檢查一個作用中的法術效果的數量 - 不要與法術效果的堆疊數量混淆。
像是你的兩個相同的武器附魔特效同時觸發並且在作用中。
請有節制的使用它，此過程需要消耗不少CPU運算來計算數量。]=]
L["ONLYCHECKMINE"] = "僅檢查自己施放的"
L["ONLYCHECKMINE_DESC"] = "勾選此項讓此條件只檢查自己施放的增益/減益。"
L["OPERATION_DIVIDE"] = "除（/）"
L["OPERATION_MINUS"] = "減（-）"
L["OPERATION_MULTIPLY"] = "乘（*）"
L["OPERATION_PLUS"] = "加（+）"
L["OPERATION_SET"] = "集（Set）"
L["OPERATION_TPAUSE"] = "暫停"
L["OPERATION_TPAUSE_DESC"] = "暫停計時器。"
L["OPERATION_TRESET"] = "重設"
L["OPERATION_TRESET_DESC"] = "重設計時器為0。如果它還在運作的話不會停止。"
L["OPERATION_TRESTART"] = "重開"
L["OPERATION_TRESTART_DESC"] = "重設計時器為0。如果它未運作則開始運作。"
L["OPERATION_TSTART"] = "開始"
L["OPERATION_TSTART_DESC"] = "如果計時器沒在運行則開始計時。不重設計時器。"
L["OPERATION_TSTOP"] = "停止"
L["OPERATION_TSTOP_DESC"] = "停止計時器並重設為0。"
L["OUTLINE_MONOCHORME"] = "單色"
L["OUTLINE_NO"] = "無描邊"
L["OUTLINE_THICK"] = "粗描邊"
L["OUTLINE_THIN"] = "細描邊"
L["PARENTHESIS_TYPE_("] = "左括號（"
L["PARENTHESIS_TYPE_)"] = "右括號）"
L["PARENTHESIS_WARNING1"] = [=[左右括號的数量不相等!

缺少%d個%s。]=]
L["PARENTHESIS_WARNING2"] = [=[一些右括號缺少左括號。

缺少%d個左括號'（'。]=]
L["PERCENTAGE"] = "百分比"
L["PERCENTAGE_DEPRECATED_DESC"] = [=[百分比條件已經作廢，因為它們不再可靠。

在德拉諾之王，增益/減益的加速機制更改為未結束前刷新可以最大延長至130%基礎持續時間。

其他一大段略過，基本同上。]=]
L["PET_TYPE_CUNNING"] = "靈巧"
L["PET_TYPE_FEROCITY"] = "兇暴"
L["PET_TYPE_TENACITY"] = "堅毅"
L["PLAYER_DESC"] = "單位'player'是你自己。"
L["Poison"] = "毒"
L["PROFILE_LOADED"] = "已載入設定檔：%s"
L["PROFILES_COPY"] = "複製設定檔..."
L["PROFILES_COPY_CONFIRM"] = "複製設定檔"
L["PROFILES_COPY_CONFIRM_DESC"] = "設定檔 %q 將被複製的設定檔 %q 覆蓋。"
L["PROFILES_COPY_DESC"] = [=[選擇一個設定檔。當前的設定檔會被這個選擇的設定檔覆蓋。

在登出游戲或重載前你都可以使用 %q (下方選單 %q 中的選項)來恢復被刪除的設定檔。]=]
L["PROFILES_DELETE"] = "刪除設定檔..."
L["PROFILES_DELETE_CONFIRM"] = "刪除設定檔"
L["PROFILES_DELETE_CONFIRM_DESC"] = "設定檔 %q 將被刪除。"
L["PROFILES_DELETE_DESC"] = [=[選擇需要刪除的設定檔。

在登出游戲或重載前你都可以使用 %q (下方選單 %q 中的選項)來恢復被刪設定檔。]=]
L["PROFILES_NEW"] = "新建設定檔"
L["PROFILES_NEW_DESC"] = "輸入新設定檔的名稱，按下enter來建立。"
L["PROFILES_SET"] = "變更設定檔..."
L["PROFILES_SET_DESC"] = "切換到選擇的設定檔。"
L["PROFILES_SET_LABEL"] = "目前設定檔"
L["PvPSpells"] = "PVP控制技能以及其他"
L["QUESTIDTOCHECK"] = "用於檢查的任務ID"
L["RAID_WARNING_FAKE"] = "團隊警報 （假）"
L["RAID_WARNING_FAKE_DESC"] = "輸出類似於團隊警報訊息的文字，此訊息不會被其他人看到，你不需要團隊權限，也不需要在團隊中就可使用。"
L["RaidWarningFrame"] = "團隊警告框架"
L["rare"] = "稀有"
L["rareelite"] = "稀有精英"
L["REACTIVECNDT_DESC"] = "此條件僅檢查技能的觸發/可用情況，並非它的冷卻。"
L["REDO"] = "重作"
L["REDO_DESC"] = "重做上次對這些設置所做的更改。"
L["ReducedHealing"] = "治療效果降低"
L["REQFAILED_ALPHA"] = "無效時的可視度"
L["RESET_ICON"] = "重設"
L["RESET_ICON_DESC"] = "重置這個圖示的所有設定為預設值。"
L["RESIZE"] = "改變大小"
L["RESIZE_GROUP_CLOBBERWARN"] = "當你使用|cff7fffff右鍵點擊並拖拽|r縮減群組格數時，部分圖示的設定將會臨時存檔，在你使用|cff7fffff右鍵點擊並拖拽|r加大群組格數時會恢復，但是在你登出或者重新載入UI後臨時存檔的數據將會丟失。"
L["RESIZE_TOOLTIP"] = "|cff7fffff點擊並拖拽：|r改變大小"
L["RESIZE_TOOLTIP_CHANGEDIMS"] = "|cff7fffff右鍵點擊並拖拽：|r更改群組的格數"
L["RESIZE_TOOLTIP_IEEXTRA"] = "在主選項啟用縮放。"
L["RESIZE_TOOLTIP_SCALEX_SIZEY"] = "|cff7fffff點擊並拖拽：|r改變大小"
L["RESIZE_TOOLTIP_SCALEXY"] = [=[|cff7fffff點擊並拖拽：|r快速調整大小比例
|cff7fffff按住CTRL：|r微調大小比例]=]
L["RESIZE_TOOLTIP_SCALEY_SIZEX"] = "|cff7fffff點擊並拖拽：|r調整大小比例"
L["RIGHT"] = "右"
L["ROLEf"] = "職責：%s"
L["Rooted"] = "纏繞"
L["RUNEOFPOWER"] = "符文%d"
L["RUNES"] = "要檢查的符文"
L["RUNSPEED"] = "單位奔跑速度"
L["RUNSPEED_DESC"] = "這是指單位的最大運行速度，而不管單位是否正在移動。"
L["SAFESETUP_COMPLETE"] = "安全&慢速設定完成。"
L["SAFESETUP_FAILED"] = "安全&慢速設定失敗：%s"
L["SAFESETUP_TRIGGERED"] = "正在進行安全&慢速設定……"
L["SEAL"] = "聖印"
L["SENDSUCCESSFUL"] = "發送完成"
L["SHAPESHIFT"] = "變身"
L["Shatterable"] = "冰凍"
L["SHOWGUIDS_OPTION"] = "在滑鼠提示上顯示GUID。"
L["SHOWGUIDS_OPTION_DESC"] = "啟用此設定可以在滑鼠提示上顯示圖示跟群組的GUID（全域唯一識別碼）。在需要知道圖示或群組所對應的GUID時，這可能對你有所幫助。"
L["Silenced"] = "沉默"
L["Slowed"] = "緩速"
L["SORTBY"] = "排序方式"
L["SORTBYNONE"] = "正常排序"
L["SORTBYNONE_DESC"] = [=[如果選中，法術將按照"%s"編輯框中的輸入順序來檢查並排序。

如果是一個增益/減益圖示，只要出現在單位框架上的法術效果數字沒有超出效率閥值設定的界限，就會被檢查並排序。

（註：如果看不懂請無視這段說明，只要知道它是按照你輸入的順序來排序就好。）]=]
L["SORTBYNONE_DURATION"] = "持續時間正常"
L["SORTBYNONE_META_DESC"] = "如果勾選，被檢查的圖示將使用上面的列表所設定的順序來排序。"
L["SORTBYNONE_STACKS"] = "堆疊數量正常"
L["SOUND_CHANNEL"] = "音效播放頻道"
L["SOUND_CHANNEL_DESC"] = [=[選擇一個你想用於播放聲音的頻道（會直接使用在系統->音效中該頻道所設定的音量跟設定來播放）。

選擇%q時，可以在音效關閉時播放聲音。]=]
L["SOUND_CHANNEL_MASTER"] = "主聲道"
L["SOUND_CUSTOM"] = "自訂音效檔案"
L["SOUND_CUSTOM_DESC"] = [=[輸入需要用來播放的自訂音效檔案的路徑。
下面是一些例子，其中「File」是你的音效檔案名，「ext」是副檔名（只能用ogg或者mp3格式）

-「CustomSounds\file.ext」：一個檔案放在WOW根目錄一個命名為「CustomSound」的新建資料夾中（此資料夾同WOW.exe，Interface和WTF在同一個位置）
-「Interface\AddOns\file.ext」：插件資料夾中的某一檔案
-「file.ext」： WOW主目錄的某個檔案

注意：魔獸世界必須在重開之後才能正常使用那些在它啟動時還不存在的檔案。]=]
L["SOUND_ERROR_ALLDISABLED"] = [=[無法進行音效播放測試，原因：遊戲音效已經被完全禁用。

你需要去更改暴雪音效選項的相關設定。]=]
L["SOUND_ERROR_DISABLED"] = [=[無法進行音效播放測試，原因：音效播放頻道「%q」已經被禁用。

你需要去更改暴雪音效選項的相關設定，或者你也可以在TellMeWhen的主選項中更改TellMeWhen的音效播放頻道（/tmw options）。]=]
L["SOUND_ERROR_MUTED"] = [=[無法進行音效播放測試，原因：音效播放頻道「%q」的音量大小為0。

你需要去更改暴雪音效選項的相關設定，或者你也可以在TellMeWhen的主選項中更改TellMeWhen的音效播放頻道（/tmw options）。]=]
L["SOUND_EVENT_DISABLEDFORTYPE"] = "不可用"
L["SOUND_EVENT_DISABLEDFORTYPE_DESC2"] = [=[在當前圖示設定下，此事件不可用。

可能因為當前的圖示類型（%s）還不支援此事件，請|cff7fffff右鍵點擊|r更改事件類型。]=]
L["SOUND_EVENT_NOEVENT"] = "未設定的事件"
L["SOUND_EVENT_ONALPHADEC"] = "在可見度百分比減少時"
L["SOUND_EVENT_ONALPHADEC_DESC"] = [=[當圖示的可視度降低時觸發此事件。

注意：可視度在降低後如果為0%不會觸發此事件（如果有需要請使用「在隱藏時」）。]=]
L["SOUND_EVENT_ONALPHAINC"] = "在可見度百分比增加時"
L["SOUND_EVENT_ONALPHAINC_DESC"] = [=[當圖示的可視度提高時觸發此事件。

注意：可視度在提高前如果為0%不會觸發此事件（如果有需要請使用「在顯示時」）。]=]
L["SOUND_EVENT_ONCHARGEGAINED"] = "在充能獲取時"
L["SOUND_EVENT_ONCHARGEGAINED_DESC"] = "此事件在一個被檢測的充能類型技能獲取一次充能時觸發。"
L["SOUND_EVENT_ONCHARGELOST"] = "在充能使用時"
L["SOUND_EVENT_ONCHARGELOST_DESC"] = "此事件在一個被檢測的充能類型技能使用一次充能時觸發。"
L["SOUND_EVENT_ONCLEU"] = "在戰鬥事件發生時"
L["SOUND_EVENT_ONCLEU_DESC"] = "此事件在圖示處理某一戰鬥事件時觸發。"
L["SOUND_EVENT_ONCONDITION"] = "在設定的條件通過時"
L["SOUND_EVENT_ONCONDITION_DESC"] = "當你設定的條件通過時觸發此事件。"
L["SOUND_EVENT_ONDURATION"] = "在持續時間改變時"
L["SOUND_EVENT_ONDURATION_DESC"] = [=[此事件在圖示計時器的持續時間改變時觸發。

因為在計時器運行時每次圖示更新都會觸發該事件，你必須設定一個條件，使事件僅在條件的狀態改變時觸發。]=]
L["SOUND_EVENT_ONEVENTSRESTORED"] = "在圖示設定後"
L["SOUND_EVENT_ONEVENTSRESTORED_DESC"] = [=[此事件在這圖示已經設定完畢後觸發。

這主要發生在你退出設定模式時，同樣也會發生在某些區域的進入事件或者離開事件。

你可以視它為圖示的"軟重設"。

此事件比較常用於創建一個圖示的預設狀態的動畫。]=]
L["SOUND_EVENT_ONFINISH"] = "在結束時"
L["SOUND_EVENT_ONFINISH_DESC"] = "當冷卻完成，增益/減益消失，等類似的情況下觸發此事件。 "
L["SOUND_EVENT_ONHIDE"] = "在隱藏時"
L["SOUND_EVENT_ONHIDE_DESC"] = "當圖示隱藏時觸發此事件（即使 %q 已勾選）。"
L["SOUND_EVENT_ONLEFTCLICK"] = "在左鍵點擊時"
L["SOUND_EVENT_ONLEFTCLICK_DESC"] = "在圖示鎖定的情況下，當你用|cff7fffff左鍵點擊|r這個圖示時觸發此事件。"
L["SOUND_EVENT_ONRIGHTCLICK"] = "在右鍵點擊時"
L["SOUND_EVENT_ONRIGHTCLICK_DESC"] = "在圖示鎖定的情況下，當你用|cff7fffff右鍵點擊|r這個圖示時觸發此事件。"
L["SOUND_EVENT_ONSHOW"] = "在顯示時"
L["SOUND_EVENT_ONSHOW_DESC"] = "當圖示顯示時觸發此事件（即使 %q 已勾選）。"
L["SOUND_EVENT_ONSPELL"] = "在法術改變時"
L["SOUND_EVENT_ONSPELL_DESC"] = "當圖示顯示資訊中的法術/物品/等改變時觸發此事件。"
L["SOUND_EVENT_ONSTACK"] = "在堆疊數量改變時"
L["SOUND_EVENT_ONSTACK_DESC"] = [=[此事件在圖示所檢查的法術/物品等的堆疊數量發生改變時觸發。

包括逐漸降低的%s圖示。]=]
L["SOUND_EVENT_ONSTACKDEC"] = "在疊加數量減少時"
L["SOUND_EVENT_ONSTACKINC"] = "在疊加數量增加時"
L["SOUND_EVENT_ONSTART"] = "在開始時"
L["SOUND_EVENT_ONSTART_DESC"] = "當冷卻開始，增益/減益開始作用，等類似的情況下觸發此事件。"
L["SOUND_EVENT_ONUIERROR"] = "在戰鬥錯誤事件發生時"
L["SOUND_EVENT_ONUIERROR_DESC"] = "此事件在圖示處理一個戰鬥錯誤事件時觸發。"
L["SOUND_EVENT_ONUNIT"] = "在單位改變時"
L["SOUND_EVENT_ONUNIT_DESC"] = "當圖示顯示資訊中的單位改變時觸發此事件。"
L["SOUND_EVENT_WHILECONDITION"] = "當設定的條件通過時"
L["SOUND_EVENT_WHILECONDITION_DESC"] = "此類型的通知事件會在你設定的條件通過時觸發。"
L["SOUND_SOUNDTOPLAY"] = "要播放的音效"
L["SOUND_TAB"] = "音效"
L["SOUND_TAB_DESC"] = "設定用於播放的聲音。你可以使用LibSharedMedia的聲音或者指定一個聲音檔案。"
L["SOUNDERROR1"] = "檔案必須有一個副檔名!"
L["SOUNDERROR2"] = [=[魔獸世界4.0+不支援自訂WAV檔案

（WoW自帶WAV音效可以使用）]=]
L["SOUNDERROR3"] = "只支援OGG和MP3檔案!"
L["SPEED"] = "單位速度"
L["SPEED_DESC"] = [=[這是指單位當前的移動速度，如果單位不移動則為0。
如果您要檢查單位的最高奔跑速度，可以使用'單位奔跑速度'條件來代替。]=]
L["SpeedBoosts"] = "速度提升"
L["SPELL_EQUIV_REMOVE_FAILED"] = "警告：嘗試把「%q」從法術列表「%q」中移除，但是無法找到。"
L["SPELLCHARGES"] = "法術次數"
L["SPELLCHARGES_DESC"] = "檢查像是%s或%s此類法術的可用次數。"
L["SPELLCHARGES_FULLYCHARGED"] = "完全恢復"
L["SPELLCHARGETIME"] = "法術次數恢復計時"
L["SPELLCHARGETIME_DESC"] = "檢查像是%s或%s恢復一次充能還需多少時間。"
L["SPELLCOOLDOWN"] = "法術冷卻"
L["SPELLREACTIVITY"] = "法術反應（激活/觸發/可用）"
L["SPELLTOCHECK"] = "要檢查的法術"
L["SPELLTOCOMP1"] = "進行比較的第一個法術"
L["SPELLTOCOMP2"] = "進行比較的第二個法術"
L["STACKALPHA_DESC"] = "設定在你要求的堆疊數量不符合時圖示需顯示的可視度。"
L["STACKS"] = "堆疊數量"
L["STACKSPANEL_TITLE2"] = "堆疊數量限定"
L["STANCE"] = "姿態"
L["STANCE_DESC"] = [=[你可以利用分號（;）輸入多個用於檢查的姿態。

此條件會在任意一個姿態相符時通過。]=]
L["STANCE_LABEL"] = "姿態"
L["STRATA_BACKGROUND"] = "背景（最低）"
L["STRATA_DIALOG"] = "對話框"
L["STRATA_FULLSCREEN"] = "全螢幕"
L["STRATA_FULLSCREEN_DIALOG"] = "全螢幕對話框"
L["STRATA_HIGH"] = "高"
L["STRATA_LOW"] = "低"
L["STRATA_MEDIUM"] = "中"
L["STRATA_TOOLTIP"] = "提示資訊（最高）"
L["Stunned"] = "擊暈"
L["SUG_BUFFEQUIVS"] = "同類型增益"
L["SUG_CLASSSPELLS"] = "已知的玩家/寵物法術"
L["SUG_DEBUFFEQUIVS"] = "同類型減益"
L["SUG_DISPELTYPES"] = "驅散類型"
L["SUG_FINISHHIM"] = "馬上結束快取"
L["SUG_FINISHHIM_DESC"] = "|cff7fffff點擊|r快速完成該快取/篩選過程。友情提示：您的電腦可能會因此停格幾秒鐘的時間。"
L["SUG_FIRSTHELP_DESC"] = [=[這是一個提示與建議列表，它可以顯示相關的條目供你選擇以加快設定速度。

|cff7fffff滑鼠點擊|r或使用鍵盤|cff7fffff上/下|r箭頭和|cff7fffffTab|r插入條目。

如果你只需要插入名稱，可以無視條目的ID是否正確，只要名稱完全相同即可。

大部分情況下，用名稱來檢查是比較好的選擇。在同個名稱存在多個不同效果可能發生重疊的情況下你才需要使用ID來檢查。

如果你輸入的是一個名稱，則|cff7fffff右鍵點擊|r條目會插入一個ID，反之亦然，你輸入的是ID則|cff7fffff右鍵點擊|r會插入一個名稱。]=]
L["SUG_INSERT_ANY"] = "|cff7fffff點擊滑鼠|r"
L["SUG_INSERT_LEFT"] = "|cff7fffff點擊左鍵|r"
L["SUG_INSERT_RIGHT"] = "|cff7fffff點擊右鍵|r"
L["SUG_INSERT_TAB"] = "或者按|cff7fffffTab|r鍵"
L["SUG_INSERTEQUIV"] = "%s插入同類型條目"
L["SUG_INSERTERROR"] = "%s插入錯誤訊息"
L["SUG_INSERTID"] = "%s插入編號（ID）"
L["SUG_INSERTITEMSLOT"] = "%s插入物品對應的裝備欄位編號"
L["SUG_INSERTNAME"] = "%s插入名稱"
L["SUG_INSERTNAME_INTERFERE"] = [=[|TInterface\AddOns\TellMeWhen\Textures\Alert:0:2|t|cffffa500CAUTION:|TInterface\AddOns\TellMeWhen\Textures\Alert:0:2|t|cffff1111
此法術可能有多個效果。
如果使用名稱可能無法被正確的檢查。
你應當使用一個ID來檢查。 |r]=]
L["SUG_INSERTTEXTSUB"] = "%s插入標籤"
L["SUG_INSERTTUNITID"] = "%s插入單位ID"
L["SUG_MISC"] = "雜項"
L["SUG_MODULE_FRAME_LIKELYADDON"] = "猜測來源：%s"
L["SUG_NPCAURAS"] = "已知NPC的增益/減益"
L["SUG_OTHEREQUIVS"] = "其他同類型"
L["SUG_PATTERNMATCH_FISHINGLURE"] = "魚餌%（%+%d+釣魚技能%）"
L["SUG_PATTERNMATCH_SHARPENINGSTONE"] = "磨利%（%+%d+傷害%）"
L["SUG_PATTERNMATCH_WEIGHTSTONE"] = "增重%（%+%d+傷害%）"
L["SUG_PLAYERAURAS"] = "已知玩家/寵物的增益/減益"
L["SUG_PLAYERSPELLS"] = "你的法術"
L["SUG_TOOLTIPTITLE"] = [=[當你輸入時，TellMeWhen將會在快取中查找並提示你最有可能輸入的法術。

法術按照以下列表分類跟著色。
注意：在記錄到相應的數據之前或是在你沒有登入过其他職業的情況下不會把那些法術放入"已知"開頭的分類中。

點擊一個條目將其插入到編輯框。

]=]
L["SUG_TOOLTIPTITLE_GENERIC"] = [=[當你輸入時，TellMeWhen會嘗試確定你想要輸入的內容。

在某些情況下，建議列表中可能顯示了錯誤的內容。你可以不用選擇建議列表中的條目- 當你輸入編輯框的（正確）內容越長時，TellMeWhen越不容易發生這樣的情況。

點擊一個條目把它插入到編輯框中。]=]
L["SUG_TOOLTIPTITLE_TEXTSUBS"] = [=[下列的單位變數可以使用在輸出顯示的文字內容中。變數將會被替換成與其相應的內容後再輸出顯示。

點擊一個條目將其插入到編輯框中。]=]
L["SUGGESTIONS"] = "提示與建議："
L["SUGGESTIONS_DOGTAGS"] = "DogTags："
L["SUGGESTIONS_SORTING"] = "排序中……"
L["SUN"] = "日蝕"
L["SWINGTIMER"] = "揮擊計時"
L["TABGROUP_GROUP_DESC"] = "設置 TellMeWhen 分組。"
L["TABGROUP_ICON_DESC"] = "設置 TellMeWhen 圖標。"
L["TABGROUP_MAIN_DESC"] = "TellMeWhen綜合設置"
L["TEXTLAYOUTS"] = "文字顯示樣式"
L["TEXTLAYOUTS_ADDANCHOR"] = "新增依附錨點"
L["TEXTLAYOUTS_ADDANCHOR_DESC"] = "點擊增加一個文字依附錨點。"
L["TEXTLAYOUTS_ADDLAYOUT"] = "創建新的文字顯示樣式"
L["TEXTLAYOUTS_ADDLAYOUT_DESC"] = "創建一個你可自行更改設定並應用到圖示的新文字顯示樣式。"
L["TEXTLAYOUTS_ADDSTRING"] = "新增文字顯示方案"
L["TEXTLAYOUTS_ADDSTRING_DESC"] = "新增一個文字顯示方案到此文字顯示樣式中。"
L["TEXTLAYOUTS_BLANK"] = "（空白）"
L["TEXTLAYOUTS_CHOOSELAYOUT"] = "選擇文字顯示樣式……"
L["TEXTLAYOUTS_CHOOSELAYOUT_DESC"] = "選取你要用於此圖示的文字顯示樣式。"
L["TEXTLAYOUTS_CLONELAYOUT"] = "克隆文字顯示樣式"
L["TEXTLAYOUTS_CLONELAYOUT_DESC"] = "點擊創建一個該顯示樣式的副本，你可以單獨修改它。"
L["TEXTLAYOUTS_DEFAULTS_BAR1"] = "計量條顯示樣式 1"
L["TEXTLAYOUTS_DEFAULTS_BAR2"] = "垂直計量條佈局1"
L["TEXTLAYOUTS_DEFAULTS_BINDINGLABEL"] = "綁定/標籤"
L["TEXTLAYOUTS_DEFAULTS_CENTERNUMBER"] = "中間數字"
L["TEXTLAYOUTS_DEFAULTS_DURATION"] = "持續時間"
L["TEXTLAYOUTS_DEFAULTS_ICON1"] = "圖示顯示樣式 1"
L["TEXTLAYOUTS_DEFAULTS_NOLAYOUT"] = "<無顯示樣式>"
L["TEXTLAYOUTS_DEFAULTS_NUMBER"] = "數字"
L["TEXTLAYOUTS_DEFAULTS_SPELL"] = "法術"
L["TEXTLAYOUTS_DEFAULTS_STACKS"] = "堆疊數量"
L["TEXTLAYOUTS_DEFAULTS_WRAPPER"] = "預設：%s"
L["TEXTLAYOUTS_DEFAULTTEXT"] = "預設顯示文字"
L["TEXTLAYOUTS_DEFAULTTEXT_DESC"] = "修改文字顯示樣式在圖示上顯示的預設文字。"
L["TEXTLAYOUTS_DEGREES"] = "%d 度"
L["TEXTLAYOUTS_DELANCHOR"] = "刪除依附錨點"
L["TEXTLAYOUTS_DELANCHOR_DESC"] = "點擊刪除此文字依附錨點"
L["TEXTLAYOUTS_DELETELAYOUT"] = "刪除顯示樣式"
L["TEXTLAYOUTS_DELETELAYOUT_CONFIRM_LISTING"] = "%s: ~%d |4圖示:圖示;"
L["TEXTLAYOUTS_DELETELAYOUT_CONFIRM_NUM2"] = "|cFFFF2929下列設定檔的圖示中使用了這個顯示樣式。如果你要刪除該顯示樣式，圖示將重新使用預設的顯示樣式：|r"
L["TEXTLAYOUTS_DELETELAYOUT_DESC2"] = "點擊刪除此文字顯示樣式"
L["TEXTLAYOUTS_DELETESTRING"] = "刪除文字顯示方案"
L["TEXTLAYOUTS_DELETESTRING_DESC2"] = "從文字顯示樣式中刪除這個文字顯示方案。"
L["TEXTLAYOUTS_DESC"] = "定義的文字顯示樣式能用於你設置的任意一個圖標。"
L["TEXTLAYOUTS_ERR_ANCHOR_BADANCHOR"] = "此文字佈局無法使用在這個群組顯示方式上，請選擇另外的文字佈局。 （未找到依附位置：%s）"
L["TEXTLAYOUTS_ERR_ANCHOR_BADINDEX"] = "文字佈局錯誤：文字顯示#%d嘗試依附到文字顯示#%d，但是%d不存在，所以文字顯示#%d不能正常使用。"
L["TEXTLAYOUTS_ERROR_FALLBACK"] = [=[找不到此圖示使用的文字顯示樣式。在找到相符的顯示樣式或選擇其他顯示樣式之前將使用預設文字顯示樣式。

（你是不是刪除了相關的文字顯示樣式？或只有匯入圖示而沒匯入它使用的文字顯示樣式？）]=]
L["TEXTLAYOUTS_fLAYOUT"] = "文字顯示樣式：%s"
L["TEXTLAYOUTS_FONTSETTINGS"] = "字型設定"
L["TEXTLAYOUTS_fSTRING"] = "文字顯示方案%s"
L["TEXTLAYOUTS_fSTRING2"] = "文字顯示方案 %d：%s"
L["TEXTLAYOUTS_fSTRING3"] = "文字顯示方案：%s"
L["TEXTLAYOUTS_HEADER_DISPLAY"] = "文字顯示方案"
L["TEXTLAYOUTS_HEADER_LAYOUT"] = "文字顯示樣式"
L["TEXTLAYOUTS_IMPORT"] = "匯入文字顯示樣式"
L["TEXTLAYOUTS_IMPORT_CREATENEW"] = "|cff59ff59創建|r 新的"
L["TEXTLAYOUTS_IMPORT_CREATENEW_DESC"] = [=[文字顯示樣式中已有一個跟該顯示樣式相同的唯一標識。

選擇此項創建一個新的唯一標識並匯入這個顯示樣式。]=]
L["TEXTLAYOUTS_IMPORT_NORMAL_DESC"] = "點擊以匯入文字顯示樣式。"
L["TEXTLAYOUTS_IMPORT_OVERWRITE"] = "|cFFFF5959覆寫|r 現有"
L["TEXTLAYOUTS_IMPORT_OVERWRITE_DESC"] = [=[文字顯示樣式中已有一個跟需要匯入的顯示樣式相同的唯一標識。

選擇此項覆寫已有唯一標識的顯示樣式並匯入新的顯示樣式。那些正在使用被覆寫掉的那個文字顯示樣式的圖示都會在匯入後自動作出相應的更新。]=]
L["TEXTLAYOUTS_IMPORT_OVERWRITE_DISABLED_DESC"] = "你無法覆寫預設文字顯示樣式。"
L["TEXTLAYOUTS_LAYOUT_SETDEFAULTS"] = "重設為預設值"
L["TEXTLAYOUTS_LAYOUT_SETDEFAULTS_DESC"] = "重設當前文字顯示樣式設定中所有方案的文字為預設顯示文字。"
L["TEXTLAYOUTS_LAYOUTDISPLAYS"] = [=[文字顯示方案：
%s]=]
L["TEXTLAYOUTS_LAYOUTSETTINGS"] = "顯示樣式設定"
L["TEXTLAYOUTS_LAYOUTSETTINGS_DESC"] = "點擊以設定文字顯示樣式%q。"
L["TEXTLAYOUTS_NOEDIT_DESC"] = [=[這個文字顯示樣式是TellMeWhen預設的文字顯示樣式，你無法對其作出更改。

如果你想更改的話，請克隆一份此文字顯示樣式的副本。]=]
L["TEXTLAYOUTS_POINT2"] = "文字位置"
L["TEXTLAYOUTS_POINT2_DESC"] = "將 %s 的文字顯示到錨定目標。"
L["TEXTLAYOUTS_POSITIONSETTINGS"] = "位置設定"
L["TEXTLAYOUTS_RELATIVEPOINT2_DESC"] = "將文字顯示到 %s 的錨定目標。"
L["TEXTLAYOUTS_RELATIVETO_DESC"] = "文字將依附的對象"
L["TEXTLAYOUTS_RENAME"] = "顯示樣式重新命名"
L["TEXTLAYOUTS_RENAME_DESC"] = "為此文字顯示樣式修改一個與其用途相符的名稱，讓你可以輕鬆的找到它。"
L["TEXTLAYOUTS_RENAMESTRING"] = "顯示方案重新命名"
L["TEXTLAYOUTS_RENAMESTRING_DESC"] = "為此文字顯示方案修改一個與其用途相符的名稱，讓你可以輕鬆的找到它。"
L["TEXTLAYOUTS_RESETSKINAS"] = "%q設定用於文字%q將被重設，以防止跟文字%q的新設定產生衝突。"
L["TEXTLAYOUTS_SETGROUPLAYOUT"] = "文字顯示樣式"
L["TEXTLAYOUTS_SETGROUPLAYOUT_DDVALUE"] = "選擇顯示樣式……"
L["TEXTLAYOUTS_SETGROUPLAYOUT_DESC"] = [=[設定使用於這個群組所有圖示的文字顯示樣式。

每個圖示的文字顯示樣式也可以自行單獨設定。]=]
L["TEXTLAYOUTS_SETTEXT"] = "設定顯示文字"
L["TEXTLAYOUTS_SETTEXT_DESC"] = [=[設定用於這個文字顯示方案中的文字。

文字可能會被轉化為DogTag標記的格式，以便動態顯示資訊。 關於如何使用DogTag標記，請輸入'/dogtag'或'/dt'查看幫助。]=]
L["TEXTLAYOUTS_SIZE_AUTO"] = "自動"
L["TEXTLAYOUTS_SKINAS"] = "使用皮膚"
L["TEXTLAYOUTS_SKINAS_COUNT"] = "堆疊數量"
L["TEXTLAYOUTS_SKINAS_DESC"] = "選擇你需要用於顯示文字的Masque皮膚。"
L["TEXTLAYOUTS_SKINAS_HOTKEY"] = "綁定/標籤"
L["TEXTLAYOUTS_SKINAS_NONE"] = "無"
L["TEXTLAYOUTS_SKINAS_SKINNEDINFO"] = [=[此文字顯示皮膚由Masque設置。 

因此，當此布局用於由Masque設置外觀的TellMeWhen圖標時，下面的設置不會有任何效果。]=]
L["TEXTLAYOUTS_STRING_COPYMENU"] = "複製"
L["TEXTLAYOUTS_STRING_COPYMENU_DESC"] = "點擊打開一個此設定檔中所有已使用的顯示文字列表，你可以將它們加入到這個文字顯示方案中。"
L["TEXTLAYOUTS_STRING_SETDEFAULT"] = "重設為預設值"
L["TEXTLAYOUTS_STRING_SETDEFAULT_DESC"] = [=[重設當前文字顯示方案中的顯示文字為下列預設顯示文字，在該文字顯示樣式中的設定為：

%s]=]
L["TEXTLAYOUTS_STRINGUSEDBY"] = "已使用%d次。"
L["TEXTLAYOUTS_TAB"] = "文字顯示方案"
L["TEXTLAYOUTS_UNNAMED"] = "<未命名>"
L["TEXTLAYOUTS_USEDBY_HEADER"] = "以下設定檔在他們的圖示中使用了此顯示樣式："
L["TEXTLAYOUTS_USEDBY_NONE"] = "此魔獸世界帳號中的TellMeWhen設定檔中沒有使用這個顯示樣式。"
L["TEXTMANIP"] = "文字處理"
L["TOOLTIPSCAN"] = "法術效果變數"
L["TOOLTIPSCAN_DESC"] = "此條件類型允許你檢查某一單位的某個法術效果提示資訊上的第一個變數（數字）。 數字是由暴雪API所提供，跟你在法術效果的提示資訊中看到的數字可能會不同（像是伺服器已經在線修正，客戶端依然顯示錯誤的數字這種情況），同時也不保證一定能夠從法術效果取得一個數字，不過在大多數實際情況下都能檢查到正確的數字。"
L["TOOLTIPSCAN2"] = "提示訊息數字 #%d"
L["TOOLTIPSCAN2_DESC"] = "此條件類型將允許你檢測一個在技能提示訊息面板上找到的數字。"
L["TOP"] = "上"
L["TOPLEFT"] = "左上"
L["TOPRIGHT"] = "右上"
L["TOTEMS"] = "檢查圖騰"
L["TREEf"] = "專精：%s"
L["TRUE"] = "是"
L["UIPANEL_ADDGROUP2"] = "新建 %s 分組"
L["UIPANEL_ADDGROUP2_DESC"] = "|cff7fffff點擊|r 新建 %s 分組。"
L["UIPANEL_ALLOWSCALEIE"] = "允許圖標編輯器縮放"
L["UIPANEL_ALLOWSCALEIE_DESC"] = [=[預設情況下圖標編輯器不允許拖放更改尺寸，以便讓布局比較清新以及完美。

如果你不介意這個或者有特別的原因，那麼請啟用它。]=]
L["UIPANEL_ANCHORNUM"] = "依附錨點 %d"
L["UIPANEL_BAR_BORDERBAR"] = "進度條邊框"
L["UIPANEL_BAR_BORDERBAR_DESC"] = "設置進度條邊框"
L["UIPANEL_BAR_BORDERCOLOR"] = "邊框顏色"
L["UIPANEL_BAR_BORDERCOLOR_DESC"] = "改變圖標和進度條邊框顏色。"
L["UIPANEL_BAR_BORDERICON"] = "圖標邊框"
L["UIPANEL_BAR_BORDERICON_DESC"] = "在紋理，冷卻掃描和其他類似組件周圍設置邊框。"
L["UIPANEL_BAR_FLIP"] = "翻轉圖標"
L["UIPANEL_BAR_FLIP_DESC"] = "將紋理，冷卻掃描和其他類似的組件放置在圖標的另一側。"
L["UIPANEL_BAR_PADDING"] = "填充"
L["UIPANEL_BAR_PADDING_DESC"] = "設置圖標和計時條間距。"
L["UIPANEL_BAR_SHOWICON"] = "顯示圖標"
L["UIPANEL_BAR_SHOWICON_DESC"] = "禁用此設置可隱藏紋理，冷卻掃描和其他類似組件。"
L["UIPANEL_BARTEXTURE"] = "計量條材質"
L["UIPANEL_COLUMNS"] = "欄"
L["UIPANEL_COMBATCONFIG"] = "允許在戰鬥中進行設定"
L["UIPANEL_COMBATCONFIG_DESC"] = [=[啟用這個選項就可以在戰鬥中對TellMeWhen進行設定。

注意，這個選項會導致插件強制載入設定模塊，記憶體的佔用以及插件載入的時間都會隨之增加。

所有角色的設定檔都共同使用該選項。

|cff7fffff需要重新載入UI|cffff5959才能生效。|r]=]
L["UIPANEL_DELGROUP"] = "刪除此群組"
L["UIPANEL_DIMENSIONS"] = "尺寸"
L["UIPANEL_DRAWEDGE"] = "高亮計時器指針"
L["UIPANEL_DRAWEDGE_DESC"] = "高亮冷卻計時器指針（時鐘動畫）來突出顯示效果"
L["UIPANEL_EFFTHRESHOLD"] = "增益效率閥值"
L["UIPANEL_EFFTHRESHOLD_DESC"] = [=[輸入增益/減益的最小時間以便在它們有很高的數值時切換到更有效的檢查模式。 注意：一旦效果的數值超出所選擇的數字的限定，數值較大的效果會優先顯示，而不是按照設定的優先級順序。
]=]
L["UIPANEL_FONT_DESC"] = "選擇圖示堆疊數量文字的字型"
L["UIPANEL_FONT_HEIGHT"] = "高"
L["UIPANEL_FONT_HEIGHT_DESC"] = [=[設定顯示文字的最大高度。如果設為0將自動使用可能的最大高度。

如果這個顯示文字依附於底部或頂部可能會無效。]=]
L["UIPANEL_FONT_JUSTIFY"] = "文字橫向對齊校準"
L["UIPANEL_FONT_JUSTIFY_DESC"] = "設定該文字顯示方案中文字的橫向對齊位置校準（左/中/右）。 "
L["UIPANEL_FONT_JUSTIFYV"] = "文字垂直對齊校準"
L["UIPANEL_FONT_JUSTIFYV_DESC"] = "設定該文字顯示方案中文字的垂直對齊位置校準（左/中/右）。"
L["UIPANEL_FONT_OUTLINE"] = "文字描邊"
L["UIPANEL_FONT_OUTLINE_DESC2"] = "設置文字顯示方案的輪廓樣式。"
L["UIPANEL_FONT_ROTATE"] = "旋轉"
L["UIPANEL_FONT_ROTATE_DESC"] = [=[設定你想要文字顯示旋轉的度數。

此方法不是暴雪自帶的功能，所以可能發生一些奇怪的錯誤，我們也只能做到這了，好運。]=]
L["UIPANEL_FONT_SHADOW"] = "陰影位移"
L["UIPANEL_FONT_SHADOW_DESC"] = "更改文字陰影效果的位移數值，設定為0則停用陰影效果。"
L["UIPANEL_FONT_SIZE"] = "字體大小"
L["UIPANEL_FONT_SIZE_DESC2"] = "改變字體大小。"
L["UIPANEL_FONT_WIDTH"] = "寬"
L["UIPANEL_FONT_WIDTH_DESC"] = [=[設定顯示文字的最大寬度。如果設為0將自動使用可能的最大寬度。

如果這個顯示文字依附於左右兩側可能會無效。]=]
L["UIPANEL_FONT_XOFFS"] = "X位移"
L["UIPANEL_FONT_XOFFS_DESC"] = "附著點的X軸位移值"
L["UIPANEL_FONT_YOFFS"] = "Y位移"
L["UIPANEL_FONT_YOFFS_DESC"] = "附著點的Y軸位移值"
L["UIPANEL_FONTFACE"] = "字型"
L["UIPANEL_FORCEDISABLEBLIZZ"] = "禁用暴雪冷卻文字"
L["UIPANEL_FORCEDISABLEBLIZZ_DESC"] = "強制關閉暴雪內置的冷卻文字顯示。它在你安裝了有此類功能的插件時會自動開啟禁用。"
L["UIPANEL_GLYPH"] = "雕紋"
L["UIPANEL_GLYPH_DESC"] = "檢查你是否使用了某一特定的雕紋。"
L["UIPANEL_GROUP_QUICKSORT_DEFAULT"] = "按照ID排序"
L["UIPANEL_GROUP_QUICKSORT_DURATION"] = "按照持續時間排序"
L["UIPANEL_GROUP_QUICKSORT_SHOWN"] = "顯示的圖標靠前"
L["UIPANEL_GROUPALPHA"] = "群組可視度"
L["UIPANEL_GROUPALPHA_DESC"] = [=[設定整個群組的可視度等級。

此選項對圖示原本的功能沒有任何影響，僅改變這個群組所有圖示的外觀。

如果你要隱藏整個群組並且仍然允許此群組下的圖示正常運作，請將此選項設定為0（該選項有點類似於圖示設定中的%q）。]=]
L["UIPANEL_GROUPNAME"] = "重命名群組"
L["UIPANEL_GROUPRESET"] = "重設位置"
L["UIPANEL_GROUPS"] = "群組"
L["UIPANEL_GROUPS_DROPDOWN"] = "選擇/創建分組"
L["UIPANEL_GROUPS_DROPDOWN_DESC"] = [=[使用此選單載入要配置的其他組，或創建新組。

您也可以|cff7fffff右鍵點擊|r在螢幕上的圖標加載該圖標的組。]=]
L["UIPANEL_GROUPS_GLOBAL"] = "|cff00c300共用|r群組"
L["UIPANEL_GROUPSORT"] = "圖示排列"
L["UIPANEL_GROUPSORT_ADD"] = "增加優先級"
L["UIPANEL_GROUPSORT_ADD_DESC"] = "為分組新增一個圖標優先級排序。"
L["UIPANEL_GROUPSORT_ADD_NOMORE"] = "無可用優先級"
L["UIPANEL_GROUPSORT_ALLDESC"] = [=[|cff7fffff點擊|r更改此排序優先級的方向。
|cff7fffff點擊並拖動|r重新排列。

拖動到底部刪除。]=]
L["UIPANEL_GROUPSORT_alpha"] = "可視度"
L["UIPANEL_GROUPSORT_alpha_1"] = "透明靠前"
L["UIPANEL_GROUPSORT_alpha_-1"] = "不透明靠前"
L["UIPANEL_GROUPSORT_alpha_DESC"] = "群組將根據圖示的可視度來排序"
L["UIPANEL_GROUPSORT_duration"] = "持續時間"
L["UIPANEL_GROUPSORT_duration_1"] = "短持續時間靠前"
L["UIPANEL_GROUPSORT_duration_-1"] = "長持續時間靠前"
L["UIPANEL_GROUPSORT_duration_DESC"] = "群組將根據圖示剩餘的持續時間來排序。"
L["UIPANEL_GROUPSORT_fakehidden"] = "%s"
L["UIPANEL_GROUPSORT_fakehidden_1"] = "總是隱藏靠後"
L["UIPANEL_GROUPSORT_fakehidden_-1"] = "總是隱藏靠前"
L["UIPANEL_GROUPSORT_fakehidden_DESC"] = "按 %q 設置的狀態對組進行排序。"
L["UIPANEL_GROUPSORT_id"] = "圖示ID"
L["UIPANEL_GROUPSORT_id_1"] = "低ID數字靠前"
L["UIPANEL_GROUPSORT_id_-1"] = "高ID數字靠前"
L["UIPANEL_GROUPSORT_id_DESC"] = "群組將根據圖示ID數字來排序。"
L["UIPANEL_GROUPSORT_PRESETS"] = "選擇預設值..."
L["UIPANEL_GROUPSORT_PRESETS_DESC"] = "從預設排序優先級列表中選擇以應用於此圖標。"
L["UIPANEL_GROUPSORT_shown"] = "顯示"
L["UIPANEL_GROUPSORT_shown_1"] = "隱藏的圖標靠前"
L["UIPANEL_GROUPSORT_shown_-1"] = "顯示的圖標靠前"
L["UIPANEL_GROUPSORT_shown_DESC"] = "群組將根據圖示是否顯示來排序。"
L["UIPANEL_GROUPSORT_stacks"] = "堆疊數量"
L["UIPANEL_GROUPSORT_stacks_1"] = "低堆疊靠前"
L["UIPANEL_GROUPSORT_stacks_-1"] = "高堆疊靠前"
L["UIPANEL_GROUPSORT_stacks_DESC"] = "群組將根據每個圖示的堆疊數量來排序。"
L["UIPANEL_GROUPSORT_value"] = "數值"
L["UIPANEL_GROUPSORT_value_1"] = "低數值靠前"
L["UIPANEL_GROUPSORT_value_-1"] = "高數值靠前"
L["UIPANEL_GROUPSORT_value_DESC"] = "按進度條值對組進行排序。 這是 %s 圖標類型提供的值。"
L["UIPANEL_GROUPSORT_valuep"] = "百分比數值"
L["UIPANEL_GROUPSORT_valuep_1"] = "低值％優先"
L["UIPANEL_GROUPSORT_valuep_-1"] = "高值％優先"
L["UIPANEL_GROUPSORT_valuep_DESC"] = "按進度條值百分比對組進行排序。 這是 %s 圖標類型提供的值。"
L["UIPANEL_GROUPTYPE"] = "群組顯示方式"
L["UIPANEL_GROUPTYPE_BAR"] = "計時條"
L["UIPANEL_GROUPTYPE_BAR_DESC"] = "群組使用圖示+進度條的方式來顯示。"
L["UIPANEL_GROUPTYPE_BARV"] = "垂直計量條"
L["UIPANEL_GROUPTYPE_BARV_DESC"] = "在分組中的圖示將會顯示垂直的計量條。"
L["UIPANEL_GROUPTYPE_ICON"] = "圖示"
L["UIPANEL_GROUPTYPE_ICON_DESC"] = "群組使用TellMeWhen傳統的圖示方式來顯示。"
L["UIPANEL_HIDEBLIZZCDBLING"] = "禁用暴雪內建的冷卻完成動畫"
L["UIPANEL_HIDEBLIZZCDBLING_DESC"] = [=[禁止暴雪增加的計時器冷卻結束時的閃光效果。

此效果暴雪新增於6.2版本。]=]
L["UIPANEL_ICONS"] = "圖示"
L["UIPANEL_ICONSPACING"] = "圖示間隔"
L["UIPANEL_ICONSPACING_DESC"] = "同組圖示彼此之間的間隔距離"
L["UIPANEL_ICONSPACINGX"] = "圖示横向間隔"
L["UIPANEL_ICONSPACINGY"] = "圖示縱向間隔"
L["UIPANEL_LEVEL"] = "框架優先級"
L["UIPANEL_LEVEL_DESC"] = "在組的層次內，應該繪制的等級。"
L["UIPANEL_LOCK"] = "鎖定位置"
L["UIPANEL_LOCK_DESC"] = "鎖定此群組，防止移動或改變比例大小"
L["UIPANEL_LOCKUNLOCK"] = "鎖定/解鎖插件"
L["UIPANEL_MAINOPT"] = "主選項"
L["UIPANEL_ONLYINCOMBAT"] = "只在戰鬥中顯示"
L["UIPANEL_PERFORMANCE"] = "性能"
L["UIPANEL_POINT"] = "依附錨點"
L["UIPANEL_POINT2_DESC"] = "將組的 %s 定位到錨定目標。"
L["UIPANEL_POSITION"] = "位置"
L["UIPANEL_PRIMARYSPEC"] = "主要天賦"
L["UIPANEL_PROFILES"] = "設定檔"
L["UIPANEL_PTSINTAL"] = "天賦使用點數（非天賦樹）"
L["UIPANEL_PVPTALENTLEARNED"] = "已學榮譽天賦"
L["UIPANEL_RELATIVEPOINT"] = "依附位置"
L["UIPANEL_RELATIVEPOINT2_DESC"] = "將 %s 的組定位到錨定目標。"
L["UIPANEL_RELATIVETO"] = "依附框架"
L["UIPANEL_RELATIVETO_DESC"] = [=[輸入'/framestack'來觀察當前滑鼠遊標所在框架的提示資訊，以便尋找需要輸入編輯框的框架名稱。

需要更多幫助，請訪問http:////www.wowpedia.org/API_Region_SetPoint]=]
L["UIPANEL_RELATIVETO_DESC_GUIDINFO"] = "當前值是另一群組的唯一識別碼。它是在該分組右鍵點擊並拖拽到另一群組並且\"依附到\"選項被選中時設定的。"
L["UIPANEL_ROLE_DESC"] = "勾選此項允許在你當前專精可以擔任這個職責時顯示群組。"
L["UIPANEL_ROWS"] = "列"
L["UIPANEL_SCALE"] = "比例"
L["UIPANEL_SECONDARYSPEC"] = "第二天賦"
L["UIPANEL_SHOWCONFIGWARNING"] = "顯示設置模式警告"
L["UIPANEL_SPEC"] = "雙天賦"
L["UIPANEL_SPECIALIZATION"] = "天賦類型"
L["UIPANEL_SPECIALIZATIONROLE"] = "專精職責"
L["UIPANEL_SPECIALIZATIONROLE_DESC"] = "檢查你當前專精所能滿足的職責（坦克，治療，傷害輸出）。"
L["UIPANEL_STRATA"] = "框架層級"
L["UIPANEL_STRATA_DESC"] = "應該繪制組的UI的層。"
L["UIPANEL_SUBTEXT2"] = [=[圖示僅在鎖定後開始工作。

在未鎖定時，你可以變更大小或移動圖示群組，右鍵點擊圖示開啟設定頁面。

你可以輸入「/tellmewhen」或「/tmw」來鎖定、解鎖。]=]
L["UIPANEL_TALENTLEARNED"] = "已學天賦"
L["UIPANEL_TOOLTIP_COLUMNS"] = "設定此群組的欄數"
L["UIPANEL_TOOLTIP_GROUPRESET"] = "重設此群組位置跟比例"
L["UIPANEL_TOOLTIP_ONLYINCOMBAT"] = "勾選此項讓該群組只在戰鬥中顯示"
L["UIPANEL_TOOLTIP_ROWS"] = "設定此群組的列數"
L["UIPANEL_TOOLTIP_UPDATEINTERVAL"] = [=[設定圖示顯示/隱藏、可見度、條件等的檢查頻率（秒）。

0為最快。低階電腦設定數值過低會使幀數明顯降低。]=]
L["UIPANEL_TREE_DESC"] = "勾選來允許該組在某個天賦樹激活時顯示，或者不勾選讓它在天賦樹沒激活時隱藏。"
L["UIPANEL_UPDATEINTERVAL"] = "更新頻率"
L["UIPANEL_USE_PROFILE"] = "使用設定檔設置"
L["UIPANEL_WARNINVALIDS"] = "提示無效圖示"
L["UIPANEL_WARNINVALIDS_DESC"] = [=[如果勾選此項， TellMeWhen會在檢測到你的圖標存在無效的設置時警告你。

非常推薦開啟這個選項，某些錯誤的設置可能會讓你的電腦變得非常卡。]=]
L["UNDO"] = "復原"
L["UNDO_DESC"] = "取消最後所做的更改操作。"
L["UNITCONDITIONS"] = "單位條件"
L["UNITCONDITIONS_DESC"] = [=[點擊以便設定條件在上面輸入的全部單位中篩選出你想用於檢查的每個單位。

譯者註：
單位條件可用於像是檢測團隊中哪幾個人缺少耐力，或者像是檢測團隊中的某個坦中了魔法/疾病等等，這只是我隨便舉的兩個例子，實際應用範圍更大。（兩個例子的前提都有在單位框中輸入了player，raid1-40，party1-4）]=]
L["UNITCONDITIONS_STATICUNIT"] = "<圖示單位>"
L["UNITCONDITIONS_STATICUNIT_DESC"] = "該條件將檢查正在被圖示檢查中的每個單位。"
L["UNITCONDITIONS_STATICUNIT_TARGET"] = "<圖示單位>的目標"
L["UNITCONDITIONS_STATICUNIT_TARGET_DESC"] = "該條件檢查圖示正在檢查之中的每個單位的目標。"
L["UNITCONDITIONS_TAB_DESC"] = "設定條件只讓那些你要用到的單位通過。"
L["UNITTWO"] = "第二單位"
L["UNKNOWN_GROUP"] = "<未知/不可用群組>"
L["UNKNOWN_ICON"] = "<未知/不可用圖示>"
L["UNKNOWN_UNKNOWN"] = "<未知???>"
L["UNNAMED"] = "（未命名）"
L["UP"] = "上"
L["VALIDITY_CONDITION_DESC"] = "條件中檢測的圖示是無效的 >>>"
L["VALIDITY_CONDITION2_DESC"] = "第%d個條件>>>"
L["VALIDITY_ISINVALID"] = "。"
L["VALIDITY_META_DESC"] = "整合圖示中檢查的第%d個圖示是無效的 >>>"
L["WARN_DRMISMATCH"] = [=[警告！你正在檢查遞減的法術來自兩個不同的已知分類。

在同一個遞減圖示中，用於檢查的所有法術應當使用同一遞減分類才能使圖示正常運作。

檢測到下列你所使用的法術及其分類：]=]
L["WATER"] = "水之圖騰"
L["worldboss"] = "首領"

end

-- How long before DR resets ?
Data.resetTimes = {
	-- As of 6.1, this is always 18 seconds, and no longer has a range between 15 and 20 seconds.
	default   = 18,
	-- Knockbacks are a special case
	knockback = 10,
}
Data.RESET_TIME = Data.resetTimes.default

-- Successives diminished durations
Data.diminishedDurations = {
	-- Decreases by 50%, immune at the 4th application
	default   = { 0.50, 0.25 },
	-- Decreases by 35%, immune at the 5th application
	taunt     = { 0.65, 0.42, 0.27 },
	-- Immediately immune
	knockback = {},
}

-- Spells and providers by categories
--[[ Generic format:
	category = {
		-- When the debuff and the spell that applies it are the same:
		debuffId = true
		-- When the debuff and the spell that applies it differs:
		debuffId = spellId
		-- When several spells apply the debuff:
		debuffId = {spellId1, spellId2, ...}
	}
--]]

-- See http://eu.battle.net/wow/en/forum/topic/11267997531
-- or http://blue.mmo-champion.com/topic/326364-diminishing-returns-in-warlords-of-draenor/
local spellsAndProvidersByCategory = {

	--[[ TAUNT ]]--
	taunt = {
		-- Death Knight
		[ 56222] = true, -- Dark Command
		[ 57603] = true, -- Death Grip
		-- I have also seen this spellID used for the Death Grip debuff in MoP:
		[ 51399] = true, -- Death Grip
		-- Demon Hunter
		[185245] = true, -- Torment
		-- Druid
		[  6795] = true, -- Growl
		-- Hunter
		[ 20736] = true, -- Distracting Shot
		-- Monk
		[116189] = 115546, -- Provoke
		[118635] = 115546, -- Provoke via the Black Ox Statue -- NEED TESTING
		-- Paladin
		[ 62124] = true, -- Reckoning
		-- Warlock
		[ 17735] = true, -- Suffering (Voidwalker)
		-- Warrior
		[   355] = true, -- Taunt
		-- Shaman
		[ 36213] = true, -- Angered Earth (Earth Elemental)
	},

	--[[ INCAPACITATES ]]--
	incapacitate = {
		-- Druid
		[236025] = true, -- Maim incap
		-- Hunter
		[  3355] = 187650, -- Freezing Trap
		[203337] = 187650, -- Freezing Trap talented
		[213691] = true, -- Scatter Shot
		-- Mage
		[   118] = true, -- Polymorph
		[ 28272] = true, -- Polymorph (pig)
		[ 28271] = true, -- Polymorph (turtle)
		[ 61305] = true, -- Polymorph (black cat)
		[ 61721] = true, -- Polymorph (rabbit)
		[ 61780] = true, -- Polymorph (turkey)
		[126819] = true, -- Polymorph (procupine)
		[161353] = true, -- Polymorph (bear cub)
		[161354] = true, -- Polymorph (monkey)
		[161355] = true, -- Polymorph (penguin)
		[161372] = true, -- Polymorph (peacock)
		[277787] = true, -- Polymorph (direhorn)
		[277792] = true, -- Polymorph (bumblebee)
		[ 82691] = 113724, -- Ring of Frost
		-- Monk
		[115078] = true, -- Paralysis
		-- Paladin
		[ 20066] = true, -- Repentance
		-- Priest
		[ 200196] = 88625, -- Holy Word: Chastise incap
		-- Rogue
		[  1776] = true, -- Gouge
		[  6770] = true, -- Sap
		-- Shaman
		[ 51514] = true, -- Hex
		[211004] = true, -- Hex (spider)
		[210873] = true, -- Hex (raptor)
		[211015] = true, -- Hex (cockroach)
		[211010] = true, -- Hex
		[277784] = true, -- Hex
		[277778] = true, -- Hex
		[269352] = true, -- Hex
		[197214] = true, -- Sundering
		-- Warlock
		[  6789] = true, -- Mortal Coil
		-- Pandaren
		[107079] = true, -- Quaking Palm
		-- Demon Hunter
		[217832] = true, -- Imprison
		[221527] = true, -- Imprison talented
	},

	--[[ SILENCES ]]--
	silence = {
		-- Death Knight
		[ 47476] = true, -- Strangulate
		-- Demon Hunter
		[204490] = 202137, -- Sigil of Silence
		-- Druid
		[81261] = true, -- Solar Beam
		-- Hunter
		[202933] = 202914, -- Spider Sting
		-- Mage
		-- Paladin
		[217824] = 31935, -- Prot pala silence
		-- Priest
		[ 15487] = true, -- Silence
		-- Rogue
		[  1330] = 703, -- Garrote
	},

	--[[ DISORIENTS ]]--
	disorient = {
		-- Death Knight
		[207167] = true, -- Blinding Sleet
		-- Demon Hunter
		[207685] = 207684, -- Sigil of Misery
		-- Druid
		[  2637] = true, -- Hibernate
		[ 33786] = true, -- Cyclone (rdruid/feral)
		[209753] = true, -- Cyclone (Balance)
		[236748] = true, -- Disorienting Roar
		-- Hunter
		-- Mage
		[ 31661] = true, -- Dragon's Breath
		-- Monk
		[198909] = 198898, -- Song of Chi-ji
		[202274] = 115181, -- Incendiary Brew
		-- Paladin
		[105421] = 115750, -- Blinding Light
		-- Priest
		[  8122] = true, -- Psychic Scream
		[   605] = true, -- Dominate Mind
		[226943] = 205369, -- Mind Bomb
		-- Rogue
		[  2094] = true, -- Blind
		-- Warlock
		[118699] = 5782, -- Fear
		[  6358] = true, -- Seduction (Succubus)
		[261589] = 261589, -- Seduction (Player)
		-- Warrior
		[  5246] = true, -- Intimidating Shout
	},

	--[[ STUNS ]]--
	stun = {
		-- Death Knight
		[108194] = true, -- Asphyxiate (unholy/frost)
		[221562] = true, -- Asphyxiate (blood)
		[ 91800] = 47481, -- Gnaw
		[ 91797] = 47481, -- Gnaw (transformed)
		[210141] = 210128, -- Zombie Explosion
		[235612] = 279302, -- frost dk stun
		[287254] = 196770, -- remorseless winter stun
		-- Demon Hunter
		[179057] = true, -- Chaos Nova
		[205630] = 205630, -- Illidan's Grasp, primary effect
		[208618] = 208173, -- Illidan's Grasp, secondary effect
		[211881] = true, -- Fel Eruption
		-- Druid
		[203123] = true, -- Maim stun
		[  5211] = true, -- Mighty Bash
		[163505] = 1822, -- Rake (Stun from Prowl)
		[202244] = 202246, -- Overrun bear stun
		-- Hunter
		[117526] = 109248, -- Binding Shot
		[ 24394] = 19577, -- Intimidation
		-- Mage

		-- Monk
		[202346] = 121253, -- Keg stun
		[119381] =   true, -- Leg Sweep
		-- Paladin
		[   853] = true, -- Hammer of Justice
		-- Priest
		[200200] = 88625, -- Holy word: Chastise stun
		[ 64044] = true, -- Psychic Horror stun
		-- Rogue
		[  1833] = true, -- Cheap Shot
		[   408] = true, -- Kidney Shot
		[199804] = true, -- Between the Eyes
		-- Shaman
		[118345] = true, -- Pulverize (Primal Earth Elemental)
		[118905] = 192058, -- Static Charge (Capacitor Totem)
		[204437] = true, -- Lightning Lasso
		-- Warlock
		[ 89766] = 111898, -- Axe Toss (Felguard)
		[ 89766] = 89766, -- Axe Toss (Felguard) 2
		[ 30283] = true, -- Shadowfury
		-- Warrior
		[132168] = 46968, -- Shockwave
		[132169] = 107570, -- Storm Bolt
		[199085] = 6544, -- Heroic Leap stun
		-- Tauren
		[ 20549] = true, -- War Stomp
		[255723] = true, -- Bull Rush
		-- Kul Tiran
		[287712] = true, -- Haymaker
	},

	--[[ ROOTS ]]--
	root = {
		-- Death Knight
		[204085] = 45524, -- Deathchill root
		[198121] = true, -- Frostbite
		[233395] = 196770, -- Frozen Center
		-- Druid
		[   339] = true, -- Entangling Roots
		[235963] = true, -- Entangling Roots undispellable
		[170855] = 102342, -- Entangling Roots ironbark
		[102359] = true, -- Mass Entanglement
		[ 45334] = 16979, -- Immobilized (wild charge, bear form)
		-- Hunter
		[162480] = 162488, -- Steel Trap root
		[190927] = 190925, -- Harpoon
		[212638] = true, -- tracker's net
		-- Mage
		[   122] = true, -- Frost Nova
		[ 33395] = true, -- Freeze (Water Elemental)
		[228600] = 199786, -- Glacial spike
		-- Monk
		[116706] = 116095, -- Disable
		-- Priest
		-- Warlock
		[233582] = 17962, -- Destro root
		-- Shaman
		[ 64695] = 51485, -- Earthgrab Totem
		[285515] = 196840, -- frost shock root (talent)
	},

	--[[ KNOCKBACK ]]--
	knockback = {
		-- Death Knight
		[108199] = true, -- Gorefiend's Grasp
		-- Druid
		[102793] = true, -- Ursol's Vortex
		[132469] = true, -- Typhoon
		-- Hunter
		-- Shaman
		[ 51490] = true, -- Thunderstorm
		-- Warlock
		[  6360] = true, -- Whiplash
		[115770] = true, -- Fellash
	},
}

-- Map deprecatedCategories to the new ones
local deprecatedCategories = {
	ctrlroot       = true,
	shortroot      = true,
	ctrlstun       = true,
	rndstun        = true,
	cyclone        = true,
	shortdisorient = true,
	fear           = true,
	horror         = true,
	mc             = true,
	disarm         = true,
}

Data.categoryNames = {
	root           = L["Roots"],
	stun           = L["Stuns"],
	disorient      = L["Disorients"],
	silence        = L["Silences"],
	taunt          = L["Taunts"],
	incapacitate   = L["Incapacitates"],
	knockback      = L["Knockbacks"],
}

Data.pveDR = {
	stun     = true,
	taunt    = true,
}

--- List of spellID -> DR category
Data.spells = {}

--- List of spellID => ProviderID
Data.providers = {}

-- Dispatch the spells in the final tables
for category, spells in pairs(spellsAndProvidersByCategory) do

	for spell, provider in pairs(spells) do
		Data.spells[spell] = category
		if provider == true then -- "== true" is really needed
			Data.providers[spell] = spell
			spells[spell] = spell
		else
			Data.providers[spell] = provider
		end
	end
end

-- Warn about deprecated categories
local function CheckDeprecatedCategory(cat)
	if cat and deprecatedCategories[cat] then
		geterrorhandler()(format("Diminishing return category '%s' does not exist anymore. The addon using DRData-1.0 may be outdated. Please consider upgrading it.", cat))
		deprecatedCategories[cat] = nil -- Warn once
	end
end

-- Public APIs
-- Category name in something usable
function Data:GetCategoryName(cat)
	CheckDeprecatedCategory(cat)
	return cat and Data.categoryNames[cat] or nil
end

-- Spell list
function Data:GetSpells()
	return Data.spells
end

-- Provider list
function Data:GetProviders()
	return Data.providers
end

-- Seconds before DR resets
function Data:GetResetTime(category)
	CheckDeprecatedCategory(category)
	return Data.resetTimes[category or "default"] or Data.resetTimes.default
end

-- Get the category of the spellID
function Data:GetSpellCategory(spellID)
	return spellID and Data.spells[spellID] or nil
end

-- Does this category DR in PvE?
function Data:IsPVE(cat)
	CheckDeprecatedCategory(cat)
	return cat and Data.pveDR[cat] or nil
end

-- List of categories
function Data:GetCategories()
	return Data.categoryNames
end

-- Next DR
function Data:NextDR(diminished, category)
	CheckDeprecatedCategory(category)
	local durations = Data.diminishedDurations[category or "default"] or Data.diminishedDurations.default
	for i = 1, #durations do
		if diminished > durations[i] then
			return durations[i]
		end
	end
	return 0
end

-- Iterate through the spells of a given category.
-- Pass "nil" to iterate through all spells.
do
	local function categoryIterator(id, category)
		local newCat
		repeat
			id, newCat = next(Data.spells, id)
			if id and newCat == category then
				return id, category
			end
		until not id
	end

	function Data:IterateSpells(category)
		if category then
			CheckDeprecatedCategory(category)
			return categoryIterator, category
		else
			return next, Data.spells
		end
	end
end

-- Iterate through the spells and providers of a given category.
-- Pass "nil" to iterate through all spells.
function Data:IterateProviders(category)
	if category then
		CheckDeprecatedCategory(category)
		return next, spellsAndProvidersByCategory[category] or {}
	else
		return next, Data.providers
	end
end

--[[ EXAMPLES ]]--
-- This is how you would track DR easily, you're welcome to do whatever you want with the below functions

--[[
local trackedPlayers = {}
local function debuffGained(spellID, destName, destGUID, isEnemy, isPlayer)
	-- Not a player, and this category isn't diminished in PVE, as well as make sure we want to track NPCs
	local drCat = DRData:GetSpellCategory(spellID)
	if( not isPlayer and not DRData:IsPVE(drCat) ) then
		return
	end

	if( not trackedPlayers[destGUID] ) then
		trackedPlayers[destGUID] = {}
	end

	-- See if we should reset it back to undiminished
	local tracked = trackedPlayers[destGUID][drCat]
	if( tracked and tracked.reset <= GetTime() ) then
		tracked.diminished = 1.0
	end
end

local function debuffFaded(spellID, destName, destGUID, isEnemy, isPlayer)
	local drCat = DRData:GetSpellCategory(spellID)
	if( not isPlayer and not DRData:IsPVE(drCat) ) then
		return
	end

	if( not trackedPlayers[destGUID] ) then
		trackedPlayers[destGUID] = {}
	end

	if( not trackedPlayers[destGUID][drCat] ) then
		trackedPlayers[destGUID][drCat] = { reset = 0, diminished = 1.0 }
	end

	local time = GetTime()
	local tracked = trackedPlayers[destGUID][drCat]

	tracked.reset = time + DRData:GetResetTime(drCat)
	tracked.diminished = DRData:NextDR(tracked.diminished, drCat)

	-- Diminishing returns changed, now you can do an update
end

local function resetDR(destGUID)
	-- Reset the tracked DRs for this person
	if( trackedPlayers[destGUID] ) then
		for cat in pairs(trackedPlayers[destGUID]) do
			trackedPlayers[destGUID][cat].reset = 0
			trackedPlayers[destGUID][cat].diminished = 1.0
		end
	end
end

local COMBATLOG_OBJECT_TYPE_PLAYER = COMBATLOG_OBJECT_TYPE_PLAYER
local COMBATLOG_OBJECT_REACTION_HOSTILE = COMBATLOG_OBJECT_REACTION_HOSTILE
local COMBATLOG_OBJECT_CONTROL_PLAYER = COMBATLOG_OBJECT_CONTROL_PLAYER

local eventRegistered = {["SPELL_AURA_APPLIED"] = true, ["SPELL_AURA_REFRESH"] = true, ["SPELL_AURA_REMOVED"] = true, ["PARTY_KILL"] = true, ["UNIT_DIED"] = true}
local function COMBAT_LOG_EVENT_UNFILTERED(self, event, timestamp, eventType, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellID, spellName, spellSchool, auraType)
	if( not eventRegistered[eventType] ) then
		return
	end

	-- Enemy gained a debuff
	if( eventType == "SPELL_AURA_APPLIED" ) then
		if( auraType == "DEBUFF" and DRData:GetSpellCategory(spellID) ) then
			local isPlayer = ( bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) == COMBATLOG_OBJECT_TYPE_PLAYER or bit.band(destFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) == COMBATLOG_OBJECT_CONTROL_PLAYER )
			debuffGained(spellID, destName, destGUID, (bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE), isPlayer)
		end

	-- Enemy had a debuff refreshed before it faded, so fade + gain it quickly
	elseif( eventType == "SPELL_AURA_REFRESH" ) then
		if( auraType == "DEBUFF" and DRData:GetSpellCategory(spellID) ) then
			local isPlayer = ( bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) == COMBATLOG_OBJECT_TYPE_PLAYER or bit.band(destFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) == COMBATLOG_OBJECT_CONTROL_PLAYER )
			local isHostile = (bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE)
			debuffFaded(spellID, destName, destGUID, isHostile, isPlayer)
			debuffGained(spellID, destName, destGUID, isHostile, isPlayer)
		end

	-- Buff or debuff faded from an enemy
	elseif( eventType == "SPELL_AURA_REMOVED" ) then
		if( auraType == "DEBUFF" and DRData:GetSpellCategory(spellID) ) then
			local isPlayer = ( bit.band(destFlags, COMBATLOG_OBJECT_TYPE_PLAYER) == COMBATLOG_OBJECT_TYPE_PLAYER or bit.band(destFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) == COMBATLOG_OBJECT_CONTROL_PLAYER )
			debuffFaded(spellID, destName, destGUID, (bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE), isPlayer)
		end

	-- Don't use UNIT_DIED inside arenas due to accuracy issues, outside of arenas we don't care too much
	elseif( ( eventType == "UNIT_DIED" and select(2, IsInInstance()) ~= "arena" ) or eventType == "PARTY_KILL" ) then
		resetDR(destGUID)
	end
end]]
