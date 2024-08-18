const { db } = require('./firebase.js');

/**
 * Fetch products based on expiration period.
 * @param {number} daysLeft - Number of days left before expiration.
 * @returns {Promise<Array>} - List of products about to expire within the given period.
 */
async function retrieveProductData(daysLeft) {
    try {
        // Calculate the start and end dates for the period based on daysLeft
        const today = new Date();
        today.setHours(0,0,0,0);
        const targetDate = new Date(today);
        targetDate.setDate(today.getDate() + daysLeft);
        targetDate.setHours(0,0,0,0);
        // Format dates as Firestore expects them
        const startDate = today.toISOString().slice(0,-1); // YYYY-MM-DD
        console.log(`start Date- ${startDate}`);
        const endDate = targetDate.toISOString().slice(0,-1); // YYYY-MM-DD
        console.log(`end Date- ${endDate}`);
        let productSnapshot;
       
        // Query Firestore to get products where warrantyEndsDate is within the specified period
        if (daysLeft === 30 || daysLeft === 7) {
            productSnapshot = await db.collection("productCollection")
                .where("warrantyEndsDate", "==", endDate)
                .get();

               
        } else if (daysLeft === 3) {
            productSnapshot = await db.collection("productCollection")
                .where("warrantyEndsDate", ">=", startDate)
                .where("warrantyEndsDate", "<=", endDate)
                .get();
        } else {
            console.log(`No products to retrieve for ${daysLeft} days.`);
            return [];
        }

        if (productSnapshot.empty) {
            console.log(`No products about to expire in ${daysLeft} days.`);
            return [];
        }

        const products = [];
        productSnapshot.forEach(doc => {
            products.push({ id: doc.id, ...doc.data() });
        });

        return products;
    } catch (error) {
        console.log(`Error: ${error}`);
        return [];
    }
}

async function getUserToken(userId) {
    try {
        const userDoc = await db.collection("userCollection").doc(userId).get();

        if (!userDoc.exists) {
            console.log(`No user found with userId: ${userId}`);
            return null; // Return null if no user is found
        }

        const userData = userDoc.data();
        const pushToken = userData.pushToken;
          // Return the pushToken and productImage
        return {pushToken};
    } catch (error) {
        console.log(`Error: ${error}`);
        return null;
    }
}

module.exports = { retrieveProductData, getUserToken };
