import Medicine_DB from '../pages/Rdb'
import relationalStore from '@ohos.data.relationalStore';
import {Info} from '../pages/Register';
import {Item_Brief_Show} from '../pages/Item_Brief_Show';
import {Item_Detailed_Show} from '../pages/Item_Detailed_Show';

enum Medicine_Class{
  All, Leaf, Flower, FruitSeed, StemWood,
  Mineral, Animal, Rhizome, Herbs, Bark, Other
}

const classification:string[]=['全部','叶','花','果实种子','茎木','矿物','动物','根茎','全草','皮','其他'];

class Item_Brief{
  MEDICINE_NAME:string;
  MEDICINE_PRICE:number;
  MEDICINE_IMAGE:string;

  constructor(MEDICINE_NAME:string='', MEDICINE_PRICE:number=-1, MEDICINE_IMAGE:string='') {
    this.MEDICINE_IMAGE=MEDICINE_IMAGE;
    this.MEDICINE_NAME=MEDICINE_NAME;
    this.MEDICINE_PRICE=MEDICINE_PRICE;
  }
}

const Item_NUM_PAGE : number = 10;

@Component
export struct Goods{
  @State private CurrentPage : number=1;
  @State private MAX_MEDICINE_NUM:number=0;
  @State private MAX_PAGE:number=1;
  @State private inputPage:string='';
  @State private displayItems: Item_Brief[]=[];
  @State private curClass:Medicine_Class=Medicine_Class.All;
  @Prop username:string;
  @Link private totalCost:number;

  aboutToAppear() {
    this.setMAX_PAGE();
    this.autoChangePageUpdate();
  }

  setMAX_PAGE(searchValue:string=''){
    let predicates = new relationalStore.RdbPredicates('Medicine');
    if(searchValue!='')predicates.like('MEDICINE_NAME',searchValue);
    if(this.curClass)predicates.equalTo('MEDICINE_CATEGORY',classification[this.curClass])
    Medicine_DB.query(predicates,[],
      (resultSet:relationalStore.ResultSet)=>{
        this.MAX_MEDICINE_NUM = resultSet.rowCount;
        this.MAX_PAGE = Math.max(Math.ceil(this.MAX_MEDICINE_NUM/Item_NUM_PAGE),1);
        resultSet.close();
      });
    this.CurrentPage=1;
  }

  autoChangePageUpdate(searchValue:string='') {
    let predicates = new relationalStore.RdbPredicates('Medicine');
    predicates.limitAs(Item_NUM_PAGE).offsetAs((this.CurrentPage-1)*Item_NUM_PAGE);
    if(searchValue!='')predicates.like('MEDICINE_NAME',searchValue);
    if(this.curClass)predicates.equalTo('MEDICINE_CATEGORY',classification[this.curClass]);
    Medicine_DB.query(predicates,['MEDICINE_NAME','MEDICINE_PRICE','MEDICINE_IMAGE'],
      (resultSet:relationalStore.ResultSet)=>{
        resultSet.goToFirstRow();
        for(let i=0;i<Item_NUM_PAGE;i++){
          if(i<resultSet.rowCount){
            delete this.displayItems[i];
            this.displayItems[i]=new Item_Brief(resultSet.getString(resultSet.getColumnIndex('MEDICINE_NAME')),
              resultSet.getDouble(resultSet.getColumnIndex('MEDICINE_PRICE')),
              resultSet.getString(resultSet.getColumnIndex('MEDICINE_IMAGE')));
            resultSet.goToNextRow();
          } else this.displayItems[i]=new Item_Brief();
        }
        resultSet.close();
      });
  }

  build(){
    Navigation() {
      Text('中药材商城').fontSize(35).height('5%')
      Search({placeholder:'请输入药材名称进行搜索'}).searchButton('搜索')
      .onSubmit((value:string)=>{
        this.setMAX_PAGE(value);
        this.autoChangePageUpdate(value);
      }).width('80%').height('5%')
      List({ space: 10 }) {
        ForEach(classification,(item:string,id)=>{
          ListItem(){
            Text((id&&item!='其他')?(item+'类'):item).fontSize(24).onClick(()=>{
              if(this.curClass!=id){
                this.curClass=id;
                this.setMAX_PAGE();
                this.autoChangePageUpdate();
              }
            }).fontColor((this.curClass==id)? '#1698CE' : '#6B6B6B')
          }
        })
      }.listDirection(Axis.Horizontal).height('5%').width('100%')
      if(this.MAX_MEDICINE_NUM){
        Grid() {
          ForEach(this.displayItems, (item: Item_Brief) => {
            if(item.MEDICINE_NAME!=''){
              GridItem() {
                NavRouter(){
                  Item_Brief_Show({ MEDICINE_IMAGE:item.MEDICINE_IMAGE as string,
                    MEDICINE_NAME:item.MEDICINE_NAME as string,
                    MEDICINE_PRICE:item.MEDICINE_PRICE as number})
                  NavDestination() {
                    Item_Detailed_Show({ MEDICINE_IMAGE:item.MEDICINE_IMAGE as string,
                      MEDICINE_NAME:item.MEDICINE_NAME as string,
                      MEDICINE_PRICE:item.MEDICINE_PRICE as number,
                      username:this.username,
                      totalCost:$totalCost})
                  }.title('返回').height('100%').width('100%').backgroundColor(Color.White)
                }
              }.width('100%')
            }
          })
        }.padding(10).columnsTemplate('1fr 1fr')
        .columnsGap(10)
        .rowsGap(15).height('75%')
        .layoutDirection(GridDirection.Row)
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
      }else{
        Text('暂无药材相关信息').position({ x: 0, y: '30%' }).fontSize(30)
          .width('100%').textAlign(TextAlign.Center)
      }
    }.mode(NavigationMode.Stack)
    .hideToolBar(true).hideTitleBar(true)
    .width('100%').height('100%')
  }
}