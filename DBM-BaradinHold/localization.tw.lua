if GetLocale() ~= "zhTW" then return end

local L

----------------
--  Argaloth  --
----------------
L= DBM:GetModLocalization(139)

-----------------
--  Occu'thar  --
-----------------
L= DBM:GetModLocalization(140)

----------------------------------
--  Alizabal, Mistress of Hate  --
----------------------------------
L= DBM:GetModLocalization(339)

L:SetTimerLocalization({
	TimerFirstSpecial		= "特別技能"
})

L:SetOptionLocalization({
	TimerFirstSpecial		= "為下一次的特別技能$spell:105738顯示計時器<br/>(特別技能是隨機性的。技能為$spell:105067或$spell:104936)"
})
