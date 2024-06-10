import Medicine_DB from '../pages/Rdb'
import relationalStore from '@ohos.data.relationalStore';
import {Info} from '../pages/Register';
import {Item_Detailed_Show} from '../pages/Item_Detailed_Show';
import {ShopCart_Item_Show} from '../pages/ShopCart_Item_Show';

export class ShopCart_Item{
  MEDICINE_NAME:string;
  CURRENT_PRICE:number;
  ID:number;
  NUMBER:number;
  MEDICINE_IMAGE:string;

  constructor(MEDICINE_NAME:string='', CURRENT_PRICE:number=-1, MEDICINE_IMAGE:string='',
  ID:number=-1,NUMBER:number=-1) {
    this.MEDICINE_IMAGE=MEDICINE_IMAGE;
    this.MEDICINE_NAME=MEDICINE_NAME;
    this.CURRENT_PRICE=CURRENT_PRICE;
    this.ID=ID;
    this.NUMBER=NUMBER;
  }
}

export const Item_NUM_PAGE : number = 10;

@Component
export struct ShopCart{
  @Prop private username:string;
  @Link private CurrentPage : number;
  @Link private MAX_ITEMS_NUM:number;
  @Link private MAX_PAGE:number;
  @State private inputPage:string='';
  @Link private displayItems: ShopCart_Item[];
  @Link private totalCost:number;
  @Watch('onEditModeChange') @State private isEditMode:boolean=false;
  @State private selectedItems: ShopCart_Item[]=[];

  onEditModeChange() {
    if (!this.isEditMode) {
      this.selectedItems = [];
    }
  }

  autoChangePageUpdate: () => void = () => {
  }

  getImage:(name:string, id:number) => void = (name:string, id:number) => {
  }

  build() {
    Column(){
      Text('我的购物车').fontColor(Color.Orange).fontSize(40).width('100%').align(Alignment.Center)
      Text(`总计${this.totalCost}元`).width('100%').align(Alignment.Start)
      if(this.MAX_ITEMS_NUM){
        if (this.isEditMode) {
          Row(){
            Text('X')
              .fontSize(20)
              .onClick(() => {
                this.isEditMode = false;
              })
              .margin({ left: 20, right: 20 })

            Text('已选择' + this.selectedItems.length + '项')
              .fontSize(24)
          }

        }

        List({space:10}){
          ForEach(this.displayItems, (item: ShopCart_Item) => {
            if(item.MEDICINE_NAME!=''){
              ListItem() {
                NavRouter(){
                  ShopCart_Item_Show({ item:item,
                    isEditMode: $isEditMode,
                    selectedItems: $selectedItems
                  })
                  NavDestination() {
                    Item_Detailed_Show({ MEDICINE_IMAGE:item.MEDICINE_IMAGE as string,
                      MEDICINE_NAME:item.MEDICINE_NAME as string,
                      username:this.username,
                      totalCost:$totalCost,
                      MAX_ITEMS_NUM:$MAX_ITEMS_NUM})
                  }.title('返回').height('100%').width('100%').backgroundColor(Color.White)
                  .onAreaChange(()=>{
                    this.autoChangePageUpdate();
                  })
                } .enabled(!this.isEditMode)
              }.width('100%').onClick(()=> {
                if(this.isEditMode){
                  let index = this.selectedItems.indexOf(item);// 取消勾选时，则将此项从selectedItems中删除
                  if (index != -1) this.selectedItems.splice(index, 1);
                  else this.selectedItems.push(item);// 勾选时，记录选中的列表项
                }
              })
            }
          })

        }.height('75%').width('100%')

        if (this.isEditMode) {
          Button('删除')
            .onClick(()=>{
              AlertDialog.show({
                message: '是否要删除', // 弹窗内容
                autoCancel: false, //点击遮障层时，是否关闭弹窗。
                alignment: DialogAlignment.Center, //弹窗位置
                primaryButton: { //主按钮的文本内容、文本色、按钮背景色和点击回调。
                  value: '确认', //按钮文字
                  action:async(): Promise<void> => { //按钮回调
                    let ID:number[]=[];
                    this.MAX_ITEMS_NUM -= this.selectedItems.length;
                    for(let i=0;i<this.selectedItems.length;i++) {
                      ID.push(this.selectedItems[i].ID);
                      this.totalCost-=this.selectedItems[i].CURRENT_PRICE*this.selectedItems[i].NUMBER;
                    }

                    let predicates = new relationalStore.RdbPredicates('ShopCart');
                    predicates.equalTo('USERNAME',this.username).in('ID',ID);
                    await new Promise<void>((resolve) => {
                      Medicine_DB.delete(predicates);// 删除选中的列表项对应的数据
                      resolve();
                    }).then(()=>{
                      this.MAX_PAGE = Math.max(Math.ceil(this.MAX_ITEMS_NUM/Item_NUM_PAGE),1);
                      if(this.CurrentPage>this.MAX_PAGE)this.CurrentPage=this.MAX_PAGE;
                      this.autoChangePageUpdate();
                    });

                    await new Promise<void>((resolve) => {
                      for(let i=0;i<this.selectedItems.length;i++) {
                        Medicine_DB.executeSql('update', 'UPDATE Medicine SET MEDICINE_STOCK = MEDICINE_STOCK +' +
                        `${this.selectedItems[i].NUMBER} WHERE MEDICINE_NAME = '` +
                        `${this.selectedItems[i].MEDICINE_NAME}'`);
                      }
                      resolve();
                    })
                    this.isEditMode = false;
                  },
                  fontColor: '#f00'
                },
                secondaryButton: { //副按钮的文本内容、文本色、按钮背景色和点击回调。
                  value: '取消', //按钮文字
                  action: ()=>{
                    this.isEditMode = false;
                  }
                }
              })
            })
        }else{
          Row({space:10}){
            Button('上一页').onClick(()=>{
              if(this.CurrentPage>1){
                this.CurrentPage--;
                this.autoChangePageUpdate();
              }
              else if(this.CurrentPage==1)Info('已到达第一页');
            }).margin({left:'20%'})
            TextInput({ text: String(this.CurrentPage) })
              .type(InputType.Number).width('20%')
              .onSubmit(()=>{
                const temp=this.CurrentPage;
                this.CurrentPage=Number(this.inputPage);
                if(this.CurrentPage>this.MAX_PAGE)this.CurrentPage=this.MAX_PAGE;
                if(this.CurrentPage<1)this.CurrentPage=1;
                if(this.CurrentPage!=temp) this.autoChangePageUpdate();
              })
              .onChange((value: string) => {
                this.inputPage=value;
              })
            Button('下一页').onClick(()=>{
              if(this.CurrentPage<this.MAX_PAGE){
                this.CurrentPage++;
                this.autoChangePageUpdate();
              }
              else if(this.CurrentPage==this.MAX_PAGE)Info('已到达最后一页');
            })
          }.width('100%').height('10%')
        }
      }else{
        Text('暂无购买商品相关信息').padding({top:'30%'}).fontSize(30)
          .width('100%').textAlign(TextAlign.Center)
      }

    }.padding(10).width('100%').height('100%')

  }
}
