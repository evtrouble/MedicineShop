import router from '@ohos.router';
import Medicine_DB from '../pages/Rdb'
import relationalStore from '@ohos.data.relationalStore';

export function Info(information:string):void{
  AlertDialog.show({
    message: information, // 弹窗内容
    autoCancel: true, //点击遮障层时，是否关闭弹窗。
    alignment: DialogAlignment.Center //弹窗位置
  })
}

@Entry
@Component
struct Register {
  @State private username:string=''
  @State private password:string=''
  @State private confirm_password:string=''

  build() {
    Column() {
      Text('注册账号').fontSize(40)
      Grid() {
        GridItem() {
          Text('用户名').fontSize(20)
        }

        GridItem() {
          TextInput({ placeholder: '请输入用户名' })
            .onChange((value: string) => {
              this.username = value;
            })
        }

        GridItem() {
          Text('密码').fontSize(20)
        }

        GridItem() {
          TextInput({ placeholder: '请输入密码' }).type(InputType.Password)
            .onChange((value: string) => {
              this.password = value;
            })
        }

        GridItem() {
          Text('确认密码').fontSize(20)
        }

        GridItem() {
          TextInput({ placeholder: '请确认密码' }).type(InputType.Password)
            .onChange((value: string) => {
              this.confirm_password = value;
            })
        }
      }.columnsTemplate('1fr 3fr')
      .columnsGap(10)
      .rowsGap(15).margin({top:'10%'}).height('30%')

      Button('注册').width(150).margin({ top: 20 })
        .onClick(() => {
          if(this.username=='')Info('账户名不能为空');
          else if(this.password=='')Info('密码不能为空');
          else if(this.confirm_password=='')Info('确认密码不能为空');
          else if(this.confirm_password!=this.password)Info('确认密码与密码不一致');
          else{
            let predicates = new relationalStore.RdbPredicates('Users');
            predicates.equalTo('USERNAME', this.username);
            Medicine_DB.query(predicates,["PASSWORD"],(resultSet:relationalStore.ResultSet)=>{
              if(resultSet.rowCount)Info('该用户已存在');
              else{
                Medicine_DB.insert('Users',{USERNAME:this.username,PASSWORD:this.password});
                AlertDialog.show({
                  message: '成功注册！', // 弹窗内容
                  autoCancel: false, //点击遮障层时，是否关闭弹窗。
                  alignment: DialogAlignment.Center, //
                  confirm: {
                    value: '确定',
                    action: () => {
                      router.back();
                    },
                    fontColor: '#00f'
                  }
                })
                resultSet.close();
              }
            })
        }})
      Button('返回').width(150).margin({ top: 20 })
        .onClick(() => {
          router.back();
        })
    }.margin({ top: '50%' }).width('95%')
  }
}

//user:111
//password:111