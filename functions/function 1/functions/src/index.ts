import * as firebase from 'firebase-admin';
import * as functions from 'firebase-functions';
import * as geofirestore from 'geofirestore';


// Initialize the Firebase SDK
firebase.initializeApp({
  // ...
});

// Create a Firestore reference
const firestore = firebase.firestore();

// Create a GeoFirestore reference
const GeoFirestore = geofirestore.initializeApp(firestore);

// Create a GeoCollection reference
const geocollection = GeoFirestore.collection('Users');



export const getHelpers = functions.https.onCall( async (data, context) => {

    try{
            // Create a GeoQuery based on a location
            const query = geocollection.near({ center: new firebase.firestore.GeoPoint(data['latitude'], data['longitude']), radius: 1000 });

            // Get query (as Promise)
            var docs = await query.get().then((value) => {
            // All GeoDocument returned by GeoQuery, like the GeoDocument added above
            return value.docs;
            });

            return docs;

    }catch(error){
        return error;       
    }
  });