-- colorLow if <= countLow, colorMiddle if <= countHigh, if > countHigh colorHigh
GridWarbabyMoreAuras = {
    --[317420] = { buff = true,  statusText="count", priority=98 }, --测试：黑曜毁灭
    --[315161] = { buff = false, statusText="count", priority=98 }, --测试：腐化之眼

    --[313255] = { desc="减速-黑龙帝王" ,buff=false, indicator="textstack", statusText="count"   ,color={1,0,1},priority=95,statusColor="count",countColorLow={.4,.4,.4},countLow=30,countColorMiddle={1,1,.2},countHigh=40,countColorHigh={1,0,1},},
    --[314993] = { desc="吸取精华-玛乌特",buff=false, indicator="borderglow", statusText="duration",color={1,0,1},priority=98,},
    --[318078] = { desc="锁定-无厌者"   ,buff=false, indicator="borderglow", statusText="duration",color={1,0,1},priority=98,},
    --[307358] = { desc="衰弱唾液-无厌者",buff=false, indicator="borderglow", statusText="count"   ,color={0,1,0},priority=99,statusColor="count",countColorLow={.4,.4,.4},countLow=2,countColorMiddle={0,1,0},countHigh=3,countColorHigh={1,1,0},},
    --[326699] = { desc="大帝-P1层数",   buff=false, indicator="textstack", statusText="count"   ,color={0,1,0}, priority=90, statusColor="count",countColorLow={.5,.5,.5},countLow=2,countColorMiddle={0,1,0},countHigh=3,countColorHigh={1,1,0},},
    --[329785] = { desc="大帝-P2猩红合唱",buff=false, indicator="textstack", statusText="count"   ,color={0,1,0}, priority=90, statusColor="count",countColorLow={ 0, 1, 0},countLow=2,countColorMiddle={1,1,0},countHigh=4,countColorHigh={1,.5,0},},
    --[334755] = { desc="饥饿者-M吸球层数", buff=false, indicator="textstack", statusText="count"   ,color={0,1,0}, priority=98, statusColor="count",countColorLow={ 0, 1, 0},countLow=6,countColorMiddle={1,1,0},countHigh=12,countColorHigh={1,0,0},},
    --[329298] = { desc="饥饿者-中白圈", buff=false, indicator="borderglow", statusText="duration",color={1,0,1},priority=98,},
    --[332664] = { desc="女勋爵-大怪点名", buff=false, indicator="borderglow", statusText="duration",color={1,0,1},priority=99,},
    --[334909] = { desc="议会层数",   buff=false, indicator="textstack", statusText="count"   ,color={0,1,0}, priority=90, statusColor="count",countColorLow={.5,.5,.5},countLow=2,countColorMiddle={0,1,0},countHigh=3,countColorHigh={1,1,0},},
--    [359660] = { desc="克尔苏加德层数",   buff=false, indicator="textstack", statusText="count"   ,color={0,1,0}, priority=90, statusColor="count",countColorLow={.5,.5,.5},countLow=10,countColorMiddle={0,1,0},countHigh=20,countColorHigh={1,1,0},},
--    [358610] = { desc="M2凄凉光波", buff=false, indicator="borderglow", statusText="duration",color={1,0,1},priority=99,},
--    [355240] = { desc="M2轻蔑",   buff=false, indicator="textstack", statusText="count", priority=90, statusColor="count",countColorLow={ 0, 1, 0}, countLow=999,countHigh=999},
--    [355245] = { desc="M2愤怒",   buff=false, indicator="textstack", statusText="count", priority=90, statusColor="count",countColorLow={ 1, 0, 0}, countLow=999,countHigh=999},
--    [350542] = { desc="M3碎片", buff=false, indicator="borderglow", statusText="duration",color={1,1,0},priority=99,},

    [342938] = { desc="PVP-痛苦无常", buff=false, indicator="borderglow", statusText="duration",color={1,0,1},priority=99,},
    [323687] = { desc="彼界商人闪电", buff=false, indicator="borderglow", statusText="duration",color={1,0,1},priority=99,},
    [323692] = { desc="彼界商人易伤",buff=false, indicator="textstack", statusText="count"   ,color={0,1,0}, priority=90, statusColor="count",countColorLow={ 0, 1, 0},countLow=4,countColorMiddle={1,1,0},countHigh=8,countColorHigh={1,.5,0},},
    [361817] = { desc="安度因灭愿者", buff=false, indicator="textstack", statusText="count", priority=90, statusColor="count",countColorLow={ 0, 1, 0}, countLow=999,countHigh=999},
    [362055] = { desc="安度因进场", buff=false, indicator="iconrole", statusText="count", priority=80, },
    [365445] = { desc="安度因轮换", buff=false, indicator="iconrole", statusText="count", priority=80, },
}
