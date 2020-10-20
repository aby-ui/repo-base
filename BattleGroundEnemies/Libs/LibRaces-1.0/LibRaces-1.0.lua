--- LibRaces-1.0 provides several functions around playable races in world of warcraft
-- @class file
-- @name LibRaces-1.0

local MAJOR, MINOR = "LibRaces-1.0", 9
local LibRaces = LibStub:NewLibrary(MAJOR, MINOR)

if not LibRaces then return end

local languageCodes = {en="enUS",de="deDE",es="esES",mx="esMX",fr="frFR",it="itIT",ko="koKR",pt="ptPT",br="ptBR",ru="ruRU",cn="zhCN",tw="zhTW"};
local genderEngStr = {[0]="NEUTRAL",[1]="MALE",[2]="FEMALE"};

-- races[<localeLowerCasedStripped>] = <table of localized race names (ref. from data)>
local races = {};

-- toEnglish[<localeLowerCasedStripped>] = { <englishStripped>, <englishCaseSens> }
local toEnglish = {};

-- gender[<localeLowerCasedStripped>] = <number[0, 1, 2]> -- 0=neutral, 1=male, 2=female
local gender = {};

-- languages[<localeLowerCasedStripped>] = { "<langCode>", <langCode>=true }
local language = {};

-- data[<engLowerStripped>] = { <langCode> = { <langCode> = { <male>[, <female>] } } }
local data = {
	human = {deDE={"Mensch"},enUS={"Human"},esES={"Humano","Humana"},esMX={"Humano","Humana"},frFR={"Humain","Humaine"},itIT={"Umano","Umana"},koKR={"인간","인간"},ptBR={"Humano","Humana"},ptPT={"Humano","Humana"},ruRU={"Человек","Человек"},zhCN={"人类","人类"},zhTW={"人類","人類"}},
	orc = {deDE={"Orc"},enUS={"Orc"},esES={"Orco"},esMX={"Orco","Orco"},frFR={"Orc","Orque"},itIT={"Orco","Orchessa"},koKR={"오크","오크"},ptBR={"Orc","Orquisa"},ptPT={"Orc","Orquisa"},ruRU={"Орк","Орчиха"},zhCN={"兽人","兽人"},zhTW={"獸人","獸人"}},
	dwarf = {deDE={"Zwerg","Zwergin"},enUS={"Dwarf"},esES={"Enano","Enana"},esMX={"Enano","Enana"},frFR={"Nain","Naine"},itIT={"Nano","Nana"},koKR={"드워프","드워프"},ptBR={"Anão","Anã"},ptPT={"Anão","Anã"},ruRU={"Дворф","Дворфийка"},zhCN={"矮人","矮人"},zhTW={"矮人","矮人"}},
	nightelf = {deDE={"Nachtelf","Nachtelfe"},enUS={"Night Elf"},esES={"Elfo de la noche","Elfa de la noche"},esMX={"Elfo de la noche","Elfa de la noche"},frFR={"Elfe de la nuit","Elfe de la nuit"},itIT={"Elfo della Notte","Elfa della Notte"},koKR={"나이트 엘프","나이트 엘프"},ptBR={"Elfo Noturno","Elfa Noturna"},ptPT={"Elfo Noturno","Elfa Noturna"},ruRU={"Ночной эльф","Ночная эльфийка"},zhCN={"暗夜精灵","暗夜精灵"},zhTW={"夜精靈","夜精靈"}},
	scourge = {deDE={"Untoter","Untote"},enUS={"Undead"},esES={"No-muerto","No-muerta"},esMX={"No-muerto","No-muerta"},frFR={"Mort-vivant","Morte-vivante"},itIT={"Non Morto","Non Morta"},koKR={"언데드","언데드"},ptBR={"Morto-vivo","Morta-viva"},ptPT={"Morto-vivo","Morta-viva"},ruRU={"Нежить"},zhCN={"亡灵","亡灵"},zhTW={"不死族","不死族"}},
	tauren = {deDE={"Tauren"},enUS={"Tauren"},esES={"Tauren"},esMX={"Tauren","Tauren"},frFR={"Tauren","Taurène"},itIT={"Tauren","Tauren"},koKR={"타우렌","타우렌"},ptBR={"Tauren","Taurena"},ptPT={"Tauren","Taurena"},ruRU={"Таурен","Тауренка"},zhCN={"牛头人","牛头人"},zhTW={"牛頭人","牛頭人"}},
	gnome = {deDE={"Gnom"},enUS={"Gnome"},esES={"Gnomo","Gnoma"},esMX={"Gnomo","Gnoma"},frFR={"Gnome","Gnome"},itIT={"Gnomo","Gnoma"},koKR={"노움","노움"},ptBR={"Gnomo","Gnomida"},ptPT={"Gnomo","Gnomida"},ruRU={"Гном","Гномка"},zhCN={"侏儒","侏儒"},zhTW={"地精","地精"}},
	troll = {deDE={"Troll"},enUS={"Troll"},esES={"Trol"},esMX={"Trol","Trol"},frFR={"Troll","Trollesse"},itIT={"Troll","Troll"},koKR={"트롤","트롤"},ptBR={"Troll","Trolesa"},ptPT={"Troll","Trolesa"},ruRU={"Тролль"},zhCN={"巨魔","巨魔"},zhTW={"食人妖","食人妖"}},
	goblin = {deDE={"Goblin"},enUS={"Goblin"},esES={"Goblin"},esMX={"Goblin","Goblin"},frFR={"Gobelin","Gobeline"},itIT={"Goblin","Goblin"},koKR={"고블린","고블린"},ptBR={"Goblin","Goblina"},ptPT={"Goblin","Goblina"},ruRU={"Гоблин"},zhCN={"地精","地精"},zhTW={"哥布林","哥布林"}},
	bloodelf = {deDE={"Blutelf","Blutelfe"},enUS={"Blood Elf"},esES={"Elfo de sangre","Elfa de sangre"},esMX={"Elfo de sangre","Elfa de sangre"},frFR={"Elfe de sang","Elfe de sang"},itIT={"Elfo del Sangue","Elfa del Sangue"},koKR={"블러드 엘프","블러드 엘프"},ptBR={"Elfo Sangrento","Elfa Sangrenta"},ptPT={"Elfo Sangrento","Elfa Sangrenta"},ruRU={"Эльф крови","Эльфийка крови"},zhCN={"血精灵","血精灵"},zhTW={"血精靈","血精靈"}},
	draenei = {deDE={"Draenei","Draenei"},enUS={"Draenei"},esES={"Draenei"},esMX={"Draenei","Draenei"},frFR={"Draeneï","Draeneï"},itIT={"Draenei","Draenei"},koKR={"드레나이","드레나이"},ptBR={"Draenei","Draenaia"},ptPT={"Draenei","Draenaia"},ruRU={"Дреней","Дренейка"},zhCN={"德莱尼","德莱尼"},zhTW={"德萊尼","德萊尼"}},
	worgen = {deDE={"Worgen"},enUS={"Worgen"},esES={"Huargen"},esMX={"Huargen","Huargen"},frFR={"Worgen","Worgen"},itIT={"Worgen","Worgen"},koKR={"늑대인간","늑대인간"},ptBR={"Worgen","Worgenin"},ptPT={"Worgen","Worgenin"},ruRU={"Ворген"},zhCN={"狼人","狼人"},zhTW={"狼人","狼人"}},
	pandaren = {deDE={"Pandaren"},enUS={"Pandaren"},esES={"Pandaren"},esMX={"Pandaren","Pandaren"},frFR={"Pandaren","Pandarène"},itIT={"Pandaren","Pandaren"},koKR={"판다렌","판다렌"},ptBR={"Pandaren","Pandarena"},ptPT={"Pandaren","Pandarena"},ruRU={"Пандарен","Пандаренка"},zhCN={"熊猫人","熊猫人"},zhTW={"熊貓人","熊貓人"}},
	nightborne = {deDE={"Nachtgeborener","Nachtgeborene"},enUS={"Nightborne"},esES={"Nocheterna"},esMX={"Natonocturno","Natonocturna"},frFR={"Sacrenuit","Sacrenuit"},itIT={"Nobile Oscuro","Nobile Oscura"},koKR={"나이트본","나이트본"},ptBR={"Filho da Noite","Filha da Noite"},ptPT={"Filho da Noite","Filha da Noite"},ruRU={"Ночнорожденный","Ночнорожденная"},zhCN={"夜之子","夜之子"},zhTW={"夜裔精靈","夜裔精靈"}},
	highmountaintauren = {deDE={"Hochbergtauren"},enUS={"Highmountain Tauren"},esES={"Tauren Monte Alto"},esMX={"Tauren de Altamontaña","Tauren de Altamontaña"},frFR={"Tauren de Haut-Roc","Taurène de Haut-Roc"},itIT={"Tauren di Alto Monte","Tauren di Alto Monte"},koKR={"높은산 타우렌","높은산 타우렌"},ptBR={"Tauren Altamontês","Taurena Altamontesa"},ptPT={"Tauren Altamontês","Taurena Altamontesa"},ruRU={"Таурен Крутогорья","Тауренка Крутогорья"},zhCN={"至高岭牛头人","至高岭牛头人"},zhTW={"高嶺牛頭人","高嶺牛頭人"}},
	voidelf = {deDE={"Leerenelf","Leerenelfe"},enUS={"Void Elf"},esES={"Elfo del Vacío","Elfa del Vacío"},esMX={"Elfo del Vacío","Elfa del Vacío"},frFR={"Elfe du Vide","Elfe du Vide"},itIT={"Elfo del Vuoto","Elfa del Vuoto"},koKR={"공허 엘프","공허 엘프"},ptBR={"Elfo Caótico","Elfa Caótica"},ptPT={"Elfo Caótico","Elfa Caótica"},ruRU={"Эльф Бездны","Эльфийка Бездны"},zhCN={"虚空精灵","虚空精灵"},zhTW={"虛無精靈","虛無精靈"}},
	lightforgeddraenei = {deDE={"Lichtgeschmiedeter Draenei","Lichtgeschmiedete Draenei"},enUS={"Lightforged Draenei"},esES={"Draenei forjado por la Luz","Draenei forjada por la Luz"},esMX={"Draenei templeluz","Draenei templeluz"},frFR={"Draeneï sancteforge","Draeneï sancteforge"},itIT={"Draenei Forgialuce","Draenei Forgialuce"},koKR={"빛벼림 드레나이","빛벼림 드레나이"},ptBR={"Draenei Forjado a Luz","Draenaia Forjada a Luz"},ptPT={"Draenei Forjado a Luz","Draenaia Forjada a Luz"},ruRU={"Озаренный дреней","Озаренная дренейка"},zhCN={"光铸德莱尼","光铸德莱尼"},zhTW={"光鑄德萊尼","光鑄德萊尼"}},
	zandalaritroll = {deDE={"Zandalaritroll"},enUS={"Zandalari Troll"},esES={"Trol Zandalari","Trols Zandalari"},esMX={"Trol zandalari","Trol zandalari"},frFR={"Troll zandalari","Trolle zandalari"},itIT={"Troll Zandalari","Troll Zandalari"},koKR={"잔달라 트롤","잔달라 트롤"},ptBR={"Troll Zandalari","Trolesa Zandalari"},ptPT={"Troll Zandalari","Trolesa Zandalari"},ruRU={"Зандалар","Зандаларка"},zhCN={"赞达拉巨魔","赞达拉巨魔"},zhTW={"贊達拉食人妖","贊達拉食人妖"}},
	kultiran = {deDE={"Kul Tiraner","Kul Tiranerin"},enUS={"Kul Tiran"},esES={"Ciudadano de Kul Tiras","Ciudadana de Kul Tiras"},esMX={"Kultirano","Kultirana"},frFR={"Kultirassien","Kultirassienne"},itIT={"Kul Tirano","Kul Tirana"},koKR={"쿨 티란","쿨 티란"},ptBR={"Kultireno","Kultirena"},ptPT={"Kultireno","Kultirena"},ruRU={"Култирасец","Култираска"},zhCN={"库尔提拉斯人","库尔提拉斯人"},zhTW={"庫爾提拉斯人","庫爾提拉斯人"}},
	darkirondwarf = {deDE={"Dunkeleisenzwerg","Dunkeleisenzwergin"},enUS={"Dark Iron Dwarf"},esES={"Enano Hierro Negro","Enana Hierro Negro"},esMX={"Enano Hierro Negro","Enana Hierro Negro"},frFR={"Nain sombrefer","Naine sombrefer"},itIT={"Nano Ferroscuro","Nana Ferroscuro"},koKR={"검은무쇠 드워프","검은무쇠 드워프"},ptBR={"Anão Ferro Negro","Anã Ferro Negro"},ptPT={"Anão Ferro Negro","Anã Ferro Negro"},ruRU={"Дворф из клана Черного Железа","Дворфийка из клана Черного Железа"},zhCN={"黑铁矮人","黑铁矮人"},zhTW={"黑鐵矮人","黑鐵矮人"}},
	vulpera = {deDE={"Vulpera"},enUS={"Vulpera"},esES={"Vulpera"},esMX={"Vulpera"},frFR={"Vulpérin"},itIT={"Vulpera"},koKR={"불페라"},ptBR={"Vulpera"},ptPT={"Vulpera"},ruRU={"Вульпера"},zhCN={"狐人"},zhTW={"狐狸人"}},
	magharorc = {deDE={"Mag'har","Mag'har"},enUS={"Mag'har Orc"},esES={"Orco Mag'har","Orco Mag'har"},esMX={"Orco mag'har","Orco mag'har"},frFR={"Orc mag’har","Orque mag’har"},itIT={"Orco Mag'har","Orchessa Mag'har"},koKR={"마그하르 오크","마그하르 오크"},ptBR={"Orc Mag'har","Orc Mag'har"},ptPT={"Orc Mag'har","Orc Mag'har"},ruRU={"Маг'хар","Маг'харка"},zhCN={"玛格汉兽人","玛格汉兽人"},zhTW={"瑪格哈獸人","瑪格哈獸人"}},
	mechagnome = {deDE={"Mechagnom"},enUS={"Mechagnome"},esES={"Mecagnomo","Mecagnomo"},esMX={"Mecagnomo","Mecagnoma"},frFR={"Mécagnome","Mécagnome"},itIT={"Meccagnomo","Meccagnomo"},koKR={"기계노움","기계노움"},ptBR={"Gnomecânico","Gnomecânico"},ptPT={"Gnomecânico","Gnomecânico"},ruRU={"Механогном","Механогномка"},zhCN={"机械侏儒","机械侏儒"},zhTW={"機械地精","機械地精"}},
};

