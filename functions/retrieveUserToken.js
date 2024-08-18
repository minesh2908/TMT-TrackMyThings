const { db } = require('./firebase.js');

async function getUserToken(userId) {
    try {
        console.log(`1 ${userId}`);

        // Query Firestore to get the user document with the specified userId
        // const userSnapshot = await db.collection("userCollection")
        //     .where("userId", "==", userId)
        //     .get();
        //  console.log(userSnapshot);
        // if (userSnapshot.empty) {
        //     console.log(`No user found with userId: ${userId}`);
        //     return null; 
        // }

        let pushToken = "dUVBK3sKSjCvbEKjQ-vx6w:APA91bGqpD_lFlUifDPOi-FP_UCLVFemzdUpB77Ea9Yj1ydziZR-kQ6QAkt9NCbTYcCz0mA4VMdADD-Nt69x3kgJXpp6enNH1g8PsymnfZKD3_b32bkV2E65DKRjojprd43M_2kz-ffl";
        // userSnapshot.forEach(doc => {
        //     const userData = doc.data();
        //     console.log(`userData: ${JSON.stringify(userData)}`);
        //     pushToken = userData.pushToken; // Assuming 'pushToken' is the field name in Firestore
        //     console.log(`pushToken: ${pushToken}`);
        // });
        
        // Return the pushToken
        return pushToken;
    } catch (error) {
        console.log(`Error: ${error}`);
        return null;
    }
}

module.exports = { getUserToken };
