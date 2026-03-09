const { Mutex } = require('async-mutex');

const { print } = require("../common/print_data");


const app = require("../../index");

const mutex = new Mutex();


const connectedUsers = [];
const soketIdToTypeMap = new Map();









async function removeUser(soketId, onUserRemoved = null) {
    var userInfo = null;

    const release = await mutex.acquire();
    try {
        const index = connectedUsers.findIndex(item => item?.socketId === soketId);
        if (index !== -1) {
            const removed = connectedUsers.splice(index, 1);
            userInfo = removed[0];
            print(`Removed user:`, userInfo);
            if (userInfo["type"] == "stand") {
                updateOnlineStandUsersOnConnectOrDisconnect(userInfo["standId"]);
            }
        }
    } finally {
        release();
    }




}





async function addUpdateUser(soketId, updatedUserInfo) {
    if (updatedUserInfo == null) {
        return;
    }



    updatedUserInfo.soketId = soketId;
  let type = updatedUserInfo?.type;

    var isAddingInfo = false;
    const release = await mutex.acquire();
    try {
        isAddingInfo = soketIdToTypeMap[soketId] == null;
      
        if (isAddingInfo) {


            connectedUsers.push(updatedUserInfo);
            soketIdToTypeMap[soketId] = type;
            print(`Added user: ${type}`, updatedUserInfo);

        } else {

           updateUserBySocketId(soketId, connectedUsers, updatedUserInfo);
            soketIdToTypeMap[soketId] = type;

            print(`Updated user: ${type}`, updatedUserInfo);


        }


    } catch (error) {

        print(error);
    }
    finally {
        release();
    }
    print("isAddingInfo", isAddingInfo, type);






}


function getSiteUsersSoketIds(siteId,skipUser = null){
        return connectedUsers.filter(e=>  e?.siteId === siteId && (skipUser == null || e?.socketId !== skipUser)  ).map(e => e.socketId);
}

function getSimlierUsersSoketIds(userId,skipUser = null){
        return connectedUsers.filter(e=> e?.isMasterUser != 1 && e?.userId === userId && (skipUser == null || e?.socketId !== skipUser) ).map(e => e.socketId);
}




exports.removeUser = removeUser;
exports.addUpdateUser = addUpdateUser;
exports.getSiteUsersSoketIds = getSiteUsersSoketIds;
exports.getSimlierUsersSoketIds = getSimlierUsersSoketIds;


exports.getOnlineUsers = async (req, res) => {
    let body = req.body || {};
    res.send(connectedUsers);

};

