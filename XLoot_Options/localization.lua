-- See: http://wow.curseforge.com/addons/xloot/localization/ to create or fix translations
local locales = {
	enUS = {
		Core = {
			panel_title = "Global options",
			details = "Skin is applied to all XLoot modules. Most other settings currently require a /reload to be applied. Please open a ticket with any issues.\nTo turn off a single module, disable it like any normal addon.",
			skin = "Skin",
			skin_desc = "Select skin to use. Includes Masque skins",
			skin_anchors = "Apply to anchors",
			skin_anchors_desc = "Apply skin to anchors that XLoot uses",
			module_header = "Module options",
		},
		Frame = {
			panel_title = "Loot Frame",
			panel_desc = "Provides a adjustable loot frame",
			-- Group labels
			frame_options = "Frame settings",
			slot_options = "Loot slots",
			link_button = "Link all button",
			autolooting = "Auto-looting",
			colors = "Colors",

			-- Option labels
			autoloot_currency = "Auto loot currency",
			autoloot_currency_desc = "When to automatically loot currency",
			autoloot_quest = "Auto loot quest items",
			autoloot_quest_desc = "When to automatically loot quest items",
			autoloot_tradegoods = "Auto loot trade goods",
			autoloot_tradegoods_desc = "When to automatically loot any item of Trade Goods type",
			autoloot_all = "Auto loot everything",
			autoloot_list = "Auto loot listed items",
			autoloot_list_desc = "When to automatically loot listed items",
			autoloot_item_list = "Items to loot",
			-- frame_scale = "Frame scale",
			-- frame_alpha = "Frame alpha",
			frame_color_border = "Frame border color",
			frame_color_backdrop = "Frame backdrop color",
			frame_color_gradient = "Frame gradient color",
			frame_width_automatic = "Automatically expand frame",
			frame_width = "Frame width",
			old_close_button = "Use old close button",
			loot_highlight = "Highlight slots on mouseover",
			-- loot_alpha = "Slot alpha",
			loot_color_border = "Loot border color",
			loot_color_backdrop = "Loot backdrop color",
			loot_color_gradient = "Loot gradient color",
			loot_color_info = "Information text color",
			loot_collapse = "Collapse looted slots",
			loot_icon_size = "Loot icon size",
			loot_row_height = "Loot row height",
			quality_color_frame = "Color frame border by top quality",
			quality_color_slot = "Color loot border by quality",
			loot_texts_info = "Show detailed information",
			loot_texts_bind = "Show loot bind type",
			loot_texts_lock = "Show locked status",
			loot_buttons_auto = "Autoloot shortcut",
			loot_buttons_auto_desc = "A button to add any item to your auto-looting list (See below)\nOnly shown when the item would be autolooted",
			font_size_info = "Loot information",
			font_size_bottombuttons = "Linkall/Close",
			frame_snap = "Snap frame to mouse",
			frame_snap_offset_x = "Horizontal snap offset",
			frame_snap_offset_y = "Vertical snap offset",
			frame_grow_upwards = "Expand frame upwards",
			frame_draggable = "Loot frame draggable",
			linkall_threshold = "Minimum chat link quality",
			linkall_channel = "Default chat link channel",
			linkall_show = "Link button visibility",

			autolooting_text = "XLoot's autolooting features act separately from the default UI. As such, if both are enabled, you may recieve warnings like 'that object is busy'. They are safe to ignore, but can be resolved by picking one autoloot method to use exclusively.",

			autolooting_list = "To automatically loot specific items, list them below.\n  Example: Linen Cloth,Ashbringer,Copper Ore",

			autolooting_details = "XLoot will choose the highest setting when deciding to loot a slot. This allows, for example, auto looting everything while solo yet only quest items and money while in a group.",

			show_slot_errors = "Looting errors in chat",
			show_slot_errors_details = "Print a chat message when a loot item cannot be shown for some reason. Most of these should be able to be safely ignored.",
		},
		Group = {
			panel_title = "Group Loot",
			-- Group labels
			anchors = "Anchors",
			rolls = "Roll frames",
			other_frames = "Other frames",
			roll_tracking = "What rolls to show",
			alerts = "Loot alerts",
			extra_info = "Details",

			-- Header labels
			expiration = "Expiration (in seconds)",

			-- Option labels
			text_outline = "Outline text",
			text_outline_desc = "Draws a dark outline around text on roll frames",
			text_time = "Show time remaining",
			text_time_desc = "Displays seconds remaining to roll over item icon",
			text_ilvl = "Show item level",
			role_icon = "Show role icons",
			win_icon = "Show winning type icon",
			show_decided = "Show decided",
			show_undecided = "List waiting players",
			show_undecided_desc = "List players who have not chosen how to roll",
			hook_alert = "Modify loot alerts",
			hook_alert_desc = "('You won..' popups)\nAttach loot alerts to a movable anchor.\n\nDisabling this can improve compatibility with other loot addons. \n\n(Requires ReloadUI)",
			alert_skin = "Skin loot alert frames",
			alert_offset = "Vertical spacing",
			alert_background = "Show background",
			alert_icon_frame = "Show icon frame",
			hook_bonus = "Modify bonus rolls",
			hook_bonus_desc = "Attach bonus loot rolls to a movable anchor.\n\nDisabling this can improve compatibility with other loot addons. \n\n(Requires ReloadUI)",
			bonus_skin = "Skin bonus roll frame",
			roll_width = "Roll frame width",
			roll_button_size = "Roll button size",
			roll_anchor_visible = "Roll anchor visible",
			alert_anchor_visible = "Loot alerts anchor visible",
			alert_anchor_visible_desc = "Refers to 'You won..' popups",
			track_all = "Track all rolls",
			track_player_roll = "Track items you roll on",
			track_by_threshold = "Track items by minimum quality",
			expire_won = "Won rolls",
			expire_lost = "Lost/Passed rolls",
			preview_show = "Show Preview",
			equip_prefix = "Show equippable prefix",
			equip_prefix_desc = "Prefixes item names to indicate if a item can be equipped or is a upgrade. (Upgrade prefix requires the Pawn addon)",
			prefix_equippable = "Equippable prefix",
			prefix_upgrade = "Upgrade prefix",

			hook_warning_text = "Hooking the loot alert and bonus roll frames has rarely been reported to cause issues such as not seeing bonus rolls.\n\nBy enabling these options you acknowledge that you understand and accept that risk.\n",
		},
		Monitor = {
			panel_title = "Loot Monitor",
			-- Group labels
			testing = "Testing",
			anchor = "Anchor",
			thresholds = "Quality thresholds",
			fading = "Row fade times (in seconds)",
			details = "Details",
			-- Option labels
			test_settings = "Click to test settings",
			visible = "Anchor visible",
			show_crafted = "Crafted",
			show_totals = "Show total items in inventory",
			show_ilvl = "Show item level",
			name_width = "Player name width",
		},
		Master = {
			panel_title = "Loot Master",
			-- Group labels
			specialrecipients = "Special Recipients Menu",
			raidroll = "Special Rolls Menu",
			awardannounce = "Announce Item Distribution",
			-- Option labels
			confirm_qualitythreshold = "Minimum confirm quality",
			menu_roll = "Show raid roll",
			menu_disenchant = "Show disenchanter",
 			menu_disenchanters = "Disenchant character names",
			menu_bank = "Show banker",
			menu_bankers = "Banker character names",
			menu_self = "Show self",
			award_qualitythreshold = "Minimum announce quality",
			award_channel = "Default chat announce channel",
			award_guildannounce = "Echo in guild chat",
			award_special = "Announce special recipients",
		},
		font = "Font",
		font_sizes = "Sizes",
		font_size_loot = "Loot",
		font_size_quantity = "Quantity",
		font_flag = "Flag",
		desc_channel_auto = "Highest available",
		growth_direction = "Growth direction",
		alignment = "Alignment",
		scale = "Scale",
		width = "Width",
		alpha = "Opacity",
		spacing = "Spacing",
		offset = "Offset",
		visible = "Visible",
		padding = "Padding",
		items_others = "Others' items",
		items_own = "Own items",
		up = "Up",
		down = "Down",
		left = "Left",
		right = "Right",
		top = "Top",
		bottom = "Bottom",
		minimum_quality = "Minimum quality",
		when_never = "Never",
		when_solo = "Solo",
		when_always = "Always",
		when_auto = "Automatic",
		when_group = "In groups",
		when_party = "In parties",
		when_raid = "In raids",
		confirm_reset_profile = "This will reset all options for this profile. Are you sure?",
		profile = "Profile",
		message_reloadui_warning = "|c2244dd22%s|r: Changing |c2244dd22%s|r requires you to reload your UI before continuing to play: |c2244dd22/reload ui|r",
	},
	-- Possibly localized
	ptBR = {

	},
	frFR = {

	},
	deDE = {

	},
	koKR = {

	},
	esMX = {

	},
	ruRU = {

	},
	zhCN = {

	},
	esES = {

	},
	zhTW = {

	},
}

