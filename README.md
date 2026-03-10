# vparking_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


https://www.google.com/maps/search/?api=1&query=27.8125071,73.8327287
https://www.google.com/maps/search/?api=1&query=22.4257803,84.8032156



## Node API Path

- cd / [For go back ho root folder directly]
- cd /home/kuldeepgupta/node_projects/nelson_pos_billing/node_apis

- pm2 start index.js --name "nelson_pos_billing"

- pm2 restart nelson_pos_billing

- pm2 stop nelson_pos_billing

- pm2 logs nelson_pos_billing --lines 1000




- openssl s_client -connect node.parkingticket.in:443 -servername node.parkingticket.in
- expected return 'Verify return code: 0 (ok)'





scp root@82.112.238.169:/home/kuldeepgupta/node_projects/vparking_app/node_apis/mysql_backups/2025/06/u999084405_ParkingTicket_2025_06_10_03_00.sql.gz ~/Downloads/



## Xampp Server

- sudo /opt/lampp/lampp start
- sudo /opt/lampp/lampp stop 
- sudo /opt/lampp/lampp restart
- sudo /opt/lampp/lampp status
- sudo /opt/lampp/lampp startapache
- /opt/lampp/htdocs/myproject
- sudo /opt/lampp/bin/mysql -u root
- http://82.112.238.169:8888/phpmyadmin
- sudo ufw reload
- sudo ufw status




## js obfuscator
- npm install javascript-obfuscator -g
- javascript-obfuscator ./node_apis --output ./socket_apis_temp


## pm2 cmd
- npm install pm2 -g
- pm2 start index.js --name "vparking-uat"
- pm2 list
- pm2 stop     <app_name|namespace|id|'all'|json_conf>
- pm2 restart  <app_name|namespace|id|'all'|json_conf>
- pm2 delete   <app_name|namespace|id|'all'|json_conf>
- pm2 delete my-app-name
- pm2 logs my-app-name



## Ubunto allow access port
- sudo apt update
- sudo ufw allow 1400
- sudo ufw delete allow 1400
- sudo ufw reload
- sudo ufw status

## some common ubunto cmd
- mkdir /home/kuldeepgupta/uat_node_projects
- rm -r foldername


## .well-known path for ssl validation
- cd /var/www/html/.well-known/pki-validation/

- nano filename.txt then write data

- sudo nano /etc/nginx/nginx.conf



## where condition with case sensitive

- MySQL: WHERE BINARY col1 = 'Val' AND col2 = 123 
- SQLite : WHERE col1 = 'Val' COLLATE BINARY AND col2 = 123



## 📇 NFC Card Types Based on Memory

| NFC Card Type         | Memory Capacity         | Notes                                                |
|------------------------|--------------------------|--------------------------------------------------------|
| **NTAG213**            | 144 bytes (usable)       | Common for simple tags/stickers                      |
| **NTAG215**            | 504 bytes (usable)       | Used in Nintendo Amiibo cards                        |
| **NTAG216**            | 888 bytes (usable)       | Higher memory for richer data                        |
| **MIFARE Ultralight**  | 64 bytes                 | Very limited storage, low-cost                        |
| **MIFARE Classic 1K**  | 1 KB (752 bytes usable)  | Popular in access cards and transit systems          |
| **MIFARE Classic 4K**  | 4 KB                     | Extended memory version of Classic 1K                |
| **MIFARE DESFire EV1/EV2/EV3** | 2 KB / 4 KB / 8 KB | Advanced features and high-security applications     |
| **ICODE (ISO 15693)**  | Up to 8 KB or more       | Long-range, industrial and logistics applications     |
| **NFC Forum Type 1–5** | ~48 bytes to 64 KB+      | Standardized types with varying features and range   |



-- https://firebase.google.com/docs/cloud-messaging/flutter/receive#background_messages


SELECT * FROM mParkedVehicalLocalDB WHERE standId = 24 AND valetPIN <> '' ORDER BY parkedInOn DESC;


SELECT * FROM `ValetParkingRequestLog` WHERE StandId = 24 ORDER BY RequestLogID DESC;

UPDATE mParkedVehicalLocalDB as pv set  pv.valetCheckOutStatus = 4
, pv.valetCheckOutManagerCode = null
, pv.valetCheckOutDriverCode = null
WHERE pv.parkingUID = 'cvCOU8tajANU' and pv.standId = 24 LIMIT 1;



select * from parkedvehicalmaster where standId = 24 and valetPIN <> '' order by datetime(parkedInOn) desc


## To merge code from another repository into a branch:
git remote add flyweis-code https://github.com/Digital-Benchers/mobile-app-flyweis
git fetch flyweis-code
git checkout flyweis-code/dev 

## To merge it into your own branch, you should:
git checkout your-branch
git merge flyweis-code/dev




## create user in mysqldb

DROP USER IF EXISTS 'phpmyadmin'@'localhost';

CREATE USER 'phpmyadmin'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON *.* TO 'phpmyadmin'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;

sudo systemctl restart mysql
sudo systemctl restart apache2



https://auth-db1258.hstgr.io/index.php?db=u999084405_ParkingTicket


- Starter (low-traffic)

- Pro  (mid-traffic)

- Elite  (high-traffic)


## Mysql indexing

- SHOW INDEX FROM table_name;

### INDEX (BTREE) – Speeds up search, sort, WHERE, ORDER BY.
- CREATE INDEX idx_StandId ON tableName(columnName);

- CREATE INDEX idx_StandId ON ChargesRule(StandId);


### FULLTEXT INDEX – For text searching in large text columns.
- CREATE FULLTEXT INDEX idx_content ON articles(content);



### COMPOSITE INDEX – Index on multiple columns (order matters).
- CREATE INDEX idx_name_age ON users(name, age);


### Drop normal/unique/composite index
- DROP INDEX idx_name ON users;


## for find someting in large file

### Search with line numbers:
- grep -n "SELECT" backup.sql


### Search in all files in a folder:
- grep -r "search_text" /path/to/folder




## Import data to mysql via cmd

- apt install unzip

- correct data remove unsuppoted function
- add bello line in function  
READS SQL DATA
DETERMINISTIC

- scp u999084405_ParkingTicket.sql.zip root@82.112.238.169:/root/

- unzip -p /root/u999084405_ParkingTicket.sql.zip | mysql -u root -p vparkingAppdb 

- enter root@localhost password.

- sudo rm /root/u999084405_ParkingTicket.sql.zip




