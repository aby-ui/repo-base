local MAJOR, MINOR = 'LibDropDown', 6
assert(LibStub, MAJOR .. ' requires LibStub')

local lib = LibStub:NewLibrary(MAJOR, MINOR)
if(not lib) then
	return
end

lib.dropdowns = {}
lib.styles = {}

--[[ LibDropDown:CloseAll(_ignore_)
Closes all open dropdowns, even ones made with [Blizzard voodoo](https://www.townlong-yak.com/framexml/live/UIDropDownMenu.lua).

* `ignore`: Menu to ignore when hiding _(frame/string)_
--]]
function lib:CloseAll(ignore)
	if(type(ignore) == 'string') then
		ignore = _G[ignore]
	end

	-- hide blizzard's
	securecall('CloseDropDownMenus')

	-- hide ours
	for menu in next, lib.dropdowns do
		if(menu ~= ignore) then
			menu:Hide()
		end
	end
end

--[[ LibDropDown:RegisterStyle(_name, data_)
Register a style for use with [Button:SetStyle(name)](Button#buttonsetstylename) and [Menu:SetStyle(name)](Menu#menusetstylename).

* `name`: Any name _(string)_
* `data`: Table containing (all optional) values:
	* `gap`: space between submenus _(number)_
	* `padding`: space between menu contents and backdrop border _(number)_
	* `spacing`: space between lines in menus _(number)_
	* `minWidth`: minimum width of the menus _(number, default = 100)_
	* `maxWidth`: maximum width of the menus _(number, optional)_
	* `backdrop`: standard [Backdrop](http://wowprogramming.com/docs/widgets/Frame/SetBackdrop) _(table)_
	* `backdropColor`: color object, see notes _(object)_
	* `backdropBorderColor`: color object, see notes _(object)_
	* `normalFont`: font object, see notes _(object/string)_
	* `highlightFont`: font object, see notes _(object/string)_
	* `disabledFont`: font object, see notes _(object/string)_
	* `titleFont`: font object, see notes _(object/string)_
	* `highlightTexture`: texture path to replace the highlight texture _(string)_
	* `radioTexture`: texture path to replace the radio/checkbox texture _(string)_
	* `expandTexture`: texture path to replace the expand arrow texture _(string)_

#### Notes

* All fonts must be [font objects](http://wowprogramming.com/docs/widgets/Font) (by reference or name).  
	See [CreateFont](http://wowprogramming.com/docs/api/CreateFont), and [SharedXML/SharedFontStyles.xml](https://www.townlong-yak.com/framexml/ptr/SharedFontStyles.xml).
* All colors must be color objects (by reference).  
	See [CreateColor](https://www.townlong-yak.com/framexml/live/go/CreateColor).
* `radioTexture` is dependant on texture coordinates, see [Interface/Common/UI-DropDownRadioChecks](https://github.com/Gethe/wow-ui-textures/blob/live/COMMON/UI-DropDownRadioChecks.PNG).
--]]
function lib:RegisterStyle(name, data)
	self.styles[name] = data
end

--[[ LibDropDown:IsStyleRegistered(_name_)
Returns `true`/`false` whether a style with the given name is already registered or not.
--]]
function lib:IsStyleRegistered(name)
	return not not self.styles[name]
end
