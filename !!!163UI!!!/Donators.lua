local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["死亡之翼"] = "NL,茶叶蛋叶子,好硬的象拔蚌,浪味仙乂,兔乄随;NK,梦断不成归,灰烬旋律,凉愁浅梦,甜蜜至臻时,丨莫笑丨;NJ,奶你一口甜;NI,撒欢哦,呆呆不盟;NH,伯牙鼓瑟,香蕉酱,泪流满面丶,醉炫;NG,陈信羽丶;NE,苏城牛少;ND,狐狸的心,Orangetime,地了个狱,北城領主,丿都给我退下,達芬琪;NC,幽默作家,塔可;NB,芃五,大力萌,花菱烈火丶;M+,榴莲灬,咕咕狐;M9,Sevenwilson,令狐盈盈,果绿森群,就不找你玩;M8,大卫妮尔;M7,还魂的酒,晨歌审判;M5,Camniel;M4,快乐狐,咔咔卡壳;M3,冲锋释放鬼才;M2,你前男友,浅忆雪,波沨水門;M1,一楼吊死鬼,月下夜響曲,我太難了,矮脚猫,筱欢郡主,灬树,筱豆豆,告一段落;Mz,楼下的阿呆,明知是意外丶,杏仁薾,欧皇的亲闺女;My,珈蓝寺听雨声,晓白狐,小风酱,光上帝的长婿,Lorenzo;Mx,碎兔万,英俊的南方哥,铁蹄踏冰河,佳洁士丶,炳明离章;Mw,大枇谷,六九冠军,丨秋月丨,马尾丶,老斑马尐;Mv,看你往哪跑,打灰机劣人,青牛翁,踏青的蚂蚁,遣怀;Mu,婷好丶挺好;Mt,梦回海布里;Ms,暴力春春,谁动了我情弦,请叫我王先生;Mr,雾羽崎,浅若灬梨花落;Mq,思舟丶,许光汉,是阿喵啊,Eviscarite,盗版杀手;Mp,洛天丨凌風,不羁与醉,破魔之紫蔷薇;Mo,肥嘟嘟布紫灰,晓灬筱,人死雕朝天;Mm,Yawakaze,Flywan,Furiosalol;Mj,萨戈尼奥,铁腕凯恩,吃货不痴货丶",["安苏"] = "NL,盜賊丶丶;NK,丶威士忌;NJ,愚鱼浴雨;NG,黄超神;ND,言弟么;NC,冰糖大西瓜,乄暮灬光炮,乄屠灬夫,龙城插手;NB,哋灬哋哋,桃花朵朵儿;NA,霸气老油条;M/,雁門郡望,涩灵;M+,白天亮晶晶,紫电丨青霜;M9,小泽老师,城管纠察队;M8,琴雪枫;M7,法神浩克,聖光摩羯,柒柒寶寶;M6,是月亮啊丶;M5,Jungle,邢丶小玉,阿米狐;M2,不爱搭讪;M1,猥琐灬怪蜀蜀,核桃搭牛奶;M0,瑟蕾吉亚;My,赏遍红尘蒹葭,荣荣;Mw,大号柠檬妖怪,地狱禛魂歌,香菜猫饼丶,大秦上将王翦,美女轻点,一拳要你猪命;Mv,住手别这样呀,Xzylcd;Mt,差劲先生;Mr,Mcon,未驲观光;Mp,梦幻领袖;Mn,皮爱吉;Mj,八宝丶宝",["基尔加丹"] = "NL,装了逼就跑;M2,就你屁事多",["凤凰之神"] = "NL,安度嘤,绯色萝莉控,黑八兔;NK,橙窦窦,Misseeker;NJ,旧砚,张不理智;NI,朔风起时;NG,乁喵小娜,泪般清澈;NF,奈良未遥,卡尔萨拉;NE,天天在郁闷,芒果养乐多丶;ND,无敌丶奶妈;NC,小帅哥丶;NB,鹿北北,响当当的瞎子,横踢滥卷;NA,婦科專家丶;M+,阳光真晒啊,小豆浆丷,小鸣童学,月色真美呀,胖板栗;M9,腐蚀狂暴戦,晴時不见荷;M8,脂虎丶;M7,Lazyai;M5,卡得假;M4,仰朢摩兲輪,奥妮酱;M3,乁雅典娜;M2,俗气且油腻,Lemon;M1,生化环材,舞转回红袖;M0,该回来了,天雨流芳灬,Fortunes;Mz,皮皮小飞侠,狂扁小朋友丶,Richwtf,柚子茶丶;Mx,一飞重天,以法之名,湖海散人;Mw,天堂之吻,西昆仑,劍聖歸來,灬大溪几灬,迷糊的芝麻糊;Mv,禹你相伴,欧皇王大宝,潇洒丨小铭哥,丨蓝海丨,哥中哥,明月花绮萝,清辉圆月,不耻下射,就喷你怎么着;Mu,胡极霸郎,暮光微醺;Mt,她乡之秋;Ms,晚謃;Mr,丶菠萝包;Mq,九五年保温杯;Mp,吉原悠一;Mn,友情以上;Mm,小基基丶,八千年玉老;Mj,工部尚书,Kratos",["白银之手"] = "NL,浪氵氵;NK,云际;NJ,周英俊,黄釒脆皮鸡;NH,生活很单纯,神的那只手;NG,喵灬小汐;NF,星辰飞虹;NE,爸爸粑粑丶;ND,Luciferyang,Scarlettyang,灵界打擊;NC,唁风,韩某人,無法潕天,Rosin;NA,言叶丶;M/,蜜小甜呀;M+,道贼遖,武汉没饭吃;M9,调皮的果子狸,低保混子胖娃;M8,小原,洛尐胖;M7,极渡恐怖丶,旋风小鼠;M6,阿弥丶;M5,温柔馨,锐华手机配件,伊丶然;M4,凛冬战魂;M2,芝心小妮;M1,米斯兰特;Mz,无聊小旋风;My,一叶知秋丶;Mx,杜兰大师,风中紫雾,纲手丶;Mw,苍穹第一骑,苍穹第一魔,苍穹第一德,未知目标氵,未知目标冫,图兰娜,东子锅儿,克里斯特鑫;Mv,凌天战神,夕阳下的承诺,泽拉瑞尔;Mu,賎气凛然,Fovdk;Ms,深蹲的男人,Dondo,Violettayang,聖卡洛斯;Mr,勿飞,三吉丶彩花;Mq,暖男,冰焰之忆;Mj,Ioststars,粥祭丨捣蛋",["无尽之海"] = "NL,文风丧胆;NK,尛魄罗;NJ,丶懒妥妥;NI,聖骑士的斩杀,狗子丶;NE,一魂一体;ND,猫孑;NC,李诞;NB,Wizi,重回靶心;NA,再重都要,纯粹为了玩;M/,戏孑;M+,逃课的红领巾,听风挽;M6,宣武永存丶;M4,蛋总赐我力量;M3,游魂无心;My,喃唔啊咪唾咐,粗野官人;Mw,飛飛;Mv,這个炎爆奈斯,天上不掉馅饼;Mt,静水阳流,三级无尽;Ms,欧皇圣光,乐炅,不关枸杞的事;Mq,欧皇信仰;Mo,欧皇劣人,喵嗚不停;Mj,河边的悉达多",["霜之哀伤"] = "NL,堇丶忆;M9,野人参,必然的命運;M2,Mourningg;M1,Vergiliu;Mn,周杰倫;Mm,貓南北",["罗宁"] = "NL,丶沐雨澄风;NK,美眉啦啦队长;NH,廿拾贰;NF,剑落雪飞,丷青岛,夏夜风铃;NC,看不尽桃花;M9,葉小天,月之语風,梅心倾城;M7,史小维,过去的回忆丶;M6,丶醉绾青丝蛊,Alo;M5,战斗教科书;M4,光影十三城;M1,我不是帝凯;M0,大婶儿好粗壮;Mz,蓝染;Mx,惊鸿破,隐刺,初尘丶,震荡丨啵,知天风;Mw,南境野鬼,丷沉寂,Amenity,天涯逸;Mv,Tenderstill,鲜榨西瓜汁,盛夏的甜茶;Mt,最后一朵奇葩,Elfo;Ms,我不玩奶德,拉不住是菜,我不是战吊,元沐夕;Mq,Tzuheng;Mp,心允朵朵;Mo,真不知盘誰;Mn,谁有不平事;Mm,蛋蛋风风;Mj,保护我方鲁班",["熊猫酒仙"] = "NL,老孟莽的很,南木;NK,堕落中重生;NJ,腐中的神;M+,雪舞倾诚;M9,菲蕾娅莉莉丝,乄琉璃;M8,奔跑的钙片,摇滚喵;M6,雷茄尔;M1,天使萍萍;Mz,塞雷娅;Mw,缘字书,小赑屃,行简丶;Mv,非常;Mr,咕喵王丶;Mp,潶白;Mj,晴曛丶",["影之哀伤"] = "NL,终于可以了;NK,丨御坂美琴,与兽丶為伍;NJ,錦衣乄南笙,蔷薇花冠;NH,三寶丶,全团的饲养员,全团的荣耀;ND,狐狸先生灬,楚留香丶;NC,阿亮丶萌德;NB,Shigefashi,加拉哈德丶,萧墨丶印清秋;M9,美艳杀手托尼,乄彎彎,乄琉璃;M8,德不常湿乀;M6,有理别动粗;M4,和風;M1,零捌;Mz,不学无术,寒炉点雪,星星乄魔嘼,夜辰;Mx,丷璀璨星辰;Mw,为你卸甲;Ms,橙匕;Mr,清风扶醉月,斩杀了奶好我;Mj,闷人的狐臭",["万色星辰"] = "NL,游侠灬",["燃烧之刃"] = "NL,墨兽灬乘规;NJ,心想事成丶,石头超人;NI,Hayward,清流丶,七月半丶魍,天然元素;NF,咘丶快樂;NE,今朝丶今色,空尽月;ND,尤哆菈;NC,暴躁的龙爸爸;NB,浔泠,土豆炖牛肉灬;NA,修丶,千与千尋丶,火焰鼠不想乖,穂乃果;M/,Talnet,虔诚丶小麻雀,姑娘丶请自重;M+,丨暗色调丶;M9,余浪丶,Zhiqiu,想念富婆多年,灬五花肉丶;M8,演员周冬雨;M7,尘埃之末丶,丿阿莎鸦歌乀;M6,五花,雨枫;M5,范达尔丶凉皮,趁乱逃离宇宙;M4,蓝山梵云,依然尘封;M3,迷路的小麋鹿;M2,是谁的心阿;M1,油焖大瞎;M0,狐说八盗,往南,無锋丶,無相丶,無道丶,發財兽;Mz,俏皮的小猫咪,今夜的雨,为我卸甲丶;My,欲火玫瑰,情趣炎爆,开司,想做偷心贼丶;Mw,风影云歌;Mv,隐忍之殇,谁知我心,流氓鬼子,布伦斯塔德,吟嘚一首好湿,红领巾接班人,仔仔丶,来两串大腰子;Mu,哆咪;Mt,恶之魔,Milkteea,咪咪九九八,红发亞特鲁,炎爆术丶;Ms,萨萨;Mr,纯情小种马,困住的野兽;Mp,麥甜甜;Mo,没有奶的棍棍;Mn,蝎子丿莱莱,丶笑魇無她;Mm,小宝月;Mj,造梦小丶姐,Matildaa,豪横丶,新大陸的白風,一襟花月,牛牛小武僧",["鬼雾峰"] = "NL,耙耳朵诺维奇;NG,邪恶蓝星;NC,守望天穹;NA,影丸丶;M9,克苏奈;M1,深井病有好转;Mw,Yuh;Mp,妖孽丶",["熔火之心"] = "NL,似水鱼心;M3,北凤凰;M0,沖淡記譩;Mo,拳王的故事",["暗影之月"] = "NK,黯然飘渺;My,星星你个星星;Mw,轻轻的拟态;Mv,周大尖;Mj,凤年梧桐",["雷霆之怒"] = "NK,芜菁沙袋;NJ,梦中的哀嚎",["奥尔加隆"] = "NK,白花瓷;M2,悲情一世;Mz,浮生暮雨;Mj,枫与糖",["菲拉斯"] = "NK,Snavs;NC,花落丶水无痕;Mx,莉影随形",["风暴之怒"] = "NK,宝贝狼;NJ,青楼前徘徊;Mw,一天;Mv,久恋红尘",["迦拉克隆"] = "NK,艾莉的冷笑话;M+,变质的心态;M8,奇妙能力丶;M5,風雲天地间;M3,夜色繁星;M1,总监,小号协会一姐;Mw,牛盾戰士丨蓝;Mv,丶我见犹怜;Mo,不朽之王;Mm,靑沐",["洛丹伦"] = "NK,雷佳音;Mw,部落海盗",["主宰之剑"] = "NK,葛德米斯达;NI,慎思;NH,丶达令丶,凤兮丶;NG,墨宝宝;NC,偽善,青玉德呀,空条徐伦丶;M+,千代纸,塔奇米;M7,恶臭先辈,伊腾城;M5,丶晴空灬幽灵,丶晴空灬幽魂,待鴻雁南飛;M4,未知目标丶,樱桃紅;M2,柔情刺客,贡举人;M1,指間砂,一支德,勿念红尘;M0,夜灬依然,修普诺斯;Mz,拳打小萝莉;My,从那儿,蹄蹄呀,天堂黑曼巴,天涯明月;Mx,龍恨丨明月,都叫我包子,丿丨小怪兽;Mw,拾玖丷;Mv,冲锋接自爆,艾塞雷,黑加吉七夕;Mu,冰域,用萌感动部落;Mt,玥辰乄,魔剑阿波菲斯;Mr,崇文;Mo,只牵你的手;Mn,乌黑亮丽;Mj,山东大汉丶,使命救赎,馥馥芳蕤",["冰风岗"] = "NJ,德鲁丨,念一;NF,夏花一样绚烂;ND,一只哈士奇;NA,邪恶的胖浩;M8,Noend;M7,兰兰的天空;M6,暮光漫天;M4,尾花夏树丶;My,灬可达尛鸭鸭;Mw,纳兰香雪,李乡长;Mv,坏尔萨斯;Mo,Magebanes",["格瑞姆巴托"] = "NJ,似風沒有歸宿,炫乂復仇,尛嫩魔,踏雪亦悠然;NI,令无情;NH,阿克门德;NG,坨克萨;NF,仙女饿了,桑柔,天命丶玄鸟,辉月杏梨;NE,丨苏小苏丨;ND,憨壮壮,暗焰挽歌;NC,梅花落了南山,乡野小狐,清風煮酒;NA,丨牛哞哞丨;M+,大碗牛肉面;M9,冬丶无雨,乄雲潮楓汐,丨半步沧桑丨;M7,尨貓丶;M5,雷之怒吼,暖阳大魔王;M4,锋华;M3,零星白帆;M2,晨曦大魔王;M1,吃货丨嘚吧嘚,咸大鱼丶,一曲苏歌,神秘学友哥;M0,炎乄陽,炎丶陽;Mz,Vintner;My,烟锁池塘柳,一曲苏歌丶,绝了,荒宴丶;Mx,丢了翅膀的鱼;Mw,Caffeine,一大碗牛肉面,苏小苏乁,火鸡味锅吧,乄始终丿微笑;Mv,快乐小义义,梦魇于心乄,十三月的偑,叶酱丷,冲锋信仰;Mu,云雾散,苏瑶儿丶,尨貓灬;Mt,望穿丶;Ms,火鸡味锅巴,Asakalu;Mr,今夜前往繁星;Mq,Vintone;Mo,大哥棒棒哒;Mm,麻酱拌面;Mj,拯救迷路少女,贝尔丶阿迪克,小饭",["贫瘠之地"] = "NJ,嚎嗨哟;NH,黑風野牛丶;NF,人生须尽欢;NB,野丶風暴;M/,黑曜石骑士;M+,血灵鸟,天坑之魂;M8,箜筬;M7,Trex;M6,陈雨墨;M5,潍所欲沩灬,六合听封;M4,灬小乐灬;M2,狐萝卜乄,做有素质的人;M1,小马牛羊;Mz,无敌大漂亮,喵喵雪,穷哥们任冲丶;Mx,潜藏使徒;Mw,乌鸦笑猪黑,Onlyshadow;Mu,皮皮虾打篮球;Mt,Mortychen,谈爱恨;Ms,雾雨夜,花菜;Mr,萌闪闪;Mq,花江鲤;Mm,狐铁花",["布兰卡德"] = "NJ,浪漫撒加;M9,塔洛;M7,箭追魂;M6,邦宝湧,神泣猎;Mz,西门大关人;My,圣殒骑;Mx,黯纪丶画思凉;Mv,丶战撸;Ms,我渴了要喝水;Mq,詩經;Mo,Oshotokill,見得風是得雨,雪落下的声音",["永恒之井"] = "NJ,愿忧愁不再有;Mz,Misshunter",["希尔瓦娜斯"] = "NJ,壹叶知秋;NE,李桂芬;M0,灬旺丨仔灬,灬小青柠灬",["阿克蒙德"] = "NJ,小滴滴;M+,Waly;M6,剑气浪荡",["扎拉赞恩"] = "NJ,我喝大奶奶;M8,语心;Mv,紫风筝",["克尔苏加德"] = "NJ,铁骑丨后生儿;NI,叫我柳岩奶;NF,丶天师傅;NE,丨无为丨;Mu,鱼塘星女神;Mn,醒目可乐味",["阿拉希"] = "NJ,飞翔的荷兰饼;My,Bane",["伊森利恩"] = "NJ,梅花落了南山;NI,玉子酱,滑蛋鲜鸡粥;NH,浪漫太子;NF,有事找大锅,打酋长;ND,乄毒瘤;NC,沐羽橙風,沐雨橙風,荒野盗賊丶;M+,童鹿鹿;M9,微笑的她好美;M4,丶新月之痕,雾笑;M0,消融之雪,红豆黑米粥,调酒师;Mx,大资本家超梦;Mw,米板,炼狱狂牛,下雪嘞,丶南方蘑菇园;Mv,红星闪闪亮,淡忘的咒语;Mu,北方的北方;Mr,Tonight,灬暴丨君灬;Mo,套套,祸晴儿;Mm,逍遥水中月;Mj,認真對待一切,油炸嫩香蕉",["末日行者"] = "NI,Haddock,光头加暴击五,全场最佳镜头;NH,至高之魂;ND,劈腿;NB,小夜光,泰迪不玩奶,百年树袋熊丶;NA,你抓不到德,海洋龙卷风;M+,小面加蛋;M9,萌萌哒官人;M8,乔潴儿丶,虫貮;M2,敌乄法乄师;M1,白小可;My,大仙您真逗;Mw,去吧超梦梦;Mv,骑了一个士,一盛世美颜一,流云雪衣;Mt,喵三千;Mp,幽默不失离骚;Mo,黄旭西,曾经的安静;Mj,丁妮戈菲",["???"] = "NI,奥格包工頭",["血色十字军"] = "NI,巨龙咆哮,王炸炸;ND,Hugespot,薙切惠里奈;NC,Ftp,绿的你发慌丿;NB,污丶云;M8,夜煨丶;M5,丶妃色;M3,甜朵莉娜;M0,青莲剑意,Insisted,Insisting,無牧丶,秋风落叶酒;My,想喝特仑苏;Mx,可口可乐丶,萬箭齊發;Mw,Kevinhunter,范克里糊;Mv,大肉爱吃肉;Ms,梅发怒;Mp,烧糊的生花菜;Mn,小小茉莉丶;Mm,丶尛柒灬",["海克泰尔"] = "NI,抓个熊德;NH,四舅;M5,长此以往丶;M4,丶钥匙毁灭者;M1,无耻无罪;M0,没事多练练",["森金"] = "NI,榴芒小骑",["阿纳克洛斯"] = "NI,莉莉斯;M7,撒欢哦;Mp,羽流丶;Mj,阿远丶狂奔",["国王之谷"] = "NI,丨荆轲丨;NF,女神相沢南;ND,阿波克烈;NA,起名好几天;M+,王小豪;M3,忽然的嘟嘟;Mz,熊猫丶獸王猎,熊猫丶蛋刀舞,欧皇诺克灬;My,猴子大魔王;Mw,麦根儿;Mv,漠丶小然,我比從前快楽,曼珠沙华灬朮;Mt,任性大领主,末日決戰,溺死了过往;Mr,熊猫丶污妖王;Mp,离谱小白;Mo,来舔我饅頭嘛;Mm,丶二柱子,彩子丶;Mj,阿卡灬贝拉",["破碎岭"] = "NI,菲菲超人;M4,第二氧化碳;M0,神鬼桩",["恶魔之魂"] = "NI,复仇丶阿宝;Mq,猫仙女要抱抱;Mj,凉丶凉,花开一季",["阿尔萨斯"] = "NI,叶落尘封;NE,猫七吖;NB,如果你看见我;Mr,再见路西儿",["圣火神殿"] = "NI,橙子皮",["回音山"] = "NH,雀实很嗨;NC,青菜小汤汤,牛奶你爱吗丶,青稞丶雷;M9,哎呦嗨哎呦嗨;M5,丶长泽雅美,宝贝土豆;Mz,上条灬当麻,悲離;Mx,冷月天行;Mv,似是故人来;Mt,云岚;Mq,小黄骑;Mo,樱岛麻衣酱;Mj,滑蛋牛柳",["沙怒"] = "NH,黄杜鹃血族",["幽暗沼泽"] = "NH,桥本爱;Mn,谁叫我胖虎",["艾森娜"] = "NH,钢然小猎,钢然战神,钢然图腾",["诺莫瑞根"] = "NH,拝頭茻哀木梯",["诺森德"] = "NH,为何放弃治疗;M8,路之遥;Mo,凤箫吟",["远古海滩"] = "NH,破釜沉舟;M0,万丰小姚静",["海加尔"] = "NG,Mara",["伊瑟拉"] = "NG,永真;Mu,依瑞爾;Mt,布鲁斯大爷",["狂热之刃"] = "NG,夜之盗圣;Mv,根本丨不瞎,根本丨美丽,小孬猪,根本丨英俊;Mp,墨淺灬南筏",["丽丽（四川）"] = "NG,沉梦扬志;ND,Maievsong,冰冷的茄子;M+,丿雪霁;M8,决战丶丶;M3,腿毛怪叔叔灬,腿毛怪叔叔丶;M0,童心,净琉璃;My,阿多科克;Mw,刘劈;Mv,刺穿吧丶獠牙;Mr,夏沫丶浅雨;Mp,戎州张家辉,倚林醉;Mo,清风拂杨柳丶",["金色平原"] = "NG,坏坏;M9,幸运咕;M8,福星,嬉皮;My,羞涩小女人;Mt,哎喽微,哒卜妞;Mp,彡咻咻彡",["埃德萨拉"] = "NF,卡莉熙丶,典庆,满地腐蚀瓜;NE,黑灵星官,东厂牛千户;NB,但丶丁,肉山小魔王;NA,齐齐大恶魔;M+,小蛀牙;M5,风月不等闲,小色拉;M4,小五森;M1,冒泡的芬达;M0,圈圈丶二意,禅丶武;Mx,乡间河太急;Mw,烟花丶小喵;Mq,啊宝,哥歌,大饼干灬,大饼干;Mj,烟花小喵",["古加尔"] = "NF,Edison",["卡德加"] = "NE,Lifaniy;M0,沙朗血蹄",["影牙要塞"] = "NE,李二公子",["亚雷戈斯"] = "NE,Paladino;M0,廊桥遗梦;Mo,丨神乐",["灰谷"] = "NE,跟着老子冲;M5,暗雪森林;Mr,米琳达",["燃烧平原"] = "NE,妖兽雅篾蝶;M7,搞不清楚",["壁炉谷"] = "ND,内涵段子;Mn,天生一水",["冰霜之刃"] = "ND,放放速度放了;NC,尐灬諾殇;Mw,嘧咖嘻,求真务实;Mv,煞萌,Mambagh",["红龙女王"] = "ND,信念之河",["黑锋哨站"] = "ND,死判丶化龙",["巫妖之王"] = "ND,超烦之萌;M1,外卖来了;M0,Vivi;Mw,鸢漓丶牧牧;Mv,Daoder",["燃烧军团"] = "ND,丶瘋言宿语",["达基萨斯"] = "ND,小芭芭拉",["风行者"] = "ND,竹葉清風;M8,Galleon",["血环"] = "NC,单纯的阿俊;NB,妖丨紅紅;My,痞痞丶德;Mj,西城阿哥",["普瑞斯托"] = "NC,想念安琪儿",["夏维安"] = "NC,南风知我意;M8,一杯奶昔,羊路西",["加尔"] = "NC,情系江南",["火焰之树"] = "NC,大铁棍子",["萨菲隆"] = "NC,豪佬",["阿古斯"] = "NC,逆袭的大香蕉;M+,横店群头儿;M6,衩裤;M5,打喷嚏,幻夜无月;Mv,哈库納玛塔塔;Mr,螭吻丿,阿克萌德丿;Mq,雨灬",["拉文霍德"] = "NC,绫濑遥",["龙骨平原"] = "NB,卻道天涼;M9,克劳德莫奈;M7,成敏;M0,奔跑的黑牛;Mx,不打我中不中;Mw,罗素;Mn,陈丶疯爆劣酒",["鹰巢山"] = "NB,红肚兜丶",["试炼之环"] = "NB,聆听丶音域;Mn,暗丶魂乡",["洛萨"] = "NB,苟二蛋",["丹莫德"] = "NA,管中窥膝;Mp,聪少爷的箭丶;Mm,老牛牛波",["达斯雷玛"] = "NA,丨灬艾琳娜丶",["踏梦者"] = "NA,追梦可乐幽",["奥特兰克"] = "M/,锤锤呀,小纯洁呀;M+,大咸鱼翻身;M5,阿鲁法尔;M3,Deathbleach,Shadowlands,Donoharm,Lhd;Mz,悲離;Mv,路人逆天,张好古;Mn,可道可名",["迅捷微风"] = "M/,暗翼灬;M2,我爱大珑,Leonheart;Mx,乄污喵王;Ms,音樂老師",["烈焰峰"] = "M/,Youths;M6,兰纸鸢;Mw,花间一壶酒丶",["朵丹尼尔"] = "M/,但用此心",["暗影迷宫"] = "M+,邪丶心;M9,露西亚蕾蒂",["石爪峰"] = "M+,吹哔哔",["艾萨拉"] = "M+,懂事",["白骨荒野"] = "M+,嗨丶妳的潘婷",["冬泉谷"] = "M+,所爱一生",["黑铁"] = "M+,姬淮;M5,西禅寺小五郎;M2,椛間壹壶酒;M1,吥髙興;Mj,小狂牛",["奥拉基尔"] = "M9,有尸必有得;M5,大理寺卿;Mv,戴小狼",["红龙军团"] = "M9,花落繁",["安威玛尔"] = "M8,喔抱歉",["黑龙军团"] = "M8,我不是好人;M7,Rebirth",["耐奥祖"] = "M8,孤寂星火",["神圣之歌"] = "M8,小朱朱;M2,Cambridgeii;Mt,小土豆丶恶魔;Ms,浮世沉香;Mr,Overous",["梦境之树"] = "M7,Bubbletea",["黑暗之矛"] = "M7,暗芝居",["雷霆之王"] = "M7,丨丶墨冥;Ms,三级腐蚀",["凯恩血蹄"] = "M7,高育良",["瓦里安"] = "M6,虚空之女",["加基森"] = "M6,张佩佩;Mj,杜兰达尔",["伊利丹"] = "M5,结遍兰襟;Mv,不死亡魂,不死猎魔;Mm,不死亚瑟",["达纳斯"] = "M5,杨建玲;Mz,丨鬼刀丨",["法拉希姆"] = "M5,龍潇潇",["天空之墙"] = "M5,桐生一馬,丶晴空灬元宝;M4,丶晴空灬沉香;Mu,丶晴空灬燃烬;Mm,聽不語",["甜水绿洲"] = "M5,國際噤區,丶晴空灬禁區",["埃加洛尔"] = "M4,龙逸轩;My,艾斯",["加兹鲁维"] = "M4,胖虎虎;Mv,半夕蝶梦",["安加萨"] = "M3,麻辣香锅",["熵魔"] = "M3,疯人院的惡魔",["泰兰德"] = "M3,断戟灬;M1,萌小匪;Mz,幽兰旋老;Mw,尐海風",["符文图腾"] = "M2,丨恋丶倾城",["地狱之石"] = "M2,Nanmerry;Mv,狐人总灌君",["风暴峭壁"] = "M2,一天多一点,莎啦嘛碧痴",["石锤"] = "M2,懒牛牛",["水晶之牙"] = "M1,酷炫",["阿比迪斯"] = "M1,阿鲁巴之手",["塞拉摩"] = "M1,不太正常;Mw,艾星漫游指南,跳氘,时光的荏苒;Mv,从前有个灬贼",["阿扎达斯"] = "M1,不会审判",["菲米丝"] = "M0,飞翔的荷兰牛,孢子蝠",["末日祷告祭坛"] = "M0,奇怪的猫;Ms,文沐沐,王俊凯嘤嘤",["诺兹多姆"] = "M0,少池先生;Mw,天蝎座大德;Mj,苇渡江安公子",["太阳之井"] = "M0,蒙塔基钢蛋儿;Mv,口无丨遮拦;Mj,唯伊",["刺骨利刃"] = "M0,肥胖的胖子;Mn,无敌干涉",["蜘蛛王国"] = "Mz,猫咪先生;Mr,紫影儿",["血吼"] = "Mz,黛楼儿",["寒冰皇冠"] = "Mz,巨型苍穹;Mn,天道茫茫",["银松森林"] = "Mz,蓝琪儿",["世界之树"] = "Mz,六独天缺丶",["能源舰"] = "Mz,屋里几个蛮娜;Mp,大圣",["奥蕾莉亚"] = "My,孤独红狼",["洛肯"] = "My,不吃柠檬",["月神殿"] = "My,君水卿;Mt,土豆皮儿;Ms,樱桃之祸",["艾露恩"] = "My,Wildlife;Mv,漪萝君",["祖阿曼"] = "Mx,监狱大姐",["战歌"] = "Mx,囚灵;Mq,Goldberg",["克苏恩"] = "Mx,啾啾的小星星",["艾欧娜尔"] = "Mx,影歌",["萨尔"] = "Mx,霻仐;Mv,小狂;Mt,Scottsummer",["黑暗之门"] = "Mx,软趴趴的熊猫",["雷斧堡垒"] = "Mx,拉风的拉拉",["伊萨里奥斯"] = "Mw,盲区行者",["索瑞森"] = "Mw,北极小狐",["风暴之眼"] = "Mw,愛仩愛啲菋噵",["玛里苟斯"] = "Mw,布德鳥;Mr,北冽鲸涛",["艾维娜"] = "Mw,芳心纵火犯",["永夜港"] = "Mw,华语乐坛坛主;Mu,Bluzzer;Mr,舟",["卡拉赞"] = "Mv,咖喱黄不辣",["通灵学院"] = "Mv,严禁喂食",["暴风祭坛"] = "Mv,有奶便是娘啊",["巨龙之吼"] = "Mv,暮光毁灭射线",["千针石林"] = "Mv,杜姆",["麦迪文"] = "Mv,巅峰阅读,沧桑面容",["桑德兰"] = "Mv,我的不锈钢锅",["安东尼达斯"] = "Mv,微笑舞步",["伊兰尼库斯"] = "Mv,针灸坚持游戏",["托塞德林"] = "Mu,铁柱",["古尔丹"] = "Mu,哆多",["血牙魔王"] = "Mu,聖光忽悠着尼,非洲小龙瞎,江狐筱贼",["自由之风"] = "Mt,Baintha",["范达尔鹿盔"] = "Mt,不怕不怕你",["卡德罗斯"] = "Mt,鲜艳的红领巾",["暗影议会"] = "Mt,跳跳神牛",["黑翼之巢"] = "Ms,喜庆",["黑手军团"] = "Ms,大象优雅",["木喉要塞"] = "Mr,苦胆",["翡翠梦境"] = "Mr,养多肉的浣熊",["聖光之願[TW]"] = "Mq,Aasiyah",["希雷诺斯"] = "Mq,达芙妮",["奈法利安"] = "Mp,拂浪影山川",["凯尔萨斯"] = "Mp,Galahad",["阿迦玛甘"] = "Mp,一样",["血顶"] = "Mp,白琰",["奎尔萨拉斯"] = "Mp,淡定的阿雅",["迦玛兰"] = "Mo,Deloco",["麦维影歌"] = "Mo,泡椒小花生",["密林游侠"] = "Mo,软子夜壶丶",["提尔之手"] = "Mo,安杜尼苏斯",["天谴之门"] = "Mo,瘦丿西风",["荆棘谷"] = "Mo,诺凡;Mm,大叔做不到",["米奈希尔"] = "Mo,拾步殺壹人",["梅尔加尼"] = "Mo,宝贝妮子",["克洛玛古斯"] = "Mm,小圆",["嚎风峡湾"] = "Mj,爆狂",["尘风峡谷"] = "Mj,狂野小魔星",["鲜血熔炉"] = "Mj,游若阑",["风暴之鳞"] = "Mj,張公子"};
local start = { year = 2018, month = 8, day = 3, hour = 7, min = 0, sec = 0 }
local now = time()
local player_shown = {}
U1Donators.players = player_shown