-- Automatically inserted translations
locales.ptBR["Options"] = {
}

locales.frFR["Options"] = {
}

locales.deDE["Options"] = {
	["alpha"] = "Transparenz",
	["confirm_reset_profile"] = "Dies wird alle Einstellungen für dieses Profil auf den Standard zurücksetzen. Bist du sicher?",
	["desc_channel_auto"] = "Höchste Verfügbare",
	["down"] = "Ab",
	["font"] = "Schriftart",
	["font_size_loot"] = "Beute",
	["font_size_quantity"] = "Menge",
	["font_sizes"] = "Größen",
	["growth_direction"] = "Wachstumsrichtung",
	["items_others"] = "Gegenstand anderer",
	["items_own"] = "Eigene Gegenstände",
	["minimum_quality"] = "Minimale Qualität",
	["profile"] = "Profil",
	["scale"] = "Skalierung",
	["up"] = "Hoch",
	["visible"] = "Sichtbar",
	["when_always"] = "Immer",
	["when_auto"] = "Automatisch",
	["when_group"] = "In Gruppe",
	["when_never"] = "Niemals",
	["when_party"] = "In Gruppen",
	["when_raid"] = "In Schlachtzügen",
	["when_solo"] = "Solo",
	["width"] = "Breite",
}

locales.koKR["Options"] = {
	["alpha"] = "투명도",
	["confirm_reset_profile"] = "이 프로필에 대한 모든 옵션을 초기화합니다. 계속할까요?",
	["down"] = "아래",
	["font"] = "글꼴",
	["font_flag"] = "속성",
	["font_size_loot"] = "전리품",
	["font_size_quantity"] = "수량",
	["font_sizes"] = "크기",
	["growth_direction"] = "확장 방향",
	["items_others"] = "기타 아이템",
	["items_own"] = "자기 아이템",
	["minimum_quality"] = "최소 품질",
	["profile"] = "프로필",
	["scale"] = "크기 비율",
	["up"] = "위",
	["visible"] = "보기",
	["when_always"] = "항상",
	["when_auto"] = "자동",
	["when_group"] = "그룹에서",
	["when_never"] = "안 함",
	["when_party"] = "파티에서",
	["when_raid"] = "공격대에서",
	["when_solo"] = "혼자일 때",
	["width"] = "너비",
}

