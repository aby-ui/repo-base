-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSRoutines = private.NewLib("RareScannerRoutines")

-- RareScanner general libraries
local RSUtils = private.ImportLib("RareScannerUtils")

local function getDelay()
	return 500/(tonumber(C_CVar.GetCVar("targetFPS")) or GetFrameRate() or 35)
end

local function clone(object)
    local dict = {}
    
    local function clone(object)
        if (type(object) ~= "table") then
            return object
        elseif (dict[object]) then
            return dict[object]
        end
        
        dict[object] = {}
        
        for k, v in pairs(object) do
            dict[object][k] = clone(v)
        end
        
        return setmetatable(dict[object], clone(getmetatable(object)))
    end

    return clone(object)
end

local LoopRoutine = {} do
	
	function LoopRoutine:Init(getterItems, chunkSize, processChunk, onfinishCallback, arguments)
		self.context, self.deadline = {}
		self.context.currentIndex = 1
		self.context.getterItems = getterItems
		self.context.chunkSize = chunkSize
		self.context.processChunk = processChunk
		self.context.onfinishCallback = onfinishCallback
		self.context.arguments = arguments
	end
	
	function LoopRoutine:Run(processChunk, onfinishCallback)
		if (not self.context) then
			return true
		end
		
		local callback = processChunk or self.context.processChunk
		local finishCallback = onfinishCallback or self.context.onfinishCallback
		
		self.deadline = debugprofilestop() + getDelay()
		repeat
			local totalIndex = 1
			local chunkIndex = 1
			for key, value in pairs(self.context.arguments and self.context.getterItems(self.context.arguments) or self.context.getterItems()) do
				if (totalIndex >= self.context.currentIndex) then
					if (chunkIndex == self.context.chunkSize) then
						return false
					end
					
					callback(self.context, key, value)
					self.context.currentIndex = self.context.currentIndex + 1
					chunkIndex = chunkIndex + 1
				end
				
				totalIndex = totalIndex + 1
			end
			
			self.context.finished = true
			if (finishCallback) then
				finishCallback(self.context)
			end
			
			return true
		until debugprofilestop() > self.deadline
	end
	
	function LoopRoutine:Restart(callback)
		if (callback) then
			callback(self.context)
		end
		return true
	end
	
	function LoopRoutine:IsRunning()
		if self.context and not self.context.finished then
			return true
		else
			return false
		end
	end
	
	function LoopRoutine:Reset()
		self.context.currentIndex = 1
	end
	
	function LoopRoutine:New()
        return clone(self)
    end
end

local ChainLoopRoutine = {} do
	
	function ChainLoopRoutine:Init(chainLoopRoutines)
		self.context = {}
		self.context.chainLoopRoutines = chainLoopRoutines
	end
	
	function ChainLoopRoutine:Run(onfinishCallback)
		if (not self.context) then
			return true
		end
		
		local function RunNext(index)
			local nextIndex, nextLoopRoutine = next(self.context.chainLoopRoutines, index)
			if (nextLoopRoutine) then
				C_Timer.NewTicker(0.1, function(self)
					local finished = nextLoopRoutine:Run()
					if (finished) then
						self:Cancel()
						return RunNext(nextIndex)
					end
				end)
			end
			
			self.context.finished = true
			if (onfinishCallback) then
				onfinishCallback(self.context)
			end
			return true
		end
		
		return RunNext();
	end
	
	function ChainLoopRoutine:IsRunning()
		if self.context and not self.context.finished then
			return true
		else
			return false
		end
	end
	
	function ChainLoopRoutine:New()
        return clone(self)
    end
end

function RSRoutines.LoopRoutineNew()
	return LoopRoutine:New()
end

function RSRoutines.ChainLoopRoutineNew()
	return ChainLoopRoutine:New()
end