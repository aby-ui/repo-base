local GlobalAddonName, ExRT = ...

local module = ExRT.mod:New("Profiles",ExRT.L.Profiles,nil,true)
local ELib,L = ExRT.lib,ExRT.L

local MAJOR_KEYS = {
	["Addon"]=true,
	["Profiles"]=true,
	["Profile"]=true,
	["ProfileKeys"]=true,
}

function module:ReselectProfileOnLoad()
	if VExRT.ProfileKeys and not VExRT.ProfileKeys[ ExRT.SDB.charKey ] then
		VExRT.ProfileKeys[ ExRT.SDB.charKey ] = "default"
	end
	if not VExRT.ProfileKeys or not VExRT.ProfileKeys[ ExRT.SDB.charKey ] or not VExRT.Profile or not VExRT.Profiles then
		return
	end
	local charProfile = VExRT.ProfileKeys[ ExRT.SDB.charKey ]
	if charProfile == VExRT.Profile then
		return
	end
	if not VExRT.Profiles[ charProfile ] then
		VExRT.ProfileKeys[ ExRT.SDB.charKey ] = VExRT.Profile
		return
	end
	local saveDB = {}
	VExRT.Profiles[ VExRT.Profile ] = saveDB
	
	for key,val in pairs(VExRT) do
		if not MAJOR_KEYS[key] then
			saveDB[key] = val
		end
	end
	
	for key,val in pairs(VExRT) do
		if not MAJOR_KEYS[key] then
			VExRT[key] = nil
		end
	end
	
	for key,val in pairs( VExRT.Profiles[ charProfile ] ) do
		if not MAJOR_KEYS[key] then
			VExRT[key] = val
		end
	end
	VExRT.Profiles[ charProfile ] = {}
	VExRT.Profile = charProfile
end

