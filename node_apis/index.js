require('dotenv').config();
const fs = require('fs');
const path = require('path');
const cors = require('cors');
const soketIO = require('socket.io');
var bodyParser = require('body-parser');
const express = require('express');
const app = express();
const { print } = require('./js/common/print_data');

const { serverInfo } = require('./js/common/env_setup.js');


// let noEnt = process.env.NODE_ENV;
// console.log(`Running for : ${noEnt}`);
// var isServer = noEnt == "production";
// var isLocal = noEnt == "development";


var isServer = serverInfo["isServer"] || false;
var isUat = serverInfo?.isUat || false;
var isLocal = serverInfo["isLocal"] || false;



//// For HTTP Server
const port = serverInfo["basePort"];


console.log(`Base Port: ${port},isServer:${isServer},isLocal:${isLocal},isUat:${isUat}`);

let https;
let httpServer;


https = require('http');
httpServer = https.Server(app);








const jobs = require('./js/common/schedular_jobs.js');
const db = require('./js/common/db_connection.js');
const aesEnc = require('./js/common/encryptions.js');
const helper = require('./js/common/helper.js');
const datetime = require('./js/common/datetime.js');
const retouteRequest = require('./js/common/retoute_request.js');
const soketHelper = require('./js/soket/soket_helper.js');

const comp = require("./js/api/company.js");
const counterToken = require("./js/api/counter_token.js");
const siteUsers = require("./js/api/site_user.js");
const allmaster = require("./js/api/masters/allmasterdata.js");
const sycdb = require("./js/api/masters/synclocaldb_v5.js");
const receipt = require("./js/api/receipts.js");
const saleReport = require("./js/api/sale_reports.js");



var urlencodedParser = bodyParser.json({ extended: false, limit: '50mb' });



const corsOptions = {
  origin: function (origin, callback) {
    const allowedOrigins = ["*"];



    if (!origin) {
      return callback(null, true);
    }

    if (allowedOrigins.includes('*')) {
      return callback(null, true);
    }

    if (allowedOrigins.includes(origin)) {
      return callback(null, true);
    }

    if (process.env.NODE_ENV === 'development' && origin.includes('localhost')) {
      console.log(`Allowing localhost origin in development: ${origin}`);
      return callback(null, true);
    }

    console.log(`Origin ${origin} not allowed by CORS`);
    callback(null, false);
  },
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS', 'PATCH', 'HEAD'],
  allowedHeaders: [
    'Content-Type',
    'Authorization',
    'X-Requested-With',
    'Accept',
    'Origin',
    'Access-Control-Request-Method',
    'Access-Control-Request-Headers',
    'X-Access-Token',
    'X-Refresh-Token',
    'X-API-KEY',
    'token',
  ],
  exposedHeaders: [
    'Content-Length',
    'X-Requested-With',
    'X-Access-Token',
    'X-Refresh-Token'
  ],
  credentials: true,
  maxAge: 86400,
  preflightContinue: false,
  optionsSuccessStatus: 204
};





// app.use(cors({ origin: '*' }));
app.use(cors(corsOptions));
// app.options('/', cors(corsOptions));
app.options('*', cors(corsOptions));

app.use((req, res, next) => {
  // console.log("HIT:", req.method, req.url);  
  next();
});


// CORS error middleware
app.use((err, req, res, next) => {

 
  if (err && err.message && err.message.includes('CORS')) {
    res.status(403).json({
      error: 'CORS policy violation',
      message: 'The origin is not allowed to access this resource',
      origin: req.headers.origin || 'No origin'
    });
  } else {
    next(err);
  }
});


// pingInterval :=> to regularly check if the client is still alive.
const ioOptions = { maxHttpBufferSize: 1e8, pingTimeout: (120 * 1000), pingInterval: (10 * 1000), cors: { origin: "*", methods: ["GET", "POST"], credentials: true }, transports: ["websocket"] };
const io = soketIO(httpServer, ioOptions);


// upload section

const profileDir = "/uploads/profileimages";
const standLogoDir = "/uploads/stand_logo";
const parkingImagesDir = "/uploads/parking_images";




for(const x of [profileDir,standLogoDir]){

  helper.createDir(`../..${x}` );
// app.use(x, express.static(path.join(__dirname, x)));


  let route = `${x}/:name`;
  app.get(route, async (req, res) => {
    const fileName = req.params.name;
    const filePath = path.join(__dirname, x, fileName);

    if (!fs.existsSync(filePath)) {
      await retouteRequest.getFileFromBackupServer(filePath,`${x}/${fileName}`);
        
    }

    res.sendFile(filePath);
});


}


// static dirs
for(const x of [parkingImagesDir]){
  helper.createDir(`../..${x}` );
  app.use(x, express.static(path.join(__dirname, x)));
}













// APIs Section






