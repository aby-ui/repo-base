-- -------------------------------------------------------------------------- --
-- BattlegroundTargets - carrier strings                                      --
-- -------------------------------------------------------------------------- --

local FLG, _, prg = {}, ...
prg.FLG = FLG

local locale = GetLocale()

if locale == "deDE" then

	-- Warsong Gulch:  --> deDE: tested with Patch 6.0.3.19342 (LIVE)
	-- Twin Peaks:     --> deDE: tested with Patch 5.3.0.17128 (LIVE)
	-- Deepwind Gorge: --> deDE: tested with Patch 6.0.3.19342 (LIVE)
	FLG["WG_TP_DG_PATTERN_PICKED1"] = "(.+) hat die Flagge der .+ aufgenommen!"
	FLG["WG_TP_DG_PATTERN_PICKED2"] = "(.+) hat die Flagge der .+ aufgenommen!" -- ruRU special
	FLG["WG_TP_DG_MATCH_DROPPED"] = "fallenlassen!"
	FLG["WG_TP_DG_MATCH_CAPTURED"] = "errungen!"

	-- Eye of the Storm: --> deDE: tested with Patch 6.0.3.19342 (LIVE)
	FLG["EOTS_PATTERN_PICKED"] = "(.+) hat die Flagge aufgenommen."
	FLG["EOTS_STRING_DROPPED"] = "Die Flagge wurde fallengelassen."
	FLG["EOTS_PATTERN_CAPTURED"] = "(.+) hat die Flagge erobert!"

	-- Temple of Kotmogu: --> deDE: tested with Patch 6.0.3.19342 (LIVE)
	FLG["TOK_PATTERN_TAKEN"] = "(.+) hat die (.+) Kugel genommen!"
	FLG["TOK_PATTERN_RETURNED"] = "Die (.+) Kugel wurde zurückgebracht!"

elseif locale == "esES" then

	-- Warsong Gulch:  --> esES: tested with Patch 6.0.3.19342 (LIVE)
	-- Twin Peaks:     --> esES: tested with Patch 6.0.3.19342 (LIVE)
	-- Deepwind Gorge: --> esES: tested with Patch 6.0.3.19342 (LIVE)
	FLG["WG_TP_DG_PATTERN_PICKED1"] = "¡(.+) ha cogido la bandera"
	FLG["WG_TP_DG_PATTERN_PICKED2"] = "¡(.+) ha cogido la bandera" -- ruRU special
	FLG["WG_TP_DG_MATCH_DROPPED"] = "dejado caer la bandera"
	FLG["WG_TP_DG_MATCH_CAPTURED"] = "capturado la bandera"

	-- Eye of the Storm: --> esES: tested with Patch 6.0.3.19342 (LIVE)
	FLG["EOTS_PATTERN_PICKED"] = "¡(.+) ha tomado la bandera!"
	FLG["EOTS_STRING_DROPPED"] = "¡Ha caído la bandera!"
	FLG["EOTS_PATTERN_CAPTURED"] = "¡(.+) ha capturado la bandera!"

	-- Temple of Kotmogu: --> esES: tested with Patch 6.0.3.19342 (LIVE)
	FLG["TOK_PATTERN_TAKEN"] = "¡(.+) se ha hecho con el orbe (.+)!"
	FLG["TOK_PATTERN_RETURNED"] = "¡El orbe (.+) ha sido devuelto!"

elseif locale == "esMX" then

	-- Warsong Gulch:  --> esMX: tested with Patch 5.1.0.16208 (PTR)
	-- Twin Peaks:     --> esMX: tested with Patch 5.1.0.16208 (PTR)
	-- Deepwind Gorge: --> esMX: TODO needs check
	FLG["WG_TP_DG_PATTERN_PICKED1"] = "¡(.+) ha tomado la bandera"
	FLG["WG_TP_DG_PATTERN_PICKED2"] = "¡(.+) ha tomado la bandera" -- ruRU special
	FLG["WG_TP_DG_MATCH_DROPPED"] = "dejado caer la bandera"
	FLG["WG_TP_DG_MATCH_CAPTURED"] = "capturado la bandera"

	-- Eye of the Storm: --> esMX: TODO need check
	FLG["EOTS_PATTERN_PICKED"] = "¡(.+) ha tomado la bandera!"
	FLG["EOTS_STRING_DROPPED"] = "¡Ha caído la bandera!"
	FLG["EOTS_PATTERN_CAPTURED"] = "¡(.+) ha capturado la bandera!"

	-- Temple of Kotmogu: --> esMX: tested with Patch 5.4.0.17093 (PTR)
	FLG["TOK_PATTERN_TAKEN"] = "¡(.+) ha tomado el orbe (.+)!"
	FLG["TOK_PATTERN_RETURNED"] = "¡El orbe (.+) ha sido devuelto!"

