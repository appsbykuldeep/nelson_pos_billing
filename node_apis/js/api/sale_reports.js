const db = require("../common/db_connection");
const { print } = require("../common/print_data");
const { appEvents } = require('../common/soket_events');
const app = require("../../index");
const socketHelper = require("../soket/soket_helper");






async function getDailyUserWiseSaleReport(data) {
    let siteId = data?.siteId;
    let fromDate = data?.fromDate;
    let tillDate = data?.tillDate;
    let userId = data?.userId;

    let query = `call getDailyUserWiseSaleReport('${siteId}', '${fromDate}', '${tillDate}', '${userId}');`;
    return  await db.runMySQLQueryAndParseResult(query);
   

}


async function getSaleHistoryWithItems(data) {
    let siteId = data?.siteId;
    let fromDate = data?.fromDate;
    let tillDate = data?.tillDate;
    let userId = data?.userId;

    var resultData = [];
    var status = 0;
    var message = "No record found !";

    var saleItemMap = {};

    let query1 = `call getSaleMasterHistory('${siteId}', '${fromDate}', '${tillDate}', '${userId}');`;
    let resp1 = await db.runMySQLQuery(query1);

    if (resp1.dataCount > 0) {
        status = 1;
        message = 'Record found !';
        resultData = resp1.data;

        let query2 = `call getSaleItemMasterHistory('${siteId}', '${fromDate}', '${tillDate}', '${userId}');`;
        let resp2 = await db.runMySQLQuery(query2);

        if (resp2.dataCount > 0) {
            for (let e of resp2.data) {
                let preData = saleItemMap[e?.saleUID] || [];
                preData.push(e);
                saleItemMap[e?.saleUID] = preData;
            }


            for (let e of resultData) {
                e.receiptItems = saleItemMap[e?.saleUID] || [];
            }

        }




    }



    return db.setResult(status, message, resultData);

}





function registerEvensInSocket(socket) {

    socket.on(appEvents.getDailyUserWiseSaleReport, async (data, callback) => {
        callback(await getDailyUserWiseSaleReport(data));
    });

    socket.on(appEvents.getSaleHistoryWithItems, async (data, callback) => {
        callback(await getSaleHistoryWithItems(data));
    });




}


exports.registerEvensInSocket = registerEvensInSocket;