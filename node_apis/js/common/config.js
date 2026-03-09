const { print } = require('./print_data');
require('dotenv').config();
var config = null;

var whatsAppDefaultCreds = {};
var whatsAppCompCreds = {};
var whatsAppStandCreds = {};
var mailCreds = {};
// map of whatsapp number id : alternate contact number
var supportWAMessages = {};
 

if (config == null) {
    try {
        config = require('../assets/config.json');

    } catch (error) {
        print(error)
        config = {};
    }

     whatsAppDefaultCreds = config?.["whatsAppDefaultCreds"] || {};
     whatsAppCompCreds = config?.["whatsAppCompCreds"] || {};
     whatsAppStandCreds = config?.["whatsAppStandCreds"] || {};
     mailCreds = config?.["mailCreds"] || {};
     supportWAMessages = config?.["supportWAMessages"] || {};
     config["backupServer"] = process.env?.["backupServer"];

  
     
}





exports.whatsAppDefaultCreds = whatsAppDefaultCreds ;
exports.whatsAppCompCreds = whatsAppCompCreds ;
exports.whatsAppStandCreds = whatsAppStandCreds ;
exports.mailCreds = mailCreds ;
exports.supportWAMessages = supportWAMessages ;
exports.backupServer = config?.["backupServer"] || "" ;