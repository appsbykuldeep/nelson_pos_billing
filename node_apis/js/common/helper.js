var fs = require('fs');
var fsasync = require('fs').promises;
const QRCode = require('qrcode');
const path = require('path');

const crypto = require('crypto');



const root_path = process.cwd();


const qrfilePath = (qrvalue) => `/qr/${qrvalue}.png`;
const qrPath = (qrvalue) => `.${qrfilePath(qrvalue)}`;

const generateQRCode = (qrvalue) => {
    var path = qrPath(qrvalue);

    QRCode.toFile(path, qrvalue);
    removeQR(qrvalue);

    return qrfilePath(qrvalue);

};


const removeQR = async (qrvalue) => {
    await sleep(500000);
    fs.rmSync(qrPath(qrvalue));
};

const safeCount = (data) => {
    if (data == null) return 0;
    try {
        return data.length;
    } catch (e) {
        return 0;
    }

}


const isTrue = (data) => {
    if (data == null) return false;
    try {
        return [1,true,"true"].includes(data);
    } catch (e) {
        return false;
    }

}


const sleep =  (ms)=> {
    return new Promise((resolve) => {
        setTimeout(resolve, ms);
    });
}



const saveFile = (name, folder, buffer) => {
    var result = {
        status: false,
        path: "",

    };
    var path = folder + name;
    // var fileName = __dirname + '/tmp/uploads/' + name;    
    fs.open((__dirname + path), 'a', 0o755, function (err, fd) {
        if (err) throw err;
        fs.write(fd, buffer, null, 'Binary', function (err, written, buff) {
            if (!err) {
                result.status = true;
                result.path = path;
            }
        })
    });


    return result;
}

async function saveFileAndGetPath(name, folder, buffer) {
         try {
            const filePath = path.join(root_path, folder, name);
             await fsasync.writeFile(filePath, buffer);
              return path.join(folder, name);
         } catch (error) {
            console.log(error);
            return null;
         }
    
}



async function saveTextFile (name, folder, text) {

     createDir(folder);
  
    var path = folder + name;
  

fs.writeFile((__dirname + path), text, (err) => {
    if (err) throw err;
    console.log("File saved!");
});

    // fs.open((__dirname + path), 'a', 0o755, function (err, fd) {
    //     if (err) throw err;
    //     fs.write(fd, text)
    // });



}





const ConcatArray = (data) => {
    try {
        if (safeCount(data) > 0) {
            var result = [];
            for (const obj of data) {
                if (Array.isArray(obj)) {
                    result = result.concat(obj)
                }

            }
            return result;

        } else {
            return data;
        }

    } catch (e) {
        return data;

    }
}




function createDir(dir){
    
    const dirPath = path.join(__dirname,dir);
    if (!fs.existsSync(dirPath)) {
        fs.mkdirSync(dirPath, { recursive: true });
    }
    
}

function createDirFromRoot(dir){
    
    const dirPath = path.join(root_path,dir);
    if (!fs.existsSync(dirPath)) {
        fs.mkdirSync(dirPath, { recursive: true });
    }
    
}


function containsDateTime(value) {
    if (value instanceof Date) {
        return !isNaN(value.getTime());
    }
    if (typeof value === 'string') {
        return !isNaN(Date.parse(value));
    }
    return false;
}


function generateRandom6DigitPin() {
  const pin = Math.floor(100000 + Math.random() * 900000); 
  return pin.toString(); 
}



function generateUUID() {
  return crypto.randomBytes(16).toString('hex');
}




exports.generateQRCode = generateQRCode;
exports.saveFile = saveFile;
exports.safeCount = safeCount;
exports.ConcatArray = ConcatArray;
exports.sleep = sleep;
exports.isTrue = isTrue;

exports.createDir = createDir;
exports.saveTextFile = saveTextFile;
exports.saveFileAndGetPath = saveFileAndGetPath;
exports.createDirFromRoot = createDirFromRoot;
exports.containsDateTime = containsDateTime;
exports.generateRandom6DigitPin = generateRandom6DigitPin;
exports.generateUUID = generateUUID;
exports.root_path = root_path;
// module.exports = { root_path };