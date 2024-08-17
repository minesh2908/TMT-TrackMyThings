const admin = require("firebase-admin");

let app;

if (!admin.apps.length) {
  const serviceAccount = JSON.parse(process.env.SERVICE_ACCOUNT_KEY);
  app = admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
} else {
  app = admin.app();
}

const db = app.firestore();
const messaging = app.messaging(); 

module.exports = {db, messaging};