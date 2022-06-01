-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSRoutines = private.NewLib("RareScannerRoutines")

-- RareScanner general libraries
local RSUtils = private.ImportLib("RareScannerUtils")

local function getDelay()
	local fps = 1
	if (C_CVar.GetCVar("targetFPS") and tonumber(C_CVar.GetCVar("targetFPS")) > 0) then
		fps = tonumber(C_CVar.GetCVar("targetFPS"))
	elseif (GetFramerate() > 0) then
		fps = GetFramerate()
	else
		fps = 35
	end
	
	return 500/fps
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

local LoopIndexRoutine = {} do
	
	function LoopIndexRoutine:Init(getterItems, chunkSize, processChunk, onfinishCallback, ...)
		self.context, self.deadline = {}
		self.context.currentIndex = 1
		self.context.getterItems = getterItems
		self.context.chunkSize = chunkSize
		self.context.processChunk = processChunk
		self.context.onfinishCallback = onfinishCallback
		self.context.arguments = { ... }
	end
	
	function LoopIndexRoutine:Run(processChunk, onfinishCallback)
		if (not self.context) then
			return true
		end
		
		local callback = processChunk or self.context.processChunk
		local finishCallback = onfinishCallback or self.context.onfinishCallback
		
		self.deadline = debugprofilestop() + getDelay()
		repeat
			local chunkIndex = 1
			local initialIndex = self.context.currentIndex
			local getter
			if (self.context.arguments) then
				getter = self.context.getterItems(unpack(self.context.arguments))
			else
				getter = self.context.getterItems()
			end
			
			if (tonumber(getter)) then
				for i = initialIndex, getter do
					if (chunkIndex == self.context.chunkSize) then
						return false
					end
					
					callback(self.context, i)
					self.context.currentIndex = self.context.currentIndex + 1
					chunkIndex = chunkIndex + 1
				end
			else
				for i = initialIndex, #getter do
					if (chunkIndex == self.context.chunkSize) then
						return false
					end
					
					callback(self.context, i)
					self.context.currentIndex = self.context.currentIndex + 1
					chunkIndex = chunkIndex + 1
				end
			end
			
			self.context.finished = true
			if (finishCallback) then
				finishCallback(self.context)
			end
			
			return true
		until debugprofilestop() > self.deadline
	end
	
	function LoopIndexRoutine:Restart(callback)
		if (callback) then
			callback(self.context)
		end
		return true
	end
	
	function LoopIndexRoutine:IsRunning()
		if self.context and not self.context.finished then
			return true
		else
			return false
		end
	end
	
	function LoopIndexRoutine:Reset()
		self.context.currentIndex = 1
	end
	
	function LoopIndexRoutine:New()
        return clone(self)
    end
end

local LoopRoutine = {} do
	
	function LoopRoutine:Init(getterItems, chunkSize, processChunk, onfinishCallback, ...)
		self.context, self.deadline = {}
		self.context.currentIndex = 1
		self.context.getterItems = getterItems
		self.context.chunkSize = chunkSize
		self.context.processChunk = processChunk
		self.context.onfinishCallback = onfinishCallback
		self.context.arguments = { ... }
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
			local getter
			if (self.context.arguments) then
				getter = self.context.getterItems(unpack(self.context.arguments))
			else
				getter = self.context.getterItems()
			end
			
			for key, value in pairs(getter) do
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
			return
		end
		
		local function RunNext(index)
			local nextIndex, nextLoopRoutine = next(self.context.chainLoopRoutines, index)
			if (nextLoopRoutine) then
				C_Timer.NewTicker(0.1, function(self)
					local finished = nextLoopRoutine:Run()
					if (finished) then
						self:Cancel()
						RunNext(nextIndex)
					end
				end)
			else
				self.context.finished = true
				if (onfinishCallback) then
					onfinishCallback(self.context)
				end
			end
		end
		
		RunNext();
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

function RSRoutines.LoopIndexRoutineNew()
	return LoopIndexRoutine:New()
end

function RSRoutines.ChainLoopRoutineNew()
	return ChainLoopRoutine:New()
end