elseif locale == "frFR" then

	-- Warsong Gulch:  --> frFR: tested with Patch 6.0.3.19342 (LIVE)
	-- Twin Peaks:     --> frFR: tested with Patch 6.0.3.19342 (LIVE)
	-- Deepwind Gorge: --> frFR: tested with Patch 6.0.3.19342 (LIVE)
	FLG["WG_TP_DG_PATTERN_PICKED1"] = "a été ramassé par (.+) !"
	FLG["WG_TP_DG_PATTERN_PICKED2"] = "a été ramassé par (.+) !" -- ruRU special
	FLG["WG_TP_DG_MATCH_DROPPED"] = "a été lâché"
	FLG["WG_TP_DG_MATCH_CAPTURED"] = "a pris le drapeau"

	-- Eye of the Storm: --> frFR: tested with Patch 6.0.3.19342 (LIVE)
	FLG["EOTS_PATTERN_PICKED"] = "(.+) a pris le drapeau !"
	FLG["EOTS_STRING_DROPPED"] = "Le drapeau a été lâché !"
	FLG["EOTS_PATTERN_CAPTURED"] = "(.+) a capturé le drapeau !"

	-- Temple of Kotmogu: --> frFR: tested with Patch 6.0.3.19342 (LIVE)
	FLG["TOK_PATTERN_TAKEN"] = "(.+) a pris l’orbe (.+) !"
	FLG["TOK_PATTERN_RETURNED"] = "L’orbe (.+) a été rendu !"

elseif locale == "itIT" then

	-- Warsong Gulch:  --> itIT: tested with Patch 6.0.3.19342 (LIVE)
	-- Twin Peaks:     --> itIT: tested with Patch 6.0.3.19342 (LIVE)
	-- Deepwind Gorge: --> itIT: tested with Patch 6.0.3.19342 (LIVE)
	FLG["WG_TP_DG_PATTERN_PICKED1"] = "(.+) ha raccolto la bandiera"
	FLG["WG_TP_DG_PATTERN_PICKED2"] = "(.+) ha raccolto la bandiera" -- ruRU special
	FLG["WG_TP_DG_MATCH_DROPPED"] = "lasciato cadere la bandiera"
	FLG["WG_TP_DG_MATCH_CAPTURED"] = "conquistato la bandiera"

	-- Eye of the Storm: --> itIT: tested with Patch 6.0.3.19342 (LIVE)
	FLG["EOTS_PATTERN_PICKED"] = "(.+) ha raccolto la bandiera!"
	FLG["EOTS_STRING_DROPPED"] = "La bandiera è a terra!"
	FLG["EOTS_PATTERN_CAPTURED"] = "(.+) ha catturato la bandiera!"

	-- Temple of Kotmogu: --> itIT: tested with Patch 6.0.3.19342 (LIVE)
	FLG["TOK_PATTERN_TAKEN"] = "(.+) ha preso il globo (.+)!"
	FLG["TOK_PATTERN_RETURNED"] = "Il globo (.+) è stato restituito!"

