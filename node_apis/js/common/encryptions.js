const crypto = require('crypto');


const key_V1 = Buffer.from('YoxqPmBoTNwEgJpPrFEcdqWMTttZOGdx', 'utf8');
const iv_V1 = Buffer.from('pyipIOBTtgRkRWai', 'utf8');


// 📦 Encrypt function
function encryptV1(text) {
  const cipher = crypto.createCipheriv('aes-256-cbc', key_V1, iv_V1);
  let encrypted = cipher.update(text, 'utf8', 'base64');
  encrypted += cipher.final('base64');
  return encrypted;
}

// 🔓 Decrypt function
function decryptV1(encryptedText) {
  const decipher = crypto.createDecipheriv('aes-256-cbc', key_V1, iv_V1);
  let decrypted = decipher.update(encryptedText, 'base64', 'utf8');
  decrypted += decipher.final('utf8');
  return decrypted;
}



// 🔓 Decrypt function
function decryptV1OrNull(encryptedText) {
  try {
    return decryptV1(encryptedText);
  } catch (error) {
    return null;
  }
}







exports.encryptV1 = encryptV1;
exports.decryptV1 = decryptV1;
exports.decryptV1OrNull = decryptV1OrNull;