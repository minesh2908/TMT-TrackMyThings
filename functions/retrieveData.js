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
        }else if(daysLeft===0){
          query = db.collection("productCollection").where("warrantyEndsDate", "==", endDate);
        } 
        else {
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
  
      const userSnapshot = await db.collection("userCollection")
        .where("userId", "==", userId)
        .get();
  
      if (userSnapshot.empty) {
        console.log(`No user found with userId: ${userId}`);
        return null;
      }
  
      const firstDoc = userSnapshot.docs[0];
      const userData = firstDoc.data();
      console.log(`userData: ${JSON.stringify(userData)}`);
      return userData.pushToken; // return the first pushToken found
    } catch (error) {
      console.log(`Error: ${error}`);
      return null;
    }
  }

module.exports = { retrieveProductData, getUserToken  };