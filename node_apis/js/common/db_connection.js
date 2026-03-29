require('dotenv').config();
var mysql = require("mysql2/promise");
const helper = require('./helper.js');
const { print } = require('./print_data');
const zlib = require('zlib');
const util = require('util');
const gzipAsync = util.promisify(zlib.gzip);



const dbCredentials = {
    connectionLimit: 20,


    host: process.env.MySQL_host,
    user: process.env.MySQL_user,
    password: process.env.MySQL_password,
    database: process.env.MySQL_database,

    waitForConnections: true,
    enableKeepAlive: true,
    keepAliveInitialDelay: 0,
    queueLimit: 1000,

    typeCast: function (field, next) {
        if (field.type === 'DATETIME' || field.type === 'DATE' || field.type === 'TIMESTAMP') {
            return field.string();
        }




        return next();
    }
};


const mysqlPool = mysql.createPool(dbCredentials);


const RETRYABLE_CODES = new Set([
    'EPIPE',
    'PROTOCOL_CONNECTION_LOST',
    'ECONNRESET',    
]);



function getPoolConnectionCount() {
    return {
        "allConnections": mysqlPool.pool._allConnections.length,
        "freeConnections": mysqlPool.pool._freeConnections.length,
    };
}


async function mySQLQueryExecuter(query) {
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


        const [result] = await mysqlPool.query(query);

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
        print(query);
        print(err);
        output.errorCode = err?.code;
        output.errorMessage = err?.message;


    }



    return output;

}


async function runMySQLQuery(query, retryCount = 0,delayMS = 2000) {



    if(retryCount <= 0){
        return await mySQLQueryExecuter(query);
    }

    var result = null;

    for (let i = 0; i <= retryCount; i++) {
        result = await mySQLQueryExecuter(query);
        if (result?.errorCode == null || !RETRYABLE_CODES.has(result?.errorCode)) {
            break;
        }
         print(result,"retryCount",retryCount);
      
        await asyncDelay(delayMS);
    }

   

return result;
}







/**
 * Uesed to run MySQL Query And Parse Result By FirstArray
 * @param {*} query str
 * @param {*} onNoDataFound callback function. It must return setResult like response
 * @returns setResult
 */

async function runMySQLQueryAndParseResultByFirstArray(query, onNoDataFound = null) {
    var result = await runMySQLQuery(query);
    if (result.queryStatus && result.dataCount > 0) {
        return parseResultByFirstArray(result.data[0]);
    } else if (onNoDataFound != null) {
        // It must return setResult like response
        return onNoDataFound();
    }
    else {
        return setResult(false, "No record found", null);

    }
}


async function runMySQLQueryAndGetFirstRecordParseResult(query, onNoDataFound = null) {
    var result = await runMySQLQuery(query);
    if (result.queryStatus && result.dataCount > 0) {
        return setResult(true, "Record found", result.data[0]);
    } else if (onNoDataFound != null) {
        // It must return setResult like response
        return onNoDataFound();
    }
    else {
        return setResult(false, "No record found", null);

    }
}







/**
 * Uesed to run MySQL Query And Parse Result By FirstArray
 * @param {*} query str
 * @param {*} recordFoundMessage str
 * @param {*} recordNotFoundMessage str
 * @returns setResult
 */

async function runMySQLQueryAndParseResult(query, recordFoundMessage = null, recordNotFoundMessage = null) {

    var result = await runMySQLQuery(query);
    if (result.queryStatus && result.dataCount > 0) {
        return setResult(1, recordFoundMessage || "Record found !", result.data);
    } else if (result.errorMessage != null) {
        return setResult(0, result.errorMessage, null);
    }
    else {
        return setResult(0, recordNotFoundMessage || "Record not found !", null);

    }
}



async function testDB() {
    console.log("called testDB");
    const start = Date.now();
    // let query = "call ProGetParkedVechialPaymentMaster(812,'');";
    let query = "call ProGetParkedVehicalMaster(812,'');";
    var resp = await runMySQLQuery(query);
    const end = Date.now();
    console.log("Time taken:", (end - start), "ms");
    console.log("testDB", resp.dataCount);
}


