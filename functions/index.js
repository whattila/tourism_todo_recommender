const functions = require('firebase-functions');
const admin = require('firebase-admin');
const _ = require('lodash');
const app = admin.initializeApp(functions.config().firebase);
const firestore = app.firestore();

exports.notifyFollowersOnTodoUpdate = 
functions.firestore.document('todos/{todoId}').onUpdate(async (event) => {
    let beforeDocument = event.before.data()
    let afterDocument = event.after.data()
    delete beforeDocument.rateStatistics
    delete afterDocument.rateStatistics
    if (!_.isEqual(beforeDocument, afterDocument)) {
        let id = event.after.id
        let title = event.after.get("shortDescription")
        let body
        let beforePhotos = event.before.get("imageReferences")
        let afterPhotos = event.after.get("imageReferences")
        if (_.isArray(afterPhotos) && _.difference(afterPhotos, beforePhotos).length != 0) {
            body = "New photos added to this favorite todo"
        }
        else {
            body = "The details of this favorite todo have been modified"
        }
        await sendMessage(title, body, id);
    }
});

exports.updateRateStatisticsAtCreate = 
functions.firestore.document('todos/{todoId}/ratings/{ratingId}').onCreate(async (newRating) => {
    try {
        await firestore.runTransaction(async (transaction) => {
            let todo = await transaction.get(newRating.ref.parent.parent)
            let rateStatistics = todo.get("rateStatistics")
            if (typeof rateStatistics === 'undefined') {
                // ha ez az első értékelés
                rateStatistics = {
                    counter: 0,
                    average: 0.0,
                    counterFiveStars: 0,
                    counterFourStars: 0,
                    counterThreeStars: 0,
                    counterTwoStars: 0,
                    counterOneStars: 0
                }
            }
            rateStatistics.counter++
            let value = newRating.get("value")
            incrementCounterXStars(value, rateStatistics)
            ratingsAverage(rateStatistics)
            transaction.update(newRating.ref.parent.parent, {rateStatistics: rateStatistics})
        })
        console.log('Transaction success!');
        let todo = await newRating.ref.parent.parent.get()
        let title = todo.get("shortDescription")
        let uploaderId = todo.get("uploaderId")
        await sendMessage(title, "The rating of your todo has changed", uploaderId);
    } catch (e) {
      console.log('Transaction failure:', e);
    }
});

exports.updateRateStatisticsAtUpdate =
functions.firestore.document('todos/{todoId}/ratings/{ratingId}').onUpdate(async (event) => {
    try {
        await firestore.runTransaction(async (transaction) => {
            let todo = await transaction.get(event.after.ref.parent.parent)
            let rateStatistics = todo.get("rateStatistics")
            // mivel egy értékelés megváltozott, biztos hogy volt korábban értékelés, így nem kell undefined vizsgálatot végezni

            let oldValue = event.before.get("value")
            decrementCounterXStars(oldValue, rateStatistics);
            let newValue = event.after.get("value")
            incrementCounterXStars(newValue, rateStatistics);
            ratingsAverage(rateStatistics);
            transaction.update(event.after.ref.parent.parent, {rateStatistics: rateStatistics}) // itt szerintem használhatnám az aftert is, vagy van különbség?
        })
        console.log('Transaction success!');
        let todo = await event.after.ref.parent.parent.get()
        let title = todo.get("shortDescription")
        let uploaderId = todo.get("uploaderId")
        await sendMessage(title, "The rating of your todo has changed", uploaderId);
    } catch (e) {
      console.log('Transaction failure:', e);
    }
});

exports.updateRateStatisticsAtDelete =
functions.firestore.document('todos/{todoId}/ratings/{ratingId}').onDelete(async (deletedRating) => {
    try {
        await firestore.runTransaction(async (transaction) => {
            let todo = await transaction.get(deletedRating.ref.parent.parent)
            let rateStatistics = todo.get("rateStatistics")
            rateStatistics.counter--
            let deletedValue = deletedRating.get("value")
            decrementCounterXStars(deletedValue, rateStatistics)
            ratingsAverage(rateStatistics);
            transaction.update(deletedRating.ref.parent.parent, {rateStatistics: rateStatistics})
        })
        console.log('Transaction success!');
        let todo = await deletedRating.ref.parent.parent.get()
        let title = todo.get("shortDescription")
        let uploaderId = todo.get("uploaderId")
        await sendMessage(title, "The rating of your todo has changed", uploaderId);
    } catch (e) {
      console.log('Transaction failure:', e);
    }
})

exports.notifyUploaderOnCommentAdd =
functions.firestore.document('todos/{todoId}/comments/{commentId}').onCreate(async (newComment) => {
    let todoRef = newComment.ref.parent.parent
	let todo = await todoRef.get()
    let title = todo.get("shortDescription")
    let uploaderId = todo.get("uploaderId")
    await sendMessage(title, "Someone commented on your todo", uploaderId)
})

async function sendMessage(title, body, topic) {
    let message = {
        notification: {
            title: title,
            body: body,
        },
        topic: topic,
    };
    let response = await admin.messaging().send(message);
    console.log(response);
}

function ratingsAverage(rateStatistics) {
    rateStatistics.average =
        (1 * rateStatistics.counterOneStars
            + 2 * rateStatistics.counterTwoStars
            + 3 * rateStatistics.counterThreeStars
            + 4 * rateStatistics.counterFourStars
            + 5 * rateStatistics.counterFiveStars)
        / rateStatistics.counter;
}

function incrementCounterXStars(newValue, rateStatistics) {
    switch (newValue) {
        case 1:
            rateStatistics.counterOneStars++;
            break;
        case 2:
            rateStatistics.counterTwoStars++;
            break;
        case 3:
            rateStatistics.counterThreeStars++;
            break;
        case 4:
            rateStatistics.counterFourStars++;
            break;
        case 5:
            rateStatistics.counterFiveStars++;
            break;
    }
}

function decrementCounterXStars(oldValue, rateStatistics) {
    switch (oldValue) {
        case 1:
            rateStatistics.counterOneStars--;
            break;
        case 2:
            rateStatistics.counterTwoStars--;
            break;
        case 3:
            rateStatistics.counterThreeStars--;
            break;
        case 4:
            rateStatistics.counterFourStars--;
            break;
        case 5:
            rateStatistics.counterFiveStars--;
            break;
    }
}
