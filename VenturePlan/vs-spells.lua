local _, T = ...

T.KnownSpells = {
	[4]={type="nukem", target=0, damageATK={75, 50}},
	[5]={type="nuke", target="all-enemies", damageATK=10},
	[6]={type="nuke", target="enemy-back", damageATK=60},
	[7]={type="nuke", target=0, damageATK=10},
	[9]={type="heal", target="all-allies", healPercent=5},
	[10]={
		{type="nuke", target=0, damagePerc=20},
		{type="aura", target="all-enemies", duration=4, damagePerc=3, noFirstTick=true, dne=true},
		{type="aura", target=4, healPerc=1, duration=4, noFirstTick=true},
	},
	[11]={type="nuke", target=0, damageATK=100},
	[12]={type="heal", target="all-allies", healATK=20},
	[15]={type="nuke", target=1, damageATK=100},
	[16]={type="nuke", target=1, damageATK=75},
	[17]={type="nuke", target="all-enemies", damageATK=10, selfhealATK=100},
	[18]={type="nukem", target="enemy-front", damageATK={20, 20, 20}},
	[19]={type="nuke", target=0, damageATK=150},
	[20]={type="nuke", target="enemy-back", damageATK=70},
	[21]={type="aura", target="all-allies", healATK=25, duration=5, noFirstTick=true},
	[22]={type="aura", target="cleave", duration=3, damageATK=10, damageATK1=90, noFirstTick=true},
	[24]={
		{type="nuke", target=1, damageATK=180},
		{type="heal", target=3, healATK=20},
	},
	[25]={
		{type="nuke", target="enemy-front", damageATK=50},
		{type="aura", target=4, modDamageDealt=20, duration=3},
	},
	[26]={
		{type="heal", target=3, healATK=100},
		{type="aura", target=3, duration=2, modMaxHPATK=20},
	},
	[43]={type="nuke", target=1, damageATK=25, selfhealATK=20},
	[44]={type="nukem", target=0, damageATK={50, 25}},
	[45]={type="nuke", target=1, damageATK=75, selfhealATK=25},
	[46]={
		{type="aura", target=4, modDamageTaken=-10, duration=1},
		{type="aura", target="friend-back-hard", modDamageTaken=-10, duration=1},
	},
	[47]={type="passive", target="all-allies", modDamageTaken=-20},
	[48]={type="heal", target=4, healATK=20, shroudTurns=1},
	[49]={type="aura", target="enemy-back", modDamageTaken=33, duration=4},
	[50]={type="nuke", target=1, damageATK=120},
	[51]={type="nuke", target="enemy-front", damageATK=75},
	[52]={type="nuke", target="enemy-back", damageATK=30},
	[53]={type="aura", target="all-enemies", duration=6, period=2, modDamageDealt=-20, damageATK=10},
	[54]={
		{type="nuke", target=0, damageATK=90},
		{type="nuke", target=1, damageATK=90},
	},
	[55]={type="nuke", target="enemy-front", damageATK=150},
	[56]={type="nuke", target=1, damageATK=125},
	[57]={type="aura", target=0, duration=4, damageATK=100, noFirstTick=true},
	[58]={type="nuke", target="cleave", damageATK=70},
	[59]={type="nuke", target="enemy-back", damageATK=50},
	[60]={type="nuke", target=1, damageATK=40},
	[61]={type="nuke", target=0, damageATK=75},
	[62]={type="nuke", target="enemy-front", damageATK=30},
	[63]={type="aura", target="all-enemies", modDamageDealt=-20, duration=2, damageATK1=60},
	[64]={type="nuke", target="all-enemies", damageATK=150},
	[66]={type="nuke", target="col", damageATK=150},
	[71]={type="heal", target=3, healATK=100},
	[72]={
		{type="nuke", target=0, damageATK=200},
		{type="nuke", target="enemy-back", damageATK=40},
	},
	[73]={type="nuke", target="col", damageATK=100},
	[74]={type="aura", target=4, duration=3, modDamageTaken=-40, modDamageDealt=-40},
	[75]={type="nuke", target=1, damageATK=150},
	[76]={type="nuke", target=1, damageATK=225},
	[77]={type="aura", target="all-allies", duration=3, plusDamageDealtATK=20},
	[78]={type="nuke", target="enemy-front", damageATK=30},
	[79]={
		{type="nuke", target="all-enemies", damageATK=20},
		{type="heal", target="all-allies", healATK=20},
	},
	[80]={type="aura", target=1, duration=3, damageATK1=120, damageATK=40, noFirstTick=true},
	[81]={type="aura", target=4, duration=3, thornsATK=100},
	[82]={type="passive", target=4, thornsATK=25},
	[83]={type="nuke", target="cleave", damageATK=120},
	[84]={type="aura", target="all-enemies", duration=2, firstTurn=4, modDamageDealt=-100},
	[85]={type="aura", target=3, duration=2, firstTurn=3, modDamageTaken=-5000},
	[87]={type="nuke", target="enemy-back", damageATK=60},
	[88]={
		{type="aura", target=4, modDamageDealt=30, duration=3},
		{type="nuke", target="all-enemies", damageATK=40}
	},
	[89]={type="aura", target=1, duration=3, damageATK=40, nore=true},
	[90]={type="passive", target="friend-surround", modDamageDealt=20},
	[91]={type="aura", target=1, duration=3, plusDamageDealtATK=-60},
	[92]={type="aura", target="enemy-back", duration=3, damageATK=50, nore=true},
	[93]={
		{type="nuke", target=0, damageATK=20},
		{type="heal", target=4, healATK=80},
	},
	[94]={type="aura", target="enemy-front", duration=4, damageATK=30, noFirstTick=true},
	[95]={
		{type="nuke", target=1, damageATK=150},
		{type="nuke", target="enemy-back", damageATK=40},
	},
	[96]={type="aura", target=1, duration=2, damageATK1=60, modDamageDealt=-30},
	[97]={type="nuke", target="cone", damageATK=90},
	[98]={type="nuke", target=1, damageATK=120},
	[99]={type="nuke", target="enemy-front", damageATK=140},
	[100]={type="heal", target=4, healATK=60},
	[101]={type="aura", target=0, damageATK1=60, duration=3, modDamageTaken=20},
	[102]={type="nuke", target="col", damageATK=30},
	[103]={type="aura", target="all-other-allies", modDamageDealt=100, duration=2},
	[104]={
		{type="heal", target=3, healATK=100},
		{type="aura", target=3, modDamageDealt=-10, duration=1},
	},
	[105]={type="passive", target="all-allies", modDamageTaken=-10},
	[106]={type="nuke", target="cleave", damageATK=40},
	[107]={
		{type="aura", target=0, duration=4, damageATK=150, nore=true},
		{type="aura", target=0, duration=3, plusDamageTakenATK=50},
	}, -- Volatile Solvent
	[108]={
		{type="heal", target=3, healATK=40},
		{type="aura", target=3, modMaxHP=10, duration=2},
	},
	[109]={type="passive", target=4, thornsATK=60},
	[110]={type="heal", target=4, healATK=40},
	[111]={type="nuke", target="enemy-front", damageATK=100},
	[112]={type="aura", target="friend-surround", duration=3, plusDamageDealtATK=30},
	[113]={type="nuke", target="cone", damageATK=120},
	[114]={type="heal", target=4, healATK=100},
	[115]={type="nuke", target="cleave", damageATK=70},
	[116]={type="nuke", target=0, damageATK=120},
	[117]={type="nuke", target="enemy-front", damageATK=40},
	[118]={type="nuke", target=1, damageATK=200, firstTurn=4},
	[119]={type="nuke", target="cone", damageATK=100},
	[120]={type="aura", target="random-enemy", modDamageDealt=50, duration=2},
	[121]={type="aura", target="all-enemies", modDamageDealt=-50, duration=1},
	[122]={type="nop"},
	[123]={type="heal", target="friend-front-soft", healATK=30},
	[124]={type="nuke", target="cleave", damageATK=60},
	[125]={type="nuke", target="random-enemy", damageATK=60},
	[126]={type="heal", target="friend-front-soft", healATK=20},
	[127]={type="nuke", target="enemy-front", damageATK=60},
	[128]={type="nuke", target="enemy-back", damageATK=75},
	[130]={type="aura", target=4, duration=3, thornsATK=100},
	[131]={type="nuke", target="enemy-back", damageATK=150},
	[132]={type="aura", target="enemy-front", damageATK1=50, duration=1, modDamageDealt=-25},
	[133]={type="nuke", target="enemy-back", damageATK=100, selfhealATK=75},
	[134]={type="aura", target="all-enemies", duration=2, modDamageTaken=25},
	[135]={type="nuke", target="enemy-back", damageATK=300},
	[136]={type="aura", target=0, duration=0, damageATK=150, noFirstTick=true, echo=3},
	[137]={type="aura", target=4, duration=2, modDamageDealt=25},
	[138]={type="nuke", target="cleave", damageATK=30},
	[139]={type="nuke", target="enemy-back", damageATK=400, firstTurn=6},
	[140]={type="aura", target="enemy-back", damageATK1=60, duration=2, modDamageDealt=-10},
	[141]={type="aura", target="all-allies", duration=2, modDamageTaken=-50},
	[143]={type="aura", target=4, modDamageDealt=25, duration=2},
	[144]={type="aura", target="all-other-allies", modDamageTaken=-75, duration=2, firstTurn=4},
	[145]={type="nuke", target=0, damageATK=75},
	[146]={type="nuke", target=1, damageATK=75},
	[147]={type="aura", target="all-other-allies", modDamageTaken=-50, duration=2},
	[148]={type="heal", target="friend-front-soft", healATK=125},
	[149]={type="nuke", target="enemy-front", damageATK=75},
	[150]={type="nuke", target="cone", damageATK=50},
	[151]={type="nuke", target=0, damageATK=20},
	[152]={type="aura", target="all-other-allies", healATK=200, duration=1, firstTurn=5, modDamageDealt=50},
	[153]={type="nuke", target="cone", damageATK=75},
	[154]={type="aura", target=4, duration=3, thornsATK=100},
	[155]={type="aura", target="all-enemies", duration=1, modDamageDealt=-75},
	[156]={type="aura", target="all-enemies", modDamageTaken=40, duration=2},
	[157]={type="nuke", target="cleave", damageATK=80},
	[158]={type="nuke", target="enemy-back", firstTurn=3, damageATK=300},
	[159]={type="aura", target="all-enemies", modDamageDealt=-25, duration=2},
	[160]={type="nuke", target="all-enemies", damageATK=200},
	[161]={
		{type="heal", target="all-allies", healATK=100},
		{type="aura", target="all-allies", duration=1, modDamageDealt=25},
	},
	[162]={type="aura", target="all-enemies", duration=2, modDamageDealt=-50},
	[163]={type="nuke", target="all-enemies", damageATK=400, firstTurn=6},
	[164]={type="nuke", target="cone", damageATK=200, echo=3, nore=true},
	[165]={type="nuke", target=0, damageATK=300},
	[166]={type="nuke", target="random-ally", damageATK=100, selfhealATK=50},
	[167]={type="nuke", target=1, damageATK=150},
	[168]={type="aura", target=0, modDamageDealt=-50, duration=2},
	[169]={type="aura", target=0, damageATK=50, damageATK1=65, duration=1, echo=3},
	[170]={type="nuke", target="enemy-front", damageATK=60},
	[171]={type="nuke", target=1, damageATK=100},
	[172]={type="aura", target="enemy-front", firstTurn=3, duration=1, modDamageDealt=-50, damageATK1=20},
	[173]={type="aura", target=1, modDamageDealt=-25, duration=2, damageATK1=75},
	[174]={type="aura", target=4, duration=3, thornsATK=40},
	[175]={type="nuke", target="random-all", damageATK=120},
	[176]={type="aura", target="all-enemies", duration=1, modDamageTaken=25},
	[177]={type="nuke", target=0, damageATK=50},
	[178]={type="nuke", target=1, damageATK=100, selfhealATK=50},
	[179]={
		{type="heal", target="all-allies", healATK=100},
		{type="aura", target="all-allies", duration=2, modDamageDealt=50},
	},
	[180]={type="nuke", target="random-enemy", damageATK=75},
	[181]={type="nuke", target="enemy-back", damageATK=150, firstTurn=6},
	[182]={type="aura", target="all-enemies", duration=2, modDamageDealt=-50},
	[183]={type="nuke", target="enemy-front", damageATK=50},
	[184]={type="nuke", target="cone", damageATK=75},
	[185]={type="nuke", target="all-enemies", damageATK=100},
	[186]={type="nuke", target="enemy-front", firstTurn=5, damageATK=200},
	[187]={type="nuke", target="all-enemies", echo=2, damageATK=50, nore=true},
	[188]={type="aura", target=0, duration=1, damageATK1=50, modDamageDealt=-50},
	[189]={type="nuke", target=0, damageATK=200},
	[190]={type="nuke", target="enemy-front", damageATK=150},
	[191]={
		{type="nuke", target="all-enemies", damageATK=100},
		{type="heal", target="all-allies", healATK=100},
	},
	[192]={type="nuke", target=1, damageATK=160},
	[193]={
		{type="nuke", target="enemy-front", damageATK=300},
		{type="nuke", target=4, damageATK=50}
	},
	[194]={
		{type="aura", target=3, duration=2, plusDamageDealtATK=40, modDamageTaken=-20},
		{type="nuke", target=4, damageATK=20},
	},
	[195]={type="aura", target="cone", duration=3, damageATK=80, nore=true},
	[196]={type="nukem", target=0, damageATK={120, 90, 60, 30}},
	[197]={type="heal", target="friend-surround", healATK=55},
	[198]={type="aura", target=4, duration=2, thornsATK=60, plusDamageTakenATK=-60},
	[199]={type="nuke", target="enemy-front", damageATK=100},
	[200]={type="aura", target="enemy-front", duration=1, damageATK=100, modDamageDealt=-50},
	[201]={type="nuke", target="enemy-back", damageATK=200},
	[202]={type="taunt", target="all-enemies", duration=2},
	[203]={type="nuke", target="enemy-front", damageATK=100},
	[204]={type="aura", target=0, damageATK1=150, modDamageDealt=-50, duration=2},
	[205]={type="heal", target="friend-front-soft", healATK=75},
	[206]={type="nuke", target=0, damageATK=150},
	[207]={type="nuke", target=0, damageATK=30},
	[208]={type="nop"},
	[209]={type="aura", target="random-ally", modDamageDealt=50, duration=1},
	[210]={type="nuke", target="all-enemies", damageATK=200},
	[211]={type="nuke", target="cone", damageATK=150},
	[212]={type="nuke", target="random-all", damageATK=200},
	[213]={type="heal", target=3, healATK=100},
	[214]={type="nuke", target="cone", damageATK=100},
	[215]={type="nuke", target=0, damageATK=300},
	[216]={type="heal", target=4, shroudTurns=2},
	[217]={type="nuke", target="enemy-back", damageATK=200},
	[218]={type="aura", target=4, duration=2, modDamageTaken=-50},
	[219]={
		{type="heal", target=3, healATK=200},
		{type="aura", target=3, duration=2, modDamageTaken=-50},
	},
	[220]={type="nuke", target="enemy-front", damageATK=100},
	[221]={type="heal", target=4, shroudTurns=2},
	[222]={
		{type="nuke", target=0, damageATK=30},
		{type="nuke", target=0, echo=2, damageATK=30, nore=true},
	},
	[223]={type="aura", target="all-enemies", duration=11, noFirstTick=true, damageATK=10, cATKa=60, cATKb=2},
	[224]={type="nuke", target="enemy-front", damageATK=50},
	[225]={type="nuke", target="cone", damageATK=50},
	[226]={type="nuke", target="cone", damageATK=50},
	[227]={type="nuke", target="random-enemy", damagePerc=30},
	[228]={type="nuke", target="all-enemies", damageATK=1000, firstTurn=10, cATKa=500, cATKb=2},
	[229]={type="aura", target="random-ally", duration=2, modDamageTaken=-50},
	[230]={type="heal", target="all-allies", healATK=50, cATKa=50, cATKb=2},
	[231]={type="aura", target="random-enemy", modDamageTaken=100, duration=2},
	[232]={type="aura", target="random-enemy", duration=3, modDamageDealt=-50},
	[233]={type="nuke", target=0, damageATK=150},
	[234]={type="aura", target="random-ally", duration=2, modDamageDealt=50},
	[235]={type="nuke", target=1, damageATK=50},
	[236]={type="aura", target="all-allies", duration=2, modDamageTaken=-50},
	[237]={type="nuke", target="enemy-front", damageATK=50},
	[238]={type="taunt", target="all-enemies", duration=2},
	[239]={type="nuke", target="enemy-back", damageATK=50},
	[240]={type="nuke", target=0, damageATK=25},
	[241]={
		{type="nuke", target=1, damageATK=75},
		{type="aura", target=1, duration=2, modDamageDealt=-50},
	},
	[242]={
		{type="heal", target=3, healATK=50},
		{type="aura", target=3, duration=2, modDamageTaken=75},
	},
	[243]={
		{type="taunt", target="all-enemies", duration=2},
		{type="aura", target=4, duration=2, modDamageTaken=-50},
	},
	[244]={firstTurn=2,
		{type="aura", target=4, plusDamageDealtATK=200, plusDamageTakenATK=30, duration=2},
		{type="nuke", target=0, damageATK=30},
	},
	[245]={type="nuke", target=0, damageATK=120},
	[246]={type="nuke", target=0, damageATK=150},
	[247]={type="nuke", target=0, damageATK=10, selfhealATK=20, firstTurn=4},
	[248]={type="aura", target=0, damageATK=15, damageATK1=30, duration=5, noFirstTick=true},
	[249]={type="aura", target=0, damageATK1=60, duration=1, modDamageDealt=-50},
	[250]={type="nuke", target=1, damageATK=80, firstTurn=4},
	[251]={type="aura", target="all-enemies", modDamageDealt=-20, duration=2},
	[252]={type="aura", target="cleave", damageATK1=60, duration=2, modDamageTaken=25},
	[253]={type="nuke", target="enemy-front", damageATK=75},
	[254]={type="aura", target="all-other-allies", firstTurn=3, duration=3, thornsATK=100},
	[255]={type="aura", target=3, modDamageTaken=-50, duration=1},
	[256]={type="nuke", target="cone", damageATK=100},
	[257]={type="heal", target=4, shroudTurns=2},
	[258]={type="aura", target=0, damageATK=50, damageATK1=100, duration=1, echo=3},
	[259]={type="aura", target=0, duration=0, echo=3, noFirstTick=true, damageATK=30},
	[260]={type="nuke", target=1, damageATK=150},
	[261]={type="aura", target=3, modDamageDealt=50, duration=2},
	[262]={type="nuke", target="enemy-front", damageATK=100},
	[263]={type="nuke", target="cone", damageATK=100},
	[264]={type="nuke", target=1, damageATK=300},
	[265]={type="nuke", target=0, damageATK=100},
	[266]={type="nuke", target=0, damageATK=1000},
	[267]={type="nuke", target=1, damageATK=150},
	[268]={type="aura", target="enemy-front", duration=3, modDamageDealt=-30},
	[269]={type="nuke", target="enemy-front", damageATK=120},
	[270]={type="aura", target=0, duration=2, modDamageDealt=-50},
	[271]={type="aura", target=1, duration=4, noFirstTick=true, damageATK=100},
	[272]={type="nuke", target=1, damageATK=150},
	[274]={type="nuke", target="enemy-front", damageATK=120},
	[275]={type="aura", target=3, modDamageDealt=75, duration=2},
	[276]={type="aura", target=1, duration=1, damageATK1=25, damageATK=50, echo=3},
	[277]={type="aura", target=4, duration=2, modDamageDealt=100},
	[278]={type="aura", target=1, duration=2, modDamageTaken=50},
	[279]={type="nuke", target="enemy-back", damageATK=50},
	[280]={type="nuke", target="enemy-front", damageATK=250},
	[281]={type="nuke", target=1, damageATK=150},
	[282]={type="nuke", target=0, damageATK=1000, firstTurn=5},
	[283]={type="nuke", target=0, damageATK=75},
	[284]={type="aura", target="all-other-allies", duration=1, modDamageTaken=-50},
	[285]={type="aura", target="all-enemies", duration=2, firstTurn=4, modDamageTaken=50},
	[286]={type="aura", target=3, modDamageDealt=50, duration=2},
	[287]={type="aura", target=4, modDamageTaken=-50, duration=1},
	[288]={type="nuke", target="enemy-back", damageATK=60},
	[289]={type="nuke", target=1, echo=3, damageATK=100, nore=true},
	[290]={type="nuke", target=1, damageATK=150},
	[291]={type="nuke", target="enemy-front", damageATK=100},
	[292]={
		{type="aura", target=0, modDamageTaken=50, duration=2},
		{type="nuke", target=0, damageATK=75},
	},
	[294]={type="nuke", target=0, damageATK=200},
	[295]={type="aura", target=0, duration=2, modDamageTaken=50},
	[296]={type="nuke", target="enemy-back", damageATK=100, firstTurn=3},
	[297]={type="nuke", target=1, damageATK=100, selfhealATK=30},
	[298]={type="nuke", target="random-ally", damageATK=100, selfhealATK=30},
	[299]={type="nuke", target=1, damageATK=200},
	[300]={type="aura", target="all-enemies", duration=4, noFirstTick=true, damageATK=5, cATKa=10, cATKb=2},
	[301]={type="nuke", target="random-enemy", damagePerc=10},
	[302]={type="aura", target="all-enemies", duration=1, modDamageDealt=-20, damageATK1=20},
	[303]={type="nuke", target="enemy-back", damageATK=25},

	--New values for 9.1
	[305]={type="nuke", target="enemy-back", damageATK=120}, --Roots of Submission
	[306]={type="aura", target=3, duration=3, modMaxHP=60, plusDamageDealtATK=40}, --Arcane Empowerment (UNVERIFIED)
	[307]={type="nuke", target="cone", damageATK=160}, --Fist of Nature (UNVERIFIED)
	[308]={type="nuke", target=1, damageATK=350, firstTurn=3}, --Spore of Doom (UNVERIFIED)
	[309]={
        {type="heal", target="all-allies", healATK=200},
        {type="aura", target="all-allies", duration=1, modDamageDealt=30},
    }, --Threads of Fate (UNVERIFIED)
	[310]={
        {type="nuke", target=0, damageATK=140},
        {type="aura", target=4, duration=1, modDamageDealt=20},
    }, --Axe of Determination (UNVERIFIED)
	[311]={
        {type="heal", target=3, healATK=120},
        {type="aura", target=3, duration=2, modMaxHPATK=40},
    }, --Wings of Mending (UNVERIFIED)
	[312]={type="nuke", target="cone", damageATK=180}, --Panoptic Beam (UNVERIFIED)
	[313]={type="heal", target="all-allies", healATK=70}, --Spirit's Guidance (UNVERIFIED)
	[314]={
        {type="heal", target=3, healATK=130},
        {type="aura", target=3, duration=2, plusDamageDealtATK=50},
    }, --Purifying Light (UNVERIFIED)
	[315]={type="aura", target=1, damageATK1=150, duration=2, modDamageDealt=-30}, --Resounding Message (UNVERIFIED)
	[316]={type="nuke", target=0, damageATK=100, selfhealATK=30}, --Self Replication (UNVERIFIED)
    [317]={type="aura", target="enemy-front", duration=1, damageATK1=150, plusDamageTakenATK=30}, --Shocking Fist (UNVERIFIED)
    [318]={type="aura", target="all-allies", duration=3, plusDamageDealtATK=50}, --Inspiring Howl (UNVERIFIED)
    [319]={type="aura", target="enemy-front", duration=3, damageATK1=80, damageATK=50, noFirstTick=true}, --Shattering Blows (UNVERIFIED)
    [320]={type="nuke", target="enemy-back", damageATK=100}, --Hailstorm (UNVERIFIED)
    [321]={type="heal", target=3, healATK=200}, --Adjustment (UNVERIFIED)
    [322]={
		{type="nuke", target=0, damageATK=80, selfhealATK=80},
		{type="aura", target=4, duration=1, modMaxHPATK=80},
    }, --Balance In All Things (UNVERIFIED)
    [323]={
        {type="nuke", target="enemy-back", damageATK=40},
        {type="aura", target="enemy-back", duration=2, modDamageDealt=-10},
    }, --Anima Shatter (UNVERIFIED)
    [324]={type="heal", target="friend-surround", healATK=120}, --Protective Parasol (UNVERIFIED)
	[325]={type="aura", target="friend-surround", duration=2, modDamageDealt=60}, --Vision of Beauty
	[326]={type="nuke", target="cleave", damageATK=25}, --Shiftless Smash
	[327]={type="aura", target="all-other-allies", duration=3, plusDamageDealtATK=20}, --Inspirational Teachings
    [328]={type="nuke", target=0, damageATK=30}, --Applied Lesson
    [329]={type="aura", target=4, modDamageTaken=-50, duration=3}, --Muscle Up
    [330]={type="aura", target="all-allies", duration=2, plusDamageDealtATK=20}, --Oversight
	[331]={type="aura", target="all-other-allies", plusDamageDealtATK=20, duration=3}, --Supporting Fire (I'm not sure it's need duration 3)
    [332]={type="nuke", target=1, damageATK=150}, --Emptied Mug
    [333]={type="aura", target=4, duration=3, modDamageDealt=40}, --Overload
    [334]={type="nuke", target=0, damageATK=90}, --Hefty Package
    [335]={type="nuke", target="enemy-back", damageATK=40}, --Errant Package
    [336]={type="heal", target=3, healATK=80}, --Evidence of Wrongdoing
    [337]={type="aura", target=1, duration=4, damageATK1=200, damageATK=40, noFirstTick=true}, --Wavebender's Tide
    [338]={type="nuke", target=0, damageATK=50}, --Scallywag Slash
    [339]={type="nuke", target="all-enemies", damageATK=120, firstTurn=3}, --Cannon Barrage
	[340]={type="nuke", target=1, damageATK=60}, --Tainted Bite (UNVERIFIED)
	[341]={type="aura", target=1, damageATK1=120, duration=3, plusDamageTakenATK=20}, --Tainted Bite
	[342]={type="aura", target=0, duration=1, damageATK1=100, plusDamageDealtATK=-70}, --Regurgitated Meal
	[343]={
		{type="nuke", target="enemy-front", damageATK=80},
		{type="aura", target=4, duration=1, modDamageDealt=20},
	}, --Sharptooth Snarl
	[344]={type="nuke", target="all-enemies", damageATK=30}, --Razorwing Buffet
	[345]={type="aura", target="all-allies" , duration=3 , plusDamageTakenATK=-30}, --Protective Wings (Bugged in data maybe? Description wording applies modDamageDealt.)
    [346]={type="aura", target=0, duration=2, damageATK1=30, plusDamageDealtATK=1}, --Heel Bite (BUGGED: Should be modDamageDealt=-1. It isn't.)
    [347]={type="nuke", target="cone", damageATK=100}, --Darkness from Above
    [348]={
		{type="nuke", target=1, damageATK=120},
		{type="aura", target=1, duration=3, plusDamageTakenATK=20},
	}, --Tainted Bite
	[349]={type="nuke", target="all-enemies", damageATK=10}, --Anima Swell
}