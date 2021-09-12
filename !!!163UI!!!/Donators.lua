local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["罗宁"] = "Vf,墨华,盞茶作酒;Vd,伊利瑟维斯;VZ,川西北大拿;VV,雅詩;VS,雲潇;VP,訫术不正;VO,潼潼,苏流云;VM,绿水绕东城;VJ,龍嶄,Switch;VH,邵奕文;VG,大爱小姝;VF,光学显微镜,折戟尘沙丶;VC,丨灬拂曉丶;VB,桐剪秋风;U/,月下夜想曲;U+,Tanzerin;U9,盏茶作酒,托马斯瑞恩;Uy,希尔维纳斯;Uu,大隐士;Ut,影之歌猎,伪造的幸运币,恋死;Us,君不灭,仇剑橙;Uq,南宫嘤嘤;Up,资本家;Ul,月之灼灼;Uh,在雨中;Ug,陈年风缕;Ub,溫蒂丶瑪貝爾;Ua,夏天的棉花糖,肆意弥漫;UZ,师兄,鸡蛋唉;UX,杰丽蜜",["伊莫塔尔"] = "Vf,舒预言",["白银之手"] = "Vf,血腥战歌,云中寄雨;Ve,彼麦凯蒂丶,Shanbaby,冰冰水冰;Vd,小小心脏,Ntmdjjww,壹贱定天下;Vc,封尘絕念斬;VY,小喵弯月;VV,老板来碗凉面,叶奈法的玩具;VT,名猎潘潘;VR,雀食有手就行,韵逐律,轻歌夜语;VN,这不有手就行,丨不二亅,酷酷的熊猫;VM,战果;VL,封存守护;VK,妖乀月;VJ,糖醋萝莉,叶青筕;VI,丿熹微丶;VH,愤怒的暗影骑,沽沽蛋,乄褪色棏幻梦,尤烈烈,Aquamanpao;VG,带你就黑了,丨萧炎;VF,榜一大锅,青春已逝去;VE,小废虾皆伞兵,梦境之塔,不吃鱼丷;VD,李啾啾,贼男;VC,三月晚风;VB,迦楼特;VA,双島;U9,逆風花狐,圣光粉;U8,星骓;U7,宸之雲漢;U6,嗷呜看箭,兜兜里有薬,丿阿丽塔,Hadam,爲暧絾殇,阿坡丶二;Uz,江津尖椒鸡;Ux,是的我叫乔丶,是的我叫乔;Ut,火箭熊,強手裂顱;Us,魅力小丫丫,风怒丿;Ur,杜妮妮,夏曰果果;Up,你好我叫乔;Uo,炭烤鹌鹑丶;Un,欧德莉娜,云卧北溟,云卧北凕,雲卧北冥,云臥北冥,云卧北冥,血色乄杀戮,神聖復仇者;Um,咪咪丶咪咪,蒙泰极;Ul,化瞳,丨风迟丶,苍穹天击;Uk,相乐左之助;Uj,信仰圣光叭丶,李啾啾丶;Ui,古尔达雷;Uh,末世,I深海大鲨鱼;Uf,微醺少女的梦;Ud,风吹淡淡凉;Uc,这是女鬼,安小魔王,Themis,沫若君上尘;Ub,温斯頓,狸笙,死亡之咸猪手;Ua,賊胖胖;UZ,沈夜,花菜炒西红柿;UY,飒珥,玄可改命,宝贝美智子,左眼看不见;UX,丶神祇,灬吞吞",["伊森利恩"] = "Vf,桃溪春野;Vd,小小波哥丶;Vb,机智的大叔;Va,执笔绘苍穹;VX,冷月丨;VS,沙漠可汗;VR,真我的風采;VP,永猎;VN,灬增强萨满灬,战死桌头;VL,血㐅狂猎;VI,冷月贼影;VG,极限读条;VF,仁兄,月灵光星;U7,囍馨;U6,Salang,独自去偷歡,古尔达雷;Ut,灬夏雨芊芊灬;Ur,嘻嘻力;Um,甜水;Ul,雪茶;Uj,好喝的冰阔洛;Uf,慕法沙,伯爵茶曲奇;Ud,薪火余灰;Uc,头头君;Ub,下沙黄旭东;UY,你踩到我了,孤山",["瑟莱德丝"] = "Vf,懒癌晚期凉凉",["死亡之翼"] = "Vf,拒绝我都被绿,Jeromecc;Vd,杨扬采,仙晨之灵,Lixm;Vc,醉后,老淦部,梦幻彤凡;Vb,发飙的天牛;Va,夜阑听雨丶;VZ,刃命,没教养的瘤;VW,莽斧,南宫仆射灬,梦醒九分丶,油油的小绿皮;VU,东北黄辉冯;VR,有一点点疼,包西;VP,牛米花,诸葛言叶,愿圣光强迫你;VO,冷面玉枫;VN,雲煙一梦,荆芥捞面;VM,创世僧,老衲法号肥圆;VK,月下花轻舞,凯恩宁;VJ,小红按钮;VI,漩涡鸣牛;VH,希望与绝望间,塔玛玛,帝国烙印;VG,丿章鱼哥,专业回春术,六九式;VF,北斗丶玉衡星,夜火丶,青城雪芽,Charprime,灬指尖旋律灬;VD,百戦丨山河,水流年,雯丶浩浩;VB,马冬梅丶丶;VA,甜蜜儿;U/,丶天亮了,雨的印记丶;U9,滴露洗手液,陶师傅,钻探队大队长;U8,戰無魂;U7,三泽大地,Kesx,想养波斯;U6,低保混子阿胖,躺尸消嗜血,粉紅的子彈,倾风雪;Ux,独孤旧箭;Uu,淘气乌龙,Raymadness;Ut,一级建筑师,师傅多放香菜;Ur,飒沓如星;Uo,三勺氮泵;Um,牲口酱一术;Ul,祸神;Ui,吸血鬼寶寶,沙盘上的痕迹,佑枫骑士,塔琪米;Uh,独釣寒江雪,布鲁克克,Cats;Ug,Lyzx;Ud,那墨丶,芬达芬达;Ub,丨熊貓丶;Ua,嫁昼,原味鸡好好吃,麦辣鸡好好吃;UZ,佑枫战刃;UY,娶水,Juventusa,你知不知道啊,仲未死;UX,噼哩啪啪,米小妖",["格瑞姆巴托"] = "Vf,琴断弦难断;VY,Aoekaizibao,狂派丨迷乱;VP,星之迟迟;VN,布兰卡桥,加十份珍珠;VM,雯丶浩浩;VL,迪兰妮圣歌,丶神灬殇丶;VK,BloodLoong;VJ,处牛;VH,一笑华年,希尔丶瓦娜思;VF,洒了嘿呦;VE,吹着比灭团了;VD,弹键盘的主唱;VB,新奇士,一块小饼干丶;U6,小璇璇的璇;Uy,Magister;Uv,幕天席地;Us,刘浩存丶;Up,丨小野槑子丨;Uo,寒蔷;Um,华蓥山土匪;Ug,希尔丶瓦纳思;Ud,灰十八;UZ,灬小甜甜灬;UY,紫薯布丁丶",["血牙魔王"] = "Vf,Mojiedjlr;Vc,七叶一枝花妖",["凤凰之神"] = "Vf,天涯觅青鸾,焦嘦嘦,于子酱,小猪佩鱼丷;Ve,自然醒吧,鸣剑;Vd,背影余晖,谜灬失,尤川丶蚩梦,丶对钱没情趣,夜半月听风;Vc,槐琥,阳顶顶丶,拿枪的老牛,熊卟贰,风寂笑,火龙果冻,愤怒毛驴;Va,尐软;VY,南京扣德普雷,伊斯嗒娜;VX,超烦之萌;VU,渡鸦有情丶;VT,幸运星星,昭灬飞燕;VS,雪物语,景依维,灰猫缪缪,娜之翼;VR,艾泽丨瑞尔,艾泽瑞尔丶;VQ,百撕不得騎妹,将君,浪徒;VP,克吕涅恩;VO,芊茗静语;VN,Bigrain;VM,薩喵;VL,家有一宝丶,糖僧小友;VK,和風,渣渣战,大箭客,梦想抓只咕咕,鈊訫缃茚丶魅,湖畔镇的晨曦;VJ,圣光依然闪耀,狗蛋代价是啥;VH,欧墨涅厄斯,万灵七愈合,黄泉幽夜;VG,毛球玩沙沙;VF,老韩抽根烟,愈合无助,Lenora,风唏笑;VC,就这灬,丶白爷;VA,蓝胖灬,就想想一想;U/,喵喵的奶猫丶,哞哞的奶牛;U+,东北大电耗子;U9,好喝的冰阔洛,我系真滴猛,先生丶德;U8,雅尓贝德,电弧萨萨,疯峰,畜电啦;U7,野比大雄丶;U6,苏灬夏,馥笍白,和风醇韵,蓝鲸炮王,野味收藏者,懒惰丶;Uy,Evalovbb,飞天流,聖灬騎士;Ux,痛风小能手,抹了油的野居,猪头开水烫,士灬官丶长;Uw,马老板之怒;Uv,Gaberier;Uu,胡安安;Ut,Feathergray,灬安慕兮灬,我天天喝旺仔,阳灮丶,嘉合;Us,远山的呼唤;Ur,枯樹年华;Un,撑伞接泺花;Um,紫云丶;Ul,我是鱼啦,灬黒宊白灬;Uj,Redsoul;Uh,嗷嗷熊,陌伤心,周么么;Uf,南美大虾;Ue,迷秋兔,墨小白;Ud,阿卡姆青年;Uc,柠檬酸不甜,Goodlucktome;Ub,莉莉丶柯林斯;UZ,猴子的血,热情,有钱通其道;UY,猴子涌波;UX,尐鹿斑比,嗜酒仙,裂开的李奶奶",["普瑞斯托"] = "Vf,一念丹香;VS,暗鸦",["诺森德"] = "Vf,无限正义",["安苏"] = "Vf,南吕五日;Ve,丨我很纯洁丶,至尊丶牛犊子;Vd,林楚儿,马大漂亮;Vc,嗨尼玛嘴硬,英雄出少女;VY,猫耳娘丶;VU,浩浩上课;VT,二两桃花下酒;VS,丨希尔瓦拉斯;VO,清扬无懈可击,颤抖吧年輕人;VH,凯恩丶血蹄丨;VG,小朋友的瞳;VF,鹿小玖,Zilililiz;VE,丶命硬;U8,小朋友的书;Ux,素颜伴离兮;Uv,Sè,根;Ut,就打咕;Us,佩内洛丶光蹄,小李阿丶;Ur,雷奥力法;Uq,魅小绫;Ui,专打布洛洛丶;Ue,千瓷;Ud,无尽的虚无;Uc,丷格调丷;UX,多肉葡萄好喝,冲丶鸭,暗影沚殇,可爱点点",["冰川之拳"] = "Vf,寶貝卟哭",["燃烧之刃"] = "Vf,始终怀念;Ve,议事厅哭强战,黄黄皇帝;Vd,尛噩夢,大奶猴也算猴;Vc,辛多雷强哥,霜火挽歌丶;VV,闪开我要装逼;VT,曾经的念想;VS,Tirionfordri,撐伞接落花,明月伴清风;VR,无敌小悠悠;VQ,氿月;VM,鹤丶;VI,叄一,沉淀灬;VH,牙床磨豆腐;VG,寂寞爱唱歌;VF,辛丶梓婉,红名怪,悲伤的猪大肠,菰獨絾殇;VD,崶訫惢暧;VC,大长老;VA,瘾大发高烧;U/,葑鈊锁嗳;U9,摸啪滚打;U7,热心市民寒哥;U6,望月芽心,噗通喵,蹭蹭丶不进去,圣光快闪;Uz,诱人的黄豆;Uy,仓三岁;Ux,Deathshura;Uw,我烤熟可香啦,小风那个吹;Uu,我信你个鬼丶;Ut,青岩卤猪脚丶;Us,丨小苹果丨;Ur,皮皮貓,逝去的海;Uo,暴躁的龙爸爸;Um,奶猴也算猴;Ul,饭特息,墨汐浅醉红颜;Uk,随风壹笑;Uj,电竞奥拉夫;Ui,婧瑜儿;Ue,丿小白去;Ud,曲终人又散;Uc,胸小垫硅胶,崔斯特尔,塔里克尔,Littlebobby;UY,丿苙宝乁,蒋晨晨",["阿古斯"] = "Vf,贺豪豪;Uk,刹那成永恒;Ui,好风凭借力;Ub,剑盾之舞",["无尽之海"] = "Vf,犇頭德撸衣;Vb,Rossoneris;VZ,带带丶;VW,牧云;VN,铭晨而醉;VM,七海麻美;VL,臭妹妹羞羞脸,獨壹無貳;VH,江水为竭;VE,入戏三分;VD,小熊栗子丶;U9,不覚;U6,艾歐利亞丶,拾穗,抽烟烫头;Uz,麻雀儿;Uy,蒙牛丶未来星,明晨而醉;Uu,凹凸丶;Us,大叔也不错;Uh,一颗草莓;Ud,疾影的鸟;UX,圣光下打伞",["海克泰尔"] = "Vf,林深鹿幽鸣;Vc,机智的大叔;VH,你那丶小样;VF,能量一星,众乐乐丶;U+,休闲小狐猎;U7,浮生星曦;Uw,温柔你一脸;Uk,朗姆莫吉托;Ua,诺登斯",["影之哀伤"] = "Vf,狂躁方向盘;Ve,沾血的黃瓜;Vc,天秀阁;VW,繧儱兄;VS,别死丷;VR,请叫我奶糖;VQ,信曾哥得永生;VL,腚小皮就薄;VJ,星河里的鲸;VH,蒲噗噗;VG,放火烧太阳;VF,Hunternine;VE,君灬怜月;VC,哇塞不哇塞,丶错过;VB,凝望灬大地;U7,橙色胖头咕,正义小红帽;U6,晴請晴晴天丶;Uv,阿白的鱿鱼;Ut,丨黎明审判丨;Um,灵魂行者黑吊;Ul,御姐好风骚;Uk,星漾;Uh,爱马仕;Ug,朔云满西山;Uf,不化骨丶;Ua,打电动;UY,麻辣香鍋",["霜之哀伤"] = "Vf,卡其布诺灬;Vd,青年蜀黍;VS,杭椒排骨烧;VO,板斧速递;U6,回憶傷痕,断剑残觞;Ut,肉奥;Us,张小轩小朋友;UX,林加德",["国王之谷"] = "Vf,留痕;Vc,一凤;Va,战士雍杰大叔;VZ,仲长胤;VJ,白鸾;VG,橙色的布尔;VE,箫声惊暮蝉;VB,假靈;U8,暗夜德其它徳;U7,苍岚的昏;U6,倾城风铃;Uw,画画惜;Us,香蕉灬皮皮,福莱特的世界;Uo,沉着的小蓝莓;Um,橙吉思涵;Uk,Bbrother,托马斯塞亚;Ug,晓美焰;Ub,羚羊角;UX,吾歌",["巨龙之吼"] = "Vf,馮巩老師丶",["贫瘠之地"] = "Vf,狂魔㐅乱舞;Vd,珊瑚海;Vc,余悸,Avicii;Vb,丶毒;VZ,风起寒秋;VI,暮云寒烟;VH,我叫水哥;VF,叮叮车,Rsoo,牛柒柒;U9,以德丿负人;U6,玄元,疋杀灬地藏,流刃灬若火,小度;Uy,青花眸;Ur,天诛;Uk,布偶熊;Uj,甲贺,小神猪;Ui,Fantacola;Ug,熬夜夜丶;Ud,Hkdoll;Uc,重庆胖胖,九曜丨;Ub,晚来风急,凛冬猎手,长街长丶;UY,烂名字想半天",["迦拉克隆"] = "Ve,二叔灬;VU,丿冥水丶;VJ,耀世尘;VE,魔力灬转转圈;VD,丨炘南丨;Us,尛心丶;Uf,罗本无解内切",["奥妮克希亚"] = "Ve,伽罗丶六道",["寒冰皇冠"] = "Ve,牛克蒙德",["月光林地"] = "Ve,白兔软糖;VS,Eurusholmes",["主宰之剑"] = "Ve,暗殺星;Vd,冰煌血舞;Vc,球丶;VY,Orionsuio,终焉恩赐,梦里是谁,冯珍珠;VX,娜依秀美;VW,Sicklikeme;VR,白丶苏;VP,梦小舞;VO,丶死亡华尔兹,北炙;VM,周冬雨;VL,灬可可;VH,伤尽天下母牛;U+,Skyland;U8,混元子大师;U7,伊布丶丶,猫咪王;Ux,松酱;Uv,黑翼降临;Ut,吾辈何以装逼;Up,轻语的风;Uo,清风雨;Um,白月魁丷;Ue,徳天独厚;UZ,配合你的演出;UX,艺兴",["自由之风"] = "Ve,黑枸杞",["风行者"] = "Ve,蔡萌萌;VD,灬烣烬渖判灬;VB,德克萨斯之手",["冰风岗"] = "Ve,萌萌哒滴萌萌;Vc,天选之子,月玄孤心;Va,洗尽凡间铅华;VV,哆啦比梦;VK,妙脆角斗士;VH,瞎子摸象,折紙丶;Uz,紫砂清茶;Us,九怀;Ug,仙气儿飘飘丶;Ua,嵩屿丶俗人;UX,丶画心,牛肉法棍",["泰拉尔"] = "Ve,弋影",["利刃之拳"] = "Ve,透明凝清;Ul,卡斯迪莱",["索瑞森"] = "Ve,飘渺天下;Uc,葦名一心",["埃德萨拉"] = "Vd,萨绝人寰;VP,黑色彗星;VN,灬無名灬,烟丶花小喵;VK,爱丽的好爹;VI,第六个布丁;VH,地狱来的小强,那灬夜;VE,极度卑劣少女;U6,议事厅内斗猎;Ul,爆师傅;Uf,Naye;Ud,蛋壳丶牧语;UY,Lovelydruid,狗头萨",["安戈洛"] = "Vd,动物园牛总",["恶魔之魂"] = "Vd,破坏者血雨;VK,由月与地",["暗影迷宫"] = "Vd,带带大天启",["暴风祭坛"] = "Vd,Èèsp",["末日行者"] = "Vd,隐匿的气息,皮塞船;Vc,坠落战神;Va,Shallnotpass;VU,真心香瓜子;VF,孙大锤丶,灬炏灬;VE,伐寇游;U/,青灯不归客;U9,小蘑菇菇;Uy,漫步风雨中;Us,堕落飞霜;Uq,舞西月;Ui,灬沐舒坦灬;Uf,头条帝;Ue,美肚杀;Ub,苍老师的圣徒",["破碎岭"] = "Vd,那一抹深蓝色;VT,欢乐碰碰车;U6,亡泉;Ut,泷谷丶源治;UZ,丷小丶噯",["幽暗沼泽"] = "Vd,万嗜唔忧",["耐普图隆"] = "Vd,小豆先生",["世界之树"] = "Vd,死亡深度",["日落沼泽"] = "Vd,眼棱瞎了眼丶",["丽丽（四川）"] = "Vd,烈火战歌丶;VP,狂贼丶;VK,决战丶;Uy,虎鲸;Ux,冒火绵绵;Ub,壹弦魄荧惑,系熊啾啾呀",["血色十字军"] = "Vd,世间大雨滂沱;Vc,Lacampanella;VW,赦免;VU,枭月ヽ;VS,牙签肉;VO,鼎酱壮壮哒,鼎酱咕咕哒;VI,多多哆余的哆;VH,小嫩魔;U7,许是故人来,人狠話又多;U6,芭雷特,云与山的彼岸,妖兽雅蔑蝶,大枠枠,女竖式;Ux,炽翼丨微笑;Uu,等待还是离开;Ut,寂寞凌迟;Ur,青蟹糯米饭,讲不出再見;Uo,嘤嘤丿怪;Un,蒹葭慕晚霞;Ul,无心之凹;Ui,番茄栗子;Ug,一心想事成一;Ue,是小薪呀;UY,梦耿耿,怡和媛,风姿卓越",["???"] = "Vd,Boahancocl;Vb,心沉旋律;VZ,米雅丶",["银月"] = "Vd,风雪夜归人;Ur,浅浅;Ul,打扰了丶",["洛肯"] = "Vc,猫哥;Uk,摧残野菊花",["熊猫酒仙"] = "Vc,尹力平;VY,泰澜德灬小鬼;VI,圣阿尔托莉雅;VG,沫丿苏汐,镜曈;VF,城南雨歇处,小号蓝色坏蛋;VD,冇鱼丸;VC,膘小雨;U6,落蘭之殤,籹装大佬;Ur,北风雪狐;Um,Darkhorse;Uk,易燃灬;Uf,大國重器,传送门售票员;Ue,翻车;UZ,音於结弦;UY,娜娜奇丶",["拉文凯斯"] = "Vc,小村镇的吻;Ug,战死的刺客",["克尔苏加德"] = "Vc,凛冬怒吼;VX,丶天师傅;VP,溟希翼秣露;VF,小红手椰汁糕;U9,花无意;U6,泰然浩克,寒竹大帝;Uy,罗哌卡因;Uo,辛小美;Uk,赵云子龙德德;Uf,逻辑;UX,板栗丶,丶板栗",["金色平原"] = "Vc,遇见北极星;VS,爸亲了你一口;VK,斯瑞尔;VC,戈多;Uw,自來也;Ug,我想静静丿",["天空之墙"] = "Vc,依楼丶听雨;VF,尼尔波兹曼",["神圣之歌"] = "Vc,幽幽小生;Uy,亦流云丶;Uc,Ikaria;UZ,花天月地;UX,追寻曾经",["凯恩血蹄"] = "Vc,易拉罐;VV,丶我不奶;U8,晨兮",["巫妖之王"] = "Vc,剑出烛影随;VD,天灵;U9,靑卿子衿,靑靑子衿",["鬼雾峰"] = "Vc,Relieved;Va,卟忘丶初心;VN,丶池早早;VE,二两面;VA,女王之刃;Ut,九罗汉",["嚎风峡湾"] = "Vc,俄里翁",["洛丹伦"] = "Vc,犇啵霸",["泰兰德"] = "Vb,Minikiki;VH,四毛莫莫提",["轻风之语"] = "Vb,天选之子;VL,艾欧莉娅;VJ,地狱咆啸,伊琍丹丶怒风;VD,艾欧莉娜",["希雷诺斯"] = "VZ,洛城时光灬",["阿纳克洛斯"] = "VY,棺材板踏浪者;Uv,星辰闘士",["塞拉摩"] = "VX,慕冬;VT,荆棘岚月;VQ,发飙灬葛;VO,熊宝宝爪机;VL,你是美玉;VK,全效金装嘎嘎;VJ,神秘的蛋;VB,斯蒂德;U7,加勒比海带;U6,鱼哼哼;Up,夜雨声声烦;Uk,Grebmar;UY,迈克尔西安",["布兰卡德"] = "VX,玛法里奧怒风;VR,姨妈出可乐;VJ,小訫訫;VI,动感弹力球,天雨星河落;VG,烟火丶静流年;VF,影噬之城;VB,柒笙;U6,秦楽桜;Uz,漫城烟雨;Uj,陳平安;Ub,Matildaa",["龙骨平原"] = "VX,小手很凉;VU,徐然然灬;Uk,徐橙橙丶;UY,徐痛苦灬",["地狱咆哮"] = "VW,呱二蛋;Uy,游学者鸿瑞;Ud,月魇",["格雷迈恩"] = "VW,Statet;VF,丨桃白白",["大地之怒"] = "VV,灬浮竹灬;Uc,为爱痴狂",["诺兹多姆"] = "VV,少年出大荒;Ug,调皮的宝宝;Ub,贰零壹零;UX,恩希尔",["黑龙军团"] = "VU,野良君",["回音山"] = "VT,请让我奶;Um,帝翎;Ue,穆有我牛",["艾萨拉"] = "VT,潛行者;VJ,Shunter",["狂热之刃"] = "VS,璨若星辰丶;VP,单格丶;U9,Montgoholy;Un,吃苹果去",["艾莫莉丝"] = "VS,弥撒;VK,弥紗",["雷斧堡垒"] = "VS,海蓝朵;Uq,厉若海;Ug,血色白杨;Ud,复仇恶魔",["霜狼"] = "VS,雷鸣丶",["莱索恩"] = "VS,苏丶妲己",["加基森"] = "VR,威武小龙虾",["亚雷戈斯"] = "VR,左牵黄;U/,灰常深蓝;UY,素梦瑾然",["晴日峰（江苏）"] = "VQ,Syrlin;U7,一个人去流浪;Ud,老司机会开车",["伊利丹"] = "VQ,兮丶夜;U6,酱香大骨头",["太阳之井"] = "VP,玛惟影歌",["奎尔丹纳斯"] = "VN,姬血冷青",["布莱恩"] = "VN,宿命之殇;VI,骷髅哥哥;U6,Azumolaso",["迅捷微风"] = "VM,京东猎;VH,秋水;U+,丶欧兜兜丶;U8,Gigabyte;Ut,以殺止殺,舟途;Ur,新区小武,奔驰;UZ,天贶十八",["瓦丝琪"] = "VL,老棍子",["戈提克"] = "VL,阿呆爱美丽",["雷霆之王"] = "VL,凛冬散尽",["奥拉基尔"] = "VK,寒冰破甲",["血吼"] = "VJ,新手村扛把子",["阿克蒙德"] = "VI,水彦凉;VF,冥魄;Uq,灵飞影",["月神殿"] = "VI,草莓兔兔;Ur,黄龙天翔;Uk,手拿棒棒糖;Ue,感染的隐鼠;Uc,萌萌哒鸡蛋饼;Ub,软萌皮卡丘丶",["伊萨里奥斯"] = "VI,Bomd",["纳克萨玛斯"] = "VI,Kelantir",["山丘之王"] = "VH,忘丶残年;UZ,赦珑魂;UY,笑靥如花",["血羽"] = "VH,可乐加冰丶;Ue,Anllhunter",["桑德兰"] = "VH,罗小虫;VC,丨灬拂晓丶;Uy,熊猫枸杞年华,湿夹摸妮",["勇士岛"] = "VH,爱吃辣椒的贤,爱吃辣椒的宗;Ub,尼古拉斯二狗",["踏梦者"] = "VG,小时了了",["奥特兰克"] = "VG,光明神欧若拉,完爆下路;U6,唐詩;Uc,Fit;UX,特级大厨诺米",["鲜血熔炉"] = "VG,冷烟丶鈊鋙",["壁炉谷"] = "VG,南无观世音",["死亡熔炉"] = "VG,疯狂的洋葱",["冰霜之刃"] = "VG,远程转火;U9,夏小夏丶;Uc,呆毛之王;UX,博士斌",["深渊之巢"] = "VF,Aghamin",["提瑞斯法"] = "VF,星辰潘德",["织亡者"] = "VF,圣灮永恒;U6,惩戒骑",["拉文霍德"] = "VF,熊孩几",["达纳斯"] = "VF,万有引力",["烈焰峰"] = "VE,希尔瓦娜嘶",["碧空之歌"] = "VE,浮生丿如梦",["哈卡"] = "VD,请叫我骑士",["暗影之月"] = "VB,安德烈丶;U6,慕千雪,凌慕雪;Uw,Dvorak;Up,野百合的春天",["图拉扬"] = "U/,笑一;Uu,Pyrrla",["暗影议会"] = "U+,曦明",["埃雷达尔"] = "U+,兴高又采烈",["梅尔加尼"] = "U+,远藤沙耶",["黑石尖塔"] = "U+,拔刀丨战仕",["奥尔加隆"] = "U+,街道办丶主任;Uy,陆吾;UZ,托马斯维德",["安其拉"] = "U9,荷鲁斯之眼",["夏维安"] = "U9,背后下刀子;Uu,独狼;Ue,温柔的挠挠你;Ud,团結就是力量,团結",["萨菲隆"] = "U9,黯荭;Ux,王飒;UY,鸡腿菇凉",["黑暗虚空"] = "U8,Lambert",["Illidan[US]"] = "U8,Dengjunai",["试炼之环"] = "U7,柠檬朗姆",["洛萨"] = "U7,呆呆灬德",["朵丹尼尔"] = "U7,你媳妇突然",["霍格"] = "U7,小虎歌;Ua,吉田步美",["血环"] = "U7,Harrydotter,布布兰塔;Uj,北野凛子",["麦迪文"] = "U7,風之輕吟;Uj,紫洛;UY,独守达菲",["黑翼之巢"] = "U7,哪壹箭的风情",["暮色森林"] = "U6,叫地主",["艾露恩"] = "U6,蒹葭沧沧",["燃烧军团"] = "U6,毛毛是真赖叽;Uc,Tt",["永恒之井"] = "U6,三少婆娘",["翡翠梦境"] = "U6,我无限嚣张;UY,实力电击",["黑铁"] = "U6,冲动的弄潮儿,月亮会消失,洋芋人",["灰谷"] = "U6,爷苏格拉底",["雷克萨"] = "U6,快乐的人生;Ub,决心",["亡语者"] = "U6,蛋疼的小萨满",["红云台地"] = "Uy,凯嗯",["迦罗娜"] = "Uy,Ilililoo",["遗忘海岸"] = "Uv,Vikkeas;UX,Yyboom",["耳语海岸"] = "Ut,沧海之剑",["恶魔之翼"] = "Ut,萌新养老",["普罗德摩"] = "Ut,大囵林",["海达希亚"] = "Ur,落雨心诚",["厄祖玛特"] = "Ur,黄晃晃",["阿尔萨斯"] = "Ur,我不是锈铁",["石爪峰"] = "Uq,费伍德;Ug,蜻蜓队长",["达克萨隆"] = "Uq,伊丽灬莎白",["红龙军团"] = "Up,单点莫斯利安",["守护之剑"] = "Uo,敏妹",["哈兰"] = "Un,沫沫智",["基尔加丹"] = "Um,丿王小贱丶",["末日之刃"] = "Ul,堕落飞霜",["银松森林"] = "Ul,Miuinitio;UY,拙拳",["塞纳留斯"] = "Ul,老骨头……",["托塞德林"] = "Uk,小兰丶;UY,萧瑟",["奥蕾莉亚"] = "Ui,夏虫不可语冰",["梦境之树"] = "Ug,一剪没",["米奈希尔"] = "Ug,绀蓝",["黑暗之门"] = "Ug,欧皇大帝,咸鱼超人",["熔火之心"] = "Ug,九条卡莲;Ud,Enterprise",["玛洛加尔"] = "Uf,徐大娘",["艾维娜"] = "Uc,老玩童",["卡德加"] = "Uc,雷鬼吖",["提尔之手"] = "Uc,书写星辰",["斩魔者"] = "Ub,别扒拉我",["达隆米尔"] = "Ua,铁血长歌",["沙怒"] = "UZ,月痕与夜",["蜘蛛王国"] = "UZ,煌黑终焉之影",["埃加洛尔"] = "UY,阿西罢",["海加尔"] = "UX,紫月重明"};
local lastDonators = "风雪夜归人-银月,夜半月听风-凤凰之神,Lixm-死亡之翼,丶对钱没情趣-凤凰之神,Boahancocl-???,马大漂亮-安苏,世间大雨滂沱-血色十字军,烈火战歌丶-丽丽（四川）,眼棱瞎了眼丶-日落沼泽,壹贱定天下-白银之手,大奶猴也算猴-燃烧之刃,尛噩夢-燃烧之刃,珊瑚海-贫瘠之地,尤川丶蚩梦-凤凰之神,死亡深度-世界之树,皮塞船-末日行者,小豆先生-耐普图隆,万嗜唔忧-幽暗沼泽,青年蜀黍-霜之哀伤,那一抹深蓝色-破碎岭,仙晨之灵-死亡之翼,杨扬采-死亡之翼,冰煌血舞-主宰之剑,小小波哥丶-伊森利恩,隐匿的气息-末日行者,伊利瑟维斯-罗宁,Èèsp-暴风祭坛,带带大天启-暗影迷宫,谜灬失-凤凰之神,背影余晖-凤凰之神,破坏者血雨-恶魔之魂,动物园牛总-安戈洛,Ntmdjjww-白银之手,萨绝人寰-埃德萨拉,小小心脏-白银之手,林楚儿-安苏,飘渺天下-索瑞森,透明凝清-利刃之拳,弋影-泰拉尔,至尊丶牛犊子-安苏,冰冰水冰-白银之手,黄黄皇帝-燃烧之刃,Shanbaby-白银之手,鸣剑-凤凰之神,沾血的黃瓜-影之哀伤,彼麦凯蒂丶-白银之手,萌萌哒滴萌萌-冰风岗,丨我很纯洁丶-安苏,议事厅哭强战-燃烧之刃,蔡萌萌-风行者,黑枸杞-自由之风,暗殺星-主宰之剑,白兔软糖-月光林地,牛克蒙德-寒冰皇冠,伽罗丶六道-奥妮克希亚,二叔灬-迦拉克隆,自然醒吧-凤凰之神,小猪佩鱼丷-凤凰之神,狂魔㐅乱舞-贫瘠之地,馮巩老師丶-巨龙之吼,留痕-国王之谷,卡其布诺灬-霜之哀伤,狂躁方向盘-影之哀伤,Jeromecc-死亡之翼,林深鹿幽鸣-海克泰尔,云中寄雨-白银之手,于子酱-凤凰之神,焦嘦嘦-凤凰之神,犇頭德撸衣-无尽之海,贺豪豪-阿古斯,始终怀念-燃烧之刃,寶貝卟哭-冰川之拳,南吕五日-安苏,无限正义-诺森德,一念丹香-普瑞斯托,天涯觅青鸾-凤凰之神,Mojiedjlr-血牙魔王,琴断弦难断-格瑞姆巴托,拒绝我都被绿-死亡之翼,懒癌晚期凉凉-瑟莱德丝,盞茶作酒-罗宁,桃溪春野-伊森利恩,血腥战歌-白银之手,舒预言-伊莫塔尔,墨华-罗宁";
local start = { year = 2018, month = 8, day = 3, hour = 7, min = 0, sec = 0 }
local now = time()
local player_shown = {}
U1Donators.players = player_shown

local topNamesOrder = {} for i, name in ipairs({ strsplit(',', topNames) }) do topNamesOrder[name] = 5000 + i end
local lastNamesOrder = {} for i, name in ipairs({ strsplit(',', lastDonators) }) do lastNamesOrder[name] = i end

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
        local order1 = lastNamesOrder[a] or topNamesOrder[a] or 9999
        local order2 = lastNamesOrder[b] or topNamesOrder[b] or 9999
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
    lastNamesOrder = nil

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
      if topNamesOrder[players[index]] then row.name:SetText(DARKYELLOW_FONT_COLOR:WrapTextInColorCode(name)) else row.name:SetText(name) end
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