const axios = require('axios');
const { backupServer } = require("./config");
const fs = require("fs");
const { print } = require('./print_data');
const path = require("path");
const https = require("https");


const EMPTY_PNG = Buffer.from([
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
    0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
    0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
    0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
    0x54, 0x78, 0x9C, 0x63, 0xF8, 0xCF, 0x00, 0x00,
    0x02, 0x05, 0x01, 0x02, 0xA2, 0x5D, 0xB7, 0x6F,
    0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44,
    0xAE, 0x42, 0x60, 0x82
]);

const agent = new https.Agent({
    rejectUnauthorized: false
});



async function retoutePostRequest(path, headers = null, data = null,) {

    const response = await axios.post(`${backupServer}/${path}`, data, {
        headers: headers,
        timeout: 20000
    });

}


async function retouteGetRequest(path, headers = null) {

    const response = await axios.get(`${backupServer}/${path}`, {
        headers: headers,
        // timeout: 20000 
    });

}



async function getFileFromBackupServer(localFilePath, remotePath) {
    try {
        const remoteUrl = `${backupServer}/${remotePath}`;
        const response = await axios({
            method: "GET",
            url: remoteUrl,
            responseType: "stream"
        });

        await saveStreamToFile(response.data, localFilePath);
        // return true;

    } catch (error) {
        await fs.promises.writeFile(localFilePath, Buffer.from([]));
        // return false;
    }

}


async function saveStreamToFile(stream, filePath) {
    return new Promise((resolve, reject) => {
        const writer = fs.createWriteStream(filePath);

        stream.pipe(writer);

        writer.on("finish", resolve);
        writer.on("error", reject);
    });
}


async function reRouteHandler(req) {


    let byGetMethod = req["bygetmthod"] || false;
    let body = req.body || {};
    let path = req.headers?.["reroutepath"];
    let reRouteFullPath = `${backupServer}/${path}`;
    let headerData = {};
    headerData["token"] = "shopqrapirequest";
    headerData["reroutepath"] = path;
    headerData["content-type"] = 'application/json';
    headerData["Accept"] = '*/*';



    try {

        var response = null;
        if (byGetMethod == true) {

            response = await axios.get(reRouteFullPath, {
                headers: headerData,
                httpsAgent: agent,
            });

        } else {

            response = await axios.post(reRouteFullPath, body, {
                headers: headerData,
                httpsAgent: agent,
            });


        }




        return response.data;


    } catch (error) {
        print(error);

    }


    return {}

}






exports.getFileFromBackupServer = getFileFromBackupServer;



exports.reRouteHandlerSocket = async (data, callback) => {


    callback(await reRouteHandler(data));

};





