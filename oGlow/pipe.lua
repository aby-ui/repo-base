local _, ns = ...
local oGlow = ns.oGlow

local pipesTable = {}
local numPipes = 0

local argcheck = oGlow.argcheck

function oGlow:RegisterPipe(pipe, enable, disable, update, name, desc)
	argcheck(pipe, 2, 'string')
	argcheck(enable, 3, 'function')
	argcheck(disable, 4, 'function', 'nil')
	argcheck(update, 5, 'function')
	argcheck(name, 6, 'string', 'nil')
	argcheck(desc, 7, 'string', 'nil')

	-- Silently fail.
	if(pipesTable[pipe]) then
		return nil, string.format('Pipe [%s] is already registered.')
	else
		numPipes = numPipes + 1

		pipesTable[pipe] = {
			enable = enable;
			disable = disable;
			name = name;
			update = update;
			desc = desc;
		}
	end

	return true
end

do
	local function iter(_, n)
		local n, t = next(pipesTable, n)
		if(t) then
			return n, t.isActive, t.name, t.desc
		end
	end

	function oGlow.IteratePipes()
		return iter, nil, nil
	end
end

function oGlow:EnablePipe(pipe)
	argcheck(pipe, 2, 'string')

	local ref = pipesTable[pipe]
	if(ref and not ref.isActive) then
		ref.enable(self)
		ref.isActive = true

		oGlowDB.EnabledPipes[pipe] = true

		return true
	end
end

function oGlow:DisablePipe(pipe)
	argcheck(pipe, 2, 'string')

	local ref = pipesTable[pipe]
	if(ref and ref.isActive) then
		if(ref.disable) then ref.disable(self) end
		ref.isActive = nil

		oGlowDB.EnabledPipes[pipe] = nil

		return true
	end
end

function oGlow:IsPipeEnabled(pipe)
	argcheck(pipe, 2, 'string')

	return pipesTable[pipe].isActive
end

function oGlow:UpdatePipe(pipe)
	argcheck(pipe, 2, 'string')

	local ref = pipesTable[pipe]
	if(ref) then
		ref.update(self)

		return true
	end
end

function oGlow:GetNumPipes()
	return numPipes
end

ns.pipesTable = pipesTable