function isArrayStatusTrue(result) {
    let status = result['ResultStatus'] ?? result['status'] ?? result['Status'];
    return isValueTrue(status);
}

function isValueTrue(value) {
    return [1, "1", true, "true"].includes(value);
}


// similer to procedureStr in php
function createProducreQuery(procedureName, paramsKyes = [], inputData = {}) {
    if (paramsKyes.length == 0) {
        return `call ${procedureName}();`
    }

    var paramValues = [];
    for (const [i, key] of Object.entries(paramsKyes)) {
        let x = inputData[key] || "";
        paramValues.push(`'${x}'`);
    }
    return `call ${procedureName}(${paramValues.join(",")});`
}


async function getTableColumnNames(tableName) {
    let resp = await runMySQLQuery(`call GetColumnNames('${tableName}');`);

    if (resp.queryStatus && resp.dataCount > 0) {
        return resp.data.map((e) => e["COLUMN_NAME"]);

    }

    return [];

}


// Helper function to filter data by keys
function filterArrayByFields(array, keys) {
    const filteredItem = {};
    let loweKeys = keys.map(e => e.toLowerCase());

    for (const [key, value] of Object.entries(array)) {
        if (loweKeys.includes(key.toLowerCase())) {
            filteredItem[key] = array[key];
        }
    }
    return filteredItem;


}

function filerArrayListByFields(arrayList, keys){
    return arrayList.map(e => filterArrayByFields(e,keys))
}


function isString(value) {
    return (typeof value == 'string');

}





//   // Helper function to filter data by keys
//   function filterArrayByFields(array, keys) {
//     const filteredItem = {};

//     for (const [i, key] of Object.entries(keys)){
//         filteredItem[key] = array[key];
//     }
//     return filteredItem;


//   }

//   // Helper function to filter data by keys
//   function filterArrayByFields(array, keys) {


//     return array.map(item => {
//       const filteredItem = {};
//       keys.forEach(key => {
//         if (item[key] !== undefined) {
//           filteredItem[key] = item[key];
//         }
//       });
//       return filteredItem;
//     });
//   }


function parseResultByFirstArray(data) {
    const [status, message, copyData] = getResultByFirstArray(data);
    return setResult(status, message, copyData);
}


function getResultByFirstArray(data) {
    const copyData = { ...data };
    let status = (data['status'] ?? data['Status'] ?? 0) == 1;
    let message = (data['message'] ?? data['Message'] ?? '') || '';
    delete copyData.status;
    delete copyData.Status;
    delete copyData.message;
    delete copyData.Message;
    return [status, message, copyData];
}



function setResult(status = 0, message = "No Record found", data = null) {
    return {
        ResultStatus: status,
        ResultMsj: message,
        ResultData: data,

    };
}



const jsonTryEncode = (obj) => {

    if (obj == null) return "";
    try {
        return JSON.stringify(obj);
    } catch (e) {
        return "";

    }
}
const jsonTryDecode = (jsonstr) => {
    if (jsonstr == null) return null;
    try {
        return JSON.parse(jsonstr);
    } catch (e) {
        return jsonstr;

    }
}


const SaveServerErrors = async (error, source = null, category = null,) => {

    // if(source == "dbo.SaveServerErrors") return;
    // var params = {
    //     Category: category,
    //     SourceName : source,
    //     ErrorMessage :  String(error),
    // };
    // return await runQuery("dbo.SaveServerErrors",params);

};


function generateInsert(table, data, other = null, type = "INSERT", emptyOnNull = true) {
    let rowsArray = [];
    let colArray = [];
    let sql = "";

    if (Array.isArray(data)) {
        let datacount = data.length;
        for (let i = 0; i < datacount; i++) {
            const row = data[i];
            if (i === 0) {
                colArray = Object.keys(row);
            }
            rowsArray.push(oneInsertRow(Object.values(row), other, emptyOnNull));

        }

    }


    if (rowsArray.length > 0) {

        const columns = colArray.map(col => `\`${col}\``).join(", ");
        const values = rowsArray.join(", ");
        sql = `${type} INTO \`${table}\` (${columns}) VALUES ${values};`;

    }

    return sql;
}


