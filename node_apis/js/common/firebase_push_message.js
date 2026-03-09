
// import { admin } from './firebase_config';
const { admin } = require('./firebase_config');
const {print} = require('./print_data');




/**
 * Uesed to send push notification to muliple device token
 * @param {*} deviceTokens array[str]
 * @param {*} title str
 * @param {*} body str
 * @param {*} payload dynamic
 * @returns void
 */
 
const sendNotificationToMultipleTokens = async (deviceTokens , title, body, payload = {}) => {
    var successCount = 0;
    var tokenCount = 0;
    if(payload == null){
        payload = {};
    }
       
    if (deviceTokens == null || title == null || body == null || deviceTokens.length == 0) return false;
    tokenCount = deviceTokens.length;
    try {
        var messaging = admin.messaging();

        if(payload != null && payload.title == null){
            payload.title =  title;
            payload.body = body;
        }

        const message = {
            tokens: deviceTokens,
            // notification key must be null else app shows same notification 2 time
            // notification: {
            //     title: title,
            //     body: body,
            // },
            data: payload,
        };

        print("fb_message",message);

        const resp = await messaging.sendEachForMulticast(message);
        print(resp);
        successCount = resp["successCount"] || 0;      
        
    }
    catch (e) {
        print(e);
    }

    return tokenCount > 0 && successCount == tokenCount;

}


const sendPushNotification = async (deviceToken,  title, body,  payload = {}) => {
  return  await sendNotificationToMultipleTokens([deviceToken],title,body,payload);
}




const sendNotificationToTopic = async (topic, title, body, payload = {}) => {
    if (topic == null || title == null || body == null) return;
    try {
        var messaging = admin.messaging();

        if(payload != null && payload.title == null){
            payload.title =  title;
            payload.body = body;
        }

        const message = {
            topic: topic,
            // notification: {
            //     title: title,
            //     body: body,
            // },
            data: payload,
        };
        
        messaging.send(message).then(function (res){
            console.dir(res);
        });

        
    }
    catch (e) {
        console.dir(e);
    }

}






exports.sendPushNotification = sendPushNotification;
exports.sendNotificationToMultipleTokens = sendNotificationToMultipleTokens;
exports.sendNotificationToTopic = sendNotificationToTopic;


exports.sendPushNotificationAPI = async (req, res) => {
    let deviceToken = req.body["deviceToken"];
    let title = req.body["title"];
    let body = req.body["body"];
    let payload = req.body["payload"];

    res.send(await sendPushNotification(deviceToken,title,body,payload));
  
  };