locales.esMX["Options"] = {
}

locales.ruRU["Options"] = {
	["alpha"] = "Прозрачность",
	["confirm_reset_profile"] = "Это сбросит все параметры этого профиля. Вы уверены?",
	["desc_channel_auto"] = "Наивысший из доступных",
	["down"] = "Вниз",
	["font"] = "Шрифт ",
	["font_flag"] = "Флажок",
	["font_size_loot"] = "Добыча ",
	["font_size_quantity"] = "Количество ",
	["font_sizes"] = "Размеры ",
	["growth_direction"] = "Добавлять новые строки",
	["items_others"] = "Остальные вещи",
	["items_own"] = "Ваши вещи",
	["minimum_quality"] = "Минимальное качество",
	["profile"] = "Профиль",
	["scale"] = "Масштаб",
	["up"] = "Вверх",
	["visible"] = "Видимый",
	["when_always"] = "Всегда",
	["when_auto"] = "Автоматически",
	["when_group"] = "В группе ",
	["when_never"] = "Никогда",
	["when_party"] = "В группе ",
	["when_raid"] = "В рейде ",
	["when_solo"] = "Соло",
	["width"] = "Ширина",
}

locales.zhCN["Options"] = {
	["alpha"] = "透明度",
	["confirm_reset_profile"] = "这将重置此配置文件的全部选项。确定？",
	["desc_channel_auto"] = "最高可得",
	["down"] = "下",
	["font"] = "字体",
	["font_flag"] = "轮廓",
	["font_size_loot"] = "战利品",
	["font_size_quantity"] = "品质",
	["font_sizes"] = "大小",
	["growth_direction"] = "扩展方向",
	["items_others"] = "其他人的物品",
	["items_own"] = "自己的物品",
	["minimum_quality"] = "最低品质",
	["profile"] = "配置文件",
	["scale"] = "比例",
	["up"] = "上",
	["visible"] = "可见",
	["when_always"] = "总是",
	["when_auto"] = "自动",
	["when_group"] = "在队伍/团队中",
	["when_never"] = "从不",
	["when_party"] = "在队伍中",
	["when_raid"] = "在团队中",
	["when_solo"] = "单人",
	["width"] = "宽度",
}

locales.esES["Options"] = {
	["confirm_reset_profile"] = "Esto reseteará todas las opciones de este perfil. ¿Estás seguro?",
	["font"] = "Fuente",
	["font_size_loot"] = "Botín",
	["font_size_quantity"] = "Cantidad",
	["font_sizes"] = "Tamaños",
	["profile"] = "Perfil",
	["when_always"] = "Siempre",
	["when_auto"] = "Automático",
	["when_never"] = "Nunca",
	["when_solo"] = "Solo",
}

