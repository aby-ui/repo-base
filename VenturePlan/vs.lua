local _, T = ...
local SpellInfo = T.KnownSpells

local f32_ne, f32_perc, f32_pim do
	local frexp, lt = math.frexp, {
		[-80]=-0xcccccd*2^-24,
		[-60]=-0x99999a*2^-24,
		[-40]=-0xcccccd*2^-25,
		[-30]=-0x99999a*2^-25,
		[-20]=-0xcccccd*2^-26,
		[-10]=-0xcccccd*2^-27,
		[1]=0xa3d70a*2^-30,
		[3]=0xf5c28f*2^-29,
		[5]=0xcccccd*2^-28,
		[10]=0xcccccd*2^-27,
		[15]=0x99999a*2^-26,
		[20]=0xcccccd*2^-26,
		[30]=0x99999a*2^-25,
		[33]=0xa8f5c3*2^-25,
		[40]=0xcccccd*2^-25,
		[45]=0xe66666*2^-25,
		[60]=0x99999a*2^-24,
		[65]=0xa66666*2^-24,
		[70]=0xb33333*2^-24,
		[80]=0xcccccd*2^-24,
		[90]=0xe66666*2^-24,
		[120]=0x99999a*2^-23,
		[140]=0xb33333*2^-23,
		[160]=0xcccccd*2^-23,
		[4520]=0xb4cccd*2^-18,
		[9040]=0xb4cccd*2^-17,
	}
	function f32_perc(p)
		return lt[p] or f32_ne(p/100)
	end
	function f32_ne(f)
		local neg, s, e = f < 0, frexp(f)
		s = neg and -s or s
		local lo = s % 2^-24
		local a = lo >= 2^-25 and (lo > 2^-25 or s % 2^-23 >= 2^-24) and 2^-24 or 0
		local rv = (s - lo + a) * 2^e
		return neg and -rv or rv
	end
	function f32_pim(p, i)
		i = f32_ne(i * (lt[p] or f32_ne(p/100)))
		return i - i%1
	end
end
local function icast(f)
	local m = f % 1
	return f - m + (m > f and m > 0 and 1 or 0)
end

local VS, VSI = {}, {}
local VSIm = {__index=VSI}

local boardSlotName = {}
for i=0,15 do
	boardSlotName[i] = ("%x"):format(i)
end