local topNamesOrder = {} for i, name in ipairs({ strsplit(',', topNames) }) do topNamesOrder[name] = i end

local pairs, ipairs, strsplit, format = pairs, ipairs, strsplit, format

local players, player_days = {}, {}
local base64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
local function ConvertDonators(day_realm_players)
    if not day_realm_players then return end
    for realm, allday in pairs(day_realm_players) do
        for _, oneday in ipairs({strsplit(';', allday)}) do
            local date;
            for i, player in ipairs({strsplit(',', oneday)}) do
                if i == 1 then
                    local dec = (base64:find(player:sub(1,1)) - 1) * 64 + (base64:find(player:sub(2,2)) - 1)
                    local y, m, d = floor(dec/12/31)+2018, floor(dec/31)%12+1, dec%31+1
                    date = format("%04d-%02d-%02d", y, m, d)
                else
                    local fullname = player .. '-' .. (realm:gsub("%[.-%]", ""))
                    if player_days[fullname] == nil then
                        table.insert(players, fullname)
                        player_days[fullname] = date
                    end
                end
            end
        end
    end
end
local function GetPlayerNames(day_realm_players)
    if not day_realm_players then return end
    for realm, allday in pairs(day_realm_players) do
        for _, oneday in ipairs({strsplit(';', allday)}) do
            for i, player in ipairs({strsplit(',', oneday)}) do
                if i > 1 then
                    local fullname = player .. '-' .. (realm:gsub("%[.-%]", ""))
                    player_shown[fullname] = topNamesOrder[fullname] or 0
                end
            end
        end
    end
