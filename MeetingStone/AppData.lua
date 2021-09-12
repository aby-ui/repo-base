BuildEnv(...)

MOUNT_MAP = nil
APP_RAID_MAPS = ListToMap{2296,2450} -- X-DBM-Mod-MapID
APP_RAID_DIFFICULTIES = ListToMap{14,15,16}
APP_LEADER_MAPS = ListToMap{"\065\114\099\097\110\101\109\097\115\116\101\045\231\180\162\231\145\158\230\163\174","\066\097\099\105\109\105\097\122\122\111\118\111\045\232\161\128\232\137\178\229\141\129\229\173\151\229\134\155","\069\114\120\105\115\098\098\045\229\135\164\229\135\176\228\185\139\231\165\158","\072\105\115\116\114\097\119\098\101\114\114\121\045\230\151\160\229\176\189\228\185\139\230\181\183","\081\105\110\103\120\105\110\101\122\112\122\045\229\134\176\233\163\142\229\178\151","\083\097\107\117\114\097\109\105\045\230\173\187\228\186\161\228\185\139\231\191\188","\083\101\109\097\103\101\045\231\153\189\233\147\182\228\185\139\230\137\139","\083\101\109\097\103\101\045\233\152\191\231\186\179\229\133\139\231\189\151\230\150\175","\083\107\121\109\097\103\101\045\228\184\187\229\174\176\228\185\139\229\137\145","\098\108\117\102\102\045\229\135\164\229\135\176\228\185\139\231\165\158","\112\108\097\121\101\114\076\075\065\074\068\045\230\173\187\228\186\161\228\185\139\231\191\188","\114\097\105\115\101\045\230\173\187\228\186\161\228\185\139\231\191\188","\228\184\128\232\142\142\228\184\182\045\231\135\131\231\131\167\228\185\139\229\136\131","\228\184\129\231\165\158\045\230\173\187\228\186\161\228\185\139\231\191\188","\228\184\129\231\165\158\231\137\185\232\131\189\233\161\182\045\230\173\187\228\186\161\228\185\139\231\191\188","\228\184\137\229\143\183\230\156\186\045\229\135\164\229\135\176\228\185\139\231\165\158","\228\184\137\230\156\168\228\184\182\233\154\143\233\163\142\045\231\135\131\231\131\167\228\185\139\229\136\131","\228\184\138\229\129\153\045\230\180\155\228\184\185\228\188\166","\228\184\141\229\165\182\231\154\132\232\144\168\230\187\161\045\230\173\187\228\186\161\228\185\139\231\191\188","\228\184\182\230\178\161\229\174\158\229\138\155\045\229\135\164\229\135\176\228\185\139\231\165\158","\228\184\182\231\165\158\229\165\135\231\154\132\233\152\191\232\175\186\045\230\151\160\229\176\189\228\185\139\230\181\183","\228\184\182\231\177\179\232\138\177\045\232\180\171\231\152\160\228\185\139\229\156\176","\228\184\182\231\186\184\233\152\178\233\170\145\045\229\135\164\229\135\176\228\185\139\231\165\158","\228\184\182\233\154\144\232\128\133\045\230\151\160\229\176\189\228\185\139\230\181\183","\228\184\183\229\171\129\231\165\184\228\184\183\045\231\135\131\231\131\167\228\185\139\229\136\131","\228\184\183\232\152\173\229\133\176\229\133\176\228\184\183\045\228\188\138\230\163\174\229\136\169\230\129\169","\228\189\160\229\143\175\231\136\177\231\130\184\228\186\134\045\229\135\164\229\135\176\228\185\139\231\165\158","\229\136\171\230\188\148\229\149\138\045\229\135\164\229\135\176\228\185\139\231\165\158","\229\139\135\230\149\162\231\154\132\228\184\128\231\177\179\228\185\157\045\229\135\164\229\135\176\228\185\139\231\165\158","\229\143\152\230\128\129\229\176\143\229\167\168\229\166\136\045\233\163\142\230\154\180\229\179\173\229\163\129","\229\144\172\232\175\180\229\190\136\231\174\128\229\141\149\045\231\180\162\231\145\158\230\163\174","\229\147\134\229\151\166\231\154\132\230\156\136\231\165\158\045\229\184\131\229\133\176\229\141\161\229\190\183","\229\149\138\232\162\171\231\148\181\228\186\134\045\232\161\128\232\137\178\229\141\129\229\173\151\229\134\155","\229\150\181\229\184\149\230\150\175\229\166\150\229\166\150\045\232\161\128\232\137\178\229\141\129\229\173\151\229\134\155","\229\164\141\228\187\135\229\176\143\231\142\139\229\173\144\045\230\151\160\229\176\189\228\185\139\230\181\183","\229\164\156\229\164\167\230\190\136\233\163\158\229\176\184\045\229\135\164\229\135\176\228\185\139\231\165\158","\229\164\167\229\167\168\045\232\180\171\231\152\160\228\185\139\229\156\176","\229\164\167\233\173\148\231\142\139\229\165\182\230\152\148\045\228\188\138\230\163\174\229\136\169\230\129\169","\229\164\169\229\173\151\229\143\183\229\183\165\229\133\183\228\186\186\045\231\135\131\231\131\167\228\185\139\229\136\131","\229\164\169\231\189\170\228\185\139\230\128\168\045\232\161\128\231\142\175","\229\164\169\233\166\172\229\158\139\231\169\186\045\229\135\164\229\135\176\228\185\139\231\165\158","\229\164\169\233\187\145\229\176\177\230\182\136\229\164\177\045\232\161\128\232\137\178\229\141\129\229\173\151\229\134\155","\229\174\137\228\184\182\229\176\143\229\184\140\045\229\155\158\233\159\179\229\177\177","\229\174\137\233\128\184\228\184\182\231\129\172\045\230\173\187\228\186\161\228\185\139\231\191\188","\229\176\143\229\133\174\229\180\189\045\230\181\183\229\133\139\230\179\176\229\176\148","\229\176\143\229\164\169\231\156\159\045\228\188\138\230\163\174\229\136\169\230\129\169","\229\176\143\229\176\143\230\178\171\228\184\171\228\184\182\045\231\135\131\231\131\167\228\185\139\229\136\131","\229\176\143\230\152\159\230\152\159\229\144\150\228\184\182\045\231\135\131\231\131\167\228\185\139\229\136\131","\229\176\143\231\186\162\230\137\139\229\143\182\232\144\189\045\228\188\138\230\163\174\229\136\169\230\129\169","\229\176\143\232\138\177\231\147\163\045\228\188\138\230\163\174\229\136\169\230\129\169","\229\176\143\232\138\177\232\166\129\230\175\149\228\184\154\045\229\135\164\229\135\176\228\185\139\231\165\158","\229\176\143\233\165\168\233\165\168\045\228\188\138\230\163\174\229\136\169\230\129\169","\229\185\189\233\187\152\228\184\168\231\140\142\233\173\148\045\229\135\164\229\135\176\228\185\139\231\165\158","\229\191\131\231\129\181\228\185\132\233\173\148\232\141\175\045\230\173\187\228\186\161\228\185\139\231\191\188","\230\128\167\230\132\159\229\176\143\231\134\138\231\140\171\228\184\182\045\229\189\177\228\185\139\229\147\128\228\188\164","\230\136\145\229\156\168\230\162\166\233\135\140\045\230\173\187\228\186\161\228\185\139\231\191\188","\230\136\176\228\184\180\045\230\151\160\229\176\189\228\185\139\230\181\183","\230\137\147\230\156\172\230\178\161\233\187\145\232\191\135\045\232\180\171\231\152\160\228\185\139\229\156\176","\230\150\151\233\177\188\228\184\168\229\185\189\233\187\152\045\233\187\145\230\154\151\233\173\133\229\189\177","\230\150\151\233\177\188\228\184\182\231\144\133\229\142\165\045\232\161\128\232\137\178\229\141\129\229\173\151\229\134\155","\230\153\147\229\133\172\229\173\144\045\230\173\187\228\186\161\228\185\139\231\191\188","\230\155\188\230\129\169\232\150\132\232\141\183\045\230\160\188\231\145\158\229\167\134\229\183\180\230\137\152","\230\156\128\233\157\147\232\152\145\232\143\135\229\164\180\045\230\151\160\229\176\189\228\185\139\230\181\183","\230\156\168\230\156\168\228\184\128\229\176\143\230\136\152\231\165\158\045\231\135\131\231\131\167\228\185\139\229\136\131","\230\156\186\230\149\143\231\154\132\232\139\141\232\139\141\045\231\129\176\231\131\172\228\189\191\232\128\133","\230\158\175\230\179\149\232\128\133\233\152\191\228\184\135\045\232\180\171\231\152\160\228\185\139\229\156\176","\230\162\166\228\188\180\045\233\152\191\229\143\164\230\150\175","\230\169\152\229\173\144\231\154\132\229\176\143\233\169\172\232\190\190\045\229\135\164\229\135\176\228\185\139\231\165\158","\230\169\159\230\153\186\231\154\132\229\176\143\232\152\191\232\142\137\045\231\189\151\229\174\129","\230\172\167\230\176\148\229\176\143\229\176\143\231\140\142\228\184\182\045\230\173\187\228\186\161\228\185\139\231\191\188","\230\175\148\229\177\139\229\174\154\229\129\135\229\184\134\045\229\135\164\229\135\176\228\185\139\231\165\158","\230\178\171\231\173\177\231\173\177\045\229\174\137\232\139\143","\230\184\133\229\141\191\045\231\135\131\231\131\167\228\185\139\229\136\131","\231\128\154\232\135\163\045\231\135\131\231\131\167\228\185\139\229\136\131","\231\129\181\233\173\130\229\164\141\232\139\143\045\229\189\177\228\185\139\229\147\128\228\188\164","\231\134\138\229\175\182\229\175\179\045\231\135\131\231\131\167\228\185\139\229\136\131","\231\137\153\233\189\191\229\143\145\233\187\132\228\186\134\045\230\151\160\229\176\189\228\185\139\230\181\183","\231\137\155\228\188\154\233\149\191\045\230\180\155\228\184\185\228\188\166","\231\140\142\229\186\147\230\150\175\045\232\180\171\231\152\160\228\185\139\229\156\176","\231\148\156\229\191\131\229\146\149\229\146\149\045\231\135\131\231\131\167\228\185\139\229\136\131","\231\154\174\231\154\174\230\178\144\228\184\182\045\228\188\138\230\163\174\229\136\169\230\129\169","\231\158\142\229\186\147\230\150\175\045\231\153\189\233\147\182\228\185\139\230\137\139","\231\158\142\232\128\129\229\184\136\045\231\135\131\231\131\167\228\185\139\229\136\131","\231\165\158\229\165\135\231\154\132\233\152\191\232\175\186\228\184\182\045\230\151\160\229\176\189\228\185\139\230\181\183","\231\172\168\233\152\191\231\129\171\045\229\189\177\228\185\139\229\147\128\228\188\164","\231\174\128\231\185\129\228\184\182\045\230\151\160\229\176\189\228\185\139\230\181\183","\231\176\170\232\138\177\233\133\140\233\133\146\045\230\151\160\229\176\189\228\185\139\230\181\183","\231\191\142\229\146\169\229\146\169\045\231\153\189\233\147\182\228\185\139\230\137\139","\231\191\142\229\174\157\229\174\157\228\184\182\045\231\153\189\233\147\182\228\185\139\230\137\139","\232\128\129\228\184\182\229\140\151\233\188\187\045\229\189\177\228\185\139\229\147\128\228\188\164","\232\138\177\231\129\172\230\167\145\230\167\145\045\229\135\164\229\135\176\228\185\139\231\165\158","\232\143\147\232\139\146\045\231\189\151\229\174\129","\232\143\160\232\144\157\233\152\159\233\149\191\045\229\135\164\229\135\176\228\185\139\231\165\158","\232\144\140\232\144\140\231\154\132\232\153\190\231\177\179\045\231\153\189\233\147\182\228\185\139\230\137\139","\232\144\140\232\153\190\228\184\182\045\229\184\131\229\133\176\229\141\161\229\190\183","\232\146\178\232\128\129\229\184\136\228\184\182\045\228\188\138\230\163\174\229\136\169\230\129\169","\232\153\142\231\137\153\228\184\182\229\171\163\229\171\163\229\132\191\045\228\184\187\229\174\176\228\185\139\229\137\145","\232\153\142\231\137\153\228\184\182\229\171\163\229\171\163\229\133\144\045\228\184\187\229\174\176\228\185\139\229\137\145","\232\153\142\231\137\153\228\184\191\229\171\163\229\171\163\229\132\191\045\228\184\187\229\174\176\228\185\139\229\137\145","\232\153\142\231\137\153\228\184\191\229\176\144\228\185\150\045\229\135\164\229\135\176\228\185\139\231\165\158","\232\153\142\231\137\153\228\185\132\229\176\143\228\185\150\045\229\135\164\229\135\176\228\185\139\231\165\158","\232\153\142\231\137\153\228\185\132\229\176\144\228\185\150\045\229\135\164\229\135\176\228\185\139\231\165\158","\232\153\142\231\137\153\233\152\191\228\185\144\228\184\182\045\231\180\162\231\145\158\230\163\174","\232\182\133\229\184\133\231\154\132\233\184\162\233\184\162\233\133\177\045\231\135\131\231\131\167\228\185\139\229\136\131","\233\129\181\228\185\137\231\130\174\231\142\139\045\229\135\164\229\135\176\228\185\139\231\165\158","\233\130\170\230\129\182\229\133\137\231\142\175\228\184\182\045\229\175\146\229\134\176\231\154\135\229\134\160","\233\151\185\229\176\143\233\151\185\233\151\185\231\129\172\045\230\173\187\228\186\161\228\185\139\231\191\188","\233\152\191\229\184\131\229\164\143\045\229\164\143\231\187\180\229\174\137","\233\152\191\230\176\180\229\150\157\229\143\175\228\185\144\045\229\184\131\229\133\176\229\141\161\229\190\183","\233\152\191\230\176\180\230\176\180\045\231\189\151\229\174\129","\233\156\158\228\185\139\228\184\152\228\184\182\232\175\151\231\190\189\045\232\161\128\232\137\178\229\141\129\229\173\151\229\134\155","\233\157\146\230\152\165\231\140\170\229\164\180\045\229\155\189\231\142\139\228\185\139\232\176\183","\233\161\155\230\178\155\230\181\129\231\146\131\045\229\189\177\228\185\139\229\147\128\228\188\164","\233\163\142\230\182\167\230\190\136\045\228\188\138\230\163\174\229\136\169\230\129\169","\233\178\156\232\161\128\229\176\143\231\142\139\229\173\144\045\230\151\160\229\176\189\228\185\139\230\181\183","\233\184\162\233\184\162\231\136\177\229\164\143\229\164\169\045\231\135\131\231\131\167\228\185\139\229\136\131","\233\187\132\228\186\166\231\143\130\045\230\173\187\228\186\161\228\185\139\231\191\188","\233\187\145\230\155\188\229\183\180\228\184\182\229\156\163\233\170\145\045\228\188\138\230\163\174\229\136\169\230\129\169","\233\187\145\230\155\188\229\183\180\228\184\182\230\173\187\233\170\145\045\228\188\138\230\163\174\229\136\169\230\129\169"}
