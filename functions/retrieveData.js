const { db } = require('./firebase.js');

// const StatusEnum = Object.freeze({
//   DAY: 3,
//   WEEK: 7,
//   MONTH: 30
// });

/**
 * Fetch products based on expiration period.
 * @param {number} daysLeft - Number of days left before expiration.
 * @returns {Promise<Array>} - List of products about to expire within the given period.
 */
async function retrieveProductData(daysLeft: int) {
    try {

        // var daysLeft;
        // if(statusEnum == StatusEnum.MONTH) {
        //     daysLeft = 30;
        // } else if(statusEnum == StatusEnum.WEEK) {
        //     daysLeft = 7;
        // } else {
        //     daysLeft = 3;
        // }
        
        // Calculate the start and end dates for the period based on daysLeft
        const today = new Date();
        const targetDate = new Date(today);
        targetDate.setDate(today.getDate() + daysLeft);

        // Format dates as Firestore expects them
        const startDate = today.toISOString().split('T')[0]; // YYYY-MM-DD
        const endDate = targetDate.toISOString().split('T')[0]; // YYYY-MM-DD

        var productSnapshot;

        if(daysLeft == 30) {
             // Query Firestore to get products where warrantyEndsDate is within the specified period
             productSnapshot = await db.collection("productCollection")
            .where("warrantyEndsDate", "==", endDate)
            .get();
        } 
        
        if(daysLeft == 7) {
             // Query Firestore to get products where warrantyEndsDate is within the specified period
             productSnapshot = await db.collection("productCollection")
            .where("warrantyEndsDate", "==", endDate)
            .get();
        } 
        
        if(daysLeft == 3) {
            // Query Firestore to get products where warrantyEndsDate is within the specified period
             productSnapshot = await db.collection("productCollection")
            .where("warrantyEndsDate", ">=", startDate)
            .where("warrantyEndsDate", "<=", endDate)
            .get();
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

module.exports = { retrieveProductData };
