const axios = require('axios');
const db = require('./db_connection')

async function sendWhatsAppMessage(data, WBNumberId, accessToken,apiVersion) {
    // const apiVersion = "v22.0";
    // const WBNumberId = InWBNumberId || "382613481609522";
    // const accessToken = InAccessToken || "EAAHWQFXlkfABOzGBLOeVg1pzwFbPFrT2Ty1C7knA2ZB0BlFJ9hmNOs94dhJfRZC38irIFtDj80nOLptwZA608if2cRbGW0TNnKZCr3nV7cnyTte1dDsFweEKnvgTPvbm5deqwyucVO8OVbs0dftDTo0lckuvimbnByDKWUV8eVvymEJOKF9II76g2o0M2jsYNwZDZD";

    const apiUrl = `https://graph.facebook.com/${apiVersion}/${WBNumberId}/messages`;

    let status = 0;
    let httpCode = -1;
    let messages_id = null;
    let errorMessage = null;
    let curl_error = null;


    if(WBNumberId == null || accessToken == null || apiVersion == null || data == null){
        print(WBNumberId,accessToken,apiVersion,data);
        return {
        "status" : status,
        "httpCode" : httpCode,
        "messages_id" : messages_id,
        "curl_error" : curl_error,
        "errorMessage" : errorMessage,
        "WBNumberId" : WBNumberId,
    };
    }

    try {
        const response = await axios.post(apiUrl, data, {
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${accessToken}`
            },
            timeout: 10000 // Optional: 10 seconds timeout
        });

        httpCode = response.status;

        const responseData = response.data;
               

        if (responseData.error && responseData.error.message) {
            errorMessage = responseData.error.message;
        }

        if (responseData.messages && responseData.messages[0] && responseData.messages[0].id) {
            status = 1;
            messages_id = responseData.messages[0].id;
        }

    } catch (error) {
        
        // console.dir(["error",db.jsonTryEncode(error?.response?.data)]);
        if (error.response) {
            httpCode = error.response.status;
            errorMessage = error.response.data?.error?.message || error.message;
        } else {
            curl_error = error.message;
            errorMessage = "Request failed: " + error.message;
        }
    }

    return {
        "status" : status,
        "httpCode" : httpCode,
        "messages_id" : messages_id,
        "curl_error" : curl_error,
        "errorMessage" : errorMessage,
        "WBNumberId" : WBNumberId,
    };
}




exports.sendWhatsAppMessage = sendWhatsAppMessage;