--- LibOO-1.0
-- @class file
-- @name LibOO-1.0.lua

local MAJOR, MINOR = "LibOO-1.0", 23
local LibOO, oldminor = LibStub:NewLibrary(MAJOR, MINOR)

if not LibOO then return end


local tconcat = table.concat
local assert, error, loadstring, xpcall = assert, error, loadstring, xpcall
local setmetatable, getmetatable, rawset, rawget = setmetatable, getmetatable, rawset, rawget
local select, pairs, ipairs, type, tostring = select, pairs, ipairs, type, tostring

local clientVersion = select(4, GetBuildInfo())

local safecall
do
	local function errorhandler(err)
		return geterrorhandler()(err)
	end

	local function CreateDispatcher(argCount)
		local code = [[
			local xpcall, eh = ...
			local method, ARGS
			local function call() return method(ARGS) end
		
			local function dispatch(func, ...)
				 method = func
				 if not method then return end
				 ARGS = ...
				 return xpcall(call, eh)
			end
		
			return dispatch
		]]
		
		local ARGS = {}
		for i = 1, argCount do ARGS[i] = "arg"..i end
		code = code:gsub("ARGS", tconcat(ARGS, ", "))
		return assert(loadstring(code, "safecall Dispatcher["..argCount.."]"))(xpcall, errorhandler)
	end

	local Dispatchers = setmetatable({}, {__index=function(self, argCount)
		local dispatcher = CreateDispatcher(argCount)
		rawset(self, argCount, dispatcher)
		return dispatcher
	end})
	Dispatchers[0] = function(func)
		return xpcall(func, errorhandler)
	end
	 
	safecall = function(func, ...)
		return Dispatchers[select('#', ...)](func, ...)
	end
end

local function validateType(argN, methodName, var, reqType)
	local varType = type(var)
	
	local negate = reqType:sub(1, 1) == "!"
	local reqType = negate and reqType:sub(2) or reqType
	reqType = reqType:trim(" ")
	
	if varType == "table" then
		if type(var[0]) == "userdata" then
			if reqType == "frame" or reqType == "widget" then
				varType = reqType
			elseif var:IsObjectType(reqType) then
				varType = reqType
			end
		end
	end
	
	local isGood
	if negate then
		if varType ~= reqType then
			isGood = true
		end
	else
		if varType == reqType then
			isGood = true
		end
	end


	if not isGood then
	
		local varTypeName = varType
		if varType == "table" and type(var[0]) == "userdata" then
			varTypeName = "frame (" .. var:GetObjectType() .. ")"
		end

		if negate then 
			reqType = "!" .. reqType
		end
		
		error(("Bad argument #%s to %q. Expected %s, got %s"):format(argN, methodName, reqType, varTypeName), 3)
	end
end


LibOO.Namespaces = LibOO.Namespaces or {}

local LibOONamespace



local metamethods = {
	__add = true,
	__call = true,
	__concat = true,
	__div = true,
	__le = true,
	__lt = true,
	__mod = true,
	__mul = true,
	__pow = true,
	__sub = true,
	__tostring = true,
	__unm = true,
}

