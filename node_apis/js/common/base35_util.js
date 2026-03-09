const CHARS = 'Q8C2N4KPXAZWGFTDJR6BE5MV31YLS97UOHI';
const BASE = CHARS.length;

/**
 * 
 * @param {*} num int
 * @returns string
 */

//Stand Id :24 => 3
function encodeBase35(num) {
  let str = '';
  while (num > 0) {
    str = CHARS[num % BASE] + str;
    num = Math.floor(num / BASE);
  }
  return str || '0';
}



/**
 * 
 * @param {*} code string
 * @returns int
 */

function decodeBase35(code) {
  let num = 0;
  for (const c of code) {
    num = num * BASE + CHARS.indexOf(c);
  }
  return num;
}



exports.encodeBase35 = encodeBase35;
exports.decodeBase35 = decodeBase35;
