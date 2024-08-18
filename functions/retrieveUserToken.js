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

        let pushToken = "e4Iy6ZNtR1-Txbv5iOcg46:APA91bF9waq7uqAhj9iJe1Tfmth-HH8sx7ZkN_1nlIgSfFbAtc-9fXfdXkPfpszpjaYurQoFbFb07OsT5_IYg6W-4yI4ERrAGVOFoFy4gV2domqMrDvZTsckVT9Enq12tyW9pn_QTwDD";
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