locales.zhTW["Options"] = {
	["alpha"] = "透明度",
	["confirm_reset_profile"] = "將會重置此設定檔的所有設定。你確定要重置嗎？",
	["desc_channel_auto"] = "最高可得",
	["down"] = "下",
	["font"] = "字型",
	["font_flag"] = "標示",
	["font_size_loot"] = "戰利品",
	["font_size_quantity"] = "品質",
	["font_sizes"] = "大小",
	["growth_direction"] = "擴展方向",
	["items_others"] = "他人物品",
	["items_own"] = "自己物品",
	["minimum_quality"] = "最低品質",
	["profile"] = "設定檔",
	["scale"] = "比例",
	["up"] = "上",
	["visible"] = "可見",
	["when_always"] = "總是",
	["when_auto"] = "自動",
	["when_group"] = "隊伍/團隊中",
	["when_never"] = "從不",
	["when_party"] = "隊伍中",
	["when_raid"] = "團隊中",
	["when_solo"] = "單人",
	["width"] = "寬度",
}


-- Manually express subtables because apparently I'm the only one who thought to use namespaces the simple way

locales.ptBR["Core"] = {
}

locales.frFR["Core"] = {
}

locales.deDE["Core"] = {
	["anchor_hide"] = "verstecken",
	["skin_legacy"] = "XLoot: Legacy",
	["skin_smooth"] = "XLoot: Smooth",
	["skin_svelte"] = "XLoot: Svelte",
}

locales.koKR["Core"] = {
	["anchor_hide"] = "감춤",
	["anchor_hide_desc"] = [=[이 모듈을 제 위치에 잠급니다.
이는 표시기를 숨기지만,
옵션에서 다시 표시할 수 있습니다.]=],
	["skin_legacy"] = "XLoot: Legacy",
	["skin_smooth"] = "XLoot: Smooth",
	["skin_svelte"] = "XLoot: Svelte",
}

locales.esMX["Core"] = {
}

locales.ruRU["Core"] = {
	["anchor_hide"] = "скрыть ",
	["anchor_hide_desc"] = [=[Заблокируйте положение этого модуля
Это позволит скрыть якорь,
но он может быть показан еще раз в настройках]=],
	["skin_legacy"] = "XLoot: Legacy",
	["skin_smooth"] = "XLoot: Smooth",
	["skin_svelte"] = "XLoot: Svelte",
}

locales.zhCN["Core"] = {
	["anchor_hide"] = "隐藏",
	["anchor_hide_desc"] = [=[在此位置锁定此模块
这将隐藏锚点
但可通过选项重新显示]=],
	["skin_legacy"] = "XLoot: Legacy",
	["skin_smooth"] = "XLoot: Smooth",
	["skin_svelte"] = "XLoot: Svelte",
	details = "外观被应用在所有的XLoot模块中。大部分设定需要使用/reload指令才能生效。如果有问题请联系",
	module_header = "模块选项",
	panel_title = "全局选项",
	skin = "外观设置",
	skin_anchors = "应用到锚点",
	skin_anchors_desc = "应用外观设置到XLoot使用的锚点",
	skin_desc = "选择要使用的外观设置，包括Masque外观设置",
}

locales.esES["Core"] = {
}

locales.zhTW["Core"] = {
	["anchor_hide"] = "隱藏",
	["anchor_hide_desc"] = [=[鎖定此模組在此位置上
這會隱藏此錨點,
但它可以藉由選項再次顯示]=],
	["skin_legacy"] = "XLoot: 傳統",
	["skin_smooth"] = "XLoot: 滑順",
	["skin_svelte"] = "XLoot: 苗條",
	details = "外觀配置被套用到所有的XLoot模組。大多設定需要使用指令/reload才能被套用。如果有任何問題請回報。",
	module_header = "模組設定",
	panel_title = "整體設定",
	skin = "外觀配置",
	skin_anchors = "套用到錨點",
	skin_anchors_desc = "套用外觀配置到XLoot使用的錨點",
	skin_desc = "選擇要使用的外觀配置。含Masque配置",
}


locales.ptBR["Frame"] = {
}

locales.frFR["Frame"] = {
	["bind_on_equip_short"] = "LqE",
	["bind_on_pickup_short"] = "LqR",
	["bind_on_use_short"] = "LqU",
	["button_close"] = "Fermer",
	["button_link"] = "Lien",
	["linkall_threshold_missed"] = "Aucun butin ne correspond à votre seuil de qualité",
}

locales.deDE["Frame"] = {
	["bind_on_equip_short"] = "BoE",
	["bind_on_pickup_short"] = "BoP",
	["bind_on_use_short"] = "BoU",
	["button_close"] = "Schließen",
	["button_link"] = "Senden",
	["linkall_threshold_missed"] = "Beute entspricht nicht deinen Qualitätsansprüchen",
}

locales.koKR["Frame"] = {
	["bind_on_equip_short"] = "착귀",
	["bind_on_pickup_short"] = "획귀",
	["bind_on_use_short"] = "사귀",
	["button_close"] = "닫기",
	["button_link"] = "링크",
	["linkall_threshold_missed"] = "당신의 품질 기준을 만족하는 전리품 없음",
}

locales.esMX["Frame"] = {
}

