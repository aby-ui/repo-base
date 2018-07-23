-----####Config.lua 1.9####
-----1.22增加一个按钮(宠物头像着色)
-----1.3增加一个按钮(breedid),按下按钮刷新PetJournalPetCard
-----1.35应用新的ShowMaxValue函数，并增加BreedID按钮
-----1.36增加放弃快捷键是否确认
-----1.4增加鼠标提示信息的开关
-----1.41增加隐藏其他UI的开关---功能生效需要/reload
-----1.51:UpdateStoneButton_Click，查看石头/四灵
-----1.6:设置界面整合进暴雪UI
-----1.7:增加BreedIDStyle/新的按钮:BandageButton
-----1.79:配合Ability.lua的修改.
-----1.8:解决某些情况下,需要点击2次config按钮才能打开设置界面
-----1.9:解决部分按钮在其他语言下错误显示的问题

--~ Globals
local _
local _G = getfenv(0)
local hooksecurefunc, tinsert, pairs, wipe = _G.hooksecurefunc, _G.table.insert, _G.pairs, _G.wipe
local ipairs = _G.ipairs
local C_PetJournal = _G.C_PetJournal
--~ --------
local addonname,addon = ...
local L = addon.L


local HPetOption = CreateFrame("Frame","HPetOption",InterfaceOptionsFramePanelContainer)

HPetOption:Hide()
--~ tinsert(UISpecialFrames, "HPetOption")


function HPetOption:Init()
	-- init frame
	self:SetWidth(320); self:SetHeight(400);
	self:SetPoint("CENTER")
	self:SetToplevel(true)
	self:SetMovable(true)
	self:SetClampedToScreen(true)

	-- background
	self:SetBackdrop( {
	  bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16,
	  insets = { left = 5, right = 5, top = 5, bottom = 5 }
	});
	self:SetBackdropColor(0,0,0)

	-- drag
	self:EnableMouse(true)
	self:RegisterForDrag("LeftButton")
	self:SetScript("OnDragStart",function(self) self:StartMoving() end)
	self:SetScript("OnDragStop",function(self) self:StopMovingOrSizing() end)

	-- title
	self:CreateFontString("HPetOptionTitle","OVERLAY","GameFontHighlight")
	HPetOptionTitle:SetPoint("TOP",0,-10)
	HPetOptionTitle:SetTextColor(1,1,0)
	HPetOptionTitle:SetText(L["HPet Options"])

	-- bottom title
	self:CreateFontString("HPetOptionBTitle","OVERLAY","GameFontHighlight")
	HPetOptionBTitle:SetPoint("BOTTOM",0,55)
	HPetOptionBTitle:SetTextColor(1,1,0)
	HPetOptionBTitle:SetText(L["bottom title"])


	-- buttons
	HPetOption:InitButtons()


	-- read options
	HPetOption:LoadOptions()

	--do
	self.ready = true
end

