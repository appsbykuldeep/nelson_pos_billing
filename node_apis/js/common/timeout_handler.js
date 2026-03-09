const { v4: uuidv4 } = require('uuid');

const {print} = require("./print_data")

const pendingRequests = new Map();

// default timeout is 300 sec
function registerTimeOut(callback ,ms = null,timeoutID = null ) {
  if(timeoutID == null || timeoutID == ""){
    timeoutID = getuuidv4();
  }
  if(ms == null){
    ms = 300000;
  }

    if(ms <=0 || callback == null || pendingRequests.get(timeoutID))return;
  const timeout = setTimeout(() => {
    print(`Request to user ${timeoutID} in ${ms} ms timed out`);
    handleCallbackFunc(callback);
    pendingRequests.delete(timeoutID);
  }, ms); 

  pendingRequests.set(timeoutID, timeout);
  print("registerTimeOut",timeoutID);
  return timeoutID;
}


function handleCallbackFunc(callback = null){
    if(callback == null) return null;
    try {
        return callback();
        
    } catch (error) {
        return null;
    }

}


function getuuidv4() {
  return uuidv4();
}


function removeTimeOut(timeoutID,callback = null) {
    if(timeoutID == null || timeoutID == "" )return;
  const timeout = pendingRequests.get(timeoutID);
  if (timeout) {
    clearTimeout(timeout);
    handleCallbackFunc(callback);
    pendingRequests.delete(timeoutID);
    print("removeTimeOut",timeoutID);
  }
}


function getTimeOutKeyByValetParkingUID(parkingUID,requestToCheckInDriver = false,requestToCheckOutManager = false,requestToCheckOutDriver = false,){
  if(requestToCheckInDriver){
    return `${parkingUID}_requestToCheckInDriver`;
  }
  if(requestToCheckOutManager){
    return `${parkingUID}_requestToCheckOutManager`;
  }
  if(requestToCheckOutDriver){
    return `${parkingUID}_requestToCheckOutDriver`;
  }
 return `${parkingUID}_valet`;

}



exports.registerTimeOut = registerTimeOut;
exports.removeTimeOut = removeTimeOut;
exports.getTimeOutKeyByValetParkingUID = getTimeOutKeyByValetParkingUID;