locales.ruRU["Frame"] = {
	["bind_on_equip_short"] = "БоЕ",
	["bind_on_pickup_short"] = "БоП",
	["bind_on_use_short"] = "Становится персональным при использовании",
	["button_close"] = "Закрыть",
	["button_link"] = "Ссылка",
	["linkall_threshold_missed"] = "Нет добычи, удовлетворяющей установленному порогу качества",
}

locales.zhCN["Frame"] = {
	["bind_on_equip_short"] = "装备后绑定",
	["bind_on_pickup_short"] = "拾取后绑定",
	["bind_on_use_short"] = "使用后绑定",
	["button_close"] = "关闭",
	["button_link"] = "链接",
	["linkall_threshold_missed"] = "没有达到拾取品质门槛的物品",
	autoloot_all = "自动拾取所有物品",
	autoloot_currency = "自动拾取货币",
	autoloot_currency_desc = "何时自动拾取货币",
	autolooting = "自动拾取",
	autolooting_details = "XLoot将会在拾取时选择最高的设置。",
	autolooting_list = [=[要自动拾取的特定物品，请在下面列出来。
例如：亚麻布,灰烬使者,铜矿石]=],
	autolooting_text = "XLoot的自动拾取功能和默认UI的设置是分开的。如果两者同时开启，你可能会收到像“物品忙碌中”的警告。这个信息是可以忽略的，但是如果想解决这个问题，你可以只开启其中的一项。",
	autoloot_item_list = "可拾取的物品",
	autoloot_list = "自动拾取列表中的物品",
	autoloot_list_desc = "什么时候自动拾取列表中的物品",
	autoloot_quest = "自动拾取任务物品",
	autoloot_quest_desc = "何时自动拾取任务物品",
	autoloot_tradegoods = "自动拾取贸易物资",
	autoloot_tradegoods_desc = "何时自动拾取任意类型的贸易物资",
	colors = "颜色",
	font_size_bottombuttons = "全部链接/关闭",
	font_size_info = "拾取信息",
	frame_color_backdrop = "框架背景颜色",
	frame_color_border = "框架边框颜色",
	frame_color_gradient = "框架梯度颜色",
	frame_draggable = "拾取框架是否可拖动",
	frame_grow_upwards = "向上扩展框体",
	frame_options = "框架设置",
	frame_snap = "框架附着在鼠标上",
	frame_snap_offset_x = "水平附着位移",
	frame_snap_offset_y = "垂直附着位移",
	frame_width = "框架宽度",
	frame_width_automatic = "自动延伸框架",
	linkall_channel = "默认链接的聊天频道",
	linkall_show = "链接按钮可见",
	linkall_threshold = "最低聊天频道输出品质",
	link_button = "链接全部按钮",
	loot_buttons_auto = "自动拾取快捷方式",
	loot_buttons_auto_desc = [=[一个添加任何物品至自动拾取列表(见下方)的按钮
仅当该物品可以被自动拾取时显示]=],
	loot_collapse = "收起战利品格子",
	loot_color_backdrop = "拾取背景颜色",
	loot_color_border = "拾取边框颜色",
	loot_color_gradient = "拾取梯度颜色",
	loot_color_info = "物品信息字体颜色",
	loot_highlight = "鼠标停留时高亮格子",
	loot_icon_size = "战利品图标大小",
	loot_row_height = "战利品行高度",
	loot_texts_bind = "显示绑定模式",
	loot_texts_info = "显示详细信息",
	loot_texts_lock = "显示锁定状态",
	old_close_button = "使用旧版关闭按钮",
	panel_desc = "产生一个可调节的拾取框架",
	panel_title = "拾取框架",
	quality_color_frame = "以最高物品品质改变框架边框颜色",
	quality_color_slot = "按拾取物品的品质改变边框颜色",
	slot_options = "拾取格子",
}

locales.esES["Frame"] = {
}