elseif locale == "koKR" then

	-- Warsong Gulch:  --> koKR: tested with Patch 4.3.2.15211 (PTR)
	-- Twin Peaks:     --> koKR: tested with Patch 4.3.2.15211 (PTR)
	-- Deepwind Gorge: --> koKR: TODO needs check
	FLG["WG_TP_DG_PATTERN_PICKED1"] = "(.+)|1이;가; (.+) 깃발을 손에 넣었습니다!"
	FLG["WG_TP_DG_PATTERN_PICKED2"] = "(.+)|1이;가; (.+) 깃발을 손에 넣었습니다!" -- ruRU special
	FLG["WG_TP_DG_MATCH_DROPPED"] = "깃발을 떨어뜨렸습니다!"
	FLG["WG_TP_DG_MATCH_CAPTURED"] = "깃발 쟁탈에 성공했습니다!"

	-- Eye of the Storm: --> koKR: TODO
	FLG["EOTS_PATTERN_PICKED"] = "TODO" -- "^(.+)|1이;가; 깃발을 차지했습니다!"
	FLG["EOTS_STRING_DROPPED"] = "TODO" -- "깃발이 떨어졌습니다!"
	FLG["EOTS_PATTERN_CAPTURED"] = "TODO"

	-- Temple of Kotmogu: --> koKR: tested with Patch 5.4.0.17093 (PTR)
	FLG["TOK_PATTERN_TAKEN"] = "(.+)|1이;가; (.+) 공을 차지했습니다!"
	FLG["TOK_PATTERN_RETURNED"] = "(.+) 공이 돌아왔습니다!"

elseif locale == "ptBR" then

	-- Warsong Gulch:  --> ptBR: tested with Patch 6.0.3.19342 (LIVE)
	-- Twin Peaks:     --> ptBR: tested with Patch 6.0.3.19342 (LIVE)
	-- Deepwind Gorge: --> ptBR: tested with Patch 6.0.3.19342 (LIVE)
	FLG["WG_TP_DG_PATTERN_PICKED1"] = "(.+) pegou a Bandeira da .+!"
	FLG["WG_TP_DG_PATTERN_PICKED2"] = "(.+) pegou a Bandeira da .+!" -- ruRU special
	FLG["WG_TP_DG_MATCH_DROPPED"] = "largou a Bandeira"
	FLG["WG_TP_DG_MATCH_CAPTURED"] = "capturou a Bandeira"

	-- Eye of the Storm: --> ptBR: tested with Patch 6.0.3.19342 (LIVE)
	FLG["EOTS_PATTERN_PICKED"] = "(.+) pegou a bandeira!"
	FLG["EOTS_STRING_DROPPED"] = "A bandeira foi largada!"
	FLG["EOTS_PATTERN_CAPTURED"] = "(.+) capturou a bandeira!"

	-- Temple of Kotmogu: --> ptBR: tested with Patch 5.4.0.17093 (PTR)
	FLG["TOK_PATTERN_TAKEN"] = "(.+) pegou o orbe (.+)!"
	FLG["TOK_PATTERN_RETURNED"] = "O orbe (.+) foi devolvido!"

elseif locale == "ruRU" then

	-- Warsong Gulch:  --> ruRU: tested with Patch 6.0.3.19342 (LIVE)
	-- Twin Peaks:     --> ruRU: tested with Patch 6.0.3.19342 (LIVE)
	-- Deepwind Gorge: --> ruRU: tested with Patch 6.0.3.19342 (LIVE)
	FLG["WG_TP_DG_PATTERN_PICKED1"] = "(.+) несет флаг Орды!"
	FLG["WG_TP_DG_PATTERN_PICKED2"] = "Флаг Альянса у |3%-1%((.+)%)!" -- ruRU special
	FLG["WG_TP_DG_MATCH_DROPPED"] = "роняет"
	FLG["WG_TP_DG_MATCH_CAPTURED"] = "захватывает"

	-- Eye of the Storm: --> ruRU: tested with Patch 6.0.3.19342 (LIVE)
	FLG["EOTS_PATTERN_PICKED"] = "(.+) захватывает флаг!"
	FLG["EOTS_STRING_DROPPED"] = "Флаг уронили!"
	FLG["EOTS_PATTERN_CAPTURED"] = "(.+) захватил флаг!"

	-- Temple of Kotmogu: --> ruRU: tested with Patch 5.4.0.17093 (PTR)
	FLG["TOK_PATTERN_TAKEN"] = "(.+) захватывает (.+) сферу!"
	FLG["TOK_PATTERN_RETURNED"] = "(.+) сфера возвращена!"

