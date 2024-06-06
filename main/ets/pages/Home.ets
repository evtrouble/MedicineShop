import Medicine_DB from '../pages/Rdb'
import relationalStore from '@ohos.data.relationalStore';
import router from '@ohos.router';
import {ShopCart} from './ShopCart';

@Component
export struct Home{
  @Prop private username : string;
  @Link private totalCost:number;

  build() {
    Navigation() {
      Column({ space: 10 }) {
        Text(this.username)
          .fontSize(40)
          .height('20%')
          .width('100%')
          .backgroundColor(Color.Orange)
          .textAlign(TextAlign.Center)
          .fontColor(Color.White)
          Text('我的设置').fontSize(30).width('100%')
          Divider().width('90%')
          Text('我的消息').fontSize(30).width('100%')
          Divider().width('90%')
          NavRouter() {
            Text('我的购物车').fontSize(30).width('100%')
            NavDestination() {
              ShopCart({username:this.username,
                totalCost:$totalCost})
            }.backgroundColor(Color.White).title('返回')
          }
        }

        Row() {
          Button('注销账号').width(150)
            .onClick(() => {
              AlertDialog.show({
                message: '是否要注销账号', // 弹窗内容
                autoCancel: false, //点击遮障层时，是否关闭弹窗。
                alignment: DialogAlignment.Center, //弹窗位置
                primaryButton: { //主按钮的文本内容、文本色、按钮背景色和点击回调。
                  value: '确认', //按钮文字
                  action: () => { //按钮回调
                    let predicates = new relationalStore.RdbPredicates('Users');
                    predicates.equalTo('USERNAME', this.username);
                    Medicine_DB.delete(predicates);

                    predicates = new relationalStore.RdbPredicates('ShopCart');
                    predicates.equalTo('USERNAME', this.username);
                    Medicine_DB.delete(predicates);

                    router.pushUrl({
                      url: 'pages/Index', // 目标url
                    }, router.RouterMode.Single, (err) => {
                      if (err) {
                        console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
                        return;
                      }
                      console.info('Invoke pushUrl succeeded.');
                    });
                    router.clear();
                  },
                  fontColor: '#f00'
                },
                secondaryButton: { //副按钮的文本内容、文本色、按钮背景色和点击回调。
                  value: '取消', //按钮文字
                  action: null
                }
              })
            })
        }.alignItems(VerticalAlign.Bottom).height('55%')
      }.width('100%').mode(NavigationMode.Stack)
    .hideToolBar(true).hideTitleBar(true).height('100%')
    }
}