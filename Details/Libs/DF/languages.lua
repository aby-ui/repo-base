


local DF = _G ["DetailsFramework"]
if (not DF or not DetailsFrameworkCanLoad) then
	return
end

--create namespace
DF.Language = {
    registeredLanguages = {},
}

function DF.Language.GetWordsFromLanguage(self, language, addonGlobalName)

end

function DF.Language.RegisterLanguage(self, addonGlobalName, language)
    local addonObject = _G[addonGlobalName]
    addonObject.__language = addonObject.__language or {}
    addonObject.__language[language] = {}
    return addonObject.__language[language]
end
