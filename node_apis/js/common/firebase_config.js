var admin = require("firebase-admin");

var isInit = false;


if (isInit == false) {

  isInit = true;
  try {

    var serviceAccount = require("../assets/firebase-vparking-admin.json");
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });


  } catch (error) {
    //Noting to do
  }


}




module.exports.admin = admin;

// exports.sendAssignTaskMessage = sendAssignTaskMessage;