local function GetLanguageCode(lang)
	if type(lang)=="string" then
		local length = strlen(lang);
		if lang=="gb" or lang=="enGB" then
			return "enUS";
		end
		if length==4 then
			local lang_12 = strsub(lang,0,2):lower();
			local lang_34 = strsub(lang,3,4):lower();
			if languageCodes[lang_34] then
				return languageCodes[lang_34];
			elseif languageCodes[lang_12] then
				return languageCodes[lang_12];
			end
		elseif length==2 then
			local lang = lang:lower();
			if languageCodes[lang] then
				return languageCodes[lang];
			end
		end
	end
	return GetLocale(); -- fallback to client language
end

local function strip(str,normalize)
	assert(type(str)=="string");
	return (normalize==true and str:lower() or str):gsub(" ",""):gsub("%-",""):gsub("'","");
end

local function Unpack(step,...)
	if step==3 then -- step3
		local name, engLower, engCaseSens, lang = ...;

		-- fill toEnglish table
		toEnglish[name] = {strip(engCaseSens),engCaseSens};

		-- fill races table
		races[name] = data[engLower];

		-- file language table
		if language[name]==nil then
			language[name] = {};
		end
		if not language[name][lang] then
			tinsert(language[name],lang);
			language[name][lang] = true;
		end
	elseif step==2 then -- step2
		local engLower,engCaseSens,lang,localized = ...;

		-- lowercase and stripped like realm names on character names
		local localeFemaleStripped = strip(localized[2] or localized[1],true);
		local localeMaleStripped   = strip(localized[1],true);

		-- is locale name gender neutral
		local isNeutral = localeMaleStripped==localeFemaleStripped;

		-- fill gender table
		if isNeutral then
			gender[localeMaleStripped] = 0;
		else
			gender[localeFemaleStripped] = 2;
			gender[localeMaleStripped] = 1;
		end

		Unpack(3,localeFemaleStripped, engLower, engCaseSens, lang);
		if not isNeutral then
			Unpack(3,localeMaleStripped, engLower, engCaseSens, lang);
		end
	else -- step1
		for engLower, localizations in pairs(data) do
			local engCaseSens = localizations.enUS[1];
			-- english first
			Unpack(2,engLower,engCaseSens,"enUS",localizations.enUS); -- exec Unpack step2
			for lang, localized in pairs(localizations)do
				if lang~="enUS" then
					-- number, string, string, string, string
					Unpack(2,engLower,engCaseSens,lang,localized); -- exec Unpack step2
				end
			end
		end
		Unpack = nil;
	end