elseif locale == "zhCN" then

	-- Warsong Gulch:  --> zhCN: tested with Patch 6.0.3.19342 (LIVE)
	-- Twin Peaks:     --> zhCN: tested with Patch 6.0.3.19342 (LIVE)
	-- Deepwind Gorge: --> zhCN: tested with Patch 6.0.3.19342 (LIVE)
	FLG["WG_TP_DG_PATTERN_PICKED1"] = "旗帜被([^%s]+)拔起了！"
	FLG["WG_TP_DG_PATTERN_PICKED2"] = "旗帜被([^%s]+)拔起了！" -- ruRU special
	FLG["WG_TP_DG_MATCH_DROPPED"] = "丢掉了"
	FLG["WG_TP_DG_MATCH_CAPTURED"] = "夺取"

	-- Eye of the Storm: --> zhCN: tested with Patch 6.0.3.19342 (LIVE)
	FLG["EOTS_PATTERN_PICKED"] = "(.+)夺走了旗帜！"
	FLG["EOTS_STRING_DROPPED"] = "旗帜被扔掉了！"
	FLG["EOTS_PATTERN_CAPTURED"] = "(.+)夺得了旗帜！"

	-- Temple of Kotmogu: --> zhCN: tested with Patch 6.0.3.19342 (LIVE)
	FLG["TOK_PATTERN_TAKEN"] = "(.+)取走了(.+)的球！"
	FLG["TOK_PATTERN_RETURNED"] = "(.+)宝珠被放回了！"

elseif locale == "zhTW" then

	-- Warsong Gulch:  --> zhTW: tested with Patch 4.3.2.15211 (PTR)
	-- Twin Peaks:     --> zhTW: tested with Patch 4.3.2.15211 (PTR)
	-- Deepwind Gorge: --> zhTW: TODO needs check
	FLG["WG_TP_DG_PATTERN_PICKED1"] = "被(.+)拔掉了!"
	FLG["WG_TP_DG_PATTERN_PICKED2"] = "被(.+)拔掉了!" -- ruRU special
	FLG["WG_TP_DG_MATCH_DROPPED"] = "丟掉了"
	FLG["WG_TP_DG_MATCH_CAPTURED"] = "佔據了"

	-- Eye of the Storm: --> zhTW: TODO
	FLG["EOTS_PATTERN_PICKED"] =  "TODO" -- "(.+)已經奪走了旗幟!"
	FLG["EOTS_STRING_DROPPED"] =  "TODO" -- "旗幟已經掉落!"
	FLG["EOTS_PATTERN_CAPTURED"] = "TODO"

	-- Temple of Kotmogu: --> zhTW: tested with Patch 5.4.0.17093 (PTR)
	FLG["TOK_PATTERN_TAKEN"] = "(.+)奪走了(.+)異能球!"
	FLG["TOK_PATTERN_RETURNED"] = "(.+)異能球已回到初始位置!"

else--if locale == "enUS" then

	-- Warsong Gulch:  --> enUS: tested with Patch 6.0.3.19342 (LIVE)
	-- Twin Peaks:     --> enUS: tested with Patch 6.0.3.19342 (LIVE)
	-- Deepwind Gorge: --> enUS: tested with Patch 6.0.3.19342 (LIVE)
	FLG["WG_TP_DG_PATTERN_PICKED1"] = "was picked up by (.+)!"
	FLG["WG_TP_DG_PATTERN_PICKED2"] = "was picked up by (.+)!" -- ruRU special
	FLG["WG_TP_DG_MATCH_DROPPED"] = "was dropped"
	FLG["WG_TP_DG_MATCH_CAPTURED"] = "captured the"

	-- Eye of the Storm: --> enUS: tested with Patch 6.0.3.19342 (LIVE)
	FLG["EOTS_PATTERN_PICKED"] = "(.+) has taken the flag!"
	FLG["EOTS_STRING_DROPPED"] = "The flag has been dropped!"
	FLG["EOTS_PATTERN_CAPTURED"] = "(.+) has captured the flag!"

	-- Temple of Kotmogu: --> enUS: tested with Patch 6.0.3.19342 (LIVE)
	FLG["TOK_PATTERN_TAKEN"] = "(.+) has taken the (.+) orb!"
	FLG["TOK_PATTERN_RETURNED"] = "The (.+) orb has been returned!"

end