local forkTargets = {["random-enemy"]="all-enemies", ["random-ally"]="all-allies", ["random-all"]="all"}
local TP = {} do
	local mistypedAutoAttack = {[57]=0, [181]=0, [209]=0, [341]=0, [409]=1, [777]=0, [69424]=0, [69426]=0, [69432]=0, [69434]=0, [69518]=0, [69522]=0, [69524]=0, [69530]=0, [69646]=0, [69648]=0, [69650]=0, [69652]=0, [70286]=0, [70288]=0, [70290]=0, [70292]=0, [70456]=0, [70478]=0, [70550]=0, [70556]=0, [70584]=0, [70586]=0, [70638]=0, [70640]=0, [70642]=0, [70644]=0, [70678]=0, [70682]=0, [70684]=0, [70702]=0, [70704]=0, [70706]=0, [70708]=0, [70714]=0, [70806]=0, [70808]=0, [70812]=0, [70832]=0, [70862]=0, [70868]=0, [70874]=0, [70908]=0, [71194]=0, [71606]=0, [71612]=0, [71640]=0, [71670]=0, [71672]=0, [71674]=0, [71676]=0, [71736]=0, [71800]=0, [71802]=0, [72086]=0, [72088]=0, [72090]=0, [72092]=0, [72310]=0, [72314]=0, [72336]=0, [72338]=0, [72942]=0, [72944]=0, [72946]=0, [72948]=0, [72954]=0, [73210]=0, [73398]=0, [73404]=0, [73558]=0, [73560]=0, [73564]=0}
	local targetLists do
		targetLists = {
		[0]={
			[0]="56a79b8c", "67b8ac59", "569a7b8c", "675a9b8c", "786bac59",
			"20314", "23014", "34201", "43120",
			"23014", "23401", "23401", "34201"
		},
		[1]={
			[0]="c89ba576", "95acb687", "c8b79a56", "9c58ab67", "95a6bc78",
			"41302", "41023", "20134", "20314",
			"41032", "10423", "01234", "20134"
		},
		[3]={
			[0]="23104", "03421", "03214", "20143", "31204",
			"56a79b8c", "5a7b698c", "56bac798", "7685a9bc",
			"56a79b8c", "96b57a8c", "a57c69b8", "56a79b8c"
		},
		[4]={
			[0]="0", "1", "2", "3", "4",
			"5","6","7","8",
			"9","a","b","c",
		},
		}
		for _, m in pairs(targetLists) do
			for o, t in pairs(m) do
				local r = {}
				for i=1,#t do
					r[i] = tonumber(t:sub(i,i), 16)
				end
				m[o] = r
			end
		end
	end
	local adjCleave = {
		[0x50]=3, [0x83]=1,
		[0x62]=3, [0x63]=2, [0xa2]=3, [0xa3]=2,
		[0x73]=4, [0x74]=3, [0xb3]=4, [0xb4]=3,
		[0x51]=4, [0x70]=1, [0x82]=0,
	}
	local adjCleaveN = {
		[0]={5,6,32,7,9,10,11,32,8,12},
		{6,7,32,8,10,11,12,32,5,9},
		{5,6,32,9,10,32,7,11,32,8,12},
		{6,7,32,5,9,10,11,32,8,12},
		{7,8,32,6,10,11,12,32,5,9},
		[7]={3,4,32,0,1,2},
	}
	local coneCleave = {
		[0x20]=1, [0x30]=1, [0x31]=1, [0x41]=1,
		[0x59]=1, [0x5a]=1,
		[0x69]=1, [0x6a]=1, [0x6b]=1,
		[0x7a]=1, [0x7b]=1, [0x7c]=1,
		[0x8b]=1, [0x8c]=1,
	}
	local friendSurround = {
		[0x01]=1, [0x02]=1, [0x03]=1,
		[0x10]=1, [0x13]=1, [0x14]=1,
		[0x20]=1, [0x23]=1,
		[0x30]=1, [0x31]=1, [0x32]=1, [0x34]=1,
		[0x41]=1, [0x43]=1,
	}
	local stt = {}
	local function GetTargets(source, tt, board)
		local ni, su, tl, lo, taunt = 1, board[source], targetLists[tt], source < 5 and source >= 0
		taunt, tl = su and su.taunt, tl and tl[source]
		if tl then
			for i=1,#tl do
				local t = tl[i]
				local tu = board[t]
				if tu and tu.curHP > 0 and not tu.shroud then
					stt[ni], ni = source < 5 and t > 4 and taunt or t, ni + 1
					break
				end
			end
		elseif tt == "all-enemies" then
			for i=lo and 5 or 0, lo and 12 or 4 do
				local tu = board[i]
				if tu and tu.curHP > 0 and not tu.shroud then
					stt[ni], ni = i, ni + 1
				end
			end
		elseif tt == "all-other-allies" then
			for i=lo and 0 or 5, lo and 4 or 12 do
				local tu = board[i]
				if i ~= source and tu and tu.curHP > 0 then
					stt[ni], ni = i, ni + 1
				end
			end
		elseif tt == "all-allies" then
			for i=lo and 0 or 5, lo and 4 or 12 do
				local tu = board[i]
				if tu and tu.curHP > 0 then
					stt[ni], ni = i, ni + 1
				end
			end
		elseif tt == "all" then
			for i=0,12 do
				local tu = board[i]
				if tu and tu.curHP > 0 and not tu.shroud then
					stt[ni], ni = i, ni + 1
				end
			end
		elseif tt == "friend-surround" then
			local f = source*16
			for i=0,12 do
				if friendSurround[f+i] then
					local tu = board[i]
					if tu and tu.curHP > 0 then
						stt[ni], ni = i, ni + 1
					end
				end
			end
			if ni == 1 then
				if source == 0 then
					stt[ni], ni = source, ni + 1
				else
					return GetTargets(source, "all-allies", board)
				end
			end
		elseif tt == "cone" then
			if taunt then
				if source == 4 then
					tl = targetLists[0][source]
					for i=1,#tl do
						local t = tl[i]
						local tu = board[t]
						if tu and tu.curHP > 0 and not tu.shroud then
							if t ~= taunt then
								tu = board[0]
								t = tu and tu.curHP > 0 and not tu.shroud and 0 or nil
							end
							stt[ni], ni = t, t and 2 or 1
							break
						end
					end
				else
					stt[1], ni = taunt, 2
				end
			elseif GetTargets(source, 0, board) and #stt > 0 then
				ni = 2
				local f = stt[1]*16
				for i=0,12 do
					if coneCleave[f+i] then
						local tu = board[i]
						if tu and tu.curHP > 0 and not tu.shroud then
							stt[ni], ni = i, ni + 1
						end
					end
				end
			end
		elseif tt == "cleave" then
			local coa = adjCleaveN[source]
			if taunt then
				stt[1], ni = taunt, 2
			elseif coa then
				for i=1,#coa do
					i = coa[i]
					if i <= 12 then
						local tu = board[i]
						if tu and tu.curHP > 0 and not tu.shroud then
							stt[ni], ni = i, ni + 1
						end
					elseif i == 32 and ni > 1 then
						break
					end
				end
			else
				GetTargets(source, 0, board)
				if #stt > 0 then
					local t = adjCleave[source*16+stt[1]]
					local tu = board[t]
					stt[2] = tu and tu.curHP > 0 and not tu.shroud and t or nil
					ni = stt[2] and 3 or 2
				end
			end
		elseif tt == "col" then
			GetTargets(source, 0, board)
			ni = #stt + 1
			local ex = lo and ni == 2 and not taunt and (stt[1]+4) or nil
			local exu = board[ex]
			if exu and exu.curHP > 0 and not exu.shroud then
				stt[2], ni = ex, ni + 1
			end
		elseif tt == "enemy-front" then
			local br = lo and 8 or 2
			for i=lo and 5 or 4, lo and 12 or 0, lo and 1 or -1 do
				local tu = board[i]
				if tu and tu.curHP > 0 and not tu.shroud then
					stt[ni], ni = i, ni + 1
				end
				if i == br and ni > 1 then
					break
				end
			end
			for i=1,ni > 2 and not lo and ni/2 or 0 do
				stt[ni-i], stt[i] = stt[i], stt[ni-i]
			end
		elseif tt == "enemy-back" then
			local br = lo and 9 or 1
			for i=lo and 12 or 0, lo and 5 or 4, lo and -1 or 1 do
				local tu = board[i]
				if tu and tu.curHP > 0 and not tu.shroud then
					stt[ni], ni = i, ni + 1
				end
				if i == br and ni > 1 then
					break
				end
			end
			for i=1,ni > 2 and lo and ni/2 or 0 do
				stt[ni-i], stt[i] = stt[i], stt[ni-i]
			end
		elseif tt == "friend-back" or tt == "friend-back-hard" or tt == "friend-back-soft" then
			local br, selfOK = lo and 1 or 9, tt == "friend-back"
			for i=lo and 0 or 12, lo and 4 or 5, lo and 1 or -1 do
				local tu = board[i]
				if tu and (i ~= source or selfOK) and tu.curHP > 0 then
					stt[ni], ni = i, ni + 1
				end
				if i == br and ni > 1 then
					break
				end
			end
			if ni == 1 and tt == "friend-back-soft" then
				stt[ni], ni = source, ni + 1
			end
		elseif tt == "friend-front" or tt == "friend-front-hard" or tt == "friend-front-soft" then
			local br, selfOK = lo and 2 or 8, tt == "friend-front"
			for i=lo and 4 or 5, lo and 0 or 12, lo and -1 or 1 do
				local tu = board[i]
				if tu and (i ~= source or selfOK) and tu.curHP > 0 then
					stt[ni], ni = i, ni + 1
				end
				if i == br and ni > 1 then
					break
				end
			end
			if ni == 1 and tt == "friend-front-soft" then
				stt[ni], ni = source, ni + 1
			end
		elseif tt == "self" then
			stt[ni], ni = source, ni + 1
		end
		for i=#stt, ni, -1 do
			stt[i] = nil
		end
		return stt
	end
	function TP:GetAutoAttack(role, slot, mid, firstSpell)
		local a1 = slot and mid and mistypedAutoAttack[4+2*slot+32*mid]
		local a2 = slot == nil and firstSpell and mistypedAutoAttack[1+4*firstSpell]
		return (a1 or a2 or (role == 1 or role == 5) and 0 or 1) == 0 and 11 or 15
	end
	TP.GetTargets = GetTargets
	TP.targetLists = targetLists
	TP.forkTargetMap = forkTargets
