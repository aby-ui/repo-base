local E = select(2, ...):unpack()



if E.preCata then
	local BLANK = {}
	E.spell_db["ESSENCES"] = nil
	E.spell_cxmod_azerite = BLANK
	E.spellcast_cdr_azerite = BLANK
	E.spell_damage_cdr_azerite = BLANK
	E.spell_cdmod_essrank23 = BLANK
	E.spell_chargemod_essrank3 = BLANK
	E.essMajorConflict = BLANK
	E.pvpTalentsByEssMajorConflict = BLANK
	E.essMinorStrive = BLANK
	E.spell_cdmod_ess_strive_mult = BLANK
	return
end

E.spell_db["ESSENCES"] = {
	{ spellID = 295373, duration = 30, type = "essence", spec = 295373 },
	{ spellID = 295186, duration = 60, type = "essence", spec = 295186 },
	{ spellID = 302731, duration = 60, type = "essence", spec = 302731 },
	{ spellID = 298357, duration = 120, type = "essence", spec = 298357 },
	{ spellID = 293019, duration = 60, type = "essence", spec = 293019 },
	{ spellID = 294926, duration = 150, type = "essence", spec = 294926 },
	{ spellID = 298168, duration = 90, type = "essence", spec = 298168 },
	{ spellID = 295746, duration = 180, type = "essence", spec = 295746 },
	{ spellID = 293031, duration = 60, type = "essence", spec = 293031 },
	{ spellID = 296197, duration = 15, type = "essence", spec = 296197 },
	{ spellID = 296094, duration = 180, type = "essence", spec = 296094 },
	{ spellID = 293032, duration = 150, type = "essence", spec = 293032 },
	{ spellID = 296072, duration = 30, type = "essence", spec = 296072 },
	{ spellID = 296230, duration = 60, type = "essence", spec = 296230 },
	{ spellID = 295258, duration = 90, type = "essence", spec = 295258 },
	{ spellID = 295840, duration = 180, type = "essence", spec = 295840 },
	{ spellID = 297108, duration = 120, type = "essence", spec = 297108 },
	{ spellID = 295337, duration = 60, type = "essence", spec = 295337 },
	{ spellID = 298452, duration = 60, type = "essence", spec = 298452 },
	{ spellID = 293030, duration = 180, type = "essence", spec = 293030 },
	{ spellID = 297375, duration = 60, type = "essence", spec = 297375 },
	{ spellID = 295046, duration = 600, type = "essence", spec = 295046 },
	{ spellID = 310592, duration = 120, type = "essence", spec = 310592 },
	{ spellID = 310690, duration = 45, type = "essence", spec = 310690 },
	{ spellID = 311203, duration = 60, type = "essence", spec = 311203 },
}





E.spell_cxmod_azerite = {
	[48792] = { azerite = 288424, duration = 15 },
	[48265] = { azerite = 280011, duration = 5 },
	[109304] = { azerite = 287938, duration = 15 },
	[116849] = { azerite = 277667, duration = 20 },
	[190784] = { azerite = 280017, duration = 5 },
	[1122] = { azerite = 277705, duration = 15 },
	[12051] = { azerite = 273330, charges = 2 },
	[-1] = { azerite = 273338, duration = 0 },
	[-2] = { azerite = 278541, duration = 0 },
}

E.spellcast_cdr_azerite = {
	[5221] = { target = { [106951]=0.3,[102543]=0.2 }, azerite = 273338 },
	[106830] = { target = { [106951]=0.3,[102543]=0.2 }, azerite = 273338 },
	[106785] = { target = { [106951]=0.3,[102543]=0.2 }, azerite = 273338 },
	[274837] = { target = { [106951]=0.3,[102543]=0.2 }, azerite = 273338 },
	[1822] = { target = { [106951]=0.3,[102543]=0.2 }, azerite = 273338 },
	[202028] = { target = { [106951]=0.3,[102543]=0.2 }, azerite = 273338 },
	[30455] = { target = { [84714]=0.5 }, azerite = 278541 },
}

E.spell_damage_cdr_azerite = {
	[283810] = { target = 1719, duration = 0.1 },
	[278565] = { target = { 186265,186289,193530,186257 }, duration = 1 },
}

for _, v in pairs(E.spell_cxmod_azerite) do
	local name = GetSpellInfo(v.azerite)
	v.name = name
end





E.spell_cdmod_essrank23 = {
	[293019] = 15,
	[293031] = 15,
	[294926] = 30,
	[295746] = 42,
	[296230] = 15,
	[297108] = 30,
	[298168] = 30,
	[298452] = 15,
}

E.spell_chargemod_essrank3 = {
	[295373] = { 299353, 1 },
}

E.essMajorConflict = {
	[303823] = true,
	[304088] = true,
	[304121] = true,
}

E.pvpTalentsByEssMajorConflict = {
	[250] = 202727,
	[251] = 305392,
	[577] = 235893,
	[102] = 305497,
	[103] = 305497,
	[105] = 203651,
	[253] = 236776,
	[254] = 236776,
	[255] = 236776,
	[62] = 198111,
	[63] = 198111,
	[64] = 198111,
	[269] = 287771,
	[270] = 216113,
	[65] = 210294,
	[256] = 305498,
	[257] = 213610,
	[258] = 108968,
	[262] = 305483,
	[266] = 212295,
	[71] = 198817,
}

E.essMinorStrive = {
	[296320] = true,
	[299367] = true,
	[299369] = true,
}

E.spell_cdmod_ess_strive_mult = {
	[275699] = true,
	[47568] = true,
	[55233] = true,
	[191427] = true,
	[187827] = true,
	[193530] = true,
	[266779] = true,
	[288613] = true,
	[194223] = true,
	[102560] = true,
	[106951] = true,
	[102543] = true,
	[61336] = 104,
	[740] = true,
	[12042] = true,
	[190319] = true,
	[12472] = true,
	[115203] = true,
	[115310] = true,
	[137639] = true,
	[152173] = true,
	[31884] = true,
	[216331] = true,
	[231895] = true,
	[64843] = true,
	[34433] = true,
	[123040] = true,
	[200174] = true,
	[13750] = true,
	[121471] = true,
	[79140] = true,
	[51533] = true,
	[198067] = true,
	[192249] = true,
	[108280] = true,
	[205180] = true,
	[265187] = true,
	[1122] = true,
	[107574] = 73,
	[227847] = true,
	[152277] = true,
	[1719] = true,
}
