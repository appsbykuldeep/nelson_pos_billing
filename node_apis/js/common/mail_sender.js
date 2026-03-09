const fs = require('fs');
const nodemailer = require('nodemailer');
const cheerio = require('cheerio');
const {mailCreds} = require("./config");



const db = require('./db_connection.js');
const jobs = require('./schedular_jobs.js');


const mailId = 'care@previewtech.in';
const senderName = 'Task Manager';



const transporter = nodemailer.createTransport(mailCreds["1"]);




const PreviousMailDetailsBYLeaveSummaryId = async (id) => {
  var outPut = {};
  if (id == null || id == 0) return null;
  var param = { "LeaveSummaryId": id };


  var result1 = await db.runQuery("dbo.GetFirstAppliedLeaveMailByLeaveSummaryId", param, true);
  if (result1 != null && result1.MailId != null) {

    outPut.MailId = result1.MailId;
    outPut.MailTo = result1.MailTo;
    outPut.MailSubject = result1.MailSubject;
    outPut.MailId = result1.MailId;
    var result2 = await db.runQuery("dbo.GetPreviousMailIdByLeaveSummaryId", param);
    if (result2 != null && result2.length > 0) {
      var MailIds = result2.map(function (value, index, arr) {
        return value.MailId;
      });
      outPut.MailIds = MailIds;
    }


    return outPut;
  }


  return null;

};


const LeaveMailReply = async (req) => {

  if(req.IsTest == 1){
    return;
  }
  var mailBody = req.MailBody;

  if (mailBody == null) return;
  var preMaildata = await PreviousMailDetailsBYLeaveSummaryId(req.LeaveSummaryId);
  if (preMaildata == null) return;
  

  var subject = `Re: ${preMaildata.MailSubject}`;
  // inReplyTo: messageId,
  var lastMailId = preMaildata.MailIds[preMaildata.MailIds.length - 1];

  var replyBody = {
    from: `"${req.ActionByName} (${senderName})" <${mailId}>`,
    to: preMaildata.MailTo,
    subject: subject,
    inReplyTo: lastMailId,
    references:lastMailId,
    html: mailBody,

  };


  var status = await finalSend(replyBody);
  if (status == null) return;
  status.subject = subject;
  status.LeaveSummaryId = req.LeaveSummaryId;
  status.ActionName = req.ActionName;
  status.ParentMailId = lastMailId;

  // console.dir(replyBody);
  // console.dir(status);

  await SaveAppliedLeaveMails(status);


};


const SendSalarySlip = async (req)=>{

  var body = {
    from: `"(${senderName})" <${mailId}>`,
    to: req.EmailId,
    subject: req.Subject,
    attachments: [{'filename': 'SalarySlip.pdf', 'content': req.pdfData}]
  };

  var status = await finalSend(body);
  if (status == null) return false;
  return (status.messageId !=null)
  // console.dir([status,"sendSalarySlip"]);


};



const finalSend = async (body) => {
  try {
    var status = await transporter.sendMail(body);
    status.messageId = status.messageId;
    // status.messageId = status.messageId.replace("<", "").replace(">", "");
    status.mailedTo = status.accepted.join();
    return status;
  } catch (err) {
    console.dir(err);
    return null;
  }

};




const veriFyMailer = async () => {
  try {
    var status = await transporter.verify();
  return status == true;
  //  SendTestMail();
  } catch (error) {
    console.dir(['veriFyMailer',error]);
    db.SaveServerErrors(error,'veriFyMailer','Mail');
    return false;
  }
};




const SendTestMail = async () => {

  try {

    console.dir("SendTestMail");
    var tempData = await getMailTemp();
    const $ = cheerio.load(tempData);

   var isVerified =  await veriFyMailer();

    if (isVerified==false) {
      return;
    }


    var remark = "This is kuldeep\nFrom PTPL\nLucknow.";
   
    
    $("#LeaveReamark").html(remark.split("\n").join("<br>"));
    // $("#LeaveReamark").innerHTML = remark;
    // $("#LeaveReamark").text(remark.replace("\n","<br>"));
    // $("#LeaveReamark").text(remark.replace("\n","<br>"));



    var mailto = [
      'kuldeepgupta983@gmail.com'
    ];
    
    var sub = "Testing mail";
    var testsenderName = "Kuldeep";


    tempData = $.html();
    

    var status = await transporter.sendMail({
      from: `"Kuldeep (${senderName})" <${mailId}>`,
      to: mailto,
      subject: sub,
      // html: "Leave Application Test at <b>12-June-2025&lt;br&gt; on <b>2nd half</b>", // html body
      html : tempData,
    });
    console.dir(["status",status]);
    var messageId = status.messageId.replace("<", "").replace(">", "");
    var replySetup = {
      from: `"${senderName}" <${mailId}>`,
      to: mailto,
      subject: 'Re: ' + sub,
      inReplyTo: messageId,
      references: [messageId],
      html: "This is reply", // html body
    };
  
  
    await sleep(2000);
  
    // var repstatus = await transporter.sendMail(replySetup);
  
    console.dir(["repstatus",repstatus]);
  
    return repstatus;
    
  } catch (error) {
    db.SaveServerErrors(error,'SendTestMail','Mail');
  }

 
};



function sleep(ms) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}


async function  getMailTemp()  {

  try {
    const data = await fs.promises.readFile('./db/assets/leave_temp.html', 'utf8');
    return data;
  } catch (err) {
    return "";
  }

 

}


const sendLeaveMail = async (empDetails) => {

  if(empDetails.IsTest == 1){
    return;
  }

  fs.readFile('./db/assets/leave_temp.html', 'utf8', (err, data) => {
    if (err) {
      console.error([err, "error"]);
      return;
    }
    sendLeaveMailSender(data, empDetails);

  });


};







exports.veriFyMailer = veriFyMailer;
exports.SendMail = SendTestMail;
exports.sendLeaveMail = sendLeaveMail;
exports.LeaveMailReply = LeaveMailReply;
exports.SendSalarySlip = SendSalarySlip;