function HPetOption:InitButtons()
	self.Buttons={
		---confing buttons
		{name="Close",type="Button",inherits="UIPanelCloseButton",
			point="TOPRIGHT",
			func=function() HPetOption:Hide() end,
		},
		{name="Reset",type="Button",inherits="UIPanelButtonTemplate",
			point="TOPLEFT",x=5,y=-5,width=50, height=20, text = "Reset",
			func=self.Reset,
		},
		{name="Help",type="Button",inherits="UIPanelButtonTemplate",
			point="BOTTOMLEFT",x=5,y=5,width=100, height=20, text = L["Search Help"],
			func=self.HelpButton_Click,
		},
		{name="UpdateStone",type="Button",inherits="UIPanelButtonTemplate",
			point="BOTTOMRIGHT",x=-5,y=5,width=100, height=20, text = L["Battle Stone"],
			func=UpdateStoneButton_Click,
		},

		----value buttons
		----综合
		{name="Config",type="Text",
			point="TOPLEFT",x=25,y=-35,
		},

		{name="Message",type="CheckButton",var="ShowMsg",
			point="TOP",relative="Config",rpoint="BOTTOM",
			y=-7,
		},
		{name="OnlyInPetInfo",type="CheckButton",var="OnlyInPetInfo",
			point="LEFT",relative="Message",rpoint="RIGHT",
			x=130,
		},
		{name="MiniTip",type="CheckButton",var="MiniTip",
			point="LEFT",relative="OnlyInPetInfo",rpoint="RIGHT",
			x=130,
		},

		{name="Sound",type="CheckButton",var="Sound",
			point="TOP",relative="Message",rpoint="BOTTOM",
			y=-7,
		},

		{name="FastForfeit",type="CheckButton",var="FastForfeit",
			point="TOP",relative="Sound",rpoint="BOTTOM",
			y=-7,
		},
		{name="OtherTooltip",type="CheckButton",var="Tooltip",
			point="LEFT",relative="FastForfeit",rpoint="RIGHT",
			x=130,
		},
		{name="HighGlow",type="CheckButton",var="HighGlow",
			point="LEFT",relative="OtherTooltip",rpoint="RIGHT",
			x=130,
		},

		{name="AutoSaveAbility",type="CheckButton",var="AutoSaveAbility",
			point="TOP",relative="FastForfeit",rpoint="BOTTOM",
			y=-7,
		},
		{name="ShowBandageButton",type="CheckButton",var="ShowBandageButton",
			point="LEFT",relative="AutoSaveAbility",rpoint="RIGHT",
			x=130,
		},
		{name="ShowHideID",type="CheckButton",var="ShowHideID",
			point="LEFT",relative="ShowBandageButton",rpoint="RIGHT",
			x=130,
		},



		----成长值
		{name="GrowInfo",type="Text",
			point="TOP",relative="AutoSaveAbility",rpoint="BOTTOM",
			y=-7,
		},

		{name="PetGrowInfo",type="CheckButton",var="ShowGrowInfo",
			point="TOP",relative="GrowInfo",rpoint="BOTTOM",
			y=-7,
		},
		{name="BreedIDStyle",type="CheckButton",var="BreedIDStyle",
			point="LEFT",relative="PetGrowInfo",rpoint="RIGHT",
			x=130,func=function()HPetAllInfoFrame:Update()end
		},

		{name="PetGreedInfo",type="CheckButton",var="PetGreedInfo",
			point="TOP",relative="PetGrowInfo",rpoint="BOTTOM",
			y=-7,
		},
		{name="PetBreedInfo",type="CheckButton",var="PetBreedInfo",
			point="LEFT",relative="PetGreedInfo",rpoint="RIGHT",
			x=130,
		},
		{name="ShowBreedID",type="CheckButton",var="ShowBreedID",
			point="LEFT",relative="PetBreedInfo",rpoint="RIGHT",
			x=130,
		},

		----技能图标
		{name="AbilityIcon",type="Text",
			point="TOP",relative="PetGreedInfo",rpoint="BOTTOM",
			y=-7,
		},

		{name="EnemyAbility",type="CheckButton",var="EnemyAbility",
			point="TOP",relative="AbilityIcon",rpoint="BOTTOM",
			y=-7,func=HPetBattleAny.AllAbilityRef
		},
		{name="LockAbilitys",type="CheckButton",var="LockAbilitys",
			point="LEFT",relative="EnemyAbility",rpoint="RIGHT",
			x=130,
		},
		{name="ShowAbilitysName",type="CheckButton",var="ShowAbilitysName",
			point="LEFT",relative="LockAbilitys",rpoint="RIGHT",
			x=130,func=HPetBattleAny.AllAbilityRef,
		},


		{name="OtherAbility",type="CheckButton",var="OtherAbility",
			point="TOP",relative="EnemyAbility",rpoint="BOTTOM",
			y=-7,func=function(self)
					HPetBattleAny.AllAbilityRef()
					if self:GetChecked() then
						_G[self:GetParent():GetName().."AllyAbility"]:Enable()
					else
						_G[self:GetParent():GetName().."AllyAbility"]:Disable()
					end
				end
		},
		{name="AllyAbility",type="CheckButton",var="AllyAbility",
			point="LEFT",relative="OtherAbility",rpoint="RIGHT",
			x=130,func=HPetBattleAny.AllAbilityRef,loadfunc=function(self) if not HPetSaves.OtherAbility then self:Disable()end end
		},
--~ 		{name="AutoShowHide",type="CheckButton",var="AutoShowHide",
--~ 			point="LEFT",relative="AutoSaveAbility",rpoint="RIGHT",
--~ 			x=130,
--~ 		},

		-- Sliders
		{name="AbilitysScale",type="Slider",min=0.00,max=2.00,step=0.01,width=220,
			var = "AbScale",
			point="TOP",relative="EnemyAbility",rpoint="BOTTOM",
			x=200,y=-60,
			func = HPetOption.OnScaleChanged,
		},
		{name="ScaleBox",type="EditBox",width=32,height=20,var="Scale",
			func = HPetOption.ScaleBoxChanged,parent = "AbilitysScale",
			point="CENTER",relative="AbilitysScale",rpoint="BOTTOM",y=-15},


	}

	self:SetHeight(50*#self.Buttons/2)

	local button, text, name, value
	for key,value in pairs(self.Buttons) do
		-- pre settings
		if value.type == "CheckButton" then
			value.inherits = "OptionsCheckButtonTemplate"
		elseif value.type == "Slider" then
			value.inherits = "OptionsSliderTemplate"
		elseif value.type == "EditBox" then
			value.inherits = "InputBoxTemplate"
		elseif value.type == "Text" then
			value.inherits = "GameFontHighlight"
		end


		-- create frame
		if value.type~="Text" then
			local parent = self
			if value.parent then parent = _G[self:GetName()..value.parent] end
			button = CreateFrame(value.type,self:GetName()..value.name,parent,value.inherits)
			button:SetID(key)
			if value.parent then parent[value.type] = button end
		else
			button = self:CreateFontString(self:GetName()..value.name,"ARTWORK","GameFontHighlight")
			button:SetText(L[value.name])
		end

		if value.type == "CheckButton" then
			text = button:CreateFontString(button:GetName().."Text","OVERLAY","GameFontNormal")
			text:SetPoint("LEFT",button,"RIGHT",7,0)
			text:SetVertexColor(1,1,1)
			button:SetFontString(text)
		elseif value.type == "EditBox" then
			text = button:CreateFontString(button:GetName().."Text","OVERLAY","GameFontNormal")
			text:SetPoint("LEFT",button,"RIGHT",10,0)
			button.text = text
		end


		-- setup
		if value.width then
			button:SetWidth(value.width)
		end
		if value.height then
			button:SetHeight(value.height)
		end
		if value.point then
			if value.relative then
				value.relative = self:GetName()..value.relative
			end
			button:SetPoint(value.point, value.relative or HPetOption, value.rpoint or value.point, value.x or 0, value.y or 0)
		end
		if value.text then
			if button.text then
				button.text:SetText(value.text)
			else
				button:SetText(value.text)
			end
		end

		-- post settings
		if value.type == "Button" then
			if value.text then button:SetText(value.text) end
			if value.func then button:SetScript("OnClick",value.func) end
		elseif value.type == "CheckButton" then
			if not value.text then button:SetText(L[value.name]) end
			button:SetScript("OnClick", HPetOption.OnCheckButtonClicked)
			if value.func then
				button:HookScript("OnClick", value.func)
			end
		elseif value.type == "Slider" then
			button.text = _G["HPetOption"..value.name.."Text"]
			button.SetDisplayValue = button.SetValue;
			if value.text then
				button.title = value.text
			else
				button.title = L[value.name]
			end
			button.text:SetText(button.title)
			_G["HPetOption"..value.name.."Low"]:SetText(value.min)
			_G["HPetOption"..value.name.."High"]:SetText(value.max)
			button:SetMinMaxValues(value.min, value.max)
			button:SetValueStep(value.step)
			if value.func then button:SetScript("OnValueChanged", value.func) end
		elseif value.type == "EditBox" then
			button:SetAutoFocus(false)
			if not value.text then button.text:SetText(L[value.name]) end
			if value.func then
				button:SetScript("OnEnterPressed", value.func)
			else
				button:SetScript("OnEnterPressed", HPetOption.OnEditBoxEnterPressed)
			end
			button:SetScript("OnEscapePressed", button.ClearFocus)
		end
		if value.type == "CheckButton" and L[value.name.."Tooltip"] then
			button:SetScript("OnEnter", function(s)
				self:CheckButton_OnEnter(s,L[value.name],L[value.name.."Tooltip"])
			end)
		end
		if value.loadfunc then value.loadfunc(button) end
	end
end

function HPetOption:OnCheckButtonClicked()
	isChecked = self:GetChecked()
	if isChecked then
		-- PlaySound("igMainMenuOptionCheckBoxOn")
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	else
		-- PlaySound("igMainMenuOptionCheckBoxOff")
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
	end
	value = HPetOption.Buttons[self:GetID()]
	if value.var then
		if isChecked then
			HPetSaves[value.var] = true
		else
			HPetSaves[value.var] = false
		end
	end
	if value.var == "HighGlow" and PetBattleFrame:IsShown() then
		if isChecked then
			PetBattleFrame.ActiveEnemy.glow:Show()
			PetBattleFrame.ActiveAlly.glow:Show()
		else
			PetBattleFrame.ActiveEnemy.glow:Hide()
			PetBattleFrame.ActiveAlly.glow:Hide()
		end
	elseif value.var == "AutoSaveAbility" and PetJournal_UpdatePetCard then
		for i = 1, 6 do
			_G["PetJournalPetCardSpell"..i].icon:SetVertexColor(1,1,1,1)
		end
		PetJournal_UpdatePetCard(PetJournalPetCard)
	elseif value.var == "ShowBandageButton" and PetJournalBandageButton then
		if not UnitAffectingCombat("player") then
			if not HPetBattleAny.SwathButton then HPetBattleAny.initSwathButton() end
			if isChecked then
				PetJournalBandageButton:Show()
			else
				PetJournalBandageButton:Hide()
			end
		else
			HPetSaves[value.var] = not HPetSaves[value.var]
			self:SetChecked(HPetSaves[value.var])
		end
	else
		if PetJournal then
			if PetJournal and CollectionsJournal:IsShown() and PetJournal:IsShown() then
				PetJournal_UpdatePetCard(PetJournalPetCard)
			end
		end
	end
end


function HPetOption:OnScaleChanged(value)
	--local scale = self:GetValue()
	--if scale == 0 then scale = 0.01 end
	--HPetSaves.AbScale = scale
	--HPetBattleAny.AllAbilityRef()
	--self.text:SetText(self.title.." : "..math.floor(scale*100).."%")

	local scale = math.floor(value*100)/100
	self:SetDisplayValue(scale)
	if scale == 0 then scale = 0.01 end
	HPetSaves.AbScale = scale
	HPetBattleAny.AllAbilityRef()
	self.text:SetText(self.title.." : "..math.floor(scale*100).."%")
	self.EditBox:SetText(format("%.2f",scale))
end
function HPetOption:ScaleBoxChanged()
	local num = self:GetText()
	local parent = self:GetParent()
	if not num then return end
	num = tonumber(num)
	if not num then return end
	parent.var = num
	HPetBattleAny.AllAbilityRef()
	parent.text:SetText(parent.title.." : "..math.floor(num).."%")
	parent:SetValue(num)
	self:ClearFocus()
end

function HPetOption:CheckButton_OnEnter(button,name,message)
	GameTooltip:SetOwner(button,"ANCHOR_NONE");
	GameTooltip:SetPoint("BOTTOMLEFT",button,"TOPRIGHT")
	GameTooltip:AddLine(name);
	GameTooltip:AddLine(message,1,1,1);
	GameTooltip:Show()
end

function HPetOption:HelpButton_Click()
	HPetBattleAny:PetPrintEX(L["searchhelp1"],1,1,0)
	HPetBattleAny:PetPrintEX(L["searchhelp2"],1,1,0)
end
function UpdateStoneButton_Click()
--~ 	if not UpdateStoneButtons.ready then UpdateStoneButtons:Init() end
--~ 	if UpdateStoneButtons.ready then UpdateStoneButtons:Toggle() end
	if not BrotherBags then
		if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
			print(format("没有开启BrotherBags",1,0,1))
		else
			print(format("Not open BrotherBags",1,0,1))
		end
		return
	end

	local GetString = function(SearchId)
		local StringTable={}
		local Max = 0
		local GetItemLink=function(tid)
			local link = select(2,GetItemInfo(tid))
			return link
		end
		for realmName,realmTable in pairs(BrotherBags) do
			StringTable[realmName]={}
			for playerName,playerTable in pairs(realmTable) do
				local counts = 0
				for bagS,bagTable in pairs(playerTable) do
					if type(bagTable) == "table" then
						for _,idString in pairs(bagTable) do
							if type(idString)=="string" then
								local id, count = strsplit(';',idString)
								if tonumber(SearchId) == tonumber(id) then
									counts = counts + (count or 1)
								end
							end
						end
					end
				end
				if counts and counts ~= 0 then
					StringTable[realmName][playerName]=counts
					Max = Max + counts
				end
			end
		end
		local L_A,L_O
		if GetLocale() == "zhCN" then
				L_A,L_O = "共","个"
		elseif GetLocale() == "zhTW" then
				L_A,L_O = "共","個"
		else
				L_A,L_O = "total",""
		end
		if Max ~= 0 then
			local Tpstring = ""
			for rname,t in pairs(StringTable) do
				for pname,c in pairs(t) do
					if UnitName("player") == pname and GetRealmName() == rname then pname = "|cff00ffff"..pname.."|r"end
					if GetRealmName() == rname  then rname = "|cff00ffff"..rname.."|r" end
					Tpstring = Tpstring..(Tpstring~="" and "\n" or "")..pname.."@"..rname..":|cffff00ff"..c.."|r"..L_O
				end
			end
			print(GetItemLink(SearchId),L_A..":","|cffffff00"..Max.."|r",L_O.."\n"..Tpstring)
		end
	end
	local Stone={92665,92675,92676,92677,92678,
				92679,92680,92681,92682,92683,
				92741,
				90173,92797,92799,92800,
				92742,
				}
	print("↓-↓-↓-↓-↓-↓-↓-↓-↓-↓-↓-↓-↓-↓-↓")
	for _,id in ipairs(Stone) do
		GetString(id)
	end
	print("↑-↑-↑-↑-↑-↑-↑-↑-↑-↑-↑-↑-↑-↑-↑")
end
--[[
	read options
--]]
function HPetOption:LoadOptions()
	local button
	for key, value in ipairs(HPetOption.Buttons) do
		button = _G["HPetOption"..value.name]
		if value.type == "CheckButton" then
			if value.var then
				button:SetChecked(HPetSaves[value.var])
			end
		elseif value.type == "Slider" then
			button:SetValue(HPetSaves[value.var] or 0.8)
		elseif value.type == "EditBox" then
			button:SetText(HPetSaves[value.var] or "")
		end
	end
	-- for anchor
	local anchor = HPetSaves["Anchor"]
	local result = {false,false,false,false}
	if anchor then
		if anchor > 2 then
			anchor = anchor - 3
		else
			result[4] = true
		end
		result[anchor+1] = true
	end
end

function HPetOption:Reset()
	HPetSaves = HPetBattleAny.Default
	HPetSaves.PetAbilitys = {}
	HPetOption:LoadOptions()
end

function HPetOption:Open()
	self:Show()
	self:LoadOptions()
end

function HPetOption:Toggle()
	if HPetOption:IsShown() and InterfaceOptionsFrame.selectedTab == 2 and InterfaceOptionsFrame:IsShown() then
		InterfaceOptionsFrame_Show()
	else
		InterfaceOptionsFrame_Show()
		InterfaceOptionsFrame_OpenToCategory(HPetOption)
	end
end

----------new init
HPetOption:SetScript("OnShow", function(frame)
	frame:Init()

	frame:EnableMouse(false)
	frame:SetToplevel(false)
	frame:SetBackdrop(nil)
	HPetOptionClose:Hide()

	frame:SetScript("OnShow", function() frame:LoadOptions() end)
end)

local addonName,addon = ...
HPetOption.name = addonName
InterfaceOptions_AddCategory(HPetOption)



--------------------		SLASH
SLASH_HPETBATTLEANY1 = "/hpq"
SlashCmdList["HPETBATTLEANY"] = function(msg, editbox)
	local comm, rest = msg:match("^(%S*)%s*(.-)$")
	local command = string.lower(comm)
	if command =="" then
		HPetOption:Toggle()
	end
--~ 	这是搜索功能
	if command =="s" or command =="搜索" or command == "ss" then
		HPetBattleAny:Search(command,rest)
	elseif command =="cc" then
		HPetSaves.PetAbilitys={}
		DEFAULT_CHAT_FRAME:AddMessage(L["AutoSaveAbilityConfig"])
	elseif command =="cz" then
		local t={}
		for k,v in pairs(HPetSaves.PetAbilitys) do
			if not v or v=="000" or v=="123" or v==123 or v==0 then
			else
				t[k]=v
			end
		end

		HPetSaves.PetAbilitys=t
		DEFAULT_CHAT_FRAME:AddMessage(L["AutoSaveAbilityConfig"])
	elseif command == "n" then
		UpdateStoneButton_Click()
	elseif command =="snp" then
		HPetBattleAny.SearchNoPet()
	elseif command == "l" then
		HP_L(strsplit(", /",rest))
	elseif command == "glp" then
		HPetBattleAny.GetLimitPet(strsplit(", /",rest))
	elseif type(tonumber(command)) == "number" then
		HP_L(strsplit(", /",msg))
	end
end

local InitSwathButton = function()
	if UnitAffectingCombat("player") then return end
	local itemName = "宠物绷带"
	local icon = GetItemIcon(86143)
	local itemCount = GetItemCount(86143)
	local name = "PetJournalBandageButton"
	local button = CreateFrame("Button","PetJournalBandageButton",nil,"SecureActionButtonTemplate")
	button:SetParent(PetJournal)



	-------------init
	button:SetAttribute("unit", "player")
	button:SetAttribute("type", "macro")
	button:SetAttribute("macrotext","/use item:86143" )
	button:SetSize(35,35)

	button.Icon = button:CreateTexture(name.."Icon","ARTWORK")
	button.Icon:SetTexture(icon)
	button.Icon:SetAllPoints()

	button.Border = button:CreateTexture(name.."Border","OVERLAY","ActionBarFlyoutButton-IconFrame")
	button:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress")
	button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square","ADD")

	button.QuantityOwned = button:CreateFontString(nil,"OVERLAY","GameFontHighlight")
	button.QuantityOwned:SetText(itemCount)
	button.QuantityOwned:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-2,2)
	button.QuantityOwned:SetJustifyH("RIGHT")

	button:SetScript("OnEvent", function(self,event)
		local itemCount = GetItemCount(86143)
		self.QuantityOwned:SetText(itemCount)
		self.Icon:SetDesaturated(itemCount <= 0 )
	end)
	button:SetScript("OnShow", function(self)self:RegisterEvent("SPELL_UPDATE_COOLDOWN")end)
	button:SetScript("OnHide",function(self)self:UnregisterEvent("SPELL_UPDATE_COOLDOWN")end)
	button:SetScript("OnEnter", function(self)GameTooltip:SetOwner(self, "ANCHOR_RIGHT");GameTooltip:SetItemByID(86143)end)
	button:SetScript("OnLeave",function()GameTooltip:Hide()end)
	button:RegisterEvent("BAG_UPDATE")

	button:SetPoint("RIGHT",PetJournalHealPetButton,"LEFT",-4)

	hooksecurefunc(button,"Show",function()
		PetJournalHealPetButton.spellname:SetPoint("RIGHT",button,"LEFT")
	end)
	hooksecurefunc(button,"Hide",function()
		PetJournalHealPetButton.spellname:SetPoint("RIGHT",PetJournalHealPetButtonBorder,"LEFT",-2,0)
	end)

	if HPetSaves.ShowBandageButton then
		button:Show()
	else
		button:Hide()
	end

	HPetBattleAny.SwathButton=button
	InitSwathButton=nil
