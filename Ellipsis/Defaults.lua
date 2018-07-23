local Ellipsis	= _G['Ellipsis']
local LSM		= LibStub('LibSharedMedia-3.0')


-- ------------------------
-- DEFAULT OPTIONS
-- ------------------------
function Ellipsis:GetDefaults()
	return {
		profile = {
			locked			= false,	-- default to being unlocked for first install so anchors can be positioned
			anchorData = { -- base display data for all anchors
				[1]		= {point = 'CENTER', x = -250, y = 128,  alpha = 1.0, scale = 1.0},
				[2]		= {point = 'CENTER', x = 250, y = 128,   alpha = 1.0, scale = 1.0},
				[3]		= {point = 'CENTER', x = -250, y = 48,   alpha = 1.0, scale = 1.0},
				[4]		= {point = 'CENTER', x = 250, y = 48,    alpha = 1.0, scale = 1.0},
				[5]		= {point = 'CENTER', x = -250, y = -32,  alpha = 1.0, scale = 1.0},
				[6]		= {point = 'CENTER', x = 250, y = -32,  alpha = 1.0, scale = 1.0},
				[7]		= {point = 'CENTER', x = 0, y = -112, alpha = 1.0, scale = 1.0},
				['CD']	= {point = 'CENTER', x = 0, y = -152, alpha = 1.0, scale = 1.0},
			},
			control = {
				-- aura restrictions
				showPassiveAuras	= true,
				timeMinLimit		= false,
				timeMinValue		= 4,
				timeMaxLimit		= false,
				timeMaxValue		= 60,
				blacklist 			= {},			-- blacklisted auras by spellID
				whitelist			= {},			-- whitelisted auras by spellID
				filterByBlacklist	= true,			-- filter auras by using a blacklist
				-- grouping and tracking
				unitGroups = { -- set the anchor to display a group in (or false for 'do not show') and the priority (if enabled)
					['target']		= {anchor = 1,		priority = 1},	-- override (priority cannot be changed)
					['focus']		= {anchor = 1,		priority = 2},	-- override (priority cannot be changed)
					['notarget']	= {anchor = 1,		priority = 3},	-- special
					['player']		= {anchor = 0,		priority = 4},	-- base
					['pet']			= {anchor = 0,		priority = 5},	-- base
					['harmful']		= {anchor = 1,		priority = 6},	-- base
					['helpful']		= {anchor = 1,		priority = 7},	-- base
				},
				-- layout (auras [bar style])
				auraBarGrowth		= 'DOWN',		-- DOWN|UP
				auraBarPaddingY		= 2,			-- vertical padding between bars
				-- layout (auras [icon style])
				auraIconGrowth		= 'CENTER',		-- CENTER|LEFT|RIGHT
				auraIconWrapAuras	= true,			-- set whether auras wrap once they reach the unit width
				auraIconPaddingX	= 4,			-- horizontal padding between icons
				auraIconPaddingY	= 16,			-- vertical padding between icons
				-- layout (auras [all styles])
				auraSorting			= 'NAME_ASC',	-- NAME_ASC|NAME_DESC|EXPIRY_ASC|EXPIRY_DESC|CREATE_ASC|CREATE_DESC
				-- layout (units)
				unitGrowth			= 'DOWN',		-- DOWN|UP|LEFT|RIGHT
				unitPaddingX		= 4,
				unitPaddingY		= 4,
				unitSorting			= 'NAME_ASC',	-- NAME_ASC|NAME_DESC|CREATE_ASC|CREATE_DESC
				unitPrioritize		= false			-- whether unit prioritiy overrides chosen sorting method
			},
			auras = {
				style				= 'BAR',		-- BAR|ICON
				interactive			= true,			-- control ability to cancel/announce timers with mouse-clicks
				tooltips			= 'HELPER',		-- FULL|HELPER|OFF
				timeFormat			= 'ABRV',		-- ABRV|TRUN|FULL
				textFormat			= 'AURA',		-- AURA|UNIT|BOTH
				flipIcon			= false,		-- flip icon to the right side of the bar
				ghosting			= true,
				ghostDuration		= 10,
				-- appearance (text)
				textFont			= 'Friz Quadrata TT',
				textFontSize		= 10,
				stacksFont			= 'Arial Narrow',
				stacksFontSize		= 13,
				-- appearance (bar)
				barSize				= 16,			-- height of bar (and width of spell icon)
				barTexture			= 'BantoBar',
				-- appearance (icon)
				iconSize			= 24,			-- height (and width) of spell icon
				-- colours
				colourText			= {1, 1, 1, 1},	-- for spell name and remaining time
				colourStacks		= {1, 1, 1, 1},
				colourGhosting		= {0.5, 0.5, 0.5, 1},
				colourHigh			= {0, 1, 0, 1},	-- colour of aura elements when > 10s remain
				colourMed			= {1, 1, 0, 1},	-- colour of aura elements when > 5-10s remain (gradient from high > med)
				colourLow			= {1, 0, 0, 1},	-- colour of aura elements when < 5s remain (gradient from med > low)
				colourBarBackground	= {0.25, 0.25, 0.25, 1},
			},
			units ={
				width				= 160,			-- also used for auras when in bar style, or for wrap distance in ICON style
				opacityFaded		= 1,			-- set the opacity of units not currently being targeted
				opacityNoTarget		= 1,			-- set the opacity of the notarget unit
				headerHeight		= 16,			-- height of the header block for each unit
				headerFont			= 'Friz Quadrata TT',
				headerFontSize		= 12,
				headerFontStyle		= 'OUTLINE',	-- OUTLINE|THICKOUTLINE|NONE
				headerShowLevel		= true,
				headerColourBy		= 'REACTION',	-- CLASS|REACTION|NONE (NONE = use player chosen colour)
				stripServer			= false,
				collapseAllUnits	= false,
				collapsePlayer		= false,
				collapseNoTarget	= false,
				-- colours
				colourHeader		= {1, 0.82, 0, 1},
				colourFriendly		= {0, 1, 0, 1},
				colourHostile		= {1, 0, 0, 1},
			},
			cooldowns = {
				enabled				= true,
				onlyWhenTracking	= false,
				interactive			= true,			-- control ability to cancel/announce cooldowns with mouse-clicks
				tooltips			= 'FULL',		-- FULL|HELPER|OFF
				-- control
				trackItem			= true,
				trackPet			= true,
				trackSpell			= true,
				blacklist = {
					['ITEM']		= {},			-- blacklisted item cooldowns
					['SPELL']		= {},			-- blacklisted spell (pet and player) cooldowns
				},
				timeMinValue		= 2,			-- always enabled with a minimum greater than the GCD
				timeMaxLimit		= false,
				timeMaxValue		= 60,
				-- appearance
				horizontal			= true,
				texture				= 'BantoBar',
				length				= 200,
				thickness			= 16,
				timeDisplayMax		= 60,
				timeDetailed		= false,
				timeFont			= 'Friz Quadrata TT',
				timeFontSize		= 10,
				offsetTags			= false,
				offsetItem			= 0,
				offsetPet			= 0,
				offsetSpell			= 0,
				-- colours
				colourBar			= {0.5, 0.5, 0.5, 1},
				colourBackdrop		= {0, 0, 0, 1},
				colourBorder		= {0, 0, 0, 1},
				colourText			= {0.75, 0.75, 0.75, 1},
				colourItem			= {0, 0, 1, 1},
				colourPet			= {0, 1, 0, 1},
				colourSpell			= {1, 0, 0, 1},
			},
			notify = {
				outputAnnounce		= 'GROUPS',			-- AUTO|GROUPS|RAID|PARTY|SAY
				outputAlerts		= {					-- storage for LibSink
					['sink20OutputSink'] = 'Default',
				},
				-- aura alerts
				auraBrokenAlerts	= false,
				auraBrokenAudio		= 'Short Circuit',	-- an entry from LSM or 'None'
				auraBrokenText		= true,
				auraExpiredAlerts	= false,
				auraExpiredAudio	= 'Simon Chime',	-- an entry from LSM or 'None'
				auraExpiredText		= true,
				-- cooldown alerts
				coolPrematureAlerts	= false,
				coolPrematureAudio	= 'Short Circuit',	-- an entry from LSM or 'None'
				coolPrematureText	= true,
				coolCompleteAlerts	= false,
				coolCompleteAudio	= 'Simon Chime',	-- an entry from LSM or 'None'
				coolCompleteText	= true,


			},
			advanced = {
				tickRate			= 0.1,
				secondaryScan		= 'OFF',			-- ON|OFF
				secondaryScanTick	= 1,
			},
		}
	}
