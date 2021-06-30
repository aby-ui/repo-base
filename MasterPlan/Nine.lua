if select(4, GetBuildInfo()) < 9e4 then return end

local Nine, _, T = {}, ...
T.Nine = Nine

function Nine.GetCurrencyInfo(id)
	local t = C_CurrencyInfo.GetCurrencyInfo(id)
	return t.name, t.quantity, t.iconFileID, nil, nil, t.maxQuantity, t.discovered, t.quality
end
function Nine.GetCurrencyLink(...)
	return C_CurrencyInfo.GetCurrencyLink(...)
end
function Nine.GetCurrencyListLink(...)
	return C_CurrencyInfo.GetCurrencyListLink(...)
end

Nine.C_Garrison = setmetatable({}, {__index=C_Garrison})

function Nine.C_Garrison.GetMissionInfo(mid)
	local mt = C_Garrison.GetMissionDeploymentInfo(mid)
	return mt.location, mt.xp, mt.environment, mt.environmentDesc, mt.environmentTexture, mt.locTextureKit, mt.isExhausting, mt.enemies
end

function Nine.IsQuestFlaggedCompleted(qid)
	return C_QuestLog.IsQuestFlaggedCompleted(qid)
end