end

--[[
Notes:
	* returns nil if no match found
Arguments:
	raceName -
Returns:
	englishToken - english version without spacer like realm name behind character names
Example:
	"NightElf", "Night Elf" = LibRaces:GetRaceToken("Elfe de la nuit")
	/dump LibStub("LibRaces-1.0"):GetRaceToken("Elfe de la nuit")
--]]

--- Returns english race token and name from any client supported language
-- @param name Race name (all client supported languages)
-- @return English tokenized race name (without dashes and whitespaces)
-- @return English race name
function LibRaces:GetRaceToken(name)
	if self~=LibRaces then name=self; end
	if Unpack then Unpack(); end
	local name = strip(name,true);
	if toEnglish[name] then
		return unpack(toEnglish[name]);
	end
end

--[[
Notes:
	* if lang nil or not match with client supported language codes then it fall back to current client language
	* returns nil if no match found
Arguments:
	raceName - race name (all client supported languages)
	languageCode - deDE, enGB, enUS, esES, esMX, frFR, itIT, koKR, ptBR, ptPT, ruRU, zhCN, zhTW or de, en, es, mx, fr, it, ko, pt, br, ru, cn, tw
	genderIndex - 0=Neutral, 1=Male, 2=Female
Returns (without 3. argument):
	raceNameMale - male race name in choosen language
	raceNameFemale - female race name in choosen language
Returns (with 3. argument):
	raceName - neutral, male or female race name in choosen language
Examples:
	"Orco", "Orchessa" = LibRaces:GetRaceName("Orc","itIT") -- Orc [english to italian]
	"Elfa Sangrenta" = LibRaces:GetRaceName("Эльф крови","ptPT",2) -- Blood Elf [Russian to female portuguese]
	/dump LibStub("LibRaces-1.0"):GetRaceName("Orc","itIT")
	/dump LibStub("LibRaces-1.0"):GetRaceName("Эльф крови","ptPT",2)
--]]

