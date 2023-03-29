const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);


exports.sendNotificationToTopic = 
functions.firestore.document('todos/{todoId}').onUpdate(async (event) => {
    let id = event.after.id
    let title = event.after.get("shortDescription")
    var message = {
        notification: {
            title: "Favorite todo modified",
            body: `The details of one your favorite todos, ${title}, has been modified`,
        },
        topic: id,
    };

    let response = await admin.messaging().send(message);
    console.log(response);
});