app.get("/api/verify", urlencodedParser, async (req, res) => {

  let resp = await db.runMySQLQuery("select 1 as Status");

  res.send(resp);

});

app.get("/api/test/getOnlineUsers", urlencodedParser, soketHelper.getOnlineUsers);

app.post("/api/userloginv1", urlencodedParser, siteUsers.userLoginV1API);
app.post("/api/userlogoutv1", urlencodedParser, siteUsers.userLogOutAPI);

// Soket Section

io.use((socket, next) => {
  const authOrQuery = socket.handshake.auth || socket.handshake.query;

  try {

   
    
    const token = authOrQuery?.token;
    const appBuildNumber = authOrQuery?.appBuildNumber || 0;    
    const deviceType = authOrQuery?.deviceType || '';    


    if (token == null || appBuildNumber == 0) {
      return next(new Error("Param not received."));
    }

    const decoded = JSON.parse(aesEnc.decryptV1(token));
    const pastDate = new Date(decoded?.deviceINDTime);

    const diffSeconds = Math.floor((Date.now() - pastDate.getTime()) / 1000);

    print(diffSeconds);
 

   

    addUpdateSocketUser(socket, decoded);
    next();
  } catch (err) {
    print(err);
    // var tt2 = db.jsonTryEncode(socket.handshake);
    return next(new Error("Authentication error"));
  }
});


 

io.on('connection', async (socket) => {

  let userType = socket["user"]?.["type"];
  let isCustomer = userType == "customer";
  let isStand = userType == "stand";


  if (!isServer) {
    socket.emit("SocketId", { SocketId: socket.id });
  }

  counterToken.registerEvensInSocket(socket);
  siteUsers.registerEvensInSocket(socket);
  allmaster.registerEvensInSocket(socket);
  sycdb.registerEvensInSocket(socket);
  receipt.registerEvensInSocket(socket);
  saleReport.registerEvensInSocket(socket);


  socket.on('disconnect', async function () {
    soketHelper.removeUser(socket.id);
  });


  if (isLocal) {
    socket.onAny((event, ...args) => {
      print(`📩 Event: ${event}`);
      // print(`📩 Event: ${event}`, args);
    });

  }

});






 


httpServer.listen(port , async () => {
  console.log(`Server running on *: ${port}`);

    if (isServer) {
    jobs.CreateJob();
  }

  if (isLocal) {

  }


});




async function addUpdateSocketUser(socket, userInfo) {
  userInfo["socketId"] = socket.id;
  userInfo["connectedOn"] = datetime.getCurrentTimeStamp();
  socket.user = userInfo;
  let type = userInfo?.["type"];
  let standId = userInfo?.standId || 0;

   await soketHelper.addUpdateUser(socket.id, userInfo);

}




function sendViaSoketIo(soketIds, event, data = null) {  

  if (soketIds == null || (Array.isArray(soketIds) && soketIds.length == 0)) {
    return false;
  }

  var encodedData = null;
  if (data != null) {
    try {
      encodedData = JSON.stringify(data);
    } catch (e) {
      encodedData = data;
    }
  }

  try {

    io.to(soketIds).emit(event, encodedData);
    return true;
  } catch (e) {
    print("sendViaSoketIo", e);
    return false;
  }
}


function waitForClientResponse(socket, eventName, timeout = 1500) {
  return new Promise((resolve, reject) => {
    const timer = setTimeout(() => {
      socket.off(eventName, onResponse);
      // reject(new Error('Timeout waiting for response'));
      resolve([false, 'Timeout waiting for response', null]);
    }, timeout);

    const onResponse = (data) => {
      clearTimeout(timer);
      resolve([true, "Response receive from user !", data]);
    };

    socket.once(eventName, onResponse);
  });
}


async function sendViaSoketIoWithAck(soketId, event, data = null, timeout = 1500) {
  try {
    const socket = io.sockets.sockets.get(soketId);
    if (!socket) {
      return [false, "User Not online", null];
    }
    socket.emit(event, db.jsonTryEncode(data));
    return await waitForClientResponse(socket, `${event}_ack`, timeout);

  } catch (e) {
    print("sendViaSoketIoWithAck", e);
    return [false, "Something was wrong !", null];
  }
}





function disconnectSoketById(socketId) {

  try {

    io.sockets.sockets.get(socketId)?.disconnect(true);

  } catch (e) {
    return;
  }

}


// waAutomation.registerAutomation();

exports.sendViaSoketIo = sendViaSoketIo;
exports.sendViaSoketIoWithAck = sendViaSoketIoWithAck;
exports.disconnectSoketById = disconnectSoketById;


/*
 run server with temp env variable in mac/linus

clear && NODE_ENV=local node index.js

clear && NODE_PORT=3000 NODE_ENV=local node index.js

*/

/*
 run server with temp env variable in windows

set  set NODE_ENV=local&& node index.js

set NODE_PORT=3000&& set NODE_ENV=local&& node index.js


*/


