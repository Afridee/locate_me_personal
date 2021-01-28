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
            const query = geocollection.near({ center: new firebase.firestore.GeoPoint(data['latitude'], data['longitude']), radius: 15 });

            // Get query (as Promise)
            const docs = await query.get().then((value) => {
            // All GeoDocument returned by GeoQuery, like the GeoDocument added above
            return value.docs;
            });

            return docs;

    }catch(error){
        return error;       
    }
  });

  
  export const sendRequestToHelpers = functions.https.onCall( (data, context) => { 
    
     try{
     
     const fcm = firebase.messaging();
    
     const token = data;
 
     const payload: firebase.messaging.MessagingPayload = {
       notification: {
         title: 'Someone needs your help',
         body: `Please open your locate me app to find out`,
         icon: 'https://firebasestorage.googleapis.com/v0/b/locate-me-177b1.appspot.com/o/locate_me_icon.png?alt=media&token=c95dd023-0bb2-4ce3-ac16-112c26fafd04',
         click_action: 'FLUTTER_NOTIFICATION_CLICK'
       }
     };

     return fcm.sendToDevice(token, payload);
 
     }catch(error){
      return error; 
     }
  });