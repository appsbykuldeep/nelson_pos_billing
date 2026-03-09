require('dotenv').config();
var mysql = require("mysql2/promise");
const helper = require('./helper.js');
const { print } = require('./print_data');
const {generateInsert} = require("./db_connection.js");


// http://localhost:1100/api/syncServerDb
// http://82.112.238.169:1100//api/syncServerDb


const dbCredentialsHostinger = {
    connectionLimit: 20,
    host: process.env.MySQL_host,
    user: process.env.MySQL_user,
    password: process.env.MySQL_password,
    database: process.env.MySQL_database,
    typeCast: function (field, next) {
        if (field.type === 'DATETIME' || field.type === 'DATE' || field.type === 'TIMESTAMP') {
            return field.string();
        }

        return next();
    }
};


const mysqlPoolHostinger = mysql.createPool(dbCredentialsHostinger);




const dbCredentialsNode = {
    connectionLimit: 20,
    host: process.env.MySQL_host_v2,
    user: process.env.MySQL_user_v2,
    password: process.env.MySQL_password_v2,
    database: process.env.MySQL_database_v2,
    typeCast: function (field, next) {
        if (field.type === 'DATETIME' || field.type === 'DATE' || field.type === 'TIMESTAMP') {
            return field.string();
        }

        return next();
    }
};


const mysqlPoolNode = mysql.createPool(dbCredentialsNode);




async function runMySQLQuery(pool,query) {
    // const connection = mysql.createConnection(dbCredentials);
    // const promiseConnection = connection.promise();
    // var isProcedure = query.trim().toLowerCase().startsWith('call');
    var output = {
        queryStatus: false,
        affectedRows: 0,
        insertId: 0,
        dataCount: 0,
        data: [],
        errorMessage: null,
    };

    try {

        if (query == null || query == "" || query.length < 4) {
            output.errorMessage = `Invalid query::${query}.`;
            return output;
        }


        const [result] = await pool.query(query);

        if (result != null) {
            output.queryStatus = true;
            if (Array.isArray(result)) {
                var isProcedure = (result.length == 2) && Array.isArray(result[0]);
                output.data = isProcedure ? result[0] : result;
                output.dataCount = output.data.length;
            } else {
                output.affectedRows = result["affectedRows"];
                output.insertId = result["insertId"];
            }
        }



    } catch (err) {
        // print(err);
        output.errorMessage = err.message;


    }

    //    print({
    //         "query" : query,
    //         "output" : output,
    //     });
    // connection.end();
    return output;
}

function chunkArray(arr, size = 500) {
    const result = [];
    for (let i = 0; i < arr.length; i += size) {
        result.push(arr.slice(i, i + size));
    }
    return result;
}





async function getAllTalbes(pool,dbname ) {

    var tables = [];     

    let query = `SELECT table_name,TABLE_TYPE FROM information_schema.tables WHERE table_schema = '${dbname}' AND TABLE_TYPE = 'BASE TABLE';`;

    let resp = await runMySQLQuery(pool,query);

        for (var row of resp.data){
            tables.push(row["table_name"]);
        }
     
        return tables;
    
}



async function getAllDropViewTableQuery(pool,dbname ) {

    var tables = [];     

    let query = `SELECT table_name,TABLE_TYPE FROM information_schema.tables WHERE table_schema = '${dbname}' AND TABLE_TYPE = 'VIEW';`;

    let resp = await runMySQLQuery(pool,query);

        for (var row of resp.data){
            let name = row["table_name"];
            tables.push(`drop TABLE IF EXISTS ${name};`);
        }
        print(tables.join("\n"));
     
        return tables;
    
}



const skipTalbes = [
  'collectionamountinfoview',
  'dailycustomersvechicals',
  'dailycustomersdetails',
  'issuednfrfcards',
  'mchargestype',
  'mconfigurationparams',
  'mcurrentstatus',
];