function module.options:Load()
	local function GetCurrentProfileName()
		return VExRT.Profile=="default" and L.ProfilesDefault or VExRT.Profile
	end
	local function GetCurrentProfilesList(func)
		local list = {
			{ text = L.ProfilesDefault, func = func, arg1 = "default", _sort = "0" },
		}
		for name,_ in pairs(VExRT.Profiles) do
			if name ~= "default" then
				list[#list + 1] = { text = name, func = func, arg1 = name, _sort = "1"..name }
			end
		end
		sort(list,function(a,b) return a._sort < b._sort end)
		return list
	end
	local function SaveCurrentProfiletoDB()
		local profileName = VExRT.Profile or "default"
		local saveDB = {}
		VExRT.Profiles[ profileName ] = saveDB
		
		for key,val in pairs(VExRT) do
			if not MAJOR_KEYS[key] then
				saveDB[key] = val
			end
		end
	end
	local function LoadProfileFromDB(profileName,isCopy)
		local loadDB = VExRT.Profiles[ profileName ]
		if not loadDB then
			print("Error")
			return
		end
		
		for key,val in pairs(VExRT) do
			if not MAJOR_KEYS[key] then
				VExRT[key] = nil
			end
		end
		for key,val in pairs(loadDB) do
			if not MAJOR_KEYS[key] then
				VExRT[key] = val
			end
		end
		
		if not isCopy then
			VExRT.Profiles[ profileName ] = {}
		end
		
		ReloadUI()
	end

	self:CreateTilte()

	self.introText = ELib:Text(self,L.ProfilesIntro,11):Size(650,200):Point(5,-45):Top():Color()
	
	self.currentText = ELib:Text(self,L.ProfilesCurrent,11):Size(650,200):Point(5,-90):Top():Color()
	self.currentName = ELib:Text(self,GetCurrentProfileName(),11):Size(650,200):Point(200,-90):Top()

	self.choseText = ELib:Text(self,L.ProfilesChooseDesc,11):Size(650,200):Point(5,-130):Top():Color()
	
	self.choseNewText = ELib:Text(self,L.ProfilesNew,11):Size(650,200):Point(5,-158):Top()
	self.choseNew = ELib:Edit(self):Size(170,20):Point(10,-170)
	
	self.choseNewButton = ELib:Button(self,L.ProfilesAdd):Size(70,20):Point("LEFT",self.choseNew,"RIGHT",0,0):OnClick(function (self)
		local text = module.options.choseNew:GetText()
		module.options.choseNew:SetText("")
		if text == "" or text == "default" or VExRT.Profiles[text] then
			return
		end
		VExRT.Profiles[text] = {}
		
		StaticPopupDialogs["EXRT_PROFILES_ACTIVATE"] = {
			text = L.ProfilesActivateAlert,
			button1 = L.YesText,
			button2 = L.NoText,
			OnAccept = function()
				SaveCurrentProfiletoDB()
				VExRT.Profile = text
				VExRT.ProfileKeys[ ExRT.SDB.charKey ] = text
				LoadProfileFromDB(text)
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_PROFILES_ACTIVATE")
	end)
	
	self.choseSelectText = ELib:Text(self,L.ProfilesSelect,11):Size(605,200):Point(325,-158):Top()
	self.choseSelectDropDown = ELib:DropDown(self,220,10):Point(320,-170):Size(235):SetText(GetCurrentProfileName())
	
	local function SelectProfile(_,name)
		ELib:DropDownClose()
		if name == VExRT.Profile then
			return
		end
		SaveCurrentProfiletoDB()
		VExRT.Profile = name
		VExRT.ProfileKeys[ ExRT.SDB.charKey ] = name
		LoadProfileFromDB(name)
	end
	function self.choseSelectDropDown:ToggleUpadte()
		self.List = GetCurrentProfilesList(SelectProfile)
	end
	
	local function CopyProfile(_,name)
		ELib:DropDownClose()
		LoadProfileFromDB(name,true)
	end
	self.copyText = ELib:Text(self,L.ProfilesCopy,11):Size(605,200):Point(15,-208):Top()
	self.copyDropDown = ELib:DropDown(self,220,10):Point(10,-220):Size(235)
	function self.copyDropDown:ToggleUpadte()
		self.List = GetCurrentProfilesList(CopyProfile)
		for i=1,#self.List do
			if self.List[i].arg1 == VExRT.Profile then
				for j=i,#self.List do
					self.List[j] = self.List[j+1]
				end
				break
			end
		end
	end
	
	local function DeleteProfile(_,name)
		ELib:DropDownClose()
		StaticPopupDialogs["EXRT_PROFILES_REMOVE"] = {
			text = L.ProfilesDeleteAlert,
			button1 = L.YesText,
			button2 = L.NoText,
			OnAccept = function()
				VExRT.Profiles[name] = nil
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_PROFILES_REMOVE")
	end
	self.deleteText = ELib:Text(self,L.ProfilesDelete,11):Size(605,200):Point(15,-258):Top()
	self.deleteDropDown = ELib:DropDown(self,220,10):Point(10,-270):Size(235)
	function self.deleteDropDown:ToggleUpadte()
		self.List = GetCurrentProfilesList(DeleteProfile)
		for i=1,#self.List do
			if self.List[i].arg1 == VExRT.Profile then
				for j=i,#self.List do
					self.List[j] = self.List[j+1]
				end
				break
			end
		end
		for i=1,#self.List do
			if self.List[i].arg1 == "default" then
				for j=i,#self.List do
					self.List[j] = self.List[j+1]
				end
				break
			end
		end
	end

end

function module.main:ADDON_LOADED()
	if not VExRT then
		return
	end
	VExRT.ProfileKeys = VExRT.ProfileKeys or {}
	VExRT.Profiles = VExRT.Profiles or {}
	VExRT.Profile = VExRT.Profile or "default"
	
	VExRT.ProfileKeys[ ExRT.SDB.charKey ] = VExRT.Profile
end