end


-- ------------------------
-- LSM ADDITIONAL MEDIA
-- ------------------------
function Ellipsis:MediaRegistration()
	-- Copied from Omen giving the same selection whether its installed or not
	LSM:Register('sound', 'Rubber Ducky',			[[Sound\Doodad\Goblin_Lottery_Open01.ogg]])
	LSM:Register('sound', 'Cartoon FX',				[[Sound\Doodad\Goblin_Lottery_Open03.ogg]])
	LSM:Register('sound', 'Explosion',				[[Sound\Doodad\Hellfire_Raid_FX_Explosion05.ogg]])
	LSM:Register('sound', 'Shing!',					[[Sound\Doodad\PortcullisActive_Closed.ogg]])
	LSM:Register('sound', 'Wham!',					[[Sound\Doodad\PVP_Lordaeron_Door_Open.ogg]])
	LSM:Register('sound', 'Simon Chime',			[[Sound\Doodad\SimonGame_LargeBlueTree.ogg]])
	LSM:Register('sound', 'War Drums',				[[Sound\Event Sounds\Event_wardrum_ogre.ogg]])
	LSM:Register('sound', 'Cheer',					[[Sound\Event Sounds\OgreEventCheerUnique.ogg]])
	LSM:Register('sound', 'Humm',					[[Sound\Spells\SimonGame_Visual_GameStart.ogg]])
	LSM:Register('sound', 'Short Circuit',			[[Sound\Spells\SimonGame_Visual_BadPress.ogg]])
	LSM:Register('sound', 'Fel Portal',				[[Sound\Spells\Sunwell_Fel_PortalStand.ogg]])
	LSM:Register('sound', 'Fel Nova',				[[Sound\Spells\SeepingGaseous_Fel_Nova.ogg]])

	-- Additional Choices (all in-game sounds)
	LSM:Register('sound', 'PVP Enter Queue',		[[Sound\Spells\PVPEnterQueue.ogg]])
	LSM:Register('sound', 'PVP Through Queue',		[[Sound\Spells\PVPThroughQueue.ogg]])
	LSM:Register('sound', 'Level Up',				[[Sound\interface\LevelUp.ogg]])
	LSM:Register('sound', 'Raid Warning',			[[Sound\interface\RaidWarning.ogg]])

	-- Additional statusbar choices (imported from SharedMedia)
	--[=[LSM:Register('statusbar', 'Aluminium',			[[Interface\Addons\Ellipsis\StatusBars\Aluminium]])
	LSM:Register('statusbar', 'Armory',				[[Interface\Addons\Ellipsis\StatusBars\Armory]])
	LSM:Register('statusbar', 'BantoBar',			[[Interface\Addons\Ellipsis\StatusBars\BantoBar]])
	LSM:Register('statusbar', 'Bars',				[[Interface\Addons\Ellipsis\StatusBars\Bars]])
	LSM:Register('statusbar', 'Bumps',				[[Interface\Addons\Ellipsis\StatusBars\Bumps]])
	LSM:Register('statusbar', 'Button',				[[Interface\Addons\Ellipsis\StatusBars\Button]])
	LSM:Register('statusbar', 'Charcoal',			[[Interface\Addons\Ellipsis\StatusBars\Charcoal]])
	LSM:Register('statusbar', 'Cilo',				[[Interface\Addons\Ellipsis\StatusBars\Cilo]])
	LSM:Register('statusbar', 'Cloud',				[[Interface\Addons\Ellipsis\StatusBars\Cloud]])
	LSM:Register('statusbar', 'Comet',				[[Interface\Addons\Ellipsis\StatusBars\Comet]])
	LSM:Register('statusbar', 'Dabs',				[[Interface\Addons\Ellipsis\StatusBars\Dabs]])
	LSM:Register('statusbar', 'DarkBottom',			[[Interface\Addons\Ellipsis\StatusBars\DarkBottom]])
	LSM:Register('statusbar', 'Diagonal',			[[Interface\Addons\Ellipsis\StatusBars\Diagonal]])
	LSM:Register('statusbar', 'Empty',				[[Interface\Addons\Ellipsis\StatusBars\Empty]])
	LSM:Register('statusbar', 'Falumn',				[[Interface\Addons\Ellipsis\StatusBars\Falumn]])
	LSM:Register('statusbar', 'Fifths',				[[Interface\Addons\Ellipsis\StatusBars\Fifths]])
	LSM:Register('statusbar', 'Flat',				[[Interface\Addons\Ellipsis\StatusBars\Flat]])
	LSM:Register('statusbar', 'Fourths',			[[Interface\Addons\Ellipsis\StatusBars\Fourths]])
	LSM:Register('statusbar', 'Frost',				[[Interface\Addons\Ellipsis\StatusBars\Frost]])
	LSM:Register('statusbar', 'Glamour',			[[Interface\Addons\Ellipsis\StatusBars\Glamour]])
	LSM:Register('statusbar', 'Glamour2',			[[Interface\Addons\Ellipsis\StatusBars\Glamour2]])
	LSM:Register('statusbar', 'Glamour3',			[[Interface\Addons\Ellipsis\StatusBars\Glamour3]])
	LSM:Register('statusbar', 'Glamour4',			[[Interface\Addons\Ellipsis\StatusBars\Glamour4]])
	LSM:Register('statusbar', 'Glamour5',			[[Interface\Addons\Ellipsis\StatusBars\Glamour5]])
	LSM:Register('statusbar', 'Glamour6',			[[Interface\Addons\Ellipsis\StatusBars\Glamour6]])
	LSM:Register('statusbar', 'Glamour7',			[[Interface\Addons\Ellipsis\StatusBars\Glamour7]])
	LSM:Register('statusbar', 'Glass',				[[Interface\Addons\Ellipsis\StatusBars\Glass]])
	LSM:Register('statusbar', 'Glaze',				[[Interface\Addons\Ellipsis\StatusBars\Glaze]])
	LSM:Register('statusbar', 'Glaze v2',			[[Interface\Addons\Ellipsis\StatusBars\Glaze2]])
	LSM:Register('statusbar', 'Gloss',				[[Interface\Addons\Ellipsis\StatusBars\Gloss]])
	LSM:Register('statusbar', 'Graphite',			[[Interface\Addons\Ellipsis\StatusBars\Graphite]])
	LSM:Register('statusbar', 'Grid',				[[Interface\Addons\Ellipsis\StatusBars\Grid]])
	LSM:Register('statusbar', 'Hatched',			[[Interface\Addons\Ellipsis\StatusBars\Hatched]])
	LSM:Register('statusbar', 'Healbot',			[[Interface\Addons\Ellipsis\StatusBars\Healbot]])
	LSM:Register('statusbar', 'LiteStep',			[[Interface\Addons\Ellipsis\StatusBars\LiteStep]])
	LSM:Register('statusbar', 'LiteStepLite',		[[Interface\Addons\Ellipsis\StatusBars\LiteStepLite]])
	LSM:Register('statusbar', 'Lyfe',				[[Interface\Addons\Ellipsis\StatusBars\Lyfe]])
	LSM:Register('statusbar', 'Melli',				[[Interface\Addons\Ellipsis\StatusBars\Melli]])
	LSM:Register('statusbar', 'Melli Dark',			[[Interface\Addons\Ellipsis\StatusBars\MelliDark]])
	LSM:Register('statusbar', 'Melli Dark Rough',	[[Interface\Addons\Ellipsis\StatusBars\MelliDarkRough]])
	LSM:Register('statusbar', 'Minimalist',			[[Interface\Addons\Ellipsis\StatusBars\Minimalist]])
	LSM:Register('statusbar', 'Otravi',				[[Interface\Addons\Ellipsis\StatusBars\Otravi]])
	LSM:Register('statusbar', 'Outline',			[[Interface\Addons\Ellipsis\StatusBars\Outline]])
	LSM:Register('statusbar', 'Perl',				[[Interface\Addons\Ellipsis\StatusBars\Perl]])
	LSM:Register('statusbar', 'Perl v2',			[[Interface\Addons\Ellipsis\StatusBars\Perl2]])
	LSM:Register('statusbar', 'Pill',				[[Interface\Addons\Ellipsis\StatusBars\Pill]])
	LSM:Register('statusbar', 'Rain',				[[Interface\Addons\Ellipsis\StatusBars\Rain]])
	LSM:Register('statusbar', 'Rocks',				[[Interface\Addons\Ellipsis\StatusBars\Rocks]])
	LSM:Register('statusbar', 'Round',				[[Interface\Addons\Ellipsis\StatusBars\Round]])
	LSM:Register('statusbar', 'Ruben',				[[Interface\Addons\Ellipsis\StatusBars\Ruben]])
	LSM:Register('statusbar', 'Runes',				[[Interface\Addons\Ellipsis\StatusBars\Runes]])
	LSM:Register('statusbar', 'Skewed',				[[Interface\Addons\Ellipsis\StatusBars\Skewed]])
	LSM:Register('statusbar', 'Smooth',				[[Interface\Addons\Ellipsis\StatusBars\Smooth]])
	LSM:Register('statusbar', 'Smooth v2',			[[Interface\Addons\Ellipsis\StatusBars\Smoothv2]])
	LSM:Register('statusbar', 'Smudge',				[[Interface\Addons\Ellipsis\StatusBars\Smudge]])
	LSM:Register('statusbar', 'Steel',				[[Interface\Addons\Ellipsis\StatusBars\Steel]])
	LSM:Register('statusbar', 'Striped',			[[Interface\Addons\Ellipsis\StatusBars\Striped]])
	LSM:Register('statusbar', 'Tube',				[[Interface\Addons\Ellipsis\StatusBars\Tube]])
	LSM:Register('statusbar', 'Water',				[[Interface\Addons\Ellipsis\StatusBars\Water]])
	LSM:Register('statusbar', 'Wglass',				[[Interface\Addons\Ellipsis\StatusBars\Wglass]])
	LSM:Register('statusbar', 'Wisps',				[[Interface\Addons\Ellipsis\StatusBars\Wisps]])
	LSM:Register('statusbar', 'Xeon',				[[Interface\Addons\Ellipsis\StatusBars\Xeon]])--]=]
end
