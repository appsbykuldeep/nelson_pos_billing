require('dotenv').config();


let nodeENV = process.env.NODE_ENV || "development";
let nodePort = process.env.NODE_PORT || 8080;

var isUat = nodeENV === "uat";
var isServer = nodeENV === "production" || isUat;
var isLocal = !(isServer || isUat);





const serverInfo = {
    "isServer" : isServer,
    "isUat" : isUat,
    "isLocal" : isLocal,
    "basePort" : nodePort,
};


exports.serverInfo = serverInfo;