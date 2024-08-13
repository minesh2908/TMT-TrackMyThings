const admin = require('firebase-admin'); 

exports.handler = async (event, context)=>{
    try {
     const serviceAccount = process.env.SERVICE_ACCOUNT_KEY;
      console.log('I am in Try');
      console.log(`service Account : ${serviceAccount}`);
      return {
         
          statusCode: 200,
          body: JSON.stringify({ message: 'Notification scheduled successfully' })
      };
    } catch (error) {
      console.log(`Here is error :  ${error}`);
      
      return {
          statusCode: 502,
          body: JSON.stringify({ message: 'Notification scheduled failed', error:error})
      };
    }
  }