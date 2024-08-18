const { db } = require('./firebase.js');

async function getUserToken(userId) {
    try {
        console.log(`1 ${userId}`);
         console.log("done");
         let userDoc;
         userDoc = await db.collection("userCollection")
                .where("userId", "==", userId)
                .get();
        if (userDoc.empty) {
            console.log(`No user found with userId: ${userId}`);
            return null; // Return null if no user is found
        }
         
        const users = [];
        userDoc.forEach(doc => {
            users.push({ id: doc.id, ...doc.data() });
        });
        
        console.log(users.length);

        console.log(`userDoc: ${userDoc}`)
        const userData = userDoc.data();
        console.log(`userData: ${userData}`);   
        
        const pushToken = userData.pushToken;
        console.log(`pushToken: ${pushToken}`);
          // Return the pushToken and productImage
        
        return pushToken;
    } catch (error) {
        console.log(`Error: ${error}`);
        return null;
    }
}

module.exports = { getUserToken };