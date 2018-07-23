BLibrary_226f708186be917ad2bc613c0e64ca55 = {};
function BLibrary_226f708186be917ad2bc613c0e64ca55:new()
    local BLibrary_799f29b621456a365c52ec84282766c2 = {}; setmetatable(BLibrary_799f29b621456a365c52ec84282766c2, self);
    if (self.__index ~= self) then
        self.__index = self;
    end BLibrary_799f29b621456a365c52ec84282766c2:constructor(); return BLibrary_799f29b621456a365c52ec84282766c2;
end

function BLibrary_226f708186be917ad2bc613c0e64ca55:constructor() self.BLibrary_bc4d26b7ed499c26222c288b9f460a2d = {}; end

function BLibrary_226f708186be917ad2bc613c0e64ca55:Register(BLibrary_b962f54280c77029bc350c2b321adc64, BLibrary_791d17790b7f87980736899c25ab6997, BLibrary_9fe6bb2a2116fc0336142d2abe4d8785, BLibrary_f5634a24d4f6a0c7ea870ac7fdfe7d73) assert(BLibrary_b962f54280c77029bc350c2b321adc64 and type(BLibrary_b962f54280c77029bc350c2b321adc64) == "table", "The class must be specified."); assert(BLibrary_b962f54280c77029bc350c2b321adc64.constructor, "The method <constructor> must be defined."); assert(BLibrary_791d17790b7f87980736899c25ab6997 and type(BLibrary_791d17790b7f87980736899c25ab6997) == "string", "The type of parameter library must be string.");
if (self.BLibrary_bc4d26b7ed499c26222c288b9f460a2d[BLibrary_791d17790b7f87980736899c25ab6997]) then
    error(string.format("The library <%s> has been registered.", BLibrary_791d17790b7f87980736899c25ab6997)); return false;
end if (BLibrary_b962f54280c77029bc350c2b321adc64.__index ~= BLibrary_b962f54280c77029bc350c2b321adc64) then BLibrary_b962f54280c77029bc350c2b321adc64.__index = BLibrary_b962f54280c77029bc350c2b321adc64; end self.BLibrary_bc4d26b7ed499c26222c288b9f460a2d[BLibrary_791d17790b7f87980736899c25ab6997] = {}; self.BLibrary_bc4d26b7ed499c26222c288b9f460a2d[BLibrary_791d17790b7f87980736899c25ab6997].BLibrary_b962f54280c77029bc350c2b321adc64 = BLibrary_b962f54280c77029bc350c2b321adc64; self.BLibrary_bc4d26b7ed499c26222c288b9f460a2d[BLibrary_791d17790b7f87980736899c25ab6997].BLibrary_9fe6bb2a2116fc0336142d2abe4d8785 = BLibrary_9fe6bb2a2116fc0336142d2abe4d8785; self.BLibrary_bc4d26b7ed499c26222c288b9f460a2d[BLibrary_791d17790b7f87980736899c25ab6997].BLibrary_f5634a24d4f6a0c7ea870ac7fdfe7d73 = BLibrary_f5634a24d4f6a0c7ea870ac7fdfe7d73; return true;
end

local function CreateInstance(self, BLibrary_791d17790b7f87980736899c25ab6997, ...)
    assert(BLibrary_791d17790b7f87980736899c25ab6997 and type(BLibrary_791d17790b7f87980736899c25ab6997) == "string", "The type of parameter library must be string.");
    assert(self.BLibrary_bc4d26b7ed499c26222c288b9f460a2d[BLibrary_791d17790b7f87980736899c25ab6997], string.format("The library <%s> does not exist.", BLibrary_791d17790b7f87980736899c25ab6997));
    local BLibrary_91ac677b9aec5afd97ac9bd6a003c402 = setmetatable({}, self.BLibrary_bc4d26b7ed499c26222c288b9f460a2d[BLibrary_791d17790b7f87980736899c25ab6997].BLibrary_b962f54280c77029bc350c2b321adc64); BLibrary_91ac677b9aec5afd97ac9bd6a003c402:constructor(...); return BLibrary_91ac677b9aec5afd97ac9bd6a003c402;
end

BLibrary_226f708186be917ad2bc613c0e64ca55.CreateInstance = CreateInstance;
function BLibrary_226f708186be917ad2bc613c0e64ca55:GetClass(BLibrary_791d17790b7f87980736899c25ab6997) assert(BLibrary_791d17790b7f87980736899c25ab6997 and type(BLibrary_791d17790b7f87980736899c25ab6997) == "string", "The type of parameter library must be string.");
if (self.BLibrary_bc4d26b7ed499c26222c288b9f460a2d[BLibrary_791d17790b7f87980736899c25ab6997] and self.BLibrary_bc4d26b7ed499c26222c288b9f460a2d[BLibrary_791d17790b7f87980736899c25ab6997].BLibrary_b962f54280c77029bc350c2b321adc64) then
    return self.BLibrary_bc4d26b7ed499c26222c288b9f460a2d[BLibrary_791d17790b7f87980736899c25ab6997].BLibrary_b962f54280c77029bc350c2b321adc64;
else return false;
end
end

BLibrary = BLibrary_226f708186be917ad2bc613c0e64ca55:new(); getmetatable(BLibrary).__call = CreateInstance;
