import router from '@ohos.router';
import {Goods} from '../pages/Goods';
import {Home} from '../pages/Home';

@Entry
@Component
struct MainPage{
  @State private username : string='';
  @State private totalCost:number=0;

  onPageShow() {
    const params = router.getParams(); // 获取传递过来的参数对象
    this.username = params['username']; // 获取属性的值
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
      this.tabsController.changeIndex(this.currentIndex);
    })
  }

  build(){
    Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
      TabContent() {
        Goods({username:this.username,
          totalCost:$totalCost});
      }.tabBar(this.TabBuilder('主页', 0))

      TabContent() {
        Home({username:this.username,
          totalCost:$totalCost})
      }.tabBar(this.TabBuilder('我的', 1))
    }.onChange((index) => {
      this.currentIndex = index;
    }).width('100%')
  }
}