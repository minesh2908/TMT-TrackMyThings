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

module.exports = { retrieveProductData };