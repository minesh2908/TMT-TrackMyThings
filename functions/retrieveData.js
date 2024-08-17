const { db } = require('./firebase.js');

async function retrieveProductData() {
    try {
        // Calculate the start and end dates for the 3-day period
        const today = new Date();
        const threeDaysFromNow = new Date(today);
        threeDaysFromNow.setDate(today.getDate() + 4);
        
        // Format dates as Firestore expects them
        const startDate = today.toISOString().split('T')[0]; // YYYY-MM-DD
        const endDate = threeDaysFromNow.toISOString().split('T')[0]; // YYYY-MM-DD

        // Query Firestore to get products where warrantyEndsDate is within the next 3 days
        const productSnapshot = await db.collection("productCollection")
            .where("warrantyEndsDate", ">", startDate)
            .where("warrantyEndsDate", "<=", endDate)
            .get();
        
        if (productSnapshot.empty) {
            console.log("No products about to expire in 3 days.");
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