--- Returns name of race by selected language and gender or both gender names of race by choosen language
-- @paramsig name[, language[, gender]]
-- @param name Name of playable race (all client supported languages)
-- @param language The language code like enUS, ptBR or shorter like de, tw or cn (optional)
-- @param gender Choose gender 1=male, 2=female (optional)
-- @return Male and female name of race or name of race by selected gender
function LibRaces:GetRaceName(raceName, lang, gender)
	if self~=LibRaces then raceName,lang,gender=self,raceName,lang; end
	assert(type(raceName)=="string","<LibRaces-1.0>:GetRaceName(<raceName(string)>[,<languageCode(string)>[,<gender(number 1=male|2=female)>]])");
	lang = GetLanguageCode(lang);
	if Unpack then Unpack(); end
	local race = races[strip(raceName,true)];
	if race and race[lang] then
		if gender==1 or gender==2 then
			return race[lang][gender];
		end
		return unpack(race[lang]); -- return male, female
	end
	-- nil on fail
end

--[[
Notes:
	* returns nil if no match found
Arguments:
	raceName - race name (all client supported languages)
Returns:
	languageCodeN - a list of language code matching with given race name
Example:
	"deDE","enGB","enUS","frFR","itIT","ptBT","ptPT" = LibRaces:GetLanguageByRaceName("Troll")
	/dump LibStub("LibRaces-1.0"):GetLanguageByRaceName("Troll")
--]]
---
-- @param name
-- @return
function LibRaces:GetLanguageByRaceName(name)
	if self~=LibRaces then name = self; end
	assert(type(name)=="string");
	if Unpack then Unpack(); end
	local lang = {};
	for _,v in ipairs(language[strip(name,true)] or {})do
		tinsert(lang, v);
	end
	if #lang>0 then
		table.sort(lang);
		return unpack(lang);
	end
