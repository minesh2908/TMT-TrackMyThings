const { db } = require('./firebase.js');

async function getUserToken(userId) {
    try {
        console.log(`1 ${userId}`);

        // Query Firestore to get the user document with the specified userId
        const userSnapshot = await db.collection("userCollection")
            .where("userId", "==", "oP7gUH8w9wZqQaDnKgwmU1xkHn33")
            .get();
         console.log(userSnapshot);
        if (userSnapshot.empty) {
            console.log(`No user found with userId: ${userId}`);
            return null; // Return null if no user is found
        }

        let pushToken;
        userSnapshot.forEach(doc => {
            const userData = doc.data();
            console.log(`userData: ${JSON.stringify(userData)}`);
            pushToken = userData.pushToken; // Assuming 'pushToken' is the field name in Firestore
            console.log(`pushToken: ${pushToken}`);
        });

        // Return the pushToken
        return pushToken;
    } catch (error) {
        console.log(`Error: ${error}`);
        return null;
    }
}

module.exports = { getUserToken };