locales.zhTW["Frame"] = {
	["bind_on_equip_short"] = "裝綁",
	["bind_on_pickup_short"] = "拾榜",
	["bind_on_use_short"] = "使綁",
	["button_close"] = "關閉",
	["button_link"] = "連結",
	["linkall_threshold_missed"] = "沒有達到品質門檻的戰利品",
	autoloot_all = "自動拾取所有物品",
	autoloot_currency = "自動拾取貨幣",
	autoloot_currency_desc = "何時自動拾取貨幣",
	autolooting = "自動拾取",
	autolooting_details = "XLoot進行拾取物品時會選最高級的設定。例如：單人的時候自動拾取所有物品，並且在隊伍中只拾取任務物品及金錢。",
	autolooting_list = [=[要自動拾取特定物品，請列在下方。
例：亞麻布，灰燼使者，銅礦]=],
	autolooting_text = "XLoot的自動拾取設計和預設UI的設定是分開的。因此，如果兩者都被啟用，你可能會看到「物品忙碌中」的警告訊息。這些訊息是可以被忽略的，如果你不想看到這些訊息，請你在兩者設定中擇一使用。",
	autoloot_item_list = "可拾取的物品",
	autoloot_list = "自動拾取表列物品",
	autoloot_list_desc = "何時自動拾取表列物品",
	autoloot_quest = "自動拾取任務物品",
	autoloot_quest_desc = "何時要自動拾取任務物品",
	autoloot_tradegoods = "自動拾取商業物品",
	autoloot_tradegoods_desc = "何時自動拾取任何商業物品類型的物品",
	colors = "色彩",
	font_size_bottombuttons = "全部連結/關閉",
	font_size_info = "拾取資訊",
	frame_color_backdrop = "框架背景顏色",
	frame_color_border = "框架邊框顏色",
	frame_color_gradient = "框架漸層顏色",
	frame_draggable = "拾取框架可移動",
	frame_grow_upwards = "框架向上擴展",
	frame_options = "框架設定",
	frame_snap = "附著在滑鼠游標",
	frame_snap_offset_x = "水平附著距離",
	frame_snap_offset_y = "垂直附著距離",
	frame_width = "框架寬度",
	frame_width_automatic = "自動延展框架",
	linkall_channel = "預設連結輸出頻道",
	linkall_show = "連結按鈕可見",
	linkall_threshold = "最低連結輸出品質",
	link_button = "連結全部按鈕",
	loot_buttons_auto = "自動拾取捷徑",
	loot_buttons_auto_desc = [=[一個用來增加任何物品到自動拾取清單的按鈕(見下方)
只有當此物品可以自動拾取才顯示]=],
	loot_collapse = "收合戰利品格子",
	loot_color_backdrop = "戰利品背景顏色",
	loot_color_border = "戰利品邊框顏色",
	loot_color_gradient = "戰利品漸層顏色",
	loot_color_info = "物品資訊字體顏色",
	loot_highlight = "按滑鼠游標高亮格子",
	loot_icon_size = "戰利品圖標大小",
	loot_row_height = "戰利品行列高度",
	loot_texts_bind = "顯示綁定模式",
	loot_texts_info = "顯示詳細資訊",
	loot_texts_lock = "顯示鎖定狀態",
	old_close_button = "使用舊版關閉按鈕",
	panel_desc = "提供一個可調整的拾取框架",
	panel_title = "拾取框架",
	quality_color_frame = "按戰利品最高品質變更框架的邊框顏色",
	quality_color_slot = "按戰利品品質變更邊框顏色",
	slot_options = "戰利品格子",
}


locales.ptBR["Group"] = {
	["alert_anchor"] = "Aparecer Saques",
}

locales.frFR["Group"] = {
}

locales.deDE["Group"] = {
	["alert_anchor"] = "Beute Popups",
	["anchor"] = "Gruppenwürfe",
	["undecided"] = "Unentschlossen",
}

locales.koKR["Group"] = {
	["alert_anchor"] = "전리품 팝업",
	["anchor"] = "그룹 주사위",
	["undecided"] = "미결정",
}

locales.esMX["Group"] = {
}

locales.ruRU["Group"] = {
	["alert_anchor"] = "Всплывающие фреймы добычи",
	["anchor"] = "Броски группы",
	["undecided"] = "Не принял решения",
}

locales.zhCN["Group"] = {
	["alert_anchor"] = "掷骰弹窗锚点",
	["anchor"] = "团队掷骰锚点",
	["undecided"] = "未决定的",
	alert_anchor_visible = "拾取弹出框体锚点可见",
	alert_anchor_visible_desc = "参照“你赢得...”框架，或者警报框架",
	alert_background = "显示背景",
	alert_icon_frame = "显示图标框体",
	alert_offset = "垂直间隔",
	alerts = "战利品警告",
	alert_skin = "应用外观配置到弹出界面",
	alert_skin_desc = "参照“你赢得...”框架，或者警报框架",
	anchors = "锚点",
	bonus_skin = "额外拾取窗体外观",
	equip_prefix = "标示可装备的",
	equip_prefix_desc = "如果物品可装备或可提升则标示物品名称。(标示提升需要Pawn插件)",
	expiration = "过期 (秒)",
	expire_lost = "失败/忽略的掷骰",
	expire_won = "胜利的掷骰",
	extra_info = "细节",
	hook_alert = "调整拾取警报",
	hook_alert_desc = [=[('你赢得了n..' popups)
将拾取警报吸附至一个可移动的锚点

禁用此项可提升与其他拾取插件的兼容性. 

(需要重载用户界面 /console reloadui,/rl)]=],
	hook_bonus = "调整额外掷骰",
	hook_bonus_desc = [=[将额外掷骰吸附至一个可移动的锚点

禁用此项可提升与其他拾取插件的兼容性. 

(需要重载用户界面 /console reloadui,/rl)]=],
	other_frames = "其他框体",
	panel_title = "群体拾取框体",
	prefix_equippable = "可装备物品的标示",
	prefix_upgrade = "可升级物品的标示",
	preview_show = "显示预览",
	role_icon = "显示角色图标",
	roll_anchor_visible = "掷骰锚点可见",
	roll_button_size = "掷骰按钮大小",
	rolls = "掷骰框体",
	roll_tracking = "显示哪些掷骰",
	roll_width = "掷骰框体宽度",
	show_decided = "显示已决定",
	show_undecided = "列出等待中的玩家",
	show_undecided_desc = "列出还没有选择掷骰的玩家",
	text_outline = "加边框的文字",
	text_outline_desc = "给掷骰框体上的文字加上暗色边框",
	text_time = "显示剩余时间",
	text_time_desc = "在物品图标上显示决定剩余时间",
	track_all = "追踪所有的掷骰",
	track_by_threshold = "按最低品质追踪物品",
	track_player_roll = "追踪你掷骰的物品",
	win_icon = "显示胜利者类型图标",
}

