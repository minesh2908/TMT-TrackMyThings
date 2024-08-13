const admin = require('firebase-admin'); 

exports.handler = async (event, context)=>{
    try {
      console.log('I am in Try');
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