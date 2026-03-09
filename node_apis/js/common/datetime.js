const moment = require('moment');

function getCurrentTimeStamp(mili = false){
    if(mili == true){
         return moment().format('YYYY-MM-DD HH:mm:ss.SSS');
    }
    return moment().format('YYYY-MM-DD HH:mm:ss');
}



function getCurrentFormattedDate(patern = 'YYYYMMDD'){
   
    return moment().format(patern);
}


function getCurrentDate(){
   
    return moment().format('YYYY-MM-DD');
}



function minuteDiff(d1,d2){      
      const diffMs = d2 - d1;
    return Math.floor(diffMs / (1000 * 60 ));

}
function secondDiff(d1,d2){      
      const diffMs = d2 - d1;
    return Math.floor(diffMs / (1000  ));

}






exports.getCurrentTimeStamp = getCurrentTimeStamp;
exports.getCurrentFormattedDate = getCurrentFormattedDate;
exports.minuteDiff = minuteDiff;
exports.secondDiff = secondDiff;
exports.getCurrentDate = getCurrentDate;