local _, U1 = ...;
U1Donators = {}
local topNames = "奶瓶小裤衩-血色十字军,御箭乘风-贫瘠之地,瓜瓜哒-白银之手,顿顿丶-伊森利恩,闪亮的眼睛丶-死亡之翼,空灵道-回音山,叶心安-远古海滩,乱劈妖裁-菲拉斯,孤雨梧桐-风暴之怒,短腿肥牛-无尽之海,墨狱-金色平原,乱灬乱-伊森利恩,古麗古麗-死亡之翼,Monarch-霜之哀伤,砂锅大的锤-暗影之月,天之冀-白银之手,丶小酒鬼-无尽之海,血缈-血牙魔王,坚果别闹-燃烧之刃,殺画丶-凤凰之神,冰淇淋上帝-血色十字军,舞弥-奎尔丹纳斯,奔跑的猎手-熊猫酒仙,发骚的院长-燃烧之刃,詩月-血色十字军,海潮之声-白银之手,败家少爷-死亡之翼,不含防腐剂-诺森德,洛天丨凌風-烈焰峰,大江江米库-雷霆之王,Haatxl-无尽之海,幽幽花舞-贫瘠之地,蒋公子-死亡之翼,Majere-冰风岗,邪恶肥嘟嘟-卡德罗斯,落霞菲-罗宁";
local recentDonators = {["伊森利恩"] = "Nz,大雨灬,猫猫丶鱼;Nv,红脸的李二狗;Nu,无奈的笑容;Ns,凯旋的战神,荒木飞吕晏;Nq,牛丶茶茶,萌萌哒猫姐,铁头娃就不谈;No,罗赛塔丶;Nn,丶小寿星;Nm,不学不练,淡忘的圣光,淡忘的荣耀,淡忘;Nl,一只小法丝,油腻嘎;Ne,重案组之虎丶,Musing;Na,欧皇亿点;NZ,伊本丝萝;NV,长腿宇叔,时透无一郎;NU,梅花落了南山;NQ,Muos;NN,壹夏丨十年;NL,冰曦涗玥;NI,玉子酱,滑蛋鲜鸡粥;NH,浪漫太子",["红云台地"] = "Nz,眼药水",["塞拉摩"] = "Nz,Convert",["鹰巢山"] = "Nz,池傲天",["死亡之翼"] = "Nz,腓特烈;Nx,Marryher;Nw,是阿牛啊,閻羅殿灬貔貅;Nu,无声低语,晓可爱的亮亮,月棠;Nt,老山城丷,Bestretlken;No,Magcal,紫灬红日;Nk,明藏;Ni,肌肉帕尼尼,清绝,酒酿丸;Nh,西西姐,Lachysis;Ne,桃乃朩香奈;Nd,莉娅德琳灬,狐狐半藏,快被淹死的鱼,法令紋,骨質酥松;Nb,Vanessamiu;Na,Miragetank,造梦怪咖丶,苏晓宇;NZ,外交部老王,丝想者丶,夜阑听雨眠;NX,尛芋头;NW,红尘灬紫陌,檸七丶;NV,安純;NT,隔壁老舅,桃花大俠;NS,清水洗尘,欧丨湟,欧丨凰;NR,戮羽大圣;NQ,卡拉赞馆长;NO,剑刃风暴灬;NN,小苏妲水,浅唱低萤;NL,茶叶蛋叶子,好硬的象拔蚌,浪味仙乂,兔乄随;NK,梦断不成归,灰烬旋律,凉愁浅梦,甜蜜至臻时,丨莫笑丨;NJ,奶你一口甜;NI,撒欢哦,呆呆不盟;NH,伯牙鼓瑟,香蕉酱,泪流满面丶,醉炫;NG,陈信羽丶",["洛肯"] = "Nz,岁月神偷丷",["主宰之剑"] = "Nz,嗜血小情人,可爱川川;Nt,瑾瑜;Nr,大河剑意,风暴祭司;No,七度丨空间;Nn,清汤丶;Nm,小千叶;Ni,人斩丶,脏刺;Ng,芊芋二宝;Nd,吉祥乂如意;NX,京溢囚茎;NW,木蘭;NV,虫虫归来,呆呆带师兄;NS,Bayonettaa,Nintendoo,独丨狼;NR,好咸丶;NQ,木兰骑;NN,花落果香;NM,墨寶寶;NK,葛德米斯达;NI,慎思;NH,丶达令丶,凤兮丶;NG,墨宝宝",["燃烧之刃"] = "Nz,高圆寺让,西门靓仔,玩德心烦,傲娇的杰尼龟;Nx,傲慢的文斯,帶帶大师兄;Nw,丶天才大猫熊;Ns,我瞎了;Np,于与玉与玉,幸运九叶德;No,迪皮艾斯丶,龙龙很聋丶;Nl,碾灬压;Ni,Osakaty;Nf,浚浚丶,萧若,欧皇无无味;Nb,宮崎英高;Na,战斗氏丶,暗夜丶吊死鬼;NZ,花姥姥丶;NX,中华大丁丁,偶尔有阵雨丶;NW,卡拉赞大馆长;NV,铠尔萨斯,偶尔有阵雨;NT,Miyimo,祖安励志家,稀有的易墨,新手骑士;NR,元栀;NQ,心随流云;NP,我爱艳阳天;NO,丶笑魇無她;NN,煩惱遊戲;NM,蓝亍亍;NL,墨兽灬乘规;NJ,心想事成丶,石头超人;NI,Hayward,清流丶,七月半丶魍,天然元素",["国王之谷"] = "Nz,一千朵玫瑰花;Np,暗影柯基,求求你带带我;Nk,嗨你的蹄妹;Ni,熊猫丶火法帝;NY,纱苍丶真菜;NV,丶孤独的信仰;NO,文竹;NI,丨荆轲丨",["末日行者"] = "Nz,够酥,Osis;Nr,欧豆豆源;Nq,Ziya;Np,小粉桥猪蹄;No,燕思归;Nn,荼蘼如若;Nm,Tx;Nl,Eldoris;Ng,看我的名字;Nc,芬达芬达;NY,荭烟儿;NT,战狼两千,灬炏灬;NR,嗨童靴,丿浮生丶;NI,Haddock,光头加暴击五,全场最佳镜头;NH,至高之魂",["影之哀伤"] = "Nz,滴血之锋;Nw,求求你救救我;Nr,可白兔奶糖;Ng,欧皇滚大爷;Nf,耳边的秋风;Ne,最佳观众;Nb,菜菜小法,幽幽丶路丽;Na,擎天柱进攻;NX,无了敌炉了石,萨满东方;NU,許一卋歡顔;NS,伟霆宝宝丶;NR,表哥丶天枢;NM,火焰中的舞者;NL,奇横三,终于可以了;NK,丨御坂美琴,与兽丶為伍;NJ,錦衣乄南笙,蔷薇花冠;NH,三寶丶,全团的饲养员,全团的荣耀",["阿拉希"] = "Nz,我名五个字;Ns,长天;NJ,飞翔的荷兰饼",["贫瘠之地"] = "Nz,求之就德;Nv,Kevin;Nt,怜竹惜笋,我的开心死了;Ns,我跑不动腿短;Nm,恩佐斯小迷弟,馨酆猪宝宝,海妖塞壬;Nl,老宋家老肆丶,霸气忄豪门,畚嚗丷大叔;Nk,含泪做人夭;Nh,丿丶叶子;Nc,小饭团子;NW,小浣熊香辣蟹;NU,Gundan;NS,花老师;NP,恩左斯丶成哥;NN,术之影;NM,Elfachilles,狩猪待兔;NL,冬吟秋;NJ,嚎嗨哟;NH,黑風野牛丶",["白银之手"] = "Nz,元少,疾风之翼;Ny,哲哲小憨憨,妙蔓影惊鸿,轻雲何皎皎;Nw,秋水燕狂徒,丨花间提壶丨,三从四,毒舌;Nu,鲜肉小笼包丶,大秃嘌;Nt,烟竹丶青花,打声望小公主;Ns,恶魔女猎,小流氓痞子;Nq,Rivoli;Np,呆呆家小劣劣;No,Suss;Nn,两鬓生华;Nm,猴莉的明太子;Nl,大意棒棒哒;Nk,Saosaosorry,三生梦,冰河之击;Ni,Alphagirl;Nh,塞塔里斯神庙;Ng,初火,神疫,糗叔叔;Nf,Xantz,芊陌小落;Ne,玛鲁娜;Nd,复仇者乌瑞恩;Nc,Saosaorry;Nb,摇晃胯胯轴,倾城倾国小妍;NZ,少林冈步吉,溢于言表;NY,Thelazysong;NX,挥霍完再記念;NV,失矢之箭,冰熊老肥,十觴亦不醉,泉七羽;NS,柴骑,迪蒙韩德;NR,冈步吉,圣丶星洛;NO,退税,横扫饥饿,瓷器,斩骨刀,德物,温黛黛,无衍;NN,艾琳丶米莉;NM,灬粽子,英語老师,Amberlight;NL,浪氵氵;NK,云际;NJ,周英俊,黄釒脆皮鸡;NH,生活很单纯,神的那只手;NG,喵灬小汐",["凤凰之神"] = "Nz,巫照师;Nx,Jlaist,沐帕斯;Nv,乱舞旋律;Nu,不是鑫爸;Ns,浮生醉秋风;Nr,豆丁矮子,猴莉星辰;Nm,素妍吖,我不是拉兹;Nk,花开未落;Nh,天空灬星河;Ng,庆功酒;Nf,岁月丿如梭;Ne,七指战神丶,群策而行;Nd,无问南北;Nb,凌晨五点碰面,是阿牛啊,張学友;NZ,暴雷,插销找插座;NY,Tiann;NW,律律,泡面莫;NV,虫虫么么哒,小葱天上飞;NU,熊小觉,Paramours;NT,酥芬又有提升;NS,第五象限;NR,Buff;NQ,Acmenethil,Luoliss;NP,小坏蛋面包,配上豆浆,冷冰凊,亥离,熙熙爸爸;NO,你的小阿飞;NN,雪野百香里;NM,丶妮狸,丶荭炎;NL,榴莲可爱多丶,安度嘤,绯色萝莉控,黑八兔;NK,橙窦窦,Misseeker;NJ,旧砚,张不理智;NI,朔风起时;NG,乁喵小娜,泪般清澈",["格瑞姆巴托"] = "Nz,御前跳跳侍卫;Ny,瑾色依依;Nw,兰兰的天空,别亦难;Ns,海鸟跟鱼;No,清雅丶大帝;Nm,我不是老板;Nk,血靈之天使;Ni,Monstehunte;Nh,Hinataml;Ne,开飛机的贝塔,开飛机的貝塔,丷乔巴;Nd,令無情,茉莉与卿;Nc,尛丶小術,铁匠炉子;Na,囹無情;NZ,Diobarnd,毛球多利;NY,三分情七分性,丨妙蛙种子丨;NX,大场由衣;NV,愿为消之;NU,肆意乀;NS,贝吉塔大人;NQ,Selenia;NP,咕喵汪,谜雾朦朦;NO,Smalldemon,卡塔库栗丶;NN,字节跳动;NM,北新桥;NJ,似風沒有歸宿,炫乂復仇,尛嫩魔,踏雪亦悠然;NI,令无情;NH,阿克门德;NG,坨克萨",["罗宁"] = "Ny,薇薇安迅羽;Nr,魔刃;Nq,橋本有菜丶,狐小幂丶,陸雪琪丶;No,啵啵一口丶;Nl,丑吊恶劣姿态;Nk,幂小白丶;Nf,清风灬寻欢;Nb,心海蓝蓝,德洛莉丝;Na,大幂幂丶;NY,老口味;NX,挽梦忆星辰;NW,菠萝菠萝幂丶;NT,艾酱的花朵;NQ,仙丶水;NP,唐梧桐;NN,妖的忏悔;NM,三鹿丹丶,赫娅;NL,丶沐雨澄风;NK,美眉啦啦队长;NH,廿拾贰",["安苏"] = "Ny,奥拉贱;Nx,喜庆;Nu,谜人的槑毛;Nr,云中仙鹤;Nm,添丁又添财;Nl,纯真的山药;Nk,黑花蚊子,青木川;Ni,怎么了就丶,奶茶来七七八,师兄丶丿;Ng,十八点六;Ne,米莎莎;Nb,天空大魔王;Na,疯狂的茶朔旬;NZ,Gasp;NU,皮埃及丶;NT,蓝色的汤姆丶;NP,孟婆汤里的狗,桃子铯铯;NO,丶尛鱼,各种提升;NN,对面的猪别跑;NM,Tomom;NL,是星星啊丶,是月亮咩丶,盜賊丶丶;NK,丶威士忌;NJ,愚鱼浴雨;NG,黄超神",["巫妖之王"] = "Ny,丨朝歌晚酒丨,一首绝望的歌;Np,苏打水",["血色十字军"] = "Ny,胖丶浩浩;Nt,幽影残梦;Nq,内酷穿特大号;Ng,正艺;Nc,四块五的汉子;NX,清辞,Miráge;NW,云巻云舒,暴戾萝莉满意;NV,村里的爷们;NU,雨辰青烟;NR,香蕉牛肉干;NQ,Momoniuniu;NM,有时看云罓;NL,花胧夕;NI,巨龙咆哮,王炸炸",["???"] = "Nx,海誓珊盟丶;Nu,泪丶心随颖动",["埃德萨拉"] = "Nx,喜欢天晴;Nn,丶唯唯熊;Nm,天启者;Ng,壹骑绝尘;Nc,发条橙;NX,锕木,木糖灬醇;NP,憨憨牛;NM,红尘惹潇湘;NL,这齐齐真逗",["布兰卡德"] = "Nx,平生相见羽;Nl,皮克桃;Nh,无至;Nf,米小蓝丶,狗大仙丶;Nb,無能狂怒,如夢令;NZ,银月漫步;NQ,面目全非德;NJ,浪漫撒加",["天空之墙"] = "Nx,李灬沧海;NU,艿茶爱原味;NN,爱原味奶茶",["加兹鲁维"] = "Nx,塔瑞爾",["无尽之海"] = "Nx,玖幺華英雄;Nw,棉花棠,叄公主;Nr,谢柒爺;Nn,云雾空;Nl,条孑;Ng,裂开的李奶奶;Ne,怒冲霄;Nc,桐生可可;NX,十二渠道急速;NW,晨曦大主教;NV,狂莽之灾;NR,小随意;NO,盾牌在手;NL,文风丧胆;NK,尛魄罗;NJ,丶懒妥妥;NI,聖骑士的斩杀,狗子丶",["提瑞斯法"] = "Nw,实在很怒风,落灬雪",["金色平原"] = "Nw,冰殒;Nk,瓦尔姬丽娅;Ne,萨隆丶尼奥;Nb,冰镇光棱猫,特级大厨诺米;NR,沃塔斯基;NN,糖一斤;NM,拉尔夫亚;NG,坏坏",["回音山"] = "Nw,林深时雾起;Nn,驴友团长;Nm,青桔丶丶,清柳;Ng,路西法丶妮娜;NY,冷月天星;NU,卖废柴的女孩;NM,快少;NH,雀实很嗨",["丽丽（四川）"] = "Nw,终焉之焱;Np,川木;No,雪山战兽妞;Nn,欧元丶怒风;Nm,柒隻熊猫;Nc,小丶啾啾;NY,小喵爱吃鱼;NV,忆难忘;NG,沉梦扬志",["耐奥祖"] = "Nw,Ahribabe;NT,阿鲁迪巴",["冰风岗"] = "Nv,小湿女未;Np,蛋炒饭;No,一百八十九斤;Nn,半人萌犸;Nk,糖浆;Nf,灬深渊巨口;Ne,一颗白菜;Nc,午夜丨丨阳光;Nb,黑暗凝视;Na,巧莓奶渣丶;NZ,巧莓丶奶渣;NW,张一山;NQ,巧莓奶渣;NM,周防尊,都听她的;NJ,德鲁丨,念一",["轻风之语"] = "Nv,长缨;Nu,奈何花落;Nn,醋溜牛肉丸",["诺兹多姆"] = "Nu,奶騎;Nc,橙子快乐橙子;NY,Yuukiasuna",["燃烧平原"] = "Nu,妖兽雅篾蝶;NQ,搞不伶清",["迅捷微风"] = "Nu,铁甲小寶;Ns,你可真香啊;NP,多情的打扰",["拉文凯斯"] = "Nu,旧时回忆;Ns,欧姆猎手;NO,渝民丶",["迦顿"] = "Nu,扮猪吃老虎",["拉文霍德"] = "Nt,可可恺撒;NU,凛丶",["血吼"] = "Nt,吧唧大",["幽暗沼泽"] = "Nt,回不去的時光;Nn,满哥;NH,桥本爱",["安东尼达斯"] = "Nt,罗小保",["黑铁"] = "Nt,划船我不用桨;Nq,赞染神光;NL,浑身是泪呃",["奎尔萨拉斯"] = "Ns,忆光影流年;NZ,壹吋天堂;NO,舊城半夏",["黑暗虚空"] = "Nr,飞翔的脚丫;Np,马老板之怒",["克尔苏加德"] = "Nr,黑妞勿扰;NY,毒奶丨猜猜;NU,丶火法;NT,维妮维妮;NM,硬派洋葱丶;NJ,铁骑丨后生儿;NI,叫我柳岩奶",["艾森娜"] = "Nr,萌萌仔;Np,灵魂吸取者,钢然小法;NH,钢然小猎,钢然战神,钢然图腾",["冰霜之刃"] = "Nq,子参宿狩;NM,李铁柱",["阿克蒙德"] = "Nq,Snsbo;NZ,翼德丶;NV,Angelimo;NJ,小滴滴",["哈兰"] = "Np,智沫沫",["太阳之井"] = "Np,寳儿驴",["海克泰尔"] = "Np,卖不起萌;Nn,烟雨居士;NP,惊无影;NI,抓个熊德;NH,四舅",["艾露恩"] = "Np,邦桑迪的邦;NX,低调猎手三号",["夏维安"] = "Np,梧桐不语",["熊猫酒仙"] = "No,馨维娜女皇;Nl,夏沫晨曦,余身有你;Nh,贼菜;Ng,諾奇;Ne,佩琪丶薮猫;Nc,灬特製鹹鱼;NY,龙之一箭,苦三瓜;NX,灬沐风丶,喵爫财神爫喵,喵爫福神爫喵;NV,冰冷刺骨;NU,官人不要停;NQ,Memorykill;NL,老孟莽的很,南木;NK,堕落中重生;NJ,腐中的神",["符文图腾"] = "No,淡殇",["日落沼泽"] = "No,伊犁猛牛;NU,与谁共鸣",["法拉希姆"] = "No,小悠悠儿",["伊利丹"] = "No,时之使;NL,集合啦森友会",["破碎岭"] = "No,莱茵丶哈特;NX,往事隨颩;NI,菲菲超人",["泰兰德"] = "Nn,一岚一;Nk,真焱",["双子峰"] = "Nn,一夜抱富丷",["山丘之王"] = "Nm,Iori;Na,克里斯丶安娜",["亚雷戈斯"] = "Nl,Lruri",["血环"] = "Nl,九牛",["霜之哀伤"] = "Nl,桃叶那尖上尖;Nk,黑龙呀;NT,丝瓜朴朴;NL,堇丶忆",["迦拉克隆"] = "Nl,血染丶战魂;Nk,还敢心动吗;NT,万宝绿;NM,影幽月舞;NK,艾莉的冷笑话",["熔火之心"] = "Nk,萬寶路;NL,似水鱼心",["阿古斯"] = "Nk,啃啃丶;Ne,猫语者;NW,蝉师;NT,风之主宰者;NS,逆袭的欧皇;NQ,君见莲若惜丶;NN,Drphoenix;NM,骷髅教主",["加基森"] = "Nk,念九",["狂热之刃"] = "Nk,啵乐乐;NR,恐怖熊;NG,夜之盗圣",["菲米丝"] = "Ni,神父",["哈卡"] = "Ni,福神;Na,懒懒吖",["战歌"] = "Nh,Momt",["鬼雾峰"] = "Nh,洛丹伦的残月;NZ,肝帝灬玲珑;NL,耙耳朵诺维奇;NG,邪恶蓝星",["海加尔"] = "Ng,小默默爱睡觉,丶小福禄;NZ,翱翔灬翼;NG,Mara",["奥特兰克"] = "Ng,猪糕雯,多喝開水",["神圣之歌"] = "Ng,秋天的童话;NN,一啸灬动千山",["阿纳克洛斯"] = "Nf,奥德赛;NO,妹子没有沟;NL,蛮横的女圣骑;NI,莉莉斯",["雷斧堡垒"] = "Nf,切尔姆索兰;NN,Jerryk",["卡德加"] = "Nf,带风的大呲花",["遗忘海岸"] = "Nf,泰迪",["圣火神殿"] = "Ne,小肥爱嘉丽;NI,橙子皮",["铜龙军团"] = "Nd,醉意流年丶",["蜘蛛王国"] = "Nd,Nobiku",["埃克索图斯"] = "Nc,烈风丶;NM,丶烈风",["洛丹伦"] = "Nc,法灵精怪,左丨小丨熊;Na,闪现了;NK,雷佳音",["玛洛加尔"] = "Nc,古代",["瓦里安"] = "Nb,人海里相依",["梅尔加尼"] = "Nb,高冷的逗比",["阿卡玛"] = "Nb,蓝色契约",["黑石尖塔"] = "Nb,俺是明白人",["万色星辰"] = "NZ,嘿嘿呼呼黑;NX,無法潕天;NW,易利丹;NL,游侠灬",["羽月"] = "NZ,脚少的保镖;NP,脚少小号",["尖石[TW]"] = "NZ,天枫凌飛",["雷霆号角"] = "NY,炁殢源飗",["桑德兰"] = "NY,芥末味花生豆",["风行者"] = "NX,搞不伶清",["风暴之鳞"] = "NX,童宝宝走了,童宝宝来了",["红龙军团"] = "NX,水果灬糖;NT,单点绿茶;NR,年月",["影牙要塞"] = "NW,轩辕小阳",["踏梦者"] = "NW,拉克斯乄戦;NV,星空下的我丶",["索瑞森"] = "NV,拿不动盾牌",["玛诺洛斯"] = "NU,迷失的小波",["安纳塞隆"] = "NS,爆炒辣蛤蜊",["巨龙之吼"] = "NR,Azreo",["外域"] = "NR,桥本油菜",["耳语海岸"] = "NQ,天怒雷帝",["玛里苟斯"] = "NP,江南风云",["塞纳留斯"] = "NO,阿忒弥斯",["麦迪文"] = "NO,肉鸡冲蛋",["阿曼尼"] = "NO,聂哥虎背熊腰",["龙骨平原"] = "NN,铁头黄毛",["麦姆"] = "NN,暴戾",["加尔"] = "NN,Juventus",["暗影之月[TW]"] = "NN,愛吃饅頭",["守护之剑"] = "NM,漠小舞,未曰",["寒冰皇冠"] = "NM,一秒的灿烂",["暗影之月"] = "NM,第一晚刀死你;NK,黯然飘渺",["基尔加丹"] = "NL,装了逼就跑",["雷霆之怒"] = "NK,芜菁沙袋;NJ,梦中的哀嚎",["奥尔加隆"] = "NK,白花瓷",["菲拉斯"] = "NK,Snavs",["风暴之怒"] = "NK,宝贝狼;NJ,青楼前徘徊",["永恒之井"] = "NJ,愿忧愁不再有",["希尔瓦娜斯"] = "NJ,壹叶知秋",["扎拉赞恩"] = "NJ,我喝大奶奶",["森金"] = "NI,榴芒小骑",["恶魔之魂"] = "NI,复仇丶阿宝",["阿尔萨斯"] = "NI,叶落尘封",["沙怒"] = "NH,黄杜鹃血族",["诺莫瑞根"] = "NH,拝頭茻哀木梯",["诺森德"] = "NH,为何放弃治疗",["远古海滩"] = "NH,破釜沉舟",["伊瑟拉"] = "NG,永真"};
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