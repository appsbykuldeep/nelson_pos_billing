const db = require("../../common/db_connection");
const { print } = require('../../common/print_data');
const { appEvents } = require("../../common/soket_events");





function getMastersProcedures(postData){
    return {

        itemsMaster: {
            flag: postData["itemsMaster"],
            procedure: 'getItemsMaster',
            param: postData["itemsMasterLastSync"] ?? '',
        },

    };
}



async function getAllMasterDataV2(postData,socketId = null) {

    if (postData == null) {
        postData = {};
    }



    const standId = postData?.siteId || 0;

    const masterData = {};

    if (standId <= 0) {
        return masterData;
    }

    const procedures = getMastersProcedures(postData);
    var dataCount = 0;

    for (const [key, config] of Object.entries(procedures)) {

        if (config.flag === 1) {
            try {
                let query = `CALL ${config.procedure}('${standId}', '${config.param || ""}')`;
                var result = await db.runMySQLQuery(query);
                dataCount += result.dataCount;
                masterData[key] = result.queryStatus ? result.data : [];

            } catch (err) {
                masterData[key] = [];
            }
        }
    }


    print("data count",dataCount);

    masterData["totaldatacount"] = dataCount;


    if(dataCount > 100){
        return db.compressJson(masterData);
    }


    
    return masterData;
}





async function getItemMasters(data) {
    let siteId = data?.siteId;
    let lastSync = data?.lastSync;
    let query = `call getItemsMaster('${siteId}', '${lastSync}');`;
    return db.runMySQLQueryAndParseResult(query);    
}





function registerEvensInSocket(socket) {

    socket.on(appEvents.getAllMasterDataV2, async (data, callback) => {
        callback(await getAllMasterDataV2(data, socket?.socketId));
    });
    socket.on(appEvents.getItemMasters, async (data, callback) => {
        callback(await getItemMasters(data, socket?.socketId));
    });



}





exports.registerEvensInSocket = registerEvensInSocket;