end

HPetBattleAny.initSwathButton=function()
	if UnitAffectingCombat("player") then
		hooksecurefunc(PetJournal,"Show",InitSwathButton)
	else
		InitSwathButton()
	end
end

---------filter还原,来源lib
do
	local fit={}
    local PJ_FLAG_FILTERS = {
        [LE_PET_JOURNAL_FILTER_COLLECTED] = true,
        [LE_PET_JOURNAL_FILTER_NOT_COLLECTED] = true
    }

    local s_search_filter
    local flag_filters = {}
    local type_filters = {}
    local source_filters = {}

    fit._filter_hooks = fit._filter_hooks or {}

    local last_search_filter
    if not fit._filter_hooks.SetSearchFilter then
        hooksecurefunc(C_PetJournal, "SetSearchFilter", function(...)
             fit._filter_hooks.SetSearchFilter(...)
        end)
    end
    fit._filter_hooks.SetSearchFilter = function(str)
        last_search_filter = str
    end

    if not fit._filter_hooks.ClearSearchFilter then
        hooksecurefunc(C_PetJournal, "ClearSearchFilter", function(...)
             fit._filter_hooks.ClearSearchFilter(...)
        end)
    end
    fit._filter_hooks.ClearSearchFilter = function()
        last_search_filter = ""
    end

    function fit.ClearFilters()
        if (fit._filters_cleared) then return end
        fit._filters_cleared = true

        if _G.PetJournal then
            _G.PetJournal:UnregisterEvent("PET_JOURNAL_LIST_UPDATE")
        end
        HPetBattleAny:UnregisterEvent("PET_JOURNAL_LIST_UPDATE")

        for flag, value in pairs(PJ_FLAG_FILTERS) do
            flag_filters[flag] = C_PetJournal.IsFilterChecked(flag)
            if flag_filters[flag] ~= value then
                C_PetJournal.SetFilterChecked(flag, value)
            end
        end
		
        local need_add_all = false
        local ntypes = C_PetJournal.GetNumPetTypes()
        for i=1,ntypes do
            type_filters[i] = C_PetJournal.IsPetTypeChecked(i)
            if not type_filters[i] then
                need_add_all = true
            end
        end
		
        if need_add_all then
            C_PetJournal.SetAllPetTypesChecked(true);
        end

        need_add_all = false
        local nsources = C_PetJournal.GetNumPetSources()
        for i=0,nsources do
            source_filters[i] = C_PetJournal.IsPetSourceChecked(i)
            if not source_filters[i] then
                need_add_all = true
            end
        end
        if need_add_all then
            C_PetJournal.SetAllPetSourcesChecked(true)
        end

        if last_search_filter == nil then
            last_search_filter = ""
            C_PetJournal.ClearSearchFilter()
        elseif last_search_filter ~= "" then
            s_search_filter = last_search_filter
            C_PetJournal.ClearSearchFilter()
        else
            s_search_filter = nil
        end
    end

    function fit.RestoreFilters()
        if (not fit._filters_cleared) then return end
        fit._filters_cleared = false

        if s_search_filter and s_search_filter ~= "" then
            C_PetJournal.SetSearchFilter(s_search_filter)
        end

        for flag, value in pairs(flag_filters) do
            if value ~= PJ_FLAG_FILTERS[flag] then
                C_PetJournal.SetFilterChecked(flag, value)
            end
        end

        for flag,value in pairs(type_filters) do
            if value ~= true then
                C_PetJournal.SetPetTypeFilter(flag, value)
            end
        end

        for flag,value in pairs(source_filters) do
            if value ~= true then
                C_PetJournal.SetPetSourceChecked(flag, value)
            end
        end

        if _G.PetJournal then
            _G.PetJournal:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
			-- PetJournal_UpdatePetList()
        end
        HPetBattleAny:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
    end
	HPetBattleAny.hookfilter = fit
end