end

--[[
Notes:
	* returns nil if no match found
Arguments:
	raceName - race name (all client supported languages)
Returns:
	genderIndex - 0=Neutral, 1=Male, 2=Female
	genderName - english gender name (uppercase)
Example:
	2, "FEMALE" = LibRaces:GetGenderByRaceName("Nachtelfe") -- german female night elf
	/dump LibStub("LibRaces-1.0"):GetGenderByRaceName("Nachtelfe")
--]]

--- Returns gender of given race name
-- @param name Name of a playable race (any client supported languages)
-- @return The gender index (0=neutral, 1=male, 2=female) and english name of gender (uppercase)
function LibRaces:GetGenderByRaceName(name)
	if self~=LibRaces then name = self; end
	assert(type(name)=="string");
	if Unpack then Unpack(); end
	local g = gender[strip(name,true)];
	if g then
		return g, genderEngStr[g]; -- 0=neutral, 1=male, 2=female
	end
end

--[[
Notes:
	* if lang nil or not match with client supported language codes then it fall back to current client language
	* returns nil if no match found
Arguments:
	lang - language code like enUS, zhCN, mx or tw (optional)
Returns:
	names - a table of names by selected language
Example:
	table = LibRaces:GetAllNamesByLanguage("ptBR")
	/dump LibStub("LibRaces-1.0"):GetAllNamesByLanguage("ptBR")
--]]
--- Returns a list of all race names by selected language or current client language
-- @param lang Language code like deDE, ptBR or shorter like en or tw
-- @return A table with localized race names
function LibRaces:GetAllNamesByLanguage(lang)
	if self~=LibRaces then lang = self; end
	local result,tmp,lang,a,b = {},{};
	lang = GetLanguageCode(lang);
	for _,tbl in pairs(data)do
		if tbl[lang] then
			a,b = tbl[lang][1],tbl[lang][2] or tbl[lang][1];
			if strlen(b)>strlen(a) then
				a,b = b,a;
			end
			if not tmp[a] then
				tinsert(result,a);
				tmp[a] = true;
			end
			if not tmp[b] then
				tinsert(result,b);
				tmp[b] = true;
			end
		end
	end
	return result,lang;
end

--[[
Notes:
	* returns nil if no match found
Arguments:
	text - a string containing a race name
Returns:
	raceLocaleName - localized name of only first found race
	raceEngToken - english token of only first found race
	raceEngName - english name of only first found race
Example:
	"Nachtelfe","NightElf","Night Elf" = LibRaces:FindRaceNameInText("Die junge Nachtelfe streift lautlos durch den dunklen Wald.")
	/dump LibStub("LibRaces-1.0"):FindRaceNameInText("Die junge Nachtelfe streift lautlos durch den dunklen Wald.")
--]]
--- Finds race name in text and returns locaized and english race name
-- @param text Text with race name
-- @return Found race name in given language, english name without whitespaces and dashes and english race name
function LibRaces:FindRaceNameInText(text)
	if self~=LibRaces then text = self; end
	assert(type(text)=="string","Usage: <LibRaces-1.0>:FindRaceNameInText(<text>) - string expected, got "..type(text));
	local names,res = LibRaces:GetAllNamesByLanguage();
	-- damned limitation of lua pattern...
	for i=1, #names do
		res = text:match(names[i]:gsub(" ","[ ]*"):gsub("%-","[%-]*"));
		if res then
			return res, LibRaces:GetRaceToken(res);
		end
	end
end