function oneInsertRow(data, other, emptyOnNull = true) {
    if (other !== null) {
        data = [...data, ...Object.values(other)];
    }

    const escapedValues = data.map(d => toInsertStr(realEscapeString(d), emptyOnNull));
    return `(${escapedValues.join(", ")})`;
}


function toInsertStr(value, emptyOnNull = true) {
    if (isSqlFunction(value)) {
        return value; // assumed to be raw SQL like `NOW()`
    } else if (value == null || value == undefined) {
        if (emptyOnNull) {
            return `''`;

        } else {
            return `null`;
        }
    }
    else {
        return `'${value}'`;
    }
}

const knownFunc = ['calculatedistance', 'checkmobileavailibility', 'checkmobileavailibilityv2', 'convertinddatetimezone'
    , 'extact24hrstime', 'formatfromdate', 'formattilldate', 'generatereferralcode', 'getactivefreeplanid'
    , 'getlastsyncormindatetime', 'getpassexpiredatetime', 'getprintablecurrencysymbol', 'getregioncodeid'
    , 'haveticketlimit', 'haveworkstafflimit', 'haveworkstafflimitv2', 'inddatemonthdiff'
    , 'inddatetimemonthdiff', 'indtime', 'parsedatetimeornull','IsSyncedToServer', 'isSyncedToServer'];

function isSqlFunction(value) {


    if (typeof value === 'string') {
        value = value.toLowerCase();
        if (value.includes('(')
            && value.includes(')')
            && knownFunc.some(x => value.includes(x))) {

            return true;
        }
    }

    return false;


}


function realEscapeString(input) {
    if (typeof input !== 'string') return input;

    return input
        .replace(/\\/g, '\\\\')
        .replace(/\0/g, '\\0')
        .replace(/\n/g, '\\n')
        .replace(/\r/g, '\\r')
        .replace(/'/g, "\\'")
        .replace(/"/g, '\\"')
        .replace(/\x1a/g, '\\Z');
}


function cleanQuery(query) {
    return query
        .replace(/\s+/g, " ")   // collapse multiple spaces/newlines/tabs into one space
        .trim();                // remove leading/trailing spaces
}



async function compressJson(jsonData) {
    try {
        return await gzipAsync(JSON.stringify(jsonData));
    } catch (error) {
        return null;
    }

}

async function asyncDelay(ms = 2000) {
    await new Promise(resolve => setTimeout(resolve, ms));
}


exports.runMySQLQuery = runMySQLQuery;
exports.jsonTryEncode = jsonTryEncode;
exports.jsonTryDecode = jsonTryDecode;
exports.SaveServerErrors = SaveServerErrors;
exports.setResult = setResult;
exports.parseResultByFirstArray = parseResultByFirstArray;
exports.getResultByFirstArray = getResultByFirstArray;
exports.filterArrayByFields = filterArrayByFields;
exports.generateInsert = generateInsert;
exports.createProducreQuery = createProducreQuery;
exports.isArrayStatusTrue = isArrayStatusTrue;
exports.isValueTrue = isValueTrue;
exports.testDB = testDB;
exports.runMySQLQueryAndParseResultByFirstArray = runMySQLQueryAndParseResultByFirstArray;
exports.runMySQLQueryAndParseResult = runMySQLQueryAndParseResult;
exports.getTableColumnNames = getTableColumnNames;
exports.cleanQuery = cleanQuery;
exports.runMySQLQueryAndGetFirstRecordParseResult = runMySQLQueryAndGetFirstRecordParseResult;
exports.compressJson = compressJson;
exports.asyncDelay = asyncDelay;
exports.mySQLQueryExecuter = mySQLQueryExecuter;
exports.filerArrayListByFields = filerArrayListByFields;


/*
Pass Table as Param in node js

https://chat.openai.com/share/9f8f2be2-3d98-4d7d-8624-d4bafb879de5

*/

/// https://stackoverflow.com/questions/24100218/socket-io-send-packet-to-sender-only