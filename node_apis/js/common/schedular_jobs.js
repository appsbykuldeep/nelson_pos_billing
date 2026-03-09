const schedule = require('node-schedule');



const CreateJob = () => {




    // schedule.scheduleJob(
    //     "Indian Stand daily collection notification",
    //     { hour: 10, minute: 0, second: 0 }
    //     , () => standNotifications.SendStandWiseDailyCollectionNotification()
    // );




    console.log("Called CreateJob");


};


// const scheduleNonSentLeaveMail = (leaveSummaryId = null)=>{

//     setTimeout(() => {
//         leave.GetLeaveSummaryDetailsForNonSendMail(leaveSummaryId);
//     }, leaveSummaryId == null ? 1000 :  10000,
//     );       
// }


function createZSquareJobs(){

        schedule.scheduleJob(
        "zSquare_autoExitPrakedVehicles",
        { hour: 2, minute: 0, second: 0 }
        , () => autoExitPrakedVehicles()
    );

        schedule.scheduleJob(
        "zSquare_autoClearTempData",
        { hour: 2, minute: 30, second: 0 }
        , () => autoClearTempData()
    );

      console.log("Called zSquare CreateJob");
}





exports.CreateJob = CreateJob;
exports.createZSquareJobs = createZSquareJobs;