import Medicine_DB from '../pages/Rdb'

export async function database_init():Promise<void> {
  await new Promise<void>((resolve) => {
    Medicine_DB.insert('Users',{USERNAME:'111',PASSWORD:'111'});
    resolve();
  })
  await new Promise<void>((resolve) => {
    Medicine_DB.batchInsert('Medicine', [{ MEDICINE_DESCRIPTION: '补中益气、健脾益肺。属补虚药下属分类的补气药。',
      MEDICINE_PRICE: 140.00, MEDICINE_CATEGORY: '根茎', MEDICINE_STOCK: 121,
      MEDICINE_IMAGE: 'images/Codonopsis.png', MEDICINE_NAME: '党参'},
      { MEDICINE_DESCRIPTION: '补血活血、调经止痛、润肠通便。属补虚药下属分类的补血药。',
        MEDICINE_PRICE: 200.00, MEDICINE_CATEGORY: '根茎', MEDICINE_STOCK: 541,
        MEDICINE_IMAGE: 'images/Angelica.png', MEDICINE_NAME: '当归'},
      { MEDICINE_DESCRIPTION: '补脾益气、止咳祛痰、缓急定痛、调和药性。属补虚药下分类的补气药。',
        MEDICINE_PRICE: 90.00, MEDICINE_CATEGORY: '根茎', MEDICINE_STOCK: 4141,
        MEDICINE_IMAGE: 'images/Licorice.png', MEDICINE_NAME: '甘草'},
      { MEDICINE_DESCRIPTION: '祛风散寒，温中理气，活血通络。属温里药。',
        MEDICINE_PRICE: 12.00, MEDICINE_CATEGORY: '茎木', MEDICINE_STOCK: 97,//公斤
        MEDICINE_IMAGE: 'images/Camphor.png', MEDICINE_NAME: '樟木'},
      { MEDICINE_DESCRIPTION: '祛风湿、补肝肾、强筋骨、降血压、安胎下乳。属祛风湿药下属分类的祛风湿强筋骨药。',
        MEDICINE_PRICE: 66.00, MEDICINE_CATEGORY: '茎木', MEDICINE_STOCK: 642,
        MEDICINE_IMAGE: 'images/Mistletoe.png', MEDICINE_NAME: '槲寄生'},
      { MEDICINE_DESCRIPTION: '行气温中、开胃止痛。属理气药。',
        MEDICINE_PRICE: 39.60, MEDICINE_CATEGORY: '茎木', MEDICINE_STOCK: 3311,
        MEDICINE_IMAGE: 'images/Sandal.png', MEDICINE_NAME: '檀香'},
      { MEDICINE_DESCRIPTION: '温脾胃，暖肝肾，祛寒止痛，散瘀消肿。属温里药。',
        MEDICINE_PRICE: 16.00, MEDICINE_CATEGORY: '皮', MEDICINE_STOCK: 1555,
        MEDICINE_IMAGE: 'images/Cinnamon.png', MEDICINE_NAME: '桂皮'},
      { MEDICINE_DESCRIPTION: '清热燥湿、泻火除蒸、解毒疗疮。属清热药下属分类的清热燥湿药。',
        MEDICINE_PRICE: 66.00, MEDICINE_CATEGORY: '皮', MEDICINE_STOCK: 4814,
        MEDICINE_IMAGE: 'images/Phellodendron.png', MEDICINE_NAME: '黄柏'},
      { MEDICINE_DESCRIPTION: '理气开胃，燥湿化痰，治脾胃病。属理气药。',
        MEDICINE_PRICE: 8.50, MEDICINE_CATEGORY: '皮', MEDICINE_STOCK: 67243,
        MEDICINE_IMAGE: 'images/Tangerine.png', MEDICINE_NAME: '陈皮'},
      { MEDICINE_DESCRIPTION: '明目，凉血，解毒。属止血药下分类的凉血止血药。',
        MEDICINE_PRICE: 31.00, MEDICINE_CATEGORY: '叶', MEDICINE_STOCK: 243,
        MEDICINE_IMAGE: 'images/Parmeliae.png', MEDICINE_NAME: '白石花'},
      { MEDICINE_DESCRIPTION: '清暑化湿，升发清阳，凉血止血。属清热药下分类的清热凉血药。',
        MEDICINE_PRICE: 17.00, MEDICINE_CATEGORY: '叶', MEDICINE_STOCK: 41804,
        MEDICINE_IMAGE: 'images/Lotus_leaf.png', MEDICINE_NAME: '荷叶'},
      { MEDICINE_DESCRIPTION: '止咳、祛痰。属化痰止咳平喘药下属分类的止咳平喘药。',
        MEDICINE_PRICE: 13.00, MEDICINE_CATEGORY: '叶', MEDICINE_STOCK: 5235,
        MEDICINE_IMAGE: 'images/Rhododendri.png', MEDICINE_NAME: '满山红'},
      { MEDICINE_DESCRIPTION: '散风清热、平肝明目。属解表药下属分类的辛凉解表药。',
        MEDICINE_PRICE: 60.00, MEDICINE_CATEGORY: '花', MEDICINE_STOCK: 54891,
        MEDICINE_IMAGE: 'images/Chrysanthemum.png', MEDICINE_NAME: '菊花'},
      { MEDICINE_DESCRIPTION: '清热解毒、凉散风热。属清热药下属分类的清热解毒药。',
        MEDICINE_PRICE: 130.00, MEDICINE_CATEGORY: '花', MEDICINE_STOCK: 5290,
        MEDICINE_IMAGE: 'images/Honeysuckle.png', MEDICINE_NAME: '金银花'},
      { MEDICINE_DESCRIPTION: '温肺化饮，散寒止痛。属化痰止咳平喘药下属分类的温化寒痰药。',
        MEDICINE_PRICE: 180.00, MEDICINE_CATEGORY: '花', MEDICINE_STOCK: 4142,
        MEDICINE_IMAGE: 'images/Fragrans.png', MEDICINE_NAME: '桂花'},
      { MEDICINE_DESCRIPTION: '清热泻火，解毒利湿。属清热药下分类的清热泻火药。',
        MEDICINE_PRICE: 50.00, MEDICINE_CATEGORY: '全草', MEDICINE_STOCK: 453,
        MEDICINE_IMAGE: 'images/Swertiae.png', MEDICINE_NAME: '鱼胆草'},
      { MEDICINE_DESCRIPTION: '清热利湿，凉血解毒，消积。属止血药下属分类的凉血止血药。',
        MEDICINE_PRICE: 141.30, MEDICINE_CATEGORY: '全草', MEDICINE_STOCK: 313,
        MEDICINE_IMAGE: 'images/Acalypha.png', MEDICINE_NAME: '铁苋'},
      { MEDICINE_DESCRIPTION: '收敛固涩、益气生津、补肾宁心。属收涩药分类下的敛肺涩肠药。',
        MEDICINE_PRICE: 65.00, MEDICINE_CATEGORY: '果实种子', MEDICINE_STOCK: 4143,
        MEDICINE_IMAGE: 'images/Schisandra.png', MEDICINE_NAME: '五味子'},
      { MEDICINE_DESCRIPTION: '解毒、杀虫、疗疮、助阳通便。外用属杀虫止痒药，内服属补虚药下属分类的补阳药。',
        MEDICINE_PRICE: 4.00, MEDICINE_CATEGORY: '矿物', MEDICINE_STOCK: 532,
        MEDICINE_IMAGE: 'images/Sulfur.png', MEDICINE_NAME: '硫黄'},
      { MEDICINE_DESCRIPTION: '壮肾阳，益精血，强筋骨，调冲任，托疮毒。属补虚药下分类的补阳药。',
        MEDICINE_PRICE: 8700.00, MEDICINE_CATEGORY: '动物', MEDICINE_STOCK: 44,
        MEDICINE_IMAGE: 'images/Deer_antler.png', MEDICINE_NAME: '鹿茸'},
      { MEDICINE_DESCRIPTION: '养阴润燥、益气补中。属补虚药下属分类的补阴药。',
        MEDICINE_PRICE: 10600.00, MEDICINE_CATEGORY: '其他', MEDICINE_STOCK: 32,
        MEDICINE_IMAGE: 'images/Nidus_collocaliae.png', MEDICINE_NAME: '燕窝'}]);
    resolve();
  })
  await new Promise<void>((resolve) => {
    Medicine_DB.insert('ShopCart',{MEDICINE_NAME:'燕窝',CURRENT_PRICE:111,USERNAME:'111',NUMBER:1});
    resolve();
  })
}