locales.esES["Group"] = {
}

locales.zhTW["Group"] = {
	["alert_anchor"] = "拾取彈出視窗定位",
	["anchor"] = "團體擲骰定位",
	["undecided"] = "未決",
	alert_anchor_visible = "拾取彈出視窗錨點可見",
	alert_anchor_visible_desc = "參照「你贏得…」框架或是通知框架",
	alert_background = "顯示背景",
	alert_icon_frame = "顯示圖標框架",
	alert_offset = "垂直間隔",
	alerts = "戰利品通知",
	alert_skin = "套用外觀配置到拾取彈出視窗",
	alert_skin_desc = "參照「你贏得…」框架或是通知框架",
	anchors = "對齊錨點",
	bonus_skin = "套用外觀配置到額外擲骰視窗",
	equip_prefix = "顯示可裝備的文字",
	equip_prefix_desc = "標示物品名稱以辨別物品是否可裝備或是可改善身上的裝備。(可改善的標示需要另外安裝Pawn)",
	expiration = "過期 (秒)",
	expire_lost = "失敗/忽略的擲骰",
	expire_won = "勝利的擲骰",
	extra_info = "細節",
	hook_alert = "改變拾取警報",
	hook_alert_desc = [=[('你贏得..'的彈出視窗)
黏附物品警報到一個可移動的錨點。

取消此功能可以增進與其他拾取插件的相容度。

(需要重載UI)]=],
	hook_bonus = "改變加成骰",
	hook_bonus_desc = [=[黏附加成骰的介面到一個可移動的錨點。

取消此功能可以增進與其他拾取插件的相容度。

(需要重載UI)]=],
	other_frames = "其他框架",
	panel_title = "群體拾取框架",
	prefix_equippable = "可裝備物品的標示",
	prefix_upgrade = "可改善物品的標示",
	preview_show = "顯示預覽",
	role_icon = "顯示角色圖示",
	roll_anchor_visible = "擲骰錨點可見",
	roll_button_size = "擲骰按鈕大小",
	rolls = "擲骰框架",
	roll_tracking = "要顯示哪些擲骰",
	roll_width = "擲骰框架寬度",
	show_decided = "顯示已決定",
	show_undecided = "列出等待中的玩家",
	show_undecided_desc = "列出誰還沒有選擇貪需",
	text_outline = "文字加外框",
	text_outline_desc = "在貪需框架的文字外加上外框",
	text_time = "顯示剩餘時間",
	text_time_desc = "在物品按鈕上顯示決定貪需的剩餘時間",
	track_all = "追蹤所有的擲骰",
	track_by_threshold = "按最小品質追蹤物品",
	track_player_roll = "追蹤你擲骰的物品",
	win_icon = "顯示贏家貪需圖示",
}


locales.ptBR["Monitor"] = {
}

locales.frFR["Monitor"] = {
}

locales.deDE["Monitor"] = {
	["anchor"] = "Beutemonitor",
}

locales.koKR["Monitor"] = {
	["anchor"] = "전리품 모니터",
}

locales.esMX["Monitor"] = {
}

locales.ruRU["Monitor"] = {
	["anchor"] = "Монитор добычи",
}

locales.zhCN["Monitor"] = {
	["anchor"] = "掷骰监控",
	anchor = "锚点",
	details = "细节",
	fading = "淡出时间 (秒)",
	panel_title = "拾取监控",
	show_coin = "显示掉落的金钱",
	show_totals = "显示背包内物品总数",
	testing = "测试",
	test_settings = "点击以测试设置",
	thresholds = "品质阈值",
	visible = "锚点可见",
	name_width = "玩家名字宽度",
}

locales.esES["Monitor"] = {
}

