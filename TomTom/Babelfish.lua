#!/usr/local/bin/lua

local strings = {}

for i=1,#arg do
	local file = io.open(arg[i], "r")
	assert(file, "Could not open " .. arg[i])
	local text = file:read("*all")

	for match in string.gmatch(text, "L%[\"(.-)\"%]") do
		strings[match] = true
	end	
end

local work = {}

for k,v in pairs(strings) do table.insert(work, k) end
table.sort(work)

print("--Localization.enUS.lua\n")
print("TomTomLocals = {")
for idx,match in ipairs(work) do
	local val = match
	print(string.format("\t[\"%s\"] = \"%s\",", match, val))
end
print("}\n")
print("setmetatable(TomTomLocals, {__index=function(t,k) rawset(t, k, k); return k; end})")
