local addonName, addon = ...
_G[addonName] = addon
addon.db = {}
addon.defaultDB = {
	keep_session = true,
	character_only = false,
	lines = 32,
    backlog = true,
	historys = {
--[[
		[ream_name] = {
			box1 = {
				{ line = "aaa", time = "aaa" }
			}
		}
]]		
	},
}
local charKey = GetRealmName().."-"..UnitName("player")
local db

local boxes = {}

--防止循环调用
local function RawAdd(box, text)
	box.rawadd = true;
	box:AddHistoryLine(text);
	box.rawadd = nil;
end

local function RawClear(box)
	box.rawclear = true;
	box:ClearHistory();
	box.rawclear = nil;
end

--对所有EditBox调用回调函数
local names = {} for i=1, NUM_CHAT_WINDOWS do names[i] = "ChatFrame"..i.."EditBox" end
local function WithAllEditBoxes(func)
	for i=1, NUM_CHAT_WINDOWS do
		if _G[names[i]] then
			func(_G[names[i]]);
		end
	end
end

local function RemoveSame(historyCopy, line)
	local i=1;
	while i<=#historyCopy do
		local v = historyCopy[i]
		if line == v.line or addon:IsSecureCmd(v.line) then
			table.remove(historyCopy, i);
		else
			i=i+1;
		end
	end
end

function U1ChatHistory_HookAddHistoryLine(self, line)
    --print("AddHistoryLine "..line)

    --内部调用不处理, 不然就堆栈溢出了.
    if self.rawadd then return end
    
    if db.lines <= 0 then return end

    if addon:IsSecureCmd(line) then return end --如果是安全则不处理HistoryLine，这样可以让安全命令保存到下一次输入非安全命令。下次输入非安全命令就会删除全部安全命令同时恢复刷新之前的记录。

    local historyCopy = db.historys[charKey][self:GetName()];

    --全部清理, 重新添加
    RawClear(self);
    --删除完全相同的, 只保留最后一个
    RemoveSame(historyCopy, line);

    --加入入新的数据
    local reuse;
    while #historyCopy > db.lines - 1 do reuse = table.remove(historyCopy, 1); end
    if reuse then table.wipe(reuse) else reuse = {} end
    reuse.line = line; reuse.time = time();
    table.insert(historyCopy, reuse);

    for i=1, #historyCopy do
        RawAdd(self , historyCopy[i].line);
    end
end

local function HookEditBox(box)
    local historyCopy = db.historys[charKey][box:GetName()];

	hooksecurefunc(box, "AddHistoryLine", function(...) U1ChatHistory_HookAddHistoryLine(...) end);

	hooksecurefunc(box, "ClearHistory", function(self)
		--TODO 如果不是characteronly, 则删除其他角色的.
		if self.rawclear then return end;
		while #historyCopy > 0 do table.remove(historyCopy) end
	end)

	--如果显示"未知的命令, 输入/help"的提示, 说明是一条无效命令, 根据配置决定是否添加
	CoreRawHook(box.chatFrame, "AddMessage", function(self, message)
		if message:find(HELP_TEXT_SIMPLE.."$") then
			--print("HELP :"..self.editBox:GetText())
			self.editBox:AddHistoryLine(self.editBox:GetText())
		end
	end)

end

local function upgradedb(db)
    if(db) then
        for k, v in next, db do
            -- removed
            if(addon.defaultDB[k] == nil) then
                db[k] = nil
            end
        end

        for k, v in next, addon.defaultDB do
            if(db[k] == nil) then
                db[k] = v
            end
        end
    end

    return db
end

function addon:VARIABLES_LOADED()
	self.db = upgradedb(ChatHistoryDB) or self.defaultDB
	db = self.db
	ChatHistoryDB = db
	db.historys[charKey] = db.historys[charKey] or {};
	local historys = db.historys[charKey];
	WithAllEditBoxes(function(box) historys[box:GetName()] = historys[box:GetName()] or {}; end);
	if not db.character_only then
		--合并其他角色的历史记录
		local combined = {}
		WithAllEditBoxes(function(box)
			local history = {}
			combined[box:GetName()] = history;
			for i, char in pairs(db.historys) do
				for _, v in pairs(char[box:GetName()]) do
					local skip = false;
					for _, oldv in pairs(history) do
						if oldv.line==v.line then
							oldv.time = max(oldv.time, v.time);
							skip = true;
							break;
						end
					end
					if not skip then table.insert(history, v); end
				end
			end
			table.sort(history, function(a,b) return a.time < b.time end);
			while #history > db.lines do table.remove(history, 1); end
		end);
		historys = combined;
		db.historys[charKey] = historys;
	end
	if db.keep_session then
		WithAllEditBoxes(function(box)
			for _, v in pairs(historys[box:GetName()]) do
				--print(v.line);
				box:AddHistoryLine(v.line);
			end
		end)
	end
	WithAllEditBoxes(function(box) HookEditBox(box) end);

    --命令行出错时是否保存记录.
    -- 加入这个会导致所有错误堆栈顶点都显示是从163ChatHistory发起的.
    if DEBUG_MODE then
        local handler = geterrorhandler();
        seterrorhandler(function(Error)
            if(ChatEdit_GetActiveWindow()) then
                ChatEdit_GetActiveWindow():AddHistoryLine(ChatEdit_GetActiveWindow():GetText());
            end
            return handler(Error)
        end);
    end
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...) addon[event](addon, event, ...) end)
f:RegisterEvent("VARIABLES_LOADED")
addon.f = f

function U1ChatHistory_AltArrowKeyMode(v)
    WithAllChatFrame(function(chatframe, v) chatframe.editBox:SetAltArrowKeyMode(v) end, v)
end
