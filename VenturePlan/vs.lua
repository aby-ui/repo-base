local T, SpellInfo = select(2, ...), {
	[4]={h="nukem", t=0, dp={75, 50}},
	[5]={h="nuke", t="all-enemies", dp=10},
	[6]={h="nuke", t="enemy-back", dp=60},
	[7]={h="nuke", t=0, dp=10},
	[9]={h="heal", t="all-allies", hh=5},
	[10]={
		{h="nuke", t=0, dh=20},
		{h="aura", t="all-enemies", d=4, p=1, dh=3, dne=true},
		{h="aura", t="self", d=4, p=1, hh=1},
	},
	[11]={h="nuke", t=0, dp=100},
	[12]={h="heal", t="all-allies", hp=20},
	[15]={h="nuke", t=1, dp=100},
	[16]={h="nuke", t=1, dp=75},
	[17]={h="nuke", t="all-enemies", dp=10, shp=100},
	[18]={h="nukem", t="enemy-front", dp={20, 20, 20}},
	[19]={h="nuke", t=0, dp=150},
	[20]={h="nuke", t="enemy-back", dp=70},
	[21]={h="aura", t="all-allies", d=5, p=1, hp=25},
	[22]={h="aura", t="cleave", d=3, p=1, dp=10, dp1=90},
	[24]={
		{h="nuke", t=1, dp=180},
		{h="heal", t=3, hp=20},
	},
	[25]={
		{h="nuke", t="enemy-front", dp=50},
		{h="aura", t="self", d=3, dom=20},
	},
	[26]={
		{h="heal", t=3, hp=100},
		{h="aura", t=3, d=2, ehp=20},
	},
	[43]={h="nuke", t=1, dp=25, shp=20},
	[44]={h="nukem", t=0, dp={50, 25}},
	[45]={h="nuke", t=1, dp=75, shp=25},
	[46]={
		{h="aura", t="self", d=1, dim=-10},
		{h="aura", t="friend-back-hard", d=1, dim=-10},
	},
	[47]={h="passive", t="all-allies", dim=-20},
	[48]={h="shroud", t="self", d=1, hp=20},
	[49]={h="aura", t="enemy-back", d=4, dim=33},
	[50]={h="nuke", t=1, dp=120},
	[51]={h="nuke", t="enemy-front", dp=75},
	[54]={
		{h="nuke", t=0, dp=90},
		{h="nuke", t=1, dp=90},
	},
	[55]={h="nuke", t="enemy-front", dp=150},
	[56]={h="nuke", t=1, dp=125},
	[57]={h="aura", t=0, d=4, p=1, dp=100},
	[58]={h="nuke", t="cleave", dp=70},
	[59]={h="nuke", t="enemy-back", dp=50},
	[60]={h="nuke", t=1, dp=40},
	[61]={h="nuke", t=0, dp=75},
	[62]={h="nuke", t="enemy-front", dp=30},
	[63]={h="aura", t="all-enemies", d=2, dom=-20, dp1=60},
	[64]={h="nuke", t="all-enemies", dp=150},
	[66]={h="nuke", t="col", dp=150},
	[71]={h="heal", t=3, hp=100},
	[72]={
		{h="nuke", t=0, dp=200},
		{h="nuke", t="enemy-back", dp=40},
	},
	[73]={h="nuke", t="col", dp=100},
	[74]={h="aura", t="self", d=3, dim=-40, dom=-40},
	[75]={h="nuke", t=1, dp=150},
	[76]={h="nuke", t=1, dp=225},
	[77]={h="aura", t="all-allies", d=3, dop=20},
	[78]={h="nuke", t="enemy-front", dp=30},
	[79]={
		{h="nuke", t="all-enemies", dp=20},
		{h="heal", t="all-allies", hp=20},
	},
	[80]={h="aura", t=1, d=3, p=1, dp=40, dp1=120},
	[81]={h="aura", t="self", d=3, thornp=100},
	[82]={h="passive", t="self", thornp=25},
	[83]={h="nuke", t="cleave", dp=120},
	[84]={h="aura", t="all-enemies", d=2, firstTurn=4, dom=-100},
	[85]={h="aura", t=3, d=2, dim=-50, firstTurn=3},
	[87]={h="nuke", t="enemy-back", dp=60},
	[88]={
		{h="aura", t="self", d=3, dom=30},
		{h="nuke", t="all-enemies", dp=40},
	},
	[89]={h="aura", t=1, d=3, dp=40},
	[90]={h="passive", t="friend-surround", dom=20},
	[91]={h="aura", t=1, d=3, dop=-60},
	[92]={h="aura", t="enemy-back", d=3, dp=50},
	[93]={h="nuke", t=0, dp=20, shp=80},
	[94]={h="aura", t="enemy-front", d=4, p=1, dp=30},
	[95]={
		{h="nuke", t=1, dp=150},
		{h="nuke", t="enemy-back", dp=40},
	},
	[96]={h="aura", t=1, d=2, dp1=60, dom=-30},
	[97]={h="nuke", t="cone", dp=90},
	[98]={h="nuke", t=1, dp=120},
	[99]={h="nuke", t="enemy-front", dp=140},
	[100]={h="heal", t="self", hp=60},
	[101]={h="aura", t=0, d=3, dim=20, dp1=60},
	[102]={h="nuke", t="col", dp=30},
	[103]={h="aura", t="all-other-allies", d=2, dom=100},
	[104]={
		{h="heal", t=3, hp=100},
		{h="aura", t=3, d=1, dom=-10},
	},
	[105]={h="passive", t="all-allies", dim=-10},
	[106]={h="nuke", t="cleave", dp=40},
	[107]={
		{h="aura", t=0, d=4, dp=150},
		{h="aura", t=0, d=3, dip=50},
	},
	[108]={
		{h="heal", t=3, hp=40},
		{h="aura", t=3, d=2, ehh=10},
	},
	[109]={h="passive", t="self", thornp=60},
	[110]={h="heal", t="self", hp=40},
	[111]={h="nuke", t="enemy-front", dp=100},
	[112]={h="aura", t="friend-surround", d=3, dop=30},
	[113]={h="nuke", t="cone", dp=120},
	[114]={h="heal", t="self", hp=100},
	[115]={h="nuke", t="cleave", dp=70},
	[116]={h="nuke", t=0, dp=120},
	[117]={h="nuke", t="enemy-front", dp=40},
	[118]={h="nuke", t=1, dp=200, firstTurn=4},
	[119]={h="nuke", t="cone", dp=100},
	[120]={h="aura", t="random-enemy", d=2, dom=50},
	[121]={h="aura", t="all-enemies", d=1, dom=-50},
	[122]={h="nop"},
	[123]={h="heal", t="friend-front-soft", hp=30},
	[124]={h="nuke", t="cleave", dp=60},
	[125]={h="aura", t="random-enemy", d=1, dp1=60, dom=-50},
	[126]={h="heal", t="friend-front-soft", hp=20},
	[127]={h="nuke", t="enemy-front", dp=60},
	[128]={h="nuke", t="enemy-back", dp=75},
	[130]={h="aura", t="self", d=3, thornp=100},
	[131]={h="nuke", t="enemy-back", dp=150},
	[132]={h="aura", t="enemy-front", d=1, dp1=50, dom=-25},
	[133]={h="nuke", t="enemy-back", dp=100, shp=75},
	[134]={h="aura", t="all-enemies", d=2, dim=25},
	[135]={h="nuke", t="enemy-back", dp=300},
	[136]={h="aura", t=0, d=0, p=1, e=3, dp=150},
	[137]={h="aura", t="self", d=2, dom=25},
	[138]={h="nuke", t="cleave", dp=30},
	[139]={h="nuke", t="enemy-back", dp=400, firstTurn=6},
	[140]={h="aura", t="enemy-back", d=2, dp1=60, dom=-10},
	[141]={h="aura", t="all-allies", d=2, dim=-50},
	[143]={h="aura", t="self", d=2, dom=25},
	[144]={h="aura", t="all-other-allies", d=2, dim=-75, firstTurn=4},
	[145]={h="nuke", t=0, dp=75},
	[146]={h="nuke", t=1, dp=75},
	[147]={h="aura", t="all-other-allies", d=2, dim=-50},
	[148]={h="heal", t="friend-front-soft", hp=125},
	[149]={h="nuke", t="enemy-front", dp=75},
	[150]={h="nuke", t="cone", dp=50},
	[151]={h="nuke", t=0, dp=20},
	[152]={firstTurn=5,
		{h="heal", t="all-other-allies", hp=200},
		{h="aura", t="all-other-allies", d=1, dom=50},
	},
	[153]={h="nuke", t="cone", dp=75},
	[154]={h="aura", t="self", d=3, thornp=100},
	[155]={h="aura", t="all-enemies", d=1, dom=-75},
	[156]={h="aura", t="all-enemies", d=2, dim=40},
	[157]={h="nuke", t="cleave", dp=80},
	[158]={h="nuke", t="enemy-back", dp=300, firstTurn=3},
	[159]={h="aura", t="all-enemies", d=2, dom=-25},
	[160]={h="nuke", t="all-enemies", dp=200},
	[161]={
		{h="heal", t="all-allies", hp=100},
		{h="aura", t="all-allies", d=1, dom=25},
	},
	[162]={h="aura", t="all-enemies", d=2, dom=-50},
	[163]={h="nuke", t="all-enemies", dp=400, firstTurn=6},
	[164]={h="aura", t="cone", d=0, e=3, dp=200},
	[165]={h="nuke", t=0, dp=300},
	[166]={h="nuke", t="random-ally", dp=100, shp=50},
	[167]={h="nuke", t=1, dp=150},
	[168]={h="aura", t=0, d=2, dom=-50},
	[169]={h="aura", t=0, d=0, e=3, dp=50, dp1=65},
	[170]={h="nuke", t="enemy-front", dp=60},
	[171]={h="nuke", t=1, dp=100},
	[172]={h="aura", t="enemy-front", d=1, firstTurn=3, dp1=20, dom=-50},
	[173]={h="aura", t=1, d=2, dom=-25, dp1=75},
	[174]={h="aura", t="self", d=3, thornp=40},
	[175]={h="nuke", t="random-all", dp=120},
	[176]={h="aura", t="all-enemies", d=1, dim=25},
	[177]={h="nuke", t=0, dp=50},
	[178]={h="nuke", t=1, dp=100, shp=50},
	[179]={
		{h="heal", t="all-allies", hp=100},
		{h="aura", t="all-allies", d=2, dom=50},
	},
	[180]={h="nuke", t="random-enemy", dp=75},
	[181]={h="nuke", t="enemy-back", dp=150, firstTurn=6},
	[182]={h="aura", t="all-enemies", d=2, dom=-50},
	[183]={h="nuke", t="enemy-front", dp=50},
	[184]={h="nuke", t="cone", dp=75},
	[185]={h="nuke", t="all-enemies", dp=100},
	[186]={h="nuke", t="enemy-front", dp=200, firstTurn=5},
	[187]={h="aura", t="all-enemies", d=0, e=2, dp=50},
	[188]={h="aura", t=0, d=1, dp1=50, dom=-50},
	[189]={h="nuke", t=0, dp=200},
	[190]={h="nuke", t="enemy-front", dp=150},
	[191]={
		{h="nuke", t="all-enemies", dp=100},
		{h="heal", t="all-allies", hp=100},
	},
	[192]={h="nuke", t=1, dp=160},
	[193]={
		{h="nuke", t="enemy-front", dp=300},
		{h="nuke", t="self", dp=50},
	},
	[194]={
		{h="aura", t=3, d=2, dop=40, dim=-20},
		{h="nuke", t="self", dp=20},
	},
	[195]={h="aura", t="cone", d=3, dp=80},
	[196]={h="nukem", t=0, dp={120, 90, 60, 30}},
	[197]={h="heal", t="friend-surround", hp=55},
	[198]={h="aura", t="self", d=2, dip=-60, thornp=60},
	[199]={h="nuke", t="enemy-front", dp=100},
	[200]={h="aura", t="enemy-front", d=1, dp1=100, dom=-50},
	[201]={h="nuke", t="enemy-back", dp=200},
	[202]={h="taunt", t="all-enemies", d=2},
	[203]={h="nuke", t="enemy-front", dp=100},
	[204]={h="aura", t=0, d=2, dp1=150, dom=-50},
	[205]={h="heal", t="friend-front-soft", hp=75},
	[206]={h="nuke", t=0, dp=150},
	[207]={h="nuke", t="col", dp=30},
	[208]={h="nop"},
	[209]={h="aura", t="random-ally", d=1, dom=50},
	[210]={h="nuke", t="all-enemies", dp=200},
	[211]={h="nuke", t="cone", dp=150},
	[212]={h="nuke", t="random-all", dp=200},
	[213]={h="heal", t=3, hp=100},
	[214]={h="nuke", t="cone", dp=100},
	[215]={h="nuke", t=0, dp=300},
	[216]={h="shroud", t="self", d=2},
	[217]={h="nuke", t="enemy-back", dp=200},
	[218]={h="aura", t="self", d=2, dim=-50},
	[219]={
		{h="heal", t=3, hp=200},
		{h="aura", t=3, d=2, dim=-50},
	},
	[220]={h="nuke", t="enemy-front", dp=100},
	[221]={h="shroud", t="self", d=2},
	[222]={h="aura", t=0, d=0, e=2, dp=30, dp1=30},
	[223]={h="aura", t="all-enemies", d=11, p=1, dp=10, cATKa=60, cATKb=2},
	[224]={h="nuke", t="enemy-front", dp=50},
	[225]={h="nuke", t="cone", dp=50},
	[226]={h="nuke", t="cone", dp=50},
	[227]={h="nuke", t="random-enemy", dh=30},
	[228]={h="nuke", t="all-enemies", dp=1000, firstTurn=10, cATKa=500, cATKb=2},
	[229]={h="aura", t="random-ally", d=2, dim=-50},
	[230]={h="heal", t="all-allies", hp=50, cATKa=50, cATKb=2},
	[231]={h="aura", t="random-enemy", d=2, dim=100},
	[232]={h="aura", t="random-enemy", d=3, dom=-50},
	[233]={h="nuke", t=0, dp=150},
	[234]={h="aura", t="random-ally", d=2, dom=50},
	[235]={h="nuke", t=1, dp=50},
	[236]={h="aura", t="all-allies", d=2, dim=-50},
	[237]={h="nuke", t="enemy-front", dp=50},
	[238]={h="taunt", t="all-enemies", d=2},
	[239]={h="nuke", t="enemy-back", dp=50},
	[240]={h="nuke", t="col", dp=25},
	[241]={h="aura", t=1, d=2, dp1=75, dom=-50},
	[242]={
		{h="heal", t=3, hp=50},
		{h="aura", t=3, d=2, dim=75},
	},
	[243]={
		{h="taunt", t="all-enemies", d=2},
		{h="aura", t="self", d=2, dim=-50},
	},
	[244]={firstTurn=2,
		{h="aura", t="self", d=2, dop=200, dip=30},
		{h="nuke", t=0, dp=30},
	},
	[245]={h="nuke", t=0, dp=120},
	[246]={h="nuke", t=0, dp=150},
	[247]={h="nuke", t=0, dp=10, firstTurn=4, shp=20},
	[248]={h="aura", t=0, d=5, p=1, dp=15, dp1=30},
	[249]={h="aura", t=0, d=1, dp1=60, dom=-50},
	[250]={h="nuke", t=1, dp=80, firstTurn=4},
	[251]={h="aura", t="all-enemies", d=2, dom=-20},
	[252]={h="aura", t="cleave", d=2, dim=25, dp1=60},
	[253]={h="nuke", t="enemy-front", dp=75},
	[254]={h="aura", t="all-other-allies", d=3, firstTurn=3, thornp=100},
	[255]={h="aura", t=3, d=1, dim=-50},
	[256]={h="nuke", t="cone", dp=100},
	[257]={h="shroud", t="self", d=2},
	[258]={h="aura", t=0, d=0, e=3, dp=50, dp1=100},
	[259]={h="aura", t=0, d=0, p=1, e=3, dp=30},
	[260]={h="nuke", t=1, dp=150},
	[261]={h="aura", t=3, d=2, dom=50},
	[262]={h="nuke", t="enemy-front", dp=100},
	[263]={h="nuke", t="cone", dp=100},
	[264]={h="nuke", t=1, dp=300},
	[265]={h="nuke", t="col", dp=100},
	[266]={h="nuke", t=0, dp=1000},
	[267]={h="nuke", t=1, dp=150},
	[268]={h="aura", t="enemy-front", d=3, dom=-30},
	[269]={h="nuke", t="enemy-front", dp=120},
	[270]={h="aura", t=0, d=2, dom=-50},
	[271]={h="aura", t=1, d=4, p=1, dp=100},
	[272]={h="nuke", t=1, dp=150},
	[274]={h="nuke", t="enemy-front", dp=120},
	[275]={h="aura", t=3, d=2, dom=75},
	[276]={h="aura", t=1, d=0, e=3, dp=50, dp1=25},
	[277]={h="aura", t="self", d=2, dom=100},
	[278]={h="aura", t=1, d=2, dim=50},
	[279]={h="nuke", t="enemy-back", dp=50},
	[280]={h="nuke", t="enemy-front", dp=250},
	[281]={h="nuke", t=1, dp=150},
	[282]={h="nuke", t=0, dp=1000, firstTurn=5},
	[283]={h="nuke", t="col", dp=75},
	[284]={h="aura", t="all-other-allies", d=1, dim=-50},
	[285]={h="aura", t="all-enemies", d=2, dim=50, firstTurn=4},
	[286]={h="aura", t=3, d=2, dom=50},
	[287]={h="aura", t="self", d=1, dim=-50},
	[288]={h="nuke", t="enemy-back", dp=60},
	[289]={h="aura", t=1, d=0, e=3, dp=100},
	[290]={h="nuke", t=1, dp=150},
	[291]={h="nuke", t="enemy-front", dp=100},
	[292]={
		{h="aura", t=0, d=2, dim=50},
		{h="nuke", t=0, dp=75},
	},
	[294]={h="nuke", t=0, dp=200},
	[295]={h="aura", t=0, d=2, dim=50},
	[296]={h="nuke", t="enemy-back", dp=100, firstTurn=3},
	[297]={h="nuke", t=1, dp=100, shp=30},
	[298]={h="nuke", t="random-ally", dp=100, shp=30},
	[299]={h="nuke", t=1, dp=200},
	[300]={h="aura", t="all-enemies", d=4, p=1, dp=5, cATKa=10, cATKb=2},
	[301]={h="nuke", t="random-enemy", dh=10},
	[302]={h="aura", t="all-enemies", d=1, dom=-20, dp1=20},
	[303]={h="nuke", t="enemy-back", dp=25},
	[305]={h="nuke", t="enemy-back", dp=120},
	[306]={
		{h="aura", t=3, d=3, dop=40},
		{h="aura", t=3, d=3, ehp=60},
	},
	[307]={h="nuke", t="cone", dp=160},
	[308]={h="nuke", t=1, dp=350, firstTurn=3},
	[309]={
		{h="heal", t="all-allies", hp=200},
		{h="aura", t="all-allies", d=1, dom=30},
	},
	[310]={
		{h="nuke", t=0, dp=140},
		{h="aura", t="self", d=2, dom=20},
	},
	[311]={
		{h="heal", t=3, hp=120},
		{h="aura", t=3, d=2, ehp=40},
	},
	[312]={h="nuke", t="cone", dp=180},
	[313]={h="heal", t="all-allies", hp=70},
	[314]={
		{h="heal", t=3, hp=130},
		{h="aura", t=3, d=2, dop=50},
	},
	[315]={h="aura", t=1, d=2, dp1=150, dom=-30},
	[316]={h="nuke", t=0, dp=100, shp=30},
	[317]={h="aura", t="enemy-front", d=1, dp1=150, dip=30},
	[318]={h="aura", t="all-allies", d=3, dop=50},
	[319]={h="aura", t="enemy-front", d=4, p=1, dp=50, dp1=80},
	[320]={h="nuke", t="enemy-back", dp=100},
	[321]={h="heal", t=3, hp=200},
	[322]={
		{h="nuke", t=0, dp=80, shp=80},
		{h="aura", t="self", d=1, ehp=80},
	},
	[323]={h="aura", t="enemy-back", d=2, dp1=40, dom=-10},
	[324]={h="heal", t="friend-surround", hp=120},
	[325]={h="aura", t="friend-surround", d=2, dom=60},
	[326]={h="nuke", t="cleave", dp=25},
	[327]={h="aura", t="all-other-allies", d=3, dop=20},
	[328]={h="nuke", t=0, dp=30},
	[329]={h="aura", t="self", d=3, dim=-50},
	[330]={h="aura", t="all-allies", d=2, dop=20},
	[331]={h="aura", t="all-other-allies", d=3, dop=20},
	[332]={h="nuke", t=1, dp=150},
	[333]={h="aura", t="self", d=3, dop=40},
	[334]={h="nuke", t=0, dp=90},
	[335]={h="nuke", t="enemy-back", dp=40},
	[336]={h="heal", t=3, hp=80},
	[337]={h="aura", t=1, d=4, p=1, dp=40, dp1=200},
	[338]={h="nuke", t=0, dp=50},
	[339]={h="nuke", t="all-enemies", dp=120, firstTurn=3},
	[340]={h="nuke", t=1, dp=60},
	[341]={h="aura", t=1, d=3, dp1=120, dip=20},
	[342]={h="aura", t=0, d=1, dop=-70, dp1=100},
	[343]={
		{h="nuke", t="enemy-front", dp=80},
		{h="aura", t="self", d=1, dom=20},
	},
	[344]={h="nuke", t="all-enemies", dp=30},
	[345]={h="aura", t="all-allies", d=3, dip=-30},
	[346]={h="aura", t=0, d=2, dop=1, dp1=30},
	[347]={h="nuke", t="cone", dp=100},
	[348]={h="aura", t=1, d=3, dp1=120, dip=20},
	[349]={h="nuke", t="all-enemies", dp=10},
	[350]={h="nuke", t="cleave", dp=25},
	[351]={h="nuke", t=1, dp=75, firstTurn=4},
	[352]={h="nop", t="self", dim=30},
	[353]={h="nop"},
	[354]={h="nuke", t="enemy-front", dp=400, firstTurn=5},
	[355]={h="passive", t=1, dom=-25},
	[356]={h="nuke", t=1, dp=100},
	[357]={h="passive", t=0, dom=-50},
	[358]={h="nuke", t="enemy-front", dp=400, firstTurn=5},
	[359]={h="aura", t=1, d=0, p=1, e=3, dp=50},
	[360]={h="nuke", t="enemy-front", dp=50},
	[361]={h="nuke", t="enemy-front", dp=75},
	[362]={h="nuke", t=1, dp=120},
	[363]={h="aura", t="friend-front-soft", d=2, dom=10},
	[364]={h="taunt", t="all-enemies", d=2},
	[365]={h="aura", t=0, d=1, dim=50},
	[366]={h="nuke", t="enemy-front", dp=50},
	[367]={h="nuke", t="cone", dp=75},
	[368]={h="nuke", t=1, dp=60},
	[369]={h="aura", t="all-enemies", d=0, p=1, e=2, dp=50},
	[370]={h="aura", t="all-enemies", d=2, dom=-50},
	[371]={h="aura", t="all-other-allies", d=2, dim=-25},
	[372]={h="nuke", t="enemy-front", dp=40},
	[373]={h="nuke", t=1, dp=100, shp=100},
	[374]={h="nuke", t=1, dp=100, shp=40},
	[375]={h="aura", t="all-enemies", d=2, dom=-20},
}

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
local forkTargetBits = {["all-enemies"]=1, ["all-allies"]=2, ["all"]=4}
do -- VS.GetTargets
	local th, stt = {}, {}
	local function clean(t, ni)
		for i=#t,ni,-1 do
			t[i] = nil
		end
		return t
	end
	local nearTargetList do -- 013
		local targetLists = {
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
				"56789abc", "5a7b69c8", "6bac7589", "7689abc5",
				"5a968b7c", "96b57a8c", "a78c69b5", "7c568ab9"
			},
		}
		local function getTargetListTarget(source, tt, board)
			local ni, su, tl = 1, board[source], targetLists[tt][source]
			for i=1,#tl do
				local t = tl[i]
				local tu = board[t]
				if tu and tu.curHP > 0 and not tu.shroud then
					stt[ni], ni = source < 5 and t > 4 and su and su.taunt or t, ni + 1
					break
				end
			end
			return clean(stt, ni)
		end
		for k, m in pairs(targetLists) do
			for o, t in pairs(m) do
				local r = {}
				for i=1,#t do
					r[i] = tonumber(t:sub(i,i), 16)
				end
				m[o] = r
			end
			th[k] = getTargetListTarget
		end
		nearTargetList = targetLists[0]
	end
	th["all-enemies"] = function(source, _, board)
		local ni, lo = 1, source < 5 and source >= 0
		for i=lo and 5 or 0, lo and 12 or 4 do
			local tu = board[i]
			if tu and tu.curHP > 0 and not tu.shroud then
				stt[ni], ni = i, ni + 1
			end
		end
		return clean(stt, ni)
	end
	th["all-other-allies"] = function(source, _, board)
		local ni, lo = 1, source < 5 and source >= 0
		for i=lo and 0 or 5, lo and 4 or 12 do
			local tu = board[i]
			if i ~= source and tu and tu.curHP > 0 then
				stt[ni], ni = i, ni + 1
			end
		end
		return clean(stt, ni)
	end
	th["all-allies"] = function(source, _, board)
		local ni, lo = 1, source < 5 and source >= 0
		for i=lo and 0 or 5, lo and 4 or 12 do
			local tu = board[i]
			if tu and tu.curHP > 0 then
				stt[ni], ni = i, ni + 1
			end
		end
		return clean(stt, ni)
	end
	th["all"] = function(_, _, board)
		local ni = 1
		for i=0,12 do
			local tu = board[i]
			if tu and tu.curHP > 0 and not tu.shroud then
				stt[ni], ni = i, ni + 1
			end
		end
		return clean(stt, ni)
	end
	do -- cone
		local coneCleave = {
			[0x20]=1, [0x30]=1, [0x31]=1, [0x41]=1,
			[0x59]=1, [0x5a]=1,
			[0x69]=1, [0x6a]=1, [0x6b]=1,
			[0x7a]=1, [0x7b]=1, [0x7c]=1,
			[0x8b]=1, [0x8c]=1,
		}
		th["cone"] = function(source, _, board)
			local ni, su, ot = 1, board[source]
			local taunt, tl = su and su.taunt, nearTargetList[source]
			for i=1, #tl do
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
				local f, lo = stt[1]*16, source < 5
				for i=lo and 5 or 0, lo and 12 or 4 do
					if coneCleave[f+i] then
						local tu = board[i]
						if tu and tu.curHP > 0 and not tu.shroud then
							stt[ni], ni = i, ni + 1
						end
					end
				end
			end
			return clean(stt, ni)
		end
	end
	do -- cleave
		local adjCleave = {
			[0x50]=3, [0x51]=4, [0x62]=3, [0x63]=2, [0x82]=0, [0x83]=1, [0x91]=4,
			[0xa3]=2, [0xb2]=3, [0xb0]=1, [0xb4]=3, [0xc0]=1, [0xc3]=4,
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
		th["cleave"] = function(source, _, board)
			local ni, su = 1, board[source]
			local taunt = su and su.taunt
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
				th[0](source, 0, board)
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
			return clean(stt, ni)
		end
	end
	th["col"] = function(source, _, board)
		th[0](source, 0, board)
		local ni = #stt + 1
		local ex = source < 5 and ni == 2 and (stt[1]+4) or nil
		local exu = board[ex]
		if exu and exu.curHP > 0 and not exu.shroud then
			stt[2], ni = ex, ni + 1
		end
		return clean(stt, ni)
	end
	th["enemy-front"] = function(source, _, board)
		local ni, lo, su = 1, source < 5, board[source]
		local br, taunt = lo and 8 or 2, su and su.taunt
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
		return clean(stt, ni)
	end
	th["enemy-back"] = function(source, _, board)
		local ni, lo, su = 1, source < 5, board[source]
		local br, taunt = lo and 9 or 1, su and su.taunt
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
		return clean(stt, ni)
	end
	th["friend-back"] = function(source, tt, board)
		local ni, lo = 1, source < 5
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
		return clean(stt, ni)
	end
	th["friend-front"] = function(source, tt, board)
		local ni, lo = 1, source < 5
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
		return clean(stt, ni)
	end
	do -- friend-surround
		local friendSurround = {
			[0x01]=1, [0x02]=1, [0x03]=1,
			[0x10]=1, [0x13]=1, [0x14]=1,
			[0x20]=1, [0x23]=1,
			[0x30]=1, [0x31]=1, [0x32]=1, [0x34]=1,
			[0x41]=1, [0x43]=1,
		}
		th["friend-surround"] = function(source, _, board)
			local ni, f = 1, source*16
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
					return th["all-allies"](source, "all-allies", board)
				end
			end
			return clean(stt, ni)
		end
	end
	th["self"] = function(source, _, _)
		stt[1] = source
		return clean(stt, 2)
	end
	-- Despite this, these are not identical.
	th["friend-back-hard"] = th["friend-back"]
	th["friend-back-soft"] = th["friend-back"]
	th["friend-front-hard"] = th["friend-front"]
	th["friend-front-soft"] = th["friend-front"]

	VS.forkTargetMap = forkTargets
	function VS.GetTargets(source, tt, board)
		return th[tt](source, tt, board)
	end
end

local function shallowCopy(s)
	if s == nil then return nil end
	local d = {}
	for k,v in pairs(s) do
		d[k] = v
	end
	return d
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
local function addMaskCount(x, mask, count)
	local nm = bor(mask, 2^x)
	return nm, count + (nm ~= mask and 1 or 0)
end
local function zeroHealthRanges(board, hrMask, _hrCount)
	local m, t = 2, 1
	for s=0,12 do
		if hrMask % m >= t then
			board[s].hpR = 0
		end
		m, t = m+m, m
	end
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
function mu:damage(sourceIndex, targetIndex, baseDamage, causeTag, causeSID, eDNE)
	local board = self.board
	local tu, su = board[targetIndex], board[sourceIndex]
	local tHP, rHP = tu.curHP, tu.hpR
	if tHP <= 0 then
		return
	end
	local su_mdd, tu_mdt, su_hmdd, tu_hmdt = su.dom, tu.dim
	if su_mdd then
		su_hmdd = su.domH
	else
		su_mdd, su_hmdd = f32_sr(su.stacks.dom)
		su.dom, su.domH = su_mdd, su_hmdd
	end
	if tu_mdt then
		tu_hmdt = tu.dimH
	else
		tu_mdt, tu_hmdt = f32_sr(tu.stacks.dim)
		tu.dim, tu.dimH = tu_mdt, tu_hmdt
	end
	if (su_mdd < 0) ~= (tu_mdt < 0) then
		tu_mdt, tu_hmdt = tu_hmdt, tu_mdt
	end
	local bp, pdd, pdt = floor(baseDamage), su.doa, tu.dia
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
						local thorns = tu.thornd
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
	local thorns = tu.thornd
	if thorns > 0 and causeTag ~= "Tick" and causeTag ~= "Thorn" and causeTag ~= "EEcho" then
		mu.damage(self, targetIndex, sourceIndex, thorns, "Thorn", tu.thornsSID)
	end
end
function mu:dtick(sourceIndex, targetIndex, esid, eeid, causeTag, causeSID)
	local board = self.board
	local tu, su = board[targetIndex], board[sourceIndex]
	if tu.curHP > 0 then
		local effect = eeid ~= 0 and SpellInfo[esid][eeid] or SpellInfo[esid]
		local datk, dperc = effect.dp, effect.dh
		local points = (datk and f32_pim(datk,su.atk) or 0) + (dperc and floor(dperc*tu.maxHP/100) or 0)
		if points > 0 then
			mu.damage(self, sourceIndex, targetIndex, points, "Tick", causeSID, effect.dne)
		end
		local hatk, hperc = effect.hp, effect.hh
		local points = (hatk and f32_pim(hatk,su.atk) or 0) + (hperc and floor(hperc*tu.maxHP/100) or 0)
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
	du.deathSeq, du.deathTurn = ds + 1, self.turn
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
	local mdd, mdt, tatk = si.dom, si.dim, si.thornp
	local td = tatk and f32_pim(tatk, su.atk)
	local tt = VS.GetTargets(source, si.t, board)
	for i=1,#tt do
		i = tt[i]
		local tu = board[i]
		if mdd then
			mu.stackf32(self, source, i, "dom", mdd, sid)
			onDeath[#onDeath+1] = {"unstackf32", source, i, "dom", mdd}
		end
		if mdt then
			mu.stackf32(self, source, i, "dim", mdt, sid)
			onDeath[#onDeath+1] = {"unstackf32", source, i, "dim", mdt}
		end
		if td then
			tu.thornd = tu.thornd + td
			tu.thornsSID = tu.thornsSID or sid
			onDeath[#onDeath+1] = {"statDelta", source, i, "thornd", -td}
		end
	end
	su.deathUnwind = onDeath
end
function mu:aura0(sourceIndex, targetIndex, _targetSeq, _ord, si, sid, _eid)
	local firstTick = not si.p
	local d1, d2, h2 = si.dp1, firstTick and si.dp, firstTick and si.hp
	if not (d1 or d2 or h2) then return end
	
	local sATK, ec = self.board[sourceIndex].atk, (d1 and 1 or 0) + (d2 and 1 or 0) + (h2 and 1 or 0)
	if ec > 1 then
		local sq, sqh = self.sq, self.sqh-1
		if h2 then
			sqh, sq[sqh] = sqh-1, {"mend", sourceIndex, targetIndex, f32_pim(h2, sATK), "Spell", sid}
		end
		if d2 then
			sqh, sq[sqh] = sqh-1, {"damage", sourceIndex, targetIndex, f32_pim(d2, sATK), "Tick", sid}
		end
		if d1 then
			sqh, sq[sqh] = sqh-1, {"damage", sourceIndex, targetIndex, f32_pim(d1, sATK), "Spell", sid}
		end
		self.sqh = sqh+1
	elseif d1 then
		mu.damage(self, sourceIndex, targetIndex, f32_pim(d1, sATK), "Spell", sid)
	elseif d2 then
		mu.damage(self, sourceIndex, targetIndex, f32_pim(d2, sATK), "Tick", sid)
	else
		mu.mend(self, sourceIndex, targetIndex, f32_pim(h2, sATK), "Tick", sid)
	end
end
function mu:aura(sourceIndex, targetIndex, targetSeq, ord, si, sid, eid)
	local board = self.board
	local su, tu = board[sourceIndex], board[targetIndex]
	if tu.curHP <= 0 then
		return
	end
	local duration, dom, dim, dop, dip, thornp, ehh, ehp = si.d, si.dom, si.dim, si.dop, si.dip, si.thornp, si.ehh, si.ehp
	local hasDamage, hasHeal = si.dp or si.dh, si.hp or si.hh
	local ordt, ordf, fadeTurn = ord-1e6+targetSeq, ord-8e5, self.turn+duration
	if dom then
		mu.stackf32(self, sourceIndex, targetIndex, "dom", dom, sid)
		enq(self.queue, fadeTurn, {"unstackf32", sourceIndex, targetIndex, "dom", dom, ord=ordf})
	end
	if dim then
		mu.stackf32(self, sourceIndex, targetIndex, "dim", dim, sid)
		enq(self.queue, fadeTurn, {"unstackf32", sourceIndex, targetIndex, "dim", dim, ord=ordf})
	end
	if dop then
		local d = f32_fpim(dop, su.atk)
		tu.doa = tu.doa + d
		enq(self.queue, fadeTurn, {"statDelta", sourceIndex, targetIndex, "doa", -d, ord=ordf})
	end
	if dip then
		local d = f32_fpim(dip, su.atk)
		tu.dia = tu.dia + d
		enq(self.queue, fadeTurn, {"statDelta", sourceIndex, targetIndex, "dia", -d, ord=ordf})
	end
	if ehh or ehp then
		local d = (ehh and f32_pim(ehh, tu.maxHP) or 0) + (ehp and f32_pim(ehp, su.atk) or 0)
		tu.curHP, tu.maxHP = tu.curHP+d, tu.maxHP+d
		enq(self.queue, fadeTurn, {"statDelta", sourceIndex, targetIndex, "maxHP", -d, ord=ordf})
	end
	if thornp then
		local d = f32_pim(thornp, tu.atk)
		tu.thornd, tu.thornsSID = tu.thornd + d, tu.thornsSID or sid
		enq(self.queue, fadeTurn, {"statDelta", sourceIndex, targetIndex, "thornd", -d, ord=ordf})
	end
	if hasDamage or hasHeal then
		local tb = fadeTurn-duration-1
		for j=2,duration do
			enq(self.queue, tb+j, {"dtick", sourceIndex, targetIndex, sid, eid, "Effect", sid, ord=ordt})
		end
	end
	if si.e then
		enq(self.queue, self.turn+si.e, {"damage", sourceIndex, targetIndex, f32_pim(si.dp, su.atk), "EEcho", sid, ord=ordt})
	end
end
function mu:nuke(sourceIndex, targetIndex, _targetSeq, _ord, si, sid, _eid)
	local board = self.board
	local su, tu = board[sourceIndex], board[targetIndex]
	local sATK, datk, dperc = su.atk, si.dp, si.dh
	local points = (datk and f32_pim(datk, sATK) or 0) + (dperc and floor(dperc*tu.maxHP/100) or 0)
	mu.damage(self, sourceIndex, targetIndex, points, "Spell", sid)
end
function mu:nukem(sourceIndex, targetIndex, _targetSeq, _ord, si, sid, _eid)
	local su = self.board[sourceIndex]
	local sATK, d = su.atk, si.dp
	local sq, sqh = self.sq, self.sqh-1
	for j=#d, 1, -1 do
		sq[sqh], sqh = {"damage", sourceIndex, targetIndex, f32_pim(d[j], sATK), "Spell", sid}, sqh - 1
	end
	self.sqh = sqh+1
end
function mu:heal(sourceIndex, targetIndex, _targetSeq, _ord, si, sid, _eid)
	local board = self.board
	local su, tu = board[sourceIndex], board[targetIndex]
	local hPerc, hatk = si.hh, si.hp
	local points = (hatk and f32_pim(hatk, su.atk) or 0) + (hPerc and floor(hPerc*tu.maxHP/100) or 0)
	mu.mend(self, sourceIndex, targetIndex, points, "Spell", sid)
end
function mu:shroud(sourceIndex, targetIndex, _targetSeq, ord, si, sid, _eid)
	local tu = self.board[targetIndex]
	tu.shroud, self.ftc = (tu.shroud or 0) + 1, nil
	enq(self.queue, self.turn+si.d, {"unshroud", sourceIndex, targetIndex, ord=ord-80})
	if si.hp then
		mu.heal(self, sourceIndex, targetIndex, _targetSeq, ord, si, sid, _eid)
	end
end
function mu:taunt(sourceIndex, targetIndex, _targetSeq, ord, si, sid, _eid)
	local tu = self.board[targetIndex]
	tu.taunt = sourceIndex
	enq(self.queue, self.turn+si.d, {"untaunt", sourceIndex, targetIndex, sid, ord=ord-8e5})
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
	local sit = si.h
	if sit == "passive" then
		return mu.passive(self, sourceIndex, sid)
	end
	
	local willCast, hrMask, hrCount = false, 0, 0
	for i=#si == 0 and 0 or 1, #si do
		local e = si[i] or si
		local et, ett = e.h, e.t
		local hasHeal = et == "heal" or (et == "aura" and (e.hp or e.hh))
		if not e.shp then
		elseif su.curHP < su.maxHP then
			willCast = true
			break
		elseif su.hpR > 0 then
			hrMask, hrCount = addMaskCount(sourceIndex, hrMask, hrCount)
		end
		local tt = VS.GetTargets(sourceIndex, forkTargets[ett] or ett, board)
		if hasHeal then
			for i=1,#tt do
				local tu = board[tt[i]]
				if not tu then
				elseif tu.curHP < tu.maxHP then
					willCast = true
					break
				elseif tu.hpR > 0 then
					hrMask, hrCount = addMaskCount(tt[i], hrMask, hrCount)
				end
			end
		elseif tt and tt[1] then
			willCast = true
			break
		end
	end
	
	local cast = {"cast", sourceIndex, sid, recast, ord=ord, ord0=qe.ord0}
	local turn, eid1, ord1 = self.turn, si[1] and 1 or 0, ord-1
	if not willCast and hrCount > 0 then
		local clone, oracle = self:Clone(), self.castOracle
		willCast = oracle and oracle(turn, sourceIndex, sid)
		if willCast == nil then
			willCast = math.random() >= 0.5
		end
		if willCast then
			if clone then
				zeroHealthRanges(clone.board, hrMask, hrCount)
				enqc(clone.queue, turn+1, shallowCopy(cast))
			end
		else
			zeroHealthRanges(board, hrMask, hrCount)
			if clone then
				local sqh = clone.sqh-1
				clone.sq[sqh], clone.sqh = {"qcast", sourceIndex, sid, eid1, ord1}, sqh
				enqc(clone.queue, turn+recast, shallowCopy(cast))
			end
		end
	end
	if not willCast then
		enqc(self.queue, turn+1, cast)
		return
	end
	enqc(self.queue, turn+recast, cast)
	return mu.qcast(self, sourceIndex, sid, eid1, ord1)
end
function mu:qcast(sourceIndex, sid, eid, ord1, forkTarget)
	local si, board = SpellInfo[sid], self.board
	for i=eid, #si do
		local si = si[i] or si
		local sitt, tt = si.t
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
		
		local et, sq, sqt, ordi = si.h, self.sq, self.sqt, ord1+i
		for ti=1,tt and #tt or 0 do
			local targetIndex = tt[ti]
			if et == "aura" then
				sqt = sqt + 1
				sq[sqt] = {"aura0", sourceIndex, targetIndex, ti, ordi, si, sid, i}
			end
			sqt = sqt + 1
			sq[sqt] = {et, sourceIndex, targetIndex, ti, ordi, si, sid, i}
		end
		if et == "nuke" and si.shp then
			sqt = sqt + 1
			sq[sqt] = {"mend", sourceIndex, sourceIndex, f32_pim(si.shp, board[sourceIndex].atk), "DHeal", sid}
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
					if tside == dside and (mt == "unstackf32" and ex == "dom" or mt == "statDelta" and ex == "doa") then
						fom = bor(fom, 2^tar)
					elseif tside ~= dside and (mt == "unstackf32" and ex == "dim" or mt == "statDelta" and ex == "dia") then
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
			res.min[19+i] = math.min(res.min[19+i] or inf, e.deathTurn or inf)
			res.max[19+i] = math.max(res.max[19+i] or 0, e.deathTurn or inf)
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
	r[s.sq or 0] = shallowCopy(s.sq)
	r[0] = nil
	if s.queue then
		for _, v in pairs(s.queue) do
			r[v] = shallowCopy(v)
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
				if (t == 7 or not (si and si.thornp)) and (t ~= 8 or not (si and si.h == "passive"))  then
					return c == a
				end
			end
		end
	end
	function self.castOracle(turn, sourceIndex, sid)
		local la = log[turn]
		la = la and la.events
		for i=1,la and #la or 0 do
			local li = la[i]
			local t = li.type
			if li.casterBoardIndex == sourceIndex and li.spellID == sid and (t ~= 5 and t ~= 6 and t ~= 8) then
				return true
			end
		end
		return false
	end
end

local function addActorProps(a)
	a.dim = 1
	a.dom = 1
	a.dimH = 1
	a.domH = 1
	a.dia = 0
	a.doa = 0
	a.thornd = 0
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
		elseif si.h ~= "nop" then
			local qe = {"cast", slot, sid, 1+s.cooldown}
			if si.h == "passive" then
				qe.ord0, qe.ord = 0, slot*1e3 + i*10
				pmask = si.dim and bor(pmask, 2^slot) or pmask
			else
				qe.ord = (1+slot)*1e7 + 5e6 + i*1e5
			end
			enqc(q, si.firstTurn or 1, qe)
		end
	end
	enqc(q, 1, {"cast", slot, aa, 1, ord=(1+slot)*1e7 + 5e6})
	return missingSpells, pmask
end
function VS:New(team, encounters, envSpell, _mid, mscalar, forkLimit)
	local q, board, nf, pmask, missingSpells = {}, {}, 0, 0
	for slot, f in pairs(team) do
		if f.stats then
			f.attack, f.health, f.maxHealth = f.stats.attack, f.stats.currentHealth, f.stats.maxHealth
		end
		local rf, sa = {maxHP=f.maxHealth, curHP=math.max(1,f.health), atk=f.attack, slot=f.boardIndex or slot, name=f.name}, f.spells
		missingSpells, pmask = addCasts(q, rf.slot, sa, f.auto, missingSpells, pmask)
		board[rf.slot], nf = addActorProps(rf), nf + 1
	end
	for i=1,#encounters do
		local e = encounters[i]
		local rf, sa = {maxHP=e.maxHealth, curHP=e.maxHealth, atk=e.attack, slot=e.boardIndex}, e.autoCombatSpells
		missingSpells, pmask = addCasts(q, rf.slot, sa, e.auto, missingSpells, pmask)
		board[e.boardIndex] = addActorProps(rf)
	end
	
	local environmentSID = envSpell and envSpell.autoCombatSpellID
	local esi = SpellInfo[environmentSID]
	if environmentSID and not esi then
		missingSpells = missingSpells or {}
		missingSpells[environmentSID] = 2
	elseif esi and esi.h ~= "nop" then
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
		res={min={}, max={}, hadWins=false, hadLosses=false, hadDrops=false, isFinished=false, hadMissingSpells=missingSpells and true or nil, n=0},
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

T.VSim, T.KnownSpells, VS.VSI = VS, SpellInfo, VSI