local funcsToCall = {}
local depth = 0
local function callFunc(class, instance, func, ...)
	local startIndex = #funcsToCall + 1
	depth = depth + 1

	-- Functions to call are placed in a single table to decrease garbage churn.
	-- The segment of the table where functions are placed in this call will be iterated over,
	-- and functions will be called based on where they are in the inheritance hierarchy

	for k, v in pairs(class.instancemeta.__index) do
		if type(k) == "string" and k:find("^" .. func) then
			funcsToCall[#funcsToCall + 1] = k
		end
	end
	
	if instance.isLibOOInstance then
		-- If this is being called on an instance of a class instead of a class,
		-- search the instance itself for matching functions too.
		-- This will never step on the toes of class.instancemeta.__index because
		-- iterating over an instance will only yield things explicity set on an instance -
		-- it will never directly contain anything inherited from a class.
		for k, v in pairs(instance) do
			if type(k) == "string" and k:find("^" .. func) then
				funcsToCall[#funcsToCall + 1] = k
			end
		end
	end

	for _, classIter in ipairs(class.inherits) do
		for i = startIndex, #funcsToCall do
			local funcName = funcsToCall[i]
			if funcName then
				local funcToCall = instance[funcName]

				if classIter[funcName] == funcToCall then
					funcsToCall[i] = false
					safecall(funcToCall, instance, ...)
				end
			end
		end
	end

	for i = startIndex, #funcsToCall do
		local funcName = funcsToCall[i]
		if funcName then
			safecall(instance[funcName], instance, ...)
		end
	end


	depth = depth - 1
	if depth == 0 then
		wipe(funcsToCall)
	end
end

local function initializeClass(self)
	if not self.initialized then
		-- set any defined metamethods
		for k, v in pairs(self.instancemeta.__index) do
			if metamethods[k] then
				self.instancemeta[k] = v
			end
		end
		
		self:CallFunc("OnFirstInstance")

		self.initialized = true
	end
end

local function class__call(self, arg)
	-- allow something like Namespace:NewClass("Name"){Foo = function() end, Bar = 5}
	if type(arg) == "table" then
		for k, v in pairs(arg) do
			if k == "METHOD_EXTENSIONS" and type(v) == "table" then
				for methodName, func in pairs(v) do
					self:PostHookMethod(methodName, func)
				end
			elseif k == "METHOD_EXTENSIONS_PRE" and type(v) == "table" then
				for methodName, func in pairs(v) do
					self:PreHookMethod(methodName, func)
				end
			else
				self[k] = v
			end
		end
	end
	return self
end

local function class__newindex(self, k, v)
	-- Update/set all subclasses at all levels of inheritance
	local existing = self[k]
	if existing ~= v then
		for class in pairs(self.inheritedBy) do
			if class[k] == existing then
				class[k] = v
			end
		end

		-- Update/set for this class
		-- Note: class.instancemeta.__index == getmetatable(class).__index
		-- We use .instancemeta here for speed
		self.instancemeta.__index[k] = v
	end
end

local function class__tostring(self)
	return tostring(self.namespace) .. "." .. self.className
end

local weakMetatable = {
	__mode = "kv"
}


LibOO.knownBlizzWidgets = LibOO.knownBlizzWidgets or setmetatable({}, weakMetatable)

local function inherit(self, source)
	if source then

		local metatable = getmetatable(self)
		local namespace = self.namespace
		
		local index, didInherit
		
		-- LibOO class inheritance (passed in class name)
		if type(source) == "string" then
			local ns, class = source:match("([^%.]*)%.(.*)")
			if ns and class then
				if LibOO.Namespaces[ns] then
					namespace = LibOO.Namespaces[ns]
					source = namespace[class]
				end
			elseif namespace[source] then
				source = namespace[source]
			end
		end

		if source == self then
			error(("%s tried to inherit itself."):format(tostring(self)), 3)
		end

		if type(source) == "table" then

			-- LibOO class inheritance (passed in class table)
			if source.isLibOOClass and source.CallFunc then
				if source.inherits[self] then
					error(("%s can't inherit %s because it would create cyclical inheritance."):format(tostring(self), tostring(source)), 3)
				end

				source:CallFunc("OnClassInherit", self)
				
				index = getmetatable(source).__index
				didInherit = true

			else
				-- Table inheritance
				index = source
				didInherit = true
			end
		else
		
			-- Blizzard widget inheritance
			if LibOO.knownBlizzWidgets[source] == nil then
				local success, frame = pcall(CreateFrame, source)

				if success then
					-- Need to hide the frame or else if we made an editbox,
					-- it will block all keyboard input for some reason
					frame:Hide()

					LibOO.knownBlizzWidgets[source] = frame
				else
					LibOO.knownBlizzWidgets[source] = false
				end
			end

			local frame = LibOO.knownBlizzWidgets[source]
			if frame then
				self.isFrameObject = source or self.isFrameObject
				rawset(self, "isFrameObject", rawget(self, "isFrameObject") or source)
				
				metatable.__index.isFrameObject = metatable.__index.isFrameObject or source
				
				index = getmetatable(frame).__index
				didInherit = true
			
			-- LibSub lib inheritance
			elseif LibStub(source, true) then
				local lib = LibStub(source, true)
				if lib.Embed then
					lib:Embed(metatable.__index)
					didInherit = true
				else
					error(("Library %q does not have an :Embed() method"):format(source), 2)
				end
			end
		end

		if not didInherit then
			error(("Could not figure out how to inherit %s into class %s. Are you sure it exists?"):format(source, tostring(self)), 3)
		end
		
		if index then
			for k, v in pairs(index) do
				if metatable.__index[k] == nil then
					metatable.__index[k] = v
				end
			end
		end
	end
end


--- Creates a new class.
-- @name Namespace:NewClass
-- @paramsig className, ...
-- @param className [String] The name of the class to be created.
-- @param ... [...] A list of things to inherit from. Valid parameters include the following (and each will be checked in the following order):
-- * The name of another LibOO-1.0 class in the same namespace as the class being created.
-- * The namespace and name for another LibOO-1.0 class, formatted as "Namespace.ClassName".
-- * A table that is a LibOO-1.0 class as returned by Namespace:NewClass()
-- * A plain table whose values will be merged into the class.
-- * The name of a Blizzard widget (like Frame, Button, EditBox, etc.) The class created will inherit the methods of that widget type, and instances of the class will be based on a new frame of that widget type.
-- * The name of a LibStub library that has an :Embed() method (many Ace3 libs do, e.g "AceEvent-3.0").
-- 
-- When conflicts between members of different inherited things arise, previously inherited (i.e. non-nil) members will not be overwritten.
-- @return [Class] A new class that inherits from LibOO:GetNamespace("LibOO-1.0").Class and all other requested inheritances.
local function NewClass(namespace, className, ...)
	
	if className then
		validateType("2 (className)", "Namespace:NewClass(className, ...)", className, "string")

		if className:find("^__") then
			error(MAJOR .. ": Class names may not start with two underscores (__) because this prefix is reserved for internal use by namespaces.", 2)
		end

		if namespace[className] then
			error(MAJOR .. ": A class with name " .. className .. " already exists. You can't overwrite existing classes, so pick a different name", 2)
		end
	end
	
	local metatable = {
		__index = { -- this is class.instancemeta.__index as well.
			isLibOOInstance = true,
		},
		__call = class__call,
		__tostring = class__tostring,
	}
	
	local class = {
		instances = {},
		inherits = {},
		inheritedBy = {},
		initialized = false,
		isLibOOClass = true,
		isLibOOInstance = false, -- Override the instancemeta so classes don't think they are instances.
	}

	local memAddr = tostring(class):gsub("table: ", "0x")

	class.instancemeta = {__index = metatable.__index}
	
	setmetatable(class, metatable)
	metatable.__newindex = class__newindex

	-- Makes referencing the class really easy - don't have to define a class variable for instances,
	-- and creates a unified way to definitely get the class for both classes and instances.
	class.class = class

	class.className = className or memAddr
	class.namespace = namespace

	if LibOONamespace then
		inherit(class, LibOONamespace.Class)
	end

	-- Inherit the requested classes/whatever
	for i = 1, select("#", ...) do
		local source = select(i, ...)
		inherit(class, source)
	end

	if className then
		namespace[className] = class
	end

	namespace.__callbacks:Fire("OnNewClass", class)

	return class
end

local ns__metatable = {
	__tostring = function(self)
		return self.__name
	end,
}


--- Gets a namespace.
-- A new namespace will be created if the namespace does not already exist.
-- @param namespace [String] The name of the namespace to get or create.
-- @return [Namespace} A LibOO-1.0 namespace that you can call Namespace:NewClass() on.
function LibOO:GetNamespace(namespace)
	validateType("2 (namespace)", "LibOO:GetNamespace(namespace)", namespace, "string")

	local ns = LibOO.Namespaces[namespace]

	if not ns then
		if namespace:find("%.") then
			error("LibOO-1.0: Namespace names may not contain periods.", 2)
		end

		ns = {NewClass = NewClass}
		setmetatable(ns, ns__metatable)
		ns.__callbacks = LibStub("CallbackHandler-1.0"):New(ns)
		ns.__name = namespace
		LibOO.Namespaces[namespace] = ns
	end

	return ns
end

-- Upgrade the NewClass method:
for _, namespace in pairs(LibOO.Namespaces) do
	namespace.NewClass = NewClass
end


LibOONamespace = LibOO:GetNamespace(MAJOR:gsub("%.", ""))

-- Define the base class. All other classes implicitly inherit from this class.
local Class = LibOONamespace.Class or LibOONamespace:NewClass("Class")

--- Instantiates a class.
--
-- All class methods and members will be accessed via metamethods.
-- 
-- If the class inherits from a Blizzard widget, any class methods that are valid script handler names for the widget type (like "OnClick" or "OnShow") will be hooked as script handlers on the instance.
-- @param ... [...] The constructor parameters of the new instance. If the class being instantiated inherits from a Blizzard widget, these will be passed directly to CreateFrame(...), and parameters after the 5th (the CreateFrame ID parameter) will be passed to calls of any class methods whose name **begins** with "OnNewInstance" (E.g. {{{Class:OnNewInstance_Class(self, ...)}}}). If this class does not inherit from a Blizzard, widget, all parameters will be passed to these calls.
-- @return A new instance of the class.
function Class:New(...)
	if self.isLibOOInstance then
		self = self.class
	end
	
	if self.isFrameObject then
		return self:NewFromExisting(CreateFrame(...), select(6, ...))
	else
		return self:NewFromExisting({}, ...)
	end
	
end

--- Creates an instance of the class out of an existing object. No additional memory is allocated to perform this.
-- 
-- If the class inherits from a Blizzard widget, any class methods that are valid script handler names for the widget type (like "OnClick" or "OnShow") will be hooked as script handlers on the instance.
-- 
-- @param instance [table] An existing table or widget to instantiate the class on. Cannot be something that has already been instantiated. If the existing object has a metatable, it will be overwritten with class.instancemeta.
-- @param ... [...] The constructor parameters of the new instance. In all cases, they will be passed to calls of any class methods whose name **begins** with "OnNewInstance" (E.g. {{{Class:OnNewInstance_Class(self, ...)}}}).
-- @return A new instance of the class.
function Class:NewFromExisting(instance, ...)
	validateType("2 (instance)", "Class:NewFromExisting(instance, ...)", instance, "table")

	if instance.isLibOOInstance then
		error("Cannot instantiate something that has already been instantiated!", 2)
	end

	local isWidget = type(instance[0]) == "userdata"

	if not isWidget and self.isFrameObject then
		error("Widget classes must be instantiated with widgets.", 2)
	elseif isWidget then
		if not self.isFrameObject then
			error("Non-widget classes must be instantiated on non-widgets.", 2)

		elseif instance:GetObjectType() ~= self.isFrameObject then
			error("Expected a " .. self.isFrameObject .. " widget, got a " .. instance:GetObjectType(), 2)
		end
	end

	if self.isLibOOInstance then
		self = self.class
	end

	-- if this is the first instance of the class, do some magic to it:
	initializeClass(self)

	setmetatable(instance, self.instancemeta)

	self.instances[#self.instances + 1] = instance
	
	for k, v in pairs(self.instancemeta.__index) do
		if self.isFrameObject and instance.HasScript and instance:HasScript(k) then
			instance:HookScript(k, v)
		end
	end

	instance:CallFunc("OnNewInstance", ...)
	
	self.namespace.__callbacks:Fire("OnNewInstance", self, instance)
	
	return instance
end



--- Pre-hooks the specified method so that it when called, it will first call newFunction, and then it will call the original method being hooked.
-- 
-- If the requested method is not defined when this is called, newFunction will simply be set as that method with no hooking involved.
-- @param method [String] The name of the method on the class that should be hooked.
-- @param newFunction [Function] The function that will be called after the original function is called.
function Class:PreHookMethod(method, newFunction)
	validateType("2 (method)", "Class:PostHookMethod(method, newFunction)", method, "!nil")
	validateType("3 (newFunction)", "Class:PostHookMethod(method, newFunction)", newFunction, "function")

	local existingFunction = self[method]
	if existingFunction then
		self[method] = function(...)
			newFunction(...)
			existingFunction(...)
		end
	else
		self[method] = newFunction
	end
end

--- Post-hooks the specified method so that it when called, it will first call the original method being extended, and then it will call newFunction.
-- 
-- If the requested method is not defined when this is called, newFunction will simply be set as that method with no hooking involved.
-- @param method [String] The name of the method on the class that should be hooked.
-- @param newFunction [Function] The function that will be called after the original function is called.
function Class:PostHookMethod(method, newFunction)
	validateType("2 (method)", "Class:PostHookMethod(method, newFunction)", method, "!nil")
	validateType("3 (newFunction)", "Class:PostHookMethod(method, newFunction)", newFunction, "function")

	local existingFunction = self[method]
	if existingFunction then
		self[method] = function(...)
			existingFunction(...)
			newFunction(...)
		end
	else
		self[method] = newFunction
	end
end

-- Backwards compatibility
Class.ExtendMethod = Class.PostHookMethod



--- Asserts that self is a LibOO class.
-- 
-- Throws a breaking error at the level of the caller's caller (user-level) if it is not.
function Class:AssertSelfIsClass()
	if not self.isLibOOClass then
		error(("Caller must be the class %q, not an instance of the class"):format(tostring(self)), 3)
	end
end

--- Asserts that self is an instance of a LibOO class.
-- 
-- Throws a breaking error at the level of the caller's caller (user-level) if it is not.
function Class:AssertSelfIsInstance()
	if not self.isLibOOInstance then
		error(("Caller must be an instance of the class %q, not the class itself"):format(tostring(self)), 3)
	end
end



--- Inherits the source into the class.
-- 
-- The source parameter must be one of the valid inheritance types documented in Namespace:NewClass()'s documentation.
-- @param [string|table] The source that should be inherited into the class.
-- @see Namespace:NewClass()
function Class:Inherit(source)
	self:AssertSelfIsClass()

	inherit(self, source)
end

--- Copies the requested source table into the caller (caller can be a class or an instance of a class).
-- @param source [table] The parent of the table that will be copied.
-- @param tableKey [!nil] The key on the parent that holds the table that will be copied. The copied table will be placed into this variable on the caller as well.
-- @usage Namespace:NewClass("One"){
-- 	someTable = {stuff1 = 1},
-- 	OnNewInstance = function(instance)
-- 		instance:InheritTable(instance.class, "someTable")
-- 
--		-- This commented line is functionally the same as the above line
-- 		-- since before the function call, instance.someTable == instance.class.someTable
-- 		-- instance:InheritTable(instance, "someTable")
-- 
-- 		instance.someTable.stuff2 = 2
-- 
-- 		-- This assertion will fail because we did not just modify the parent's someTable - we modified an instance-level copy.
-- 		assert(instance.class.someTable.stuff2)
-- 	end
-- }
-- 
-- @return [table] The destination table - self[tableKey].
function Class:InheritTable(source, tableKey)
	validateType("2 (source)", "Class:InheritTable(source, tableKey)", source, "table")
	validateType("3 (tableKey)", "Class:InheritTable(source, tableKey)", tableKey, "!nil")
	
	self[tableKey] = {}
	for k, v in pairs(source[tableKey]) do
		self[tableKey][k] = v
	end
	
	return self[tableKey]
end

--- Calls all the functions of a class that begin with funcName.
-- @param funcName [string] The beginning of the method name that must be matched in order for the method to be called.
-- @param ... The parameters that will be passed, after a reference to self, to the function(s) when they are called.
-- @usage -- Example usage from within the Class core on how this method is used.
-- -- It may be used externally, of course
-- 
-- -- Used to notify a class that the first instance of it has been created
-- -- so that it may preform any class-level initialization needed.
-- class:CallFunc("OnFirstInstance")
-- 
-- -- Another example:
-- -- Used when an instance of a class is created.
-- -- Functions as the instance constructor. See the How To page for more info.
-- instance:CallFunc("OnNewInstance", ...)
function Class:CallFunc(funcName, ...)
	if self.isLibOOClass then
		callFunc(self, self, funcName, ...)
	else
		callFunc(self.class, self, funcName, ...)
	end
end


--- Sets the __mode metamethod of the instances table of the class to "kv" so that instances will be garbage collected when they are orphaned everywhere else.
-- This behavior will not be inherited by subclasses. Keep in mind that Blizzard Frames cannot be garbage collected.
function Class:MakeInstancesWeak()
	setmetatable(self.instances, weakMetatable)
end



-- [INTERNAL]
function Class:OnClassInherit_BaseClass(newClass)
	-- for class in pairs(self.inherits) do
	-- 	newClass.inherits[class] = true
	-- 	class.inheritedBy[newClass] = true
	-- end

	for i, class in ipairs(self.inherits) do
		if not newClass.inherits[class] then
			tinsert(newClass.inherits, class)
			newClass.inherits[class] = true
		end

		class.inheritedBy[newClass] = true
	end
	
	if not newClass.inherits[self] then
		tinsert(newClass.inherits, self)
		newClass.inherits[self] = true
	end

	self.inheritedBy[newClass] = true
end




