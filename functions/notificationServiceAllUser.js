const { retrieveProductData, getUserToken } = require('./retrieveData');
// const { getUserToken } = require('./retrieveUserToken');
const { sendNotification, sendBroadcastNotification } = require('./sendNotification');

exports.handler = async (event, context) => {
    try {
        await sendBroadcastNotification('Testing Notification', 'This is a testing notificaion')
    } catch (error) {
        console.error('Error sending notification:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Failed to fetch user data' }),
        };
    }
};