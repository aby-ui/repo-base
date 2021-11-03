local GlobalAddonName, ExRT = ...

local ELib,L = ExRT.lib,ExRT.L

if ExRT.isClassic then return end

local sf

local function SF_Show()
	if not sf then
		sf = CreateFrame("ScrollFrame", nil, UIParent)
		sf:SetPoint("CENTER")
		sf:SetSize(500,500)
		sf:Hide()
		sf:SetFrameStrata("DIALOG")
		
		sf.back = sf:CreateTexture(nil,"BACKGROUND")
		sf.back:SetAtlas("UI-Frame-Venthyr-CardParchmentWider")
		sf.back:SetSize(570,570)
		sf.back:SetPoint("CENTER",0,0)
		
		sf.close = CreateFrame("Button",nil,sf,"UIPanelCloseButton")
		sf.close:SetPoint("TOPRIGHT",25,25)
		
		sf.C = CreateFrame("Frame", nil, sf) 
		sf:SetScrollChild(sf.C)
		sf.C:SetSize(500,500)
		
		for i=1,4 do
			local f = CreateFrame("Frame",nil,sf.C)
			sf.C[i] = f
			f:SetPoint("CENTER")
			f:SetSize(1,1)
			
			f.img = f:CreateTexture(nil,"BACKGROUND")
			f.img:SetSize(350,350)
			
			local group = f:CreateAnimationGroup()
			group:SetScript('OnFinished', function() group:Play() end)
			local rotation = group:CreateAnimation('Rotation')
			rotation:SetDuration(0.000001)
			rotation:SetEndDelay(2147483647)
			rotation:SetOrigin('TOPLEFT', 0, 0)
			rotation:SetDegrees(0)
			group:Play()
		
			f.r = rotation
		end
		
		sf.C[1].img:SetPoint("BOTTOMLEFT",0,0)
		sf.C[1].img:SetAtlas("UI-Frame-KyrianChoice-ScrollingBG")
		sf.C[1].r:SetOrigin('BOTTOMLEFT', 0, 0)
		
		sf.C[2].img:SetPoint("TOPLEFT",0,0)
		sf.C[2].img:SetAtlas("UI-Frame-NecrolordsChoice-ScrollingBG")
		sf.C[2].r:SetOrigin('TOPLEFT', 0, 0)
		
		sf.C[3].img:SetPoint("TOPRIGHT",0,0)
		sf.C[3].img:SetAtlas("UI-Frame-NightFaeChoice-ScrollingBG")
		sf.C[3].r:SetOrigin('TOPRIGHT', 0, 0)
		
		sf.C[4].img:SetPoint("BOTTOMRIGHT",0,0)
		sf.C[4].img:SetAtlas("UI-Frame-VenthyrChoice-ScrollingBG")
		sf.C[4].r:SetOrigin('BOTTOMRIGHT', 0, 0)
		
		
		sf.arrowf = CreateFrame("Frame",nil,sf)
		sf.arrowf:SetAllPoints()
		
		sf.arrow = sf.arrowf:CreateTexture()
		sf.arrow:SetAtlas("NPE_ArrowDown",true)
		sf.arrow:SetPoint("TOP",0,28)
		
		sf.result = CreateFrame("Frame",nil,sf)
		sf.result:SetAllPoints()
		
		sf.result_icon = sf.result:CreateTexture()
		sf.result_icon:SetSize(500,232)
		sf.result_icon:SetPoint("CENTER",0,0)
		
		local f2 = CreateFrame("Frame")
		
		local t = 0
		
		f2.anim = f2:CreateAnimationGroup()
		f2.anim:SetLooping("NONE")
		f2.anim.timer = f2.anim:CreateAnimation()
		f2.anim.timer:SetDuration(7)
		f2.anim.timer:SetSmoothing("OUT")
		f2.anim.timer:SetScript("OnUpdate", function(self,elapsed) 
			local p = self:GetSmoothProgress()
			for i=1,4 do
				sf.C[i].r:SetDegrees(t*p)
			end
		end)
		
		local f3 = CreateFrame("Frame")
		f3.anim = f3:CreateAnimationGroup()
		f3.anim.timer = f3.anim:CreateAnimation()
		f3.anim.timer:SetDuration(.5)
		f3.anim.timer:SetSmoothing("IN")
		f3.anim.timer:SetScript("OnUpdate", function(self,elapsed) 
			local p = self:GetSmoothProgress()
			sf.result_icon:SetScale(2-p)
		end)
		
		f2.anim:SetScript('OnFinished', function() 
			local covenantID = floor((t%360)/90)
			sf.result_icon:SetTexCoord(0,1,0,1)
			if covenantID == 0 then
				sf.result_icon:SetAtlas("adventures-endcombat-kyrian")
			elseif covenantID == 1 then
				sf.result_icon:SetAtlas("adventures-endcombat-necrolord")
			elseif covenantID == 2 then
				sf.result_icon:SetTexture(3463360)
				sf.result_icon:SetTexCoord(1/1024,501/1024,338/2048,570/2048)
			elseif covenantID == 3 then
				sf.result_icon:SetAtlas("adventures-endcombat-venthyr")
			end
			f3.anim:Play()
			sf.result_icon:Show()
		end)
		
		sf:SetScript("OnMouseUp",function()
			if f3.anim:IsPlaying() then
				return
			end
			if f2.anim:IsPlaying() then
				t = t + math.random(1000,3000)
				return
			end
			local prev = t % 360
			t = math.random(2000,5000)
			f2.anim:Play()
			sf.result_icon:Hide()
		end)
		
		sf:SetScript("OnShow",function(self)
			self:GetScript("OnMouseUp")(self)
		end)
	end

	sf:Show()
end

local helpButton
local helpButtonClick = function()
	PlayerChoiceFrame:Hide()
	SF_Show()
end

local C_PlayerChoice_GetPlayerChoiceInfo = C_PlayerChoice.GetPlayerChoiceInfo or function()
	local choiceInfo = C_PlayerChoice.GetCurrentPlayerChoiceInfo()

	if choiceInfo then
		choiceInfo.numOptions = 0

		for _, optionInfo in ipairs(choiceInfo.options) do
			choiceInfo.numOptions = choiceInfo.numOptions + #optionInfo.buttons
		end
	end

	return choiceInfo
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:RegisterEvent("PLAYER_CHOICE_UPDATE")
loader:SetScript("OnEvent",function(self,event,arg)
	if event == "ADDON_LOADED" then
		if arg == "Blizzard_PlayerChoice" then
			helpButton = CreateFrame("Button",nil,PlayerChoiceFrame,"UIPanelButtonTemplate")
			helpButton:SetPoint("BOTTOM",PlayerChoiceFrame,"TOP",0,4)
			helpButton:SetText("MRT: "..L.OtherCovHelper)
			helpButton:SetSize(200,30)
			helpButton:SetScale(1.3)
			helpButton:SetScript("OnClick",helpButtonClick)
		end
	elseif event == "PLAYER_CHOICE_UPDATE" then
		if not helpButton then
			return
		end
		local choiceInfo = C_PlayerChoice_GetPlayerChoiceInfo()
		if choiceInfo and choiceInfo.choiceID == 644 then
			helpButton:Show()
		else
			helpButton:Hide()
		end
	end
end)


SlashCmdList["covhelpSlash"] = function (arg)
	SF_Show()
end
SLASH_covhelpSlash1 = "/covenanthelper"