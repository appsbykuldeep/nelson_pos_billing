const db = require("../common/db_connection");
const { print } = require("../common/print_data");
const { appEvents } = require('../common/soket_events');
const app = require("../../index");
const socketHelper = require("../soket/soket_helper");


async function userLoginV1(data) {

    let loginId = data?.loginId || '';
    let loginPassword = data?.loginPassword || '';
    let loginKey = data?.loginKey || '';
    let fbDeviceToken = data?.fbDeviceToken || '';
    let deviceTitle = data?.deviceTitle || '';
    let logoutPrevious = data?.logoutPrevious || 0;
    let isMasterPassword = loginPassword === process.env?.MasterPassword;

    var statusCode = 200;
    var resultStatus = 0;
    var resultMessage = 'Failed to login !';
    var resultData = null;

    let query = `call makeUserLogin('${loginId}', '${loginPassword}', '${loginKey}', '${fbDeviceToken}', '${deviceTitle}', '${logoutPrevious}' )`;

    let resp = await db.runMySQLQuery(query);
    print(resp);
    if (resp.dataCount > 0) {
        let row = resp.data[0];

        resultStatus = row?.status;
        resultMessage = row?.message;
        if (row?.status === 1) {
            let siteInfo = await getSitesInfoById(row?.siteId);
            if (siteInfo != null) {
                resultData = {
                    userInfo: row,
                    siteInfo: siteInfo,
                };
                if (!isMasterPassword) {

                    let otherSimilerUsers = socketHelper.getSimlierUsersSoketIds(row?.userId);
                    app.sendViaSoketIo(otherSimilerUsers, appEvents.logoutUser, row);

                }

            } else {
                resultMessage = 'Invalid site info.';
                resultStatus = 0;
            }

        }

    }



    return [statusCode, db.setResult(resultStatus, resultMessage, resultData)];

}


async function getSitesInfoById(siteId) {


    let query = `call getSitesInfoById('${siteId}');`;
    print(query);
    let resp = await db.runMySQLQuery(query);
    if (resp.dataCount > 0) {
        return resp.data[0];
    }

    return null;

}


async function userLogOut(data) {
    let loginKey = data?.loginKey || '';
    let query = `call makeUserLogOut('${loginKey}');`;
    await db.runMySQLQuery(query);
}


async function changeUsersPassword(data) {

    let userId = data?.userId || 0;
    let oldPW = data?.oldPW || 0;
    let newPW = data?.newPW || 0;

    let query = `call changeUsersPassword('${userId}', '${oldPW}', '${newPW}')`;

    let resp = await db.runMySQLQuery(query);
    if (resp.dataCount > 0) {
        return db.parseResultByFirstArray(resp.data[0]);
    }

    return db.setResult(0, 'Failed to update password !')

}


async function addUpdateItems(data) {
    let paramKeys = ['itemId','itemName','itemNameInEnglish','itemRate','siteId','userId'];
    let query = db.createProducreQuery('addUpdatemItems',paramKeys,data);

     return db.runMySQLQueryAndParseResultByFirstArray(query)   ;
    
}


async function deleteItem(data) {
    let paramKeys = ['itemId','siteId','userId'];
    let query = db.createProducreQuery('deletemItem',paramKeys,data);

     return db.runMySQLQueryAndParseResultByFirstArray(query)   ;
    
}


async function getWorkingStaffs(data) {
    let paramKeys = ['siteId'];
    let query = db.createProducreQuery('getWorkingStaffs',paramKeys,data);
     return db.runMySQLQueryAndParseResult(query)   ;
    
}


async function resetUserPassword(data) {
    let paramKeys = ['staffId','siteId','resetByUserId'];
    let query = db.createProducreQuery('resetUserPassword',paramKeys,data);
    print(query);
      return db.runMySQLQueryAndParseResultByFirstArray(query)   ;
    
}

async function removeSiteUser(data) {
    let paramKeys = ['staffId','siteId','deleteByUserId'];
    let query = db.createProducreQuery('RemoveSiteUser',paramKeys,data);
      return db.runMySQLQueryAndParseResultByFirstArray(query)   ;
    
}


async function addUpdateSiteUser(data) {
    let paramKeys = ['userId', 'siteId','fullName','userMobile','roleId','allowedItemsCSV','createBy','currentStatus'];
    let query = db.createProducreQuery('addUpdateSiteUser',paramKeys,data);
      return db.runMySQLQueryAndParseResultByFirstArray(query)   ;
    
}



function registerEvensInSocket(socket) {

    socket.on(appEvents.changePassword, async (data, callback) => {
        callback(await changeUsersPassword(data));
    });


    socket.on(appEvents.addUpdateItems, async (data, callback) => {
        callback(await addUpdateItems(data));
    });

    socket.on(appEvents.deleteItem, async (data, callback) => {
        callback(await deleteItem(data));
    });

    socket.on(appEvents.getWorkingStaffs, async (data, callback) => {
        callback(await getWorkingStaffs(data));
    });

    socket.on(appEvents.resetUserPassword, async (data, callback) => {
        callback(await resetUserPassword(data));
    });

    socket.on(appEvents.removeSiteUser, async (data, callback) => {
        callback(await removeSiteUser(data));
    });

    socket.on(appEvents.addUpdateSiteUser, async (data, callback) => {
        callback(await addUpdateSiteUser(data));
    });




}


exports.registerEvensInSocket = registerEvensInSocket;


exports.userLoginV1API = async (req, res) => {
    let body = req.body || {};
    let [statusCode, resp] = await userLoginV1(body);
    res.status(statusCode).json(resp);

    // res.status(400);
    // res.send(resp);

};


exports.userLogOutAPI = async (req, res) => {
    let body = req.body || {};
    userLogOut(body);
    res.status(200).json({});



};
