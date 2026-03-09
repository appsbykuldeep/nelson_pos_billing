
const {whatsAppCompCreds,whatsAppStandCreds,whatsAppDefaultCreds} = require("./config");



// //TODO: config creds
// const whatsAppCompCreds = {

//     2 : {
//         WBNumberId :"382613481609522",
//         WBNumber :"9452094430",
//         APIVersion :"v22.0",
//         AccessToken : "EAAYWCQTh2hIBPrpZATAkeTMTJaW5S49ED6U4FtZCUnSayD4WtMnaKQp19cBZCTqnY3WFW0RmTEZBUBXUuoURQ4hZBJBsZBhNheNyAqFzyahgaOQKXxSUZCpokl6lYiCEzUO3bfSHZAoWBU9SDHVJ2Xc53NFYr1T36jmMFDYQdLPrbhgYrVsX4kWti16dpHuIwb9HTQZDZD",
//     },
//     // 2 : {
//     //     WBNumberId :"382613481609522",
//     //     WBNumber :"9452094430",
//     //     APIVersion :"v22.0",
//     //     AccessToken : "EAAHWQFXlkfABOzGBLOeVg1pzwFbPFrT2Ty1C7knA2ZB0BlFJ9hmNOs94dhJfRZC38irIFtDj80nOLptwZA608if2cRbGW0TNnKZCr3nV7cnyTte1dDsFweEKnvgTPvbm5deqwyucVO8OVbs0dftDTo0lckuvimbnByDKWUV8eVvymEJOKF9II76g2o0M2jsYNwZDZD",
//     // },
//     1 : {
//         WBNumberId :"382613481609522",
//         WBNumber :"9452094430",
//         APIVersion :"v22.0",
//         AccessToken : "EAAHWQFXlkfABOzGBLOeVg1pzwFbPFrT2Ty1C7knA2ZB0BlFJ9hmNOs94dhJfRZC38irIFtDj80nOLptwZA608if2cRbGW0TNnKZCr3nV7cnyTte1dDsFweEKnvgTPvbm5deqwyucVO8OVbs0dftDTo0lckuvimbnByDKWUV8eVvymEJOKF9II76g2o0M2jsYNwZDZD",
//     },

// }


// const whatsAppStandCreds = {
//  24 : {
//         WBNumberId :"382613481609522",
//         WBNumber :"9452094430",
//         APIVersion :"v22.0",
//         AccessToken : "EAAHWQFXlkfABOzGBLOeVg1pzwFbPFrT2Ty1C7knA2ZB0BlFJ9hmNOs94dhJfRZC38irIFtDj80nOLptwZA608if2cRbGW0TNnKZCr3nV7cnyTte1dDsFweEKnvgTPvbm5deqwyucVO8OVbs0dftDTo0lckuvimbnByDKWUV8eVvymEJOKF9II76g2o0M2jsYNwZDZD",
//     },
 

// }



// function getBusinessWhatsAppCredsByStandID(standId = null){
//     var creds = whatsAppStandCreds[standId] ?? whatsAppStandCreds[24];   
//     // return [creds.WBNumberId,creds.AccessToken,creds.WBNumber,creds.APIVersion];
//      return [creds?.["WBNumberId"] ,creds?.["AccessToken"],creds?.["WBNumber"],creds?.["APIVersion"]];
// }

function getBusinessWhatsAppCredsByCompanyOrStandID(companyID,standId = null,messageType = ""){
     var creds = {};

    if(standId != null && whatsAppStandCreds[standId]){
          creds = whatsAppStandCreds[standId];   
    }else{
        creds = whatsAppCompCreds[companyID];
    }

  
        return [
            creds?.["WBNumberId"] || whatsAppDefaultCreds?.["WBNumberId"]
            ,creds?.["AccessToken"] || whatsAppDefaultCreds?.["AccessToken"]
            ,creds?.["WBNumber"] || whatsAppDefaultCreds?.["WBNumber"]
            ,creds?.["APIVersion"] || whatsAppDefaultCreds?.["APIVersion"]
            ,creds?.["templateByMessageType"]?.[messageType] || whatsAppDefaultCreds?.["templateByMessageType"]?.[messageType]
        ];
}


function getWhatsAppAutomationCredsByCompanyOrStandID(companyID,standId = null,messageType = ""){
     var creds = {};

    if(standId != null && whatsAppStandCreds[standId]){
          creds = whatsAppStandCreds[standId];   
    }else{
        creds = whatsAppCompCreds[companyID];
    }

  
        return [
            creds?.["WBNumberId"] || whatsAppDefaultCreds?.["WBNumberId"]
            ,creds?.["AccessToken"] || whatsAppDefaultCreds?.["AccessToken"]
            ,creds?.["WBNumber"] || whatsAppDefaultCreds?.["WBNumber"]
            ,creds?.["APIVersion"] || whatsAppDefaultCreds?.["APIVersion"]
            ,creds?.["WebhookVerifyToken"] || whatsAppDefaultCreds?.["WebhookVerifyToken"]
        ];
}



exports.getBusinessWhatsAppCredsByCompanyOrStandID = getBusinessWhatsAppCredsByCompanyOrStandID;
exports.getWhatsAppAutomationCredsByCompanyOrStandID = getWhatsAppAutomationCredsByCompanyOrStandID;