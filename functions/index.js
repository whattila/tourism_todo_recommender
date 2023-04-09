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

exports.updateRateStatisticsAtCreate = 
functions.firestore.document('todos/{todoId}/ratings/{ratingId}').onCreate(async (newRating) => {
    let todoRef = newRating.ref.parent.parent
	let todo = await todoRef.get()
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
    await todoRef.update({rateStatistics: rateStatistics})
    // a pontosvesszők hiánya nem okoz gondot, főleg így hogy van olyan utasítás, ami több sorra van tördelve?
});

exports.updateRateStatisticsAtUpdate =
functions.firestore.document('todos/{todoId}/ratings/{ratingId}').onUpdate(async (event) => {
    let todoRef = event.after.ref.parent.parent
	let todo = await todoRef.get()
    let rateStatistics = todo.get("rateStatistics")
    // mivel egy értékelés megváltozott, biztos hogy volt korábban értékelés, így nem kell undefined vizsgálatot végezni

    let oldValue = event.before.get("value")
    decrementCounterXStars(oldValue, rateStatistics);
    let newValue = event.after.get("value")
    incrementCounterXStars(newValue, rateStatistics);
    ratingsAverage(rateStatistics);
    await todoRef.update({rateStatistics: rateStatistics})
});

exports.updateRateStatisticsAtDelete =
functions.firestore.document('todos/{todoId}/ratings/{ratingId}').onDelete(async (deletedRating) => {
    let todoRef = deletedRating.ref.parent.parent
	let todo = await todoRef.get()
    let rateStatistics = todo.get("rateStatistics")
    rateStatistics.counter--
    let deletedValue = deletedRating.get("value")
    decrementCounterXStars(deletedValue, rateStatistics)
    ratingsAverage(rateStatistics);
    await todoRef.update({rateStatistics: rateStatistics})
})

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
