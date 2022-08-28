
local DF = _G ["DetailsFramework"]
if (not DF or not DetailsFrameworkCanLoad) then
	return
end

local _

--mixin for options functions
DF.OptionsFunctions = {
	SetOption = function (self, optionName, optionValue)
		if (self.options) then
			self.options [optionName] = optionValue
		else
			self.options = {}
			self.options [optionName] = optionValue
		end

		if (self.OnOptionChanged) then
			DF:Dispatch (self.OnOptionChanged, self, optionName, optionValue)
		end
	end,

	GetOption = function (self, optionName)
		return self.options and self.options [optionName]
	end,

	GetAllOptions = function (self)
		if (self.options) then
			local optionsTable = {}
			for key, _ in pairs (self.options) do
				optionsTable [#optionsTable + 1] = key
			end
			return optionsTable
		else
			return {}
		end
	end,

	BuildOptionsTable = function (self, defaultOptions, userOptions)
		self.options = self.options or {}
		DF.table.deploy (self.options, userOptions or {})
		DF.table.deploy (self.options, defaultOptions or {})
	end
}

--payload mixin
DF.PayloadMixin = {
	ClearPayload = function(self)
		self.payload = {}
	end,

	SetPayload = function(self, ...)
		self.payload = {...}
		return self.payload
	end,

	AddPayload = function(self, ...)
		local currentPayload = self.payload or {}
		self.payload = currentPayload

		for i = 1, select("#", ...) do
			local value = select(i, ...)
			currentPayload[#currentPayload+1] = value
		end

		return self.payload
	end,

	GetPayload = function(self)
		return self.payload
	end,

	DumpPayload = function(self)
		return unpack(self.payload)
	end,

	--does not copy wow objects, just pass them to the new table, tables strings and numbers are copied entirely
	DuplicatePayload = function(self)
		local duplicatedPayload = DF.table.duplicate({}, self.payload)
		return duplicatedPayload
	end,
}
