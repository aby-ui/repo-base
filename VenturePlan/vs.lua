local _, T = ...
local SpellInfo = T.KnownSpells

local band, bor, floor = bit.band, bit.bor, math.floor
local f32_ne, f32_perc, f32_pim, f32_fpim do
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
	function f32_fpim(p, i)
		return f32_ne(i * (lt[p] or f32_ne(p/100)))
	end
end
local f32_sr do
	local ah, al = {}, {}
	local ev, minv, maxv = {}, {}, {}
	function f32_sr(s)
		local c, mc = s.c, #s
		if mc == 1 then
			local m, r = f32_perc(s[1]), 1
			for i=1, c[s[1]] do
				r = f32_ne(r+m)
			end
			return r, r
		end
		table.sort(s)
		local sk, ec = "", 0
		for i=1,mc do
			local m = s[i]
			ec = ec + c[m]
			sk = sk .. m .. ":" .. ec .. ":"
		end
		local vl, vh = al[sk], ah[sk]
		if vl then
			return vl, vh
		end
		local sv, cv = 0, 1
		for i=1,mc do
			local m = s[i]
			local c, smul = c[m], 2
			while smul <= c do
				smul = smul + smul
			end
			ev[i], sv, minv[i], maxv[i], cv = f32_perc(m), sv+cv*c, cv, cv*smul, cv*smul
		end
		local hi, lo = {[sv]=1}, {[sv]=1}
		for i=1,ec do
			local hi2, lo2 = {}, {}
			for k, v in pairs(hi) do
				for j=1,mc do
					local f, mv = k % maxv[j], minv[j]
					if f >= mv then
						local nk = k - mv
						local vj = ev[j]
						local hv = f32_ne(v+vj)
						local lv = f32_ne(lo[k]+vj)
						local oh, ol = hi2[nk], lo2[nk]
						if oh == nil or hv > oh then
							hi2[nk] = hv
						end
						if ol == nil or lv < ol then
							lo2[nk] = lv
						end
					end
				end
			end
			hi, lo = hi2, lo2
		end
		vl, vh = lo[0], hi[0]
		al[sk], ah[sk] = vl, vh
		return vl, vh
	end
end
local function icast(f)
	local m = f % 1
	return f - m + (m > f and m > 0 and 1 or 0)
end

local VS, VSI = {}, {}
local VSIm = {__index=VSI}

local slotHex = {[-1]="w"}
for i=0,15 do
	slotHex[i] = ("%x"):format(i)
end