locales.zhTW["Monitor"] = {
	["anchor"] = "拾取監控",
	anchor = "對齊錨點",
	details = "細節",
	fading = "淡出時間 (秒)",
	panel_title = "拾取監控",
	show_coin = "顯示掉落的金錢",
	show_totals = "顯示包包中物品總數",
	testing = "測試中",
	test_settings = "點擊以測試設定",
	thresholds = "品質門檻",
	visible = "對齊錨點可見",
	name_width = "玩家名字寬度",	
}


locales.ptBR["Master"] = {
}

locales.frFR["Master"] = {
}

locales.deDE["Master"] = {
	["BINDING_BANKER"] = "Setze Bankier",
	["BINDING_DISENCHANTER"] = "Setze Entzauberer",
	["ITEM_AWARDED"] = "%s erhielt: %s",
	["ML_BANKER"] = "Bankier",
	["ML_DISENCHANTER"] = "Entzauberer",
	["ML_RANDOM"] = "Schlachtzugswurf",
	["ML_SELF"] = "Eigenständiges Plündern",
	["RECIPIENTS"] = "Spezieller Empfänger",
	["SPECIALROLLS"] = "Spezielle Würfe",
}

locales.koKR["Master"] = {
	["BINDING_BANKER"] = "은행원 설정",
	["BINDING_DISENCHANTER"] = "마법부여사 설정",
	["ITEM_AWARDED"] = "%s |1을;를; 획득했습니다: %s",
	["ML_BANKER"] = "은행인",
	["ML_DISENCHANTER"] = "마법부여사",
	["ML_RANDOM"] = "공격대 주사위",
	["RECIPIENTS"] = "특별 수령인",
	["SPECIALROLLS"] = "특별 주사위",
}

locales.esMX["Master"] = {
}

locales.ruRU["Master"] = {
	["BINDING_BANKER"] = "Назначить банкира",
	["BINDING_DISENCHANTER"] = "Назначить дизенчантера",
	["ITEM_AWARDED"] = "%s получает: %s",
	["ML_BANKER"] = "Банкир",
	["ML_DISENCHANTER"] = "Дизенчантер",
	["ML_RANDOM"] = "Raid Roll",
	["ML_SELF"] = "Своя добыча",
	["RECIPIENTS"] = "Особые получатели",
	["SPECIALROLLS"] = "Особые броски",
}

locales.zhCN["Master"] = {
	["BINDING_BANKER"] = "设置银行存放者",
	["BINDING_DISENCHANTER"] = "设置附魔分解者",
	["ITEM_AWARDED"] = "%s 获得了： %s",
	["ML_BANKER"] = "银行存放者",
	["ML_DISENCHANTER"] = "附魔分解者",
	["ML_RANDOM"] = "团队掷骰",
	["ML_SELF"] = "自己掷骰",
	["RECIPIENTS"] = "特殊接收者",
	["SPECIALROLLS"] = "特殊掷骰",
	awardannounce = "发布物品分配",
	award_channel = "默认发布的聊天频道",
	award_guildannounce = "显示在公会聊天频道",
	award_qualitythreshold = "最低发布品质",
	award_special = "发布特殊接收者",
	confirm_qualitythreshold = "最低确认品质",
	menu_bank = "显示存放银行者",
	menu_bankers = "银行存放者角色名",
	menu_disenchant = "显示附魔分解者",
	menu_disenchanters = "附魔分解者角色名",
	menu_roll = "显示团队掷骰",
	menu_self = "显示自己",
	panel_title = "拾取分配",
	raidroll = "特殊拾取菜单",
	specialrecipients = "特殊配方菜单",
}

locales.esES["Master"] = {
}

locales.zhTW["Master"] = {
	["BINDING_BANKER"] = "設定存放銀行者",
	["BINDING_DISENCHANTER"] = "設定附魔分解者",
	["ITEM_AWARDED"] = "%s 給與: %s",
	["ML_BANKER"] = "銀行存放者",
	["ML_DISENCHANTER"] = "附魔分解者",
	["ML_RANDOM"] = "團隊擲骰",
	["ML_SELF"] = "自己拾取",
	["RECIPIENTS"] = "特殊接受者",
	["SPECIALROLLS"] = "特殊擲骰",
	awardannounce = "公告物品分配",
	award_channel = "預設輸出的聊天頻道",
	award_guildannounce = "同步顯示在公會頻道",
	award_qualitythreshold = "最低公佈品質",
	award_special = "通報特殊接受者",
	confirm_qualitythreshold = "最小需確認品質",
	menu_bank = "顯示存放銀行者",
	menu_bankers = "銀行存放者角色名稱",
	menu_disenchant = "顯示附魔分解者",
	menu_disenchanters = "附魔分解者角色名稱",
	menu_roll = "顯示團隊擲骰",
	menu_self = "顯示自己",
	panel_title = "拾取分配者",
	raidroll = "特殊擲骰選單",
	specialrecipients = "特殊配方選單",
}


XLoot:Localize("Options", locales)