end
GetPlayerNames(recentDonators)
GetPlayerNames(U1.historyDonators)

function U1Donators:CreateFrame()
    ConvertDonators(recentDonators)
    recentDonators = nil
    ConvertDonators(U1.historyDonators)
    U1.historyDonators = nil

    table.sort(players, function(a, b)
        local order1 = topNamesOrder[a] or 9999
        local order2 = topNamesOrder[b] or 9999
        if order1 ~= order2 then return order1 < order2 end
        local _, r1 = strsplit("-", a)
        local _, r2 = strsplit("-", b)
        if r1 ~= r2 then
            if r1 == '???' then return false
            elseif r2 == '???' then return true
            else return r1 < r2; end
        end
        local day1 = player_days[a]
        local day2 = player_days[b]
        if day1 ~= day2 then return day1 > day2 end
        return a < b
    end)
    -- 排完序就不需要了
    topNames = nil
    topNamesOrder = nil

    local f = WW:Frame("U1DonatorsFrame", UIParent, "BasicFrameTemplateWithInset"):Size(320, 500):TR(U1Frame, "TL", -10, 0):SetToplevel(1):SetFrameStrata("DIALOG")

    f.TitleText:SetText("爱不易的捐助者，谢谢你们")
    f.InsetBg:SetPoint("TOPLEFT", 4, -50)
    CoreUIMakeMovable(f)

    local scroll = CoreUICreateHybridStep1(nil, f(), nil, true, true, nil)
    WW(scroll):TL(f.InsetBg, 3, -3):BR(f.InsetBg, -2-21, 2):un() --:TL(3, -20)
    f.scroll = scroll

    local headn = TplColumnButton(f, nil, 22):SetWidth(108):SetText("玩家主角色"):SetScript("OnClick", noop):un()
    WW(headn:GetFontString()):SetFontHeight(14):un()
    local heads = TplColumnButton(f, nil, 22):SetWidth(80):SetText("服务器"):SetScript("OnClick", noop):un()
    WW(heads:GetFontString()):SetFontHeight(14):un()
    local headd = TplColumnButton(f, nil, 22):SetWidth(100):SetText("捐助时间"):SetScript("OnClick", noop):un()
    WW(headd:GetFontString()):SetFontHeight(14):un()
    CoreUIAnchor(f, "TOPLEFT", "TOPLEFT", 8, -30, "LEFT", "RIGHT", 0, 0, headn, heads, headd)

    local function fix_text_width(obj)
      obj:GetFontString():SetAllPoints()
    end

    scroll.creator = function(self, index, name)
      local row = WW(self.scrollChild):Button(name):LEFT():RIGHT():Size(0, 20)
      row:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]], 'ADD')

      row.name = row:Button():Size(100, 20):EnableMouse(false):SetButtonFont(U1FCenterTextMid):SetText(111):GetButtonText():SetJustifyH("Center"):up()
      row.server = row:Button():Size(75, 20):EnableMouse(false):SetButtonFont(U1FCenterTextTiny):SetText(111):GetButtonText():SetJustifyH("Right"):up()
      row.firstdate = row:Button():Size(90, 20):EnableMouse(false):SetButtonFont(U1FCenterTextTiny):SetText(333):GetButtonText():SetJustifyH("Right"):up()

      fix_text_width(row.name)
      fix_text_width(row.server)
      fix_text_width(row.firstdate)

      CoreUIAnchor(row, "LEFT", "LEFT", 5, 0, "LEFT", "RIGHT", 5, 0, row.name, row.server, row.firstdate)
      return row:un()
    end

    scroll.getNumFunc = function()
      return #players
    end

    scroll.updateFunc = function(self, row, index)
      row.index = index
      local name, realm = strsplit('-', players[index])
      row.name:SetText(name)
      row.server:SetText(realm)
      row.firstdate:SetText(player_days[players[index]]);
      --row.name:GetFontString():SetTextColor(1,1,1)
      --local date_fmt = '%Y/%m/%d'
      --local txt = date(date_fmt, time())
      --row.firstdate:SetText(txt)
    end

    CoreUICreateHybridStep2(scroll, 0, 0, "TOPLEFT", "TOPLEFT", 0)

    f:Hide()

    collectgarbage()
    return f()
end

CoreOnEvent("PLAYER_ENTERING_WORLD", function()
    local origs = {}
    local addMessageReplace = function(self, msg, ...)
        msg = msg and tostring(msg) or ""
        local h, t, part1, fullname, part2 = msg:find("(\124Hplayer:(.-):.-:.-:.-\124h%[)(\124c.........-\124r%]\124h)")
        if fullname and ((U1Donators and U1Donators.players[fullname]) or (U1STAFF and U1STAFF[fullname])) then
            --local _, height = self:GetFont()
            msg = msg:sub(1,h-1) .. part1 .. '\124TInterface\\AddOns\\!!!163UI!!!\\Textures\\UI2-logo:' .. (13) .. '\124t' .. part2 .. msg:sub(t+1);
        end
        origs[self](self, msg, ...)
    end
    WithAllChatFrame(function(cf)
        if cf:GetID() == 2 then return end
        origs[cf] = cf.AddMessage
        cf.AddMessage = addMessageReplace
    end)
    return "remove"
end)