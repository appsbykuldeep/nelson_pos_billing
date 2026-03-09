const fs = require('fs');
const path = require('path');
const moment = require('moment');
const {serverInfo} = require('./env_setup')


const { exec,spawn } = require('child_process');
require('dotenv').config();

// Config
const dbHost = process.env.MySQL_host; // or IP like '192.168.1.100'
const dbName = process.env.MySQL_database;
const user = process.env.MySQL_user;
const password = process.env.MySQL_password;





function takeMYSQLBackUpIngzip() {

try {
  

   const now = moment();  
  const formattedDate = now.format('YYYY_MM_DD_HH_mm');


  const backupDir = path.join(__dirname, '..', '..', 'mysql_backups',now.format('YYYY'),now.format('MM'));
 
  const fileName = `${dbName}_${formattedDate}.sql.zip`;
  // const fileName = `${dbName}_${formattedDate}.sql.gz`;
  const filePath = path.join(backupDir, fileName);

  // Create backup folder if not exists
  if (!fs.existsSync(backupDir)) {
    fs.mkdirSync(backupDir, { recursive: true });
  }

    var dumpCommand = null;

  // if(serverInfo.isLocal){
  //     dumpCommand = `/opt/homebrew/opt/mysql-client/bin/mysqldump --single-transaction -h ${dbHost} -u ${user} -p'${password}' ${dbName} > "${filePath}"`;
  // }else{
  //     dumpCommand = `mysqldump --single-transaction -h ${dbHost} -u ${user} -p'${password}' ${dbName} > "${filePath}"`;
  // }


  if(serverInfo.isLocal){
      dumpCommand = `/opt/homebrew/opt/mysql-client/bin/mysqldump`;
  }else{
      dumpCommand = `mysqldump`;
  }

  const env = { ...process.env, MYSQL_PWD: password };

  console.log("called takeMYSQLBackUpIngzip")

  const dump = spawn(dumpCommand, [
    // '--single-transaction',
    // '--skip-comments',
    '-h', dbHost,
    '-u', user,
    '--routines',
    '--triggers',
    '--events',
  // `-p'${password}'`,
  dbName
],{env});




const gzip = spawn('gzip');

let timeoutInMin = 15;

const timeout = setTimeout(() => {
  console.warn('⏰ Process timed out, killing spawn...');
  dump.kill(); 
  gzip.kill(); 
}, timeoutInMin * 60 * 1000);

dump.stdout.pipe(gzip.stdin);
const writeStream = fs.createWriteStream(filePath);
gzip.stdout.pipe(writeStream);


// Handle errors
// dump.stderr.on('data', (data) => {
//   console.error('mysqldump error:', data.toString());
// });

// gzip.stderr.on('data', (data) => {
//   console.error('gzip error:', data.toString());
// });



// Optional: handle gzip/dump exit codes
dump.on('close', (code) => {
  clearTimeout(timeout);  
  console.error(`mysqldump exited with code ${code}`);
});


// // Call function when file write is done
// writeStream.on('close', () => {
//   console.log('✅ Backup and compression complete!');
// });


} catch (error) {
  return;
}
 
 




}

function takeMYSQLBackUpInSQL() {


   const now = moment();  
  const formattedDate = now.format('YYYYMMDDHHmmss');


  const backupDir = path.join(__dirname, '..', '..', 'mysql_backups',now.format('YYYY'),now.format('MM'));
 
  const fileName = `${dbName}_${formattedDate}.sql`;
  const filePath = path.join(backupDir, fileName);

  // Create backup folder if not exists
  if (!fs.existsSync(backupDir)) {
    fs.mkdirSync(backupDir, { recursive: true });
  }

    var dumpCommand = null;

  if(serverInfo.isLocal){
      dumpCommand = `/opt/homebrew/opt/mysql-client/bin/mysqldump --single-transaction -h ${dbHost} -u ${user} -p'${password}' ${dbName} > "${filePath}"`;
  }else{
      dumpCommand = `mysqldump --single-transaction -h ${dbHost} -u ${user} -p'${password}' ${dbName} > "${filePath}"`;
  }
 
 


  exec(dumpCommand, (error, stdout, stderr) => {
    if (error) {
      console.error('Backup failed:', error.message);
      return;
    }
    console.log('Backup successful:', filePath);
  });

}


exports.takeMYSQLBackUpIngzip = takeMYSQLBackUpIngzip;