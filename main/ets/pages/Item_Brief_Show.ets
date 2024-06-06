@Component
export struct Item_Brief_Show{
  @Prop MEDICINE_NAME:string;
  @Prop MEDICINE_PRICE:number;
  @Prop MEDICINE_IMAGE:string;
  build(){
    Column() {
      Image(this.MEDICINE_IMAGE).width('100%')
      Text(this.MEDICINE_NAME)
      Text(this.MEDICINE_PRICE < 0 ? '' : `价格：${this.MEDICINE_PRICE}元/公斤`)
    }.width('100%')
  }
}