const db = require("../../common/db_connection");
const soketHelper = require("../../soket/soket_helper");
const app = require("../../../index");

const { print } = require('../../common/print_data');
const { appMasterDataType, appEvents } = require('../../common/soket_events');



 
const instantReceiptMasterDBKeys = [
  'instantReceiptUID',
  'irReceiptNo',
  'standId',
  'vehicleId',
  'vehicleCategoryId',
  'remark',
  'parkingCharge',
  'paymentMode',
  'issuedOn',
  'issuedByUser',
  'countryCallingCode',
  'whatsappNo',
  'currentStatus',
  'isSyncedToServer',
  'InstanceUID',
];










async function syncLocalDBV5(postData,socketId = null) {




  return finalOutput;
}






function registerEvensInSocket(socket) {

    socket.on(appEvents.syncLocalDBV5, async (data, callback) => {
        callback(await syncLocalDBV5(data, socket?.socketId));
    });



}



exports.registerEvensInSocket = registerEvensInSocket;




