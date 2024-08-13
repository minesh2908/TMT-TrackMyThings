const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({credential:admin.credential.cert(serviceAccount),});
const firestore = admin.firestore();

exports.handler = async (event, context)=>{
  try {
    console.log('I am in Try block');
    console.log(`firestore: ${firestore}`);
    const snapshot = await firestore.collection('productCollection').get();
    console.log(`snapshot data: ${snapshot}`);
    return {
        statusCode: 200,
        body: JSON.stringify({ message: 'Notification scheduled successfully' })
    };
  } catch (error) {
    console.log(`Here is error :  $error`);
    
    return {
        statusCode: 502,
        body: JSON.stringify({ message: 'Notification scheduled failed', error:error})
    };
  }
}