const admin = require("firebase-admin");

let app;

// Check if the Firebase app has already been initialized
if (!admin.apps.length) {
  const serviceAccount = JSON.parse(process.env.SERVICE_ACCOUNT_KEY);
  
  // Initialize the app with the service account credentials
  app = admin.initializeApp({ 
    credential: admin.credential.cert(serviceAccount) 
  });
} else {
  app = admin.app();
}

// Initialize Firestore and Cloud Messaging using the app instance
const db = app.firestore();
const messaging = app.messaging();

// Export the Firestore and Cloud Messaging instances for use in other files
module.exports = { db, messaging };
