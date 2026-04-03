const db = require("../common/db_connection");
const { print } = require("../common/print_data");
const { appEvents } = require('../common/soket_events');
const app = require("../../index");
const socketHelper = require("../soket/soket_helper");
const time = require("../common/datetime");



const receiptItemsDBKeys = [
    'saleItemUID',
    'saleUID',
    'itemId',
    'itemQuantity',
    'itemAmount',
    'currentStatus',
    'updateOn',
    'updateBy',

];



async function saveSaleSyncLog(receiptInfo, tokenNumber = null, errorCode = null, errorMessage = null) {
    try {


        let saleUID = receiptInfo?.saleUID;
        let saleOn = receiptInfo?.saleOn;
        let saleBy = receiptInfo?.saleBy;
        let siteId = receiptInfo?.siteId;
        let totalItems = receiptInfo?.totalItems;
        let totalAmount = receiptInfo?.totalAmount;
        let paymentMode = receiptInfo?.paymentMode;
        let syncOn = time.getCurrentTimeStamp(true);
        let saleInfoJson = JSON.stringify(receiptInfo);
        tokenNumber = tokenNumber || '';
        errorCode = errorCode || '';
        errorMessage = errorMessage || '';

        let query = `INSERT INTO saleSyncLog(saleUID,tokenNumber,siteId,saleBy,saleOn,totalItems,totalAmount,paymentMode,syncOn,saleInfoJson,errorCode,errorMessage)
VALUES ('${saleUID}','${tokenNumber}','${siteId}','${saleBy}','${saleOn}','${totalItems}','${totalAmount}','${paymentMode}','${syncOn}','${saleInfoJson}','${errorCode}','${errorMessage}');`;
        await db.runMySQLQuery(db.cleanQuery(query));

    } catch (error) {

        return;

    }

}


async function saveReceipt(receiptInfo) {


    let saleUID = receiptInfo?.saleUID;
    let saleOn = receiptInfo?.saleOn;
    let saleBy = receiptInfo?.saleBy;
    let siteId = receiptInfo?.siteId;
    let totalItems = receiptInfo?.totalItems;
    let totalAmount = receiptInfo?.totalAmount;
    let remark = receiptInfo?.remark;
    let paymentMode = receiptInfo?.paymentMode;



    var output = {
        status: 0,
        message: "Failed to save.",
        tokenNumber: null,
    };


    const receiptItems = db.filerArrayListByFields((receiptInfo?.receiptItems || []), receiptItemsDBKeys);
    let itemQuery = db.generateInsert('mSaleItems', receiptItems);
    let resp0 = await db.runMySQLQuery(itemQuery);


    if (resp0.queryStatus == true || resp0?.errorCode === 'ER_DUP_ENTRY') {

        let query = `call saveReceiptInfo('${saleUID}', '${saleOn}', '${saleBy}', '${siteId}', '${totalItems}', '${totalAmount}', '${remark}', '${paymentMode}');`;
        let resp1 = await db.runMySQLQuery(query);
        if (resp1.dataCount == 1) {
            output = resp1.data[0];
        } else {
            output.errorCode = resp1?.errorCode;
            output.errorMessage = resp1?.errorMessage;
        }

    } else {
        output.errorCode = resp0?.errorCode;
        output.errorMessage = resp0?.errorMessage;
    }


    saveSaleSyncLog(receiptInfo, output?.tokenNumber, output?.errorCode, output?.errorMessage);



    return output;

}


async function saveAllReceipts(param) {
    let dataList = param?.dataList || [];

    let totalRecords = dataList.length;
    var saveCount = 0;

    var saveResponses = [];


    for (let e of dataList) {

        let resp = await saveReceipt(e);
        if (resp?.status === 1) {
            saveCount += 1;
            saveResponses.push(resp);
        }
    }

    // print("saveCount", saveCount, totalRecords, totalRecords === saveCount);


    return db.setResult(
        saveCount === totalRecords ? 1 : 0,
        `${saveCount} receipts saved.`,
        {
            "totalRecords": totalRecords,
            "saveCount": saveCount,
            "saveResponses": saveResponses,
        },);


}


function registerEvensInSocket(socket) {

    socket.on(appEvents.saveAllReceipts, async (data, callback) => {
        callback(await saveAllReceipts(data));
    });




}


exports.registerEvensInSocket = registerEvensInSocket;