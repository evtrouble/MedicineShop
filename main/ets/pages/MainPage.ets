import router from '@ohos.router';
import {Goods} from '../pages/Goods';
import {Home} from '../pages/Home';
import {ShopCart, ShopCart_Item, Item_NUM_PAGE} from '../pages/ShopCart';
import Medicine_DB from '../pages/Rdb'
import relationalStore from '@ohos.data.relationalStore';

@Entry
@Component
struct MainPage{
  @State private username : string='';
  @State private CurrentPage : number=1;
  @State private displayItems: ShopCart_Item[]=[];
  @State private totalCost:number=0;
  @State private MAX_ITEMS_NUM:number=0;
  @State private MAX_PAGE:number=1;

  onPageShow() {
    const params = router.getParams(); // 获取传递过来的参数对象
    this.username = params['username']; // 获取属性的值

    for(let i=0;i<Item_NUM_PAGE;i++)this.displayItems[i]=new ShopCart_Item();

    let predicates = new relationalStore.RdbPredicates('ShopCart');
    predicates.equalTo('USERNAME',this.username);
    Medicine_DB.query(predicates,['NUMBER', 'CURRENT_PRICE'],
      (resultSet:relationalStore.ResultSet)=>{
        this.MAX_ITEMS_NUM = resultSet.rowCount;
        this.MAX_PAGE = Math.max(Math.ceil(this.MAX_ITEMS_NUM/Item_NUM_PAGE),1);

        resultSet.goToFirstRow();
        for(let i=0;i<resultSet.rowCount;i++){
          this.totalCost+=(resultSet.getDouble(resultSet.getColumnIndex('CURRENT_PRICE'))*
          resultSet.getLong(resultSet.getColumnIndex('NUMBER')));
          resultSet.goToNextRow();
        }
        resultSet.close();
      })
    this.autoChangePageUpdate();
  }

  private tabsController : TabsController = new TabsController()
  @State private currentIndex:number = 0;

  @Builder TabBuilder(title: string, targetIndex: number) {
    Column() {
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? '#1698CE' : '#6B6B6B')
    }
    .onClick(() => {
      this.currentIndex = targetIndex;
      if(targetIndex==1)this.autoChangePageUpdate();
      this.tabsController.changeIndex(this.currentIndex);
    })
  }

  autoChangePageUpdate() {
    let predicates = new relationalStore.RdbPredicates('ShopCart');
    predicates.equalTo('USERNAME',this.username);
    predicates.limitAs(Item_NUM_PAGE).offsetAs((this.CurrentPage-1)*Item_NUM_PAGE);
    Medicine_DB.query(predicates,['MEDICINE_NAME','CURRENT_PRICE','ID', 'NUMBER'],
      async (resultSet:relationalStore.ResultSet):Promise<void> =>{
        resultSet.goToFirstRow();
        for(let i=0;i<Item_NUM_PAGE;i++){
          if(i<resultSet.rowCount){
            await new Promise<void>((resolve) => {
              this.getImage(resultSet.getString(resultSet.getColumnIndex('MEDICINE_NAME')), i);
              resolve();
            });

            this.displayItems[i]=new ShopCart_Item(resultSet.getString(resultSet.getColumnIndex('MEDICINE_NAME')),
              resultSet.getDouble(resultSet.getColumnIndex('CURRENT_PRICE')),
              this.displayItems[i].MEDICINE_IMAGE,
              resultSet.getLong(resultSet.getColumnIndex('ID')),
              resultSet.getLong(resultSet.getColumnIndex('NUMBER')));

            resultSet.goToNextRow();
          } else this.displayItems[i]=new ShopCart_Item();
        }
        resultSet.close();
      });
  }

  getImage(name:string, id:number){
    let predicates = new relationalStore.RdbPredicates('Medicine');
    predicates.equalTo('MEDICINE_NAME',name);
    Medicine_DB.query(predicates,['MEDICINE_IMAGE'],
      (resultSet:relationalStore.ResultSet)=>{
        resultSet.goToFirstRow();
        this.displayItems[id].MEDICINE_IMAGE=resultSet.getString(resultSet.getColumnIndex('MEDICINE_IMAGE'));
        resultSet.close();
      })
  }

  build(){
    Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
      TabContent() {
        Goods({username:this.username,
          totalCost:$totalCost,
          MAX_ITEMS_NUM:$MAX_ITEMS_NUM});
      }.tabBar(this.TabBuilder('主页', 0))

      TabContent() {
        Navigation() {
          ShopCart({ username: this.username,
            totalCost: $totalCost,
            CurrentPage:$CurrentPage,
            displayItems:$displayItems,
            MAX_ITEMS_NUM:$MAX_ITEMS_NUM,
            MAX_PAGE:$MAX_PAGE,
            autoChangePageUpdate:this.autoChangePageUpdate,
            getImage:this.getImage})
        }.width('100%').mode(NavigationMode.Stack)
        .hideToolBar(true).hideTitleBar(true).height('100%')
      }.tabBar(this.TabBuilder('购物车', 1))

      TabContent() {
        Home({username:this.username})
      }.tabBar(this.TabBuilder('我的', 2))
    }.onChange((index) => {
      this.currentIndex = index;
      if(index==1) this.autoChangePageUpdate();
    }).width('100%')
  }
}
