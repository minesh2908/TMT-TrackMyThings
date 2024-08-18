const { db } = require('./firebase.js');

async function retrieveProductData(daysLeft) {
    try {
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        const targetDate = new Date(today);
        targetDate.setDate(today.getDate() + (daysLeft-1));
        targetDate.setHours(0, 0, 0, 0);

        const startDate = today.toISOString().slice(0, -1);
        const endDate = targetDate.toISOString().slice(0, -1);

        let query;
        if (daysLeft === 30 || daysLeft === 7) {
            query = db.collection("productCollection").where("warrantyEndsDate", "==", endDate);
        } else if (daysLeft === 3) {
            query = db.collection("productCollection")
                .where("warrantyEndsDate", ">=", startDate)
                .where("warrantyEndsDate", "<=", endDate);
        } else {
            return [];
        }

        const productSnapshot = await query.get();
        if (productSnapshot.empty) {
            return [];
        }
        return productSnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    } catch (error) {
        console.log(`Error: ${error}`);
        return [];
    }
}

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

module.exports = { retrieveProductData, getUserToken  };