end

local function enq(qs, k, e)
	local q = qs[k]
	if q == nil then
		q = {}
		qs[k] = q
	end
	q[#q+1] = e
end
local function enqc(q, k, e)
	e[5] = e
	return enq(q, k, e)
end
local stacksort do
	local u2, o, u = {}
	local function cmp(a,b)
		local ac, bc = o[a], o[b]
		if ac == bc then
			return u2[a] < u2[b]
		end
		return u[ac] < u[bc]
	end
	function stacksort(s, bom)
		o, u = s.o, bom
		for i=1,#s do
			u2[s[i]] = i
		end
		table.sort(s, cmp)
		local nv, m = 1, s.m
		for i=1, #s do
			local v = s[i]
			nv, u2[v] = f32_ne(nv + m[v]), nil
		end
		return nv
	end
end

local mu = {}
function mu:stackf32(sourceIndex, targetIndex, stackName, magh, _sid)
	local b = self.board[targetIndex]
	local s = b.stacks[stackName]
	if s == nil then
		s = {m={}, o={}}
		b.stacks[stackName] = s
	end
	local tok = (self.lsToken or 0) - 1
	self.lsToken, self.lsName, self.lsTarget = tok, stackName, targetIndex
	s.m[tok], s.o[tok], s[#s+1] = f32_perc(magh), sourceIndex, tok
	b[stackName] = stacksort(s, self.bom)
	return tok
end
function mu:unstackf32(_sourceIndex, targetIndex, stackName, cancelToken)
	local b = self.board[targetIndex]
	local s = b.stacks[stackName]
	local m, nv, wi = s.m, 1, 1
	if not m[cancelToken] then error("cannot unwind") end
	m[cancelToken] = nil
	for i=1,#s do
		local t = s[i]
		if t ~= cancelToken then
			s[wi], wi = t, wi+1
			nv = f32_ne(nv + m[t])
		end
	end
	b[stackName], s[wi] = nv, nil
end
function mu:funstackf32(sourceIndex, atTurn, ord)
	local sn = self.lsName
	if not sn then
		error("stackop desync")
	end
	enq(self.queue, atTurn, {"unstackf32", sourceIndex, self.lsTarget, sn, self.lsToken, ord=ord})
	self.lsName = nil
end
function mu:modDamageDealt(sourceIndex, targetIndex, mod, sid)
	mu.stackf32(self, sourceIndex, targetIndex, "modDamageDealt", mod, sid)
end
function mu:modDamageTaken(sourceIndex, targetIndex, mod, sid)
	mu.stackf32(self, sourceIndex, targetIndex, "modDamageTaken", mod, sid)
end
function mu:damage(sourceIndex, targetIndex, baseDamage, causeTag, causeSID)
	local board, ret = self.board, false
	local tu, su = board[targetIndex], board[sourceIndex]
	local tHP = tu.curHP
	if tHP > 0 then
		local points = math.floor(baseDamage) + su.plusDamageDealt
		points = icast(f32_ne(points * su.modDamageDealt)) + tu.plusDamageTaken
		points = icast(f32_ne(points * tu.modDamageTaken))
		if points > 0 or (causeTag == "Thorn" and points ~= 0) then
			local tracer = self.trace
			if tracer then
				tracer(self, "HIT", sourceIndex, targetIndex, points, tHP, causeTag, causeSID)
			end
			if tHP > points then
				tu.curHP = tHP-points
				if points < 0 and (tHP-points) > tu.maxHP then
					tu.curHP = tu.maxHP
				end
			else
				tu.curHP = 0
				mu.die(self, targetIndex, causeTag)
				ret=true
			end
		end
		if causeTag ~= "Thorn" then
			local thorns = tu.thornsDamage
			if thorns > 0 and causeTag ~= "Tick" and causeTag ~= "Thorn" and causeTag ~= "EEcho" then
				mu.damage(self, targetIndex, sourceIndex, thorns, "Thorn", tu.thornsSID)
			end
		end
	end
	return ret
end
function mu:dtick(sourceIndex, targetIndex, esid, eeid, causeTag, causeSID)
	local board, ret = self.board
	local tu, su = board[targetIndex], board[sourceIndex]
	if tu.curHP > 0 then
		local effect = eeid ~= 0 and SpellInfo[esid][eeid] or SpellInfo[esid]
		local datk, dperc = effect.damageATK, effect.damagePerc
		local points = (datk and f32_pim(datk,su.atk) or 0) + (dperc and math.floor(dperc*tu.maxHP/100) or 0)
		if points > 0 then
			local dne = effect.dne and not self.over
			ret = mu.damage(self, sourceIndex, targetIndex, points, "Tick", causeSID)
			if dne and self.over then
				self.dne = true
			end
		end
		local datk, dperc = effect.healATK, effect.healPerc
		local points = (datk and f32_pim(datk,su.atk) or 0) + (dperc and math.floor(dperc*tu.maxHP/100) or 0)
		if points > 0 then
			mu.heal(self, sourceIndex, targetIndex, points, causeTag, causeSID)
		end
	end
	return ret
end
function mu:heal(sourceIndex, targetIndex, halfPoints, causeTag, causeSID)
	local board = self.board
	local tu = board[targetIndex]
	local cHP = tu.curHP
	if cHP > 0 then
		local points = math.floor(halfPoints)
		if points > 0 then
			local nhp, max = cHP + points, tu.maxHP
			nhp = nhp > max and max or nhp
			tu.curHP = nhp
			local tracer = self.trace
			if tracer then
				tracer(self, "HEAL", sourceIndex, targetIndex, points, cHP, causeTag, causeSID)
			end
		end
	end
end
function mu:shroud(_sourceIndex, targetIndex, delta)
	local tu = self.board[targetIndex]
	if tu then
		local ns = (tu.shroud or 0) + delta
		tu.shroud = ns > 0 and ns or nil
	end
end
function mu:spell(source, sid, eid, ord)
	local si = eid ~= 0 and SpellInfo[sid][eid] or SpellInfo[sid]
	local board = self.board
	local su = board[source]
	local rflag = false
	local sit, sitt, tt = si.type, si.target
	local ft = forkTargets[sitt]
	if not ft then
	elseif self.inFork then
		sitt, self.inFork = "fork", nil
	else
		tt = TP.GetTargets(source, ft, board)
		local lim, cc = self.forkLimit, self.forks
		cc = cc and #cc or 0
		if #tt > 1 then
			local oracle, baseSpell = self.forkOracle, SpellInfo[sid]
			local ownTarget = oracle and oracle(self.turn, source, sid) or tt[math.random(#tt)]
			for i=1,#tt do
				if tt[i] == ownTarget then
					tt[1], tt[i] = tt[i], tt[1]
					break
				end
			end
			self.mass, self.inFork, self.forkTarget = self.mass * #tt, true, nil
			for i=2,#tt do
				if not lim or #(self.forks or "") < lim then
					local f = self:Clone()
					f.forkTarget = tt[i]
					local fq = f.queue[self.turn]
					for e2=eid,#baseSpell do
						fq[#fq+1] = {"spell", source, sid, e2, ord-eid+e2}
					end
				else
					local prime = self.prime or self
					prime.droppedTraces = true
				end
			end
			self.inFork, self.forkTarget, sitt = nil, tt[1], "fork"
		else
			self.forkTarget, sitt = tt[1], "fork"
		end
	end
	
	if sitt == "fork" then
		if self.forkTarget == nil then
			return
		end
		tt = TP.GetTargets(self.forkTarget, "self", board)
	elseif sitt == "mark" then
		if self.markTarget == nil then
			return
		end
		tt = TP.GetTargets(self.markTarget, "self", board)
	else
		tt = TP.GetTargets(source, sitt, board)
	end
	if sit == "passive" then
		local onDeath = su.deathUnwind or {}
		local mdd, mdt, tatk = si.modDamageDealt, si.modDamageTaken, si.thornsATK
		local td = tatk and f32_pim(tatk,su.atk)
		for i=1,#tt do
			i = tt[i]
			local tu = board[i]
			if mdd then
				mu.modDamageDealt(self, source, i, mdd, sid)
				onDeath[#onDeath+1] = {"unstackf32", source, i, self.lsName, self.lsToken}
				self.lsName = nil
			end
			if mdt then
				mu.modDamageTaken(self, source, i, mdt, sid)
				onDeath[#onDeath+1] = {"unstackf32", source, i, self.lsName, self.lsToken}
				self.lsName = nil
			end
			if td then
				tu.thornsDamage = tu.thornsDamage + td
				tu.thornsSID = tu.thornsSID or sid
				onDeath[#onDeath+1] = {"statDelta", source, i, "thornsDamage", -td}
			end
		end
		su.deathUnwind = onDeath
	elseif sit == "mark" then
		self.markTarget = tt[1]
	elseif sit == "aura" then
		local period, duration = si.period, si.duration
		local mdd, mdt = si.modDamageDealt, si.modDamageTaken
		local datk, hatk = si.damageATK, si.healATK
		local halfPoints = datk and f32_pim(datk, su.atk) or 0
		local healPoints = hatk and f32_pim(hatk, su.atk) or 0
		local tb = self.turn-1
		local d1 = si.damageATK1
		local pdda, pdta, thornsa = si.plusDamageDealtATK, si.plusDamageTakenATK, si.thornsATK
		local hasDamage, hasHeal = si.damageATK or si.damagePerc, si.healATK or si.healPerc
		local modHPP, modHPA = si.modMaxHP, si.modMaxHPATK
		local pdd, pdt = pdda and (pdda*su.atk/100) or si.plusDamageDealtA, pdta and (pdta*su.atk/100) or si.plusDamageTakenA
		local nore = si.nore
		for ti=1,#tt do
			local i = tt[ti]
			local tu = board[i]
			local thornsp = thornsa and f32_pim(thornsa, tu.atk)
			if d1 then
				rflag = mu.damage(self, source, i, f32_pim(d1, su.atk), "EFirst", sid) or rflag
			end
			if not si.noFirstTick and halfPoints > 0 and not period then -- Periodic initial damage is deferred?
				rflag = mu.damage(self, source, i, halfPoints, (nore or d1) and "Tick" or "EFront", sid) or rflag
			end
			if healPoints > 0 and not si.noFirstTick and not period then -- Periodic heals are deferred too
				mu.heal(self, source, i, healPoints, "EFront", sid)
			end
			if tu.curHP > 0 then
				if mdd then
					mu.modDamageDealt(self, source, i, mdd, sid)
					mu.funstackf32(self, source, tb+duration+1, ord+(si.fadeOrd or -80))
				end
				if mdt then
					mu.modDamageTaken(self, source, i, mdt, sid)
					mu.funstackf32(self, source, tb+duration+1, ord+(si.fadeOrd or -80))
				end
				if pdd then
					tu.plusDamageDealt = tu.plusDamageDealt + pdd
					enq(self.queue, tb+duration+1, {"statDelta", source, i, "plusDamageDealt", -pdd, ord=ord-80})
				end
				if pdt then
					tu.plusDamageTaken = tu.plusDamageTaken + pdt
					enq(self.queue, tb+duration+1, {"statDelta", source, i, "plusDamageTaken", -pdt, ord=ord-80})
				end
				if modHPP or modHPA then
					local d = (modHPP and f32_pim(modHPP, tu.maxHP) or 0) + (modHPA and f32_pim(modHPA, su.atk) or 0)
					tu.curHP, tu.maxHP = tu.curHP+d, tu.maxHP+d
					enq(self.queue, tb+duration+1, {"statDelta", source, i, "maxHP", -d, ord=ord-100})
				end
				if thornsp then
					tu.thornsDamage = tu.thornsDamage + thornsp
					tu.thornsSID = tu.thornsSID or sid
					enq(self.queue, tb+duration+1, {"statDelta", source, i, "thornsDamage", -thornsp, ord=ord-80})
				end
				if period == 2 then
					for j=3,duration+1,2 do
						if hasDamage or hasHeal then
							enq(self.queue, tb+j, {"dtick", source, i, sid, eid, "Effect", sid, ord=ord-100+ti})
						end
					end
				else
					for j=2,duration do
						if hasDamage or hasHeal then
							enq(self.queue, tb+j, {"dtick", source, i, sid, eid, "Effect", sid, ord=ord-100+ti})
						end
					end
				end
				if si.echo then
					enq(self.queue, tb+si.echo+1, {"damage", source, i, halfPoints, "EEcho", sid, ord=ord-100+ti})
				end
			end
		end
	elseif sit == "nuke" then
		local mdd, sATK = si.modDamageDealt, su.atk
		local datk, datk2, dperc, echo = si.damageATK, si.damageATK2, si.damagePerc, si.echo
		local points1, points2 = datk and f32_pim(datk, sATK) or 0, datk2 and f32_pim(datk2, sATK) or 0
		echo = echo and (self.turn+echo) or nil
		local causeTag = si.nore and "Tick" or "Spell"
		for ti=1,#tt do
			local i = tt[ti]
			local tu = board[i]
			rflag = mu.damage(self, source, i, points1 + (dperc and math.floor(dperc*tu.maxHP/100) or 0), causeTag, sid) or rflag
			if points2 > 0 then
				rflag = mu.damage(self, source, i, points2, "Spell", sid) or rflag
			end
			if tu.curHP > 0 then
				if mdd then
					mu.modDamageDealt(self, source, i, mdd, sid)
					mu.funstackf32(self, source, self.turn+si.duration, ord-80)
				end
				if echo then
					enq(self.queue, echo, {"damage", source, i, points1, "Tick", sid, ord=ord-100+ti})
				end
			end
		end
		if si.healTarget == "self" then
			mu.heal(self, source, source, f32_pim(si.healATK or 0, su.atk), "DHeal", sid)
		end
	elseif sit == "nukem" then
		local sATK, d = su.atk, si.damageATK
		for i=1,#tt do
			local i = tt[i]
			for j=1,#d do
				local p = f32_pim(d[j], sATK)
				rflag = mu.damage(self, source, i, p, "Spell", sid) or rflag
			end
		end
	elseif sit == "heal" then
		local mdd, hPerc = si.modDamageDealt, si.healPercent
		for i=1,#tt do
			i = tt[i]
			local tu = board[i]
			local hatk = si.healATK
			local points = (hatk and f32_pim(hatk, su.atk) or 0) + (hPerc and math.floor(hPerc*tu.maxHP/100) or 0)
			mu.heal(self, source, i, points, "Spell", sid)
			if mdd then
				mu.modDamageDealt(self, source, i, mdd, sid)
				mu.funstackf32(self, source, self.turn+si.duration, ord-80)
			end
			if si.shroudTurns then
				tu.shroud = (tu.shroud or 0) + 1
				enq(self.queue, self.turn+si.shroudTurns, {"shroud", source, i, -1, ord=ord})
			end
		end
	elseif sit == "taunt" then
		for i=1,#tt do
			i = tt[i]
			local tu = board[i]
			tu.taunt = source
			enq(self.queue, self.turn+si.duration, {"untaunt", source, i, sid, ord=ord-100})
		end
	end
	return rflag
end
function mu:untaunt(source, target, _sid)
	local tu = self.board[target]
	if tu and tu.taunt == source then
		tu.taunt = nil
	end
end
function mu:statDelta(_sourceIndex, targetIndex, statName, delta)
	local tu = self.board[targetIndex]
	if tu then
		local nv = tu[statName] + delta
		tu[statName] = nv
		if statName == "maxHP" and tu.curHP > nv then
			tu.curHP = nv
		end
	end
end
function mu:die(deadIndex, causeTag)
	local k, board, wasOver = deadIndex < 5 and "liveFriends" or "liveEnemies", self.board, self.over
	self[k] = self[k] - 1
	if self[k] == 0 then
		self.over, self.won = true, deadIndex >= 5
	end
	local ds = 0
	for i=0,12 do
		local tu = board[i]
		if tu then
			if tu.taunt == deadIndex then
				tu.taunt = nil
			end
			local tds = (tu.deathSeq or 0)
			if tds > ds then
				ds = tds
			end
		end
	end
	local du = board[deadIndex]
	du.deathSeq = ds + 1
	if causeTag == "Thorn" then
		self.over = wasOver or self.over and "Thorn"
	else
		local duw = du.deathUnwind
		for i=1, duw and #duw or 0 do
			local q = duw[i]
			mu[q[1]](self, unpack(q,2))
		end
	end
end
function mu:cast(sourceIndex, sid, recast, qe)
	local board = self.board
	local su = board[sourceIndex]
	if su.curHP > 0 or sourceIndex < 0 then
		local si = SpellInfo[sid]
		local ord1 = (qe.ord or 0)-1
		if si.type ~= "passive" then
			enq(self.queue, self.turn+recast+1, qe)
		end
		if #si > 0 then
			for i=1,#si do
				mu.spell(self, sourceIndex, sid, i, ord1+i)
			end
		else
			mu.spell(self, sourceIndex, sid, 0, ord1+1)
		end
	end
end

function VSI:Turn(isResumed)
	local q, turn
	if isResumed then
		turn = self.turn
		q = self.queue[turn]
	else
		turn = self.turn + 1
		q, self.turn = self.queue[turn], turn
		self:SortAttackOrder(q)
	end
	local qi
	for i=#q,1,-1 do
		qi, q[i] = q[i], nil
		mu[qi[1]](self, unpack(qi, 2))
		if self.over then
			local si, sn = qi[2], i > 1 and q[i-1][2] or nil
			if self.over ~= true and si and sn and self.board[si].curHP == 0 and self.board[sn].curHP == 0 then
			elseif self.dne then
				self.dne = nil
			else
				for j=i-1,1,-1 do
					if q[j][2] == qi[2] and q[j][1] == "statDelta" then
						qi = q[j]
						mu[qi[1]](self, unpack(qi, 2))
						break
					end
				end
				break
			end
		end
	end
	self.checkpoints[self.turn] = self:CheckpointBoard()
	self.queue[self.turn] = nil
	return not not self.over
end
function VSI:Run()
	if self.unfinishedTurn then
		self.unfinishedTurn = nil
		self:Turn(true)
	end
	while not self.over do
		self:Turn()
	end
	self.queue = nil
	if self.forks and not self.prime then
		local i, forks = (self.exploredForks or 0) + 1, self.forks
		local winMass, lossMass = self.winMass, self.lossMass
		if winMass == nil then
			winMass, lossMass = self.won and 1/self.mass or 0, self.won and 0 or 1/self.mass
		end
		local rMass = 1-winMass-lossMass
		while i <= #forks do
			forks[i]:Run()
			local mi, won = 1/forks[i].mass, forks[i].won
			winMass, lossMass, rMass = winMass + (won and mi or 0), lossMass + (won and 0 or mi), rMass - mi
			i = i + 1
		end
		local isFullyExplored = i >= #forks and not self.droppedTraces
		self.winMass, self.lossMass = winMass, lossMass
		self.pWin = lossMass == 0 and isFullyExplored and 1 or winMass
		self.pLose = winMass == 0 and isFullyExplored and 1 or lossMass
		self.exhaustive, self.exploredForks = isFullyExplored, i-1
	elseif not self.prime then
		local isFullyExplored, mass = not self.droppedTraces, 1/self.mass
		self.pWin = self.won and (isFullyExplored and 1 or mass) or 0
		self.pLose = self.won and 0 or (isFullyExplored and 1 or mass)
		self.exhaustive = isFullyExplored
	end
end
function VSI:CheckpointBoard()
	local board = self.board
	local c = ""
	for i=0,12 do
		local b = board[i]
		if b and b.curHP > 0 then
			c = (c ~= "" and c .. "_" or "") .. boardSlotName[i] .. ":" .. b.curHP
		end
	end
	return c
end
function VSI:SortAttackOrder(q)
	local board, bo, bom = self.board, self.boardOrder, self.bom
	for b=0,12 do
		local e = board[b]
		if e then
			bom[b] = (b < 5 and 1e9 or 2e9) - e.curHP * 1e3 + b + 20*(e.deathSeq or 0)
		end
	end
	table.sort(bo, function(a,b)
		return bom[a] < bom[b]
	end)
	for i=1,#bo do
		bom[bo[i]] = i
	end
	table.sort(q, function(a, b)
		local ac, bc = a.ord0 or bom[a[2]], b.ord0 or bom[b[2]]
		if ac == bc then
			ac, bc = a.ord or 0, b.ord or 0
		end
		return ac > bc
	end)
end
function VSI:Clone()
	local n = setmetatable({}, VSIm)
	local q, r, s, d = {}, {[self]=n}, self, n
	local forks = self.forks or {[0]=self}
	self.forks, forks[#forks+1] = forks, n
	r[self.prime or 0], r[forks] = self.prime, forks
	r[0] = nil
	while s do
		q[s] = nil
		for k,v in pairs(s) do
			if r[k] then
				k = r[k]
			elseif type(k) == "table" then
				r[k] = setmetatable({}, getmetatable(k))
				q[k], k = r[k], r[k]
			end
			if r[v] then
				v = r[v]
			elseif type(v) == "table" then
				r[v] = setmetatable({}, getmetatable(v))
				q[v], v = r[v], r[v]
			end
			d[k] = v
		end
		q[s] = nil
		s, d = next(q)
	end
	n.prime, n.forkOracle = self.prime or self
	return n
end

local function addActorProps(a)
	a.modDamageTaken = 1
	a.modDamageDealt = 1
	a.plusDamageTaken = 0
	a.plusDamageDealt = 0
	a.thornsDamage = 0
	a.stacks = {}
	return a
end
function VS:New(team, encounters, envSpell, mid, mscalar, forkOracle, forkLimit)
	local q, board, nf, missingSpells = {}, {}, 0
	for _, f in pairs(team) do
		if f.stats then
			f.attack, f.health, f.maxHealth = f.stats.attack, f.stats.currentHealth, f.stats.maxHealth
		end
		local rf = {maxHP=f.maxHealth, curHP=math.max(1,f.health), atk=f.attack, slot=f.boardIndex, name=f.name}
		for i=1,#f.spells do
			local s = f.spells[i]
			local sid = s.autoCombatSpellID
			local si = SpellInfo[sid]
			if not si then
				missingSpells = missingSpells or {}
				missingSpells[sid] = 1
			elseif si.type ~= "nop" then
				local qe = {"cast", rf.slot, sid, s.cooldown}
				if si.phase == 0 then
					qe.ord0, qe.ord = 0, rf.slot*1e3 + i*10
				else
					qe.ord = 1e5 + rf.slot*1e3 + 500 + i*10
				end
				enqc(q, si.firstTurn or 1, qe)
			end
		end
		local aa = TP:GetAutoAttack(f.role, nil, nil, f.spells and f.spells[1] and f.spells[1].autoCombatSpellID)
		enqc(q, 1, {"cast", rf.slot, aa, 0, ord=1e5 + rf.slot*1e3 + 500})
		board[f.boardIndex], nf = addActorProps(rf), nf + 1
	end
	for i=1,#encounters do
		local e = encounters[i]
		local rf = {maxHP=e.maxHealth, curHP=e.maxHealth, atk=e.attack, slot=e.boardIndex}
		for i=1,#e.autoCombatSpells do
			local s = e.autoCombatSpells[i]
			local sid = s.autoCombatSpellID
			local si = SpellInfo[sid]
			if not si then
				missingSpells = missingSpells or {}
				missingSpells[sid] = 1
			elseif si.type ~= "nop" then
				local qe = {"cast", rf.slot, sid, s.cooldown}
				if si.phase == 0 then
					qe.ord0, qe.ord = 0, rf.slot*1e3 + i*10
				else
					qe.ord = 1e5 + rf.slot*1e3 + 500 + i*10
				end
				enqc(q, si.firstTurn or 1, qe)
			end
		end
		local aa = TP:GetAutoAttack(e.role, rf.slot, mid, e.autoCombatSpells and e.autoCombatSpells[1] and e.autoCombatSpells[1].autoCombatSpellID)
		enqc(q, 1, {"cast", rf.slot, aa, 0, ord=1e5 + rf.slot*1e3 + 500})
		board[e.boardIndex] = addActorProps(rf)
	end
	
	local environmentSID = envSpell and envSpell.autoCombatSpellID
	local esi = SpellInfo[environmentSID]
	if environmentSID and not esi then
		missingSpells = missingSpells or {}
		missingSpells[environmentSID] = 2
	elseif esi and esi.type ~= "nop" then
		-- There's no way making the environment killable is going to cause problems later. Nope. No way at all.
		board[-1] = addActorProps({atk=(esi.cATKa or 0) + (esi.cATKb or 0)*mscalar, curHP=1e9, maxHP=1e9, slot=-1})
		enqc(q, esi.firstTurn or 1, {"cast", -1, environmentSID, envSpell.cooldown, ord=0})
	end
	
	local boardOrder = {}
	for b=0,12 do
		local e = board[b]
		if e then
			boardOrder[1+#boardOrder] = b
		end
	end
	
	local ii = setmetatable({
		board=board, turn=0, queue=q,
		liveFriends=nf, liveEnemies=#encounters, over=nf == 0,
		checkpoints={}, boardOrder=boardOrder, bom={[-1]=14},
		mass=1, forkOracle=forkOracle, forkLimit=forkLimit,
	}, VSIm)
	ii.checkpoints[0] = ii:CheckpointBoard()
	return ii, missingSpells
end


T.VSim, VS.TP, VS.VSI, VS.mu = VS, TP, VSI, mu
