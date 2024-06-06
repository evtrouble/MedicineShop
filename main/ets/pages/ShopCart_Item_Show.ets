import {ShopCart_Item} from './ShopCart';

@Component
export struct ShopCart_Item_Show{
  private item:ShopCart_Item;
  @Link isEditMode: boolean;
  @Link selectedItems: ShopCart_Item[];

  hasBeenSelected(): boolean {
    return this.selectedItems.indexOf(this.item) != -1;
  }

  build(){
    Row() {
      Image(this.item.MEDICINE_IMAGE).width('20%')
      Column(){
        Text(this.item.MEDICINE_NAME)
        Text(this.item.CURRENT_PRICE < 0 ? '' : `价格：${this.item.CURRENT_PRICE}元/公斤`)
        Text(this.item.CURRENT_PRICE < 0 ? '' : `数量：${this.item.NUMBER}公斤`)
      }.padding({left:'20%',right:'20%'})
      if (this.isEditMode) {
        Checkbox().select(this.hasBeenSelected());
      }
    }.width('100%').height('20%')
    .gesture(
      GestureGroup(GestureMode.Exclusive,
        LongPressGesture()
          .onAction(() => {
            if (!this.isEditMode) {
              this.isEditMode = true; //进入编辑模式
              this.selectedItems.push(this.item);
              // 记录长按时选中的列表项
            }
          }))

    )
  }
}