local forkTargets = {["random-enemy"]="all-enemies", ["random-ally"]="all-allies", ["random-all"]="all"}
local forkTargetBits= {["all-enemies"]=1, ["all-allies"]=2, ["all"]=4}
do -- targets
	local overrideAA = {[57]=0, [181]=0, [209]=0, [341]=0, [777]=0, [1213]=0, [1301]=0, [69424]=0, [69426]=0, [69432]=0, [69434]=0, [69518]=0, [69522]=0, [69524]=0, [69530]=0, [69646]=0, [69648]=0, [69650]=0, [69652]=0, [70286]=0, [70288]=0, [70290]=0, [70292]=0, [70456]=0, [70478]=0, [70550]=0, [70556]=0, [70584]=0, [70586]=0, [70638]=0, [70640]=0, [70642]=0, [70644]=0, [70678]=0, [70682]=0, [70684]=0, [70702]=0, [70704]=0, [70706]=0, [70708]=0, [70714]=0, [70806]=0, [70808]=0, [70812]=0, [70832]=0, [70862]=0, [70868]=0, [70874]=0, [70908]=0, [71194]=0, [71606]=0, [71612]=0, [71640]=0, [71670]=0, [71672]=0, [71674]=0, [71676]=0, [71736]=0, [71800]=0, [71802]=0, [72086]=0, [72088]=0, [72090]=0, [72092]=0, [72310]=0, [72314]=0, [72336]=0, [72338]=0, [72942]=0, [72944]=0, [72946]=0, [72948]=0, [72954]=0, [73210]=0, [73398]=0, [73404]=0, [73558]=0, [73560]=0, [73564]=0}
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
			"56a79b8c", "5a7b69c8", "6bac8759", "768bc95a",
			"5a6978bc", "96b57a8c", "a78c69b5", "8b7c65a9"
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
	local adjCleaveT = {
		[6]={6,21,9,10},
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
			local ot
			tl = targetLists[0][source]
			for i=1,#tl do
				i = tl[i]
				local tu = board[i]
				if tu and tu.curHP > 0 and not tu.shroud then
					stt[1], ot, ni = taunt or i, i, 2
					break
				end
			end
			if taunt == 6 and source == 4 and ot ~= taunt then
				local tu = board[0]
				if tu and tu.curHP > 0 and not tu.shroud then
					stt[1], ni, ot = 0, 2
				else
					local t2 = board[2]
					if t2 and t2.curHP > 0 and not t2.shroud then
						stt[1], ni, ot = 2, 2
						for i=5,6 do
							tu = board[i]
							if tu and tu.curHP > 0 and not tu.shroud then
								stt[ni], ni = i, ni + 1
							end
						end
					end
				end
			end
			if ot then
				local f = stt[1]*16
				for i=lo and 5 or 0, lo and 12 or 4 do
					if coneCleave[f+i] then
						local tu = board[i]
						if tu and tu.curHP > 0 and not tu.shroud then
							stt[ni], ni = i, ni + 1
						end
					end
				end
			end
		elseif tt == "cleave" then
			local coa, cot = adjCleaveN[source], adjCleaveT[taunt]
			if cot then
				for i=1,#cot do
					i = cot[i]
					if i <= 12 then
						local tu = board[i]
						if tu and tu.curHP > 0 and not tu.shroud then
							stt[ni], ni = i, ni + 1
						end
					elseif i >= 16 then
						local tu = board[i-16]
						if tu and tu.curHP > 0 and not tu.shroud then
							break
						end
					end
				end
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
				if taunt and (ni < 2 or stt[1] ~= taunt) then
					stt[1], ni = taunt, 2
				elseif taunt and ni > 3 then
					ni = 3
				end
			elseif taunt then
				stt[1], ni = taunt, 2
			else
				GetTargets(source, 0, board)
				if #stt > 0 then
					local s1 = stt[1]
					local t = adjCleave[source*16+s1]
					local tu = board[t]
					local s2 = tu and tu.curHP > 0 and not tu.shroud and t or nil
					stt[2], ni = s2, s2 and 3 or 2
					if s2 and s2 < s1 then
						stt[1], stt[2] = s2, s1
					end
				end
			end
		elseif tt == "col" then
			GetTargets(source, 0, board)
			ni = #stt + 1
			local ex = lo and ni == 2 and (stt[1]+4) or nil
			local exu = board[ex]
			if exu and exu.curHP > 0 and not exu.shroud then
				stt[2], ni = ex, ni + 1
			end
		elseif tt == "enemy-front" then
			local br = lo and 8 or 2
			for i=lo and (taunt and taunt > 8 and 9 or 5) or 4, lo and 12 or 0, lo and 1 or -1 do
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
			for i=lo and (taunt and taunt < 9 and 8 or 12) or 0, lo and 5 or 4, lo and -1 or 1 do
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
	function VS:GetAutoAttack(role, slot, mid, firstSpell)
		local a1 = slot and mid and overrideAA[4+2*slot+32*mid]
		local a2 = (slot or 0) < 5 and firstSpell and overrideAA[1+4*firstSpell]
		return (a1 or a2 or (firstSpell == 11 or role == 1 or role == 5) and 0 or 1) == 0 and 11 or 15
	end
	VS.GetTargets = GetTargets
	VS.targetLists = targetLists
	VS.forkTargetMap = forkTargets
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

local mu = {}
function mu:stackf32(_sourceIndex, targetIndex, stackName, magh, _sid)
	local b = self.board[targetIndex]
	local s = b.stacks[stackName]
	if s == nil then
		b.stacks[stackName] = {magh, c={[magh]=1}}
	else
		local c = s.c
		local oc = c[magh]
		if oc then
			c[magh] = oc + 1
		else
			s[#s+1], c[magh] = magh, 1
		end
	end
	b[stackName], b[stackName .. "H"] = nil
end
function mu:unstackf32(_sourceIndex, targetIndex, stackName, magh)
	local b = self.board[targetIndex]
	local s = b.stacks[stackName]
	local c = s.c
	local oc = c[magh]
	if oc > 1 then
		c[magh] = oc - 1
	elseif #s == 1 then
		b[stackName], b[stackName .. "H"], b.stacks[stackName] = 1,1, nil
		return
	else
		c[magh] = nil
		for i=1, #s-1 do
			if s[i] == magh then
				s[i] = s[#s]
				break
			end
		end
		s[#s] = nil
	end
	b[stackName], b[stackName .. "H"] = nil
end
function mu:modDamageDealt(sourceIndex, targetIndex, mod, sid)
	mu.stackf32(self, sourceIndex, targetIndex, "modDamageDealt", mod, sid)
end
function mu:modDamageTaken(sourceIndex, targetIndex, mod, sid)
	mu.stackf32(self, sourceIndex, targetIndex, "modDamageTaken", mod, sid)
end
function mu:damage(sourceIndex, targetIndex, baseDamage, causeTag, causeSID, eDNE)
	local board = self.board
	local tu, su = board[targetIndex], board[sourceIndex]
	local tHP, rHP = tu.curHP, tu.hpR
	if tHP <= 0 then
		return
	end
	local su_mdd, tu_mdt, su_hmdd, tu_hmdt = su.modDamageDealt, tu.modDamageTaken
	if su_mdd then
		su_hmdd = su.modDamageDealtH
	else
		su_mdd, su_hmdd = f32_sr(su.stacks.modDamageDealt)
		su.modDamageDealt, su.modDamageDealtH = su_mdd, su_hmdd
	end
	if tu_mdt then
		tu_hmdt = tu.modDamageTakenH
	else
		tu_mdt, tu_hmdt = f32_sr(tu.stacks.modDamageTaken)
		tu.modDamageTaken, tu.modDamageTakenH = tu_mdt, tu_hmdt
	end
	if (su_mdd < 0) ~= (tu_mdt < 0) then
		tu_mdt, tu_hmdt = tu_hmdt, tu_mdt
	end
	local bp, pdd, pdt = floor(baseDamage), su.plusDamageDealt, tu.plusDamageTaken
	bp = pdd == 0 and bp or f32_ne(bp + pdd)
	local points = icast(su_mdd == 1 and bp or f32_ne(bp * su_mdd))
	points = pdt == 0 and points or f32_ne(points + pdt)
	points = icast(tu_mdt == 1 and points or f32_ne(points * tu_mdt))
	local pointsR, points2 = 0, points
	if su_mdd ~= su_hmdd or tu_mdt ~= tu_hmdt then
		points2 = icast(su_hmdd == 1 and bp or f32_ne(bp * su_hmdd))
		points2 = pdt == 0 and points2 or f32_ne(points2 + pdt)
		points2 = icast(tu_hmdt == 1 and points2 or f32_ne(points2 * tu_hmdt))
		if points > points2 then
			points, points2, pointsR = points2, points, points-points2
		elseif points < points2 then
			pointsR = points2-points
		end
	end
	if causeTag ~= "Thorn" and points <= 0 and points2 >= 0 then
		points, pointsR = 0, points2
	end
	if points2 > 0 or (causeTag == "Thorn" and (points ~= 0 or points2 ~= 0)) then
		local tracer = self.trace
		if tracer then
			tracer(self, "HIT", sourceIndex, targetIndex, points, tHP, causeTag, causeSID, pointsR)
		end
		if points < 0 then
			local nHP, maxHP, nrHP = tHP-points2, tu.maxHP, rHP + pointsR
			if nHP > maxHP then
				tu.curHP = maxHP
				local nr = nrHP - nHP + maxHP
				tu.rHP = nr > 0 and nr or 0
			else
				tu.curHP, tu.hpR = nHP, nrHP
			end
		elseif tHP > points then
			tu.curHP, tu.hpR = tHP - points, rHP + pointsR
		else
			tu.curHP, tu.hpR = 0, 0
			mu.die(self, sourceIndex, targetIndex, causeTag, eDNE)
		end
		if tu.curHP > 0 and tu.curHP <= tu.hpR then
			local oracle = self.finalHitOracle
			local survived = oracle and oracle(self.turn, sourceIndex, targetIndex, causeSID, tHP, rHP)
			if survived == nil then
				survived = math.random() >= 0.5
				local f = self:Clone()
				if f then
					local tuf = f.board[targetIndex]
					if survived then
						tuf.curHP, tuf.hpR = 0,0
						mu.die(f, sourceIndex, targetIndex, causeTag, eDNE)
					else
						tuf.hpR = tuf.curHP-1
						local thorns = tu.thornsDamage
						if thorns > 0 and causeTag ~= "Tick" and causeTag ~= "Thorn" and causeTag ~= "EEcho" then
							local fqh = f.sqh-1
							f.sqh, f.sq[fqh] = fqh, {"damage", targetIndex, sourceIndex, thorns, "Thorn", tu.thornsSID}
						end
					end
				end
			end
			if survived then
				tu.hpR = tu.curHP-1
			else
				tu.curHP, tu.hpR = 0, 0
				mu.die(self, sourceIndex, targetIndex, causeTag, eDNE)
			end
		end
	end
	local thorns = tu.thornsDamage
	if thorns > 0 and causeTag ~= "Tick" and causeTag ~= "Thorn" and causeTag ~= "EEcho" then
		mu.damage(self, targetIndex, sourceIndex, thorns, "Thorn", tu.thornsSID)
	end
end
function mu:dtick(sourceIndex, targetIndex, esid, eeid, causeTag, causeSID)
	local board = self.board
	local tu, su = board[targetIndex], board[sourceIndex]
	if tu.curHP > 0 then
		local effect = eeid ~= 0 and SpellInfo[esid][eeid] or SpellInfo[esid]
		local datk, dperc = effect.damageATK, effect.damagePerc
		local points = (datk and f32_pim(datk,su.atk) or 0) + (dperc and floor(dperc*tu.maxHP/100) or 0)
		if points > 0 then
			mu.damage(self, sourceIndex, targetIndex, points, "Tick", causeSID, effect.dne)
		end
		local datk, dperc = effect.healATK, effect.healPerc
		local points = (datk and f32_pim(datk,su.atk) or 0) + (dperc and floor(dperc*tu.maxHP/100) or 0)
		if points > 0 then
			mu.mend(self, sourceIndex, targetIndex, points, causeTag, causeSID)
		end
	end
end
function mu:mend(sourceIndex, targetIndex, halfPoints, causeTag, causeSID)
	local board = self.board
	local tu = board[targetIndex]
	local cHP = tu.curHP
	if cHP > 0 then
		local points = floor(halfPoints)
		if points > 0 then
			local nhp, max, rHP = cHP + points, tu.maxHP, tu.hpR
			if nhp > max then
				local nr = rHP - nhp + max
				tu.curHP, tu.hpR = max, nr > 0 and nr or 0
			else
				tu.curHP = nhp
			end
			local tracer = self.trace
			if tracer then
				tracer(self, "HEAL", sourceIndex, targetIndex, points, cHP, causeTag, causeSID)
			end
		end
	end
end
function mu:unshroud(_sourceIndex, targetIndex)
	local tu = self.board[targetIndex]
	if tu then
		local ns = (tu.shroud or 0) - 1
		tu.shroud, self.ftc = ns > 0 and ns or nil, nil
	end
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
function mu:die(sourceIndex, deadIndex, causeTag, eDNE)
	local k, board, wasOver = deadIndex < 5 and "liveFriends" or "liveEnemies", self.board, self.over
	self[k], self.ftc = self[k] - 1, nil
	if self[k] == 0 and not self.over then
		self.over, self.dne = true, eDNE or nil
		if causeTag ~= "Thorn" and sourceIndex ~= deadIndex and self.won == nil then
			self.won = deadIndex > 4
		end
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
	if (causeTag == "Thorn" or deadIndex == sourceIndex) and self.over and not wasOver then
		self.overnext, self.over = self.turn, nil
	end
	if causeTag ~= "Thorn" then
		local duw = du.deathUnwind
		for i=1, duw and #duw or 0 do
			local q = duw[i]
			mu[q[1]](self, unpack(q,2))
		end
	end
end
function mu:passive(source, sid)
	local board = self.board
	local si, su = SpellInfo[sid], board[source]
	local onDeath = su.deathUnwind or {}
	local mdd, mdt, tatk = si.modDamageDealt, si.modDamageTaken, si.thornsATK
	local td = tatk and f32_pim(tatk, su.atk)
	local tt = VS.GetTargets(source, si.target, board)
	for i=1,#tt do
		i = tt[i]
		local tu = board[i]
		if mdd then
			mu.modDamageDealt(self, source, i, mdd, sid)
			onDeath[#onDeath+1] = {"unstackf32", source, i, "modDamageDealt", mdd}
		end
		if mdt then
			mu.modDamageTaken(self, source, i, mdt, sid)
			onDeath[#onDeath+1] = {"unstackf32", source, i, "modDamageTaken", mdt}
		end
		if td then
			tu.thornsDamage = tu.thornsDamage + td
			tu.thornsSID = tu.thornsSID or sid
			onDeath[#onDeath+1] = {"statDelta", source, i, "thornsDamage", -td}
		end
	end
	su.deathUnwind = onDeath
end
function mu:aura0(sourceIndex, targetIndex, _targetSeq, _ord, si, sid, _eid)
	local board = self.board
	local su = board[sourceIndex]
	local firstTick = not si.period and not si.noFirstTick
	local d1, d2, h2 = si.damageATK1, firstTick and si.damageATK, firstTick and si.healATK
	local ec = (d1 and 1 or 0) + (d2 and 1 or 0) + (h2 and 1 or 0)
	local sATK = su.atk
	if ec == 1 then
		if d1 then
			mu.damage(self, sourceIndex, targetIndex, f32_pim(d1, sATK), "EFirst", sid)
		elseif d2 then
			mu.damage(self, sourceIndex, targetIndex, f32_pim(d2, sATK), si.nore and "Tick" or "EFront", sid)
		else
			mu.mend(self, sourceIndex, targetIndex, f32_pim(h2, sATK), "EFront", sid)
		end
	elseif ec > 0 then
		local sq, sqh = self.sq, self.sqh-1
		if h2 then
			sqh, sq[sqh] = sqh-1, {"mend", sourceIndex, targetIndex, f32_pim(h2, sATK), "EFront", sid}
		end
		if d2 then
			sqh, sq[sqh] = sqh-1, {"damage", sourceIndex, targetIndex, f32_pim(d2, sATK), (si.nore or d1) and "Tick" or "EFront", sid}
		end
		if d1 then
			sqh, sq[sqh] = sqh-1, {"damage", sourceIndex, targetIndex, f32_pim(d1, sATK), "EFirst", sid}
		end
		self.sqh = sqh+1
	end
end
function mu:aura(sourceIndex, targetIndex, targetSeq, ord, si, sid, eid)
	local board = self.board
	local su, tu = board[sourceIndex], board[targetIndex]
	if tu.curHP <= 0 then
		return
	end
	local period, duration = si.period, si.duration
	local mdd, mdt = si.modDamageDealt, si.modDamageTaken
	local pdda, pdta, thornsa = si.plusDamageDealtATK, si.plusDamageTakenATK, si.thornsATK
	local thornsp = thornsa and f32_pim(thornsa, tu.atk)
	local hasDamage, hasHeal = si.damageATK or si.damagePerc, si.healATK or si.healPerc
	local modHPP, modHPA = si.modMaxHP, si.modMaxHPATK
	local pdd, pdt = pdda and f32_fpim(pdda, su.atk) or si.plusDamageDealtA, pdta and f32_fpim(pdta, su.atk) or si.plusDamageTakenA
	local ordt, ordf, fadeTurn = ord-1e6+targetSeq, ord-8e5, self.turn+duration
	if mdd then
		mu.modDamageDealt(self, sourceIndex, targetIndex, mdd, sid)
		enq(self.queue, fadeTurn, {"unstackf32", sourceIndex, targetIndex, "modDamageDealt", mdd, ord=ordf})
	end
	if mdt then
		mu.modDamageTaken(self, sourceIndex, targetIndex, mdt, sid)
		enq(self.queue, fadeTurn, {"unstackf32", sourceIndex, targetIndex, "modDamageTaken", mdt, ord=ordf})
	end
	if pdd then
		tu.plusDamageDealt = tu.plusDamageDealt + pdd
		enq(self.queue, fadeTurn, {"statDelta", sourceIndex, targetIndex, "plusDamageDealt", -pdd, ord=ordf})
	end
	if pdt then
		tu.plusDamageTaken = tu.plusDamageTaken + pdt
		enq(self.queue, fadeTurn, {"statDelta", sourceIndex, targetIndex, "plusDamageTaken", -pdt, ord=ordf})
	end
	if modHPP or modHPA then
		local d = (modHPP and f32_pim(modHPP, tu.maxHP) or 0) + (modHPA and f32_pim(modHPA, su.atk) or 0)
		tu.curHP, tu.maxHP = tu.curHP+d, tu.maxHP+d
		enq(self.queue, fadeTurn, {"statDelta", sourceIndex, targetIndex, "maxHP", -d, ord=ordf})
	end
	if thornsp then
		tu.thornsDamage = tu.thornsDamage + thornsp
		tu.thornsSID = tu.thornsSID or sid
		enq(self.queue, fadeTurn, {"statDelta", sourceIndex, targetIndex, "thornsDamage", -thornsp, ord=ordf})
	end
	if hasDamage or hasHeal then
		local tb = fadeTurn-duration-1
		if period == 2 then
			for j=3,duration+1,2 do
				enq(self.queue, tb+j, {"dtick", sourceIndex, targetIndex, sid, eid, "Effect", sid, ord=ordt})
			end
		else
			for j=2,duration do
				enq(self.queue, tb+j, {"dtick", sourceIndex, targetIndex, sid, eid, "Effect", sid, ord=ordt})
			end
		end
	end
	if si.echo then
		enq(self.queue, self.turn+si.echo, {"damage", sourceIndex, targetIndex, f32_pim(si.damageATK, su.atk), "EEcho", sid, ord=ordt})
	end
end
function mu:nuke(sourceIndex, targetIndex, targetSeq, ord, si, sid, _eid)
	local board = self.board
	local su, tu = board[sourceIndex], board[targetIndex]
	local sATK, datk, dperc, echo = su.atk, si.damageATK, si.damagePerc, si.echo
	local points = (datk and f32_pim(datk, sATK) or 0) + (dperc and floor(dperc*tu.maxHP/100) or 0)
	local causeTag = si.nore and "Tick" or "Spell"
	mu.damage(self, sourceIndex, targetIndex, points, causeTag, sid)
	if tu.curHP > 0 and echo then
		enq(self.queue, self.turn+echo, {"damage", sourceIndex, targetIndex, points, "Tick", sid, ord=ord-1e6+targetSeq})
	end
end
function mu:nukem(sourceIndex, targetIndex, _targetSeq, _ord, si, sid, _eid)
	local su = self.board[sourceIndex]
	local sATK, d = su.atk, si.damageATK
	local sq, sqh = self.sq, self.sqh-1
	for j=#d, 1, -1 do
		sq[sqh], sqh = {"damage", sourceIndex, targetIndex, f32_pim(d[j], sATK), "Spell", sid}, sqh - 1
	end
	self.sqh = sqh+1
end
function mu:heal(sourceIndex, targetIndex, _targetSeq, ord, si, sid, _eid)
	local board = self.board
	local su, tu = board[sourceIndex], board[targetIndex]
	local hPerc, hatk = si.healPercent, si.healATK
	local points = (hatk and f32_pim(hatk, su.atk) or 0) + (hPerc and floor(hPerc*tu.maxHP/100) or 0)
	mu.mend(self, sourceIndex, targetIndex, points, "Spell", sid)
	if si.shroudTurns then
		tu.shroud, self.ftc = (tu.shroud or 0) + 1, nil
		enq(self.queue, self.turn+si.shroudTurns, {"unshroud", sourceIndex, targetIndex, ord=ord-80})
	end
end
function mu:taunt(sourceIndex, targetIndex, _targetSeq, ord, si, sid, _eid)
	local tu = self.board[targetIndex]
	tu.taunt = sourceIndex
	enq(self.queue, self.turn+si.duration, {"untaunt", sourceIndex, targetIndex, sid, ord=ord-8e5})
end
function mu:cast(sourceIndex, sid, recast, qe)
	local board = self.board
	local su = board[sourceIndex]
	if su.curHP <= 0 and sourceIndex >= 0 then
		return
	elseif self.overnext then
		self.over, self.overnext = true
		return
	end
	local si, ord = SpellInfo[sid], (qe.ord or 0)+recast*40
	if si.type == "passive" then
		return mu.passive(self, sourceIndex, sid)
	else
		local checkCast = mu.CheckCast(self,sourceIndex,sid)
		if checkCast then
			--cast success,enqueue after recast(cooldown) turn
			enqc(self.queue, self.turn+recast, {"cast", sourceIndex, sid, recast, ord=ord, ord0=qe.ord0})
			return mu.qcast(self, sourceIndex, sid, si[1] and 1 or 0, ord-1)
		else
			--cast fail,enqueue next turn
			enqc(self.queue, self.turn+1, {"cast", sourceIndex, sid, recast, ord=ord, ord0=qe.ord0})
			return
		end
	end
	--return mu.qcast(self, sourceIndex, sid, si[1] and 1 or 0, ord-1)
end
function mu:CheckCast(sourceIndex,sid)
	local spellInfo,board = SpellInfo[sid], self.board
	--only heal spell with single effect needs to be check
	if spellInfo == nil or spellInfo[1] ~= nil or spellInfo.type ~= "heal" then
		return true
	end
	local targets = VS.GetTargets(sourceIndex, spellInfo.target, board)
	local cast = false
	for i=1,targets and #targets or 0 do
		local targetUnit = board[targets[i]]
		if targetUnit.curHP > 0 and targetUnit.curHP < targetUnit.maxHP then
			cast = true
			break
		end
	end
	return cast
end
function mu:qcast(sourceIndex, sid, eid, ord1, forkTarget)
	local si, board = SpellInfo[sid], self.board
	local ne = #si
	for i=eid, ne do
		local si = si[i] or si
		local sitt, tt = si.target
		local ft = forkTargets[sitt]
		if ft and forkTarget then
			tt = VS.GetTargets(forkTarget, "self", board)
		elseif ft then
			local pileOn = band(self.ftc or 0, forkTargetBits[ft]) > 0 and self["ft-" .. ft]
			pileOn = pileOn and VS.GetTargets(pileOn, "self", board)
			if pileOn and pileOn[1] then
				tt = pileOn
			else
				tt = VS.GetTargets(sourceIndex, ft, board)
				if #tt > 1 then
					local oracle = self.forkOracle
					local ownTarget = oracle and oracle(self.turn, sourceIndex, sid) or tt[math.random(#tt)]
					for i=1,#tt do
						if tt[i] == ownTarget then
							tt[1], tt[i] = tt[i], tt[1]
							break
						end
					end
					for j=2,#tt do
						local f = self:Clone()
						if not f then
							break
						end
						local sqh = f.sqh-1
						f.sq[sqh], f.sqh = {"qcast", sourceIndex, sid, i, ord1, tt[j]}, sqh
					end
				end
				tt = tt[1] and VS.GetTargets(tt[1], "self", board)
			end
		else
			tt = VS.GetTargets(sourceIndex, sitt, board)
		end
		if ft then
			self.ftc, self["ft-"..ft] = bor(self.ftc or 0, tt and tt[1] and forkTargetBits[ft] or 0), tt and tt[1] or nil
		end
		
		local et, sq, sqt, ordi = si.type, self.sq, self.sqt, ord1+i
		for ti=1,tt and #tt or 0 do
			local targetIndex = tt[ti]
			if et == "aura" then
				sqt = sqt + 1
				sq[sqt] = {"aura0", sourceIndex, targetIndex, ti, ordi, si, sid, i}
			end
			sqt = sqt + 1
			sq[sqt] = {et, sourceIndex, targetIndex, ti, ordi, si, sid, i}
		end
		if et == "nuke" and si.selfhealATK then
			sqt = sqt + 1
			sq[sqt] = {"mend", sourceIndex, sourceIndex, f32_pim(si.selfhealATK, board[sourceIndex].atk), "DHeal", sid}
		end
		self.sqt = sqt
	end
end

local function resolveRange(bFirst, b, f, bh, bl, fh, fl)
	if bFirst then
		if bh < fh then
			f.curHP, f.hpR = bh, bh-fl
		end
		if fl > bl then
			b.hpR = bh-fl
		end
	else
		if fh <= bh then
			b.curHP, b.hpR = fh - 1, fh - 1 - bl
		end
		if fl <= bl then
			f.hpR = fh - bl - 1
		end
	end
end
local function resolveDeath(board, a, b, inOrder)
	if not inOrder then
		a, b = b, a
	end
	local abit, bbit = 2^a, 2^b
	local lo, au, bu = a < 5, board[a], board[b]
	au.drB, au.drC = bor(au.drB, bbit, bu.drC), bor(au.drC, bbit, bu.drC)
	bu.drB, bu.drA = bor(bu.drB, abit, au.drA), bor(bu.drA, abit, au.drA)
	local aA, bC, aC, maxAA = au.drA, bu.drC, au.drC, 0
	for i=lo and 0 or 5, lo and 4 or 12 do
		local iu, ibit = board[i], 2^i
		if iu and iu.curHP == 0 then
			if band(aA, ibit) then
				iu.drB, iu.drC = bor(iu.drB, bC), bor(iu.drC, bC)
				maxAA = iu.deathSeq > maxAA and iu.deathSeq or maxAA
			elseif band(bC, ibit) then
				iu.drB, iu.drA = bor(iu.drB, aA), bor(iu.drA, aA)
			end
		end
	end
	maxAA = maxAA+1
	au.deathSeq = maxAA
	for i=lo and 0 or 5, lo and 4 or 12 do
		local iu, ibit = board[i], 2^i
		if i ~= a and iu and iu.curHP == 0 and (iu.deathSeq >= maxAA or band(aC, ibit) > 0) then
			iu.deathSeq = maxAA + iu.deathSeq
		end
	end
end
local function prepareDeath(self, turn, du, deadIndex)
	local dside, masks, horizon = deadIndex < 5
	for k,v in pairs(self.queue) do
		if k >= turn then
			local fim, fom, dtm = 0,0,0
			for i=1,#v do
				local vi = v[i]
				if vi[2] == deadIndex then
					local mt, tar, ex = vi[1], vi[3], vi[4]
					local tside = tar < 5
					if tside == dside and (mt == "unstackf32" and ex == "modDamageDealt" or mt == "statDelta" and ex == "plusDamageDealt") then
						fom = bor(fom, 2^tar)
					elseif tside ~= dside and (mt == "unstackf32" and ex == "modDamageTaken" or mt == "statDelta" and ex == "plusDamageTaken") then
						fim = bor(fim, 2^tar)
					elseif (mt == "damage" or mt == "dtick") then
						dtm = bor(dtm, 2^tar)
					end
				end
			end
			if fim > 0 or fom > 0 or dtm > 0 then
				masks = masks or {}
				masks[3*k] = fim > 0 and fim or nil
				masks[3*k+1] = fom > 0 and fom or nil
				masks[3*k+2] = dtm > 0 and dtm or nil
				horizon = horizon and horizon > k and horizon or k
			end
		end
	end
	du.dmasks, du.dhorizon, du.drA, du.drB, du.drC = masks, horizon, 0, 0, 0
end
local function prepareTurn(self)
	local board, turn = self.board, self.turn
	
	local mlive = 0
	for b=0,12 do
		local e = board[b]
		if e and e.curHP > 0 then
			mlive = mlive + 2^b
		elseif e and not e.drA then
			prepareDeath(self, turn, e, b)
		end
	end

	local t3, pm, oracle, skip = turn*3, band(self.pmask, mlive), self.firstHitOracle, self.saoSkip or 0
	for b=0, 12 do
		local e = board[b]
		local bh = e and e.curHP
		local bl = bh and (bh-e.hpR)
		local bd = bh == 0 and (e.dhorizon or 0) >= turn
		for i=b+1,bh and (b<5 and 4 or 12) or 0 do
			local f = board[i]
			local fh = f and f.curHP
			local fl = fh and (fh-f.hpR)
			local fd = fh == 0 and (f.dhorizon or 0) >= turn
			if skip >= (16*b+i) then
			elseif fh and fh > 0 and bh > 0 and not (bl >= fh or fl > bh) then
				local bFirst = oracle and oracle(turn, b, i)
				if bFirst == nil and oracle then
				else
					if bFirst == nil then
						bFirst = math.random(2) == 1
					end
					local fc, fb = self:Clone()
					if fc then
						fc.turn, fb, fc.saoSkip = turn-1, fc.board, b*16+i
						resolveRange(not bFirst, fb[b], fb[i], bh, bl, fh, fl)
					end
					resolveRange(bFirst, e, f, bh, bl, fh, fl)
				end
			elseif bd and fd and band(e.drB, 2^i) == 0 then
				local bm, fm, bbit, fbit = e.dmasks, f.dmasks, 2^b, 2^i
				local bfi, bfo, bdt = bm[t3], bm[t3+1], bm[t3+2]
				local ffi, ffo, fdt = fm[t3], fm[t3+1], fm[t3+2]
				bdt, fdt = bdt and band(bdt, mlive) or 0, fdt and band(fdt, mlive) or 0
				if bdt > 0 and (ffi and band(ffi, bdt) > 0 or ffo and band(ffo, bbit) > 0) or
				   fdt > 0 and (bfi and band(bfi, fdt) > 0 or bfo and band(bfo, fbit) > 0) or
				   bdt > 0 and fdt > 0 and pm > 0 and (band(bdt, pm) > 0 or band(fdt, pm) > 0)
				   then
					local bFirst = oracle and oracle(turn, b, i)
					if bFirst == nil then
						bFirst = math.random(2) == 1
					end
					local fc = self:Clone()
					if fc then
						fc.turn, fc.saoSkip = turn-1, b*16+i
						resolveDeath(fc.board, b, i, not bFirst)
					end
					resolveDeath(board, b, i, bFirst)
				end
			end
		end
	end
	self.saoSkip = nil
end
local function sortAttackOrder(self, q)
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
local function registerTraceResult(self, stopCB)
	local prime = self.prime or self
	local ch = self.checkpoints
	if ch[#ch] == ch[#ch-1] then
		ch[#ch] = nil
	end
	for _, a in pairs(self.queue) do
		for _, qi in pairs(a) do
			if qi[1] == "statDelta" then
				mu[qi[1]](self, unpack(qi, 2))
			end
		end
	end
	self.over, self.queue, self.sq, self.sqh, self.sqt = "r", nil
	if self.won == nil then
		self.won = self.liveFriends > 0
	end
	local tHP1, tHP2, ns, res, inf = 0, 0, 0, prime.res, math.huge
	local wHP1, wHP2, wmask = 0,0, self.wmask or 31
	res[self.won and "hadWins" or "hadLosses"] = true
	res.n = res.n + 1
	res.isFinished = res.n > #(prime.forks or "")
	for i=0,12 do
		local e = self.board[i]
		if e then
			local hp1, hp2 = e.curHP-e.hpR, e.curHP
			tHP1, tHP2, ns = tHP1 + hp1, tHP2 + hp2, ns + (e.curHP > 0 and 1 or 0)
			if wmask and band(wmask, 2^i) > 0 then
				wHP1, wHP2 = wHP1 + hp1, wHP2 + hp2
			end
			res.min[i] = math.min(res.min[i] or inf, hp1)
			res.max[i] = math.max(res.max[i] or 0, hp2)
		end
		if i == 4 or i == 12 then
			local o = i == 4 and 12 or 14
			res.min[o+1], res.max[o+1] = math.min(tHP1, res.min[o+1] or inf), math.max(tHP2, res.max[o+1] or 0)
			res.min[o+2], res.max[o+2] = math.min(ns, res.min[o+2] or inf), math.max(ns, res.max[o+2] or 0)
			tHP1, tHP2, ns = 0, 0, 0
		end
	end
	res.min[17] = math.min(res.min[17] or inf, self.turn)
	res.max[17] = math.max(res.max[17] or 0, self.turn)
	res.min[18] = math.min(res.min[18] or inf, wHP1)
	res.max[18] = math.max(res.max[18] or 0, wHP2)
	if self.forkID and self.dropForks then
		self.forks[self.forkID] = not not self.won
	end
	if stopCB and self.forks and #self.forks >= res.n and stopCB(prime, res.n, 1+#self.forks, self) then
		return true
	end
end
local function storeShallowCopy(r, s)
	local d = {}
	for k,v in pairs(s) do
		d[k] = v
	end
	r[s] = d
end

function VSI:Turn()
	local sq, sqh, q, turn = self.sq, self.sqh
	if self.unfinishedTurn then
		turn = self.turn
		q = self.queue[turn]
		while sqh <= self.sqt do
			local e = sq[sqh]
			self.sqh, sq[sqh] = sqh + 1
			mu[e[1]](self, unpack(e, 2))
			sqh = self.sqh
		end
	else
		turn = self.turn + 1
		q, self.turn = self.queue[turn], turn
		prepareTurn(self)
		sortAttackOrder(self, q)
		self.unfinishedTurn = true
	end
	local qi, at
	for i=#q, 1, -1 do
		qi, q[i] = q[i], nil
		at = qi[1]
		mu[at](self, unpack(qi, 2))
		sqh = self.sqh
		while sqh <= self.sqt do
			local e = sq[sqh]
			self.sqh, sq[sqh] = sqh + 1
			mu[e[1]](self, unpack(e, 2))
			sqh = self.sqh
		end
		if self.over then
			if self.dne then
				self.dne = nil
			else
				for j=i-1,1,-1 do
					if q[j][2] == qi[2] and q[j][1] == "statDelta" then
						qi, q[j] = q[j], nil
						mu[qi[1]](self, unpack(qi, 2))
						break
					end
				end
				break
			end
		end
	end
	if self.overnext and self.overnext < turn then
		self.over, self.overnext = true
	end
	self.checkpoints[turn] = self:CheckpointBoard()
	self.queue[turn], self.unfinishedTurn = next(q) and q, nil
end
function VSI:Run(stopCB)
	if self.over ~= "r" then
		if self.unfinishedTurn then
			self:Turn()
		end
		while not self.over do
			self:Turn()
			if stopCB and self.turn % 100 == 0 and not self.over and stopCB(self.prime or self) then
				return true
			end
		end
		if registerTraceResult(self, stopCB) then
			return true
		end
	end
	if self.forks and not self.prime then
		local i, forks = self.res.n, self.forks
		while i <= #forks do
			if forks[i]:Run(stopCB) then
				return true
			end
			i = i + 1
		end
	end
end
function VSI:CheckpointBoard()
	local board = self.board
	local c = ""
	for i=0,12 do
		local b = board[i]
		if b and b.curHP > 0 then
			local r = b.hpR
			c = (c ~= "" and c .. "_" or "") .. slotHex[i] .. ":" .. b.curHP .. (r > 0 and "-" .. r or "")
		end
	end
	return c
end
function VSI:Clone()
	local lim, forks = self.forkLimit, self.forks
	if lim and lim <= (forks and #forks or 0) then
		self.res.hadDrops = true
		return
	elseif forks == nil then
		forks = {[0]=self}
	end
	local n = setmetatable({}, VSIm)
	local q, r, s, d = {}, {[self]=n}, self, n
	self.forks, forks[#forks+1] = forks, n
	r[self.prime or 0], r[self.res or 0], r[forks] = self.prime, self.res, forks
	r[0] = nil
	if s.sq then
		storeShallowCopy(r, s.sq)
	end
	if s.queue then
		for _, v in pairs(s.queue) do
			storeShallowCopy(r, v)
		end
	end
	while s do
		q[s] = nil
		for k,v in pairs(s) do
			if r[k] then
				k = r[k]
			elseif type(k) == "table" then
				r[k] = {}
				q[k], k = r[k], r[k]
			end
			if r[v] then
				v = r[v]
			elseif type(v) == "table" then
				r[v] = {}
				q[v], v = r[v], r[v]
			end
			d[k] = v
		end
		q[s] = nil
		s, d = next(q)
	end
	n.prime, n.forkID, n.forkOracle = self.prime or self, #forks
	return n
end
function VSI:AddFightLogOracles(log)
	function self.forkOracle(turn, source, spell)
		local la = log[turn]
		la = la and la.events
		for i=1,la and #la or 0 do
			local li = la[i]
			if li.spellID == spell and li.casterBoardIndex == source and (li.type < 5 or li.type == 7) and li.targetInfo[1] then
				return li.targetInfo[1].boardIndex
			end
		end
	end
	function self.finalHitOracle(turn, source, target, sid, _oldHP, _oldRange)
		local la = log[turn]
		la = la and la.events
		for i=1,la and #la or 0 do
			local li = la[i]
			if li.type == 9 and li.casterBoardIndex == source and li.spellID == sid then
				local tt = li.targetInfo
				for j=1,tt and #tt or 0 do
					if tt[j].boardIndex == target then
						return false
					end
				end
			end
		end
		return true
	end
	function self.firstHitOracle(turn, a, b)
		local la = log[turn]
		la = la and la.events
		for i=1,la and #la or 0 do
			local li = la[i]
			local c, t = li.casterBoardIndex, li.type
			if t == 9 then
				local tt = li.targetInfo
				for i=1,tt and #tt or 0 do
					local di = tt[i].boardIndex
					if di == a or di == b then
						return nil
					end
				end
			elseif (c == a or c == b) then
				local si = SpellInfo[li.spellID]
				if (t == 7 or not (si and si.thornsATK)) and (t ~= 8 or not (si and si.type == "passive"))  then
					return c == a
				end
			end
		end
	end
end

local function addActorProps(a)
	a.modDamageTaken = 1
	a.modDamageDealt = 1
	a.modDamageTakenH = 1
	a.modDamageDealtH = 1
	a.plusDamageTaken = 0
	a.plusDamageDealt = 0
	a.thornsDamage = 0
	a.hpR = 0
	a.stacks = {}
	return a
end
local function addCasts(q, slot, spells, aa, missingSpells, pmask)
	for i=1,#spells do
		local s = spells[i]
		local sid = s.autoCombatSpellID
		local si = SpellInfo[sid]
		if not si then
			missingSpells = missingSpells or {}
			missingSpells[sid] = 1
		elseif si.type ~= "nop" then
			local qe = {"cast", slot, sid, 1+s.cooldown}
			if si.type == "passive" then
				qe.ord0, qe.ord = 0, slot*1e3 + i*10
				pmask = si.modDamageTaken and bor(pmask, 2^slot) or pmask
			else
				qe.ord = (1+slot)*1e7 + 5e6 + i*1e5
			end
			enqc(q, si.firstTurn or 1, qe)
		end
	end
	enqc(q, 1, {"cast", slot, aa, 1, ord=(1+slot)*1e7 + 5e6})
	return missingSpells, pmask
end
function VS:New(team, encounters, envSpell, mid, mscalar, forkLimit)
	local q, board, nf, pmask, missingSpells = {}, {}, 0, 0
	for slot, f in pairs(team) do
		if f.stats then
			f.attack, f.health, f.maxHealth = f.stats.attack, f.stats.currentHealth, f.stats.maxHealth
		end
		local rf, sa = {maxHP=f.maxHealth, curHP=math.max(1,f.health), atk=f.attack, slot=f.boardIndex or slot, name=f.name}, f.spells
		local aa = VS:GetAutoAttack(f.role, nil, nil, sa and sa[1] and sa[1].autoCombatSpellID)
		missingSpells, pmask = addCasts(q, rf.slot, sa, aa, missingSpells, pmask)
		board[rf.slot], nf = addActorProps(rf), nf + 1
	end
	for i=1,#encounters do
		local e = encounters[i]
		local rf, sa = {maxHP=e.maxHealth, curHP=e.maxHealth, atk=e.attack, slot=e.boardIndex}, e.autoCombatSpells
		local aa = VS:GetAutoAttack(e.role, rf.slot, mid, e.autoCombatAutoAttack and e.autoCombatAutoAttack.autoCombatSpellID)
		missingSpells, pmask = addCasts(q, rf.slot, sa, aa, missingSpells, pmask)
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
		enqc(q, esi.firstTurn or 1, {"cast", -1, environmentSID, 1+envSpell.cooldown, ord=0})
	end
	
	local boardOrder = {}
	for b=0,12 do
		local e = board[b]
		if e then
			boardOrder[1+#boardOrder] = b
		end
	end
	
	local ii = setmetatable({
		board=board, turn=0, queue=q, sq={}, sqh=1, sqt=0,
		liveFriends=nf, liveEnemies=#encounters, over=nf == 0,
		checkpoints={}, boardOrder=boardOrder, bom={[-1]=14},
		res={min={}, max={}, hadWins=false, hadLosses=false, hadDrops=false, isFinished=false, n=0},
		pmask=pmask,
		forkLimit=forkLimit,
	}, VSIm)
	ii.checkpoints[0] = ii:CheckpointBoard()
	if ii.over then
		registerTraceResult(ii)
	end
	return ii, missingSpells
end
function VS:SetSpellInfo(t)
	SpellInfo = t
end

T.VSim, VS.VSI, VS.mu = VS, VSI, mu