const talbeConfig = {
  marketingwhatsapp: { colName: 'Id', type: 'PK_Int' },
  mcompany: { colName: 'CompanyID', type: 'PK_Int' },
  mcountrybaseinfo: { colName: 'CountryBaseInfoId', type: 'PK_Int' },
  mexitpoint: { colName: 'ExitPointID', type: 'PK_Int' },
  monlinepaidin: { colName: 'Id', type: 'PK_Int' },
  mparkingpasses: { colName: 'ParkingPassId', type: 'PK_Int' },
  mplans: { colName: 'PlanId', type: 'PK_Int' },
  mplantype: { colName: 'PlanTypeId', type: 'PK_Int' },
  mpointtransactiontype: { colName: 'TypeId', type: 'PK_Int' },
  mreferearnplans: { colName: 'ReferEarnId', type: 'PK_Int' },
  mreferredstand: { colName: 'ReferredId', type: 'PK_Int' },
  mregioncode: { colName: 'RegionCodeId', type: 'PK_Int' },
  mrole: { colName: 'RoleId', type: 'PK_Int' },
  mstand: { colName: 'Id', type: 'PK_Int' },
  mstandcharges: { colName: 'Id', type: 'PK_Int' },
  mstandplanhistory: { colName: 'Id', type: 'PK_Int' },
  mstandschedularjobs: { colName: 'SchedularJobsId', type: 'PK_Int' },
  mvechialtype: { colName: 'Id', type: 'PK_Int' },
  mvehicalcategory: { colName: 'Id', type: 'PK_Int' },
  mworkingstaff: { colName: 'Id', type: 'PK_Int' },
  otpsms: { colName: 'Id', type: 'PK_Int' },
  parkedvechialpayment: { colName: 'Id', type: 'PK_Int' },
  parkedvehical: { colName: 'Id', type: 'PK_Int' },
  parkingpasshistory: { colName: 'ParkingPassHistoryId', type: 'PK_Int' },
  razorpaywebhook: { colName: 'WebhookId', type: 'PK_Int' },
  whatsappwebhook: { colName: 'WebhookId', type: 'PK_Int' },
  valetparkingrequestlog: { colName: 'RequestLogID', type: 'PK_Int' },
  standgeotagging: { colName: 'GeoTaggingId', type: 'PK_Int' },
  planusescache: { colName: 'id', type: 'PK_Int' },
  userloginhistory: { colName: 'LoginHistoryId', type: 'PK_Int' },
  chargesrule: { colName: 'ChargesRuleId', type: 'PK_Int' },
  mparkinglots: { colName: 'ParkingLotID', type: 'PK_Int' },


  staffwallettransactions: { colName: 'CreatedOn', type: 'datetime' },
  vehicleswhatsappnumber: { colName: 'CreatedOn', type: 'datetime' },
  paymentactivitytracking: { colName: 'LastUpdateOn', type: 'datetime' },
  mparkingnotes: { colName: 'CreatedOn', type: 'datetime' },
  mslipprinthistory: { colName: 'CreatedOn', type: 'datetime' },
  mwhatsappmessages: { colName: 'createdOn', type: 'datetime' },
  minstantreceiptlocaldb: { colName: 'SyncedOnSerer', type: 'datetime' },
  mparkedpassvehiclelocaldb: { colName: 'SyncedOnSerer', type: 'datetime' },
  mparkedpassvehiclelocaldbtempdata: { colName: 'SyncedOnSerer', type: 'datetime' },
  mparkedvechialpaymentlocaldb: { colName: 'SyncedOnSerer', type: 'datetime' },
  mparkedvechialpaymentlocaldbtempdata: { colName: 'SyncedOnSerer', type: 'datetime' },
  mparkedvehicallocaldb: { colName: 'SyncedOnSerer', type: 'datetime' },
  mparkedvehicallocaldbtempdata: { colName: 'SyncedOnSerer', type: 'datetime' },
  mparkingpasshistorylocaldb: { colName: 'SyncedOnSerer', type: 'datetime' },
  mparkingpasshistorylocaldbtempdata: { colName: 'SyncedOnSerer', type: 'datetime' },
  mpointtransactionlocaldb: { colName: 'SyncedOnSerer', type: 'datetime' },
};


async function insertInNodeDb(tableName,data,totalData) {
          const batches = chunkArray(data, 5000);
          i = 0;
        for (const batch of batches){      
             i+=batch.length;      
             let que =  generateInsert(tableName,batch,null,"replace",false);
            //  print(que);
             let res =  await runMySQLQuery(mysqlPoolNode,que);
             if(!res.queryStatus){
                helper.saveTextFile("error.sql","/error_log/",que);
                
                return true;
             }
             print(`inserted ${tableName}`,i,totalData);
            

        }
    

return false;
    }


async function pullData(tableName) {
        let tname = tableName.toLowerCase();
    if (skipTalbes.includes(tname)) {
    return;
        }

    
    let colName = talbeConfig?.[tname]?.colName;
    let type = talbeConfig?.[tname]?.type;

    var q0 =  null;
    var q1 =  null;
    var lastValue = null;
    if(type == 'PK_Int' ){
        q0 =  `select ifnull(max(${colName}),0) as LastValue from ${tableName} ;`;
    }
    if( type == 'datetime'){
        
        q0 =  `select ifnull(max(${colName}),'2000-01-01') as LastValue from ${tableName} ;`;
        // return;
    }

    if(q0 != null){
        let res0 = await runMySQLQuery(mysqlPoolNode,q0);
       
        if(res0.dataCount > 0){
            lastValue = res0.data[0]["LastValue"];
        }

         q1 = `select * from ${tableName} where ${colName} > '${lastValue}';`;      


    }else{
        q1 = `select * from ${tableName};`;
    }

   
    
    if(q1 != null ){
        print(q1);

              let res1 = await runMySQLQuery(mysqlPoolHostinger,q1);
              if(!res1.queryStatus){
                print(res1);
              }
            
     return await  insertInNodeDb(tableName,res1.data,res1.dataCount);

     


    }


}

async function syncServerDb() {
    // await getAllDropViewTableQuery(mysqlPoolHostinger,dbCredentialsHostinger.database);
    // return;
  let tables =    await getAllTalbes(mysqlPoolHostinger,dbCredentialsHostinger.database);

    for (var table of tables.values()){
        
        
        if(await pullData(table) == true){
            break;
        }
    }
}




exports.syncServerDb = syncServerDb;
