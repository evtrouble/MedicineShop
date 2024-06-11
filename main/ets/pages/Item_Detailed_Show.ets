import Medicine_DB from '../pages/Rdb'
import relationalStore from '@ohos.data.relationalStore';
import {Info} from '../pages/Register';

@CustomDialog
struct BuyDialog {
  @Link private MEDICINE_PRICE: number;
  @Prop private MEDICINE_NAME:string;
  @Prop private username:string;
  @Link private MEDICINE_STOCK:number;
  @Link private totalCost:number;
  @Link private MAX_ITEMS_NUM:number;
  @Link private buyNumber:number;

  controller?: CustomDialogController
  // 若尝试在CustomDialog中传入多个其他的Controller，以实现在CustomDialog中打开另一个或另一些CustomDialog，
  // 那么此处需要将指向自己的controller放在所有controller的后面
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }

  aboutToDisappear() {
    this.buyNumber=0;// 将dialogController置空
  }

  build() {
    Column({space:10}) {
      Text('加入购物车').fontSize(20).margin({ top: 10, bottom: 10 })
      Text(`总计：${this.buyNumber*this.MEDICINE_PRICE}元`)
      Row({space:10}){
        Text('请输入要购买的数量').fontSize(16).margin({ bottom: 10})
        Button('-').onClick(()=>{
          if(this.buyNumber)this.buyNumber--;
        })
        TextInput({ text: String(this.buyNumber)})
          .height(30).width('20%').type(InputType.Number)
          .onChange((value: string) => {
            this.buyNumber = Number(value);
          })
        Button('+').onClick(()=>{
          if(this.buyNumber<this.MEDICINE_STOCK)this.buyNumber++;
        })
      }

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('cancel')
          .onClick(() => {
            this.controller.close();
            this.cancel();

          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('confirm')
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close();
              this.confirm();
            }
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })

    }.borderRadius(10)
  }
}

@Component
export struct Item_Detailed_Show{
  @Prop private MEDICINE_NAME:string;
  @Prop private username:string;
  @Link private totalCost:number;

  @State private MEDICINE_PRICE:number=0;
  @Prop private MEDICINE_IMAGE:string;
  @State private MEDICINE_STOCK:number=0;
  @State private MEDICINE_DESCRIPTION:string='';
  @Link private MAX_ITEMS_NUM:number;
  @State private buyNumber:number=0;

  dialogController: CustomDialogController = new CustomDialogController({
    builder: BuyDialog({
      cancel: this.onCancel,
      confirm: this.onAccept,
      MEDICINE_PRICE:$MEDICINE_PRICE,
      MEDICINE_NAME:this.MEDICINE_NAME,
      username:this.username,
      MEDICINE_STOCK:$MEDICINE_STOCK,
      totalCost:$totalCost,
      MAX_ITEMS_NUM:$MAX_ITEMS_NUM,
      buyNumber:$buyNumber
    }),
    cancel: this.exitApp,
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false
  })

  // 在自定义组件即将析构销毁时将dialogControlle置空
  aboutToDisappear() {
    this.dialogController = null;
    this.buyNumber=0;// 将dialogController置空
  }

  onCancel() {
    console.info('Callback when the first button is clicked')
  }

  onAccept() {
    console.info('Callback when the second button is clicked')
    if(this.buyNumber==0)Info('购买数量不能为0')
    else {
      let predicates = new relationalStore.RdbPredicates('Medicine');
      predicates.equalTo('MEDICINE_NAME',this.MEDICINE_NAME)
      Medicine_DB.query(predicates,['MEDICINE_STOCK', 'MEDICINE_PRICE'],
        async (resultSet:relationalStore.ResultSet):Promise<void> =>{
          resultSet.goToFirstRow();
          this.MEDICINE_STOCK=resultSet.getLong(resultSet.getColumnIndex('MEDICINE_STOCK'));
          this.MEDICINE_PRICE=resultSet.getDouble(resultSet.getColumnIndex('MEDICINE_PRICE'));
          if(this.buyNumber > this.MEDICINE_STOCK)Info('购买的数量超过库存');
          else{
              await new Promise<void>((resolve) => {
                Medicine_DB.executeSql('update', `UPDATE Medicine SET MEDICINE_STOCK =
                 MEDICINE_STOCK - ${this.buyNumber} WHERE MEDICINE_NAME =
                 '${this.MEDICINE_NAME}'`);
                resolve();
            }).then(()=>{
                Info('加入购物车成功');
                this.MEDICINE_STOCK-=this.buyNumber;
                this.totalCost+=this.buyNumber*this.MEDICINE_PRICE;
                this.MAX_ITEMS_NUM+=this.buyNumber;
                Medicine_DB.insert('ShopCart',{MEDICINE_NAME:this.MEDICINE_NAME,
                  CURRENT_PRICE:this.MEDICINE_PRICE,
                  USERNAME:this.username,
                  NUMBER:this.buyNumber});
              });
            }
          resultSet.close();
        })

    }
  }

  exitApp() {
    console.info('Click the callback in the blank area')
  }


  aboutToAppear() {
    let predicates = new relationalStore.RdbPredicates('Medicine');
    predicates.equalTo('MEDICINE_NAME',this.MEDICINE_NAME);
    Medicine_DB.query(predicates,['MEDICINE_STOCK','MEDICINE_DESCRIPTION','MEDICINE_PRICE'],
      (resultSet:relationalStore.ResultSet)=>{
        resultSet.goToFirstRow();
        this.MEDICINE_STOCK=resultSet.getLong(resultSet.getColumnIndex('MEDICINE_STOCK'));
        this.MEDICINE_DESCRIPTION=resultSet.getString(resultSet.getColumnIndex('MEDICINE_DESCRIPTION'));
        this.MEDICINE_PRICE=resultSet.getDouble(resultSet.getColumnIndex('MEDICINE_PRICE'));
        resultSet.close();
      })
  }

  build(){
    Column({space:10}) {
      Image(this.MEDICINE_IMAGE).width('100%')
      Text(this.MEDICINE_NAME).fontSize(30)
      Text(`功效与作用：${this.MEDICINE_DESCRIPTION}`).fontSize(30)
      Text(`库存：${this.MEDICINE_STOCK}公斤`).fontSize(30)
      Text(`价格：${this.MEDICINE_PRICE}元/公斤`).fontSize(30)
      Button('购买')
        .onClick(() => {
          this.dialogController.open()
        })

    }.width('100%')
  }
}
