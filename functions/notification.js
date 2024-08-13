const admin = require('firebase-admin'); 
const serviceAccount = process.env.SERVICE_ACCOUNT_KEY;

admin.initializeApp({credential:admin.credential.cert(serviceAccount),});
const firestore = admin.firestore();
exports.handler = async (event, context)=>{
    try {
      console.log(`firestore: ${firestore}`);
      return {
         
          statusCode: 200,
          body: JSON.stringify({ message: 'Notification scheduled successfully' })
      };
    } catch (error) {
      console.log(`Here is error :  ${error}`);
      
      return {
          statusCode: 502,
          body: JSON.stringify({ message: 'Notification scheduled failed', error:error})
      };
    }
  }