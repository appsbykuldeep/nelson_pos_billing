const db = require("../common/db_connection");
const { v4: uuidv4 } = require('uuid');
const { appEvents } = require('../common/soket_events');
const app = require("../../index");
const socketHelper = require("../soket/soket_helper");
const { getCurrentDate } = require("../common/datetime");

async function GetCounterTokenByUser(data, socketId = null) {

    let siteId = data?.siteId;
    let userId = data?.userId;
    let tokenType = data?.tokenType || '-';
    let tokenDate = data?.tokenDate || getCurrentDate();
    const tokenUID = uuidv4();

    let query = `call GetCounterTokenByUser('${siteId}','${userId}','${tokenType}', '${tokenDate}','${tokenUID}')`;
    let resp = await db.runMySQLQuery(query);
    if (resp.queryStatus && resp.dataCount > 0) {
        let tokenNumber = resp.data[0]?.tokenNumber;
        let generatedOn = resp.data[0]?.generatedOn;

        let otherUser = socketHelper.getSiteUsersSoketIds(siteId, socketId);
        app.sendViaSoketIo(otherUser, appEvents.updateLastCounterToken, { tokenNumber: tokenNumber, generatedOn: generatedOn });

        return db.setResult(1, "token number", resp.data[0]);

    }


    return db.setResult(0,resp.errorMessage ?? 'Failed to get token');

}


function informLastCounterToken(data) {

}

async function GetLastCounterToken(data) {
    let siteId = data?.siteId;
    let tokenType = data?.tokenType || '-';
    let tokenDate = data?.tokenDate || getCurrentDate();

    let query = `call GetLastCounterToken('${siteId}','${tokenType}','${tokenDate}')`;
    let resp = await db.runMySQLQuery(query);

    var outResult = {};

    if (resp.dataCount > 0) {
        outResult.tokenNumber = resp.data[0]?.tokenNumber;
        outResult.generatedOn = resp.data[0]?.generatedOn;

        return db.setResult(1, '', outResult);
    }

    return db.setResult();
}




async function getSiteWiseTokenHistory(data) {
    let siteId = data?.siteId || 0;
    let fromDateTime = data?.fromDateTime || '';
    let tillDateTime = data?.tillDateTime || '';

    let query = `call getSiteWiseTokenHistory('${siteId}', '${fromDateTime}', '${tillDateTime}' )`;

    return db.runMySQLQueryAndParseResult(query);
    
}

async function getUserWiseTokenHistory(data) {
    let userId = data?.userId || 0;
    let fromDateTime = data?.fromDateTime || '';
    let tillDateTime = data?.tillDateTime || '';

    let query = `call getUserWiseTokenHistory('${userId}', '${fromDateTime}', '${tillDateTime}' )`;

    return db.runMySQLQueryAndParseResult(query);
    
}


function registerEvensInSocket(socket) {

    socket.on(appEvents.getCounterTokenByUser, async (data, callback) => {
        callback(await GetCounterTokenByUser(data, socket?.socketId));
    });

    socket.on(appEvents.getLastCounterToken, async (data, callback) => {
        callback(await GetLastCounterToken(data));
    });

    socket.on(appEvents.getSiteWiseTokenHistory, async (data, callback) => {
        callback(await getSiteWiseTokenHistory(data));
    });
    socket.on(appEvents.getUserWiseTokenHistory, async (data, callback) => {
        callback(await getUserWiseTokenHistory(data));
    });


}


exports.registerEvensInSocket = registerEvensInSocket;