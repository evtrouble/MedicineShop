import relationalStore from '@ohos.data.relationalStore';
import {database_init} from '../pages/Initial';

class Medicine_DB{
  private store:relationalStore.RdbStore;
  public initDB(context) {
    const STORE_CONFIG = {
      name: 'Manage.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S1 // 数据库安全级别
    };
    relationalStore.getRdbStore(context, STORE_CONFIG, async (err, store) => {
      if (err) {
        console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info(`Succeeded in getting RdbStore.`);

      this.store = store;
      //store.executeSql('DROP TABLE Users');
      //store.executeSql('DROP TABLE Medicine');
      //store.executeSql('DROP TABLE ShopCart');
      //store.executeSql('DROP TABLE Comments');

      await new Promise<void>((resolve) => {
        this.executeSql('create', 'CREATE TABLE IF NOT EXISTS Users(' +
        'USERNAME VARCHAR(40) NOT NULL UNIQUE PRIMARY KEY, ' +
        'PASSWORD VARCHAR(40) NOT NULL)');
        resolve();
      })
      await new Promise<void>((resolve) => {
        this.executeSql('create', 'CREATE TABLE IF NOT EXISTS ShopCart(' +
        "ID INTEGER PRIMARY KEY AUTOINCREMENT," +
        'MEDICINE_NAME VARCHAR(40) NOT NULL, ' +
        'CURRENT_PRICE DOUBLE NOT NULL, ' +
        'USERNAME VARCHAR(40) NOT NULL, ' +
        'NUMBER INTEGER NOT NULL, ' +
        'CHECK(NUMBER>0))');
        resolve();
      })
      await new Promise<void>((resolve) => {
        this.executeSql('create', 'CREATE TABLE IF NOT EXISTS Medicine(' +
        'MEDICINE_DESCRIPTION TEXT, ' +
        'MEDICINE_PRICE DOUBLE NOT NULL, ' +
        'MEDICINE_CATEGORY VARCHAR(40), ' +
        'MEDICINE_STOCK INTEGER NOT NULL, ' +
        'MEDICINE_IMAGE TEXT,' +
        'MEDICINE_NAME VARCHAR(40) PRIMARY KEY NOT NULL,' +
        'CHECK(MEDICINE_STOCK>=0 AND MEDICINE_PRICE>=0))');
        resolve();
      })
      await new Promise<void>((resolve) => {
        this.executeSql('create', 'CREATE TABLE IF NOT EXISTS Comments(' +
        'COMMENT TEXT NOT NULL, ' +
        'COMMENT_TIME DATETIME NOT NULL, ' +
        'USERNAME VARCHAR(40) NOT NULL, ' +
        'PRIMARY KEY(USERNAME, COMMENT_TIME))');
        resolve();
      })

      database_init();
    });
  }

  public insert(tableName:string,valueBucket){
    this.store.insert(tableName, valueBucket, (err, rowId) => {
      if (err) {
        console.error(`Failed to insert data into ${tableName}. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info(`Succeeded in inserting data into ${tableName}. rowId:${rowId}`);
    })
  }

  public batchInsert(tableName:string,valueBucket) {
    this.store.batchInsert(tableName, valueBucket, (err, insertNum) => {
      if (err) {
        console.error(`Failed to batchInsert data into ${tableName}.
         Code is ${err.code},message is ${err.message}`);
        return;
      }
      console.info(`Succeeded in batchInserting data into ${tableName}.
      the number of values that were inserted = ${insertNum}`);
    })
  }

  public query(predicates:relationalStore.RdbPredicates,valueBucket,callback:
    (resultSet:relationalStore.ResultSet)=>void){
    this.store.query(predicates, valueBucket, (err, resultSet) => {
      if (err) {
        console.error(`Failed to query data. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info(`ResultSet column names: ${resultSet.columnNames}`);
      console.info(`ResultSet column count: ${resultSet.columnCount}`);
      callback(resultSet);
    })
  }

  // 修改数据
  public update(predicates:relationalStore.RdbPredicates,valueBucket){
    this.store.update(valueBucket, predicates, (err, rows) => {
      if (err) {
        console.error(`Failed to update data. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info(`Succeeded in updating data. row count: ${rows}`);
    })
  }

// 删除数据
  public delete(predicates:relationalStore.RdbPredicates){
    this.store.delete(predicates, (err, rows) => {
      if (err) {
        console.error(`Failed to delete data. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info(`Delete rows: ${rows}`);
    })
  }

  public executeSql(type:string, sql:string, bindArgs=[]){
    this.store.executeSql(sql, bindArgs, function(err) {
      if (err) {
        console.error(`ExecuteSql failed, code is ${err.code},message is ${err.message}`);
        return;
      }
      console.info(`${type} table done.`);
    })
    //console.log(sql);
  }

  public querySql(sql: string, bindArgs, callback:
    (resultSet:relationalStore.ResultSet)=>void) {
    this.store.querySql(sql, bindArgs, (err, resultSet) => {
      if (err) {
        console.error(`Failed to query data. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info(`ResultSet column names: ${resultSet.columnNames}`);
      console.info(`ResultSet column count: ${resultSet.columnCount}`);
      callback(resultSet);
    })
  }
};

const DB=new Medicine_DB();
export default DB as Medicine_DB;